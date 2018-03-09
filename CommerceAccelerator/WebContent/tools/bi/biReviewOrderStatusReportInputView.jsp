<%
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* 5697-D24
//*
//* (c) Copyright IBM Corp. 2000, 2002
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
//*
 %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
<%@page import="java.util.*" %>
<%@page import="com.ibm.commerce.tools.util.*" %>
<%@page import="com.ibm.commerce.tools.xml.*" %>
<%@page import="com.ibm.commerce.command.CommandContext"%>
<%@page import="com.ibm.commerce.server.ECConstants"%>


<%@include file="/tools/reporting/common.jsp" %>
<%@include file="/tools/reporting/ReportStartDateEndDateHelper.jspf" %>
<%@include file="/tools/reporting/ReportFrameworkHelper.jsp" %>

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
                                              "            <INPUT TYPE=RADIO NAME=sortBy VALUE=All>\n" +
                                                 "                     <label for= s1>" +
                                              "               " + biNLS.get("customerId") + "\n </label>" +
                                              "                      </INPUT>\n" +
                                              "            <BR>\n" +
                            "            <BR>\n" +
                                              "            <INPUT TYPE=RADIO NAME=sortBy VALUE=PayA>\n" +
                                                 "                     <label for= s2>" +
                                              "               " + biNLS.get("orderPlaced") + "\n </label>" +
                                              "                      </INPUT>\n" +
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
                                              "            <INPUT TYPE=RADIO  NAME=orderBy VALUE=All>\n" +
                                                 "                     <label for= ord1>" +
                                              "               " + biNLS.get("descend") + "\n </label>" +
                                              "                      </INPUT>\n" +
                                              "            <BR>\n" +
                                                 "            <BR>\n" +
                                              "            <INPUT TYPE=RADIO NAME=orderBy VALUE=PayA>\n" +
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
   <link rel=stylesheet href="<%= UIUtil.getCSSFile(biLocale) %>" type="text/css">
   <%=fHeader%>

    <title><LABEL><%=biNLS.get("biReviewOrderStatusReportWindowTitle")%></LABEL></title>

   <SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
   <SCRIPT SRC="/wcs/javascript/tools/common/DateUtil.js"></SCRIPT>
   <SCRIPT SRC="/wcs/javascript/tools/common/SwapList.js"></SCRIPT>
   <SCRIPT SRC="/wcs/javascript/tools/reporting/ReportHelpers.js"></SCRIPT>
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
  
   function returnSortByOptionCustomerId(container) {
      return document.forms[container].sortBy[0].checked;
   }
   function returnSortByOptionOrderPlaced(container) {
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
   <SCRIPT>

      ///////////////////////////////////////////////////////////////////////////////////////////////////////
      // Call the initialize routines for the various elements of the page
      ///////////////////////////////////////////////////////////////////////////////////////////////////////
      function initializeValues()
      {
         onLoadStartDateEndDate("enquiryPeriod");
		 onLoadSortOrderByOption("myHelperReviewOrders");
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

		 saveSortOrderByOption("myHelperReviewOrders");

         setReportFrameworkOutputView("DialogView");
		 setReportFrameworkParameter("XMLFile","bi.biReviewOrderStatusReportOutputDialog");
         setReportFrameworkReportXML("bi.biReviewOrderStatusReport");
		if(document.all.time.selectedIndex != 0)
		{
		////////////////////////////////////////////////////////////////////////////////////////////////////
         // Specify the report framework particulars
         ////////////////////////////////////////////////////////////////////////////////////////////////////
         if(returnSortByOptionCustomerId("myHelperReviewOrders")){

			// ASC & DESC CHECKING QUERY
				if(returnOrderbyDesc("myHelperReviewOrders")){
					setReportFrameworkReportName("biReviewOrderStatusReport"+ document.all.time[document.all.time.selectedIndex].value+"CustId");
				}
				else{
					setReportFrameworkReportName("biReviewOrderStatusReport"+ document.all.time[document.all.time.selectedIndex].value+"CustIdAscend");
				}
         }
		 else{
				if(returnOrderbyDesc("myHelperReviewOrders")){
					setReportFrameworkReportName("biReviewOrderStatusReport"+ document.all.time[document.all.time.selectedIndex].value+"OrderPlaced");
				}
				else{
					setReportFrameworkReportName("biReviewOrderStatusReport"+ document.all.time[document.all.time.selectedIndex].value+"OrderPlacedAscend");
				}
       	 }

         ////////////////////////////////////////////////////////////////////////////////////////////////////
         // Specify the report specific parameters and save
         ////////////////////////////////////////////////////////////////////////////////////////////////////
         setReportFrameworkParameter("Time", document.all.time[document.all.time.selectedIndex].text);
		 setReportFrameworkParameter("order_status", document.all.order_status[document.all.order_status.selectedIndex].value);
		 setReportFrameworkParameter("order_id", document.OrderId.EnterOrderId.value);
 		 setReportFrameworkParameter("ReportType", "Predefined");
		}
		else
		{
		 saveStartDateEndDate("enquiryPeriod");
         ////////////////////////////////////////////////////////////////////////////////////////////////////
         // Specify the report framework particulars
         ////////////////////////////////////////////////////////////////////////////////////////////////////
         if(returnSortByOptionCustomerId("myHelperReviewOrders")){

			// ASC & DESC CHECKING QUERY
				if(returnOrderbyDesc("myHelperReviewOrders")){
					setReportFrameworkReportName("biReviewOrderStatusReportCustId");
				}
				else{
					setReportFrameworkReportName("biReviewOrderStatusReportCustIdAscend");
				}
         }
		 else{
				if(returnOrderbyDesc("myHelperReviewOrders")){
					setReportFrameworkReportName("biReviewOrderStatusReportOrderPlaced");
				}
				else{
					setReportFrameworkReportName("biReviewOrderStatusReportOrderPlacedAscend");
				}
       	 }

         ////////////////////////////////////////////////////////////////////////////////////////////////////
         // Specify the report specific parameters and save
         ////////////////////////////////////////////////////////////////////////////////////////////////////
 		 setEndDate();
		 setReportFrameworkParameter("StartDate", returnStartDateAsTimestamp("enquiryPeriod"));
         setReportFrameworkParameter("EndDate", returnEndDateAsTimestamp("enquiryPeriod"));
		 setReportFrameworkParameter("order_status", document.all.order_status[document.all.order_status.selectedIndex].value);
		 setReportFrameworkParameter("order_id", document.OrderId.EnterOrderId.value);
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
			document.enquiryPeriod.StartDateEndDateHelperMonthSD.value != "" || document.enquiryPeriod.StartDateEndDateHelperDaySD.value != "" ))
		{
			parent.alertDialog("<%=UIUtil.toJavaScript(biNLS.get("SelectAnyOneOption"))%>");
			ResetValues();
			return false;

		  }
		 if(document.all.time.selectedIndex == 0)
		 {
			 if (validateStartDateEndDate("enquiryPeriod") == false) return false;
		 }
		 //Validate the order id..
		 if(!isValidPositiveInteger(document.OrderId.EnterOrderId.value))
		 {

			reprompt(document.OrderId.EnterOrderId.value, "<%=UIUtil.toJavaScript(biNLS.get("InvalidOrderId"))%>");
			parent.alertDialog("<%=UIUtil.toJavaScript(biNLS.get("InvalidOrderId"))%>");
			return false;
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

</SCRIPT>
<META name="GENERATOR" content="IBM WebSphere Studio">
</HEAD>

<BODY ONLOAD="initializeValues()" CLASS=content>

   <h1><LABEL><%=biNLS.get("biReviewOrderStatusReportWindowTitle") %></LABEL></h1>
   <LABEL><%=biNLS.get("biReviewOrderStatusReportDescription")%></LABEL>

   <DIV ID=pageBody STYLE="display: block; margin-left: 20">
   	<FORM NAME="OrderId">
		<TABLE CELLPADDING=0 CELLSPACING=0>
         <TR HEIGHT=25>
            <TD COLSPAN=4 VALIGN=TOP>
			<LABEL><%=biNLS.get("EnterOrderID")%></LABEL> </TD>
            <TD WIDTH=10>&nbsp;</TD>
            <TD COLSPAN=4 VALIGN=TOP>
            <TD><LABEL for="OrderID"></LABEL><INPUT TYPE=TEXT id="OrderID" NAME=EnterOrderId   SIZE=20 MAXLENGTH=32>&nbsp;</TD>
            </TR>
	       </TABLE>
		</Form>
   </DIV>

   <p></p>
   <LABEL><%=biNLS.get("biReviewOrderStatusSelection")%></LABEL>
   <p>
   <DIV ID=pageBody STYLE="display: block; margin-left: 20">
   <label for="order_status"><%=biNLS.get("labelOrderStatus")%></label><br>
	<select id="order_status">
		<option value="1" selected><LABEL><%=biNLS.get("pending")%></LABEL></option>
		<option value="2"><LABEL><%=biNLS.get("canceled")%></LABEL></option>
		<option value="3"><LABEL><%=biNLS.get("submitted")%></LABEL></option>
		<option value="4"><LABEL><%=biNLS.get("paymentInitiated")%></LABEL></option>
		<option value="5"><LABEL><%=biNLS.get("lowInventory")%></LABEL></option>
		<option value="6"><LABEL><%=biNLS.get("paymentauthorized")%></LABEL></option>
		<option value="7"><LABEL><%=biNLS.get("shipped")%></LABEL></option>
		<option value="8"><LABEL><%=biNLS.get("ordertemplate")%></LABEL></option>
		<option value="9"><LABEL><%=biNLS.get("waitingforapproval")%></LABEL></option>
		<option value="10"><LABEL><%=biNLS.get("approvaldenied")%></LABEL></option>
		<option value="11"><LABEL><%=biNLS.get("requiresreview")%></LABEL></option>
		<option value="12"><LABEL><%=biNLS.get("csredit")%></LABEL></option>
		<option value="13"><LABEL><%=biNLS.get("backordered")%></LABEL></option>
		<option value="14"><LABEL><%=biNLS.get("releaseforfulfillment")%></LABEL></option>
		<option value="15"><LABEL><%=biNLS.get("deposited")%></LABEL></option>
		<option value="16"><LABEL><%=biNLS.get("temporary")%></LABEL></option>
		<option value="17"><LABEL><%=biNLS.get("readyforremotefulfillment")%></LABEL></option>
		<option value="18"><LABEL><%=biNLS.get("waitingforremotefulfillment")%></LABEL></option>
		<option value="19"><LABEL><%=biNLS.get("privatelist")%></LABEL></option>
		<option value="20"><LABEL><%=biNLS.get("shareablelist")%></LABEL></option>
	</select>
  </DIV>
   <p></p>
   <LABEL><%=biNLS.get("biReviewOrderStatusReportSelection")%></LABEL>
   <p>

  <DIV ID=pageBody STYLE="display: block; margin-left: 20">
  <label for="time"><%=biNLS.get("labelTimePeriod")%></label><br>
	<select id="time">
		<option value="pleaseSelect" selected><LABEL><%=biNLS.get("pleaseSelect")%></LABEL></option>
		<option value="Yesterday"><LABEL><%=biNLS.get("yesterdayTitle")%></LABEL></option>
		<option value="Weekly"><LABEL><%=biNLS.get("thisWeekTitle")%></LABEL></option>
		<option value="Monthly"><LABEL><%=biNLS.get("thisMonthTitle")%></LABEL></option>
		<option value="Quarterly"><LABEL><%=biNLS.get("thisQuarterTitle")%></LABEL></option>
		<option value="Yearly"><LABEL><%=biNLS.get("thisYearTitle")%></LABEL></option>
	</select>
  </DIV>

<p></p>
<p></p>

 <DIV ID=pageBody STYLE="display: block; margin-left: 20">
  <B><LABEL><%=biNLS.get("or")%></LABEL></B>
  </DIV>

   <DIV ID=pageBody STYLE="display: block; margin-left: 20">
      <%=generateStartDateEndDate("enquiryPeriod", biNLS, null)%>
   </DIV>

   <br>
<table border="0" bordercolor="black" CELLPADDING="0" CELLSPACING="0">
	<tr>
		<td>
		<table border="0" bordercolor="black" CELLPADDING="0" CELLSPACING="0" width="200">
		<tr>
			<td align="left">
				<B><LABEL><%=biNLS.get("sortby")%></LABEL></B>
			</td>
		</tr>
		</table>
		</td>
		<td>
		<table border="0" bordercolor="black" CELLPADDING="0" CELLSPACING="0" width="200">
		<tr>
			<td align="left">
			  <B><LABEL><%=biNLS.get("orderby")%></LABEL></B>
			</td>
		</tr>
		</table>
		</td>
		</tr>
</table>
	<div id=pageBody style="display: block; margin-center:5">
		<%=generateSortOrderByOption("myHelperReviewOrders", biNLS)%>
	</div>

</BODY>
</HTML>
