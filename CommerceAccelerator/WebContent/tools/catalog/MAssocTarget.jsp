<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%--
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2002, 2017
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
//*
--%>

<%@ page language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.tools.util.UIUtil" %>
<%@ page import="com.ibm.commerce.tools.catalog.commands.MAssociationUpdateCmd" %>
<%@ page import="com.ibm.commerce.tools.catalog.beans.AccessControlHelperDataBean" %>
<%@ page import="com.ibm.commerce.beans.DataBeanManager" %>
<%@ page import="com.ibm.commerce.ejb.helpers.SessionBeanHelper" %>
<%@ page import="com.ibm.commerce.base.objects.ServerJDBCHelperBean" %>

<%@ include file="../common/common.jsp" %>
<%@ include file="KitUtil.jsp" %> 

<%!
/////////////////////////////////////////////////////////////////////////////////////
// MAssocDisplayObject
//
// - Display object for MAssoc
/////////////////////////////////////////////////////////////////////////////////////
class MAssocDisplayObject {

	String identifier;
	String displayStr;
	
	/**
	*	Constructor for MAssoc object
	*	@param identifier - identifier for this object
	*	@pararm displayStr - display string for the identifier
	*/
	public MAssocDisplayObject(String identifier, String displayStr) {
		this.identifier = identifier;
		this.displayStr = displayStr;
	}
	
	/**
	*	return identifiers
	*/
	public String getIdentifier() {
		return identifier;
	}
	
	/**
	*	return the display string for identifiers
	*/
	public String getDisplayStr() {
		return displayStr;
	}
}

/////////////////////////////////////////////////////////////////////////////////////
// Vector getAllMAssocTypes()
//
// - get all Association types
/////////////////////////////////////////////////////////////////////////////////////
private Vector getAllMAssocTypes(Hashtable mAssocNLS)
{
	Vector vMAssocTypes= new Vector();

	try{
		ServerJDBCHelperBean helper = SessionBeanHelper.lookupSessionBean(ServerJDBCHelperBean.class);

		String  strSQL = " SELECT MASSOCTYPE_ID FROM MASSOCTYPE ORDER BY MASSOCTYPE_ID ASC ";

		Vector vResult = helper.executeQuery(strSQL);
		Vector vRow;
		String strType;
		String strTypeDisplay;
		
		for(int i=0; i<vResult.size(); i++)
		{
			vRow = (Vector) vResult.elementAt(i);

			strType = (String) vRow.elementAt(0);
			strType = strType.trim();
			
			strTypeDisplay = (String) mAssocNLS.get(strType);

			if (strTypeDisplay == null) {
				strTypeDisplay = strType;
			}
			
			if (strType.length()>0)
			{
				vMAssocTypes.addElement(new MAssocDisplayObject(strType, strTypeDisplay));
			}	
		}		
	}catch (Exception ex){
		jspTrace("getAllMAssocTypes() Exception= " + ex.toString());
	}	
	return vMAssocTypes;
}

/////////////////////////////////////////////////////////////////////////////////////
// Vector getAllMAssocSemantics()
//
// - get all Association semantics
/////////////////////////////////////////////////////////////////////////////////////
private Vector getAllMAssocSemantics(Hashtable mAssocNLS)
{
	Vector vMAssocTypes= new Vector();

	try{
		ServerJDBCHelperBean helper = SessionBeanHelper.lookupSessionBean(ServerJDBCHelperBean.class);

		String strSQL = " SELECT MASSOC_ID FROM MASSOC ";
		
		Vector vResult =helper.executeQuery(strSQL);
		Vector vRow;
		String strSemantic;
		String strSemanticDisplay;
		
		for(int i=0; i<vResult.size(); i++)
		{
			vRow = (Vector) vResult.elementAt(i);
			
			strSemantic = (String) vRow.elementAt(0);
			strSemantic = strSemantic.trim();
			
			strSemanticDisplay = (String) mAssocNLS.get(strSemantic);

			if (strSemanticDisplay == null) {
				strSemanticDisplay = strSemantic;
			}
			
			if(strSemantic.length()>0)
			{
				vMAssocTypes.addElement(new MAssocDisplayObject(strSemantic, strSemanticDisplay));
			}	
		}	
		
	}catch (Exception ex){
		jspTrace("getAllMAssocSemantics() Exception= " + ex.toString());
	}	
	return vMAssocTypes;
}

%>


<%
	CommandContext 	cmdContext = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
   	Locale 			jLocale = cmdContext.getLocale();
    Hashtable		nlsMAssoc= (Hashtable) ResourceDirectory.lookup("catalog.MAssociationNLS", jLocale);
 	Hashtable rbProduct = (Hashtable)ResourceDirectory.lookup("catalog.ProductNLS", cmdContext.getLocale());

	String myInterfaceName = MAssociationUpdateCmd.NAME;
	AccessControlHelperDataBean myACHelperBean= new AccessControlHelperDataBean();
	myACHelperBean.setInterfaceName(myInterfaceName);
	DataBeanManager.activate(myACHelperBean,cmdContext);
%>

<HTML>
<HEAD>

<title><%=UIUtil.toHTML((String)nlsMAssoc.get("titleTarget"))%></title>

<LINK rel=stylesheet href="<%= UIUtil.getCSSFile(jLocale) %>" type="text/css">
<link rel=stylesheet href="/wcs/tools/catalog/DTable.css" type="text/css">

<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/common/Vector.js"></SCRIPT>
<script src="/wcs/javascript/tools/common/DateUtil.js"></script>

