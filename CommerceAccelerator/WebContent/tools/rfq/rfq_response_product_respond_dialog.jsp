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

<%@ page import="com.ibm.commerce.beans.DataBeanManager" %>
<%@ page import="com.ibm.commerce.beans.ErrorDataBean" %>
<%@ page import="com.ibm.commerce.server.*" %>
<%@ page import="com.ibm.commerce.ras.ECMessageType" %>
<%@ page import="com.ibm.commerce.tools.test.*" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.command.*" %>
<%@ page import="com.ibm.commerce.common.objects.*" %>
<%@ page import="com.ibm.commerce.rfq.utils.*" %>
<%@ page import="com.ibm.commerce.ubf.util.*" %>
<%@ page import="com.ibm.commerce.utf.utils.*" %>
<%@ page import="com.ibm.commerce.catalog.beans.*" %>
<%@ include file="../common/common.jsp" %>
<%@ include file="../common/NumberFormat.jsp" %>

<%
	//*** GET LOCALE FROM COMANDCONTEXT ***//
	CommandContext aCommandContext = (CommandContext)request.getAttribute("CommandContext");    
	Locale   locale = null;
	String  StoreId = null;
	Integer lang = null;
	if( aCommandContext!= null ){
		locale = aCommandContext.getLocale();
		lang = aCommandContext.getLanguageId();
		StoreId = aCommandContext.getStoreId().toString();
	}
	if (locale == null) 
		locale = new Locale("en","US");
	if (lang == null)
		lang = new java.lang.Integer("-1");

	//*** GET THE RESOURCE BUNDLE BASED ON LOCALE ***//
	Hashtable rfqNLS = (Hashtable)ResourceDirectory.lookup("rfq.rfqNLS",locale);
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">

<head>
<link rel="stylesheet" href="<%= UIUtil.getCSSFile(locale)%>" type="text/css" />
<title></title>
<script type="text/javascript" src="/wcs/javascript/tools/rfq/rfqUtile.js"></script>
<script type="text/javascript" src="/wcs/javascript/tools/common/Util.js"></script>
<script type="text/javascript" src="/wcs/javascript/tools/common/DateUtil.js"></script>

<script type="text/javascript">
function view(attachment_id, pattrvalue_id) {
	var url = "RFQAttachmentView?<%= com.ibm.commerce.server.ECConstants.EC_ATTACH_ID %>=" + attachment_id + "&<%= com.ibm.commerce.rfq.utils.RFQConstants.EC_PATTRVALUE_ID %>=" + pattrvalue_id;
	var windowTitle = "<%= UIUtil.toJavaScript(rfqNLS.get("rfq_bct_Attachment")) %>";
	var attributes = 'left=0,top=0,width=1014,height=710,scrollbars=no,toolbar=no,directories=no,status=no,menubar=no,copyhistory=no,resizable=yes';
	var attachmentWindow = top.openChildWindow(url, windowTitle, attributes);
}
function ChangeParms(){
if (anAttribute.<%= RFQConstants.EC_ATTR_TYPE %> == "D"){
  document.all.unitDropDown.style.visibility='hidden';
  document.all.unitDropDown.style.display='none';
  document.all.unithead.style.visibility='hidden';
  document.all.unithead.style.display='none';

}else if (anAttribute.<%= RFQConstants.EC_ATTR_TYPE %> == "<%= com.ibm.commerce.utf.utils.UTFConstants.EC_ATTRTYPE_ATTACHMENT %>")
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
}else {
  document.all.operatorhead.style.visibility='visible';
  document.all.operatorhead.style.display='';
  document.all.valuehead.style.visibility='visible';
  document.all.valuehead.style.display='';
  document.all.unitDropDown.style.visibility='visible';
  document.all.unitDropDown.style.display='';
  document.all.operatorDropDown.style.visibility='visible';
  document.all.operatorDropDown.style.display='';
  document.all.unithead.style.visibility='visible';
  document.all.unithead.style.display='';
}

}


function init() { 
  if(anAttribute.<%= RFQConstants.EC_ATTR_TYPE %> == "D"){
    document.rfqListForm.year.value = getCurrentYear(); 
    document.rfqListForm.month.value = getCurrentMonth(); 
    document.rfqListForm.day.value = getCurrentDay(); 
  }
}


