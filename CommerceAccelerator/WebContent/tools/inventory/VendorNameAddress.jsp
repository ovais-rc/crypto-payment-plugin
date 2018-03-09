

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">

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
<%@ page language="java" import="java.util.*" %>
<%@ page import="com.ibm.commerce.command.*" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.tools.xml.*" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.user.objects.*" %>
<%@ page import="com.ibm.commerce.beans.*" %>
<%@ page import="com.ibm.commerce.inventory.beans.VendorInformationDataBean" %>
<%@ page import="com.ibm.commerce.server.*" %>
<%@ page import="com.ibm.commerce.common.beans.*" %>
<%@ page import="com.ibm.commerce.usermanagement.commands.ECUserConstants" %>
<%@ page import="com.ibm.commerce.user.beans.*" %>
<%@ page import="com.ibm.commerce.datatype.TypedProperty" %>
<%@ page import="com.ibm.commerce.tools.common.ui.taglibs.*" %>
<%@ page import="com.ibm.commerce.server.JSPHelper" %>
<%@include file="../common/common.jsp" %>
<%@ page import="com.ibm.commerce.beans.DataBeanManager,
	com.ibm.commerce.tools.segmentation.SegmentCountriesDataBean" %>

<jsp:useBean id="vendorInformationList" scope="request" class="com.ibm.commerce.inventory.beans.VendorInformationListDataBean">
</jsp:useBean>

