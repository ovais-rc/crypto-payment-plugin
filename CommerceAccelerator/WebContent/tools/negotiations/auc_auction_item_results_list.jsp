<!-- ========================================================================
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2000, 2017
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
 ===========================================================================-->
<%@  page import="com.ibm.commerce.negotiation.beans.*" %>
<%@  page import="com.ibm.commerce.negotiation.bean.commands.*" %>
<%@  page import="com.ibm.commerce.negotiation.util.*" %>
<%@  page import="com.ibm.commerce.negotiation.helpers.*" %>
<%@  page import="com.ibm.commerce.ejb.helpers.SessionBeanHelper" %>
<%@  page import="com.ibm.commerce.negotiation.objects.*" %>
<%@  page import="com.ibm.commerce.negotiation.objimpl.*" %>
<%@  page import="com.ibm.commerce.negotiation.misc.*" %>
<%@  page import="com.ibm.commerce.negotiation.operation.*" %>
<%@  page import="com.ibm.commerce.tools.common.ui.taglibs.*" %>
<%@  page import="com.ibm.commerce.server.*" %>
<%@  page import="com.ibm.commerce.command.*" %>
<%@page import="com.ibm.commerce.tools.test.*" %>
<%@page import="com.ibm.commerce.tools.util.*" %>
<%@include file="../common/common.jsp" %>

<%
   String   emptyString = new String("");
   Integer  storeid = null;
   Integer  langid = null;
   Long     ownerid = null; 
   int      auctionLength = 0; 
   Locale   aLocale = null;


   //***Get storeid from CommandContext
   CommandContext aCommandContext = (CommandContext)request.getAttribute("CommandContext");    
   if( aCommandContext!= null )
   {
        langid = aCommandContext.getLanguageId();
        storeid = aCommandContext.getStoreId();
        aLocale = aCommandContext.getLocale();
   }

   //*** GET list size and start index ***//
   JSPHelper help = new JSPHelper(request);
   int listSize = Integer.parseInt((String) help.getParameter("listsize"));
   int startIndex = Integer.parseInt((String) help.getParameter("startindex"));
 
   String sku        = help.getParameter("sku");
%>

<HTML>
<HEAD>
<%= fHeader%>
<link rel=stylesheet href="<%= UIUtil.getCSSFile(aLocale) %>" type="text/css">
<%
     // obtain the resource bundle for display
     Hashtable auctionListNLS = (Hashtable)ResourceDirectory.lookup("negotiations.negotiationsNLS",aLocale);

%>
<TITLE><%= auctionListNLS.get("auctionlisttitle") %></TITLE>


<%
 
   Vector itemVector = new Vector(); 
   Vector auctionVector = new Vector();
   Enumeration enu = null;
   Long product_id = null;
   String auct_id = "";
   String auct_type = "";
   String auct_status = "";
   String auct_product = "";
   Double quantity = null;
   int    auct_quant = 0;

   AuctionJDBCHelperBean ah = SessionBeanHelper.lookupSessionBean(AuctionJDBCHelperBean.class);
   AuctionItemSortingAttribute aiSort = new AuctionItemSortingAttribute();
   itemVector = ah.findBuyableItemsByPartNumber(storeid, langid, ownerid, null, sku, false, aiSort);  

   if (itemVector.isEmpty()) {
       auctionLength = 0;
   }
   else {  
        for( int i = 0; i < itemVector.size();  i++) {
 
          AuctionItemDataBean aib = (AuctionItemDataBean) itemVector.elementAt(i); 
          product_id = aib.getCatentryId();
          try{
             AuctionAccessBean aab = new AuctionAccessBean();
             AuctionSortingAttribute aSort = new AuctionSortingAttribute();
           
             enu = aab.findAuctionsByItem(product_id, aSort);
             
             while (enu.hasMoreElements())
	     {
		AuctionAccessBean aab1 = (AuctionAccessBean) enu.nextElement();
		auctionVector.addElement(aab1); 	       
             }
            auctionLength = auctionVector.size();
          }
          catch (Exception e) { auctionLength = 0; }
       }    
   }  
int totalItems = auctionLength;  
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
	   if (defined(parent.buttons.buttonForm.changeAuctionButton)) {
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

 if ( temp_status == "F")  {
	   if (defined(parent.buttons.buttonForm.closeButton)) {
               parent.buttons.buttonForm.closeButton.id = 'disabled';
      	   parent.buttons.buttonForm.closeButton.className = 'disabled';
	   }
     }  
  
}
}


function goToSummary(auct_id)
{
   var url = "DialogView?XMLFile=negotiations.auctionSummaryDialog&auctionId=" + auct_id; 
   top.setContent(getSummaryAuctionBCT(), url, true);
}

function getResultsSize() { 
     return <%= totalItems %>; 
}

function getListSize() {
    return "<%= listSize %>"
}

