# PRIVACY_NOTICE_TR.md

<!--
  CANONICAL REPO PATH: /docs/PRIVACY_NOTICE_TR.md
  DOCUMENT TYPE: Turkish privacy notice / Aydınlatma Metni draft
  OWNER / AUTHOR: Pod A — Product & Planning
  REVIEWER: Pod B — Architecture, Logic & Risk
  LEGAL REVIEW: Legal advisor required
  APPROVER: Kerem
  STATUS: v0.1 draft — includes P16 QR-linked live-bill / guest-flow wording; requires legal advisor sign-off and Kerem approval before use
  IMPLEMENTATION AUTHORITY: This document does NOT authorize Pod C, PWA implementation, live Selcafe reads, or pilot operation.
  DATA: Synthetic examples only. No real customer/staff/Selcafe row data.
-->

## Status

| Field | Value |
|---|---|
| Document | `PRIVACY_NOTICE_TR.md` |
| Scope | Turkish Aydınlatma Metni draft for Phase 1, including P16 QR-linked live-bill / guest flow |
| Current status | v0.1 draft — requires legal advisor sign-off, Pod B review where technical/data-flow claims are made, and Kerem approval |
| Implementation status | Does **not** authorize Pod C, live Selcafe reads, direct Selcafe writes, or pilot operation |
| Source issue | GitHub issue #133 |
| Legal sign-off | Required before use in PWA/pilot |
| Kerem approval | Required |

## Amaç ve Kapsam

Bu belge Adeks Platform için Türkçe Aydınlatma Metni taslağıdır. P16 kapsamında QR ile aktif oturuma bağlanma, canlı hesap görüntüleme, misafir akışı, indirim/kupon/puan gibi hesap bağlantılı işlemler ve sınırlı teknik kayıtlar için açıklama metni içerir.

Bu metin taslaktır. Hukuk danışmanı onayı ve Kerem onayı olmadan müşteri ekranında kullanılmamalıdır.

## Veri Sorumlusu

[REQUIRES LEGAL ADVISOR SIGN-OFF] [NEEDS KEREM APPROVAL]

Mevcut P16 kontrollü pilotu için veri sorumlusu:

> Adeks Bilişim Hizmetleri Ltd. Şti.

Bu pozisyon yalnızca mevcut tek şirketli pilot kurgusu için geçerlidir. Adeks Platform ileride başka kafe işletmecilerine sunulursa, ayrı bir platform şirketiyle işletilirse veya SaaS / çok kiracılı modele genişlerse veri sorumlusu / veri işleyen / ortak veri sorumlusu değerlendirmesi yeniden yapılmalıdır.

## İşlenen Kişisel Veriler

P16 QR ile canlı hesap / misafir akışı kapsamında aşağıdaki veri kategorileri işlenebilir:

| Veri kategorisi | Açıklama |
|---|---|
| Oturum / masa / bilgisayar bağlamı | QR ile bağlanılan aktif fiziksel oturumun sınırlı bağlam bilgisi |
| Canlı hesap bilgisi | Güncel hesap toplamı, hesap durumu, hizmet bağlamı |
| Yiyecek-içecek sipariş satırları | Aktif hesaptaki güncel ürün satırları, miktar ve tutar bilgileri |
| QR oturum bağlantı kayıtları | QR token durumu, oturum bağlantısı, zaman damgası, kullanım / süre dolumu / iptal durumu |
| İndirim doğrulama bilgileri | Adeks’e özel işlem tipi, tek kullanımlık rastgele kod, indirim tutarı, mutabakat durumu |
| Sınırlı teknik güvenlik kayıtları | Kötüye kullanım önleme, uyuşmazlık inceleme, denetim ve güvenlik amaçlı sınırlı meta veriler |
| Adeks hesap verileri | Yalnızca hesapla giriş yapıldığında indirim, kupon, puan ve hesap geçmişi için gerekli Adeks hesap bağlantıları |

## İşleme Amaçları

