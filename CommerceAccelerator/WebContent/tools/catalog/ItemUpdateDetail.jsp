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

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 TRANSITIONAL//EN">
<%
//---------------------------------------------------------------------
//- Import and Include Section
//---------------------------------------------------------------------
%>
<%@ page language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="com.ibm.commerce.tools.util.ResourceDirectory" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.tools.util.UIUtil" %>
<%@ page import="com.ibm.commerce.tools.util.Util" %>
<%@ page import="com.ibm.commerce.catalog.beans.*" %>
<%@ page import="com.ibm.commerce.catalog.objects.*" %>
<%@ page import="com.ibm.commerce.common.objects.StoreAccessBean" %>
<%@ page import="com.ibm.commerce.contract.objects.ContractAccessBean" %>
<%@ page import="com.ibm.commerce.contract.objects.TradingAgreementAccessBean" %>
<%@ page import="com.ibm.commerce.beans.DataBeanManager" %>
<%@ page import="com.ibm.commerce.base.objects.ServerJDBCHelperBean" %>
<%@ page import="com.ibm.commerce.productset.commands.util.*" %>
<%@ page import="com.ibm.commerce.attachment.common.ECAttachmentConstants" %>

<%@include file="../common/common.jsp" %>
<%@include file="../catalog/CatalogSearchUtil.jsp" %>
<%@include file="../catalog/TradingAgreements.jspf" %>
<%@include file="../catalog/Worksheet2.jspf" %>

<%
	
	CommandContext cmdContext = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
	Hashtable rbProduct       = (Hashtable)ResourceDirectory.lookup("catalog.ProductNLS", cmdContext.getLocale());
	String myMemberId         = cmdContext.getStore().getMemberId();
	
	JSPHelper helper= new JSPHelper(request);
	String parentCatentryId = helper.getParameter("parentCatentryId");
	String catentryId = helper.getParameter("catentryId");
	String displayNum  = helper.getParameter("pageSize");
	String startIndex  = helper.getParameter("startIndex");
	String catentryArray  = helper.getParameter("catentryArray");
	String catentryNewArray  = helper.getParameter("catentryNewArray");
	
	int iStartIndex=0, iEndIndex=0, iPageSize=0;

	String strCatentryArray = "";
	String strCatentryNewArray = "";
	String strCatentryId = null;
	Vector vCatentries = new Vector();
	Vector vNewCatentries = new Vector();

	try {
		iStartIndex = Integer.parseInt(startIndex);
	} catch (Exception e) {
		iStartIndex = 0;
	}

	try {
		iPageSize   = Integer.parseInt(displayNum);
	} catch (Exception e) {
		iPageSize   = 25;
	}
	
	
	Hashtable hXMLFile1 = (Hashtable)ResourceDirectory.lookup("catalog.CatalogPageList");
	Hashtable hData = (Hashtable) hXMLFile1.get("data");
	Vector vTabs = (Vector) hData.get("tab");
	Vector vCols = (Vector) hData.get("column");


	Hashtable hXMLFile2 = (Hashtable)ResourceDirectory.lookup(request.getParameter("menuXML"));
	Hashtable hMenuList = (Hashtable) hXMLFile2.get("menuList");
	Vector vMenus = (Vector) hMenuList.get("menu");
	Vector vFuncs = new Vector();

	for (int i=0; i<vMenus.size(); i++)
	{
		Hashtable hMenu = (Hashtable) vMenus.elementAt(i);
		Vector vFunctions = null;
		java.lang.Object oFunctions = hMenu.get("function");
		if (oFunctions == null)
		{
			vFunctions = new Vector();
		} else {
			if (oFunctions.getClass().getName().equalsIgnoreCase("java.util.Vector"))
			{
				vFunctions = (Vector) oFunctions;
			} else {
				vFunctions = new Vector();
				vFunctions.addElement((Hashtable)oFunctions);
			}
		}

		vFuncs.addElement(vFunctions);
	}
%>

<HTML>
<HEAD>

<LINK rel=stylesheet href="<%= UIUtil.getCSSFile(cmdContext.getLocale()) %>" type="text/css">

<TITLE><%=UIUtil.toHTML((String)rbProduct.get("ItemUpdateDialog_FrameTitle_2"))%></TITLE>

<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/catalog/CatalogCommonFunctions.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/common/ConvertToXML.js"></SCRIPT>
<script src="/wcs/javascript/tools/attachment/Constants.js"></script>

<SCRIPT LANGUAGE="JavaScript">
    
	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	// Important Global Variables
	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	var product   = new Object();
	var catentryArray = new Array();
	var languages = new Array();
	var ccStoreID  = "<%=cmdContext.getStoreId().toString()%>";
	var currentLanguage = <%= cmdContext.getLanguageId() %>;
	currentFrameName = "secondIFRAMENAME";

	// Strings used in common javascript functions
	searchTableForValue_notfound = "<%= UIUtil.toJavaScript((String)rbProduct.get("ProductUpdateDetail_searchTableForValue_notfound")) %>";
	productUpdateDetailNoProducts = "<BR><%= UIUtil.toJavaScript((String)rbProduct.get("ProductUpdateDetailNoItems"))%>";
	msgNoChangesToSave = "<%= UIUtil.toJavaScript((String)rbProduct.get("descriptiveAttributeNoChangesToSave")) %>";
	msgConfirmDelete = "<%= UIUtil.toJavaScript((String)rbProduct.get("ItemDeleteMsg")) %>";

	<%= createDataObject(cmdContext.getLanguageId()) %>

