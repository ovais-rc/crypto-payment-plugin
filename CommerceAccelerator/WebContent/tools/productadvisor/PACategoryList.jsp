<!-- ==========================================================================
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2002
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
//*
 ===========================================================================-->

<!-- 
  //*----
  //* @deprecated The Product Advisor feature has been deprecated. For more information, see <a href="../../../../../../com.ibm.commerce.productadvisor.doc/concepts/cpaintro.htm">Product Advisor</a>.
  //*----
-->

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
<%@page language="java" import="com.ibm.commerce.beans.DataBeanManager,
	com.ibm.commerce.pa.tools.metaphor.containers.PAGuiConstants,
	com.ibm.commerce.pa.tools.metaphor.containers.PACategoryDataContainer,
	com.ibm.commerce.pa.tools.metaphor.beans.PACategoryListDataBean,
	com.ibm.commerce.pa.tools.searchspace.containers.SearchSpaceMapper,
      com.ibm.commerce.tools.util.*,
	com.ibm.commerce.tools.xml.XMLUtil,
	com.ibm.commerce.server.ConfigProperties,
	com.ibm.commerce.server.ServerConfiguration,
	com.ibm.commerce.tools.common.ui.taglibs.*,
	com.ibm.commerce.tools.common.ui.UIProperties,
	java.util.Hashtable" %>

<%@include file="pacommon.jsp" %>

<%

PACategoryListDataBean categoriesList;
PACategoryDataContainer categories[] = null;
int numberOfCategories = 0;


categoriesList = new PACategoryListDataBean ();
DataBeanManager.activate(categoriesList, request);
categories = categoriesList.getPACategoryDataList ();
if ( categories != null ) {
	numberOfCategories = categories.length;
}

%>

<HTML>
<HEAD>
<%= fHeader%>
<TITLE><%= productAdvisorRB.get(PAGuiConstants.MSG_CATEGORY_LIST_TITLE) %></TITLE>

<SCRIPT LANGUAGE="JavaScript">
<!-- hide script from old browsers -->

function isButtonDisabled(b) {
    if (b.className =='disabled' &&	b.id == 'disabled')
	return true;
    return false;
}

// code for disbling the button
function disableButton(b) {
	if (defined(b)) {
		b.disabled=false;
		b.className='disabled';
		b.id='disabled';
	}
}


//my refresh buttons
function myRefreshButtons(){
	parent.refreshButtons();
	var checked = parent.getChecked().toString();
	var params = checked.split(';');
	var isPE = params[1];
	var isPC = params[2];
	var isSS = params[4];
	if(isSS == "false")
	{
		disableButton(parent.buttons.buttonForm.paListRemoveExploreButtonButton);
		disableButton(parent.buttons.buttonForm.paListChangeExploreButtonButton);
		disableButton(parent.buttons.buttonForm.paListNewExploreButtonButton);
		disableButton(parent.buttons.buttonForm.paListRemoveCompareButtonButton);
		disableButton(parent.buttons.buttonForm.paListChangeCompareButtonButton);
		disableButton(parent.buttons.buttonForm.paListNewCompareButtonButton);
		disableButton(parent.buttons.buttonForm.paListMetaphorSummaryButtonButton);
	}
	if(isPE == "false"){
		disableButton(parent.buttons.buttonForm.paListRemoveExploreButtonButton);
		disableButton(parent.buttons.buttonForm.paListChangeExploreButtonButton);
	}
	else{
		disableButton(parent.buttons.buttonForm.paListNewExploreButtonButton);
	}
	if(isPC == "false"){
		disableButton(parent.buttons.buttonForm.paListRemoveCompareButtonButton);
		disableButton(parent.buttons.buttonForm.paListChangeCompareButtonButton);
	}
	else{
		disableButton(parent.buttons.buttonForm.paListNewCompareButtonButton);
	}
	if(isPE == "false" && isPC == "false"){
		disableButton(parent.buttons.buttonForm.paListMetaphorSummaryButtonButton);
	}
}


function forwardToCreateSS()
{
    var url = "/webapp/wcs/tools/servlet/DialogView?XMLFile=productAdvisor.CreateSearchSpace"+"&storeId="+"<%= categoriesList.getStoreId().toString() %>"+"&languageId="+"<%=categoriesList.getLanguageId().toString()%>";

    if (top.setContent)     {
      top.setContent("<%= UIUtil.toJavaScript( (String)productAdvisorRB.get(PAGuiConstants.MSG_SEARCH_SPACE )) %>", url, true);
    }    else     {
	parent.location.replace(url);
    }

}


function refreshPage() {
	var checkLength = document.categoryListForm.elements.length;
	for (var i=0; i<checkLength; i++) {
	    var e = document.categoryListForm.elements[i];
	    if (e.type == 'checkbox') {
     		if (e.name != 'select_deselect' && e.checked) {
			document.categoryListForm.elements[i].click();
     		}
    	   }
	}
	parent.basefrm.location.replace('/webapp/wcs/tools/servlet/PACategoryListView?orderby=name');
}


