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
<%@include file="common.jsp" %>
<%@include file="ReportFrameworkHelper.jsp" %>

<HTML>
<HEAD>
   <%=fHeader%>

   <TITLE><%=reportsRB.get("CsrDailyRevenueReportTitle")%></TITLE>

   <SCRIPT SRC="/wcs/javascript/tools/common/DateUtil.js"></SCRIPT>

   <SCRIPT>

      ///////////////////////////////////////////////////////////////////////////////////////////////////////
      // Call the initialize routines for the various elements of the page
      ///////////////////////////////////////////////////////////////////////////////////////////////////////
      function initializeValues() 
      {        
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
	   setReportFrameworkParameter("XMLFile","reporting.CsrDailyRevenueReportOutputDialog");
         setReportFrameworkReportXML("reporting.CsrDailyRevenueReport");		
         
         ////////////////////////////////////////////////////////////////////////////////////////////////////
         // Specify the report specific parameters and save
         ////////////////////////////////////////////////////////////////////////////////////////////////////
		if (document.form1.EnterTeamName.value == ""){
			setReportFrameworkReportName("CsrDailyRevenueReportForAll");
			setReportFrameworkParameter("teamName", null);
		}else{
			setReportFrameworkReportName("CsrDailyRevenueReport");
			setReportFrameworkParameter("teamName", document.form1.EnterTeamName.value);	
		}	

		if (document.forms["sortForm"].rbname[0].checked) {
			setReportFrameworkParameter("sort","revenue");
		} else {
			setReportFrameworkParameter("sort","name");
		}

		if (document.forms["sortForm"].rbsort[0].checked) {
			setReportFrameworkParameter("order","DESC");
		} else {
			setReportFrameworkParameter("order","ASC");
		}
		 setReportFrameworkParameter("CurrentDateStart", returnCurrentDateStart());
		 setReportFrameworkParameter("CurrentDateEnd", returnCurrentDateEnd());
         saveReportFramework();
         top.saveModel(parent.model);
         return true;
      }

      ///////////////////////////////////////////////////////////////////////////////////////////////////////
      // Call the validate routines for the various elements of the page
      ///////////////////////////////////////////////////////////////////////////////////////////////////////
      function validatePanelData()
      {
/*	  if (document.form1.EnterTeamName.value == ""){
		parent.alertDialog("<%=UIUtil.toJavaScript(reportsRB.get("CsrDailyRevenueReportEnterCsrIdAlert"))%> ");
		return false;
	   }	   */
         return true;
	}

	// Returns current sysdate date 

	function returnCurrentDateStart(){
		var currentDateStart = getCurrentYear() + "-" + getCurrentMonth() + "-" + getCurrentDay() + "-00.00.00";
		return currentDateStart;
	}

	function returnCurrentDateEnd(){
		var currentDateEnd = getCurrentYear() + "-" + getCurrentMonth() + "-" + getCurrentDay() + "-23.59.59";
		return currentDateEnd;
	}


</SCRIPT>
<META name="GENERATOR" content="IBM WebSphere Studio">
</HEAD>

<BODY ONLOAD="initializeValues()" CLASS=content>

   <H1><%=reportsRB.get("CsrDailyRevenueReportWindowTitle") %></H1>
   <%=reportsRB.get("CsrDailyRevenueReportInputDescription")%>

   <DIV ID=pageBody STYLE="display: block; margin-left: 20">
	<FORM NAME="form1">
		<TABLE CELLPADDING=0 CELLSPACING=0>
         		<TR HEIGHT=25>
            		<TD VALIGN=TOP><LABEL FOR=EnterTeamName> 
					<%=reportsRB.get("CsrDailyRevenueReportEnterTeam")%></LABEL></TD>
				</TR>
				<TR HEIGHT=25>
            		<TD VALIGN=TOP>
					<INPUT TYPE=TEXT NAME='EnterTeamName' ID='EnterTeamName' SIZE='20' MAXLENGTH='50' onkeypress="trapKey(event);">&nbsp;
				</TD>				
			</TR>
	       </TABLE>
		<BR><BR>
	</FORM>      
   </DIV>
<br>

<table border="0" bordercolor="black" CELLPADDING="0" CELLSPACING="0">
	<tr>

		<td>
		<table border="0" bordercolor="black" CELLPADDING="0" CELLSPACING="0" width="210">
		<tr>
			<td align="left">
				<B><LABEL><%=reportsRB.get("sortby")%></LABEL></B>
			</td>
		</tr>
		</table>
		</td>

		<td>
		<table border="0" bordercolor="black" CELLPADDING="0" CELLSPACING="0" width="210">
		<tr>
			<td align="left">
			  <B><LABEL><%=reportsRB.get("orderby")%></LABEL></B>
			</td>
		</tr>
		</table>
		</td>

		</tr>
	</table>
		<FORM NAME=sortForm>
			<TABLE border=0 bordercolor=red CELLPADDING=0 CELLSPACING=0 width=400>
				<TR>
					<TD ALIGN=left VALIGN=TOP>
						<TABLE border=0 bordercolor=black CELLPADDING=0 CELLSPACING=0 width=200>
							<TR HEIGHT=5>
								<TD ALIGN=left VALIGN=TOP>
									<INPUT TYPE=RADIO id="s1" NAME=rbname checked>
										<label for="s1">
											<%=reportsRB.get("CsrDailyRevenueReportSortByRevenue")%>
										</label>
									</INPUT>
									<BR>
									<BR>
									<INPUT TYPE=RADIO id="s2" NAME=rbname>
										<label for="s2">
											<%=reportsRB.get("CsrDailyRevenueReportSortByName")%>
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
									<INPUT TYPE=RADIO id="ord1"  NAME=rbsort checked>
										<label for="ord1">
											<%=reportsRB.get("descend")%>
										</label>
									</INPUT>
									<BR>
									<BR>
									<INPUT TYPE=RADIO id="ord2" NAME=rbsort>
										<label for="ord2">
											<%=reportsRB.get("ascend")%>
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
