/**
 * @license Copyright (c) 2003-2014, CKSource - Frederico Knabben. All rights reserved.
 * For licensing, see LICENSE.md or http://ckeditor.com/licensePortions Copyright IBM Corp., 2009-2015.
 */

CKEDITOR.plugins.setLang( 'a11yhelp', 'es',
{
	//do not translate anything with the form ${xxx} 
	
	title : "Ayuda",
	contents : "Contenidos de la Ayuda. Para cerrar el diálogo pulse ESC.",
	legend :
	[
		{
			name : "Instrucciones de accesibilidad",
			items :
			[
				{
					name : "Barra de herramientas del editor",
					legend: "Pulse ${toolbarFocus} para navegar a la barra de herramientas. " +
						"Para pasar al grupo de barra de herramientas siguiente y anterior, utilice TAB y MAYÚS+TAB. " +
						"Para pasar al botón de barra de herramientas siguiente y anterior, utilice FLECHA DERECHA y FLECHA IZQUIERDA. " +
						"Pulse ESPACIO o INTRO para activar el botón de la barra de herramientas."
				},

				{
					name: "Diálogo del editor",
					legend:
						"Dentro de un diálogo, pulse TABULADOR para ir al siguiente elemento de diálogo, pulse MAYÚSCULAS+TABULADOR para ir al elemento de diálogo anterior, pulse INTRO para enviar el diálogo o pulse ESC para cancelar el diálogo. " +
						"Si un diálogo tiene varios separadores, se puede acceder a la lista de separadores con ALT+F10 o con TABULADOR como parte del orden de separadores del diálogo. " +
						"Con el foco en la lista de separadores, vaya al separador anterior o siguiente con FLECHA DERECHA y FLECHA IZQUIERDA, respectivamente. "
				},

				{
					name : "Menú de contexto del editor",
					legend :
						"Pulse ${contextMenu} o la TECLA DE APLICACIÓN para abrir el menú contextual. " +
						"A continuación, puede pasar a la siguiente opción de menú con TAB o FLECHA ABAJO. " +
						"Puede pasar a la opción anterior con MAYÚS+TAB o FLECHA ARRIBA. " +
						"Pulse ESPACIO o INTRO para seleccionar la opción de menú. " +
						"Abra el submenú de la opción actual con ESPACIO o INTRO o FLECHA DERECHA. " +
						"Vuelva al elemento de menú padre con ESC o FLECHA IZQUIERDA. " +
						"Cierre el menú de contexto con Esc."
				},

				{
					name : "Recuadro de lista del editor",
					legend :
						"Dentro de un recuadro de lista, pase al siguiente elemento de la lista con TAB o FLECHA ABAJO. " +
						"Pase al elemento de lista anterior con MAYÚS + TAB o FLECHA ARRIBA. " +
						"Pulse ESPACIO o INTRO para seleccionar la opción de lista. " +
						"Pulse ESC para cerrar el cuadro de lista."
				},

				{
					name : "Barra de vía de acceso de elementos del editor (si estuviera disponible)",
					legend :
						"Pulse ${elementsPathFocus} para navegar a la barra de vía de acceso de elementos. " +
						"Pase al siguiente botón de elemento con TAB o FLECHA DERECHA. " +
						"Pase al botón anterior con MAYÚS+TAB o FLECHA IZQUIERDA. " +
						"Pulse ESPACIO o INTRO para seleccionar el elemento en el editor."
				}
			]
		},
		{
			name : "Mandatos",
			items :
			[
				{
					name : " Mandato Deshacer",
					legend : "Pulse ${undo}"
				},
				{
					name : " Mandato Rehacer",
					legend : "Pulse ${redo}"
				},
				{
					name : " Mandato Negrita",
					legend : "Pulse ${bold}"
				},
				{
					name : " Mandato Cursiva",
					legend : "Pulse ${italic}"
				},
				{
					name : " Mandato Subrayado",
					legend : "Pulse ${underline}"
				},
				{
					name : " Mandato Enlazar",
					legend : "Pulse ${link}"
				},
				{
					name : " Mandato Contraer barra de herramientas (si estuviera disponible*)",
					legend : "Pulse ${toolbarCollapse}"
				},
				{
					name: ' Mandato de espacio para acceder a foco anterior',
					legend: 'Pulse ${accessPreviousSpace} para insertar un espacio en un espacio de foco al que no se puede acceder directamente delante del cursor. ' +
						'Un espacio de foco al que no se puede acceder es una ubicación en el editor en la que no puede colocar el cursor. ' + 
						'utilizando el teclado o ratón. Por ejemplo: utilice este mandato para insertar contenido entre dos elementos de tabla adyacentes.'
				},
				{
					name: ' Mandato de espacio para acceder al siguiente foco',
					legend: 'Pulse ${accessNextSpace} para insertar un espacio en un espacio de foco al que no se puede acceder directamente después del cursor. ' +
						'Un espacio de foco al que no se puede acceder es una ubicación en el editor en la que no puede colocar el cursor. ' +
						'utilizando el teclado o ratón. Por ejemplo: utilice este mandato para insertar contenido entre dos elementos de tabla adyacentes.'
				},
				{
					name : " Aumentar sangría",
					legend : "Pulse ${indent}"
				},
				{
					name : " Reducir sangría",
					legend : "Pulse ${outdent}"
				},				
				{
					name : " Dirección del texto de izquierda a derecha",
					legend : "Pulse ${bidiltr}"
				},
				{
					name : " Dirección del texto de derecha a izquierda",
					legend : "Pulse ${bidirtl}"
				},
				{
					name: ' Bolígrafo permanente',
					legend: 'Pulse ${ibmpermanentpen} (Alt+Cmd+T en MAC) dentro del editor para activar/desactivar el bolígrafo permanente.'
				},
				{
					name : " Ayuda para la accesibilidad",
					legend : "Pulse ${a11yHelp}"
				}
			]
		},
		
		{	//added by ibm
			name : "Nota",
			items :
			[
				{	
					name : "",
					legend : "* El administrador podría haber inhabilitado algunas características."
				}
			]
		}
	],
	backspace: 'Retroceso',
	tab: 'Separador',
	enter: 'Intro',
	shift: 'Mayús',
	ctrl: 'Ctrl',
	alt: 'Alt',
	pause: 'Pausa',
	capslock: 'Bloq Mayús',
	escape: 'Esc',
	pageUp: 'Re Pág',
	pageDown: 'Av Pág',
	end: 'Fin',
	home: 'Inicio',
	leftArrow: 'Flecha hacia la izquierda',
	upArrow: 'Flecha hacia arriba',
	rightArrow: 'Flecha hacia la derecha',
	downArrow: 'Flecha hacia abajo',
	insert: 'Insertar',
	'delete': 'Suprimir',
	leftWindowKey: 'Tecla de Windows de la izquierda',
	rightWindowKey: 'Tecla de Windows de la derecha',
	selectKey: 'Seleccionar tecla',
	numpad0: '0 de teclado numérico',
	numpad1: '1 de teclado numérico',
	numpad2: '2 de teclado numérico',
	numpad3: '3 de teclado numérico',
	numpad4: '4 de teclado numérico',
	numpad5: '5 de teclado numérico',
	numpad6: '6 de teclado numérico',
	numpad7: '7 de teclado numérico',
	numpad8: '8 de teclado numérico',
	numpad9: '9 de teclado numérico',
	multiply: 'Multiplicar',
	add: 'Añadir',
	subtract: 'Restar',
	decimalPoint: 'Coma decimal',
	divide: 'Dividir',
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
	numLock: 'Bloq Num',
	scrollLock: 'Bloq Despl',
	semiColon: 'Punto y coma',
	equalSign: 'Signo igual',
	comma: 'Coma',
	dash: 'Guión',
	period: 'Punto',
	forwardSlash: 'Barra',
	graveAccent: 'Acento grave',
	openBracket: 'Abrir corchete',
	backSlash: 'Barra invertida',
	closeBracket: 'Cerrar corchete',
	singleQuote: 'Comillas sencillas',
	
	ibm :
	{
		helpLinkDescription : "Abrir más temas de ayuda en una ventana nueva",
		helpLink : "Más temas de ayuda"
	}

});

