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
<%@ page import="com.ibm.commerce.tools.catalog.beans.AttributeValueListDataBean" %>
<%@ page import="com.ibm.commerce.tools.catalog.beans.AttributeValueDataBean" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@include file="../common/common.jsp" %>
<%@include file="../common/NumberFormat.jsp" %>

    <HEAD>
      <%= fHeader %>
      
      <%
      try {
      CommandContext cmdContext = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
      Locale jLocale = cmdContext.getLocale();
      Hashtable AttrValueListNLS = (Hashtable) ResourceDirectory.lookup("catalog.AttributeNLS", jLocale);

      String lang_id = cmdContext.getLanguageId().toString(); 
      String defaultStoreLang_id = cmdContext.getStore().getLanguageId(); 


      String orderByParm = request.getParameter("orderby");
      String productrfnbr = request.getParameter("productrfnbr");
      String attrId = request.getParameter("attributeId");
      String attrValue_id = request.getParameter("attrValueId"); 


	AttributeValueListDataBean defaultAttributeValueList;
	AttributeValueDataBean defaultAttributeValues[] = null;
	int defaultTotalsize = 0;
	defaultAttributeValueList = new AttributeValueListDataBean();
	defaultAttributeValueList.setLanguageId(new Integer(defaultStoreLang_id));
	DataBeanManager.activate(defaultAttributeValueList, request);
	defaultAttributeValues = defaultAttributeValueList.getAttributeValueList();
	if (defaultAttributeValues != null)
	 {
	  defaultTotalsize = defaultAttributeValues.length;
	 }

      
	AttributeValueListDataBean attributeValueList;
	AttributeValueDataBean attributeValues[] = null;
	int totalsize = 0;
	attributeValueList = new AttributeValueListDataBean();
	attributeValueList.setLanguageId(new Integer(lang_id));
	DataBeanManager.activate(attributeValueList, request);
	attributeValues = attributeValueList.getAttributeValueList();
	if (attributeValues != null)
	 {
	  totalsize = attributeValues.length;
	 }

          int startIndex = Integer.parseInt(request.getParameter("startindex"));
          int listSize = Integer.parseInt(request.getParameter("listsize"));
          int endIndex = startIndex + listSize;
          int rowselect = 1;
          int totalpage = (totalsize+listSize-1)/listSize;
      %>
      <link rel=stylesheet href="<%= UIUtil.getCSSFile(jLocale) %>" type="text/css">
      <TITLE><%= UIUtil.toHTML((String)AttrValueListNLS.get("attrValueList_title")) %></TITLE>
      <SCRIPT>
	  var productID = "<%=UIUtil.toJavaScript( productrfnbr )%>";
	  var attributeId = "<%=UIUtil.toJavaScript( attrId )%>";
	  
	  var attributeValueId = "<%=UIUtil.toJavaScript( attrValue_id )%>";
	  
	  
	function addEntry(entry){
      		parent.checkeds.addElement(entry);
	}

        function onLoad()
        {
        
          if(attributeValueId != ""){
          
          	addEntry(attributeValueId);
          }
                  
          parent.loadFrames();
        }

        function getProductID() {
	
            return productID;
        }

        function getAttributeId() {
		
            return attributeId;
        }

	function getNewAttrValueTitle() {
            return "<%=UIUtil.toJavaScript((String)AttrValueListNLS.get("newAttrValueTitle"))%>";
        }

	function getUpdateAttrValueTitle() {
            return "<%=UIUtil.toJavaScript((String)AttrValueListNLS.get("updateAttrValueTitle"))%>";
        }

	function getAttrValueMoveUpTitle() {
            return "<%=UIUtil.toJavaScript((String)AttrValueListNLS.get("attribute_up"))%>";
        }

	function getAttrValueMoveDownTitle() {
            return "<%=UIUtil.toJavaScript((String)AttrValueListNLS.get("attribute_down"))%>";
        }

	function getAttrValueDelConfirmMsg()
	{
	    return "<%= UIUtil.toJavaScript((String)AttrValueListNLS.get("attributeValueDeleteConfirm")) %>";
	}

	function performAttributeValueMoveUp()
	{
	    var strURL  ='/webapp/wcs/tools/servlet/AttributeValueSequenceMoveUp?';
	    	strURL += 'attrValueId' + '=' + parent.getSelected();
	    	strURL +='&productrfnbr=' + getProductID();
	    	strURL +='&attributeId=' + getAttributeId();
	    	strURL +='&orderby=' + '<%=UIUtil.toJavaScript(orderByParm)%>';
	    	
		parent.location.replace(strURL);
  	   	top.showProgressIndicator(true);
	}
	
	function performAttributeValueMoveDown()
	{
	    var strURL  ='/webapp/wcs/tools/servlet/AttributeValueSequenceMoveDown?';
	    	strURL += 'attrValueId' + '=' + parent.getSelected();
	    	strURL +='&productrfnbr=' + getProductID();
	    	strURL +='&attributeId=' + getAttributeId();
	    	strURL +='&orderby=' + '<%=UIUtil.toJavaScript(orderByParm)%>';
	    	
		parent.location.replace(strURL);
  	   	top.showProgressIndicator(true);
	}

	function displayValue(value, valueType) {   
	        
        	if(valueType == "<%=UIUtil.toJavaScript((String)AttrValueListNLS.get("integer"))%>") 
        	{
             		var formatted = numberToStr(value, "<%=lang_id%>", null);
             		if (formatted != "NaN" && formatted != null){
                 		return formatted;   
             		}else{             
                 		return value;                 
             		}
         
        	}else if(valueType  == "<%=UIUtil.toJavaScript((String)AttrValueListNLS.get("float"))%>"){
  
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


       function changeAttrValue() {
 	var attrValueId = null;
	if (arguments.length > 0) {
	   attrValueId = arguments[0];
           if ( attrValueId != null ) {
             if (top.setContent) {
                top.setContent( getUpdateAttrValueTitle(), '/webapp/wcs/tools/servlet/DialogView?XMLFile=catalog.attributeValueDialog&amp;attrValueId=' + attrValueId + '&amp;productrfnbr=' + getProductID() + '&amp;attributeId=' + getAttributeId(),true)
             } else {
	        parent.location.replace('/webapp/wcs/tools/servlet/DialogView?XMLFile=catalog.attributeValueDialog&amp;attrValueId=' + attrValueId + '&amp;productrfnbr=' + getProductID() + '&amp;attributeId=' + getAttributeId());
             }
           }
	}
       }

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

          
<%=comm.addControlPanel("catalog.attributeValueList",totalpage,defaultTotalsize,jLocale)%>
      <FORM NAME="AttributeValueForm">
        <%= comm.startDlistTable((String)AttrValueListNLS.get("accessProducts")) %>
        <%= comm.startDlistRowHeading() %>
        <%= comm.addDlistCheckHeading() %>
        <%= comm.addDlistColumnHeading((String)AttrValueListNLS.get("refValue"),"ATTRVALUE.VALUE",orderByParm.equals("ATTRVALUE.VALUE") ) %>
        <%= comm.addDlistColumnHeading((String)AttrValueListNLS.get("attributeValue"),"ATTRVALUE.VALUE",orderByParm.equals("ATTRVALUE.VALUE") ) %>
        <%= comm.addDlistColumnHeading((String)AttrValueListNLS.get("attributeValueType"),null,orderByParm.equals(null) ) %>
        <%= comm.addDlistColumnHeading((String)AttrValueListNLS.get("attributeValueSequence"),"ATTRVALUE.SEQUENCE",orderByParm.equals("ATTRVALUE.SEQUENCE") ) %>
        <%= comm.endDlistRow() %>

          <%
	    AttributeValueDataBean attributeValue;
	    AttributeValueDataBean defaultAttributeValue;
          
          if (endIndex > defaultTotalsize) {
            endIndex = defaultTotalsize;
          }
          
          int indexFrom = startIndex;           
          for (int i = indexFrom; i < endIndex; i++)
          {
		defaultAttributeValue = defaultAttributeValues[i];
		
          	String attrValue = null;
	    	String attrValueType = null;
	    	String attrValueSequence = null;
          	
          	for(int j = 0; j < totalsize; j++){
          	
			attributeValue = attributeValues[j];
			
			if(attributeValue.getAttributeValueId().equals(defaultAttributeValue.getAttributeValueId())){
			
				attrValue = attributeValue.getAttributeValue();
				attrValueType = attributeValue.getAttributeValueType();
				attrValueSequence = attributeValue.getAttributeValueSequence().toString();
				break;
			}
			
			
			
		}		
		
		attrValueSequence = 	(attrValueSequence != null ? UIUtil.toJavaScript(attrValueSequence) : "") ;
		
		
		
		
		%>

        <%= comm.startDlistRow(rowselect) %>
        <%= comm.addDlistCheck( defaultAttributeValue.getAttributeValueId().toString(),"none" ) %>

	<script>
		var defaultFormattedValue = displayValue("<%=UIUtil.toJavaScript(defaultAttributeValue.getAttributeValue())%>", "<%=UIUtil.toJavaScript(defaultAttributeValue.getAttributeValueType())%>");		
                addDlistColumn( defaultFormattedValue, "none");
	</script>	
	

	<script>
		var formattedValue = displayValue("<%=UIUtil.toJavaScript(attrValue)%>", "<%=UIUtil.toJavaScript(attrValueType)%>");		
                addDlistColumn( formattedValue, "<%= UIUtil.toHTML("javascript:changeAttrValue(" + defaultAttributeValue.getAttributeValueId().toString() + ")")%>");
	</script>	

	
        <%= comm.addDlistColumn( UIUtil.toHTML(attrValueType),"none" ) %>
        
	<script>
		var formattedSequence = displayValue("<%=attrValueSequence%>", "<%=UIUtil.toJavaScript((String)AttrValueListNLS.get("float"))%>");
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
        <%=UIUtil.toHTML((String) AttrValueListNLS.get("emptyAttrValueList"))%>
        
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
      
      <%
      } catch (Exception e)	{
      
         com.ibm.commerce.exception.ExceptionHandler.displayJspException(request, response, e);
      }
      %>
      
    </BODY>
  </HTML>


