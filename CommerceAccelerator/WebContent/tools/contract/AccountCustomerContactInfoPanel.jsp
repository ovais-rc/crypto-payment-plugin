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
   import="com.ibm.commerce.tools.util.UIUtil,
      com.ibm.commerce.beans.DataBeanManager,
      com.ibm.commerce.tools.contract.beans.*,
      com.ibm.commerce.contract.helper.ContractUtil,      
      com.ibm.commerce.datatype.TypedProperty" %>

<%@include file="../common/common.jsp" %>
<%@include file="ContractCommon.jsp" %>

<%
   Hashtable fixedResourceBundle = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("contract.storeCreationWizardRB", fLocale);  
   if (fixedResourceBundle == null) {
	out.println("The untranslatable store creation resources bundle is null");
   } 
   // Getting the price list types from the resource bundle
   int plTypeCount = 0;
   while(true){		
	if(fixedResourceBundle.get("priceList_internalName_type_" + (plTypeCount + 1)) == null){
		break;
	} 			
	plTypeCount++;				
   }	

   // this loads all policies, may need to choose
   // load the store policies from the database
   PolicyListDataBean policyListAll = new PolicyListDataBean();
   policyListAll.setPolicyType(policyListAll.TYPE_PRICE);
   policyListAll.setStoreId(fStoreId);
   DataBeanManager.activate(policyListAll, request);
   PolicyDataBean policiesAll[] = policyListAll.getPolicyList();
   
%>
   
<html>

<head>
 <%= fHeader %>
 <style type='text/css'>
 .selectWidth {width: 200px;}

</style>
 <link rel="stylesheet" href="<%= UIUtil.getCSSFile(fLocale) %>" type="text/css">

 <title><%= contractsRB.get("accountCustomerContactInfoPrompt") %></title>
 <script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/Util.js">
</script>
 <script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/FieldEntryUtil.js">
</script>

 <script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/contract/Account.js">
</script>
 <script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/contract/ContractUtil.js">
</script>

 <script LANGUAGE="JavaScript">
