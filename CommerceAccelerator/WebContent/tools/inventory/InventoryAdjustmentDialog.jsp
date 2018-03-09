<%@ page language="java" %>   
<%@ page import="java.io.*" %>  
<%@ page import="java.lang.*" %>
<%@ page import="java.math.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="javax.servlet.*" %>
<%@ page import="com.ibm.commerce.base.objects.*" %>
<%@ page import="com.ibm.commerce.beans.*" %>
<%@ page import="com.ibm.commerce.command.*" %>
<%@ page import="com.ibm.commerce.datatype.*" %>
<%@ page import="com.ibm.commerce.server.*" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>  
<%@ page import="com.ibm.commerce.user.beans.*"   %>
<%@ page import="com.ibm.commerce.user.objects.*"   %>
<%@ page import="com.ibm.commerce.utils.TimestampHelper" %>
<%@ page import="com.ibm.commerce.inventory.beans.InventoryAdjustmentCodeDataBean" %>
<%@ page import="com.ibm.commerce.inventory.beans.ItemInventoryDataBean" %>
<%@ page import="com.ibm.commerce.inventory.objects.*" %>
<%@ page import="com.ibm.commerce.fulfillment.objects.*" %>
<%@ page import="com.ibm.commerce.fulfillment.beans.*" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.server.JSPHelper" %>
<%@ page import="com.ibm.commerce.datatype.TypedProperty" %>
<%@ include file= "../common/common.jsp" %>

<jsp:useBean id="reasonCodeList" scope="request" class="com.ibm.commerce.inventory.beans.InventoryAdjustmentCodeListDataBean">
</jsp:useBean>
<jsp:useBean id="invAvailable" scope="request" class="com.ibm.commerce.inventory.beans.ItemInventoryListDataBean">
</jsp:useBean>
<%  
    CommandContext cmdContext = (CommandContext)request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
    Locale locale = cmdContext.getLocale();
    Hashtable inventoryNLS = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("inventory.VendorPurchaseNLS", locale);
    
    Integer store_id = cmdContext.getStoreId();
    String storeId = store_id.toString();

    Integer langId = cmdContext.getLanguageId();
    String strLangId = langId.toString();
    
    reasonCodeList.setLanguageId(strLangId);
    reasonCodeList.setStoreentId(storeId);

    String  itemSpcId  = request.getParameter("itemSpcId");
    String  unitOfMeasure  = request.getParameter("unitOfMeasure");
    String q   ;
    String ffcId = UIUtil.getFulfillmentCenterId(request);
    String tooBig = "no";
    invAvailable.setFulfillmentCenterId(ffcId);
    invAvailable.setStoreId(storeId);
    invAvailable.setItemSpcId(itemSpcId);
    
    InventoryAdjustmentCodeDataBean adjustmentCodes[] = null;
    int numberOfadjustmentCodes = 0;

    ItemInventoryDataBean quantityAvail[] = null;
    int numberOfRows = 0;

    DataBeanManager.activate(reasonCodeList, request);
    adjustmentCodes = reasonCodeList.getInventoryAdjustmentCodeList();

    try{
      DataBeanManager.activate(invAvailable, request);
    } catch (Exception e) {
      tooBig = "yes";   
    }
    
    if (tooBig.equals("no")) {
      quantityAvail = invAvailable.getItemInventoryList();
    } 
    q = (String)"null";
     
    if (quantityAvail != null){
      numberOfRows = quantityAvail.length;
      ItemInventoryDataBean quantityFFC ;
      for (int i = 0 ; i < numberOfRows; i++){
        quantityFFC = quantityAvail[i]; 
        q = quantityFFC.getQtyAvailable();
      }
    }

  
    if (adjustmentCodes != null){
      numberOfadjustmentCodes = adjustmentCodes.length;
    }

    Vector adjCodeIdVec = new Vector();
    Vector adjDescVec = new Vector();
    Vector adjDisplayVec = new Vector();
    InventoryAdjustmentCodeDataBean adjustmentCode;

    for (int i=0; i < numberOfadjustmentCodes ; i++){
      adjustmentCode = adjustmentCodes[i];
      String adjCodeId = adjustmentCode.getInvAdjCodeId();
      String adjustDesc = adjustmentCode.getDisplay();
      String adjustCode = adjustmentCode.getAdjustCode();
      String adjDisplay = "\"" + adjustmentCode.getDescription() + "\"";
      String descEmpt = adjustDesc.trim();
      int k = descEmpt.length();
      if (k == 0){
        adjustDesc = adjustCode ;
      }
       
      adjCodeIdVec.addElement(adjCodeId);
      adjDescVec.addElement(adjustDesc);
      adjDisplayVec.addElement(adjDisplay);
    }

   %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2000, 2013 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<HTML>
 <HEAD>
 <%= fHeader%>

