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
<TITLE><%=UIUtil.toHTML((String)rbProduct.get("ProductAttributeEditor_FrameTitle_2"))%></TITLE>
<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/catalog/button.js"></SCRIPT>
<SCRIPT>
   var css = top.getCSSFile();
   document.writeln("<link rel=stylesheet href='" + css + "' type='text/css'>");

   	function buttonRemove()
   	{
   		if (removeButton.className == 'enabled' && confirmDialog("<%= UIUtil.toJavaScript((String)rbProduct.get("AttributeDeleteMsg")) %>"))
			parent.frameProduct.buttonRemove();
	}

	function buttonNewAttribute()
	{
		if (newButton.className == 'enabled') {
			if (parent.attributeChanged) {	
				if (top.confirmDialog('<%=UIUtil.toJavaScript((String)rbProduct.get("productUpdateDetailCancelConfirmation"))%>')) {
					top.put("AttributeEditorReturnLanguage", parent.frameTop.languageSelect.selectedIndex);
					top.setContent('<%=UIUtil.toJavaScript((String)rbProduct.get("attribute_title_newAttribute"))%>', '/webapp/wcs/tools/servlet/DialogView?XMLFile=catalog.attributeDetailCreateDialog&amp;productrfnbr=' + parent.frameProduct.getProductId() + '&amp;isNewAttribute=true',true);
				}
			} else {
				top.put("AttributeEditorReturnLanguage", parent.frameTop.languageSelect.selectedIndex);
				top.setContent('<%=UIUtil.toJavaScript((String)rbProduct.get("attribute_title_newAttribute"))%>', '/webapp/wcs/tools/servlet/DialogView?XMLFile=catalog.attributeDetailCreateDialog&amp;productrfnbr=' + parent.frameProduct.getProductId() + '&amp;isNewAttribute=true',true);
			}
		}
	}


	function buttonAddValue()
	{
		if (addButton.className == 'enabled') {
			var url 		= '/webapp/wcs/tools/servlet/DialogView';
			var urlPara 		= new Object();
			urlPara.XMLFile		= "catalog.attributeDetailDialog";
			urlPara.productrfnbr 	= parent.frameProduct.getProductId();
			urlPara.attributeId	= parent.frameProduct.getSelectedAttributeId();
			urlPara.isNewAttribute	= false;
			//urlPara.attributeUsage= parent.frameProduct.attributeType;

			if (parent.attributeChanged) {		
				if (top.confirmDialog('<%=UIUtil.toJavaScript((String)rbProduct.get("productUpdateDetailCancelConfirmation"))%>')) {
					top.put("AttributeEditorReturnLanguage", parent.frameTop.languageSelect.selectedIndex);
					top.setContent('<%=UIUtil.toJavaScript((String)rbProduct.get("attribute_title_updateAttribute"))%>', url, true, urlPara);
				}
			} else {
				top.put("AttributeEditorReturnLanguage", parent.frameTop.languageSelect.selectedIndex);
				top.setContent('<%=UIUtil.toJavaScript((String)rbProduct.get("attribute_title_updateAttribute"))%>', url, true, urlPara);
			}
		}
	}

	function displayButtons(count)
	{
		if (parent.getDOIOWN() == false) 
		{
			newButton.className    = 'disabled';
			removeButton.className = 'disabled';
			addButton.className    = 'disabled';
			return;
		}

		if (count == 0)
		{
			newButton.className    = 'enabled';
			removeButton.className = 'disabled';
			addButton.className    = 'disabled';
		}

		if (count == 1)
		{
			newButton.className    = 'enabled';
			removeButton.className = 'enabled';
			addButton.className    = 'enabled';
		}

		if (count > 1)
		{
			newButton.className    = 'enabled';
			removeButton.className = 'enabled';
			addButton.className    = 'disabled';
		}
	}

	function onLoad()
	{
		displayButtons(0);
	}



</SCRIPT>
</HEAD>
<BODY CLASS="content_bt" ONLOAD=onLoad() style="background-color:#F3F3F3;">

  	<script>
  	beginButtonTable();
	</script>

	<TR HEIGHT=20>
		<TD>&nbsp;</TD>
	</TR>

  	<script>
	drawButton("newButton", 
				"<%=UIUtil.toHTML((String)rbProduct.get("attribute_button_newAttribute"))%>", 
				"buttonNewAttribute()", 
				"enabled");		  				
				
	drawButton("addButton", 
				"<%=UIUtil.toHTML((String)rbProduct.get("attribute_button_updateAttribute"))%>", 
				"buttonAddValue()", 
				"enabled");		  				

	drawButton("removeButton", 
				"<%=UIUtil.toHTML((String)rbProduct.get("attribute_button_removeAttribute"))%>", 
				"buttonRemove()", 
				"enabled");		  				

	endButtonTable();			
  	</script>

</BODY>

<SCRIPT>
	AdjustRefreshButton(newButton);
	AdjustRefreshButton(addButton);
	AdjustRefreshButton(removeButton);
</SCRIPT>


</HTML>
