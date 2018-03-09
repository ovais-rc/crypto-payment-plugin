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

CKEDITOR.lang['pt'] =
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
	editorPanel: 'Painel do editor de Rich Text',

	// Common messages and labels.
	common: {
		// Screenreader titles. Please note that screenreaders are not always capable
		// of reading non-English words. So be careful while translating it.
		editorHelp: "Prima ALT 0 para aceder à ajuda",

		browseServer	: "Servidor do navegador:",
		url				: "URL:",
		protocol		: "Protocolo:",
		upload			: "Transferir:",
		uploadSubmit	: "Enviar para o Servidor",
		image			: "Inserir imagem",
		flash			: "Inserir filme Flash",
		form			: "Inserir formulário",
		checkbox		: "Inserir caixa de verificação",
		radio			: "Inserir botão de opção",
		textField		: "Inserir campo de texto",
		textarea		: "Inserir área de texto",
		hiddenField		: "Inserir campo oculto",
		button			: "Inserir botão",
		select			: "Inserir campo de selecção",
		imageButton		: "Inserir botão de imagem",
		notSet			: "não definido",
		id				: "ID:",
		name			: "Nome:",
		langDir			: "Direcção do idioma:",
		langDirLtr		: "Esquerda para a direita",
		langDirRtl		: "Direita para a esquerda",
		langCode		: "Código de idioma:",
		longDescr		: "URL de descrição longa:",
		cssClass		: "Classes de folha de estilos:",
		advisoryTitle	: "Título informativo:",
		cssStyle		: "Estilo:",
		ok				: "OK",
		cancel			: "Cancelar",
		close : "Fechar",
		preview			: "Pré-visualizar:",
		resize			: "Redimensionar",
		generalTab		: "Geral",
		advancedTab		: "Avançadas",
		validateNumberFailed	: "Este valor não corresponde a um número.",
		confirmNewPage	: "Serão perdidas todas as alterações não guardadas a este conteúdo. Tem a certeza de que pretende carregar a nova página?",
		confirmCancel	: "Algumas das opções foram alteradas. Tem a certeza de que pretende fechar a caixa de diálogo?",
		options : "Opções",
		target			: "Destino:",
		targetNew		: "Nova janela (_blank)",
		targetTop		: "Janela mais acima (_top)",
		targetSelf		: "Mesma janela (_self)",
		targetParent	: "Janela ascendente (_parent)",
		langDirLTR		: "Esquerda para a direita",
		langDirRTL		: "Direita para a esquerda",
		styles			: "Estilo:",
		cssClasses		: "Classes de folha de estilos:",
		width			: "Largura:",
		height			: "Altura:",
		align			: "Alinhar:",
		alignLeft		: "Esquerda",
		alignRight		: "Direita",
		alignCenter		: "Centro",
		alignJustify	: 'Justificar',
		alignTop		: "Superior",
		alignMiddle		: "Centro",
		alignBottom		: "Inferior",
		alignNone		: 'Nenhuma',
		invalidValue	: "Valor não válido.",
		invalidHeight	: "A altura tem de corresponder a um número inteiro positivo",
		invalidWidth	: "A largura tem de corresponder a um número inteiro positivo",
		invalidCssLength	: "O valor especificado para o campo '%1' tem de corresponder a um número positivo com ou sem uma unidade de medição de CSS válida (px, %, pol, cm, mm, em, ex, pt ou pc).",
		invalidHtmlLength	: "O valor especificado para o campo '%1' tem de corresponder a um número positivo com ou sem uma unidade de medição de HTML válida (px ou %).",
		invalidInlineStyle	: "O valor especificado para o estilo incluído tem de consistir numa ou mais enuplas com o formato de \"name : value\", separadas por ponto e vírgula.",
		cssLengthTooltip	: "Introduza um número para um valor em píxeis ou um número com uma unidade de CSS válida (px, %, pol, cm, mm, em, ex, pt ou pc).",

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
			required : "Obrigatório"
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
		btnIgnoreAll: 'Ignorar tudo',
		btnReplace: 'Substituir',
		btnReplaceAll: 'Substituir tudo',
		btnUndo: 'Anular',
		changeTo: 'Alterar para',
		errorLoading: 'Erro ao carregar o sistema central dos serviços da aplicação: %s.',
		ieSpellDownload: 'O verificador ortográfico não está instalado. Pretende descarregar o mesmo agora?',
		manyChanges: 'Verificação ortográfica concluída: %1 palavras alteradas',
		noChanges: 'Verificação ortográfica concluída: Nenhuma palavra alterada',
		noMispell: 'Verificação ortográfica concluída: Não forem encontrados erros ortográficos',
		noSuggestions: '- Sem sugestões -',
		notAvailable: 'Lamentamos, mas o serviço não se encontra actualmente disponível.',
		notInDic: 'Não está no dicionário',
		oneChange: 'Verificação ortográfica concluída: Uma palavra alterada',
		progress: 'Verificação ortográfica em curso...',
		title: 'Verificação ortográfica',
		toolbar: 'Verificar ortografia'
	},
	
	scayt :
	{
		about: 'Acerca do SCAYT',
		aboutTab: 'Acerca de',
		addWord: 'Adicionar palavra',
		allCaps: 'Ignorar palavras com toda as letras em maiúsculas',
		dic_create: 'Criar',
		dic_delete: 'Eliminar',
		dic_field_name: 'Nome do dicionário',
		dic_info: 'Inicialmente, o dicionário do utilizador está armazenado num cookie. No entanto, os cookies têm um tamanho limitado. Quando o dicionário do utilizador aumentar e já não puder ser armazenado num cookie, poderá ser armazenado no nosso servidor. Para armazenar o dicionário pessoal no nosso servidor, deve especificar um nome para o dicionário. Se já tiver um dicionário armazenado, introduza o respectivo nome e faça clique no botão Restaurar.',
		dic_rename: 'Mudar o nome',
		dic_restore: 'Restaurar',
		dictionariesTab: 'Dicionários',
		disable: 'Desactivar SCAYT',
		emptyDic: 'O nome do dicionário não deve estar vazio.',
		enable: 'Activar SCAYT',
		ignore: 'Ignorar',
		ignoreAll: 'Ignorar tudo',
		ignoreDomainNames: 'Ignorar nomes de domínio',
		langs: 'Idiomas',
		languagesTab: 'Idiomas',
		mixedCase: 'Ignorar palavras com letras em maiúsculas e minúsculas',
		mixedWithDigits: 'Ignorar palavras com números',
		moreSuggestions: 'Mais sugestões',
		opera_title: 'Não suportado pelo Opera',
		options: 'Opções',
		optionsTab: 'Opções',
		title: 'Verificação ortográfica ao escrever',
		toggle: 'Alternar SCAYT',
		noSuggestions: 'Nenhuma sugestão'
	}
	
};

