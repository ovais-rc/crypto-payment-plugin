<%--
//********************************************************************
//*-BR 20011005-1600 updated
//*------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2000, 2002
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
//*
--%>
 
<%@ page language="java"%>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@include file="../common/common.jsp" %>

<!-- Get the resource bundle with all the NLS strings -->
<%
  CommandContext cmdContextLocale = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
  Locale jLocale = cmdContextLocale.getLocale();
  Hashtable vendorPurchaseNLS = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("inventory.VendorPurchaseNLS", jLocale);
  
  //Remove the following line once a "Search Results" string is added to VendorPurchaseNLS
  Hashtable orderLabels = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("order.orderLabels", jLocale);
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
<HTML>
<HEAD>
<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
<%= fHeader%>
<LINK rel="stylesheet" href="<%= UIUtil.getCSSFile(jLocale) %>" type="text/css">
<SCRIPT LANGUAGE="JavaScript">
<!---- hide script from old browsers
  var badChar = '/"#%\'\\';
  var Item;
  var SKU;
  var GroupBy;

  function onLoad(){
    parent.setContentFrameLoaded(true);
  }

  function validateString(word){// start validateString
    for(var i = 0; i <= word.length-1 ; i++){ //start for
      var letter = word.charAt(i);
	if (badChar.indexOf(letter) == -1){ //start if
      
      }else{
	  switch( letter ){  //start switch
	  case '/':
	    alertDialog('<%=UIUtil.toJavaScript((String)vendorPurchaseNLS.get("noForwardSlash"))%>');
	    break;
	  case'"':
	    alertDialog('<%=UIUtil.toJavaScript((String)vendorPurchaseNLS.get("noDoubleQuote"))%>');
	    break;
	  case '#':
  	    alertDialog('<%=UIUtil.toJavaScript((String)vendorPurchaseNLS.get("noPound"))%>');
	    break;
	  case '%':
  	    alertDialog('<%=UIUtil.toJavaScript((String)vendorPurchaseNLS.get("noPercent"))%>');
	    break;
	  case '\\':
  	    alertDialog('<%=UIUtil.toJavaScript((String)vendorPurchaseNLS.get("noBackSlash"))%>');
	    break;
	  case'\'':
  	    alertDialog('<%=UIUtil.toJavaScript((String)vendorPurchaseNLS.get("noSingleQuote"))%>');
	    break;
        }  //end switch
        return "false";
      }//end if
    }//end for
    return "true";
  }//end validateString

  function validate(){
    Item  = trim(document.itemsSearch.searchItemName.value);
    SKU = trim(document.itemsSearch.searchSKU.value);
    GroupBy = document.itemsSearch.groupBy.value;
    if ((Item == null || Item == "") && (SKU == null || SKU =="")){
      alertDialog("<%=UIUtil.toJavaScript((String) vendorPurchaseNLS.get("findDialogNoCriteria"))%>");;
      return "false";
    }
    var good = validateString(Item);
    var good1 = validateString(SKU);
    if (good == "false"){
      return "false";
    }else if(good1 =="false"){
      return "false";
    }else{
      return "true";
    }
  }   

  function getResultList(){
    var urlParams = new Object();
    var url = "/webapp/wcs/tools/servlet/NewDynamicListView" ;
    urlParams.searchItemName=Item;
    urlParams.searchSKU =  SKU ;
    urlParams.groupBy = GroupBy ;
    urlParams.ActionXMLFile =   "inventory.InventoryList";
    urlParams.cmd = "InventoryListView";
    
    //Replace 1st parameter with "Search Results" entry from VendorPurchaseNLS
    top.setContent('<%=UIUtil.toJavaScript((String)vendorPurchaseNLS.get("findResultBCT"))%>',
                       url,
                       true, 
                       urlParams);
  }
              
// -->
</script>
<META name="GENERATOR" content="IBM WebSphere Studio">
</head>

<BODY CLASS=content ONLOAD="onLoad();">

<script language="javascript"><!-- alert("InventoryQueryDialog.jsp"); --></script> 

<H1><%= UIUtil.toHTML((String)vendorPurchaseNLS.get("inventoryQueryTitle")) %> </H1>
<P><%=vendorPurchaseNLS.get("findInventoryInst")%></P>

<FORM name="itemsSearch">
  <TABLE>
    <TR>
      <TD>
	    <LABEL for="searchItemName"><%= UIUtil.toHTML((String)vendorPurchaseNLS.get("catentryName")) %></LABEL><br>
        <input type="text" name="searchItemName" id="searchItemName" maxlength=254>
      </TD>
    </TR>
    <TR>
      <TD>
        <LABEL for="searchSKU"><%= UIUtil.toHTML((String)vendorPurchaseNLS.get("partNumber")) %></LABEL><br>
        <input type="text" name="searchSKU" id="searchSKU" maxlength=64>
        </TD>
    </TR>
    <TR>
       <TD>
            <LABEL for="groupBy"><%= UIUtil.toHTML((String)vendorPurchaseNLS.get("GroupBy")) %></LABEL> <BR>
            <SELECT name="groupBy" id="groupBy">
      		    <OPTION value="none" selected="selected"></OPTION>
      		    <OPTION value="ffc"><%= UIUtil.toHTML((String)vendorPurchaseNLS.get("QueryfulfillmentCenter")) %></OPTION>
      		    <OPTION value="vendor"><%= UIUtil.toHTML((String)vendorPurchaseNLS.get("Queryvendor")) %></OPTION>
      		 </SELECT>	
        </TD>
    </TR>
  </TABLE> 
</FORM>
</BODY>
</HTML>

