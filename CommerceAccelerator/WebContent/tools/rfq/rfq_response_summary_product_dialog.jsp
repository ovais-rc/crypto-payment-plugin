<!-- 
========================================================================
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2000, 2016
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
========================================================================
--> 
<%@ page import="com.ibm.commerce.tools.test.*" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.command.*" %>
<%@ page import="com.ibm.commerce.common.objects.*" %>
<%@ page import="com.ibm.commerce.rfq.utils.*" %>
<%@ page import="com.ibm.commerce.ubf.util.*" %>
<%@ page import="com.ibm.commerce.utf.utils.*" %>
<%@ page import="com.ibm.commerce.contract.objects.*" %>
<%@ include file="../common/common.jsp" %>
<%
    //*** GET LOCALE FROM COMANDCONTEXT ***//
    CommandContext aCommandContext = (CommandContext)request.getAttribute("CommandContext");    
    Locale   locale = null;
    String   storeId= null;
    if( aCommandContext!= null )
    {
   	locale = aCommandContext.getLocale();
   	storeId = aCommandContext.getStoreId().toString();
    }
    if (locale == null)
    {
	locale = new Locale("en","US");
    }
    Integer langId = aCommandContext.getLanguageId();
    String lang = aCommandContext.getLanguageId().toString();
	
    if ( lang == null)
    {
    	lang = "-1";
    }
	    
    if (storeId == null)
    {
    	storeId = "0";
    }

    //*** GET THE RESOURCE BUNDLE BASED ON LOCALE ***//
    Hashtable rfqNLS = (Hashtable)ResourceDirectory.lookup("rfq.rfqNLS",locale);

    String resProdId = request.getParameter("ProductId");
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<link rel="stylesheet" href="<%= UIUtil.getCSSFile(locale)%>" type="text/css" />
<title></title>
<script type="text/javascript" src="/wcs/javascript/tools/common/Util.js"></script>
<script type="text/javascript" src="/wcs/javascript/tools/common/dynamiclist.js"></script>

<script type="text/javascript">
    var anProduct = new Object();
    anProduct = top.getData("anProduct",1);

    function view(attachment_id, pattrvalue_id) 
    {
       	var url = "RFQAttachmentView?<%= com.ibm.commerce.server.ECConstants.EC_ATTACH_ID %>=" + attachment_id + "&<%= com.ibm.commerce.rfq.utils.RFQConstants.EC_PATTRVALUE_ID %>=" + pattrvalue_id;
	var windowTitle = "<%= UIUtil.toJavaScript(rfqNLS.get("rfq_bct_Attachment")) %>";
	var attributes = 'left=0,top=0,width=1014,height=710,scrollbars=no,toolbar=no,directories=no,status=no,menubar=no,copyhistory=no,resizable=yes';
	var attachmentWindow = top.openChildWindow(url, windowTitle, attributes);
    }

    function initializeState()
    {
        parent.setContentFrameLoaded(true);
    }
    function printAction()
    {
    	window.print();
    }

    function productComments(res_tc_id,res_comments,mandatory,changeable, Name)
    {
	this.<%= RFQConstants.EC_RESPONSE_TC_ID %>=res_tc_id;
	this.<%= RFQConstants.EC_ATTR_RES_CMMENTS_VALUE %>=res_comments;
	this.<%= RFQConstants.EC_ATTR_MANDATORY %>=mandatory;
	this.<%= RFQConstants.EC_ATTR_CHANGEABLE %>=changeable;
	this.<%= RFQConstants.EC_ATTR_NAME %> = Name;
    }

    function ProductAttribute(resPAttrValId,Attribute_id,Pattribute_id,Name,Operator,Unit,Value, type, res_filename)
    {
	this.<%= RFQConstants.EC_ATTR_RES_VALUE_ID %>=resPAttrValId;
	this.<%= RFQConstants.EC_ATTR_ATTRID %>=Attribute_id;
	this.<%= RFQConstants.EC_ATTR_PATTRID %>=Pattribute_id;
	this.<%= RFQConstants.EC_ATTR_NAME %> = Name;
	this.<%= RFQConstants.EC_ATTR_OPERATOR %> = Operator;
	this.<%= RFQConstants.EC_ATTR_UNIT %>=Unit;
	this.<%= RFQConstants.EC_ATTR_VALUE %>=Value;
	this.<%= RFQConstants.EC_ATTR_TYPE %> = type;
	this.res_filename = res_filename;
    }

    function initData()
    {
<%
	RFQResProdAttributes[] resAttrs=RFQResProdHelper.getResAllAttributesForProduct(Long.valueOf(resProdId),langId,RFQConstants.EC_ATTR_VALUEDELIM_VALUE);
	int m=0,n=0;
	String res_filename = null;
	String type = null;
	for (int j=0;resAttrs != null && j<resAttrs.length;j++)
	{
	    if (resAttrs[j].getType().equalsIgnoreCase(UTFConstants.EC_ATTRTYPE_FREEFORM))
	    {
		type = resAttrs[j].getAttrType();
		res_filename = "";
%>
	        prodComments[<%= m++ %>] = new productComments(
		    "<%= resAttrs[j].getRes_tc_id() %>",
		    "<%= UIUtil.toHTML(UIUtil.toJavaScript((String)resAttrs[j].getRes_value())) %>",
		    "<%= resAttrs[j].getMandatory() %>",
		    "<%= resAttrs[j].getChangeable() %>", 
		    "<%= UIUtil.toHTML(UIUtil.toJavaScript((String)resAttrs[j].getName())) %>");
<%
	    }
	    else
	    {
		if (resAttrs[j].getType().equalsIgnoreCase(UTFConstants.EC_ATTRTYPE_ATTACHMENT)
		 && resAttrs[j].getRes_value() != null 
		 && (resAttrs[j].getRes_value()).length() > 0) 
		{
		    AttachmentAccessBean attachment = new AttachmentAccessBean();
		    attachment.setInitKey_attachmentId((String)resAttrs[j].getRes_value());
		    res_filename = attachment.getFilename();
		    type = resAttrs[j].getType();
		}
		else 
		{
		    type = resAttrs[j].getType();
		    res_filename = "";
		}
%>
		prodAttributes[<%= n++ %>] = new ProductAttribute(
	   	    "<%= resAttrs[j].getResPAttrValueId() %>",
		    "",
	   	    "<%= resAttrs[j].getPAttribute_id() %>",
		    "<%= UIUtil.toHTML(UIUtil.toJavaScript((String)resAttrs[j].getName())) %>",
		    "<%= UIUtil.toJavaScript(resAttrs[j].getOperator_des()) %>",
		    "<%= UIUtil.toJavaScript(resAttrs[j].getUnitDesc()) %>",
		    "<%= UIUtil.toHTML(UIUtil.toJavaScript((String)resAttrs[j].getRes_value())) %>",
		    "<%= UIUtil.toJavaScript(type) %>", 
		    "<%= UIUtil.toJavaScript(res_filename) %>");
<%
	    } 
	}
%>
    }

    var prodComments = new Array();
    var prodAttributes = new Array();
    initData();

