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
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.tools.util.UIUtil" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.tools.catalog.commands.PackageBundleContentsCmd" %>
<%@ page import="com.ibm.commerce.tools.catalog.beans.AccessControlHelperDataBean" %>
<%@ page import="com.ibm.commerce.beans.DataBeanManager" %>

<%@page import="com.ibm.commerce.catalog.objects.*" %>
<%@page import="com.ibm.commerce.catalog.beans.*" %>

<%@include file="../common/common.jsp" %>
<%@include file="CatalogSearchUtil.jsp" %> 
<%@include file="KitUtil.jsp" %> 

<%! 
/////////////////////////////////////////////////////////////////////////////////////
// Vector getCatentryRelationAccessBean(Long nParentCatentryId)
//
// - get the children items of the catalog entry
/////////////////////////////////////////////////////////////////////////////////////
private Vector getCatentryRelationAccessBean(Long nParentCatentryId)
{
	Vector vCatenrelAccessBeans= new Vector();

	try{
		CatalogEntryRelationDataBean dbCatenRel = new CatalogEntryRelationDataBean();
		Enumeration enCatenrel=dbCatenRel.findByCatalogEntryParentId(nParentCatentryId);
		while(enCatenrel.hasMoreElements())
		{
			CatalogEntryRelationAccessBean abCatenrel= (CatalogEntryRelationAccessBean) enCatenrel.nextElement();
			
			//We'd better check if it a XXXXXXXX_COMPONENT relation
			//if(abCatenrel.getCatalogRelationTypeId().endsWith("COMPONENT"))
			//   vCatenrelAccessBeans.addElement(abCatenrel);
			
			//Aalim's suggestion: check specifically for the three type
			String strType=abCatenrel.getCatalogRelationTypeId();
			if( (strType.equals("PACKAGE_COMPONENT")) ||				//Package
			    (strType.equals("BUNDLE_COMPONENT")) ||					//Bundle
				(strType.equals("DYNAMIC_KIT_COMPONENT")) )				//DyanmicKit(right now not in schema)
			{
			    	vCatenrelAccessBeans.addElement(abCatenrel);
			}	
			else
			{
				jspTrace("getCatentryRelationAccessBean("+nParentCatentryId+") found unknown Catenrel type"+ strType);				    
			}
		}	
	}catch (Exception ex){
		jspTrace("getCatentryRelationAccessBean("+nParentCatentryId+") "+ex.toString());
	}	
	return vCatenrelAccessBeans;
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
		if(strTemp.equals("PackageBean"))
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
		jspTrace("getCatentryType() "+ex.toString());
	}	
	return strType;	
}

%>

