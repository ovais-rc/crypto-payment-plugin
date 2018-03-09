<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

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
<%@include file="epromotionCommon.jsp" %>
<%@page import="com.ibm.commerce.price.utils.*" %>
<%@page import="com.ibm.commerce.common.objects.*" %>
<%@page import="com.ibm.commerce.tools.epromotion.util.EproUtil"%>

<%
	StoreAccessBean storeAB = com.ibm.commerce.server.WcsApp.storeRegistry.find(fStoreId);
	String defCurr= CurrencyManager.getInstance().getDefaultCurrency(storeAB);
    String calCodeId =  request.getParameter("calcodeId");
    String userId = commContext.getUserId().toString();
%>

<%!
    static final int NUMOFVISIBLEITEMSINLIST= 5;
%>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title><%=RLPromotionNLS.get("RLPromotionProperties_title")%></title>
<%= fPromoHeader%>

<jsp:useBean id="memberGroupList" scope="request" class="com.ibm.commerce.tools.promotions.CustomerGroupDataBean">
</jsp:useBean>
<%
	memberGroupList.setMemberGroupTypeId(new Integer(-1));
	com.ibm.commerce.beans.DataBeanManager.activate(memberGroupList, request);
%>

<style type='text/css'>
.selectWidth {width: 235px;}
</style>

<script src="/wcs/javascript/tools/common/DateUtil.js"></script>
<script src="/wcs/javascript/tools/common/Util.js"></script>
<script language="JavaScript1.2" src="/wcs/javascript/tools/common/SwapList.js"></script>

<script language="JavaScript">
	var calCodeId = null;
	var lastType = 0;
	var lastGroup = 0;
	var currType = 0;
	var currGroup = 0;
	var version = 0;
	var revision = 0;
	var promoStatus = 0;
	var promotionType = null;

</script>

<script language="JavaScript" for="document" event="onclick()">
<!-- hide script from old browsers
document.all.CalFrame.style.display = "none";
//-->
</script>

<%
if(calCodeId != null && !(calCodeId.trim().equals("")))
{
%>
<script language="JavaScript">
	calCodeId = <%=(calCodeId == null ? null : UIUtil.toJavaScript(calCodeId))%>;
</script>
<%
}
%>


<script language="JavaScript">
var languageId = '<%=fLanguageId%>';
parent.put("languageId",languageId);

if (parent.get) {
	var o = parent.get("<%= RLConstants.RLPROMOTION %>", null);
	if (o != null) {
		if( calCodeId != null && calCodeId != '')
		{
		    if (o.<%= RLConstants.RLPROMOTION_TYPE %> == "<%= RLConstants.RLPROMOTION_ORDERLEVELPERCENTDISCOUNT %>") {
	      	parent.setPanelAttribute( "RLDiscountWizardRanges", "hasTab", "YES" );
			var ranges = o.<%= RLConstants.RLPROMOTION_RANGES %>;
			var values = o.<%= RLConstants.RLPROMOTION_VALUES %>;			
			if(ranges.length < 2 || (ranges.length == 2 && eval(values[0]) == 0) ) 
	      	parent.setPanelAttribute( "RLDiscountPercentType", "hasTab", "YES" );
                  parent.reloadFrames();
		    }	else if (o.<%= RLConstants.RLPROMOTION_TYPE %> == "<%= RLConstants.RLPROMOTION_ORDERLEVELVALUEDISCOUNT %>"){
	      	parent.setPanelAttribute( "RLDiscountWizardRanges", "hasTab", "YES" );
			var ranges = o.<%= RLConstants.RLPROMOTION_RANGES %>;
			var values = o.<%= RLConstants.RLPROMOTION_VALUES %>;			
			if(ranges.length < 2 || (ranges.length == 2 && eval(values[0]) == 0) ) 
	      	parent.setPanelAttribute( "RLDiscountFixedType", "hasTab", "YES" );
                  parent.reloadFrames();
		    }	else if (o.<%= RLConstants.RLPROMOTION_TYPE %> == "<%= RLConstants.RLPROMOTION_ORDERLEVELFIXEDSHIPPINGDISCOUNT %>"){
	      	parent.setPanelAttribute( "RLDiscountShippingType", "hasTab", "YES" );
                  parent.reloadFrames();
		    }	else if (o.<%= RLConstants.RLPROMOTION_TYPE %> == "<%= RLConstants.RLPROMOTION_ORDERLEVELFREEGIFT %>"){
	      	parent.setPanelAttribute( "RLDiscountGWPType", "hasTab", "YES" );
                  parent.reloadFrames();
		    }	else if (o.<%= RLConstants.RLPROMOTION_TYPE %> == "<%= RLConstants.RLPROMOTION_ITEMLEVELPERCENTDISCOUNT %>" || o.<%= RLConstants.RLPROMOTION_TYPE %> == "<%= RLConstants.RLPROMOTION_PRODUCTLEVELPERCENTDISCOUNT %>" || o.<%= RLConstants.RLPROMOTION_TYPE %> == "<%= RLConstants.RLPROMOTION_CATEGORYLEVELPERCENTDISCOUNT %>"){
		    parent.setPanelAttribute( "RLProdPromoWhat", "hasTab", "YES");
	      	parent.setPanelAttribute( "RLProdPromoWizardRanges", "hasTab", "YES" );
			var ranges = o.<%= RLConstants.RLPROMOTION_RANGES %>;
			var values = o.<%= RLConstants.RLPROMOTION_VALUES %>;
			if(ranges.length < 2 || (ranges.length == 2 && eval(values[0]) == 0) )
	      	parent.setPanelAttribute( "RLProdPromoPercentType", "hasTab", "YES" );
                  parent.reloadFrames();
		    }	else if (o.<%= RLConstants.RLPROMOTION_TYPE %> == "<%= RLConstants.RLPROMOTION_ITEMLEVELPERITEMVALUEDISCOUNT %>" || o.<%= RLConstants.RLPROMOTION_TYPE %> == "<%= RLConstants.RLPROMOTION_PRODUCTLEVELPERITEMVALUEDISCOUNT %>" || o.<%= RLConstants.RLPROMOTION_TYPE %> == "<%= RLConstants.RLPROMOTION_CATEGORYLEVELPERITEMVALUEDISCOUNT %>"){
		    parent.setPanelAttribute( "RLProdPromoWhat", "hasTab", "YES");
	      	parent.setPanelAttribute( "RLProdPromoWizardRanges", "hasTab", "YES" );
			var ranges = o.<%= RLConstants.RLPROMOTION_RANGES %>;
			var values = o.<%= RLConstants.RLPROMOTION_VALUES %>;			
			if(ranges.length < 2 || (ranges.length == 2 && eval(values[0]) == 0) )
	      	parent.setPanelAttribute( "RLProdPromoFixedType", "hasTab", "YES" );
                  parent.reloadFrames();
		    }	else if (o.<%= RLConstants.RLPROMOTION_TYPE %> == "<%= RLConstants.RLPROMOTION_ITEMLEVELVALUEDISCOUNT %>" || o.<%= RLConstants.RLPROMOTION_TYPE %> == "<%= RLConstants.RLPROMOTION_PRODUCTLEVELVALUEDISCOUNT %>" || o.<%= RLConstants.RLPROMOTION_TYPE %> == "<%= RLConstants.RLPROMOTION_CATEGORYLEVELVALUEDISCOUNT %>"){
		    parent.setPanelAttribute( "RLProdPromoWhat", "hasTab", "YES");
	      	parent.setPanelAttribute( "RLProdPromoWizardRanges", "hasTab", "YES" );
			var ranges = o.<%= RLConstants.RLPROMOTION_RANGES %>;
			var values = o.<%= RLConstants.RLPROMOTION_VALUES %>;			
			if(ranges.length < 2 || (ranges.length == 2 && eval(values[0]) == 0) )
	      	parent.setPanelAttribute( "RLProdPromoFixedType", "hasTab", "YES" );
                  parent.reloadFrames();
		    }	else if (o.<%= RLConstants.RLPROMOTION_TYPE %> == "<%= RLConstants.RLPROMOTION_ITEMLEVELSAMEITEMPERCENTDISCOUNT %>" || o.<%= RLConstants.RLPROMOTION_TYPE %> == "<%= RLConstants.RLPROMOTION_PRODUCTLEVELSAMEITEMPERCENTDISCOUNT %>" || o.<%= RLConstants.RLPROMOTION_TYPE %> == "<%= RLConstants.RLPROMOTION_CATEGORYLEVELSAMEITEMPERCENTDISCOUNT %>"){
		    parent.setPanelAttribute( "RLProdPromoWhat", "hasTab", "YES");
	      	parent.setPanelAttribute( "RLProdPromoBXGYType", "hasTab", "YES" );
                  parent.reloadFrames();
		    }	else if (o.<%= RLConstants.RLPROMOTION_TYPE %> == "<%= RLConstants.RLPROMOTION_ITEMLEVELBUYXGETYFREE %>" || o.<%= RLConstants.RLPROMOTION_TYPE %> == "<%= RLConstants.RLPROMOTION_PRODUCTLEVELBUYXGETYFREE %>" || o.<%= RLConstants.RLPROMOTION_TYPE %> == "<%= RLConstants.RLPROMOTION_CATEGORYLEVELBUYXGETYFREE %>"){
		    parent.setPanelAttribute( "RLProdPromoWhat", "hasTab", "YES");
	      	parent.setPanelAttribute( "RLProdPromoGWPType", "hasTab", "YES" );
                  parent.reloadFrames();
		    }
		}
		else
		{
	      	parent.setPanelAttribute( "RLProdPromoWizardRanges", "hasTab", "NO" );
	      	parent.setPanelAttribute( "RLDiscountWizardRanges", "hasTab", "NO" );
            parent.reloadFrames();
		}
	}
}


