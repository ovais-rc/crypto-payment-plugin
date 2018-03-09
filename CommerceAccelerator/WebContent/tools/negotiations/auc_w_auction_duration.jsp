
<%@page language="java" %>
<!-- ========================================================================
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2000, 2002
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
//* IBM Confidential
//* OCO Source Materials
//*
//* The source code for this program is not published or otherwise
//* divested of its trade secrets, irrespective of what has been
//* deposited with the US Copyright Office.
//*--------------------------------------------------------------------------------------
//* The sample contained herein is provided to you "AS IS".
//*
//* It is furnished by IBM as a simple example and has not been thoroughly tested
//* under all conditions.  IBM, therefore, cannot guarantee its reliability, 
//* serviceability or functionality.  
//*
//* This sample may include the names of individuals, companies, brands and products 
//* in order to illustrate concepts as completely as possible.  All of these names
//* are fictitious and any similarity to the names and addresses used by actual persons 
//* or business enterprises is entirely coincidental.
//*--------------------------------------------------------------------------------------
 ===========================================================================-->
<%@  page import="com.ibm.commerce.command.*" %>
<%@  page import="com.ibm.commerce.negotiation.beans.*" %>
<%@  page import="com.ibm.commerce.negotiation.bean.commands.*" %>
<%@  page import="java.util.*"  %>
<%@  page import="java.text.*"  %>
<%@  page import="com.ibm.commerce.tools.test.*" %>
<%@  page import="com.ibm.commerce.tools.util.*" %>
<%@include file="../common/common.jsp" %>

<%
     Locale   aLocale = null;
     CommandContext aCommandContext = (CommandContext)request.getAttribute("CommandContext");    
     if( aCommandContext!= null )
     {
       aLocale = aCommandContext.getLocale();
     }

     // obtain the resource bundle for display
     Hashtable auctionNLS = (Hashtable)ResourceDirectory.lookup("negotiations.negotiationsNLS",aLocale);
     
     //get time zone and time offset of server
     Calendar c=Calendar.getInstance();
     TimeZone  serverTimeZone=TimeZone.getDefault();
     int serverOffset=-c.getTimeZone().getRawOffset();
%>
<% 
//  String emptyString = new String("");
//  String temptime = "";

  String tmflag=  request.getParameter("tmflag");
  String autype = request.getParameter("autype");
  String auruletype = request.getParameter("auruletype");
  String locale = request.getParameter("locale");
   
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "DTD/xhtml1-transitional.dtd" >

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2006, 2014 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<HTML lang="en">
<HEAD>
<link rel=stylesheet href="<%= UIUtil.getCSSFile(aLocale) %>" type="text/css">
<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/common/DateUtil.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/negotiations/auc_common.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/negotiations/auc_datetime.js"></SCRIPT>
<%@include file="../common/NumberFormat.jsp" %>

</HEAD>

<BODY class=content ONLOAD="initializeState();">
<SCRIPT FOR=document EVENT="onclick()">
   document.all.CalFrame.style.display="none";
</SCRIPT>
<IFRAME STYLE="display:none;position:absolute;width:198;height:230;z-index=100"
ID="CalFrame" MARGINHEIGHT=0 MARGINWIDTH=0 NORESIZE FRAMEBORDER=0 SCROLLING=NO
SRC="/webapp/wcs/tools/servlet/Calendar" title="<%= auctionNLS.get("calendarImgAlt") %>">
</IFRAME>

<BR><h1><%= auctionNLS.get("AuctDuration") %></h1>

