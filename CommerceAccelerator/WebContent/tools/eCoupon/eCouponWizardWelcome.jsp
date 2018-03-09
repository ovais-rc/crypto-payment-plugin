<!--==========================================================================
Licensed Materials - Property of IBM

WebSphere Commerce

(c)  Copyright  IBM Corp.  2000      All Rights Reserved

US Government Users Restricted Rights - Use, duplication or
disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
===========================================================================-->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<?xml version="1.0"?>
<%@include file="eCouponCommon.jsp" %>
<%@page import="com.ibm.commerce.price.utils.*" %>
<%@page import="com.ibm.commerce.common.objects.*" %>
<%@page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.utils.TimestampHelper" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="java.util.Date" %>

<%
Timestamp currentTime = new Timestamp(new Date().getTime());
%>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title><%=eCouponWizardNLS.get("eCouponWizardWelcome_title")%></title>
<%= feCouponHeader%>

<script src="/wcs/javascript/tools/common/DateUtil.js">
</script>
<script src="/wcs/javascript/tools/common/Util.js">
</script>

<script language="JavaScript">

// start added for modify coupon promotion

	// get the eCouponDetails object and if it is not null, put its variables in the parent
	// the eCouponDetails object is not null only for modifyCoupon promotion,
      // do updates only if visiting the
	// welcome page for first time, else merchant's modified values will get overwritten
	var first = parent.get("firstVisitToWelcomePage", true);

	var o = parent.get("<%=ECECouponConstant.ECOUPON_DETAILS%>", null);
	if ((o != null) && (o.newECouponPromotion == false))
 	{
	   //alertDialog("ecoupon details not null" + " first is " + first);

	   // parameters for welcome page
	   parent.put("visitedWizWelcome", o.visitedWizWelcome);
	   if(first)
         {
		parent.put("eCouponName", o.ECouponName);
		parent.put("eCouponDesc", o.ECouponDesc);
		parent.put("eCouponStartYear", o.ECouponStartYear);
		parent.put("eCouponStartMonth", o.ECouponStartMonth);
		parent.put("eCouponStartDay", o.ECouponStartDay);
		parent.put("eCouponEndMonth", o.ECouponEndMonth);
		parent.put("eCouponEndYear", o.ECouponEndYear);
		parent.put("eCouponEndDay", o.ECouponEndDay);
		parent.put("eCouponEndTimeSelectedIndex", o.ECouponEndTimeSelectedIndex);
		parent.put("eCouponStartTimeSelectedIndex", o.ECouponStartTimeSelectedIndex);
		parent.put("hasDateTimeRange", o.hasDateTimeRange);

		// parameters for details page
		parent.put("visitedDetailsForm", o.visitedDetailsForm);
		parent.put("eCouponCurr", o.ECouponCurr);
		parent.put("hasNumOffer", o.hasNumOffer);
		parent.put("eCouponNumOffer", o.ECouponNumOffer);
		parent.put("purchaseConditionType", o.purchaseConditionType);

		// parameters for description page
		parent.put("visitedDescriptionForm", o.visitedDescriptionForm);
		parent.put("shortDesc", o.shortDesc);
		parent.put("longDesc", o.longDesc);
		parent.put("thumbNailPath", o.thumbNailPath);
		parent.put("fullImagePath", o.fullImagePath);


		// parameters for order pc type
		parent.put("visitedOrderValueForm", o.visitedOrderValueForm);
		parent.put("visitedOrderPurchaseCondition", o.visitedOrderPurchaseCondition);
		parent.put("minAmt", o.minAmt);
		parent.put("maxAmt", o.maxAmt);
		parent.put("orderType", o.orderType);
		parent.put("orderPercentageAmt", o.orderPercentageAmt);
		parent.put("orderFixedAmt", o.orderFixedAmt);
		parent.put("hasMax", o.hasMax);

		// parameters for product pc type
		parent.put("visitedProductPurchaseForm", o.visitedProductPurchaseForm);
		parent.put("product", o.product);
		parent.put("checkedProducts", o.checkedProducts);
		parent.put("productType", o.productType);
		parent.put("productFixedAmt", o.productFixedAmt);
		parent.put("productPercentageAmt", o.productPercentageAmt);
		parent.put("visitedProductValueForm", o.visitedProductValueForm);

		// parameters for category pc type
		parent.put("visitedCategoryPurchaseForm", o.visitedCategoryPurchaseForm);
		parent.put("category", o.category);
		parent.put("checkedCategorys", o.checkedCategorys);
		parent.put("categoryType", o.categoryType);
		parent.put("categoryFixedAmt", o.categoryFixedAmt);
		parent.put("categoryPercentageAmt", o.categoryPercentageAmt);
		parent.put("visitedCategoryValueForm", o.visitedCategoryValueForm);
		parent.put("catalogId", o.catalogId);

		// make the first visit as false
		parent.put("firstVisitToWelcomePage", false);

		//alertDialog("product type is " + parent.get("productType"));
		//alertDialog("visited is " + parent.get("visitedProductValueForm"));
         }
	}
	else
	{
		//alertDialog("putting new promotion to true");
		parent.put("newECouponPromotion", true);
	}

      // for modfiy coupon promotion, to show panels as per the purchase condition type
      //parent.put("purchaseConditionType",0);
	if (!eval(parent.get("newECouponPromotion")))
	{
      	if(eval(parent.get("purchaseConditionType"))==0) // product
      	{
	    		//alertDialog("Purchase Condtion is product");
          		parent.setPanelAttribute("eCouponProductPurchaseCondition", "hasTab", "YES" );
          		parent.setPanelAttribute("eCouponProductValue", "hasTab", "YES" );
          		parent.TABS.location.reload();
      	}
      	else if(eval(parent.get("purchaseConditionType"))==1) // order
      	{
          		//alertDialog("Purchase Condtion is order");
          		parent.setPanelAttribute("eCouponOrderPurchaseCondition", "hasTab", "YES" );
          		parent.setPanelAttribute("eCouponOrderValue", "hasTab", "YES" );
          		parent.TABS.location.reload();
      	}
		else if(eval(parent.get("purchaseConditionType"))==2) // category
      	{
          		//alertDialog("Purchase Condtion is category");
          		parent.setPanelAttribute("eCouponCategoryPurchaseCondition", "hasTab", "YES" );
          		parent.setPanelAttribute("eCouponCategoryValue", "hasTab", "YES" );
          		parent.TABS.location.reload();
      	}
	}

