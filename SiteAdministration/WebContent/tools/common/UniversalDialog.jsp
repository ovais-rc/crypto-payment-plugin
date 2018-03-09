<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<!--
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2004, 2013
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*--------------------------------------------------------------------->
<%@page import="java.util.*" %>
<%@page import="java.sql.Timestamp" %>
<%@page import="java.lang.reflect.Method" %>
<%@page import="com.ibm.commerce.tools.util.*" %>
<%@page import="com.ibm.commerce.tools.common.*" %>
<%@page import="com.ibm.commerce.tools.common.ui.*" %>
<%@page import="com.ibm.commerce.tools.resourcebundle.*" %>
<%@page import="com.ibm.commerce.beans.*" %>
<%@page import="com.ibm.commerce.server.*" %>
<%@page import="com.ibm.commerce.command.*" %>
<%@page import="com.ibm.commerce.ras.*" %>

<%@include file="common.jsp" %>

<%
    JSPHelper jspHelper = new JSPHelper(request);
    String XMLFile = jspHelper.getParameter("XMLFile");
    String targetSection = jspHelper.getParameter("section");
    String finishMsg = jspHelper.getParameter(UIProperties.SUBMIT_FINISH_MESSAGE);
    String errorMsg = jspHelper.getParameter(UIProperties.SUBMIT_ERROR_MESSAGE);

    ECTrace.trace(ECTraceIdentifiers.COMPONENT_TOOLSFRAMEWORK, "UniversalDialogView", "service", "XMLFile=" + XMLFile + (targetSection == null ? "" : "&section=" + targetSection) );

    CommandContext commandContext = (CommandContext) request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
    Hashtable xmlConfig = (Hashtable) ResourceDirectory.lookup(XMLFile);

    Locale locale = (commandContext == null ? Locale.getDefault() : commandContext.getLocale());
%>

<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%= locale.getLanguage() %>" lang="<%= locale.getLanguage() %>">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE7" />
<link rel="stylesheet" type="text/css" href="<%= UIUtil.getCSSFile(locale) %>" />
<script src="<%=  UIUtil.getWebPrefix(request) %>javascript/tools/common/ConvertToXML.js"></script>
<script src="<%=  UIUtil.getWebPrefix(request) %>javascript/tools/common/validator.js"></script>
<script src="<%=  UIUtil.getWebPrefix(request) %>javascript/tools/common/DateUtil.js"></script>

<%
    Hashtable universalDialog = (Hashtable) xmlConfig.get("universalDialog");
    ResourceBundleProperties globalNLS = (ResourceBundleProperties) ResourceDirectory.lookup((String)universalDialog.get("resourceBundle"), locale);
    ResourceBundleProperties calendarNLS = (ResourceBundleProperties) ResourceDirectory.lookup("common.calendarNLS", locale);   // contains common rb keys like "year", "month" and "day"
    ResourceBundleProperties mccNLS = null; // contains common rb keys like "ok" and "cancel", will be loaded when needed

    String formName = (String) universalDialog.get("formName");

    // includeCalendar - whether calendar iframe is needed
    String includeCalendarStr = (String) universalDialog.get("includeCalendar");
    boolean includeCalendar = (includeCalendarStr == null ? false : new Boolean(includeCalendarStr).booleanValue());

    // panelMode - "true" if this widget is used as a panel inside Notebook/Wizard/Dialog
    String panelModeStr = (String) universalDialog.get("panelMode");
    boolean panelMode = (panelModeStr == null ? false : new Boolean(panelModeStr).booleanValue());

    request.setAttribute(ECToolsConstants.EC_UD_XML, universalDialog);
    request.setAttribute(ECToolsConstants.EC_UD_NLS, globalNLS);
    request.setAttribute(ECToolsConstants.EC_UD_LOCALE, locale);
    request.setAttribute(ECToolsConstants.EC_UD_FORM, formName);

    HashMap validators = new HashMap(); // local and global validators

    ECTrace.trace(ECTraceIdentifiers.COMPONENT_TOOLSFRAMEWORK, "UniversalDialogView", "service", "formName=" + formName );

    // instantiate beans
    Vector beans = Util.convertToVector(universalDialog.get("bean"));
    if (beans != null) {
       Hashtable bean = null;
       String type = null;
       Object beanIns = null;
       Class beanClass = null;

       for (Enumeration enumList = beans.elements(); enumList.hasMoreElements();)
       {
          bean = (Hashtable) enumList.nextElement();
          type = (String) bean.get("type");
          beanIns = (Class) request.getAttribute((String) bean.get("id"));
          if (beanIns == null) {
              beanClass = Class.forName( (String) bean.get("class") );
              beanIns = beanClass.newInstance();

              ECTrace.trace(ECTraceIdentifiers.COMPONENT_TOOLSFRAMEWORK, "UniversalDialogView", "service", "beanIns=" + bean.get("class"));

              if (beanIns instanceof SmartDataBean)
              {
                  ECTrace.trace(ECTraceIdentifiers.COMPONENT_TOOLSFRAMEWORK, "UniversalDialogView", "service", "activating smart data bean...");
                  try {
                      DataBeanManager.activate((DataBean)beanIns, request);
                  }
                  catch (Exception e) {
                      String dataBeanError = (String) globalNLS.get("DataBeanAccessControlError");
                      if (dataBeanError == null) {
                          dataBeanError = e.getLocalizedMessage();
                      }
%>
<script>
top.alertDialog("<%= UIUtil.toJavaScript(dataBeanError) %>");
top.goBack();
</script>
<%
                  }
                  ECTrace.trace(ECTraceIdentifiers.COMPONENT_TOOLSFRAMEWORK, "UniversalDialogView", "service", "activated.");
              }
              request.setAttribute((String) bean.get("id"), beanIns);
          }
       }
    }

    // include JS file(s)
    Vector jsFiles = Util.convertToVector(universalDialog.get("jsFile"));
    if (jsFiles != null) {
        Hashtable jsFile = null;
        for (Enumeration enumList = jsFiles.elements(); enumList.hasMoreElements();)
        {
          jsFile = (Hashtable) enumList.nextElement();
%>
          <script src="<%= jsFile.get("src") %>"></script>
<%
        }
    }
