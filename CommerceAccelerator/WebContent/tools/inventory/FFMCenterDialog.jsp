

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2000, 2016 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>     
<%@ page language="java" import="java.util.*" %>
<%@ page import="com.ibm.commerce.command.*" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.tools.xml.*" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.user.objects.*" %>
<%@ page import="com.ibm.commerce.common.beans.StoreDataBean" %>
<%@ page import="com.ibm.commerce.tools.optools.user.beans.*" %>
<%@ page import="com.ibm.commerce.tools.optools.order.commands.*" %>
<%@ page import="com.ibm.commerce.beans.*" %>
<%@ page import="com.ibm.commerce.server.*" %>
<%@ page import="com.ibm.commerce.common.beans.*" %>
<%@ page import="com.ibm.commerce.usermanagement.commands.ECUserConstants" %>
<%@ page import="com.ibm.commerce.user.beans.*" %>
<%@ page import="com.ibm.commerce.datatype.TypedProperty" %>
<%@ page import="com.ibm.commerce.tools.common.ui.taglibs.*" %>
<%@ page import="com.ibm.commerce.server.JSPHelper" %>
<%@ page import="com.ibm.commerce.fulfillment.beans.FulfillmentCenterDataBean" %>
<%@ page import="com.ibm.commerce.fulfillment.beans.FulfillmentCenterDescriptionDataBean" %>
<%@ page import="com.ibm.commerce.fulfillment.beans.StAddressDataBean" %>
<%@ page import="com.ibm.commerce.beans.DataBeanManager,
	com.ibm.commerce.tools.segmentation.SegmentCountriesDataBean" %>
	
<%@include file="../common/common.jsp" %>

<jsp:useBean id="orgEntityBean" scope="request" class="com.ibm.commerce.user.beans.OrgEntityManageDataBean">
</jsp:useBean>

<jsp:useBean id="ffcBean" scope="request" class="com.ibm.commerce.fulfillment.beans.FulfillmentCenterDataBean">
</jsp:useBean>

<jsp:useBean id="ffcDescBean" scope="request" class="com.ibm.commerce.fulfillment.beans.FulfillmentCenterDescriptionDataBean">
</jsp:useBean>

<jsp:useBean id="addressListBean" scope="request" class="com.ibm.commerce.fulfillment.beans.StAddressListDataBean">
</jsp:useBean>

<jsp:useBean class="com.ibm.commerce.tools.taxation.databeans.StateProvBean" id="StateProvBean" scope="request">  
<% com.ibm.commerce.beans.DataBeanManager.activate(StateProvBean, request); %></jsp:useBean>

<%     
    SegmentCountriesDataBean segmentCountries = new SegmentCountriesDataBean();
	   DataBeanManager.activate(segmentCountries, request);
	   SegmentCountriesDataBean.Country[] countries = segmentCountries.getCountries();
	   String selectBoxHtmlForCountry = "";
	   for(int k =0 ;k < countries.length ; k++)
       {
           String selectBoxHtmlForPartCountry ="<option value = \"";
           String country = countries[k].getName();
           country = country.replaceAll("'","\\\\'");
           selectBoxHtmlForPartCountry = selectBoxHtmlForPartCountry + country+ "\">" + country+ "</option>" ;
           selectBoxHtmlForCountry = selectBoxHtmlForCountry + selectBoxHtmlForPartCountry;
       }
       String startingCountryIndex = request.getParameter("startingCountryIndex");
       String countryName = request.getParameter("countryName");           
       String [] areStates = null;
       String selectBoxHtmlForState = "";
       if (countryName != null){
           areStates = StateProvBean.getState(countryName);
           if (areStates != null){
		   	   for (int i=0; i < areStates.length; i++) 
			   {
			       String selectBoxHtmlForPartState ="<option value = \"";
			       if(areStates[i] == null){ break; }
			       String states = areStates[i].replaceAll("'","\\\\'");
			       selectBoxHtmlForPartState = selectBoxHtmlForPartState + states + "\">" + states+ "</option>" ;
			       selectBoxHtmlForState = selectBoxHtmlForState + selectBoxHtmlForPartState;
			   }
           }
	}
		
