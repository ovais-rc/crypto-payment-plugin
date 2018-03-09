<!--
//********************************************************************
//*-------------------------------------------------------------------
//*Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright International Business Machines Corporation. 2002
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
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
<%@page language="java" 
	  import="	com.ibm.commerce.beans.DataBeanManager,
			com.ibm.commerce.tools.util.*,
			com.ibm.commerce.tools.common.ui.taglibs.*,
			com.ibm.commerce.tools.common.ui.taglibs.*,
			com.ibm.commerce.pa.tools.guidedsell.utils.GuidedSellUIConstants,
			java.util.Vector" %>

<%@include file="/tools/guidedsell/GuidedSellCommon.jsp" %>
<%!
	String name = "";
	String forChange = "";
	String fromPage = "";
%>
<%
	name = request.getParameter(GuidedSellUIConstants.GSMLL_METAPHOR_LINK_NAME);
	forChange = request.getParameter(GuidedSellUIConstants.GSMLL_FOR_CHANGE);
	fromPage = request.getParameter(GuidedSellUIConstants.GSMLL_FROM_PAGE);
%>
<SCRIPT LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/dynamiclist.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript">
<!--
function visibleList (s) {
	if (defined(this.document.forms[0])) {
		for (var i = 0; i < this.document.forms[0].elements.length; i++) {
			if (this.document.forms[0].elements[i].type.substring(0,6) == "select") {
				this.document.forms[0].elements[i].style.visibility = s;
			}
		}
	}
}

function getLinkName(){
	return '<%=UIUtil.toJavaScript(name)%>';
}

function loadForm(){
	top.showProgressIndicator(false);
}

function unLoadForm(){
	parent.setChecked(null);
	parent.setObjectArray(null);
}
//-->
</SCRIPT>
<%
	if(name.equals(GuidedSellUIConstants.QUESTION_CLASSNAME)) {
%>
	<%@include file="/tools/guidedsell/GuidedSellQuestionLinkList.jspf" %>
<%
	} else if(name.equals(GuidedSellUIConstants.PRODUCT_EXPLORER_METAPHOR_CLASSNAME) || 
			name.equals(GuidedSellUIConstants.PRODUCT_COMPARER_METAPHOR_CLASSNAME) || 
			name.equals(GuidedSellUIConstants.SALES_ASSISTANT_METAPHOR_CLASSNAME)) {
%>
	<%@include file="/tools/guidedsell/GuidedSellMetaphorLinkList.jspf" %>
<%
	} else if(name.equals(GuidedSellUIConstants.GSMLL_NO_LINK)){
%>
	<%@include file="/tools/guidedsell/GuidedSellNoLink.jspf" %>	
<%
	} else if(name.equals(GuidedSellUIConstants.GSMLL_URL)) {
%>
	<%@include file="/tools/guidedsell/GuidedSellLinkToURL.jspf" %>
<%
	} else if(name.equals(GuidedSellUIConstants.GSMLL_PRODUCT_PAGE)){
%>
	<%@include file="/tools/guidedsell/GuidedSellLinkToProduct.jspf" %>
<%
	}
%>
