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
private String generateStatOption(String container, Hashtable reportsRB, String title)
{
   String resulttitle = "";

   if (title != null)  { resulttitle =
                                     "    <TR>\n" +
                                     "       <TD COLSPAN=9 ALIGN=LEFT VALIGN=CENTER HEIGHT=32>" + reportsRB.get(title) + "</TD>\n" +
                                     "    </TR>\n";
			     }

   String result = 	"<FORM NAME=" + container + ">\n" +
                   			"   <TABLE CELLPADDING=0 CELLSPACING=0>" + resulttitle +
						    "      <TR HEIGHT=5>\n" +
						    "         <TD>&nbsp;</TD>\n" +
						    "      </TR>\n" +
						    "      <TR>\n" +
						    "         <TD ALIGN=LEFT VALIGN=TOP>\n" +
						    "            <BR>\n" +
						    "            <INPUT TYPE=RADIO NAME=MyOrderStatusOptions VALUE=All>\n" +
						    "               " + reportsRB.get("OrderStatHelperStatusAll") + "\n" +
						    "			 </INPUT>\n" +
						    "            <BR>\n" +
						    "            <INPUT TYPE=RADIO NAME=MyOrderStatusOptions VALUE=PayA>\n" +
						    "               " + reportsRB.get("OrderStatHelperStatusPayA") + "\n" +
						    "			 </INPUT>\n" +
						    "            <BR>\n" +
						    "            <INPUT TYPE=RADIO NAME=MyOrderStatusOptions VALUE=Pending>\n" +
						    "               " + reportsRB.get("OrderStatHelperStatusPending") + "\n" +
						    "			 </INPUT>\n" +
						    "            <BR>\n" +
						    "            <INPUT TYPE=RADIO NAME=MyOrderStatusOptions VALUE=LowInventory>\n" +
						    "               " + reportsRB.get("OrderStatHelperStatusLowInventory") + "\n" +
						    "			 </INPUT>\n" +
						    "            <BR>\n" +
						    "            <INPUT TYPE=RADIO NAME=MyOrderStatusOptions VALUE=Shipped>\n" +
						    "               " + reportsRB.get("OrderStatHelperStatusShipped") + "\n" +
						    "			 </INPUT>\n" +
						    "            <BR>\n" +
						    "            <INPUT TYPE=RADIO NAME=MyOrderStatusOptions VALUE=Canceled>\n" +
						    "               " + reportsRB.get("OrderStatHelperStatusCanceled") + "\n" +
						    "			 </INPUT>\n" +
						    "            <BR>\n" +
						    "            <INPUT TYPE=RADIO NAME=MyOrderStatusOptions VALUE=Backordered>\n" +
						    "               " + reportsRB.get("OrderStatHelperStatusBackordered") + "\n" +
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
				MyOrderStatusOptions[0].checked = true;
			}
			parent.put(container, myContainer);
			return;  	    
      } else {
      		// If it is not the first time set it to the last selected.		
			if(myContainer.StatusChosen == 7){
				document.forms[container].MyOrderStatusOptions[6].checked = true;
			} else if(myContainer.StatusChosen == 2){
				document.forms[container].MyOrderStatusOptions[1].checked = true;
			} else if(myContainer.StatusChosen == 3){
				document.forms[container].MyOrderStatusOptions[2].checked = true;
			} else if(myContainer.StatusChosen == 4){
				document.forms[container].MyOrderStatusOptions[3].checked = true;
			} else if(myContainer.StatusChosen == 5){
				document.forms[container].MyOrderStatusOptions[4].checked = true;
			} else if(myContainer.StatusChosen == 6){
				document.forms[container].MyOrderStatusOptions[5].checked = true;
			} else {
				document.forms[container].MyOrderStatusOptions[0].checked = true;
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
	      	 if(MyOrderStatusOptions[6].checked){
	      	 	myContainer.StatusChosen = 7;
	      	 } else if (MyOrderStatusOptions[1].checked){
	      	 	myContainer.StatusChosen = 2;
	      	 } else if (MyOrderStatusOptions[2].checked){
	      	 	myContainer.StatusChosen = 3;
	      	 } else if (MyOrderStatusOptions[3].checked){
	      	 	myContainer.StatusChosen = 4;
	      	 } else if (MyOrderStatusOptions[4].checked){
	      	 	myContainer.StatusChosen = 5;
	      	 } else if (MyOrderStatusOptions[5].checked){
	      	 	myContainer.StatusChosen = 6;
	      	 } else {
	      	 	myContainer.StatusChosen = 1;
	      	 } 	 
      }
      parent.put(container, myContainer);
   }

   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   // Return the Status Chosen
   ///////////////////////////////////////////////////////////////////////////////////////////////////////  
   function returnStatOptionAll(container) {
      return document.forms[container].MyOrderStatusOptions[0].checked;
   }
   function returnStatOptionPayA(container) {
      return document.forms[container].MyOrderStatusOptions[1].checked;
   }
   function returnStatOptionPending(container) {
      return document.forms[container].MyOrderStatusOptions[2].checked;
   }
   function returnStatOptionLowInventory(container) {
      return document.forms[container].MyOrderStatusOptions[3].checked;
   }
   function returnStatOptionShipped(container) {
      return document.forms[container].MyOrderStatusOptions[4].checked;
   }
    function returnStatOptionCanceled(container) {
      return document.forms[container].MyOrderStatusOptions[5].checked;
   }
   function returnStatOptionBackordered(container) {
      return document.forms[container].MyOrderStatusOptions[6].checked;
   }
</SCRIPT>