<FORM Name="DurationForm" id="DurationForm">
<TABLE id="WC_W_AuctionDuration_Table_1">
	<TR>
		<TD width=125 id="WC_W_AuctionDuration_TableCell_1"> 
			&nbsp;
		</TD>
		<!--<TD width=30> -->
		<TD nowrap id="WC_W_AuctionDuration_TableCell_2">
			<LABEL for="WC_W_AuctionDuration_year1_In_DurationForm"><%= auctionNLS.get("year") %></LABEL>
		</TD>
		<TD nowrap id="WC_W_AuctionDuration_TableCell_3"> 
			<LABEL for="WC_W_AuctionDuration_month1_In_DurationForm"><%= auctionNLS.get("month") %></LABEL>
		</TD>
		<!--<TD width=25> -->
		<TD nowrap id="WC_W_AuctionDuration_TableCell_4">
			<LABEL for="WC_W_AuctionDuration_day1_In_DurationForm"><%= auctionNLS.get("day") %></LABEL>
		</TD>
		<TD width=25 id="WC_W_AuctionDuration_TableCell_5">  
			&nbsp;
		</TD>
		<TD width=100 id="WC_W_AuctionDuration_TableCell_6"> 
		&nbsp;
		</TD>
		<TD id="WC_W_AuctionDuration_TableCell_7"> 
		&nbsp;
		</TD>
        </TR>  
        <TR>
            	<TD  width=125 id="WC_W_AuctionDuration_TableCell_8"> 
			<%= auctionNLS.get("AuctionStartDate") %>
	    	</TD>
		<TD width=25 id="WC_W_AuctionDuration_TableCell_9"> 
			<INPUT TYPE=TEXT VALUE="" NAME=YEAR1 SIZE=4 MAXLENGTH=4 id="WC_W_AuctionDuration_year1_In_DurationForm">
		</TD>
		<TD width=25 id="WC_W_AuctionDuration_TableCell_10"> 
			<INPUT TYPE=TEXT VALUE="" NAME=MONTH1 SIZE=2 MAXLENGTH=2 id="WC_W_AuctionDuration_month1_In_DurationForm">
		</TD>
		<TD width=25 id="WC_W_AuctionDuration_TableCell_11"> 
			<INPUT TYPE=TEXT VALUE="" NAME=DAY1 SIZE=2 MAXLENGTH=2 id="WC_W_AuctionDuration_day1_In_DurationForm">
		</TD>
		<TD width=25 id="WC_W_AuctionDuration_TableCell_12">  
                 <%--//<A HREF="#" onClick="javascript:setupDate1();showCalendar(document.DurationForm.calImg1)">--%>
		<A HREF="javascript:setupDate1();showCalendar(document.DurationForm.calImg1)">
                   <IMG SRC="/wcs/images/tools/calendar/calendar.gif" BORDER=0 id=calImg1 
                      alt="<%= auctionNLS.get("calendarImgAlt") %>">
                 </A>
		</TD>
                <!--<TD width=100> -->
		<TD nowrap id="WC_W_AuctionDuration_TableCell_13">
			<LABEL for="WC_W_AuctionDuration_austtime_In_DurationForm"><%= auctionNLS.get("AuctionStartTime") %></LABEL>
                </TD>
                <TD id="WC_W_AuctionDuration_TableCell_14"> 
			<INPUT TYPE="text" NAME="austtime" SIZE=5  MAXLENGTH=5 VALUE=" " id="WC_W_AuctionDuration_austtime_In_DurationForm">
			<% if ( tmflag.equals("1") ) { %>    
				<LABEL for="WC_W_AuctionDuration_austAMPM_In_DurationForm"></LABEL> 		      
				<SELECT Name="austAMPM" id="WC_W_AuctionDuration_austAMPM_In_DurationForm">
				<OPTION VALUE="AM" SELECTED>AM
				<OPTION VALUE="PM">PM
				</SELECT>
			<%  } %>
                </TD>
         </TR>  
         <TR>
		<TD  width=125 id="WC_W_AuctionDuration_TableCell_15"> 
			<%= auctionNLS.get("AuctionEndDate") %>
		</TD>
		<TD width=25 id="WC_W_AuctionDuration_TableCell_16"> 
			<LABEL for="WC_W_AuctionDuration_year2_In_DurationForm"></LABEL><INPUT TYPE=TEXT VALUE="" NAME=YEAR2 SIZE=4 MAXLENGTH=4 id="WC_W_AuctionDuration_year2_In_DurationForm">
		</TD>
		<TD width=25 id="WC_W_AuctionDuration_TableCell_17"> 
			<LABEL for="WC_W_AuctionDuration_month2_In_DurationForm"></LABEL><INPUT TYPE=TEXT VALUE="" NAME=MONTH2 SIZE=2 MAXLENGTH=2 id="WC_W_AuctionDuration_month2_In_DurationForm">
		</TD>
		<TD width=25 id="WC_W_AuctionDuration_TableCell_18"> 	
			<LABEL for="WC_W_AuctionDuration_day2_In_DurationForm"></LABEL><INPUT TYPE=TEXT VALUE="" NAME=DAY2 SIZE=2 MAXLENGTH=2 id="WC_W_AuctionDuration_day2_In_DurationForm">
		</TD>
		<TD width=25 id="WC_W_AuctionDuration_TableCell_19"> 
               <%--//<A HREF="#" onClick="javascript:setupDate2();showCalendar(document.DurationForm.calImg2)">--%>
		<A HREF="javascript:setupDate2();showCalendar(document.DurationForm.calImg2)">
                  <IMG SRC="/wcs/images/tools/calendar/calendar.gif" BORDER=0 id=calImg2 
                    alt="<%= auctionNLS.get("calendarImgAlt") %>">
               </A>
		</TD>
		
		<TD width=100 id="WC_W_AuctionDuration_TableCell_20"> 
			<LABEL for="WC_W_AuctionDuration_auendtim_In_DurationForm"><%= auctionNLS.get("AuctionEndTime") %></LABEL>
		</TD>
		<TD> 
			<INPUT TYPE="text" NAME="auendtim" SIZE=5  MAXLENGTH=5 VALUE=" " id="WC_W_AuctionDuration_auendtim_In_DurationForm">
			<% if ( tmflag.equals("1") ) { %>     		     
			 	<LABEL for="WC_W_AuctionDuration_auendAMPM_In_DurationForm"></LABEL>
                       		<SELECT Name="auendAMPM" id="WC_W_AuctionDuration_auendAMPM_In_DurationForm">
		         	<OPTION VALUE="AM" SELECTED>AM
		         	<OPTION VALUE="PM">PM
                       		</SELECT>
                     	<%  } %>
		</TD>
         </TR>  