var msgMandatoryField = '<%= UIUtil.toJavaScript((String)rfqNLS.get("msgEmptyResponseValue")) %>';
var msgInvalidSize = '<%= UIUtil.toJavaScript((String)rfqNLS.get("msgInvalidSize254")) %>';
function initializeState()
{
        parent.setContentFrameLoaded(true);
}
var anAttribute = new Object();
var anProduct = new Object();
anAttribute = top.getData("anAttribute",1);
anProduct = top.getData("anProduct",1);

function retrievePanelData()
{
if (anAttribute.<%= RFQConstants.EC_ATTR_VALUE %> == "" ||anAttribute.<%= RFQConstants.EC_ATTR_VALUE %> == undefined) return;

if (anAttribute.<%= RFQConstants.EC_ATTR_TYPE %> == "D")
{
var tmpArray = new Array();
var values = new Array();
tmpArray=anAttribute.<%= RFQConstants.EC_ATTR_VALUE %>.split(' ');
var date = tmpArray[0];
values=date.split('-');
document.rfqListForm.year.value = values[0];
document.rfqListForm.month.value = values[1];
document.rfqListForm.day.value = values[2];
}
else
document.rfqListForm.attrvalue.value = anAttribute.<%=RFQConstants.EC_ATTR_VALUE%>;
}

function onLoad() { loadFrames(); }

var VPDResult;
function validatePanelData()
{
return VPDResult;
}