%>

<script>

<%
    // panel mode: form data are kept in parent's "model" object
    // standalone mode: form data are kep in local "model" object, which will also be saved in TOP.model object
    if (!panelMode) {
%>

function getHelp() {
    return "<%= universalDialog.get("helpKey") %>";
}

// a javascript object to keep local form data, it'll be put into PARENT
var model = new Object();
<%
    }
%>

// save form data to TOP javascript object, so that it can be restored later
function _saveFormData()
{
    var inputform = document.<%= formName %>;
    for (var i = 0; i < inputform.length; i++) {
        var name = inputform.elements[i].name;
        var type = inputform.elements[i].type;

        // text, textarea and password fields
        if (type == "text" || type == "textarea" || type == "password" || type == "hidden" ) {
            saveData(name, inputform.elements[i].value);
        }
        // select-one
        else if (type == "select-one") {
            var selectedIndex = inputform.elements[i].selectedIndex;
            if (selectedIndex > -1)
                saveData(name, inputform.elements[i].options[selectedIndex].value);
        }
        // select-multiple
        else if (type == "select-multiple") {
            var entries = new Array();
            for (var j = 0; j < inputform.elements[i].options.length; j++) {
                if (inputform.elements[i].options[j].selected) {
                    entries[entries.length] = inputform.elements[i].options[j].value;
                }
            }
            saveData(name, entries);
        }
        // radio
        else if (type == "radio") {
            if (inputform.elements[i].checked)
                saveData(name, inputform.elements[i].value);
        }
        // checkbox
        else if (type == "checkbox") {
            saveData(name, inputform.elements[i].checked);
        }
    }

    // call optional custom function to save custom data
    if (this.saveFormData)
        saveFormData();


<%
    // standalone mode: save "model" object to TOP, so that it can be retrieved later
    // this is useful for form data persistency when controller command returns to current page
    if (!panelMode) {
%>
    top.saveModel(model);
<%
    }
%>

}

// load form data from TOP javascript object
function _loadFormData()
{

<%
    // standalone mode: get "model" object from TOP
    if (!panelMode) {
%>
    model = top.getModel();
<%
    }
%>

    var inputform = document.<%= formName %>;
    for (var i = 0; i < inputform.length; i++) {
        var name = inputform.elements[i].name;
        var type = inputform.elements[i].type;

        var value = getData(name);
        if (value == null)
            continue;

        // text, textarea and password
        if (type == "text" || type == "textarea" || type == "password" || type == "hidden") {
            inputform.elements[i].value = value;
        }
        // select-one
        else if (type == "select-one") {
            for (var j = 0; j < inputform.elements[i].options.length; j++) {
                if (inputform.elements[i].options[j].value == value)
                    inputform.elements[i].options[j].selected = true;
            }
        }
        // select-multiple
        else if (type == "select-multiple") {
            for (var j = 0; j < inputform.elements[i].options.length; j++) {
                inputform.elements[i].options[j].selected = false;
                for (var k = 0; k < value.length; k++) {
                    if (inputform.elements[i].options[j].value == value[k]) {
                        inputform.elements[i].options[j].selected = true;
                        break;
                    }
                }
            }
        }
        // radio
        else if (type == "radio") {
            if (inputform.elements[i].value == value) {
                inputform.elements[i].checked = true;
            }
        }
        // checkbox
        else if (type == "checkbox") {
            inputform.elements[i].checked = value;
        }
    }

    // call optional custom function to load custom data
    if (this.loadFormData)
        loadFormData();
}

