<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2008, 2016 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<!-- 
========================================================================
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2000, 2002, 2003
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
========================================================================
-->

<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>
<%@ page import="com.ibm.commerce.catalog.beans.*" %>
<%@ page import="com.ibm.commerce.catalog.objects.*" %>
<%@ page import="com.ibm.commerce.command.*" %>
<%@ page import="com.ibm.commerce.common.objects.*" %>
<%@ page import="com.ibm.commerce.rfq.utils.*" %>
<%@ page import="com.ibm.commerce.rfq.beans.*" %>
<%@ page import="com.ibm.commerce.tools.common.ui.taglibs.*" %>
<%@ page import="com.ibm.commerce.tools.test.*" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.utf.beans.*" %>
<%@ page import="com.ibm.commerce.utf.commands.*" %>
<%@ page import="com.ibm.commerce.utf.helper.*" %>
<%@ page import="com.ibm.commerce.utf.objects.*" %>
<%@ page import="com.ibm.commerce.utf.utils.*" %>
<%@ page import="com.ibm.commerce.ubf.util.*" %>
<%@ page import="com.ibm.commerce.contract.objects.*" %>
<%@ include file="../common/common.jsp" %>
<%@ include file="../common/NumberFormat.jsp" %>

<jsp:useBean id="rfq" class="com.ibm.commerce.utf.beans.RFQDataBean"></jsp:useBean>
<jsp:useBean id="rfqProdList" class="com.ibm.commerce.utf.beans.RFQProdListBean"></jsp:useBean>
<jsp:useBean id="rfqProdCompList" class="com.ibm.commerce.rfq.beans.RFQProductComponentListBean"></jsp:useBean>

<%
    Locale aLocale = null;
    String storeId= null;
    CommandContext aCommandContext = (CommandContext)request.getAttribute("CommandContext");  
    String ErrorMessage = request.getParameter(com.ibm.commerce.tools.common.ui.UIProperties.SUBMIT_ERROR_MESSAGE);
    if (ErrorMessage == null) {
	ErrorMessage = "";
    }
    if( aCommandContext!= null ) {
       	aLocale = aCommandContext.getLocale();
       	storeId = aCommandContext.getStoreId().toString();
    }
    Hashtable rfqNLS = (Hashtable)ResourceDirectory.lookup("rfq.rfqNLS", aLocale);
    String lang = aCommandContext.getLanguageId().toString();
    if (lang == null) {
   		lang =  "-1";
    }        
    String rfqProdId = request.getParameter("rfqProdId");  

	String rfqId = request.getParameter("rfqid");        
	rfq.setRfqId(rfqId);
    com.ibm.commerce.beans.DataBeanManager.activate(rfq, request);
    String rfqName = UIUtil.toHTML(rfq.getName());
    
    int rowselect=1;
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<link rel="stylesheet" href="<%= UIUtil.getCSSFile(aLocale)%>" type="text/css" />
<title><%= rfqNLS.get("productinfo") %></title>
<script type="text/javascript" src="/wcs/javascript/tools/common/Util.js"></script>
<script type="text/javascript" src="/wcs/javascript/tools/rfq/rfqUtile.js"></script>
<script type="text/javascript" src="/wcs/javascript/tools/common/dynamiclist.js"></script>
<script type="text/javascript">
function view(attachment_id, pattrvalue_id) {
	var url = "RFQAttachmentView?<%= com.ibm.commerce.server.ECConstants.EC_ATTACH_ID %>=" + attachment_id + "&<%= com.ibm.commerce.rfq.utils.RFQConstants.EC_PATTRVALUE_ID %>=" + pattrvalue_id;
	var windowTitle = "<%= UIUtil.toJavaScript(rfqNLS.get("rfq_bct_Attachment")) %>";
	var attributes = 'left=0,top=0,width=1014,height=710,scrollbars=no,toolbar=no,directories=no,status=no,menubar=no,copyhistory=no,resizable=yes';
	var attachmentWindow = top.openChildWindow(url, windowTitle, attributes);
}
function initializeState() {
  	parent.setContentFrameLoaded(true);
}
function savePanelData() {
	return true;
}
function validatePanelData() {
	return true;
}
function printAction() {
	window.print();
}
</script>
</head>

<body class="content" onload="initializeState();">
<br /><h1><%= rfqNLS.get("rfqprodattrlist") %></h1>

