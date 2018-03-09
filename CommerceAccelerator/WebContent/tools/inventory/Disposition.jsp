<!--  ES 101901
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
<%@ page import="com.ibm.commerce.beans.DataBeanManager" %>
<%@ page import="com.ibm.commerce.tools.util.ResourceDirectory" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.tools.xml.*" %>
<%@ page import="com.ibm.commerce.inventory.beans.PackslipDataBean" %>
<%@ page import="com.ibm.commerce.inventory.beans.*" %>
<%@ page import="com.ibm.commerce.ordermanagement.beans.*" %>
<%@ page import="com.ibm.commerce.tools.common.ui.taglibs.*" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.server.JSPHelper" %>
<%@ page import="com.ibm.commerce.utils.TimestampHelper" %>
<%@ page import="java.util.Hashtable" %>
<%@ page import="java.util.Locale" %>
<%@ page import="java.io.*" %>
<%@ page import="java.lang.*" %>
<%@ page import="java.math.*" %>
<%@ page import="java.util.*" %>
<%@ page import="javax.servlet.*" %>

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

<%@ include file="../common/common.jsp" %>

<jsp:useBean id="dispositionHeader" scope="request" class="com.ibm.commerce.ordermanagement.beans.DispositionHeaderListDataBean">
</jsp:useBean>
<jsp:useBean id="merchantReason" scope="request" class="com.ibm.commerce.ordermanagement.beans.MerchantReturnReasonsListDataBean">
</jsp:useBean>
<jsp:useBean id="dispositionReason" scope="request" class="com.ibm.commerce.ordermanagement.beans.ReturnDispositionListDataBean">
</jsp:useBean>
<jsp:useBean id="dispositionList" scope="request" class="com.ibm.commerce.ordermanagement.beans.PreviousDispositionsListDataBean">
</jsp:useBean>

<%
   Hashtable FulfillmentNLS = null;
   DispositionHeaderDataBean headerIDs[] = null; 
   int numberOfheaderIDs = 0; 

   MerchantReturnReasonsDataBean merchantIDs[] = null; 
   int numberOfmerchantIDs = 0; 

   ReturnDispositionDataBean dispositionIDs[] = null;
   int numberOfdispositionIDs = 0;

   PreviousDispositionsDataBean previousIDs[] = null; 
   int numberOfpreviousIDs = 0; 

   CommandContext cmdContext = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
   Long userId = cmdContext.getUserId();
   Locale localeUsed = cmdContext.getLocale();

   StoreAccessBean sa = cmdContext.getStore();
   String strGrpId = sa.getStoreGroupId();

   Integer langId = cmdContext.getLanguageId();
   String strLangId = langId.toString();

   Integer storeId = cmdContext.getStoreId();
   String strStoreId = storeId.toString();

   String returnReceiptId = request.getParameter("receiptId");
   String rmaId = request.getParameter("rmaId");


   // obtain the resource bundle for display
   FulfillmentNLS = (Hashtable)ResourceDirectory.lookup("inventory.VendorPurchaseNLS", localeUsed   );
   Hashtable calendarNLS = (Hashtable)ResourceDirectory.lookup("common.calendarNLS", localeUsed);

   //********* header bean **************

  String strReceivedDate = null;
  String strDispQuantity = null;
  String strSKU = null;
  String strCustomerRR = null;
  String strDescription =  null;
  String strReceivedQuantity = null;


   dispositionHeader.setDataBeanKeyLanguageId1(strLangId); 