<%
	CommandContext 	cmdContext = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
   	Locale 			jLocale = cmdContext.getLocale();
    Hashtable		nlsKit = (Hashtable) ResourceDirectory.lookup("catalog.KitNLS", jLocale);
    
    	String myInterfaceName = PackageBundleContentsCmd.NAME;
	AccessControlHelperDataBean myACHelperBean= new AccessControlHelperDataBean();
	myACHelperBean.setInterfaceName(myInterfaceName);
	DataBeanManager.activate(myACHelperBean,cmdContext);

	JSPHelper jspHelper	= new JSPHelper(request);	
	String strActionKit = UIUtil.toHTML(jspHelper.getParameter("actionKit"));
		   if(strActionKit==null)	
		   		{ strActionKit=""; }
	String strNoMoreNewResults=jspHelper.getParameter("NoMoreNewResults");
		   if(strNoMoreNewResults==null)	
		   		{ strNoMoreNewResults=""; }
	
    Vector vPackageList = new Vector();

	if( ! strNoMoreNewResults.equals("true"))
	{
		String strCatentryIdFromJeff = jspHelper.getParameter("catentryID");
		if(strCatentryIdFromJeff!=null)		//from Jeff
		{
			String strFindByChild = jspHelper.getParameter("strFindByChild");
			if(strFindByChild != null && strFindByChild.equals("true"))
			{
				CatalogEntryRelationAccessBean abRelations = new CatalogEntryRelationAccessBean();
				Enumeration ePackages = abRelations.findByCatalogEntryChildId(new Long(strCatentryIdFromJeff));
				while (ePackages.hasMoreElements())
				{
					CatalogEntryRelationAccessBean abRelation = (CatalogEntryRelationAccessBean) ePackages.nextElement();
					String strType = abRelation.getCatalogRelationTypeId();
					if (strType.equals("PACKAGE_COMPONENT") || strType.equals("BUNDLE_COMPONENT") || strType.equals("DYNAMIC_KIT_COMPONENT"))
					{
						CatalogEntryDataBean bnNewCatentry = new CatalogEntryDataBean();
						bnNewCatentry.setCatalogEntryID(abRelation.getCatalogEntryIdParent());
						DataBeanManager.activate(bnNewCatentry, cmdContext);
						vPackageList.addElement(bnNewCatentry);
					}
				}
				
			} else {
				StringTokenizer st = new StringTokenizer(strCatentryIdFromJeff, ",");
				while (st.hasMoreTokens()) {				
					CatalogEntryDataBean bnNewCatentry = new CatalogEntryDataBean();
					bnNewCatentry.setCatalogEntryID(st.nextToken().trim());
					DataBeanManager.activate(bnNewCatentry, cmdContext);
					vPackageList.addElement(bnNewCatentry);
				}			
			}
		}
		else						//from search		
		{		       
			CatalogEntryDataBean arrayDbCatentry[] = catEntrySearchDB.getResultList();
		
		    if(arrayDbCatentry!=null)
		    for(int i=0; i< arrayDbCatentry.length; i++)
		    {
				vPackageList.addElement(arrayDbCatentry[i]);
			}
		}
	}%>

<HTML>
<HEAD>

<LINK rel=stylesheet href="<%= UIUtil.getCSSFile(jLocale) %>" type="text/css">

<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/common/Vector.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/catalog/KitContents.js"></SCRIPT>
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
	saveKitModel();
   	top.saveModel(parent.model);
   	//top.setReturningPanel("KitContents");

	var strURL= top.getWebPath() + "DialogView";
	var	param= new Object();
		param["XMLFile"]="catalog.KitItemPickupDialog";
		param["redirectURL"]=strURL;
		param["redirectCmd"]="KitLayoutView";
		param["redirectXML"]="catalog.KitContentsDialog";
		
	parent.setContentFrameLoaded(false);
	
   	top.setContent('<%=getNLString(nlsKit,"bctSelectSKUs")%>', strURL, true, param);
}

/////////////////////////////////////////////////////////////////////////////////////
// showKitCreateWizard()
//
// - popup the Kit creation wizard
/////////////////////////////////////////////////////////////////////////////////////
function showKitCreateWizard()
{
   	// save the model before launching the wizard
	saveKitModel();
   	top.saveModel(parent.model);
   	//top.setReturningPanel("KitContents");

	var strURL= top.getWebPath() + "WizardView";
	var	param= new Object();
		param["XMLFile"]="catalog.KitWizard";
		param["langId"]="<%=cmdContext.getLanguageId().toString()%>";
		param["storeId"]="<%=cmdContext.getStoreId().toString()%>";
		
	parent.setContentFrameLoaded(false);
	
   	top.setContent('<%=getNLString(nlsKit,"bctNewKit")%>', strURL, true, param);
}

/////////////////////////////////////////////////////////////////////////////////////
// submitSku()
//
// - pass sku to hidden frame
/////////////////////////////////////////////////////////////////////////////////////
function submitSku(value) {

	var urlPara = new Object();
	urlPara.inputSku  = value;
	top.mccmain.submitForm("/webapp/wcs/tools/servlet/KitHiddenView", urlPara, "Hidden");
}

