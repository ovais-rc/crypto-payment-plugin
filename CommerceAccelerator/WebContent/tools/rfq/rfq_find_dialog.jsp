<!-- 
========================================================================
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2000, 2002, 2003
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
========================================================================
--> 
<%@ page import="com.ibm.commerce.utf.beans.*" %>
<%@ page import="com.ibm.commerce.utf.commands.*" %>
<%@ page import="com.ibm.commerce.utf.helper.*" %>
<%@ page import="com.ibm.commerce.utf.utils.*" %>
<%@ page import="com.ibm.commerce.utf.objects.*" %>
<%@ page import="com.ibm.commerce.tools.test.*" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.command.*" %>
<%@ page import="com.ibm.commerce.common.objects.*" %>
<%@ page import="java.sql.*" %>

<%@ include file="../common/common.jsp" %>

<%
	Locale   aLocale = null;
	CommandContext aCommandContext = (CommandContext)request.getAttribute("CommandContext");  
	String ErrorMessage = request.getParameter(com.ibm.commerce.tools.common.ui.UIProperties.SUBMIT_ERROR_MESSAGE);
	if (ErrorMessage == null) {
		ErrorMessage = "";
	}
	if( aCommandContext!= null ) {
       aLocale = aCommandContext.getLocale();
	}
	Hashtable userNLS = null;
	Hashtable rfqNLS = (Hashtable)ResourceDirectory.lookup("rfq.rfqNLS",aLocale);
	Hashtable neg_properties = (Hashtable)ResourceDirectory.lookup("negotiations.negotiationsNLS",aLocale);
	userNLS = (Hashtable)ResourceDirectory.lookup("csr.userNLS", aLocale);
%>
 
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head> 
<link rel="stylesheet" href="<%= UIUtil.getCSSFile(aLocale)%>" type="text/css" />
<title></title>
<script type="text/javascript" src="/wcs/javascript/tools/common/Util.js"></script>
<script type="text/javascript" src="/wcs/javascript/tools/common/DateUtil.js"></script>

<script type="text/javascript">

var msgInvalidSize = '<%= UIUtil.toJavaScript((String)neg_properties.get("msgInvalidSize")) %>';

function getResultBCT() {
	return "<%= UIUtil.toJavaScript(rfqNLS.get("rfq_bct_result")) %>";
}

function initializeState(){
	  document.rfqsearchform.focus();
	  parent.setContentFrameLoaded(true);
}

function getAfterCreateDate(){
	window.yearField = document.rfqsearchform.byear;
	window.monthField = document.rfqsearchform.bmonth;
	window.dayField = document.rfqsearchform.bday;
}

function getAfterActiveDate(){
	window.yearField = document.rfqsearchform.ayear;
	window.monthField = document.rfqsearchform.amonth;
	window.dayField = document.rfqsearchform.aday;
}

function savePanelData(){
	return true;
}

function formatDate(year,month,day){
	var fdate = "" + year + "-" + month + "-" + day;
	return fdate;
}

function formatTime(tm){
	var hr, mn, ftime;
	var splitTimeArray = tm.split(":");
	if ( splitTimeArray[0] < 10 && splitTimeArray[0].charAt(0) != "0" )
		hr = "0" + splitTimeArray[0];
	else
		hr = splitTimeArray[0];
		
	if ( splitTimeArray[1] < 10 && splitTimeArray[1].charAt(0) != "0" )
		mn = "0" + splitTimeArray[1];
	else
		mn = splitTimeArray[1];
		
	var ftime = "" + hr + ":" + mn + ":00";
	return ftime;
}

function validatePanelData(){
	var form = document.rfqsearchform;

	var createdate = "";
	var createtime = "";
	var createday;
	if ((form.byear.value!="")||(form.bmonth.value!="")||(form.bday.value!="")){
		if ( validDate(form.byear.value, form.bmonth.value, form.bday.value))
			 createdate = formatDate(form.byear.value, form.bmonth.value,form.bday.value);
		else {
			createdate="";
			parent.alertDialog("<%= UIUtil.toJavaScript(rfqNLS.get("msgInvalidDate")) %>");
			return false;
		}		
		if (validTime(form.btime.value))
			createtime = formatTime(form.btime.value);
		else{
			createtime = "";
			parent.alertDialog("<%= UIUtil.toJavaScript(rfqNLS.get("msgInvalidTime")) %>");
			return false;
		}	
		createday = document.rfqsearchform.createday;
	}		
	createday = createdate + " " + createtime;
	var activedate = "";
	var activetime ="";
	if ((form.ayear.value!="")||(form.amonth.value!="")||(form.aday.value!="")){
		if ( validDate(form.ayear.value,form.amonth.value,form.aday.value))
			activedate = formatDate(form.ayear.value, form.amonth.value,form.aday.value);
		else{
			activedate="";
			parent.alertDialog("<%= UIUtil.toJavaScript(rfqNLS.get("msgInvalidDate")) %>");
			return false;
		}			
		if (validTime(form.atime.value))
			activetime = formatTime(form.atime.value);
		else{
			activetime = "";
			parent.alertDialog(" <%= UIUtil.toJavaScript(rfqNLS.get("msgInvalidTime")) %>");
			return false;
		}	
	}		
	var activeday = null;
	activeday = activedate + " " + activetime;
	if (!isValidUTF8length(form.name.value,200)) {
		reprompt(form.name, msgInvalidSize);
		return false;
	}
	if ((form.name.value.length != 0) && (form.state.value.length == 0) && (isInputStringEmpty(createday)) && (isInputStringEmpty(activeday))) {
		return true;
	} else if ((form.name.value.length == 0) && (form.state.value.length != 0) && (isInputStringEmpty(createday)) && (isInputStringEmpty(activeday))) {
		return true;
	} else if ((form.name.value.length == 0) && (form.state.value.length == 0) && (!(isInputStringEmpty(createday))) && (isInputStringEmpty(activeday))) {
		return true;
	} else if ((form.name.value.length == 0) && (form.state.value.length == 0) && (isInputStringEmpty(createday)) && (!(isInputStringEmpty(activeday)))) {
		return true;
	} else {
		alertDialog ("<%= UIUtil.toJavaScript((String)rfqNLS.get("msgSearchCriterionRequired")) %>");
		return false;
	}
}

