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
<%@page import="com.ibm.commerce.common.objects.CurrencyAccessBean" %>
<%@page import="com.ibm.commerce.common.objects.SupportedCurrencyAccessBean" %>
<%@page import="com.ibm.commerce.price.utils.CurrencyManager" %>
<%@page import="com.ibm.commerce.exception.ExceptionHandler" %>

<%!

private String generateCurrencySelection(HttpServletRequest request, String container, String title)
{
   Iterator iter = null;
   TreeMap sortedMap = new TreeMap();

   CommandContext currencyHelperCC = (CommandContext) request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
   Hashtable currencyHelperRB = new Hashtable();
   String currentCurrency = "";
         
   try {
      currencyHelperRB = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("reporting.reportingString", currencyHelperCC.getLocale());
      currentCurrency = currencyHelperCC.getCurrency();
      
      CurrencyAccessBean cBean = new CurrencyAccessBean();  // maps to the SETCCURR table
      Enumeration en = cBean.findAll();

      // sort the records by description

      while (en.hasMoreElements()) {
         CurrencyAccessBean bean = (CurrencyAccessBean)en.nextElement();
         String description = bean.getDescription(currencyHelperCC.getLanguageId(), currencyHelperCC.getStoreId()).getDescription();
         sortedMap.put(description, bean.getCurrencyCode());
      }

      iter = sortedMap.keySet().iterator();
   } catch (Exception e) {
      e.printStackTrace();
   }

   String resulttitle = "";
   
   if (iter == null) {
      // System.out.println("Reporting Framework: No currency available for selection.");
      return "";
   }
    
   if (title != null)  resulttitle =
                                     "    <TR>\n" +
                                     "       <TD COLSPAN=9 ALIGN=LEFT VALIGN=CENTER HEIGHT=32>" + currencyHelperRB.get(title) + "</TD>\n" +
                                     "    </TR>\n";

   String result = resulttitle + "<FORM NAME=" + container + ">\n <SELECT NAME=CurrencySelection ID=currencySelection width=100> \n";
   
   while (iter.hasNext()) {
      String desc = (String) iter.next();
      String curCode = (String) sortedMap.get(desc);
      result = result + "   <OPTION value=" + curCode; 
      if (curCode.equalsIgnoreCase(currentCurrency)) {
      	 result = result + " selected";
      }
      result = result + ">" + desc + "</OPTION> \n";
   }
   
   result += " </SELECT> \n</FORM>";
   
   return result;
}

%>
 
<SCRIPT>

   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   // save function for currency
   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   function saveCurrency(container)
   {
      with (document.forms[container]) {
         parent.put("currencySelectionIndex", CurrencySelection.selectedIndex);
      }
   }

   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   // initialize function for currency
   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   function onLoadCurrency(container)
   {
      var curIndex = parent.get("currencySelectionIndex", null);

      if (curIndex != null) {
         with (document.forms[container]) {
            CurrencySelection.selectedIndex  = curIndex;
         }
      }
   }

   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   // This function returns the currency 
   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   function returnCurrency(container)
   {
      with (document.forms[container]) {
         return CurrencySelection[CurrencySelection.selectedIndex].value;
      }
   }

</SCRIPT>