/////////////////////////////////////////////////////////////////////////////////////
// showKitUpdateNotebook(nCatentryId)
//
// - popup the Kit update notebook
/////////////////////////////////////////////////////////////////////////////////////
function showKitUpdateNotebook(nCatentryId)
{
   	// save the model before launching the notebook
	saveKitModel();
   	top.saveModel(parent.model);
   	//top.setReturningPanel("KitContents");

	var strURL= top.getWebPath() + "NotebookView";
	var	param= new Object();
		param["XMLFile"]="catalog.KitNotebook";
		param["langId"]="<%=cmdContext.getLanguageId().toString()%>";
		param["storeId"]="<%=cmdContext.getStoreId().toString()%>";
		param["productrfnbr"]=nCatentryId;
		
	parent.setContentFrameLoaded(false);
	
   	top.setContent('<%=getNLString(nlsKit,"bctUpdateKit")%>', strURL, true, param);
}

/////////////////////////////////////////////////////////////////////////////////////
// showPricingDialog(nCatentryId)
//
// - popup the pricing dialog
/////////////////////////////////////////////////////////////////////////////////////
function showPricingDialog(nCatentryId)
{
   	// save the model before launching the dialog
	saveKitModel();
   	top.saveModel(parent.model);
   	//top.setReturningPanel("KitContents");

	var strURL= top.getWebPath() + "PricingDialogView";
	var	param= new Object();
		param["XMLFile"]="catalog.pricingDialog";
		param["isSummary"]="false";
		param["refNum"]=nCatentryId;

	parent.setContentFrameLoaded(false);
	
   	top.setContent('<%=getNLString(nlsKit,"bctPrices")%>', strURL, true, param);
}


/////////////////////////////////////////////////////////////////////////////////////
// saveKitModel()
//
// - save the model
/////////////////////////////////////////////////////////////////////////////////////
function saveKitModel()
{
    var modelKitContents = new KitContentsModel();
    
    	modelKitContents.DTableListRows				= List.getDTContents();
    	modelKitContents.DTableListRemovedRows		= List.getDTRemovedRows();
    	
    	modelKitContents.DTableContentsRows			= Content.getDTContents();
		modelKitContents.DTableContentsRemovedRows	= Content.getDTRemovedRows();
		modelKitContents.bShowCommonContent			= Content.m_bShowCommonContent;
		modelKitContents.bCommonContentRefreshed	= Content.m_bCommonContentRefreshed;
		
		modelKitContents.nListScrollTop				= List.divDTable.scrollTop;
		modelKitContents.nContentScrollTop			= Content.divDTable.scrollTop;
    	
    top.saveData(modelKitContents, KIT_MODEL);
}

/////////////////////////////////////////////////////////////////////////////////////
// retrieveKitModel()
//
// - retrieve the Model
/////////////////////////////////////////////////////////////////////////////////////
function retrieveKitModel()
{
	var m=top.getData(KIT_MODEL);

	if(m!=null)
	{	
		m.DTableListRows			= cloneDTableCotents(m.DTableListRows);
		m.DTableListRemovedRows		= cloneDTableCotents(m.DTableListRemovedRows);
		m.DTableContentsRows		= cloneDTableCotents(m.DTableContentsRows);
		m.DTableContentsRemovedRows	= cloneDTableCotents(m.DTableContentsRemovedRows);
	}
		
	top.saveData(null, KIT_MODEL);					//clear it
	
	return m;
}

