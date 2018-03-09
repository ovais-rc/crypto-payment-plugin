<!-- 
========================================================================
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
========================================================================
--> 
<%@ page import="java.util.*" %>
<%@ page import="com.ibm.commerce.beans.DataBeanManager" %>
<%@ page import="com.ibm.commerce.beans.ErrorDataBean" %>
<%@ page import="com.ibm.commerce.server.*" %>
<%@ page import="com.ibm.commerce.ras.ECMessageType" %>
<%@ page import="com.ibm.commerce.tools.test.*" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.command.*" %>
<%@ page import="com.ibm.commerce.common.objects.*" %>
<%@ page import="com.ibm.commerce.catalog.objects.*" %>
<%@ page import="com.ibm.commerce.rfq.utils.*" %>
<%@ page import="com.ibm.commerce.utf.utils.*" %>
<%@ page import="com.ibm.commerce.exception.*" %>
<%@ include file="../common/common.jsp" %>
<%@ include file="../common/NumberFormat.jsp" %>

<%
	CommandContext aCommandContext = (CommandContext)request.getAttribute("CommandContext");    
	Locale   locale = null;
	String  StoreId = null;
	Integer  langId = null;
   if( aCommandContext!= null ){
   	locale = aCommandContext.getLocale();
	langId = aCommandContext.getLanguageId();
	StoreId = aCommandContext.getStoreId().toString();
	}
   if (locale == null)	locale = new Locale("en","US");
   if (langId == null) langId = new Integer("-1");
	//*** GET THE RESOURCE BUNDLE BASED ON LOCALE ***//
	Hashtable rfqNLS = (Hashtable)ResourceDirectory.lookup("rfq.rfqNLS",locale);
%>
 
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<link rel="stylesheet" href="<%= UIUtil.getCSSFile(locale)%>" type="text/css" />
<title></title>
<script type="text/javascript" src="/wcs/javascript/tools/common/DateUtil.js"></script>
<script type="text/javascript" src="/wcs/javascript/tools/rfq/rfqUtile.js"></script> 
<script type="text/javascript" src="/wcs/javascript/tools/common/Util.js"></script>
<script type="text/javascript">
var msgMandatoryField = '<%= UIUtil.toJavaScript(rfqNLS.get("msgEmptyResponseValue")) %>';
var msgInvalidSize = '<%= UIUtil.toJavaScript((String)rfqNLS.get("msgInvalidSize254")) %>';

var attributeObj;
attributeObj = top.getData("attributeData",1);

function view(attachment_id, pattrvalue_id) {
	var url = "RFQAttachmentView?<%= com.ibm.commerce.server.ECConstants.EC_ATTACH_ID %>=" + attachment_id + "&<%= com.ibm.commerce.rfq.utils.RFQConstants.EC_PATTRVALUE_ID %>=" + pattrvalue_id;
	var windowTitle = "<%= UIUtil.toJavaScript(rfqNLS.get("rfq_bct_Attachment")) %>";
	var attributes = 'left=0,top=0,width=1014,height=710,scrollbars=no,toolbar=no,directories=no,status=no,menubar=no,copyhistory=no,resizable=yes';
	var attachmentWindow = top.openChildWindow(url, windowTitle, attributes);
}
function onLoad(){
	
	parent.setContentFrameLoaded(true);
}
var VPDResult;
function validatePanelData()
{
return VPDResult;
}

