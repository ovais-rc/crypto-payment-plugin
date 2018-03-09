<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2009 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<!--   02/05/2002 ES
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2001, 2002
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
-->
<%@ page language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.ibm.commerce.beans.DataBeanManager" %>
<%@ page import="com.ibm.commerce.tools.util.ResourceDirectory" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.tools.xml.*" %>
<%@ page import="com.ibm.commerce.inventory.beans.ReleaseShipDataBean" %>
<%@ page import="com.ibm.commerce.inventory.beans.*" %>
<%@ page import="com.ibm.commerce.tools.common.ui.taglibs.*" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.server.JSPHelper" %>
<%@ page import="com.ibm.commerce.utils.TimestampHelper" %>
<%@ page import="com.ibm.commerce.tools.util.UIUtil" %>
<%@ page import="com.ibm.commerce.inventory.commands.InventoryConstants" %>

<%@ include file="../common/common.jsp" %>

<jsp:useBean id="releaseShipList" scope="request" class="com.ibm.commerce.inventory.beans.ReleaseShipListDataBean">
</jsp:useBean>

<%
   Hashtable FulfillmentNLS = null;
   ReleaseShipDataBean shipIDs[] = null; 
   int numberOfShipIDs = 0; 

   CommandContext cmdContext = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
   Long userId = cmdContext.getUserId();
   Locale localeUsed = cmdContext.getLocale();

   Integer langId = cmdContext.getLanguageId();
   String sLang = langId.toString();
   String sLocale = sLang.trim();

   // obtain the resource bundle for display
   FulfillmentNLS = (Hashtable)ResourceDirectory.lookup("inventory.FulfillmentNLS", localeUsed   );

   String manifestFound = (String) request.getParameter(InventoryConstants.MANIFEST_FOUND);
   String paymentFailed = (String) request.getParameter(InventoryConstants.DEPOSIT_FAIL);

   Integer store_id = cmdContext.getStoreId();
   String storeId = store_id.toString(); 
   releaseShipList.setStoreentId(storeId); 
   String ffmcenterId = UIUtil.getFulfillmentCenterId(request);
   if (ffmcenterId == null){
   		ffmcenterId = "";
   }else{
   		ffmcenterId = ffmcenterId.trim();
   }
   if (ffmcenterId != "") {
   	releaseShipList.setFfmcenterId(ffmcenterId); 
	
   	DataBeanManager.activate(releaseShipList, request);
   	shipIDs = releaseShipList.getReleaseShipList();
	
   	if (shipIDs != null)
   	{
     		numberOfShipIDs = shipIDs.length;
   	}
   }
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
<HTML>
<HEAD>
<%= fHeader%>
<LINK rel=stylesheet href="<%= UIUtil.getCSSFile(localeUsed) %>" type="text/css">
<TITLE></TITLE>

<SCRIPT LANGUAGE="JavaScript">
<!---- hide script from old browsers

    function printMsg()
    {
        var hasPopUp = top.getData("hasPopUp");
        if(hasPopUp== null || hasPopUp != "Yes"){
        hasPopUp = "No";				
        }
        var found = '<%=UIUtil.toJavaScript((String)FulfillmentNLS.get("confirmError"))%>';
        var did = '<%=UIUtil.toJavaScript((String)FulfillmentNLS.get("confirmInfo"))%>';
        var paymentFail = '<%=UIUtil.toJavaScript((String)FulfillmentNLS.get("confirmErrorPaymentDeposit"))%>';
		
      if(hasPopUp == "No"){
<%
      out.println("var manifestFound = \"" + UIUtil.toJavaScript(manifestFound) + "\";");

      if (manifestFound != null && manifestFound.equals("No")) {
        out.println("alertDialog(found);");
%> 
        top.saveData("Yes","hasPopUp");
<%     } else if (paymentFailed != null && paymentFailed.equals("true")){ 
        out.println("alertDialog(paymentFail);"); 
%>
        top.saveData("Yes","hasPopUp");
<%     } else if (manifestFound != null && manifestFound.equals("Yes")) {
        out.println("alertDialog(did);");
%>
        top.saveData("Yes","hasPopUp");        
<%     }

%> 
	  }
    }


    function toBeOrNot()
    {
	var FFC = '<%=ffmcenterId%>';

	if ( FFC == "") {
		var mess = '<%=UIUtil.toJavaScript((String)FulfillmentNLS.get("FFCnone"))%>';
		alertDialog(mess);
		top.goBack();
	}
    }

			     
    function viewPackages(){

        var tokens = parent.getSelected().split(",");
	var orderNumber = tokens[0];

        var tokens = parent.getSelected().split(",");
	var releaseNumber = tokens[1];

        var tokens = parent.getSelected().split(",");
	var shipmodeId = tokens[2];	

        var url="/webapp/wcs/tools/servlet/NewDynamicListView?ActionXMLFile=inventory.PackageList&cmd=PackageListView";
        url += "&orderNumber=" + orderNumber + "&releaseNumber=" + releaseNumber + "&shipmodeId=" + shipmodeId;
       
	var titleList = orderNumber + "-" + releaseNumber + " - " + '<%=UIUtil.toJavaScript((String)FulfillmentNLS.get("PackageList"))%>';
        if (top.setContent)
        {
          top.setContent(titleList,
                                 url,
                                 true);

      }else{
        parent.location.replace(url);
      }
    }

    function releaseManifest()
    {
	top.saveData("No","hasPopUp");
	var tokens = parent.getSelected().split(",");
  	var orderNumber = tokens[0];
  	var releaseNumber =  tokens[1];

        var redirectURL = "/webapp/wcs/tools/servlet/NewDynamicListView?ActionXMLFile=inventory.ReleaseConfirmList&amp;cmd=ReleaseConfirmListView";
        var url = "/webapp/wcs/tools/servlet/ReleaseManifest?"
                  + "ordersId=" + orderNumber 
                  + "&ordReleaseNum=" + releaseNumber
                  + "&URL=" + redirectURL;

           if (top.setContent)
          {
            top.showContent(url); 
            top.refreshBCT(); 
          }
          else
          {
            parent.location.replace(url);
          }
    }
 

    function onLoad()
    {
      toBeOrNot();
      printMsg();
      parent.loadFrames()
    }

    function getResultSize () {
	return <%= numberOfShipIDs %>;
    }


