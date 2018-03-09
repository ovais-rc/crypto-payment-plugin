<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN">

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2002, 2014 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<%@include file="../../common/common.jsp" %>
	
<%-- -------------------------------------------------------------------------
	Tools Framework Dynamic List Java code
--------------------------------------------------------------------------- --%>
<%@page import="com.ibm.commerce.tools.util.UIUtil" %>
<%@page import="com.ibm.commerce.tools.common.ui.taglibs.*" %>

<%@page import="com.ibm.commerce.command.CommandContext" %>
<%@page import="com.ibm.commerce.server.ECConstants" %>
<%@page import="com.ibm.commerce.tools.util.ResourceDirectory" %>
<%@page import="com.ibm.commerce.tools.resourcebundle.ResourceBundleProperties" %>
<%@page import="com.ibm.commerce.tools.devtools.databeans.SAROwnerBean" %>
<%@page import="com.ibm.commerce.tools.devtools.publish.refs.StoreParamInputType" %>
<%@page import="com.ibm.commerce.tools.devtools.publish.refs.ExternalRef" %>
<%@page import="com.ibm.commerce.tools.devtools.publish.refs.ExternalRefListType" %>
<%@page import="java.util.Locale" %>

<%
	CommandContext commandContext = (CommandContext)request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
	Locale locale = commandContext.getLocale();
	ResourceBundleProperties serviceNLS = (ResourceBundleProperties)ResourceDirectory.lookup("publish.storePublishNLS", locale);		
%>

<html lang="<%= locale.getLanguage()%>">

<jsp:useBean class="com.ibm.commerce.tools.devtools.publish.databeans.StorePublishParametersDataBean" id="paramsBean">
<jsp:setProperty name="paramsBean" property="storeArchiveFilename" param="sar"/>
	<%
	try{
		com.ibm.commerce.beans.DataBeanManager.activate(paramsBean, request);
	}catch (Exception e) {
		%>
		<script>
		alertDialog("<%= (String)serviceNLS.getJSProperty("_ERR_LOADING_PARAMS")%>");
		</script>
		<%
	}
	%>
</jsp:useBean>
<head>
	<link rel="stylesheet" href="<%= UIUtil.getCSSFile(locale) %>" type="text/css">
	<script src="/wcadmin/javascript/tools/common/dynamiclist.js"></script>
	<script src="/wcadmin/javascript/tools/common/Util.js"></script>
	<script src="/wcadmin/javascript/tools/devtools/publish/StorePublishWizard.js"></script>	


<script>


function storeVal(memberId, memberDN, directory, identifier, type, id){
	this.memberId = memberId;
	this.memberDN = memberDN;
	this.directory = directory;
	this.identifier = identifier;
	this.type = type;
	this.id = id;
}

	
function initFields(){
	var selectIdList1 = <%= new Vector(paramsBean.getSelectIdGroupList()) %>;
	tempactiveId = parent.get("activeId");
		for(var sel=0; sel<selectIdList1.length; sel++){
		if(tempactiveId == selectIdList1[sel].id){
			activeId = tempactiveId;
		}
		var paramLength = document["param" + selectIdList1[sel].id].length;
		var fieldValue;
		for (var i=0; i < paramLength; i++){
			fieldValue = parent.get(document["param" + selectIdList1[sel].id][i].name);
			if ((fieldValue != null) && (fieldValue != 'undefined')){
				document["param" + selectIdList1[sel].id][i].value = fieldValue;
			}
				//alert(document["param" + selectIdList1[sel].id][i].name + ": " + document["param" + selectIdList1[sel].id][i].value);
		}
	}
	if(activeId == null){
		activeId = selectIdList1[0].id;
	}
	document.getElementById(activeId).style.display = "block";
	if(document.getElementById("select_"+activeId) != null){
		document.getElementById("select_"+activeId).checked = "checked";
	}
	parent.remove("elTagValid");
}
	function initializeState()
	{
		// pre-fill fields
		initFields();		
		parent.setContentFrameLoaded(true);
	}
	
	function setFieldValues(selectElem, theStoreValues, fields, selId)
	{
		var selStoreId = selectElem.options[selectElem.selectedIndex].value;
		for (var j in fields){
			document["param" + selId.id][fields[j].entity].value = theStoreValues[selStoreId][fields[j].property];
		}
	}

	function isValidStoreId(myString) 
	{
		var invalidChars = "~!@#$%^&*()+=[]{};:,<>?/|`."; // invalid characters
		invalidChars += "\t\'\"\\"; // escape sequences
	   
		// look for presence of invalid characters.  if one is
		// found return false.  otherwise return true
		for (var i=0; i<myString.length; i++) {
		  if (invalidChars.indexOf(myString.substring(i, i+1)) >= 0) {
			return false;
		  }
		}
		return true;
	}

