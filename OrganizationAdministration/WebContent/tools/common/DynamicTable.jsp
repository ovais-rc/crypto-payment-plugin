<%--
/*
 *-------------------------------------------------------------------
 * Licensed Materials - Property of IBM
 *
 * WebSphere Commerce
 *
 * (c) Copyright International Business Machines Corporation.
 *     2006
 *     All rights reserved.
 *
 * US Government Users Restricted Rights - Use, duplication or
 * disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 *
 *-------------------------------------------------------------------
 */
--%> 
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<%@page import="java.util.*" %>
<%@page import="com.ibm.commerce.tools.util.*" %>
<%@page import="com.ibm.commerce.tools.common.ui.*" %>
<%@page import="com.ibm.commerce.tools.common.*" %>
<%@page import="com.ibm.commerce.tools.command.*" %>
<%@page import="com.ibm.commerce.tools.xml.*" %>
<%@ include file="common.jsp" %>

<jsp:useBean id="dtable" scope="request" class="com.ibm.commerce.tools.common.ui.DynamicTableBean"></jsp:useBean>

<%
    // set databean request properties
 	dtable.setRequest(request);
%>

<html>

<head>
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE7" />
<title>Dynamic Table</title>
<link rel="stylesheet" href="<%= dtable.getXMLValue("cssFile") %>" type="text/css" />
</head>

<script src="/wcs/javascript/tools/common/Vector.js"></script>
<script src="/wcs/javascript/tools/common/dtable.js"></script>

<SCRIPT>

// populate columns 
var columns = new Object();	// contains column attributes
<%= dtable.getColumns() %>

// populate column names and Item() function
var columnNames = new Vector();	// to keep track of column orders
<%= dtable.getItemFunctions() %>

// table data array
var tableContents = new Array();

// default cell event (including the onchange event)
var defaultEvent = "<%= UIUtil.toJavaScript(dtable.getXMLValue("defaultEvent")) %>";

// # of context menu items
var contextMenuSize = <%= dtable.getContextMenuSize() %>;

// whether multiple selection is allowed
var multiSelection = <%= dtable.getXMLValue("multipleSelection") %>;

// row header type - number or checkbox
var rowHeaderType = "<%= dtable.getXMLValue("rowHeader") %>";

// whether column re-sizing is allowed
var columnResize = <%= dtable.getXMLValue("columnResize") %>;

// whether column re-ordering is allowed
var columnReordering = <%= dtable.getXMLValue("columnReorder") %>;

// whether column sorting is allowed
var columnSort = <%= dtable.getXMLValue("columnSort") %>;

// on row highlight function
var rowHiliteFn = "<%= UIUtil.toJavaScript(dtable.getXMLValue("onHighlight")) %>";

/// public APIs starts here

    	function getColumnNames() {
    		return columnNames;
    	}
    	
    	function getColumnInfo() {
    		return columns;
    	}
    		
    	function getAllRows() {
    		return tableContents;
    	}
    	
    	function getTableSize() {
    		return tableContents.length;
    	}
    	
    	function getRowsByFlag(f) {
    		var resultSet = new Array();
    		for (var i = 0; i < tableContents.length; i++) {
    			onerow = tableContents[i];
    			if (onerow.flag % 10 == f || (onerow.flag >= 10 && f == 10))
    				resultSet[resultSet.length] = onerow;
    		}
    		if (resultSet.length == 0) 
    			return null;
    		else	
    			return resultSet;
    	}
    	
    	function getUpdatedRows() {
    		return getRowsByFlag(1);
    	}
    	
    	function getDeletedRows() {
    		return getRowsByFlag(3);
    	}
    	
    	function getInsertedRows() {
    		return getRowsByFlag(2);
    	}
    	
    	function getHilightedRows() {
    		return getRowsByFlag(10);    		
    	}

/// public APIs ends here


function initBody()
{
	// populate data
	
<%= dtable.getData() %>

	refreshTable();	
}

</SCRIPT>

<BODY onload="initBody();">

<!-- Context Menu -->
<DIV ID="oContextHTML" STYLE="display:none;">
<%= dtable.getContextMenu() %>
</DIV>

<!- Place holder for the dynamic table -->
<DIV id=tdiv></DIV>
    
</BODY></HTML>
