<%--
/*
 *-------------------------------------------------------------------
 * Licensed Materials - Property of IBM 
 *
 * WebSphere Commerce
 *
 * (c) Copyright International Business Machines Corporation. 2003
 *     All rights reserved.
 *
 * US Government Users Restricted Rights - Use, duplication or
 * disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 *-------------------------------------------------------------------
*/
////////////////////////////////////////////////////////////////////////////////
//
// Change History
//
// YYMMDD    F/D#   WHO       Description
//------------------------------------------------------------------------------
// 020723	    KNG		Initial Create
//
// 020813	    KNG		Make changes from code review and
//				UCD design exploration sessions
////////////////////////////////////////////////////////////////////////////////
--%>

<%@ page language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="com.ibm.commerce.command.*" %>
<%@ page import="com.ibm.commerce.server.*" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@include file="ReleaseOrdersHelper.jsp" %>
<%@include file="../common/common.jsp" %>

<%
// obtain the resource bundle for display
CommandContext cmdContextLocale = (CommandContext)request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
Locale jLocale 		= cmdContextLocale.getLocale();
Integer languageId	= cmdContextLocale.getLanguageId();
Integer storeId 	= cmdContextLocale.getStoreId();

Vector specialFFMCDisplayNames = getSpecialFFMCsInformation(storeId.toString(), languageId.toString(), 0);
String firstDisplayName = null;
if (specialFFMCDisplayNames != null && specialFFMCDisplayNames.size()>0 ) {
	firstDisplayName = (String)specialFFMCDisplayNames.elementAt(0);
}

Hashtable releaseOrderItemsNLS 	= (Hashtable)ResourceDirectory.lookup("inventory.releaseOrderItemsNLS", jLocale);
Hashtable calendarNLS = (Hashtable)ResourceDirectory.lookup("common.calendarNLS", jLocale);

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
<HTML>
<HEAD>
<link rel=stylesheet href="<%= UIUtil.getCSSFile(jLocale) %>" type="text/css"> 
<TITLE></TITLE>
<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/common/DateUtil.js"></SCRIPT>

<SCRIPT FOR=document EVENT="onclick()">
	document.all.CalFrame.style.display="none";
</SCRIPT>

<SCRIPT LANGUAGE="JavaScript">
<!---- hide script from old browsers

function initializeState()
{
	parent.setContentFrameLoaded(true);
}

function savePanelData()
{
}

function onLoad() {
	initializeState();
}

function setupOrderDateSD()
{
	window.yearField = document.all.orderDateSDYear;
	window.monthField = document.all.orderDateSDMonth;
	window.dayField = document.all.orderDateSDDay;  
}

function setupOrderDateED()
{
	window.yearField = document.all.orderDateEDYear;
	window.monthField = document.all.orderDateEDMonth;
	window.dayField = document.all.orderDateEDDay;
}

function setupShopcartDateSD()
{
	window.yearField = document.all.shopcartDateSDYear;
	window.monthField = document.all.shopcartDateSDMonth;
	window.dayField = document.all.shopcartDateSDDay;  
}

function setupShopcartDateED()
{
	window.yearField = document.all.shopcartDateEDYear;
	window.monthField = document.all.shopcartDateEDMonth;
	window.dayField = document.all.shopcartDateEDDay;
}


function isEmpty(id) {
	return !id.match(/[^\s]/);
}
function isNumber(word) 
{
	var numbers="0123456789";
	for (var i=0; i < word.length; i++)
	{
		if (numbers.indexOf(word.charAt(i)) == -1) 
		return false;
	}
	return true;
}

function createSDTimestampString(year, month, day)
{
	var returnString = year  + "-" +
			   month + "-" +
			   day   + " 00:00:00.000000000";
	return returnString;
}

function createEDTimestampString(year, month, day)
{
         var returnString = year  + "-" +
			    month + "-" +
			    day   + " 23:59:59.999999";
	return returnString;
}

