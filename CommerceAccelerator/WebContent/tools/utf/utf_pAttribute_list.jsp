<!-- 
========================================================================
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2001, 2016
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//* MS
//*-------------------------------------------------------------------
 ===========================================================================
-->

<%@ page import="java.text.*"  %> 
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.server.*" %>
<%@ page import="com.ibm.commerce.tools.common.ui.taglibs.*" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.utf.beans.*" %>
<%@ page import="com.ibm.commerce.utf.helper.*" %>
<%@ page import="com.ibm.commerce.utf.objects.*" %>
<%@ page import="com.ibm.commerce.utf.utils.*" %>

<%@ include file="../common/common.jsp" %>

<%
	CommandContext cmdContext = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
	Locale jLocale = cmdContext.getLocale();
	Hashtable utfNLS = (Hashtable)ResourceDirectory.lookup("utf.utfNLS", jLocale);
	JSPHelper jspHelper = new JSPHelper(request);

	int startIndex = Integer.parseInt(request.getParameter("startindex"));
	int listSize = Integer.parseInt(request.getParameter("listsize"));
	int endIndex = startIndex + listSize;
   	String   lang =  "-1";
%>

<jsp:useBean id="tempList" class="com.ibm.commerce.utf.beans.PAttributeListBean" >
     <jsp:setProperty property="*" name="tempList" />
</jsp:useBean>

<%
	String  StoreId = "0";
   	Locale   aLocale = null;

   	if( cmdContext != null ){
	  lang = cmdContext.getLanguageId().toString();
        StoreId = cmdContext.getStoreId().toString();
        aLocale = cmdContext.getLocale();
   	}
		
	/* SORTING */
	/* for available sort columns, see com.ibm.commerce.utf.helper.PAttributeTable  */

	String orderby = jspHelper.getParameter("orderby");
	if(!orderby.equals("none") ){
		try{
		PAttributeSortingAttribute sort = new PAttributeSortingAttribute();
		sort.addSorting(orderby, true);
           	tempList.setSortAtt(sort);


		} catch (Exception e){ ; }
	}
	boolean nameSort = false;
	if (orderby.equals("NAME") ){
		nameSort = true;
	}

	com.ibm.commerce.beans.DataBeanManager.activate(tempList, request);


	int rowselect = 1;

      com.ibm.commerce.beans.DataBeanManager.activate(tempList, request);
      com.ibm.commerce.utf.beans.PAttributeDataBean [] aList = tempList.getPAttributes();
	int length = aList.length;
	if (endIndex > length){
		endIndex = length;
	}
		
	int totalsize = length;
	int totalpage = totalsize/listSize;
		 
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<link rel="stylesheet" href="<%= UIUtil.getCSSFile(jLocale) %>" type="text/css" />
<title><%= utfNLS.get("utf_entryList") %></title>
<script type="text/javascript" src="/wcs/javascript/tools/common/dynamiclist.js"></script>
<script type="text/javascript" src="/wcs/javascript/tools/common/Util.js"></script>

<script type="text/javascript">
function onLoad(){
	parent.loadFrames();
}

function getNewEntryBCT(){
	return "<%= utfNLS.get("utf_CreateEntry") %>";
}
function getEditAttributeBCT() {
	return "<%= utfNLS.get("utf_changeAttribue") %>";
}

function performDelete() {
	if (confirmDialog("<%= utfNLS.get("utf_confirmDelete") %>")) {
		document.kForm.attr_id.value = getAttrId();
		document.kForm.listsize.value="<%= listSize %>";
		document.kForm.selected.value=parent.getChecked();
		document.kForm.startindex.value = "<%= startIndex %>";
		document.kForm.refnum.value = "0";
		document.kForm.language_id.value = "<%= lang %>";
		document.kForm.orderby.value = "NAME";
		document.kForm.action = "PAttributeDelete";
		document.kForm.ActionXMLFile.value = "utf.pAttributeList";
		document.kForm.cmd.value = "PAttributeList";
		document.kForm.submit();
		parent.location.reload();
	}
}

