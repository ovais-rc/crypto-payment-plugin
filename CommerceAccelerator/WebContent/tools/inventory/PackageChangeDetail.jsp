<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2008, 2016 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
			
<!--  ES 10/15/01
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
-->
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.server.ECConstants" %>
<%@ page import="com.ibm.commerce.tools.segmentation.SegmentConstants" %>
<%@ page import="com.ibm.commerce.tools.util.ResourceDirectory" %>
<%@ page import="com.ibm.commerce.utils.TimestampHelper" %>
<%@ page import="com.ibm.commerce.tools.util.UIUtil" %>
<%@ page import="java.util.Hashtable" %>
<%@ page import="java.util.Locale" %>
<%@ page language="java" %>
 
<%@ page import="java.io.*" %>
<%@ page import="java.lang.*" %>
<%@ page import="java.math.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="javax.servlet.*" %>
<%@ page import="com.ibm.commerce.base.objects.*" %>
<%@ page import="com.ibm.commerce.beans.*" %>
<%@ page import="com.ibm.commerce.command.*" %>
<%@ page import="com.ibm.commerce.datatype.*" %>
<%@ page import="com.ibm.commerce.server.*" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.common.objects.*" %>
<%@ page import="com.ibm.commerce.price.utils.*" %>
<%@ page import="com.ibm.commerce.user.beans.*"   %>
<%@ page import="com.ibm.commerce.user.objects.*"   %>
<%@ page import="com.ibm.commerce.utils.TimestampHelper" %>
<%@ page import="com.ibm.commerce.inventory.beans.*" %>
<%@ page import="com.ibm.commerce.inventory.objects.*" %>
<%@ page import="com.ibm.commerce.fulfillment.objects.*" %>
<%@ page import="com.ibm.commerce.fulfillment.beans.*" %>
<%@ page import="com.ibm.commerce.tools.util.UIUtil" %>

<%@ include file= "../common/common.jsp" %>

<jsp:useBean id="shipmodeList" scope="request" class="com.ibm.commerce.tools.shipping.ShippingModeListDataBean">
</jsp:useBean>

<jsp:useBean id="detailChange" scope="request" class="com.ibm.commerce.inventory.beans.PackageShipDetailListDataBean">
</jsp:useBean>

<%
response.setContentType("text/html;charset=UTF-8");
CommandContext commandContext = (CommandContext) request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
Locale locale = commandContext.getLocale();
Hashtable resources = (Hashtable) ResourceDirectory.lookup("inventory.FulfillmentNLS", locale);
Hashtable calendarNLS = (Hashtable)ResourceDirectory.lookup("common.calendarNLS", locale);

Integer langId = commandContext.getLanguageId();
String strLangId = langId.toString();

Integer storeId = commandContext.getStoreId();
String strStoreId = storeId.toString();

String ffmcId = UIUtil.getFulfillmentCenterId(request);

String manifestId = request.getParameter("manifestId");
String orderNum = request.getParameter("orderNumber");
String releaseNum = request.getParameter("releaseNumber");

//***** get detail info
PackageShipDetailDataBean packageIDs[] = null;
int numberOfPackageIds = 0;

detailChange.setFfmCenterId(ffmcId);
detailChange.setStoreentId(strStoreId);
detailChange.setManifestId(manifestId);

DataBeanManager.activate(detailChange, request);
packageIDs = detailChange.getPackageShipDetailList();

if (packageIDs != null)
{
  numberOfPackageIds = packageIDs.length;
}

PackageShipDetailDataBean packageBean;
int ii = 0;
packageBean = packageIDs[ii];

String shipDate = packageBean.getDateShipped();
String strShipDate = null;
String orderYear = null;
String orderDay = null;
String orderMonth = null;
if (shipDate == null){
	strShipDate = "";
} else {
 	strShipDate = shipDate.trim(); 

   Timestamp t = Timestamp.valueOf(strShipDate);
    orderYear = TimestampHelper.getYearFromTimestamp(t);
    orderDay = TimestampHelper.getDayFromTimestamp(t);
    orderMonth = TimestampHelper.getMonthFromTimestamp(t);

}

String packageId = UIUtil.toHTML(packageBean.getPackageId());
String strPackageId = null;
if (packageId == null){
	strPackageId = "";
} else {
	strPackageId = packageId.trim();
}

String shipMode = packageBean.getShipModeId();
String strShipMode = null;
if (shipMode == null){
	strShipMode = "";
} else {
	strShipMode = shipMode.trim();
}

