<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2009 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

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
<%@ page import="java.util.*" %>
<%@ page import="com.ibm.commerce.server.ECConstants" %>
<%@ page import="com.ibm.commerce.common.beans.StoreEntityDataBean" %>
<%@ page import="com.ibm.commerce.beans.DataBeanManager" %>
<%@ page import="com.ibm.commerce.tools.util.ResourceDirectory" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.tools.xml.*" %>
<%@ page import="com.ibm.commerce.ordermanagement.beans.*" %>
<%@ page import="com.ibm.commerce.ordermanagement.objects.*" %>
<%@ page import="com.ibm.commerce.ordermanagement.beans.ReturnRecordsForOperationManagerDataBean" %>
<%@ page import="com.ibm.commerce.tools.common.ui.taglibs.*" %>
<%@ page import="com.ibm.commerce.tools.command.*" %>
<%@ page import="com.ibm.commerce.datatype.TypedProperty" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.server.JSPHelper" %>
<%@ page import="com.ibm.commerce.utils.TimestampHelper" %>
<%@ page import="com.ibm.commerce.bi.databeans.*" %>
<%@ include file="../common/common.jsp" %>
<%@ page import="com.ibm.commerce.server.ECConstants" %>
<%@ page import="com.ibm.commerce.tools.segmentation.SegmentConstants" %>
<%@ page import="com.ibm.commerce.base.objects.*" %>
<%@ page import="com.ibm.commerce.beans.*" %>
<%@ page import="com.ibm.commerce.command.*" %>
<%@ page import="com.ibm.commerce.datatype.*" %>
<%@ page import="com.ibm.commerce.server.*" %>
<%@ page import="com.ibm.commerce.common.objects.*" %>
<%@ page import="com.ibm.commerce.user.beans.*"   %>
<%@ page import="com.ibm.commerce.user.objects.*"   %>

<% CommandContext cmdContext = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
   if (cmdContext == null) {
       out.println("CommandContext is null");
       return;
   }

  Hashtable  VendorPurchaseNLS_en_US = null;
  Locale  localeUsed = cmdContext.getLocale();
  VendorPurchaseNLS_en_US = (Hashtable)ResourceDirectory.lookup("inventory.VendorPurchaseNLS", localeUsed);
  Long owner_id = com.ibm.commerce.command.ECStringConverter.StringToLong(cmdContext.getStore().getMemberId());
  StoreAccessBean sa = cmdContext.getStore();
  String storeType = sa.getStoreType();
  UserAccessBean ua = cmdContext.getUser();

  Vector roles = Util.getRoles(ua, owner_id);
  boolean receiver = false;
  boolean disposer = false;
  
  for (int i=0; i < roles.size(); i++) {
    String oTempInteger=(String) roles.elementAt(i); 
    int  iCurrentValue=Integer.parseInt(oTempInteger); 

    if ((iCurrentValue == -1) || (iCurrentValue == -4) || (iCurrentValue == -12) || (iCurrentValue == -17)) {
      receiver = true;
      disposer = true;
    }
    else if ((iCurrentValue == -10)) {
      receiver = true;
    }
    else if(iCurrentValue == -15) {
      disposer = true;
    }
  }
  
  //Convert from boolean definition of access to int version
  int role = 4;
  if (receiver && disposer) {
    role =1;
  }
  if (receiver && !disposer) {
      role =2;
  }
  
  if (!receiver && disposer) {
      role =3;
  }

%>

<!-- This JSP is developed For the Role Operation Manager seller and logistics Manager -->