</TABLE>         
<TABLE id="WC_W_AuctionDuration_Table_2">         
<%	if ( !autype.equals("D") )  { %>
   	<TR>
		<TD ALIGN=CENTER id="WC_W_AuctionDuration_TableCell_21">
     <%	if ( auruletype.equals("4") )  { %>
		
		<B><INPUT TYPE="radio" NAME="AndOr" VALUE="Or" id="WC_W_AuctionDuration_r1_In_DurationForm"><LABEL for="WC_W_AuctionDuration_r1_In_DurationForm"><%= auctionNLS.get("Or") %></LABEL>
		<INPUT TYPE="radio" NAME="AndOr" VALUE="And" checked id="WC_W_AuctionDuration_r2_In_DurationForm" ><LABEL for="WC_W_AuctionDuration_r2_In_DurationForm"><%= auctionNLS.get("And") %></LABEL></B> 
     <%	} else { %>  
		<B><INPUT TYPE="radio" NAME="AndOr" VALUE="Or" checked id="WC_W_AuctionDuration_r3_In_DurationForm"><LABEL for="WC_W_AuctionDuration_r3_In_DurationForm"><%= auctionNLS.get("Or") %> </LABEL>
		<INPUT TYPE="radio" NAME="AndOr" VALUE="And" id="WC_W_AuctionDuration_r4_In_DurationForm"><LABEL for="WC_W_AuctionDuration_r4_In_DurationForm"><%= auctionNLS.get("And") %> </LABEL></B> 
     <% } %>	
		</TD>
   	</TR>
   	<TR>
		<TD id="WC_W_AuctionDuration_TableCell_22">
		<%= auctionNLS.get("StyleDurationPrefix") %> 
		<INPUT TYPE="text" NAME="audaydur" SIZE ="5" 
		      MAXLENGTH="5" VALUE="" id="WC_W_AuctionDuration_audaydur_In_DurationForm"> <LABEL for="WC_W_AuctionDuration_audaydur_In_DurationForm"><%= auctionNLS.get("days") %> </LABEL>
		
		
		<INPUT TYPE="text" NAME="auhourdur" SIZE ="2" 
		      MAXLENGTH="2" VALUE="" id="WC_W_AuctionDuration_auhourdur_In_DurationForm"> <LABEL for="WC_W_AuctionDuration_auhourdur_In_DurationForm"><%= auctionNLS.get("hours") %> </LABEL>
		
		<INPUT TYPE="text" NAME="aumindur" SIZE ="2" 
		      MAXLENGTH="2" VALUE="" id="WC_W_AuctionDuration_aumindur_In_DurationForm"> <LABEL for="WC_W_AuctionDuration_aumindur_In_DurationForm"><%= auctionNLS.get("minutes") %> </LABEL>
		<%= auctionNLS.get("StyleDurationSuffix") %>
		</TD>
   	</TR>
   	<tr><td></td></tr>
   	<tr><td></td></tr>
 <% } %>	
  
</TABLE>
<TABLE id="WC_W_AuctionDuration_Table_3">
   	<tr><td></td></tr>
   	<tr><td></td></tr>
</TABLE>

   <BR><%= auctionNLS.get("TimeFormat") %> 	
   <BR><%= auctionNLS.get("ClickFinish") %> 	

<SCRIPT LANGUAGE="JavaScript">

var locale = "<%= UIUtil.toJavaScript(locale) %>"; 
var lang; 
var aRuletype = "";
var i = 0;
var aDefault = null;
var temp;
var temp1;
var temp2;

var msgInvalidStDate	   ="<%= UIUtil.toJavaScript( (String)auctionNLS.get("msgInvalidStDate")) %>";
var msgInvalidEndDate	   ="<%= UIUtil.toJavaScript( (String)auctionNLS.get("msgInvalidEndDate")) %>";
var msgInvalidHour         ="<%= UIUtil.toJavaScript( (String)auctionNLS.get("msgInvalidHour")) %>";
var msgInvalidMinute       ="<%= UIUtil.toJavaScript( (String)auctionNLS.get("msgInvalidMinute")) %>";
var msgInvalidTime         = "<%= UIUtil.toJavaScript( (String)auctionNLS.get("msgInvalidTime")) %>";
var msgInvalidDurationDay  = "<%= UIUtil.toJavaScript( (String)auctionNLS.get("msgInvalidDurationDay")) %>";
var msgInvalidDurationTime = "<%= UIUtil.toJavaScript( (String)auctionNLS.get("msgInvalidDurationTime")) %>";

