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
<%@page language="java" import="com.ibm.commerce.beans.DataBeanManager,
	com.ibm.commerce.pa.tools.guidedsell.utils.GuidedSellUIConstants,
	com.ibm.commerce.pa.tools.guidedsell.containers.GuidedSellData,
	com.ibm.commerce.pa.tools.guidedsell.beans.GuidedSellListDataBean,
	com.ibm.commerce.server.ECConstants,
      com.ibm.commerce.tools.util.*,
	com.ibm.commerce.tools.xml.XMLUtil,
	com.ibm.commerce.tools.common.ui.taglibs.*,
	com.ibm.commerce.tools.common.ui.UIProperties,
	java.util.Hashtable,
	java.util.Vector" %>

<%@include file="/tools/guidedsell/GuidedSellCommon.jsp" %>

<%
	GuidedSellListDataBean gsldb = new GuidedSellListDataBean();
	DataBeanManager.activate(gsldb,request);
	int numberOfCategories = 0;

	Vector dataVector = gsldb.getGuidedSellData();
	if(dataVector != null && !dataVector.isEmpty()){
		numberOfCategories = dataVector.size();
	}

	String storeId = gsldb.getStoreId().toString();
	String langId = gsldb.getLanguageId().toString();
%>

<HTML>
<HEAD>
<%= fHeader%>
<TITLE><%= guidedSellRB.get(GuidedSellUIConstants.GSL_TITLE) %></TITLE>
<SCRIPT LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/dynamiclist.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/guidedsell/gscommon.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" >
<!-- hide script from old browsers -->
function myRefreshButtons(){
	parent.refreshButtons();
	var checked = parent.getChecked().toString();
	var params = checked.split(';');
	var pstatus = params[1];
	if(pstatus == 'true'){
		disableButton(parent.buttons.buttonForm.publishButtonButton);
	}
	if(pstatus == 'false'){
		disableButton(parent.buttons.buttonForm.unpublishButtonButton);
	}
}

function newGuidedSell(){
	var url = "/webapp/wcs/tools/servlet/WizardView?XMLFile=guidedSell.GuidedSellWizard";
	url +=  "&<%=GuidedSellUIConstants.GS_CATEGORY_ID%>="; 
	url +=  "&<%=GuidedSellUIConstants.GS_METAPHOR_ID%>=";
	url +=  "&<%=GuidedSellUIConstants.GS_TREE_ID%>=";
	url +=  "&<%=GuidedSellUIConstants.GS_CONCEPT_ID%>=";
	url +=  "&<%=GuidedSellUIConstants.GS_LANGUAGE_ID%>=<%=langId%>";
	url +=  "&<%=GuidedSellUIConstants.GSMLL_FROM_PAGE%>=<%=GuidedSellUIConstants.GSMLL_FROM_NEW_CHANGE_CATEGORY%>";
	url +=  "&<%=GuidedSellUIConstants.GSMLL_FOR_CHANGE%>=false";

	if (top.setContent)
      {
        top.setContent("<%=getNLString(guidedSellRB,GuidedSellUIConstants.GSL_NEW_GUIDED_SELL)%>",url,true);
      }
      else
      {
        parent.location.replace(url);
      }
}

function changeGuidedSell(){
	var checked = parent.getChecked().toString();
	var params = checked.split(';');
	var metaphorId = params[0];
	var categoryId = params[2];
	var catName = params[3];
	var treeId = params[4];
	var url = "/webapp/wcs/tools/servlet/DialogView?XMLFile=guidedSell.GuidedSellLinkDialog";
	url += "&<%=GuidedSellUIConstants.GS_CATEGORY_ID%>="+categoryId;
	url += "&<%=GuidedSellUIConstants.GS_METAPHOR_ID%>="+metaphorId;
	url += "&<%=ECConstants.EC_STORE_ID%>="+'<%=storeId%>';
	url += "&<%=GuidedSellUIConstants.GS_LANGUAGE_ID%>="+'<%=langId%>';
	url += "&<%=GuidedSellUIConstants.GS_TREE_ID%>="+treeId;
	url += "&<%=GuidedSellUIConstants.GSMLL_FROM_PAGE%>=<%=GuidedSellUIConstants.GSMLL_FROM_NEW_CHANGE_CATEGORY%>";
	url += "&<%=GuidedSellUIConstants.GSMLL_FOR_CHANGE%>=true";
	if (top.setContent) {
		top.setContent("<%=getNLString(guidedSellRB,GuidedSellUIConstants.GSL_CHANGE_GUIDED_SELL)%>", url, true);
	} else {
		parent.location.replace(url);
	}
}