var priceListTypeOptions = new Array();
var possiblePriceListPolicyArray = new Array();

  function displayMustUsePriceListPreference() {
    if (self.document.infoForm.priceListChoice.selectedIndex != 0) {
  	self.document.getElementById("MustUsePriceListPreferenceDiv").style.display = "block";
    } else {
	self.document.getElementById("MustUsePriceListPreferenceDiv").style.display = "none";
    }    
  }
  
  // This function detect if the panel has been load before
  function loadPanelData() {

<%
   for (int i=0; i<policiesAll.length; i++) {
      PolicyDataBean pricePDB = policiesAll[i];
      String plType = ContractUtil.getPolicyPriceListType(pricePDB.getProperties());

      if (!plType.equals(ContractUtil.TYPEUNKNOWN)) {
         // get the member data bean for the store member ID owner of this policy
         MemberDataBean mdb = new MemberDataBean();
              mdb.setId(pricePDB.getStoreMemberId());
              DataBeanManager.activate(mdb, request);
%>
possiblePriceListPolicyArray[possiblePriceListPolicyArray.length] =

         new PolicyObject('<%=UIUtil.toJavaScript(pricePDB.getShortDescription())%>',
               '<%= UIUtil.toJavaScript(pricePDB.getPolicyName()) %>',
               '<%= pricePDB.getId() %>',
               '<%= UIUtil.toJavaScript(pricePDB.getStoreIdentity()) %>',
               new Member('<%= UIUtil.toJavaScript(mdb.getMemberType()) %>',
                     '<%= UIUtil.toJavaScript(mdb.getMemberDN()) %>',
                     '<%= UIUtil.toJavaScript(mdb.getMemberGroupName()) %>',
                     '<%= UIUtil.toJavaScript(mdb.getMemberGroupOwnerMemberType()) %>',
                     '<%= UIUtil.toJavaScript(mdb.getMemberGroupOwnerMemberDN()) %>'),
			'<%= plType %>'                     
                                        );
//alert("Price Policy["+possiblePriceListPolicyArray.length+"]="+dumpObject(possiblePriceListPolicyArray[possiblePriceListPolicyArray.length-1]));

   <% }
   } // end for  
   
	if(plTypeCount > 0){		
		for(int i=0; i < plTypeCount; i++){
%>	
			var obj = new Object();
			obj.name = "<%= (String) fixedResourceBundle.get("priceList_internalName_type_" + (i + 1)) %>";
			obj.text = "<%= UIUtil.toJavaScript((String) contractsRB.get("priceList_displayText_type_" + (i + 1))) %>";
			obj.havePolicy = false;
			priceListTypeOptions[priceListTypeOptions.length] = obj;
//alert("Policy type ["+priceListTypeOptions.length+"]="+dumpObject(priceListTypeOptions[priceListTypeOptions.length-1]));
<%
		}		
	}		
%>
	if ("<%= plTypeCount %>" == "0") {
//alert('no types in properties file');	
		self.document.getElementById("PriceListSelect").style.display = "none";	
	} else {
//alert('have types in properties file');		
		// ok, we want to load some specific types
		// check if we have them
		for (var i = 0; i < <%= plTypeCount %>; i++) {
			// loop through possiblities	
			for (var j=0; j<possiblePriceListPolicyArray.length; j++) {
//alert(' choice ' + priceListTypeOptions[i].name + 'policy ' + possiblePriceListPolicyArray[j].type + ' ' + possiblePriceListPolicyArray[j].displayText);			
				if (possiblePriceListPolicyArray[j].type == priceListTypeOptions[i].name) {
					// we have a policy of that type
//alert('MATCH Type: ' + priceListTypeOptions[i].name + ' Policy: ' + possiblePriceListPolicyArray[j].displayText);					
					priceListTypeOptions[i].havePolicy = true;
					break;
				}
			}
		}
//alert('check how many types have policies');		
		// check how many of the types actually have policies
		var havePoliciesForAnyTypeChoices = 0;
		var plType = "";
		for (var i = 0; i < <%= plTypeCount %>; i++) {
			if (priceListTypeOptions[i].havePolicy == true) {
				havePoliciesForAnyTypeChoices++;
				plType = priceListTypeOptions[i].name;
			}
		}	
//alert(havePoliciesForAnyTypeChoices + ' types have policies');			
		
		if (havePoliciesForAnyTypeChoices == 0) {
			self.document.getElementById("PriceListSelect").style.display = "none";	
		} else {
			// user has to choose
			var added = 0;
			for (var i=0; i< <%= plTypeCount %>; i++) {
			   if (priceListTypeOptions[i].havePolicy == true) {
				self.document.infoForm.priceListChoice.options[added + 1] = new Option(priceListTypeOptions[i].text, 
								priceListTypeOptions[i].name, false, false);
				added++;
			   }
			}			
			self.document.getElementById("PriceListSelect").style.display = "block";	
		}	
	}
  
  if (parent.parent.get) {
   var hereBefore = parent.parent.get("AccountCustomerModelLoaded", null);
   //alert('info = ' + hereBefore);
   if (hereBefore != null) {
      // have been to this page before - load from the model
            var o = parent.parent.get("AccountCustomerModel", null);
      if (o != null) {
        self.document.infoForm.Info.value = o.info;
        if (o.allowPurchase) {
         self.document.infoForm.AllowOutsidePurchase.checked = true;
        }
        if (o.forBaseContracts) {
         self.document.infoForm.ForBaseContracts.checked = true;
        }
        
    for (var i=0; i<self.document.infoForm.priceListChoice.length; i++) {
      if (self.document.infoForm.priceListChoice.options[i].value == o.priceListType) {
         self.document.infoForm.priceListChoice.selectedIndex = i;
         break;
      }
    }        
        if (o.mustUsePriceListPreference) {
         self.document.infoForm.MustUsePriceListPreference.checked = true;
        }        
  displayMustUsePriceListPreference();
  
        // handle error messages back from the validate page
           if (parent.parent.get("accountCustomerContactInfoTooLong", false)) {
               parent.parent.remove("accountCustomerContactInfoTooLong");
               alertDialog("<%= UIUtil.toJavaScript((String)contractsRB.get("accountCustomerContactInfoTooLong"))%>");
           }
         }
        }
   if (o.accountName != "") {
      // cannot set this on an update
      if (o.accountName.indexOf("BaseContracts") >= 0) {
        self.document.infoForm.ForBaseContracts.checked = true;
      }
      //self.document.infoForm.ForBaseContracts.disabled = true;
    }
    }
       <%
              // To check this panel is in account 'update' mode or 'create' mode, if
              // it is in update mode, we disable the checkbox so that user will not
              // able to change the attribute of 'This account is for base contract'.

              boolean isUpdateMode = false;

              try
              {
                     // Retrieve the update mode attribute set by parent frame AccountCustomer.
                 isUpdateMode = "TRUE".equalsIgnoreCase((String)request.getSession().getAttribute("com.ibm.commerce.tools.contract.AccountCustomer.jsp.updateMode"));
              }
              catch (Exception e)
              {
                     // Either couldn't find the attribute or session is missing,
                     // we set the isUpdateMode to false by default if exception occurs.
                     isUpdateMode = false;
               }

              if (isUpdateMode)
              {
       %>
                 self.document.infoForm.ForBaseContracts.disabled = true;
       <%
              } //end-if(isUpdateMode)
       %>
    
  }