// twistie function for section titles
function twistie(id)
{
    var element = document.getElementById(id);
    if (element != null)
        if (element.style.display == "none")
            element.style.display = "block";
        else
            element.style.display = "none";
}

// submit data in a form
function submitData()
{
    _saveFormData();
<%
    // standalone mode: submit form
    if (!panelMode) {
%>
    document._submitForm.XML.value = convertToXML(model, "XML");
    document._submitForm.submit();
<%
    } else { // panel mode: this usually doesn't happen since Finish is normally handled by parent (ie.Notebook)
%>
    parent.finish();
<%
    }
%>

}

// default finish implementation
function finish()
{
    _saveFormData();
    if (validateForm()) {
        submitData();
    }
}

// default cancel implementation
function cancelForm()
{
    if (top.goBack)
        top.goBack();
}

// validation error class
function validationError(name, code, msg)
{
    this.elementName = name;
    this.errorCode = code;
    this.errorMsg = msg;
}

// default validation form implementation
function validateForm()
{
     var errors = getValidationErrors();
     var message = "";

     if (errors == null || errors.length == 0)
        return true;
     else {
        for (i = 0; i < errors.length; i++)
            message += "<li>" + errors[i].errorMsg ;
        _alert(message);
        return false;
     }
}


// convenient function to retrive previously saved javascript data
function getData(key, defaultValue) {
<%
    if (panelMode) {
%>
    return parent.get(key, defaultValue);
<%
    } else {
%>
    if (model[key] == null)
        return defaultValue;
    else
        return model[key];
<%
    }
%>
}


// convenient function to save data as javascript object in either parent (panel mode) or top (standalone mode)
function saveData(key, value) {
<%
    if (panelMode) {
%>
    parent.put(key, value);
<%
    } else {
%>
    model[key] = value;
<%
    }
%>
}

// popup alert
function _alert(msg) {
    if (top.alertDialog)
        top.alertDialog(msg);
    else
        alert(msg);
}

<%
    // generate savePanelData() when panel mode is true
    // note:  validateAllPanels() function needs to be defined in notebook included js file
    if (panelMode) {
%>

function savePanelData() {
    _saveFormData();
}

<%
    }
%>


</script>

</head>

<body class="content" onload="_init()">

<%
    // panel mode: form data will be submitted by parent widget (ie. NotebookNavigation)
    // standalone mode: submit form defined here
    if (!panelMode) {
%>
<form name="_submitForm" method="post" action="<%=universalDialog.get("finishURL")%>">
<input type="hidden" name="XML" value="">
<% if ("true".equals(universalDialog.get("sendAuthToken"))) { %>
<input type="hidden" name="authToken" value="${authToken}">
<% } %>
</form>
<%
    }
%>


<%
    // include init JSP file(s)
    Vector includeFiles = Util.convertToVector(universalDialog.get("include"));
    if (includeFiles != null) {
        Hashtable includeFile = null;
        String includePage = null;
        for (Enumeration enumList = includeFiles.elements(); enumList.hasMoreElements();)
        {
          includeFile = (Hashtable) enumList.nextElement();
          includePage = (String) includeFile.get("page");
          ECTrace.trace(ECTraceIdentifiers.COMPONENT_TOOLSFRAMEWORK, "UniversalDialogView", "service", "Include global JSP segment: " + includePage);
%>
          <jsp:include page="<%= includePage %>" />
<%
        }
    }
    // end of init
%>

<table id="mainTable" <%= universalDialog.get("tableProperty") %>>


<%
    // buttons
    Vector buttons = Util.convertToVector(universalDialog.get("button"));
    if (buttons != null) {
%>
<tr><td>
<table width="100%" border="0" cellspacing="1" cellpadding="0">
<form name="buttonForm">
<tr>
  <td height="1" colspan="10" width="100%" class="dottedLine"></td>
</tr>
<tr>
<td width="99%"></td>
<%
        Hashtable button = null;
        String buttonName = null;
        String buttonLabel = null;
        for (Enumeration enumList = buttons.elements(); enumList.hasMoreElements();)
        {
            button = (Hashtable) enumList.nextElement();
            buttonName = (String) button.get("name");
            buttonLabel = (String) globalNLS.get(buttonName);
            if ( buttonLabel == null ) {  // "ok" and "cancel" are pre-defined in mccNLS.properties
                if (mccNLS == null) {
                    mccNLS = (ResourceBundleProperties) ResourceDirectory.lookup("common.mccNLS", locale);
                }
                buttonLabel = (String) mccNLS.get(buttonName);
            }

%>
          <td align="center">
          <button name="<%= buttonName %>" onclick="<%= button.get("action") %>"><%= buttonLabel %></button>
          </td>
<%
        }
%>
</tr>
<tr>
  <td height="1" colspan=10 width=100% class="dottedLine"></td>
</tr>
</form>
</table>

</td></tr>

<%
    }
    // end of buttons