<%
	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	// Retrieve the product data
	///////////////////////////////////////////////////////////////////////////////////////////////////////////

	CatalogEntryAccessBean abEntry2 = new CatalogEntryAccessBean();
	abEntry2.setInitKey_catalogEntryReferenceNumber(parentCatentryId);

	String strDoIOwn = "false";
	if (abEntry2.getMemberId().equals(myMemberId)) { strDoIOwn = "true"; }
	else                                          { strDoIOwn = "false"; }
%>

	data[0] = new DataObject();
	<%=createData(cmdContext, abEntry2, false, rbProduct, 0)%>
	data[0].DOIOWN     = <%= strDoIOwn %>;
	if (parent.readonlyAccess == true) data[0].DOIOWN = false;
	data[0].category   = "&nbsp;";
	data[0].categoryID = "-1";


<%
	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	// Retrieve the item beans which belong to this catentry
	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	if (catentryArray != null)
	{
%>
		catentryArray = top.get("SKULineUpdateCatentryArray", null);

<%
		int iOffsetStart=0, iOffsetEnd=0;
		iEndIndex=iStartIndex;
		while (iOffsetStart < catentryArray.length())
		{
			iOffsetEnd = catentryArray.indexOf(",",iOffsetStart);
			if (iOffsetEnd == -1) { iOffsetEnd = catentryArray.length(); }

			strCatentryId = catentryArray.substring(iOffsetStart, iOffsetEnd);
			vCatentries.addElement(strCatentryId);
			iOffsetStart = iOffsetEnd + 1;
			iEndIndex++;
		}

		if (catentryNewArray != null && catentryNewArray.trim().equals("") == false)
		{
			iOffsetStart=0;
			iOffsetEnd=0;
			while (iOffsetStart < catentryNewArray.length())
			{
				iOffsetEnd = catentryNewArray.indexOf(",",iOffsetStart);
				if (iOffsetEnd == -1) { iOffsetEnd = catentryNewArray.length(); }
	
				strCatentryId = catentryNewArray.substring(iOffsetStart, iOffsetEnd);
				vNewCatentries.addElement(strCatentryId);
				iOffsetStart = iOffsetEnd + 1;
			}
		}

		if (catentryId != null && catentryId.equals("null") == false)
		{
			boolean bFound = false;
			for (int i=0; i<vCatentries.size(); i++)
			{
				if (catentryId.equals((String) vCatentries.elementAt(i))) { bFound = true; }
			}
			for (int i=0; i<vNewCatentries.size(); i++)
			{
				if (catentryId.equals((String) vNewCatentries.elementAt(i))) { bFound = true; }
			}
			if (bFound == false) 
			{ 
				vNewCatentries.addElement(catentryId);
			}
		}

	} else {
		//
		// Read the entries in the product
		Vector vResults = new Vector();
		if (parentCatentryId != null && parentCatentryId.equals("null") == false)
		{
			try 
			{	
				ProductSetEntitlementHelper psHelper;
			
				// Out-of-box, Accelerator behaves like the store front. So if products are excluded
				// in the default store contract, then we won't be able to browse or search them in Accelerator.
				// By default, the method isRemoveDefaultContract() returns false. 
				// By changing this method to return true, then we remove any default contract that
				// we pass to ProductSetEntitlementHelper.
				// isRemoveDefaultContract() is defined in the file DefaultContractBehavior.jspf
		
				
				boolean removeDefaultContract = isRemoveDefaultContract();
				TradingAgreementAccessBean[] outAgreementABs = getCurrentTradingAgreements(removeDefaultContract,cmdContext.getCurrentTradingAgreements());
				
				psHelper = new ProductSetEntitlementHelper(outAgreementABs,cmdContext.getUserId(), true);
			
				//ProductSetEntitlementHelper psHelper = new ProductSetEntitlementHelper(cmdContext.getCurrentTradingAgreements(),cmdContext.getUserId(), true);
				Long[] inclusionPS = psHelper.getIncludeProductSets();
				Long[] exclusionPS = psHelper.getExcludeProductSets();
			
				ItemAccessBean abItems = new ItemAccessBean();      
				Enumeration e = abItems.findEntitledItemsByProduct(new Long(parentCatentryId), inclusionPS, exclusionPS);
				while (e.hasMoreElements())
				{
					ItemAccessBean abItem = (ItemAccessBean) e.nextElement();
					Vector v = new Vector();
					v.addElement(abItem.getCatalogEntryReferenceNumber());
					vResults.addElement(v);
				}
			} catch (Exception e) {}
		} else {
			try 
			{
				vResults = catEntrySearchDB.getResultSet();
			} catch (Exception e) { vResults = new Vector(); }
		} 
		
		iEndIndex = iPageSize;
		if (iPageSize > vResults.size()) 
		{ 
			iEndIndex=vResults.size(); 
		}
		for (int i=0; i<vResults.size(); i++)
		{
			strCatentryId = (String) ((Vector) vResults.elementAt(i)).elementAt(0).toString();
			if (i < iEndIndex) 
			{ 
				vCatentries.addElement(strCatentryId); 
			}
%>
			catentryArray[<%=i%>] = "<%=strCatentryId%>";
<%
		}
%>
		top.put("SKULineUpdateCatentryArray",catentryArray);
<%
	}
	int index = 1;
	CatalogEntryAccessBean abEntry = null;
	for (int i=0; i<vCatentries.size(); i++)
	{
		try 
		{
			abEntry = new CatalogEntryAccessBean();
			abEntry.setInitKey_catalogEntryReferenceNumber((String)vCatentries.elementAt(i));
			if (strCatentryArray.length() > 0) { strCatentryArray += ","; }
			strCatentryArray += (String)vCatentries.elementAt(i);
%>
data[<%=index%>] = new DataObject();
<%=createData(cmdContext, abEntry, true, rbProduct, index)%>
if (parent.readonlyAccess == true) data[<%=index%>].DOIOWN = false;


<%
index++;
} catch (Exception e) {}
} 