</script>
<% 
	boolean elTagValid=false;
	SAROwnerBean ownerBean = new SAROwnerBean();
	ownerBean.setCommandContext(commandContext);
%>
<META name="GENERATOR" content="IBM WebSphere Studio">
</head>
<BODY ONLOAD="initializeState();" class=content>

<H1><%= serviceNLS.getProperty("StorePublishParamTitle") %></H1><BR>
<%= serviceNLS.getProperty("param.storeArchive") %>&nbsp;
<SCRIPT>


	function savePanelData()
	{
	
		var paramInfoArray = new Array();
		var hiddenParamArray = new Array();
		var count = 0;
		var paramCount = 0;

		var parameterValue = "";

			var paramLength = document["param" + activeId].length;
			if(activeId != null){
				parent.put("activeId",activeId);
			}
			// construct an array of paramInfo objects that can
			// be used to displayed the parameters and values in the following page
			var paramDisplayKeys = "paramDisplayKeys" + activeId;
			for (var i=0; i < paramLength; i++){
				parent.put(document["param" + activeId][i].name, document["param" + activeId][i].value);
				if ((document["param" +activeId][i].DISPLAY == null) || (document["param" +activeId][i].DISPLAY != 'no')){
					if (document["param" +activeId][i].type == 'select-one' && document["param" +activeId][i].selectedIndex >= 0){
						parameterValue = document["param" +activeId][i].options[document["param" +activeId][i].selectedIndex].text;
					} else {
						parameterValue = document["param" +activeId][i].value;
					}
					paramInfoArray[count] = new paramInfo(document["param" +activeId][i].name, parameterValue, eval(paramDisplayKeys)[document["param" +activeId][i].name]);
					//alert(paramInfoArray[count].name + "," + paramInfoArray[count].value + "," + eval(paramDisplayKeys)[document["param" +activeId][i].name]);
					count ++;
				}
				else{
					hiddenParamArray[paramCount]=document["param" +activeId][i].name; 
					paramCount ++;
				}
			}
	parent.put("paramInfos", paramInfoArray);
	parent.put("hiddenParams", hiddenParamArray);

	// pass the number of external refs to the next JSP
	// so it can build the display

	// get the next URL
	var nextURL = parent.pageArray['StorePublishWizardOptions'].url;
	//alertDialog("before: " + nextURL);
	var changedURL = null;
	if (nextURL != null) {
		changedURL = addReplaceParam(nextURL, "paramLength", count); 
	}
	//alertDialog("after: "+ changedURL);
	parent.pageArray['StorePublishWizardOptions'].url = changedURL;
	parent.put("elTagValid",elTag);
	}
	