// end added for modify coupon promotion

function initializeState()
{
	// This is required if we have already entered these data and coming back to this page

	// put hour values into hour selects
	loadeCouponHours();

	var visitedWizWelcome = parent.get("visitedWizWelcome", false);
	if (visitedWizWelcome)  // if we've been here already ...
	{
		// get name & desc
		if (eval(parent.get("newECouponPromotion")))
		{
	 		document.welcomeForm.eCouponName.value = parent.get("eCouponName");
		}
		//document.welcomeForm.eCouponName.value = parent.get("eCouponName");
		document.welcomeForm.eCouponDesc.value = parent.get("eCouponDesc");

		// check if we have a date time range ..
		var hasDateTime=parent.get("hasDateTimeRange",false);
		if (hasDateTime)
		{
			document.welcomeForm.eCouponStartYear.value=parent.get("eCouponStartYear");
			document.welcomeForm.eCouponStartMonth.value=parent.get("eCouponStartMonth");
			document.welcomeForm.eCouponStartDay.value=parent.get("eCouponStartDay");

			document.welcomeForm.eCouponEndYear.value=parent.get("eCouponEndYear");
			document.welcomeForm.eCouponEndMonth.value=parent.get("eCouponEndMonth");
			document.welcomeForm.eCouponEndDay.value=parent.get("eCouponEndDay");

			// select the hour for start & end -- the information is indexed against the
			// select elements
			document.welcomeForm.eCouponStartTimeSelect.selectedIndex = parent.get("eCouponStartTimeSelectedIndex");
			document.welcomeForm.eCouponEndTimeSelect.selectedIndex = parent.get("eCouponEndTimeSelectedIndex");

			document.welcomeForm.hasDateTime[1].checked = true;
			showDateTimeFields();
		}
		else
		{
			document.welcomeForm.hasDateTime[0].checked = true;
		}


		if ((trim(document.welcomeForm.eCouponStartYear.value).length == 0)||(trim(document.welcomeForm.eCouponStartMonth.value).length == 0)||(trim(document.welcomeForm.eCouponStartDay.value).length == 0))
		{
			// default the dates/times
			document.welcomeForm.eCouponStartYear.value=getCurrentYear();
			document.welcomeForm.eCouponStartMonth.value=getCurrentMonth();
			document.welcomeForm.eCouponStartDay.value=getCurrentDay();

			document.welcomeForm.eCouponEndYear.value=getCurrentYear();
			document.welcomeForm.eCouponEndMonth.value=getCurrentMonth();
			document.welcomeForm.eCouponEndDay.value=getCurrentDay();

			document.welcomeForm.eCouponStartTimeSelect.selectedIndex = 0;
			document.welcomeForm.eCouponEndTimeSelect.selectedIndex = 23;
		}

	}
	else
	{


		// default the dates/times
		document.welcomeForm.eCouponStartYear.value=getCurrentYear();
		document.welcomeForm.eCouponStartMonth.value=getCurrentMonth();
		document.welcomeForm.eCouponStartDay.value=getCurrentDay();

		document.welcomeForm.eCouponEndYear.value=getCurrentYear();
		document.welcomeForm.eCouponEndMonth.value=getCurrentMonth();
		document.welcomeForm.eCouponEndDay.value=getCurrentDay();

		document.welcomeForm.eCouponStartTimeSelect.selectedIndex = 0;
		document.welcomeForm.eCouponEndTimeSelect.selectedIndex = 23;

	}

	//alertDialog("before loading frame");
	parent.setContentFrameLoaded(true);
	//alertDialog("loaded frame");

}

