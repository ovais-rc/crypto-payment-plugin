<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2002, 2009 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>


<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
<%
//---------------------------------------------------------------------
//- Import and Include Section
//---------------------------------------------------------------------
%>
<%@ page language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.tools.util.UIUtil" %>
<%@ page import="com.ibm.commerce.beans.DataBeanManager" %>
<%@ page import="com.ibm.commerce.tools.common.ToolsConfiguration" %>
<%@ page import="com.ibm.commerce.discount.rules.DiscountConst" %> 

<%@include file="../common/common.jsp" %>

<%
	CommandContext cmdContext = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
	Hashtable rbProduct = (Hashtable)ResourceDirectory.lookup("catalog.ProductNLS", cmdContext.getLocale());
	Hashtable rbUI      = (Hashtable)ResourceDirectory.lookup("common.uiNLS", cmdContext.getLocale());
	String jsFunction  = request.getParameter("jsFunction"); 
	String catgroupID = request.getParameter("catgroupID");
	String pagingSKU = request.getParameter("pagingSKU");

	Hashtable hXMLFile1 = (Hashtable)ResourceDirectory.lookup("catalog.CatalogPageList");
	Hashtable hData = (Hashtable) hXMLFile1.get("data");
	Vector vTabs = (Vector) hData.get("tab");
	Vector vCols = (Vector) hData.get("column");

	// Define the number of tabs
	int totalTabs = vTabs.size();
	int tableCells = (totalTabs * 2) + 1;


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
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE7" />
<LINK rel=stylesheet href="<%= UIUtil.getCSSFile(cmdContext.getLocale()) %>" type="text/css">

<%@include file="./Worksheet.jsp" %>

<SCRIPT>
	// Flag set to true or false for the SchemaBasedDiscounts
	// In the instance configuration file, we need to look at the RulesBasedDiscounts component.
	flagSchemaBasedDiscounts = <%= ! ToolsConfiguration.isComponentEnabled(DiscountConst.COMPONENT_RULE_BASED_DISCOUNT) %> ;

	// Global Variables
	var currentContextMenuType = null;     // Current context menu
	var globalElement          = null;     // Currently selected element
	var globalCopyElement      = null;     // Currently selected element
	var globalElementType      = null;     // Currently selected element's type
	var globalElementID        = null;     // Currently selected element's id
	var globalElementDOIOWN    = null;     // Do I own the current element
	var globalFindNext         = false;    // Is the find next button active
	var globalCopyFlag         = false;    // Has a copy been performed
	var globalCopyRowFlag      = false;    // Has a copy row been performed
	var globalMultiSelect      = 0;        // Number of selected rows

	var savedTab = 0;                      // Currently selected menu tab
	var oPopup   = window.createPopup();   // Variable used to display the context menu

	var pagingSKU = "<%=UIUtil.toJavaScript(pagingSKU)%>";

	var startIndex, endIndex, totalIndex, pageSize;

<%
	for (int i=0; i<vMenus.size(); i++)
	{
		Hashtable hMenu = (Hashtable) vMenus.elementAt(i);
		String strMenuId = (String) hMenu.get("id");
		Vector vFunctions = (Vector) vFuncs.elementAt(i);
		if (vFunctions.size() == 0) continue;
%>
		function <%=strMenuId%>Menu()                                          
		{
			var showMenuResult;
			currentContextMenuType = "<%=strMenuId%>";
			var popupBody = "<DIV ID='divPopup' STYLE='width:196; background:#EFEFEF; color:black; border-color : WHITE; border-style : solid; border-width : 1px; filter: progid:DXImageTransform.Microsoft.Shadow(color=#777777, Direction=135, Strength=4) alpha(Opacity=90);'>";
<%
			for (int j=0; j<vFunctions.size(); j++)
			{
				Hashtable hFunction = (Hashtable) vFunctions.elementAt(j);
				String strFuncId = (String) hFunction.get("id");
				if (strFuncId.equals("HR"))
				{
%>
					popupBody += "<HR STYLE='height:1px; color=WHITE' WIDTH=94%>";
<%
				} else {
%>
					showMenuResult = showMenu_<%=strFuncId%>();
					if (showMenuResult != "hide")
					{
						(showMenuResult == true) ? popupBody += div<%=strFuncId%>_ON.outerHTML : popupBody += div<%=strFuncId%>_OFF.outerHTML;
					}
<%
				}
			}
%>
			popupBody += "</DIV>";
			oPopup.document.body.innerHTML = popupBody; 
			oPopup.show(getObjPageX(td<%=strMenuId%>Menu), getObjPageY(td<%=strMenuId%>Menu) + td<%=strMenuId%>Menu.offsetHeight, 204, 200, document.body);
			adjustPopupWindowSize(getObjPageX(td<%=strMenuId%>Menu), getObjPageY(td<%=strMenuId%>Menu) + td<%=strMenuId%>Menu.offsetHeight);
			td<%=strMenuId%>Menu.focus();
		}
<%
	}
