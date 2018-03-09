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
   com.ibm.commerce.user.beans.AddressDataBean,
   com.ibm.commerce.tools.contract.beans.*,
   com.ibm.commerce.tools.contract.beans.AddressListDataBean" %>

<%@ include file="../common/common.jsp" %>
<%@ include file="ContractCommon.jsp" %>

<%
   AddressListDataBean addressList = new AddressListDataBean();
   AddressDataBean address[] = null;
   int numberOfAddress = 0;
   Long fAccountHolderMemberId = null;

   try
   {

     AccountDataBean account = new AccountDataBean(new Long(accountId), new Integer(fLanguageId));
    DataBeanManager.activate(account, request);
    fAccountHolderMemberId = new Long(account.getCustomerId());

     addressList.setMemberId(fAccountHolderMemberId);
     DataBeanManager.activate(addressList, request);
     address = addressList.getAddressList();
     if (address != null)
     {
       numberOfAddress = address.length;
     }
   }
   catch (Exception e)
   {
     //System.out.println("exception");
   }
%>

<html>
<head>
<%= fHeader %>
<link rel="stylesheet" href="<%= UIUtil.getCSSFile(fLocale) %>" type="text/css">
<title><%= contractsRB.get("contractPaymentFormAddressSelectionPanelTitle") %></title>
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


<script LANGUAGE="JavaScript">
<!---- hide script from old browsers
var fAccountHolderMemberId = "<%=fAccountHolderMemberId%>";
function showBlank(flag)
{
  if (flag)
  {
    addressDIV.style.display = "none";
    if (defined(parent.addressDetailBody.showBlankLoadingDetail))
     {
      parent.addressDetailBody.showBlankLoadingDetail("Blank");
    }
  }
  else
  {
    addressDIV.style.display = "block";
    if (defined(parent.addressDetailBody.showBlankLoadingDetail))
    {
      parent.addressDetailBody.showBlankLoadingDetail("Detail");
    }
  }
}

function onload()
{
  var changeRow=top.getData("changeRow",1);
  if (changeRow!=null)
  {
    var addressName = changeRow.addressName;
    if (addressName != null && addressName!="")
    {
      for (var i=0; i < <%=numberOfAddress %>+1; i++)
      {
        if (document.addressForm.paymentAddress.options[i].text==addressName)
        {
          document.addressForm.paymentAddress.options[i].selected=true;
          return;
        }
      }
    }
  }
}

-->

</script>

</head>

<body class="content" onLoad="onload();">

<div id="addressDIV" style="display: none">
<form name="addressForm" id="addressForm">
<p><label for="ContractPaymentDialogAddressSelectionPanel_FormInput_paymentAddress_In_addressForm_1"><%= contractsRB.get("contractPaymentAddressPrompt") %></label><br>
<select id="ContractPaymentDialogAddressSelectionPanel_FormInput_paymentAddress_In_addressForm_1" name="paymentAddress" onChange="parent.AddressFormDetailChange();">
  <option value=""><%= contractsRB.get("contractPaymentFormAddressSelectionPanelNoAddress")%></option>
   <%
     AddressDataBean addressDb;
     int count = 0;
     for ( int i = 0; i < numberOfAddress; i++)
     {
       //Long idValue = new Long(address[i].getAddressId());

       // check if the address is not the default address
       //if (idValue.longValue() >= 0) {
         addressDb = address[i];
   %>
         <option value="<%= addressDb.getAddressId() %>"><%= addressDb.getNickName() %></option>
   <%
       //} else {
       //  count++;
       //}
     }
     numberOfAddress = numberOfAddress - count;
  %>
</select>

</form>
</div>
<script LANGUAGE="JavaScript">
parent.AddressFormDetailChange();

</script>
</body>

</html>
