
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
<%@  page import="java.util.*"  %>
<%@  page import="java.text.*"  %>
<%@  page import="com.ibm.commerce.tools.test.*" %>
<%@  page import="com.ibm.commerce.tools.util.*" %>
<%@  page import="com.ibm.commerce.command.*" %>
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
//	String emptyString = new String("");
//	String temptime = "";
//	String locale =       request.getParameter("locale");
	String autype =       request.getParameter("autype");
	String auruletype =   request.getParameter("auruletype");
	String tmflag =       request.getParameter("tmflag");
	
	String austdate     =  request.getParameter("austdate");
//	String austyear_ds  =  request.getParameter("austyear_ds");
//	String austmonth_ds = request.getParameter("austmonth_ds");
//	String austday_ds   =   request.getParameter("austday_ds");
	String austtim_ds   =   request.getParameter("austtim_ds");
	
//	String auendyear_ds =  request.getParameter("auendyear_ds");
//	String auendmonth_ds =  request.getParameter("auendmonth_ds");
//	String auendday_ds =  request.getParameter("auendday_ds");
//	String auendtim_ds =  request.getParameter("auendtim_ds");
	
//	String austAMPM =     request.getParameter("austAMPM");
//	String auendAMPM =    request.getParameter("auendAMPM");
//	String audaydur =     request.getParameter("audaydur");
//	String auhourdur =     request.getParameter("auhourdur");
//	String aumindur =     request.getParameter("aumindur");
	
	String editable =  request.getParameter("editable");
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "DTD/xhtml1-transitional.dtd" >

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2006, 2013 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<HTML lang="en">
<HEAD>
<link rel=stylesheet href="<%= UIUtil.getCSSFile(aLocale) %>" type="text/css">
<SCRIPT SRC="/wcs/javascript/tools/common/DateUtil.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/negotiations/auc_common.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/negotiations/auc_datetime.js"></SCRIPT>

<SCRIPT>
var aRuletype = "";
var i = 0;
var aDefault = null;
var temp;
var temp1;
var temp2;

var  locale = parent.get(auctLocale, "en_US");  
var  lang   = parent.get(auctLang, "1");
var  autype = parent.get(auctType, aDefault);  
var  tmflag = parent.get(auctTimeFlag, "0");
var  auruletype = parent.get(auctRuleType, aDefault);
var  editable =  parent.get(auctEditable, "false");
  
var or_checked;
var and_checked;

var msgInvalidStDate	   ="<%= UIUtil.toJavaScript( (String)auctionNLS.get("msgInvalidStDate")) %>";
var msgInvalidEndDate	   ="<%= UIUtil.toJavaScript( (String)auctionNLS.get("msgInvalidEndDate")) %>";

