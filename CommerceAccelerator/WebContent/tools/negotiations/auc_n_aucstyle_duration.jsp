
<!-- ========================================================================
 Licensed Materials - Property of IBM

 WebSphere Commerce

 (c) Copyright IBM Corp. 2000, 2002

US Government Users Restricted Rights - Use, duplication or
disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
===========================================================================-->
<%@page import=	"com.ibm.commerce.tools.test.*,
			com.ibm.commerce.tools.util.*,
			com.ibm.commerce.negotiation.beans.*,
			com.ibm.commerce.negotiation.util.*,
			com.ibm.commerce.negotiation.misc.*,
			com.ibm.commerce.negotiation.operation.*,
			com.ibm.commerce.command.*,
			com.ibm.commerce.common.objects.*,
			com.ibm.commerce.utils.*" %>

<%@include file="../common/common.jsp" %>

<HTML>
<HEAD>
<%
	String selectedAuctionType = (String)request.getParameter("autype");

      //*** GET LOCALE FROM COMANDCONTEXT ***//
      CommandContext aCommandContext = (CommandContext)request.getAttribute("CommandContext");    
	Locale   locale_obj = null;
      if( aCommandContext!= null )
            locale_obj = aCommandContext.getLocale();
	if (locale_obj == null)
		locale_obj = new Locale("en","US");

	//*** GET THE RESOURCE BUNDLE BASED ON LOCALE ***//
	Hashtable neg_properties = (Hashtable)ResourceDirectory.lookup("negotiations.negotiationsNLS",locale_obj);
%>

<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
<%@include file="../common/NumberFormat.jsp" %>

<SCRIPT>

// The following values will be accessed from the External Javascript function
// validateAllPanels()
var msgInvalidInteger 	= '<%= UIUtil.toJavaScript((String)neg_properties.get("msgInvalidInteger")) %>';
var msgInvalidTime 	= '<%= UIUtil.toJavaScript((String)neg_properties.get("msgInvalidTime")) %>';
var msgNonNegative 	= '<%= UIUtil.toJavaScript((String)neg_properties.get("msgNegativeNumber")) %>';
var msgInvalidHour 	= '<%= UIUtil.toJavaScript((String)neg_properties.get("msgInvalidHour")) %>';
var msgInvalidMinute 	= '<%= UIUtil.toJavaScript((String)neg_properties.get("msgInvalidMinute")) %>';
var msgDayCompareFailed = '<%= UIUtil.toJavaScript((String)neg_properties.get("msgStartDayEndDayCompare")) %>';
var msgTimeCompareFailed= '<%= UIUtil.toJavaScript((String)neg_properties.get("msgTimeCompare")) %>';
var msgTimeStampCompareFailed= '<%= UIUtil.toJavaScript((String)neg_properties.get("msgSameStartEndTime")) %>';

var ds_auctiontype	= '<%= UIUtil.toJavaScript((String)neg_properties.get("auctionType")) %>';
var ds_austday		= '<%= UIUtil.toJavaScript((String)neg_properties.get("StyleStartDay")) %>';
var ds_auendday		= '<%= UIUtil.toJavaScript((String)neg_properties.get("StyleEndDay")) %>';
var ds_austtim		= '<%= UIUtil.toJavaScript((String)neg_properties.get("StyleStartTime")) %>';
var ds_auendtim		= '<%= UIUtil.toJavaScript((String)neg_properties.get("StyleEndTime")) %>';
var ds_audaydur		= '<%= UIUtil.toJavaScript((String)neg_properties.get("StyleDayDur")) %>';
var ds_auhourdur		= '<%= UIUtil.toJavaScript((String)neg_properties.get("StyleHourDur")) %>';
var ds_aumindur		= '<%= UIUtil.toJavaScript((String)neg_properties.get("StyleMinDur")) %>';

function initializeState()
{
   var code = parent.getErrorParams();
   if (code == "startdayError")
        alertDialog(ds_austday + " : " + msgInvalidInteger);
   else if (code == "startdayNegative")
        alertDialog(ds_austday + " : " + msgNonNegative);
   else if (code == "enddayError")
        alertDialog(ds_auendday + " : " + msgInvalidInteger);
   else if (code == "enddayNegative")
        alertDialog(ds_auendday + " : " + msgNonNegative);
   else if (code == "starttimeError")
        alertDialog(ds_austtim + " : " + msgInvalidTime);
   else if (code == "endtimeError")
        alertDialog(ds_auendtim + " : " + msgInvalidTime);
   else if (code == "hourdurError")
        alertDialog(ds_auhourdur + " : " + msgInvalidHour);
   else if (code == "minutedurError")
        alertDialog(ds_aumindur + " : " + msgInvalidMinute);
   else if (code == "daydurError")
        alertDialog(ds_audaydur + " : " + msgInvalidInteger);
   else if (code == "daydurNegative")
        alertDialog(ds_audaydur + " : " + msgNonNegative);
   else if (code == "daycompareError")
        alertDialog(msgDayCompareFailed);
   else if (code == "timecompareError")
        alertDialog(msgTimeCompareFailed);
   else if (code == "timestampcompareError")
        alertDialog(msgTimeStampCompareFailed);

   parent.setContentFrameLoaded(true);
}

function savePanelData()
{
	var form=document.auctionStyleForm;

	if (parent.get("autype") != "<%= AuctionConstants.EC_AUCTION_DUTCH_TYPE %>") 
	{
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
}

function retrievePanelData(){
  var form = document.auctionStyleForm;

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

  form.austday.value = parent.get("austday_ds","");
  form.austtim.value = parent.get("austtim_ds","");
  form.auendday.value = parent.get("auendday_ds","");
  form.auendtim.value = parent.get("auendtim_ds","");
}

</SCRIPT>
<link rel=stylesheet href="<%= UIUtil.getCSSFile(locale_obj) %>" type="text/css">
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

		<Label>
		<%= neg_properties.get("StyleDurationPrefix") %> 	
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
	<TR>
	<TD>
		<BR><BR>
		<%= neg_properties.get("TimeFormat") %> 	
	</TD>
	</TR>

</TABLE>

</FORM>

<SCRIPT LANGUAGE="Javascript">
	retrievePanelData();
</SCRIPT> 
</BODY>
</HTML>



