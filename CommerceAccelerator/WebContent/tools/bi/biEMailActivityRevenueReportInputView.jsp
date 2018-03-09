<!-- ========================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (c) Copyright IBM Corp. 2001, 2002

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
===========================================================================-->

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
<%@page import="java.util.*" %>
<%@page import="com.ibm.commerce.tools.util.*" %>
<%@page import="com.ibm.commerce.tools.xml.*" %>

<%@include file="/tools/common/common.jsp" %>
<%@include file="/tools/reporting/ReportStartDateEndDateHelper.jspf" %>
<%@include file="/tools/reporting/ReportFrameworkHelper.jsp" %>

<%
   CommandContext biCommandContext = (CommandContext) request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
   Locale biLocale = biCommandContext.getLocale();
   Hashtable biNLS = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("bi.biNLS", biLocale);
%>

<HTML>
<HEAD>

<link rel=stylesheet href="<%= UIUtil.getCSSFile(biLocale) %>" type="text/css">
   <%=fHeader%>

   <title><LABEL><%=biNLS.get("eMailActivityRevenue")%></LABEL></title>

   <SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
   <SCRIPT SRC="/wcs/javascript/tools/common/DateUtil.js"></SCRIPT>
   <SCRIPT SRC="/wcs/javascript/tools/common/SwapList.js"></SCRIPT>
   <SCRIPT SRC="/wcs/javascript/tools/reporting/ReportHelpers.js"></SCRIPT>

   <SCRIPT>

	/////////////////////////////////////////////////////////////////////
	// Call the initialize routines for the various elements of the page
	/////////////////////////////////////////////////////////////////////
	function initializeValues() {
    	ResetValues();
		onLoadStatOption("myHelperEMailActivityRevenue");
       	if (parent.setContentFrameLoaded) {
       		parent.setContentFrameLoaded(true);
       	}
    }

	///////////////////////////////////////////////////////////////
	// Call the save routines for the various elements of the page
	///////////////////////////////////////////////////////////////
	function savePanelData() {
		saveStatOption("myHelperEMailActivityRevenue");
		setReportFrameworkOutputView("DialogView");
		setReportFrameworkParameter("XMLFile","bi.biEMailActivityRevenueReportOutputDialog");
		setReportFrameworkReportXML("bi.biEMailActivityRevenueReport");

		if (document.forms["myHelperEMailActivityRevenue"].rbsort[0].checked) {
			setReportFrameworkParameter("sortOrder","DESC");
		} else {
			setReportFrameworkParameter("sortOrder","ASC");
		}

		if (document.forms["myHelperEMailActivityRevenue"].rbname[0].checked) {
			setReportFrameworkParameter("sortBy","1");
		} else if (document.forms["myHelperEMailActivityRevenue"].rbname[1].checked) {
			setReportFrameworkParameter("sortBy","2");
		} else if (document.forms["myHelperEMailActivityRevenue"].rbname[2].checked) {
			setReportFrameworkParameter("sortBy","3");
		} else if (document.forms["myHelperEMailActivityRevenue"].rbname[3].checked) {
			setReportFrameworkParameter("sortBy","4");
		} else if (document.forms["myHelperEMailActivityRevenue"].rbname[4].checked) {
			setReportFrameworkParameter("sortBy","5");
		}

                setReportFrameworkParameter("emailActivityName",document.Names.emailActivityName.value);
                setReportFrameworkParameter("campaignName",document.Names.campaignName.value);
                
		setReportFrameworkReportName("biEMailActivityRevenueReport");

		if (document.all.time.selectedIndex != 0) {
			var startDate = getPreselectedStartDate(document.all.time.value);
			var endDate = getPreselectedEndDate(document.all.time.value);

			setReportFrameworkParameter("StartDate", startDate);
		 	setReportFrameworkParameter("EndDate", endDate);
		} else {
			saveStartDateEndDate("enquiryPeriod");
			setEndDate();
		 	setReportFrameworkParameter("StartDate", returnStartDateAsTimestamp("enquiryPeriod"));
			setReportFrameworkParameter("EndDate", returnEndDateAsTimestamp("enquiryPeriod"));
		}
	 	setReportFrameworkParameter("ReportType", "UserInput");
        saveReportFramework();
        top.saveModel(parent.model);
        return true;
	}

    ///////////////////////////////////////////////////////////////////
    // Call the validate routines for the various elements of the page
    ///////////////////////////////////////////////////////////////////
    function validatePanelData() {
		if (document.all.time.selectedIndex != 0 &&
			(document.enquiryPeriod.StartDateEndDateHelperYearSD.value != "" ||
			document.enquiryPeriod.StartDateEndDateHelperMonthSD.value != "" ||
			document.enquiryPeriod.StartDateEndDateHelperDaySD.value != "" )) {

			parent.alertDialog("<%=UIUtil.toJavaScript(biNLS.get("SelectAnyOneOption"))%>");
			ResetValues();
			return false;
		}
		if (document.all.time.selectedIndex == 0) {
			if (validateStartDateEndDate("enquiryPeriod") == false) {
				return false;
			}
		}
		return true;
	}


	function ResetValues() {
		document.enquiryPeriod.StartDateEndDateHelperYearSD.value = "";
		document.enquiryPeriod.StartDateEndDateHelperMonthSD.value = "";
		document.enquiryPeriod.StartDateEndDateHelperDaySD.value = "";
		document.enquiryPeriod.StartDateEndDateHelperYearED.value = "";
		document.enquiryPeriod.StartDateEndDateHelperMonthED.value = "";
		document.enquiryPeriod.StartDateEndDateHelperDayED.value = "";
		document.all.time.selectedIndex = 0;
	}


	function setEndDate() {
   		if ((document.enquiryPeriod.StartDateEndDateHelperYearSD.value != "" &&
			 document.enquiryPeriod.StartDateEndDateHelperMonthSD.value != "" &&
			 document.enquiryPeriod.StartDateEndDateHelperDaySD.value != "" ) &&
			(document.enquiryPeriod.StartDateEndDateHelperYearED.value == "" &&
			 document.enquiryPeriod.StartDateEndDateHelperMonthED.value == "" &&
			 document.enquiryPeriod.StartDateEndDateHelperDayED.value == "" )) {

			parent.alertDialog("<%=UIUtil.toJavaScript(biNLS.get("EndDateIsCurrentDate"))%>");
			document.enquiryPeriod.StartDateEndDateHelperYearED.value = getCurrentYear();
			document.enquiryPeriod.StartDateEndDateHelperMonthED.value = getCurrentMonth();
			document.enquiryPeriod.StartDateEndDateHelperDayED.value = getCurrentDay();
		}
	}

   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   // Validate is done by the HTML radio button
   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   function validateStatOption(container) {
      return true;
   }

   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   // initialize function for the status dates
   ///////////////////////////////////////////////////////////////////////////////////////////////////////

  function onLoadStatOption(container) {
	  var myContainer = parent.get(container, null);

	  // If this is the first time set it to the default.
      if (myContainer == null) {
			myContainer = new Object();
			myContainer.StatusChosen = 1;
			with (document.forms[container]) {
				rbname[0].checked = true;
				rbsort[0].checked = true;
			}
			parent.put(container, myContainer);
			return;
      } else {
      		// If it is not the first time set it to the last selected.
			if(myContainer.StatusChosen == 10){
				document.forms[container].rbname[4].checked = true;
				document.forms[container].rbsort[1].checked = true;
			}
			else if(myContainer.StatusChosen == 9){
				document.forms[container].rbname[4].checked = true;
				document.forms[container].rbsort[0].checked = true;
			}

			 else if(myContainer.StatusChosen == 8){
				document.forms[container].rbname[3].checked = true;
				document.forms[container].rbsort[1].checked = true;
			}

			 else if(myContainer.StatusChosen == 7){
				document.forms[container].rbname[3].checked = true;
				document.forms[container].rbsort[0].checked = true;
			}
			else if(myContainer.StatusChosen == 6){
				document.forms[container].rbname[2].checked = true;
				document.forms[container].rbsort[1].checked = true;
			}
			 else if(myContainer.StatusChosen == 5){
				document.forms[container].rbname[2].checked = true;
				document.forms[container].rbsort[0].checked = true;
			}
			 else if(myContainer.StatusChosen == 4){
				document.forms[container].rbname[1].checked = true;
				document.forms[container].rbsort[1].checked = true;
			}
			 else if(myContainer.StatusChosen == 3){
				document.forms[container].rbname[1].checked = true;
				document.forms[container].rbsort[0].checked = true;
			}
			 else if(myContainer.StatusChosen == 2){
				document.forms[container].rbname[0].checked = true;
				document.forms[container].rbsort[1].checked = true;
			}
			 else {
				document.forms[container].rbname[0].checked = true;
				document.forms[container].rbsort[0].checked = true;
			}
			parent.put(container, myContainer);
      		return;
      }
   }

   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   // save function for the Staus selected
   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   function saveStatOption(container) {
   		myContainer = parent.get(container,null);
      	if (myContainer == null) {
      		return;
      	}
		with (document.forms[container]) {
			 if (rbname[4].checked){
			       if (rbsort[1].checked) {
			       myContainer.StatusChosen = 10;
			       } else {
			              myContainer.StatusChosen = 9;
			       }
	        } else if (rbname[3].checked){
				if (rbsort[1].checked) {
	      	 		myContainer.StatusChosen = 8;
				} else {
					myContainer.StatusChosen = 7;
				}
	     	} else if (rbname[2].checked) {
				if (rbsort[1].checked) {
	      	 		myContainer.StatusChosen = 6;
				} else {
					myContainer.StatusChosen = 5;
				}
	      	} else if (rbname[1].checked) {
	      	 	if (rbsort[1].checked) {
	      	 		myContainer.StatusChosen = 4;
				} else {
					myContainer.StatusChosen = 3;
				}
	      	 } else {
	      	 	if (rbsort[1].checked) {
	      	 		myContainer.StatusChosen = 2;
				} else {
					myContainer.StatusChosen = 1;
				}
	      	}
      	}
		parent.put(container, myContainer);
   }

   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   // Return the Status Chosen
   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   function returnStatOptionCampaign(container) {
    	return document.forms[container].rbname[0].checked;
   }



   function returnStatOptionDisplayed(container) {
   		return document.forms[container].rbname[1].checked;
   }

   function returnStatOptionClicked(container) {
   		return document.forms[container].rbname[2].checked;
   }

   function returnStatOptionDisplayedClickedOrdered(container) {
      	return document.forms[container].rbname[3].checked;
   }

   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   // Return the Orderby Status Chosen
   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   function returnOrderbyDesc(container) {
      	return document.forms[container].rbsort[0].checked;
   }

   function returnOrderbyAsc(container) {
      	return document.forms[container].rbsort[1].checked;
   }