function initializeState()
{
	initializeCurrency();
	initializePromotionGroup();
	initializePromotionType();
	initializeInCombination();
	initializeSloshBuckets(document.propertiesForm.allShopperGroup, document.propertiesForm.addButton, document.propertiesForm.definedShopperGroup, document.propertiesForm.removeButton);
	initializeSummaryButton(document.propertiesForm.allShopperGroup, document.propertiesForm.definedShopperGroup, document.propertiesForm.summaryButton);	
	initializeRedemption();
	initializePromotionAvailability();
	initializeCustomerSegment();
	initializePriority();
	var fromSegmentSummaryPage = top.get("fromSegmentSummaryPage");
	// If the user has returned from segment summary page., get RLPromotion object 
	// from top and put it in parent
	if(fromSegmentSummaryPage != 'undefined' && fromSegmentSummaryPage == true)
	{
		top.put("fromSegmentSummaryPage", false);
		var rlPromo = top.getData("RLPromotion");
		parent.put("<%= RLConstants.RLPROMOTION %>", rlPromo);			
	}
		
	if (parent.get) {
	var o = parent.get("<%= RLConstants.RLPROMOTION %>", null);
	var targetSalesNumber = 0;
		if (o != null) {
			document.propertiesForm.rlName.value = o.<%= RLConstants.RLPROMOTION_NAME %>;
			document.propertiesForm.rlDesc.value = o.<%= RLConstants.RLPROMOTION_DESCRIPTION %>;
			document.propertiesForm.rlDescNL.value = o.<%= RLConstants.RLPROMOTION_DESCRIPTION_NL %>;
			document.propertiesForm.rlDescLongNL.value =  o.<%= RLConstants.RLPROMOTION_DESCRIPTION_LONG_NL %>;
			version = o.<%= RLConstants.RLPROMOTION_VERSION %>;
			revision = o.<%= RLConstants.RLPROMOTION_REVISION %>;
			promoStatus = o.<%= RLConstants.RLPROMOTION_STATUS %>;
			promotionType = o.<%= RLConstants.RLPROMOTION_TYPE %>;
		    if (o.<%= RLConstants.RLPROMOTION_TYPE %> == "<%= RLConstants.RLPROMOTION_ORDERLEVELPERCENTDISCOUNT %>") {
			    document.propertiesForm.rlPromotionGroup.options[1].selected = true;
			    refreshPromoTypeAndCombinationFields(document.propertiesForm.rlPromotionGroup);
   			    document.propertiesForm.rlPromotionType.options[0].selected = true;
   			    lastGroup = 1;
   			    lastType = 0;
		    }	else if (o.<%= RLConstants.RLPROMOTION_TYPE %> == "<%= RLConstants.RLPROMOTION_ORDERLEVELVALUEDISCOUNT %>"){
			    document.propertiesForm.rlPromotionGroup.options[1].selected = true;
			    refreshPromoTypeAndCombinationFields(document.propertiesForm.rlPromotionGroup);			    
   			    document.propertiesForm.rlPromotionType.options[1].selected = true;
   			    lastGroup = 1;
   			    lastType = 1;
		    }	else if (o.<%= RLConstants.RLPROMOTION_TYPE %> == "<%= RLConstants.RLPROMOTION_ORDERLEVELFIXEDSHIPPINGDISCOUNT %>"){
		    	
				    document.propertiesForm.rlPromotionGroup.options[2].selected = true;
				    refreshPromoTypeAndCombinationFields(document.propertiesForm.rlPromotionGroup);			    
   				    document.propertiesForm.rlPromotionType.options[0].selected = true;
	   			    lastGroup = 2;
   				    lastType = 0;
   				
		    }	else if (o.<%= RLConstants.RLPROMOTION_TYPE %> == "<%= RLConstants.RLPROMOTION_ORDERLEVELFREEGIFT %>"){
			    document.propertiesForm.rlPromotionGroup.options[1].selected = true;
			    refreshPromoTypeAndCombinationFields(document.propertiesForm.rlPromotionGroup);			    
   			    document.propertiesForm.rlPromotionType.options[2].selected = true;
   			    lastGroup = 1;
   			    lastType = 2;
		    }	else if (o.<%= RLConstants.RLPROMOTION_TYPE %> == "<%= RLConstants.RLPROMOTION_ITEMLEVELPERCENTDISCOUNT %>" || o.<%= RLConstants.RLPROMOTION_TYPE %> == "<%= RLConstants.RLPROMOTION_PRODUCTLEVELPERCENTDISCOUNT %>" || o.<%= RLConstants.RLPROMOTION_TYPE %> == "<%= RLConstants.RLPROMOTION_CATEGORYLEVELPERCENTDISCOUNT %>"){
			    document.propertiesForm.rlPromotionGroup.options[0].selected = true;
			    refreshPromoTypeAndCombinationFields(document.propertiesForm.rlPromotionGroup);			    
   			    document.propertiesForm.rlPromotionType.options[0].selected = true;
   			    lastGroup = 0;
   			    lastType = 0;
		    }	else if (o.<%= RLConstants.RLPROMOTION_TYPE %> == "<%= RLConstants.RLPROMOTION_ITEMLEVELPERITEMVALUEDISCOUNT %>" || o.<%= RLConstants.RLPROMOTION_TYPE %> == "<%= RLConstants.RLPROMOTION_PRODUCTLEVELPERITEMVALUEDISCOUNT %>" || o.<%= RLConstants.RLPROMOTION_TYPE %> == "<%= RLConstants.RLPROMOTION_CATEGORYLEVELPERITEMVALUEDISCOUNT %>"){
			    document.propertiesForm.rlPromotionGroup.options[0].selected = true;
			    refreshPromoTypeAndCombinationFields(document.propertiesForm.rlPromotionGroup);			    
   			    document.propertiesForm.rlPromotionType.options[1].selected = true;
   			    lastGroup = 0;
   			    lastType = 1;
		    }	else if (o.<%= RLConstants.RLPROMOTION_TYPE %> == "<%= RLConstants.RLPROMOTION_ITEMLEVELVALUEDISCOUNT %>" || o.<%= RLConstants.RLPROMOTION_TYPE %> == "<%= RLConstants.RLPROMOTION_PRODUCTLEVELVALUEDISCOUNT %>" || o.<%= RLConstants.RLPROMOTION_TYPE %> == "<%= RLConstants.RLPROMOTION_CATEGORYLEVELVALUEDISCOUNT %>"){
			    document.propertiesForm.rlPromotionGroup.options[0].selected = true;
			    refreshPromoTypeAndCombinationFields(document.propertiesForm.rlPromotionGroup);			    
   			    document.propertiesForm.rlPromotionType.options[2].selected = true;
   			    lastGroup = 0;
   			    lastType = 2;
		    }	else if (o.<%= RLConstants.RLPROMOTION_TYPE %> == "<%= RLConstants.RLPROMOTION_ITEMLEVELSAMEITEMPERCENTDISCOUNT %>" || o.<%= RLConstants.RLPROMOTION_TYPE %> == "<%= RLConstants.RLPROMOTION_PRODUCTLEVELSAMEITEMPERCENTDISCOUNT %>" || o.<%= RLConstants.RLPROMOTION_TYPE %> == "<%= RLConstants.RLPROMOTION_CATEGORYLEVELSAMEITEMPERCENTDISCOUNT %>"){
			    document.propertiesForm.rlPromotionGroup.options[0].selected = true;
			    refreshPromoTypeAndCombinationFields(document.propertiesForm.rlPromotionGroup);			    
   			    document.propertiesForm.rlPromotionType.options[3].selected = true;
   			    lastGroup = 0;
   			    lastType = 3;
		    }	else if (o.<%= RLConstants.RLPROMOTION_TYPE %> == "<%= RLConstants.RLPROMOTION_ITEMLEVELBUYXGETYFREE %>" || o.<%= RLConstants.RLPROMOTION_TYPE %> == "<%= RLConstants.RLPROMOTION_PRODUCTLEVELBUYXGETYFREE %>" || o.<%= RLConstants.RLPROMOTION_TYPE %> == "<%= RLConstants.RLPROMOTION_CATEGORYLEVELBUYXGETYFREE %>"){
			    document.propertiesForm.rlPromotionGroup.options[0].selected = true;
			    refreshPromoTypeAndCombinationFields(document.propertiesForm.rlPromotionGroup);			    
   			    document.propertiesForm.rlPromotionType.options[4].selected = true;
   			    lastGroup = 0;
   			    lastType = 4;
		    }
			if(o.<%= RLConstants.RLPROMOTION_GROUP_NAME %> == '<%= RLConstants.RLPROMOTION_PRODUCT_GROUP %>')
			{
				document.propertiesForm.inCombination.options[o.<%= RLConstants.RLPROMOTION_EXCLUSIVENESS %>].selected = true;		   		
			}
			else if(o.<%= RLConstants.RLPROMOTION_GROUP_NAME %> == '<%= RLConstants.RLPROMOTION_ORDER_GROUP %>')
			{
					if(o.<%= RLConstants.RLPROMOTION_EXCLUSIVENESS %> == 3)
					{
			   			document.propertiesForm.inCombination.options[2].selected = true;
			   		}
			   		else
			   		{
			   			document.propertiesForm.inCombination.options[o.<%= RLConstants.RLPROMOTION_EXCLUSIVENESS %>].selected = true;
			   		}		   		
			}
			else if(o.<%= RLConstants.RLPROMOTION_GROUP_NAME %> == '<%= RLConstants.RLPROMOTION_SHIPPING_GROUP %>')
			{
					if(o.<%= RLConstants.RLPROMOTION_EXCLUSIVENESS %> == 3)
					{
			   			document.propertiesForm.inCombination.options[2].selected = true;
			   		}
			   		else
			   		{
			   			document.propertiesForm.inCombination.options[o.<%= RLConstants.RLPROMOTION_EXCLUSIVENESS %>].selected = true;
			   		}		   		
			}
			
			if(calCodeId == null || calCodeId == '')
			{
				document.propertiesForm.rlName.focus();
			}
			else
			{
				document.propertiesForm.rlDesc.focus();
				document.propertiesForm.rlPromotionType.disabled=true;
				document.propertiesForm.rlPromotionGroup.disabled=true;
				document.propertiesForm.isCoupon.disabled=true;
			}
			if(eval(o.<%= RLConstants.RLPROMOTION_PRIORITY %>) == 300)
			{
				document.propertiesForm.rlPriority.options[0].selected = true;
			}
			else if(eval(o.<%= RLConstants.RLPROMOTION_PRIORITY %>) == 250)
			{
				document.propertiesForm.rlPriority.options[1].selected = true;
			}
			else if(eval(o.<%= RLConstants.RLPROMOTION_PRIORITY %>) == 200)
			{
				document.propertiesForm.rlPriority.options[2].selected = true;
			}
			else if(eval(o.<%= RLConstants.RLPROMOTION_PRIORITY %>) == 150)
			{
				document.propertiesForm.rlPriority.options[3].selected = true;
			}
			else if(eval(o.<%= RLConstants.RLPROMOTION_PRIORITY %>) == 100)
			{
				document.propertiesForm.rlPriority.options[4].selected = true;
			}
			targetSalesNumber=o.<%= RLConstants.RLPROMOTION_TARGETSALES %>;
			if(targetSalesNumber != "")
			{
				document.propertiesForm.targetSales.value=parent.numberToCurrency(targetSalesNumber, parent.getCurrency(),"<%=fLanguageId%>");
			}
			else
			{
				targetSalesNumber=0;
				document.propertiesForm.targetSales.value=parent.numberToCurrency(targetSalesNumber, parent.getCurrency(),"<%=fLanguageId%>");
			}
		    if(o.<%= RLConstants.RLPROMOTION_ISCOUPON %>)
		    	{
		    		document.propertiesForm.isCoupon.checked = true;
		    		document.propertiesForm.daysCouponExpire.value = o.<%= RLConstants.RLPROMOTION_COUPON_EXPIRATION_DAYS %>;
		    	}
		    else
		    	{
			    	document.propertiesForm.rlPromotionCode.value = o.<%= RLConstants.RLPROMOTION_PROMOTION_CODE  %>;		    	
		    	}
		    refreshCouponAndCustomerSegmentField(document.propertiesForm.isCoupon);
		    if(o.<%= RLConstants.RLPROMOTION_TOTAL_LIMIT %> != null && o.<%= RLConstants.RLPROMOTION_TOTAL_LIMIT %> != -1 )
		    	{
		    		document.propertiesForm.maxRedemptionInTotal.options[1].selected = true;
		    	   	document.propertiesForm.rlMaxRedemptionInTotal.value = displayRedemption(parent.numberToStr(o.<%= RLConstants.RLPROMOTION_TOTAL_LIMIT %>,"<%=fLanguageId%>",0),o.<%= RLConstants.RLPROMOTION_TOTAL_LIMIT %>);
		    	}
		    else
		    	{
				    	document.propertiesForm.maxRedemptionInTotal.options[0].selected = true;
		    	}
		    refreshMaxRedemptionInTotalFields(document.propertiesForm.maxRedemptionInTotal);
		    if(o.<%= RLConstants.RLPROMOTION_PER_ORDER_LIMIT %> != null && o.<%= RLConstants.RLPROMOTION_PER_ORDER_LIMIT %> != -1)
		    	{
			    	document.propertiesForm.maxRedemptionPerOrder.options[1].selected = true;
			    	document.propertiesForm.rlMaxRedemptionPerOrder.value = displayRedemption(parent.numberToStr(o.<%= RLConstants.RLPROMOTION_PER_ORDER_LIMIT %>,"<%=fLanguageId%>",0),o.<%= RLConstants.RLPROMOTION_PER_ORDER_LIMIT %>);
		    	}
		    else
		    	{
			    	document.propertiesForm.maxRedemptionPerOrder.options[0].selected = true;
		    	}
		    refreshMaxRedemptionPerOrderFields(document.propertiesForm.maxRedemptionPerOrder);
		    if(o.<%= RLConstants.RLPROMOTION_PER_SHOPPER_LIMIT %> != null && o.<%= RLConstants.RLPROMOTION_PER_SHOPPER_LIMIT %> != -1)
		    	{
			    	document.propertiesForm.maxRedemptionPerCustomer.options[1].selected = true;
			    	document.propertiesForm.rlMaxRedemptionPerCustomer.value = displayRedemption(parent.numberToStr(o.<%= RLConstants.RLPROMOTION_PER_SHOPPER_LIMIT %>,"<%=fLanguageId%>",0),o.<%= RLConstants.RLPROMOTION_PER_SHOPPER_LIMIT %>);
		    	}
		    else
		    	{
			    	document.propertiesForm.maxRedemptionPerCustomer.options[0].selected = true;
		    	}
		    refreshMaxRedemptionPerCustomerFields(document.propertiesForm.maxRedemptionPerCustomer);

			// Start of initializing date,days and time
			loadHours();
			var hasDateTime = false;
			var hasTime = false;
			hasDateTime = o.<%= RLConstants.RLPROMOTION_DATERANGED%>;
			if (hasDateTime) 
			{
				document.propertiesForm.rlStartYear.value=o.<%= RLConstants.RLPROMOTION_STARTYEAR %>;
				document.propertiesForm.rlStartMonth.value=o.<%= RLConstants.RLPROMOTION_STARTMONTH %>;
				document.propertiesForm.rlStartDay.value=o.<%= RLConstants.RLPROMOTION_STARTDAY %>;
				document.propertiesForm.rlEndYear.value=o.<%= RLConstants.RLPROMOTION_ENDYEAR %>;
				document.propertiesForm.rlEndMonth.value=o.<%= RLConstants.RLPROMOTION_ENDMONTH %>;
				document.propertiesForm.rlEndDay.value=o.<%= RLConstants.RLPROMOTION_ENDDAY %>;
				document.propertiesForm.datesPromIsAvailable.options[1].selected = true;
				showDateFields();
			}
			else
			{
				document.propertiesForm.datesPromIsAvailable.options[0].selected = true;
			}
			if ((trim(document.propertiesForm.rlStartYear.value).length == 0)||(trim(document.propertiesForm.rlStartMonth.value).length == 0)||(trim(document.propertiesForm.rlStartDay.value).length == 0))
			{
				setDateDefaults();
			}
			hasTime = o.<%= RLConstants.RLPROMOTION_TIMERANGED%>;
			if (hasTime) 
			{
				document.propertiesForm.rlStartTimeSelect.selectedIndex = o.<%= RLConstants.RLPROMOTION_STARTHOUR %>;
				document.propertiesForm.rlEndTimeSelect.selectedIndex = o.<%= RLConstants.RLPROMOTION_ENDHOUR %>;
				document.propertiesForm.timePromIsAvailable.options[1].selected = true;
				showTimeFields();
			}
			else
			{
				setTimeDefaults();			
				document.propertiesForm.timePromIsAvailable.options[0].selected = true;
			}
			var isEverydayFlag = true;
			daysInWeek = o.<%= RLConstants.RLPROMOTION_DAYSINWEEK %>;
			if(daysInWeek.length < 7 && daysInWeek.length != 0)
			{
				isEverydayFlag = false;
			}
			if(isEverydayFlag)
			{
				document.propertiesForm.daysPromIsAvailable.options[0].selected = true;
				hideDayChoice();
			}
			else
			{
				document.propertiesForm.daysPromIsAvailable.options[1].selected = true;
				daysSelected=o.<%= RLConstants.RLPROMOTION_DAYSINWEEK %>;
				loadCheckBoxValues(document.propertiesForm.daysInWeek, daysSelected);
				showDayChoice();
			}
			// End of initializing date,days and time
		
			// Start of initializing customer segment
			var assignedShopperGroups  = new Array();
			var assignedShopperGroupIds  = new Array();
			var noAssignedShopperGroups  = new Array();
			var noAssignedShopperGroupIds  = new Array();
	
		    var shopGroups = new Array();
			<%
			int i=0;
			while (i<memberGroupList.getLength())
			{
			%>
				noAssignedShopperGroups[<%=i%>] ="<%=UIUtil.toJavaScript(memberGroupList.getMemberGroupName(i).toString())%>";
				noAssignedShopperGroupIds[<%=i%>] ="<%=UIUtil.toJavaScript(memberGroupList.getMemberGroupId(i).toString())%>";
				var sgrp = new Object;
				sgrp.name ="<%=UIUtil.toJavaScript(memberGroupList.getMemberGroupName(i).toString())%>";
				sgrp.ref  ="<%=memberGroupList.getMemberGroupId(i)%>";
				shopGroups[shopGroups.length] = sgrp ;
			<%
				i++;
			}
			%>
			parent.put("shopperGroups", shopGroups);
			parent.put("noAssignedShopperGroups", noAssignedShopperGroups);
			parent.put("noAssignedShopperGroupIds", noAssignedShopperGroupIds);

			if(o.<%= RLConstants.RLPROMOTION_ASSIGNEDSEGMENTS %> != null && o.<%= RLConstants.RLPROMOTION_ASSIGNEDSEGMENTS %>.length != 0)
			{
				document.propertiesForm.customerSegment.options[1].selected = true;
				document.all["shopperGroupArea"].style.display = "block";

				assignedShopperGroups= o.<%= RLConstants.RLPROMOTION_ASSIGNEDSEGMENTS %>; 
				assignedShopperGroupIds= o.<%= RLConstants.RLPROMOTION_ASSIGNEDSEGMENTIDS %>; 
				for (var i=0; i< assignedShopperGroups.length; i++) 
				{
					var shopperGroupName = replaceSpecialChars(assignedShopperGroups[i]);
					var shopperGroupId = replaceSpecialChars(assignedShopperGroupIds[i]);
					//document.propertiesForm.definedShopperGroup.options[i] = new Option(shopperGroupName, shopperGroupName, false, false);
					document.propertiesForm.definedShopperGroup.options[i] = new Option(shopperGroupName, shopperGroupId, false, false);
					document.propertiesForm.definedShopperGroup.options[i].selected=false;
				}
				var shopperGroups = parent.get("shopperGroups", null);
				var noAssignedShopGroups  = new Array();
				var noAssignedShopGroupIds  = new Array();
				if(shopperGroups != null)
				{
					var nasgLength=0;
					for (var i=0; i< shopperGroups.length; i++) 
					{
						var has = true;
						for (var j=0; j< assignedShopperGroups.length; j++) 
						{
							if (shopperGroups[i].name ==  replaceSpecialChars(assignedShopperGroups[j]) )
							{
								has = false;	
								break;
							}
						}
						if(has)
						{
							noAssignedShopGroups[nasgLength] = shopperGroups[i].name;
							noAssignedShopGroupIds[nasgLength] = shopperGroups[i].ref;
							nasgLength = nasgLength-(-1);
						}
					}
					parent.put("noAssignedShopperGroups", noAssignedShopGroups);
					parent.put("noAssignedShopperGroupIds", noAssignedShopGroupIds);
				}
			}
			else
			{
				document.propertiesForm.customerSegment.options[0].selected = true;
				document.all["shopperGroupArea"].style.display = "none";
			}

			var noAssignedShopperGroups = parent.get("noAssignedShopperGroups");
			var noAssignedShopperGroupIds = parent.get("noAssignedShopperGroupIds");
			if(noAssignedShopperGroups != null || noAssignedShopperGroups != "")
			{
				for ( var i=0; i< noAssignedShopperGroups.length; i++) 
				{
					var shopperGroupName = noAssignedShopperGroups[i];
					var shopperGroupId = noAssignedShopperGroupIds[i];
					document.propertiesForm.allShopperGroup.options[i] = new Option( shopperGroupName, shopperGroupId, false, false);
					document.propertiesForm.allShopperGroup.options[i].selected=false;
				}
			}
		// End of initializing customer segment
		}// if o != null
		else
		{
			setDateDefaults();
			setTimeDefaults();
		}
		
		if (parent.setContentFrameLoaded) {
			parent.setContentFrameLoaded(true);
		}
	}// if parent.get	
		
	
	if (parent.get("invalidDiscountDesc", false)) {
		parent.remove("invalidDiscountDesc");
            reprompt(document.propertiesForm.rlDesc, "<%= UIUtil.toJavaScript(RLPromotionNLS.get("descriptionTooLong").toString())%>");
	      return;
	}
	if (parent.get("invalidNLDiscountDesc", false)) {
		parent.remove("invalidNLDiscountDesc");
            reprompt(document.propertiesForm.rlDescNL, "<%= UIUtil.toJavaScript(RLPromotionNLS.get("descriptionTooLong").toString())%>");
	      return;
	}
	if (parent.get("invalidNLDiscountLongDesc", false)) {
		parent.remove("invalidNLDiscountLongDesc");
            reprompt(document.propertiesForm.rlDescLongNL, "<%= UIUtil.toJavaScript(RLPromotionNLS.get("longDescriptionTooLong").toString())%>");
	      return;
	}
	if (parent.get("currencyTooLong", false))
	{
		parent.remove("currencyTooLong");
		reprompt(document.propertiesForm.targetSales,"<%= UIUtil.toJavaScript(RLPromotionNLS.get("currencyTooLong").toString())%>");
		return;
	}
	if (parent.get("invalidCurrency", false))
	{
		parent.remove("invalidCurrency");
		reprompt(document.propertiesForm.targetSales,"<%= UIUtil.toJavaScript(RLPromotionNLS.get("targetSalesCurrencyInvalid").toString())%>");
		return;
	}
	if (parent.get("noProperCouponExpirationDays", false))
	{
		parent.remove("noProperCouponExpirationDays");
		reprompt(document.propertiesForm.daysCouponExpire,"<%= UIUtil.toJavaScript(RLPromotionNLS.get("invalidCouponExpireNumber").toString())%>");
		return;
	}
	if (parent.get("noProperTotalLimit", false))
	{
		parent.remove("noProperTotalLimit");
		reprompt(document.propertiesForm.rlMaxRedemptionInTotal,"<%= UIUtil.toJavaScript(RLPromotionNLS.get("redemptionNotNumber").toString())%>");
		return;
	}
	if (parent.get("noProperOrderLimit", false))
	{
		parent.remove("noProperOrderLimit");
		reprompt(document.propertiesForm.rlMaxRedemptionPerOrder,"<%= UIUtil.toJavaScript(RLPromotionNLS.get("redemptionNotNumber").toString())%>");
		return;
	}
	if (parent.get("noProperShopperLimit", false))
	{
		parent.remove("noProperShopperLimit");
		reprompt(document.propertiesForm.rlMaxRedemptionPerCustomer,"<%= UIUtil.toJavaScript(RLPromotionNLS.get("redemptionNotNumber").toString())%>");
		return;
	}
	if (parent.get("totalLimitValueTooLong", false))
	{
	    parent.remove("totalLimitValueTooLong");
		reprompt(document.propertiesForm.rlMaxRedemptionInTotal,"<%= UIUtil.toJavaScript(RLPromotionNLS.get("redemptionQtyNumberTooLong").toString())%>");
		return;
	}
	if (parent.get("orderLimitValueTooLong", false))
	{
	    parent.remove("orderLimitValueTooLong");
		reprompt(document.propertiesForm.rlMaxRedemptionPerOrder,"<%= UIUtil.toJavaScript(RLPromotionNLS.get("redemptionQtyNumberTooLong").toString())%>");
		return;
	}
	if (parent.get("shopperLimitValueTooLong", false))
	{
	    parent.remove("shopperLimitValueTooLong");
		reprompt(document.propertiesForm.rlMaxRedemptionPerCustomer,"<%= UIUtil.toJavaScript(RLPromotionNLS.get("redemptionQtyNumberTooLong").toString())%>");
		return;
	}
	// Start of Date, day and time fields alert
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
	// End of Date, day and time fields alert
	
	// Start of customer segment alert
	if (parent.get("noAssignedMbrGrps", false)) {
		parent.remove("noAssignedMbrGrps");
		alertDialog('<%= UIUtil.toJavaScript(RLPromotionNLS.get("needAMemberGroup").toString())%>');
	      return;
	}
	// End of customer segment alert
}

