<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2009 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<%@page import="java.util.*,
                com.ibm.commerce.tools.common.*,
                com.ibm.commerce.command.*,
                com.ibm.commerce.server.*,
                com.ibm.commerce.tools.util.*,
                com.ibm.commerce.tools.resourcebundle.ResourceBundleProperties,
                com.ibm.commerce.tools.xml.*,
                com.ibm.commerce.datatype.*, 
                com.ibm.commerce.beans.*,
    		    com.ibm.commerce.tools.taxation.databeans.TaxInfoBean1,
	    	    com.ibm.commerce.tools.taxation.databeans.TaxFulfillmentInfoBean1,
	            com.ibm.commerce.tools.taxation.databeans.EditorBean1,
		        com.ibm.commerce.tools.taxation.databeans.StoreCatalogTaxBean1,
		        com.ibm.commerce.tools.taxation.databeans.CurrencyEditBean1" 
%>
<%
  CommandContext cmdContext  = (CommandContext)request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
  Locale locale = cmdContext.getLocale();
  ResourceBundleProperties taxNLS = (ResourceBundleProperties)ResourceDirectory.lookup("taxation.taxationNLS", locale);

  String startingCountryIndex = request.getParameter("startingCountryIndex");
  String countryName = request.getParameter("countryName");
%>
<%@include file="../common/common.jsp" %>

<HTML>
<HEAD>
<LINK REL=stylesheet HREF="<%= UIUtil.getCSSFile(locale) %>" TYPE="text/css">
<STYLE TYPE='text/css'>
.selectWidth {width: 370px;}
.selectWidth3 {width: 315px;}
</STYLE>
</HEAD>
<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/common/Vector.js"></SCRIPT> 
<SCRIPT>

<%@include file="TaxUtil.jsp"%>
 
var selectedCountry = "<%=UIUtil.toJavaScript(startingCountryIndex)%>";

<jsp:useBean class="com.ibm.commerce.tools.devtools.databeans.LangBean" id="LangBean" scope="request">
<% com.ibm.commerce.beans.DataBeanManager.activate(LangBean, request); %></jsp:useBean>

<jsp:useBean class="com.ibm.commerce.tools.taxation.databeans.CountryBean" id="CountryBean" scope="request"> 
<% com.ibm.commerce.beans.DataBeanManager.activate(CountryBean, request); %></jsp:useBean>

<jsp:useBean class="com.ibm.commerce.tools.taxation.databeans.StateProvBean" id="StateProvBean" scope="request">  
<% com.ibm.commerce.beans.DataBeanManager.activate(StateProvBean, request); %></jsp:useBean>

