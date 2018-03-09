<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2009, 2010 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java"
	import="com.ibm.commerce.beans.DataBeanManager,
	com.ibm.commerce.utils.TimestampHelper,
	java.text.DateFormat,
	java.util.*,com.ibm.commerce.tools.common.*,
	com.ibm.commerce.command.*,
	com.ibm.commerce.server.*,
	com.ibm.commerce.tools.util.*,
	com.ibm.commerce.tools.xml.*,
	com.ibm.commerce.datatype.*,
	com.ibm.commerce.beans.*" %>

<%@ include file="../common/common.jsp" %>

<%@page import="com.ibm.commerce.tools.resourcebundle.*"%>

<%
	CommandContext cmdContext = (CommandContext) request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
	Locale locale = cmdContext.getLocale();
	Integer langId = cmdContext.getLanguageId();
	ResourceBundleProperties taxNLS = (ResourceBundleProperties) ResourceDirectory.lookup("taxation.taxationNLS", locale);
	
%>

<html xmlns="http://www.w3.org/1999/xhtml">
<HEAD>
<LINK REL=stylesheet HREF="<%=UIUtil.getCSSFile(locale)%>"
	TYPE="text/css">
<STYLE TYPE='text/css'>
.selectWidth {width: 230px;}
.selectWidth2 {width: 260px;}
.selectWidth3 {width: 260px;}
</STYLE>
</HEAD>
<script language="JavaScript" src="<%= UIUtil.getWebPrefix(request) %>javascript/tools/common/DateUtil.js"></script>
<script language="JavaScript" src="<%= UIUtil.getWebPrefix(request) %>javascript/tools/common/SwapList.js"></script>
<script language="JavaScript" src="<%= UIUtil.getWebPrefix(request) %>javascript/tools/common/Util.js"></script>
<%@include file="../common/NumberFormat.jsp" %>
<script language="JavaScript">
	
	function getHeading()
  {
  	return "<%=taxNLS.getJSProperty("TaxRateInfo")%>";
  }
  
	var initiativeDataBean = null;
	var taxRatesList;
	taxRatesList = top.getData("TaxRatesList", 1);
	var operation = top.getData("operation",1);
	var calculationRuleId = top.getData("calculationRuleId", 1);
	var taxRatesDataIndex=0;
	var jurstIdSelected;
	var taxCategoryId;
	var taxCategoryName;
	var jursts = top.getData("jurstlist",1);
	
	function setupStartDate()
	{
		window.yearField = document.taxRatesForm.startyear;
		window.monthField = document.taxRatesForm.startmonth;
		window.dayField = document.taxRatesForm.startday;
	}
	
	function setupEndDate()
	{
		window.yearField = document.taxRatesForm.endyear;
		window.monthField = document.taxRatesForm.endmonth;
		window.dayField = document.taxRatesForm.endday;
	}
	
	function loadValue (entryField, value) {
		if (value != top.undefined) {
			entryField.value = value;
		}
	}
	
	function loadSelectValue (select, value) {
		for (var i=0; i<select.length; i++) {
			if (select.options[i].value == value) {
				select.options[i].selected = true;
				return;
			}
		}
	}

		
	function loadJurisdictions(){
		var count=0;
		if (jursts !=null ){
			for (var i=0; i<jursts.length; i++ ){
				var displayName="";
				var country=jursts[i].country;
				if (country == null || country==""){
					displayName="World"
				}else{
					var state=jursts[i].state;
					if(state == null || state==""){
						displayName = country;
					}else{
						displayName = country+", "+state;
					}
				}
				var id = jursts[i].jurisdictionId;
				document.taxRatesForm.jurisdictionList.options[count] = new Option(displayName, id, false, false);
	          	document.taxRatesForm.jurisdictionList.options[count].selected=false;
	          	count++;
			}
		}
		
		// if operation == change, then make jurisdiction 
		if (operation == "Change"){
			document.taxRatesForm.jurisdictionList.disabled="disabled";
		}
	}
	
	function loadDateInfo(value, entryYear,entryMonth, entryDay, entryTime){
		if (value != null && value != ""){
			 var delimiter = "-";
			 var delimiter1=" ";
			 var delimiter2=".";
			 var year, month, day, time,date;
			 date = value.substring(0,value.indexOf(delimiter1));
	  		 time= value.substring(value.indexOf(delimiter1) + 1);
	  		 time= time.substring(0,time.indexOf(delimiter2));
	  		 year = date.substring(0,date.indexOf(delimiter));
	  		 var temp = date.substring(date.indexOf(delimiter)+1);
	  		 month = temp.substring(0,temp.indexOf(delimiter));
	  		 day = temp.substring(temp.indexOf(delimiter)+1);
	  		 
	  		if (year != top.undefined) {
				entryYear.value = year;
			}
			
			if (month != top.undefined) {
				entryMonth.value = month;
			}
			
			if (day != top.undefined) {
				entryDay.value = day;
			}
			
			if (time != top.undefined) {
				entryTime.value = time;
			}	
		}
	}
	
	function loadPanelData(){
		//load tax category
		var id = top.getData("taxCategoryId",1);
		var name = top.getData("taxCategory",1);
		taxCategoryId = id;
		taxCategoryName = name;
		if (taxCategoryName != null){
			loadValue(document.taxRatesForm.taxcategory, taxCategoryName);
		}
	
		//load the jurisdiction
		loadJurisdictions();
		
		with (document.taxRatesForm) {
			if (taxRatesList != null && taxRatesList != undefined) {
				var taxRatesInfoData ;
				for (var i = 0; i<taxRatesList.length ; i++){
					if (taxRatesList[i].calculationRuleId == calculationRuleId){
						taxRatesInfoData = taxRatesList[i];
						taxRatesDataIndex=i;
						break;
					}
				}
				//load tax rates info
				if (taxRatesInfoData != null && taxRatesInfoData != undefined){
					loadSelectValue(document.getElementById("jurisdictionList"), taxRatesInfoData.jurstId);
					loadValue(document.getElementById("rate"), numberToStr(taxRatesInfoData.rate,"<%=langId%>",4));
					loadValue(document.getElementById("precedence"), numberToStr(taxRatesInfoData.precedence,"<%=langId%>",1));
					jurstIdSelected = taxRatesInfoData.jurstId;
					// load date info
					loadDateInfo(taxRatesInfoData.startDate,document.getElementById("startyear"),document.getElementById("startmonth"),document.getElementById("startday"),document.getElementById("starttime"));
					loadDateInfo(taxRatesInfoData.endDate,document.getElementById("endyear"),document.getElementById("endmonth"),document.getElementById("endday"),document.getElementById("endtime"));
				}else{
					jurstIdSelected = jursts[0].jurisdictionId;
				}
				
				
			}else{
				//select the first one
				jurstIdSelected = jursts[0].jurisdictionId;
			}
		}
		
		if (parent.setContentFrameLoaded) {
			parent.setContentFrameLoaded(true);
		}
	}
	
	
	function validateEntry(fieldName,length,errorDialog)
  {
  	var value = document.getElementById(fieldName).value;
  	
  	if (value != null && value !=""){
  	    var isValid = isValidNumber(value, "<%=langId%>");
  		var newValue = strToNumber(document.getElementById(fieldName).value, "<%=langId%>");
  		if (!isValid || (newValue < 0)) {
		    alertDialog(errorDialog);
		    document.getElementById(fieldName).focus();
		 }
		 else {
			document.getElementById(fieldName).value= numberToStr(newValue, "<%=langId%>", length);
		 }
  	}else{
  		document.getElementById(fieldName).value= numberToStr(0, "<%=langId%>", length);
  	}
    
  }
  
  
  function dochange(value){
		// load list data
		var index =  window.document.getElementById("jurisdictionList").selectedIndex;
		var value = window.document.getElementById("jurisdictionList").options[index].text;
		var id = window.document.getElementById("jurisdictionList").options[index].value;
		jurstIdSelected = id;
	
	}
	
	function validateDate (inYear,inMonth,inDay) {
	
		if ((inYear.length > 4) || (inYear.length < 4) || (inMonth.length <=0) || (inDay.length <= 0)){
			return false;
		}
		if (inDay.length > 0 && inDay.charAt(0) == "0") {
			inDay = inDay.substring(1, inDay.length);
		}
	
		if (inMonth.length > 0 && inMonth.charAt(0) == "0") {
			inMonth = inMonth.substring(1, inMonth.length);
		}
	
		if (inYear.length == 4 && (inMonth.length == 1 || inMonth.length == 2) && (inDay.length == 1 || inDay.length == 2)) {
			var day = parseInt(inDay);
			var month = parseInt(inMonth);
			var year = parseInt(inYear);
			var dayString = day.toString();
			var monthString = month.toString();
			var yearString = year.toString();
	
			if ((year != NaN && yearString.length == 4 && year >= 1900 && year <= 9999 ) && (month != NaN && month >= 1 && month <= 12 && (monthString.length == inMonth.length)) && (day != NaN && (inDay.length == dayString.length))) {
				var daysMonth = getDaysInMonth(month, year);
	
				if (day >= 1 && day <= daysMonth) {
					return true;
				}
			}
			else {
				return false;
			}
		}
		return false;
	}
	
	function validateTime(time1) {
	
	   var delimiter = ":";
	   var hh, mm, ss;
	   var time1Length;
	   var hhlength;
	   var mmlength;
	   var sslength;
	
	   time1Length = time1.length;
	
	   if (time1 == "" || time1.indexOf(delimiter) == -1 ||  time1Length > 8 ) return false;
	
	   hh = time1.substring(0,time1.indexOf(delimiter));
	   var temp = time1.substring(time1.indexOf(delimiter) + 1);
	   mm = temp.substring(0,temp.indexOf(delimiter));
	   ss = temp.substring(temp.indexOf(delimiter) + 1);
	
	   hhlength = hh.length;
	   mmlength = mm.length;
	   sslength = ss.length;
	
	   if (hhlength <1 || hhlength >2 || mmlength <1 || mmlength >2 || sslength <1 || sslength >2) return false;
	   if (hh=="" || mm == "" || ss=="") return false;
	   if (isNaN(hh) || isNaN(mm) || isNaN(ss)) return false;
	
	   if ( parseInt(hh) > 23 || parseInt(hh) < 0 ) return false;
	   if ( parseInt(mm) > 59 || parseInt(mm) < 0 ) return false;
	   if ( parseInt(ss) > 59 || parseInt(ss) < 0 ) return false;
	   return true;
	}
	
	function validateStartAndEndDateTime(inStartYear,inStartMonth,inStartDay,inEndYear,inEndMonth,inEndDay,startTime,endTime){	
	    var inStartHour = 0;
	    var inStartMinute = 0;
	    var inStartSecond = 0;
	
	    var inEndHour = 0;
	    var inEndMinute = 0;
	    var inEndSecond = 0;
	
	    // parse the hours and minutes from the startTime
	    if (startTime != null) {
	       inStartHour = startTime.substring(0,startTime.indexOf(":"));
	       var temp = startTime.substring(startTime.indexOf(":") + 1);
	       inStartMinute = temp.substring(0,temp.indexOf(":"));
	       inStartSecond = temp.substring(temp.indexOf(":")+1);
	    }
	
	    // parse the hours and minutes from the endTime
	    if (endTime != null) {
	       inEndHour = endTime.substring(0,endTime.indexOf(":"));
	       var temp = endTime.substring(endTime.indexOf(":") + 1);
	       inEndMinute = temp.substring(0,temp.indexOf(":"));
	       inEndSecond = temp.substring(temp.indexOf(":") + 1);
	    }
	
	    // alert('START\nY='+inStartYear+'\nM='+inStartMonth+'\nD='+inStartDay+'\nh='+inStartHour+'\nm='+inStartMinute+'\ns='+inStartSecond);
	    // alert('END\nY='+inEndYear+'\nM='+inEndMonth+'\nD='+inEndDay+'\nh='+inEndHour+'\nm='+inEndMinute+'\ns='+inEndSecond);
	
	    // create a date object for the startdate
	    var sDate = new Date(inStartYear,
	                         inStartMonth-1,
	                         inStartDay,
	                         inStartHour,
	                         inStartMinute,
	                         inStartSecond);
	    // create a date object for the enddate
	    var eDate = new Date(inEndYear,
	                         inEndMonth-1,
	                         inEndDay,
	                         inEndHour,
	                         inEndMinute,
	                         inEndSecond);
	
	    // generate millisecond internal representations of the start/end dates
	    var startMilliTime = sDate.getTime();
	    var endMilliTime = eDate.getTime();
	
	    // alert ('start='+startMilliTime+' end='+endMilliTime);
	
	    // if startMilliTime is greater than endMillTime return false.
	    // otherwise return true.
	    // note: startdate = enddate returns true!
	    if (startMilliTime == endMilliTime)
	    {
	        return -1;
	    }
	    else if (startMilliTime > endMilliTime)
	    {
	        return false;
	    }
	    else if (startMilliTime < endMilliTime)
	    {
	        return true;
	    }
	}

	function validatePanelData(){
	
		var startyear_value = document.getElementById("startyear").value;
		var startmonth_value = document.getElementById("startmonth").value;
		var startday_value = document.getElementById("startday").value;
		var starttime_value = document.getElementById("starttime").value;
		
		var endyear_value=document.getElementById("endyear").value;
		var endmonth_value = document.getElementById("endmonth").value;
		var endday_value = document.getElementById("endday").value;
		var endtime_value = document.getElementById("endtime").value;
		
		//check the validation of input about start date 
		if ((startyear_value != null && startyear_value != "")|| (startmonth_value != null && startmonth_value != "") || (startday_value != null && startday_value != "")){
			if ( !validateDate(startyear_value,startmonth_value,startday_value))
			{
			    alertDialog('<%= UIUtil.toJavaScript(taxNLS.get("invalidStartDate").toString())%>');
			    return false;
			}
		}
		
		//check the validation of input about end date
		if ((endyear_value != null && endyear_value != "") || (endmonth_value != null && endmonth_value != "") || (endday_value != null && endday_value != "")){
			if ( !validateDate(endyear_value,endmonth_value,endday_value))
			{
			    alertDialog('<%= UIUtil.toJavaScript(taxNLS.get("invalidEndDate").toString())%>');
			    return false;
			}
		}
		
		//check the validation of input about start time
		if (starttime_value != null && starttime_value != ""){
			if (!validateTime(starttime_value)){
				alertDialog('<%= UIUtil.toJavaScript(taxNLS.get("invalidStartTime").toString())%>');
			    return false;
			}	
		}
		
		//check the validation of input about end time
		if (endtime_value != null && endtime_value != ""){
			if (!validateTime(endtime_value)){
				alertDialog('<%= UIUtil.toJavaScript(taxNLS.get("invalidEndTime").toString())%>');
			    return false;
			}
		}	
		
		// if user has typed the start date and end date, check the validation of them (start date <= end date)
		if (startyear_value != null && startyear_value != "" && endyear_value != null && endyear_value != ""){
			var validTime = validateStartAndEndDateTime(document.getElementById("startyear").value,document.getElementById("startmonth").value,document.getElementById("startday").value, 
												document.getElementById("endyear").value,document.getElementById("endmonth").value,document.getElementById("endday").value, 
												document.getElementById("starttime").value, document.getElementById("endtime").value);
			if ((validTime==false)||(eval(validTime)==-1))
			{
			    alertDialog('<%= UIUtil.toJavaScript(taxNLS.get("invalidStartEndTime").toString())%>');
			    return false;
			}
		}
	}
  
  

	<%--
		- Ths method is used to compose start date value according to start year, start month, start day and start time.
	--%>
	function composeStartDate(){
		var startDate = "";
			var startYear = document.getElementById("startyear").value;
			var startMonth = document.getElementById("startmonth").value;
			var startDay = document.getElementById("startday").value;
			var startTime = document.getElementById("startTime").value;
			if (startYear != null && startMonth != null && startDay != null && startYear.length>0 && startMonth.length >0  && startDay.length>0){
				startDate = startYear+"-"+startMonth+"-"+startDay;
				if (startTime == null || startTime == ""){
					startTime ="00:00:00";
				}
				startDate = startDate+" "+startTime+".0";
			}
		return startDate;
		
	}
	
	<%--
		- Ths method is used to compose end date value according to end year, end month, end day and end time.
	--%>
	function composeEndDate(){
		var endDate = "";
			var endYear = document.getElementById("endyear").value;
			var endMonth = document.getElementById("endmonth").value;
			var endDay = document.getElementById("endday").value;
			var endTime = document.getElementById("endTime").value;
			if (endYear != null && endMonth != null && endDay != null && endYear.length>0 && endMonth.length>0 && endDay.length>0){
				endDate = endYear+"-"+endMonth+"-"+endDay;
				if (endTime == null || endTime == "" ){
					endTime ="23:59:59";
				}
				endDate = endDate+" "+endTime+".0";
			}
		return endDate;
	}
	
	function savePanelData(){
		
		if (operation =="Add"){
		
			// if operation is "Add", then create a new object and return it.
			var taxRatesResult = new Object();
			// create an new calrule
			taxRatesResult["calculationRuleId"]="";
			taxRatesResult["taxcgryId"]=taxCategoryId;
			taxRatesResult["taxcategory"]=taxCategoryName;
			taxRatesResult["jurstId"]=jurstIdSelected;
			var index =  window.document.getElementById("jurisdictionList").selectedIndex;
			var value = window.document.getElementById("jurisdictionList").options[index].text;
			taxRatesResult["jurisdiction"]=window.document.getElementById("jurisdictionList").options[index].text;
			var taxRate = document.getElementById("rate").value;
			if (taxRate == null || taxRate == ""){
				taxRate = 0;
			}
			taxRatesResult["rate"]=strToNumber(taxRate,"<%=langId%>");
			//startDate
			taxRatesResult["startDate"]=composeStartDate();
			//endDate
			taxRatesResult["endDate"]=composeEndDate();
			var taxPrecedence = document.getElementById("precedence").value;
			if (taxPrecedence == null || taxPrecedence == ""){
				taxPrecedence = 0;
			}
			taxRatesResult["precedence"]=strToNumber(taxPrecedence,"<%=langId%>");

			top.sendBackData(taxRatesResult,"taxRatesResult");
			top.sendBackData(true,"isAdded");
		}else if (operation == "Change"){
			// if the operation is "Change", update the record of the TaxRatesList directly.
			//taxRatesList[taxRatesDataIndex].jurstId = jurstIdSelected;
			//var index =  window.document.getElementById("jurisdictionList").selectedIndex;
			//taxRatesList["jurisdiction"]=window.document.getElementById("jurisdictionList").options[index].text;
			//taxRatesList[taxRatesDataIndex].jurisdiction = window.document.getElementById("jurisdictionList").options[index].text;
			taxRatesList[taxRatesDataIndex].rate = strToNumber(document.getElementById("rate").value,"<%=langId%>");
			//startDate
			taxRatesList[taxRatesDataIndex].startDate=composeStartDate();
			//endDate
			taxRatesList[taxRatesDataIndex].endDate=composeEndDate();
			taxRatesList[taxRatesDataIndex].precedence = strToNumber(document.getElementById("precedence").value,"<%=langId%>");
			
		}
		
		top.sendBackData(null,"calculationRuleId");
		top.sendBackData(taxRatesList, "TaxRatesList");
	}
	