// ES 101901   dispositionHeader.setDataBeanKeyLanguageId2(strLangId);
   dispositionHeader.setDataBeanKeyReceiptId(returnReceiptId);

   DataBeanManager.activate(dispositionHeader, request);
   headerIDs = dispositionHeader.getDispositionHeaderList();

   if (headerIDs != null)
   {
     numberOfheaderIDs = headerIDs.length;
   }
  
  DispositionHeaderDataBean headerBean;
  int a = 0;
  if (headerIDs != null)
   { if (numberOfheaderIDs > 0)
     {	headerBean = headerIDs[0];

  	strReceivedDate = headerBean.getDataBeanKeyDateReceived();
	String formattedCreatedDate = null;
        if (strReceivedDate == null){
           strReceivedDate = "";
        }else{
           Timestamp tmp_createdDate = Timestamp.valueOf(strReceivedDate);
           formattedCreatedDate = TimestampHelper.getDateFromTimestamp(tmp_createdDate, localeUsed );
           strReceivedDate = formattedCreatedDate;
	}

  	if (strReceivedDate == null){
		strReceivedDate = "";
  	}

  	strDispQuantity = headerBean.getDataBeanKeyNonDispositionQuantity();
  	if (strDispQuantity == null){
		strDispQuantity = "";
   	}

  	strSKU = headerBean.getDataBeanKeyPartNumber();
  	if (strSKU == null){
		strSKU = "";
  	}

  	strCustomerRR = headerBean.getDataBeanKeyReasonDescription();
  	if (strCustomerRR == null){
		strCustomerRR = "";
  	}

  	strDescription = headerBean.getDataBeanKeyShortDescription();
  	if (strDescription == null){
		strDescription = "";
  	}

  	strReceivedQuantity = headerBean.getDataBeanKeyTotalQuantity();
  	if (strReceivedQuantity == null){
		strReceivedQuantity = "";
  	}
     }    
}
   //********* merchant return reasons bean **************

   merchantReason.setDataBeanKeyStoreentId(strStoreId); 
   merchantReason.setDataBeanKeyLanguageId(strLangId);
   merchantReason.setDataBeanKeyStoreGroupId(strGrpId);

   DataBeanManager.activate(merchantReason, request);
   merchantIDs = merchantReason.getMerchantReturnReasonsList();

   if (merchantIDs != null)
   {
     numberOfmerchantIDs = merchantIDs.length;
   }

	Vector vecMRRId = new Vector();
	Vector vecMRRName = new Vector();
	MerchantReturnReasonsDataBean merchantBean;

	String strMRRDescription = null;
	String strMRRId = null;

	for (int b=0; b < numberOfmerchantIDs ; b++)
	{
      		merchantBean = merchantIDs[b];

  		strMRRDescription = merchantBean.getDataBeanKeyReasonDescription();
  		if (strMRRDescription == null){
 		strMRRDescription = "";
  		}

  		strMRRId = merchantBean.getDataBeanKeyReasonId();
  		if (strMRRId == null){
 		strMRRId = "";
  		}
	
      	vecMRRId.addElement(strMRRId);
      	vecMRRName.addElement(strMRRDescription);
	}
  



   //********* disposition codes bean **************

   dispositionReason.setDataBeanKeyLanguageId(strLangId); 
   dispositionReason.setDataBeanKeyStoreentId1(strStoreId);
   dispositionReason.setDataBeanKeyStoreentId2(strGrpId);
 
   DataBeanManager.activate(dispositionReason, request);
   dispositionIDs = dispositionReason.getReturnDispositionList();

   if (dispositionIDs != null)
   {
     numberOfdispositionIDs = dispositionIDs.length;
   }
  
  Vector vecDRId = new Vector();
  Vector vecDRName = new Vector();
  ReturnDispositionDataBean dispositionBean;

  String strRDDescription = null;
  String strDCId = null;

  for (int c=0; c < numberOfdispositionIDs ; c++)
{
      dispositionBean = dispositionIDs[c];

   	strRDDescription = dispositionBean.getDataBeanKeyDescription();
   	if (strRDDescription == null){
 		strRDDescription = "";
   	}

   	strDCId = dispositionBean.getDataBeanKeyDispositionCodeId();
   	if (strDCId == null){
 		strDCId = "";
   	}
	
      vecDRId.addElement(strDCId);
      vecDRName.addElement(strRDDescription);
}

   //********* previous dispositions list bean **************

   dispositionList.setDataBeanKeyLanguageId1(strLangId); 
   dispositionList.setDataBeanKeyLanguageId2(strLangId);
   dispositionList.setDataBeanKeyReceiptId(returnReceiptId);

   DataBeanManager.activate(dispositionList, request);
   previousIDs = dispositionList.getPreviousDispositionsList();

   if (previousIDs != null)
   {
     numberOfpreviousIDs = previousIDs.length;
   }
  

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
<HTML>
<HEAD>
<%= fHeader%>
<LINK rel="stylesheet" href="<%= UIUtil.getCSSFile(localeUsed) %>" type="text/css">
<TITLE></TITLE>
<H1><%= UIUtil.toHTML((String)FulfillmentNLS.get("Disposition")) %></H1>

