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

private String generateSortOrderByOption(String container, Hashtable reportsRB)
{
   

   String result = 	"<FORM NAME=" + container + ">" +
                   			"   <TABLE border=0 bordercolor=red CELLPADDING=0 CELLSPACING=0 width=400>" + 
	                        "	 <TR>" +

							"         <TD ALIGN=left VALIGN=TOP>" +						    							
							"			<TABLE border=0 bordercolor=black CELLPADDING=0 CELLSPACING=0 width=200>" + 
						    "			 <TR HEIGHT=5>" +
							"			   <TD ALIGN=left VALIGN=TOP>" +
						    "            <INPUT TYPE=RADIO NAME=sortBy VALUE=All>" +
						    "               " + reportsRB.get("orderItemId") + "" +
						    "			 </INPUT>" +
						    "            <BR>" +
                            "            <BR>" +
						    "            <INPUT TYPE=RADIO NAME=sortBy VALUE=PayA>" +
						    "               " + reportsRB.get("dateActivated") + "" +
						    "			 </INPUT>" +
						    "            <BR>" +	
                            "            <BR>" +
						    "            <INPUT TYPE=RADIO NAME=sortBy VALUE=PayA>" +
						    "               " + reportsRB.get("tsrPriceOverridesRateColumnTitle") + "" +
						    "			 </INPUT>" +
						    "            <BR>" +							    
						    "         </TD>" +
						    "      </TR>" +
						    "   </TABLE>" +
						    "         </TD>" +

							"         <TD>&nbsp;</TD>" +

	            			"         <TD ALIGN=left VALIGN=TOP>" +
							"			<TABLE border=0 bordercolor=black CELLPADDING=0 CELLSPACING=0 width=200>" + 
						    "			 <TR HEIGHT=5>" +
							"			   <TD ALIGN=left VALIGN=TOP>" +
						    "            <INPUT TYPE=RADIO  NAME=orderBy VALUE=All>" +
						    "               " + reportsRB.get("descend") + "" +
						    "			 </INPUT>" +
						    "            <BR>" +
							"            <BR>" +
						    "            <INPUT TYPE=RADIO NAME=orderBy VALUE=PayA>" +
						    "               " + reportsRB.get("ascend") + "" +
						    "			 </INPUT>" +
						    "            <BR>" +						            		
							"         </TD>" +
							"      </TR>" +
						    "   </TABLE>" +
						    "         </TD>" +
						    
							
							"      </TR>" +
							"   </TABLE>" +
						    " </FORM>";
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
      if (myContainer == null) {
			myContainer = new Object();
	
			myContainer.StatusChosen = 1;
			
			with (document.forms[container]) {
				sortBy[0].checked = true;
				orderBy[0].checked = true;
			}
			parent.put(container, myContainer);
			return;  	    
      } else {
      		// If it is not the first time set it to the last selected.
			if(myContainer.StatusChosen == 4){
				document.forms[container].sortBy[1].checked = true;
				document.forms[container].orderBy[1].checked = true;
			} 		
			 else if(myContainer.StatusChosen == 3){
				document.forms[container].sortBy[1].checked = true;
				document.forms[container].orderBy[0].checked = true;
			} 
			 else if(myContainer.StatusChosen == 2){
				document.forms[container].sortBy[0].checked = true;
				document.forms[container].orderBy[1].checked = true;
			} 
			 else if(myContainer.StatusChosen == 1){
				document.forms[container].sortBy[0].checked = true;
				document.forms[container].orderBy[0].checked = true;
			} else if(myContainer.StatusChosen == 5){
				document.forms[container].sortBy[2].checked = true;
				document.forms[container].orderBy[0].checked = true;
			} else{
				document.forms[container].sortBy[2].checked = true;
				document.forms[container].orderBy[1].checked = true;
			} 
			parent.put(container, myContainer);
      		return;
      }
   }
   
   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   // save function for the Staus selected
   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   function saveSortOrderByOption(container)
   {

	   
      myContainer = parent.get(container,null);
      if (myContainer == null) return;

      with (document.forms[container]) {
		  
	    	 if (sortBy[1].checked){
	      	 	if(orderBy[1].checked)
	      	 		myContainer.StatusChosen = 4;
				 else
					myContainer.StatusChosen = 3;
	      	 }
			 else if(sortBy[0].checked){
	      	 	if(orderBy[1].checked)
	      	 		myContainer.StatusChosen = 2;
				 else
					myContainer.StatusChosen = 1;
	      	 }
	      	 else{
	      	 	if(orderBy[1].checked)
	      	 		myContainer.StatusChosen = 6;
				 else
					myContainer.StatusChosen = 5;	      	 
	      	 }
      }
      parent.put(container, myContainer);
   }

   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   // Return the Status Chosen
   ///////////////////////////////////////////////////////////////////////////////////////////////////////  
  
   function returnSortByOptionOrder(container) {
      return document.forms[container].sortBy[0].checked;
   }
   function returnSortByOptionTransDate(container) {
      return document.forms[container].sortBy[1].checked;
   }
   function returnSortByOptionAdjPer(container) {
      return document.forms[container].sortBy[2].checked;
   }      

 ///////////////////////////////////////////////////////////////////////////////////////////////////////
   // Return the Orderby Status Chosen
   ///////////////////////////////////////////////////////////////////////////////////////////////////////  
    function returnOrderbyDesc(container) {
      return document.forms[container].orderBy[0].checked;
   }

    function returnOrderbyAsc(container) {
      return document.forms[container].orderBy[1].checked;
   }
   
</SCRIPT>
