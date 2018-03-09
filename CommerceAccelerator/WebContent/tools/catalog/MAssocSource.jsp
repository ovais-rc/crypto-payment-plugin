<%--
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2002,2003
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
<%@ include file="../common/common.jsp" %>
<%@ include file="KitUtil.jsp" %> 

<%@ page import="com.ibm.commerce.beans.DataBeanManager" %>

<%@ page import="com.ibm.commerce.catalog.objects.*" %>
<%@ page import="com.ibm.commerce.catalog.beans.*" %>

<%
	CommandContext 	cmdContext = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
   	Locale 			jLocale = cmdContext.getLocale();
    Hashtable		nlsMAssoc = (Hashtable) ResourceDirectory.lookup("catalog.MAssociationNLS", jLocale);
 	Hashtable rbProduct = (Hashtable)ResourceDirectory.lookup("catalog.ProductNLS", cmdContext.getLocale());

%>

<HTML>
<HEAD>

<title><%=UIUtil.toHTML((String)nlsMAssoc.get("titleSource"))%></title>

<LINK rel=stylesheet href="<%= UIUtil.getCSSFile(jLocale) %>" type="text/css">
<link rel=stylesheet href="/wcs/tools/catalog/DTable.css" type="text/css">


<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/common/Vector.js"></SCRIPT>

<SCRIPT SRC="/wcs/javascript/tools/catalog/MAssociation.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/catalog/DTable.js"></SCRIPT>

<SCRIPT LANGUAGE="JavaScript">

/////////////////////////////////////////////////////////////////////////////////////
// generateHeadHTML()
//
// - callback (when a table need to be refreshed)
/////////////////////////////////////////////////////////////////////////////////////
function generateHeadHTML()
{
	var strHead;
	
    strHead  = "<TD CLASS=COLHEAD STYLE='width: 200;' id=partNumber><%=getNLString(nlsMAssoc,"columnPartNumber")%></TD>";
    strHead += "<TD CLASS=COLHEAD STYLE='width: 22;' id=type>&nbsp</TD>";
    strHead += "<TD CLASS=COLHEAD STYLE='width: 950;' id=name><%=getNLString(nlsMAssoc,"columnName")%></TD>";
    strHead += "<TD CLASS=COLHEAD STYLE='width: 80;'  id=targets><%=getNLString(nlsMAssoc,"columnTargets")%></TD>";
    
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
	strRow  = generateCellHTML("STRING",objRow.oSource.partNumber,null,true );
	strRow += generateCellHTML("IMAGE",elementType(objRow.oSource.type) );
	strRow += generateCellHTML("STRING",objRow.oSource.name,null,true );
	strRow += generateCellHTML("STRING_NUMBER",parent.parent.numberToStr(objRow.oSource.numberOfTargets) );
	
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
			case "Product":
				return 'SRC="/wcs/images/tools/catalog/product_grey.gif" ALT="<%=UIUtil.toJavaScript((String)rbProduct.get("attribute_catentryType_product"))%>"';
			case "Item":
				return 'SRC="/wcs/images/tools/catalog/skuitem_grey.gif" ALT="<%=UIUtil.toJavaScript((String)rbProduct.get("attribute_catentryType_item"))%>"';
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

	parent.SourceBtn.enableButtons(nNumberOfSelectedRows);
	
	if(nNumberOfSelectedRows >1)
	{
		parent.Target.populateData(null);					// pass in empty arry, until finishing selection 
		parent.Target.showCommonContent(false);			// not updated, until click the button
	}	
	else
	{
		if(nNumberOfSelectedRows==0)
			parent.Target.populateData(null);
		else 
		{
			var nSelectedRowId=nextDTSelectedRowId(-1);
 			
			parent.Target.populateData(getDTRow(nSelectedRowId).oTargetArray);
		}		  	
		
		parent.Target.showSimpleContent(nNumberOfSelectedRows);
	}
	
	parent.TargetBtn.onInputBoxChange();
}

