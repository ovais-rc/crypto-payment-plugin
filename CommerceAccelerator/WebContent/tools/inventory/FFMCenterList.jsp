<!--      
//BR updated 20020225 - 1344
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2001, 2016
//*
//* US Government Users Restricted Rights - Use, duplication or 
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
-->
<%@ page language="java" %>
<%@ page import="java.sql.*" %> 
<%@ page import="com.ibm.commerce.beans.DataBeanManager" %>
<%@ page import="com.ibm.commerce.tools.util.ResourceDirectory" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.tools.xml.*" %>
<%@ page import="com.ibm.commerce.common.beans.StoreDataBean" %>
<%@ page import="com.ibm.commerce.fulfillment.beans.FFMOrderItemsDataBean" %>
<%@ page import="com.ibm.commerce.fulfillment.beans.FulfillmentCenterDataBean" %>
<%@ page import="com.ibm.commerce.tools.common.ui.taglibs.*" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %> 
<%@ page import="com.ibm.commerce.server.JSPHelper" %>
<%@ page import="com.ibm.commerce.utils.TimestampHelper" %>
<%@ include file="../common/common.jsp" %>


<jsp:useBean id="ffmCenterListBean" scope="request" class="com.ibm.commerce.fulfillment.beans.FFMOrderItemsListDataBean">
</jsp:useBean>


<%
   Hashtable ffmCenterListNLS = null;
   FFMOrderItemsDataBean ffmCenters[] = null; 
   int numberOfffmCenters = 0; 

   CommandContext cmdContext = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
   Long userId = cmdContext.getUserId();
   Locale localeUsed = cmdContext.getLocale();

   // obtain the resource bundle for display
   ffmCenterListNLS = (Hashtable)ResourceDirectory.lookup("inventory.FFMCenterNLS", localeUsed   );

   Integer store_id = cmdContext.getStoreId();
   String storeId = store_id.toString(); 


   StoreDataBean  storeBean = new StoreDataBean();
   storeBean.setStoreId(storeId.toString());
   com.ibm.commerce.beans.DataBeanManager.activate(storeBean, request);

   Integer langId = cmdContext.getLanguageId();
   String strLangId = langId.toString(); 
   ffmCenterListBean.setDataBeanKeyLanguageId(strLangId);

   ffmCenterListBean.setDataBeanKeyStoreentId(storeId);
   DataBeanManager.activate(ffmCenterListBean, request);
   ffmCenters = ffmCenterListBean.getFFMOrderItemsList();

   if (ffmCenters != null)  
   {
     numberOfffmCenters = ffmCenters.length;
   }
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
<HTML>
<HEAD>
<SCRIPT SRC="/wcs/javascript/tools/common/dynamiclist.js"></SCRIPT>
<%= fHeader%>
<LINK rel="stylesheet" href="<%= UIUtil.getCSSFile(localeUsed) %>" type="text/css">
<TITLE></TITLE>

<SCRIPT LANGUAGE="JavaScript">
<!---- hide script from old browsers
    function getResultsize(){
     return <%=numberOfffmCenters%>; 
    }
			     
   function newFFMCenter(){
     var title = '<%=UIUtil.toJavaScript((String)ffmCenterListNLS.get("ffmCenterNewTitle"))%>' ;
     var url = "/webapp/wcs/tools/servlet/DialogView?XMLFile=inventory.FFMCenterDialog";
     url += "&status=" +  "new";
      if (top.setContent){
        top.setContent('<%=UIUtil.toJavaScript((String)ffmCenterListNLS.get("ffmCenterNewTitle"))%>',
                        url,
                        true);
      }else{
        parent.location.replace(url);
      }
      top.saveData(title, "title");
    
    }

    function changeFFMCenter(ffcId){
      var title = '<%=UIUtil.toJavaScript((String)ffmCenterListNLS.get("ffmCenterChangeTitle"))%>' ;
      var url = "/webapp/wcs/tools/servlet/DialogView?XMLFile=inventory.FFMCenterChangeDialog";
      if (ffcId == null){
       var tokens = parent.getSelected().split(",");
       ffcId = tokens[0];
      }
      url += "&ffmID=" + ffcId ; 
      url += "&status=" +  "change";
      if (top.setContent){
        top.setContent('<%=UIUtil.toJavaScript((String)ffmCenterListNLS.get("ffmCenterChangeTitle"))%>',
                        url,
                        true);
      }else{
        parent.location.replace(url);
      }
      top.saveData(title, "title");
     
    }
    
  function deleteFFMCenter(){
      if (parent.buttons.buttonForm.deleteButtonButton.className !='disabled') {
        var tokens = parent.getSelected().split(",");
        var tokenLength = tokens.length;
        var checked;
        for (var i = 0 ; i < tokenLength ; i++){
            if (i == 0){
              checked = tokens[i]; 
            }else if (i%2 == 0){
              checked = checked + "," + tokens[i];
            }
        }
        //var checked = parent.getChecked();
       var size = tokenLength
       if (size > 0){
         // Set up the delete list
         var FulfillmentCenterList = "";
         for(var i=0; i< size; i++){
           if (i == 0){
             FulfillmentCenterList = "fulfillmentCenterId=" + tokens[i];
           } else if (i%2 ==0){
             FulfillmentCenterList += "&fulfillmentCenterId=" + tokens[i];
           }
         }
      }

    var confirmDelete = '<%=UIUtil.toJavaScript((String)ffmCenterListNLS.get("deleteFFC")) %>';
    if (confirmDialog('<%=UIUtil.toJavaScript((String)ffmCenterListNLS.get("deleteFFC")) %>')){
      var redirectURL = "<%="/webapp/wcs/tools/servlet/NewDynamicListView?ActionXMLFile=inventory.FFMCenterList&cmd=FFMCenterListView"%>";
      var url = "/webapp/wcs/tools/servlet/FulfillmentCenterDelete?"
                + FulfillmentCenterList
                + "&URL=" + redirectURL;
   
      parent.location.replace(url);
    }
  }
}

    
   

    function onLoad()
    {
      parent.loadFrames()
    }

    function getRefNum() 
    {
      
    }
    
    function isButtonDisabled(b) {
      if (b.className =='disabled' &&	b.id == 'disabled'){
        return true;
      }
      return false;
    }	
    function disableBut(but){
      but.className='disabled';
    }
    
    function enableBut(but){
      but.className='enabled';
    }

    function check() {
      var tokens = parent.getSelected().split(",");
      var ffcid = tokens[0];
      var  canDelete = tokens[1]; 
      if(canDelete=='N'){
        
        return;
      }else if(canDelete =='Y'){
        
        return;
      }
      return ;
    }

