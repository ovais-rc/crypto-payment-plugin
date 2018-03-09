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
   import="com.ibm.commerce.beans.DataBeanManager,
   com.ibm.commerce.tools.util.UIUtil,
   com.ibm.commerce.tools.common.ui.taglibs.*,
   com.ibm.commerce.datatype.TypedProperty,
   com.ibm.commerce.tools.contract.beans.PolicyDataBean,
   com.ibm.commerce.tools.contract.beans.PolicyListDataBean,
   com.ibm.commerce.account.util.AccountTCHelper,
   com.ibm.commerce.tools.contract.beans.AddressBookTCDataBean,
   com.ibm.commerce.contract.helper.ECContractConstants,
   com.ibm.commerce.payment.beans.PaymentPolicyListDataBean,
  com.ibm.commerce.tools.contract.beans.*,
  com.ibm.commerce.tools.contract.beans.PaymentTCDataBean" %>



<%
   PolicyListDataBean policyList = new PolicyListDataBean();
   String policyType = policyList.TYPE_PAYMENT;
%>

<%@ include file="../common/common.jsp" %>
<%@ include file="ContractCommon.jsp" %>


<%
   /*90288*/
   //--------------------------------------------------------------
   // Checking the current terms and conditions lock
   // in contract change mode. This is not applicable if a draft
   // contract is not even created.
   //--------------------------------------------------------------
   int lockHelperRC       = 0;
   String tcLockOwner     = "";
   String tcLockTimestamp = "";

   if (foundContractId)
   {
      com.ibm.commerce.contract.util.ContractTCLockHelper myLockHelper
            = new com.ibm.commerce.contract.util.ContractTCLockHelper
                  (contractCommandContext,
                   new Long(contractId),
                   com.ibm.commerce.contract.util.ContractTCLockHelper.TCTYPE_PAYMENT);
      lockHelperRC    = myLockHelper.managingLock();
      tcLockOwner     = myLockHelper.getCurrentLockOwnerLogonId();
      tcLockTimestamp = myLockHelper.getCurrentLockCreationTimestamp();
   }
%>


<%
   int startIndex = Integer.parseInt(request.getParameter("startindex"));
   int listSize = Integer.parseInt(request.getParameter("listsize"));
   boolean bNotFoundCreditPolicy = true;

   try
   {
     PaymentTCDataBean temptc = new PaymentTCDataBean(new Long(UIUtil.toHTML(accountId)), new Integer(fLanguageId));
    DataBeanManager.activate(temptc, request);
    String[] tempPolicyName;

    tempPolicyName = temptc.getPolicyName();
    for (int i = 0; i < tempPolicyName.length; i++) {
       if (PaymentPolicyListDataBean.isCreditPaymentPolicy(tempPolicyName[i])) {
          bNotFoundCreditPolicy = false;
          break;
       }
    }
  }
  catch (Exception e)
  {
  }
  if (editingAccount) {
   // if in account, cannot choose set credit line
   bNotFoundCreditPolicy = true;
  }
%>

<html>

<head>
<%= fHeader%>
<link rel="stylesheet" href="<%= UIUtil.getCSSFile(fLocale) %>" type="text/css">
<title><%= UIUtil.toHTML((String)contractsRB.get("contractPaymentTitle")) %></title>

<script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/Util.js">
</script>
<script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/dynamiclist.js">
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


/*90288*/
//-------------------------------------------------------
// These variables capture the return code and some
// lock details of executing the ContractTCLockHelper
//-------------------------------------------------------
var contractTCLockHelperRC = "<%= lockHelperRC %>";
var contractTCLockOwner    = "<%= tcLockOwner %>";
var contractTCLockTime     = "<%= tcLockTimestamp %>";
var shouldTCbeSaved        = false;


