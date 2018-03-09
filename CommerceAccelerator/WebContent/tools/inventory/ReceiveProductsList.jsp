<%--==========================================================================
Licensed Materials - Property of IBM

WebSphere Commerce

(c) Copyright IBM Corp.  2006
All Rights Reserved

US Government Users Restricted Rights - Use, duplication or
disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
===========================================================================--%>
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
<!-- This JSP is for Receive Products -->

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
<%@ page import="com.ibm.commerce.ordermanagement.beans.ReturnRecordComponentByRmaAndLanguageDataBean" %>
<%@ page import="com.ibm.commerce.tools.common.ui.taglibs.*" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.server.JSPHelper" %>
<%@ page import="com.ibm.commerce.utils.TimestampHelper" %>
<%@ include file="../common/common.jsp" %>



<jsp:useBean id="returnop5List" scope="request" 
class="com.ibm.commerce.ordermanagement.beans.ReturnRecordComponentByRmaAndLanguageListDataBean">

</jsp:useBean>

<%
   Hashtable VendorPurchaseNLS_en_US = null;

   ReturnRecordComponentByRmaAndLanguageDataBean returnPOs[] = null; 
   int 	numberOfreturnPOs = 0; 

   CommandContext cmdContext = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
    if (cmdContext == null) {
        return;
   }
   Long 	userId     = cmdContext.getUserId();
   Locale 	localeUsed = cmdContext.getLocale();

   // obtain the resource bundle for display
   // This is where the NLS file is linked to a variable of type hashtable..
   VendorPurchaseNLS_en_US = (Hashtable)ResourceDirectory.lookup("inventory.VendorPurchaseNLS", localeUsed);
   Hashtable calendarNLS = (Hashtable)ResourceDirectory.lookup("common.calendarNLS", localeUsed);
  
// above is casted to Hashtable  @#

 
   //Integer 	store_id = cmdContext.getStoreId();
    Integer 	store_Id  = cmdContext.getStoreId(); 
   
    Integer 	langId1    = cmdContext.getLanguageId();
    String  	strLangId1 = langId1.toString(); 
    Integer 	langId2    = cmdContext.getLanguageId();
    String  	strLangId2 = langId2.toString(); 
    
    
    /////////////////////////////////////////////////
    Timestamp  t = cmdContext.getTimestamp() ;
    String Year = TimestampHelper.getYearFromTimestamp(t);
    String Day = TimestampHelper.getDayFromTimestamp(t);
    String Month = TimestampHelper.getMonthFromTimestamp(t);
    ////////////////////////////////////////////////////////

    
    returnop5List.setDataBeanKeyLanguageId1(strLangId1); 
    returnop5List.setDataBeanKeyLanguageId2(strLangId2); 
  
   String rmaid1 = request.getParameter("rmaid");
   String rmaid2 = request.getParameter("rmaid");


   returnop5List.setDataBeanKeyRmaId1(rmaid1);
   returnop5List.setDataBeanKeyRmaId2(rmaid2);
   

   DataBeanManager.activate(returnop5List, request);
   returnPOs = returnop5List.getReturnRecordComponentByRmaAndLanguageList();
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

<SCRIPT SRC="/wcs/javascript/tools/common/newbutton.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/common/dynamiclist.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/common/DateUtil.js"></SCRIPT>

<TITLE> </TITLE>


<SCRIPT LANGUAGE="JavaScript">
var RMAInputList ="";
var date = "";
var validQtyCheck = true;
var validQtyInteger = true;
var validQtyBound = true;
var validate1 = true;
var RMAList = new Array();
RMAList = parent.parent.get("RMAList");
if(RMAList == null || !defined(RMAList)){
 	RMAList = new Array();
}
	
function initQtyField(){	
    if (RMAList.length > 0){
    <% for (int i = 0; i < numberOfreturnPOs ; i++){ %>    	
     	if(defined(RMAList[<%=i%>]) && RMAList[<%=i%>] != null ){     	 
      		var qtyToReceiveQty = RMAList[<%=i%>].QtyToReceive;
      		if(defined(document.ReturnRecordList.quantity<%=i%>) 
      				&& document.ReturnRecordList.quantity<%=i%> != null)
      		{
      			document.ReturnRecordList.quantity<%=i%>.value = qtyToReceiveQty;
      		}      		
      	}
    <% } %>  
    }	
 }
   