var msgDateAndTimeTogetherMandatory   = "<%= UIUtil.toJavaScript( (String)auctionNLS.get("msgDateAndTimeTogetherMandatory")) %>";
var msgDateAndTimeTogether            = "<%= UIUtil.toJavaScript( (String)auctionNLS.get("msgDateAndTimeTogether")) %>";
var msgDutchEndDate                   = "<%= UIUtil.toJavaScript( (String)auctionNLS.get("msgDutchEndDate")) %>";
var msgStartEndCompare                = "<%= UIUtil.toJavaScript( (String)auctionNLS.get("msgStartEndCompare")) %>";
var msgWrongStartDate                 = "<%= UIUtil.toJavaScript( (String)auctionNLS.get("msgWrongStartDate")) %>";
var msgWrongEndDate                   = "<%= UIUtil.toJavaScript( (String)auctionNLS.get("msgWrongEndDate")) %>";
var msgCurrentEndCompare              = "<%= UIUtil.toJavaScript( (String)auctionNLS.get("msgCurrentEndCompare")) %>";
var msgMissingAuctionEndCriterion     = "<%= UIUtil.toJavaScript( (String)auctionNLS.get("msgMissingAuctionEndCriterion")) %>";
var msgMissingBothAuctionEndCriterion = "<%= UIUtil.toJavaScript( (String)auctionNLS.get("msgMissingBothAuctionEndCriterion")) %>";
var msgConvertTimeNotes				  = "<%= UIUtil.toJavaScript( (String)auctionNLS.get("ConvertTimeNotes")) %>"	;
var msgConvertInputTimeToServer		  = "<%= UIUtil.toJavaScript( (String)auctionNLS.get("msgConvertInputTimeToServer")) %>"	;
var convertValue=0;

function initializeState()
{

  // Get panel data from model  
  lang = parent.get(auctLang, "-1");
  
  document.DurationForm.YEAR1.value  = "";   
  document.DurationForm.MONTH1.value = "";   
  document.DurationForm.DAY1.value   = "";   
  document.DurationForm.YEAR2.value   = "";   
  document.DurationForm.MONTH2.value  = "";   
  document.DurationForm.DAY2.value    = "";   
  document.DurationForm.austtime.value = "";   
  document.DurationForm.auendtim.value = "";   
 
  if ( parent.get(auctStYear_ds, aDefault) != null ) {
    document.DurationForm.YEAR1.value  = parent.get(auctStYear_ds, "");   
    document.DurationForm.MONTH1.value = parent.get(auctStMonth_ds, "");   
    document.DurationForm.DAY1.value   = parent.get(auctStDay_ds, "");   
    document.DurationForm.austtime.value = parent.get(auctStTime_ds, "");   
  }
  
  if ( parent.get(auctEndYear_ds, aDefault) != null ) {
    document.DurationForm.YEAR2.value   = parent.get(auctEndYear_ds, "");   
    document.DurationForm.MONTH2.value  = parent.get(auctEndMonth_ds, "");   
    document.DurationForm.DAY2.value    = parent.get(auctEndDay_ds, "");   
    document.DurationForm.auendtim.value = parent.get(auctEndTime_ds, "");   
  }
  
  
  if ( "<%= UIUtil.toJavaScript(autype) %>" != "D" ) {
    document.DurationForm.audaydur.value  = parent.get(auctDayDur, "");   
    document.DurationForm.auhourdur.value = parent.get(auctHourDur, "");   
    document.DurationForm.aumindur.value  = parent.get(auctMinDur, "");   

  }

  if ("<%= UIUtil.toJavaScript(tmflag) %>" == "1" ) {
    var sttemp  = parent.get(auctStAMPM, aDefault);   
    var endtemp = parent.get(auctEndAMPM, aDefault);   
    if (sttemp == "PM")
      document.DurationForm.austAMPM.selectedIndex = 1;
    else
      document.DurationForm.austAMPM.selectedIndex = 0;
    if ( endtemp == "PM")
      document.DurationForm.auendAMPM.selectedIndex = 1;
    else
      document.DurationForm.auendAMPM.selectedIndex = 0;
  }
   
  document.DurationForm.YEAR1.focus();   

  parent.setContentFrameLoaded(true);
  
  
  //get clinet offset
  dat=new Date();
  var clientOffset=dat.getTimezoneOffset()*(60*1000);

  convertValue=clientOffset-'<%=serverOffset%>';
  if(convertValue!=0){
  	var table=document.getElementById("WC_W_AuctionDuration_Table_3");
	table.rows[0].cells[0].innerHTML=msgConvertTimeNotes;
  	table.rows[1].cells[0].innerHTML="<input type=\"checkbox\" name=\"timeConvertCheckBox\" value=\"On\" id=\"timeConvertCheckBox\"><label for=\"timeConvertCheckBox\">" + msgConvertInputTimeToServer + "</label>";
  }
}

