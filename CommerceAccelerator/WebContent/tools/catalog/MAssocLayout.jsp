<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2002, 2016 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%
//---------------------------------------------------------------------
//- Import and Include Section
//---------------------------------------------------------------------
%>
<%@ page language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.tools.util.UIUtil" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.beans.DataBeanManager" %>
<%@ page import="com.ibm.commerce.tools.catalog.commands.MAssociationUpdateCmd" %>
<%@ page import="com.ibm.commerce.tools.catalog.beans.AccessControlHelperDataBean" %>
<%@page import="com.ibm.commerce.catalog.objects.*" %>
<%@page import="com.ibm.commerce.catalog.beans.*" %>

<%@include file="../common/common.jsp" %>
<%@include file="CatalogSearchUtil.jsp" %> 
<%@include file="KitUtil.jsp" %> 

<%! 

/////////////////////////////////////////////////////////////////////////////////////
// Vector getRelatedCatentryByFromCatentryId(Long nFromCatentryId)
//
// - get the Associations by the source catentry (CATENTRY_ID_FROM)
/////////////////////////////////////////////////////////////////////////////////////
private Vector getRelatedCatentryByFromCatentryId(Long nFromCatentryId,Integer nStoreId)
{
	Vector vRelatedCatentry= new Vector();

	try{
		RelatedCatalogEntryAccessBean abRelatedCatentry= new RelatedCatalogEntryAccessBean();
		Enumeration enRelCatentry= abRelatedCatentry.findByCatalogEntryAndStore(nFromCatentryId,nStoreId);
		while(enRelCatentry.hasMoreElements())
		{
			vRelatedCatentry.addElement(enRelCatentry.nextElement());
		}
		
	}catch (Exception ex){
		jspTrace("getRelatedCatentryByFromCatentryId() Exception= " + ex.toString());
	}	

	return vRelatedCatentry;
}

/////////////////////////////////////////////////////////////////////////////////////
// String getCatentryType(CatalogEntryDataBean dbCatentry)
//
// - get and check if it's known types 
/////////////////////////////////////////////////////////////////////////////////////
private String getCatentryType(CatalogEntryDataBean dbCatentry)
{
	String strType=null;
	try{
		String strTemp=dbCatentry.getType();
		if(strTemp.equals("ProductBean"))
		{
			strType="Product";
		}	
		else if(strTemp.equals("ItemBean"))
		{
			strType="Item";
		}	
		else if(strTemp.equals("PackageBean"))
		{
			strType="Package";
		}	
		else if (strTemp.equals("BundleBean"))	
		{
			strType="Bundle";
		}	
		else if (strTemp.equals("DynamicKitBean"))	
		{
			strType="DynamicKit";
		}	
	}catch (Exception ex){
		jspTrace("getCatentryType() Exception= "+ex.toString());
	}	
	return strType;	
}

%>


