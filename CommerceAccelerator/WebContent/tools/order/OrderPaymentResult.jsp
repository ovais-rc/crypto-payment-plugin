

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2001, 2016 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%@ page language="java" import="java.util.*" %>
<%@ page import="com.ibm.commerce.server.*" %>
<%@ page import="com.ibm.commerce.command.*" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.tools.util.UIUtil" %>
<%@include file="../common/common.jsp" %>

<%
CommandContext cmdContext = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
Locale jLocale = cmdContext.getLocale();

JSPHelper URLParameters = new JSPHelper(request);
String displayPaymentFor = URLParameters.getParameter("displayPaymentFor");

Hashtable paymentBuyPagesNLS = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("order.paymentBuyPagesNLS", jLocale);
Hashtable orderMgmtNLS = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("order.orderMgmtNLS", jLocale);
%>

<html>
<head>
   <title><%= UIUtil.toHTML( (String)orderMgmtNLS.get("cardholderInformation")) %></title>
   <link rel="stylesheet" href="<%= UIUtil.getCSSFile(jLocale) %>" type="text/css" />
   <script type="text/javascript" src="/wcs/javascript/tools/common/Util.js"></script>
</head>

<body class="content">
<form name="f1">
<script type="text/javascript">
<!-- <![CDATA[
var aProfile = new Object();
<%
String name = "";
String value = "";
Enumeration paramNames	= request.getParameterNames();

String buyPageInfo = "";
String cardBrand = "";
String policyId = "";
String paymentTCId = "";
String description = "";
String billingAddressId = "";
while (paramNames.hasMoreElements()) {
   name = (String)paramNames.nextElement();      
   value = request.getParameter(name);
   if (name.equals("buyPageInfo"))
      buyPageInfo = value;
   else if (name.equals("cardBrand"))
      cardBrand = value;
   else if (name.equals("policyId"))
      policyId = value;
   else if (name.equals("paymentTCId"))
      paymentTCId = value;
   else if (name.equals("description"))
      description = value;
   else if (name.equals("billingAddressId"))
      billingAddressId = value;
%>
aProfile["<%= UIUtil.toJavaScript(name) %>"] = "<%= UIUtil.toJavaScript(value) %>";
<%
}
String includePage = "/tools/order/buyPages/" + buyPageInfo + ".jsp";
%>


// function to masked any text.
// Takes two parameters: aText, and number of unmasked characters at the end
function mask(aText, numberUnmasked)
{
   var maskedText = "";
   
   if ( (aText != "") && (aText.length > 4) )
   {
      for (var k=0; k<aText.length-4; k++)
         if ( (aText.charAt(k) != "-") && (aText.charAt(k) != " ") )
            maskedText += "*";

      maskedText += aText.substring(aText.length-4, aText.length);
   }
   else
      maskedText = aText;
   
   return maskedText;
}

//[[>-->
</script>

<%
if (!cardBrand.equals(""))
   request.setAttribute("cardType", cardBrand);
 
request.setAttribute("resourceBundle", paymentBuyPagesNLS);
%>
<jsp:include page="<%= includePage %>" flush="true" />

<input type="hidden" name="policyId" value="<%= UIUtil.toHTML(policyId) %>" />
<input type="hidden" name="paymentTCId" value="<%= UIUtil.toHTML(paymentTCId) %>" />
<input type="hidden" name="description" value="<%= UIUtil.toHTML(description) %>" />
<% if (!billingAddressId.equals("")) { %>
      <input type="hidden" name="billingAddressId" value="<%= UIUtil.toHTML(billingAddressId) %>" />
<% } %>

</form>

<script type="text/javascript">
<!-- <![CDATA[
   
   var order = parent.parent.get("order");
   var orderToChange = order["<%= displayPaymentFor %>"];
   var payment = orderToChange["payment"];
   
   // pre-fill information
   //
   // 1. pre-fill with a combination of PaymentTC chosen and payment object
   // 2. pre-fill with current PaymentTC chosen 
   //    if payment policy Id != passed payment profile policy Id
   //
   if ( (defined(payment)) && (payment.policyId == aProfile.policyId) ) {
      for (var i in payment)
      {
         if ( (defined(aProfile[i])) && (aProfile[i] != "") )
         {           
            if ( i == "cardNumber" )
            {
               // mask the entire number except for last four digits
               var displayCardNumber = mask(aProfile[i], 4);
               useValue = displayCardNumber;
            }
            else
            {
               useValue = aProfile[i];
            }
         }
         else if ( payment[i] != "" )
         {
            useValue = payment[i];
         }
         else
         {
            useValue = "";
         }
         
         if ( defined(document.f1.elements[i]) )
         {
            if ( document.f1.elements[i].type == "select-one" )
            {
               for (var j=0; j<document.f1.elements[i].length; j++)
               {
                  if (document.f1.elements[i].options[j].value == useValue)
                  {
                     document.f1.elements[i].options[j].selected = true;
                     break;
                  }
               }
            }
            else
            {
               document.f1.elements[i].value = useValue;
            }
         }
      }
   }
   else
   {
      for (var i in aProfile)
      {
         if ( defined(document.f1.elements[i]) )
         {
            if ( document.f1.elements[i].type == "select-one" )
            {
               for (var j=0; j<document.f1.elements[i].length; j++)
               {
                  if (document.f1.elements[i].options[j].value == aProfile[i])
                  {
                     document.f1.elements[i].options[j].selected = true;
                     break;
                  }
               }
            }
            else
            {
               if ( i == "cardNumber" )
               {
                  // mask the entire number except for last four digits
                  var displayCardNumber = mask(aProfile[i], 4);
                  document.f1.elements[i].value = displayCardNumber;
               }
               else
               {
                  document.f1.elements[i].value = aProfile[i];
               }
            }
         }
      }
   }

   
   // function to disable input fields in the payment snip files
   // if the payment TC defines the particular payment entry.
   // Otherwise, it lets the user modify the input fields.
   function snipJSPOnChange(anObjName)
   {
      for (var i in aProfile)
      {
         if ( (i == anObjName) && (aProfile[i] != "") )
         {
            alertDialog("<%= UIUtil.toJavaScript( (String)orderMgmtNLS.get("fieldCannotBeModified")) %>");
            if ( document.f1.elements[anObjName].type == "select-one" )
            {
               for (var j=0; j<document.f1.elements[anObjName].length; j++)
               {
                  if (document.f1.elements[anObjName].options[j].value == aProfile[anObjName])
                  {
                     document.f1.elements[anObjName].options[j].selected = true;
                     break;
                  }
               }
            }
            else
            {
               if ( i == "cardNumber" )
               {
                  // mask the entire number except for last four digits
                  var displayCardNumber = mask(aProfile[anObjName], 4);
                  document.f1.elements[anObjName].value = displayCardNumber;
               }
               else
               {
                  document.f1.elements[anObjName].value = aProfile[anObjName];
               }
            }
            break;
         }
      }
   }
//[[>-->
</script>

</body>
</html>



