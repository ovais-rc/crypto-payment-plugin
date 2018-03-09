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
<%@ page import="com.ibm.commerce.catalog.beans.*" %>

<%@include file="../common/common.jsp" %>

<%
	CommandContext cmdContext = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
	Hashtable rbProduct = (Hashtable)ResourceDirectory.lookup("catalog.ProductNLS", cmdContext.getLocale());
	String catentryId  = request.getParameter("catentryID"); 
	Integer [] iLanguages = cmdContext.getStore().getSupportedLanguageIds();
	Integer storeDefLangId = cmdContext.getStore().getLanguageIdInEntityType();

	// Define the number of tabs
	int totalTabs = 3;
	int tableCells = (totalTabs * 2) + 1;


	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	// If a catentryId has been passed then load the appropriate data
	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	String strCode = "";
	if (catentryId != null && catentryId.equals("null") == false)
	{
		CatalogEntryDataBean bnNewEntry = new CatalogEntryDataBean();
		bnNewEntry.setCatalogEntryID(catentryId);
		DataBeanManager.activate(bnNewEntry, cmdContext);
		strCode = UIUtil.toJavaScript(bnNewEntry.getPartNumber());
	}

%>

<HTML>
<HEAD>

<LINK rel=stylesheet href="<%= UIUtil.getCSSFile(cmdContext.getLocale()) %>" type="text/css">

<SCRIPT>

	var savedTab = 0;  // Currently selected menu tab


	//////////////////////////////////////////////////////////////////////////////////////
	// selectTab(value) 
	//
	// - sets the tab to the selected tab
	//////////////////////////////////////////////////////////////////////////////////////
	function selectTab(value)
	{
		updateTabView(value);
		parent.contentFrame.setCurrentTab(value);
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
		cell.style.backgroundColor="#EFEFEF";

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

	
	function onLoad()
	{
		languageSelect.selectedIndex = 0;
		top.put("descriptiveAttributeLanguageIndex", 0);
		top.put("descriptiveAttributeLanguageId", languageSelect.options[0].value);
		if (parent.contentFrame && parent.contentFrame.displayView) parent.contentFrame.displayView();
	}


	function selectLanguage()
	{
		top.put("descriptiveAttributeLanguageIndex", languageSelect.selectedIndex);
		top.put("descriptiveAttributeLanguageId"   , languageSelect.options[languageSelect.selectedIndex].value);
		parent.contentFrame.displayView();
	}

	function replaceField(source, pattern, replacement) 
	{
		index1 = source.indexOf(pattern);
		index2 = index1 + pattern.length;
		return source.substring(0, index1) + replacement + source.substring(index2);
	}

</SCRIPT>
	
</HEAD>

<BODY CLASS=tabtitle SCROLL=auto ONLOAD=onLoad() style="background-color:#EFEFEF; margin-top:0;">

	<H1 style="padding-left:13px;">
		<SCRIPT>
			document.writeln(replaceField("<%= UIUtil.toJavaScript((String)rbProduct.get("productUpdateDetail_DescriptiveAttributesTitle")) %>", "?", "<%=strCode%>"));
		</SCRIPT>
	</H1>

	<TABLE WIDTH=100% MARGIN=0 BORDER=0 BGCOLOR=#EFEFEF CELLSPACING=0 CELLPADDING=0>   
		<TR>
			<TD ALIGN=RIGHT>
			<LABEL for="languageSelect"><%=UIUtil.toHTML((String)rbProduct.get("attribute_languageSelection"))%></LABEL>&nbsp;
				<SELECT ID=languageSelect ONCHANGE=selectLanguage()>
<%
				// Add the default language
				// if the description does not exit, we try to use the one in the store default language
				LanguageDescriptionDataBean bnLanguage = new LanguageDescriptionDataBean();
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
				<OPTION VALUE="<%=storeDefLangId%>" SELECTED><%=UIUtil.toHTML(bnLanguage.getDescription())%>
<%
				//Add the alternate languages
				// if the description does not exit, we try to use the one in the store default language
				for (int i=0; i<iLanguages.length; i++) 
				{
					if (iLanguages[i].intValue() ==  storeDefLangId.intValue()) { continue; }
					try {
						bnLanguage = new LanguageDescriptionDataBean();
						bnLanguage.setDataBeanKeyDescriptionLanguageId(iLanguages[i].toString());
						bnLanguage.setDataBeanKeyLanguageId(cmdContext.getLanguageId().toString());
						DataBeanManager.activate(bnLanguage, cmdContext);
					} catch (Exception ex) {
						bnLanguage = new LanguageDescriptionDataBean();
						bnLanguage.setDataBeanKeyDescriptionLanguageId( iLanguages[i].toString() );
						bnLanguage.setDataBeanKeyLanguageId(storeDefLangId.toString() );
						DataBeanManager.activate(bnLanguage, cmdContext);			
					}
%>
					<OPTION VALUE="<%=iLanguages[i]%>"><%=UIUtil.toHTML(bnLanguage.getDescription())%>
<%
				}
%>
				</SELECT>
				&nbsp;&nbsp;&nbsp;
			</TD>
		</TR>
	</TABLE>

	<TABLE ID=table1 WIDTH=100% MARGIN=0 BORDER=0 BGCOLOR=WHITE CELLSPACING=0 CELLPADDING=0>   
		<TR CLASS=tab>
			<TD STYLE="border-width: 0 0 0 0;"><IMG alt='' SRC="/wcs/images/tools/catalog/lefttabselected.bmp" HEIGHT=23></TD>
			<TD CLASS=activetab  onClick=selectTab(0) NOWRAP STYLE='height: 23px; background-image: url("/wcs/images/tools/catalog/tabbgactive.bmp");'>
				&nbsp;<%=UIUtil.toHTML((String)rbProduct.get("attribute_general"))%>&nbsp;
			</TD>
			<TD CLASS=tabend STYLE="border-width: 0 0 0 0;">
				<IMG alt='' SRC="/wcs/images/tools/catalog/atoina.bmp" HEIGHT=23>
			</TD>                                            
			<TD CLASS=activetab  onClick=selectTab(1) NOWRAP STYLE='height: 23px; background-image: url("/wcs/images/tools/catalog/tabbg.bmp");'>
				&nbsp;<%=UIUtil.toHTML((String)rbProduct.get("attribute_description"))%>&nbsp;
			</TD>
			<TD CLASS=tabend STYLE="border-width: 0 0 0 0;">
				<IMG alt='' SRC="/wcs/images/tools/catalog/inatoina.bmp" HEIGHT=23>
			</TD>                                            
			<TD CLASS=activetab  onClick=selectTab(2) NOWRAP STYLE='height: 23px; background-image: url("/wcs/images/tools/catalog/tabbg.bmp");'>
				&nbsp;<%=UIUtil.toHTML((String)rbProduct.get("attribute_customField"))%>&nbsp;
			</TD>
			<TD CLASS=tabend STYLE="border-width: 0 0 0 0;">
				<IMG alt='' SRC="/wcs/images/tools/catalog/inatoend.bmp"  HEIGHT=23>
			</TD>
			<TD WIDTH=100% STYLE='height: 23px;  background-image: url("/wcs/images/tools/catalog/bottom.bmp");'>&nbsp;</TD>
		</TR>
	</TABLE>


</BODY>
</HTML>