function getResultsize()
{
  return <%= numberOfreturnPOs %>;
}
function setupDate()
{
  window.yearField = document.ReturnRecordList.YEAR1;
  window.monthField = document.ReturnRecordList.MONTH1;
  window.dayField = document.ReturnRecordList.DAY1;
}
  function isValidUTF8length(UTF8String, maxlength) {
    // alert('UTF8String='+UTF8String+'\nUTF-8 length='+utf8StringByteLength(UTF8String)+'\nmaxlength='+maxlength);
    if (utf8StringByteLength(UTF8String) > maxlength) return false;
    else return true;
   }

function init() {
      document.ReturnRecordList.YEAR1.value = getCurrentYear();
      document.ReturnRecordList.MONTH1.value = getCurrentMonth();
      document.ReturnRecordList.DAY1.value = getCurrentDay();
      }

   function onLoad()
    {
     parent.loadFrames();
     if (parent.parent.setContentFrameLoaded) {
          parent.parent.setContentFrameLoaded(true);
     }
      initQtyField();   
      //parent.loadFrames()
      // parent.init()
    }

function clickQtyAction(index)
{
	if (RMAList.length > 0 && defined(RMAList[index]) && RMAList[index] != null ){ 
		RMAList[index].QtyToReceive = document.ReturnRecordList["quantity" + index].value;
	}	
	
}

function validatePanelData()
{
  
  if ( !isValidPositiveInteger(document.ReturnRecordList.YEAR1.value )) {
    alertDialog('<%=UIUtil.toJavaScript((String)VendorPurchaseNLS_en_US.get("invalidDate"))%>');
    document.ReturnRecordList.YEAR1.select();
    document.ReturnRecordList.YEAR1.focus();
    return false;
  }

  if (!validDate(document.ReturnRecordList.YEAR1.value , document.ReturnRecordList.MONTH1.value, document.ReturnRecordList.DAY1.value)){
    alertDialog('<%=UIUtil.toJavaScript((String)VendorPurchaseNLS_en_US.get("invalidDate"))%>');
    document.ReturnRecordList.YEAR1.select();
    document.ReturnRecordList.YEAR1.focus();
    return false;
  }
  
  date = document.ReturnRecordList.YEAR1.value + ':' + document.ReturnRecordList.MONTH1.value +':'+ document.ReturnRecordList.DAY1.value + ':00:00:00';
  
    
  var validQty = 0;
  var validExpQty = 0;
  var validRcvQty = 0;
    var q4 = 0;

  var validateRMAList = parent.parent.get("RMAList");
  if (validateRMAList.length > 0 && validateRMAList.length <=2147483647){
    <% for (int i = 0; i < numberOfreturnPOs ; i++){ %>
     if(defined(validateRMAList[<%=i%>]) && validateRMAList[<%=i%>] != null ){     	 
      validExpQty = validateRMAList[<%=i%>].QtyExp;
      validRcvQty = validateRMAList[<%=i%>].QtyAlReceived;
      //validQty = validExpQty - validRcvQty;

      var quantity = validateRMAList[<%=i%>].QtyToReceive;
           
      if (quantity > 0  ) {
        if (quantity > validExpQty - validRcvQty){
          validQtyCheck = false;
        } 
          }
       
       q4 = parseInt(quantity) + parseInt(validRcvQty);
        if(q4 >= 2147483648) {
         
        alertDialog('<%=UIUtil.toJavaScript((String)VendorPurchaseNLS_en_US.get("QuantityLimitation"))%>');
        if(defined(document.ReturnRecordList.quantity<%=i%>) 
      				&& document.ReturnRecordList.quantity<%=i%> != null)
      	{
        	document.ReturnRecordList.quantity<%=i%>.select();
        	document.ReturnRecordList.quantity<%=i%>.focus();
        }	
        RMAInputList="";
        validQtyInteger = false;
        validate1 = true;
        validQtyCheck = true;
        return false;
                              }
      if (quantity >= 2147483648) {
           
            
        alertDialog('<%=UIUtil.toJavaScript((String)VendorPurchaseNLS_en_US.get("QuantityLimit"))%>');
        if(defined(document.ReturnRecordList.quantity<%=i%>) 
      				&& document.ReturnRecordList.quantity<%=i%> != null)
      	{
        	document.ReturnRecordList.quantity<%=i%>.select();
        	document.ReturnRecordList.quantity<%=i%>.focus();
        }	
        RMAInputList="";
        validQtyInteger = false;
        validQtyBound = false;
        validQtyCheck = true;
        return false;
                                  }
       
      
      if ( !isValidPositiveInteger(quantity)   ) {
        alertDialog('<%=UIUtil.toJavaScript((String)VendorPurchaseNLS_en_US.get("ReceiveProductsInvalidQty"))%>');
        if(defined(document.ReturnRecordList.quantity<%=i%>) 
      				&& document.ReturnRecordList.quantity<%=i%> != null)
      	{
       	 	document.ReturnRecordList.quantity<%=i%>.select();
        	document.ReturnRecordList.quantity<%=i%>.focus();
        }	
        RMAInputList="";
        validQtyInteger = false;
        
        
        return false;
      }
      
      if (quantity > 0 ) {
        var RMAItemCmpId_<%=i%> = validateRMAList[<%=i%>].RmaItmCompId;
        var quantity_<%=i%> = quantity;
        RMAInputList += "&RMAItemCmpId_"+<%=i%>+"="+ validateRMAList[<%=i%>].RmaItmCompId;
        RMAInputList += "&quantity_"+<%=i%>+"="+ quantity;
      }
    }
    <% } %>
    if (!validQtyCheck) {
      validQtyCheck = true;
      if (confirmDialog('<%=UIUtil.toJavaScript((String)VendorPurchaseNLS_en_US.get("ReceiveProductsQtyExceeding"))%>')){
        return true;
      } else {
        RMAInputList = "";
        return false;
      }
    }
  }
  
  
  return true;

}
function savePanelData()
{
  if (RMAInputList.length > 0) {
    alertDialog('<%=UIUtil.toJavaScript((String)VendorPurchaseNLS_en_US.get("prodMessage"))%>');  
    var redirectURL = "<%="/webapp/wcs/tools/servlet/NewDynamicListView?ActionXMLFile=inventory.ReturnRecordsListOpMgr&amp;cmd=ReturnRecordsListOpMgrView"%>";
    var url = "/webapp/wcs/tools/servlet/ReturnItemComponentReceive?"
            + "date=" + date 
            + RMAInputList
            + "&URL=" + redirectURL;
                 
    if (top.setContent) {
      RMAInputList = "";
      top.goBack();
      top.refreshBCT();
      top.showContent(url);
    }else {
      parent.parent.location.replace(url);
    }
  } else {
    top.goBack();
  }
  
}

