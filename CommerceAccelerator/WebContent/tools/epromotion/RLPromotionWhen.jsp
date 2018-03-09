<!--
//********************************************************************
//*-------------------------------------------------------------------
//*Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright International Business Machines Corporation. 2002
//*     All rights reserved.
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*--------------------------------------------------------------------
-->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@include file="epromotionCommon.jsp" %>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title><%=RLPromotionNLS.get("RLPromotionWhen_title")%></title>
<%= fPromoHeader%>

<script src="/wcs/javascript/tools/common/DateUtil.js">
</script>
<script src="/wcs/javascript/tools/common/Util.js">
</script>

<script language="JavaScript">

function initializeState()
{
	loadHours();
	if (parent.get) {
		var o = parent.get("<%= RLConstants.RLPROMOTION %>", null);
		var hasDateTime = false;
		var hasTime = false;
		if (o != null) {
			hasDateTime = o.<%= RLConstants.RLPROMOTION_DATERANGED%>;
			if (hasDateTime) 
			{
				document.whenForm.rlStartYear.value=o.<%= RLConstants.RLPROMOTION_STARTYEAR %>;
				document.whenForm.rlStartMonth.value=o.<%= RLConstants.RLPROMOTION_STARTMONTH %>;
				document.whenForm.rlStartDay.value=o.<%= RLConstants.RLPROMOTION_STARTDAY %>;
				document.whenForm.rlEndYear.value=o.<%= RLConstants.RLPROMOTION_ENDYEAR %>;
				document.whenForm.rlEndMonth.value=o.<%= RLConstants.RLPROMOTION_ENDMONTH %>;
				document.whenForm.rlEndDay.value=o.<%= RLConstants.RLPROMOTION_ENDDAY %>;
				document.whenForm.hasDateTime[1].checked = true;
				showDateTimeFields();
			}
			else
			{
				document.whenForm.hasDateTime[0].checked = true;
			}
			if ((trim(document.whenForm.rlStartYear.value).length == 0)||(trim(document.whenForm.rlStartMonth.value).length == 0)||(trim(document.whenForm.rlStartDay.value).length == 0))
			{
				setDateDefaults();
			}

			hasTime = o.<%= RLConstants.RLPROMOTION_TIMERANGED%>;
			if (hasTime) 
			{
				document.whenForm.rlStartTimeSelect.selectedIndex = o.<%= RLConstants.RLPROMOTION_STARTHOUR %>;
				document.whenForm.rlEndTimeSelect.selectedIndex = o.<%= RLConstants.RLPROMOTION_ENDHOUR %>;
				document.whenForm.hasTime[1].checked = true;
				showTimeFields();
			}
			else
			{
				setTimeDefaults();			
				document.whenForm.hasTime[0].checked = true;
			}
			

			var isEverydayFlag = true;
			daysInWeek = o.<%= RLConstants.RLPROMOTION_DAYSINWEEK %>;
			if(daysInWeek.length < 7 && daysInWeek.length != 0)
			{
				isEverydayFlag = false;
			}

			if(isEverydayFlag)
			{
				document.whenForm.isEveryday[0].checked=true;
				hideDayChoice();
			}
			else
			{
				document.whenForm.isEveryday[1].checked=true;
				daysSelected=o.<%= RLConstants.RLPROMOTION_DAYSINWEEK %>;
				loadCheckBoxValues(document.whenForm.daysInWeek, daysSelected);
				showDayChoice();
			}
		}
		else
		{
			setDateDefaults();
			setTimeDefaults();
		}
		parent.setContentFrameLoaded(true);
	}


	if (parent.get("invalidStartDate", false)) {
		parent.remove("invalidStartDate");
		alertDialog('<%= UIUtil.toJavaScript(RLPromotionNLS.get("invalidStartDateMsg").toString())%>');
	      return;
	}
	if (parent.get("invalidEndDate", false)) {
		parent.remove("invalidEndDate");
		alertDialog('<%= UIUtil.toJavaScript(RLPromotionNLS.get("invalidEndDateMsg").toString())%>');
	      return;
	}
	if (parent.get("notOrderedStartEndDate", false)) {
		parent.remove("notOrderedStartEndDate");
		alertDialog('<%= UIUtil.toJavaScript(RLPromotionNLS.get("notOrderedMsg").toString())%>');
	      return;
	}
	if (parent.get("dayNotSelected", false)) {
		parent.remove("dayNotSelected");
		alertDialog('<%= UIUtil.toJavaScript(RLPromotionNLS.get("needADay").toString())%>');
	      return;
	}

}

