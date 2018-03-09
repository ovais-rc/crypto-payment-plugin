<%--
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
//*-------------------------------------------------------------------
//*
--%>


<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
<%
//---------------------------------------------------------------------
//- Import and Include Section
//---------------------------------------------------------------------
%>
<%@ page language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@page import="com.ibm.commerce.tools.util.UIUtil" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>

<%@page import="com.ibm.commerce.catalog.objects.*" %>
<%@page import="com.ibm.commerce.catalog.beans.*" %>

<%@include file="../common/common.jsp" %>
<%@include file="CatalogSearchUtil.jsp" %> 
<%@include file="KitUtil.jsp" %> 


<%
	CommandContext 	cmdContext = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
   	Locale 			jLocale = cmdContext.getLocale();
    Hashtable		nlsKit = (Hashtable) ResourceDirectory.lookup("catalog.KitNLS", jLocale);
    
	CatalogEntryDataBean arrayDbCatentry[]= null;
	
	if(catEntrySearchDB!=null) 
	{   
   		arrayDbCatentry = catEntrySearchDB.getResultList();
   	}	

%>

<HTML>
<HEAD>

<LINK rel=stylesheet href="<%= UIUtil.getCSSFile(jLocale) %>" type="text/css">

<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/common/Vector.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/catalog/KitContents.js"></SCRIPT>

<SCRIPT LANGUAGE="JavaScript">

//////////////////////////////////////////////////////////////////////////////////////////////
var arraySKUPickList = null;

function saveSKUPickList(arraySKUList)
{
    //top.saveData(arraySKUList, SKU_PICK_LIST);
    top.sendBackData(arraySKUList, SKU_PICK_LIST);
}

function retrieveSKUPickList()
{
	var arraySKUList=top.getData(SKU_PICK_LIST,1);

	if(arraySKUList != null)
		arraySKUList = cloneSKUArray(arraySKUList);
	else
		arraySKUList = new Array();	
	
	return arraySKUList;
}

//////////////////////////////////////////////////////////////////////////////////////////////
function findMoreSKUs()
{
   	// save the model before launching the search dialog
   	top.saveModel(parent.model);

	var strURL= top.getWebPath() + "DialogView";
	var	param= new Object();
		param["XMLFile"]="catalog.catEntrySearchDialog";
		param["redirectURL"]=strURL;
		param["redirectCmd"]="KitItemPickListLayoutView";
		param["redirectXML"]="catalog.KitItemPickupDialog";
		param["actionEP"]="GO_BACK";
		
		//D40138
		//SearchDialog will overwite redirectCmd, 
		//we can check the redirectCmd ONLY first time coming to this page
		//Change to save the search type to top		
<%
	JSPHelper jspHelper	= new JSPHelper(request);	
	String strCmd	= jspHelper.getParameter("redirectCmd");
	if((strCmd!=null)&&(strCmd.equals("MAssocLayoutView")))
	{	
%>		
		top.saveData("catentry","_SEARCH_TYPE");	//Search all catentries	
<%	} %>
		
	var strSearchType = top.getData("_SEARCH_TYPE");
	if( strSearchType == null)
		strSearchType= "item";						//Only search for items
		
	var strSearchBCT;
	if(strSearchType== "item")
		strSearchBCT="<%=getNLString(nlsKit,"bctFindSKU")%>";
	else
		strSearchBCT="<%=getNLString(nlsKit,"bctFindCatalogEntries")%>";	
		
	param["searchType"]=strSearchType;				
	parent.setContentFrameLoaded(false);
	
   	top.setContent(strSearchBCT, strURL, true, param);
}

function buttonSelect_onClick()
{
	saveSKUPickList(arraySKUPickList);

	var urlParam=top.mccbanner.trail[top.mccbanner.counter-1].parameters;
		if(urlParam==null)
			urlParam= new Object();
		urlParam['actionKit']= SKU_PICK_ACTION_ADD;
		//urlParam['searchType']=null;
		//urlParam['actionEP']=null;

	top.mccbanner.counter --;
	top.mccbanner.showbct();
		
	top.showContent(top.mccbanner.trail[top.mccbanner.counter].location, urlParam);
}

function buttonCancel_onClick()
{
	//saveSKUPickList(arraySKUPickList);
	var urlParam=top.mccbanner.trail[top.mccbanner.counter-1].parameters;
		if(urlParam==null)
			urlParam= new Object();
		urlParam['actionKit']= SKU_PICK_ACTION_NONE;

	top.mccbanner.counter --;
	top.mccbanner.showbct();
		
	top.showContent(top.mccbanner.trail[top.mccbanner.counter].location,urlParam);
}

//////////////////////////////////////////////////////////////////////////////////////////////
function mergeSKUSearchResults()
{
	arraySKUPickList = retrieveSKUPickList();

	<% if(arrayDbCatentry!= null) 
	   {	
	   	for(int i=0; i< arrayDbCatentry.length; i++)
	   	 {
			CatalogEntryDataBean dbCatentry = arrayDbCatentry[i];
			dbCatentry.setCommandContext(cmdContext);
			
			String strCatentryId= dbCatentry.getCatalogEntryReferenceNumber();	
			String strPartNumber = dbCatentry.getPartNumber();
			String strName = getName(dbCatentry);								//SearchUtil
			String strShotDesc = getShortDescription(dbCatentry);				//SearchUtil
			String strType = dbCatentry.getType();				//SearchUtil
			
	%>
			
			var oSKU= new SKUObj("<%=strCatentryId %>",
							 	 "<%= toJavaScript(strPartNumber) %>",
							 	 "<%= toJavaScript(strName) %>",
							 	 "<%= toJavaScript(strShotDesc) %>",
							 	 -1, -1, "<%=strType%>");				
			if(!isSKUinArray(oSKU.partNumber, arraySKUPickList))
				arraySKUPickList[arraySKUPickList.length]=oSKU;
		<%} //Eof for%>
	<%  } //Eof if%>
	
	saveSKUPickList(arraySKUPickList);
}

//////////////////////////////////////////////////////////////////////////////////////////////
var nFramesLoaded=0;
function initAllFrames()
{
	nFramesLoaded++;
	
	if(nFramesLoaded == 2)
	{
		mergeSKUSearchResults();
		
		List.init();
		//ListBtn
		parent.setContentFrameLoaded(true);
	}
}

</SCRIPT>

<META name="GENERATOR" content="IBM WebSphere Studio">
</HEAD>

<script>
	
	var strWebPath= top.getWebPath();
	
	document.write("<FRAMESET COLS=87%,13% BORDER=0 >	");
	document.write("	<FRAME NAME = List SRC= '" + strWebPath + "KitItemPickListView' title='<%=getNLString(nlsKit,"fmSKUList")%>' FRAMEBORDER=0  NORESIZE SCROLLING=AUTO MARGINWIDTH=0 MARGINHEIGHT=0 >	");
	document.write("	<FRAME NAME = ListBtn SRC= '" + strWebPath + "KitItemPickListBtnView' title='<%=getNLString(nlsKit,"fmSKUListBtn")%>' FRAMEBORDER=0  NORESIZE SCROLLING=AUTO MARGINWIDTH=0 MARGINHEIGHT=0 >	");
	document.write("</FRAMESET >	");
	
</script>

</HTML>

