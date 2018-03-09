<%
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2002
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
//*
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">

<html>

<head>
<%@page import = "java.util.*,
			com.ibm.commerce.beans.*,
			com.ibm.commerce.command.CommandContext,
			com.ibm.commerce.datatype.TypedProperty,
			com.ibm.commerce.tools.contract.beans.*,
			com.ibm.commerce.contract.helper.ContractUtil,
			com.ibm.commerce.tools.catalog.beans.*,
			com.ibm.commerce.tools.catalog.util.*,
			com.ibm.commerce.catalog.objects.*,
			com.ibm.commerce.common.objects.StoreAccessBean,
			com.ibm.commerce.tools.util.*"
%>

<%@include file="../common/common.jsp" %>
<%@include file="ContractCommon.jsp" %>

<meta name="GENERATOR" content="IBM WebSphere Page Designer V3.0.2 for Windows">
<meta http-equiv="Content-Style-Type" content="text/css">

<title><%=UIUtil.toHTML((String)contractsRB.get("genericCatalogFilterTitle"))%></title>

<link rel=stylesheet href="<%= UIUtil.getCSSFile(fLocale) %>" type="text/css">

<script SRC="/wcs/javascript/tools/common/Util.js">
</script>


<script LANGUAGE="JavaScript">
<%

   Hashtable fixedResourceBundle = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("contract.storeCreationWizardRB", fLocale);  
   if (fixedResourceBundle == null) {
	out.println("The untranslatable store creation resources bundle is null");
   }
   
	String _contractId = null;
	String contractTitle = "";
	String fromContractList = "";
	TypedProperty requestProperties = (TypedProperty)request.getAttribute("RequestProperties");
	if (requestProperties != null) {
		_contractId = (String)requestProperties.getString("contractId");
		if (_contractId != null && _contractId.length() > 0) {
			ContractDataBean contract = new ContractDataBean(new Long(_contractId), new Integer(fLanguageId));
			DataBeanManager.activate(contract, request);
			contractTitle = UIUtil.toHTML((String)contract.getContractName());
		}
		fromContractList = requestProperties.getString("fromContractList", "");
	}
	
		// Getting the price list types from the resource bundle
		int plTypeCount = 0;
		while(true){		
			if(fixedResourceBundle.get("priceList_internalName_type_" + (plTypeCount + 1)) == null){
				break;
			} 			
			plTypeCount++;				
		}
	
	String accountPriceListPreference = "";
	boolean useAccountPriceListPreference = false;

	if (foundAccountId && accountId != null && accountId.length() > 0 && !accountId.equals("null") && !accountId.equals("-1")) {
         AccountDataBean account = new AccountDataBean(new Long(accountId), new Integer(fLanguageId));
         DataBeanManager.activate(account, request);
         accountPriceListPreference = account.getPriceListPreference();
         useAccountPriceListPreference = account.getMustUsePriceListPreference();
	}					
	
%>

function doNotShowCatalogFilterTitleDivision() {
	document.getElementById("catalogFilterTitleDiv").style.display = "none";
}
function refreshCatalogFilterTitleDivision() {
//alert('reload');
	//location.reload();
	updateCatalogFilterTitleDivision();
}

var priceListTypeOptions = new Array();
	