function displayRedemption(newValue, previousValue) {
	if (newValue == "NaN") {        
    	return previousValue;
    } else {
    	return newValue;
    }
}


function savePanelData()
{
	var assignedShopperGroups  = new Array();
	var assignedShopperGroupIds  = new Array();
	var noAssignedShopperGroups  = new Array();
	
	with (document.propertiesForm)
	{
		if (parent.get) {
			var o = parent.get("<%= RLConstants.RLPROMOTION %>", null);
			if (o != null) {
				o.<%=RLConstants.RLPROMOTION_LAST_UPDATE_USER%> = '<%=userId%>';
				o.<%= RLConstants.RLPROMOTION_NAME %> = trim(rlName.value);
				  o.<%= RLConstants.RLPROMOTION_VERSION %> = version;
				  o.<%= RLConstants.RLPROMOTION_REVISION %> = revision;
				  o.<%= RLConstants.RLPROMOTION_STATUS %> = promoStatus;
				  o.<%= RLConstants.RLPROMOTION_DESCRIPTION %> = rlDesc.value;
		            o.<%= RLConstants.RLPROMOTION_DESCRIPTION_NL %> = rlDescNL.value;
				o.<%= RLConstants.RLPROMOTION_DESCRIPTION_LONG_NL %> = rlDescLongNL.value;
				o.<%= RLConstants.RLPROMOTION_PRIORITY %> = rlPriority.options[rlPriority.selectedIndex].value;
				if (!(targetSales.value)) {
					o.<%= RLConstants.RLPROMOTION_TARGETSALES %> = parent.currencyToNumber(trim(0), parent.getCurrency(),"<%=fLanguageId%>");
				} else {
					o.<%= RLConstants.RLPROMOTION_TARGETSALES %> = parent.currencyToNumber(trim(targetSales.value), parent.getCurrency(),"<%=fLanguageId%>");
				}
				o.<%= RLConstants.RLPROMOTION_GROUP_NAME %>=rlPromotionGroup.options[rlPromotionGroup.selectedIndex].value;
				if (promotionType != null) {
				  o.<%= RLConstants.RLPROMOTION_TYPE %> = promotionType;
				  // this is only happened when Update Promotion.
				} else {
					o.<%= RLConstants.RLPROMOTION_TYPE %>=rlPromotionType.options[rlPromotionType.selectedIndex].value;
				}
			    if(rlPromotionGroup.options[0].selected)
			    {
	   				o.<%= RLConstants.RLPRODPROMO_TYPEALIAS %>=rlPromotionType.options[rlPromotionType.selectedIndex].value;
	   			}
	   			o.<%= RLConstants.RLPROMOTION_EXCLUSIVENESS %>=inCombination.options[inCombination.selectedIndex].value;
		   		o.<%= RLConstants.RLPROMOTION_ISCOUPON %> = isCoupon.checked;
			    	if(isCoupon.checked)
			    	{
			    		o.<%= RLConstants.RLPROMOTION_COUPON_EXPIRATION_DAYS %> = trim(daysCouponExpire.value);
			    	}
			    	else
			    	{
				    	o.<%= RLConstants.RLPROMOTION_PROMOTION_CODE  %> = trim(rlPromotionCode.value);
				    	if(trim(rlPromotionCode.value) == '')
				    	{
					    	o.<%= RLConstants.RLPROMOTION_CODE_REQUIRED %> = false;
				    	}
				    	else
				    	{
					    	o.<%= RLConstants.RLPROMOTION_CODE_REQUIRED %> = true;
				    	}
				    }
			    	if(maxRedemptionInTotal.options[0].selected)
			    	{
			    		o.<%= RLConstants.RLPROMOTION_TOTAL_LIMIT %> = -1;
						parent.put("unlimitedTotalLimit", true);
			    	}
			    	else
			    	{
			    	   	if (trim(rlMaxRedemptionInTotal.value) == -1) {
			    	   	  rlMaxRedemptionInTotal.value = 0
			    	   	}
			    	   	o.<%= RLConstants.RLPROMOTION_TOTAL_LIMIT %> = displayRedemption(parent.strToNumber(trim(rlMaxRedemptionInTotal.value),"<%=fLanguageId%>"), trim(rlMaxRedemptionInTotal.value));
			    	   	parent.put("unlimitedTotalLimit", false);
			    	}
			    	if(maxRedemptionPerOrder.options[0].selected)
			    	{
				    	o.<%= RLConstants.RLPROMOTION_PER_ORDER_LIMIT %> = -1;
						parent.put("unlimitedOrderLimit", true);
			    	}
			    	else
			    	{
				    	if (trim(rlMaxRedemptionPerOrder.value) == -1) {
			    	   	  rlMaxRedemptionPerOrder.value = 0
			    	   	}
			    	   	o.<%= RLConstants.RLPROMOTION_PER_ORDER_LIMIT %> = displayRedemption(parent.strToNumber(trim(rlMaxRedemptionPerOrder.value),"<%=fLanguageId%>"),trim(rlMaxRedemptionPerOrder.value));
				    	parent.put("unlimitedOrderLimit", false);						
			    	}
			    	if(maxRedemptionPerCustomer.options[0].selected)
			    	{
				    	o.<%= RLConstants.RLPROMOTION_PER_SHOPPER_LIMIT %> = -1;
						parent.put("unlimitedShopperLimit", true);
			    	}
			    	else
			    	{
				    	if (trim(rlMaxRedemptionPerCustomer.value) == -1) {
			    	   	  rlMaxRedemptionPerCustomer.value = 0
			    	   	}
			    	   	o.<%= RLConstants.RLPROMOTION_PER_SHOPPER_LIMIT %> = displayRedemption(parent.strToNumber(trim(rlMaxRedemptionPerCustomer.value),"<%=fLanguageId%>"),trim(rlMaxRedemptionPerCustomer.value));
						parent.put("unlimitedShopperLimit", false);
			    	}
			   	if (datesPromIsAvailable.options[1].selected)
			   	{
				    o.<%= RLConstants.RLPROMOTION_DATERANGED %>= true;
				    o.<%= RLConstants.RLPROMOTION_STARTYEAR %>= rlStartYear.value;
				    o.<%= RLConstants.RLPROMOTION_STARTMONTH %>= rlStartMonth.value;
				    o.<%= RLConstants.RLPROMOTION_STARTDAY %>= rlStartDay.value;
				    o.<%= RLConstants.RLPROMOTION_ENDYEAR %>= rlEndYear.value;
				    o.<%= RLConstants.RLPROMOTION_ENDMONTH %>= rlEndMonth.value;
				    o.<%= RLConstants.RLPROMOTION_ENDDAY %>= rlEndDay.value;
			   	}
			   	else
			   	{
				    o.<%= RLConstants.RLPROMOTION_DATERANGED %>= false;
			    }
	
				if (daysPromIsAvailable.options[1].selected)
				{
					o.<%= RLConstants.RLPROMOTION_DAYSINWEEK %>=getCheckBoxValues(document.propertiesForm.daysInWeek);
					o.<%= RLConstants.RLPROMOTION_ISEVERYDAYFLAG %>= false;
				}
				else
				{
					o.<%= RLConstants.RLPROMOTION_DAYSINWEEK %> = getAllCheckBoxValues(document.propertiesForm.daysInWeek);
					o.<%= RLConstants.RLPROMOTION_ISEVERYDAYFLAG %>= true;
				}
				
			   	if (timePromIsAvailable.options[1].selected)
			   	{
				    o.<%= RLConstants.RLPROMOTION_TIMERANGED %>= true;
				    o.<%= RLConstants.RLPROMOTION_STARTHOUR %>= rlStartTimeSelect.selectedIndex;
				    o.<%= RLConstants.RLPROMOTION_ENDHOUR %>= rlEndTimeSelect.selectedIndex;	
			   	}
			   	else
			   	{
				    o.<%= RLConstants.RLPROMOTION_TIMERANGED %>= false;
	            }
			    	if(customerSegment.options[1].selected)
					{
						o.<%= RLConstants.RLPROMOTION_VALIDFORALLCUSTOMERS %> = false;
						for (var i=0; i< allShopperGroup.options.length; i++)
						{
							noAssignedShopperGroups[i] = allShopperGroup.options[i].text;
						}
						var groups = parent.get("shopperGroups");
						if(groups.length > 0)
						{
							parent.put("noAssignedShopperGroups", noAssignedShopperGroups);
						}
						for (var i=0; i< definedShopperGroup.options.length; i++)
						{							
							assignedShopperGroups[i] = definedShopperGroup.options[i].text;
							assignedShopperGroupIds[i] = definedShopperGroup.options[i].value;
						}
						o.<%= RLConstants.RLPROMOTION_ASSIGNEDSEGMENTS %> = assignedShopperGroups;
						o.<%= RLConstants.RLPROMOTION_ASSIGNEDSEGMENTIDS %> = assignedShopperGroupIds;
					}
					else
					{
						o.<%= RLConstants.RLPROMOTION_ASSIGNEDSEGMENTS %> = assignedShopperGroups;
						o.<%= RLConstants.RLPROMOTION_ASSIGNEDSEGMENTIDS %> = assignedShopperGroupIds;
						o.<%= RLConstants.RLPROMOTION_VALIDFORALLCUSTOMERS %> = true;
					}
				// }				
				currGroup = rlPromotionGroup.selectedIndex;
	   			currType = rlPromotionType.selectedIndex;
			}
		}
	}
}

