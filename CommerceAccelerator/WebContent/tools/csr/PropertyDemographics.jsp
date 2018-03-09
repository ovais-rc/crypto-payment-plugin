<%--
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2000, 2016
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
//*
--%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java"
    import="java.util.*,
            com.ibm.commerce.tools.util.*,
            com.ibm.commerce.tools.common.*,
            com.ibm.commerce.server.*,
            com.ibm.commerce.user.beans.*,
            com.ibm.commerce.user.objects.*,
            com.ibm.commerce.usermanagement.commands.ECUserConstants,
	    com.ibm.commerce.beans.*,
	    com.ibm.commerce.tools.optools.user.beans.*,
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

	if (format == null) 
	{
	   format = (Hashtable)XMLUtil.get(formats, "nlsFormats.default");
	} 

	Hashtable userNLS = (Hashtable)ResourceDirectory.lookup("csr.userNLS", cmdContext.getLocale());	

        Locale jLocale = cmdContext.getLocale();
	OptoolsRegisterDataBean registerDataBean = null;

	try
	{
		registerDataBean = new OptoolsRegisterDataBean();
		if (userId != null) {
			registerDataBean.setUserId(userId); 
			List attrs = new ArrayList();
			attrs.add(ECUserConstants.EC_DEMO_AGE);
			attrs.add(ECUserConstants.EC_DEMO_GENDER);
			attrs.add(ECUserConstants.EC_DEMO_MARITALSTATUS);
			attrs.add(ECUserConstants.EC_DEMO_INCOME);
			attrs.add(ECUserConstants.EC_DEMO_HOUSEHOLD);
			attrs.add(ECUserConstants.EC_DEMO_CHILDREN);
			attrs.add(ECUserConstants.EC_DEMO_ORDERBEFORE);
			attrs.add(ECUserConstants.EC_DEMO_COMPANYNAME);
			attrs.add(ECUserConstants.EC_DEMO_HOBBIES);
			registerDataBean.setRetrieveProperties(attrs);
			DataBeanManager.activate(registerDataBean, request);
		}
	}
	catch (Exception e)
	{
		registerDataBean = null;
	}
	String AgeURL = registerDataBean.getAgeURL();
	String GenderURL = registerDataBean.getGenderURL();
	String IncomeURL = registerDataBean.getIncomeURL();
	String MaritalStatusURL = registerDataBean.getMaritalStatusURL();

	ResourceBundleDataBean bnResourceBundle = new ResourceBundleDataBean();
	bnResourceBundle.setPropertyFileName("UserRegistration");
	DataBeanManager.activate(bnResourceBundle, request);

	Hashtable hshAge = new Hashtable();
	Hashtable hshGender = new Hashtable();
	Hashtable hshIncome = new Hashtable();
	Hashtable hshMaritalStatus = new Hashtable();

	String[][] AgeOptions = null;
	String[][] GenderOptions = null;
	String[][] IncomeOptions = null;
	String[][] MaritalStatusOptions = null;

	try {
		SortedMap smpFields = bnResourceBundle.getPropertySortedMap();
		Iterator entryIterator = smpFields.entrySet().iterator();
		Map.Entry textentry = (Map.Entry) entryIterator.next();
		Hashtable hshText = (Hashtable) textentry .getValue();

		while (entryIterator.hasNext()) {
			Map.Entry entry = (Map.Entry) entryIterator.next();
			Hashtable hshField = (Hashtable) entry.getValue();
			String strName = (String) hshField.get("Name");

			if (strName.equals(AgeURL)) {
				hshAge  = (Hashtable) entry.getValue();
			}
			if (strName.equals(GenderURL)) {
				hshGender  = (Hashtable) entry.getValue();
			}
			if (strName.equals(IncomeURL)) {
				hshIncome  = (Hashtable) entry.getValue();
			}
			if (strName.equals(MaritalStatusURL)) {
				hshMaritalStatus  = (Hashtable) entry.getValue();
			}
		}

		AgeOptions = (String[][])hshAge.get(ECUserConstants.EC_RB_OPTIONS);
		GenderOptions = (String[][])hshGender.get(ECUserConstants.EC_RB_OPTIONS);
		IncomeOptions = (String[][])hshIncome.get(ECUserConstants.EC_RB_OPTIONS);
		MaritalStatusOptions = (String[][])hshMaritalStatus.get(ECUserConstants.EC_RB_OPTIONS);
	} catch (Exception e) {
	}
	UIUtil convert = null;