function validateEntries()
{
	if (isEmpty(document.findForm.orderId.value)
	   && isEmpty(document.findForm.orderDateSDDay.value) && isEmpty(document.findForm.orderDateSDMonth.value)
	   && isEmpty(document.findForm.orderDateSDYear.value) && isEmpty(document.findForm.orderDateEDDay.value)
	   && isEmpty(document.findForm.orderDateEDMonth.value) && isEmpty(document.findForm.orderDateEDYear.value)
	   && isEmpty(document.findForm.shopcartDateSDDay.value) && isEmpty(document.findForm.shopcartDateSDMonth.value)
	   && isEmpty(document.findForm.shopcartDateSDYear.value) && isEmpty(document.findForm.shopcartDateEDDay.value)
	   && isEmpty(document.findForm.shopcartDateEDMonth.value) && isEmpty(document.findForm.shopcartDateEDYear.value) ) {
		alertDialog('<%=UIUtil.toJavaScript((String)releaseOrderItemsNLS.get("FindReleasedOrderItemsNoCriteria"))%>');
		return false;
	} else {
	
		//validate order number
		if (!isEmpty(document.findForm.orderId.value)) {
			if (!isNumber(document.findForm.orderId.value)) {
				alertDialog ('<%=UIUtil.toJavaScript((String)releaseOrderItemsNLS.get("FindReleasedOrderItemsInvalidNumber"))%>');
				return false;
			}   
		}
	
		//validate order date SD
		if (!isEmpty(document.findForm.orderDateSDDay.value) || !isEmpty(document.findForm.orderDateSDMonth.value) 
		    || !isEmpty(document.findForm.orderDateSDYear.value) ) {
	    		if ( !validDate(document.findForm.orderDateSDYear.value, document.findForm.orderDateSDMonth.value, document.findForm.orderDateSDDay.value) ) {
				alertDialog ('<%=UIUtil.toJavaScript((String)releaseOrderItemsNLS.get("FindReleasedOrderItemsInvalidOrderDateSD"))%>');
				return false;
			}
		}
		
		//validate order date ED
		if (!isEmpty(document.findForm.orderDateEDDay.value) || !isEmpty(document.findForm.orderDateEDMonth.value) 
		    || !isEmpty(document.findForm.orderDateEDYear.value) ) {
	    		if ( !validDate(document.findForm.orderDateEDYear.value, document.findForm.orderDateEDMonth.value, document.findForm.orderDateEDDay.value) ) {
				alertDialog ('<%=UIUtil.toJavaScript((String)releaseOrderItemsNLS.get("FindReleasedOrderItemsInvalidOrderDateED"))%>');
				return false;
			}		    
		}
		
		//validate order date start date < end date
		if (!isEmpty(document.findForm.orderDateSDYear.value) && !isEmpty(document.findForm.orderDateEDYear.value) ) {
			if ( !validateStartEndDateTime(document.findForm.orderDateSDYear.value, document.findForm.orderDateSDMonth.value, document.findForm.orderDateSDDay.value, document.findForm.orderDateEDYear.value, document.findForm.orderDateEDMonth.value, document.findForm.orderDateEDDay.value, null, null) ) {
				alertDialog ('<%=UIUtil.toJavaScript((String)releaseOrderItemsNLS.get("FindReleasedOrderItemsInvalidOrderDate"))%>');
				return false;
			}
		}
		
		//validate product released SD
		if (!isEmpty(document.findForm.shopcartDateSDDay.value) || !isEmpty(document.findForm.shopcartDateSDMonth.value) 
		    || !isEmpty(document.findForm.shopcartDateSDYear.value)  ) {
	    		if ( !validDate(document.findForm.shopcartDateSDYear.value, document.findForm.shopcartDateSDMonth.value, document.findForm.shopcartDateSDDay.value) ) {
				alertDialog ('<%=UIUtil.toJavaScript((String)releaseOrderItemsNLS.get("FindReleasedOrderItemsInvalidShopcartDateSD"))%>');
				return false;
			}
		}
		
		//validate product released ED
		if (!isEmpty(document.findForm.shopcartDateEDDay.value) || !isEmpty(document.findForm.shopcartDateEDMonth.value) 
		    || !isEmpty(document.findForm.shopcartDateEDYear.value) ) {
	    		if ( !validDate(document.findForm.shopcartDateEDYear.value, document.findForm.shopcartDateEDMonth.value, document.findForm.shopcartDateEDDay.value) ) {
				alertDialog ('<%=UIUtil.toJavaScript((String)releaseOrderItemsNLS.get("FindReleasedOrderItemsInvalidShopcartDateED"))%>');
				return false;
			}
		}
		
		//validate product released start date < end date
		if (!isEmpty(document.findForm.shopcartDateSDYear.value) && !isEmpty(document.findForm.shopcartDateEDYear.value) ) {
			if ( !validateStartEndDateTime(document.findForm.shopcartDateSDYear.value, document.findForm.shopcartDateSDMonth.value, document.findForm.shopcartDateSDDay.value, document.findForm.shopcartDateEDYear.value, document.findForm.shopcartDateEDMonth.value, document.findForm.shopcartDateEDDay.value, null, null) ) {
				alertDialog ('<%=UIUtil.toJavaScript((String)releaseOrderItemsNLS.get("FindReleasedOrderItemsInvalidShopcartDate"))%>');
				return false;
			}
		}		
		
		//validate maximum number to display
		if ( document.findForm.fetchSize.value != "100" ) {
			if ( !isNumber(document.findForm.fetchSize.value) || document.findForm.fetchSize.value == "0") {
				alertDialog ('<%=UIUtil.toJavaScript((String)releaseOrderItemsNLS.get("FindReleasedOrderItemsInvalidMaxDisplay"))%>');
				return false;
			}
		}
	}
	return true;
}

