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
  ReportContractHelper.jsp
 ===========================================================================-->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
<%@page import="java.util.*" %>
<%@page import="java.lang.*" %>
<%@page import="com.ibm.commerce.command.CommandContext"%>
<%@page import="com.ibm.commerce.server.ECConstants"%>
<%@page import="com.ibm.commerce.beans.DataBeanManager" %>
<%@page import="com.ibm.commerce.tools.contract.beans.AccountListDataBean"%>
<%@page import="com.ibm.commerce.tools.contract.beans.AccountDataBean"%>
<%@page import="com.ibm.commerce.tools.contract.beans.ContractListDataBean"%>
<%@page import="com.ibm.commerce.tools.contract.beans.ContractDataBean"%>

<%
   CommandContext ContractHelperCC = (CommandContext) request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
   Hashtable      ContractHelperRB = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("reporting.reportStrings", ContractHelperCC.getLocale());
%>


<%!
private String generateContracts(String container, Hashtable reportsRB, String title)
{
   int dynamicTagCounter = 0;
   String resultTitle = "";

   if (title != null) resultTitle = "   <tr>\n" +
                                    "      <td align=left valign=center height=32 colspan=5 id=\"ReportContractHelper_DynamicTableCell_"+ dynamicTagCounter +"_1\">\n" + reportsRB.get(title) + "</td>\n" +
                                    "   </tr>\n";

   String result =
      "<form name=\"" + container + "\" id=\"" + container + "\">\n" +
      "   <table cellpadding=0 cellspacing=0>\n" + resultTitle +
      "      <tr>\n" +
      "         <td align=left valign=top id=\"ReportContractHelper_DynamicTableCell_"+ dynamicTagCounter +"_2\">\n" +
      "            <select id=ReportContractHelper_FormInput_ContractHelperSelectBox_In_" + container + "_1  name=ContractHelperSelectBox tabindex=1 multiple width=80 size=4>\n" +
      "            </select>\n" +
      "         </td>\n" +
      "      </tr>\n" +
      "   </table>\n" +
      "</form>\n";

  dynamicTagCounter++;
  return result;
 }
%>

<script>

   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   // Load any data from the parent (if it exists)
   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   function onLoadContracts(container)
   {
      var myContainer = parent.get(container, null);

     ////////////////////////////////////////////////////////////////////////////////////////////////////
      // If false then this is the first time to the page and we need to generate the data bean
      ////////////////////////////////////////////////////////////////////////////////////////////////////
      if (myContainer == null) initializeContract(container);
      else                     retrieveContract(container);



      return;
   }


  /////////////////////////////////////////////////////////////////////////////////////////////////
   // Retrieve the containers available contracts
   /////////////////////////////////////////////////////////////////////////////////////////////////
   function retrieveContract(container)
   {
      var myContainer = parent.get(container, null);
      if (myContainer == null) return;

      /////////////////////////////////////////////////////////////////////////////////////////////////
      // Retrieve the saved available Contracts
      /////////////////////////////////////////////////////////////////////////////////////////////////
      var Contracts = myContainer.ContractHelperSelectBox;
      if (Contracts != null ) {
         for (var i=0; i<Contracts.length; i++) {
            document.forms[container].ContractHelperSelectBox.options[i] = new Option(Contracts[i].text,Contracts[i].value, false, false);
         }
      }
   }

  ///////////////////////////////////////////////////////////////////////////////////////////////////////
   // Initialize the contract center data from the data bean
   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   function initializeContract(container)
   {
      var myContainer = new Object();

      putColl(container, "sampleContract1", "1");
      putColl(container, "sampleContract2", "2");

      parent.put(container, myContainer);
   }

   /////////////////////////////////////////////////////////////////////////////////////////////////
   // Puts a new option to the available contracts
   /////////////////////////////////////////////////////////////////////////////////////////////////
   function putColl(container, text, value)
   {
      with (document.forms[container]) {
         var index = ContractHelperSelectBox.length;
         ContractHelperSelectBox.options[index] = new Option(text, value, false, false);
      }
   }



   /////////////////////////////////////////////////////////////////////////////////////////////////
   // Save the contract data
   /////////////////////////////////////////////////////////////////////////////////////////////////
   function saveSelectContracts(container)
   {
      saveColl(container);
   }


   /////////////////////////////////////////////////////////////////////////////////////////////////
   // Save the containers available contracts
   /////////////////////////////////////////////////////////////////////////////////////////////////
   function saveColl(container)
   {
      var myContainer = parent.get(container, null);
      if (myContainer == null) return;

      /////////////////////////////////////////////////////////////////////////////////////////////////
      // Retrieve the saved selected contracts
      /////////////////////////////////////////////////////////////////////////////////////////////////
      var Contracts = new Array();
      with (document.forms[container]) {
         for (var i=0; i<ContractHelperSelectBox.length; i++) {
            Contracts[i] = new Object();
            Contracts[i].text  = ContractHelperSelectBox.options[i].text;
            Contracts[i].value = ContractHelperSelectBox.options[i].value;
         }
      }

      myContainer.ContractHelperSelectBox = Contracts;
      parent.put(container,myContainer);
   }



   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   // Return an array of selected contract ids
   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   function returnSelectContractIDs(container)
   {
     return returnSelectedValue(container);
   }

   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   // Return an array of selected contract names
   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   function returnSelectContractNames(container)
   {
      return returnSelectedText(container);
   }

   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   // function which returns the array of selected contract Ids
   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   function returnSelectedValue(container)
   {
      var selectedValue = new Array();
      var j=0;
      with (document.forms[container]){
         for (var i=0; i<ContractHelperSelectBox.length; i++) {
            if (ContractHelperSelectBox.options[i].selected) {
                selectedValue[j] = ContractHelperSelectBox.options[i].value;
                j++;
            }
         }
      }
      return selectedValue;
   }

   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   // function which returns the array of selected contract name
   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   function returnSelectedText(container)
   {
      var selectedValue = new Array();
      var j=0;
      with (document.forms[container]){
         for (var i=0; i<ContractHelperSelectBox.length; i++) {
            if (ContractHelperSelectBox.options[i].selected) {
                selectedValue[j] = ContractHelperSelectBox.options[i].text;
                j++;
            }
         }
      }
      return selectedValue;
   }

   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   // Return the number of selected contracts
   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   function getNumberOfContract(container)
   {
      var j=0;
      with (document.forms[container]){
         for (var i=0; i<ContractHelperSelectBox.length; i++) {
            if (ContractHelperSelectBox.options[i].selected)  j++;
         }
      }
       return j;
   }


   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   // Validation function to ensure that a contract has been selected
   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   function validateSelectContracts(container)
   {

      if (getNumberOfContract(container) == 0) {
         alertDialog("<%=ContractHelperRB.get("ContractHelperNoSelection")%>");
         return false;
      }

      if (getNumberOfContract(container) > 1) {
         alertDialog("<%=ContractHelperRB.get("ContractHelperNoMoreThanOneSelection")%>");
         return false;
      }
      return true;
   }


   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   // Validation function to ensure that multiple contracts has been selected
   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   function areMultipleContracts(container)
   {
      if (getNumberOfContract(container) < 2) {
         return false;
      }
      return true;
   }




</script>