<SCRIPT SRC="/wcs/javascript/tools/catalog/DTable.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/catalog/MAssociation.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/catalog/KitContents.js"></SCRIPT>

<SCRIPT LANGUAGE="JavaScript">

	var readonlyAccess = <%=myACHelperBean.isReadOnly()%>;
	var showName = false;
	var partNumberWidth = "90";
	var nameWidth = "125";

/////////////////////////////////////////////////////////////////////////////////////
// - colors used for validation
/////////////////////////////////////////////////////////////////////////////////////
var COLOR_INVALID_NUMBER='RED';
var COLOR_VALID_NUMBER='BLACK';
var COLOR_INVALID_TARGET='RED';

/////////////////////////////////////////////////////////////////////////////////////
// - variables used for AssociationType and semantic
/////////////////////////////////////////////////////////////////////////////////////
var MASelection = new Object();
	MASelection.OPTIONS  = new Object();
<% Vector vMATypes = getAllMAssocTypes(nlsMAssoc);
	for(int i=0; i<vMATypes.size(); i++)
	{
		MAssocDisplayObject mAssocDisplayObject = (MAssocDisplayObject) vMATypes.elementAt(i); 
		String strType = mAssocDisplayObject.getIdentifier();
		String strTypeDisplay = mAssocDisplayObject.getDisplayStr();
%>	
		MASelection.OPTIONS['<%=strType%>'] = "<%=strTypeDisplay%>";
<%		
	}
%>		

var MASemanticSelection = new Object();
	MASemanticSelection.OPTIONS  = new Object();
<% Vector vMASemantics = getAllMAssocSemantics(nlsMAssoc);
	for(int i=0; i<vMASemantics.size(); i++)
	{
		MAssocDisplayObject mAssocDisplayObject = (MAssocDisplayObject) vMASemantics.elementAt(i); 
		String strSemantic = mAssocDisplayObject.getIdentifier();
		String strSemanticDisplay = mAssocDisplayObject.getDisplayStr();
%>	
		MASemanticSelection.OPTIONS['<%=strSemantic%>'] = "<%=strSemanticDisplay%>";
<%		
	}
%>		

var DEFAULT_MA_TYPE="<%=vMATypes.size()>0? (String) ((MAssocDisplayObject) vMATypes.elementAt(0)).getIdentifier(): "" %>";
var DEFAULT_NEW_MA_TYPE = DEFAULT_MA_TYPE;
var DEFAULT_MA_SEMANTIC ="<%=vMASemantics.size()>0? (String) ((MAssocDisplayObject) vMASemantics.elementAt(0)).getIdentifier(): "" %>";
var CURRENT_MA_TYPE;

var default_ma_saved_type = top.getData("default_ma_type");
var displayNone = "display:none;";
if (defined(default_ma_saved_type)) DEFAULT_MA_TYPE = default_ma_saved_type;
else                                default_ma_saved_type = "0";	  // "0" represents all types

if (showName) {
	displayNone = "";
	partNumberWidth="125";
}

