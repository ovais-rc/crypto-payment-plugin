<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2009, 2010 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@page import="java.util.*,
                com.ibm.commerce.tools.common.*,
                com.ibm.commerce.command.*,
                com.ibm.commerce.server.*,
                com.ibm.commerce.tools.util.*,
                com.ibm.commerce.tools.xml.*,
                com.ibm.commerce.datatype.*,
                com.ibm.commerce.beans.*"
%>
<%@page import="com.ibm.commerce.tools.resourcebundle.*"
%>
<%
  CommandContext cmdContext  = (CommandContext)request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
  Locale locale = cmdContext.getLocale();
  Integer langId = cmdContext.getLanguageId();
  ResourceBundleProperties taxNLS = (ResourceBundleProperties)ResourceDirectory.lookup("taxation.taxationNLS", locale);
  
%>
<%@include file="../common/common.jsp" %>
<HTML>
<HEAD>
<LINK REL=stylesheet HREF="<%=UIUtil.getCSSFile(locale)%>" TYPE="text/css"> 
</HEAD>
<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/common/Vector.js"></SCRIPT>
<%@include file="../common/NumberFormat.jsp" %>

<SCRIPT>
	<%@include file="TaxUtil.jsp" %>
  var taxes = parent.get("TaxInfoBean1");


  var updateCalrlookup = new Vector();
  
  var updateTaxJcRule = new Vector();
  
  var updateCalrule = new Vector();

    function getHeading()
  {
  	return "<%=taxNLS.getJSProperty("taxWizardJurisdictionsTab")%>";
  }

  <%--
    - Return the calrule_id that should be used for this jurisdiction.
    -
    -    jurst_id -> jurstgprel -> jurstgroup -> taxjcrule.calrule_id
    -
    -    subclass=="2" means tax (1 is shipping)
    -
    --%>
  function getJurstgroupIdFromJurstId(jurst_id)
  {
     var taxes = parent.get("TaxInfoBean1");
     var jurstgprel = taxes.jurstgprel;
     var jurstgroup_id = -1;

     for (var i=0; i < size(jurstgprel); i++) {
        var temp = elementAt(i,jurstgprel);
        if (temp.jurisdictionId == jurst_id && temp.subclass=="2") {
           jurstgroup_id = temp.jurisdictionGroupId;
           break;
        }
     }

     if (jurstgroup_id == -1) {
        //alertDialog("jurst_id= " + jurst_id + " does not belong to a group.");
        return;
     }
     
     return jurstgroup_id;
  }

  <%--
    -Return the CalscaleId as per calculationRuleId
    --%>
  function getCalscaleIdFromCalruleId(calrule_id)
  {
     var taxes = parent.get("TaxInfoBean1");
     var crulescale = taxes.crulescale;

     for (var i=0; i < size(crulescale); i++) {
        var temp = elementAt(i,crulescale);
        if (temp.calculationRuleId == calrule_id) {
           return temp.calculationScaleId;
        }
     }

     //alertDialog("Rates.jsp::getCalscaleIdFromCalruleId() - calrule_id=" + calrule_id + " not found in crulescale.");
  }


  <%--
    - Note that we do not support tax ranges. Return the first calrange_id whose
    - calscale_id matches.
    --%>
  function getCalrangeIdFromCalscaleId(calscale_id)
  {
     var taxes = parent.get("TaxInfoBean1");
     var calrange = taxes.calrange;

     for (var i=0; i < size(calrange); i++) {
        var temp = elementAt(i,calrange);
        if (temp.calculationScaleId == calscale_id) {
           return temp.calculationRangeId;
        }
     }

     //alertDialog("Rates.jsp::getCalrangeIdFromCalscaleId() - calscale_id=" + calscale_id + " not found in calrange.");
  }

  <%--
    -Return the Calrlookup as per calrange_id
    --%>
  function getCalrlookupFromCalrangeId(calrange_id)
  {
	var taxes = parent.get("TaxInfoBean1");
	var calrlookup = taxes.calrlookup;
	for (var i=0; i < size(calrlookup); i++)
	{
		var temp = elementAt(i,calrlookup);
		if (temp.calculationRangeId == calrange_id)
			return temp;
	}
	//alertDialog("Rates.jsp::getCalrlookupFromCalrangeId(calrange_id) - no value found for calrange_id=" + calrange_id);
  }

  <%--
    --%>
  function getCalrule(calrule_id)
  {
     var taxes = parent.get("TaxInfoBean1");
     var calrule = taxes.calrule;

     for (var i=0; i < size(calrule); i++) {
        var temp = elementAt(i,calrule);
        if (temp.calculationRuleId == calrule_id) {
           return temp;
        }
     }

     //alertDialog("Rates.jsp::getCalrule() - calrule_id=" + calrule_id + " not found in calrule.");
  }

 <%--
    - Return the tax rate for the calrule_id.
    --%>
  function getCalrlookupFromCalruleId(calrule_id)
  {
    var calrule = getCalrule(calrule_id);
	  
    <%-- find the calscale associated with this calrule --%>
    var calscale_id = getCalscaleIdFromCalruleId(calrule_id);
	
    <%-- find the calrange_id for this calscale_id. --%>
    var calrange_id = getCalrangeIdFromCalscaleId(calscale_id);
	
    <%-- find the value of this calrange_id. --%>
    return getCalrlookupFromCalrangeId(calrange_id);
  }
  
  <%--
    - Return the tax rate for the given (jurisdiction,category) pair.
    --%>
  function getCalrlookup(jurst_id, taxcgry_id, ffmcntr)
  {
     var taxes = parent.get("TaxInfoBean1");
     var calrulebean = taxes.calrule;
     var jurstgroup_id = getJurstgroupIdFromJurstId(jurst_id);
	 
     <%-- now find the calrule_id that has this jurstgroup_id and this taxcgry_id--%>
     var taxFulfillmentInfoBean = parent.get("TaxFulfillmentInfoBean1");
     var taxjcrule = taxFulfillmentInfoBean.taxjcrule;
     var calrule_id = -1;

     for (var i=0; i < size(taxjcrule); i++) {
        var temp = elementAt(i,taxjcrule);
        if (String(temp.jurisdictionGroupId) == String(jurstgroup_id) && String(temp.fulfillmentCenterId) == String(ffmcntr)) {
		   
           <%-- check if this taxjcrule.calrule_id has the right taxcgry_id in the calrule table --%>
           var calrule = getCalrule(temp.calculationRuleId);
		   //alert("calrule for jurst_id"+jurst_id+" , taxcgry_id"+taxcgry_id+" is "+calrule);
		   if(calrule == null) {
		     continue;	
		   }
           if (calrule.taxCategoryId == taxcgry_id) {
              calrule_id = temp.calculationRuleId;
              break;
           }
        }
     }

     if (calrule_id == -1) {
        //alertDialog("Rates.jsp::getTaxRate() - no calrule_id was found for jurstgroup_id = " + jurstgroup_id + " and taxcgry_id=" + taxcgry_id + ".");
        return;
     }

     //alert("find calrule_id"+calrule_id);
     return getCalrlookupFromCalruleId(calrule_id);
  }

	<%--
		- Return the calrlookup as per calrule_id which is called by SetTaxRateByCalruleId
	--%>
  	function getCalrlookup_forSetTaxRateByCalruleId(calrule_id){
	     var calrlookup = new Vector();
	     if (calrule_id != null){
	     	var calrlookup_id = getCalrlookupFromCalruleId(calrule_id);
	     	addElement(calrlookup_id,calrlookup);
	     }
	     if (calrlookup.isEmpty()) {
	       //alertDialog("Rates.jsp::getCalrlookup_forSetTaxRate() - no value found for jurst_id=" + jurst_id + " and taxcgry_id=" + taxcgry_id + ".");
	     }
	     return calrlookup;
  }
	
	<%--
		- Add the tax rate value into updateCallookup
	--%>
	function setTaxRateByCalruleId(calrule_id,newValue){
	    <%-- set the tax rate in all calrlookup --%>
	    var calrlookup = getCalrlookup_forSetTaxRateByCalruleId(calrule_id); 
	     for (var i = 0; i < size(calrlookup); i++) {
			 var row = elementAt(i,calrlookup);
			 if (row != null){
			 	row.value = newValue;
			 	addElement(elementAt(i,calrlookup),updateCalrlookup);
			 }
			 
	    }
	}
	
	<%--
		- Return the tax type id as per tax cateogry id
	--%>
	function getTypeId(taxcgryId){
		var taxes = parent.get("TaxInfoBean1");
		var taxcgry = taxes.taxcgry;
		if (taxcgry != null){
			for (var i=0; i<size(taxcgry); i++){
				if (elementAt(i,taxcgry).categoryId == taxcgryId){
					return elementAt(i,taxcgry).typeId;
				}
			}
		}
	}
  <%--
    - Test each table entry to see if it is a valid tax rate. If all entries
    - are valid, save them.
    -
    - Returns true if all changes can be committed; false otherwise.
    --%>
  function savePanelData()
  {
  		if (TaxRatesList != null && TaxRatesList != undefined){
  			var taxes = parent.get("TaxInfoBean1");
		    var taxFulfillmentInfoBean = parent.get("TaxFulfillmentInfoBean1");
		    var taxjcrule = taxFulfillmentInfoBean.taxjcrule;
		    var calrule = taxes.calrule;
		    var ffmcntr = parent.get("ffmcntr");
		    var calcode = taxes.calcode;
		    for (var i=0; i<TaxRatesList.length; i++){
		    	var data = TaxRatesList[i];
  				var calrule_id = data.calculationRuleId;
  				
  				// save data as per calrule_id and its related calrules
  				var calrule_ids ;
  				for (var j=0; j<TaxRulesPairList.length ; j++){
  					if (TaxRulesPairList[j].calculationRuleId == calrule_id ){
  						calrule_ids = TaxRulesPairList[j].ruleList;
  						break;
  					}
  				}
  				if (calrule_ids != null){
  					for (var j=0; j<calrule_ids.length; j++){
  						var tempCalrule_Id = calrule_ids[j];	
		        	     setTaxRateByCalruleId(tempCalrule_Id,data.rate);
				        //save calrule.start/end date
				        if (calrule!= null){
				        	for (var k=0; k<size(calrule); k++){
				        		if (tempCalrule_Id == elementAt(k,calrule).calculationRuleId){
				        			elementAt(k,calrule).startDate = data.startDate;
	            					elementAt(k,calrule).endDate = data.endDate;
	            					addElement(elementAt(k,calrule),updateCalrule);
				        		}
				        	}
				        }
		        	 	 
		        	 	// save precedence
		        	 	if (taxjcrule != null){
		        	 		for (var k=0; k<size(taxjcrule); k++){
		        	 			var temp = elementAt(k,taxjcrule);
		            	 		var data_jgpId=getJurstgroupIdFromJurstId(data.jurstId);
		            	 		var rule_id = temp.calculationRuleId;
		            	 		if ((rule_id == tempCalrule_Id) && (temp.fulfillmentCenterId == ffmcntr) && (temp.jurisdictionGroupId ==data_jgpId )){
		            	 			elementAt(k,taxjcrule).precedence = data.precedence;
		            	 			addElement(elementAt(k,taxjcrule),updateTaxJcRule);
		            	 		}
		        	 		}
		        	 	}
  					}
  				}
  				
		    }
		    
		     parent.put("updateCalrlookup", updateCalrlookup);	
	         parent.put("updateTaxJcRule",updateTaxJcRule);
	         parent.put("updateCalrule",updateCalrule);
  		}
  	
  	
  	
  	 	//clear data of top
	 	top.saveData(null,"TaxRatesList");
	 	top.saveData(null,"jurstlist");
	 	top.saveData(null,"taxCategoryId");
	 	top.saveData(null,"taxCategory");
	 	top.saveData(null,"TaxRulesPairList");
  }
  
	<%--
		- Return the tax category name as per category id.
	--%>
	function gettaxcgryNameById(taxcgryId){
		var taxes = parent.get("TaxInfoBean1");
		var temp = taxes.taxcgry;
		if ((temp != null) && (taxcgryId != null)){
			for (var i = 0; i<size(temp); i++){
				if (elementAt(i,temp).categoryId == taxcgryId){
					return elementAt(i,temp).name;
				}
			}
		}
		return null;
	}
	
	<%--
		- Return the jurisdiction group id as per calculation rule id.
	--%>
	function getJurstGPId(calrule_id){
		var ffmcntr = parent.get("ffmcntr");
		var taxFulfillmentInfoBean = parent.get("TaxFulfillmentInfoBean1");
		var temptaxjcrule = taxFulfillmentInfoBean.taxjcrule;
		if (temptaxjcrule != null && calrule_id != null){
			for (var i= 0; i<size(temptaxjcrule); i++){
				var jurstgroupId;
				var temp = elementAt(i, temptaxjcrule);
				if (temp.calculationRuleId == calrule_id && temp.fulfillmentCenterId == ffmcntr){
					return temp.jurisdictionGroupId;
				}
			}
		}
	}
	
	<%--
		- Return jurisdiction id as per jurisdiction group id.
	--%>
	function getJurstIdByGourpId(jurstgroupId){
		var taxes = parent.get("TaxInfoBean1");
		var jurstgprel = taxes.jurstgprel;
		for (var i=0; i<size(jurstgprel); i++){
			if (elementAt(i, jurstgprel).jurisdictionGroupId == jurstgroupId){
				return elementAt(i,jurstgprel).jurisdictionId;
			}
		}
	}
	
	<%--
		- Return the jurisdiction description which including country and state as per jurisdiction id.
	--%>
	function getJurstDSById(id){
		var taxes = parent.get("TaxInfoBean1");
		var jurst = taxes.jurst;
		for (var i=0; i<size(jurst); i++){
			var jurstElem = elementAt(i,jurst);
			if (jurstElem.jurisdictionId == id){
				var country = jurstElem.country;
				var state = jurstElem.state;
				
				if (country == null || country ==""){
					country="World"
				}
				if (state == null || state ==""){
					return country;
				}else{
					return country+", "+state;
				}
			}
		}
	}
	
	<%--
		- Return the precedence as per calculation rule id.
	--%>
	function getPrecedenceByRuleId (calrule_id){
		var ffmcntr = parent.get("ffmcntr");
		var taxFulfillmentInfoBean = parent.get("TaxFulfillmentInfoBean1");
		var temptaxjcrule = taxFulfillmentInfoBean.taxjcrule;
		if (temptaxjcrule != null && calrule_id != null){
			for (var i= 0; i<size(temptaxjcrule); i++){
				var jurstgroupId;
				var temp = elementAt(i, temptaxjcrule);
				if (temp.calculationRuleId == calrule_id && temp.fulfillmentCenterId == ffmcntr){
					if (temp.precedence == null){
						return "";
					}else{
						return temp.precedence;
					}
				}
			}
		return "";
		}
	}
	
	<%--
		- Constructor method of TaxRatesData
	--%>
	function TaxRatesData(){
		var obj=new Object();
		obj["calculationRuleId"]='';
		obj["taxcgryId"]='';
		obj["taxcategory"]='';
		obj["jurstId"]='';
		obj["jurisdiction"]='';
		obj["rate"]='';
		obj["startDate"]= '';
		obj["endDate"]= '';
		obj["precedence"]='';
		return obj;
	}
		
	function TaxRulesPair (){
		var obj = new Object();
		var rules = new Array();
		obj["calculationRuleId"] = '';
		obj["ruleList"] = new Array();
		return obj;
	}
	   
	  var TaxRatesList =top.getData("TaxRatesList");
	  
	  var TaxRulesPairList = top.getData("TaxRulesPairList");
	  if (TaxRulesPairList == null){
	  		TaxRulesPairList = new Array();
	  }
	  if (TaxRatesList == null || TaxRatesList == undefined){
	  	TaxRatesList = new Array();
	  	
	  	 var taxes =parent.get("TaxInfoBean1");
	  	 
	  	 
	  	var jurst = taxes.jurst;
    	var taxcgry = taxes.taxcgry;
    	var codes = taxes.calcode;
		var errorMessage;
		top.saveData(true, "parameterIsEnough");
	    if (size(jurst) == 0) {
	    	errorMessage = "<%=taxNLS.getJSProperty("NoJurisdictionsDefined")%>";
	      
	    }
	    else if (size(taxcgry) == 0) {
	    	errorMessage = "<%=taxNLS.getJSProperty("NoCategoriesDefined")%>";
	       
	    } 
	    else if (size(codes) == 0) {
	    	errorMessage = "<%=taxNLS.getJSProperty("NoCodesDefined")%>";
	    }
    	
    	if (errorMessage != null){
    		alertDialog(errorMessage);
    		top.saveData(false, "parameterIsEnough");
    		top.saveData(errorMessage,"errorMessage");
    	}
    
    
	  	 var calrules = taxes.calrule;
	  	 if (calrules != null){
	  	 	var remTaxcgrys = new Array();
	  	 	var remJursts = new Array();
	  	 	var index=0;
	  	 	for (var i=0; i<size(calrules); i++){
	  	 		var tempData = TaxRatesData();
	  	 		var ruleElem = elementAt(i, calrules);
	  	 		tempData.calculationRuleId = ruleElem.calculationRuleId;
	  	 		tempData.taxcgryId = ruleElem.taxCategoryId;
		  	 	tempData.taxcategory =gettaxcgryNameById(tempData.taxcgryId);
		  	 	tempData.jurstId = getJurstIdByGourpId(getJurstGPId(ruleElem.calculationRuleId));
		  	 	tempData.jurisdiction =getJurstDSById(tempData.jurstId);
		  	 	var value;
		  	 	if (getCalrlookupFromCalruleId(ruleElem.calculationRuleId) != null){
		  	 		value =getCalrlookupFromCalruleId(ruleElem.calculationRuleId).value;
		  	 	}
		  	 	
		  	 	if (value == null){
		  	 		tempData.rate = 0;
		  	 	}else{
		  	 		tempData.rate =value;
		  	 	}
		  	 	
		  	 	
		  	 	tempData.startDate = ruleElem.startDate;
		  	 	tempData.endDate = ruleElem.endDate;
		  	 	tempData.precedence = getPrecedenceByRuleId(ruleElem.calculationRuleId);
		  	 	
		  	 	// remove the duplicate lines for different tax codes
		  	 	var flag = true;
		  	 	for (var j = 0; j<TaxRatesList.length; j++){
		  	 		var temp = TaxRatesList[j];
		  	 		if (temp.taxcgryId == tempData.taxcgryId && temp.jurstId == tempData.jurstId && temp.rate == tempData.rate){
		  	 			flag = false;
		  	 			// add this rules to list
		  	 			for (var k= 0; k<TaxRulesPairList.length; k++){
		  	 				if (TaxRulesPairList[k].calculationRuleId == temp.calculationRuleId){
		  	 					var len = TaxRulesPairList[k].ruleList.length;
		  	 					TaxRulesPairList[k].ruleList[len]=tempData.calculationRuleId;
		  	 				}
		  	 			}
		  	 			break;
		  	 		}
		  	 	}
		  	 	
		  	 	if (flag){
		  	 		// if same jurisdiction, same rate, same tax cateogry then add the rules to TaxCodeRulesPairList but not to add to TaxRatesList
		  	 		TaxRatesList[index]=tempData;
		  	 		// create a new TaxRulesPair add it to TaxRulesPairList
		  	 		var taxRulesPair = TaxRulesPair();
		  	 		taxRulesPair.calculationRuleId = tempData.calculationRuleId;
		  	 		taxRulesPair.ruleList[0]= tempData.calculationRuleId;
		  	 		TaxRulesPairList [index] = taxRulesPair;
		  	 		index = index+1;
		  	 	}
		  	 		  	 		
	  	 	}
	  	 }
	    
	  	top.saveData(TaxRatesList,"TaxRatesList");
	  	top.saveData(TaxRulesPairList,"TaxRulesPairList");
	  }
	  
	// add the new one to the TaxRatesList
	var isAdded = false;
	
	if (top.getData("isAdded") != null){
		isAdded = top.getData("isAdded");
		if (isAdded){
			var result = top.getData("taxRatesResult");
			//create a new Calrule
			var taxes = parent.get("TaxInfoBean1");
		    var taxFulfillmentInfoBean = parent.get("TaxFulfillmentInfoBean1");
		    var taxjcrule = taxFulfillmentInfoBean.taxjcrule;
		    var calrule = taxes.calrule;
		    var ffmcntr = parent.get("ffmcntr");
		    var calcode = taxes.calcode;
		    var taxcgryId = top.getData("taxCategoryId"); 					
  			var typeId = getTypeId(taxcgryId);

  			var rate = 0;
			if (result.rate != null && result.rate != ""){
				rate = result.rate;
			}else{
				result.rate=rate;
			}
  			var dup_flag = true;
  			for (var j = 0; j<TaxRatesList.length; j++){
		  	 		var temp = TaxRatesList[j];
		  	 		if (temp.taxcgryId == result.taxcgryId && temp.jurstId == result.jurstId && temp.rate == rate){
		  	 			dup_flag = false;
		  	 			alertDialog("<%=taxNLS.getJSProperty("TaxRateAlreadyExists")%>");
		  	 		}
		  	}	
		  	if (dup_flag) { 		
	  			for (var k=0; k < size(calcode); k++){
	  				var thiscalcode = elementAt(k,calcode);
					var taxtype = null;
					if (thiscalcode.calculationUsageId == "-3") taxtype = "sales";
					else if (thiscalcode.calculationUsageId == "-4") taxtype = "shipping";
					else alertDialog("No correct tax type defined in sar!");
					if (typeId == thiscalcode.calculationUsageId){
						<%-- create the new calrule --%>
						
			       		var newCalrule = createNewCalrule(taxtype, rate);
			       	  	newCalrule.taxCategoryId = taxcgryId;
			       	  	newCalrule.taxCategoryId = taxcgryId;
			       	  	newCalrule.calculationCodeId = thiscalcode.calculationCodeId;
			       	  	newCalrule.calculationCodeId = thiscalcode.calculationCodeId;
			       	  	newCalrule.sequence = thiscalcode.sequence;
			       	  	newCalrule.sequence = thiscalcode.sequence;
			       	  	newCalrule.startDate = result.startDate;
			       	  	newCalrule.endDate = result.endDate;
			       	  	addElement(newCalrule,calrule);
			       	  	
			       	  	
			       	  	
			       	  	var jurstGroupID = getJurstgroupIdFromJurstId(result.jurstId);
			       	  	var precedence = 0;
			       	  
			       	  	if (result.precedence != null && result.precedence != ""){
			       	  		precedence=result.precedence;
			       	  	}else{
			       	  		result.precedence = precedence;
			       	  	}
			       	  	var newTaxjcrule = new parent.taxjcrule(precedence);
			       	  	newTaxjcrule.calculationRuleId = newCalrule.calculationRuleId;
			          	newTaxjcrule.calculationRuleId = newTaxjcrule.calculationRuleId;
			       	  	newTaxjcrule.jurisdictionGroupId = jurstGroupID;
					  	newTaxjcrule.fulfillmentCenterId = ffmcntr;						
			       	  	newTaxjcrule.taxJCRuleId = "@taxjcrule_id_" + getTaxjcruleuid();
			       	  	addElement(newTaxjcrule,taxjcrule);
			       	  	
			       	  	//compose calrule and its related rules
			       	  	
			       	  	if (result.calculationRuleId == null || result.calculationRuleId == ""){
				       	  	//add this new calrule_id to the result.calculationRuleId
				       	  	result.calculationRuleId =  newCalrule.calculationRuleId;
			       	  		var taxRulesPair = TaxRulesPair();
			  	 			taxRulesPair.calculationRuleId = newCalrule.calculationRuleId;
			  	 			var ruleList= taxRulesPair.ruleList;
			       	  		ruleList[ruleList.length]=newCalrule.calculationRuleId;
			       	  		TaxRulesPairList [TaxRulesPairList.length] = taxRulesPair;
			       	  	}else{
			       	  		var ruleList = TaxRulesPairList [TaxRulesPairList.length-1].ruleList;
			       	  		ruleList[ruleList.length]=newCalrule.calculationRuleId;
			       	  	}
			       	  	
			       	}
	  			}
	  			
	  			//add this new one to the list
				if (TaxRatesList == null){
					TaxRatesList = new Array();
				}
				TaxRatesList[TaxRatesList.length]=result;
		  	}
			
			top.saveData(false,"isAdded");
			top.saveData(TaxRatesList,"TaxRatesList");
			top.saveData(TaxRulesPairList,"TaxRulesPairList");
		}
	}

</SCRIPT>
  <FRAMESET ROWS="100,*" BORDER=0>
      <FRAME NAME="Description"
               SRC="TaxRatesTopView"
               TITLE="<%=taxNLS.getJSProperty("taxWizardRatesTab")%>"
               FRAMEBORDER="0"
               BORDER="0"
               NORESIZE
               SCROLLING="no"
               MARGINWIDTH=15
               MARGINHEIGHT=15>
      <FRAME NAME="TaxRatesTable"
               SRC="TaxRatesListView"
               TITLE="<%=taxNLS.getJSProperty("taxWizardRatesTab")%>"
               FRAMEBORDER="0"
               BORDER="0"
               NORESIZE
               SCROLLING="auto"
               MARGINWIDTH=15
               MARGINHEIGHT=10>
   </FRAMESET>
  
</HTML>