function validatePanelData()
{
	with (document.propertiesForm)
	{
		if ( !(rlName.value) )
		{
			reprompt(rlName, "<%= UIUtil.toJavaScript(RLPromotionNLS.get("nameBlankMsg").toString())%>");
		 	return false;
	   	}
		// Added by Veni - defect# 37794
	    	// else if (isNaN(rlName.value.charAt(0)) == false)
		// {
		// 	reprompt(rlName, "<%= UIUtil.toJavaScript(RLPromotionNLS.get("rlDiscountNameNonNumeric").toString())%>");
		// 	return false;
		// }	
	    else if ( (numOfOccur(rlName.value, "$") >0)  || (numOfOccur(rlName.value, "!") >0)  || (numOfOccur(rlName.value, "@") >0) || (numOfOccur(rlName.value, "%") >0) || (numOfOccur(rlName.value, "^") >0) || (numOfOccur(rlName.value, "&") >0) || (numOfOccur(rlName.value, "~") >0) || (numOfOccur(rlName.value, ">") >0) || (numOfOccur(rlName.value, "<") >0) || (numOfOccur(rlName.value, "?") >0) || (numOfOccur(rlName.value, ",") >0) || (numOfOccur(rlName.value, ".") >0)  || (numOfOccur(rlName.value, "/") >0) || (numOfOccur(rlName.value, "-") >0) || (numOfOccur(rlName.value, '"') >0) || (numOfOccur(rlName.value, "#") >0) || (numOfOccur(rlName.value, "=") >0) || (numOfOccur(rlName.value, "{") >0) || (numOfOccur(rlName.value, "}") >0) || (numOfOccur(rlName.value, "\\") >0) || (numOfOccur(rlName.value, "/") >0))  	    
	    {
			reprompt(rlName, "<%= UIUtil.toJavaScript(RLPromotionNLS.get("rlDiscountInvalidName").toString())%>");
			return false;
		}
 		// End - defect# 37794
 		// defect # 64021
		    else if ( (numOfOccur(rlName.value, ":") >0)  || (numOfOccur(rlName.value, "+") >0)  || (numOfOccur(rlName.value, "`") >0) || (numOfOccur(rlName.value, "*") >0) || (numOfOccur(rlName.value, "(") >0) ||(numOfOccur(rlName.value, ")") >0) ||(numOfOccur(rlName.value, "|") >0) || (numOfOccur(rlName.value, "[") >0) || (numOfOccur(rlName.value, "]") >0) || (numOfOccur(rlName.value, ";") >0))  	    
	      {
			reprompt(rlName, "<%= UIUtil.toJavaScript(RLPromotionNLS.get("rlDiscountInvalidName").toString())%>");
			return false;
		}
		// end defect # 64021
        	else if(rlName.value.length > 30)
		{
			reprompt(rlName, "<%= UIUtil.toJavaScript(RLPromotionNLS.get("nameLenMsg").toString())%>");
			return false;
		}
		else if(numOfOccur(rlName.value, "_") >0)
		{
			reprompt(rlName, "<%= UIUtil.toJavaScript(RLPromotionNLS.get("nameUnderscoreMsg").toString())%>");
			return false;
		}
		
		if (rlDesc.value.length > 254)
		{
		    reprompt(rlDesc, "<%= UIUtil.toJavaScript(RLPromotionNLS.get("descriptionTooLong").toString())%>");
		    return false;
		}
	
		if (rlDescNL.value.length > 254)
		{
		    reprompt(rlDescNL, "<%= UIUtil.toJavaScript(RLPromotionNLS.get("descriptionTooLong").toString())%>");
		    return false;
		}

		if (rlDescLongNL.value.length > 4000)
		{
		    reprompt(rlDescLongNL, "<%= UIUtil.toJavaScript(RLPromotionNLS.get("longDescriptionTooLong").toString())%>");
		    return false;
		}

		if (parent.currencyToNumber(trim(targetSales.value), parent.getCurrency(),"<%=fLanguageId%>").toString().length >14)
		{
			reprompt(targetSales,"<%= UIUtil.toJavaScript(RLPromotionNLS.get("currencyTooLong").toString())%>");
			return false;
		}
		else if ( (targetSales.value) && !parent.isValidCurrency(trim(targetSales.value), parent.getCurrency(), "<%=fLanguageId%>"))
		{
			reprompt(targetSales,"<%= UIUtil.toJavaScript(RLPromotionNLS.get("targetSalesCurrencyInvalid").toString())%>");
			return false;
		}

	    if(isCoupon.checked)
	    	{
				if ( trim(daysCouponExpire.value) == '' || !isValidNZPosInt(trim(daysCouponExpire.value))) 
				{
					reprompt(daysCouponExpire,"<%= UIUtil.toJavaScript(RLPromotionNLS.get("invalidCouponExpireNumber").toString())%>");
					return false;
				}
	    	}
		if (maxRedemptionInTotal.options[1].selected && !validateRedemptionQty(rlMaxRedemptionInTotal)) return false;
		if (maxRedemptionPerOrder.options[1].selected && !validateRedemptionQty(rlMaxRedemptionPerOrder)) return false;
		if (maxRedemptionPerCustomer.options[1].selected && !validateRedemptionQty(rlMaxRedemptionPerCustomer)) return false;
	    if (datesPromIsAvailable.options[1].selected)
	    {
	    	var startTime=rlStartTimeSelect.selectedIndex+"<%=RLPromotionNLS.get("colonZeroZero")%>";
	    	var endTime=rlEndTimeSelect.selectedIndex+"<%=RLPromotionNLS.get("colonZeroZero")%>";
	    
			if ( !validDate(rlStartYear.value,rlStartMonth.value,rlStartDay.value))
			{
			    alertDialog('<%= UIUtil.toJavaScript(RLPromotionNLS.get("invalidStartDateMsg").toString())%>');
			    return false;
			}
			else if ( !validDate(rlEndYear.value,rlEndMonth.value,rlEndDay.value))
			{
			    alertDialog('<%= UIUtil.toJavaScript(RLPromotionNLS.get("invalidEndDateMsg").toString())%>');
			    return false;
			}
	
			rc = validateStartEndDateTime(rlStartYear.value,rlStartMonth.value,rlStartDay.value, rlEndYear.value,rlEndMonth.value,rlEndDay.value, startTime, endTime);
			if ((rc==false)||(eval(rc)==-1))
			{
			    alertDialog('<%= UIUtil.toJavaScript(RLPromotionNLS.get("notOrderedMsg").toString())%>');
			    return false;
			}
	    }
	    if (daysPromIsAvailable.options[1].selected)
		{
			daysSelected=getCheckBoxValues(document.propertiesForm.daysInWeek);
			if (daysSelected.length == 0)
			{
			    alertDialog('<%= UIUtil.toJavaScript(RLPromotionNLS.get("needADay").toString())%>');
			    return false;
			}
		}
	    if ((customerSegment.options[1].selected)&&(isListBoxEmpty(definedShopperGroup))) 
			{
				alertDialog('<%= UIUtil.toJavaScript(RLPromotionNLS.get("needAMemberGroup").toString())%>');
				return false;
			}			
	}
	if (parent.get) {
		var o = parent.get("<%= RLConstants.RLPROMOTION %>", null);
		if (o != null) {
			if (typeChanged()) {
				var ranges = o.<%= RLConstants.RLPROMOTION_RANGES %>;
				if(eval(lastGroup)== 0)
				{
					if(eval(lastType)== 0 || eval(lastType)== 1 || eval(lastType)== 2)
					{
						if(ranges.length != 0)
						{
							var newRanges = new Array();
							var newValues = new Array();
							o.<%= RLConstants.RLPROMOTION_RANGES %> = newRanges;
							o.<%= RLConstants.RLPROMOTION_VALUES %> = newValues;
						}
						if(eval(currType)== 3 || eval(currType)== 4)
						{
							o.<%= RLConstants.RLPROMOTION_MAX_DISCOUNT_ITEM_QTY %> = "";
							o.<%= RLConstants.RLPROMOTION_REQUIRED_QTY %> = "";
							o.<%= RLConstants.RLPROMOTION_VALUE %> = "";
							o.<%= RLConstants.RLPROMOTION_DISCOUNT_ITEM_SKU %> = "";
						}
					}
					else if(eval(lastType)== 3)
					{
						o.<%= RLConstants.RLPROMOTION_MAX_DISCOUNT_ITEM_QTY %> = "";
						o.<%= RLConstants.RLPROMOTION_REQUIRED_QTY %> = "";
						o.<%= RLConstants.RLPROMOTION_VALUE %> = "";
					}
					else if( eval(lastType)== 4)
					{
						o.<%= RLConstants.RLPROMOTION_MAX_DISCOUNT_ITEM_QTY %> = "";
						o.<%= RLConstants.RLPROMOTION_REQUIRED_QTY %> = "";
						o.<%= RLConstants.RLPROMOTION_DISCOUNT_ITEM_SKU %> = "";
					}
				}	
				if(eval(lastGroup)== 1)
				{
					if(ranges.length != 0)
					{
						var newRanges = new Array();
						var newValues = new Array();
						o.<%= RLConstants.RLPROMOTION_RANGES %> = newRanges;
						o.<%= RLConstants.RLPROMOTION_VALUES %> = newValues;
					}	
					if(eval(lastType) == 0 || eval(lastType) == 1)
					{
					}
					else if(eval(lastType) == 2)
					{
						o.<%= RLConstants.RLPROMOTION_DISCOUNT_ITEM_SKU %> = "";
					}
					else if(eval(lastType) == 3)
					{
						o.<%= RLConstants.RLPROMOTION_SHIPMODEID %> = "";	
					}
				}
				if(eval(lastGroup)== 2)
				{
					if(ranges.length != 0)
					{
						var newRanges = new Array();
						var newValues = new Array();
						o.<%= RLConstants.RLPROMOTION_RANGES %> = newRanges;
						o.<%= RLConstants.RLPROMOTION_VALUES %> = newValues;
					}	
					if(eval(lastType) == 0)
					{
						o.<%= RLConstants.RLPROMOTION_SHIPMODEID %> = "";	
					}
				}
			}	
			var promotionGroupName = document.propertiesForm.rlPromotionGroup.options[document.propertiesForm.rlPromotionGroup.selectedIndex].value;
			var promotionType = document.propertiesForm.rlPromotionType.options[document.propertiesForm.rlPromotionType.selectedIndex].value;
			if((calCodeId == null || trim(calCodeId) == '') && promotionGroupName == '<%= RLConstants.RLPROMOTION_PRODUCT_GROUP %>')
			{
				parent.setNextBranch("RLProdPromoWhat");
			}
			if((calCodeId == null || trim(calCodeId) == '') && promotionType == "<%= RLConstants.RLPROMOTION_ORDERLEVELPERCENTDISCOUNT %>")
			{
				var ranges = o.<%= RLConstants.RLPROMOTION_RANGES %>;
				var values = o.<%= RLConstants.RLPROMOTION_VALUES %>;
				if(ranges != null && values != null)					
				{
					if(ranges.length < 2 || (ranges.length == 2 && eval(values[0]) == 0) )
					{
			  	    	parent.setNextBranch("RLDiscountPercentType");
			  	    }
			  	    else
			  	    {
			  	    	parent.setNextBranch("RLDiscountWizardRanges");
			  	    }	
			  	}
			  	else
			  	{    	
					parent.setNextBranch("RLDiscountPercentType");
				}	
			}
			if((calCodeId == null || trim(calCodeId) == '') && promotionType == "<%= RLConstants.RLPROMOTION_ORDERLEVELVALUEDISCOUNT %>")
			{
				var ranges = o.<%= RLConstants.RLPROMOTION_RANGES %>;
				var values = o.<%= RLConstants.RLPROMOTION_VALUES %>;
				if(ranges != null && values != null)					
				{
					if(ranges.length < 2 || (ranges.length == 2 && eval(values[0]) == 0) )
					{
						  parent.setNextBranch("RLDiscountFixedType");
			  	    }
			  	    else
			  	    {
			  	    	parent.setNextBranch("RLDiscountWizardRanges");
			  	    }	
			  	}
			  	else
			  	{
		  	    	parent.setNextBranch("RLDiscountFixedType");
		  	    }	
			}
			if((calCodeId == null || trim(calCodeId) == '') && promotionType == "<%= RLConstants.RLPROMOTION_ORDERLEVELFIXEDSHIPPINGDISCOUNT %>")
			{
				parent.setNextBranch("RLDiscountShippingType");
			}
			if((calCodeId == null || trim(calCodeId) == '') && promotionType == "<%= RLConstants.RLPROMOTION_ORDERLEVELFREEGIFT %>")
			{
				parent.setNextBranch("RLDiscountGWPType");
			}

		}	
	}
	return true;
}

