<%--
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
            com.ibm.commerce.tools.xml.*"

%>

<%@include file="../common/common.jsp" %>

<%
try
{
	String userId = request.getParameter("shrfnbr");

	String locale = request.getParameter("locale");
	CommandContext cmdContext = (CommandContext)request.getAttribute("CommandContext");

	Hashtable formats = (Hashtable)ResourceDirectory.lookup("csr.nlsFormats");
	Hashtable format = (Hashtable)XMLUtil.get(formats, "nlsFormats."+ locale);

	if (format == null) 
	{
	   format = (Hashtable)XMLUtil.get(formats, "nlsFormats.default");
	} 

	Hashtable userNLS = (Hashtable)ResourceDirectory.lookup("csr.userNLS", cmdContext.getLocale());	


	// Assume one to one relationship between a user and X509 certificate
	String certStatus = "";
	CertificateX509ByUserIdListDataBean certificateX509DataBeanList = new CertificateX509ByUserIdListDataBean();
	certificateX509DataBeanList.setDataBeanKeyUserId(userId);
	DataBeanManager.activate(certificateX509DataBeanList, request);

	CertificateX509DataBean certificateList[] = null;
	certificateList = certificateX509DataBeanList.getCertificateX509ByUserIdList();

	int numCertificates = 0;
	numCertificates = certificateList.length;

	for (int i=0; i<numCertificates; i++)
	{
			CertificateX509DataBean certx509 = certificateList[i];
			certStatus = certx509.getStatus();
	}


	OptoolsRegisterDataBean registerDataBean = new OptoolsRegisterDataBean();
	registerDataBean.setUserId(userId); 
	DataBeanManager.activate(registerDataBean, request);

	ResourceBundleDataBean bnResourceBundle = new ResourceBundleDataBean();
	bnResourceBundle.setPropertyFileName("UserRegistration");
	DataBeanManager.activate(bnResourceBundle, request);

	String FirstNameURL = registerDataBean.getFirstNameURL();
	String MiddleNameURL = registerDataBean.getMiddleNameURL();
	String LastNameURL = registerDataBean.getLastNameURL();
	String Address1URL  = registerDataBean.getAddress1URL();
	String CityURL      = registerDataBean.getCityURL();
	String StateURL     = registerDataBean.getStateURL();
	String CountryURL   = registerDataBean.getCountryURL();
	String ZipCodeURL   = registerDataBean.getZipCodeURL();
	String PersonTitleURL = registerDataBean.getPersonTitleURL();

	Hashtable hshFirstName = new Hashtable();
	Hashtable hshMiddleName = new Hashtable();
	Hashtable hshLastName = new Hashtable();
	Hashtable hshAddress1  = new Hashtable();
	Hashtable hshCity      = new Hashtable();
	Hashtable hshState     = new Hashtable();
	Hashtable hshCountry   = new Hashtable();
	Hashtable hshZipCode   = new Hashtable();	
	Hashtable hshPersonTitle = new Hashtable();


	LanguageListDataBean bnLanguageList = new LanguageListDataBean();
	DataBeanManager.activate(bnLanguageList, request);
	String[][] PreferredLanguageOptions = bnLanguageList.getLanguageList();

	com.ibm.commerce.user.beans.CurrencyListDataBean bnCurrencyList = new com.ibm.commerce.user.beans.CurrencyListDataBean();
	DataBeanManager.activate(bnCurrencyList, request);
	String[][] PreferredCurrencyOptions = bnCurrencyList.getCurrencyList();

	String[][] PersonTitleOptions = null;

	String mandatoryLine = "";

	try { 
		SortedMap smpFields = bnResourceBundle.getPropertySortedMap();

		Iterator entryIterator = smpFields.entrySet().iterator();
		Map.Entry textentry = (Map.Entry) entryIterator.next();
		Hashtable hshText = (Hashtable) textentry.getValue();

		while (entryIterator.hasNext()) {
			Map.Entry entry = (Map.Entry) entryIterator.next();
			Hashtable hshField = (Hashtable) entry.getValue();

			String strName = (String) hshField.get("Name");


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
				PersonTitleOptions = (String[][])hshPersonTitle.get(ECUserConstants.EC_RB_OPTIONS);
			}	
		}

		if (((Boolean)hshFirstName.get(ECUserConstants.EC_RB_REQUIRED)).booleanValue())
			mandatoryLine += "first";
		if (((Boolean)hshMiddleName.get(ECUserConstants.EC_RB_REQUIRED)).booleanValue())
			mandatoryLine += ",middle";
		if (((Boolean)hshLastName.get(ECUserConstants.EC_RB_REQUIRED)).booleanValue())
			mandatoryLine += ",last";
		if (((Boolean)hshAddress1.get(ECUserConstants.EC_RB_REQUIRED)).booleanValue())
			mandatoryLine += ",street";
		if (((Boolean)hshCity.get(ECUserConstants.EC_RB_REQUIRED)).booleanValue())
			mandatoryLine += ",city";
		if (((Boolean)hshState.get(ECUserConstants.EC_RB_REQUIRED)).booleanValue())
			mandatoryLine += ",state";
		if (((Boolean)hshZipCode.get(ECUserConstants.EC_RB_REQUIRED)).booleanValue())
			mandatoryLine += ",zip";
		if (((Boolean)hshCountry.get(ECUserConstants.EC_RB_REQUIRED)).booleanValue())
			mandatoryLine += ",country";


	} catch (Exception e) {
	}

	UserRegistryDataBean userRegistry = null;

	try
	{
		userRegistry = new UserRegistryDataBean();
		userRegistry.setDataBeanKeyUserId(userId);
		DataBeanManager.activate(userRegistry, request);

		String status = userRegistry.getStatus();//may be obsolete
	}
	catch (Exception e)
	{
		userRegistry = null;
	}	

	String lastOrderTime = registerDataBean.getLastOrderTime();
	String registrationTime = registerDataBean.getRegistrationTime();
	String lastUpdateTime = registerDataBean.getRegistrationUpdateTime();
	String lastVisitTime = registerDataBean.getAttribute("lastSession");


	Hashtable hshRegister = bnResourceBundle.getPropertyHashtable();
	UserRegistrationDataBean bnRegister = new UserRegistrationDataBean();
	com.ibm.commerce.beans.DataBeanManager.activate (bnRegister, request);


	UIUtil convert = null;

