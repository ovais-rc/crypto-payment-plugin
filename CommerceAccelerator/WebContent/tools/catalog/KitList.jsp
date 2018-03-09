<%--
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2002, 2003
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
//*
--%>


<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
<%
//---------------------------------------------------------------------
//- Import and Include Section
//---------------------------------------------------------------------
%>
<%@ page language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="com.ibm.commerce.server.*" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.tools.util.UIUtil" %>
<%@ page import="com.ibm.commerce.tools.catalog.commands.PackageBundleContentsCmd" %>
<%@ page import="com.ibm.commerce.tools.catalog.beans.AccessControlHelperDataBean" %>
<%@ page import="com.ibm.commerce.beans.DataBeanManager" %>
<%@ include file="../common/common.jsp" %>
<%@ include file="KitUtil.jsp" %> 

<%@ page import="com.ibm.commerce.beans.DataBeanManager" %>

<%@ page import="com.ibm.commerce.catalog.objects.*" %>
<%@ page import="com.ibm.commerce.catalog.beans.*" %>


<%
	CommandContext 	cmdContext = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
   	Locale 			jLocale = cmdContext.getLocale();
    Hashtable		nlsKit = (Hashtable) ResourceDirectory.lookup("catalog.KitNLS", jLocale);
 	Hashtable rbProduct = (Hashtable)ResourceDirectory.lookup("catalog.ProductNLS", cmdContext.getLocale());

	String myInterfaceName = PackageBundleContentsCmd.NAME;
	AccessControlHelperDataBean myACHelperBean= new AccessControlHelperDataBean();
	myACHelperBean.setInterfaceName(myInterfaceName);
	DataBeanManager.activate(myACHelperBean,cmdContext);

%>


<HTML>
<HEAD>

<LINK rel=stylesheet href="<%= UIUtil.getCSSFile(jLocale) %>" type="text/css">
<link rel=stylesheet href="/wcs/tools/catalog/DTable.css" type="text/css">

<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/common/Vector.js"></SCRIPT>

<SCRIPT SRC="/wcs/javascript/tools/catalog/KitContents.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/catalog/DTable.js"></SCRIPT>

<SCRIPT LANGUAGE="JavaScript">

	var readonlyAccess = <%=myACHelperBean.isReadOnly()%>;

/////////////////////////////////////////////////////////////////////////////////////
// generateHeadHTML()
//
// - callback (when a table need to be refreshed)
/////////////////////////////////////////////////////////////////////////////////////
function generateHeadHTML()
{
	var strHead;
	
    strHead = "<TD CLASS=COLHEAD STYLE='width: 200' id=partNumber><%=getNLString(nlsKit,"columnPartNumber")%></TD>";
    strHead += "<TD CLASS=COLHEAD STYLE='width: 22' id=type>&nbsp</TD>";
    strHead += "<TD CLASS=COLHEAD STYLE='width: 75%' id=name><%=getNLString(nlsKit,"columnName")%></TD>";
    strHead += "<TD CLASS=COLHEAD STYLE='width: 120' id=numberOfskus><%=getNLString(nlsKit,"columnSKUs")%></TD>";
    
    return strHead;
}