<LINK rel="stylesheet" href="<%= UIUtil.getCSSFile(locale) %>" type="text/css">
 <SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
 <SCRIPT SRC="/wcs/javascript/tools/common/DateUtil.js"></SCRIPT>
 <SCRIPT SRC="/wcs/javascript/tools/common/NumberFormat.js"></SCRIPT>
 <SCRIPT>
   var itemSpc;
   var qtyAvailable;
   var itemSpc;
   var Item;
   var SKU;
   var searchResult;
   var comment ;
   var checkReasonCode;
   var quantity ;
   var tooBig;
   var confirm;
   var incDec;
   var answer;
   var formatedQuantity;
   formatedQuantity = parent.formatInteger(<%= q %>, "<%=strLangId%>");

   function onLoad(){
     if (parent.setContentFrameLoaded){
       parent.setContentFrameLoaded(true);
       tooBig = "<%= tooBig %>";
       var quantityAvailable = "<%= q %>" ;
       if (tooBig == "yes"){
         alertDialog('<%=UIUtil.toJavaScript((String)inventoryNLS.get("noAdjust"))%>');
         top.goBack();
       }else if (quantityAvailable == "null"){
         alertDialog('<%=UIUtil.toJavaScript((String)inventoryNLS.get("quantityAvailableNull"))%>');
         top.goBack();
       }
     }
   }

   
  function validatePanelData(){ //start validatePanelData
    qtyAvailable = <%= q %>;
    qtyAvailable = strToInteger(qtyAvailable,  "<%=langId%>");
    var quantityStr = quantity ;
    quantity =  strToInteger(quantity,  "<%=langId%>");
    var remaining = qtyAvailable + quantity;      
    var minInt = - 2147483648 ;
    minInt = strToInteger(minInt,  "<%=langId%>");
    var maxInt = 2147483647 ;
    maxInt = strToInteger(maxInt,  "<%=langId%>");
    
    if (checkReasonCode == null) {
      alertDialog('<%=UIUtil.toJavaScript((String)inventoryNLS.get("invalidAdjustmentCode"))%>');
      document.adjustInventory.reasonCode.focus();
      return false;
    }
   
    if (!isValidNumber(quantity, "<%=langId%>", true)) {
      alertDialog('<%=UIUtil.toJavaScript((String)inventoryNLS.get("invalidAdjustmentAmount"))%>');
      if (incDec == "INC"){
        document.adjustInventory.quantityInc.focus();
      }else{
        document.adjustInventory.quantityDec.focus();
      }        
      return false;
    }else{
     //check to see if - amount is more than quantity available
      if (!isValidNumber(quantity, "<%=langId%>", false)) {
        if (incDec == "INC"){
          alertDialog('<%=UIUtil.toJavaScript((String)inventoryNLS.get("invalidAdjustmentAmount"))%>');
          document.adjustInventory.quantityInc.focus();
          return false;
        }
        if ( remaining < 0 ){
          alertDialog('<%=UIUtil.toJavaScript((String)inventoryNLS.get("invalidAdjustmentAmount2"))%>');
          if (incDec == "INC"){
            document.adjustInventory.quantityInc.focus();
          }else{
            document.adjustInventory.quantityDec.focus();
          } 
          return false;
        }
        if ( quantity < minInt ){
          alertDialog('<%=UIUtil.toJavaScript((String)inventoryNLS.get("quantityAdjustExceedMin"))%>');
          if (incDec == "INC"){
            document.adjustInventory.quantityInc.focus();
          }else{
            document.adjustInventory.quantityDec.focus();
          } 
          return false;
        } 
      } 
    } 
    var plus = "+" ;
    if (quantityStr.indexOf(plus) != -1){ 
      alertDialog('<%=UIUtil.toJavaScript((String)inventoryNLS.get("invalidAdjustmentAmount"))%>');
      if (incDec == "INC"){
        document.adjustInventory.quantityInc.focus();
      }else{
        document.adjustInventory.quantityDec.focus();
      } 
      return false;
    }
    if (quantity == 0 ){
      alertDialog('<%=UIUtil.toJavaScript((String)inventoryNLS.get("quantityZero"))%>');
      if (incDec == "INC"){
        document.adjustInventory.quantityInc.focus();
      }else{
        document.adjustInventory.quantityDec.focus();
      } 
      return false;
    }  
      if ( quantity > maxInt ){
      alertDialog('<%=UIUtil.toJavaScript((String)inventoryNLS.get("QuantityAdjustLimit"))%>');
      if (incDec == "INC"){
        document.adjustInventory.quantityInc.focus();
      }else{
        document.adjustInventory.quantityDec.focus();
      } 
      return false;
    }
    if ( remaining > maxInt ){
      alertDialog('<%=UIUtil.toJavaScript((String)inventoryNLS.get("QuantityAdjustLimitation"))%>');
      if (incDec == "INC"){
        document.adjustInventory.quantityInc.focus();
      }else{
        document.adjustInventory.quantityDec.focus();
      } 
      return false;
    }
    if ( !isValidUTF8length( comment, 254 )) {
      alertDialog('<%=UIUtil.toJavaScript((String)inventoryNLS.get("commentExceedMaxLength"))%>');
      document.adjustInventory.comment.focus();
      return false;
    }
    answer = confirmDialog(confirm);
    if (answer == false) {
        if(incDec == "INC"){
          document.adjustInventory.quantityInc.focus();
        }else{
          document.adjustInventory.quantityDec.focus();       
        }        
        return false;  
     }
    
    return true;
  } //end validatePanelData


  function savePanelData(){//start savePanelData
    var ffcId = <%= ffcId%>;
    var itemspcId  = '<%=(itemSpcId == null ? null : UIUtil.toJavaScript(itemSpcId))%>' ;
    var storeId = <%= storeId %>;
    checkReasonCode  = document.adjustInventory.reasonCode.value;
    if (document.adjustInventory.quantityButton[0].checked){
      quantity = trim(document.adjustInventory.quantityInc.value);
      incDec = "INC";
      confirm = '<%= UIUtil.toJavaScript((String)inventoryNLS.get("increaseQuantityMessage")) %>';
    }else if (   document.adjustInventory.quantityButton[1].checked){
      quantity = '-';
      quantity = quantity + trim(document.adjustInventory.quantityDec.value);
      incDec = "DEC";
      confirm = '<%= UIUtil.toJavaScript((String)inventoryNLS.get("decreaseQuantityMessage")) %>';
    }
    comment = trim(document.adjustInventory.comment.value);
       
    parent.put("comment",comment);
    parent.put("ffmcenterId",ffcId);
    parent.put("invAdjCodeId",checkReasonCode);
    parent.put("itemspcId",itemspcId);
    parent.put("quantity",quantity);
    parent.put("storeId",storeId);
   
  } //end savePanelData

  function cancel () {
    var answer = parent.confirmDialog('<%=UIUtil.toJavaScript((String)inventoryNLS.get("standardCancelConfirmation"))%>');
    return answer ;
  }

  function clearRow(rowName){
    if (rowName == "INCREASE"){
      document.adjustInventory.quantityInc.value = '';
      document.adjustInventory.quantityInc.disabled = true;
      document.adjustInventory.quantityDec.disabled = false;
    }else if (rowName == "DECREASE"){
      document.adjustInventory.quantityDec.value = '';
      document.adjustInventory.quantityInc.disabled = false;
      document.adjustInventory.quantityDec.disabled = true;
    }
  }