//------------------------------------------------------------------------
// Function Name: handleTCLockStatus
//
// This function handle the current lock status for this terms and
// conditions. It will determine the dialog to interact with user
// according to the lock status return code during loading this page.
//------------------------------------------------------------------------
function handleTCLockStatus()
{
   if (contractTCLockHelperRC==0)
   {
      // Skip it because this is a new contract not even created yet
      return;
   }

   var forceUnlock = false;

   if (   (contractTCLockHelperRC=="<%= com.ibm.commerce.contract.util.ContractTCLockHelper.RC_ACQUIRE_NEWLOCK %>")
       || (contractTCLockHelperRC=="<%= com.ibm.commerce.contract.util.ContractTCLockHelper.RC_RENEW_LOCK %>") )
   {
      // New lock has been acquired for the current user on this TC
      shouldTCbeSaved = true;
   }
   else if (contractTCLockHelperRC=="<%= com.ibm.commerce.contract.util.ContractTCLockHelper.RC_NOT_ALLOWED_TO_UNLOCK %>")
   {
      // This TC has been locked by someone, and user is not allowed to unlock.
      // Show warning message to the user

      shouldTCbeSaved = false;
      var tcName = "<%= UIUtil.toJavaScript((String)contractsRB.get("CCL_TCName_Payment")) %>";
      var warningMsg = "<%= UIUtil.toJavaScript((String)contractsRB.get("CCL_MsgLockTC")) %>";
      warningMsg = warningMsg.replace(/%3/, tcName);
      warningMsg = warningMsg.replace(/%1/, contractTCLockOwner);
      warningMsg = warningMsg.replace(/%2/, contractTCLockTime);

      alertDialog(warningMsg);
   }
   else if (contractTCLockHelperRC=="<%= com.ibm.commerce.contract.util.ContractTCLockHelper.RC_ALLOWED_TO_UNLOCK %>")
   {
      // This TC has been locked by someone, but user is allowed to unlock.
      // Promopt user to unlock

      var tcName = "<%= UIUtil.toJavaScript((String)contractsRB.get("CCL_TCName_Payment")) %>";
      var promptMsg = "<%= UIUtil.toJavaScript((String)contractsRB.get("CCL_MsgLockTCPrompt")) %>";
      promptMsg = promptMsg.replace(/%3/, tcName);
      promptMsg = promptMsg.replace(/%1/, contractTCLockOwner);
      promptMsg = promptMsg.replace(/%2/, contractTCLockTime);
      promptMsg = promptMsg.replace(/%1/, contractTCLockOwner);

      if (confirmDialog(promptMsg))
      {
         // User clicks OK to unlock this TC
         shouldTCbeSaved = true;
         forceUnlock = true;
         parent.parent.unlockAndLockContractTC("<%= contractId %>", 3);
      }
      else
      {
         // User clicks CANCEL to give up the unlock of this TC
         shouldTCbeSaved = false;
      }
   }

   // Persist the flag to the javascript ContractCommonDataModel
   var ccmd = parent.parent.get("ContractCommonDataModel", null);
   if (ccmd!=null)
   {
      ccmd.tcLockInfo["PaymentTC"] = new Object();
      ccmd.tcLockInfo["PaymentTC"].contractID = "<%= contractId %>";
      ccmd.tcLockInfo["PaymentTC"].tcType = "<%= com.ibm.commerce.contract.util.ContractTCLockHelper.TCTYPE_PAYMENT %>";
      ccmd.tcLockInfo["PaymentTC"].shouldTCbeSaved = shouldTCbeSaved;
      ccmd.tcLockInfo["PaymentTC"].forceUnlock = forceUnlock;
   }

   if (!shouldTCbeSaved) { disableAllFormsElements(); } //disallow user to change any fields

   return;

}//end-function-handleTCLockStatus


//------------------------------------------------------------------------
// Function Name: disableAllFormsElements
//
// This function disables all the elements in the forms, so that user
// will not able to change any current contents to the forms fields.
//------------------------------------------------------------------------
function disableAllFormsElements()
{
   for (var i=0; i<document.AllowCreditLineForm.elements.length; i++)
   {
      document.AllowCreditLineForm.elements[i].disabled = true;
   }
   for (var i=0; i<document.ContractPaymentForm.elements.length; i++)
   {
      document.ContractPaymentForm.elements[i].disabled = true;
   }
   for (var i=0; i<document.AddressBookForm.elements.length; i++)
   {
      document.AddressBookForm.elements[i].disabled = true;
   }

   parent.hideButton("add");
   parent.hideButton("change");
   parent.hideButton("remove");
}



<!---- hide script from old browsers
//Declare variables to be used throughout the entire page

var paymentList;
var numberOfPayment = 0;

function getResultsize ()
{
   return numberOfPayment;
}


