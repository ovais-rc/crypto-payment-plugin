


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2001, 2014 All Rights Reserved.

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
// @param customerId The customer reference number
// @param request The HTTP Request
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
CommandContext cmdContextLocale =
	(CommandContext) request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
Locale jLocale = cmdContextLocale.getLocale();
Hashtable orderLabels =
	(Hashtable) ResourceDirectory.lookup("order.orderLabels", jLocale);
Hashtable calendarNLS =
	(Hashtable) ResourceDirectory.lookup("common.calendarNLS", jLocale);

// Enable store type filtering
storeLang.setStoreTypeFiltering(true);
storeLang.setDropShipIncluded(true);
String error = storeLang.Init(cmdContextLocale);

// retrieve request parameters
JSPHelper jspHelp = new JSPHelper(request);
String customerId =	jspHelp.getParameter(ECOptoolsConstants.EC_OPTOOL_CUSTOMER_ID);
customerId = UIUtil.toHTML(customerId);

if (customerId == null) {
	customerId = "";
}

Integer storeId 	= cmdContextLocale.getStoreId();
StoreDataBean  storeBean = new StoreDataBean();
storeBean.setStoreId(storeId.toString());
com.ibm.commerce.beans.DataBeanManager.activate(storeBean, request);


/*d67432:del*/ // //compose entire list of account names
/*d67432:del*/ // AccountListDataBean acctListDB = new AccountListDataBean();
/*d67432:del*/ // DataBeanManager.activate(acctListDB, request);
/*d67432:del*/ // AccountDataBean[] acctList = acctListDB.getAccountList();
%>


<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<link rel="stylesheet" href="<%=UIUtil.getCSSFile(jLocale)%>"
	type="text/css" />
<title></title>
<script type="text/javascript"
	src="/wcs/javascript/tools/common/Util.js">
</script>
<script type="text/javascript"
	src="/wcs/javascript/tools/common/DateUtil.js">
</script>

<script type="text/javascript" for="document" event="onclick()">
   document.all.CalFrame.style.display="none";

</script>


<!-- /*d67432:add-begin*/ -->
<!-------------------------------------------->
<!-- Define the CSS for the LUS's GUI parts -->
<!-------------------------------------------->
<style type='text/css'>
. LUS_CSS_QuickTextEntryWidth {
	width: 320px;
}

. LUS_CSS_ResultListBoxWidth {
	width: 320px;
}

. LUS_CSS_KeywordEntryWidth {
	width: 200px;
}

. LUS_CSS_CriteriaListWidth {
	width: auto;
}
</style>

<!-------------------------------------------->
<!-- Import the LUS Widget Model javascript -->
<!-------------------------------------------->
<script language="JavaScript" type="text/javascript"
	src="/wcs/javascript/tools/common/LUSWidgetModel.js">
</script>
<!-- /*d67432:add-end*/ -->



<script language="JavaScript" type="text/javascript">
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

function validateStatus(){
    return (document.orderFindForm.orderStatus.value == "");   	   
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
      && validateStatus() && isEmpty(document.orderFindForm.accountId.value) && isEmpty(document.orderFindForm.shipFirstName.value) && isEmpty(document.orderFindForm.shipLastName.value) 
	   && isEmpty(document.orderFindForm.billFirstName.value) && isEmpty(document.orderFindForm.billLastName.value)
	   && isEmpty(document.orderFindForm.shipAddress1.value) && isEmpty(document.orderFindForm.shipZipcode.value)
       && isEmpty(document.orderFindForm.billAddress1.value) && isEmpty(document.orderFindForm.billZipcode.value)
 	   && isEmpty(document.orderFindForm.orgName.value) && isEmpty(document.orderFindForm.ordersField1.value)
 	   && isEmpty(document.orderFindForm.SKU.value) && isEmpty(document.orderFindForm.orgField1.value) 
 	   && isEmpty(document.orderFindForm.billCity.value) && isEmpty(document.orderFindForm.fulfillmentCenterId.value) 
 	   && isEmpty(document.orderFindForm.orderItemStatus.value)&& isEmpty(document.orderFindForm.protocolDataValue1.value)  
 	   && checkBlock() && checkNotFulfillment()&& isEmpty(document.orderFindForm.shipCity.value) 
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
      alertDialog('<%=UIUtil.toJavaScript((String) orderLabels.get("findDialogNoCriteria"))%>');
      return false;
   } else {

      //validate order number
      if (!isEmpty(document.orderFindForm.orderId.value)) {
         if (!isNumber(document.orderFindForm.orderId.value)) {
            alertDialog ('<%=UIUtil.toJavaScript((String) orderLabels.get("findDialogInvalidNumber"))%>');
            return false;
			}   
      }

      //validate order date SD
      if (!isEmpty(document.orderFindForm.orderDateSDDay.value) || !isEmpty(document.orderFindForm.orderDateSDMonth.value)
          || !isEmpty(document.orderFindForm.orderDateSDYear.value) ) {
            if ( !validDate(document.orderFindForm.orderDateSDYear.value, document.orderFindForm.orderDateSDMonth.value, document.orderFindForm.orderDateSDDay.value) ) {
            alertDialog ('<%=UIUtil.toJavaScript((String) orderLabels.get("invalidOrderDateSD"))%>');
            return false;
         }
      }

      //validate order date ED
      if (!isEmpty(document.orderFindForm.orderDateEDDay.value) || !isEmpty(document.orderFindForm.orderDateEDMonth.value)
          || !isEmpty(document.orderFindForm.orderDateEDYear.value) ) {
            if ( !validDate(document.orderFindForm.orderDateEDYear.value, document.orderFindForm.orderDateEDMonth.value, document.orderFindForm.orderDateEDDay.value) ) {
            alertDialog ('<%=UIUtil.toJavaScript((String) orderLabels.get("invalidOrderDateED"))%>');
            return false;
         }
      }

      //validate order date start date < end date
      if (!isEmpty(document.orderFindForm.orderDateSDYear.value) && !isEmpty(document.orderFindForm.orderDateEDYear.value) ) {
         if ( !validateStartEndDateTime(document.orderFindForm.orderDateSDYear.value, document.orderFindForm.orderDateSDMonth.value, document.orderFindForm.orderDateSDDay.value, document.orderFindForm.orderDateEDYear.value, document.orderFindForm.orderDateEDMonth.value, document.orderFindForm.orderDateEDDay.value, null, null) ) {
            alertDialog ('<%=UIUtil.toJavaScript((String) orderLabels.get("invalidOrderDate"))%>');
            return false;
         }
      }

      //validate last update SD
      if (!isEmpty(document.orderFindForm.lastUpdateSDDay.value) || !isEmpty(document.orderFindForm.lastUpdateSDMonth.value)
          || !isEmpty(document.orderFindForm.lastUpdateSDYear.value)  ) {
            if ( !validDate(document.orderFindForm.lastUpdateSDYear.value, document.orderFindForm.lastUpdateSDMonth.value, document.orderFindForm.lastUpdateSDDay.value) ) {
            alertDialog ('<%=UIUtil.toJavaScript((String) orderLabels.get("invalidLastUpdateSD"))%>');
            return false;
         }
      }

      //validate last update ED
      if (!isEmpty(document.orderFindForm.lastUpdateEDDay.value) || !isEmpty(document.orderFindForm.lastUpdateEDMonth.value)
          || !isEmpty(document.orderFindForm.lastUpdateEDYear.value) ) {
            if ( !validDate(document.orderFindForm.lastUpdateEDYear.value, document.orderFindForm.lastUpdateEDMonth.value, document.orderFindForm.lastUpdateEDDay.value) ) {
            alertDialog ('<%=UIUtil.toJavaScript((String) orderLabels.get("invalidLastUpdateED"))%>');
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

      //validate last update start date < end date
      if (!isEmpty(document.orderFindForm.lastUpdateSDYear.value) && !isEmpty(document.orderFindForm.lastUpdateEDYear.value) ) {
         if ( !validateStartEndDateTime(document.orderFindForm.lastUpdateSDYear.value, document.orderFindForm.lastUpdateSDMonth.value, document.orderFindForm.lastUpdateSDDay.value, document.orderFindForm.lastUpdateEDYear.value, document.orderFindForm.lastUpdateEDMonth.value, document.orderFindForm.lastUpdateEDDay.value, null, null) ) {
            alertDialog ('<%=UIUtil.toJavaScript((String) orderLabels.get("invalidLastUpdate"))%>');
            return false;
         }
      }


	  //validate the account number
	  if(!isEmpty(document.orderFindForm.protocolDataValue1.value) && (document.orderFindForm.protocolDataName1.value == "account")){
		  if (!isNumber(document.orderFindForm.protocolDataValue1.value) || document.orderFindForm.protocolDataValue1.value.length <5){
			 alertDialog('<%=UIUtil.toJavaScript((String)orderLabels.get("invalidAccountNumber"))%>');
			 return false;
		  }
	  }

      //validate maximum number to display
      if ( document.orderFindForm.fetchSize.value != "100" ) {
         if ( !isNumber(document.orderFindForm.fetchSize.value) || document.orderFindForm.fetchSize.value == "0") {
            alertDialog ('<%=UIUtil.toJavaScript((String) orderLabels.get("invalidMaxDisplay"))%>');
            return false;
         }
      }
   }
   return true;
}

function getNotFulfilled(){
   if (document.orderFindForm.ordersNotFulfilled.checked){
      return "Yes";
   }
   return "";
}

function findAction() {
   if (validateEntries() == true) {
      url = '/webapp/wcs/tools/servlet/NewDynamicListView';
      var urlPara = new Object();
      urlPara.listsize='22';
      urlPara.startindex='0';
      if ("<%=customerId%>" != "") {
         urlPara.ActionXMLFile='order.csadminOrderListB2B';
	  } else {
         urlPara.ActionXMLFile='order.csOrderListB2B';
	  }
      urlPara.cmd='OrderListViewB2B';
      urlPara.customerId="<%=customerId%>";
      urlPara.isAdvancedSearch=document.orderFindForm.isAdvancedSearch.value;
      urlPara.orderId=document.orderFindForm.orderId.value;
      urlPara.userLogon=document.orderFindForm.userLogon.value;
      urlPara.accountId=document.orderFindForm.accountId.value;
      urlPara.orderStatus=document.orderFindForm.orderStatus.value;
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
      urlPara.userLogonSearchType   = document.orderFindForm.customerLogonSearchType.value;
      urlPara.fetchSize    = document.orderFindForm.fetchSize.value;

      if ( !isEmpty(document.orderFindForm.orderDateSDYear.value) )
         urlPara.orderDateSD = createSDTimestampString(document.orderFindForm.orderDateSDYear.value, document.orderFindForm.orderDateSDMonth.value, document.orderFindForm.orderDateSDDay.value);

      if ( !isEmpty(document.orderFindForm.orderDateEDYear.value) )
         urlPara.orderDateED = createEDTimestampString(document.orderFindForm.orderDateEDYear.value, document.orderFindForm.orderDateEDMonth.value, document.orderFindForm.orderDateEDDay.value);

      if ( !isEmpty(document.orderFindForm.lastUpdateSDYear.value) )
         urlPara.lastUpdateSD = createSDTimestampString(document.orderFindForm.lastUpdateSDYear.value, document.orderFindForm.lastUpdateSDMonth.value, document.orderFindForm.lastUpdateSDDay.value);

      if ( !isEmpty(document.orderFindForm.lastUpdateEDYear.value) )
         urlPara.lastUpdateED = createEDTimestampString(document.orderFindForm.lastUpdateEDYear.value, document.orderFindForm.lastUpdateEDMonth.value, document.orderFindForm.lastUpdateEDDay.value);

      urlPara.firstName    = document.orderFindForm.firstName.value;
      urlPara.firstNameSearchType   = document.orderFindForm.firstNameSearchType.value;
      urlPara.lastName     = document.orderFindForm.lastName.value;
      urlPara.lastNameSearchType = document.orderFindForm.lastNameSearchType.value;
      urlPara.address1     = document.orderFindForm.address1.value;
      urlPara.address1SearchType = document.orderFindForm.address1SearchType.value;
		urlPara.city		= document.orderFindForm.city.value;
		urlPara.citySearchType	= document.orderFindForm.citySearchType.value;
      urlPara.zipcode         = document.orderFindForm.zipcode.value;
      urlPara.zipcodeSearchType  = document.orderFindForm.zipcodeSearchType.value;
      urlPara.email1       = document.orderFindForm.email1.value;
      urlPara.email1SearchType   = document.orderFindForm.email1SearchType.value;
      urlPara.phone1       = document.orderFindForm.phone1.value;
      
      top.setContent("<%=UIUtil.toJavaScript((String) orderLabels.get("findResultBCT"))%>",url,true, urlPara);
      return true;
   }
   return false;
}

function cancelAction() {
   top.goBack();
}

function clearAdvancedFields() {
   document.all["isAdvancedSearch"].value = "false";
   document.all["orderStatus"].options[0].selected = true;
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

/*d67432:del*/ // document.all["accountId"].options[0].selected = true;
/*d67432:add*/    document.all["accountId"].value = "";
/*d67432:add*/    document.all["LUS_SearchResultListBox"].options.selectedIndex = -1;
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
      document.all["isAdvancedSearch"].value="true";
   } else {
      division.style.display = "none";
      clearAdvancedFields();
   }
}

