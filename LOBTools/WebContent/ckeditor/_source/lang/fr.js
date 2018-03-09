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

CKEDITOR.lang['fr'] =
{
	/**
	 * The language reading direction. Possible values are "rtl" for
	 * Right-To-Left languages (like Arabic) and "ltr" for Left-To-Right
	 * languages (like English).
	 * @default "ltr"
	 */
	dir : "ltr",
	
	// ARIA descriptions.
	editor	: "Editeur de texte enrichi",
	editorPanel: 'Panneau de l\'éditeur de texte enrichi',

	// Common messages and labels.
	common: {
		// Screenreader titles. Please note that screenreaders are not always capable
		// of reading non-English words. So be careful while translating it.
		editorHelp: "Appuyez sur ALT 0 pour obtenir de l'aide",

		browseServer	: "Serveur d'exploration :",
		url				: "Adresse URL :",
		protocol		: "Protocole :",
		upload			: "Envoi par téléchargement :",
		uploadSubmit	: "L'envoyer au serveur",
		image			: "Insérer une image",
		flash			: "Insérer un film Flash",
		form			: "Insérer un formulaire",
		checkbox		: "Insérer une case à cocher",
		radio			: "Insérer un bouton radio",
		textField		: "Insérer un champ de texte",
		textarea		: "Insérer une zone de texte",
		hiddenField		: "Insérer une zone masquée",
		button			: "Insérer un bouton",
		select			: "Insérer une zone de sélection",
		imageButton		: "Insérer un bouton d'image",
		notSet			: "non défini",
		id				: "ID:",
		name			: "Nom :",
		langDir			: "Sens de la langue :",
		langDirLtr		: "De gauche à droite",
		langDirRtl		: "De droite à gauche",
		langCode		: "Code de la langue :",
		longDescr		: "URL de description longue :",
		cssClass		: "Classes de feuille de style :",
		advisoryTitle	: "Titre de recommandation :",
		cssStyle		: "Style :",
		ok				: "OK",
		cancel			: "Annuler",
		close : "Fermer",
		preview			: "Aperçu :",
		resize			: "Redimensionner",
		generalTab		: "Général",
		advancedTab		: "Avancé",
		validateNumberFailed	: "Cette valeur n'est pas un nombre.",
		confirmNewPage	: "Toutes les modifications non enregistrées qui ont été apportées à ce contenu seront perdues. Etes-vous sûr de vouloir charger une nouvelle page ?",
		confirmCancel	: "Certaines options ont été modifiées. Etes-vous sûr de vouloir vraiment fermer la boîte de dialogue ?",
		options : "Options",
		target			: "Cible :",
		targetNew		: "Nouvelle fenêtre (_vide)",
		targetTop		: "Fenêtre de 1er plan (_haut)",
		targetSelf		: "Même fenêtre (_auto)",
		targetParent	: "Fenêtre parente (_parent)",
		langDirLTR		: "De gauche à droite",
		langDirRTL		: "De droite à gauche",
		styles			: "Style :",
		cssClasses		: "Classes de feuille de style :",
		width			: "Largeur :",
		height			: "Hauteur :",
		align			: "Aligner :",
		alignLeft		: "Gauche",
		alignRight		: "Droite",
		alignCenter		: "Centre",
		alignJustify	: 'Justifier',
		alignTop		: "Haut",
		alignMiddle		: "Milieu",
		alignBottom		: "Bas",
		alignNone		: 'Aucun',
		invalidValue	: "Valeur non valide.",
		invalidHeight	: "La hauteur doit être un nombre entier positif.",
		invalidWidth	: "La largeur doit être un nombre entier positif.",
		invalidCssLength	: "La valeur spécifiée pour la zone '%1' doit un nombre positif avec ou sans unité de mesure CSS valide (px, %, in, cm, mm, em, ex, pt ou pc).",
		invalidHtmlLength	: "La valeur indiquée pour la zone '%1' doit être un nombre positif avec ou sans unité de mesure HTML valide (px ou %).",
		invalidInlineStyle	: "La valeur indiquée pour le style en ligne doit se composer d'un ou plusieurs uplets avec le format \"nom : valeur\", séparées par des points-virgules.",
		cssLengthTooltip	: "Entrez un nombre pour une valeur en pixels ou un nombre avec une unité CSS valide (px,%, in, cm, mm, em, ex, pt ou pc).",

		// Put the voice-only part of the label in the span.
		unavailable		: "%1<span class=\"cke_accessibility\">, indisponible</span>"
	},
	
	ibm :
	{
		common :
		{
			widthIn	: "pouces",
			widthCm	: "centimètres",
			widthMm	: "millimètres",
			widthEm	: "em",
			widthEx	: "ex",
			widthPt	: "points",
			widthPc	: "points pica",
			required : "Obligatoire"
		}
		/*linkdialog : 
		{
			label : "Link Dialog"
		}
		*/		
	},
	
	wsc :
	{
		btnIgnore: 'Ignorer',
		btnIgnoreAll: 'Ignorer tout',
		btnReplace: 'Remplacer',
		btnReplaceAll: 'Remplacer tout',
		btnUndo: 'Annuler',
		changeTo: 'Modifier à',
		errorLoading: 'Erreur lors du chargement de l\'hôte du service d\'application : %s.',
		ieSpellDownload: 'Le vérificateur orthographique n\'est pas installé. Voulez-vous le télécharger maintenant ?',
		manyChanges: 'Vérification orthographique : %1 mots modifiés',
		noChanges: 'Vérification orthographique terminée : aucun mot modifié',
		noMispell: 'Vérification orthographique terminée : aucune erreur d\'orthographe trouvée',
		noSuggestions: '- Aucune suggestion -',
		notAvailable: 'Désolé, mais le service est actuellement indisponible.',
		notInDic: 'Absent du dictionnaire',
		oneChange: 'Vérification orthographique terminée : un mot modifié',
		progress: 'Vérification orthographique en cours...',
		title: 'Vérification orthographique',
		toolbar: 'Vérification orthographique'
	},
	
	scayt :
	{
		about: 'A propos de SCAYT',
		aboutTab: 'A propos de',
		addWord: 'Ajouter un mot',
		allCaps: 'Ignorer les mots en majuscules',
		dic_create: 'Créer',
		dic_delete: 'Supprimer',
		dic_field_name: 'Nom du dictionnaire',
		dic_info: 'A l\'origine, le dictionnaire utilisateur est stocké dans un cookie. Toutefois, les cookies sont limités en taille. Quand le dictionnaire utilisateur devient trop volumineux pour être stocké dans un cookie, il peut être enregistré sur notre serveur. Pour stocker votre dictionnaire personnel sur notre serveur, vous devez lui donner un nom. Si vous avez déjà un dictionnaire stocké, entrez son nom et cliquez sur le bouton Restaurer.',
		dic_rename: 'Renommer',
		dic_restore: 'Restaurer',
		dictionariesTab: 'Dictionnaires',
		disable: 'Désactiver SCAYT',
		emptyDic: 'Le nom du dictionnaire ne doit pas être vide.',
		enable: 'Activer SCAYT',
		ignore: 'TESTIgnore',
		ignoreAll: 'Ignorer tout',
		ignoreDomainNames: 'Ignorer les noms de domaine',
		langs: 'Langues',
		languagesTab: 'Langues',
		mixedCase: 'Ignorer les mots à casse mixte',
		mixedWithDigits: 'Ignorer les mots comportant des chiffres',
		moreSuggestions: 'Suggestions supplémentaires',
		opera_title: 'Non pris en charge par Opera',
		options: 'Options',
		optionsTab: 'Options',
		title: 'Vérifier l\'orthographe pendant la saisie',
		toggle: 'Activer/désactiver SCAYT',
		noSuggestions: 'Aucune suggestion'
	}
	
};

