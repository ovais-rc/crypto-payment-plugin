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
			com.ibm.commerce.negotiation.beans.*,
			com.ibm.commerce.negotiation.util.*,
			com.ibm.commerce.negotiation.misc.*,
			com.ibm.commerce.negotiation.operation.*,
			com.ibm.commerce.command.*,
			com.ibm.commerce.common.objects.*,
			com.ibm.commerce.price.utils.*,
			java.math.*" %>

<%@include file="../common/common.jsp" %>

<HTML>
<HEAD>

<%
      //*** GET LANGID AND STOREID FROM COMANDCONTEXT ***//
      CommandContext aCommandContext = (CommandContext)request.getAttribute("CommandContext");    
 	String   StoreId = "0";
	String   lang =  "-1";  
	Locale   locale = null;
      if( aCommandContext!= null ){
            lang = aCommandContext.getLanguageId().toString();
            locale = aCommandContext.getLocale();
            StoreId = aCommandContext.getStoreId().toString();
      }
	if (locale == null)
		locale = new Locale("en","US");

     StoreAccessBean storeAB = com.ibm.commerce.registry.StoreRegistry.singleton().find(new Integer(StoreId));

     //*** GET CURRENCY ***//             
     CurrencyManager cm = CurrencyManager.getInstance();
     Integer defaultLanguageId = new Integer(Integer.parseInt(lang));
     String defaultCurrency = cm.getDefaultCurrency(storeAB, defaultLanguageId);

     FormattedMonetaryAmount fmt = null;

	//*** GET THE RESOURCE BUNDLE BASED ON LOCALE ***//
	Hashtable neg_properties = (Hashtable)ResourceDirectory.lookup("negotiations.negotiationsNLS",locale);

%>

<link rel="stylesheet" href="<%= UIUtil.getCSSFile(locale) %>" type="text/css">

<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
<%@include file="../common/NumberFormat.jsp" %>
<SCRIPT>
var msgMandatoryField	= '<%= UIUtil.toJavaScript((String)neg_properties.get("msgMandatoryField")) %>';
var msgInvalidSize	= '<%= UIUtil.toJavaScript((String)neg_properties.get("msgInvalidSize")) %>';
var ds_name   		= '<%= UIUtil.toJavaScript((String)neg_properties.get("BidRuleName")) %>';
var ds_desc   		= '<%= UIUtil.toJavaScript((String)neg_properties.get("BidRuleDesc")) %>';

function initializeState(){
	var code = parent.getErrorParams();
	if (code == "rulenameMissing")
		alertDialog(ds_name + ":" + msgMandatoryField);
	else if (code == "ruledescTooLong")
		alertDialog(ds_desc + ":" + msgInvalidSize);

   // If coming into this notebook for the first time,
   // populate Model with all the required data from the
   // bean. Format the data for display according to Locale.
   if (parent.get("firstvisit","true") != "false") {
	populateModel();
	formatModelData();
   }
   parent.put("firstvisit","false");
   
   retrievePanelData();
   parent.setContentFrameLoaded(true);

}

function savePanelData(){
	var form=document.bidrulenotebookForm;
	
	parent.put("ruletype",form.ruletype.value);
	parent.put("cntrlrule",form.cntrlrule.value);
	parent.put("rulename",form.rulename.value);
	parent.put("ruledesc",form.ruledesc.value);
	parent.put("currency","<%= defaultCurrency %>");
	parent.put("lang","<%= lang %>");
}


function retrievePanelData(){
	var form = document.bidrulenotebookForm;

	form.cntrlrule.value = parent.get("cntrlrule","");
	form.rulename.value  = parent.get("rulename","");
	form.ruledesc.value  = parent.get("ruledesc","");
	form.ruletype.value  = parent.get("ruletype","O");
}

// This function picks up all the data coming from the database and 
// formats them in accordance with the User's Locale. Gets executed the very
// first time ONLY.
function formatModelData(){
	var tempquant = parent.get("minquant","");
	var lang = parent.get("lang","-1");

	// if quantity is not null or 0, format it
	if (tempquant != null && !isInputStringEmpty(tempquant.toString())){
		if (tempquant.toString().charAt(0) != '0'){
			var t = strToNumber(tempquant,lang);
			parent.put("minquant_ds",formatInteger(t.toString(),lang));
		}
		else
			parent.put("minquant_ds","");
	}
}

