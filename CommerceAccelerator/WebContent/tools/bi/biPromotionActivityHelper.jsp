<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
<!-- ========================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (c) Copyright IBM Corp. 2001, 2002

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 ===========================================================================-->

<%@page import="java.util.*" %>
<%@page import="com.ibm.commerce.command.CommandContext"%>
<%@page import="com.ibm.commerce.server.ECConstants"%>
<%@include file="/tools/reporting/ORReportOutputHelper.jsp" %>

<%!

/// get first name and last name and user ID...
private String generateSpecificHeaderInformation(String reportPrefix, Hashtable biNLS, Locale locale)
{
	StringBuffer buff = new StringBuffer("");
	Hashtable aReportDataBeanEnv = aReportDataBean.getEnv();
	
	String PromotionType			=	  (String) aReportDataBeanEnv.get("promotiongrp");
   
	if(PromotionType != null)
	   PromotionType = UIUtil.toHTML(PromotionType); 

	buff.append("   <DIV ID=pageBody STYLE=\"display: block; margin-left: 20\">\n");
	buff.append("<b>"+biNLS.get(reportPrefix + "ReportTypeSelectionTitle")+"</b>" +" ");
	if(PromotionType.equals("OrderLevelPromotion"))
		buff.append(biNLS.get("orderLevel"));
	else if (PromotionType.equals("ProductLevelPromotion"))
		buff.append(biNLS.get("productLevel"));
	else if (PromotionType.equals("ShippingPromotion"))
		buff.append(biNLS.get("shippingLevel"));
	else
		buff.append(biNLS.get("allPromotions"));

	buff.append("   </DIV><BR>\n\n");
	return buff.toString();
}