</SCRIPT>
</HEAD>

<BODY ONLOAD="initializeValues()" CLASS=content>

<h1><LABEL><%=biNLS.get("eMailActivityRevenue") %></LABEL></h1>
<LABEL><%=biNLS.get("eMailActivityRevenueDescription") %></LABEL>
<p>

<table border="0" bordercolor="black" CELLPADDING="0" CELLSPACING="0" width="400">
	<tr>
		<td>
			<DIV ID=pageBody STYLE="display: block; margin-left: 0">
				<form>
					<label for="time"><%=biNLS.get("lableviewreportfor")%></label><br><br>
			      	<select id="time">
						<option value="pleaseSelect" selected><LABEL><%=biNLS.get("pleaseSelect")%></LABEL></option>
			      		<option value="Yesterday"><LABEL><%=biNLS.get("yesterdayTitle")%></LABEL></option>
			      		<option value="Weekly"><LABEL><%=biNLS.get("thisWeekTitle")%></LABEL></option>
			      		<option value="Monthly"><LABEL><%=biNLS.get("thisMonthTitle")%></LABEL></option>
						<option value="Quarterly"><LABEL><%=biNLS.get("thisQuarterTitle")%></LABEL></option>
			      		<option value="Yearly"><LABEL><%=biNLS.get("thisYearTitle")%></LABEL></option>
					</select>
				</form>
			</DIV>
			<DIV ID=pageBody STYLE="display: block; margin-left: 50">
				<B><LABEL><%=biNLS.get("or")%></LABEL></B>
			</DIV>
			<DIV ID=pageBody STYLE="display: block; margin-left: 0">
				<%=generateStartDateEndDate("enquiryPeriod", biNLS, null)%>
			</DIV>
		<DIV ID=pageBody STYLE="display: block; margin-left: 0">
    			<FORM NAME="Names">
 					
 				<%=biNLS.get("eMailActivityName")%>
 				<label for="eMailActivityName"> </label>
 				 <INPUT TYPE=TEXT NAME=emailActivityName  id="eMailActivityName" SIZE=10 MAXLENGTH=32> 
 				  (<%=biNLS.get("optional")%>)
 			                        
 	                	  <BR>
 				        
 	                 	  <%=biNLS.get("campaignName")%> 
 		     		  <label for="campaignName"> </label>
 		     		   <INPUT TYPE=TEXT NAME=campaignName  id="campaignName" SIZE=10 MAXLENGTH=32> 
 				 (<%=biNLS.get("optional")%>)
 		       		  <BR>
 				      
 			</Form>
 </DIV>
 
			
			

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