/////////////////////////////////////////////////////////////////////////////////////
// generateRowHTML(objRow)
//
// - callback (when a row need to be refreshed)
/////////////////////////////////////////////////////////////////////////////////////
function generateRowHTML(objRow)
{
	var strRow;
	
	strRow  = generateCellHTML("STRING",objRow.oKit.partNumber,null,true );
	strRow += generateCellHTML("IMAGE",elementType(objRow.oKit.type) );
	strRow += generateCellHTML("STRING",objRow.oKit.name,null,true );
	strRow += generateCellHTML("STRING_NUMBER",parent.parent.numberToStr(objRow.oKit.numberOfskus,<%= cmdContext.getLanguageId()%>,0) );
	
	return strRow;	
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
			case "Package":
				return 'SRC="/wcs/images/tools/catalog/bundle_grey.gif" ALT="<%=UIUtil.toJavaScript((String)rbProduct.get("attribute_catentryType_package"))%>"';
			case "Bundle":
				return 'SRC="/wcs/images/tools/catalog/package_grey.gif" ALT="<%=UIUtil.toJavaScript((String)rbProduct.get("attribute_catentryType_bundle"))%>"';
			case "DynamicKit":
				return 'SRC="/wcs/images/tools/catalog/dynamkit_grey.gif" ALT="<%=UIUtil.toJavaScript((String)rbProduct.get("attribute_catentryType_dynKit"))%>"';
		}
		return "X";
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

	parent.ListBtn.enableButtons(nNumberOfSelectedRows);
	
	if(nNumberOfSelectedRows >1)
	{
		parent.Content.populateData(null);					// pass in empty arry, until finishing selection 
		parent.Content.showCommonContent(false);			// not updated, until click the button
	}	
	else
	{
		if(nNumberOfSelectedRows==0)
			parent.Content.populateData(null);
		else 
		{
			var nSelectedRowId=nextDTSelectedRowId(-1);
 			
			parent.Content.populateData(getDTRow(nSelectedRowId).oSKUArray,isDTSelectedRowEditable());
		}		  	
		
		parent.Content.showSimpleContent(nNumberOfSelectedRows);
	}
}

/////////////////////////////////////////////////////////////////////////////////////
// preChangeSelection()
//
// - if it's allowed to change selection
/////////////////////////////////////////////////////////////////////////////////////
function preChangeSelection()
{
	return parent.Content.validateAndSaveData();
}

/////////////////////////////////////////////////////////////////////////////////////
// getNLType(strType)
//
// - get NL description for Catentry types
/////////////////////////////////////////////////////////////////////////////////////
function getNLType(strType)
{
	var strNLType;
	
	if(strType=="Package")
		strNLType="<%= getNLString(nlsKit,"typePackage")%>";
	else if(strType=="Bundle")
		strNLType="<%= getNLString(nlsKit,"typeBundle")%>";
	else if(strType=="DynamicKit")
		strNLType="<%= getNLString(nlsKit,"typeDynamicKit")%>";
	else
		strNLType="";	
		
	return strNLType;	
}

/////////////////////////////////////////////////////////////////////////////////////
// getCommonSKUsOfSelectedPBs
//
// - get common SKUs in selected Kits
/////////////////////////////////////////////////////////////////////////////////////
function getCommonSKUsOfSelectedPBs()
{
	var aCommonSKUs = new Array();
	var tableContents = getDTContents();
	
	for(var i=0; i< tableContents.length; i++)
	{
		if(isDTRowSelected(i))
		{
			var oRow =getDTRow(i);
			var arraySKUs= oRow.oSKUArray;
			
			if(aCommonSKUs.length == 0)						// the first selected PB
			{
				for(var k=0; k<arraySKUs.length; k++)		// copy the array (reference is ok)	
				  if(arraySKUs[k].action != ACTION_REMOVE)
					aCommonSKUs[aCommonSKUs.length]= arraySKUs[k];
			}
			else											// other selected PB
			{
				for(var k=0; k<aCommonSKUs.length; k++)		// remove skus if not common
				  if(! isSKUinArray(aCommonSKUs[k].partNumber, arraySKUs))
				  {
						aCommonSKUs.splice(k, 1);
						k--;
				  }
			}			
			
			if(aCommonSKUs.length==0)						// nothing in common so far, break
				break;
							
		}//Eof if oRow.bSelected
		
	}//Eof for
	
	return aCommonSKUs;
}