function addReplaceParam(theURL, paramName, paramValue){
	// create regular expression (need to find out what is valid URL)
	re = new RegExp(("(.+)(" + paramName + "=)(.+)(&?.*)"));
	pos = theURL.search(re);
	// alertDialog(pos);
	if (pos == -1){
		// the paramName does not exist, so add
		// DEFECT: putting ? assumes that there are no other parameters
		// check if there is already a parameter
		re2 = new RegExp("(.+)\?(.+)=(.+)");
		pos2 = theURL.search(re2);
		if (pos2 == -1) {
			//alertDialog("adding the first parameter");
			return (theURL + "?" + paramName + "=" + paramValue);
		} else {
			//alertDialog("adding another parameter");
			return (theURL + "&" + paramName + "=" + paramValue);
		}
		
	} else {
		// the paramName does exist, so replace
		return (theURL.replace(re, ("$1$2" + paramValue + "$4")));
	}
}

	
	function validateInput(object)
	{
				if(object == null)
					return true;
				var str = object.value;
				var title = object.title;
				if (!isValidUTF8length(str , 50))
				alertDialog("<%= (String) serviceNLS.getJSProperty("alertmaxlength")%>");
				else if (str == "")
				{	
					var emptymsg = "<%= (String)serviceNLS.getJSProperty("alertRequiredParamValueEmpty")%>";
					emptymsg = emptymsg.replace(/%1/,title);
					alertDialog(emptymsg);
				}
				else if (!isValidStoreId(str))
				{	
					var invalidCharmsg = "<%= (String)serviceNLS.getJSProperty("alertRequiredParamInvalidChar")%>";
					invalidCharmsg = invalidCharmsg.replace(/%1/,title);
					alertDialog(invalidCharmsg);
				}

				else
				return true;
				
				object.focus();
				return false;
	}

	function validateStoreIdentifier()
	{
		str = trim(document["param" + activeId].storeId.value);
		document["param" + activeId].storeId.value = str;
		
	        if (!isValidUTF8length(str , 50))
		        alertDialog("<%= (String) serviceNLS.getJSProperty("alertmaxlength")%>");
        	else if (str == "")
			alertDialog("<%= (String)serviceNLS.getJSProperty("alertRequiredParamEmpty")%>");
		else
			return true;

		document["param" + activeId].storeId.focus();
		return false;

	}
	
	function validateStoreDirectory()
	{
		str = trim(document["param" + activeId].storeDir.value);
		document["param" + activeId].storeDir.value = str;

	        if (!isValidUTF8length(str , 50))
	        	alertDialog("<%= (String) serviceNLS.getJSProperty("alertmaxlength")%>");
        	else if (str == "")
			alertDialog("<%= (String)serviceNLS.getJSProperty("alertDirectoryEmpty")%>");
		else
			return true;

		document["param" + activeId].storeDir.focus();
		return false;
	}



	var sarName= parent.get("storeArchiveFilename");
	document.writeln(sarName);
</SCRIPT>

<jsp:useBean class="com.ibm.commerce.tools.devtools.publish.databeans.StorePublishELTagValidationDataBean" id="elTagBean">
<jsp:setProperty name="elTagBean" property="storeArchiveFilename" param="sar"/>
	<%
	try{
		com.ibm.commerce.beans.DataBeanManager.activate(elTagBean, request);
		elTagValid=elTagBean.getSarJSTLUnCompatible();
	%>
		<script>
			parent.remove("elTagValid");
			var elTag = "<%=elTagValid%>";
		</script>
	<%}catch (Exception e1) {
		%>
		<script>
		alertDialog("<%= (String)serviceNLS.getJSProperty("_ERR_LOADING_PARAMS")%>");
		</script>
		<%
	}
	%>
</jsp:useBean>
<div>
<br/>
<% Vector selectIdList2 = new Vector(paramsBean.getSelectIdGroupList()); 
if(selectIdList2.size()>1){
%>
<fieldset id="rgStoreType">
<legend><%= serviceNLS.getProperty("StorePublishSelectBusinessModel") %></legend>
<%
for(int sel=0; sel<selectIdList2.size(); sel++){
if(paramsBean.getLength() == 0){
%>
<input type=radio name="paramGroup" id="select_<%=selectIdList2.elementAt(sel)%>" value="<%=selectIdList2.elementAt(sel)%>" onclick="javascript:activateSection(this.value);"><%=paramsBean.getSelectDescription((String)selectIdList2.elementAt(sel))%></input>
<br/>
<%
}
}
%>
 </fieldset>
<% } // end if selectId.size()>0 %>
</div>
<script>
var activeId = null;
function activateSection(id){
	document.getElementById(id).style.display = "block";
	if(activeId != null){
		document.getElementById(activeId).style.display = "none";
	}
	activeId = id;
}
<%
Vector selectIdList = new Vector(paramsBean.getSelectIdGroupList());
for(int sel=0; sel<selectIdList.size(); sel++){
	Vector paramList = new Vector(paramsBean.getSelectList((String)selectIdList.elementAt(sel)));
%>
var paramDisplayKeys<%=selectIdList.elementAt(sel)%> = new Array(<%=paramList.size()%>);
<%
}
%>
//var paramDisplayKeys = new Array(<%=paramsBean.getLength()%>);
function validatePanelData()
	{
			<% 
			ExternalRef curRefObj = null;  
			for (int j=0; j< paramsBean.getLength(); j++)
			{
				curRefObj = paramsBean.getStoreParamListElementAt(j);
				if(curRefObj.getInputType() == StoreParamInputType.TEXT)
				{
			%>
				if(!validateInput(document["param" + activeId].<%=curRefObj.getEntityName()%>))
				return false;
			<%  }
				if(curRefObj.getInputType() == StoreParamInputType.MEMBER)
				{
			 %>
				if(document["param" + activeId].<%=curRefObj.getEntityName()%>.selectedIndex < 0){
					var emptymsg = "<%= (String)serviceNLS.getJSProperty("alertRequiredParamValueEmpty")%>";
					emptymsg = emptymsg.replace(/%1/,"<%= paramsBean.getEntityDisplayName(curRefObj) %>");
					alertDialog(emptymsg);
					return false;
				 }
			 <% }
			 }
			%>
	return true;
	}