<table>
    <tr>
		<td><b><%= rfqNLS.get("rfqname") %>: <i><%= rfqName %></i></b></td>
    </tr>
</table>

<form name="SummaryForm" action="">

<b><%= rfqNLS.get("ProductAttList") %></b>
<script type="text/javascript">
    startDlistTable("<%= UIUtil.toJavaScript(rfqNLS.get("ProductAttList")) %>");
    startDlistRowHeading();
    addDlistColumnHeading("<%= UIUtil.toJavaScript(rfqNLS.get("rfqattribname")) %>",true,"23%",null);
    addDlistColumnHeading("<%= UIUtil.toJavaScript(rfqNLS.get("rfqoperator")) %>",true,"10%",null);
    addDlistColumnHeading("<%= UIUtil.toJavaScript(rfqNLS.get("value")) %>",true,"12%",null);
    addDlistColumnHeading("<%= UIUtil.toJavaScript(rfqNLS.get("rfqunits")) %>",true,"10%",null);    
    addDlistColumnHeading("<%= UIUtil.toJavaScript(rfqNLS.get("mandatory")) %>",true,"10%",null);
    addDlistColumnHeading("<%= UIUtil.toJavaScript(rfqNLS.get("rfqchangeable")) %>",true,"10%",null);
    addDlistColumnHeading("<%= UIUtil.toJavaScript(rfqNLS.get("userdefined")) %>",true,"10%",null);
    endDlistRowHeading();
<%
    String vdelimit = RFQConstants.EC_ATTR_VALUEDELIM_VALUE;
    RFQProductAttributes[] plist = RFQProductHelper.getAllAttributesWithValuesForProduct(Long.valueOf(rfqProdId),Integer.valueOf(lang),vdelimit);

    for (int i=0; plist != null && i<plist.length; i++) {
        Long pattribute_id    	= plist[i].getAttribute_id();

		String pattribute_desc;
		if (pattribute_id != null) {
            pattribute_desc = UIUtil.toHTML(plist[i].getName());
		} else {
            pattribute_desc = UIUtil.toHTML(plist[i].getDescription());
		}
		pattribute_desc = pattribute_desc != null ? pattribute_desc : "";
	
        Integer pattribute_op  	= plist[i].getOperator_id();
        String pattribute_value	= UIUtil.toHTML(plist[i].getValue());
        Integer pattribute_mandatory = plist[i].getMandatory();
        Integer pattribute_changeable = plist[i].getChangeable();
   		String pattribute_unit = plist[i].getUnit();
    	String pattribute_userdefine = null;
    	String pattribute_opname = null;
    	String pattribute_unitname = null;
    	String mandatory = null;
    	String changeable = null;

    	String attr_filename = null;
    	
        if (plist[i].getAttrtype().equals(com.ibm.commerce.utf.utils.UTFConstants.EC_ATTRTYPE_ATTACHMENT)) {
	    	AttachmentAccessBean attachment = new AttachmentAccessBean();
	     	attachment.setInitKey_attachmentId(plist[i].getValue());

	     	attr_filename = UIUtil.toJavaScript(attachment.getFilename());
	     
	     	pattribute_value = "<a href=\"javascript:view('"+plist[i].getValue()+"','"+plist[i].getPAttrValueId()+ "');\"> " + attr_filename +"</a>";
        }

        if (pattribute_id != null) {
            pattribute_userdefine = (String)rfqNLS.get("no");
        } else {
            pattribute_userdefine = (String)rfqNLS.get("yes");
        }

        if (pattribute_op != null) {
            OperatorDataBean odbean = new OperatorDataBean();
            odbean.setInitKey_operatorId(String.valueOf(pattribute_op));
            pattribute_opname = odbean.getOperator();
        } else {
            pattribute_opname = "";
        }

        if (pattribute_unit != null && !pattribute_unit.equals("")) {
            QuantityUnitDescriptionAccessBean qdab = new QuantityUnitDescriptionAccessBean();
            qdab.setInitKey_language_id(lang);
            qdab.setInitKey_quantityUnitId(pattribute_unit);
            pattribute_unitname = UIUtil.toHTML(qdab.getDescription());
        } else {
            pattribute_unitname = "";
        }

		if (pattribute_mandatory.equals(UTFConstants.EC_UTF_MANDATORY)) {
	    	mandatory = (String)rfqNLS.get("yes"); 
		} else if (pattribute_mandatory.equals(UTFConstants.EC_UTF_OPTIONAL)) {
	    	mandatory = (String)rfqNLS.get("no"); 
		}

		if (pattribute_changeable.equals(UTFConstants.EC_UTF_NON_CHANGEABLE)) {
	    	changeable = (String)rfqNLS.get("no"); 
		} else if (pattribute_changeable.equals(UTFConstants.EC_UTF_CHANGEABLE)) {
	    	changeable = (String)rfqNLS.get("yes"); 
		}
%>
    	startDlistRow(<%=rowselect%>);

    	addDlistColumn("<%= UIUtil.toJavaScript(pattribute_desc) %>");
    	addDlistColumn("<%= UIUtil.toJavaScript(pattribute_opname) %>");
    	addDlistColumn("<%= UIUtil.toJavaScript(pattribute_value) %>");
    	addDlistColumn("<%= UIUtil.toJavaScript(pattribute_unitname) %>");    
    	addDlistColumn("<%= UIUtil.toJavaScript(mandatory) %>");
    	addDlistColumn("<%= UIUtil.toJavaScript(changeable) %>");
    	addDlistColumn("<%= UIUtil.toJavaScript(pattribute_userdefine) %>");
    	endDlistRow();

<%
		if ( rowselect == 1 ) { rowselect = 2; } else { rowselect = 1; }
    } //end for