function showXML()
{
  var cpm = parent.parent.get("ContractPaymentModel", null);
  var o = convertLocalModelToPayment(cpm);
  if (o!=null)
  {
    alertDialog(convertToXML(o));
  }
  else
  {
    alertDialog("no payment tcs");
  }
}

function createPayment ()
{
  var url = "/webapp/wcs/tools/servlet/DialogView?XMLFile=contract.ContractPaymentDialog&accountId=<%=UIUtil.toJavaScript(accountId)%>&contractId=<%=contractId%>";
   //top.saveModel(Object data);
   top.saveModel(parent.parent.model);

   var ccdm = parent.parent.get("ContractCommonDataModel",null);
   if (ccdm != null)
   {
     top.saveData(ccdm, "CCDM");
   }

  savePanelData();
   //top.saveData(Object data, String slotName);

   //top.setReturningPanel(String panelName);
   top.setReturningPanel("notebookPayment");

   if(top.setContent)
   {
     top.setContent("<%= UIUtil.toJavaScript((String)contractsRB.get("contractPaymentDialogAddTitle")) %>", url, true);
   }
   else
   {
     alertDialog("parent.parent.location.replace(url);");
     //parent.parent.location.replace(url);
   }
}

function changePOById(checked)
{

   var url = "/webapp/wcs/tools/servlet/DialogView?XMLFile=contract.ContractPaymentDialog&accountId=<%=UIUtil.toJavaScript(accountId)%>&contractId=<%=contractId%>";
   if (checked.length > 0)
   {
      var parms = checked.split(',');
      var rowNum = parms[0];

   var ccdm = parent.parent.get("ContractCommonDataModel",null);
   if (ccdm != null)
   {
     top.saveData(ccdm, "CCDM");
   }
   savePanelData();

   var changeRow = new Object();
   changeRow = paymentList[rowNum];
    top.saveData(changeRow, "changeRow");
    top.saveModel(parent.parent.model);
   top.setReturningPanel("notebookPayment");
    if(top.setContent)
   {
     top.setContent("<%= UIUtil.toJavaScript((String)contractsRB.get("contractPaymentDialogChangeTitle")) %>", url, true);
   }
   else
   {
     alertDialog("parent.parent.location.replace(url);");
   //parent.parent.location.replace(url);
   }
  }
}


function updatePayment ()
{
   var url = "/webapp/wcs/tools/servlet/DialogView?XMLFile=contract.ContractPaymentDialog&accountId=<%=UIUtil.toJavaScript(accountId)%>&contractId=<%=contractId%>";
   var ccdm = parent.parent.get("ContractCommonDataModel",null);
   if (ccdm != null)
   {
     top.saveData(ccdm, "CCDM");
   }
   savePanelData();
   var rowNum = parent.getChecked();
   if (rowNum != null)
   {
      var changeRow = new Object();
      changeRow = paymentList[rowNum];
    top.saveData(changeRow, "changeRow");
      top.saveModel(parent.parent.model);
     top.setReturningPanel("notebookPayment");
    if(top.setContent)
     {
       top.setContent("<%= UIUtil.toJavaScript((String)contractsRB.get("contractPaymentDialogChangeTitle")) %>", url, true);
     }
     else
     {
       alertDialog("parent.parent.location.replace(url);");
     //parent.parent.location.replace(url);
     }
   }
}

function deletePayment ()
{
  if (confirmDialog("<%= UIUtil.toJavaScript((String)contractsRB.get("contractPaymentFormDeleteConfirmation")) %>"))
  {
    var rowNum = new String(parent.getChecked());
    var items = rowNum.split(",");
    //items.sort();
    for (var i=0; i<items.length; i++)
    {
      paymentList[items[i]].deleted=true;
    }


    var newPaymentList= new Array();
    var j=0;

    if (<%= foundContractId %> == true || (<%= editingAccount %> == true && <%= foundAccountId %> == true) )
    {
      //updating a contract: if it is old TC, set action = delete

      for (var i=0; i<paymentList.length; i++)
      {
        if (paymentList[i].deleted)
        {
          if (paymentList[i].action=="noaction")
          {
            //load -> delete : set action=delete and keep it
            paymentList[i].action="delete";
            newPaymentList[j]=paymentList[i];
            j++;
          }
          else if (paymentList[i].action=="new")
          {
            //new tc, we can delete it from model
            //so do nothing
          }
          else
          {
            //catch "update" and "delete" TCs
            //just keep it
            newPaymentList[j]=paymentList[i];
            newPaymentList[j].action="delete";
            j++;
          }
        }
        else
        {
          //catch no deleted TCs
          newPaymentList[j]=paymentList[i];
          j++;
        }
      }
    }
    else
    {
      //new contract: erase deleted TCs from the model
      var j=0;
      for (var i=0; i<paymentList.length; i++)
      {
        if (!paymentList[i].deleted)
        {
          newPaymentList[j]=paymentList[i];
          j++;
        }
      }
    }

    paymentList=newPaymentList;

    var o = parent.parent.get("ContractPaymentModel", null);
    if (o != null)
    {
       o.paymentMethod=paymentList;
    }

    var url="notebookPayment";
    parent.parent.gotoPanel(url);
    //parent.parent.location.reload();
  }
}

