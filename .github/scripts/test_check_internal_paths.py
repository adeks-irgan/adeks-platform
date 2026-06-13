"""
Tests for check_internal_paths.py

Run with:  pytest .github/scripts/test_check_internal_paths.py -v
"""

from __future__ import annotations

import sys
from pathlib import Path

# Make the scripts directory importable
sys.path.insert(0, str(Path(__file__).parent))

import check_internal_paths as cip  # noqa: E402

# ---------------------------------------------------------------------------
# _strip_path
# ---------------------------------------------------------------------------


def test_strip_leading_slash():
    assert cip._strip_path("/docs/file.md") == "docs/file.md"


def test_strip_anchor():
    assert cip._strip_path("docs/file.md#section-6") == "docs/file.md"


def test_strip_trailing_period():
    assert cip._strip_path("docs/file.md.") == "docs/file.md"


def test_strip_trailing_comma():
    assert cip._strip_path("docs/file.md,") == "docs/file.md"


def test_strip_trailing_paren():
    assert cip._strip_path("docs/file.md)") == "docs/file.md"


def test_strip_combined():
    assert cip._strip_path("/docs/file.md#section.") == "docs/file.md"


# ---------------------------------------------------------------------------
# _has_file_extension
# ---------------------------------------------------------------------------


def test_has_extension_md():
    assert cip._has_file_extension("docs/PROJECT_METHODOLOGY.md") is True


def test_has_extension_yml():
    assert cip._has_file_extension(".github/workflows/ci.yml") is True


def test_no_extension_branch_name():
    assert cip._has_file_extension("docs/gov-cleanup-gov01-04") is False


def test_no_extension_bare_directory():
    assert cip._has_file_extension("docs/adr") is False


# ---------------------------------------------------------------------------
# extract_paths
# ---------------------------------------------------------------------------


def test_extract_bare_docs_path():
    paths = cip.extract_paths("See docs/PROJECT_METHODOLOGY.md for details.")
    assert "docs/PROJECT_METHODOLOGY.md" in paths


def test_extract_slash_prefix():
    paths = cip.extract_paths("See /docs/PROJECT_METHODOLOGY.md for details.")
    assert "docs/PROJECT_METHODOLOGY.md" in paths


def test_extract_github_path():
    paths = cip.extract_paths("Template at .github/PULL_REQUEST_TEMPLATE.md.")
    assert ".github/PULL_REQUEST_TEMPLATE.md" in paths


def test_extract_claude_md():
    paths = cip.extract_paths("See CLAUDE.md for Pod C instructions.")
    assert "CLAUDE.md" in paths


def test_extract_ignores_https_url():
    paths = cip.extract_paths(
        "See https://github.com/adeks-irgan/adeks-platform/blob/main/docs/NONEXISTENT.md"
    )
    assert "docs/NONEXISTENT.md" not in paths


def test_extract_ignores_fenced_code_block():
    text = "```\ngit add docs/nonexistent-file.md\n```"
    paths = cip.extract_paths(text)
    assert "docs/nonexistent-file.md" not in paths


def test_extract_finds_inline_code_path():
    paths = cip.extract_paths("See `docs/PROJECT_METHODOLOGY.md` for context.")
    assert "docs/PROJECT_METHODOLOGY.md" in paths


def test_extract_strips_anchor_from_link():
    paths = cip.extract_paths("[§6](docs/PROJECT_METHODOLOGY.md#section-6)")
    assert "docs/PROJECT_METHODOLOGY.md" in paths
    assert "docs/PROJECT_METHODOLOGY.md#section-6" not in paths


def test_extract_ignores_branch_name_no_extension():
    # Branch names like docs/gov-cleanup-gov01-04 have no file extension
    paths = cip.extract_paths("Branch: docs/gov-cleanup-gov01-04")
    assert "docs/gov-cleanup-gov01-04" not in paths


def test_extract_table_cell():
    line = "| docs/PROJECT_METHODOLOGY.md | exists |"
    paths = cip.extract_paths(line)
    assert "docs/PROJECT_METHODOLOGY.md" in paths


def test_extract_ignores_triple_tilde_fence():
    text = "~~~\ndocs/nonexistent.md\n~~~"
    paths = cip.extract_paths(text)
    assert "docs/nonexistent.md" not in paths


def test_extract_multiple_paths_in_one_line():
    line = "See docs/PROJECT_METHODOLOGY.md and docs/PROJECT_DECISION_INDEX.md."
    paths = cip.extract_paths(line)
    assert "docs/PROJECT_METHODOLOGY.md" in paths
    assert "docs/PROJECT_DECISION_INDEX.md" in paths


# ---------------------------------------------------------------------------
# load_manifest_exclusions — uses a synthetic repo root
# ---------------------------------------------------------------------------


def test_manifest_exclusions_planned_paths(tmp_path):
    """Paths in rows with 'planned' status are excluded."""
    docs = tmp_path / "docs"
    docs.mkdir()
    manifest = docs / "AGENT_CONTEXT_MANIFEST.md"
    manifest.write_text(
        "| Task | Required Files | File Status | Fallback | Pods | Review | Freshness |\n"
        "|---|---|---|---|---|---|---|\n"
        "| F&B | `/docs/MVP_SCOPE.md`; `/docs/BUSINESS_RULES.md` | planned | draft first | A | Pod B | Yes |\n"
        "| Auth | `/docs/PROJECT_METHODOLOGY.md`; `/docs/SECURITY_REVIEW.md` | mixed: methodology exists; security planned | stop | A,B,C | Pod B | Yes |\n"
    )
    exclusions = cip.load_manifest_exclusions(tmp_path)
    assert "docs/MVP_SCOPE.md" in exclusions
    assert "docs/BUSINESS_RULES.md" in exclusions
    # Auth row has 'planned' in status — all its paths should be excluded
    assert "docs/PROJECT_METHODOLOGY.md" in exclusions
    assert "docs/SECURITY_REVIEW.md" in exclusions