<SCRIPT LANGUAGE="JavaScript">
<!---- hide script from old browsers

 	function setupDate()
	{
  		window.yearField = document.Disposition.YEAR1;
  		window.monthField = document.Disposition.MONTH1;
  		window.dayField = document.Disposition.DAY1;
	}

	function init() {
      		document.Disposition.YEAR1.value = getCurrentYear();
      		document.Disposition.MONTH1.value = getCurrentMonth();
      		document.Disposition.DAY1.value = getCurrentDay();
      	}


    	function onLoad()
    	{


      		if (parent.parent.setContentFrameLoaded) {
          	parent.parent.setContentFrameLoaded(true);
      		}
      		//parent.loadFrames();
		//parent.init();
    	}


	function validatePanelData()
	{
		var quantityD = trim(document.Disposition.DQUANTITY.value);
		var quantityTo = <%=strDispQuantity%>;

   	         if ( !isValidPositiveInteger(quantityD)) 
   	        {
		if (quantityD >= 2147483648) {
   			alertDialog('<%=UIUtil.toJavaScript((String)FulfillmentNLS.get("dispositionInvalidQuantity"))%>');
   			document.Disposition.DQUANTITY.select();
    			document.Disposition.DQUANTITY.focus();
   			return false;
		} else {

   			alertDialog('<%=UIUtil.toJavaScript((String)FulfillmentNLS.get("invalidQuantity"))%>');
   			document.Disposition.DQUANTITY.select();
    			document.Disposition.DQUANTITY.focus();
   			return false;
		}
   	         } else {
			if ( quantityD > quantityTo ) {
				alertDialog('<%=UIUtil.toJavaScript((String)FulfillmentNLS.get("invalidQuantity"))%>');
   				document.Disposition.DQUANTITY.select();
    				document.Disposition.DQUANTITY.focus();
   				return false;
			}
		} 
		
		if ( quantityD == 0 ) {
		  	alertDialog('<%=UIUtil.toJavaScript((String)FulfillmentNLS.get("invalidQuantity"))%>');
   			document.Disposition.DQUANTITY.select();
    			document.Disposition.DQUANTITY.focus();
   			return false;
		}

  		if (!validDate(document.Disposition.YEAR1.value , document.Disposition.MONTH1.value, document.Disposition.DAY1.value)){
    			alertDialog('<%=UIUtil.toJavaScript((String)FulfillmentNLS.get("invalidDate"))%>');
    			document.Disposition.YEAR1.select();
    			document.Disposition.YEAR1.focus();
    			return false;
  		}

  		var dispComment = document.Disposition.Comment.value;
  		if ( !isValidUTF8length( dispComment, 254 )) {
    			alertDialog('<%=UIUtil.toJavaScript((String)FulfillmentNLS.get("commentExceedMaxLength"))%>');
    			document.Disposition.Comment.select();
    			document.Disposition.Comment.focus();
    			return false;
  		}

  		return true;
	}


	function savePanelData()
	{

	var dispDate = trim(document.Disposition.YEAR1.value) + ':' + trim(document.Disposition.MONTH1.value) + ':' + trim(document.Disposition.DAY1.value); 
	var quant = trim(document.Disposition.DQUANTITY.value);
	var langId = '<%=strLangId%>';
	var storeId = '<%=strStoreId%>';
	var receiptId = '<%=UIUtil.toJavaScript(returnReceiptId)%>';
	var comment = trim(document.Disposition.Comment.value);
	if (comment == null) {
		comment = "";
	}
	var DReason = trim(document.Disposition.DReason.value);	
	var MReason = trim(document.Disposition.MReason.value);
	
	var RMA = '<%=UIUtil.toJavaScript(rmaId)%>';

        var redirectURL1 = "/webapp/wcs/tools/servlet/NewDynamicListView?ActionXMLFile=inventory.ReturnProductsList&cmd=ReturnProductsListView";
	var redirectURL = redirectURL1 + "&rmaid=" + RMA;

	var url = "/webapp/wcs/tools/servlet/ReturnItemComponentDispose"

	var urlParams = new Object();
	urlParams.quantity=quant;
	urlParams.storeId=storeId;
	urlParams.langId=langId;
	urlParams.receiptId=receiptId;
	urlParams.date=dispDate;
	urlParams.dispositionCode=DReason;
	urlParams.reason=MReason;
	urlParams.comment=comment; 
	urlParams.URL=redirectURL;

	if (top.setContent) 
	{
    		top.goBack();
		top.refreshBCT();
          	top.showContent(url,urlParams);

	}
	else 
	{
    		parent.parent.location.replace(url);
		top.refreshBCT();
	}
	}


// -->
</script>

<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/common/dynamiclist.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/common/DateUtil.js"></SCRIPT>

<META name="GENERATOR" content="IBM WebSphere Studio">
</HEAD>
<BODY ONLOAD="onLoad()" class="content">

<script language="javascript"><!--alert("Disposition.jsp");--></script> 

<SCRIPT FOR=document EVENT="onclick()"> 
document.all.CalFrame.style.display="none";
</SCRIPT>

<FORM NAME="Disposition">

