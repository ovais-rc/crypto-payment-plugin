<!--==========================================================================
Licensed Materials - Property of IBM

WebSphere Commerce

(c) Copyright IBM Corp.  2002, 2016
All Rights Reserved

US Government Users Restricted Rights - Use, duplication or
disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
===========================================================================-->


<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 TRANSITIONAL//EN">
<%
//---------------------------------------------------------------------
//- Import and Include Section
//---------------------------------------------------------------------
%>
<%@ page language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.tools.util.UIUtil" %>
<%@ page import="com.ibm.commerce.beans.DataBeanManager" %>
<%@ page import="com.ibm.commerce.common.beans.LanguageDescriptionDataBean"%>
<%@ page import="com.ibm.commerce.catalog.beans.ProductDataBean" %>
<%@ page import="com.ibm.commerce.server.*" %>
<%@ page import="com.ibm.icu.text.UTF16" %>
<%@include file="../common/common.jsp" %>

<%
	CommandContext cmdContext = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
	Hashtable rbProduct = (Hashtable)ResourceDirectory.lookup("catalog.ProductNLS", cmdContext.getLocale());
	JSPHelper jsphelper 	= new JSPHelper(request);
	String catentryID  	= jsphelper.getParameter("catentryID"); 
	String attributeType 	= jsphelper.getParameter("attributeType");
	
	if (attributeType == null || !attributeType.equals("descriptive")) {
		attributeType = "defining";
	}	
	
	// Define the attribute language data bean
	Integer [] iLanguages = cmdContext.getStore().getSupportedLanguageIds();
	Integer storeDefLangId = cmdContext.getStore().getLanguageIdInEntityType();

	ProductDataBean bnProduct = new ProductDataBean();
	bnProduct.setProductID(catentryID);
	DataBeanManager.activate(bnProduct, cmdContext);
	bnProduct.setAdminMode(true);
	
	String strDoIOwn = null;
	if (bnProduct.getMemberId().equals(cmdContext.getStore().getMemberId())) { strDoIOwn = "true"; }
	else                                                                     { strDoIOwn = "false"; }
	
	// Define the number of tabs
	int totalTabs = 3;
	int tableCells = (totalTabs * 2) + 1;

%>

<HTML>
<HEAD>

<LINK rel=stylesheet href="<%= UIUtil.getCSSFile(cmdContext.getLocale()) %>" type="text/css">
<TITLE><%=UIUtil.toHTML((String)rbProduct.get("productUpdateDetail_AttributeEditor"))%></TITLE>

