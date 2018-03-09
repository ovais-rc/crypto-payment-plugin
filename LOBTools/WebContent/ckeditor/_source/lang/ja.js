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

CKEDITOR.lang['ja'] =
{
	/**
	 * The language reading direction. Possible values are "rtl" for
	 * Right-To-Left languages (like Arabic) and "ltr" for Left-To-Right
	 * languages (like English).
	 * @default "ltr"
	 */
	dir : "ltr",
	
	// ARIA descriptions.
	editor	: "リッチ・テキスト・エディター",
	editorPanel: 'リッチ・テキスト・エディター・パネル',

	// Common messages and labels.
	common: {
		// Screenreader titles. Please note that screenreaders are not always capable
		// of reading non-English words. So be careful while translating it.
		editorHelp: "ALT + 0 キーを押すとヘルプが表示されます。",

		browseServer	: "ブラウザー・サーバー:",
		url				: "URL:",
		protocol		: "プロトコル:",
		upload			: "アップロード:",
		uploadSubmit	: "サーバーに送信",
		image			: "イメージの挿入",
		flash			: "Flash ムービーの挿入",
		form			: "フォームの挿入",
		checkbox		: "チェック・ボックスの挿入",
		radio			: "ラジオ・ボタンの挿入",
		textField		: "テキスト・フィールドの挿入",
		textarea		: "テキスト域の挿入",
		hiddenField		: "隠しフィールドの挿入",
		button			: "ボタンの挿入",
		select			: "選択フィールドの挿入",
		imageButton		: "イメージ・ボタンの挿入",
		notSet			: "未設定",
		id				: "ID:",
		name			: "名前:",
		langDir			: "言語の方向:",
		langDirLtr		: "左から右",
		langDirRtl		: "右から左",
		langCode		: "言語コード:",
		longDescr		: "詳細説明の URL:",
		cssClass		: "スタイルシート・クラス:",
		advisoryTitle	: "推奨タイトル:",
		cssStyle		: "スタイル:",
		ok				: "OK",
		cancel			: "キャンセル",
		close : "閉じる",
		preview			: "プレビュー:",
		resize			: "サイズ変更",
		generalTab		: "一般",
		advancedTab		: "拡張",
		validateNumberFailed	: "この値は数値ではありません。",
		confirmNewPage	: "このコンテンツに対する変更内容で保存していないものはすべて失われます。新しいページをロードしてもよろしいですか?",
		confirmCancel	: "一部のオプションが変更されました。ダイアログを閉じてもよろしいですか?",
		options : "オプション",
		target			: "ターゲット:",
		targetNew		: "新規ウィンドウ (_blank)",
		targetTop		: "最上位ウィンドウ (_top)",
		targetSelf		: "同じウィンドウ (_self)",
		targetParent	: "親ウィンドウ (_parent)",
		langDirLTR		: "左から右",
		langDirRTL		: "右から左",
		styles			: "スタイル:",
		cssClasses		: "スタイルシート・クラス:",
		width			: "幅:",
		height			: "高さ:",
		align			: "位置合わせ:",
		alignLeft		: "左揃え",
		alignRight		: "右揃え",
		alignCenter		: "中央揃え",
		alignJustify	: '両端揃え',
		alignTop		: "先頭",
		alignMiddle		: "中央",
		alignBottom		: "下端",
		alignNone		: 'なし',
		invalidValue	: "無効な値です。",
		invalidHeight	: "高さは正の整数でなければなりません。",
		invalidWidth	: "幅は正の整数でなければなりません。",
		invalidCssLength	: "'%1' フィールドの値には、有効な CSS 計測単位 (px、%、in、cm、mm、em、ex、pt、pc) を持つ正数または持たない正数を指定する必要があります。",
		invalidHtmlLength	: "'%1' フィールドの値には、有効な HTML 計測単位 (px または %) を持つ正数または持たない正数を指定する必要があります。",
		invalidInlineStyle	: "インライン・スタイルの値には、\"name : value\" という形式の 1 つ以上のタプルをセミコロンで区切って指定する必要があります。",
		cssLengthTooltip	: "ピクセル単位の数値または有効な CSS 単位 (px、%、in、cm、mm、em、ex、pt、pc) を持つ数値を入力してください。",

		// Put the voice-only part of the label in the span.
		unavailable		: "%1<span class=\"cke_accessibility\">、使用不可</span>"
	},
	
	ibm :
	{
		common :
		{
			widthIn	: "インチ",
			widthCm	: "センチメートル",
			widthMm	: "ミリメートル",
			widthEm	: "em",
			widthEx	: "ex",
			widthPt	: "ポイント",
			widthPc	: "パイカ",
			required : "必須"
		}
		/*linkdialog : 
		{
			label : "Link Dialog"
		}
		*/		
	},
	
	wsc :
	{
		btnIgnore: '辞退する',
		btnIgnoreAll: 'すべて無視する',
		btnReplace: '置換',
		btnReplaceAll: 'すべてを置換',
		btnUndo: '取り消し',
		changeTo: '変更後',
		errorLoading: 'アプリケーション・サービス・ホストのロード中にエラーが発生しました: %s。',
		ieSpellDownload: 'スペル・チェッカーがインストールされていません。ダウンロードしますか?',
		manyChanges: 'スペル・チェック完了: %1 語修正しました',
		noChanges: 'スペル・チェック完了: 修正した語はありません',
		noMispell: 'スペル・チェック完了: ミススペルはありません',
		noSuggestions: '- 推奨なし -',
		notAvailable: '現在サービスは利用できません。',
		notInDic: '辞書にありません',
		oneChange: 'スペル・チェック完了: 1 語修正しました',
		progress: 'スペル・チェック進行中...',
		title: 'スペル・チェック',
		toolbar: 'スペルを確認してください'
	},
	
	scayt :
	{
		about: 'SCAYT について',
		aboutTab: '詳細情報',
		addWord: '単語の追加',
		allCaps: '大文字だけの語を無視',
		dic_create: '作成',
		dic_delete: '削除',
		dic_field_name: '辞書名',
		dic_info: '最初、ユーザー辞書は Cookie に保管されます。 ただし、Cookie のサイズには制限があります。 ユーザー辞書が大きくなって Cookie に保管できなくなった場合、辞書は弊社のサーバーに保管されます。 個人辞書を弊社のサーバーに保管するには、辞書の名前を指定する必要があります。 既に辞書を保管している場合は、その名前を指定して「復元」ボタンをクリックします。',
		dic_rename: '名前変更',
		dic_restore: '復元',
		dictionariesTab: '辞書',
		disable: 'SCAYT を無効にする',
		emptyDic: '辞書名を空にすることはできません。',
		enable: 'SCAYT を有効にする',
		ignore: 'TESTIgnore',
		ignoreAll: 'すべて無視する',
		ignoreDomainNames: 'ドメイン・ネームを無視',
		langs: '言語',
		languagesTab: '言語',
		mixedCase: '大/小文字混合の語を無視',
		mixedWithDigits: '数字が入っている語を無視',
		moreSuggestions: 'その他の提案',
		opera_title: 'Opera ではサポートされていません',
		options: 'オプション',
		optionsTab: 'オプション',
		title: '入力時のスペル・チェック',
		toggle: 'SCAYT の切り替え',
		noSuggestions: '候補なし'
	}
	
};