var isAttachment;
var isReady;
if (attributeObj.<%= RFQConstants.EC_ATTR_TYPE %> == "<%= com.ibm.commerce.utf.utils.UTFConstants.EC_ATTRTYPE_ATTACHMENT %>")
{
   isAttachmet = true;
}
else 
{
    isAttachmet = false;
}
function Okaction()
{
  if (attributeObj.<%= RFQConstants.EC_ATTR_TYPE %> == "<%= com.ibm.commerce.utf.utils.UTFConstants.EC_ATTRTYPE_ATTACHMENT %>")
  {
    	var form=document.attrDiag;
    
    	if (isInputStringEmpty(form.filename.value)) 
    	{
    	    reprompt(form.filename, msgMandatoryField);
    	    isReady=false;
    	    return false;
    	}
    
    	if (!isValidUTF8length(form.filename.value,254)) 
    	{
    	    reprompt(form.filename, msgInvalidSize);
    	    isReady=false;
    	    return false;
	}
  
        isReady = true;
  }else
  {
     	VPDResult = validatePanelData0();
     	if(!VPDResult)
     	{
		return false;
	}else 
	{
           savePanelData();
           top.goBack();
        }
  }
}
function savePanelData(){
	attributeObj.<%= RFQConstants.EC_RFQ_CHANGE_STATUS %> = "<%= RFQConstants.EC_RFQ_CHANGE_TRUE %>";
    if (attributeObj.<%= RFQConstants.EC_ATTR_TYPE %> == "<%= UTFConstants.EC_ATTRTYPE_DATETIME %>")
	attributeObj.<%=RFQConstants.EC_ATTR_VALUE%> = document.forms["attrDiag"].year.value +"-"+document.forms["attrDiag"].month.value+"-"+document.forms["attrDiag"].day.value+" 00:00:00.0"
    else	
	attributeObj.<%=RFQConstants.EC_ATTR_VALUE%> =document.forms["attrDiag"].attrvalue.value;
	attributeObj.<%=RFQConstants.EC_ATTR_OPERATOR_DES%> =document.forms["attrDiag"].Op.options[document.forms["attrDiag"].Op.selectedIndex].text;
	attributeObj.<%=RFQConstants.EC_ATTR_OPERATOR%> =document.forms["attrDiag"].Op.options[document.forms["attrDiag"].Op.selectedIndex].value;
	attributeObj.<%=RFQConstants.EC_ATTR_UNIT_DESC%> =document.forms["attrDiag"].unit.options[document.forms["attrDiag"].unit.selectedIndex].text;
	attributeObj.<%=RFQConstants.EC_ATTR_UNIT%> =document.forms["attrDiag"].unit.options[document.forms["attrDiag"].unit.selectedIndex].value;
 	
}

function validatePanelData0()
{
	var form=document.attrDiag;
	if (attributeObj.<%= RFQConstants.EC_ATTR_TYPE %> == "<%= UTFConstants.EC_ATTRTYPE_DATETIME %>")
	{
	 if(!validDate(form.year.value,form.month.value,form.day.value))
	 {
	  alertDialog("<%= UIUtil.toJavaScript(rfqNLS.get("msgInvalidDate")) %>");
	  return false;
	  }
	}
	else
	{
	     if (isInputStringEmpty(form.attrvalue.value) && attributeObj.<%=RFQConstants.EC_ATTR_MANDATORY %> == 1) {
		reprompt(form.attrvalue, msgMandatoryField);
		form.attrvalue.focus();
		return false;
		}
	     var op = form.Op[form.Op.selectedIndex].value;
	     if (op==6||op==7||op==8){
	     	if (attributeObj.<%= RFQConstants.EC_ATTR_TYPE %> != "<%= UTFConstants.EC_ATTRTYPE_STRING %>"){
	     		var allValues = new Array();
	     		allValues = form.attrvalue.value.split(";");
	     		for (var i = 0; i <allValues.length; i++){
	     			if (!isValidNumber(allValues[i],<%= langId%>,true)){
	     				alertDialog("<%= UIUtil.toJavaScript(rfqNLS.get("msgInvalidNumber")) %>");
					form.attrvalue.focus();
					return false;
				}
	     		}
	     	}
	     }
	     else {
	     		if (attributeObj.<%= RFQConstants.EC_ATTR_TYPE %> != "<%= UTFConstants.EC_ATTRTYPE_STRING %>"){
	     			if (!isValidNumber(form.attrvalue.value,<%= langId%>,true)){
	     				alertDialog("<%= UIUtil.toJavaScript(rfqNLS.get("msgInvalidNumber")) %>");
					form.attrvalue.focus();
					return false;
				}
	     		}
			if (utf8StringByteLength( form.attrvalue.value ) > 254){
				form.attrvalue.focus();
				parent.alertDialog("<%= UIUtil.toJavaScript(rfqNLS.get("msgInvalidSize254")) %>");
				return false;
				}
	     }
	}
	return true;
}
function getFormatedValue(value,type){
	var tempvalue;
	if (value == undefined || value == null || value == "") return("");
	tempvalue = value;
    	switch (type) {
    		case "<%= UTFConstants.EC_ATTRTYPE_DATETIME %>":
    			tempArray = new Array();
    		 	tempArray = value.split(" ");
    		 	var dateString = tempArray[0];
			var timeValues = dateString.split('-');
			tempvalue = getFormattedDate(timeValues[0], timeValues[1], timeValues[2], "<%= locale.toString() %>");

    			break;
    		case "<%= UTFConstants.EC_ATTRTYPE_STRING %>":
    			break;
    		default:
    			;
//    		tempvalue = numberToStr(value,<%= langId %>,null);
    		}
    	return tempvalue;
}
function setupDate() { 
    window.yearField = document.attrDiag.year;
    window.monthField = document.attrDiag.month;
    window.dayField =document.attrDiag.day;
}
function init() { 
if (attributeObj.<%= RFQConstants.EC_ATTR_TYPE %> == "<%= UTFConstants.EC_ATTRTYPE_DATETIME %>")
{
    document.attrDiag.year.value = getCurrentYear(); 
    document.attrDiag.month.value = getCurrentMonth(); 
    document.attrDiag.day.value = getCurrentDay(); 
  }
}