String curr = UIUtil.toHTML(packageBean.getSetCcurr());
String strCurr = null;
if (curr == null){
	strCurr = "";
} else{
	strCurr = curr.trim();
}

String shippingCosts = packageBean.getShippingCosts();
String strShippingCosts = null;
if (shippingCosts == null){
	strShippingCosts = "0";
} else {
	strShippingCosts = shippingCosts.trim();
}

String trackingId = UIUtil.toHTML(packageBean.getTrackingId());
String strTrackingId = null;
if (trackingId == null){
	strTrackingId = "";
} else {
	strTrackingId = trackingId.trim();
}

String pickupId = UIUtil.toHTML(packageBean.getPickUpRecordId());
String strPickupId = null;
if (pickupId == null){
	strPickupId = "";
} else {
	strPickupId = pickupId.trim();
}

String weight = packageBean.getWeight();
String strWeight = null;
if (weight == null){
	strWeight = "0";
} else {
	strWeight = weight.trim();
}

String weightMeasure = UIUtil.toHTML(packageBean.getWeightMeasure());
String strWeightMeasure = null;
if (weightMeasure == null){
	strWeightMeasure = "";
} else {
	strWeightMeasure = weightMeasure.trim();
}

//***** get the supported currencies for a store
StoreAccessBean storeAB = com.ibm.commerce.server.WcsApp.storeRegistry.find(storeId);

CurrencyManager cm = CurrencyManager.getInstance();
String[] supportedCurrencies = cm.getSupportedCurrencies( storeAB );

//***** get weight measures
QuantityManager qm = QuantityManager.getInstance();
List supportedUnits = qm.getConvertableUnits("LBR");
int numberOfUnits = 0;

if (supportedUnits != null) {
	numberOfUnits = supportedUnits.size();
}

Vector vecUnitId = new Vector();
Vector vecDesc = new Vector();

String unitId = null;
String unitDesc = null;

for (int u=0; u < numberOfUnits ; u++)
{
      unitId = (String) supportedUnits.get(u);
      unitDesc = qm.getDescription(storeAB, unitId, langId);
      vecUnitId.addElement(unitId);
      vecDesc.addElement(unitDesc);
}


//***** populate shipmode drop down list
ShippingModeDataBean shipIds[] = null;
int numberOfShips = 0;

DataBeanManager.activate(shipmodeList, request);
shipIds = shipmodeList.getShippingModeList();

if (shipIds != null){
     numberOfShips = shipIds.length;
}

Vector vecShipId = new Vector();
Vector vecShipDisplayName = new Vector();
ShippingModeDataBean shipmode;

String shipmodeId = null;

for (int i=0; i < numberOfShips ; i++)
{
      shipmode = shipIds[i];

      shipmodeId = shipmode.getShippingModeId();
      StringBuffer strBufShipModeName = new StringBuffer(0);
      strBufShipModeName.append(shipmode.getCode());
      
      com.ibm.commerce.fulfillment.objects.ShippingModeDescriptionAccessBean shipModeDesc 
      	= shipmode.getDescription(langId,shipmode.getStoreEntityIdInEntityType());
      if(shipModeDesc != null){
     	String strDesc = shipModeDesc.getDescription();
     	if(strDesc != null){
     		strBufShipModeName.append(" - ");
     		int endIndex = 30;
     		if(endIndex > strDesc.length()){
     			endIndex = strDesc.length();
     		}
      		strBufShipModeName.append(strDesc.substring(0,endIndex));   
     	}            
      } 
      vecShipId.addElement(shipmodeId);
      vecShipDisplayName.addElement(strBufShipModeName.toString());
}

shipmodeId = strShipMode;

%>

<HTML>

<HEAD>
<LINK rel="stylesheet" href="<%= UIUtil.getCSSFile(locale) %>" type="text/css">


<SCRIPT SRC="/wcs/javascript/tools/common/DateUtil.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/common/NumberFormat.js"></SCRIPT>


<SCRIPT>

