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
   com.ibm.commerce.beans.DataBeanManager,
   com.ibm.commerce.datatype.TypedProperty,
   com.ibm.commerce.payment.beans.*,
   com.ibm.commerce.common.objects.*,
   com.ibm.commerce.server.*,
   com.ibm.commerce.user.beans.*,
   com.ibm.commerce.tools.contract.beans.PolicyDataBean,
   com.ibm.commerce.tools.contract.beans.PolicyListDataBean" %>

<%@ include file="../common/common.jsp" %>
<%@ include file="ContractCommon.jsp" %>

<%
   int numberOfPolicy = 0;

   Integer storeId= contractCommandContext.getStoreId();
   PaymentPolicyListDataBean policyList = new PaymentPolicyListDataBean();
  policyList.setStoreId(storeId);
  String storeEntityId = new String("");
  String pPStoreMemberId = new String("");
  String pPStoreIdentity = new String("");

%>

<html>

<head>
<%= fHeader %>
<link rel="stylesheet" href="<%= UIUtil.getCSSFile(fLocale) %>" type="text/css">
<title><%= contractsRB.get("contractPaymentFormSelectionPanelTitle") %></title>
<script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/contract/ContractUtil.js">
</script>
<script LANGUAGE="JavaScript">
<!---- hide script from old browsers

var policyNameArray = new Array();
var policyDescArray = new Array();
var brandArray = new Array();
var snipFileNameArray = new Array();
var policyStoreIdentity = new Array();
var policyStoreMemberId = new Array();
var policyStoreMemberObj = new Array();

