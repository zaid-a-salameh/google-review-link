const fs = require('fs');
const path = require('path');

const BASE_DIR = path.resolve(__dirname, '..');
const L10N_DIR = path.join(BASE_DIR, 'flutter_app', 'lib', 'l10n');
const I18N_PATH = path.join(BASE_DIR, 'src', 'js', 'core', 'i18n.js');

// 1. Read existing i18n.js
const i18nSource = fs.readFileSync(I18N_PATH, 'utf8');

// 2. Parse current en and ar from i18nSource using Node VM context
const sandbox = {
    window: {},
    localStorage: { getItem() { return 'en'; }, setItem() {} }
};
const vm = require('vm');
vm.createContext(sandbox);
vm.runInContext(i18nSource, sandbox);

const originalI18N = sandbox.window.I18N;
if (!originalI18N || !originalI18N.en || !originalI18N.ar) {
    throw new Error('Failed to parse original en and ar from i18n.js');
}

console.log(`Successfully loaded original en (${Object.keys(originalI18N.en).length} keys) and ar (${Object.keys(originalI18N.ar).length} keys).`);

// 3. Marketing website translations for the 8 additional languages
const marketing = {
    de: {
        apkDownload: "Android-App herunterladen",
        docTitle: "Quick NFC | Schnelles NFC-Tool & 5-Sterne Google-Bewertungslinks",
        metaDesc: "Kostenloses Open-Source-NFC-Tool und Google Maps 5-Sterne-Bewertungslink-Generator. Schreibe NFC-Karten, WLAN-Tags, PIN-Sperren und QR-Codes.",
        appTitle: "Quick NFC",
        appSubtitle: "Schnelles NFC-Tool mit sofortiger Umwandlung in Google Maps-Bewertungslinks",
        navSupport: "Unterstützen",
        navApk: "APK herunterladen",
        navGithub: "GitHub",
        tagHowItWorks: "Ablauf",
        titleHowItWorks: "In 3 einfachen Schritten",
        subHowItWorks: "Erstelle mühelos Bewertungslinks und kontaktlose NFC-Karten in Sekundenschnelle",
        step1Title: "Link kopieren oder suchen",
        step1Desc: "Kopiere deinen Google Maps-Link oder suche direkt nach deinem Unternehmen.",
        step2Title: "Sofortige 5-Sterne-Umwandlung",
        step2Desc: "Der Link öffnet beim Kunden sofort das 5-Sterne-Bewertungsfenster.",
        step3Title: "QR drucken oder NFC schreiben",
        step3Desc: "Lade einen druckfertigen QR-Code herunter oder tippe eine NFC-Karte an.",
        tagFeatures: "Funktionen",
        titleFeatures: "Alles für NFC und Google-Bewertungen",
        subFeatures: "Einfache, leistungsstarke Tools für 5-Sterne-Bewertungen, WLAN-Karten und Hardware-Sicherheit",
        feat1Title: "Direkte 5-Sterne-Vorauswahl",
        feat1Desc: "Wandelt jeden Google Maps-Link in einen direkten Link um, der das 5-Sterne-Bewertungs-Popup automatisch öffnet.",
        feat2Title: "WLAN-NFC-Karten & Klonen",
        feat2Desc: "Programmiere kontaktlose WLAN-Karten für Gäste und Kunden oder klone bestehende Karten in Sekundenschnelle.",
        feat3Title: "Universelles NFC-Schreiben",
        feat3Desc: "Schreibe Bewertungs-Links, Websites und Menüs mit einem Fingertipp auf NTAG213, NTAG215 und NTAG216.",
        feat4Title: "PIN-Schutz & Entsperren",
        feat4Desc: "Schütze deine NFC-Karten mit einer 4-stelligen PIN vor Manipulation, mit vollständiger Entsperrung.",
        feat5Title: "Dauerhafte Hardware-Sperre",
        feat5Desc: "Sperre Karten unwiderruflich im Nur-Lese-Modus für manipulationssichere Aufsteller an öffentlichen Orten.",
        feat6Title: "100% Kostenlos & 10 Sprachen",
        feat6Desc: "Open-Source ohne Abonnements, Offline-Datenschutz, keine API-Schlüssel erforderlich und in 10 Sprachen.",
        tagFaq: "Wissensdatenbank",
        titleFaq: "Häufig gestellte Fragen",
        subFaq: "Alles Wissenswerte über Bewertungslinks, QR-Codes und kontaktlose NFC-Karten",
        faq1Q: "Wie erstelle ich einen direkten 5-Sterne-Google-Bewertungslink?",
        faq1A: "Suche im Tab 'Ort suchen' nach deinem Unternehmen oder füge deinen Maps-Link ein. Das Tool generiert einen direkten Link zur 5-Sterne-Bewertung.",
        faq2Q: "Welche NFC-Tags und Karten werden unterstützt?",
        faq2A: "Quick NFC unterstützt alle gängigen NTAG-Chips (NTAG213, NTAG215, NTAG216) sowie kompatible Sticker, Münzen, Schlüsselanhänger und PVC-Karten.",
        faq3Q: "Wie funktioniert das Einrichten und Klonen von WLAN-NFC-Karten?",
        faq3A: "Gib WLAN-Name und Passwort ein oder halte eine bestehende Karte an dein Smartphone. Halte eine leere Karte heran, um die Konfiguration zu schreiben.",
        faq4Q: "Kann ich meine Karten vor unbefugtem Überschreiben schützen?",
        faq4A: "Ja, du kannst eine 4-stellige PIN festlegen oder die Karte dauerhaft als Nur-Lese-Karte sperren.",
        faq5Q: "Kann ich hochauflösende QR-Codes herunterladen?",
        faq5A: "Ja! Klicke auf 'QR-Code', um sofort ein hochauflösendes PNG-Bild zum Drucken auf Tischen, Theken und Visitenkarten herunterzuladen.",
        faq6Q: "Ist Quick NFC völlig kostenlos und privat?",
        faq6A: "Ja, es ist 100% kostenlos und Open-Source unter der MIT-Lizenz. Es erfordert kein Benutzerkonto und funktioniert komplett offline.",
        footerTagline: "Schnelles NFC-Tool für direkte Google Maps-Bewertungslinks, WLAN-Karten und NFC-Programmierung.",
        footerApk: "Android APK",
        footerGithub: "GitHub Repository",
        footerBackToTop: "↑ Nach oben",
        footerCopyright: '© 2026 Entwickelt von <a href="https://github.com/zaid-a-salameh" target="_blank" rel="noopener noreferrer">Zaid Salameh</a>. MIT-Lizenz.'
    },
    es: {
        apkDownload: "Descargar app para Android",
        docTitle: "Quick NFC | Herramienta NFC y Enlaces de Reseñas de Google 5 Estrellas",
        metaDesc: "Herramienta NFC gratuita y de código abierto y generador de enlaces de reseñas de 5 estrellas de Google Maps. Graba tarjetas NFC, Wi-Fi, bloqueo PIN y códigos QR.",
        appTitle: "Quick NFC",
        appSubtitle: "Herramienta NFC rápida con conversión instantánea de enlaces de reseñas de Google Maps",
        navSupport: "Apoyar",
        navApk: "Obtener APK",
        navGithub: "GitHub",
        tagHowItWorks: "Flujo de trabajo",
        titleHowItWorks: "Cómo funciona en 3 simples pasos",
        subHowItWorks: "Genera enlaces de reseñas directas y tarjetas NFC al instante en pocos segundos",
        step1Title: "Copiar o buscar negocio",
        step1Desc: "Copia tu enlace de Google Maps o busca tu negocio directamente.",
        step2Title: "Conversión directa a 5 estrellas",
        step2Desc: "El enlace abre directamente la ventana de calificación de 5 estrellas para tus clientes.",
        step3Title: "Imprimir QR o programar NFC",
        step3Desc: "Descarga un código QR nítido o acerca una tarjeta NFC a tu teléfono.",
        tagFeatures: "Características",
        titleFeatures: "Todo lo que necesitas para NFC y reseñas",
        subFeatures: "Herramientas sencillas y potentes para reseñas de 5 estrellas, tarjetas Wi-Fi y seguridad de hardware",
        feat1Title: "Preselección directa de 5 estrellas",
        feat1Desc: "Convierte cualquier enlace de Google Maps en un enlace que abre automáticamente el diálogo de 5 estrellas.",
        feat2Title: "Tarjetas Wi-Fi NFC y clonación",
        feat2Desc: "Programa tarjetas Wi-Fi para invitados o lee y clona tarjetas existentes en segundos.",
        feat3Title: "Grabación universal NFC",
        feat3Desc: "Escribe enlaces de reseñas, sitios web y menús en chips NTAG213, NTAG215 y NTAG216 con un toque.",
        feat4Title: "Protección y desbloqueo por PIN",
        feat4Desc: "Configura un PIN de 4 dígitos para evitar modificaciones en espacios públicos, con desbloqueo reversible.",
        feat5Title: "Bloqueo permanente de hardware",
        feat5Desc: "Bloquea tarjetas en modo de solo lectura irreversible para exhibición pública a prueba de manipulaciones.",
        feat6Title: "100% Gratis y 10 idiomas",
        feat6Desc: "Código abierto sin suscripciones, privacidad sin conexión, sin claves de API y disponible en 10 idiomas.",
        tagFaq: "Preguntas frecuentes",
        titleFaq: "Preguntas frecuentes",
        subFaq: "Todo lo que necesitas saber sobre enlaces de reseñas, códigos QR y tarjetas NFC",
        faq1Q: "¿Cómo creo un enlace directo de reseña de 5 estrellas?",
        faq1A: "Busca tu negocio en la pestaña 'Buscar lugar' o pega tu enlace de Maps para generar el enlace directo.",
        faq2Q: "¿Qué chips y tarjetas NFC son compatibles?",
        faq2A: "Quick NFC es compatible con todos los chips NTAG estándar (NTAG213, NTAG215, NTAG216), pegatinas, llaveros y tarjetas PVC.",
        faq3Q: "¿Cómo funciona la configuración y clonación de tarjetas Wi-Fi?",
        faq3A: "Ingresa el nombre de red y contraseña o lee una tarjeta Wi-Fi existente, y luego grábala en una tarjeta nueva.",
        faq4Q: "¿Puedo proteger mis tarjetas contra modificaciones?",
        faq4A: "Sí, puedes asignar una clave PIN de 4 dígitos o aplicar un bloqueo de hardware permanente de solo lectura.",
        faq5Q: "¿Puedo generar y descargar códigos QR de alta resolución?",
        faq5A: "¡Sí! Haz clic en el botón de código QR para descargar una imagen PNG lista para imprimir.",
        faq6Q: "¿Quick NFC es totalmente gratuito y privado?",
        faq6A: "Sí, es 100% gratuito y de código abierto bajo la licencia MIT. No requiere cuenta y funciona sin conexión.",
        footerTagline: "Herramienta NFC rápida para enlaces directos de reseñas de Google Maps, tarjetas Wi-Fi y programación NFC.",
        footerApk: "APK de Android",
        footerGithub: "Repositorio GitHub",
        footerBackToTop: "↑ Volver arriba",
        footerCopyright: '© 2026 Desarrollado por <a href="https://github.com/zaid-a-salameh" target="_blank" rel="noopener noreferrer">Zaid Salameh</a>. Licencia MIT.'
    },
    fr: {
        apkDownload: "Télécharger l'application Android",
        docTitle: "Quick NFC | Outil NFC & Avis Google 5 Étoiles Directs",
        metaDesc: "Outil NFC open source gratuit et générateur de liens d'avis Google Maps 5 étoiles. Programmez cartes NFC, Wi-Fi, verrou PIN et QR codes.",
        appTitle: "Quick NFC",
        appSubtitle: "Outil NFC rapide avec conversion instantanée en lien d'avis Google Maps",
        navSupport: "Soutenir",
        navApk: "Obtenir l'APK",
        navGithub: "GitHub",
        tagHowItWorks: "Fonctionnement",
        titleHowItWorks: "Comment ça marche en 3 étapes",
        subHowItWorks: "Générez des liens d'avis directs et des cartes sans contact NFC en quelques secondes",
        step1Title: "Copier ou rechercher un lieu",
        step1Desc: "Copiez votre lien Google Maps ou recherchez directement votre établissement.",
        step2Title: "Conversion directe en 5 étoiles",
        step2Desc: "Le lien ouvre automatiquement la fenêtre d'évaluation 5 étoiles pour vos clients.",
        step3Title: "Imprimer le QR ou programmer NFC",
        step3Desc: "Téléchargez un code QR prêt à imprimer ou touchez une carte NFC avec votre téléphone.",
        tagFeatures: "Fonctionnalités",
        titleFeatures: "Tout ce dont vous avez besoin pour le NFC et les avis",
        subFeatures: "Outils simples et puissants pour avis 5 étoiles, cartes Wi-Fi et sécurité matérielle",
        feat1Title: "Présélection directe 5 étoiles",
        feat1Desc: "Convertit tout lien Google Maps en un lien qui ouvre directement la notation 5 étoiles.",
        feat2Title: "Cartes Wi-Fi NFC et clonage",
        feat2Desc: "Programmez des cartes Wi-Fi pour vos invités ou lisez et clonez des cartes existantes en quelques secondes.",
        feat3Title: "Écriture NFC universelle",
        feat3Desc: "Écrivez des liens d'avis, sites web et menus sur NTAG213, NTAG215 et NTAG216 d'un simple geste.",
        feat4Title: "Protection par code PIN",
        feat4Desc: "Définissez un code PIN à 4 chiffres pour empêcher toute modification intempestive en public.",
        feat5Title: "Verrouillage matériel permanent",
        feat5Desc: "Verrouillez les cartes en mode lecture seule irréversible pour un affichage public inviolable.",
        feat6Title: "100% Gratuit et en 10 langues",
        feat6Desc: "Open-source sans abonnement, respect total de la vie privée, sans clé API et disponible en 10 langues.",
        tagFaq: "FAQ",
        titleFaq: "Foire aux questions",
        subFaq: "Tout ce que vous devez savoir sur les liens d'avis, codes QR et cartes sans contact NFC",
        faq1Q: "Comment créer un lien d'avis 5 étoiles direct ?",
        faq1A: "Recherchez votre établissement dans l'onglet 'Rechercher un lieu' ou collez votre lien Google Maps.",
        faq2Q: "Quels types de badges et puces NFC sont pris en charge ?",
        faq2A: "Quick NFC prend en charge toutes les puces NTAG standard (NTAG213, NTAG215, NTAG216), stickers et cartes PVC.",
        faq3Q: "Comment fonctionne la configuration Wi-Fi NFC ?",
        faq3A: "Saisissez les identifiants Wi-Fi ou lisez une carte existante, puis touchez une carte NFC pour la programmer.",
        faq4Q: "Puis-je protéger mes cartes contre toute réécriture ?",
        faq4A: "Oui, vous pouvez verrouiller la carte par code PIN à 4 chiffres ou appliquer un verrou matériel permanent.",
        faq5Q: "Puis-je télécharger un code QR haute résolution ?",
        faq5A: "Oui ! Cliquez sur le bouton QR code pour télécharger une image PNG prête à l'impression.",
        faq6Q: "Quick NFC est-il gratuit et confidentiel ?",
        faq6A: "Oui, 100% gratuit et open source sous licence MIT, sans compte requis et fonctionnant hors ligne.",
        footerTagline: "Outil NFC rapide pour avis Google Maps 5 étoiles directs, cartes Wi-Fi et programmation sans contact.",
        footerApk: "APK Android",
        footerGithub: "Dépôt GitHub",
        footerBackToTop: "↑ Haut de page",
        footerCopyright: '© 2026 Développé par <a href="https://github.com/zaid-a-salameh" target="_blank" rel="noopener noreferrer">Zaid Salameh</a>. Licence MIT.'
    },
    hi: {
        apkDownload: "एंड्रॉइड ऐप डाउनलोड करें",
        docTitle: "Quick NFC | तेज़ एनएफसी टूल और Google 5-स्टार समीक्षा लिंक",
        metaDesc: "मुफ़्त और ओपन-सोर्स एनएफसी टूल और गूगल मैप्स 5-स्टार समीक्षा लिंक जनरेटर। एनएफसी कार्ड, वाई-फाई और क्यूआर कोड बनाएं।",
        appTitle: "Quick NFC",
        appSubtitle: "त्वरित गूगल मैप्स समीक्षा लिंक और संपर्क रहित एनएफसी टूल",
        navSupport: "समर्थन करें",
        navApk: "APK डाउनलोड",
        navGithub: "GitHub",
        tagHowItWorks: "कार्यप्रणाली",
        titleHowItWorks: "3 आसान चरणों में काम करता है",
        subHowItWorks: "ग्राहकों के लिए सीधे समीक्षा लिंक और एनएफसी कार्ड सेकंडों में बनाएं",
        step1Title: "लिंक कॉपी करें या खोजें",
        step1Desc: "अपना Google Maps लिंक कॉपी करें या सीधे अपने व्यवसाय का नाम खोजें।",
        step2Title: "तुरंत 5-स्टार में परिवर्तन",
        step2Desc: "लिंक सीधे ग्राहकों के लिए 5-स्टार रेटिंग विंडो खोलता है।",
        step3Title: "QR प्रिंट करें या NFC लिखें",
        step3Desc: "उच्च गुणवत्ता वाला QR कोड डाउनलोड करें या NFC कार्ड पर फोन टच करें।",
        tagFeatures: "सुविधाएं",
        titleFeatures: "NFC और समीक्षाओं के लिए सब कुछ",
        subFeatures: "5-स्टार समीक्षाओं, वाई-फाई कार्ड और हार्डवेयर सुरक्षा के लिए शक्तिशाली टूल",
        feat1Title: "सीधा 5-स्टार चयन",
        feat1Desc: "किसी भी मैप्स लिंक को सीधे 5-स्टार पॉपअप लिंक में बदलता है।",
        feat2Title: "वाई-फाई एनएफसी कार्ड और क्लोनिंग",
        feat2Desc: "मेहमानों के लिए वाई-फाई कार्ड प्रोग्राम करें या मौजूदा कार्ड क्लोन करें।",
        feat3Title: "सार्वभौमिक एनएफसी लेखन",
        feat3Desc: "NTAG213, NTAG215 और NTAG216 चिप्स पर एक टैप से लिंक लिखें।",
        feat4Title: "पिन सुरक्षा और अनलॉक",
        feat4Desc: "छेड़छाड़ रोकने के लिए 4 अंकों का पिन सेट करें, जिसे कभी भी अनलॉक किया जा सकता है।",
        feat5Title: "स्थायी हार्डवेयर लॉक",
        feat5Desc: "सार्वजनिक स्थानों के लिए कार्ड को हमेशा के लिए केवल-पढ़ने योग्य मोड में लॉक करें।",
        feat6Title: "100% मुफ़्त और 10 भाषाएं",
        feat6Desc: "बिना किसी सदस्यता या विज्ञापन के, पूर्ण गोपनीयता और 10 भाषाओं में उपलब्ध।",
        tagFaq: "सामान्य प्रश्न",
        titleFaq: "अक्सर पूछे जाने वाले प्रश्न",
        subFaq: "गूगल समीक्षा लिंक, क्यूआर कोड और संपर्क रहित एनएफसी कार्ड के बारे में सब कुछ",
        faq1Q: "मैं सीधा 5-स्टार Google समीक्षा लिंक कैसे बनाऊं?",
        faq1A: "व्यवसाय खोजें टैब में नाम टाइप करें या अपना लिंक पेस्ट करें। टूल सीधा 5-स्टार लिंक बना देगा।",
        faq2Q: "कौन से NFC टैग और कार्ड समर्थित हैं?",
        faq2A: "Quick NFC सभी मानक NTAG चिप्स (NTAG213, NTAG215, NTAG216), स्टिकर और पीवीसी कार्ड का समर्थन करता है।",
        faq3Q: "वाई-फाई कार्ड कैसे सेट और क्लोन करें?",
        faq3A: "वाई-फाई विवरण दर्ज करें या मौजूदा कार्ड पढ़ें, फिर नए एनएफसी कार्ड पर टच करके सेव करें।",
        faq4Q: "क्या मैं अपने कार्ड को सुरक्षित कर सकता हूं?",
        faq4A: "हाँ, आप 4 अंकों का पिन पासवर्ड सेट कर सकते हैं या स्थायी हार्डवेयर लॉक लगा सकते हैं।",
        faq5Q: "क्या मैं उच्च-रिज़ॉल्यूशन क्यूआर कोड डाउनलोड कर सकता हूं?",
        faq5A: "हाँ! टेबल और बिल पर प्रिंट करने के लिए तुरंत पीएनजी इमेज डाउनलोड करें।",
        faq6Q: "क्या Quick NFC पूरी तरह मुफ़्त और सुरक्षित है?",
        faq6A: "हाँ, यह एमआईटी लाइसेंस के तहत 100% मुफ़्त और ओपन-सोर्स है और ऑफलाइन काम करता है।",
        footerTagline: "गूगल मैप्स 5-स्टार समीक्षा लिंक और एनएफसी कार्ड प्रबंधन टूल।",
        footerApk: "एंड्रॉइड APK",
        footerGithub: "GitHub रिपॉजिटरी",
        footerBackToTop: "↑ शीर्ष पर जाएं",
        footerCopyright: '© 2026 विकसित किया गया <a href="https://github.com/zaid-a-salameh" target="_blank" rel="noopener noreferrer">Zaid Salameh</a> द्वारा। MIT लाइसेंस।'
    },
    ja: {
        apkDownload: "Androidアプリをダウンロード",
        docTitle: "Quick NFC | 高速NFCツール＆Googleマップ星5レビューリンク",
        metaDesc: "完全無料・オープンソースのNFCツール＆Googleマップ星5評価直リンク作成ツール。NFCカード書き込み、Wi-Fi共有、PIN保護、QRコード生成。",
        appTitle: "Quick NFC",
        appSubtitle: "Googleマップの星5レビューリンクとNFCカードを瞬時に作成",
        navSupport: "支援する",
        navApk: "APKを入手",
        navGithub: "GitHub",
        tagHowItWorks: "使い方",
        titleHowItWorks: "簡単3ステップで完了",
        subHowItWorks: "お客様が迷わず星5評価できる直リンクとNFCカードを数秒で作成",
        step1Title: "リンクをコピーまたは検索",
        step1Desc: "Googleマップの共有リンクをコピーするか、店舗名を直接検索します。",
        step2Title: "星5評価直リンクへ自動変換",
        step2Desc: "リンクを開くだけで自動的に星5評価ダイアログが起動します。",
        step3Title: "QR印刷またはNFC書き込み",
        step3Desc: "印刷用QRコードを保存するか、NFCカードにタッチして即座に書き込みます。",
        tagFeatures: "主な機能",
        titleFeatures: "NFCとレビューに必要なすべてを搭載",
        subFeatures: "星5レビュー促進、Wi-Fiカード作成、ハードウェア保護のための強力ツール",
        feat1Title: "星5評価の直接選択",
        feat1Desc: "お客様が地図内を探す手間なく、星5つが選択された投稿画面を開きます。",
        feat2Title: "Wi-Fi NFCカード作成＆複製",
        feat2Desc: "スマホをかざすだけで接続できるWi-Fiカードを作成・複製できます。",
        feat3Title: "標準NFCタグへ簡単書き込み",
        feat3Desc: "NTAG213、NTAG215、NTAG216等の汎用NFCチップに1タップで書き込み可能。",
        feat4Title: "4桁PIN保護＆解除",
        feat4Desc: "店頭設置時の改ざん防止用にPINパスワードを設定可能。いつでもロック解除できます。",
        feat5Title: "恒久ハードウェアロック",
        feat5Desc: "公共の場でも絶対に書き換えられない読み取り専用モードへ永久固定可能。",
        feat6Title: "完全無料＆10言語対応",
        feat6Desc: "広告・課金なし、オフライン動作、APIキー不要、10言語のネイティブ対応。",
        tagFaq: "よくある質問",
        titleFaq: "よくあるご質問",
        subFaq: "Googleレビュー直リンク、QRコード、NFC非接触カードに関するFAQ",
        faq1Q: "星5レビューの直リンクはどうやって作りますか？",
        faq1A: "「場所を検索」タブで店舗名を検索するか、Googleマップのリンクを貼り付けるだけで自動生成されます。",
        faq2Q: "どのNFCチップやカードに対応していますか？",
        faq2A: "一般的なNTAGシリーズ（NTAG213、NTAG215、NTAG216）や各種NFCステッカー、PVCカードに対応しています。",
        faq3Q: "Wi-Fiカードの作成や複製はどう動きますか？",
        faq3A: "SSIDとパスワードを入力するか既存カードを読み取り、空のNFCカードにタッチして書き込みます。",
        faq4Q: "カードが勝手に書き換えられないよう保護できますか？",
        faq4A: "はい、4桁のPINパスワード保護または恒久的なハードウェア読み取り専用ロックが設定できます。",
        faq5Q: "高解像度のQRコードをダウンロードできますか？",
        faq5A: "はい！卓上スタンドやメニュー、ショップカード印刷に適した高画質PNGを保存できます。",
        faq6Q: "Quick NFCは本当に完全無料で利用できますか？",
        faq6A: "はい、MITライセンスの完全オープンソースです。アカウント登録もAPIキーも不要です。",
        footerTagline: "Googleマップ星5レビュー直リンク作成、Wi-Fi共有、NFCカード書き込みツール。",
        footerApk: "Android APK",
        footerGithub: "GitHub リポジトリ",
        footerBackToTop: "↑ トップへ戻る",
        footerCopyright: '© 2026 Developed by <a href="https://github.com/zaid-a-salameh" target="_blank" rel="noopener noreferrer">Zaid Salameh</a>. MIT License.'
    },
    pt: {
        apkDownload: "Baixar aplicativo Android",
        docTitle: "Quick NFC | Ferramenta NFC e Links de Avaliação 5 Estrelas",
        metaDesc: "Ferramenta NFC gratuita e de código aberto e gerador de links de avaliação 5 estrelas do Google Maps. Grave cartões NFC, Wi-Fi, senha PIN e QR codes.",
        appTitle: "Quick NFC",
        appSubtitle: "Ferramenta NFC rápida com conversão instantânea de links de avaliação do Google Maps",
        navSupport: "Apoiar",
        navApk: "Baixar APK",
        navGithub: "GitHub",
        tagHowItWorks: "Como funciona",
        titleHowItWorks: "Em 3 passos simples",
        subHowItWorks: "Crie links de avaliação direta e cartões NFC sem esforço em segundos",
        step1Title: "Copiar ou buscar local",
        step1Desc: "Copie o link do Google Maps ou busque seu negócio diretamente pelo nome.",
        step2Title: "Conversão direta para 5 estrelas",
        step2Desc: "O link abre automaticamente a caixa de avaliação com 5 estrelas para os clientes.",
        step3Title: "Imprimir QR ou gravar NFC",
        step3Desc: "Baixe um QR Code nítido ou encoste um cartão NFC no celular para programar.",
        tagFeatures: "Recursos",
        titleFeatures: "Tudo o que você precisa para NFC e avaliações",
        subFeatures: "Ferramentas práticas e poderosas para avaliações 5 estrelas, cartões Wi-Fi e proteção",
        feat1Title: "Pré-seleção direta de 5 estrelas",
        feat1Desc: "Converte links do Google Maps em um link direto que abre a tela de 5 estrelas sem buscas extras.",
        feat2Title: "Cartões Wi-Fi NFC e clonagem",
        feat2Desc: "Programe cartões de Wi-Fi para clientes ou leia e clone cartões existentes em segundos.",
        feat3Title: "Gravação universal em NFC",
        feat3Desc: "Grave links de avaliação, sites e cardápios em chips NTAG213, NTAG215 e NTAG216 com um toque.",
        feat4Title: "Proteção por PIN e desbloqueio",
        feat4Desc: "Defina uma senha PIN de 4 dígitos para impedir alterações indevidas em locais públicos.",
        feat5Title: "Bloqueio permanente de hardware",
        feat5Desc: "Trave os cartões em modo somente leitura irreversível para máxima segurança em vitrines e balcões.",
        feat6Title: "100% Gratuito e em 10 idiomas",
        feat6Desc: "Código aberto sem assinaturas, privacidade offline, sem chaves de API e disponível em 10 idiomas.",
        tagFaq: "Perguntas frequentes",
        titleFaq: "Dúvidas frequentes",
        subFaq: "Tudo o que você precisa saber sobre links de avaliação, QR codes e cartões NFC",
        faq1Q: "Como criar um link direto de avaliação 5 estrelas?",
        faq1A: "Busque seu estabelecimento na aba 'Buscar local' ou cole o link do Maps para gerar a URL direta.",
        faq2Q: "Quais tipos de tags e cartões NFC são suportados?",
        faq2A: "O Quick NFC suporta todos os chips NTAG comuns (NTAG213, NTAG215, NTAG216), adesivos e cartões PVC.",
        faq3Q: "Como funciona a configuração de cartões de Wi-Fi?",
        faq3A: "Digite o nome da rede e a senha ou leia um cartão existente, depois encoste o novo cartão para gravar.",
        faq4Q: "Posso proteger meus cartões contra regravação?",
        faq4A: "Sim, você pode definir uma senha PIN de 4 dígitos ou aplicar o bloqueio definitivo de hardware.",
        faq5Q: "Posso baixar um QR Code em alta resolução?",
        faq5A: "Sim! Clique no botão de QR Code para baixar uma imagem PNG nítida e pronta para impressão.",
        faq6Q: "O Quick NFC é realmente gratuito e privativo?",
        faq6A: "Sim, 100% gratuito e de código aberto sob licença MIT. Funciona offline sem exigir cadastro.",
        footerTagline: "Ferramenta NFC rápida para links diretos de avaliação do Google Maps, cartões Wi-Fi e NFC.",
        footerApk: "APK Android",
        footerGithub: "Repositório GitHub",
        footerBackToTop: "↑ Voltar ao topo",
        footerCopyright: '© 2026 Desenvolvido por <a href="https://github.com/zaid-a-salameh" target="_blank" rel="noopener noreferrer">Zaid Salameh</a>. Licença MIT.'
    },
    ru: {
        apkDownload: "Скачать приложение для Android",
        docTitle: "Quick NFC | Быстрый NFC инструмент и ссылки на отзывы Google 5 звезд",
        metaDesc: "Бесплатный инструмент с открытым исходным кодом для генерации прямых ссылок на отзывы Google Maps 5 звезд, записи NFC-карт и Wi-Fi.",
        appTitle: "Quick NFC",
        appSubtitle: "Быстрый NFC инструмент с мгновенной генерацией ссылок на отзывы Google Maps",
        navSupport: "Поддержать",
        navApk: "Скачать APK",
        navGithub: "GitHub",
        tagHowItWorks: "Как это работает",
        titleHowItWorks: "В 3 простых шага",
        subHowItWorks: "Создавайте ссылки для отзывов и бесконтактные NFC-карты за считанные секунды",
        step1Title: "Скопируйте или найдите место",
        step1Desc: "Скопируйте ссылку Google Maps или найдите ваше заведение по названию.",
        step2Title: "Мгновенная ссылка на 5 звезд",
        step2Desc: "Ссылка сразу открывает окно для выставления 5 звезд без лишних шагов.",
        step3Title: "Печать QR или запись на NFC",
        step3Desc: "Скачайте качественный QR-код для печати или запишите данные на NFC-карту.",
        tagFeatures: "Возможности",
        titleFeatures: "Все необходимое для NFC и отзывов",
        subFeatures: "Простые и мощные инструменты для 5-звездочных отзывов, карт Wi-Fi и защиты",
        feat1Title: "Прямой выбор 5 звезд",
        feat1Desc: "Превращает ссылку на место в прямую ссылку с уже выбранными 5 звездами.",
        feat2Title: "NFC-карты Wi-Fi и клонирование",
        feat2Desc: "Программируйте карты Wi-Fi для гостей или клонируйте существующие за секунды.",
        feat3Title: "Универсальная запись на NFC",
        feat3Desc: "Записывайте ссылки на отзывы, сайты и меню на чипы NTAG213, NTAG215 и NTAG216 в одно касание.",
        feat4Title: "Защита PIN-кодом и разблокировка",
        feat4Desc: "Установите 4-значный PIN для защиты от перезаписи в общественных местах с возможностью снятия защиты.",
        feat5Title: "Постоянная аппаратная блокировка",
        feat5Desc: "Заблокируйте карту в режиме только для чтения навсегда для максимальной безопасности на витринах.",
        feat6Title: "100% Бесплатно и 10 языков",
        feat6Desc: "Открытый исходный код без подписок, оффлайн-приватность, без ключей API и на 10 языках мира.",
        tagFaq: "База знаний",
        titleFaq: "Часто задаваемые вопросы",
        subFaq: "Все о ссылках на отзывы, QR-кодах и бесконтактных картах NFC",
        faq1Q: "Как создать прямую ссылку на отзыв 5 звезд в Google?",
        faq1A: "Найдите заведение на вкладке 'Поиск места' или вставьте ссылку Google Maps для мгновенного создания.",
        faq2Q: "Какие NFC-чипы и карты поддерживаются?",
        faq2A: "Quick NFC поддерживает все стандартные чипы серии NTAG (NTAG213, NTAG215, NTAG216), наклейки и пластиковые карты.",
        faq3Q: "Как работает создание и копирование карт Wi-Fi?",
        faq3A: "Введите имя сети и пароль или считайте готовую карту, затем коснитесь новой карты для записи.",
        faq4Q: "Можно ли защитить карты от перезаписи?",
        faq4A: "Да, вы можете задать 4-значный PIN-код или включить постоянную аппаратную защиту от записи.",
        faq5Q: "Можно ли скачать качественный QR-код?",
        faq5A: "Да! Нажмите кнопку QR-кода, чтобы получить четкое изображение PNG для печати на столах и визитках.",
        faq6Q: "Quick NFC действительно бесплатен и конфиденциален?",
        faq6A: "Да, 100% бесплатно по лицензии MIT. Приложение не требует регистрации и работает полностью оффлайн.",
        footerTagline: "Быстрый NFC инструмент для прямых ссылок на отзывы Google Maps и карт Wi-Fi.",
        footerApk: "Android APK",
        footerGithub: "Репозиторий GitHub",
        footerBackToTop: "↑ Наверх",
        footerCopyright: '© 2026 Разработано <a href="https://github.com/zaid-a-salameh" target="_blank" rel="noopener noreferrer">Zaid Salameh</a>. Лицензия MIT.'
    },
    zh: {
        apkDownload: "下载 Android 客户端",
        docTitle: "Quick NFC | 极速 NFC 工具与 Google 地图 5 星好评直达链接",
        metaDesc: "完全免费、开源的 NFC 工具与 Google 地图 5 星好评直达链接生成器。支持 NFC 卡片烧录、Wi-Fi 触碰连接、PIN 密码锁与高清二维码。",
        appTitle: "Quick NFC",
        appSubtitle: "极速 NFC 工具与 Google 地图 5 星好评直达链接生成器",
        navSupport: "支持项目",
        navApk: "获取 APK",
        navGithub: "GitHub",
        tagHowItWorks: "工作流程",
        titleHowItWorks: "简单 3 步即可完成",
        subHowItWorks: "轻松生成无障碍好评链接与免密触碰 NFC 卡片",
        step1Title: "复制链接或搜索地点",
        step1Desc: "复制您的 Google 地图商户链接，或直接在应用中输入名称搜索地点。",
        step2Title: "自动转为 5 星好评直达",
        step2Desc: "该链接会自动弹出 5 星好评窗口，方便客户即刻评分无需在地图中漫游。",
        step3Title: "打印二维码或写入 NFC",
        step3Desc: "下载高清打印用二维码，或将手机轻贴 NFC 卡片进行一键烧录。",
        tagFeatures: "特色功能",
        titleFeatures: "NFC 与客户好评所需的一切功能",
        subFeatures: "专为 5 星评价转化、Wi-Fi 卡片与防篡改硬件安全设计的强大工具",
        feat1Title: "直接预设 5 星评分",
        feat1Desc: "将任意 Google 地图链接转换为直达链接，打开即自动呈现 5 星打分窗口。",
        feat2Title: "Wi-Fi NFC 卡片与克隆",
        feat2Desc: "制作触碰即连的访客 Wi-Fi 卡片，或在几秒钟内快速读取并克隆现有卡片。",
        feat3Title: "通用 NFC 卡片写入",
        feat3Desc: "轻触即可将好评链接、官网及菜单写入标准 NTAG213、NTAG215 和 NTAG216 芯片。",
        feat4Title: "4 位 PIN 码保护与解锁",
        feat4Desc: "设置 4 位 PIN 码以防公开场所卡片被他人篡改覆盖，并随时支持可逆解锁。",
        feat5Title: "永久硬件只读锁",
        feat5Desc: "将卡片永久锁定为不可逆的硬件只读模式，确保在公共展台使用万无一失。",
        feat6Title: "100% 免费开源 & 10 种语言",
        feat6Desc: "无广告、无订阅、零追踪、离线可用，原生支持全球 10 种主流语言。",
        tagFaq: "常见问题",
        titleFaq: "常见问题解答",
        subFaq: "关于 Google 好评链接、二维码与 NFC 触碰卡片的一切须知",
        faq1Q: "如何创建 Google 地图 5 星好评直达链接？",
        faq1A: "在“搜索地点”标签中输入商户名称，或直接粘贴 Google 地图分享链接，系统将自动生成直达评分链接。",
        faq2Q: "支持哪些类型的 NFC 芯片和卡片？",
        faq2A: "Quick NFC 支持市面所有标准 NTAG 芯片（NTAG213、NTAG215、NTAG216）以及兼容的滴胶卡、钥匙扣和 PVC 卡片。",
        faq3Q: "Wi-Fi NFC 卡片如何设置与克隆？",
        faq3A: "输入 Wi-Fi 名称和密码，或者先触碰读取一张现有卡片，然后贴近新卡片即可烧录。",
        faq4Q: "如何防止卡片被他人覆盖修改？",
        faq4A: "您可以为卡片设置 4 位 PIN 码保护，或者直接进行永久硬件只读锁死。",
        faq5Q: "可以下载高清打印二维码吗？",
        faq5A: "可以！点击“二维码”按钮即可生成清晰的高清 PNG 图像，适合打印在台卡、收银台和菜单上。",
        faq6Q: "Quick NFC 真的完全免费并且安全吗？",
        faq6A: "是的，基于 MIT 许可 100% 免费开源，无需注册账号，无需 API 密钥，离线也能安心使用。",
        footerTagline: "极速 Google 地图 5 星评价直达、Wi-Fi 触碰卡片与 NFC 烧录工具。",
        footerApk: "Android 安装包 (APK)",
        footerGithub: "GitHub 源码仓库",
        footerBackToTop: "↑ 返回顶部",
        footerCopyright: '© 2026 由 <a href="https://github.com/zaid-a-salameh" target="_blank" rel="noopener noreferrer">Zaid Salameh</a> 开发。遵循 MIT 开源许可。'
    }
};

