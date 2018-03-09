<!-- 
  //*----
  //* @deprecated The Product Advisor feature has been deprecated. For more information, see <a href="../../../../../../com.ibm.commerce.productadvisor.doc/concepts/cpaintro.htm">Product Advisor</a>.
  //*----
-->

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2002, 2013 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%@page language="java" %>
<%@ page import="java.util.Vector" %>
<%@ page import="com.ibm.commerce.beans.DataBeanManager" %>
<%@ page import="com.ibm.commerce.tools.util.ResourceDirectory" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.pa.tools.metaphor.containers.PAGuiConstants" %>
<%@ page import="com.ibm.commerce.utils.TimestampHelper" %>
<%@ page import="com.ibm.commerce.pa.tools.metaphor.containers.MetaphorFeatureDataContainer" %>
<%@ page import="com.ibm.commerce.pa.tools.metaphor.beans.MetaphorFeatureListDataBean" %>
<%@ page import="com.ibm.commerce.pa.tools.metaphor.beans.DefaultFeatureListDataBean" %>
<%@ page import="com.ibm.commerce.tools.common.ui.taglibs.*" %>
 

<%@include file="pacommon.jsp" %>

<%
String fromPACat = (String)request.getParameter("fromPACat");
String categoryId = (String)request.getParameter("categoryId");
String featureExists = (String)request.getParameter("featureExists");
String storeId = (String)request.getParameter("storeId");
String languageId = (String)request.getParameter("languageId");

Vector prodLinkVect = new Vector();
prodLinkVect.addElement((String)productAdvisorRB.get(PAGuiConstants.PC_LIST_PRODLINK_YES ));
prodLinkVect.addElement((String)productAdvisorRB.get(PAGuiConstants.PC_LIST_PRODLINK_NO ));

Vector sortVect = new Vector();
sortVect.addElement((String)productAdvisorRB.get(PAGuiConstants.ASCENDING_ORDER ));
sortVect.addElement((String)productAdvisorRB.get(PAGuiConstants.DESCENDING_ORDER ));


MetaphorFeatureDataContainer pcFeatures[] = null;
int numberOfFeatures = 0;
String metaphorId="-1";

if(fromPACat.equals("1")){
    if(featureExists.equals("true")) {
	    MetaphorFeatureListDataBean pcFeatureList = new MetaphorFeatureListDataBean();
	    pcFeatureList.setViewName("ProductComparerListView");
	    DataBeanManager.activate(pcFeatureList, request);
	    pcFeatures = pcFeatureList.getPCFeatureDataBeanArray();
	    metaphorId = pcFeatureList.getPCMetaphorId().toString();
    } else {
	    DefaultFeatureListDataBean pcFeatureList = new DefaultFeatureListDataBean();
	    pcFeatureList.setViewName("ProductComparerListView");
	    DataBeanManager.activate(pcFeatureList, request);
	    pcFeatures = pcFeatureList.getPCFeatureDataBeanArray();
	    metaphorId = pcFeatureList.getPCMetaphorId().toString();
    }
    if (pcFeatures != null)
     {
      numberOfFeatures = pcFeatures.length;
     }
}
%>
<HTML>
<%=fHeader%>
<HEAD>
	<TITLE><%= productAdvisorRB.get(PAGuiConstants.PC_LIST_TITLE) %></TITLE>

<SCRIPT LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/Util.js">	</SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/Vector.js">	</SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/dynamiclist.js">	</SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/ConvertToXML.js">	</SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/productadvisor/paCommon.js">	</SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/productadvisor/pcFeatureList.js">	</SCRIPT>

<SCRIPT LANGUAGE="JavaScript">

