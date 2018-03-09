<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2012 All Rights Reserved.

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
<%@page import="com.ibm.commerce.server.ECConstants" %>
<%@page import="com.ibm.commerce.command.CommandContext" %>
<%@include file="common.jsp" %>
<jsp:useBean id="searchBean" scope="request" class="com.ibm.commerce.tools.common.ui.SearchDialogBean"></jsp:useBean>
<%
    searchBean.setRequest(request);
%>
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE7" />
<link rel="stylesheet" type="text/css" href="<%= UIUtil.getCSSFile(searchBean.getLocale()) %>"/>
<script type="text/javascript" src="/wcs/javascript/tools/common/Util.js"></script>
<script type="text/javascript" src="/wcs/javascript/tools/common/DateUtil.js"></script>
<script type="text/javascript" src="/wcs/javascript/tools/common/URLParser.js"></script>
<script type="text/javascript">

// Search variables and functions
parent.resultURL = "<%= searchBean.getResultUrl() %>";
parent.resultTargetFrame = "<%= searchBean.getResultTargetFrame() %>";
parent.resultNavigationPanelXMLFile = "<%= searchBean.getResultNavigationPanelXMLFile() %>";
parent.hasSetBCT = <%= searchBean.hasSetBCT() %>;
parent.isNewTrail = <%= searchBean.isNewTrail() %>;
parent.bctName = "<%= searchBean.getBCTName() %>";
parent.criteriaHelpKey = "<%= searchBean.getCriteriaHelpKey() %>";
parent.resultHelpKey = "<%= searchBean.getResultHelpKey() %>";
var parentHead = parent.document.body.previousSibling;

// Set the help key.
if (parent.criteriaHelpKey != "") {
	parent.page['helpKey'] = parent.criteriaHelpKey;
}

// Generates user's JS messages
<%	

	CommandContext cmdContext = (CommandContext)request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
	Locale locale = cmdContext.getLocale();

	Hashtable calendarNLS = (Hashtable)ResourceDirectory.lookup("common.calendarNLS", locale);
	Hashtable mccNLS = (Hashtable)ResourceDirectory.lookup("common.mccNLS", locale);

	// Populate user-defined JS Messages.
	Vector jsMessages = searchBean.getJSMessages();

	for (int i = 0; i<jsMessages.size(); i++) {
		Hashtable jsMessage = (Hashtable)jsMessages.elementAt(i);
		String jsName = "";
		String jsValue = "";

		if (jsMessage.containsKey("resourceKey")) {
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
	if (parent.userLoadPanelData) {
		parent.userLoadPanelData();
	}
		 
	loadPanelData();
	parent.setContentFrameLoaded(true);
}

function savePanelData() {
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
		// select-multiple
		else if (type == "select-multiple") {
			var entries = new Array();
			for (var j = 0; j < document.searchForm.elements[i].options.length; j++) {
				if (document.searchForm.elements[i].options[j].selected == true) {
					entries[entries.length] = document.searchForm.elements[i].options[j].value;
					parent.NAVIGATION.addURLParameter(name, document.searchForm.elements[i].options[j].value);
				}
			}
			parent.put(name, entries);
		}
		// radio and checkbox
		else if (type == "radio" || type == "checkbox") {
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
			
			// Set the resultHelpkey
			if (parent.resultHelpKey != "") {
				parent.page['helpKey'] = parent.resultHelpKey;
			}
			
			return true;
		}
		else {
			return false;
		}
	}
	else {
		parent.NAVIGATION.location = url;

		// Set the resultHelpkey
		if (parent.resultHelpKey != "") {
			parent.page['helpKey'] = parent.resultHelpKey;
		}
		
		return true;
	}
}

