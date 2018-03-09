
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2008, 2013 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%@page import="java.util.*" %>
<%@page import="com.ibm.commerce.tools.util.*" %>
<%@page import="com.ibm.commerce.tools.common.*" %>
<%@page import="com.ibm.commerce.tools.common.ui.*" %>
<%@page import="com.ibm.commerce.tools.command.*" %>
<%@include file="epromotionCommon.jsp" %>
<jsp:useBean id="searchBean" scope="request" class="com.ibm.commerce.tools.common.ui.SearchDialogBean"></jsp:useBean>
<%
    searchBean.setRequest(request);
%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<link rel="stylesheet" type="text/css" href="<%= UIUtil.getCSSFile(searchBean.getLocale()) %>"/>
<script src="/wcs/javascript/tools/common/Util.js">
</script>
<script src="/wcs/javascript/tools/common/DateUtil.js">
</script>
<script src="/wcs/javascript/tools/common/URLParser.js">
</script>
<script>

top.mccmain.mcccontent.isInsideWizard = function() {
       return true;
}

	var rlpage = top.get("<%= RLConstants.RLPROMOTION_PROD_SEARCH_PAGE %>",null);
	if (rlpage == "RLProdPromoWhat")
	{
		top.help['MC.discount.productSearch2.Help'] = top.help['MC.discount.productSearch2Wht.Help'];
	}
	else if (rlpage == "RLProdPromoGWP" || rlpage == "RLDiscountGWP")
	{	
		top.help['MC.discount.productSearch2.Help'] = top.help['MC.discount.productSearch2Gwp.Help'];
	}
	
	var o = top.getData("RLPromotion", 1);
	var rlpagename = top.get("<%= RLConstants.RLPROMOTION_PROD_SEARCH_PAGE %>");
	var calCodeId = null; 
	var productSKU = null;
	var promoType = null;
	if (o != null) {
		calCodeId = o.<%= RLConstants.EC_CALCODE_ID %>;
		promoType = o.<%= RLConstants.RLPROMOTION_MERCHANDISE_TYPE %>; 		
		productSKU = o.<%= RLConstants.RLPROMOTION_PRODUCT_SKU %>
	}
	else
	{
		promoType = top.get("<%= RLConstants.RLPROMOTION_MERCHANDISE_TYPE%>"); 
		productSKU = top.get("RLSkuList");
	}

parent.resultURL = "<%= searchBean.getResultUrl() %>"+"&pagename="+rlpagename+"&calCodeId="+calCodeId+"&promotype="+promoType;
parent.resultTargetFrame = "<%= searchBean.getResultTargetFrame() %>";
parent.resultNavigationPanelXMLFile = "<%= searchBean.getResultNavigationPanelXMLFile() %>";
var parentHead = parent.document.body.previousSibling;

// Generates user's JS messages
<%

	// Populate user-defined JS Messages.
	Vector jsMessages = searchBean.getJSMessages();

	for (int i = 0; i<jsMessages.size(); i++) {
		Hashtable jsMessage = (Hashtable)jsMessages.elementAt(i);
		String jsName = "";
		String jsValue = "";

		if (jsMessage.containsKey("resourceKey"))
		{
			jsValue = searchBean.getResourceString((String)jsMessage.get("resourceKey"));
		}

		if (jsMessage.containsKey("name")) {
			jsName = (String)jsMessage.get("name");
			out.println("parent." + jsName + " = \"" + jsValue + "\";");
		}
	}

%>

// Includes user's JS scripts
<%

	// Import user-defined JS files.
	Vector jsFiles = searchBean.getJSFiles();

	for (int i = 0; i<jsFiles.size(); i++) {
		Hashtable jsFile = (Hashtable)jsFiles.elementAt(i);
		if (jsFile.containsKey("src")) {
			out.println("var userScript" + i + " = parent.document.createElement('SCRIPT');");
			out.println("userScript" + i + ".src = \"" + (String)jsFile.get("src") + "\";");
			out.println("if (!parent.userScriptLoaded) {");
			out.println("\tparentHead.appendChild(userScript" + i + ");");
			out.println("}");
		}
	}

