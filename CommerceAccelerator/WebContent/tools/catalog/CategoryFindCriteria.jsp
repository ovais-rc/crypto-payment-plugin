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
          Hashtable categoryFindNLS = (Hashtable) ResourceDirectory.lookup("catalog.CategoryNLS", jLocale); %>
          
      <TITLE>
      		<%= UIUtil.toHTML((String)categoryFindNLS.get("categoryFindCriteria_Title")) %>
      </TITLE>
      
      <SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>

      <SCRIPT>

        function doOnLoad()
        {
          document.categoryFindCriteriaFORM.categoryName.focus();
          parent.setContentFrameLoaded(true);
        }
        
         function getResultTitle() 
        {
          return "<%=UIUtil.toJavaScript((String)categoryFindNLS.get("categoryFindResults_Title"))%>";
        }
        
        function hasInvalidChars(inputString) 
        {
           
           var i=0;
           for (i=0; i < inputString.length; i++)
           {
              var c = inputString.charAt(i);
              switch(c)
              {
                 case "%":
                 case "\"":
                 case "_":
                 case "\\":
                 case "\'":
		 case "#":
                    return c;
              }
           }
           return null;
        }
            
        function validatePanelData() 
        {
         
            var a = document.categoryFindCriteriaFORM.categoryName.value;
            var b = document.categoryFindCriteriaFORM.categoryShortDescription.value;
      	   
      	    var invalidChar = "";

      	    invalidChar = hasInvalidChars(a);
      	    if ( invalidChar != null )
      	    {
      	        alertDialog(replaceField("<%=UIUtil.toJavaScript((String)categoryFindNLS.get("invalidCharacter"))%>", "?", invalidChar));
      	        return false;
      	    }
      	    
      	    invalidChar = hasInvalidChars(b);
      	    if ( invalidChar != null )
      	    {
      	        alertDialog(replaceField("<%=UIUtil.toJavaScript((String)categoryFindNLS.get("invalidCharacter"))%>", "?", invalidChar));
      	        return false;
      	    }
      	    
      	    return true;
  	}
        
        function replaceField(source, pattern, replacement) 
        {
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
    
      <H1><%=UIUtil.toHTML((String)categoryFindNLS.get("categoryFindCriteria_Title"))%></H1>
      <%=categoryFindNLS.get("categorySearchInstruction")%>
      <BR>
      <FORM NAME="categoryFindCriteriaFORM" ACTION="" METHOD="GET">
         <INPUT TYPE="hidden" NAME="langid" VALUE="<%=jLanguageID%>">
        <TABLE BORDER=0 CELLSPACING=0 CELLPADDING=0>

           <TH colspan="4"></TH>    
          <TR>
            <TD COLSPAN=4>&nbsp;</TD>
          </TR>
          <TR>
            <TD>&nbsp;</TD>
            <TD><LABEL for="categoryName"><%= UIUtil.toHTML((String)categoryFindNLS.get("categoryFindCriteria_field_name")) %></LABEL></TD>
            <TD WIDTH="25">&nbsp;</TD>
            <TD>
<!--              <INPUT TYPE="checkbox" NAME="nameCaseSensitive" VALUE=""><B>case sensitive</B>           -->
            </TD>
          </TR>
          <TR>
            <TD>&nbsp;</TD>
            <TD>
              <INPUT TYPE=text ID="categoryName" NAME="categoryName" SIZE=30>
            </TD>
            <TD>&nbsp;<LABEL for="nameLike"><SPAN STYLE="display:none;"><%= UIUtil.toHTML((String)categoryFindNLS.get("categoryFindCriteria_field_name")) %></SPAN></LABEL></TD>
            <TD>
              <SELECT ID="nameLike" NAME="nameLike">
                <OPTION VALUE="true"><%= UIUtil.toHTML((String)categoryFindNLS.get("categoryFindCriteria_option_like")) %></OPTION>
                <OPTION VALUE="false"><%= UIUtil.toHTML((String)categoryFindNLS.get("categoryFindCriteria_option_exact")) %></OPTION>
              </SELECT>
            </TD>
          </TR>
          
          <TR>
            <TD COLSPAN=4>&nbsp;</TD>
          </TR>
          
          <TR>
      <TD COLSPAN=4><br>
      </TD>
          </TR>
          <TR>
            <TD>&nbsp;</TD>
            <TD><LABEL for="categoryShortDescription"><%= UIUtil.toHTML((String)categoryFindNLS.get("categoryFindCriteria_field_shortDescription")) %></LABEL></TD>
            <TD WIDTH="25">&nbsp;</TD>
            <TD>
<!--              <INPUT TYPE="checkbox" NAME="shortDescriptionCaseSensitive" VALUE=""><B>case sensitive</B>          -->
            </TD>
          </TR>
          <TR>
            <TD>&nbsp;</TD>
            <TD>
              <INPUT TYPE=text ID="categoryShortDescription" NAME="categoryShortDescription" SIZE=30>
            </TD>
            <TD>&nbsp;<LABEL for="shortDescriptionLike"><SPAN STYLE="display:none;"><%= UIUtil.toHTML((String)categoryFindNLS.get("categoryFindCriteria_field_name")) %></SPAN></LABEL></TD>
            <TD>
              <SELECT ID="shortDescriptionLike" NAME="shortDescriptionLike">
                <OPTION VALUE="true"><%= UIUtil.toHTML((String)categoryFindNLS.get("categoryFindCriteria_option_like")) %></OPTION>
                <OPTION VALUE="false"><%= UIUtil.toHTML((String)categoryFindNLS.get("categoryFindCriteria_option_exact")) %></OPTION>
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
