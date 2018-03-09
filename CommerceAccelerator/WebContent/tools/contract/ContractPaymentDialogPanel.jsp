<!--==========================================================================
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
===========================================================================-->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
<%@ page language="java"
   import="com.ibm.commerce.tools.util.UIUtil,
      com.ibm.commerce.user.beans.*,
     com.ibm.commerce.tools.contract.beans.*" %>

<%@ include file="../common/common.jsp" %>
<%@ include file="ContractCommon.jsp" %>

<%
   // Create an instance of the databean to use if we are doing an update

   String customerId="";
   String customerDN="";
   boolean showBillingAddressProblem = false;
   com.ibm.commerce.tools.contract.beans.MemberDataBean addrMemberDB = new com.ibm.commerce.tools.contract.beans.MemberDataBean();
   try
   {
     AccountDataBean adb = new AccountDataBean(new Long(accountId), new Integer(fLanguageId));
     DataBeanManager.activate(adb, request);
     customerId = adb.getCustomerId();

        addrMemberDB.setId(customerId);
     DataBeanManager.activate(addrMemberDB, request);
   }
   catch(Exception e)
   {
      showBillingAddressProblem = true;
   }
%>

<html>

<head>
<%= fHeader %>
<title><%= contractsRB.get("contractPaymentFormTitle") %></title>

<script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/Util.js">
</script>
<script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/NumberFormat.js">
</script>
<script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/DateUtil.js">
</script>
<script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/FieldEntryUtil.js">
</script>
<script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/Vector.js">
</script>
<script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/ConvertToXML.js">
</script>

<script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/contract/Contract.js">
</script>
<script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/contract/Payment.js">
</script>
<script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/contract/ContractUtil.js">
</script>

<script LANGUAGE="JavaScript">
<!---- hide script from old browsers


function loadPanelData () {
   with (selectionBody.document.paymentForm) {
      if (parent.setContentFrameLoaded) {
         parent.setContentFrameLoaded(true);
         if (<%= showBillingAddressProblem %> == true) {
               alertDialog('<%= UIUtil.toJavaScript(contractsRB.get("accountSaveBeforeBillingAddress")) %>');
            }
      }
   }
}

function savePanelData () {

}

function visibleList (s) {
   if (defined(this.selectionBody) == false || this.selectionBody.document.readyState != "complete") {
      return;
   }

   if (defined(this.selectionBody.visibleList)) {
      this.selectionBody.visibleList(s);
      return;
   }

   if (defined(this.selectionBody.document.forms[0])) {
      for (var i = 0; i < this.selectionBody.document.forms[0].elements.length; i++) {
         if (this.selectionBody.document.forms[0].elements[i].type.substring(0,6) == "select") {
            this.selectionBody.document.forms[0].elements[i].style.visibility = s;
         }
      }
   }

   if (defined(this.detailBody) == false || this.detailBody.document.readyState != "complete") {
      return;
   }

   if (defined(this.detailBody.visibleList)) {
      this.detailBody.visibleList(s);
      return;
   }

   if (defined(this.detailBody.document.forms[0])) {
      for (var i = 0; i < this.detailBody.document.forms[0].elements.length; i++) {
         if (this.detailBody.document.forms[0].elements[i].type.substring(0,6) == "select") {
            this.detailBody.document.forms[0].elements[i].style.visibility = s;
         }
      }
   }

   if (defined(this.AddressSelectionBody) == false || this.AddressSelectionBody.document.readyState != "complete") {
      return;
   }

   if (defined(this.AddressSelectionBody.visibleList)) {
      this.AddressSelectionBody.visibleList(s);
      return;
   }

   if (defined(this.AddressSelectionBody.document.forms[0])) {
      for (var i = 0; i < this.AddressSelectionBody.document.forms[0].elements.length; i++) {
         if (this.AddressSelectionBody.document.forms[0].elements[i].type.substring(0,6) == "select") {
            this.AddressSelectionBody.document.forms[0].elements[i].style.visibility = s;
         }
      }
   }

}

