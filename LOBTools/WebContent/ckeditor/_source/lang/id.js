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

CKEDITOR.lang['id'] =
{
	/**
	 * The language reading direction. Possible values are "rtl" for
	 * Right-To-Left languages (like Arabic) and "ltr" for Left-To-Right
	 * languages (like English).
	 * @default "ltr"
	 */
	dir : "ltr",
	
	// ARIA descriptions.
	editor	: "Editor Teks Kaya",
	editorPanel: 'Panel Editor Teks Kaya',

	// Common messages and labels.
	common: {
		// Screenreader titles. Please note that screenreaders are not always capable
		// of reading non-English words. So be careful while translating it.
		editorHelp: "Tekan ALT 0 untuk bantuan",

		browseServer	: "Server Browser:",
		url				: "URL:",
		protocol		: "Protokol:",
		upload			: "Unggah:",
		uploadSubmit	: "Kirim ke Server",
		image			: "Masukkan Gambar",
		flash			: "Masukkan Film Flash",
		form			: "Masukkan Bentuk",
		checkbox		: "Masukkan Kotak Centang",
		radio			: "Masukkan Tombol Radio",
		textField		: "Masukkan Kolom Teks",
		textarea		: "Masukkan Area Teks",
		hiddenField		: "Masukkan Kolom Tersembunyi",
		button			: "Masukkan Tombol",
		select			: "Masukkan Kolom Pilihan",
		imageButton		: "Masukkan Tombol Gambar",
		notSet			: "tidak diatur",
		id				: "ID:",
		name			: "Nama:",
		langDir			: "Arah Bahasa:",
		langDirLtr		: "Kiri ke Kanan",
		langDirRtl		: "Kanan ke Kiri",
		langCode		: "Kode Bahasa:",
		longDescr		: "URL Deskripsi Panjang:",
		cssClass		: "Kelas Stylesheet:",
		advisoryTitle	: "Jabatan departemen:",
		cssStyle		: "Gaya:",
		ok				: "Ya",
		cancel			: "Batalkan",
		close : "Tutup",
		preview			: "Pratinjau:",
		resize			: "Ubah ukuran",
		generalTab		: "Umum",
		advancedTab		: "Lanjutan",
		validateNumberFailed	: "Nilai ini bukan angka.",
		confirmNewPage	: "Setiap perubahan atas konten ini yang belum disimpan akan hilang. Anda yakin ingin memuat halaman baru?",
		confirmCancel	: "Beberapa opsi telah diubah. Anda yakin ingin menutup dialog?",
		options : "Opsi",
		target			: "Target:",
		targetNew		: "Jendela Baru (_kosong)",
		targetTop		: "Jendela Topmost (_atas)",
		targetSelf		: "Jendela yang Sama (_ini)",
		targetParent	: "Jendela Induk (_induk)",
		langDirLTR		: "Kiri ke Kanan",
		langDirRTL		: "Kanan ke Kiri",
		styles			: "Gaya:",
		cssClasses		: "Kelas Stylesheet:",
		width			: "Lebar:",
		height			: "Tinggi:",
		align			: "Ratakan:",
		alignLeft		: "Kiri",
		alignRight		: "Kanan",
		alignCenter		: "Tengah",
		alignJustify	: 'Rata Dua Sisi',
		alignTop		: "Atas",
		alignMiddle		: "Tengah",
		alignBottom		: "Bawah",
		alignNone		: 'Tidak Ada',
		invalidValue	: "Nilai tidak valid.",
		invalidHeight	: "Tinggi harus berupa bilangan bulat positif.",
		invalidWidth	: "Lebar harus berupa bilangan bulat positif.",
		invalidCssLength	: "Nilai yang dimasukkan untuk kolom '%1' harus berupa bilangan positif dengan atau tanpa unit pengukuran CSS yang valid (px, %, in, cm, mm, em, ex, pt, atau pc).",
		invalidHtmlLength	: "Nilai yang dimasukkan untuk kolom '%1' harus berupa bilangan positif dengan atau tanpa unit pengukuran HTML yang valid (px atau %).",
		invalidInlineStyle	: "Nilai yang dimasukkan untuk gaya inline harus terdiri atas satu atau lebih tuple dengan format \"nama : nilai\", yang dipisahkan dengan tanda titik koma.",
		cssLengthTooltip	: "Masukkan sebuah angka untuk nilai dalam piksel atau sebuah angka dengan unit CSS yang valid (px, %, in, cm, mm, em, ex, pt, atau pc).",

		// Put the voice-only part of the label in the span.
		unavailable		: "%1<span class=\"cke_accessibility\">, tidak tersedia</span>"
	},
	
	ibm :
	{
		common :
		{
			widthIn	: "inci",
			widthCm	: "sentimeter",
			widthMm	: "millimeter",
			widthEm	: "em",
			widthEx	: "ex",
			widthPt	: "point",
			widthPc	: "pica",
			required : "Wajib diisi"
		}
		/*linkdialog : 
		{
			label : "Link Dialog"
		}
		*/		
	},
	
	wsc :
	{
		btnIgnore: 'Abaikan',
		btnIgnoreAll: 'Abaikan Semua',
		btnReplace: 'Ganti',
		btnReplaceAll: 'Ganti Semua',
		btnUndo: 'Batalkan',
		changeTo: 'Ubah jadi',
		errorLoading: 'Kesalahan dalam memuat host layanan aplikasi: %s.',
		ieSpellDownload: 'Pemeriksa ejaan tidak terpasang. Apakah Anda ingin mengunduhnya sekarang?',
		manyChanges: 'Pemeriksaan ejaan selesai: %1 kata diubah',
		noChanges: 'Pemeriksaan ejaan selesai: Tidak ada kata yang diubah',
		noMispell: 'Pemeriksaan ejaan selesai: Tidak ditemukan ejaan yang salah',
		noSuggestions: '- Tidak ada saran -',
		notAvailable: 'Maaf, layanan tidak tersedia saat ini.',
		notInDic: 'Tidak ada dalam kamus',
		oneChange: 'Pemeriksaan ejaan selesai: Satu kata diubah',
		progress: 'Pemeriksaan ejaan sedang berlangsung...',
		title: 'Pemeriksaan Ejaan',
		toolbar: 'Periksa Ejaan'
	},
	
	scayt :
	{
		about: 'Tentang SCAYT',
		aboutTab: 'Tentang',
		addWord: 'Tambah Kata',
		allCaps: 'Abaikan Kata dengan Huruf Kapital Semua',
		dic_create: 'Buat',
		dic_delete: 'Hapus',
		dic_field_name: 'Nama kamus',
		dic_info: 'Kamus Pengguna mula-mula disimpan dalam sebuah Cookie. Namun, ukuran Cookie terbatas. Jika ukuran Kamus Pengguna bertambah hingga tidak dapat lagi disimpan dalam sebuah Cookie, maka kamus dapat disimpan di server kami. Untuk menyimpan kamus pribadi Anda di server kami Anda harus memasukkan nama untuk kamus Anda. Jika anda telah memiliki kamus tersimpan, masukkan nama kamus dan klik tombol Pulihkan.',
		dic_rename: 'Ganti nama',
		dic_restore: 'Pulihkan',
		dictionariesTab: 'Kamus',
		disable: 'Nonaktifkan SCAYT',
		emptyDic: 'Nama kamus tidak boleh kosong.',
		enable: 'Aktifkan SCAYT',
		ignore: 'TESTIgnore',
		ignoreAll: 'Abaikan Semua',
		ignoreDomainNames: 'Abaikan Nama Domain',
		langs: 'Bahasa',
		languagesTab: 'Bahasa',
		mixedCase: 'Abaikan Kata dengan Huruf Besar Kecil',
		mixedWithDigits: 'Abaikan Kata dengan Angka',
		moreSuggestions: 'Lebih banyak saran',
		opera_title: 'Tidak didukung oleh Opera',
		options: 'Opsi',
		optionsTab: 'Opsi',
		title: 'Pemeriksaan Ejaan Sembari Mengetik',
		toggle: 'Aktifkan/Nonaktifkan SCAYT',
		noSuggestions: 'Tidak ada saran'
	}
	
};

