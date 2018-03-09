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

CKEDITOR.lang['pt-br'] =
{
	/**
	 * The language reading direction. Possible values are "rtl" for
	 * Right-To-Left languages (like Arabic) and "ltr" for Left-To-Right
	 * languages (like English).
	 * @default "ltr"
	 */
	dir : "ltr",
	
	// ARIA descriptions.
	editor	: "Editor de Rich Text",
	editorPanel: 'Painel Editor de Rich Text',

	// Common messages and labels.
	common: {
		// Screenreader titles. Please note that screenreaders are not always capable
		// of reading non-English words. So be careful while translating it.
		editorHelp: "Pressione ALT 0 para obter ajuda",

		browseServer	: "Servidor de Navegador:",
		url				: "URL:",
		protocol		: "Protocol:",
		upload			: "Carregar:",
		uploadSubmit	: "Enviar para o Servidor",
		image			: "Inserir Imagem",
		flash			: "Inserir Flash Movie",
		form			: "Inserir Formulário",
		checkbox		: "Inserir Caixa de Seleção",
		radio			: "Inserir Botão de Opções",
		textField		: "Inserir Campo de Texto",
		textarea		: "Inserir Área de Texto",
		hiddenField		: "Inserir Campo Oculto",
		button			: "Inserir Botão",
		select			: "Inserir Campo de Seleção",
		imageButton		: "Inserir Botão de Imagem",
		notSet			: "não configurado",
		id				: "ID:",
		name			: "Nome:",
		langDir			: "Direção de Idioma:",
		langDirLtr		: "Da Esquerda para Direita",
		langDirRtl		: "Da Direita para Esquerda",
		langCode		: "Código de Idioma:",
		longDescr		: "URL de Descrição Detalhada:",
		cssClass		: "Classes de folha de estilo:",
		advisoryTitle	: "Título do Conselheiro:",
		cssStyle		: "Estilo:",
		ok				: "OK",
		cancel			: "Cancelar",
		close : "Fechar",
		preview			: "Pré-visualizar:",
		resize			: "Redimensionar",
		generalTab		: "Geral",
		advancedTab		: "Avançado",
		validateNumberFailed	: "Este valor não é um número.",
		confirmNewPage	: "Quaisquer alterações não salvas feitas neste conteúdo serão perdidas. Tem certeza de que deseja carregar uma nova página?",
		confirmCancel	: "Algumas das opções foram alteradas. Tem certeza de que deseja fechar o diálogo?",
		options : "Opções",
		target			: "Destino:",
		targetNew		: "Nova Janela (_blank)",
		targetTop		: "Janela Superior (_top)",
		targetSelf		: "Mesma Janela (_self)",
		targetParent	: "Janela-Pai (_parent)",
		langDirLTR		: "Da Esquerda para Direita",
		langDirRTL		: "Da Direita para Esquerda",
		styles			: "Estilo:",
		cssClasses		: "Classes de Folha de Estilo:",
		width			: "Largura:",
		height			: "Altura:",
		align			: "Alinhar:",
		alignLeft		: "Esquerda",
		alignRight		: "Direita",
		alignCenter		: "Centro",
		alignJustify	: 'Justificar',
		alignTop		: "Parte Superior",
		alignMiddle		: "Meio",
		alignBottom		: "Parte Inferior",
		alignNone		: 'Nenhum',
		invalidValue	: "Valor inválido.",
		invalidHeight	: "A altura deve ser um número inteiro positivo.",
		invalidWidth	: "A largura deve ser um número inteiro positivo.",
		invalidCssLength	: "O valor especificado para o campo '%1' deve ser um número positivo com ou sem uma unidade de medida CSS válida (px, %, in, cm, mm, em, ex, pt ou pc).",
		invalidHtmlLength	: "O valor especificado para o campo '%1' deve ser um número positivo com ou sem uma unidade de medida HTML válida (px ou %).",
		invalidInlineStyle	: "O valor especificado para o estilo sequencial deve consistir em uma ou mais tuplas com o formato \"name : value\", separadas por ponto-e-vírgula.",
		cssLengthTooltip	: "Insira um número para um valor em pixels ou um número com uma unidade CSS válida (px, %, in, cm, mm, em, ex, pt ou pc).",

		// Put the voice-only part of the label in the span.
		unavailable		: "%1<span class=\"cke_accessibility\">, indisponível</span>"
	},
	
	ibm :
	{
		common :
		{
			widthIn	: "polegadas",
			widthCm	: "centímetros",
			widthMm	: "milímetros",
			widthEm	: "em",
			widthEx	: "ex",
			widthPt	: "pontos",
			widthPc	: "picas",
			required : "Obrigatória"
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
		btnIgnoreAll: 'Ignorar Todos',
		btnReplace: 'Substituir',
		btnReplaceAll: 'Substituir Todos',
		btnUndo: 'Desfazer',
		changeTo: 'Alterar para',
		errorLoading: 'Erro ao carregar o host do serviço de aplicativo: %s.',
		ieSpellDownload: 'Verificador ortográfico não instalado. Deseja fazer o download dele agora?',
		manyChanges: 'Verificação ortográfica concluída: %1 de palavras alteradas',
		noChanges: 'Verificação ortográfica concluída: Nenhuma palavra alterada',
		noMispell: 'Verificação ortográfica concluída: Nenhum erro de ortografia localizado',
		noSuggestions: '- Sem sugestões -',
		notAvailable: 'O serviço está indisponível no momento.',
		notInDic: 'Não consta no dicionário',
		oneChange: 'Verificação ortográfica concluída: Uma palavra alterada',
		progress: 'Verificação ortográfica em andamento...',
		title: 'Verificação ortográfica',
		toolbar: 'Verificação Ortográfica'
	},
	
	scayt :
	{
		about: 'Sobre SCAYT',
		aboutTab: 'Sobre',
		addWord: 'Incluir Palavra',
		allCaps: 'Ignorar Todas Palavras em Caixa Alta',
		dic_create: 'Criar',
		dic_delete: 'Excluir',
		dic_field_name: 'Nome do dicionário',
		dic_info: 'Inicialmente, o Dicionário do Usuário está armazenado em um Cookie. No entanto, Cookies têm limite de tamanho. Quando o Dicionário do Usuário cresce até um ponto em que não pode ser armazenado em um Cookie, o dicionário pode ser armazenado em nosso servidor. Para armazenar o seu dicionário pessoal em nosso servidor, você deve especificar um nome para o dicionário. Se já tiver um dicionário armazenado, digite seu nome e clique no botão Restaurar.',
		dic_rename: 'Renomear',
		dic_restore: 'Restaurar',
		dictionariesTab: 'Dicionários',
		disable: 'Desativar SCAYT',
		emptyDic: 'O nome do dicionário não deve estar vazio.',
		enable: 'Ativar SCAYT',
		ignore: 'TESTIgnore',
		ignoreAll: 'Ignorar Todos',
		ignoreDomainNames: 'Ignorar Nomes de Domínios',
		langs: 'Idiomas',
		languagesTab: 'Idiomas',
		mixedCase: 'Ignorar palavras compostas por letras maiúsculas e minúsculas',
		mixedWithDigits: 'Ignorar Palavras com Números',
		moreSuggestions: 'Mais Sugestões',
		opera_title: 'Não suportado por Opera',
		options: 'Opções',
		optionsTab: 'Opções',
		title: 'Verificação Ortográfica Durante Digitação',
		toggle: 'Alternar SCAYT',
		noSuggestions: 'Nenhuma sugestão'
	}
	
};

