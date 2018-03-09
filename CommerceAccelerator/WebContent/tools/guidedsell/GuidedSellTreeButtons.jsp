<!--
//********************************************************************
//*-------------------------------------------------------------------
//*Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright International Business Machines Corporation. 2002, 2003
//*     All rights reserved.
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*--------------------------------------------------------------------
-->

<!-- 
  //*----
  //* @deprecated The Product Advisor feature has been deprecated. For more information, see <a href="../../../../../../com.ibm.commerce.productadvisor.doc/concepts/cpaintro.htm">Product Advisor</a>.
  //*----
-->

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@page import="	com.ibm.commerce.beans.DataBeanManager,
			com.ibm.commerce.tools.util.*,
			com.ibm.commerce.tools.common.ui.taglibs.*,
			com.ibm.commerce.tools.common.ui.taglibs.*,
			com.ibm.commerce.pa.tools.guidedsell.utils.GuidedSellUIConstants,
			java.util.Vector" %>
			
<%@ include file="/tools/guidedsell/GuidedSellCommon.jsp" %>

<%
	//StringBuffer buffer = new StringBuffer();
	String newButton = (String)guidedSellRB.get("newButton");
	String changeButton = (String)guidedSellRB.get("changeButton");
	String questionsButton = (String)guidedSellRB.get("questionsButton");
	String answersButton = (String)guidedSellRB.get("answersButton");
	String previewButton = (String)guidedSellRB.get("previewButton");
	String removeButton = (String)guidedSellRB.get("removeButton");
	String removeAllButton = (String)guidedSellRB.get("removeAllButton");
%>			

<HTML>
<HEAD>
 <%= fHeader %>
<HTML>
<HEAD>
<META name="GENERATOR" content="IBM WebSphere Studio">
<TITLE><%=guidedSellRB.get(GuidedSellUIConstants.GSQAT_BUTTONS_TITLE)%></TITLE>
</HEAD>
<BODY class="content">
<FORM name="buttonForm">
<TABLE CELLPADDING=0 CELLSPACING=1 BORDER=0>
	<TR>
		<TD ALIGN="LEFT" VALIGN="TOP">
			<TABLE CELLPADDING=2 CELLSPACING=0 BORDER=0>
				<TR>
					<TD class="button1" valign="middle">
						<BUTTON type="BUTTON" value="New" name="newButton" CLASS="enabled"  style="width: 
						135px;" onClick="if(this.className=='enabled')parent.newFunction();"><span class="buttonText"><%= newButton%></span></BUTTON>
					</TD>
				</TR>
			</TABLE>
		</TD>
	</TR>
	<TR>
		<TD ALIGN="LEFT" VALIGN="TOP">
			<TABLE CELLPADDING=2 CELLSPACING=0 BORDER=0>
				<TR>
					<TD class="button1" valign="middle">
						<BUTTON type="BUTTON" value="Change" name="changeButton" CLASS="disabled"  style="width: 
						135px;" onClick="if(this.className=='enabled')parent.changeFunction();"><span class="buttonText"><%= changeButton%></span></BUTTON>
					</TD>
				</TR>
			</TABLE>
		</TD>
	</TR>
	<TR>
		<TD ALIGN="LEFT" VALIGN="TOP">
			<TABLE CELLPADDING=2 CELLSPACING=0 BORDER=0>
				<TR>
					<TD class="button1" valign="middle">
						<BUTTON type="BUTTON" value="Questions" name="questionsButton" CLASS="enabled" style="width: 
						135px;" onClick="if(this.className=='enabled')parent.questions();"><span class="buttonText"><%= questionsButton%></span></BUTTON>
					</TD> 
				</TR>
			</TABLE>
		</TD>
	</TR>
	<TR>
		<TD ALIGN="LEFT" VALIGN="TOP">
			<TABLE CELLPADDING=2 CELLSPACING=0 BORDER=0>
				<TR>
					<TD class="button1" valign="middle">
						<BUTTON type="BUTTON" value="Answers" name="answersButton" CLASS="disabled" style="width: 
						135px;" onClick="if(this.className=='enabled')parent.answers();"><span class="buttonText"><%= answersButton%></span></BUTTON>
					</TD>
				</TR>
			</TABLE>
		</TD>
	</TR>
	<TR>
		<TD ALIGN="LEFT" VALIGN="TOP">
			<TABLE CELLPADDING=2 CELLSPACING=0 BORDER=0>
				<TR>
					<TD class="button1" valign="middle">
						<BUTTON type="BUTTON" value="Preview" name="previewButton" CLASS="enabled" style="width: 
						135px;" onClick="if(this.className=='enabled')parent.preview();"><span class="buttonText"><%= previewButton%></span></BUTTON>
					</TD>
				</TR>
			</TABLE>
		</TD>
	</TR>
	<TR>
		<TD ALIGN="LEFT" VALIGN="TOP">
			<TABLE CELLPADDING=2 CELLSPACING=0 BORDER=0>
				<TR>
					<TD class="button1" valign="middle">
						<BUTTON type="BUTTON" value="Remove" name="removeButton" CLASS="disabled" style="width: 
						135px;" onClick="if(this.className=='enabled')parent.removeFunction();"><span class="buttonText"><%= removeButton%></span></BUTTON>
					</TD>
				</TR>
			</TABLE>
		</TD>
	</TR>
	<TR>
		<TD ALIGN="LEFT" VALIGN="TOP">
			<TABLE CELLPADDING=2 CELLSPACING=0 BORDER=0>
				<TR>
					<TD class="button1" valign="middle">
						<BUTTON type="BUTTON" value="RemoveAll" name="removeAllButton" CLASS="disabled" style="width: 
						135px;" onClick="if(this.className=='enabled')parent.removeAllFunction();"><span class="buttonText"><%= removeAllButton%></span></BUTTON>
					</TD>
				</TR>
			</TABLE>
		</TD>
	</TR>
</TABLE>
</FORM>
</BODY>
</HTML>
