<%--==========================================================================
Licensed Materials - Property of IBM

WebSphere Commerce

(c) Copyright IBM Corp.  2006
All Rights Reserved

US Government Users Restricted Rights - Use, duplication or
disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
===========================================================================--%>

<%--
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2001, 2002
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
//*
--%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">

<%@ page import="com.ibm.commerce.tools.common.ui.taglibs.*" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.ordermanagement.beans.*" %>
<%@ page import="com.ibm.commerce.ordermanagement.objects.RMAItemComponentAccessBean " %>
<%@ page import="com.ibm.commerce.catalog.beans.CatalogEntryDataBean" %>
<%@ page import="com.ibm.commerce.tools.catalog.beans.CatalogEntryDescriptionDataBean" %>
<%@ page import="com.ibm.commerce.server.JSPHelper" %>
<%@include file="../common/common.jsp" %>

<%
try{
	CommandContext cmdContext = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
	Locale jLocale = cmdContext.getLocale();
	Hashtable returnsNLS = (Hashtable)ResourceDirectory.lookup("returns.ReturnsNLS", jLocale);
	JSPHelper jspHelper = new JSPHelper(request);

	String jLanguageId = cmdContext.getLanguageId().toString();
%>

<HTML>
<HEAD>
<TITLE><%= UIUtil.toHTML((String)returnsNLS.get("returnItemKitDetailsDialogTitle")) %></TITLE>
<link rel=stylesheet href="<%= UIUtil.getCSSFile(jLocale) %>" type="text/css"> 

<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT src="/wcs/javascript/tools/common/Vector.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/common/dynamiclist.js"></SCRIPT>

<SCRIPT>
    var checkBoxes = new Array();
    var compId = '';

    function init() {
        parent.setContentFrameLoaded(true);
    }

    isAnyChange = false;
    function setAnyChange() {
		isAnyChange = true;
    }	

    function addToUpdate(id) {
	var itemCmps = parent.get("returnItemComponent");
	
	anItemCmp = new Object();
	anItemCmp.returnItemComponentId	= id;
	anItemCmp.returnToWarehouse	= document.KitDetailsForm["returnToWarehouse"+id].value;
	
	if (itemCmps == null) {
	    itemCmps = new Array();
	    itemCmps[0]=anItemCmp;
	} else {
	    var alreadyExists = false;
	    for (var i=0; i<itemCmps.length; i++) {
		if (itemCmps[i].returnItemComponentId == id) {
		    itemCmps[i]=anItemCmp;
		    alreadyExists = true;
		}
	    }
	    if (!alreadyExists) {
		itemCmps[itemCmps.length] = anItemCmp;
	    }
	}

	parent.remove("returnItemComponent");
	parent.put("returnItemComponent", itemCmps);
    }

    function performUpdate() {
        //alert(parent.modelToXML("XML"));
    	document.updateReturnItemCmpForm.XML.value=parent.modelToXML("XML");
    	document.updateReturnItemCmpForm.URL.value="ReturnItemKitDetailsGoBack";
    	document.updateReturnItemCmpForm.submit();
    }
    
    
    function checkButton() {
        var count=0;
        for(var i=0;i<checkBoxes.length;i++) {
            if (document.all(checkBoxes[i]).checked) {
                compId = checkBoxes[i];
                count++;
            }
        }
        
        if(count==1){
            document.KitDetailsForm.updateSNBtn.disabled = false;
        }else{
            document.KitDetailsForm.updateSNBtn.disabled = true;
        }    
    }
</SCRIPT>



</HEAD>

<BODY CLASS=content onload="init();">

<H1><%= UIUtil.toHTML((String)returnsNLS.get("returnItemKitDetailsDialogTitle")) %></H1>

<%
	String returnItemId = jspHelper.getParameter("returnItemId");
	RMAItemDataBean rmaItem = new RMAItemDataBean();
	rmaItem.setRmaItemId(returnItemId);
 	com.ibm.commerce.beans.DataBeanManager.activate(rmaItem, request);
	String returnId = rmaItem.getRmaId();
	String customerId = rmaItem.getMemberId();
%>
<SCRIPT>
	parent.put("customerId","<%=customerId%>");
</SCRIPT>
<%
	CatalogEntryDataBean item = new CatalogEntryDataBean();
	item.setCatalogEntryID(rmaItem.getCatalogEntryId());
	com.ibm.commerce.beans.DataBeanManager.activate(item, request);

	CatalogEntryDescriptionDataBean itemDescription = new CatalogEntryDescriptionDataBean();
	itemDescription.setItemRefNum(item.getCatalogEntryReferenceNumber());
	itemDescription.setInitKey_language_id(jLanguageId);
	com.ibm.commerce.beans.DataBeanManager.activate(itemDescription, request);

	RMAItemComponentListDataBean rmaItemComponentListDB = new RMAItemComponentListDataBean();
	rmaItemComponentListDB.setRmaItemId(returnItemId);
	com.ibm.commerce.beans.DataBeanManager.activate(rmaItemComponentListDB, request);
	RMAItemComponentAccessBean[] rmaItemComponentListAB = rmaItemComponentListDB.getRMAItemComponentList();
%>

<P><B><%=returnsNLS.get("returnItemKitDetailsKitName")%>:</B> <%= UIUtil.toHTML(itemDescription.getName())%>
<P><B><%=returnsNLS.get("returnItemKitDetailsKitSKU")%>:</B> <%= UIUtil.toHTML(item.getPartNumber())%>
<P>

<FORM NAME="updateReturnItemCmpForm" METHOD="post" ACTION="CSRReturnItemComponentUpdate">
    <INPUT TYPE='hidden' NAME="XML" VALUE=""> 
    <INPUT TYPE='hidden' NAME="URL" VALUE="">
</FORM>


<FORM name="KitDetailsForm">

<table>
<tr>
<td>    
<%
    int rowselect = 1;
%>

    <%= comm.startDlistTable(UIUtil.toJavaScript( (String)returnsNLS.get("orderItemListTableSummary"))) %>
        <%= comm.startDlistRowHeading() %>
	    <%= comm.addDlistCheckHeading() %>
            <%= comm.addDlistColumnHeading((String)returnsNLS.get("returnItemKitDetailsProductName"),null,false,null,false ) %>
            <%= comm.addDlistColumnHeading((String)returnsNLS.get("returnItemKitDetailsSku"),null,false,null,false ) %>
            <%= comm.addDlistColumnHeading((String)returnsNLS.get("returnItemKitDetailsQuantity"),null,false,null,false ) %>
            <%= comm.addDlistColumnHeading((String)returnsNLS.get("returnItemKitDetailsReturnToWarehouse"),null,false,null,false ) %>
            <%= comm.addDlistColumnHeading((String)returnsNLS.get("rmaSerialNumber"),null,false,null,false ) %>
        <%= comm.endDlistRow() %>


<%	
        for (int i=0; i < rmaItemComponentListAB.length; i++) {
        
	    	String compId = rmaItemComponentListAB[i].getRmaItemCmpId();

		CatalogEntryDataBean itemComp = new CatalogEntryDataBean();
		itemComp.setCatalogEntryID(rmaItemComponentListAB[i].getCatentryId());
		com.ibm.commerce.beans.DataBeanManager.activate(itemComp, request);

		CatalogEntryDescriptionDataBean itemCompDescription = new CatalogEntryDescriptionDataBean();
		itemCompDescription.setItemRefNum(itemComp.getCatalogEntryReferenceNumber());
		itemCompDescription.setInitKey_language_id(jLanguageId);
		com.ibm.commerce.beans.DataBeanManager.activate(itemCompDescription, request);
		
%>


        <%= comm.startDlistRow(rowselect) %>
            <%= comm.addDlistCheck(compId, "checkButton()" ) %>
            <script> checkBoxes[<%=i%>]='<%=compId%>';  </script>
            <%= comm.addDlistColumn(itemCompDescription.getName(), "none" ) %>
            <%= comm.addDlistColumn(itemComp.getPartNumber(), "none" ) %>
            <%= comm.addDlistColumn("<SCRIPT>document.writeln(parent.numberToStr("+ rmaItemComponentListAB[i].getQuantity() + "," + jLanguageId + "))" + "</SCRIPT>", "none" ) %>
            
<% 
		String yesSelect = "";
		String noSelect = "";
		String noType = "";
		if (rmaItemComponentListAB[i].getShouldReceive().equals("Y")) {
		    noType = "N";
		    yesSelect = "SELECTED ";
		} else if (rmaItemComponentListAB[i].getShouldReceive().equals("N")) {
		    noType = "N";
		    noSelect = "SELECTED ";
		} else if (rmaItemComponentListAB[i].getShouldReceive().equals("S")) {
		    noType = "";
		    noSelect = "SELECTED ";
		}
%>            

	    
<%	    
	    String thisColumn = "<LABEL for=\"returnToWarehouse" + compId + "\"> </LABEL>";
	    thisColumn += "<select name=\"returnToWarehouse" + compId + "\" id=\"returnToWarehouse" + compId + "\" onChange=\"setAnyChange();addToUpdate(" + compId + ");\">";
	    thisColumn += "<option " + yesSelect + " value=\"Y\">" + returnsNLS.get("returnToWarehouseYes") + "</option>";
	    thisColumn += "<option " + noSelect + " value=\"" + noType + "\">" + returnsNLS.get("returnToWarehouseNo") + "</option>";
	    
%>
            
            <%= comm.addDlistColumn(thisColumn, "none" ) %>
           
<%
	        StringBuffer serialNumbers = new StringBuffer();
	        Set setSerialNumbers = new HashSet();       
	        String catEntryId = rmaItemComponentListAB[i].getCatentryId();
	        RMASerialNumbersListDataBean rmaSNDB = new RMASerialNumbersListDataBean();
	        rmaSNDB.setRMAItemComponentId(compId);
	        com.ibm.commerce.beans.DataBeanManager.activate(rmaSNDB, request);
	        
	        RMASerialNumbersDataBean [] arraySNs = rmaSNDB.getRmaSerialNumbersDataBeans();
	        
	        if (arraySNs!=null){
	            for (int k = 0; k < arraySNs.length; k++){
	                setSerialNumbers.add(arraySNs[k].getSerialNumber());
	            }
	            
	        }
	        Iterator it = setSerialNumbers.iterator();
		    while (it.hasNext()) {
		        serialNumbers.append((String)it.next());
		        serialNumbers.append("<br>");
		    }	
%>            
            <%= comm.addDlistColumn(serialNumbers.toString(), "none" ) %>
            
        <%= comm.endDlistRow() %>
        
        
<%
        if (rowselect==1) {
	    rowselect = 2;
        } else {
	    rowselect = 1;
        }
        
	}
%>        
        
        
    <%= comm.endDlistTable() %> 
</td>
<td valign="top" >
    <div align="left" valign="top" >
    <button id="contentButton" disabled name="updateSNBtn" onclick="editSn()" ><%= UIUtil.toHTML((String)returnsNLS.get("editSNsPanel")) %></button>
    </div>
</td>
</tr>
</table>    
</FORM>

<SCRIPT>
  function savePanelData() {    
  }
  
  function validatePanelData()
  {
    return true;
  }
  
  function editSn(){
    var url = "/webapp/wcs/tools/servlet/DialogView?XMLFile=returns.rmaSerialNumberEdit";
    url += "&returnId=" + <%=returnId%> + "&rmaItemId=" + <%=returnItemId%> + "&itemCompId="+compId;
    top.setContent("<%= UIUtil.toJavaScript( (String)returnsNLS.get("editSNsPanel") ) %>", url, true);
  }
  
</SCRIPT>








</BODY>
</HTML>

<%
}
catch (Exception e)
{	System.out.println(e);
	out.println(e);
}
%>
