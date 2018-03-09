<!--==========================================================================
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2001, 2010
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
//*
  ===========================================================================-->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2014 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%@ page language="java"
   import="com.ibm.commerce.tools.util.UIUtil,
   com.ibm.commerce.beans.DataBeanManager,
   com.ibm.commerce.datatype.TypedProperty,
   com.ibm.commerce.payment.beans.*,
   com.ibm.commerce.server.*,
   com.ibm.commerce.user.beans.AddressDataBean,
   com.ibm.commerce.user.beans.*,
   com.ibm.commerce.tools.contract.beans.AddressListDataBean,
   com.ibm.commerce.common.objects.*,
   com.ibm.commerce.common.beans.StoreDataBean,
   com.ibm.commerce.tools.contract.beans.AccountDataBean,
   com.ibm.commerce.tools.contract.beans.PaymentTCDataBean" %>

<%@ include file="../common/common.jsp" %>
<%@ include file="ContractCommon.jsp" %>

<%
   String  fAccountHolderMemberId = "";
   String  storeMemberType="";

   TypedProperty requestProperties = (TypedProperty)request.getAttribute("RequestProperties");
   if (requestProperties != null) {
      fAccountHolderMemberId = UIUtil.toHTML((String)requestProperties.getString("org"));
   }
%>

