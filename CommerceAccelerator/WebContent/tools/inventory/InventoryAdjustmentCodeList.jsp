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
-->
<%@ page language="java" %>

<%@ page import="java.sql.*" %>
<%@ page import="com.ibm.commerce.beans.*" %>
<%@ page import="com.ibm.commerce.ras.*" %>
<%@ page import="com.ibm.commerce.tools.util.ResourceDirectory" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.tools.xml.*" %>
<%@ page import="com.ibm.commerce.inventory.beans.InventoryAdjustmentCodeDataBean" %>
<%@ page import="com.ibm.commerce.tools.common.ui.taglibs.*" %>
<%@ page import="com.ibm.commerce.tools.common.ui.*" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.server.JSPHelper" %>
<%@ page import="com.ibm.commerce.common.objects.StoreAccessBean" %>
<%@ include file="../common/common.jsp" %>


<jsp:useBean id="InventoryAdjustmentCodeList" scope="request"
	class="com.ibm.commerce.inventory.beans.InventoryAdjustmentCodeListDataBean">
</jsp:useBean>

<%
Hashtable vendorPurchaseListNLS = null;
InventoryAdjustmentCodeDataBean invAdjCodes[] = null;
int numberOfInvAdjCodes = 0;

CommandContext cmdContext =(CommandContext) request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);

Long userId = cmdContext.getUserId();
Locale localUsed = cmdContext.getLocale();

// obtain the resource bundle for display
vendorPurchaseListNLS =(Hashtable) ResourceDirectory.lookup("inventory.VendorPurchaseNLS", localUsed);

//yinjian modify
JSPHelper URLParameters	= new JSPHelper(request);
String actionPerformed	= URLParameters.getParameter("actionPerformed");

Integer store_id = cmdContext.getStoreId();
String storeId = store_id.toString();
InventoryAdjustmentCodeList.setStoreentId(storeId);

Integer langId = cmdContext.getLanguageId();
String strLangId = langId.toString();
InventoryAdjustmentCodeList.setLanguageId(strLangId);
DataBeanManager.activate(InventoryAdjustmentCodeList, request);

invAdjCodes = InventoryAdjustmentCodeList.getInventoryAdjustmentCodeList();

if (invAdjCodes != null) {
	numberOfInvAdjCodes = invAdjCodes.length;
}

StoreAccessBean sa = cmdContext.getStore();
String StoreType = sa.getStoreType();
if (StoreType == null) {
	StoreType = "";
}
%>


<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
<HTML>
<HEAD>
<SCRIPT SRC="/wcs/javascript/tools/common/dynamiclist.js"></SCRIPT>
<%=fHeader%>
<LINK rel="stylesheet" href="<%=UIUtil.getCSSFile(localUsed)%>" type="text/css">

<TITLE>
</TITLE>

<SCRIPT LANGUAGE="JavaScript">
function initialize() {    

	//parent.setContentFrameLoaded(false);
	<%
	if ((actionPerformed != null) && (!actionPerformed.equals("")) ) {
	%>
	
		alertDialog("<%= UIUtil.toJavaScript((String)vendorPurchaseListNLS.get("inventoryadjustcodeDeleteFinished")) %>");
		parent.generalForm.actionPerformed.value = "";
	<%
	}
	%>
}
function newInventoryAdjustmentCode()
{
  var url = "/webapp/wcs/tools/servlet/DialogView?XMLFile=inventory.InventoryAdjustmentCodeDetail";
  url += "&status=" + "new";
  url += "&invAdjCodeId=";
  if (top.setContent){
    top.setContent('<%=UIUtil.toJavaScript((String) vendorPurchaseListNLS.get("inventoryAdjustmentCodeDetailTitleNew"))%>', url, true);
  } else {
    parent.location.replace(url);
  }
}

function changeInventoryAdjustmentCode(rowId)
{
  if (rowId == null) {
    var rowNum = parent.getChecked();
    var tokens = rowNum[0].split(",");
    var invAdjCodeId = tokens[0];
  } else {
  var invAdjCodeId = rowId;
  } 
  var url = "/webapp/wcs/tools/servlet/DialogView?XMLFile=inventory.InventoryAdjustmentCodeDetailChange";
    url += "&status=" + "change";
    url += "&invAdjCodeId=" + invAdjCodeId;

  if (top.setContent){
    top.setContent('<%=UIUtil.toJavaScript((String) vendorPurchaseListNLS.get("inventoryAdjustmentCodeDetailTitleChange"))%>', url, true);
  } else {
    parent.location.replace(url);
  }

}

