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

<%!

private String generateSortOrderByOption(String container, Hashtable biNLS)
{
   

   String result = 	"<FORM NAME=" + container + ">\n" +
                   			"   <TABLE border=0 bordercolor=red CELLPADDING=0 CELLSPACING=0 width=500>" + 
	                        "	 <TR>\n" +

							"         <TD ALIGN=left VALIGN=TOP>\n" +						    							
							"			<TABLE border=0 bordercolor=black CELLPADDING=0 CELLSPACING=0 width=300>" + 
						    "			 <TR HEIGHT=5>\n" +
							"			   <TD ALIGN=left VALIGN=TOP>\n" +
						    "            <INPUT TYPE=RADIO NAME=sortBy VALUE=All>\n" +
								"			<label for= s1>" +
						    "               " + biNLS.get("orderamountwithpromotion") + "\n </label>" +
						    "			 </INPUT>\n" +
						    "            <BR>\n" +
                            "            <BR>\n" +
						    "            <INPUT TYPE=RADIO NAME=sortBy VALUE=PayA>\n" +
								"			<label for= s2>" +
						    "               " + biNLS.get("promotionname") + "\n </label>" +
						    "			 </INPUT>\n" +
						    "            <BR>\n" +	
                            "            <BR>\n" +
						    "            <INPUT TYPE=RADIO NAME=sortBy VALUE=PayA>\n" +
								"			<label for= s3>" +
						    "               " + biNLS.get("nooforders") + "\n </label>" +
						    "			 </INPUT>\n" +
							"            <BR>\n" +
                            "            <BR>\n" +
						    "            <INPUT TYPE=RADIO NAME=sortBy VALUE=PayA>\n" +
								"			<label for= s4>" +
						    "               " + biNLS.get("orderamountwithoutpromotion") + "\n </label>" +
						    "			 </INPUT>\n" +
						    "            <BR>\n" +	
                            "            <BR>\n" +
						    "            <INPUT TYPE=RADIO NAME=sortBy VALUE=PayA>\n" +
								"			<label for= s5>" +
						    "               " + biNLS.get("ordersizewithpromotion") + "\n </label>" +
						    "			 </INPUT>\n" +
						    "            <BR>\n" +	
                            "            <BR>\n" +
						    "            <INPUT TYPE=RADIO NAME=sortBy VALUE=PayA>\n" +
								"			<label for= s6>" +
						    "               " + biNLS.get("ordersizewithoutpromotion") + "\n </label>" +
						    "			 </INPUT>\n" +
						    "            <BR>\n" +	
                            "            <BR>\n" +
						    "            <INPUT TYPE=RADIO NAME=sortBy VALUE=PayA>\n" +
								"			<label for= s7>" +
						    "               " + biNLS.get("adjustAmount") + "\n </label>" +
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
								"			<label for= ord1>" +
						    "               " + biNLS.get("descend") + "\n </label>" +
						    "			 </INPUT>\n" +
						    "            <BR>\n" +
							"            <BR>\n" +
						    "            <INPUT TYPE=RADIO NAME=orderBy VALUE=PayA>\n" +
								"			<label for= ord2>" +
						    "               " + biNLS.get("ascend") + "\n </label>" +
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
			if(myContainer.StatusChosen == 14){
				document.forms[container].sortBy[6].checked = true;
				document.forms[container].orderBy[1].checked = true;
			} 		
			 else if(myContainer.StatusChosen == 13){
				document.forms[container].sortBy[6].checked = true;
				document.forms[container].orderBy[0].checked = true;
			} 
			else if(myContainer.StatusChosen == 12){
				document.forms[container].sortBy[5].checked = true;
				document.forms[container].orderBy[1].checked = true;
			} 
			else if(myContainer.StatusChosen == 11){
				document.forms[container].sortBy[5].checked = true;
				document.forms[container].orderBy[0].checked = true;
			} 
			else if(myContainer.StatusChosen == 10){
				document.forms[container].sortBy[4].checked = true;
				document.forms[container].orderBy[1].checked = true;
			} 
			else if(myContainer.StatusChosen == 9){
				document.forms[container].sortBy[4].checked = true;
				document.forms[container].orderBy[0].checked = true;
			} 
			else if(myContainer.StatusChosen == 8){
				document.forms[container].sortBy[3].checked = true;
				document.forms[container].orderBy[1].checked = true;
			} 
			else if(myContainer.StatusChosen == 7){
				document.forms[container].sortBy[3].checked = true;
				document.forms[container].orderBy[0].checked = true;
			} 
			else if(myContainer.StatusChosen == 6){
				document.forms[container].sortBy[2].checked = true;
				document.forms[container].orderBy[1].checked = true;
			} 
			else if(myContainer.StatusChosen == 5){
				document.forms[container].sortBy[2].checked = true;
				document.forms[container].orderBy[0].checked = true;
			} 
			 else if(myContainer.StatusChosen == 4){
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
			 else {
				document.forms[container].sortBy[0].checked = true;
				document.forms[container].orderBy[0].checked = true;
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
		  
	    	 if (sortBy[6].checked){
				 if(orderBy[1].checked)
	      	 		myContainer.StatusChosen = 14;
				 else
					myContainer.StatusChosen = 13;
	      	 }
			 else if (sortBy[5].checked){
	      	 	if(orderBy[1].checked)
	      	 		myContainer.StatusChosen = 12;
				 else
					myContainer.StatusChosen = 11;
	      	 }
			 else if (sortBy[4].checked){
	      	 	if(orderBy[1].checked)
	      	 		myContainer.StatusChosen = 10;
				 else
					myContainer.StatusChosen = 9;
	      	 }
			 else if (sortBy[3].checked){
	      	 	if(orderBy[1].checked)
	      	 		myContainer.StatusChosen = 8;
				 else
					myContainer.StatusChosen = 7;
	      	 }
			 else if (sortBy[2].checked){
	      	 	if(orderBy[1].checked)
	      	 		myContainer.StatusChosen = 6;
				 else
					myContainer.StatusChosen = 5;
	      	 }
			 else if (sortBy[1].checked){
	      	 	if(orderBy[1].checked)
	      	 		myContainer.StatusChosen = 4;
				 else
					myContainer.StatusChosen = 3;
	      	 }
			 else{
	      	 	if(orderBy[1].checked)
	      	 		myContainer.StatusChosen = 2;
				 else
					myContainer.StatusChosen = 1;
	      	 }
      }
      parent.put(container, myContainer);
   }

   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   // Return the Status Chosen
   ///////////////////////////////////////////////////////////////////////////////////////////////////////  
  
   function returnSortByOptionOrderAmount(container) {
      return document.forms[container].sortBy[0].checked;
   }
   function returnSortByOptionPromoName(container) {
      return document.forms[container].sortBy[1].checked;
   }
   function returnSortByOptionNumOrders(container) {
      return document.forms[container].sortBy[2].checked;
   }
   function returnSortByOptionOrderAmountWithoutPromo(container) {
      return document.forms[container].sortBy[3].checked;
   }
   function returnSortByOptionOrderSize(container) {
      return document.forms[container].sortBy[4].checked;
   }
   function returnSortByOptionOrderSizeWithoutPromo(container) {
      return document.forms[container].sortBy[5].checked;
   }
   function returnSortByOptionAdjustment(container) {
      return document.forms[container].sortBy[6].checked;
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