var msgInvalidHour         ="<%= UIUtil.toJavaScript( (String)auctionNLS.get("msgInvalidHour")) %>";
var msgInvalidMinute       ="<%= UIUtil.toJavaScript( (String)auctionNLS.get("msgInvalidMinute")) %>";
var msgInvalidDate         ="<%= UIUtil.toJavaScript( (String)auctionNLS.get("msgInvalidDate")) %>";
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
var msgConvertInputTimeToServer		  = "<%= UIUtil.toJavaScript( (String)auctionNLS.get("msgConvertInputTimeToServer")) %>" ;
var convertValue=0;
function initializeState()
{

  // Get panel data from model  
    if ( "<%= UIUtil.toJavaScript(editable) %>" == "false") {
     document.DurationForm.YEAR2.value = parent.get(auctEndYear_ds, aDefault);   
     document.DurationForm.MONTH2.value = parent.get(auctEndMonth_ds, aDefault);   
     document.DurationForm.DAY2.value = parent.get(auctEndDay_ds, aDefault);   
     document.DurationForm.auendtim.value = parent.get(auctEndTime_ds, aDefault);   
     document.DurationForm.YEAR2.focus();

    }
    else {
     document.DurationForm.YEAR1.value  = parent.get(auctStYear_ds, aDefault);   
     document.DurationForm.MONTH1.value = parent.get(auctStMonth_ds, aDefault);   
     document.DurationForm.DAY1.value   = parent.get(auctStDay_ds, aDefault);   
     document.DurationForm.austtime.value = parent.get(auctStTime_ds, aDefault);   
     document.DurationForm.YEAR2.value  = parent.get(auctEndYear_ds, aDefault);   
     document.DurationForm.MONTH2.value = parent.get(auctEndMonth_ds, aDefault);   
     document.DurationForm.DAY2.value   = parent.get(auctEndDay_ds, aDefault);   
     document.DurationForm.auendtim.value = parent.get(auctEndTime_ds, aDefault);   
     document.DurationForm.YEAR1.focus();

    }
     
     if ( autype != "D" ) {
        if ( parent.get(auctAndChecked, "") == "true")
           document.DurationForm.AndOr[1].checked = true;
        else    
           document.DurationForm.AndOr[0].checked = true;
       document.DurationForm.audaydur.value = parent.get(auctDayDur, aDefault);   
       document.DurationForm.auhourdur.value = parent.get(auctHourDur, aDefault);   
       document.DurationForm.aumindur.value  = parent.get(auctMinDur, aDefault);   
     }
     
     if ("<%= UIUtil.toJavaScript(tmflag) %>" == "1" ) {
        if (parent.get(auctStAMPM) == "PM")
          document.DurationForm.austAMPM.selectedIndex = 1;
        else
          document.DurationForm.austAMPM.selectedIndex = 0;
        if ( parent.get(auctEndAMPM) == "PM")
          document.DurationForm.auendAMPM.selectedIndex = 1;
        else
          document.DurationForm.auendAMPM.selectedIndex = 0;
     }

  //Check if there is a validation error 
  checkForError(document.DurationForm);
  
  parent.setContentFrameLoaded(true);
  
  //get clinet offset
  dat=new Date();
  var clientOffset=dat.getTimezoneOffset()*(60*1000);
  convertValue=clientOffset-'<%=serverOffset%>';
  if(convertValue!=0){
  	var table=document.getElementById("WC_N_AuctionDuration_Table_3");
  	table.rows[0].cells[0].innerHTML=msgConvertTimeNotes;
  	table.rows[1].cells[0].innerHTML="<input type=\"checkbox\" name=\"timeConvertCheckBox\" value=\"On\" id=\"timeConvertCheckBox\"><label for=\"timeConvertCheckBox\">" + msgConvertInputTimeToServer + "</label>";
  }
 
}

function checkForError(form) {

  var errorCode = parent.getErrorParams();
  
  if ( errorCode == "errStDate" )
       reprompt(form.YEAR1, msgInvalidStDate );
       
  
  if ( errorCode == "errEndDate" )
       reprompt(form.YEAR2, msgInvalidEndDate );
  

  if ( errorCode == "errStTime" )
       reprompt(form.austtime, msgInvalidTime );

  if ( errorCode == "errEndTime" )
       reprompt(form.auendtim, msgInvalidTime );

  if ( errorCode == "errStEndCompare" )
       reprompt(form.YEAR1, msgStartEndCompare );
       
  if ( errorCode == "errCurEndCompare" )
       reprompt(form.YEAR2, msgCurrentEndCompare );

  if ( errorCode == "errCurEndCompare2" )
       reprompt(form.auendtim, msgCurrentEndCompare );
       
  if ( errorCode == "errStWrongDate" )
       reprompt(form.YEAR2, msgWrongStartDate );

  if ( errorCode == "errEndWrongDate" )
       reprompt(form.YEAR2, msgWrongEndDate );
       
  if ( errorCode == "errStDateTime1" )
       reprompt(form.YEAR1, msgDateAndTimeTogether );
  if ( errorCode == "errStDateTime2" )
       reprompt(form.austtime, msgDateAndTimeTogether );
       
  if ( errorCode == "errEndDateTime1" )
       reprompt(form.YEAR2, msgDateAndTimeTogether );
  if ( errorCode == "errEndDateTime2" )
       reprompt(form.auendtim, msgDateAndTimeTogether );
       

  if ( errorCode == "errStTimeEndCompare" )
       reprompt(form.austtime, msgStartEndCompare );

  if ( errorCode == "errDurDay" )
       reprompt(form.audaydur, msgInvalidDurationDay );

  if ( errorCode == "errDurHour" )
       reprompt(form.auhourdur, msgInvalidHour );

  if ( errorCode == "errDurMinute" )
       reprompt(form.aumindur, msgInvalidMinute );

  if ( errorCode == "errEndMissing" )
       reprompt(form.YEAR2, msgMissingAuctionEndCriterion );

  if ( errorCode == "errBothEndMissing" )
       reprompt(form.YEAR2, msgMissingBothAuctionEndCriterion );

  if ( errorCode == "errEndDutchDate" )
       reprompt(form.YEAR2, msgDutchEndDate );

}