function loadPanelData() {
	for (var i = 0; i < document.searchForm.length; i++) {
		var name = document.searchForm.elements[i].name;
		var type = document.searchForm.elements[i].type;
		// text
		if (type == "text") {
			var inputValue = parent.get(name);
			if (inputValue) {
				document.searchForm.elements[i].value = inputValue;
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
		// select-multiple
		else if (type == "select-multiple") {
			var selectedEntries = parent.get(name);
			for (var j = 0; j < document.searchForm.elements[i].options.length; j++) {
				var entry = document.searchForm.elements[i].options[j].value;
				if (arrayContains(selectedEntries, entry)) {
					document.searchForm.elements[i].options[j].selected = true;
				}
			}
		}
		// radio
		else if (type == "radio" || type == "checkbox") {
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

function setupCalendar(year, month, day) {
	window.yearField = eval("document.searchForm." + year);
	window.monthField = eval("document.searchForm." + month);
	window.dayField = eval("document.searchForm." + day);
}

function blockEnter(evt) {
    evt = (evt) ? evt : event;
    var charCode = (evt.charCode) ? evt.charCode :
        ((evt.which) ? evt.which : evt.keyCode);
    if (charCode == 13 || charCode == 3) {
        return false;
    } else {
        return true;
    }
}

</script>
</head>
<body class="content" onload="init();">
<div class="searchTitle"><%= searchBean.getTitle() %></div>
<br>
<div class="searchDesc"><%= searchBean.getDescription() %></div>
<br><br>
<div class="searchTable">
<form name="searchForm" onsubmit="processForm()">
<table border="0" bordercolor="#0080C0" cellpadding="2" cellspacing="0">
	<tbody>
<%

Hashtable field = null;
String type = null;
String name = null;
String value = null;
String key = null;
Vector criteria = searchBean.getFields();
boolean hasCalendar = false;

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
		String nameId = "";
			
		if (field.containsKey("name")) {
			nameId = (String)field.get("name");
		}
		
		/***** Field Name *****/
		if (field.containsKey("resourceKey")) {
			String resourceKey = (String)field.get("resourceKey");
			
			out.println("\t\t<tr>");
			out.println("\t\t\t<td colspan=\"2\" valign=\"top\" nowrap=\"nowrap\"><label for=\"" + nameId + "\">" + searchBean.getResourceString(resourceKey) + "</label></td>");
			out.println("\t\t</tr>");
		}		
		
		out.println("\t\t<tr>");

		/***** Field Input *****/
		out.println("\t\t\t<td align=\"left\" valign=\"top\">");
		if (type != null) {
			tagOpened = true;
			if (type.equalsIgnoreCase("text")) {
			    out.print("\t\t\t\t<input type=\"text\"");
			}
			else if (type.equalsIgnoreCase("select-one")) {
				out.print("\t\t\t\t<select");
			} 
			else if (type.equalsIgnoreCase("select-multiple")) {
				out.print("\t\t\t\t<select multiple=\"multiple\"");
			}
			else if (type.equalsIgnoreCase("radio")) {
			    out.print("\t\t\t\t<input type=\"radio\"");
			}
			else {
			    tagOpened = false;
			}			    
		}

		if (field.containsKey("name") && !type.equalsIgnoreCase("checkbox")) {
			name = (String)field.get("name");
			out.print("  id=\"" + name + "\" name=\"" + name + "\"");
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
			if (type.equalsIgnoreCase("text")) {
				out.println(" onkeydown=\"return blockEnter(event)\" />");
			}
			else if (type.equalsIgnoreCase("select-one") || type.equalsIgnoreCase("select-multiple")) {
			    Hashtable options = (Hashtable)searchBean.getUserBean(name);
			    out.println(">");
			    for (Enumeration enumList = options.keys(); enumList.hasMoreElements();) {
			        key = (String)enumList.nextElement();
			        value = (String)options.get(key);
			        out.println("\t\t\t\t\t<option value=\"" + key + "\">" + value + "</option>");
			    }
				out.println("\t\t\t\t</select>");
			}
			else if (type.equalsIgnoreCase("radio")) {
			    Hashtable radio = (Hashtable)searchBean.getUserBean(name);
			    int radioCounter = 0;
			    for (Enumeration enumList = radio.keys(); enumList.hasMoreElements();) {
			    	radioCounter++;
			        key = (String)enumList.nextElement();
			        value = (String)radio.get(key);
			        out.print("value=\"" + key + "\"/>" + value);
			        if (enumList.hasMoreElements()) {
			            out.print("&nbsp;&nbsp;<input type=\"radio\" id=\"" + name + radioCounter + "\" name=\"" + name + "\" ");
	                }
			    }
				out.println("\t\t\t\t</select>");
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
		            if (checkBox.containsKey("name")) {
						checkBoxName = (String)checkBox.get("name");
					}
					
		            if (checkBox.containsKey("value")) {
						checkBoxValue = (String)checkBox.get("value");
					}
											
		            if (checkBox.containsKey("resourceKey")) {
						checkBoxResourceKey = (String)checkBox.get("resourceKey");
					}
					
					out.print("<input type=\"checkbox\" id=\"" + checkBoxName + j + "\" name=\"" + checkBoxName + "\" value=\"" + checkBoxValue + "\"/>");
					out.print(searchBean.getResourceString(checkBoxResourceKey));
					out.print("&nbsp;&nbsp;");
				}
		    }
		    out.println();
		}
		else if (type != null && type.equalsIgnoreCase("calendar")) {
			Hashtable yearField = null;
			Hashtable monthField = null;
			Hashtable dayField = null;

			if (field.containsKey("yearField")) {
				yearField = (Hashtable)field.get("yearField");
			}
			
			if (field.containsKey("monthField")) {
				monthField = (Hashtable)field.get("monthField");
			}
			
			if (field.containsKey("dayField")) {
				dayField = (Hashtable)field.get("dayField");
			}
			
			if (yearField != null && monthField != null && dayField != null) {
				String yearName = (yearField.containsKey("name"))?((String)yearField.get("name")):(null);
				String monthName = (monthField.containsKey("name"))?((String)monthField.get("name")):(null);
				String dayName = (dayField.containsKey("name"))?((String)dayField.get("name")):(null);

				if (yearName != null && monthName != null && dayName != null) {
					out.println("\t\t\t\t<input type=\"text\" id=\"" + yearName + "\" name=\"" + yearName + "\" size=\"4\" maxlength=\"4\"/>&nbsp;/");
					out.println("\t\t\t\t<input type=\"text\" id=\"" + monthName + "\" name=\"" + monthName + "\" size=\"2\" maxlength=\"4\"/>&nbsp;/");
					out.println("\t\t\t\t<input type=\"text\" id=\"" + dayName + "\" name=\"" + dayName + "\" size=\"2\" maxlength=\"2\"/>");
					out.println("\t\t\t\t<a href=\"javascript:setupCalendar('" + yearName + "', '" + monthName + "', '" + dayName + "'); showCalendar(document.searchForm." + yearName + "CalImg);\"><img alt=\"" + calendarNLS.get("showCalendar") + "\" border=\"0\" id=\"" + yearName + "CalImg\" src=\"/wcs/images/tools/calendar/calendar.gif\"></a>");
					hasCalendar = true;
				}
			}
		}
		out.println("\t\t\t</td>");
	
		/***** Operator Column *****/
		out.println("\t\t\t<td align=\"left\" valign=\"top\">");
		if (field.containsKey("operatorBox")) {
			Hashtable operatorBox = (Hashtable)field.get("operatorBox");
			Vector operator = null;

			if (operatorBox.containsKey("name")) {
				name = (String)operatorBox.get("name");
				out.println("\t\t\t\t<label for=\"" + name + "\" class=\"hidden-label\">" + mccNLS.get("searchOptions") + "</label>");
				out.println("\t\t\t\t<select id=\"" + name + "\" name=\"" + name + "\">");
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
	
		out.println("\t\t</tr>");
		out.println("\t\t<tr>");
		out.println("\t\t\t<td colspan=\"2\" height=\"1\">&nbsp;</td>");
		out.println("\t\t</tr>");
	}
}
%>
	</tbody>
</table>
</form>
</div>
<%
if (hasCalendar) {
%>
<script type="text/javascript">
	document.writeln('<iframe id="CalFrame" title="' + top.calendarTitle + '" marginheight="0" marginwidth="0" frameborder="0" scrolling="no" src="/webapp/wcs/tools/servlet/Calendar" style="display: none; position: absolute; width: 198px; height: 230px; z-index: 5;"></iframe>');
	document.onclick=hideCalendar;
</script>
<%
}
%>
</body>
</html>