function AddressFormDetailChange ()
{
  if (defined(selectionBody.document.paymentForm) && defined(AddressSelectionBody.document.addressForm))
  {
    var policyIndex = selectionBody.document.paymentForm.PaymentPolicy.selectedIndex;

    if (policyIndex > 0)
    {
         if (defined(AddressSelectionBody.showBlank))
      {
        AddressSelectionBody.showBlank(false);
      }
    }
   var address = AddressSelectionBody.document.addressForm.paymentAddress.options[AddressSelectionBody.document.addressForm.paymentAddress.selectedIndex].value;
   if ((address == "") || (address == null))
   {
     address="/wcs/tools/common/blank.html";
     addressDetailBody.location.replace(address);
   }
   else
   {
     if (defined(addressDetailBody.showBlankLoadingDetail))
     {
       addressDetailBody.showBlankLoadingDetail("Loading");
     }
     else if (parent.setContentFrameLoaded)
      {
         parent.setContentFrameLoaded(false);
      }

     addressDetailBody.location.replace("ContractPaymentDialogAddressDetailPanelView?AddressId=" + address);
   }
  }
}

function paymentFormDetailChange (paymentPolicy)
{
   if ((paymentPolicy == "") || (paymentPolicy == null))
   {
     paymentPolicy="/wcs/tools/common/blank.html";
     detailBody.location.replace(paymentPolicy);
     if (defined(AddressSelectionBody.showBlank))
     {
       AddressSelectionBody.showBlank(true);
     }

     if (defined(addressDetailBody.showBlankLoadingDetail))
     {
       addressDetailBody.showBlankLoadingDetail("Blank");
     }
   }
   else if (paymentPolicy == "NOATTRPAGE")
   {
     paymentPolicy="/wcs/tools/common/blank.html";
     detailBody.location.replace(paymentPolicy);
     if (defined(AddressSelectionBody.showBlank))
     {
       AddressSelectionBody.showBlank(false);
     }

     /*if (defined(addressDetailBody.showBlankLoadingDetail))
     {
       addressDetailBody.showBlankLoadingDetail("Blank");
     }*/
   }
   else
   {
     if (defined(detailBody.showBlankLoadingDetail))
     {
       detailBody.showBlankLoadingDetail("Loading");
     }
     else if (parent.setContentFrameLoaded)
      {
         parent.setContentFrameLoaded(false);
      }
     /*
     if (defined(AddressSelectionBody.showBlank))
     {
       AddressSelectionBody.showBlank(false);
     }
     */
     detailBody.location.replace("ContractPaymentDialogPaymentPolicyDetailPanelView?paymentPolicy=" + paymentPolicy);

   }
}


function validatePanelData()
{
  var paymentPolicy = selectionBody.document.paymentForm.PaymentPolicy.options[selectionBody.document.paymentForm.PaymentPolicy.selectedIndex].value;
  var displayName = selectionBody.document.paymentForm.PaymentName.value;

  if (paymentPolicy=="" || paymentPolicy == null)
  {
    alertDialog("<%= UIUtil.toJavaScript((String)contractsRB.get("contractPaymentFormInvalidPaymentPolicy"))%>");
    return false;
  }

  if (displayName=="" || displayName == null)
  {
    alertDialog("<%= UIUtil.toJavaScript((String)contractsRB.get("contractPaymentFormInvalidDisplayName"))%>");
    selectionBody.document.paymentForm.PaymentName.focus();
    return false;
  }

  if (!isValidUTF8length(displayName, 254))
  {
    alertDialog("<%= UIUtil.toJavaScript((String)contractsRB.get("contractPaymentFormDisplayNameTooLong"))%>");
    selectionBody.document.paymentForm.PaymentName.focus();
    return false;
  }

  if (checkUniqueness(displayName))
  {
    alertDialog("<%= UIUtil.toJavaScript((String)contractsRB.get("contractPaymentFormDuplicateplayName"))%>");
    selectionBody.document.paymentForm.PaymentName.focus();
    return false;
  }


  return true;
}

function checkUniqueness(name)
{
  var changeRow=top.getData("changeRow",1);

  //it a update
  if (changeRow!=null)
  {
    // display name has not been changed.
    if (name == changeRow.name)
    {
      return false;
    }
  }

  // otherwise it is a new entry or display name has changed, so check uniqueness

  var cpm=top.getModel(1);

  //alertDialog(convertToXML(cpm.ContractPaymentModel));
  if (cpm==null)
  {
    alertDialog ("model is null");
  }

  var paymentList = cpm.ContractPaymentModel.paymentMethod;


  for (var i=0; i<paymentList.length; i++)
  {
    if (name==paymentList[i].name)
    {
      return true;
    }
  }

  return false;
}


