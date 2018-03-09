<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2001, 2016 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<%@ page language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="com.ibm.commerce.beans.*" %>
<%@ page import="com.ibm.commerce.common.beans.StoreDataBean" %>
<%@ page import="com.ibm.commerce.command.*" %>
<%@ page import="com.ibm.commerce.server.*" %>
<%@ page import="com.ibm.commerce.tools.contract.beans.*" %>
<%@ page import="com.ibm.commerce.tools.optools.order.commands.*" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.user.beans.*" %>
<%@ page import="com.ibm.commerce.ordermanagement.beans.BlockReasonCodeDataBean" %>
<%@include file="../common/common.jsp" %>
<jsp:useBean id="storeLang" scope="request" class="com.ibm.commerce.tools.common.ui.StoreLanguageBean">
</jsp:useBean>

<%!
//
// Get the user logon
// @param customerId	The customer reference number
// @param request	The HTTP Request
//
public String getUserLogon(String customerId, HttpServletRequest request) {
	try {
		if (customerId != null && !customerId.equals("")) {
			UserRegistrationDataBean userBean = new UserRegistrationDataBean();
			userBean.setUserId(customerId);
			DataBeanManager.activate(userBean, request);
	
			if (userBean.getLogonId() != null) {
				return userBean.getLogonId();
			}
		}
	} catch (Exception ex) {
		return "";
	}
	return "";
}
%>

<%
// obtain the resource bundle for display
CommandContext cmdContextLocale = (CommandContext)request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
Locale jLocale = cmdContextLocale.getLocale();
Hashtable orderLabels = (Hashtable)ResourceDirectory.lookup("order.orderLabels", jLocale);
Hashtable calendarNLS = (Hashtable)ResourceDirectory.lookup("common.calendarNLS", jLocale);
     

// Enable store type filtering
storeLang.setStoreTypeFiltering(true);
storeLang.setDropShipIncluded(true);
String error = storeLang.Init(cmdContextLocale);


// retrieve request parameters
JSPHelper jspHelp = new JSPHelper(request);
String customerId = jspHelp.getParameter(ECOptoolsConstants.EC_OPTOOL_CUSTOMER_ID);

Integer storeId 	= cmdContextLocale.getStoreId();
StoreDataBean  storeBean = new StoreDataBean();
storeBean.setStoreId(storeId.toString());
com.ibm.commerce.beans.DataBeanManager.activate(storeBean, request);

if (customerId == null) {
	customerId = "";
}

%>

<HTML>
<HEAD>
<link rel=stylesheet href="<%= UIUtil.getCSSFile(jLocale) %>" type="text/css"> 
<TITLE></TITLE>
<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/common/DateUtil.js"></SCRIPT>

<SCRIPT FOR=document EVENT="onclick()">
	document.all.CalFrame.style.display="none";
</SCRIPT>

<SCRIPT LANGUAGE="JavaScript">
<!---- hide script from old browsers

function initializeState()
{
	parent.setContentFrameLoaded(true);
}

function savePanelData()
{
}

function onLoad() {
	initializeState();
}

function setupOrderDateSD()
{
	window.yearField = document.all.orderDateSDYear;
	window.monthField = document.all.orderDateSDMonth;
	window.dayField = document.all.orderDateSDDay;  
}

function setupOrderDateED()
{
	window.yearField = document.all.orderDateEDYear;
	window.monthField = document.all.orderDateEDMonth;
	window.dayField = document.all.orderDateEDDay;
}

function setupLastUpdateSD()
{
	window.yearField = document.all.lastUpdateSDYear;
	window.monthField = document.all.lastUpdateSDMonth;
	window.dayField = document.all.lastUpdateSDDay;  
}

function setupLastUpdateED()
{
	window.yearField = document.all.lastUpdateEDYear;
	window.monthField = document.all.lastUpdateEDMonth;
	window.dayField = document.all.lastUpdateEDDay;
}


function isEmpty(id) {
    if (defined(id)){
	  return !id.match(/[^\s]/);
	}
	return true;
}

function trim(inString) {
	var retString = inString;
	var ch = retString.substring(0,1);
 	while(ch == " "){
 		retString=retString.substring(1,retString.length);
 		ch=retString.substring(0,1);
 	}
 	ch=retString.substring(retString.length-1,retString.length)
 	while(ch == " "){
 		retString=retString.substring(0,retString.length-1);
 		ch=retString.substring(retString.length-1,retString.length);	
	}
	return retString;
}

function isNumber(word)
{
   	var numbers="0123456789";
   	var word=trim(word);
	for (var i=0; i < word.length; i++)
	{
		if (numbers.indexOf(word.charAt(i)) == -1) 
		return false;
	}
	return true;
}

function createSDTimestampString(year, month, day)
{
	var returnString = year  + "-" +
			   month + "-" +
			   day   + " 00:00:00.000000000";
	return returnString;
}

function createEDTimestampString(year, month, day)
{
         var returnString = year  + "-" +
			    month + "-" +
			    day   + " 23:59:59.999999";
	return returnString;
}
function isOrgIdValid(word)
{
   	var numbers="-0123456789";
   	var word=trim(word);
	for (var i=0; i < word.length; i++)
	{
		if (numbers.indexOf(word.charAt(i)) == -1) 
		return false;
	}
	return true;
}

function validateStatus(){
    return (document.orderFindForm.orderState.value == "all");
}

function checkBlock(){
     return (document.orderFindForm.orderBlocked.value =="");
}

function checkNotFulfillment(){
   return (getNotFulfilled() == "");
}

function blockSelected(){
  if (document.orderFindForm.orderBlocked.value == "Y"){
     blockReasonLabel0.style.display="block";
     blockReason0.style.display="block";
  }else{
     blockReasonLabel0.style.display="none";
     blockReason0.style.display="none";  
  }
  document.all["orderBlockReason"].options[0].selected = true; 
}

