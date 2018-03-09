<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<!--
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2000, 2003
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*--------------------------------------------------------------------->
<%@ page language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.tools.util.UIUtil" %>
<%@ page import="com.ibm.commerce.server.*" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.tools.catalog.commands.PackageBundleContentsCmd" %>
<%@ page import="com.ibm.commerce.tools.catalog.beans.AccessControlHelperDataBean" %>
<%@ page import="com.ibm.commerce.beans.DataBeanManager" %>
<%@ include file="../common/common.jsp" %>
<%@ include file="KitUtil.jsp" %> 

<%
    CommandContext cmdContext = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
    Locale jLocale = cmdContext.getLocale();
	Hashtable		nlsKit = (Hashtable) ResourceDirectory.lookup("catalog.KitNLS", jLocale);
    	
	JSPHelper jspHelper	= new JSPHelper(request);	
	String jstrActionKit = jspHelper.getParameter("actionKit");
		   if(jstrActionKit==null)	{jstrActionKit="";}

	String myInterfaceName = PackageBundleContentsCmd.NAME;
	AccessControlHelperDataBean myACHelperBean= new AccessControlHelperDataBean();
	myACHelperBean.setInterfaceName(myInterfaceName);
	DataBeanManager.activate(myACHelperBean,cmdContext);

%>

<HTML>
<HEAD>
<link rel=stylesheet href="<%= UIUtil.getCSSFile(jLocale) %>" type="text/css">

<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/common/Vector.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/catalog/DTable.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/catalog/KitContents.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/catalog/button.js"></SCRIPT>

<SCRIPT LANGUAGE="JavaScript">

	var readonlyAccess = <%=myACHelperBean.isReadOnly()%>;


/////////////////////////////////////////////////////////////////////////////////////
// enableButtons(nNumOfPackages)
//
// - enable or disable buttons 
/////////////////////////////////////////////////////////////////////////////////////
function enableButtons(nNumOfPackages)
{
	var bEditable=false;
	if(nNumOfPackages>0)			//check if the selected rows editable
		bEditable= parent.List.isDTSelectedRowEditable();
		
	enableButton(btnDelete,((nNumOfPackages>0) && (bEditable)));
	enableButton(btnChange,((nNumOfPackages==1) && (bEditable)));
	enableButton(btnCommonSKUs,(nNumOfPackages>1));
	
	//Pricing on for Package
	var bEnalbePricing=false;
	//if((nNumOfPackages==1) && (bEditable))
	if(nNumOfPackages==1)
	{
		var nRowId= parent.List.nextDTSelectedRowId();
		var oRow= parent.List.getDTRow(nRowId);
		if(oRow.oKit.type=='Package')
			bEnalbePricing=true;
	}
	enableButton(btnPrices,bEnalbePricing);
}

/////////////////////////////////////////////////////////////////////////////////////
// btnCommonSKUs_onclick()
//
// - event handler
/////////////////////////////////////////////////////////////////////////////////////
function btnCommonSKUs_onclick()
{
	if(isButtonEnabled(btnCommonSKUs))
	{
		var arraySKUs = parent.List.getCommonSKUsOfSelectedPBs();
		var bEditable = parent.List.isDTSelectedRowEditable();
		
		parent.Content.populateData(arraySKUs,bEditable);
		parent.Content.showCommonContent(true);
	}	
}

/////////////////////////////////////////////////////////////////////////////////////
// btnNew_onclick()
//
// - event handler
/////////////////////////////////////////////////////////////////////////////////////
function btnNew_onclick()
{
	if(isButtonEnabled(btnNew))
		parent.showKitCreateWizard();
}

/////////////////////////////////////////////////////////////////////////////////////
// btnChange_onclick()
//
// - event handler
/////////////////////////////////////////////////////////////////////////////////////
function btnChange_onclick()
{
	if(isButtonEnabled(btnChange))
	{
		var nRowId= parent.List.nextDTSelectedRowId();
		var oRow= parent.List.getDTRow(nRowId);
		parent.showKitUpdateNotebook(oRow.oKit.catentryId)
	}	
}

/////////////////////////////////////////////////////////////////////////////////////
// btnDelete_onclick()
//
// - event handler
/////////////////////////////////////////////////////////////////////////////////////
function btnDelete_onclick()
{
	if(isButtonEnabled(btnDelete))
	  if(confirmDialog("<%=getNLString(nlsKit,"msgPackageBundleDelete")%>"))
		parent.List.deleteSelectedPBs();
}	