function addRowNumbers ()
{
   for (var i=0; i<paymentList.length; i++)
   {
      paymentList[i].rowNum = i;
      paymentList[i].deleted = false;
   }
}

function savePanelData()
{
//alertDialog ('Payment TC: savePanelData');
  if (parent.parent.get)
  {
    var o = parent.parent.get("ContractPaymentModel", null);
    if (o != null)
    {
         with (document.AllowCreditLineForm)
         {
//alert('savePanelData');
           o.allowCredit=AllowCreditLine.checked;
         }
         with (document.AddressBookForm)
         {
                     o.usePersonal = usePersonal.checked;
                     o.useParent = useParent.checked;
                     o.useAccount = useAccount.checked;
           //alert(o.allowCredit);
         }
      }
   }
}

function setAddressBookForm() {
   var cpm = parent.parent.get("ContractPaymentModel", null);
   if (cpm != null)
   {
                with (document.AddressBookForm)
                {
//alert('loadPanelData reload page from model');
                    usePersonal.checked = cpm.usePersonal;
                    useParent.checked = cpm.useParent;
                    useAccount.checked = cpm.useAccount;
                }
        }
}

function onLoad()
{
   parent.loadFrames();
   if (parent.parent.setContentFrameLoaded)
   {
      parent.parent.setContentFrameLoaded(true);
   }

   /*90288*/ handleTCLockStatus();
}

