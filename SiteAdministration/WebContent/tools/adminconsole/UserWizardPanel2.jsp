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
<%@ page language="java" %>

<%@ page import="java.io.*" %>
<%@ page import="java.lang.*" %>
<%@ page import="java.math.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="javax.servlet.*" %>
<%@ page import="com.ibm.commerce.base.objects.*" %>
<%@ page import="com.ibm.commerce.beans.*" %>
<%@ page import="com.ibm.commerce.common.beans.*" %>
<%@ page import="com.ibm.commerce.command.*" %>
<%@ page import="com.ibm.commerce.datatype.*" %>
<%@ page import="com.ibm.commerce.server.*" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.tools.xml.*" %>
<%@ page import="com.ibm.commerce.user.beans.*"   %>
<%@ page import="com.ibm.commerce.user.objects.*"   %>
<%@ page import="com.ibm.commerce.usermanagement.commands.*"   %>
<%@ page import="com.ibm.commerce.utils.TimestampHelper" %>
<%@ page import="com.ibm.commerce.member.constants.ECMemberConstants" %>

<%@ include file= "../common/common.jsp" %>

<%
   CommandContext cmdContext = (CommandContext)request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
   Locale locale = cmdContext.getLocale();
   String webalias = UIUtil.getWebPrefix(request);

   // obtain the resource bundle for display
   Hashtable userWizardNLS = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("adminconsole.AdminConsoleNLS", locale);
   Hashtable securityNLS = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("adminconsole.SecurityNLS", locale);
   if (userWizardNLS == null) System.out.println("!!!! RS is null");

   String userGeneralLogonIdEmpty = UIUtil.toJavaScript((String)userWizardNLS.get("userGeneralLogonIdEmpty"));
   String userGeneralLastNameEmpty = UIUtil.toJavaScript((String)userWizardNLS.get("userGeneralLastNameEmpty"));
   String userGeneralPasswordEmpty = UIUtil.toJavaScript((String)userWizardNLS.get("userGeneralPasswordEmpty"));
   String userPassLength = UIUtil.toJavaScript((String)userWizardNLS.get("userPassLength"));

   String userGeneralPasswordNotMatched = UIUtil.toJavaScript((String)userWizardNLS.get("userGeneralPasswordNotMatched"));
   String userGeneralLogonIdUpdateFailed = UIUtil.toJavaScript((String)userWizardNLS.get("userGeneralLogonIdUpdateFailed"));
   String userGeneralAdminTypeUpdateFailed = UIUtil.toJavaScript((String)userWizardNLS.get("userGeneralAdminTypeUpdateFailed"));
   String AdminConsoleExceedMaxLength = UIUtil.toJavaScript((String)userWizardNLS.get("AdminConsoleExceedMaxLength"));

   String localeUsed = locale.toString();
   com.ibm.commerce.server.JSPHelper jspHelper1 = new JSPHelper(request);
   String xmlFileParm = jspHelper1.getParameter("ActionXMLFile");
   Hashtable xmlTree = (Hashtable)ResourceDirectory.lookup(xmlFileParm);

   Hashtable localeNameFormat = (Hashtable)XMLUtil.get(xmlTree, "nlsNameFormats."+ localeUsed);
   if (localeNameFormat == null)
   {
     localeNameFormat = (Hashtable)XMLUtil.get(xmlTree, "nlsNameFormats.default");
   }

   boolean displayLastNameFirst = false;
   boolean displayTitle = false;
   boolean displayMiddleName = false;
   int displayLastNamePos = 0;
   int displayFirstNamePos = 0;

   String nameFormatStr = (String)XMLUtil.get(localeNameFormat,"name.fields");
   if (nameFormatStr != null)
   {
     String[] nameFormatFields = Util.tokenize(nameFormatStr, ",");


     for (int i=0; i < nameFormatFields.length; i++)
     {
       if ( nameFormatFields[i].equals("title") )
         displayTitle = true;
       else if ( nameFormatFields[i].equals("middleName") )
         displayMiddleName = true;
       else if ( nameFormatFields[i].equals("lastName") )
         displayLastNamePos = i;
       else if ( nameFormatFields[i].equals("firstName") )
         displayFirstNamePos = i;
     }
     if (displayLastNamePos < displayFirstNamePos)
       displayLastNameFirst = true;
   }
  
   UserRegistryDataBean urdb = new UserRegistryDataBean();
   UserRegistrationDataBean urdb2 = new UserRegistrationDataBean();
   String memberId2 = request.getParameter("memberId");
   if(!(memberId2 == null || memberId2.trim().length()==0)) 
   {
     
     urdb2.setDataBeanKeyMemberId(memberId2);
     DataBeanManager.activate(urdb2, request);
     
     urdb.setInitKey_userId(memberId2);
   }
   
   PolicyAccountDataBean padb = new PolicyAccountDataBean();
   padb.setCommandContext(cmdContext);

   Vector accPolList = padb.getPolicyAcct(); 
   
   ResourceBundleDataBean bnResourceBundle = new ResourceBundleDataBean();
   bnResourceBundle.setPropertyFileName("UserRegistration_" + locale);
   DataBeanManager.activate(bnResourceBundle, request);

   SortedMap smpFields = bnResourceBundle.getPropertySortedMap();
   Iterator entryIterator = smpFields.entrySet().iterator();
   Map.Entry textentry = (Map.Entry) entryIterator.next();
   
   Hashtable hshAddress1  = new Hashtable();
   Hashtable hshCity      = new Hashtable();
   Hashtable hshState     = new Hashtable();
   Hashtable hshCountry   = new Hashtable();
   Hashtable hshZipCode   = new Hashtable();
   
   String Address1URL  = urdb2.getAddress1URL();
   String CityURL      = urdb2.getCityURL();
   String StateURL     = urdb2.getStateURL();
   String CountryURL   = urdb2.getCountryURL();
   String ZipCodeURL   = urdb2.getZipCodeURL();
   
   while (entryIterator.hasNext()) {
	Map.Entry entry = (Map.Entry) entryIterator.next();
	Hashtable hshField = (Hashtable) entry.getValue();
	String strName = (String) hshField.get("Name");
		
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
	
   }
   
   
   String mandatoryLine = "";
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
%>  