function initializeState()
{

        parent.setContentFrameLoaded(true);
}

function ChangeParms(){
if (attributeObj.<%= RFQConstants.EC_ATTR_TYPE %> == "<%= UTFConstants.EC_ATTRTYPE_DATETIME %>")
{
  document.all.unitDropDown.style.visibility='hidden';
  document.all.unitDropDown.style.display='none';
  document.all.unithead.style.visibility='hidden';
  document.all.unithead.style.display='none';

} else if (attributeObj.<%= RFQConstants.EC_ATTR_TYPE %> == "<%= com.ibm.commerce.utf.utils.UTFConstants.EC_ATTRTYPE_ATTACHMENT %>")
{
  document.all.operatorhead.style.visibility='hidden';
  document.all.operatorhead.style.display='none';
  document.all.valuehead.style.visibility='hidden';
  document.all.valuehead.style.display='none';
  document.all.unitDropDown.style.visibility='hidden';
  document.all.unitDropDown.style.display='none';
  document.all.operatorDropDown.style.visibility='hidden';
  document.all.operatorDropDown.style.display='none';
  document.all.unithead.style.visibility='hidden';
  document.all.unithead.style.display='none';
}
else {
  document.all.operatorhead.style.visibility='visible';
  document.all.operatorhead.style.display='';
  document.all.valuehead.style.visibility='visible';
  document.all.valuehead.style.display='';
  document.all.operatorDropDown.style.visibility='visible';
  document.all.operatorDropDown.style.display='';
  document.all.unitDropDown.style.visibility='visible';
  document.all.unitDropDown.style.display='';
  document.all.unithead.style.visibility='visible';
  document.all.unithead.style.display='';
}
}

function closeCalendar()
{
    document.all.CalFrame.style.display="none";
}
</script>
</head>

<body class="content" onload="onLoad();init();ChangeParms();retrievePanelData();" onclick="closeCalendar()">

<iframe style="display:none;position:absolute;width:198;height:230" 
        id="CalFrame" marginheight="0" marginwidth="0" frameborder="0" scrolling="no" 
        src="/webapp/wcs/tools/servlet/Calendar" title='<%= rfqNLS.get("calendarTool")%>'>
</iframe>

<h1><%= rfqNLS.get("rfq_bct_ProductAtt") %></h1>
<%= rfqNLS.get("instruction_Specresponse_modify") %>

<form name="attrDiag" action="RFQResponsePattributeAttachmentAdd" enctype="multipart/form-data" method="post" target="NAVIGATION">
<input type="hidden" name="XMLFile" value="rfq.rfqresponseproductmodify" />

<table border="0" width="100%">
  <tbody>
    <tr>
      <td>
      <table border="0" width="100%">
        <tbody>
          <tr>
            <td width="25%">
