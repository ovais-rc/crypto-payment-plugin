<%
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2000, 2002
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
//*
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
<HTML>
<!--
catalog editor test JSP
-->

<%@ page import="com.ibm.commerce.tools.test.*" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>

<%@ page import="javax.servlet.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>

<%@include file="../common/common.jsp" %>
<%@include file="../common/NumberFormat.jsp" %>

  
    <HEAD>
      <% try {
          CommandContext cmdContext = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
     	  Locale jLocale = cmdContext.getLocale();
     	  String jLanguageID = cmdContext.getLanguageId().toString();
          Hashtable ProductFindNLS = (Hashtable) ResourceDirectory.lookup("catalog.ProductNLS", jLocale); %>
      <TITLE><%= UIUtil.toHTML((String)ProductFindNLS.get("productFindCriteria_Title")) %></TITLE>
      <SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>

      
      <SCRIPT>

        function doOnLoad()
        {
          document.ProductFindCriteriaFORM.ProductPartNumber.focus();
          
          parent.setContentFrameLoaded(true);
        }
        
         function getResultTitle() 
        {
          return "<%=UIUtil.toJavaScript((String)ProductFindNLS.get("productFindResults_Title"))%>";
        }
        
        function hasInvalidChars(inputString) 
        {
  			return null;
  			
  		   /*******************************************         
           var i=0;
           
           for (i=0; i < inputString.length; i++)
           {
              //var c = inputString.charAt(i);
              //switch(c)
              //{
                 //case "%":
                 //case "_":
                 //case "\"":
                 //case "\\":
                 //case "\'":
		 		 //case "#":
                 //   return c;
              //}
           }
           return null;
           ********************************************/
        }
            
        function validatePanelData() 
        {
         
            var a = document.ProductFindCriteriaFORM.ProductPartNumber.value;
            var b = document.ProductFindCriteriaFORM.ProductName.value;
            var c = document.ProductFindCriteriaFORM.ProductShortDescription.value;
            //var d = document.ProductFindCriteriaFORM.categoryCode.value;
            var e = document.ProductFindCriteriaFORM.categoryName.value;
      	   
      	    var invalidChar = "";

      	    invalidChar = hasInvalidChars(a);
      	    if ( invalidChar != null )
      	    {
      	        alertDialog(replaceField("<%=UIUtil.toJavaScript((String)ProductFindNLS.get("invalidCharacter"))%>", "?", invalidChar));
      	        return false;
      	    }
      	    
      	    invalidChar = hasInvalidChars(b);
      	    if ( invalidChar != null )
      	    {
      	        alertDialog(replaceField("<%=UIUtil.toJavaScript((String)ProductFindNLS.get("invalidCharacter"))%>", "?", invalidChar));
      	        return false;
      	    }

      	    invalidChar = hasInvalidChars(c);
      	    if ( invalidChar != null )
      	    {
      	        alertDialog(replaceField("<%=UIUtil.toJavaScript((String)ProductFindNLS.get("invalidCharacter"))%>", "?", invalidChar));
      	        return false;
      	    }
      	    
      	    //invalidChar = hasInvalidChars(d);
      	    //if ( invalidChar != null )
      	    //{
      	    //    alertDialog(replaceField("<%=UIUtil.toJavaScript((String)ProductFindNLS.get("invalidCharacter"))%>", "?", invalidChar));
      	    //    return false;
      	    //}
      	    
      	    invalidChar = hasInvalidChars(e);
      	    if ( invalidChar != null )
      	    {
      	        alertDialog(replaceField("<%=UIUtil.toJavaScript((String)ProductFindNLS.get("invalidCharacter"))%>", "?", invalidChar));
      	        return false;
      	    }

      	    return true;
  	}
        
        function replaceField(source, pattern, replacement) {
    	    returnString = "";

    	    index1 = source.indexOf(pattern);
    	    index2 = index1 + pattern.length;
	
	    returnString += source.substring(0, index1) + replacement + source.substring(index2);
	
    	    return returnString;
	}	
	
      </SCRIPT>
      <link rel=stylesheet href="<%= UIUtil.getCSSFile(jLocale) %>" type="text/css">
      <STYLE>
        <!-- A {text-decoration:none; font-family:Arial,Helvetica,sans-serif; font-size:10pt} -->
        <!-- BODY {text-decoration:none; font-family:Arial,Helvetica,sans-serif; font-size:10pt} -->
        <!-- INPUT {text-decoration:none; font-family:Arial,Helvetica,sans-serif; font-size:10pt} -->
        <!-- TD {text-decoration:none; font-family:Arial,Helvetica,sans-serif; font-size:10pt} -->
      </STYLE>
    </HEAD>

    <BODY onLoad="doOnLoad()" class="content">
    
      <H1><%=UIUtil.toHTML((String)ProductFindNLS.get("productFindCriteria_Title"))%></H1>
      <%=ProductFindNLS.get("searchInstruction")%>
      <BR>
      <FORM NAME="ProductFindCriteriaFORM" ACTION="" METHOD="GET">
         <INPUT TYPE="hidden" NAME="langid" VALUE="<%=jLanguageID%>">
        <TABLE BORDER=0 CELLSPACING=0 CELLPADDING=0>
          <TH colspan="4"></TH>   
          <TR>
            <TD WIDTH="25">&nbsp;</TD>
            <TD><label for='productFindCriteria_field_sku'><%= UIUtil.toHTML((String)ProductFindNLS.get("productFindCriteria_field_sku")) %></label></TD>
            <TD>&nbsp;</TD>
            <TD>
<!--              <INPUT TYPE="checkbox" NAME="partNumberCaseSensitive" VALUE=""><B>case sensitive</B>              -->
            </TD>
          </TR>
          <TR>
            <TD>&nbsp;</TD>
            <TD>
              <INPUT id='productFindCriteria_field_sku' TYPE=text NAME="ProductPartNumber" SIZE=15>
            </TD>
            <TD WIDTH="25">&nbsp;<LABEL for='productFindCriteria_field_sku2'><SPAN STYLE="display:none;"><%= UIUtil.toHTML((String)ProductFindNLS.get("productFindCriteria_field_sku")) %></SPAN></LABEL></TD>
            <TD>
              <SELECT id='productFindCriteria_field_sku2' NAME="partNumberLike">
                <OPTION VALUE="true"><%= UIUtil.toHTML((String)ProductFindNLS.get("productFindCriteria_option_like")) %></OPTION>
                <OPTION VALUE="false"><%= UIUtil.toHTML((String)ProductFindNLS.get("productFindCriteria_option_exact")) %></OPTION>
              </SELECT>
            </TD>
          </TR>
          <TR>
            <TD COLSPAN=4>&nbsp;</TD>
          </TR>
          <TR>
            <TD>&nbsp;</TD>
            <TD><label for='productFindCriteria_field_name'><%= UIUtil.toHTML((String)ProductFindNLS.get("productFindCriteria_field_name")) %></label></TD>
            <TD WIDTH="25">&nbsp;</TD>
            <TD>
<!--              <INPUT TYPE="checkbox" NAME="nameCaseSensitive" VALUE=""><B>case sensitive</B>           -->
            </TD>
          </TR>
          <TR>
            <TD>&nbsp;</TD>
            <TD>
              <INPUT id='productFindCriteria_field_name' TYPE=text NAME="ProductName" SIZE=30>
            </TD>
            <TD>&nbsp;<LABEL for='productFindCriteria_field_name2'><SPAN STYLE="display:none;"><%= UIUtil.toHTML((String)ProductFindNLS.get("productFindCriteria_field_name")) %></SPAN></LABEL></TD>
            <TD>
              <SELECT id='productFindCriteria_field_name2' NAME="nameLike">
                <OPTION VALUE="true"><%= UIUtil.toHTML((String)ProductFindNLS.get("productFindCriteria_option_like")) %></OPTION>
                <OPTION VALUE="false"><%= UIUtil.toHTML((String)ProductFindNLS.get("productFindCriteria_option_exact")) %></OPTION>
              </SELECT>
            </TD>
          </TR>
          <TR>
            <TD COLSPAN=4>&nbsp;</TD>
          </TR>
          <TR>
            <TD>&nbsp;</TD>
            <TD><label for='productFindCriteria_field_shortDescription'><%= UIUtil.toHTML((String)ProductFindNLS.get("productFindCriteria_field_shortDescription")) %></label></TD>
            <TD WIDTH="25">&nbsp;</TD>
            <TD>
<!--              <INPUT TYPE="checkbox" NAME="shortDescriptionCaseSensitive" VALUE=""><B>case sensitive</B>          -->
            </TD>
          </TR>
          
          <TR>
            <TD>&nbsp;</TD>
            <TD>
              <INPUT id='productFindCriteria_field_shortDescription' TYPE=text NAME="ProductShortDescription" SIZE=30>
            </TD>
            <TD>&nbsp;<LABEL for='productFindCriteria_field_shortDescription2'><SPAN STYLE="display:none;"><%= UIUtil.toHTML((String)ProductFindNLS.get("productFindCriteria_field_shortDescription")) %></SPAN></LABEL></TD>
            <TD>
              <SELECT id='productFindCriteria_field_shortDescription2' NAME="shortDescriptionLike">
                <OPTION VALUE="true"><%= UIUtil.toHTML((String)ProductFindNLS.get("productFindCriteria_option_like")) %></OPTION>
                <OPTION VALUE="false"><%= UIUtil.toHTML((String)ProductFindNLS.get("productFindCriteria_option_exact")) %></OPTION>
              </SELECT>
            </TD>
          </TR>
<!--          
          <TR>
            <TD COLSPAN=4>&nbsp;</TD>
          </TR>
          <TR>
            <TD>&nbsp;</TD>
            <TD COLSPAN=3><label for='productFindCriteria_field_categoryCode'><%= UIUtil.toHTML((String)ProductFindNLS.get("productFindCriteria_field_categoryCode")) %></label></TD>
          </TR>
         
          <TR>
            <TD>&nbsp;</TD>
            <TD>
              <INPUT id='productFindCriteria_field_categoryCode' TYPE=text NAME="categoryCode" SIZE=30>
            </TD>
            <TD>&nbsp;<LABEL for='productFindCriteria_field_categoryCode2'><SPAN STYLE="display:none;"><%= UIUtil.toHTML((String)ProductFindNLS.get("productFindCriteria_field_categoryCode")) %></SPAN></LABEL></TD>
            <TD>
              <SELECT id='productFindCriteria_field_categoryCode2' NAME="categoryCodeLike">
                <OPTION VALUE="true"><%= UIUtil.toHTML((String)ProductFindNLS.get("productFindCriteria_option_like")) %></OPTION>
                <OPTION VALUE="false"><%= UIUtil.toHTML((String)ProductFindNLS.get("productFindCriteria_option_exact")) %></OPTION>
              </SELECT>
            </TD>
          </TR>
-->          
          <TR>
            <TD COLSPAN=4>&nbsp;</TD>
          </TR>
          <TR>
            <TD>&nbsp;</TD>
            <TD COLSPAN=3><label for='productFindCriteria_field_categoryName'><%= UIUtil.toHTML((String)ProductFindNLS.get("productFindCriteria_field_categoryName")) %></label></TD>
          </TR>
          
          <TR>
            <TD>&nbsp;</TD>
            <TD>
              <INPUT id='productFindCriteria_field_categoryName' TYPE=text NAME="categoryName" SIZE=30>
            </TD>
            <TD>&nbsp;<LABEL for='productFindCriteria_field_categoryName2'><SPAN STYLE="display:none;"><%= UIUtil.toHTML((String)ProductFindNLS.get("productFindCriteria_field_categoryName")) %></SPAN></LABEL></TD>
            <TD>
              <SELECT id='productFindCriteria_field_categoryName2' NAME="categoryNameLike">
                <OPTION VALUE="true"><%= UIUtil.toHTML((String)ProductFindNLS.get("productFindCriteria_option_like")) %></OPTION>
                <OPTION VALUE="false"><%= UIUtil.toHTML((String)ProductFindNLS.get("productFindCriteria_option_exact")) %></OPTION>
              </SELECT>
            </TD>
          </TR>

        </TABLE>
       <% } catch (Exception e)	{
        	com.ibm.commerce.exception.ExceptionHandler.displayJspException(request, response, e);
	  }
	%>
      </FORM>

    </BODY>

  </HTML>
