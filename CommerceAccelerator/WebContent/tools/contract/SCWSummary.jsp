<%
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2000, 2016
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
//*
%>

<%@page import="java.util.*" %>
<%@page import="com.ibm.commerce.tools.util.*" %>
<%@page import="com.ibm.commerce.tools.common.*" %>
<%@page import="com.ibm.commerce.command.*" %>
<%@page import="com.ibm.commerce.tools.resourcebundle.*" %>
<%@page import="com.ibm.commerce.server.*" %>
<%@page import="com.ibm.commerce.common.objects.*" %>
<%@page import="com.ibm.commerce.contract.util.ECContractCmdConstants"%>

<%@include file="../common/common.jsp" %>
<%@include file="../contract/SCWCommon.jsp" %>
<%
   try{
         String default_lang = null;
         try {
         LanguageDescriptionAccessBean langDescAB = new LanguageDescriptionAccessBean();
         langDescAB.setInitKey_languageId(lang_id);
         langDescAB.setInitKey_descriptionLanguageId(lang_id);

         default_lang = langDescAB.getDescription();
         } catch (Exception e) {
         }
%>

<html>
<head>
<link rel=stylesheet href="<%= UIUtil.getCSSFile(locale) %>" type="text/css">
<script language="JavaScript" src="/wcs/javascript/tools/common/Util.js">
</script>
<script language="JavaScript">
var summaryArrayLabel = new Array();
var summaryArray = new Array();
var org_Owner = null;
var org_Address = null;

   summaryArrayLabel["summaryStoreUniqueIdentifier"] = "<%=UIUtil.toJavaScript((String)resourceBundle.get("summaryStoreUniqueIdentifier"))%>";
   summaryArrayLabel["summaryStoreDisplayName"] = "<%=UIUtil.toJavaScript((String)resourceBundle.get("summaryStoreDisplayName"))%>";
   summaryArrayLabel["summaryStoreDescription"] = "<%=UIUtil.toJavaScript((String)resourceBundle.get("summaryStoreDescription"))%>";
   summaryArrayLabel["summaryDefaultStoreCurr"] = "<%=UIUtil.toJavaScript((String)resourceBundle.get("summaryDefaultStoreCurr"))%>";
   summaryArrayLabel["summaryDefaultStoreLang"] = "<%=UIUtil.toJavaScript((String)resourceBundle.get("summaryDefaultStoreLang"))%>";
   if(parent.get("SWCGeneral").storeCategory != ''){
      summaryArrayLabel["summaryStoreCat"] = "<%=UIUtil.toJavaScript((String)resourceBundle.get("summaryStoreCat"))%>";
   }
   summaryArrayLabel["summaryStoreOrg"] = "<%=UIUtil.toJavaScript((String)resourceBundle.get("summaryStoreOrg"))%>";
   if(parent.get("SWCGeneral").storeOrganizationSharedOwner != ''){
      summaryArrayLabel["summarySharedOrg"] = "<%=UIUtil.toJavaScript((String)resourceBundle.get("summarySharedOrg"))%>";
   }
   summaryArrayLabel["summaryOrgAddress"] = "<%=UIUtil.toJavaScript((String)resourceBundle.get("summaryOrgAddress"))%>";
   summaryArrayLabel["summaryStoreTypeModel"] = "<%=UIUtil.toJavaScript((String)resourceBundle.get("summaryStoreTypeModel"))%>";
   summaryArrayLabel["summarySharedCatalog"] = "<%=UIUtil.toJavaScript((String)resourceBundle.get("summarySharedCatalog"))%>";
   summaryArrayLabel["summaryFulfillment"] = "<%=UIUtil.toJavaScript((String)resourceBundle.get("summaryFulfillment"))%>";
   if(parent.get("payments") != null && (parent.get("payments").paymentList.length > 0 || parent.get("payments").selectedMethodsText.length > 0)){
      summaryArrayLabel["summaryPayments"] = "<%=UIUtil.toJavaScript((String)resourceBundle.get("summaryPayments"))%>";
   }
   summaryArrayLabel["summaryAdminEmail"] = "<%=UIUtil.toJavaScript((String)resourceBundle.get("summaryAdminEmail"))%>";


   if(parent.get("SWCGeneral").storeIdentifier != ''){
      summaryArray["summaryStoreUniqueIdentifier"] = parent.get("SWCGeneral").storeIdentifier;
   }
   if(parent.get("SWCGeneral").storeName != ''){
      summaryArray["summaryStoreDisplayName"] = parent.get("SWCGeneral").storeName;
   }
   if(parent.get("SWCGeneral").storeDescription != ''){
      summaryArray["summaryStoreDescription"] = parent.get("SWCGeneral").storeDescription;
   }
   if(parent.get("SWCGeneral").notificationEmail != ''){
      summaryArray["summaryAdminEmail"] = parent.get("SWCGeneral").notificationEmail;
   }
   if(parent.get("SWCGeneral").storeDefaultCurrencyName != ''){
      summaryArray["summaryDefaultStoreCurr"] = parent.get("SWCGeneral").storeDefaultCurrencyName;
   }
   if(parent.get("SWCGeneral").storeOrganizationName != ''){
      summaryArray["summaryStoreOrg"] = parent.get("SWCGeneral").storeOrganizationName;
   }
   if(parent.get("SWCGeneral").storeOrganizationSharedOwner != ''){
      summaryArray["summarySharedOrg"] = parent.get("SWCGeneral").storeOrganizationSharedOwner;
   }
   if(parent.get("SWCStoreTypeData").storeType != ''){
      summaryArray["summaryStoreTypeModel"] = parent.get("SWCStoreTypeData").storeType;
   }
   if(parent.get("SWCSharedCatalogData").sharedCatalog != ''){
      summaryArray["summarySharedCatalog"] = parent.get("SWCSharedCatalogData").sharedCatalog;
   }
   if("<%=default_lang%>" != null && "<%=default_lang%>" != ""){
      summaryArray["summaryDefaultStoreLang"] = "<%=default_lang%>";
   }
   if(parent.get("SWCGeneral").storeCategoryName != ''){
      summaryArray["summaryStoreCat"] = parent.get("SWCGeneral").storeCategoryName;
   }


function init(){
   if (parent.get("InternalConfigError", false)){
         parent.remove("InternalConfigError");
         alertDialog("<%= UIUtil.toJavaScript((String)resourceBundle.get("storeCreationFailed"))%>");
        }
   parent.setContentFrameLoaded(true);
}


function generateSummaryTable(){

   var htmlText = null;
        htmlText = "<TABLE border=0>";
   for(var label in summaryArrayLabel){
    if (summaryArray[label] != null && summaryArray[label] != '<BR>'){   
      htmlText += "<TR height=30>";
      htmlText += "<TD VALIGN=TOP>";
      htmlText += summaryArrayLabel[label];
      htmlText += "</TD>";
      htmlText += "<TD width=50>";
      htmlText += "</TD>";
      htmlText += "<TD VALIGN=TOP>";
      if(summaryArray[label] != null && summaryArray[label] != ''){
            htmlText += '<I>' + summaryArray[label] + '</I>';
      }else{
         htmlText += '<I>' + '<%= UIUtil.toJavaScript((String)resourceBundle.get("summaryNA"))%>' + '</I>';
      }
      htmlText += "</TD>";
      htmlText += "</TR>";
    }
   }
   htmlText += "</TABLE>";
   document.getElementById("summaryTable").innerHTML = htmlText;
}


function generateFulfillment(){

   var fulfillments = null;
   var text = '';

   if(parent.get("fulfillmentCenters") != null){
      fulfillments = parent.get("fulfillmentCenters").fulfillmentCentersArray;

      for (var i=0;i<fulfillments.length;i++){
         text += fulfillments[i] + '<BR>';
      }      
   }

   return text + '<BR>';
}



function generatePaymentTable(){
   var paymentList = null;
   var text = '';

   if(parent.get("payments") != null){
      paymentList = parent.get("payments").paymentList;
      for (var i=0;i<paymentList.length;i++){

         if(paymentList[i].paymentType == "<%=ECContractCmdConstants.EC_CONTRACT_SCW_PAYMENTS_CUSTOM_OFFLINE%>"){
            text += paymentList[i].paymentMethodNameDisplayText + '<BR>';
         }else{
            var brand = '';
            if(paymentList[i].brandName != ''){
               brand = paymentList[i].brandName;
            }else{
               brand = paymentList[i].brand;
            }
            text += brand + ' - ' + paymentList[i].currencyName + '<BR>';
         }
      }
      paymentList = parent.get("payments").selectedMethodsText;
      for (var j=0;j<paymentList.length;j++){
            text += paymentList[j] + '<BR>';
      }      
    }
   return text + '<BR>';
}



function generateAddress(){

   var text = '';

   <%
   if (locale.toString().equals("ja_JP")||locale.toString().equals("ko_KR")||locale.toString().equals("zh_CN")||locale.toString().equals("zh_TW")){
      // Format Name (Lastname, Firstname) for Double Byte Countries

      if (locale.toString().equals("ja_JP")){
         // Format Address (Country, Zip, State/Region, City, Street Address) for Japan
      %>
         text += '<FONT class="address">' +
         summaryArray["summaryOrgCountry"] + '&nbsp;' + summaryArray["summaryOrgZipCode"] + '<BR>' +
         summaryArray["summaryOrgState"] + '&nbsp;' + summaryArray["summaryOrgCity"] + '<BR>' +
         summaryArray["summaryOrgAddress"] + '<BR></FONT><BR>';
      <%
      }else if (locale.toString().equals("ko_KR")){
         // Format Address (Zip, Country, State/Region, City, Street Address) for Korea
      %>
         text += '<FONT class="address">' +
         summaryArray["summaryOrgCountry"] + '&nbsp;' + summaryArray["summaryOrgZipCode"] + '<BR>' +
         summaryArray["summaryOrgState"] + '&nbsp;' + summaryArray["summaryOrgCity"] + '<BR>' +
         summaryArray["summaryOrgAddress"] + '<BR></FONT><BR>';
      <%
      }else if (locale.toString().equals("zh_CN")){
         // Format Address (Country, State/Region, City, Street Address, Zip) for China
      %>
         text += '<FONT class="address">' +
         summaryArray["summaryOrgCountry"] + '<BR>' +
         summaryArray["summaryOrgState"] + '&nbsp;' + summaryArray["summaryOrgCity"] + '<BR>' +
         summaryArray["summaryOrgAddress"] + '<br>' +
         summaryArray["summaryOrgZipCode"] + '<BR></FONT><BR>';
      <%
      }else if (locale.toString().equals("zh_TW")){
         // Format Address (Country, State/Region, City, Zip, Street Address) for Taiwan
      %>
         text += '<FONT class="address">' +
         summaryArray["summaryOrgCountry"] + '<BR>' +
         summaryArray["summaryOrgState"] + '&nbsp;' + summaryArray["summaryOrgCity"] + '<BR>' +
         summaryArray["summaryOrgZipCode"] + '<BR>' +
         summaryArray["summaryOrgAddress"] + '<BR></FONT><BR>';
      <%
      }

   }else{

      // Format Address : Single Byte Countries
      if (locale.toString().equals("fr_FR")||locale.toString().equals("de_DE")||locale.toString().equals("it_IT")||locale.toString().equals("es_ES")){
         // Format Address(Zip,City,State/Region,Country) for France, Germany, Italy and Spain
   %>
         text += '<FONT class="address">' +
         summaryArray["summaryOrgAddress"] + '<BR>' +
         summaryArray["summaryOrgZipCode"] + '&nbsp;' + summaryArray["summaryOrgCity"] + '<BR>' +
         summaryArray["summaryOrgState"] + '&nbsp;' + summaryArray["summaryOrgCountry"] + '<BR></FONT><BR>';
      <%
      }else{
         // Format Address(City,State/Region,Country & Zip) for Brazil and English US and unhandled locales.
      %>
         text += '<FONT class="address">' +
         summaryArray["summaryOrgAddress"] + '<BR>' +
         summaryArray["summaryOrgCity"] + '&nbsp;' + summaryArray["summaryOrgState"] + '<BR>' +
         summaryArray["summaryOrgCountry"] + '&nbsp;' + summaryArray["summaryOrgZipCode"] + '<BR></FONT><BR>';
   <%
      }
   }

   %>

   return text;
}

</script>
</head>

<body onload="init()" class="content">

<h1><%=UIUtil.toHTML((String)resourceBundle.get("summaryPanelTitle"))%></h1>

<div id="summaryTable">
</div>

<script>
   var org_id= null;
   if(parent.get("SWCGeneral").storeOrganizationName != ''){
      org_id = parent.get("SWCGeneral").storeOrganization;
   }

   var sourceText = "/webapp/wcs/tools/servlet/SCWSummaryIframeView?orgID=" + org_id;
   document.writeln('<IFRAME src='
                  + sourceText
                  + ' title="<%=UIUtil.toJavaScript((String)resourceBundle.get("summaryPanelTitle"))%>"'
                  + ' id="storeCreationIframe" STYLE="visibility:hidden; height:130; width:300; position:absolute; top:300; left:500" />');

</script>
</body>
</html>
<%
    }catch (Exception e){ %>
   <script language="JavaScript">
      document.URL="/webapp/wcs/tools/servlet/SCWErrorView";

</script>
    <% }
%>



