/**
 * @license Copyright (c) 2003-2014, CKSource - Frederico Knabben. All rights reserved.
 * For licensing, see LICENSE.md or http://ckeditor.com/licensePortions Copyright IBM Corp., 2009-2015.
 */

/**
 * @fileOverview Defines the {@link CKEDITOR.lang} object for the English
 *		language. This is the base file for all translations.
 */

/**#@+
   @type String
   @example
*/

/**
 * Contains the dictionary of language entries.
 * @namespace
 */
// NLS_ENCODING=UTF-8
// NLS_MESSAGEFORMAT_NONE
// G11N GA UI

CKEDITOR.lang['tr'] =
{
	/**
	 * The language reading direction. Possible values are "rtl" for
	 * Right-To-Left languages (like Arabic) and "ltr" for Left-To-Right
	 * languages (like English).
	 * @default "ltr"
	 */
	dir : "ltr",
	
	// ARIA descriptions.
	editor	: "Zengin Metin Düzenleyici",
	editorPanel: 'Zengin Metin Düzenleyici panosu',

	// Common messages and labels.
	common: {
		// Screenreader titles. Please note that screenreaders are not always capable
		// of reading non-English words. So be careful while translating it.
		editorHelp: "Yardım için ALT 0 tuşlarına basın",

		browseServer	: "Tarayıcı Sunucusu:",
		url				: "URL:",
		protocol		: "Protokol:",
		upload			: "Karşıya Yükle:",
		uploadSubmit	: "Sunucuya gönder",
		image			: "Resim Ekle",
		flash			: "Flash Filmi Ekle",
		form			: "Form Ekle",
		checkbox		: "Onay Kutusu Ekle",
		radio			: "Radyo Düğmesi Ekle",
		textField		: "Metin Alanı Ekle",
		textarea		: "Metin Bölgesi Ekle",
		hiddenField		: "Gizli Alan Ekle",
		button			: "Düğme Ekle",
		select			: "Seçin Alanı Ekle",
		imageButton		: "Resim Düğmesi Ekle",
		notSet			: "belirlenmedi",
		id				: "Tanıtıcı:",
		name			: "Ad:",
		langDir			: "Dil Yönü:",
		langDirLtr		: "Soldan Sağa",
		langDirRtl		: "Sağdan Sola",
		langCode		: "Dil Kodu:",
		longDescr		: "Uzun Tanım URL Adresi:",
		cssClass		: "Stil sayfası sınıfları:",
		advisoryTitle	: "Danışman başlığı:",
		cssStyle		: "Stil:",
		ok				: "Tamam",
		cancel			: "İptal",
		close : "Kapat",
		preview			: "Önizleme:",
		resize			: "Yeniden Boyutlandır",
		generalTab		: "Genel",
		advancedTab		: "Gelişmiş",
		validateNumberFailed	: "Bu değer bir sayı değil.",
		confirmNewPage	: "Bu içerikteki saklanmamış değişiklikler kaybedilir. Yeni bir sayfa yüklemek istediğinizden emin misiniz?",
		confirmCancel	: "Bazı seçenekler değiştirildi. İletişim kutusunu kapatmak istediğinizden emin misiniz?",
		options : "Seçenekler",
		target			: "Hedef:",
		targetNew		: "Yeni Pencere (_blank)",
		targetTop		: "En Üstteki Pencere (_top)",
		targetSelf		: "Aynı Pencere (_self)",
		targetParent	: "Üst Pencere (_parent)",
		langDirLTR		: "Soldan Sağa",
		langDirRTL		: "Sağdan Sola",
		styles			: "Stil:",
		cssClasses		: "Stil Sayfası Sınıfları:",
		width			: "Genişlik:",
		height			: "Yükseklik:",
		align			: "Hizala:",
		alignLeft		: "Sola",
		alignRight		: "Sağa",
		alignCenter		: "Ortala",
		alignJustify	: 'Hizala',
		alignTop		: "En Üste",
		alignMiddle		: "Ortaya",
		alignBottom		: "Alta",
		alignNone		: 'Yok',
		invalidValue	: "Geçersiz değer.",
		invalidHeight	: "Yükseklik bir pozitif tamsayı olmalıdır.",
		invalidWidth	: "Genişlik bir pozitif tamsayı olmalıdır.",
		invalidCssLength	: "'%1' alanı için belirtilen değer, geçerli bir CSS ölçü birimiyle ya da CSS ölçü birimi olmadan (px, %, in, cm, mm, em, ex, pt veya pc) pozitif bir sayı olmalıdır.",
		invalidHtmlLength	: "'%1' alanı için belirtilen değer, geçerli bir HTML ölçü birimiyle ya da HTML ölçü birimi olmadan (px veya %) pozitif bir sayı olmalıdır.",
		invalidInlineStyle	: "Satır içi stili için belirtilen değer, iki noktayla birbirinden ayrılmış \"ad : değer\" biçimindeki bir ya da daha fazla değişken grubundan oluşmalıdır.",
		cssLengthTooltip	: "Piksel değeri için bir sayı ya da geçerli bir CSS birimiyle (px, %, in, cm, mm, em, ex, pt veya pc) sayı girin.",

		// Put the voice-only part of the label in the span.
		unavailable		: "%1<span class=\"cke_accessibility\">, kullanılamıyor</span>"
	},
	
	ibm :
	{
		common :
		{
			widthIn	: "inç",
			widthCm	: "santimetre",
			widthMm	: "milimetre",
			widthEm	: "em",
			widthEx	: "ex",
			widthPt	: "nokta",
			widthPc	: "pika",
			required : "Zorunlu"
		}
		/*linkdialog : 
		{
			label : "Link Dialog"
		}
		*/		
	},
	
	wsc :
	{
		btnIgnore: 'Yoksay',
		btnIgnoreAll: 'Tümünü Yoksay',
		btnReplace: 'Değiştir',
		btnReplaceAll: 'Tümünü Değiştir',
		btnUndo: 'Geri Al',
		changeTo: 'Buna çevir',
		errorLoading: 'Uygulama hizmeti anasistemi yüklenirken hata: %s.',
		ieSpellDownload: 'Yazım denetleyici kurulu değil. Şimdi karşıdan yüklemek ister misiniz?',
		manyChanges: 'Yazım denetimi tamamlandı: %1 sözcük değiştirildi',
		noChanges: 'Yazım denetimi tamamlandı: Hiçbir sözcük değiştirilmedi',
		noMispell: 'Yazım denetimi tamamlandı: Yazım hatası bulunamadı',
		noSuggestions: '- Öneri yok -',
		notAvailable: 'Üzgünüz, şu an hizmet kullanılamıyor.',
		notInDic: 'Sözlükte yok',
		oneChange: 'Yazım denetimi tamamlandı: Bir sözcük değiştirildi',
		progress: 'Yazım denetimi devam ediyor...',
		title: 'Yazım Denetimi',
		toolbar: 'Yazım Denetimi'
	},
	
	scayt :
	{
		about: 'SCAYT ürün bilgisi',
		aboutTab: 'Hakkında',
		addWord: 'Sözcük Ekle',
		allCaps: 'Tüm Büyük Harf Sözcükleri Yoksay',
		dic_create: 'Oluştur',
		dic_delete: 'Sil',
		dic_field_name: 'Sözlük adı',
		dic_info: 'Başlangıçta Kullanıcı Sözlüğü bir Tanımlama Bilgisi içinde saklanır. Ancak, Tanımlama Bilgilerinin boyutu sınırlıdır. Kullanıcı Sözlüğü, bir Tanımlama Bilgisi içinde saklanamayacak kadar büyüdüğünde, sözlük sunucumuzda saklanabilir. Kişisel sözlüğünüzü sunucumuzda saklamak için sözlüğünüze bir ad vermeniz gerekir. Önceden saklanmış olan bir sözlüğünüz varsa, lütfen bu sözlüğün adını yazın ve Geri Yükle düğmesini tıklatın.',
		dic_rename: 'Yeniden Adlandır',
		dic_restore: 'Geri Yükle',
		dictionariesTab: 'Sözlükler',
		disable: 'SCAYT olanağını geçersiz kıl',
		emptyDic: 'Sözlük adı boş olmamalıdır.',
		enable: 'SCAYT olanağını etkinleştir',
		ignore: 'TESTIgnore',
		ignoreAll: 'Tümünü Yoksay',
		ignoreDomainNames: 'Etki Alanı Adlarını Yoksay',
		langs: 'Diller',
		languagesTab: 'Diller',
		mixedCase: 'Büyük/Büyük Harf Karışık Kullanılan Sözcükleri Yoksay',
		mixedWithDigits: 'Sayı İçeren Sözcükleri Yoksay',
		moreSuggestions: 'Ek öneriler',
		opera_title: 'Opera tarafından sıralanmamış',
		options: 'Seçenekler',
		optionsTab: 'Seçenekler',
		title: 'Yazarken Yazım Denetimi',
		toggle: 'SCAYT aç/kapa',
		noSuggestions: 'Öneri yok'
	}
	
};

