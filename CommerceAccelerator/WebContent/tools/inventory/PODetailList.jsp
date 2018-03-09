<%@ page language="java" %>

<%@ page import="com.ibm.commerce.beans.DataBeanManager" %>
<%@ page import="com.ibm.commerce.tools.util.ResourceDirectory" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.tools.xml.*" %>
<%@ page import="com.ibm.commerce.inventory.beans.ExpectedInventoryRecordDetailDataBean" %>
<%@ page import="com.ibm.commerce.tools.common.ui.taglibs.*" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.server.JSPHelper" %>
<%@ page import="com.ibm.commerce.utils.TimestampHelper" %>
<%@ page import="com.ibm.commerce.tools.util.UIUtil" %>
<%@ include file="../common/common.jsp" %>


<jsp:useBean id="vendorDetailList" scope="request" class="com.ibm.commerce.inventory.beans.ExpectedInventoryRecordDetailListDataBean">
</jsp:useBean>

<%
   Hashtable vendorPurchaseListNLS = null;
   
   ExpectedInventoryRecordDetailDataBean vendorPOs[] = null; 
   int numberOfvendorPOs = 0; 

   CommandContext cmdContext = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
   Long userId = cmdContext.getUserId();
   Locale localUsed = cmdContext.getLocale();

   // obtain the resource bundle for display
   vendorPurchaseListNLS = (Hashtable)ResourceDirectory.lookup("inventory.VendorPurchaseNLS", localUsed  );

 
  
  Integer langId = cmdContext.getLanguageId();
  String strLangId = langId.toString(); 
  
  
  
  String strVendorId = request.getParameter("vendorId");
  strVendorId = UIUtil.toHTML(strVendorId);
  String strRaId = request.getParameter("raId"); 
  
  vendorDetailList.setLanguageId(strLangId);     
  vendorDetailList.setRaId(strRaId);
   
   DataBeanManager.activate(vendorDetailList, request);
   vendorPOs = vendorDetailList.getExpectedInventoryRecordDetailList();



   if (vendorPOs != null)
   {
     numberOfvendorPOs = vendorPOs.length;
   }
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2001, 2014 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<HTML>
<HEAD>
<%= fHeader%>
<LINK rel="stylesheet" href="<%= UIUtil.getCSSFile(localUsed) %>" type="text/css">
<TITLE></TITLE>

<SCRIPT LANGUAGE="JavaScript">
<!---- hide script from old browsers
function getResultsize(){
     return <%=numberOfvendorPOs%>; 
}
    
    
    
    function receivedInventoryDetailList()
              {
                
                var tokens = parent.getSelected().split(",");
		var raDetailId = tokens[0];

                var url="/webapp/wcs/tools/servlet/DialogView?XMLFile=inventory.POReceivedInventoryDetailListInterim";
          	url += "&raDetailId=" + raDetailId;
          	
          	
                if (top.setContent)
                {
                  top.setContent('<%=UIUtil.toJavaScript((String)vendorPurchaseListNLS.get("receivedInventory"))%>',
                                 url,
                                 true);
                }
                else
                {
                  parent.location.replace(url);
                }
                  
              }
  	          
      
      
       function receiveInventoryDialog(rowId)
              {
               var urlParams = new Object();
               
               if(rowId == null){  
		var tokens = parent.getSelected().split(",");
		var raDetailId = tokens[0];
		var uOM = tokens[1];
                var ffmcenterId = tokens[2];
                var itemSpcId = tokens[3];
                var received =  tokens[4];
               
                }else{
                var valueArray = rowId.split(",");
		var itemSpcId  = valueArray[0];
		var ffmcenterId = valueArray[1];
		var raDetailId = valueArray[2];
                var uOM =  valueArray[3];
                var received =  valueArray[4];
                }
                
                                
                urlParams.uOM=uOM;
                urlParams.itemSpcId=itemSpcId;
                urlParams.ffmcenterId=ffmcenterId;
                urlParams.raDetailId=raDetailId;
                urlParams.vendorId=<%=(strVendorId == null ? null : UIUtil.toJavaScript(strVendorId))%>;
                urlParams.received=received;
                
              
                var url="/webapp/wcs/tools/servlet/DialogView?XMLFile=inventory.POReceiveInventoryDialog";
          	
          	
                if (top.setContent)
                {
                  top.setContent('<%=UIUtil.toJavaScript((String)vendorPurchaseListNLS.get("receiveInventory"))%>',
                                 url,
                                 true, urlParams);
                }
                else
                {
                  parent.location.replace(url);
                }
                
           }
        
    function onLoad()
    {
      parent.loadFrames()
    }

