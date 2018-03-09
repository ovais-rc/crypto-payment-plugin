/**
 * @license Copyright (c) 2003-2014, CKSource - Frederico Knabben. All rights reserved.
 * For licensing, see LICENSE.md or http://ckeditor.com/licensePortions Copyright IBM Corp., 2009-2015.
 */

CKEDITOR.plugins.setLang( 'a11yhelp', 'tr',
{
	//do not translate anything with the form ${xxx} 
	
	title : "Yardım",
	contents : "Yardımın İçindekiler. Bu iletişim kutusunu kapatmak için ESC tuşuna basın.",
	legend :
	[
		{
			name : "Erişilirlik Yönergeleri",
			items :
			[
				{
					name : "Düzenleyici Araç Çubuğu",
					legend: "Araç çubuğuna gitmek için ${toolbarFocus} tuşuna basın. " +
						"SEKME ve ÜST KARAKTER+SEKME tuşlarıyla bir sonraki ve bir önceki araç çubuğu grubuna gidin. " +
						"SAĞ OK ve SOL OK tuşlarıyla bir sonraki ve bir önceki araç çubuğu düğmesine gidin. " +
						"Araç çubuğu düğmesini etkinleştirmek için ARA ÇUBUĞU ya da ENTER tuşuna basın."
				},

				{
					name: "Düzenleyici İletişim Kutusu",
					legend:
						"Bir iletişim kutusunun içinde sonraki iletişim kutusu öğesine gitmek için SEKME tuşuna; önceki iletişim kutusu öğesine gitmek için ÜST KARAKTER+SEKME tuşuna; iletişim kutusunu göndermek için ENTER tuşuna; iletişim kutusunu iptal etmek için ESC tuşuna basın. " +
						"Bir iletişim kutusunda birden çok sekme olduğunda, iletişim kutusu sekmesinin bir parçası olarak SEKME ya da ALT+F10 tuşuyla da sekme listesine erişilebilir. " +
						"Odak sekme listesindeyken sırayla SAĞ ve SOL OK tuşlarıyla sonraki ve önceki sekmeye gidin. "
				},

				{
					name : "Düzenleyici Bağlam Menüsü",
					legend :
						"Bağlam menüsünü açmak için ${contextMenu} ya da UYGULAMA TUŞUNA basın. " +
						"Daha sonra, sonraki menü seçeneğine gitmek için SEKME ya da AŞAĞI OK tuşuna basın. " +
						"Önceki seçeneğe ÜST KARAKTER+SEKME ya da YUKARI OK tuşuyla gidin. " +
						"Menü seçeneğini belirlemek için ARA ÇUBUĞU ya da ENTER tuşuna basın. " +
						"Geçerli seçeneğin alt menüsünü açmak için ARA ÇUBUĞU ya da ENTER ya da SAĞ OK tuşuna basın. " +
						"Üst menü öğesine dönmek için ESC ya da SOL OK tuşuna basın. " +
						"Bağlam menüsünü ESC tuşuyla kapatın."
				},

				{
					name : "Düzenleyici Liste Kutusu",
					legend :
						"Bir liste kutusunun içindeyken sonraki liste öğesine gitmek için SEKME ya da AŞAĞI OK tuşuna basın. " +
						"Önceki liste öğesine gitmek için ÜST KARAKTER + SEKME ya da YUKARI OK tuşuna basın. " +
						"Liste seçeneğini belirlemek için ARA ÇUBUĞU ya da ENTER tuşuna basın. " +
						"Liste kutusunu kapatmak için ESC tuşuna basın."
				},

				{
					name : "Düzenleyici Öğe Yolu Çubuğu (varsa*)",
					legend :
						"Öğe yolu çubuğuna gitmek için ${elementsPathFocus} tuşuna basın. " +
						"Sonraki öğe düğmesine SEKME ya da SAĞ OK tuşuyla gidin. " +
						"Önceki düğmeye ÜST KARAKTER+SEKME ya da SOL OK tuşuyla gidin. " +
						"Düzenleyicide öğeyi seçmek için ARA ÇUBUĞU ya da ENTER tuşuna basın."
				}
			]
		},
		{
			name : "Komutlar",
			items :
			[
				{
					name : " Geri Al komutu",
					legend : "${undo} tuşuna basın"
				},
				{
					name : " Yinele komutu",
					legend : "${redo} tuşuna basın"
				},
				{
					name : " Koyu komutu",
					legend : "${bold} tuşuna basın"
				},
				{
					name : " İtalik komutu",
					legend : "${italic} tuşuna basın"
				},
				{
					name : " Altını Çiz komutu",
					legend : "${underline} tuşuna basın"
				},
				{
					name : " Bağlantı Oluştur komutu",
					legend : "${link} tuşuna basın"
				},
				{
					name : " Araç Çubuğunu Daralt komutu (varsa*)",
					legend : "${toolbarCollapse} tuşuna basın"
				},
				{
					name: ' Önceki odak alanına eriş komutu',
					legend: 'Ulaşılamayan bir odak alanında imlecin hemen öncesine boşluk eklemek için ${accessPreviousSpace} tuşuna basın. ' +
						'Ulaşılamayan odak alanı, düzenleyicide fare ya da klavye kullanarak imleci konumlayamadığınız ' + 
						'bir konumdur. Örneğin: iki yakın tablo öğesi arasına içerik eklemek için bu komutu kullanın.'
				},
				{
					name: ' Sonraki odak alanına eriş komutu',
					legend: 'Ulaşılamayan bir odak alanında imlecin hemen sonrasına boşluk eklemek için ${accessNextSpace} tuşuna basın. ' +
						'Ulaşılamayan odak alanı, düzenleyicide fare ya da klavye kullanarak imleci konumlayamadığınız ' +
						'bir konumdur. Örneğin: iki yakın tablo öğesi arasına içerik eklemek için bu komutu kullanın.'
				},
				{
					name : " Girintiyi Artır",
					legend : "${indent} tuşuna basın"
				},
				{
					name : " Girintiyi Azalt",
					legend : "${outdent} tuşuna basın"
				},				
				{
					name : " Metin yönü soldan sağa",
					legend : "${bidiltr} tuşuna basın"
				},
				{
					name : " Metin yönü sağdan sola",
					legend : "${bidirtl} tuşuna basın"
				},
				{
					name: ' Kalıcı kalem',
					legend: 'Kalıcı kalemi etkinleştirmek/devre dışı bırakmak için düzenleyici içindeki ${ibmpermanentpen} (MAC\'te Alt+Cmd+T) simgesini tıklatın.'
				},
				{
					name : " Erişilebilirlik Yardımı",
					legend : "${a11yHelp} tuşuna basın"
				}
			]
		},
		
		{	//added by ibm
			name : "Not",
			items :
			[
				{	
					name : "",
					legend : "* Bazı özellikler, yöneticiniz tarafından devre dışı bırakılabilir."
				}
			]
		}
	],
	backspace: 'Geri tuşu',
	tab: 'Sekme tuşu',
	enter: 'Enter',
	shift: 'Üst karakter',
	ctrl: 'Ctrl',
	alt: 'Alt',
	pause: 'Pause',
	capslock: 'Caps Lock',
	escape: 'Escape',
	pageUp: 'Page Up',
	pageDown: 'Page Down',
	end: 'End',
	home: 'Home',
	leftArrow: 'Sol Ok',
	upArrow: 'Yukarı Ok',
	rightArrow: 'Sağ Ok',
	downArrow: 'Aşağı Ok',
	insert: 'Insert',
	'delete': 'Delete',
	leftWindowKey: 'Sol Windows tuşu',
	rightWindowKey: 'Sağ Windows tuşu',
	selectKey: 'Tuş seç',
	numpad0: 'Numpad 0',
	numpad1: 'Numpad 1',
	numpad2: 'Numpad 2',
	numpad3: 'Numpad 3',
	numpad4: 'Numpad 4',
	numpad5: 'Numpad 5',
	numpad6: 'Numpad 6',
	numpad7: 'Numpad 7',
	numpad8: 'Numpad 8',
	numpad9: 'Numpad 9',
	multiply: 'Çarp',
	add: 'Ekle',
	subtract: 'Çıkar',
	decimalPoint: 'Ondalık Nokta',
	divide: 'Böl',
	f1: 'F1',
	f2: 'F2',
	f3: 'F3',
	f4: 'F4',
	f5: 'F5',
	f6: 'F6',
	f7: 'F7',
	f8: 'F8',
	f9: 'F9',
	f10: 'F10',
	f11: 'F11',
	f12: 'F12',
	numLock: 'Num Lock',
	scrollLock: 'Scroll Lock',
	semiColon: 'Noktalı virgül',
	equalSign: 'Eşittir İşareti',
	comma: 'Virgül',
	dash: 'Tire',
	period: 'Nokta',
	forwardSlash: 'Eğik Çizgi',
	graveAccent: 'Ağır Vurgu',
	openBracket: 'Köşeli Ayraç Aç',
	backSlash: 'Ters eğik çizgi',
	closeBracket: 'Köşeli Ayraç Kapa',
	singleQuote: 'Tek Tırnak',
	
	ibm :
	{
		helpLinkDescription : "Diğer yardım konularını yeni bir pencerede açın",
		helpLink : "Diğer Yardım Konuları"
	}

});

