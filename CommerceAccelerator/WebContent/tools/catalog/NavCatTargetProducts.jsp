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
<%@ page import="com.ibm.commerce.contract.objects.TradingAgreementAccessBean" %>
<%@ page import="com.ibm.commerce.contract.objects.ContractAccessBean" %>
<%@ page import="com.ibm.commerce.ras.ECTrace" %>
<%@ page import="com.ibm.commerce.ras.ECTraceIdentifiers" %>
<%@ page import="com.ibm.commerce.tools.common.ToolsConfiguration" %>

<%@include file="../common/common.jsp" %>
<%@include file="../catalog/DefaultContractBehavior.jspf" %>
<%@include file="../catalog/TradingAgreements.jspf" %>

<%!
private String generateEntitlementSQL(CommandContext cmdContext)
{
	String strSQL="";

	try{
		Long lMemberId=cmdContext.getUser().getMemberIdInEntityType();
		
		// Out-of-box, Accelerator behaves like the store front. So if products are excluded
		// in the default store contract, then we won't be able to browse or search them in Accelerator.
		// By default, the method isRemoveDefaultContract() returns false. 
		// By changing this method to return true, then we remove any default contract that
		// we pass to ProductSetEntitlementHelper.
		// isRemoveDefaultContract() is defined in the file DefaultContractBehavior.jspf

		
		boolean removeDefaultContract = isRemoveDefaultContract();
		TradingAgreementAccessBean[] abTradingAgreements= getCurrentTradingAgreements(removeDefaultContract,cmdContext.getCurrentTradingAgreements());
		
		if(abTradingAgreements != null)
		{
			com.ibm.commerce.productset.commands.util.ProductSetEntitlementHelper pss = new com.ibm.commerce.productset.commands.util.ProductSetEntitlementHelper(abTradingAgreements, lMemberId);
			if(pss.isFilterEnabled())
			{
				Vector[] productSetInList=pss.getInclusionProductSetsOfContracts();
				Vector[] productSetOutList=pss.getExclusionProductSetsOfContracts();
				
				strSQL = com.ibm.commerce.catalog.helpers.ProductSetHelper.makeUpProductSetEntitlementSQLString("CATENTRY", "CATENTRY_ID", productSetInList, productSetOutList);
			}
			
		}
	}catch(Exception ex){
	}

	return strSQL;		
}
%>