%>

    	endDlistTable();
</script>

<%
    if ( plist == null || plist.length < 1 ) {
%>
    <%=  rfqNLS.get("msgEmptyprodattrlist") %><br />
<%
    } //end if
%>

<br /><b><%= rfqNLS.get("ProductComm") %></b>

<script type="text/javascript">
    startDlistTable("<%= UIUtil.toJavaScript(rfqNLS.get("ProductComm")) %>");
    startDlistRowHeading();
    addDlistColumnHeading("<%= UIUtil.toJavaScript(rfqNLS.get("type")) %>",true,"20%",null);
    addDlistColumnHeading("<%= UIUtil.toJavaScript(rfqNLS.get("comments")) %>",true,"25%",null);
    addDlistColumnHeading("<%= UIUtil.toJavaScript(rfqNLS.get("mandatory")) %>",true,"20%",null);
    addDlistColumnHeading("<%= UIUtil.toJavaScript(rfqNLS.get("rfqchangeable")) %>",true,"20%",null);
    endDlistRowHeading();
<%
    rowselect = 1;
    RFQProductAttributes[] pcomment = RFQProductHelper.getProductCommentsForProduct(Long.valueOf(rfqProdId),Integer.valueOf(lang));
    for (int k=0; pcomment != null && k<pcomment.length; k++) {
        String com_desc  	= UIUtil.toHTML(pcomment[k].getDescription());
		com_desc = com_desc != null ? com_desc : "";
        String com_value	= UIUtil.toHTML(pcomment[k].getValue());
        Integer com_mandatory	= pcomment[k].getMandatory();
        Integer com_changeable	= pcomment[k].getChangeable();
		String mandatory = null;
		String changeable = null;
		if (com_mandatory.equals(UTFConstants.EC_UTF_MANDATORY)) {
	    	mandatory = (String)rfqNLS.get("yes"); 
		} else if (com_mandatory.equals(UTFConstants.EC_UTF_OPTIONAL)) {
	    	mandatory = (String)rfqNLS.get("no"); 
		}
		if (com_changeable.equals(UTFConstants.EC_UTF_NON_CHANGEABLE)) {
	    	changeable = (String)rfqNLS.get("no"); 
		} else if (com_changeable.equals(UTFConstants.EC_UTF_CHANGEABLE)) {
	    	changeable = (String)rfqNLS.get("yes"); 
		}
%>
    startDlistRow(<%=rowselect%>);
    addDlistColumn("<%= UIUtil.toJavaScript(com_desc) %>");
    addDlistColumn("<%= UIUtil.toJavaScript(com_value) %>");
    addDlistColumn("<%= UIUtil.toJavaScript(mandatory) %>");
    addDlistColumn("<%= UIUtil.toJavaScript(changeable) %>");
    endDlistRow();
<%
		if ( rowselect == 1 ) { rowselect = 2; } else { rowselect = 1; }
    } // end for
%>
    endDlistTable();
</script>
<%
    if ( pcomment == null || pcomment.length < 1 ) {
%>
    <%=  rfqNLS.get("msgEmptyprodcommlist") %><br />
<%
    } //end if
%>

</form>

<br /><br />
</body>
</html>
