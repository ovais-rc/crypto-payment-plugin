<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2000, 2016 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<%@  page import="com.ibm.commerce.negotiation.beans.*" %>
<%@  page import="com.ibm.commerce.negotiation.bean.commands.*" %>
<%@  page import="com.ibm.commerce.negotiation.util.*" %>
<%@  page import="com.ibm.commerce.negotiation.misc.*" %>
<%@  page import="com.ibm.commerce.negotiation.operation.*" %>
<%@  page import="com.ibm.commerce.catalog.objects.*" %>
<%@  page import="com.ibm.commerce.command.*" %>
<%@  page import="com.ibm.commerce.tools.test.*" %>
<%@  page import="com.ibm.commerce.tools.util.*" %>
<%@  page import="com.ibm.commerce.tools.common.ui.taglibs.*" %>
<%@  page import="com.ibm.commerce.server.*" %>
<%@  page import="com.ibm.commerce.exception.*" %>
<%@include file="../common/common.jsp" %>

<%
try
{


   Double  quantity = null;
   int     quant_ds = 0;
   String  StoreId = "0";
   Locale   aLocale = null;

   //***Get storeid from CommandContext
   CommandContext aCommandContext = (CommandContext)request.getAttribute("CommandContext");    
   String ErrorMessage = request.getParameter(com.ibm.commerce.tools.common.ui.UIProperties.SUBMIT_ERROR_MESSAGE);
   if (ErrorMessage == null)
	ErrorMessage = "";

   if( aCommandContext!= null )
   {
        StoreId = aCommandContext.getStoreId().toString();
        aLocale = aCommandContext.getLocale();
   }

   String selected_type = request.getParameter("auctType");

     // obtain the resource bundle for display
     Hashtable auctionListNLS = (Hashtable)ResourceDirectory.lookup("negotiations.negotiationsNLS",aLocale);

     //*** GET list size and start index ***//
     JSPHelper help = new JSPHelper(request);
     int listSize = Integer.parseInt((String) help.getParameter("listsize"));
     int startIndex = Integer.parseInt((String) help.getParameter("startindex"));
     String theOption = "0";

%>

<HTML>
<HEAD>
<%= fHeader%>
<link rel=stylesheet href="<%= UIUtil.getCSSFile(aLocale) %>" type="text/css">
<TITLE><%= auctionListNLS.get("auctionlisttitle") %></TITLE>
     <jsp:useBean id="auctionList" class="com.ibm.commerce.negotiation.beans.AuctionInfoListBean" >
     <jsp:setProperty property="auctStoreId" name="auctionList" value="<%= StoreId %>" />
<% 
   if(selected_type!=null && selected_type.equals("O")) {
%>
     <jsp:setProperty property="auctType"    name="auctionList" value="O" />
<%
     theOption = "1";
    } else if(selected_type!=null && selected_type.equals("SB")) { 
%>
     <jsp:setProperty property="auctType"    name="auctionList" value="SB" />
<%
     theOption = "2";
   } else if(selected_type!=null && selected_type.equals("D")) { 
%>
     <jsp:setProperty property="auctType"    name="auctionList" value="D" />
<%
     theOption = "3";
   } %>     
     </jsp:useBean>

<%
  
  com.ibm.commerce.negotiation.util.AuctionInfoSortingAttribute aSort
       = new com.ibm.commerce.negotiation.util.AuctionInfoSortingAttribute();

  String sortBy = help.getParameter("orderby");
 
  if ( sortBy != null && !sortBy.equals("null") && !sortBy.equals("") ) {
     aSort.addSorting(sortBy, true);
     auctionList.setSortAtt(aSort);
  }

  com.ibm.commerce.beans.DataBeanManager.activate(auctionList, request);

  AuctionInfoDataBean ab;

  AuctionInfoDataBean[] auctions = auctionList.getAuctions();
  int len = auctions.length;
  int totalItems = len;
  
%>
<%!
   // move this function from list.jsp to the local file since the length is only need on the server by
   // the implemented list and not List.jsp
   public int getResultsSize(AuctionInfoListBean auctionList) 
   {
     return auctionList.getAuctions().length;
   }
%>

<SCRIPT LANGUAGE="JavaScript">
<!---- hide script from old browsers

function isButtonDisabled(b) {
    if (b.className =='disabled' &&	b.id == 'disabled')
	return true;
    return false;
}

function userInitialButtons() {
	if (defined(parent.buttons.buttonForm.changeAuctionButton)) 
	{
         parent.buttons.buttonForm.changeAuctionButton.id = 'disabled';
         parent.buttons.buttonForm.changeAuctionButton.className = 'disabled';
	}
      if (defined(parent.buttons.buttonForm.summaryAuctionButton)) 
	{
         parent.buttons.buttonForm.summaryAuctionButton.id = 'disabled';
         parent.buttons.buttonForm.summaryAuctionButton.className = 'disabled';
	}
      if (defined(parent.buttons.buttonForm.bidsButton)) 
	{
         parent.buttons.buttonForm.bidsButton.id = 'disabled';
         parent.buttons.buttonForm.bidsButton.className = 'disabled';
	}
      if (defined(parent.buttons.buttonForm.discussionButton)) 
	{
         parent.buttons.buttonForm.discussionButton.id = 'disabled';
         parent.buttons.buttonForm.discussionButton.className = 'disabled';
	}
      if (defined(parent.buttons.buttonForm.retractButton)){
         parent.buttons.buttonForm.retractButton.id = 'disabled';
         parent.buttons.buttonForm.retractButton.className = 'disabled';
	}
    	if (defined(parent.buttons.buttonForm.closeButton)) {
         parent.buttons.buttonForm.closeButton.id = 'disabled';
         parent.buttons.buttonForm.closeButton.className = 'disabled';
	}
      myRefreshButtons();
}

function performDelete() {
  if(isButtonDisabled(parent.buttons.buttonForm.retractButton))
    return;
  if (confirmDialog("<%= UIUtil.toJavaScript((String)auctionListNLS.get("retractauction")) %>")) {
    document.auctionForm.auctid.value = parent.getChecked();
    document.auctionForm.startindex.value = "0";
    document.auctionForm.listsize.value = getListSize();
    document.auctionForm.orderby.value = getSortby();
    document.auctionForm.action = "DeleteAuction";
    deSelectAll();
    parent.page = 1;
    document.auctionForm.submit();
  }
}

function performDelete2() {
  if(isButtonDisabled(parent.buttons.buttonForm.closeButton))
    return;
  if (confirmDialog("<%= UIUtil.toJavaScript((String)auctionListNLS.get("closeauction")) %>")) {
    document.auctionForm.auctid.value = parent.getChecked();
    document.auctionForm.startindex.value = "0";
    document.auctionForm.listsize.value = getListSize();
    document.auctionForm.orderby.value = getSortby();
    document.auctionForm.action = "CloseBidding";
    deSelectAll();
    parent.page = 1;
    document.auctionForm.submit();
  }
}

function performChange() {
  if(isButtonDisabled(parent.buttons.buttonForm.changeAuctionButton))
    return;
  top.setContent(getChangeAuctionBCT(),'/webapp/wcs/tools/servlet/NotebookView?XMLFile=negotiations.auctionNotebook&amp;auctionId=' + parent.getChecked(),true);
}

function onLoad() {
  parent.loadFrames()
}

function getType() {
  return "<%= UIUtil.toJavaScript(selected_type) %>";
}

function getNewAuctionBCT() {
  return "<%= UIUtil.toJavaScript((String)auctionListNLS.get("newAuctionBCT")) %>";
}

function getChangeAuctionBCT() {
  return "<%= UIUtil.toJavaScript((String)auctionListNLS.get("changeAuctionBCT")) %>";
}

function getSummaryAuctionBCT() {
  return "<%= UIUtil.toJavaScript((String)auctionListNLS.get("summaryAuctionBCT")) %>";
}

function getAuctionBidsBCT() {
  return "<%= UIUtil.toJavaScript((String)auctionListNLS.get("auctionBidsBCT")) %>";
}

function getAuctionDiscussionBCT() {
  return "<%= UIUtil.toJavaScript((String)auctionListNLS.get("auctionDiscussionBCT")) %>";
}

function getFindAuctionBCT() {
  return "<%= UIUtil.toJavaScript((String)auctionListNLS.get("findAuctionBCT")) %>";
}

function myRefreshButtons(){
  parent.refreshButtons();

  if(typeof parent.checkValueHashtable == "undefined")
    parent.checkValueHashtable = new Object();

  var theArray = new Array;
  var temp;
 
  for (var i=0; i<document.auctionForm.elements.length; i++) {
      if (document.auctionForm.elements[i].type == 'checkbox')
        if (document.auctionForm.elements[i].checked)
           parent.checkValueHashtable[document.auctionForm.elements[i].name] = document.auctionForm.elements[i].value;
 }

  var temp2;
  var checked = new String(parent.getChecked());
  if(checked == "") return;

  temp2 = checked.split(",");
  for (var j = 0; j < temp2.length; j++)
  {
    theArray[j] = parent.checkValueHashtable[temp2[j]];
  }


  if (theArray.length == 1 ) {

    temp = theArray[0].split(",");
    temp_id = temp[0];
    temp_status = temp[1];

    if ( temp_status != "C" && temp_status != "F" ) 
    {  
	if (defined(parent.buttons.buttonForm.changeAuctionButton)) 
	{
	  parent.buttons.buttonForm.changeAuctionButton.id = 'disabled';
	  parent.buttons.buttonForm.changeAuctionButton.className = 'disabled';
	}
    }
    
    if ( temp_status == "R" || temp_status == "BC" || temp_status == "SC") {
	   if (defined(parent.buttons.buttonForm.retractButton)){
      	   parent.buttons.buttonForm.retractButton.id = 'disabled';
      	   parent.buttons.buttonForm.retractButton.className = 'disabled';
	   }
    	   if (defined(parent.buttons.buttonForm.closeButton)) {
      	   parent.buttons.buttonForm.closeButton.id = 'disabled';
      	   parent.buttons.buttonForm.closeButton.className = 'disabled';
	   }
    }

    if ( temp_status == "F") 
    {
	 if (defined(parent.buttons.buttonForm.closeButton)) 
	{
           parent.buttons.buttonForm.closeButton.id = 'disabled';
           parent.buttons.buttonForm.closeButton.className = 'disabled';
      }

    }  
  
}
// added for the defect # 13512
  
  if (theArray.length > 1 ) {
      var flag=0;
      var future = 0;

      for (var i=0; i<theArray.length; i++) {
        temp = theArray[i].split(",");
       	temp_id = temp[0];
      	temp_status = temp[1];

      	if ( temp_status == "R" || temp_status == "BC" || temp_status == "SC") 	{
      		flag=1;
      	}

      	else if ( temp_status == "F") 
	{
      		future=1; // future auction found
      	}

      }

     if(future == 1){
	if (defined(parent.buttons.buttonForm.closeButton)) {
         parent.buttons.buttonForm.closeButton.id = 'disabled';
         parent.buttons.buttonForm.closeButton.className = 'disabled';
	}

     }

      if(flag==1){
	if (defined(parent.buttons.buttonForm.retractButton)){
           parent.buttons.buttonForm.retractButton.id = 'disabled';
           parent.buttons.buttonForm.retractButton.className = 'disabled';
        }
        if (defined(parent.buttons.buttonForm.closeButton)) {
   	     parent.buttons.buttonForm.closeButton.id = 'disabled';
   	     parent.buttons.buttonForm.closeButton.className = 'disabled';
   	}

     }
  
  }  
  // defect # 13512

  
  
}

// This function currently handles only errors.
function handleErrorOrSuccess()
{
   var FinishMessage = "<%= UIUtil.toJavaScript(ErrorMessage) %>";
   if (FinishMessage != null && FinishMessage !="")
	alertDialog(FinishMessage);
}

function goToSummary(auct_id)
{
   var url = "DialogView?XMLFile=negotiations.auctionSummaryDialog&auctionId=" + auct_id; 
   top.setContent(getSummaryAuctionBCT(), url, true);

}

function getResultsSize() { 
     return <%= totalItems %>; 
}

function getSortby() {
     return "<%= UIUtil.toJavaScript(sortBy) %>";
}

function getListSize() {
    return "<%= listSize %>"
}

function getUserNLSTitle() {
   return "<%= UIUtil.toJavaScript((String)auctionListNLS.get("auctionlisttitle")) %>"
}

parent.setResultssize(getResultsSize());

// -->
</script>
<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/common/dynamiclist.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/negotiations/auc_commonlist.js"></SCRIPT>
</HEAD>
<BODY class="content_list">

<SCRIPT LANGUAGE="JavaScript">

<!--
//For IE
if (document.all) {
    onLoad();
}
handleErrorOrSuccess();

//-->

</SCRIPT>

<%
  int totalpage = totalItems/listSize;
  // addControlPanel adds 1 to the page count which is ok unless the division doesn't result in a remainder
   if(totalItems == totalpage * listSize)
   {
     totalpage--;
   }
   String nul = null;
%>

<%= comm.addControlPanel("negotiations.auctionListSC",totalpage,totalItems,aLocale) %>

<FORM NAME="auctionForm" action="AuctionList?" method="POST">

<INPUT TYPE="hidden" NAME="auctStoreid" VALUE=<%= StoreId %>>
<INPUT TYPE="hidden" NAME="auctType" VALUE=<%= UIUtil.toHTML(selected_type) %>>
<INPUT TYPE="hidden" NAME="auctid" VALUE="">
<INPUT TYPE="HIDDEN" NAME="startindex" VALUE="">
<INPUT TYPE="HIDDEN" NAME="listsize" VALUE="">
<INPUT TYPE="HIDDEN" NAME="orderby" VALUE="">
 
<%= comm.startDlistTable(nul) %>
<%= comm.startDlistRowHeading() %>
<%= comm.addDlistCheckHeading(true,"parent.selectDeselectAll();userInitialButtons();myRefreshButtons();") %>
<%= comm.addDlistColumnHeading(UIUtil.toHTML((String)auctionListNLS.get("auctionId")), aSort.ID, 
sortBy.equals(aSort.ID)) %>
<%= comm.addDlistColumnHeading(UIUtil.toHTML((String)auctionListNLS.get("AuctType")), aSort.AUCTION_TYPE, sortBy.equals(aSort.AUCTION_TYPE)) %>
<%= comm.addDlistColumnHeading(UIUtil.toHTML((String)auctionListNLS.get("SKU")), "none", false) %>
<%= comm.addDlistColumnHeading(UIUtil.toHTML((String)auctionListNLS.get("auctionStatus")), aSort.STATUS, sortBy.equals(aSort.STATUS)) %>
<%= comm.addDlistColumnHeading(UIUtil.toHTML((String)auctionListNLS.get("auctionQuantity")), aSort.QUANTITY, sortBy.equals(aSort.QUANTITY)) %>
<%= comm.endDlistRow() %>

<%

int rowselect = 1;  

  int endIndex = startIndex + listSize;
  if (endIndex > getResultsSize(auctionList))
    endIndex=getResultsSize(auctionList);
    
  //len = endIndex;  
  String product_id = "";
  String sku = "";
   
  for (int i = startIndex; i < endIndex ; i++) {
      
     ab = auctions[i];
       
     //Get SKU
     product_id = ab.getEntryId();
     CatalogEntryAccessBean cb = new CatalogEntryAccessBean(); 
     cb.setInitKey_catalogEntryReferenceNumber(product_id);
     sku = cb.getPartNumber();
     quantity = ab.getQuantityInEntityType();
     String quant_str = (new Integer(quantity.intValue())).toString();
      
%>

<%= comm.startDlistRow(rowselect) %>
<%= comm.addDlistCheck(ab.getId().trim(), "parent.setChecked();myRefreshButtons()",ab.getId().trim() + "," + ab.getStatus().trim()) %>
<%= comm.addDlistColumn(UIUtil.toHTML(ab.getId()), "javascript:goToSummary(" + ab.getId() + ")") %>

<%     if ( (ab.getAuctionType().trim()).equals("O") ) {
%>
<%= comm.addDlistColumn(UIUtil.toHTML((String)auctionListNLS.get("opencry")), "none") %>
<%      } else if ( (ab.getAuctionType().trim()).equals("SB")  ) {
%>
<%= comm.addDlistColumn(UIUtil.toHTML((String)auctionListNLS.get("sealedbid")), "none") %>
<%      } else if ( (ab.getAuctionType().trim()).equals("D")  ) {
%>
<%= comm.addDlistColumn(UIUtil.toHTML((String)auctionListNLS.get("dutch")), "none") %>
<%      } else {
%>
<%= comm.addDlistColumn(UIUtil.toHTML(ab.getAuctionType().trim()), "none") %>
<%      }
%>

<%= comm.addDlistColumn(UIUtil.toHTML(sku), "none") %>

<%     if ( (ab.getStatus().trim()).equals("C") ) {
%>
<%= comm.addDlistColumn(UIUtil.toHTML((String)auctionListNLS.get("currentStatus")), "none") %>
<%      } else if ( (ab.getStatus().trim()).equals("F") ) {
%>
<%= comm.addDlistColumn(UIUtil.toHTML((String)auctionListNLS.get("futureStatus")), "none") %>
<%      } else if ( (ab.getStatus().trim()).equals("R") ) {
%>
<%= comm.addDlistColumn(UIUtil.toHTML((String)auctionListNLS.get("retractedStatus")), "none") %>
<%      } else if ( (ab.getStatus().trim()).equals("BC") ) {
%>
<%= comm.addDlistColumn(UIUtil.toHTML((String)auctionListNLS.get("biddingClosedStatus")), "none") %>
<%      } else if ( (ab.getStatus().trim()).equals("SC") ) {
%>
<%= comm.addDlistColumn(UIUtil.toHTML((String)auctionListNLS.get("settlementClosedStatus")), "none") %>
<%      } else {
%>   
<%= comm.addDlistColumn(UIUtil.toHTML(ab.getStatus().trim()), "none") %>
<%      }
%>

<%= comm.addDlistColumn(quant_str, "none") %>
<%= comm.endDlistRow() %>

<%
     if(rowselect==1){
       rowselect = 2;
     }
     else{
       rowselect = 1;
     } 
  }
%>

<%= comm.endDlistTable() %>

<%
	if (getResultsSize(auctionList) <= 0) {
%>
	<P>
	<P>
	<%= UIUtil.toHTML((String)auctionListNLS.get("emptyAuctionList")) %>
<% 
	}
%>
</FORM>
<SCRIPT LANGUAGE="Javascript">
   parent.afterLoads();
   parent.setoption(<%= theOption %>);
</SCRIPT>
</BODY>
</HTML>

<%
}
catch(Exception e)
{
   ExceptionHandler.displayJspException(request, response, e);
}
%>