%>

if (!parent.userScriptLoaded) {
	parent.userScriptLoaded = true;
}

function init() {
	loadPanelData();
	parent.setContentFrameLoaded(true);
}

function savePanelData() {
	var rlpagename = top.get("<%= RLConstants.RLPROMOTION_PROD_SEARCH_PAGE %>");
	if (rlpagename != null)
	{
		top.put(rlpagename,"<%= RLConstants.RLPROMOTION_PROD_SEARCH_PAGE %>");
	}

	for (var i = 0; i < document.searchForm.length; i++) {
		var name = document.searchForm.elements[i].name;
		var type = document.searchForm.elements[i].type;

		// text and hidden fields
		if (type == "text" || type == "hidden") {
			parent.put(name, document.searchForm.elements[i].value);
			parent.NAVIGATION.addURLParameter(name, document.searchForm.elements[i].value);
		}
		// select-one
		else if (type == "select-one") {
			var selectedIndex = document.searchForm.elements[i].selectedIndex;
			if (selectedIndex > -1) {
				parent.put(name, document.searchForm.elements[i].options[selectedIndex].value);
				parent.NAVIGATION.addURLParameter(name, document.searchForm.elements[i].options[selectedIndex].value);
			}
		}

		// radio 
		else if (type == "radio") {
			if (document.searchForm.elements[i].checked) {
				parent.put(name, document.searchForm.elements[i].value);
				parent.NAVIGATION.addURLParameter(name, document.searchForm.elements[i].value);
			}
		}
	}

	// Call user's savePanelData if available
	if (parent.userSavePanelData) {
		parent.userSavePanelData();
	}
}

function validatePanelData() {
	var urlParser = new URLParser(parent.NAVIGATION.document.URL);
	var url = urlParser.getRequestURI() + "?XMLFile=" + parent.resultNavigationPanelXMLFile;

	// Call user's validatePanelData if available
	if (parent.userValidatePanelData) {
		if (parent.userValidatePanelData() == true) {
			parent.NAVIGATION.location = url;
			return true;
		}
		else {
			return false;
		}
	}
	else {
		parent.NAVIGATION.location = url;
		return true;
	}
}

function cancelAction() {
		top.goBack();
}

function loadPanelData() {
	var rlpagename = top.get("<%= RLConstants.RLPROMOTION_PROD_SEARCH_PAGE %>",null);
    var rlPromo = top.getData("RLPromotion");
    var firstField=0;
	for (var i = 0; i < document.searchForm.length; i++) {
		var name = document.searchForm.elements[i].name;
		var type = document.searchForm.elements[i].type;
		// text
		if (type == "text") {
			var inputValue = parent.get(name);
			if (inputValue) {
				document.searchForm.elements[i].value = inputValue;
			}
			if (firstField == 0)
			{
				firstField = 1;
				document.searchForm.elements[i].focus();
			}
		}
		// select-one
		else if (type == "select-one") {
			var selectedValue = parent.get(name);
			for (var j = 0; j < document.searchForm.elements[i].options.length; j++) {
				if (document.searchForm.elements[i].options[j].value == selectedValue) {
					document.searchForm.elements[i].options[j].selected = true;
				}
			}
		}
		// radio
		else if (type == "radio") {
			var checkedValue = parent.get(name);
			if (document.searchForm.elements[i].value == checkedValue) {
				document.searchForm.elements[i].checked = true;
			}
		}
	}
}

function arrayContains(arrayObj, value) {
	if (arrayObj != null) {
		for (var i = 0; i < arrayObj.length; i++) {
			if (arrayObj[i] == value)
				return true;
		}
	}
	else
		return false;
}