function searchCategories(){
    var url = "/webapp/wcs/tools/servlet/DialogView?XMLFile=productAdvisor.CreateSearchSpace";
	url += "&<%=ECConstants.EC_STORE_ID%>="+"<%= gsldb.getStoreId().toString() %>";
	url += "&<%=ECConstants.EC_LANGUAGE_ID%>="+"<%=gsldb.getLanguageId().toString()%>";

    if (top.setContent)     {
      top.setContent("<%= UIUtil.toJavaScript( (String)guidedSellRB.get(GuidedSellUIConstants.GSL_SEARCH_CATEGORY_BUTTON_TEXT )) %>", url, true);
    }    else     {
	parent.location.replace(url);
    }
}
function qnaTree(){
	top.put("pathId",null);
	var checked = parent.getChecked().toString();
	var params = checked.split(';');
	var metaphorId = params[0];
	var categoryId = params[2];
	var catName = params[3];
	var treeId = params[4];

	var catalogId = params[7];
	if(catalogId != 'NULL'){
		top.put("catalogId",catalogId);
	}
	
	top.put("categoryName",catName);

//	var url="/webapp/wcs/tools/servlet/NewDynamicListView?ActionXMLFile=guidedSell.GuidedSellTreeMain&cmd=GSTreeMainView";
	var url="/webapp/wcs/tools/servlet/GSTreeMainView";
//	url += "&<%=GuidedSellUIConstants.GS_CATEGORY_ID%>="+categoryId;
	url += "?<%=GuidedSellUIConstants.GS_CATEGORY_ID%>="+categoryId;
	url += "&<%=GuidedSellUIConstants.GS_METAPHOR_ID%>="+metaphorId;
	url += "&<%=ECConstants.EC_STORE_ID%>="+'<%=storeId%>';
	url += "&<%=GuidedSellUIConstants.GS_LANGUAGE_ID%>="+'<%=langId%>';
	url += "&<%=GuidedSellUIConstants.GS_TREE_ID%>="+treeId;

	if (top.setContent)     {
      	top.setContent(catName+" - <%= getNLString(guidedSellRB,GuidedSellUIConstants.GSL_Q_AND_A_TREE_BUTTON_TEXT) %>",url, true);
	}    else     {
		parent.location.replace(url);
    }
}

function publish(){
	if(isButtonDisabled(parent.buttons.buttonForm.publishButtonButton)){
		return;
	}
	var checked = parent.getChecked().toString();
	var params = checked.split(';');
	var metaphorId = params[0];
	var categoryId = params[2];
	var p = new Object();
	p['metaphorId']=metaphorId;
	p['categoryId']=categoryId;
	p['publish']="true";
	top.showContent('/webapp/wcs/tools/servlet/GSPublishDeleteCmd',p);
}

function unpublish(){
	if(isButtonDisabled(parent.buttons.buttonForm.unpublishButtonButton)){
		return;
	}
	var checked = parent.getChecked().toString();
	var params = checked.split(';');
	var metaphorId = params[0];
	var categoryId = params[2];
	var p = new Object();
	p['metaphorId']=metaphorId;
	p['categoryId']=categoryId;
	p['publish']="false";
	top.showContent('/webapp/wcs/tools/servlet/GSPublishDeleteCmd',p);
}