function forwardToPE()
{
var data = -1;
if (arguments.length > 0){
    data = arguments[0];
}  else   {
    var checked = parent.getChecked();
    if (checked.length > 0) {
      data = checked[0];
    }
}
var params = data.split(';');
var categoryId = params[0];
var peFeatureExists = params[1];
var catName = params[3];	
top.put("categoryName",catName);
var catalogId = params[5];
if(catalogId != 'NULL'){
	top.put("catalogId",catalogId);
}

if (categoryId != -1 || categoryId != "")
{
    var url = "/webapp/wcs/tools/servlet/DialogView?XMLFile=productAdvisor.ProductExplorerDialog" + "&<%= ECConstants.EC_CATEGORY_ID %>=" + categoryId + "&fromPACat=1"+"&featureExists="+peFeatureExists+"&storeId="+"<%= categoriesList.getStoreId().toString() %>"+"&languageId="+"<%=categoriesList.getLanguageId().toString()%>";

    if (top.setContent)     {
      top.setContent(catName + " - <%= UIUtil.toJavaScript( (String)productAdvisorRB.get(PAGuiConstants.MSG_PRODUCT_EXPLORER )) %>", url, true);
    }    else     {
	parent.location.replace(url);
    }
}
}

function forwardToPC()
{
var data = -1;
if (arguments.length > 0){
    data = arguments[0];
}  else   {
    var checked = parent.getChecked();
    if (checked.length > 0) {
      data = checked[0];
    }
}
var params = data.split(';');
var categoryId = params[0];
var pcFeatureExists = params[2];
var catName = params[3];	
top.put("categoryName",catName);
var catalogId = params[5];
if(catalogId != 'NULL'){
	top.put("catalogId",catalogId);
}

if (categoryId != -1 || categoryId != "")
{
	var url = "/webapp/wcs/tools/servlet/DialogView?XMLFile=productAdvisor.ProductComparerDialog" + "&<%= ECConstants.EC_CATEGORY_ID %>=" + categoryId + "&fromPACat=1"+"&featureExists="+pcFeatureExists+"&storeId="+"<%= categoriesList.getStoreId().toString() %>"+"&languageId="+"<%=categoriesList.getLanguageId().toString()%>";
    if (top.setContent)     {
      top.setContent(catName + " - <%= UIUtil.toJavaScript( (String)productAdvisorRB.get(PAGuiConstants.MSG_PRODUCT_COMPARER )) %>", url, true);
    }    else     {
	parent.location.replace(url);
    }
}
}

function newPEMetaphor()
{
	if(isButtonDisabled(parent.buttons.buttonForm.paListNewExploreButtonButton)){
		return;
	}

forwardToPE();
}

function changePEMetaphor()
{
	if(isButtonDisabled(parent.buttons.buttonForm.paListChangeExploreButtonButton)){
		return;
	}

forwardToPE();
}


function newPCMetaphor()
{
	if(isButtonDisabled(parent.buttons.buttonForm.paListNewCompareButtonButton)){
		return;
	}

forwardToPC();
}

function changePCMetaphor()
{
	if(isButtonDisabled(parent.buttons.buttonForm.paListChangeCompareButtonButton)){
		return;
	}

forwardToPC();
}



function metaphorSummary()
{
	if(isButtonDisabled(parent.buttons.buttonForm.paListMetaphorSummaryButtonButton)){
		return;
	}

	var checked = parent.getChecked().toString();
	var params = checked.split(';');
	var categoryId = params[0];
	var catName = params[3];
	var catalogId = params[5];
	if(catalogId != 'NULL'){
		top.put("catalogId",catalogId);
	}
	top.put("categoryName",catName);
	var url = "/webapp/wcs/tools/servlet/DialogView?XMLFile=productAdvisor.PASummaryDialog&categoryId="+categoryId;
	if(top.setContent){
		top.setContent(catName+" - <%= UIUtil.toJavaScript((String)productAdvisorRB.get(PAGuiConstants.MSG_PA_SUMMARY))%>",url,true);
	} else {
		parent.location.replace(url);
	}
}


//delete metaphor
function deletePEMetaphor()
{
	if(isButtonDisabled(parent.buttons.buttonForm.paListRemoveExploreButtonButton)){
		return;
	}

	var selected = confirmDialog("<%= getNLString(productAdvisorRB,PAGuiConstants.MSG_DELETE_METAPHOR_CONFIRMATION)%>");
	if(selected){
		var checked = parent.getChecked().toString();
		var params = checked.split(';');
		var categoryId = params[0];
		var p = new Object();
		p['categoryId']=categoryId;
		p['deletePE']="true";
		p['deletePC']="false";
		top.showContent('/webapp/wcs/tools/servlet/MetaphorDeleteCmd',p);
	}
}


