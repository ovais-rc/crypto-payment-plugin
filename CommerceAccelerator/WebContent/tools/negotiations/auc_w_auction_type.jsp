<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2014 All Rights Reserved.

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
//*  WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2000, 2002
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
 ===========================================================================-->

<%@  page import="com.ibm.commerce.negotiation.beans.*" %>
<%@  page import="com.ibm.commerce.negotiation.bean.commands.*" %>
<%@  page import="com.ibm.commerce.negotiation.objects.*"  %>
<%@  page import="com.ibm.commerce.negotiation.util.*"  %>
<%@  page import="com.ibm.commerce.negotiation.misc.*"  %>
<%@  page import="com.ibm.commerce.negotiation.operation.*"  %>
<%@  page import="com.ibm.commerce.beans.*"  %>
<%@  page import="com.ibm.commerce.command.*"  %>
<%@  page import="com.ibm.commerce.exception.*"  %>
<%@  page import="com.ibm.commerce.price.utils.*"  %>
<%@  page import="com.ibm.commerce.common.objects.*"  %>
<%@  page import="java.util.*"  %>
<%@  page import="java.text.*"  %>
<%@  page import="com.ibm.commerce.tools.test.*" %>
<%@  page import="com.ibm.commerce.tools.util.*" %>

<%@  page import="com.ibm.commerce.tools.util.UIUtil" %>

<%@include file="../common/common.jsp" %>

<%
	String ffmidvalue = UIUtil.getFulfillmentCenterId(request);

	String   autype = ""; 
	String   emptyString = new String("");
 	String   StoreId = "0";
 	Integer  aLang;
	String   lang =  "-1";  
      Locale   aLocale = null;
	String   locale = "en_US";

     //***Get lang id, locale and storeid from CommandContext
      CommandContext aCommandContext = (CommandContext)request.getAttribute("CommandContext");    
        if( aCommandContext!= null )
        {

            aLang = aCommandContext.getLanguageId();
            lang = aLang.toString();
            aLocale = aCommandContext.getLocale();
            locale = aLocale.toString();
            StoreId = aCommandContext.getStoreId().toString();
        }


	
     //***Get ownerid
     StoreAccessBean storeAB = com.ibm.commerce.registry.StoreRegistry.singleton().find(new Integer(StoreId));
     String ownerid = storeAB.getMemberId();
        
     //***Get currency        
     CurrencyManager cm = CurrencyManager.getInstance();
     Integer defaultLanguageId = new Integer(Integer.parseInt(lang));
     String defaultCurrency = cm.getDefaultCurrency(storeAB, defaultLanguageId);    

     // obtain the resource bundle for display
     Hashtable auctionNLS = (Hashtable)ResourceDirectory.lookup("negotiations.negotiationsNLS",aLocale);

%>

<jsp:useBean id="aslb" class="com.ibm.commerce.negotiation.beans.AuctionStyleListBean" >
<jsp:setProperty property="*" name="aslb" />
<jsp:setProperty property="auctStyleOwnerId" name="aslb" value="<%= ownerid %>" />
</jsp:useBean>

<HTML>
<HEAD>
<link rel=stylesheet href="<%= UIUtil.getCSSFile(aLocale) %>" type="text/css">

<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/negotiations/auc_common.js"></SCRIPT>

</HEAD>


<BODY class=content ONLOAD="initializeState();">
<BR><h1><%= auctionNLS.get("AuctType") %></h1>


   <FORM Name="TypeForm" id="TypeForm">
          <INPUT TYPE="radio"  NAME="SelectedRadio" VALUE="auctionStyle" id="WC_W_AuctionType_R1_In_TypeForm" checked>
       <LABEL for="WC_W_AuctionType_R1_In_TypeForm"> 	
           <%= auctionNLS.get("CreateStyle") %>
       </LABEL>
                   <TABLE id="WC_W_AuctionType_Table_1">
                      <TR>
                        <TD id="WC_W_AuctionType_TableCell_1">&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; 	
                        	<LABEL for="WC_W_AuctionType_StyleName_In_TypeForm"></LABEL>	   
    			        <SELECT NAME="StyleName" id="WC_W_AuctionType_StyleName_In_TypeForm">
    				<!-- Display styles from database *************************-->
    				<%
                                   com.ibm.commerce.beans.DataBeanManager.activate(aslb, request);

				   AuctionStyleDataBean[] styles = aslb.getAuctionStyles();
				%>   
  				    	<OPTION VALUE="Choice"><%= auctionNLS.get("SavedStyle") %>
				   <%
     					 for (int i = 0; i < styles.length ; i++ ) {
     					 AuctionStyleDataBean asb = (AuctionStyleDataBean)(styles[i]);
     					  %>
        				<OPTION VALUE="<%= asb.getName() %>">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%= asb.getName() %> 
     				    <% } %>
	    				<OPTION VALUE="Choice">-----------------------
					 <OPTION VALUE="Choice"><%= auctionNLS.get("BlankStyle") %>
				         <OPTION VALUE="Custom_Open_Cry" SELECTED>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%= auctionNLS.get("CustomOpenCry") %>
	         		         <OPTION VALUE="Custom_Sealed_Bid">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%= auctionNLS.get("CustomSealedBid") %>
	         			 <OPTION VALUE="Custom_Dutch">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%= auctionNLS.get("CustomDutch") %>
				</SELECT>
			    </TD>
                          </TR>
                        </TABLE><P>
         	
           <INPUT TYPE="radio"  NAME="SelectedRadio" VALUE="newAuction" id="WC_W_AuctionType_R2_In_TypeForm">
        <LABEL for="WC_W_AuctionType_R2_In_TypeForm">
             <%= auctionNLS.get("CreateNew") %>
        </LABEL>

         <TABLE width=600 id="WC_W_AuctionType_Table_2">
                 <TR >
		    <TD  WIDTH=5 id="WC_W_AuctionType_TableCell_2">
		    	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	             </TD>
	             <TD>
                    
		    <INPUT TYPE="radio" NAME="autype" VALUE="O" id="WC_W_AuctionType_R21_In_TypeForm" >
		    <LABEL for="WC_W_AuctionType_R21_In_TypeForm"> <%= auctionNLS.get("opencry") %> </LABEL>
                     <BR>
                     <%= auctionNLS.get("OpenCryDesc1") %>
		    </TD>
		  </TR>
		  
		  <TR > 
		  <TD  WIDTH=5 id="WC_W_AuctionType_TableCell_3">
		    	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	             </TD>	                  
		    <TD>
	             
                    
		    <INPUT TYPE="radio" NAME="autype" VALUE="SB" id="WC_W_AuctionType_R22_In_TypeForm">
		    <LABEL for="WC_W_AuctionType_R22_In_TypeForm"> <%= auctionNLS.get("sealedbid") %> </Label>	
		    
                    <BR>
                    <%= auctionNLS.get("SealedBidDesc1") %>
                    
		   </TD> 
		  </TR>
		  
		  <TR >
		  <TD  WIDTH=5 id="WC_W_AuctionType_TableCell_4">
		    	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	             </TD>
		    <TD>
	             
                   
		   <INPUT TYPE="radio" NAME="autype" VALUE="D" id="WC_W_AuctionType_R23_In_TypeForm">
		   <LABEL for="WC_W_AuctionType_R23_In_TypeForm"><%= auctionNLS.get("dutch") %> </LABEL>
                    <BR>
                    <%= auctionNLS.get("DutchDesc1") %>
               	    <TD>
		  </TR>

          </TABLE>    