<html>
<head>
<%= fHeader%>
<link rel=stylesheet href="<%= UIUtil.getCSSFile(cmdContext.getLocale()) %>" type="text/css">
<TITLE><%=UIUtil.toHTML((String)userWizardNLS.get("userGeneralUserInfo"))%></TITLE>

<script LANGUAGE="JavaScript1.2" SRC="<%=webalias%>javascript/tools/common/SwapList.js"></script>
<SCRIPT SRC="<%=webalias%>javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT>


////////////////////////////////////////////////
// Load data from state of info for this page
// add them to the GUI
///////////////////////////////////////////////

function initializeState()
{
    //alertDialog("initialize state");
 
  if(parent.get("logonId") != null) {

  //alertDialog("logon id is NOT null, getting information from parent");

  var title = parent.get("personTitle");
  if(title != null) {
    document.wizard1.title.value = title;
  }

  var firstname = parent.get("firstName");
  if(firstname != null) {
    document.wizard1.firstname.value = firstname;
  }

  var middlename = parent.get("middleName");
  if(middlename != null) {
    document.wizard1.init.value = middlename;
  }

  var lastname = parent.get("lastName");
  if(lastname != null) {
    document.wizard1.lastname.value = lastname;
  }

  var logonid = parent.get("logonId");
  if(parent.get("operation") == "create") {
    document.wizard1.logonid.value = logonid;
  }
  
  var status = parent.get("<%=ECUserConstants.EC_UREG_USERSTATUS%>");
  for (var k=0; k < document.wizard1.AccStat.length; k++) {
      if (document.wizard1.AccStat[k].value == status) {
          document.wizard1.AccStat[k].selected = true;
          break;
      }
  }

  

  var password = parent.get("logonPassword");
  if(password != null) {
    document.wizard1.password.value = password;
  }

  var confirm = parent.get("logonPassword");
  if(confirm != null) {
    document.wizard1.confirm.value = confirm;
  }

  var chQuestion = parent.get("challengeQuestion");
  if(chQuestion != null) {
    document.wizard1.chQuestion.value = chQuestion;
  }

  var chAnswer = parent.get("challengeAnswer");
  if(chAnswer != null) {
    document.wizard1.chAnswer.value = chAnswer;
   }
   
  var accPol = parent.get("<%=ECUserConstants.EC_UREG_POLICYACCOUNTID%>");
  if (accPol != null) {
    for (var i=0; i < document.wizard1.SelectPol.length; i++) {
        if (document.wizard1.SelectPol[i].value == accPol) {
            document.wizard1.SelectPol[i].selected = true;
            break;
        }
    }
  }

  }


  else {

  	//alertDialog("logon id is null, initializing databean");

<%

        String memberId = request.getParameter("memberId");

       if(memberId == null || memberId.trim().length()==0) {
       
%>
	//alertDialog("Creating new user...");

<%
	   // *** Change this to default to dummy user ***
	   //System.out.println("memberId is null, defaulting to ncadmin");
	  //out.println("  parent.put(\"memberId\", \"-1000\"); ");
%>
	//alertDialog("0 is put into memberId in model");


<%
     	   out.println("  parent.put(\"operation\", \"create\"); ");
	}
	else {
%>
	//alertDialog("Updating existing user...");
<%
	   //System.out.println("memberId is NOT null = " + memberId);
	   out.println("  parent.put(\"memberId\", \"" + UIUtil.toJavaScript(memberId) + "\"); ");	
           out.println("  parent.put(\"operation\", \"update\"); ");     



	if(urdb2.getPersonTitle() != null && displayTitle) {
   		out.println("  document.wizard1.title.value = \"" + urdb2.getPersonTitle() + "\"; ");
	}
	if(urdb2.getFirstName() != null) {
		out.println("  document.wizard1.firstname.value = \"" + urdb2.getFirstName() + "\"; ");
	}

	if(urdb2.getMiddleName() != null && displayMiddleName) {
		out.println("  document.wizard1.init.value = \"" + urdb2.getMiddleName() + "\"; ");
	}
	if(urdb2.getLastName() != null) {
		out.println("  document.wizard1.lastname.value = \"" + urdb2.getLastName() + "\"; ");
	}
	if(urdb2.getLogonId() != null) {
		out.println("  parent.put(\"logonId\", \"" + urdb2.getLogonId() + "\"); ");
	}
	if(urdb2.getRegisterType() != null) {
		out.println("  parent.put(\"registerType\", \"" + urdb2.getRegisterType() + "\"); ");
	}
	out.println("  document.wizard1.password.value = \"" + ECMemberConstants.EC_DB_DUMMY_LOGONPASSWORD + "\"; ");
	out.println("  document.wizard1.confirm.value = \"" + ECMemberConstants.EC_DB_DUMMY_LOGONPASSWORD + "\"; ");
	if(urdb2.getChallengeQuestion() != null) {
		out.println("  document.wizard1.chQuestion.value = \"" + urdb2.getChallengeQuestion() + "\"; ");
	}
	if(urdb2.getChallengeAnswer() != null) {
		out.println("  document.wizard1.chAnswer.value = \"" + urdb2.getChallengeAnswer() + "\"; ");
	}
	
	if(urdb2.getChallengeAnswer() != null) {
		out.println("  document.wizard1.chAnswer.value = \"" + urdb2.getChallengeAnswer() + "\"; ");
	}

	//System.out.println("urdb2 get logon id = " + urdb2.getLogonId());
%>
	for (var i=0; i < document.wizard1.SelectPol.length; i++) {
	    var x = '<%=urdb.getPolicyAccountId()%>';
            if (document.wizard1.SelectPol[i].value == x) {
                document.wizard1.SelectPol[i].selected = true;
                break;
            }
        }
        
        for (var j=0; j < document.wizard1.AccStat.length; j++) {
	    var x = "<%=urdb.getStatus()%>";
	    if (document.wizard1.AccStat[j].value == x) {
                document.wizard1.AccStat[j].selected = true;
                break;
            }
        }

<%	}%>
  }

   parent.setContentFrameLoaded(true);

}


