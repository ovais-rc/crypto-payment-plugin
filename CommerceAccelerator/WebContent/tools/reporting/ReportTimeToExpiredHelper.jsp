<!-- ========================================================================
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
   -------------------------------------------------------------------
    ReportNumberOfDaysHelper.jsp
 ===========================================================================-->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">

<%@page import="java.util.*" %>
<%@page import="com.ibm.commerce.command.CommandContext"%>
<%@page import="com.ibm.commerce.server.ECConstants"%>

<%
   CommandContext timeToExpiredHelperCC = (CommandContext) request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
   Hashtable      timeToExpiredHelperRB = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("reporting.reportStrings", timeToExpiredHelperCC.getLocale());
%>

<%!
private String generateTimeToExpired(String container, Hashtable reportsRB, String title, String day)
{
   String resulttitle = "";
   int dynamicTagCounter = 0;   

   if (title != null)  resulttitle = 
                                     "    <tr>\n" +
                                     "       <td  align=left valign=center height=32 id=\"ReportTimeToExpiredHelper_DynamicTableCell_"+ dynamicTagCounter +"_1\">\n" + reportsRB.get(title) + "</td>\n" +
                                     "    </tr>\n";


   String result = "<form name=\"" + container + "\" id=\"" + container + "\">\n" +
                   "  <table cellpadding=0 cellspacing=0>\n" + resulttitle + 
                   "    <tr>\n" + 
                   "      <td id=\"ReportTimeToExpiredHelper_DynamicTableCell_"+ dynamicTagCounter +"_2\">\n" +
                   "          <input type=text name=TimeToExpired width=4 size=2 maxlength=3>" + reportsRB.get(day) + "</input>\n" +
  		   "      </td>\n" +
                   "    </tr>\n" +
                   "  </table>\n" + 
                   "</form>\n";
   dynamicTagCounter++;
   return result;
}

%>

<script>

   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   // Load any data from the parent (if it exists)
   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   function onLoadTimeToExpired(container) 
   {
      var myContainer = parent.get(container, null);

      ////////////////////////////////////////////////////////////////////////////////////////////////////
      // If this is the first time then initialize the container to 0 days 
      ////////////////////////////////////////////////////////////////////////////////////////////////////
      if (myContainer == null) {
         myContainer = new Object();
         myContainer.TimeToExpired = 0;
         parent.put(container, myContainer);
      }

      ////////////////////////////////////////////////////////////////////////////////////////////////////
      // Load the previously saved days into input text box
      ////////////////////////////////////////////////////////////////////////////////////////////////////
      var days = myContainer.TimeToExpired;
      if (days != null) {
         document.forms[container].TimeToExpired.value = days;
      }

      return;
   }

   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   // Save the selected days for when returning
   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   function saveTimeToExpired(container) 
   {
      myContainer = parent.get(container,null);
      if (myContainer == null) return;
      myContainer.TimeToExpired = document.forms[container].TimeToExpired.value ;
      parent.put(container, myContainer);
   }

   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   // Validate the number of days entered
   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   function validateTimeToExpired(container) 
   {
      with (document.forms[container]) {
         if (TimeToExpired.value == null || !isValidPositiveInteger(TimeToExpired.value)) {
            alertDialog("<%=timeToExpiredHelperRB.get("TimeToExpiredHelperInvalidNumber")%>");
            return false;
         }
      }
      return true;
   }

   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   // Return days 
   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   function returnTimeToExpired(container) {
      return document.forms[container].TimeToExpired.value;
   }




</script>


