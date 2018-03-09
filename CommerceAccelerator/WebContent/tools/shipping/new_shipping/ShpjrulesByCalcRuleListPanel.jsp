<!-- ========================================================================
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2000, 2004
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
//*
=========================================================================== -->

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<%@page import="com.ibm.commerce.tools.shipping.*" %>
<%@page import="com.ibm.commerce.beans.DataBeanManager" %>
<%@page import="com.ibm.commerce.tools.common.ui.taglibs.*" %>
<%@page import="com.ibm.commerce.tools.util.UIUtil" %>
<%@page import="java.util.*" %>
<%@page import="javax.servlet.*" %>
	

<%@include file="ShippingCommon.jsp" %>

<%
    String readOnly = request.getParameter(ShippingConstants.PARAMETER_READONLY);
    boolean editable = true;
    if(!(readOnly == null) && !(readOnly.equals(""))&&!(readOnly.equalsIgnoreCase("false")))
    {
    	editable = false;
    }

%>

<html>

<head>
<%= fHeader %>
<title><%= shippingRB.get(ShippingConstants.MSG_SHPJRULE_LIST_TITLE) %></title>

<script language="JavaScript" src="/wcs/javascript/tools/common/Util.js"></script>
<script language="JavaScript" src="/wcs/javascript/tools/common/dynamiclist.js"></script>
<script language="JavaScript" src="/wcs/javascript/tools/shipping/ShippingUtil.js"></script>
<script language="JavaScript">
<!---- hide script from old browsers

function newShpjrule () {

   	
	savePanelData();

	var o = parent.parent.get("<%= ShippingConstants.ELEMENT_CALCRULE_DETAILS_BEAN %>", null);
	if( o != null ){
		
	}
	top.setReturningPanel("shpjruleByCalcRuleListPanel");
	

	// save the states of the tabs
	top.saveData(parent.parent.pageArray, "shpjrulePageArray");

	var url = "<%= ShippingConstants.URL_SHPJRULE_NEW_DIALOG_VIEW %>";
	
	if (top.setContent) {
		top.setContent("<%= UIUtil.toJavaScript((String)shippingRB.get(ShippingConstants.MSG_CREATE_SHPJRULE)) %>", url, true);
	}
	else {
		parent.location.replace(url);
	}


}

function changeShpjrule () {

   	
	savePanelData();
	var shpjruleId = -1;
	if (arguments.length > 0) {
		shpjruleId = arguments[0];

	}else{
	
		shpjruleId = parent.getChecked();
	}

	var o = parent.parent.get("<%= ShippingConstants.ELEMENT_CALCRULE_DETAILS_BEAN %>", null);
	if( o != null ){
		
	}
	top.setReturningPanel("shpjruleByCalcRuleListPanel");
	

	// save the states of the tabs
	top.saveData(parent.parent.pageArray, "shpjrulePageArray");

	var url = "<%= ShippingConstants.URL_SHPJRULE_CHANGE_DIALOG_VIEW %>" + "shpjRuleId=" + shpjruleId;
	
	if (top.setContent) {
		top.setContent("<%= UIUtil.toJavaScript((String)shippingRB.get("shpjRuleChangePanelPrompt")) %>", url, true);
	}
	else {
		parent.location.replace(url);
	}


}
function displayShpjrule () {
   	
	savePanelData();
	var shpjruleId = -1;
	if (arguments.length > 0) {
		shpjruleId = arguments[0];

	}

	var o = parent.parent.get("<%= ShippingConstants.ELEMENT_CALCRULE_DETAILS_BEAN %>", null);
	if(  o != null ){
		
	}
	top.setReturningPanel("shpjruleByCalcRuleListPanel");
	

	// save the states of the tabs
	top.saveData(parent.parent.pageArray, "shpjrulePageArray");

	if(shpjruleId!=-1){
		var url = "<%= ShippingConstants.URL_SHPJRULE_DETAILS_DIALOG_VIEW%>" + "shpjRuleId=" + shpjruleId + "&amp;<%=ShippingConstants.PARAMETER_READONLY%>=true";
	
		if (top.setContent) {
			top.setContent("<%= UIUtil.toJavaScript((String)shippingRB.get(ShippingConstants.MSG_DETAILS_SHPJRULE)) %>", url, true);
		}
		else {
			parent.location.replace(url);
		}
	}

}



