<%--==========================================================================
Licensed Materials - Property of IBM

WebSphere Commerce

(c) Copyright IBM Corp.  2006, 2016
All Rights Reserved

US Government Users Restricted Rights - Use, duplication or
disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
===========================================================================--%>



<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%
//---------------------------------------------------------------------
//- Import and Include Section
//---------------------------------------------------------------------
%>

<%@ page language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="java.math.*" %>
<%@ page import="com.ibm.commerce.ras.*" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.server.*" %>
<%@ page import="com.ibm.commerce.tools.common.ui.taglibs.*" %>
<%@ page import="com.ibm.commerce.utils.TimestampHelper" %>
<%@ page import="com.ibm.commerce.server.ECConstants" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.tools.util.UIUtil" %>
<%@ page import="com.ibm.commerce.ordermanagement.objects.RMAItemAccessBean" %>
<%@ page import="com.ibm.commerce.ordermanagement.objects.RMAItemComponentAccessBean" %>
<%@ page import="com.ibm.commerce.ordermanagement.beans.RMAItemDataBean" %>
<%@ page import="com.ibm.commerce.ordermanagement.beans.RMAItemComponentListDataBean" %>
<%@ page import="com.ibm.commerce.fulfillment.beans.OrderSerialNumbersDataBean" %>
<%@ page import="com.ibm.commerce.ordermanagement.beans.RMASerialNumbersDataBean" %>
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

// obtain the resource bundle for display
CommandContext cmdContextLocale = (CommandContext) request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
Locale jLocale = cmdContextLocale.getLocale();
Integer langId = cmdContextLocale.getLanguageId();
Integer storeId = cmdContextLocale.getStoreId();
String currency = cmdContextLocale.getCurrency();
Hashtable returnsNLS = (Hashtable)ResourceDirectory.lookup("returns.ReturnsNLS", jLocale);

JSPHelper jspHelper = new JSPHelper(request);
String returnId = jspHelper.getParameter("returnId");
String rmaItemId = jspHelper.getParameter("rmaItemId");
String itemComId = jspHelper.getParameter("itemCompId");

if (rmaItemId == null){
// for kit
    RMAItemComponentAccessBean rmaItemCmpAB = new RMAItemComponentAccessBean();
    rmaItemCmpAB.setInitKey_rmaItemCmpId(itemComId);
    rmaItemId = rmaItemCmpAB.getRmaItemId();
}	

RMAItemAccessBean abRMAItem = new RMAItemAccessBean();
abRMAItem.setInitKey_rmaItemId(rmaItemId);
String orderItemId = abRMAItem.getOrderItemsId();
String customerId = abRMAItem.getMemberId();


		
if(returnId!=null && returnId.length()!=0){
	returnId = abRMAItem.getRmaId();
}

ArrayList rmaSerialNums = new ArrayList();
ArrayList orderSerialNums = new ArrayList();

com.ibm.commerce.order.beans.OrderItemDataBean anOrderItem = new com.ibm.commerce.order.beans.OrderItemDataBean();
if (orderItemId !=null && !orderItemId.equalsIgnoreCase("")) {
	anOrderItem.setOrderItemId(orderItemId);
	com.ibm.commerce.beans.DataBeanManager.activate(anOrderItem, request);
}
RMAItemDataBean anRMAItem = new RMAItemDataBean();
anRMAItem.setRmaItemId(rmaItemId);
com.ibm.commerce.beans.DataBeanManager.activate(anRMAItem, request);

OrderSerialNumbersDataBean [] orderSNDBs = null;
RMASerialNumbersDataBean [] rmaSNDBs = null;