// -->

</script>


<!-- /*d67432:add-begin*/ -->
<!-- ******************************************************************** -->
<!-- *  START HERE --- Javascript Functions for Wiring the LUS Widget   * -->
<!-- ******************************************************************** -->
<script type="text/javascript">

/////////////////////////////////////////////////////////////////////////////
// Function: LUS_Setup
// Desc.   : Register the GUI parts to the LUS Widget object instance
/////////////////////////////////////////////////////////////////////////////
function LUS_Setup()
{
   lusWidget = new LUS_LookUpSelectionWidget
                     ('orderFindForm',
                      'LUS_SearchTextField',
                      'LUS_CriteriaDropDown',
                      'LUS_QuickTextEntry',
                      'LUS_SearchResultListBox',
                      'LUS_NumOfCurrentlyShowing',
                      '<%=UIUtil.toJavaScript((String) orderLabels.get("LUS_Label_statusLine"))%> ');

   LUS_DataFrameInitialization();

}//end-function


/////////////////////////////////////////////////////////////////////////////
// Function: LUS_DataFrameInitialization
// Desc.   : Initialize the data frame for performing search action
/////////////////////////////////////////////////////////////////////////////
function LUS_DataFrameInitialization()
{
   var searchType   = 0;  // default to search all
   var searchString = ""; // default to wildcard search

   // Building the search parameter as a query string
   var queryString = "searchType="    + searchType
                   + "&searchString=" + searchString
                   + "&maxThreshold=" + "<%=(String) orderLabels.get("LUS_MaxNumOfResultForAccountSearch")%>"
                   + "&firstLoad=1";

   // Construct the IFRAME as the data frame for getting the search result
   var webAppPath = "<%=UIUtil.getWebappPath(request)%>";
   var dataFrame = "<iframe name='CSROrderSearchB2B_dataFrame' "
   						 + "title='<%=UIUtil.toHTML((String) orderLabels.get("searchForAccountsFrame"))%>'"
                         + "id='CSROrderSearchB2B_dataFrame' "
                         + "onload='LUS_ProcessDataFrameSearchResults()' "
                         + "width='0' height='0' "
                         + "src='" + webAppPath + "CSRSearchForAccountsView?"
                         + queryString
                         + "'></iframe>";

   // Execute the data fream to perform the search
   document.write(dataFrame);

}//end-function


/////////////////////////////////////////////////////////////////////////////
// Function: LUS_ProcessDataFrameSearchResults
// Desc.   : Process the search results from the data frame. This is a
//           call-back method invoking from the data frame after the frame
//           is loaded
/////////////////////////////////////////////////////////////////////////////
var LUS_isDataFrameInitialized=false;
function LUS_ProcessDataFrameSearchResults()
{
   top.showProgressIndicator(false);
   var resultCondition = CSROrderSearchB2B_dataFrame.getSearchResultCondition();
   // Possible search result conditions:
   //    '0' - no match found
   //    '1' - match found within max. threshold
   //    '2' - match found exceeding max. threshold

   //-------------------------------------------------
   // Handle the first time of this page being loaded
   //-------------------------------------------------
   if (LUS_isDataFrameInitialized==false)
   {
      // Toggle ON to skip this block for all subsequent calls
      LUS_isDataFrameInitialized=true;

      if (resultCondition=='1')
      {
         // Re-wiring the data frame's result to LUS widget
         // and display the results in the resulting list box
         // and update the currently showing status line.
         lusWidget.LUS_setResultingList(CSROrderSearchB2B_dataFrame.getAccountNameList(),
                                        CSROrderSearchB2B_dataFrame.getAccountIdList());
         lusWidget.LUS_refreshCurrentlyShown();
      }
      else if (resultCondition=='2')
      {
         // Too many entries, show msg in widget to let user type account name to search
         lusWidget.LUS_setSearchKeyword('<%=UIUtil.toJavaScript((String) orderLabels.get("LUS_Label_keywordDefaultText"))%> ', true);
         lusWidget.LUS_refreshCurrentlyShown();
      }
      else if (resultCondition=='0')
      {
         // No entries avaliable in system, disable the widget
         lusWidget.LUS_disableAll();
      }

      return;

   }//end-if (LUS_isDataFrameInitialized==false)


   //----------------------------------------------------------
   // Process the search resulting data for various conditions
   //----------------------------------------------------------
   var msg = "";
   if (resultCondition=='0')
   {
      // No entries avaliable in system, disable the widget
      msg = "<%=UIUtil.toJavaScript((String) orderLabels.get("LUS_Msg_NotFound"))%>";
      alertDialog(msg);
      return;
   }
   else if (resultCondition=='2')
   {
      // Too many entries
      msg = "<%=UIUtil.toJavaScript((String) orderLabels.get("LUS_Msg_TooManyFound"))%>";
      var thresholdValue = new Number('<%=(String) orderLabels.get("LUS_MaxNumOfResultForAccountSearch")%>');
      if (isNaN(thresholdValue))
      {
         msg = msg.replace(/%1/, '100'); //default to 100 if invalid value
      }
      else
      {
         msg = msg.replace(/%1/, thresholdValue.toString());
      }
      alertDialog(msg);
      return;
   }
   else if (resultCondition=='1')
   {
      // Re-wiring the data frame's result to LUS widget
      // and display the results in the resulting list box
      // and update the currently showing status line.

      lusWidget.LUS_setResultingList(CSROrderSearchB2B_dataFrame.getAccountNameList(),
                                     CSROrderSearchB2B_dataFrame.getAccountIdList());
      lusWidget.LUS_refreshCurrentlyShown();
   }

}//end-function