function savePanelData()
{
	if (parent.get)
	{
		var o = parent.get("<%= RLConstants.RLPROMOTION %>", null);
		if (o != null)
		{
		   	if (document.whenForm.hasDateTime[1].checked)
		   	{
			    o.<%= RLConstants.RLPROMOTION_DATERANGED %>= true;
			    o.<%= RLConstants.RLPROMOTION_STARTYEAR %>=  document.whenForm.rlStartYear.value;
			    o.<%= RLConstants.RLPROMOTION_STARTMONTH %>=  document.whenForm.rlStartMonth.value;
			    o.<%= RLConstants.RLPROMOTION_STARTDAY %>=  document.whenForm.rlStartDay.value;
			    o.<%= RLConstants.RLPROMOTION_ENDYEAR %>=  document.whenForm.rlEndYear.value;
			    o.<%= RLConstants.RLPROMOTION_ENDMONTH %>=  document.whenForm.rlEndMonth.value;
			    o.<%= RLConstants.RLPROMOTION_ENDDAY %>=  document.whenForm.rlEndDay.value;
		   	}
		   	else
		   	{
			    o.<%= RLConstants.RLPROMOTION_DATERANGED %>= false;
		      }

			if (document.whenForm.isEveryday[1].checked)
			{
				o.<%= RLConstants.RLPROMOTION_DAYSINWEEK %>=getCheckBoxValues(document.whenForm.daysInWeek);
				o.<%= RLConstants.RLPROMOTION_ISEVERYDAYFLAG %>= false;
			}
			else
			{
				o.<%= RLConstants.RLPROMOTION_DAYSINWEEK %> = getAllCheckBoxValues(document.whenForm.daysInWeek);
				o.<%= RLConstants.RLPROMOTION_ISEVERYDAYFLAG %>= true;
			}
			
		   	if (document.whenForm.hasTime[1].checked)
		   	{
			    o.<%= RLConstants.RLPROMOTION_TIMERANGED %>= true;
			    o.<%= RLConstants.RLPROMOTION_STARTHOUR %>=  document.whenForm.rlStartTimeSelect.selectedIndex;
			    o.<%= RLConstants.RLPROMOTION_ENDHOUR %>=  document.whenForm.rlEndTimeSelect.selectedIndex;	
		   	}
		   	else
		   	{
			    o.<%= RLConstants.RLPROMOTION_TIMERANGED %>= false;
            }
			
		}
	}
}