function validateRedemptionQty(qtyField)
{
	if(parent.strToNumber(trim(qtyField.value),"<%=fLanguageId%>").toString().length > 9)
	{
		reprompt(qtyField,"<%= UIUtil.toJavaScript(RLPromotionNLS.get("redemptionQtyNumberTooLong").toString())%>");
		return false;
	}
	else if ( !parent.isValidInteger(trim(qtyField.value), "<%=fLanguageId%>")) 
	{
		reprompt(qtyField,"<%= UIUtil.toJavaScript(RLPromotionNLS.get("redemptionNotNumber").toString())%>");
		return false;
	}
	else if (!(eval(parent.strToNumber(trim(qtyField.value),"<%=fLanguageId%>")) >= 1))
	{
		reprompt(qtyField,"<%= UIUtil.toJavaScript(RLPromotionNLS.get("redemptionNotNumber").toString())%>");
		return false;
	}
	return true;	
}

function typeChanged()
{
  if (lastGroup!=currGroup)
    return true;
  else if(lastType!=currType)
    return true;
  else 
  	return false;
}

function initializeCurrency()
{
	if (parent.get) {
		var o = parent.get("<%= RLConstants.RLPROMOTION %>", null);
		if (o != null) {
			o.<%= RLConstants.RLPROMOTION_CURRENCY %> = '<%=defCurr%>';
		}
	}	
}