const extraWebStrings = {
    de: {
        searchStep1: "Unternehmensnamen eingeben & 'Auf Maps suchen' klicken",
        searchStep2: "'Teilen' klicken & Link in Google Maps kopieren",
        searchStep3: "Unten auf 'Automatisch einfügen & umwandeln' klicken!",
        btnLaunchMaps: "Auf Google Maps suchen ↗",
        btnAutoPasteConvert: "Automatisch einfügen & umwandeln",
        apiKeyConnected: "Google Maps-Autovervollständigung aktiv",
        apiKeyAuthError: "Fehler bei der API-Schlüssel-Authentifizierung",
        apiKeyNotSet: "Maps API konfigurieren / Demo-Schlüssel",
        btnKeyConfigure: "API-Schlüssel",
        gmpKeyTitle: "Google Maps-Suchschlüssel",
        btnKeySave: "Speichern & Verbinden",
        btnKeyRemove: "Schlüssel entfernen",
        toastKeySaved: "API-Schlüssel gespeichert. Verbindung wird hergestellt...",
        toastKeyRemoved: "API-Schlüssel entfernt"
    },
    es: {
        searchStep1: "Escribe el nombre del negocio y pulsa 'Buscar en Maps'",
        searchStep2: "Pulsa 'Compartir' y copia el enlace en Google Maps",
        searchStep3: "¡Pulsa 'Pegar automáticamente y convertir' abajo!",
        btnLaunchMaps: "Buscar en Google Maps ↗",
        btnAutoPasteConvert: "Pegar automáticamente y convertir",
        apiKeyConnected: "Autocompletado de Google Maps activo",
        apiKeyAuthError: "Error de autenticación de clave de API",
        apiKeyNotSet: "Configurar API de Maps / Clave Demo",
        btnKeyConfigure: "Clave API",
        gmpKeyTitle: "Clave de búsqueda de Google Maps",
        btnKeySave: "Guardar y conectar",
        btnKeyRemove: "Eliminar clave",
        toastKeySaved: "Clave de API guardada. Conectando...",
        toastKeyRemoved: "Clave de API eliminada"
    },
    fr: {
        searchStep1: "Entrez le nom de l'établissement et cliquez sur 'Rechercher sur Maps'",
        searchStep2: "Cliquez sur 'Partager' et copiez le lien sur Google Maps",
        searchStep3: "Cliquez sur 'Coller auto & convertir' ci-dessous !",
        btnLaunchMaps: "Rechercher sur Google Maps ↗",
        btnAutoPasteConvert: "Coller auto & convertir",
        apiKeyConnected: "Saisie semi-automatique Google Maps active",
        apiKeyAuthError: "Erreur d'authentification de la clé API",
        apiKeyNotSet: "Configurer l'API Maps / Clé de démo",
        btnKeyConfigure: "Clé API",
        gmpKeyTitle: "Clé de recherche Google Maps",
        btnKeySave: "Enregistrer et connecter",
        btnKeyRemove: "Supprimer la clé",
        toastKeySaved: "Clé API enregistrée. Connexion en cours...",
        toastKeyRemoved: "Clé API supprimée"
    },
    hi: {
        searchStep1: "व्यवसाय का नाम लिखें और मैप्स पर खोजें पर क्लिक करें",
        searchStep2: "Google Maps पर 'शेयर' पर क्लिक करके लिंक कॉपी करें",
        searchStep3: "नीचे 'ऑटो-पेस्ट और कन्वर्ट' पर क्लिक करें!",
        btnLaunchMaps: "Google Maps पर खोजें ↗",
        btnAutoPasteConvert: "ऑटो-पेस्ट और कन्वर्ट",
        apiKeyConnected: "Google Maps ऑटोकम्प्लीट सक्रिय है",
        apiKeyAuthError: "एपीआई कुंजी प्रमाणीकरण त्रुटि",
        apiKeyNotSet: "मैप्स एपीआई / डेमो कुंजी कॉन्फ़िगर करें",
        btnKeyConfigure: "API कुंजी",
        gmpKeyTitle: "Google Maps खोज कुंजी",
        btnKeySave: "सहेजें और कनेक्ट करें",
        btnKeyRemove: "कुंजी हटाएं",
        toastKeySaved: "API कुंजी सहेजी गई। कनेक्ट हो रहा है...",
        toastKeyRemoved: "API कुंजी हटा दी गई"
    },
    ja: {
        searchStep1: "店舗・施設名を入力して「Googleマップで検索」をクリック",
        searchStep2: "Googleマップで「共有」をタップしてリンクをコピー",
        searchStep3: "下の「自動貼り付け＆変換」をクリック！",
        btnLaunchMaps: "Googleマップで検索 ↗",
        btnAutoPasteConvert: "自動貼り付け＆変換",
        apiKeyConnected: "Google Maps オートコンプリート有効",
        apiKeyAuthError: "APIキー認証エラー",
        apiKeyNotSet: "Maps API設定 / デモキー",
        btnKeyConfigure: "APIキー",
        gmpKeyTitle: "Google Maps 検索キー",
        btnKeySave: "保存して接続",
        btnKeyRemove: "キーを削除",
        toastKeySaved: "APIキーを保存しました。接続中...",
        toastKeyRemoved: "APIキーを削除しました"
    },
    pt: {
        searchStep1: "Digite o nome da empresa e clique em 'Pesquisar no Maps'",
        searchStep2: "Clique em 'Compartilhar' e copie o link no Google Maps",
        searchStep3: "Clique em 'Colar automático e converter' abaixo!",
        btnLaunchMaps: "Pesquisar no Google Maps ↗",
        btnAutoPasteConvert: "Colar automático e converter",
        apiKeyConnected: "Preenchimento automático do Google Maps ativo",
        apiKeyAuthError: "Erro de autenticação da chave de API",
        apiKeyNotSet: "Configurar API Maps / Chave de Demonstração",
        btnKeyConfigure: "Chave API",
        gmpKeyTitle: "Chave de pesquisa do Google Maps",
        btnKeySave: "Salvar e conectar",
        btnKeyRemove: "Remover chave",
        toastKeySaved: "Chave de API salva. Conectando...",
        toastKeyRemoved: "Chave de API removida"
    },
    ru: {
        searchStep1: "Введите название компании и нажмите 'Поиск на картах'",
        searchStep2: "Нажмите 'Поделиться' и скопируйте ссылку в Google Maps",
        searchStep3: "Нажмите 'Авто-вставка и конвертация' внизу!",
        btnLaunchMaps: "Искать в Google Maps ↗",
        btnAutoPasteConvert: "Авто-вставка и конвертация",
        apiKeyConnected: "Автозаполнение Google Maps активно",
        apiKeyAuthError: "Ошибка аутентификации API-ключа",
        apiKeyNotSet: "Настроить Maps API / Демо-ключ",
        btnKeyConfigure: "API-ключ",
        gmpKeyTitle: "Ключ поиска Google Maps",
        btnKeySave: "Сохранить и подключить",
        btnKeyRemove: "Удалить ключ",
        toastKeySaved: "API-ключ сохранен. Подключение...",
        toastKeyRemoved: "API-ключ удален"
    },
    zh: {
        searchStep1: "输入商家名称并点击“在地图上搜索”",
        searchStep2: "在 Google 地图上点击“分享”并复制链接",
        searchStep3: "点击下方的“自动粘贴并转换”！",
        btnLaunchMaps: "在 Google 地图上搜索 ↗",
        btnAutoPasteConvert: "自动粘贴并转换",
        apiKeyConnected: "Google 地图自动补全已启用",
        apiKeyAuthError: "API 密钥验证失败",
        apiKeyNotSet: "配置 Maps API / 演示密钥",
        btnKeyConfigure: "API 密钥",
        gmpKeyTitle: "Google 地图搜索密钥",
        btnKeySave: "保存并连接",
        btnKeyRemove: "移除密钥",
        toastKeySaved: "API 密钥已保存，正在连接...",
        toastKeyRemoved: "API 密钥已移除"
    }
};

