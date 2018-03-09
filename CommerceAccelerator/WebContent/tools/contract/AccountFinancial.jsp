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
<%@page language="java"
import="com.ibm.commerce.beans.DataBeanManager,
	com.ibm.commerce.tools.contract.beans.AccountDataBean,
	com.ibm.commerce.tools.util.UIUtil" %>

<%@include file="../common/common.jsp" %>
<%@include file="ContractCommon.jsp" %>

<html>

<head>
 <%= fHeader %>
 <link rel="stylesheet" href="<%= UIUtil.getCSSFile(fLocale) %>" type="text/css">

 <title><%= contractsRB.get("accountFinancialFormPanelTitle") %></title>
 <script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/Util.js">
</script>

 <script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/contract/Account.js">
</script>
 <script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/contract/AccountFinancial.js">
</script>

 <script LANGUAGE="JavaScript">

function loadPanelData()
{
  //alert ('financial LoadPanelData');
  var o = parent.get("AccountCustomerModel", null);
  var org = "";
  if (o!=null)
  {
    org=o.org;
  }
  selectionBody.location.replace("AccountFinancialPanelView?org="+org+"&accountId=<%=UIUtil.toJavaScript(accountId)%>");
}

function getDetailFormData ()
{
	atts = new Array();
  var j=0;
	if (defined(selectionBody.document.financialFormDetail))
	{
  	with (selectionBody.document.financialFormDetail)
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

function validateFinancialPanel()
{
  var atts=getDetailFormData();
	if (validatePanelData() && validateDynamicForm(atts))
  {
    return true;
  }
  else
  {
    return false;
  }
}

function validatePanelData()
{
  var displayName = selectionBody.document.financialForm.FinancialName.value;
  
  if (displayName=="" || displayName == null)
  {
    alertDialog("<%= UIUtil.toJavaScript((String)contractsRB.get("accountFinancialFormInvalidDisplayName"))%>");
    selectionBody.document.financialForm.FinancialName.focus();
    return false;
  }

  return true;    
}

function validateDynamicForm(atts)
{
  //return true;
  //alertDialog(convertToXML(atts));
  if ((atts!=null) && (atts.length!=0))
  { 
    //var j=0;
    for (var i=0; i<atts.length; i++)
    {
      //The following code assume all fields inside the form are required.
      
      if (atts[i].value=="")
      {
        alertDialog ("<%=UIUtil.toJavaScript((String)contractsRB.get("accountFinancialFormMissValue"))%>");
        return false;
      }
      /*
      if ((atts[i].name=="cardNumber") && !parent.isValidNumber(atts[i].value, <%=fLanguageId%>))
      {
        //alertDialog(parent.isValidNumber(atts[i].value, <%=fLanguageId%>));
        alertDialog ("<%=UIUtil.toJavaScript((String)contractsRB.get("contractPaymentFormInvalidCardNumber"))%>");
        detailBody.document.financialFormDetail.cardNumber.focus();
        return false;
      }
      */
      
      //Give user a warning meesage if he input nothing.
      /*
      if (atts[i].value=="")
      {
        j++;
      }
      */
    }
    //Give user a warning meesage if he input nothing.
    /*
    if (j==atts.length)
    {
      return confirmDialog ("<%=UIUtil.toJavaScript((String)contractsRB.get("accountFinancialFormMissAllValues"))%>");
    }
    */
  }
  return true;
}

function savePanelData()
{
  //alert ('financial savePanelData');
  var atts=getDetailFormData();
  var afm=parent.get("AccountFinancialModel",null);
  if (afm!=null)
  {
    with (selectionBody.document)
    {
      afm.allowCredit=financialForm.AllowCredit.checked;
      afm.displayName=financialForm.FinancialName.value;

      if(financialFormAddress.FinancialAddress.selectedIndex!=0)
        afm.addressName=financialFormAddress.FinancialAddress.options[financialFormAddress.FinancialAddress.selectedIndex].text;
      else
        afm.addressName="";

      afm.atts=atts;
      parent.put("AccountFinancialModel",afm);
    }
  }
}

function AddressFormDetailChange (tag)
{
	if (!tag)
	{
	  address="AccountFinancialAddressDetailPanelView";
  	AccountFinancialAddressDetailBody.location.replace(address);
	}
	else
	{
  	var address = selectionBody.document.financialFormAddress.FinancialAddress.options[selectionBody.document.financialFormAddress.FinancialAddress.selectedIndex].value;
  	if ((address == "") || (address == null))
  	{
  	  address="AccountFinancialAddressDetailPanelView";
  	  AccountFinancialAddressDetailBody.location.replace(address);
  	}
  	else
  	{
	  	if (defined(AccountFinancialAddressDetailBody.showLoadingMsg))
	  	{
	  	  AccountFinancialAddressDetailBody.showLoadingMsg(true);
	  	}
	  	if (parent.setContentFrameLoaded)
      {
        parent.setContentFrameLoaded(false);
      }
  	  AccountFinancialAddressDetailBody.location.replace("AccountFinancialAddressDetailPanelView?AddressId=" + address);
  	}
  }
}


function visibleList (s)
{
	if (defined(this.selectionBody) == false || this.selectionBody.document.readyState != "complete") {
		return;
	}

	if (defined(this.selectionBody.visibleList)) {
		this.selectionBody.visibleList(s);
		return;
	}

  for (var j=0;j<3;j++)
  {
  	if (defined(this.selectionBody.document.forms[j])) {
  		for (var i = 0; i < this.selectionBody.document.forms[j].elements.length; i++) {
  			if (this.selectionBody.document.forms[j].elements[i].type.substring(0,6) == "select") {
  				this.selectionBody.document.forms[j].elements[i].style.visibility = s;
  			}
  		}
  	}
  }
}


</script>

</head>

<frameset rows="300,*" frameborder="no" border="0" framespacing="0">
	<!-- frame src="AccountFinancialPanelView" title="<%= UIUtil.toJavaScript(contractsRB.get("accountFinancialFormPanelTitle")) %>" name="selectionBody" scrolling="auto" noresize -->
	<frame src="/wcs/tools/common/blank.html" title="<%= UIUtil.toJavaScript(contractsRB.get("accountFinancialFormPanelTitle")) %>" name="selectionBody" scrolling="auto" noresize>
	<frame src="AccountFinancialAddressDetailPanelView" title="<%= UIUtil.toJavaScript(contractsRB.get("accountFinancialAddressDetailPanelTitle")) %>" name="AccountFinancialAddressDetailBody" scrolling="auto" noresize>
</frameset>

<script LANGUAGE="JavaScript">
//alert ("ok");
loadPanelData();

</script>

</html>