/////////////////////////////////////////////////////////////////////////////////////
// preChangeSelection()
//
// - if it's allowed to change selection
/////////////////////////////////////////////////////////////////////////////////////
function preChangeSelection()
{
	return parent.Target.validateAndSaveData();
}

/////////////////////////////////////////////////////////////////////////////////////
// getNLType(strType)
//
// - get NL description for Catentry types
/////////////////////////////////////////////////////////////////////////////////////
function getNLType(strType)
{
	var strNLType;

	if(strType=="Product")
		strNLType="<%= getNLString(nlsMAssoc,"typeProduct")%>";
	else if(strType=="Item")
		strNLType="<%= getNLString(nlsMAssoc,"typeItem")%>";
	else if(strType=="Package")
		strNLType="<%= getNLString(nlsMAssoc,"typePackage")%>";
	else if(strType=="Bundle")
		strNLType="<%= getNLString(nlsMAssoc,"typeBundle")%>";
	else if(strType=="DynamicKit")
		strNLType="<%= getNLString(nlsMAssoc,"typeDynamicKit")%>";
	else
		strNLType="";	
		
	return strNLType;	
}

/////////////////////////////////////////////////////////////////////////////////////
// getCommonTargetsOfSelectedSources
//
// - get common Targets of selected Sources
/////////////////////////////////////////////////////////////////////////////////////
function getCommonTargetsOfSelectedSources()
{
	var aCommonTargets = new Array();
	var tableContents = getDTContents();
	
	for(var i=0; i< tableContents.length; i++)
	{
		if(isDTRowSelected(i))
		{
			var oRow =getDTRow(i);
			var arrayTargets= oRow.oTargetArray;
			
			if(aCommonTargets.length == 0)						// the first selected PB
			{
				for(var k=0; k<arrayTargets.length; k++)		// copy the array (reference is ok)	
				  if(arrayTargets[k].action != ACTION_REMOVE)
					aCommonTargets[aCommonTargets.length]= arrayTargets[k];
			}
			else											// other selected PB
			{
				for(var k=0; k<aCommonTargets.length; k++)		// remove skus if not common
				  if(! isTargetInArray(aCommonTargets[k], arrayTargets))
				  {
						aCommonTargets.splice(k, 1);
						k--;
				  }
			}			
			
			if(aCommonTargets.length==0)						// nothing in common so far, break
				break;
							
		}//Eof if oRow.bSelected
		
	}//Eof for
	
	return aCommonTargets;
}


/////////////////////////////////////////////////////////////////////////////////////
// removeTargetFromSelectedSources(oTarget, bRefresh)
//
// - remove a target from selected Sources
/////////////////////////////////////////////////////////////////////////////////////
function removeTargetFromSelectedSources(oTarget, bRefresh)
{
	var tableContents=getDTContents();
	var bMultiSelection=(getDTNumberOfSelectedRows()>1);
	
	for(var i=0; i< tableContents.length; i++)
	{
		if( isDTRowSelected(i))		
		{
			var oRow = tableContents[i];
			var arrayTargets= oRow.oTargetArray;

			var bFoundInArray = false;
			var bRowChanged = false;
			for(var k=0; (k< arrayTargets.length) && (!bFoundInArray); k++)
			{
			  if(arrayTargets[k].editable)
			  {
			    if(bMultiSelection)		// for Multi selection, no associaitonId
			    {
					if(arrayTargets[k].equals(oTarget))
						bFoundInArray=true;
				}
				else					// for single selection, use associationId
				{
					if(arrayTargets[k].associationId == oTarget.associationId)
						bFoundInArray=true;
				}		
			  }	
			  
			  if(bFoundInArray)
			  {
					switch(arrayTargets[k].action)
					{
						case ACTION_ADD:							// it's a new one, remove it 
										arrayTargets.splice(k,1);
										bRowChanged=true;
										break;	
										
						case ACTION_NONE:
						case ACTION_UPDATE:							// existing one, mark for remove
										arrayTargets[k].action = ACTION_REMOVE;
										bRowChanged=true;
										break;
										
						case ACTION_REMOVE:
										bFoundInArray=false;		// already removed, go to find other ones
										break;						
					}
				}
			}// Eof for k
			
			if(bRowChanged)
			{
				oRow.oSource.numberOfTargets --;
				oRow.setFlag(FLAG_CHANGED);
				
				if(bRefresh)
					refreshDTRow(i);
			}
		}//Eof if(isDTRowSelected(i))
	}//Eof for
}