/////////////////////////////////////////////////////////////////////////////////////
// btnPrices_onclick()
//
// - event handler
/////////////////////////////////////////////////////////////////////////////////////
function btnPrices_onclick()
{
	if(isButtonEnabled(btnPrices))
	{
		var nRowId= parent.List.nextDTSelectedRowId();
		var oRow= parent.List.getDTRow(nRowId);
		parent.showPricingDialog(oRow.oKit.catentryId)
	}	
}	

/////////////////////////////////////////////////////////////////////////////////////
// buildXMLData()
//
// - build XML data
/////////////////////////////////////////////////////////////////////////////////////
function buildXMLData()
{
   var xmlContents = new Array();
	
   // FOR Deleted PB	   
   var removedRows = parent.List.getDTRemovedRows();
   for (x in removedRows)
   {
   		var PackageBundleContents = new Object();
   			
   			PackageBundleContents.PackageBundle = new Object();
   			//PB 
   			//PB Catentry Id
   			PackageBundleContents.PackageBundle.catentryId = removedRows[x].oKit.catentryId;
   			//PB Type
   			PackageBundleContents.PackageBundle.type	   = removedRows[x].oKit.type;
   			PackageBundleContents.PackageBundle.action	   = ACTION_REMOVE;
   			
			PackageBundleContents.SKU=new Array();  
			
		xmlContents[xmlContents.length]=PackageBundleContents;	 			
   }	   
   
   //FOR Updated/New PB
   var tableContents =parent.List.getDTContents();	//CONTENTS.List.getDTContents();
   
   for(var i=0; i< tableContents.length; i++)
   {
   		var oRow = tableContents[i];
   		
   		if( (oRow.flag == FLAG_NONE) || (oRow.flag == FLAG_UNEDITABLE))			// nothing changed
   			continue;
   		
   		var PackageBundleContents = new Object();
   			
   			PackageBundleContents.PackageBundle = new Object();
   			//PB 
   			//PB Catentry Id
   			PackageBundleContents.PackageBundle.catentryId = oRow.oKit.catentryId;
   			//PB Type
   			PackageBundleContents.PackageBundle.type	   = oRow.oKit.type;
   			PackageBundleContents.PackageBundle.action	   = ACTION_NONE;
   			
   			//if(DEBUG)
   			//	PackageBundleContents.PackageBundle.flag_FOR_DEBUG_ONLY = oRow.flag;
   			
   			//PB Contents
   			var arraySKUs= oRow.oSKUArray;
   			PackageBundleContents.SKU	= new Array();
   			for(var k=0; k<arraySKUs.length; k++)
   			{	
   				if(arraySKUs[k].action != ACTION_NONE)
   				{
	   				var sku = new Object();
	   					sku.catentryId 	= arraySKUs[k].catentryId;
	   					sku.quantity	= arraySKUs[k].qty;
	   					sku.sequence	= arraySKUs[k].sequence;
	   					sku.action		= arraySKUs[k].action;
   				
   					PackageBundleContents.SKU[PackageBundleContents.SKU.length]=sku;
   				}
   			}
   			
   			//if(PackageBundleContents.SKU.length>0)
   				xmlContents[xmlContents.length]=PackageBundleContents;
   }

   var xmlData = new Object();
   xmlData.PBContents = new Object();
   //xmlData.PBContents.PackageBundleContents=xmlContents;
   xmlData.PBContents.PackageBundleContents=xmlContents;
   return xmlData;
}

