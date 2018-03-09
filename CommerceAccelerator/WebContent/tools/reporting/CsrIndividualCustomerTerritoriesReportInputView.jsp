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

   <TITLE><%=reportsRB.get("CsrActiveAccountsB2CReportTitle")%></TITLE>
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
	   setReportFrameworkParameter("XMLFile","reporting.CsrIndividualCustomerTerritoriesReportOutputDialog");
         setReportFrameworkReportXML("reporting.CsrIndividualCustomerTerritoriesReport");		
         setReportFrameworkReportName("CsrActiveAccountsB2CReport"); 
		 
		 if (document.forms["sortForm"].rbsort[0].checked) 
		{
			
			setReportFrameworkParameter("order","DESC");
		}
		else
		{
						
			setReportFrameworkParameter("order","ASC");
		}
		
		
		 if (document.forms["sortForm"].rbname1[0].checked) 
		{
			
			setReportFrameworkParameter("sort","MBRGRPNAME");
		}
		else
		{
						
			setReportFrameworkParameter("sort","CSRGROUP");
		}
     

         ////////////////////////////////////////////////////////////////////////////////////////////////////
         // Specify the report specific parameters and save
         ////////////////////////////////////////////////////////////////////////////////////////////////////
 	   setReportFrameworkParameter("InputParm", document.form1.EnterCsrId.value);	
 	   setReportFrameworkParameter("InputParmName", "CSRID");
         saveReportFramework();
         top.saveModel(parent.model);
         return true;
      }

      ///////////////////////////////////////////////////////////////////////////////////////////////////////
      // Call the validate routines for the various elements of the page
      ///////////////////////////////////////////////////////////////////////////////////////////////////////
      function validatePanelData()
      {
	  if (document.form1.EnterCsrId.value == ""){
		parent.alertDialog("<%=UIUtil.toJavaScript(reportsRB.get("CsrActiveAccountsB2CReportEnterCsrIdAlert"))%> ");
		return false;
	   }	   
         return true;
	}

</SCRIPT>
<META name="GENERATOR" content="IBM WebSphere Studio">
</HEAD>

<BODY ONLOAD="initializeValues()" CLASS=content>

   <H1><%=reportsRB.get("CsrActiveAccountsB2CReportWindowTitle") %></H1>
   <%=reportsRB.get("CsrActiveAccountsB2CReportInputDescription")%>
   <br>
   <br>
   <b><%=reportsRB.get("searchCriteria")%></b>   

   <DIV ID=pageBody STYLE="display: block; margin-left: 20">
	<FORM NAME="form1">
		<TABLE CELLPADDING=0 CELLSPACING=0>
         		<TR HEIGHT=25>
            		<TD VALIGN=TOP><LABEL FOR=EnterCsrId> 
					<%=reportsRB.get("CsrActiveAccountsB2CReportEnterCsrId")%></LABEL></TD>
            		<TD WIDTH=10>&nbsp;</TD>
            		<TD VALIGN=TOP>
					<INPUT TYPE=TEXT NAME='EnterCsrId' ID='EnterCsrId' SIZE='20' MAXLENGTH='20'>&nbsp;
				</TD>				
			</TR>
	       </TABLE>
		<BR><BR>
	</FORM>
	
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
									<INPUT TYPE=RADIO id="s1" NAME=rbname1 checked>
										<label for="s1">
										<%=reportsRB.get("CsrActiveAccountsB2BReportEnterTerritory")%>	
										</label>
									</INPUT>
									<BR>
									<BR>	
									<INPUT TYPE=RADIO id="s2" NAME=rbname1>
										<label for="s2">
										<%=reportsRB.get("CsrActiveAccountsB2BReportEnterTeamName")%>	
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