/////////////////////////////////////////////////////////////////////////////////////
// populateFromSearchResults(tableContents)
//
// - populate table content from search results
/////////////////////////////////////////////////////////////////////////////////////
function populateFromSearchResults(tc)
{
	var oRow;
	var oKit, oSKU, oSKUArray;
	
	<% 
		Long nStoreMemberId=cmdContext.getStore().getMemberIdInEntityType();
		for(int i=0; i< vPackageList.size(); i++) 
	   { 
				CatalogEntryDataBean dbCatentry = (CatalogEntryDataBean) vPackageList.elementAt(i);
				dbCatentry.setCommandContext(cmdContext);
				
				String strType=getCatentryType(dbCatentry);
				if(strType==null)
				{
					continue;	
				}
					
				String strCatentryId= dbCatentry.getCatalogEntryReferenceNumber();	
				Long   nCatentryMemberId=dbCatentry.getMemberIdInEntityType();
				String strPartNumber = dbCatentry.getPartNumber();
				String strName = getName(dbCatentry);								//SearchUtil
				String strShotDesc = getShortDescription(dbCatentry);				//SearchUtil
				Vector vCatenRel=getCatentryRelationAccessBean(dbCatentry.getCatalogEntryReferenceNumberInEntityType());
			%>  
				
			oKit = new KitObj("<%= strCatentryId %>",
							  "<%= toJavaScript(strPartNumber) %>",
							  "<%= strType %>",
							  "<%= toJavaScript(strName) %>",
							  "<%= toJavaScript(strShotDesc) %>",
							  <%= vCatenRel.size() %> );	
								 
			oSKUArray = new Array();
			<%	
				for(int k=0; k<vCatenRel.size(); k++)
				{
					CatalogEntryRelationAccessBean abCatenrel= (CatalogEntryRelationAccessBean) vCatenRel.elementAt(k);
					
					CatalogEntryDataBean dbItem = new CatalogEntryDataBean();
					dbItem.setCatalogEntryID(abCatenrel.getCatalogEntryIdChild());
					DataBeanManager.activate(dbItem, cmdContext);
					CatalogEntryDescriptionAccessBean abCatentryDesc= dbItem.getDescription();
					
					String strQty			   = abCatenrel.getQuantity();
					String strSequence		   = abCatenrel.getSequence();
					if(strQty==null || strQty.length()==0)
						strQty="0";
					if(strSequence==null || strSequence.length()==0)
						strSequence="0";
					
			%>		
					oSKU= new SKUObj(    "<%=dbItem.getCatalogEntryReferenceNumber() %>",
										 "<%=toJavaScript(dbItem.getPartNumber()) %>",
										 "<%=toJavaScript(abCatentryDesc.getName()) %>",
										 "<%=toJavaScript(abCatentryDesc.getShortDescription()) %>",
										 <%=strQty %>,
										 <%=strSequence %>,
										 "<%=dbItem.getType()%>");				
										 
					oSKUArray[oSKUArray.length]=oSKU;					 
					
			<%	}	//Eof for k		%>
 
			oRow = new DTRow(oKit.partNumber);
			oRow.oKit = oKit;
			oRow.oSKUArray = oSKUArray;

			<% if(nCatentryMemberId.longValue()!= nStoreMemberId.longValue()) {%>
				oRow.flag=FLAG_UNEDITABLE;
			<%}%>			
			
			
			//addDTRow(oRow);
			tc[tc.length]=oRow;
	
	<% } 	// Eof for i %>
}