<%String [] areStates = StateProvBean.getState(countryName);%>

   	var	remJurst = parent.get("remJurst");  
	if(remJurst == null){
		remJurst = new Vector();
	} 

   	var	remJurstGroup = parent.get("remJurstGroup");  
	if(remJurstGroup == null){
		remJurstGroup = new Vector();
	} 
    
    var	remCalRule2 = parent.get("remCalRule2");  
	if(remCalRule2 == null){
		remCalRule2 = new Vector();
	} 
    
	var countryAbbrList = new Array();
	var stateAbbrList = new Array();
	function checkErrorMessages()
	{
	//	var errorMsg = null;
	
	//	if (parent.get("EditorBean").errorMessage.length > 0)
	//		errorMsg = parent.get("EditorBean").errorMessage;
	//	else if (parent.get("CurrencyEditBean").errorMessage.length > 0)
	//		errorMsg = parent.get("CurrencyEditBean").errorMessage;
	//	else if (parent.get("TaxInfoBean").errorMessage.length > 0)
	//		errorMsg = parent.get("TaxInfoBean").errorMessage;
	//	else if (parent.get("TaxFulfillmentInfoBean").errorMessage.length > 0)
	//		errorMsg = parent.get("TaxFulfillmentInfoBean").errorMessage;
		
		
	//	if (errorMsg != null) {
	//		alertDialog(errorMsg);
	//		top.setHome();
	//		return true;
	//	}
	}  

  <%--
    -  Create a new jurisdiction. This is called when the user clicks 'Add'
    --%>
  function addJurisdiction()
  {
    var countryIndex = document.f1.countryList.selectedIndex;   
	var states = "<%=areStates%>";
	var state = null;
	var stateAbbr = null;
        
	if (states != "null")
	{
		var regionIndex = document.f1.regionList.selectedIndex;
		if (regionIndex == (document.f1.regionList.length - 1))
			state = null;
		else
			state = document.f1.regionList[regionIndex].value;
			stateAbbr = stateAbbrList[regionIndex];
	}
	else
	{
		state = trim(document.f1.regionText.value);

		<%-- Make sure the user entered a region name of valid length--%>
		if ( !isValidUTF8length(document.f1.regionText.value, 30)) {
			alertDialog ( "<%=taxNLS.getJSProperty("tooLong")%>" );
			return;
		}
	}
    
    var taxes = parent.get("TaxInfoBean1");
    var storeid = parent.get("storeid");
    var jurisdictions = taxes.jurst;
    var jurstgroup = taxes.jurstgroup;
    var jurstgprel = taxes.jurstgprel;
    var taxcgry = taxes.taxcgry;
    var taxFulfillmentInfoBean = parent.get("TaxFulfillmentInfoBean1");
    var taxjcrule = taxFulfillmentInfoBean.taxjcrule;
    var calrule = taxes.calrule;
    var ffmcntr = parent.get("ffmcntr");
    var calcode = taxes.calcode;
//    var default_id;
    
      
//      for (var x=0; x < calcode.size(); x++) {
//         var tmpcalcode = calcode.elementAt(x);
//         if(tmpcalcode.code == "Default") {
//            default_id = tmpcalcode.calculationCodeId;
//            break;
//         }
//      }
        
	<%-- Spin through the jurisdictions & make sure this is not a duplicate. --%>
	for (var i = 0; i < size(jurisdictions); i++)
	{
        var jurisdiction = elementAt(i,jurisdictions);
		if (jurisdiction.code == "World" || jurisdiction.code == "world") continue;
		
		var displayName = jurisdiction.country;
		if (jurisdiction.state !=null && jurisdiction.state != "")
			displayName = displayName + ", " + jurisdiction.state;

		var userInput = document.f1.countryList[countryIndex].value;
	
		if (states != "null")
		{
			if (state != null)
				userInput += ", " + document.f1.regionList[regionIndex].value.toUpperCase();
		}
		else
		{
			if (state != "")
				userInput += ", " + trim(document.f1.regionText.value);
		}
		
		if (displayName.toUpperCase() == userInput.toUpperCase())
		{
			alertDialog("<%=taxNLS.getJSProperty("JurisdictionAlreadyExists")%>");
			return;
		}
	}

//
	var precedence = 1;
	if(states != "null" && state != null)
		precedence = 2;
//
    
    <%-- create a new jurisdiction --%>
    var newJurst  = new parent.jurst();
    var jid = getJurstuid();
    newJurst.country = document.f1.countryList[countryIndex].value;
    newJurst.countryAbbreviation = countryAbbrList[countryIndex];

    if (state != "" && state != null) {
       newJurst.state = state;
       if (stateAbbr != "" && stateAbbr != null) {
           newJurst.stateAbbreviation = stateAbbr;
       }
       
    } 
    newJurst.code = jid;
    newJurst.subclass = '2';
    newJurst.jurisdictionId = "@jurst_id_" + jid;
    newJurst.storeEntityId = storeid;
    addElement(newJurst,jurisdictions);

    <%-- create a new jurisdiction group for the new jurisdiction--%>
    var newJurstGroup  = new parent.jurstgroup();
    var jgid = getJurstgroupuid();
    newJurstGroup.code = jgid;
    newJurstGroup.subclass = '2';
    newJurstGroup.jurisdictionGroupId = "@jurstgroup_id_" + jgid;
    newJurstGroup.storeentId = storeid;
    addElement(newJurstGroup,jurstgroup);

    <%-- associate the new jurisdiction with the new group --%>
    var newJurstgprel = new parent.jurstgprel();
    newJurstgprel.jurisdictionId = newJurst.jurisdictionId;
    newJurstgprel.jurisdictionGroupId = newJurstGroup.jurisdictionGroupId;
    newJurstgprel.subclass='2';
    addElement(newJurstgprel,jurstgprel);

    <%-- add a new taxjcrule, and all of its dependant entries, for each defined tax category --%>
    
    for (var k=0; k < size(calcode); k++){
       var thiscalcode = elementAt(k,calcode);
       var taxtype = null;
       //if (thiscalcode.code == "Default") continue;
       if (thiscalcode.calculationUsageId == "-3") taxtype = "sales";
       else if (thiscalcode.calculationUsageId == "-4") taxtype = "shipping";
       else alertDialog("No correct tax type defined in sar!");
      	       
       for (var i=0; i < size(taxcgry); i++) {
           var category = elementAt(i,taxcgry);
	       if (thiscalcode.calculationUsageId == category.typeId){
	  
	    	<%-- create the new calrule --%>
	        var newCalrule = createNewCalrule(taxtype,0);
	        newCalrule.taxCategoryId = category.categoryId;
	        //var check = isChecked(thiscalcode.calculationCodeId, category.categoryId);
	        //if (check) newCalrule.calculationCodeId = thiscalcode.calculationCodeId;
	        //else newCalrule.calculationCodeId = default_id;
		    newCalrule.calculationCodeId = thiscalcode.calculationCodeId;
		    newCalrule.calculationCodeId = newCalrule.calculationCodeId;
	        newCalrule.sequence = thiscalcode.sequence;
	        addElement(newCalrule,calrule);

	        var newTaxjcrule = new parent.taxjcrule(precedence);
	        newTaxjcrule.calculationRuleId = newCalrule.calculationRuleId;
	        newTaxjcrule.jurisdictionGroupId = newJurstGroup.jurisdictionGroupId;
	        newTaxjcrule.fulfillmentCenterId = ffmcntr;
	        newTaxjcrule.taxJCRuleId = "@taxjcrule_id_" + getTaxjcruleuid();
	        addElement(newTaxjcrule,taxjcrule);
	   }    
       }
    }


    var i = document.f1.definedJurisdictions.options.length;
    if (i==null) i = 1;
    
    var displayName = document.f1.countryList[countryIndex].value;
    if (state != "" && state != null) {
       displayName += ", " + state;
    }
    
    document.f1.definedJurisdictions.options[i] = new Option(displayName, displayName, false, false);
    document.f1.definedJurisdictions.options[i].selected=false;
  }
  
  function isChecked(calcode_id, taxcgry_id) 
  {
    var taxes = parent.get("TaxInfoBean1");
    var calrule = taxes.calrule;

    if (calrule == null) return false;

    for (var i=0; i < size(calrule); i++) {
       var temp = elementAt(i,calrule);

       if (temp.calculationCodeId == calcode_id && temp.taxCategoryId == taxcgry_id) {
          return true;
       }
    }
    return false;
  }

  function removeJurstByCode(jurstName)
  {
    var taxes = parent.get("TaxInfoBean1");
    var jurisdictions = taxes.jurst;
    var calrule = taxes.calrule;
    var jurstgroup = taxes.jurstgroup; 
    var jurstgprel = taxes.jurstgprel;
    var taxFulfillmentInfoBean = parent.get("TaxFulfillmentInfoBean1");
    var taxjcrule = taxFulfillmentInfoBean.taxjcrule;
    var jurstgroup_id;
    
    
    var jurstcode;
    for (var i=0; i < size(jurisdictions); i++) { 
       var temp = elementAt(i,jurisdictions);
       var displayName = temp.country;
       if (temp.state !=null && temp.state != "") displayName = displayName + ", " + temp.state;
       if (displayName == jurstName) jurstcode = temp.code;
       
    }

    for (var i=size(jurisdictions) -1; i >=0 ; i--) { 
       var jurst = elementAt(i,jurisdictions);
       
       var disp = jurst.code;
       if (disp == jurstcode && jurst.subclass == "2") { 
          removeElementAt(i,jurisdictions);
          <%-- add the primary ids to the vector so that it can be deleted from the db --%>
          if (jurst.jurisdictionId.substring(0,1) != "@"){
             //remJurst.addElement(jurst.jurisdictionId);
	         addElement(jurst.jurisdictionId,remJurst);

             }
            
          <%-- remove this jurst from the jurstgprel table --%>
          for (var j=size(jurstgprel) - 1; j >=0 ; j--) {
             var gprel = elementAt(j,jurstgprel);
             if (gprel.jurisdictionId == jurst.jurisdictionId) {
                jurstgroup_id = gprel.jurisdictionGroupId;
                removeElementAt(j,jurstgprel);
             }
          }

          <%-- remove this jurstgroup from the jurstgroup table --%>
          for (var j=size(jurstgroup) - 1; j >= 0; j--) {
             var group = elementAt(j,jurstgroup);
             if (group.jurisdictionGroupId == jurstgroup_id) {
                removeElementAt(j,jurstgroup);
                <%-- add the primary ids to the vector so that it can be deleted from the db --%>
                if (group.jurisdictionGroupId.substring(0,1) != "@"){
                 //remJurstGroup.addElement(group.jurisdictionGroupId);
                 addElement(group.jurisdictionGroupId,remJurstGroup);
                 
                }
             }
          }

          <%-- remove this jurstgroup_id from the taxjcrule table (cascade delete on calrule_id) --%>
          for (var j=size(taxjcrule)-1; j >= 0; j--) {
             var jcrule = elementAt(j,taxjcrule);
             if (jcrule.jurisdictionGroupId == jurstgroup_id) {
                removeCalruleAssociations(jcrule.calculationRuleId);
                                
                for (var k=size(calrule) - 1; k >= 0; k--) {
                   var rule = elementAt(k,calrule);
                   if (rule.calculationRuleId == jcrule.calculationRuleId) {
                      removeElementAt(k,calrule);
                      <%--Remove the calrulation associations as per calculation rule id--%>
                      removeCalruleAssociations(rule.calculationRuleId);
                      <%--Remove the records from updateCalrlookup, updateTaxJcRule,updateCalrule as per calculation rule id if existed--%>
          			  removeCalruleRefUpdates(rule.calculationRuleId);
                      <%-- add the primary ids to the vector so that it can be deleted from the db --%>
                      if (rule.calculationRuleId.substring(0,1) != "@"){
  	                      //remCalRule2.addElement(rule.calculationRuleId);	
  	                      addElement(rule.calculationRuleId,remCalRule2);	

                      }
                      break;
                   }
                }
             }
          }
       }
    }
    parent.put("remJurst", remJurst);
    parent.put("remJurstGroup", remJurstGroup);
    parent.put("remCalRule2",remCalRule2);
  }

  <%--
    -  Delete the selected jurisdiction(s). This is called when the user
    -  clicks 'Remove'
    --%>
  function removeJurisdiction()
  {
    var selectionMade = false;
    var taxes = parent.get("TaxInfoBean1"); 
    var jurisdictions = taxes.jurst;

    <%-- Remove the selected items from the list --%>
    for(var i = document.f1.definedJurisdictions.length-1; i >= 0; i--) {
      if(document.f1.definedJurisdictions[i].selected == true) {

         var removedJurstCode = document.f1.definedJurisdictions[i].value;

			if (removedJurstCode == "<%=taxNLS.getJSProperty("defaultJurisdiction")%>") {
			   alertDialog("<%=taxNLS.getJSProperty("cannotRemoveDefaultJurisdiction")%>");
	         selectionMade = true;
			}
			else {
	         removeJurstByCode(removedJurstCode);
	
	         selectionMade = true;
	         document.f1.definedJurisdictions.options[i] = null;
			}
      }
    }

    <%-- If nothing was selected, prompt the user to select something. --%>
    if (!selectionMade) {
      alertDialog("<%=taxNLS.getJSProperty("SelectJurisdictionToRemove")%>");
      return;
    }
  }

  <%--
    -  Update the page with the appropriate country/region combinations. This
    - function is called whenever the user changes the country.
    -
    - countryListIndex - The index of the selected country in the country list.
    --%>
  function newCountrySelected()
  {
     var newIndex = document.f1.countryList.selectedIndex;
     parent.put("newIndex", newIndex);
     var countryName = document.f1.countryList[newIndex].value;

     //window.location.href = "TaxJurstPanelView?countryName=" + countryName;
     
     var url = "/webapp/wcs/tools/servlet/TaxJurstPanelView";
     var param = new Object();
     param.countryName = countryName;
     
     top.mccmain.submitForm(url,param,"CONTENTS");
     
     selectedCountry = countryName;
  }



  function initialize()
  {
    //if (checkErrorMessages()) return;
    var taxes = parent.get("TaxInfoBean1");
    var editorbean = parent.get("EditorBean1");
    var storeid = parent.get("storeid");
    var calrule = taxes.calrule;
    var calcode = taxes.calcode;
    var calrule = taxes.calrule;
    var crulescale = taxes.crulescale;
    var calrange = taxes.calrange;
    var calrlookup = taxes.calrlookup;
    var calscale = taxes.calscale;
    var jurstgroup = taxes.jurstgroup;
    var jurst = taxes.jurst;
    var taxcgry = taxes.taxcgry;
    var taxFulfillmentInfoBean = parent.get("TaxFulfillmentInfoBean1");
    var taxjcrule = taxFulfillmentInfoBean.taxjcrule;
    var ffmcntr = parent.get("ffmcntr");
//    var default_id;
    var taxtype;
//    var found = false;    
    var newIndex = parent.get("newIndex");
    var nameValuePair = parent.get("nameValuePair");
    
    if (nameValuePair == null || nameValuePair == ""){
     nameValuePair = 1;
     parent.put("nameValuePair",nameValuePair);
     setNameValuePair();
     }

    if (newIndex == null || newIndex == "") newIndex = 0;
  
    getLanguage();
    var ffmcntr = top.ffmId;    // Get Fulfillment Center id from accelerator login
    if (ffmcntr == null || ffmcntr.length == 0){
    	alertDialog("<%=taxNLS.getJSProperty("errorFulfillmentCenterIsNull")%>");
    	top.goBack();
    }
    parent.put("ffmcntr", ffmcntr);
    var storeentities = editorbean.storeent;
    var tmpstoreentities = elementAt(0,storeentities);
    var storeid = tmpstoreentities.storeEntityId;              
    parent.put("storeid", storeid);
           
//    var found = false;       
//    for (var x=0; x < calcode.size(); x++)     {
//       var thiscalcode = calcode.elementAt(x);
//       if (thiscalcode.code == "Default") found = true; 
//    }
//    if (!found) {
//       <%-- populate sequence column --%>
//       var sequence = 0;
//       for (var x=0; x < calcode.size(); x++)     {
//       	 var thiscalcode = calcode.elementAt(x);
//         thiscalcode.sequence = x;
//       }
//       sequence ++;
//       parent.put("sequence", sequence);
//
//       <%-- modify identifier column --%>
//       for (var x=0; x < calrule.size(); x++)     {
//       	 var thiscalrule = calrule.elementAt(x);
//         thiscalrule.identifier = x + 1;
//       }
//              
//       <%-- add default calcode_id to be used in calrule --%>
//
//       var newCode = new parent.calcode();
//       newCode.code = "Default";
//       newCode.calculationCodeId = "@calcode_id_" + getCalcodeuid();
//       
//       newCode.sequence = getSequence();
//       newCode.storeEntityId = storeid;
//       calcode.addElement(newCode);
//       default_id = newCode.calculationCodeId;
//   
//    	<%-- populate calrule for !checked relation and related sequence in AssignTaxCategories --%>
//    	for (var h = 0; h < calcode.size(); h++){
//       	  thiscalcode = calcode.elementAt(h);
//     	  if(thiscalcode.code == "Default") continue;
//     	  if (thiscalcode.calculationUsageId == "-3") taxtype = "sales";
//     	  else if (thiscalcode.calculationUsageId == "-4") taxtype = "shipping";
//     	  else alertDialog("No correct tax type defined in sar!");
//       	  
//   	     for (var i = 0; i < taxcgry.size(); i++){
//   	     var thistaxcgry = taxcgry.elementAt(i);
//   	     if (thiscalcode.calculationUsageId == thistaxcgry.typeId){
//
//       	  	for (var j = 0; j < jurst.size(); j++) {
//       	  	   var thisjurst = jurst.elementAt(j);
//          	   var thisjurstgroup_id = getJurstgroupIdFromJurstId(thisjurst.jurisdictionId);
//
//       	  	   found = false;
//       	  	   for (var k = 0; k < taxjcrule.size(); k++) {
//          		var thistaxjcrule = taxjcrule.elementAt(k);
//          		if(thistaxjcrule.jurisdictionGroupId == thisjurstgroup_id){
//          		   
//          		   for (var m = 0; m < calrule.size(); m++){
//          		      var thiscalrule = calrule.elementAt(m);
//          		      if(thistaxjcrule.calculationRuleId == thiscalrule.calculationRuleId){
//          		   	      if (thistaxcgry.categoryId == thiscalcode.taxCategoryId && thiscalcode.calculationCodeId == thiscalrule.calculationCodeId){
//          		   	         thiscalrule.sequence = thiscalcode.sequence;
//          		   	         found = true;
//          		   	         break;
//          	   	    	}
//          	   	      }
//          	   	   }
//          	   	}
//          	   	if (found) break;   
//          	   }
//          	   
//          	   if (!found){ 
//        	   	var tempcalrlookup = getCalrlookup(thisjurst.jurisdictionId, thistaxcgry.categoryId);
//
//       			if (taxtype == "sales"){
//		        	var newCalrule = new parent.calrule();
//		 	    }
//       			else if (taxtype == "shipping"){
//       				var newCalrule = new parent.shippingcalrule();
//       			}
//                
//       			newCalrule.calculationCodeId = default_id;
//       			newCalrule.taxCategoryId = thistaxcgry.categoryId;
//       			var cid = getCalruleuid();
//       			newCalrule.calculationRuleId = "@calrule_id_" + cid;
//       			newCalrule.identifier = cid;
//       			newCalrule.sequence = thiscalcode.sequence;
//       			calrule.addElement(newCalrule);
//			
//			//
//			var precedence = getPrecedence(thisjurstgroup_id);
//			//
//          
//       			var newTaxjcrule = new parent.taxjcrule(precedence);
//       			newTaxjcrule.calculationRuleId = newCalrule.calculationRuleId;
//       			newTaxjcrule.jurisdictionGroupId = thisjurstgroup_id;
//	        	newTaxjcrule.taxJCRuleId = "@taxjcrule_id_" + getTaxjcruleuid();       			
//       			newTaxjcrule.fulfillmentCenterId = ffmcntr;
//       			taxjcrule.addElement(newTaxjcrule);
//        	  
//        	  	<%-- create a new calrlookup for this calrule --%>
//  			    var newCalrlookup = new parent.calrlookup();
//        	  	newCalrlookup.calculationRangeLookupResultId = "@calrlookup_id_" + getCalrlookupuid();
//        		newCalrlookup.calculationRangeId = "@calrange_id_" + getCalrangeuid();
//        		newCalrlookup.value = tempcalrlookup.value;
//	
//		        <%-- create a new calrange for this calrule --%>
//		      	if (taxtype == "sales"){
//		         	var newCalrange = new parent.calrange();
//		        }
//		        else if (taxtype == "shipping"){
//		          	var newCalrange = new parent.shippingcalrange();
//		        }
//		        newCalrange.calculationRangeId = newCalrlookup.calculationRangeId;
//		        var scaleid = getCalscaleuid();
//		        newCalrange.calculationScaleId = "@calscale_id_" + scaleid;
//			
//		        <%-- create a new calscale for this calrule --%>
//		        if (taxtype == "sales"){
//		        	var newCalscale = new parent.calscale();
//		        }
//		        else if (taxtype == "shipping"){
//		          	newCalscale = new parent.shippingcalscale();
//		        }
//		        newCalscale.calculationScaleId = newCalrange.calculationScaleId;
//		        newCalscale.code = scaleid;
//		        newCalscale.storeEntityId = storeid;
//		
//		        <%-- create a new crulescale --%>
//		        var newCrulescale = new parent.crulescale();
//		        newCrulescale.calculationRuleId = newCalrule.calculationRuleId;
//		        newCrulescale.calculationScaleId = newCalscale.calculationScaleId;
//		        <%-- save the new entries --%>
//		        calrlookup.addElement(newCalrlookup);
//		        calrange.addElement(newCalrange);
//		        calscale.addElement(newCalscale);
//		        crulescale.addElement(newCrulescale);
//		   }
//	    	}
//	     }	
//	  }
//        }
//    }
    
    var jurisdictions = taxes.jurst;
    var count = 0;

    for(var i=0; i < size(jurisdictions); i++) {
        var jurisdiction = elementAt(i,jurisdictions);
        
        if (jurisdiction.subclass != "2") continue;

        var displayName = jurisdiction.country;
        if (jurisdiction.state !=null && jurisdiction.state != "") displayName = displayName + ", "  + jurisdiction.state;
        if (jurisdiction.code == "World" || jurisdiction.code == "world") displayName = "<%=taxNLS.getJSProperty("defaultJurisdiction")%>";
        document.f1.definedJurisdictions.options[count] = new Option(displayName, displayName, false, false);
        document.f1.definedJurisdictions.options[count].selected=false;
        count++;
    }

	<%
		CountryBean.getCountry();
		String [] countryAbbrList = CountryBean.getCodeList();
		
		for (int i=0; i < countryAbbrList.length; i++) {
			if(countryAbbrList[i] == null){ 
				break; 
			}
			out.println("countryAbbrList[" + i + "] ='" + countryAbbrList[i] + "';");
			
		}
		if (areStates != null) {
			String [] stateAbbrList = StateProvBean.getCodeList();
			for (int i=0; i < stateAbbrList.length; i++) {
				if(stateAbbrList[i] == null){ 
					break; 
				}
				out.println("stateAbbrList[" + i + "] ='" + stateAbbrList[i] + "';");
			
		}
			
			
		}
		

	%>
	
    document.f1.countryList[newIndex].selected = true;
    parent.setContentFrameLoaded(true);
  }
  
  function getLanguage()
  {
     if (parent.get("AvailLangList") != null) return;

     var EditorBean_new = parent.get("EditorBean1");
     var storelang = EditorBean_new.storelang;
     var AvailLangList = new Array();
     var AllLangList = new Array();
               
     <%
	Hashtable langlocalehash = LangBean.getLangPairing();  
	Hashtable langdescriphash = LangBean.getLangDescrip();
        if (langlocalehash!=null)
        {
	Enumeration langlist = langlocalehash.keys();
	int x = 0;
  
	while (langlist.hasMoreElements()) {
		String nextkey = (String)langlist.nextElement();
		String descripName = (String)langdescriphash.get(nextkey);
		descripName = UIUtil.toJavaScript(descripName);
		out.println("AllLangList[" + x + "] = new Array();");
		out.println("AllLangList[" + x + "].languageId ='" + nextkey + "';");
		out.println("AllLangList[" + x + "].description ='" + descripName + "';");
		x = x+1;
	}	
         }
      %>
           
      for (var i=0; i < size(storelang); i++){
         AvailLangList[i] = new Array();
         var tmpStorelang = elementAt(i,storelang);
         AvailLangList[i].languageId = tmpStorelang.languageId;
    	 for (var j=0; j < AllLangList.length; j++) {
	       if (AllLangList[j].languageId == AvailLangList[i].languageId)  {
	         AvailLangList[i].description = AllLangList[j].description;
	       }
	     }
       }
     parent.put("AllLangList", AllLangList);
     parent.put("AvailLangList", AvailLangList);
   }
  
   