<SCRIPT LANGUAGE="JavaScript">
var msgAuctionType  = '<%= UIUtil.toJavaScript( (String)auctionNLS.get("msgAuctionType") )  %>';
var msgAuctionStyle = '<%= UIUtil.toJavaScript( (String)auctionNLS.get("msgAuctionStyle") )  %>';

var temp;
var firstRadio;
var aType  = "";
var aStyle = "";
var i = 0;
var validated = "yes";
var temp;
var aDefault = null;

function initializeState() {


   
   //Restore auction style if the user has previously selected one 
   if ( parent.get(auctStyle, aDefault) != null ) {
       document.TypeForm.SelectedRadio[0].checked = true;
       aStyle =   parent.get(auctStyle, aDefault);   
       for(var i=0; i< document.TypeForm.StyleName.length; i++) 
       {
          if ( aStyle == document.TypeForm.StyleName.options[i].value)  
               document.TypeForm.StyleName.selectedIndex = i;
       }
   }  
   else if ( parent.get(auctType, aDefault) != null ) {
       document.TypeForm.SelectedRadio[1].checked = true;
       aType =   parent.get(auctType, aDefault);   
       for(var i=0; i< document.TypeForm.autype.length; i++)
       {
          if ( aType == document.TypeForm.autype[i].value) 
            document.TypeForm.autype[i].checked = true ;
       }
 
   } 

  parent.setContentFrameLoaded(true);

}

function savePanelData() {


  validated = "yes";
  firstRadio = getSelected(document.TypeForm.SelectedRadio);
  
  
  aStyle = "";
  aType = "";
  
  if ( firstRadio == "newAuction" ) {
    aType = getSelected(document.TypeForm.autype);
  }  
  else if ( firstRadio == "auctionStyle" ) {
    checkStyle(document.TypeForm.StyleName.options[document.TypeForm.StyleName.selectedIndex].value);
  }    

  // Save panel data
  parent.put(auctLang,  "<%= lang %>");   
  parent.put(auctStoreid, "<%= StoreId %>"); 

  parent.put(auctOwnerid,  "<%= ownerid %>");   
  parent.put(auctLocale,  "<%= locale %>");   
  parent.put(auctCur_ds,  "<%= defaultCurrency %>");   

  parent.put(auctStyle, aStyle);   
  parent.put(auctType,  aType);   
  parent.put("firsttime", "true"); 

  parent.put("<%= AuctionServerMessageHelper.EC_AUC_FULFILLMENT_CODE %>","<%= ffmidvalue %>");
 
  parent.addURLParameter("authToken", "${authToken}");
 
}
function validatePanelData() {
  

  if ( validated == "no" )
    return false;
  else  
    return true;
  

}

function getSelected(radioObject){
   
   var value = null;
   
   
   for(var i=0; i< radioObject.length; i++)
    {
        if (radioObject[i].checked) {
          value = radioObject[i].value;
          break;
        }
     }
       
   if ( value ==  null){
     alertDialog(msgAuctionType);
     validated = "no";
   }
       
   return value;
      
}

function checkStyle(profilename) {

   
   if(profilename == "Custom_Open_Cry" ) {
      aStyle = "";
      aType ="O";
   }   
   else if(profilename == "Custom_Sealed_Bid") {
          aStyle = "";
      	  aType ="SB";
   }   	  
   else if(profilename == "Custom_Dutch") {
          aStyle = "";
          aType ="D";
   }       
   else if(profilename == "Choice") {
          alertDialog(msgAuctionStyle);
          validated = "no";
          aStyle = "";
          aType = "";
   }
   else {		
 	aStyle = profilename;
 	aType = "";		

  }  
  
}

</SCRIPT>

</FORM>
</BODY>

</HTML>
