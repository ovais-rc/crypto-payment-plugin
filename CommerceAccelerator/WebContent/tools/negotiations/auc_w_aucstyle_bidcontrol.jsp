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

<%@page import=	"com.ibm.commerce.tools.test.*,
			com.ibm.commerce.tools.util.*,
			com.ibm.commerce.negotiation.beans.*,
			com.ibm.commerce.command.*,
			com.ibm.commerce.common.objects.*,
			com.ibm.commerce.price.utils.*,
			java.math.*" %>

<%@include file="../common/common.jsp" %>



<%
      //*** GET LANGID,LOCALE AND STOREID FROM COMANDCONTEXT ***//
      CommandContext aCommandContext = (CommandContext)request.getAttribute("CommandContext");    
 	String   StoreId 	= "0";
	String   lang	=  "1";  
	String   locale	= "en_US";
	Locale   locale_obj = null;
      if( aCommandContext!= null ){
            lang = aCommandContext.getLanguageId().toString();
		locale_obj = aCommandContext.getLocale();
            locale = aCommandContext.getLocale().toString();
            StoreId = aCommandContext.getStoreId().toString();
      }
	if (locale_obj == null)
		locale_obj = new Locale("en","US");

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

	String selectedAuctionType = (String)request.getParameter("autype");
	String selectedBidRule     = (String)request.getParameter("aubdrule");
%>

<HTML>
<HEAD>
<link rel="stylesheet" href="<%= UIUtil.getCSSFile(locale_obj)%>" type="text/css">


<jsp:useBean id="bcrList" class="com.ibm.commerce.negotiation.beans.ControlRuleListBean" >
<jsp:setProperty property="*" name="bcrList" />
</jsp:useBean>

<%
	//*** FIND RULES BY OWNER***//
	bcrList.setOwnerId(ownerid);
	com.ibm.commerce.beans.DataBeanManager.activate(bcrList, request); 
	ControlRuleDataBean[] bcrData = bcrList.getControlRules();

     ControlRuleDataBean controlrule = null;
     OpenCryBidControlRuleDataBean aOCRule= null;
     SealedBidControlRuleDataBean aSBRule= null;
     String RuleID = null;
     String RuleName = null;
     String RuleDesc = null;
     String MinValue = null;
     String MinQuantity = null;
     NumericRangeDataBean[] numericRangeDataBeans = null;
%>

<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT>

function initializeState(){
   parent.setContentFrameLoaded(true);
}

function savePanelData(){
	var form=document.auctionStyleForm;
	parent.put("aubdrule",form.aubdrule.value);
	parent.put("autype",form.autype.value);
	
	parent.addURLParameter("authToken", "${authToken}");
}

function ChangeBidRule(){
	var form=document.auctionStyleForm;
	form.aubdrule.value = form.BidRule.options[form.BidRule.selectedIndex].value;
	parent.put("aubdrule",form.aubdrule.value);
	parent.put("autype",form.aubdrule.value);
	form.action = document.location;
	form.submit();
}

function validatePanelData(){  
	return true;
}