<DIV ID=pageBody STYLE="display: block; margin-left:0">
	<FORM NAME=myHelperEMailActivityRevenue>
		<TABLE border=0 bordercolor=red CELLPADDING=0 CELLSPACING=0 width=400>
			<TR>
				<TD ALIGN=left VALIGN=TOP>
					<TABLE border=0 bordercolor=black CELLPADDING=0 CELLSPACING=0 width=200>
						<TR HEIGHT=5>
							<TD ALIGN=left VALIGN=TOP>
								<INPUT TYPE=RADIO NAME=rbname id="s1" VALUE=All>
									<label for="s1">
										<%=biNLS.get("emailactivityname")%>
									</label>
								</INPUT>
					            <BR>
					            <BR>
					            <INPUT TYPE=RADIO NAME=rbname id="s2" VALUE=PayA>
						    		        <label for="s2">
						    				<%=biNLS.get("campaignname")%>
						    			</label>
						    </INPUT>
						    <BR>
					            <BR>
					            <INPUT TYPE=RADIO NAME=rbname id="s3" VALUE=PayA>
									<label for="s3">
										<%=biNLS.get("avgorderamount")%>
									</label>
								</INPUT>
					            <BR>
					            <BR>
					            
					            <INPUT TYPE=RADIO NAME=rbname id="s4" VALUE=PayA>
									<label for="s4">
										<%=biNLS.get("associatedorders")%>
									</label>
								</INPUT>
					            <BR>
							<BR>
					            <INPUT TYPE=RADIO NAME=rbname id="s5" VALUE=PayA>
									<label for="s5">
										<%=biNLS.get("associatedrevenue")%>
									</label>
								</INPUT>
					            <BR>

							</TD>
						</TR>
					</TABLE>
				</TD>
				<TD>&nbsp;</TD>
				<TD ALIGN=left VALIGN=TOP>
					<TABLE border=0 bordercolor=black CELLPADDING=0 CELLSPACING=0 width=200>
						<TR HEIGHT=5>
							<TD ALIGN=left VALIGN=TOP>
					            <INPUT TYPE=RADIO  NAME=rbsort id="ord1" VALUE=All>
									<label for="ord1">
										<%=biNLS.get("descend")%>
									</label>
								</INPUT>
					            <BR>
					            <BR>
					            <INPUT TYPE=RADIO NAME=rbsort id="ord2" VALUE=PayA>
									<label for="ord2">
										<%=biNLS.get("ascend")%>
									</label>
								</INPUT>
					            <BR>
							</TD>
						</TR>
					</TABLE>
				</TD>
			</TR>
		</TABLE>
	</FORM>
</DIV>

</BODY>
</HTML>