function savePanelData() {

  var form = document.DurationForm;
  // Save panel data in model
  parent.put(auctStYear_ds,  document.DurationForm.YEAR1.value);   
  parent.put(auctStMonth_ds, document.DurationForm.MONTH1.value);   
  parent.put(auctStDay_ds,   document.DurationForm.DAY1.value);   
  parent.put(auctStTime_ds, document.DurationForm.austtime.value);   
  parent.put(auctEndYear_ds,  document.DurationForm.YEAR2.value);  
  parent.put(auctEndMonth_ds, document.DurationForm.MONTH2.value);  
  parent.put(auctEndDay_ds,   document.DurationForm.DAY2.value);  
  parent.put(auctEndTime_ds, document.DurationForm.auendtim.value);  
  parent.put(auctStDate, "" );
  parent.put(auctEndDate, "" );
  parent.put(auctStTime, "" );   
  parent.put(auctEndTime, "" ); 
  if(convertValue!=0){  
  	parent.put("convertTime",document.DurationForm.timeConvertCheckBox.checked);
  	parent.put("convertValue", convertValue);
  }
  if(    !isInputStringEmpty(form.YEAR1.value)
      && !isInputStringEmpty(form.MONTH1.value)
      && !isInputStringEmpty(form.DAY1.value) ) 
    parent.put(auctStDate, formatDate(form.YEAR1.value,form.MONTH1.value, form.DAY1.value) );
  if(    !isInputStringEmpty(form.YEAR2.value)
      && !isInputStringEmpty(form.MONTH2.value)
      && !isInputStringEmpty(form.DAY2.value) ) 
    parent.put(auctEndDate, formatDate(form.YEAR2.value,form.MONTH2.value, form.DAY2.value) );  
  

  if ("<%= UIUtil.toJavaScript(tmflag) %>" == "1" ) {
      temp1 = document.DurationForm.austAMPM.options[document.DurationForm.austAMPM.selectedIndex].value; 
      parent.put(auctStAMPM,  temp1);   
      temp2 = document.DurationForm.auendAMPM.options[document.DurationForm.auendAMPM.selectedIndex].value; 
      parent.put(auctEndAMPM, temp2);   

      if( !isInputStringEmpty(document.DurationForm.austtime.value) ) {
        temp = document.DurationForm.austtime.value + " " + temp1;    
        parent.put(auctStTime, convertTime(temp) );   
      }

      if( !isInputStringEmpty(document.DurationForm.auendtim.value) ) {
        temp = document.DurationForm.auendtim.value + " " + temp2;    
        parent.put(auctEndTime, convertTime(temp) );  
      }
 
  } 
  else {
      if( !isInputStringEmpty(document.DurationForm.austtime.value) )  {
        temp = document.DurationForm.austtime.value + ":00";
        parent.put(auctStTime, temp );
      }  
           
      if( !isInputStringEmpty(document.DurationForm.auendtim.value) ) { 
	temp = document.DurationForm.auendtim.value + ":00";
        parent.put(auctEndTime, temp ); 
      }   
  
  } 
  if ("<%= UIUtil.toJavaScript(autype) %>" != "D") {
    parent.put(auctDayDur, document.DurationForm.audaydur.value);   
    parent.put(auctHourDur, document.DurationForm.auhourdur.value);   
    parent.put(auctMinDur, document.DurationForm.aumindur.value);   
    temp = formatDuration(document.DurationForm);
    parent.put(auctTimDur, temp);   
  }
  else {
    parent.put(auctDayDur, "");   
    parent.put(auctTimDur, "");   
    parent.put(auctHourDur, "");   
    parent.put(auctMinDur, "");   

  }

  parent.addURLParameter("authToken", "${authToken}");
}

