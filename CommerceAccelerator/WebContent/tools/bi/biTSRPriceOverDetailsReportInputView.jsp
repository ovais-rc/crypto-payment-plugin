<%
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* 5697-D24
//*
//* (c) Copyright IBM Corp. 2005
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

<%@include file="biTSRPriceOverDetailsReportHelper.jsp" %>

<%@include file="/tools/reporting/common.jsp" %>
<%@include file="/tools/reporting/ReportStartDateEndDateHelper.jspf" %>
<%@include file="/tools/reporting/ReportFrameworkHelper.jsp" %>


<%
   CommandContext biCommandContext = (CommandContext) request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
   Locale biLocale = biCommandContext.getLocale();
   Hashtable biNLS = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("bi.biNLS", biLocale);
%>

<HTML>
<HEAD>
   <%=fHeader%>

   <TITLE><%=biNLS.get("biTSRPriceOverDetailsReportWindowTitle")%></TITLE>

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
         onLoadSortOrderByOption("myHelperTSRPriceOverideDetails");
         document.PriceOvDet.EnterUserId.disabled=true;
		 document.PriceOvDet.EnterOrderId.disabled=false;
		 document.PriceOvDet.EnterOrderId.focus();         
         if (parent.setContentFrameLoaded) parent.setContentFrameLoaded(true);
      }


      ///////////////////////////////////////////////////////////////////////////////////////////////////////
      // Call the save routines for the various elements of the page
      ///////////////////////////////////////////////////////////////////////////////////////////////////////
      function savePanelData() 
      {
	    ////////////////////////////////////////////////////////////////////////////////////////////////////
        // Set report framework particulars
        ////////////////////////////////////////////////////////////////////////////////////////////////////
		saveSortOrderByOption("myHelperTSRPriceOverideDetails");
        setReportFrameworkOutputView("DialogView");
		setReportFrameworkParameter("XMLFile","bi.biTSRPriceOverDetailsReportOutputDialog");
        setReportFrameworkReportXML("bi.biTSRPriceOverDetailsReport");
		////////////////////////////////////////////////////////////////////////////////////////////////////
        // Check input is Order id or TSR id
        ////////////////////////////////////////////////////////////////////////////////////////////////////
        if(document.PriceOvDet.EnterUserId.value!=""){
	         /////////////////////////////////////////
    	     //TSR Id
        	 /////////////////////////////////////////
	   		 saveStartDateEndDate("enquiryPeriod");
			 setReportFrameworkReportName("TSRPriceOverDetailsTSRInputReport");   		 
			 sortOrder();
	         ////////////////////////////////////////////////////////////////////////////////////////////////////
    	     // Specify the report input parameters
        	 ////////////////////////////////////////////////////////////////////////////////////////////////////
	   		 setEndDate();
			 setReportFrameworkParameter("StartDate", returnStartDateAsTimestamp("enquiryPeriod"));
        	 setReportFrameworkParameter("EndDate", returnEndDateAsTimestamp("enquiryPeriod"));
	         setReportFrameworkParameter("tsr_id", document.PriceOvDet.EnterUserId.value);   
    		 setReportFrameworkParameter("order_id", null);      
 			 setReportFrameworkParameter("ReportType", "UserInput");
		}else if(document.PriceOvDet.EnterOrderId.value!=""){	
	         /////////////////////////////////////////
    	     //Order Id
        	 /////////////////////////////////////////		
		 	 saveStartDateEndDate("enquiryPeriod");
			 setReportFrameworkReportName("TSRPriceOverDetailsOrderInputReport");
			 sortOrder();
	         ////////////////////////////////////////////////////////////////////////////////////////////////////
    	     // Specify the report input parameters
        	 ////////////////////////////////////////////////////////////////////////////////////////////////////
	 		 setEndDate();
			 setReportFrameworkParameter("StartDate", returnStartDateAsTimestamp("enquiryPeriod"));
        	 setReportFrameworkParameter("EndDate", returnEndDateAsTimestamp("enquiryPeriod"));
	         setReportFrameworkParameter("order_id", document.PriceOvDet.EnterOrderId.value);
	         setReportFrameworkParameter("tsr_id", null);   	         
			 setReportFrameworkParameter("ReportType", "UserInput");
		}else{
			/////////////////////////////////////////
    	     //When both values are not being selected
        	 /////////////////////////////////////////		
		 	 saveStartDateEndDate("enquiryPeriod");
			 setReportFrameworkReportName("TSRPriceOverDetails");
			 sortOrder();
	         ////////////////////////////////////////////////////////////////////////////////////////////////////
    	     // Specify the report input parameters
        	 ////////////////////////////////////////////////////////////////////////////////////////////////////
	 		 setEndDate();
			 setReportFrameworkParameter("StartDate", returnStartDateAsTimestamp("enquiryPeriod"));
        	 setReportFrameworkParameter("EndDate", returnEndDateAsTimestamp("enquiryPeriod"));
	         setReportFrameworkParameter("order_id", null);
	         setReportFrameworkParameter("tsr_id", null);   	         
			 setReportFrameworkParameter("ReportType", "UserInput");
		}
         saveReportFramework();
         top.saveModel(parent.model);
         return true;
      }
      ///////////////////////////////////////////////////////////////////////////////////////////////////////
      // Call the sortOrder to add sort and order parameters
      ///////////////////////////////////////////////////////////////////////////////////////////////////////
	  function sortOrder(){
         	if(returnSortByOptionAdjPer("myHelperTSRPriceOverideDetails")){
	         	setReportFrameworkParameter("sortBy", "ADJUSTPER");
				if(returnOrderbyDesc("myHelperTSRPriceOverideDetails")){
					setReportFrameworkParameter("orderBy", "DESC");
				 }
				 else{
					setReportFrameworkParameter("orderBy", "ASC");
					 }
			 } else if (returnSortByOptionTransDate("myHelperTSRPriceOverideDetails")){
				 setReportFrameworkParameter("sortBy", "FS.CREATED_TIME");
				 if(returnOrderbyDesc("myHelperTSRPriceOverideDetails")){
					setReportFrameworkParameter("orderBy", "DESC");
				 }
				 else{
					setReportFrameworkParameter("orderBy", "ASC");
				 }
			 } else{
	         	setReportFrameworkParameter("sortBy", "FS.ORDERITEMS_ID");
				if(returnOrderbyDesc("myHelperTSRPriceOverideDetails")){
					setReportFrameworkParameter("orderBy", "DESC");
				 }
				 else{
					setReportFrameworkParameter("orderBy", "ASC");
					 }			 
			 }
	  }
      ///////////////////////////////////////////////////////////////////////////////////////////////////////
      // Call the validate routines for the various elements of the page
      ///////////////////////////////////////////////////////////////////////////////////////////////////////
      function validatePanelData()
      {
	    ///////////////////////////////////////////////////////////////////////////////////////////////////////
		//Validate if there is data in either User id or Order id. Only one must be specified.
		///////////////////////////////////////////////////////////////////////////////////////////////////////			
	/*	if(document.PriceOvDet.EnterUserId.value=="" && document.PriceOvDet.EnterOrderId.value==""){
			parent.alertDialog("<%=UIUtil.toJavaScript(biNLS.get("TSRSelectAnyOneOption"))%>");
			return false;	  	
		  }

		if(document.PriceOvDet.EnterOrderId.value!="" && document.PriceOvDet.EnterUserId.value!=""){
			parent.alertDialog("<%=UIUtil.toJavaScript(biNLS.get("TSRSelectAnyOneOption"))%>");
			return false;	  	
		}
		///////////////////////////////////////////////////////////////////////////////////////////////////////		
		//Validate input - must be integer
		///////////////////////////////////////////////////////////////////////////////////////////////////////		
		if(document.PriceOvDet.EnterUserId.value==""){
			///////////////////////////////////////////////////////////////////////////////////////////////////////		
			//Validate the Order id
			///////////////////////////////////////////////////////////////////////////////////////////////////////			
			if(!isValidPositiveInteger(document.PriceOvDet.EnterOrderId.value)){			 
			 	reprompt(document.PriceOvDet.EnterOrderId, "<%=UIUtil.toJavaScript(biNLS.get("InvalidOrderId"))%>");
				//parent.alertDialog("<%=UIUtil.toJavaScript(biNLS.get("InvalidOrderId"))%>");
				return false;
			}		
		}
*/
		///////////////////////////////////////////////////////////////////////////////////////////////////////		  
		//Validate enquiry period
		///////////////////////////////////////////////////////////////////////////////////////////////////////		
		if (validateStartDateEndDate("enquiryPeriod") == false)
		{
			return false;
		}
		return true;
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

	function disableOrder()
	{
		document.PriceOvDet.EnterUserId.disabled=false;
		document.PriceOvDet.EnterOrderId.disabled=true;
		document.PriceOvDet.EnterUserId.focus();
		document.PriceOvDet.EnterOrderId.value="";
	}
	function disableCSRId()
	{
		document.PriceOvDet.EnterUserId.disabled=true;
		document.PriceOvDet.EnterOrderId.disabled=false;
		document.PriceOvDet.EnterOrderId.focus();
		document.PriceOvDet.EnterUserId.value="";
	}	
</SCRIPT>
<META name="GENERATOR" content="IBM WebSphere Studio">
</HEAD>

<BODY ONLOAD="initializeValues()" CLASS=content>

   <H1><%=biNLS.get("biTSRPriceOverDetailsReportWindowTitle") %></H1>
   <%=biNLS.get("biTSRPriceOverDetailsInputReportDescription")%>
   <br>
   <br>
   <b><%=biNLS.get("searchCriteria")%></b>
   <DIV ID=pageBody STYLE="display: block; margin-left: 20">
   	<FORM NAME="PriceOvDet">
		<TABLE CELLPADDING=0 CELLSPACING=0>
         <TR HEIGHT=25>         
			<TD VALIGN=TOP>
				<LABEL FOR="rb1"></LABEL><INPUT TYPE=RADIO NAME=rbname ID=rb1 checked="checked" onclick="disableCSRId()"></INPUT>
				<LABEL FOR="EnterOrderId"><%=biNLS.get("EnterTSROrderID")%></LABEL>
			</TD>
		 </TR>
		 <TR HEIGHT=25>
			<TD VALIGN=TOP><INPUT TYPE=TEXT NAME=EnterOrderId ID=EnterOrderId SIZE=30 onkeypress="trapKey(event);">&nbsp;
			</TD>                
         </TR>
         <TR HEIGHT=25>         
			<TD VALIGN=TOP>
				<LABEL FOR="rb2"></LABEL><INPUT TYPE=RADIO NAME=rbname ID=rb2 onclick="disableOrder()"></INPUT>
				<LABEL FOR="EnterUserId"><%=biNLS.get("EnterTSRUserId")%></LABEL>
			</TD>
		</TR>
		<TR HEIGHT=25>
			<TD VALIGN=TOP><INPUT TYPE=TEXT NAME=EnterUserId ID=EnterUserId SIZE=30 onkeypress="trapKey(event);">&nbsp;
			</TD>                
         </TR>          
	    </TABLE>
		   <BR><BR>
		</Form>
   </DIV>


<p></p>
<p></p>

	<b><%=biNLS.get("timePeriod")%></b>
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
				<B><%=biNLS.get("sortby")%></B>
			</td>
		</tr>
		</table>
		</td>
		<td>
		<table border="0" bordercolor="black" CELLPADDING="0" CELLSPACING="0" width="200">
		<tr>
			<td align="left">
			  <B><%=biNLS.get("orderby")%></B>
			</td>
		</tr>
		</table>
		</td>
		</tr>
</table>
	<div id=pageBody style="display: block; margin-center:5">
		<%=generateSortOrderByOption("myHelperTSRPriceOverideDetails", biNLS)%>
	</div>

</BODY>
</HTML>