%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">

<head>
<link rel="stylesheet" href="<%= UIUtil.getCSSFile(cmdContext.getLocale()) %>" type="text/css" />
<title><%= userNLS.get("profilePageTitle") %></title>
<script type="text/javascript" src="/wcs/javascript/tools/csr/user.js">
</script>
<script type="text/javascript" src="/wcs/javascript/tools/common/Util.js">
</script>

<script type="text/javascript">
<%@ include file = "NameDisplay.jspf" %>
var oldCertStatus = "<%=certStatus%>";

 
function validateCertStatusChange()
{
	var newCertStatus = document.profile.certStatus.options[document.profile.certStatus.selectedIndex].value;
	if (oldCertStatus == "" && newCertStatus != "")
	{
		alertDialog("<%=UIUtil.toJavaScript((String)userNLS.get("noCertToVRE"))%>");
		document.profile.certStatus.options[3].selected = true;
	}
	if (oldCertStatus != "" && newCertStatus == "")
	{
		alertDialog("<%=UIUtil.toJavaScript((String)userNLS.get("vREToNoCert"))%>");
      for (var i=0; i< document.profile.certStatus.length; i++)
      {
         if (document.profile.certStatus.options[i].value == oldCertStatus)
  	      {
            document.profile.certStatus.options[i].selected = true;
            break;
         }
      }		
	}	
}
	

