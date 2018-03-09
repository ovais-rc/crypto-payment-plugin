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
<%@ page import="com.ibm.commerce.beans.DataBeanManager" %>
<%@ page import="com.ibm.commerce.tools.util.ResourceDirectory" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.pa.tools.metaphor.containers.PAGuiConstants" %>
<%@ page import="com.ibm.commerce.utils.TimestampHelper" %>
<%@ page import="com.ibm.commerce.pa.tools.metaphor.containers.MetaphorFeatureDataContainer" %>
<%@ page import="com.ibm.commerce.pa.tools.metaphor.beans.MetaphorFeatureListDataBean" %>
<%@ page import="com.ibm.commerce.pa.tools.metaphor.beans.WidgetListDataBean" %>
<%@ page import="com.ibm.commerce.pa.tools.metaphor.beans.DefaultFeatureListDataBean" %>
<%@ page import="com.ibm.commerce.tools.common.ui.taglibs.*" %>
 

<%@include file="pacommon.jsp" %>

<%
String fromPACat = (String)request.getParameter("fromPACat");
String categoryId = (String)request.getParameter("categoryId");
String featureExists = (String)request.getParameter("featureExists");
String storeId = (String)request.getParameter("storeId");
String languageId = (String)request.getParameter("languageId");

Vector sortVect = new Vector();
sortVect.addElement((String)productAdvisorRB.get(PAGuiConstants.ASCENDING_ORDER ));
sortVect.addElement((String)productAdvisorRB.get(PAGuiConstants.DESCENDING_ORDER ));

MetaphorFeatureDataContainer peFeatures[] = null;

WidgetListDataBean widgetList = null;
String widgetCNList[] = null;
String widgetDNList[] = null;
int numberOfFeatures = 0;
String metaphorId="-1";

if(fromPACat.equals("1")){

    widgetList = new WidgetListDataBean();	
    DataBeanManager.activate(widgetList, request);
    widgetCNList = widgetList.getWidgetClassNameList();
    widgetDNList = widgetList.getWidgetDisplayNameList();
    if(featureExists.equals("true")) {
	    MetaphorFeatureListDataBean peFeatureList = new MetaphorFeatureListDataBean();
	    peFeatureList.setViewName("ProductExplorerListView");
	    DataBeanManager.activate(peFeatureList, request);
	    peFeatures = peFeatureList.getPEFeatureDataBeanArray();
	    metaphorId = peFeatureList.getPEMetaphorId().toString();
    } else {
	    DefaultFeatureListDataBean peFeatureList = new DefaultFeatureListDataBean();
	    peFeatureList.setViewName("ProductExplorerListView");
	    DataBeanManager.activate(peFeatureList, request);
	    peFeatures = peFeatureList.getPEFeatureDataBeanArray();
	    metaphorId = peFeatureList.getPEMetaphorId().toString();
    }		
    if (peFeatures != null)
     {
      numberOfFeatures = peFeatures.length;
     }
}
%>
<HTML>
<%=fHeader%>
<HEAD>
	<TITLE><%= productAdvisorRB.get(PAGuiConstants.PE_LIST_TITLE) %></TITLE>

<SCRIPT LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/Util.js">	</SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/Vector.js">	</SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/dynamiclist.js">	</SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/ConvertToXML.js">	</SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/productadvisor/paCommon.js">	</SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/productadvisor/peFeatureList.js">	</SCRIPT>


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
var title = top.get("categoryName","")+ " - <%= getNLString(productAdvisorRB,PAGuiConstants.PE_LIST_TITLE) %>";
title += "<BR><I><%= getNLString(productAdvisorRB,PAGuiConstants.PE_INSTRUCTIONAL_TEXT) %></I>";
return title;

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
      var url = "/webapp/wcs/tools/servlet/DialogView?XMLFile=productAdvisor.AddFeaturesDialog&categoryId=<%=UIUtil.toJavaScript(categoryId)%>&fromMetaphor=PE&storeId=<%=UIUtil.toJavaScript( storeId )%>&languageId=<%=UIUtil.toJavaScript( languageId )%>";
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
		alertDialog("<%= getNLString(productAdvisorRB,PAGuiConstants.MSG_METAPHOR_NOT_DEFINED) %>");
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
	xml = xml + "<fromPE>true</fromPE>\n";
	xml = xml + "<fromPC>false</fromPC>\n";
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

//	var url = "PEPreviewView?";
//	url = url+fix;
//	var date= new Date();
//	var time = date.getTime();
//	var title ="PE" + time;
//      window.open(url,title, "resizable=yes,scrollbars=yes,status=no,width=800,height=600");

