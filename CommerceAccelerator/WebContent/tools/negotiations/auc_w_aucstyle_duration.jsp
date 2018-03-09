<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2014 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<%@page import=	"com.ibm.commerce.tools.test.*,
			com.ibm.commerce.tools.util.*,
			com.ibm.commerce.negotiation.beans.*,
			com.ibm.commerce.negotiation.util.*,
			com.ibm.commerce.negotiation.misc.*,
			com.ibm.commerce.negotiation.operation.*,
			com.ibm.commerce.command.*,
			com.ibm.commerce.common.objects.*" %>

<%@include file="../common/common.jsp" %>

<HTML>
<HEAD>

<%
	String selectedAuctionType = (String)request.getParameter("autype");

      //*** GET LANGID AND LOCALE FROM COMANDCONTEXT ***//
      CommandContext aCommandContext = (CommandContext)request.getAttribute("CommandContext");    
	String   js_lang =  "-1";  
	Locale   locale_obj = null;
      if( aCommandContext!= null ){
            js_lang = aCommandContext.getLanguageId().toString();
		locale_obj  = aCommandContext.getLocale();
      }
	if (locale_obj == null)
		locale_obj = new java.util.Locale("en","US");

	//*** GET THE RESOURCE BUNDLE BASED ON LOCALE ***//
	Hashtable neg_properties= (Hashtable)ResourceDirectory.lookup("negotiations.negotiationsNLS",locale_obj);
%>

<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
<%@include file="../common/NumberFormat.jsp" %>


<SCRIPT>

var msgInvalidInteger		= '<%= UIUtil.toJavaScript((String)neg_properties.get("msgInvalidInteger")) %>';
var msgNegativeNumber		= '<%= UIUtil.toJavaScript((String)neg_properties.get("msgNegativeNumber")) %>';
var msgInvalidTime		= '<%= UIUtil.toJavaScript((String)neg_properties.get("msgInvalidTime")) %>';
var msgInvalidHour		= '<%= UIUtil.toJavaScript((String)neg_properties.get("msgInvalidHour")) %>';
var msgInvalidMinute		= '<%= UIUtil.toJavaScript((String)neg_properties.get("msgInvalidMinute")) %>';
var msgDayCompareFailed		= '<%= UIUtil.toJavaScript((String)neg_properties.get("msgStartDayEndDayCompare")) %>';
var msgTimeCompareFailed	= '<%= UIUtil.toJavaScript((String)neg_properties.get("msgTimeCompare")) %>';
var msgTimeStampCompareFailed	= '<%= UIUtil.toJavaScript((String)neg_properties.get("msgSameStartEndTime")) %>';


function initializeState(){
   parent.setContentFrameLoaded(true);
}

function savePanelData(){
	var form=document.auctionStyleForm;
	if (parent.get("autype") != "<%= AuctionConstants.EC_AUCTION_DUTCH_TYPE %>") {
		for (i=0;i<form.ANDOR.length;i++) {
			if (form.ANDOR[i].checked){
				parent.put("ANDOR",form.ANDOR[i].value);
				break;
			}
		}
		parent.put("audaydur_ds",form.audaydur.value);
		parent.put("auhourdur_ds",form.auhourdur.value);
		parent.put("aumindur_ds",form.aumindur.value);
	}

	parent.put("austday_ds",form.austday.value);
	parent.put("austtim_ds",form.austtim.value);
	parent.put("auendday_ds",form.auendday.value);
	parent.put("auendtim_ds",form.auendtim.value);

	if (parent.get("autype") == "<%= AuctionConstants.EC_AUCTION_DUTCH_TYPE %>")
		parent.put("auruletype","1");
	else {
		var tmflag = 0;
		var durflag = 0;
		if ( 	!isInputStringEmpty(parent.get("auendtim_ds","")) || 		     			!isInputStringEmpty(parent.get("auendday_ds","")))
			tmflag = 1;

		if (	!isInputStringEmpty(parent.get("audaydur_ds",""))  || 
			!isInputStringEmpty(parent.get("auhourdur_ds","")) || 
			!isInputStringEmpty(parent.get("aumindur_ds",""))  )
			durflag = 1;

		if (parent.get("ANDOR") == "AND")
			parent.put("auruletype","4");	
		else {	
			if (tmflag == 0 && durflag == 1)
				parent.put("auruletype","2");
			else if (tmflag == 1 && durflag == 1)
				parent.put("auruletype","3");
			else
				parent.put("auruletype","1");
		}	
	}
	
	parent.addURLParameter("authToken", "${authToken}");
}