<%
	CommandContext 	cmdContext	= (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
	Locale 			jLocale		= cmdContext.getLocale();
    Hashtable		nlsMAssoc	= (Hashtable) ResourceDirectory.lookup("catalog.MAssociationNLS", jLocale);
	
	String myInterfaceName = MAssociationUpdateCmd.NAME;
	AccessControlHelperDataBean myACHelperBean= new AccessControlHelperDataBean();
	myACHelperBean.setInterfaceName(myInterfaceName);
	DataBeanManager.activate(myACHelperBean,cmdContext);

	JSPHelper jspHelper	= new JSPHelper(request);	
	String jstrActionKit = UIUtil.toHTML(jspHelper.getParameter("actionKit"));
		   if(jstrActionKit==null)	
		   		{ jstrActionKit=""; }

	String strNoMoreNewResults=jspHelper.getParameter("NoMoreNewResults");
		   if(strNoMoreNewResults==null)	
		   		{ strNoMoreNewResults=""; }

	Vector vSourceList = new Vector();

	if (!strNoMoreNewResults.equals("true"))
	{
		String strCatentryIdFromJeff = jspHelper.getParameter("catentryID");
		if (strCatentryIdFromJeff == null)
		{
			CatalogEntryDataBean arrayDbCatentry[] = catEntrySearchDB.getResultList();
			if(arrayDbCatentry!=null)
			{
				for(int i=0; i< arrayDbCatentry.length; i++)
				{
					vSourceList.addElement(arrayDbCatentry[i]);
				}
			}
		} else {
			String strFindByChild = jspHelper.getParameter("strFindByChild");
			if (strFindByChild != null && strFindByChild.equals("true"))
			{
				String strQuery = "CATENTRY_ID_TO="+strCatentryIdFromJeff;
				RelatedCatalogEntryAccessBean abRelations = new RelatedCatalogEntryAccessBean();
				Enumeration eRelations = abRelations.findWithPushDownQuery(strQuery);
				while (eRelations.hasMoreElements())
				{
					RelatedCatalogEntryAccessBean abRelation = (RelatedCatalogEntryAccessBean) eRelations.nextElement();
					CatalogEntryDataBean bnNewCatentry = new CatalogEntryDataBean();
					bnNewCatentry.setCatalogEntryID(abRelation.getFromCatalogEntryReferenceNumber());
					DataBeanManager.activate(bnNewCatentry, cmdContext);
					vSourceList.addElement(bnNewCatentry);
				}
				
			} else {
				StringTokenizer st = new StringTokenizer(strCatentryIdFromJeff, ",");
				while (st.hasMoreTokens()) {
					CatalogEntryDataBean bnNewCatentry = new CatalogEntryDataBean();
					bnNewCatentry.setCatalogEntryID(st.nextToken().trim());
					DataBeanManager.activate(bnNewCatentry, cmdContext);
					vSourceList.addElement(bnNewCatentry);
				}
			}
		}
	}
%>

<HTML>
<HEAD>

<title><%=UIUtil.toHTML((String)nlsMAssoc.get("titleMALayout"))%></title>
<LINK rel=stylesheet href="<%= UIUtil.getCSSFile(jLocale) %>" type="text/css">

<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/common/Vector.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/catalog/MAssociation.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/catalog/DTable.js"></SCRIPT>

<SCRIPT LANGUAGE="JavaScript">

	var readonlyAccess = <%=myACHelperBean.isReadOnly()%>;

/////////////////////////////////////////////////////////////////////////////////////
// showSKUPickupDialog()
//
// - popup the SKU Pick List dialog
/////////////////////////////////////////////////////////////////////////////////////
function showSKUPickupDialog()
{
   	// save the model before launching the dialog
	saveMAssocModel();
   	top.saveModel(parent.model);

	var strURL= top.getWebPath() + "DialogView";
	var	param= new Object();
		param["XMLFile"]="catalog.KitItemPickupDialog";
		param["redirectURL"]=strURL;
		param["redirectCmd"]="MAssocLayoutView";
		param["redirectXML"]="catalog.MAssocContentsDialog";
		
	parent.setContentFrameLoaded(false);
	
   	top.setContent("<%=getNLString(nlsMAssoc,"bctSelectTargets")%>", strURL, true, param);
}

/////////////////////////////////////////////////////////////////////////////////////
// generateMAssocId()
//
// - generate Id for a new Association
/////////////////////////////////////////////////////////////////////////////////////
var m_nTempAssociationId	=	-1;		
function generateMAssocId()
{
	return m_nTempAssociationId--;
}

/////////////////////////////////////////////////////////////////////////////////////
// saveMAssocModel()
//
// - save the model
/////////////////////////////////////////////////////////////////////////////////////
function saveMAssocModel()
{
    var modelMAssoc = new MAssocModel();
    
    	modelMAssoc.DTableSourceRows			= Source.getDTContents();
    	modelMAssoc.DTableSourceRemovedRows		= Source.getDTRemovedRows();
    	
    	modelMAssoc.DTableTargetRows			= Target.getDTContents();
		modelMAssoc.DTableTargetRemovedRows		= Target.getDTRemovedRows();
		modelMAssoc.bShowCommonTargets			= Target.m_bShowCommonTargets;
		modelMAssoc.bCommonTargetsRefreshed		= Target.m_bShowCommonTargetsRefreshed;
		
		modelMAssoc.nTempAssociationId			= m_nTempAssociationId;

		modelMAssoc.nSourceScrollTop			= Source.divDTable.scrollTop;
		modelMAssoc.nTargetScrollTop			= Target.divDTable.scrollTop;
    	
    top.saveData(modelMAssoc, MA_MODEL);
}

/////////////////////////////////////////////////////////////////////////////////////
// cloneDTRow(oTDRow)
//
// - clone a DT Row
/////////////////////////////////////////////////////////////////////////////////////
function cloneDTRow(o)
{
	var oRow = new DTRow();
		
	// 3 possible objects 				
	if(defined(o.oTarget))
		oRow.oTarget=cloneMATarget(o.oTarget);
	
	if(defined(o.oTargetArray))
		oRow.oTargetArray= cloneMATargetArray(o.oTargetArray);
	
	if(defined(o.oSource))
		oRow.oSource= cloneObj(o.oSource);

	// and other fields
	for(var x in o)
	 if((typeof o[x] != "object") &&(typeof o[x] != "function"))
				oRow[x]=o[x];

	return oRow;	
}

/////////////////////////////////////////////////////////////////////////////////////
// cloneDTableCotents(tableContents)
//
// - clone a DT 
/////////////////////////////////////////////////////////////////////////////////////
function cloneDTableCotents(tableContents)
{
	var tc = new Array();
	
	if(tableContents==null)
		return tc;
		
	//for(var i=0; i<tableContents.length; i++)
	//	tc[tc.length]=cloneDTRow(tableContents[i]);

	for(x in tableContents)
	 tc[x]=cloneDTRow(tableContents[x]);
	
	return tc;		
}

/////////////////////////////////////////////////////////////////////////////////////
// retrieveMAssocModel()
//
// - retrieve the model
/////////////////////////////////////////////////////////////////////////////////////
function retrieveMAssocModel()
{
	var m=top.getData(MA_MODEL);

	if(m!=null)
	{	
		m.DTableSourceRows				= cloneDTableCotents(m.DTableSourceRows);
		m.DTableSourceRemovedRows		= cloneDTableCotents(m.DTableSourceRemovedRows);
		m.DTableTargetRows				= cloneDTableCotents(m.DTableTargetRows);
		m.DTableTargetRemovedRows		= cloneDTableCotents(m.DTableTargetRemovedRows);
		
		//restore the temp MAssocId here		
		m_nTempAssociationId			= m.nTempAssociationId;
	}
		
	top.saveData(null, MA_MODEL);					//clear it
	
	return m;
}

/////////////////////////////////////////////////////////////////////////////////////
// populateFromSearchResults(tableContent)
//
// - populate the table from search result
/////////////////////////////////////////////////////////////////////////////////////
function populateFromSearchResults(tc)
{
	var oRow;
	var oSource, oTarget, oTargetArray;
	
	<% for(int i=0; i< vSourceList.size(); i++) 
	   { 
				CatalogEntryDataBean dbCatentry = (CatalogEntryDataBean) vSourceList.elementAt(i);
				dbCatentry.setCommandContext(cmdContext);

				String strType=getCatentryType(dbCatentry);
				if(strType==null)
				{
					continue;	
				}
					
				String strCatentryId = dbCatentry.getCatalogEntryReferenceNumber();	
				String strPartNumber = dbCatentry.getPartNumber();
				String strName = getName(dbCatentry);								//SearchUtil
				Vector vTargets=getRelatedCatentryByFromCatentryId(dbCatentry.getCatalogEntryReferenceNumberInEntityType(),cmdContext.getStoreId());
			%>  
			//MASourceObj(catentryId, partNumber, type, name, numberOfTargets)		
			oSource = new MASourceObj("<%= strCatentryId %>",
							  "<%= toJavaScript(strPartNumber) %>",
							  "<%= strType %>",
							  "<%= toJavaScript(strName) %>",
							  <%= vTargets.size()%> );	
								 
			oTargetArray = new Array();
			<%	
				for(int k=0; k<vTargets.size(); k++)
				{
					try{
								RelatedCatalogEntryAccessBean abRelatedCatentry= (RelatedCatalogEntryAccessBean) vTargets.elementAt(k);
								
								CatalogEntryDataBean dbTarget = new CatalogEntryDataBean();
								
								dbTarget.setCatalogEntryID(abRelatedCatentry.getToCatalogEntryReferenceNumber());
								DataBeanManager.activate(dbTarget, cmdContext);
								
								String strTargetCatentryId = dbTarget.getCatalogEntryReferenceNumber();	
								String strTargetPartNumber = dbTarget.getPartNumber();
								String strTargetName 	   = getName(dbTarget);		
								String strTargetShortDesc  = getShortDescription(dbTarget);			//SearchUtil
								String strAssocType		   = abRelatedCatentry.getAssociationType();
								String strSemantic		   = abRelatedCatentry.getSemanticSpecifier();
								String strEntryType		   = abRelatedCatentry.getRelatedCatalogEntry().getType();
								String strQty			   = abRelatedCatentry.getQuantity();
								String strSequence		   = abRelatedCatentry.getRank();
								if(strQty==null || strQty.length()==0)
									strQty="0";
								if(strSequence==null || strSequence.length()==0)
									strSequence="0";
																	
								Long   nMAssocId		   = abRelatedCatentry.getAssociationReferenceNumber();
								
								//for PCD, get date and storeId
								Timestamp tm=abRelatedCatentry.getDate1();
								
								String strYear = (tm==null)? "null":String.valueOf(tm.getYear()+1900);
								String strMonth = (tm==null)? "null":String.valueOf(tm.getMonth()+1);
								String strDay = (tm==null)? "null":""+String.valueOf(tm.getDate());
								
								String strStoreId	=abRelatedCatentry.getStoreId().toString();
								String strLogInStoreId=cmdContext.getStoreId().toString();
								
								String strEditable= (strStoreId.equals(strLogInStoreId) || strStoreId.equals("0"))? "true":"false";
								
						%>		
									  //catentryId, partNumber, name, shortDesc, associationType, semantic, qty, associationId, sequence, year, month, day, store, editable	
								oTarget= new MATargetObj("<%=strTargetCatentryId %>",
												 		 "<%=toJavaScript(strTargetPartNumber) %>",
												 		 "<%=toJavaScript(strTargetName) %>",
												 		 "<%=toJavaScript(strTargetShortDesc) %>",
												 		 "<%=strAssocType %>",
												 		 "<%=strSemantic %>",
												 		 <%=strQty %>,
												 		 "<%=nMAssocId %>",
												 		 <%=strSequence%>,
												 		 <%=strYear%>,
												 		 <%=strMonth%>,
												 		 <%=strDay%>,
												 		 "<%=strStoreId%>",
												 		 <%=strEditable%>,
														 "<%=strEntryType%>");				
													 
								oTargetArray[oTargetArray.length]=oTarget;				
									 
						<%} catch(Exception ex){ jspTrace(ex);}%>		
					
			<%	}	//Eof for k		%>
 
			oRow = new DTRow(oSource.partNumber);
			oRow.oSource = oSource;
			oRow.oTargetArray = oTargetArray;
			
			//addDTRow(oRow);
			tc[tc.length]=oRow;
			
	<% } 	// Eof for i %>

}

/////////////////////////////////////////////////////////////////////////////////////
// constructMAssocModel()
//
// - build the MAssoc Model
/////////////////////////////////////////////////////////////////////////////////////
function constructMAssocModel()
{
	var modelMAssoc = retrieveMAssocModel();

	if(modelMAssoc==null)
	{
		// First time come in, search for MAssoc
		modelMAssoc = new MAssocModel();
		
	 	populateFromSearchResults(modelMAssoc.DTableSourceRows);
	}	
	else
	{			
		// add or reload a new source obj, not supported by the gui
	}
	
	return modelMAssoc;
}

/////////////////////////////////////////////////////////////////////////////////////
// processSKUPickups()
//
// - if it's comming back from SKU Pick List, add the selectd SKUs into Kits
/////////////////////////////////////////////////////////////////////////////////////
function processSKUPickups()
{
	if('<%=jstrActionKit%>'==SKU_PICK_ACTION_ADD)
	{
		var urlParam=top.mccbanner.trail[top.mccbanner.counter].parameters;
		if(urlParam!=null)
			urlParam['actionKit']= null;
	
		TargetBtn.addSelectedSKUsToSource();
	}
}

/////////////////////////////////////////////////////////////////////////////////////
// deactivateSearchBean
//
// - deactivate the SearchBean if it comes back to this page again
/////////////////////////////////////////////////////////////////////////////////////
function deactivateSearchBean()
{
	var urlParam=top.mccbanner.trail[top.mccbanner.counter].parameters;
		if(urlParam!=null)
		{
			urlParam['searchType']="";
			urlParam['actionEP']="";
			urlParam['NoMoreNewResults']="true";
		}
}

/////////////////////////////////////////////////////////////////////////////////////
// initAllFrames()
//
// - initialize all frames 
/////////////////////////////////////////////////////////////////////////////////////
var nFramesLoaded=0;
function initAllFrames()
{
	if (readonlyAccess == true)
	{
		var btnSaveButton = parent.NAVIGATION.document.getElementsByName("btnSaveButton");
		btnSaveButton.item(0).disabled = true;
	}

	nFramesLoaded++;
	if(nFramesLoaded == 4)
	{
		var modelMAssoc = constructMAssocModel();

		SourceBtn.init();

		if(! Source.init(modelMAssoc.DTableSourceRows, modelMAssoc.DTableSourceRemovedRows))
		{
			TargetBtn.init();

			Target.init(modelMAssoc.DTableTargetRows, modelMAssoc.DTableTargetRemovedRows, 
						modelMAssoc.bShowCommonTargets, modelMAssoc.bCommonTargetsRefreshed);
		}				

		processSKUPickups();

		Source.divDTable.scrollTop = modelMAssoc.nSourceScrollTop;
		Target.divDTable.scrollTop = modelMAssoc.nTargetScrollTop;
				
		parent.setContentFrameLoaded(true);
	}
	
	deactivateSearchBean();
	
}

function visibleList(s)
{
	Target.showDropdown(s);
}

/////////////////////////////////////////////////////////////////////////////////////
// submitSku()
//
// - pass sku to hidden frame
/////////////////////////////////////////////////////////////////////////////////////
function submitSku(value) {

	var urlPara = new Object();
	urlPara.inputSku  = value;
	top.mccmain.submitForm("/webapp/wcs/tools/servlet/MAssocHiddenView", urlPara, "Hidden");
}

</SCRIPT>

<META name="GENERATOR" content="IBM WebSphere Studio">
</HEAD>

<script>
	
	var strWebPath= top.getWebPath();
	
	document.write("<frameset framespacing='0' frameborder='0' rows='47%,53%,0' id='LayoutFrameSet'> 		");
	document.write("	<frameset frameborder='0' framespacing='0' cols='86%,14%' id='SourceFrameSet'>	");
	document.write("		<frame src='" + strWebPath + "MAssocSourceView'  name='Source' scrolling='no' title='<%=getNLString(nlsMAssoc,"fmSourceList")%>'>			");
	document.write("		<frame src='" + strWebPath + "MAssocSourceBtnView' name='SourceBtn' scrolling='no' title='<%=getNLString(nlsMAssoc,"fmSourceListBtn")%>'>	");
	document.write("	</frameset>																		");
	document.write("	<frameset frameborder='0' framespacing='0' cols='86%,14%' id='TargetFrameSet'>");
	document.write("		<frame src='" + strWebPath + "MAssocTargetView' name='Target' scrolling='no' title='<%=getNLString(nlsMAssoc,"fmTargetList")%>'>			");
	document.write("		<frame src='" + strWebPath + "MAssocTargetBtnView' name='TargetBtn' scrolling='no' title='<%=getNLString(nlsMAssoc,"fmTargetListBtn")%>'>	");
	document.write("	</frameset>		");
	document.write("	<frame scrolling=no frameborder=no framespacing=0 name=Hidden src='" + strWebPath + "MAssocHiddenView' title='<%=getNLString(nlsMAssoc,"titleHidden")%>'>");
	document.write("</frameset>			");

	parent.isDialog=null;
	
</script>

</HTML>