function updateCatalogFilterTitleDivision() {

//alert('updateCatalogFilterTitleDivision');

	var JROM = parent.getJROM();
	var statusText = "<table border=\"0\" id=\"CatalogFilterTitle_Table_2\">";
	<% if (fromContractList.length() > 0) { 
		if (contractTitle != null && contractTitle.length() > 0 ) {
	%>
			if (JROM.delegationGrid == false) {
				statusText += "<tr VALIGN=TOP><td class=\"list_info1\" VALIGN=TOP id=\"CatalogFilterTitle_TableCell_3\"><%=UIUtil.toHTML((String)contractsRB.get("customerContractLabel"))%></td>";
			} else {
				statusText += "<tr VALIGN=TOP><td class=\"list_info1\" VALIGN=TOP id=\"CatalogFilterTitle_TableCell_3\"><%=UIUtil.toHTML((String)contractsRB.get("delegationGridLabel"))%></td>";
			}
			statusText += "<td class=\"list_info1\" VALIGN=TOP id=\"CatalogFilterTitle_TableCell_4\"><%= contractTitle %></td></tr>";
	<%	}
	%>
		if (JROM.baseContractTitle != null && JROM.baseContractTitle != "") {
			if (JROM.delegationGrid == false) {
				statusText += "<tr VALIGN=TOP><td class=\"list_info1\" VALIGN=TOP id=\"CatalogFilterTitle_TableCell_5\"><%=UIUtil.toHTML((String)contractsRB.get("baseContractLabel"))%></td><td class=\"list_info1\" VALIGN=TOP id=\"CatalogFilterTitle_TableCell_6\">";
			} else {
				statusText += "<tr VALIGN=TOP><td class=\"list_info1\" VALIGN=TOP id=\"CatalogFilterTitle_TableCell_5\"><%=UIUtil.toHTML((String)contractsRB.get("baseDelegationGridLabel"))%></td><td class=\"list_info1\" VALIGN=TOP id=\"CatalogFilterTitle_TableCell_6\">";
			}
			statusText += JROM.baseContractTitle;
			statusText += "</td></tr>";
		}
		if (JROM.delegationGrid == false) {
		  if(JROM.includedCategoriesAreSynched == true) {	
			statusText += "<tr VALIGN=TOP><td class=\"list_info1\" VALIGN=TOP id=\"CatalogFilterTitle_TableCell_7\"><%=UIUtil.toHTML((String)contractsRB.get("includeCategorySynchronizedLabel"))%></td>";
			statusText += "<td class=\"list_info1\" VALIGN=TOP id=\"CatalogFilterTitle_TableCell_8\"><%=UIUtil.toHTML((String)contractsRB.get("includeCategorySynchronizedYes"))%></td></tr>";
		  } else if(JROM.includedCategoriesAreUnSynched == true) {
			statusText += "<tr VALIGN=TOP><td class=\"list_info1\" VALIGN=TOP id=\"CatalogFilterTitle_TableCell_7\"><%=UIUtil.toHTML((String)contractsRB.get("includeCategorySynchronizedLabel"))%></td>";
			statusText += "<td class=\"list_info1\" VALIGN=TOP id=\"CatalogFilterTitle_TableCell_8\"><%=UIUtil.toHTML((String)contractsRB.get("includeCategorySynchronizedNo"))%></td></tr>";
		  }
		}
							
		if(JROM.contractState != JROM.CONTRACT_STATUS_INPROGRESS && JROM.publishStatus == JROM.PUBLISH_STATUS_FAILED) {
			alertDialog("<%=UIUtil.toJavaScript((String)contractsRB.get("publishingFailedMessage"))%>");
		}
	<% } else { %>
		statusText += "<tr VALIGN=TOP><td class=\"list_info1\" VALIGN=TOP id=\"CatalogFilterTitle_TableCell_9\"><%=UIUtil.toHTML((String)contractsRB.get("filtersLastUpdate"))%></td><td class=\"list_info1\" VALIGN=TOP id=\"CatalogFilterTitle_TableCell_10\">";
		statusText += JROM.tcLastUpdateTime;
		statusText += "</td></tr>";
		
		statusText += "<tr VALIGN=TOP><td class=\"list_info1\" VALIGN=TOP id=\"CatalogFilterTitle_TableCell_11\"><%=UIUtil.toHTML((String)contractsRB.get("publishStatus"))%></td><td class=\"list_info1\" VALIGN=TOP id=\"CatalogFilterTitle_TableCell_12\">";

		// LOGIC
		//if contract state = in progress then another dialog (CatalogFilterRefreshDialog) will have been loaded
		//else if contract state  = active then filter state = termcond.integerfield2
		//else if contract state  = failed then filter state = termcond.integerfield2
		//else filter state = N/A
	
		if(JROM.contractState == JROM.CONTRACT_STATUS_INPROGRESS || JROM.publishStatus == JROM.PUBLISH_STATUS_INPROGRESS) {	
			statusText += "<%=UIUtil.toHTML((String)contractsRB.get("publishInProgress"))%>";
		}
		else if(JROM.publishStatus == JROM.PUBLISH_STATUS_SUCCESS) {
			statusText += "<%=UIUtil.toHTML((String)contractsRB.get("publishSuccess"))%>";
		}
		else if(JROM.publishStatus == JROM.PUBLISH_STATUS_FAILED) {
			statusText += "<%=UIUtil.toHTML((String)contractsRB.get("publishFailed"))%>";
			alertDialog("<%=UIUtil.toJavaScript((String)contractsRB.get("publishingFailedMessage"))%>");
		}
		else {
			statusText += "<%=UIUtil.toHTML((String)contractsRB.get("publishStatusNA"))%>";
		}
		statusText += "</td></tr>";
	<% } %>
	statusText += "</table>";
//alert(statusText);
	document.getElementById("statusInformation").innerHTML = statusText;
	
	if (JROM.delegationGrid == true) {
		document.getElementById("CatalogFilterTitle_TableCell_1").innerHTML = "<h1><%=UIUtil.toHTML((String)contractsRB.get("delegationGridCatalogFilterTitle"))%></h1>";
	}
	
<%
		if(plTypeCount > 0){		
			for(int i=0; i < plTypeCount; i++){
		%>	
				var obj = new Object();
				obj.name = "<%= (String) fixedResourceBundle.get("priceList_internalName_type_" + (i + 1)) %>";
				obj.text = "<%= UIUtil.toJavaScript((String) contractsRB.get("priceList_displayText_type_" + (i + 1))) %>";
				obj.mark = "<%= (String) fixedResourceBundle.get("priceListAdjustment_internalName_type_" + (i + 1)) %>";
				obj.havePolicy = false;
				priceListTypeOptions[priceListTypeOptions.length] = obj;
//alert("Policy type ["+priceListTypeOptions.length+"]="+dumpObject(priceListTypeOptions[priceListTypeOptions.length-1]));
		<%
			}		
		}		
%>

//alert('base contract type ' + JROM.baseContractPriceListType + ' type index ' + JROM.priceListTypeIndex);         
   if (JROM.needToSelectPriceList == true) {
//alert('needToSelectPriceList');
	// match the choice from the base contract
	if (JROM.delegationGrid == true) {
//alert('use delegation grid NOMINAL cost');	
			selectSpecificType("<%=ContractUtil.TYPENOMINAL%>");
			noUserChoice();	
	}
	// match the choice from the base contract
	else if (JROM.baseContractPriceListType != "") {
//alert('match type from base contract ' + JROM.baseContractPriceListType);	
			selectSpecificType(JROM.baseContractPriceListType);
			noUserChoice();	
	}
	// if there are no types we want, select all the possiblities
	else if ("<%= plTypeCount %>" == "0") {
//alert('no types in properties file');	
		selectAllPossibilities();
		noUserChoice();
	}
	// if hosting contract, only want master
	else if (JROM.hostingMode == true) {
//alert('hosting contract');	
		selectAllPossibilities();
		noUserChoice();		
	} else {
//alert('have types in properties file');		
		// ok, we want to load some specific types
		// check if we have them
		for (var i = 0; i < <%= plTypeCount %>; i++) {
			// loop through possiblities	
			for (var j=0; j<JROM.possiblePriceListPolicyArray.length; j++) {
//alert(' choice ' + priceListTypeOptions[i].name + 'policy ' + JROM.possiblePriceListPolicyArray[j].type + ' ' + JROM.possiblePriceListPolicyArray[j].displayText);			
				if (JROM.possiblePriceListPolicyArray[j].type == priceListTypeOptions[i].name) {
					// we have a policy of that type
//alert('MATCH Type: ' + priceListTypeOptions[i].name + ' Policy: ' + JROM.possiblePriceListPolicyArray[j].displayText);					
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
			// we do not have policies for any of the needed types
			selectAllPossibilities();
			noUserChoice();
		} else if (havePoliciesForAnyTypeChoices == 1) {
			// we only have one of the types
			selectSpecificType(plType);
			noUserChoice();
		} else if ("<%= accountPriceListPreference %>" != "" && "<%= useAccountPriceListPreference %>" == "true") {
			// see if the account has a preference
			// must use the account preference
			selectSpecificType("<%= accountPriceListPreference %>");
			noUserChoice();		
		} else {
			// user has to choose
			var added = 0;
			for (var i=0; i< <%= plTypeCount %>; i++) {
			   if (priceListTypeOptions[i].havePolicy == true) {
				priceListChoice.options[added + 1] = new Option(priceListTypeOptions[i].text, 
								priceListTypeOptions[i].name, false, false);
				added++;
			   }
			}
			if (JROM.priceListTypeIndex != 0) {
				// user has already made a choice
				document.getElementById("priceListChoice").selectedIndex = JROM.priceListTypeIndex;
			}
			else if ("<%= accountPriceListPreference %>" != "") {
				// preselect the account preference
    				for (var i=0; i<document.getElementById("priceListChoice").length; i++) {
      					if (document.getElementById("priceListChoice").options[i].value == "<%= accountPriceListPreference %>") {
         					document.getElementById("priceListChoice").selectedIndex = i;
         					break;
      					}
    				} 				
			} 
			selectPriceList();
			document.getElementById("PriceListSelect").style.display = "block";	
		}	
	}
   } // if needToSelectPriceList
   else {
//alert('do not needToSelectPriceList');
	// check if we have a known type
	var type = noUserChoice();
  	// set the default markup/markdown behaviour
  	for (var i=0; i<priceListTypeOptions.length; i++) {
   	 if (priceListTypeOptions[i].name == type) {
    	    JROM.defaultMarkType = priceListTypeOptions[i].mark;
    	    break;
    	 }
  	} 	  	
   }
}

function selectAllPossibilities() {
//alert('selectAllPossibilities');

  var JROM = parent.getJROM();
  var newpriceListPolicyArray = new Array();
  var newpriceListIdArray = new Array();
  for (var j=0; j<JROM.possiblePriceListPolicyArray.length; j++) {
	if (JROM.possiblePriceListPolicyArray[j].type != "<%=ContractUtil.TYPENOMINAL%>") {
		// we want all policies, except the special NOMINAL policy
//alert(JROM.possiblePriceListPolicyArray[j].displayText);
		newpriceListPolicyArray[newpriceListPolicyArray.length] = JROM.possiblePriceListPolicyArray[j];
		newpriceListIdArray[newpriceListIdArray.length] = JROM.possiblePriceListIdArray[j];
	}
  }
  JROM.priceListPolicyArray = newpriceListPolicyArray;
  JROM.priceListIdArray = newpriceListIdArray; 
  JROM.defaultMarkType = "markdown";
}

function selectSpecificType(type) {
//alert('selectSpecificType: ' + type);
  var JROM = parent.getJROM();
  var newpriceListPolicyArray = new Array();
  var newpriceListIdArray = new Array();
  for (var j=0; j<JROM.possiblePriceListPolicyArray.length; j++) {
	if (JROM.possiblePriceListPolicyArray[j].type == type) {
		// we have a policy of that type
//alert(JROM.possiblePriceListPolicyArray[j].displayText);
		newpriceListPolicyArray[newpriceListPolicyArray.length] = JROM.possiblePriceListPolicyArray[j];
		newpriceListIdArray[newpriceListIdArray.length] = JROM.possiblePriceListIdArray[j];
	}
  }
  JROM.priceListPolicyArray = newpriceListPolicyArray;
  JROM.priceListIdArray = newpriceListIdArray; 
  
  // set the default markup/markdown behaviour
  for (var i=0; i<priceListTypeOptions.length; i++) {
    if (priceListTypeOptions[i].name == type) {
        JROM.defaultMarkType = priceListTypeOptions[i].mark;
        break;
    }
  } 	  
}

function noUserChoice() {
// display the existing price list type if it is known
//alert('noUserChoice');
		var JROM = parent.getJROM();
		var plType = "";
		for (var i=0; i<JROM.priceListPolicyArray.length; i++) {
			if (JROM.priceListPolicyArray[i].type != '<%=ContractUtil.TYPEUNKNOWN%>') {
				plType = JROM.priceListPolicyArray[i].type;
				break;
			}
		}
		// for hosting contract - do not display the choice
		if (JROM.hostingMode == true || JROM.delegationGrid == true) {
			plType = "";
		}
		if (plType != "") {
			var priceLists = "";
			for (var i=0; i< <%= plTypeCount %>; i++) {
				if (priceListTypeOptions[i].name == plType) {
				        priceLists = "<%=UIUtil.toHTML((String)contractsRB.get("priceListLabel"))%> ";
					priceLists += priceListTypeOptions[i].text;
					break;
				}
			}
			document.getElementById("PriceListNames").innerHTML = priceLists;
			document.getElementById("PriceListDisplay").style.display = "block";	
		}
		return plType;
}

function selectPriceList(){
//alert('selectPriceList');
  var JROM = parent.getJROM();
  JROM.priceListTypeIndex = document.getElementById("priceListChoice").selectedIndex; 
//alert('new type index ' +   JROM.priceListTypeIndex);  
  if(document.getElementById("priceListChoice").value == 'specifyPriceList'){     
  	JROM.priceListPolicyArray = new Array();
  	JROM.priceListIdArray = new Array(); 
  	JROM.defaultMarkType = "markdown";
  } else {
  	selectSpecificType(document.getElementById("priceListChoice").value);	
  }
}
</script>

</head>


<body ONLOAD="updateCatalogFilterTitleDivision()">
<div id="catalogFilterTitleDiv" style="display: block; margin-left: 0">
 <table border="0" width="100%" id="CatalogFilterTitle_Table_1">
	<tr VALIGN=CENTER>
		<td VALIGN=CENTER id="CatalogFilterTitle_TableCell_1">
			<h1><%=UIUtil.toHTML((String)contractsRB.get("genericCatalogFilterTitle"))%></h1>
		</td>
		<td id="CatalogFilterTitle_TableCell_100" VALIGN=TOP>
		<div id="PriceListSelect" style="display: none; margin-left: 0">
			<table border="0" id="CatalogFilterTitle_Table_200">
			<tr VALIGN=TOP>
				<td class="list_info1" id="CatalogFilterTitle_TableCell_101" VALIGN=TOP>
				<label for="priceListChoice"><%=UIUtil.toHTML((String)contractsRB.get("priceListLabel"))%></label>&nbsp;
					<select class="list_info1" id="priceListChoice" SIZE=1 width=100% onchange="selectPriceList();">
						<option value="specifyPriceList" selected><%=UIUtil.toHTML((String)contractsRB.get("GeneralPleaseSpecify"))%></option>
			     		</select>
				</td>
			</tr>
			</table>
		</div>
		<div id="PriceListDisplay" style="display: none; margin-left: 0">
			<table border="0" id="CatalogFilterTitle_Table_201">
			<tr>
				<td class="list_info1" id="CatalogFilterTitle_TableCell_103">
				</td>
			</tr>
			<tr>
				<td class="list_info1" id="PriceListNames">
				</td>
			</tr>
			</table>
		</div>						
		</td>
		<td class="list_info1" ALIGN=RIGHT VALIGN=TOP id="CatalogFilterTitle_TableCell_2">
		   <!-- The empty DIV below is used to insert dynamically the status information -->
   		  <div id="statusInformation">
   		  </div>
		</td>
	</tr>
 </table>

</div>

</body>
</html>