function validatePanelData() {
  
  var form     = document.DurationForm;
  var styear   = form.YEAR1.value;
  var stmonth  = form.MONTH1.value;
  var stday    = form.DAY1.value;
  var stdate   = " ";
  var endyear   = form.YEAR2.value;
  var endmonth  = form.MONTH2.value;
  var endday    = form.DAY2.value;
  var enddat   = " ";
  var sttim    = form.austtime.value;
  var endtim   = form.auendtim.value;
  var temp;
  var today;
  var t_year;
  var t_month;
  var t_day; 
  var t_hour;
  var t_minute;
  var t_second;
   
  aRuletype = "<%= UIUtil.toJavaScript(auruletype) %>";

  //Validate Start date
  if ( !isInputStringEmpty(styear) || !isInputStringEmpty(stmonth) || !isInputStringEmpty(stday) ) {
      if ( !validDate(styear, stmonth, stday) ) {
	 reprompt(form.YEAR1, msgInvalidStDate);
         return false;
      }   
  }    

  //Validate End date
  if ( !isInputStringEmpty(endyear) || !isInputStringEmpty(endmonth) || !isInputStringEmpty(endday) ) {
      if ( !validDate(endyear, endmonth, endday) ) {
	 reprompt(form.YEAR2, msgInvalidEndDate);
         return false;
      }   
  }    

  //format dates for additional validation usage 
  if (!isInputStringEmpty(styear) && !isInputStringEmpty(stmonth) && !isInputStringEmpty(stday) )
     stdate = getDateFormat( styear, stmonth, stday, locale);
  if ( !isInputStringEmpty(endyear) && !isInputStringEmpty(endmonth) && !isInputStringEmpty(endday) ) 
     enddat = getDateFormat( endyear, endmonth, endday, locale);

  //Validate Start time either in 12 or 24 hour format
  if ("<%= UIUtil.toJavaScript(tmflag) %>" == "1" ) {
    temp = document.DurationForm.austAMPM.options[document.DurationForm.austAMPM.selectedIndex].value; 
    temp2 = sttim + " " + temp; 
    this.inTime = temp2;
    if (!isInputStringEmpty(sttim)){
  	if ( !validateTime(inTime) || validateTime(inTime)  == "false") {
  	    reprompt(form.austtime, msgInvalidTime);
  	    return false;
  	}    
    }
  }  
  else {  
     if (!isInputStringEmpty(sttim)){
  	if ( !validTime(sttim)) {
    	    reprompt(form.austtime, msgInvalidTime);
    	    return false;
    	}    
     }
  }

  //Validate End time either in 12 or 24 hour format
  if ("<%= UIUtil.toJavaScript(tmflag) %>" == "1" ) {
    temp = document.DurationForm.auendAMPM.options[document.DurationForm.auendAMPM.selectedIndex].value; 
    temp2 = endtim + " " + temp; 
    this.inTime = temp2;
    if (!isInputStringEmpty(endtim)){
	if ( !validateTime(inTime) || validateTime(inTime)  == "false") {
	    reprompt(form.auendtim, msgInvalidTime);
	    return false;
	}    
    }
  }  
  else {  
     if (!isInputStringEmpty(endtim)){
  	if ( !validTime(endtim)) {
    	    reprompt(form.auendtim, msgInvalidTime);
    	    return false;
    	}    
     }
  }

    today = new Date();
    t_year = today.getFullYear();
    t_month = today.getMonth() + 1;
    t_day  = today.getDate();
    t_hour = today.getHours();
    t_minute = today.getMinutes();
    t_second  = today.getSeconds();
    
    var now = getDateFormat( t_year, t_month, t_day, locale);

  //If start date is not blank, then it must be  >= current date
    if( !isInputStringEmpty(stdate) )
    {
       this.inDate = stdate;
       if ( isDateOrdered(now, inDate, locale) == "0" ) {
   	  reprompt(form.YEAR1, msgStartEndCompare);
	  return false;  
       }
     }

  //If end date is not blank, then it must be  >= current date
    if( !isInputStringEmpty(enddat) )
    {
     
       this.inDate = enddat;
       if ( isDateOrdered(now, inDate, locale) == "0" ) {
   	  reprompt(form.YEAR2, msgCurrentEndCompare);
	  return false;  
       }
     }

  //Check that enddate is >= start date
    this.inDate = stdate;
    temp = enddat; 
    if (!isInputStringEmpty(stdate) && !isInputStringEmpty(enddat) ) {
       if (isDateOrdered(inDate, temp, locale) == "0") {
           reprompt(form.YEAR1, msgWrongStartDate);
           return false; 
       }    
    }
  //Check that Start Date and time must be entered together as a pair 
  if ((!isInputStringEmpty(stdate) && isInputStringEmpty(sttim)) || (isInputStringEmpty(stdate) && !isInputStringEmpty(sttim)) ){

        if ( isInputStringEmpty(stdate) ) {
	   reprompt(form.YEAR1, msgDateAndTimeTogether);
	   return false;
	}
	if ( isInputStringEmpty(sttim) ) {    
	   reprompt(form.austtime, msgDateAndTimeTogether);
	   return false;
	}

  }

  //Check that End Date and time must be entered together as a pair 
  if ((!isInputStringEmpty(enddat) && isInputStringEmpty(endtim)) || (isInputStringEmpty(enddat) && !isInputStringEmpty(endtim))) {

        if ( isInputStringEmpty(enddat) ) {
	   reprompt(form.YEAR2, msgDateAndTimeTogether);
	   return false;
	}   
	if ( isInputStringEmpty(endtim) ) {    
	   reprompt(form.auendtim, msgDateAndTimeTogether);
	   return false;
	}

  }

 
  //Check that if start date and end date are not blanks, and start date equals end date,
  //           then end time is > start time

if (!isInputStringEmpty(stdate) && !isInputStringEmpty(enddat) ) {

  if (    styear == endyear  && stmonth == endmonth && stday == endday ) {

    if ("<%= UIUtil.toJavaScript(tmflag) %>" == "1" ) {
       temp = document.DurationForm.austAMPM.options[document.DurationForm.austAMPM.selectedIndex].value; 
       temp1 = sttim + " " + temp; 
       temp = document.DurationForm.auendAMPM.options[document.DurationForm.auendAMPM.selectedIndex].value; 
       temp2 = endtim + " " + temp; 
       if ( isTimeOrdered(temp1, temp2) == "false") {
          reprompt(form.austtime, msgWrongStartDate);
         return false ; 
       }
    }
    else {
      //check 24 hour clock
       if ( is24HourTimeOrdered(sttim, endtim) == "false") {
          reprompt(form.austtime, msgWrongStartDate);
         return false ; 
       }
       else if ( is24HourTimeOrdered(sttim, endtim) == "false1") {
              reprompt(form.austtime, msgWrongEndDate);
             return false ; 
            }

    }          
  }
}

//Check that if start date equals current date, then start time is > current time
    today = new Date();
    t_year = today.getFullYear();
    t_month = today.getMonth() + 1;
    t_day  = today.getDate();
    t_hour = today.getHours();
    t_minute = today.getMinutes();
    t_second  = today.getSeconds();

  if ("<%= UIUtil.toJavaScript(tmflag) %>" == "1" ) {
    temp = document.DurationForm.austAMPM.options[document.DurationForm.austAMPM.selectedIndex].value; 
    temp2 = sttim + " " + temp; 
    if (    styear == t_year && stmonth == t_month  && stday == t_day ) {
       
       if ( parseInt(t_hour) > parseInt(getHour(temp2)) ) {
          reprompt(form.austtime, msgStartEndCompare);
          return false ; 
       }
       else
         if (  parseInt(t_hour) == parseInt(getHour(temp2)) 
            && parseInt(t_minute) > parseInt(getMinutes(temp2)) ) {
              reprompt(form.austtime, msgStartEndCompare);
              return false ; 
         }
         //else
         //   if (  parseInt(t_hour) == parseInt(getHour(temp2)) 
         //      && parseInt(t_minute) == parseInt(getMinutes(temp2))
         //      && parseInt(t_second) > parseInt(getSeconds(temp2)) ) {
         //     reprompt(form.austtime, msgStartEndCompare);
         //    return false ; 
         //   } 
         
    }
  }
  else {
   //check 24 hour time compare if start date equals current date, then start time is > current time  
    if (    styear == t_year && stmonth == t_month  && stday == t_day ) {
        temp1 = t_hour + ":" + t_minute; 
        if ( is24HourTimeOrdered(temp1, sttim) == "false") {
           reprompt(form.austtime, msgStartEndCompare);
           return false ; 
         }
    } 
  }
  
//Check if end date exists and end date is equal to current date, then end time is > current time
if (!isInputStringEmpty(enddat) ) {
  if ("<%= UIUtil.toJavaScript(tmflag) %>" == "1" ) {
     //*** same logic as start time/current time compare check if we implement am/pm indicator
  }
  else {
   //check 24 hour time compare if end date equals current date, then end time is > current time  
    if (    endyear == t_year && endmonth == t_month  && endday == t_day ) {
        temp1 = t_hour + ":" + t_minute; 
        if ( is24HourTimeOrdered(temp1, endtim) == "false") {
           reprompt(form.auendtim, msgCurrentEndCompare);
           return false ; 
        }
    } 
  }

}

  if ( "<%= UIUtil.toJavaScript(autype) %>" != "D") {
    var durday   = form.audaydur.value; 
    var durhour  = form.auhourdur.value;
    var durmin   = form.aumindur.value;
   
    //Validate Duration Day
    if (!isInputStringEmpty(durday)){
        if ( !isValidInteger(durday, lang) ) {
  	   reprompt(form.audaydur, msgInvalidDurationDay);
  	   return false;
        }
      temp = strToNumber(document.DurationForm.audaydur.value, lang);  
      parent.put(auctDayDur, temp);   
   
     }  
 

    //Validate duration hours. Allows 24 hour format  
    if (!isInputStringEmpty(durhour)){
          if ( !isValidInteger(durhour, lang) ) {
  	   reprompt(form.auhourdur, msgInvalidHour);
  	   return false;
        }
        if ( parseInt(durhour) < 0 || parseInt(durhour) > 23) { 
	    reprompt(form.auhourdur, msgInvalidHour);
	    return false;
	}    

     }  

      
    //Validate duration minutes.   
    if (!isInputStringEmpty(durmin)){
       if ( !isValidInteger(durmin, lang) ) {
  	   reprompt(form.aumindur, msgInvalidMinute);
  	   return false;
        }
        if ( parseInt(durmin) < 0 || parseInt(durmin) > 59) { 
	    reprompt(form.aumindur, msgInvalidMinute);
	    return false;
	}    

     }  



    // Check that at least fixed time  or duration is specified
    if (    isInputStringEmpty(form.YEAR2.value) 
         && isInputStringEmpty(form.MONTH2.value)
         && isInputStringEmpty(form.DAY2.value)
         && isInputStringEmpty(form.audaydur.value)
         && isInputStringEmpty(form.auhourdur.value) 
         && isInputStringEmpty(form.aumindur.value) ){
        reprompt(form.YEAR2, msgMissingAuctionEndCriterion);
        return false;
    }   

    // Check that  fixed time and duration is specified when user selects AND option
    if ( "<%= UIUtil.toJavaScript(autype) %>" != "D" &&
	( (isInputStringEmpty(form.YEAR2.value)  && isInputStringEmpty(form.MONTH2.value) && isInputStringEmpty(form.DAY2.value))
         ||
	  ( isInputStringEmpty(form.audaydur.value)  && isInputStringEmpty(form.auhourdur.value) && isInputStringEmpty(form.aumindur.value)) )
	&&  (form.AndOr[1].checked == true))
    {
       if  (    isInputStringEmpty(form.YEAR2.value) 
	     && isInputStringEmpty(form.MONTH2.value) && isInputStringEmpty(form.DAY2.value) ) {
          reprompt(form.YEAR2, msgMissingBothAuctionEndCriterion);
          return false;
       }
       else {
          reprompt(form.audaydur, msgMissingBothAuctionEndCriterion);
          return false;
       }   
    }  

  }



  //Check that End Date and time is entered for Dutch
  if ("<%= UIUtil.toJavaScript(autype) %>" == "D" 
      && isInputStringEmpty(form.YEAR2.value)
      && isInputStringEmpty(form.MONTH2.value)
      && isInputStringEmpty(form.DAY2.value)   ){
	reprompt(form.YEAR2, msgDutchEndDate);
	return false;
  }

  // Assing auruletype
  if ( "<%= UIUtil.toJavaScript(autype) %>" == "D" )
      aRuletype = 1;
  else {
       if ( !isInputStringEmpty(enddat) && !isInputStringEmpty(form.auendtim.value) 
         && (!isInputStringEmpty(form.audaydur.value) || !isInputStringEmpty(form.auhourdur.value) || !isInputStringEmpty(form.aumindur.value))
         && (form.AndOr[1].checked == true) ) 
       {
          aRuletype = 4;
       }
       if ( !isInputStringEmpty(enddat) && !isInputStringEmpty(form.auendtim.value)
         && (!isInputStringEmpty(form.audaydur.value) || !isInputStringEmpty(form.auhourdur.value) || !isInputStringEmpty(form.aumindur.value))
         && (form.AndOr[0].checked == true) ) 
       {
          aRuletype = 3;
       }
       if ( isInputStringEmpty(enddat) && isInputStringEmpty(form.auendtim.value)  &&
          (!isInputStringEmpty(form.audaydur.value) || !isInputStringEmpty(form.auhourdur.value) || !isInputStringEmpty(form.aumindur.value) ) ) 
       {
          aRuletype = 2;
       }

       if ( !isInputStringEmpty(enddat) && !isInputStringEmpty(form.auendtim.value)  &&
            isInputStringEmpty(form.audaydur.value) && isInputStringEmpty(form.auhourdur.value) && isInputStringEmpty(form.aumindur.value)) 
       {
          aRuletype = 1;
       }
    
    }  
    parent.put(auctRuleType, aRuletype );  

    //requiredFieldsCheck();
    
    return true;
}  


