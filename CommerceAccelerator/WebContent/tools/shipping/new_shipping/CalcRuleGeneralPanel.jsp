<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2000, 2014 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%@ page import="java.util.*" %>
<%@ page import="com.ibm.commerce.utils.*" %>
<%@ page import="com.ibm.commerce.tools.shipping.*" %>
<%@ page import="com.ibm.commerce.tools.util.UIUtil" %>

<%@ include file="ShippingCommon.jsp" %>

<%
	try {
	String calcRuleId = request.getParameter(ShippingConstants.PARAMETER_CALCRULE_ID);
		
	String calcCodeId = request.getParameter(ShippingConstants.PARAMETER_CALCCODE_ID);
 
    String readOnly = request.getParameter(ShippingConstants.PARAMETER_READONLY);
    boolean editable = (readOnly == null || readOnly.equals("")|| readOnly.equalsIgnoreCase("false"));
    String disabledString = " disabled";
    if(editable)
    {
    	disabledString = "";
    }
	

	boolean foundCalcRuleId = (calcRuleId != null && calcRuleId.length() > 0);
	CalcRuleDetailsDataBean ruleBean = new CalcRuleDetailsDataBean();
	
	try{
	
		DataBeanManager.activate(ruleBean, request);
	}
	catch(Exception e){
		e.printStackTrace(); 
	}
		String calcScaleCode = ruleBean.getScaleCode();
		
	CommandContext cmdContext = (CommandContext)request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
	Locale locale = null;

	// use server default locale if no command context is found
	if (cmdContext != null) {
		locale = cmdContext.getLocale();
	}
	else {
		locale = Locale.getDefault();
	}

	// get calendar for this locale to determine what the first day of the week is so we can display our calendar appropriately
	if (locale==null) {
		locale=Locale.US;
	}
	Hashtable calendarNLS = (Hashtable)ResourceDirectory.lookup("common.calendarNLS", locale);
	
		
	

%>

<HTML>

<HEAD>
<%= fHeader %>
<STYLE type='text/css'>
.disabledBox {background: #c0c0c0;}
.enabledBox {background: #ffffff;}
</STYLE>
<TITLE><%= shippingRB.get(ShippingConstants.MSG_CALCRULE_GENERAL_PANEL_TITLE) %></TITLE>

 <SCRIPT language="JavaScript" src="/wcs/javascript/tools/common/Util.js"></SCRIPT>
 <SCRIPT language="JavaScript" src="/wcs/javascript/tools/common/DateUtil.js"></SCRIPT>
 <SCRIPT language="JavaScript" src="/wcs/javascript/tools/common/FieldEntryUtil.js"></SCRIPT>
 <SCRIPT language="JavaScript" src="/wcs/javascript/tools/common/Vector.js"></SCRIPT>
 <SCRIPT language="JavaScript" src="/wcs/javascript/tools/common/NumberFormat.js"></SCRIPT>

 <SCRIPT language="JavaScript" src="/wcs/javascript/tools/shipping/CalcRule.js"></SCRIPT>
 <SCRIPT language="JavaScript" src="/wcs/javascript/tools/shipping/ShippingUtil.js"></SCRIPT>
 <SCRIPT language="JavaScript">
<!---- hide script from old browsers

var incomingShipDependType;
var flags = 1;
var debug = false;

function CalcRuleAvailabilityModel()
{

  if (debug == true) alert("inside CalcRuleAvailabilityModel");
  this.StartImmediateChecked = false;
  this.startYear = "";
  this.startMonth = "";
  this.startDay = "";
  this.startTime = "00:00";
  this.endNeverExpires = false;
  this.endYear = "";
  this.endMonth = "";
  this.endDay = "";
  this.endTime = "00:00";
  
}

function initializeState(){
	
   	var visitedWizType = parent.get("visitedWizType", false);
	if (visitedWizType)
	{
		incomingShipDependType=parent.get("ShipDependType");
	
		if (incomingShipDependType)
		{
			document.generalForm.typeRadio.checked = true;
		}
		else 
		{
		        document.generalForm.typeRadio.checked = false;
		}
	}
}

function showDivisions()
{
  with (document.generalForm) {
  	if (StartImmediate[1].checked)
      		endDateDiv.style.display = "block";
  }
}
 
function showStartDateDivisions()
{
  with (document.generalForm) {
  	if (StartImmediate[0].checked)
    		endDateDiv.style.display = "none";
  }
}
 
function defaultStartDate()
{
  
  with (document.generalForm){
  	if (debug == true) alert("defaultStartDate");
    	StartYear.value = getCurrentYear();
	StartMonth.value = getCurrentMonth();
  	StartDay.value = getCurrentDay();
  	//loadValue(StartTime, "00:00");
  }  
}

function defaultEndDate()
{
 
 with (document.generalForm){

  if (debug == true) alert("defaultEndDate");
   	 
 	 EndYear.value = parseInt(StartYear.value) + 1;
 	 EndMonth.value = StartMonth.value;
 	 EndDay.value = StartDay.value;
 	 //loadValue(EndTime, "00:00");
 	 
  }
  
}
 
function loadPanelData()
 {
  if (debug == true) alert("loadPanelData");
  with (document.generalForm) {
  	if (parent.setContentFrameLoaded) {
    		parent.setContentFrameLoaded(true);
     	}
    	if (parent.get) {
 	    	var o = parent.get("<%= ShippingConstants.ELEMENT_CALCRULE_DETAILS_BEAN %>", null);
        	var o1 = parent.get("CalcRuleAvailabilityModel", null);
		if (o != null) {
		
			loadValue(ScaleCode, o.scaleCode);  
			loadValue(Description, o.scaleDescription);
			
			var fulfill = o.<%= ShippingConstants.ELEMENT_FLAGS %>;
			if (fulfill == 1) {
				typeRadio.checked = true;
			} else {
				typeRadio.checked = false;
			}

			flags = o.flags;
			if ( debug == true ) alert(" flags = " + flags);
			
			if( o1 != null){
				if (debug == true) alert("CalcRuleAvailabilityModel not null" );
		
				if (o1.StartImmediateChecked) 
					StartImmediate[0].checked = true;
				else 
					StartImmediate[1].checked = true;
				showDivisions();
				showStartDateDivisions();
				if (o1.StartImmediateChecked == false) {
					loadValue(StartYear, o1.startYear);
					loadValue(StartMonth, o1.startMonth);
					loadValue(StartDay, o1.startDay);
					//loadValue(StartTime, o1.startTime);

				}
				if (o1.endNeverExpires == false) {
					loadValue(EndYear, o1.endYear);
					loadValue(EndMonth, o1.endMonth);
					loadValue(EndDay, o1.endDay);
					//loadValue(EndTime, o1.endTime);
				}
			}
			else{ // time model does not exist
				// create the model
				StartImmediate[0].checked = true;
				var timeModel = new CalcRuleAvailabilityModel();
        			parent.put("CalcRuleAvailabilityModel", timeModel);
        			  		
        			if (o.startDate == null || o.startDate == "") {
 					//Use default StartDate
					defaultStartDate();
				} else {
					//Use user StartDate	
		   			if (debug == true) alert("Use user StartDate");
		  			
		  			<% try { %>
		  			
		  			StartYear.value = <%= TimestampHelper.getYearFromTimestamp(  ruleBean.getStartDate() ) %>;
		  			StartMonth.value =  <%= TimestampHelper.getMonthFromTimestamp( ruleBean.getStartDate()  ) %>;
        				StartDay.value = <%= TimestampHelper.getDayFromTimestamp( ruleBean.getStartDate()  ) %>;
        			
        					  	
        				<% } catch(Exception e){%>
        					defaultStartDate();
					<% } %>
				}
				if (o.endDate == null || o.endDate == "") {
					defaultEndDate();
				} else {
									
		  			<% try { %>
		  	
	  				EndYear.value = <%= TimestampHelper.getYearFromTimestamp( ruleBean.getEndDate() ) %>;
  					EndMonth.value = <%= TimestampHelper.getMonthFromTimestamp( ruleBean.getEndDate()  ) %>;
  					EndDay.value = <%= TimestampHelper.getDayFromTimestamp( ruleBean.getEndDate()  ) %>;
	 				
	 						
	 				<% } catch(Exception e){ %>
        					defaultEndDate();
	      				<% } %>
				}
				<% if (ruleBean.getStartDate() != null) { %>
				if ("<%= TimestampHelper.getYearFromTimestamp(ruleBean.getStartDate())%>" != "1900") {
		  				StartImmediate[1].checked = true;
		  				showDivisions();
						showStartDateDivisions();
		  		}
		  		<% } %>
	    		
			} // time model does not exist
		} // data bean model does not exit
		else {
		
			if (debug == true) alert("data bean model does not exist");
			defaultStartDate();
			defaultEndDate();
			
		}
     
		if (debug == true) alert("before show divisions");
	
    		showDivisions();
    	
    		if (debug == true) alert("before show showStartDateDivisions");

    		showStartDateDivisions();
    	
    		if (debug == true) alert("before show initializeState");
    	
 		initializeState();
 		
     if (parent.get("scaleCodeRequired", false))
     {
      parent.remove("scaleCodeRequired");
      reprompt(ScaleCode, "<%= UIUtil.toJavaScript((String)shippingRB.get(ShippingConstants.MSG_CALCSCALE_CODE_REQUIRED))%>");
      
     }


    	// handle error messages back from the validate page
    if (parent.get("contractDescriptionTooLong", false))
     {
      parent.remove("scaleDescriptionTooLong");
      reprompt(Description, "<%= UIUtil.toJavaScript((String)shippingRB.get(ShippingConstants.MSG_CALCSCALE_DESCR_TOO_LONG))%>");
     }
     else if (parent.get("invalidStartDate", false))
     {
      parent.remove("invalidStartDate");
      reprompt(StartYear, "<%= UIUtil.toJavaScript((String)shippingRB.get(ShippingConstants.MSG_INVALID_DATE))%>");
     }
    else if (parent.get("invalidEndDate", false))
     {
      parent.remove("invalidEndDate");
      alertDialog("<%= UIUtil.toJavaScript((String)shippingRB.get(ShippingConstants.MSG_INVALID_DATE))%>");
      endDateDiv.style.display = "block";
      EndYear.select();
      EndYear.focus();
    }
    else if (parent.get("invalidEndAfterStartDate", false))
     {
      parent.remove("invalidEndAfterStartDate");
      alertDialog("<%= UIUtil.toJavaScript((String)shippingRB.get(ShippingConstants.MSG_INVALID_END_AFTER_START_DATE))%>");
      endDateDiv.style.display = "block";
      EndYear.select();
      EndYear.focus();
     }
    else if (parent.get("calcRuleExists", false))
     {
      parent.remove("calcRuleExists");
      alertDialog("<%= UIUtil.toJavaScript((String)shippingRB.get("calcRuleExists"))%>");
     }
    else if (parent.get("contractGenericError", false))
     {
      parent.remove("contractGenericError");
      alertDialog("<%= UIUtil.toJavaScript((String)shippingRB.get(ShippingConstants.MSG_CALRULE_NOT_SAVED))%>");
      
     }
    

    }
   }
 }
 
function isEmpty(id) {
   return !id.match(/[^\s]/); 
}

function validatePanelData () {

	  var calcRuleDetails = parent.get("<%= ShippingConstants.ELEMENT_CALCRULE_DETAILS_BEAN %>", null);
  var o = parent.get("CalcRuleAvailabilityModel", null);

  with (document.generalForm) {
  	
       //SCALE
 
          if (!ScaleCode.value)
             {
                reprompt(ScaleCode, "<%= UIUtil.toJavaScript((String)shippingRB.get(ShippingConstants.MSG_CALCSCALE_CODE_REQUIRED))%>");
                     return false;
       }
   
           if (!isValidUTF8length(ScaleCode.value, 30))
             {
            reprompt(ScaleCode, "<%= UIUtil.toJavaScript((String)shippingRB.get(ShippingConstants.MSG_CALCSCALE_CODE_TOO_LONG))%>");
                  return false;
       }


       
 	   // DESCRIPTION
 	     if(debug == true) alert('validate description');
              if (!isValidUTF8length(Description.value, 254))
             {
                    reprompt(Description, "<%= UIUtil.toJavaScript((String)shippingRB.get(ShippingConstants.MSG_CALCSCALE_DESCR_TOO_LONG))%>");
                  return false;
                 }


	   // START DATE
	    if(debug == true) alert('validate start date');
       if (o.StartImmediateChecked == false && !validDate(o.startYear, o.startMonth, o.startDay))
   	   {
      		alertDialog("<%= UIUtil.toJavaScript((String)shippingRB.get(ShippingConstants.MSG_INVALID_DATE))%>");
      		startDateDiv.style.display = "block";
      		StartYear.select();
      		StartYear.focus();
    		return false;
   		}

  		// END DATE
  		 if(debug == true) alert('validate end date');
  		if (o.endNeverExpires == false && !validDate(o.endYear, o.endMonth, o.endDay))
  		{
     		alertDialog("<%= UIUtil.toJavaScript((String)shippingRB.get(ShippingConstants.MSG_INVALID_DATE))%>");
      		endDateDiv.style.display = "block";
      		EndYear.select();
      		EndYear.focus();
    		return false;
   		}

  		// if start and end dates are specified, validate range
  		 if(debug == true) alert('validate date range');
  		if (o.endNeverExpires == false && ! validateStartEndDateTime(o.startYear, o.startMonth, o.startDay,
                                 o.endYear, o.endMonth, o.endDay,
                                 o.startTime,
                                 o.endTime))
   		{
    		alertDialog("<%= UIUtil.toJavaScript((String)shippingRB.get(ShippingConstants.MSG_INVALID_END_AFTER_START_DATE))%>");
      		endDateDiv.style.display = "block";
      		EndYear.select();
      		EndYear.focus();
    		return false;
   		}
   		
   	}
   	
   	return true;
}


function saveCalcRuleDates() {

  var calcRuleDetails = parent.get("<%= ShippingConstants.ELEMENT_CALCRULE_DETAILS_BEAN %>", null);
  var o = parent.get("CalcRuleAvailabilityModel", null);

  var timeStr;
  var year;
  var month;
  var date; 

  var time = "00:00:00";
  var hour = "";
  var minute = "";
  var second = "";

  // Start Date
  if (o.StartImmediateChecked == false) {
  	
  	year =  o.startYear;
  	month = padZero(o.startMonth);
  	date =  padZero(o.startDay);

   	calcRuleDetails.startDate = year.concat( "-", String(month), "-", String(date), " 00:00:00" );
  } else {
  	year =  "1900";
  	month = "01";
  	date =  "01";

   	calcRuleDetails.startDate = year.concat( "-", String(month), "-", String(date), " 00:00:00" );
  }
  // End Date
  if (o.StartImmediateChecked == false) {

   	year =  o.endYear;
  	month = padZero(o.endMonth);
  	date =  padZero(o.endDay);
   
	calcRuleDetails.endDate = year.concat("-", String(month), "-", String(date), " 00:00:00");
  } else {
  
  	year =  "2100";
  	month = "01";
  	date =  "01";
  	
  	
   	calcRuleDetails.endDate = year.concat( "-", String(month), "-", String(date), " 00:00:00" );
  }


  return true;
}

function savePanelData()
 {
  if (debug == true) alert ('General savePanelData');
  with (document.generalForm)
   {
    if (parent.get)
     {
           var o = parent.get("<%= ShippingConstants.ELEMENT_CALCRULE_DETAILS_BEAN %>", null);
       	   var o1 = parent.get("CalcRuleAvailabilityModel", null);
	
        if (o != null) {
        		o.scaleCode = ScaleCode.value;
  			o.scaleDescription = Description.value;
  			if (typeRadio.checked == true)
  				o.<%= ShippingConstants.ELEMENT_FLAGS %> = "1";
  			else 
  				o.<%= ShippingConstants.ELEMENT_FLAGS %> = "0";
  			o.<%= ShippingConstants.ELEMENT_CALCCODE_ID %> = <%=(calcCodeId == null ? null : UIUtil.toHTML(calcCodeId))%>;
  		}
  		if(o1 != null){
  			o1.StartImmediateChecked = StartImmediate[0].checked;
  			o1.startYear = StartYear.value;
  			o1.startMonth = StartMonth.value;
  			o1.startDay = StartDay.value;
			o1.endNeverExpires = StartImmediate[0].checked;
  			o1.endYear = EndYear.value;
  			o1.endMonth = EndMonth.value;
  			o1.endDay = EndDay.value;
 		
        	}
        if (debug == true) alert("before select branch");
        saveCalcRuleDates();
        selectBranch();
     }
   }
 }
 
function selectBranch(){
    var o = parent.get("<%= ShippingConstants.ELEMENT_CALCRULE_DETAILS_BEAN %>", null);
	var outgoingShipDependType = document.generalForm.typeRadio.checked;
	if(outgoingShipDependType){
		if (debug == true) alert("going to shpjruleByCalcRuleListPanel");
		parent.setNextBranch("shpjruleByCalcRuleListPanel");  
		parent.put("ShipDependType", true);
		o.<%= ShippingConstants.ELEMENT_FLAGS %> = "1";
       	
	}
	else{
		if (debug == true) alert("going to calcRangeTypePanel");
		parent.setNextBranch("calcRangeTypePanel");
		parent.put("ShipDependType", false);
		o.<%= ShippingConstants.ELEMENT_FLAGS %> = "0";
	}
	//////////////////////////////////////////////////////////////
	// if user is changing types ... set the visited flags
	// to false to avoid reading incorrect data
	//////////////////////////////////////////////////////////////
	var visitedWizTypeBefore = parent.get("visitedWizType", false);

	if (visitedWizTypeBefore)
	{
		if ((incomingShipDependType != outgoingShipDependType))
		{
			parent.put("visitedShpjrulesByCalcRuleListPanel", false);
			parent.put("visitedCalcRangeTypePanel", false);
		} 
	}
	parent.put("visitedWizType", true);
    return true;
}


function setupStartDate() {
      window.yearField = document.generalForm.StartYear;
      window.monthField = document.generalForm.StartMonth;
      window.dayField = document.generalForm.StartDay;
}

function setupEndDate() {
      window.yearField = document.generalForm.EndYear;
      window.monthField = document.generalForm.EndMonth;
      window.dayField = document.generalForm.EndDay;
}
//-->
</SCRIPT>
<META name="GENERATOR" content="IBM WebSphere Studio">
</HEAD>


<BODY onload="loadPanelData()" class="content">
<SCRIPT for="document" event="onclick()">
      document.all.CalFrame.style.display="none";
</SCRIPT>

<IFRAME style="display:none;position:absolute;width:198;height:230"
      title="<%= calendarNLS.get("calendarTitle") %>"
      id="CalFrame" marginheight="0" marginwidth="0" noresize frameborder="0" scrolling="NO"
      src="/webapp/wcs/tools/servlet/Calendar">
</IFRAME>

<H1><%= shippingRB.get(ShippingConstants.MSG_CALCRULE_GENERAL_PANEL_TITLE) %></H1>

<LINE3><%= shippingRB.get("calcRuleGeneralPanelDesc") %></LINE3>

<FORM name="generalForm">
<% if (foundCalcRuleId) { %>
       <P><%= shippingRB.get(ShippingConstants.MSG_CALCSCALE_CODE_PROMPT) %><BR><I><%= calcScaleCode %></I>
       <INPUT name="ScaleCode" type="HIDDEN" value="">
       
       <P><%= shippingRB.get(ShippingConstants.MSG_CALCSCALE_DESCR_PROMPT) %><BR>
       <LABEL for="Description"><TEXTAREA name="Description" id="Description" rows="2" cols="50" wrap="physical" onkeydown="limitTextArea(this.form.Description,254);" onkeyup="limitTextArea(this.form.Description,254);" <%=disabledString%>>
       </TEXTAREA></LABEL>
       	
<% } else {%>
       <P><%= shippingRB.get(ShippingConstants.MSG_CALCSCALE_CODE_PROMPT) %><BR>
       <LABEL><INPUT name="ScaleCode" type="TEXT" size="30" maxlength="30"><LABEL>

       <P><%= shippingRB.get(ShippingConstants.MSG_CALCSCALE_DESCR_PROMPT) %><BR>
       <LABEL><TEXTAREA name="Description" id="Description" rows="2" cols="50" wrap="physical" onkeydown="limitTextArea(this.form.Description,254);" onkeyup="limitTextArea(this.form.Description,254);">
       </TEXTAREA></LABEL>
       
<% } %>

<P>
<%= UIUtil.toHTML((String)shippingRB.get("timePeriod")) %><BR>
<%= UIUtil.toHTML((String)shippingRB.get("timePeriodDesc")) %><BR>

<LABEL for="StartImmediate"><INPUT name="StartImmediate" id="StartImmediate" type="radio" checked onclick="showStartDateDivisions()" <%=disabledString%>></LABEL>
    <%= shippingRB.get("ruleAlwaysInEffect") %>

<BR>

<LABEL for="StartImmediate"><INPUT name="StartImmediate" id="StartImmediate" type="radio" onclick="showDivisions()" <%=disabledString%>></LABEL>

    <%= shippingRB.get("ruleInEffectTimePeriod") %>

<DIV id="endDateDiv" style="display: none; margin-left: 25">
<TABLE border="0" cellspacing="0" cellpadding="0">
<TBODY><TR>
      <TD>&nbsp;</TD>
      <TD>&nbsp;</TD>
      <TD><%= shippingRB.get(ShippingConstants.MSG_YEAR_PROMRT) %></TD>
      <TD>&nbsp;</TD>
      <TD><%= shippingRB.get(ShippingConstants.MSG_MONTH_PROMPT) %></TD>
      <TD>&nbsp;</TD>
      <TD><%= shippingRB.get(ShippingConstants.MSG_DAY_PROMPT) %></TD>
  </TR>
  <TR>
         <TD><%=shippingRB.get(ShippingConstants.MSG_CALCRULE_START_PROMPT)%></TD>
         <TD>&nbsp;</TD>
  	 <TD>
  	 <LABEL><INPUT type="TEXT" name="StartYear" size="4" maxlength="4" <%=disabledString%>></LABEL>
  	 </TD>
	 <TD></TD><TD>
	 
	<LABEL> <INPUT type="TEXT" name="StartMonth" size="2" maxlength="2" <%=disabledString%>></LABEL>
	 </TD>  
	 <TD></TD><TD>
	 <LABEL><INPUT type="TEXT" name="StartDay" size="2" maxlength="2" <%=disabledString%>></LABEL>
	 
	 </TD>
	 <TD>&nbsp;</TD>
	 <TD>
	 <% if(editable){
	 %>
	 <A href="javascript:setupStartDate();showCalendar(document.generalForm.calImg1)" >
	 <IMG src="/wcs/images/tools/calendar/calendar.gif" border="0" id="calImg1" alt="<%= UIUtil.toJavaScript((String)shippingRB.get(ShippingConstants.MSG_CALENDAR_TOOLS_PROMPT)) %>"></A>
	 <% }
	 %>
	 </TD>
	 
  
  <TR>
         <TD><%=shippingRB.get(ShippingConstants.MSG_CALCRULE_END_PROMPT)%></TD>
         <TD>&nbsp;</TD>
  	 <TD>
  	 <LABEL><INPUT type="TEXT" name="EndYear" size="4" maxlength="4" <%=disabledString%>><LABEL>
  	 
  	 </TD>
	 <TD></TD><TD>
	 <INPUT type="TEXT" name="EndMonth" size="2" maxlength="2" <%=disabledString%>>
	 </TD>
	 <TD></TD><TD>
	 <LABEL><INPUT type="TEXT" name="EndDay" size="2" maxlength="2" <%=disabledString%>></LABEL>
	        
	 </TD>
	 <TD>&nbsp;</TD>
	 <TD>
	 <% if(editable){
	 %>
	 <A href="javascript:setupEndDate();showCalendar(document.generalForm.calImg2)" >
	 <IMG src="/wcs/images/tools/calendar/calendar.gif" border="0" id="calImg2" alt="<%= UIUtil.toJavaScript((String)shippingRB.get(ShippingConstants.MSG_CALENDAR_TOOLS_PROMPT)) %>"></A>
	 <% }
	 %>
	 </TD>
<!--
         <TD>&nbsp;</TD>
         <TD><%= shippingRB.get(ShippingConstants.MSG_TIME_PROMPT) %></TD>
         <TD>&nbsp;</TD>
         <TD><INPUT name="EndTime" type="TEXT" size="5" maxlength="5"></TD>
-->
  </TR>

 
</TBODY></TABLE>
</DIV>

<% if (foundCalcRuleId) { %>
	<P><LABEL><INPUT name="typeRadio" type="Checkbox" disabled=true></LABEL><%=shippingRB.get(ShippingConstants.MSG_CALCRULE_SHIP_DEPENDENT_PROMPT)%><BR>
<% } else {  %>
     	<P><LABEL><INPUT name="typeRadio" type="Checkbox"></LABEL><%=shippingRB.get(ShippingConstants.MSG_CALCRULE_SHIP_DEPENDENT_PROMPT)%><BR>
<% } %>

</P></FORM>
</BODY>
</HTML>
<% } catch (Exception e) {e.printStackTrace();}%>
