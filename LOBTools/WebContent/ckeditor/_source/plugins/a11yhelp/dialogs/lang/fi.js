/**
 * @license Copyright (c) 2003-2014, CKSource - Frederico Knabben. All rights reserved.
 * For licensing, see LICENSE.md or http://ckeditor.com/licensePortions Copyright IBM Corp., 2009-2015.
 */

CKEDITOR.plugins.setLang( 'a11yhelp', 'fi',
{
	//do not translate anything with the form ${xxx} 
	
	title : "Ohje",
	contents : "Ohjeen sisältö. Voit sulkea tämän valintaikkunan painamalla ESC-näppäintä.",
	legend :
	[
		{
			name : "Helppokäyttötoimintojen ohjeet",
			items :
			[
				{
					name : "Muokkausohjelman työkalurivi",
					legend: "Siirry työkaluriville painamalla näppäintä ${toolbarFocus}. " +
						"Siirry seuraavaan tai edelliseen työkaluriviryhmään painamalla SARKAINTA tai näppäinyhdistelmää VAIHTO+SARKAIN." +
						"Siirry seuraavaan tai edelliseen työkalurivin painikkeeseen painamalla OIKEAA tai VASENTA NUOLINÄPPÄINTÄ. " +
						"Aktivoi työkalurivin painike painamalla VÄLILYÖNTIÄ tai ENTER-näppäintä."
				},

				{
					name: "Muokkaaja-valintaikkuna",
					legend:
						"Valintaikkunassa voit siirtyä seuraavaan valintaikkunan elementtiin painamalla SARKAINTA, siirtyä edelliseen elementtiin painamalla näppäinyhdistelmää VAIHTO+SARKAIN, lähettää valintaikkunassa tehdyt muutokset painamalla ENTER-näppäintä ja peruuttaa valintaikkunassa tehdyt muutokset painamalla ESC-näppäintä. " +
						"Jos valintaikkunassa on useita välilehtiä, välilehtiluetteloa voi käyttää joko näppäinyhdistelmällä ALT+F10 tai SARKAIMELLA osana valintaikkunan sarkainjärjestystä. " +
						"Kun kohdistus on välilehtiluettelossa, voit siirtyä seuraavaan välilehteen OIKEALLA ja edelliseen välilehteen VASEMMALLA NUOLINÄPPÄIMELLÄ."
				},

				{
					name : "Muokkausohjelman pikavalikko",
					legend :
						"Avaa pikavalikko painamalla näppäintä ${contextMenu} tai SOVELLUSNÄPPÄINTÄ. " +
						"Siirry sitten seuraavaan valikon vaihtoehtoon painamalla SARKAINTA tai ALANUOLINÄPPÄINTÄ. " +
						"Siirry edelliseen vaihtoehtoon painamalla YLÄNUOLINÄPPÄINTÄ tai näppäinyhdistelmää VAIHTO+SARKAIN. " +
						"Valitse valikon vaihtoehto painamalla VÄLILYÖNTIÄ tai ENTER-näppäintä. " +
						"Avaa nykyisen vaihtoehdon alivalikko painamalla VÄLILYÖNTIÄ, ENTER-näppäintä tai OIKEAA NUOLINÄPPÄINTÄ. " +
						"Palaa valikon päävaihtoehtoon painamalla ESC-näppäintä tai VASENTA NUOLINÄPPÄINTÄ. " +
						"Sulje pikavalikko painamalla ESC-näppäintä."
				},

				{
					name : "Muokkausohjelman luetteloruutu",
					legend :
						"Siirry luetteloruudussa seuraavaan luettelokohtaan painamalla SARKAINTA tai ALANUOLINÄPPÄINTÄ. " +
						"Siirry edelliseen luettelokohtaan painamalla YLÄNUOLINÄPPÄINTÄ tai näppäinyhdistelmää VAIHTO+SARKAIN. " +
						"Valitse luettelon kohta painamalla VÄLILYÖNTIÄ tai ENTER-näppäintä. " +
						"Sulje luetteloruutu painamalla ESC-näppäintä."
				},

				{
					name : "Muokkausohjelman elementtien polku -palkki (jos se on käytettävissä*)",
					legend :
						"Siirry elementtien polku -palkkiin painamalla näppäintä ${elementsPathFocus}. " +
						"Siirry seuraavaan elementtipainikkeeseen painamalla SARKAINTA tai OIKEAA NUOLINÄPPÄINTÄ. " +
						"Siirry edelliseen painikkeeseen painamalla VASENTA NUOLINÄPPÄINTÄ tai näppäinyhdistelmää VAIHTO + SARKAIN. " +
						"Valitse muokkausohjelman elementti painamalla VÄLILYÖNTIÄ tai ENTER-näppäintä."
				}
			]
		},
		{
			name : "Komennot",
			items :
			[
				{
					name : "  Kumoa komento",
					legend : "Valitse ${undo}"
				},
				{
					name : "  Tee komento uudelleen",
					legend : "Valitse ${redo}"
				},
				{
					name : "  Lihavoinnin komento",
					legend : "Valitse ${bold}"
				},
				{
					name : " Kursivoinnin komento",
					legend : "Valitse ${italic}"
				},
				{
					name : "  Alleviivauksen komento",
					legend : "Valitse ${underline}"
				},
				{
					name : "  Linkityksen komento",
					legend : "Valitse ${link}"
				},
				{
					name : " Työkalurivin pienennyskomento (jos se on käytettävissä*)",
					legend : "Valitse ${toolbarCollapse}"
				},
				{
					name: '  Siirry edelliseen kohdistustilaan -komento',
					legend: 'Painamalla ${accessPreviousSpace} voit lisätä välilyönnin tavoittamattomissa olevaan tarkennusalueeseen juuri ennen kohdistinta. ' +
						'Tavoittamattomissa oleva tarkennusalue on muokkausohjelman sijainti, johon kohdistinta ei voi asettaa ' + 
						'käyttämällä hiirtä tai näppäimistöä. Esimerkki: lisää sisältöä kahden vierekkäisen taulukkoelementin väliin käyttämällä tätä komentoa.'
				},
				{
					name: '  Siirry seuraavaan kohdistustilaan -komento',
					legend: 'Painamalla ${accessNextSpace} voit lisätä välilyönnin tavoittamattomissa olevaan tarkennusalueeseen juuri kohdistimen jälkeen. ' +
						'Tavoittamattomissa oleva tarkennusalue on muokkausohjelman sijainti, johon kohdistinta ei voi asettaa ' +
						'käyttämällä hiirtä tai näppäimistöä. Esimerkki: lisää sisältöä kahden vierekkäisen taulukkoelementin väliin käyttämällä tätä komentoa.'
				},
				{
					name : " Suurenna sisennystä",
					legend : "Valitse ${indent}"
				},
				{
					name : " Pienennä sisennystä",
					legend : "Valitse ${outdent}"
				},				
				{
					name : " Tekstin suunta vasemmalta oikealle",
					legend : "Valitse ${bidiltr}"
				},
				{
					name : " Tekstin suunta oikealta vasemmalle",
					legend : "Valitse ${bidirtl}"
				},
				{
					name: ' Oma kynä',
					legend: 'Ota oma kynä käyttöön tai poista se käytöstä painamalla ${ibmpermanentpen} (Mac: Optio+Komento+T) muokkausohjelman sisällä.'
				},
				{
					name : "  Helppokäyttötoimintojen ohje",
					legend : "Valitse ${a11yHelp}"
				}
			]
		},
		
		{	//added by ibm
			name : "Huomautus",
			items :
			[
				{	
					name : "",
					legend : "* Pääkäyttäjä on voinut poistaa käytöstä joitakin ominaisuuksia."
				}
			]
		}
	],
	backspace: 'Askelpalautin',
	tab: 'Sarkain',
	enter: 'Enter',
	shift: 'Vaihto',
	ctrl: 'Ctrl',
	alt: 'Alt',
	pause: 'Pause',
	capslock: 'Caps Lock',
	escape: 'Esc',
	pageUp: 'Page Up',
	pageDown: 'Page Down',
	end: 'End',
	home: 'Home',
	leftArrow: 'Vasen nuolinäppäin',
	upArrow: 'Ylänuolinäppäin',
	rightArrow: 'Oikea nuolinäppäin',
	downArrow: 'Alanuolinäppäin',
	insert: 'Insert',
	'delete': 'Delete',
	leftWindowKey: 'Vasen Windows-näppäin',
	rightWindowKey: 'Oikea Windows-näppäin',
	selectKey: 'Valitse näppäin',
	numpad0: 'Numeronäppäimistön 0',
	numpad1: 'Numeronäppäimistön 1',
	numpad2: 'Numeronäppäimistön 2',
	numpad3: 'Numeronäppäimistön 3',
	numpad4: 'Numeronäppäimistön 4',
	numpad5: 'Numeronäppäimistön 5',
	numpad6: 'Numeronäppäimistön 6',
	numpad7: 'Numeronäppäimistön 7',
	numpad8: 'Numeronäppäimistön 8',
	numpad9: 'Numeronäppäimistön 9',
	multiply: 'Kertomerkki',
	add: 'Plusmerkki',
	subtract: 'Miinusmerkki',
	decimalPoint: 'Desimaalierotin',
	divide: 'Jakomerkki',
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
	semiColon: 'Puolipiste',
	equalSign: 'Yhtäläisyysmerkki',
	comma: 'Pilkku',
	dash: 'Yhdysmerkki',
	period: 'Piste',
	forwardSlash: 'Vinoviiva',
	graveAccent: 'Gravis-aksentti',
	openBracket: 'Vasen sulje',
	backSlash: 'Kenoviiva',
	closeBracket: 'Oikea sulje',
	singleQuote: 'Puolilainausmerkki',
	
	ibm :
	{
		helpLinkDescription : "Avaa lisää ohjeaiheita uudessa ikkunassa",
		helpLink : "Lisää ohjeaiheita"
	}

});