function validateEntries()
{
    if (isEmpty(document.orderFindForm.orderId.value) && isEmpty(document.orderFindForm.userLogon.value) 
	   && validateStatus() && isEmpty(document.orderFindForm.shipFirstName.value) && isEmpty(document.orderFindForm.shipLastName.value) 
	   && isEmpty(document.orderFindForm.billFirstName.value) && isEmpty(document.orderFindForm.billLastName.value)
	   && isEmpty(document.orderFindForm.shipAddress1.value) && isEmpty(document.orderFindForm.shipZipcode.value)
       && isEmpty(document.orderFindForm.billAddress1.value) && isEmpty(document.orderFindForm.billZipcode.value)
 	   && isEmpty(document.orderFindForm.orgName.value) 
 	   && isEmpty(document.orderFindForm.ordersField1.value)
 	   && isEmpty(document.orderFindForm.SKU.value)
       && isEmpty(document.orderFindForm.orgField1.value) && isEmpty(document.orderFindForm.billCity.value)
       && isEmpty(document.orderFindForm.fulfillmentCenterId.value) && isEmpty(document.orderFindForm.orderItemStatus.value)
       && isEmpty(document.orderFindForm.protocolDataValue1.value)
       && checkBlock() && checkNotFulfillment() && isEmpty(document.orderFindForm.shipCity.value) 
	   && isEmpty(document.orderFindForm.orderDateSDDay.value) && isEmpty(document.orderFindForm.orderDateSDMonth.value)
	   && isEmpty(document.orderFindForm.orderDateSDYear.value) && isEmpty(document.orderFindForm.orderDateEDDay.value)
	   && isEmpty(document.orderFindForm.orderDateEDMonth.value) && isEmpty(document.orderFindForm.orderDateEDYear.value)
	   && isEmpty(document.orderFindForm.lastUpdateSDDay.value) && isEmpty(document.orderFindForm.lastUpdateSDMonth.value)
	   && isEmpty(document.orderFindForm.lastUpdateSDYear.value) && isEmpty(document.orderFindForm.lastUpdateEDDay.value)
	   && isEmpty(document.orderFindForm.lastUpdateEDMonth.value) && isEmpty(document.orderFindForm.lastUpdateEDYear.value)
	   && isEmpty(document.orderFindForm.firstName.value) && isEmpty(document.orderFindForm.lastName.value)  
	   && isEmpty(document.orderFindForm.address1.value) && isEmpty(document.orderFindForm.zipcode.value) 
	   && isEmpty(document.orderFindForm.city.value) 
	   && isEmpty(document.orderFindForm.email1.value) && isEmpty(document.orderFindForm.phone1.value) 
 	    ) {
		alertDialog('<%=UIUtil.toJavaScript((String)orderLabels.get("findDialogNoCriteria"))%>');
		return false;
	} else {
	
		//validate order number
		if (!isEmpty(document.orderFindForm.orderId.value)) {
			if (!isNumber(document.orderFindForm.orderId.value)) {
				alertDialog ('<%=UIUtil.toJavaScript((String)orderLabels.get("findDialogInvalidNumber"))%>');
				return false;
			}   
		}
	
		//validate order date SD
		if (!isEmpty(document.orderFindForm.orderDateSDDay.value) || !isEmpty(document.orderFindForm.orderDateSDMonth.value) 
		    || !isEmpty(document.orderFindForm.orderDateSDYear.value) ) {
	    		if ( !validDate(document.orderFindForm.orderDateSDYear.value, document.orderFindForm.orderDateSDMonth.value, document.orderFindForm.orderDateSDDay.value) ) {
				alertDialog ('<%=UIUtil.toJavaScript((String)orderLabels.get("invalidOrderDateSD"))%>');
				return false;
			}
		}
		
		//validate order date ED
		if (!isEmpty(document.orderFindForm.orderDateEDDay.value) || !isEmpty(document.orderFindForm.orderDateEDMonth.value) 
		    || !isEmpty(document.orderFindForm.orderDateEDYear.value) ) {
	    		if ( !validDate(document.orderFindForm.orderDateEDYear.value, document.orderFindForm.orderDateEDMonth.value, document.orderFindForm.orderDateEDDay.value) ) {
				alertDialog ('<%=UIUtil.toJavaScript((String)orderLabels.get("invalidOrderDateED"))%>');
				return false;
         }
		}
		
		//validate order date start date < end date
		if (!isEmpty(document.orderFindForm.orderDateSDYear.value) && !isEmpty(document.orderFindForm.orderDateEDYear.value) ) {
			if ( !validateStartEndDateTime(document.orderFindForm.orderDateSDYear.value, document.orderFindForm.orderDateSDMonth.value, document.orderFindForm.orderDateSDDay.value, document.orderFindForm.orderDateEDYear.value, document.orderFindForm.orderDateEDMonth.value, document.orderFindForm.orderDateEDDay.value, null, null) ) {
				alertDialog ('<%=UIUtil.toJavaScript((String)orderLabels.get("invalidOrderDate"))%>');
				return false;
			}
		}
		

		// Validate ordersField1 is a number
	  	if (!isEmpty(document.orderFindForm.ordersField1.value)) {
	     	if (!isNumber(document.orderFindForm.ordersField1.value)) {
	        	alertDialog ('<%=UIUtil.toJavaScript((String) orderLabels.get("findDialogInvalidNumber"))%>');
	            return false;
			}   
	  	}

      	
		//validate last update SD
		if (!isEmpty(document.orderFindForm.lastUpdateSDDay.value) || !isEmpty(document.orderFindForm.lastUpdateSDMonth.value) 
		    || !isEmpty(document.orderFindForm.lastUpdateSDYear.value)  ) {
	    		if ( !validDate(document.orderFindForm.lastUpdateSDYear.value, document.orderFindForm.lastUpdateSDMonth.value, document.orderFindForm.lastUpdateSDDay.value) ) {
				alertDialog ('<%=UIUtil.toJavaScript((String)orderLabels.get("invalidLastUpdateSD"))%>');
				return false;
			}
		}
		
		//validate last update ED
		if (!isEmpty(document.orderFindForm.lastUpdateEDDay.value) || !isEmpty(document.orderFindForm.lastUpdateEDMonth.value) 
		    || !isEmpty(document.orderFindForm.lastUpdateEDYear.value) ) {
	    		if ( !validDate(document.orderFindForm.lastUpdateEDYear.value, document.orderFindForm.lastUpdateEDMonth.value, document.orderFindForm.lastUpdateEDDay.value) ) {
				alertDialog ('<%=UIUtil.toJavaScript((String)orderLabels.get("invalidLastUpdateED"))%>');
				return false;
			}
		}
		
		//validate last update start date < end date
		if (!isEmpty(document.orderFindForm.lastUpdateSDYear.value) && !isEmpty(document.orderFindForm.lastUpdateEDYear.value) ) {
			if ( !validateStartEndDateTime(document.orderFindForm.lastUpdateSDYear.value, document.orderFindForm.lastUpdateSDMonth.value, document.orderFindForm.lastUpdateSDDay.value, document.orderFindForm.lastUpdateEDYear.value, document.orderFindForm.lastUpdateEDMonth.value, document.orderFindForm.lastUpdateEDDay.value, null, null) ) {
				alertDialog ('<%=UIUtil.toJavaScript((String)orderLabels.get("invalidLastUpdate"))%>');
				return false;
			}
		}	
		
	   //validate the account number
	   if(!isEmpty(document.orderFindForm.protocolDataValue1.value) && (document.orderFindForm.protocolDataName1.value == "account")){
		    if(!isNumber(document.orderFindForm.protocolDataValue1.value) || document.orderFindForm.protocolDataValue1.value.length <5){
		    	alertDialog('<%=UIUtil.toJavaScript((String)orderLabels.get("invalidAccountNumber"))%>');
		     	return false;
		    }
	   }

		//validate maximum number to display
		if ( document.orderFindForm.fetchSize.value != "100" ) {
			if ( !isNumber(document.orderFindForm.fetchSize.value) || document.orderFindForm.fetchSize.value == "0") {
				alertDialog ('<%=UIUtil.toJavaScript((String)orderLabels.get("invalidMaxDisplay"))%>');
				return false;
			}
		}
	}
	return true;
}

