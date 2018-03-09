<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2013 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

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
			com.ibm.commerce.negotiation.util.*, 
			com.ibm.commerce.negotiation.misc.*, 
			com.ibm.commerce.negotiation.operation.*, 
			com.ibm.commerce.common.objects.*, 
			com.ibm.commerce.price.utils.*, 
			com.ibm.commerce.command.*, 
                  com.ibm.commerce.server.*,
			java.math.*" %>

<%@include file="../common/common.jsp" %>

<%
      //*** GET LANGID AND STOREID FROM COMANDCONTEXT ***//
      CommandContext aCommandContext = (CommandContext)request.getAttribute("CommandContext");    
 	String   StoreId = "0";
	String   lang =  "-1";  
	java.util.Locale   locale_obj = null;
      if( aCommandContext!= null ){
            lang = aCommandContext.getLanguageId().toString();
		locale_obj = aCommandContext.getLocale();
            StoreId = aCommandContext.getStoreId().toString();
      }

	if (locale_obj == null)
		locale_obj = new java.util.Locale("en","US");

     //*** GET OWNER ***//        
     StoreAccessBean storeAB = com.ibm.commerce.registry.StoreRegistry.singleton().find(new Integer(StoreId));
     String   ownerid =  storeAB.getMemberId();

     //*** GET CURRENCY ***//             
     CurrencyManager cm = CurrencyManager.getInstance();
     Integer defaultLanguageId = new Integer(Integer.parseInt(lang));
     String defaultCurrency = cm.getDefaultCurrency(storeAB, defaultLanguageId);    

     FormattedMonetaryAmount fmt = null;
     BigDecimal d= null;

	//*** GET THE RESOURCE BUNDLE BASED ON LOCALE ***//
	Hashtable neg_properties= (Hashtable)ResourceDirectory.lookup("negotiations.negotiationsNLS",locale_obj);
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
<TITLE><%= neg_properties.get("rulelisttitle") %></TITLE>

<jsp:useBean id="bcrList" class="com.ibm.commerce.negotiation.beans.ControlRuleListBean" >
<jsp:setProperty property="*" name="bcrList" />
<jsp:setProperty property="ownerId" name="bcrList" value="" />
</jsp:useBean>
<%

	//*** GET THE SORT ORDER, IF ANY. ***//
	String sortBy = (String)help.getParameter("orderby");
	com.ibm.commerce.negotiation.util.ControlRuleSortingAttribute sa = new com.ibm.commerce.negotiation.util.ControlRuleSortingAttribute();
	if (sortBy != null && !sortBy.equals("null") && !sortBy.equals(""))
		sa.addSorting(sortBy,true);
	else
		sa.addSorting(com.ibm.commerce.negotiation.util.ControlRuleTable.NAME,true);
	bcrList.setSortAtt(sa);
	bcrList.setOwnerId(ownerid);

	//*** FIND BID RULES BY OWNER***//
	com.ibm.commerce.beans.DataBeanManager.activate(bcrList, request); 
	ControlRuleDataBean[] bcrData = bcrList.getControlRules();

	//*** DETERMINE IF THE AUCTIONTYPE FILTER IS SET ***//
	String selected_type = request.getParameter("auctiontype");
	if (selected_type == null)
		selected_type = "all";
	int OpenCryCount = 0;
      int SealedBidCount = 0;
	for (int i=0;bcrData!=null && i<bcrData.length;i++) {
		if (bcrData[i].getRuleType().equals("O"))
			OpenCryCount++;
		else if (bcrData[i].getRuleType().equals("SB"))
			SealedBidCount++;
	}

	//*** DETERMINE THE TYPE AND NUMBER OF RULES TO DISPLAY ***//
	boolean displayOpenCryRules = false;
	boolean displaySealedBidRules = false;
	if (selected_type == null || selected_type.equals("all") || selected_type.equals("")) {
		displayOpenCryRules = true;
		displaySealedBidRules = true;
	}
	else if (selected_type.equals("O"))
		displayOpenCryRules = true;
	else if (selected_type.equals("SB"))
		displaySealedBidRules = true;

	int displayCount = 0;
	if (displayOpenCryRules)
		displayCount += OpenCryCount;
	if (displaySealedBidRules)
		displayCount += SealedBidCount;
%>