<IFRAME STYLE="display:none;position:absolute;width:198;height:230;z-index=100" ID="CalFrame" TITLE="<%= calendarNLS.get("calendarTitle") %>" MARGINHEIGHT=0 MARGINWIDTH=0 NORESIZE FRAMEBORDER=0 SCROLLING=NO SRC="/webapp/wcs/tools/servlet/tools/common/Calendar.jsp"></IFRAME>



<%
          int startIndex = Integer.parseInt(request.getParameter("startindex"));
          int listSize = Integer.parseInt(request.getParameter("listsize"));
          int endIndex = startIndex + listSize;
          int rowselect = 1;
          int totalsize = numberOfpreviousIDs;
          int totalpage = totalsize/listSize;
	
%>

<P>
<TD><i><%=strDescription%></i> </TD>
<TD>&nbsp;</TD>
<TD>&nbsp;</TD>
<TD>&nbsp;</TD>
<TD><i><%=strSKU%></i></TD>	
<P>
<TD><%= UIUtil.toHTML((String)FulfillmentNLS.get("DCustomerRC")) %>  <i><%=strCustomerRR%></i> </TD>
<TD>&nbsp;</TD>
<TD>&nbsp;</TD>
<TD>&nbsp;</TD>
<TD><%= UIUtil.toHTML((String)FulfillmentNLS.get("DReceivedDate")) %>  <i><%=strReceivedDate%></i> </TD>
<P>
<TD><%= UIUtil.toHTML((String)FulfillmentNLS.get("DReceivedQuantity")) %>  <i><%=strReceivedQuantity%></i> </TD>
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
<TD>&nbsp;</TD>
<TD>&nbsp;</TD>
<TD>&nbsp;</TD>
<TD><%= UIUtil.toHTML((String)FulfillmentNLS.get("DQuantityTo")) %>  <i><%=strDispQuantity%></i> </TD>
<P>
<b><%= UIUtil.toHTML((String)FulfillmentNLS.get("DNewDisposition")) %></b>
<P>

<TABLE>
	<TR>
		<TD><LABEL><%= UIUtil.toHTML((String)FulfillmentNLS.get("DDispositionDate")) %></LABEL></TD>
	</TR>

	<TABLE>
         	<TR>
           		<TD><LABEL for="YEAR2"><%= UIUtil.toHTML((String)FulfillmentNLS.get("year")) %></LABEL></TD>
           		<TD>&nbsp;</TD>
           		<TD><LABEL for="MONTH2"><%= UIUtil.toHTML((String)FulfillmentNLS.get("month")) %></LABEL></TD>
           		<TD>&nbsp;</TD>
           		<TD><LABEL for="DAY2"><%= UIUtil.toHTML((String)FulfillmentNLS.get("day")) %></LABEL></TD>
         	</TR>
         	<TR>
           		<TD ><INPUT TYPE=TEXT VALUE="" NAME=YEAR1 ID="YEAR2" SIZE=4 MAXLENGTH=4></TD>
           		<TD></TD><TD><INPUT TYPE=TEXT VALUE="" NAME=MONTH1 ID="MONTH2" SIZE=2 MAXLENGTH=2></TD>
           		<TD></TD><TD><INPUT TYPE=TEXT VALUE="" NAME=DAY1 ID="DAY2" SIZE=2 MAXLENGTH=2></TD>
           		<TD>&nbsp;</TD>
           		<TD><A HREF="javascript:setupDate();showCalendar(document.Disposition.calImg)">
             		<IMG SRC="/wcs/images/tools/calendar/calendar.gif" ALT="<%=FulfillmentNLS.get("chooseDate")%>" BORDER=0 id=calImg></A></TD>   
         	</TR>
	</TABLE>
</TABLE>