function getHiddenNumbers ()
{
  var j=0;
   if (defined(detailBody.document.forms[0]))
   {
   with (detailBody.document.forms[0])
   {
      for (var i=0; i<elements.length; i++)
      {
//         if (elements[i].type=="hidden" && elements[i].value!="")
         if (elements[i].type=="hidden")
         {
           j++;
         }
      }
   }
   }
  return j;
}


function getEmptyHiddenFieldsNumber ()
{
   var j=0;

   if (defined(detailBody.document.forms[0]))
   {
      with (detailBody.document.forms[0])
      {
         for (var i=0; i<elements.length; i++)
         {
            if (elements[i].type=="hidden" && elements[i].value=="")
            {
               j++;
            }
         }

      }//end-with

   }//end-if

   return j;
}


function getDetailFormData ()
{
   atts = new Array();
  var j=0;
   if (defined(detailBody.document.forms[0]))
   {
   with (detailBody.document.forms[0])
   {
      for (var i=0; i<elements.length; i++)
      {
         if ((elements[i].type=="radio") || (elements[i].type=="checkbox"))
         {
          if (elements[i].checked==true)
          {
            atts[j] = new Object();
            atts[j].name=elements[i].name;
            atts[j].value=elements[i].value;
            j++;
          }
         }
         else
         {
            atts[j] = new Object();
            atts[j].name=elements[i].name;
            atts[j].value=elements[i].value;
            j++;
         }
      }
   }
   }
  return atts;
}


   function validateDynamicForm(atts)
   {
      if ((atts!=null) && (atts.length!=0))
      {
         var totalEmptyFields  = 0;             // Total number of empty or unfilled fields (including both hidden & user fields)
         var hiddenFields = getHiddenNumbers(); // Numbers of hidden fields in the form
         var totalFormFields  = atts.length;    // Total number of fields in the form
         var emptyHiddenFields = getEmptyHiddenFieldsNumber(); // Numbers of hidden fields with empty value

         // Total number of user allowed input fields
         var userAllowedInputFields = totalFormFields - hiddenFields;

         // Count how many empty fields in the form
         for (var i=0; i<totalFormFields; i++)
         {
            if (atts[i].value=="")
            {
               totalEmptyFields++;
            }

         }//end-for


         // Number of user's unfilled fields
         var userEmptyFields = totalEmptyFields - emptyHiddenFields;

         // Total number of fields that user already inputed
         var userAlreadyInputedFields = userAllowedInputFields - userEmptyFields ;

         /* this is for debug
         var debugMsg = "debugMsg: "
                        + "\n   totalFormFields=" + totalFormFields
                        + ",\n   totalEmptyFields=" + totalEmptyFields
                        + ",\n   hiddenFields=" + hiddenFields
                        + ",\n   emptyHiddenFields=" + emptyHiddenFields
                        + ",\n   userAllowedInputFields=" + userAllowedInputFields
                        + ",\n   userEmptyFields=" + userEmptyFields
                        + ",\n   userAlreadyInputedFields=" + userAlreadyInputedFields
                        ; alert(debugMsg);
         */


         // Give user a warning message if he input nothing.
         if ( (userAllowedInputFields>0) && (userAlreadyInputedFields==0) )
         {
            return confirmDialog ("<%=UIUtil.toJavaScript((String)contractsRB.get("contractPaymentFormMissAllValues"))%>");
         }

      }//end-if

      return true;
   }