function getNotFulfilled(){
   if ( document.orderFindForm.ordersNotFulfilled.checked){
      return "Yes";
   }
   return "";
}

function findAction() {
	if (validateEntries() == true) {
		url = '/webapp/wcs/tools/servlet/NewDynamicListView';
		var urlPara = new Object();
		urlPara.listsize='24';
		urlPara.startindex='0';
		if ("<%=UIUtil.toJavaScript(customerId)%>" != "") {
   			urlPara.ActionXMLFile='order.csadminOrderListB2C';
		} else {
     		urlPara.ActionXMLFile='order.csOrderListB2C';

		}
  		urlPara.cmd='OrderListViewB2C';
  		urlPara.customerId = "<%=UIUtil.toJavaScript(customerId)%>";
  		urlPara.orderId=document.orderFindForm.orderId.value;
  		urlPara.userLogon=document.orderFindForm.userLogon.value;
        urlPara.orderStatus=document.orderFindForm.orderState.value;
  		urlPara.orderType=document.orderFindForm.orderType.value;
  		urlPara.blocked=document.orderFindForm.orderBlocked.value;
  		urlPara.blockReason=document.orderFindForm.orderBlockReason.value;
  		urlPara.fulfillmentCenterId=document.orderFindForm.fulfillmentCenterId.value;
  		urlPara.orderItemStatus=document.orderFindForm.orderItemStatus.value;
  		if( !isEmpty(document.orderFindForm.protocolDataValue1.value) ) {
	  		urlPara.paymentDataSize=1;
  			urlPara.paymentData_name_1=document.orderFindForm.protocolDataName1.value;
  			urlPara.paymentData_value_1=document.orderFindForm.protocolDataValue1.value;
  		} else {
  		    urlPara.paymentDataSize=0;
  		}
  		   
  		   		//pass shipAddress1 and shipZipCode and Organization name
		urlPara.shipFirstName		= document.orderFindForm.shipFirstName.value;
		urlPara.shipFirstNameSearchType	= document.orderFindForm.shipFirstNameSearchType.value;
		urlPara.shipLastName		= document.orderFindForm.shipLastName.value;
		urlPara.shipLastNameSearchType	= document.orderFindForm.shipLastNameSearchType.value;
		urlPara.shipAddress1		= document.orderFindForm.shipAddress1.value;
		urlPara.shipAddress1SearchType	= document.orderFindForm.shipAddress1SearchType.value;
		urlPara.shipCity		= document.orderFindForm.shipCity.value;
		urlPara.shipCitySearchType	= document.orderFindForm.shipCitySearchType.value;
		urlPara.shipZipcode			= document.orderFindForm.shipZipcode.value;
		urlPara.shipZipcodeSearchType	= document.orderFindForm.shipZipcodeSearchType.value;
		urlPara.orgName	= document.orderFindForm.orgName.value;
		urlPara.orgNameSearchType	= document.orderFindForm.orgNameSearchType.value;
		urlPara.ordersField1	= document.orderFindForm.ordersField1.value;
		urlPara.orgField1SearchType	= document.orderFindForm.orgField1SearchType.value;
		urlPara.orgField1	= document.orderFindForm.orgField1.value;
		urlPara.SKU	= document.orderFindForm.SKU.value;
		urlPara.ordersNotFulfilled	= getNotFulfilled();
  		
  		//pass billAddress1 and shipZipCode 
		urlPara.billFirstName		= document.orderFindForm.billFirstName.value;
		urlPara.billFirstNameSearchType	= document.orderFindForm.billFirstNameSearchType.value;
		urlPara.billLastName		= document.orderFindForm.billLastName.value;
		urlPara.billLastNameSearchType	= document.orderFindForm.billLastNameSearchType.value;
		urlPara.billAddress1		= document.orderFindForm.billAddress1.value;
		urlPara.billAddress1SearchType	= document.orderFindForm.billAddress1SearchType.value;
		urlPara.billCity		= document.orderFindForm.billCity.value;
		urlPara.billCitySearchType	= document.orderFindForm.billCitySearchType.value;
		urlPara.billZipcode			= document.orderFindForm.billZipcode.value;
		urlPara.billZipcodeSearchType	= document.orderFindForm.billZipcodeSearchType.value;   
  		 		
  		urlPara.orderby='orderid';
  		
  		//pass new parameters
  		urlPara.userLogonSearchType	= document.orderFindForm.customerLogonSearchType.value;
  		urlPara.fetchSize		= document.orderFindForm.fetchSize.value;
  		
		if ( !isEmpty(document.orderFindForm.orderDateSDYear.value) )
  			urlPara.orderDateSD = createSDTimestampString(document.orderFindForm.orderDateSDYear.value, document.orderFindForm.orderDateSDMonth.value, document.orderFindForm.orderDateSDDay.value);
  		
  		if ( !isEmpty(document.orderFindForm.orderDateEDYear.value) )
			urlPara.orderDateED = createEDTimestampString(document.orderFindForm.orderDateEDYear.value, document.orderFindForm.orderDateEDMonth.value, document.orderFindForm.orderDateEDDay.value);
  		
  		if ( !isEmpty(document.orderFindForm.lastUpdateSDYear.value) )
  			urlPara.lastUpdateSD = createSDTimestampString(document.orderFindForm.lastUpdateSDYear.value, document.orderFindForm.lastUpdateSDMonth.value, document.orderFindForm.lastUpdateSDDay.value);
  		
  		if ( !isEmpty(document.orderFindForm.lastUpdateEDYear.value) )
  			urlPara.lastUpdateED = createEDTimestampString(document.orderFindForm.lastUpdateEDYear.value, document.orderFindForm.lastUpdateEDMonth.value, document.orderFindForm.lastUpdateEDDay.value);
		
  		urlPara.firstName		= document.orderFindForm.firstName.value;
		urlPara.firstNameSearchType	= document.orderFindForm.firstNameSearchType.value;
		urlPara.lastName		= document.orderFindForm.lastName.value;
		urlPara.lastNameSearchType	= document.orderFindForm.lastNameSearchType.value;
		urlPara.address1		= document.orderFindForm.address1.value;
		urlPara.address1SearchType	= document.orderFindForm.address1SearchType.value;
		urlPara.city		= document.orderFindForm.city.value;
		urlPara.citySearchType	= document.orderFindForm.citySearchType.value;
		urlPara.zipcode			= document.orderFindForm.zipcode.value;
		urlPara.zipcodeSearchType	= document.orderFindForm.zipcodeSearchType.value;
		urlPara.email1			= document.orderFindForm.email1.value;
		urlPara.email1SearchType	= document.orderFindForm.email1SearchType.value;
		urlPara.phone1			= document.orderFindForm.phone1.value;


		
		top.setContent("<%= UIUtil.toJavaScript((String)orderLabels.get("findResultBCT")) %>",url,true, urlPara);     
		return true;
	}
	return false;
}

function cancelAction() {
	top.goBack();
}

