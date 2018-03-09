<!--      
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2001, 2002
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
-->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">

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
<%@ page language="java" import="java.util.*" %>
<%@ page import="com.ibm.commerce.command.*" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.tools.xml.*" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.user.objects.*" %>
<%@ page import="com.ibm.commerce.beans.*" %>
<%@ page import="com.ibm.commerce.server.*" %>
<%@ page import="com.ibm.commerce.common.beans.*" %>
<%@ page import="com.ibm.commerce.usermanagement.commands.ECUserConstants" %>
<%@ page import="com.ibm.commerce.user.beans.*" %>
<%@ page import="com.ibm.commerce.datatype.TypedProperty" %>
<%@ page import="com.ibm.commerce.tools.common.ui.taglibs.*" %>
<%@ page import="com.ibm.commerce.server.JSPHelper" %>

<%@ page import="com.ibm.commerce.user.objects.*"   %>
<%@ page import="com.ibm.commerce.utils.TimestampHelper" %>
<%@include file="../common/common.jsp" %>




<%
try {
    //Get resource bundle for displaying text on the page
    	CommandContext cmdContextLocale = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
    	Locale jLocale = cmdContextLocale.getLocale();
    	Hashtable orderMgmtNLS = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("order.orderMgmtNLS", jLocale);
        Hashtable VendorPurchaseNLS = (Hashtable)ResourceDirectory.lookup("inventory.VendorPurchaseNLS", jLocale  );
            
    	//OptoolsRegisterDataBean registerDataBean = new OptoolsRegisterDataBean();
    	//UIUtil convert = null;
         
    	
       	ResourceBundleDataBean bnResourceBundle = new ResourceBundleDataBean();
       	bnResourceBundle.setPropertyFileName("Address_" + jLocale);
       	com.ibm.commerce.beans.DataBeanManager.activate(bnResourceBundle, request);
        
        String strStatus = request.getParameter("status");
%>

<HTML>
<HEAD>
<LINK rel="stylesheet" href="<%= UIUtil.getCSSFile(jLocale) %>" type="text/css">

   	<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
   	<script src="/wcs/javascript/tools/common/FieldEntryUtil.js"></script>
   	<script src="/wcs/javascript/tools/inventory/VendorUtil.js"></script>
   	<script language="javascript">
        
        var status = "<%=UIUtil.toJavaScript(strStatus)%>";
        var back = "";
	back = top.getData("back");

        var address = new Address();
	var contactInformation = address;      
	          
	      
	contactInformation.title = contactInformation.title.replace(/\"/g, "&quot;");
	contactInformation.firstName = contactInformation.firstName.replace(/\"/g, "&quot;");
	contactInformation.middleName = contactInformation.middleName.replace(/\"/g, "&quot;");
	contactInformation.lastName = contactInformation.lastName.replace(/\"/g, "&quot;");
	contactInformation.position = contactInformation.position.replace(/\"/g, "&quot;");
	contactInformation.phoneNumber = contactInformation.phoneNumber.replace(/\"/g, "&quot;");
	contactInformation.email = contactInformation.email.replace(/\"/g, "&quot;");
	contactInformation.fax = contactInformation.fax.replace(/\"/g, "&quot;");
      



/****************************************************************************
* Save all required state information.
* return - always returns TRUE
****************************************************************************/
 function savePanelData()
 {
  
   
   // Save contact info
   var contactForm       = document.contactInformation;     
         
        parent.addURLParameter("authToken", "${authToken}"); 
        
        // Passing arguments to VendorCreate
        parent.put("vendorName", top.getData("vName"));
        parent.put("vendorId", top.getData("vendorId"));
        parent.put("description", top.getData("vDescr"));
        
        parent.put("address1", top.getData("address1"));
        parent.put("address2", top.getData("address2"));
        parent.put("address3", top.getData("address3"));
        parent.put("city", top.getData("city"));
        parent.put("state", top.getData("region"));
        parent.put("country", top.getData("country"));
        parent.put("zipCode", top.getData("postalCode"));
        
        if (document.contactInformation.title != null) {   
	  parent.put("personTitle", contactForm.title.value);
        }
        
        if (document.contactInformation.firstName != null) { 
          parent.put("firstName", contactForm.firstName.value);
        }
        
        if (document.contactInformation.middleName != null) {   
	  parent.put("middleName", contactForm.middleName.value);
        }
        
        if (document.contactInformation.lastName != null) {
          parent.put("lastName", contactForm.lastName.value);
        }
        
        if (document.contactInformation.position != null) {
          parent.put("businessTitle", contactForm.position.value);
        }
        
        if (document.contactInformation.phoneNumber != null) {
          parent.put("phone1", contactForm.phoneNumber.value);
        }
        
        if (document.contactInformation.email != null) {
          parent.put("email1", contactForm.email.value);
        }
        
        if (document.contactInformation.fax != null) {
          parent.put("fax1", contactForm.fax.value);
        }
        
    //    if (status == "change") {
         
         if (document.contactInformation.title != null) {   
	  top.saveData(contactForm.title.value, "personTitle");
	 }  
         
         if (document.contactInformation.firstName != null) {
          top.saveData(contactForm.firstName.value, "firstName");
         }
         
         if (document.contactInformation.middleName != null) {   
	   top.saveData( contactForm.middleName.value, "middleName");
	 }
	
	 if (document.contactInformation.lastName != null) {
	  top.saveData( contactForm.lastName.value, "lastName");
	 }
	 
	 if (document.contactInformation.position != null) {
	  top.saveData( contactForm.position.value, "businessTitle");
	 }
	 
	 if (document.contactInformation.phoneNumber != null) {
	  top.saveData(contactForm.phoneNumber.value, "phone1");
	 }
	 
	 if (document.contactInformation.email != null) {
	  top.saveData(contactForm.email.value, "email1");
	 }
	 
	 if (document.contactInformation.fax != null) {
          top.saveData(contactForm.fax.value, "fax1");
         }
         
         //pass the 'back' string
         top.saveData("back", "back");
         
     //    }
        
 }
 
 
 
      function validatePanelData() {  
      
                    if (!validateInputLength()){
                      return false;
                    }
                    if (blankName()){
                      return false;       
                    } 
                    
                    if (blankVendor()){
		      return false;       
                    } 
                     return true;
                   
                     
      }
      
       function blankName(){
      
       if (top.getData("vName") == ""){
        top.saveData("name", "name");
        alertDialog("<%= UIUtil.toJavaScript((String)VendorPurchaseNLS.get("blankField")) %>");
        return true;
            }
        return false;
        }
        
        function blankVendor(){
        
	       if (top.getData("vDescr") == ""){
	        top.saveData("description", "description");
	        alertDialog("<%= UIUtil.toJavaScript((String)VendorPurchaseNLS.get("blankField")) %>");
	        return true;
	           }
	        return false;
        }
 
       function validateInputLength() {
 	  
          	
          
          if (!isValidLength(document.contactInformation.title, 50))
 	        return false;
 	  
          if (!isValidLength(document.contactInformation.firstName, 128))
          	return false;
         
          if (!isValidLength(document.contactInformation.middleName, 128))
          	return false;
          	
          if (!isValidLength(document.contactInformation.lastName, 128))
          	return false;
          
          if (!isValidLength(document.contactInformation.position, 128))
          	return false;
          if (!isValidLength(document.contactInformation.phoneNumber, 32))
          	return false;
          if (!isValidLength(document.contactInformation.email, 254))
          	return false;
          if (!isValidLength(document.contactInformation.fax, 32))
          	return false;
         
         
          return true;
       }
       
       function isValidLength(fieldName, maxLen) {
                
                if (fieldName == null){
                return true;
                }
                if (fieldName.value != "") {
                   if (!isValidUTF8length(fieldName.value, maxLen)) {
                      alertDialog("<%= UIUtil.toJavaScript((String)orderMgmtNLS.get("inputFieldMax")) %>");
                      fieldName.select();
                      return false;
                   }
                }
                return true;
       }
       
       
       function validateInputLengthOnChange(fieldName, maxLen) {
          isValidLength(fieldName, maxLen);
       }
 
       
 function initializeState() {
     
   if (status == "new"||status == "change") {
   
     if (back == "back")  {
        
        if (document.contactInformation.title != null) {
        document.contactInformation.title.value = top.getData("personTitle");
        if (document.contactInformation.title.value =="null") {  
          document.contactInformation.title.value = "";
         }
        } 
       
        if (document.contactInformation.firstName != null) {
        document.contactInformation.firstName.value = top.getData("firstName");
        if (document.contactInformation.firstName.value =="null") {  
	  document.contactInformation.firstName.value = "";
         } 
        }
        
        if (document.contactInformation.middleName != null) {
        document.contactInformation.middleName.value = top.getData("middleName");
	if (document.contactInformation.middleName.value =="null") {  
          document.contactInformation.middleName.value = "";
         }
        }
        
        if (document.contactInformation.lastName != null) {
        document.contactInformation.lastName.value = top.getData("lastName");
        if (document.contactInformation.lastName.value =="null") {  
	 document.contactInformation.lastName.value = "";
         }
        }
        
        if (document.contactInformation.position != null) {
        document.contactInformation.position.value = top.getData("businessTitle");
        if (document.contactInformation.position.value =="null") {  
	  document.contactInformation.position.value = "";
         }
        }
        
        if (document.contactInformation.phoneNumber != null) { 
        document.contactInformation.phoneNumber.value = top.getData("phone1");
        if (document.contactInformation.phoneNumber.value =="null") {  
	 document.contactInformation.phoneNumber.value = "";
         }
        }
         
        if (document.contactInformation.email != null) {
        document.contactInformation.email.value = top.getData("email1");
        if (document.contactInformation.email.value =="null") {  
	 document.contactInformation.email.value = "";
         }
        } 
        
        if (document.contactInformation.fax != null) {
        document.contactInformation.fax.value = top.getData("fax1");
        if (document.contactInformation.fax.value =="null") {  
	 document.contactInformation.fax.value = "";
         }
        }
       }
      }  
      
      
      parent.setContentFrameLoaded(true);
      
   }



 
</SCRIPT>

</HEAD>
<BODY ONLOAD="initializeState();"class="content">



<FORM NAME="contactInformation" method="post" action="">
	<INPUT TYPE='hidden' NAME="URL" VALUE=""> 
	<INPUT TYPE='hidden' NAME="XML" VALUE="">
	<INPUT TYPE='hidden' NAME="customerId" VALUE="">
	
<H1><%= UIUtil.toHTML((String)VendorPurchaseNLS.get("vendorContact")) %></H1>
 

</BR> 
 <table border=0 cellspacing=0 cellpadding=0>
 <TH colspan="1"></TH>   
   

<script>

<%
     String typeOfAddress = "contactInformation";
     Hashtable contactFormats = (Hashtable)ResourceDirectory.lookup("inventory.contactFormats");
     Hashtable localeAddrFormat = (Hashtable)XMLUtil.get(contactFormats, "contactFormats."+ jLocale.toString());

     if (localeAddrFormat == null) 
     {
	localeAddrFormat = (Hashtable)XMLUtil.get(contactFormats, "contactFormats.default");
     }
     
     
      
          
          String addressLine = "";
          
          for (int i=0;i<localeAddrFormat.size();i++) {
            
            addressLine = (String)XMLUtil.get(localeAddrFormat,"line"+ i +".elements");
             String[] addressFields = Util.tokenize(addressLine, ",");
 %>
             var counter = 0;
     	<%
     	        for (int j=0; j<addressFields.length; j++) {
     	           
     	           if ( (!addressFields[j].equals("space")) && (!addressFields[j].equals("comma"))   ) {
     	              //check if it is mandatory
     	            
        %>
     	 if ( "<%= addressFields[j] %>" == "title" ) {
                 
                 
                 document.writeln('<TR><TD  valign="top" align="left" colspan=2>');
                 document.writeln('<label for="<%= addressFields[j] %>"> <%= UIUtil.toJavaScript((String)VendorPurchaseNLS.get("title")) %></label><BR>');
                 document.writeln('<input type="text" name="<%= addressFields[j] %>" id="<%= addressFields[j] %>" value="" size=6 maxlength=50 onChange="validateInputLengthOnChange(document.contactInformation.<%= addressFields[j] %>, 50);"><BR>');
                 document.writeln('</TD></TR>');
                 
              }  else if ( "<%= addressFields[j] %>" == "firstName" ) {
                 document.writeln('<TR><TD  valign="top" align="left">');
                 document.writeln('<label for="<%= addressFields[j] %>"> <%= UIUtil.toJavaScript((String)VendorPurchaseNLS.get("firstName")) %></label><BR>');
                 document.writeln('<input type="text" name="<%= addressFields[j] %>" id="<%= addressFields[j] %>" value="" size=50 maxlength=128 onChange="validateInputLengthOnChange(document.contactInformation.<%= addressFields[j] %>, 128);"><BR>');
                 
              }  else if ( "<%= addressFields[j] %>" == "middleName" ) {
	         document.writeln('<label for="<%= addressFields[j] %>"> <%= UIUtil.toJavaScript((String)VendorPurchaseNLS.get("middleName")) %></label><BR>');
	         document.writeln('<input type="text" name="<%= addressFields[j] %>" id="<%= addressFields[j] %>" value="" size=50 maxlength=128 onChange="validateInputLengthOnChange(document.contactInformation.<%= addressFields[j] %>, 128);"><BR>');
                
                 
              }  else if ( "<%= addressFields[j] %>" == "lastName" ) {
	         document.writeln('<label for="<%= addressFields[j] %>"> <%= UIUtil.toJavaScript((String)VendorPurchaseNLS.get("lastName")) %></label><BR>');
	         document.writeln('<input type="text" name="<%= addressFields[j] %>" id="<%= addressFields[j] %>" value="" size=50 maxlength=128 onChange="validateInputLengthOnChange(document.contactInformation.<%= addressFields[j] %>, 128);"><BR>');
                
              
              }  else if ( "<%= addressFields[j] %>" == "position" ) {
	         document.writeln('<label for="<%= addressFields[j] %>"> <%= UIUtil.toJavaScript((String)VendorPurchaseNLS.get("position")) %></label><BR>');
	         document.writeln('<input type="text" name="<%= addressFields[j] %>" id="<%= addressFields[j] %>" value="" size=50 maxlength=128 onChange="validateInputLengthOnChange(document.contactInformation.<%= addressFields[j] %>, 128);"><BR>');
                
              
              }  else if ( "<%= addressFields[j] %>" == "phoneNumber" ) {
	         document.writeln('<label for="<%= addressFields[j] %>"> <%= UIUtil.toJavaScript((String)VendorPurchaseNLS.get("phone")) %></label><BR>');
	         document.writeln('<input type="text" name="<%= addressFields[j] %>" id="<%= addressFields[j] %>" value="" size=50 maxlength=32 onChange="validateInputLengthOnChange(document.contactInformation.<%= addressFields[j] %>, 32);"><BR>');
                
              
              }  else if ( "<%= addressFields[j] %>" == "email" ) {
	         document.writeln('<label for="<%= addressFields[j] %>"> <%= UIUtil.toJavaScript((String)VendorPurchaseNLS.get("email")) %></label><BR>');
	         document.writeln('<input type="text" name="<%= addressFields[j] %>" id="<%= addressFields[j] %>" value="" size=50 maxlength=254 onChange="validateInputLengthOnChange(document.contactInformation.<%= addressFields[j] %>, 254);"><BR>');
                
              
              }  else  {
	         document.writeln('<label for="<%= addressFields[j] %>"> <%= UIUtil.toJavaScript((String)VendorPurchaseNLS.get("fax")) %></label><BR>');
	         document.writeln('<input type="text" name="<%= addressFields[j] %>" id="<%= addressFields[j] %>" value="" size=50 maxlength=32 onChange="validateInputLengthOnChange(document.contactInformation.<%= addressFields[j] %>, 32);"><BR>');
                 document.writeln('</TD></TR>');
              
              }
              
              counter++;
                       
     	<%            
     	     } // end if
           
         } //end for
     } //end for
     
     
     
     %>
    
     </script>
     </table>       
        


</FORM>

<%
} catch (Exception e) {
   System.out.println ("Exception ");
   e.printStackTrace();
   out.println(e);
}
%>

</BODY>
</HTML>
