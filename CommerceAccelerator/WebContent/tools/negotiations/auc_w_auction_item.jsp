<%@page language="java" %>
<!-- ========================================================================
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//*  WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2000, 2016
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
 ===========================================================================-->
 <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">

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
 
<%@  page import="com.ibm.commerce.negotiation.beans.*" %>
<%@  page import="com.ibm.commerce.negotiation.bean.commands.*" %>
<%@  page import="com.ibm.commerce.catalog.objects.*" %>
<%@  page import="com.ibm.commerce.catalog.beans.*" %>
<%@  page import="com.ibm.commerce.negotiation.helpers.*" %>
<%@  page import="com.ibm.commerce.negotiation.objimpl.*" %>
<%@  page import="com.ibm.commerce.beans.*"  %>
<%@  page import="com.ibm.commerce.command.*"  %>
<%@  page import="com.ibm.commerce.common.objects.*" %>
<%@  page import="com.ibm.commerce.exception.*"  %>
<%@  page import="com.ibm.commerce.negotiation.objects.*"  %>
<%@  page import="com.ibm.commerce.negotiation.misc.*"  %>
<%@  page import="com.ibm.commerce.negotiation.operation.*"  %>
<%@  page import="com.ibm.commerce.negotiation.util.*"  %>
<%@  page import="com.ibm.commerce.search.beans.*" %>
<%@  page import="java.util.*"  %>
<%@  page import="java.text.*"  %>
<%@  page import="java.sql.*"  %>
<%@  page import="java.math.*"  %>
<%@  page import="com.ibm.commerce.utils.*" %>
<%@  page import="com.ibm.commerce.tools.test.*" %>
<%@  page import="com.ibm.commerce.tools.util.*" %>
<%@  page import="com.ibm.commerce.price.utils.*" %>

<%@include file="../common/common.jsp" %>

<%
     String   lang =  request.getParameter("lang");
     String   storeId =  request.getParameter("StoreId");
     String   ownerid =  request.getParameter("ownerid");
     String   austyle =  request.getParameter("austyle");
     String   autype =   request.getParameter("autype");
     String   itemFlag =  request.getParameter("itemFlag");

     Locale   aLocale = null;
     CommandContext aCommandContext = (CommandContext)request.getAttribute("CommandContext");    
     if( aCommandContext!= null )
     {
       aLocale = aCommandContext.getLocale();
     }

     //*** GET store object ***//        
     StoreAccessBean storeAB = com.ibm.commerce.registry.StoreRegistry.singleton().find(new Integer(storeId));

     //*** GET CURRENCY ***//	     
     CurrencyManager cm = CurrencyManager.getInstance();
     Integer defaultLanguageId = new Integer(Integer.parseInt(lang));
     String defaultCurrency = cm.getDefaultCurrency(storeAB, defaultLanguageId);    

     FormattedMonetaryAmount fmt = null;
     BigDecimal d= null;

     // obtain the resource bundle for display
     Hashtable auctionNLS = (Hashtable)ResourceDirectory.lookup("negotiations.negotiationsNLS",aLocale);
%>

<%
        if (itemFlag == null ) {
          itemFlag = "1";
        }
    	String   firsttime =  request.getParameter("firsttime");
	if (firsttime ==  null) {
	   firsttime = "true";
	}

      String   emptyString = "";
      String   zeroPrice = "0";
      String   sku = "";
	String   aMemberId = "";
	String   aName = "";
	String   aShortDesc = "";
	String   aCatentryId = "";
//	Double   quantity = null;
      String   quant_ds = "";
      String   quant_ds_char = "";
//	String   audesc = ""; 
	String   aubdrule = ""; 
 	String   auprdmacro = ""; 
 	String   aurulemacro = ""; 
 	String   auruletype = ""; 
	String   minbid = ""; 
	String   minbid_ds = ""; 
	String   aucur = ""; 
	String   pricing = ""; 
	String   audaydur = ""; 
	String   autimdur = ""; 
	String   auhourdur = ""; 
	String   aumindur = ""; 
// 	String   austdate = ""; 
	String   austtime = "";
//	String   auenddat = "";
	String   auendtim = "";
	String   audeposit = "";
	String   audeposit_ds = "";
	String   aucurprice = ""; 
	String   aucurprice_ds = ""; 
