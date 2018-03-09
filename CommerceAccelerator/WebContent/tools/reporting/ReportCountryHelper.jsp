<!-- ========================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (c) Copyright IBM Corp. 2001, 2002

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 ===========================================================================-->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">

<%@page import="java.util.*" %>
<%@page import="com.ibm.commerce.command.CommandContext"%>
<%@page import="com.ibm.commerce.server.ECConstants"%>
<%@page import = "com.ibm.commerce.taxation.objects.CountryAccessBean" %>
<%@page import="com.ibm.commerce.exception.ExceptionHandler" %>

<%!

private String generateCountrySelection(HttpServletRequest request, String container, String title)
{
   CommandContext countryHelperCC = (CommandContext) request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
   Hashtable countryHelperRB = new Hashtable();
   String result = null;
         
   try {
      countryHelperRB = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("reporting.reportStrings", countryHelperCC.getLocale());

	  CountryAccessBean  countryBean = new CountryAccessBean();  
	  Enumeration en = countryBean.findByLanguageId(countryHelperCC.getLanguageId());
   if (countryHelperRB == null) System.out.println("!!!! Reports resouces bundle is null");

   String resulttitle = "";
   if (en == null) {
      // System.out.println("Reporting Framework: No currency available for selection.");
      return "";
   }
    
   if (title != null)  resulttitle =
                                     "    <TR>\n" +
                                     "       <TD COLSPAN=9 ALIGN=LEFT VALIGN=CENTER HEIGHT=32>" + countryHelperRB.get(title) + "</TD>\n" +
                                     "    </TR>\n";

	result = resulttitle + "<FORM NAME=" + container + ">\n <SELECT NAME=CountrySelection ID=countrySelection width=100> \n";
   
   while (en.hasMoreElements()) {
      CountryAccessBean bean = (CountryAccessBean)en.nextElement();
      String countryName=bean.getName();
      result = result + "   <OPTION value=" + countryName + ">" + countryName + "</OPTION> \n";
   }
   
   result += " </SELECT> \n</FORM>";
  } catch (Exception e) {
  e.printStackTrace();
  return "";
}
   return result;

}

%>
 
<SCRIPT>

   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   // save function for country
   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   function saveCountry(container)
   {
      with (document.forms[container]) {
         parent.put("countrySelectionIndex", CountrySelection.selectedIndex);
      }
   }

   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   // initialize function for country
   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   function onLoadCountry(container)
   {
      var curIndex = parent.get("countrySelectionIndex", null);

      if (curIndex != null) {
         with (document.forms[container]) {
            CountrySelection.selectedIndex  = curIndex;
         }
      }
   }

   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   // This function returns the country
   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   function returnCountry(container)
   {
      with (document.forms[container]) {
         return CountrySelection[CountrySelection.selectedIndex].value;
      }
   }

</SCRIPT>