<%
	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	// Get the command context
	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	CommandContext cmdContext = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
	Hashtable rbCategory = (Hashtable) ResourceDirectory.lookup("catalog.CatalogNLS", cmdContext.getLocale());
	Hashtable commonNLS = (Hashtable)ResourceDirectory.lookup("common.listNLS", cmdContext.getLocale());
	com.ibm.commerce.server.JSPHelper helper = new com.ibm.commerce.server.JSPHelper(request);

	String strExtFunctionSKU = helper.getParameter("ExtFunctionSKU");
	if (strExtFunctionSKU!= null && strExtFunctionSKU.equals("true"))
		strExtFunctionSKU= "true";	
	else
		strExtFunctionSKU="false"; //disabled by default

	String strCatalogId  = helper.getParameter("catalogId"); 
	String strCategoryId = helper.getParameter("categoryId"); 
	String startIndex    = helper.getParameter("startIndex"); 
	String orderByParm   = helper.getParameter("orderby");

	try
	{
		Long.parseLong(strCatalogId);
		Long.parseLong(strCategoryId);
		
		if(orderByParm != null && orderByParm.trim().length()!=0)
		{
			//Allowed values
			HashSet allowedTokens = new HashSet();
			allowedTokens.add("CATGPENREL");
			allowedTokens.add("CATENTRY_ID");
			allowedTokens.add("CATENTRY");
			allowedTokens.add("PARTNUMBER");
			allowedTokens.add("CATENTTYPE_ID");
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

	if (startIndex == null)  startIndex  = "1";
	if (orderByParm == null) orderByParm = "CATGPENREL.SEQUENCE";

	Integer languageId = cmdContext.getLanguageId();

	int listSize = 200;
	int numofpage = (new Integer(startIndex)).intValue();
	int totalPage = 5;

	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	// Run the query to return the store path enabled products
	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	Vector vResults = new Vector();
	try
	{
		String strEntitlementSQL=generateEntitlementSQL(cmdContext);
		
		// SELECT LIST OF CATALOG ENTRIES WITHIN THE SELECTED CATEGORY
		ServerJDBCHelperBean abHelper = SessionBeanHelper.lookupSessionBean(ServerJDBCHelperBean.class);
		String strSQL  = "SELECT DISTINCT CATGPENREL.CATENTRY_ID, CATENTRY.PARTNUMBER, CATENTRY.CATENTTYPE_ID, CATGPENREL.SEQUENCE";
				 strSQL += " FROM CATENTRY, CATGPENREL, STORECENT";
				 //strSQL += " WHERE CATENTRY.CATENTRY_ID=CATGPENREL.CATENTRY_ID AND CATENTRY.CATENTRY_ID=STORECENT.CATENTRY_ID AND CATGPENREL.CATENTRY_ID=STORECENT.CATENTRY_ID";
				 strSQL += " WHERE CATGPENREL.CATENTRY_ID=CATENTRY.CATENTRY_ID AND CATGPENREL.CATENTRY_ID=STORECENT.CATENTRY_ID";
				 strSQL += " AND CATGPENREL.CATALOG_ID=" +  strCatalogId;
				 strSQL += " AND CATGPENREL.CATGROUP_ID=" + strCategoryId;
				 strSQL += " AND CATENTRY.MARKFORDELETE=0";
				 if(strExtFunctionSKU.equals("false"))
				 	strSQL += " AND CATENTRY.CATENTTYPE_ID <> 'ItemBean'";
				 strSQL += " AND STORECENT.STOREENT_ID " + CatalogSqlHelper.getStorePathInClauseSQL(cmdContext.getStoreId());
				 strSQL += strEntitlementSQL;
				 strSQL += " ORDER BY " + orderByParm;

		vResults = abHelper.executeQuery(strSQL);
	} catch (Exception ex) {
		vResults = new Vector();
	}

	totalPage = (vResults.size() / listSize) + 1;
	int iStartOffset = (numofpage-1) * listSize;
	int iEndOffset = iStartOffset + listSize;
	if (iEndOffset > vResults.size()) { iEndOffset = vResults.size(); }

	int nNumOfProducts=vResults.size();

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
<HTML>
<HEAD>

	<TITLE><%=UIUtil.toHTML((String)rbCategory.get("NavCatTargetProducts_Title"))%></TITLE>
	<LINK rel=stylesheet href="<%= UIUtil.getCSSFile(cmdContext.getLocale()) %>" type="text/css">

	<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
	<SCRIPT SRC="/wcs/javascript/tools/catalog/NavCatCommonFunctions.js"></SCRIPT>
	<SCRIPT SRC="/wcs/javascript/tools/common/dynamiclist.js"></SCRIPT>

<SCRIPT>

	var numofpage = <%=numofpage%>;
	var sequenceArray = new Array();

	//////////////////////////////////////////////////////////////////////////////////////
	// onLoad()
	//
	// - this function is called when the frame is loaded
	//////////////////////////////////////////////////////////////////////////////////////
	function onLoad () 
	{
		if (getTableSize(NavCatTargetProductList) == 0) 
		{
			divEmpty.innerHTML = "<BR><%=UIUtil.toJavaScript((String)rbCategory.get("NavCatTargetProducts_NoProducts"))%>";
			divEmpty.style.display = "block";
		}
		setChecked();

		parent.updateCategoryProductCounts(<%=strCatalogId%>, <%=strCategoryId%>, <%=nNumOfProducts%>);
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// refresh(value)
	//
	// @param value - value is a field that can be used to determine redirect logic
	//
	// - this function is called when the frame is reloaded it will save the
	//   sequences first if they have changed
	//////////////////////////////////////////////////////////////////////////////////////
	function refresh(value)
	{
		if (sequenceChanges(value) == false)
		{
			if (value == "none") mySort("<%=orderByParm%>");
			else if (value == "close") parent.hideTargetProducts();
			else mySort(value);
		}
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
				sequences[index].catentryId = getCheckBoxId(NavCatTargetProductList, i+1);
				sequences[index].sequence   = seqValue;
				sequenceArray[i] = seqValue;
			}
		}

		if (sequences.length > 0)
		{
			var obj = new Object();
			obj.catalogId  = parent.currentTargetDetailCatalog;
			obj.categoryId = parent.currentTargetTreeElement.id;
			obj.value      = value;
			obj.sequences = sequences;
			parent.workingFrame.submitFunction("NavCatSequenceCategoryControllerCmd", obj);
			return true
		} 

		return false;
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
		urlPara.catalogId  = parent.currentTargetDetailCatalog;
		urlPara.categoryId = parent.currentTargetTreeElement.id;
		urlPara.startIndex = numofpage;
		urlPara.orderby    = value;
		urlPara.ExtFunctionSKU="<%=strExtFunctionSKU%>";
		top.mccmain.submitForm("/webapp/wcs/tools/servlet/NavCatTargetProducts", urlPara, "targetProductsContents");
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// setChecked() 
	//
	// - this function is called whenever a checkbox is clicked
	//////////////////////////////////////////////////////////////////////////////////////
	function setChecked()
	{
		var count = getNumberOfChecks(NavCatTargetProductList);
		if (defined(parent.targetProductsContentsButtons.setButtons)) parent.targetProductsContentsButtons.setButtons(count);
		setCheckHeading(NavCatTargetProductList, (count == getTableSize(NavCatTargetProductList)));
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// selectDeselectAll() 
	//
	// - this function is called when the select/deselect all checkbox is clicked
	//////////////////////////////////////////////////////////////////////////////////////
	function selectDeselectAll()
	{
		setAllRowChecks(NavCatTargetProductList, event.srcElement.checked);
		setChecked();
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// removeButton()
	//
	// - this function is called when the remove button is clicked
	//////////////////////////////////////////////////////////////////////////////////////
	function removeButton()
	{
		var obj = new Object();
		obj.catalogId  = parent.currentTargetDetailCatalog;
		obj.categoryId = parent.currentTargetTreeElement.id;
		obj.catentryId = new Array();

		for (var i=1; i<NavCatTargetProductList.rows.length; i++)
		{
			if (getChecked(NavCatTargetProductList, i))
			{
				obj.catentryId[obj.catentryId.length] = getCheckBoxId(NavCatTargetProductList, i);

			}
		}

		parent.workingFrame.submitFunction("NavCatRemoveProductRelationsControllerCmd", obj);
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// prevButton() 
	//
	// - this function is called when selecting the prev page of results
	//////////////////////////////////////////////////////////////////////////////////////
	function prevButton()
	{
		numofpage = numofpage - 1;
		refresh("none");
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// nextButton() 
	//
	// - this function is called when selecting the next page of results
	//////////////////////////////////////////////////////////////////////////////////////
	function nextButton()
	{
		numofpage = numofpage + 1;
		refresh("none");
	}


function mySelectDeselectAll()
{
  for (var i=1; i<NavCatTargetProductList.rows.length; i++) 
  {
	if(NavCatTargetProductList.rows(i).cells(0).firstChild.LOCKED == null)  	
  		NavCatTargetProductList.rows(i).cells(0).firstChild.checked=select_deselect.checked;
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
	var categoryName = parent.currentTargetTreeElement.children(1).firstChild.nodeValue;
	document.writeln("<b>" + parent.replaceField("<%=UIUtil.toJavaScript((String)rbCategory.get("NavCatDialog_showProducts"))%>", changeJavaScriptToHTML(categoryName)) + "</b><BR>");
</SCRIPT>

<%
if (totalPage > 1)
{
%>
	<table id="CP_table" cellspacing=0 cellspacing=0 border=0 width="100%" style="position:absolute;">
		<tr>
			<td align="right" id="control_panel_navigate">
				<table id=idtable1 cellspacing=0 cellspacing=0 border=0>
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
						<td id=idtable1_tr1 class="scroll">&nbsp;<%=specialDisplay%>&nbsp;</td>
<%
	if (numofpage < totalPage)
	{
%>
						<td id=idtable1_tr2><img src="/wcs/images/tools/newlist/divide.gif" width="1" height="13" border="0" alt=""></td>
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

	parent.sortImgMsg = "<%=UIUtil.toJavaScript((String)rbCategory.get("NavCatSortSaveMsg"))%>";

	var bParentLocked = (parent.currentTargetTreeElement.LOCK == 'true');
	var bOwnThisCatentry;

	startDlistTable("NavCatTargetProductList", "100%");
	startDlistRowHeading();
	addDlistCheckHeading(true, "mySelectDeselectAll()");
	addDlistColumnHeading("<%=UIUtil.toJavaScript((String)rbCategory.get("NavCatTargetProducts_Code"))%>",     true,  "null", "CATENTRY.PARTNUMBER",    <%=orderByParm.equals("CATENTRY.PARTNUMBER")%>,    "refresh" );
	addDlistColumnHeading("&nbsp;",                                                                            false, "18px", "CATENTRY.CATENTTYPE_ID", <%=orderByParm.equals("CATENTRY.CATENTTYPE_ID")%>, "refresh" );
	addDlistColumnHeading("<%=UIUtil.toJavaScript((String)rbCategory.get("NavCatTargetProducts_Sequence"))%>", false, "80px",    "CATGPENREL.SEQUENCE",    <%=orderByParm.equals("CATGPENREL.SEQUENCE")%>,    "refresh" );
	endDlistRow();
<%
	int nStoreId=cmdContext.getStoreId().intValue();
	int rowselect = 0;
	for (int i=iStartOffset; i<iEndOffset; i++)
	{
		Vector vResult = (Vector) vResults.elementAt(i);

		Long lCatentryId = new Long(vResult.elementAt(0).toString());
		String strIdent = (String) vResult.elementAt(1);
		String strType  = (String) vResult.elementAt(2);

		Integer nCatentryStoreId = new Integer(0); //, STORECENT.STOREENT_ID  new Integer(vResult.elementAt(4).toString());
		StoreCatalogEntryAccessBean abStoreCent= new StoreCatalogEntryAccessBean();
		Enumeration enStoreCent=abStoreCent.findByCatalogEntryId(lCatentryId);    
		if(enStoreCent.hasMoreElements())
		{
			abStoreCent = (StoreCatalogEntryAccessBean) enStoreCent.nextElement();	
			nCatentryStoreId=abStoreCent.getStoreEntryIDInEntityType();
		}
		
		Double dSequence = new Double(0.0);
		if (vResult.elementAt(3) != null) { dSequence = new Double(vResult.elementAt(3).toString()); }

%>
		sequenceArray[sequenceArray.length] = "<%=dSequence%>";
		
		bOwnThisCatentry=<%=(nStoreId == nCatentryStoreId.intValue())%>;
		if(bParentLocked && (!bOwnThisCatentry))		
		{
			startDlistRow("_lock");
			addDlistCheck_Locked( "<%=lCatentryId%>", "<%=lCatentryId%>" );
			addDlistColumn( changeJavaScriptToHTML("<%=UIUtil.toJavaScript(strIdent)%>"), "none", "word-break:break-all;" );
			addDlistColumn( parent.elementType("<%=strType.trim()%>"), "none", "text-align:center;" );
			addDlistColumn( "<INPUT NAME=sequenceInput SIZE=5 VALUE=\""+top.numberToStr(<%=dSequence%>,<%=cmdContext.getLanguageId()%>)+"\" STYLE=\"background-color:transparent; text-align:right;\" disabled >", "none", "text-align:right" );
		}
		else
		{
			startDlistRow(<%=rowselect+1%>);
			addDlistCheck( "<%=lCatentryId%>", "setChecked()", "<%=lCatentryId%>" );
			addDlistColumn( changeJavaScriptToHTML("<%=UIUtil.toJavaScript(strIdent)%>"), "none", "word-break:break-all;" );
			addDlistColumn( parent.elementType("<%=strType.trim()%>"), "none", "text-align:center;" );
			
			if(parent.bStoreViewOnly)
				addDlistColumn( "<INPUT NAME=sequenceInput SIZE=5 VALUE=\""+top.numberToStr(<%=dSequence%>,<%=cmdContext.getLanguageId()%>)+"\" STYLE=\"background-color:transparent; text-align:right;\" disabled >", "none", "text-align:right" );
			else
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