//	String   austAMPM = "";
//	String   auendAMPM = "";
      String   styyyy = "";
      String   stmm = "";
      String   stdd = "";
	String   endyyyy = "";
	String   endmm = "";
   	String   enddd = "";
	String   sthh = "";
	String   stmin = "";
	String   stss = "";
	String   endhh = "";
	String   endmin = "";
	String   endss = "";

//        TimestampHelper tsh = new TimestampHelper(0, 0, 1, 0, 0, 0, 0); 
        String start_time = "";
        String end_time = "";
         
%>
<%      if (    austyle != null
             && !austyle.equals(emptyString) 
             && austyle != auctionNLS.get("CustomOpenCry")
             && austyle != auctionNLS.get("CustomSealedBid")
             && austyle != auctionNLS.get("CustomDutch")  )
    {
 %>
     	<jsp:useBean id="asb" class="com.ibm.commerce.negotiation.beans.AuctionStyleDataBean" >
  	<jsp:setProperty property="auctStyleName" name="asb" value="<%= austyle %>" />
  	<jsp:setProperty property="auctStyleOwnerId"  name="asb" value="<%= ownerid %>" />
  	</jsp:useBean>
         

<%  
        com.ibm.commerce.beans.DataBeanManager.activate(asb, request);
       
  	aubdrule = asb.getBidRuleId(); 
   	auprdmacro = asb.getItemPage(); 
   	aurulemacro = asb.getRulePage();
  	//out.println("<BR>aurulemacro retrieved from the database is: " + aurulemacro);
   	
   	auruletype = asb.getCloseType(); 
   	minbid = asb.getReservePrice();
	if (minbid != null && minbid.length() > 0) 
	{
		d   = new BigDecimal(minbid);
		if (d.doubleValue() > 0) {
	      	fmt = cm.getFormattedMonetaryAmount( new MonetaryAmount(d, defaultCurrency), storeAB, Integer.valueOf(lang));   
			minbid_ds = fmt.getFormattedValue();
		}
	}

   	aucur = asb.getCurrency(); 
   	autype = asb.getAuctionType();  //****
   	pricing = asb.getClosePriceRule(); 
      
	quant_ds = asb.getQuantity();
        if (quant_ds!= null && quant_ds.length() > 0){
		Double dtemp = Double.valueOf(quant_ds);
 		Integer itemp = new Integer(dtemp.intValue());
	 	java.text.NumberFormat numberFormatter;
		if (itemp.intValue() > 0 ) {
		 	numberFormatter = java.text.NumberFormat.getNumberInstance(aLocale);
 			quant_ds_char = numberFormatter.format(itemp);
		}
	}
        
   	audeposit = asb.getDeposit();
	if (audeposit != null && audeposit.length() > 0) 
	{
		d   = new BigDecimal(audeposit);
		if (d.doubleValue() > 0) {
	      	fmt = cm.getFormattedMonetaryAmount( new MonetaryAmount(d, defaultCurrency), storeAB, Integer.valueOf(lang));   
			audeposit_ds = fmt.getFormattedValue();
		}
	}

   	aucurprice = asb.getOpenPrice();
	if (aucurprice != null && aucurprice.length() > 0) 
	{
		d   = new BigDecimal(aucurprice);
		if (d.doubleValue() > 0) {
	      	fmt = cm.getFormattedMonetaryAmount( new MonetaryAmount(d, defaultCurrency), storeAB, Integer.valueOf(lang));   
			aucurprice_ds = fmt.getFormattedValue();
		}
	}

 	audaydur = asb.getDurationDays(); 
   	autimdur  = asb.getAuctDurationTime(); 
   	auhourdur = asb.getAuctDurationHour();
   	aumindur  = asb.getAuctDurationMinute();

        Calendar cal = Calendar.getInstance();
        java.util.Date today = new java.util.Date();
//        java.util.Date future;

   	//Calculate start date using auction style start days
   	String sdays = asb.getAuctStartDays();
   	if ( !sdays.equals(emptyString) ) { 
   	   int stdays = Integer.parseInt(sdays);
  	   cal.setTime(today);
	   cal.add(Calendar.DATE, stdays);
	   styyyy = String.valueOf(cal.get(Calendar.YEAR));
	   stmm = String.valueOf(cal.get(Calendar.MONTH) + 1);
   	   stdd = String.valueOf(cal.get(Calendar.DAY_OF_MONTH));
        }
           	
   	//Get Start hour, minute, second 
   	//Format 2 times for either 12 or 24 hour clock display
        Timestamp start_ts = asb.getStartTimeInEntityType();
        if (start_ts == null) {
          start_time = "";  
        } else {
          start_time = TimestampHelper.getTimeFromTimestamp(start_ts);
        }
        String stime = asb.getAuctStartTime();
   	if ( !stime.equals(emptyString) ) { 
   	  sthh = asb.getAuctStartHour();
   	  stmin = asb.getAuctStartMinute();
	  stss = asb.getAuctStartSecond();
   	  if ( (sthh.substring(0,1)).equals("0") ) {
   	     sthh = sthh.substring(1);
   	  }
   	  if ( (stmin.substring(0,1)).equals("0") ) {
   	     stmin = stmin.substring(1);
   	  }
   	  if ( (stss.substring(0,1)).equals("0") ) {
   	     stss = stss.substring(1);
   	  }
        }
          
   	//Calculate end date using auction style end days 
   	String edays = asb.getAuctEndDays();
   	if ( !edays.equals(emptyString) ) {
     	   int enddays = Integer.parseInt(edays);
  	   cal.setTime(today);
	   cal.add(Calendar.DATE, enddays);
	   endyyyy = String.valueOf(cal.get(Calendar.YEAR));
	   endmm = String.valueOf(cal.get(Calendar.MONTH) + 1);
   	   enddd = String.valueOf(cal.get(Calendar.DAY_OF_MONTH));
          }
          
   	//Get End hour, minute, second
   	//Format 2 times for either 12 or 24 hour clock display
        Timestamp end_ts = asb.getEndTimeInEntityType();
        if ( end_ts == null) {
          end_time = "";
        } else {
          end_time = TimestampHelper.getTimeFromTimestamp(end_ts);
        }
        String etime = asb.getAuctEndTime();
   	if ( !etime.equals(emptyString) ) { 
   	  endhh = asb.getAuctEndHour();
   	  endmin = asb.getAuctEndMinute();
   	  endss = asb.getAuctEndSecond();
   	  
   	  if ( (endhh.substring(0,1)).equals("0") ) {
   	     endhh = endhh.substring(1);
   	  }
   	  if ( (endmin.substring(0,1)).equals("0") ) {
   	     endmin = endmin.substring(1);
   	  }
   	  if ( (endss.substring(0,1)).equals("0") ) {
   	     endss = endss.substring(1);
   	  }

        }
   
   }
