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
<%@ include file="../common/common.jsp" %>
<%@ include file="KitUtil.jsp" %> 

<%
    CommandContext cmdContext = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
    Locale jLocale = cmdContext.getLocale();
	Hashtable		nlsMAssoc = (Hashtable) ResourceDirectory.lookup("catalog.MAssociationNLS", jLocale);
%>

<HTML>
<HEAD>
<link rel=stylesheet href="<%= UIUtil.getCSSFile(jLocale) %>" type="text/css">

<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/common/Vector.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/catalog/DTable.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/catalog/MAssociation.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/catalog/button.js"></SCRIPT>

<SCRIPT LANGUAGE="JavaScript">

/////////////////////////////////////////////////////////////////////////////////////
// enableButtons(nNumOfSources)
//
// - enable or disable buttons 
/////////////////////////////////////////////////////////////////////////////////////
function enableButtons(nNumOfSources)
{
	enableButton(btnCommonTargets,(nNumOfSources>1));
}

/////////////////////////////////////////////////////////////////////////////////////
// btnCommonTargets_onclick()
//
// - event handler
/////////////////////////////////////////////////////////////////////////////////////
function btnCommonTargets_onclick()
{
	if(isButtonEnabled(btnCommonTargets))
	{
		var arrayTargets = parent.Source.getCommonTargetsOfSelectedSources();
		
		parent.Target.populateData(arrayTargets);
		parent.Target.showCommonContent(true);
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
   var tableContents =parent.Source.getDTContents();	//CONTENTS.List.getDTContents();
   
   for(var i=0; i< tableContents.length; i++)
   {
   		var oRow = tableContents[i];
   		
   		if( (oRow.flag == FLAG_NONE) || (oRow.flag == FLAG_UNEDITABLE))			// nothing changed
   			continue;
   		
   		var MAssociationsFromOneSource = new Object();
   			
   			MAssociationsFromOneSource.Source = new Object();
   			//Source 
   			//Source Catentry Id
   			MAssociationsFromOneSource.Source.catentryId = oRow.oSource.catentryId;
   			
   			//Target 
   			var arrayTargets = oRow.oTargetArray;
   			MAssociationsFromOneSource.Target = new Array();
   			for(var k=0; k<arrayTargets.length; k++)
   			{	
   				if(arrayTargets[k].action != ACTION_NONE)
   				{
	   				var ot = new Object();
	   					ot.catentryId 		= arrayTargets[k].catentryId;
	   					ot.associationId	= arrayTargets[k].associationId;
	   					ot.associationType	= arrayTargets[k].associationType;
	   					ot.semantic			= arrayTargets[k].semantic;
	   					ot.quantity			= arrayTargets[k].qty;
	   					ot.sequence			= arrayTargets[k].sequence;
	   					ot.year				= arrayTargets[k].year;
	   					ot.month			= arrayTargets[k].month;
	   					ot.day				= arrayTargets[k].day;
	   					ot.storeId			= arrayTargets[k].store;			//storeId in xml -- store
	   					ot.action			= arrayTargets[k].action;
   				
   					MAssociationsFromOneSource.Target[MAssociationsFromOneSource.Target.length]=ot;
   				}
   			}
   			
   			//if(MAssociations.Target.length>0)
   				xmlContents[xmlContents.length]=MAssociationsFromOneSource;
   }

   var xmlData = new Object();
   xmlData.MAssociations = new Object();
   xmlData.MAssociations.MAssociationsFromOneSource=xmlContents;
   return xmlData;
}

/////////////////////////////////////////////////////////////////////////////////////
// buildFullXMLData()
//
// - build complete XML data (including untouched data), for debugging only
/////////////////////////////////////////////////////////////////////////////////////
function buildFullXMLData()
{
   var xmlContents = new Array();
   var tableContents =parent.Source.getDTContents();	//CONTENTS.List.getDTContents();
   
   for(var i=0; i< tableContents.length; i++)
   {
   		var oRow = tableContents[i];
   		
   		//if( (oRow.flag == FLAG_NONE) || (oRow.flag == FLAG_UNEDITABLE))			// nothing changed
   		//	continue;
   		
   		var MAssociationsFromOneSource = new Object();
   			
   			MAssociationsFromOneSource.Source = new Object();
   			//Source 
   			//Source Catentry Id
   			MAssociationsFromOneSource.Source.catentryId = oRow.oSource.catentryId;
   			
   			//Target 
   			var arrayTargets = oRow.oTargetArray;
   			MAssociationsFromOneSource.Target = new Array();
   			for(var k=0; k<arrayTargets.length; k++)
   			{	
   				//if(arrayTargets[k].action != ACTION_NONE)
   				{
	   				var ot = new Object();
	   					ot.catentryId 		= arrayTargets[k].catentryId;
	   					ot.associationId	= arrayTargets[k].associationId;
	   					ot.associationType	= arrayTargets[k].associationType;
	   					ot.semantic			= arrayTargets[k].semantic;
	   					ot.quantity			= arrayTargets[k].qty;
	   					ot.sequence			= arrayTargets[k].sequence;
	   					ot.year				= arrayTargets[k].year;
	   					ot.month			= arrayTargets[k].month;
	   					ot.day				= arrayTargets[k].day;
	   					ot.storeId			= arrayTargets[k].store;			//storeId in xml -- store
	   					ot.action			= arrayTargets[k].action;
   				
   					MAssociationsFromOneSource.Target[MAssociationsFromOneSource.Target.length]=ot;
   				}
   			}
   			
   			//if(MAssociations.Target.length>0)
   				xmlContents[xmlContents.length]=MAssociationsFromOneSource;
   }

   var xmlData = new Object();
   xmlData.MAssociations = new Object();
   xmlData.MAssociations.MAssociationsFromOneSource=xmlContents;
   return xmlData;
}

/////////////////////////////////////////////////////////////////////////////////////
// btnDumpXML_onClick()
//
// - for debugging only
/////////////////////////////////////////////////////////////////////////////////////
function btnDumpXML_onClick()
{
	//popupXMLwindow(buildXMLData(), XML_ROOT);
	popupXMLwindow(buildFullXMLData(), XML_ROOT);
	
}

/////////////////////////////////////////////////////////////////////////////////////
// init()
//
// - initialize this frame
/////////////////////////////////////////////////////////////////////////////////////
function init()
{
}
</SCRIPT>


</HEAD>
<BODY class="button">

<P><H1>&nbsp;</H1></P>

  	<script>
  	beginButtonTable();
  	
	drawButton("btnCommonTargets", 
				"<%=getNLString(nlsMAssoc,"btnCommonTargets")%>", 
				"btnCommonTargets_onclick()", 
				"disabled");		  				
				
	//drawButton("btnDumpXML", 
	//			"Dump XML", 
	//			"btnDumpXML_onClick()", 
	//			"enabled");		  				
				
	endButtonTable();			
  	</script>
  	

</body>

<script>
	AdjustRefreshButton(btnCommonTargets);
	//AdjustRefreshButton(btnDumpXML);
	parent.initAllFrames();
</script>

</html>