/////////////////////////////////////////////////////////////////////////////
// Function: LUS_FindAction
// Desc.   : This triggers the search action in the data frame
/////////////////////////////////////////////////////////////////////////////
function LUS_FindAction()
{
   lusWidget.LUS_clearComboBox();
   lusWidget.LUS_refreshCurrentlyShown();

   var searchType   = lusWidget.LUS_getSelectedCriteria();
   var searchString = lusWidget.LUS_getSearchKeyword();

   // Building the search parameter as a query string
   var queryString = "searchType="    + searchType
                   + "&searchString=" + searchString
                   + "&maxThreshold=" + "<%=(String) orderLabels.get("LUS_MaxNumOfResultForAccountSearch")%>";

   var webAppPath = "<%=UIUtil.getWebappPath(request)%>";
   var newURL     = webAppPath + 'CSRSearchForAccountsView?' + queryString;

   top.showProgressIndicator(true);
   CSROrderSearchB2B_dataFrame.location.replace(newURL);

}//end-function


/////////////////////////////////////////////////////////////////////////////
// Function: LUS_SelectResultItem
// Desc.   : Rewire the user selected item from the resuling list box to
//           the expected form's field.
/////////////////////////////////////////////////////////////////////////////
function LUS_SelectResultItem()
{  
   var selectedItem = lusWidget.LUS_getSelectedResults();
   var selectedItemName = lusWidget.LUS_getSelectedResultNames();
   document.orderFindForm.LUS_QuickTextEntry.value=selectedItemName;
   document.orderFindForm.accountId.value = selectedItem;
}



</script>
<!-- ******************************************************************** -->
<!-- *   END HERE --- Javascript Functions for Wiring the LUS Widget    * -->
<!-- ******************************************************************** -->
<!-- /*d67432:add-end*/ -->


</head>


<body class="content" onload="initializeState();">

<iframe title='<%=calendarNLS.get("calendarTitle")%>'
	style='display: none; position: absolute; width: 198; height: 230'
	id='CalFrame' marginheight="0" marginwidth="0" noresize="noresize"
	frameborder="0" scrolling="no"
	src='/webapp/wcs/tools/servlet/tools/common/Calendar.jsp'> </iframe>

<h1><%=orderLabels.get("findDialog")%></h1>
<%=orderLabels.get("findCSOrderInst")%>
<form name="orderFindForm" id="orderFindForm" action="">
<table id="WC_ CSROrderSearchB2B_Table_1">
	<tbody>
		<tr>
			<td id="WC_ CSROrderSearchB2B_TableCell_1"><label for="orderNumber"><%=orderLabels.get("orderNumber")%></label></td>
		</tr>
		<tr>
			<td id="WC_ CSROrderSearchB2B_TableCell_2"><input size="20"
				type="text" maxlength="20" name="orderId" id="orderNumber" /></td>
		</tr>
		<tr>
			<td id="WC_ CSROrderSearchB2B_TableCell_3"></td>
		</tr>
		<tr>
			<td id="WC_ CSROrderSearchB2B_TableCell_4"><label for="customerName"><%=orderLabels.get("customerName")%></label></td>
			<td id="WC_ CSROrderSearchB2B_TableCell_5"></td>
		</tr>
		<tr>
			<td id="WC_ CSROrderSearchB2B_TableCell_6"><input id="customerName"
				size="31" type="text" maxlength="31" name="userLogon"
				value="<%=getUserLogon(customerId, request)%>" /></td>
			<td id="WC_ CSROrderSearchB2B_TableCell_7"><label for="searchType"></label>
			<select id="searchType" name="customerLogonSearchType">
				<option value="1" selected="selected"><%=UIUtil.toHTML((String) orderLabels.get("customerLogonSearchType1"))%></option>
				<option value="2"><%=UIUtil.toHTML((String) orderLabels.get("customerLogonSearchType2"))%></option>
				<option value="3"><%=UIUtil.toHTML((String) orderLabels.get("customerLogonSearchType3"))%></option>
				<option value="4"><%=UIUtil.toHTML((String) orderLabels.get("customerLogonSearchType4"))%></option>
				<option value="5"><%=UIUtil.toHTML((String) orderLabels.get("customerLogonSearchType5"))%></option>
			</select></td>
		</tr>
		<tr>
			<td id="WC_ CSROrderSearchB2B_TableCell_8"></td>
		</tr>
		<tr>
			<td id="WC_ CSROrderSearchB2B_TableCell_9"><br />
			<a href='javascript:onclick=toggleDiv()'
				id="WC_ CSROrderSearchB2B_Link_1"><u><%=UIUtil.toHTML((String) orderLabels.get("advancedOptions"))%></u></a>
			<br />
			</td>
		</tr>
	</tbody>
</table>

