<!-- ========================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (c) Copyright IBM Corp. 2001, 2005

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 ===========================================================================-->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
<%@page import="java.util.*" %>
<%@page import="com.ibm.commerce.tools.util.*" %>
<%@page import="com.ibm.commerce.tools.xml.*" %>
<%@page import="com.ibm.commerce.command.CommandContext"%>
<%@page import="com.ibm.commerce.server.ECConstants"%>


<%@include file="/tools/reporting/common.jsp" %>
<%@include file="/tools/reporting/ReportStartDateEndDateHelper.jspf" %>

<%
   CommandContext biCommandContext = (CommandContext) request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
   Locale biLocale = biCommandContext.getLocale();
   Hashtable biNLS = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("bi.biNLS", biLocale);
%>
<%!

private String generateSortOrderByOption(String container, Hashtable biNLS)
{
   

   String result =        "<FORM NAME=" + container + ">\n" +
                                        "   <TABLE border=0 bordercolor=red CELLPADDING=0 CELLSPACING=0 width=400>" + 
                               "        <TR>\n" +

                                                 "         <TD ALIGN=left VALIGN=TOP>\n" +                                                                                               
                                                 "                     <TABLE border=0 bordercolor=black CELLPADDING=0 CELLSPACING=0 width=200>" + 
                                              "                      <TR HEIGHT=5>\n" +
                                                 "                        <TD ALIGN=left VALIGN=TOP>\n" +
                                              "            <INPUT TYPE=RADIO NAME=sortBy VALUE=All id=s1>\n" +
                                                        "                     <label for= s1>" +
                                              "               " + biNLS.get("createddate") + "\n </label>" +
                                              "                      </INPUT>\n" +
                                              "            <BR>\n" +
                            "            <BR>\n" +
                                              "            <INPUT TYPE=RADIO NAME=sortBy VALUE=PayA id=s2>\n" +
                                                        "                     <label for= s2>" +
                                              "               " + biNLS.get("orderno") + "\n </label>" +
                                              "                      </INPUT>\n" +
                                              "            <BR>\n" +       
                                                 "            <BR>\n" +       
                                              "         </TD>\n" +
                                              "      </TR>\n" +
                                              "   </TABLE>\n" +
                                              "         </TD>\n" +

                                                 "         <TD>&nbsp;</TD>\n" +

                                        "         <TD ALIGN=left VALIGN=TOP>\n" +
                                                 "                     <TABLE border=0 bordercolor=black CELLPADDING=0 CELLSPACING=0 width=200>" + 
                                              "                      <TR HEIGHT=5>\n" +
                                                 "                        <TD ALIGN=left VALIGN=TOP>\n" +
                                              "            <INPUT TYPE=RADIO  NAME=orderBy VALUE=All id=ord1>\n" +
                                                        "                     <label for= ord1>" +
                                              "               " + biNLS.get("descend") + "\n </label>" +
                                              "                      </INPUT>\n" +
                                              "            <BR>\n" +
                                                 "            <BR>\n" +
                                              "            <INPUT TYPE=RADIO NAME=orderBy VALUE=PayA id=ord2>\n" +
                                                        "                     <label for= ord2>" +
                                              "               " + biNLS.get("ascend") + "\n </label>" +
                                              "                      </INPUT>\n" +
                                              "            <BR>\n" +                                                                    
                                                 "         </TD>\n" +
                                                 "      </TR>\n" +
                                              "   </TABLE>\n" +
                                              "         </TD>\n" +
                                              
                                                 
                                                 "      </TR>\n" +
                                                 "   </TABLE>\n" +
                                              " </FORM>\n";
   return result;
}

%>


<HTML>
<HEAD>
<%@include file="/tools/reporting/ReportFrameworkHelper.jsp" %>
<link rel=stylesheet href="<%= UIUtil.getCSSFile(biLocale) %>" type="text/css">
   <%=fHeader%>

   <title><LABEL><%=biNLS.get("shoppingCartCreated")%></LABEL></title>

   <script src="/wcs/javascript/tools/common/Util.js"></script>
   <script src="/wcs/javascript/tools/common/DateUtil.js"></script>
   <script src="/wcs/javascript/tools/common/SwapList.js"></script>
   <script src="/wcs/javascript/tools/reporting/ReportHelpers.js"></script>
