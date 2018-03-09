/**
 * @license Copyright (c) 2003-2014, CKSource - Frederico Knabben. All rights reserved.
 * For licensing, see LICENSE.md or http://ckeditor.com/licensePortions Copyright IBM Corp., 2009-2015.
 */

CKEDITOR.plugins.setLang( 'a11yhelp', 'fr',
{
	//do not translate anything with the form ${xxx} 
	
	title : "Aide",
	contents : "Table des matières. Pour fermer la boîte de dialogue, appuyez sur Echap.",
	legend :
	[
		{
			name : "Instructions relatives à l'accessibilité",
			items :
			[
				{
					name : "Barre d'outils de l'éditeur",
					legend: "Appuyez sur ${toolbarFocus} pour accéder à la barre d'outils. " +
						"Accédez au groupe de barre d'outils suivant et précédent avec TAB et MAJ+TAB. " +
						"Accédez au bouton de la barre d'outils suivant et précédent avec FLECHE DROITE ou FLECHE GAUCHE. " +
						"Appuyez sur ESPACE ou ENTREE pour activer le bouton de la barre d'outils."
				},

				{
					name: "Boîte de dialogue de l'éditeur",
					legend:
						"Dans une boîte de dialogue, appuyez sur la touche TAB pour accéder à l'élément de boîte de dialogue suivant, appuyez sur MAJ+TAB pour passer à l'élément de boîte de dialogue précédent, appuyez sur Entrée pour soumettre la boîte de dialogue et appuyez sur ECHAP pour annuler la boîte de dialogue." +
						"Lorsqu'une boîte de dialogue comporte plusieurs onglets, la liste des onglets peut être affichée en appuyant sur ALT+F10 ou TAB dans l'ordre de tabulation de la boîte de dialogue. " +
						"Lorsque la liste des onglets est mise en évidence, passez aux onglets suivant et précédent en utilisant respectivement FLECHE DROITE et FLECHE GAUCHE. "
				},

				{
					name : "Menu en incrustation de l'éditeur",
					legend :
						"Appuyez sur ${contextMenu} ou sur la TOUCHE APPLICATION pour ouvrir le menu contextuel. " +
						"Ensuite, passez à l'option de menu suivante à l'aide de la touche TAB ou FLECHE VERS LE BAS. " +
						"Accédez à l'option précédente à l'aide des touches MAJ+TAB ou FLECHE VERS LE HAUT. " +
						"Appuyez sur BARRE D'ESPACEMENT ou ENTREE pour sélectionner l'option de menu. " +
						"Ouvrez le sous-menu de l'option actuelle à l'aide de la BARRE D'ESPACEMENT, de la touche ENTREE ou de la FLECHE DROITE. " +
						"Pour revenir à l'élément de menu parent, appuyez sur la touche ECHAP ou FLECHE GAUCHE. " +
						"Pour fermer le menu en incrustation, appuyez sur la touche ECHAP."
				},

				{
					name : "Zone de liste de l'éditeur",
					legend :
						"Dans une zone de liste, passez à l'élément de liste suivant à l'aide de la touche TAB ou FLECHE VERS LE BAS. " +
						"Accédez à l'élément de liste précédent à l'aide des touches MAJ + TAB ou FLECHE VERS LE HAUT. " +
						"Appuyez sur BARRE D'ESPACEMENT ou ENTREE pour sélectionner l'option de liste. " +
						"Appuyez sur ECHAP pour fermer la zone de liste. "
				},

				{
					name : "Barre du chemin d'accès aux éléments de l'éditeur (si disponible*)",
					legend :
						"Appuyez sur ${elementsPathFocus} pour accéder à la barre du chemin d'accès aux éléments. " +
						"Accédez au bouton de l'élément suivant à l'aide de la touche TAB ou FLECHE DROITE. " +
						"Accédez au bouton précédent à l'aide des touches MAJ+TAB ou FLECHE DROITE. " +
						"Appuyez sur ESPACE ou ENTREE pour sélectionner l'élément dans l'éditeur."
				}
			]
		},
		{
			name : "Commandes",
			items :
			[
				{
					name : " Commande Annuler",
					legend : "Appuyez sur ${undo}"
				},
				{
					name : " Commande Rétablir",
					legend : "Appuyez sur ${redo}"
				},
				{
					name : " Commande Gras",
					legend : "Appuyez sur ${bold}"
				},
				{
					name : " Commande Italique",
					legend : "Appuyez sur ${italic}"
				},
				{
					name : " Commande Souligner",
					legend : "Appuyez sur ${underline}"
				},
				{
					name : " Commande Lier",
					legend : "Appuyez sur ${link}"
				},
				{
					name : " Commande de réduction de la barre d'outils (si disponible*)",
					legend : "Appuyez sur ${toolbarCollapse}"
				},
				{
					name: ' Commande d\'accès à l\'espace de mise en évidence précédent',
					legend: 'Appuyez sur ${accessPreviousSpace} pour insérer un espace dans un espace de mise en évidence inaccessible directement avant le curseur. ' +
						'Une zone de mise en évidence inaccessible est un emplacement de l\'éditeur dans lequel vous ne pouvez pas placer le curseur ' + 
						'à l\'aide de la souris ou du clavier. Par exemple : utilisez cette commande pour insérer du contenu entre deux éléments de table adjacents.'
				},
				{
					name: ' Commande d\'accès à l\'espace de mise en évidence précédent',
					legend: 'Appuyez sur ${accessNextSpace} pour insérer un espace dans un espace de mise en évidence inaccessible directement après le curseur. ' +
						'Une zone de mise en évidence inaccessible est un emplacement de l\'éditeur dans lequel vous ne pouvez pas placer le curseur ' +
						'à l\'aide de la souris ou du clavier. Par exemple : utilisez cette commande pour insérer du contenu entre deux éléments de table adjacents.'
				},
				{
					name : " Augmenter le retrait",
					legend : "Appuyez sur ${indent}"
				},
				{
					name : " Diminuer le retrait",
					legend : "Appuyez sur ${outdent}"
				},				
				{
					name : " Direction du texte de gauche à droite",
					legend : "Appuyez sur ${bidiltr}"
				},
				{
					name : " Direction du texte de droite à gauche",
					legend : "Appuyez sur ${bidirtl}"
				},
				{
					name: ' Outil de révision',
					legend: 'Appuyez sur ${ibmpermanentpen} (Alt+Cmd+T sur Mac) au sein de l\'éditeur pour activer/désactiver l\'outil de révision.'
				},
				{
					name : " Aide sur l'accessibilité",
					legend : "Appuyez sur ${a11yHelp}"
				}
			]
		},
		
		{	//added by ibm
			name : "Note",
			items :
			[
				{	
					name : "",
					legend : "* Certaines fonctions peuvent avoir été désactivées par votre administrateur."
				}
			]
		}
	],
	backspace: 'Retour arrière',
	tab: 'Tab',
	enter: 'Entrée',
	shift: 'Maj',
	ctrl: 'Ctrl',
	alt: 'Alt',
	pause: 'Pause',
	capslock: 'Verr maj',
	escape: 'Echap',
	pageUp: 'Pg préc.',
	pageDown: 'Pg suiv.',
	end: 'Fin',
	home: 'Domicile',
	leftArrow: 'Flèche gauche',
	upArrow: 'Flèche haut',
	rightArrow: 'Flèche droite',
	downArrow: 'Flèche bas',
	insert: 'Inser',
	'delete': 'Supprimer',
	leftWindowKey: 'Touche Windows gauche',
	rightWindowKey: 'Touche Windows droite',
	selectKey: 'Touche de sélection',
	numpad0: 'Pavé num 0',
	numpad1: 'Pavé num 1',
	numpad2: 'Pavé num 2',
	numpad3: 'Pavé num 3',
	numpad4: 'Pavé num 4',
	numpad5: 'Pavé num 5',
	numpad6: 'Pavé num 6',
	numpad7: 'Pavé num 7',
	numpad8: 'Pavé num 8',
	numpad9: 'Pavé num 9',
	multiply: 'Multiplier',
	add: 'Ajouter',
	subtract: 'Soustraire',
	decimalPoint: 'Séparateur décimal',
	divide: 'Diviser',
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
	numLock: 'Verr num',
	scrollLock: 'Arrêt défil',
	semiColon: 'Point-virgule',
	equalSign: 'Signe égal',
	comma: 'Virgule',
	dash: 'Tiret',
	period: 'Point',
	forwardSlash: 'Barre oblique',
	graveAccent: 'Accent grave',
	openBracket: 'Crochet ouvrant',
	backSlash: 'Barre oblique inverse',
	closeBracket: 'Crochet fermant',
	singleQuote: 'Guillemet simple',
	
	ibm :
	{
		helpLinkDescription : "Ouvrir davantage de rubriques d'aide dans une nouvelle fenêtre",
		helpLink : "Plus de rubriques d'aide"
	}

});