/////////////////////////////////////////////////////////////////////////////////////
// removeSKUFromSelectedPBs(oSKU, bRefresh)
//
// - remove a SKU from selected Kits
/////////////////////////////////////////////////////////////////////////////////////
function removeSKUFromSelectedPBs(oSKU, bRefresh)
{
	var tableContents=getDTContents();
	
	for(var i=0; i< tableContents.length; i++)
	{
		if( isDTRowSelected(i))		
		{
			var oRow = tableContents[i];
			var arraySKUs= oRow.oSKUArray;

			var bFoundInArray = false;
			var bRowChanged = false;
			for(var k=0; (k< arraySKUs.length) && (!bFoundInArray); k++)
			{
				if(arraySKUs[k].partNumber == oSKU.partNumber)
				{
					bFoundInArray=true;
					
					switch(arraySKUs[k].action)
					{
						case ACTION_ADD:							// it's a new one, remove it 
										arraySKUs.splice(k,1);
										bRowChanged=true;
										break;	
										
						case ACTION_NONE:
						case ACTION_UPDATE:							// existing one, mark for remove
										arraySKUs[k].action = ACTION_REMOVE;
										bRowChanged=true;
										break;
										
						case ACTION_REMOVE:
										break;						// already removed, nothing to do, warning msg???				
					}
				}
			}// Eof for k
			
			if(bRowChanged)
			{
				oRow.oKit.numberOfskus --;
				oRow.setFlag(FLAG_CHANGED);
				
				if(bRefresh)
					refreshDTRow(i);
			}
		}//Eof if(isDTRowSelected(i))
	}//Eof for
}

/////////////////////////////////////////////////////////////////////////////////////
// addSKUToSelectedPBs(oSKU, bRefresh)
//
// - add a SKU into selected Kits
/////////////////////////////////////////////////////////////////////////////////////
function addSKUToSelectedPBs(oSKU, bRefresh)
{
	var tableContents=getDTContents();
	var bDuplicatedSKU=false;
	
	for(var i=0; i< tableContents.length; i++)
	{
		if( isDTRowSelected(i))		
		{
			var oRow = tableContents[i];
			var arraySKUs= oRow.oSKUArray;

			var bFoundInArray = false;
			var bRowChanged   = false;
			var oSKUAdd = cloneObj(oSKU);
				oSKUAdd.action = ACTION_ADD;						//by default,it's add
				
			for(var k=0; (k< arraySKUs.length) && (!bFoundInArray); k++)
			{
				if(arraySKUs[k].partNumber == oSKUAdd.partNumber)
				{
					bFoundInArray=true;
					switch(arraySKUs[k].action)
					{
						case ACTION_ADD:							
						case ACTION_NONE:
						case ACTION_UPDATE:					
											oSKUAdd.action = ACTION_NONE;
											bDuplicatedSKU=true;
											break;
										
						case ACTION_REMOVE:
											oSKUAdd.action = ACTION_UPDATE;	// removed, change it to update
											arraySKUs.splice(k,1);
											break;						
					}
				}
			}// Eof for k

			// if we need to append the sku at the end of the array
			if((oSKUAdd.action==ACTION_ADD) || (oSKUAdd.action==ACTION_UPDATE))
			{
			    oSKUAdd.qty 	= 1.0;
				
				if(arraySKUs.length>0)
					oSKUAdd.sequence=arraySKUs[arraySKUs.length-1].sequence+ 1.0;
				else
					oSKUAdd.sequence=0.0;
			
				arraySKUs[arraySKUs.length]= oSKUAdd;
				
				oRow.oKit.numberOfskus ++;
				oRow.setFlag(FLAG_CHANGED);

				if(bRefresh)
					refreshDTRow(i);
			} 
		}//Eof if(isDTRowSelected(i))
	}//Eof for

	return (!bDuplicatedSKU);				//if the sku is not duplicated, return true			
}

