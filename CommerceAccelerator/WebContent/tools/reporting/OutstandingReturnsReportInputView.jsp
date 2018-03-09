<!-- ========================================================================
  Licensed Materials - Property of IBM
   
  WebSphere Commerce
   
  (c) Copyright IBM Corp. 2001, 2002
   
  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 -----------------------------------------------------------------------------
 OutstandingReturnsReportInputView.jsp
 ===========================================================================-->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
<%@page import="java.util.*" %>
<%@page import="com.ibm.commerce.tools.util.*" %>
<%@page import="com.ibm.commerce.tools.xml.*" %>

<%@include file="common.jsp" %>
<%@include file="ReportStartDateEndDateHelper.jspf" %>
<%@include file="ReportProductHelper.jspf" %>
<%@include file="ReportFulfillmentCenterHelper.jspf" %>
<%@include file="ReportFrameworkHelper.jsp" %>

<HTML>
<HEAD>
   <%=fHeader%>

   <TITLE><%=reportsRB.get("OutstandingReturnsReportInputViewTitle")%></TITLE>

   <SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
   <SCRIPT SRC="/wcs/javascript/tools/common/DateUtil.js"></SCRIPT>
   <SCRIPT SRC="/wcs/javascript/tools/common/SwapList.js"></SCRIPT>
   <SCRIPT SRC="/wcs/javascript/tools/reporting/ReportHelpers.js"></SCRIPT>

   <SCRIPT>

      ///////////////////////////////////////////////////////////////////////////////////////////////////////
      // Call the initialize routines for the various elements of the page
      ///////////////////////////////////////////////////////////////////////////////////////////////////////
      function initializeValues() 
      {
         onLoadStartDateEndDate("enquiryPeriod");
         onLoadSelectProducts("myProducts");
         onLoadFulfillmentCenter("myFFC");
         if (parent.setContentFrameLoaded) parent.setContentFrameLoaded(true);
      }


      ///////////////////////////////////////////////////////////////////////////////////////////////////////
      // Call the save routines for the various elements of the page
      ///////////////////////////////////////////////////////////////////////////////////////////////////////
      function savePanelData() 
      {
         saveStartDateEndDate("enquiryPeriod");
         saveSelectProducts("myProducts");
         saveFulfillmentCenter("myFFC");

         ////////////////////////////////////////////////////////////////////////////////////////////////////
         // Specify the report framework particulars
         ////////////////////////////////////////////////////////////////////////////////////////////////////
         setReportFrameworkOutputView("DialogView");
         setReportFrameworkParameter("XMLFile","reporting.OutstandingReturnsReportOutputDialog");
         setReportFrameworkReportXML("reporting.OutstandingReturnsReport");
         if (allProductsSelectedTF("myProducts")) setReportFrameworkReportName("OutstandingReturnsReportAllProducts");
         else                                     setReportFrameworkReportName("OutstandingReturnsReport");

         ////////////////////////////////////////////////////////////////////////////////////////////////////
         // Specify the report specific parameters and save
         ////////////////////////////////////////////////////////////////////////////////////////////////////
         if (allProductsSelectedTF("myProducts")) setReportFrameworkParameter("ItemsSelected","<%=reportsRB.get("OutstandingReturnsReportAllItemsSelectedTitle")%>");
         else                                     setReportFrameworkParameter("ItemsSelected",returnArrayAsSQLList(returnSelectedProductSKUs("myProducts"), false));

         setReportFrameworkParameter("StartDate", returnStartDateAsTimestamp("enquiryPeriod"));
         setReportFrameworkParameter("EndDate", returnEndDateAsTimestamp("enquiryPeriod"));
         setReportFrameworkParameter("ItemList", returnArrayAsSQLList(returnSelectedProductIDs("myProducts"), false));
         setReportFrameworkParameter("FulfillmentCenterList", returnArrayAsSQLList(returnSelectedFulfillmentCenterIDs("myFFC"), false));
         setReportFrameworkParameter("FulfillmentCenterNames", returnArrayAsSQLList(returnSelectedFulfillmentCenterNames("myFFC"), false));
         saveReportFramework();
         top.saveModel(parent.model);
         return true;
      }

      ///////////////////////////////////////////////////////////////////////////////////////////////////////
      // Call the validate routines for the various elements of the page
      ///////////////////////////////////////////////////////////////////////////////////////////////////////
      function validatePanelData()
      {
         if (validateStartDateEndDate("enquiryPeriod") == false) return false;
         if (validateSelectProducts("myProducts") == false) return false;
         if (validateFulfillmentCenter("myFFC") == false) return false;
         return true;
      }

	  function visibleList(s)
	  {
	  		setSelectProductVisible("myProducts", s);
			setSelectFulfillmentCenterVisible("myFFC", s);
	  }

</SCRIPT>
</HEAD>

<BODY ONLOAD="initializeValues()" CLASS=content>

   <H1><%=reportsRB.get("OutstandingReturnsReportInputViewTitle") %></H1>
   <%=reportsRB.get("OutstandingReturnsReportDescription")%>
   <p>

   <DIV ID=pageBody STYLE="display: block; margin-left: 20">
      <%=generateStartDateEndDate("enquiryPeriod", reportsRB, null)%>
      <%=generateSelectProducts("myProducts", reportsRB, "OutstandingReturnsReportSelectProductsTitle")%>
      <%=generateFulfillmentCenter("myFFC", reportsRB, "AvailableFulfillmentCenterLabel", "SelectedFulfillmentCenterLabel")%>
   </DIV>

</BODY>
</HTML>