/////////////////////////////////////////////////////////////////////////////
// This function will validate the entry fields for this page before wizard
// goes to the next or previous page. This function will also be used to
// restore the user changes to the state of info
/////////////////////////////////////////////////////////////////////////////
function savePanelData()
{

   var mandatoryFields = "<%=mandatoryLine%>";
   parent.put("mandatoryFields", mandatoryFields);
   
<%
  if(!(memberId2 == null || memberId2.trim().length()==0)) {
%>
   parent.put("<%=ECUserConstants.EC_USERID%>", "<%=UIUtil.toJavaScript(memberId2)%>");
   parent.put("redirecturl","NotebookNavigation");
<%} else {%>
   parent.put("redirecturl","WizardNavigation");
<%}%>
  
   
  //alertDialog("UserWizard Panel2 save panel data");
<%
  if (displayTitle) {
%>
  if(document.wizard1.title.value != parent.get("personTitle")) {
    parent.put("personTitle", document.wizard1.title.value);
  }
<%
   }

  if (displayMiddleName) {
%>
  if(document.wizard1.init.value != parent.get("middleName")) {
    parent.put("middleName", document.wizard1.init.value);
  }
<%
   }
%>

  if(document.wizard1.firstname.value != parent.get("firstName")) {
    parent.put("firstName", document.wizard1.firstname.value);
  }

  if(document.wizard1.lastname.value != parent.get("lastName")) {	
    parent.put("lastName", document.wizard1.lastname.value);
  }
  if(parent.get("operation")=="create") {
     parent.put("logonId", document.wizard1.logonid.value);
  }
 
  if(document.wizard1.password.value != parent.get("logonPassword")) {
    var pass = document.wizard1.password.value;
    //alertDialog("password = " + pass);
    parent.put("logonPassword", document.wizard1.password.value);
  }
  
  if(document.wizard1.confirm.value != parent.get("logonPasswordVerify")) {
    var passVer = document.wizard1.confirm.value;
    //alertDialog("password = " + pass);
    parent.put("logonPasswordVerify", document.wizard1.confirm.value);
  }
  if(document.wizard1.chQuestion.value != parent.get("challengeQuestion")) {
    parent.put("challengeQuestion", document.wizard1.chQuestion.value);
  }
  if(document.wizard1.chAnswer.value != parent.get("challengeAnswer")) {
    parent.put("challengeAnswer", document.wizard1.chAnswer.value);
  }
  
  var index = document.wizard1.SelectPol.selectedIndex;
  parent.put("<%=ECUserConstants.EC_UREG_POLICYACCOUNTID%>", document.wizard1.SelectPol[index].value);
  
  parent.put("profileType", "<%=ECUserConstants.EC_USER_PROFILE_BUSINESS%>");
  
  var index2 = document.wizard1.AccStat.selectedIndex;
  parent.put("<%=ECUserConstants.EC_UREG_USERSTATUS%>",document.wizard1.AccStat[index2].value);

}
 
