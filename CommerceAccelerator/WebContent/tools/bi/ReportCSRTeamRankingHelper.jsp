<!-- ========================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (c) Copyright IBM Corp. 2005

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 ===========================================================================-->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">

<%@page import="java.util.*" %>
<%@page import="com.ibm.commerce.command.CommandContext"%>
<%@page import="com.ibm.commerce.server.ECConstants"%>

<%!

private String generateSortOrderByOption(String container, Hashtable biNLS)
{
   

   String result = 	"<FORM NAME=" + container + ">\n" +
                   			"   <TABLE border=0 bordercolor=red CELLPADDING=0 CELLSPACING=0 width=400>" + 
	                        "	 <TR>\n" +

							"         <TD ALIGN=left VALIGN=TOP>\n" +						    							
							"			<TABLE border=0 bordercolor=black CELLPADDING=0 CELLSPACING=0 width=200>" + 
						    "			 <TR HEIGHT=5>\n" +
							"			   <TD ALIGN=left VALIGN=TOP>\n" +
						    "            <INPUT TYPE=RADIO NAME=sortBy VALUE=All>\n" +
						    "               " + biNLS.get("CSRTeamRankingReportCSRTeamName") + "\n" +
						    "			 </INPUT>\n" +
						    "            <BR>\n" +
                            "            <BR>\n" +
						    "            <INPUT TYPE=RADIO NAME=sortBy VALUE=All>\n" +
						    "               " + biNLS.get("CSRTeamRankingReportRevenue") + "\n" +
						    "			 </INPUT>\n" +
						    "            <BR>\n" +	
                            "            <BR>\n" +
						    "            <INPUT TYPE=RADIO NAME=sortBy VALUE=All>\n" +
						    "               " + biNLS.get("CSRTeamRankingReportProfit") + "\n" +
						    "			 </INPUT>\n" +
						    "            <BR>\n" +	
						    "         </TD>\n" +
						    "      </TR>\n" +
						    "   </TABLE>\n" +
						    "         </TD>\n" +

							"         <TD>&nbsp;</TD>\n" +

	            			"         <TD ALIGN=left VALIGN=TOP>\n" +
							"			<TABLE border=0 bordercolor=black CELLPADDING=0 CELLSPACING=0 width=200>" + 
						    "			 <TR HEIGHT=5>\n" +
							"			   <TD ALIGN=left VALIGN=TOP>\n" +
						    "            <INPUT TYPE=RADIO  NAME=orderBy VALUE=All>\n" +
						    "               " + biNLS.get("descend") + "\n" +
						    "			 </INPUT>\n" +
						    "            <BR>\n" +
							"            <BR>\n" +
						    "            <INPUT TYPE=RADIO NAME=orderBy VALUE=All>\n" +
						    "               " + biNLS.get("ascend") + "\n" +
						    "			 </INPUT>\n" +
						    "            <BR>\n" +						            		
							"         </TD>\n" +
							"      </TR>\n" +
						    "   </TABLE>\n" +
						    "         </TD>\n" +
						    
							"         <TD>&nbsp;</TD>\n" +

	            			"         <TD ALIGN=left VALIGN=TOP>\n" +
							"			<TABLE border=0 bordercolor=black CELLPADDING=0 CELLSPACING=0 width=200>" + 
						    "			 <TR HEIGHT=5>\n" +
							"			   <TD ALIGN=left VALIGN=TOP>\n" +
						    "            <INPUT TYPE=RADIO  NAME=rankBy VALUE=All>\n" +
						    "               " + biNLS.get("CSRTeamRankingReportRevenue") + "\n" +
						    "			 </INPUT>\n" +
						    "            <BR>\n" +
							"            <BR>\n" +
						    "            <INPUT TYPE=RADIO NAME=rankBy VALUE=All>\n" +
						    "               " + biNLS.get("CSRTeamRankingReportProfit") + "\n" +
						    "			 </INPUT>\n" +
						    "            <BR>\n" +						            		
							"         </TD>\n" +
							"      </TR>\n" +
						    "   </TABLE>\n" +
						    "         </TD>\n" +
							
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
   // Validate is done by the HTML radio button
   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   function validateSortOrderByOption(container)
   {
      return true;
   }

   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   // initialize function for the status dates
   ///////////////////////////////////////////////////////////////////////////////////////////////////////
     
   function onLoadSortOrderByOption(container)
   {
	  var myContainer = parent.get(container, null);
    	
	  // If this is the first time set it to the default.	    	
	  myContainer = new Object();
	
	  myContainer.StatusChosen = 1;
			
	  with (document.forms[container]) {
		sortBy[0].checked = true;
		orderBy[0].checked = true;
		rankBy[0].checked = true;
	  }
	  parent.put(container, myContainer);
	  return;  	    
   }
   
   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   // Return the Status Chosen
   ///////////////////////////////////////////////////////////////////////////////////////////////////////  
  
   function returnSortByTSRTeamId(container) {
      return document.forms[container].sortBy[0].checked;
   }
   function returnSortByRevenue(container) {
      return document.forms[container].sortBy[1].checked;
   }
   function returnSortByProfit(container) {
      return document.forms[container].sortBy[2].checked;
   }

   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   // Return the Orderby Status Chosen
   ///////////////////////////////////////////////////////////////////////////////////////////////////////  
   function returnOrderByDesc(container) {
	return document.forms[container].orderBy[0].checked;
   }

   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   // Return the Rankby Status Chosen
   ///////////////////////////////////////////////////////////////////////////////////////////////////////  
   function returnRankByProfit(container) {
      return document.forms[container].rankBy[1].checked;
   }

</SCRIPT>
