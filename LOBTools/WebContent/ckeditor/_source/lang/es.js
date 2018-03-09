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

CKEDITOR.lang['es'] =
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
	editorPanel: 'Panel de Rich Text Editor',

	// Common messages and labels.
	common: {
		// Screenreader titles. Please note that screenreaders are not always capable
		// of reading non-English words. So be careful while translating it.
		editorHelp: "Pulse ALT 0 para obtener ayuda",

		browseServer	: "Servidor de navegador:",
		url				: "URL:",
		protocol		: "Protocolo:",
		upload			: "Subir:",
		uploadSubmit	: "Enviar al servidor",
		image			: "Insertar imagen",
		flash			: "Insertar película de flash",
		form			: "Insertar formulario",
		checkbox		: "Insertar recuadro de selección",
		radio			: "Insertar botón de selección",
		textField		: "Insertar campo de texto",
		textarea		: "Insertar área de texto",
		hiddenField		: "Insertar campo oculto",
		button			: "Insertar botón",
		select			: "Insertar campo de selección",
		imageButton		: "Insertar botón de imagen",
		notSet			: "no definido",
		id				: "ID:",
		name			: "Nombre:",
		langDir			: "Dirección del idioma:",
		langDirLtr		: "De izquierda a derecha",
		langDirRtl		: "De derecha a izquierda",
		langCode		: "Código de idioma:",
		longDescr		: "URL de descripción detallada:",
		cssClass		: "Clases de hoja de estilos:",
		advisoryTitle	: "Título consultivo:",
		cssStyle		: "Estilo:",
		ok				: "Aceptar",
		cancel			: "Cancelar",
		close : "Cerrar",
		preview			: "Vista previa:",
		resize			: "Redimensionar",
		generalTab		: "General",
		advancedTab		: "Avanzado",
		validateNumberFailed	: "Este valor no es un número.",
		confirmNewPage	: "Todos los cambios no guardados en este contenido se perderán. ¿Está seguro de que desea cargar una nueva página?",
		confirmCancel	: "Algunas de las opciones se han modificado. ¿Está seguro de que desea cerrar el diálogo?",
		options : "Opciones",
		target			: "Destino:",
		targetNew		: "Nueva ventana (_blank)",
		targetTop		: "Ventana más alta (_top)",
		targetSelf		: "Misma ventana (_self)",
		targetParent	: "Ventana padre (_parent)",
		langDirLTR		: "De izquierda a derecha",
		langDirRTL		: "De derecha a izquierda",
		styles			: "Estilo:",
		cssClasses		: "Clases de hojas de estilo:",
		width			: "Anchura:",
		height			: "Altura:",
		align			: "Alinear:",
		alignLeft		: "Izquierda",
		alignRight		: "Derecha",
		alignCenter		: "Centrar",
		alignJustify	: 'Ajustar',
		alignTop		: "Arriba",
		alignMiddle		: "Medio",
		alignBottom		: "Abajo",
		alignNone		: 'Ninguno',
		invalidValue	: "Valor no válido.",
		invalidHeight	: "La altura debe ser un número entero positivo.",
		invalidWidth	: "El ancho debe ser un número entero positivo.",
		invalidCssLength	: "El valor especificado para el campo '%1' debe ser un número positivo con o sin una unidad de medida CSS válida (px, %, in, cm, mm, em, ex, pt o pc).",
		invalidHtmlLength	: "El valor especificado para el campo '%1' debe ser un número positivo con o sin una unidad de medida HTML válida (px o %).",
		invalidInlineStyle	: "El valor especificado para el estilo en línea debe constar de una o más tuplas con el formato \"nombre : valor\", separadas por el carácter punto y coma.",
		cssLengthTooltip	: "Especifique un número para un valor en píxeles o un número con una unidad CSS válida (px, %, in, cm, mm, em, ex, pt o pc).",

		// Put the voice-only part of the label in the span.
		unavailable		: "%1<span class=\"cke_accessibility\">, no disponible</span>"
	},
	
	ibm :
	{
		common :
		{
			widthIn	: "pulgadas",
			widthCm	: "centímetros",
			widthMm	: "milímetros",
			widthEm	: "em",
			widthEx	: "ex",
			widthPt	: "puntos",
			widthPc	: "picas",
			required : "Obligatorio"
		}
		/*linkdialog : 
		{
			label : "Link Dialog"
		}
		*/		
	},
	
	wsc :
	{
		btnIgnore: 'Ignorar',
		btnIgnoreAll: 'Ignorar todo',
		btnReplace: 'Reemplazar',
		btnReplaceAll: 'Sustituir todo',
		btnUndo: 'Deshacer',
		changeTo: 'Cambiar por',
		errorLoading: 'Error al cargar el host de servicio de aplicación: %s.',
		ieSpellDownload: 'Corrector ortográfico no instalado. ¿Desea descargarlo ahora?',
		manyChanges: 'La comprobación ortográfica ha finalizado: %1 palabras cambiadas.',
		noChanges: 'La comprobación ortográfica ha finalizado: no ha cambiado ninguna palabra.',
		noMispell: 'La comprobación ortográfica ha finalizado: no se ha encontrado ningún error ortográfico',
		noSuggestions: '- Sin sugerencias -',
		notAvailable: 'Lo sentimos pero el servicio ahora no está disponible.',
		notInDic: 'No está en diccionario',
		oneChange: 'La comprobación ortográfica ha finalizado: ha cambiado una palabra.',
		progress: 'Comprobar ortografía en curso...',
		title: 'Comprobar ortografía',
		toolbar: 'Comprobar la ortografía'
	},
	
	scayt :
	{
		about: 'Acerca de SCAYT',
		aboutTab: 'Acerca de',
		addWord: 'Añadir palabra',
		allCaps: 'Ignorar palabras con todas las letras en mayúsculas',
		dic_create: 'Crear',
		dic_delete: 'Suprimir',
		dic_field_name: 'Nombre de diccionario',
		dic_info: 'Inicialmente, el Diccionario de usuario se almacena en una cookie. Sin embargo, las cookies tienen un tamaño limitado. Cuando el diccionario del usuario crece hasta un punto en el cual ya no puede almacenarse en una cookie, debe almacenarse en nuestro servidor. Para almacenar su diccionario personal en nuestro servidor, debe especificar un nombre para su diccionario. Si ya dispone de un diccionario almacenado, escriba su nombre y pulse el botón Restaurar.',
		dic_rename: 'Renombrar',
		dic_restore: 'Restaurar',
		dictionariesTab: 'Diccionarios',
		disable: 'Inhabilitar SCAYT',
		emptyDic: 'El nombre de diccionario no debe estar vacío.',
		enable: 'Habilitar SCAYT',
		ignore: 'TESTIgnore',
		ignoreAll: 'Ignorar todo',
		ignoreDomainNames: 'Ignorar nombres de dominio',
		langs: 'Idiomas',
		languagesTab: 'Idiomas',
		mixedCase: 'Ignorar palabras con mayúsculas y minúsculas',
		mixedWithDigits: 'Ignorar palabras con números',
		moreSuggestions: 'Más sugerencias',
		opera_title: 'No soportado por Opera',
		options: 'Opciones',
		optionsTab: 'Opciones',
		title: 'Revisión ortográfica a medida que escribe',
		toggle: 'Conmutar SCAYT',
		noSuggestions: 'Ninguna sugerencia'
	}
	
};

