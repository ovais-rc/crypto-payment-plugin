<!--
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2003, 2016
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
-->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">

<HTML>
<HEAD>

<%@ page import = "java.util.*" %>
<%@ page import = "com.ibm.commerce.command.CommandContext" %>
<%@ page import = "com.ibm.commerce.tools.util.*" %>
<%@ page import = "com.ibm.commerce.catalog.beans.*" %>
<%@ page import = "com.ibm.commerce.catalog.objects.*" %>
<%@ page import = "com.ibm.commerce.beans.DataBeanManager" %>
<%@ page import = "com.ibm.commerce.common.beans.LanguageDescriptionDataBean"%>

<%@include file="../common/common.jsp" %>

<%
	CommandContext cmdContext = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
	Hashtable rbCategory = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("catalog.CatalogNLS", cmdContext.getLocale());
	Integer [] iLanguages = cmdContext.getStore().getSupportedLanguageIds();
	Integer storeDefLangId = cmdContext.getStore().getLanguageIdInEntityType();
	Vector vLanguages = new Vector();

	for (int i=0; i<iLanguages.length; i++)
	{
		if (iLanguages[i].intValue() == storeDefLangId.intValue())
		{
			iLanguages[i] = iLanguages[0];
			iLanguages[0] = storeDefLangId;
		}
	}
%>

<TITLE><%=UIUtil.toHTML((String)rbCategory.get("NavCatCatalogCreateContent_Title"))%></TITLE>
<link rel=stylesheet href="<%= UIUtil.getCSSFile(cmdContext.getLocale()) %>" type="text/css">
 
<SCRIPT LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT> 
<SCRIPT LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/catalog/NavCatCommonFunctions.js"></SCRIPT> 

<SCRIPT>

	var selectedLanguageIndex = 0;
	var vLanguages = new Array();

<%
	for (int i=0; i<iLanguages.length; i++) 
	{
		LanguageDescriptionDataBean bnLanguage = new LanguageDescriptionDataBean();
		bnLanguage.setDataBeanKeyDescriptionLanguageId(iLanguages[i].toString());
		bnLanguage.setDataBeanKeyLanguageId(cmdContext.getLanguageId().toString());
		DataBeanManager.activate(bnLanguage, cmdContext);
		vLanguages.addElement(bnLanguage.getDescription());
%>
		vLanguages[<%=i%>] = new descriptionObject("<%=iLanguages[i]%>");
<%
	}
