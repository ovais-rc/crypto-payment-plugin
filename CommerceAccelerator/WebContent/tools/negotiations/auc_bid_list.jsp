<!-- ========================================================================
 Licensed Materials - Property of IBM

 WebSphere Commerce

 (c) Copyright IBM Corp. 2000, 2002

US Government Users Restricted Rights - Use, duplication or
disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
===========================================================================-->

<%@page import=	"com.ibm.commerce.tools.test.*, 
			com.ibm.commerce.tools.util.*, 
                  com.ibm.commerce.tools.common.ui.taglibs.*, 
			com.ibm.commerce.negotiation.beans.*, 			
			com.ibm.commerce.user.objects.*,
			com.ibm.commerce.base.helpers.*,
			com.ibm.commerce.negotiation.util.*,
			com.ibm.commerce.negotiation.misc.*, 
			com.ibm.commerce.negotiation.operation.*,  
			com.ibm.commerce.user.beans.*,
			com.ibm.commerce.common.objects.*,
			com.ibm.commerce.price.utils.*, 
			com.ibm.commerce.command.*, 
                  com.ibm.commerce.server.*,
                  com.ibm.commerce.exception.*,
			java.math.*" %>

<%@include file="../common/common.jsp" %>

<%
try
{

      //*** GET LANGID AND STOREID FROM COMANDCONTEXT ***//
      CommandContext aCommandContext = (CommandContext)request.getAttribute("CommandContext");    
 	String   StoreId = "0";
	String   lang =  "-1";  
	Locale   locale_obj = null;
      if( aCommandContext!= null ){
            lang = aCommandContext.getLanguageId().toString();
		locale_obj = aCommandContext.getLocale();
            StoreId = aCommandContext.getStoreId().toString();
      }
	if (locale_obj == null)
		locale_obj = new java.util.Locale("en","US");

     //*** GET CURRENCY  ***//
     StoreAccessBean storeAB = com.ibm.commerce.registry.StoreRegistry.singleton().find(new Integer(StoreId)); 
     
     CurrencyManager cm = CurrencyManager.getInstance();
     Integer defaultLanguageId = new Integer(Integer.parseInt(lang));
     String defaultCurrency = cm.getDefaultCurrency(storeAB, defaultLanguageId);    

     FormattedMonetaryAmount fmt = null;
     BigDecimal d= null;

	//*** OBTAIN THE RESOURCE BUNDLE BASED ON LOCALE ***//
	Hashtable neg_properties = (Hashtable)ResourceDirectory.lookup("negotiations.negotiationsNLS",locale_obj);
	JSPHelper help = new JSPHelper(request);
	String ErrorMessage= (String)help.getParameter(com.ibm.commerce.tools.common.ui.UIProperties.SUBMIT_ERROR_MESSAGE);
	if (ErrorMessage == null) ErrorMessage = "";

      //*** GET list size and start index ***//
      int listSize = Integer.parseInt((String) help.getParameter("listsize"));
      int startIndex = Integer.parseInt((String) help.getParameter("startindex"));

%>

<HTML>
<HEAD>
<%= fHeader%>
<link rel=stylesheet href="<%= UIUtil.getCSSFile(locale_obj) %>" type="text/css">
<TITLE><%= neg_properties.get("bidlisttitle") %></TITLE>

<jsp:useBean id="bidList" class="com.ibm.commerce.negotiation.beans.BidListBean" >
<jsp:setProperty property="*" name="bidList" />
</jsp:useBean>

<%!
   // move this function from list.jsp to the local file since the length is only need on the server by
   // the implemented list and not List.jsp
   public int getResultsSize(com.ibm.commerce.negotiation.beans.BidDataBean[] bidData) 
   {
     return bidData.length;
   }   
%>

<%
	String aucrfn = (String)help.getParameter("aucrfn");
	bidList.setBidAuctionId(aucrfn);
	BidSortingAttribute sa = new BidSortingAttribute();
	// Obtain the Sort Order, if any.
	String sortBy = (String)help.getParameter("orderby");

	if (sortBy != null && !sortBy.equals("") && !sortBy.equals(""))
		sa.addSorting(sortBy,true);
	else
		sa.addSorting(sa.REFERENCE_CODE,true);
	
	bidList.setSortAtt(sa);

	com.ibm.commerce.beans.DataBeanManager.activate(bidList, request); 
	BidDataBean[] bidData = bidList.getBids();
      int totalItems = bidData.length;
%>

<SCRIPT LANGUAGE="Javascript">
<!---- hide script from old browsers

function onLoad() 
{
   parent.loadFrames()
}

// This function currently handles only errors.
function handleErrorOrSuccess()
{
   var FinishMessage = "<%= UIUtil.toJavaScript(ErrorMessage) %>";
   if (FinishMessage != null && FinishMessage !="")
	alertDialog(FinishMessage);
}

function getResultsSize() { 
     return <%= totalItems %>; 
}

function getSortby() {
     return "<%= sortBy %>";
}

function getListSize() {
    return "<%= listSize %>"
}

function getUserNLSTitle() {
   return "<%= UIUtil.toJavaScript((String)neg_properties.get("bidlisttitle")) %>"
}

parent.setResultssize(getResultsSize());

//-->
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
handleErrorOrSuccess();
//-->
</SCRIPT>

<jsp:useBean id="anAuction" class="com.ibm.commerce.negotiation.beans.AuctionDataBean" >
<jsp:setProperty property="*" name="anAuction" />     
<jsp:setProperty property="auctionId" name="anAuction" value="<%= aucrfn %>" />                                                 
</jsp:useBean>

<%
String prrfnbr = null;
String currency = null;
String product_Desc = null;
String AucStatus = null;
String AucType = null;
com.ibm.commerce.beans.DataBeanManager.activate(anAuction, request);                                           
prrfnbr = anAuction.getEntryId();                   
currency = anAuction.getCurrency();
AucStatus  = anAuction.getStatus();
AucType  = anAuction.getAuctionType();
               
//get product description    
if (prrfnbr != null && !prrfnbr.equals(""))
{ %>    
                   
<jsp:useBean id="anItem" class="com.ibm.commerce.catalog.beans.CatalogEntryDataBean" >
<jsp:setProperty property="*" name="anItem" />
<jsp:setProperty property="catalogEntryID" name="anItem" value="<%= prrfnbr %>" />
</jsp:useBean>  


<% 
	com.ibm.commerce.beans.DataBeanManager.activate(anItem, request);
	if (anItem != null) {
		com.ibm.commerce.catalog.objects.CatalogEntryDescriptionAccessBean ca = null;
		ca = anItem.getDescription(Integer.valueOf(lang));
		if (ca!=null)
			product_Desc = ca.getShortDescription();                
	}
}                      
%>  

<%
  int totalpage = totalItems/listSize;
  // addControlPanel adds 1 to the page count which is ok unless the division doesn't result in a remainder
   if(totalItems == totalpage * listSize)
   {
     totalpage--;
   }
   String nul = null;
%>

<%= comm.addControlPanel("negotiations.bidList",totalpage,totalItems,locale_obj) %>

<FORM NAME="bidForm" ACTION="AdminBidList?">
<INPUT TYPE="HIDDEN" NAME="aucrfn" VALUE="<%= aucrfn %>">
<INPUT TYPE="HIDDEN" NAME="bid_id" VALUE="">
<INPUT TYPE="HIDDEN" NAME="productId" VALUE="<%= prrfnbr %>">
<INPUT TYPE="HIDDEN" NAME="viewname" VALUE="AdminBidList">
<INPUT TYPE="HIDDEN" NAME="startindex" VALUE="">
<INPUT TYPE="HIDDEN" NAME="listsize" VALUE="">
<INPUT TYPE="HIDDEN" NAME="orderby" VALUE="">

<%= comm.startDlistTable(nul) %>
<%= comm.startDlistRowHeading() %>
<%= comm.addDlistCheckHeading(true,"parent.selectDeselectAll();userInitialButtons();myRefreshButtons();") %>
<%= comm.addDlistColumnHeading(UIUtil.toHTML((String)neg_properties.get("shopperName")), "none", false) %>
<%= comm.addDlistColumnHeading(UIUtil.toHTML((String)neg_properties.get("auctionId")), "none", false) %>
<%= comm.addDlistColumnHeading(UIUtil.toHTML((String)neg_properties.get("bidAmount")), BidTable.BID_PRICE, sortBy.equals(BidTable.BID_PRICE)) %>
<%= comm.addDlistColumnHeading(UIUtil.toHTML((String)neg_properties.get("bidquantity")), BidTable.BID_QUANTITY, sortBy.equals(BidTable.BID_QUANTITY)) %>
<%= comm.addDlistColumnHeading(UIUtil.toHTML((String)neg_properties.get("bidNumber")), BidTable.REFERENCE_CODE, sortBy.equals(BidTable.REFERENCE_CODE)) %>
<%= comm.addDlistColumnHeading(UIUtil.toHTML((String)neg_properties.get("bidstatus")), BidTable.STATUS, sortBy.equals(BidTable.STATUS)) %>
<%= comm.endDlistRow() %>

<%
int rowselect = 1;

String BidId = null;
String BidReferenceNumber = null;
String BidStatus = null;
String BidValue = null;
String BidQuantity = null;
String ShopperName = "";
String ShopperId = "";
String LogonId = "";
Object parms[] = null;
int endIndex = startIndex + listSize -1;

if (endIndex > getResultsSize(bidData))
    endIndex=getResultsSize(bidData);

for(int i=0; i< bidData.length; i++){    
      if (i < startIndex)
			continue;
	if (i > endIndex)
			break;

      BidId 			= bidData[i].getId();   
      BidReferenceNumber 	= bidData[i].getReferenceCode();   
      BidStatus 			= bidData[i].getStatus();
      BidValue 			= bidData[i].getBidPrice();                         
      BidQuantity 		= bidData[i].getBidQuantity();                       
      ShopperId 			= bidData[i].getOwnerId();    
	
	UserInfoDataBean tempUser = new UserInfoDataBean();
	tempUser.setUserId(ShopperId);
	String f_name = "", m_name = "", l_name="";
	try{
	com.ibm.commerce.beans.DataBeanManager.activate(tempUser, request);
	
	
      if (tempUser.getFirstName() != null)
		f_name = tempUser.getFirstName();
      if (tempUser.getMiddleName() != null)
		m_name = tempUser.getMiddleName();
      if (tempUser.getLastName() != null)
		l_name = tempUser.getLastName();
      }
 
      catch(Exception e)
      {                                                      
      	f_name= "-";
      	m_name= "-";
      	l_name= "-";
      } 

     ShopperName = (String)neg_properties.get("author");
     parms = new Object[4];
     parms[0] = f_name;
     parms[1] = m_name;
     parms[2] = l_name;
     ShopperName = java.text.MessageFormat.format(ShopperName, parms);

	if (BidStatus.equals(AuctionConstants.EC_BID_STATUS_RETRACTED))
		BidStatus = (String)neg_properties.get("retractedState");
	else if (BidStatus.equals(AuctionConstants.EC_BID_STATUS_DELETED))
		BidStatus = (String)neg_properties.get("deletedState");
	else if (BidStatus.equals(AuctionConstants.EC_BID_STATUS_ACTIVE))
		BidStatus = (String)neg_properties.get("activeState");
	else if (BidStatus.equals(AuctionConstants.EC_BID_STATUS_SUPERSEDED))
		BidStatus = (String)neg_properties.get("supersededState");
	else if (BidStatus.equals(AuctionConstants.EC_BID_STATUS_WINNING))
		BidStatus = (String)neg_properties.get("winningState");
	else if (BidStatus.equals(AuctionConstants.EC_BID_ORDER_STATUS_FAILED))
		BidStatus = (String)neg_properties.get("orderFailedState");
	else if (BidStatus.equals(AuctionConstants.EC_BID_ORDER_STATUS_COMPLETED))
		BidStatus = (String)neg_properties.get("orderCompleteState");
%>

<%= comm.startDlistRow(rowselect) %>
<%= comm.addDlistCheck(BidId, "parent.setChecked();myRefreshButtons()",BidStatus.trim()) %>
<%= comm.addDlistColumn(UIUtil.toHTML(ShopperName), "none") %>
<%= comm.addDlistColumn(UIUtil.toHTML(aucrfn), "none") %>

<%
	d   = new BigDecimal(BidValue);
      fmt = cm.getFormattedMonetaryAmount( new MonetaryAmount(d, currency), storeAB, Integer.valueOf(lang));   
%>
<%= comm.addDlistColumn(fmt.toString(), "none") %>

<%
	Double d_qty = Double.valueOf(BidQuantity);
	Integer quantity = new Integer(d_qty.intValue());
 	java.text.NumberFormat numberFormatter;
 	numberFormatter = java.text.NumberFormat.getNumberInstance(locale_obj);
%>
<%= comm.addDlistColumn(UIUtil.toHTML(numberFormatter.format(quantity)), "none") %>

<%= comm.addDlistColumn(BidReferenceNumber, "none") %>
<%= comm.addDlistColumn(BidStatus, "none") %>
<%= comm.endDlistRow() %>
<%
     if(rowselect==1){
       rowselect = 2;
     }
     else{
       rowselect = 1;
     } 
} // End For
%>
<%= comm.endDlistTable() %>
<%
	if (bidData.length <= 0) {
%>
	<P>
	<P>
	<%= UIUtil.toHTML((String)neg_properties.get("emptyBidList")) %>
<% 
	}
%>
</FORM>
<SCRIPT LANGUAGE="Javascript">
function performDelete() 
{
     if(isButtonDisabled(parent.buttons.buttonForm.withdrawButton))
        return;
	if ("<%= AucStatus %>" != "C") {
		alertDialog("<%= UIUtil.toJavaScript((String)neg_properties.get("invalidAuctionStateForBidDelete")) %>");
		return; 
	} else if ("<%= AucType %>" == "<%= AuctionConstants.EC_AUCTION_DUTCH_TYPE %>") {
		alertDialog("<%= UIUtil.toJavaScript((String)neg_properties.get("invalidAuctionTypeForBidDelete")) %>");
		return; 
	} else if (confirmDialog("<%= UIUtil.toJavaScript((String)neg_properties.get("deletebid")) %>")) {
		document.bidForm.bid_id.value = parent.getChecked();	
		document.bidForm.startindex.value="0";
		document.bidForm.action="AdminBidDelete";
            document.bidForm.listsize.value = getListSize();
            document.bidForm.orderby.value = getSortby();
            deSelectAll();
            parent.page = 1;
		document.bidForm.submit();
	}
}

function isButtonDisabled(b) {
    if (b.className =='disabled' &&	b.id == 'disabled')
	return true;
    return false;
}

function userInitialButtons() {
	if (defined(parent.buttons.buttonForm.withdrawButton)) 
	{
         parent.buttons.buttonForm.withdrawButton.id = 'disabled';
         parent.buttons.buttonForm.withdrawButton.className = 'disabled';
	}
      myRefreshButtons();
}

function myRefreshButtons()
{

  parent.refreshButtons();

  if (  "<%= AucStatus %>" != "C" || "<%= AucType %>" == "<%= AuctionConstants.EC_AUCTION_DUTCH_TYPE %>")  { 
         parent.buttons.buttonForm.withdrawButton.id = 'disabled';
         parent.buttons.buttonForm.withdrawButton.className = 'disabled';
         return;
     }

  if(typeof parent.checkValueHashtable == "undefined")
    parent.checkValueHashtable = new Object();

  var temp_status;
  for (var i=0; i<document.bidForm.elements.length; i++) {
      if (document.bidForm.elements[i].type == 'checkbox')
        if (document.bidForm.elements[i].checked)
           parent.checkValueHashtable[document.bidForm.elements[i].name] = document.bidForm.elements[i].value;
  }

  var checked = new String(parent.getChecked());
  if(checked == "") return;

  var temp2 = checked.split(",");
  for (var j = 0; j < temp2.length; j++)
  {
    if (  parent.checkValueHashtable[temp2[j]] == "Deleted" )  { 
	    parent.buttons.buttonForm.withdrawButton.id = 'disabled';
	    parent.buttons.buttonForm.withdrawButton.className = 'disabled';
          return;
	}
  }
 
}

parent.afterLoads();
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

