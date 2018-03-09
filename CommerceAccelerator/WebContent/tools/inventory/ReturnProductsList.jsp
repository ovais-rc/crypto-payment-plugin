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
<!-- This Program is for Returned Products -->

<%@ page language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="com.ibm.commerce.server.ECConstants" %>
<%@ page import="com.ibm.commerce.common.beans.StoreEntityDataBean" %>
<%@ page import="com.ibm.commerce.beans.DataBeanManager" %>
<%@ page import="com.ibm.commerce.tools.util.ResourceDirectory" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.tools.xml.*" %>
<%@ page import="com.ibm.commerce.ordermanagement.beans.*" %>
<%@ page import="com.ibm.commerce.ordermanagement.objects.*" %>
<%@ page import="com.ibm.commerce.ordermanagement.beans.ReturnedProductsDataBean" %>
<%@ page import="com.ibm.commerce.tools.common.ui.taglibs.*" %>
<%@ page import="com.ibm.commerce.tools.command.*" %>
<%@ page import="com.ibm.commerce.datatype.TypedProperty" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.server.JSPHelper" %>
<%@ page import="com.ibm.commerce.utils.TimestampHelper" %>
<%@ include file="../common/common.jsp" %>

<jsp:useBean id="returnop4List" scope="request" 
class="com.ibm.commerce.ordermanagement.beans.ReturnedProductsListDataBean">

</jsp:useBean>

<%
   Hashtable 	VendorPurchaseNLS_en_US = null;
   ReturnedProductsDataBean returnPOs[] = null; 
   int 	numberOfreturnPOs = 0; 

   CommandContext cmdContext = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
   Long 	userId     = cmdContext.getUserId();
   Locale 	localeUsed = cmdContext.getLocale();

   // obtain the resource bundle for display. This is where the NLS file is linked to a variable of type hashtable..
   VendorPurchaseNLS_en_US= (Hashtable)ResourceDirectory.lookup("inventory.VendorPurchaseNLS", localeUsed);
              
       Integer 	langId    = cmdContext.getLanguageId();
       String  	strLangId = langId.toString(); 
       returnop4List.setDataBeanKeyLanguageId(strLangId);

       Integer 	store_id = cmdContext.getStoreId();
       String 	storeId  = store_id.toString(); 
       String rmaid = request.getParameter("rmaid");
        
   
       //returnopList.setStoreentId(storeId); 

       // Rmaid is also required to set returnop4List before activating DataBeanManager
       returnop4List.setDataBeanKeyRmaId(rmaid);

       DataBeanManager.activate(returnop4List, request);
       
       returnPOs = returnop4List.getReturnedProductsList();
        

  
   if (returnPOs != null)
   {
     numberOfreturnPOs = returnPOs.length;
   }
 

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
<HTML>
<HEAD>
<%= fHeader%>

<LINK rel="stylesheet" href="<%= UIUtil.getCSSFile(localeUsed) %>" type="text/css">
<TITLE></TITLE>

<SCRIPT LANGUAGE="JavaScript">

    function onLoad()
    {
      parent.loadFrames()
    }
    function disableButton(b) {
		b.disabled=false;
		b.className='disabled';
		b.id='disabled';
	                      }

	
       function isButtonDisabled(b) {
		if (b.className =='disabled' &&	b.id == 'disabled')
			return true;
		return false;
	                        }
function check1() {
    
    var tokens = parent.getSelected().split(",");
    var ReceiptID = tokens[0];
    var QtytoDisposition = tokens[1]; 
     
    if(QtytoDisposition ==0){
     disableBut(parent.buttons.buttonForm.DispositionButton);
     return;
     }
       
      return ;
                }

	
function disableBut(but){
but.className='disabled';
                      }
function enableBut(but){
but.className='enabled';
                      }

    function viewDisposition()
    {
        if (parent.buttons.buttonForm.DispositionButton.className !='disabled') {
	var tokens = parent.getSelected().split(",");
	var receiptId = tokens[0];	
	var RMA = '<%=UIUtil.toJavaScript(rmaid)%>';

        var url="/webapp/wcs/tools/servlet/DialogView?XMLFile=inventory.DispositionDialog";
        url += "&receiptId=" + receiptId + "&rmaId=" + RMA;     
          	
        if (top.setContent)
        {
          top.setContent('<%=UIUtil.toJavaScript((String)VendorPurchaseNLS_en_US.get("Disposition"))%>',
                                 url,
                                 true);

        }else{
          parent.location.replace(url);
        }
                                             }
     }


    function getResultSize () {
	return <%= numberOfreturnPOs %>;
    }