<b>                  <%= rfqNLS.get("rfqattribname")%>:</b>
</td>
		<td>
       		  <script type="text/javascript">
		    document.write(ToHTML(attributeObj.<%=RFQConstants.EC_ATTR_NAME%>));
		  </script>

		</td>
          </tr>
        </tbody>
      </table>
      </td>
    </tr>
    
    <tr>
      <td>
      <table border="0" width="100%">
        <tbody>
          <tr>
		<td  width="25%"><%= rfqNLS.get("rfqoperator") %></td>
		<td>
		   <script type="text/javascript">
		    document.write(attributeObj.<%=RFQConstants.EC_ATTR_REQ_OPERATOR_DES%>);
		  </script>
		</td>
          </tr>
          <tr>
		<td width="25%"><%= rfqNLS.get("value") %></td>
		<td>
		  <script type="text/javascript">
		  var value = getFormatedValue(attributeObj.<%= RFQConstants.EC_ATTR_REQ_VALUE %>,attributeObj.<%= RFQConstants.EC_ATTR_TYPE %>);
		  if (attributeObj.<%= RFQConstants.EC_ATTR_TYPE %> == "<%= com.ibm.commerce.utf.utils.UTFConstants.EC_ATTRTYPE_ATTACHMENT %>")
		  {
		      value ="<a href='javascript:view("+attributeObj.<%= RFQConstants.EC_ATTR_REQ_VALUE %>+","+attributeObj.<%= RFQConstants.EC_PATTRVALUE_ID %>+ ");'> " + attributeObj.req_filename +"</a>"
		      document.write(value);
		  }else
		  {
		     document.write(ToHTML(value));
		  }
		  </script>
		</td>
          </tr>
          <tr>   
		<td  width="25%">
		<%= rfqNLS.get("rfqunits") %></td>
		<td>
       		  <script type="text/javascript">
		    document.write(attributeObj.<%=RFQConstants.EC_ATTR_REQ_UNIT%>);
		  </script>
			
            </td>
          </tr>
        </tbody>
      </table>
      </td>
    </tr>
    <tr>
      <td ><b><%= rfqNLS.get("resresponsevalue") %></b></td>
    </tr>
    <tr>
      <td>
      <table border="0" width="100%">
        <tbody>
        <tr>
          			
		<td><div id="operatorhead" style="visibility:hidden"><label for="Op"><%= rfqNLS.get("rfqoperator") %></label></div></td>
		<td><div id="valuehead" style="visibility:hidden"><label for="value"><%= rfqNLS.get("value") %>&nbsp;<%= rfqNLS.get("required") %></label></div></td>		
		<td><div id="unithead" style="visibility:hidden"><label for="unit"><%= rfqNLS.get("rfqunits") %></label></div></td>
	</tr>
	<tr>
		<td>			
		    <div id="operatorDropDown" style="visibility:hidden">	
		    <script type="text/javascript">
		    	document.write('<select size="1" name="Op" id="Op">');				
				<%
				OperatorAccessBean OAB = new OperatorAccessBean();
				OperatorDescriptionAccessBean OPABDsc =null;
				Enumeration enu = OAB.findAll();
				while (enu.hasMoreElements()){
					OAB = (OperatorAccessBean)enu.nextElement();
					OPABDsc = new OperatorDescriptionAccessBean();
					OPABDsc.setInitKey_languageId(langId.toString());
					OPABDsc.setInitKey_operatorId(OAB.getOperatorId());
				%>

				if (attributeObj.<%=RFQConstants.EC_ATTR_OPERATOR%> == "<%=OAB.getOperatorId()%>")			
					document.write("<option value='<%=OAB.getOperatorId() %>' selected='selected'> <%=UIUtil.toJavaScript(OPABDsc.getDescription()) %></option>");
				else
					document.write("<option value='<%=OAB.getOperatorId() %>'> <%=UIUtil.toJavaScript(OPABDsc.getDescription()) %></option>");		
				
				<% 
				}
				%>
				document.write('</select>');
			</script>			
			</div>		
		</td>
          		
		<td>
		<script type="text/javascript">
			if (attributeObj.<%= RFQConstants.EC_ATTR_TYPE %> == "<%= UTFConstants.EC_ATTRTYPE_DATETIME %>")
			{
			document.write("<label for='year'><%= UIUtil.toJavaScript(rfqNLS.get("year")) %></label>");
			document.write("<input size='4' type='text' name='year' id='year' maxlength='4' value='' />");
			document.write("<label for='month'><%= UIUtil.toJavaScript(rfqNLS.get("month")) %></label>");
			document.write("<input size='2' type='text' name='month' id='month' maxlength='2' value='' />");
			document.write("<label for='day'><%= UIUtil.toJavaScript(rfqNLS.get("day")) %></label>");
			document.write("<input size='2' type='text' name='day' id='day' maxlength='2' value='' />");
			document.write('<a href="javascript:setupDate();showCalendar(document.attrDiag.calImg1)"><img src="/wcs/images/tools/calendar/calendar.gif" border="0" id="calImg1" alt=\"<%= UIUtil.toJavaScript(rfqNLS.get("calendarTool")) %>\" /></a>');
			}
			else if (attributeObj.<%= RFQConstants.EC_ATTR_TYPE %> != "<%= com.ibm.commerce.utf.utils.UTFConstants.EC_ATTRTYPE_ATTACHMENT %>")
			{
			   document.write('<input size="20" type="text" name="attrvalue" id="value" maxlength="254" value="	" />');
			}else
			{
			   document.write('<input type="hidden" name="attrvalue" id="value" maxlength="254" value="1" />'); 
			}  
		</script>	
		</td>
				
		<td>
			<div id="unitDropDown" style="visibility:hidden">
			<script type="text/javascript">
			document.write('<select name="unit" id="unit">');
			document.write('<option value=""><%= UIUtil.toJavaScript(rfqNLS.get("none")) %></option>');
			<% QuantityUnitAccessBean QAB = new QuantityUnitAccessBean();
			QuantityUnitDescriptionAccessBean qtUnitDesAB = new QuantityUnitDescriptionAccessBean();
			Hashtable h = new Hashtable();
			Enumeration enumDesc = qtUnitDesAB.findByLanguage(langId);
			while (enumDesc.hasMoreElements()){
				qtUnitDesAB=(QuantityUnitDescriptionAccessBean)enumDesc.nextElement();
				h.put(qtUnitDesAB.getQuantityUnitId(),qtUnitDesAB.getDescription());
				}
  			 String qtUnit,qtUnitDesc;
			Enumeration enum1 = QAB.findAll();
			while (enum1.hasMoreElements()){
				QAB= (QuantityUnitAccessBean)enum1.nextElement();
				qtUnit = QAB.getQuantityUnitId();
				qtUnitDesc= (String)h.get(qtUnit);
				if (qtUnitDesc == null) qtUnitDesc = qtUnit;
				%>
			
			if (attributeObj.<%= RFQConstants.EC_ATTR_UNIT %> == "<%= qtUnit %>" )
				document.write('<option value = "<%= UIUtil.toJavaScript(qtUnit) %>" selected="selected"><%= UIUtil.toJavaScript(qtUnitDesc) %></option>');
			else
				document.write('<option value = "<%= UIUtil.toJavaScript(qtUnit) %>" ><%= UIUtil.toJavaScript(qtUnitDesc) %></option>');
			
			<% }%>
			document.write('</select>');
			</script>
			</div>
		</td>
		</tr>
		
		<tr>
		<td>
		<script type="text/javascript">
	  	if (attributeObj.<%= RFQConstants.EC_ATTR_TYPE %> == "<%= com.ibm.commerce.utf.utils.UTFConstants.EC_ATTRTYPE_ATTACHMENT %>")
	  	{	  	
			document.write('<tr><td><%= UIUtil.toJavaScript(rfqNLS.get("filename")) %><input type="hidden" name="refcmd" value="RFQResponsePattributeAttachmentAdd" /><input type="hidden" name="URL" value="RFQNResponsePattributeAttachmentAddReturn" /></td>');
			document.write('<td><input type="file" name="filename" id="value" /></td></tr>');		
	  	}
		</script>
		</td>
		</tr>
		</tbody>
      </table>
      </td>
    </tr>
    </tbody>