/////////////////////////////////////////////////////////////////////////////////////
// preUpdateTarget(oTarget)
//
// - mark the old one as ACTION_REMOVE 
// - create a new one for update
// Note: If I can get association Id, it should not be so complicated
//		 but right now the Assceebean does not support,
//		 and I do not want to refresh the screen after each 'Save'
/////////////////////////////////////////////////////////////////////////////////////
function preUpdateTarget(oTarget)
{
	var nRowId = nextDTSelectedRowId();
	var oRow = getDTRow(nRowId);
	
	var arrayTargets= oRow.oTargetArray;

	var bFoundInArray = false;

	for(var k=0; k< arrayTargets.length; k++)
	{
	  if(arrayTargets[k].editable)
		if(arrayTargets[k].associationId == oTarget.associationId)
		  {
				switch(arrayTargets[k].action)
				{
					case ACTION_ADD: // it's a new one, update it is ok
									return oTarget;
									
					case ACTION_NONE:
					case ACTION_UPDATE:	// existing one, mark for remove, add a new one to update
										
									var oTargetNew=cloneMATarget(oTarget);
									oTargetNew.associationId=parent.generateMAssocId();
									
									for(var j=arrayTargets.length; j>k+1; j--)
										arrayTargets[j]=arrayTargets[j-1];
									
									arrayTargets[k+1]=oTargetNew;
									
									arrayTargets[k].action = ACTION_REMOVE;
									arrayTargets[k+1].action = ACTION_ADD; 																			
									
									return oTargetNew;
									
					case ACTION_REMOVE:
									// already removed, go to find the next one
									break;						
				}
			}
	}// Eof for k
	
	return null;	
}