</script>
<meta name="GENERATOR" content="IBM WebSphere Studio" />
</head>
<body class="content" onload="init();">
<h1><%= RLPromotionNLS.get("ProductSearchBrowserTitle") %></h1>
<div class="searchTitle"><%= searchBean.getTitle() %></div>
<br />
<div class="searchDesc"><%= searchBean.getDescription() %></div>
<br /><br />
<table id="WC_RLSearchDialogCriteria_Table_1"> <tr> <td id="WC_RLSearchDialogCriteria_TableCell_1"> <%= RLPromotionNLS.get("productFindDescription") %> </td> </tr> </table>
<div class="searchTable">
<table cellpadding="3" cellspacing="4" id="WC_RLSearchDialogCriteria_Table_2">
	<tbody>
		<form name="searchForm" onsubmit="processForm()" id="searchForm">
<%

Hashtable field = null;
String type = null;
String name = null;
String value = null;
String key = null;
Vector criteria = searchBean.getFields();

for (int i = 0; i<criteria.size(); i++) {
	field = (Hashtable)criteria.elementAt(i);
	type = null;

	if (field.containsKey("type") && field.containsKey("name")) {
		type = (String)field.get("type");
		name = (String)field.get("name");

		if (type.equalsIgnoreCase("hidden")) {
			out.print("\t\t\t<input type=\"hidden\" name=\"" + name + "\" ");
			if (field.containsKey("value")) {
				value = (String)field.get("value");
			}
			else if (field.containsKey("beanMethod")) {
				value = (String)searchBean.getUserBean(name);
			}
			else {
				value = "";
			}
			out.println("value=\"" + value + "\">");
		}
	}
}