// -->
</script>

<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>

</HEAD>
<BODY ONLOAD="onLoad()" CLASS="content">

<H1><%= UIUtil.toHTML((String)ffmCenterListNLS.get("inventoryAdjustmentTitle")) %></H1>


<%
          int startIndex = Integer.parseInt(request.getParameter("startindex"));
          int listSize = Integer.parseInt(request.getParameter("listsize"));
          int endIndex = startIndex + listSize;
          int rowselect = 1;
          int totalsize = numberOfffmCenters;
          int totalpage = totalsize/listSize;
	
%>


<%=comm.addControlPanel("inventory.FFMCenterList", totalpage, totalsize, localeUsed )%>


<FORM NAME="ffmCenterListForm">


<%=comm.startDlistTable((String)ffmCenterListNLS.get("ffmCenterTableSum")) %>


<%= comm.startDlistRowHeading() %>


<%= comm.addDlistCheckHeading() %>


<%-- //BR 13MAR2001 These next few rows get the header name from the vendorPurchaseNLS file --%>
<%--//"VendorName should be the orderby variable  if orderbyParm = true, it sorts by this--%>

<%= comm.addDlistColumnHeading((String)ffmCenterListNLS.get("fulfillmentCenterName"), null, false )%>

<%= comm.addDlistColumnHeading((String)ffmCenterListNLS.get("fulfillmentDropShip"), null, false )%>

<%= comm.addDlistColumnHeading((String)ffmCenterListNLS.get("fulfillmentDisplayName"), null, false )%>

<%= comm.endDlistRow() %>


<!-- Need to have a for loop to look for all the fulfillment centers -->
<%
    FFMOrderItemsDataBean ffmCenter;
  
    if (endIndex > numberOfffmCenters){
      endIndex = numberOfffmCenters;
     }

    for (int i=startIndex; i<endIndex ; i++){
      ffmCenter = ffmCenters[i];
      String ffmCenterId = ffmCenter.getDataBeanKeyFulfillmentCenterId();
      String dropShipNLV = "";
      
        FulfillmentCenterDataBean anFFC = new FulfillmentCenterDataBean();
        anFFC.setInitKey_fulfillmentCenterId(ffmCenterId);
        String dropShip = anFFC.getDropShip();
        if (dropShip.equals("Y")){
          dropShipNLV = (String)ffmCenterListNLS.get("ffcDropShip");
        }else{
          dropShipNLV = (String)ffmCenterListNLS.get("ffcNotDropShip");
        }
     
%>
<%=  comm.startDlistRow(rowselect) %>

<%= comm.addDlistCheck(ffmCenterId + "," +  ffmCenter.getDataBeanKeyYorN() ,"parent.setChecked();check();" ) %>


<%= comm.addDlistColumn( UIUtil.toHTML(ffmCenter.getDataBeanKeyName()), "javascript:changeFFMCenter('"+ffmCenter.getDataBeanKeyFulfillmentCenterId()+"');" ) %> 


<%= comm.addDlistColumn( dropShipNLV, "none" ) %> 


<%= comm.addDlistColumn( UIUtil.toHTML(ffmCenter.getDataBeanKeyDisplayName()), "none" ) %> 

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
   if ( numberOfffmCenters == 0 ){
%>
<br>
<%= ffmCenterListNLS.get("noffmcenter") %>
<%
   }
%>

</FORM>
<SCRIPT LANGUAGE="JavaScript">
<!---- hide script from old browsers
  parent.afterLoads();
  parent.setResultssize(getResultsize());
  // -->
</SCRIPT>

</BODY>
</HTML>