%>	

<%
try {
  String orgEnts[][] = null; 
  //Get resource bundle for displaying text on the page
  CommandContext cmdContextLocale = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
  Locale jLocale = cmdContextLocale.getLocale();
  Hashtable ffmCenterNLS = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("inventory.FFMCenterNLS", jLocale);
  Hashtable orderMgmtNLS = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("order.orderMgmtNLS", jLocale);
  ResourceBundleDataBean bnResourceBundle = new ResourceBundleDataBean();
  bnResourceBundle.setPropertyFileName("Address_" + jLocale );
  com.ibm.commerce.beans.DataBeanManager.activate(bnResourceBundle, request);

  Integer store_id = cmdContextLocale.getStoreId();
  String storeId = store_id.toString(); 
  
  StoreDataBean  storeBean = new StoreDataBean();
  storeBean.setStoreId(storeId);
  com.ibm.commerce.beans.DataBeanManager.activate(storeBean, request);
   
  String  status = request.getParameter("status");
  String  ffcID = request.getParameter("ffmID");
  ffcID = UIUtil.toHTML(ffcID);
       
  Integer langId = cmdContextLocale.getLanguageId();
  String strLangId = langId.toString();
       
  Long orgEntId =  cmdContextLocale.getStore().getMemberIdInEntityType();

  String strAddress1  = "";
  String strAddress2 = "";
  String strAddress3  = "";
  String strCity      = "";
  String strCountry = "";
  String strDescription = "";
  String strDisplayName = "";
  String strName = "";
  String strState  = "";
  String strZipCode = "";
  String strMbrId = "";
  String work = "yes";  
  String strMaxRelease="";
  String strPickDelay=""; 
  String dropShip=""; 
  int numberOfAddresses = 0; 
  

  if (status.equals("change")) {
         
    addressListBean.setFfmCenterId(ffcID);  
    addressListBean.setLanguageId(strLangId);  

    DataBeanManager.activate(addressListBean, request);    
    ffcBean.setCommandContext(cmdContextLocale);
    ffcBean.setDataBeanKeyFulfillmentCenterId(ffcID);
    DataBeanManager.activate(ffcBean, request);
    ffcDescBean.setCommandContext(cmdContextLocale);
    ffcDescBean.setDataBeanKeyFulfillmentCenterId(ffcID);
    ffcDescBean.setDataBeanKeyLanguageId(strLangId);
  
    StAddressDataBean addresses[] = null;
    StAddressDataBean oneAddress;
    addresses = addressListBean.getStAddressList();	
    numberOfAddresses = addresses.length;
	if (numberOfAddresses  > 0){	      	
    
        oneAddress = addresses[0];  // only one row retrieved!!!!!
    
        strAddress1 = UIUtil.toJavaScript(oneAddress.getAddress1()); 
        strAddress2 = UIUtil.toJavaScript(oneAddress.getAddress2());
        strAddress3 = UIUtil.toJavaScript(oneAddress.getAddress3());
        strCity     = UIUtil.toJavaScript(oneAddress.getCity());
        strCountry  = UIUtil.toJavaScript(oneAddress.getCountry());

        strState  = UIUtil.toJavaScript(oneAddress.getState());
        strZipCode = UIUtil.toJavaScript(oneAddress.getZipCode());
        
        boolean isAppendCountryList = true;	
	if (strCountry == null || strCountry.equals("")){
		isAppendCountryList = false;
	}else{
		for(int k =0 ;k < countries.length ; k++)
	       {
				
	           String country = countries[k].getName();     
	           String abbr = countries[k].getAbbr();
	           if (country.equals(strCountry)||abbr.equals(strCountry)){
	           		isAppendCountryList = false;
	           		if (abbr.equals(strCountry)){
           				strCountry = country;
           			}
	           }
	       }
	  }
	  if (isAppendCountryList){
	       String selectBoxHtmlForPartCountry ="<option value = \"";
	       String country = strCountry.replaceAll("'","\\\\'");
	       selectBoxHtmlForPartCountry = selectBoxHtmlForPartCountry + country+ "\">" + country+ "</option>" ;
	       selectBoxHtmlForCountry = selectBoxHtmlForCountry + selectBoxHtmlForPartCountry;
	}
		
	   if (countryName==null){
	   
		   areStates = StateProvBean.getState(strCountry);
		   if (areStates != null){		
			   for (int i=0; i < areStates.length; i++) 
			   {
			       String selectBoxHtmlForPartState ="<option value = \"";
			       if(areStates[i] == null){ break; }
			       String states = areStates[i].replaceAll("'","\\\\'");
			       selectBoxHtmlForPartState = selectBoxHtmlForPartState + states + "\">" + states+ "</option>" ;
			       selectBoxHtmlForState = selectBoxHtmlForState + selectBoxHtmlForPartState;
			   }
		   }
	   }
	    
       if(areStates!=null)
       {              
            boolean isAppendStatesList = true;		
			if (strState == null || strState.equals("")){
				isAppendStatesList = false;
			}else{
			   for(int k =0 ;k < areStates.length ; k++)
		       {
		           String state = areStates[k];
		          
		           if (strState.equals(state)){
		           		isAppendStatesList = false;
		           		break;
		           }
		       }
		    }
		   if (isAppendStatesList){
		       String selectBoxHtmlForPartState ="<option value = \"";
		       String states = strState.replaceAll("'","\\\\'");
		       selectBoxHtmlForPartState = selectBoxHtmlForPartState + states + "\">" + states+ "</option>" ;
               selectBoxHtmlForState = selectBoxHtmlForState + selectBoxHtmlForPartState;
			}
		}
    }

    try{
      DataBeanManager.activate(ffcDescBean, request);
    } catch (Exception e) {
      work = "no";   
    }
    if (work.equals("yes")) {
      strDescription = UIUtil.toJavaScript(ffcDescBean.getDescription());
      strDisplayName = UIUtil.toJavaScript(ffcDescBean.getDisplayName());
    }	       
    strName = UIUtil.toJavaScript(ffcBean.getName());
    strMbrId = UIUtil.toJavaScript(ffcBean.getMemberId());
    strMaxRelease = UIUtil.toJavaScript(ffcBean.getMaxNumPick().toString());
    strPickDelay = UIUtil.toJavaScript(ffcBean.getPickDelayInMin().toString());
    dropShip = UIUtil.toJavaScript(ffcBean.getDropShip());
  }
%>
<HTML>
<HEAD>
  <LINK rel="stylesheet" href="<%= UIUtil.getCSSFile(jLocale) %>" type="text/css">
  <SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
  <SCRIPT SRC="/wcs/javascript/tools/common/validator.js"></SCRIPT>
  <script src="/wcs/javascript/tools/common/FieldEntryUtil.js"></script>
  <script src="/wcs/javascript/tools/inventory/FFCUtil.js"></script>
  <script language="javascript">

  var owner = "<%= orgEntId %>";

  var status = "<%= UIUtil.toJavaScript(status) %>";
  var pageTitle ;
  var address = new FFMCenterAddress();
  var ffmAddress = address;    
  var ffcID = '<%= UIUtil.toJavaScript(ffcID) %>' ;
 
  ffmAddress.address1 = ffmAddress.address1.replace(/\"/g, "&quot;");
  ffmAddress.address2 = ffmAddress.address2.replace(/\"/g, "&quot;"); 
  ffmAddress.address3 = ffmAddress.address3.replace(/\"/g, "&quot;");
  ffmAddress.city = ffmAddress.city.replace(/\"/g, "&quot;");
  ffmAddress.region = ffmAddress.region.replace(/\"/g, "&quot;");
  ffmAddress.country = ffmAddress.country.replace(/\"/g, "&quot;");
  ffmAddress.postalCode = ffmAddress.postalCode.replace(/\"/g, "&quot;");

  function savePanelData(){ 
    var ffmCenterForm       = document.ffcForm;
    var name = trim(ffmCenterForm.ffmCenterName.value) ;
    var displayName =  trim(ffmCenterForm.ffmCenterDisplayName.value); 
    var description =  trim(ffmCenterForm.ffmCenterDescription.value);
    var address1 =    trim(ffmCenterForm.address1.value); 
    var address2 =    trim(ffmCenterForm.address2.value);
    var address3 =   trim(ffmCenterForm.address3.value);
    var city =  trim(ffmCenterForm.city.value);
    var region =   trim(ffmCenterForm.region.value);
    var postalCode =  trim(ffmCenterForm.postalCode.value);
    var country =  trim(ffmCenterForm.country.value);
    var defaultShipOffset = 86400;
    var maxRelease = trim(document.ffcForm.maxRelease.value);
    var pickDelay = trim(document.ffcForm.pickDelay.value);
    var orgEnt ;
    if (status == "change"){
      parent.put("fulfillmentCenterId",'<%= UIUtil.toJavaScript(ffcID) %>' ); 
    }else{
      orgEnt = owner; 
      parent.put("memberId ", orgEnt );  

        if (document.ffcForm.dropShip.checked == true){
          parent.put("dropShip","Y");
        }

    }        
      
    parent.put("name",name ); 
    parent.put("displayName",displayName );
    parent.put("description",description); 
    parent.put("maxNumPick",maxRelease);
    parent.put("pickDelayInMin",pickDelay);
    parent.put("address1",address1 ); 
    parent.put("address2",address2 ); 
    parent.put("address3",address3); 
    parent.put("city",city );
    parent.put("state",region );
    parent.put("zipCode",postalCode ); 
    parent.put("country",country ); 
    parent.put("defaultShipOffset",defaultShipOffset);
   
  }// END savePanelData

  function validatePanelData() {//start validatePanelData    
    if (!validateNumber()){
      return false;
    }
    if (!validateInputLength()){
      return false;
    }
    if (blankValues()){
      return false;       
    } 
      return true;
  }//end  validatePanelData    
  function validateNumber(){//start validateNumber
    if (!wc_validateIntRange(trim(document.ffcForm.maxRelease.value),1,32767)){ 
      alertDialog("<%= UIUtil.toJavaScript((String)ffmCenterNLS.get("maxReleaseWrong")) %>");
      return false;
    }
    if (!wc_validateIntRange(trim(document.ffcForm.pickDelay.value),1,32767)){ 
      alertDialog("<%= UIUtil.toJavaScript((String)ffmCenterNLS.get("pickDelayWrong")) %>"); 
      return false;
    } 
    return true;
  }//end validateNumber
      
  function blankValues(){//start blankValues
    if (trim(document.ffcForm.ffmCenterName.value) == ""){
      document.ffcForm.ffmCenterName.focus();
      valueIsBlank(document.ffcForm.ffmCenterName.name);
      return true;
    }else if (trim(document.ffcForm.ffmCenterDisplayName.value) == ""){
      document.ffcForm.ffmCenterDisplayName.focus();
      valueIsBlank(document.ffcForm.ffmCenterDisplayName.name);
      return true;
    }        
    return false;      
  }  // end blankValues      
      
  function validateInputLength() {//start validateInputLength
    if (!isValidLength(document.ffcForm.ffmCenterName, 254))
      return false;
    if (!isValidLength(document.ffcForm.ffmCenterDisplayName, 80))
      return false;
    if (!isValidLength(document.ffcForm.address1, 50))
      return false;
    if (!isValidLength(document.ffcForm.address2, 50))
      return false;
    if (!isValidLength(document.ffcForm.address3, 50))
      return false;
    if (!isValidLength(document.ffcForm.city, 128))
      return false;
    if (!isValidLength(document.ffcForm.country, 128))
      return false;
    if (!isValidLength(document.ffcForm.region, 128))
      return false;
    if (!isValidLength(document.ffcForm.postalCode, 40))
      return false;
        
      return true;
  }//end validateInputLength
      
  function isValidLength(fieldName, maxLen) {//start isValidLength
    if (fieldName.value != "") {
      if (!isValidUTF8length(fieldName.value, maxLen)) {
        alertDialog("<%= UIUtil.toJavaScript((String)orderMgmtNLS.get("inputFieldMax")) %>");
     //   displayTooLong(fieldName.name);
        fieldName.select();
        return false;
      }
    }
    return true;
  }//end isValidLength
  
  function  displayTooLong(field) {//start displayTooLong

    if (field == "ffmCenterName" ){
      alertDialog("<%= UIUtil.toJavaScript((String)ffmCenterNLS.get("ffmCenterNameTooLong")) %>");
    } else if (field == "ffmCenterDisplayName" ){
      alertDialog("<%= UIUtil.toJavaScript((String)ffmCenterNLS.get("ffmCenterDisplayNameTooLong")) %>");        
    } else  if (field == "address1" ){
      alertDialog("<%= UIUtil.toJavaScript((String)ffmCenterNLS.get("address1TooLong")) %>");      
    } else  if (field == "address2" ){
      alertDialog("<%= UIUtil.toJavaScript((String)ffmCenterNLS.get("address1TooLong")) %>");      
    } else  if (field == "address3" ){
      alertDialog("<%= UIUtil.toJavaScript((String)ffmCenterNLS.get("address1TooLong")) %>");      
    } else  if (field == "city" ){
      alertDialog("<%= UIUtil.toJavaScript((String)ffmCenterNLS.get("cityTooLong")) %>");
    } else  if (field == "country" ){
      alertDialog("<%= UIUtil.toJavaScript((String)ffmCenterNLS.get("countryTooLong")) %>");
    } else  if (field == "region" ){
      alertDialog("<%= UIUtil.toJavaScript((String)ffmCenterNLS.get("regionTooLong")) %>");
    } else   if (field == "postalCode" ){
      alertDialog("<%= UIUtil.toJavaScript((String)ffmCenterNLS.get("postalCodeTooLong")) %>");
    }      
  }// end displayTooLong
      
  function  valueIsBlank(field) {//start valueIsBlank
    if (field == "ffmCenterName" ){
      alertDialog("<%= UIUtil.toJavaScript((String)ffmCenterNLS.get("blankName")) %>");
    } else if (field == "ffmCenterDisplayName" ){
      alertDialog("<%= UIUtil.toJavaScript((String)ffmCenterNLS.get("blankDisplayName")) %>");        
    }      
  }   //end valueIsBlank     
 
  function validateInputLengthOnChange(fieldName, maxLen) {
    isValidLength(fieldName, maxLen);
  }

  function populateFields(){ //start populateFields
    document.ffcForm.ffmCenterName.value = '<%= strName %>';
    document.ffcForm.ffmCenterDisplayName.value = '<%= strDisplayName %>';
    document.ffcForm.ffmCenterDescription.value = '<%= strDescription %>';
    document.ffcForm.maxRelease.value = '<%=strMaxRelease%>';
    document.ffcForm.pickDelay.value = '<%=strPickDelay%>';
    document.ffcForm.address1.value = '<%= strAddress1 %>';
    document.ffcForm.address2.value = '<%= strAddress2 %>';
    document.ffcForm.address3.value = '<%= strAddress3 %>';
    document.ffcForm.city.value = '<%= strCity %>';
    document.ffcForm.region.value = '<%= strState %>';
    document.ffcForm.country.value = '<%= strCountry %>';
    document.ffcForm.postalCode.value = '<%= strZipCode %>';

      <% if (dropShip.equals("Y")){%>
          document.ffcForm.dropShip.checked = true;
      <% } else {%>
          document.ffcForm.dropShip.checked = false;
      <% } %>

    document.ffcForm.dropShip.disabled = true; 
  }//end populateFields
    
  function newCountrySelected()
  {    
    var newIndex = document.ffcForm.country.selectedIndex;
	var countryName = document.ffcForm.country[newIndex].value;  
	
	var addressInfo = new Object;	
	
	addressInfo.ffmCenterName = document.ffcForm.ffmCenterName.value;
	addressInfo.ffmCenterDisplayName = document.ffcForm.ffmCenterDisplayName.value;
	addressInfo.ffmCenterDescription = document.ffcForm.ffmCenterDescription.value;
	addressInfo.maxRelease = document.ffcForm.maxRelease.value;
	addressInfo.pickDelay = document.ffcForm.pickDelay.value;	
	addressInfo.address1 = document.ffcForm.address1.value;
	addressInfo.address2 = document.ffcForm.address2.value;
	addressInfo.address3 = document.ffcForm.address3.value;
	addressInfo.city = document.ffcForm.city.value;	
	addressInfo.postalCode = document.ffcForm.postalCode.value;	
	addressInfo.state = document.ffcForm.region.value;	
	if (document.ffcForm.dropShip.checked == true){
    	addressInfo.dropShip = true;
    }
    
	addressInfo.country = document.ffcForm.country.options[newIndex].value;
	parent.put("addressInfo", addressInfo); 
	    	
	var url = "/webapp/wcs/tools/servlet/FFMCenterDialogView";
	
	var param = new Object();
	if(status == null)
     {
         status = "new";
     }     	
	param.status = status;
	param.countryName = countryName;	
	if(status == "change"){
	    param.ffmID = ffcID;	    
	}   		    
	top.mccmain.submitForm(url,param,"CONTENTS");   	
  }  
    
  function initializeState() 
  {
    var addressInfo = parent.get("addressInfo");
    if (addressInfo != null)
    {      
      document.ffcForm.ffmCenterName.value  = addressInfo.ffmCenterName;
      document.ffcForm.ffmCenterDisplayName.value    = addressInfo.ffmCenterDisplayName;
      document.ffcForm.ffmCenterDescription.value    = addressInfo.ffmCenterDescription;
      document.ffcForm.maxRelease.value   = addressInfo.maxRelease;
      document.ffcForm.pickDelay.value  =  addressInfo.pickDelay ;
      document.ffcForm.address1.value  = addressInfo.address1;
      document.ffcForm.address2.value    = addressInfo.address2;
      document.ffcForm.address3.value    = addressInfo.address3;
      document.ffcForm.city.value   = addressInfo.city;
      document.ffcForm.country.value   = addressInfo.country;
      document.ffcForm.postalCode.value   = addressInfo.postalCode;
      if (addressInfo.dropShip == true) {
      	  document.ffcForm.dropShip.checked = true;
      } else {
	      document.ffcForm.dropShip.checked = false;
      }
      if (status == "change"){
      	  document.ffcForm.dropShip.disabled = true;
      }
     <% if (areStates == null) { %>
		document.ffcForm.region.value  = addressInfo.state;
     <% } else { %>
     	     var selectOne = false;
             for (var i = 0; i < document.ffcForm.region.length; i++) {
             	if (document.ffcForm.region.options[i].value == addressInfo.state) {
             		document.ffcForm.region.options[i].selected = true;
             		selectOne = true;
             		break;
             	}
             }
             if (!selectOne)
             	document.ffcForm.region.options[0].selected = true; 
      <% } %>
             
    }
    
    else if (status == "change"){     
      populateFields();
    }       
    
    parent.setContentFrameLoaded(true);
  }
      
  function cancel () {
    var answer = parent.confirmDialog('<%=UIUtil.toJavaScript((String)ffmCenterNLS.get("standardCancelConfirmation"))%>');
    return answer ;
  }
  
</script>
</HEAD>
<body ONLOAD="initializeState();" class="content">
<form name="ffcForm" method="get" action="">
<INPUT TYPE='hidden' NAME="URL" VALUE=""> 
<INPUT TYPE='hidden' NAME="XML" VALUE="">
<INPUT TYPE='hidden' NAME="customerId" VALUE=""> 
<SCRIPT>
  var stat =  '<%= UIUtil.toJavaScript(status) %>';
  var heading;
  if (stat =='new'){
    heading = '<%=UIUtil.toJavaScript((String)ffmCenterNLS.get("ffmCenterNewTitle"))%>' ;
  }else if (stat == 'change'){
    heading = '<%=UIUtil.toJavaScript((String)ffmCenterNLS.get("ffmCenterChangeTitle"))%>' ;
  }
</SCRIPT>
<h1><SCRIPT>document.writeln(heading);</SCRIPT></h1>
<table>

<TR>
  <TD> 
   <LABEL for="ffmCenterName"><%= UIUtil.toHTML((String)ffmCenterNLS.get("ffmCenterName")) %> <%= UIUtil.toHTML((String)ffmCenterNLS.get("required")) %></LABEL><BR>
   <INPUT size="80" type="text" name="ffmCenterName" id="ffmCenterName" maxlength=254><BR>
	  </TD>	  		
</TR>   
   
<TR>
      <TD>   
		<LABEL for="ffmCenterDisplayName"><%= UIUtil.toHTML((String)ffmCenterNLS.get("ffmCenterDisplayName")) %> <%= UIUtil.toHTML((String)ffmCenterNLS.get("required")) %></LABEL><BR>
	  	<INPUT size="80" type="text" name="ffmCenterDisplayName" id="ffmCenterDisplayName" maxlength=80><BR>
	  </TD>	  		
</TR>	  	
	  	
<TR>
      <TD>	  	
		<LABEL for="ffmCenterDescription"><%= UIUtil.toHTML((String)ffmCenterNLS.get("ffmCenterDescription")) %></LABEL> <BR>
	 	<TEXTAREA NAME="ffmCenterDescription" id="ffmCenterDescription" rows="3" cols="80" onKeyDown="limitTextArea(ffcForm.ffmCenterDescription,32700);" onKeyUp="limitTextArea(ffcForm.ffmCenterDescription,32700);"></TEXTAREA><BR>
	 </TD>	  		
</TR>
	 	
<TR>
      <TD>	 	
		<LABEL for="maxRelease"><%= UIUtil.toHTML((String)ffmCenterNLS.get("maxReleasesPerPickBatch")) %>  <%= UIUtil.toHTML((String)ffmCenterNLS.get("required")) %></LABEL><BR>
  		<INPUT size="30" type="text" name="maxRelease" id="maxRelease" maxlength=254><BR>
	  </TD>	  		
</TR>

<TR>
      <TD>  		
		<LABEL for="pickDelay"><%= UIUtil.toHTML((String)ffmCenterNLS.get("pickDelay")) %>  <%= UIUtil.toHTML((String)ffmCenterNLS.get("required")) %></LABEL><BR>
  		<INPUT size="30" type="text" name="pickDelay" id="pickDelay" maxlength=254><BR>
	  </TD>	  		
</TR>	  

<TR>
      <TD>  		
  <INPUT type="checkbox" name="dropShip" value="Yes" id="dropShip1"/><label for="dropShip1"><%= UIUtil.toHTML((String)ffmCenterNLS.get("dropShip")) %></label>
	  </TD>	  		
</TR>	  

  		
<script>
     
<%
  String typeOfAddress = "ffmAddress";
  Hashtable addrFormats = (Hashtable)ResourceDirectory.lookup("inventory.addressFormats");
  Hashtable localeAddrFormat = (Hashtable)XMLUtil.get(addrFormats, "addressFormats."+ jLocale.toString());
  if (localeAddrFormat == null){
    localeAddrFormat = (Hashtable)XMLUtil.get(addrFormats, "addressFormats.default");
  }
  String addressLine = "";
  for (int i=0;i<localeAddrFormat.size();i++) {
    addressLine = (String)XMLUtil.get(localeAddrFormat,"line"+ i +".elements");
    String[] addressFields = Util.tokenize(addressLine, ",");
%>
    var counter = 0;
<%
    for (int j=0; j<addressFields.length; j++) {
      if ( (!addressFields[j].equals("space")) && (!addressFields[j].equals("comma")) &&
        (!addressFields[j].equals("title"))  ) {
           //check if it is mandatory
%>
           if ( "<%= addressFields[j] %>" == "address1" ) {
             document.writeln('<TR><TD  valign="top" align="left" colspan=2>');
             document.writeln('<%= UIUtil.toJavaScript((String)ffmCenterNLS.get("streetAddress")) %> <BR>');
             document.writeln('<input type="text" name="<%= addressFields[j] %>" id="<%= addressFields[j] %>" value="" size=50 maxlength=50 onChange="validateInputLengthOnChange(document.ffcForm.<%= addressFields[j] %>, 50);"><BR>');
           } else if ( "<%= addressFields[j] %>" == "address2" ) {
             document.writeln('<input type="text" name="<%= addressFields[j] %>" id="<%= addressFields[j] %>" value="" size=50 maxlength=50 onChange="validateInputLengthOnChange(document.ffcForm.<%= addressFields[j] %>, 50);"><BR>');
           } else if ( "<%= addressFields[j] %>" == "address3" ) {
             document.writeln('<input type="text" name="<%= addressFields[j] %>" id="<%= addressFields[j] %>" value="" size=50 maxlength=50 onChange="validateInputLengthOnChange(document.ffcForm.<%= addressFields[j] %>, 50);"><BR>');
             document.writeln('</TD></TR>');
           } else if ( "<%= addressFields[j] %>" == "postalCode" ) {
             document.writeln('<TD  valign="top" align="left">');
             document.writeln('<%= UIUtil.toJavaScript((String)ffmCenterNLS.get(addressFields[j])) %> <BR>');
             document.writeln('<input type="text" name="<%= addressFields[j] %>" id="<%= addressFields[j] %>" value="" size=35 maxlength=40 onChange="validateInputLengthOnChange(document.ffcForm.<%= addressFields[j] %>, 40);">');              
             document.writeln('</TD></TR>');
           }else if ( "<%= addressFields[j] %>" == "country" ) {                           
	           document.writeln('<TD  valign="top" align="left">');
	           document.writeln('<label for="<%= addressFields[j] %>"><%= UIUtil.toJavaScript((String)ffmCenterNLS.get(addressFields[j])) %></label> <BR>');
	           document.writeln('<select name="<%= addressFields[j] %>" id="<%= addressFields[j] %>" onChange="newCountrySelected()" class="selectWidth" >');
	           document.writeln('<%=selectBoxHtmlForCountry%>');                                                
	           document.writeln('</select></TD></TR>');                           
	        } else if ( "<%= addressFields[j] %>" == "region" ) {
	        <% 
	           if (areStates!= null){ 
	        %>                         
	           document.writeln('<TD  valign="top" align="left">');
	           document.writeln('<label for="<%= addressFields[j] %>"><%= UIUtil.toJavaScript((String)ffmCenterNLS.get(addressFields[j])) %></label> <BR>');
	           document.writeln('<select name="<%= addressFields[j] %>" id="<%= addressFields[j] %>" class="selectWidth" >');
	        
	           document.writeln('<%=selectBoxHtmlForState%>');                                                
	           document.writeln('</select></TD></TR>');
	        <% } 
	        else {
	        %> 
	           document.writeln('<TD  valign="top" align="left">');
	           document.writeln('<label for="<%= addressFields[j] %>"><%= UIUtil.toJavaScript((String)ffmCenterNLS.get(addressFields[j])) %></label> <BR>');
	           document.writeln('<input type="text" name="<%= addressFields[j] %>" id="<%= addressFields[j] %>" value="" size=35 maxlength=128 onChange="validateInputLengthOnChange(document.ffcForm.<%= addressFields[j] %>, 128);">');              
	           document.writeln('</TD></TR>');
	        <%
	        }
	        %>                                           
        }  
           else {
             document.writeln('<TD  valign="top" align="left">');
             document.writeln('<%= UIUtil.toJavaScript((String)ffmCenterNLS.get(addressFields[j])) %> <BR>');
             document.writeln('<input type="text" name="<%= addressFields[j] %>" id="<%= addressFields[j] %>" value="" size=35 maxlength=128 onChange="validateInputLengthOnChange(document.ffcForm.<%= addressFields[j] %>, 128);">');              
             document.writeln('</TD></TR>');
           }
<%
      } //end if
    } //end for
  } //end for
%>
     
</script>
</table>
</form>  

<%
} catch (Exception e) {
   System.out.println ("Exception ");
   e.printStackTrace();
   out.println(e);
}
%>
</body>
</HTML>