/////////////////////////////////////////////////////////////////////////////////////
// buildCompleteXMLData()
//
// - build complete XML data (including untouched data), for debugging only
/////////////////////////////////////////////////////////////////////////////////////
function buildCompleteXMLData()
{
   var xmlContents = new Array();
   
   // FOR Deleted PB	   
   var removedRows = parent.List.getDTRemovedRows();
   for (x in removedRows)
   {
   		var PackageBundleContents = new Object();
   			
   			PackageBundleContents.PackageBundle = new Object();
   			//PB 
   			//PB Catentry Id
   			PackageBundleContents.PackageBundle.catentryId = removedRows[x].oKit.catentryId;
   			//PB Type
   			PackageBundleContents.PackageBundle.type	   = removedRows[x].oKit.type;
   			PackageBundleContents.PackageBundle.action	   = ACTION_REMOVE;
   			
			PackageBundleContents.SKU=new Array();  
			
		xmlContents[xmlContents.length]=PackageBundleContents;	 			
   }	   
   
   var tableContents =parent.List.getDTContents();	//CONTENTS.List.getDTContents();
   
   for(var i=0; i< tableContents.length; i++)
   {
   		var oRow = tableContents[i];
   		
   		//if( (oRow.flag == FLAG_NONE) || (oRow.flag == FLAG_UNEDITABLE))			// nothing changed
   		//	continue;
   		
   		var PackageBundleContents = new Object();
   			
   			PackageBundleContents.PackageBundle = new Object();
   			//PB 
   			//PB Catentry Id
   			PackageBundleContents.PackageBundle.catentryId = oRow.oKit.catentryId;
   			//PB Type
   			PackageBundleContents.PackageBundle.type	   = oRow.oKit.type;
   			
   			//if(DEBUG)
   			//	PackageBundleContents.PackageBundle.flag_FOR_DEBUG_ONLY = oRow.flag;
   			
   			//PB Contents
   			var arraySKUs= oRow.oSKUArray;
   			PackageBundleContents.SKU	= new Array();
   			for(var k=0; k<arraySKUs.length; k++)
   			{	
   			//	if(arraySKUs[k].action != ACTION_NONE)
   				{
	   				var sku = new Object();
	   					sku.catentryId 	= arraySKUs[k].catentryId;
	   					sku.quantity	= arraySKUs[k].qty;
	   					sku.sequence	= arraySKUs[k].sequence;
	   					sku.action		= arraySKUs[k].action;
   				
   					PackageBundleContents.SKU[PackageBundleContents.SKU.length]=sku;
   				}
   			}
   			
   			//if(PackageBundleContents.SKU.length>0)
   				xmlContents[xmlContents.length]=PackageBundleContents;
   }

   var xmlData = new Object();
   xmlData.PBContents = new Object();
   //xmlData.PBContents.PackageBundleContents=xmlContents;
   xmlData.PBContents.PackageBundleContents=xmlContents;
   return xmlData;
}

/////////////////////////////////////////////////////////////////////////////////////
// btnDumpXML_onClick()
//
// - for debugging only
/////////////////////////////////////////////////////////////////////////////////////
function btnDumpXML_onClick()
{
	popupXMLwindow(buildXMLData(), XML_ROOT);
	//popupXMLwindow(buildCompleteXMLData(), XML_ROOT);
}

/////////////////////////////////////////////////////////////////////////////////////
// init()
//
// - initialize this frame
/////////////////////////////////////////////////////////////////////////////////////
function init()
{
	if (readonlyAccess == true) 
	{
		btnNew.parentNode.parentNode.style.display = "none";
		btnChange.parentNode.parentNode.style.display = "none";
		btnPrices.parentNode.parentNode.style.display = "none";
		btnDelete.parentNode.parentNode.style.display = "none";
		return;
	}

	enableButton(btnNew,true);
}

</SCRIPT>


<META name="GENERATOR" content="IBM WebSphere Studio">
</HEAD>
<BODY class="content_bt">

<P><H1>&nbsp;</H1></P>

  	<script>
  	beginButtonTable();
  	
	drawButton("btnNew", 
				"<%=getNLString(nlsKit,"btnNew")%>", 
				"btnNew_onclick()", 
				"disabled");		  				

	drawButton("btnChange", 
				"<%=getNLString(nlsKit,"btnChange")%>", 
				"btnChange_onclick()", 
				"disabled");	
					  				
	drawButton("btnPrices", 
				"<%=getNLString(nlsKit,"btnPrices")%>", 
				"btnPrices_onclick()", 
				"disabled");
						  				
	drawButton("btnCommonSKUs", 
				"<%=getNLString(nlsKit,"btnCommonSKUs")%>", 
				"btnCommonSKUs_onclick()", 
				"disabled");
						  				
	drawButton("btnDelete", 
				"<%=getNLString(nlsKit,"btnDelete")%>", 
				"btnDelete_onclick()", 
				"disabled");		  				
				
	//drawButton("btnDumpXML", 
	//			"Dump XML", 
	//			"btnDumpXML_onClick()", 
	//			"enabled");		  				
				
	endButtonTable();			
  	</script>
  	
</BODY>

<script>

	AdjustRefreshButton(btnNew);
	AdjustRefreshButton(btnChange);
	AdjustRefreshButton(btnPrices);
	AdjustRefreshButton(btnCommonSKUs);
	AdjustRefreshButton(btnDelete);
	//AdjustRefreshButton(btnDumpXML);

	parent.initAllFrames();
</script>

</html>