| Amaç | Açıklama |
|---|---|
| Hizmetin yürütülmesi | Müşterinin / oturum katılımcısının aktif hesabı ve güncel sipariş satırlarını görmesi |
| QR oturum bağlantısının güvenliği | QR bağlantısının tek kullanımlık, kısa süreli, oturuma bağlı ve iptal edilebilir yürütülmesi |
| İndirim doğrulama ve mutabakat | Kasiyer aracılığıyla Selcafe’ye yansıtılan Adeks indiriminin doğrulanması |
| Uyuşmazlık ve şikâyet yönetimi | Yanlış QR okutma, yanlış bağlantı, indirim uyuşmazlığı veya şikâyet durumlarının incelenmesi |
| Güvenlik ve kötüye kullanımın önlenmesi | Anormal QR denemeleri, kötüye kullanım, yetkisiz erişim ve işlem uyuşmazlıklarının tespiti |
| Hesap bağlantılı faydaların sunulması | Adeks hesabı ile kupon, indirim, puan ve hesap geçmişi özelliklerinin sağlanması |

## Hukuki Sebepler

[REQUIRES LEGAL ADVISOR SIGN-OFF]

| İşleme faaliyeti | Taslak hukuki sebep |
|---|---|
| QR ile aktif canlı hesabın gösterilmesi | KVKK m.5/2(c) — bir sözleşmenin kurulması veya ifasıyla doğrudan doğruya ilgili olması |
| Güncel toplam ve yiyecek-içecek satırlarının gösterilmesi | KVKK m.5/2(c) |
| QR güvenliği, kötüye kullanım önleme, kısa teknik kayıtlar | Meşru menfaat; hakların tesisi, kullanılması veya korunması |
| Uyuşmazlık, şikâyet, dolandırıcılık veya chargeback kanıtı | Hakların tesisi, kullanılması veya korunması |
| Mali / ticari / muhasebesel kayıtlar | Kanuni yükümlülük ve/veya hakların korunması; kayıt türüne göre ayrıca teyit gerekir |
| Opsiyonel pazarlama | Ayrı açık rıza / ayrı hukuki sebep modeli gerekir; P16 çekirdek canlı hesap görüntüleme kapsamı dışıdır |

Çekirdek QR ile canlı hesap görüntüleme için açık rıza kullanılmaz. Bu işlem, alınan kafe / bilgisayar / yiyecek-içecek hizmetinin yürütülmesi kapsamında değerlendirilir.

## QR ile Canlı Hesap / Misafir Akışı

[REQUIRES LEGAL ADVISOR SIGN-OFF] [NEEDS KEREM APPROVAL]

Adeks’te aktif bir bilgisayar, masa veya oturum ile telefonunuzu tek kullanımlık QR kod aracılığıyla eşleştirdiğinizde, Adeks Platform ilgili aktif oturuma ait sınırlı hesap bilgilerini gösterebilir. Bu bilgiler; oturum/masa/bilgisayar bağlamı, güncel hesap toplamı ve yiyecek-içecek sipariş satırları gibi hizmetin yürütülmesi için gerekli bilgilerle sınırlıdır.

Bu işlem, Adeks’te aldığınız bilgisayar, kafe ve yiyecek-içecek hizmetinin yürütülmesi kapsamında gerçekleştirilir. Misafir olarak canlı hesabı görüntülemek ve yiyecek-içecek siparişi vermek için Adeks hesabı açmanız zorunlu değildir.

QR ile canlı hesap görüntüleme akışında Adeks; Selcafe üye profil bilgilerini, üye numarasını, telefon/e-posta/adres bilgilerini, üye bakiyesini, puanlarını, geçmiş hesaplarını veya personel kimlik bilgilerini misafir ekranda göstermez.

Misafir akışında yalnızca ilgili fiziksel oturum / masa / bilgisayar için güncel aktif hesap gösterilir. Geçmiş hesaplar, başka hesaba aktarılmış / birleştirilmiş hesaplar veya genel üye hesap geçmişi misafir QR akışı üzerinden gösterilmez.

Şüpheli, hatalı veya uyuşmazlık içeren QR bağlantılarında personel bağlantıyı iptal edebilir ve süreç manuel olarak ele alınır.

## İndirim, Kupon, Puan ve Hesap Bağlantılı İşlemler

İndirim, kupon, puan veya hesap geçmişi gibi Adeks hesabına bağlı özelliklerden yararlanmak için Adeks hesabı gerekir.

Misafir akışında:

