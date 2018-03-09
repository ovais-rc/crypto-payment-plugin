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
<%@ page import="com.ibm.commerce.ejb.helpers.SessionBeanHelper" %>
<%@ page import="com.ibm.commerce.base.objects.ServerJDBCHelperBean" %>
<%@ page import="com.ibm.commerce.catalog.objects.*" %>
<%@ page import="com.ibm.commerce.catalog.beans.*" %>
<%@ page import="com.ibm.commerce.tools.common.ui.taglibs.*" %>
<%@ page import="com.ibm.commerce.server.ECConstants" %>

<%@include file="../common/common.jsp" %>

<%
	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	// Get the command context
	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	CommandContext cmdContext = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
	Hashtable rbProduct  = (Hashtable) ResourceDirectory.lookup("catalog.ProductNLS", cmdContext.getLocale());
	Hashtable rbCategory = (Hashtable) ResourceDirectory.lookup("catalog.CatalogNLS", cmdContext.getLocale());
	com.ibm.commerce.server.JSPHelper helper = new com.ibm.commerce.server.JSPHelper(request);

	String strCatalogId  = helper.getParameter("catalogId"); 
	String strParentId   = helper.getParameter("categoryId"); 
	String orderByParm   = helper.getParameter("orderby");
	
	// Validate parms - throw exception on error
	try
	{
		Long.parseLong(strCatalogId);
		Long.parseLong(strParentId);	
		
		if(orderByParm != null && orderByParm.trim().length()!=0)
		{
			//Allowed values
			HashSet allowedTokens = new HashSet();
			allowedTokens.add("CATTOGRP");
			allowedTokens.add("CATGROUP_ID");
			allowedTokens.add("STORECGRP");
			allowedTokens.add("STOREENT_ID");
			allowedTokens.add("CATGROUP");
			allowedTokens.add("IDENTIFIER");
			allowedTokens.add("CATGRPREL");
			allowedTokens.add("CATGROUP_ID_CHILD");
			allowedTokens.add("SEQUENCE");
			allowedTokens.add("ASC");
			allowedTokens.add("DESC");
			
			StringTokenizer parms = new StringTokenizer(orderByParm, ",. ");
			while( parms.hasMoreTokens() )
			{
				if( !allowedTokens.contains(parms.nextToken().trim().toUpperCase()) )
				{
					throw new Exception();
				}
			}
		}
		
	}
	catch(Exception e)
	{
		throw e;
	}	
	
	if (orderByParm == null) orderByParm = "SEQUENCE";

	Integer languageId = cmdContext.getLanguageId();


	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	// If the parentId is 0 then return top categories
	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	Vector vResults = new Vector();

	if (strParentId == null || strParentId.equals("0"))
	{
		try
		{
			String strOrderBy = orderByParm;
			if (strOrderBy.equals("SEQUENCE")) strOrderBy = "CATTOGRP.SEQUENCE";
			ServerJDBCHelperBean abHelper = SessionBeanHelper.lookupSessionBean(ServerJDBCHelperBean.class);
			String strSQL  = "SELECT DISTINCT CATTOGRP.CATGROUP_ID, STORECGRP.STOREENT_ID, CATGROUP.IDENTIFIER, CATTOGRP.SEQUENCE";
					 strSQL += " FROM CATGROUP, CATTOGRP, STORECGRP";
					 strSQL += " WHERE CATGROUP.CATGROUP_ID=CATTOGRP.CATGROUP_ID AND CATGROUP.CATGROUP_ID=STORECGRP.CATGROUP_ID ";
					 strSQL += " AND CATGROUP.MARKFORDELETE=0";
					 strSQL += " AND CATTOGRP.CATALOG_ID=" +  strCatalogId;
					 strSQL += " AND STORECGRP.STOREENT_ID " + CatalogSqlHelper.getStorePathInClauseSQL(cmdContext.getStoreId());
					 strSQL += " ORDER BY " + strOrderBy;
			vResults = abHelper.executeQuery(strSQL);
		} catch (Exception ex) { vResults = new Vector(); }
	}
	else
	{
		try
		{
			String strOrderBy = orderByParm;
			if (strOrderBy.equals("SEQUENCE")) strOrderBy = "CATGRPREL.SEQUENCE";
			ServerJDBCHelperBean abHelper = SessionBeanHelper.lookupSessionBean(ServerJDBCHelperBean.class);
			String strSQL = "SELECT DISTINCT CATGRPREL.CATGROUP_ID_CHILD, STORECGRP.STOREENT_ID, CATGROUP.IDENTIFIER, CATGRPREL.SEQUENCE";
					 strSQL += " FROM CATGRPREL, STORECGRP, CATGROUP";
					 strSQL += " WHERE CATGRPREL.CATGROUP_ID_CHILD=STORECGRP.CATGROUP_ID AND CATGROUP.CATGROUP_ID=CATGRPREL.CATGROUP_ID_CHILD";
					 strSQL += " AND CATGROUP.MARKFORDELETE=0";
					 strSQL += " AND CATGRPREL.CATALOG_ID=" +  strCatalogId;
					 strSQL += " AND CATGRPREL.CATGROUP_ID_PARENT=" +  strParentId;
					 strSQL += " AND STORECGRP.STOREENT_ID " + CatalogSqlHelper.getStorePathInClauseSQL(cmdContext.getStoreId());
					 strSQL += " ORDER BY " + strOrderBy;
			vResults = abHelper.executeQuery(strSQL);
		} catch (Exception ex) { vResults = new Vector(); }
	}
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
<HTML>
<HEAD>

	<TITLE><%=UIUtil.toHTML((String)rbCategory.get("NavCatTargetChildren_Title"))%></TITLE>
	<LINK rel=stylesheet href="<%= UIUtil.getCSSFile(cmdContext.getLocale()) %>" type="text/css">

	<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
	<SCRIPT SRC="/wcs/javascript/tools/catalog/NavCatCommonFunctions.js"></SCRIPT>
	<SCRIPT SRC="/wcs/javascript/tools/common/dynamiclist.js"></SCRIPT>