function findAction() {
	if (validateEntries() == true) {
		var url = '/webapp/wcs/tools/servlet/ReleasedOrderItemsListView';
		var urlPara = new Object();;
  		
  		urlPara.orderId		= document.findForm.orderId.value;
  		urlPara.fetchSize	= document.findForm.fetchSize.value;
  		
		if ( !isEmpty(document.findForm.orderDateSDYear.value) )
  			urlPara.orderDateSD = createSDTimestampString(document.findForm.orderDateSDYear.value, document.findForm.orderDateSDMonth.value, document.findForm.orderDateSDDay.value);
  		
  		if ( !isEmpty(document.findForm.orderDateEDYear.value) )
			urlPara.orderDateED = createEDTimestampString(document.findForm.orderDateEDYear.value, document.findForm.orderDateEDMonth.value, document.findForm.orderDateEDDay.value);
  		
  		if ( !isEmpty(document.findForm.shopcartDateSDYear.value) )
  			urlPara.shopcartDateSD = createSDTimestampString(document.findForm.shopcartDateSDYear.value, document.findForm.shopcartDateSDMonth.value, document.findForm.shopcartDateSDDay.value);
  		
  		if ( !isEmpty(document.findForm.shopcartDateEDYear.value) )
  			urlPara.shopcartDateED = createEDTimestampString(document.findForm.shopcartDateEDYear.value, document.findForm.shopcartDateEDMonth.value, document.findForm.shopcartDateEDDay.value);
		
		top.setContent("<%= UIUtil.toJavaScript((String)releaseOrderItemsNLS.get("FindReleasedOrderItemsResultBCT")) %>",url,true, urlPara);     
		return true;
	}
	return false;
}

function closeDialog() {
	top.goBack();
}

function clearAdvancedFields() {
	document.all["orderDateSDDay"].value = "";
	document.all["orderDateSDMonth"].value = "";
	document.all["orderDateSDYear"].value = "";
	document.all["orderDateEDDay"].value = "";
	document.all["orderDateEDMonth"].value = "";
	document.all["orderDateEDYear"].value = "";
	document.all["shopcartDateSDDay"].value = "";
	document.all["shopcartDateSDMonth"].value = "";
	document.all["shopcartDateSDYear"].value = "";
	document.all["shopcartDateEDDay"].value = "";
	document.all["shopcartDateEDMonth"].value = "";
	document.all["shopcartDateEDYear"].value = "";
	document.all["fetchSize"].value = "100";
}

function toggleDiv() {
	var division = document.all["advancedOptionsDivision"];
		
	if (division.style.display == "none") {
		division.style.display = "block";
	} else {
		division.style.display = "none";
		clearAdvancedFields();
	}
}
	
// -->
</SCRIPT>
</HEAD>


<BODY CLASS=content ONLOAD="initializeState();">
<IFRAME STYLE='display:none;position:absolute;width:198;height:230;z-index=10' ID='CalFrame' TITLE="<%= calendarNLS.get("calendarTitle") %>" MARGINHEIGHT=0 MARGINWIDTH=0 NORESIZE FRAMEBORDER=0 SCROLLING=NO SRC='/webapp/wcs/tools/servlet/tools/common/Calendar.jsp' ></IFRAME>

<H1><%=releaseOrderItemsNLS.get("FindReleasedOrderItemsTitle")%></H1>

<script language="javascript"><!--alert("FindReleasedOrderItems.jsp");--></script> 

<% if (firstDisplayName != null) {
	%>
	<SCRIPT LANGUAGE="JavaScript">
	var text = "<%= UIUtil.toJavaScript((String)releaseOrderItemsNLS.get("FindReleasedOrderItemsDescription")) %>";
	var ffmname = "<%= firstDisplayName %>";
	text = text.replace(/%1/, ffmname);
	document.writeln("<P>" + text + "<BR><BR>");
	</SCRIPT>
	<%
} else {
	%>
	<SCRIPT LANGUAGE="JavaScript">
	alertDialog("<%= UIUtil.toJavaScript((String)releaseOrderItemsNLS.get("FindReleasedOrderItemsNotAvaliable")) %>");
	top.goBack();
	</SCRIPT>
<%
}
%>

