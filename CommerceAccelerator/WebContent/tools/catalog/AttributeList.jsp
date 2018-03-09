<%
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
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 TRANSITIONAL//EN">
<HTML>
<!--
catalog editor test JSP
-->
<%@ page import="com.ibm.commerce.beans.DataBeanManager" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.tools.common.ui.taglibs.*" %>
<%@ page import="com.ibm.commerce.tools.catalog.beans.AttributeListDataBean" %>
<%@ page import="com.ibm.commerce.tools.catalog.beans.AttributeDataBean" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@include file="../common/common.jsp" %>
<%@include file="../common/NumberFormat.jsp" %>

    <HEAD>
      <%= fHeader %>
     
      <%
      try {
      CommandContext cmdContext = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
      Locale jLocale = cmdContext.getLocale();;
      Hashtable ProductFindNLS = (Hashtable) ResourceDirectory.lookup("catalog.ProductNLS", jLocale);
      Hashtable PricingResource = (Hashtable)ResourceDirectory.lookup("catalog.PricingNLS", jLocale);
      Hashtable AttributeNLS = (Hashtable) ResourceDirectory.lookup("catalog.AttributeNLS", jLocale);
      Hashtable ItemNLS = (Hashtable) ResourceDirectory.lookup("catalog.ItemNLS", jLocale);
      Hashtable CategoryNLS = (Hashtable) ResourceDirectory.lookup("catalog.CategoryNLS", jLocale);
 
      String lang_id = cmdContext.getLanguageId().toString(); 
      String defaultStoreLang_id = cmdContext.getStore().getLanguageId();

      String orderByParm = request.getParameter("orderby");
      String productrfnbr = request.getParameter("productrfnbr");
      String attr_id = request.getParameter("attributeId"); 
      
	AttributeListDataBean defaultAttributeList;
	AttributeDataBean defaultAttributes[] = null;
	int defaultTotalsize = 0;
	defaultAttributeList = new AttributeListDataBean();
	defaultAttributeList.setLanguageId(new Integer(defaultStoreLang_id));
	DataBeanManager.activate(defaultAttributeList, request);
	defaultAttributes = defaultAttributeList.getAttributeList();
		
	if (defaultAttributes != null)
	 {
	  defaultTotalsize = defaultAttributes.length;
	 }
	 
	AttributeListDataBean attributeList;
	AttributeDataBean attributes[] = null;
	int totalsize = 0;
	attributeList = new AttributeListDataBean();
	attributeList.setLanguageId(new Integer(lang_id));
	DataBeanManager.activate(attributeList, request);
	attributes = attributeList.getAttributeList();	 
	 
	if (attributes != null)
	 {
	  totalsize = attributes.length;
	 }
	 

	int startIndex = Integer.parseInt(request.getParameter("startindex"));
	int listSize = Integer.parseInt(request.getParameter("listsize"));
	int endIndex = startIndex + listSize;
	int rowselect = 1;
	int totalpage = (defaultTotalsize + listSize-1)/listSize;
      %>
      
      <link rel=stylesheet href="<%= UIUtil.getCSSFile(jLocale) %>" type="text/css">
      <TITLE><%= UIUtil.toHTML((String)AttributeNLS.get("attributeList_title")) %></TITLE>

      <SCRIPT>
	  var productID = "<%=UIUtil.toJavaScript( productrfnbr )%>";
	  
	  var attributeId = "<%=UIUtil.toJavaScript( attr_id )%>";
	  

        function onLoad()
        {        
          parent.loadFrames();
        }

        function getProductID() {
		
            return productID;
        }

	function getNewAttributeTitle() {
            return "<%=UIUtil.toJavaScript((String)AttributeNLS.get("newAttributeTitle"))%>";
        }

	function getUpdateAttributeTitle() {
            return "<%=UIUtil.toJavaScript((String)AttributeNLS.get("updateAttributeTitle"))%>";
        }

	function getAttributeValueTitle() {
	
        	var checkedAttributeRefNum = parent.getChecked();
        
        	<% 
        	
        	AttributeDataBean attr;
        	
        	for (int i = 0; i < defaultTotalsize; i++){
        	
        		attr = defaultAttributes[i];
        	
        	%>
                        
			if(checkedAttributeRefNum == "<%=UIUtil.toJavaScript(attr.getAttributeId().toString())%>"){

				return ("<%=UIUtil.toJavaScript(attr.getAttributeName())%>" + "  -  " + "<%=UIUtil.toJavaScript((String)AttributeNLS.get("attributeValueTitle"))%>");
			
			}
	
		<%}%>		
	
        }

	function getAttributeMoveUpTitle() {
            return "<%=UIUtil.toJavaScript((String)AttributeNLS.get("attribute_up"))%>";
        }

	function getAttributeMoveDownTitle() {
            return "<%=UIUtil.toJavaScript((String)AttributeNLS.get("attribute_down"))%>";
        }

	function getAttrDelConfirmMsg()
	{
	    return "<%= UIUtil.toJavaScript((String)AttributeNLS.get("attributeDeleteConfirm")) %>";
	}
	
	function performAttributeMoveUp()
	{
	    var strURL  ='/webapp/wcs/tools/servlet/AttributeSequenceMoveUp?';
	    	strURL += 'attributeId' + '=' + parent.getSelected();
	    	strURL +='&productrfnbr=' + getProductID();
	    	strURL +='&orderby=' + '<%=UIUtil.toJavaScript(orderByParm)%>';
	    	
		parent.location.replace(strURL);
  	   	top.showProgressIndicator(true);
	}
	
	function performAttributeMoveDown()
	{
	    var strURL  ='/webapp/wcs/tools/servlet/AttributeSequenceMoveDown?';
	    	strURL += 'attributeId' + '=' + parent.getSelected();
	    	strURL +='&productrfnbr=' + getProductID();
	    	strURL +='&orderby=' + '<%=UIUtil.toJavaScript(orderByParm)%>';
	    	
		parent.location.replace(strURL);
  	   	top.showProgressIndicator(true);
	}

	function displayValue(value, valueType) {   
	        
        	if(valueType == "Integer") 
        	{
             		var formatted = numberToStr(value, "<%=lang_id%>", null);
             		if (formatted != "NaN" && formatted != null){
                 		return formatted;   
             		}else{             
                 		return value;                 
             		}
         
        	}else if(valueType  == "Float"){
  
             		var numDecimal = numberOfDecimalPlaces(value);
           
             		var formatted = numberToStr(value, "<%=lang_id%>", numDecimal);
             		if (formatted != "NaN" && formatted != null){ 
                 		return formatted;     
             		}else{
                 		return value;
             		}
        
        	}else{
            		return value;                                         
        	}
        
       }

      function changeAttribute () {
 	var attributeId = null;
	if (arguments.length > 0) {
	   attributeId = arguments[0];
           if (top.setContent) {
		top.setContent( getUpdateAttributeTitle(), '/webapp/wcs/tools/servlet/DialogView?XMLFile=catalog.attributeDialog&amp;productrfnbr=' + getProductID() + '&amp;attributeId=' + attributeId + '&amp;isNewAttribute=false',true)
           } else {
	        parent.location.replace('/webapp/wcs/tools/servlet/DialogView?XMLFile=catalog.attributeDialog&amp;productrfnbr=' + getProductID() + '&amp;attributeId=' + attributeId + '&amp;isNewAttribute=false');
           }
	}
      }
	

        // -->
      </SCRIPT>
      
      <SCRIPT SRC="/wcs/javascript/tools/common/dynamiclist.js"></SCRIPT>
      <SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
      
    </HEAD>

    <BODY class="content_list">

      <SCRIPT>
        <!--
        // For IE
        if (document.all) {
          onLoad();
        }
        //-->
      </SCRIPT>



<%=comm.addControlPanel("catalog.attributeList",totalpage,defaultTotalsize,jLocale)%>
      <FORM NAME="AttributeForm">
        <%= comm.startDlistTable((String)AttributeNLS.get("accessProducts")) %>
        <%= comm.startDlistRowHeading() %>
        <%= comm.addDlistCheckHeading() %>
        <%= comm.addDlistColumnHeading((String)AttributeNLS.get("refName"),"ATTRIBUTE.NAME",orderByParm.equals("ATTRIBUTE.NAME") ) %>        
        <%= comm.addDlistColumnHeading((String)AttributeNLS.get("attributeName"),"ATTRIBUTE.NAME",orderByParm.equals("ATTRIBUTE.NAME") ) %>
        <%= comm.addDlistColumnHeading((String)AttributeNLS.get("attributeDescription"),"ATTRIBUTE.DESCRIPTION",orderByParm.equals("ATTRIBUTE.DESCRIPTION") ) %>
        <%= comm.addDlistColumnHeading((String)AttributeNLS.get("attributeSequence"),"ATTRIBUTE.SEQUENCE",orderByParm.equals("ATTRIBUTE.SEQUENCE") ) %>
        <%= comm.endDlistRow() %>


          <%
	    AttributeDataBean attribute;
	    AttributeDataBean defaultAttribute;
	    
          
          if (endIndex > defaultTotalsize) {
            endIndex = defaultTotalsize;
          }
          
          int indexFrom = startIndex;           
          for (int i = indexFrom; i < endIndex; i++)
          {
          
          	String attrName = null;
	    	String attrDesc = null;
	    	String attrSequence = null;
          	defaultAttribute = defaultAttributes[i];
          	
          	for(int j = 0; j < totalsize; j++){
          	
			attribute = attributes[j];
			
			if(attribute.getAttributeId().equals(defaultAttribute.getAttributeId())){
			
				attrName = attribute.getAttributeName();
				attrDesc = attribute.getAttributeDescription();
				attrSequence = attribute.getAttributeSequence().toString();
				break;
			}
			
			
			
		}
		
		attrSequence = 	(attrSequence != null ? UIUtil.toJavaScript(attrSequence) : "") ;
		
		%>

        <%= comm.startDlistRow(rowselect) %>
        <%= comm.addDlistCheck( defaultAttribute.getAttributeId().toString(),"none" ) %>
        <%= comm.addDlistColumn((defaultAttribute != null ? UIUtil.toHTML(defaultAttribute.getAttributeName()) : "" ), defaultAttribute != null ? UIUtil.toJavaScript("javascript:changeAttribute(" + defaultAttribute.getAttributeId().toString() + ")") : "none") %>        
        <%= comm.addDlistColumn((attrName != null ? UIUtil.toHTML(attrName) : ""), "none") %>
        <%= comm.addDlistColumn((attrDesc != null ? UIUtil.toHTML(attrDesc) : "" ), "none" ) %>
        
        
	<script>		
		var formattedSequence = displayValue("<%=attrSequence%>", "Float");
		addDlistColumn( formattedSequence, "none" );	
	</script> 
	
        <%= comm.endDlistRow() %>
          <%
            if(rowselect==1){
               rowselect = 2;
            }else{
               rowselect = 1;
            }
          } 
    %>
        <%= comm.endDlistTable() %>
        
        
        <%
        
        if(defaultTotalsize == 0){
        
        %>
        <BR>
        <%=UIUtil.toHTML((String) AttributeNLS.get("emptyAttrList"))%>
        
        <%
        }
        %>
        
        
      </FORM>
      
      <SCRIPT>
        <!--
          parent.afterLoads();
          parent.setResultssize( <%=defaultTotalsize %> );
        //-->
      </SCRIPT>
      
      <%@include file="MsgDisplay.jspf" %>
      
      <%
      } catch (Exception e)	{
      
         com.ibm.commerce.exception.ExceptionHandler.displayJspException(request, response, e);
      }
      %>
      
    </BODY>
         
  </HTML>