</script>

<body onload="loadPanelData()" class="content">
<H1><%=taxNLS.getProperty("TaxRateInfo")%></H1>
<form name="taxRatesForm" id="taxRatesForm">
	<p/>
	<script>
		document.writeln('<iframe name="calendar" style="display:none;position:absolute;width:198;height:230;z-index=100" id="CalFrame" marginheight="0" marginwidth="0" NORESIZE frameborder="0" scrolling="no" src="Calendar"></iframe>');
	</script>

	<table id='taxRatesInfo'>
		<tr>
			<td id="taxRatesInfoCell_1"><label for="taxcategory"><%=taxNLS.getProperty("taxCategories")%></label></td>
			<td id="taxRatesInfoCell_2"><input name="taxcategory" type="text" size="40" id="taxcategory" style="border-style:none" readonly="readonly" disabled="disabled"/></td>
		</tr><tr>
			<td id="taxRatesInfoCell_3"><label for="jurisdictionList"><%=taxNLS.getProperty("taxRatesList_Jurisdiction")%></label></td>
			<td id="taxRatesInfoCell_4"><select name=jurisdictionList id=jurisdictionList class='selectWidth3'
				onchange="dochange(this.options[this.options.selectedIndex].value)">
			</select></td>
		</tr><tr>
			<td id="taxRatesInfoCell_5"><label for="rate"><%=taxNLS.getProperty("taxRatesList_Rate")%></label></td>
			<td id="taxRatesInfoCell_6"><input name="rate" tabindex="1" type="text" size="10" maxlength="10" id="rate" ONBLUR='validateEntry("rate",4,"<%=UIUtil.toJavaScript(taxNLS.getJSProperty("InvalidRateMsg"))%>")'/></td>
		</tr><tr>
		<td id="taxRatesInfoCell_7"><%=taxNLS.getProperty("StartDate")%></td>
		<td id="taxRatesInfoCell_8">
			<table border=0 cellspacing=0 cellpadding=0 id="taxRates_startdate_table">
				<tr>
					<td id="taxRatesInfoCell_8_1"><label for="startyear"><%=taxNLS.getProperty("year")%></label></td>
					<td id="taxRatesInfoCell_8_2">&nbsp;</td>
					<td id="taxRatesInfoCell_8_3"><label for="startmonth"><%=taxNLS.getProperty("month")%></label></td>
					<td id="taxRatesInfoCell_8_4">&nbsp;</td>
					<td id="taxRatesInfoCell_8_5"><label for="startday"><%=taxNLS.getProperty("day")%></label></td>
				</tr>
				<tr>
					<td id="taxRatesInfoCell_8_6"><input type="text" value="" name="startyear" size="4" maxlength="4" id="startyear" /></td>
					<td id="taxRatesInfoCell_8_7"></td>
					<td id="taxRatesInfoCell_8_8"><input type="text" value="" name="startmonth" size="2" maxlength="2" id="startmonth" /></td>
					<td id="taxRatesInfoCell_8_9"></td>
					<td id="taxRatesInfoCell_8_10"><input type="text" value="" name="startday" size="2" maxlength="2" id="startday" /></td>
					<td id="taxRatesInfoCell_8_11">&nbsp;</td>
					<td id="taxRatesInfoCell_8_12">
						<a href="javascript:setupStartDate();showCalendar(document.taxRatesForm.calImgStart);" id="Link_1">
					 	<img src="/wcs/images/tools/calendar/calendar.gif" border="0" id="calImgStart" alt="Start Date"/></a>				
					</td>
					<td id="taxRatesInfoCell_8_13">&nbsp;</td>
					<td id="taxRatesInfoCell_8_14"><input type="text" value="" name="starttime" size="8" maxlength="8" id="starttime" /></td>
					<td id="taxRatesInfoCell_8_15">&nbsp;</td>
					<td id="taxRatesInfoCell_8_16"><label for="starttime"><%=taxNLS.getProperty("timeformat")%></label></td>
					<td id="taxRatesInfoCell_8_17">&nbsp;</td>
					
				</tr>
			</table>
		</td>
		</tr><tr>
		<td id="taxRatesInfoCell_9"><%=taxNLS.getProperty("EndDate")%></td>
		<td id="taxRatesInfoCell_10">
			<table border=0 cellspacing=0 cellpadding=0 id="taxRates_enddate_table">
				<tr>
					<td id="taxRatesInfoCell_10_1"><label for="endyear"><%=taxNLS.getProperty("year")%></label></td>
					<td id="taxRatesInfoCell_10_2">&nbsp;</td>
					<td id="taxRatesInfoCell_10_3"><label for="endmonth"><%=taxNLS.getProperty("month")%></label></td>
					<td id="taxRatesInfoCell_10_4">&nbsp;</td>
					<td id="taxRatesInfoCell_10_5"><label for="endday"><%=taxNLS.getProperty("day")%></label></td>
				</tr>
				<tr>
					<td id="taxRatesInfoCell_10_6"><input type="text" value="" name="endyear" size="4" maxlength="4" id="endyear" /></td>
					<td id="taxRatesInfoCell_10_7"></td>
					<td id="taxRatesInfoCell_10_8"><input type="text" value="" name="endmonth" size="2" maxlength="2" id="endmonth" /></td>
					<td id="taxRatesInfoCell_10_9"></td>
					<td id="taxRatesInfoCell_10_10"><input type="text" value="" name="endday" size="2" maxlength="2" id="endday" /></td>
					
					<td id="taxRatesInfoCell_10_11">&nbsp;</td>
					<td id="taxRatesInfoCell_10_12">
						<a href="javascript:setupEndDate();showCalendar(document.taxRatesForm.calImgEnd);" id="Link_2">
					 	<img src="/wcs/images/tools/calendar/calendar.gif" border="0" id="calImgEnd" alt="End Date"/></a>				
					</td>
					<td id="taxRatesInfoCell_10_13">&nbsp;</td>
					<td id="taxRatesInfoCell_10_14"><input type="text" value="" name="endtime" size="8" maxlength="8" id="endtime" /></td>
					<td id="taxRatesInfoCell_10_15">&nbsp;</td>
					<td id="taxRatesInfoCell_10_16"><label for="endtime"><%=taxNLS.getProperty("timeformat")%></label></td>
					
					<td id="taxRatesInfoCell_10_17">&nbsp;</td>
				</tr>
			</table>
		</td>
		</tr><tr>
			<td id="taxRatesInfoCell_11"><label for="precedence"><%=taxNLS.getProperty("taxRatesList_Priority")%></label></td>
			<td id="taxRatesInfoCell_12"><input name="precedence" type="text" size="10" maxlength="3" id="precedence"  ONBLUR='validateEntry("precedence",1,"<%=UIUtil.toJavaScript(taxNLS.getJSProperty("InvalidPrecedenceMsg"))%>")'/></td>
		</tr>
</table>
</form>
</body>
</html>