function loadPanelData ()
{
  if (!parent.parent.get)
  {
    alertDialog('No model found!');
    return;
  }

  //set creditLineAllowed
  var gm=parent.parent.get("ContractGeneralModel",null);
  if (gm!=null)
  {
    with (document.AllowCreditLineForm)
    {
      AllowCreditLine.checked=gm.creditLineAllowed;
      //alert(gm.creditLineAllowed);
    }
  }
  var hereBefore = parent.parent.get("ContractPaymentModelLoaded", null);
  //alertDialog(hereBefore);
  if (hereBefore)
  {
   // have been to this page before - load from the model
   //alertDialog("have been here before, load data from the model");
   var cpm = parent.parent.get("ContractPaymentModel", null);
   if (cpm != null)
   {
      // load data to list from parent javascript object
      paymentList = cpm.paymentMethod;
   }
   //check see if we go back from 'New' or 'update' panel.
   var newPaymentTC=top.getData("newPaymentTC");
   var changeRow=top.getData("changeRow",0);
   if (newPaymentTC != null)
   {
      if (changeRow ==null)
      {
         //alertDialog("Go back from 'new' dialog.");
         paymentList[paymentList.length] = newPaymentTC;
//alertDialog(paymentList.length);
      }
      else
            {
//alertDialog("Go back from 'change' dialog.");
            paymentList[changeRow.rowNum]=newPaymentTC;

              //clear saved changeRow
            //alertDialog ("clear changeRow");
            top.saveData(null,"changeRow");
            }

            //clear saved new payment TC
            top.saveData(null,"newPaymentTC");
      }
  } // end here before
  else
  {
   // this is the first time on this page
   // create the model

   var cpm = new ContractPaymentModel();

   // check if this is an update

   if (<%= foundContractId %> == true || (<%= editingAccount %> == true && <%= foundAccountId %> == true))
   {
      // load the data from the databean

      paymentList = new Array();

       <%
            int j = 0;
      if (foundContractId || (editingAccount && foundAccountId) )
      {
         String tradingId = null;
         if (foundContractId) {
            tradingId = contractId;
         } else {
            tradingId = UIUtil.toHTML(accountId);
         }
         try
         {
         AddressBookTCDataBean bookTcData = new AddressBookTCDataBean(new Long(tradingId), new Integer(fLanguageId), ECContractConstants.EC_ATTR_BILLING);
         DataBeanManager.activate(bookTcData, request);
         if (bookTcData.getHasTC()) {
%>
                     cpm.hasAddressBookTC = true;
                     cpm.addressBookReferenceNumber = '<%= bookTcData.getReferenceNumber() %>';
//alert('loadPanelData load from database');
            cpm.usePersonal = <%= bookTcData.getUsePersonalAddressBook() %>;
                  cpm.useParent = <%= bookTcData.getUseParentOrgAddressBook() %>;
                  cpm.useAccount = <%= bookTcData.getUseAccountAddressBook() %>;
<%
            }

            PaymentTCDataBean ptc = new PaymentTCDataBean(new Long(tradingId), new Integer(fLanguageId));
            com.ibm.commerce.tools.contract.beans.MemberDataBean policyMemberDB = new com.ibm.commerce.tools.contract.beans.MemberDataBean();
              com.ibm.commerce.tools.contract.beans.MemberDataBean addrMemberDB = new com.ibm.commerce.tools.contract.beans.MemberDataBean();
            AccountDataBean adb = new AccountDataBean(new Long(UIUtil.toHTML(accountId)), new Integer(fLanguageId));
            String customerId="";

               try
               {
                  DataBeanManager.activate(adb, request);
               customerId = adb.getCustomerId();

                  addrMemberDB.setId(customerId);
               DataBeanManager.activate(addrMemberDB, request);
            }
               catch (Exception e)
               {
               }

            DataBeanManager.activate(ptc, request);

            String[] pSMID;
            String[] pSMDN;
            String[] pSMDNType;
            String[] pSID;
            String[] paymentPolicyName;
            String[] displayName;
            String[] addressNickName;
            String[] addressMemberId;
            String[] addressMemberDN;
            String[] addressMemberDNType;
            String[] referenceNumber;
            Hashtable[] hashtableAttrs;

            paymentPolicyName = ptc.getPolicyName();
            displayName = ptc.getDisplayName();
            addressNickName = ptc.getAddrNickName();
            addressMemberId = ptc.getAddrMemberID();
            addressMemberDN = ptc.getAddrMemberDN();
            addressMemberDNType = ptc.getAddrMemberDNType();
            referenceNumber = ptc.getReferenceNumber();
            pSMID = ptc.getStoreMemberId();
            pSMDN = ptc.getStoreMemberDN();
            pSMDNType = ptc.getStoreMemberDNType();
            pSID = ptc.getStoreIdentity();
            hashtableAttrs = (Hashtable[]) ptc.getAttrs();

            for (int i=0; i < displayName.length; i++)
            {
             if (!PaymentPolicyListDataBean.isCreditPaymentPolicy(paymentPolicyName[i])) {
                     try
                        {
                           policyMemberDB.setId(pSMID[i]);
                        DataBeanManager.activate(policyMemberDB, request);
                     }
                        catch (Exception e)
                        {
                        }

             %>
            var index = paymentList.length;
               paymentList[index] = new Object();
               paymentList[index].action = "noaction";
               paymentList[index].name = "<%=UIUtil.toJavaScript((String)displayName[i])%>";
               paymentList[index].paymentPolicy = "<%=UIUtil.toJavaScript(paymentPolicyName[i])%>";
               paymentList[index].storeMemberId = "<%=pSMID[i]%>";
               //paymentList[index].storeMemberDN = "<%=UIUtil.toJavaScript((String)pSMDN[i])%>";
               //paymentList[index].storeMemberDNType = "<%=pSMDNType[i]%>";

                     paymentList[index].storeMemberObj = new Member('<%= policyMemberDB.getMemberType() %>',
                                  '<%= UIUtil.toJavaScript(policyMemberDB.getMemberDN()) %>',
                                    '<%= UIUtil.toJavaScript(policyMemberDB.getMemberGroupName()) %>',
                                    '<%= policyMemberDB.getMemberGroupOwnerMemberType() %>',
                                    '<%= UIUtil.toJavaScript(policyMemberDB.getMemberGroupOwnerMemberDN()) %>');

               paymentList[index].storeIdentity = "<%=UIUtil.toJavaScript((String)pSID[i])%>";
               paymentList[index].addressName =  "<%=UIUtil.toJavaScript((String)addressNickName[i])%>";
               paymentList[index].member_id =  "<%=addressMemberId[i]%>";
               //paymentList[index].member_dn =  "<%=UIUtil.toJavaScript((String)addressMemberDN[i])%>";
               paymentList[index].member_obj = new Member('<%= addrMemberDB.getMemberType() %>',
                                    '<%= UIUtil.toJavaScript(addrMemberDB.getMemberDN()) %>',
                                    '<%= UIUtil.toJavaScript(addrMemberDB.getMemberGroupName()) %>',
                                    '<%= addrMemberDB.getMemberGroupOwnerMemberType() %>',
                                    '<%= UIUtil.toJavaScript(addrMemberDB.getMemberGroupOwnerMemberDN()) %>');

               paymentList[index].member_dnType =  "<%=addressMemberDNType[i]%>";
               paymentList[index].referenceNumber =  "<%=referenceNumber[i]%>";
               paymentList[index].atts = new Array();

             <%
               Enumeration names;
               names = (Enumeration) hashtableAttrs[i].keys();
               int k=0;
               while (names.hasMoreElements())
               {
                     String attrName = (String)names.nextElement();
               %>
                  paymentList[index].atts[<%=k%>] = new Object();
                  paymentList[index].atts[<%=k%>].name = "<%=UIUtil.toJavaScript(attrName)%>";
                  paymentList[index].atts[<%=k%>].value = "<%=UIUtil.toJavaScript(hashtableAttrs[i].get(attrName))%>";
               <%
                     k++;
               }
             } // end if credit
           } // end for
         }
         catch (Exception e)
         {
           //out.println(e);
         }
      } // end if found
      %>

      cpm.paymentMethod=paymentList;
      cpm.policyType="<%= policyType %>";
      if (gm != null) {
               cpm.allowCredit=gm.creditLineAllowed;
      }
   } // end if found
   else
   {
      // new contract/account
            // initialize payment list (temp)

            paymentList = new Array();

            cpm.paymentMethod=paymentList;
            cpm.policyType="<%= policyType %>";
            cpm.allowCredit=false;
   }
  } // end here before

  //Just in case
  top.saveData(null,"changeRow");
  parent.parent.put("ContractPaymentModel", cpm);
  parent.parent.put("ContractPaymentModelLoaded", true);

  if (cpm == null)
  {
   //no rows have been entered yet
   numberOfPayment = 0;
   paymentList = new Array();
   alertDialog("Fatal Error: No payment model found!");
  }
  else
  {
   // find out how many rows have been saved
   numberOfPayment = paymentList.length;
  }
  with (document.AllowCreditLineForm)
  {
   AllowCreditLine.disabled=<%=bNotFoundCreditPolicy%>;
  }
  addRowNumbers();
}