for (int i = 0; i < criteria.size(); i++) {
	field = (Hashtable)criteria.elementAt(i);
	boolean tagOpened = false;
	type = null;
	name = null;


	if (field.containsKey("type")) {
		type = (String)field.get("type");
	}

	if (type != null && !type.equalsIgnoreCase("hidden")) {
		out.println("\t\t<tr></tr><tr>");

		/***** Field Name *****/
		if (field.containsKey("resourceKey")) {
			String resourceKey = (String)field.get("resourceKey");
			out.println("\t\t\t<td valign=\"top\" nowrap>" + searchBean.getResourceString(resourceKey) + "</td></tr><tr>");
		}
		else {
			out.println("\t\t\t<td valign=\"top\" >&nbsp;</td>");
		}
		/***** Field Input *****/
		out.print("\t\t\t<td align=\"left\" valign=\"top\" >" + System.getProperty("line.separator"));
		if (type != null) {
			tagOpened = true;
			if (type.equalsIgnoreCase("text"))
			{
			    out.print("\t\t\t\t<input type=\"text\"");
			}
			else if (type.equalsIgnoreCase("select-one"))
			{
				out.print("\t\t\t\t<select");
			}
			else if (type.equalsIgnoreCase("select-multiple"))
			{
				out.print("\t\t\t\t<select multiple");
			}
			else if (type.equalsIgnoreCase("radio"))
			{
			    out.print("\t\t\t\t<input type=\"radio\"");
			}
			else
			    tagOpened = false;
		}

		if (field.containsKey("name") && !type.equalsIgnoreCase("checkbox")) {
			name = (String)field.get("name");
			out.print(" name=\"" + name + "\"" + " id=\"" + name + "\"");
		}

		if (field.containsKey("size") && (!type.equalsIgnoreCase("radio") || !type.equalsIgnoreCase("checkbox"))) {
			String size = (String)field.get("size");
			out.print(" size=\"" + size + "\"");
		}

		if (field.containsKey("maxlength") && type.equalsIgnoreCase("text")) {
			String maxLength = (String)field.get("maxlength");
			out.print(" maxlength=\"" + maxLength + "\"");
		}

		if (tagOpened) {
			if (type.equalsIgnoreCase("text"))
			{
				out.print(">" + System.getProperty("line.separator"));
			}
			else if (type.equalsIgnoreCase("select-one") || type.equalsIgnoreCase("select-multiple")) {
			    Hashtable options = (Hashtable)searchBean.getUserBean(name);
			    out.print(">" + System.getProperty("line.separator"));
			    for (Enumeration enumList = options.keys(); enumList.hasMoreElements();) {
			        key = (String)enumList.nextElement();
			        value = (String)options.get(key);
			        out.print("\t\t\t\t\t<option value=\"" + key + "\">" + value + "</option>"+System.getProperty("line.separator"));
			    }
				out.print("\t\t\t\t</select>"+System.getProperty("line.separator"));
			}
			else if (type.equalsIgnoreCase("radio")) {
			    Hashtable radio = (Hashtable)searchBean.getUserBean(name);
			    for (Enumeration enumList = radio.keys(); enumList.hasMoreElements();) {
			        key = (String)enumList.nextElement();
			        value = (String)radio.get(key);
			        out.print("value=\"" + key + "\">" + value);
			        if (enumList.hasMoreElements()) {
			            out.print("&nbsp;&nbsp;<input type=\"radio\" name=\"" + name + "\" ");
	                }
			    }
				out.print("\t\t\t\t</select>"+System.getProperty("line.separator"));
			}
		}
		else if (type != null && type.equalsIgnoreCase("checkbox")) {
		    Vector checkBoxes = Util.convertToVector(field.get("checkbox"));
		    out.print("\t\t\t\t");
		    for (int j = 0; j < checkBoxes.size(); j++) {
		        Hashtable checkBox = (Hashtable)checkBoxes.elementAt(j);
		        String checkBoxName = null;
		        String checkBoxValue = null;
		        String checkBoxResourceKey = null;

		        if (checkBox != null) {
		            if (checkBox.containsKey("name"))
		            {
						checkBoxName = (String)checkBox.get("name");
					}
		            if (checkBox.containsKey("value"))
		            {
						checkBoxValue = (String)checkBox.get("value");
					}
		            if (checkBox.containsKey("resourceKey"))
		            {
						checkBoxResourceKey = (String)checkBox.get("resourceKey");
					}

					out.print("<input type=\"checkbox\" name=\"" + checkBoxName + "\" value=\"" + checkBoxValue + "\">");
					out.print(searchBean.getResourceString(checkBoxResourceKey));
					out.print("&nbsp;&nbsp;");
				}
		    }
		    out.print(System.getProperty("line.separator"));
		}

	}


		/***** Operator Column *****/
		out.println("\t\t\t<td align=\"left\" valign=\"top\" >");
		if (field.containsKey("operatorBox")) {
			Hashtable operatorBox = (Hashtable)field.get("operatorBox");
			Vector operator = null;

			if (operatorBox.containsKey("name")) {
				name = (String)operatorBox.get("name");
				out.println("\t\t\t\t<select name=\"" + name + "\" id=\"" + name + "\">");
			}

			if (operatorBox.containsKey("operator")) {
				operator = Util.convertToVector(operatorBox.get("operator"));
				for (int k = 0; k < operator.size(); k++) {
					Hashtable op = (Hashtable)operator.elementAt(k);
					if (op.containsKey("value")) {
						value = (String)op.get("value");
						out.print("\t\t\t\t\t<option value=\"" + value + "\">");
						if (op.containsKey("resourceKey")) {
							String displayName = searchBean.getResourceString((String)op.get("resourceKey"));
							out.println(displayName + "</option>");
						}
						else {
							out.println(value + "</option>");
						}
					}
				}
			}

			if (operatorBox.containsKey("name")) {
				out.println("\t\t\t\t</select>");
			}
		}
		else {
			out.println("\t\t\t\t&nbsp;");
		}
		out.println("\t\t\t</td>");

}

%>
		</form>
	</tbody>
</table>
</div>
<pre>


</pre>
</body>
</html>