function CreatepAttribute() {
	top.setContent(getNewEntryBCT(),top.getWebPath() + 'DialogView?XMLFile=utf.newpAttributeEntry',true);
}

function ChangepAttribute(){
	var checkedEntries = parent.getChecked();
   	top.setContent(getEditAttributeBCT(),top.getWebPath() + 'DialogView?XMLFile=utf.pAttrNotebook&amp;attr_id='+checkedEntries[0], true);     
}

function getAttrId() {
	var tempval = parent.getChecked();
	var attrIds = "";
	for (i=0;i<tempval.length;i++) {
		var selval = tempval[i].split(",");
		if (attrIds != "")
		{
			attrIds += ",";
		}
		attrIds += selval[0];
	}
	
	return attrIds;
}

</script>
</head>

<body class="content_list">
<script type="text/javascript"><!--
// For IE
if (document.all) {
	var aTemp = onLoad();
}
//-->
</script>
<form name="kForm" action="">

<input type="hidden" name="ProfileName" value="" />
<input type="hidden" name="attr_id" value="" />
<input type="hidden" name="listsize" value="" />
<input type="hidden" name="selected" value="" />
<input type="hidden" name="startindex" value="" />
<input type="hidden" name="refnum" value="" />
<input type="hidden" name="language_id" value="" />
<input type="hidden" name="orderby" value="" />
<input type="hidden" name="ActionXMLFile" value="" />
<input type="hidden" name="cmd" value="" />

 <%=comm.addControlPanel("utf.pAttributeList",totalpage,totalsize,jLocale)%> 
					
<%-- THIS IS THE HEADER ROW OF THE TABLE --%>
	<%= comm.startDlistTable((String)utfNLS.get("utf_pAttrList")) %>
	<%= comm.startDlistRowHeading() %>
	<%= comm.addDlistCheckHeading() %>
	<%= comm.addDlistColumnHeading((String)utfNLS.get("name"),PAttributeTable.NAME,nameSort,"35%" ) %>
	<%= comm.addDlistColumnHeading((String)utfNLS.get("description"),null,false,"35%" ) %>
	<%= comm.addDlistColumnHeading((String)utfNLS.get("attrdatatype"),PAttributeTable.ATTRTYPE_ID,!nameSort,"30%" ) %>
	<%= comm.endDlistRow() %>

<%
   	PAttributeDataBean aPAttr = null;
	
	for (int i = startIndex; i < endIndex; i++){

		aPAttr = aList[i];
		String pAttribute_id = aPAttr.getReferenceNumber();
		String pAttribute_name = UIUtil.toHTML(aPAttr.getName());
		//String pAttribute_desc = aPAttr.getDescription();
		String pAttribute_AttrType = aPAttr.getAttrTypeId();
		String adesc=null;
			try{
		   		PAttributeDescDataBean pAttrdesc = new PAttributeDescDataBean();
		   		pAttrdesc.setInitKey_pattributeId(pAttribute_id);                
		   		pAttrdesc.setInitKey_langId(lang);
		   		adesc = UIUtil.toHTML(pAttrdesc.getShortDesc());                          
 		   		}
                catch (Exception e) {}
	
%>
	<%-- PUT DATA INTO A TABLE ROW --%>
	<%= comm.startDlistRow(rowselect) %>
	<%= comm.addDlistCheck( pAttribute_id,"none" ) %>
	<%= comm.addDlistColumn( pAttribute_name,"none") %>
 	<%= comm.addDlistColumn( adesc,"none") %> 
	<%= comm.addDlistColumn( pAttribute_AttrType,"none") %>
	<%= comm.endDlistRow() %>

<%
		if ( rowselect == 1 )
			rowselect = 2;
		else
			rowselect = 1;
	}//end for
%>


<%-- THIS ENDS THE TABLE --%>

	<%= comm.endDlistTable() %>
<%
	if ( length < 1 ){
%>
	<%= utfNLS.get("utf_emptyAttributeList") %>
<%
	}//end if
%>

</form>
<script type="text/javascript"><!--
	parent.afterLoads();
	parent.setResultssize(<%= length %>); // total

//-->
</script>

</body>
</html>