for (int i=0; i<vNewCatentries.size(); i++)
{
try 
{
abEntry = new CatalogEntryAccessBean();
abEntry.setInitKey_catalogEntryReferenceNumber((String)vNewCatentries.elementAt(i));
if (strCatentryNewArray.length() > 0) { strCatentryNewArray += ","; }
strCatentryNewArray += (String)vNewCatentries.elementAt(i);

%>
data[<%=index%>] = new DataObject();
data[<%=index%>].isNew = true;
<%=createData(cmdContext, abEntry, true, rbProduct, index)%>

<%
index++;
} catch (Exception e) {}
} 

%>


	//////////////////////////////////////////////////////////////////////////////////////
	// ContextMenu()
	//
	// - displays the context menu if a right-click event occured
	//////////////////////////////////////////////////////////////////////////////////////
	function ContextMenu()
	{
		if (checkDisplayExtras()) return;
		var popupBody = "";
		var element = event.srcElement;

		if (element.tagName == "TABLE") return;
		while (element.tagName != "TD") element = element.parentElement;
		var index = element.parentNode.rowIndex;
		if (index == 0) return;
		if (element.firstChild) setAsCurrent(element.firstChild);

		if (element.className == "CORNER")  return;
		if (element.className == "COLHEAD") return;
		if (element.className == "ROWHEAD") return;

		popupBody += "<DIV ID='divPopup' STYLE='width:196; font-size:9pt; background:#EFEFEF; border-color : WHITE; border-style : solid; border-width : 1px; filter: progid:DXImageTransform.Microsoft.Shadow(color=#777777, Direction=135, Strength=4) alpha(Opacity=90);'>";
<%
		Hashtable hContextMenu = (Hashtable) hMenuList.get("context");
		Vector vContextFuncs = (Vector) hContextMenu.get("function");

		for (int ii=0; ii<vContextFuncs.size(); ii++)
		{
			Hashtable hContextFunc = (Hashtable) vContextFuncs.elementAt(ii);
			String strFuncId = (String)hContextFunc.get("id");
			if (strFuncId.equals("HR"))
			{
%>
				popupBody += "<HR STYLE='height:1px; color=white' WIDTH=94%>";
<%
			} else {
%>
				(parent.titleFrame.showMenu_<%=strFuncId%>() == true) ? popupBody += parent.titleFrame.div<%=strFuncId%>_ON.outerHTML : popupBody += parent.titleFrame.div<%=strFuncId%>_OFF.outerHTML;
<%
			}
		}
%>
		popupBody += "</DIV>";

		parent.titleFrame.oPopup.document.body.innerHTML = popupBody; 
		if (currentFrameName == "firstIFRAMENAME") parent.titleFrame.oPopup.show(event.clientX+2, event.clientY+2, 200, 224, document.body);
		else                                       parent.titleFrame.oPopup.show(event.clientX+2, event.clientY+2, 200, 182, document.body);
		
		var nWidth=parent.titleFrame.oPopup.document.getElementById('divPopup').scrollWidth;
		var nHeight=parent.titleFrame.oPopup.document.getElementById('divPopup').scrollHeight;
		parent.titleFrame.oPopup.show(event.clientX+2, event.clientY+2, 
					parent.titleFrame.oPopup.document.getElementById('divPopup').scrollWidth+4,
					parent.titleFrame.oPopup.document.getElementById('divPopup').scrollHeight+4,
					document.body);
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// isValidNumericValue(value, language, minValue, maxValue)
	//
	// - determine if the value is valid
	//////////////////////////////////////////////////////////////////////////////////////
	function isValidNumericValue(value, language, minValue, maxValue)
	{
		if (top.isValidNumber(value, language, false) == false) { alertDialog("<%= UIUtil.toJavaScript((String)rbProduct.get("ProductUpdateValidation_InvalidNumber")) %>"); return false; }
		if ((minValue && value < minValue) || (maxValue && value > maxValue)) { alertDialog("<%= UIUtil.toJavaScript((String)rbProduct.get("ProductUpdateValidation_OutsideRange")) %>"); return false; }
		return true;
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// isValidIntegerValue(value, language, minValue, maxValue)
	//
	// - determine if the value is valid
	//////////////////////////////////////////////////////////////////////////////////////
	function isValidIntegerValue(value, language, minValue, maxValue)
	{
		if (top.isValidInteger(value, language) == false) { alertDialog("<%= UIUtil.toJavaScript((String)rbProduct.get("ProductUpdateValidation_InvalidInteger")) %>"); return false; }
		if ((minValue && value < minValue) || (maxValue && value > maxValue)) { alertDialog("<%= UIUtil.toJavaScript((String)rbProduct.get("ProductUpdateValidation_OutsideRange")) %>"); return false; }
		return true;
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// isValidStringValue(value, length, nullableTF, specialTF)
	//
	// - determine if the value is valid
	//////////////////////////////////////////////////////////////////////////////////////
	function isValidStringValue(value, length, nullableTF, nameTF)
	{
		if ((length != -1) && (isValidUTF8length(value, length) == false)) {
			alertDialog("<%= UIUtil.toJavaScript((String)rbProduct.get("fieldSizeExceeded"))%>"); return false; 
		}
		if (nullableTF == false && (value == null || isInputStringEmpty(value) == true)) { alertDialog("<%= UIUtil.toJavaScript((String)rbProduct.get("ProductUpdateValidation_EmptyRequiredField"))%>"); return false; }
		if (nameTF == true && isValidName(value) == false) { alertDialog("<%= UIUtil.toJavaScript((String)rbProduct.get("productNameNotValidMessage"))%>"); return false; }
	}

	//////////////////////////////////////////////////////////////////////////////////////
	// toolbarListAttachment(element)
	//
	// - check if it is a valid integer
	//////////////////////////////////////////////////////////////////////////////////////
	function toolbarListAttachment() {

		if (toolbarCurrentElement == null) return;
		if (leavingPageFunction() == false) return;
		saveReturnData();

		var index = toolbarCurrentElement.parentNode.parentNode.rowIndex;
		var url = top.getWebPath() + "AttachmentListDialogView";
		var urlPara = new Object();
		
		urlPara.objectType = "<%=ECAttachmentConstants.EC_ATCH_OBJECT_TYPE_CATALOG_ENTRY%>";
		urlPara.objectId = data[index].ID;
		urlPara.readOnly = !parent.attachmentAccessGained;
		
		top.setContent("<%=UIUtil.toJavaScript((String) rbProduct.get("ProductUpdateMenuTitle_ShowAttachment"))%>", url, true, urlPara);    
	}
	
	//////////////////////////////////////////////////////////////////////////////////////
	// toolbarAddAttachment(element)
	//
	// - check if it is a valid integer
	//////////////////////////////////////////////////////////////////////////////////////
	function toolbarAddAttachment() {

		if (toolbarCurrentElement == null) return;
		if (leavingPageFunction() == false) return;
		saveReturnData();

		var index = toolbarCurrentElement.parentNode.parentNode.rowIndex;
		var url = top.getWebPath() + "PickAttachmentAssetsTool";
		var urlPara  = new Object();

		urlPara.objectId    = data[index].ID;
		urlPara.objectType	= "<%=ECAttachmentConstants.EC_ATCH_OBJECT_TYPE_CATALOG_ENTRY%>";
		urlPara.saveChanges = true;
		urlPara.returnPage = CONSTANT_TOOL_LIST;
		
		top.setContent("<%=UIUtil.toJavaScript((String) rbProduct.get("ProductUpdateMenuTitle_AddAttachment"))%>", url, true, urlPara);
	}

	//////////////////////////////////////////////////////////////////////////////////////
	// toolbarShowContents(elementID)
	//
	// - open the Kit contents tool
	//////////////////////////////////////////////////////////////////////////////////////
	function toolbarShowContents(elementID)
	{
		if (elementID == null) return;
		if (leavingPageFunction() == false) return;
		saveReturnData("item");

		var url = top.getWebPath() + "DialogView";
		var urlPara  = new Object();
		urlPara['XMLFile']    = "catalog.KitContentsDialog";
		urlPara['catentryID'] = elementID;
		top.setContent("<%= UIUtil.toJavaScript((String)rbProduct.get("productUpdateDetail_KitContents")) %>", url, true, urlPara);     
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// toolbarShowContaining(elementID)
	//
	// - open the Kit contents tool
	//////////////////////////////////////////////////////////////////////////////////////
	function toolbarShowContaining(elementID)
	{
		if (elementID == null) return;
		if (leavingPageFunction() == false) return;
		saveReturnData("item");
		var url = top.getWebPath() + "DialogView";
		var urlPara  = new Object();
		urlPara['XMLFile']    = "catalog.KitContentsDialog";
		urlPara['catentryID'] = elementID;
		urlPara['strFindByChild'] = "true";
		top.setContent("<%= UIUtil.toJavaScript((String)rbProduct.get("productUpdateDetail_KitContents")) %>", url, true, urlPara);     
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// toolbarShowAssociationsFrom(elementID)
	//
	// - open the Massoc tool
	//////////////////////////////////////////////////////////////////////////////////////
	function toolbarShowAssociationsFrom(elementID)
	{
		if (elementID == null) return;
		if (leavingPageFunction() == false) return;
		saveReturnData("item");
		var url = top.getWebPath() + "DialogView";
		var urlPara  = new Object();
		urlPara['XMLFile']    = "catalog.MAssociationDialog";
		urlPara['catentryID'] = elementID;
		urlPara['strFindByChild'] = "true";
		top.setContent("<%= UIUtil.toJavaScript((String)rbProduct.get("productUpdateDetail_MerchandisingAssociations")) %>", url, true, urlPara);     
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// toolbarShowAssociations()
	//
	// - open the Merchandising Association tool
	//////////////////////////////////////////////////////////////////////////////////////
	function toolbarShowAssociations(elementID)
	{
		if (leavingPageFunction() == false) return;
		saveReturnData("item");

		var catentryIDString = "";
		for (var i=1; i<dTable.rows.length; i++)
		{
			if (dTable.rows(i).cells(0).firstChild.checked == true) 
			{
				catentryIDString += data[i].ID + ",";
			}
		}

		var url = top.getWebPath() + "DialogView";
		var urlPara  = new Object();
		urlPara['XMLFile']    = "catalog.MAssociationDialog";
		urlPara['catentryID'] = catentryIDString;
		top.setContent("<%= UIUtil.toJavaScript((String)rbProduct.get("productUpdateDetail_MerchandisingAssociations")) %>", url, true, urlPara);     
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// toolbarDescriptive()
	//
	// - Open the find menu
	//////////////////////////////////////////////////////////////////////////////////////
	function toolbarDescriptive(elementID)
	{
		if (elementID == null) return;
		if (leavingPageFunction() == false) return;
		saveReturnData("item");

		top.saveData(elementID, "ProductUpdateElementID");
		var url              = "/webapp/wcs/tools/servlet/DialogView"
		var urlPara          = new Object();
		urlPara.catentryID   = elementID;
		urlPara.XMLFile      = "catalog.descriptiveAttributeDialog";
		top.setContent("<%= UIUtil.toJavaScript((String)rbProduct.get("productUpdateDetail_DescriptiveAttributes")) %>", url, true, urlPara);     
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// toolbarSetPrices(elementID)
	//
	// - Display the existing 5.4 pricing menu
	//////////////////////////////////////////////////////////////////////////////////////
	function toolbarSetPrices(elementID)
	{
		if (elementID == null) return;
		if (leavingPageFunction() == false) return;
		saveReturnData("item");

		var url            = "/webapp/wcs/tools/servlet/PricingDialogView";
		var urlPara        = new Object();
		urlPara.XMLFile    = "catalog.pricingDialog";
		urlPara.refNum     = elementID;
		urlPara.isSummary  = false;
		top.setContent("<%=UIUtil.toJavaScript((String)rbProduct.get("productUpdateDetailBCT_SetPrices"))%>", url, true, urlPara);     
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// toolbarPriceSummary(elementID)
	//
	// - Display the existing 5.4 pricing summary menu
	//////////////////////////////////////////////////////////////////////////////////////
	function toolbarPriceSummary(elementID)
	{
		if (elementID == null) return;
		if (leavingPageFunction() == false) return;
		saveReturnData("item");

		var url            = "/webapp/wcs/tools/servlet/PricingDialogView";
		var urlPara        = new Object();
		urlPara.XMLFile    = "catalog.pricingSummaryDialog";
		urlPara.refNum     = elementID;
		urlPara.isSummary  = true;
		top.setContent("<%=UIUtil.toJavaScript((String)rbProduct.get("productUpdateDetailBCT_PricingSummary"))%>", url, true, urlPara);     
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// toolbarCreate(type)
	//
	// - open the create wizard
	//////////////////////////////////////////////////////////////////////////////////////
	function toolbarCreate(type)
	{
		if (leavingPageFunction() == false) return;
		saveReturnData("item");

		var url = "/webapp/wcs/tools/servlet/WizardView";
		var urlPara          = new Object();
		urlPara.XMLFile      = "catalog.itemWizard";
		urlPara.productrfnbr = data[0].ID;
		urlPara.langId       = currentLanguage;
		urlPara.storeId      = ccStoreID;
		top.setContent("<%=UIUtil.toJavaScript((String)rbProduct.get("productUpdateDetailBCT_CreateItem"))%>", url, true, urlPara);     
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// toolbarDiscounts(elementID)
	//
	// - Display the existing 5.4 discount screen
	//////////////////////////////////////////////////////////////////////////////////////
	function toolbarDiscounts(elementID)
	{
		if (elementID == null) return;
		if (leavingPageFunction() == false) return;
		saveReturnData("item");

		var url            = "/webapp/wcs/tools/servlet/DialogView";
		var urlPara        = new Object();
		urlPara.XMLFile    = "discount.choseDiscount";
		top.saveData(elementID, "categoryId");

		top.setContent("<%=UIUtil.toJavaScript((String)rbProduct.get("ProductFindResults_button_discounts"))%>", url, true, urlPara);     
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// toolbarChange()
	//
	// - open the update notebook
	//////////////////////////////////////////////////////////////////////////////////////
	function toolbarChange()
	{
		if (toolbarCurrentElement == null) return;
		if (leavingPageFunction() == false) return;
		saveReturnData("item");

		var index = toolbarCurrentElement.parentNode.parentNode.rowIndex;
		var url = "/webapp/wcs/tools/servlet/NotebookView";
		var urlPara          = new Object();
		urlPara.XMLFile      = "catalog.itemNotebook";
		urlPara.productrfnbr = data[0].ID;
		urlPara.itemrfnbr    = data[index].ID;
		urlPara.langId       = currentLanguage;
		urlPara.storeId      = ccStoreID;
		top.setContent("<%=UIUtil.toJavaScript((String)rbProduct.get("productUpdateDetailBCT_UpdateItem"))%>", url, true, urlPara);     
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// fcnIntegerOnChange(element)
	//
	// - check if it is a valid integer
	//////////////////////////////////////////////////////////////////////////////////////
	function fcnIntegerOnChange(element)
	{
		if (top.isValidInteger(element.value, currentLanguage) == false)
		{
			element.title = "<%= UIUtil.toJavaScript((String)rbProduct.get("ProductUpdateDetail_InvalidIntegerTooltip")) %>";
			element.style.color = "#FF0000";
		} else {
			element.title = "";
			element.style.color = "#000000";
		}
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// fcnNumberOnChange(element)
	//
	// - check if it is a valid number
	//////////////////////////////////////////////////////////////////////////////////////
	function fcnNumberOnChange(element)
	{
		if (top.isValidNumber(element.value, currentLanguage, false) == false)
		{
			element.title = "<%= UIUtil.toJavaScript((String)rbProduct.get("ProductUpdateDetail_InvalidNumberTooltip")) %>";
			element.style.color = "#FF0000";
		} else {
			element.title = "";
			element.style.color = "#000000";
		}
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// leavingPageFunction()
	//
	// - determine if a message needs to be displayed
	//////////////////////////////////////////////////////////////////////////////////////
	function leavingPageFunction()
	{
		if (dataChanged == false) return true;
		return confirmDialog("<%=UIUtil.toJavaScript((String)rbProduct.get("productUpdateDetailCancelConfirmation"))%>");
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// onLoad()
	//
	// - called when page is first loaded.  
	// - This creates the (empty) base rows for the items where data will be populated
	//////////////////////////////////////////////////////////////////////////////////////
	function onLoad()
	{	
		numOfTabs = <%=vTabs.size()%>;
		numOfCols = <%=vCols.size()%>;

		var urlParam=top.mccbanner.trail[top.mccbanner.counter].parameters;
		// set the iframe displays to none for all tabs
		for (var i=0; i<10; i++) toolbarCurrentElementArray[i] = null;
		displayView();
		calculateDisplayColumn();
		fillinView();
		generalDiv.style.display = "block";
		parent.detailPageLoaded();
		adjustColumnWidth();
		parent.titleFrame.setElementType(null, null, <%=strDoIOwn%>, null);
		if (defined(urlParam)) { retreiveSavedState("item") };
		colorRows();

		if (!urlParam)
		{
			top.mccbanner.trail[top.mccbanner.counter].parameters = new Object();
			urlParam=top.mccbanner.trail[top.mccbanner.counter].parameters;
		}
		urlParam['searchType'] = "";
		urlParam['catentryArray'] = "<%=strCatentryArray%>";
		urlParam['catentryNewArray'] = "<%=strCatentryNewArray%>";

		parent.titleFrame.setText(<%=iStartIndex%>, <%=iEndIndex%>, <%=iPageSize%>, catentryArray.length);
		
		top.showProgressIndicator(false);
		document.body.focus();
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


	var cellWidths = new Array();
	cellWidths[cellWidths.length] = "30px";
	cellWidths[cellWidths.length] = "150px";
	cellWidths[cellWidths.length] = "22px";
	cellWidths[cellWidths.length] = "0px";
<%
	for (int iCol=0; iCol<vCols.size(); iCol++)
	{
		Hashtable hCol = (Hashtable) vCols.elementAt(iCol);
%>
	cellWidths[cellWidths.length] = "<%=hCol.get("width")%>";
<%
	}
%>


	//////////////////////////////////////////////////////////////////////////////////////
	// fillinView()
	//
	// - fills in the PMT table contents
	//////////////////////////////////////////////////////////////////////////////////////
	function fillinView()
	{
		for (var i=1; i<data.length; i++) 
		{
			if (data[i].DOIOWN == false) {
				dTable.rows(i).cells(1).innerText = data[i].partNumber;
			} else {
				dTable.rows(i).cells(1).firstChild.innerText = data[i].partNumber;
			}
<%
	for (int iCol=0; iCol<vCols.size(); iCol++)
	{
		Hashtable hCol = (Hashtable) vCols.elementAt(iCol);
		if (hCol.get("type").toString().equalsIgnoreCase("TEXTAREA"))
		{
%>
			dTable.rows(i).cells(<%=iCol+4%>).firstChild.value = data[i].<%=hCol.get("id")%>;
<%
		}
		if (hCol.get("type").toString().equalsIgnoreCase("ANCHOR") && hCol.get("id").toString().equalsIgnoreCase("category") == false)
		{
%>
			if (data[i].DOIOWN == false) {
				dTable.rows(i).cells(<%=iCol+4%>).innerText = data[i].<%=hCol.get("id")%>;
			} else {
				dTable.rows(i).cells(<%=iCol+4%>).firstChild.innerText = data[i].<%=hCol.get("id")%>;
			}
<%
		}
	}
%>
		}
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// generateDiv()
	//
	// - generate the general table
	//////////////////////////////////////////////////////////////////////////////////////
	function generateDiv()
	{
		if (data.length > 1) {
			dTable.style.borderBottomWidth="1px";
			dTable.style.borderBottomStyle="solid";
			dTable.style.borderBottomColor="#6D6D7C";
		} else {
			dTable.style.borderBottomWidth="0px";
		}

		for (var i=1; i<data.length; i++) 
		{
			document.writeln("<TR CLASS=dtablehigh valign=top DOIOWN="+data[i].DOIOWN+"><TD CLASS=ROWHEAD><INPUT TYPE=CHECKBOX ONCLICK=rowClick(this)></TD>");
			document.writeln(createCellString(i, "ANCHOR",    "dtable",        data[i].partNumber, 'toolbarChangeAnchor(this)'));
			document.writeln(createCellString(i, "IMAGE",     "dtablecenter",  "", elementType(data[i].type)));
			document.writeln(createCellString(i, "STRING",    "dtable",        ""));

<%
	for (int iCol=0; iCol<vCols.size(); iCol++)
	{
		Hashtable hCol = (Hashtable) vCols.elementAt(iCol);
%>
	if ("<%=hCol.get("id")%>" == "category") {
		document.writeln(createCellString(i, "STRING", "<%=hCol.get("CLASS")%>", data[i].<%=hCol.get("id")%> , "<%=hCol.get("other")%>"));
	} else {
		document.writeln(createCellString(i, "<%=hCol.get("type")%>", "<%=hCol.get("CLASS")%>", data[i].<%=hCol.get("id")%> , "<%=hCol.get("other")%>","<%=hCol.get("id")%>"));
	}
<%
	}
%>
			document.writeln("</TR>");
		}
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// createCatalogEntryBaseXML(i)
	//
	// - creates and returns a string which represents the detail changes
	//////////////////////////////////////////////////////////////////////////////////////
	function createCatalogEntryBaseXML(i)
	{
		var chgString = "";

<%
	for (int iCol=0; iCol<vCols.size(); iCol++)
	{
		Hashtable hCol = (Hashtable) vCols.elementAt(iCol);
		String strColType = (String) hCol.get("type");
		if (strColType.equals("CHECKBOX")) {
%>
		if ( dTable.rows(i).cells(<%=iCol+4%>).firstChild.checked && data[i].<%=hCol.get("id")%> == 0) chgString += ' <%=hCol.get("id")%>="1"';
		if (!dTable.rows(i).cells(<%=iCol+4%>).firstChild.checked && data[i].<%=hCol.get("id")%> == 1) chgString += ' <%=hCol.get("id")%>="0"';
<%
		} else if (strColType.equals("TEXTAREA")) {
			String strInput = (String) hCol.get("input");
			if (strInput.equals("STRING")) {
%>
		if (data[i].<%=hCol.get("id")%> != dTable.rows(i).cells(<%=iCol+4%>).firstChild.value) 
		{
			if (isValidStringValue(dTable.rows(i).cells(<%=iCol+4%>).firstChild.value, <%=hCol.get("maxsize")%>, true, false) == false) return failTableEntry(i, <%=iCol+4%>);
			chgString += ' <%=hCol.get("id")%>="' + replaceSpecialChars(dTable.rows(i).cells(<%=iCol+4%>).firstChild.value) + '"';
		}
<%
			} else if (strInput.equals("INTEGER")) {
%>
		if (data[i].<%=hCol.get("id")%> != dTable.rows(i).cells(<%=iCol+4%>).firstChild.value) 
		{
			if (isValidIntegerValue(dTable.rows(i).cells(<%=iCol+4%>).firstChild.value, currentLanguage) == false) return failTableEntry(i, <%=iCol+4%>);
			chgString += ' <%=hCol.get("id")%>="' + dTable.rows(i).cells(<%=iCol+4%>).firstChild.value + '"';
		}
<%
			} else if (strInput.equals("DECIMAL")) {
%>
		if (data[i].<%=hCol.get("id")%> != dTable.rows(i).cells(<%=iCol+4%>).firstChild.value) 
		{
			if (isValidNumericValue(dTable.rows(i).cells(<%=iCol+4%>).firstChild.value, currentLanguage) == false) return failTableEntry(i, <%=iCol+4%>);
			chgString += ' <%=hCol.get("id")%>="' + dTable.rows(i).cells(<%=iCol+4%>).firstChild.value + '"';
		}
<%
			}
		}
	}
%>

		var action = "update";
		if (data[i].ID == -1 && dTable.rows(i).cells(1).firstChild.value != "")
		{
			action = "create";
			if (isValidStringValue(dTable.rows(i).cells(1).firstChild.value, 64, false, false) == false) return failTableEntry(i, 1);
			chgString += ' partNumber="' + dTable.rows(i).cells(1).firstChild.value + '"';
		}

		if (chgString != "") xmlString = '<CatalogEntry action="'+action+'" type="'+data[i].type+'" catalogEntryId="'+data[i].ID+'" languageId="' + data[i].languageId + '"' + chgString + ' />';
	}

	function escapeQuotes(obj)
	{
	   var string = new String(obj);
	   var result = "";
	
	   for (var i=0; i < string.length; i++ ) {
	      if (string.charAt(i) == "\"") result += "&quot;";
	      else result += string.charAt(i);
	   }
	   return result;
	}

	//////////////////////////////////////////////////////////////////////////////////////
	// savedCatalogEntryBase(i)
	//
	// - reset the data array
	//////////////////////////////////////////////////////////////////////////////////////
	function savedCatalogEntryBase(i)
	{
		if (data[i].DOIOWN == false) return;
<%
		for (int iCol=0; iCol<vCols.size(); iCol++)
		{
			Hashtable hCol = (Hashtable) vCols.elementAt(iCol);
			String strColType = (String) hCol.get("type");
			String strColId   = (String) hCol.get("id");
			if (strColType.equals("CHECKBOX")) {
%>
				if (dTable.rows(i).cells(<%=iCol+4%>).firstChild.checked) data[i].<%=strColId%> = 1;
				else data[i].<%=strColId%> = 0;
<%
			} else if (strColType.equals("TEXTAREA")) {
%>
				data[i].<%=strColId%> = dTable.rows(i).cells(<%=iCol+4%>).firstChild.value;
<%
			}
		}
%>
	}


</SCRIPT>

</HEAD>


<BODY CLASS=content ONLOAD="onLoad();" ONCONTEXTMENU="return false;" STYLE="margin-top=0px;">

<DIV ID=generalDiv STYLE="display: none;">
	<SCRIPT>
		var tableString = '';
		tableString += '<TABLE ID=dTable CELLSPACING=0 CELLPADDING=0 width=98% DRAGCOLOR=yellow ONCONTEXTMENU="ContextMenu(); return false;" style="table-layout:fixed; border-bottom: 1px solid #6D6D7C;">';
		tableString += '<THEAD><TR CLASS=dtableHeading ALIGN=middle cellpadding=0 cellspacing=0 height=23>';
		tableString += '<TD CLASS=CORNER  TABID=ALL STYLE="cursor:default; word-wrap:normal;">&nbsp;</TD>';
		tableString += '<TD CLASS=COLHEADNORMAL TABID=ALL STYLE="cursor:default; word-wrap:normal;"><%=UIUtil.toJavaScript((String)rbProduct.get("productUpdateDetail_PartNumber"))%></TD>';
		tableString += '<TD CLASS=COLHEADNORMAL TABID=ALL STYLE="cursor:default; word-wrap:normal;">&nbsp;</TD>';
		tableString += '<TD CLASS=COLHEADNORMAL TABID=ALL STYLE="cursor:default; word-wrap:normal;">&nbsp;</TD>';
<%
	for (int iCol=0; iCol<vCols.size(); iCol++)
	{
		Hashtable hColumn = (Hashtable) vCols.elementAt(iCol);
%>
		tableString += '<TD CLASS=COLHEADNORMAL HEIGHT=100% TABID=<%=hColumn.get("tabid")%> STYLE="cursor:default; word-break: keep-all; word-wrap: normal;"><LABEL for="<%=hColumn.get("id")%>"><%=UIUtil.toJavaScript((String)rbProduct.get((String)hColumn.get("title")))%></LABEL></TD>';
<%
	}
%>
		tableString += '</TR></THEAD>';
		document.writeln(tableString);
		generateDiv();
		document.writeln("</TABLE>");
		document.writeln("<SPAN ID=noProductsSpan>");
		if (data.length <= 1) document.writeln(productUpdateDetailNoProducts);
		document.writeln("</SPAN>");
	</SCRIPT>
</DIV>

<DIV ID=labelDiv STYLE="display: none;">
<%
	for (int ii=0; ii<vMenus.size(); ii++)
	{
		Hashtable hMenu = (Hashtable) vMenus.elementAt(ii);
		String strMenuId = (String)hMenu.get("id");
%>
		<LABEL FOR="fp<%=(String)hMenu.get("id")%>" ACCESSKEY="<%=UIUtil.toHTML((String)rbProduct.get((String)hMenu.get("accessKey")))%>"></LABEL>
	   <INPUT CLASS=menuButton iD="fp<%=strMenuId%>" TABINDEX="1" TYPE=BUTTON VALUE="<%=strMenuId%>" STYLE="width: 0px;" ONCLICK="parent.titleFrame.<%=strMenuId%>Menu();">
<%
	}
%>
</DIV>

<iframe name="findIframe" 
   title="<%=UIUtil.toHTML((String)rbProduct.get("ProductUpdateFind"))%>"
   MARGINHEIGHT=0 MARGINWIDTH=0 NORESIZE SCROLLING=NO 
   src="/webapp/wcs/tools/servlet/ProductUpdateFind" 
   style="display:none;position:absolute;top:150;left:100;width:400;height:16;z-index=100; border-width: 3px">
</iframe>

<iframe name="replaceIframe" 
   title="<%=UIUtil.toHTML((String)rbProduct.get("ProductUpdateReplace"))%>"
   MARGINHEIGHT=0 MARGINWIDTH=0 NORESIZE SCROLLING=NO 
   src="/webapp/wcs/tools/servlet/ProductUpdateReplace" 
   style="display:none;position:absolute;top:150;left:100;width:400;height:16;z-index=100">
</iframe>

<iframe name="textareaIframe"
   title="<%=UIUtil.toHTML((String)rbProduct.get("ProductUpdateContextMenu_Edit"))%>"
   MARGINHEIGHT=0 MARGINWIDTH=0 NORESIZE SCROLLING=NO 
   src="/wcs/tools/common/blank.html" 
   style="display:none;position:absolute;top:100;left:100;width:700;height:275;z-index=100">
</iframe>

<iframe name="categoryIframe"
   title="<%=UIUtil.toHTML((String)rbProduct.get("CatalogGroupTree_FrameTitle_1"))%>"
   MARGINHEIGHT=0 MARGINWIDTH=0 NORESIZE SCROLLING=YES 
   src="/wcs/tools/common/blank.html"
   style="border-style:inset;display:none;position:absolute;top:50;left:65%;width:33%;height:520">
</iframe>

<iframe name="imageIframe"
   title="<%=UIUtil.toHTML((String)rbProduct.get("productUpdateDetail_ThumbNail"))%>"
   MARGINHEIGHT=0 MARGINWIDTH=0 NORESIZE SCROLLING=YES 
   src="/wcs/tools/common/blank.html"
   style="border-style:outset;display:none;position:absolute;top:10;left:10;width:97%;height:97%">
</iframe>
</BODY>
</HTML>