function initializePriority()
{
	document.propertiesForm.rlPriority.options[0] = new Option("<%=RLPromotionNLS.get("highest")%>", 300, false, false);
	document.propertiesForm.rlPriority.options[1] = new Option("<%=RLPromotionNLS.get("high")%>", 250, false, false);
	document.propertiesForm.rlPriority.options[2] = new Option("<%=RLPromotionNLS.get("moderate")%>", 200, true, true);
	document.propertiesForm.rlPriority.options[3] = new Option("<%=RLPromotionNLS.get("low")%>", 150, false, false);
	document.propertiesForm.rlPriority.options[4] = new Option("<%=RLPromotionNLS.get("lowest")%>", 100, false, false);	
}

function initializePromotionGroup()
{
	document.propertiesForm.rlPromotionGroup.options[0] = new Option("<%=RLPromotionNLS.get("prodPromo")%>", "<%= RLConstants.RLPROMOTION_PRODUCT_GROUP %>", true, true);
	document.propertiesForm.rlPromotionGroup.options[1] = new Option("<%=RLPromotionNLS.get("orderPromo")%>", "<%= RLConstants.RLPROMOTION_ORDER_GROUP %>", false, false);
	document.propertiesForm.rlPromotionGroup.options[2] = new Option("<%=RLPromotionNLS.get("shipPromo")%>", "<%= RLConstants.RLPROMOTION_SHIPPING_GROUP %>", false, false);
}

function initializePromotionType()
{
		document.propertiesForm.rlPromotionType.options[0] = new Option("<%=RLPromotionNLS.get("percentOffPerItem")%>", "<%= RLConstants.RLPROMOTION_PRODUCTLEVELPERCENTDISCOUNT %>", true, true);
		document.propertiesForm.rlPromotionType.options[1] = new Option("<%=RLPromotionNLS.get("fixedAmountOffPerItem")%>", "<%= RLConstants.RLPROMOTION_PRODUCTLEVELPERITEMVALUEDISCOUNT %>", false, false);
		document.propertiesForm.rlPromotionType.options[2] = new Option("<%=RLPromotionNLS.get("fixedAmountOffAll")%>", "<%= RLConstants.RLPROMOTION_PRODUCTLEVELVALUEDISCOUNT %>", false, false);
		document.propertiesForm.rlPromotionType.options[3] = new Option("<%=RLPromotionNLS.get("buyXGetY")%>",  "<%= RLConstants.RLPROMOTION_ITEMLEVELSAMEITEMPERCENTDISCOUNT %>", false, false);
		document.propertiesForm.rlPromotionType.options[4] = new Option("<%=RLPromotionNLS.get("freeGiftWithPurchase")%>", "<%= RLConstants.RLPROMOTION_PRODUCTLEVELBUYXGETYFREE %>", false, false);
}

function initializeInCombination()
{
	document.propertiesForm.inCombination.options[0] = new Option("<%=RLPromotionNLS.get("combineWithAnyPromotion")%>", 0, true, true);
	document.propertiesForm.inCombination.options[1] = new Option("<%=RLPromotionNLS.get("exclusiveSelectedGroup")%>", 1, false, false);
	document.propertiesForm.inCombination.options[2] = new Option("<%=RLPromotionNLS.get("exclusiveAllGroups")%>", 2, false, false);
}

function initializeRedemption()
{
	document.propertiesForm.maxRedemptionInTotal.options[0] = new Option("<%=RLPromotionNLS.get("unlimited")%>", 0, true, true);
	document.propertiesForm.maxRedemptionInTotal.options[1] = new Option("<%=RLPromotionNLS.get("maxRedemption")%>", 1, false, false);

	document.propertiesForm.maxRedemptionPerOrder.options[0] = new Option("<%=RLPromotionNLS.get("unlimited")%>", 0, true, true);
	document.propertiesForm.maxRedemptionPerOrder.options[1] = new Option("<%=RLPromotionNLS.get("maxRedemption")%>", 1, false, false);

	document.propertiesForm.maxRedemptionPerCustomer.options[0] = new Option("<%=RLPromotionNLS.get("unlimited")%>", 0, true, true);
	document.propertiesForm.maxRedemptionPerCustomer.options[1] = new Option("<%=RLPromotionNLS.get("maxRedemption")%>", 1, false, false);	
}

function initializePromotionAvailability()
{
	document.propertiesForm.datesPromIsAvailable.options[0] = new Option("<%=RLPromotionNLS.get("alwaysInEffect")%>", 0, true, true);
	document.propertiesForm.datesPromIsAvailable.options[1] = new Option("<%=RLPromotionNLS.get("specificPeriod")%>", 1, false, false);

	document.propertiesForm.daysPromIsAvailable.options[0] = new Option("<%=RLPromotionNLS.get("everyDayOfWeek")%>", 0, true, true);
	document.propertiesForm.daysPromIsAvailable.options[1] = new Option("<%=RLPromotionNLS.get("specificDayOfWeek")%>", 1, false, false);

	document.propertiesForm.timePromIsAvailable.options[0] = new Option("<%=RLPromotionNLS.get("allThroughDay")%>", 0, true, true);
	document.propertiesForm.timePromIsAvailable.options[1] = new Option("<%=RLPromotionNLS.get("specificTimeOfDay")%>", 1, false, false);
}

function initializeCustomerSegment()
{
	document.propertiesForm.customerSegment.options[0] = new Option("<%=RLPromotionNLS.get("allCustomerSegments")%>", 0, true, true);
	document.propertiesForm.customerSegment.options[1] = new Option("<%=RLPromotionNLS.get("specificCustomerSegments")%>", 1, false, false);
}

function refreshPromoTypeAndCombinationFields(promGroup)
{
	var length = document.propertiesForm.rlPromotionType.options.length;
	for(var i=length-1; i>=0; i--) {
    	document.propertiesForm.rlPromotionType.options[i] = null;
  	}

	var length = document.propertiesForm.inCombination.options.length;
	for(var i=length-1; i>=0; i--) {
    	document.propertiesForm.inCombination.options[i] = null;
  	}

	if(promGroup.options[0].selected)
	{
		document.propertiesForm.rlPromotionType.options[0] = new Option("<%=RLPromotionNLS.get("percentOffPerItem")%>", "<%= RLConstants.RLPROMOTION_PRODUCTLEVELPERCENTDISCOUNT %>", true, true);
		document.propertiesForm.rlPromotionType.options[1] = new Option("<%=RLPromotionNLS.get("fixedAmountOffPerItem")%>", "<%= RLConstants.RLPROMOTION_PRODUCTLEVELPERITEMVALUEDISCOUNT %>", false, false);
		document.propertiesForm.rlPromotionType.options[2] = new Option("<%=RLPromotionNLS.get("fixedAmountOffAll")%>", "<%= RLConstants.RLPROMOTION_PRODUCTLEVELVALUEDISCOUNT %>", false, false);
		document.propertiesForm.rlPromotionType.options[3] = new Option("<%=RLPromotionNLS.get("buyXGetY")%>",  "<%= RLConstants.RLPROMOTION_ITEMLEVELSAMEITEMPERCENTDISCOUNT %>", false, false);
		document.propertiesForm.rlPromotionType.options[4] = new Option("<%=RLPromotionNLS.get("freeGiftWithPurchase")%>", "<%= RLConstants.RLPROMOTION_PRODUCTLEVELBUYXGETYFREE %>", false, false);

		document.propertiesForm.inCombination.options[0] = new Option("<%=RLPromotionNLS.get("combineWithAnyPromotion")%>", 0, true, true);
		document.propertiesForm.inCombination.options[1] = new Option("<%=RLPromotionNLS.get("exclusiveSelectedGroup")%>", 1, false, false);
		document.propertiesForm.inCombination.options[2] = new Option("<%=RLPromotionNLS.get("exclusiveAllGroups")%>", 2, false, false);
	}
	else if (promGroup.options[1].selected)
	{
		document.propertiesForm.rlPromotionType.options[0] = new Option("<%=RLPromotionNLS.get("percentOff")%>", "<%= RLConstants.RLPROMOTION_ORDERLEVELPERCENTDISCOUNT %>", true, true);
		document.propertiesForm.rlPromotionType.options[1] = new Option("<%=RLPromotionNLS.get("fixedAmountOff")%>", "<%= RLConstants.RLPROMOTION_ORDERLEVELVALUEDISCOUNT %>", false, false);
		document.propertiesForm.rlPromotionType.options[2] = new Option("<%=RLPromotionNLS.get("freeGiftWithPurchase")%>", "<%= RLConstants.RLPROMOTION_ORDERLEVELFREEGIFT %>", false, false);
		document.propertiesForm.inCombination.options[0] = new Option("<%=RLPromotionNLS.get("combineWithAnyPromotion")%>", 0, true, true);
		document.propertiesForm.inCombination.options[1] = new Option("<%=RLPromotionNLS.get("exclusiveSelectedGroup")%>", 1, false, false);
		document.propertiesForm.inCombination.options[2] = new Option("<%=RLPromotionNLS.get("cannotCombineWithProdPromo")%>", 3, false, false);
	}
	else if (promGroup.options[2].selected)
	{
		document.propertiesForm.rlPromotionType.options[0] = new Option("<%=RLPromotionNLS.get("discountedShipping")%>", "<%= RLConstants.RLPROMOTION_ORDERLEVELFIXEDSHIPPINGDISCOUNT %>", true, true);

		document.propertiesForm.inCombination.options[0] = new Option("<%=RLPromotionNLS.get("combineWithAnyPromotion")%>", 0, true, true);
		document.propertiesForm.inCombination.options[1] = new Option("<%=RLPromotionNLS.get("exclusiveSelectedGroup")%>", 1, false, false);
		document.propertiesForm.inCombination.options[2] = new Option("<%=RLPromotionNLS.get("cannotCombineWithProdPromo")%>", 3, false, false);
	}
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
		document.propertiesForm.rlStartTimeSelect.options[i] = new Option(i + "<%=RLPromotionNLS.get("colonZeroZero")%>", i + "<%=RLPromotionNLS.get("colonZeroZero")%>", false, false);
		document.propertiesForm.rlEndTimeSelect.options[i] = new Option(i + "<%=RLPromotionNLS.get("colonZeroZero")%>", i + "<%=RLPromotionNLS.get("colonZeroZero")%>", false, false);
	}
}

function setDateDefaults()
{
	document.propertiesForm.rlStartYear.value=getCurrentYear();
	document.propertiesForm.rlStartMonth.value=getCurrentMonth();
	document.propertiesForm.rlStartDay.value=getCurrentDay();
	document.propertiesForm.rlEndYear.value=getCurrentYear();
	document.propertiesForm.rlEndMonth.value=getCurrentMonth();
	document.propertiesForm.rlEndDay.value=getCurrentDay();
}

function setTimeDefaults()
{
	document.propertiesForm.rlStartTimeSelect.selectedIndex = 0;
	document.propertiesForm.rlEndTimeSelect.selectedIndex = 23;
}

function setupStartDate()
{
	window.yearField = document.propertiesForm.rlStartYear;
	window.monthField = document.propertiesForm.rlStartMonth;
	window.dayField = document.propertiesForm.rlStartDay;
}

function setupEndDate()
{
	window.yearField = document.propertiesForm.rlEndYear;
	window.monthField = document.propertiesForm.rlEndMonth;
	window.dayField = document.propertiesForm.rlEndDay;
}

function refreshCouponAndCustomerSegmentField(isCouponChecked)
{
	if(isCouponChecked.checked)
	{
		document.all["couponArea"].style.display = "block";
		document.all["customerSegmentArea"].style.display = "none";
		document.all["promoCodeArea"].style.display = "none";
	}
	else
	{
		document.all["couponArea"].style.display = "none";
		document.all["customerSegmentArea"].style.display = "block";
		document.all["promoCodeArea"].style.display = "block";
	}
}

function refreshMaxRedemptionPerOrderFields(maxRedemptionPerOrder)
{
	if(maxRedemptionPerOrder.options[0].selected)
	{
		document.all["maxRedemptionPerOrderArea"].style.display = "none";
	}
	else
	{
		document.all["maxRedemptionPerOrderArea"].style.display = "block";
	}
}