/////////////////////////////////////////////////////////////////////////////////////
// addSKUToSelectedSources(oSKU, bRefresh)
//
// - add a target to selected sources
/////////////////////////////////////////////////////////////////////////////////////
function addSKUToSelectedSources(oSKU, bRefresh)
{
	var tableContents=getDTContents();
	var bDuplicatedSKU=false;
	
	// if for one source, we allow duplicated targets
	var bAllowDuplicatedTarget= (getDTNumberOfSelectedRows()==1);
	var skuType = parent.Target.CURRENT_MA_TYPE;
	
	if (skuType == "0") {
		skuType = (parent.Target.DEFAULT_MA_TYPE == "0") ? parent.Target.DEFAULT_NEW_MA_TYPE : parent.Target.DEFAULT_MA_TYPE;
	}
	
	for(var i=0; i< tableContents.length; i++)
	{
		if( isDTRowSelected(i))		
		{
			var bFoundInArray = false;
			var bRowChanged   = false;
			var oRow = tableContents[i];
			var arrayTargets= oRow.oTargetArray;

			var oTarget= new MATargetObj(oSKU.catentryId,
							 		 	 oSKU.partNumber,
							 		 	 oSKU.name,
							 		 	 oSKU.shortDesc,
							 		 	 skuType,							//associationType
							 		 	 parent.Target.DEFAULT_MA_SEMANTIC,	//semantic
							 		 	 1,									//Qty
							 		 	 parent.generateMAssocId(),			//TempId								
										 -1,		 		 				//strSequence%>,
										 null,	 		 					//strYear%>,
										 null,	 		 					//strMonth%>,
										 null,	 		 					//strDay%>,
										 <%=cmdContext.getStoreId().toString()%>,	//strStoreId%>,
										 true, oSKU.type);	 		 					//strEditable%>);				
							 		 	 
			oTarget.setAction(ACTION_ADD);									//set it to ADD				 
				
			for(var k=0; (k< arrayTargets.length) && (!bFoundInArray); k++)
			{
				if(arrayTargets[k].equals(oTarget))
				{
					bFoundInArray=true;
					switch(arrayTargets[k].action)
					{
						case ACTION_ADD:							
						case ACTION_NONE:
						case ACTION_UPDATE:					
											if(! bAllowDuplicatedTarget)
												oTarget.action = ACTION_NONE;
											bDuplicatedSKU=true;
											break;
										
										
						case ACTION_REMOVE:
											oTarget.action = ACTION_UPDATE;						// removed, change it to update
											oTarget.associationId=arrayTargets[k].associationId;	// we need the id
											arrayTargets.splice(k,1);
											break;						
					}
				}
			}// Eof for k
			  
			// if we need to append the target at the end of the array
			if((oTarget.action==ACTION_ADD) || (oTarget.action==ACTION_UPDATE))
			{
				if(arrayTargets.length >0 )
					oTarget.sequence=arrayTargets[arrayTargets.length-1].sequence+1;
				else
					oTarget.sequence=0;	
				
				arrayTargets[arrayTargets.length]=oTarget;					 
					
				oRow.oSource.numberOfTargets ++;
				oRow.setFlag(FLAG_CHANGED);
					
				if(bRefresh)
					refreshDTRow(i);
			} 
		}//Eof if(isDTRowSelected(i))
	}//Eof for

	return (!bDuplicatedSKU);				//if the sku is not duplicated, return true			
}

/////////////////////////////////////////////////////////////////////////////////////
// moveUpTargetInSelectedSource(oTarget)
//
// - move up a target in the selected Source
/////////////////////////////////////////////////////////////////////////////////////
function moveUpTargetInSelectedSource(oTarget)
{
	var bUpdated=false;
	var nRowId=nextDTSelectedRowId();
	var oRow=getDTRow(nRowId);
	var arrayTargets = oRow.oTargetArray;
	var upRowId=upRowId_1=-1;
	var nTargetListRowId=-1;
	for(var i=0; i< arrayTargets.length; i++)
	{
		if(arrayTargets[i].getAction()== ACTION_REMOVE)
			continue;
			
		if(arrayTargets[i].associationId != oTarget.associationId)
		{
			upRowId_1=upRowId;
			upRowId=i;
			nTargetListRowId++;
		}	
		else if(upRowId >=0)	//fount it, make sure it's not the first one
		{
			arrayTargets[i]=arrayTargets[upRowId];
			arrayTargets[upRowId]=oTarget;			
			
			if(upRowId_1>=0)
				oTarget.sequence=(arrayTargets[i].sequence+arrayTargets[upRowId_1].sequence)/2;
			else
				oTarget.sequence=arrayTargets[i].sequence-1;	
								
			//mark the target to be changed
			oTarget.setAction(ACTION_UPDATE);

			//mark the row has been changed
			oRow.setFlag(FLAG_CHANGED);
			
			bUpdated=true;
			break;
		}
	}//Eof for
	
	if(bUpdated)
	{
		// refresh the row
		refreshDTRow(nRowId);
	
		//refresh Target List
		var arraySelectRows= new Array();
		arraySelectRows[0]=nTargetListRowId;
		
		parent.Target.populateData(oRow.oTargetArray,arraySelectRows);
		parent.Target.showSimpleContent(1);
	}
	
}