function getUserNLSTitle() {
   return "<%= UIUtil.toJavaScript((String)auctionListNLS.get("auctionlisttitle")) %>"
}

parent.setResultssize(getResultsSize());


// -->
</SCRIPT>
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

<%= comm.addControlPanel("negotiations.auctionItemResultsListSC",totalpage,totalItems,aLocale) %>

<FORM NAME="auctionForm" action="AuctionItemResultsList" method="POST">

<INPUT TYPE="hidden" NAME="sku" VALUE="<%= sku %>">
<INPUT TYPE="hidden" NAME="auctStoreid" VALUE=<%= storeid %>>
<INPUT TYPE="hidden" NAME="auctid" VALUE="">
<INPUT TYPE="HIDDEN" NAME="startindex" VALUE="">
<INPUT TYPE="HIDDEN" NAME="listsize" VALUE="">
 
<%= comm.startDlistTable(nul) %>
<%= comm.startDlistRowHeading() %>
<%= comm.addDlistCheckHeading(true,"parent.selectDeselectAll();userInitialButtons();myRefreshButtons();") %>
<%= comm.addDlistColumnHeading(UIUtil.toHTML((String)auctionListNLS.get("auctionId")), "none", false) %>
<%= comm.addDlistColumnHeading(UIUtil.toHTML((String)auctionListNLS.get("AuctType")), "none", false) %>
<%= comm.addDlistColumnHeading(UIUtil.toHTML((String)auctionListNLS.get("SKU")), "none", false) %>
<%= comm.addDlistColumnHeading(UIUtil.toHTML((String)auctionListNLS.get("auctionStatus")), "none", false) %>
<%= comm.addDlistColumnHeading(UIUtil.toHTML((String)auctionListNLS.get("auctionQuantity")), "none", false) %>
<%= comm.endDlistRow() %>

<%
              
             int rowselect = 1;
  
             int endIndex = startIndex + listSize;
             if ( endIndex > auctionLength )
             endIndex= auctionLength;

             for (int i = startIndex; i < endIndex ; i++) {

	        AuctionAccessBean auction = (AuctionAccessBean) auctionVector.elementAt(i);
	        auct_id = auction.getId();
    		  auct_type = auction.getAuctionType();
              auct_status = auction.getStatus();
              auct_product = auction.getEntryId();
              quantity = auction.getQuantityInEntityType();
              String quant_str = (new Integer(quantity.intValue())).toString();
%>

<%= comm.startDlistRow(rowselect) %>
<%= comm.addDlistCheck(auct_id, "parent.setChecked();myRefreshButtons()",auct_id + "," + auct_status) %>
<%= comm.addDlistColumn(UIUtil.toHTML(auct_id), "javascript:goToSummary(" + auct_id + ")") %>

<%     if ( auct_type.equals("O") ) {
%>
<%= comm.addDlistColumn(UIUtil.toHTML((String)auctionListNLS.get("opencry")), "none") %>
<%      } else if ( auct_type.equals("SB")  ) {
%>
<%= comm.addDlistColumn(UIUtil.toHTML((String)auctionListNLS.get("sealedbid")), "none") %>
<%      } else if ( auct_type.equals("D")  ) {
%>
<%= comm.addDlistColumn(UIUtil.toHTML((String)auctionListNLS.get("dutch")), "none") %>
<%      } else {
%>
<%= comm.addDlistColumn(UIUtil.toHTML(auct_type), "none") %>
<%      }
%>
<%= comm.addDlistColumn(sku, "none") %>
<%     if ( auct_status.equals("C") ) {
%>
<%= comm.addDlistColumn(UIUtil.toHTML((String)auctionListNLS.get("currentStatus")), "none") %>
<%      } else if ( auct_status.equals("F") ) {
%>
<%= comm.addDlistColumn(UIUtil.toHTML((String)auctionListNLS.get("futureStatus")), "none") %>
<%      } else if ( auct_status.equals("R") ) {
%>
<%= comm.addDlistColumn(UIUtil.toHTML((String)auctionListNLS.get("retractedStatus")), "none") %>

<%      } else if ( auct_status.equals("BC") ) {
%>
<%= comm.addDlistColumn(UIUtil.toHTML((String)auctionListNLS.get("biddingClosedStatus")), "none") %>
<%      } else if ( auct_status.equals("SC") ) {
%>
<%= comm.addDlistColumn(UIUtil.toHTML((String)auctionListNLS.get("settlementClosedStatus")), "none") %>
<%      } else {
%>   
<%= comm.addDlistColumn(UIUtil.toHTML(auct_status), "none") %>
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
	if (auctionLength <= 0) {
%>
	<P>
	<P>
	<%= UIUtil.toHTML((String)auctionListNLS.get("emptyAuctionSearchList")) %>
<% 
	}
%>

</FORM>
<SCRIPT LANGUAGE="Javascript">
   parent.afterLoads();
</SCRIPT>
</BODY>
</HTML>