function savePanelData() {

  var form = document.DurationForm;
  if ( "<%= UIUtil.toJavaScript(editable) %>" == "false") {
    parent.put(auctEndYear_ds, form.YEAR2.value);  
    parent.put(auctEndMonth_ds, form.MONTH2.value);  
    parent.put(auctEndDay_ds, form.DAY2.value);  
    parent.put(auctEndTime_ds, document.DurationForm.auendtim.value);  

    if(   !isInputStringEmpty(form.YEAR2.value)
       && !isInputStringEmpty(form.MONTH2.value) 
       && !isInputStringEmpty(form.DAY2.value) ) 
      parent.put(auctEndDate, formatDate(form.YEAR2.value,form.MONTH2.value,form.DAY2.value) );  
    else 
      parent.put(auctEndDate, " " );

    if ("<%= UIUtil.toJavaScript(tmflag) %>" == "1" ) {
      temp2 = document.DurationForm.auendAMPM.options[document.DurationForm.auendAMPM.selectedIndex].value; 
      parent.put(auctEndAMPM, temp2);   

      if( !isInputStringEmpty(document.DurationForm.auendtim.value) ) {
        temp = document.DurationForm.auendtim.value + " " + temp2;    
        parent.put(auctEndTime, convertTime(temp) );  
      }
 
    } 
    else {
           
      if( !isInputStringEmpty(document.DurationForm.auendtim.value) ) {
	temp = document.DurationForm.auendtim.value + ":00";
        parent.put(auctEndTime, temp );
      }    
    } 

  } 
  else {
    parent.put(auctStYear_ds, form.YEAR1.value);   
    parent.put(auctStMonth_ds, form.MONTH1.value);   
    parent.put(auctStDay_ds, form.DAY1.value);   
    parent.put(auctStTime_ds, document.DurationForm.austtime.value);   
    parent.put(auctEndYear_ds, form.YEAR2.value);   
    parent.put(auctEndMonth_ds, form.MONTH2.value);   
    parent.put(auctEndDay_ds, form.DAY2.value);   
    parent.put(auctEndTime_ds, document.DurationForm.auendtim.value);  

    parent.put(auctStTime, document.DurationForm.austtime.value);   
    parent.put(auctEndTime, document.DurationForm.auendtim.value);
    if(convertValue!=0){  
  		parent.put("convertTime",document.DurationForm.timeConvertCheckBox.checked);
  		parent.put("convertValue", convertValue);
  	}

    if(   !isInputStringEmpty(form.YEAR1.value)
       && !isInputStringEmpty(form.MONTH1.value) 
       && !isInputStringEmpty(form.DAY1.value) ) 
      parent.put(auctStDate, formatDate(form.YEAR1.value,form.MONTH1.value,form.DAY1.value) );
    else
      parent.put(auctStDate, "" );
              
    if(   !isInputStringEmpty(form.YEAR2.value)
       && !isInputStringEmpty(form.MONTH2.value) 
       && !isInputStringEmpty(form.DAY2.value) ) 
      parent.put(auctEndDate, formatDate(form.YEAR2.value,form.MONTH2.value,form.DAY2.value) );  
    else 
      parent.put(auctEndDate, "" );
      
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
      if( !isInputStringEmpty(document.DurationForm.austtime.value) ) { 
        temp = document.DurationForm.austtime.value + ":00";
        parent.put(auctStTime, temp );
      }  
           
      if( !isInputStringEmpty(document.DurationForm.auendtim.value) ) { 
	temp = document.DurationForm.auendtim.value + ":00";
        parent.put(auctEndTime, temp );  
      }  
    } 

  }   // end editable


  if ( autype != "D") {
      parent.put(auctDayDur, document.DurationForm.audaydur.value);   
      parent.put(auctHourDur, document.DurationForm.auhourdur.value);   
      parent.put(auctMinDur, document.DurationForm.aumindur.value);   
      temp = formatDuration(document.DurationForm);
      parent.put(auctTimDur, temp);   
      if( document.DurationForm.AndOr[0].checked == true) {
        parent.put(auctOrChecked, "true");
        parent.put(auctAndChecked, "false");
      }   
      if( document.DurationForm.AndOr[1].checked == true) {
        parent.put(auctOrChecked, "false");
        parent.put(auctAndChecked, "true");
      }
  }
  else {
      parent.put(auctDayDur, "");   
      parent.put(auctTimDur, "");   
      parent.put(auctHourDur, "");   
      parent.put(auctMinDur, "");   
  }


}
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

   //alert("formatDuration returns " + hour + delimiter + min + delimiter + sec);    
   
   return hour + delimiter + min + delimiter + sec;     
   
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
</HEAD>
<BODY class=content ONLOAD="initializeState();">
<SCRIPT FOR=document EVENT="onclick()">
   document.all.CalFrame.style.display="none";