if (rmaItemId != null && (itemComId == null || itemComId.trim().length()==0)){
// not a kit
	if (orderItemId !=null && !orderItemId.equalsIgnoreCase("")) {
	    orderSNDBs = anOrderItem.getSerialNumbersForOrderItem();
	}    
    rmaSNDBs   = anRMAItem.getRmaSerialNumbersDataBeansForRMAItem();
}else{
	OrderSerialNumbersDataBean [] cmpOrderSNs =null;
	if (orderItemId !=null && !orderItemId.equalsIgnoreCase("")) {
    	cmpOrderSNs = anOrderItem.getSerialNumbersForComponents();
    }
    com.ibm.commerce.ordermanagement.beans.RMAItemComponentDataBean anRMAItemCmpDB = new com.ibm.commerce.ordermanagement.beans.RMAItemComponentDataBean();
    anRMAItemCmpDB.setDataBeanKeyRmaItemCmpId(itemComId);
    com.ibm.commerce.beans.DataBeanManager.activate(anRMAItemCmpDB, request);
    Long catentryId = anRMAItemCmpDB.getCatentryIdInEntityType();
    List aSNOICmp = new ArrayList();
    Long orditemCmpId = null;
    if (orderItemId !=null && !orderItemId.equalsIgnoreCase("")) {
    	for (int k = 0; k < cmpOrderSNs.length; k++){
        
        	orditemCmpId = cmpOrderSNs[k].getOrderItemCompListId();
        	if (orditemCmpId != null){
            	com.ibm.commerce.order.objects.OrderItemComponentAccessBean anOrderItemCmpAB = new com.ibm.commerce.order.objects.OrderItemComponentAccessBean();
	            anOrderItemCmpAB.setInitKey_orderItemComponentId(orditemCmpId.toString());
    	        if (anOrderItemCmpAB.getCatalogEntryIdInEntityType().equals(catentryId)){
        	        aSNOICmp.add(cmpOrderSNs[k]);
            	}
       		}
        
    	}
    	orderSNDBs = (OrderSerialNumbersDataBean [])aSNOICmp.toArray(new OrderSerialNumbersDataBean[0]);
    }
    rmaSNDBs = anRMAItemCmpDB.getRmaSerialNumbersDataBeans();
}
if ( rmaSNDBs != null){
    for (int i = 0; i < rmaSNDBs.length; i++){
        if (!rmaSerialNums.contains(rmaSNDBs[i].getSerialNumber())){
            rmaSerialNums.add(rmaSNDBs[i].getSerialNumber());
        }
    }
}

if ( orderSNDBs != null){
    for (int i = 0; i < orderSNDBs.length; i++){
        if (!orderSerialNums.contains(orderSNDBs[i].getSerialNumber())){
            orderSerialNums.add(orderSNDBs[i].getSerialNumber());
        }
    }
}

%>
<html>
<head>

<style type='text/css'>.selectWidth {width: 200px;}</style>
<link rel="stylesheet" href="<%=UIUtil.getCSSFile(jLocale)%>"
	type="text/css" />
<title><%= UIUtil.toHTML((String)returnsNLS.get("returnSNTitle")) %></title>

<script src="/wcs/javascript/tools/common/Util.js"></script>
<script src="/wcs/javascript/tools/common/SwapList.js"></script>
<script language="JavaScript" type="text/javascript">
//---------------------------------------------------------------------
//  Required javascript function for dynamic list
//---------------------------------------------------------------------

function replace(fromList,toList) {

  for(var i=0; i<fromList.options.length; i++) {
    if(fromList.options[i].selected && fromList.options[i].value != "") {
       var no = new Option();
       no.value = fromList.options[i].value;
       no.text = fromList.options[i].text;
       toList.options[toList.options.length] = no;
    }
  }
  
  for(var i=fromList.options.length-1; i>=0; i--) {
    if(fromList.options[i].selected) {
    	if(toList.length==1){
    		fromList.options[i]=null;
    	}else if(toList.length==2){

    	  	var no = new Option();
       		no.value = toList.options[0].value;
       		no.text = toList.options[0].text;
       		fromList.options[i] = no;
       		
       		toList.options[0]=null;
       		
    		
    	}
    }
  }
  
  
  // Refresh to correct for bug in IE5.5 in list box
  // If more than the list box's displayable contents are moved, a phantom
  // line appears.  This refresh corrects the problem.
  for (var i=fromList.options.length-1; i>=0; i--) {
    if(fromList.options.length!=0) {
      fromList.options[i].selected = true;
    }
  }
  for (var i=fromList.options.length-1; i>=0; i--) {
    if(fromList.options.length!=0) {
      fromList.options[i].selected = false;
    }
  }
}