function clearAdvancedFields() {
	
           document.all["orderType"].options[0].selected = true;
	       document.all["orderState"].options[0].selected = true;
	       document.all["orderBlocked"].options[0].selected = true;
	       document.all["orderBlockReason"].options[0].selected = true;
	       document.all["fulfillmentCenterId"].options[0].selected = true;
	       document.all["orderItemStatus"].options[0].selected = true;
	       blockReasonLabel0.style.display="none";
           blockReason0.style.display="none";
           document.all["protocolDataValue1"].value="";
           document.all["shipFirstName"].value = "";
	       document.all["shipLastName"].value = "";
	       document.all["shipAddress1"].value = "";
	       document.all["shipZipcode"].value = "";
           document.all["shipFirstName"].value = "";
	       document.all["billLastName"].value = "";
	       document.all["billAddress1"].value = "";
	       document.all["billCity"].value = "";
	       document.all["billZipcode"].value = "";
	       document.all["orgName"].value = "";
	       document.all["ordersField1"].value = "";
	       document.all["orgField1"].value = "";
	       document.all["ordersNotFulfilled"].checked = false;
	       document.all["SKU"].value = "";

	document.all["orderDateSDDay"].value = "";
	document.all["orderDateSDMonth"].value = "";
	document.all["orderDateSDYear"].value = "";
	document.all["orderDateEDDay"].value = "";
	document.all["orderDateEDMonth"].value = "";
	document.all["orderDateEDYear"].value = "";
	document.all["lastUpdateSDDay"].value = "";
	document.all["lastUpdateSDMonth"].value = "";
	document.all["lastUpdateSDYear"].value = "";
	document.all["lastUpdateEDDay"].value = "";
	document.all["lastUpdateEDMonth"].value = "";
	document.all["lastUpdateEDYear"].value = "";
	document.all["firstName"].value = "";
	document.all["lastName"].value = "";
	document.all["address1"].value = "";
	document.all["city"].value = "";
	document.all["zipcode"].value = "";
	document.all["email1"].value = "";
	document.all["phone1"].value = "";	
	document.all["fetchSize"].value = "100";
}

function toggleDiv() {
	var division = document.all["advancedOptionsDivision"];
		
	if (division.style.display == "none") {
		division.style.display = "block";
	} else {
		division.style.display = "none";
		clearAdvancedFields();
	}
}
	
// -->
</SCRIPT>
</HEAD>


<BODY CLASS=content ONLOAD="initializeState();">
<IFRAME 
	title='<%= calendarNLS.get("calendarTitle") %>'  
	STYLE='display:none;position:absolute;width:198;height:230;z-index=10' 
	ID='CalFrame' 
	MARGINHEIGHT=0 MARGINWIDTH=0 NORESIZE FRAMEBORDER=0 SCROLLING=NO 
	SRC='/webapp/wcs/tools/servlet/tools/common/Calendar.jsp' >
</IFRAME>

<H1><%=orderLabels.get("findDialog")%></H1>
<P><%=orderLabels.get("findCSOrderInst")%>
<FORM NAME="orderFindForm">
<TABLE>
  <TBODY>
    <TR>
      <TD><label for="orderId1"><%=orderLabels.get("orderNumber")%></label></TD>
    </TR>
    <TR>
      <TD><INPUT size="20" type="text" maxlength="20" id="orderId1" name="orderId"></TD>
    </TR>
    <TR>
      <TD></TD>
    </TR>
    <TR>
      <TD><label for="custName"><%=orderLabels.get("customerName")%></label></TD>
      <TD></TD>
    </TR>
    <TR>
      <TD><INPUT size="31" type="text" maxlength="31" id="custName" name="userLogon" value="<%=getUserLogon(customerId, request)%>"></TD>
      <TD>
        <label for="custNameSearchType1"><select name="customerLogonSearchType" id="custNameSearchType1">
	  <option value="1" selected ><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType1")) %></option>
	  <option value="2"><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType2")) %></option>
	  <option value="3"><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType3")) %></option>
	  <option value="4"><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType4")) %></option>
	  <option value="5"><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType5")) %></option>
        </select></label>            
      </TD>
    </TR>
    <TR>
      <TD></TD>
    </TR>
    <TR>
      <TD>
      <BR>
      <a href='javascript:onclick=toggleDiv()' ><U><%= UIUtil.toHTML((String)orderLabels.get("advancedOptions")) %></U></a>
      <BR>
      </TD>
    </TR>
  </TBODY>
</TABLE>