/////////////////////////////////////////////////////////////////////////////////////
// reloadKitData(modelKitContents)
//
// - load or reload data for a Kit
/////////////////////////////////////////////////////////////////////////////////////
function reloadKitData(modelKitContents)
{
	// add a new Kit, or reload an updated Kit
	<% if(strActionKit.equals("LOAD_KIT")) 
	   { 
			String strCatentryId = jspHelper.getParameter("LOAD_KIT_catentryId");

			CatalogEntryAccessBean abCatentry = new CatalogEntryAccessBean();
			abCatentry.setInitKey_catalogEntryReferenceNumber(strCatentryId);
			
			CatalogEntryDataBean dbCatentry = new CatalogEntryDataBean(abCatentry,cmdContext);	

			String strType=getCatentryType(dbCatentry);
				
			String strPartNumber = abCatentry.getPartNumber();
			String strName = getName(dbCatentry);								//SearchUtil
			String strShotDesc = getShortDescription(dbCatentry);				//SearchUtil
			
			Vector vCatenRel=getCatentryRelationAccessBean(dbCatentry.getCatalogEntryReferenceNumberInEntityType());
		%>
			
		oKit = new KitObj("<%= strCatentryId %>",
						  "<%= toJavaScript(strPartNumber) %>",
						  "<%= strType %>",
						  "<%= toJavaScript(strName) %>",
						  "<%= toJavaScript(strShotDesc) %>",
						  <%= vCatenRel.size()%> );	
		
		oSKUArray = new Array();
		<%	
			for(int k=0; k<vCatenRel.size(); k++)
			{
				CatalogEntryRelationAccessBean abCatenrel= (CatalogEntryRelationAccessBean) vCatenRel.elementAt(k);
				
				CatalogEntryDataBean dbItem = new CatalogEntryDataBean();
				dbItem.setCatalogEntryID(abCatenrel.getCatalogEntryIdChild());
				DataBeanManager.activate(dbItem, cmdContext);
				CatalogEntryDescriptionAccessBean abCatentryDesc= dbItem.getDescription();
				
				String strQty			   = abCatenrel.getQuantity();
				String strSequence		   = abCatenrel.getSequence();
				if(strQty==null || strQty.length()==0)
					strQty="0";
				if(strSequence==null || strSequence.length()==0)
					strSequence="0";
		%>		
				oSKU= new SKUObj(	 "<%=dbItem.getCatalogEntryReferenceNumber() %>",
									 "<%= toJavaScript(dbItem.getPartNumber()) %>",
									 "<%= toJavaScript(abCatentryDesc.getName()) %>",
									 "<%= toJavaScript(abCatentryDesc.getShortDescription()) %>",
									 <%=strQty %>,
									 <%=strSequence %>,
									 "<%=dbItem.getType()%>");				
									 
				oSKUArray[oSKUArray.length]=oSKU;					 
				
		<%	}	//Eof for k		%>

		oRow = new DTRow(oKit.partNumber);
		oRow.oKit = oKit;
		oRow.oSKUArray = oSKUArray;

		//addDTRow(oRow);
		var bAddDTRow=true;
		var tc=modelKitContents.DTableListRows;
		for(var n=0; n<tc.length; n++)
		{
		  if(tc[n].oKit.catentryId=="<%=strCatentryId %>")
		  {
		  	//tc[n].oKit=oRow.oKit;						// not a new one, only update the Kit
			tc[n].oKit.partNumber 	= oRow.oKit.partNumber;
			tc[n].oKit.type			= oRow.oKit.type;
			tc[n].oKit.name 		= oRow.oKit.name;
			tc[n].oKit.shortDesc 	= oRow.oKit.shortDesc;

		  	bAddDTRow=false;
		  	break;
		  }
		}  
		if(bAddDTRow)
		{
			//tc[tc.length]=oRow;
			for(var n=tc.length; n>0; n--)				//Change to add the new row at top and select it
			{  	
				tc[n]=tc[n-1];
				tc[n].bSelected=false;
			}
			tc[0]=oRow;
			//tc[0].bSelected=true;						//will be pre-selected in the List frame,
			
			modelKitContents.nListScrollTop=0;			//scroll to top
		}	

	<%  } //Eof if%>
}

/////////////////////////////////////////////////////////////////////////////////////
// constructKitModel()
//
// - construct the model
/////////////////////////////////////////////////////////////////////////////////////
function constructKitModel()
{
	var modelKitContents = retrieveKitModel();
	
	if(modelKitContents==null)
	{
		// First time come in, search for PB
		modelKitContents = new KitContentsModel();
		
		populateFromSearchResults(modelKitContents.DTableListRows);
	}	
	else
	{			
		// add a new Kit, or reload an updated Kit
		reloadKitData(modelKitContents);
	}
	return modelKitContents;
}

