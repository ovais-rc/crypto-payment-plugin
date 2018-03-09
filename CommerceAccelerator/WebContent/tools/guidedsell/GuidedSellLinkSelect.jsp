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
			com.ibm.commerce.pa.tools.guidedsell.beans.GuidedSellLinkSelectBean,
			java.util.Vector" %>

<%@include file="/tools/guidedsell/GuidedSellCommon.jsp" %>

<%
	String metaphorLinkName = request.getParameter(GuidedSellUIConstants.GSMLL_METAPHOR_LINK_NAME);
	GuidedSellLinkSelectBean gsmlsb = new GuidedSellLinkSelectBean();
	DataBeanManager.activate(gsmlsb,request);
	Vector linkTypes = gsmlsb.getLinkTypes();
	Vector linkNames = gsmlsb.getLinkNames();
	Vector linkAddresses = gsmlsb.getLinkAddresses();
	int length = linkNames.size();
%>

<HTML>
<HEAD>
 <%= fHeader %>
<TITLE><%=guidedSellRB.get(GuidedSellUIConstants.GSMLL_SELECT_LINK)%></TITLE>
<script language="javascript">
<!--
function visibleList(s){
   if (this.linkSelectFrom.listSelect)
   {
      this.linkSelectFrom.listSelect.style.visibility = s;
   }
}
//-->
</script>
</HEAD>
<BODY class="content" >
<span id="select_title" style="position: absolute; height: 30px; font-size: 16pt; font-family : Times New Roman, Times, serif;"></span><br>
<span id="select_text"  style="position: absolute; top: 31px; height: 11px; font-size: 9pt; "></span><br>
<script>
   <!--
      if(parent.gsframe.getUserNLSTitle)
          this.document.all("select_title").innerHTML=parent.gsframe.getUserNLSTitle();
      else if (parent.getUserNLSTitle)
          this.document.all("select_title").innerHTML=parent.getUserNLSTitle();

      if(parent.getInstruction)
          this.document.all("select_text").innerHTML=parent.getInstruction();

   //-->
</script>

<FORM NAME="linkSelectFrom" OnSubmit="return false;">
<label id="link_select" for="link_select_list"></label>
<script>
   <!--
      if(parent.gsframe.getLinkSelectText)
		this.document.all("link_select").innerHTML=parent.gsframe.getLinkSelectText();
	else if(parent.getLinkSelectText)
		this.document.all("link_select").innerHTML=parent.getLinkSelectText();
	
   //-->
</script>
	<SELECT id="link_select_list" name="listSelect" onChange="parent.linkListSelect(this)">
	<%
		for(int i=0;i<length;i++) {
			String type = (String)linkTypes.elementAt(i);
			String name = (String)linkNames.elementAt(i);
			String address = (String)linkAddresses.elementAt(i);
			if(type.equals(metaphorLinkName)){
	%>
			<option value="<%=address%>" selected><%=toHTML(name)%></option>
	<%
			} else {
	%>
			<option value="<%=address%>" ><%=toHTML(name)%></option>
	<%
			}
		}
	%>
	</SELECT>
</FORM>
</BODY>
</HTML>
