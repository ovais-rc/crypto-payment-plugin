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

function AttachmentModel()
{
   this.URL = "";
}

function DisplayLogoModel()
{
   var attachment = new AttachmentModel();
   this.Attachment = attachment;
}

function DisplayTextModel()
{
   this.text = "";
   this.locale = "";
}


// Model_1 contains only display logo attributes but not display text
function DisplayCustomizationModel_1()
{
   this.referenceNumber = "";
   this.indexNumber = "";
   this.action = "";
   this.displayType = "";

   var displayLogo = new DisplayLogoModel();
   this.DisplayLogo = displayLogo;
}



// Model_2 contains only display text attributes but not display logo
function DisplayCustomizationModel_2()
{
   this.referenceNumber = "";
   this.indexNumber = "";
   this.action = "";
   this.displayType = "";

   var displayText = new DisplayTextModel();
   this.DisplayText = displayText;
}


function DisplayTCPlaceHolderModel()
{
   this.accountID = "";
   this.languageID = "";
   this.originalAttachmentURL = "";
   this.originalTextField1 = "";
   this.originalTextField2 = "";
   this.attachmentURL = "";
   this.textField1 = "";
   this.textField2 = "";
   this.attachmentRefNumber = "";
   this.textField1RefNumber = "";
   this.textField2RefNumber = "";
}


function validateDisplayCustomizationPanel()
{
   //alert("validateDisplayCustomizationPanel()");

   var dcModel = get("DisplayCustomizationModel");

   if (dcModel != null)
   {
      //alert("validateDisplayCustomizationPanel():: dcModel != null");

      // Check if logo field is empty
      if (!dcModel.attachmentURL)
      {
         // allow nullable
      }

      // Check if logo field is too long
      if (!isValidUTF8length(dcModel.attachmentURL, 254))
      {
         put("accountDisplayCustomizationLogoFieldTooLong", true);
         gotoPanel("notebookDisplayCustomization");
         return false;
      }

      // Check if text field #1 is empty
      if (!dcModel.textField1)
      {
         // allow nullable
      }

      // Check if text field #1 is too long
      if (!isValidUTF8length(dcModel.textField1, 3000))
      {
         put("accountDisplayCustomizationTextField1TooLong", true);
         gotoPanel("notebookDisplayCustomization");
         return false;
      }

      // Check if text field #2 is empty
      if (!dcModel.textField2)
      {
         // allow nullable
      }

      // Check if text field #2 is too long
      if (!isValidUTF8length(dcModel.textField2, 3000))
      {
         put("accountDisplayCustomizationTextField2TooLong", true);
         gotoPanel("notebookDisplayCustomization");
         return false;
      }

  }

}



function submitDisplayCustomizationTC(account)
{
   //alert("submitDisplayCustomizationTC(account)");

   var tcModel = get("DisplayCustomizationModel");

   if (tcModel == null) { return true; }

   var tcArray = new Array();


   //--------------------------------------------
   // Model a TC for the attachment display logo
   //--------------------------------------------

   var displayTC1 = new DisplayCustomizationModel_1();
   displayTC1.indexNumber = "1";
   displayTC1.displayType = "ATTACHMENT";
   displayTC1.DisplayLogo.Attachment.URL = tcModel.attachmentURL;

   if (tcModel.attachmentRefNumber != "")
   {
      // Existing term & condition
      displayTC1.referenceNumber = tcModel.attachmentRefNumber;
      tcArray[tcArray.length] = displayTC1;

      // Check if the URL changed
      if (tcModel.originalAttachmentURL == displayTC1.DisplayLogo.Attachment.URL)
      {
         displayTC1.action = "noaction";
      }
      else if (displayTC1.DisplayLogo.Attachment.URL == "")
      {
         displayTC1.action = "delete";
      }
      else
      {
         // Change the term and condition
         displayTC1.action = "update";
      }
   }
   else if (tcModel.attachmentURL != "")
   {
      // Create a new term & condition
      displayTC1.action = "new";
      tcArray[tcArray.length] = displayTC1;
   }
   else
   {
      // No reference# and empty logo field, do nothing
      displayTC1.action = "noaction";
   }



   //-----------------------------------------
   // Model a TC for the display text field 1
   //-----------------------------------------

   var displayTC2 = new DisplayCustomizationModel_2();
   displayTC2.indexNumber = "1";
   displayTC2.displayType = "TEXTFIELD";
   displayTC2.DisplayText.text  = tcModel.textField1;
   displayTC2.DisplayText.locale = tcModel.languageID;

   if (tcModel.textField1RefNumber != "")
   {
      displayTC2.referenceNumber = tcModel.textField1RefNumber;
      tcArray[tcArray.length] = displayTC2;

      // Check if the text field one changed
      if (tcModel.originalTextField1 == displayTC2.DisplayText.text)
      {
         displayTC2.action = "noaction";
      }
      else if (displayTC2.DisplayText.text == "")
      {
         displayTC2.action = "delete";
      }
      else
      {
         // Change the term and condition
         displayTC2.action = "update";
      }

   }
   else  if (tcModel.textField1 != "")
   {
      // Create a new term & condition
      displayTC2.action = "new";
      tcArray[tcArray.length] = displayTC2;
   }
   else
   {
      // No reference# and empty text field, do nothing
      displayTC2.action = "noaction";
   }



   //-----------------------------------------
   // Model a TC for the display text field 2
   //-----------------------------------------

   var displayTC3 = new DisplayCustomizationModel_2();
   displayTC3.indexNumber = "2";
   displayTC3.displayType = "TEXTFIELD";
   displayTC3.DisplayText.text  = tcModel.textField2;
   displayTC3.DisplayText.locale = tcModel.languageID;

   if (tcModel.textField2RefNumber != "")
   {
      displayTC3.referenceNumber = tcModel.textField2RefNumber;
      tcArray[tcArray.length] = displayTC3;

      // Check if the text field two changed
      if (tcModel.originalTextField2 == displayTC3.DisplayText.text)
      {
         displayTC3.action = "noaction";
      }
      else if (displayTC3.DisplayText.text == "")
      {
         displayTC3.action = "delete";
      }
      else
      {
         // Change the term and condition
         displayTC3.action = "update";
      }

   }
   else  if (tcModel.textField2 != "")
   {
      // Create a new term & condition
      displayTC3.action = "new";
      tcArray[tcArray.length] = displayTC3;
   }
   else
   {
      // No reference# and empty text field, do nothing
      displayTC3.action = "noaction";
   }


   if (tcArray.length > 0)
   {
      account.DisplayCustomizationTC = tcArray;
   }


   return true;
}





