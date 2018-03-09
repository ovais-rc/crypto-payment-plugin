<%--==========================================================================
Licensed Materials - Property of IBM

WebSphere Commerce

(c) Copyright IBM Corp.  2002, 2006
All Rights Reserved

US Government Users Restricted Rights - Use, duplication or
disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
===========================================================================--%>


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<!--
category search JSP
-->


<%@ page import="com.ibm.commerce.tools.util.*" %>

<%@ page import="javax.servlet.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>

<%@include file="epromotionCommon.jsp" %>
<%@include file="../common/NumberFormat.jsp" %>


 <head>
  <% try {      	  
      CommandContext cmdContext = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
 	  Locale jLocale = cmdContext.getLocale();
 	  String jLanguageID = cmdContext.getLanguageId().toString();       
  %>

  <title>
  		<%= UIUtil.toHTML((String)RLPromotionNLS.get("RLCgrySearchTitle")) %>
  </title>

 <script src="/wcs/javascript/tools/common/Util.js">
</script>
 <script> 
       // top.mccmain.mcccontent.isInsideWizard = function() {
       // return true;
		//}   
	top.getModel(1);
	var rlpromo = top.getData("RLPromotion", 1);
	var catList = top.getData("RLCategoryList",1);
			
                  
	if(rlpromo != null)
	{
		top.put("RLPromotion", rlpromo);	
	}		
		
	function doOnLoad()
    {          
      document.categorySearchCriteriaFORM.categoryName.focus();
      parent.setContentFrameLoaded(true);
    }
    
    function cancelAction() {
		top.goBack();	
	}
        
    function getResultTitle() 
    {
      return "<%=UIUtil.toJavaScript((String)RLPromotionNLS.get("CategorySearchResultBrowserTitle"))%>";
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
		if (rlpromo != null)
		{
			top.put("RLPromotion", rlpromo);
		}
     
        var a = document.categorySearchCriteriaFORM.categoryName.value;
        var b = document.categorySearchCriteriaFORM.categoryShortDescription.value;
  	   
  	    var invalidChar = "";
		// disable for search.
  	    // invalidChar = hasInvalidChars(a);
  	    // if ( invalidChar != null )
  	    // {
  	    //     alertDialog(replaceField("<%=UIUtil.toJavaScript((String)RLPromotionNLS.get("invalidCharacter"))%>", "?", invalidChar));
  	    //     return false;
  	    // }
  	    
  	    // invalidChar = hasInvalidChars(b);
  	    // if ( invalidChar != null )
  	    // {
  	    //     alertDialog(replaceField("<%=UIUtil.toJavaScript((String)RLPromotionNLS.get("invalidCharacter"))%>", "?", invalidChar));
  	    //     return false;
  	    // }      	    
  	    return true;
  	}
        
    function replaceField(source, pattern, replacement){
	    returnString = "";
	    index1 = source.indexOf(pattern);
	    index2 = index1 + pattern.length;
    	returnString += source.substring(0, index1) + replacement + source.substring(index2);
   	    return returnString;
	}			
		
	
 
</script>
      <link rel="stylesheet" href="<%= UIUtil.getCSSFile(jLocale) %>" type="text/css" />

        <!-- A {text-decoration:none; font-family:Arial,Helvetica,sans-serif; font-size:10pt} -->
        <!-- BODY {text-decoration:none; font-family:Arial,Helvetica,sans-serif; font-size:10pt} -->
        <!-- INPUT {text-decoration:none; font-family:Arial,Helvetica,sans-serif; font-size:10pt} -->
        <!-- TD {text-decoration:none; font-family:Arial,Helvetica,sans-serif; font-size:10pt} -->

    </head>

    <body onload="doOnLoad()" class="content">

      <h1><%=UIUtil.toHTML((String)RLPromotionNLS.get("RLCgrySearchTitle"))%></h1>

      <br />
      <form name="categorySearchCriteriaFORM" action="" method="post" id="categorySearchCriteriaFORM">
      <br /><br />
		<table id="WC_RLCategorySearchCriteria_Table_1"> <tr> <td id="WC_RLCategorySearchCriteria_TableCell_1"> <%= RLPromotionNLS.get("RLCgrySearchText") %> </td> </tr> </table>
         <input type="hidden" name="langid" value="<%=jLanguageID%>" id="WC_RLCategorySearchCriteria_FormInput_langid_In_categorySearchCriteriaFORM_1" />
        <table border="0" cellspacing="0" cellpadding="0" id="WC_RLCategorySearchCriteria_Table_2">

           <th colspan="4"></th>
          <tr>
            <td colspan="4" id="WC_RLCategorySearchCriteria_TableCell_2">&nbsp;</td>
          </tr>
          <tr>
            <td id="WC_RLCategorySearchCriteria_TableCell_3">&nbsp;</td>
            <td id="WC_RLCategorySearchCriteria_TableCell_4"><label for="searchTermName"><%= UIUtil.toHTML((String)RLPromotionNLS.get("searchTermName")) %></label></td>
            <td width="25" id="WC_RLCategorySearchCriteria_TableCell_5">&nbsp;</td>
            <td id="WC_RLCategorySearchCriteria_TableCell_6">
<!--              <INPUT TYPE="checkbox" NAME="nameCaseSensitive" VALUE=""><B>case sensitive</B>           -->
            </td>
          </tr>
          <tr>
            <td id="WC_RLCategorySearchCriteria_TableCell_7">&nbsp;</td>
            <td id="WC_RLCategorySearchCriteria_TableCell_8">
              <input type="text" name="categoryName" size="30" id="searchTermName" />
            </td>
            <td id="WC_RLCategorySearchCriteria_TableCell_9"><label class="hidden-label" for="nameLike"><%= UIUtil.toHTML((String)RLPromotionNLS.get("containsMatch")) %></label>&nbsp;</td>
            <td id="WC_RLCategorySearchCriteria_TableCell_10">
              <select name="nameLike" id="nameLike">
                <option value="true"><%= UIUtil.toHTML((String)RLPromotionNLS.get("containsMatch")) %></option>
                <option value="false"><%= UIUtil.toHTML((String)RLPromotionNLS.get("exactMatch")) %></option>
              </select>
            </td>
          </tr>

          <tr>
            <td colspan="4" id="WC_RLCategorySearchCriteria_TableCell_11">&nbsp;</td>
          </tr>

          <tr>
      <td colspan="4" id="WC_RLCategorySearchCriteria_TableCell_12"><br />
      </td>
          </tr>
          <tr>
            <td id="WC_RLCategorySearchCriteria_TableCell_13">&nbsp;</td>
            <td id="WC_RLCategorySearchCriteria_TableCell_14"><label for="searchTermDesc"><%= UIUtil.toHTML((String)RLPromotionNLS.get("searchTermDesc")) %></label></td>
            <td width="25" id="WC_RLCategorySearchCriteria_TableCell_15">&nbsp;</td>
            <td id="WC_RLCategorySearchCriteria_TableCell_16">
<!--              <INPUT TYPE="checkbox" NAME="shortDescriptionCaseSensitive" VALUE=""><B>case sensitive</B>          -->
            </td>
          </tr>
          <tr>
            <td id="WC_RLCategorySearchCriteria_TableCell_17">&nbsp;</td>
            <td id="WC_RLCategorySearchCriteria_TableCell_18">
              <input type="text" name="categoryShortDescription" size="30" id="searchTermDesc" />
            </td>
            <td id="WC_RLCategorySearchCriteria_TableCell_19"><label class="hidden-label" for="shortDescriptionLike"><%= UIUtil.toHTML((String)RLPromotionNLS.get("containsMatch")) %></label>&nbsp;</td>
            <td id="WC_RLCategorySearchCriteria_TableCell_20">
              <select name="shortDescriptionLike" id="shortDescriptionLike">
                <option value="true"><%= UIUtil.toHTML((String)RLPromotionNLS.get("containsMatch")) %></option>
                <option value="false"><%= UIUtil.toHTML((String)RLPromotionNLS.get("exactMatch")) %></option>
              </select>
            </td>
          </tr>

        </table>
       <% } catch (Exception e)	{       		
        	com.ibm.commerce.exception.ExceptionHandler.displayJspException(request, response, e);
	  }
	%>
      </form>

    </body>

  </html>
