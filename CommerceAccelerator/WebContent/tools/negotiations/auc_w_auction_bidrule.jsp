<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2013, 2014 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<%@page language="java" %>
<!-- ========================================================================
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//*   WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2000, 2002
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
 ===========================================================================-->
<%@  page import="com.ibm.commerce.command.*" %>
<%@  page import="com.ibm.commerce.common.objects.*" %>
<%@  page import="java.util.*"  %>
<%@  page import="java.text.*"  %>
<%@  page import="java.math.*"  %>
<%@  page import="com.ibm.commerce.tools.test.*" %>
<%@  page import="com.ibm.commerce.tools.util.*" %>
<%@  page import="com.ibm.commerce.negotiation.beans.*" %>
<%@  page import="com.ibm.commerce.price.utils.*" %>

<%@include file="../common/common.jsp" %>

<HTML>
<HEAD>
<%
     Locale   aLocale = null;
     String   StoreId = "0";
     String    lang = "-1"; 	
     CommandContext aCommandContext = (CommandContext)request.getAttribute("CommandContext");    
     if( aCommandContext!= null )
     {
       aLocale = aCommandContext.getLocale();
       StoreId = aCommandContext.getStoreId().toString();
       lang = aCommandContext.getLanguageId().toString();

     }

     //*** GET OWNER ***//        
     StoreAccessBean storeAB = com.ibm.commerce.registry.StoreRegistry.singleton().find(new Integer(StoreId));
     String   ownerid =  storeAB.getMemberId();

     //*** GET CURRENCY ***//	     
     CurrencyManager cm = CurrencyManager.getInstance();
     Integer defaultLanguageId = new Integer(Integer.parseInt(lang));
     String defaultCurrency = cm.getDefaultCurrency(storeAB, defaultLanguageId);    

     FormattedMonetaryAmount fmt = null;
     BigDecimal d= null;

     // obtain the resource bundle for display
     Hashtable auctionNLS = (Hashtable)ResourceDirectory.lookup("negotiations.negotiationsNLS",aLocale);

     String selectedAuctionType = (String)request.getParameter("autype");
     String selectedBidRule     = (String)request.getParameter("aubdrule");
%>


<jsp:useBean id="bcrList" class="com.ibm.commerce.negotiation.beans.ControlRuleListBean" >
<jsp:setProperty property="*" name="bcrList" />
</jsp:useBean>

<%
	bcrList.setOwnerId(ownerid);
	com.ibm.commerce.beans.DataBeanManager.activate(bcrList, request); 
	ControlRuleDataBean[] bcrData = bcrList.getControlRules();
%>

<LINK rel="stylesheet" href="<%= UIUtil.getCSSFile(aLocale) %>" type="text/css">

<SCRIPT SRC="/wcs/javascript/tools/negotiations/auc_common.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
<%@include file="../common/NumberFormat.jsp" %>

<SCRIPT>


function initializeState()
{
   parent.setContentFrameLoaded(true);
}

function savePanelData()
{
	var form=document.BidruleForm;
	parent.put(auctBdrule ,form.aubdrule.value);
	parent.put(auctType,form.autype.value);
	
	parent.addURLParameter("authToken", "${authToken}");
}


function ChangeBidRule()
{
	var form=document.BidruleForm;
	form.aubdrule.value = form.BidRule.options[form.BidRule.selectedIndex].value;
	parent.put(auctBdrule ,form.aubdrule.value);
	parent.put(auctType,form.aubdrule.value);
	form.action = document.location;
	form.submit();
}

function validatePanelData()
{  
 return true;
}

function retrievePanelData(){
  var form = document.BidruleForm;
  var temp = parent.get("aubdrule","");
  if (temp != "") {
	  for (i=0;i<form.BidRule.length;i++) {
 		if (form.BidRule.options[i].value == temp){
			form.BidRule.selectedIndex = i;
			form.aubdrule.value = temp;
			break;
		}
	  }
  }
}



</SCRIPT>
</HEAD>



<BODY class=content ONLOAD="initializeState();">
<BR><h1><%= auctionNLS.get("AuctBidRule") %></h1>
<%if (selectedAuctionType.equals("O")) { %>
		<%= auctionNLS.get("openCryRuleDescMessage") %>
<% } else if (selectedAuctionType.equals("SB")){%>
		<%= auctionNLS.get("sealedBidRuleDescMessage") %>
<% } %>

