<!-- ========================================================================
  Licensed Materials - Property of IBM
   
  WebSphere Commerce
   
  (c) Copyright IBM Corp. 2001, 2002
   
  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 -----------------------------------------------------------------------------
 InventoryAdjustmentsReportInputView.jsp
 ===========================================================================-->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
<%@page import="java.util.*" %>
<%@page import="com.ibm.commerce.tools.util.*" %>
<%@page import="com.ibm.commerce.tools.xml.*" %>

<%@include file="common.jsp" %>
<%@include file="ReportStartDateEndDateHelper.jspf" %>
<%@include file="ReportProductHelper.jspf" %>
<%@include file="ReportFulfillmentCenterHelper.jspf" %>
<%@include file="ReportInventoryAdjustmentCodeHelper.jspf" %>
<%@include file="ReportFrameworkHelper.jsp" %>

<HTML>
<HEAD>
   <%=fHeader%>

   <TITLE><%=reportsRB.get("InventoryAdjustmentsReportInputView1Title")%></TITLE>

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
         onLoadInventoryAdjustmentCode("myInventoryAdjustmentCode");
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
         saveInventoryAdjustmentCode("myInventoryAdjustmentCode");

         ////////////////////////////////////////////////////////////////////////////////////////////////////
         // Specify the report framework particulars
         ////////////////////////////////////////////////////////////////////////////////////////////////////
         setReportFrameworkOutputView("DialogView");
         setReportFrameworkParameter("XMLFile","reporting.InventoryAdjustmentsReportOutputDialog");
         setReportFrameworkReportXML("reporting.InventoryAdjustmentsReport");
         if (allProductsSelectedTF("myProducts")) setReportFrameworkReportName("InventoryAdjustmentsReportAllProducts");
         else                                     setReportFrameworkReportName("InventoryAdjustmentsReport");

         ////////////////////////////////////////////////////////////////////////////////////////////////////
         // Specify the report specific parameters and save
         ////////////////////////////////////////////////////////////////////////////////////////////////////
         if (allProductsSelectedTF("myProducts")) setReportFrameworkParameter("ItemsSelected","<%=reportsRB.get("InventoryAdjustmentsReportAllItemsSelectedTitle")%>");
         else                                     setReportFrameworkParameter("ItemsSelected",returnArrayAsSQLList(returnSelectedProductSKUs("myProducts"), false));

         setReportFrameworkParameter("StartDate", returnStartDateAsTimestamp("enquiryPeriod"));
         setReportFrameworkParameter("EndDate", returnEndDateAsTimestamp("enquiryPeriod"));
         setReportFrameworkParameter("ItemList", returnArrayAsSQLList(returnSelectedProductIDs("myProducts"), false));
         setReportFrameworkParameter("FulfillmentCenterList", returnArrayAsSQLList(returnSelectedFulfillmentCenterIDs("myFFC"), false));
         setReportFrameworkParameter("FulfillmentCenterNames", returnArrayAsSQLList(returnSelectedFulfillmentCenterNames("myFFC"), false));
         setReportFrameworkParameter("InventoryAdjustmentCodeList", returnArrayAsSQLList(returnSelectedInventoryAdjustmentCodeIDs("myInventoryAdjustmentCode"), false));
         setReportFrameworkParameter("InventoryAdjustmentCodeNames", returnArrayAsSQLList(returnSelectedInventoryAdjustmentCodeNames("myInventoryAdjustmentCode"), false));
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
         if (validateInventoryAdjustmentCode("myInventoryAdjustmentCode") == false) return false;
         return true;
      }

	  function visibleList(s)
	  {
	  		setSelectProductVisible("myProducts", s);
			setSelectFulfillmentCenterVisible("myFFC", s);
			setSelectAdjustmentCodeVisible("myInventoryAdjustmentCode", s);
	  }

</SCRIPT>
</HEAD>

<BODY ONLOAD="initializeValues()" CLASS=content>

   <H1><%=reportsRB.get("InventoryAdjustmentsReportInputViewTitle") %></H1>
   <%=reportsRB.get("InventoryAdjustmentsReportDescription")%>
   <p>

   <DIV ID=pageBody STYLE="display: block; margin-left: 20">
      <%=generateStartDateEndDate("enquiryPeriod", reportsRB, null)%>
      <%=generateSelectProducts("myProducts", reportsRB, "InventoryAdjustmentsReportSelectProductsTitle")%>
      <%=generateFulfillmentCenter("myFFC", reportsRB, "AvailableFulfillmentCenterLabel", "SelectedFulfillmentCenterLabel")%>
      <%=generateInventoryAdjustmentCode("myInventoryAdjustmentCode", reportsRB, "AvailableInventoryAdjustmentCodeLabel", "SelectedInventoryAdjustmentCodeLabel")%>

   </DIV>

</BODY>
</HTML>