<% if (role ==1) { 
%>

  <jsp:useBean id="returnop3List" scope="request" class="com.ibm.commerce.ordermanagement.beans.ReturnRecordsForOperationManagerListDataBean">
  </jsp:useBean>

<% if (cmdContext == null) {
     out.println("CommandContext is null");
     return;
   }
   
   ReturnRecordsForOperationManagerDataBean returnPOs[] = null; 
   int  numberOfreturnPOs = 0; 

   Long userId = cmdContext.getUserId();
   Integer langId = cmdContext.getLanguageId();
   String strLangId = langId.toString(); 
   int lanval = Integer.parseInt(strLangId);

   // obtain the resource bundle for display. This is where the NLS file is linked to a variable of type hashtable..
   Integer  store_id1 = cmdContext.getStoreId();
   String  storeId1  = store_id1.toString(); 
   
   String ffmcenterId1 = UIUtil.getFulfillmentCenterId(request); 

   if(ffmcenterId1 == null) {
     ffmcenterId1 = "";
   }
   else {
     ffmcenterId1 = ffmcenterId1.trim();
   }
  
   if ((!ffmcenterId1.equalsIgnoreCase(""))) {
     returnop3List.setDataBeanKeyStoreId1(storeId1); 
     returnop3List.setDataBeanKeyFfmCenterId1(ffmcenterId1);   
 
    DataBeanManager.activate(returnop3List, request);
    returnPOs = returnop3List.getReturnRecordsForOperationManagerList();
           
    if (returnPOs != null) {
     numberOfreturnPOs = returnPOs.length;
    }
  }
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
<HTML>
<HEAD>
<%= fHeader%>

<LINK rel="stylesheet" href="<%= UIUtil.getCSSFile(localeUsed) %>" type="text/css">

<SCRIPT LANGUAGE="JavaScript">
<!---- hide script from old browsers
  function getResultsize() {
    return <%=numberOfreturnPOs%>; 
  }

  function ReturnedProducts() {    
    //GET THE VALUE FROM THE ROW SELECTED. SET THE COLUMN THAT'S 'SELECTED' WHEN THE ROW IS CHECKED IS SET IN  addDlistCheck().
    if (parent.buttons.buttonForm.ReturnedProductsButton.className !='disabled') {
      var tokens = parent.getSelected().split(",");
      var rmaid = tokens[0];
            
      var url="/webapp/wcs/tools/servlet/NewDynamicListView?ActionXMLFile=inventory.ReturnProductsList&amp;cmd=ReturnProductsListView";
      url += "&rmaid=" + rmaid;
      
      if (top.setContent) {
        top.setContent('<%=UIUtil.toJavaScript((String)VendorPurchaseNLS_en_US.get("ReturnedProductsListScreenTitle"))%>',  url, true);
      }
      else {
        parent.location.replace(url);
      }
    }
  }
                             
  function toBeOrNot() {
    var FFC1 = '<%=ffmcenterId1%>';
    
    if (FFC1 == "") {
      var mess = '<%=UIUtil.toJavaScript((String)VendorPurchaseNLS_en_US.get("FFCnone"))%>';
      alertDialog(mess);
      top.goBack();
    }
  }

  function check() {
    var tokens = parent.getSelected().split(",");
    var rmaid = tokens[0];
    var rowstatus = tokens[1]; 
     
    if(rowstatus=='DISPOSE') {
      disableBut(parent.buttons.buttonForm.ReceiveButton);
      return;
    }
    else if(rowstatus=='RECEIVE'){
      disableBut(parent.buttons.buttonForm.ReturnedProductsButton); 
      return;
    }
    else if (rowstatus =='BOTH') {
      parent.getChecked();
      return;
    }
    return ;
  }
              
  function ReceiveProducts() {
    if (parent.buttons.buttonForm.ReceiveButton.className !='disabled') {
      var tokens = parent.getSelected().split(",");
      //var tokens = parent.getChecked();
      var rmaid = tokens[0];
      var url="/webapp/wcs/tools/servlet/DialogView?XMLFile=inventory.ReceiveProductsDialog";
        
      url += "&rmaid=" + rmaid;
   
      if (top.setContent) {
        top.setContent('<%=UIUtil.toJavaScript((String)VendorPurchaseNLS_en_US.get("ReceiveProductsScreenTitle"))%>',  url, true);
      }
      else {
        parent.location.replace(url);
      }
    }
  } 

  function disableButton(b) {
    b.disabled=false;
    b.className='disabled';
    b.id='disabled';
  }

  function isButtonDisabled(b) {
    if (b.className =='disabled' && b.id == 'disabled')
     return true;
    return false;
  }
   
  function disableBut(but){
    but.className='disabled';
  }

  function enableBut(but){
    but.className='enabled';
  }

  function viewReports() {
    var store = '<%=storeType%>';
      
    if (store=="B2C" || store=="RHS" || store=="MHS") {
      var url="/webapp/wcs/tools/servlet/ShowContextList?context=B2C_ReturnsReports&contextConfigXML=reporting.OperationalReportsContext&ActionXMLFile=bi.retMgtcontextList";

      if (top.setContent){
        top.setContent('<%=UIUtil.toJavaScript((String)VendorPurchaseNLS_en_US.get("reportsButton"))%>', url, true);
      } 
      else {
        parent.location.replace(url);
      }
    }
    else {
      var url="/webapp/wcs/tools/servlet/ShowContextList?context=B2B_ReturnsReports&contextConfigXML=reporting.OperationalReportsContext&ActionXMLFile=bi.retMgtcontextList";

      if (top.setContent){
        top.setContent('<%=UIUtil.toJavaScript((String)VendorPurchaseNLS_en_US.get("reportsButton"))%>',url,true);
      }
      else{
        parent.location.replace(url);
      }
    }
  } 

  function onLoad(){
    toBeOrNot(); 
    parent.loadFrames()
  }

// -->
</SCRIPT>

<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/common/dynamiclist.js"></SCRIPT>

</HEAD>
<BODY ONLOAD="onLoad()" CLASS="content_list">

<%int startIndex = Integer.parseInt(request.getParameter("startindex"));
  int listSize = Integer.parseInt(request.getParameter("listsize"));
  int endIndex = startIndex + listSize;
  int rowselect = 1;
  int totalsize = numberOfreturnPOs;
  int totalpage = totalsize/listSize;
%>
<%= comm.addControlPanel("inventory.ReturnRecordsListOpMgr", totalpage, totalsize, localeUsed )%>

<FORM NAME="ReturnRecordsListScreenTitle" method="get"><%=comm.startDlistTable((String)VendorPurchaseNLS_en_US.get("ReturnRecordsTableSum")) %>
<%= comm.startDlistRowHeading()%> <%=comm.addDlistCheckHeading()%> <%-- // GET THE DISPLAY COLUMN HEADINGS FROM THE ReturnRecordsNLS FILE: --%>
<%= comm.addDlistColumnHeading((String)VendorPurchaseNLS_en_US.get("ReturnsID"), null, false )%>
<%= comm.addDlistColumnHeading((String)VendorPurchaseNLS_en_US.get("ReturnsDate"), null, false  )%>
<%= comm.addDlistColumnHeading((String)VendorPurchaseNLS_en_US.get("CustomerName"), null, false )%>
<!-- %= comm.addDlistColumnHeading((String)VendorPurchaseNLS_en_US.get("RowStatus"), null, false )% -->

<%= comm.endDlistRow() %> <!-- Need to have a for loop to look for all the member groups -->

<% ReturnRecordsForOperationManagerDataBean returnPO;
   if (endIndex > numberOfreturnPOs ){
     endIndex = numberOfreturnPOs;
   }
   String name1 = "";
     
   for (int i=startIndex; i<endIndex ; i++){
     returnPO = returnPOs[i];
     String rmaid = returnPO.getDataBeanKeyRmaId();
     if (rmaid == null){
       rmaid = "";
     }
     String orderDate = returnPO.getDataBeanKeyRmaDate();
     String formattedOrderDate = null;
     if (orderDate == null) {
       formattedOrderDate = "";
     }
     else {
       Timestamp tmp_orderDate = Timestamp.valueOf(orderDate);
       formattedOrderDate = TimestampHelper.getDateFromTimestamp(tmp_orderDate, localeUsed );
     }

     String FirstName= returnPO.getDataBeanKeyFirstname();
     if (FirstName==null) {
        FirstName = "";
     }

     String Lastname=  returnPO.getDataBeanKeyLastname();
     if (Lastname== null){
       Lastname="";
     }
        
     String MiddleName=returnPO.getDataBeanKeyMiddlename();
     if (MiddleName== null) {
       MiddleName= "";
     }
          
     if ((lanval == -7) || (lanval == -8) || (lanval == -9) || (lanval == -10)) {
       StringBuffer Name = new StringBuffer();
       Name.append(Lastname);
       Name.append(" ");
       Name.append(FirstName);
       name1 = Name.toString();
      }
      else {
        StringBuffer Name = new StringBuffer();
        Name.append(FirstName);
        Name.append(" ");
        Name.append(MiddleName);
        Name.append(" ");
        Name.append(Lastname);
        name1 = Name.toString();
      }

      String rowstatus = returnPO.getDataBeanKeyRowStatus();
      if (rowstatus == null) {
        rowstatus= "";
      }
        
%>
<%=  comm.startDlistRow(rowselect) %> <!-- THIS IS WHERE YOU ADD THE COLUMN CHECKED, TO BE RETRIEVED AS A PARM: -->
<!-- %= comm.addDlistCheck(rmaid, "none" ) % --> <%= comm.addDlistCheck(rmaid + "," +  returnPO.getDataBeanKeyRowStatus(),"parent.setChecked();check();" ) %>

<!-- ADDS A COLUMN 'CELL' TO THE DISPLAY: --> <%= comm.addDlistColumn( rmaid, "none" ) %>
<%= comm.addDlistColumn( formattedOrderDate, "none" ) %> <%= comm.addDlistColumn( name1, "none" ) %>
<!-- %= comm.addDlistColumn( rowstatus, "none" ) % --> <%= comm.endDlistRow() %>

<% if(rowselect==1){
     rowselect = 2;
   } 
   else{
     rowselect = 1;
   }
%>
<%}
%>
<%= comm.endDlistTable() %> 
<%
   if ( numberOfreturnPOs == 0 ){
%>
<br>
<%=UIUtil.toHTML((String)VendorPurchaseNLS_en_US.get("NoReturnRows")) %>
<% }
%>
</FORM>
<SCRIPT LANGUAGE="JavaScript">
  parent.afterLoads();
  parent.setResultssize(getResultsize());
</SCRIPT>
</BODY>
</HTML>
<% }
  else if (role ==2 ){
%>


<!-- This JSP is developed For the Role receiver -->

<%@ page import="com.ibm.commerce.ordermanagement.beans.ReturnRecordsForReceiverDataBean" %>

<jsp:useBean id="returnop1List" scope="request" class="com.ibm.commerce.ordermanagement.beans.ReturnRecordsForReceiverListDataBean">
</jsp:useBean>

<% ReturnRecordsForReceiverDataBean returnPOs[] = null; 
   int  numberOfreturnPOs = 0; 
   if (cmdContext == null) {
     out.println("CommandContext is null");
     return;
   }
   Long  userId     = cmdContext.getUserId();
     
   // obtain the resource bundle for display. This is where the NLS file is linked to a variable of type hashtable..
   
   // above is casted to Hashtable  @#
   Integer store_id = cmdContext.getStoreId();
   String storeId = store_id.toString();
   Integer langId1 = cmdContext.getLanguageId();
   String strLangId1 = langId1.toString(); 
   int  lanval2 = Integer.parseInt(strLangId1); 
   String ffmcenterId = UIUtil.getFulfillmentCenterId(request); 
  

   if(ffmcenterId.equalsIgnoreCase("null")){
     ffmcenterId = "";
   }
   else {
     ffmcenterId = ffmcenterId.trim();
   }
    
   if ((!ffmcenterId.equalsIgnoreCase(""))) {
     returnop1List.setDataBeanKeyStoreId(storeId); 
     returnop1List.setDataBeanKeyFfmCenterId(ffmcenterId);
     DataBeanManager.activate(returnop1List, request);
     returnPOs = returnop1List.getReturnRecordsForReceiverList();
   
     if (returnPOs != null) {
       numberOfreturnPOs = returnPOs.length;
     }
 
                     }
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
<HTML>
<HEAD>
<%= fHeader%>

<LINK rel="stylesheet" href="<%= UIUtil.getCSSFile(localeUsed) %>"
 type="text/css">
<TITLE></TITLE>

<SCRIPT LANGUAGE="JavaScript">
<!---- hide script from old browsers
    function getResultsize(){
      return <%=numberOfreturnPOs%>; 
    }
 
/////////////////////////////////////////////////////////////////////
// function ReceiveProducts() - called when RECEIVE button is pressed.
/////////////////////////////////////////////////////////////////////
  function ReturnedProducts() {    
    //GET THE VALUE FROM THE ROW SELECTED. SET THE COLUMN THAT'S 'SELECTED' WHEN THE ROW IS CHECKED IS SET IN  addDlistCheck().
    var tokens = parent.getSelected().split(",");
    var rmaid = tokens[0];
    var url="/webapp/wcs/tools/servlet/NewDynamicListView?ActionXMLFile=inventory.ReturnProductsList&amp;cmd=ReturnProductsListView";
    url += "&rmaid=" + rmaid;
     
    if (top.setContent) {
      top.setContent('<%=UIUtil.toJavaScript((String)VendorPurchaseNLS_en_US.get("ReturnedProductsListScreenTitle"))%>',  url, true);
    }
    else {
      parent.location.replace(url);
    }
  }

  function toBeOrNot() {
    var FFC1 = '<%=ffmcenterId%>';
    
    if ( FFC1 == "")  {
      var mess = '<%=UIUtil.toJavaScript((String)VendorPurchaseNLS_en_US.get("FFCnone"))%>';
      alertDialog(mess);
      top.goBack();
    }
  }

  function ReceiveProducts(){
    var tokens = parent.getSelected().split(",");
    var rmaid = tokens[0];

    var url="/webapp/wcs/tools/servlet/DialogView?XMLFile=inventory.ReceiveProductsDialog";
    url += "&rmaid=" + rmaid;
   
    if (top.setContent){
      top.setContent('<%=UIUtil.toJavaScript((String)VendorPurchaseNLS_en_US.get("ReceiveProductsScreenTitle"))%>',  url, true);
    }
    else{
      parent.location.replace(url);
    }
  }                     


  function viewReports()      {
    var store = '<%=storeType%>';
    
    if (store=="B2C"){
      var url="/webapp/wcs/tools/servlet/ShowContextList?context=B2C_ReturnsReports&contextConfigXML=reporting.OperationalReportsContext&ActionXMLFile=bi.retMgtcontextList";

      if (top.setContent){
        top.setContent('<%=UIUtil.toJavaScript((String)VendorPurchaseNLS_en_US.get("reportsButton"))%>',url,true);
      } 
      else{
        parent.location.replace(url);
      }
    }
    else{
      var url="/webapp/wcs/tools/servlet/ShowContextList?context=B2B_ReturnsReports&contextConfigXML=reporting.OperationalReportsContext&ActionXMLFile=bi.retMgtcontextList";
      if (top.setContent){
        top.setContent('<%=UIUtil.toJavaScript((String)VendorPurchaseNLS_en_US.get("reportsButton"))%>',url,true);
      } 
      else {
        parent.location.replace(url);
      }
    }  
  } 

  function onLoad() {
    toBeOrNot(); 
    parent.loadFrames()
  }   
   
// -->
</SCRIPT>

<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/common/dynamiclist.js"></SCRIPT>

</HEAD>
<BODY ONLOAD="onLoad()" CLASS="content_list">

<% int startIndex = Integer.parseInt(request.getParameter("startindex"));
   int listSize = Integer.parseInt(request.getParameter("listsize"));
   int endIndex = startIndex + listSize;
   int rowselect = 1;
   int totalsize = numberOfreturnPOs;
   int totalpage = totalsize/listSize;
%>

<%=comm.addControlPanel("inventory.ReturnRecordsListOpMgr", totalpage, totalsize, localeUsed )%>

<FORM NAME="ReturnRecordsListScreenTitle"><%=comm.startDlistTable((String)VendorPurchaseNLS_en_US.get("ReturnRecordsTableSum")) %>
<%= comm.startDlistRowHeading() %> <%=comm.addDlistCheckHeading()%> <%-- // GET THE DISPLAY COLUMN HEADINGS FROM THE ReturnRecordsNLS FILE: --%>
<%= comm.addDlistColumnHeading((String)VendorPurchaseNLS_en_US.get("ReturnsID"), null, false )%>
<%= comm.addDlistColumnHeading((String)VendorPurchaseNLS_en_US.get("ReturnsDate"), null, false  )%>
<%= comm.addDlistColumnHeading((String)VendorPurchaseNLS_en_US.get("CustomerName"), null, false )%>
<!-- %= comm.addDlistColumnHeading((String)VendorPurchaseNLS_en_US.get("RowStatus"), null, false )% -->

<%= comm.endDlistRow() %> <!-- Need to have a for loop to look for all the member groups -->

<% ReturnRecordsForReceiverDataBean returnPO;
  
   if (endIndex > numberOfreturnPOs ){
     endIndex = numberOfreturnPOs;
   }
   String name2 = "";     
     
   for (int i=startIndex; i<endIndex ; i++){
     returnPO = returnPOs[i];
     String rmaid = returnPO.getDataBeanKeyRmaId();
      
     if (rmaid == null){
       rmaid = "";
     }
     String orderDate = returnPO.getDataBeanKeyRmaDate();
     String formattedOrderDate = null;
     if (orderDate == null){
       formattedOrderDate = "";
     }
     else {
       Timestamp tmp_orderDate = Timestamp.valueOf(orderDate);
       formattedOrderDate = TimestampHelper.getDateFromTimestamp(tmp_orderDate, localeUsed );
     }
   
     String FirstName= returnPO.getDataBeanKeyFirstname();
     if (FirstName==null) {
        FirstName = "";
     }

     String Lastname=  returnPO.getDataBeanKeyLastname();
     if (Lastname== null) {
       Lastname="";
     }

     String MiddleName=returnPO.getDataBeanKeyMiddlename();
     if (MiddleName== null) {
       MiddleName= "";
     }
         
     if ((lanval2 == -7) || (lanval2 == -8) || (lanval2 == -9) || (lanval2 == -10)) {
       StringBuffer Name = new StringBuffer();
       Name.append(Lastname);
       Name.append(" ");
       Name.append(FirstName);
       name2 = Name.toString();
     }
     else {
       StringBuffer Name = new StringBuffer();
       Name.append(FirstName);
       Name.append(" ");
       Name.append(MiddleName);
       Name.append(" ");
       Name.append(Lastname);
       name2 = Name.toString();
     }
     
     String rowstatus = returnPO.getDataBeanKeyRowStatus();
     if (rowstatus == null){
       rowstatus= "";
     }
%>
<%=  comm.startDlistRow(rowselect) %> <!-- THIS IS WHERE YOU ADD THE COLUMN CHECKED, TO BE RETRIEVED AS A PARM: -->
<%= comm.addDlistCheck(rmaid, "none" ) %> <!-- ADDS A COLUMN 'CELL' TO THE DISPLAY: -->
<%= comm.addDlistColumn( rmaid, "none" ) %> <%= comm.addDlistColumn( formattedOrderDate, "none" ) %>

<%= comm.addDlistColumn( name2, "none" ) %> <!-- %= comm.addDlistColumn( rowstatus, "none" ) % -->

<%= comm.endDlistRow() %>
<% if(rowselect==1){
     rowselect = 2;
   }
   else{
     rowselect = 1;
   }
%>
<%}
%>
<%= comm.endDlistTable() %>
<%
   if ( numberOfreturnPOs == 0 ){
%> <br>
<%=UIUtil.toHTML((String)VendorPurchaseNLS_en_US.get("NoReturnRows")) %>
<%
   }
%></FORM>
<SCRIPT LANGUAGE="JavaScript">
 parent.afterLoads();
 parent.setResultssize(getResultsize());
</SCRIPT>
</BODY>
</HTML>



<% 
  }  
 else if (role == 3){
  
  
 %>

<!-- This JSP is developed For the Role  of Return Administrator -->
<%@ page import="com.ibm.commerce.ordermanagement.beans.ReturnRecordsForReturnAdministratorDataBean" %>

<jsp:useBean id="returnop2List" scope="request" class="com.ibm.commerce.ordermanagement.beans.ReturnRecordsForReturnAdministratorListDataBean">

</jsp:useBean>

<%
  
   //ReturnRecordsForAdministratorDataBean returnPOs[] = null; 
   ReturnRecordsForReturnAdministratorDataBean returnPOs[] = null; 
   int  numberOfreturnPOs = 0; 

   if (cmdContext == null) {
     out.println("CommandContext is null");
     return;
   }
   Long  userId     = cmdContext.getUserId();
   // obtain the resource bundle for display. This is where the NLS file is linked to a variable of type hashtable..
   // above is casted to Hashtable  @#
   Integer  langId3     = cmdContext.getLanguageId();
   String   strLangId3 = langId3.toString(); 
   int  lanval3 = Integer.parseInt(strLangId3);

   Integer  store_id = cmdContext.getStoreId();
   String  storeId  = store_id.toString(); 
  
   String ffmcenterId = UIUtil.getFulfillmentCenterId(request); 

   if(ffmcenterId.equalsIgnoreCase("null")) {
     ffmcenterId = "";
   }
   else {
     ffmcenterId = ffmcenterId.trim();
   }

   if ((!ffmcenterId.equalsIgnoreCase(""))) {
     returnop2List.setDataBeanKeyStoreId(storeId); 
     returnop2List.setDataBeanKeyFfmCenterId(ffmcenterId);   
     DataBeanManager.activate(returnop2List, request);
     returnPOs = returnop2List.getReturnRecordsForReturnAdministratorList();
     if (returnPOs != null) {
       numberOfreturnPOs = returnPOs.length;
     }
   }
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
<HTML>
<HEAD>
<%= fHeader%>
<LINK rel="stylesheet" href="<%= UIUtil.getCSSFile(localeUsed) %>" type="text/css">
<TITLE></TITLE>

<SCRIPT LANGUAGE="JavaScript">
<!---- hide script from old browsers
  function getResultsize(){
    return <%=numberOfreturnPOs%>; 
  }
 
  /////////////////////////////////////////////////////////////////////
  // function ReceiveProducts() - called when RECEIVE button is pressed.
  /////////////////////////////////////////////////////////////////////
   
  function ReturnedProducts() {    
    //GET THE VALUE FROM THE ROW SELECTED. SET THE COLUMN THAT'S 'SELECTED' WHEN THE ROW IS CHECKED IS SET IN  addDlistCheck().
    var tokens = parent.getSelected().split(",");
    var rmaid = tokens[0];
    
    var url="/webapp/wcs/tools/servlet/NewDynamicListView?ActionXMLFile=inventory.ReturnProductsList&amp;cmd=ReturnProductsListView";
    url += "&rmaid=" + rmaid;
 
    if (top.setContent){
      top.setContent('<%=UIUtil.toJavaScript((String)VendorPurchaseNLS_en_US.get("ReturnedProductsListScreenTitle"))%>',  url, true);
    }
    else {
      parent.location.replace(url);
    }
  }
   
  function ReceiveProducts() {
    var tokens = parent.getSelected().split(",");
    var rmaid = tokens[0];

    var url="/webapp/wcs/tools/servlet/DialogView?XMLFile=inventory.ReceiveProductsDialog";
    url += "&rmaid=" + rmaid;
   
    if (top.setContent){
      top.setContent('<%=UIUtil.toJavaScript((String)VendorPurchaseNLS_en_US.get("ReceiveProductsScreenTitle"))%>',  url, true);
    }
    else {
      parent.location.replace(url);
    }
  }                     

  function toBeOrNot() {
    var FFC1 = '<%=ffmcenterId%>';
    if ( FFC1 == "")  {
      var mess = '<%=UIUtil.toJavaScript((String)VendorPurchaseNLS_en_US.get("FFCnone"))%>';
      alertDialog(mess);
      top.goBack();
    }
  }

  function viewReports(){
    var store = '<%=storeType%>';
      
    if (store=="B2C"){
      var url="/webapp/wcs/tools/servlet/ShowContextList?context=B2C_ReturnsReports&contextConfigXML=reporting.OperationalReportsContext&ActionXMLFile=bi.retMgtcontextList";

      if (top.setContent){
        top.setContent('<%=UIUtil.toJavaScript((String)VendorPurchaseNLS_en_US.get("reportsButton"))%>',url,true);
      }
      else {
        parent.location.replace(url);
      }
    }
    else {
      var url="/webapp/wcs/tools/servlet/ShowContextList?context=B2B_ReturnsReports&contextConfigXML=reporting.OperationalReportsContext&ActionXMLFile=bi.retMgtcontextList";
      if (top.setContent) {
        top.setContent('<%=UIUtil.toJavaScript((String)VendorPurchaseNLS_en_US.get("reportsButton"))%>',url,true);
      } 
      else {
        parent.location.replace(url);
      }
    }
  } 

  function onLoad(){
    toBeOrNot(); 
    parent.loadFrames()
  }

// -->
</SCRIPT>

<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/common/dynamiclist.js"></SCRIPT>

</HEAD>
<BODY ONLOAD="onLoad()" CLASS="content_list">

<% int startIndex = Integer.parseInt(request.getParameter("startindex"));
   int listSize = Integer.parseInt(request.getParameter("listsize"));
   int endIndex = startIndex + listSize;
   int rowselect = 1;
   int totalsize = numberOfreturnPOs;
   int totalpage = totalsize/listSize;
%>

<%=comm.addControlPanel("inventory.ReturnRecordsListOpMgr", totalpage, totalsize, localeUsed )%>
<FORM NAME="ReturnRecordsListScreenTitle"><%=comm.startDlistTable((String)VendorPurchaseNLS_en_US.get("ReturnRecordsTableSum")) %>
<%= comm.startDlistRowHeading() %> <%= comm.addDlistCheckHeading() %> <%--//"VendorName should be the orderby variable  if orderbyParm = true, it sorts by this--%>

<%-- BELOW ADDS A BLANK COLUMN HEADING, TO TAKE THE PLACE OF WHERE A HEADING CKBOX WOULD BE: --%>
<!--%= comm.addDlistColumnHeading((String)ReturnRecordsListNLS.get(""), null, false )%-->

<%-- // GET THE DISPLAY COLUMN HEADINGS FROM THE ReturnRecordsNLS FILE: --%>
<%= comm.addDlistColumnHeading((String)VendorPurchaseNLS_en_US.get("ReturnsID"), null, false )%>
<%= comm.addDlistColumnHeading((String)VendorPurchaseNLS_en_US.get("ReturnsDate"), null, false  )%>
<%= comm.addDlistColumnHeading((String)VendorPurchaseNLS_en_US.get("CustomerName"), null, false )%>
<!-- %= comm.addDlistColumnHeading((String)VendorPurchaseNLS_en_US.get("RowStatus"), null, false )% -->
<%= comm.endDlistRow() %> <!-- Need to have a for loop to look for all the member groups -->

<% ReturnRecordsForReturnAdministratorDataBean returnPO;
  
   if (endIndex > numberOfreturnPOs ){
      endIndex = numberOfreturnPOs;
   }

   String name3 = "";
 
   for (int i=startIndex; i<endIndex ; i++){
     returnPO = returnPOs[i];
     String rmaid = returnPO.getDataBeanKeyRmaId();
      
     if (rmaid == null){
       rmaid = "";
     }

     String orderDate = returnPO.getDataBeanKeyRmaDate();
     String formattedOrderDate = null;
     if (orderDate == null){
       formattedOrderDate = "";
     }
     else {
       Timestamp tmp_orderDate = Timestamp.valueOf(orderDate);
       formattedOrderDate = TimestampHelper.getDateFromTimestamp(tmp_orderDate, localeUsed );
     }
  
     String FirstName= returnPO.getDataBeanKeyFirstname();
     if (FirstName==null) {
       FirstName = "";
     }
  
     String Lastname=  returnPO.getDataBeanKeyLastname();
     if (Lastname== null){
       Lastname="";
     }
        

     String MiddleName=returnPO.getDataBeanKeyMiddlename();
     if (MiddleName== null) {
       MiddleName= "";
     }
         
     if ((lanval3 == -7) || (lanval3 == -8) || (lanval3 == -9) || (lanval3 == -10)) {
       StringBuffer Name = new StringBuffer();
       Name.append(Lastname);
       Name.append(" ");
       Name.append(FirstName);
       name3 = Name.toString();
      }
      else{
        StringBuffer Name = new StringBuffer();
        Name.append(FirstName);
        Name.append(" ");
        Name.append(MiddleName);
        Name.append(" ");
        Name.append(Lastname);
        name3 = Name.toString();
      }

      String rowstatus = returnPO.getDataBeanKeyRowStatus();
      if (rowstatus == null){
        rowstatus= "";
      }
%>
<%= comm.startDlistRow(rowselect) %> <!-- THIS IS WHERE YOU ADD THE COLUMN CHECKED, TO BE RETRIEVED AS A PARM: -->
<%= comm.addDlistCheck(rmaid, "none" ) %> <!-- ADDS A COLUMN 'CELL' TO THE DISPLAY: -->
<%= comm.addDlistColumn( rmaid, "none" ) %> <%= comm.addDlistColumn( formattedOrderDate, "none" ) %>

<%= comm.addDlistColumn( name3, "none" ) %> <!-- %= comm.addDlistColumn( rowstatus, "none" ) % -->

<%= comm.endDlistRow() %> <%
  if(rowselect==1){
     rowselect = 2;
  } 
  else {
    rowselect = 1;
  }
%>
<%
}
%>
<%= comm.endDlistTable() %>
<% if ( numberOfreturnPOs == 0 ){
%>
 <br>
<%=UIUtil.toHTML((String)VendorPurchaseNLS_en_US.get("NoReturnRows")) %>
<%
   }
%></FORM>
<SCRIPT LANGUAGE="JavaScript">
   parent.afterLoads();
   parent.setResultssize(getResultsize());
</SCRIPT>
</BODY>
</HTML>
<% }
else if (role ==4) {

%>
<br>
<%=UIUtil.toHTML((String)VendorPurchaseNLS_en_US.get("authMessage")) %>
<% }
%>