%>

<%        
	sku      = request.getParameter("sku");
	
	//Execute only if sku is not null and it is not coming back from the find list or dialog indicated
	// by the itemFlag
	//  itemFlag 0=not found, 1=look for sku entered on the screen 2=coming back from the find list
	if ( sku != null && !sku.equals(emptyString)  && !itemFlag.equals("2") ) {
	   itemFlag = "1";
          try {
            	AdvancedCatEntrySearchListDataBean searchBean = new AdvancedCatEntrySearchListDataBean();
				searchBean.setCommandContext(aCommandContext);
				searchBean.setStoreId(storeId.toString());
				searchBean.setLangId( lang.toString() );
				searchBean.setBuyable("1");
				searchBean.setPublished("1");
				searchBean.setIsPackage(true);
				searchBean.setIsItem(true);
	      		if (sku != null && !sku.equals(emptyString) ) {
					searchBean.setSku(sku);
					searchBean.setSkuCaseSensitive( SearchConstants.CASE_SENSITIVE );
					searchBean.setSkuOperator( SearchConstants.OPERATOR_LIKE);
	     		 }
				searchBean.populate();
				CatalogEntryDataBean[] tempResult = searchBean.getResultList();
              	if ( tempResult.length==0 ) {
                	itemFlag = "0"; 
              	} else {
                if ( tempResult.length== 1 ) {
	                   //AuctionItemDataBean aib = (AuctionItemDataBean) aVector.elementAt(0); 
	                   CatalogEntryDataBean aib=(CatalogEntryDataBean)tempResult[0];
	                   CatalogEntryDescriptionAccessBean descAB = aib.getDescription();
	                   aMemberId   = aib.getMemberId().toString();
	                   aName       = descAB.getName();
	                   aShortDesc  = descAB.getShortDescription();
	                   aCatentryId = aib.getCatalogEntryID();	 
                 } else {
                   itemFlag ="2"; 
                 }
               }
          }
          catch( Exception e ) {  itemFlag = "0"; }    
        }
%>   