/////////////////////////////////////////////////////////////////////////////////////
// moveDownTargetInSelectedSource(oTarget)
//
// - move down a target in the selected Source
/////////////////////////////////////////////////////////////////////////////////////
function moveDownTargetInSelectedSource(oTarget)
{
	var bUpdated=false;
	var nRowId=nextDTSelectedRowId();
	var oRow=getDTRow(nRowId);
	var arrayTargets = oRow.oTargetArray;
	var upRowId=upRowId_1=-1;
	var nTargetListRowId=-1;
	for(var i=arrayTargets.length-1; i>=0; i--)
	{
		if(arrayTargets[i].getAction()== ACTION_REMOVE)
			continue;
			
		if(arrayTargets[i].associationId != oTarget.associationId)
		{
			upRowId_1=upRowId;
			upRowId=i;
		}	
		else if(upRowId >=0)	//fount it, make sure it's not the first one
		{
		
			arrayTargets[i]=arrayTargets[upRowId];
			arrayTargets[upRowId]=oTarget;			
			
			if(upRowId_1>=0)
				oTarget.sequence=(arrayTargets[i].sequence+arrayTargets[upRowId_1].sequence)/2;
			else
				oTarget.sequence=arrayTargets[i].sequence+1;	
								
			//mark the target to be changed
			oTarget.setAction(ACTION_UPDATE);

			//mark the row has been changed
			oRow.setFlag(FLAG_CHANGED);
			
			bUpdated=true;
			break;
		}
	}//Eof for
	
	if(bUpdated)
	{
		// refresh the row
		refreshDTRow(nRowId);
	
		//refresh Target List
		var nContentSelecteRowId=-1;
		for(var i=0; i<arrayTargets.length; i++)
		{
			if(arrayTargets[i].getAction()== ACTION_REMOVE)
				continue;

			nContentSelecteRowId++;
				
			if(arrayTargets[i].associationId == oTarget.associationId)
				break;	
		} 
		
		var arraySelectRows= new Array();
		arraySelectRows[0]=nContentSelecteRowId;
		
		parent.Target.populateData(oRow.oTargetArray,arraySelectRows);
		parent.Target.showSimpleContent(1);
	}
}

/////////////////////////////////////////////////////////////////////////////////////
// refreshTable()
//
// - refresh the Source List table
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
		divText.innerHTML = "<%=getNLString(nlsMAssoc,"instructionEmptyList")%>";
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
	var bPreSelection = false;
	
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
	if(! bPreSelection)
		parent.SourceBtn.enableButtons(getDTNumberOfSelectedRows());
	else
		onChangeSelection();
	
	return bPreSelection;		
}

/////////////////////////////////////////////////////////////////////////////////////
// getNumberofSourceSelected()
//
// - return number of source selected
/////////////////////////////////////////////////////////////////////////////////////
function getNumberofSourceSelected() 
{
	return getDTNumberOfSelectedRows();
}

/////////////////////////////////////////////////////////////////////////////////////
// getCancelConfirmMessage()
//
// - get the confirm message for exit the dialog 
/////////////////////////////////////////////////////////////////////////////////////
function getCancelConfirmMessage()
{
	return "<%=getNLString(nlsMAssoc,"massocCancelConfirmation")%>";
}

/////////////////////////////////////////////////////////////////////////////////////
// contentsChanged()
//
// - check if the contents have been changed
/////////////////////////////////////////////////////////////////////////////////////
function contentsChanged()
{
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
			
   		oRow.flag = FLAG_NONE;	
   		
		var arrayTargets= oRow.oTargetArray;
		
		for(var k=0; k<arrayTargets.length; k++)
		{
		  if(arrayTargets[k].action == ACTION_REMOVE)
			arrayTargets.splice(k--,1);
		  else
		  	arrayTargets[k].action = ACTION_NONE;	
		}		
   }
}

</SCRIPT>

</HEAD>

<BODY CLASS="content" >

<H1> <%=getNLString(nlsMAssoc,"titleSourceList")%></H1>

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

