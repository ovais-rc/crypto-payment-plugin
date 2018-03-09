<!--
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2002, 2003
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*--------------------------------------------------------------------->
<%@ page language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@include file="../common/common.jsp" %>
<%
   	CommandContext cmdContext = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
	Hashtable rbProduct 	= (Hashtable)ResourceDirectory.lookup("catalog.ProductNLS", cmdContext.getLocale());
%>
<HTML>
<HEAD>
<TITLE><%=UIUtil.toHTML((String)rbProduct.get("ProductAttributeEditor_FrameTitle_4"))%></TITLE>
<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/catalog/button.js"></SCRIPT>
<SCRIPT>
   var css = top.getCSSFile();
   document.writeln("<link rel=stylesheet href='" + css + "' type='text/css'>");

   function buttonRemove() {
		if (removeButton.className == 'disabled') return;
   	if (confirmDialog("<%= UIUtil.toJavaScript((String)rbProduct.get("ItemDeleteMsg")) %>"))
	      parent.frameItems.buttonRemove();
   }
   
   function buttonNewItem() {
		if (newButton.className == 'disabled') return;
		if (parent.attributeChanged) {
			if (top.confirmDialog('<%=UIUtil.toJavaScript((String)rbProduct.get("productUpdateDetailCancelConfirmation"))%>')) {
				top.setContent('<%=UIUtil.toJavaScript((String)rbProduct.get("attribute_title_newItem"))%>', '/webapp/wcs/tools/servlet/WizardView?XMLFile=catalog.itemWizard&amp;productrfnbr=' + parent.frameProduct.getProductId() + '&amp;langId=<%=cmdContext.getLanguageId()%>&amp;storeId=' + parent.frameItems.getStoreId(),true);
			}
		} else {
			top.setContent('<%=UIUtil.toJavaScript((String)rbProduct.get("attribute_title_newItem"))%>', '/webapp/wcs/tools/servlet/WizardView?XMLFile=catalog.itemWizard&amp;productrfnbr=' + parent.frameProduct.getProductId() + '&amp;langId=<%=cmdContext.getLanguageId()%>&amp;storeId=' + parent.frameItems.getStoreId(),true);
		}
   }

	function buttonGenerate() 
	{
		if (generateButton.className == 'disabled') return;
		if (confirmDialog("<%= UIUtil.toJavaScript((String)rbProduct.get("itemGenerateConfirm")) %>")) 
		{
			var url                      = "/webapp/wcs/tools/servlet/ItemGenerate";
			var urlPara                  = new Object();
			urlPara.checkedProductRefNum = parent.frameProduct.getProductId();
			urlPara.fulfillmentCenterId = parent.frameProduct.getFulfillmentCenterId();
			top.setContent("<%=UIUtil.toJavaScript((String)rbProduct.get("productList_button_generate"))%>", url, true, urlPara);     
		}
	}


	function buttonUpdateItem()
	{
		if (updateButton.className == 'disabled') return;
		var url                = '/webapp/wcs/tools/servlet/NotebookView';
		var urlPara            = new Object();
		urlPara.XMLFile        = "catalog.itemNotebook";
		urlPara.productrfnbr   = parent.frameProduct.getProductId();
		urlPara.itemrfnbr      = parent.frameItems.getSKUId();
		urlPara.langId         = "<%=cmdContext.getLanguageId()%>";
		urlPara.storeId        = parent.frameItems.getStoreId();
		if (parent.attributeChanged) 
		{
			if (top.confirmDialog('<%=UIUtil.toJavaScript((String)rbProduct.get("productUpdateDetailCancelConfirmation"))%>')) 
			{
				top.setContent('<%=UIUtil.toJavaScript((String)rbProduct.get("attribute_itemUpdate"))%>', url, true, urlPara);
			}
		} else {
			top.setContent('<%=UIUtil.toJavaScript((String)rbProduct.get("attribute_itemUpdate"))%>', url, true, urlPara);
		}
	}

	function displayButtons(count, size)
	{

		if (parent.getDOIOWN() == false)
		{
			generateButton.className = 'disabled';
			newButton.className      = 'disabled';
			updateButton.className   = 'disabled';
			removeButton.className   = 'disabled';
			return;
		} 

		if (size == 0) 
		{
			generateButton.className = 'enabled';
		} else {
			generateButton.className = 'disabled';
		}

		if (count == 0)
		{
			newButton.className    = 'enabled';
			updateButton.className = 'disabled';
			removeButton.className = 'disabled';
		}

		if (count == 1)
		{
			newButton.className    = 'disabled';
			updateButton.className = 'enabled';
			removeButton.className = 'enabled';
		}

		if (count > 1)
		{
			newButton.className    = 'disabled';
			updateButton.className = 'disabled';
			removeButton.className = 'enabled';
		}
	}

</SCRIPT>
</HEAD>
<BODY class="content_bt" style="background-color:#F3F3F3;">

  	<script>
  	beginButtonTable();
	</script>

	<TR HEIGHT=20>
		<TD>&nbsp;</TD>
	</TR>

  	<script>
	drawButton("newButton", 
				"<%=UIUtil.toHTML((String)rbProduct.get("attribute_button_newItem"))%>", 
				"buttonNewItem()", 
				"enabled");		  				

	drawButton("updateButton", 
				"<%=UIUtil.toHTML((String)rbProduct.get("attribute_button_updateAttribute"))%>", 	//LL0410 -- sharing property string ?
				"buttonUpdateItem()", 
				"enabled");		  				

	drawButton("generateButton", 
				"<%=UIUtil.toHTML((String)rbProduct.get("productList_button_generate"))%>", 
				"buttonGenerate()", 
				"enabled");		  				

	drawButton("removeButton", 
				"<%=UIUtil.toHTML((String)rbProduct.get("attribute_button_removeItem"))%>", 
				"buttonRemove()", 
				"enabled");		  				

	endButtonTable();			
  	</script>

</BODY>
<SCRIPT>
	AdjustRefreshButton(newButton);
	AdjustRefreshButton(updateButton);
	AdjustRefreshButton(generateButton);
	AdjustRefreshButton(removeButton);
</SCRIPT>

</HTML>