</script>
<TITLE><%= UIUtil.toHTML((String)VendorPurchaseNLS_en_US.get("ReceiveProductsScreenTitle")) %> </TITLE>

</HEAD>
<BODY ONLOAD="onLoad()" CLASS="content_list">

<script language="javascript"><!--alert("ReceiveProductsList.jsp");--></script> 

<SCRIPT FOR=document EVENT="onclick()"> 
document.all.CalFrame.style.display="none";
</SCRIPT>
<FORM NAME="ReturnRecordList">
<IFRAME STYLE="display:none;position:absolute;width:198;height:230;z-index=100" ID="CalFrame" TITLE="<%= calendarNLS.get("calendarTitle") %>" MARGINHEIGHT=0 MARGINWIDTH=0 FRAMEBORDER=0 SCROLLING=NO SRC="/webapp/wcs/tools/servlet/tools/common/Calendar.jsp"></IFRAME>



<%
  int startIndex = Integer.parseInt(request.getParameter("startindex"));
  int listSize = Integer.parseInt(request.getParameter("listsize"));
  int endIndex = startIndex + listSize;
  int rowselect = 1;
  int totalsize = numberOfreturnPOs;
  int totalpage = totalsize/listSize;
	
%>

<TABLE> 
	<TR>
	<TD>&nbsp;</TD>
	<TD>&nbsp;</TD>
	<TD>&nbsp;</TD>
	<TD>&nbsp;</TD>
	<TD>&nbsp;</TD>
	<TD>&nbsp;</TD>
	<TD>&nbsp;</TD>
	<TD>&nbsp;</TD>
	<TD>&nbsp;</TD>
	<TD>&nbsp;</TD>
	</TR>