%>
<html xmlns="http://www.w3.org/1999/xhtml">

<head>
<link rel="stylesheet" href="<%= UIUtil.getCSSFile(jLocale) %>" type="text/css" />
<title><%= userNLS.get("demographicsPageTitle") %></title>
<script type="text/javascript" src="/wcs/javascript/tools/csr/user.js">
</script>
<script type="text/javascript" src="/wcs/javascript/tools/common/Util.js">
</script>

<script type="text/javascript">
var maritalStatusOrder = "<%=(String)XMLUtil.get(format, "maritalStatus.order")%>";
var maritalStatusList = maritalStatusOrder.split(",");
var maritalStatus = new Object();
maritalStatus.single          = "<%=UIUtil.toJavaScript((String)userNLS.get("single"))%>";
maritalStatus.married         = "<%=UIUtil.toJavaScript((String)userNLS.get("married"))%>";
maritalStatus.commonLaw       = "<%=UIUtil.toJavaScript((String)userNLS.get("commonLaw"))%>";
maritalStatus.separated       = "<%=UIUtil.toJavaScript((String)userNLS.get("separated"))%>";
maritalStatus.divorced        = "<%=UIUtil.toJavaScript((String)userNLS.get("divorced"))%>";
maritalStatus.widowed         = "<%=UIUtil.toJavaScript((String)userNLS.get("widowed"))%>";
maritalStatus.other           = "<%=UIUtil.toJavaScript((String)userNLS.get("other"))%>";

var maritalStatusValue = new Object();
maritalStatusValue.single     = "S";
maritalStatusValue.married    = "M";
maritalStatusValue.commonLaw  = "C";
maritalStatusValue.separated  = "P";
maritalStatusValue.divorced   = "D";
maritalStatusValue.widowed    = "W";
maritalStatusValue.other      = "O";

function compare()
{
	// alertDialog("DEBUG: compare is called");
<%
if (registerDataBean == null)
{
%>
   for (var i=0; i<document.dem.elements.length; i++)
   {
      var e = document.dem.elements[i];
      if (parent.get("demographicsUpdated")=="false" && e.type == "text")
      {
        if ((e.name=="employer" || e.name=="hobby") && e.value != "")
           parent.put("demographicsUpdated", "true");
        if (e.name=="peopleNumInHouse" && e.value!="0")
           parent.put("demographicsUpdated", "true");
        if (e.name=="childrenNum" && e.value!="")
           parent.put("demographicsUpdated", "true");
      }

      if (parent.get("demographicsUpdated")=="false" && e.type == "select-one")
      {
        if ((e.name=="age" || e.name=="annualIncome") && e.options[e.selectedIndex].value != "0")
           parent.put("demographicsUpdated", "true");
        if ((e.name=="gender") && e.options[e.selectedIndex].value != "/")
           parent.put("demographicsUpdated", "true");
        if ((e.name=="maritalStatus") && e.options[e.selectedIndex].value != "N")
           parent.put("demographicsUpdated", "true");           
        if (e.name=="orderedBefore" && e.options[e.selectedIndex].value != "")
           parent.put("demographicsUpdated", "true");
      }
      
		// alertDialog(e.name + " " + parent.get("demographicsUpdated"));         
   }
<%
}
else
{
%>
   for (var i=0; i<document.dem.elements.length; i++)
   {
      var e = document.dem.elements[i];
      if (parent.get("demographicsUpdated")=="false" && e.type == "text")
      {
        if (e.name=="employer" && e.value != "<%=convert.toJavaScript(registerDataBean.getCompanyName())%>")
           parent.put("demographicsUpdated", "true");
        if (e.name=="hobby" && e.value != "<%=convert.toJavaScript(registerDataBean.getHobbies())%>")
           parent.put("demographicsUpdated", "true");
        if (e.name=="peopleNumInHouse" && e.value!="<%=registerDataBean.getHousehold()%>")
           parent.put("demographicsUpdated", "true");
        if (e.name=="childrenNum" && e.value!="<%=registerDataBean.getNumberOfChildren()%>")
           parent.put("demographicsUpdated", "true");
      }

      if (parent.get("demographicsUpdated")=="false" && e.type == "select-one")
      {
        if (e.name=="age" && e.options[e.selectedIndex].value != "<%=registerDataBean.getAge()%>")
           parent.put("demographicsUpdated", "true");
        if (e.name=="annualIncome" && e.options[e.selectedIndex].value != "<%=registerDataBean.getIncome()%>")
           parent.put("demographicsUpdated", "true");
        if (e.name=="gender" && e.options[e.selectedIndex].value != "<%=registerDataBean.getGender()%>")
           parent.put("demographicsUpdated", "true");
        if (e.name=="maritalStatus" && e.options[e.selectedIndex].value != "<%=registerDataBean.getMaritalStatus()%>")
           parent.put("demographicsUpdated", "true");
        if (e.name=="orderedBefore" && e.options[e.selectedIndex].value != "<%=registerDataBean.getAttribute(ECUserConstants.EC_DEMO_ORDERBEFORE)%>")
           parent.put("demographicsUpdated", "true");
      }
      
		// alertDialog(e.name + " " + parent.get("demographicsUpdated"));  
   }
<%
}
%>

  if (parent.get("demographicsUpdated") == "true")
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
	var iNH = "InvalidNumberInHousehold";
	var iCH = "InvalidNumberOfChildren";
	var iFM = "inputFieldMax";
		
	var code = parent.getErrorParams();
	if (code != null)
	{
		if (code == iNH)
		{
			alertDialog("<%=UIUtil.toJavaScript((String)userNLS.get("InvalidNumberInHousehold"))%>");
			document.dem.peopleNumInHouse.focus();
		}
		else if (code == iCH)
		{
			alertDialog("<%=UIUtil.toJavaScript((String)userNLS.get("InvalidNumberOfChildren"))%>");
			document.dem.childrenNum.focus();
		}
		else if (code.indexOf(iFM) != -1)
		{
			alertDialog("<%=UIUtil.toJavaScript((String)userNLS.get("inputFieldMax"))%>");
			code = code.split("_");
			if (code[1]=="peopleNumInHouse")
				document.dem.peopleNumInHouse.select();
			else if (code[1]=="childrenNum")
				document.dem.childrenNum.select();
			else if (code[1]=="employer")
				document.dem.employer.select();
			else if (code[1]=="hobby") 
				document.dem.hobby.select(); 
		}
	}
}

