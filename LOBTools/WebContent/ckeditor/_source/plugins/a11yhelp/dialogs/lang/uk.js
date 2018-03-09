/**
 * @license Copyright (c) 2003-2014, CKSource - Frederico Knabben. All rights reserved.
 * For licensing, see LICENSE.html or http://ckeditor.com/licensePortions Copyright IBM Corp., 2009-2015.
 */

CKEDITOR.plugins.setLang( "a11yhelp", "uk",
{
	//do not translate anything with the form ${xxx}
	
	title : "Інструкції з використання спеціальних можливостей",
	contents : "Зміст довідки. Для того щоб закрити це вікно, натисніть клавішу ESC.",
	legend :
	[
		{
			name : "Загальні параметри",
			items :
			[
				{
					name : "Панель інструментів редактора",
					legend: "Натисніть ${toolbarFocus} для переходу до панелі інструментів; для переходу до наступної кнопки панелі інструментів натисніть TAB або клавішу Вправо; для переходу до попередньої кнопки натисніть SHIFT+TAB або клавішу Вліво; для активації кнопки панелі інструментів натисніть Пробіл або ENTER."
				},

				{
					name : "Рядок шляху елементів редактора",
					legend : "Натисніть ${elementsPathFocus} для переходу до рядка шляху елементів; для переходу до наступної кнопки елемента натисніть TAB або клавішу Вправо; для переходу до попередньої кнопки натисніть SHIFT+TAB або клавішу Вліво. Для вибору елемента в редакторі натисніть Пробіл або ENTER."
				},

				{
					name : "Контекстне меню редактора",
					legend : "Натисніть ${contextMenu} або клавішу програми, щоб відкрити контекстне меню. Для переходу до наступного пункту меню натисніть TAB або клавішу Вниз; для переходу до попереднього пункту меню натисніть SHIFT+TAB або клавішу Вгору. Для вибору пункту меню натисніть Пробіл або ENTER." +
							 "Для того щоб відкрити вкладене меню для вибраного пункту основного меню натисніть Пробіл або клавішу Вправо; для того щоб повернутися до головного меню, натисніть ESC або клавішу Вліво." +
							 "Натисніть ESC для закриття контекстного меню."
				},

				{
					name : "Вікно редактора",
					legend : "Для переходу до наступного поля вікна натисніть TAB, для переходу до попереднього поля натисніть SHIFT + TAB, для відправки даних натисніть ENTER, а для закриття вікна натисніть ESC." +
							 "Якщо вікно складається з декількох вкладок, натисніть ALT + F10 для переходу до списку вкладок. Для переходу до наступної вкладки натисніть TAB або клавішу Вправо; для переходу до попередньої вкладки натисніть SHIFT + TAB або клавішу Вліво. Для вибору потрібної вкладки натисніть Пробіл або ENTER."
				},

				{
					name : "Список у редакторі",
					legend : "Для переходу до наступного елемента списку натисніть TAB або стрілку Вниз; для переходу до попереднього елемента списку натисніть SHIFT + TAB або стрілку Вгору. Для того щоб закрити список, натисніть ESC."
				}
			]
		},
		{
			name : "Команди",
			items :
			[
				{
					name : " Команда Скасувати",
					legend : "Натисніть ${undo}"
				},
				{
					name : " Команда Повторити",
					legend : "Натисніть ${redo}"
				},
				{
					name : " Команда Напівжирний",
					legend : "Натисніть ${bold}"
				},
				{
					name : " Команда Курсив",
					legend : "Натисніть ${italic}"
				},
				{
					name : " Команда Підкреслений",
					legend : "Натисніть ${underline}"
				},
				{
					name : " Команда Додати посилання",
					legend : "Натисніть ${link}"
				},
				{
					name : " Команда Згорнути панель інструментів",
					legend : "Натисніть ${toolbarCollapse}"
				},
				{
					name: ' Access previous focus space command',
					legend: 'Press ${accessPreviousSpace} to access the closest unreachable focus space before the caret, ' +
						'for example: two adjacent HR elements. Repeat the key combination to reach distant focus spaces.'
				},
				{
					name: ' Access next focus space command',
					legend: 'Press ${accessNextSpace} to access the closest unreachable focus space after the caret, ' +
						'for example: two adjacent HR elements. Repeat the key combination to reach distant focus spaces.'
				},
				{
					name : " Increase Indent",
					legend : "Press ${indent}"
				},
				{
					name : " Decrease Indent",
					legend : "Press ${outdent}"
				},
				{
					name : " Text direction from left to right",
					legend : "Press ${bidiltr}"
				},
				{
					name : " Text direction from right to left",
					legend : "Press ${bidirtl}"
				},
				{
					name : " Довідка зі спеціальних можливостей",
					legend : "Натисніть ${a11yHelp}"
				}
			]
		},
		
		{	//added by ibm
			name : "Note",
			items :
			[
				{	
					name : "",
					legend : "* Some features can be disabled by your administrator."
				}
			]
		}
	],
	
	ibm :
	{
		helpLinkDescription : "Open more help topics in a new window",
		helpLink : "More Help Topics"		
	}
	
});