function deletePCMetaphor()
{
	if(isButtonDisabled(parent.buttons.buttonForm.paListRemoveCompareButtonButton)){
		return;
	}

	var selected = confirmDialog("<%= getNLString(productAdvisorRB,PAGuiConstants.MSG_DELETE_METAPHOR_CONFIRMATION)%>");
	if(selected){
		var checked = parent.getChecked().toString();
		var params = checked.split(';');
		var categoryId = params[0];
		var p = new Object();
		p['categoryId']=categoryId;
		p['deletePE']="false";
		p['deletePC']="true";
		top.showContent('/webapp/wcs/tools/servlet/MetaphorDeleteCmd',p);
	}
}


function onLoad()
{
  parent.loadFrames();
if (parent.setContentFrameLoaded) {
	parent.setContentFrameLoaded(true);
}
if (parent.parent.setContentFrameLoaded) {
	parent.parent.setContentFrameLoaded(true);
}
}

// -->
</script>
<SCRIPT LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/dynamiclist.js"></SCRIPT>

</HEAD>

<BODY ONLOAD="onLoad()" class="content">

<%
	String orderByParm = (String)request.getParameter("orderby");
	int rowselect = 1;
%>

<FORM NAME="categoryListForm">


<%= comm.startDlistTable((String)productAdvisorRB.get(PAGuiConstants.CATEGORY_LIST_SUMMARY)) %>
<%= comm.startDlistRowHeading() %>
<%= comm.addDlistCheckHeading(true,"parent.selectDeselectAll();myRefreshButtons()") %>
<%= comm.addDlistColumnHeading((String)productAdvisorRB.get(PAGuiConstants.CATEGORY_LIST_CATEGORY_COLUMN_NAME), PAGuiConstants.ORDER_BY_NAME, PAGuiConstants.ORDER_BY_NAME.equals(orderByParm)) %>
<%= comm.addDlistColumnHeading((String)productAdvisorRB.get(PAGuiConstants.CATEGORY_LIST_DESC_COLUMN_NAME), PAGuiConstants.ORDER_BY_DESCRIPTION, PAGuiConstants.ORDER_BY_DESCRIPTION.equals(orderByParm)) %>
<%= comm.addDlistColumnHeading((String)productAdvisorRB.get(PAGuiConstants.CATEGORY_LIST_SS_CREATE_STATUS_COLUMN_NAME),PAGuiConstants.ORDER_BY_SS_CREATION_STATUS, PAGuiConstants.ORDER_BY_SS_CREATION_STATUS.equals(orderByParm)) %>
<%= comm.addDlistColumnHeading((String)productAdvisorRB.get(PAGuiConstants.CATEGORY_LIST_PE_COLUMN_NAME), PAGuiConstants.ORDER_BY_PE, PAGuiConstants.ORDER_BY_PE.equals(orderByParm)) %>
<%= comm.addDlistColumnHeading((String)productAdvisorRB.get(PAGuiConstants.CATEGORY_LIST_PC_COLUMN_NAME), PAGuiConstants.ORDER_BY_PC, PAGuiConstants.ORDER_BY_PC.equals(orderByParm)) %>
<%= comm.endDlistRow() %>
<%

  PACategoryDataContainer category;
  String SSCreateStatus = null;
  String ssCreated = "true";
	for (int i=0; i<numberOfCategories; i++) {
		category = categories[i];
%>
<%= comm.startDlistRow(rowselect) %>
<%= comm.addDlistCheck(category.getCategoryId().toString()+";"+category.getPEDefinedAsString()+";"+category.getPCDefinedAsString()+";"+category.getCategoryName()+";"+category.isSSCreateSuccess()+";"+category.getCatalogId(),"parent.setChecked();myRefreshButtons()") %>
<%= comm.addDlistColumn(UIUtil.toHTML(category.getCategoryName()), "none") %>
<%= comm.addDlistColumn(UIUtil.toHTML(category.getShortDescription()), "none") %>
<%= comm.addDlistColumn(UIUtil.toHTML((String)productAdvisorRB.get(category.getSSCreateStatus())), "none") %>
<%= comm.addDlistColumn(UIUtil.toHTML(category.isPEDefined() ? (String)productAdvisorRB.get(PAGuiConstants.METAPHOR_EXISTS):(String)productAdvisorRB.get(PAGuiConstants.METAPHOR_DOESNOT_EXISTS)), "none") %>
<%= comm.addDlistColumn(UIUtil.toHTML(category.isPCDefined() ? (String)productAdvisorRB.get(PAGuiConstants.METAPHOR_EXISTS):(String)productAdvisorRB.get(PAGuiConstants.METAPHOR_DOESNOT_EXISTS)), "none") %>
<%= comm.endDlistRow() %>
<%
		if (rowselect == 1) {
			rowselect = 2;
		}
		else {
			rowselect = 1;
		}
	}
%>
<%= comm.endDlistTable() %>

<% 
if (numberOfCategories == 0)   {
%>
<P><P>
<%= productAdvisorRB.get(PAGuiConstants.CATEGORY_LIST_EMPTY) %>
<%
  }
%>
</FORM>

<script>
<!--
parent.afterLoads();
if(parent.buttons.buttonForm != null)
{
parent.selectDeselectAll();
}
//-->
</script>

</BODY>
</HTML>