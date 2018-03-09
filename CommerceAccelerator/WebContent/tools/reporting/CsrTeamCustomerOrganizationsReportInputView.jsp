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

   <TITLE><%=reportsRB.get("CsrTeamActiveAccountsB2BReportTitle")%></TITLE>
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
	   setReportFrameworkParameter("XMLFile","reporting.CsrTeamCustomerOrganizationsReportOutputDialog");
         setReportFrameworkReportXML("reporting.CsrTeamCustomerOrganizationsReport");		
         setReportFrameworkReportName("CsrTeamActiveAccountsB2BReport"); 	
		 
		 if (document.forms["sortForm"].rbsort[0].checked) 
		{
			
			setReportFrameworkParameter("order","DESC");
		}
		else
		{
						
			setReportFrameworkParameter("order","ASC");
		}
     

         ////////////////////////////////////////////////////////////////////////////////////////////////////
         // Specify the report specific parameters and save
         ////////////////////////////////////////////////////////////////////////////////////////////////////	   
	
		
	   if (document.form1.EnterCsrId.value != ""){
		setReportFrameworkReportName("CsrTeamActiveAccountsB2BReportForTeam");
		setReportFrameworkParameter("InputParm", document.form1.EnterCsrId.value);
		setReportFrameworkParameter("InputParmName", "TEAMNAME");
	   }	   
	   else{
		setReportFrameworkReportName("CsrTeamActiveAccountsB2BReportForOrg");
		setReportFrameworkParameter("InputParm", document.form1.EnterOrg.value);
		setReportFrameworkParameter("InputParmName", "ORGNAME");
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
	  if (document.form1.EnterCsrId.value == "" && document.form1.EnterOrg.value == "" ){
		parent.alertDialog("<%=UIUtil.toJavaScript(reportsRB.get("CsrTeamActiveAccountsB2BReportEnterTeamNameAlert"))%> ");
		return false;
	   }	   
         return true;
	}
	function disableCsr()
	{
		document.form1.EnterCsrId.disabled=false;
		document.form1.EnterOrg.disabled=true;
		document.form1.EnterCsrId.focus();
		document.form1.EnterOrg.value="";
	}
	function disableOrg()
	{
		document.form1.EnterCsrId.disabled=true;
		document.form1.EnterOrg.disabled=false;
		document.form1.EnterOrg.focus();
		document.form1.EnterCsrId.value="";
	}	


</SCRIPT>
<META name="GENERATOR" content="IBM WebSphere Studio">
</HEAD>

<BODY ONLOAD="initializeValues()" CLASS=content>

   <H1><%=reportsRB.get("CsrTeamActiveAccountsB2BReportWindowTitle") %></H1>
   <%=reportsRB.get("CsrTeamActiveAccountsB2BReportInputDescription")%>

   <DIV ID=pageBody STYLE="display: block; margin-left: 20">
	<FORM NAME="form1">
		
	<TABLE CELLPADDING=0 CELLSPACING=0>
         	<TR HEIGHT=25>         
			<TD VALIGN=TOP>
				<LABEL FOR=rb1></LABEL><INPUT TYPE=RADIO NAME=rbname ID=rb1 checked="checked" onclick="disableCsr()">
				<LABEL FOR=CsrId><%=reportsRB.get("CsrTeamActiveAccountsB2BReportEnterTeamName")%></LABEL>
			</TD>					
			<TD WIDTH=10>&nbsp;</TD>
			<TD VALIGN=TOP><INPUT TYPE=TEXT NAME=EnterCsrId ID=CsrId SIZE=30>&nbsp;</LABEL>
			</TD>                
        	</TR>
		<TR HEIGHT=25>         
			<TD VALIGN=TOP>
				<LABEL FOR=rb2></LABEL><INPUT TYPE=RADIO NAME=rbname ID=rb2 onclick="disableOrg()">
				<LABEL FOR=Org><%=reportsRB.get("CsrTeamActiveAccountsB2BReportEnterOrg")%></LABEL>
			</TD>
			<TD WIDTH=10>&nbsp;</TD>
			<TD VALIGN=TOP><INPUT TYPE=TEXT NAME=EnterOrg ID=Org SIZE=30>&nbsp;
			</TD>                
         	</TR>          
	    </TABLE>
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
											<%=reportsRB.get("CsrActiveAccountsB2BReportEnterOrg")%>
										</label>
									</INPUT>															
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