function deleteInventoryAdjustmentCode() 
{

  var checked = parent.getChecked();

  if (checked.length > 0) {
    //Set up the close list
    var invAdjCodeList = "";
    
    for (var i = 0; i< checked.length; i++) {
      var tokens = checked[i].split(",");
      var invAdjCodId = tokens[0];
      invAdjCodeList += "&invAdjCodId=" + invAdjCodId;
    }
      
    var confirmDelete = "<%=UIUtil.toJavaScript((String) vendorPurchaseListNLS.get("deleteInventoryAdjustmentCode"))%>";

    if (parent.confirmDialog(confirmDelete)) {
      //delete Inventory Adjustment Code
      var redirectURL = "<%="/webapp/wcs/tools/servlet/NewDynamicListView?cmd=InventoryAdjustmentCodeListView?ActionXMLFile=inventory.InventoryAdjustmentCodeList&amp;cmd=InventoryAdjustmentCodeListView"%>";
      var url = "/webapp/wcs/tools/servlet/InventoryAdjustmentCodeDelete?"+ invAdjCodeList ;
  		
      if (top.setContent) {
        top.showContent(url);
        top.refreshBCT();
       
      } else {
        parent.location.replace(url);      
      }
    }
  }

} 

function getResultsize()
{
 return <%=numberOfInvAdjCodes%>; 
}

function onLoad()
{
	initialize();
  	parent.loadFrames();
  
}

// -->
</script>

<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>

</HEAD>
<BODY ONLOAD="onLoad()" CLASS="content">

<%
int startIndex = Integer.parseInt(request.getParameter("startindex"));
int listSize = Integer.parseInt(request.getParameter("listsize"));
int endIndex = startIndex + listSize;
int rowselect = 1;
int totalsize = numberOfInvAdjCodes;
int totalpage = totalsize / listSize;
%>

<%=comm.addControlPanel("inventory.InventoryAdjustmentCodeList", totalpage, totalsize, localUsed)%>

<FORM NAME="inventoryAdjustmentCodeListForm">
<%=comm.startDlistTable((String) vendorPurchaseListNLS.get("vendorPurchaseTableSum"))%>
<%=comm.startDlistRowHeading()%>
<%-- //Checkbox row is automatically included --%> 
<%=comm.addDlistCheckHeading()%>
<%-- //BR 13MAR2001 These next few rows get the header name from the vendorPurchaseNLS file --%>
<%--//"VendorName should be the orderby variable  if orderbyParm = true, it sorts by this--%>
<%=comm.addDlistColumnHeading((String) vendorPurchaseListNLS.get("inventoryAdjustmentCodeName"), null, false)%>
<%=comm.addDlistColumnHeading((String) vendorPurchaseListNLS.get("inventoryAdjustmentCodeDescription"), null, false)%>
<%=comm.endDlistRow()%> 
<!-- Need to have a for loop to look for all the member groups -->
<%
InventoryAdjustmentCodeDataBean invAdjCode;

if (endIndex > numberOfInvAdjCodes) {
	endIndex = numberOfInvAdjCodes;
}

for (int i = startIndex; i < endIndex; i++) {
	invAdjCode = invAdjCodes[i];

	String invAdjCodName = invAdjCode.getAdjustCode();
	String invAdjCodDesc = invAdjCode.getDescription();
	if (invAdjCodDesc == null) {
		invAdjCodDesc = "";
	}
%> 
<%=comm.startDlistRow(rowselect)%>
<%=comm.addDlistCheck(invAdjCode.getInvAdjCodeId(), "none")%>
<%=comm.addDlistColumn(UIUtil.toHTML(invAdjCodName), "javascript:changeInventoryAdjustmentCode('" + invAdjCode.getInvAdjCodeId() + "');")%> 
<%=comm.addDlistColumn(UIUtil.toHTML(invAdjCodDesc), "none")%>
<%=comm.endDlistRow()%>
<%if (rowselect == 1) { rowselect = 2; } else { rowselect = 1;}%> 
<%}%> 

<%=comm.endDlistTable()%> 

<%if (numberOfInvAdjCodes == 0) {%> 
<SCRIPT>
  document.writeln('<P>');
  document.writeln('<%=UIUtil.toJavaScript(vendorPurchaseListNLS.get("inventoryAdjustmentCodeNoRows"))%>');
</SCRIPT> 
<%}%>

</FORM>

<SCRIPT>
  parent.afterLoads();
  parent.setResultssize(getResultsize());
</SCRIPT>

</BODY>
</HTML>
