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
//*
-->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<%--
//---------------------------------------------------------------------
//- Import and Include Section
//---------------------------------------------------------------------
--%>

<%@ page language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="com.ibm.commerce.tools.xml.*" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.tools.util.UIUtil" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>

<%@include file="../common/common.jsp" %>

<%--
//---------------------------------------------------------------------
//- Method Declarion
//---------------------------------------------------------------------
--%>

<%--
//---------------------------------------------------------------------
//- Logic Section
//---------------------------------------------------------------------
--%>
<%
try {
	// obtain the resource bundle for display
	CommandContext cmdContext = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
	Locale jLocale = cmdContext.getLocale();
	Hashtable userNLS = (Hashtable)ResourceDirectory.lookup("csr.userNLS", jLocale);
	Hashtable formats = (Hashtable)ResourceDirectory.lookup("csr.nlsFormats");
	Hashtable format = (Hashtable)XMLUtil.get(formats, "nlsFormats."+ jLocale.toString());
	if (format == null) {
	   format = (Hashtable)XMLUtil.get(formats, "nlsFormats.default");
	} 
	String nameOrder = (String)XMLUtil.get(format, "name.order");
	com.ibm.commerce.common.beans.StoreDataBean  store = new com.ibm.commerce.common.beans.StoreDataBean();
    Integer storeId 	= cmdContext.getStoreId();
    store.setStoreId(storeId.toString());
    com.ibm.commerce.beans.DataBeanManager.activate(store, request);
%>						

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<link rel="stylesheet" href="<%= UIUtil.getCSSFile(jLocale) %>" type="text/css" />
<title><%=userNLS.get("custSearch")%></title>
<script type="text/javascript" src="/wcs/javascript/tools/csr/user.js">
</script>
<script type="text/javascript" src="/wcs/javascript/tools/common/Util.js">
</script>
<script type="text/javascript">
<%@ include file = "CaseSelection.jspf" %>

var dynamicTagCounter = 0;

//---------------------------------------------------------------------
//  Required javascript function for Dialog
//---------------------------------------------------------------------
function savePanelData() {
	debugAlert("savePanelData() ...begin...");
}

function vaildatePanelData() {
	debugAlert("validatePanelData() ...begin...");
	
	if (isEmpty(document.searchForm.logonid.value) 	&&
		 isEmpty(document.searchForm.firstName.value)&&
		 isEmpty(document.searchForm.lastName.value) &&
		 isEmpty(document.searchForm.phone.value) 	&&
		 isEmpty(document.searchForm.email.value) 	&&
		 isEmpty(document.searchForm.city.value) 		&&
		 isEmpty(document.searchForm.zip.value) 		   ) {

		alertDialog("<%=UIUtil.toJavaScript((String)userNLS.get("missingSearchCriteria")) %>");
		return false;
	
	} 
	return true;
}

//---------------------------------------------------------------------
//  User defined javascript function 
//---------------------------------------------------------------------
function debugAlert(msg) {
//	alert("DEBUG: " + msg);
}
function isEmpty(id) {
	return !id.match(/[^\s]/);
}

function loadPanelData() {
	document.searchForm.logonid.focus();
   parent.setContentFrameLoaded(true);
}

function filterAction() {
	debugAlert("filterAction() ...begin...");
   if (vaildatePanelData()) { 
		debugAlert("Pass validation ");
		var url = "/webapp/wcs/tools/servlet/NewDynamicListView";
		var urlPara = new Object();
	    
	    urlPara.ActionXMLFile='csr.shopperListB2C';
	
		urlPara.cmd='ShopperListB2C';
		urlPara.listsize='22';
		urlPara.startindex='0';
		urlPara.orderby='LOGONID';
		urlPara.logonid 	=	document.searchForm.logonid.value;
		urlPara.firstName =	document.searchForm.firstName.value;
		urlPara.lastName	=	document.searchForm.lastName.value;
		urlPara.phone		=	document.searchForm.phone.value;
		urlPara.email		=	document.searchForm.email.value;
		urlPara.city		=	document.searchForm.city.value;
		urlPara.zip			=	document.searchForm.zip.value;
		
		urlPara.logonidSearchType = document.searchForm.logonidSearchType.value;
		urlPara.firstNameSearchType = document.searchForm.firstNameSearchType.value;
		urlPara.lastNameSearchType = document.searchForm.lastNameSearchType.value;
		urlPara.phoneSearchType = document.searchForm.phoneSearchType.value;
		urlPara.emailSearchType = document.searchForm.emailSearchType.value;
		urlPara.citySearchType = document.searchForm.citySearchType.value;
		urlPara.zipSearchType = document.searchForm.zipSearchType.value;
		top.setContent("<%= UIUtil.toJavaScript((String)userNLS.get("custSearchResult")) %>",url,true,urlPara);
	}
}

function cancelAction() {
	top.goBack();
}


function getNameOrder() {
   return "<%=nameOrder%>";
}


function displayNameSearchField()
{
   var tempList = getNameOrder();
   var nameOrderList = tempList.split(",");
 
   for (var i=0; i<nameOrderList.length; i++) {
   	if (nameOrderList[i] == "last")
   	{
   	   println("<tr><td id=\'ShopperSearchB2C_DynamicTableCell_"+ dynamicTagCounter +"_"+ i +"_1\'>");
   	   println("<%=UIUtil.toJavaScript((String)userNLS.get("lastName"))%><br />");
   	   println("<label for=\'ShopperSearchB2C_FormInput_lastName"+ dynamicTagCounter +"_"+ i +"\'><span style='display:none;'><%=userNLS.get("lastName")%></span></label>");    	   
  	   println("<input size='30' type='text' name='lastName' maxlength='64' id=\'ShopperSearchB2C_FormInput_lastName"+ dynamicTagCounter +"_"+ i +"\' />");
  	   println("</td><td id=\'ShopperSearchB2C_DynamicTableCell_"+ dynamicTagCounter +"_"+ i +"_2\'>"); 
  	   println("<label for='lastNameSearchType1'><span style='display:none;'><%=userNLS.get("lastName")%></span></label>"); 
  	   println("<br /><select name='lastNameSearchType' id='lastNameSearchType1'>");
  	   displayCaseSelection();
  	   println("</select>");
  	   println("</td></tr>");
   	}
   	else if (nameOrderList[i] == "first")
   	{
   	   println("<tr><td id=\'ShopperSearchB2C_DynamicTableCell_"+ dynamicTagCounter +"_"+ i +"_1\'>");
   	   println("<%=UIUtil.toJavaScript((String)userNLS.get("firstName"))%><br />");  
   	   println("<label for=\'ShopperSearchB2C_FormInput_firstName"+ dynamicTagCounter +"_"+ i +"\'><span style='display:none;'><%=userNLS.get("firstName")%></span></label>");   	   
   	   println("<input size='30' type='text' name='firstName' maxlength='64' id=\'ShopperSearchB2C_FormInput_firstName"+ dynamicTagCounter +"_"+ i +"\' />");
   	   println("</td><td id=\'ShopperSearchB2C_DynamicTableCell_"+ dynamicTagCounter +"_"+ i +"_2\'>"); 
   	   println("<label for='firstNameSearchType1'><span style='display:none;'><%=userNLS.get("firstName")%></span></label>");
   	   println("<br /><select name='firstNameSearchType' id='firstNameSearchType1'>");
  	   displayCaseSelection();
  	   println("</select>");
  	   println("</td></tr>");
   	}
   }
   dynamicTagCounter++;
}

</script>
</head>
<body class="content" onload="loadPanelData()">

<h1><%=userNLS.get("custSearch")%></h1>
<p><%=userNLS.get("findInstMsg")%></p>
<form name="searchForm" method="GET" id="searchForm">

<table border="0" id="ShopperSearchB2C_Table_1">
  <tr><th></th></tr>
  <tbody>
    <tr>
      <td id="ShopperSearchB2C_TableCell_1"><%=userNLS.get("custLogonID")%><br />
      	  <label for="ShopperSearchB2C_FormInput_logonid_In_searchForm_1"><span style='display:none;'><%=userNLS.get("custLogonID")%></span></label>
          <input size="30" type="text" name="logonid" maxlength="31" id="ShopperSearchB2C_FormInput_logonid_In_searchForm_1" />
      </td>
      <td id="ShopperSearchB2C_TableCell_2"><br />
      	  <label for="logonidSearchType"><span style="display:none;"><%=userNLS.get("logonid")%></span></label>
          <select name="logonidSearchType" id="logonidSearchType">
          	<script type="text/javascript">displayCaseSelection()
		</script>
          </select>
      </td>
    </tr>

    <script type="text/javascript">displayNameSearchField()
</script>

    <tr>
      <td id="ShopperSearchB2C_TableCell_3"><%=userNLS.get("phone1")%><br />
      	  <label for="ShopperSearchB2C_FormInput_phone_In_searchForm_1"><span style='display:none;'><%=userNLS.get("phone1")%></span></label>
          <input size="30" type="text" name="phone" maxlength="32" id="ShopperSearchB2C_FormInput_phone_In_searchForm_1" />
      </td>
      <td id="ShopperSearchB2C_TableCell_4"><br />
      	  <label for="phoneSearchType1"><span style='display:none;'><%=userNLS.get("phone1")%></span></label>
          <select name="phoneSearchType" id="phoneSearchType1">
             	<script type="text/javascript">displayCaseSelection()
		</script>
          </select>
      </td>
    </tr>
    <tr>
      <td id="ShopperSearchB2C_TableCell_5"><%=userNLS.get("email1")%><br />
      <label for="ShopperSearchB2C_FormInput_email_In_searchForm_1"><span style='display:none;'><%=userNLS.get("email1")%></span></label>
      <input size="30" type="text" name="email" maxlength="254" id="ShopperSearchB2C_FormInput_email_In_searchForm_1" /></td>
      <td id="ShopperSearchB2C_TableCell_6"><br />
                <label for="emailSearchType1"><span style='display:none;'><%=userNLS.get("email1")%></span></label>
                <select name="emailSearchType" id="emailSearchType1">
                	<script type="text/javascript">displayCaseSelection()
			</script>
                </select>
      </td>
    </tr>
    <tr>
      <td id="ShopperSearchB2C_TableCell_7"><%=userNLS.get("city")%><br />
      <label for="ShopperSearchB2C_FormInput_city_In_searchForm_1"><span style='display:none;'><%=userNLS.get("city")%></span></label>
      <input size="30" type="text" name="city" maxlength="128" id="ShopperSearchB2C_FormInput_city_In_searchForm_1" /></td>
      <td id="ShopperSearchB2C_TableCell_8"><br />
      		<label for="citySearchType1"><span style='display:none;'><%=userNLS.get("city")%></span></label>
                <select name="citySearchType" id="citySearchType1">
                	<script type="text/javascript">displayCaseSelection()
			</script>
                </select>
      </td>
    </tr>
    <tr>
      <td id="ShopperSearchB2C_TableCell_9"><%=userNLS.get("zip")%><br />
      <label for="ShopperSearchB2C_FormInput_zip_In_searchForm_1"><span style='display:none;'><%=userNLS.get("zip")%></span></label>
      <input size="30" type="text" name="zip" maxlength="40" id="ShopperSearchB2C_FormInput_zip_In_searchForm_1" /></td>
      <td id="ShopperSearchB2C_TableCell_10"><br />
      		<label for="zipSearchType1"><span style='display:none;'><%=userNLS.get("zip")%></span></label>
                <select name="zipSearchType" id="zipSearchType1">
                	<script type="text/javascript">displayCaseSelection()
			</script>
                </select>
      </td>
    </tr>

  </tbody>
</table>

</form>
</body>
</html>
<%
} catch (Exception e) {
	e.printStackTrace();
}
%>