function addToSelectedCollateral() {
	move(document.configMethodForm.serialNumbersAvail, document.configMethodForm.serialNumbersSeleted);
    updateSloshBuckets(document.configMethodForm.serialNumbersAvail, document.configMethodForm.addToSloshBucketButton, document.configMethodForm.serialNumbersSeleted, document.configMethodForm.removeFromSloshBucketButton);
    
}

function removeFromSelectedCollateral() {
   move(document.configMethodForm.serialNumbersSeleted, document.configMethodForm.serialNumbersAvail);
   updateSloshBuckets(document.configMethodForm.serialNumbersSeleted, document.configMethodForm.removeFromSloshBucketButton, document.configMethodForm.serialNumbersAvail, document.configMethodForm.addToSloshBucketButton);
}

function loadPanelData () {
	initializeSloshBuckets(document.configMethodForm.serialNumbersAvail, document.configMethodForm.removeFromSloshBucketButton, document.configMethodForm.serialNumbersSeleted, document.configMethodForm.addToSloshBucketButton);
    parent.setContentFrameLoaded(true);
}

function validatePanelData () {
	return true;
}

function savePanelData(){
    
    return true;
}

function updateAction(){
	
     var rmacom=new Array();
         
	if (document.configMethodForm.serialNumbersSeleted.options.length > 0){
	    for (var i = 0; i < document.configMethodForm.serialNumbersSeleted.options.length; i++) {
	           var tempcom=new Object();	
	            <%if(itemComId!=null && itemComId.length()!=0){%>
		    	tempcom.returnItemComponentId = "<%=itemComId%>";
		    <%}else{%>
		        tempcom.RMAItemId = "<%=rmaItemId%>";
		    <%}%>
		        tempcom.serialNumber = configMethodForm.serialNumbersSeleted.options[i].value;
	           	rmacom[i] = tempcom;
	    }
	}else{
		var tempcom=new Object();
		<%if(itemComId!=null && itemComId.length()!=0){%>
		tempcom.returnItemComponentId = "<%=itemComId%>";
		<%}else{%>
		tempcom.RMAItemId = "<%=rmaItemId%>";
		<%}%>
		
		rmacom[0] = tempcom;
	}
		     
	 if (parent.setContentFrameLoaded) {
	   parent.setContentFrameLoaded(true);
	}
	 // save parent "model" to TOP frame before call
	    top.saveModel(parent.model);
	   
	 parent.put("customerId","<%= customerId %>");
	 	 
	 parent.remove("itemCompId");
	 parent.remove("returnId");
	 parent.remove("rmaItemId");
	 parent.put("returnItemComponent",rmacom); 
	var xmlObject = parent.modelToXML("XML");
	document.callActionForm.action="CSRReturnItemComponentUpdate";
	document.callActionForm.XML.value=xmlObject;
	document.callActionForm.URL.value="/webapp/wcs/tools/servlet/RMASerialNumberRedirect";
	document.callActionForm.submit();
	
}

function addSerialNumber(){
    var sn = document.configMethodForm.serialNumber.value;
    if (sn != null || sn != ""){
       for (var i = 0; i < document.configMethodForm.serialNumbersSeleted.options.length; i++) {
		 if (sn == configMethodForm.serialNumbersSeleted.options[i].value) {
		    return;
		 }
	   }
	   var no = new Option();
       no.value = sn;
       no.text = sn;
       document.configMethodForm.serialNumbersSeleted.options[document.configMethodForm.serialNumbersSeleted.options.length] = no;
    }
    document.configMethodForm.serialNumber.value="";
    document.configMethodForm.updateBtn.disabled= true;
}
function snChanged(){
    document.configMethodForm.updateBtn.disabled= false;
}
</script>
</head>