<SCRIPT>

   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   // Validate is done by the HTML radio button
   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   function validateSortOrderByOption(container)
   {
      return true;
   }

   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   // initialize function for the status dates
   ///////////////////////////////////////////////////////////////////////////////////////////////////////
     
   function onLoadSortOrderByOption(container)
   {

          
         var myContainer = parent.get(container, null);
           
         // If this is the first time set it to the default.                  
      if (myContainer == null) {
                     myContainer = new Object();
       
                     myContainer.StatusChosen = 1;
                     
                     with (document.forms[container]) {
                            sortBy[0].checked = true;
                            orderBy[0].checked = true;
                     }
                     parent.put(container, myContainer);
                     return;             
      } else {
                    // If it is not the first time set it to the last selected.
                     if(myContainer.StatusChosen == 4){
                            document.forms[container].sortBy[1].checked = true;
                            document.forms[container].orderBy[1].checked = true;
                     }               
                      else if(myContainer.StatusChosen == 3){
                            document.forms[container].sortBy[1].checked = true;
                            document.forms[container].orderBy[0].checked = true;
                     } 
                      else if(myContainer.StatusChosen == 2){
                            document.forms[container].sortBy[0].checked = true;
                            document.forms[container].orderBy[1].checked = true;
                     } 
                      else {
                            document.forms[container].sortBy[0].checked = true;
                            document.forms[container].orderBy[0].checked = true;
                     }
                     parent.put(container, myContainer);
                    return;
      }
   }
   
   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   // save function for the Staus selected
   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   function saveSortOrderByOption(container)
   {

          
      myContainer = parent.get(container,null);
      if (myContainer == null) return;

      with (document.forms[container]) {
                
                   if (sortBy[1].checked){
                             if(orderBy[1].checked)
                                   myContainer.StatusChosen = 4;
                             else
                                   myContainer.StatusChosen = 3;
                     }
                      else{
                            if(orderBy[1].checked)
                                   myContainer.StatusChosen = 2;
                             else
                                   myContainer.StatusChosen = 1;
                     }
      }
      parent.put(container, myContainer);
   }

   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   // Return the Status Chosen
   ///////////////////////////////////////////////////////////////////////////////////////////////////////  
  
   function returnSortByOptionCreatedDate(container) {
      return document.forms[container].sortBy[0].checked;
   }
   function returnSortByOptionOrderNumber(container) {
      return document.forms[container].sortBy[1].checked;
   }
      

 ///////////////////////////////////////////////////////////////////////////////////////////////////////
   // Return the Orderby Status Chosen
   ///////////////////////////////////////////////////////////////////////////////////////////////////////  
    function returnOrderbyDesc(container) {
      return document.forms[container].orderBy[0].checked;
   }

    function returnOrderbyAsc(container) {
      return document.forms[container].orderBy[1].checked;
   }
   