<HTML lang="en">
<HEAD>
<SCRIPT>
   var itemFlag  = "<%= UIUtil.toJavaScript(itemFlag) %>"; 
   var firsttime  = "<%= UIUtil.toJavaScript(firsttime) %>"; 

</SCRIPT>
<link rel=stylesheet href="<%= UIUtil.getCSSFile(aLocale) %>" type="text/css">
</HEAD>
<SCRIPT SRC="/wcs/javascript/tools/negotiations/auc_common.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/negotiations/auc_datetime.js"></SCRIPT>
<%@include file="../common/NumberFormat.jsp" %>


<BODY class="content" ONLOAD="initializeState();">
<BR><h1><%= auctionNLS.get("AuctItem") %></h1>


   <FORM Name="ItemForm" >   
   <INPUT TYPE=HIDDEN NAME="StoreId" VALUE="<%= UIUtil.toHTML(storeId) %>">
   <INPUT TYPE=HIDDEN NAME="lang" VALUE="<%= UIUtil.toHTML(lang) %>">
   <INPUT TYPE=HIDDEN NAME="autype" VALUE="<%= UIUtil.toHTML(autype) %>">
   <INPUT TYPE=HIDDEN NAME="auruletype" VALUE="<%= auruletype %>">
   <INPUT TYPE=HIDDEN NAME="austyle" VALUE="<%= UIUtil.toHTML(austyle) %>">
   <INPUT TYPE=HIDDEN NAME="ownerid" VALUE="<%= UIUtil.toHTML(ownerid) %>">
   <INPUT TYPE=HIDDEN NAME="itemFlag" VALUE="itemFlag">
   <INPUT TYPE=HIDDEN NAME="firsttime" VALUE="firsttime">
   

<TABLE>
	<TR>
	   <TD>
	     <TABLE>
		   <TR>
		     <TD> 
	                <LABEL for="sku">
			<%= auctionNLS.get("SKU") %>&nbsp;<%= auctionNLS.get("mandatory") %></LABEL><BR>
			<INPUT TYPE="text"
				NAME="sku"
				SIZE=17 
				id="sku"
				MAXLENGTH="31"
				VALUE="<%= UIUtil.toHTML(sku) %>"
				onChange="findItem(document.ItemForm.sku.value)">
		        
		    </TD>
                    <TD >
                       <BR><INPUT type="BUTTON" Name="Find"  Value="<%= auctionNLS.get("find") %>" 
                        class="enabled" style="width:200px;"
                        onClick="open_item_dialog()" >
                    </TD>
                 </TR>   
             </TABLE>    
          </TD>
	</TR>
<SCRIPT>
   //The following code is pretty confusing... However, it works ok. 
   //I am retrieving the product data for display from different places.
   //We can improve it later.
   
   var aDefault = null;
   var aSKU = null;
   var aMemberId = null;
   var aName = null;
   var aShortDesc = null;
   var aCatentryId = null;
   var name_title      = "<%= UIUtil.toJavaScript( (String)auctionNLS.get("ItemName")) %>";
   var shortdesc_title = "<%= UIUtil.toJavaScript( (String)auctionNLS.get("ItemDesc")) %>";

   
   //Check to see if we are coming back from the Item Find Dialog
   if (top.getData("aSKU") != undefined || top.getData("aSKU") != null) {
     document.ItemForm.sku.value = top.getData("aSKU"); 
     aSKU                        = top.getData("aSKU"); 
     aMemberId                   = top.getData("aMemberId"); 
     aName                       = top.getData("aName"); 
     aShortDesc                  = top.getData("aShortDesc"); 
     aCatentryId                 = top.getData("aCatentryId"); 
     itemFlag                    = "1";
     document.ItemForm.itemFlag.value = itemFlag; 
   }  
   else //we are coming back from another wizard panel
     if (    parent.get(auctSKU, aDefault) != null 
          && parent.get(auctProdDesc, aDefault) != null 
          && parent.get(auctProdName, aDefault) != null ) {
        aSKU         = parent.get(auctSKU, aDefault);
        aName        = parent.get(auctProdName, aDefault);
        aShortDesc   = parent.get(auctProdDesc, aDefault);
        aCatentryId  = parent.get(auctItem, aDefault);   
     }    
     else 
       if (itemFlag != "2" ) {
        aSKU       = "<%= UIUtil.toJavaScript(sku) %>";
        aMemberId  = "<%= aMemberId %>";
        aName      = "<%= UIUtil.toJavaScript( (String)aName) %>";
        aShortDesc = "<%= UIUtil.toJavaScript( (String)aShortDesc) %>";
        aCatentryId = "<%= aCatentryId %>";
     }  

   if ( aSKU != null && aSKU != "") {
     document.writeln('<TR>');
     document.writeln('<TD>');
     document.writeln('<TABLE><TR><TD>');
     document.writeln(name_title + ': <I>' + aName + '</I><BR>');
     document.writeln('</TD>');
     document.writeln('</TR>');
     document.writeln('<TR>');
     document.writeln('<TD>');
     document.writeln(shortdesc_title + ': <I>' + aShortDesc + '</I><BR>');
     document.writeln('</TD>');
     document.writeln('</TR>');
     document.writeln('</TD></TR></TABLE>');
     document.writeln('</TD>');
     document.writeln('</TR>');
   }