<SCRIPT>

	var savedTab = 0;                      // Currently selected menu tab
	parent.setDOIOWN(<%= strDoIOwn %>);
	if (parent.readonlyAccess == true) parent.setDOIOWN(false);

	function onLoad()
	{
<%
		LanguageDescriptionDataBean bnLanguage = new LanguageDescriptionDataBean();
		// Add the default language
		//if the description does not exit, we try to use the one in the store default language
		try {
			bnLanguage.setDataBeanKeyDescriptionLanguageId( storeDefLangId.toString() );
			bnLanguage.setDataBeanKeyLanguageId(cmdContext.getLanguageId().toString());
			DataBeanManager.activate(bnLanguage, cmdContext);
		} catch (Exception ex) {
			bnLanguage = new LanguageDescriptionDataBean();
			bnLanguage.setDataBeanKeyDescriptionLanguageId( storeDefLangId.toString() );
			bnLanguage.setDataBeanKeyLanguageId(storeDefLangId.toString() );
			DataBeanManager.activate(bnLanguage, cmdContext);			
		}
%>
		parent.languages[0] = "<%=storeDefLangId%>";
		var element = new Option();
		element.value = "0";
		element.text  = "<%=UIUtil.toJavaScript((String)bnLanguage.getDescription())%>";
		languageSelect.options.add(element);
<%

		// Add the alternate languages
		// if the description does not exit, we try to use the one in the store default language
		int index = 1;
		for (int i=0; i<iLanguages.length; i++) 
		{
			// ignore the default language
			if (iLanguages[i].intValue() ==  storeDefLangId.intValue()) { continue; }
			try {
				bnLanguage = new LanguageDescriptionDataBean();
				bnLanguage.setDataBeanKeyDescriptionLanguageId( iLanguages[i].toString() );
				bnLanguage.setDataBeanKeyLanguageId(cmdContext.getLanguageId().toString());
				DataBeanManager.activate(bnLanguage, cmdContext);
			} catch (Exception ex) {
				bnLanguage = new LanguageDescriptionDataBean();
				bnLanguage.setDataBeanKeyDescriptionLanguageId( iLanguages[i].toString() );
				bnLanguage.setDataBeanKeyLanguageId(storeDefLangId.toString() );
				DataBeanManager.activate(bnLanguage, cmdContext);			
			}
%>
			parent.languages[<%=index%>] = "<%=iLanguages[i].toString()%>";
			var element = new Option();
			element.value = "<%=index%>";
			element.text  = "<%=UIUtil.toJavaScript((String)bnLanguage.getDescription())%>";
			languageSelect.options.add(element);
<%
			index++;
		}
%>

		parent.setAttributes();
	}

	function changeLanguage()
	{
		var startLanguage = top.get("AttributeEditorReturnLanguage", "null");
		top.put("AttributeEditorReturnLanguage", "null");
		if (startLanguage != "null") 
		{
			languageSelect.selectedIndex = startLanguage;
			selectLanguage();
		}

		parent.frameset1.rows="85,30%,*";
	}

	function selectLanguage()
	{
		parent.setCurrentLanguage(languageSelect.options[languageSelect.selectedIndex].value);
	}

	function selectTab(value)
	{
		updateTabView(value);
		parent.frameProduct.setCurrentTab(value);
	}

	//////////////////////////////////////////////////////////////////////////////////////
	// updateTabView(value) 
	//
	// - sets the tab bar to display the correct colors and images
	//////////////////////////////////////////////////////////////////////////////////////
	function updateTabView(value)
	{
		var index = value*2;

		if (savedTab == index) return;

		table1.rows[0].cells[index+1].style.backgroundImage = 'url("/wcs/images/tools/catalog/tabbgactive.bmp")';
		table1.rows[0].cells[savedTab+1].style.backgroundImage = 'url("/wcs/images/tools/catalog/tabbg.bmp")';

		// make active
		var cell = table1.rows[0].cells[index+1];
		cell.style.backgroundColor="WHITE";

		// before image
		if (index != 0) {
		   cell = table1.rows[0].cells[index];
		   cell.innerHTML = "<IMG alt='' SRC='/wcs/images/tools/catalog/inatoa.bmp' HEIGHT=23>";
		}

		// after image
		if (index != <%=tableCells-3%>) {
		   cell = table1.rows[0].cells[index+2];
		   cell.innerHTML = "<IMG alt='' SRC='/wcs/images/tools/catalog/atoina.bmp' HEIGHT=23>";
		} else {
		   cell = table1.rows[0].cells[index+2];
		   cell.innerHTML = "<IMG alt='' SRC='/wcs/images/tools/catalog/atoend.bmp' HEIGHT=23>";
		}

		// make inactive
		cell = table1.rows[0].cells[savedTab+1];
		cell.style.backgroundColor="#91B3DE";

		// before image
		if (savedTab != 0 && savedTab != (index+2)) {
		   cell = table1.rows[0].cells[savedTab];
		   cell.innerHTML = "<IMG alt='' SRC='/wcs/images/tools/catalog/inatoina.bmp' HEIGHT=23>";
		}

		// after image
		if (savedTab != (index-2)) {
		   if (savedTab != <%=tableCells-3%>) {
		      cell = table1.rows[0].cells[savedTab+2];
		      cell.innerHTML = "<IMG alt='' SRC='/wcs/images/tools/catalog/inatoina.bmp' HEIGHT=23>";
		   } else {
		      cell = table1.rows[0].cells[savedTab+2];
		      cell.innerHTML = "<IMG alt='' SRC='/wcs/images/tools/catalog/inatoend.bmp' HEIGHT=23>";
		   }
		}

		// make first tab image shows correctly
		if (value != 0) {
		      cell = table1.rows[0].cells[0];
		      cell.innerHTML = "<IMG alt='' SRC='/wcs/images/tools/catalog/lefttabunselected.bmp' HEIGHT=23>";
		} else {
		      cell = table1.rows[0].cells[0];
		      cell.innerHTML = "<IMG alt='' SRC='/wcs/images/tools/catalog/lefttabselected.bmp' HEIGHT=23>";
		}
		savedTab = index;
	}

