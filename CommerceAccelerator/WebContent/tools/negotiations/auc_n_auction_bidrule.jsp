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
<%@  page import="java.util.*"  %>
<%@  page import="java.text.*"  %>
<%@  page import="java.math.*"  %>
<%@  page import="com.ibm.commerce.tools.test.*" %>
<%@  page import="com.ibm.commerce.tools.util.*" %>
<%@  page import="com.ibm.commerce.negotiation.beans.*" %>
<%@  page import="com.ibm.commerce.command.*" %>
<%@  page import="com.ibm.commerce.common.objects.*" %>
<%@  page import="com.ibm.commerce.price.utils.*" %>
<%@include file="../common/common.jsp" %>

<HTML>
<HEAD>
<%
     Locale   aLocale = null;
     String   StoreId = "0";
     String   lang = "-1"; 	
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

     String emptyString = new String("");
     String selectedAuctionType = (String)request.getParameter("autype");
     String selectedBidRule     = (String)request.getParameter("aubdrule");
     if ( selectedBidRule == null || selectedBidRule.equals(emptyString))
       selectedBidRule = "0"; 
     String editable            =  request.getParameter("editable");
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
var editable = parent.get(auctEditable); 

function initializeState()
{
     
   parent.setContentFrameLoaded(true);
}

function savePanelData()
{
	var form=document.BidruleForm;
     if( editable =="true" ) {  
 	parent.put(auctBdrule ,form.aubdrule.value);
	parent.put(auctType,form.autype.value);
     } 	
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

<FORM NAME="BidruleForm">
<INPUT TYPE=HIDDEN NAME="aubdrule" VALUE="">
<INPUT TYPE=HIDDEN NAME="autype" VALUE="<%=UIUtil.toHTML(selectedAuctionType)%>">
<INPUT TYPE=HIDDEN NAME="editable" VALUE="<%= UIUtil.toHTML(editable) %>">

 <TABLE>
<% 
    if ( selectedAuctionType.equals("D") ) {
%>
    <TR> 
 	<TD>
 	  <%= auctionNLS.get("NoRuleForDutch") %>  
   	</TD>
     </TR>
<%  } else if (   selectedBidRule.equals("0") && editable.equals("false") ) {
%>
    <TR> 
 	<TD>
 	  <%= auctionNLS.get("msgNoBidRule") %>  
   	</TD>
     </TR>

<%  } else if ( editable.equals("true") ) {
%>
       <%@ include file="auc_n_auction_bidrule_t.jspf" %>

<%  } else {
%>   
       <%@ include file="auc_n_auction_bidrule_f.jspf" %>

<%  } 
%>   

</TABLE>

</FORM>
<SCRIPT LANGUAGE="Javascript">
   if ( "<%= UIUtil.toJavaScript(editable) %>" == "true")
      retrievePanelData();
</SCRIPT> 
</BODY>
</HTML>

