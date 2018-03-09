<%--
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2001, 2016
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
//*
--%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<%@ page language="java" import="java.util.*" %>
<%@ page import="com.ibm.commerce.server.*" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.datatype.TypedProperty" %>

<%@include file="../common/common.jsp" %>

<!-- Get the resource bundle with all the NLS strings and find OrdeDataBean with order_rn -->
<%
CommandContext cmdContextLocale = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
Locale jLocale = cmdContextLocale.getLocale();
Hashtable orderAddProducts 	= (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("order.orderAddProducts", jLocale);
JSPHelper jspHelper 	= new JSPHelper(request);
String customerId	= jspHelper.getParameter("customerId");
String selectedOrgId	= jspHelper.getParameter("activeOrganizationId");
TypedProperty property = (TypedProperty)request.getAttribute("RequestProperties");

if (customerId != null) {
		property.put(com.ibm.commerce.server.ECConstants.EC_FOR_USER_ID, customerId);
}

cmdContextLocale.setRequestProperties(property);

%>

<html>
  <head>
    <link rel="stylesheet" href="<%= UIUtil.getCSSFile(jLocale) %>" type="text/css" /> 
    <title><%= UIUtil.toHTML((String)orderAddProducts.get("addProductPageSearch")) %></title>

      <script type="text/javascript" src="/wcs/javascript/tools/common/ConvertToXML.js"></script>
      <script type="text/javascript" src="/wcs/javascript/tools/common/Util.js"></script>
      <script type="text/javascript">
	<!-- <![CDATA[	
	function trim(inString) {
		var retString = inString;
		var ch = retString.substring(0,1);
 		while(ch == " "){
 			retString=retString.substring(1,retString.length);
 			ch=retString.substring(0,1);
 		}
 		ch=retString.substring(retString.length-1,retString.length)
 		while(ch == " "){
 			retString=retString.substring(0,retString.length-1);
 			ch=retString.substring(retString.length-1,retString.length);	
		}
		return retString;
	} 	
	
	function isNumber(word) 
	{
		var numbers="0123456789";
		var word=trim(word);
		for (var i=0; i < word.length; i++)
		{
			if (numbers.indexOf(word.charAt(i)) == -1) 
			return false;
		}
		return true;
	}

	function initializeState() {
		parent.setContentFrameLoaded(true);
	}
	
	function getValueForSelection(name) {
		selectedIndex = document.itemsSearch[name].selectedIndex;
		return document.itemsSearch[name].options[selectedIndex].value;
	}

	function addProductList()
	{
		// gather all form data
		var searchSkuNumber 	= document.itemsSearch.searchSKUNumber.value;
		var skuSearchType 	= getValueForSelection("skuSearchType");
		
		var itemChecked 	= document.itemsSearch["item"].checked;
		var productChecked 	= document.itemsSearch["product"].checked;
		var packageChecked 	= document.itemsSearch["package"].checked;
		var bundleChecked 	= document.itemsSearch["bundle"].checked;
		var searchProductName 	= document.itemsSearch.searchProductName.value;
		var nameSearchType 	= getValueForSelection("nameSearchType");
		var searchProductDesc 	= document.itemsSearch.searchProductDesc.value;
		var descSearchType 	= getValueForSelection("descSearchType");
		var searchMaxMatches 	= document.itemsSearch.searchMaxMatches.value;
		
		// validate data and create the passing URL object
		var searchResultURL 		= "/webapp/wcs/tools/servlet/DialogView"
		var URLParam 			= new Object();
		URLParam.XMLFile		= "order.orderAddProductListDialogB2B";
		URLParam.customerId		= "<%=customerId%>";
		URLParam.activeOrganizationId     = "<%=selectedOrgId%>";
		
		if ( !itemChecked && !productChecked && !packageChecked && !bundleChecked) {
			alertDialog("<%=UIUtil.toJavaScript((String)orderAddProducts.get("addProductPageNoTypeError"))%>");
			return;
		}
			
		if ((searchSkuNumber == null || searchSkuNumber.length == 0) &&
		    (searchProductName == null || searchProductName.length == 0) &&
		    (searchProductDesc == null || searchProductDesc.length == 0)) {
			alertDialog("<%=UIUtil.toJavaScript((String)orderAddProducts.get("addProductPageNoCriteriaError"))%>");
			return;
		}
		
		//validate maximum number to display
		if ( document.itemsSearch.searchMaxMatches.value != "100") {
			if ( !isNumber(document.itemsSearch.searchMaxMatches.value) || document.itemsSearch.searchMaxMatches.value == "0") {
				alertDialog ('<%=UIUtil.toJavaScript((String)orderAddProducts.get("invalidMaxDisplay"))%>');
				return;
			}
		}
			
		URLParam.searchSKUNumber 	= searchSkuNumber;
		URLParam.skuSearchType 		= skuSearchType;
		URLParam.searchProductName 	= searchProductName;
		URLParam.nameSearchType 	= nameSearchType;
		URLParam.searchProductDesc 	= searchProductDesc;
		URLParam.descSearchType 	= descSearchType;
		URLParam.searchMaxMatches 	= searchMaxMatches;
			
		var type = "";
		if (itemChecked)
			if (type == "")
				type += "item";
			else
				type += ",item";
		if (productChecked)
			if (type == "")
				type += "product";
			else
				type += ",product";
		if (packageChecked)
			if (type == "")
				type += "package";
			else
				type += ",package";
		if (bundleChecked)
			if (type == "")
				type += "bundle";
			else
				type += ",bundle";
					
		URLParam.searchType=type;
		
		top.mccmain.submitForm(searchResultURL,URLParam);
      		top.refreshBCT();
	}

	function closeDialog()
	{
  		top.goBack();
	}
	
	function toggleCheckBox(name) {
      		var isChecked = document.itemsSearch[name].checked;
      		
      		if (isChecked) {
      			document.itemsSearch[name].value = "true";
		} else {
			document.itemsSearch[name].value = "false";
		}
	}
	
	function clearAdvancedFields() {
		document.all["product"].checked = false;
		document.all["product"].value = "false";
		document.all["package"].checked = false;
		document.all["package"].value = "false";
		document.all["bundle"].checked = false;
		document.all["bundle"].value = "false";
		
		document.all["searchProductName"].value = "";
		document.all["nameSearchType"].options[0].selected = true;
		document.all["searchProductDesc"].value = "";
		document.all["descSearchType"].options[0].selected = true;
		document.all["searchMaxMatches"].value = "100";
	}
	
	function toggleDiv() {
		var division = document.all["advancedOptionsDivision"];
		
		if (division.style.display == "none") {
			division.style.display = "block";
		} else {
			division.style.display = "none";
			clearAdvancedFields();
		}
	}
	//Support For Customers,Shopping Under Multiple Accounts. 
	function getFromTop(){
		var orgName = top.get("selectedOrgName");
		//alert("orgname:" + orgName);
		//top.remove("selectedOrgName");
		return orgName; 
		
	}
	//[[>-->
    </script>
  </head>


  <body class="content" onload="initializeState();">
  <h1><%= UIUtil.toHTML((String)orderAddProducts.get("addProductPageSearch")) %></h1>
  <p><%= orderAddProducts.get("addProductPageSearchDescription") %>    
    
<!--Support For Customers,Shopping Under Multiple Accounts. -->
    </p><form name="itemsSearch" method="post" action="">      
    <table border="0" cellpadding="0" cellspacing="0">
        <tr>
          <td valign="bottom" align="left">
            <%= UIUtil.toHTML((String)orderAddProducts.get("activeOrganization")) %>
          </td>
          <td>
          &nbsp;&nbsp;
          </td>
          <td valign="bottom" align="left">
            <i><script>document.write(getFromTop()); </script></i>
          </td>
        </tr>
        
   </table>
      <table>
        <tr>
          <td valign="bottom" align="left">
            &nbsp;<br /><label for="SKUNum"><%= UIUtil.toHTML((String)orderAddProducts.get("addProductPageSearchSKU")) %></label>
          </td>
          <td valign="bottom" align="left">
            <input id="SKUNum" type="text" maxlength="64" name="searchSKUNumber" />
          </td>
          <td valign="bottom" align="left">
	    <label for="SKUNumSearchType">
            <select id="SKUNumSearchType" name="skuSearchType">
		<option value="1" selected ="selected"><%= UIUtil.toHTML((String)orderAddProducts.get("addProductPageSearchType1")) %></option>
		<option value="2"><%= UIUtil.toHTML((String)orderAddProducts.get("addProductPageSearchType2")) %></option>
		<option value="3"><%= UIUtil.toHTML((String)orderAddProducts.get("addProductPageSearchType3")) %></option>
		<option value="4"><%= UIUtil.toHTML((String)orderAddProducts.get("addProductPageSearchType4")) %></option>
		<option value="5"><%= UIUtil.toHTML((String)orderAddProducts.get("addProductPageSearchType5")) %></option>
            </select>  
            </label>          
          </td>
        </tr>
        <tr>
          <td>
          <br />
          <u><%= UIUtil.toHTML((String)orderAddProducts.get("addProductPageSearchAdvancedOptions")) %></u>
          <br />
          </td>
        </tr>
      </table>
      
      <table>
        <tr>
          <td rowspan=2 valign="middle" align="left">
            <%= UIUtil.toHTML((String)orderAddProducts.get("addProductPageSearchByType")) %>
          </td>
          <td colspan=2 valign="bottom" align="left">
          <input type="checkbox" name="item" value="true" checked="checked"
                 id="searchItem" onclick="toggleCheckBox(this.name);"/>
                 <label for="searchItem"><%= UIUtil.toHTML((String)orderAddProducts.get("addProductPageSearchItem")) %></label>
          <input type="checkbox" name="product" value="true" checked="checked"
                 id="searchProduct" onclick="toggleCheckBox(this.name);"/>
                 <label for="searchProduct"><%= UIUtil.toHTML((String)orderAddProducts.get("addProductPageSearchProduct")) %></label>
          </td>
        </tr>
	<tr>		
		<td valign="bottom" align="left" colspan="2">
		<input type="checkbox" name="package" value="true" checked="checked"
			   id="searchPackage" onclick="toggleCheckBox(this.name);"/>
			   <label for="searchPackage"><%= UIUtil.toHTML((String)orderAddProducts.get("addProductPageSearchPackage")) %></label>
		<input type="checkbox" name="bundle" value="true" checked="checked"
			   id="searchBundle" onclick="toggleCheckBox(this.name);"/>
			   <label for="searchBundle"><%= UIUtil.toHTML((String)orderAddProducts.get("addProductPageSearchBundle")) %></label>
         </td>
	</tr>
        <tr>
          <td valign="bottom" align="left">
            <label for="searchByName"><%= UIUtil.toHTML((String)orderAddProducts.get("addProductPageSearchByName")) %></label>
          </td>
          <td valign="bottom" align="left">
            <input id="searchByName" type="text" maxlength="64" name="searchProductName" />
          </td>
          <td valign="bottom" align="left">
            <label for="searchByNameType">
            <select id="searchByNameType" name="nameSearchType">
		<option value="1" selected ="selected"><%= UIUtil.toHTML((String)orderAddProducts.get("addProductPageSearchType1")) %></option>
		<option value="2"><%= UIUtil.toHTML((String)orderAddProducts.get("addProductPageSearchType2")) %></option>
		<option value="3"><%= UIUtil.toHTML((String)orderAddProducts.get("addProductPageSearchType3")) %></option>
		<option value="4"><%= UIUtil.toHTML((String)orderAddProducts.get("addProductPageSearchType4")) %></option>
		<option value="5"><%= UIUtil.toHTML((String)orderAddProducts.get("addProductPageSearchType5")) %></option>
            </select>
            </label>
          </td>
        </tr>
        
        <tr>
          <td valign="bottom" align="left">
            <label for="itemDescr"><%= UIUtil.toHTML((String)orderAddProducts.get("addProductPageSearchByDescription")) %></label>
          </td>
          <td valign="bottom" align="left">
            <input id="itemDescr" type="text" maxlength="64" name="searchProductDesc" />
          </td>
          <td valign="bottom" align="left">
            <label for="itemDescrType">
            <select id="itemDescrType" name="descSearchType">
		<option value="1" selected ="selected"><%= UIUtil.toHTML((String)orderAddProducts.get("addProductPageSearchType1")) %></option>
		<option value="2"><%= UIUtil.toHTML((String)orderAddProducts.get("addProductPageSearchType2")) %></option>
		<option value="3"><%= UIUtil.toHTML((String)orderAddProducts.get("addProductPageSearchType3")) %></option>
		<option value="4"><%= UIUtil.toHTML((String)orderAddProducts.get("addProductPageSearchType4")) %></option>
		<option value="5"><%= UIUtil.toHTML((String)orderAddProducts.get("addProductPageSearchType5")) %></option>
            </select>
            </label>
          </td>
        </tr>

        <tr>
          <td valign="bottom" align="left">
            <label for="maxDisplay"><%= UIUtil.toHTML((String)orderAddProducts.get("addProductPageSearchMaxMatches")) %></label>
          </td>
          <td valign="bottom" align="left">
            <input id="maxDisplay" type="text" maxlength="6" name="searchMaxMatches" value="100" />
          </td>
        </tr>
      </table> 

    </form>
  </body>
  </html>