function deleteGuidedSell(){
	var selected = confirmDialog("<%=getNLString(guidedSellRB,GuidedSellUIConstants.GSL_DELETE_CONFIRM)%>");
	if(selected){
		var checked = parent.getChecked();
		var clength = checked.length;
		var p = new Object();
		p['metaphorId']=metaphorId;
		p['numberOfCategories']=clength;
		p['delete']="true";
		for(var i=0;i<clength;i++){
			var params = checked[i].split(';');
			var metaphorId = params[0];
			var categoryId = params[2];
			p['categoryId_'+i]= categoryId;
		}
		top.showContent('/webapp/wcs/tools/servlet/GSPublishDeleteCmd',p);
	}
}

function onLoad(){
	top.remove("pathId");
	parent.loadFrames();
}

</SCRIPT>
</HEAD>
<BODY ONLOAD="onLoad()" class="content">
<%
	String orderByParm = request.getParameter(GuidedSellUIConstants.GS_ORDER_BY);
	int rowselect = 1;
%>
	<FORM NAME="guidedSellForm" >
	<%= comm.startDlistTable("guidedSellListSummary") %>
	<%= comm.startDlistRowHeading() %>
	<%= comm.addDlistCheckHeading(true,"parent.selectDeselectAll();myRefreshButtons()") %>
	<%= comm.addDlistColumnHeading((String)guidedSellRB.get(GuidedSellUIConstants.GSL_CATEGORY_NAME), GuidedSellUIConstants.GSL_ORDER_BY_NAME, GuidedSellUIConstants.GSL_ORDER_BY_NAME.equals(orderByParm),null,false) %>
	<%= comm.addDlistColumnHeading((String)guidedSellRB.get(GuidedSellUIConstants.GSL_CATEGORY_DESCRIPTION), GuidedSellUIConstants.GSL_ORDER_BY_DESCRIPTION, GuidedSellUIConstants.GSL_ORDER_BY_DESCRIPTION.equals(orderByParm),null,false) %>
	<%= comm.addDlistColumnHeading((String)guidedSellRB.get(GuidedSellUIConstants.GSL_CATEGORY_SEARCH_CATEGORY), GuidedSellUIConstants.GSL_ORDER_BY_SEARCH_CATEGORY, GuidedSellUIConstants.GSL_ORDER_BY_SEARCH_CATEGORY.equals(orderByParm),null,false) %>
	<%= comm.addDlistColumnHeading((String)guidedSellRB.get(GuidedSellUIConstants.GSL_CATEGORY_STATUS), GuidedSellUIConstants.GSL_ORDER_BY_STATUS, GuidedSellUIConstants.GSL_ORDER_BY_STATUS.equals(orderByParm),null,false) %>
	<%= comm.endDlistRow() %>
	<%
		GuidedSellData data = null;
		for (int i=0; i<numberOfCategories; i++) {
			data = (GuidedSellData)dataVector.elementAt(i);
	%>
		<%= comm.startDlistRow(rowselect) %>
		<%= comm.addDlistCheck(data.getMetaphorId()+";"+data.isPublished()+";"+data.getCategoryId()+";"+data.getName()+";"+data.getTreeId()+";"+data.isRootQuestion()+";"+data.isSearchSpaceExists()+";"+data.getCatalogId(),"parent.setChecked();myRefreshButtons()") %>
		<%= comm.addDlistColumn(UIUtil.toHTML(data.getName()), "none") %>
		<%= comm.addDlistColumn(UIUtil.toHTML(data.getDescription()), "none") %>
		<%= comm.addDlistColumn(UIUtil.toHTML(data.getSearchSpaceStatus()), "none") %>
		<%= comm.addDlistColumn(UIUtil.toHTML(data.getStatus()), "none") %>
		<%= comm.endDlistRow() %>
	<%
			if (rowselect == 1) {
				rowselect = 2;
			}
			else {
				rowselect = 1;
			}
		}
	%>
	<%= comm.endDlistTable() %>
	<%
		if(numberOfCategories == 0){
	%>
		<P><P>
		<%= guidedSellRB.get(GuidedSellUIConstants.GSL_EMPTY) %>		
	<%
		}
	%>
	</FORM>
<SCRIPT LANGUAGE="JavaScript" >
<!--
parent.afterLoads();
//-->
</SCRIPT>
</BODY>
</HTML>
