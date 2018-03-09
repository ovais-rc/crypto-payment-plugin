<%--
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2000, 2013
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
//*
--%>

<%@ page language="java"
    import="java.util.*,
            com.ibm.commerce.tools.util.*,
            com.ibm.commerce.tools.common.*,
            com.ibm.commerce.server.*,
            com.ibm.commerce.common.objects.*,
            com.ibm.commerce.common.beans.*,
            com.ibm.commerce.user.beans.*,
            com.ibm.commerce.user.objects.*,
            com.ibm.commerce.usermanagement.commands.ECUserConstants,
            com.ibm.commerce.tools.optools.user.beans.*,
            com.ibm.commerce.beans.*,
            com.ibm.commerce.utils.*,
            com.ibm.commerce.command.*,
            com.ibm.commerce.ras.*,
            com.ibm.commerce.tools.xml.*"

%>

<%@include file="../common/common.jsp" %>
<%!
	private final static String DOT = ".";
%>
<%
try
{
	CommandContext cmdContext = (CommandContext)request.getAttribute("CommandContext");
	String locale = cmdContext.getLocale().toString();


	Hashtable formats = (Hashtable)ResourceDirectory.lookup("csr.nlsFormats");

	StringBuffer nlsFmt = new StringBuffer();
	nlsFmt.append("nlsFormats").append(DOT).append(locale);
	Hashtable format = (Hashtable)XMLUtil.get(formats, nlsFmt.toString());

	if (format == null) 
	{
	   format = (Hashtable)XMLUtil.get(formats, "nlsFormats.default");
	} 

	Hashtable userNLS = (Hashtable)ResourceDirectory.lookup("csr.userNLS", cmdContext.getLocale());	

	OptoolsRegisterDataBean registerDataBean = new OptoolsRegisterDataBean();

	ResourceBundleDataBean bnResourceBundle = new ResourceBundleDataBean();
	StringBuffer userRegProp = new StringBuffer();
	userRegProp.append("UserRegistration");
	bnResourceBundle.setPropertyFileName(userRegProp.toString());

	// defect 64669, this disables the store specific UserRegistration properties files.
	bnResourceBundle.setStoreDirectoryEnabled(false);

	DataBeanManager.activate(bnResourceBundle, request);

	SortedMap smpFields = bnResourceBundle.getPropertySortedMap();
	Iterator entryIterator = smpFields.entrySet().iterator();

	String LogonIdURL = registerDataBean.getLogonIdURL();
	String PasswordURL = registerDataBean.getLogonPasswordURL();
	String PasswordVerifyURL = registerDataBean.getLogonPasswordVerifyURL();
	String FirstNameURL = registerDataBean.getFirstNameURL();
	String MiddleNameURL = registerDataBean.getMiddleNameURL();
	String LastNameURL = registerDataBean.getLastNameURL();
	String Address1URL  = registerDataBean.getAddress1URL();
	String CityURL      = registerDataBean.getCityURL();
	String StateURL     = registerDataBean.getStateURL();
	String CountryURL   = registerDataBean.getCountryURL();
	String ZipCodeURL   = registerDataBean.getZipCodeURL();
	String PersonTitleURL = registerDataBean.getPersonTitleURL();

	Hashtable hshLogonId = new Hashtable();
	Hashtable hshPassword = new Hashtable();
	Hashtable hshPasswordVerify = new Hashtable();
	Hashtable hshFirstName = new Hashtable();
	Hashtable hshMiddleName = new Hashtable();
	Hashtable hshLastName = new Hashtable();
	Hashtable hshAddress1  = new Hashtable();
	Hashtable hshCity      = new Hashtable();
	Hashtable hshState     = new Hashtable();
	Hashtable hshCountry   = new Hashtable();
	Hashtable hshZipCode   = new Hashtable();	
	Hashtable hshPersonTitle = new Hashtable();

	String[][] PreferredCurrencyOptions = null;
	String[][] PreferredLanguageOptions = null;

	LanguageListDataBean bnLanguageList = null;
	com.ibm.commerce.user.beans.CurrencyListDataBean bnCurrencyList = null;

	while (entryIterator.hasNext()) {
		Map.Entry entry = (Map.Entry) entryIterator.next();
		Hashtable hshField = (Hashtable) entry.getValue();

		String strName = (String) hshField.get("Name");
	    if (strName != null) {
		if (strName.equals(ECUserConstants.EC_USER_PREFERREDLANGUAGE)) {
			bnLanguageList = new LanguageListDataBean();
			DataBeanManager.activate(bnLanguageList, request);
			PreferredLanguageOptions = bnLanguageList.getLanguageList();
		}
		if (strName.equals(ECUserConstants.EC_USER_PREFERREDCURRENCY)) {
			bnCurrencyList = new com.ibm.commerce.user.beans.CurrencyListDataBean();
			DataBeanManager.activate(bnCurrencyList, request);
			PreferredCurrencyOptions = bnCurrencyList.getCurrencyList();
		}
		if (strName.equals(LogonIdURL)) {
			hshLogonId = (Hashtable) entry.getValue();
		}
		if (strName.equals(PasswordURL)) {
			hshPassword = (Hashtable) entry.getValue();
		}
		if (strName.equals(PasswordVerifyURL)) {
			hshPasswordVerify = (Hashtable) entry.getValue();
		}
		if (strName.equals(FirstNameURL)) {
			hshFirstName  = (Hashtable) entry.getValue();
		}
		if (strName.equals(MiddleNameURL)) {
			hshMiddleName  = (Hashtable) entry.getValue();
		}
		if (strName.equals(LastNameURL)) {
			hshLastName  = (Hashtable) entry.getValue();
		}
		if (strName.equals(Address1URL)) {
			hshAddress1  = (Hashtable) entry.getValue();
		}
		if (strName.equals(CityURL)) {
			hshCity  = (Hashtable) entry.getValue();
		}
		if (strName.equals(StateURL)) {
			hshState  = (Hashtable) entry.getValue();
		}
		if (strName.equals(CountryURL)) {
			hshCountry  = (Hashtable) entry.getValue();
		}
		if (strName.equals(ZipCodeURL)) {
			hshZipCode  = (Hashtable) entry.getValue();
		}
		if (strName.equals(PersonTitleURL)) {
			hshPersonTitle  = (Hashtable) entry.getValue();
		}	
	    }
	}

	String[][] PersonTitleOptions = (String[][])hshPersonTitle.get(ECUserConstants.EC_RB_OPTIONS);	

	AddressDataBean address = new AddressDataBean();

	UserRegistrationDataBean bnRegister = new UserRegistrationDataBean();
	com.ibm.commerce.beans.DataBeanManager.activate (bnRegister, request);

	StringBuffer mandatoryLineBuffer = new StringBuffer();

	if (((Boolean)hshFirstName.get(ECUserConstants.EC_RB_REQUIRED)).booleanValue()) {
		mandatoryLineBuffer.append("first");
	}
	if (((Boolean)hshMiddleName.get(ECUserConstants.EC_RB_REQUIRED)).booleanValue()) {
		mandatoryLineBuffer.append(",middle");
	}
	if (((Boolean)hshLastName.get(ECUserConstants.EC_RB_REQUIRED)).booleanValue()) {
		mandatoryLineBuffer.append(",last");
	}
	if (((Boolean)hshAddress1.get(ECUserConstants.EC_RB_REQUIRED)).booleanValue()) {
		mandatoryLineBuffer.append(",street");
	}
	if (((Boolean)hshCity.get(ECUserConstants.EC_RB_REQUIRED)).booleanValue()) {
		mandatoryLineBuffer.append(",city");
	}
	if (((Boolean)hshState.get(ECUserConstants.EC_RB_REQUIRED)).booleanValue()) {
		mandatoryLineBuffer.append(",state");
	}
	if (((Boolean)hshZipCode.get(ECUserConstants.EC_RB_REQUIRED)).booleanValue()) {
		mandatoryLineBuffer.append(",zip");
	}
	if (((Boolean)hshCountry.get(ECUserConstants.EC_RB_REQUIRED)).booleanValue()) {
		mandatoryLineBuffer.append(",country");
	}
	String mandatoryLine = mandatoryLineBuffer.toString();
	
	String error_password = ECMessageHelper.getMessage(ECMessage._ERR_PASSWORDS_NOT_SAME, null, cmdContext.getLocale());

%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">

<head>

<link rel="stylesheet" href="<%= UIUtil.getCSSFile(cmdContext.getLocale()) %>" type="text/css" />
<title><%= userNLS.get("Profile") %></title>
<script type="text/javascript"  src="/wcs/javascript/tools/csr/user.js">
</script>
<script type="text/javascript"  src="/wcs/javascript/tools/common/Util.js">
</script>

<script  type="text/javascript">
<%@ include file = "NameDisplay.jspf" %>


function compare()
{
   for (var i=0; i<document.profile.elements.length; i++)
   {
      var e = document.profile.elements[i];

      
      if (parent.get("userRegUpdated")=="false" && e.type=="radio" &&
      	e.name == "acStatus")
      {
     
      }
      		      
      if (parent.get("userRegUpdated")=="false" && e.type == "text" &&
          (e.name == "challengeQuestion" || e.name == "challengeAnswer"))
      {
        	if (e.name == "challengeQuestion" && e.value != "<%=UIUtil.toJavaScript(registerDataBean.getChallengeQuestion())%>")
           parent.put("userRegUpdated", "true");
        	if (e.name == "challengeAnswer" && e.value != "<%=UIUtil.toJavaScript(registerDataBean.getChallengeAnswer())%>")
           parent.put("userRegUpdated", "true");
 	
      }

      if (parent.get("userUpdated")=="false" && e.type == "select-one" && 
      	(e.name == "preferredLocale" || e.name == "preferredCurrency"))
      {
        if (e.name == "preferredLocale" && 
           e.options[e.selectedIndex].value != "<%=registerDataBean.getPreferredLanguage()%>"  &&
           !(e.options[e.selectedIndex].value == "" && ("<%=registerDataBean.getPreferredLanguage()%>" == "" || "<%=registerDataBean.getPreferredLanguage()%>" == "null")))
        	  parent.put("userUpdated", "true")
        	  
        if (e.name == "preferredCurrency" && 
           e.options[e.selectedIndex].value != "<%=registerDataBean.getPreferredCurrency()%>" &&
           !(e.options[e.selectedIndex].value == "" && ("<%=registerDataBean.getPreferredCurrency()%>" == "null" || "<%=registerDataBean.getPreferredCurrency()%>" == "")))
        	  parent.put("userUpdated", "true")        
      }

      if (parent.get("addressUpdated")=="false" && e.type == "text" &&
          (e.name == "lastName" || e.name == "firstName" || e.name == "middleName"))
      { 
        if (e.name == "lastName" && e.value != "<%=UIUtil.toJavaScript(address.getLastName())%>")
           parent.put("addressUpdated", "true");
        if (e.name == "firstName" && e.value != "<%=UIUtil.toJavaScript(address.getFirstName())%>")
           parent.put("addressUpdated", "true");
        if (e.name == "middleName" && e.value != "<%=UIUtil.toJavaScript(address.getMiddleName())%>")
           parent.put("addressUpdated", "true");
      }

      if (parent.get("addressUpdated")=="false" && e.type == "select-one" && e.name == "title")
      {
        if (e.options[e.selectedIndex].value != "<%=address.getPersonTitle()%>")
           parent.put("addressUpdated", "true");
      }
   }

  if (parent.get("userUpdated") == "true" || parent.get("addressUpdated") == "true"
  		|| parent.get("userRegUpdated")== "true" || parent.get("certStatusUpdated") == "true")
     return true;
  else
     return false;
}

function setStateChanged()
{
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
	var mM = "missingMandatoryField";

	var iFM = "inputFieldMax";	

	var code = parent.getErrorParams();
	if (code != null)
	{
		if (code.indexOf(mM) != -1)
		{
			alertDialog("<%=UIUtil.toJavaScript((String)userNLS.get("missingMandatoryData"))%>");
			code = code.split("_");
			
			if (code[1]=="lastName")
				document.profile.lastName.focus();
			else if (code[1]=="firstName")
				document.profile.firstName.focus();
			else if (code[1]=="middleName")
				document.profile.middleName.focus();
			else if (code[1]=="title")
				document.profile.title.focus();
		}
		else if (code.indexOf(iFM) != -1)
		{
			alertDialog("<%=UIUtil.toJavaScript((String)userNLS.get("inputFieldMax"))%>");
			code = code.split("_");
			
			if (code[1]=="lastName")
				document.profile.lastName.select();
			else if (code[1]=="firstName")
				document.profile.firstName.select(); 
			else if (code[1]=="middleName")
				document.profile.middleName.select();
			else if (code[1]=="challengeQuestion")
				document.profile.challengeQuestion.select();
			else if (code[1]=="challengeAnswer")
				document.profile.challengeAnswer.select();
		}
	}
}

function initializeState()
{
	 
   var profileInfo = parent.get("profileInfo");
     if (profileInfo != null)
      {
   
   	document.profile.newLogonId.value = profileInfo.logonId;
    	document.profile.pwd.value = profileInfo.password;
    	document.profile.pwd2.value = profileInfo.passwordConfirmation;
    
   	document.profile.challengeQuestion.value  = profileInfo.challengeQuestion;
   	document.profile.challengeAnswer.value    = profileInfo.challengeAnswer;
   	
           if (defined(document.profile.lastName))
         	document.profile.lastName.value    = profileInfo.lastName;
         if (defined(document.profile.firstName))	
         	document.profile.firstName.value   = profileInfo.firstName;
         if (defined(document.profile.middleName))	
         	document.profile.middleName.value  = profileInfo.middleName;
         
         for (var i=0; i<document.profile.acStatus.length; i++)
         {
         	if (document.profile.acStatus[i].value == profileInfo.acStatus)
         	{
         		document.profile.acStatus[i].checked = true;
         		break;
         	}
      }
      
      
      if (defined(document.profile.title))
      {
      	for (var i=0; i< document.profile.title.length; i++)
      	{
   			if (document.profile.title.options[i].value == profileInfo.title)
      		{
      	 	  	document.profile.title.options[i].selected = true;
         		break;
        	}
      	}
      }
      
      
      
      for (var i=0; i< document.profile.preferredLocale.length; i++)
      {
         if (document.profile.preferredLocale.options[i].value == profileInfo.preferredLocale)
         {
            document.profile.preferredLocale.options[i].selected = true;
            break;
         }
      }
      
      for (var i=0; i< document.profile.preferredCurrency.length; i++)
      {
         if (document.profile.preferredCurrency.options[i].value == profileInfo.preferredCurrency)
         {
            document.profile.preferredCurrency.options[i].selected = true;
            break;
         }
      }            
   }
   else
   {
   	// First time visit the page
   	document.profile.newLogonId.value = "<%=UIUtil.toJavaScript(registerDataBean.getLogonId())%>";
   	
   	document.profile.address_rn.value = "<%=address.getAddressId()%>";
   	
   	if (defined(document.profile.lastName))
      		document.profile.lastName.value    = "<%=UIUtil.toJavaScript(address.getLastName())%>";
      		
      	if (defined(document.profile.firstName))	
      		document.profile.firstName.value   = "<%=UIUtil.toJavaScript(address.getFirstName())%>";
      		
      	if (defined(document.profile.middleName))	
      		document.profile.middleName.value  = "<%=UIUtil.toJavaScript(address.getMiddleName())%>";

      
      if (defined(document.profile.title))
      {
      	for (var i=0; i< document.profile.title.length; i++)
      	{
      	   if (document.profile.title.options[i].value == "<%=address.getPersonTitle()%>")
      	   {
      	      document.profile.title.options[i].selected = true;
      	      break;
      	   }
      	}
      }
      
      if (defined(document.profile.acStatus)) {
       	document.profile.acStatus[0].checked = true;
      }
      
      
      document.profile.challengeQuestion.value  = "<%=UIUtil.toJavaScript(registerDataBean.getChallengeQuestion())%>";
      document.profile.challengeAnswer.value    = "<%=UIUtil.toJavaScript(registerDataBean.getChallengeAnswer())%>";
      
         
      for (var i=0; i< document.profile.preferredLocale.length; i++)
      {
         if (document.profile.preferredLocale.options[i].value == "<%=registerDataBean.getPreferredLanguage()%>")
         {
            document.profile.preferredLocale.options[i].selected = true;
            break;
         }
      }
      
      for (var i=0; i< document.profile.preferredCurrency.length; i++)
      {
         if (document.profile.preferredCurrency.options[i].value == "<%=registerDataBean.getPreferredCurrency()%>")
         {
            document.profile.preferredCurrency.options[i].selected = true;
            break;
         }
      }      

   }

   if (parent.get("userUpdated") == null)
      parent.put("userUpdated",           "false");
 
   if (parent.get("userRegUpdated") == null)
      parent.put("userRegUpdated",           "false");
   if (parent.get("userProfileUpdated") == null)
      parent.put("userProfileUpdated",           "false");      
   if (parent.get("certStatusUpdated") == null)
      parent.put("certStatusUpdated",           "false");      
   if (parent.get("addressUpdated") == null)
      parent.put("addressUpdated",           "false");
   if (parent.get("demographicsUpdated") == null)
      parent.put("demographicsUpdated",      "false");
   
   if (parent.get("changesMade") == null)
      parent.put("changesMade",      "false");
   
   var authToken = parent.get("authToken");
   if (!defined(authToken)) {
	parent.put("authToken", document.profile.authToken.value);
   }
   
   parent.setContentFrameLoaded(true);  
   displayValidationError(); 
}

function savePanelData()
{
	var undefinedFormVarValue="";
	if (parent.get("mandatoryFieldList") == null) {
	   var mandatoryFields = "<%=mandatoryLine%>";
	   
	   parent.put("mandatoryFields", mandatoryFields);
	   var mandatoryFieldList = mandatoryFields.split(",");
	   parent.put("mandatoryFieldList", mandatoryFieldList);
	}
	if (parent.get("missingMandatoryData") == null)
		parent.put("missingMandatoryData", "<%=UIUtil.toJavaScript((String)userNLS.get("missingMandatoryData"))%>");

	if (parent.get("inputFieldMax") == null)
		parent.put("inputFieldMax", "<%=UIUtil.toJavaScript((String)userNLS.get("inputFieldMax"))%>");

	
   	var profileInfo = new Object();
	profileInfo.pwdLength = <%=(String)XMLUtil.get(format,"password.maxiLength")%>;
	profileInfo.logonId = document.profile.newLogonId.value;

	profileInfo.sarfnbr = document.profile.address_rn.value;
	profileInfo.password = document.profile.pwd.value;
	profileInfo.passwordConfirmation = document.profile.pwd2.value;
		
	for (var i=0; i<document.profile.acStatus.length; i++)
	{
		if (document.profile.acStatus[i].checked == true)
		{
			profileInfo.acStatus = document.profile.acStatus[i].value;
			break;
		}
	}
 
   	profileInfo.preferredLocale = document.profile.preferredLocale.options[document.profile.preferredLocale.selectedIndex].value;
   	profileInfo.preferredCurrency = document.profile.preferredCurrency.options[document.profile.preferredCurrency.selectedIndex].value;   
   	profileInfo.challengeQuestion = document.profile.challengeQuestion.value;
   	profileInfo.challengeAnswer = document.profile.challengeAnswer.value;

   	if (defined(document.profile.lastName))
   		profileInfo.lastName =   document.profile.lastName.value;
      	
   	if (defined(document.profile.firstName))	
   		profileInfo.firstName =  document.profile.firstName.value;
   
   	if (defined(document.profile.middleName))	
   		profileInfo.middleName = document.profile.middleName.value;
      	
   	if (defined(document.profile.title.options))	
   		profileInfo.title = document.profile.title.options[document.profile.title.selectedIndex].value;   
      	
      	     	
	parent.put("profileInfo", profileInfo); 
	
	setStateChanged();

   return true;
}

function validatePanelData() 
{
	if (isInputStringEmpty(document.profile.newLogonId.value)) {
		alertDialog(parent.getValidationMissingRequiredFieldMessage());
		document.profile.newLogonId.focus();
		return false;
	}
	if (isInputStringEmpty(document.profile.pwd.value)) {
		alertDialog(parent.getValidationMissingRequiredFieldMessage());
		document.profile.pwd.focus();
		return false;
	}
	if (isInputStringEmpty(document.profile.pwd2.value)) {
		alertDialog(parent.getValidationMissingRequiredFieldMessage());
		document.profile.pwd2.focus();
		return false;
	}
	if (isInputStringEmpty(document.profile.lastName.value)) {
		alertDialog(parent.getValidationMissingRequiredFieldMessage());
		document.profile.lastName.focus();
		return false;
	}
	if (document.profile.pwd.value != document.profile.pwd2.value) {
		alertDialog("<%= error_password %>");
		return false;
	}
	
	return true;
}

function onSubmit()
{
	document.profile.submit();
}




</script>

</head>
<body class="content" onload="initializeState();">
<p>
</p>
<form name="profile" method="POST" id="profile">
	<input type="hidden" name="authToken" value="${authToken}" id="WC_CustomerNewPropertyProfileForm_FormInput_authToken"/>
	<input type="hidden" name="logonId" value="" id="CSRNewPropertyProfile_FormInput_logonId_In_profile_1" />
	<input type="hidden" name="address_rn" value="" id="CSRNewPropertyProfile_FormInput_address_rn_In_profile_1" />

<h1><%= userNLS.get("Profile") %></h1>
<table border="0" cellpadding="0" cellspacing="0" width="100%" id="CSRNewPropertyProfile_Table_1">
  <tr><th></th></tr>
  <tbody>

  		   <tr>
			<td valign="bottom" id="CSRNewPropertyProfile_TableCell_1"><%=userNLS.get("logonIdReq")%><br />
			     <label for="CSRNewPropertyProfile_FormInput_newLogonId_In_profile_1"><span style="display:none;"><%=UIUtil.toHTML((String)userNLS.get("logonIdReq"))%></span></label>
		  	     <input size="30" type="text" name="newLogonId" maxlength="64" id="CSRNewPropertyProfile_FormInput_newLogonId_In_profile_1" />
			</td>
		   </tr>
		   <tr>
			   <td valign="bottom" id="CSRNewPropertyProfile_TableCell_2"><%=userNLS.get("passwordReq")%><br />
			      <label for="CSRNewPropertyProfile_FormInput_pwd_In_profile_1"><span style="display:none;"><%=UIUtil.toHTML((String)userNLS.get("passwordReq"))%></span></label>
			      <input size="30" type="password" autocomplete="off" name="pwd" maxlength="68" id="CSRNewPropertyProfile_FormInput_pwd_In_profile_1" />
      			   </td>
      		   </tr>
      		   <tr>
      			   <td valign="bottom" id="CSRNewPropertyProfile_TableCell_3"><%=userNLS.get("passwordVerifyReq")%><br />
      			      <label for="CSRNewPropertyProfile_FormInput_pwd2_In_profile_1"><span style="display:none;"><%=UIUtil.toHTML((String)userNLS.get("passwordVerifyReq"))%></span></label>
		   	      <input size="30" type="password" autocomplete="off" name="pwd2" maxlength="68" id="CSRNewPropertyProfile_FormInput_pwd2_In_profile_1" />
      			   </td>
		   </tr>
	<tr><td id="CSRNewPropertyProfile_TableCell_4"><br /></td><td id="CSRNewPropertyProfile_TableCell_5"><br /></td></tr>

   <script type="text/javascript">displayNameItem()
</script>
   <tr><td id="CSRNewPropertyProfile_TableCell_6"><br /></td></tr>


   <tr>
  	   <td colspan="2" valign="bottom" id="CSRNewPropertyProfile_TableCell_7"><%=userNLS.get("challengeQuestion")%><br />
  	   <label for="CSRNewPropertyProfile_FormInput_challengeQuestion_In_profile_1"><span style="display:none;"><%=UIUtil.toHTML((String)userNLS.get("challengeQuestion"))%></span></label>
      <input size="74" type="text" name="challengeQuestion" maxlength="254" id="CSRNewPropertyProfile_FormInput_challengeQuestion_In_profile_1" />
      </td>
   </tr>
	<tr>
      <td colspan="2" valign="bottom" id="CSRNewPropertyProfile_TableCell_8"><%=userNLS.get("challengeAnswer")%><br />
      <label for="CSRNewPropertyProfile_FormInput_challengeAnswer_In_profile_1"><span style="display:none;"><%=UIUtil.toHTML((String)userNLS.get("challengeAnswer"))%></span></label>
      <input size="74" type="text" name="challengeAnswer" maxlength="254" id="CSRNewPropertyProfile_FormInput_challengeAnswer_In_profile_1" /></td>
   </tr>

  </tbody>
</table>
</form>

<%
}
catch (Exception e)
{
	e.printStackTrace();
}

%>

</body>
</html>