function initializeState()
{
   // alertDialog("DEBUG: initializeState()");
	
   var demographicsInfo = parent.get("demographicsInfo");
   if (demographicsInfo != null)
   {
      // alertDialog("demographicsInfo is not null");
      document.dem.peopleNumInHouse.value = demographicsInfo.peopleNumInHouse;
      document.dem.childrenNum.value = demographicsInfo.childrenNum;
      document.dem.employer.value = demographicsInfo.employer;
      document.dem.hobby.value = demographicsInfo.hobby;

      for ( var i=0; i < document.dem.age.length; i++ )
      {
         if ( document.dem.age.options[i].value == demographicsInfo.age )
         {
            document.dem.age.options[i].selected = true;
            break;
         }
      }
      for ( var i=0; i < document.dem.gender.length; i++ )
      {
         if ( document.dem.gender.options[i].value == demographicsInfo.gender )
         {
            document.dem.gender.options[i].selected = true;
            break;
         }
      }
      for ( var i=0; i < document.dem.orderedBefore.length; i++ )
      {
         if ( document.dem.orderedBefore.options[i].value == demographicsInfo.orderedBefore )
         {
            document.dem.orderedBefore.options[i].selected = true;
            break;
         }
      }
      for ( var i=0; i < document.dem.maritalStatus.length; i++ )
      {
         if ( document.dem.maritalStatus.options[i].value == demographicsInfo.maritalStatus )
         {
            document.dem.maritalStatus.options[i].selected = true;
            break;
         }
      }
      for ( var i=0; i < document.dem.annualIncome.length; i++ )
      {
         if ( document.dem.annualIncome.options[i].value == demographicsInfo.annualIncome )
         {
            document.dem.annualIncome.options[i].selected = true;
            break;
         }
      }
   }
   else
   {
      // alertDialog("demographicsInfo is null");
      <%if (registerDataBean != null)
      {
      %>
      	// alertDialog("shopper has demographics info");
         document.dem.peopleNumInHouse.value = "<%=registerDataBean.getHousehold()%>";
         document.dem.childrenNum.value = "<%=registerDataBean.getNumberOfChildren()%>";
         document.dem.employer.value = "<%=convert.toJavaScript(registerDataBean.getCompanyName())%>";
         document.dem.hobby.value = "<%=convert.toJavaScript(registerDataBean.getHobbies())%>";

         var dbAge="<%=registerDataBean.getAge()%>";
         for ( var i=0; i < document.dem.age.length; i++ )
         {
            if ( document.dem.age.options[i].value == dbAge )
            {
               document.dem.age.options[i].selected = true;
               break;
            }
         }

         var dbGender="<%=registerDataBean.getGender()%>";
         for ( var i=0; i < document.dem.gender.length; i++ )
         {
            if ( document.dem.gender.options[i].value == dbGender )
            {
               document.dem.gender.options[i].selected = true;
               break;
            }
         }

         var dbOrderedBefore="<%=registerDataBean.getAttribute(ECUserConstants.EC_DEMO_ORDERBEFORE)%>";
         for ( var i=0; i < document.dem.orderedBefore.length; i++ )
         {
            if ( document.dem.orderedBefore.options[i].value == dbOrderedBefore )
            {
               document.dem.orderedBefore.options[i].selected = true;
               break;
            }
         }

         var dbMaritalStatus="<%=registerDataBean.getMaritalStatus()%>";
         for ( var i=0; i < document.dem.maritalStatus.length; i++ )
         {
            if ( document.dem.maritalStatus.options[i].value == dbMaritalStatus )
            {
               document.dem.maritalStatus.options[i].selected = true;
               break;
            }
         }

         var dbAnnualIncome="<%=registerDataBean.getIncome()%>";
         for ( var i=0; i < document.dem.annualIncome.length; i++ )
         {
            if ( document.dem.annualIncome.options[i].value == dbAnnualIncome )
            {
               document.dem.annualIncome.options[i].selected = true;
               break;
            }
         }

      <%
      }
      %>
   }

	parent.setContentFrameLoaded(true);
	displayValidationError();
	
}

