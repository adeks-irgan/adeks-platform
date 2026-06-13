#!/usr/bin/env python3
"""
check_internal_paths.py

Validates internal repo-path references in the PR body and in changed
markdown files against the branch HEAD file tree.

Checked path families (file references only — paths with a file extension):
  docs/...   /docs/...   .github/...   /.github/...   CLAUDE.md

Ignored:
  - HTTP/HTTPS URLs (stripped before scanning)
  - Fenced code blocks (``` or ~~~)
  - Paths with no file extension in the final segment (e.g. branch names)
  - Paths listed in rows marked 'planned' or 'missing' in
    docs/AGENT_CONTEXT_MANIFEST.md

Exit codes:
  0 — all referenced paths exist (or are excluded)
  1 — one or more broken references found
"""

from __future__ import annotations

import os
import re
import subprocess
import sys
from pathlib import Path
from typing import List, Optional, Set, Tuple

# ---------------------------------------------------------------------------
# Module-level repo root — overridable for tests
# ---------------------------------------------------------------------------

REPO_ROOT: Path = Path(os.environ.get("GITHUB_WORKSPACE", ".")).resolve()

# ---------------------------------------------------------------------------
# Regex: candidate internal path references
# ---------------------------------------------------------------------------

# Matches paths starting with the target families.
# Lookbehind (?<![a-zA-Z0-9_]) avoids mid-word matches.
# Character class allows: word chars, dot, hyphen, forward-slash.
_PATH_RE = re.compile(
    r"(?<![a-zA-Z0-9_])"
    r"(/?(?:docs|\.github)/[\w.\-/]+|CLAUDE\.md)"
)

_URL_RE = re.compile(r"https?://\S+")

# ---------------------------------------------------------------------------
# Core helpers
# ---------------------------------------------------------------------------


def _remove_urls(text: str) -> str:
    """Strip http/https URLs so their path segments are not matched."""
    return _URL_RE.sub("", text)


def _strip_path(raw: str) -> str:
    """Normalise a matched path: remove leading slash, anchor, trailing punctuation."""
    p = raw.lstrip("/")
    p = p.split("#")[0]
    p = p.rstrip(".,;:)'\">`\\")
    return p.strip()


def _has_file_extension(path: str) -> bool:
    """Return True if the final path segment has a file extension.

    This filter excludes branch names (e.g. docs/some-feature) and bare
    directory references from the check, avoiding common false positives.
    """
    last_segment = path.split("/")[-1]
    return "." in last_segment


def extract_paths(text: str) -> Set[str]:
    """Return normalised internal path references found in *text*.

    Skips fenced code blocks (``` / ~~~) and HTTP/HTTPS URLs.
    Retains inline-code references (single backtick) because they are
    legitimate file citations in this project's docs conventions.
    """
    paths: Set[str] = set()
    in_fence = False

    for line in text.splitlines():
        stripped = line.strip()
        if stripped.startswith("```") or stripped.startswith("~~~"):
            in_fence = not in_fence
            continue
        if in_fence:
            continue

        clean = _remove_urls(line)
        for m in _PATH_RE.finditer(clean):
            p = _strip_path(m.group(1))
            if p and _has_file_extension(p):
                paths.add(p)

    return paths


def load_manifest_exclusions(repo_root: Optional[Path] = None) -> Set[str]:
    """Parse docs/AGENT_CONTEXT_MANIFEST.md and return all path references
    found in rows whose File Status column contains 'planned' or 'missing'.

    These paths are excluded from the integrity check because the manifest
    intentionally tracks their lifecycle as not-yet-created files.
    """
    root = repo_root or REPO_ROOT
    manifest = root / "docs" / "AGENT_CONTEXT_MANIFEST.md"
    exclusions: Set[str] = set()

    if not manifest.exists():
        return exclusions

    for line in manifest.read_text(encoding="utf-8").splitlines():
        if not line.startswith("|"):
            continue
        cols = [c.strip() for c in line.split("|")]
        # Expected columns (0-indexed after split on |):
        #   0: ''  1: Task  2: Required Files  3: File Status  4+: rest
        if len(cols) < 5:
            continue
        file_status = cols[3].lower()
        if "planned" not in file_status and "missing" not in file_status:
            continue
        # Extract all path refs from the Required Files column
        clean = _remove_urls(cols[2])
        for m in _PATH_RE.finditer(clean):
            p = _strip_path(m.group(1))
            if p:
                exclusions.add(p)

    return exclusions


def get_changed_markdown_files(repo_root: Optional[Path] = None) -> List[str]:
    """Return .md files added/modified in this branch vs origin/main."""
    root = repo_root or REPO_ROOT
    try:
        out = subprocess.check_output(
            ["git", "diff", "--name-only", "--diff-filter=ACM", "origin/main...HEAD"],
            text=True,
            cwd=root,
            stderr=subprocess.DEVNULL,
        )
        return [f for f in out.splitlines() if f.endswith(".md")]
    except subprocess.CalledProcessError:
        return []


def check_paths(
    paths: Set[str],
    exclusions: Set[str],
    source: str,
    repo_root: Optional[Path] = None,
) -> List[Tuple[str, str]]:
    """Return (source, path) pairs for paths that are missing and not excluded."""
    root = repo_root or REPO_ROOT
    failures: List[Tuple[str, str]] = []
    for p in sorted(paths):
        if p in exclusions:
            continue
        if not (root / p).exists():
            failures.append((source, p))
    return failures


def run_check(
    pr_body: str = "",
    changed_md: Optional[List[str]] = None,
    repo_root: Optional[Path] = None,
) -> List[Tuple[str, str]]:
    """Run the full check. Returns list of (source, path) failures.

    Exposed as a function so tests can call it directly without subprocess.
    """
    root = repo_root or REPO_ROOT
    if changed_md is None:
        changed_md = get_changed_markdown_files(root)

    exclusions = load_manifest_exclusions(root)
    failures: List[Tuple[str, str]] = []

    if pr_body:
        paths = extract_paths(pr_body)
        failures.extend(check_paths(paths, exclusions, "PR body", root))

    for md_file in changed_md:
        full = root / md_file
        if not full.exists():
            continue
        text = full.read_text(encoding="utf-8")
        paths = extract_paths(text)
        failures.extend(check_paths(paths, exclusions, f"file:{md_file}", root))

    return failures


# ---------------------------------------------------------------------------
# Entry point
# ---------------------------------------------------------------------------


def main() -> None:
    pr_body = os.environ.get("PR_BODY", "")
    changed_md = get_changed_markdown_files()

    failures = run_check(pr_body=pr_body, changed_md=changed_md)

    if failures:
        print("\n❌  Internal path reference check FAILED\n")
        print("The following referenced paths do not exist on this branch:\n")
        for source, path in failures:
            print(f"  [{source}]  {path}")
        print(
            "\nFix or remove the broken references before merging.\n"
            "If the path is intentionally planned (not yet created), add it to\n"
            "docs/AGENT_CONTEXT_MANIFEST.md with status 'planned'.\n"
        )
        sys.exit(1)

    scanned: List[str] = (["PR body"] if pr_body else []) + list(changed_md)
    label = ", ".join(scanned) if scanned else "nothing to scan"
    print(f"✅  Internal path reference check passed.  Scanned: {label}")
    sys.exit(0)


if __name__ == "__main__":
    main()
