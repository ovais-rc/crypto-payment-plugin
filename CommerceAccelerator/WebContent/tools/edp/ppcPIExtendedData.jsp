<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2001, 2016 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<%@ page import="java.util.*" %>
<%@ page import="java.math.*" %>
<%@ page import="com.ibm.commerce.server.*" %>
<%@ page import="com.ibm.commerce.server.ECConstants" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.server.*" %>
<%@ page import="com.ibm.commerce.tools.common.ui.taglibs.*" %>
<%@ page import="com.ibm.commerce.tools.util.UIUtil" %>
<%@ page import="com.ibm.commerce.payment.ppc.beans.*" %>
<%@ page import="com.ibm.commerce.payments.plugin.ExtendedData" %>
<%@ page import="com.ibm.commerce.edp.api.EDPPaymentInstruction"%>
<%@ page import="com.ibm.commerce.edp.beans.EDPPaymentInstructionsDataBean" %>
<%@ include file="../common/common.jsp" %>
<%@ include file="ppcUtil.jsp" %>
<%
// obtain the resource bundle for display
CommandContext cmdContextLocale = (CommandContext) request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
Locale jLocale = cmdContextLocale.getLocale();
Integer langId = cmdContextLocale.getLanguageId();
Integer storeId = cmdContextLocale.getStoreId();
String currency = cmdContextLocale.getCurrency();
Hashtable ppcLabels = (Hashtable) ResourceDirectory.lookup("edp.ppcLabels", jLocale);

JSPHelper jspHelper = new JSPHelper(request);

String piId = request.getParameter("piId");
String orderId = request.getParameter("orderId");

HashMap protocolData = new HashMap();
if(orderId != null && !orderId.equals("")){
     EDPPaymentInstructionsDataBean edpPIDataBean = new EDPPaymentInstructionsDataBean();
     edpPIDataBean.setOrderId(new Long(orderId));
     com.ibm.commerce.beans.DataBeanManager.activate(edpPIDataBean, request);
     ArrayList pis = edpPIDataBean.getPaymentInstructions();
	 Iterator iteForPI = pis.iterator();
	 while(iteForPI.hasNext()){
	      EDPPaymentInstruction aPI = (EDPPaymentInstruction)iteForPI.next();
		   if(aPI!=null && aPI.getBackendPIId() != null && aPI.getBackendPIId().toString().equals(piId)){
		        protocolData = aPI.getProtocolData();
		        break;
		   }
	 }
}

if(protocolData.isEmpty()){
	if(piId != null && !piId.equals("")){
		PPCGetPaymentInstructionDataBean ppcGetPIdata = new PPCGetPaymentInstructionDataBean();
		ppcGetPIdata.setPIId(piId);
		com.ibm.commerce.beans.DataBeanManager.activate(ppcGetPIdata, request);
		protocolData = ppcGetPIdata.getPaymentInstruction().getExtendedData();
	}
}

PPCPIExtendedDataDataBean piExtDataBean = new PPCPIExtendedDataDataBean();
piExtDataBean.setPIId(piId);

com.ibm.commerce.beans.DataBeanManager.activate(piExtDataBean, request);

ExtendedData extData = piExtDataBean.getExtendedData();
 HashMap hashData = extData.getExtendedDataAsHashMap();
Set keySet = hashData.keySet();
Iterator iter = keySet.iterator();
int index = 0;
%>

<html>
<head>
<title><%=UIUtil.toHTML((String) ppcLabels.get("title"))%></title>

<SCRIPT SRC="/wcs/javascript/tools/common/dynamiclist.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/common/NumberFormat.js"></SCRIPT>
<script src="/wcs/javascript/tools/common/Util.js"></script>
<script language="JavaScript">
	var back = "";
	back = top.getData("back");	
	
	var row = 1;
	var checkBoxes=new Array();	
	var ListDatas = new ListDate("payInst");
	var typesTranslated=new Array('<%=ppcLabels.get("Boolean")%>','<%=ppcLabels.get("Integer")%>','<%=ppcLabels.get("Long")%>','<%=ppcLabels.get("BigDecimal")%>','<%=ppcLabels.get("String")%>');	
	
		
