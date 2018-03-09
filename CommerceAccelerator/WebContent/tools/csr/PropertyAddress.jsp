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
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java"
    import="java.util.*,
            com.ibm.commerce.tools.common.*,
            com.ibm.commerce.tools.util.*,
            com.ibm.commerce.server.*,
            com.ibm.commerce.user.beans.*,
            com.ibm.commerce.user.objects.*,            
            com.ibm.commerce.beans.*,
            com.ibm.commerce.tools.xml.*,
            com.ibm.commerce.tools.optools.user.beans.*,
            com.ibm.commerce.command.*,
            com.ibm.commerce.common.beans.*,
            com.ibm.commerce.usermanagement.commands.ECUserConstants,
            com.ibm.commerce.user.beans.*,
            com.ibm.commerce.taxation.objects.*,
            com.ibm.commerce.taxation.objsrc.*,
            com.ibm.commerce.persistence.JpaEntityAccessBeanCacheUtil,
            java.text.Collator,
            java.sql.*"
%>

<%@include file="../common/common.jsp" %>

<%!
public CountryStateListDataBean.StateProvince[] getStateProvince(String countryName, Integer langId, Locale _locale) {

	CountryStateListDataBean.StateProvince[] _states = null;
	try {
		Collection collStateProvAB = Collections
			.list(JpaEntityAccessBeanCacheUtil
					.newJpaEntityAccessBean(
							StateProvinceAccessBean.class).findByCountryNameAndLanguageId(countryName, langId));
		int len = collStateProvAB==null? 0 : collStateProvAB.size();
		Map statesMap = new HashMap(1+len*100/75);
		Iterator iter = collStateProvAB.iterator();
		while (iter.hasNext()) {
			StateProvinceAccessBean stateAB = (StateProvinceAccessBean) iter.next();
			statesMap.put(stateAB.getName(), stateAB.getStateAbbr());
		}
			
		List lstStateNames = new ArrayList(statesMap.size());
		lstStateNames.addAll(statesMap.keySet());
		Collator colStateNames = Collator.getInstance(_locale);
		Collections.sort(lstStateNames, colStateNames);
		ListIterator StatesIterator = lstStateNames.listIterator();
		_states = new CountryStateListDataBean.StateProvince[statesMap.size()];
		int i=0;
		while (StatesIterator.hasNext())
		{
			String aName = (String)StatesIterator.next();
			_states[i] = new CountryStateListDataBean.StateProvince((String) statesMap.get(aName), aName);
			i++;
		}
			
	} catch (Exception ex) {
				
	}
	return _states;
}


%>

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

	JSPHelper jspHelper 	= new JSPHelper(request);
	String selectedCountry	= jspHelper.getParameter("selectedCountry");

	OptoolsRegisterDataBean registerDataBean = new OptoolsRegisterDataBean();
	
	//RM:d70084 Should not initialize the databean if the userId is null
	if (userId != null && userId.trim().length() > 0) {
		registerDataBean.setUserId(userId); 
		DataBeanManager.activate(registerDataBean, request);
	}

	AddressDataBean address = new AddressDataBean();
	try
	{
		String regAddrId = registerDataBean.getAddressId();
		if (regAddrId != null && regAddrId.length() != 0) {
			address.setAddressId(regAddrId);
			DataBeanManager.activate(address, request);
		}
	}
	catch (Exception e)
	{
	}	

	UIUtil convert = null;

	CountryStateListDataBean countryDB = new CountryStateListDataBean();
	DataBeanManager.activate(countryDB, request);
	Vector countries = countryDB.getCountries();
	CountryStateListDataBean.Country aCountry = null;
	CountryStateListDataBean.StateProvince[] states = null;
	
	if (selectedCountry != null && selectedCountry.length() != 0) {
		states = countryDB.getStates(selectedCountry);
	} else {
		states = countryDB.getStates(address.getCountry());
		if (states == null || states.length == 0) {
		   // couldn't find by the country code, maybe this is migrated so check by the country name
		   states = getStateProvince(address.getCountry(), cmdContext.getLanguageId(), cmdContext.getLocale());
		}
	}

%>   
<html xmlns="http://www.w3.org/1999/xhtml">

<head>
<link rel="stylesheet" href="<%= UIUtil.getCSSFile(cmdContext.getLocale()) %>" type="text/css" />
<title><%= userNLS.get("addressPageTitle") %></title>
<script type="text/javascript" src="/wcs/javascript/tools/csr/user.js">
</script>
<script type="text/javascript" src="/wcs/javascript/tools/common/Util.js">
</script>

