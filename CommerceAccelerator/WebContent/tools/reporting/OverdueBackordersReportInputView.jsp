<!-- ========================================================================
  Licensed Materials - Property of IBM
   
  WebSphere Commerce
   
  (c) Copyright IBM Corp. 2001, 2002
   
  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 -----------------------------------------------------------------------------
 OverdueBackordersReportInputView.jsp
 ===========================================================================-->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
<%@page import="java.util.*" %>
<%@page import="com.ibm.commerce.tools.util.*" %>
<%@page import="com.ibm.commerce.tools.xml.*" %>

<%@include file="common.jsp" %>
<%@include file="ReportDaysWaitedHelper.jspf" %>
<%@include file="ReportProductHelper.jspf" %>
<%@include file="ReportFrameworkHelper.jsp" %>

<HTML>
<HEAD>
   <%=fHeader%>

   <TITLE><%=reportsRB.get("OverdueBackordersReportInputViewTitle")%></TITLE>

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
         onLoadDaysWaited("DaysWaited");
         onLoadSelectProducts("myProducts");
         if (parent.setContentFrameLoaded) parent.setContentFrameLoaded(true);
      }


      ///////////////////////////////////////////////////////////////////////////////////////////////////////
      // Call the save routines for the various elements of the page
      ///////////////////////////////////////////////////////////////////////////////////////////////////////
      function savePanelData() 
      {
         saveDaysWaited("DaysWaited");
         saveSelectProducts("myProducts");

         ////////////////////////////////////////////////////////////////////////////////////////////////////
         // Specify the report framework particulars
         ////////////////////////////////////////////////////////////////////////////////////////////////////
         setReportFrameworkOutputView("DialogView");
         setReportFrameworkParameter("XMLFile","reporting.OverdueBackordersReportOutputDialog");
         setReportFrameworkReportXML("reporting.OverdueBackordersReport");
         if (allProductsSelectedTF("myProducts")) setReportFrameworkReportName("OverdueBackordersReportAllProducts");
         else                                     setReportFrameworkReportName("OverdueBackordersReport");

         ////////////////////////////////////////////////////////////////////////////////////////////////////
         // Specify the report specific parameters and save
         ////////////////////////////////////////////////////////////////////////////////////////////////////
         if (allProductsSelectedTF("myProducts")) setReportFrameworkParameter("ItemsSelected","<%=reportsRB.get("OverdueBackordersReportAllItemsSelectedTitle")%>");
         else                                     setReportFrameworkParameter("ItemsSelected",returnArrayAsSQLList(returnSelectedProductSKUs("myProducts"), false));

         ////////////////////////////////////////////////////////////////////////////////////////////////////
         // Specify the report specific parameters and save
         ////////////////////////////////////////////////////////////////////////////////////////////////////
         setReportFrameworkParameter("NumberOfDaysOverdue", returnDaysWaited("DaysWaited"));
         setReportFrameworkParameter("DaysWaited", returnDaysWaited("DaysWaited"));
         setReportFrameworkParameter("ItemList", returnArrayAsSQLList(returnSelectedProductIDs("myProducts"), false));
         saveReportFramework();
         top.saveModel(parent.model);
         return true;
      }

      ///////////////////////////////////////////////////////////////////////////////////////////////////////
      // Call the validate routines for the various elements of the page
      ///////////////////////////////////////////////////////////////////////////////////////////////////////
      function validatePanelData()
      {
         if (validateDaysWaited("DaysWaited") == false) return false;
         if (validateSelectProducts("myProducts") == false) return false;
         return true;
      }

	  function visibleList(s)
	  {
	  		setSelectProductVisible("myProducts", s);
	  }

</SCRIPT>
</HEAD>

<BODY ONLOAD="initializeValues()" CLASS=content>

   <H1><%=reportsRB.get("OverdueBackordersReportInputViewTitle") %></H1>
   <%=reportsRB.get("OverdueBackordersReportDescription")%>
   <p>

   <DIV ID=pageBody STYLE="display: block; margin-left: 20">
      <%=generateDaysWaited("DaysWaited", reportsRB, "OverdueBackordersReportSelectDaysTitle")%>
      <%=generateSelectProducts("myProducts", reportsRB, "OverdueBackordersReportSelectProductsTitle")%>
   </DIV>

</BODY>
</HTML>