// 4. Build complete 10-language dictionary object
const fullI18N = {
    en: originalI18N.en,
    ar: originalI18N.ar
};

const otherLangs = ['de', 'es', 'fr', 'hi', 'ja', 'pt', 'ru', 'zh'];

for (const lang of otherLangs) {
    // Start with a clean copy of English so that no key is ever missing or undefined
    const dict = Object.assign({}, originalI18N.en);

    // Merge arb translations from Flutter
    const arbPath = path.join(L10N_DIR, `app_${lang}.arb`);
    if (fs.existsSync(arbPath)) {
        const arbData = JSON.parse(fs.readFileSync(arbPath, 'utf8'));
        for (const [k, v] of Object.entries(arbData)) {
            if (!k.startsWith('@')) {
                dict[k] = v;
            }
        }
    }

    // Merge marketing translations
    if (marketing[lang]) {
        Object.assign(dict, marketing[lang]);
    }

    // Merge extra web strings
    if (extraWebStrings[lang]) {
        Object.assign(dict, extraWebStrings[lang]);
    }

    fullI18N[lang] = dict;
    console.log(`Prepared language '${lang}': ${Object.keys(dict).length} keys.`);
}

// 5. Format replacement JS for I18N
const langKeys = Object.keys(fullI18N);
const formattedParts = [];