function onload()
{
  <%
  String sMsg= new String("GeneralPleaseSpecify");
   try
   {
     DataBeanManager.activate(policyList, request);
    PaymentPolicyInfo[] nonPMPolicyInfo = policyList.getNonPMPaymentPolicyInfo();
    PaymentPolicyInfo[] policyInfo      = policyList.getPMPaymentPolicyInfo();
    Exception exc = policyList.getPaymentSystemException();

    int i=0;
    com.ibm.commerce.tools.contract.beans.MemberDataBean policyMemberDB = new com.ibm.commerce.tools.contract.beans.MemberDataBean();
     for ( i=0; i < policyInfo.length; i++)
     {
       storeEntityId = policyInfo[i].getStoreEntityId();

       StoreAccessBean abStore2 = StoreRegistry.singleton().find(new Integer(storeEntityId));
       if (abStore2 != null) {
   	    pPStoreMemberId = abStore2.getMemberId();
	    pPStoreIdentity = abStore2.getIdentifier();   
       } else {
	    StoreEntityAccessBean abStoreEnt2 = new StoreEntityAccessBean();
	    abStoreEnt2.setInitKey_storeEntityId(storeEntityId);
   	    pPStoreMemberId = abStoreEnt2.getMemberId();
	    pPStoreIdentity = abStoreEnt2.getIdentifier();  
       }

      try
      {
        policyMemberDB.setId(pPStoreMemberId);
        DataBeanManager.activate(policyMemberDB, request);
      }
      catch (Exception e)
      {
      }
       String ld = policyInfo[i].getLongDescription();
       if (ld == null || ld.length() == 0)
         ld = policyInfo[i].getPolicyName();
   %>
       policyStoreMemberObj[<%=i%>]= new Member('<%= policyMemberDB.getMemberType() %>',
                                 '<%= UIUtil.toJavaScript(policyMemberDB.getMemberDN()) %>',
                                 '<%= UIUtil.toJavaScript(policyMemberDB.getMemberGroupName()) %>',
                                 '<%= policyMemberDB.getMemberGroupOwnerMemberType() %>',
                                 '<%= UIUtil.toJavaScript(policyMemberDB.getMemberGroupOwnerMemberDN()) %>');
       policyStoreMemberId[<%=i%>]="<%=pPStoreMemberId%>";
       policyStoreIdentity[<%=i%>]="<%=UIUtil.toJavaScript(pPStoreIdentity)%>";

       policyNameArray[<%=i%>]="<%=UIUtil.toJavaScript(policyInfo[i].getPolicyName())%>";
       policyDescArray[<%=i%>]="<%=UIUtil.toJavaScript(ld)%>";
       brandArray[<%=i%>]="<%=UIUtil.toJavaScript(policyInfo[i].getBrand())%>";
       snipFileNameArray[<%=i%>]="<%=UIUtil.toJavaScript(policyInfo[i].getAttrPageName())%>";
   <%
        numberOfPolicy++;
     }
     int k=i;
     for (int j=k; j < k+nonPMPolicyInfo.length ; j++)
     {
       //always filter out the credit and void checkout policies.
       if (!PaymentPolicyListDataBean.isCreditPaymentPolicy(nonPMPolicyInfo[j-k].getPolicyName()) && !nonPMPolicyInfo[j-k].getPolicyName().equals(PaymentPolicyListDataBean.POLICY_NAME_VOID_CHECKOUT))
      {
       storeEntityId = nonPMPolicyInfo[j-k].getStoreEntityId();

       StoreAccessBean abStore3 = StoreRegistry.singleton().find(new Integer(storeEntityId));
       if (abStore3 != null) {
   	    pPStoreMemberId = abStore3.getMemberId();
	    pPStoreIdentity = abStore3.getIdentifier();   
       } else {
	    StoreEntityAccessBean abStoreEnt3 = new StoreEntityAccessBean();
	    abStoreEnt3.setInitKey_storeEntityId(storeEntityId);
   	    pPStoreMemberId = abStoreEnt3.getMemberId();
	    pPStoreIdentity = abStoreEnt3.getIdentifier();  
       }

        try
        {
          policyMemberDB.setId(pPStoreMemberId);
          DataBeanManager.activate(policyMemberDB, request);
        }
        catch (Exception e)
        {
        }
             String ld = nonPMPolicyInfo[j-k].getLongDescription();
       if (ld == null || ld.length() == 0)
         ld = nonPMPolicyInfo[j-k].getPolicyName();
   %>
       policyStoreMemberObj[<%=i%>]= new Member('<%= policyMemberDB.getMemberType() %>',
                                 '<%= UIUtil.toJavaScript(policyMemberDB.getMemberDN()) %>',
                                 '<%= UIUtil.toJavaScript(policyMemberDB.getMemberGroupName()) %>',
                                 '<%= policyMemberDB.getMemberGroupOwnerMemberType() %>',
                                 '<%= UIUtil.toJavaScript(policyMemberDB.getMemberGroupOwnerMemberDN()) %>');

       policyStoreMemberId[<%=i%>]="<%=pPStoreMemberId%>";
       policyStoreIdentity[<%=i%>]="<%=UIUtil.toJavaScript(pPStoreIdentity)%>";

       policyNameArray[<%=i%>]="<%=UIUtil.toJavaScript(nonPMPolicyInfo[j-k].getPolicyName())%>";
       policyDescArray[<%=i%>]="<%=UIUtil.toJavaScript(ld)%>";
       brandArray[<%=i%>]="<%=UIUtil.toJavaScript(nonPMPolicyInfo[j-k].getBrand())%>";
         snipFileNameArray[<%=i%>]="<%=UIUtil.toJavaScript(nonPMPolicyInfo[j-k].getAttrPageName())%>";
         <% i++; %>

   <%
         numberOfPolicy++;
       }
     }
   }
  catch (Exception e)
  {
    //System.out.println(e);
  }
  if (numberOfPolicy!=0) sMsg= new String("GeneralPleaseSpecify");
  if (numberOfPolicy==0 && sMsg.equals("GeneralPleaseSpecify")) sMsg = new String("contractPaymentFormPMNoPolicy");


   //temp
   //numberOfPolicy=1;
%>

  for (var i = 0; i< policyNameArray.length; i++)
  {
    document.paymentForm.PaymentPolicy.options[i+1] = new Option(policyDescArray[i], policyNameArray[i], false, false);
  }

  var changeRow=top.getData("changeRow",1);
  if (changeRow!=null)
  {
    //display name
    document.paymentForm.PaymentName.value=changeRow.name;
    var brand="";
    if (changeRow.atts != null)
    {
      for (var i=0; i < changeRow.atts.length; i++)
      {
        if (changeRow.atts[i].name == "<%= ECConstants.EC_CC_TYPE %>")
        {
          brand = changeRow.atts[i].value;
          break;
        }
      }
    }
    for (var i=0; i < <%=numberOfPolicy %>; i++)
    {
      if (policyStoreMemberId[i]==changeRow.storeMemberId && policyStoreIdentity[i]==changeRow.storeIdentity)
      {
        if (brand == "")
        {
          if (document.paymentForm.PaymentPolicy.options[i+1].value==changeRow.paymentPolicy)
          {
            document.paymentForm.PaymentPolicy.options[i+1].selected=true;
            return;
          }
        }
        else
        {
     if (brandArray[i] == "" && policyNameArray[i]==changeRow.paymentPolicy)
     {
      document.paymentForm.PaymentPolicy.options[i+1].selected=true;
               return;
     }
     else
          if (policyNameArray[i]==changeRow.paymentPolicy && brandArray[i] == brand)
          {
            document.paymentForm.PaymentPolicy.options[i+1].selected=true;
            return;
          }
        }
      }
    }
  }
}