/////////////////////////////////////////////////////////////////////////////////////
// moveUpSKUInSelectedPB(oSKU)
//
// - move up a SKU in the selected Kit
/////////////////////////////////////////////////////////////////////////////////////
function moveUpSKUInSelectedPB(oSKU)
{
	var bUpdated=false;
	var nRowId=nextDTSelectedRowId();
	var oRow=getDTRow(nRowId);
	var arraySKUs = oRow.oSKUArray;
	var upRowId=-1;
	var nContentsRowId=-1;
	for(var i=0; i< arraySKUs.length; i++)
	{
		if(arraySKUs[i].getAction()== ACTION_REMOVE)
			continue;
			
		if(arraySKUs[i].partNumber != oSKU.partNumber)
		{
			upRowId=i;
			nContentsRowId++;
		}	
		else if(upRowId >=0)	//fount it, make sure it's not the first one
		{
			var sequenceI= arraySKUs[i].sequence;
			var sequenceUpRowId = arraySKUs[upRowId].sequence;
			
			var oSKU=cloneSKU(oSKU);
			arraySKUs[i]=arraySKUs[upRowId];
			arraySKUs[upRowId]=oSKU;			
			
			arraySKUs[i].sequence = sequenceI;
			arraySKUs[upRowId].sequence = sequenceUpRowId;
			
			//mark the two targets to be changed
			arraySKUs[i].setAction(ACTION_UPDATE);
			arraySKUs[upRowId].setAction(ACTION_UPDATE);

			//mark the row has been changed
			oRow.setFlag(FLAG_CHANGED);
			
			bUpdated=true;
			break;
		}
		else					//found it, but it's already the first row
			break;
	}//Eof for
	
	if(bUpdated)
	{
		// refresh the row
		refreshDTRow(nRowId);
	
		//refresh Target List
		var arraySelectRows= new Array();
		arraySelectRows[0]=nContentsRowId;
		
		parent.Content.populateData(oRow.oSKUArray,true,arraySelectRows);
		parent.Content.showSimpleContent(1);
	}
	
}

/////////////////////////////////////////////////////////////////////////////////////
// moveDownSKUInSelectedPB(oSKU)
//
// - move down a SKU in the selected Kit
/////////////////////////////////////////////////////////////////////////////////////
function moveDownSKUInSelectedPB(oSKU)
{
	var bUpdated=false;
	var nRowId=nextDTSelectedRowId();
	var oRow=getDTRow(nRowId);
	var arraySKUs = oRow.oSKUArray;
	var upRowId=-1;
	for(var i=arraySKUs.length-1; i>=0; i--)
	{
		if(arraySKUs[i].getAction()== ACTION_REMOVE)
			continue;
			
		if(arraySKUs[i].partNumber != oSKU.partNumber)
		{
			upRowId=i;
		}	
		else if(upRowId >=0)	//fount it, make sure it's not the first one
		{
			var sequenceI= arraySKUs[i].sequence;
			var sequenceUpRowId = arraySKUs[upRowId].sequence;
			
			//var oSKU=cloneSKU(oSKU);
			arraySKUs[i]=arraySKUs[upRowId];
			arraySKUs[upRowId]=oSKU;			
			
			arraySKUs[i].sequence = sequenceI;
			arraySKUs[upRowId].sequence = sequenceUpRowId;
			
			//mark the two targets to be changed
			arraySKUs[i].setAction(ACTION_UPDATE);
			arraySKUs[upRowId].setAction(ACTION_UPDATE);

			//mark the row has been changed
			oRow.setFlag(FLAG_CHANGED);
			
			bUpdated=true;
			break;
		}
		else					//found it, but it's already the first row
			break;
	}//Eof for
	
	if(bUpdated)
	{
		// refresh the row
		refreshDTRow(nRowId);
	
		//refresh Target List
		var nContentSelecteRowId=-1;
		for(var i=0; i<arraySKUs.length; i++)
		{
			if(arraySKUs[i].getAction()== ACTION_REMOVE)
				continue;

			nContentSelecteRowId++;
				
			if(arraySKUs[i].partNumber == oSKU.partNumber)
				break;	
		} 
		
		var arraySelectRows= new Array();
		arraySelectRows[0]=nContentSelecteRowId;
		
		parent.Content.populateData(oRow.oSKUArray,true,arraySelectRows);
		parent.Content.showSimpleContent(1);
	}
	
}

/////////////////////////////////////////////////////////////////////////////////////
// deleteSelectedPBs()
//
// - delete a Kit
/////////////////////////////////////////////////////////////////////////////////////
function deleteSelectedPBs()
{
	var bTableChanged=false;
	var tableContents = getDTContents();
	
	for(var i=0; i< tableContents.length; i++)
	{
		if(isDTRowSelected(i))
		{
			removeDTRow(i);
			i--;
			bTableChanged=true;
		}
			
	}//Eof for
	
	if(bTableChanged)
	{
		refreshTable();
		onChangeSelection();
	}
}