for (const lk of langKeys) {
    const dictObj = fullI18N[lk];
    const lines = [];
    for (const [k, v] of Object.entries(dictObj)) {
        lines.push(`            ${JSON.stringify(k)}: ${JSON.stringify(v)}`);
    }
    formattedParts.push(`        ${lk}: {\n${lines.join(',\n')}\n        }`);
}

const newI18nBlock = `const I18N = {\n${formattedParts.join(',\n')}\n    };`;

// 6. Replace in i18nSource
const startMarker = 'const I18N = {';
const startIdx = i18nSource.indexOf(startMarker);
if (startIdx === -1) throw new Error('Could not find const I18N = { in i18n.js');

const letMarker = 'let currentLang =';
const letIdx = i18nSource.indexOf(letMarker);
if (letIdx === -1) throw new Error('Could not find let currentLang = in i18n.js');

const closeIdx = i18nSource.lastIndexOf('};', letIdx);
if (closeIdx === -1) throw new Error('Could not find closing }; before let currentLang =');

let updatedI18nSource = i18nSource.slice(0, startIdx) + newI18nBlock + i18nSource.slice(closeIdx + 2);

// 7. Defensive check in applyLanguage: ensure updateLanguageSelectorUi(lang) always runs and fallback to en
updatedI18nSource = updatedI18nSource.replace(
    /const dict = I18N\[lang\];\s*if \(!dict\) return;/,
    `updateLanguageSelectorUi(lang);\n        const dict = I18N[lang] || I18N['en'];`
);

// 8. Write updated i18n.js
fs.writeFileSync(I18N_PATH, updatedI18nSource, 'utf8');
console.log(`Successfully updated ${I18N_PATH} with all 10 languages!`);

// 9. Validation
const testSandbox = {
    window: {},
    localStorage: { getItem() { return 'en'; }, setItem() {} }
};
vm.createContext(testSandbox);
vm.runInContext(fs.readFileSync(I18N_PATH, 'utf8'), testSandbox);

const finalKeys = Object.keys(testSandbox.window.I18N);
console.log('Final I18N languages in sandbox:', finalKeys);
if (finalKeys.length !== 10) {
    throw new Error(`Expected 10 languages, found ${finalKeys.length}`);
}

console.log('All 10 languages verified in i18n.js with 100% success!');