</SCRIPT>
 
        <TR>
           <TD>
	     <TABLE>
		   <TR>
		     <TD> 
         
		        <LABEL for="quant">
			<%= auctionNLS.get("AuctionQuantity") %> <%= auctionNLS.get("mandatory") %></LABEL><BR>
			<INPUT TYPE="text"
				NAME="quant"
				SIZE=17 
				id="quant"
				MAXLENGTH="64"
				VALUE=<%= quant_ds_char %>>
		        
                    </TD>
                 </TR>   
             </TABLE>    

  	  </TD>
        </TR>

</TABLE>

<SCRIPT LANGUAGE="JavaScript">
var msgItem           = "<%= UIUtil.toJavaScript( (String)auctionNLS.get("msgItem") ) %>";
var msgInvalidItem    = "<%= UIUtil.toJavaScript( (String)auctionNLS.get("msgInvalidItem") ) %>";
var msgMandatoryField = "<%= UIUtil.toJavaScript( (String)auctionNLS.get("msgMandatoryField") ) %>";
var msgInvalidNumber  = "<%= UIUtil.toJavaScript( (String)auctionNLS.get("msgInvalidNumber") ) %>";
var msgInvalidInteger = "<%= UIUtil.toJavaScript( (String)auctionNLS.get("msgInvalidInteger") ) %>";
var msgQuantityCheck  = "<%= UIUtil.toJavaScript( (String)auctionNLS.get("msgQuantityCheck") ) %>";
var msgNegativeNumber = "<%= UIUtil.toJavaScript( (String)auctionNLS.get("msgNegativeNumber") ) %>";

var locale; 
var lang;
var currency;
var temp = ""; 
var aTime;
var ampmIndicator;
var delimiter; 
var i = 0;

function initializeState()
{
    
   locale   = parent.get(auctLocale, aDefault);
   currency = parent.get(auctCur_ds, aDefault);	
   lang     = parent.get(auctLang, aDefault);
   firsttime = 	parent.get("firsttime", "false");
   
   if ( itemFlag == "0" ) {
     reprompt(document.ItemForm.sku, msgInvalidItem);
     document.ItemForm.sku.value = "";	
   }  
   else
     if ( itemFlag == "2" ) 
        goToItemList();  
   
   if ( firsttime != "true" && parent.get(auctQuantity, aDefault) != null  ) 
     document.ItemForm.quant.value =   parent.get(auctQuantity_ds, aDefault);  
   

   if ( parent.get(auctSKU, aDefault) == null ) 
      document.ItemForm.sku.focus();
   else   
      document.ItemForm.quant.focus();

   parent.setContentFrameLoaded(true);

  

   if ( "<%= UIUtil.toJavaScript(autype) %>" == "D" ) 
   {
      parent.setPanelAttribute("Duration", "hasFinish", "NO");
   }
   else
   {
      parent.setPanelAttribute("Duration", "hasFinish", "YES");
   }

}