function savePanelData()
{

	var packageId = trim(document.PackageDetail.PDPACKAGEID.value);
	var trackingId = trim(document.PackageDetail.PDTRACKINGID.value);
	var pickupId = trim(document.PackageDetail.PDPICKUPID.value);
	var provider = trim(document.PackageDetail.shipmodeId.value);
	var weightM = trim(document.PackageDetail.PDPACKAGEWEIGHT.value);
	if (weightM != '') {
		var weight = parent.strToNumber(weightM, "<%=strLangId%>");
	}

	var weightUnit = trim(document.PackageDetail.Units.value);
	var costM = trim(document.PackageDetail.PDSHIPPINGCOSTS.value);
	var currency = trim(document.PackageDetail.Currency.value);

	var cost = parent.currencyToNumber(costM, currency, "<%=strLangId%>")

	var manifestId = '<%=UIUtil.toJavaScript(manifestId)%>';
	var shipDate = trim(document.PackageDetail.YEAR1.value) + '-' + trim(document.PackageDetail.MONTH1.value) + '-' + trim(document.PackageDetail.DAY1.value) + ' 00:00:00.000'; 
	var orderNum = '<%=UIUtil.toJavaScript(orderNum)%>';
	var releaseNum = '<%=UIUtil.toJavaScript(releaseNum)%>';
	var status = "S";

	parent.put("manifestId",manifestId);
	parent.put("manifestStatus",status);
	parent.put("packageId",packageId);
	parent.put("trackingId",trackingId);
	parent.put("pickupRecordId",pickupId);
	parent.put("shipModeId",provider);
	parent.put("weight",weight);
	parent.put("weightMeasure",weightUnit);
	parent.put("shippingCosts",cost);
	parent.put("setCCurr",currency);
	parent.put("dateShipped",shipDate);
	parent.put("ordersId",orderNum);
	parent.put("ordReleaseNum",releaseNum);
	parent.put("updateManifestStatus","0");
}


function setupDate()
{
  window.yearField = document.PackageDetail.YEAR1;
  window.monthField = document.PackageDetail.MONTH1;
  window.dayField = document.PackageDetail.DAY1;
}


function currArray()
{
	var currArray = new Array();
	<% int a=0;
	while (a < supportedCurrencies.length) 
	{%>
		currArray[<%=a%>] = "<%=supportedCurrencies[a]%>";
		<%a++;
	}%>


	parent.put("storeCurrArray", currArray);
}


function loadDiscCurr()
{
	var storeCurrs = parent.get("storeCurrArray");
	var curr = "";
	var currChange = "<%=strCurr%>";
	for(var a=0; a<storeCurrs.length; a++)
	{
	  document.PackageDetail.Currency.options[a] = new Option(storeCurrs[a], storeCurrs[a], false, false);
	  curr = trim(storeCurrs[a]);
	  if (curr == currChange) {
		document.PackageDetail.Currency.value = curr ;
	  }
	}
}


function setUnit()
{
	var unitChange = '<%=strWeightMeasure%>';
    	document.PackageDetail.Units.value = unitChange ;
}


function setFFC(){

    var shipmodeId = '<%= strShipMode %>';
    var vecShipId = new Array();
    vecShipId = <%= vecShipId %>;
    for (i=0; (i < <%= numberOfShips %> - 1) && (vecShipId[i] != shipmodeId); i++){}
    if (vecShipId[i] == shipmodeId) {
    	document.PackageDetail.shipmodeId.value = shipmodeId ;
	}
}


function setNumbers() {
	var nWeight = <%= strWeight %>;

	var lang = "<%=strLangId%>";
	if ( nWeight != 0) {		
		nWeight = parent.numberToStr(nWeight,lang , 2); 
		document.PackageDetail.PDPACKAGEWEIGHT.value = nWeight ;
	}

	var nCost = <%= strShippingCosts %>;
	var currn = "<%=strCurr%>";		
		nCost = round(nCost,2); 
		nCost = parent.numberToCurrency(nCost, currn, lang);
		document.PackageDetail.PDSHIPPINGCOSTS.value = nCost ;

}