</TABLE>


<TABLE>
<TR><TD>
			<TABLE>
                <TR> 
         		  <TD>&nbsp;</TD>
                  <TD>&nbsp;</TD>
           		  <TD><LABEL for="YEAR1" ><%= UIUtil.toHTML((String)VendorPurchaseNLS_en_US.get("year")) %></LABEL></TD>
           		  <TD>&nbsp;</TD>
           		  <TD><LABEL for="MONTH1" ><%= UIUtil.toHTML((String)VendorPurchaseNLS_en_US.get("month")) %></LABEL></TD>
           		  <TD>&nbsp;</TD>
           		  <TD><LABEL for="DAY1"><%= UIUtil.toHTML((String)VendorPurchaseNLS_en_US.get("day")) %></LABEL></TD>
         		</TR> 
         		<TR> 
         		  <TD><%= UIUtil.toHTML((String)VendorPurchaseNLS_en_US.get("ReceiveProductsdate")) %></TD>
                  <TD>&nbsp;</TD>
           		  <TD ><INPUT TYPE=TEXT VALUE='<%=Year %>' NAME=YEAR1 ID="YEAR1" SIZE=4 maxlength=4></TD>
           		  <TD></TD>
           		  <TD ><INPUT TYPE=TEXT VALUE='<%=Month %>' NAME=MONTH1 ID="MONTH1" SIZE=2 maxlength=2></TD>
           		  <TD></TD>
           		  <TD><INPUT TYPE=TEXT VALUE='<%=Day %>' NAME=DAY1 ID="DAY1" SIZE=2 maxlength=2></TD>
           		  <TD>&nbsp;</TD>
           		  <TD><A HREF="javascript:setupDate();showCalendar(document.ReturnRecordList.calImg)">
             			<IMG SRC="/wcs/images/tools/calendar/calendar.gif" ALT="<%=VendorPurchaseNLS_en_US.get("chooseDate")%>" BORDER=0 id=calImg></A></TD>   
         		</TR>
			</TABLE>
</TD></TR>			
</TABLE>

<TABLE> 
<TR>
<TD>&nbsp;</TD>
<TD>&nbsp;</TD>
<TD>&nbsp;</TD>
<TD>&nbsp;</TD>
<TD>&nbsp;</TD>
<TD>&nbsp;</TD>
<TD>&nbsp;</TD>
<TD>&nbsp;</TD>
<TD>&nbsp;</TD>
<TD>&nbsp;</TD>
</TR>
</TABLE>

<%=comm.addControlPanel("inventory.ReceiveProductsList", totalpage, totalsize, localeUsed )%>
<%=comm.startDlistTable((String)VendorPurchaseNLS_en_US.get("ReturnRecordsTableSum")) %>
<%= comm.startDlistRowHeading() %>

<%= comm.addDlistColumnHeading((String)VendorPurchaseNLS_en_US.get("ReceiveProductsProductName"), null, false )%>
<%= comm.addDlistColumnHeading((String)VendorPurchaseNLS_en_US.get("ReceiveProductsSKU"), null, false  )%>
<%= comm.addDlistColumnHeading((String)VendorPurchaseNLS_en_US.get("SerialNumbers"),null,false)%>
<%= comm.addDlistColumnHeading((String)VendorPurchaseNLS_en_US.get("ReceiveProductsQtyExpected"), null, false )%>
<%= comm.addDlistColumnHeading((String)VendorPurchaseNLS_en_US.get("ReceiveProductsQtyAlreadyReceived"), null, false )%>
<%= comm.addDlistColumnHeading((String)VendorPurchaseNLS_en_US.get("ReceiveProductsQtyToReceiveNow"), null, false )%>
<%= comm.endDlistRow() %>