</SCRIPT>
<IFRAME STYLE="display:none;position:absolute;width:198;height:230;z-index=100"
ID="CalFrame" MARGINHEIGHT=0 MARGINWIDTH=0 NORESIZE FRAMEBORDER=0 SCROLLING=NO
SRC="/webapp/wcs/tools/servlet/Calendar" 
title="<%= auctionNLS.get("calendarImgAlt") %>" >
</IFRAME>

<BR><h1><%= auctionNLS.get("AuctDuration") %></h1>

<FORM Name="DurationForm" METHOD="POST" id="DurationForm">

   <TABLE id="WC_N_AuctionDuration_Table_1">

<%   if ( editable.equals("false") ) {
%>
          <TR>
                   <TD width=125 id="WC_N_AuctionDuration_TableCell_1">
                    <%= auctionNLS.get("AuctionStartDate") %> 
                   </TD>
                   <TD colspan=4 id="WC_N_AuctionDuration_TableCell_2"> 
                    <I><%= UIUtil.toHTML(austdate) %></I>
                   </TD>
                   <!--<TD width=100> -->
		   <TD nowrap id="WC_N_AuctionDuration_TableCell_3">
                     <%= auctionNLS.get("AuctionStartTime") %>
                   </TD>
                   <TD id="WC_N_AuctionDuration_TableCell_4"> 
		     <I><%= UIUtil.toHTML(austtim_ds) %>	
                   </TD>
<%                 if ( tmflag.equals("1") ) {
%>
                    <LABEL for="WC_N_AuctionDuration_austAMPM_In_DurationForm"></LABEL>
                    <SELECT Name="austAMPM" id="WC_N_AuctionDuration_austAMPM_In_DurationForm"> 
	             <OPTION VALUE="AM" SELECTED>AM
	             <OPTION VALUE="PM">PM 
	            </SELECT>
<%                } 
%> 
          </TR>

<% }
%> 