%>


<form name="<%= formName %>" method="get" action="">
<input type="hidden" name="<%=ECConstants.EC_REDIRECTURL%>" value="UniversalDialogView">
<input type="hidden" name="XMLFile" value="<%=XMLFile%>">

<%
    // writes page title and description if in standalone mode
    if (!panelMode) {
        String pageTitle = (String) universalDialog.get("pageTitle");
        String pageDescription = (String) universalDialog.get("pageDescription");

        if (pageTitle != null && pageTitle.length() != 0) {

%>
<tr><td>
<h1> <%= globalNLS.get(pageTitle) %> </h1>
</td></tr>
<%
        }
        if (pageDescription != null && pageDescription.length() != 0) {
%>
<tr><td>
<%= globalNLS.get(pageDescription) %>
</td></tr>
<tr><td>
&nbsp;
</td></tr>
<%
        }
    }

    // handle sections
    Vector sections = Util.convertToVector(universalDialog.get("section"));
    if (sections != null) {
        Hashtable section = null;
        String enabled = null;
        String sectionName = null;
        String sectionTitle = null;
        String sectionDescription = null;
        String sectionSeparator = null;

        Vector elements = null;
        Hashtable element = null;
        String elementType = null;
        String elementProperty = null;
        String elementName = null;
        String elementLabel = null;
        String elementPage = null;
        String elementValue = null;
        String elementBean = null;
        String elementSpace = null;
        Vector elementValidators = null;
        String beanPorperty = null;
        String beanMethodName = null;
        String labelStr = null;
        Method beanMethod = null;
        Object beanInstance = null;
        Object result = null;
        int dotIndex = 0;
        HTMLButton button = null;
        HTMLOption option = null;
        Timestamp ts = null;
        boolean samerow = false; // whether new row is needed
        Vector sectionValidators = null; // section level validators

        // for checkbox group only
        String horizontalMaxNumberStr = null;
        int    horizontalMaxNumber = 0;
        int    horizontalCounter = 0;

        for (Enumeration enumList = sections.elements(); enumList.hasMoreElements();)
        {
            section = (Hashtable) enumList.nextElement();
            enabled = (String) section.get("enabled");
            sectionName = (String) section.get("name");
            sectionTitle = (String) section.get("sectionTitle");
            sectionDescription = (String) section.get("sectionDescription");
            sectionSeparator = (String) section.get("separator");
            if ( enabled != null && enabled.equalsIgnoreCase("false") ) {
                continue;
            }

            // if target section is specified in the request (ie. section name specified in request)
            if (!panelMode && targetSection != null && !sectionName.equalsIgnoreCase(targetSection) ) {
                continue;
            }

            ECTrace.trace(ECTraceIdentifiers.COMPONENT_TOOLSFRAMEWORK, "UniversalDialogView", "service", "Process section: " + sectionName);

            // add section level validators
            sectionValidators = Util.convertToVector(section.get("validator"));
            if (sectionValidators != null) {
                validators.put("", sectionValidators);
            }

            if ( !panelMode ) {
                if (sectionTitle != null) {
%>
<tr><td>
<a href="javascript:twistie('<%= sectionName %>')"><h1><%= globalNLS.get(sectionTitle) %></h1></a>
</td></tr>
<tr><td>
<%
                }
            } else if (targetSection != null && !sectionName.equalsIgnoreCase(targetSection)) {
%>
<tr style="display:none"><td>
<%
            } else { // panel mode and this is the targeted section
                if (sectionTitle != null && sectionTitle.length() != 0) {
%>
<tr><td class="h1" height="35">
<%= globalNLS.get(sectionTitle) %>
</td></tr>
<%
                }
                if (sectionDescription != null && sectionDescription.length() != 0) {
%>
<tr><td>
<%= globalNLS.get(sectionDescription) %>
</td></tr>

<%
                }
%>
<tr><td>
<%
            }
%>

<table id="<%= sectionName %>" border="0" cellpadding="10" cellspacing="0" width="100%">

<%
            // handle each element within a section
            elements = Util.convertToVector(section.get("element"));
            for (Enumeration enumList2 = elements.elements(); enumList2.hasMoreElements();)
            {
                element = (Hashtable) enumList2.nextElement();
                elementType = (String) element.get("type");
                elementProperty = (String) element.get("property");
                elementName = (String) element.get("name");
                elementPage = (String) element.get("page");
                elementLabel = (String) element.get("label");
                elementValue = (String) element.get("value");
                elementSpace = (String) element.get("sameRowSpace");
                if (elementType == null || elementName == null) {
                    continue;
                } else {
                    elementType = elementType.toLowerCase();
                }

                if (elementProperty == null) {
                    elementProperty = "";
                }

                elementValidators = Util.convertToVector(element.get("validator"));
                if (elementValidators != null) {
                    validators.put(elementName + "." + elementType, elementValidators);
                }

                if (!samerow && !elementType.equals("hidden") ) { // start a new row
                    String tableWidth = "";
                    if (elementType.equals("custom")) {
                        tableWidth = "width=100%";
					}
%>
                    <tr><td>
                    <table id="row_<%= elementName %>" border="0" cellpadding="0" cellspacing="0" <%= tableWidth %>>
                    <tr>
<%
                }

                result = null;

                if (elementValue != null) {
                    // "value" should be of format "beanId.property"
                    dotIndex = elementValue.indexOf(".");
                    if (dotIndex <= 0) {
                        continue;
                    }
                    try {
                        elementBean = elementValue.substring(0, dotIndex);
                        beanPorperty = elementValue.substring(dotIndex+1);
                        beanInstance = request.getAttribute(elementBean);
                        beanMethodName = Character.toUpperCase(beanPorperty.charAt(0)) + beanPorperty.substring(1); // uppercase the first letter of the bean property
                        if (elementType.equals("checkbox")) {
                            beanMethodName = "is" + beanMethodName;
                        } else {
                            beanMethodName = "get" + beanMethodName;
                        }
                        beanMethod = beanInstance.getClass().getMethod(beanMethodName, null);
                        result = beanMethod.invoke(beanInstance, null);
                    } catch (Exception e) {
                        System.out.println("UD - Failed to invoke bean method: " + beanMethodName + " from " + elementBean);
                    }
                }

                ECTrace.trace(ECTraceIdentifiers.COMPONENT_TOOLSFRAMEWORK, "UniversalDialogView", "service", "Process element: " + elementName + " - " + elementType + " - " + beanMethod + " - " + result);

                if (elementLabel != null) {
					if (elementType.equals("summarytext")) {
	                    labelStr = "<label for=\"" + elementName + "\">" + globalNLS.get(elementLabel) + "</label>";
					}
					else {
	                    labelStr = "<label for=\"" + elementName + "\">" + globalNLS.get(elementLabel) + "</label> <br>";
					}
                } else {
                    labelStr = "";
                }

                if (elementType.equals("hidden")) {
                    if (result == null) {
                        result = "";
                    } else {
                        result = UIUtil.toHTML(result.toString());
                    }
%>
                    <input type="hidden" id="<%=elementName%>" name="<%=elementName%>" value="<%=result%>" <%=elementProperty%> >
<%
                } else if (elementType.equals("label")) {
                    if (result == null) {
                        result = "";
                    }
%>
                    <td class="ud" valign="top"><%=globalNLS.get(elementName)%><%= result==null ? "":result %></td>
<%
                } else if (elementType.equals("summarytext")) {
                    if (result == null) {
                        result = "";
                    } else {
                        result = UIUtil.toHTML(result.toString());
                    }
%>
                    <td class="ud" valign="top"><%= labelStr %>&nbsp;<i><span id="<%= elementName %>"><%= result %></span></i></td>
<%
                } else if (elementType.equals("text")) {
                    if (result == null) {
                        result = "";
                    } else {
                        result = UIUtil.toHTML(result.toString());
                    }
%>
                    <td class="ud" valign="top"><%= labelStr %>
                    <input type="text" id="<%=elementName%>" name="<%=elementName%>" value="<%=result%>" <%=elementProperty%> >
                    </td>
<%
                } else if (elementType.equals("textarea")) {
                    if (result == null) {
                        result = "";
                    }
%>
                    <td class="ud" valign="top"><%= labelStr %>
                    <textarea id="<%=elementName%>" name="<%=elementName%>" <%=elementProperty%> ><%=result%></textarea>
                    </td>
<%
                } else if (elementType.equals("button")) {
%>
                    <td class="ud" valign="top">
                    <input type="button" class="button" id="<%=elementName%>" name="<%=elementName%>" value="<%=globalNLS.getJSProperty(elementLabel, "")%>" <%=elementProperty%> >
                    </td>
<%
                } else if (elementType.equals("buttongroup")) {
%>
                    <td class="ud" valign="top">
                    <br/>
                    <table border="0" cellpadding="0" cellspacing="0">
<%
                    for (Iterator iterator = ((Collection) result).iterator(); iterator.hasNext(); ) {
                        button = (HTMLButton) iterator.next();
%>
                    <tr><td>
                    <input type="button" class="button" id="<%= button.getButtonName() %>" name="<%= button.getButtonName() %>" value="<%= button.getTextRBKey() ? globalNLS.get(button.getText()) : button.getText() %>" onclick="<%= button.getClickAction() %>">
                    </td></tr>
                    <tr><td height="4px"></td></tr>
<%
                    }
%>
					</table>
                    </td>
<%
                } else if (elementType.equals("checkbox")) {
                    if (result == null) {
                        result = new Boolean(false);
                    }
%>
                    <td class="ud" valign="top">
                    <input type="checkbox" id="<%=elementName%>" name="<%=elementName%>" <%=elementProperty%> <%=((Boolean)result).booleanValue()?"checked":""%>><%= labelStr %>
                    </td>
<%
                } else if (elementType.equals("checkboxgroup") && result != null) {
                    if (result == null) {
                        result = new Vector();
                    }

                    horizontalCounter = 0;
                    horizontalMaxNumberStr = (String) element.get("horizontalMaxNumber");
                    if (horizontalMaxNumberStr != null) {
                        horizontalMaxNumber = Integer.parseInt(horizontalMaxNumberStr);
                    } else {
                        horizontalMaxNumber = 0;
                    }
%>
                    <td class="ud" valign="top"><%= labelStr %>
<%
                    for (Iterator iterator = ((Collection) result).iterator(); iterator.hasNext(); ) {
                        option = (HTMLOption) iterator.next();
%>
                    <label><input type="checkbox" id="<%=option.getValue()%>" name="<%=option.getValue()%>" <%=option.isSelected()?"checked":""%>><%= option.isTextRBKey() ? globalNLS.get(option.getText()) : option.getText() %></label>
<%
                        if (horizontalMaxNumber == 0) {  // vertical layout
                            out.println("                    <br>");
                        } else {    // horizontal layout
                            out.println("&nbsp;&nbsp;");
                            if (++horizontalCounter >= horizontalMaxNumber) {
                                horizontalCounter = 0;
                                out.println("                    <br>");
                            }
                        }
                    }
%>
                    </td>
<%
                } else if (elementType.equals("radio") && result != null) {
                    if (result == null) {
                        result = new Vector();
                    }
%>
                    <td class="ud" valign="top"><%= labelStr %>
<%
                    for (Iterator iterator = ((Collection) result).iterator(); iterator.hasNext(); ) {
                        option = (HTMLOption) iterator.next();
%>
					<label>
                    <input type="radio" id="<%=elementName%>" name="<%=elementName%>" value="<%=UIUtil.toHTML(option.getValue())%>" <%=option.isSelected()?"checked":"" %> >
                    <%= option.isTextRBKey() ? globalNLS.get(option.getText()) : option.getText() %>
                    </label><br>
<%
                    }
%>
                    </td>
<%
                } else if (elementType.equals("password")) {
                    if (result == null) {
                        result = "";
                    } else {
                        result = UIUtil.toHTML(result.toString());
                    }
%>
                    <td class="ud" valign="top"><%= labelStr %>
                    <input type="password" autocomplete="off" id="<%=elementName%>" name="<%=elementName%>" value="<%=result%>" <%=elementProperty%> >
                    </td>
<%
                } else if (elementType.equals("select")) {
                    if (result == null) {
                        result = new Vector();
                    }
%>
                    <td class="ud" valign="top"><%= labelStr %>
                    <select id="<%=elementName%>" name="<%=elementName%>" <%=elementProperty%> >
<%
                    for (Iterator iterator = ((Collection) result).iterator(); iterator.hasNext(); ) {
                        option = (HTMLOption) iterator.next();
%>
                    <option value="<%=UIUtil.toHTML(option.getValue())%>" <%=option.isSelected()?"selected":""%> >
                    <%= option.isTextRBKey() ? globalNLS.get(option.getText()) : option.getText() %>
<%
                    }
%>
                    </select>
                    </td>
<%
                } else if (elementType.equals("date")) {
                    includeCalendar = true;
                    if (result == null) {
                        ts = new Timestamp(System.currentTimeMillis());
                    } else {
                        ts = (Timestamp) result;
                    }
%>
                    <td class="ud" valign="top">
                    <table border=0 cellspacing=0 cellpadding=0>
                          <tr>
                            <td></td>
                            <td><label for="<%=elementName%>_year"><%= calendarNLS.get("year") %></label></td>
                            <td>&nbsp;</td>
                            <td><label for="<%=elementName%>_month"><%= calendarNLS.get("month") %></label></td>
                            <td>&nbsp;</td>
                            <td><label for="<%=elementName%>_day"><%= calendarNLS.get("day") %></label></td>
                            <td>&nbsp;</td>
                          </tr>
                          <tr>
                            <td><%= labelStr %>&nbsp;</td>
                            <td><input type=text value="<%=ts.getYear()+1900%>" name="<%=elementName%>_year" id="<%=elementName%>_year" size="4" maxlength="4"></td>
                            <td></td>
                            <td><input type=text value="<%=ts.getMonth()+1%>" name="<%=elementName%>_month" id="<%=elementName%>_month" size="2" maxlength="2"></td>
                            <td></td>
                            <td><input type=text value="<%=ts.getDate()%>" name="<%=elementName%>_day" id="<%=elementName%>_day" size="2" maxlength="2"></td>
                            <td></td>    <td><a href="javascript:window.dayField=document.<%=formName%>.<%=elementName%>_day;window.monthField=document.<%=formName%>.<%=elementName%>_month;window.yearField=document.<%=formName%>.<%=elementName%>_year;showCalendar(document.all.<%=elementName%>_img)">
                            <img alt="<%= calendarNLS.get("calendarTitle") %>" id="<%=elementName%>_img" src="/wcs/images/tools/calendar/calendar.gif" border="0"></a></td>
                          </tr>
                    </table>
                    </td>
<%
                } else if (elementType.equals("datetime")) {
                    includeCalendar = true;
                    if (result == null) {
                        ts = new Timestamp(System.currentTimeMillis());
                    } else {
                        ts = (Timestamp) result;
                    }
%>
<script>
function <%= elementName %>_onchange () {
	if (document.<%= formName %>.<%= elementName %>_year.value != "" &&
		document.<%= formName %>.<%= elementName %>_month.value != "" &&
		document.<%= formName %>.<%= elementName %>_day.value != "" &&
		document.<%= formName %>.<%= elementName %>_time.value == "") {
		document.<%= formName %>.<%= elementName %>_time.value = "<%= ts.getHours() %>:<%= ts.getMinutes() %>";
	}
}
</script>
                    <td class="ud" valign="top">
                    <table border=0 cellspacing=0 cellpadding=0>
                          <tr>
                            <td></td>
                            <td><label for="<%=elementName%>_year"><%= calendarNLS.get("year") %></label></td>
                            <td>&nbsp;</td>
                            <td><label for="<%=elementName%>_month"><%= calendarNLS.get("month") %></label></td>
                            <td>&nbsp;</td>
                            <td><label for="<%=elementName%>_day"><%= calendarNLS.get("day") %></label></td>
                            <td>&nbsp;</td>
                            <td>&nbsp;</td>
                            <td>&nbsp;</td>
                            <td><label for="<%=elementName%>_time"><%= calendarNLS.get("time") %></label></td>
                          </tr>
                          <tr>
                            <td><%= labelStr %>&nbsp;</td>
                            <td><input type=text value="<%=ts.getYear()+1900%>" name="<%=elementName%>_year" id="<%=elementName%>_year" size="4" maxlength="4" onpropertychange="<%= elementName %>_onchange();"></td>
                            <td></td>
                            <td><input type=text value="<%=ts.getMonth()+1%>" name="<%=elementName%>_month" id="<%=elementName%>_month" size="2" maxlength="2" onpropertychange="<%= elementName %>_onchange();"></td>
                            <td></td>
                            <td><input type=text value="<%=ts.getDate()%>" name="<%=elementName%>_day" id="<%=elementName%>_day" size="2" maxlength="2" onpropertychange="<%= elementName %>_onchange();"></td>
                            <td></td>
                            <td><a href="javascript:window.dayField=document.<%=formName%>.<%=elementName%>_day;window.monthField=document.<%=formName%>.<%=elementName%>_month;window.yearField=document.<%=formName%>.<%=elementName%>_year;showCalendar(document.all.<%=elementName%>_img)">
                            <img alt="<%= calendarNLS.get("calendarTitle") %>" id="<%=elementName%>_img" src="/wcs/images/tools/calendar/calendar.gif" border="0"></a></td>
                            <td></td>
                            <td><input type=text value="<%=ts.getHours()%>:<%=ts.getMinutes()%>" name="<%=elementName%>_time" id="<%=elementName%>_time" size="5" maxlength="5"></td>
                          </tr>
                    </table>
                    </td>
<%
                } else if (elementType.equals("custom")) {
                    if (elementPage != null) {
%>
                    <td class="ud" valign="top"><%= labelStr %>
                    <jsp:include page="<%= elementPage %>" />
                    </td>
<%
                    }
                } else {    // unknown type
%>
                    <td class="ud" valign="top"><%=globalNLS.get(elementName)%></td>
<%
                }

                if ( elementSpace != null) {
%>
                    <td width="<%=elementSpace%>">&nbsp;</td>
<%
                    samerow = true;
                } else if (!elementType.equals("hidden")) {
%>
                    </tr></table>
                    </td></tr>
<%                  samerow = false;
                }
            }

            if ( elementSpace != null) { // in case the last element didn't close itself
%>
                    </tr></table>
                    </td></tr>
<%
            }
%>

</table>
</td></tr>
<%
            if (sectionSeparator != null && sectionSeparator.equalsIgnoreCase("true")) {
%>
<tr><td>
<hr class="sectionSeparator" align="left" />
</td></tr>
<%
            }
        }
    }
    // end of sections