</script>

<%
selectIdList = new Vector(paramsBean.getSelectIdGroupList());
for(int sel=0; sel<selectIdList.size(); sel++){
	Vector paramList = new Vector(paramsBean.getSelectList((String)selectIdList.elementAt(sel)));
	String formName = "param" + (String)selectIdList.elementAt(sel);
%>
<form name="param<%=selectIdList.elementAt(sel)%>">
<div id = "<%=selectIdList.elementAt(sel)%>" style="display:none;">
<%
if (paramList.size() == 0) {
%>
<%= serviceNLS.getProperty("paramInstr3") %> <BR>
<% } else { %>
<%= serviceNLS.getProperty("paramInstr1") %> <BR>
<%= serviceNLS.getProperty("paramInstr2") %> <BR><BR>
<table class="list" width="90%" cellpadding="4">

<TR class="list_roles">

<TH class="list_header" id="col<%=sel%>_1">
<nobr>&nbsp;&nbsp;&nbsp;<%= serviceNLS.getProperty("param.param") %>&nbsp;&nbsp;&nbsp;</nobr>
</TH>

<TH width="20%" class="list_header" id="col<%=sel%>_2">
<nobr>&nbsp;&nbsp;&nbsp;<%= serviceNLS.getProperty("param.value") %>&nbsp;&nbsp;&nbsp;</nobr>
</TH>
<TH width="65%" class="list_header" id="col<%=sel%>_3">
<nobr>&nbsp;&nbsp;&nbsp;<%= serviceNLS.getProperty("archive.Desc") %>&nbsp;&nbsp;&nbsp;</nobr>
</TH>

</TR>

<% 
// Dynamic generation of the parameter input fields
int rowSelect = 1;
ExternalRef curRef = null;  
String curDisplayKey = "";
String curRefDesc = "";
boolean storeValuesPopulated = false;
for (int i=0; i< paramList.size(); i++)
{
	curRef = (ExternalRef)paramList.elementAt(i);
	// XXX: review this
	if (curRef.getInputType() == StoreParamInputType.HIDDEN){
	%>
<INPUT TYPE="HIDDEN" NAME="<%=curRef.getEntityName()%>" VALUE="<%=curRef.getEntityValue()%>" DISPLAY="no" >	
	<%
		continue;
	}
	rowSelect = (rowSelect == 1) ? (rowSelect = 2) : (rowSelect = 1);
	curDisplayKey =  paramsBean.getEntityDisplayName(curRef);
	curRefDesc = paramsBean.getEntityDescription(curRef);
	
%>
<TR class=list_row<%=rowSelect%>>
<TD class="list_info1" align="left" id="row<%=sel%>_<%=i%>_1" headers="col<%=sel%>_1" >

<nobr>&nbsp;<label for="storeParam<%=sel%>_<%=i%>"><%= curDisplayKey %></label>&nbsp;</nobr>
<script>
	paramDisplayKeys<%=selectIdList.elementAt(sel)%>["<%=curRef.getEntityName()%>"] = "<%= curDisplayKey %>";
</script>
</TD>
<TD class="list_info1" align="left" headers="col<%=sel%>_2" id="row<%=sel%>_<%=i%>_2">
<%
	if (curRef.getInputType() == StoreParamInputType.TEXT) 
	{
%>
<INPUT NAME="<%=curRef.getEntityName()%>" VALUE="<%=curRef.getEntityValue()%>" SIZE="35" id="storeParam<%=sel%>_<%=i%>" TITLE="<%= curDisplayKey %>" onchange="javascript:validateInput(this);">
<%  }    
	else if (curRef.getInputType() == StoreParamInputType.READONLY)
	{
%>
<nobr>&nbsp;<%= curRef.getEntityValue()%>&nbsp;</nobr>
<INPUT TYPE="HIDDEN" NAME="<%=curRef.getEntityName()%>" VALUE="<%=curRef.getEntityValue()%>" >
<%  }
	else if (curRef.getInputType() == StoreParamInputType.MEMBER)
	{
		String taskName;
		ExternalRefListType memberRef = (ExternalRefListType) curRef;
		taskName = "ManageO";		// default
		if (memberRef.size() > 0){	// check for a mode option
			String option = memberRef.elementAt(0).getDisplayKey();
			if (option.equals("mode")){
				String mode = memberRef.elementAt(0).getValueKey();
				if (mode.equalsIgnoreCase("ou")){
					taskName = "ManageOU";
				} else if (mode.equalsIgnoreCase("all")){
					taskName = "ManageExcludingAD";
				} 
			}
		}
%> 

 <jsp:include page="../../buyerconsole/BuyCommonOrgSelection.jsp">
	<jsp:param name="memberName" value="<%=curRef.getEntityName()%>"/>
	<jsp:param name="defaultValue" value="<%=curRef.getEntityValue()%>"/>
	<jsp:param name="taskName" value="<%=taskName%>"/>
	<jsp:param name="formName" value="<%=formName%>"/>
 </jsp:include>

<%  }
	else if (curRef.getInputType() == StoreParamInputType.LIST) {
		ExternalRefListType listRef = (ExternalRefListType) curRef;
%>
<SELECT name="<%=listRef.getEntityName()%>" size="1" id="storeParam<%=sel%>_<%=i%>" TITLE="<%= curDisplayKey %>" aria-label="<%= curDisplayKey %>">
<%
		
		java.util.Properties props = paramsBean.getProperties();
		String displayKey = "";
		String displayText = "";
		String selstr = "";
		for (int k=0; k < listRef.size(); k++){
			displayKey = listRef.elementAt(k).getDisplayKey();
			displayText = props.getProperty(displayKey, displayKey);
			if (listRef.getEntityValue().equals(listRef.elementAt(k).getValueKey())){
				selstr = "selected=\"selected\"";
			} else {
				selstr = "";
			}
%>
		<OPTION value="<%=listRef.elementAt(k).getValueKey()%>" <%=selstr%>><%=displayText%></OPTION>
<%		} %>
</SELECT>
<%
	} else if (curRef.getInputType() == StoreParamInputType.STORE) {
			ownerBean.setStoreTypes(curRef.getStoreTypes());
			ownerBean.populateStoreValues();
%>
<script>
<% 		
			ExternalRefListType listRefTemp = (ExternalRefListType) curRef;
			ownerBean.printStoreValues(listRefTemp.getEntityName()+"_StoreValues", out); %>
</script>
<%
		ExternalRefListType listRef = (ExternalRefListType) curRef;
%>
<SELECT name="<%=listRef.getEntityName()%>" size="1" TITLE="<%= curDisplayKey %>" aria-label="<%= curDisplayKey %>" id="storeParam<%=sel%>_<%=i%>" onchange="javascript:setFieldValues(this, <%=listRef.getEntityName()%>_StoreValues, <%=listRef.getEntityName()%>_fields, <%= (String)selectIdList.elementAt(sel) %> )">		
<% 		ownerBean.printStoreSelection(out, listRef.getEntityValue()); %>
</SELECT>
<script>
	var <%=listRef.getEntityName()%>_fields = new Array(<%=listRef.size()%>);
<% 	for	(int k=0; k < listRef.size(); k++){
%>
	<%=listRef.getEntityName()%>_fields[<%=k%>] = {entity:"<%=listRef.elementAt(k).getValueKey()%>", property:"<%=listRef.elementAt(k).getDisplayKey()%>"} ;
<% 	} %>	
</script>
<%		for (int k=0; k < listRef.size(); k++){
			
%>
<INPUT TYPE="HIDDEN" NAME="<%=listRef.elementAt(k).getValueKey()%>" VALUE="" DISPLAY="no">
<%
		}
%>
<script>
	// statically call set fields
	setFieldValues(document["param<%= (String)selectIdList.elementAt(sel) %>"].<%=listRef.getEntityName()%>, <%=listRef.getEntityName()%>_StoreValues, <%=listRef.getEntityName()%>_fields, <%= (String)selectIdList.elementAt(sel) %>);
</script>
<%
	}
	else
	{
%>
<I>Not yet supported</I>
<%  } %>
</TD>
<TD class="list_info1" align="left" id="row<%=sel%>_<%=i%>_3" headers="col<%=sel%>_3" >

<!--nobr--><%= curRefDesc %><!--/nobr-->

</TD>
</TR>
<% 
} // end for loop
%> 

</TABLE>
<% } // end if %>
</div>
</FORM>
<%
}
%>
</BODY>
</HTML>