function savePanelData()
{
	if (eval(parent.get("newECouponPromotion")))
	{
	 	parent.put("eCouponName", document.welcomeForm.eCouponName.value);
	}
	if (document.welcomeForm.hasDateTime[1].checked)
    	{
    	    parent.put("hasDateTimeRange", true);

	    parent.put("eCouponStartYear",  document.welcomeForm.eCouponStartYear.value);
	    parent.put("eCouponStartMonth",  document.welcomeForm.eCouponStartMonth.value);
	    parent.put("eCouponStartDay",  document.welcomeForm.eCouponStartDay.value);

	    parent.put("eCouponEndYear",  document.welcomeForm.eCouponEndYear.value);
	    parent.put("eCouponEndMonth",  document.welcomeForm.eCouponEndMonth.value);
	    parent.put("eCouponEndDay",  document.welcomeForm.eCouponEndDay.value);

	    parent.put("eCouponStartTimeSelectedIndex",  document.welcomeForm.eCouponStartTimeSelect.selectedIndex);
	    parent.put("eCouponEndTimeSelectedIndex",  document.welcomeForm.eCouponEndTimeSelect.selectedIndex);
    	}
    	else
    		parent.put("hasDateTimeRange", false);

    		// put desc in top frame
    	parent.put("eCouponDesc", document.welcomeForm.eCouponDesc.value);

	// show that we've been here
    	parent.put("visitedWizWelcome", true);

}

