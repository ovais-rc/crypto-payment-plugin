<!--==========================================================================
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
  ===========================================================================-->

<!-- 
  //*----
  //* @deprecated The Product Advisor feature has been deprecated. For more information, see <a href="../../../../../../com.ibm.commerce.productadvisor.doc/concepts/cpaintro.htm">Product Advisor</a>.
  //*----
-->

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
<%@page language="java" 
import="com.ibm.commerce.pa.tools.metaphor.containers.PAGuiConstants,
	  com.ibm.commerce.tools.util.ResourceDirectory,
	  com.ibm.commerce.beans.DataBeanManager,
	  com.ibm.commerce.tools.util.*,
	  com.ibm.commerce.tools.common.ui.taglibs.*,
	  com.ibm.commerce.pa.tools.metaphor.beans.PASummaryDataBean,
	  com.ibm.commerce.pa.tools.metaphor.containers.PASummaryDataContainer,
	  java.util.Vector" %>

<%@include file="pacommon.jsp" %>

<%
	PASummaryDataBean pasdb = new PASummaryDataBean();
	DataBeanManager.activate(pasdb,request);
	Vector pasdv = pasdb.getSummary();
%>

<HTML>
<HEAD>
 <%= fHeader %>
<TITLE><%=productAdvisorRB.get(PAGuiConstants.SUMMARY_LIST_TITLE)%></TITLE>
<SCRIPT LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/Util.js"></script>
<SCRIPT LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/dynamiclist.js"></script>
<SCRIPT LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/productadvisor/paCommon.js">	</SCRIPT>
<script language="javascript">
function loadPanelData()
{
parent.setContentFrameLoaded(true);
}

function savePanelData()
{
}

function validatePanelData()
{
return true;
}

function isPCMetaphorAvailable(){
	var available = "<%=pasdb.isPCMetaphorAvailable()%>";
	if(available == "false"){
		alertDialog("<%=getNLString(productAdvisorRB,PAGuiConstants.MSG_PCMETAPHOR_NOT_AVAILABLE)%>");
		return false;
	}
	return true;
}

function isPEMetaphorAvailable(){
	var available = "<%=pasdb.isPEMetaphorAvailable()%>";
	if(available == "false"){
		alertDialog("<%=getNLString(productAdvisorRB,PAGuiConstants.MSG_PEMETAPHOR_NOT_AVAILABLE)%>");
		return false;
	}
	return true;
}
function getURLFix(){
	var storeId = <%=pasdb.getStoreId().toString()%>;
	var categoryId = <%=pasdb.getCategoryId()%>;
	var languageId = <%=pasdb.getLanguageId().toString()%>;
	var fix = "storeId="+storeId+"&categoryId="+categoryId+"&langId="+languageId;	
	var catalogId = top.get("catalogId",null);
	if(catalogId != null){
		fix = fix + "&catalogId="+catalogId;
	}
	return fix;
}

//Added function for defect 48051 - Preview fix
function prompt(url){
	var changed = promptDialog("<%=getNLString(productAdvisorRB,PAGuiConstants.MSG_PREVIEW_TEXT)%>",url);
	if(changed != null)
	{
		return rtrim(ltrim(changed));
	}
	else
	{
		return changed;
	}	
}	

</SCRIPT>
</HEAD>
<BODY ONLOAD="loadPanelData();" class="content">

<SPAN style="color: #565665; height: 30px; font-size: 16pt; font-family : Verdana,Arial,Helvetica; "><script>document.write(top.get("categoryName",""))</script> - <%=UIUtil.toHTML((String)productAdvisorRB.get(PAGuiConstants.SUMMARY_LIST_TITLE))%></SPAN><p>

<%= comm.startDlistTable((String)productAdvisorRB.get(PAGuiConstants.SUMMARY_LIST_TITLE)) %>
<%= comm.startDlistRowHeading() %>
<%= comm.addDlistColumnHeading((String)productAdvisorRB.get(PAGuiConstants.SUMMARY_FEATURECODE_COLUMN_NAME), "", true) %>
<%= comm.addDlistColumnHeading((String)productAdvisorRB.get(PAGuiConstants.FEATUREDESCRIPTION_COLUMN_NAME), "", false) %>
<%= comm.addDlistColumnHeading((String)productAdvisorRB.get(PAGuiConstants.SUMMARY_PE_COLUMN_NAME), "", false) %>
<%= comm.addDlistColumnHeading((String)productAdvisorRB.get(PAGuiConstants.SUMMARY_PC_COLUMN_NAME), "", false) %>
<%= comm.endDlistRow() %>
<%
	int rowselect = 1;
	PASummaryDataContainer data;
	for (int i=0; i<pasdv.size(); i++) {
		data = (PASummaryDataContainer)pasdv.elementAt(i);
%>
<%= comm.startDlistRow(rowselect) %>
<%= comm.addDlistColumn(UIUtil.toHTML(data.getFeatureDisplayColumnName()), "none") %>
<%= comm.addDlistColumn(UIUtil.toHTML(data.getFeatureDescription()), "none") %>
<%= comm.addDlistColumn(UIUtil.toHTML((String)productAdvisorRB.get(data.getHasProductExploration())), "none") %>
<%= comm.addDlistColumn(UIUtil.toHTML((String)productAdvisorRB.get(data.getHasProductComparision())), "none") %>
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
	if (pasdv.size() == 0)   {
%>
<P><P>
	<%= UIUtil.toHTML((String)productAdvisorRB.get(PAGuiConstants.SUMMARY_NO_METAPHORS_CREATED)) %>
<%
	}
%>
</BODY>
</HTML>