top.mccmain.mcccontent.isInsideWizard = function() {
       return true;
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


function getUserNLSTitle()
{
var title = top.get("categoryName","")+ " - <%= getNLString(productAdvisorRB,PAGuiConstants.PC_LIST_TITLE) %>";
title += "<BR><I><%= getNLString(productAdvisorRB,PAGuiConstants.PC_INSTRUCTIONAL_TEXT)%></I>";
return title;
}

function getLinkNo()
{
	return "<%= getNLString(productAdvisorRB,PAGuiConstants.PC_LIST_PRODLINK_NO) %>";
}

function getLinkYes()
{
	return "<%= getNLString(productAdvisorRB,PAGuiConstants.PC_LIST_PRODLINK_YES) %>";
}

function getAscText()
{
	return "<%= getNLString(productAdvisorRB,PAGuiConstants.ASCENDING_ORDER) %>";
}

function getDescText()
{
	return "<%= getNLString(productAdvisorRB,PAGuiConstants.DESCENDING_ORDER) %>";
}

function addFeature()
{
      var url = "/webapp/wcs/tools/servlet/DialogView?XMLFile=productAdvisor.AddFeaturesDialog&categoryId=<%=UIUtil.toJavaScript(categoryId)%>&fromMetaphor=PC&storeId=<%=UIUtil.toJavaScript( storeId )%>&languageId=<%=UIUtil.toJavaScript( languageId )%>";
      if (top.setContent)
      {
        top.setContent("<%= getNLString( productAdvisorRB,PAGuiConstants.MSG_ADD_FEATURES ) %>",url,true);
      }
      else
      {
        parent.location.replace(url);
      }
}


function removeFeature()
{
	var checked = parent.getChecked();
	if (checked.length > 0)
	{
		if(confirmDialog("<%= getNLString(productAdvisorRB,PAGuiConstants.MSG_REMOVE_FEATURE_CONFIRMATION) %>"))
		{
			createRemoveVector();
			refreshTable();
		}
	}
}


function concurrentConfirmMsg()
{
	return confirmDialog("<%= getNLString(productAdvisorRB,PAGuiConstants.MSG_CONCURRENT_CONFIRM)%>");
}


function cancelConfirmMsg()
{
	return confirmDialog("<%= getNLString(productAdvisorRB,PAGuiConstants.MSG_CANCEL_CONFIRM)%>");
}


function validatePanelData()
{
	var vect = top.get("vectorDataRemove");
	var featExists = top.get("featExists");
	var createMetaphors = "true";
	if(size(vect) == 0)
	{
		createMetaphors = "false";
	}
	var selected = true;

	if( !(featExists == "true") && (createMetaphors=="false") )
	{
		selected = alertDialog("<%= getNLString(productAdvisorRB,PAGuiConstants.MSG_METAPHOR_NOT_DEFINED) %>");
		return false;
	}
	else if( featExists=="true" && createMetaphors=="false" )
	{
	      selected = confirmDialog("<%= getNLString(productAdvisorRB,PAGuiConstants.MSG_METAPHOR_DELETE) %>");
	}
	return selected;
}

function savePanelData()
{
	var vect = top.get("vectorDataRemove");
	var featExists = top.get("featExists");
	var createMetaphors = "true";
	if(size(vect) == 0)
	{
		createMetaphors = "false";
	}
	var xml = generateXML(vect,"pa",null);
	xml = xml + "<categoryId><%=UIUtil.toJavaScript(categoryId)%></categoryId>\n";
	xml = xml + "<fromPE>false</fromPE>\n";
	xml = xml + "<fromPC>true</fromPC>\n";
	xml = xml + "<metaphorId>"+top.get("metaphorId")+"</metaphorId>\n";
	xml = xml + "<createMetaphors>"+ createMetaphors +"</createMetaphors>";
	xml = "<PAData>\n"+xml+"</PAData>\n";
	parent.parent.put("EC_XMLFileObject", xml);	
}


function preview(){
	var storeId = "<%=UIUtil.toJavaScript( storeId)%>";
	var categoryId = "<%=UIUtil.toJavaScript( categoryId )%>";
	var languageId = "<%=UIUtil.toJavaScript( languageId )%>";
	var fix = "storeId="+storeId+"&categoryId="+categoryId+"&langId="+languageId;
	var catalogId = top.get("catalogId",null);
	if(catalogId != null){
		fix = fix + "&catalogId="+catalogId;
	}

//	var url = "PCPreviewView?";
//	url = url+fix;
//	var date= new Date();
//	var time = date.getTime();
//	var title = "PC" + time;
//  window.open(url, title, "resizable=yes,scrollbars=yes,status=no,width=800,height=600");

//changed for defect 48051 - Preview fix start
	var date= new Date();
	var time = date.getTime();
	var title ="PC" + time;
	var hostname = window.location.hostname;
	var url = "http://"+hostname+"/webapp/wcs/stores/servlet/pc51.jsp?";
	url = url+fix;
	var changed = promptDialog("<%=getNLString(productAdvisorRB,PAGuiConstants.MSG_PREVIEW_TEXT)%>",url);
	if(changed != null && rtrim(ltrim(changed)).length != 0 )
	{
	   	window.open(changed,title, "resizable=yes,scrollbars=yes,status=no,width=800,height=600");
	}
//changed for defect 48051 - Preview fix end

}


</script>

<%
if(fromPACat.equals("1")){
%>
<script language="javascript">

	var vectorAdd = new Vector();
	var vectorRemove = new Vector();

<%
	MetaphorFeatureDataContainer pcFeature1;
	for(int i=0;i<numberOfFeatures;i++){
		pcFeature1 = pcFeatures[i];
%>
	var object = new Object();
	object.name = "<%=UIUtil.toJavaScript(pcFeature1.getFeatureName())%>";
	object.columnName = "<%=UIUtil.toJavaScript(pcFeature1.getFeatureColumnName())%>";
	object.displayColumnName = "<%=UIUtil.toJavaScript(pcFeature1.getFeatureDisplayColumnName())%>";
	object.sequence = "<%=pcFeature1.getOrderSequence()+""%>";
	object.sortOrder = "<%=pcFeature1.getSortOrder()+""%>";
	object.display = "<%=!pcFeature1.isPCDisplayable() ? "0":(pcFeature1.isProductLink() ? "2":"1")%>";
	object.description = "<%=UIUtil.toJavaScript(pcFeature1.getDescription())%>";
<%
		if(pcFeature1.isPCDisplayable()) {
%>
			addElement(object,vectorRemove);
<%
		} else {
%>
			addElement(object,vectorAdd);
<%
		}//if else ends
	}//for ends
%>

	
	top.put("vectorDataAdd",vectorAdd);
	top.put("vectorDataRemove",vectorRemove);

	var featExists = "<%=UIUtil.toJavaScript(featureExists)%>";
	top.put("featExists",featExists);

	top.put("metaphorId","<%=metaphorId%>");

</script>

<%
}//if ends
%>

<script language="javascript">
	
	var rowselect = 1;
	var removeVector = top.get("vectorDataRemove");
	var numOfFeatures = size(removeVector);

	<%= UIUtil.toJS("sortarray",sortVect)%>;	
	<%= UIUtil.toJS("prodLinkList",prodLinkVect)%>;
	top.put("sortarrayData",sortarray);
	top.put("prodLinkListData",prodLinkList);
	
</Script>

</HEAD>
<BODY ONLOAD="onLoad()" class="content">

<FONT size="2"><B><%= productAdvisorRB.get(PAGuiConstants.MSG_FEATURES)%></B></FONT>

<FORM NAME="pcForm">
<%= comm.startDlistTable("pcFeatureListSummaryID") %>
<%= comm.startDlistRowHeading() %>
<%= comm.addDlistCheckHeading(true,"parent.selectDeselectAll();myRefreshButtons()") %>
<%= comm.addDlistColumnHeading((String)productAdvisorRB.get(PAGuiConstants.PC_LIST_SEQUENCE_COLUMN_NAME),"", false) %>
<%= comm.addDlistColumnHeading((String)productAdvisorRB.get(PAGuiConstants.PC_LIST_FEATURECODE_COLUMN_NAME), "", false) %>
<%= comm.addDlistColumnHeading((String)productAdvisorRB.get(PAGuiConstants.FEATUREDESCRIPTION_COLUMN_NAME), "", false) %>
<%= comm.addDlistColumnHeading((String)productAdvisorRB.get(PAGuiConstants.PC_LIST_FEATURELIST_COLUMN_NAME), "", false) %>
<%= comm.addDlistColumnHeading((String)productAdvisorRB.get(PAGuiConstants.PC_LIST_FEATUREORDER_COLUMN_NAME), "", false) %>
<%= comm.endDlistRow() %>

<script language="javascript">
		var sortOrder;
		var isLink;
		for(var i = 0;i<size(removeVector);i++) {
		var object =  new Object();
		object = elementAt(i,removeVector);
		startDlistRow(rowselect);
		addDlistCheck(i,"parent.setChecked();myRefreshButtons()");
		addDlistColumn(object.sequence, "none");
		addDlistColumn(object.displayColumnName, "none");
		addDlistColumn(object.description, "none");
		if(object.display == '1')
		{
		isLink = "<%=getNLString(productAdvisorRB,PAGuiConstants.PC_LIST_PRODLINK_NO )%>";
		}
		else
		{
		isLink = "<%=getNLString(productAdvisorRB,PAGuiConstants.PC_LIST_PRODLINK_YES )%>";
		}
		addDlistDropDown(object.name,"updateLinkToPage(selectedIndex,"+i+")",prodLinkList,isLink);
		if(object.sortOrder == 'true')
		{
		sortOrder = "<%=getNLString(productAdvisorRB,PAGuiConstants.ASCENDING_ORDER )%>";
		}
		else
		{
		sortOrder = "<%=getNLString(productAdvisorRB,PAGuiConstants.DESCENDING_ORDER )%>";
		}
		addDlistDropDown(object.name,"updateSortOrderType(selectedIndex,"+i+")",sortarray,sortOrder);
		endDlistRow();
		if(rowselect == 1){
			rowselect = 2;
		} else {
			rowselect = 1;
		}
	}
</script>

<%= comm.endDlistTable() %>

<script language="javascript">

	 if (size(removeVector) == 0)
	   {
		document.writeln("<P><%= getNLString(productAdvisorRB,PAGuiConstants.MSG_COMPARE_FEATURE_LIST_EMPTY) %>");
       }

</script>
</FORM>
<script language="javascript">
	parent.afterLoads();
</script>

</BODY>
</HTML>