<P>
		<TABLE>
         		<TR>
				<TD><LABEL for="DQUANTITY1"><%= UIUtil.toHTML((String)FulfillmentNLS.get("DQuantity")) %></LABEL> </TD>
				<TD>&nbsp;</TD>
           			<TD><LABEL for="MReason"><%= UIUtil.toHTML((String)FulfillmentNLS.get("DMerchantRR")) %></LABEL></TD>
           			<TD>&nbsp;</TD>
           			<TD><LABEL for="DReason"><%= UIUtil.toHTML((String)FulfillmentNLS.get("DDispositionR")) %></LABEL></TD>
         		</TR>
         		<TR>
				<TD><INPUT TYPE = TEXT VALUE = "" NAME=DQUANTITY ID="DQUANTITY1" SIZE=10 MAXLENGTH=10/> </TD>
           			<TD></TD><TD ><SELECT NAME=MReason ID="MReason" width="100%">
					<%int firstTime = 1;
    					for (int b=0; b< numberOfmerchantIDs ; b++) {
					String MRRId = (String) vecMRRId.elementAt(b);
      					String MRRName = (String) vecMRRName.elementAt(b);%>
      					<OPTION value="<%= MRRId %>" <%if (firstTime == 1) {%> SELECTED <%}%> >
      					<%= MRRName %></OPTION><%firstTime = 0;}%>
 				</SELECT></TD>
				<TD></TD><TD ><SELECT NAME=DReason ID="DReason" width="100%">
					<%int ffirstTime = 1;
    					for (int c=0; c< numberOfdispositionIDs ; c++) {
					String DRId = (String) vecDRId.elementAt(c);
      					String DRName = (String) vecDRName.elementAt(c);%>
      					<OPTION value="<%= DRId %>" <%if (ffirstTime == 1) {%> SELECTED <%}%> >
      					<%= DRName %></OPTION><%ffirstTime = 0;}%>
 				</SELECT></TD>

          		</TR>
		</TABLE>


<P>   
<TABLE border=0 cellspacing=0 cellpadding=0>
     <TR>
       <TD><LABEL for="COMMENT1"><%= UIUtil.toHTML((String)FulfillmentNLS.get("DComments")) %></LABEL> </TD>
     </TR>
     <TR>
       <TD><TEXTAREA NAME=Comment ID="COMMENT1" rows="3" cols="100" maxlength="254"></TEXTAREA></TD>
</TABLE>
  

<P>
<b><%= UIUtil.toHTML((String)FulfillmentNLS.get("DPreviousDisposition")) %></b>

<%=comm.startDlistTable((String)FulfillmentNLS.get("Disposition")) %>

<%= comm.startDlistRowHeading() %>

<%--//These next few rows get the header name from FulfillmentNLS file --%>

<%= comm.addDlistColumnHeading((String)FulfillmentNLS.get("DLDate"), null, false )%>
<%= comm.addDlistColumnHeading((String)FulfillmentNLS.get("DLQuantity"), null, false )%>
<%= comm.addDlistColumnHeading((String)FulfillmentNLS.get("DLDisposition"), null, false  )%>
<%= comm.addDlistColumnHeading((String)FulfillmentNLS.get("DLMerchantRR"), null, false  )%>
<%= comm.addDlistColumnHeading((String)FulfillmentNLS.get("DLComments"), null, false  )%>

<%= comm.endDlistRow() %>

<!-- Need to have a for loop to look for all pick batches -->
<%
    PreviousDispositionsDataBean listBean;
  
    if (endIndex > numberOfpreviousIDs){
      endIndex = numberOfpreviousIDs;
     }
    for (int i=startIndex; i<endIndex ; i++){
      listBean = previousIDs[i];

      String listDate = listBean.getDataBeanKeyDispositionDate();
      String formattedListDate = null;
      if (listDate == null){
        formattedListDate = "";
      }else{
         Timestamp tmp_createdDate = Timestamp.valueOf(listDate);
         formattedListDate = TimestampHelper.getDateFromTimestamp(tmp_createdDate, localeUsed );
	}

      String listComments = UIUtil.toHTML(listBean.getDataBeanKeyComments());
      if (listComments == null){
        listComments = "";
      }

      String listDisposition = UIUtil.toHTML(listBean.getDataBeanKeyDispositionDescription());
      if (listDisposition == null){
        listDisposition = "";
      }

      String listQuantity = listBean.getDataBeanKeyQuantity();
      if (listQuantity == null){
        listQuantity = "";
      }

      String listReason = UIUtil.toHTML(listBean.getDataBeanKeyReasonDescription());
      if (listReason == null){
        listReason = "";
      }
%>

<%=  comm.startDlistRow(rowselect) %>

<%= comm.addDlistColumn(formattedListDate, "none" ) %>
<%= comm.addDlistColumn(listQuantity, "none" ) %>
<%= comm.addDlistColumn(listDisposition, "none" ) %>
<%= comm.addDlistColumn(listReason, "none" ) %>
<%= comm.addDlistColumn(listComments, "none" ) %>

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
   if ( numberOfpreviousIDs == 0 ){
%>
<br>
<%= UIUtil.toHTML((String)FulfillmentNLS.get("DNoRows")) %>
<%
   }
%>

</FORM>
<SCRIPT LANGUAGE="JavaScript">
<!---- hide script from old browsers
  parent.afterLoads();
  // -->
</SCRIPT>

</BODY>
</HTML>