<body onload="loadPanelData()" class="content">

<FORM NAME="callActionForm" action="" method="POST">
    <INPUT type="hidden" name="XML" value="">
    <INPUT type="hidden" name="URL" value="">
    <input type='hidden' name="SNdelete" value="true">
</FORM>

<form name="configMethodForm">
<table>
    <tbody>
    <tr>
    <td colspan="3">
    <br/>
    <br/>
    </td>
    </tr>
	
		<tr>
			<td valign="bottom" class="selectWidth">
			<label for="serialNumbersAvail1"><%= UIUtil.toHTML((String)returnsNLS.get("SNAvailable")) %></label><br/>
			<select	name="serialNumbersAvail" class='selectWidth' size='10'  MULTIPLE id="serialNumbersAvail1"
				onchange="updateSloshBuckets(this, document.configMethodForm.addToSloshBucketButton, document.configMethodForm.serialNumbersSeleted, document.configMethodForm.removeFromSloshBucketButton);">
<%
     for (int j = 0; j < orderSerialNums.size(); j++)
     {
     	boolean found = false;
		for(int i=0; i<rmaSerialNums.size(); i++){
			if(rmaSerialNums.get(i).equals(orderSerialNums.get(j))){
				found = true;
				continue;
			}
		}
		if( !found ){
%>
     <option value="<%= orderSerialNums.get(j) %>"><%= orderSerialNums.get(j) %></option>
<%
			
		}
     }
%>
			</select>
			</td>
			
			<td width=150px align="center">
			<br/>
			
			<input type="button" name="addToSloshBucketButton"
				value="<%= UIUtil.toHTML((String)returnsNLS.get("SNAdd")) %>" 
				onclick="addToSelectedCollateral();" /><br>			
			<input type="button" name="removeFromSloshBucketButton"
				value="<%= UIUtil.toHTML((String)returnsNLS.get("SNRemove")) %>"
				onclick="removeFromSelectedCollateral();" /><br>
			</td>
			
			<td valign="bottom" class="selectWidth">
			<label for="serialNumbersSeleted1"><%= UIUtil.toHTML((String)returnsNLS.get("selectedSNs")) %></label><br/>
			<select	name="serialNumbersSeleted"  class='selectWidth' size='10' MULTIPLE id="serialNumbersSeleted1" 
				onchange="updateSloshBuckets(this, document.configMethodForm.removeFromSloshBucketButton, document.configMethodForm.serialNumbersAvail, document.configMethodForm.addToSloshBucketButton);">
	<%
 	for(int i=0;i<rmaSerialNums.size() ; i++){
	%>
     <option value="<%= rmaSerialNums.get(i) %>"><%= rmaSerialNums.get(i) %></option>
	<%
			
     }
%>
			</select>
			</td>
		</tr>
	<tr> </tr>
	<tr>
	   <td> 
	      <label for="serialNumbersAdd1"><%= UIUtil.toHTML((String)returnsNLS.get("serialNumberAdd")) %></label><br/> 
	      
	   </td>
	</tr>
	<tr>
	   <td>
	      <input size="26" type="text" maxlength="64" id="serialNumbersAdd1" name="serialNumber" onKeyUp="snChanged()" value="" />
	   </td>
	
	   <td width=150px align="center" >
	      <button id="contentButton" name="updateBtn" onclick="addSerialNumber();" disabled="disabled"><%=UIUtil.toHTML(returnsNLS.get("serialNumberAddBtn").toString())%></button>
	   </td>
	</tr>
	</tbody>
</table>
</form>
</body>
</html>
