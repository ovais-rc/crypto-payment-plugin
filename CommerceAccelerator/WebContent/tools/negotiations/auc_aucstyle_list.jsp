<!-- ========================================================================
 Licensed Materials - Property of IBM

 WebSphere Commerce

 (c) Copyright IBM Corp. 2000, 2002

US Government Users Restricted Rights - Use, duplication or
disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
===========================================================================-->

<%@ page import="com.ibm.commerce.tools.test.*,
                com.ibm.commerce.tools.util.*, 
                com.ibm.commerce.tools.common.ui.taglibs.*, 
		    com.ibm.commerce.negotiation.beans.*,
		    com.ibm.commerce.negotiation.util.*,
		    com.ibm.commerce.negotiation.misc.*,
		    com.ibm.commerce.negotiation.operation.*,
		    com.ibm.commerce.command.*,
                com.ibm.commerce.server.*,
		    com.ibm.commerce.common.objects.*" %>

<%@include file="../common/common.jsp" %>



<%
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
		locale_obj = new Locale("en","US");

     //*** GET OWNER ***//        
     StoreAccessBean storeAB = com.ibm.commerce.registry.StoreRegistry.singleton().find(new Integer(StoreId));
     String   ownerid =  storeAB.getMemberId();

	//*** GET THE RESOURCE BUNDLE BASED ON LOCALE ***//
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
<TITLE><%= neg_properties.get("stylelisttitle") %></TITLE>

<jsp:useBean id="aslb" class="com.ibm.commerce.negotiation.beans.AuctionStyleListBean" >
<jsp:setProperty property="*" name="aslb" />
</jsp:useBean>

<%!
   // move this function from list.jsp to the local file since the length is only need on the server by
   // the implemented list and not List.jsp
   public int getResultsSize(com.ibm.commerce.negotiation.beans.AuctionStyleDataBean[] asData) 
   {
     return asData.length;
   }   
%>

<%   
	//*** GET THE SORT ORDER, IF ANY. ***//
	String sortBy = UIUtil.toHTML((String)help.getParameter("orderby"));
	com.ibm.commerce.negotiation.util.AuctionStyleSortingAttribute sa = new com.ibm.commerce.negotiation.util.AuctionStyleSortingAttribute();
	if (sortBy != null && !sortBy.equals("null") && !sortBy.equals(""))
		sa.addSorting(sortBy,true);
	else
		sa.addSorting(com.ibm.commerce.negotiation.util.AuctionStyleTable.NAME,true);
	aslb.setSortAtt(sa);

	//*** FIND STYLES BY OWNER ***//
	aslb.setAuctStyleOwnerId(ownerid);
	com.ibm.commerce.beans.DataBeanManager.activate(aslb, request); 
	AuctionStyleDataBean[] asData = aslb.getAuctionStyles();	
      int totalItems = getResultsSize(asData);
%>

<SCRIPT LANGUAGE="Javascript">
<!---- hide script from old browsers


function onLoad() {
   parent.loadFrames()
}

function getStyleName() {
	var tempval = parent.getChecked();
	var selval = tempval[0].split("!");
	return selval[0];
}

function getStyleOwner(){
	var tempval = parent.getChecked();
	var selval = tempval[0].split("!");
	return selval[1];
}

function performChange() {
      var urlPara = new Object();
	urlPara.XMLFile = "negotiations.auctionstyleNotebook";
	urlPara.ProfileName = getStyleName();
	urlPara.OwnerId = getStyleOwner();
      deSelectAll();
	top.setContent(getChangeAuctionStyleBCT(), "/webapp/wcs/tools/servlet/NotebookView", true, urlPara)
}

function performChangeFromLink(stylename,owner) {
      var urlPara = new Object();
	urlPara.XMLFile = "negotiations.auctionstyleNotebook";
	urlPara.ProfileName = stylename;
	urlPara.OwnerId = owner;
      deSelectAll();
	top.setContent(getChangeAuctionStyleBCT(), "/webapp/wcs/tools/servlet/NotebookView", true, urlPara)
}

function performDelete() {
	if (confirmDialog("<%= UIUtil.toJavaScript((String)neg_properties.get("deletestyle")) %>")) {
		// change all exclaimation points to commas
		var a=parent.getChecked();   //get an array of checked boxes
		var b=new String(a);
		var pos=0;
		var findText="!";
		var replaceText=",";
		var len = findText.length;
		pos = b.indexOf(findText);
		
	 	while (pos != -1) {
 
 		  preString=b.substring(0,pos);
 		  postString=b.substring(pos + len, b.length);
 		  b =preString + replaceText + postString;
 		  pos = b.indexOf(findText);
 
 		}

		document.auctionstyleForm.ProfileName.value = getStyleName();
		document.auctionstyleForm.selected.value = b;
		document.auctionstyleForm.action = "DeleteAuctionStyle";
            document.auctionstyleForm.startindex.value = "0";
            document.auctionstyleForm.listsize.value = getListSize();
            document.auctionstyleForm.orderby.value = getSortby();
            deSelectAll();
            parent.page = 1;
		document.auctionstyleForm.submit();
	}
}


//*** This function currently handles only errors. ***//
function handleErrorOrSuccess(){
   var FinishMessage = "<%= UIUtil.toJavaScript(ErrorMessage) %>";
   if (FinishMessage != null && FinishMessage !="")
	alertDialog(FinishMessage);
}