<jsp:useBean class="com.ibm.commerce.tools.taxation.databeans.CountryBean" id="CountryBean" scope="request"> 
<% com.ibm.commerce.beans.DataBeanManager.activate(CountryBean, request); %></jsp:useBean>

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

	//Get resource bundle for displaying text on the page
	
	CommandContext cmdContextLocale = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
	Locale jLocale = cmdContextLocale.getLocale();
	Hashtable orderMgmtNLS = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("order.orderMgmtNLS", jLocale);
        Hashtable vendorPurchaseListNLS = (Hashtable)ResourceDirectory.lookup("inventory.VendorPurchaseNLS", jLocale  );
        
       
        
        
	//OptoolsRegisterDataBean registerDataBean = new OptoolsRegisterDataBean();
	//UIUtil convert = null;
     
	ResourceBundleDataBean bnResourceBundle = new ResourceBundleDataBean();
   	bnResourceBundle.setPropertyFileName("Address_" + jLocale);
   	com.ibm.commerce.beans.DataBeanManager.activate(bnResourceBundle, request);
        
        Integer langId = cmdContextLocale.getLanguageId();
        String strLangId = langId.toString(); 
        
        String strVendorId = request.getParameter("vendorId");
      //String strVendorName = request.getParameter("vendorName");
      //String strVendorDescription = UIUtil.toJavaScript(request.getParameter("vendorDescription"));
      	
      	String strStatus = request.getParameter("status");
      	
      	String strAddress1 = "";
	String strAddress2 = ""; 
	String strAddress3 = "";
	String strCity = "";
	String strState = "";
	String strZipCode = "";
	String strCountry = "";
	String strPersonTitle = "";
	String strFirstname = "";
	String strMiddlename = "";
	String strLastname = "";
	String strBusinessTitle = "";
	String strPhone1 = "";
	String strEmail1 = "";
	String strFax1 = "";
	String strVendorName = "";
      	String strVendorDescription = "";
      	
      	//if strStatus == "change"{
      	
      	if (strStatus.equals("change")) {
        
        VendorInformationDataBean vendorPOs[] = null;
      	
      	vendorInformationList.setDataBeanKeyVendorId(strVendorId);
      	vendorInformationList.setDataBeanKeyLanguageId(strLangId);
      	DataBeanManager.activate(vendorInformationList, request);
      	
      	vendorPOs = vendorInformationList.getVendorInformationList();
      
        VendorInformationDataBean vendorPO;
        vendorPO = vendorPOs[0];  // only one row retrieved!!!!!
        strAddress1 = UIUtil.toJavaScript(vendorPO.getDataBeanKeyAddress1());   
      	strAddress2 = UIUtil.toJavaScript(vendorPO.getDataBeanKeyAddress2());
	strAddress3 = UIUtil.toJavaScript(vendorPO.getDataBeanKeyAddress3());
	strCity = UIUtil.toJavaScript(vendorPO.getDataBeanKeyCity());
	strState = UIUtil.toJavaScript(vendorPO.getDataBeanKeyState());
	strZipCode = UIUtil.toJavaScript(vendorPO.getDataBeanKeyZipCode());
	strCountry = UIUtil.toJavaScript(vendorPO.getDataBeanKeyCountry());
	strPersonTitle = UIUtil.toJavaScript(vendorPO.getDataBeanKeyPersonTitle());
	strFirstname = UIUtil.toJavaScript(vendorPO.getDataBeanKeyFirstname());
	strMiddlename = UIUtil.toJavaScript(vendorPO.getDataBeanKeyMiddlename());
	strLastname = UIUtil.toJavaScript(vendorPO.getDataBeanKeyLastname());
	strBusinessTitle = UIUtil.toJavaScript(vendorPO.getDataBeanKeyBusinessTitle());
	strPhone1 = UIUtil.toJavaScript(vendorPO.getDataBeanKeyPhone1());
	strEmail1 = UIUtil.toJavaScript(vendorPO.getDataBeanKeyEmail1());
	strFax1 = UIUtil.toJavaScript(vendorPO.getDataBeanKeyFax1());
	strVendorName = UIUtil.toJavaScript(vendorPO.getDataBeanKeyVendorName());
	strVendorDescription = UIUtil.toJavaScript(vendorPO.getDataBeanKeyDescription());
	
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
%>





<HTML>
<HEAD>
<LINK rel="stylesheet" href="<%= UIUtil.getCSSFile(jLocale) %>" type="text/css">
   
<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
<script src="/wcs/javascript/tools/common/FieldEntryUtil.js"></script>
<script src="/wcs/javascript/tools/inventory/VendorUtil.js"></script>
<script language="javascript">


function trimName(){
document.billingAddress.VENDORNAME.value=trim(document.billingAddress.VENDORNAME.value);
}

function trimDescription(){
document.billingAddress.VENDORDESCRIPTION.value=trim(document.billingAddress.VENDORDESCRIPTION.value);
}

var status = "<%=UIUtil.toJavaScript(strStatus)%>";

var back = "";
back = top.getData("back");


if (status == "change") {
var vendorId = "<%=UIUtil.toJavaScript(strVendorId)%>";  

}
var address = new Address();
	 
var vendorAddress = address;      
	
vendorAddress.address1 = vendorAddress.address1.replace(/\"/g, "&quot;");
vendorAddress.address2 = vendorAddress.address2.replace(/\"/g, "&quot;");
vendorAddress.address3 = vendorAddress.address3.replace(/\"/g, "&quot;");
vendorAddress.city = vendorAddress.city.replace(/\"/g, "&quot;");
vendorAddress.region = vendorAddress.region.replace(/\"/g, "&quot;");
vendorAddress.country = vendorAddress.country.replace(/\"/g, "&quot;");
vendorAddress.postalCode = vendorAddress.postalCode.replace(/\"/g, "&quot;");


      /****************************************************************************
      * Save all required state information.
      * return - always returns TRUE
      ****************************************************************************/
 function savePanelData(){ 
            
            
               var vendorForm       = document.billingAddress;
               // Save billing address
	      
               
               parent.put("address", address);
               
               parent.addURLParameter("authToken", "${authToken}"); 
               
               var vendorName = new Array();
               vendorName.name = vendorForm.VENDORNAME.value ;
               vendorName.description = vendorForm.VENDORDESCRIPTION.value; 
               top.saveData(vendorId, "vendorId");
               top.saveData(vendorName.name, "vName");
               top.saveData(vendorName.description, "vDescr");
               top.saveData(vendorForm.address1.value, "address1");
               top.saveData(vendorForm.address2.value, "address2");
               top.saveData(vendorForm.address3.value, "address3");
               top.saveData(vendorForm.city.value, "city");
               top.saveData(vendorForm.region.value, "region");
               top.saveData(vendorForm.country.value, "country");
               top.saveData(vendorForm.postalCode.value, "postalCode");
               
               parent.put("vendorName", trim(top.getData("vName")));
	       parent.put("description", top.getData("vDescr"));               
               parent.put("address1", vendorForm.address1.value);
	       parent.put("address2", vendorForm.address2.value);
	       parent.put("address3", vendorForm.address3.value);
	       parent.put("city", vendorForm.city.value);
	       parent.put("state", vendorForm.region.value);
	       parent.put("country", vendorForm.country.value);
	       parent.put("zipCode", vendorForm.postalCode.value);
	       	       
	       	     
               
                  if (status == "change") {
                 
               parent.put("vendorName", trim(top.getData("vName")));
               parent.put("vendorId", top.getData("vendorId"));
	       parent.put("description", top.getData("vDescr"));
	       parent.put("address1", top.getData("address1"));
	       parent.put("address2", top.getData("address2"));
	       parent.put("address3", top.getData("address3"));
	       parent.put("city", top.getData("city"));
	       parent.put("state", top.getData("region"));
	       parent.put("country", top.getData("country"));
	       parent.put("zipCode", top.getData("postalCode"));
	       
	       parent.put("personTitle", top.getData("personTitle"));
	       parent.put("firstName",top.getData("firstName"));
	       parent.put("middleName",top.getData("middleName"));
	       parent.put("lastName", top.getData("lastName"));
	       parent.put("businessTitle", top.getData("businessTitle"));
	       parent.put("phone1", top.getData("phone1"));
	       parent.put("email1", top.getData("email1"));
               parent.put("fax1", top.getData("fax1"));
              
               if (back == "back") {
                 
		  top.saveData("back", "back");
		  top.saveData(top.getData("personTitle"), "personTitle");
		  top.saveData(top.getData("firstName"), "firstName");
		  top.saveData(top.getData("middleName"), "middleName");
		  top.saveData(top.getData("lastName"), "lastName");
		  top.saveData(top.getData("businessTitle"), "businessTitle");
		  top.saveData(top.getData("phone1"), "phone1");
		  top.saveData(top.getData("email1"), "email1");
		  top.saveData(top.getData("fax1"), "fax1");
		 
		
		 
		  }else{
		 
		  
		  top.saveData("back", "back");
		  top.saveData(vendorName.name, "vName");
		  top.saveData(vendorName.description, "vDescr");
		  top.saveData(vendorForm.address1.value, "address1");
		  top.saveData(vendorForm.address2.value, "address2");
		  top.saveData(vendorForm.address3.value, "address3");
		  top.saveData(vendorForm.city.value, "city");
		  top.saveData(vendorForm.region.value, "region");
		  top.saveData(vendorForm.country.value, "country");
                  top.saveData(vendorForm.postalCode.value, "postalCode");
		  top.saveData('<%=strPersonTitle%>', "personTitle");
		  top.saveData('<%=strFirstname%>', "firstName");
		  top.saveData('<%=strMiddlename%>', "middleName");
		  top.saveData('<%=strLastname%>', "lastName");
		  top.saveData('<%=strBusinessTitle%>', "businessTitle");
		  top.saveData('<%=strPhone1%>', "phone1");
		  top.saveData('<%=strEmail1%>', "email1");
                  top.saveData('<%=strFax1%>', "fax1");
               } 
              }
           }// END savePanelData     

 function validatePanelData() {  

              if (!validateInputLength()){
                return false;
              }
              if (blankValues()){
                return false;       
              } 
               return true;
               
      }


      function blankValues(){
              if (document.billingAddress.VENDORNAME.value == ""){
              valueIsBlank(document.billingAddress.VENDORNAME.name);
              return true;
             }else if (document.billingAddress.VENDORDESCRIPTION.value == ""){
               valueIsBlank(document.billingAddress.VENDORDESCRIPTION.name);
                return true;   
             }        
                   
             return false;      
      }        
   
   function validateInputLength() {
           
            if (!isValidLength(document.billingAddress.VENDORNAME, 30))
              return false;
            if (!isValidLength(document.billingAddress.VENDORDESCRIPTION, 254))
              return false;
            if (!isValidLength(document.billingAddress.address1, 50))
	      return false;
	    if (!isValidLength(document.billingAddress.address2, 50))
              return false;
	    if (!isValidLength(document.billingAddress.address3, 50))
	      return false;
	    if (!isValidLength(document.billingAddress.city, 128))
	      return false;
	    if (!isValidLength(document.billingAddress.country, 128))
	      return false;
	    if (!isValidLength(document.billingAddress.region, 128))
	      return false;
	    if (!isValidLength(document.billingAddress.postalCode, 40))
              return false;
           
            
               return true;
      }
   
    function isValidLength(fieldName, maxLen) {
            if (fieldName.value != "") {
               if (!isValidUTF8length(fieldName.value, maxLen)) {
                  alertDialog("<%= UIUtil.toJavaScript((String)orderMgmtNLS.get("inputFieldMax")) %>");
                  fieldName.select();
                  return false;
               }
            }
         return true;
         }
    
    function  valueIsBlank(field) {
             if (field == "VENDORNAME" ){
               alertDialog("<%= UIUtil.toJavaScript((String)vendorPurchaseListNLS.get("blankField")) %>");
               document.billingAddress.VENDORNAME.focus();
                     
             } else if (field == "VENDORDESCRIPTION" ){
                alertDialog("<%= UIUtil.toJavaScript((String)vendorPurchaseListNLS.get("blankField")) %>");        
                document.billingAddress.VENDORDESCRIPTION.focus();     
                         
             }      
                
                
        }        
    
         function validateInputLengthOnChange(fieldName, maxLen) {
            isValidLength(fieldName, maxLen);
         }
   
     function newCountrySelected()
     {
	    var countrySelected = document.billingAddress.country.selectedIndex;
		var countryName = document.billingAddress.country.options[countrySelected].value;
		
		var addressInfo = new Object;		    
		addressInfo.VENDORNAME = document.billingAddress.VENDORNAME.value;		
		addressInfo.VENDORDESCRIPTION = billingAddress.VENDORDESCRIPTION.value;			
		addressInfo.address1 = document.billingAddress.address1.value;
		addressInfo.address2 = document.billingAddress.address2.value;
		addressInfo.address3 = document.billingAddress.address3.value;
		addressInfo.city = document.billingAddress.city.value;	
		addressInfo.region = document.billingAddress.region.value;		
		addressInfo.postalCode = document.billingAddress.postalCode.value;		
		addressInfo.country = document.billingAddress.country.options[countrySelected].value;
		
		parent.put("addressInfo", addressInfo);
		
		var url = "/webapp/wcs/tools/servlet/VendorNameAddressView";
		
		if(status == null)
	     {
	         status = "new";
	     }     
		var param = new Object();
		param.status = status;
	    param.vendorId = vendorId;
		param.countryName = countryName;
		top.mccmain.submitForm(url,param,"CONTENTS");   
     } 
   
   function initializeState() {
        var addressInfo = parent.get("addressInfo");
       if (status == "new"||status == "change") {          
         if (top.getData("description") == "description"){
         document.billingAddress.VENDORDESCRIPTION.focus();
         }
						
         if (top.getData("name") == "name"){
	 document.billingAddress.VENDORNAME.focus();
         }
         if (back == "back") {          
          document.billingAddress.VENDORNAME.value = top.getData("vName");
          document.billingAddress.VENDORDESCRIPTION.value = top.getData("vDescr");
          document.billingAddress.address1.value = top.getData("address1");
          document.billingAddress.address2.value = top.getData("address2");
          document.billingAddress.address3.value = top.getData("address3");
          document.billingAddress.city.value = top.getData("city");
          document.billingAddress.region.value = top.getData("region");
          document.billingAddress.country.value = top.getData("country");
          document.billingAddress.postalCode.value = top.getData("postalCode");
          
          }else if (addressInfo != null)
          {          
	      document.billingAddress.VENDORNAME.value  = addressInfo.VENDORNAME;
	      document.billingAddress.VENDORDESCRIPTION.value    = addressInfo.VENDORDESCRIPTION;
	      document.billingAddress.address1.value    = addressInfo.address1;	      
	      document.billingAddress.address2.value    = addressInfo.address2;
	      document.billingAddress.address3.value    = addressInfo.address3;
	      document.billingAddress.city.value   = addressInfo.city;
	      document.billingAddress.country.value   = addressInfo.country;
	      document.billingAddress.postalCode.value  = addressInfo.postalCode;
			      
	     <% if (areStates == null) { %>
			document.billingAddress.region.value  = addressInfo.region;

	     <% } else { %>
	     	     var selectOne = false;
	             for (var i = 0; i < document.billingAddress.region.length; i++) {
	             	if (document.billingAddress.region.options[i].value == addressInfo.region) {

	             		document.billingAddress.region.options[i].selected = true;
	             		selectOne = true;
	             		break;
	             	}
	             }
	             if (!selectOne)
	             	document.billingAddress.region.options[0].selected = true; 
	      <% } %>
             
          }
          
          else {
          document.billingAddress.VENDORNAME.value = trim('<%=strVendorName%>');
          if (document.billingAddress.VENDORNAME.value == "null") {
	    document.billingAddress.VENDORNAME.value = "";
	  }
	  
	  document.billingAddress.VENDORDESCRIPTION.value = trim('<%=strVendorDescription%>');
	  if (document.billingAddress.VENDORDESCRIPTION.value == "null") {
	    document.billingAddress.VENDORDESCRIPTION.value = "";
          }
          
          document.billingAddress.address1.value = '<%=strAddress1%>';
          if (document.billingAddress.address1.value == "null") {
	    document.billingAddress.address1.value = "";
          }
          
          document.billingAddress.address2.value = '<%=strAddress2%>';
          if (document.billingAddress.address2.value == "null") {
	    document.billingAddress.address2.value = "";
          }
          
          document.billingAddress.address3.value = '<%=strAddress3%>';
          if (document.billingAddress.address3.value == "null") {
	    document.billingAddress.address3.value = "";
          }
          
          document.billingAddress.city.value = '<%=strCity%>';
          if (document.billingAddress.city.value == "null") {
	  	    document.billingAddress.city.value = "";
          }
          
          document.billingAddress.region.value = '<%=strState%>';
          if (document.billingAddress.region.value == "null") {
	    document.billingAddress.region.value = "";
          }
          
          document.billingAddress.country.value = '<%=strCountry%>';
          if (document.billingAddress.country.value == "null") {
	    document.billingAddress.country.value = "";
          }
          
          document.billingAddress.postalCode.value = '<%=strZipCode%>';
          if (document.billingAddress.postalCode.value == "null") {
	   document.billingAddress.postalCode.value = "";
          }
          }        
                            
        }
        
        parent.setContentFrameLoaded(true);
        
   }

   
   </script>
   
<META name="GENERATOR" content="IBM WebSphere Studio">
</HEAD>
<body ONLOAD="initializeState();" class="content">

<script language="javascript"><!-- alert("VendorNameAddress.jsp"); --></script> 

<form name="billingAddress" method="post" action="">
	<INPUT TYPE='hidden' NAME="URL" VALUE=""> 
	<INPUT TYPE='hidden' NAME="XML" VALUE="">
	<INPUT TYPE='hidden' NAME="customerId" VALUE="">
     <h1><%= vendorPurchaseListNLS.get("vendorHeaderHeading") %></h1>
     
     <table border=0 cellspacing=0 cellpadding=0>
       <TR>
         <TD>
           <LABEL for="VENDORNAME"><%= UIUtil.toHTML((String)vendorPurchaseListNLS.get("vendorName")) %></LABEL>
         </TD>
       </TR>
       <TR>
         <TD>
           <INPUT TYPE = TEXT VALUE = "" NAME=VENDORNAME ID="VENDORNAME" SIZE=30 maxlength=30 onBlur="trimName()"/>
         </TD>
       </TR>
       <TR>
         <TD>
           <LABEL for="VENDORDESCRIPTION"><%= UIUtil.toHTML((String)vendorPurchaseListNLS.get("vendorDescription")) %></LABEL>
         </TD>
       </TR>
       <TR>
         <TD>
           <INPUT TYPE = TEXT VALUE = "" NAME=VENDORDESCRIPTION ID="VENDORDESCRIPTION" SIZE=50 maxlength=254 onBlur="trimDescription()"/>
         </TD>
         
            
       </TR>
     
     <script>
     <%
     String typeOfAddress = "vendorAddress";
     Hashtable addrFormats = (Hashtable)ResourceDirectory.lookup("inventory.vendorAddressFormats");
     Hashtable localeAddrFormat = (Hashtable)XMLUtil.get(addrFormats, "addressFormats."+ jLocale.toString());

     if (localeAddrFormat == null) 
     {
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
                          (!addressFields[j].equals("title")) ) {
                        //check if it is mandatory
                       
                        %>
                        
                        if ( "<%= addressFields[j] %>" == "address1" ) {
                                   
                           document.writeln('<TR><TD  valign="top" align="left" colspan=2>');
                           document.writeln('<label for="<%= addressFields[j] %>"><%= UIUtil.toJavaScript((String)vendorPurchaseListNLS.get("address")) %></label><BR>');
                           document.writeln('<input type="text" name="<%= addressFields[j] %>" id="<%= addressFields[j] %>" value="" size=50 maxlength=50 onChange="validateInputLengthOnChange(document.billingAddress.<%= addressFields[j] %>, 50);"><BR>');
                        } else if ( "<%= addressFields[j] %>" == "address2" ) {
                                 
                           document.writeln('<input type="text" name="<%= addressFields[j] %>" id="<%= addressFields[j] %>" value="" size=50 maxlength=50 onChange="validateInputLengthOnChange(document.billingAddress.<%= addressFields[j] %>, 50);"><BR>');
                   
                        } else if ( "<%= addressFields[j] %>" == "address3" ) {
                                 
                           document.writeln('<input type="text" name="<%= addressFields[j] %>" id="<%= addressFields[j] %>" value="" size=50 maxlength=50 onChange="validateInputLengthOnChange(document.billingAddress.<%= addressFields[j] %>, 50);"><BR>');
                           document.writeln('</TD></TR>');
                        } else if ( "<%= addressFields[j] %>" == "postalCode" ) {
                                 
                           document.writeln('<TD  valign="top" align="left">');
                           document.writeln('<label for="<%= addressFields[j] %>"><%= UIUtil.toJavaScript((String)vendorPurchaseListNLS.get(addressFields[j])) %></label> <BR>');
                           document.writeln('<input type="text" name="<%= addressFields[j] %>" id="<%= addressFields[j] %>" value="" size=35 maxlength=40 onChange="validateInputLengthOnChange(document.billingAddress.<%= addressFields[j] %>, 40);">');              
                           document.writeln('</TD></TR>');
                        }else if ( "<%= addressFields[j] %>" == "country" ) {                           
                           document.writeln('<TD  valign="top" align="left">');
                           document.writeln('<label for="<%= addressFields[j] %>"><%= UIUtil.toJavaScript((String)vendorPurchaseListNLS.get(addressFields[j])) %></label> <BR>');
                           document.writeln('<select name="<%= addressFields[j] %>" id="<%= addressFields[j] %>" onChange="newCountrySelected()" class="selectWidth" >');
                           document.writeln('<%=selectBoxHtmlForCountry%>');                                                
                           document.writeln('</select></TD></TR>');                           
                        } else if ( "<%= addressFields[j] %>" == "region" ) {
                        <% 
                           if (areStates!= null){ 
                        %>                         
                           document.writeln('<TD  valign="top" align="left">');
                           document.writeln('<label for="<%= addressFields[j] %>"><%= UIUtil.toJavaScript((String)vendorPurchaseListNLS.get(addressFields[j])) %></label> <BR>');
                           document.writeln('<select name="<%= addressFields[j] %>" id="<%= addressFields[j] %>" class="selectWidth" >');
                        
                           document.writeln('<%=selectBoxHtmlForState%>');                                                
                           document.writeln('</select></TD></TR>');
                        <% } 
                        else {
                        %> 
                           document.writeln('<TD  valign="top" align="left">');
                           document.writeln('<label for="<%= addressFields[j] %>"><%= UIUtil.toJavaScript((String)vendorPurchaseListNLS.get(addressFields[j])) %></label> <BR>');
                           document.writeln('<input type="text" name="<%= addressFields[j] %>" id="<%= addressFields[j] %>" value="" size=35 maxlength=128 onChange="validateInputLengthOnChange(document.billingAddress.<%= addressFields[j] %>, 128);">');              
                           document.writeln('</TD></TR>');
                        <%
                        }
                        %>                                                           
                        }  
                        else {
                           document.writeln('<TD  valign="top" align="left">');
                           document.writeln('<label for="<%= addressFields[j] %>"><%= UIUtil.toJavaScript((String)vendorPurchaseListNLS.get(addressFields[j])) %></label> <BR>');
                           document.writeln('<input type="text" name="<%= addressFields[j] %>" id="<%= addressFields[j] %>" value="" size=35 maxlength=128 onChange="validateInputLengthOnChange(document.billingAddress.<%= addressFields[j] %>, 128);">');              
                           document.writeln('</TD></TR>');
                        }
                        
                        if ( (counter%2 != 0) && ("<%= addressFields[j] %>" != "address1") && ("<%= addressFields[j] %>" != "address2") && ("<%= addressFields[j] %>" != "email") && ("<%= addressFields[j] %>" != "phoneNumber") )
                           document.writeln('</TR>');
                           
                        counter++;
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