function ListDate(instanceName) {
  this.instanceName = instanceName;
  this.data = new Array();  
}

function extData(key,value,type){
	this.key=key;
	this.value=value;	
	this.type=type;
}

function initializeDynamicList(tableName) {

  startDlistTable(tableName,'100%');
  startDlistRowHeading();  
  addDlistColumnHeading("<%=UIUtil.toJavaScript(ppcLabels.get("name"))%>",true,null,null,null);
  addDlistColumnHeading("<%=UIUtil.toJavaScript(ppcLabels.get("value"))%>",true,null,null,null);
  addDlistColumnHeading("<%=UIUtil.toJavaScript(ppcLabels.get("type"))%>",true,null,null,null); 
  endDlistRowHeading();
  endDlistTable();

}




function loadPanelData(){	

    if (parent.setContentFrameLoaded)
	{
	   parent.setContentFrameLoaded(true);
	}
	
	if(back == "back"){
	
		if(top.getData("extData")!=null ){
			ListDatas.data=top.getData("extData");
			ListDatas.outputToDynamicList('extdata');		
		}
	}
	
}

function validatePanelData () {

	return true;
}

function savePanelData(){
	
		
}

function outputToDynamicList(tableName) {

  checkBoxes=new Array(); 

  for (i=0;i<this.data.length;i++) {
    var dynamicListIndex=i+1;

    insRow(tableName,dynamicListIndex); 
   
 		insCell(tableName,dynamicListIndex,0,this.data[i].key );
 		insCell(tableName,dynamicListIndex,1,this.data[i].value );
 	     	    
 	    insCell(tableName,dynamicListIndex,2,this.data[i].type);
 	


	}
}

</script>
<LINK rel="stylesheet" href="<%=UIUtil.getCSSFile(jLocale)%>"
	type="text/css">
</head>

<body onLoad="loadPanelData()" CLASS="content">
<!--JSP File name :ppcPIExtendedData.jsp -->
<TABLE>
<TBODY>
<TR>
<td class="h1" height="40" valign="bottom" style="padding-left: 25px; padding-bottom: 20px;">
<%=UIUtil.toHTML((String) ppcLabels.get("PIExtendedData"))%></td>
</TR>
</TBODY>
</TABLE>
<SCRIPT>
	
	ListDatas.initializeDynamicList=initializeDynamicList;
	ListDatas.outputToDynamicList=outputToDynamicList;
</SCRIPT>
<TABLE ID="layoutTable" width=80%>

	<TR>
		<TD ALIGN="LEFT" VALIGN="TOP" COLSPAN=2></TD>
	</TR>
	<TR>
		<TD ALIGN="LEFT" VALIGN="TOP"><SCRIPT>ListDatas.initializeDynamicList('extdata');</SCRIPT></TD>		
	</TR>
</TABLE>
<SCRIPT>
	
	ListDatas.initializeDynamicList=initializeDynamicList;
	ListDatas.outputToDynamicList=outputToDynamicList;
	
<%
	while (iter.hasNext()) {
	String key = (String) iter.next();	
	String value = (hashData.get(key)).toString();
	
	if(protocolData.get(key) != null){
		value = protocolData.get(key).toString();
	}	
	short typeCode = extData.getType(key);
	
	//String type = getTypeStr(typeCode);
	
%>
	
	if(back !="back"){	
		ListDatas.data[<%=index%>]=new extData('<%=key%>','<%=UIUtil.toJavaScript(UIUtil.toHTML(value))%>',typesTranslated[<%=typeCode%>]);
		
	}
<% 
	index++; 
	}
%>	
	ListDatas.outputToDynamicList('extdata');
		
</SCRIPT>
</body>

</html>