function refreshMaxRedemptionInTotalFields(maxRedemptionInTotal)
{
	if(maxRedemptionInTotal.options[0].selected)
	{
		document.all["maxRedemptionInTotalArea"].style.display = "none";
	}
	else
	{
		document.all["maxRedemptionInTotalArea"].style.display = "block";
	}
}

function refreshMaxRedemptionPerCustomerFields(maxRedemptionPerCustomer)
{
	if(maxRedemptionPerCustomer.options[0].selected)
	{
		document.all["maxRedemptionPerCustomerArea"].style.display = "none";
	}
	else
	{
		document.all["maxRedemptionPerCustomerArea"].style.display = "block";
	}
}

function hideDateFields()
{
	document.all["dateArea"].style.display = "none";
}

function showDateFields()
{
	document.all["dateArea"].style.display = "block";
}

function refreshDateArea(selectComp)
{
	if(selectComp.options[1].selected)
	{
		showDateFields();
	}
	else
	{
		hideDateFields();
	}
}

function hideDayChoice()
{
	document.all["dayArea"].style.display = "none";
}

function showDayChoice()
{
	document.all["dayArea"].style.display = "block";
}

function refreshDayArea(selectDay)
{
	if(selectDay.options[1].selected)
	{
		showDayChoice();
	}
	else
	{
		hideDayChoice();
	}
}

function hideTimeFields()
{
	document.all["timeArea"].style.display = "none";
}

function showTimeFields()
{
	document.all["timeArea"].style.display = "block";
}

function refreshTimeArea(selectTime)
{
	if(selectTime.options[1].selected)
	{
		showTimeFields();
	}
	else
	{
		hideTimeFields();
	}
}

function addToDefinedShopperGroup() 
{
	move(document.propertiesForm.allShopperGroup, document.propertiesForm.definedShopperGroup);
	updateSloshBuckets(document.propertiesForm.allShopperGroup, document.propertiesForm.addButton, document.propertiesForm.definedShopperGroup, document.propertiesForm.removeButton);
	initializeSummaryButton(document.propertiesForm.allShopperGroup, document.propertiesForm.definedShopperGroup, document.propertiesForm.summaryButton);	
}

function removeFromDefinedShopperGroup() 
{
	move(document.propertiesForm.definedShopperGroup, document.propertiesForm.allShopperGroup);
	updateSloshBuckets(document.propertiesForm.definedShopperGroup, document.propertiesForm.removeButton,document.propertiesForm.allShopperGroup, document.propertiesForm.addButton);
	initializeSummaryButton(document.propertiesForm.allShopperGroup, document.propertiesForm.definedShopperGroup, document.propertiesForm.summaryButton);
}

function summaryDisplay()
{
	if(document.propertiesForm.summaryButton.className=='enabled' && document.propertiesForm.summaryButton.id=='enabled')
	{   
		var segmentId = whichItemIsSelected(document.propertiesForm.allShopperGroup);
		if(segmentId == '')
		{
			segmentId = whichItemIsSelected(document.propertiesForm.definedShopperGroup);
		}
		savePanelData();
		if (parent.get) {
			var o = parent.get("<%= RLConstants.RLPROMOTION %>", null);
			if (o != null) {			
	          	top.saveData(o,"RLPromotion");			
			}
		}
		top.saveModel(parent.model);	
		top.saveData(parent.pageArray, "RLPromotionPropertiesPageArray");
		top.put("fromSegmentSummaryPage",true);
		top.setReturningPanel("RLPromotionProperties");
		var url = "/webapp/wcs/tools/servlet/SegmentDetailsDialogView?XMLFile=segmentation.SegmentDetailsDialog&segmentId=" + segmentId;
		if (top.setContent) {
			top.setContent("<%= UIUtil.toJavaScript(RLPromotionNLS.get("segmentSummary").toString())%>", url, true);
		}
		else {
			parent.location.replace(url);
		}
	}	
}

function getshopperGroupRefnum(shopperGroupName) 
{
	 var groups = parent.get("shopperGroups");
	 for (var i=0; i< groups.length; i++) 
	 {
	 	  if ( shopperGroupName == groups[i].name ) 
		  {		  
			   return groups[i].ref;				
		  }
	 }
}

function replaceSpecialChars(obj)
{
   var string = new String(obj);
   var result = string;
   for (var i=0; i<string.length;i++)
   { 	
	 result = result.replace("\\\"",'"');
   }
		
   return result;
}

function showAllShopperGroup()
{
	var shopperGroups = new Array();
	shopperGroups = parent.get("shopperGroups", null);

	if(shopperGroups != null && shopperGroups.length !=0)
	{
		setItemsSelected(document.propertiesForm.definedShopperGroup);
		move(document.propertiesForm.definedShopperGroup,document.propertiesForm.allShopperGroup);
		document.all["shopperGroupArea"].style.display = "block";
	}
	else
	{
		alertDialog('<%= UIUtil.toJavaScript(RLPromotionNLS.get("emptyGroup").toString())%>');
		document.propertiesForm.customerSegment.options[0].selected=true;
	}

}

function hideAllShopperGroup()
{
	setItemsSelected(document.propertiesForm.definedShopperGroup);
	move(document.propertiesForm.definedShopperGroup,document.propertiesForm.allShopperGroup);	
	document.all["shopperGroupArea"].style.display = "none";
}

function refreshShopperGroupArea(selectShopperGroup)
{
	if(selectShopperGroup.options[1].selected)
	{
		showAllShopperGroup();
	}
	else
	{
		hideAllShopperGroup();
	}
}

