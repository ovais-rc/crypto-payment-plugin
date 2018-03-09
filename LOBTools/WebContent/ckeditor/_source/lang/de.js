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

CKEDITOR.lang['de'] =
{
	/**
	 * The language reading direction. Possible values are "rtl" for
	 * Right-To-Left languages (like Arabic) and "ltr" for Left-To-Right
	 * languages (like English).
	 * @default "ltr"
	 */
	dir : "ltr",
	
	// ARIA descriptions.
	editor	: "Rich Text Editor",
	editorPanel: 'Anzeige \'Rich Text Editor\'',

	// Common messages and labels.
	common: {
		// Screenreader titles. Please note that screenreaders are not always capable
		// of reading non-English words. So be careful while translating it.
		editorHelp: "Drücken Sie ALT 0 für Hilfe",

		browseServer	: "Browser-Server:",
		url				: "URL:",
		protocol		: "Protokoll:",
		upload			: "Hochladen:",
		uploadSubmit	: "An den Server senden",
		image			: "Grafik einfügen",
		flash			: "Flashfilm einfügen",
		form			: "Maske einfügen",
		checkbox		: "Kontrollkästchen einfügen",
		radio			: "Optionsfeld einfügen",
		textField		: "Textfeld einfügen",
		textarea		: "Textbereich einfügen",
		hiddenField		: "Verdecktes Feld einfügen",
		button			: "Schaltfläche einfügen",
		select			: "Auswahlfeld einfügen",
		imageButton		: "Grafikschaltfläche einfügen",
		notSet			: "nicht festgelegt",
		id				: "ID:",
		name			: "Name: ",
		langDir			: "Sprachrichtung:",
		langDirLtr		: "Von links nach rechts",
		langDirRtl		: "Von rechts nach links",
		langCode		: "Sprachcode:",
		longDescr		: "Langbeschreibung URL:",
		cssClass		: "Formatvorlageklassen:",
		advisoryTitle	: "Ratgebertitel:",
		cssStyle		: "Formatvorlage:",
		ok				: "OK",
		cancel			: "Abbrechen",
		close : "Schließen",
		preview			: "Vorschau:",
		resize			: "Größe ändern",
		generalTab		: "Allgemein",
		advancedTab		: "Erweitert",
		validateNumberFailed	: "Dieser Wert ist keine Zahl.",
		confirmNewPage	: "Alle nicht gespeicherten Änderungen an diesem Inhalt gehen verloren. Möchten Sie wirklich eine neue Seite laden?",
		confirmCancel	: "Einige Optionen wurden geändert. Möchten Sie das Dialogfenster wirklich schließen?",
		options : "Optionen",
		target			: "Ziel:",
		targetNew		: "Neues Fenster (_blank)",
		targetTop		: "Aktives Fenster (_top)",
		targetSelf		: "Gleiches Fenster (_self)",
		targetParent	: "Übergeordnetes Fenster (_parent)",
		langDirLTR		: "Von links nach rechts",
		langDirRTL		: "Von rechts nach links",
		styles			: "Formatvorlage:",
		cssClasses		: "Formatvorlageklassen:",
		width			: "Breite:",
		height			: "Höhe:",
		align			: "Ausrichten:",
		alignLeft		: "Links",
		alignRight		: "Rechts",
		alignCenter		: "Zentriert",
		alignJustify	: 'Ausrichten',
		alignTop		: "Oben",
		alignMiddle		: "Mitte",
		alignBottom		: "Unten",
		alignNone		: 'Keine',
		invalidValue	: "Ungültiger Wert.",
		invalidHeight	: "Die Höhe muss eine positive Ganzzahl sein.",
		invalidWidth	: "Die Breite muss eine positive Ganzzahl sein.",
		invalidCssLength	: "Der Wert für das Feld '%1' muss eine positive Zahl mit oder ohne gültige CSS-Maßeinheit sein (px, %, in, cm, mm, em, ex, pt oder pc).",
		invalidHtmlLength	: "Der Wert für das Feld '%1' muss eine positive Zahl mit oder ohne gültige HTML-Maßeinheit sein (px oder %).",
		invalidInlineStyle	: "Der Wert für den Inlinestil muss aus einem oder mehreren Tupeln mit dem Format \"Name : Wert\" bestehen. Die Tupel werden durch Semikolons getrennt.",
		cssLengthTooltip	: "Geben Sie eine Zahl für einen Wert in Pixeln oder eine Zahl mit einer gültigen CSS-Einheit ein (px, %, in, cm, mm, em, ex, pt oder pc).",

		// Put the voice-only part of the label in the span.
		unavailable		: "%1<span class=\"cke_accessibility\">, nicht verfügbar</span>"
	},
	
	ibm :
	{
		common :
		{
			widthIn	: "Zoll",
			widthCm	: "Zentimeter",
			widthMm	: "Millimeter",
			widthEm	: "em",
			widthEx	: "ex",
			widthPt	: "Punkt",
			widthPc	: "Pica",
			required : "Erforderlich"
		}
		/*linkdialog : 
		{
			label : "Link Dialog"
		}
		*/		
	},
	
	wsc :
	{
		btnIgnore: 'Ignorieren',
		btnIgnoreAll: 'Alle ignorieren',
		btnReplace: 'Ersetzen',
		btnReplaceAll: 'Alle ersetzen',
		btnUndo: 'Rückgängig machen',
		changeTo: 'Ändern in',
		errorLoading: 'Fehler beim Laden des Anwendungsservice-Hosts: %s.',
		ieSpellDownload: 'Das Programm für die Rechtschreibprüfung ist nicht installiert. Möchten Sie das Programm jetzt herunterladen?',
		manyChanges: 'Rechtschreibprüfung abgeschlossen: %1 Wörter geändert',
		noChanges: 'Rechtschreibprüfung abgeschlossen: Keine Wörter geändert',
		noMispell: 'Rechtschreibprüfung abgeschlossen: Keine Rechtschreibfehler gefunden',
		noSuggestions: '- Keine Vorschläge -',
		notAvailable: 'Der Service ist derzeit leider nicht verfügbar.',
		notInDic: 'Nicht im Wörterbuch',
		oneChange: 'Rechtschreibprüfung abgeschlossen: Ein Wort geändert',
		progress: 'Rechtschreibprüfung läuft...',
		title: 'Rechtschreibprüfung',
		toolbar: 'Überprüfen Sie die Schreibweise'
	},
	
	scayt :
	{
		about: 'Informationen zu SCAYT',
		aboutTab: 'Über',
		addWord: 'Wort hinzufügen',
		allCaps: 'Wörter in Großbuchstaben ignorieren',
		dic_create: 'Erstellen',
		dic_delete: 'Löschen',
		dic_field_name: 'Wörterbuchname',
		dic_info: 'Anfangs wird das Benutzerwörterbuch in einem Cookie gespeichert. Jedoch ist die Größe von Cookies begrenzt. Wenn das Benutzerwörterbuch so groß wird, dass es nicht mehr in einem Cookie gespeichert werden kann, dann kann das Wörterbuch auf unserem Server gespeichert werden. Um Ihr persönliches Wörterbuch auf unserem Server zu speichern, sollten Sie einen Namen für Ihr Wörterbuch angeben. Wenn Sie bereits über ein gespeichertes Wörterbuch verfügen, geben Sie den Namen ein und klicken Sie auf die Schaltfläche "Wiederherstellen". ',
		dic_rename: 'Umbenennen',
		dic_restore: 'Wiederherstellen ',
		dictionariesTab: 'Wörterbücher',
		disable: 'SCAYT inaktivieren',
		emptyDic: 'Der Wörterbuchname darf nicht leer sein.',
		enable: 'SCAYT aktivieren',
		ignore: 'TESTIgnore',
		ignoreAll: 'Alle ignorieren',
		ignoreDomainNames: 'Domänennamen ignorieren',
		langs: 'Sprachen',
		languagesTab: 'Sprachen',
		mixedCase: 'Wörter mit Groß-/Kleinschreibung ignorieren',
		mixedWithDigits: 'Wörter mit Zahlen ignorieren',
		moreSuggestions: 'Weitere Vorschläge',
		opera_title: 'Nicht unterstützt von Opera',
		options: 'Optionen',
		optionsTab: 'Optionen',
		title: 'Rechtschreibprüfung bei Eingabe',
		toggle: 'SCAYT ein-/ausschalten',
		noSuggestions: 'Kein Vorschlag'
	}
	
};