<div id="advancedOptionsDivision" style="display: none">
<input type="hidden" name="isAdvancedSearch" id="WC_ CSROrderSearchB2B_FormInput_isAdvancedSearch_In_orderFindForm_1" />
<table id="WC_ CSROrderSearchB2B_Table_2">
	<tr>
		<td id="WC_ CSROrderSearchB2B_TableCell_10"><label for="orderStatus"><%=orderLabels.get("orderStatus")%></label></td>
	</tr>
	<tr>
		<td id="WC_ CSROrderSearchB2B_TableCell_11"><select name="orderStatus"
			id="orderStatus">
			<option value="all"></option>
			<option value="I"><%=orderLabels.get("I")%></option>
			<option value="W"><%=orderLabels.get("W")%></option>
			<option value="N"><%=orderLabels.get("N")%></option>
			<option value="M"><%=orderLabels.get("M")%></option>
			<option value="B"><%=orderLabels.get("B")%></option>
			<option value="C"><%=orderLabels.get("C")%></option>
			<option value="E"><%=orderLabels.get("E")%></option>
			<option value="R"><%=orderLabels.get("R")%></option>
			<option value="S"><%=orderLabels.get("S")%></option>
			<option value="D"><%=orderLabels.get("D")%></option>
			<option value="L"><%=orderLabels.get("L")%></option>
			<option value="T"><%=orderLabels.get("T")%></option>
			<option value="A"><%=orderLabels.get("A")%></option>
			<option value="F"><%=orderLabels.get("F")%></option>
			<option value="G"><%=orderLabels.get("G")%></option>
			<option value="X"><%=orderLabels.get("X")%></option>
		</select></td>
	</tr>

      <tr>
        <td id = "WC_CSROrderSearchB2B_TableCell_orderitemstatus0"><label for="orderitemstatus"><%= orderLabels.get("orderItemStatus") %></label></td>
      </tr>
      <tr>
        <td id = "WC_CSROrderSearchB2B_TableCell_orderitemstatus1">
            <select name="orderItemStatus" id="orderitemstatus">
      		    <option value="" selected="selected"></option>
	      		<option value="I"><%= orderLabels.get("AOPOrderItemI") %></option>
	      		<option value="B"><%= orderLabels.get("AOPOrderItemB") %></option>  
    	  		<option value="C"><%= orderLabels.get("AOPOrderItemC") %></option>
      			<option value="R"><%= orderLabels.get("AOPOrderItemR") %></option>
	      		<option value="S"><%= orderLabels.get("AOPOrderItemS") %></option>
    	  		<option value="F"><%= orderLabels.get("AOPOrderItemF") %></option>
      			<option value="G"><%= orderLabels.get("AOPOrderItemG") %></option>
      			<option value="H"><%= orderLabels.get("AOPOrderItemH") %></option>
            </select>	
        </td>
      </tr>
      
      <tr>
      	<td>
      		<input type="hidden" name="orderType" value="ORD" id="orderType"/>
      	</td>
      </tr>
 
      <tr>
         <td id="WC_ CSROrderSearchB2B_TableCell_168"><label for="SKU1"><%=orderLabels.get("SKU")%></label></td>
      </tr>
      <tr>
        <td id="WC_ CSROrderSearchB2B_TableCell_169"><input size="30" type="text" maxlength="64" id="SKU1" name="SKU" /></td>
      </tr>

 
      <tr>
        <td><label for="orderBlocked1"><%= orderLabels.get("blockStatus") %></label></td>
      </tr>
      <tr>
        <td>
            <select name="orderBlocked" id="orderBlocked1" onchange="blockSelected()">
                <option value="" selected="selected"></option>
      		    <option value="N"><%= orderLabels.get("notBlockd") %></option>
      		    <option value="Y"><%= orderLabels.get("blocked") %></option>
            </select>	
        </td>
      </tr>
      <tr>
        <td id = "blockReasonLabel0" style="display:none"><label for="orderBlockReason1" ><%= orderLabels.get("orderBlockReason") %></label></td>
      </tr>
      <tr>
        <td id = "blockReason0" style="display:none">
            <select name="orderBlockReason" id="orderBlockReason1">
      		    <option value="all" selected="selected"></option>
      		    <!-- here need use new listdatabean -->
				  <%
				    BlockReasonCodeDataBean aBlkCodeBean = new BlockReasonCodeDataBean();
				    com.ibm.commerce.beans.DataBeanManager.activate(aBlkCodeBean, request);
				    BlockReasonCodeDataBean[] blkCodeDBs = aBlkCodeBean.getAllBlockReasonCode();
				    for (int i=0; i<blkCodeDBs.length; i++) {
				  %>    		   
      	   <option value="<%= blkCodeDBs[i].getBlockReasonCodeId()%>"><%= blkCodeDBs[i].getBlockReasonCodeId() + "  " +blkCodeDBs[i].getDescription() %></option>
      	    <%}%>
      	    </select>	
        </td>
    </tr>
    <tr> 
       <td>
           <input type="checkbox" name="ordersNotFulfilled" value="Yes" id="ordersNotFulfilled1"/><label for="ordersNotFulfilled1"><%= orderLabels.get("ordersNotFulfilled") %></label>
       </td>
    </tr>  
    <tr>
      <td id = "WC_CSROrderSearchB2B_TableCell_fulfillmentCenter0"><label for="fulfillmentCenter"><%= orderLabels.get("fulfillmentCenter") %></label></td>
    </tr>
    <tr>
      <td id = "WC_CSROrderSearchB2B_TableCell_fulfillmentCenter1">
      	<select name="fulfillmentCenterId" id="fulfillmentCenter">
      		<option value=""></option>
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
					<option value="<%= ffmId %>"><%= ffcDesc %></option>
				
			<%
      		}
      		%>
      	</select>	
      </td>
    </tr>
    </table>
    <table>    
    <tr>
      <td id="WC_ CSROrderSearchB2B_TableCell_ProtocolData0">
      	<label for="protocolDataName1"></label>
      	<label for="protocolDataValue1"><%=orderLabels.get("account")%></label>
      </td>
    </tr>
    <tr>
      <td id="WC_ CSROrderSearchB2B_TableCell_ProtocolData1">
      	<input type="hidden" name="protocolDataName1" value="account" id="protocolDataName1"/>
      	<input size="5" type="text" maxlength="5" id="protocolDataValue1" name="protocolDataValue1"/>
      </td>
    </tr>
    </table>
    
    <table>	
    <tr>
		<!-- /*d67432:chg*/ -->
		<td id="WC_ CSROrderSearchB2B_TableCell_12"><br />
		</td>
	</tr>
	<!-- /*d67432:del-begin*/
    <tr>
      <td><label for="accountId"><%-- /*d67432:del*/ <%= orderLabels.get("accountName") %> --%></label></td>
    </tr>
    <tr>
      <td>
        <select id="accountId" name="accountId">
         <option value=""></option>
         <%/*d67432:del*/ /* if (acctList != null) {
             for (int i=0; i<acctList.length; i++) { */%>
               <option value="<%-- /*d67432:del*/ <%=acctList[i].getAccountId()%> --%>"><%-- /*d67432:del*/ <%=acctList[i].getAccountName()%> --%></option>
         <%/*d67432:del*/ /* }
          } */%>

        </select>
      </td>
    </tr>
/*d67432:del-end*/ -->
	<tr>
		<td id="WC_ CSROrderSearchB2B_TableCell_20"></td>
	</tr>
</table>
<!-- /*d67432:chg-begin*/ --> <input type="hidden" name="accountId"
	id="WC_ CSROrderSearchB2B_FormInput_accountId_In_orderFindForm_1" /> <!-- /*d67432:chg-end*/ -->

<!-- /*d67432:add-begin*/ --> <!-- ******************************************************************** -->
<!-- *****        LUS Widget GUI Component Scope START HERE         ***** -->
<!-- ******************************************************************** -->

<table id="WC_ CSROrderSearchB2B_Table_3">
	<tbody>

		<tr>
			<!---------------------------------------------------------------->
			<!-- Status line showing currently items in the result list box -->
			<!---------------------------------------------------------------->
			<td id="LUS_NumOfCurrentlyShowing" colspan="2"><%=orderLabels.get("LUS_Label_statusLine")%>
			0</td>
		</tr>

		<tr>
			<!-- Building GUI Body Parts BEGIN ------------------------------>


			<!----------------------------------------------------------->
			<!-- Quick search text entry field with resulting list box -->
			<!----------------------------------------------------------->
			<td valign="top" id="LUS_TableCell_SelectAccount"><%=orderLabels.get("LUS_Label_selectAccount")%><br />
			<table border="0" id="WC_ CSROrderSearchB2B_Table_4">
				<tbody>
					<tr>
						<td id="LUS_TableCell_QuickNavigation"><label
							for="LUS_FormInput_QuickTextEntry"></label> <input
							name="LUS_QuickTextEntry" type="text" size="50"
							class="LUS_CSS_QuickTextEntryWidth"
							onkeyup="javascript:lusWidget.LUS_autoNavigate();"
							id="LUS_FormInput_QuickTextEntry" /><br />
						<label for="SearchResultListBox"></label> <select
							name="LUS_SearchResultListBox" size="4" id="SearchResultListBox"
							onchange="javascript:LUS_SelectResultItem();"
							class="LUS_CSS_ResultListBoxWidth">
						</select> <br />
						</td>
					</tr>
					<tr>
						<td id="LUS_TableCell_Null"></td>
					</tr>
				</tbody>
			</table>
			</td>

			<!--------------------------------------------------------------->
			<!-- Keyword field, criteria drop down, & search action button -->
			<!--------------------------------------------------------------->
			<td valign="top" id="LUS_TableCell_SearchAccount"><%=orderLabels.get("LUS_Label_searchAccount")%><br />
			<table border="0" id="WC_ CSROrderSearchB2B_Table_5">
				<tbody>
					<tr>
						<td id="LUS_TableCell_KeywordSearch"><label for="keyWord"></label>
						<input name="LUS_SearchTextField" type="text" size="20"
							id="keyWord" class="LUS_CSS_KeywordEntryWidth" /><br />
						<label for="criteria"></label> <select name="LUS_CriteriaDropDown"
							id="criteria" class="LUS_CSS_CriteriaListWidth">
							<option value="1"><%=orderLabels.get("LUS_SearchType1")%></option>
							<option value="2"><%=orderLabels.get("LUS_SearchType2")%></option>
							<option value="3"><%=orderLabels.get("LUS_SearchType3")%></option>
							<option value="4"><%=orderLabels.get("LUS_SearchType4")%></option>
							<option value="5"><%=orderLabels.get("LUS_SearchType5")%></option>
						</select><br />
						<br />
						</td>
					</tr>
					<tr>
						<td align="right" id="LUS_FormInput_FindAction">
						<button name="LUS_ActionButton" class="general"
							onclick="javascript:LUS_FindAction();"><%=orderLabels.get("LUS_Label_findButton")%></button>
						<br />
						</td>
					</tr>
				</tbody>
			</table>
			</td>


		</tr>
		<!-- Building GUI Body Parts End ------------------------------->

	</tbody>
</table>

<!-- ******************************************************************** -->
<!-- *****        LUS Widget GUI Component Scope END HERE           ***** -->
<!-- ******************************************************************** -->
<!-- /*d67432:add-end*/ -->




