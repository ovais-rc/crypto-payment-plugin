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

CKEDITOR.lang['el'] =
{
	/**
	 * The language reading direction. Possible values are "rtl" for
	 * Right-To-Left languages (like Arabic) and "ltr" for Left-To-Right
	 * languages (like English).
	 * @default "ltr"
	 */
	dir : "ltr",
	
	// ARIA descriptions.
	editor	: "Πρόγραμμα σύνταξης εμπλουτισμένου κειμένου",
	editorPanel: 'Πλαίσιο προγράμματος σύνταξης εμπλουτισμένου κειμένου',

	// Common messages and labels.
	common: {
		// Screenreader titles. Please note that screenreaders are not always capable
		// of reading non-English words. So be careful while translating it.
		editorHelp: "Πατήστε ALT 0 για βοήθεια",

		browseServer	: "Αναζήτηση εξυπηρετητή:",
		url				: "Διεύθυνση URL:",
		protocol		: "Πρωτόκολλο:",
		upload			: "Μεταφόρτωση:",
		uploadSubmit	: "Αποστολή στον εξυπηρετητή",
		image			: "Εισαγωγή εικόνας",
		flash			: "Εισαγωγή ταινίας Flash",
		form			: "Εισαγωγή φόρμας",
		checkbox		: "Εισαγωγή τετραγωνιδίου επιλογής",
		radio			: "Εισαγωγή κουμπιού επιλογής",
		textField		: "Εισαγωγή πεδίου κειμένου",
		textarea		: "Εισαγωγή περιοχής κειμένου",
		hiddenField		: "Εισαγωγή κρυφού αρχείου",
		button			: "Εισαγωγή κουμπιού",
		select			: "Εισαγωγή πεδίου επιλογής",
		imageButton		: "Εισαγωγή κουμπιού εικόνας",
		notSet			: "δεν έχει οριστεί",
		id				: "Ταυτότητα:",
		name			: "Όνομα:",
		langDir			: "Κατεύθυνση γλώσσας:",
		langDirLtr		: "Από αριστερά προς δεξιά",
		langDirRtl		: "Από δεξιά προς αριστερά",
		langCode		: "Κωδικός γλώσσας:",
		longDescr		: "Διεύθυνση URL αναλυτικής περιγραφής:",
		cssClass		: "Κλάσεις φύλλων στυλ:",
		advisoryTitle	: "Πληροφοριακός τίτλος:",
		cssStyle		: "Στυλ:",
		ok				: "ΟΚ",
		cancel			: "Ακύρωση",
		close : "Κλείσιμο",
		preview			: "Προεπισκόπηση:",
		resize			: "Αλλαγή μεγέθους",
		generalTab		: "Γενικά",
		advancedTab		: "Σύνθετες επιλογές",
		validateNumberFailed	: "Αυτή η τιμή δεν είναι αριθμός.",
		confirmNewPage	: "Οποιεσδήποτε μη αποθηκευμένες αλλαγές κάνατε στο περιεχόμενο θα χαθούν. Είστε βέβαιοι ότι επιθυμείτε να φορτώσετε μια νέα σελίδα;",
		confirmCancel	: "Ορισμένες από τις επιλογές έχουν αλλάξει. Είστε βέβαιοι ότι επιθυμείτε να κλείσετε το πλαίσιο διαλόγου;",
		options : "Επιλογές",
		target			: "Προορισμός:",
		targetNew		: "Νέο παράθυρο (_blank)",
		targetTop		: "Παράθυρο σε πρώτο πλάνο (_top)",
		targetSelf		: "Ίδιο παράθυρο (_self)",
		targetParent	: "Γονικό παράθυρο (_parent)",
		langDirLTR		: "Από αριστερά προς δεξιά",
		langDirRTL		: "Από δεξιά προς αριστερά",
		styles			: "Στυλ:",
		cssClasses		: "Κλάσεις φύλλων στυλ:",
		width			: "Πλάτος:",
		height			: "Ύψος:",
		align			: "Στοίχιση:",
		alignLeft		: "Αριστερά",
		alignRight		: "Δεξιά",
		alignCenter		: "Στο κέντρο",
		alignJustify	: 'Πλήρης στοίχιση',
		alignTop		: "Πάνω",
		alignMiddle		: "Στο κέντρο",
		alignBottom		: "Κάτω",
		alignNone		: 'Χωρίς',
		invalidValue	: "Μη έγκυρη τιμή.",
		invalidHeight	: "Η τιμή για το ύψος πρέπει να είναι θετικός ακέραιος αριθμός.",
		invalidWidth	: "Η τιμή για το πλάτος πρέπει να είναι θετικός ακέραιος αριθμός.",
		invalidCssLength	: "Η τιμή για το πεδίο '%1' πρέπει να είναι ένας θετικός αριθμός με ή χωρίς μια έγκυρη μονάδα μέτρησης CSS (px, %, in, cm, mm, em, ex, pt ή pc).",
		invalidHtmlLength	: "Η τιμή για το πεδίο '%1' πρέπει να είναι ένας θετικός αριθμός με ή χωρίς μια έγκυρη μονάδα μέτρησης HTML (px ή %).",
		invalidInlineStyle	: "Η τιμή για το εσωτερικό στυλ πρέπει να αποτελείται από ένα η περισσότερα ζεύγη (πλειάδες) της μορφής \"όνομα : τιμή\" που θα χωρίζονται με ερωτηματικό (;).",
		cssLengthTooltip	: "Καταχωρήστε έναν αριθμό εικονοστοιχείων ή έναν αριθμό με μια έγκυρη μονάδα μέτρησης CSS (px, %, in, cm, mm, em, ex, pt ή pc).",

		// Put the voice-only part of the label in the span.
		unavailable		: "%1<span class=\"cke_accessibility\"> - Δεν είναι διαθέσιμο.</span>"
	},
	
	ibm :
	{
		common :
		{
			widthIn	: "ίντσες",
			widthCm	: "εκατοστά",
			widthMm	: "χιλιοστά",
			widthEm	: "em",
			widthEx	: "ex",
			widthPt	: "pt",
			widthPc	: "pc",
			required : "Απαιτείται"
		}
		/*linkdialog : 
		{
			label : "Link Dialog"
		}
		*/		
	},
	
	wsc :
	{
		btnIgnore: 'Αγνόηση',
		btnIgnoreAll: 'Αγνόηση όλων',
		btnReplace: 'Αντικατάσταση',
		btnReplaceAll: 'Αντικατάσταση όλων',
		btnUndo: 'Αναίρεση',
		changeTo: 'Αλλαγή σε',
		errorLoading: 'Παρουσιάστηκε σφάλμα κατά τη φόρτωση της υπηρεσίας: %s.',
		ieSpellDownload: 'η λειτουργία ορθογραφικού ελέγχου δεν έχει εγκατασταθεί. Θέλετε να τη μεταφορτώσετε τώρα;',
		manyChanges: 'Ο ορθογραφικός έλεγχος ολοκληρώθηκε: Άλλαξαν %1 λέξεις.',
		noChanges: 'Ο ορθογραφικός έλεγχος ολοκληρώθηκε: Δεν άλλαξε καμία λέξη.',
		noMispell: 'Ο ορθογραφικός έλεγχος ολοκληρώθηκε: Δεν βρέθηκαν ορθογραφικά λάθη.',
		noSuggestions: '- Καμία πρόταση -',
		notAvailable: 'Λυπούμαστε, αλλά η υπηρεσία δεν είναι διαθέσιμη.',
		notInDic: 'Δεν υπάρχει στο λεξικό',
		oneChange: 'Ο ορθογραφικός έλεγχος ολοκληρώθηκε: Άλλαξε μία λέξη.',
		progress: 'Εκτελείται ορθογραφικός έλεγχος...',
		title: 'Ορθογραφικός έλεγχος',
		toolbar: 'Έλεγχος ορθογραφίας'
	},
	
	scayt :
	{
		about: 'Πληροφορίες για τον ορθογραφικό έλεγχο κατά την πληκτρολόγηση',
		aboutTab: 'Πληροφορίες',
		addWord: 'Προσθήκη λέξης',
		allCaps: 'Παράβλεψη των λέξεων με κεφαλαία γράμματα',
		dic_create: 'Δημιουργία',
		dic_delete: 'Διαγραφή',
		dic_field_name: 'Όνομα λεξικού',
		dic_info: 'Αρχικά, το λεξικό χρήστη αποθηκεύεται σε ένα cookie. Ωστόσο, τα cookies έχουν περιορισμένο μέγεθος. Όταν το λεξικό χρήστη αυξηθεί τόσο ώστε να μην μπορεί να αποθηκευτεί σε ένα cookie, μπορεί να αποθηκευτεί στον εξυπηρετητή μας. Για να αποθηκεύσετε το προσωπικό λεξικό σας στον εξυπηρετητή μας, θα πρέπει να καθορίσετε για αυτό ένα όνομα. Αν έχετε ήδη ένα αποθηκευμένο λεξικό, πληκτρολογήστε το όνομά του και πατήστε το κουμπί Επαναφορά.',
		dic_rename: 'Μετονομασία',
		dic_restore: 'Επαναφορά',
		dictionariesTab: 'Λεξικά',
		disable: 'Απενεργοποίηση ορθογραφικού ελέγχου κατά την πληκτρολόγηση',
		emptyDic: 'Το όνομα του λεξικού δεν μπορεί να είναι κενό.',
		enable: 'Ενεργοποίηση ορθογραφικού ελέγχου κατά την πληκτρολόγηση',
		ignore: 'TESTIgnore',
		ignoreAll: 'Αγνόηση όλων',
		ignoreDomainNames: 'Παράβλεψη ονομάτων τομέων',
		langs: 'Γλώσσες',
		languagesTab: 'Γλώσσες',
		mixedCase: 'Παράβλεψη λέξεων με ταυτόχρονη παρουσία πεζών και κεφαλαίων γραμμάτων',
		mixedWithDigits: 'Παράβλεψη λέξεων με αριθμούς',
		moreSuggestions: 'Περισσότερες προτάσεις',
		opera_title: 'Δεν υποστηρίζεται από το Opera',
		options: 'Επιλογές',
		optionsTab: 'Επιλογές',
		title: 'Ορθογραφικός έλεγχος κατά την πληκτρολόγηση',
		toggle: 'Εναλλαγή ορθογραφικού ελέγχου κατά την πληκτρολόγηση',
		noSuggestions: 'Καμία πρόταση'
	}
	
};

