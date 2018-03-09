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
	
	com.ibm.commerce.server.JSPHelper helper = new com.ibm.commerce.server.JSPHelper(request);
	String strCatalogId = helper.getParameter("catalogId");
	String strCatgroupId = helper.getParameter("catgroupId");
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

	CatalogGroupAccessBean abCatgroup = new CatalogGroupAccessBean();
	abCatgroup.setInitKey_catalogGroupReferenceNumber(strCatgroupId);
		
%>

<TITLE><%=UIUtil.toHTML((String)rbCategory.get("NavCatSourceUpdateCategory_Title"))%></TITLE>
<link rel=stylesheet href="<%= UIUtil.getCSSFile(cmdContext.getLocale()) %>" type="text/css">
 
<SCRIPT LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT> 

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

		try 
		{
			CatalogGroupDescriptionAccessBean abCatgroupDesc = abCatgroup.getDescription(iLanguages[i]);
%>
			vLanguages[<%=i%>] = new descriptionObject("<%=iLanguages[i]%>") ;
			vLanguages[<%=i%>].name             = "<%=UIUtil.toJavaScript(abCatgroupDesc.getName())%>";
			vLanguages[<%=i%>].shortDescription = "<%=UIUtil.toJavaScript(abCatgroupDesc.getShortDescription())%>";
			vLanguages[<%=i%>].longDescription  = "<%=UIUtil.toJavaScript(abCatgroupDesc.getLongDescription())%>";
			vLanguages[<%=i%>].thumbnail        = "<%=UIUtil.toJavaScript(abCatgroupDesc.getThumbNail())%>";
			vLanguages[<%=i%>].fullimage        = "<%=UIUtil.toJavaScript(abCatgroupDesc.getFullIImage())%>";
			vLanguages[<%=i%>].published        = "<%=abCatgroupDesc.getPublished()%>";
<%
		} 
		catch (Exception e) 
		{
%>
			vLanguages[<%=i%>] = new descriptionObject("<%=iLanguages[i]%>") ;
<%
		}
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
		this.published		  = "0";
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
		setPublishedCheckboxes();
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// okButton() 
	//
	// - this function submits the changes when the ok button is clicked
	//////////////////////////////////////////////////////////////////////////////////////
	function okButton() 
	{
		updateLanguageInfo();
		if (validateParameters() == false) return;

		// Construct output
		var obj = new Object();
		obj.catalogId  = "<%=strCatalogId%>";
		obj.catgroupId = "<%=strCatgroupId%>";
		obj.categoryCode = trim(CategoryCode.value);
		obj.languages = vLanguages;
		
		parent.workingFrame.submitFunction("NavCatCategoryUpdateControllerCmd", obj);
	} 


	//////////////////////////////////////////////////////////////////////////////////////
	// selectLanguage() 
	//
	// - this function saves the values when a language is selected
	//////////////////////////////////////////////////////////////////////////////////////
	function selectLanguage()
	{
		var i = languageSelect.selectedIndex;
		if (i != 0) 
			CategoryCode.disabled = true;
		else
			CategoryCode.disabled = false;	
		CategoryName.value      = vLanguages[i].name;
		CategoryShortDesc.value = vLanguages[i].shortDescription;
		CategoryLongDesc.value  = vLanguages[i].longDescription;
		CategoryThumbNail.value = vLanguages[i].thumbnail;
		CategoryFullImage.value = vLanguages[i].fullimage;
		CategoryPublished.checked = (vLanguages[i].published=="1");
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
		vLanguages[i].published		   = (CategoryPublished.checked)? "1":"0";
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// validateParameters() 
	//
	// - this function checks to ensure all necessary conditions are met
	//////////////////////////////////////////////////////////////////////////////////////
	function validateParameters()
	{
		if (isInputStringEmpty(CategoryCode.value))
		{
			alertDialog("<%=UIUtil.toJavaScript(rbCategory.get("NavCatSourceCreateCategory_ErrorMissingCode"))%>");
			return false;
		}

		for (var i=0; i<vLanguages.length; i++)
		{
			var current = vLanguages[i];

			if (isInputStringEmpty(current.name))
			{
				if (current.languageId == "<%=cmdContext.getStore().getLanguageId()%>")
				{
					focusByLanguageAndElement(i, CategoryName);
					alertDialog("<%=UIUtil.toJavaScript(rbCategory.get("NavCatSourceCreateCategory_ErrorMissingDefaultName"))%>");
					return false;
				}
				else
				{
					if (isInputStringEmpty(current.shortDescription) == false || isInputStringEmpty(current.longDescription) == false || isInputStringEmpty(current.thumbnail) == false || isInputStringEmpty(current.fullimage) == false)
					{
						focusByLanguageAndElement(i, CategoryName);
						alertDialog("<%=UIUtil.toJavaScript(rbCategory.get("NavCatSourceCreateCategory_ErrorMissingName"))%>");
						return false;
					}
				}
			}

			if(i==0)
			{
				if (isValidUTF8length(CategoryCode.value, 254) == false) 
				{ 
					focusByLanguageAndElement(i, CategoryCode);
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

			if (isValidCategoryName(current.name) == false) 
			{ 
				focusByLanguageAndElement(i, CategoryName);
				alertDialog("<%= UIUtil.toJavaScript((String)rbCategory.get("invalidCategoryName"))%>"); 
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
	function isValidCategoryName(myString) {
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
	// handleEnterPressed() 
	//
	// - perform a default action if the enter key is pressed
	//////////////////////////////////////////////////////////////////////////////////////
	function handleEnterPressed() 
	{
		if(event.keyCode != 13) return;
		if(event.srcElement==CategoryShortDesc) return;
		if(event.srcElement==CategoryLongDesc) return;
		parent.editFrameButtons.okButton();
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// getPublishedStatus()
	//
	// - return 0: partially published, 1: all languages published, -1: all lanugages unpublished
	//////////////////////////////////////////////////////////////////////////////////////
	function getPublishedStatus()
	{
		var nPublishedCount=0;
		for (var i=0; i<vLanguages.length; i++)
		{
			if(vLanguages[i].published=="1")
				nPublishedCount++;
		}
		if(nPublishedCount==vLanguages.length)
			return 1;
		else if (nPublishedCount==0)		
			return -1;
		else 
			return 0;	
	}
	

	//////////////////////////////////////////////////////////////////////////////////////
	// setPublishedCheckboxes()
	//
	// - set the published checkboxes
	//////////////////////////////////////////////////////////////////////////////////////
	function setPublishedCheckboxes()
	{
		var nPublishedAll= getPublishedStatus();
		if(nPublishedAll==1)
		{
			PublishedAll.checked=true;
			PublishedAll.disabled=false;
			
			CategoryPublished.checked=true;
		}	
		else if (nPublishedAll==0)
		{
			PublishedAll.checked=true;
			PublishedAll.disabled=true;
			
			CategoryPublished.checked= (vLanguages[languageSelect.selectedIndex].published=="1");
		}
		else if (nPublishedAll==-1)
		{
			PublishedAll.checked=false;
			PublishedAll.disabled=false;
			
			CategoryPublished.checked=false;
		}
	}

	//////////////////////////////////////////////////////////////////////////////////////
	// Published_onclick()
	//
	// - event handeler for the CatetoryPublished checkbox
	//////////////////////////////////////////////////////////////////////////////////////
	function Published_onclick()
	{
		//published.checked= !published.checked;
		updateLanguageInfo();
		
		setPublishedCheckboxes();
	}

	//////////////////////////////////////////////////////////////////////////////////////
	// PublishedAll_onclick()
	//
	// - event handeler for the PublishedAll checkbox
	//////////////////////////////////////////////////////////////////////////////////////
	function PublishedAll_onclick()
	{
		var nPublishedStatus= getPublishedStatus();
		if( (nPublishedStatus==1) || (nPublishedStatus==0))
		{
			for (var i=0; i<vLanguages.length; i++)
				vLanguages[i].published="0";
		}
		else if (nPublishedStatus==-1)
		{
			for (var i=0; i<vLanguages.length; i++)
				vLanguages[i].published="1";
		}
		
		setPublishedCheckboxes();
	}
	
	function PublishedAll_KeyUp()
	{
		if(event.keyCode == 32)
			PublishedAll_onclick();
	}
	

</SCRIPT>
</HEAD>

<BODY CLASS=content ONLOAD=onLoad() ONKEYPRESS=handleEnterPressed() >

	<TABLE>   
		<TR><TD><LABEL for="CategoryCode"><%=UIUtil.toHTML((String)rbCategory.get("NavCatSourceCreateCategory_CategoryCode"))%></LABEL></TD></TR>
		<TR VALIGN=TOP><TD><INPUT SIZE=32 MAXLENGTH=254 ID="CategoryCode" NAME=CategoryCode VALUE="<%=UIUtil.toHTML(abCatgroup.getIdentifier())%>"></TD></TR>
		
		<TR HEIGHT=42 > <TD onKeyUp="PublishedAll_KeyUp()" onMouseUp="PublishedAll_onclick()"> <INPUT type="checkbox" onClick="return false;" ID="PublishedAll" name="PublishedAll"> &nbsp;<LABEL for="PublishedAll"><%=UIUtil.toHTML((String)rbCategory.get("NavCatSourceCreateCategory_Publish_AllLang"))%></LABEL></TD></TR>
    	
		<TR><TD><LABEL for="languageSelect"><%=UIUtil.toHTML((String)rbCategory.get("NavCat_Language"))%></LABEL></TD></TR>
		<TR HEIGHT=42 VALIGN=TOP><TD>
			<SELECT ID=languageSelect ONCHANGE=selectLanguage()>
<% 		for (int i=0; i<iLanguages.length; i++) { %>
				<OPTION VALUE="<%=iLanguages[i]%>"><%=(String)vLanguages.elementAt(i)%>
<% 		} %>
			</SELECT>
		</TD></TR>
		<TR><TD><LABEL for="CategoryName"><%=UIUtil.toHTML((String)rbCategory.get("NavCatSourceCreateCategory_Name"))%></LABEL></TD></TR>
		<TR HEIGHT=42 VALIGN=TOP><TD><INPUT SIZE=32 MAXLENGTH=254 ONBLUR=updateLanguageInfo() ID="CategoryName" NAME=CategoryName VALUE=""></TD></TR>
		<TR><TD><LABEL for="CategoryShortDesc"><%=UIUtil.toHTML((String)rbCategory.get("NavCatSourceCreateCategory_ShortDesc"))%></LABEL></TD></TR>
		<TR HEIGHT=42 VALIGN=TOP><TD><TEXTAREA ONBLUR=updateLanguageInfo() ID="CategoryShortDesc" NAME=CategoryShortDesc ROWS=3 COLS=50 WRAP="HARD"></TEXTAREA></TD></TR>
		<TR><TD><LABEL for="CategoryLongDesc"><%=UIUtil.toHTML((String)rbCategory.get("NavCatSourceCreateCategory_LongDesc"))%></LABEL></TD></TR>
		<TR HEIGHT=42 VALIGN=TOP><TD><TEXTAREA ONBLUR=updateLanguageInfo() ID="CategoryLongDesc" NAME=CategoryLongDesc ROWS=3 COLS=50 WRAP="HARD"></TEXTAREA></TD></TR>
		<TR><TD><LABEL for="CategoryThumbNail"><%=UIUtil.toHTML((String)rbCategory.get("NavCatSourceCreateCategory_Thumbnail"))%></LABEL></TD></TR>
		<TR HEIGHT=42 VALIGN=TOP><TD><INPUT SIZE=60 MAXLENGTH=254 ONBLUR=updateLanguageInfo() ID="CategoryThumbNail" NAME=CategoryThumbNail VALUE=""></TD></TR>
		<TR><TD><LABEL for="CategoryFullImage"><%=UIUtil.toHTML((String)rbCategory.get("NavCatSourceCreateCategory_Fullimage"))%></LABEL></TD></TR>
		<TR HEIGHT=42 VALIGN=TOP><TD><INPUT SIZE=60 MAXLENGTH=254 ONBLUR=updateLanguageInfo() ID="CategoryFullImage" NAME=CategoryFullImage VALUE=""></TD></TR>
		
		<TR VALIGN=TOP> <TD><INPUT type="checkbox" id="CategoryPublished" name="CategoryPublished" onClick="Published_onclick()"> &nbsp;<LABEL for="CategoryPublished"><%=UIUtil.toHTML((String)rbCategory.get("NavCatSourceCreateCategory_Publish"))%></LABEL></TD></TR>
		
	</TABLE>
 
</BODY>
</HTML>

