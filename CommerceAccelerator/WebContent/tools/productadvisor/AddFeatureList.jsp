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
<%@page language="java" 
import="com.ibm.commerce.pa.tools.metaphor.containers.PAGuiConstants,
	  com.ibm.commerce.tools.util.ResourceDirectory,
	  com.ibm.commerce.tools.util.*,
	  com.ibm.commerce.tools.common.ui.taglibs.*,
	  java.util.Hashtable" %>

<%@include file="pacommon.jsp" %>
<HTML>
<HEAD>
 <%= fHeader %>
<TITLE><%= productAdvisorRB .get(PAGuiConstants.ADD_FEATURES_LIST_TITLE) %></TITLE>
<SCRIPT LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/Util.js"></script>
<SCRIPT LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/Vector.js"></script>
<SCRIPT LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/dynamiclist.js"></script>
<SCRIPT LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/productadvisor/paCommon.js"></script>
<script language="javascript">

top.mccmain.mcccontent.isInsideWizard = function() {
       return true;
}

function loadPanelData()
{
parent.loadFrames();
if (parent.parent.setContentFrameLoaded) {
	parent.parent.setContentFrameLoaded(true);
}

}

function savePanelData()
{
}

function validatePanelData()
{
 var checked = getChecked();
 if(checked.length <= 0)
 {
  alertDialog("<%= getNLString(productAdvisorRB,PAGuiConstants.MSG_NO_FEATURE_SELECTED) %>");
  return false;
 }
 else
 {
  return true;
 }
}

var vector = top.get("vectorDataAdd",null);
vector = sortVector(vector);
var numberOfFeatures = size(vector);

function getChecked() {
  var checkeds = new Vector;
  for (var i=0; i<document.addFeatureListForm.elements.length; i++) {
    var e = document.addFeatureListForm.elements[i];
    if (e.type == 'checkbox') {
      if (e.name != 'select_deselect' && e.checked && !checkeds.contains(e.name)) {
        checkeds.addElement(e.name);
      }
      if (e.name != 'select_deselect' && !e.checked && checkeds.contains(e.name)) {
        checkeds.removeElement(e.name);
      }
    }
  }
	return checkeds.container;
}


function createRemoveVector(){
	var remV = top.get("vectorDataRemove");
	var checked = getChecked();
	var obj = new Object();

	//getting the last object
	var length = size(remV);
	var seqNumber = 0;	
	if(length != 0){
		for(var i=0;i<size(remV);i++){
			obj = elementAt(i,remV);
			var tempSeq = obj.sequence-(-0);
			if(tempSeq > seqNumber){
				seqNumber = tempSeq;
			}
		}
	}

	var objArray = new Array();
	for(var i=0;i<checked.length;i++){
		obj = elementAt(checked[i],vector);
		obj.display = "1";
		obj.sequence = ++seqNumber;
		objArray[i] = obj;
		addElement(obj,remV);
	}
	for(var i=0;i<objArray.length;i++){
		paRemoveElement(objArray[i],vector);
	}
	top.put("vectorDataAdd",vector);
	top.put("vectorDataRemove",remV);
}


function addSelectedFeaturestoList(){
	createRemoveVector();
}

</SCRIPT>

<script language="javascript">
	var from = "<%=UIUtil.toJavaScript( (String)request.getParameter("fromMetaphor"))%>";
	if( from == "PC")
	{
	top.mccbanner.trail[top.mccbanner.counter-1].location = "/webapp/wcs/tools/servlet/DialogView?XMLFile=productAdvisor.ProductComparerDialog&categoryId=<%=UIUtil.toJavaScript( (String)request.getParameter("categoryId"))%>&storeId=<%=UIUtil.toJavaScript( (String)request.getParameter("storeId"))%>&languageId=<%=UIUtil.toJavaScript( (String)request.getParameter("languageId"))%>&fromPACat=0";
	}
	else
	{
	top.mccbanner.trail[top.mccbanner.counter-1].location = "/webapp/wcs/tools/servlet/DialogView?XMLFile=productAdvisor.ProductExplorerDialog&categoryId=<%=UIUtil.toJavaScript( (String)request.getParameter("categoryId"))%>&storeId=<%=UIUtil.toJavaScript( (String)request.getParameter("storeId"))%>&languageId=<%=UIUtil.toJavaScript( (String)request.getParameter("languageId"))%>&fromPACat=0";
	}

</Script>
</HEAD>

<BODY ONLOAD="loadPanelData();" class="content">
<FORM NAME="addFeatureListForm">
<%= comm.startDlistTable((String)productAdvisorRB.get(PAGuiConstants.ADD_FEATURES_LIST_TITLE)) %>
<%= comm.startDlistRowHeading() %>
<%= comm.addDlistCheckHeading() %>
<%= comm.addDlistColumnHeading((String)productAdvisorRB.get(PAGuiConstants.ADD_FEATURES_FEATURECODE_COLUMN_NAME),"", false) %>
<%= comm.addDlistColumnHeading((String)productAdvisorRB.get(PAGuiConstants.FEATUREDESCRIPTION_COLUMN_NAME), "", false) %>
<%= comm.endDlistRow() %>

<script language="javascript">
	var rowselect = 1;
		for(var i=0;i<numberOfFeatures;i++) {
		var object =  new Object();
		object = elementAt(i,vector);
		startDlistRow(rowselect);
		addDlistCheck(i+"");
		addDlistColumn(object.displayColumnName, "none");
		addDlistColumn(object.description, "none");
		endDlistRow()
		if(rowselect == 1){
			rowselect = 2;
		} else {
			rowselect = 1;
		}
	}
</script>
<%= comm.endDlistTable() %>

<script language="javascript">

	 if (numberOfFeatures == 0)
	   {
		document.writeln("<P><%= getNLString(productAdvisorRB,PAGuiConstants.MSG_ADD_FEATURE_LIST_EMPTY) %>");
       }
</script>

</FORM>
<script language="javascript">
	parent.afterLoads();
</script>

</BODY>
</HTML>