function noenter() {
	return !(window.event && window.event.keyCode == 13); 
}
</SCRIPT>

<%
	//*** GET THE DATA FROM THE ControlRuleDataBean AND POPULATE MODEL ***//
	String rule_Id = request.getParameter("rule_Id"); 
	String rule_Type = request.getParameter("rule_Type");
	String rule_Name = null,rule_Desc=null,minvalue=null,minquant=null;
      String val_Range1 = null;
      String val_Range2 = null;
	String val_Incr= null;

	out.println("<SCRIPT LANGUAGE='Javascript'>"); 
	out.println("function populateModel(){"); 
	out.println("parent.put('currency','" + defaultCurrency + "')");
	out.println("parent.put('lang','" + lang + "')");
	if (rule_Id != null && !rule_Id.equals("")) { 
		if (rule_Type.equals("O")) { 
%>
	            <jsp:useBean id="aOCRule" class="com.ibm.commerce.negotiation.beans.OpenCryBidControlRuleDataBean" >
      	      <jsp:setProperty property="*" name="aOCRule" />  
            	<jsp:setProperty property="id" name="aOCRule" value="<%= rule_Id %>" />
	            </jsp:useBean> 
<%
      	      com.ibm.commerce.beans.DataBeanManager.activate(aOCRule, request); 
			rule_Name = aOCRule.getRuleName();
			rule_Desc = aOCRule.getRuleDesc();
			minvalue  = aOCRule.getMinValue();
			minquant  = aOCRule.getMinQuant();

			out.println("parent.put('cntrlrule','" + aOCRule.getId() + "')");                        
			out.println("parent.put('classId','"  + aOCRule.getRuleInterpreterClassId() + "')");                        
			com.ibm.commerce.negotiation.beans.NumericRangeDataBean[] numericRangeDataBeans = aOCRule.getPriceRanges();
			if (numericRangeDataBeans == null)
				out.println("parent.put('VVLength','0')");
			else {
	  			out.println("parent.put('VVLength','"  + numericRangeDataBeans.length + "')");
				String ruletext = "";
  				for(int j=0;j<numericRangeDataBeans.length; j++) 
				{         
					val_Range1 = numericRangeDataBeans[j].getLowerLimit().toString();
					val_Range2 = numericRangeDataBeans[j].getUpperLimit().toString();
					val_Incr   = numericRangeDataBeans[j].getIncrement().toString(); 
					ruletext   += val_Range1 + "," +val_Range2 + "," + val_Incr + ";" ;
				
					String fm_range1="",fm_range2="",fm_incr="";
					BigDecimal d   = new BigDecimal(val_Range1);
					fmt = cm.getFormattedMonetaryAmount( new MonetaryAmount(d, defaultCurrency), storeAB, Integer.valueOf(lang));   
					fm_range1 = fmt.getFormattedValue();

					d   = new BigDecimal(val_Range2);
					fmt = cm.getFormattedMonetaryAmount( new MonetaryAmount(d, defaultCurrency), storeAB, Integer.valueOf(lang));   
					fm_range2 = fmt.getFormattedValue();

					d   = new BigDecimal(val_Incr);
					fmt = cm.getFormattedMonetaryAmount( new MonetaryAmount(d, defaultCurrency), storeAB, Integer.valueOf(lang));   
					fm_incr = fmt.getFormattedValue();

					String temptext = fm_range1 + " - "  + fm_range2 + " = " + fm_incr;
					String tempvalue = val_Range1 + "," +val_Range2 + "," + val_Incr + ";" ;
					out.println("parent.put('ValueVectorText" + j + "' ,'" + temptext + "')");
					out.println("parent.put('ValueVectorValue" + j + "' ,'" + tempvalue + "')");
	  			} 
				out.println("parent.put('ruletext','"  + ruletext + "')");
			}
	}
	else if (rule_Type.equals("SB")) {
%>
	            <jsp:useBean id="aSBRule" class="com.ibm.commerce.negotiation.beans.SealedBidControlRuleDataBean" >
      	      <jsp:setProperty property="*" name="aSBRule" />  
            	<jsp:setProperty property="id" name="aSBRule" value="<%= rule_Id %>" />
	            </jsp:useBean> 
<%
	     	      com.ibm.commerce.beans.DataBeanManager.activate(aSBRule, request); 
			rule_Name = aSBRule.getRuleName();
			rule_Desc = aSBRule.getRuleDesc();
			minvalue  = aSBRule.getMinValue();
			minquant  = aSBRule.getMinQuant();
			out.println("parent.put('cntrlrule'," + aSBRule.getId() + ")");                  
			out.println("parent.put('classId','"  + aSBRule.getRuleInterpreterClassId() + "')");                        

	}

	if(rule_Type.equals("SB") || rule_Type.equals("O")) 
	{
			//*** NULL CHECKS ***//
			if (rule_Desc == null) rule_Desc = "";
			String fm_minvalue = "";
			if (minvalue  == null || minvalue.length() == 0) 
				minvalue = "";
			else {
					BigDecimal d   = new BigDecimal(minvalue);
					if (d.doubleValue() > 0) {
	      				fmt = cm.getFormattedMonetaryAmount( new MonetaryAmount(d, defaultCurrency), storeAB, Integer.valueOf(lang));   
						fm_minvalue = fmt.getFormattedValue();
					}
			}

			if (minquant  == null || minquant.length() == 0) 
				minquant = "";
			else {
				Double d   = Double.valueOf(minquant);
				if (d.intValue() > 0) 
					minquant = String.valueOf(d.intValue());
				else
					minquant="";
			}
			out.println("parent.put('ruledesc','" + UIUtil.toJavaScript(rule_Desc) + "')");                        
			out.println("parent.put('minvalue','" + minvalue + "')");                        
			out.println("parent.put('minvalue_ds','" + fm_minvalue + "')");
			out.println("parent.put('minquant','" + minquant + "')");                        
			out.println("parent.put('ruletype','" + UIUtil.toJavaScript(rule_Type) + "')");                        
			out.println("parent.put('rulename','" + UIUtil.toJavaScript(rule_Name) + "')");                        
	}

    }
    out.println("}"); 
    out.println("</SCRIPT>"); 