function retrievePanelData(){
	var form = document.auctionStyleForm;
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
<BR><h1><%= neg_properties.get("AStyleBidRule") %></h1>

<% if (selectedAuctionType.equals("O")) { %>
	<%= neg_properties.get("openCryRuleDescMessage") %>
<% } else if (selectedAuctionType.equals("SB")) { %>
		<%= neg_properties.get("sealedBidRuleDescMessage") %>
<% } %>

<FORM NAME="auctionStyleForm" id="auctionStyleForm">
<INPUT TYPE=HIDDEN NAME="aubdrule" VALUE="" id="W_AucstyleBidcontrol_aubdrule_In_auctionStyleForm">
<INPUT TYPE=HIDDEN NAME="autype" VALUE="<%=UIUtil.toHTML(selectedAuctionType)%>" id="W_AucstyleBidcontrol_autype_In_auctionStyleForm">
<TABLE ALIGN="LEFT" id="W_AucstyleBidcontrol_Table_1">

	<TR>
	<TD id="W_AucstyleBidcontrol_TableCell_1">
	<LABEL for="W_AucstyleBidcontrol_BidRule_In_auctionStyleForm"><%= neg_properties.get("StyleBidRule") %></LABEL><BR>	
      	<SELECT name="BidRule" onChange="ChangeBidRule()" id="W_AucstyleBidcontrol_BidRule_In_auctionStyleForm">
<%
for (int i = 0; i < bcrData.length; i++) { // begin FOR
	controlrule = bcrData[i];
	if (selectedAuctionType.equals("O") && 
	    controlrule instanceof com.ibm.commerce.negotiation.beans.OpenCryBidControlRuleDataBean) 
	{
		aOCRule 	= (OpenCryBidControlRuleDataBean)controlrule; 		
		RuleID      = aOCRule.getId().trim();	 
%>
			<OPTION VALUE="<%=RuleID%>"> <%=aOCRule.getRuleName().trim()%>
<%
		if (selectedBidRule != null && RuleID.equals(selectedBidRule)) {
			RuleName      = aOCRule.getRuleName().trim();
			RuleDesc 	  = aOCRule.getRuleDesc();
			MinValue 	  = aOCRule.getMinValue();                        
			MinQuantity   = aOCRule.getMinQuant();       
			numericRangeDataBeans = aOCRule.getPriceRanges();            
		}
	}
	else 	if (selectedAuctionType.equals("SB") && 
		    controlrule instanceof com.ibm.commerce.negotiation.beans.SealedBidControlRuleDataBean) 
	{
		aSBRule 	= (SealedBidControlRuleDataBean)controlrule;
		RuleID      = aSBRule.getId().trim();	 
%>			
			<OPTION VALUE="<%=RuleID%>"><%=aSBRule.getRuleName().trim()%>
<%
		if (selectedBidRule!= null && RuleID.equals(selectedBidRule)) {
			RuleName      = aSBRule.getRuleName().trim();
			RuleDesc 	= aSBRule.getRuleDesc();
			MinValue 	= aSBRule.getMinValue();                        
			MinQuantity = aSBRule.getMinQuant();                                
		}
	}

	if (RuleName == null) RuleName = "";
	if (MinValue == null) MinValue = "";
	if (MinQuantity == null) MinQuantity = "";

}// END FOR
%>
			<OPTION VALUE="" SELECTED><%= neg_properties.get("none") %>
	</SELECT>
	</TD>
	</TR>
	

<% if (RuleName != null && !RuleName.equals("")) {%>
	<TR><TD id="W_AucstyleBidcontrol_TableCell_2">
		 <%= neg_properties.get("name") %>: <I><%=RuleName%></I> <BR>	
	</TD></TR>

	<TR><TD id="W_AucstyleBidcontrol_TableCell_3">
		 <%= neg_properties.get("description") %>: <I><%=RuleDesc%></I> <BR>	
	</TD></TR>

	<TR><TD id="W_AucstyleBidcontrol_TableCell_4">
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

		 <%= neg_properties.get("MinBidAmount") %>: <I><%=formatted_MinValue%></I> <BR>	
	</TD></TR>


	<TR><TD id="W_AucstyleBidcontrol_TableCell_5">

<%
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

		 <%= neg_properties.get("MinBidQty") %>: <I><%=formatted_MinQty%></I> <BR>	
	</TD></TR>
<% } %>

<%
if (numericRangeDataBeans != null){
%>
	<TR><TD id="W_AucstyleBidcontrol_TableCell_6">
	       <TABLE class="list"  summary="<%= neg_properties.get("summaryText") %>" id="W_AucstyleBidcontrol_Table_2">
	       <TR  class="list_roles">
	         <TD class="list_header" id="W_AucstyleBidcontrol_TableCell_7"><%= neg_properties.get("RangeFrom") %> </TH>
	         <TD class="list_header" id="W_AucstyleBidcontrol_TableCell_8"><%= neg_properties.get("RangeTo") %> </TH>
	         <TD class="list_header" id="W_AucstyleBidcontrol_TableCell_9"><%= neg_properties.get("Increment") %> </TH>
		</TR>
<%
	for(int j=0;j<numericRangeDataBeans.length; j++) {         
		     String val_Range1 = numericRangeDataBeans[j].getLowerLimit().toString();
		     String val_Range2 = numericRangeDataBeans[j].getUpperLimit().toString();
		     String val_Incr   = numericRangeDataBeans[j].getIncrement().toString();           
%>
		<TR>
		<TD CLASS="list_info1" headers="t1" id="W_AucstyleBidcontrol_TableCell_10_<%=j%>">

            <%
			d   = new BigDecimal(val_Range1);
            	fmt = cm.getFormattedMonetaryAmount( new MonetaryAmount(d, defaultCurrency), storeAB, Integer.valueOf(lang));   
            %>
			<%= fmt.toString() %> 
		</TD>

		<TD CLASS="list_info1" headers="t2" id="W_AucstyleBidcontrol_TableCell_11_<%=j%>">
            <%
			d   = new BigDecimal(val_Range2);
            	fmt = cm.getFormattedMonetaryAmount( new MonetaryAmount(d, defaultCurrency), storeAB, Integer.valueOf(lang));   
            %>
			<%= fmt.toString() %> 
		</TD>
		<TD CLASS="list_info1" headers="t3" id="W_AucstyleBidcontrol_TableCell_12_<%=j%>">
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

</TABLE>

</FORM>
<SCRIPT LANGUAGE="Javascript">
	retrievePanelData();
</SCRIPT> 
</BODY>

</HTML>
