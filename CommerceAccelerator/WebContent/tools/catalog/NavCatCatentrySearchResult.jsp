<!--
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2003, 2017
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
-->
<%@ page language="java" %>

<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.base.objects.ServerJDBCHelperBean" %>
<%@ page import="com.ibm.commerce.catalog.objects.*" %>
<%@ page import="com.ibm.commerce.catalog.beans.*" %>
<%@ page import="com.ibm.commerce.common.helpers.StoreUtil" %>
<%@ page import="com.ibm.commerce.tools.common.ui.taglibs.*" %>
<%@ page import="com.ibm.commerce.server.ECConstants" %>
<%@include file="../common/common.jsp" %>

<%@include file="CatalogSearchUtil.jsp" %> 


<%
try{
	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	// Get the command context 
	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	CommandContext cmdContext = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
	Hashtable rbProduct  = (Hashtable) ResourceDirectory.lookup("catalog.ProductNLS", cmdContext.getLocale());
	Hashtable rbCatalog = (Hashtable) ResourceDirectory.lookup("catalog.CatalogNLS", cmdContext.getLocale());
	Hashtable commonNLS = (Hashtable)ResourceDirectory.lookup("common.listNLS", cmdContext.getLocale());
	
	com.ibm.commerce.server.JSPHelper jspHelper = new com.ibm.commerce.server.JSPHelper(request);

	String strStartIndex    = jspHelper.getParameter("startIndex"); 
	String strListSize		= jspHelper.getParameter("listsize");
	String strOrderByParam  = jspHelper.getParameter("orderby");

	//if (strStartIndex == null)  strStartIndex  = "0";
	//if (strListSize == null)  strListSize="20";
	//if (strOrderByParam == null) strOrderByParam = "SKU";
	
	int nNumOfRowsPage = 0;
	int	nNumOfRowsTotal= Integer.parseInt(catEntrySearchDB.getResultCount());
	int nListSize = Integer.parseInt(strListSize);
	int nStartIndex = Integer.parseInt(strStartIndex);

	int numofpage = (nStartIndex/nListSize)+1;
	int totalPage = (nNumOfRowsTotal+nListSize-1)/nListSize;
	
	CatalogEntryDataBean arrayDbCatentry[] = catEntrySearchDB.getResultList();
	if(arrayDbCatentry!=null)
		nNumOfRowsPage=arrayDbCatentry.length;

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
<HTML>
<HEAD>
	<LINK rel=stylesheet href="<%= UIUtil.getCSSFile(cmdContext.getLocale()) %>" type="text/css">

	<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
	<SCRIPT SRC="/wcs/javascript/tools/catalog/NavCatCommonFunctions.js"></SCRIPT>
	<SCRIPT SRC="/wcs/javascript/tools/common/dynamiclist.js"></SCRIPT>

<SCRIPT>
	function onLoad () 
	{
		if (getTableSize(NavCatSourceProductList) == 0) 
		{
			divEmpty.innerHTML = "<BR><%=UIUtil.toJavaScript((String)rbCatalog.get("NavCatCatentrySearchResult_Empty"))%>";
			divEmpty.style.display = "block";
		}
		
		setChecked();
	}

	function setChecked()
	{
		var count = getNumberOfChecks(NavCatSourceProductList);
		parent.catentrySearchResultButtonsFrame.setButtons(count);
		setCheckHeading(NavCatSourceProductList, (count == getTableSize(NavCatSourceProductList)));
	}

	function selectDeselectAll()
	{
		setAllRowChecks(NavCatSourceProductList, event.srcElement.checked);
		parent.catentrySearchResultButtonsFrame.setButtons(getNumberOfChecks(NavCatSourceProductList));
	}

	//////////////////////////////////////////////////////////////////////////////////////
	// addButton() 
	//
	// - this function determs which products have been selected and adds them to the
	//   target category
	//////////////////////////////////////////////////////////////////////////////////////
	function addButton()
	{
		var obj = new Object();
		obj.catalogId  = parent.currentTargetDetailCatalog;
		obj.categoryId = parent.currentTargetTreeElement.id;
		obj.products   = new Array();

		for (var i=1; i<NavCatSourceProductList.rows.length; i++)
		{
			if (getChecked(NavCatSourceProductList, i))
			{
				var product = new Object;
				product.catentryId = getCheckBoxId(NavCatSourceProductList, i);
				product.sequence   = "0.0";
				obj.products[obj.products.length] = product;
			}
		}

		parent.workingFrame.submitFunction("NavCatAddProductRelationsControllerCmd", obj);
	}

	//////////////////////////////////////////////////////////////////////////////////////
	// refresh(value)
	//
	// @param value - value is a field that can be used to determine redirect logic
	//
	// - this function is called to reload the frame
	//////////////////////////////////////////////////////////////////////////////////////
	function refresh(value)
	{
		if (value == "none") mySort("<%=strOrderByParam%>");
		else if (value == "close") parent.hideSourceProducts();
		else mySort(value);
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// mySort(value)
	//
	// @param value - the order by value to sort against
	//
	// - this function reloads the page to sort by the requested sort feature
	//////////////////////////////////////////////////////////////////////////////////////
	function mySort(value)
	{
		parent.catentrySearchFrame.searchParam.orderby=value;
		parent.setCatentrySearchResults(parent.catentrySearchFrame.searchParam);
	}
	
	var numofpage = <%=numofpage%>;
	
	//////////////////////////////////////////////////////////////////////////////////////
	// prevButton() 
	//
	// - this function is called when selecting the prev page of results
	//////////////////////////////////////////////////////////////////////////////////////
	function prevButton()
	{
		parent.catentrySearchFrame.searchParam.startIndex="<%=nStartIndex-nListSize%>";
		refresh("none");
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// nextButton() 
	//
	// - this function is called when selecting the next page of results
	//////////////////////////////////////////////////////////////////////////////////////
	function nextButton()
	{
		parent.catentrySearchFrame.searchParam.startIndex="<%=nStartIndex+nListSize%>";
		refresh("none");
	}

</SCRIPT>

<STYLE TYPE='text/css'>
TR.list_row_lock { background-color: ButtonFace; height: 20px; word-wrap: break-word; }
</STYLE>

</HEAD>

<BODY ONLOAD="onLoad()" CLASS="content" ONCONTEXTMENU="return false;">

<b> 
<%=UIUtil.toHTML((String)rbCatalog.get("NavCatCatentrySearchResult_Title"))%>
</b>
<BR>

<%
if (totalPage > 1)
{
%>
	<table id="CP_table" cellspacing=0 cellspacing=0 border=0 width="100%" style="position:absolute;">
		<tr>
			<td align="right" id="control_panel_navigate">
				<table id=idTable1 cellspacing=0 cellspacing=0 border=0>
					<tr>
<%
	if (numofpage > 1)
	{
%>
						<td id="control_panel_prev_but1"><A HREF="#" onClick="javascript: prevButton(); return false;"><img src="/wcs/images/tools/newlist/previous.gif" width="12" height="12" border="0" alt="<%=UIUtil.toHTML((String)commonNLS.get("prev"))%>"></A></td>
						<td id="control_panel_prev_but2"><class="item"><A HREF="#" onClick="javascript: prevButton(); return false;"><%=UIUtil.toHTML((String)commonNLS.get("prev"))%></A></td>
						<td id="control_panel_prev_but3"><img src="/wcs/images/tools/newlist/divide.gif" width="1" height="13" border="0" alt=""></td>
<%
	}

	String specialDisplay = (String)commonNLS.get("specialPageDisplay");
	specialDisplay = Util.replace( specialDisplay, "%P", "<b><SPAN id=numofpage>"+numofpage+"</SPAN></b>" );
	specialDisplay = Util.replace( specialDisplay, "%T", "<SPAN id=totalpage>"+totalPage+"</SPAN>" );
%>
						<td id=idtable1_td1 class="scroll">&nbsp;<%=specialDisplay%>&nbsp;</td>
<%
	if (numofpage < totalPage)
	{
%>
						<td id=idtable1_td2><img src="/wcs/images/tools/newlist/divide.gif" width="1" height="13" border="0" alt=""></td>
						<td id="control_panel_next_but1"><class="item"><A HREF="#" onClick="javascript: nextButton(); return false;"><%=UIUtil.toHTML((String)commonNLS.get("next"))%></A></td>
						<td id="control_panel_next_but2"><A HREF="#" onClick="javascript: nextButton(); return false;"><img src="/wcs/images/tools/newlist/next.gif" width="12" height="12" border="0" alt="<%=UIUtil.toHTML((String)commonNLS.get("next"))%>"></A></td>
<%
	}
%>
					</tr>
				</table>
			</td>
		</tr>
	</table>

	<BR>
<%
}
%>

<BR>
<SCRIPT>
	parent.sortImgMsg = "<%=UIUtil.toJavaScript((String)rbCatalog.get("NavCatSortMsg"))%>";
	
	startDlistTable("NavCatSourceProductList", "100%");
	startDlistRowHeading();
	addDlistCheckHeading(true, "selectDeselectAll()");
	addDlistColumnHeading("&nbsp;",                                                                        false, "18px", "CatEntryType", <%=strOrderByParam.equals("CatEntryType")%>, "mySort");
	addDlistColumnHeading("<%=UIUtil.toJavaScript((String)rbCatalog.get("NavCatTargetProducts_Code"))%>", true,  "null", "SKU",    <%=strOrderByParam.equals("SKU")%>, "mySort");
 	endDlistRow();
	
<%
	int rowselect  = 0;
	long lStoreMemberId=cmdContext.getStore().getMemberIdInEntityType().longValue();
	
	for (int i=0; i<nNumOfRowsPage; i++)
	{
		CatalogEntryDataBean dbCatentry = (CatalogEntryDataBean) arrayDbCatentry[i];
		dbCatentry.setCommandContext(cmdContext);
		
		String strType=dbCatentry.getType();
			
		String strCatentryId= dbCatentry.getCatalogEntryReferenceNumber();	
		String strPartNumber = dbCatentry.getPartNumber();
		//String strName = getName(dbCatentry);								//SearchUtil
		//String strShotDesc = getShortDescription(dbCatentry);				//SearchUtil

%>
		<% if(dbCatentry.getMemberIdInEntityType().longValue()==lStoreMemberId) { %>
			startDlistRow(<%=rowselect+1%>);
		<%} else {%>	
			startDlistRow("_lock");
		<%}%>
		
		addDlistCheck( "<%=strCatentryId%>", "setChecked()", "<%=strCatentryId%>" );
		addDlistColumn( parent.elementType("<%=strType%>"), "none", "text-align:center;" );
		addDlistColumn( changeJavaScriptToHTML("<%=UIUtil.toJavaScript(strPartNumber)%>"), "none", "word-break:break-all;" );
		endDlistRow();
<%
		rowselect = 1 - rowselect;
	}
%>
	endDlistTable();

</SCRIPT>

<DIV ID=divEmpty STYLE="display: none;">
</DIV>

</BODY>
</HTML>
<%
}catch(Exception ex){
	System.out.println(ex.toString());
	ex.printStackTrace();
}
%>