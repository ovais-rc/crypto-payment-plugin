<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2000, 2016 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">

<HTML>
<HEAD>


<%@page import="java.util.*,
		com.ibm.commerce.beans.*,
		com.ibm.commerce.tools.util.*,
                com.ibm.commerce.tools.catalog.beans.*,
                com.ibm.commerce.catalog.objects.*,
                com.ibm.commerce.catalog.beans.ItemDataBean,
                com.ibm.commerce.tools.catalog.util.*"
%>
<%@ page import="com.ibm.commerce.command.CommandContext" %>

<%@include file="../common/common.jsp" %>

<%
  CommandContext cmdContext = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
  Locale jLocale = cmdContext.getLocale();
  Hashtable itemResource = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("catalog.ItemNLS", jLocale);
%>

<% 
  try {
    // get parameters from URL
    
    String itemId = request.getParameter(ECConstants.EC_ITEM_NUMBER);
    Long item_id = null;
    if(itemId != null){
    	item_id = new Long(itemId);
    }
    String lang_id = request.getParameter(com.ibm.commerce.server.ECConstants.EC_LANGUAGE_ID);
    lang_id = (lang_id != null ? UIUtil.toJavaScript(lang_id) : "");
    
    Long product_id = new Long(request.getParameter(com.ibm.commerce.tools.catalog.util.ECConstants.EC_PRODUCT_NUMBER));

	if (itemId != null) {
	    if (product_id.toString().equals(item_id.toString()))
	    {
	       ItemDataBean bnItem = new ItemDataBean();
	       bnItem.setItemID(item_id.toString());
	       String strParent = bnItem.getParentProductId();
	       try
	       {
		       if (strParent != null)
		       {
		          product_id = new Long(strParent);
		       }
		       else
		       {
					String strParents[] = bnItem.getParentCatalogEntryIds();
					if (strParents.length > 0)
					{
						product_id = new Long(strParents[0]);
					}
		       }
	       }
	       catch(Exception e)
	       {
	       	//Could not find the ID of the parent product for the selected SKU.
	       }
	    }
    }

    AttributeListDataBean attributeList;
    AttributeDataBean attributes[] = null;
    int totalAttributes = 0;
    attributeList = new AttributeListDataBean();
    if (itemId != null) attributeList.setParentId(product_id);
    DataBeanManager.activate(attributeList, request);
    attributes = attributeList.getAttributeList();

    Vector attrValue = new Vector();
    Vector attrType = null;
    Vector attr_id = null;
    Vector attrName = null;
    Vector allAttrValues = null;
    Vector attrValueListEmpty = new Vector();


    if (attributes != null)
    {
   	totalAttributes = attributes.length;

	allAttrValues = new Vector();
	attrName = new Vector();
	attr_id = new Vector();
	attrType = new Vector();
 	
    	

    	for(int i=0; i < totalAttributes; i++){

		Long attributeId = attributes[i].getAttributeId();

		attr_id.addElement(attributeId.toString());
		attrName.addElement(attributes[i].getAttributeName());
		attrType.addElement(attributes[i].getAttributeType());


		// get the attribute values for the attributeId
		AttributeValueListDataBean attributeValueList;
		String attributeValues[] = null;
		attributeValueList = new AttributeValueListDataBean();
		attributeValueList.setAttributeId(attributeId);
		DataBeanManager.activate(attributeValueList, request);
		attributeValues = attributeValueList.getAttributeValues();
		
  		allAttrValues.addElement(attributeValues);
  		  		  		
  		if(attributeValues.length == 0){
  			attrValueListEmpty.addElement("YES");
  		}else{
  			attrValueListEmpty.addElement("NO");
  		}
  		


		//get the attribute value for the particular attributeId and itemId
		if(item_id != null){

			AttributeValueAccessBean attrValueAB = new AttributeValueAccessBean();
			
			Enumeration e =  attrValueAB.findByCatEntryIdLanguageIdAndAttributeId(item_id, new Integer(lang_id), attributeId);
			
			if(e != null && e.hasMoreElements()){
				AttributeValueAccessBean attributeValueAccessBean = (AttributeValueAccessBean) e.nextElement();
				
				try{
				
					if(attributes[i].getAttributeType().equalsIgnoreCase("AttributeFloatValueBean") || attributes[i].getAttributeType().equalsIgnoreCase("AttributeIntegerValueBean")){
					
						attrValue.addElement(attributeValueAccessBean.getAttributeValue().toString());
					
					}else{
						
						attrValue.addElement((String)attributeValueAccessBean.getAttributeValue());
					}
					
				}catch(java.lang.NullPointerException exception){
					attrValue.addElement(null);
				}
			} else {
				attrValue.addElement(null);
			}
			

		}
		
	}

	
    }
    
    
%>
<META name="GENERATOR" content="IBM WebSphere Page Designer V3.0.2 for Windows">
<META http-equiv="Content-Style-Type" content="text/css">
<TITLE><%=UIUtil.toHTML((String)itemResource.get("attribute"))%></TITLE>
<link rel=stylesheet href="<%= UIUtil.getCSSFile(jLocale) %>" type="text/css">

<%@include file="../common/NumberFormat.jsp" %>
<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/common/Vector.js"></SCRIPT>

<SCRIPT>
function AttributeData() {
    
    this.langid = "<%=lang_id%>";
    this.size = "<%=totalAttributes%>";
    this.attribute = new Object();

}  

Attribute.ID = "attribute";

function Attribute() {

    this.data = new AttributeData();
    this.id = Attribute.ID;
    this.formref = null;

}    


function AttributeStruct(attrname, attrvalue, attrtype, attrid, attrValueListEmpty) {
 
    this.attrname = attrname;
    this.attrvalue = attrvalue;
    this.attrtype = attrtype;
    this.attrid = attrid;
    this.formatValue = null;
    this.isEmptyValueList = attrValueListEmpty;   
}    

Attribute.prototype.load = load;
Attribute.prototype.display = display;
Attribute.prototype.getData = getData;


 
function load() {
    
    var objValue = null;
    
    <% for (int i = 0; i < totalAttributes; i++) { %>
        x = this.data.attribute["attr<%=i%>"];

    	x.attrvalue = this.formref.attrvalue<%=i%>.value;    		

    <%}%>
    
}

function display() {


   <% for (int i = 0; i < totalAttributes; i++) {  %>
        x = this.data.attribute["attr<%=i%>"];
                
        this.formref.attrvalue<%=i%>.value = x.attrvalue;   
                
    <%}%>
 
}

function getData() {

    return this.data;
    
}
 
var attr = null;

function savePanelData()
{

   if (attr != null)
   {
       attr.formref = document.attribute;
       attr.load();
       parent.put(Attribute.ID, attr.getData());
   }
  
}

function initForm() {

    attr = parent.get(Attribute.ID);
    
    if (attr == null) {
        

        attr = new Attribute();
        attrData = new AttributeData();  
        attrStruct = new Array();
  	
 	<% for (int i = 0; i < totalAttributes; i++) {%>
 	    attrStruct[<%=i%>] = new AttributeStruct("<%=(attrName != null ? UIUtil.toJavaScript((String)(attrName.elementAt(i))) : "")%>",
 	    					     "<%=(!attrValue.isEmpty() ? UIUtil.toJavaScript((String)attrValue.elementAt(i)) : "")%>",		    	
 					    	     "<%=(attrType != null ? UIUtil.toJavaScript((String)attrType.elementAt(i)) : "")%>",
 					    	     "<%=(attr_id != null ? UIUtil.toJavaScript((String)attr_id.elementAt(i)) : "")%>",
 					    	     "<%=(attrValueListEmpty != null ? UIUtil.toJavaScript((String)attrValueListEmpty.elementAt(i)) : "")%>");
 	
 	

 	    attrData.attribute["attr<%=i%>"] = attrStruct[<%=i%>];
 
 	<%}%>
	 
        attr.data = attrData;
        attr.formref = document.attribute;
        attr.display(); 
        
    } else {    
        

        attr = new Attribute();
        attr.data = parent.get(Attribute.ID);
        attr.formref = document.attribute;
        attr.display();
    }



    if (parent.get("attributeValueListEmptyMessage", false))
       {
        parent.remove("attributeValueListEmptyMessage");
        alertDialog("<%= UIUtil.toJavaScript((String)itemResource.get("attributeValueListEmptyMessage"))%>");
        
       }
    
    if (parent.get("selectAttributeMessage", false))
       {
        parent.remove("selectAttributeMessage");
        alertDialog("<%= UIUtil.toJavaScript((String)itemResource.get("selectAttributeMessage"))%>");
        
       }
     
    parent.setContentFrameLoaded(true);
}    




function validatePanelData(){
      
  <%  for (int i = 0; i < totalAttributes; i++) {  
  
  	String checkEmptyList = (String)attrValueListEmpty.elementAt(i);
  	
  	if(checkEmptyList.equalsIgnoreCase("YES")){  %> 
  
		alertDialog("<%=UIUtil.toJavaScript((String)itemResource.get("attributeValueListEmptyMessage"))%>");
		return false;
		
  	<%}%> //end if  
  
     
     	var objValue = document.attribute.attrvalue<%=i%>.value;              
                         
        if (objValue == "" || objValue == "NaN"){

		alertDialog("<%=UIUtil.toJavaScript((String)itemResource.get("selectAttributeMessage"))%>");
		return false;
      	}
      	      
  <%}%>  // end for
  
     
     return true;
     
}


function displayValue(value, valueType) {   
	        
        if(valueType == "AttributeIntegerValueBean") 
        {
             	var formatted = numberToStr(value, "<%=lang_id%>", null);
             	if (formatted != "NaN" && formatted != null){
                 	return formatted;   
             	}else{             
                 	return value;                 
             	}
         
        }else if(valueType  == "AttributeFloatValueBean"){
  
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


</SCRIPT>  

</HEAD>

<BODY onload="initForm()" class="content">
<H1><%=UIUtil.toHTML((String)itemResource.get("attribute"))%></H1>

<FORM name="attribute">
<% if (totalAttributes == 0) { %>
    <%=UIUtil.toHTML((String)itemResource.get("noattribute"))%>
<% } else {%>
<TABLE summary='<%=UIUtil.toHTML((String)itemResource.get("accessAttributes"))%>' width="95%" border=1 cellSpacing=0 cellPadding=0 dragColor=yellow style="margin-top: 0px; margin-right: 0px;  border-bottom: 1px solid #6D6D7C; border-left: 1px solid #6D6D7C; border-right: 0px solid #6D6D7C; border-top: 0px solid #6D6D7C;">

    <TR CLASS=dtableHeading ALIGN=left cellpadding=0 cellspacing=0 height=23>
        
   	<TD class="COLHEADNORMAL" width="80%" height=23><%=UIUtil.toHTML((String)itemResource.get("attrname"))%></TD>
	<TD class="COLHEADNORMAL" width="10%" height=23><%=UIUtil.toHTML((String)itemResource.get("attrvalue"))%></TD>
	
    </TR>
    
    <% 
        String classId="list_row1";
        
        for (int i = 0; i < totalAttributes; i++) {
        
           if (classId.equals("list_row1")) 
               classId="list_row2"; 
           else
	       classId="list_row1";
    %>
    <TR class=<%=classId%>>
    	
    	<TD CLASS="dtable" nowrap style="border-right: 1px solid #6D6D7C; padding-left: 7px;"><label for='attrvalue<%=i%>'><%=UIUtil.toHTML((String)attrName.elementAt(i))%></label></TD>
    	<TD CLASS="dtable" style="border-right: 1px solid #6D6D7C; padding-left: 7px;">
    	
    				<SELECT id='attrvalue<%=i%>' name="attrvalue<%=i%>">
    				<%
    				
    				String arrayOfValues[] = null;
    				String assignedValue = null;
    				
    				
    				if(allAttrValues != null){
    					arrayOfValues = (String[]) allAttrValues.elementAt(i);
    				}
    				
    				if(!attrValue.isEmpty()){
    					assignedValue = (String) attrValue.elementAt(i);
    				}


    		
				if(arrayOfValues != null){
				    				
    					for (int j = 0; j < arrayOfValues.length; j++){
    					
    					
    				%>	
    						<script>
							
        						var objAttributeType = "<%= UIUtil.toJavaScript((String) attrType.elementAt(i)) %>";    							
    							
    							var formattedValue = displayValue("<%= UIUtil.toJavaScript((String) arrayOfValues[j])%>", objAttributeType);
							formattedValue = convertFromTextToHTML(formattedValue);
    						
    						</script>
    					
    				<%		
					
						if (assignedValue != null && assignedValue.equals(arrayOfValues[j])){ 
    				%>	   			
							<OPTION value="<%= UIUtil.toHTML((String) arrayOfValues[j]) %>"  selected> <script> document.write(formattedValue); </script> </OPTION>
   	 			
   	 			<%
   	 					}else{   				
				%>
							<OPTION value="<%= UIUtil.toHTML((String) arrayOfValues[j]) %>" > <script> document.write(formattedValue); </script> </OPTION>
    				<%
    						}
					}
					
				}
				
				%>
				</SELECT>
    	</TD>
    	
    	
    </TR>

    <%}%>
       
</TABLE>
<%}%>
</FORM>
 
<%
}
catch (Exception e) 
{
com.ibm.commerce.exception.ExceptionHandler.displayJspException(request, response, e);
}

%>

<BODY>

</BODY>
</HTML>