// -->
</script>

<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/common/dynamiclist.js"></SCRIPT>

</HEAD>
<BODY ONLOAD="onLoad()" CLASS="content">



<%
          int startIndex = Integer.parseInt(request.getParameter("startindex"));
          int listSize = Integer.parseInt(request.getParameter("listsize"));
          int endIndex = startIndex + listSize;
          int rowselect = 1;
          int totalsize = numberOfShipIDs;
          int totalpage = totalsize/listSize;
	
%>



<%=comm.addControlPanel("inventory.ReleaseConfirmList", totalpage, totalsize, localeUsed )%>

<FORM NAME="ReleaseConfirmList">

<%=comm.startDlistTable((String)FulfillmentNLS.get("ReleaseConfirmList")) %>

<%= comm.startDlistRowHeading() %>

<%= comm.addDlistCheckHeading() %>

<%--//These next few rows get the header name from FulfillmentNLS file --%>

<%= comm.addDlistColumnHeading((String)FulfillmentNLS.get("RSCLOrderNumber"), null, false )%>
<%= comm.addDlistColumnHeading((String)FulfillmentNLS.get("RSCLReleaseNumber"), null, false  )%>
<%= comm.addDlistColumnHeading((String)FulfillmentNLS.get("RSCLShippingAddress"), null, false )%>
<%= comm.addDlistColumnHeading((String)FulfillmentNLS.get("RSCLUpdatedDate"), null, false )%>

<%= comm.endDlistRow() %>


<!-- Need to have a for loop to look for all pick batches -->
<%
    ReleaseShipDataBean shipBean;
  
      String sComma = ", ";
      String sSpace = " ";

    if (endIndex > numberOfShipIDs){
      endIndex = numberOfShipIDs;
     }
    for (int i=startIndex; i<endIndex ; i++){
      shipBean = shipIDs[i];

      String orderNumber = shipBean.getOrdersId();
      if (orderNumber == null){
        orderNumber = "";
      }

      String releaseNumber = shipBean.getOrdReleaseNum();
      if (releaseNumber == null){
        releaseNumber = "";
      }

      String shipId = shipBean.getShipmodeId();
      if (shipId == null){
        shipId = "";
      }

      String city = shipBean.getCity();
      String cCity = "";
      String sCity = "";
      if (city == null){
        city = "";
      } else {
	cCity = city + sComma;
	sCity = city + sSpace;
      }

      String state = shipBean.getState();
      String cState = "";
      String sState = "";
      if (state == null){
        state = "";
      } else {
	cState = state + sComma;
	sState = state + sSpace;
      }

      String country = shipBean.getCountry();
      String cCountry = "";
      String sCountry = "";
      if (country == null){
        country = "";
      } else {
	cCountry = country + sComma;
	sCountry = country + sSpace;
      }
	 
      String address = "";

	if (sLocale.equals("-3")) {
		address = cCity + cState + cCountry;

	} else if (sLocale.equals("-6")) {
		address = cCity + cState + cCountry;

	} else if (sLocale.equals("-5")) {
		address = cCity + cState + cCountry;

	} else if (sLocale.equals("-2")) {
		address = cCity + cState + cCountry;

	} else if (sLocale.equals("-4")) {
		address = cCity + cState + cCountry;

	} else if (sLocale.equals("-7")) {
		address = sCountry + sState + sCity;

	} else if (sLocale.equals("-10")) {
		address = sCountry + sState + sCity;

	} else if (sLocale.equals("-9")) {
		address = sCountry + sState + sCity;

	} else if (sLocale.equals("-8")) {
		address = sCountry + sState + sCity;

	} else {
		address = cCity + cState + cCountry;
	}

      String createdDate = shipBean.getLastUpdate();
      String formattedCreatedDate = null;
      if (createdDate == null){
         formattedCreatedDate = "";
      }else{
         Timestamp tmp_createdDate = Timestamp.valueOf(createdDate);
         formattedCreatedDate = TimestampHelper.getDateFromTimestamp(tmp_createdDate, localeUsed );
	}
%>
<%=  comm.startDlistRow(rowselect) %>

<%= comm.addDlistCheck(orderNumber + "," + releaseNumber + "," + shipId, "none" ) %>

<%= comm.addDlistColumn(orderNumber, "none" ) %>

<%= comm.addDlistColumn( releaseNumber, "none" ) %> 

<%= comm.addDlistColumn( address, "none" ) %> 

<%= comm.addDlistColumn( formattedCreatedDate, "none" ) %> 

<%= comm.endDlistRow() %>
 
 
<%
if(rowselect==1)
   {
     rowselect = 2;
   }else{
     rowselect = 1;
   }
%>

<%
}
%>
<%= comm.endDlistTable() %>

<%
   if ( numberOfShipIDs == 0 ){
%>
<br>
<%= UIUtil.toHTML((String)FulfillmentNLS.get("RSCLNoRows")) %>
<%
   }
%>

</FORM>
<SCRIPT LANGUAGE="JavaScript">
 
  parent.afterLoads();
  parent.setResultssize(getResultSize());

</SCRIPT>

</BODY>
</HTML>