function paymentFormDetailChange()
{
  with (document.paymentForm)
  {
    var selectedIndex= PaymentPolicy.selectedIndex -1;
    if (selectedIndex >=0 && snipFileNameArray[selectedIndex]!="")
    {
      var paymentPolicy = snipFileNameArray[selectedIndex] + ".jsp&cardBrand=" + brandArray[selectedIndex];
      parent.paymentFormDetailChange(paymentPolicy);
    }
    else if (selectedIndex >=0 && snipFileNameArray[selectedIndex]=="")
      parent.paymentFormDetailChange("NOATTRPAGE");
    else
      parent.paymentFormDetailChange("");
  }
}
-->

</script>
</head>
<body onLoad="parent.loadPanelData();onload();paymentFormDetailChange();" class="content">
<script>
  var changeRow=top.getData("changeRow",1);
  if (changeRow!=null)
   document.writeln('<h1><%= UIUtil.toJavaScript((String)contractsRB.get("contractPaymentDialogChangeTitle")) %></h1>');
  else
   document.writeln('<h1><%= UIUtil.toJavaScript((String)contractsRB.get("contractPaymentDialogAddTitle")) %></h1>');

</script>
<form name="paymentForm" id="paymentForm">
<p><label for="ContractPaymentDialogPaymentPolicySelectionPanel_FormInput_PaymentPolicy_In_paymentForm_1"><%= contractsRB.get("contractPaymentPolicyPrompt") %></label><br>
<!-- this list should comes from policy databean -->
<select id="ContractPaymentDialogPaymentPolicySelectionPanel_FormInput_PaymentPolicy_In_paymentForm_1" name="PaymentPolicy" onChange="paymentFormDetailChange();">
  <option value=""><%=contractsRB.get(sMsg)%></option>
</select>
<p><label for="ContractPaymentDialogPaymentPolicySelectionPanel_FormInput_PaymentName_In_paymentForm_1"><%= contractsRB.get("contractPaymentDisplayNamePrompt") %></label><br>
<input type="text" name="PaymentName" size="30" maxlength=254 id="ContractPaymentDialogPaymentPolicySelectionPanel_FormInput_PaymentName_In_paymentForm_1">
</form>
<script LANGUAGE="JavaScript">
parent.AddressFormDetailChange();

</script>
</body>
</html>
