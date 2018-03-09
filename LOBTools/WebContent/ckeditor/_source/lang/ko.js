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

CKEDITOR.lang['ko'] =
{
	/**
	 * The language reading direction. Possible values are "rtl" for
	 * Right-To-Left languages (like Arabic) and "ltr" for Left-To-Right
	 * languages (like English).
	 * @default "ltr"
	 */
	dir : "ltr",
	
	// ARIA descriptions.
	editor	: "서식있는 텍스트 편집기",
	editorPanel: '서식있는 텍스트 편집기 패널',

	// Common messages and labels.
	common: {
		// Screenreader titles. Please note that screenreaders are not always capable
		// of reading non-English words. So be careful while translating it.
		editorHelp: "도움말: ALT+0 ",

		browseServer	: "브라우저 서버:",
		url				: "URL:",
		protocol		: "프로토콜:",
		upload			: "업로드:",
		uploadSubmit	: "서버로 보내기",
		image			: "이미지 삽입",
		flash			: "플래시 동영상 삽입",
		form			: "양식 삽입",
		checkbox		: "선택란 삽입",
		radio			: "단일 선택 단추 삽입",
		textField		: "텍스트 필드 삽입",
		textarea		: "텍스트 영역 삽입",
		hiddenField		: "숨겨진 필드 삽입",
		button			: "단추 삽입",
		select			: "선택 필드 삽입",
		imageButton		: "이미지 단추 삽입",
		notSet			: "설정하지 않음",
		id				: "ID:",
		name			: "이름:",
		langDir			: "언어 방향:",
		langDirLtr		: "왼쪽에서 오른쪽",
		langDirRtl		: "오른쪽에서 왼쪽",
		langCode		: "언어 코드:",
		longDescr		: "긴 설명 URL:",
		cssClass		: "스타일시트 클래스:",
		advisoryTitle	: "링크 설명",
		cssStyle		: "스타일:",
		ok				: "확인",
		cancel			: "취소 ",
		close : "닫기",
		preview			: "미리보기:",
		resize			: "크기 조정",
		generalTab		: "일반",
		advancedTab		: "고급",
		validateNumberFailed	: "이 값은 숫자가 아닙니다.",
		confirmNewPage	: "이 컨텐츠에 대한 저장되지 않은 변경사항이 손실됩니다. 새 페이지를 로드하시겠습니까?",
		confirmCancel	: "일부 옵션이 변경되었습니다. 대화 상자를 닫으시겠습니까?",
		options : "옵션",
		target			: "대상:",
		targetNew		: "새 창(_blank)",
		targetTop		: "맨 위 창(_top)",
		targetSelf		: "동일한 창(_self)",
		targetParent	: "상위 창(_parent)",
		langDirLTR		: "왼쪽에서 오른쪽",
		langDirRTL		: "오른쪽에서 왼쪽",
		styles			: "스타일:",
		cssClasses		: "스타일시트 클래스:",
		width			: "너비:",
		height			: "높이:",
		align			: "맞춤:",
		alignLeft		: "왼쪽",
		alignRight		: "오른쪽",
		alignCenter		: "가운데",
		alignJustify	: '양쪽 맞춤',
		alignTop		: "맨 위",
		alignMiddle		: "중간",
		alignBottom		: "아래",
		alignNone		: '없음',
		invalidValue	: "올바르지 않은 값",
		invalidHeight	: "높이는 양의 정수여야 합니다.",
		invalidWidth	: "너비는 양의 정수여야 합니다.",
		invalidCssLength	: "'%1' 필드에 대해 지정된 값이 유효한 CSS 수치 단위(px, %, in, cm, mm, em, ex, pt 또는 pc)가 있거나 없는 양수여야 합니다.",
		invalidHtmlLength	: "'%1' 필드에 대해 지정된 값이 유효한 HTML 수치 단위(px 또는 %)가 있거나 없는 양수여야 합니다.",
		invalidInlineStyle	: "인라인 스타일에 대해 지정된 값이 세미콜론으로 분리된 \"이름 : 값\"의 형식으로 하나 이상의 튜플로 구성되어야 합니다.",
		cssLengthTooltip	: "유효한 CSS 단위(px, %, in, cm, mm, em, ex, pt 또는 pc)의 숫자나 픽셀 값의 숫자를 입력하십시오.",

		// Put the voice-only part of the label in the span.
		unavailable		: "%1<span class=\"cke_accessibility\">, 사용 불가능</span>"
	},
	
	ibm :
	{
		common :
		{
			widthIn	: "인치",
			widthCm	: "센티미터",
			widthMm	: "밀리미터",
			widthEm	: "em",
			widthEx	: "ex",
			widthPt	: "포인트",
			widthPc	: "파이카",
			required : "필수"
		}
		/*linkdialog : 
		{
			label : "Link Dialog"
		}
		*/		
	},
	
	wsc :
	{
		btnIgnore: '무시',
		btnIgnoreAll: '모두 무시',
		btnReplace: '대체',
		btnReplaceAll: '모두 대체',
		btnUndo: '실행 취소',
		changeTo: '다음으로 변경',
		errorLoading: '애플리케이션 서비스 호스트를 로드하는 중에 오류 발생: %s.',
		ieSpellDownload: '맞춤법 검사기가 설치되어 있지 않습니다. 지금 다운로드하시겠습니까?',
		manyChanges: '맞춤법 검사 완료: %1 단어가 바뀌었습니다.',
		noChanges: '맞춤법 검사 완료: 바뀐 단어가 없습니다.',
		noMispell: '맞춤법 검사 완료: 맞춤법 오류가 없습니다.',
		noSuggestions: '- 제안사항 없음 -',
		notAvailable: '죄송합니다. 현재 서비스가 사용 불가능합니다.',
		notInDic: '사전에 없음',
		oneChange: '맞춤법 검사 완료: 한 단어가 바뀌었습니다.',
		progress: '맞춤법 검사 진행 중...',
		title: '맞춤법 검사',
		toolbar: '맞춤법 확인'
	},
	
	scayt :
	{
		about: 'SCAYT 정보',
		aboutTab: '제품 정보',
		addWord: '단어 추가',
		allCaps: '모든 대문자 단어 무시',
		dic_create: '작성',
		dic_delete: '삭제',
		dic_field_name: '사전 이름',
		dic_info: '초기에는 사용자 사전이 쿠키에 저장됩니다. 그러나 쿠키에는 크기에 한계가 있습니다. 사용자 사전이 쿠키에 저장될 수 없는 크기가 되면 사전을 당사 서버에 저장할 수 있습니다. 개인 사전을 당사 서버에 저장하려면 사전의 이름을 지정해야 합니다. 이미 저장된 사전이 있는 경우 해당 사전의 이름을 입력하고 복원 단추를 클릭하십시오.',
		dic_rename: '이름 변경',
		dic_restore: '복원',
		dictionariesTab: '사전',
		disable: 'SCAYT 사용 안함',
		emptyDic: '사전 이름은 공백으로 둘 수 없습니다.',
		enable: 'SCAYT 사용',
		ignore: 'TESTIgnore',
		ignoreAll: '모두 무시',
		ignoreDomainNames: '도메인 이름 무시',
		langs: '언어',
		languagesTab: '언어',
		mixedCase: '대소문자 혼용 단어 무시',
		mixedWithDigits: '숫자가 포함된 단어 무시',
		moreSuggestions: '추가 제한사항',
		opera_title: 'Opera에서 지원되지 않음',
		options: '옵션',
		optionsTab: '옵션',
		title: '입력하는 동안 맞춤법 검사',
		toggle: 'SCAYT 토글',
		noSuggestions: '제안 없음'
	}
	
};