<table id="WC_ CSROrderSearchB2B_Table_6">
	<tr>
		<td colspan="9" align="left" valign="middle" height="32"><label for='orderDateLabel'><%=orderLabels.get("orderDate")%></label></td>
	</tr>
	<tr>
		<td height="25" colspan="4" valign="top"><label for='orderStartDateLabel'><%=orderLabels.get("startDate")%></label></td>
	</tr>
	<tr>
		<td><label for="WC_ CSROrderSearchB2B_FormInput_orderDateSDYear_In_orderFindForm_1"><%=orderLabels.get("year")%></label></td>
		<td><label for="WC_ CSROrderSearchB2B_FormInput_orderDateSDMonth_In_orderFindForm_1"><%=orderLabels.get("month")%></label></td>
		<td><label for="WC_ CSROrderSearchB2B_FormInput_orderDateSDDay_In_orderFindForm_1"><%=orderLabels.get("day")%></label></td>
	</tr>
	<tr>
		<td><input type='text' name='orderDateSDYear' size="4" maxlength="4"
			id="WC_ CSROrderSearchB2B_FormInput_orderDateSDYear_In_orderFindForm_1" /></td>

		<td><input type='text' name='orderDateSDMonth' size="4" maxlength="2"
			id="WC_ CSROrderSearchB2B_FormInput_orderDateSDMonth_In_orderFindForm_1" /></td>

		<td><input type='text' name='orderDateSDDay' size="4" maxlength="2"
			id="WC_ CSROrderSearchB2B_FormInput_orderDateSDDay_In_orderFindForm_1" /></td>
			
		<td valign="bottom" id="WC_ CSROrderSearchB2B_TableCell_37"><a
			href='javascript:setupOrderDateSD();showCalendar(document.all.orderDateSDImg)'
			id="WC_ CSROrderSearchB2B_Link_3"> <img
			src='/wcs/images/tools/calendar/calendar.gif' border='0'
			id='orderDateSDImg' alt='<%=orderLabels.get("startDate")%>' /> </a>
		</td>
	</tr>
	<tr>
		<td height="25" colspan="4" valign="top"
			id="WC_ CSROrderSearchB2B_TableCell_24"><label for='orderEndDateLabel'><%=orderLabels.get("endDate")%></label></td>
	</tr>
	<tr>
		<td><label
			for="WC_CSROrderSearchB2B_FormInput_orderDateEDYear_In_orderFindForm_1"><%=orderLabels.get("year")%></label></td>
		<td><label
			for="WC_CSROrderSearchB2B_FormInput_orderDateEDMonth_In_orderFindForm_1"><%=orderLabels.get("month")%></label></td>
		<td><label
			for="WC_CSROrderSearchB2B_FormInput_orderDateEDDay_In_orderFindForm_1"><%=orderLabels.get("day")%></label></td>
	</tr>
	<tr>

		<td>
		<input type='text' name='orderDateEDYear' size="4" maxlength="4"
			id="WC_CSROrderSearchB2B_FormInput_orderDateEDYear_In_orderFindForm_1" />&nbsp;</td>

		<td>
		<input type='text' name='orderDateEDMonth' size="4" maxlength="2"
			id="WC_CSROrderSearchB2B_FormInput_orderDateEDMonth_In_orderFindForm_1" />&nbsp;</td>

		<td>
		<input type='text' name='orderDateEDDay' size="4" maxlength="2"
			id="WC_CSROrderSearchB2B_FormInput_orderDateEDDay_In_orderFindForm_1" /></td>
		
		<td valign="bottom" id="WC_ CSROrderSearchB2B_TableCell_42"><a
			href='javascript:setupOrderDateED();showCalendar(document.all.orderDateEDImg)'
			id="WC_CSROrderSearchB2B_Link_4"> <img
			src='/wcs/images/tools/calendar/calendar.gif' border='0'
			id='orderDateEDImg' alt='<%=orderLabels.get("endDate")%>' /> </a></td>
	</tr>
</table>

<table	id="WC_ CSROrderSearchB2B_Table_7">
	<tr>
		<td colspan="9" align="left" valign="middle" height="32"><label for='orderUpdateDateLabel'><%=orderLabels.get("orderUpdatedDate")%></label></td>
	</tr>
	<tr>
		<td height="25" colspan="4" valign="top"><label for='lastUpdateStartDate'><%=orderLabels.get("startDate")%></label></td>
	</tr>
	<tr>
		<td><label for="WC_ CSROrderSearchB2B_FormInput_lastUpdateSDYear_In_orderFindForm_1"><%=orderLabels.get("year")%></label></td>
		<td><label for="WC_ CSROrderSearchB2B_FormInput_lastUpdateSDMonth_In_orderFindForm_1"><%=orderLabels.get("month")%></label></td>
		<td><label for="WC_ CSROrderSearchB2B_FormInput_lastUpdateSDDay_In_orderFindForm_1"><%=orderLabels.get("day")%></label></td>
	</tr>
	<tr>
		<td><input type='text' name='lastUpdateSDYear' size="4" maxlength="4"
			id="WC_ CSROrderSearchB2B_FormInput_lastUpdateSDYear_In_orderFindForm_1" /></td>
		<td><input type='text' name='lastUpdateSDMonth' size="4" maxlength="2"
			id="WC_ CSROrderSearchB2B_FormInput_lastUpdateSDMonth_In_orderFindForm_1" /></td>
		<td><input type='text' name='lastUpdateSDDay' size="4" maxlength="2"
			id="WC_ CSROrderSearchB2B_FormInput_lastUpdateSDDay_In_orderFindForm_1" /></td>
		<td valign="bottom" id="WC_ CSROrderSearchB2B_TableCell_59"><a
			href='javascript:setupLastUpdateSD();showCalendar(document.all.lastUpdateSDImg)'
			id="WC_ CSROrderSearchB2B_Link_5"> <img
			src='/wcs/images/tools/calendar/calendar.gif' border='0'
			id='lastUpdateSDImg' alt='<%=orderLabels.get("startDate")%>' /> </a>
		</td>
	</tr>

	<tr>
		<td height="25" colspan="4" valign="top"
			id="WC_ CSROrderSearchB2B_TableCell_46"><label for='orderUpdateEndDateLabel'><%=orderLabels.get("endDate")%></td>
	</tr>
	<tr>
		<td><label for="WC_ CSROrderSearchB2B_FormInput_lastUpdateEDYear_In_orderFindForm_1"><%=orderLabels.get("year")%></label></td>
		<td><label for="WC_ CSROrderSearchB2B_FormInput_lastUpdateEDMonth_In_orderFindForm_1"><%=orderLabels.get("month")%></label></td>
		<td><label for="WC_ CSROrderSearchB2B_FormInput_lastUpdateEDDay_In_orderFindForm_1"><%=orderLabels.get("day")%></label></td>
	</tr>
	<tr>

		<td><input type='text' name='lastUpdateEDYear' size="4" maxlength="4"
			id="WC_ CSROrderSearchB2B_FormInput_lastUpdateEDYear_In_orderFindForm_1" /></td>

		<td><input type='text' name='lastUpdateEDMonth' size="4" maxlength="2"
			id="WC_ CSROrderSearchB2B_FormInput_lastUpdateEDMonth_In_orderFindForm_1" /></td>

		<td><input type='text' name='lastUpdateEDDay' size="4" maxlength="2"
			id="WC_ CSROrderSearchB2B_FormInput_lastUpdateEDDay_In_orderFindForm_1" /></td>
		
		<td valign="bottom" id="WC_ CSROrderSearchB2B_TableCell_64"><a
			href='javascript:setupLastUpdateED();showCalendar(document.all.lastUpdateEDImg)'
			id="WC_ CSROrderSearchB2B_Link_6"> <img
			src='/wcs/images/tools/calendar/calendar.gif' border='0'
			id='lastUpdateEDImg' alt='<%=orderLabels.get("endDate")%>' /> </a></td>


	</tr>

</table>

<table id="WC_ CSROrderSearchB2B_Table_8">


	<%boolean switchNames = false;

