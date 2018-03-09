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

<%
   CommandContext monthlyWeekleyHelperCC = (CommandContext) request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
   Hashtable monthlyWeekleyHelperRB = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("reporting.reportStrings", monthlyWeekleyHelperCC.getLocale());
%>

<%!
private String generateTimePeriodOption(String container, Hashtable reportsRB, String title)
{
   String resulttitle = "";

   if (title != null){  resulttitle =
                                     "    <TR>\n" +
                                     "       <TD COLSPAN=9 ALIGN=LEFT VALIGN=CENTER HEIGHT=32>" + reportsRB.get(title) + "</TD>\n" +
                                     "    </TR>\n";
			   }
   String result = 	"<FORM NAME=" + container + ">\n" +
                   			"   <TABLE CELLPADDING=0 CELLSPACING=0>" + resulttitle +
						    "      <TR HEIGHT=25>\n" +
						    "         <TD VALIGN=TOP>" + reportsRB.get("MonthlyWeekleySelect") + "</TD>\n" +
						    "         <TD>&nbsp;</TD>\n" +
						    "      </TR>\n" +
						    "      <TR>\n" +
						    "         <TD ALIGN=LEFT VALIGN=TOP>\n" +
						    "            <BR>\n" +
						    "            <INPUT TYPE=RADIO NAME=TimePeriodOptions VALUE=Weekley>\n" +
						    "               " + reportsRB.get("MonthlyWeekleyHelperWeekley") + "\n" +
						    "			 </INPUT>\n" +
						    "            <BR>\n" +
						    "            <INPUT TYPE=RADIO NAME=TimePeriodOptions VALUE=Monthly>\n" +
						    "               " + reportsRB.get("MonthlyWeekleyHelperMonthly") + "\n" +
						    "			 </INPUT>\n" +
						    "         </TD>\n" +
						    "         <TD>&nbsp;</TD>\n" +
						    "      </TR>\n" +
						    "   </TABLE>\n" +
						    " </FORM>\n";
   return result;
}

%>

<HEAD>
   <META name="GENERATOR" content="IBM WebSphere Studio">
</HEAD>
 
<SCRIPT>

   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   // Validate that some items have been chosen if the "some items" radio is checked
   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   function validateTimePeriodOption(container)
   {
      return true;
   }

   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   // initialize function for the start/end dates
   ///////////////////////////////////////////////////////////////////////////////////////////////////////
     
   function onLoadTimePeriodOption(container)
   {
	  var myContainer = parent.get(container, null);
    	
	  // If this is the first time set it to the default.	    	
      if (myContainer == null) {
		myContainer = new Object();
		myContainer.Weekley = true;
		with (document.forms[container]) {
			TimePeriodOptions[0].checked = true;
		}
		parent.put(container, myContainer);
		return;  	    
      }else {
			if(myContainer.Weekley == false ){
				document.forms[container].TimePeriodOptions[1].checked = true;
			} else {
				document.forms[container].TimePeriodOptions[0].checked = true;
			}
      	return;
      }
   }
   
   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   // save function for the time period selected
   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   function saveTimePeriodOption(container)
   {
      myContainer = parent.get(container,null);
      if (myContainer == null) return;

      with (document.forms[container]) {
      	 if(TimePeriodOptions[0].checked){
      	 	myContainer.Weekley = true;
      	 }else {
      	 	myContainer.Weekley = false;
      	 }
      }
      parent.put(container, myContainer);
   }

   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   // Return the value
   ///////////////////////////////////////////////////////////////////////////////////////////////////////  
   function returnTimePeriodOption(container) {
      return document.forms[container].TimePeriodOptions[0].checked;
   }

</SCRIPT>