function validatePanelData()
{
  
  if (isEmpty(document.wizard1.lastname.value))
  {
      alertDialog("<%= userGeneralLastNameEmpty %>");
      return false;
  } 

  if (parent.get("operation")=="create" && isEmpty(document.wizard1.logonid.value))
  {
      alertDialog("<%= userGeneralLogonIdEmpty %>");
      return false;
  } 

  if (parent.get("operation")=="create" && isEmpty(document.wizard1.password.value))
  {
      alertDialog("<%= userGeneralPasswordEmpty %>");
      return false;
  }

  if (document.wizard1.password.value != document.wizard1.confirm.value) {
      
      alertDialog("<%= userGeneralPasswordNotMatched %>");
      return false;
  }

<%
  if (displayTitle) {
%>
 	if(!isValidUTF8length(document.wizard1.title.value, 50))
  	{
		document.wizard1.title.select();
      		alertDialog("<%= AdminConsoleExceedMaxLength %>");
      		return false;
	}
<%
  }
%>

  	if (!isValidUTF8length(document.wizard1.firstname.value, 128))
  	{
		document.wizard1.firstname.select();
      		alertDialog("<%= AdminConsoleExceedMaxLength %>");
      		return false;
  	}

<%
  if (displayMiddleName) {
%>
	if (!isValidUTF8length(document.wizard1.init.value, 128))
  	{
                document.wizard1.init.select();
      		alertDialog("<%= AdminConsoleExceedMaxLength %>");
      		return false;
	}
<%
  }
%>

  if (!isValidUTF8length(document.wizard1.lastname.value, 128))
  {
      document.wizard1.lastname.select();
      alertDialog("<%= AdminConsoleExceedMaxLength %>");
      return false;
  }

  if (parent.get("operation")=="create" && !isValidUTF8length(document.wizard1.logonid.value, 254))
  {
      document.wizard1.logonid.select();
      alertDialog("<%= AdminConsoleExceedMaxLength %>");
      return false;
  }

  if (!isValidUTF8length(document.wizard1.password.value, 70))
  {
      document.wizard1.password.select();
      alertDialog("<%= AdminConsoleExceedMaxLength %>");
      return false;
  }

  if (!isValidUTF8length(document.wizard1.confirm.value, 70))
  {
      document.wizard1.confirm.select();
      alertDialog("<%= AdminConsoleExceedMaxLength %>");
      return false;
  }

  if (!isValidUTF8length(document.wizard1.chQuestion.value, 254))
  {
      document.wizard1.chQuestion.select();
      alertDialog("<%= AdminConsoleExceedMaxLength %>");
      return false;
  }

  if (!isValidUTF8length(document.wizard1.chAnswer.value, 254))
  {
      document.wizard1.chAnswer.select();
      alertDialog("<%= AdminConsoleExceedMaxLength %>");
      return false;
  }

   return true;
}