/////////////////////////////////////////////////////////////////////////////////////
// processSKUPickups()
//
// - if it's comming back from SKU Pick List, add the selectd SKUs into Kits
/////////////////////////////////////////////////////////////////////////////////////
function processSKUPickups()
{
	if('<%=strActionKit%>'==SKU_PICK_ACTION_ADD)
	{
		var urlParam=top.mccbanner.trail[top.mccbanner.counter].parameters;
		if(urlParam!=null)
			urlParam['actionKit']= null;
	
		ContentBtn.addSelectedSKUsToKit();
	}	
}

/////////////////////////////////////////////////////////////////////////////////////
// cloneDTRow(oRow)
//
// - clone a DTRow object
/////////////////////////////////////////////////////////////////////////////////////
function cloneDTRow(o)
{
	var oRow = new DTRow();
		
	// 3 possible objects 				
	if(defined(o.oSKU))
		oRow.oSKU=cloneSKU(o.oSKU);
	
	if(defined(o.oSKUArray))
		oRow.oSKUArray= cloneSKUArray(o.oSKUArray);
	
	if(defined(o.oKit))
		oRow.oKit= cloneObj(o.oKit);

	// and other fields
	for(var x in o)
	 if((typeof o[x] != "object") &&(typeof o[x] != "function"))
				oRow[x]=o[x];

	return oRow;	
}

/////////////////////////////////////////////////////////////////////////////////////
// cloneDTableCotents(tableContents)
//
// - clone the content of a DTable
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
		var modelKitContents = constructKitModel();

		ListBtn.init();
					
		if(! List.init(modelKitContents.DTableListRows, modelKitContents.DTableListRemovedRows))
		{
			ContentBtn.init();
			
			Content.init(modelKitContents.DTableContentsRows, modelKitContents.DTableContentsRemovedRows, 
						modelKitContents.bShowCommonContent, modelKitContents.bCommonContentRefreshed);
		}
		
		processSKUPickups();

		//restore the scroll-position
		List.divDTable.scrollTop = modelKitContents.nListScrollTop;
		Content.divDTable.scrollTop = modelKitContents.nContentScrollTop;

		parent.setContentFrameLoaded(true);
	}
	else if(nFramesLoaded > 4)
	{
		ListBtn.init();
		List.refreshTable();
	}	
	
	deactivateSearchBean();
}


</SCRIPT>

<META name="GENERATOR" content="IBM WebSphere Studio">
<TITLE><%=UIUtil.toHTML((String)nlsKit.get("titleKitLayout"))%></TITLE>
</HEAD>

<script>
	
	var strWebPath= top.getWebPath();
	top.put("ProductUpdateDetailCatentryId", null);
	
	document.write("<frameset framespacing='0' frameborder='0' rows='50%,50%,0' id='LayoutFrameSet'> 		");
	document.write("	<frameset frameborder='0' framespacing='0' cols='86%,14%' id='ListFrameSet'>	");
	document.write("		<frame src='" + strWebPath + "KitListView'  name='List' scrolling='no' title='<%=getNLString(nlsKit,"fmKitList")%>' >	");
	document.write("		<frame src='" + strWebPath + "KitListBtnView' name='ListBtn' scrolling='no' title='<%=getNLString(nlsKit,"fmKitListBtn")%>'>");
	document.write("	</frameset>																		");
	document.write("	<frameset frameborder='0' framespacing='0' cols='86%,14%' id='ContentsFrameSet'>");
	document.write("		<frame src='" + strWebPath + "KitContentsView' name='Content' scrolling='no' title='<%=getNLString(nlsKit,"fmContent")%>'>			");
	document.write("		<frame src='" + strWebPath + "KitContentsBtnView' name='ContentBtn' scrolling='no' title='<%=getNLString(nlsKit,"fmContentBtn")%>'>");
	document.write("	</frameset>		");
	document.write("	<frame scrolling=no frameborder=no framespacing=0 name=Hidden src='/webapp/wcs/tools/servlet/KitHiddenView' title='<%=getNLString(nlsKit,"titleKitAddHidden")%>'>");
	document.write("</frameset>	");

	parent.isDialog=null;
	
</script>

</HTML>