%>
</HEAD>

<BODY class=content ONLOAD="initializeState();">

<BR><h1><%= neg_properties.get("BRuleGeneral") %></h1>

<FORM NAME="bidrulenotebookForm" id="bidrulenotebookForm">
<INPUT type="hidden" name="cntrlrule" value="<%= UIUtil.toHTML(rule_Id) %>" id="WC_N_BidruleInfo_cntrlrule_In_bidrulenotebookForm">
<INPUT type="hidden" name="rulename" value="<%= rule_Name %>" id="WC_N_BidruleInfo_rulename_In_bidrulenotebookForm">
<INPUT type="hidden" name="ruletype" value="<%= UIUtil.toHTML(rule_Type) %>" id="WC_N_BidruleInfo_ruletype_In_bidrulenotebookForm">

<TABLE ALIGN="LEFT" id="WC_N_BidruleInfo_Table_1">
	<TR>
	<TD id="WC_N_BidruleInfo_TableCell_1">
		<%= neg_properties.get("name") %>: <I><%= UIUtil.toHTML(rule_Name) %></I>	
	</TD>
	</TR>
	<TR>
	<TD id="WC_N_BidruleInfo_TableCell_2">
		<%= neg_properties.get("auctionType") %>: 

<% if (rule_Type.equals(AuctionConstants.EC_AUCTION_OPEN_CRY_TYPE)){ %>
			<I><%= neg_properties.get("opencry") %></I>
<% }else if (rule_Type.equals(AuctionConstants.EC_AUCTION_SEALED_BID_TYPE)){ %>
			<I><%= neg_properties.get("sealedbid") %></I>
<% } %>
		<BR><BR>	
	</TD>
	</TR>
	<TR>
	<TD id="WC_N_BidruleInfo_TableCell_3">
		<Label for="WC_N_BidruleInfo_ruledesc_In_bidrulenotebookForm">
		<%= neg_properties.get("description") %>
	 	</Label><BR>
	 	<TEXTAREA NAME="ruledesc" COLS=50 ROWS=3 WRAP=VIRTUAL id="WC_N_BidruleInfo_ruledesc_In_bidrulenotebookForm">
		</TEXTAREA>
		
	</TD>
	</TR>
</TABLE>

</FORM>
</BODY>
</HTML>