function validatePanelData(){  
	var form=document.auctionStyleForm;
	var tempvalue = form.austday.value;
	if (!isInputStringEmpty(tempvalue.toString())) {
		if (!isValidInteger(tempvalue,"<%= js_lang %>")){
			reprompt(form.austday,msgInvalidInteger)
			return false  
		}
		var p_stday = strToNumber(tempvalue, "<%= js_lang %>")
		if (parseInt(p_stday) < 0) {
			reprompt(form.austday,msgNegativeNumber)
			return false
		}
		parent.put("austday",p_stday); 
	} else 
		parent.put("austday","");

 	tempvalue = form.austtim.value;
	var temp = null;
	var input_time = null;
 	if (!isInputStringEmpty(tempvalue)) {
		input_time = tempvalue;
		temp = validTime(input_time);
		if (!temp || temp == "false"){
	    		reprompt(form.austtim , msgInvalidTime)
    			return false  
 		}
		parent.put("austtim",input_time + ":00");
 	}else
		parent.put("austtim","");

 	tempvalue = form.auendday.value;
	if (!isInputStringEmpty(tempvalue)) {
		if (!isValidInteger(tempvalue,"<%= js_lang %>")){
			reprompt(form.auendday,msgInvalidInteger)
			return false  
		}
		var p_endday = strToNumber(tempvalue, "<%= js_lang %>")
		if (parseInt(p_endday) < 0) {
			reprompt(form.auendday,msgNegativeNumber)
			return false
		}
		parent.put("auendday",p_endday); 
	} else 
		parent.put("auendday",""); 

	tempvalue = form.auendtim.value;
	var temp = null;
	var input_time = null;
 	if (!isInputStringEmpty(tempvalue)) {
		input_time = tempvalue;
		temp = validTime(input_time);

		if (!temp || temp == "false"){
			reprompt(form.auendtim , msgInvalidTime)
			return false  
		}
		parent.put("auendtim",input_time + ":00");
 	}else
		parent.put("auendtim","");

	tempvalue = form.audaydur.value;
	if (!isInputStringEmpty(tempvalue)) {
		if (!isValidInteger(tempvalue,"<%= js_lang %>")){
	    		reprompt(form.audaydur,msgInvalidInteger)
    			return false  
		}
		var p_daydur = strToNumber(tempvalue, "<%= js_lang %>")
		if (parseInt(p_daydur) < 0) {
			reprompt(form.audaydur,msgNegativeNumber)
			return false
		}
		parent.put("audaydur",p_daydur); 
	} else 
		parent.put("audaydur","");

	 tempvalue = form.auhourdur.value;
	 var p_hour="00";
	 var p_min = "00";
	 var p_sec = "00";
	 if (!isInputStringEmpty(tempvalue)) {
		if (!isValidInteger(tempvalue,"<%= js_lang %>")){
	    		reprompt(form.auhourdur,msgInvalidInteger)
    			return false  
 		}
		var p_hourdur = strToNumber(tempvalue, "<%= js_lang %>")
		if (parseInt(p_hourdur) > 23){
			reprompt(form.auhourdur,msgInvalidHour)
			return false  
		}
		p_hour = form.auhourdur.value;	
	}


	 tempvalue = form.aumindur.value;
	 if (!isInputStringEmpty(tempvalue)) {
		if (!isValidInteger(tempvalue,"<%= js_lang %>")){
	    		reprompt(form.aumindur,msgInvalidInteger)
    			return false  
 		}
		var p_mindur = strToNumber(tempvalue, "<%= js_lang %>")
		if (parseInt(p_mindur) > 59){
    			reprompt(form.aumindur,msgInvalidMinute)
	    		return false  
 		}
		p_min = form.aumindur.value;
 	}

	if (p_hour != "00" || p_min != "00")
	{
		var p_time = p_hour + ":" + p_min + ":" + "00";
		parent.put("autimdur",p_time);
	} else
		parent.put("autimdur","");
	

	if (daytimeCompare(form))
		return true;
	else
		return false;
}

function daytimeCompare(form){
	var startday   = form.austday.value;
	var endday     = form.auendday.value;
	var starttime  = form.austtim.value;
	var endtime    = form.auendtim.value;
	var startArray = new Array(3);
	var endArray   = new Array(3);

	// Only-one-day/No-day is specified. Return true, no comparisons are possible
	if ( isInputStringEmpty(startday) || isInputStringEmpty(endday) ) 
		return true;
   
	// Both days specified. Check for startday <= endday
	// If endday > startday, return true. No need for time comparisons.
	if (!isInputStringEmpty(startday) && !isInputStringEmpty(endday)){
		if (strToNumber(startday,"<%= js_lang %>")  > strToNumber(endday,"<%= js_lang %>")) {
    			reprompt(form.austday,msgDayCompareFailed)
    			return false
		}
		if (strToNumber(startday,"<%= js_lang %>") != strToNumber(endday,"<%= js_lang %>")) 
			return true;
   	}

	// Both times are specified and days are equal
	if (!isInputStringEmpty(starttime) && !isInputStringEmpty(endtime)){
		var hh1 = starttime.substring(0,starttime.indexOf(":"));
		var mm1 = starttime.substring(starttime.indexOf(":") + 1);
		var hh2 = endtime.substring(0,endtime.indexOf(":"));
		var mm2 = endtime.substring(endtime.indexOf(":") + 1);
	
		if (parseInt(hh2) > parseInt(hh1)) 
			return true;
		if (parseInt(hh2) < parseInt(hh1)) 
		{
			reprompt(form.austtim,msgTimeCompareFailed);
			return false;
		}
		if (parseInt(mm2) > parseInt(mm1)) 
			return true;
		if (parseInt(mm2) < parseInt(mm1)) 
		{
			reprompt(form.austtim,msgTimeCompareFailed);
			return false;
		}

		// both times are equal. Disallow it, as both days are equal too.
		reprompt(form.austday,msgTimeStampCompareFailed);
		return false;
   	}
	return true;
}