<DIV ID="advancedOptionsDivision" STYLE="display:none;">
        
    <TABLE>
    <TR>
      <TD><label for="status1"><%= orderLabels.get("orderStatus") %></label></TD>
    </TR>
    <TR>
      <TD>
      	<SELECT name="orderState" id="status1">
      		<OPTION value="all"></OPTION>
			<OPTION value="P"><%= orderLabels.get("P") %></OPTION>
      		<OPTION value="I"><%= orderLabels.get("I") %></OPTION>
      		<OPTION value="W"><%= orderLabels.get("W") %></OPTION>
      		<OPTION value="N"><%= orderLabels.get("N") %></OPTION>    		
      		<OPTION value="M"><%= orderLabels.get("M") %></OPTION>
      		<OPTION value="B"><%= orderLabels.get("B") %></OPTION>  
      		<OPTION value="C"><%= orderLabels.get("C") %></OPTION>
      		<OPTION value="E"><%= orderLabels.get("E") %></OPTION>
      		<OPTION value="R"><%= orderLabels.get("R") %></OPTION>
      		<OPTION value="S"><%= orderLabels.get("S") %></OPTION>
     		<OPTION value="D"><%= orderLabels.get("D") %></OPTION>
      		<OPTION value="L"><%= orderLabels.get("L") %></OPTION>
      		<OPTION value="T"><%= orderLabels.get("T") %></OPTION>
      		<OPTION value="A"><%= orderLabels.get("A") %></OPTION>      		
      		<OPTION value="F"><%= orderLabels.get("F") %></OPTION>
      		<OPTION value="G"><%= orderLabels.get("G") %></OPTION>
      		<OPTION value="X"><%= orderLabels.get("X") %></OPTION>
      	</SELECT>	
      </TD>
    </TR>
      <TR>      
        <TD><label for="orderitemstatus"><%= orderLabels.get("orderItemStatus") %></label></TD>
      </TR>
      
      <TR>
        <TD>
            <SELECT name="orderItemStatus" id="orderitemstatus">
      		    <OPTION value="" selected="selected"></OPTION>
	      		<OPTION value="I"><%= orderLabels.get("AOPOrderItemI") %></OPTION>
	      		<OPTION value="B"><%= orderLabels.get("AOPOrderItemB") %></OPTION>  
    	  		<OPTION value="C"><%= orderLabels.get("AOPOrderItemC") %></OPTION>
      			<OPTION value="R"><%= orderLabels.get("AOPOrderItemR") %></OPTION>
	      		<OPTION value="S"><%= orderLabels.get("AOPOrderItemS") %></OPTION>
    	  		<OPTION value="F"><%= orderLabels.get("AOPOrderItemF") %></OPTION>
      			<OPTION value="G"><%= orderLabels.get("AOPOrderItemG") %></OPTION>
      			<OPTION value="H"><%= orderLabels.get("AOPOrderItemH") %></OPTION>
            </SELECT>	
        </TD>
      </TR>
      
      <TR>
      	<TD>
      		<INPUT type="hidden" name="orderType" value="ORD" id="orderType"/>
      	</TD>
      </TR>
      
      <TR>    
        <TD><label for="SKU1"><%=orderLabels.get("SKU")%></label></TD>
      </TR>
      <TR>
        <TD><INPUT size="30" type="text" maxlength="64" id="SKU1" name="SKU"></TD>
      </TR>
   </TABLE>
   <TABLE>
      <TR>
        <TD><label for="orderBlocked1"><%= orderLabels.get("blockStatus") %></label></TD>
      </TR>
      <TR>
        <TD>
            <SELECT name="orderBlocked" id="orderBlocked1" onchange="blockSelected()">
                <OPTION value="" selected="selected"></OPTION>
      		    <OPTION value="N"><%= orderLabels.get("notBlockd") %></OPTION>
      		    <OPTION value="Y"><%= orderLabels.get("blocked") %></OPTION>
            </SELECT>	
        </TD>
      </TR>

      <TR>
        <TD id = blockReasonLabel0 style="display:none"><label for="orderBlockReason1" ><%= orderLabels.get("orderBlockReason") %></label></TD>
      </TR>
      <TR>
        <TD id = blockReason0 style="display:none">
            <SELECT name="orderBlockReason" id="orderBlockReason1">
      		    <OPTION value="all" selected="selected"></OPTION>
      		    <!-- here need use new listdatabean -->
  <%
    BlockReasonCodeDataBean aBlkCodeBean = new BlockReasonCodeDataBean();
    com.ibm.commerce.beans.DataBeanManager.activate(aBlkCodeBean, request);
    BlockReasonCodeDataBean[] blkCodeDBs = aBlkCodeBean.getAllBlockReasonCode();
    for (int i=0; i<blkCodeDBs.length; i++) {
  %>    		   
      	   <OPTION value=<%= blkCodeDBs[i].getBlockReasonCodeId()%>><%= blkCodeDBs[i].getBlockReasonCodeId() + "  " +blkCodeDBs[i].getDescription() %></OPTION>
  <%}%>
      	    </SELECT>	
        </TD>
    </TR>
    <tr> 
       <td>
           <input type="checkbox" name="ordersNotFulfilled" value="Yes" id="ordersNotFulfilled1"/><label for="ordersNotFulfilled1"><%= orderLabels.get("ordersNotFulfilled") %></label>
       </td>
    </tr> 
    <TR>
      <TD><label for="fulfillmentCenter"><%= orderLabels.get("fulfillmentCenter") %></label></TD>
    </TR>

    <TR>
      <TD>
      	<SELECT name="fulfillmentCenterId" id="fulfillmentCenter">
      		<OPTION value=""></OPTION>
      		<% 
      		Vector ful =  storeLang.getFulfill(storeId);
      		Enumeration fulfillId = ful.elements();
					
			while (fulfillId.hasMoreElements()) {
					Vector aFCB = (Vector) fulfillId.nextElement();
					if (aFCB.elementAt(1) == null || aFCB.elementAt(0) == null) {
						continue;
					}
					String ffmId = aFCB.elementAt(1).toString();
					String ffcDesc = aFCB.elementAt(0).toString();
					%>
					<OPTION value="<%= ffmId %>"><%= ffcDesc %></OPTION>
				
			<%
      		}
      		%>
      	</SELECT>	
      </TD>
    </TR>
    </TABLE>
    <TABLE>    
    <TR>
      <TD>
      	<label for="protocolDataValue1"><%=orderLabels.get("account")%></label>
      </TD>
    </TR>
    <TR>
      <TD>
      	<INPUT type="hidden" name="protocolDataName1" value="account" id="protocolDataName1"/>
      	<INPUT size="5" type="text" maxlength="5" id="protocolDataValue1" name="protocolDataValue1"/>
      </TD>
    </TR>
    </TABLE>



    <TABLE>
    <TR>
      <TD COLSPAN=9 ALIGN=LEFT VALIGN=MIDDLE HEIGHT=32><%= orderLabels.get("orderDate") %></TD>
    </TR>
    <TR HEIGHT=25>
      <TD COLSPAN=4 VALIGN=TOP><%= orderLabels.get("startDate") %></TD>
    </TR>
    <TR>
      <TD><label for='orderDateSYear'><%= orderLabels.get("year") %></label></TD>
      <TD><label for='orderDateSMonth'><%= orderLabels.get("month") %></label></TD>
      <TD><label for='orderDateSDay'><%= orderLabels.get("day") %></label></TD>
    </TR>
    <TR>
      <TD><INPUT ID='orderDateSYear' TYPE='TEXT' NAME='orderDateSDYear'  SIZE=4 MAXLENGTH=4></TD>
      <TD><INPUT ID='orderDateSMonth' TYPE='TEXT' NAME='orderDateSDMonth' SIZE=4 MAXLENGTH=2></TD>
      <TD><INPUT ID='orderDateSDay' TYPE='TEXT' NAME='orderDateSDDay'   SIZE=4 MAXLENGTH=2></TD>
      <TD VALIGN=BOTTOM>
        <A HREF='javascript:setupOrderDateSD();showCalendar(document.all.orderDateSDImg)' >
          <IMG SRC='/wcs/images/tools/calendar/calendar.gif' BORDER='0'  id='orderDateSDImg' ALT='<%= orderLabels.get("startDate")%>'>
        </A>
      </TD>
    </TR>

    <TR>
      <TD COLSPAN=4 VALIGN=TOP><%= orderLabels.get("endDate") %></TD>
    </TR>

    <TR>
      <TD><label for='orderDateEYear'><%= orderLabels.get("year") %></label></TD>
      <TD><label for='orderDateEMonth'><%= orderLabels.get("month") %></label></TD>
      <TD><label for='orderDateEDay'><%= orderLabels.get("day") %></label></TD>
    </TR>

    <TR>
      <TD><INPUT ID='orderDateEYear' TYPE='TEXT' NAME='orderDateEDYear'  SIZE=4 MAXLENGTH=4></TD>
      <TD><INPUT ID='orderDateEMonth' TYPE='TEXT' NAME='orderDateEDMonth' SIZE=4 MAXLENGTH=2></TD>
      <TD><INPUT ID='orderDateEDay' TYPE='TEXT' NAME='orderDateEDDay'   SIZE=4 MAXLENGTH=2></TD>
      <TD VALIGN=BOTTOM>
        <A HREF='javascript:setupOrderDateED();showCalendar(document.all.orderDateEDImg)'>
          <IMG SRC='/wcs/images/tools/calendar/calendar.gif' BORDER='0'  id='orderDateEDImg' ALT='<%= orderLabels.get("endDate")%>'>
        </A>
      </TD>
    </TR>
    </TABLE>
    

    <TABLE>
    <TR>
      <TD COLSPAN=9 ALIGN=LEFT VALIGN=CENTER HEIGHT=32><%= orderLabels.get("orderUpdatedDate") %></TD>
    </TR>
    <TR HEIGHT=25>
      <TD COLSPAN=4 VALIGN=TOP><%= orderLabels.get("startDate") %></TD>
    </TR>
    <TR>
      <TD><LABEL for='lastUpdateSYear'><%= orderLabels.get("year") %></LABEL></TD>
      <TD><LABEL for='lastUpdateSMonth'><%= orderLabels.get("month") %></LABEL></TD>
      <TD><LABEL for='lastUpdateSDay'><%= orderLabels.get("day") %></LABEL></TD>
    </TR>
    <TR>
      <TD><INPUT ID='lastUpdateSYear' TYPE='TEXT' NAME='lastUpdateSDYear'  SIZE=4 MAXLENGTH=4></TD>
      <TD><INPUT ID='lastUpdateSMonth' TYPE='TEXT' NAME='lastUpdateSDMonth' SIZE=4 MAXLENGTH=2></TD>
      <TD><INPUT ID='lastUpdateSDay' TYPE='TEXT' NAME='lastUpdateSDDay'   SIZE=4 MAXLENGTH=2></TD>
      <TD VALIGN=BOTTOM>
        <A HREF='javascript:setupLastUpdateSD();showCalendar(document.all.lastUpdateSDImg)' >
          <IMG SRC='/wcs/images/tools/calendar/calendar.gif' BORDER='0'  id='lastUpdateSDImg' ALT='<%= orderLabels.get("startDate")%>'>
        </A>
      </TD>

    </TR>

    <TR>
      <TD COLSPAN=4 VALIGN=TOP><%= orderLabels.get("endDate") %></TD>
    </TR>
    <TR>
      <TD><LABEL for='lastUpdateEYear'><%= orderLabels.get("year") %></LABEL></TD>
      <TD><LABEL for='lastUpdateEMonth'><%= orderLabels.get("month") %></LABEL></TD>
      <TD><LABEL for='lastUpdateEDay'><%= orderLabels.get("day") %></LABEL></TD>
    </TR>
    <TR>
      <TD><INPUT ID='lastUpdateEYear' TYPE='TEXT' NAME='lastUpdateEDYear'  SIZE=4 MAXLENGTH=4></TD>
      <TD><INPUT ID='lastUpdateEMonth' TYPE='TEXT' NAME='lastUpdateEDMonth' SIZE=4 MAXLENGTH=2></TD>
      <TD><INPUT ID='lastUpdateEDay' TYPE='TEXT' NAME='lastUpdateEDDay'   SIZE=4 MAXLENGTH=2></TD>
      <TD VALIGN=BOTTOM>
        <A HREF='javascript:setupLastUpdateED();showCalendar(document.all.lastUpdateEDImg)'>
          <IMG SRC='/wcs/images/tools/calendar/calendar.gif' BORDER='0'  id='lastUpdateEDImg' ALT='<%= orderLabels.get("endDate")%>'>
        </A>
      </TD>
    </TR>
    </TABLE>
    
    <TABLE>
    <% boolean switchNames = false;
    
    if (jLocale.toString().equals("ja_JP")||jLocale.toString().equals("ko_KR")||jLocale.toString().equals("zh_CN")||jLocale.toString().equals("zh_TW")) {
    	switchNames = true;
    }%>
	<TR>
	<% if (!switchNames) { %>
      		<TD><label for="fName1"><%=orderLabels.get("firstName")%></label></TD>
    <% } else { %>
       		<TD><label for="lName1"><%=orderLabels.get("lastName")%></label></TD> 
    <% } %>
      <TD></TD>
    </TR>
    <TR>
    <% if (!switchNames) { %>
      <TD><INPUT size="31" type="text" maxlength="128" id="fName1" name="firstName" value=""></TD>
      <TD>
      		<label for="fNameSearchType1"><select name="firstNameSearchType" id="fNameSearchType1">
    <% } else { %>
      <TD><INPUT size="31" type="text" maxlength="128" id="lName1" name="lastName" value=""></TD>
      <TD>
       		<label for="lNameSearchType1"><select name="lastNameSearchType" id="lNameSearchType1">
    <% } %>
	  <option value="1" selected ><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType1")) %></option>
	  <option value="2"><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType2")) %></option>
	  <option value="3"><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType3")) %></option>
	  <option value="4"><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType4")) %></option>
	  <option value="5"><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType5")) %></option>
        </select> </label>           
      </TD>
    </TR>
    <TR>
      <TD></TD>
    </TR>
    <TR>
    <% if (!switchNames) { %>
      		<TD><label for="lName2"><%=orderLabels.get("lastName")%></label></TD>
    <% } else { %>
       		<TD><label for="fName2"><%=orderLabels.get("firstName")%></label></TD> 
    <% } %>
      <TD></TD>
    </TR>
    <TR>
      <% if (!switchNames) { %>
      <TD><INPUT size="31" type="text" maxlength="128" id="lName2" name="lastName" value=""></TD>
      <TD>
      		<label for="lNameSearchType2"><select name="lastNameSearchType" id="lNameSearchType2">
    <% } else { %>
      <TD><INPUT size="31" type="text" maxlength="128" id="fName2" name="firstName" value=""></TD>
      <TD>
       		<label for="fNameSearchType2"><select name="firstNameSearchType" id="fNameSearchType2">
    <% } %>
	  <option value="1" selected ><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType1")) %></option>
	  <option value="2"><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType2")) %></option>
	  <option value="3"><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType3")) %></option>
	  <option value="4"><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType4")) %></option>
	  <option value="5"><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType5")) %></option>
        </select> </label>           
      </TD>
    </TR>   
    <TR>
      <TD></TD>
    </TR>
    <TR>
      <TD><label for="addr1"><%=orderLabels.get("address1")%></label></TD>
      <TD></TD>
    </TR>
    <TR>
      <TD><INPUT size="31" type="text" maxlength="50" id="addr1" name="address1" value=""></TD>
      <TD>
        <label for="addrSearchType1"><select name="address1SearchType" id="addrSearchType1">
	  <option value="1" selected ><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType1")) %></option>
	  <option value="2"><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType2")) %></option>
	  <option value="3"><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType3")) %></option>
	  <option value="4"><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType4")) %></option>
	  <option value="5"><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType5")) %></option>
        </select></label>
      </TD>
    </TR>
    <TR>
      <TD></TD>
    </TR>
    <TR>
      <TD><label for="city"><%=orderLabels.get("city")%></label></TD>
      <TD></TD>
    </TR>
    <TR>
      <TD><INPUT size="31" type="text" maxlength="50" id="city" name="city" value="" /></TD>
      <TD>
        <label for="citySearchType1"><select name="citySearchType" id="citySearchType1">
	  <option value="1" selected ><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType1")) %></option>
	  <option value="2"><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType2")) %></option>
	  <option value="3"><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType3")) %></option>
	  <option value="4"><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType4")) %></option>
	  <option value="5"><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType5")) %></option>
        </select></label>      
      </TD>
    </TR>
    <TR>
      <TD></TD>
    </TR>
    <TR>
      <TD><label for="zip1"><%=orderLabels.get("zipcode")%></label></TD>
      <TD></TD>
    </TR>
    <TR>
      <TD><INPUT size="31" type="text" maxlength="40" id="zip1" name="zipcode" value=""></TD>
      <TD>
        <label for="zipSearchType1"><select name="zipcodeSearchType" id="zipSearchType1">
	  <option value="1" selected ><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType1")) %></option>
	  <option value="2"><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType2")) %></option>
	  <option value="3"><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType3")) %></option>
	  <option value="4"><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType4")) %></option>
	  <option value="5"><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType5")) %></option>
        </select> </label>
      </TD>
    </TR>
    <TR>
      <TD></TD>
    </TR>
    <TR>
      <TD><label for="email1"><%=orderLabels.get("email1")%></label></TD>
      <TD></TD>
    </TR>
    <TR>
      <TD><INPUT size="31" type="text" maxlength="128" id="email1" name="email1" value=""></TD>
      <TD>
        <label for="emailSearchType1"><select name="email1SearchType" id="emailSearchType1">
	  <option value="1" selected ><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType1")) %></option>
	  <option value="2"><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType2")) %></option>
	  <option value="3"><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType3")) %></option>
	  <option value="4"><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType4")) %></option>
	  <option value="5"><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType5")) %></option>
        </select>            </label>
      </TD>
    </TR>
    <TR>
      <TD></TD>
    </TR>
    <TR>
      <TD><label for="phone1"><%=orderLabels.get("phone1")%></label></TD>
      <TD></TD>
    </TR>
    <TR>
      <TD><INPUT size="31" type="text" maxlength="32" id="phone1" name="phone1" value=""></TD>
    </TR>
    <TR>
    <% if (!switchNames) { %>
      		<TD><label for="fsName1"><%=orderLabels.get("billFirstName")%></label></TD>
    <% } else { %>
       		<TD><label for="lsName1"><%=orderLabels.get("billLastName")%></label></TD>
    <% } %>
      <TD></TD>
    </TR>
	<TR>
    <% if (!switchNames) { %>
      <TD><INPUT size="31" type="text" maxlength="128" id="fsName1" name="billFirstName" value=""></TD>
      <TD>
      		<label for="fsNameSearchType1"><select name="billFirstNameSearchType" id="fsNameSearchType1">
    <% } else { %>
      <TD><INPUT size="31" type="text" maxlength="128" id="lsName1" name="billLastName" value=""></TD>
      <TD>
       		<label for="lsNameSearchType1"><select name="billLastNameSearchType" id="lsNameSearchType1">
    <% } %>
	  <option value="1" selected ><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType1")) %></option>
	  <option value="2"><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType2")) %></option>
	  <option value="3"><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType3")) %></option>
	  <option value="4"><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType4")) %></option>
	  <option value="5"><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType5")) %></option>
        </select>            </label>
      </TD>
    </TR>
    <TR>
    <% if (!switchNames) { %>
      		<TD><label for="lsName2"><%=orderLabels.get("billLastName")%></label></TD> 	
    <% } else { %>
            <TD><label for="fsName2"><%=orderLabels.get("billFirstName")%></label></TD>       		
    <% } %>
      <TD></TD>
    </TR>
	<TR>
    <% if (!switchNames) { %>
      <TD><INPUT size="31" type="text" maxlength="128" id="lsName2" name="billLastName" value=""></TD>
      <TD>
      		<label for="lsNameSearchType2"><select name="billLastNameSearchType" id="lsNameSearchType2">
    <% } else { %>
      <TD><INPUT size="31" type="text" maxlength="128" id="fsName2" name="billFirstName" value=""></TD>
      <TD>
       		<label for="fsNameSearchType2"><select name="billFirstNameSearchType" id="fsNameSearchType2">
    <% } %>
	  <option value="1" selected ><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType1")) %></option>
	  <option value="2"><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType2")) %></option>
	  <option value="3"><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType3")) %></option>
	  <option value="4"><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType4")) %></option>
	  <option value="5"><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType5")) %></option>
        </select>            </label>
      </TD>
    </TR>          
    <TR>
      <TD></TD>
    </TR>
    <TR>
    <TR>
      <TD><label for="billAddress1"><%=orderLabels.get("billaddress1")%></label></TD>
      <TD></TD>
    </TR>
    <TR>
      <TD><INPUT size="31" type="text" maxlength="50" name="billAddress1" id="billAddress1" value=""></TD>
      <TD>
        <label for="billAddress1SearchType"><select name="billAddress1SearchType" id="billAddress1SearchType">
	  <option value="1" selected ><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType1")) %></option>
	  <option value="2"><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType2")) %></option>
	  <option value="3"><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType3")) %></option>
	  <option value="4"><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType4")) %></option>
	  <option value="5"><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType5")) %></option>
        </select>        </label>
      </TD>
    </TR>
    <TR>
      <TD></TD>
    </TR>
    <TR>
    <TR>
      <TD><label for="billCity"><%=orderLabels.get("billCity")%></label></TD>
      <TD></TD>
    </TR>
    <TR>
      <TD><INPUT size="31" type="text" maxlength="50" name="billCity" id="billCity" value=""></TD>
      <TD>
        <label for="billCitySearchType"><select name="billCitySearchType" id="billCitySearchType">
	  <option value="1" selected ><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType1")) %></option>
	  <option value="2"><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType2")) %></option>
	  <option value="3"><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType3")) %></option>
	  <option value="4"><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType4")) %></option>
	  <option value="5"><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType5")) %></option>
        </select>            </label>
      </TD>
    </TR>
    
    <TR>
      <TD><label for="billZipcode"><%=orderLabels.get("billzipcode")%></label></TD>
      <TD></TD>
    </TR>
    <TR>
      <TD><INPUT size="31" type="text" maxlength="40" name="billZipcode" id="billZipcode" value=""></TD>
      <TD>
        <label for="billZipcodeSearchType"><select name="billZipcodeSearchType" id="billZipcodeSearchType">
	  <option value="1" selected ><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType1")) %></option>
	  <option value="2"><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType2")) %></option>
	  <option value="3"><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType3")) %></option>
	  <option value="4"><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType4")) %></option>
	  <option value="5"><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType5")) %></option>
        </select>            </label>
      </TD>
    </TR>
      
     
   <TR>
	<% if (!switchNames) { %>
      		<TD><label for="shipFirstName1"><%=orderLabels.get("shipFirstName")%></label></TD>
    <% } else { %>
       		<TD><label for="shipLastName1"><%=orderLabels.get("shipLastName")%></label></TD> 
    <% } %>
      <TD></TD>
    </TR>
    <TR>
    <% if (!switchNames) { %>
      <TD><INPUT size="31" type="text" maxlength="128" id="shipFirstName1" name="shipFirstName" value=""></TD>
      <TD>
      		<label for="shipFirstNameSearchType1"><select name="shipFirstNameSearchType" id="shipFirstNameSearchType1">
    <% } else { %>
      <TD><INPUT size="31" type="text" maxlength="128" id="shipLastName1" name="shipLastName" value=""></TD>
      <TD>
       		<label for="shipLastNameSearchType1"><select name="shipLastNameSearchType" id="shipLastNameSearchType1">
    <% } %>
	  <option value="1" selected ><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType1")) %></option>
	  <option value="2"><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType2")) %></option>
	  <option value="3"><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType3")) %></option>
	  <option value="4"><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType4")) %></option>
	  <option value="5"><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType5")) %></option>
        </select>            </label>
      </TD>
    </TR>
   <TR>
	<% if (!switchNames) { %>
      		<TD><label for="shipLastName2"><%=orderLabels.get("shipLastName")%></label></TD>
    <% } else { %>
       		<TD><label for="shipFirstName2"><%=orderLabels.get("shipFirstName")%></label></TD> 
    <% } %>
      <TD></TD>
    </TR>
    <TR>
    <% if (!switchNames) { %>
      <TD><INPUT size="31" type="text" maxlength="128" id="shipLastName2" name="shipLastName" value=""></TD>
      <TD>
      		<label for="shipLastNameSearchType1"><select name="shipLastNameSearchType" id="shipLastNameSearchType1">
    <% } else { %>
      <TD><INPUT size="31" type="text" maxlength="128" id="shipFirstName2" name="shipFirstName" value=""></TD>
      <TD>
       		<label for="shipFirstNameSearchType2"><select name="shipFirstNameSearchType" id="shipFirstNameSearchType2">
    <% } %>
	  <option value="1" selected ><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType1")) %></option>
	  <option value="2"><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType2")) %></option>
	  <option value="3"><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType3")) %></option>
	  <option value="4"><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType4")) %></option>
	  <option value="5"><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType5")) %></option>
        </select>            </label>
      </TD>
    </TR>    
    <TR>
      <TD></TD>
    </TR>

   
    <TR>
      <TD><label for="shipAddress1"><%=orderLabels.get("shipaddress1")%></label></TD>
      <TD></TD>
    </TR>
    <TR>
      <TD><INPUT size="31" type="text" maxlength="50" name="shipAddress1" id="shipAddress1" value=""></TD>
      <TD>
        <label for="shipAddress1SearchType"><select name="shipAddress1SearchType" id="shipAddress1SearchType">
	  <option value="1" selected ><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType1")) %></option>
	  <option value="2"><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType2")) %></option>
	  <option value="3"><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType3")) %></option>
	  <option value="4"><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType4")) %></option>
	  <option value="5"><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType5")) %></option>
        </select>            </label>
      </TD>
    </TR>
    <TR>
      <TD></TD>
    </TR>
    <TR>
    <TR>
      <TD><label for="shipCity"><%=orderLabels.get("shipCity")%></label></TD>
      <TD></TD>
    </TR>
    <TR>
      <TD><INPUT size="31" type="text" maxlength="50" name="shipCity" id="shipCity" value=""></TD>
      <TD>
       <label for="shipCitySearchType"> <select name="shipCitySearchType" id="shipCitySearchType">
 	  <option value="1" selected ><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType1")) %></option>
	  <option value="2"><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType2")) %></option>
	  <option value="3"><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType3")) %></option>
	  <option value="4"><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType4")) %></option>
	  <option value="5"><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType5")) %></option>
        </select>            </label>
      </TD>
    </TR>
    
    <TR>
      <TD><label for="shipZipcode"><%=orderLabels.get("shipzipcode")%></label></TD>
      <TD></TD>
    </TR>
    <TR>
      <TD><INPUT size="31" type="text" maxlength="40" name="shipZipcode" id="shipZipcode" value=""></TD>
      <TD>
       <label for="shipZipcodeSearchType"> <select name="shipZipcodeSearchType" id="shipZipcodeSearchType">
	  <option value="1" selected ><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType1")) %></option>
	  <option value="2"><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType2")) %></option>
	  <option value="3"><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType3")) %></option>
	  <option value="4"><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType4")) %></option>
	  <option value="5"><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType5")) %></option>
        </select>            </label>
      </TD>
    </TR>
	<TR>
      <TD><label for="orgName"><%=orderLabels.get("organizationName")%></label></TD>
      <TD></TD>
    </TR>
    <TR>
      <TD><INPUT size="31" type="text" maxlength="40" name="orgName" value="" id="orgName"></TD>
      <TD>
      <label for="orgNameSearchType">  <select name="orgNameSearchType" id="orgNameSearchType">
	  <option value="1" selected ><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType1")) %></option>
	  <option value="2"><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType2")) %></option>
	  <option value="3"><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType3")) %></option>
	  <option value="4"><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType4")) %></option>
	  <option value="5"><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType5")) %></option>
        </select>            </label>
      </TD>
    </TR>       
    <TR style="display:none">
      <TD><label for="ordersField1"><%=orderLabels.get("ordersField1")%></label></TD>
    </TR>
    <TR style="display:none">
      <TD><INPUT size="9" type="text" maxlength="9" id="ordersField1" name="ordersField1"></TD>
    </TR>
     <TR>
      <TD></TD>
    </TR>
    <TR>
      <TD></TD>
    </TR>
    <TR>
      <TD></TD>
    </TR>
    <TR>
      <TD></TD>
    </TR>
    </TABLE>
   
   <TABLE>
    <TR style="display:none">
      <TD><label for="orgField1"><%=orderLabels.get("orgField1")%></label></TD>
      <TD></TD>
    </TR>
    <TR style="display:none">
      <TD><INPUT size="64" type="text" maxlength="64" id="orgField1" name="orgField1" value=""></TD>
      <TD>
        <label for="orgField1SearchType1"><select name="orgField1SearchType" id="orgField1SearchType1">
	  <option value="1" selected ><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType1")) %></option>
	  <option value="2"><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType2")) %></option>
	  <option value="3"><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType3")) %></option>
	  <option value="4"><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType4")) %></option>
	  <option value="5"><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType5")) %></option>
        </select>            </label>
      </TD>
    </TR>
    </TABLE>
    
    <TABLE>
    <TR>
      <TD><BR><label for="maxDisplay"><%=orderLabels.get("maximumDisplay")%></label></TD>
    </TR>
    <TR>
      <TD><INPUT size="9" type="text" maxlength="9" id="maxDisplay" name="fetchSize" value="100"></TD>
    </TR>
    </TABLE>
    
</DIV>

</FORM>

<SCRIPT LANGUAGE="JavaScript">
<!--
//For IE
if (document.all) {
    onLoad();
}
//-->
</SCRIPT>

</BODY>
</HTML>