function printTitle()
{
      document.write("<LABEL>");
      document.write("<%=UIUtil.toHTML((String)userWizardNLS.get("userGeneralTitle"))%><BR>");
      document.write("<INPUT size=\"30\" type=\"input\" name=\"title\">");
      document.write("</LABEL>");
}

function printFirstName()
{
      document.write("<LABEL>");
      document.write("<%=UIUtil.toHTML((String)userWizardNLS.get("userGeneralFirstName"))%><BR>");
      document.write("<INPUT size=\"30\" type=\"input\" name=\"firstname\">");
      document.write("</LABEL>");
}

function printInit()
{
	document.write("<LABEL>");
	document.write("<%=UIUtil.toHTML((String)userWizardNLS.get("userGeneralInitial"))%><BR>");
	document.write("<INPUT size=\"32\" type=\"input\" name=\"init\">");
	document.write("</LABEL>");
}

function printLastName()
{
      document.write("<LABEL>");
      document.write("<%=UIUtil.toHTML((String)userWizardNLS.get("userGeneralLastNameReq"))%><BR>");
      document.write("<INPUT size=\"30\" type=\"input\" name=\"lastname\">");
      document.write("</LABEL>");
}

function validateNoteBookPanel() 
{
    return validatePanelData();
}




</SCRIPT>
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

</head>
<BODY ONLOAD="initializeState();" class="content">
<H1><%=UIUtil.toHTML((String)userWizardNLS.get("userGeneralUserInfo"))%></H1>


<FORM NAME="wizard1">
<table border=0 summary="<%=UIUtil.toHTML((String)userWizardNLS.get("AdminConsoleTableSumUserAdminGeneral"))%>">
<%
   if (displayTitle) 
   {
%>
     <script language="javascript">
	document.write("<TR><TD>");
	printTitle();
	document.write("</TD></TR>");
     </script>
<%
   }

   if (displayLastNameFirst) 
   {
%>
     <script language="javascript">
	document.write("<TR><TD>");
	printLastName();
	document.write("</TD></TR>");
     </script>
<%
   }
%>

     <script language="javascript">
	document.write("<TR><TD>");
	printFirstName();
	document.write("</TD>");
     </script>

<%
   if (displayMiddleName) 
   {
%>
     <script language="javascript">
	document.write("<TD>");
	printInit();
	document.write("</TD>");
     </script>
<%
   }
%>

     <script language="javascript">
	document.write("</TR>");
     </script>

<%
   if (!displayLastNameFirst) 
   {
%>
     <script language="javascript">
	document.write("<TR><TD>");
	printLastName();
	document.write("</TD></TR>");
     </script>
<%
   }
%>

<TR>
<TD>

<%
        String logonTemp = request.getParameter("memberId");
        if(logonTemp == null || logonTemp.trim().length()==0) {
%>
      	        <LABEL>
         	<%=UIUtil.toHTML((String)userWizardNLS.get("userGeneralLogonIdReq"))%><BR>
		<INPUT size="30" type="input" name="logonid">
      	        </LABEL>
	        </TD>
<%
        }
	else {
%>

                <%=UIUtil.toHTML((String)userWizardNLS.get("userGeneralLogonId"))%>:
<%
	        if(urdb2.getLogonId() != null) {
		       out.println("<i>" + urdb2.getLogonId() + "</i><BR>");
		}
	}
%>

</TD>

</TR>



<TR>
<TD>
      <LABEL for="password">
<%
       String passwordTemp = request.getParameter("memberId");
       if(passwordTemp == null || passwordTemp.trim().length()==0) {
%>
	<%=UIUtil.toHTML((String)userWizardNLS.get("userGeneralPasswordReq"))%>
<%
	} else {
%>	
	<%=UIUtil.toHTML((String)userWizardNLS.get("userGeneralPassword"))%>	
<% } %>
      </LABEL>
</TD>
<TD>
      <LABEL for="confirm">
<%
       String confirmTemp = request.getParameter("memberId");
       if(confirmTemp == null || confirmTemp.trim().length()==0) {
%>
	<%=UIUtil.toHTML((String)userWizardNLS.get("userGeneralConfirmationReq"))%>
<%
	} else {
%>	
	<%=UIUtil.toHTML((String)userWizardNLS.get("userGeneralConfirmation"))%>
<% } %>
	</LABEL>