function validatePanelData()
{
    if (document.whenForm.hasDateTime[1].checked)
    {
    	var startTime=document.whenForm.rlStartTimeSelect.selectedIndex+"<%=RLPromotionNLS.get("colonZeroZero")%>";
    	var endTime=document.whenForm.rlEndTimeSelect.selectedIndex+"<%=RLPromotionNLS.get("colonZeroZero")%>";
    
		if ( !validDate(document.whenForm.rlStartYear.value,document.whenForm.rlStartMonth.value,document.whenForm.rlStartDay.value))
		{
		    alertDialog('<%= UIUtil.toJavaScript(RLPromotionNLS.get("invalidStartDateMsg").toString())%>');
		    return false;
		}
		else if ( !validDate(document.whenForm.rlEndYear.value,document.whenForm.rlEndMonth.value,document.whenForm.rlEndDay.value))
		{
		    alertDialog('<%= UIUtil.toJavaScript(RLPromotionNLS.get("invalidEndDateMsg").toString())%>');
		    return false;
		}

		rc = validateStartEndDateTime(document.whenForm.rlStartYear.value,document.whenForm.rlStartMonth.value,document.whenForm.rlStartDay.value, document.whenForm.rlEndYear.value,document.whenForm.rlEndMonth.value,document.whenForm.rlEndDay.value, startTime, endTime);
		if ((rc==false)||(eval(rc)==-1))
		{
		    alertDialog('<%= UIUtil.toJavaScript(RLPromotionNLS.get("notOrderedMsg").toString())%>');
		    return false;
		}
    }
    if (document.whenForm.isEveryday[1].checked)
	{
		daysSelected=getCheckBoxValues(document.whenForm.daysInWeek);
		if (daysSelected.length == 0)
		{
		    alertDialog('<%= UIUtil.toJavaScript(RLPromotionNLS.get("needADay").toString())%>');
		    return false;
		}
	}


    return true;
}

function setupStartDate()
{
	window.yearField = document.whenForm.rlStartYear;
	window.monthField = document.whenForm.rlStartMonth;
	window.dayField = document.whenForm.rlStartDay;
}

function setupEndDate()
{
	window.yearField = document.whenForm.rlEndYear;
	window.monthField = document.whenForm.rlEndMonth;
	window.dayField = document.whenForm.rlEndDay;
}

function hideDateTimeFields()
{
	document.all["dateTimeArea"].style.display = "none";
}


function showDateTimeFields()
{
	document.all["dateTimeArea"].style.display = "block";
}

function hideTimeFields()
{
	document.all["timeArea"].style.display = "none";
}

function showTimeFields()
{
	document.all["timeArea"].style.display = "block";
}

function hideDayChoice()
{
	document.all["dayArea"].style.display = "none";
}

function showDayChoice()
{
	document.all["dayArea"].style.display = "block";
}


function getCheckBoxValues(checkBoxes)
{
	var values = new Array();
	var i = 0;
	for (var j = 0; j < checkBoxes.length; j++)
	{
		if (checkBoxes[j].checked)
		{
	    	values[i] = checkBoxes[j].value;
	    	i++;
	    }
	}
	return values;
}

function getAllCheckBoxValues(checkBoxes)
{
	var values = new Array();
	var i = 0;
	for (var j = 0; j < checkBoxes.length; j++)
	{
    	values[i] = checkBoxes[j].value;
    	i++;
	}
	return values;
}

function loadCheckBoxValues(checkBoxes, values)
 {
  for (var i = 0; i < values.length; i++)
   {
    for (var j = 0; j < checkBoxes.length; j++)
     {
      if (checkBoxes[j].value == values[i])
       {
        checkBoxes[j].checked = true;
       }
     }
   }
 }



function loadHours()
{
	for(var i=0; i<24; i++)
	{
		document.whenForm.rlStartTimeSelect.options[i] = new Option(i + "<%=RLPromotionNLS.get("colonZeroZero")%>", i + "<%=RLPromotionNLS.get("colonZeroZero")%>", false, false);
		document.whenForm.rlEndTimeSelect.options[i] = new Option(i + "<%=RLPromotionNLS.get("colonZeroZero")%>", i + "<%=RLPromotionNLS.get("colonZeroZero")%>", false, false);
	}
}

function setDateDefaults()
{
	document.whenForm.rlStartYear.value=getCurrentYear();
	document.whenForm.rlStartMonth.value=getCurrentMonth();
	document.whenForm.rlStartDay.value=getCurrentDay();
	document.whenForm.rlEndYear.value=getCurrentYear();
	document.whenForm.rlEndMonth.value=getCurrentMonth();
	document.whenForm.rlEndDay.value=getCurrentDay();
}

function setTimeDefaults()
{
	document.whenForm.rlStartTimeSelect.selectedIndex = 0;
	document.whenForm.rlEndTimeSelect.selectedIndex = 23;
}