function savePanelData() {

  // Save panel data in model 

  parent.put("itemFlag", itemFlag );
  parent.put(auctTimeFlag, temp );
  parent.put(auctItem, aCatentryId);   
  parent.put(auctSKU, document.ItemForm.sku.value);   
  parent.put(auctProdDesc, aShortDesc );   
  parent.put(auctProdName, aName );   
  parent.put(auctQuantity, document.ItemForm.quant.value);   
  parent.put(auctQuantity_ds, document.ItemForm.quant.value);   

  //Only store auction style data in model if first time is true
  if (firsttime == "true") {
        document.ItemForm.firsttime.value ="false";
        parent.put("firsttime", "false" );
        if ( AMPMIndicator == "Yes") {
         temp = "1";  
        } else {
         temp = "0";    
        }
        parent.put(auctType,  "<%= UIUtil.toJavaScript(autype) %>");
  	parent.put(auctRuleMacro, "<%= aurulemacro %>");   
  	parent.put(auctPrdMacro, "<%= auprdmacro %>");   
  	parent.put(auctRuleType, "<%= auruletype %>");   
  	parent.put(auctBdrule, "<%= aubdrule %>");   
  	parent.put(auctCur, "<%= aucur %>");   
  	parent.put(auctPricing, "<%= pricing %>");   
	if ("<%= audaydur %>" == "-1") {
  		parent.put(auctDayDur, "");  
	} else {
		parent.put(auctDayDur, "<%= audaydur %>");
	}
  	parent.put(auctTimDur, "<%= autimdur %>");   
  	parent.put(auctHourDur, "<%= auhourdur %>");   
  	parent.put(auctMinDur, "<%= aumindur %>");   
  	if ("<%= UIUtil.toJavaScript(austyle) %>" == "") {
     	   parent.put(auctStYear_ds, "");   
     	   parent.put(auctStMonth_ds, "");   
     	   parent.put(auctStDay_ds, "");   
     	   parent.put(auctStTime_ds, "<%= austtime %>");   
     	   parent.put(auctEndYear_ds, "");   
     	   parent.put(auctEndMonth_ds, "");   
     	   parent.put(auctEndDay_ds, "");   
     	   parent.put(auctEndTime_ds, "<%= auendtim %>");   
     	   parent.put(auctCur, currency);   
     	   parent.put(auctBdrule, "<%= aubdrule %>");   
           parent.put(auctRuleMacro, "auc_rule.jsp");  
           parent.put(auctPrdMacro,  "auc_ItemDisplay.jsp");   

       } 
       else {
    
    	  //--format start date--
          parent.put(auctStYear_ds, "<%= styyyy %>");   
   	  parent.put(auctStMonth_ds, "<%= stmm %>");   
   	  parent.put(auctStDay_ds, "<%= stdd %>");   
    
    	  //--format start time--
   	  if ( AMPMIndicator == "Yes") {   // 12 hour clock format
     	    temp = getTimeFormat("<%= sthh %>", "<%= stmin %>","<%= stss %>");
     	    delimiter = " ";
    	    aTime = temp.substring(0, temp.indexOf(delimiter));
     	    ampmIndicator = temp.substring(temp.lastIndexOf(delimiter) + 1);
     	    parent.put(auctStTime_ds, aTime);   
     	    parent.put(auctStAMPM, ampmIndicator);   
   	  } 
	  else {
            temp = "<%= start_time %>";
            parent.put(auctStTime_ds, temp );   
          }
    
          //--format end date--
          parent.put(auctEndYear_ds, "<%= endyyyy %>");   
          parent.put(auctEndMonth_ds, "<%= endmm %>");   
          parent.put(auctEndDay_ds, "<%= enddd %>");   

          //--format end time--
          if ( AMPMIndicator == "Yes") {   // 12 hour clock format
            temp = getTimeFormat("<%= endhh %>", "<%= endmin %>","<%= endss %>");
            delimiter = " ";
            aTime = temp.substring(0, temp.indexOf(delimiter));
            ampmIndicator = temp.substring(temp.lastIndexOf(delimiter) + 1);
            parent.put(auctEndTime_ds, aTime);
            parent.put(auctEndAMPM, ampmIndicator); 
          }     
          else {
            temp = "<%= end_time %>";
            parent.put(auctEndTime_ds, temp );   
          }
       }   
       parent.put(auctMinbid, "<%= minbid %>");   
       parent.put(auctMinbid_ds, "<%= minbid_ds %>");   
       parent.put(auctDeposit, "<%= audeposit %>");   
       parent.put(auctDeposit_ds, "<%= audeposit_ds %>");   
       if ( "<%= UIUtil.toJavaScript(autype) %>" == "D" ) {
         parent.put(auctCurPrice, "<%= aucurprice %>");   
         parent.put(auctCurPrice_ds, "<%= aucurprice_ds %>");   
       } else {
         parent.put(auctCurPrice, "<%= zeroPrice %>");   
       }

  }  //end first time is true
  
    parent.addURLParameter("authToken", "${authToken}");
}