function getNewAuctionStyleBCT() {
  return "<%= UIUtil.toJavaScript((String)neg_properties.get("newAuctionStyleBCT")) %>";
}

function getChangeAuctionStyleBCT() {
  return "<%= UIUtil.toJavaScript((String)neg_properties.get("changeAuctionStyleBCT")) %>";
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
   return "<%= UIUtil.toJavaScript((String)neg_properties.get("stylelisttitle")) %>"
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
handleErrorOrSuccess()
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

<%= comm.addControlPanel("negotiations.auctionstyleList",totalpage,totalItems,locale_obj) %>

<FORM NAME="auctionstyleForm" ACTION="AuctionStyleList?" METHOD="POST">
<INPUT TYPE="HIDDEN" NAME="ProfileName" VALUE="">
<INPUT TYPE="HIDDEN" NAME="selected" VALUE="">
<INPUT TYPE="HIDDEN" NAME="startindex" VALUE="">
<INPUT TYPE="HIDDEN" NAME="listsize" VALUE="">
<INPUT TYPE="HIDDEN" NAME="orderby" VALUE="">

<%= comm.startDlistTable(nul) %>
<%= comm.startDlistRowHeading() %>
<%= comm.addDlistCheckHeading() %>
<%= comm.addDlistColumnHeading(UIUtil.toHTML((String)neg_properties.get("StyleName")), AuctionStyleTable.NAME, 
sortBy.equals(AuctionStyleTable.NAME)) %>
<%= comm.addDlistColumnHeading(UIUtil.toHTML((String)neg_properties.get("auctionType")), AuctionStyleTable.AUCTION_TYPE, sortBy.equals(AuctionStyleTable.AUCTION_TYPE)) %>
<%= comm.addDlistColumnHeading(UIUtil.toHTML((String)neg_properties.get("StyleBidRuleName")), AuctionStyleTable.BID_RULE_ID, sortBy.equals(AuctionStyleTable.BID_RULE_ID)) %>
<%= comm.endDlistRow() %>
    
<%
int rowselect = 1;
AuctionStyleDataBean aStyle = null;

String StyleName = null;
String AuctionType = null;
String AuctionTypeForDisplay = null;
String BidRuleID = null;
String BidRuleName = null;
String OwnerID = null;
String checkboxvalue = null;

int endIndex = startIndex + listSize -1;

if (endIndex > totalItems)
    endIndex=totalItems;

for (int i = 0; i < totalItems; i++) {
            if (i < startIndex)
			continue;
		if (i > endIndex)
			break;

		aStyle 	  = asData[i];
		StyleName 	  = aStyle.getName().trim();
		BidRuleID 	  = aStyle.getBidRuleId().trim();
		BidRuleName   = "";
		AuctionType   = aStyle.getAuctionType().trim();                                
		OwnerID	  = aStyle.getOwnerId().trim();
		checkboxvalue = StyleName + "!" + OwnerID;
		
		if (AuctionType.equals(AuctionConstants.EC_AUCTION_OPEN_CRY_TYPE))
			AuctionTypeForDisplay = (String)neg_properties.get("opencry");
		else if (AuctionType.equals(AuctionConstants.EC_AUCTION_SEALED_BID_TYPE))
			AuctionTypeForDisplay = (String)neg_properties.get("sealedbid");
		else if (AuctionType.equals(AuctionConstants.EC_AUCTION_DUTCH_TYPE))
			AuctionTypeForDisplay = (String)neg_properties.get("dutch");

		if (BidRuleID != null && !BidRuleID.equals("")) {
			if (AuctionType.equals(AuctionConstants.EC_AUCTION_OPEN_CRY_TYPE)) {		
				OpenCryBidControlRuleDataBean ocData = new OpenCryBidControlRuleDataBean();
				ocData.setId(BidRuleID);
				com.ibm.commerce.beans.DataBeanManager.activate(ocData, request);
				BidRuleName = ocData.getRuleName();
			}
			else if(AuctionType.equals(AuctionConstants.EC_AUCTION_SEALED_BID_TYPE)){
				SealedBidControlRuleDataBean sbData = new SealedBidControlRuleDataBean();
				sbData.setId(BidRuleID);
				com.ibm.commerce.beans.DataBeanManager.activate(sbData, request);
				BidRuleName = sbData.getRuleName();
			}
		}
%>

<%= comm.startDlistRow(rowselect) %>
<%= comm.addDlistCheck(checkboxvalue, "none") %>
<%= comm.addDlistColumn(UIUtil.toHTML(StyleName), "javascript:performChangeFromLink('" + StyleName + "','" +  OwnerID + "')") %>
<%= comm.addDlistColumn(UIUtil.toHTML(AuctionTypeForDisplay), "none") %>
<%= comm.addDlistColumn(UIUtil.toHTML(BidRuleName), "none") %>
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
	if (totalItems <= 0) {
%>
	<P>
	<P>
	<%= UIUtil.toHTML((String)neg_properties.get("emptyAuctionStyleList")) %>
<% 
	}
%>
<SCRIPT LANGUAGE="Javascript">
   parent.afterLoads();
</SCRIPT>
</FORM>
</BODY>
</HTML>