%>


	//////////////////////////////////////////////////////////////////////////////////////
	// SearchMenu()
	//
	// - Display the search dialog for products
	//////////////////////////////////////////////////////////////////////////////////////
	function SearchMenu()
	{
		oPopup.hide();
		currentContextMenuType = "Search";
		if (parent.getDetailPageLoaded() == false) return;
		parent.contentFrame.toolbarFindProducts();
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// fcnKeyDown()
	//
	// - Process a key press to determine the necessary action
	//////////////////////////////////////////////////////////////////////////////////////
	function fcnKeyDown()
	{
		if (event.keyCode == "18") oPopup.hide();
		if (oPopup && oPopup.isOpen == true) 
		{   
			switch (currentContextMenuType)
			{

<%
	for (int i=0; i<vMenus.size(); i++)
	{
		Hashtable hMenu = (Hashtable) vMenus.elementAt(i);
%>
		case "<%=(String) hMenu.get("id")%>":
<%
		Vector vFunctions = (Vector) vFuncs.elementAt(i);

		for (int j=0; j<vFunctions.size(); j++)
		{
			Hashtable hFunction = (Hashtable) vFunctions.elementAt(j);
			String strFunctionId = (String) hFunction.get("id");
			String strAccessKey  = (String) hFunction.get("accessKey");
			if (strAccessKey != null)
			{
%>
				if (event.keyCode == "<%=UIUtil.toJavaScript((String)rbProduct.get(strAccessKey))%>".charCodeAt(0) && showMenu_<%=strFunctionId%>()) toolbar<%=strFunctionId%>();
<%
			}
		}
%>
		break;
<%
	}
%>
				default:
					break;
			}
			event.returnValue = false; 
		}
	}

	//////////////////////////////////////////////////////////////////////////////////////
	// selectTab(value) 
	//
	// - sets the tab to the selected tab
	//////////////////////////////////////////////////////////////////////////////////////
	function selectTab(value)
	{
		if (parent.getDetailPageLoaded() == false) return;
		updateTabView(value);
		parent.contentFrame.setCurrentTab(value);
	}

	//////////////////////////////////////////////////////////////////////////////////////
	// updateTabView(value) 
	//
	// - sets the tab bar to display the correct colors and images
	//////////////////////////////////////////////////////////////////////////////////////
	function updateTabView(value)
	{
		var index = value*2;

		if (savedTab == index) return;

		// make active
		var cell = table1.rows[1].cells[index+1];
		cell.style.backgroundColor="WHITE";

		table1.rows[1].cells[index+1].style.backgroundImage = 'url("/wcs/images/tools/catalog/tabbgactive.bmp")';
		table1.rows[1].cells[savedTab+1].style.backgroundImage = 'url("/wcs/images/tools/catalog/tabbg.bmp")';

		// before image
		if (index != 0) {
		   cell = table1.rows[1].cells[index];
		   cell.innerHTML = "<IMG alt='' SRC='/wcs/images/tools/catalog/inatoa.bmp' HEIGHT=23>";
		}

		// after image
		if (index != <%=tableCells-3%>) {
		   cell = table1.rows[1].cells[index+2];
		   cell.innerHTML = "<IMG alt='' SRC='/wcs/images/tools/catalog/atoina.bmp' HEIGHT=23>";
		} else {
		   cell = table1.rows[1].cells[index+2];
		   cell.innerHTML = "<IMG alt='' SRC='/wcs/images/tools/catalog/atoend.bmp' HEIGHT=23>";
		}

		// make inactive
		cell = table1.rows[1].cells[savedTab+1];
		cell.style.backgroundColor="#91B3DE";

		// before image
		if (savedTab != 0 && savedTab != (index+2)) {
		   cell = table1.rows[1].cells[savedTab];
		   cell.innerHTML = "<IMG alt='' SRC='/wcs/images/tools/catalog/inatoina.bmp' HEIGHT=23>";
		}

		// after image
		if (savedTab != (index-2)) {
		   if (savedTab != <%=tableCells-3%>) {
		      cell = table1.rows[1].cells[savedTab+2];
		      cell.innerHTML = "<IMG alt='' SRC='/wcs/images/tools/catalog/inatoina.bmp' HEIGHT=23>";
		   } else {
		      cell = table1.rows[1].cells[savedTab+2];
		      cell.innerHTML = "<IMG alt='' SRC='/wcs/images/tools/catalog/inatoend.bmp' HEIGHT=23>";
		   }
		}
		
		// make first tab image shows correctly
		if (value != 0) {
		      cell = table1.rows[1].cells[0];
		      cell.innerHTML = "<IMG alt='' SRC='/wcs/images/tools/catalog/lefttabunselected.bmp' HEIGHT=23>";
		} else {
		      cell = table1.rows[1].cells[0];
		      cell.innerHTML = "<IMG alt='' SRC='/wcs/images/tools/catalog/lefttabselected.bmp' HEIGHT=23>";
		}
		
		savedTab = index;
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// setElementType(elementType, elementID, DOIOWN, element)
	//
	// - set the element type and id of the current element
	//////////////////////////////////////////////////////////////////////////////////////
	function setElementType(elementType, elementID, DOIOWN, element)
	{
		globalElementType   = elementType;
		globalElementID     = elementID;
		globalElementDOIOWN = DOIOWN;
		globalElement       = element;
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// adjustPopupWindowSize()
	//
	// - adjust the popup window size
	//////////////////////////////////////////////////////////////////////////////////////
	function adjustPopupWindowSize(nX,nY)
	{
		var nWidth=oPopup.document.getElementById('divPopup').scrollWidth+5;
		var nHeight=oPopup.document.getElementById('divPopup').scrollHeight+5;

		oPopup.show(nX, nY, nWidth, nHeight, document.body);
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// setGlobalFindNext(value)
	//
	// - set the globalFindNext variable
	//////////////////////////////////////////////////////////////////////////////////////
	function setGlobalFindNext(value)
	{
		globalFindNext = value;
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// getObjPageX(obj) 
	//
	// - return the X offset of the object 
	//////////////////////////////////////////////////////////////////////////////////////
	function getObjPageX(obj) 
	{
		var num = 0;
		for (var p = obj; p && p.tagName != "BODY"; p = p.offsetParent) num += p.offsetLeft;
		return num;
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// getObjPageY(obj) 
	//
	// - return the Y offset of the object 
	//////////////////////////////////////////////////////////////////////////////////////
	function getObjPageY(obj) 
	{
		var num = 0;
		for (var p = obj; p && p.tagName != "BODY"; p = p.offsetParent) num += p.offsetTop;
		return num;
	}

	function setText(iStartIndex, iEndIndex, iPageSize, iTotal)
	{
		var newString = "<%=UIUtil.toJavaScript((String)rbProduct.get("productUpdateFromToTotal"))%>";

		newString = replaceField(newString,"?1", iStartIndex+1);
		newString = replaceField(newString,"?2", iEndIndex);
		newString = replaceField(newString,"?3", iTotal);
		myfonttext.firstChild.nodeValue = newString;
		if (eval(iTotal) > 0) {
			displayNP.style.display = "block";
			cell = table0.rows[0].cells[0];
			cell.innerHTML = "&nbsp;";
			if (eval(iStartIndex) == 0) prevInputButton.style.display = "none";
			if (eval(iEndIndex) == eval(iTotal)) nextInputButton.style.display = "none";
		}
		startIndex = iStartIndex;
		endIndex = iEndIndex; 
		pageSize = iPageSize;
		totalIndex = iTotal;
	}

	function nextButton()
	{
		if (eval(endIndex) >= eval(totalIndex)) return;
		if (parent.contentFrame.leavingPageFunction() == false) return;

		if (pagingSKU=="true") {
			var catentryArray = top.get("SKULineUpdateCatentryArray", null);
		} else {
			var catentryArray = top.get("ProductLineUpdateCatentryArray", null);
		}
		var newStart = eval(endIndex);
		var newEnd = eval(endIndex) + eval(pageSize);
		if (newEnd > totalIndex) newEnd = totalIndex;

		var urlString = "";
		for (var i=newStart; i<newEnd; i++)
		{
			if (i > newStart) urlString = urlString + ",";
			urlString = urlString + catentryArray[i];
		}

		var urlParam=top.mccbanner.trail[top.mccbanner.counter].parameters;
		if (!urlParam)
		{	
			top.mccbanner.trail[top.mccbanner.counter].parameters = new Object();
			urlParam=top.mccbanner.trail[top.mccbanner.counter].parameters;
		}
		urlParam['startIndex'] = endIndex;
		urlParam['searchType'] = "";
		urlParam['catentryArray'] = urlString;

		top.goBack(0);
	}

	function prevButton()
	{
		if (startIndex <= 0) return;
		if (parent.contentFrame.leavingPageFunction() == false) return;

		if (pagingSKU=="true") {
			var catentryArray = top.get("SKULineUpdateCatentryArray", null);
		} else {
			var catentryArray = top.get("ProductLineUpdateCatentryArray", null);
		}
		var newStart = eval(startIndex) - eval(pageSize);
		if (newStart < 0) newStart = 0;
		var newEnd = eval(newStart) + eval(pageSize);

		var urlString = "";
		for (var i=newStart; i<newEnd; i++)
		{
			if (i > newStart) urlString = urlString + ",";
			urlString = urlString + catentryArray[i];
		}

		var urlParam=top.mccbanner.trail[top.mccbanner.counter].parameters;
		if (!urlParam)
		{
			top.mccbanner.trail[top.mccbanner.counter].parameters = new Object();
			urlParam=top.mccbanner.trail[top.mccbanner.counter].parameters;
		}
		urlParam['startIndex'] = newStart;
		urlParam['searchType'] = "";
		urlParam['catentryArray'] = urlString;
		top.goBack(0);
	}

	//////////////////////////////////////////////////////////////////////////////////////
	// replaceField(source, pattern, replacement) 
	//
	// - replace values in the property file string
	//////////////////////////////////////////////////////////////////////////////////////
	function replaceField(source, pattern, replacement) 
	{
		index1 = source.indexOf(pattern);
		index2 = index1 + pattern.length;
		return source.substring(0, index1) + replacement + source.substring(index2);
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// setMultiSelect(value) 
	//
	// @param value - the number of selected rows
	//
	// - sets the number of selected rows
	//////////////////////////////////////////////////////////////////////////////////////
	function setMultiSelect(value) 
	{
		globalMultiSelect = value;
	}

</SCRIPT>
	
</HEAD>

<BODY CLASS=tabtitle SCROLL=AUTO ONKEYDOWN=fcnKeyDown() ONCONTEXTMENU="return false;" style="background-color:#EFEFEF; margin-top:0;">
	<div id=dropmenu>
<%
	for (int i=0; i<vMenus.size(); i++)
	{
		Hashtable hMenu = (Hashtable) vMenus.elementAt(i);
%>
		<LABEL FOR="fp<%=(String)hMenu.get("id")%>" ACCESSKEY="<%=UIUtil.toHTML((String)rbProduct.get((String)hMenu.get("accessKey")))%>"></LABEL>
<%
	}
%>
	<INPUT TYPE=HIDDEN NAME=inputCopy STYLE='height:20px;'></INPUT>
	<TABLE ID=table0 HEIGHT=25px BORDER=0 CELLPADDING=0 CELLSPACING=0 STYLE="margin: 0 0 0 10;">
		
		<TR STYLE='background-color:#EFEFEF;'>
			<TD></TD>
			<TD width=10>&nbsp;</TD>
<%
	for (int i=0; i<vMenus.size(); i++)
	{
		Hashtable hMenu = (Hashtable) vMenus.elementAt(i);
		String strMenuId = (String)hMenu.get("id");
%>
			<TD WIDTH=8>&nbsp;</TD>
			<TD NOWRAP ID=td<%=strMenuId%>Menu ONCLICK="<%=strMenuId%>Menu();" CLASS=toolbarMenu STYLE="cursor:hand;">
			   <%=rbProduct.get((String)hMenu.get("title"))%>
			</TD>
			<TD STYLE="width: 0px;">
			   <INPUT CLASS=menuButton iD="fp<%=strMenuId%>" TABINDEX="1" TYPE=BUTTON VALUE="<%=strMenuId%>" STYLE="width: 0px;" ONCLICK="<%=strMenuId%>Menu();">
			</TD>
<%
	}
%>
			<TD NOWRAP CLASS=button ID=displayNP WIDTH=100% ALIGN=RIGHT BGCOLOR=#EFEFEF STYLE="display:none;">
				<FONT ID=myfonttext>&nbsp;</FONT>&nbsp;
				<BUTTON NAME="prevInputButton" ID="dialog" onclick="prevButton()"><%=UIUtil.toHTML((String)rbProduct.get("ProductUpdateTitle_Previous"))%></BUTTON>
				&nbsp;
				<BUTTON NAME="nextInputButton" ID="dialog" onclick="nextButton()"><%=UIUtil.toHTML((String)rbProduct.get("ProductUpdateTitle_Next"))%></BUTTON>&nbsp;&nbsp;
			</TD>
		</TR>
		
	</TABLE>
	
	<IMG alt=''  border="0" width="100%" height="1" src="<%= UIUtil.getWebPrefix(request) %>images/tools/mcc/white_stripe.gif"/>

	
	<TABLE ID=table1 WIDTH=100% MARGIN=0 BORDER=0 BGCOLOR=#EFEFEF CELLSPACING=0 CELLPADDING=0>
		<TR HEIGHT=10px><TD COLSPAN=<%=tableCells+1%>></TD></TR>
		<TR CLASS=tab STYLE="height: 23px;">
			<TD STYLE="border-width: 0 0 0 0;"><IMG alt='' SRC="/wcs/images/tools/catalog/lefttabselected.bmp" HEIGHT=23></TD>
<%
	for (int iTab=0; iTab<vTabs.size(); iTab++)
	{
		Hashtable hTab = (Hashtable) vTabs.elementAt(iTab);
		String strTitle = UIUtil.toHTML((String)rbProduct.get((String)hTab.get("title")));
		if (iTab == 0) {
%>
			<TD CLASS=activetab onClick=selectTab(<%=iTab%>) NOWRAP STYLE='cursor:hand; height: 23px; background-image: url("/wcs/images/tools/catalog/tabbgactive.bmp");'>&nbsp;<%=strTitle%>&nbsp;</TD>
			<TD CLASS=tabend STYLE="border-width: 0 0 0 0;"><IMG alt='' SRC="/wcs/images/tools/catalog/atoina.bmp" HEIGHT=23></TD>                                            
<%
		} else if (iTab == vTabs.size()-1) {
%>
			<TD CLASS=inactivetab onClick=selectTab(<%=iTab%>) NOWRAP STYLE='cursor:hand; height: 23px; background-image: url("/wcs/images/tools/catalog/tabbg.bmp");'>&nbsp;<%=strTitle%>&nbsp;</TD>
			<TD CLASS=tabend STYLE="border-width: 0 0 0 0;"><IMG alt='' SRC="/wcs/images/tools/catalog/inatoend.bmp" HEIGHT=23></TD>
<%
		} else {
%>
			<TD CLASS=inactivetab onClick=selectTab(<%=iTab%>) NOWRAP STYLE='cursor:hand; height: 23px; background-image: url("/wcs/images/tools/catalog/tabbg.bmp");'>&nbsp;<%=strTitle%>&nbsp;</TD>
			<TD CLASS=tabend STYLE="border-width: 0 0 0 0;"><IMG alt='' SRC="/wcs/images/tools/catalog/inatoina.bmp" HEIGHT=23></TD>
<%
		}
	}
%>
			<TD WIDTH=100% STYLE='height: 23px;  background-image: url("/wcs/images/tools/catalog/bottom.bmp");'>&nbsp;</TD>
		</TR>
	</TABLE>
		</div>


<DIV ID="divWorkSheet" STYLE="display:none;">


<%
	for (int i=0; i<vMenus.size(); i++)
	{
		Hashtable hMenu = (Hashtable) vMenus.elementAt(i);
		Vector vFunctions = (Vector) vFuncs.elementAt(i);
		for (int j=0; j<vFunctions.size(); j++)
		{
			Hashtable hFunction = (Hashtable) vFunctions.elementAt(j);
			String strFuncId = (String) hFunction.get("id");
			if (strFuncId.equals("HR")) continue;
			String strFuncTitle = (String) hFunction.get("title");
%>
			<DIV ID=div<%=strFuncId%>_ON
				onmouseover="this.style.background='#F7B600';" 
				onmouseout="this.style.background='#EFEFEF';" 
				onclick="parent.parent.titleFrame.toolbar<%=strFuncId%>();"
				STYLE="font-family:verdana; font-size:8pt; height:18px; width:200px; background:#EFEFEF;  padding:3px; padding-left:10px; padding-right: 10px; cursor:hand ">
				<SPAN><%=rbProduct.get(strFuncTitle)%></SPAN> 
			</DIV>
			<DIV ID=div<%=strFuncId%>_OFF
				onmouseover="this.style.background='#F7B600';" 
				onmouseout="this.style.background='#EFEFEF';" 
				STYLE="color: #888888; font-family:verdana; font-size:8pt; height:18px; width:200px; background:#EFEFEF;  padding:3px; padding-left:10px; padding-right: 10px; cursor:hand ">
				<SPAN><%=rbProduct.get(strFuncTitle)%></SPAN> 
			</DIV>
<%
		}
	}
%>

</DIV>


</BODY>
</HTML>