function closeCalendar()
{
    document.all.CalFrame.style.display="none";
}
</script>
</head>

<body  onload="initializeState()" onclick="closeCalendar()" class="content">

<iframe style='display:none;position:absolute;width:198;height:230;z-index=10' id='CalFrame' marginheight='0' marginwidth='0' frameborder='0' scrolling='no' src='/webapp/wcs/tools/servlet/tools/common/Calendar.jsp' title='<%= rfqNLS.get("calendarTool")%>'></iframe>

<h1><%= rfqNLS.get("RFQfindTitle") %></h1>

<p><%= rfqNLS.get("msgfind") %></p>

<form name="rfqsearchform" action="">

<table>
    <tr>
	<td>
	    <label for="name">
	    <%= rfqNLS.get("name") %><br />
	    <input type="text" name="name" id="name" size="50" />
	    </label>

	    <label for="casesensitive">
	    <input type="checkbox" name="casesensitive" id="casesensitive" value="able" />
  	    <%= rfqNLS.get("caseinsensitive") %><br />
  	    </label>
	</td>
    </tr>
    <tr>
	<td>
	    <label for="status"><%= rfqNLS.get("status") %><br />
	    <select name="state" id="status">
        	<option value="" selected="selected"> </option> 
        	<option value="1"><%= rfqNLS.get("active") %> </option> 
        	<option value="2"><%= rfqNLS.get("closed") %> </option>
        	<option value="3"><%= rfqNLS.get("complete") %>	</option>
         	<option value="4"><%= rfqNLS.get("nextround") %> </option>
    	</select>
	    </label>
	</td>
    </tr>
	
    <tr>
	<td>
	    <%= rfqNLS.get("createafter") %><br />
	    <table>
		<tr>
		    <td>
			<label for="byear">
			<%= rfqNLS.get("year") %><br />
		        <input name="byear" id="byear" size="5" type="text" maxlength="4" />
			</label>
		    </td>
		    <td>
		    	<label for="bmonth">
			<%= rfqNLS.get("month") %><br />
		    	<input name="bmonth" id="bmonth" size="5" type="text" maxlength="2" />
			</label>
		    </td>
		    <td>
			<label for="bday">
			<%= rfqNLS.get("day") %><br />
		    	<input name="bday" id="bday" size="5" type="text" maxlength="2" />
			</label>
		    </td>
		    <td width="25">
		        &nbsp;
			<a href="javascript:getAfterCreateDate();showCalendar(document.rfqsearchform.calImg1)">
			<img src="/wcs/images/tools/calendar/calendar.gif" border="0" id='calImg1' alt="<%= rfqNLS.get("calendarTool")%>" /></a>
		    </td>
		    <td>
		        <label for="btime">
			<%= rfqNLS.get("time") %><br />
			<input name="btime" id="btime" size="5" type="text" maxlength="5" />
			</label>
		    </td>
		</tr>
	    </table>
	</td>
    </tr>

    <tr>
	<td>
	    <%= rfqNLS.get("activeafter") %><br />
	    <table>
	        <tr>
		    <td>
		        <label for="ayear">
			<%= rfqNLS.get("year") %><br />
		  	<input name="ayear" id="ayear" size="5" type="text" maxlength="4" />
			</label>
		    </td>
		    <td>
			<label for="amonth">
			<%= rfqNLS.get("month") %><br />
		    	<input name="amonth" id="amonth" size="5" type="text" maxlength="2" />
			</label>
		    </td>
		    <td>
		    	<label for="aday">
			<%= rfqNLS.get("day") %><br />
			<input name="aday" id="aday" size="5" type="text" maxlength="2" />
			</label>
		    </td>
		    <td width="25">
		    	&nbsp;		
			<a href="javascript:getAfterActiveDate();showCalendar(document.rfqsearchform.calImg2)">
			<img src="/wcs/images/tools/calendar/calendar.gif" border="0" id='calImg2' alt="<%= rfqNLS.get("calendarTool")%>" /></a>
		    </td>
		    <td>
		    	<label for="atime">
			<%= rfqNLS.get("time") %><br />
			<input name="atime" id="atime" size="5" type="text" maxlength="5" />
			</label>
		    </td>
		</tr>
	    </table>
	</td>
    </tr>
</table>
</form>

</body>
</html>