//////////////////////////////////////////////////////////
// Convert Date to the format acceptable by the CreateAuction Command 
//  input format :  year, month, day 
//  output format : yyyy-mm-dd 
//////////////////////////////////////////////////////////
function formatDate(aYear, aMonth, aDay) {
   
   return aYear + "-" + aMonth + "-" + aDay; 
}
//////////////////////////////////////////////////////////
// Convert Time to the format acceptable by the CreateAuction Command 
//  input format : hh:mm:ss AM  
//  output format : hh:mm:ss in 24 hour clock 
//////////////////////////////////////////////////////////
function convertTime(aTime) {
   var aHH  = getHour(aTime);
   var aMin = getMinutes(aTime);
   //var aSS  = getSeconds(aTime);
   var aSS  = "00";
   
   return aHH + ":" + aMin + ":" + aSS; 
}

//////////////////////////////////////////////////////////
//  Format duration hour, minute to the format acceptable by the CreateAuction Command 
//////////////////////////////////////////////////////////
function formatDuration(form) {
   var hour = "00";
   var min  = "00";
   var sec  = "00";
   var delimiter = ":";

   if ( !isInputStringEmpty(form.auhourdur.value) ) {   
     hour = form.auhourdur.value;
     if ( parseInt(hour) == 0 || parseInt(hour) < 10 )
       hour = "0" + hour;
   }

   if ( !isInputStringEmpty(form.aumindur.value) ) {   
     min = form.aumindur.value; 
     if ( parseInt(min) == 0 || parseInt(min) < 10 )
       min = "0" + min;
   }

   
   return hour + delimiter + min + delimiter + sec;     
   
}

function setupDate1(){
      window.yearField = document.DurationForm.YEAR1;
      window.monthField = document.DurationForm.MONTH1;
      window.dayField = document.DurationForm.DAY1;
}

function setupDate2(){
      window.yearField = document.DurationForm.YEAR2;
      window.monthField = document.DurationForm.MONTH2;
      window.dayField = document.DurationForm.DAY2;
}

</SCRIPT>
</FORM>
</BODY>
</HTML>