<%   if ( editable.equals("true") ) {
%>
	<TR>
		<TD width=125 id="WC_N_AuctionDuration_TableCell_5"> 
			&nbsp;
		</TD>
		<!--<TD width=30> -->
		<TD nowrap id="WC_N_AuctionDuration_TableCell_6">
			<LABEL for="WC_N_AuctionDuration_YEAR1_In_DurationForm"><%= auctionNLS.get("year") %></LABEL>
		</TD>
		<TD nowrap id="WC_N_AuctionDuration_TableCell_7"> 
			<LABEL for="WC_N_AuctionDuration_MONTH1_In_DurationForm"><%= auctionNLS.get("month") %></LABEL>
		</TD>
		<!--<TD width=25> -->
		<TD nowrap id="WC_N_AuctionDuration_TableCell_8">
			<LABEL for="WC_N_AuctionDuration_DAY1_In_DurationForm"><%= auctionNLS.get("day") %></LABEL>
		</TD>
		<TD width=25 id="WC_N_AuctionDuration_TableCell_9">  
			&nbsp;
		</TD>
		<TD width=100 id="WC_N_AuctionDuration_TableCell_10"> 
		&nbsp;
		</TD>
		<TD id="WC_N_AuctionDuration_TableCell_11"> 
		&nbsp;
		</TD>
        </TR>  
        <TR>
            	<TD  width=125 id="WC_N_AuctionDuration_TableCell_12"> 
			<%= auctionNLS.get("AuctionStartDate") %>
	    	</TD>
		<TD width=25 id="WC_N_AuctionDuration_TableCell_13"> 
			<INPUT TYPE=TEXT VALUE="" NAME=YEAR1 SIZE=4 MAXLENGTH=4 id="WC_N_AuctionDuration_YEAR1_In_DurationForm">
		</TD>
		<TD width=25 id="WC_N_AuctionDuration_TableCell_14"> 
			<INPUT TYPE=TEXT VALUE="" NAME=MONTH1 SIZE=2 MAXLENGTH=2 id="WC_N_AuctionDuration_MONTH1_In_DurationForm">
		</TD>
		<TD width=25 id="WC_N_AuctionDuration_TableCell_15"> 
			<INPUT TYPE=TEXT VALUE="" NAME=DAY1 SIZE=2 MAXLENGTH=2 id="WC_N_AuctionDuration_DAY1_In_DurationForm">
		</TD>
		<TD width=25 id="WC_N_AuctionDuration_TableCell_16">  
                 <%--//<A HREF="#" onClick="javascript:setupDate1();showCalendar(document.DurationForm.calImg1)">--%>
		<A HREF="javascript:setupDate1();showCalendar(document.DurationForm.calImg1)">
                    <IMG SRC="/wcs/images/tools/calendar/calendar.gif" BORDER=0 id=calImg1 
                     alt="<%= auctionNLS.get("calendarImgAlt") %>">
                 </A>
		</TD>
                <!--<TD width=100> -->
		<TD nowrap id="WC_N_AuctionDuration_TableCell_17">
			<LABEL for="WC_N_AuctionDuration_austtime_In_DurationForm"><%= auctionNLS.get("AuctionStartTime") %></LABEL>
                </TD>
                <TD> 
			<INPUT TYPE="text" NAME="austtime" SIZE=5  MAXLENGTH=5 VALUE=" " id="WC_N_AuctionDuration_austtime_In_DurationForm">
			
			<% if ( tmflag.equals("1") ) { %>     		      
				<LABEL for="WC_N_AuctionDuration_austAMPM_In_DurationForm">
				</LABEL>
				<SELECT Name="austAMPM" id="WC_N_AuctionDuration_austAMPM_In_DurationForm">
				<OPTION VALUE="AM" SELECTED>AM
				<OPTION VALUE="PM">PM
				</SELECT>
			<%  } %>
                </TD>
         </TR>  

<% } // end editable is 'true'
 %>
         <TR>
		<TD  width=125 id="WC_N_AuctionDuration_TableCell_18"> 
			<%= auctionNLS.get("AuctionEndDate") %>
		</TD>
		<TD width=25 id="WC_N_AuctionDuration_TableCell_19"> 
			<LABEL for="WC_N_AuctionDuration_YEAR2_In_DurationForm">
			</LABEL>
			<INPUT TYPE=TEXT VALUE="" NAME=YEAR2 SIZE=4 MAXLENGTH=4 id="WC_N_AuctionDuration_YEAR2_In_DurationForm">
			
		</TD>
		<TD width=25 id="WC_N_AuctionDuration_TableCell_20"> 
			<LABEL for="WC_N_AuctionDuration_MONTH2_In_DurationForm">
			</LABEL>
			<INPUT TYPE=TEXT VALUE="" NAME=MONTH2 SIZE=2 MAXLENGTH=2 id="WC_N_AuctionDuration_MONTH2_In_DurationForm">
			
		</TD>
		<TD width=25 id="WC_N_AuctionDuration_TableCell_21"> 	
			<LABEL for="WC_N_AuctionDuration_DAY2_In_DurationForm">
			</LABEL>
			<INPUT TYPE=TEXT VALUE="" NAME=DAY2 SIZE=2 MAXLENGTH=2 id="WC_N_AuctionDuration_DAY2_In_DurationForm">
			
		</TD>
		<TD width=25 id="WC_N_AuctionDuration_TableCell_22"> 
               <%--//<A HREF="#" onClick="javascript:setupDate2();showCalendar(document.DurationForm.calImg2)">--%>
		<A HREF="javascript:setupDate2();showCalendar(document.DurationForm.calImg2)">
                  <IMG SRC="/wcs/images/tools/calendar/calendar.gif" BORDER=0 id=calImg2 
                   alt="<%= auctionNLS.get("calendarImgAlt") %>">
                </A>
		</TD>
		
		<TD width=100 id="WC_N_AuctionDuration_TableCell_23"> 
			<%= auctionNLS.get("AuctionEndTime") %>
		</TD>
		<TD id="WC_N_AuctionDuration_TableCell_24"> 
			<LABEL for="WC_N_AuctionDuration_auendtim_In_DurationForm">
			</LABEL>
			<INPUT TYPE="text" NAME="auendtim" SIZE=5  MAXLENGTH=5 VALUE=" " id="WC_N_AuctionDuration_auendtim_In_DurationForm">
			<% if ( tmflag.equals("1") ) { %>     		      
                       		<LABEL for="WC_N_AuctionDuration_auendAMPM_In_DurationForm">
                       		</LABEL>
                       		<SELECT Name="auendAMPM" id="WC_N_AuctionDuration_auendAMPM_In_DurationForm">
		         	<OPTION VALUE="AM" SELECTED>AM
		         	<OPTION VALUE="PM">PM
                       		</SELECT>
                     	<%  } %>
		</TD>
         </TR>  
  </TABLE>      