<script type="text/javascript">
<%@ include file = "AddressDisplay.jspf" %>

function compare()
{
   for (var i=0; i<document.address.elements.length; i++)
   {
      var e = document.address.elements[i];
    
      //if (parent.get("addressUpdated")=="false" && e.type == "text")
      if (parent.get("addressUpdated")=="false")
      {
        if (e.name == "address1" && e.value != "<%=convert.toJavaScript(address.getAddress1())%>")
           parent.put("addressUpdated", "true");
        if (e.name == "address2" && e.value != "<%=convert.toJavaScript(address.getAddress2())%>")
           parent.put("addressUpdated", "true");
        if (e.name == "address3" && e.value != "<%=convert.toJavaScript(address.getAddress3())%>")
           parent.put("addressUpdated", "true");
        if (e.name == "city" && e.value != "<%=convert.toJavaScript(address.getCity())%>")
           parent.put("addressUpdated", "true");
        if (e.name == "state" && e.value != "<%=convert.toJavaScript(address.getState())%>")
           parent.put("addressUpdated", "true");
        if (e.name == "zip" && e.value != "<%=convert.toJavaScript(address.getZipCode())%>")
           parent.put("addressUpdated", "true");
        if (e.name == "country" && e.value != "<%=convert.toJavaScript(address.getCountry())%>") {
           parent.put("addressUpdated", "true");           
        }
      }

   }
  
  if (parent.get("addressUpdated") == "true")
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
		if (code.indexOf(mM)!=-1)
		{
			alertDialog("<%=UIUtil.toJavaScript((String)userNLS.get("missingMandatoryData"))%>");
			code = code.split("_");
			if (code[1]=="address1")
				document.address.address1.focus();
			else if (code[1]=="city")
				document.address.city.focus();
			else if (code[1]=="state")
				document.address.state.focus();
			else if (code[1]=="zip")
				document.address.zip.focus();
			else if (code[1]=="country")
				document.address.country.focus();
		} else if (code.indexOf(iFM)!=-1) {
			alertDialog("<%=UIUtil.toJavaScript((String)userNLS.get("inputFieldMax"))%>");
			code = code.split("_");
			if (code[1]=="address1")
				document.address.address1.select();
			else if (code[1]=="address2")
				document.address.address2.select();
			else if (code[1]=="address3")
				document.address.address3.select();
			else if (code[1]=="city")
				document.address.city.select();
			else if (code[1]=="state")
				document.address.state.select();
			else if (code[1]=="zip")
				document.address.zip.select();
			else if (code[1]=="country")
				document.address.country.select();
		}
	}
}