function compare()
{
   for (var i=0; i<document.profile.elements.length; i++)
   {
      var e = document.profile.elements[i];

		if (parent.get("certStatusUpdated")=="false" && e.type=="select-one" &&
			e.name == "certStatus")
		{
         if (e.name == "certStatus" && e.options[e.selectedIndex].value != "<%=certStatus%>")
        		parent.put("certStatusUpdated", "true");
		}
      
      if (parent.get("userRegUpdated")=="false" && e.type=="radio" &&
      	e.name == "acStatus")
      {
      <% if (userRegistry != null)
      	{
      %>
      	if (e.checked == true && e.value != "<%=userRegistry.getStatus()%>")
      		parent.put("userRegUpdated", "true");
      <% }
      %>
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
        if (e.name == "lastName" && e.value != "<%=UIUtil.toJavaScript(registerDataBean.getLastName())%>")
           parent.put("addressUpdated", "true");
        if (e.name == "firstName" && e.value != "<%=UIUtil.toJavaScript(registerDataBean.getFirstName())%>")
           parent.put("addressUpdated", "true");
        if (e.name == "middleName" && e.value != "<%=UIUtil.toJavaScript(registerDataBean.getMiddleName())%>")
           parent.put("addressUpdated", "true");
      }

      if (parent.get("addressUpdated")=="false" && e.type == "select-one" && e.name == "title")
      {
        if (e.options[e.selectedIndex].value != "<%=registerDataBean.getPersonTitle()%>")
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

	document.profile.logonId.value = profileInfo.logonId;
   	   	
   	document.profile.address_rn.value = profileInfo.sarfnbr;
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
   	document.profile.logonId.value = "<%=UIUtil.toJavaScript(registerDataBean.getLogonId())%>";
   	
   	document.profile.address_rn.value = "<%=registerDataBean.getAddressId()%>";
   	
   	if (defined(document.profile.lastName))
      		document.profile.lastName.value    = "<%=UIUtil.toJavaScript(registerDataBean.getLastName())%>";
      		
      	if (defined(document.profile.firstName))	
      		document.profile.firstName.value   = "<%=UIUtil.toJavaScript(registerDataBean.getFirstName())%>";
      		
      	if (defined(document.profile.middleName))	
      		document.profile.middleName.value  = "<%=UIUtil.toJavaScript(registerDataBean.getMiddleName())%>";

	

		<% if (userRegistry != null)
		{
		%>
      for (var i=0; i<document.profile.acStatus.length; i++)
      {
      	if (document.profile.acStatus[i].value == "<%=userRegistry.getStatus()%>")
      	{
      		document.profile.acStatus[i].checked = true;
      		break;
      	}
      }
      <%
      }
      %>
      
      if (defined(document.profile.title))
      {
      	for (var i=0; i< document.profile.title.length; i++)
      	{
      	   if (document.profile.title.options[i].value == "<%=registerDataBean.getPersonTitle()%>")
      	   {
      	      document.profile.title.options[i].selected = true;
      	      break;
      	   }
      	}
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
   
   parent.setContentFrameLoaded(true);  
   displayValidationError(); 
}

function savePanelData()
{

	var undefinedFormVarValue="";
	if (parent.get("mandatoryFieldList") == null) {
	   var mandatoryFields = "<%=mandatoryLine%>";
	   
	   //just added
	   //alertDialog("mandatory field line: " + mandatoryFields);
	   
	 	parent.put("mandatoryFields", mandatoryFields);
	   var mandatoryFieldList = mandatoryFields.split(",");
		parent.put("mandatoryFieldList", mandatoryFieldList);
	}
	if (parent.get("missingMandatoryData") == null)
		parent.put("missingMandatoryData", "<%=UIUtil.toJavaScript((String)userNLS.get("missingMandatoryData"))%>");

	if (parent.get("inputFieldMax") == null)
		parent.put("inputFieldMax", "<%=UIUtil.toJavaScript((String)userNLS.get("inputFieldMax"))%>");

	//just added
	//alertDialog("DEBUG: saveState is called");
   var profileInfo = new Object();
	profileInfo.pwdLength = <%=(String)XMLUtil.get(format,"password.maxiLength")%>;
	profileInfo.logonId = document.profile.logonId.value;

	profileInfo.sarfnbr = document.profile.address_rn.value;
	
	//just added
	//alertDialog("sarfnbr: " + profileInfo.sarfnbr);
	
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
	
	//just added
	//alertDialog("before setStateChanged");
	
	setStateChanged();

	//just added
	//alertDialog("after setStateChanged");
   return true;
}

function onSubmit()
{
	//just added
	//alertDialog("onSubmit");
	
	document.profile.submit();
}




</script>

</head>
<body class="content" onload="initializeState();">
<p>
</p>
<form name="profile" method="POST" id="profile">
	<label for="PropertyProfile_FormInput_logonId_In_profile_1"><span style='display:none;'><%=userNLS.get("logonid")%></span></label>
	<input type="hidden" name="logonId" value="" id="PropertyProfile_FormInput_logonId_In_profile_1" />
	<label for="PropertyProfile_FormInput_address_rn_In_profile_1"><span style='display:none;'><%=userNLS.get("address")%></span></label>
	<input type="hidden" name="address_rn" value="" id="PropertyProfile_FormInput_address_rn_In_profile_1" />

<h1><%= userNLS.get("Profile") %></h1>
<table border="0" cellpadding="0" cellspacing="0" width="100%" id="PropertyProfile_Table_1">
  <tr><th></th></tr>
  <tbody>
    <tr>
  		<td valign="bottom" id="PropertyProfile_TableCell_1"><%=userNLS.get("logonid")%>
  		 	<i><%=UIUtil.toHTML(registerDataBean.getLogonId()) %></i>
		</td>

	</tr>
	<tr><td id="PropertyProfile_TableCell_2"><br /></td><td id="PropertyProfile_TableCell_3"><br /></td></tr>

    <script type="text/javascript">displayNameItem()
</script>

      <tr><td id="PropertyProfile_TableCell_4"><br /></td></tr>
   <tr>
  	   <td colspan="2" valign="bottom" id="PropertyProfile_TableCell_5"><%=userNLS.get("challengeQuestion")%><br />
      <label for="PropertyProfile_FormInput_challengeQuestion_In_profile_1"><span style='display:none;'><%=userNLS.get("challengeQuestion")%></span></label>
      <input size="74" type="text" name="challengeQuestion" maxlength="254" id="PropertyProfile_FormInput_challengeQuestion_In_profile_1" />
      </td>
   </tr>
	<tr>
      <td colspan="2" valign="bottom" id="PropertyProfile_TableCell_6"><%=userNLS.get("challengeAnswer")%><br />
      <label for="PropertyProfile_FormInput_challengeAnswer_In_profile_1"><span style='display:none;'><%=userNLS.get("challengeAnswer")%></span></label>
      <input size="74" type="text" name="challengeAnswer" maxlength="254" id="PropertyProfile_FormInput_challengeAnswer_In_profile_1" /></td>
   </tr>
    <tr>
      <td id="PropertyProfile_TableCell_7">
      <table summary="<%= userNLS.get("timestampTableSummary") %>" border="0" width="100%">
        <tbody>
        	 <tr><td id="PropertyProfile_TableCell_8"><br /></td><td id="PropertyProfile_TableCell_9"><br /></td></tr>

          <tr>
            <td valign="bottom" id="PropertyProfile_TableCell_10"><%=userNLS.get("lastVisit")%>
            <i>
                  <%	if((lastVisitTime == null) || lastVisitTime.equals("")) { %>
                        <%=userNLS.get("notAvailable")%>
                  <%    } else { 
                          	String DateTime = TimestampHelper.getDateTimeFromTimestamp(ECStringConverter.StringToTimestamp(lastVisitTime), cmdContext.getLocale());                                
                  %>
                          <%= DateTime %>      
                  <%    } %>



            </i></td>
          </tr>
          <tr>
            <td valign="bottom" id="PropertyProfile_TableCell_11"><%=userNLS.get("lastUpdated")%>
            <i>
			<%	if((lastUpdateTime == null) || lastUpdateTime.equals("")) { %>
                        	<%=userNLS.get("notAvailable")%>
                  	<%    } else { 
                          	String DateTime = TimestampHelper.getDateTimeFromTimestamp(ECStringConverter.StringToTimestamp(lastUpdateTime), cmdContext.getLocale());
                  	%>
                          <%= DateTime %>      
                  <%    } %>


            </i></td>
          </tr>
        </tbody>
      </table>
      </td>
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