| Özellik | Misafir akışı |
|---|---|
| QR ile oturuma bağlanma | Uygun |
| Güncel aktif hesabı görüntüleme | Uygun |
| Güncel yiyecek-içecek satırlarını görüntüleme | Uygun |
| Yiyecek-içecek siparişi verip hesaba ekletme | Uygun |
| Misafir olarak uygulama içi ödeme | Uygun değil |
| İndirim / kupon / puan kullanımı | Adeks hesabı gerekir |
| Hesap bağlantılı geçmiş | Adeks hesabı gerekir |
| Cüzdan / sadakat işlemleri | Adeks hesabı gerekir |
| Pazarlama | Ayrı hukuki sebep / açık rıza modeli olmadan yapılmaz |

P16 kontrollü pilotunda misafir ödeme süreci yalnızca hesaba ekleme ve personel aracılı ödeme şeklindedir. Misafirler için uygulama içi ödeme yoktur.

## Saklama Süreleri

[REQUIRES LEGAL ADVISOR SIGN-OFF]

P16 kapsamındaki kayıtlar farklı saklama sürelerine tabidir. Canlı hesap gösterimi kalıcı olarak saklanmaz. Sipariş satırı görünürlüğü oturumla sınırlı tutulur ve kısa süreli teknik önbellek dışında kopyalanmaz. Güvenlik, uyuşmazlık ve indirim mutabakatı için sınırlı teknik kayıtlar ilgili saklama politikasında belirtilen sürelerle saklanabilir.

Saklama sürelerinin kanonik kaynağı:

- `DATA_RETENTION_POLICY.md`

## Aktarımlar ve Yurt Dışı Aktarım Durumu

[REQUIRES LEGAL ADVISOR SIGN-OFF] [REQUIRES POD B REVIEW]

Doğrudan yerel Selcafe okuması tek başına yurt dışı aktarım oluşturmaz. Ancak Adeks backend, veritabanı, loglama, izleme, hata takip, analitik, yedekleme, CDN/WAF, destek, hata ayıklama, yapay zekâ destekli destek araçları veya Selcafe veri replikasyonu P16 verilerini Türkiye dışına aktarıyorsa ayrıca yurt dışı aktarım değerlendirmesi gerekir.

Yurt dışı aktarım durumunun kanonik değerlendirme dosyası:

- `CROSS_BORDER_TRANSFER_ASSESSMENT.md`

Bu değerlendirme tamamlanmadan yurt dışı aktarım olmadığı varsayılmamalıdır.

## İlgili Kişi Hakları

İlgili kişiler KVKK kapsamındaki haklarını Adeks’e başvurarak kullanabilir. Detaylı başvuru süreci ayrı veri sahibi hakları süreciyle belirlenecektir.

[OPEN QUESTION] Veri sahibi hakları sürecinin kanonik dosyası henüz bu belge kapsamında tamamlanmamıştır.

## Açık Noktalar / Hukuki Onay Bekleyen Alanlar

| ID | Açık nokta | Sahip / rota |
|---|---|---|
| PN-P16-001 | Bu metnin hukuk danışmanı tarafından onaylanması | Legal advisor + Kerem |
| PN-P16-002 | P16 yurt dışı aktarım durumunun altyapı gerçeklerine göre belirlenmesi | Pod B + legal advisor + Kerem |
| PN-P16-003 | Selcafe tarafındaki indirim kaydının mali/ticari saklama sınıfının teyidi | Legal/accounting advisor + Kerem |
| PN-P16-004 | Misafir akışında yaş kısıtlı ürünlerin engellenmesi veya personel onayı süreci | Pod A + Pod B + legal advisor + Kerem |
| PN-P16-005 | Transfer/birleştirme durumlarında “güncel aktif hesap” tanımı | Pod A + Pod B + Kerem |

## Review Routing

| Review item | Required |
|---|---|
| Ready for commit | Yes — as v0.1 draft only |
| Ready for customer display | No |
| Requires legal advisor sign-off | Yes |
| Requires Pod B review | Yes, for data-flow/security/cross-border claims |
| Requires Kerem approval | Yes |
| Requires Pod C implementation | No |
| Requires Pod D review | Later only if customer-facing UX/notice display changes |

## Document History

| Version | Date | Author | Change |
|---|---|---|---|
| v0.1 draft | 2026-07-01 | Pod A | Initial Turkish privacy notice draft including P16 QR live-bill / guest-flow wording. Requires legal advisor sign-off and Kerem approval. |