function validatePanelData()
{
    	if (eval(parent.get("newECouponPromotion")))
 	{
    		if ( !(document.welcomeForm.eCouponName.value) )
    		{
	    		reprompt(document.welcomeForm.eCouponName, "<%= UIUtil.toJavaScript(eCouponWizardNLS.get("eCouponNameBlankMsg").toString())%>");
	    		return false;
		}
		else if ( !isValidUTF8length(document.welcomeForm.eCouponName.value, 30) )
		{
			reprompt(document.welcomeForm.eCouponName,"<%= UIUtil.toJavaScript(eCouponWizardNLS.get("eCouponFieldTooLong").toString())%>");
			return false;
		}
	}
	if (!isValidUTF8length(document.welcomeForm.eCouponDesc.value, 254))
	{
		reprompt(document.welcomeForm.eCouponDesc,"<%= UIUtil.toJavaScript(eCouponWizardNLS.get("eCouponFieldTooLong").toString())%>");
	    return false;
	}
	else if (document.welcomeForm.hasDateTime[1].checked)
    {
    	var startTime=document.welcomeForm.eCouponStartTimeSelect.selectedIndex+":00";
    	var endTime=document.welcomeForm.eCouponEndTimeSelect.selectedIndex+":00";

		if ( !validDate(document.welcomeForm.eCouponStartYear.value,document.welcomeForm.eCouponStartMonth.value,document.welcomeForm.eCouponStartDay.value))
		{
		    //reprompt(document.welcomeForm.eCouponStartDay,'<%= UIUtil.toJavaScript(eCouponWizardNLS.get("eCouponInvalidStartDateMsg").toString())%>');
		    alertDialog('<%= UIUtil.toJavaScript(eCouponWizardNLS.get("eCouponInvalidStartDateMsg").toString())%>');
		    return false;
		}
		else if ( !validDate(document.welcomeForm.eCouponEndYear.value,document.welcomeForm.eCouponEndMonth.value,document.welcomeForm.eCouponEndDay.value))
		{
		    //reprompt(document.welcomeForm.eCouponEndDay,'<%= UIUtil.toJavaScript(eCouponWizardNLS.get("eCouponInvalidEndDateMsg").toString())%>');
		    alertDialog('<%= UIUtil.toJavaScript(eCouponWizardNLS.get("eCouponInvalidEndDateMsg").toString())%>');
		    return false;
		}

		rc = validateStartEndDateTime(document.welcomeForm.eCouponStartYear.value,document.welcomeForm.eCouponStartMonth.value,document.welcomeForm.eCouponStartDay.value, document.welcomeForm.eCouponEndYear.value,document.welcomeForm.eCouponEndMonth.value,document.welcomeForm.eCouponEndDay.value, startTime, endTime);

		if ((rc==false)||(eval(rc)==-1))
		{
		    alertDialog('<%= UIUtil.toJavaScript(eCouponWizardNLS.get("eCouponNotOrderedMsg").toString())%>');
		    return false;
		}

		// if the coupon promotion starts in the past, confirms with the user
		if (!validateStartEndDateTime("<%= TimestampHelper.getYearFromTimestamp(currentTime) %>",
			"<%= TimestampHelper.getMonthFromTimestamp(currentTime) %>",
			"<%= TimestampHelper.getDayFromTimestamp(currentTime) %>",
			document.welcomeForm.eCouponStartYear.value,
			document.welcomeForm.eCouponStartMonth.value,
			document.welcomeForm.eCouponStartDay.value,
			"0:00", startTime))
		{
			if (!confirmDialog("<%= UIUtil.toJavaScript((String)eCouponWizardNLS.get("eCouponStartInPast")) %>"))
			{
				document.welcomeForm.eCouponStartYear.select();
				document.welcomeForm.eCouponStartYear.focus();
				return false;
			}
		}
    }

    return true;
}

function setupStartDate()
{
	window.yearField = document.welcomeForm.eCouponStartYear;
	window.monthField = document.welcomeForm.eCouponStartMonth;
	window.dayField = document.welcomeForm.eCouponStartDay;
}


function setupEndDate()
{
	window.yearField = document.welcomeForm.eCouponEndYear;
	window.monthField = document.welcomeForm.eCouponEndMonth;
	window.dayField = document.welcomeForm.eCouponEndDay;
}

function hideDateTimeFields()
{
	document.all["dateTimeArea"].style.display = "none";
}

function showDateTimeFields()
{
	document.all["dateTimeArea"].style.display = "block";
}


function loadeCouponHours()
{

	for(var i=0; i<24; i++)
	{
		document.welcomeForm.eCouponStartTimeSelect.options[i] = new Option(i + "<%=UIUtil.toJavaScript((String)eCouponWizardNLS.get("colonZeroZero"))%>", i + "<%=UIUtil.toJavaScript((String)eCouponWizardNLS.get("colonZeroZero"))%>", false, false);
		document.welcomeForm.eCouponEndTimeSelect.options[i] = new Option(i + "<%=UIUtil.toJavaScript((String)eCouponWizardNLS.get("colonZeroZero"))%>", i + "<%=UIUtil.toJavaScript((String)eCouponWizardNLS.get("colonZeroZero"))%>", false, false);
	}

}