<%
  //foundAccountId=true;
  //accountId=new String("10151");
  //fAccountHolderMemberId = "10";


  CommandContext cmdContext = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
  Locale jLocale = cmdContext.getLocale();
  Hashtable paymentBuyPagesNLS = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("order.paymentBuyPagesNLS", jLocale);

  Integer storeId= contractCommandContext.getStoreId();
  PaymentPolicyListDataBean policyList = new PaymentPolicyListDataBean();
  policyList.setStoreId(storeId);

  //the follow line lets policyList only returns credit payment policy
  policyList.setFindCreditLinePolicy(true);

  String policyName = new String("");
  String policyDesc = new String("");
  String snipFileName = new String("");
  String paymentPolicy = new String("");
  String storeEntityId = new String("");

  int bGetPolicy=0;
  try {
    DataBeanManager.activate(policyList, request);
    PaymentPolicyInfo[] nonPMPolicyInfo = policyList.getNonPMPaymentPolicyInfo();

    if(nonPMPolicyInfo.length >0)
    {
      policyName=nonPMPolicyInfo[0].getPolicyName();
      policyDesc=nonPMPolicyInfo[0].getLongDescription();
      snipFileName=nonPMPolicyInfo[0].getAttrPageName();
      storeEntityId = nonPMPolicyInfo[0].getStoreEntityId();
    } else {
      storeEntityId = fStoreId.toString();
    }
  }
  catch (Exception e)
  {
    //System.out.println("exception");
    storeEntityId = fStoreId.toString();
  }

  String pPStoreMemberId = new String("");
  String pPStoreMemberDN = new String("");
  String pPStoreIdentity = new String("");

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

  //for policy reference member obj
  com.ibm.commerce.tools.contract.beans.MemberDataBean policyMemberDB = new com.ibm.commerce.tools.contract.beans.MemberDataBean();
  try
  {
    policyMemberDB.setId(pPStoreMemberId);
    DataBeanManager.activate(policyMemberDB, request);
  }
  catch (Exception e)
  {
  }


  String memberDN = new String("");

  //OrgEntityDataBean OrgEntityDB = new OrgEntityDataBean();
  com.ibm.commerce.tools.contract.beans.MemberDataBean addrMemberDB = new com.ibm.commerce.tools.contract.beans.MemberDataBean();
  if (!fAccountHolderMemberId.equals(""))
  {

    try
    {
      addrMemberDB.setId(fAccountHolderMemberId);
      DataBeanManager.activate(addrMemberDB, request);
    }
    catch (Exception e)
    {
    }
   /*
    try
    {
     OrgEntityDB.setDataBeanKeyMemberId(fAccountHolderMemberId);
     DataBeanManager.activate(OrgEntityDB, request);
     memberDN = (OrgEntityDB.getDistinguishedName().toString()).trim();
   }
   catch (Exception e)
   {
   }
   */
  }

  AddressDataBean address[] = null;
  paymentPolicy = "../order/buyPages/" + snipFileName +".jsp";
  AddressListDataBean addressList = new AddressListDataBean();
  //String addressType = addressList.TYPE_BILLTO;
  int numberOfAddress = 0;
  //Long memberId = new Long(-1000);


  if (!policyName.equals("") && !snipFileName.equals(""))
  {
    bGetPolicy=1;
    //memberId = contractCommandContext.getUserId();
    if (!fAccountHolderMemberId.equals(""))
    {
      try
      {
          //AccountDataBean account = new AccountDataBean(new Long(accountId), new Integer(fLanguageId));
          //DataBeanManager.activate(account, request);
          //fAccountHolderMemberId = new Long(account.getCustomerId());

          addressList.setMemberId(new Long(fAccountHolderMemberId));


        //addressList.setMemberId(memberId);
        //addressList.setAddressType(addressType);
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
    }
  }
  else
  {
    paymentPolicy = "";
  }
  
    StoreDataBean storeBean = new StoreDataBean();
    storeBean.setStoreId(fStoreId.toString());
    com.ibm.commerce.beans.DataBeanManager.activate(storeBean, request);
%>

<html>
<script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/Util.js">
</script>
<script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/FieldEntryUtil.js">
</script>
<script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/Vector.js">
</script>
<script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/ConvertToXML.js">
</script>

<script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/contract/AccountFinancial.js">
</script>
<script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/contract/ContractUtil.js">
</script>

<script LANGUAGE="JavaScript">
<!--
function snipJSPOnChange(name)
{
  return;
}

function onload ()
{
  if (parent.parent.setContentFrameLoaded)
  {
    parent.parent.setContentFrameLoaded(true);
  }


  if (!parent.parent.get)
  {
    alertDialog('No model found!');
    return;
  }

  var hereBefore = parent.parent.get("AccountFinancialModelLoaded", null);

  //alertDialog(hereBefore);
  if (hereBefore)
  {
   // have been to this page before - load from the model
   //alertDialog("have been here before, load data from the model");
   var afm = parent.parent.get("AccountFinancialModel", null);
   if (afm != null && <%=bGetPolicy%>==1)
   {
      // load data to list from parent javascript object
      // paymentList = cpm.paymentMethod;
      with(document)
      {
              for (var k=0; k< financialFormAddress.FinancialAddress.options.length; k++)
              {
                if (financialFormAddress.FinancialAddress.options[k].text==afm.addressName)
                {
                  financialFormAddress.FinancialAddress.options[k].selected=true;
                  k = financialFormAddress.FinancialAddress.options.length;
                }
              }
              financialForm.FinancialName.value=afm.displayName;
              financialForm.AllowCredit.checked=afm.allowCredit;
              showDivisions();
           }

      var atts = afm.atts;
           if (atts != null)
      {
              putValueBackToForm(atts);
      }//end if atts
   }
  }
  else
  {
   // this is the first time on this page
    //alertDialog("First time here, create the model.");
   // create the model

   var afm = new AccountFinancialModel();

   // check if this is an update

   if (<%=foundAccountId%> == true)
   {
      // load the data from the databean
    <%
        int j = 0;

      if (foundAccountId)
      {
         try
         {
               PaymentTCDataBean ptc = new PaymentTCDataBean(new Long(accountId), new Integer(fLanguageId));
            DataBeanManager.activate(ptc, request);

            String[] paymentPolicyName;
               String[] displayName;
               String[] addressNickName;
               String[] addressMemberId;
            String[] referenceNumber;
               Hashtable[] hashtableAttrs;

            paymentPolicyName = ptc.getPolicyName();
            displayName = ptc.getDisplayName();
            addressNickName = ptc.getAddrNickName();
            addressMemberId = ptc.getAddrMemberID();
            referenceNumber = ptc.getReferenceNumber();
            hashtableAttrs = (Hashtable[]) ptc.getAttrs();

            boolean foundCredit = false;
            if(displayName.length > 0)
            {
              for (int loop=0; loop < displayName.length; loop++)
              {
               if (PaymentPolicyListDataBean.isCreditPaymentPolicy(paymentPolicyName[loop])) {
                foundCredit = true;
    %>
                afm.allowCredit=true;
                afm.action = "noaction";
                afm.displayName = "<%=UIUtil.toJavaScript((String)displayName[loop])%>";
                afm.policyName = "<%=UIUtil.toJavaScript(paymentPolicyName[loop])%>";
    <%
                if(addressNickName.length > 0)
                {
    %>
                     afm.addressName =  "<%=UIUtil.toJavaScript((String)addressNickName[loop])%>";
    <%
                } else {
    %>
                  afm.addressName="";
    <%
                }
                if (addressNickName.length > 0 && addressNickName[loop] != "")
                {
                     try
                     {
                         addrMemberDB.setId(addressMemberId[loop]);
                         DataBeanManager.activate(addrMemberDB, request);
                      }
                      catch (Exception e)
                      {
                      }
               }
    %>
                 if (afm.addressName=="") //no address specified in tc
                 {
                     afm.memberID =  "<%=fAccountHolderMemberId%>";
                 }
                 else
                 {
                     afm.memberID =  "<%=addressMemberId[loop]%>";
                 }
               afm.referenceNumber = "<%=referenceNumber[loop]%>";
                  afm.storeMemberType="<%=storeMemberType%>";
                 afm.pPStoreMemberId = "<%=pPStoreMemberId%>";
                 afm.pPStoreIdentity = "<%=UIUtil.toJavaScript((String)pPStoreIdentity)%>";

                 //address member obj
                 afm.addrMemberObj = new Member('<%= addrMemberDB.getMemberType() %>',
                                 '<%= UIUtil.toJavaScript(addrMemberDB.getMemberDN()) %>',
                                 '<%= UIUtil.toJavaScript(addrMemberDB.getMemberGroupName()) %>',
                                 '<%= addrMemberDB.getMemberGroupOwnerMemberType() %>',
                                 '<%= UIUtil.toJavaScript(addrMemberDB.getMemberGroupOwnerMemberDN()) %>');

                 //policy member obj
                 afm.policyMemberObj = new Member('<%= policyMemberDB.getMemberType() %>',
                                 '<%= UIUtil.toJavaScript(policyMemberDB.getMemberDN()) %>',
                                 '<%= UIUtil.toJavaScript(policyMemberDB.getMemberGroupName()) %>',
                                 '<%= policyMemberDB.getMemberGroupOwnerMemberType() %>',
                                 '<%= UIUtil.toJavaScript(policyMemberDB.getMemberGroupOwnerMemberDN()) %>');


                 //afm.pPStoreMemberDN = "<%=UIUtil.toJavaScript((String)pPStoreMemberDN)%>";
                 //afm.memberDN = "<%=UIUtil.toJavaScript((String)memberDN)%>";

               afm.atts = new Array();

               <%
               Enumeration names;
               names = hashtableAttrs[loop].keys();
               int k=0;
               while (names.hasMoreElements())
               {
                     String attrName = (String)names.nextElement();
               %>
                  afm.atts[<%=k%>] = new Object();
                  afm.atts[<%=k%>].name = "<%=UIUtil.toJavaScript(attrName)%>";
                  afm.atts[<%=k%>].value = "<%=UIUtil.toJavaScript((String)hashtableAttrs[loop].get(attrName))%>";
               <%
                     k++;
               }
               %>
               if (afm != null && <%=bGetPolicy%>==1)
               {
                  // load data to list from parent javascript object
                  // paymentList = cpm.paymentMethod;
                  with(document)
                    {
                            for (var k=0; k< financialFormAddress.FinancialAddress.options.length; k++)
                            {
                              if (financialFormAddress.FinancialAddress.options[k].text==afm.addressName)
                              {
                                financialFormAddress.FinancialAddress.options[k].selected=true;
                                k = financialFormAddress.FinancialAddress.options.length;
                              }
                            }
                            financialForm.FinancialName.value=afm.displayName;
                            financialForm.AllowCredit.checked=afm.allowCredit;
                            showDivisions();
                    }

                  var atts = afm.atts;
                    if (atts != null)
                    {
                            putValueBackToForm(atts);
                    }//end if atts
               }
          <%
               } // end if credit
               } // end for
           } // end displayName length
           if (!foundCredit)
           {
     %>
                  afm.allowCredit=false;
                  afm.memberID =  "<%=fAccountHolderMemberId%>";
                  afm.memberDN="<%=UIUtil.toJavaScript((String)memberDN)%>";
                  afm.storeID="<%=storeId%>";
                   afm.referenceNumber="";
                   afm.policyName="<%=UIUtil.toJavaScript(policyName)%>";
                  afm.pPStoreMemberId = "<%=pPStoreMemberId%>";
                  afm.pPStoreMemberDN = "<%=UIUtil.toJavaScript((String)pPStoreMemberDN)%>";
                  afm.pPStoreIdentity = "<%=UIUtil.toJavaScript((String)pPStoreIdentity)%>";
                afm.storeMemberType="<%=storeMemberType%>";

                  //for address member obj

                  afm.addrMemberObj = new Member('<%= addrMemberDB.getMemberType() %>',
                                 '<%= UIUtil.toJavaScript(addrMemberDB.getMemberDN()) %>',
                                 '<%= UIUtil.toJavaScript(addrMemberDB.getMemberGroupName()) %>',
                                 '<%= addrMemberDB.getMemberGroupOwnerMemberType() %>',
                                 '<%= UIUtil.toJavaScript(addrMemberDB.getMemberGroupOwnerMemberDN()) %>');

                  //policy member obj
                  afm.policyMemberObj = new Member('<%= policyMemberDB.getMemberType() %>',
                                 '<%= UIUtil.toJavaScript(policyMemberDB.getMemberDN()) %>',
                                 '<%= UIUtil.toJavaScript(policyMemberDB.getMemberGroupName()) %>',
                                 '<%= policyMemberDB.getMemberGroupOwnerMemberType() %>',
                                 '<%= UIUtil.toJavaScript(policyMemberDB.getMemberGroupOwnerMemberDN()) %>');

                  afm.action="new";
                  afm.allowCredit=false;
                   afm.displayName = "";
                afm.addressName = "";
                var atts = new Array();
                afm.atts = atts;
           <%
           } // end foundCredit
            }
         catch (Exception e)
         {
           //out.println(e);
         }
      } // foundAccountId java
   %>

   // I think this is wrong afm.allowCredit=false;
   } // foundAccountId javascript
   else
   {
      // this is a new account
         afm.memberID="<%=fAccountHolderMemberId%>";
         afm.memberDN="<%=UIUtil.toJavaScript((String)memberDN)%>";
         afm.storeID="<%=storeId%>";
         afm.referenceNumber="";
         afm.policyName="<%=UIUtil.toJavaScript(policyName)%>";
         afm.pPStoreMemberId = "<%=pPStoreMemberId%>";
         afm.pPStoreMemberDN = "<%=UIUtil.toJavaScript((String)pPStoreMemberDN)%>";
         afm.pPStoreIdentity = "<%=UIUtil.toJavaScript((String)pPStoreIdentity)%>";
         afm.storeMemberType="<%=storeMemberType%>";
         //for address member obj

         afm.addrMemberObj = new Member('<%= addrMemberDB.getMemberType() %>',
                           '<%= UIUtil.toJavaScript(addrMemberDB.getMemberDN()) %>',
                           '<%= UIUtil.toJavaScript(addrMemberDB.getMemberGroupName()) %>',
                           '<%= addrMemberDB.getMemberGroupOwnerMemberType() %>',
                           '<%= UIUtil.toJavaScript(addrMemberDB.getMemberGroupOwnerMemberDN()) %>');

         //policy member obj
         afm.policyMemberObj = new Member('<%= policyMemberDB.getMemberType() %>',
                           '<%= UIUtil.toJavaScript(policyMemberDB.getMemberDN()) %>',
                           '<%= UIUtil.toJavaScript(policyMemberDB.getMemberGroupName()) %>',
                           '<%= policyMemberDB.getMemberGroupOwnerMemberType() %>',
                           '<%= UIUtil.toJavaScript(policyMemberDB.getMemberGroupOwnerMemberDN()) %>');

         afm.action="new";
         afm.allowCredit=false;
         afm.displayName = "";
         afm.addressName = "";
         var atts = new Array();
         afm.atts = atts;
   }
 } // end here before
 //alert (afm.pPStoreMemberId);
 //alert (afm.pPStoreIdentity);
 // handle error messages back from the validate page
 if (parent.parent.get("displayNameTooLong", false))
 {
    parent.parent.remove("displayNameTooLong");
    alertDialog("<%= UIUtil.toJavaScript((String)contractsRB.get("contractPaymentFormDisplayNameTooLong"))%>");
    with(document.financialForm)
    {
      FinancialName.focus();
    }
 }

 if (parent.parent.get("displayNameIsNull", false))
 {
    parent.parent.remove("displayNameIsNull");
    alertDialog("<%= UIUtil.toJavaScript((String)contractsRB.get("contractPaymentFormInvalidDisplayName"))%>");
    with(document.financialForm)
    {
      FinancialName.focus();
    }
 }

 if (parent.parent.get("customerOrgChanged", false))
 {
    parent.parent.remove("customerOrgChanged");
    alertDialog("<%= UIUtil.toJavaScript((String)contractsRB.get("contractPaymentFormAOrgChanged"))%>");
 }
 if (parent.parent.get("accountFinancialFormMissValue", false))
 {
    parent.parent.remove("accountFinancialFormMissValue");
    alertDialog("<%= UIUtil.toJavaScript((String)contractsRB.get("accountFinancialFormMissValue"))%>");
 } 

 parent.parent.put("AccountFinancialModel", afm);
 parent.parent.put("AccountFinancialModelLoaded", true);
}

function putValueBackToForm(atts)
{
  if (atts!=null && atts.length!=0)
  {
      with (document.financialFormDetail)
      {
         for (var i=0; i<elements.length; i++)
         {

            for (var j=0; j<atts.length; j++)
            {

              if (elements[i].name==atts[j].name)
              {
                  if ((elements[i].type=="checkbox") || (elements[i].type=="radio"))
                  {
                      if (elements[i].value==atts[j].value)
                      {
                        elements[i].checked=true;
                        //got it, then skip to next element
                       i++;
                   }
                      else
                      {
                        elements[i].checked=false;
                      }
                  }
                  else if (elements[i].type=="select-one")
                  {
                    var m=i;
                   for (var k=0; k< elements[m].options.length; k++)
                   {
                          if (elements[m].options[k].value==atts[j].value)
                          {
                            elements[m].options[k].selected=true;
                            //got it, then skip to next element
                            i++;
                            k = elements[m].options.length;
                          }
                   }
                  }
                  else if (elements[i].type=="text")
                  {
                    elements[i].value=atts[j].value;
                  }

                 } //end if
               } //end for j
         } //end for i
      } // end with
  }
}

function showDivisions()
{
  with (document)
  {
    var allowCredit = financialForm.AllowCredit.checked;
    var afm = parent.parent.get("AccountFinancialModel", null);
    if (afm != null)
    {
     afm.allowCredit=allowCredit;
     parent.parent.put("AccountFinancialModel", afm);
    }
    else
    {
     var afm = new AccountFinancialModel();
     afm.allowCredit=false;
     parent.parent.put("AccountFinancialModel", afm);
    }
    parent.AddressFormDetailChange(allowCredit);
    if (allowCredit == true)
    {
      AccountFinancialDiv.style.display = "block";
    }
    else
    {
      AccountFinancialDiv.style.display = "none";
    }
  }
}

function disableCredit(check) {
  if (check == false) {
   var afm = parent.parent.get("AccountFinancialModel", null);
   if (afm != null && afm.action == "noaction")
   {
      alertDialog('<%= UIUtil.toJavaScript((String)contractsRB.get("accountFinancialFormCreditLineWarning"))%>');
   }
  }
}

-->

</script>

<head>
<%= fHeader %>
<link rel="stylesheet" href="<%= UIUtil.getCSSFile(fLocale) %>" type="text/css">
</head>

<body class="content" OnLoad="onload();">

<h1><%= contractsRB.get("accountFinancialFormPanelTitle") %></h1>

<% if (bGetPolicy==0) { %>
   <form name=financialForm id=financialForm>
   <input type=checkbox name=AllowCredit disabled id="AccountFinancialPanel_FormInput_AllowCredit_In_financialForm_1">&nbsp;<label for="AccountFinancialPanel_FormInput_AllowCredit_In_financialForm_1"><%= contractsRB.get("accountFinancialAllowCreditPrompt") %></label><br>
   <input type="hidden" name="FinancialName" id="AccountFinancialPanel_FormInput_FinancialName_In_financialForm_1">
   </form>
   <form name=financialFormAddress id=financialFormAddress>
   <div id="tempDiv1" style="display: none"><label for="AccountFinancialPanel_FormInput_FinancialAddress_In_financialForm_1"></label>
   <select name="FinancialAddress" id="AccountFinancialPanel_FormInput_FinancialAddress_In_financialForm_1" >
   <option value=""></option>
   </select>
   </div>
   </form>
   <form name=financialFormDetail id=financialFormDetail>
   </form>

<% } else { %>
   <form name=financialForm id=financialForm>
   <input type=checkbox name=AllowCredit ONCLICK="disableCredit(this.checked);showDivisions()" id="AccountFinancialPanel_FormInput_AllowCredit_In_financialForm_2">&nbsp;<label for="AccountFinancialPanel_FormInput_AllowCredit_In_financialForm_2"><%= contractsRB.get("accountFinancialAllowCreditPrompt") %></label><br>
   <div id="AccountFinancialDiv" style="display: none">
   <table border=0 id="AccountFinancialPanel_Table_1">
   <tr>
   <td width=20 id="AccountFinancialPanel_TableCell_1">&nbsp;</td>
   <td id="AccountFinancialPanel_TableCell_2">
   <label for="AccountFinancialPanel_FormInput_FinancialName_In_financialForm_2"><%= contractsRB.get("accountFinancialDisplayNamePrompt") %></label><br>
   <input type="text" name="FinancialName" size="30" maxlength=254 id="AccountFinancialPanel_FormInput_FinancialName_In_financialForm_2">
   </form>
   </td>
   </tr>
   <tr>
   <td width=20 id="AccountFinancialPanel_TableCell_3">&nbsp;</td>
   <td id="AccountFinancialPanel_TableCell_4">
   <form name=financialFormDetail id=financialFormDetail>
   <%
   //set the account number as required for defect 130168
   if(jLocale.toString().equals("en_US")){
   		paymentBuyPagesNLS.put("accountNumber", "Credit line account number (required)");
   }
   request.setAttribute("resourceBundle", paymentBuyPagesNLS);
   %>

   <jsp:include page= "<%= paymentPolicy %>" flush="true" /><br>

   </form>
   </td>
   </tr>
   <tr>
   <td width=20 id="AccountFinancialPanel_TableCell_5">&nbsp;</td>
   <td id="AccountFinancialPanel_TableCell_6">
   <form name=financialFormAddress id=financialFormAddress>
   <label for="AccountFinancialPanel_FormInput_FinancialAddress_In_financialFormAddress_1"><%= contractsRB.get("accountFinancialAddressPrompt") %></label><br>
   <select name="FinancialAddress" id="AccountFinancialPanel_FormInput_FinancialAddress_In_financialFormAddress_1" onChange="parent.AddressFormDetailChange(true);">
   <%=numberOfAddress%>
   <option value=""><%= contractsRB.get("contractPaymentFormAddressSelectionPanelNoAddress")%></option>
   <%
     AddressDataBean addressDb;
     for ( int i = 0; i < numberOfAddress; i++)
     {
       addressDb = address[i];
   %>
       <option value="<%= addressDb.getAddressId() %>"><%= addressDb.getNickName() %></option>
   <%
     }
   %>
   </select>
   </form>
   </td>
   </tr>
   </table>
   </div>



<% } %>

</body>

</html>