<!-- Need to have a for loop to look for all the member groups -->
<%
    ReturnRecordComponentByRmaAndLanguageDataBean returnPO;
    
    if (endIndex > numberOfreturnPOs){
      endIndex = numberOfreturnPOs;
     }
     
     
    for (int i=startIndex; i<endIndex ; i++){
      returnPO = returnPOs[i];

      String ProductName = returnPO.getDataBeanKeyShortDescription();

       if (ProductName == null) {
           ProductName = "";
                                }
     String SKU = returnPO.getDataBeanKeyPartNumber();
       if(SKU == null) {
         SKU = "";
                      }

     String itemComId = returnPO.getDataBeanKeyRmaItemComponentId();
     RMAItemComponentDataBean aRmaItem = new RMAItemComponentDataBean();
     aRmaItem.setDataBeanKeyRmaItemCmpId(itemComId);
     DataBeanManager.activate(aRmaItem, request);
     //String catEntryId = aRmaItem.getCatentryId();
    
      
     RMASerialNumbersDataBean[] rmaSBeans = aRmaItem.getRmaSerialNumbersDataBeans();
           
     boolean hasRmaSN = ( rmaSBeans != null && rmaSBeans.length > 0);
     Set sNs = new HashSet();
     for (int k = 0; k < rmaSBeans.length; k++){
         sNs.add(rmaSBeans[k].getSerialNumber());
     }
      
     String QtyExp = returnPO.getDataBeanKeyTotalQuantity();
     String  Search = ".";
     String QtyExp1 = "";
     int j;
       //do {
         j = QtyExp.indexOf(Search);
 if (j != -1)
    {
     QtyExp1 = QtyExp.substring(0,j);
      
       QtyExp =QtyExp1; 
}
 // } while (j!= -1);
        if( QtyExp == null) {
            QtyExp = "";
                            }

     String QtyAlReceived = returnPO.getDataBeanKeyReceiptQuantity();
            if ( QtyAlReceived == null ) {
                 QtyAlReceived = "";
                                         }
     String RmaItmCompId = returnPO.getDataBeanKeyRmaItemComponentId();    
     
     
     
%>
<%= comm.startDlistRow(rowselect) %>



<%= comm.addDlistColumn( ProductName, "none" ) %> 
<%= comm.addDlistColumn( SKU, "none" ) %> 
<% if ( !hasRmaSN ) { %>
<%= comm.addDlistColumn( "", "none" ) %> 
<% } else {%>

<%
    StringBuffer aStrBuffer = new StringBuffer();
    for (Iterator ite = sNs.iterator(); ite.hasNext();){
      //aStrBuffer.append("<LABEL><input type='checkbox'");
      //aStrBuffer.append(" name='SN_" + i + "_" + j);
      //aStrBuffer.append("' value='" + sNs.get(j) + "'>");
      //aStrBuffer.append("' ></LABEL> <br>");
      aStrBuffer.append((String)ite.next() + "<br>");
    }
%>
    <%= comm.addDlistColumn(aStrBuffer.toString(), "none") %>
<% } %>
<%= comm.addDlistColumn( QtyExp, "none" ) %> 
<%= comm.addDlistColumn( QtyAlReceived, "none" ) %> 

<%= comm.addDlistColumn("<LABEL><input type= \'text\' size =\'25\' maxlength = \'10\' Style=\'text-align:left\'  name=quantity" + i + " onChange='clickQtyAction(" + i + ")' value= \'0\' ></LABEL>","none") %>


<%= comm.endDlistRow() %>

<%
if(rowselect==1)
   {
     rowselect = 2;
   }else{
     rowselect = 1;
   }
%>

<SCRIPT>
if(RMAList[<%=i%>] == null || !defined(RMAList[<%=i%>])){
<%
out.println("RMAList[" + i + "] = new Object();");
out.println("RMAList[" + i + "].RmaItmCompId = " +  RmaItmCompId + ";");
out.println("RMAList[" + i + "].QtyAlReceived = " +  QtyAlReceived + ";");
out.println("RMAList[" + i + "].QtyExp = " +  QtyExp + ";");
out.println("RMAList[" + i + "].SNSize = " + sNs.size()  + ";");
out.println("RMAList[" + i + "].QtyToReceive = ReturnRecordList.quantity" + i + ".value;");
out.println("parent.parent.put('RMAList', RMAList);");
%>
}
</SCRIPT>

<%
}
%>

<%= comm.endDlistTable() %>


<%
   if ( numberOfreturnPOs == 0 ){
%>
<P>
<%= UIUtil.toHTML((String)VendorPurchaseNLS_en_US.get("NOReceiveRows")) %>
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