</script>
</head>

<body class="content" >
<br /><h1><%= rfqNLS.get("rfqProduct") %>:<i> <script type="text/javascript">document.write(anProduct.<%= RFQConstants.EC_OFFERING_NAME %>)</script></i></h1>
<form name="SummaryForm" action="">

<b><%= rfqNLS.get("resprdatrrespnd") %></b>
<script type="text/javascript">
    startDlistTable("<%= UIUtil.toJavaScript(rfqNLS.get("resprdatrrespnd")) %>","100%");

    startDlistRowHeading();
    addDlistColumnHeading("<%= UIUtil.toJavaScript(rfqNLS.get("rfqattribname")) %>",true,"40%",null,true);
    addDlistColumnHeading("<%= UIUtil.toJavaScript(rfqNLS.get("rfqoperator")) %>",true,"20%",null,false);
    addDlistColumnHeading("<%= UIUtil.toJavaScript(rfqNLS.get("value")) %>",true,"20%",null,false);
    addDlistColumnHeading("<%= UIUtil.toJavaScript(rfqNLS.get("rfqunits")) %>",true,"20%",null,false);
    endDlistRowHeading();

    var rowselect=1;
    if (prodAttributes.length > 0)
    {  
  	for (var i=0; i<prodAttributes.length; i++)
  	{
    startDlistRow(rowselect); 
    addDlistColumn(prodAttributes[i].<%= RFQConstants.EC_ATTR_NAME %>);
    addDlistColumn(prodAttributes[i].<%= RFQConstants.EC_ATTR_OPERATOR %>);

	    if (prodAttributes[i].<%= RFQConstants.EC_ATTR_TYPE %> == "<%= UTFConstants.EC_ATTRTYPE_ATTACHMENT %>")
	    {
    addDlistColumn("<a  href='javascript:view("+prodAttributes[i].<%= RFQConstants.EC_ATTR_VALUE %>+","+prodAttributes[i].<%= RFQConstants.EC_ATTR_RES_VALUE_ID %>+ ");'> " + prodAttributes[i].res_filename +"</a>");
	    }
	    else
	    {
    addDlistColumn(prodAttributes[i].<%= RFQConstants.EC_ATTR_VALUE %>);
	    }

    addDlistColumn(prodAttributes[i].<%= RFQConstants.EC_ATTR_UNIT %>);
    endDlistRow();

	    if ( rowselect == 1 )
	    {
		rowselect = 2;
	    }
	    else
	    {
		rowselect = 1;
	    }
        }
    }
    endDlistTable();
</script>
<br />

<b><%= rfqNLS.get("resprdcommrespnd") %></b>
<script type="text/javascript">
    startDlistTable("<%= UIUtil.toJavaScript(rfqNLS.get("resprdcommrespnd")) %>","100%");

    startDlistRowHeading();
    addDlistColumnHeading("<%= UIUtil.toJavaScript(rfqNLS.get("type")) %>",true,"30%",null,true);
    addDlistColumnHeading("<%= UIUtil.toJavaScript(rfqNLS.get("comments")) %>",true,"70%",null,false);
    endDlistRowHeading();

    rowselect=1;
    if (prodComments.length > 0)
    {  
  	for (var i=0; i<prodComments.length ;i++)
  	{
  	    if(prodComments==null || prodComments[i].<%= RFQConstants.EC_ATTR_RES_CMMENTS_VALUE %>=="") 
  	    {
  		continue;
  	    }

    startDlistRow(rowselect);
    addDlistColumn(prodComments[i].<%= RFQConstants.EC_ATTR_NAME %>);
    addDlistColumn(prodComments[i].<%= RFQConstants.EC_ATTR_RES_CMMENTS_VALUE %>);
    endDlistRow();

	    if ( rowselect == 1 )
  	    {
		rowselect = 2;
  	    }
	    else
  	    {
		rowselect = 1;
  	    }
        }
    }
    endDlistTable();
</script>

<br /><br />

<script type="text/javascript">
    initializeState();
</script>
</form>

</body>
</html>
