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


<%@ page language="java"
		import="com.ibm.commerce.tools.util.*,
			com.ibm.commerce.tools.common.ui.taglibs.*,
			com.ibm.commerce.pa.tools.guidedsell.utils.GuidedSellUIConstants,
			java.util.Vector"			
 %>


<%@ include file= "/tools/guidedsell/GuidedSellCommon.jsp" %>

<%
	String urlCatalogTree="/webapp/wcs/tools/servlet/DynamicTreeView?XMLFile=guidedSell.GuidedSellCatalogTree";
%> 

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
<HTML>
<HEAD>
<TITLE><%=guidedSellRB.get(GuidedSellUIConstants.GSW_CATEGORY_TITLE_NAME)%></TITLE>
<%= fHeader%>
<SCRIPT LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/guidedsell/gscommon.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/guidedsell/gstree.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/guidedsell/gscategorytree.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript">
<!-- 
function initForm(){
	var title = "<span id='select_title' style='position: absolute; height: 30px; font-size: 16pt; font-family : Times New Roman, Times, serif;'>";
	title += "<%=getNLString(guidedSellRB,GuidedSellUIConstants.GSW_NEW_TITLE_NAME)%>";
	title += "</span>";
	blankpage.document.writeln("<html><head>");
	blankpage.document.writeln("<%=fHeader%>");
	blankpage.document.writeln("</head>");
	blankpage.document.writeln("<body class='content'>");
	blankpage.document.writeln(title);
	blankpage.document.writeln("</body></html>");
	displayPathNew();
	parent.setContentFrameLoaded(true);
   	setTimeout("stopProgress()", minDelay);
}

function validatePanelData(){
	
	var param = getNodeParameterNew();
	if(param == null || param.length == 0){
		alertDialog("<%= UIUtil.toJavaScript((String)guidedSellRB.get(GuidedSellUIConstants.GSCT_NO_NODE_SELECTED))%>");
		return false;
	}

	if(param == 'root'){
		alertDialog("<%= UIUtil.toJavaScript((String)guidedSellRB.get(GuidedSellUIConstants.GSCT_NO_CATEGORY_SELECTED))%>");
		return false;
	} else {
		var canCreateGS = getCanCreateGS(param);
		if(!canCreateGS){
			alertDialog("<%= UIUtil.toJavaScript((String)guidedSellRB.get(GuidedSellUIConstants.GSCT_NO_CATEGORY_SELECTED_FOR_STORE))%>");	
			return false;
		}
		var gsexists=isGuidedSellExists(param);

		if(gsexists) {
			alertDialog("<%= UIUtil.toJavaScript((String)guidedSellRB.get(GuidedSellUIConstants.GSCT_GS_EXISTS))%>");
			return false;
		} else {
			return true;
		}
	}
}

function unloadForm(){

}

function savePanelData() {
	var param = getNodeParameterNew();    
	var guidedSellCategoryId = getGuidedSellCategory(param);
	parent.put("newGuidedSellCategoryId",guidedSellCategoryId);
	
}

var minDelay = 10;
function stopProgress () 
{
     setTimeout("stopProgress()", minDelay);
     top.showProgressIndicator ( false );
}

// -->
</SCRIPT>
</HEAD>
<FRAMESET ROWS="15%,*" BORDER=0 ONLOAD="initForm();" onUnload="saveHighLightedPathNew();">
      <FRAME NAME="blankpage" SRC="/wcs/tools/common/blank.html" FRAMEBORDER="0" BORDER="0"  NORESIZE SCROLLING="no" title="<%=guidedSellRB.get(GuidedSellUIConstants.GS_CATALOG_TREE_TITLE_FRAME)%>">
      <FRAME NAME="gsframe" SRC="<%=urlCatalogTree%>" FRAMEBORDER="0" BORDER="0" NORESIZE SCROLLING="auto" title="<%=guidedSellRB.get(GuidedSellUIConstants.GS_CATALOG_TREE_FRAME)%>">
</FRAMESET>
</HTML>