if (jLocale.toString().equals("ja_JP")
	|| jLocale.toString().equals("ko_KR")
	|| jLocale.toString().equals("zh_CN")
	|| jLocale.toString().equals("zh_TW")) {
	switchNames = true;
}%>
	<tr>
		<%if (!switchNames) {%>
		<td id="WC_ CSROrderSearchB2B_TableCell_65"><label for="fName1"><%=orderLabels.get("firstName")%></label></td>
		<%} else {%>
		<td id="WC_ CSROrderSearchB2B_TableCell_66"><label for="lName1"><%=orderLabels.get("lastName")%></label></td>
		<%}%>
		<td id="WC_ CSROrderSearchB2B_TableCell_67"></td>
	</tr>
	<tr>
		<%if (!switchNames) {%>
		<td id="WC_ CSROrderSearchB2B_TableCell_68"><label for="fName1"></label>
		<input size="31" type="text" maxlength="128" id="fName1"
			name="firstName" value="" /></td>
		<td id="WC_ CSROrderSearchB2B_TableCell_69"><label
			for="fNameSearchType1"></label> <select name="firstNameSearchType"
			id="fNameSearchType1">
			<option value="1" selected="selected"><%=UIUtil.toHTML((String) orderLabels.get("customerLogonSearchType1"))%></option>
			<option value="2"><%=UIUtil.toHTML((String) orderLabels.get("customerLogonSearchType2"))%></option>
			<option value="3"><%=UIUtil.toHTML((String) orderLabels.get("customerLogonSearchType3"))%></option>
			<option value="4"><%=UIUtil.toHTML((String) orderLabels.get("customerLogonSearchType4"))%></option>
			<option value="5"><%=UIUtil.toHTML((String) orderLabels.get("customerLogonSearchType5"))%></option>
		</select></td>
		<%} else {%>
		<td id="WC_ CSROrderSearchB2B_TableCell_70"><label for="lName1"></label>
		<input size="31" type="text" maxlength="128" id="lName1"
			name="lastName" value="" /></td>
		<td id="WC_ CSROrderSearchB2B_TableCell_71"><label
			for="lNameSearchType1"></label> <select name="lastNameSearchType"
			id="lNameSearchType1">
			<option value="1" selected="selected"><%=UIUtil.toHTML((String) orderLabels.get("customerLogonSearchType1"))%></option>
			<option value="2"><%=UIUtil.toHTML((String) orderLabels.get("customerLogonSearchType2"))%></option>
			<option value="3"><%=UIUtil.toHTML((String) orderLabels.get("customerLogonSearchType3"))%></option>
			<option value="4"><%=UIUtil.toHTML((String) orderLabels.get("customerLogonSearchType4"))%></option>
			<option value="5"><%=UIUtil.toHTML((String) orderLabels.get("customerLogonSearchType5"))%></option>
		</select></td>
		<%}%>
	</tr>
	<tr>
		<td id="WC_ CSROrderSearchB2B_TableCell_72"></td>
	</tr>
	<tr>
		<%if (!switchNames) {%>
		<td id="WC_ CSROrderSearchB2B_TableCell_73"><label for="lName2"><%=orderLabels.get("lastName")%></label></td>
		<%} else {%>
		<td id="WC_ CSROrderSearchB2B_TableCell_74"><label for="fName2"><%=orderLabels.get("firstName")%></label></td>
		<%}%>
		<td id="WC_ CSROrderSearchB2B_TableCell_75"></td>
	</tr>
	<tr>
		<%if (!switchNames) {%>
		<td id="WC_ CSROrderSearchB2B_TableCell_76"><input size="31"
			type="text" maxlength="128" id="lName2" name="lastName" value="" /></td>
		<td id="WC_ CSROrderSearchB2B_TableCell_77"><label
			for="lNameSearchType2"></label> <select name="lastNameSearchType"
			id="lNameSearchType2">
			<option value="1" selected="selected"><%=UIUtil.toHTML((String) orderLabels.get("customerLogonSearchType1"))%></option>
			<option value="2"><%=UIUtil.toHTML((String) orderLabels.get("customerLogonSearchType2"))%></option>
			<option value="3"><%=UIUtil.toHTML((String) orderLabels.get("customerLogonSearchType3"))%></option>
			<option value="4"><%=UIUtil.toHTML((String) orderLabels.get("customerLogonSearchType4"))%></option>
			<option value="5"><%=UIUtil.toHTML((String) orderLabels.get("customerLogonSearchType5"))%></option>
		</select></td>
		<%} else {%>
		<td id="WC_ CSROrderSearchB2B_TableCell_78"><input size="31"
			type="text" maxlength="128" id="fName2" name="firstName" value="" /></td>

		<td id="WC_ CSROrderSearchB2B_TableCell_79"><label
			for="fNameSearchType2"></label> <select name="firstNameSearchType"
			id="fNameSearchType2">
			<option value="1" selected="selected"><%=UIUtil.toHTML((String) orderLabels.get("customerLogonSearchType1"))%></option>
			<option value="2"><%=UIUtil.toHTML((String) orderLabels.get("customerLogonSearchType2"))%></option>
			<option value="3"><%=UIUtil.toHTML((String) orderLabels.get("customerLogonSearchType3"))%></option>
			<option value="4"><%=UIUtil.toHTML((String) orderLabels.get("customerLogonSearchType4"))%></option>
			<option value="5"><%=UIUtil.toHTML((String) orderLabels.get("customerLogonSearchType5"))%></option>
		</select></td>
		<%}%>
	</tr>
	<tr>
		<td id="WC_ CSROrderSearchB2B_TableCell_80"></td>
	</tr>
	<tr>
		<td id="WC_ CSROrderSearchB2B_TableCell_81"><label for="addr1"><%=orderLabels.get("address1")%></label></td>
		<td id="WC_ CSROrderSearchB2B_TableCell_82"></td>
	</tr>
	<tr>
		<td id="WC_ CSROrderSearchB2B_TableCell_83"><input size="31"
			type="text" maxlength="50" id="addr1" name="address1" value="" /></td>
		<td id="WC_ CSROrderSearchB2B_TableCell_84"><label
			for="addrSearchType1"></label> <select name="address1SearchType"
			id="addrSearchType1">
			<option value="1" selected="selected"><%=UIUtil.toHTML((String) orderLabels.get("customerLogonSearchType1"))%></option>
			<option value="2"><%=UIUtil.toHTML((String) orderLabels.get("customerLogonSearchType2"))%></option>
			<option value="3"><%=UIUtil.toHTML((String) orderLabels.get("customerLogonSearchType3"))%></option>
			<option value="4"><%=UIUtil.toHTML((String) orderLabels.get("customerLogonSearchType4"))%></option>
			<option value="5"><%=UIUtil.toHTML((String) orderLabels.get("customerLogonSearchType5"))%></option>
		</select></td>
	</tr>
	<tr>
      <td id="WC_ CSROrderSearchB2B_TableCell_801"><label for="city"><%=orderLabels.get("city")%></label></td>
      <td id="WC_ CSROrderSearchB2B_TableCell_802"></td>
    </tr>
    <tr>
      <td id="WC_ CSROrderSearchB2B_TableCell_803"><input size="31"
       type="text" maxlength="50" id="city" name="city" value="" /></td>
      <td id="WC_ CSROrderSearchB2B_TableCell_804">
      <label for="citySearchType1"></label>
        <select name="citySearchType" id="citySearchType1">
	  <option value="1" selected="selected" ><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType1")) %></option>
	  <option value="2"><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType2")) %></option>
	  <option value="3"><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType3")) %></option>
	  <option value="4"><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType4")) %></option>
	  <option value="5"><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType5")) %></option>
        </select>            
      </td>
    </tr>
	<tr>
		<td id="WC_ CSROrderSearchB2B_TableCell_85"></td>
	</tr>
	<tr>
		<td id="WC_ CSROrderSearchB2B_TableCell_86"><label for="zip1"><%=orderLabels.get("zipcode")%></label></td>
		<td id="WC_ CSROrderSearchB2B_TableCell_87"></td>
	</tr>
	<tr>
		<td id="WC_ CSROrderSearchB2B_TableCell_88"><input size="31"
			type="text" maxlength="40" id="zip1" name="zipcode" value="" /></td>
		<td id="WC_ CSROrderSearchB2B_TableCell_89"><label
			for="zipSearchType1"></label> <select name="zipcodeSearchType"
			id="zipSearchType1">
			<option value="1" selected="selected"><%=UIUtil.toHTML((String) orderLabels.get("customerLogonSearchType1"))%></option>
			<option value="2"><%=UIUtil.toHTML((String) orderLabels.get("customerLogonSearchType2"))%></option>
			<option value="3"><%=UIUtil.toHTML((String) orderLabels.get("customerLogonSearchType3"))%></option>
			<option value="4"><%=UIUtil.toHTML((String) orderLabels.get("customerLogonSearchType4"))%></option>
			<option value="5"><%=UIUtil.toHTML((String) orderLabels.get("customerLogonSearchType5"))%></option>
		</select></td>
	</tr>
	<tr>
		<td id="WC_ CSROrderSearchB2B_TableCell_90"></td>
	</tr>
	<tr>
		<td id="WC_ CSROrderSearchB2B_TableCell_91"><label for="email1"><%=orderLabels.get("email1")%></label></td>
		<td id="WC_ CSROrderSearchB2B_TableCell_92"></td>
	</tr>
	<tr>
		<td id="WC_ CSROrderSearchB2B_TableCell_93"><input size="31"
			type="text" maxlength="128" id="email1" name="email1" value="" /></td>
		<td id="WC_ CSROrderSearchB2B_TableCell_94"><label
			for="emailSearchType1"></label> <select name="email1SearchType"
			id="emailSearchType1">
			<option value="1" selected="selected"><%=UIUtil.toHTML((String) orderLabels.get("customerLogonSearchType1"))%></option>
			<option value="2"><%=UIUtil.toHTML((String) orderLabels.get("customerLogonSearchType2"))%></option>
			<option value="3"><%=UIUtil.toHTML((String) orderLabels.get("customerLogonSearchType3"))%></option>
			<option value="4"><%=UIUtil.toHTML((String) orderLabels.get("customerLogonSearchType4"))%></option>
			<option value="5"><%=UIUtil.toHTML((String) orderLabels.get("customerLogonSearchType5"))%></option>
		</select></td>
	</tr>
	<tr>
		<td id="WC_ CSROrderSearchB2B_TableCell_95"></td>
	</tr>
	<tr>
		<td id="WC_ CSROrderSearchB2B_TableCell_96"><label for="phone1"><%=orderLabels.get("phone1")%></label></td>
		<td id="WC_ CSROrderSearchB2B_TableCell_97"></td>
	</tr>
	<tr>
		<td id="WC_ CSROrderSearchB2B_TableCell_98"><input size="31"
			type="text" maxlength="32" id="phone1" name="phone1" value="" /></td>
	</tr>
	<tr>
		<td id="WC_ CSROrderSearchB2B_TableCell_99"></td>
	</tr>
 
	<tr>
    <% if (!switchNames) { %>
      		<td id="WC_ CSROrderSearchB2B_TableCell_103"><label for="fsName1"><%=orderLabels.get("billFirstName")%></label></td> 
    <% } else { %>
      		<td id="WC_ CSROrderSearchB2B_TableCell_102"><label for="lsName1"><%=orderLabels.get("billLastName")%></label></td>       		
    <% } %>
      <td id="WC_ CSROrderSearchB2B_TableCell_104"></td>
    </tr> 
    
	<tr>
    <% if (!switchNames) { %>
      <td id="WC_ CSROrderSearchB2B_TableCell_107"><input size="31" type="text" maxlength="128" id="fsName1" name="billFirstName" value="" /></td>
      <td id="WC_ CSROrderSearchB2B_TableCell_108">
         <label for="fsNameSearchType1"></label>
       	<select name="billFirstNameSearchType" id="fsNameSearchType1">
       		<option value="1" selected="selected" ><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType1")) %></option>
	        <option value="2"><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType2")) %></option>
	        <option value="3"><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType3")) %></option>
	        <option value="4"><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType4")) %></option>
	        <option value="5"><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType5")) %></option>
        </select>
       </td>    
    <% } else { %>
      <td id="WC_ CSROrderSearchB2B_TableCell_105"><input size="31" type="text" maxlength="128" id="lsName1" name="billLastName" value="" /></td>
      <td id="WC_ CSROrderSearchB2B_TableCell_106">
         <label for="lsNameSearchType1"></label>
      	<select name="billLastNameSearchType" id="lsNameSearchType1">
      		<option value="1" selected="selected" ><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType1")) %></option>
	        <option value="2"><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType2")) %></option>
	        <option value="3"><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType3")) %></option>
	        <option value="4"><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType4")) %></option>
	        <option value="5"><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType5")) %></option>
        </select>
       </td>
    <% } %>
	              
      
    </tr>
    <tr>
    <% if (!switchNames) { %>
      		<td id="WC_ CSROrderSearchB2B_TableCell_110"><label for="lsName2"><%=orderLabels.get("billLastName")%></label></td> 
    <% } else { %>
      		<td id="WC_ CSROrderSearchB2B_TableCell_109"><label for="fsName2"><%=orderLabels.get("billFirstName")%></label></td>       		
    <% } %>
      <td id="WC_ CSROrderSearchB2B_TableCell_111"></td>
    </tr>      
	<tr>
    <% if (!switchNames) { %>
      <td id="WC_ CSROrderSearchB2B_TableCell_114"><input size="31" type="text" maxlength="128" id="lsName2" name="billLastName" value="" /></td>
      <td id="WC_ CSROrderSearchB2B_TableCell_115">
      <label for="lsNameSearchType2"></label>
       	<select name="billLastNameSearchType" id="lsNameSearchType2">
       		<option value="1" selected="selected" ><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType1")) %></option>
	        <option value="2"><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType2")) %></option>
	        <option value="3"><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType3")) %></option>
	        <option value="4"><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType4")) %></option>
	        <option value="5"><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType5")) %></option>
        </select>            
      </td>
    <% } else { %>
      <td id="WC_ CSROrderSearchB2B_TableCell_112"><input size="31" type="text" maxlength="128" id="fsName2" name="billFirstName" value="" /></td>
      <td id="WC_ CSROrderSearchB2B_TableCell_113">
      <label for="fsNameSearchType2"></label>
      	<select name="billFirstNameSearchType" id="fsNameSearchType2">
      		<option value="1" selected="selected" ><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType1")) %></option>
	        <option value="2"><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType2")) %></option>
	        <option value="3"><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType3")) %></option>
	        <option value="4"><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType4")) %></option>
	        <option value="5"><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType5")) %></option>
        </select>            
      </td>    
    <% } %>
	  
    </tr>          
    <tr>
      <td id="WC_ CSROrderSearchB2B_TableCell_116"></td>
    </tr>
    <tr>
      <td id="WC_ CSROrderSearchB2B_TableCell_117"><label for="billAddress1"><%=orderLabels.get("billaddress1")%></label></td>
      <td id="WC_ CSROrderSearchB2B_TableCell_118"></td>
    </tr>
    <tr>
      <td id="WC_ CSROrderSearchB2B_TableCell_119"><input size="31" type="text" maxlength="50" name="billAddress1" id="billAddress1" value="" /></td>
      <td id="WC_ CSROrderSearchB2B_TableCell_120">
      <label for="billAddress1SearchType"></label>
        <select name="billAddress1SearchType" id="billAddress1SearchType">
	  <option value="1" selected="selected" ><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType1")) %></option>
	  <option value="2"><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType2")) %></option>
	  <option value="3"><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType3")) %></option>
	  <option value="4"><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType4")) %></option>
	  <option value="5"><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType5")) %></option>
        </select>            
      </td>
    </tr>
    <tr>
      <td id="WC_ CSROrderSearchB2B_TableCell_121"></td>
    </tr>
    <tr>
      <td id="WC_ CSROrderSearchB2B_TableCell_122"><label for="billCity"><%=orderLabels.get("billCity")%></label></td>
      <td id="WC_ CSROrderSearchB2B_TableCell_123"></td>
    </tr>
    <tr>
      <td id="WC_ CSROrderSearchB2B_TableCell_124"><input size="31" type="text" maxlength="50" name="billCity" id="billCity" value="" /></td>
      <td id="WC_ CSROrderSearchB2B_TableCell_125">
      <label for="billCitySearchType"></label>
        <select name="billCitySearchType" id="billCitySearchType">
	  <option value="1" selected="selected" ><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType1")) %></option>
	  <option value="2"><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType2")) %></option>
	  <option value="3"><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType3")) %></option>
	  <option value="4"><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType4")) %></option>
	  <option value="5"><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType5")) %></option>
        </select>            
      </td>
    </tr>
    
    <tr>
      <td id="WC_ CSROrderSearchB2B_TableCell_126"><label for="billZipcode"><%=orderLabels.get("billzipcode")%></label></td>
      <td id="WC_ CSROrderSearchB2B_TableCell_127"></td>
    </tr>
    <tr>
      <td id="WC_ CSROrderSearchB2B_TableCell_128"><input size="31" type="text" maxlength="40" name="billZipcode" id="billZipcode" value="" /></td>
      <td id="WC_ CSROrderSearchB2B_TableCell_129">
      <label for="billZipcodeSearchType"></label>
        <select name="billZipcodeSearchType" id="billZipcodeSearchType">
	  <option value="1" selected="selected" ><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType1")) %></option>
	  <option value="2"><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType2")) %></option>
	  <option value="3"><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType3")) %></option>
	  <option value="4"><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType4")) %></option>
	  <option value="5"><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType5")) %></option>
        </select>            
      </td>
    </tr>
       
   <tr>
	<% if (!switchNames) { %>
      		<td id="WC_ CSROrderSearchB2B_TableCell_130"><label for="shipFirstName1"><%=orderLabels.get("shipFirstName")%></label></td>
    <% } else { %>
       		<td id="WC_ CSROrderSearchB2B_TableCell_131"><label for="shipLastName1"><%=orderLabels.get("shipLastName")%></label></td> 
    <% } %>
      <td id="WC_ CSROrderSearchB2B_TableCell_132"></td>
    </tr>
    <tr>
    <% if (!switchNames) { %>
      <td id="WC_ CSROrderSearchB2B_TableCell_133"><input size="31" type="text" maxlength="128" id="shipFirstName1" name="shipFirstName" value="" /></td>
      <td id="WC_ CSROrderSearchB2B_TableCell_134">
	    <label for="shipFirstNameSearchType1"></label>
      	<select name="shipFirstNameSearchType" id="shipFirstNameSearchType1">
      		<option value="1" selected="selected" ><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType1")) %></option>
	        <option value="2"><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType2")) %></option>
	        <option value="3"><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType3")) %></option>
	        <option value="4"><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType4")) %></option>
	        <option value="5"><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType5")) %></option>
        </select>            
      </td>
    <% } else { %>
      <td id="WC_ CSROrderSearchB2B_TableCell_135"><input size="31" type="text" maxlength="128" id="shipLastName1" name="shipLastName" value="" /></td>
      <td id="WC_ CSROrderSearchB2B_TableCell_136">
	    <label for="shipLastNameSearchType1"></label>
       	<select name="shipLastNameSearchType" id="shipLastNameSearchType1">
       		<option value="1" selected="selected" ><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType1")) %></option>
	        <option value="2"><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType2")) %></option>
	        <option value="3"><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType3")) %></option>
	        <option value="4"><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType4")) %></option>
	        <option value="5"><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType5")) %></option>
        </select>            
      </td>
    <% } %>
	  
    </tr>
   <tr>
	<% if (!switchNames) { %>
      		<td id="WC_ CSROrderSearchB2B_TableCell_137"><label for="shipLastName2"><%=orderLabels.get("shipLastName")%></label></td>
    <% } else { %>
       		<td id="WC_ CSROrderSearchB2B_TableCell_138"><label for="shipFirstName2"><%=orderLabels.get("shipFirstName")%></label></td> 
    <% } %>
      <td id="WC_ CSROrderSearchB2B_TableCell_139"></td>
    </tr>
    <tr>
    <% if (!switchNames) { %>
      <td id="WC_ CSROrderSearchB2B_TableCell_140"><input size="31" type="text" maxlength="128" id="shipLastName2" name="shipLastName" value="" /></td>
      <td id="WC_ CSROrderSearchB2B_TableCell_141">
      <label for="shipLastNameSearchType1"></label>
      	<select name="shipLastNameSearchType" id="shipLastNameSearchType1">
      		<option value="1" selected="selected" ><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType1")) %></option>
	        <option value="2"><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType2")) %></option>
	        <option value="3"><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType3")) %></option>
	        <option value="4"><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType4")) %></option>
	        <option value="5"><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType5")) %></option>
        </select>            
      </td>
    <% } else { %>
      <td id="WC_ CSROrderSearchB2B_TableCell_142"><input size="31" type="text" maxlength="128" id="shipFirstName2" name="shipFirstName" value="" /></td>
      <td id="WC_ CSROrderSearchB2B_TableCell_143">
      <label for="shipFirstNameSearchType2"></label>
       	<select name="shipFirstNameSearchType" id="shipFirstNameSearchType2">
       		<option value="1" selected="selected" ><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType1")) %></option>
	        <option value="2"><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType2")) %></option>
	        <option value="3"><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType3")) %></option>
	        <option value="4"><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType4")) %></option>
	        <option value="5"><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType5")) %></option>
        </select>            
      </td>
    <% } %>
	  
    </tr>    
    <tr>
      <td id="WC_ CSROrderSearchB2B_TableCell_144"></td>
    </tr>

   
    <tr>
      <td id="WC_ CSROrderSearchB2B_TableCell_145"><label for="shipAddress1"><%=orderLabels.get("shipaddress1")%></label></td>
      <td id="WC_ CSROrderSearchB2B_TableCell_146"></td>
    </tr>
    <tr>
      <td id="WC_ CSROrderSearchB2B_TableCell_147"><input size="31" type="text" maxlength="50" name="shipAddress1" id="shipAddress1" value="" /></td>
      <td id="WC_ CSROrderSearchB2B_TableCell_148">
      <label for="shipAddress1SearchType"></label>
        <select name="shipAddress1SearchType" id="shipAddress1SearchType">
	  <option value="1" selected="selected" ><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType1")) %></option>
	  <option value="2"><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType2")) %></option>
	  <option value="3"><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType3")) %></option>
	  <option value="4"><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType4")) %></option>
	  <option value="5"><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType5")) %></option>
        </select>            
      </td>
    </tr>
    <tr>
      <td id="WC_ CSROrderSearchB2B_TableCell_149"></td>
    </tr>
    
    <tr>
      <td id="WC_ CSROrderSearchB2B_TableCell_150"><label for="shipCity"><%=orderLabels.get("shipCity")%></label></td>
      <td id="WC_ CSROrderSearchB2B_TableCell_151"></td>
    </tr>
    <tr>
      <td id="WC_ CSROrderSearchB2B_TableCell_152"><input size="31" type="text" maxlength="50" name="shipCity" id="shipCity" value="" /></td>
      <td id="WC_ CSROrderSearchB2B_TableCell_153">
      <label for="shipCitySearchType"></label>
        <select name="shipCitySearchType" id="shipCitySearchType">
 	  <option value="1" selected="selected" ><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType1")) %></option>
	  <option value="2"><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType2")) %></option>
	  <option value="3"><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType3")) %></option>
	  <option value="4"><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType4")) %></option>
	  <option value="5"><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType5")) %></option>
        </select>            
      </td>
    </tr>
    
    <tr>
      <td id="WC_ CSROrderSearchB2B_TableCell_154"><label for="shipZipcode"><%=orderLabels.get("shipzipcode")%></label></td>
      <td id="WC_ CSROrderSearchB2B_TableCell_155"></td>
    </tr>
    <tr>
      <td id="WC_ CSROrderSearchB2B_TableCell_156"><input size="31" type="text" maxlength="40" name="shipZipcode" id="shipZipcode" value="" /></td>
      <td id="WC_ CSROrderSearchB2B_TableCell_157">
      <label for="shipZipcodeSearchType"></label>
        <select name="shipZipcodeSearchType" id="shipZipcodeSearchType">
	  <option value="1" selected="selected" ><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType1")) %></option>
	  <option value="2"><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType2")) %></option>
	  <option value="3"><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType3")) %></option>
	  <option value="4"><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType4")) %></option>
	  <option value="5"><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType5")) %></option>
        </select>            
      </td>
    </tr>
       
	<tr>
      <td id="WC_ CSROrderSearchB2B_TableCell_158"><label for="orgName"><%=orderLabels.get("organizationName")%></label></td>
      <td id="WC_ CSROrderSearchB2B_TableCell_159"></td>
    </tr>
    <tr>
      <td id="WC_ CSROrderSearchB2B_TableCell_160"><input size="31" type="text" maxlength="40" name="orgName" id ="orgName" value="" /></td>
      <td id="WC_ CSROrderSearchB2B_TableCell_161">
      <label for="orgNameSearchType"></label>
        <select name="orgNameSearchType" id="orgNameSearchType">
	  <option value="1" selected="selected" ><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType1")) %></option>
	  <option value="2"><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType2")) %></option>
	  <option value="3"><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType3")) %></option>
	  <option value="4"><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType4")) %></option>
	  <option value="5"><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType5")) %></option>
        </select>            
      </td>
    </tr>       
    
    <tr style="display:none">
      <td id="WC_ CSROrderSearchB2B_TableCell_164"><label for="ordersField1"><%=orderLabels.get("ordersField1")%></label></td>
    </tr>
    <tr style="display:none">
      <td id="WC_ CSROrderSearchB2B_TableCell_165"><input size="9" type="text" maxlength="9" id="ordersField1" name="ordersField1" /></td>
    </tr>
    <tr>
      <td id="WC_ CSROrderSearchB2B_TableCell_166"></td>
    </tr>
    <tr>
      <td id="WC_ CSROrderSearchB2B_TableCell_167"></td>
    </tr>
    <tr>
      <td id="WC_ CSROrderSearchB2B_TableCell_170"></td>
    </tr>
    <tr>
      <td id="WC_ CSROrderSearchB2B_TableCell_171"></td>
    </tr>

    <tr style="display:none">
      <td id="WC_ CSROrderSearchB2B_TableCell_172"><label for="orgField1"><%=orderLabels.get("orgField1")%></label></td>
      <td id="WC_ CSROrderSearchB2B_TableCell_173"></td>
    </tr>
     <tr style="display:none">
      <td id="WC_ CSROrderSearchB2B_TableCell_174"><input size="64" type="text" maxlength="64" id="orgField1" name="orgField1" value="" /></td>
      <td id="WC_ CSROrderSearchB2B_TableCell_174">
      <label for="orgField1SearchType1"></label>
        <select name="orgField1SearchType" id="orgField1SearchType1">
	  <option value="1" selected="selected" ><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType1")) %></option>
	  <option value="2"><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType2")) %></option>
	  <option value="3"><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType3")) %></option>
	  <option value="4"><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType4")) %></option>
	  <option value="5"><%= UIUtil.toHTML((String)orderLabels.get("customerLogonSearchType5")) %></option>
        </select>            
      </td>
    </tr>
</table>

<table id="WC_ CSROrderSearchB2B_Table_9">
	<tr>
		<td id="WC_ CSROrderSearchB2B_TableCell_100"><br />
		<label for="maxDisplay"><%=orderLabels.get("maximumDisplay")%></label></td>
	</tr>
	<tr>
		<td id="WC_ CSROrderSearchB2B_TableCell_101"><label for="maxDisplay"></label>
		<input size="9" type="text" maxlength="9" id="maxDisplay"
			name="fetchSize" value="100" /></td>
	</tr>
</table>

</div>

</form>

<script language="JavaScript" type="text/javascript">
<!--
//For IE
if (document.all) {
    onLoad();
}
//-->

</script>

<!-- /*d67432:add-begin*/ -->
<!-- Initialize the LUS Widget -->
<script type="text/javascript">
   LUS_Setup();

</script>
<!-- /*d67432:add-end*/ -->

</body>
</html>