<SCRIPT LANGUAGE="Javascript">
<!---- hide script from old browsers

function onLoad() {
	parent.loadFrames()
}

function getNewBidRuleBCT() {
	return "<%= UIUtil.toJavaScript((String)neg_properties.get("newBidRuleBCT")) %>";
}

function getChangeBidRuleBCT() {
	return "<%= UIUtil.toJavaScript((String)neg_properties.get("changeBidRuleBCT")) %>";
}

function getRuleNum() {
	var tempval = parent.getChecked();
	var ruleIds = "";
	for (i=0;i<tempval.length;i++) {
		var selval = tempval[i].split(",");
		if (ruleIds != "")
			ruleIds += ",";
		ruleIds += selval[0];
	}
	return ruleIds;
}

//*** The getType function gets called only when selection=single.***//
function getType() {
	var tempval = parent.getChecked();
	var selval = tempval[0].split(",");
	return selval[1];
}

function performDelete() {
	if (confirmDialog("<%= UIUtil.toJavaScript((String)neg_properties.get("deleterule")) %>")) {
		document.bidruleForm.cntrlrule.value = getRuleNum();
		document.bidruleForm.startindex.value = "0";
		document.bidruleForm.action = "DeleteBidRule";
            document.bidruleForm.listsize.value = getListSize();
            document.bidruleForm.orderby.value = getSortby();
            deSelectAll();
            parent.page = 1;
		document.bidruleForm.submit();
	}
}


//*** This function currently handles only errors. ***//
function handleErrorOrSuccess()
{
	var FinishMessage = "<%= UIUtil.toJavaScript(ErrorMessage) %>";
	if (FinishMessage != null && FinishMessage !="")
		alertDialog(FinishMessage);
}

function getResultsSize() { 
     return <%= displayCount %>; 
}

function getSortby() {
     return "<%= sortBy %>";
}

function getListSize() {
    return "<%= listSize %>"
}