function validatePanelData()
{

	var packageId = trim(document.PackageDetail.PDPACKAGEID.value);	
	var trackingId = trim(document.PackageDetail.PDTRACKINGID.value);
	var pickupId = trim(document.PackageDetail.PDPICKUPID.value);

   if (!parent.isValidUTF8length(packageId, 20)) {
    	alertDialog('<%=UIUtil.toJavaScript((String)resources.get("exceedMaxLength"))%>');
    	document.PackageDetail.PDPACKAGEID.select();
    	document.PackageDetail.PDPACKAGEID.focus();		
    	return false;
   }

   if (!parent.isValidUTF8length(trackingId, 20)) {
    	alertDialog('<%=UIUtil.toJavaScript((String)resources.get("exceedMaxLength"))%>');
    	document.PackageDetail.PDTRACKINGID.select();
    	document.PackageDetail.PDTRACKINGID.focus();		
    	return false;
   }

   if (!parent.isValidUTF8length(pickupId, 20)) {
    	alertDialog('<%=UIUtil.toJavaScript((String)resources.get("exceedMaxLength"))%>');
    	document.PackageDetail.PDPICKUPID.select();
    	document.PackageDetail.PDPICKUPID.focus();		
    	return false;
   }
  var weight = trim(document.PackageDetail.PDPACKAGEWEIGHT.value);
  var len = weight.length;

  var cost = trim(document.PackageDetail.PDSHIPPINGCOSTS.value);
  var curr = trim(document.PackageDetail.Currency.value);

  if (len!=0) {
    if ( !parent.isValidNumber(weight, "<%=strLangId%>") )
   {
    alertDialog('<%=UIUtil.toJavaScript((String)resources.get("invalidQuantity"))%>');
    document.PackageDetail.PDPACKAGEWEIGHT.select();
    document.PackageDetail.PDPACKAGEWEIGHT.focus();
    return false;
   }
  }

    if ( !parent.isValidCurrency(cost, curr, "<%=strLangId%>") )

  {
    alertDialog('<%=UIUtil.toJavaScript((String)resources.get("invalidCost"))%>');
    document.PackageDetail.PDSHIPPINGCOSTS.select();
    document.PackageDetail.PDSHIPPINGCOSTS.focus();
    return false;
  }
    
  {
    
      if (!validDate(document.PackageDetail.YEAR1.value , document.PackageDetail.MONTH1.value, document.PackageDetail.DAY1.value)){
        alertDialog('<%=UIUtil.toJavaScript((String)resources.get("invalidDate"))%>');
        document.PackageDetail.YEAR1.select();
        document.PackageDetail.YEAR1.focus();
        return false;
      }
    
      return true;
   }
}


function loadPanelData()
  
 {
  setNumbers();

  currArray();
  loadDiscCurr();

  setUnit();

  setFFC();

  if (parent.setContentFrameLoaded)
   {
    parent.setContentFrameLoaded(true);
   }
 }

function cancel () {
  var answer = parent.confirmDialog('<%=UIUtil.toJavaScript((String)resources.get("cancelAction"))%>');
  if (answer) top.goBack();
 }

</SCRIPT>
<META name="GENERATOR" content="IBM WebSphere Studio">
</HEAD>

<BODY ONLOAD="loadPanelData()" CLASS="content">

<IFRAME STYLE="display:none;position:absolute;width:198;height:230;z-index=100" ID="CalFrame" TITLE="<%= calendarNLS.get("calendarTitle") %>" MARGINHEIGHT=0 MARGINWIDTH=0 FRAMEBORDER=0 SCROLLING=NO SRC="/webapp/wcs/tools/servlet/tools/common/Calendar.jsp"></IFRAME>

<script language="javascript"><!--alert("PackageChangeDetail.jsp");--></script> 

<H1><%= UIUtil.toHTML((String)resources.get("PackageDetailChangePanel")) %></H1>   


<FORM NAME="PackageDetail" >