</TD>
</TR>

<TR>
<TD>
      <INPUT size="30" type="password" name="password" id="password">
</TD>
<TD>
      <INPUT size="32" type="password" name="confirm" id="confirm">
</TD>
</TR>
<TR>
<TD>
      <LABEL>
      <%=UIUtil.toHTML((String)userWizardNLS.get("userGeneralchQuestion"))%><BR>
      <INPUT size="30" type="input" name="chQuestion">
      </LABEL>
</TD>
<TD>
      <LABEL>
      <%=UIUtil.toHTML((String)userWizardNLS.get("userGeneralchAnswer"))%><BR>
      <INPUT size="32" type="input" name="chAnswer">
      </LABEL>
</TD>
</TR>
<TR>
<TD><LABEL for="SelectPol1"><%=UIUtil.toHTML((String)securityNLS.get("secAcctPolicy"))%></LABEL><BR>
<SELECT NAME="SelectPol" id="SelectPol1">

		<%for (int m=0; m < accPolList.size(); m++) {
		    Vector temp = (Vector) accPolList.elementAt(m);
		    String accId = (String) temp.elementAt(0);
		    String accDesc = (String) temp.elementAt(1);
		    %>

		<OPTION  VALUE="<%=accId%>"><%=accDesc%></OPTION>
		<%}%>
		

	      </SELECT>   
</TD></TR>	  

<TR>
<TD><LABEL for="AccStat1"><%=UIUtil.toHTML((String)userWizardNLS.get("userGeneralAccStat"))%></LABEL><BR>
<SELECT NAME="AccStat" id="AccStat1">

		<OPTION  VALUE="1"><%=UIUtil.toHTML((String)userWizardNLS.get("enable"))%></OPTION>
		<OPTION  VALUE="0"><%=UIUtil.toHTML((String)userWizardNLS.get("disable"))%></OPTION>
		

	      </SELECT>   
</TD></TR>	  
<TR><TD><BR><TD></TR>

</table>

<%
        String dateTemp = request.getParameter("memberId");

       if(dateTemp != null && dateTemp.trim().length()!=0) {
%>

<table>
<TR>
<TD>	<%=UIUtil.toHTML((String)userWizardNLS.get("userGeneralRegistration"))%>: 
</TD>
<%
	if(urdb2.getRegistration() != null && urdb2.getRegistration().trim().length()!=0) {
%>
<TD>		<% out.println("<i>"); %>
		<% 
			Timestamp t3 = Timestamp.valueOf(urdb2.getRegistration());
		   	String adjustedDate3 = TimestampHelper.getDateFromTimestamp(t3, locale);
			out.println(adjustedDate3 + " ");
			String adjustedTime3 = TimestampHelper.getTimeFromTimestamp(t3);
			out.println(adjustedTime3);
		%>
		<% out.println("</i>"); %>
</TD>
<%
	}
%>
</TR>

<TR>
<TD>	<%=UIUtil.toHTML((String)userWizardNLS.get("userGeneralLastVisit"))%>: 
</TD>
<%
	if(urdb2.getLastSession() != null && urdb2.getLastSession().trim().length()!=0) {
%>
<TD>		<% out.println("<i>"); %>
		<% 
			Timestamp t = Timestamp.valueOf(urdb2.getLastSession());
		   	String adjustedDate = TimestampHelper.getDateFromTimestamp(t, locale);
			out.println(adjustedDate);
			String adjustedTime = TimestampHelper.getTimeFromTimestamp(t);
			out.println(adjustedTime);
		%>
		<% out.println("</i>"); %>
</TD>
<%
	}
%>
</TR>

<TR>
<TD>	<%=UIUtil.toHTML((String)userWizardNLS.get("userGeneralLastUpdated"))%>:
</TD>
<%
	if(urdb2.getRegistrationUpdate() != null && urdb2.getRegistrationUpdate().trim().length()!=0) {	
%>
<TD>		<% out.println("<i>"); %>
		<% 
			Timestamp t2 = Timestamp.valueOf(urdb2.getRegistrationUpdate());
		   	String adjustedDate2 = TimestampHelper.getDateFromTimestamp(t2, locale);
			out.println(adjustedDate2);
			String adjustedTime2 = TimestampHelper.getTimeFromTimestamp(t2);
			out.println(adjustedTime2);
		%>
		<% out.println("</i>"); %>
</TD>
<%
	}
%>
</TR>


</table>
<%
	}
%>


</FORM>
</BODY>
</HTML>