function setCreditLineAllowed()
{
  var gm=parent.parent.get("ContractGeneralModel",null);
  if (gm!=null)
  {
    with (document.AllowCreditLineForm)
    {
      gm.creditLineAllowed=AllowCreditLine.checked;
    }
  }
}

function setUsePersonal()
{
//alert('setUsePersonal');
  var pm=parent.parent.get("ContractPaymentModel",null);
  if (pm!=null)
  {
  //alert('setUsePersonal');
    with (document.AddressBookForm)
    {
      pm.usePersonal=usePersonal.checked;
    }
  }
}

function setUseParent()
{
  //alert('setUseParent');
  var pm=parent.parent.get("ContractPaymentModel",null);
  if (pm!=null)
  {
    //alert('setUseParent');
    with (document.AddressBookForm)
    {
      pm.useParent=useParent.checked;
    }
  }
}

function setUseAccount()
{
  //alert('setUseAccount');
  var pm=parent.parent.get("ContractPaymentModel",null);
  if (pm!=null)
  {
    //alert('setUseAccount');
    with (document.AddressBookForm)
    {
      pm.useAccount=useAccount.checked;
    }
  }
}
//-->

</script>
</head>

<!--BODY onload="onLoad();" onUnLoad="savePanelData();"-->
<body onload="onLoad();" class="content_list">