</SCRIPT>
   <script>

      ///////////////////////////////////////////////////////////////////////////////////////////////////////
      // Call the initialize routines for the various elements of the page
      ///////////////////////////////////////////////////////////////////////////////////////////////////////
      function initializeValues()
      {
         onLoadStartDateEndDate("enquiryPeriod");
		 onLoadSortOrderByOption("myHelperShoppingCartByCreated");
		 ResetValues();
         if (parent.setContentFrameLoaded) parent.setContentFrameLoaded(true);
      }


      ///////////////////////////////////////////////////////////////////////////////////////////////////////
      // Call the save routines for the various elements of the page
      ///////////////////////////////////////////////////////////////////////////////////////////////////////
      function savePanelData()
      {
         ////////////////////////////////////////////////////////////////////////////////////////////////////
         // Specify the report framework particulars
         ////////////////////////////////////////////////////////////////////////////////////////////////////
         setReportFrameworkOutputView("DialogView");
         setReportFrameworkParameter("XMLFile","bi.biShoppingCartCreatedReportOutputDialog");
         setReportFrameworkReportXML("bi.biShoppingCartCreatedReport");

		 if(document.all.time.selectedIndex != 0)
		{
		////////////////////////////////////////////////////////////////////////////////////////////////////
         // Specify the report framework particulars
         ////////////////////////////////////////////////////////////////////////////////////////////////////
         if(returnSortByOptionCreatedDate("myHelperShoppingCartByCreated")){

			// ASC & DESC CHECKING QUERY
				if(returnOrderbyDesc("myHelperShoppingCartByCreated")){
					setReportFrameworkReportName("biShoppingCartCreatedReport"+ document.all.time[document.all.time.selectedIndex].value+"CreatedDate");
				}
				else{
					setReportFrameworkReportName("biShoppingCartCreatedReport"+ document.all.time[document.all.time.selectedIndex].value+"CreatedDateAscend");
				}
		 }
		  else{
				if(returnOrderbyDesc("myHelperShoppingCartByCreated")){
					setReportFrameworkReportName("biShoppingCartCreatedReport"+ document.all.time[document.all.time.selectedIndex].value+"OrderNumber");
				}
				else{
					setReportFrameworkReportName("biShoppingCartCreatedReport"+ document.all.time[document.all.time.selectedIndex].value+"OrderNumberAscend");
				}
       	  }

		 ////////////////////////////////////////////////////////////////////////////////////////////////////
         // Specify the report specific parameters and save
         ////////////////////////////////////////////////////////////////////////////////////////////////////
         setReportFrameworkParameter("Time", document.all.time[document.all.time.selectedIndex].text);
 		 setReportFrameworkParameter("ReportType", "Predefined");
		}
		else
		{
		 saveStartDateEndDate("enquiryPeriod");
         ////////////////////////////////////////////////////////////////////////////////////////////////////
         // Specify the report framework particulars
         ////////////////////////////////////////////////////////////////////////////////////////////////////
         if(returnSortByOptionCreatedDate("myHelperShoppingCartByCreated")){

			// ASC & DESC CHECKING QUERY
				if(returnOrderbyDesc("myHelperShoppingCartByCreated")){
					setReportFrameworkReportName("biShoppingCartCreatedReportCreatedDate");
				}
				else{
					setReportFrameworkReportName("biShoppingCartCreatedReportCreatedDateAscend");
				}
         }
		 else{
				if(returnOrderbyDesc("myHelperShoppingCartByCreated")){
					setReportFrameworkReportName("biShoppingCartCreatedReportOrderNumber");
				}
				else{
					setReportFrameworkReportName("biShoppingCartCreatedReportOrderNumberAscend");
				}
       	  }

         ////////////////////////////////////////////////////////////////////////////////////////////////////
         // Specify the report specific parameters and save
         ////////////////////////////////////////////////////////////////////////////////////////////////////
 		 setEndDate();
		 setReportFrameworkParameter("StartDate", returnStartDateAsTimestamp("enquiryPeriod"));
         setReportFrameworkParameter("EndDate", returnEndDateAsTimestamp("enquiryPeriod"));
		 setReportFrameworkParameter("ReportType", "UserInput");
		}
         saveReportFramework();
         top.saveModel(parent.model);
         return true;
      }

      ///////////////////////////////////////////////////////////////////////////////////////////////////////
      // Call the validate routines for the various elements of the page
      ///////////////////////////////////////////////////////////////////////////////////////////////////////
       function validatePanelData()
      {

	  if(document.all.time.selectedIndex != 0 &&
		  (document.enquiryPeriod.StartDateEndDateHelperYearSD.value != "" ||
		   document.enquiryPeriod.StartDateEndDateHelperMonthSD.value != "" || 		 		   document.enquiryPeriod.StartDateEndDateHelperDaySD.value != "" ||
		   document.enquiryPeriod.StartDateEndDateHelperYearED.value != "" ||
		   document.enquiryPeriod.StartDateEndDateHelperMonthED.value != "" ||  				  document.enquiryPeriod.StartDateEndDateHelperDayED.value != ""
	  ))
		{
			parent.alertDialog("<%=UIUtil.toJavaScript(biNLS.get("SelectAnyOneOption"))%>");
			ResetValues();
			return false;

		  }
		 if(document.all.time.selectedIndex == 0)
		 {
			 if (validateStartDateEndDate("enquiryPeriod") == false) return false;
		 }
         return true;
      }


	function ResetValues()
	{
		document.enquiryPeriod.StartDateEndDateHelperYearSD.value = "";
		document.enquiryPeriod.StartDateEndDateHelperMonthSD.value = "";
		document.enquiryPeriod.StartDateEndDateHelperDaySD.value = "";
		document.enquiryPeriod.StartDateEndDateHelperYearED.value = "";
		document.enquiryPeriod.StartDateEndDateHelperMonthED.value = "";
		document.enquiryPeriod.StartDateEndDateHelperDayED.value = "";
		document.all.time.selectedIndex = 0;
	}
	function setEndDate()
	{
    	  if((document.enquiryPeriod.StartDateEndDateHelperYearSD.value != "" &&
			document.enquiryPeriod.StartDateEndDateHelperMonthSD.value != "" && document.enquiryPeriod.StartDateEndDateHelperDaySD.value != "" ) &&
			  (document.enquiryPeriod.StartDateEndDateHelperYearED.value == "" &&
			document.enquiryPeriod.StartDateEndDateHelperMonthED.value == "" && document.enquiryPeriod.StartDateEndDateHelperDayED.value == "" ))
		{

				parent.alertDialog("<%=UIUtil.toJavaScript(biNLS.get("EndDateIsCurrentDate"))%>");
				document.enquiryPeriod.StartDateEndDateHelperYearED.value = getCurrentYear();
				document.enquiryPeriod.StartDateEndDateHelperMonthED.value = getCurrentMonth();
				document.enquiryPeriod.StartDateEndDateHelperDayED.value = getCurrentDay();
		}

	}