function validatePanelData() {
  

  if (isInputStringEmpty(document.ItemForm.sku.value)) {
       reprompt(document.ItemForm.sku, msgMandatoryField); 
       return false;
    }	


  if (isInputStringEmpty(document.ItemForm.quant.value)) {
       reprompt(document.ItemForm.quant, msgMandatoryField); 
       return false;
  }
  else {
       if(!isValidInteger(document.ItemForm.quant.value, lang)){ 	
  	  reprompt(document.ItemForm.quant, msgInvalidInteger);
  	  return false;
       }
       var p_quant = document.ItemForm.quant.value;
       if (p_quant.charAt(0) == '-'){
	  reprompt(document.ItemForm.quant, msgNegativeNumber);
   	  return false;  
       }
       temp = strToNumber(document.ItemForm.quant.value, lang);
       if ( temp < 1 ) {
  	  reprompt(document.ItemForm.quant, msgQuantityCheck);
  	 return false;
       }
       parent.put(auctQuantity, temp);   
  }
    
  

}


function findItem(theSKU) {
  
  //Refresh the panle so we can validate item number and retrieve item description
  alertDialog(msgItem);

    var form= document.ItemForm;

    parent.put(auctItem, aCatentryId);
    parent.put(auctSKU, theSKU);
    parent.put(auctProdDesc, aDefault);   
    parent.put(auctProdName, aDefault);   
    parent.put(auctQuantity, form.quant.value);
    parent.put(auctStyle, form.austyle.value);
        aSKU = null;
        aMemberId = null;
        aName = null;
        aShortDesc = null;
        aCatentryID = null;

        top.saveData(aSKU, "aSKU");
        top.saveData(aMemberId, "aMemberId");
        top.saveData(aName, "aName");
        top.saveData(aShortDesc, "aShortDesc");
        top.saveData(aCatentryId, "aCatentryId");


    form.action = document.location;
    form.itemFlag.value = "1"
    form.submit();
 
}

function open_item_dialog()
{
        document.ItemForm.itemFlag.value = "2"; 
        savePanelData();
        
        aSKU = null;
        aMemberId = null;
        aName = null;
        aShortDesc = null;
        aCatentryID = null;

        top.saveData(aSKU, "aSKU");
        top.saveData(aMemberId, "aMemberId");
        top.saveData(aName, "aName");
        top.saveData(aShortDesc, "aShortDesc");
        top.saveData(aCatentryId, "aCatentryId");

	// if inside merchant center
	if (parent.isInsideMC()) { 
		// save parent "model" to TOP frame before calling item search dialog
		top.saveModel(parent.model);

		// set returning panel to be current panel
		top.setReturningPanel(parent.getCurrentPanelAttribute("name"));

		// launch item search dialog
		top.setContent("<%= auctionNLS.get("ItemDialog") %>", "/webapp/wcs/tools/servlet/DialogView?XMLFile=negotiations.auctionItemDialog", true);
							
	} else
		alertDialog("Wizard Chaining can only be launched from inside Merchant Center.");
}

function goToItemList() {

        document.ItemForm.itemFlag.value = "2"; 
        savePanelData();

        aSKU = null;
        aMemberId = null;
        aName = null;
        aShortDesc = null;
        aCatentryID = null;

        top.saveData(aSKU, "aSKU");
        top.saveData(aMemberId, "aMemberId");
        top.saveData(aName, "aName");
        top.saveData(aShortDesc, "aShortDesc");
        top.saveData(aCatentryId, "aCatentryId");


	// if inside merchant center
	if (parent.isInsideMC()) { 
		// save parent "model" to TOP frame before calling item list
		top.saveModel(parent.model);

		// set returning panel to be current panel
		top.setReturningPanel(parent.getCurrentPanelAttribute("name"));

		// launch item list
	        var url = "/webapp/wcs/tools/servlet/NewDynamicListView?ActionXMLFile=negotiations.auctionItemListSC&cmd=AuctionItemList"
  				+ "&listsize=15&startindex=0&refnum=0&orderby=PARTNUMBER&selected=SELECTED"
  				+ "&sku=" + document.ItemForm.sku.value;

		top.setContent("<%= auctionNLS.get("ItemList") %>", url, true); 
							
	} else
		alertDialog("Wizard Chaining can only be launched from inside Merchant Center.");
  
}
</SCRIPT>
</FORM>
</BODY>

</HTML>
