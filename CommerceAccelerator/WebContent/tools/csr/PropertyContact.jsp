<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2000, 2009 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java"
    import="java.util.*,
            com.ibm.commerce.tools.common.*,
            com.ibm.commerce.tools.util.*,
            com.ibm.commerce.server.*,
            com.ibm.commerce.user.beans.*,
            com.ibm.commerce.user.objects.*,
            com.ibm.commerce.usermanagement.commands.ECUserConstants,
            com.ibm.commerce.tools.optools.user.beans.*,
	    com.ibm.commerce.beans.*,
	    com.ibm.commerce.command.*,
	    com.ibm.commerce.common.beans.*,
            com.ibm.commerce.tools.xml.*"

%>

<%@include file="../common/common.jsp" %>

<%
try
{
	CommandContext cmdContext = (CommandContext)request.getAttribute("CommandContext");

	String userId = request.getParameter("shrfnbr");

	String locale = cmdContext.getLocale().toString();

	Hashtable formats = (Hashtable)ResourceDirectory.lookup("csr.nlsFormats");
	Hashtable format = (Hashtable)XMLUtil.get(formats, "nlsFormats."+ locale);
	String showPhoneType = (String)XMLUtil.get(format, "phoneType.show");
	String showPhoneListed = (String)XMLUtil.get(format, "phoneListed.show");

	// (defect 8650)
	// Check that if the showPhoneType and showPhoneListed is null
	// which means that they are not defined in the property file
	// Initialize these two variables to 'false'
	if (null == showPhoneType)
		showPhoneType = new String("false");
	if (null == showPhoneListed)
		showPhoneListed = new String("false");



	if (format == null) 
	{
	   format = (Hashtable)XMLUtil.get(formats, "nlsFormats.default");
	} 


	Hashtable userNLS = (Hashtable)ResourceDirectory.lookup("csr.userNLS", cmdContext.getLocale());	

	OptoolsRegisterDataBean registerDataBean = new OptoolsRegisterDataBean();
	
	//RM:d70084 Should not initialize the databean if the userId is null
	if (userId != null && userId.trim().length() > 0) {
		registerDataBean.setUserId(userId); 
		DataBeanManager.activate(registerDataBean, request);
	}

	ResourceBundleDataBean bnResourceBundle = new ResourceBundleDataBean();
	bnResourceBundle.setPropertyFileName("UserRegistration");
	DataBeanManager.activate(bnResourceBundle, request);


	// for drop-down list options
	String PreferredCommunicationURL = registerDataBean.getPreferredCommunicationURL();
	String Phone1TypeURL = registerDataBean.getPhone1TypeURL();	
	String Phone2TypeURL = registerDataBean.getPhone2TypeURL();	
	String BestCallingTimeURL = registerDataBean.getBestCallingTimeURL();

	Hashtable hshPreferredCommunication = new Hashtable();
	Hashtable hshPhone1Type = new Hashtable();
	Hashtable hshPhone2Type = new Hashtable();
	Hashtable hshBestCallingTime  = new Hashtable();

	String[][] PreferredCommunicationOptions = null;
	String[][] Phone1TypeOptions = null;
	String[][] Phone2TypeOptions = null;
	String[][] BestCallingTimeOptions = null;
	try {
		SortedMap smpFields = bnResourceBundle.getPropertySortedMap();
		Iterator entryIterator = smpFields.entrySet().iterator();
		Map.Entry textentry = (Map.Entry) entryIterator.next();
		Hashtable hshText = (Hashtable) textentry .getValue();

		while (entryIterator.hasNext()) {
			Map.Entry entry = (Map.Entry) entryIterator.next();
			Hashtable hshField = (Hashtable) entry.getValue();
			String strName = (String) hshField.get("Name");

			if (strName.equals(PreferredCommunicationURL)) {
				hshPreferredCommunication  = (Hashtable) entry.getValue();
			}
			if (strName.equals(Phone1TypeURL)) {
				hshPhone1Type  = (Hashtable) entry.getValue();
			}
			if (strName.equals(Phone2TypeURL)) {
				hshPhone2Type  = (Hashtable) entry.getValue();
			}
			if (strName.equals(BestCallingTimeURL)) {
				hshBestCallingTime  = (Hashtable) entry.getValue();
			}
		}

		PreferredCommunicationOptions = (String[][])hshPreferredCommunication.get(ECUserConstants.EC_RB_OPTIONS);
		Phone1TypeOptions = (String[][])hshPhone1Type.get(ECUserConstants.EC_RB_OPTIONS);
		Phone2TypeOptions = (String[][])hshPhone2Type.get(ECUserConstants.EC_RB_OPTIONS);
		BestCallingTimeOptions = (String[][])hshBestCallingTime.get(ECUserConstants.EC_RB_OPTIONS);
	} catch (Exception e) {
	}

        UIUtil convert = null;

%>   
<html xmlns="http://www.w3.org/1999/xhtml">

<head>
<link rel="stylesheet" href="<%= UIUtil.getCSSFile(cmdContext.getLocale()) %>" type="text/css" />
<title><%= userNLS.get("contactPageTitle") %></title>
<script type="text/javascript" src="/wcs/javascript/tools/csr/user.js">
</script>
<script type="text/javascript" src="/wcs/javascript/tools/common/Util.js">
</script>
<script type="text/javascript" src="/wcs/javascript/tools/common/validator.js">
</script>
<script type="text/javascript">

function isTrue(v)
{
	return (v=="1")?true:false;
}

function compare()
{
	for (var i=0; i<document.contact.elements.length; i++)
   {
   	var e = document.contact.elements[i];
      if (parent.get("userProfileUpdated")=="false" && e.type == "select-one" && e.name == "preferredCommunication")
      {
      	if (e.options[e.selectedIndex].value != "<%=registerDataBean.getPreferredCommunication()%>")
         	parent.put("userProfileUpdated", "true");
      }

      if (parent.get("addressUpdated")=="false" && e.type == "text")
      {
    	 if (e.name == "email1" && e.value != "<%=convert.toJavaScript(registerDataBean.getEmail1())%>")
     	     	parent.put("addressUpdated", "true");
     	 if (e.name == "email2" && e.value != "<%=convert.toJavaScript(registerDataBean.getEmail2())%>")
      	   parent.put("addressUpdated", "true");
         if (e.name == "phone1" && e.value != "<%=convert.toJavaScript(registerDataBean.getPhone1())%>")
            parent.put("addressUpdated", "true");
         if (e.name == "phone2" && e.value != "<%=convert.toJavaScript(registerDataBean.getPhone2())%>")
            parent.put("addressUpdated", "true");
         if (e.name == "fax1" && e.value != "<%=convert.toJavaScript(registerDataBean.getFax1())%>")
            parent.put("addressUpdated", "true");
         if (e.name == "fax2" && e.value != "<%=convert.toJavaScript(registerDataBean.getFax2())%>")
            parent.put("addressUpdated", "true");            
      }

      if (parent.get("addressUpdated")=="false" && e.type == "select-one")
      {
         if (e.name == "phone1Type" && e.options[e.selectedIndex].value != "<%=registerDataBean.getPhone1Type()%>")
            parent.put("addressUpdated", "true");
         if (e.name == "phone2Type" && e.options[e.selectedIndex].value != "<%=registerDataBean.getPhone2Type()%>")
            parent.put("addressUpdated", "true");
         if (e.name == "bestTimeToCall" && e.options[e.selectedIndex].value != "<%=registerDataBean.getBestCallingTime()%>")
            parent.put("addressUpdated", "true");
      }

      if (parent.get("addressUpdated")=="false" && e.type == "checkbox")
      {
         if (e.name=="packageInsert" && e.checked != isTrue("<%=registerDataBean.getPackageSuppression()%>"))
         {
            parent.put("addressUpdated", "true");
   		}
         if (e.name=="phone1Listed" && e.checked != isTrue("<%=registerDataBean.getPublishPhone1()%>"))
         {
            parent.put("addressUpdated", "true");
         }
         if (e.name=="phone2Listed" && e.checked != isTrue("<%=registerDataBean.getPublishPhone2()%>"))
            parent.put("addressUpdated", "true");
      }

      // alertDialog(e.name + " " + parent.get("userProfileUpdated") + " " + parent.get("addressUpdated"));      
  }
      

  if (parent.get("addressUpdated") == "true" || parent.get("userProfileUpdated") == "true" )
     return true;
  else
     return false;
}


function setStateChanged()
{
   // alertDialog("DEBUG: setStateChanged is called");
   if (compare() == true)
   {
     if (parent.get("changesMade") == "false")
        parent.put("changesMade",      "true");
   }
}

function isStateChanged()
{
	return parent.get("changesMade");
}

function displayValidationError()
{
	// check for errors from validation
	var mE1 = "missingEmail1";
	var mE2 = "missingEmail2";
	var mP1 = "missingPhone1";
	var mP2 = "missingPhone2";
	var iFM = "inputFieldMax";
	var iFIE1 = "inputFieldInvalidEmail1";
	var iFIE2 = "inputFieldInvalidEmail2";
	var iFME1 = "inputFieldMaxEmail1";
	var iFME2 = "inputFieldMaxEmail2";
		
	var code = parent.getErrorParams();
	if (code != null)
	{
		if (code == mE1)
		{
			alertDialog("<%=UIUtil.toJavaScript((String)userNLS.get("missingEmail1"))%>");
			document.contact.email1.focus();
		}
		else if (code == mE2)
		{
			alertDialog("<%=UIUtil.toJavaScript((String)userNLS.get("missingEmail2"))%>");
			document.contact.email2.focus();
		}
		else if (code == mP1)
		{
			alertDialog("<%=UIUtil.toJavaScript((String)userNLS.get("missingPhone1"))%>");
			document.contact.phone1.focus();
		}
		else if (code == mP2)
		{
			alertDialog("<%=UIUtil.toJavaScript((String)userNLS.get("missingPhone2"))%>");
			document.contact.phone2.focus();			
		} else if (code == iFIE1) {
			alertDialog("<%=UIUtil.toJavaScript((String)userNLS.get("inputFieldInvalidEmail1"))%>");
			document.contact.email1.focus();
		} else if (code == iFIE2) {
			alertDialog("<%=UIUtil.toJavaScript((String)userNLS.get("inputFieldInvalidEmail2"))%>");
			document.contact.email2.focus();
		} else if (code == iFME1) {
			alertDialog("<%=UIUtil.toJavaScript((String)userNLS.get("inputFieldMaxEmail1"))%>");
			document.contact.email1.focus();
		} else if (code == iFME2) {
			alertDialog("<%=UIUtil.toJavaScript((String)userNLS.get("inputFieldMaxEmail2"))%>");
			document.contact.email2.focus();
		} else if (code.indexOf(iFM)!=-1) {
			alertDialog("<%=UIUtil.toJavaScript((String)userNLS.get("inputFieldMax"))%>");
			code = code.split("_");
			if (code[1]=="phone1")
				document.contact.phone1.select();
			else if (code[1]=="phone2")
				document.contact.phone2.select();
			else if (code[1]=="fax1")
				document.contact.fax1.select();
			else if (code[1]=="fax2")
				document.contact.fax2.select();
		}
	}
}

function initializeState()
{
   // alertDialog("DEBUG: initializeState()");
	
   var contactInfo = parent.get("contactInfo");
   if (contactInfo != null)
   {
      // alertDialog("contactInfo is not null");
      document.contact.email1.value  = contactInfo.email1;
      document.contact.email2.value    = contactInfo.email2;
      document.contact.phone1.value    = contactInfo.phone1;
      document.contact.phone2.value   = contactInfo.phone2;
      document.contact.fax1.value  = contactInfo.fax1;
      document.contact.fax2.value = contactInfo.fax2;

      for ( var i=0; i < document.contact.preferredCommunication.length ; i++ )
      {
	      if ( document.contact.preferredCommunication.options[i].value == contactInfo.preferredCommunication )
         {
   	      document.contact.preferredCommunication[i].selected = true;
            break;
         }
      }
		<%
      if (showPhoneType.equals("true"))
      {
      %>
         for ( var i=0; i < document.contact.phone1Type.length; i++ )
         {
           if ( document.contact.phone1Type.options[i].value == contactInfo.phone1Type )
           {
              document.contact.phone1Type.options[i].selected = true;
              break;
           }
         }
         for ( var i=0; i < document.contact.phone2Type.length; i++ )
         {
            if ( document.contact.phone2Type.options[i].value == contactInfo.phone2Type )
            {
               document.contact.phone2Type.options[i].selected = true;
               break;
            }
         }
      <%
      }

      if (showPhoneListed.equals("true")) {
      %>
         if (contactInfo.phone1Listed == "1")
            document.contact.phone1Listed.checked = true;
         else
            document.contact.phone1Listed.checked = false;
         if (contactInfo.phone2Listed == "1")
            document.contact.phone2Listed.checked = true;
         else
            document.contact.phone2Listed.checked = false;
      <%
      }
      %>

      if (contactInfo.packageInsert== "1")
         document.contact.packageInsert.checked = true;
      else
         document.contact.packageInsert.checked = false;

      for (var i=0; i< document.contact.bestTimeToCall.length; i++)
      {
         if (document.contact.bestTimeToCall.options[i].value == contactInfo.bestTimeToCall)
         {
            document.contact.bestTimeToCall.options[i].selected = true;
            break;
         }
      }
   }
   else
   {
      // alertDialog("contactInfo is null");

      var dbPreferedMethod = "<%=registerDataBean.getPreferredCommunication()%>";
      for ( var i=0; i < document.contact.preferredCommunication.length; i++ )
      {
         if ( document.contact.preferredCommunication.options[i].value == dbPreferedMethod )
         {
      	   document.contact.preferredCommunication[i].selected = true;
            break;
         }
      }
	    
      document.contact.email1.value  = "<%=convert.toJavaScript(registerDataBean.getEmail1())%>";
      document.contact.email2.value  = "<%=convert.toJavaScript(registerDataBean.getEmail2())%>";
      document.contact.phone1.value  = "<%=convert.toJavaScript(registerDataBean.getPhone1())%>";
      document.contact.phone2.value  = "<%=convert.toJavaScript(registerDataBean.getPhone2())%>";
      document.contact.fax1.value    = "<%=convert.toJavaScript(registerDataBean.getFax1())%>";
      document.contact.fax2.value    = "<%=convert.toJavaScript(registerDataBean.getFax2())%>";
 
      <%
      if (showPhoneType.equals("true"))
      {
      %>
      var dbPhone1Type = "<%=registerDataBean.getPhone1Type()%>";
      var dbPhone2Type = "<%=registerDataBean.getPhone2Type()%>";

      for ( var i=0; i < document.contact.phone1Type.length; i++ )
      {
         if ( document.contact.phone1Type.options[i].value == dbPhone1Type )
         {
         	document.contact.phone1Type.options[i].selected = true;
            break;
         }
      }
      for ( var i=0; i < document.contact.phone2Type.length; i++ )
      {
         if ( document.contact.phone2Type.options[i].value == dbPhone2Type )
         {
            document.contact.phone2Type.options[i].selected = true;
            break;
         }
      }
      <%
      }

      if (showPhoneListed.equals("true")) {
      %>
      var dbPhone1Listed = "<%=registerDataBean.getPublishPhone1()%>";
      var dbPhone2Listed = "<%=registerDataBean.getPublishPhone2()%>";

      if (dbPhone1Listed == "1")
         document.contact.phone1Listed.checked = true;
      else
         document.contact.phone1Listed.checked = false;

      if (dbPhone2Listed == "1")
         document.contact.phone2Listed.checked = true;
      else
         document.contact.phone2Listed.checked = false;
      <%
      }
      %>

      var dbPackageInsert = "<%=registerDataBean.getPackageSuppression()%>";
      if (dbPackageInsert== "1")
         document.contact.packageInsert.checked = true;
      else
         document.contact.packageInsert.checked = false;

      var dbBestTimeToCall = "<%=registerDataBean.getBestCallingTime()%>";
      for (var i=0; i< document.contact.bestTimeToCall.length; i++)
      {
         if (document.contact.bestTimeToCall.options[i].value == dbBestTimeToCall)
         {
      	   document.contact.bestTimeToCall.options[i].selected = true;
            break;
         }
      }
   
   }

	parent.setContentFrameLoaded(true);  
	displayValidationError();

}

function validatePanelData() {
	var email1 = document.contact.email1.value;
	var email2 = document.contact.email2.value;
	var selected = document.contact.preferredCommunication.selectedIndex;
	var preferredCommunication = document.contact.preferredCommunication.options[selected].value;
	var phone1 = document.contact.phone1.value;
    var phone2 = document.contact.phone2.value;
    var fax1 = document.contact.fax1.value;
    var fax2 = document.contact.fax2.value;
 
	if (preferredCommunication == "E1") {
		if (isEmpty(email1)) {
			alertDialog("<%=UIUtil.toJavaScript((String)userNLS.get("missingEmail1"))%>");
			document.contact.email1.focus();
			return false;
		}
	}
	if (email1 != null && !isEmpty(email1)) {
		if(!wc_validateUTF8length(email1, 254)) {
			alertDialog("<%=UIUtil.toJavaScript((String)userNLS.get("inputFieldMaxEmail1"))%>");
			document.contact.email1.focus();
			return false;
		}
		if (!isValidEmail(email1)) {
			alertDialog("<%=UIUtil.toJavaScript((String)userNLS.get("inputFieldInvalidEmail1"))%>");
			document.contact.email1.focus();
			return false;
		}
	}
	if (preferredCommunication == "E2") {
		if (isEmpty(email2)) {
			alertDialog("<%=UIUtil.toJavaScript((String)userNLS.get("missingEmail2"))%>");
			document.contact.email2.focus();
			return false;
		}
	}
	if (email2 != null && !isEmpty(email2)) {
		if(!wc_validateUTF8length(email2, 254)) {
			alertDialog("<%=UIUtil.toJavaScript((String)userNLS.get("inputFieldMaxEmail2"))%>");
			document.contact.email2.focus();
			return false;
		}
		if (!isValidEmail(email2)) {
			alertDialog("<%=UIUtil.toJavaScript((String)userNLS.get("inputFieldInvalidEmail2"))%>");
			document.contact.email2.focus();
			return false;
		}
	}
	
	
	return true;
}
function savePanelData()
{
	if (parent.get("missingEmail1") == null) 
	   parent.put("missingEmail1", "<%=UIUtil.toJavaScript((String)userNLS.get("missingEmail1"))%>");
	if (parent.get("missingEmail2") == null)
	   parent.put("missingEmail2", "<%=UIUtil.toJavaScript((String)userNLS.get("missingEmail2"))%>");
	if (parent.get("missingPhone1") == null)
	   parent.put("missingPhone1", "<%=UIUtil.toJavaScript((String)userNLS.get("missingPhone1"))%>");
	if (parent.get("missingPhone2") == null)
	   parent.put("missingPhone2", "<%=UIUtil.toJavaScript((String)userNLS.get("missingPhone2"))%>");
	if (parent.get("inputFieldInvalidEmail1") == null)
	   parent.put("inputFieldInvalidEmail1", "<%=UIUtil.toJavaScript((String)userNLS.get("inputFieldInvalidEmail1"))%>");
	if (parent.get("inputFieldInvalidEmail2") == null)
	   parent.put("inputFieldInvalidEmail2", "<%=UIUtil.toJavaScript((String)userNLS.get("inputFieldInvalidEmail2"))%>");
	if (parent.get("inputFieldMaxEmail1") == null)
	   parent.put("inputFieldMaxEmail1", "<%=UIUtil.toJavaScript((String)userNLS.get("inputFieldMaxEmail1"))%>");
	if (parent.get("inputFieldMaxEmail2") == null)
	   parent.put("inputFieldMaxEmail2", "<%=UIUtil.toJavaScript((String)userNLS.get("inputFieldMaxEmail2"))%>");
   
   var contactInfo = new Object;
 
   var selected;
   selected = document.contact.preferredCommunication.selectedIndex;
   contactInfo.preferredCommunication = document.contact.preferredCommunication.options[selected].value;
	
   contactInfo.email1 = document.contact.email1.value;
   contactInfo.email2 = document.contact.email2.value;
   contactInfo.phone1 = document.contact.phone1.value;
   contactInfo.phone2 = document.contact.phone2.value;
   contactInfo.fax1 = document.contact.fax1.value;
   contactInfo.fax2 = document.contact.fax2.value;

   <%
   if (showPhoneType.equals("true"))
   {
   %>
      selected = document.contact.phone1Type.selectedIndex;
      contactInfo.phone1Type = document.contact.phone1Type.options[selected].value;
      selected = document.contact.phone2Type.selectedIndex;
      contactInfo.phone2Type = document.contact.phone2Type.options[selected].value;
   <%
   }

   if (showPhoneListed.equals("true")) 
   {
   %>
   	if (document.contact.phone1Listed.checked == true)
	      contactInfo.phone1Listed = "1";
	   else
	   	contactInfo.phone1Listed = "0";
	   	
   	if (document.contact.phone2Listed.checked == true)
	      contactInfo.phone2Listed = "1";
	   else
	   	contactInfo.phone2Listed = "0";
	   		   	
   <%
   }
   %>

   selected = document.contact.bestTimeToCall.selectedIndex;
   contactInfo.bestTimeToCall = document.contact.bestTimeToCall.options[selected].value;

	if (document.contact.packageInsert.checked == true)
	   contactInfo.packageInsert = "1";
	else
	   contactInfo.packageInsert = "0";

   parent.put("contactInfo", contactInfo);   
   
	
	setStateChanged();

	var authToken = parent.get("authToken");
	if (defined(authToken)) {
		parent.addURLParameter("authToken", authToken);
	}

	// alertDialog("contact state changed?" + isStateChanged());
   // return true;

}


</script>

</head>
<body class="content" onload="initializeState();">
<form name="contact" id="contact">
<h1><%= userNLS.get("Contact") %></h1>
<table border="0" cellpadding="0" cellspacing="0" id="PropertyContact_Table_1">
  <tr><th></th></tr>
  <tbody>

          <tr>
            <td valign="bottom" id="PropertyContact_TableCell_1"><label for='preferredCommunication1'><%=userNLS.get("preferredCommunication")%></label><br />
            <select name="preferredCommunication" id='preferredCommunication1'>
            <option value="" selected><%=userNLS.get("notProvided")%></option>
            			<%	if (PreferredCommunicationOptions != null) {%>
					<%	for (int i = 0; i < PreferredCommunicationOptions.length; i ++) { %>
					<option value="<%= PreferredCommunicationOptions[i][0] %>">
					<%= PreferredCommunicationOptions[i][1] %></option>
					<%	} %>
				<%	} %>
            </select></td>
            <td id="PropertyContact_TableCell_2"></td>
          </tr>
          <tr>
            <td valign="bottom" id="PropertyContact_TableCell_3"><%=userNLS.get("email1")%><br />
            <label for="PropertyContact_FormInput_email1_In_contact_1"><span style="display:none;"><%=userNLS.get("email1")%></span></label>
            <input size="30" type="text" name="email1" maxlength="254" id="PropertyContact_FormInput_email1_In_contact_1" /></td>

          </tr>
          <tr>
             <td valign="bottom" id="PropertyContact_TableCell_4"><%=userNLS.get("email2")%><br />
             <label for="PropertyContact_FormInput_email2_In_contact_1"><span style="display:none;"><%=userNLS.get("email2")%></span></label>
             <input size="30" type="text" name="email2" maxlength="254" id="PropertyContact_FormInput_email2_In_contact_1" /></td>
          </tr>


    <tr>

            <td valign="bottom" id="PropertyContact_TableCell_5"><%=userNLS.get("phone1")%><br />
            <label for="PropertyContact_FormInput_phone1_In_contact_1"><span style="display:none;"><%=userNLS.get("phone1")%></span></label>
            <input size="30" type="text" name="phone1" maxlength="32" id="PropertyContact_FormInput_phone1_In_contact_1" /></td>
<%          if (showPhoneType.equals("true")) {
%>            <td valign="bottom" id="PropertyContact_TableCell_6">
              <label for='phone1Type1'><%=userNLS.get("type")%></label><br />
              <select name="phone1Type" id='phone1Type1'>
              <option value="" selected></option>
                          		<%	if (Phone1TypeOptions != null) {%>
						<%	for (int i = 0; i < Phone1TypeOptions.length; i ++) { %>
						<option value="<%= Phone1TypeOptions[i][0] %>">
						<%= Phone1TypeOptions[i][1] %></option>
						<%	} %>
					<%	} %>
              </select></td>
<%          }
            if (showPhoneListed.equals("true")) {
%>           <td valign="bottom" id="PropertyContact_TableCell_7">
	      <label for="PropertyContact_FormInput_phone1Listed_In_contact_1"><span style="display:none;"><%=userNLS.get("listed")%></span></label>
              <input type="checkbox" name="phone1Listed" value="1" id="PropertyContact_FormInput_phone1Listed_In_contact_1" /><%=userNLS.get("listed")%></td>
<%          }
%>        </tr>
          <tr>
            <td valign="bottom" id="PropertyContact_TableCell_8"><%=userNLS.get("phone2")%><br />
            <label for="PropertyContact_FormInput_phone2_In_contact_1"><span style="display:none;"><%=userNLS.get("phone2")%></span></label>
            <input size="30" type="text" name="phone2" maxlength="32" id="PropertyContact_FormInput_phone2_In_contact_1" /></td>
<%          if (showPhoneType.equals("true")) {
%>            <td valign="bottom" id="PropertyContact_TableCell_9">
              <label for='phone2Type1'><%=userNLS.get("type")%></label><br />
              <select name="phone2Type" id='phone2Type1'>
              <option value="" selected></option>
              				<%	if (Phone2TypeOptions != null) {%>
						<%	for (int i = 0; i < Phone2TypeOptions.length; i ++) { %>
						<option value="<%= Phone2TypeOptions[i][0] %>">
						<%= Phone2TypeOptions[i][1] %></option>
						<%	} %>
					<%	} %>
              </select></td>
<%          }
            if (showPhoneListed.equals("true")) {
%>            <td valign="bottom" id="PropertyContact_TableCell_10">
	      <label for="PropertyContact_FormInput_phone2Listed_In_contact_1"><span style="display:none;"><%=userNLS.get("listed")%></span></label>
              <input type="checkbox" name="phone2Listed" value="1" id="PropertyContact_FormInput_phone2Listed_In_contact_1" /><%=userNLS.get("listed")%></td>
<%          }
%>        </tr>


          <tr>
            <td valign="bottom" id="PropertyContact_TableCell_11"><%=userNLS.get("fax1")%><br />
            <label for="PropertyContact_FormInput_fax1_In_contact_1"><span style="display:none;"><%=userNLS.get("fax1")%></span></label>
            <input size="30" type="text" name="fax1" maxlength="32" id="PropertyContact_FormInput_fax1_In_contact_1" /></td>

          </tr>
          <tr>
            <td valign="bottom" id="PropertyContact_TableCell_12"><%=userNLS.get("fax2")%><br />
            <label for="PropertyContact_FormInput_fax2_In_contact_1"><span style="display:none;"><%=userNLS.get("fax2")%></span></label>
            <input size="30" type="text" name="fax2" maxlength="32" id="PropertyContact_FormInput_fax2_In_contact_1" /></td>
          </tr>
          <tr>
            <td colspan="2" valign="bottom" id="PropertyContact_TableCell_13"><label for='bestTimeToCall1'><%=userNLS.get("bestTimeToCall")%></label><br />
            <select name="bestTimeToCall" id='bestTimeToCall1'>
            <option value="" selected><%=userNLS.get("notProvided")%></option>
          			<%	if (BestCallingTimeOptions != null) {%>
					<%	for (int i = 0; i < BestCallingTimeOptions.length; i ++) { %>
					<option value="<%= BestCallingTimeOptions[i][0] %>">
					<%= BestCallingTimeOptions[i][1] %></option>
					<%	} %>
				<%	} %>
            </select></td>
          </tr>
          <tr>
            <td colspan="2" valign="bottom" id="PropertyContact_TableCell_14"><br />
            <label for="PropertyContact_FormInput_packageInsert_In_contact_1"><span style="display:none;"><%=userNLS.get("includePackage")%></span></label>
            <input type="checkbox" name="packageInsert" id="PropertyContact_FormInput_packageInsert_In_contact_1" /><%=userNLS.get("includePackage")%></td>
          </tr>

  </tbody>
</table>
</form>
<%
} catch (Exception e)
{
	e.printStackTrace();
}
%>

</body>
</html>