/////////////////////////////////////////////////////////////////////////////////////
// escapeSpecialCharacters()
//
// - escapeSpecialCharacters in a string for javascript
/////////////////////////////////////////////////////////////////////////////////////
function escapeSpecialCharacters(str) {
	return str.replace(/'/g,"&#39;");
}


/////////////////////////////////////////////////////////////////////////////////////
// generateHeadHTML()
//
// - callback (when a table need to be refreshed)
/////////////////////////////////////////////////////////////////////////////////////
function generateHeadHTML()
{
	var strHead;
	
    strHead	 = "<TD CLASS=COLHEAD STYLE='width: " + partNumberWidth + ";' id=partNumber><%=getNLString(nlsMAssoc,"columnPartNumber")%></TD>";
	strHead += "<TD CLASS=COLHEAD STYLE='width: 22;' id=type>&nbsp</TD>";
 
 	if(!m_bShowCommonTargets)
 	{   
		strHead += "<TD CLASS=COLHEAD STYLE='width: " + nameWidth + ";' id=name style='" + displayNone + "'><%=getNLString(nlsMAssoc,"columnName")%></TD>";
		strHead += "<TD CLASS=COLHEAD STYLE='width:" + (dpMassocTypeSize.scrollWidth + 70) + "' id=association><label for='columnAssociation'><%=getNLString(nlsMAssoc,"columnAssociation")%></label></TD>";
		strHead += "<TD CLASS=COLHEAD STYLE='width:" + (dpMassocSemanticSize.scrollWidth + 25) + "' id=semantic><label for='columnSemantic'><%=getNLString(nlsMAssoc,"columnSemantic")%></label></TD>";
		strHead += "<TD CLASS=COLHEAD STYLE='width: 127px; font-size: 8pt;' id=date><%=getNLString(nlsMAssoc,"columnDate")%><BR><%=getNLString(nlsMAssoc,"columnDateYYYYMMDD")%></TD>";
		strHead += "<TD CLASS=COLHEAD STYLE='width: 75px;' id=qty><label for='columnQty'><%=getNLString(nlsMAssoc,"columnQty")%></label></TD>";
	}
	else
	{
		strHead += "<TD CLASS=COLHEAD STYLE='width: 75%;' id=name style='" + displayNone + "'><%=getNLString(nlsMAssoc,"columnName")%></TD>";
		strHead += "<TD CLASS=COLHEAD STYLE='width:" + (dpMassocTypeSize.scrollWidth+6) + "' id=association><label for='columnAssociation'><%=getNLString(nlsMAssoc,"columnAssociation")%></label></TD>";
		strHead += "<TD CLASS=COLHEAD STYLE='width:" + (dpMassocSemanticSize.scrollWidth+6) + "' id=semantic><label for='columnSemantic'><%=getNLString(nlsMAssoc,"columnSemantic")%></label></TD>";
	}	
	
    return strHead;
}    

//////////////////////////////////////////////////////////////////////////////////////
// elementType(type)
//
// - return the displayed value for this type
//////////////////////////////////////////////////////////////////////////////////////
function elementType(type)
{
	switch (type)
	{
		case "ProductBean":
			return 'SRC="/wcs/images/tools/catalog/product_grey.gif" ALT="<%=UIUtil.toJavaScript((String)rbProduct.get("attribute_catentryType_product"))%>"';
		case "ItemBean":
			return 'SRC="/wcs/images/tools/catalog/skuitem_grey.gif" ALT="<%=UIUtil.toJavaScript((String)rbProduct.get("attribute_catentryType_item"))%>"';
		case "PackageBean":
			return 'SRC="/wcs/images/tools/catalog/bundle_grey.gif" ALT="<%=UIUtil.toJavaScript((String)rbProduct.get("attribute_catentryType_package"))%>"';
		case "BundleBean":
			return 'SRC="/wcs/images/tools/catalog/package_grey.gif" ALT="<%=UIUtil.toJavaScript((String)rbProduct.get("attribute_catentryType_bundle"))%>"';
		case "DynamicKitBean":
			return 'SRC="/wcs/images/tools/catalog/dynamkit_grey.gif" ALT="<%=UIUtil.toJavaScript((String)rbProduct.get("attribute_catentryType_dynKit"))%>"';
	}
	return "X";
}

/////////////////////////////////////////////////////////////////////////////////////
// generateRowHTML(objRow)
//
// - callback (when a row need to be refreshed)
/////////////////////////////////////////////////////////////////////////////////////
function generateRowHTML(objRow)
{
	var strRow;
	
	var strColorDuplicatedRow;
	if(objRow.bDuplicated)
		strColorDuplicatedRow=" STYLE='COLOR:"+ COLOR_INVALID_TARGET+"' ";
	else
		strColorDuplicatedRow="";
	
	
	//Partnumber and Name
	var escapedName = escapeSpecialCharacters(objRow.oTarget.name);
	strRow  = generateCellHTML("STRING",objRow.oTarget.partNumber,strColorDuplicatedRow + " width=" + partNumberWidth + " title='" + escapedName + "' ",true );
	strRow += generateCellHTML("IMAGE",elementType(objRow.oTarget.type) );
	strRow += generateCellHTML("STRING",objRow.oTarget.name,strColorDuplicatedRow + " width=" + nameWidth + " style='" + displayNone + "' ",true );

	//MAssoc and Semantic
	if( (m_bShowCommonTargets) || (objRow.getFlag()==FLAG_UNEDITABLE) || (readonlyAccess == true))
	{
		//If not allowed to change
		strRow += generateCellHTML("STRING",objRow.oTarget.associationType,strColorDuplicatedRow,true);
		strRow += generateCellHTML("STRING",objRow.oTarget.semantic,strColorDuplicatedRow,true);
	}
	else
	{
		//If it's allowed to change MAssocType and Semantic
		MASelection['SELECTED']= objRow.oTarget.associationType;
		strRow += generateCellHTML("DROPDOWN",MASelection, strColorDuplicatedRow+" onchange=\"MAssocType_onChange(event)\" ", 'columnAssociation');
		MASemanticSelection['SELECTED']= objRow.oTarget.semantic;
		strRow += generateCellHTML("DROPDOWN",MASemanticSelection, strColorDuplicatedRow+" onchange=\"MASematic_onChange(event)\" ", 'columnSemantic');
	}
		
	if(!m_bShowCommonTargets)
	{
		var strDate ="&nbsp;<input  disabled name='year' onchange='Date_onChange()' CLASS=WITH_BORDER STYLE='right: 0; left: 0; padding: 0; margin: 0; width: 43;' value='"+ objRow.oTarget.year+"'></input>";
			strDate +="<input  disabled name='month' onchange='Date_onChange()' CLASS=WITH_BORDER STYLE='right: 0; left: 0; padding: 0; margin: 0; width: 23;' value='"+ objRow.oTarget.month+"'></input>";
		 	strDate +="<input  disabled name='day' onchange='Date_onChange()' CLASS=WITH_BORDER STYLE='right: 0; left: 0; padding: 0; margin: 0; width: 23;' value='"+ objRow.oTarget.day+"'></input>";
		 	strDate +="<IMG SRC='/wcs/images/tools/calendar/calendar.gif' CLASS=WITH_BORDER BORDER=0 id=calImg1 alt='<%=UIUtil.toJavaScript((String)nlsMAssoc.get("columnDateCalendar"))%>'>";

		var strColorQty="";
		var strTempQty= convertToFormatedString(objRow.oTarget.qty);
		if(strTempQty==null)
		{
			strColorQty=" STYLE='COLOR:"+ COLOR_INVALID_NUMBER+"' ";
			strTempQty= objRow.oTarget.qty;
		}
		else
			strColorQty=" STYLE='COLOR:"+ COLOR_VALID_NUMBER+"' ";	
			
	
		if(objRow.getFlag()==FLAG_UNEDITABLE || readonlyAccess == true)
		{
			strRow += generateCellHTML("STRING",strDate," width=125 ",false,true);
			strRow += generateCellHTML("STRING_NUMBER",strTempQty,strColorQty);
		}	
		else	
		{
			strRow += generateCellHTML("STRING",strDate," onclick=\"Date_onClick()\" ",false,true);
			strRow += generateCellHTML("INPUT_NUMBER",strTempQty,strColorQty+" onchange=\"Qty_onChange()\" ", 'columnQty');
		}	
	}	

	return strRow;	
}

/////////////////////////////////////////////////////////////////////////////////////
// Vector skuIsReady()
//
// - call by hidden JSP when the list of SKU are ready
/////////////////////////////////////////////////////////////////////////////////////
function skuIsReady() {

	var bTableChanged 		= false;
	var arrayDuplicatedSKUs	= new Array();
	var skuArray 			= cloneSKUArray(parent.Hidden.getSku());

	// go through the sku list and check for duplicates
	for (var i = 0; i < skuArray.length; i++) {
	
		var oSKU = skuArray[i];
		
		if(!parent.Source.addSKUToSelectedSources(oSKU, false)) {
			arrayDuplicatedSKUs[arrayDuplicatedSKUs.length] = oSKU;
		}
		bTableChanged = true;
	
	}

	// update table when the content is modified
	if (bTableChanged) {
		
		parent.Source.drawDTable(parent.Source.divDTable);
		
		if(parent.Source.getDTNumberOfSelectedRows() > 1) {
			parent.SourceBtn.btnCommonTargets_onclick();
		} else {
			parent.Source.onChangeSelection();
		}
	}		
	
	// display error message when duplicates are found
	if (arrayDuplicatedSKUs.length > 0) {
		
		var strTemp="<br>";
		
		for(var i = 0; i < arrayDuplicatedSKUs.length; i++) {
			strTemp+="<br>&nbsp&nbsp&nbsp&nbsp" + changeJavaScriptToHTML(arrayDuplicatedSKUs[i].partNumber) + "&nbsp&nbsp&nbsp&nbsp" + changeJavaScriptToHTML(arrayDuplicatedSKUs[i].name);
		}
		
		strTemp += "<br><br>";	
		alertDialog("<%=getNLString(nlsMAssoc,"msgDuplicatedSKUs")%>" + strTemp);
	}	
}

/////////////////////////////////////////////////////////////////////////////////////
// onChangeSelection()
//
// - callback (when selection changed)
/////////////////////////////////////////////////////////////////////////////////////
function onChangeSelection()
{
	// interact with other fames
	var nNumberOfSelectedRows=getDTNumberOfSelectedRows();

	if(m_bShowCommonTargets)
		parent.TargetBtn.enableButtons(2,nNumberOfSelectedRows);
	else
		parent.TargetBtn.enableButtons(1,nNumberOfSelectedRows);
}

/////////////////////////////////////////////////////////////////////////////////////
// preChangeSelection()
//
// - if it's allowed to change selection
/////////////////////////////////////////////////////////////////////////////////////
function preChangeSelection()
{
	//if( (m_winCalender!=null) && (!m_winCalender.closed))
	//	m_winCalender.close();
		
	return true;
}

/////////////////////////////////////////////////////////////////////////////////////
// validateAndSaveData()
//
// - validate the target list table, 
//	 popup message if invalid entries are found
//	 save the data if the data is valid
/////////////////////////////////////////////////////////////////////////////////////
function validateAndSaveData()
{
	// if show common contents, nothing editable
	if(m_bShowCommonTargets)				
		return true;

	var tableContents=getDTContents();

	var nInvalidNumbers=0;
	for(var i=0; i< tableContents.length; i++)
	{
		var oRow = tableContents[i];
		
		if((oRow.flag==FLAG_NONE)||(oRow.flag==FLAG_UNEDITABLE))
			continue;
	
		var strNumber=""+oRow.oTarget.qty;		
		if(!parent.parent.isValidNumber(strNumber,<%= cmdContext.getLanguageId()%>,true))
			nInvalidNumbers++;
		else
			oRow.oTarget.qty= parent.parent.strToNumber(strNumber,<%= cmdContext.getLanguageId()%>);	
	}

	if(nInvalidNumbers>0)
	{
		drawDTable(divDTable);
		alertDialog("<%=getNLString(nlsMAssoc,"msgInvalidNumber")%>");
		return false;
	}
	
	
	for(var i=0; i< tableContents.length; i++)
	  if(tableContents[i]['bDuplicated'] == true)
	  {
		alertDialog("<%=getNLString(nlsMAssoc,"msgDuplicatedTargets")%>");
		return false;
	  }	

	for(var i=0; i< tableContents.length; i++)
	  if(tableContents[i]['bDuplicated'] == "replacement")
	  {
		alertDialog("<%=UIUtil.toJavaScript(getNLString(nlsMAssoc,"msgReplacementTargets"))%>");
		return false;
	  }	


	return true;
}

/////////////////////////////////////////////////////////////////////////////////////
// checkDuplicatedTargets()
//
// - validate the target list table, 
//	 popup message if invalid entries are found
//	 save the data if the data is valid
/////////////////////////////////////////////////////////////////////////////////////
function checkDuplicatedTargets()
{
	var tableContents=getDTContents();

	var nInvalidRows=0;
	for(var i=0; i< tableContents.length; i++)
	 	tableContents[i]['bDuplicated']=false;


	if (parent.Source.getDTNumberOfSelectedRows() == 1)
	{
		var sourceIndex = parent.Source.nextDTSelectedRowId();
		var oSourceRow = parent.Source.getDTRow(sourceIndex);
		var sourceType = oSourceRow.oSource.type + "Bean";
	}

	for(var i=0; i< tableContents.length; i++)
	{
		var oRow = tableContents[i];
		
		var targetType = oRow.oTarget.type;
		if (oRow.oTarget.associationType == "REPLACEMENT" && sourceType != targetType)
		{
			oRow['bDuplicated']="replacement";
			nInvalidRows+=1;
		}
		
		if(!oRow.bDuplicated)	
		{

			for(var k=i+1; k<tableContents.length; k++)
			{
				if(oRow.oTarget.equals(tableContents[k].oTarget))
				{
					oRow['bDuplicated']=true;
					tableContents[k]['bDuplicated']=true;
					nInvalidRows+=2;
				}
			}
		}	
	}
	
	if(nInvalidRows>0)
		return true;
	else
		return false;	
}

/////////////////////////////////////////////////////////////////////////////////////
// convertToFormatedString(num)
//
// - convert a num/string to a formated string
//	 return a formated string if it's a correct number, or null if it's not correct
/////////////////////////////////////////////////////////////////////////////////////
function convertToFormatedString(num)
{
	var strRet;
	
	var strNumber=""+num;
	var numNumber=(typeof num =='number')? num:parent.parent.strToNumber(num,<%= cmdContext.getLanguageId()%>);
	
	if(!parent.parent.isValidNumber(strNumber,<%= cmdContext.getLanguageId()%>,true))
		strRet = null;
	else
		strRet=parent.parent.numberToStr(numNumber,<%= cmdContext.getLanguageId()%>);

	if((strRet!=null) && (strRet!='NaN'))
		return strRet;
		
	return null;	
}

/////////////////////////////////////////////////////////////////////////////////////
// Qty_onChange()
//
// - event handler (the Quantity column)
/////////////////////////////////////////////////////////////////////////////////////
function Qty_onChange()
{
	var nRowId=event.srcElement.parentElement.parentElement.rowIndex-1;
	
	var oRow = getDTRow(nRowId);
	oRow.setFlag(FLAG_CHANGED);

	oRow.oTarget.setAction(ACTION_UPDATE);
	var strNum=event.srcElement.value;
	if(strNum=="")
		strNum=0;
	strNum=convertToFormatedString(strNum);
	
	if(strNum==null)
	{
		oRow.oTarget.qty=convertFromTextToHTML(event.srcElement.value);
		event.srcElement.style.color=COLOR_INVALID_NUMBER;
	}
	else
	{
		oRow.oTarget.qty=event.srcElement.value=strNum;
		event.srcElement.style.color=COLOR_VALID_NUMBER;
	}	

	refreshDTRowByFlag(nRowId);
	//drawDTable(divDTable);
	
	//also need to tell the parent list (Qty is for single row)
	var nParentRowId=parent.Source.nextDTSelectedRowId();
	var oParentRow=parent.Source.getDTRow(nParentRowId);
	oParentRow.setFlag(FLAG_CHANGED);
	parent.Source.refreshDTRowByFlag(nParentRowId);
}

/////////////////////////////////////////////////////////////////////////////////////
// Date_onClick()
//
// - event handler (the Date column)
/////////////////////////////////////////////////////////////////////////////////////
var m_winCalender=null;
var m_oTDCalender=null;
function Date_onClick()
{
	closeWinCalender();
	
	var oTD=event.srcElement;
	if(oTD.className=="WITH_BORDER")
		oTD=oTD.parentElement;
		
	if (oTD.children != null) {
		window.yearField = oTD.children['year'];
		window.monthField = oTD.children['month'];
		window.dayField = oTD.children['day'];
	}
	
	var strCalendar=top.getWebPath()+'Calendar';
	m_winCalender = window.open(strCalendar, '', 'width=200, height=250, left=410, top=200');
	
	m_winCalender.attachEvent('onunload',Date_onChange);
	
	//m_winCalender.attachEvent('onblur',closeWinCalender);
	//m_winCalender.attachEvent('ondeactivate',closeWinCalender);
	
	m_oTDCalender=oTD;
}

/////////////////////////////////////////////////////////////////////////////////////
// closeWinCalender()
//
// - close the window
/////////////////////////////////////////////////////////////////////////////////////
function closeWinCalender()
{
	if( (m_winCalender!=null) && (!m_winCalender.closed))
		m_winCalender.close();
}
/////////////////////////////////////////////////////////////////////////////////////
// Date_onChange()
//
// - event handler (the Date column)
/////////////////////////////////////////////////////////////////////////////////////
function Date_onChange()
{
	if(m_oTDCalender==null) return;
	if(!defined(m_oTDCalender.parentElement))	return;
	if(!defined(m_oTDCalender.parentElement.rowIndex))	return;

	var nRowId=m_oTDCalender.parentElement.rowIndex-1;
	
	var oRow = getDTRow(nRowId);
	oRow.setFlag(FLAG_CHANGED);

	var oTD=m_oTDCalender;
	
	oRow.oTarget.setAction(ACTION_UPDATE);

	if (oTD.children != null) {
		oRow.oTarget.year=oTD.children['year'].value;
		oRow.oTarget.month=oTD.children['month'].value;
		oRow.oTarget.day=oTD.children['day'].value;
	}
	
	refreshDTRowByFlag(nRowId);
	
	//also need to tell the parent list (may affect many rows)
	var nParentRowId=parent.Source.nextDTSelectedRowId();
	while(nParentRowId>=0)
	{
		var oParentRow=parent.Source.getDTRow(nParentRowId);
		oParentRow.setFlag(FLAG_CHANGED);
		parent.Source.refreshDTRowByFlag(nParentRowId);
		
		nParentRowId = parent.Source.nextDTSelectedRowId(nParentRowId);
	}
}

/////////////////////////////////////////////////////////////////////////////////////
// MAssocType_onChange()
//
// - event handler (the MAssocType column)
/////////////////////////////////////////////////////////////////////////////////////
function MAssocType_onChange(event)
{

	var nRowId=event.srcElement.parentElement.parentElement.rowIndex-1;

	var oRow = getDTRow(nRowId);
	
	//we may need to remove the old target and create a new one to update
	var oTargetNew = parent.Source.preUpdateTarget(oRow.oTarget);
	if(oTargetNew==null)
		return;
	else
		oRow.oTarget=oTargetNew;	
	
	oRow.setFlag(FLAG_CHANGED);

	oRow.oTarget.setAction(ACTION_UPDATE);
	oRow.oTarget.associationType=event.srcElement.value;
	
	checkDuplicatedTargets();
	drawDTable(divDTable);
	
	//refreshDTRowByFlag(nRowId);
	
	//also need to tell the parent list (may affect many rows)
	var nParentRowId=parent.Source.nextDTSelectedRowId();
	while(nParentRowId>=0)
	{
		var oParentRow=parent.Source.getDTRow(nParentRowId);
		oParentRow.setFlag(FLAG_CHANGED);
		parent.Source.refreshDTRowByFlag(nParentRowId);
		
		nParentRowId = parent.Source.nextDTSelectedRowId(nParentRowId);
	}
}

/////////////////////////////////////////////////////////////////////////////////////
// MASematic_onChange()
//
// - event handler (the Semantic column)
/////////////////////////////////////////////////////////////////////////////////////
function MASematic_onChange(event)
{
	var nRowId=event.srcElement.parentElement.parentElement.rowIndex-1;
	
	var oRow = getDTRow(nRowId);

	//we may need to remove the old target and create a new one to update
	var oTargetNew = parent.Source.preUpdateTarget(oRow.oTarget);
	if(oTargetNew==null)
		return;
	else
		oRow.oTarget=oTargetNew;	
	
	oRow.setFlag(FLAG_CHANGED);

	oRow.oTarget.setAction(ACTION_UPDATE);
	oRow.oTarget.semantic=event.srcElement.value;

	checkDuplicatedTargets();
	drawDTable(divDTable);
	//refreshDTRowByFlag(nRowId);
	
	//also need to tell the parent list (may affect many rows)
	var nParentRowId=parent.Source.nextDTSelectedRowId();
	while(nParentRowId>=0)
	{
		var oParentRow=parent.Source.getDTRow(nParentRowId);
		oParentRow.setFlag(FLAG_CHANGED);
		parent.Source.refreshDTRowByFlag(nParentRowId);
		
		nParentRowId = parent.Source.nextDTSelectedRowId(nParentRowId);
	}
}

/////////////////////////////////////////////////////////////////////////////////////
// moveUpSelectedTarget()
//
// - move up the selected Target
/////////////////////////////////////////////////////////////////////////////////////
function moveUpSelectedTarget()
{
	var nRowId = nextDTSelectedRowId();
	var toRowId = nRowId - 1;
	var oRow =	getDTRow(nRowId);
	
	if(oRow!=null)
		parent.Source.moveUpTargetInSelectedSource(oRow.oTarget);

	setDTRowSelected(toRowId, true);
	hiLiteDTSelectedRows();
	onChangeSelection();
}

/////////////////////////////////////////////////////////////////////////////////////
// moveDownSelectedTarget()
//
// - move down the selected Target 
/////////////////////////////////////////////////////////////////////////////////////
function moveDownSelectedTarget()
{
	var nRowId = nextDTSelectedRowId();
	var toRowId = nRowId + 1;
	var oRow =	getDTRow(nRowId);
	
	if(oRow!=null)
		parent.Source.moveDownTargetInSelectedSource(oRow.oTarget);

	setDTRowSelected(toRowId, true);
	hiLiteDTSelectedRows();
	onChangeSelection();
}

/////////////////////////////////////////////////////////////////////////////////////
// removeSelectedTargets()
//
// - remove the selected Targets 
/////////////////////////////////////////////////////////////////////////////////////
function removeSelectedTargets()
{
	var tableContents=getDTContents();
	var bTableChanged=false;

	for(var i=0; i< tableContents.length; i++)
	{
		var oRow = tableContents[i];
		
		if(oRow.bSelected)
		{
			parent.Source.removeTargetFromSelectedSources(oRow.oTarget, false);			// remove but do not refresh
			bTableChanged=true;
		}		
	}//Eof for
	
	if(bTableChanged)
	{
		parent.Source.drawDTable(parent.Source.divDTable);
		if(parent.Source.getDTNumberOfSelectedRows()>1)
			parent.SourceBtn.btnCommonTargets_onclick();
		else
			parent.Source.onChangeSelection();
	}	
}

/////////////////////////////////////////////////////////////////////////////////////
// populateData(arrayTargets, bEditable, arraySelectedRowId)
//
// - populate data for the Target List table
/////////////////////////////////////////////////////////////////////////////////////
function populateData(arrayTargets, arraySelectedRowId)
{
	clearDTContents();
	
	if(arrayTargets==null)
		return;

	for(var i=0;i<arrayTargets.length;i++)
	{
		var oTarget = arrayTargets[i];
		
		if(oTarget.action == ACTION_REMOVE)							//do not show the removed one
			continue;
			
		var oRow= new DTRow(oTarget.associationId);
		
		if(oTarget.action == ACTION_ADD)							// Bolder new and changed ones
			oRow.setFlag(FLAG_NEW);							
		else if (oTarget.action == ACTION_UPDATE)
			oRow.setFlag(FLAG_CHANGED);
		
		oRow.oTarget = oTarget;		
		
		if(!oTarget.editable)
		{
			//oRow.setFlag(FLAG_UNEDITABLE);
			oRow.flag=FLAG_UNEDITABLE;
		}	
			
		addDTRow(oRow);
	}
	
	if(arraySelectedRowId!=null)
		for(var i=0; i< arraySelectedRowId.length; i++)
			setDTRowSelected(arraySelectedRowId[i],true);
			
	checkDuplicatedTargets();		
}

/////////////////////////////////////////////////////////////////////////////////////
// variables for switching the Target List for a single or multiple Sources
/////////////////////////////////////////////////////////////////////////////////////
var m_bShowCommonTargets=false;
var m_bShowCommonTargetsRefreshed=false;

/////////////////////////////////////////////////////////////////////////////////////
// showCommonContent( bContentAlreadyRefreshed)
//
// - show common Targets for multiple Source
/////////////////////////////////////////////////////////////////////////////////////
function showCommonContent( bContentAlreadyRefreshed)
{
	m_bShowCommonTargets=true;
	m_bShowCommonTargetsRefreshed = bContentAlreadyRefreshed; 
	
	var strTitle = "<H1> <%= getNLString(nlsMAssoc,"titleCommonContents")%> </H1>";
	divTitle.innerHTML = strTitle;
	
	var	strText; 
	if(!bContentAlreadyRefreshed)
	{
		divDTable.style.height="64px";
		strText= "<%= getNLString(nlsMAssoc,"instructionCommonContents")%>";
	}	
	else
	{
		if(getDTContents().length>0)
		{
			divDTable.style.height="228px";
			strText="";
		}
		else
		{
			divDTable.style.height="64px";
			strText= "<%=getNLString(nlsMAssoc,"instructionEmptyCommonContents")%>";
		}	
	}	

	onChangeMassocTypeList();
		
	divText.innerHTML = strText;
	
	parent.TargetBtn.enableButtons(2,getDTNumberOfSelectedRows());

}

/////////////////////////////////////////////////////////////////////////////////////
// showSimpleContent(nNumberOfPackages)
//
// - show Targets for a single Source
/////////////////////////////////////////////////////////////////////////////////////
function showSimpleContent(nNumberOfPackages)
{
	m_bShowCommonTargets=false;
	
	//Title	
	var strTitle = "<H1> <%= getNLString(nlsMAssoc,"titleSimpleContents")%> </H1>";
	divTitle.innerHTML = strTitle;

	//DTable
	if(getDTContents().length>0)
		divDTable.style.height="228px";
	else
		divDTable.style.height="64px";

		
	onChangeMassocTypeList();

	//Instruction
	if(getDTContents().length>0)
		divText.innerHTML = "";
	else
	{
		if(nNumberOfPackages>0) 
			divText.innerHTML = "<%=getNLString(nlsMAssoc,"instructionEmptySimpleContents")%>"
			//divText.innerHTML = "<%=getNLString(nlsMAssoc,"instructionEmptySimpleContents")%>";
		else
			divText.innerHTML = "<%=getNLString(nlsMAssoc,"instructionSimpleContents")%>";
	}	
		 
	parent.TargetBtn.enableButtons(nNumberOfPackages,getDTNumberOfSelectedRows());
	
}

/////////////////////////////////////////////////////////////////////////////////////
// init(tableContents, tableRemovedRows, bShowCommonContents, bCommotContentsRefreshed)
//
// - initialize this frame
/////////////////////////////////////////////////////////////////////////////////////
function init(tableContents, tableRemovedRows, bShowCommonContents, bCommotContentsRefreshed)
{
	m_aRows			= tableContents;				
	m_aRowsRemoved 	= tableRemovedRows;

	//redraw the table		
	if(!bShowCommonContents)
		showSimpleContent(parent.Source.getDTNumberOfSelectedRows());
	else
		showCommonContent(bCommotContentsRefreshed);	
}

/////////////////////////////////////////////////////////////////////////////////////
// _onunload()
//
// - when unload the frame, we may need to close the popup window
/////////////////////////////////////////////////////////////////////////////////////
function _onunload()
{
	if( (m_winCalender!=null) && (!m_winCalender.closed))
		m_winCalender.close();
}

/////////////////////////////////////////////////////////////////////////////////////
// _onload()
//
// - when loading the frame set up the defaults
/////////////////////////////////////////////////////////////////////////////////////
function _onload()
{
	var selectedType = default_ma_saved_type;
	for (var i=0; i<massocTypeList.length; i++)
	{
		if (massocTypeList.options[i].value == selectedType) massocTypeList.options[i].selected = true;
	}
	displayMassocTypeList(selectedType);
}

/////////////////////////////////////////////////////////////////////////////////////
// showDropdown(s)
//
// - show or hide all dropdown boxes
/////////////////////////////////////////////////////////////////////////////////////
function showDropdown(s)
{
	showAllDropdowns(s);
}

/////////////////////////////////////////////////////////////////////////////////////
// onChangeMassocTypeList()
//
// - display associations of selected type.
/////////////////////////////////////////////////////////////////////////////////////
function onChangeMassocTypeList()
{
	setDTAllRowsSelected(false);
	var selectedType = massocTypeList.value;
	CURRENT_MA_TYPE = selectedType;
	displayMassocTypeList(selectedType);
	
	// reset buttons
	onChangeSelection();
}

/////////////////////////////////////////////////////////////////////////////////////
// displayMassocTypeList(selectedType)
//
// @param selectedType - the selected type to display or "0" to display all types
//
// - display associations of selected type.
/////////////////////////////////////////////////////////////////////////////////////
function displayMassocTypeList(selectedType)
{
	top.saveData(selectedType, "default_ma_type");

	var tableContents=getDTContents();
	for(var i=0; i< tableContents.length; i++)
	{
		var oRow = tableContents[i];
		oRow.displayRow = true;

		var currentType = oRow.oTarget.associationType;
		if (selectedType != "0" && selectedType != currentType)
		{
			oRow.displayRow = false;
		}
	}
	drawDTable(divDTable);
}


</SCRIPT>

<META name="GENERATOR" content="IBM WebSphere Studio">
</HEAD>

<BODY CLASS="content" onUnload="_onunload()" onLoad="_onload()">
<!- Place holder for title->
<DIV id=divTitles >
<TABLE WIDTH=100% BORDER=0>
	<TR>
		<TD ALIGN=LEFT>
			<SPAN id=divTitle></SPAN>
		</TD>
		<TD ALIGN=RIGHT>
			<label for='filterName'><%=getNLString(nlsMAssoc,"filterName")%></label>&nbsp;
			<SELECT id='filterName' NAME=massocTypeList ONCHANGE="onChangeMassocTypeList()">
				<OPTION VALUE=0 SELECTED><%=UIUtil.toHTML((String)nlsMAssoc.get("allAvailableType"))%></OPTION>
<%
				for(int i=0; i<vMATypes.size(); i++)
				{
					MAssocDisplayObject mAssocDisplayObject = (MAssocDisplayObject) vMATypes.elementAt(i); 
					String strType = mAssocDisplayObject.getIdentifier();
					String strTypeDisplay = mAssocDisplayObject.getDisplayStr();

%>
					<option value="<%=strType%>" > <%=UIUtil.toHTML(strTypeDisplay)%></option>
<%
	} 
%>
			</SELECT>
		</TD>
</TABLE>
</DIV>

<!- Place holder for the dynamic table ->
<DIV id=divDTable STYLE="overflow: auto; width:100%; "></DIV>

<!- Place holder for hint text ->
<DIV id=divText></DIV>

<!- Place holder for ToolTip ->
<DIV id=divToolTip CLASS=TOOLTIP></DIV>

<!- hidden DIV for calcuating the dropdown sizes ->
<DIV id=divSize STYLE="overflow: auto; display:block; visibility:hidden; position:absolute; top:0; left:0; z-index:-1">
	<TABLE CLASS=DTABLE border=1 cellSpacing=0 cellPadding=0 style="margin-top: 0px; margin-right: 0px;">
		<TR CLASS=DTABLE_TR0 >
			<TD CLASS=DTABLE_TD >
			    <label for="dpMassocTypeSize"><%=getNLString(nlsMAssoc,"columnAssociation")%></label>
				<select id="dpMassocTypeSize" style="font-family: Verdana,Arial,Helvetica; font-size: 10pt; color: black; word-wrap: break-word; height: 21px;" size=1>
				<%				
					for(int i=0; i<vMATypes.size(); i++)
					{
						MAssocDisplayObject mAssocDisplayObject = (MAssocDisplayObject) vMATypes.elementAt(i); 
						String strType = mAssocDisplayObject.getIdentifier();
						String strTypeDisplay = mAssocDisplayObject.getDisplayStr();
				%>	
					<option value="<%=strType%>" > <%=UIUtil.toHTML(strTypeDisplay)%>
					</option>
				<%} %>	
				</select>
			</TD>		
			<TD CLASS=DTABLE_TD >
			    <label for="dpMassocSemanticSize"><%=getNLString(nlsMAssoc,"columnSemantic")%></label>
				<select id="dpMassocSemanticSize" style="font-family: Verdana,Arial,Helvetica; font-size: 10pt; color: black; word-wrap: break-word; height: 21px;" size=1>
				<%				
				for(int i=0; i<vMASemantics.size(); i++)
				{
					MAssocDisplayObject mAssocDisplayObject = (MAssocDisplayObject) vMASemantics.elementAt(i); 
					String strSemantic = mAssocDisplayObject.getIdentifier();
					String strSemanticDisplay = mAssocDisplayObject.getDisplayStr();
				%>	
					<option value="<%=strSemantic%>" > <%=UIUtil.toHTML(strSemanticDisplay)%>
					</option>
				<%} %>	
				</select>
			</TD>		

		</TR> 
	</TABLE>
	
</DIV>
 
</BODY>

<script>
    document.body.style.scrollbarBaseColor = 'lavender';
    setToolTipDiv(divToolTip);
	parent.initAllFrames();
</script>

</HTML>