function initializeState()
{
   

   var addressInfo = parent.get("addressInfo");
   if (addressInfo != null)
   {
      document.address.address1.value  = addressInfo.address1;
      document.address.address2.value    = addressInfo.address2;
      document.address.address3.value    = addressInfo.address3;
      document.address.city.value   = addressInfo.city;
     
     <% if (states == null || states.length == 0) { %>
		document.address.state.value  = addressInfo.state;
     <% } else { %>
     	     var selectOne = false;
             for (var i = 0; i < document.address.state.length; i++) {
             	if (document.address.state.options[i].value == addressInfo.state || document.address.state.options[i].innerText == addressInfo.state) {
             		document.address.state.options[i].selected = true;
             		selectOne = true;
             		break;
             	}
             }
             if (!selectOne && addressInfo.state != '') {
                var stateSelectInputObj = document.getElementById("state1");
                aOption = document.createElement("OPTION");
                stateSelectInputObj.options.add(aOption);
                aOption.innerText = addressInfo.state;
                aOption.value = addressInfo.state;     
                aOption.selected = true;      
             }
      <% } %>
          
      document.address.zip.value  = addressInfo.zip;
      var foundCountry = false;
       for (var i=0; i< document.address.country.length; i++)
       {
         if (document.address.country.options[i].value == addressInfo.country || document.address.country.options[i].innerText == addressInfo.country)
         {
           document.address.country.options[i].selected = true;
           foundCountry = true;
           break;
         }
       }
       if (foundCountry == false) {
            var countrySelectInputObj = document.getElementById("country1");
            aOption = document.createElement("OPTION");
            countrySelectInputObj.options.add(aOption);
            aOption.innerText = addressInfo.country;
            aOption.value = addressInfo.country;     
            aOption.selected = true;      
       }
      //document.address.country.value = addressInfo.country;
   }
   else
   {
      document.address.address1.value  = "<%=convert.toJavaScript(address.getAddress1())%>";
      document.address.address2.value  = "<%=convert.toJavaScript(address.getAddress2())%>";
      document.address.address3.value  = "<%=convert.toJavaScript(address.getAddress3())%>";
      document.address.city.value      = "<%=convert.toJavaScript(address.getCity())%>";
 
     <% if (states == null || states.length == 0) { %>
		document.address.state.value  = "<%=convert.toJavaScript(address.getState())%>";
     <% } else { %>
     	     var selectOne = false;
             for (var i = 0; i < document.address.state.length; i++) {
             	if (document.address.state.options[i].value == "<%=convert.toJavaScript(address.getState())%>" || document.address.state.options[i].innerText == "<%=convert.toJavaScript(address.getState())%>") {
             		document.address.state.options[i].selected = true;
             		selectOne = true;
             		break;
             	}
             }
             if (!selectOne) {
                var stateSelectInputObj = document.getElementById("state1");
                aOption = document.createElement("OPTION");
                stateSelectInputObj.options.add(aOption);
                aOption.innerText = "<%=convert.toJavaScript(address.getState())%>";
                aOption.value = "<%=convert.toJavaScript(address.getState())%>";     
                aOption.selected = true;      
             }
      <% } %>      
      
      document.address.zip.value       = "<%=convert.toJavaScript(address.getZipCode())%>";
      var foundCountry = false;
       for (var i=0; i< document.address.country.length; i++)
       {
   	   if (document.address.country.options[i].value == "<%=convert.toJavaScript(address.getCountry())%>" || document.address.country.options[i].innerText == "<%=convert.toJavaScript(address.getCountry())%>")
         {
      	   document.address.country.options[i].selected = true;
      	   foundCountry = true;
            break;
         }
      }
       if (foundCountry == false) {
            var countrySelectInputObj = document.getElementById("country1");
            aOption = document.createElement("OPTION");
            countrySelectInputObj.options.add(aOption);
            aOption.innerText = "<%=convert.toJavaScript(address.getCountry())%>";
            aOption.value = "<%=convert.toJavaScript(address.getCountry())%>";     
            aOption.selected = true;      
       }      
      //document.address.country.value   = "<%=convert.toJavaScript(address.getCountry())%>";
   }
   
	parent.setContentFrameLoaded(true);   
	displayValidationError();

}

function savePanelData()
{

   var addressInfo = new Object;
   addressInfo.address1 = document.address.address1.value;
   addressInfo.address2 = document.address.address2.value;
   addressInfo.address3 = document.address.address3.value;
   addressInfo.city = document.address.city.value;
 
   <% if (states == null || states.length == 0) { %>
   	addressInfo.state = document.address.state.value;
   <% } else { %>
   	var stateSelected = document.address.state.selectedIndex;
   	addressInfo.state = document.address.state.options[stateSelected].value;
   <% } %>
   addressInfo.zip = document.address.zip.value;
   //addressInfo.country = document.address.country.value;

   var countrySelected = document.address.country.selectedIndex;
   addressInfo.country = document.address.country.options[countrySelected].value;
 
	parent.put("addressInfo", addressInfo);     
	setStateChanged();
	var authToken = parent.get("authToken");
	if (defined(authToken)) {
		parent.addURLParameter("authToken", authToken);
	}

   return true;
}
 

</script>

</head>
<body class="content" onload="initializeState();">
<form name="address" id="address">
<h1><%= UIUtil.toHTML((String)userNLS.get("Address")) %></h1>
<table border="0" cellpadding="2" cellspacing="2" id="PropertyAddress_Table_1">
  <tr><th></th></tr>
  <tbody>
    <tr>
       <td valign="bottom" id="PropertyAddress_TableCell_1">
         <script type="text/javascript">displayAddrItem(-1)
</script>
       </td>
    </tr>
    <tr>
      <td valign="bottom" id="PropertyAddress_TableCell_2">
        <script type="text/javascript">displayAddrItem(0)
</script>
      </td>
    </tr>
    <tr>
      <td valign="bottom" id="PropertyAddress_TableCell_3">
        <script type="text/javascript">displayAddrItem(1)
</script>
      </td>
    </tr>
    <tr>
      <td valign="bottom" id="PropertyAddress_TableCell_4">
        <script type="text/javascript">displayAddrItem(2)
</script>
      </td>
    </tr>
    <tr>
      <td valign="bottom" id="PropertyAddress_TableCell_5">
        <script type="text/javascript">displayAddrItem(3)
</script>
      </td>
    </tr>
    <tr>
      <td valign="bottom" id="PropertyAddress_TableCell_6">
        <script type="text/javascript">displayAddrItem(4)
</script>
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
