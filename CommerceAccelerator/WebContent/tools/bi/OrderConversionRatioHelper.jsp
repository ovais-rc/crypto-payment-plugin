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


private String generateStatOption(String container, Hashtable biNLS)
{
   

   String result = 	"<FORM NAME=" + container + ">\n" +
                   			"   <TABLE border=0 bordercolor=red CELLPADDING=0 CELLSPACING=0 width=400>" + 
	                        "	 <TR>\n" +

							"         <TD ALIGN=left VALIGN=TOP>\n" +						    							
							"			<TABLE border=0 bordercolor=black CELLPADDING=0 CELLSPACING=0 width=200>" + 
						    "			 <TR HEIGHT=5>\n" +
							"			   <TD ALIGN=left VALIGN=TOP>\n" +
						    "            <INPUT TYPE=RADIO NAME=rbname VALUE=All>\n" +
								"			<label for= s1>" +
						    "               " + biNLS.get("orderConversionRatioCSRLogonIDSortBy") + "\n </label>" +
						    "			 </INPUT>\n" +
						    "            <BR>\n" +
                            "            <BR>\n" +
						    "            <INPUT TYPE=RADIO NAME=rbname VALUE=PayA>\n" +
								"			<label for= s2>" +
						    "               " + biNLS.get("orderConversionRatioCSRname") + "\n </label>" +
						    "			 </INPUT>\n" +
						    "            <BR>\n" +	
                            "            <BR>\n" +
						    "            <INPUT TYPE=RADIO NAME=rbname VALUE=PayA>\n" +
								"			<label for= s2>" +
						    "               " + biNLS.get("orderConversionRatiorate") + "\n </label>" +
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
						    "            <INPUT TYPE=RADIO  NAME=rbsort VALUE=All>\n" +
								"			<label for= ord1>" +
						    "               " + biNLS.get("descend") + "\n </label>" +
						    "			 </INPUT>\n" +
						    "            <BR>\n" +
							"            <BR>\n" +
						    "            <INPUT TYPE=RADIO NAME=rbsort VALUE=PayA>\n" +
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
   function validateStatOption(container)
   {
      return true;
   }

   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   // initialize function for the status dates
   ///////////////////////////////////////////////////////////////////////////////////////////////////////
     
  function onLoadStatOption(container)
   {

	   
	  var myContainer = parent.get(container, null);
    	
	  // If this is the first time set it to the default.	    	
      if (myContainer == null) {
			myContainer = new Object();
	
			myContainer.StatusChosen = 1;
			
			with (document.forms[container]) {
				rbname[0].checked = true;
				rbsort[0].checked = true;
			}
			parent.put(container, myContainer);
			return;  	    
      } else {
      		// If it is not the first time set it to the last selected.
			if(myContainer.StatusChosen == 4){
				document.forms[container].rbname[1].checked = true;
				document.forms[container].rbsort[1].checked = true;
			} 		
			 else if(myContainer.StatusChosen == 3){
				document.forms[container].rbname[1].checked = true;
				document.forms[container].rbsort[0].checked = true;
			} 
			 else if(myContainer.StatusChosen == 2){
				document.forms[container].rbname[0].checked = true;
				document.forms[container].rbsort[1].checked = true;
			} 
			 else {
				document.forms[container].rbname[0].checked = true;
				document.forms[container].rbsort[0].checked = true;
			}
			parent.put(container, myContainer);
      		return;
      }
   }
   
   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   // save function for the Staus selected
   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   function saveStatOption(container)
   {

	   
      myContainer = parent.get(container,null);
      if (myContainer == null) return;

      with (document.forms[container]) {
		  

			 if (rbname[1].checked){
	      	 	if(rbsort[1].checked)
	      	 		myContainer.StatusChosen = 4;
				 else
					myContainer.StatusChosen = 3;
	      	 }
			 else{
	      	 	if(rbsort[1].checked)
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
  
   function returnStatOptionCSRName(container) {
      return document.forms[container].rbname[1].checked;
   }
   function returnStatOptionCSRLogonID(container) {
      return document.forms[container].rbname[0].checked;
   }
   function returnStatOptionRate(container) {
      return document.forms[container].rbname[2].checked;
   }
   
   
 ///////////////////////////////////////////////////////////////////////////////////////////////////////
   // Return the Orderby Status Chosen
   ///////////////////////////////////////////////////////////////////////////////////////////////////////  
    function returnOrderbyDesc(container) {
      return document.forms[container].rbsort[0].checked;
   }

    function returnOrderbyAsc(container) {
      return document.forms[container].rbsort[1].checked;
   }
   
</SCRIPT>