</SCRIPT>

<META name="GENERATOR" content="IBM WebSphere Studio">
</HEAD>
<BODY ONLOAD="onLoad();" CLASS=content>
<%@include file="../common/NumberFormat.jsp" %>
<H1><%= UIUtil.toHTML((String)inventoryNLS.get("inventoryAdjustmentTitle")) %></H1>

<script language="javascript"><!--- alert("InventoryAdjustmentDialog.jsp"); --></script> 

<BR>
<FORM NAME="adjustInventory">

<TABLE>
  <TR>
    <TD>
      <TABLE>
        <TR>
          <TD><%= UIUtil.toHTML((String)inventoryNLS.get("qtyAvailable")) %> <i> <script>if ("<%= q %>" != "null"){ document.write(formatedQuantity); }</script> </i><P><P>
          </TD>
           
        </TR>
        <TR>
          <TD><%= UIUtil.toHTML((String)inventoryNLS.get("unitOfMeasure")) %> <i> <script>document.write('<%= UIUtil.toJavaScript(unitOfMeasure) %>'); </script> </i><P><P></TD>
        </TR>
        <TR>
          <TD><%= UIUtil.toHTML((String)inventoryNLS.get("adjustQuantityReq")) %></TD>
        </TR>
        <TR>
          <TD>
              <INPUT NAME=quantityButton ID="quantityButton" type="radio" value="increase" checked onClick='clearRow("DECREASE")'>
              <LABEL for="quantityButton"><%= UIUtil.toHTML((String)inventoryNLS.get("increaseQuantity")) %></LABEL>
          </TD>
        </TR>
        <TR>
           <TD>
             <LABEL for="quantityInc"><INPUT NAME=quantityInc ID="quantityInc" size="10" type="text" maxlength = 10  onClick='clearRow("DECREASE")'></LABEL>
           </TD>
        </TR>
        <TR>
          <TD>
            <INPUT NAME=quantityButton ID="quantityButton" type="radio" value="decrease"onClick='clearRow("INCREASE")'>
            <LABEL for="quantityButton"><%= UIUtil.toHTML((String)inventoryNLS.get("decreaseQuantity")) %></LABEL>
          </TD>
        </TR>
        <TR>
           <TD>
             <LABEL for="quantityDec"><INPUT NAME=quantityDec ID="quantityDec" size="10" type="text" maxlength = 10  disabled onClick='clearRow("INCREASE")'></LABEL>
           </TD>
        </TR>
        
      </TABLE>
 <P>    
     <TABLE>
       <TBODY>
         <TR>
           <TD><LABEL for="reasonCode"><%= UIUtil.toHTML((String)inventoryNLS.get("adjustmentDispostionReasonCode")) %></LABEL>
           </TD>
         </TR>
         <TR>
           <TD>
             <SELECT size="1" name="reasonCode" id="reasonCode">
             <%  int firstTime = 1;
               for (int i=0; i < numberOfadjustmentCodes ; i++){
                 String adjDisplay = (String) adjDescVec.elementAt(i);
                 String adjID = (String) adjCodeIdVec.elementAt(i);
             %>
               <OPTION value="<%= adjID   %>" 

             <% if (firstTime == 1){ %> selected <% } %> >
                <%= adjDisplay %>
                </OPTION>
             <%
               firstTime ++;
               }
             %>
             </SELECT>
           </TD>
         </TR>
       </TBODY>
     </TABLE>
<P>   
     <TABLE>
       <TR>
         <TD><LABEL for="comment"><%= UIUtil.toHTML((String)inventoryNLS.get("adjustmentComments")) %></LABEL></TD>
       </TR>
       <TR>
         <TD><TEXTAREA NAME=comment ID="comment" rows="4" cols="45" onKeyDown="limitTextArea(this.form.comment ,254);" onKeyUp="limitTextArea(this.form.comment ,254);"> </TEXTAREA></TD>
       </TR>
     </TABLE>
   </TD>
 </TR>
</TABLE>
</FORM>
</BODY>
</HTML>