</table>
<%
      String tmpstr = rfqNLS.get("msgDelimiterInformation").toString();
      String infomsg = tmpstr.substring(0,tmpstr.indexOf("{0}")) + RFQConstants.EC_ATTR_VALUEDELIM_VALUE + tmpstr.substring(tmpstr.indexOf("{0}")+3);
%>
<p><%= infomsg %></p>
</form>

<script type="text/javascript">
{
function retrievePanelData() {
	var values=attributeObj.<%= RFQConstants.EC_ATTR_VALUE %>;
	values = getFormatedValue(values,attributeObj.<%= RFQConstants.EC_ATTR_TYPE %>);
	if (values != "") {
		if (attributeObj.<%= RFQConstants.EC_ATTR_TYPE %> == "<%= UTFConstants.EC_ATTRTYPE_DATETIME %>"){
			var tmpArray = new Array();
			var dateTokens = new Array();
			tmpArray=(attributeObj.<%= RFQConstants.EC_ATTR_VALUE %>).split(' ');
			dateTokens = tmpArray[0].split('-');
			document.forms["attrDiag"].year.value = dateTokens[0];
			document.forms["attrDiag"].month.value = dateTokens[1];
			document.forms["attrDiag"].day.value = dateTokens[2];
		} else {
			document.forms["attrDiag"].attrvalue.value=values;
		}
	}
}
}
initializeState();
</script>

</body>
</html>