%>

	//////////////////////////////////////////////////////////////////////////////////////
	// descriptionObject(languageId) 
	//
	// @param languageId - the language of this description object
	//
	// - this defines the description object for the specified language
	//////////////////////////////////////////////////////////////////////////////////////
	function descriptionObject(languageId) 
	{
		this.languageId = languageId;
		this.name             = "";
		this.shortDescription = "";
		this.longDescription  = "";
		this.thumbnail        = "";
		this.fullimage        = "";
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// onLoad() 
	//
	// - this function is called upon load of the frame
	//////////////////////////////////////////////////////////////////////////////////////
	function onLoad()
	{
		languageSelect.selectedIndex = selectedLanguageIndex;
		selectLanguage();
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// okButton() 
	//
	// - this function validates the fields and submits the catalog for creation
	//////////////////////////////////////////////////////////////////////////////////////
	function okButton() 
	{
		updateLanguageInfo();
		if (validateParameters() == false) return;

		// Construct output object
		var outputObject = new Object();
		outputObject.catalogCode = trim(CatalogCode.value);
		outputObject.catalogDesc = CatalogDesc.value;
		outputObject.languages    = vLanguages;

		parent.catalogCreateButtons.submitFunction("NavCatCatalogCreateControllerCmd", outputObject);
	} 


	//////////////////////////////////////////////////////////////////////////////////////
	// validateParameters() 
	//
	// - this function checks to ensure all necessary conditions are met
	//////////////////////////////////////////////////////////////////////////////////////
	function validateParameters()
	{

		if (isInputStringEmpty(CatalogCode.value))
		{
			alertDialog("<%=UIUtil.toJavaScript(rbCategory.get("NavCatCatalogCreate_ErrorMissingCode"))%>");
			return false;
		}


		for (var i=0; i<vLanguages.length; i++)
		{
			var current = vLanguages[i];

		
			if (isInputStringEmpty(current.name))
			{
				//if this is the non-default language, check to make sure that this catalog 
				//exists in the default language before creating in the non-default language
	
				if (current.languageId == "<%=cmdContext.getStore().getLanguageId()%>")
				{
					focusByLanguageAndElement(i, CategoryName);
					alertDialog("<%=UIUtil.toJavaScript(rbCategory.get("NavCatCatalogCreate_ErrorMissingDefaultName"))%>");
					return false;
				}
				else
				{					
					if (isInputStringEmpty(current.shortDescription) == false || isInputStringEmpty(current.longDescription) == false || isInputStringEmpty(current.thumbnail) == false || isInputStringEmpty(current.fullimage) == false)
					{
						focusByLanguageAndElement(i, CategoryName);
						alertDialog("<%=UIUtil.toJavaScript(rbCategory.get("NavCatCatalogCreate_ErrorMissingName"))%>");
						return false;
					}
				}
			}

			if(i==0)
			{
				if (isValidUTF8length(CatalogCode.value, 254) == false) 
				{ 
					focusByLanguageAndElement(i, CatalogCode);
					alertDialog("<%= UIUtil.toJavaScript((String)rbCategory.get("fieldSizeExceeded"))%>"); 
					return false;
				}
				
				if (isValidUTF8length(CatalogDesc, 254) == false) 
				{ 
					focusByLanguageAndElement(i, CatalogDesc);
					alertDialog("<%= UIUtil.toJavaScript((String)rbCategory.get("fieldSizeExceeded"))%>"); 
					return false;
				}
			}
			
			if (isValidUTF8length(current.name, 254) == false) 
			{ 
				focusByLanguageAndElement(i, CategoryName);
				alertDialog("<%= UIUtil.toJavaScript((String)rbCategory.get("fieldSizeExceeded"))%>"); 
				return false;
			}

			if (isValidCatalogName(current.name) == false) 
			{ 
				focusByLanguageAndElement(i, CategoryName);
				alertDialog("<%= UIUtil.toJavaScript((String)rbCategory.get("invalidCatalogName"))%>"); 
				return false;
			}


			if (isValidUTF8length(current.shortDescription, 254) == false) 
			{ 
				focusByLanguageAndElement(i, CategoryShortDesc);
				alertDialog("<%= UIUtil.toJavaScript((String)rbCategory.get("fieldSizeExceeded"))%>"); 
				return false;
			}

			if (isValidUTF8length(current.thumbnail, 254) == false) 
			{ 
				focusByLanguageAndElement(i, CategoryThumbNail);
				alertDialog("<%= UIUtil.toJavaScript((String)rbCategory.get("fieldSizeExceeded"))%>"); 
				return false;
			}

			if (isValidUTF8length(current.fullimage, 254) == false) 
			{ 
				focusByLanguageAndElement(i, CategoryFullImage);
				alertDialog("<%= UIUtil.toJavaScript((String)rbCategory.get("fieldSizeExceeded"))%>"); 
				return false;
			}
		}

		return true;
	}

	//Disallow illegal characters for category name
	//This function is copied from CategoryGeneral.jsp
	function isValidCatalogName(myString) {
	    var invalidChars = "<>"; // invalid chars
	    invalidChars += "\t"; // escape sequences
	    
	    // if the string is empty it is not a valid name
	    //if (isEmpty(myString)) return false;
	 
	    // look for presence of invalid characters.  if one is
	    // found return false.  otherwise return true
	    for (var i=0; i<myString.length; i++) {
	      if (invalidChars.indexOf(myString.substring(i, i+1)) >= 0) {
	        return false;
	      }
	    }    
	        
	    return true;
	}

	//////////////////////////////////////////////////////////////////////////////////////
	// focusByLanguageAndElement(index, element) 
	//
	// @param iLanguage - the language id of the select box to focus on
	// @param element - the element to move the focus to
	//
	// - this function saves the values when a language is selected
	//////////////////////////////////////////////////////////////////////////////////////
	function focusByLanguageAndElement(index, element) 
	{
		languageSelect.selectedIndex = index;
		selectLanguage();
		element.focus();
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// selectLanguage() 
	//
	// - this function saves the values when a language is selected
	//////////////////////////////////////////////////////////////////////////////////////
	function selectLanguage()
	{
		var i = languageSelect.selectedIndex;
		if (i == 0)
		{
			CatalogCode.disabled = false;
			CatalogDesc.disabled = false;
			CategoryName.value      = vLanguages[i].name;
			CategoryShortDesc.value = vLanguages[i].shortDescription;
			CategoryLongDesc.value  = vLanguages[i].longDescription;
			CategoryThumbNail.value = vLanguages[i].thumbnail;
			CategoryFullImage.value = vLanguages[i].fullimage;
		}
		else
		{
			if (trim(CatalogCode.value) == "")
			{
				alertDialog("<%= UIUtil.toJavaScript((String)rbCategory.get("NavCatCatalogCreate_ErrorDefaultLangFirst"))%>"); 
				languageSelect.selectedIndex = 0;

			}
			else
			{
				CatalogCode.disabled = true;
				CatalogDesc.disabled = true;
				CategoryName.value      = vLanguages[i].name;
				CategoryShortDesc.value = vLanguages[i].shortDescription;
				CategoryLongDesc.value  = vLanguages[i].longDescription;
				CategoryThumbNail.value = vLanguages[i].thumbnail;
				CategoryFullImage.value = vLanguages[i].fullimage;
			}
		}

	}


	//////////////////////////////////////////////////////////////////////////////////////
	// updateLanguageInfo() 
	//
	// - this function updates the information upon language change
	//////////////////////////////////////////////////////////////////////////////////////
	function updateLanguageInfo()
	{
		var i = languageSelect.selectedIndex;
		vLanguages[i].name             = CategoryName.value;
		vLanguages[i].shortDescription = CategoryShortDesc.value;
		vLanguages[i].longDescription  = CategoryLongDesc.value;
		vLanguages[i].thumbnail        = CategoryThumbNail.value;
		vLanguages[i].fullimage        = CategoryFullImage.value;
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// handleEnterPressed() 
	//
	// - perform a default action if the enter key is pressed
	//////////////////////////////////////////////////////////////////////////////////////
	function handleEnterPressed() 
	{
		if(event.keyCode != 13) return;
		if(event.srcElement==CatalogDesc) return;
		if(event.srcElement==CategoryShortDesc) return;
		if(event.srcElement==CategoryLongDesc) return;

		okButton();
	}

</SCRIPT>
</HEAD>

<BODY CLASS=content ONLOAD=onLoad() ONKEYPRESS=handleEnterPressed() ONCONTEXTMENU="return false;" >

	<H1><%=UIUtil.toHTML((String)rbCategory.get("NavCatCatalogCreateContent_TitleText"))%></H1>

	<TABLE>   
		<TR><TD><LABEL for="CatalogCode"><%=UIUtil.toHTML((String)rbCategory.get("NavCatCatalogCreate_Code"))%></LABEL></TD></TR>
		<TR><TD><INPUT SIZE=32 MAXLENGTH=254 ID="CatalogCode" NAME=CatalogCode VALUE=""></TD></TR>
		<TR HEIGHT=5><TD HEIGHT=5></TD></TR>
		<TR><TD><LABEL for="CatalogDesc"><%=UIUtil.toHTML((String)rbCategory.get("NavCatCatalogCreate_Desc"))%></LABEL></TD></TR>
		<TR><TD><TEXTAREA ID="CatalogDesc" NAME=CatalogDesc ROWS=3 COLS=50 WRAP="HARD"></TEXTAREA></TD></TR>
		<TR HEIGHT=5><TD HEIGHT=5></TD></TR>
		<TR><TD><LABEL for="languageSelect"><%=UIUtil.toHTML((String)rbCategory.get("NavCat_Language"))%></LABEL></TD></TR>
		<TR><TD>
			<SELECT ID=languageSelect ONCHANGE=selectLanguage()>
<% 		for (int i=0; i<iLanguages.length; i++) { %>
				<OPTION VALUE="<%=iLanguages[i]%>"><%=(String)vLanguages.elementAt(i)%>
<% 		} %>
			</SELECT>
		</TD></TR>
		<TR HEIGHT=5><TD HEIGHT=5></TD></TR>
		<TR><TD><LABEL for="CategoryName"><%=UIUtil.toHTML((String)rbCategory.get("NavCatCatalogCreate_Name"))%></LABEL></TD></TR>
		<TR><TD><INPUT SIZE=32 MAXLENGTH=254 ONBLUR=updateLanguageInfo() ID="CategoryName" NAME=CategoryName VALUE=""></TD></TR>
		<TR HEIGHT=5><TD HEIGHT=5></TD></TR>
		<TR><TD><LABEL for="CategoryShortDesc"><%=UIUtil.toHTML((String)rbCategory.get("NavCatCatalogCreate_ShortDesc"))%></LABEL></TD></TR>
		<TR><TD><TEXTAREA ONBLUR=updateLanguageInfo() ID="CategoryShortDesc" NAME=CategoryShortDesc ROWS=3 COLS=50 WRAP="HARD"></TEXTAREA></TD></TR>
		<TR HEIGHT=5><TD HEIGHT=5></TD></TR>
		<TR><TD><LABEL for="CategoryLongDesc"><%=UIUtil.toHTML((String)rbCategory.get("NavCatCatalogCreate_LongDesc"))%></LABEL></TD></TR>
		<TR><TD><TEXTAREA ONBLUR=updateLanguageInfo() ID="CategoryLongDesc" NAME=CategoryLongDesc ROWS=3 COLS=50 WRAP="HARD"></TEXTAREA></TD></TR>
		<TR HEIGHT=5><TD HEIGHT=5></TD></TR>
		<TR><TD><LABEL for="CategoryThumbNail"><%=UIUtil.toHTML((String)rbCategory.get("NavCatCatalogCreate_Thumbnail"))%></LABEL></TD></TR>
		<TR><TD><INPUT SIZE=60 MAXLENGTH=254 ONBLUR=updateLanguageInfo() ID="CategoryThumbNail" NAME=CategoryThumbNail VALUE=""></TD></TR>
		<TR HEIGHT=5><TD HEIGHT=5></TD></TR>
		<TR><TD><LABEL for="CategoryFullImage"><%=UIUtil.toHTML((String)rbCategory.get("NavCatCatalogCreate_Fullimage"))%></LABEL></TD></TR>
		<TR><TD><INPUT SIZE=60 MAXLENGTH=254 ONBLUR=updateLanguageInfo() ID="CategoryFullImage" NAME=CategoryFullImage VALUE=""></TD></TR>
	</TABLE>
 
</BODY>
</HTML>