// added for modify coupon promotion
function writeECouponName()
{
	//alertDialog("new ecoupon promotion is " + parent.get("newECouponPromotion"));
	if (!eval(parent.get("newECouponPromotion")))
	{
		//alertDialog("in ecoupon name, modify true");
		document.write("<i>");
		document.write('<%=UIUtil.toJavaScript(eCouponWizardNLS.get("eCouponNameLabelWithColon").toString())%>');
		//alertDialog("ecoupon name is " + parent.get("eCouponName"));
		document.write(parent.get("eCouponName"));
		document.write("</i>");
    	}
	else
	{
		//alertDialog("in ecoupon name, create");
		document.write('<%=UIUtil.toJavaScript(eCouponWizardNLS.get("eCouponNameLabel").toString())%>');
		document.write("<br>");
		document.write("<input name=\"eCouponName\" type=\"text\" size=15 maxlength=30 />");
		document.welcomeForm.eCouponName.focus();
	}
}


</script>
</head>

<body class="content" onload="initializeState();">
<script for="document" event="onclick()">
document.all.CalFrame.style.display="none";

</script>
<iframe style="display:none;position:absolute;width:198;height:230" id="CalFrame" title="Calendar Frame" marginheight="0" marginwidth="0" noresize="NORESIZE" frameborder="0" scrolling="no" src="/webapp/wcs/tools/servlet/Calendar">
</iframe>

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

<form name="welcomeForm" id="welcomeForm">

<h1><%=eCouponWizardNLS.get("welcome")%></h1>

<p>
<script language="JavaScript">
writeECouponName();

</script>
</p>

<p><label for="eCouponDesc"><%=eCouponWizardNLS.get("eCouponDescLabel")%></label><br />
<textarea name="eCouponDesc" id="eCouponDesc" rows="5" cols="50" wrap="physical" onkeydown="limitTextArea(this.form.eCouponDesc, 254);" onkeyup="limitTextArea(this.form.eCouponDesc, 254);"></textarea></p>

<p><input name="hasDateTime" type="radio" value="no" onclick="javascript:hideDateTimeFields();" checked ="checked" id="WC_eCouponWizardWelcome_FormInput_hasDateTime_In_welcomeForm_1" /> <label for="WC_eCouponWizardWelcome_FormInput_hasDateTime_In_welcomeForm_1"><%=eCouponWizardNLS.get("eCouponAlways")%></label> <br />
<input name="hasDateTime" type="radio" value="yes" onclick="javascript:showDateTimeFields();" id="WC_eCouponWizardWelcome_FormInput_hasDateTime_In_welcomeForm_2" /> <label for="WC_eCouponWizardWelcome_FormInput_hasDateTime_In_welcomeForm_2"><%=eCouponWizardNLS.get("eCouponHasDateTime")%></label></p>