<%
	String strTitle = (String)rbProduct.get("attribute_title_definingAttribute");
	int i1 = strTitle.indexOf("?");
	if (i1 >= 0) {
		//icu4j changes
		//strTitle = strTitle.substring(0, i1) + bnProduct.getPartNumber() + strTitle.substring(i1 + 1);
	
		int offset1=UTF16.findOffsetFromCodePoint(strTitle,i1);
		int offset2=UTF16.findOffsetFromCodePoint(strTitle,i1 + 1);
		strTitle = strTitle.substring(0, offset1) + bnProduct.getPartNumber() + strTitle.substring(offset2);
	}
%>

</SCRIPT>

</HEAD>

<BODY CLASS=tabtitle BGCOLOR=WHITE SCROLL=auto ONLOAD=onLoad() style="background-color:#EFEFEF;">

	<TABLE ID=menubar WIDTH=100% BORDER=0 CELLPADDING=0 CELLSPACING=0 STYLE="margin-bottom:0px;margin-top:0px;">
		<!--TR ALIGN=RIGHT VALIGN=CENTER-->
		<TR>
			<TD style="padding-left=14px;"><H1>
				<%= UIUtil.toHTML((String)strTitle) %>
			</H1></TD>
			<TD ALIGN=RIGHT VALIGN=TOP><label for="languageSelect"><%=UIUtil.toHTML((String)rbProduct.get("attribute_languageSelection"))%>&nbsp;</label><SELECT ID="languageSelect" ONCHANGE=selectLanguage()></SELECT>&nbsp;&nbsp;&nbsp;</TD>
		</TR>
	</TABLE>

	<TABLE ID=table1 WIDTH=100% MARGIN=0 BORDER=0 BGCOLOR=#EFEFEF CELLSPACING=0 CELLPADDING=0  STYLE="margin-bottom:0px;margin-top:0px;">   
		<TR CLASS=tab>
			<TD STYLE="border-width: 0 0 0 0;"><IMG alt='' SRC="/wcs/images/tools/catalog/lefttabselected.bmp" HEIGHT=23></TD>
			<TD CLASS=activetab  onClick=selectTab(0) NOWRAP STYLE='height: 23px; background-image: url("/wcs/images/tools/catalog/tabbgactive.bmp");'>
			   &nbsp;<%=UIUtil.toHTML((String)rbProduct.get("attribute_general"))%>&nbsp;
			</TD>
			<TD CLASS=tabend>
			   <IMG alt='' SRC="/wcs/images/tools/catalog/atoina.bmp" HEIGHT=23>
			</TD>
			<TD CLASS=inactivetab  onClick=selectTab(1) NOWRAP STYLE='height: 23px; background-image: url("/wcs/images/tools/catalog/tabbg.bmp");'>
			   &nbsp;<%=UIUtil.toHTML((String)rbProduct.get("attribute_description"))%>&nbsp;
			</TD>
			<TD CLASS=tabend>
			   <IMG alt='' SRC="/wcs/images/tools/catalog/inatoina.bmp" HEIGHT=23>
			</TD>
			<TD CLASS=inactivetab onClick=selectTab(2) NOWRAP STYLE='height: 23px; background-image: url("/wcs/images/tools/catalog/tabbg.bmp");'>
			   &nbsp;<%=UIUtil.toHTML((String)rbProduct.get("attribute_customField"))%>&nbsp;
			</TD>

			<TD CLASS=tabend>
			   <IMG alt='' SRC="/wcs/images/tools/catalog/inatoend.bmp" HEIGHT=23>
			</TD>
			<TD WIDTH=100% STYLE='height: 23px;  background-image: url("/wcs/images/tools/catalog/bottom.bmp");'>&nbsp;</TD>
		</TR>
	</TABLE>

</BODY>
</HTML>