function deleteShpjrules() {
		
	
	var checked = parent.getChecked();
	if (checked.length > 0) {
		if (confirmDialog("<%= UIUtil.toJavaScript((String)shippingRB.get(ShippingConstants.MSG_SHPJRULE_LIST_DELETE_CONFIRMATION)) %>")) {
			if (parent.parent.get) {
				var o = parent.parent.get("<%= ShippingConstants.ELEMENT_CALCRULE_DETAILS_BEAN %>", null);
				if (o != null) {
					// get the saved shjrules from the calculation rule details databean
					var shjrules = o.<%= ShippingConstants.ELEMENT_SHPJRULES %>;
					// create a new shjrules array which will store the remaining (non-deleted) shjrules
					var newShjrules = new Array();

					// loop through all the shjrules...
					// if a shjrule is not marked for deletion, store it in the new array, otherwise skip.
					for (i=0; i < shjrules.length; i++) {
						var doDelete = false;
						for (j=0; j < checked.length; j++) {
							if ( checked[j] == i ) {
								// the shjrule checkbox "name" was found in the checked array, set delete flag
								doDelete = true;
								break;
							}
						}
						// if this shjrule is not to be deleted, copy it to the new array
						if (!doDelete) {
							newShjrules[newShjrules.length] = new Object();
							newShjrules[newShjrules.length-1] = shjrules[i];
						}
					}
					o.<%= ShippingConstants.ELEMENT_SHPJRULES %> = newShjrules;
				}
			}
			// reload page now that the when choice have been deleted
			savePanelData();
			parent.location.reload();
		}
	}
}

function selectShpjrule(value)
{

	parent.refreshButtons();

	if (value == "false"){
    	disableButton(parent.buttons.buttonForm.newButton);		 
    	
    	var checked = parent.getChecked();
		if (checked!=null&&checked.length > 0) {
		for (var i=0;i<checked.length;i++){
		    	disableButton(parent.buttons.buttonForm.changeButton);
		    	disableButton(parent.buttons.buttonForm.deleteButton);
				break;			
			}
		}
	
	}
}

function userInitialButtons(){
	var value = "<%=editable%>";
	selectShpjrule(value);
}


function getResultsSize  () {
	if (parent.parent.get) {
		var o = parent.parent.get("<%= ShippingConstants.ELEMENT_CALCRULE_DETAILS_BEAN %>", null);
		if (o != null) {
			var shjrules = ruledatabean.<%= ShippingConstants.ELEMENT_SHPJRULES %>;
			return shjrules.length;
		}
	}
	return 0;
}

function loadPanelData () {

	parent.loadFrames();
	
	// initialize states of the tabs
	if (top.getData("shpjrulePageArray") != null) {
		parent.parent.pageArray = top.getData("shpjrulePageArray");
		parent.parent.TABS.location.reload();
		top.saveData(null, "shpjrulePageArray");
	}
	
	if (parent.parent.setContentFrameLoaded) {
		parent.parent.setContentFrameLoaded(true);
	}
	
}


function validatePanelData () {
  
   	return true;
  }
  
function savePanelData(){
  	
   	top.saveModel(parent.parent.model);
	top.saveData(parent.parent.get("<%= ShippingConstants.ELEMENT_CALCRULE_DETAILS_BEAN %>"), "<%= ShippingConstants.ELEMENT_CALCRULE_DETAILS_BEAN %>");

	
}
//-->
</script>
<meta name="GENERATOR" content="IBM WebSphere Studio">
</head>

<body onload="loadPanelData()" class="content_list">


<H1><%= shippingRB.get(ShippingConstants.MSG_SHPJRULE_LIST_TITLE) %></H1>

<form name="shpjruleListForm">

<!--


if(ruledatabean.id != null){

<p class="entry_text"><%= (String)shippingRB.get(ShippingConstants.MSG_SHPJRULE_CALCRULE) %>  + " " + ruledatabean.id 

}

-->

