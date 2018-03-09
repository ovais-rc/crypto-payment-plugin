<!--********************************************************************
*-------------------------------------------------------------------
* Licensed Materials - Property of IBM
*
* WebSphere Commerce
*
* (c) Copyright IBM Corp. 2000, 2016
*
* US Government Users Restricted Rights - Use, duplication or
* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
*
*-------------------------------------------------------------------
*-->
<%@ page language="java" import="java.util.*" %>

<%@ page import="com.ibm.commerce.beans.*" %>
<%@ page import="com.ibm.commerce.command.*" %>
<%@ page import="com.ibm.commerce.common.objects.ReportDeliverySettingAccessBean" %>
<%@ page import="com.ibm.commerce.ras.*" %>
<%@ page import="com.ibm.commerce.server.*" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>

<%@include file="../common/common.jsp" %>

<%--
//---------------------------------------------------------------------
//- Logic Section
//---------------------------------------------------------------------
--%>
<%
CommandContext cmdContextLocale = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
Locale jLocale 		= cmdContextLocale.getLocale();
String storeId		= cmdContextLocale.getStoreId().toString();

Hashtable reportSetupNLS 	= (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("store.PeriodicReportSetupNLS", jLocale);

//retrieve information from database @kng
String format = "0";
String frequency = "M";
String fiscalYear = "01/01";
try {
	ReportDeliverySettingAccessBean repDeliverySetupAB = repDeliverySetupAB = new ReportDeliverySettingAccessBean();
	repDeliverySetupAB.setInitKey_storeentId(storeId);
	
	format = repDeliverySetupAB.getFormat();
	frequency = repDeliverySetupAB.getFrequency();
	fiscalYear = repDeliverySetupAB.getFiscalYear();	
} catch (Exception ex) {
	format = "0";
	frequency = "M";
	fiscalYear = "01/01";
}
%>

<html>
  <head>  
    <link rel=stylesheet href="<%= UIUtil.getCSSFile(jLocale) %>" type="text/css">
    
    <title><%= UIUtil.toHTML(reportSetupNLS.get("reportSetupTitle").toString()) %></title>
    <script src="/wcs/javascript/tools/common/Util.js"></script>
    <script src="/wcs/javascript/tools/common/Vector.js"></script>


	<script>
	
	function initializeState() {
		var storeFiscalYear = "<%= fiscalYear %>";
		if (storeFiscalYear != "null" && storeFiscalYear != "") {
			storeFiscalYear = storeFiscalYear.split("/");
			document.reportSetupForm.month.value = storeFiscalYear[0];
			document.reportSetupForm.day.value = storeFiscalYear[1];
		}
		
		fiscalYearDisplay();	
		
		parent.setContentFrameLoaded(true);
	}

	function fiscalYearDisplay() {
      		var isQuarterly = document.reportSetupForm.frequency[1].checked;
      		var division = document.all.fiscalYearDiv;
      	  
      		if (isQuarterly) {
		    	division.style.display = "block";
		} else {
		    	division.style.display = "none";
		}	
	}

	function validateFiscalYear(month, day) {
		if (day.length > 0 && day.charAt(0) == "0") {
			day = day.substring(1, day.length);
		}

		if (month.length > 0 && month.charAt(0) == "0") {
			month = month.substring(1, month.length);
		}

		var monthInt = parseInt(month);
		var dayInt = parseInt(day);
		
		if ( (monthInt != NaN) && (monthInt == 2) ) {
			if ( (dayInt != NaN) && (dayInt >= 1) && (dayInt <= 29) )
				return true;
			else
				return false;
		} else if ( (monthInt != NaN) && (monthInt == 4 || monthInt == 6 || monthInt == 9 || monthInt == 11) ) {
			if ( (dayInt != NaN) && (dayInt >= 1) && (dayInt <= 30) )
				return true;
			else
				return false;
		} else if ( (monthInt != NaN) && (monthInt == 1 || monthInt == 3 || monthInt == 5 || monthInt == 7 || monthInt == 8 || monthInt == 10 || monthInt == 12) ) {
			if ( (dayInt != NaN) && (dayInt >= 1) && (dayInt <= 31) )
				return true;
			else
				return false;
		} else {
			return false;
		}
	}

	function validatePanelData() {
		if (parent.get("frequency") == "Q") {
			var month = document.reportSetupForm.month.value;
			var day = document.reportSetupForm.day.value;
			
			if ( month != "" && day != "") {
				if (validateFiscalYear(month, day)) {
					parent.put("fiscalYear", month + "/" + day);
					parent.setContentFrameLoaded(false);
					return true;
				} else {
					alertDialog("<%=UIUtil.toJavaScript((String)reportSetupNLS.get("reportSetupInvalidDate"))%>");
				}
			} else {
				alertDialog("<%=UIUtil.toJavaScript((String)reportSetupNLS.get("reportSetupNoDate"))%>");
			}
		} else {
			parent.put("fiscalYear", "<%= fiscalYear %>");
			parent.setContentFrameLoaded(false);
			return true;
		}
		return false;
	}
	
	function savePanelData() {
		if (document.reportSetupForm.format[0].checked) {
			format = document.reportSetupForm.format[0].value;
		} else {
			format = document.reportSetupForm.format[1].value;
		}
		
		if (document.reportSetupForm.frequency[0].checked) {
			frequency = document.reportSetupForm.frequency[0].value;
		} else {
			frequency = document.reportSetupForm.frequency[1].value;
		}
	
		parent.put("URL", "DialogNavigation");
		parent.put("format", format);
		parent.put("frequency", frequency);
	}
	</script>
	
  </head>

  <body class=content onload="initializeState();">
  <h1><%= UIUtil.toHTML((String)reportSetupNLS.get("reportSetupTitle")) %></h1>
  <P><%= UIUtil.toHTML((String)reportSetupNLS.get("reportSetupDescription")) %>    

    <form name="reportSetupForm"
          method="post"
          action="">

	<table border=0 cellpadding=0 cellspacing=0>
        <tr>
          <td valign="bottom" align="left">
            <%= UIUtil.toHTML((String)reportSetupNLS.get("reportSetupFrequency")) %><br />
          </td>
	</tr>
	<%
	String checked = "";
	if (frequency.equals("M")) {
		checked = "checked";
	}
	%>
	<tr>
          <td valign="bottom" align="left">
            <input type="radio" name="frequency" id="WCPeriodicReportSetup_frequencyMonthly" value="M" <%= checked %> onclick="fiscalYearDisplay()"><label for="WCPeriodicReportSetup_frequencyMonthly"><%= UIUtil.toHTML((String)reportSetupNLS.get("reportSetupMonthly")) %></label><br />
          </td>
        </tr>
	<%
	checked = "";
	if (frequency.equals("Q")) {
		checked = "checked";
	}
	%>  
	<tr>
          <td valign="bottom" align="left">
            <input type="radio" name="frequency" id="WCPeriodicReportSetup_frequencyQuarterly" value="Q" <%= checked %> onclick="fiscalYearDisplay()"><label for="WCPeriodicReportSetup_frequencyQuarterly"><%= UIUtil.toHTML((String)reportSetupNLS.get("reportSetupQuarterly")) %></label><br /><br />
          </td>
        </tr>
        </table>
        
        <div id="fiscalYearDiv" style="display:none;">
          <table border=0 cellpadding=0 cellspacing=0>
          <tr colspan=2 >
            <td valign="bottom" align="left">
              &nbsp;&nbsp;&nbsp;<%= UIUtil.toHTML((String)reportSetupNLS.get("reportSetupFiscalYear")) %><br />
            </td>
	  </tr>
	  
          <tr>
            <td valign="bottom" align="left">
              &nbsp;&nbsp;&nbsp;<label for="WCPeriodicReportSetup_month"><%= UIUtil.toHTML((String)reportSetupNLS.get("reportSetupMonth")) %></label><br />
            </td>
            <td valign="bottom" align="left">
              <label for="WCPeriodicReportSetup_day"><%= UIUtil.toHTML((String)reportSetupNLS.get("reportSetupDay")) %></label><br />
            </td>          
	  </tr>
          <tr>
            <td valign="bottom" align="left">
              &nbsp;&nbsp;&nbsp;<input type="text" name="month" id="WCPeriodicReportSetup_month" value="01" size=4 maxlength=2 >
            </td>
            <td valign="bottom" align="left">
              <input type="text" name="day" id="WCPeriodicReportSetup_day" value="01" size=4 maxlength=2 >
            </td>          
	  </tr>
	  </table>
        </div>
        
        <table border=0 cellpadding=0 cellspacing=0>
        <p><br />
        <tr>
          <td valign="bottom" align="left">
            <%= UIUtil.toHTML((String)reportSetupNLS.get("reportSetupFormat")) %><br />
          </td>
	</tr>
	<%
	checked = "";
	if (format.equals("0")) {
		checked = "checked";
	}
	%>
	<tr>
          <td valign="bottom" align="left">
            <input type="radio" name="format" id="WCPeriodicReportSetup_formatText" value="0" <%= checked %> ><label for="WCPeriodicReportSetup_formatText"><%= UIUtil.toHTML((String)reportSetupNLS.get("reportSetupText")) %></label><br />
          </td>
        </tr>
	<%
	checked = "";
	if (format.equals("1")) {
		checked = "checked";
	}
	%>
	<tr>
          <td valign="bottom" align="left">
            <input type="radio" name="format" id="WCPeriodicReportSetup_formatCSV" value="1" <%= checked %> ><label for="WCPeriodicReportSetup_formatCSV"><%= UIUtil.toHTML((String)reportSetupNLS.get("reportSetupCS")) %></label><br />
          </td>
        </tr>
      </table>
    </form>
  </body>
</html>