function getUserNLSTitle() {
   return "<%= UIUtil.toJavaScript((String)neg_properties.get("rulelisttitle")) %>"
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

<%
  int totalpage = displayCount/listSize;
  // addControlPanel adds 1 to the page count which is ok unless the division doesn't result in a remainder
   if(displayCount == totalpage * listSize)
   {
     totalpage--;
   }
   String nul = null;
%>

<%= comm.addControlPanel("negotiations.bidruleList",totalpage,displayCount,locale_obj) %>

<FORM NAME="bidruleForm" ACTION="BidRuleList?" METHOD="POST">
<INPUT TYPE="HIDDEN" NAME="cntrlrule" VALUE="">
<INPUT TYPE="HIDDEN" NAME="auctiontype" VALUE="<%= UIUtil.toHTML(selected_type) %>">
<INPUT TYPE="HIDDEN" NAME="startindex" VALUE="">
<INPUT TYPE="HIDDEN" NAME="listsize" VALUE="">
<INPUT TYPE="HIDDEN" NAME="orderby" VALUE="">

<%= comm.startDlistTable(nul) %>
<%= comm.startDlistRowHeading() %>
<%= comm.addDlistCheckHeading() %>
<%= comm.addDlistColumnHeading(UIUtil.toHTML((String)neg_properties.get("ruleName")), ControlRuleTable.NAME, 
sortBy.equals(ControlRuleTable.NAME)) %>
<%= comm.addDlistColumnHeading(UIUtil.toHTML((String)neg_properties.get("description")), ControlRuleTable.DESCRIPTION, sortBy.equals(ControlRuleTable.DESCRIPTION)) %>
<%= comm.addDlistColumnHeading(UIUtil.toHTML((String)neg_properties.get("minvalue")), ControlRuleTable.MINIMUM_VALUE, sortBy.equals(ControlRuleTable.MINIMUM_VALUE)) %>
<%= comm.addDlistColumnHeading(UIUtil.toHTML((String)neg_properties.get("minqty")), ControlRuleTable.MINIMUM_QUANTITY, sortBy.equals(ControlRuleTable.MINIMUM_QUANTITY)) %>
<%= comm.endDlistRow() %>

<%

int rowselect = 1;
ControlRuleDataBean controlrule = null;
SealedBidControlRuleDataBean aSBRule = null;
OpenCryBidControlRuleDataBean aOCRule = null;

int endIndex = startIndex + listSize -1;
if (endIndex > displayCount)
    endIndex=displayCount;
int j= -1;

for (int i = 0; i < bcrData.length; i++) {
	controlrule = bcrData[i];
	String 	RuleID = null,RuleName = null,RuleDesc = null,MinValue = null,MinQuantity = null,
			ruleType = null,checkboxvalue = null;

	if (  displayOpenCryRules &&
		controlrule instanceof com.ibm.commerce.negotiation.beans.OpenCryBidControlRuleDataBean) 
	{	
		aOCRule 	= (com.ibm.commerce.negotiation.beans.OpenCryBidControlRuleDataBean)controlrule;  
		RuleID 	= aOCRule.getId().trim();
		RuleName 	= aOCRule.getRuleName().trim();
		RuleDesc 	= aOCRule.getRuleDesc();
		MinValue 	= aOCRule.getMinValue();                        
		MinQuantity = aOCRule.getMinQuant();                                
		ruleType    = aOCRule.getRuleType().trim();                                
		checkboxvalue = RuleID + "," + ruleType;
		j++;
	}
	else if (	displaySealedBidRules &&
			controlrule instanceof com.ibm.commerce.negotiation.beans.SealedBidControlRuleDataBean) 
	{
		aSBRule 	= (com.ibm.commerce.negotiation.beans.SealedBidControlRuleDataBean)controlrule;
		RuleID 	= aSBRule.getId().trim();
		RuleName 	= aSBRule.getRuleName().trim();
		RuleDesc 	= aSBRule.getRuleDesc();
		MinValue 	= aSBRule.getMinValue();                        
		MinQuantity = aSBRule.getMinQuant();                                
		ruleType    = aSBRule.getRuleType().trim();                                
		checkboxvalue = RuleID + "," + ruleType;
            j++;
	}
	else
		continue;

	//*** Begin Null Checks ***//
	if (RuleDesc == null)	 
		RuleDesc = "";
	else
		RuleDesc = RuleDesc.trim();
	if (MinValue == null)	 
		MinValue = "";
	else 
		MinValue=MinValue.trim();
	if (MinQuantity == null) 
		MinQuantity = "";
	else 
		MinQuantity=MinQuantity.trim();
	//*** End Null Checks ***//

		
      if (j < startIndex)
			continue;
	if (j > endIndex)
			break;

	String formatted_MinValue = "";
	if (MinValue != null && MinValue.length() > 0) 
	{
		d   = new BigDecimal(MinValue);
		if (d.doubleValue() > 0) {
	      	fmt = cm.getFormattedMonetaryAmount( new MonetaryAmount(d, defaultCurrency), storeAB, Integer.valueOf(lang));   
			formatted_MinValue = fmt.toString();
		}
	}

	String formatted_MinQty = "";
	if (MinQuantity != null && MinQuantity.length() > 0)
	{
		Double d_qty = Double.valueOf(MinQuantity);
 		Integer quantity = new Integer(d_qty.intValue());
	 	java.text.NumberFormat numberFormatter;
		if (quantity.intValue() > 0 ) {
		 	numberFormatter = java.text.NumberFormat.getNumberInstance(locale_obj);
 			formatted_MinQty = numberFormatter.format(quantity);
		}
	}

%>

<%= comm.startDlistRow(rowselect) %>
<%= comm.addDlistCheck(checkboxvalue, "none") %>
<%= comm.addDlistColumn(UIUtil.toHTML(RuleName), "javascript:top.setContent(getChangeBidRuleBCT(), '/webapp/wcs/tools/servlet/NotebookView?XMLFile=negotiations.bidruleNotebook&rule_Id=" + RuleID + "&rule_Type=" +  ruleType + "')") %>
<%= comm.addDlistColumn(UIUtil.toHTML(RuleDesc), "none") %>
<%= comm.addDlistColumn(formatted_MinValue, "none") %>
<%= comm.addDlistColumn(formatted_MinQty, "none") %>
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
	if (displayCount <= 0) {
%>
	<P>
	<P>
	<%= UIUtil.toHTML((String)neg_properties.get("emptyBidRuleList")) %>
<% 
	}
%>
</FORM>
<SCRIPT LANGUAGE="Javascript">
	parent.afterLoads();
</SCRIPT>
</BODY>
</HTML>