function savePaymentForm () {
   // save data to notebook javascript model

   var atts=getDetailFormData();
   if (validatePanelData() && validateDynamicForm(atts))
   {
     var storeIdentity = selectionBody.policyStoreIdentity[selectionBody.document.paymentForm.PaymentPolicy.selectedIndex-1];
     var storeMemberId = selectionBody.policyStoreMemberId[selectionBody.document.paymentForm.PaymentPolicy.selectedIndex-1];
     //var storeMemberDN = selectionBody.policyStoreMemberDN[selectionBody.document.paymentForm.PaymentPolicy.selectedIndex-1];
     //var storeMemberDNType = selectionBody.policyStoreMemberDNType[selectionBody.document.paymentForm.PaymentPolicy.selectedIndex-1];
     var storeMemberObj = selectionBody.policyStoreMemberObj[selectionBody.document.paymentForm.PaymentPolicy.selectedIndex-1];

     newPaymentTC = new Object();

    newPaymentTC.action="new";

     var changeRow=top.getData("changeRow",1);

    //it an update
    if ((changeRow!=null) && ((changeRow.action=="noaction") || (changeRow.action=="update")))
    {
      newPaymentTC=changeRow;
      newPaymentTC.action="update";
    }

    newPaymentTC.name = selectionBody.document.paymentForm.PaymentName.value
     newPaymentTC.paymentPolicy=selectionBody.document.paymentForm.PaymentPolicy.options[selectionBody.document.paymentForm.PaymentPolicy.selectedIndex].value;
     newPaymentTC.storeIdentity = storeIdentity;
     newPaymentTC.storeMemberId = storeMemberId;
     //newPaymentTC.storeMemberDN = storeMemberDN;
     //newPaymentTC.storeMemberDNType = storeMemberDNType;
     newPaymentTC.storeMemberObj = storeMemberObj;

    var addressName="";
    if(AddressSelectionBody.document.addressForm.paymentAddress.selectedIndex!=0)
    {
      addressName = AddressSelectionBody.document.addressForm.paymentAddress.options[AddressSelectionBody.document.addressForm.paymentAddress.selectedIndex].text;
    }

    //testing
    var memberId=AddressSelectionBody.fAccountHolderMemberId;
    //if (addressName != "")
    //{
      newPaymentTC.addressName=addressName;
      newPaymentTC.member_id=memberId;
      newPaymentTC.member_obj=new Member('<%= addrMemberDB.getMemberType() %>',
                                 '<%= UIUtil.toJavaScript(addrMemberDB.getMemberDN()) %>',
                                 '<%= UIUtil.toJavaScript(addrMemberDB.getMemberGroupName()) %>',
                                 '<%= addrMemberDB.getMemberGroupOwnerMemberType() %>',
                                 '<%= UIUtil.toJavaScript(addrMemberDB.getMemberGroupOwnerMemberDN()) %>');
    //}
    if (atts.length!=0)
    {
      newPaymentTC.atts=atts;
    }

     top.sendBackData(newPaymentTC, "newPaymentTC");
     top.goBack();
   }
}

function cancelPaymentForm () {
   // go back to contract payment panel
   top.goBack();
}
//-->

</script>
</head>

<frameset rows="36%,20%,20%,24%" frameborder="no" border="0" framespacing="0">
   <frame src="ContractPaymentDialogPaymentPolicySelectionPanelView?accountId=<%=UIUtil.toHTML(accountId)%>" title="<%= UIUtil.toJavaScript(contractsRB.get("contractPaymentFormSelectionPanelTitle")) %>" name="selectionBody" scrolling="auto" noresize>
   <frame src="/wcs/tools/common/blank.html" title="<%= UIUtil.toJavaScript(contractsRB.get("contractPaymentFormDetailPanelTitle")) %>" name="detailBody" scrolling="auto" noresize>
   <frame src="ContractPaymentDialogAddressSelectionPanelView?accountId=<%=UIUtil.toHTML(accountId)%>" title="<%= UIUtil.toJavaScript(contractsRB.get("contractPaymentFormAddressSelectionPanelTitle")) %>" name="AddressSelectionBody" scrolling="auto" noresize>
   <!--frame src="/wcs/tools/common/blank.html" title="<%= UIUtil.toJavaScript(contractsRB.get("contractPaymentFormAddressSelectionPanelTitle")) %>" name="AddressSelectionBody" scrolling="auto" noresize-->
   <frame src="/wcs/tools/common/blank.html" title="<%= UIUtil.toJavaScript(contractsRB.get("contractPaymentFormAddressDetailPanelTitle")) %>" name="addressDetailBody" scrolling="auto" noresize>
</frameset>

</html>