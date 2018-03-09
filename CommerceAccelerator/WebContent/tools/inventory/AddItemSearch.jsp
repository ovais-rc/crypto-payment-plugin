<%--
//********************************************************************
//*-------------------------------------------------------------------
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
var Item = "";
var SKU = "";

function onLoad(){
  parent.setContentFrameLoaded(true);
}

function validateString(word){
  for(var i = 0; i <= word.length-1 ; i++){
    var letter = word.charAt(i);
	 
    if (badChar.indexOf(letter) == -1){
      
    }else{
	   switch( letter ){
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

		}
      return "false";
    }
  }
  return "true";
}

function validate(){

  Item  = trim(document.itemsSearch.searchItemName.value);
  SKU = trim(document.itemsSearch.searchSKU.value);
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
  var URLParam = new Object();
  if (Item == ""){
    Item = null ;
  }
  if (SKU == ""){
    SKU = null ;
  }
  if (Item == null){
    if (SKU != null){
      SKU = SKU + '%';
    } else {
      Item = '' ;
      SKU = '' ;
    }
  }else {
    Item = '%' + Item + '%';
    if (SKU != null){
      SKU = SKU + '%';
    } else {
		
    }
  }

  URLParam.searchItemName= Item;
  URLParam.searchSKU=  SKU ;
  URLParam.XMLFile="inventory.AddItemListDialog";
  var searchResultURL = "/webapp/wcs/tools/servlet/DialogView"  ;
  top.saveData(URLParam,"AddItemSearch");
  top.mccmain.submitForm(searchResultURL,URLParam);
  top.refreshBCT();
}
   
// -->
</script>
</head>

<BODY CLASS=content ONLOAD="onLoad();">

<H1><%= UIUtil.toHTML((String)vendorPurchaseNLS.get("vendorPOItemFind")) %> </H1>
<SCRIPT>
  document.writeln('<P>');
  document.writeln('<%= UIUtil.toJavaScript(vendorPurchaseNLS.get("findProductInst"))%>');
  document.writeln('</P>');
</SCRIPT>

<script language="javascript"> <!-- alert("AddItemSearch.jsp"); --> </script> 

<FORM name="itemsSearch">
  <TABLE border=0 cellspacing=0 cellpadding=0>
    <TR>
      <TD>
        <LABEL for="searchItemName"><%= UIUtil.toHTML((String)vendorPurchaseNLS.get("itemName")) %></LABEL>
      </TD>
    </TR>
    <TR>
      <TD>
        <input type="text" name="searchItemName" id="searchItemName" maxlength=254>
      </TD>
    </TR>
    <TR>
      <TD>
        <LABEL for="searchSKU"><%= UIUtil.toHTML((String)vendorPurchaseNLS.get("sku")) %></LABEL>
      </TD>
    </TR>
    <TR>
      <TD>
        <input type="text" name="searchSKU" id="searchSKU" maxlength=64>
      </TD>
    </TR>
  </TABLE> 
</FORM>
</BODY>
</HTML>