%>

</form>


</table>

<script>


// body onload function, display success/error message if they're returned from controller command
// users can define custom finishHandler() and errorHandler() to implement their own error handling logic.
// default implementation is to alert message, and in the case of success, go back to previous item in BCT
function _init()
{
<%
    if (panelMode) {
%>
    parent.setContentFrameLoaded(true);
<%
    }
%>

    // restore form data (if this is a re-visit of the page)
    _loadFormData();

<%
    if (finishMsg != null) {
%>
    if (this.finishHandler)
        finishHandler("<%=UIUtil.toJavaScript(finishMsg)%>");
    else {
        _alert("<%=UIUtil.toJavaScript(finishMsg)%>");
        if (top.goBack)
            top.goBack();
    }
<%
    } else if (errorMsg != null) {
%>
    if (this.errorHandler)
        errorHandler("<%=UIUtil.toJavaScript(errorMsg)%>", "<%=jspHelper.getParameter(UIProperties.SUBMIT_ERROR_STATUS)%>");
    else
        _alert("<%=UIUtil.toJavaScript(errorMsg)%>");
<%
    }
%>

    // optional custom init() function to be defined by page developers (in either included JS file or JSP segment file)
    if (this.init) {
        init();
    }

    // save form data
    _saveFormData();

}


// this function checks all validators and return an array of validation errors
function getValidationErrors()
{
    var errors = new Array();

<%
    // validators
    String validatorKey = null;
    StringTokenizer tokens = null;
    String elementName = null;
    String elementType = null;
    Vector validatorList = null;
    Hashtable validator = null;
    String errorCode = null;
    String errorMessage = null;
    Vector parameters = null;
    Hashtable parameter = null;

    // add global validators
    Vector globalValidators = Util.convertToVector(universalDialog.get("validator"));
    if (globalValidators != null) {
        validators.put("", globalValidators);
    }

    if (!validators.isEmpty()) {
        for (Iterator iterator = validators.keySet().iterator(); iterator.hasNext(); ) {
            validatorKey = (String) iterator.next();    // the key is in the format of <element name>.<element type>
            tokens = new StringTokenizer(validatorKey, ".");
            if (tokens.countTokens() == 2) {
                elementName = tokens.nextToken();
                elementType = tokens.nextToken();
            }

            validatorList = (Vector) validators.get(validatorKey);

            for (Enumeration enumList = validatorList.elements(); enumList.hasMoreElements();) {
                validator = (Hashtable) enumList.nextElement();
                if (validatorKey.length() == 0 || elementType.equals("custom")) { // global or custom validator
                    out.print("    if (this." + validator.get("name") + " && !" + validator.get("name") + "(");
                } else if (elementType.equals("date")) { // date type
                    out.print("    if (this." + validator.get("name") + " && !" + validator.get("name") + "(getData(\"" + elementName + "_year\"), getData(\"" + elementName + "_month\"), getData(\"" + elementName + "_day\")");
                } else if (elementType.equals("datetime")) { // datetime type
                    out.print("    if (this." + validator.get("name") + " && !" + validator.get("name") + "(getData(\"" + elementName + "_year\"), getData(\"" + elementName + "_month\"), getData(\"" + elementName + "_day\"), getData(\"" + elementName + "_time\")");
                } else { // all other types
                    out.print("    if (this." + validator.get("name") + " && !" + validator.get("name") + "(getData(\"" + elementName + "\")");
                }
                errorCode = (String) validator.get("errorCode");
                errorMessage = (String) validator.get("errorMsg");
                parameters = Util.convertToVector(validator.get("parameter"));
                if (parameters != null) {
                    for (Enumeration enumList2 = parameters.elements(); enumList2.hasMoreElements();) {
                        parameter = (Hashtable) enumList2.nextElement();
                        out.print(","+parameter.get("value"));
                    }
                }
                out.println(")) ");
                out.println("        errors[errors.length] = new validationError(\"" + elementName + "\", \"" + errorCode + "\", \"" + globalNLS.getJSProperty(errorMessage) + "\"); \n\n");
            }
        }
    }

%>

    return errors;
}
</script>

<%
    if (includeCalendar) {
%>
<script for=document event="onclick()">
    document.all.CalFrame.style.display="none";
</script>

<script>
document.writeln('<iframe id="CalFrame" title="' + top.calendarTitle + '" marginheight="0" marginwidth="0" noresize frameborder="0" scrolling="no" src="/webapp/wcs/tools/servlet/Calendar" style="display: none; position:absolute; width:198; height:230; z-index=100;"></iframe>');
</script>
<%
    }
%>


</body>
</html>
