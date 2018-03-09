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
  ReportAccountHelper.jsp
 ===========================================================================-->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
<%@page import="java.util.*" %>
<%@page import="com.ibm.commerce.command.CommandContext"%>
<%@page import="com.ibm.commerce.server.ECConstants"%>
<%@page import="com.ibm.commerce.beans.DataBeanManager" %>
<%@page import="com.ibm.commerce.tools.contract.beans.AccountListDataBean"%>
<%@page import="com.ibm.commerce.tools.contract.beans.AccountDataBean"%>


<%
   CommandContext AccountHelperCC = (CommandContext) request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
   Hashtable      AccountHelperRB = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("reporting.reportStrings", AccountHelperCC.getLocale());
%>


<%!
private String generateAccounts(String container, Hashtable reportsRB, String title)
{
   String resultTitle = "";
   int dynamicTagCounter = 0;   

   if (title != null) resultTitle = "   <tr>\n" +
                                    "      <td align=left valign=center height=32 colspan=5 id=\"ReportAccountHelper_DynamicTableCell_"+ dynamicTagCounter +"_1\">\n" + reportsRB.get(title) + "</td>\n" +
                                    "   </tr>\n";

   String result =
      "<form name=\"" + container + "\" id=\"" + container + "\">\n" +
      "   <table cellpadding=0 cellspacing=0>\n" + resultTitle +
      "      <tr>\n" +
      "         <td align=left valign=top id=\"ReportAccountHelper_DynamicTableCell_"+ dynamicTagCounter +"_2\">\n" +
      "            <select id=ReportAccountHelper_FormImput_AccountHelperSelectBox_In_" + container + "_1  name=AccountHelperSelectBox tabindex=1 multiple width=80 size=4>\n" +
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
   function onLoadAccounts(container)
   {
      var myContainer = parent.get(container, null);

     ////////////////////////////////////////////////////////////////////////////////////////////////////
      // If false then this is the first time to the page and we need to generate the data bean
      ////////////////////////////////////////////////////////////////////////////////////////////////////
      if (myContainer == null) initializeAccount(container);
      else                     retrieveAccount(container);



      return;
   }


  /////////////////////////////////////////////////////////////////////////////////////////////////
   // Retrieve the containers available accounts
   /////////////////////////////////////////////////////////////////////////////////////////////////
   function retrieveAccount(container)
   {
      var myContainer = parent.get(container, null);
      if (myContainer == null) return;

      /////////////////////////////////////////////////////////////////////////////////////////////////
      // Retrieve the saved available Accounts
      /////////////////////////////////////////////////////////////////////////////////////////////////
      var Accounts = myContainer.AccountHelperSelectBox;
      if (Accounts != null ) {
         for (var i=0; i<Accounts.length; i++) {
            document.forms[container].AccountHelperSelectBox.options[i] = new Option(Accounts[i].text,Accounts[i].value, false, false);
         }
      }
   }

  ///////////////////////////////////////////////////////////////////////////////////////////////////////
   // Initialize the account data from the data bean
   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   function initializeAccount(container)
   {
      var myContainer = new Object();

      putColl(container, "sampleAccount1", "1");
      putColl(container, "sampleAccount2", "2");

      parent.put(container, myContainer);
   }

   /////////////////////////////////////////////////////////////////////////////////////////////////
   // Puts a new option to the available accounts
   /////////////////////////////////////////////////////////////////////////////////////////////////
   function putColl(container, text, value)
   {
        with (document.forms[container]) {
         var index = AccountHelperSelectBox.length;
         AccountHelperSelectBox.options[index] = new Option(text, value, false, false);
      }
   }



   /////////////////////////////////////////////////////////////////////////////////////////////////
   // Save the account data
   /////////////////////////////////////////////////////////////////////////////////////////////////
   function saveSelectAccounts(container)
   {
      saveColl(container);
   }


   /////////////////////////////////////////////////////////////////////////////////////////////////
   // Save the containers available accounts
   /////////////////////////////////////////////////////////////////////////////////////////////////
   function saveColl(container)
   {
      var myContainer = parent.get(container, null);
      if (myContainer == null) return;

      /////////////////////////////////////////////////////////////////////////////////////////////////
      // Retrieve the saved selected accounts
      /////////////////////////////////////////////////////////////////////////////////////////////////
      var Accounts = new Array();
      with (document.forms[container]) {
         for (var i=0; i<AccountHelperSelectBox.length; i++) {
            Accounts[i] = new Object();
            Accounts[i].text  = AccountHelperSelectBox.options[i].text;
            Accounts[i].value = AccountHelperSelectBox.options[i].value;
         }
      }

      myContainer.AccountHelperSelectBox = Accounts;
      parent.put(container,myContainer);
   }



   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   // Return an array of selected account ids
   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   function returnSelectAccountIDs(container)
   {
     return returnSelectedValue(container);
   }

   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   // Return an array of selected account names
   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   function returnSelectAccountNames(container)
   {
      return returnSelectedText(container);
   }

   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   // function which returns the array of selected account ids
   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   function returnSelectedValue(container)
   {
      var selectedValue = new Array();
      var j=0;
      with (document.forms[container]){
         for (var i=0; i<AccountHelperSelectBox.length; i++) {
            if (AccountHelperSelectBox.options[i].selected) {
                selectedValue[j] = AccountHelperSelectBox.options[i].value;
                j++;
            }
         }
      }
      return selectedValue;
   }

   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   // function which returns the array of selected account names
   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   function returnSelectedText(container)
   {
      var selectedValue = new Array();
      var j=0;
      with (document.forms[container]){
         for (var i=0; i<AccountHelperSelectBox.length; i++) {
            if (AccountHelperSelectBox.options[i].selected) {
                selectedValue[j] = AccountHelperSelectBox.options[i].text;
                j++;
            }
         }
      }
      return selectedValue;
   }

   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   // Return the number of selected accounts
   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   function getNumberOfAccount(container)
   {
      var j=0;
      with (document.forms[container]){
         for (var i=0; i<AccountHelperSelectBox.length; i++) {
            if (AccountHelperSelectBox.options[i].selected)  j++;
         }
      }
       return j;
   }


   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   // Validation function to ensure that a account has been selected
   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   function validateSelectAccounts(container)
   {

      if (getNumberOfAccount(container) == 0) {
         alertDialog("<%=AccountHelperRB.get("AccountHelperNoSelection")%>");
         return false;
      }

      if (getNumberOfAccount(container) > 1) {
         alertDialog("<%=AccountHelperRB.get("AccountHelperNoMoreThanOneSelection")%>");
         return false;
      }
      return true;
   }


   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   // Validation function to ensure that multiple accounts has been selected
   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   function areMultipleAccounts(container)
   {
      if (getNumberOfAccount(container) < 2) {
         return false;
      }
      return true;
   }




</script>