</script>
<meta name="GENERATOR" content="IBM WebSphere Studio" />
</head>

<body class="content" onload="initializeState();">
<!-- ============================================================================
The sample Templates, HTML and Macros are furnished by IBM as simple
examples to provide an illustration. These examples have not been
thoroughly tested under all conditions.  IBM, therefore, cannot guarantee reliability, 
serviceability or function of these programs. All programs contained herein are provided 
to you "AS IS".

The sample Templates, HTML and Macros may include the names of individuals,
companies, brands and products in order to illustrate them as completely as
possible.  All of these are names are ficticious and any similarity to the names
and addresses used by actual persons or business enterprises is entirely coincidental.

Licensed Materials - Property of IBM

5697-D24

(c)  Copyright  IBM Corp.  1997, 1999.      All Rights Reserved

US Government Users Restricted Rights - Use, duplication or 
disclosure restricted by GSA ADP Schedule Contract with IBM Corp

=============================================================================== -->
<script for="document" event="onclick()">
	// document.all.CalFrame.style.display="none";

</script>

<script>
document.writeln('<iframe name="calendar" title="' + top.calendarTitle + '" style="display:none;position:absolute;width:198;height:230;z-index=100" id="CalFrame" marginheight="0" marginwidth="0" NORESIZE frameborder="0" scrolling="no" src="Calendar"></iframe>');
</script>

<form name="whenForm" id="whenForm">

<h1><%=RLPromotionNLS.get("RLPromotionWhen_title")%></h1>

<p><%=RLPromotionNLS.get("whenSubtext")%></p>

<p><input name="isEveryday" type="radio" value="true" onclick="javascript:hideDayChoice();" checked ="checked" id="isEveryday" /> <label for="isEveryday"><%=RLPromotionNLS.get("whenEveryday")%></label> <br />
<input name="isEveryday" type="radio" value="false" onclick="javascript:showDayChoice();" id="isEveryday" /> <label for="isEveryday"><%=RLPromotionNLS.get("whenChoose")%></label></p>

<div id="dayArea" style="display:none">
<blockquote>

<input name="daysInWeek" type="checkbox" value="<%= RLConstants.RLPROMOTION_MONDAY %>" id="WC_RLPromotionWhen_FormInput_daysInWeek_In_whenForm_1" />
<label for="WC_RLPromotionWhen_FormInput_daysInWeek_In_whenForm_1"><%= RLPromotionNLS.get("monday") %></label>
<br />

<input name="daysInWeek" type="checkbox" value="<%= RLConstants.RLPROMOTION_TUESDAY %>" id="WC_RLPromotionWhen_FormInput_daysInWeek_In_whenForm_2" />
<label for="WC_RLPromotionWhen_FormInput_daysInWeek_In_whenForm_2"><%= RLPromotionNLS.get("tuesday") %></label>
<br />

<input name="daysInWeek" type="checkbox" value="<%= RLConstants.RLPROMOTION_WEDNESDAY %>" id="WC_RLPromotionWhen_FormInput_daysInWeek_In_whenForm_3" />
<label for="WC_RLPromotionWhen_FormInput_daysInWeek_In_whenForm_3"><%= RLPromotionNLS.get("wednesday") %></label>
<br />

<input name="daysInWeek" type="checkbox" value="<%= RLConstants.RLPROMOTION_THURSDAY %>" id="WC_RLPromotionWhen_FormInput_daysInWeek_In_whenForm_4" />
<label for="WC_RLPromotionWhen_FormInput_daysInWeek_In_whenForm_4"><%= RLPromotionNLS.get("thursday") %></label>
<br />

<input name="daysInWeek" type="checkbox" value="<%= RLConstants.RLPROMOTION_FRIDAY %>" id="WC_RLPromotionWhen_FormInput_daysInWeek_In_whenForm_5" />
<label for="WC_RLPromotionWhen_FormInput_daysInWeek_In_whenForm_5"><%= RLPromotionNLS.get("friday") %></label>
<br />