<P>
<FORM NAME="findForm">
<TABLE>
  <TBODY>
    <TR>
      <TD><label for="orderId"><%=releaseOrderItemsNLS.get("FindReleasedOrderItemsOrderNumber")%></label></TD>
    </TR>
    <TR>
      <TD><INPUT size="9" type="text" maxlength="9" name="orderId" id="orderId" title="orderId"></TD>
    </TR>
    <TR>
      <TD></TD>
    </TR>
    <TR>
      <TD>
      <BR>
      <a href='javascript:onclick=toggleDiv()' ><U><%= UIUtil.toHTML((String)releaseOrderItemsNLS.get("FindReleasedOrderItemsAdvancedSearch")) %></U></a>
      <BR>
      </TD>
    </TR>
  </TBODY>
</TABLE>

<DIV ID="advancedOptionsDivision" STYLE="display:none;">

    <TABLE CELLPADDING=0 CELLSPACING=0>
    <TR>
      <TD COLSPAN=9 ALIGN=LEFT VALIGN=CENTER HEIGHT=32><%= releaseOrderItemsNLS.get("FindReleasedOrderItemsOrderCreateDateRange") %></TD>
    </TR>
    <TR>
      <TD COLSPAN=4 VALIGN=TOP><LABEL><%= releaseOrderItemsNLS.get("FindReleasedOrderItemsStartDate") %></LABEL></TD>
      <TD WIDTH=40>&nbsp;</TD>
      <TD COLSPAN=4 VALIGN=TOP><LABEL><%= releaseOrderItemsNLS.get("FindReleasedOrderItemsEndDate") %></LABEL></TD>
    </TR>
    <TR>
      <TD><LABEL for="orderDateSDYear1"><%= releaseOrderItemsNLS.get("year") %></LABEL></TD>
      <TD><LABEL for="orderDateSDMonth1"><%= releaseOrderItemsNLS.get("month") %></LABEL></TD>
      <TD><LABEL for="orderDateSDDay1"><%= releaseOrderItemsNLS.get("day") %></LABEL></TD>
      <TD></TD>
      <TD></TD>
      <TD><LABEL for="orderDateEDYear1"><%= releaseOrderItemsNLS.get("year") %></LABEL></TD>
      <TD><LABEL for="orderDateEDMonth1"><%= releaseOrderItemsNLS.get("month") %></LABEL></TD>
      <TD><LABEL for="orderDateEDDay1"><%= releaseOrderItemsNLS.get("day") %></LABEL></TD>
      <TD></TD>
    </TR>
    <TR>
      <TD><INPUT TYPE='TEXT' NAME='orderDateSDYear' ID='orderDateSDYear1' SIZE=4 MAXLENGTH=4>&nbsp;</TD>
      <TD><INPUT TYPE='TEXT' NAME='orderDateSDMonth' ID='orderDateSDMonth1' SIZE=4 MAXLENGTH=2>&nbsp;</TD>
      <TD><INPUT TYPE='TEXT' NAME='orderDateSDDay'  ID='orderDateSDDay1' SIZE=4 MAXLENGTH=2></TD>
      <TD VALIGN=BOTTOM>
        <A HREF='javascript:setupOrderDateSD();showCalendar(document.all.orderDateSDImg)' >
          <IMG SRC='/wcs/images/tools/calendar/calendar.gif' BORDER='0'  id='orderDateSDImg' ALT='<%= releaseOrderItemsNLS.get("startDate")%>'>
        </A>
      </TD>
      <TD WIDTH=40>&nbsp;</TD>
      <TD><INPUT TYPE='TEXT' NAME='orderDateEDYear' ID='orderDateEDYear1' SIZE=4 MAXLENGTH=4>&nbsp;</TD>
      <TD><INPUT TYPE='TEXT' NAME='orderDateEDMonth' ID='orderDateEDMonth1' SIZE=4 MAXLENGTH=2>&nbsp;</TD>
      <TD><INPUT TYPE='TEXT' NAME='orderDateEDDay' ID='orderDateEDDay1'  SIZE=4 MAXLENGTH=2></TD>
      <TD VALIGN=BOTTOM>
        <A HREF='javascript:setupOrderDateED();showCalendar(document.all.orderDateEDImg)'>
          <IMG SRC='/wcs/images/tools/calendar/calendar.gif' BORDER='0'  id='orderDateEDImg' ALT='<%= releaseOrderItemsNLS.get("endDate")%>'>
        </A>
      </TD>
    </TR>
    </TABLE>
    
    <TABLE CELLPADDING=0 CELLSPACING=0>
    <TR>
      <TD COLSPAN=9 ALIGN=LEFT VALIGN=CENTER HEIGHT=32><%= releaseOrderItemsNLS.get("FindReleasedOrderItemsShoppingCartCreateDateRange") %></TD>
    </TR>
    <TR>
      <TD COLSPAN=4 VALIGN=TOP><LABEL><%= releaseOrderItemsNLS.get("FindReleasedOrderItemsStartDate") %></LABEL></TD>
      <TD WIDTH=40>&nbsp;</TD>
      <TD COLSPAN=4 VALIGN=TOP><LABEL><%= releaseOrderItemsNLS.get("FindReleasedOrderItemsEndDate") %></LABEL></TD>
    </TR>
    <TR>
      <TD><LABEL for="shopcartDateSDYear1"><%= releaseOrderItemsNLS.get("year") %></LABEL></TD>
      <TD><LABEL for="shopcartDateSDMonth1"><%= releaseOrderItemsNLS.get("month") %></LABEL></TD>
      <TD><LABEL for="shopcartDateSDDay1"><%= releaseOrderItemsNLS.get("day") %></LABEL></TD>
      <TD></TD>
      <TD></TD>
      <TD><LABEL for="shopcartDateEDYear1"><%= releaseOrderItemsNLS.get("year") %></LABEL></TD>
      <TD><LABEL for="shopcartDateEDMonth1"><%= releaseOrderItemsNLS.get("month") %></LABEL></TD>
      <TD><LABEL for="shopcartDateEDDay1"><%= releaseOrderItemsNLS.get("day") %></LABEL></TD>
      <TD></TD>
    </TR>
    <TR>
      <TD><INPUT TYPE='TEXT' NAME='shopcartDateSDYear' ID="shopcartDateSDYear1" SIZE=4 MAXLENGTH=4>&nbsp;</TD>
      <TD><INPUT TYPE='TEXT' NAME='shopcartDateSDMonth' ID="shopcartDateSDMonth1" SIZE=4 MAXLENGTH=2>&nbsp;</TD>
      <TD><INPUT TYPE='TEXT' NAME='shopcartDateSDDay'   ID="shopcartDateSDDay1" SIZE=4 MAXLENGTH=2></TD>
      <TD VALIGN=BOTTOM>
        <A HREF='javascript:setupShopcartDateSD();showCalendar(document.all.shopcartDateSDImg)' >
          <IMG SRC='/wcs/images/tools/calendar/calendar.gif' BORDER='0'  id='shopcartDateSDImg' ALT='<%= releaseOrderItemsNLS.get("startDate")%>'>
        </A>
      </TD>
      <TD WIDTH=40>&nbsp;</TD>
      <TD><INPUT TYPE='TEXT' NAME='shopcartDateEDYear' ID="shopcartDateEDYear1" SIZE=4 MAXLENGTH=4>&nbsp;</TD>
      <TD><INPUT TYPE='TEXT' NAME='shopcartDateEDMonth' ID="shopcartDateEDMonth1" SIZE=4 MAXLENGTH=2>&nbsp;</TD>
      <TD><INPUT TYPE='TEXT' NAME='shopcartDateEDDay'  ID="shopcartDateEDDay1" SIZE=4 MAXLENGTH=2></TD>
      <TD VALIGN=BOTTOM>
        <A HREF='javascript:setupShopcartDateED();showCalendar(document.all.shopcartDateEDImg)'>
          <IMG SRC='/wcs/images/tools/calendar/calendar.gif' BORDER='0'  id='shopcartDateEDImg' ALT='<%= releaseOrderItemsNLS.get("endDate")%>'>
        </A>
      </TD>
    </TR>
    </TABLE>
    
    <TABLE>
    <TR>
      <TD><BR><label for="fetchSize"><%=releaseOrderItemsNLS.get("FindReleasedOrderItemsMaximum")%></label></TD>
    </TR>
    <TR>
      <TD><INPUT size="9" type="text" maxlength="9" name="fetchSize" id="fetchSize" value="100"></TD>
    </TR>
    </TABLE>
    
</DIV>

</FORM>

<SCRIPT LANGUAGE="JavaScript">
<!--
//For IE
if (document.all) {
    onLoad();
}
//-->
</SCRIPT>

</BODY>
</HTML>