</script>

</head>

<body ONLOAD="loadPanelData();" class="content">

<form NAME="infoForm" id="infoForm">

<table border=0 id="AccountCustomerContactInfoPanel_Table_1">
 <tr>
  <td valign='top' id="AccountCustomerContactInfoPanel_TableCell_1">
    <label for="AccountCustomerContactInfoPanel_FormInput_Info_In_infoForm_1"><%= contractsRB.get("accountCustomerContactInfoPrompt") %></label><br>
    <textarea NAME="Info" ROWS="4" COLS="50" id="AccountCustomerContactInfoPanel_FormInput_Info_In_infoForm_1" WRAP=physical onKeyDown="limitTextArea(this.form.Info,4000);" onKeyUp="limitTextArea(this.form.Info,4000);"></textarea>
  </td>
 </tr>
 <tr>
  <td id="AccountCustomerContactInfoPanel_TableCell_2">
    <input NAME="AllowOutsidePurchase" TYPE="CHECKBOX" id="AccountCustomerContactInfoPanel_FormInput_AllowOutsidePurchase_In_infoForm_1"><label for="AccountCustomerContactInfoPanel_FormInput_AllowOutsidePurchase_In_infoForm_1"><%= contractsRB.get("accountCustomerAllowOutsidePurchasePrompt") %></label>
  </td>
 </tr>
 <tr>
  <td>
    <input NAME="ForBaseContracts" TYPE="CHECKBOX" id="AccountCustomerContactInfoPanel_FormInput_ForBaseContracts_In_infoForm_1"><label for="AccountCustomerContactInfoPanel_FormInput_ForBaseContracts_In_infoForm_1"><%= contractsRB.get("accountCustomerBaseContracts") %></label>
  </td>
 </tr>
</table>
<div id="PriceListSelect" style="display: none; margin-left: 0">
<table border=0 id="AccountCustomerContactInfoPanel_Table_2">
 <tr>
  <td id="AccountCustomerContactInfoPanel_TableCell_102">
   <label for="priceListChoice"><%= contractsRB.get("accountCustomerPriceListPreference") %></label><br>  
   <select class="list_info1" id="priceListChoice" SIZE=1 width=100% onchange="displayMustUsePriceListPreference();">
    <option value="" selected><%=UIUtil.toHTML((String)contractsRB.get("accountCustomerNoPriceListPreference"))%></option>
   </select>
  </td>
 </tr> 
</table>
</div>
<div id="MustUsePriceListPreferenceDiv" style="display: none; margin-left: 0">
<table border=0 id="AccountCustomerContactInfoPanel_Table_3">
 <tr>
  <td>
    <input NAME="MustUsePriceListPreference" TYPE="CHECKBOX" id="AccountCustomerContactInfoPanel_FormInput_MustUsePriceListPreference_In_infoForm_1"><label for="AccountCustomerContactInfoPanel_FormInput_MustUsePriceListPreference_In_infoForm_1"><%= contractsRB.get("accountCustomerMustUsePriceListPreference") %></label>
  </td>
 </tr> 
</table>
</div>

</form>
</body>
</html>