function initializeSummaryButton (aComponent1, aComponent2, aButton) {
	var selectedCount = countSelected(aComponent1) + countSelected(aComponent2);

	// if exactly one item is selected... enable the button.
	if (selectedCount == 1) {
		aButton.disabled = false;
		aButton.className = "enabled";
		aButton.id = "enabled";
	}
	else {
		aButton.disabled = true;
		aButton.className = "disabled";
		aButton.id = "disabled";
	}
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

<form name="propertiesForm" id="propertiesForm">

<h1><%=RLPromotionNLS.get("RLPromotionProperties_title")%></h1>
<table>
<tr>
<td colspan="2">
<label for="nameLabel"><%=RLPromotionNLS.get("nameLabel")%></label><br />
<%
if(calCodeId == null || calCodeId.trim().equals(""))
{
%>
	<input name="rlName" type="text" size="50" maxlength="30" id="nameLabel" />
<%
} else
{
%>
	<input name="rlName" type="text" style="border-style:none" size="50" readonly ="readonly" id="nameLabel" />
<%
}
%>
</td>
</tr>
<tr>
<td colspan="2">
<br /><label for="rlDesc"><%=RLPromotionNLS.get("descriptionLabel")%></label><br />
<textarea name="rlDesc" rows="4" cols="50" id="rlDesc"></textarea>
</td>
</tr>
<tr>
<td colspan="1">
<br /><label for="rlDescNL"><%=RLPromotionNLS.get("descriptionLabelNL")%></label><br />
<textarea name="rlDescNL" rows="4" cols="50" id="rlDescNL"></textarea>
</td>
<td colspan="1">
<br /><label for="rlDescLongNL"><%=RLPromotionNLS.get("descriptionLongLabelNL")%></label><br />
<textarea name="rlDescLongNL" rows="4" cols="50" id="rlDescLongNL"></textarea>
</td>
</tr>
<tr>
<td colspan="2">
<br /><input name="isCoupon" type="checkbox" onclick="javascript:refreshCouponAndCustomerSegmentField(this)" id="isCoupon" /> <label for="isCoupon"><%=RLPromotionNLS.get("isCoupon")%></label>
<div id="couponArea" style="display:none;margin-left: 20">
	<br /><label for="daysCouponExpire"><%=RLPromotionNLS.get("daysCouponExpire")%></label><br />
	<input name="daysCouponExpire" type="text" size="14" maxlength="14" id="daysCouponExpire" />
</div>
</td>
</tr>
<tr>
<td colspan="1">
<br /><label for="rlPromotionGroup"><%=RLPromotionNLS.get("promotionGroup")%></label><br />
<select name="rlPromotionGroup" onchange="javascript:refreshPromoTypeAndCombinationFields(this)" id="rlPromotionGroup"></select>
</td>
<td colspan="1">
<br /><label for="rlPromotionType"><%=RLPromotionNLS.get("promotionType")%></label><br />
<select name="rlPromotionType" id="rlPromotionType"></select>
</td>
</tr>
<tr>
<td colspan="1">
<br /><label for="rlPriority"><%=RLPromotionNLS.get("priorityLabel")%></label><br />
<select name="rlPriority" id="rlPriority"></select>
</td>
<td colspan="1">
<br /><label for="inCombination"><%=RLPromotionNLS.get("combinationWithOther")%></label><br />
<select name="inCombination" id="inCombination"></select>
</td>
</tr>
<tr>
<td colspan="2">
<div id="promoCodeArea" style="display:block">
<br /><label for="rlPromotionCode"><%=RLPromotionNLS.get("promotionCode")%></label><br />
<input name="rlPromotionCode" type="text" size="50" maxlength="30" id="rlPromotionCode" />
</div>
</td>
</tr>
<tr>
<td colspan="2">
<br /><label for="targetSales"><%=RLPromotionNLS.get("targetSalesVolume")%></label><br />
<input name="targetSales" type="text" size="50" maxlength="14" id="targetSales" />
</td>
</tr>
<tr>
<td colspan="2">
<br /><label for="maxRedemptionInTotal"><%=RLPromotionNLS.get("maxRedemptionInTotal")%></label><br />
<select name="maxRedemptionInTotal" onchange="javascript:refreshMaxRedemptionInTotalFields(this)" id="maxRedemptionInTotal"></select>
<div id="maxRedemptionInTotalArea" style="display:none;margin-left: 20">
	<br /><label for="rlMaxRedemptionInTotal"><%=RLPromotionNLS.get("maximumRedemption")%></label><br />
	<input name="rlMaxRedemptionInTotal" type="text" value="1" size="15" maxlength="30" id="rlMaxRedemptionInTotal" />
</div>
</td>
</tr>
<tr>
<td colspan="2">
<br /><label for="maxRedemptionPerOrder"><%=RLPromotionNLS.get("maxRedemptioPerOrder")%></label><br />
<select name="maxRedemptionPerOrder" onchange="javascript:refreshMaxRedemptionPerOrderFields(this)" id="maxRedemptionPerOrder"></select>
<div id="maxRedemptionPerOrderArea" style="display:none;margin-left: 20">
	<br /><label for="rlMaxRedemptionPerOrder"><%=RLPromotionNLS.get("maximumRedemption")%></label><br />
	<input name="rlMaxRedemptionPerOrder" type="text" value="1" size="15" maxlength="30" id="rlMaxRedemptionPerOrder" />
</div>
</td>
</tr>
<tr>
<td colspan="2">
<br /><label for="maxRedemptionPerCustomer"><%=RLPromotionNLS.get("maxRedemptionPerCustomer")%></label><br />
<select name="maxRedemptionPerCustomer" onchange="javascript:refreshMaxRedemptionPerCustomerFields(this)" id="maxRedemptionPerCustomer"></select>
<div id="maxRedemptionPerCustomerArea" style="display:none;margin-left: 20">
	<br /><label for="rlMaxRedemptionPerCustomer"><%=RLPromotionNLS.get("maximumRedemption")%></label><br />
	<input name="rlMaxRedemptionPerCustomer" type="text" value="1" size="15" maxlength="30" id="rlMaxRedemptionPerCustomer" />
</div>
</td>
</tr>
<tr>
<td colspan="2">
<br /><label for="datesPromIsAvailable"><%=RLPromotionNLS.get("datesPromIsAvailable")%></label><br />
<select name="datesPromIsAvailable" onchange="javascript:refreshDateArea(this)" id="datesPromIsAvailable"></select><br />

<script>
document.writeln('<iframe name="calendar" title="' + top.calendarTitle + '" style="display:none;position:absolute;width:198;height:230;z-index=100" id="CalFrame" marginheight="0" marginwidth="0" NORESIZE frameborder="0" scrolling="no" src="Calendar"></iframe>');
</script>
<div id="dateArea" style="display:none;margin-left: 20">
		<br />
<table border=0 cellspacing=0 cellpadding=0 id="WC_RLPromotionProperties_Table_1">
	<tr>
	<td>	
		<table border=0 cellspacing=0 cellpadding=0 id="WC_RLPromotionProperties_Table_2">
			<tr>
				<td id="WC_RLPromotionProperties_TableCell_1">&nbsp;</td>
				<td id="WC_RLPromotionProperties_TableCell_2">&nbsp;</td>
				<td id="WC_RLPromotionProperties_TableCell_3">&nbsp;</td>
				<td id="WC_RLPromotionProperties_TableCell_4"><label for="rlStartYear"><%=RLPromotionNLS.get("year")%></label></td>
				<td id="WC_RLPromotionProperties_TableCell_5">&nbsp;</td>
				<td id="WC_RLPromotionProperties_TableCell_6"><label for="rlStartMonth"><%=RLPromotionNLS.get("month")%></label></td>
				<td id="WC_RLPromotionProperties_TableCell_7">&nbsp;</td>
				<td id="WC_RLPromotionProperties_TableCell_8"><label for="rlStartDay"><%=RLPromotionNLS.get("day")%></label></td>
			</tr>
			<tr>
				<td id="WC_RLPromotionProperties_TableCell_9"><%=RLPromotionNLS.get("startDateLabel")%></td>
				<td id="WC_RLPromotionProperties_TableCell_10">&nbsp;</td>
				<td id="WC_RLPromotionProperties_TableCell_11">&nbsp;</td>
				<td id="WC_RLPromotionProperties_TableCell_12"><input type="text" value="" name="rlStartYear" size="4" maxlength="4" id="rlStartYear" /></td>
				<td id="WC_RLPromotionProperties_TableCell_13"></td>
				<td id="WC_RLPromotionProperties_TableCell_14"><input type="text" value="" name="rlStartMonth" size="2" maxlength="2" id="rlStartMonth" /></td>
				<td id="WC_RLPromotionProperties_TableCell_15"></td>
				<td id="WC_RLPromotionProperties_TableCell_16"><input type="text" value="" name="rlStartDay" size="2" maxlength="2" id="rlStartDay" /></td>
				<td id="WC_RLPromotionProperties_TableCell_17">&nbsp;</td>
				<td id="WC_RLPromotionProperties_TableCell_18">
					<a href="javascript:setupStartDate();showCalendar(document.propertiesForm.calImgStart);" id="WC_RLPromotionProperties_Link_1">
				 	<img src="/wcs/images/tools/calendar/calendar.gif" border="0" id="calImgStart" alt="Start Date"/></a>				
				</td>
				<td id="WC_RLPromotionProperties_TableCell_19">&nbsp;</td>
			</tr>
		</table>
	</td>
	<td>&nbsp;&nbsp;
	</td>
	<td>
		<table border=0 cellspacing=0 cellpadding=0 id="WC_RLPromotionProperties_Table_3">
			<tr>
				<td id="WC_RLPromotionProperties_TableCell_20">&nbsp;</td>
				<td id="WC_RLPromotionProperties_TableCell_21">&nbsp;</td>
				<td id="WC_RLPromotionProperties_TableCell_22">&nbsp;</td>
				<td id="WC_RLPromotionProperties_TableCell_23"><label for="rlEndYear"><%=RLPromotionNLS.get("year")%></label></td>
				<td id="WC_RLPromotionProperties_TableCell_24">&nbsp;</td>
				<td id="WC_RLPromotionProperties_TableCell_25"><label for="rlEndMonth"><%=RLPromotionNLS.get("month")%></label></td>
				<td id="WC_RLPromotionProperties_TableCell_26">&nbsp;</td>
				<td id="WC_RLPromotionProperties_TableCell_27"><label for="rlEndDay"><%=RLPromotionNLS.get("day")%></label></td>
			</tr>
			<tr>
				<td id="WC_RLPromotionProperties_TableCell_28"><%=RLPromotionNLS.get("endDateLabel")%></td>
				<td id="WC_RLPromotionProperties_TableCell_29">&nbsp;</td>
				<td id="WC_RLPromotionProperties_TableCell_30">&nbsp;</td>
				<td id="WC_RLPromotionProperties_TableCell_31"><input type="text" value="" name="rlEndYear" size="4" maxlength="4" id="rlEndYear" /></td>
				<td id="WC_RLPromotionProperties_TableCell_32"></td>
				<td id="WC_RLPromotionProperties_TableCell_33"><input type="text" value="" name="rlEndMonth" size="2" maxlength="2" id="rlEndMonth" /></td>
				<td id="WC_RLPromotionProperties_TableCell_34"></td>
				<td id="WC_RLPromotionProperties_TableCell_35"><input type="text" value="" name="rlEndDay" size="2" maxlength="2" id="rlEndDay" /></td>
				<td id="WC_RLPromotionProperties_TableCell_36">&nbsp;</td>
				<td id="WC_RLPromotionProperties_TableCell_37">
					<a href="javascript:setupEndDate(); showCalendar(document.propertiesForm.calImgEnd);" id="WC_RLPromotionProperties_Link_2">
				 	<img src="/wcs/images/tools/calendar/calendar.gif" border="0" id="calImgEnd" alt="End Date"/></a>
				</td>
			</tr>
		</table>
	</td>
	</tr>
	</table>
</div>
</td>
</tr>
<tr>
<td colspan="2">
<br /><label for="daysPromIsAvailable"><%=RLPromotionNLS.get("daysPromIsAvailable")%></label><br />
<select name="daysPromIsAvailable" onchange="javascript:refreshDayArea(this)" id="daysPromIsAvailable"></select><br />

<div id="dayArea" style="display:none;margin-left: 20">
<br />
<input name="daysInWeek" type="checkbox" value="<%= RLConstants.RLPROMOTION_MONDAY %>" id="monday" />
<label for="monday"><%= RLPromotionNLS.get("monday") %></label>

<input name="daysInWeek" type="checkbox" value="<%= RLConstants.RLPROMOTION_TUESDAY %>" id="tuesday" />
<label for="tuesday"><%= RLPromotionNLS.get("tuesday") %></label>

<input name="daysInWeek" type="checkbox" value="<%= RLConstants.RLPROMOTION_WEDNESDAY %>" id="wednesday" />
<label for="wednesday"><%= RLPromotionNLS.get("wednesday") %></label>

<input name="daysInWeek" type="checkbox" value="<%= RLConstants.RLPROMOTION_THURSDAY %>" id="thursday" />
<label for="thursday"><%= RLPromotionNLS.get("thursday") %></label>

<input name="daysInWeek" type="checkbox" value="<%= RLConstants.RLPROMOTION_FRIDAY %>" id="friday" />
<label for="friday"><%= RLPromotionNLS.get("friday") %></label>

<input name="daysInWeek" type="checkbox" value="<%= RLConstants.RLPROMOTION_SATURDAY %>" id="saturday" />
<label for="saturday"><%= RLPromotionNLS.get("saturday") %></label>

<input name="daysInWeek" type="checkbox" value="<%= RLConstants.RLPROMOTION_SUNDAY %>" id="sunday" />
<label for="sunday"><%= RLPromotionNLS.get("sunday") %></label>
</div>

</td>
</tr>
<tr>
<td colspan="2">
<br /><label for="timePromIsAvailable"><%=RLPromotionNLS.get("timePromIsAvailable")%></label><br />
<select name="timePromIsAvailable" onchange="javascript:refreshTimeArea(this);" id="timePromIsAvailable"></select><br />

<div id="timeArea" style="display:none;margin-left: 20">
        <br /><table border="0" cellspacing="3" cellpadding="0" id="WC_RLPromotionProperties_Table_21">
          <tr align="left" valign="middle">
            <td id="WC_RLPromotionProperties_TableCell_351">  <label for="rlStartTimeSelect"><%=RLPromotionNLS.get("startTimeLabel")%></label></td>
            <td id="WC_RLPromotionProperties_TableCell_361"><select name="rlStartTimeSelect" id="rlStartTimeSelect"></select></td>
            <td id="WC_RLPromotionProperties_TableCell_371">  <label for="rlEndTimeSelect"><%=RLPromotionNLS.get("endTimeLabel")%></label> </td>
            <td id="WC_RLPromotionProperties_TableCell_38"><select name="rlEndTimeSelect" id="rlEndTimeSelect"></select></td>
          </tr>
        </table>
</div>

</td>
</tr>
<tr>
<td colspan="2">
 <div id="customerSegmentArea" style="display:block">
<br /><label for="customerSegment"><%=RLPromotionNLS.get("customerSegment")%></label><br />
<select name="customerSegment" onchange="javascript:refreshShopperGroupArea(this);" id="customerSegment"></select><br />

   <div id="shopperGroupArea" style="display:none;margin-left: 20">
       <br />
       <table border='0' id="WC_RLPromotionProperties_Table_39">
         <tr>
        <td id="WC_RLPromotionProperties_TableCell_40"><label for="definedShopperGroup"><%=RLPromotionNLS.get("definedShopperGroups")%></label></td>
   	<td width='20' id="WC_RLPromotionProperties_TableCell_41">&nbsp;</td>
   	<td id="WC_RLPromotionProperties_TableCell_42"><label for="allShopperGroup"><%=RLPromotionNLS.get("allShopperGroupsLbl")%></label></td>
         </tr>

   	  <!-- all shopper groups -->
          <tr>
           <td id="WC_RLPromotionProperties_TableCell_43">
   	     <select name='definedShopperGroup' id="definedShopperGroup" class='selectWidth' multiple ="multiple" size='<%=NUMOFVISIBLEITEMSINLIST%>' onchange="javascript:updateSloshBuckets(this, document.propertiesForm.removeButton, document.propertiesForm.allShopperGroup, document.propertiesForm.addButton);	initializeSummaryButton(document.propertiesForm.allShopperGroup, document.propertiesForm.definedShopperGroup, document.propertiesForm.summaryButton);">

         	   </select>
     	   </td>

   	   <td width=150px align=center id="WC_RLPromotionProperties_TableCell_44"><br />
   	      <input type='button' name='addButton' class="disabled" style='width:120px' value='<%=RLPromotionNLS.get("buttonAdd")%>' onclick="addToDefinedShopperGroup();parent.put('lastupdategui', '<%=RLPromotionNLS.get("definedshoppergroups")%>');" /><br />
   	      <input type='button' name='removeButton' class="disabled" style='width:120px' value='<%=RLPromotionNLS.get("buttonRemove")%>' onclick="removeFromDefinedShopperGroup();parent.put('lastupdategui', '<%=RLPromotionNLS.get("definedshoppergroups")%>');" /><br />
   	      <input type='button' name='summaryButton' class="disabled" style='width:120px' value='<%=RLPromotionNLS.get("buttonSummary")%>' onclick="summaryDisplay()" /><br /><br />
   	   </td>
           <td id="WC_RLPromotionProperties_TableCell_45">
             <select name='allShopperGroup' id="allShopperGroup" class='selectWidth' multiple ="multiple" size='<%=NUMOFVISIBLEITEMSINLIST%>' onchange="javascript:updateSloshBuckets(this, document.propertiesForm.addButton, document.propertiesForm.definedShopperGroup, document.propertiesForm.removeButton);	initializeSummaryButton(document.propertiesForm.allShopperGroup, document.propertiesForm.definedShopperGroup, document.propertiesForm.summaryButton);">
   	     <!-- all available shopper groups for merchant -->

   	     </select>
   	   </td>
          </tr>
      </table>
  </div>

 </div>

</td>
</tr>
</table>

</form>
</body>
</html>