function savePanelData()
{
	// alertDialog("DEBUG: saveState is called");
	if (parent.get("InvalidNumberInHousehold") == null)
		parent.put("InvalidNumberInHousehold", "<%=UIUtil.toJavaScript((String)userNLS.get("InvalidNumberInHousehold"))%>");
	if (parent.get("InvalidNumberOfChildren") == null)
		parent.put("InvalidNumberOfChildren", "<%=UIUtil.toJavaScript((String)userNLS.get("InvalidNumberOfChildren"))%>");
	
   var demographicsInfo = new Object;
  
   demographicsInfo.peopleNumInHouse = document.dem.peopleNumInHouse.value;
   demographicsInfo.childrenNum = document.dem.childrenNum.value;
   demographicsInfo.employer = document.dem.employer.value;
   demographicsInfo.hobby = document.dem.hobby.value;

   var selected;
   selected = document.dem.age.selectedIndex;
   demographicsInfo.age = document.dem.age.options[selected].value;
   selected = document.dem.gender.selectedIndex;
   demographicsInfo.gender = document.dem.gender.options[selected].value;
   selected = document.dem.orderedBefore.selectedIndex;
   demographicsInfo.orderedBefore = document.dem.orderedBefore.options[selected].value;
   selected = document.dem.maritalStatus.selectedIndex;
   demographicsInfo.maritalStatus = document.dem.maritalStatus.options[selected].value;
   selected = document.dem.annualIncome.selectedIndex;
   demographicsInfo.annualIncome = document.dem.annualIncome.options[selected].value;

   parent.put("demographicsInfo", demographicsInfo);
   
	setStateChanged();
	
	var authToken = parent.get("authToken");
	if (defined(authToken)) {
		parent.addURLParameter("authToken", authToken);
	}
	// alertDialog("demographics is changed? " + isStateChanged());

	// return true;
}


</script>

</head>