</SCRIPT>

<BODY ONLOAD="initialize();" CLASS='content'>
<FORM NAME='f1' onsubmit='return false;'>
    <H1><%=taxNLS.getProperty("taxWizardJurisdictionsTab")%></H1>

    <%=taxNLS.getProperty("JurisdictionMsg")%><BR><br>
  <LABEL for="countryList"><%=taxNLS.getProperty("JurisdictionCountry")%></LABEL><BR>
	 <TABLE CELLPADDING=0 BORDER=0 cellspacing="0">
		<TR>
		  <TD width="330" VALIGN=TOP>
		     <TABLE CELLPADDING=0 BORDER=0 cellspacing="0">
					  <TR>
					    <TD width="330" VALIGN=TOP>
                <SELECT NAME=countryList ID=countryList  OnChange='newCountrySelected()' CLASS='selectWidth3'>
					    <%String [] x = CountryBean.getCountry();
							for (int i=0; i < x.length; i++) {
							   if(x[i] == null){ break; }%>
							   <OPTION VALUE='<%=x[i]%>'><%=x[i]%></OPTION><%
							}%>
					    </SELECT>
    		
	 <BR>
	 <BR>
	 <%=taxNLS.getProperty("JurisdictionState")%>
	 <BR>
<%
      // If the starting country has provinces/states, list them in a select box; else a text filed

      if (areStates != null) {
%>
		<LABEL for="regionList"><SELECT NAME=regionList ID=regionList>
		  <% 
		for (int i=0; i < areStates.length; i++) {
		   if(areStates[i] == null){ break; }%>
		   <OPTION VALUE='<%=areStates[i]%>'><%=areStates[i]%></OPTION><%
		}%>
		<OPTION VALUE='<%=taxNLS.getProperty("OtherZoneState")%>'><%=taxNLS.getProperty("OtherZoneState")%></OPTION>
		</SELECT></LABEL>
<%
      }
      else {
%>  
		<LABEL><INPUT TYPE=TEXT name=regionText MAXLENGTH=128></LABEL>
<%
      }
%>

		  </TD>
		</TR>
  </TABLE>
		  </TD>
		  
      <TD WIDTH=428 VALIGN=TOP> 
        <INPUT type="button" id='logon' class="button"
				      value="   <%=taxNLS.getProperty("JurisdictionAddButton")%>    " 
						onClick="addJurisdiction()">
		  </TD>
		</TR>
  </TABLE>

  <br><br>

    <%=taxNLS.getProperty("DefinedJurisdictions")%>

	 <TABLE>
	    <TR>
		  <TD width="325">
		    <LABEL for="definedJurisdictions"><SELECT NAME="definedJurisdictions" ID="definedJurisdictions" SIZE="5" MULTIPLE CLASS='selectWidth3' >  
		    </SELECT></LABEL>
		  </TD>
		  <TD WIDTH=423 VALIGN=TOP>
		    <INPUT type="button" id='logon' class="button"
				      value="<%=taxNLS.getProperty("JurisdictionRemoveButton")%> " 
						onClick="removeJurisdiction()">
		  </TD>
		</TR>
	 </TABLE>
</FORM>
</BODY>
</HTML>