<SCRIPT>

	var sequenceArray = new Array();

	//////////////////////////////////////////////////////////////////////////////////////
	// onLoad()
	//
	// - this function is called when the frame is loaded
	//////////////////////////////////////////////////////////////////////////////////////
	function onLoad () 
	{
		if (getTableSize(NavCatTargetChildrenList) == 0) 
		{
			divEmpty.innerHTML = "<BR><%=UIUtil.toJavaScript((String)rbCategory.get("NavCatTargetChildren_NoChildren"))%>";
			divEmpty.style.display = "block";
		}
		setChecked();
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// refresh(value)
	//
	// @param value - value is a field that can be used to determine redirect logic
	//
	// - this function is called when the frame is reloaded it will save the
	//   sequences first if they have changed
	//////////////////////////////////////////////////////////////////////////////////////
	m_bCloseOnRefresh=false;
	function refresh(value)
	{
		if (sequenceChanges(value) == false)
		{
			if( ((value == "none") &&(m_bCloseOnRefresh)) || (value == "close") )
				parent.hideTargetChildren();
			else if (value == "none") 
				mySort("<%=orderByParm%>");
			else 
				mySort(value);
				
			m_bCloseOnRefresh=false;	
		}
		else if (value=="close")
			m_bCloseOnRefresh=true;
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
		var urlPara = new Object();
		urlPara.catalogId  = <%=strCatalogId%>;
		urlPara.categoryId = <%=strParentId%>;
		urlPara.orderby    = value;
		top.mccmain.submitForm("/webapp/wcs/tools/servlet/NavCatTargetChildren", urlPara, "targetChildrenContent");
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// setChecked() 
	//
	// - this function is called whenever a checkbox is clicked
	//////////////////////////////////////////////////////////////////////////////////////
	function setChecked()
	{
		var count = getNumberOfChecks(NavCatTargetChildrenList);
		if (parent.targetChildrenButtons.setButtons) parent.targetChildrenButtons.setButtons(count);
		setCheckHeading(NavCatTargetChildrenList, (count == getTableSize(NavCatTargetChildrenList)));
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// selectDeselectAll() 
	//
	// - this function is called when the select/deselect all checkbox is clicked
	//////////////////////////////////////////////////////////////////////////////////////
	function selectDeselectAll()
	{
		setAllRowChecks(NavCatTargetChildrenList, event.srcElement.checked);
		setChecked();
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// removeButton()
	//
	// - this function is called when the remove button is clicked
	//////////////////////////////////////////////////////////////////////////////////////
	function removeButton()
	{
		var parentId = parent.currentTargetTreeElement.id;
		var categoryIds = new Array();

		for (var i=1; i<NavCatTargetChildrenList.rows.length; i++)
		{
			if (getChecked(NavCatTargetChildrenList, i))
			{
				categoryIds[categoryIds.length] = getCheckBoxId(NavCatTargetChildrenList, i);
			}
		}

		parent.targetTreeFrame.removeButton(parentId, categoryIds);
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// validateSequences()
	//
	// @return true - if the sequences are valid, otherwise false
	//
	// - this function determines if the sequence values are valid numbers
	//////////////////////////////////////////////////////////////////////////////////////
	function validateSequences()
	{
		for (var i=0; i<sequenceArray.length; i++)
		{
			if (top.isValidNumber(sequenceInput[i].value, <%=languageId%>) == false)
			{
				alertDialog("<%=UIUtil.toJavaScript((String)rbCategory.get("NavCatTargetProducts_InvalidSequence"))%>");
				sequenceInput[i].focus();
				return false;
			}
		}

		return true;
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// sequenceChanges(value)
	//
	// @param value - value is a field that can be used to determine redirect logic
	//
	// @return true - if the sequence has changed, otherwise false
	//
	// - this function determines if the sequence has changed saving them if they have
	//////////////////////////////////////////////////////////////////////////////////////
	function sequenceChanges(value)
	{
		if (validateSequences() == false) return true;

		var sequences = new Array();
		for (var i=0; i<sequenceArray.length; i++)
		{
			var seqValue = top.strToNumber(sequenceInput[i].value, <%=languageId%>);
			if (sequenceArray[i] != seqValue)
			{
				var index = sequences.length;
				sequences[index] = new Object();
				sequences[index].categoryId = getCheckBoxId(NavCatTargetChildrenList, i+1);
				sequences[index].sequence   = seqValue;
				sequenceArray[i] = seqValue;
			}
		}

		if (sequences.length > 0)
		{
			var obj = new Object();
			obj.catalogId  = parent.currentTargetDetailCatalog;
			obj.parentId   = parent.currentTargetTreeElement.id;
			obj.value      = value;
			obj.sequences  = sequences;
			parent.workingFrame.submitFunction("NavCatSequenceCategoriesControllerCmd", obj);
			return true
		} 

		return false;
	}


function mySelectDeselectAll()
{
  for (var i=1; i<NavCatTargetChildrenList.rows.length; i++) 
  {
	if(NavCatTargetChildrenList.rows(i).cells(0).firstChild.LOCKED == null)  	
  		NavCatTargetChildrenList.rows(i).cells(0).firstChild.checked=select_deselect.checked;
  }
  
  var checked=select_deselect.checked;
  setChecked();
  select_deselect.checked=checked;
}

function addDlistCheck_Locked(strName,strValue)
{
	document.writeln("<TD CLASS=\""+list_check_style+"\"><INPUT TYPE=\"checkbox\"");
   	document.write(" NAME=\""+strName+"\"" );
   	document.write(" value='"+strValue+"' LOCKED='true' disabled ");
	document.write("></TD>");			
}

</SCRIPT>

<STYLE TYPE='text/css'>
TR.list_row_lock { background-color: ButtonFace; height: 20px; word-wrap: break-word; }
</STYLE>

</HEAD>

<BODY CLASS=content ONLOAD=onLoad() ONCONTEXTMENU="return false;">

<SCRIPT>
	parent.sortImgMsg = "<%=UIUtil.toJavaScript((String)rbCategory.get("NavCatSortSaveMsg"))%>";
	
	var categoryName = parent.currentTargetTreeElement.children(1).firstChild.nodeValue;
	document.writeln("<b>" + parent.replaceField("<%=UIUtil.toJavaScript((String)rbCategory.get("NavCatTargetChildren_ChildrenOf"))%>", changeJavaScriptToHTML(categoryName)) + "</b><BR><BR>");

	var bParentLocked = (parent.currentTargetTreeElement.LOCK == 'true');
	var bOwnThisCategory;
	
	startDlistTable("NavCatTargetChildrenList", "100%");
	startDlistRowHeading();
	addDlistCheckHeading(true, "mySelectDeselectAll()");
	addDlistColumnHeading("<%=UIUtil.toJavaScript((String)rbCategory.get("NavCatTargetProducts_Code"))%>",     true,  "null", "CATGROUP.IDENTIFIER", <%=orderByParm.equals("CATGROUP.IDENTIFIER")%>, "refresh"  );
	addDlistColumnHeading("<%=UIUtil.toJavaScript((String)rbCategory.get("NavCatTargetProducts_Sequence"))%>", false, "80px",    "SEQUENCE",            <%=orderByParm.equals("SEQUENCE")%>,            "refresh"  );
	endDlistRow();
<%
	int nStoreId=cmdContext.getStoreId().intValue();
	int rowselect = 1;
	for (int i=0; i<vResults.size(); i++)
	{
		Vector vResult = (Vector) vResults.elementAt(i);

		Long lCatgroupId = new Long(vResult.elementAt(0).toString());
		Integer nCatgpStoreId = new Integer(vResult.elementAt(1).toString());
		String strIdent = (String) vResult.elementAt(2);
		Double dSequence = new Double(0.0);
		if (vResult.elementAt(3) != null) { dSequence = new Double(vResult.elementAt(3).toString()); }
%>
		sequenceArray[sequenceArray.length] = "<%=dSequence%>";
		
		bOwnThisCategory=<%=(nStoreId == nCatgpStoreId.intValue())%>;
		
		if(bParentLocked && (!bOwnThisCategory))		
		{
			startDlistRow("_lock");
			addDlistCheck_Locked( "<%=lCatgroupId%>", "<%=lCatgroupId%>" );
			addDlistColumn( changeJavaScriptToHTML("<%=UIUtil.toJavaScript(strIdent)%>"), "none", "word-break:break-all;" );
			addDlistColumn( "<INPUT NAME=sequenceInput SIZE=5 VALUE=\""+top.numberToStr(<%=dSequence%>,<%=cmdContext.getLanguageId()%>)+"\" STYLE=\"background-color:transparent; text-align:right;\" disabled >", "none", "text-align:right" );
		}	
		else
		{
			startDlistRow(<%=rowselect+1%>);		
			addDlistCheck( "<%=lCatgroupId%>", "setChecked()", "<%=lCatgroupId%>" );
			addDlistColumn( changeJavaScriptToHTML("<%=UIUtil.toJavaScript(strIdent)%>"), "none", "word-break:break-all;" );
			addDlistColumn( "<INPUT NAME=sequenceInput SIZE=5 VALUE=\""+top.numberToStr(<%=dSequence%>,<%=cmdContext.getLanguageId()%>)+"\" STYLE=\"background-color:transparent; text-align:right;\">", "none", "text-align:right" );
		}		
		endDlistRow();
<%
		rowselect = 1 - rowselect;
	}
%>
	endDlistTable();

	document.writeln("<INPUT TYPE=HIDDEN NAME=sequenceInput>");  // dummy to ensure an array
</SCRIPT>

<DIV ID=divEmpty STYLE="display: none;">
</DIV>

</BODY>
</HTML>