<body class="content" onload="initializeState();">
<form name="dem" id="dem">
<h1><%= userNLS.get("Demographics") %></h1>
<table border="0" cellpadding="2" cellspacing="2" id="PropertyDemographics_Table_1">
  <tbody>
    <tr>
      <td id="PropertyDemographics_TableCell_1">
      <table border="0" id="PropertyDemographics_Table_2">
        <tbody>
          <tr>
            <td valign="bottom" id="PropertyDemographics_TableCell_2"><label for='age1'><%=userNLS.get("age")%></label><br />
            <select name="age" id='age1'>
                          <option value="" selected></option>
			<%	if (AgeOptions != null) {%>
				<%	for (int i = 0; i < AgeOptions.length; i ++) { %>
				<option value="<%= AgeOptions[i][0] %>">
				       <%= AgeOptions[i][1] %>
				</option>
				       <% } %>
			<% } %>
            </select></td>
            <td valign="bottom" id="PropertyDemographics_TableCell_3"><label for='gender1'><%=userNLS.get("gender")%></label><br />
            <select name="gender" id='gender1'>
                          <option value="" selected></option>
            		<%	if (GenderOptions != null) {%>
				<%	for (int i = 0; i < GenderOptions.length; i ++) { %>
				<option value="<%= GenderOptions[i][0] %>">
				        <%= GenderOptions[i][1] %>
				</option>
				<%	} %>
			<%	} %>
            </select></td>
          </tr>
          <tr>
            <td valign="bottom" id="PropertyDemographics_TableCell_4"><label for='maritalStatus1'><%=userNLS.get("maritalStatus")%></label><br />
            <select name="maritalStatus" id='maritalStatus1'>
                          <option value="" selected></option>
                        <%	if (MaritalStatusOptions != null) {%>
				<%	for (int i = 0; i < MaritalStatusOptions.length; i ++) { %>
				<option value="<%= MaritalStatusOptions[i][0] %>">
					<%= MaritalStatusOptions[i][1] %>
				</option>
				<%	} %>
			<%	} %>
            </select></td>
            <td valign="bottom" id="PropertyDemographics_TableCell_5"><label for='annualIncome1'><%=userNLS.get("annualIncome")%></label><br />
            <select name="annualIncome" id='annualIncome1'>
                          <option value="" selected></option>
                        <%	if (IncomeOptions != null) {%>
				<%	for (int i = 0; i < IncomeOptions.length; i ++) { %>
				<option value="<%= IncomeOptions[i][0] %>">
					<%= IncomeOptions[i][1] %>
				</option>
				<%	} %>
			<%	} %>
	    </select>
            </td>
            <td id="PropertyDemographics_TableCell_6"></td>
          </tr>
          <tr>
            <td colspan="3" valign="bottom" id="PropertyDemographics_TableCell_7"><%=userNLS.get("numberInHousehold")%><br />
            <label for="PropertyDemographics_FormInput_peopleNumInHouse_In_dem_1"><span style="display:none;"><%=userNLS.get("numberInHousehold")%></span></label>
            <input size="2" type="text" maxlength="2" value="1" name="peopleNumInHouse" id="PropertyDemographics_FormInput_peopleNumInHouse_In_dem_1" /></td>
          </tr>
          <tr>
            <td colspan="3" valign="bottom" id="PropertyDemographics_TableCell_8"><%=userNLS.get("numberOfChildren")%><br />
            <label for="PropertyDemographics_FormInput_childrenNum_In_dem_1"><span style="display:none;"><%=userNLS.get("numberOfChildren")%></span></label>
            <input size="2" type="text" name="childrenNum" value="" maxlength="2" id="PropertyDemographics_FormInput_childrenNum_In_dem_1" /></td>
          </tr>
          <tr>
            <td valign="bottom" id="PropertyDemographics_TableCell_9"><label for='orderedBefore1'><%=userNLS.get("orderedBefore")%></label><br />
            <select name="orderedBefore" id='orderedBefore1'>
            <option value="" selected><%=userNLS.get("notProvided")%></option>
            <option value="Y"><%=userNLS.get("yes")%></option>
            <option value="N"><%=userNLS.get("no")%></option>
            </select></td>
          </tr>
        </tbody>
      </table>
      </td>
    </tr>
    <tr>
      <td id="PropertyDemographics_TableCell_10">
      <table border="0" id="PropertyDemographics_Table_3">
        <tbody>
          <tr>
            <td colspan="3" valign="bottom" id="PropertyDemographics_TableCell_11"><%=userNLS.get("employer")%><br />
            <label for="PropertyDemographics_FormInput_employer_In_dem_1"><span style="display:none;"><%=userNLS.get("employer")%></span></label>
            <input size="65" type="text" name="employer" maxlength="128" id="PropertyDemographics_FormInput_employer_In_dem_1" /></td>
          </tr>
          <tr>
            <td colspan="3" valign="bottom" id="PropertyDemographics_TableCell_12"><%=userNLS.get("hobby")%><br />
            <label for="PropertyDemographics_FormInput_hobby_In_dem_1"><span style="display:none;"><%=userNLS.get("hobby")%></span></label>
            <input size="65" type="text" name="hobby" maxlength="254" id="PropertyDemographics_FormInput_hobby_In_dem_1" /></td>
          </tr>
        </tbody>
      </table>
      </td>
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




