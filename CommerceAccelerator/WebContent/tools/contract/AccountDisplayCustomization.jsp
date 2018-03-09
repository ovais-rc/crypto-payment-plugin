<!--==========================================================================
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2001, 2002, 2003
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
//*
  ===========================================================================-->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
<%@page language="java"
   import="com.ibm.commerce.beans.DataBeanManager,
   com.ibm.commerce.tools.contract.beans.DisplayCustomizationTCDataBean,
   com.ibm.commerce.tools.util.UIUtil" %>

<%@ page import="com.ibm.commerce.contract.beans.AttachmentDataBean" %>

<%@include file="../common/common.jsp" %>
<%@include file="ContractCommon.jsp" %>
<html>

<head>
 <%= fHeader %>
 <link rel="stylesheet" href="<%= UIUtil.getCSSFile(fLocale) %>" type="text/css">

 <title><%= contractsRB.get("accountDisplayCustomizationTitle") %></title>

 <script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/Util.js">
</script>
 <script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/contract/DisplayCustomization.js">
</script>



 <script LANGUAGE="JavaScript">

function loadPanelData()
{
   //alert ('DisplayCustomization.jsp javascript::loadPanelData()');

   with (document.displayCustomizationForm)
   {
      if (parent.setContentFrameLoaded)
      {
         parent.setContentFrameLoaded(true);
      }

      if (parent.get)
      {
         var hereBefore = parent.get("DisplayCustomizationModelLoaded", null);

         if (hereBefore != null)
         {
            //alert('DisplayCustomization - back to same page - load from model');

            var o = parent.get("DisplayCustomizationModel", null);
            if (o != null)
            {
               document.displayCustomizationForm.logoField.value  = o.attachmentURL;
               document.displayCustomizationForm.textField1.value = o.textField1;
               document.displayCustomizationForm.textField2.value = o.textField2;
            }

         }
         else
         {
            //alert('DisplayCustomization - first time on page');

            // Create the model
            var dcm = new DisplayTCPlaceHolderModel();

            parent.put("DisplayCustomizationModel", dcm);
            parent.put("DisplayCustomizationModelLoaded", true);
            
            dcm.languageID = "<%= fLocale.toString() %>";

            // Check if this is an update
            if (<%= foundAccountId %> == true)
            {
               //alert('Load from the databean');

               <%

               if (foundAccountId)
               {
                  DisplayCustomizationTCDataBean tc = new DisplayCustomizationTCDataBean(new Long(accountId), new Integer(fLanguageId));
                  DataBeanManager.activate(tc, request);

                  out.println("dcm.accountID = '"  + accountId   + "';");

                  if (tc.getHasDisplayLogo())
                  {
                     AttachmentDataBean dbAttachment = tc.getAttachment(1);
                     if (dbAttachment!=null)
                     {
                        String pathname = UIUtil.toJavaScript(dbAttachment.getAttachmentURL());
                        out.println("document.displayCustomizationForm.logoField.value = '" + pathname + "';");
                        out.println("dcm.attachmentURL = '"         + pathname + "';");
                        out.println("dcm.originalAttachmentURL = '" + pathname + "';");
                        out.println("dcm.attachmentRefNumber = '"   + tc.getAttachmentReferenceNumber(1) + "';");
                     }
                     else
                     {
                        out.println("document.displayCustomizationForm.logoField.value = '';");
                     }

                  }

                  if (tc.getHasDisplayText())
                  {
                     // Take care the Text Field One & Text Field Two

                     String textOne =  UIUtil.toJavaScript((tc.getDisplayText(1)==null) ? "" : tc.getDisplayText(1));
                     String textTwo =  UIUtil.toJavaScript((tc.getDisplayText(2)==null) ? "" : tc.getDisplayText(2));
                     String textOneRefNum = ((tc.getDisplayTextReferenceNumber(1)==null) ? "" : tc.getDisplayTextReferenceNumber(1));
                     String textTwoRefNum = ((tc.getDisplayTextReferenceNumber(2)==null) ? "" : tc.getDisplayTextReferenceNumber(2));

                     out.println("dcm.textField1 = '"          + textOne + "';");
                     out.println("dcm.originalTextField1 = '"  + textOne + "';");
                     out.println("dcm.textField1RefNumber = '" + textOneRefNum + "';");
                     out.println("dcm.textField2 = '"          + textTwo + "';");
                     out.println("dcm.originalTextField2 = '"  + textTwo + "';");
                     out.println("dcm.textField2RefNumber = '" + textTwoRefNum + "';");

                     out.println("document.displayCustomizationForm.textField1.value = '" + textOne + "';");
                     out.println("document.displayCustomizationForm.textField2.value = '" + textTwo + "';");
                  }

               }//end-if (foundAccountId)

               %>

            }
            else
            {
               document.displayCustomizationForm.logoField.value  = "" ;
               document.displayCustomizationForm.textField1.value = "";
               document.displayCustomizationForm.textField2.value = "";

            }//end-if-else (foundAccountId==true)

         }//end-if-else (herebefore!=null)


         // handle error messages back from the validate page


      }//end-if (parent.get)

   }//end-with

}




function savePanelData()
{
   //alert ('DisplayCustomization.jsp javascript::savePanelData()');

   with (document.displayCustomizationForm)
   {
      if (parent.get)
      {
         var o = parent.get("DisplayCustomizationModel", null);
         if (o != null)
         {
            o.attachmentURL  = document.displayCustomizationForm.logoField.value;
            o.textField1 = document.displayCustomizationForm.textField1.value;
            o.textField2 = document.displayCustomizationForm.textField2.value;
         }
      }
    }

}



</script>

</head>

<body ONLOAD="loadPanelData()" class="content">

<h1><%= contractsRB.get("accountDisplayCustomizationTitle") %></h1>

<form NAME="displayCustomizationForm" id="displayCustomizationForm">

   <label for="AccountDisplayCustomization_FormInput_logoField_In_displayCustomizationForm_1"><%= contractsRB.get("accountDisplayCustomizationLogoField") %></label>
   <br>
   <input type=text name=logoField value="" size=50 maxlength=254 id="AccountDisplayCustomization_FormInput_logoField_In_displayCustomizationForm_1">
   <br>
   <br>

   <label for="AccountDisplayCustomization_FormInput_textField1_In_displayCustomizationForm_1"><%= contractsRB.get("accountDisplayCustomizationTextField1") %></label>
   <br>
   <input type=text name=textField1 value="" size=50 maxlength=3000 id="AccountDisplayCustomization_FormInput_textField1_In_displayCustomizationForm_1">
   <br>
   <br>

   <label for="AccountDisplayCustomization_FormInput_textField2_In_displayCustomizationForm_1"><%= contractsRB.get("accountDisplayCustomizationTextField2") %></label>
   <br>
   <input type=text name=textField2 value="" size=50 maxlength=3000 id="AccountDisplayCustomization_FormInput_textField2_In_displayCustomizationForm_1">
   <br>
   <br>

</form>


</body>
</html>