<input name="daysInWeek" type="checkbox" value="<%= RLConstants.RLPROMOTION_SATURDAY %>" id="WC_RLPromotionWhen_FormInput_daysInWeek_In_whenForm_6" />
<label for="WC_RLPromotionWhen_FormInput_daysInWeek_In_whenForm_6"><%= RLPromotionNLS.get("saturday") %></label>
<br />

<input name="daysInWeek" type="checkbox" value="<%= RLConstants.RLPROMOTION_SUNDAY %>" id="WC_RLPromotionWhen_FormInput_daysInWeek_In_whenForm_7" />
<label for="WC_RLPromotionWhen_FormInput_daysInWeek_In_whenForm_7"><%= RLPromotionNLS.get("sunday") %></label>
<br />
</blockquote>
</div>


<p><%=RLPromotionNLS.get("dateSubtext")%></p>


<p><input name="hasDateTime" type="radio" value="no" onclick="javascript:hideDateTimeFields();" checked ="checked" id="alwaysInEffect" /> <label for="alwaysInEffect"><%=RLPromotionNLS.get("alwaysInEffect")%></label> <br />
<input name="hasDateTime" type="radio" value="yes" onclick="javascript:showDateTimeFields();" id="hasDateTime" /> <label for="hasDateTime"><%=RLPromotionNLS.get("hasDateTime")%></label></p>

<div id="dateTimeArea" style="display:none">
<blockquote>

        <table border="0" cellspacing="3" cellpadding="0" id="WC_RLPromotionWhen_Table_1">
          <tr align="left" valign="middle">
            <td id="WC_RLPromotionWhen_TableCell_1">&nbsp;</td>
            <td id="WC_RLPromotionWhen_TableCell_2"><%=RLPromotionNLS.get("year")%></td>
            <td id="WC_RLPromotionWhen_TableCell_3">&nbsp;</td>
            <td id="WC_RLPromotionWhen_TableCell_4"><%=RLPromotionNLS.get("month")%></td>
            <td id="WC_RLPromotionWhen_TableCell_5">&nbsp;</td>
            <td id="WC_RLPromotionWhen_TableCell_6"><%=RLPromotionNLS.get("day")%></td>
            <td id="WC_RLPromotionWhen_TableCell_7">&nbsp;</td>
            <td id="WC_RLPromotionWhen_TableCell_8">&nbsp;</td>
            <td id="WC_RLPromotionWhen_TableCell_9">&nbsp;</td>
            <td id="WC_RLPromotionWhen_TableCell_10">&nbsp;</td>
          </tr>

          <tr>
            <td id="WC_RLPromotionWhen_TableCell_11"><%=RLPromotionNLS.get("startDateLabel")%></td>
            <td id="WC_RLPromotionWhen_TableCell_12"><input type="text" value="" name="rlStartYear" size="4" maxlength="4" id="WC_RLPromotionWhen_FormInput_rlStartYear_In_whenForm_1" /><label for="WC_RLPromotionWhen_FormInput_rlStartYear_In_whenForm_1"></label></td>
            <td id="WC_RLPromotionWhen_TableCell_13">&nbsp;</td>
            <td id="WC_RLPromotionWhen_TableCell_14"><input type="text" value="" name="rlStartMonth" size="2" maxlength="2" id="WC_RLPromotionWhen_FormInput_rlStartMonth_In_whenForm_1" /><label for="WC_RLPromotionWhen_FormInput_rlStartMonth_In_whenForm_1"></label></td>
            <td id="WC_RLPromotionWhen_TableCell_15">&nbsp;</td>
            <td id="WC_RLPromotionWhen_TableCell_16"><input type="text" value="" name="rlStartDay" size="2" maxlength="2" id="WC_RLPromotionWhen_FormInput_rlStartDay_In_whenForm_1" /><label for="WC_RLPromotionWhen_FormInput_rlStartDay_In_whenForm_1"></label></td>
            <td id="WC_RLPromotionWhen_TableCell_17">&nbsp;</td>
            <td id="WC_RLPromotionWhen_TableCell_18"><a href="javascript:setupStartDate();showCalendar(document.whenForm.calImgStart);" id="WC_RLPromotionWhen_Link_1">
		 	<img src="/wcs/images/tools/calendar/calendar.gif" border="0" id="calImgStart" alt="Start Date"/></a></td>

          </tr>

          <tr>
            <td id="WC_RLPromotionWhen_TableCell_19"><%=RLPromotionNLS.get("endDateLabel")%></td>
            <td id="WC_RLPromotionWhen_TableCell_20"><input type="text" value="" name="rlEndYear" size="4" maxlength="4" id="WC_RLPromotionWhen_FormInput_rlEndYear_In_whenForm_1" /><label for="WC_RLPromotionWhen_FormInput_rlEndYear_In_whenForm_1"></label></td>
            <td id="WC_RLPromotionWhen_TableCell_21"></td>
            <td id="WC_RLPromotionWhen_TableCell_22"><input type="text" value="" name="rlEndMonth" size="2" maxlength="2" id="WC_RLPromotionWhen_FormInput_rlEndMonth_In_whenForm_1" /><label for="WC_RLPromotionWhen_FormInput_rlEndMonth_In_whenForm_1"></label></td>
            <td id="WC_RLPromotionWhen_TableCell_23"></td>
            <td id="WC_RLPromotionWhen_TableCell_24"><input type="text" value="" name="rlEndDay" size="2" maxlength="2" id="WC_RLPromotionWhen_FormInput_rlEndDay_In_whenForm_1" /><label for="WC_RLPromotionWhen_FormInput_rlEndDay_In_whenForm_1"></label></td>
            <td id="WC_RLPromotionWhen_TableCell_25">&nbsp;</td>
            <td id="WC_RLPromotionWhen_TableCell_26"><a href="javascript:setupEndDate(); showCalendar(document.whenForm.calImgEnd);" id="WC_RLPromotionWhen_Link_2">
		 	<img src="/wcs/images/tools/calendar/calendar.gif" border="0" id="calImgEnd" alt="End Date"/></a></td>

          </tr>
        </table>