// -->
</script>

<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/common/dynamiclist.js"></SCRIPT>

</HEAD>

<BODY onload="onLoad()"CLASS="content">



<%
          int startIndex = Integer.parseInt(request.getParameter("startindex"));
          int listSize = Integer.parseInt(request.getParameter("listsize"));
          int endIndex = startIndex + listSize;
          int rowselect = 1;
          int totalsize = numberOfvendorPOs;
          int totalpage = totalsize/listSize;
%>

 
 


<%-- // Building Menu  --%>
<%=comm.addControlPanel("inventory.VendorPurchase",totalpage,totalsize, localUsed)%>


<FORM NAME="vendorPOForm">

<%=comm.startDlistTable((String)vendorPurchaseListNLS.get("expectedInventoryDetails")) %>

<%= comm.startDlistRowHeading() %>
<%= comm.addDlistCheckHeading() %>
<%-- //Checkbox row is automatically included --%>   

<%-- //AF 3APRIL2001 These next few rows get the header name from the vendorPurchaseNLS file --%>

<%= comm.addDlistColumnHeading((String)vendorPurchaseListNLS.get("sku"), null, false  )%>
<%= comm.addDlistColumnHeading((String)vendorPurchaseListNLS.get("pofulfillmentCenter"), null, false )%>
<%= comm.addDlistColumnHeading((String)vendorPurchaseListNLS.get("itemDescription"), null, false )%>
<%= comm.addDlistColumnHeading((String)vendorPurchaseListNLS.get("unitofmeasure"), null, false )%>
<%= comm.addDlistColumnHeading((String)vendorPurchaseListNLS.get("qtyOrdered"), null, false )%>
<%= comm.addDlistColumnHeading((String)vendorPurchaseListNLS.get("qtyReceived"), null, false )%>   
<%= comm.addDlistColumnHeading((String)vendorPurchaseListNLS.get("qtyRemaining"), null, false )%>

<%= comm.endDlistRow() %>


<!-- Need to have a for loop to look for all the member groups -->
<%
    ExpectedInventoryRecordDetailDataBean vendorPO;
  
    if (endIndex > numberOfvendorPOs)
      {endIndex = numberOfvendorPOs;
      }

    for (int i=startIndex; i<endIndex ; i++) 
    {
      vendorPO = vendorPOs[i];


      
%>

<%=  comm.startDlistRow(rowselect) %>

<!-- CheckBox column added-->
<%= comm.addDlistCheck(vendorPO.getRaDetailId() + ","  + vendorPO.getQtyDescription()+ "," + vendorPO.getFfmCenterId()+ "," + vendorPO.getItemSpcId()+ "," + vendorPO.getQtyReceived(),"none" ) %>

<%= comm.addDlistColumn( UIUtil.toHTML(vendorPO.getPartNumber()), "javascript:receiveInventoryDialog('"+vendorPO.getItemSpcId()+"," + vendorPO.getFfmCenterId()+ "," + vendorPO.getRaDetailId()+ "," + vendorPO.getQtyDescription()+ "," + vendorPO.getQtyReceived()+"');" ) %> 

<%= comm.addDlistColumn( UIUtil.toHTML(vendorPO.getDisplayName()), "none" ) %> 

<%= comm.addDlistColumn( UIUtil.toHTML(vendorPO.getShortDescription()), "none" ) %> 

<%= comm.addDlistColumn( UIUtil.toHTML(vendorPO.getQtyDescription()), "none" ) %> 

<%= comm.addDlistColumn( UIUtil.toHTML(vendorPO.getQtyOrdered()), "none" ) %> 

<%= comm.addDlistColumn( UIUtil.toHTML(vendorPO.getQtyReceived()), "none" ) %> 

<%= comm.addDlistColumn( UIUtil.toHTML(vendorPO.getQtyRemaining()), "none" ) %> 


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
   if ( numberOfvendorPOs == 0 ){
%>
<br>
<%= UIUtil.toHTML((String)vendorPurchaseListNLS.get("vendorPurchaseDetailsNoRows")) %>
<%
   }
%>


</FORM>
<SCRIPT>
  parent.afterLoads();
  parent.setResultssize(getResultsize());
  </SCRIPT>

</BODY>
</HTML>