/////////////////////////////////////////////////////////////////////////////////////
// refreshTable()
//
// - refresh the Kit List table
/////////////////////////////////////////////////////////////////////////////////////
function refreshTable()
{
	//DTable and Text		
	if(getDTContents().length>0)
	{
		divDTable.style.height="216px";
		divText.innerHTML = "";
	}
	else
	{
		divDTable.style.height="64px";
		divText.innerHTML = "<%=getNLString(nlsKit,"instructionEmptyList")%>";
	}

	drawDTable(divDTable);
}

/////////////////////////////////////////////////////////////////////////////////////
// init(tableContents, removedTableContents)
//
// - initialize this frame
/////////////////////////////////////////////////////////////////////////////////////
function init(tableContents, removedTableContents) 
{
	var bPreSelection=false;
	
	m_aRows				= tableContents;			
	m_aRowsRemoved   	= removedTableContents;
	
	//if nothing selected, preselect the first row
	if(getDTNumberOfSelectedRows()==0)
		if(m_aRows.length>0)
		{
			setDTRowSelected(0,true);
			bPreSelection=true;
		}
			
	//redraw the table		
	refreshTable();
	
	//Enable buttons
	if(!bPreSelection)
		parent.ListBtn.enableButtons(getDTNumberOfSelectedRows());
	else
		onChangeSelection();
	
	return bPreSelection;		
}

/////////////////////////////////////////////////////////////////////////////////////
// getCancelConfirmMessage()
//
// - get the confirm message for exit the dialog 
/////////////////////////////////////////////////////////////////////////////////////
function getCancelConfirmMessage()
{
	return "<%=getNLString(nlsKit,"kitContentsCancelConfirmation")%>";
}

/////////////////////////////////////////////////////////////////////////////////////
// contentsChanged()
//
// - check if the contents have been changed
/////////////////////////////////////////////////////////////////////////////////////
function contentsChanged()
{
	for(x in getDTRemovedRows())
		return true;
	
	var tc=getDTContents();
	
	for(var i=0; i<tc.length; i++)
	{
		var oRow=getDTRow(i);
		if(oRow.getFlag()==FLAG_CHANGED)
			return true;
	}
	
	return false;
}

/////////////////////////////////////////////////////////////////////////////////////
// clearAllChangedFlags
//
// - clear all changed flags and all actions
/////////////////////////////////////////////////////////////////////////////////////
function clearAllChangedFlags()
{
	//deleted rows have been actually deleted from DB
	m_aRowsRemoved = new Array();
	
   var tableContents = getDTContents();	
   
   for(var i=0; i< tableContents.length; i++)
   {
   		var oRow = tableContents[i];
   		
		if(oRow.flag == FLAG_UNEDITABLE)   		
			continue;
			
   		if(oRow.flag == FLAG_NONE)
   			continue;
   		else
   			oRow.flag = FLAG_NONE;	
   		
		var arraySKUs= oRow.oSKUArray;
		
		//Fixing defect 40284 --LL0818
		for(var k=0; k<arraySKUs.length; k++)
		  if(arraySKUs[k].action == ACTION_REMOVE)
			arraySKUs.splice(k--,1);
		
		for(var k=0; k<arraySKUs.length; k++)
		  if(arraySKUs[k].action != ACTION_NONE)
			arraySKUs[k].action = ACTION_NONE;
   }
}

</SCRIPT>

</HEAD>

<BODY CLASS="content" >

<H1> <%=getNLString(nlsKit,"titleKitList")%> </H1>

<!- Place holder for the dynamic table ->
<DIV id=divDTable STYLE="overflow: auto; width:98%; "></DIV>

<!- Place holder for hint text ->
<DIV id=divText></DIV>
  
<!- Place holder for ToolTip ->
<DIV id=divToolTip CLASS=TOOLTIP></DIV>
  
</BODY>

<script>
    document.body.style.scrollbarBaseColor = 'lavender';
    setToolTipDiv(divToolTip);
	parent.initAllFrames();
</script>

</HTML>