</blockquote>
</div>

<p><%=RLPromotionNLS.get("timeSubtext")%></p>

<p><input name="hasTime" type="radio" value="no" onclick="javascript:hideTimeFields();" checked ="checked" id="rlDiscountAllTime" /> <label for="rlDiscountAllTime"><%=RLPromotionNLS.get("rlDiscountAllTime")%></label> <br />
<input name="hasTime" type="radio" value="yes" onclick="javascript:showTimeFields();" id="rlDiscountSelectedTime" /> <label for="rlDiscountSelectedTime"><%=RLPromotionNLS.get("rlDiscountSelectedTime")%></label> </p>

<div id="timeArea" style="display:none">
<blockquote>
        <table border="0" cellspacing="3" cellpadding="0" id="WC_RLPromotionWhen_Table_2">
          <tr align="left" valign="middle">
            <td id="WC_RLPromotionWhen_TableCell_27">  <label for="rlStartTimeSelect"><%=RLPromotionNLS.get("startTimeLabel")%></label></td>
            <td id="WC_RLPromotionWhen_TableCell_28"><select name="rlStartTimeSelect" id="rlStartTimeSelect"></select></td>
            <td id="WC_RLPromotionWhen_TableCell_29">  <label for="rlEndTimeSelect"><%=RLPromotionNLS.get("endTimeLabel")%></label> </td>
            <td id="WC_RLPromotionWhen_TableCell_30"><select name="rlEndTimeSelect" id="rlEndTimeSelect"></select></td>
          </tr>
        </table>
</blockquote>
</div>


</form>
</body>
</html>


