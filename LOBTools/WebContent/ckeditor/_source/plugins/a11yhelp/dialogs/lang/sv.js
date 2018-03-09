/**
 * @license Copyright (c) 2003-2014, CKSource - Frederico Knabben. All rights reserved.
 * For licensing, see LICENSE.md or http://ckeditor.com/licensePortions Copyright IBM Corp., 2009-2015.
 */

CKEDITOR.plugins.setLang( 'a11yhelp', 'sv',
{
	//do not translate anything with the form ${xxx} 
	
	title : "Hjälp",
	contents : "Hjälpinnehåll. Om du vill stänga dialogrutan trycker du på ESC.",
	legend :
	[
		{
			name : "Instruktioner för hjälpmedelsfunktioner",
			items :
			[
				{
					name : "Verktygsfältet i redigeraren",
					legend: "Om du vill gå till verktygsfältet trycker du på ${toolbarFocus}. " +
						"Om du vill gå till nästa eller föregående verktygsfältsgrupp trycker du på Tabb respektive Skift+Tabb. " +
						"Om du vill gå till nästa eller föregående verktygsfältsknapp trycker du på Högerpil respektive Vänsterpil. " +
						"Om du vill aktivera verktygsfältsknappen trycker du på mellanslag eller Enter."
				},

				{
					name: "Dialogrutor i redigeraren",
					legend:
						"Om du vill gå till nästa element i en dialogruta trycker du på Tabb. Om du vill gå till föregående element trycker du på Skift+Tabb. Om du vill acceptera inställningarna och stänga dialogrutan trycker du på Enter. Om du vill stänga dialogrutan trycker du på Esc. " +
						"När en dialogruta innehåller flera fliksidor kan fliklistan visas antingen med Alt+F10 eller med Tabb som en del av dialogrutans flikordning. " +
						"När tabblistan är i fokus kan du flytta till nästa och föregående flik med Höger- respektiva Vänsterpil."
				},

				{
					name : "Snabbmenyn i redigeraren",
					legend :
						"Om du vill visa snabbmenyn trycker du på ${contextMenu} eller programtangenten. " +
						"Om du vill gå till nästa menyalternativ trycker du på Tabb eller Nedåtpil. " +
						"Om du vill gå till föregående menyalternativ trycker du på Skift+Tabb eller Uppåtpil. " +
						"Om du vill välja menyalternativet trycker du på mellanslag eller Enter. " +
						"Om du vill öppna en undermeny till det aktuella menyalternativet trycker du på mellanslag, Enter eller Högerpil. " +
						"Om du vill gå tillbaka till den överordnade menyn trycker du på Esc eller Vänsterpil. " +
						"Om du vill stänga snabbmenyn trycker du på ESC."
				},

				{
					name : "Listrutor i redigeraren",
					legend :
						"Om du vill gå till nästa alternativ i en listruta trycker du på Tabb eller Nedåtpil. " +
						"Om du vill gå till föregående alternativ trycker du på Skift+Tabb eller Uppåtpil. " +
						"Om du vill välja alternativet trycker du på mellanslag eller Enter. " +
						"Om du vill stänga listrutan trycker du på Esc."
				},

				{
					name : "Fältet för sökvägselement i redigeraren (om tillgängligt*)",
					legend :
						"Om du vill gå till fältet för sökvägselement trycker du på ${elementsPathFocus}. " +
						"Om du vill gå till nästa elementknapp trycker du på Tabb eller Högerpil. " +
						"Om du vill gå till föregående elementknapp trycker du på Skift+Tabb eller Vänsterpil. " +
						"Om du vill välja elementet i redigeraren trycker du på mellanslag eller Enter."
				}
			]
		},
		{
			name : "Kommandon",
			items :
			[
				{
					name : "  Ångra",
					legend : "Tryck på ${undo}."
				},
				{
					name : "  Gör om",
					legend : "Tryck på ${redo}."
				},
				{
					name : "  Halvfet",
					legend : "Tryck på ${bold}."
				},
				{
					name : "  Kursiv stil",
					legend : "Tryck på ${italic}."
				},
				{
					name : "  Understrykning",
					legend : "Tryck på ${underline}."
				},
				{
					name : "  Länk",
					legend : "Tryck på ${link}."
				},
				{
					name : "  Komprimera verktygsfältet (om tillgängligt*)",
					legend : "Tryck på ${toolbarCollapse}."
				},
				{
					name: '  Gå till föregående fokusplats',
					legend: 'Tryck på ${accessPreviousSpace} om du vill infoga ett blanktecken omedelbart före markören i ett fokusområde som det inte går att gå till. ' +
						'Ett fokusområde som det inte går att gå till är en plats där du inte kan placera markören ' + 
						'med hjälp av musen eller tangentbordet. Du kan till exempel använda det här kommandot till att infoga innehåll mellan två intilliggande tabellelement.'
				},
				{
					name: '  Gå till nästa fokusplats',
					legend: 'Tryck på ${accessNextSpace} om du vill infoga ett blanktecken omedelbart efter markören i ett fokusområde som det inte går att gå till. ' +
						'Ett fokusområde som det inte går att gå till är en plats där du inte kan placera markören ' +
						'med hjälp av musen eller tangentbordet. Du kan till exempel använda det här kommandot till att infoga innehåll mellan två intilliggande tabellelement.'
				},
				{
					name : " Öka indrag",
					legend : "Tryck på ${indent} (gäller endast för amerikanska tangentbord)."
				},
				{
					name : " Minska indrag",
					legend : "Tryck på ${outdent} (gäller endast för amerikanska tangentbord)."
				},				
				{
					name : " Textriktning från vänster till höger",
					legend : "Tryck på ${bidiltr}."
				},
				{
					name : " Textriktning från höger till vänster",
					legend : "Tryck på ${bidirtl}."
				},
				{
					name: ' Permanent penna',
					legend: 'Tryck på ${ibmpermanentpen} (Alt+Cmd+T på MAC) i redigeraren för att aktivera/avaktivera den permanenta pennan.'
				},
				{
					name : " Hjälp för hjälpmedelsfunktioner",
					legend : "Tryck på ${a11yHelp}."
				}
			]
		},
		
		{	//added by ibm
			name : "Anm.",
			items :
			[
				{	
					name : "",
					legend : "* Administratören kan ha avaktiverat vissa funktioner."
				}
			]
		}
	],
	backspace: 'Backsteg',
	tab: 'Tabb',
	enter: 'Enter',
	shift: 'Skift',
	ctrl: 'Ctrl',
	alt: 'Alt',
	pause: 'Pause',
	capslock: 'Caps Lock',
	escape: 'Esc',
	pageUp: 'Page Up',
	pageDown: 'Page Down',
	end: 'End',
	home: 'Home',
	leftArrow: 'Vänsterpil',
	upArrow: 'Uppåtpil',
	rightArrow: 'Högerpil',
	downArrow: 'Nedåtpil',
	insert: 'Insert',
	'delete': 'Delete',
	leftWindowKey: 'Vänster Windows-tangent',
	rightWindowKey: 'Höger Windows-tangent',
	selectKey: 'Välj tangent',
	numpad0: '0 på det numeriska tangentbordet',
	numpad1: '1 på det numeriska tangentbordet',
	numpad2: '2 på det numeriska tangentbordet',
	numpad3: '3 på det numeriska tangentbordet',
	numpad4: '4 på det numeriska tangentbordet',
	numpad5: '5 på det numeriska tangentbordet',
	numpad6: '6 på det numeriska tangentbordet',
	numpad7: '7 på det numeriska tangentbordet',
	numpad8: '8 på det numeriska tangentbordet',
	numpad9: '9 på det numeriska tangentbordet',
	multiply: '× på det numeriska tangentbordet',
	add: '+ på det numeriska tangentbordet',
	subtract: '- på det numeriska tangentbordet',
	decimalPoint: 'Decimalkomma',
	divide: '÷ på det numeriska tangentbordet',
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
	semiColon: 'Semikolon',
	equalSign: 'Lika med',
	comma: 'Kommatecken',
	dash: 'Bindestreck',
	period: 'Punkt',
	forwardSlash: 'Snedstreck',
	graveAccent: 'Grav accent',
	openBracket: 'Vänsterparentest',
	backSlash: 'Bakstreck',
	closeBracket: 'Högerparentes',
	singleQuote: 'Enkelt citattecken',
	
	ibm :
	{
		helpLinkDescription : "Visa fler hjälpavsnitt i ett nytt fönster",
		helpLink : "Fler hjälpavsnitt"
	}

});