function retrievePanelData(){
	var form = document.auctionStyleForm;
	form.austday.value = parent.get("austday_ds","");
	form.austtim.value = parent.get("austtim_ds","");
	form.auendday.value = parent.get("auendday_ds","");
	form.auendtim.value = parent.get("auendtim_ds","");

	// Fill in the rest of the fields for a non-dutch auction type
	if (parent.get("autype") != "<%= AuctionConstants.EC_AUCTION_DUTCH_TYPE %>") 
	{
		form.audaydur.value = parent.get("audaydur_ds","");
		form.auhourdur.value = parent.get("auhourdur_ds","");
		form.aumindur.value = parent.get("aumindur_ds","");
		var selectedANDORoption = parent.get("ANDOR","OR");
		for (i=0;i<form.ANDOR.length;i++) {
			if (form.ANDOR[i].value == selectedANDORoption){
				form.ANDOR[i].click();
				break;
			}
		}
	}
}

</SCRIPT>
<link rel="stylesheet" href="<%= UIUtil.getCSSFile(locale_obj) %>" type="text/css">

</HEAD>

<BODY class=content ONLOAD="initializeState();">
<BR><h1><%= neg_properties.get("AStyleDuration") %></h1>

<FORM NAME="auctionStyleForm">
 <TABLE>
		<TR>
		          <TD>
				<Label for="startday">
				   <%= neg_properties.get("StyleStartsDatePrefix") %> 	
				</Label>
		          </TD>
		 </TR>
		<TR>
		          <TD width=100%>
				<Label for="startday">
				   &nbsp;&nbsp;<%= neg_properties.get("StyleStartsDateSuffix") %> 	
				</Label>
		          </TD>
		 </TR>

		 <TR>
			  <TD>
		      	    <INPUT size="5" type="input" name="austday" id="startday">
			  </TD>
		 </TR>
		 <TR>	  
			  <TD>
				<Label for="starttime">
				&nbsp;&nbsp;<%= neg_properties.get("StyleStartsTimePrefix") %>
				</Label>
			  </TD>
		 </TR>
		 <TR>	
			<TD>
		      	<INPUT size="5" type="input" name="austtim" maxlength="5" id="starttime">
			</TD>
		</TR>
		<TR>
			<TD>
				<Label for="endday">
				<%= neg_properties.get("StyleEndsDatePrefix") %>
				</Label>
			</TD>
		</TR>	
		<TR>
			<TD width=100%>
				<Label for="endday">
				   &nbsp;&nbsp;<%= neg_properties.get("StyleEndsDateSuffix") %> 	
				</Label>
			</TD>
		</TR>	

		<TR>
			<TD> 	
		      	<INPUT size="5" type="input" name="auendday" id="endday">
			</TD>
		</TR>
		<TR>
			<TD>
				<Label for="endtime">
				&nbsp;&nbsp;<%= neg_properties.get("StyleEndsTimePrefix") %>
				</Label>
			</TD>
		</TR>
		<TR>
			<TD>
		      	<INPUT size="5" type="input" name="auendtim" maxlength="5" id="endtime">
			</TD>
		</TR>

<% 	if (!selectedAuctionType.equals(AuctionConstants.EC_AUCTION_DUTCH_TYPE)) {
%>
	<TR>
	<TD WIDTH=400 ALIGN=CENTER>
		<Label for="And">
      	<INPUT TYPE="radio" NAME="ANDOR" VALUE="AND" id="And" CHECKED><%= neg_properties.get("And") %>
		</Label>
		<Label for="Or">
      	<INPUT TYPE="radio" NAME="ANDOR" VALUE="OR" id="Or"><%= neg_properties.get("Or") %>
		</Label>
	</TD>
	</TR>
	<TR>
	<TD>
		<%= neg_properties.get("StyleDurationPrefix") %> 	
		<Label>
      	<INPUT size="5" type="input" name="audaydur"> <%= neg_properties.get("days") %>
		</Label>
		<Label>
      	<INPUT size="2" type="input" name="auhourdur" maxlength="2"> <%= neg_properties.get("hours") %>
		</Label>
		<Label>
      	<INPUT size="2" type="input" name="aumindur" maxlength="2"> <%= neg_properties.get("minutes") %> 
		<%= neg_properties.get("StyleDurationSuffix") %>
		</Label>

	</TD>
	</TR>
<% } else {
%>
	<INPUT TYPE="HIDDEN" NAME="audaydur" VALUE="">
	<INPUT TYPE="HIDDEN" NAME="auhourdur" VALUE="">
	<INPUT TYPE="HIDDEN" NAME="aumindur" VALUE="">
<% }
%>

</TABLE>
	<BR><%= neg_properties.get("TimeFormat") %> 	

</FORM>
<SCRIPT LANGUAGE="Javascript">
	retrievePanelData();
</SCRIPT> 
</BODY>
</HTML>