def test_manifest_exclusions_exists_rows_not_excluded(tmp_path):
    """Paths in rows with only 'exists' status are NOT excluded (they should be checked)."""
    docs = tmp_path / "docs"
    docs.mkdir()
    manifest = docs / "AGENT_CONTEXT_MANIFEST.md"
    manifest.write_text(
        "| Task | Required Files | File Status | Fallback | Pods | Review | Freshness |\n"
        "|---|---|---|---|---|---|---|\n"
        "| Wallet | `/docs/PROJECT_METHODOLOGY.md` | exists | n/a | A,B,C | Pod B + Kerem | Yes |\n"
    )
    exclusions = cip.load_manifest_exclusions(tmp_path)
    assert "docs/PROJECT_METHODOLOGY.md" not in exclusions


def test_manifest_missing_file_returns_empty(tmp_path):
    exclusions = cip.load_manifest_exclusions(tmp_path)
    assert exclusions == set()


# ---------------------------------------------------------------------------
# run_check integration — uses tmp_path as a synthetic repo root
# ---------------------------------------------------------------------------


def test_run_check_passes_existing_file(tmp_path):
    """A PR body referencing an existing file should produce no failures."""
    docs = tmp_path / "docs"
    docs.mkdir()
    (docs / "METHODOLOGY.md").write_text("# Methodology\n")

    failures = cip.run_check(
        pr_body="See docs/METHODOLOGY.md for context.",
        changed_md=[],
        repo_root=tmp_path,
    )
    assert failures == []


def test_run_check_fails_missing_file(tmp_path):
    """A PR body referencing a non-existent file should produce a failure."""
    (tmp_path / "docs").mkdir()

    failures = cip.run_check(
        pr_body="See docs/MISSING_FILE_XYZ.md for context.",
        changed_md=[],
        repo_root=tmp_path,
    )
    assert any("docs/MISSING_FILE_XYZ.md" == p for _, p in failures)


def test_run_check_ignores_url(tmp_path):
    """An HTTPS URL containing a docs path should not produce a failure."""
    (tmp_path / "docs").mkdir()

    failures = cip.run_check(
        pr_body="See https://github.com/example/repo/blob/main/docs/NONEXISTENT.md",
        changed_md=[],
        repo_root=tmp_path,
    )
    assert failures == []


def test_run_check_ignores_fenced_block_in_md_file(tmp_path):
    """A path inside a fenced code block in a changed .md file should be ignored."""
    docs = tmp_path / "docs"
    docs.mkdir()
    md = docs / "example.md"
    md.write_text("```\ngit add docs/not-a-real-file.md\n```\n")

    failures = cip.run_check(
        pr_body="",
        changed_md=["docs/example.md"],
        repo_root=tmp_path,
    )
    assert failures == []


def test_run_check_fails_missing_path_in_changed_md(tmp_path):
    """A changed .md file referencing a non-existent path should fail."""
    docs = tmp_path / "docs"
    docs.mkdir()
    md = docs / "guide.md"
    md.write_text("See docs/DOES_NOT_EXIST_FIXTURE.md for details.\n")

    failures = cip.run_check(
        pr_body="",
        changed_md=["docs/guide.md"],
        repo_root=tmp_path,
    )
    assert any("docs/DOES_NOT_EXIST_FIXTURE.md" == p for _, p in failures)


def test_run_check_exclusion_suppresses_planned_path(tmp_path):
    """A planned path in the manifest should not trigger a CI failure."""
    docs = tmp_path / "docs"
    docs.mkdir()
    manifest = docs / "AGENT_CONTEXT_MANIFEST.md"
    manifest.write_text(
        "| Task | Required Files | File Status | Fallback | Pods | Review | Freshness |\n"
        "|---|---|---|---|---|---|---|\n"
        "| F&B | `/docs/MVP_SCOPE.md` | planned | draft first | A | Pod B | Yes |\n"
    )
    # docs/MVP_SCOPE.md does not exist in tmp_path
    failures = cip.run_check(
        pr_body="See docs/MVP_SCOPE.md for scope.",
        changed_md=[],
        repo_root=tmp_path,
    )
    assert failures == [], f"Planned path should be excluded, got: {failures}"


def test_run_check_empty_pr_body_and_no_md(tmp_path):
    """No body, no changed files — should always pass."""
    failures = cip.run_check(pr_body="", changed_md=[], repo_root=tmp_path)
    assert failures == []


def test_run_check_claude_md_existing(tmp_path):
    """CLAUDE.md at repo root — if it exists, reference should pass."""
    (tmp_path / "CLAUDE.md").write_text("# Claude\n")

    failures = cip.run_check(
        pr_body="See CLAUDE.md for Pod C instructions.",
        changed_md=[],
        repo_root=tmp_path,
    )
    assert failures == []


def test_run_check_claude_md_missing(tmp_path):
    """CLAUDE.md at repo root — if it's missing, reference should fail."""
    failures = cip.run_check(
        pr_body="See CLAUDE.md for Pod C instructions.",
        changed_md=[],
        repo_root=tmp_path,
    )
    assert any("CLAUDE.md" == p for _, p in failures)