</SCRIPT>

<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/common/dynamiclist.js"></SCRIPT>

</HEAD>
<BODY ONLOAD="onLoad()" CLASS="content_list">
<%
          int startIndex = Integer.parseInt(request.getParameter("startindex"));
          int listSize = Integer.parseInt(request.getParameter("listsize"));
          int endIndex = startIndex + listSize;
          int rowselect = 1;
          int totalsize = numberOfreturnPOs;
          int totalpage = totalsize/listSize;
%>
<%=comm.addControlPanel("inventory.ReturnProductsList", totalpage, totalsize, localeUsed )%>

<FORM NAME="ReturnedProductsListScreenTitle">

<%=comm.startDlistTable((String)VendorPurchaseNLS_en_US.get("ReturnRecordsTableSum")) %>
<%= comm.startDlistRowHeading() %>
<%=comm.addDlistCheckHeading()%>

<%= comm.addDlistColumnHeading((String)VendorPurchaseNLS_en_US.get("ProductName"), null, false )%>
<%= comm.addDlistColumnHeading((String)VendorPurchaseNLS_en_US.get("SKU"), null, false  )%>
<%= comm.addDlistColumnHeading((String)VendorPurchaseNLS_en_US.get("QuantityReceived"), null, false )%>
<%= comm.addDlistColumnHeading((String)VendorPurchaseNLS_en_US.get("QuantityToDisposition"), null, false )%>
<%= comm.addDlistColumnHeading((String)VendorPurchaseNLS_en_US.get("DateReceived"), null, false )%>

<%= comm.endDlistRow() %>


<!-- Need to have a for loop to look for all the member groups -->

   <% ReturnedProductsDataBean returnPO;
  
    if (endIndex > numberOfreturnPOs ){
      endIndex = numberOfreturnPOs;
                                     }
     
    for (int i=startIndex; i<endIndex ; i++){
      returnPO = returnPOs[i];
      String ProductName = returnPO.getDataBeanKeyShortDescription();
      
      if (ProductName == null){
        ProductName = "";
                              }
                              
      String SKU = returnPO.getDataBeanKeyPartNumber();
      if (SKU == null) {
          SKU = "";
                       }
                       
      String QtyReceived = returnPO.getDataBeanKeyTotalQuantity();
       if(QtyReceived == null) {
          QtyReceived = "";
                               }
      String QtytoDisposition = returnPO.getDataBeanKeyNonDispositionQuantity();
       if (QtytoDisposition == null)
                      {
           QtytoDisposition="";
                      }
      String ReceiptID = returnPO.getDataBeanKeyReceiptId();
       if(ReceiptID == null) {
        ReceiptID = "";
                             }
                  

      String DateReceived = returnPO.getDataBeanKeyDateReceived();
      String formattedOrderDate = null;
      if (DateReceived == null){
         formattedOrderDate = "";
                               }
          else {
         Timestamp tmp_orderDate = Timestamp.valueOf(DateReceived);
         formattedOrderDate = TimestampHelper.getDateFromTimestamp(tmp_orderDate, localeUsed );
	        }
         %>
       

<%=  comm.startDlistRow(rowselect) %>


<!-- %= comm.addDlistCheck(ReceiptID, "none" ) % -->
<%= comm.addDlistCheck(ReceiptID + "," +  returnPO.getDataBeanKeyNonDispositionQuantity(),"parent.setChecked();check1();" ) %>

<%= comm.addDlistColumn( ProductName, "none" ) %> 
<%= comm.addDlistColumn( SKU, "none" ) %> 
<%= comm.addDlistColumn( QtyReceived, "none" ) %> 
<%= comm.addDlistColumn(QtytoDisposition, "none" ) %> 
<%= comm.addDlistColumn(formattedOrderDate , "none" ) %> 

<%= comm.endDlistRow() %>

<%
if(rowselect==1)
   {
     rowselect = 2;
   }else{
     rowselect = 1;
   }
%>

<%
}
%>
<%= comm.endDlistTable() %>

<%
   if ( numberOfreturnPOs == 0 ){
%>
<br>
<%=UIUtil.toHTML((String)VendorPurchaseNLS_en_US.get("NoProductRows")) %>
<%
   }
%>

</FORM>
<SCRIPT LANGUAGE="JavaScript">
 parent.afterLoads();
 parent.setResultssize(getResultSize());
</SCRIPT>
</BODY>
</HTML>