<TABLE>
  <TR>
    <TD width="66"></TD>
    <TD>
    <TABLE>
       <TBODY>

		<TR><TD>
			<LABEL for="PDPACKAGEID"><%= UIUtil.toHTML((String)resources.get("PDPackageID")) %></LABEL>
			<INPUT TYPE = TEXT VALUE ="<%=strPackageId%>" NAME=PDPACKAGEID ID="PDPACKAGEID" SIZE=20 maxlength=20/>
		</TD></TR>

		<TR><TD>
			<LABEL for="PDTRACKINGID"><%= UIUtil.toHTML((String)resources.get("PDTrackingID")) %></LABEL>
			<INPUT TYPE = TEXT VALUE ="<%=strTrackingId%>" NAME=PDTRACKINGID ID="PDTRACKINGID" SIZE=20 maxlength=20/>
		</TD></TR>

		<TR>
		    <TD>
			<LABEL for="PDPICKUPID"><%= UIUtil.toHTML((String)resources.get("PDPickupID")) %></LABEL>    
			<INPUT TYPE = TEXT VALUE ="<%=strPickupId%>" NAME=PDPICKUPID ID="PDPICKUPID" SIZE=20 maxlength=20/>
		    </TD>
		</TR>

		<TR><TD>
		<TABLE>
    			<TR>
      				<TD>
      				<LABEL for="shipmodeId"><%= UIUtil.toHTML((String)resources.get("PDShippingProvider")) %></LABEL>
      				</TD>
    			</TR>
    			<TR>
				<TD>
        				<SELECT NAME=shipmodeId ID="shipmodeId" >
					<%int firstTime = 1;
    					for (int i=0; i<numberOfShips ; i++) {
      					String shipName = (String) vecShipDisplayName.elementAt(i);
					String shipModeId = (String) vecShipId.elementAt(i);%>
      					<OPTION value="<%= shipModeId %>" <%if (firstTime == 1) {%> SELECTED <%}%> >
      					<%= shipName %></OPTION><%firstTime = 0;}%></SELECT>
      				</TD>
   		    	</TR>
		</TABLE>
		</TD></TR>

        <TR><TD>
		<TABLE>
         		<TR>
           			<TD><LABEL for="PDPACKAGEWEIGHT"><%= UIUtil.toHTML((String)resources.get("PDPackageWeight")) %></LABEL></TD>
           			<TD>&nbsp;</TD>
           			<TD><LABEL for="Units"><%= UIUtil.toHTML((String)resources.get("PDUnit")) %></LABEL></TD>
           			<TD>&nbsp;</TD>
         		</TR>
         		<TR>
           			<TD ><INPUT TYPE=TEXT VALUE="" NAME=PDPACKAGEWEIGHT ID="PDPACKAGEWEIGHT" SIZE=10></TD>
				    <TD>&nbsp;</TD>
				    <TD>
         				<SELECT NAME=Units ID="Units" >
					<% int ft = 1;
					for (int i=0; i<numberOfUnits ; i++) { 
      					String unitDisplay = (String) vecDesc.elementAt(i);
					String unitWId = (String) vecUnitId.elementAt(i);%>
      					<OPTION value="<%= unitWId %>"  <%if (ft == 1) {%> SELECTED <%}%> >
      					<%= unitDisplay %></OPTION><%ft = 0;}%></SELECT>
 				    </TD>
           			<TD>&nbsp;</TD>


         		</TR>

         		<TR>
           			<TD><LABEL for="PDSHIPPINGCOSTS"><%= UIUtil.toHTML((String)resources.get("PDShippingCosts")) %></LABEL></TD>
           			<TD>&nbsp;</TD>
           			<TD><LABEL for="Currency"><%= UIUtil.toHTML((String)resources.get("PDCurrency")) %></LABEL></TD>
           			<TD>&nbsp;</TD>
         		</TR>
         		<TR>
           			<TD ><INPUT TYPE=TEXT VALUE="" NAME=PDSHIPPINGCOSTS ID="PDSHIPPINGCOSTS" SIZE=10></TD>
           			<TD>&nbsp;</TD>
           			<TD ><SELECT NAME=Currency ID="Currency" ></SELECT></TD>
           			<TD>&nbsp;</TD>
          		</TR>
		</TABLE>
		</TD></TR>

		<TR><TD>
		<TABLE>
			<TR>
				<TD><LABEL><%= UIUtil.toHTML((String)resources.get("PDShippingDate")) %></LABEL></TD>
			</TR>

			<TABLE>
         		   <TR>
           			<TD><LABEL for="YEAR1"><%= UIUtil.toHTML((String)resources.get("year")) %></LABEL></TD>
           			<TD>&nbsp;</TD>
           			<TD><LABEL for="MONTH1"><%= UIUtil.toHTML((String)resources.get("month")) %></LABEL></TD>
           			<TD>&nbsp;</TD>
           			<TD><LABEL for="DAY1"><%= UIUtil.toHTML((String)resources.get("day")) %></LABEL></TD>
         		   </TR>
         		   <TR>
           			<TD ><INPUT TYPE=TEXT VALUE="<%=orderYear%>" NAME=YEAR1 ID="YEAR1"  SIZE=4 maxlength=4></TD>
           			<TD></TD><TD ><INPUT TYPE=TEXT VALUE="<%=orderMonth%>" NAME=MONTH1 ID="MONTH1" SIZE=2 maxlength=2></TD>
           			<TD></TD><TD><INPUT TYPE=TEXT VALUE="<%=orderDay%>" NAME=DAY1 ID="DAY1" SIZE=2 maxlength=2></TD>
           			<TD>&nbsp;</TD>
           			<TD><A HREF="javascript:setupDate();showCalendar(document.PackageDetail.calImg)">
             			<IMG SRC="/wcs/images/tools/calendar/calendar.gif" ALT="<%=resources.get("chooseDate")%>" BORDER=0 id=calImg></A></TD>   
         		   </TR>
			</TABLE>
		</TABLE>
		</TD></TR>
		
    	</TABLE>
  </TR>
</TABLE>

</FORM>
</BODY>
</HTML>


























