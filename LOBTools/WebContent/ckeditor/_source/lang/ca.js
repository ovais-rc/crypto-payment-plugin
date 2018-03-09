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

CKEDITOR.lang['ca'] =
{
	/**
	 * The language reading direction. Possible values are "rtl" for
	 * Right-To-Left languages (like Arabic) and "ltr" for Left-To-Right
	 * languages (like English).
	 * @default "ltr"
	 */
	dir : "ltr",
	
	// ARIA descriptions.
	editor	: "Editor de text enriquit",
	editorPanel: 'Panell de l\'editor de text enriquit',

	// Common messages and labels.
	common: {
		// Screenreader titles. Please note that screenreaders are not always capable
		// of reading non-English words. So be careful while translating it.
		editorHelp: "Premeu ALT 0 per obtenir ajuda",

		browseServer	: "Servidor del navegador:",
		url				: "URL:",
		protocol		: "Protocol:",
		upload			: "Penja:",
		uploadSubmit	: "Envia\'l a un servidor",
		image			: "Insereix imatge",
		flash			: "Insereix pel·lícula en flaix",
		form			: "Insereix un formulari",
		checkbox		: "Insereix un quadre de selecció",
		radio			: "Insereix un botó d\'opció",
		textField		: "Insereix camp de text",
		textarea		: "Insereix àrea de text",
		hiddenField		: "Insereix un camp ocult",
		button			: "Insereix un botó",
		select			: "Insereix un camp de selecció",
		imageButton		: "Insereix un botó d\'imatge",
		notSet			: "no definit",
		id				: "ID:",
		name			: "Nom:",
		langDir			: "Direcció de l\'idioma:",
		langDirLtr		: "D\'esquerra a dreta",
		langDirRtl		: "De dreta a esquerra",
		langCode		: "Codi de l\'idioma:",
		longDescr		: "URL de descripció llarga:",
		cssClass		: "Classes de full d'estil:",
		advisoryTitle	: "Títol informatiu:",
		cssStyle		: "Estil:",
		ok				: "D'acord",
		cancel			: "Cancel·la",
		close : "Tanca",
		preview			: "Visualització prèvia:",
		resize			: "Redimensiona",
		generalTab		: "General",
		advancedTab		: "Avançat",
		validateNumberFailed	: "Aquest valor no és un número.",
		confirmNewPage	: "Qualsevol canvi sense desar a aquest contingut es perdrà. Esteu segur que voleu carregar una pàgina nova?",
		confirmCancel	: "Algunes de les opcions s'han modificat. Esteu segur que desitgeu tancar el diàleg?",
		options : "Opcions",
		target			: "Destinació:",
		targetNew		: "Finestra nova (_blank)",
		targetTop		: "Finestra a la part superior (_top)",
		targetSelf		: "Mateixa finestra (_self)",
		targetParent	: "Finestra pare (_parent)",
		langDirLTR		: "D\'esquerra a dreta",
		langDirRTL		: "De dreta a esquerra",
		styles			: "Estil:",
		cssClasses		: "Classes de full d'estil:",
		width			: "Amplada:",
		height			: "Alçada:",
		align			: "Alineació:",
		alignLeft		: "Esquerra",
		alignRight		: "Dreta",
		alignCenter		: "Centre",
		alignJustify	: 'Justificada',
		alignTop		: "Superior",
		alignMiddle		: "Mig",
		alignBottom		: "Inferior",
		alignNone		: 'Cap',
		invalidValue	: "Valor no vàlid.",
		invalidHeight	: "L'alçada ha de ser un número enter positiu.",
		invalidWidth	: "L'amplada ha de ser un número enter positiu.",
		invalidCssLength	: "El valor especificat per al camp '%1' ha de ser un número positiu amb o sense una unitat de mesura CSS vàlida (px, %, in, cm, mm, em, ex, pt, o pc).",
		invalidHtmlLength	: "El valor especificat per al camp '%1' ha de ser un número positiu amb o sense una unitat de mesura HTML vàlida (px o %).",
		invalidInlineStyle	: "El valor especificat per a l'estil en línia ha de constar d'un o més tuples amb el format \"nom : valor\", separat per punts i coma.",
		cssLengthTooltip	: "Introduïu el número d'un valor en píxels amb una unitat CSS vàlida (px, %, in, cm, mm, em, ex, pt, o pc).",

		// Put the voice-only part of the label in the span.
		unavailable		: "%1<span class=\"cke_accessibility\">, no disponible</span>"
	},
	
	ibm :
	{
		common :
		{
			widthIn	: "polzades",
			widthCm	: "centímetres",
			widthMm	: "mil·límetres",
			widthEm	: "quadratí",
			widthEx	: "ex",
			widthPt	: "punts",
			widthPc	: "picas",
			required : "Obligatori"
		}
		/*linkdialog : 
		{
			label : "Link Dialog"
		}
		*/		
	},
	
	wsc :
	{
		btnIgnore: 'Ignora',
		btnIgnoreAll: 'Ignora tot',
		btnReplace: 'Substitueix',
		btnReplaceAll: 'Substitueix tot',
		btnUndo: 'Desfés',
		changeTo: 'Canvia a',
		errorLoading: 'S\'ha produït un error en carregar l\'amfitrió del servei d\'aplicació: %s.',
		ieSpellDownload: 'El corrector ortogràfic no està instal·lat. ¿Voleu baixar-lo ara?',
		manyChanges: 'Correcció ortogràfica completa: %1 paraules canviades',
		noChanges: 'Correcció ortogràfica completa: no s\'ha canviat cap paraula',
		noMispell: 'Correcció ortogràfica completa: no s\'ha trobat cap error ortogràfic',
		noSuggestions: '- Sense suggeriments -',
		notAvailable: 'Ho sentim, aquest servei no està disponible ara.',
		notInDic: 'No es troba al diccionari',
		oneChange: 'Correcció ortogràfica completa: s\'ha canviat una paraula',
		progress: 'Correcció ortogràfica en curs...',
		title: 'Correcció ortogràfica',
		toolbar: 'Comprovació ortogràfica'
	},
	
	scayt :
	{
		about: 'Quant a SCAYT',
		aboutTab: 'Quant a',
		addWord: 'Afegeix paraula',
		allCaps: 'Ignora les paraules amb totes les lletres en majúscules',
		dic_create: 'Crea',
		dic_delete: 'Suprimeix',
		dic_field_name: 'Nom de diccionari',
		dic_info: 'Inicialment, el Diccionari d\'usuari s\'emmagatzema en una galeta. Tanmateix, les galetes tenen una mida limitada. Quan el Diccionari d\'usuari creix fins a un punt en què no es pot emmagatzemar en una galeta, es pot emmagatzemar al nostre servidor. Per emmagatzemar el vostre diccionari personal en el nostre servidor, heu d\'especificar un nom per al diccionari. Si ja teniu un diccionari emmagatzemat, escriviu el seu nom i feu clic al botó Restaura.',
		dic_rename: 'Reanomena',
		dic_restore: 'Restaura',
		dictionariesTab: 'Diccionaris',
		disable: 'Inhabilita SCAYT',
		emptyDic: 'El nom del diccionari no pot ser buit.',
		enable: 'Habilita SCAYT',
		ignore: 'TESTIgnore',
		ignoreAll: 'Ignora tot',
		ignoreDomainNames: 'Ignora els noms de domini',
		langs: 'Idiomes',
		languagesTab: 'Idiomes',
		mixedCase: 'Ignora les paraules amb majúscules i minúscules mesclades',
		mixedWithDigits: 'Ignora les paraules amb números',
		moreSuggestions: 'Més suggeriments',
		opera_title: 'No admès per l\'Opera',
		options: 'Opcions',
		optionsTab: 'Opcions',
		title: 'Fer correcció ortogràfica mentre escriu',
		toggle: 'Commuta SCAYT',
		noSuggestions: 'Cap suggeriment'
	}
	
};