private String generatePromotionActivity(String container, Hashtable biNLS)
{
   String result =        "<FORM NAME=" + container + ">\n" +
                                        "   <TABLE border=0 bordercolor=red CELLPADDING=0 CELLSPACING=0 width=400>" + 
                               "        <TR>\n" +

                                                 "         <TD ALIGN=left VALIGN=TOP>\n" +                                                                                               
                                                 "                     <TABLE border=0 bordercolor=black CELLPADDING=0 CELLSPACING=0 width=200>" + 
                                              "                      <TR HEIGHT=5>\n" +
                                                 "                        <TD ALIGN=left VALIGN=TOP>\n" +
                                              "            <INPUT TYPE=RADIO NAME=rbsortby VALUE=All>\n" +
                                              "               " + biNLS.get("promotionname") + "\n" +
                                              "                      </INPUT>\n" +
                                              "            <BR>\n" +
                            "            <BR>\n" +
                                              "            <INPUT TYPE=RADIO NAME=rbsortby VALUE=PayA>\n" +
                                              "               " + biNLS.get("promotioncode") + "\n" +
                                              "                      </INPUT>\n" +
                                              "            <BR>\n" +       
                            "            <BR>\n" +
                                              "            <INPUT TYPE=RADIO NAME=rbsortby VALUE=PayA>\n" +
                                              "               " + biNLS.get("numsDisplayed") + "\n" +
                                              "                      </INPUT>\n" +
                                                 "            <BR>\n" +       
                                                 "                      <BR>\n" +
                                              "            <INPUT TYPE=RADIO NAME=rbsortby VALUE=PayA>\n" +
                                              "               " + biNLS.get("numsClicked") + "\n" +
                                              "                      </INPUT>\n" +
                                                 "            <BR>\n" +
                                                 "                      <BR>\n" +
                                              "            <INPUT TYPE=RADIO NAME=rbsortby VALUE=PayA>\n" +
                                              "               " + biNLS.get("numsOrdered") + "\n" +
                                              "                      </INPUT>\n" +
                                                 "            <BR>\n" +       
                                                 "                      <BR>\n" +
                                              "            <INPUT TYPE=RADIO NAME=rbsortby VALUE=PayA>\n" +
                                              "               " + biNLS.get("numsAbandoned") + "\n" +
                                              "                      </INPUT>\n" +
                                                 "            <BR>\n" +       
                                                 "                      <BR>\n" +
                                              "            <INPUT TYPE=RADIO NAME=rbsortby VALUE=PayA>\n" +
                                              "               " + biNLS.get("convertionRate") + "\n" +
                                              "                      </INPUT>\n" +
                                                 "            <BR>\n" +       
                                                 "                      <BR>\n" +
                                              "            <INPUT TYPE=RADIO NAME=rbsortby VALUE=PayA>\n" +
                                              "               " + biNLS.get("abandonedRate") + "\n" +
                                              "                      </INPUT>\n" +
                                                 "            <BR>\n" +
                                              "         </TD>\n" +
                                              "      </TR>\n" +
                                              "   </TABLE>\n" +
                                              "         </TD>\n" +

                                                 "         <TD>&nbsp;</TD>\n" +

                                        "         <TD ALIGN=left VALIGN=TOP>\n" +
                                                 "                     <TABLE border=0 bordercolor=black CELLPADDING=0 CELLSPACING=0 width=200>" + 
                                              "                      <TR HEIGHT=5>\n" +
                                                 "                        <TD ALIGN=left VALIGN=TOP>\n" +
                                              "            <INPUT TYPE=RADIO  NAME=rborderby VALUE=All>\n" +
                                              "               " + biNLS.get("descend") + "\n" +
                                              "                      </INPUT>\n" +
                                              "            <BR>\n" +
                                                 "            <BR>\n" +
                                              "            <INPUT TYPE=RADIO NAME=rborderby VALUE=PayA>\n" +
                                              "               " + biNLS.get("ascend") + "\n" +
                                              "                      </INPUT>\n" +
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
     
     function onLoadPromotionActivity(container)
   {

          
         var myContainer = parent.get(container, null);
           
         // If this is the first time set it to the default.                  
      if (myContainer == null) {
                     myContainer = new Object();
       
                     myContainer.StatusChosen = 1;
                     
                     with (document.forms[container]) {
                            rbsortby[0].checked = true;
                            rborderby[0].checked = true;
                     }
                     parent.put(container, myContainer);
                     return;             
      } else {
                    // If it is not the first time set it to the last selected.
                     if(myContainer.StatusChosen == 16){
                            document.forms[container].rbsortby[7].checked = true;
                            document.forms[container].rborderby[1].checked = true;
                     }               
                      else if(myContainer.StatusChosen == 15){
                            document.forms[container].rbsortby[7].checked = true;
                            document.forms[container].rborderby[0].checked = true;
                     } 
                     else if(myContainer.StatusChosen == 14){
                            document.forms[container].rbsortby[6].checked = true;
                            document.forms[container].rborderby[1].checked = true;
                     }               
                      else if(myContainer.StatusChosen == 13){
                            document.forms[container].rbsortby[6].checked = true;
                            document.forms[container].rborderby[0].checked = true;
                     } 

                     else if(myContainer.StatusChosen == 12){
                            document.forms[container].rbsortby[5].checked = true;
                            document.forms[container].rborderby[1].checked = true;
                     }               
                      else if(myContainer.StatusChosen == 11){
                            document.forms[container].rbsortby[5].checked = true;
                            document.forms[container].rborderby[0].checked = true;
                     } 

                     else if(myContainer.StatusChosen == 10){
                            document.forms[container].rbsortby[4].checked = true;
                            document.forms[container].rborderby[1].checked = true;
                     }               
                      else if(myContainer.StatusChosen == 9){
                            document.forms[container].rbsortby[4].checked = true;
                            document.forms[container].rborderby[0].checked = true;
                     } 
                     else if(myContainer.StatusChosen == 8){
                            document.forms[container].rbsortby[3].checked = true;
                            document.forms[container].rborderby[1].checked = true;
                     }               
                      else if(myContainer.StatusChosen == 7){
                            document.forms[container].rbsortby[3].checked = true;
                            document.forms[container].rborderby[0].checked = true;
                     } 
                     else if(myContainer.StatusChosen == 6){
                            document.forms[container].rbsortby[2].checked = true;
                            document.forms[container].rborderby[1].checked = true;
                     }               
                      else if(myContainer.StatusChosen == 5){
                            document.forms[container].rbsortby[2].checked = true;
                            document.forms[container].rborderby[0].checked = true;
                     } 
                      else if(myContainer.StatusChosen == 4){
                            document.forms[container].rbsortby[1].checked = true;
                            document.forms[container].rborderby[1].checked = true;
                     }               
                      else if(myContainer.StatusChosen == 3){
                            document.forms[container].rbsortby[1].checked = true;
                            document.forms[container].rborderby[0].checked = true;
                     } 
                      else if(myContainer.StatusChosen == 2){
                            document.forms[container].rbsortby[0].checked = true;
                            document.forms[container].rborderby[1].checked = true;
                     } 
                      else {
                            document.forms[container].rbsortby[0].checked = true;
                            document.forms[container].rborderby[0].checked = true;
                     }
                     parent.put(container, myContainer);
                    return;
      }
   }
   
   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   // save function for the Staus selected
   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   function savePromotionActivity(container)
   {

          
      myContainer = parent.get(container,null);
      if (myContainer == null) return;

      with (document.forms[container]) {
            if (rbsortby[7].checked){
                             if(rborderby[1].checked)
                                   myContainer.StatusChosen = 16;
                             else
                                   myContainer.StatusChosen = 15;
                     }
                if (rbsortby[6].checked){
                             if(rborderby[1].checked)
                                   myContainer.StatusChosen = 14;
                             else
                                   myContainer.StatusChosen = 13;
                     }
                   if (rbsortby[5].checked){
                             if(rborderby[1].checked)
                                   myContainer.StatusChosen = 12;
                             else
                                   myContainer.StatusChosen = 11;
                     }
                      if (rbsortby[4].checked){
                             if(rborderby[1].checked)
                                   myContainer.StatusChosen = 10;
                             else
                                   myContainer.StatusChosen = 9;
                     }       
                   if (rbsortby[3].checked){
                             if(rborderby[1].checked)
                                   myContainer.StatusChosen = 8;
                             else
                                   myContainer.StatusChosen = 7;
                     }
                   if (rbsortby[2].checked){
                             if(rborderby[1].checked)
                                   myContainer.StatusChosen = 6;
                             else
                                   myContainer.StatusChosen = 5;
                     }
                      else if (rbsortby[1].checked){
                            if(rborderby[1].checked)
                                   myContainer.StatusChosen = 4;
                             else
                                   myContainer.StatusChosen = 3;
                     }
                      else{
                            if(rborderby[1].checked)
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
  
   function returnPromotionName(container) {
      return document.forms[container].rbsortby[0].checked;
   }
   function returnPromotionCode(container) {
      return document.forms[container].rbsortby[1].checked;
   }
   function returnNumsDisplayed(container) {
      return document.forms[container].rbsortby[2].checked;
   }
   function returnNumsClicked(container) {
      return document.forms[container].rbsortby[3].checked;
   }
   function returnNumsOrdered(container) {
      return document.forms[container].rbsortby[4].checked;
   }
   function returnNumsAbandoned(container) {
      return document.forms[container].rbsortby[5].checked;
   }
   function returnConvertionRate(container) {
      return document.forms[container].rbsortby[6].checked;
   }
   function returnAbandonedRate(container) {
      return document.forms[container].rbsortby[7].checked;
   }
 ///////////////////////////////////////////////////////////////////////////////////////////////////////
   // Return the Orderby Status Chosen
///////////////////////////////////////////////////////////////////////////////////////////////////////  

    function returnOrderbyDesc(container) {
      return document.forms[container].rborderby[0].checked;
   }

    function returnOrderbyAsc(container) {
      return document.forms[container].rborderby[1].checked;
   }
   
</SCRIPT>