</script>
</head>

<body onload="initializeValues()" class="content">

   <h1><LABEL><%=biNLS.get("shoppingCartCreated") %></LABEL></h1>
   <LABEL><%=biNLS.get("shoppingCartCreatedDescription") %></LABEL>
   <p></p>
   <LABEL><%=biNLS.get("shoppingCartCreatedReportSelection")%></LABEL>
   <p>
<table border="0" bordercolor="black" CELLPADDING="0" CELLSPACING="0" width="400">
<tr>
	<td>
	<div id="pageBody" style="display: block; margin-left: 0">
      <form>
	  <label for="time"><%=biNLS.get("labelTimePeriod")%></label><br>
      	<select id="time">
				<option value="pleaseSelect" selected><LABEL><%=biNLS.get("pleaseSelect")%></LABEL></option>
				<option value="Yesterday"><LABEL><%=biNLS.get("yesterdayTitle")%></LABEL></option>
				<option value="Weekly"><LABEL><%=biNLS.get("thisWeekTitle")%></LABEL></option>
				<option value="Monthly"><LABEL><%=biNLS.get("thisMonthTitle")%></LABEL></option>
				<option value="Quarterly"><LABEL><%=biNLS.get("thisQuarterTitle")%></LABEL></option>
				<option value="Yearly"><LABEL><%=biNLS.get("thisYearTitle")%></LABEL></option>
      	</select>
      </form>
   </div>

  <div id=pageBody style="display: block; margin-left: 50">
  <B><LABEL><%=biNLS.get("or")%></LABEL></B>
  </div>
  <div id=pageBody style="display: block; margin-left: 0">
      <%=generateStartDateEndDate("enquiryPeriod", biNLS, null)%>
   </div>
	</td>
</tr>
</table>

<br>
<table border="0" bordercolor="black" CELLPADDING="0" CELLSPACING="0">
	<tr>
		<td>
		<table border="0" bordercolor="black" CELLPADDING="0" CELLSPACING="0" width="210">
		<tr>
			<td align="left">
				<B><LABEL><%=biNLS.get("sortby")%></LABEL></B>
			</td>
		</tr>
		</table>
		</td>
		<td>
		<table border="0" bordercolor="black" CELLPADDING="0" CELLSPACING="0" width="210">
		<tr>
			<td align="left">
			  <B><LABEL><%=biNLS.get("orderby")%></LABEL></B>
			</td>
		</tr>
		</table>
		</td>
		</tr>
</table>
	<div id=pageBody style="display: block; margin-left:0">
		<%=generateSortOrderByOption("myHelperShoppingCartByCreated", biNLS)%>
	</div>

</body>
</html>