<%= comm.startDlistTable((String)shippingRB.get(ShippingConstants.MSG_SHPJRULE_LIST_SUMMARY)) %>
<%= comm.startDlistRowHeading() %>
<%= comm.addDlistCheckHeading(true, "parent.selectDeselectAll();selectShpjrule('"+ String.valueOf(editable) +"')") %>
<%= comm.addDlistColumnHeading((String)shippingRB.get(ShippingConstants.MSG_SHPJRULE_LIST_FFC_COLUMN), null, false) %>
<%= comm.addDlistColumnHeading((String)shippingRB.get(ShippingConstants.MSG_SHPJRULE_LIST_ZONE_COLUMN), null, false) %>
<%= comm.addDlistColumnHeading((String)shippingRB.get(ShippingConstants.MSG_SHPJRULE_LIST_SHIPMODE_COLUMN), null, false) %>
<%= comm.addDlistColumnHeading((String)shippingRB.get(ShippingConstants.MSG_SHPJRULE_LIST_PRECEDENCE_COLUMN), null, false) %>

<%= comm.endDlistRow() %>


<SCRIPT LANGUAGE="JavaScript">
<!---- hide script from old browsers
var j = 0;
var ruledatabean = parent.parent.get("<%= ShippingConstants.ELEMENT_CALCRULE_DETAILS_BEAN %>", null);
var shjrules = ruledatabean.<%= ShippingConstants.ELEMENT_SHPJRULES %>;
var numberOfShjrules = shjrules.length;

for (var i=0; i<numberOfShjrules; i++) {
	var shjrule = shjrules[i];

	if (j == 0) {
		document.writeln('<TR CLASS="list_row1">');
		j = 1;
	}
	else {
		document.writeln('<TR CLASS="list_row2">');
		j = 0;
	}
	addDlistCheck(i,"parent.setChecked();selectShpjrule(\'<%=editable%>\')");
    <% if (editable){
    %>
    if (shjrule.<%= ShippingConstants.ELEMENT_FFC_NAME %> == null || shjrule.<%= ShippingConstants.ELEMENT_FFC_NAME %> == "" ){
    	addDlistColumn("<%= shippingRB.get(ShippingConstants.MSG_ANY) %>", "javascript:changeShpjrule("+i+")");
    }
    else{
    	addDlistColumn(shjrule.<%= ShippingConstants.ELEMENT_FFC_NAME %>, "javascript:changeShpjrule("+i+")");
    }
    <% } else{
    %>
    if (shjrule.<%= ShippingConstants.ELEMENT_FFC_NAME %> == null || shjrule.<%= ShippingConstants.ELEMENT_FFC_NAME %> == "" ){
    	addDlistColumn("<%= shippingRB.get(ShippingConstants.MSG_ANY) %>", "javascript:displayShpjrule("+i+")");
    }
    else{
		addDlistColumn(shjrule.<%= ShippingConstants.ELEMENT_FFC_NAME %>, "javascript:displayShpjrule("+i+")");
	}
	<% }
	%>
	addDlistColumn(shjrule.<%= ShippingConstants.ELEMENT_ZONE_CODE %>, "none");
	addDlistColumn(shjrule.<%= ShippingConstants.ELEMENT_SHIPMODE_CARRIER %> + " - " + shjrule.<%= ShippingConstants.ELEMENT_SHIPMODE_CODE %>, "none");
	addDlistColumn(shjrule.<%= ShippingConstants.ELEMENT_PRECEDENCE %>, "none");
	document.writeln("</TR>");
}

//-->
</SCRIPT>

<%= comm.endDlistTable() %>
<SCRIPT LANGUAGE="JavaScript">
<!---- hide script from old browsers
if (numberOfShjrules == 0) {
	document.writeln('<br>');
	document.writeln('<%= UIUtil.toJavaScript((String)shippingRB.get(ShippingConstants.MSG_SHPJRULE_LIST_EMPTY)) %>');
}
//-->
</SCRIPT>

</FORM>

<SCRIPT LANGUAGE="JavaScript">
<!---- hide script from old browsers
parent.afterLoads();
parent.setResultssize(numberOfShjrules);
parent.setButtonPos("0px", "42px");
//-->
</SCRIPT>



</body>

</html>