function validatePanelData0(){
	var form=document.rfqListForm;
	if (anAttribute.<%= RFQConstants.EC_ATTR_TYPE %> == "D")
	{
		if(!validDate(form.year.value,form.month.value,form.day.value))
	 	{
	  	alertDialog("<%= UIUtil.toJavaScript(rfqNLS.get("msgInvalidDate")) %>");
	 	return false;
		}
	}
	else
	{
		if (anAttribute.<%=RFQConstants.EC_ATTR_MANDATORY%> ==1 && isInputStringEmpty(form.attrvalue.value)) {
			reprompt(form.attrvalue, msgMandatoryField);
			return false;
			}
		var op = form.operator[form.operator.selectedIndex].value.split(",");
		var op1 = op[0];
		var allValues = new Array();

		if  (op1 == 6||op1 == 7||op1 == 8) {
			if (anAttribute.<%= RFQConstants.EC_ATTR_TYPE %> != "<%= UTFConstants.EC_ATTRTYPE_STRING %>"){
				allValues = form.attrvalue.value.split(";");
				for (var i = 0; i < allValues.length ;i++){
					if (!isValidNumber(allValues[i],<%= lang%>,true)){
	     					alertDialog("<%= UIUtil.toJavaScript(rfqNLS.get("msgInvalidNumber")) %>");
						form.attrvalue.focus();
						return false;
					}
				}	
			}
		}
		else { 
	        	if (anAttribute.<%= RFQConstants.EC_ATTR_TYPE %> != "<%= UTFConstants.EC_ATTRTYPE_STRING %>"){
	     			if (!isValidNumber(form.attrvalue.value,<%= lang%>,true)){
	     				alertDialog("<%= UIUtil.toJavaScript(rfqNLS.get("msgInvalidNumber")) %>");
					form.attrvalue.focus();
					return false;
				}
	     		}
	     	}
		
		if (!isValidUTF8length(form.attrvalue.value,254)) {
			reprompt(form.attrvalue, msgInvalidSize);
			return false;
		}
	}
return true;
}
var isAttachment;
var isReady;
if (anAttribute.<%= RFQConstants.EC_ATTR_TYPE %> == "<%= com.ibm.commerce.utf.utils.UTFConstants.EC_ATTRTYPE_ATTACHMENT %>")
{
   isAttachmet = true;
}
else 
{
    isAttachmet = false;
}
function Okaction()
{
  if (anAttribute.<%= RFQConstants.EC_ATTR_TYPE %> == "<%= com.ibm.commerce.utf.utils.UTFConstants.EC_ATTRTYPE_ATTACHMENT %>")
  {
  	var form=document.rfqListForm;
  
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
  
      top.sendBackData(anProduct,"anProduct");
      top.sendBackData(anAttribute,"anAttribute");
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
function savePanelData()
{
     

	var form = document.rfqListForm;
	var opInfo = form.operator[form.operator.selectedIndex].value.split(",");
	var operator = opInfo[0];
	var operatorName = opInfo[1];
	var unitInfo = form.unit[form.unit.selectedIndex].value.split(",");
	if (anAttribute.<%= RFQConstants.EC_ATTR_TYPE %> == "D")
		anAttribute.<%=RFQConstants.EC_ATTR_VALUE%> = form.year.value+"-"+form.month.value+"-"+form.day.value+" 00:00:00.0";
	else
		anAttribute.<%=RFQConstants.EC_ATTR_VALUE%> = form.attrvalue.value;
	
	if (unitInfo[0] != undefined && unitInfo[0]!=null)
		anAttribute.<%=RFQConstants.EC_ATTR_UNIT%> =  unitInfo[0];
	if (unitInfo[1] != undefined && unitInfo[1]!=null)
		anAttribute.UnitDsc = unitInfo[1];
	
	anAttribute.<%=RFQConstants.EC_ATTR_OPERATOR%> = operator;
	anAttribute.operatorName = operatorName;
        for(var i = 0;i < anProduct.<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>.length;i++)
          {
            if (anProduct.<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[i].<%=RFQConstants.EC_PATTRVALUE_ID%> == anAttribute.<%=RFQConstants.EC_PATTRVALUE_ID%>)
              {
                 anProduct.<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[i].<%=RFQConstants.EC_ATTR_VALUE%> = anAttribute.<%=RFQConstants.EC_ATTR_VALUE%>; 
                 anProduct.<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[i].<%=RFQConstants.EC_ATTR_UNIT%> = anAttribute.<%=RFQConstants.EC_ATTR_UNIT%>; 
                 anProduct.<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[i].<%=RFQConstants.EC_ATTR_OPERATOR%> = anAttribute.<%=RFQConstants.EC_ATTR_OPERATOR%>; 
                 anProduct.<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[i].operatorName = anAttribute.operatorName; 
                 break; 
              }
          }
        top.sendBackData(anProduct,"anProduct");
    
}

function setupDate() { 
    window.yearField = document.rfqListForm.year;
    window.monthField = document.rfqListForm.month;
    window.dayField =document.rfqListForm.day;
}

function closeCalendar()
{
    document.all.CalFrame.style.display="none";
}
</script>
</head>

<body class="content" onload="init();ChangeParms();retrievePanelData()" onclick="closeCalendar()">

<iframe style="display:none;position:absolute;width:198;height:230" 
        id="CalFrame" marginheight="0" marginwidth="0" frameborder="0" scrolling="no" 
        src="/webapp/wcs/tools/servlet/Calendar" title='<%= rfqNLS.get("calendarTool")%>'>
</iframe>

<h1><%= rfqNLS.get("rfq_bct_ProductAtt") %></h1>
<%= rfqNLS.get("instruction_Specresponse") %>

<form name="rfqListForm" action="RFQResponsePattributeAttachmentAdd" enctype="multipart/form-data" method="post" target="NAVIGATION">
<input type="hidden" name="XMLFile" value="rfq.rfqresponseproductrespond" />

<table border="0" width="100%">

  <tbody>
    <tr>
      <td ><b><%= rfqNLS.get("rfq_bct_ProductAtt")%></b></td>
    </tr>
    <tr>
      <td>
      <table border="0" width="100%">
        <tbody>
          <tr>
            <td width="25%">
                  <%= rfqNLS.get("rfqattribname") %>
</td>
		<td>
       		  <script type="text/javascript">
		    document.write('<i>'+ ToHTML(anAttribute.<%=RFQConstants.EC_ATTR_DESCRIPTION%>)+'</i>');
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
		<td width="25%"><label for="reqOperator"><%= rfqNLS.get("rfqoperator") %></label></td>
		<td>
		 <script type="text/javascript">
		    document.write('<i>'+ anAttribute.req_operator+'</i>');  	
		 </script>
		</td>
          </tr>
          <tr>
		<td width="25%"><label for="reqValue"><%= rfqNLS.get("value") %></label></td>
		<td>
       		  <script type="text/javascript">
       		  {
       		  var value = anAttribute.req_value;
       		  if (anAttribute.<%= RFQConstants.EC_ATTR_TYPE %> == "<%= com.ibm.commerce.utf.utils.UTFConstants.EC_ATTRTYPE_ATTACHMENT %>")
       		  {
       		     
       		      value ="<a href='javascript:view("+anAttribute.<%= RFQConstants.EC_ATTR_REQ_VALUE %>+","+anAttribute.<%= RFQConstants.EC_PATTRVALUE_ID %>+ ");'> " + anAttribute.req_filename +"</a>"
		      document.write(value);
       		  } else if (anAttribute.<%= RFQConstants.EC_ATTR_TYPE %> == "D")
       		  {
			var timeArray = new Array();
			var timeValues = new Array();
			timeArray=value.split(' ');
			var dateString = timeArray[0];
			timeValues=dateString.split('-');
			var formattedDate = getFormattedDate(timeValues[0], timeValues[1], timeValues[2], "<%= locale.toString() %>");
			document.write('<i>'+ToHTML(formattedDate)+'</i>');
       		  }else
       		  {       		     
    		
		    document.write('<i>'+ToHTML(value)+'</i>');
		   }
		  }
		  </script>
		</td>
          </tr>
          <tr>   
		<td width="25%"><label for="reqUnits"><%= rfqNLS.get("rfqunits") %></label></td>
		<td>
       		  <script type="text/javascript">
		    document.write('<i>'+ anAttribute.req_unit+'</i>');
		  </script>
			
            </td>
          </tr>
        </tbody>
      </table>
      </td>
    </tr>
    <tr>
      <td ><b><%= rfqNLS.get("resresponse") %></b></td>
    </tr>
    <tr>
      <td>
      <table border="0" width="100%">
 	<tr>
		<td width="25%"><%= rfqNLS.get("rfqattribname") %></td>
		<td width="25%"><div id="operatorhead" style="visibility:hidden"><label for="operator"><%= rfqNLS.get("rfqoperator") %></label></div></td>
		<td width="25%"><div id="valuehead" style="visibility:hidden"><label for="value"><%= rfqNLS.get("value") %>&nbsp;<%= rfqNLS.get("required") %></label></div></td>
		<td width="25%"><div id="unithead" style="visibility:hidden"><label for="unit"><%= rfqNLS.get("rfqunits") %></label></div>
		</td>
	</tr>
	<tr>
		<td><i><script type="text/javascript">
		    document.write(anAttribute.<%=RFQConstants.EC_ATTR_DESCRIPTION%>);
		  </script></i></td>
		<td>
		<div id="operatorDropDown" style="visibility:hidden">
			<select name="operator" id="operator">
<%
				String errorFound="";
				// get all operators
				String operatorDesc = "";
				String operatorName = "";
				String operatorId    = "";
				String tmp          = "";
				String rowsFoundOper = "N";
				int k2 = 0;
				try { 
					OperatorDataBean odbean = null;
					odbean = new OperatorDataBean();
					java.util.Enumeration enumeration = odbean.findAll();

					while (enumeration != null && enumeration.hasMoreElements()) {
						rowsFoundOper = "Y";
						k2++;
						OperatorDataBean odbean2 = (OperatorDataBean)enumeration.nextElement();
						operatorId = odbean2.getOperatorId();
						operatorName = odbean2.getOperator();

						OperatorDescriptionDataBean oddbean = null;
						oddbean = new OperatorDescriptionDataBean();
						oddbean.setInitKey_operatorId(String.valueOf(operatorId));
						oddbean.setInitKey_languageId(lang.toString());
						operatorDesc = oddbean.getDescription();
						tmp = operatorId + "," + operatorDesc;

						if (k2 == 1) {
%>
							<option value="<%= tmp %>" selected="selected"><%= operatorDesc %></option>
<%
						} else {
%> 
							<option value="<%= tmp %>" ><%= operatorDesc %></option>
<%
						} // end if
					} // end while
					if (rowsFoundOper.equals("N"))
						errorFound = "nooperatordata";
				} catch (Exception e2) {if (errorFound.equals("N")) errorFound = "Operator - " + UIUtil.toJavaScript(e2.toString()); }
%>
			</select></div>
	</td>
	<td>
	<script type="text/javascript">
			if (anAttribute.<%= RFQConstants.EC_ATTR_TYPE %> == "D")
			{
			document.write("<label for='year'><%= UIUtil.toJavaScript(rfqNLS.get("year")) %>   </label>");
			document.write("<input size='4' type='text' name='year' id='year' maxlength='4' value='' />");
			document.write("<label for='month'><%= UIUtil.toJavaScript(rfqNLS.get("month")) %>  </label>");
			document.write("<input size='2' type='text' name='month' id='month' maxlength='2' value='' />");
			document.write("<label for='day'><%= UIUtil.toJavaScript(rfqNLS.get("day")) %>    </label>");
			document.write("<input size='2' type='text' name='day' id='day' maxlength='2' value='' />");
			document.write('<a href="javascript:setupDate();showCalendar(document.rfqListForm.calImg1)"> <img src="/wcs/images/tools/calendar/calendar.gif" border="0" id="calImg1" alt=\"<%= UIUtil.toJavaScript(rfqNLS.get("calendarTool"))%>\" /></a>');

			}
			else if (anAttribute.<%= RFQConstants.EC_ATTR_TYPE %> != "<%= com.ibm.commerce.utf.utils.UTFConstants.EC_ATTRTYPE_ATTACHMENT %>")
			{
			   document.write('<input size="20" type="text" name="attrvalue" id="value" maxlength="254" value="	" />');
			}else
			{
			   document.write('<input type="hidden" name="attrvalue" maxlength="254" value="1" />'); 
			}  
		</script>
	
	</td>
	 <td>
<div id="unitDropDown" style="visibility:hidden">
<script type="text/javascript">
	document.write('<select name="unit" id="unit">');
	document.write('<option value="," selected="selected"></option>');
<%
	try {
	QuantityUnitDescriptionAccessBean quab = new QuantityUnitDescriptionAccessBean();
	java.util.Enumeration enumeration = quab.findByLanguage(lang);

	while ( enumeration != null && enumeration.hasMoreElements() ) {
		QuantityUnitDescriptionAccessBean quab2 =  (QuantityUnitDescriptionAccessBean)enumeration.nextElement();
		String unit_id = quab2.getQuantityUnitId();
		String unit_desc = quab2.getDescription();
%>
	if(anAttribute.<%=RFQConstants.EC_ATTR_UNIT%> == "<%=unit_id%>"){
		document.write('<option value="<%=UIUtil.toJavaScript(unit_id)%>,<%= UIUtil.toJavaScript(unit_desc)%>" selected="selected"><%=UIUtil.toJavaScript(unit_desc)%></option>');
	}else{
		document.write('<option value="<%=UIUtil.toJavaScript(unit_id)%>,<%=UIUtil.toJavaScript(unit_desc)%>"><%=UIUtil.toJavaScript(unit_desc)%></option>');
	}
<%
	} //end while
	} catch (Exception e) {out.println("Error - " + e.toString()); }
%>
	document.write('</select>');
</script>
</div>
	</td>
	</tr>
     <script type="text/javascript">
	  if (anAttribute.<%= RFQConstants.EC_ATTR_TYPE %> == "<%= com.ibm.commerce.utf.utils.UTFConstants.EC_ATTRTYPE_ATTACHMENT %>")
	  {
	        document.write('<tr><td><%= UIUtil.toJavaScript(rfqNLS.get("filename")) %><input type="hidden" name="refcmd" value="RFQResponsePattributeAttachmentAdd" /> <input type="hidden" name="URL" value="RFQResponsePattributeAttachmentAddReturn" /></td>');
	  		document.write('<td><input type="file" name="filename" id="value" /></td></tr>');
	  }
     </script>
</table>

<table width="100%">
<tr><td>&nbsp;</td></tr>

</table>
<%
	String tmpstr = rfqNLS.get("msgDelimiterInformation").toString();
	String infomsg = tmpstr.substring(0,tmpstr.indexOf("{0}")) + RFQConstants.EC_ATTR_VALUEDELIM_VALUE + tmpstr.substring(tmpstr.indexOf("{0}")+3);
%>
<p><%= infomsg %></p>

</td>
</tr>

</tbody>
</table>
</form>

<script type="text/javascript">
  retrievePanelData();
  initializeState();
</script>


</body>
</html>