<FORM NAME="BidruleForm" id="BidruleForm">
<INPUT TYPE=HIDDEN NAME="aubdrule" VALUE="" id="WC_W_AuctionBidrule_aubdrule_In_BidruleForm">
<INPUT TYPE=HIDDEN NAME="autype" VALUE="<%=UIUtil.toHTML(selectedAuctionType)%>" id="WC_W_AuctionBidrule_autype_In_BidruleForm">
 <TABLE id="WC_W_AuctionBidrule_Table_1">
<% 
    if ( selectedAuctionType.equals("D") ) {
%>
    <TR> 
 	<TD id="WC_W_AuctionBidrule_TableCell_1">
 	     <%= auctionNLS.get("NoRuleForDutch") %>     
   	</TD>
     </TR>
<%  } else {
%>
	<TR>
	<TD id="WC_W_AuctionBidrule_TableCell_2">
        <LABEL for="WC_W_AuctionBidrule_BidRule_In_BidruleForm">
		<%= auctionNLS.get("BidRuleName") %> </LABEL><BR>	
      	<SELECT name="BidRule" onChange="ChangeBidRule()" id="WC_W_AuctionBidrule_BidRule_In_BidruleForm">
<%
	ControlRuleDataBean controlrule = null;
	OpenCryBidControlRuleDataBean aOCRule= null;
	SealedBidControlRuleDataBean aSBRule= null;
        NumericRangeDataBean[] numericRangeDataBeans = null;

	String RuleID = null;
	String RuleName = null;
	String RuleDesc = null;
	String MinValue = null;
	String MinQuantity = null;
	for (int i = 0; i < bcrData.length; i++) { // begin FOR
		controlrule = bcrData[i];
		if (selectedAuctionType.equals("O") && 
		    controlrule instanceof com.ibm.commerce.negotiation.beans.OpenCryBidControlRuleDataBean) 
		{
			aOCRule 	= (OpenCryBidControlRuleDataBean)controlrule; 		
			RuleID      = aOCRule.getId();	 
%>
			<OPTION VALUE="<%=RuleID%>"> <%=aOCRule.getRuleName()%>
<%
			if (selectedBidRule != null && RuleID.equals(selectedBidRule)) {
				RuleName      = aOCRule.getRuleName();
				RuleDesc 	  = aOCRule.getRuleDesc();
				MinValue 	  = aOCRule.getMinValue();                        
				MinQuantity   = aOCRule.getMinQuant();   
                               numericRangeDataBeans = ((OpenCryBidControlRuleDataBean)aOCRule).getPriceRanges();
				                             
		     }

		}
	
		else 	if (selectedAuctionType.equals("SB") && 
			    controlrule instanceof com.ibm.commerce.negotiation.beans.SealedBidControlRuleDataBean) {

				aSBRule 	= (SealedBidControlRuleDataBean)controlrule;
				RuleID      = aSBRule.getId();	 
%>			
			<OPTION VALUE="<%=RuleID%>"><%=aSBRule.getRuleName() %>
<%
			if (selectedBidRule!= null && RuleID.equals(selectedBidRule)) {
				RuleName      = aSBRule.getRuleName();
				RuleDesc 	= aSBRule.getRuleDesc();
				MinValue 	= aSBRule.getMinValue();                        
				MinQuantity = aSBRule.getMinQuant();                                
			}
		}

	}// END FOR
%>
			<OPTION VALUE="" SELECTED><%= auctionNLS.get("None") %>
			</SELECT>
         
	</TD>
	</TR>
<% if (RuleName != null && !RuleName.equals("")) {%>
	<TR>
	<TD id="WC_W_AuctionBidrule_TableCell_3">
		    <%= auctionNLS.get("BidRuleRefNum") %>: <I><%= UIUtil.toHTML(selectedBidRule) %></I> <BR>	
	</TD>
	</TR>
	<TR>
	<TD id="WC_W_AuctionBidrule_TableCell_4">
		    <%= auctionNLS.get("BidRuleDesc") %>: <I><%=RuleDesc%></I> <BR>	
	</TD>
	</TR>
	<TR>
	<TD id="WC_W_AuctionBidrule_TableCell_5">
<%
	String formatted_MinValue = "";
	if (MinValue != null && MinValue.length() > 0) 
	{
		d   = new BigDecimal(MinValue);
		if (d.doubleValue() > 0) {
	      	fmt = cm.getFormattedMonetaryAmount( new MonetaryAmount(d, defaultCurrency), storeAB, Integer.valueOf(lang));   
			formatted_MinValue = fmt.toString();
		}
	}

%>

		    <%= auctionNLS.get("MinValue") %>: <I><%= formatted_MinValue%></I> <BR>	
	</TD>
	</TR>
	<TR>
	<TD id="WC_W_AuctionBidrule_TableCell_6">
<%
	String formatted_MinQty = "";
	if (MinQuantity != null && MinQuantity.length() > 0)
	{
		Double d_qty = Double.valueOf(MinQuantity);
 		Integer quantity = new Integer(d_qty.intValue());
	 	java.text.NumberFormat numberFormatter;
		if (quantity.intValue() > 0 ) {
		 	numberFormatter = java.text.NumberFormat.getNumberInstance(aLocale);
 			formatted_MinQty = numberFormatter.format(quantity);
		}
	}
%>
	
		    <%= auctionNLS.get("MinQuantity") %>: <I><%= formatted_MinQty%></I> <BR>	
	</TD>
	</TR>
<% } %>

<%
if (numericRangeDataBeans != null){
%>
	<TR>
	<TD id="WC_W_AuctionBidrule_TableCell_7">
	<TABLE class="list"  summary="<%= auctionNLS.get("summaryText") %>" id="WC_W_AuctionBidrule_Table_2">
	<TR  class="list_roles">
	<TD class="list_header" id="WC_W_AuctionBidrule_TableCell_8"><%= auctionNLS.get("RangeFrom") %> </TH>
	<TD class="list_header" id="WC_W_AuctionBidrule_TableCell_9"><%= auctionNLS.get("RangeTo") %> </TH>
	<TD class="list_header" id="WC_W_AuctionBidrule_TableCell_10"><%= auctionNLS.get("Increment") %> </TH>
	</TR>
<%
	for(int j=0;j<numericRangeDataBeans.length; j++) {         
		     String val_Range1 = numericRangeDataBeans[j].getLowerLimit().toString();
		     String val_Range2 = numericRangeDataBeans[j].getUpperLimit().toString();
		     String val_Incr   = numericRangeDataBeans[j].getIncrement().toString();           
%>
		<TR>
		<TD CLASS="list_info1" headers="t1" id="WC_W_AuctionBidrule_TableCell_11_<%=j%>">
            <%
			d   = new BigDecimal(val_Range1);
            	fmt = cm.getFormattedMonetaryAmount( new MonetaryAmount(d, defaultCurrency), storeAB, Integer.valueOf(lang));   
            %>
			<%= fmt.toString() %> 
		</TD>

		<TD CLASS="list_info1" headers="t2" id="WC_W_AuctionBidrule_TableCell_12_<%=j%>">
            <%
			d   = new BigDecimal(val_Range2);
            	fmt = cm.getFormattedMonetaryAmount( new MonetaryAmount(d, defaultCurrency), storeAB, Integer.valueOf(lang));   
            %>
			<%= fmt.toString() %> 
		</TD>
		<TD CLASS="list_info1" headers="t3" id="WC_W_AuctionBidrule_TableCell_13_<%=j%>">
            <%
			d   = new BigDecimal(val_Incr);
	            fmt = cm.getFormattedMonetaryAmount( new MonetaryAmount(d, defaultCurrency), storeAB, Integer.valueOf(lang));   
            %>
			<%= fmt.toString() %> 
		</TD>
		</TR>
<%	}// end for
%>
	</TABLE>
	</TD>
	</TR>
<%	
} // End if
%>

<% }  // end else autype is O or SB
%>
</TABLE>

</FORM>
<SCRIPT LANGUAGE="Javascript">
	retrievePanelData();
</SCRIPT> 
</BODY>
</HTML>