<h1><%= contractsRB.get("contractPaymentTitle") %></h1>

<form NAME="AllowCreditLineForm" id="AllowCreditLineForm">
<input type=checkbox name=AllowCreditLine onClick="setCreditLineAllowed()" id="ContractPaymentList_FormInput_AllowCreditLine_In_AllowCreditLineForm_1"><label for="ContractPaymentList_FormInput_AllowCreditLine_In_AllowCreditLineForm_1"><%= contractsRB.get("contractPaymentAllowCreditLinePrompt") %></label>
</form>

<script LANGUAGE="JavaScript">
<!---- hide script from old browsers
  loadPanelData();
//-->

</script>

<p>
<form NAME="ContractPaymentForm" id="ContractPaymentForm">

<%= comm.startDlistTable((String)contractsRB.get("contractPaymentTitle")) %>
<%= comm.startDlistRowHeading() %>
<%= comm.addDlistCheckHeading() %>
<%= comm.addDlistColumnHeading((String)contractsRB.get("contractPaymentListNameColumn"), null, false) %>
<%= comm.addDlistColumnHeading((String)contractsRB.get("contractPaymentAddressPrompt"), null, false) %>
<%= comm.endDlistRow() %>

<script LANGUAGE="JavaScript">
<!-- hide script from old browsers
  //var startIndex = <%= startIndex %>;
  var startIndex = 0;
  var listSize = <%= listSize %>;
  var endIndex = startIndex + listSize;
  var j = 0;
  if (endIndex > numberOfPayment)
  {
     endIndex = numberOfPayment;
  }
  endIndex = numberOfPayment
  for (var i=startIndex; i<endIndex; i++)
  {
    //alert(paymentList[i].action);
     if (paymentList[i].action != "delete" )
   {
     if (j == 0)
     {
        document.writeln('<TR CLASS="list_row1">');
        j = 1;
     }
     else
     {
        document.writeln('<TR CLASS="list_row2">');
        j = 0;
     }
      addDlistCheck(i, "none" );
      addDlistColumn(paymentList[i].name, "javascript: changePOById('" + i +"')");
         addDlistColumn(paymentList[i].addressName, "none");

      document.writeln('</TR>');
    }
  }
//-->

</script>

<%= comm.endDlistTable() %>

<script LANGUAGE="JavaScript">
<!---- hide script from old browsers
if (numberOfPayment == 0)
{
   document.writeln('<br>');
   document.writeln('<%= UIUtil.toJavaScript((String)contractsRB.get("contractPaymentListEmpty")) %>');
}
//-->

</script>

</form>
</p>
<br /><br /><br /><br />
<p>
<form NAME="AddressBookForm" id="AddressBookForm">
<br /><br />
<label for="ContractBillingAddressSelectionPanel_FormInput_contractBillingAddressBookDescription_In_addressForm_1"><%= contractsRB.get("contractBillingAddressBookDescription") %></label><br /><br />
<input NAME="usePersonal" onclick="setUsePersonal()" TYPE="CHECKBOX" id="ContractBillingAddressSelectionPanel_FormInput_usePersonal_In_infoForm_1"><label for="ContractBillingAddressSelectionPanel_FormInput_usePersonal_In_infoForm_1"><%= contractsRB.get("contractShippingAddressBookPersonal") %></label><br>
<input NAME="useParent"   onclick="setUseParent()" TYPE="CHECKBOX" id="ContractBillingAddressSelectionPanel_FormInput_useParent_In_infoForm_1"><label for="ContractBillingAddressSelectionPanel_FormInput_useParent_In_infoForm_1"><%= contractsRB.get("contractShippingAddressBookParent") %></label><br>
<input NAME="useAccount"  onclick="setUseAccount()" TYPE="CHECKBOX" id="ContractBillingAddressSelectionPanel_FormInput_useAccount_In_infoForm_1"><label for="ContractBillingAddressSelectionPanel_FormInput_useAccount_In_infoForm_1"><%= contractsRB.get("contractShippingAddressBookAccount") %></label>
</form>
</p>

<script LANGUAGE="JavaScript">
<!---- hide script from old browsers
  setAddressBookForm();
  parent.afterLoads();
  parent.setResultssize(getResultsize());
  //adjust button frame position to line up it with base frame
  parent.setButtonPos('0px','92px');
//-->

</script>

</body>

</html>