<div id="dateTimeArea" style="display:none">
<blockquote>

        <table border="0" cellspacing="3" cellpadding="0" id="WC_eCouponWizardWelcome_Table_1">
          <tr align="left" valign="middle">
            <td id="WC_eCouponWizardWelcome_TableCell_1">&nbsp;</td>
            <td id="WC_eCouponWizardWelcome_TableCell_2"><label for="eCouponStartYear"><%=eCouponWizardNLS.get("eCouponYear")%></label></td>
            <td id="WC_eCouponWizardWelcome_TableCell_3">&nbsp;</td>
            <td id="WC_eCouponWizardWelcome_TableCell_4"><label for="eCouponStartMonth"><%=eCouponWizardNLS.get("eCouponMonth")%></label></td>
            <td id="WC_eCouponWizardWelcome_TableCell_5">&nbsp;</td>
            <td id="WC_eCouponWizardWelcome_TableCell_6"><label for="eCouponStartDay"><%=eCouponWizardNLS.get("eCouponDay")%></label></td>
            <td id="WC_eCouponWizardWelcome_TableCell_7">&nbsp;</td>
            <td id="WC_eCouponWizardWelcome_TableCell_8">&nbsp;</td>
            <td id="WC_eCouponWizardWelcome_TableCell_9">&nbsp;</td>
            <td id="WC_eCouponWizardWelcome_TableCell_10">&nbsp;</td>
          </tr>

          <tr>
            <td id="WC_eCouponWizardWelcome_TableCell_11"><%=eCouponWizardNLS.get("startDateLabel")%></td>
            <td id="WC_eCouponWizardWelcome_TableCell_12"><input type="text" value="" name="eCouponStartYear" size="4" maxlength="4" id="eCouponStartYear" /></td>
            <td id="WC_eCouponWizardWelcome_TableCell_13">&nbsp;</td>
            <td id="WC_eCouponWizardWelcome_TableCell_14"><input type="text" value="" name="eCouponStartMonth" size="2" maxlength="2" id="eCouponStartMonth" /></td>
            <td id="WC_eCouponWizardWelcome_TableCell_15">&nbsp;</td>
            <td id="WC_eCouponWizardWelcome_TableCell_16"><input type="text" value="" name="eCouponStartDay" size="2" maxlength="2" id="eCouponStartDay" /></td>
            <td id="WC_eCouponWizardWelcome_TableCell_17">&nbsp;</td>
            <td id="WC_eCouponWizardWelcome_TableCell_18"><a href="javascript:setupStartDate();showCalendar(document.welcomeForm.calImg1);" id="WC_eCouponWizardWelcome_Link_1">
		 	<img src="/wcs/images/tools/calendar/calendar.gif" border="0" id="calImg1" alt='<%=eCouponWizardNLS.get("startDateLabel")%>' /></a></td>
            <td id="WC_eCouponWizardWelcome_TableCell_19">  <label for="eCouponStartTimeSelect"><%=eCouponWizardNLS.get("startTimeLabel")%></label></td>
            <td id="WC_eCouponWizardWelcome_TableCell_20"><select name="eCouponStartTimeSelect" id="eCouponStartTimeSelect"></select></td>
          </tr>

          <tr>
            <td id="WC_eCouponWizardWelcome_TableCell_21"><%=eCouponWizardNLS.get("endDateLabel")%></td>
            <td id="WC_eCouponWizardWelcome_TableCell_22"><label for="eCouponEndYear"></label><input type="text" value="" name="eCouponEndYear" size="4" maxlength="4" id="eCouponEndYear" /></td>
            <td id="WC_eCouponWizardWelcome_TableCell_23"></td>
            <td id="WC_eCouponWizardWelcome_TableCell_24"><label for="eCouponEndMonth"></label><input type="text" value="" name="eCouponEndMonth" size="2" maxlength="2" id="eCouponEndMonth" /></td>
            <td id="WC_eCouponWizardWelcome_TableCell_25"></td>
            <td id="WC_eCouponWizardWelcome_TableCell_26"><label for="eCouponEndDay"></label><input type="text" value="" name="eCouponEndDay" size="2" maxlength="2" id="eCouponEndDay" /></td>
            <td id="WC_eCouponWizardWelcome_TableCell_27">&nbsp;</td>
            <td id="WC_eCouponWizardWelcome_TableCell_28"><a href="javascript:setupEndDate(); showCalendar(document.welcomeForm.calImg2)" id="WC_eCouponWizardWelcome_Link_2">
		 	<img src="/wcs/images/tools/calendar/calendar.gif" border="0" id="calImg2" alt='<%=eCouponWizardNLS.get("endDateLabel")%>' /></a></td>
            <td id="WC_eCouponWizardWelcome_TableCell_29">  <label for="eCouponEndTimeSelect"><%=eCouponWizardNLS.get("endTimeLabel")%></label> </td>
            <td id="WC_eCouponWizardWelcome_TableCell_30"><select name="eCouponEndTimeSelect" id="eCouponEndTimeSelect"></select></td>
          </tr>
        </table>

</blockquote>
</div>
</form>
</body>
</html>