<%   if ( !autype.equals("D") ) {
%>
  <TABLE id="WC_N_AuctionDuration_Table_2">      
        <TR>
        <TD ALIGN=Center id="WC_N_AuctionDuration_TableCell_25"> 
<%      if ( auruletype.equals("4") ) {
%>
	  
	   <B><INPUT TYPE="radio" NAME="AndOr" VALUE="Or"  id="WC_N_AuctionDuration_r1_In_DurationForm"><LABEL for="WC_N_AuctionDuration_r1_In_DurationForm"> <%= auctionNLS.get("Or") %></LABEL>
	   
	  
	   <INPUT TYPE="radio" NAME="AndOr" VALUE="And"  checked id="WC_N_AuctionDuration_r2_In_DurationForm"> <LABEL for="WC_N_AuctionDuration_r2_In_DurationForm"><%= auctionNLS.get("And") %></LABEL>
	   
<%      } else {
%> 
	   
	   <B><INPUT TYPE="radio" NAME="AndOr" VALUE="Or"  checked id="WC_N_AuctionDuration_r3_In_DurationForm"><LABEL for="WC_N_AuctionDuration_r3_In_DurationForm"><%= auctionNLS.get("Or") %></LABEL>
	   
	  
	   <INPUT TYPE="radio" NAME="AndOr" VALUE="And"  id="WC_N_AuctionDuration_r4_In_DurationForm"> <LABEL for="WC_N_AuctionDuration_r4_In_DurationForm"><%= auctionNLS.get("And") %></LABEL>	
	  
	   </TD></TR>
<%      }
%> 
        <TR>
	   <TD id="WC_N_AuctionDuration_TableCell_26">
		
		<%= auctionNLS.get("StyleDurationPrefix") %> 
				
		<INPUT TYPE="text" NAME="audaydur" SIZE ="5"   MAXLENGTH="5" VALUE="" id="WC_N_AuctionDuration_audaydur_In_DurationForm"> 
		 <LABEL for="WC_N_AuctionDuration_audaydur_In_DurationForm">
		 <%= auctionNLS.get("days") %> 
		 </LABEL>
		 
		<INPUT TYPE="text" NAME="auhourdur" SIZE ="2" MAXLENGTH="2" VALUE="" id="WC_N_AuctionDuration_auhourdur_In_DurationForm">
		<LABEL for="WC_N_AuctionDuration_auhourdur_In_DurationForm">
		  <%= auctionNLS.get("hours") %> 
		</LABEL>		 
		<INPUT TYPE="text" NAME="aumindur" SIZE ="2"  MAXLENGTH="2" VALUE="" id="WC_N_AuctionDuration_aumindur_In_DurationForm">
		 <LABEL for="WC_N_AuctionDuration_aumindur_In_DurationForm">
		  <%= auctionNLS.get("minutes") %>
		 </LABEL>
		<%= auctionNLS.get("StyleDurationSuffix") %> 
		
	  </TD>
       </TR>
		<tr><td></td></tr>
		<tr><td></td></tr>
<%   }  // end if not auction type 'd'
%> 

  
</TABLE>
<TABLE id="WC_N_AuctionDuration_Table_3">
   	<tr><td></td></tr>
   	<tr><td></td></tr>
</TABLE>
   <BR><%= auctionNLS.get("TimeFormat") %> 	

</FORM>
</BODY>
</HTML>