//changed for defect 48051 - Preview fix start
	var date= new Date();
	var time = date.getTime();
	var title ="PE" + time;
	var hostname = window.location.hostname;
	var url = "http://"+hostname+"/webapp/wcs/stores/servlet/pe51.jsp?";
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
	var widgetClassNameList1 = new Array();
	var widgetDisplayNameList1 = new Array();


<%
	MetaphorFeatureDataContainer peFeature1;
	for(int i=0;i<numberOfFeatures;i++){
		peFeature1 = peFeatures[i];
%>
	var object = new Object();
	object.name = "<%=UIUtil.toJavaScript(peFeature1.getFeatureName())%>";
	object.columnName = "<%=UIUtil.toJavaScript(peFeature1.getFeatureColumnName())%>";
	object.displayColumnName = "<%=UIUtil.toJavaScript(peFeature1.getFeatureDisplayColumnName())%>";
	object.sequence = "<%=peFeature1.getOrderSequence()+""%>";
	object.sortOrder = "<%=peFeature1.getSortOrder()+""%>";
	object.widget = "<%=getNLString(productAdvisorRB,peFeature1.getWidgetClassName())%>";
	object.widgetClassName = "<%=peFeature1.getWidgetClassName()%>";
	object.display = "<%=peFeature1.isPEDisplayable() ? "1":"0" %>";
	object.description = "<%=UIUtil.toJavaScript(peFeature1.getDescription())%>";
<%
		if(peFeature1.isPEDisplayable()) {
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

//widget array starting
<%
	for(int i=0;i<widgetCNList.length;i++){
%>
		widgetClassNameList1[<%=i%>] = "<%=widgetCNList[i]%>";
		widgetDisplayNameList1[<%=i%>] = "<%=getNLString(productAdvisorRB,widgetCNList[i])%>";
<%
	}
%>

	top.put("widgetClassNameArray",widgetClassNameList1);
	top.put("widgetDisplayNameArray",widgetDisplayNameList1);
	
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
	var widgetClassNameList = top.get("widgetClassNameArray");
	var widgetDisplayNameList = top.get("widgetDisplayNameArray");
	var numOfFeatures = size(removeVector);

	//var sortarray = new Array("Ascending","Descending");
	<%= UIUtil.toJS("sortarray",sortVect)%>;	
	top.put("sortarrayData",sortarray);	
</Script>


</HEAD>
<BODY ONLOAD="onLoad()" class="content">

<FONT size="2"><B><%= productAdvisorRB.get(PAGuiConstants.MSG_FEATURES)%></B></FONT>

<FORM NAME="peForm">
<%= comm.startDlistTable("peFeatureListSummaryID") %>
<%= comm.startDlistRowHeading() %>
<%= comm.addDlistCheckHeading(true,"parent.selectDeselectAll();myRefreshButtons()") %>
<%= comm.addDlistColumnHeading((String)productAdvisorRB.get(PAGuiConstants.PE_LIST_SEQUENCE_COLUMN_NAME),"", false) %>
<%= comm.addDlistColumnHeading((String)productAdvisorRB.get(PAGuiConstants.PE_LIST_FEATURECODE_COLUMN_NAME), "", false) %>
<%= comm.addDlistColumnHeading((String)productAdvisorRB.get(PAGuiConstants.FEATUREDESCRIPTION_COLUMN_NAME), "", false) %>
<%= comm.addDlistColumnHeading((String)productAdvisorRB.get(PAGuiConstants.PE_LIST_WIDGET_COLUMN_NAME), "", false) %>
<%= comm.addDlistColumnHeading((String)productAdvisorRB.get(PAGuiConstants.PE_LIST_FEATUREORDER_COLUMN_NAME), "", false) %>
<%= comm.endDlistRow() %>

<script language="javascript">
		var sortOrder;
		for(var i = 0;i<size(removeVector);i++) {
		var object =  new Object();
		object = elementAt(i,removeVector);
		startDlistRow(rowselect);
		addDlistCheck(i,"parent.setChecked();myRefreshButtons()");
		addDlistColumn(object.sequence, "none");
		addDlistColumn(object.displayColumnName, "none");
		addDlistColumn(object.description, "none");
		addDlistWidgetDropDown(object.name,"updateWidgetType(selectedIndex,"+i+")",widgetDisplayNameList,widgetClassNameList,object.widgetClassName);
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
		document.writeln("<P><%= getNLString(productAdvisorRB,PAGuiConstants.MSG_EXPLORE_FEATURE_LIST_EMPTY) %>");
       }
</script>
</FORM>
<script language="javascript">
	parent.afterLoads();
</script>

</BODY>
</HTML>
