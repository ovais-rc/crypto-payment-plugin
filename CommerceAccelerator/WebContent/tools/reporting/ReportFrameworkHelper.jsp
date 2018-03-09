<!-- ========================================================================
  Licensed Materials - Property of IBM
   
  WebSphere Commerce
   
  (c) Copyright IBM Corp. 2001, 2002
   
  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
   -------------------------------------------------------------------
   
 ===========================================================================-->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">

<%@page import="java.util.*" %>
<%@page import="com.ibm.commerce.command.CommandContext"%>
<%@page import="com.ibm.commerce.server.ECConstants"%>

<%
   CommandContext reportFrameworkHelperCC = (CommandContext) request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
%>
<script type="text/javascript" src="/wcs/javascript/tools/common/Util.js"></script>
<SCRIPT>

   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   // retrieves the reportInputData objects and reportResultPage object and initializes them if necessary
   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   var reportResultPage = parent.get("reportResultPage",null);
   var reportInputData = parent.get("reportInputData",null);
   if ( reportResultPage == null) reportResultPage = new Object();
   if ( reportInputData  == null) {
      reportInputData  = new Object();
      reportInputData.LanguageID  = "<%=reportFrameworkHelperCC.getLanguageId().toString()%>";
      reportInputData.StoreEnt_ID = "<%=reportFrameworkHelperCC.getStoreId().toString()%>";
   }

   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   // save the reporting framework reportResultPage and reportInputData
   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   function saveReportFramework() 
   {
      parent.put("reportResultPage",reportResultPage);
      parent.put("reportInputData",reportInputData);
   }

   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   // set the reporting framework output view
   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   function setReportFrameworkOutputView(viewname) 
   {
      reportResultPage.view = viewname;
   }

   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   // set the reporting framework language ID
   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   function setReportFrameworkLanguageID(languageID) 
   {
      reportInputData.LanguageID = languageID;
   }

   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   // set the reporting framework Store entity ID
   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   function setReportFrameworkStoreentID(storeentID) 
   {
      reportInputData.StoreEnt_ID = storeentID;
   }

   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   // set the reporting framework source XML file
   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   function setReportFrameworkReportXML(XML) 
   {
      reportInputData.reportXML = XML;
   }

   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   // set the reporting framework report name (looked up in the ReportXML)
   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   function setReportFrameworkReportName(name) 
   {
      reportInputData.reportName = name;
   }

   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   // add a name,value pair to the report input data
   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   function setReportFrameworkParameter(name,value) 
   {
      reportInputData[name] = value;
   }
////98202
   function trapKey(evt) {
	var e = new XBEvent(evt);

	// Traps the Enter key.
	if (e.keyCode == 13) {
		//document.Logon.submit();
		parent.finish();
	}
}
   
</SCRIPT>

