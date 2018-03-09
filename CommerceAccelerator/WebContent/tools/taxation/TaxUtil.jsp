<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2000, 2017 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

var remCalScale = new Vector();

function compareValues(a, b)
  {
    if ( a > b ) return 1;
    else if ( a < b ) return -1;
    else return 0;
  }

  function compareMixedCase(x, y)
  {
    if (x.toLowerCase() == y.toLowerCase()) return true;
    else return false;
  }
  
  function getSequence()
  {
     var sequence = parent.get("sequence");
     
     if (sequence == null) {
     
        var taxes = parent.get("TaxInfoBean1");
        var calcode = taxes.calcode;
     
        if (size(calcode) == 0) {
           sequence = 0;
           parent.put("sequence", sequence);
           return sequence;
        } 
        else {
       		var sequence = 0;
       		for (var x=0; x < size(calcode); x++)     {
       			var thiscalcode = elementAt(x,calcode);
       			thiscalcode.sequence = x;
			sequence = x;
       		}
       		sequence ++;
       		parent.put("sequence", sequence);
           	return sequence;
        }
     } 
     else {
        sequence ++;
        parent.put("sequence", sequence);
        return sequence;
     }  
  
  }
  
  function getJurstuid()
  {
     var jurstuid = parent.get("jurstuid");
     
     if (jurstuid == null) {
     
        var taxes = parent.get("TaxInfoBean1");
        var jurst = taxes.jurst;
     
        if (size(jurst) == 0) {
           jurstuid = 100;
           parent.put("jurstuid", jurstuid);
           return jurstuid;
        } else {
           var idArray = new Array();
           for (var i=0; i < size(jurst); i++) {
              var thisjurst = elementAt(i,jurst);
              if (thisjurst.jurisdictionId.substring(0,10) == "@jurst_id_") idArray[idArray.length] = parseFloat(thisjurst.jurisdictionId.substring(10));
           }
           if (idArray.length != 0) {
              idArray.sort(compareValues);
              jurstuid = idArray[idArray.length -1] + 1;
           } else jurstuid = 100;
           
           parent.put("jurstuid", jurstuid);
           return jurstuid;
        }
     } else {
        jurstuid++;
        parent.put("jurstuid", jurstuid);
        return jurstuid;
     }
     
  }



  function getJurstgroupuid()
  {
     var jurstgroupuid = parent.get("jurstgroupuid");
     
     if (jurstgroupuid == null) {
     
        var taxes = parent.get("TaxInfoBean1");
        var jurstgroup = taxes.jurstgroup;
        
        if (size(jurstgroup) == 0) {
           jurstgroupuid = 100;
           parent.put("jurstgroupuid", jurstgroupuid);
           return jurstgroupuid;
        } else {
           var idArray = new Array();
           for (var i=0; i < size(jurstgroup); i++) {
              var thisjurstgroup = elementAt(i,jurstgroup);
              if (thisjurstgroup.jurisdictionGroupId.substring(0,15) == "@jurstgroup_id_") idArray[idArray.length] = parseFloat(thisjurstgroup.jurisdictionGroupId.substring(15));
           }
           if (idArray.length != 0) {
              idArray.sort(compareValues);
              jurstgroupuid = idArray[idArray.length -1] + 1;
           }else jurstgroupuid = 100;   
           parent.put("jurstgroupuid", jurstgroupuid);
           return jurstgroupuid;
        }
     } else {
        jurstgroupuid++;
        parent.put("jurstgroupuid", jurstgroupuid);
        return jurstgroupuid;
     }
     
  }


  function getCalcodeuid()
  {
     var calcodeuid = parent.get("calcodeuid");
     
     if (calcodeuid == null) {
     
        var taxes = parent.get("TaxInfoBean1");
        var calcode = taxes.calcode;
     
//        if (size(calcode) == 0) {
//           calcodeuid = 1;
//           parent.put("calcodeuid", calcodeuid); 
//           return calcodeuid;
//        } else {
//           var idArray = new Array();
//           for (var i=0; i < size(calcode); i++) {
//              var thiscalcode = elementAt(i,calcode);
//              if (thiscalcode.calculationCodeId.substring(0,12) == "@calcode_id_") idArray[idArray.length] = parseFloat(thiscalcode.calculationCodeId.substring(12));
//           }
//           if (idArray.length != 0) {
//              idArray.sort(compareValues);
//              calcodeuid = idArray[idArray.length -1] + 1;
//           }else calcodeuid = 100;   
//           parent.put("calcodeuid", calcodeuid);
//           return calcodeuid;
//        }
	var allowed = '0123456789';
	var calcodeuid = 100;
	for(var i=1; i < size(calcode); i++) {
	 var thiscalcode = elementAt(i,calcode);
	 if(isValid(elementAt(i,calcode).calculationCodeId, allowed)) {
		 if(elementAt(i,calcode).calculationCodeId > calcodeuid) calcodeuid = elementAt(i,calcode).calculationCodeId;
	 }	 
	}
	calcodeuid++;
	parent.put("calcodeuid", calcodeuid);
	return calcodeuid;
     } else {
        calcodeuid++;
        parent.put("calcodeuid", calcodeuid);
        return calcodeuid;
     }
  }


  function isValid(string,allowed) {
    for (var i=0; i< string.length; i++) {
       if (allowed.indexOf(string.charAt(i)) == -1)
          return false;
    }
    return true;
  }

  function getCalrangeuid()
  {
     var calrangeuid = parent.get("calrangeuid");
     
     if (calrangeuid == null) {
     
        var taxes = parent.get("TaxInfoBean1");
        var calrange = taxes.calrange;
     
        if (size(calrange) == 0) {
           calrangeuid = 1;
           parent.put("calrangeuid", calrangeuid);
           return calrangeuid;
        } else {
           var idArray = new Array();
           for (var i=0; i < size(calrange); i++) {
              var thiscalrange = elementAt(i,calrange);
              if (thiscalrange.calculationRangeId.substring(0,13) == "@calrange_id_") idArray[idArray.length] = parseFloat(thiscalrange.calculationRangeId.substring(13));
           }
           if (idArray.length != 0) {
              idArray.sort(compareValues);
              calrangeuid = idArray[idArray.length -1] + 1;
           }else calrangeuid = 100;   
           parent.put("calrangeuid", calrangeuid);
           return calrangeuid;
        }
     } else {
        calrangeuid++;
        parent.put("calrangeuid", calrangeuid);
        return calrangeuid;
     }
     
  }


  function getCalrlookupuid()
  {
     var calrlookupuid = parent.get("calrlookupuid");
     
     if (calrlookupuid == null) {
     
        var taxes = parent.get("TaxInfoBean1");
        var calrlookup = taxes.calrlookup;
     
        if (size(calrlookup) == 0) {
           calrlookupuid = 1000;
           parent.put("calrlookupuid", calrlookupuid);
           return calrlookupuid;
        } else {
           var idArray = new Array();
           for (var i=0; i < size(calrlookup); i++) {
              var thiscalrlookup = elementAt(i,calrlookup);
              if (thiscalrlookup.calculationRangeLookupResultId.substring(0,15) == "@calrlookup_id_") idArray[idArray.length] = parseFloat(thiscalrlookup.calculationRangeLookupResultId.substring(15));
           }
           if (idArray.length != 0) {
              idArray.sort(compareValues);
              calrlookupuid = idArray[idArray.length -1] + 1;
           }else calrlookupuid = 1000;   
           parent.put("calrlookupuid", calrlookupuid);
           return calrlookupuid;
        }
     } else {
        calrlookupuid++;
        parent.put("calrlookupuid", calrlookupuid);
        return calrlookupuid;
     }
     
  }
  
  
  function getCalruleuid()
  {
     var calruleuid = parent.get("calruleuid");
     
     if (calruleuid == null) {
     
        var taxes = parent.get("TaxInfoBean1");
        var calrule = taxes.calrule;
     
        if (size(calrule) == 0) {
           calruleuid = 1000;
           parent.put("calruleuid", calruleuid);
           return calruleuid;
        } else {
           var idArray = new Array();
           for (var i=0; i < size(calrule); i++) {
              var thiscalrule = elementAt(i,calrule);
              if (thiscalrule.calculationRuleId.substring(0,12) == "@calrule_id_") idArray[idArray.length] = parseFloat(thiscalrule.calculationRuleId.substring(12));
           }
           if (idArray.length != 0) {
              idArray.sort(compareValues);
              calruleuid = idArray[idArray.length -1] + 1;
           }else calruleuid = 1000;   
           parent.put("calruleuid", calruleuid);
           return calruleuid;
        }
     } else {
        calruleuid++;
        parent.put("calruleuid", calruleuid);
        return calruleuid;
     }
     
  }
  
  
  function getCalscaleuid()
  {
     var calscaleuid = parent.get("calscaleuid");
     
     if (calscaleuid == null) {
     
        var taxes = parent.get("TaxInfoBean1");
        var calscale = taxes.calscale;
     
        if (size(calscale) == 0) {
           calscaleuid = 1000;
           parent.put("calscaleuid", calscaleuid);
           return calscaleuid;
        } else {
           var idArray = new Array();
           for (var i=0; i < size(calscale); i++) {
              var thiscalscale = elementAt(i,calscale);
              if (thiscalscale.calculationScaleId.substring(0,13) == "@calscale_id_") idArray[idArray.length] = parseFloat(thiscalscale.calculationScaleId.substring(13));
           }
           if (idArray.length != 0) {
              idArray.sort(compareValues);
              calscaleuid = idArray[idArray.length -1] + 1;
           }else calscaleuid = 1000;   
           parent.put("calscaleuid", calscaleuid);
           return calscaleuid;
        }
     } else {
        calscaleuid++;
        parent.put("calscaleuid", calscaleuid);
        return calscaleuid;
     }
     
  }
  
  
  function getTaxcgryuid()
  {
     var taxcgryuid = parent.get("taxcgryuid");
     
     if (taxcgryuid == null) {
     
        var taxes = parent.get("TaxInfoBean1");
        var taxcgry = taxes.taxcgry;
     
        if (size(taxcgry) == 0) {
           taxcgryuid = 100;
           parent.put("taxcgryuid", taxcgryuid);
           return taxcgryuid;
        } else {
           var idArray = new Array();
           for (var i=0; i < size(taxcgry); i++) {
              var thistaxcgry = elementAt(i,taxcgry);
              if (thistaxcgry.categoryId.substring(0,12) == "@taxcgry_id_") idArray[idArray.length] = parseFloat(thistaxcgry.categoryId.substring(12));
           }
           if (idArray.length != 0) {
              idArray.sort(compareValues);
              taxcgryuid = idArray[idArray.length -1] + 1;
           } else taxcgryuid = 100;   
           parent.put("taxcgryuid", taxcgryuid);
           return taxcgryuid;
        }
     } else {
        taxcgryuid++;
        parent.put("taxcgryuid", taxcgryuid);
        return taxcgryuid;
     }
     
  }

  <%--
    -  Returns a new calrule object with all of the dependant table rows
    - created and populated with the default values;
    --%>
  function createNewCalrule(taxtype, tempcalrlookup)
  {
      var taxes = parent.get("TaxInfoBean1");
      var storeid = parent.get("storeid");
      var calrlookup = taxes.calrlookup;
      var calrange = taxes.calrange;
      var calscale = taxes.calscale;
      var crulescale = taxes.crulescale;
      var calcode = taxes.calcode;
      var calcode_id;
      
//      for (var x=0; x < size(calcode); x++) {
//         var thiscalcode = elementAt(x,calcode);
//         if(thiscalcode.code == "Default") {
//            calcode_id = thiscalcode.calculationCodeId;
//            break;
//         }
//      }

      <%-- create a new calrlookup for this calrule --%>
      var newCalrlookup = new parent.calrlookup();
      newCalrlookup.calculationRangeLookupResultId = "@calrlookup_id_" + getCalrlookupuid();
	  newCalrlookup.calculationRangeLookupResultId = newCalrlookup.calculationRangeLookupResultId;
      newCalrlookup.calculationRangeId = "@calrange_id_" + getCalrangeuid();
	  newCalrlookup.calculationRangeId = newCalrlookup.calculationRangeId;
      newCalrlookup.value = tempcalrlookup;
	  newCalrlookup.value = tempcalrlookup;
            
      <%-- create a new calrange for this calrule --%>
      if (taxtype == "sales"){
       	var newCalrange = new parent.calrange();
      }
      else if (taxtype == "shipping"){
       	var newCalrange = new parent.shippingcalrange();
      }
      newCalrange.calculationRangeId = newCalrlookup.calculationRangeId;
	  newCalrange.calculationRangeId = newCalrlookup.calculationRangeId;
      var scaleid = getCalscaleuid();
      newCalrange.calculationScaleId = "@calscale_id_" + scaleid;
	  newCalrange.calculationScaleId = newCalrange.calculationScaleId;

      <%-- create a new calscale for this calrule --%>
      if (taxtype == "sales"){
       	var newCalscale = new parent.calscale();
      }
      else if (taxtype == "shipping"){
       	newCalscale = new parent.shippingcalscale();
      }
      newCalscale.calculationScaleId = newCalrange.calculationScaleId;
      newCalscale.calculationScaleId = newCalrange.calculationScaleId;
      newCalscale.code = scaleid;
      newCalscale.storeEntityId = storeid;
      newCalscale.storeEntityId = storeid;

      <%-- create a new calrule --%>
      if (taxtype == "sales"){
       	var newCalrule = new parent.calrule();
      }
      else if (taxtype == "shipping"){
       	var newCalrule = new parent.shippingcalrule();
      }
      var cid = getCalruleuid();
      newCalrule.calculationRuleId = "@calrule_id_" + cid;
      newCalrule.calculationRuleId = newCalrule.calculationRuleId;
      newCalrule.calculationCodeId = calcode_id;
	  newCalrule.calculationCodeId = newCalrule.calculationCodeId;
      newCalrule.identifier = cid;
	  newCalrule.identifier = cid;
      
      <%-- create a new crulescale --%>
      var newCrulescale = new parent.crulescale();
      newCrulescale.calculationRuleId = newCalrule.calculationRuleId;
      newCrulescale.calculationRuleId = newCalrule.calculationRuleId;
      newCrulescale.calculationScaleId = newCalscale.calculationScaleId;
	  newCrulescale.calculationScaleId = newCalscale.calculationScaleId;

      <%-- save the new entries --%>
      addElement(newCalrlookup,calrlookup);
      addElement(newCalrange,calrange);
      addElement(newCalscale,calscale);
      addElement(newCrulescale,crulescale);

      return newCalrule;
  }



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
        alertDialog("Rates1.jsp::getJurstgroupIdFromJurstId() - jurst_id= " + jurst_id + " does not belong to a group.");
        return;
     }      
     
     return jurstgroup_id;
  }


  function removeCalruleAssociations(calrule_id)
  {
    var taxes = parent.get("TaxInfoBean1");
    var taxFulfillmentInfoBean = parent.get("TaxFulfillmentInfoBean1");
    var taxjcrule = taxFulfillmentInfoBean.taxjcrule;
    var crulescale = taxes.crulescale;
    var calscale = taxes.calscale;
    var calscaleds = taxes.calscaleds;
    var calrange = taxes.calrange;
    var calrlookup = taxes.calrlookup;
    
    
    <%-- remove this calrule from taxjcrule --%>
    for (var i=size(taxjcrule)-1; i >= 0 ; i--) {
       var temp = elementAt(i,taxjcrule);
       if (temp.calculationRuleId == calrule_id) {
          removeElementAt(i,taxjcrule);
       }
    }


    <%-- remove this calrule from crulescale (this cascades) --%>
    for (var i=size(crulescale)-1; i >= 0; i--) {
       var thisCrulescale = elementAt(i,crulescale);

       if (thisCrulescale.calculationRuleId == calrule_id) {

           var calscale_id = thisCrulescale.calculationScaleId;

           <%-- remove this calscale_id from the calscale table --%>
           for (var j=size(calscale)-1; j >=0 ; j--) {
              var tmp = elementAt(j,calscale);
              
               if (tmp.calculationScaleId == calscale_id) {
				     if (calscaleds != null){
					     for (var n=size(calscaleds) -1; n >= 0; n--) {
						     var thiscalscaleds = elementAt(n,calscaleds);
							  if (thiscalscaleds.calscale_id == calscale_id) {
								removeElementAt(n,calscaleds);
							  }	
						  }
					  } 
                 removeElementAt(j,calscale);
		     <%-- add the primary ids to the vector so that it can be deleted from the db --%>
                 if (tmp.calculationScaleId.substring(0,1) != "@"){
                     addElement(tmp.calculationScaleId,remCalScale);
                 }
              }
           }

           <%-- remove this calscale_id from the calrange table (this cascades to calrlookup) --%>
           for (var j=size(calrange) - 1; j >= 0; j--) {
              var tmp = elementAt(j,calrange);

              if (tmp.calculationScaleId == calscale_id) {
                 var calrange_id = tmp.calculationRangeId;

                 <%-- remove this calrange_id from the calrlookup table --%>
                 for (var k=size(calrlookup)-1; k >= 0; k--) {
                    var tmp2 = elementAt(k,calrlookup);
      
                    if (tmp2.calculationRangeId == calrange_id) {
                       removeElementAt(k,calrlookup);
                    }
                 }
                 <%--remove the records which is associated with the calrange_id from updateCalrlookup --%>
                 removeCalrangeRefUpdates(calrange_id);
                 removeElementAt(j,calrange);
                
              } 
           }

           removeElementAt(i,crulescale);
       }
    }
    parent.put("remCalScale",remCalScale);
  }
  
  <%--
  	 - This method remove the calrlookup records from updateCalrlookup,which is associated with the calrange_id.
  --%>
  function removeCalrangeRefUpdates(calrange_id){
  
  	 var updateCalrlookup = parent.get("updateCalrlookup");
  	 if (updateCalrlookup != null){
		  for (var i=0; i< size(updateCalrlookup) ; i++){
		  	var temp = elementAt(i,updateCalrlookup);
		 		if (temp.calculationRangeId == calrange_id){
					removeElementAt(i,updateCalrlookup);		
		 		}
		  }
	 }
	 
  }
  
  <%--
  	 - This method remove the records from updateTaxJcRule and updateCalrule ,which is associated with the calrule_id.
  --%>
  
  function removeCalruleRefUpdates(calrule_id){
  
	
	 var updateTaxJcRule = parent.get("updateTaxJcRule");
	 var updateCalrule = parent.get("updateCalrule");
	 
	 
	 if (updateTaxJcRule != null){
	 	for (var i=0; i< size(updateTaxJcRule); i++){
	 		var temp = elementAt(i,updateTaxJcRule);
	 		if (temp.calculationRuleId == calrule_id){
	 			removeElementAt(i,updateTaxJcRule);
	 		}
	 	}
	 }
	 
	 if (updateCalrule != null){
	 	for (var i = 0; i< size(updateCalrule); i++){
	 		var temp = elementAt(i,updateCalrule);
	 		if (temp.calculationRuleId == calrule_id){
	 			removeElementAt(i,updateCalrule);
	 		}
	 	}
	 }
  }
  

  <%--
    - Return the tax rate for the given (jurisdiction,category) pair.
    --%>
  function getCalrlookup(jurst_id, taxcgry_id)
  {
     var taxes = parent.get("TaxInfoBean1");
     var calrulebean = taxes.calrule;
     var jurstgroup_id = getJurstgroupIdFromJurstId(jurst_id);
     var ffmcntr = parent.get("ffmcntr");
     
     <%-- now find the calrule_id that has this jurstgroup_id and this taxcgry_id--%>
     var taxFulfillmentInfoBean = parent.get("TaxFulfillmentInfoBean1");
     var taxjcrule = taxFulfillmentInfoBean.taxjcrule;
     var calrule_id = -1;

     for (var i=0; i < size(taxjcrule); i++) {
        var temp = elementAt(i,taxjcrule);
        if (temp.jurisdictionGroupId == jurstgroup_id && temp.fulfillmentCenterId == ffmcntr) {
         <%-- check if this taxjcrule.calrule_id has the right taxcgry_id in the calrule table --%>
	     var calrule = getCalrule(temp.calculationRuleId);
	     
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
//        alertDialog("no calrule_id was found for jurstgroup_id = " + jurstgroup_id + " and taxcgry_id=" + taxcgry_id + ".");
        return;
     }


     <%-- find the calscale associated with this calrule --%>
     var calscale_id = getCalscaleIdFromCalruleId(calrule_id);

     <%-- find the calrange_id for this calscale_id. --%>
     var calrange_id = getCalrangeIdFromCalscaleId(calscale_id);

     <%-- find the value of this calrange_id. --%>
     var calrlookup = taxes.calrlookup;
	
     for (var i=0; i < size(calrlookup); i++) {
        var temp = elementAt(i,calrlookup);
        if (temp.calculationRangeId == calrange_id) {
           return temp;
        }
     }
     
     //alertDialog("Rates.jsp::getCalrlookup() - no value found for jurst_id=" + jurst_id + " and taxcgry_id=" + taxcgry_id + ".");
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
    -
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
        //alertDialog("Rates.jsp::getJurstgroupIdFromJurstId() - jurst_id= " + jurst_id + " does not belong to a group.");
        return;
     }
     
     return jurstgroup_id;
  }

  function getTaxjcruleuid()
  {
     var taxjcruleuid = parent.get("taxjcruleuid");
     
     if (taxjcruleuid == null) {
     
//        var taxFulfillmentInfoBean = parent.get("TaxFulfillmentInfoBean1");
//     	var taxjcrule = taxFulfillmentInfoBean.taxjcrule;

//        if (size(taxjcrule) == 0) {
           taxjcruleuid = 1000;
           parent.put("taxjcruleuid", taxjcruleuid);
           return taxjcruleuid;
//        } else {
//           var idArray = new Array();
//           for (var i=0; i < size(taxjcrule); i++) {
//              var thistaxjcrule = elementAt(i,taxjcrule);
//              if (thistaxjcrule.taxJCRuleId.substring(0,14) == "@taxjcrule_id_") idArray[idArray.length] = parseFloat(thistaxjcrule.taxJCRuleId.substring(14));
//           }
//           if (idArray.length != 0) {
//              idArray.sort(compareValues);
//              taxjcruleuid = idArray[idArray.length -1] + 1;
//           }else taxjcruleuid = 1000;   
//           parent.put("taxjcruleuid", taxjcruleuid);
//           return taxjcruleuid;
//        }
     } else {
        taxjcruleuid++;
        parent.put("taxjcruleuid", taxjcruleuid);
        return taxjcruleuid;
     }
     
  }
  
  function getPrecedence(ajurstgroup_id)
  {
    var taxFulfillmentInfoBean = parent.get("TaxFulfillmentInfoBean1");
    var taxjcrule = taxFulfillmentInfoBean.taxjcrule;
    var thisprecedence;
    
    for (j=0; j < size(taxjcrule); j++) {
       var thistaxjcrule = elementAt(j,taxjcrule);
       if (thistaxjcrule.jurisdictionGroupId == ajurstgroup_id) {
          thisprecedence=thistaxjcrule.precedence;
          return(thisprecedence);
       }
    }
  }
             
  function setNameValuePair()
  {    
    var taxFulfillmentInfoBean = parent.get("TaxFulfillmentInfoBean1");
    var taxjcrule = taxFulfillmentInfoBean.taxjcrule;
    
    for(var i=0; i< size(taxjcrule); i++) {
       var thistaxjcrule = elementAt(i,taxjcrule);
       if (thistaxjcrule.jurisdictionGroupId) thistaxjcrule.jurisdictionGroupIdInEntityType = thistaxjcrule.jurisdictionGroupId;
       if (thistaxjcrule.jurisdictionGroupIdInEntityType) thistaxjcrule.jurisdictionGroupId = String(thistaxjcrule.jurisdictionGroupIdInEntityType);
       
       if (thistaxjcrule.calculationRuleIdInEntityType) thistaxjcrule.calculationRuleId = String(thistaxjcrule.calculationRuleIdInEntityType);
       if (thistaxjcrule.calculationRuleId) thistaxjcrule.calculationRuleIdInEntityType = thistaxjcrule.calculationRuleId;
       
       if (thistaxjcrule.fulfillmentCenterIdInEntityType) thistaxjcrule.fulfillmentCenterId = String(thistaxjcrule.fulfillmentCenterIdInEntityType);
       if (thistaxjcrule.fulfillmentCenterId) thistaxjcrule.fulfillmentCenterIdInEntityType = thistaxjcrule.fulfillmentCenterId;
       
       if (thistaxjcrule.precedenceInEntityType) thistaxjcrule.precedence = String(thistaxjcrule.precedenceInEntityType);
       if (thistaxjcrule.precedence) thistaxjcrule.precedenceInEntityType = thistaxjcrule.precedence;
    }
    
    var taxes = parent.get("TaxInfoBean1");
    var jurst = taxes.jurst;
    
    for(var i=0; i < size(jurst); i++)
    {
        var thisjurst = elementAt(i,jurst);
        if (thisjurst.jurisdictionIdInEntityType) thisjurst.jurisdictionId = String(thisjurst.jurisdictionIdInEntityType);
        if (thisjurst.jurisdictionId) thisjurst.jurisdictionIdInEntityType = thisjurst.jurisdictionId;
        
        if (thisjurst.markForDeleteInEntityType) thisjurst.markForDelete = String(thisjurst.markForDeleteInEntityType);
        if (thisjurst.markForDelete) thisjurst.markForDeleteInEntityType = thisjurst.markForDelete;
        
        if (thisjurst.subclassInEntityType) thisjurst.subclass = String(thisjurst.subclassInEntityType);
        if (thisjurst.subclass) thisjurst.subclassInEntityType = thisjurst.subclass;
        
        if (thisjurst.storeEntityIdInEntityType) thisjurst.storeEntityId = String(thisjurst.storeEntityIdInEntityType);
        if (thisjurst.storeEntityId) thisjurst.storeEntityIdInEntityType = thisjurst.storeEntityId;
    }
    
    
    var jurstgroup = taxes.jurstgroup;
    for(var i=0; i < size(jurstgroup); i++)
    {
        var thisjurstgroup = elementAt(i,jurstgroup);
        if (thisjurstgroup.storeentIdInEntityType) thisjurstgroup.storeentId = String(thisjurstgroup.storeentIdInEntityType);
        if (thisjurstgroup.storeentId) thisjurstgroup.storeentIdInEntityType = thisjurstgroup.storeentId;
        
        if (thisjurstgroup.markForDeleteInEntityType) thisjurstgroup.markForDelete = String(thisjurstgroup.markForDeleteInEntityType);
        if (thisjurstgroup.markForDelete) thisjurstgroup.markForDeleteInEntityType = thisjurstgroup.markForDelete;
        
        if (thisjurstgroup.subclassInEntityType) thisjurstgroup.subclass = String(thisjurstgroup.subclassInEntityType);
        if (thisjurstgroup.subclass) thisjurstgroup.subclassInEntityType = thisjurstgroup.subclass;
        
        if (thisjurstgroup.jurisdictionGroupIdInEntityType) thisjurstgroup.jurisdictionGroupId = String(thisjurstgroup.jurisdictionGroupIdInEntityType);
        if (thisjurstgroup.jurisdictionGroupId) thisjurstgroup.jurisdictionGroupIdInEntityType = thisjurstgroup.jurisdictionGroupId;
        
    }    
    
    var jurstgprel = taxes.jurstgprel;
    for(var i=0; i < size(jurstgprel); i++)
    {
        var thisjurstgprel = elementAt(i,jurstgprel);
        if (thisjurstgprel.jurisdictionIdInEntityType) thisjurstgprel.jurisdictionId = String(thisjurstgprel.jurisdictionIdInEntityType);
        if (thisjurstgprel.jurisdictionId) thisjurstgprel.jurisdictionIdInEntityType = thisjurstgprel.jurisdictionId;
        
        if (thisjurstgprel.subclassInEntityType) thisjurstgprel.subclass = String(thisjurstgprel.subclassInEntityType);
        if (thisjurstgprel.subclassIn) thisjurstgprel.subclassInEntityType = thisjurstgprel.subclass;
        
        if (thisjurstgprel.jurisdictionGroupIdInEntityType) thisjurstgprel.jurisdictionGroupId = String(thisjurstgprel.jurisdictionGroupIdInEntityType);
        if (thisjurstgprel.jurisdictionGroupId) thisjurstgprel.jurisdictionGroupIdInEntityType = thisjurstgprel.jurisdictionGroupId;
    }   
    
    var taxcgry = taxes.taxcgry;    
    for(var i=0; i < size(taxcgry); i++)
    {
        var thistaxcgry = elementAt(i,taxcgry);
        if (thistaxcgry.field2InEntityType) thistaxcgry.field2 = String(thistaxcgry.field2InEntityType);
        if (thistaxcgry.field2) thistaxcgry.field2InEntityType = thistaxcgry.field2;
        
        if (thistaxcgry.categoryIdInEntityType) thistaxcgry.categoryId = String(thistaxcgry.categoryIdInEntityType);
        if (thistaxcgry.categoryId) thistaxcgry.categoryIdInEntityType = thistaxcgry.categoryId;
        
        if (thistaxcgry.markForDeleteInEntityType) thistaxcgry.markForDelete = String(thistaxcgry.markForDeleteInEntityType);
        if (thistaxcgry.markForDelete) thistaxcgry.markForDeleteInEntityType = thistaxcgry.markForDelete;
        
        if (thistaxcgry.displayUsageInEntityType) thistaxcgry.displayUsage = String(thistaxcgry.displayUsageInEntityType);
        if (thistaxcgry.displayUsage) thistaxcgry.displayUsageInEntityType = thistaxcgry.displayUsage;
        
        if (thistaxcgry.storeEntityIdInEntityType) thistaxcgry.storeEntityId = String(thistaxcgry.storeEntityIdInEntityType);
        if (thistaxcgry.storeEntityId) thistaxcgry.storeEntityIdInEntityType = thistaxcgry.storeEntity;
        
        if (thistaxcgry.field1InEntityType) thistaxcgry.field2 = String(thistaxcgry.field1InEntityType);
        if (thistaxcgry.field1) thistaxcgry.field1InEntityType = thistaxcgry.field1;
        
        if (thistaxcgry.typeIdInEntityType) thistaxcgry.typeId = String(thistaxcgry.typeIdInEntityType);
        if (thistaxcgry.typeId) thistaxcgry.typeIdInEntityType = thistaxcgry.typeId;
        
        if (thistaxcgry.calculationSequenceInEntityType) thistaxcgry.calculationSequence = String(thistaxcgry.calculationSequenceInEntityType);
        if (thistaxcgry.calculationSequence) thistaxcgry.calculationSequenceInEntityType = thistaxcgry.calculationSequence;
        
        if (thistaxcgry.displaySequenceInEntityType) thistaxcgry.displaySequence = String(thistaxcgry.displaySequenceInEntityType);
        if (thistaxcgry.displaySequence) thistaxcgry.displaySequenceInEntityType = thistaxcgry.displaySequence;
    }
    
    var taxcgryds = taxes.taxcgryds;
    for(var i=0; i < size(taxcgryds); i++)
    {
        var thistaxcgryds = elementAt(i,taxcgryds);
        if (thistaxcgryds.taxCategoryIdInEntityType) thistaxcgryds.taxCategoryId = String(thistaxcgryds.taxCategoryIdInEntityType);
        if (thistaxcgryds.taxCategoryId) thistaxcgryds.taxCategoryIdInEntityType = thistaxcgryds.taxCategoryId;
        
        if (thistaxcgryds.languageIdInEntityType) thistaxcgryds.languageId = String(thistaxcgryds.languageIdInEntityType);
        if (thistaxcgryds.languageId) thistaxcgryds.languageIdInEntityType = thistaxcgryds.languageId;
    }
    
    var calcode = taxes.calcode;
    for(var i=0; i < size(calcode); i++)
    {
        var thiscalcode = elementAt(i,calcode);
        if (thiscalcode.precedenceInEntityType) thiscalcode.precedence = String(thiscalcode.precedenceInEntityType);
        if (thiscalcode.precedence) thiscalcode.precedenceInEntityType = thiscalcode.precedence;
        
        if (thiscalcode.calculationUsageIdInEntityType) thiscalcode.calculationUsageId = String(thiscalcode.calculationUsageIdInEntityType);
        if (thiscalcode.calculationUsageId) thiscalcode.calculationUsageIdInEntityType = thiscalcode.calculationUsageId;
        
        if (thiscalcode.sequenceInEntityType) thiscalcode.sequence = String(thiscalcode.sequenceInEntityType);
        if (thiscalcode.sequence) thiscalcode.sequenceInEntityType = thiscalcode.sequence;
        
        if (thiscalcode.publishedInEntityType) thiscalcode.published = String(thiscalcode.publishedInEntityType);
        if (thiscalcode.published) thiscalcode.publishedInEntityType = thiscalcode.published;
        
        if (thiscalcode.calculationMethodIdInEntityType) thiscalcode.calculationMethodId = String(thiscalcode.calculationMethodIdInEntityType);
        if (thiscalcode.calculationMethodId) thiscalcode.calculationMethodIdInEntityType = thiscalcode.calculationMethodId;
        
        if (thiscalcode.endDateInEntityType) thiscalcode.endDate = String(thiscalcode.endDateInEntityType);
        if (thiscalcode.endDate) thiscalcode.endDateInEntityType = thiscalcode.endDate;
        
        if (thiscalcode.combinationInEntityType) thiscalcode.combination = String(thiscalcode.combinationInEntityType);
        if (thiscalcode.combination) thiscalcode.combinationInEntityType = thiscalcode.combination;
        
        if (thiscalcode.groupByInEntityType) thiscalcode.groupBy = String(thiscalcode.groupByInEntityType);
        if (thiscalcode.groupBy) thiscalcode.groupByInEntityType = thiscalcode.groupBy;
        
        if (thiscalcode.taxCodeClassIdInEntityType) thiscalcode.taxCodeClassId = String(thiscalcode.taxCodeClassIdInEntityType);
        if (thiscalcode.taxCodeClassId) thiscalcode.taxCodeClassIdInEntityType = thiscalcode.taxCodeClassId;        
        
        if (thiscalcode.startDateInEntityType) thiscalcode.startDate = String(thiscalcode.startDateInEntityType);
        if (thiscalcode.startDate) thiscalcode.startDateInEntityType = thiscalcode.startDate;                
        
        if (thiscalcode.storeEntityIdInEntityType) thiscalcode.storeEntityId = String(thiscalcode.storeEntityIdInEntityType);
        if (thiscalcode.storeEntityId) thiscalcode.storeEntityIdInEntityType = thiscalcode.storeEntityId;                 

        if (thiscalcode.flagsInEntityType) thiscalcode.flags = String(thiscalcode.flagsInEntityType);
        if (thiscalcode.flags) thiscalcode.flagsInEntityType = thiscalcode.flags;                 
        
        if (thiscalcode.calculationCodeApplyMethodIdInEntityType) thiscalcode.calculationCodeApplyMethodId = String(thiscalcode.calculationCodeApplyMethodIdInEntityType);
        if (thiscalcode.calculationCodeApplyMethodId) thiscalcode.calculationCodeApplyMethodIdInEntityType = thiscalcode.calculationCodeApplyMethodId;                 
        
        if (thiscalcode.calculationCodeQualifyMethodIdInEntityType) thiscalcode.calculationCodeQualifyMethodId = String(thiscalcode.calculationCodeQualifyMethodIdInEntityType);
        if (thiscalcode.calculationCodeQualifyMethodId) thiscalcode.calculationCodeQualifyMethodIdInEntityType = thiscalcode.calculationCodeQualifyMethodId; 
        
        if (thiscalcode.displayLevelInEntityType) thiscalcode.displayLevel = String(thiscalcode.displayLevelInEntityType);
        if (thiscalcode.displayLevel) thiscalcode.displayLevelInEntityType = thiscalcode.displayLevel;                 
        
        if (thiscalcode.lastUpdateInEntityType) thiscalcode.lastUpdate = String(thiscalcode.lastUpdateInEntityType);
        if (thiscalcode.lastUpdate) thiscalcode.lastUpdateInEntityType = thiscalcode.lastUpdate;                 
        
        if (thiscalcode.calculationCodeIdInEntityType) thiscalcode.calculationCodeId = String(thiscalcode.calculationCodeIdInEntityType);
        if (thiscalcode.calculationCodeId) thiscalcode.calculationCodeIdInEntityType = thiscalcode.calculationCodeId; 

    }   
    
    var calrule = taxes.calrule;
    for(var i=0; i < size(calrule); i++)
    {
        var thiscalrule = elementAt(i,calrule);
        if (thiscalrule.sequenceInEntityType) thiscalrule.sequence = String(thiscalrule.sequenceInEntityType);
        if (thiscalrule.sequence) thiscalrule.sequenceInEntityType = thiscalrule.sequence;

        if (thiscalrule.taxCategoryIdInEntityType) thiscalrule.taxCategoryId = String(thiscalrule.taxCategoryIdInEntityType);
        if (thiscalrule.taxCategoryId) thiscalrule.taxCategoryIdInEntityType = thiscalrule.taxCategoryId;

        if (thiscalrule.calculationMethodIdInEntityType) thiscalrule.calculationMethodId = String(thiscalrule.calculationMethodIdInEntityType);
        if (thiscalrule.calculationMethodId) thiscalrule.calculationMethodIdInEntityType = thiscalrule.calculationMethodId;
        
        if (thiscalrule.endDateInEntityType) thiscalrule.endDate = String(thiscalrule.endDateInEntityType);
        if (thiscalrule.endDate) thiscalrule.endDateInEntityType = thiscalrule.endDate;
        
        if (thiscalrule.endDateInEntityType) thiscalrule.endDate = String(thiscalrule.endDateInEntityType);
        if (thiscalrule.endDate) thiscalrule.endDateInEntityType = thiscalrule.endDate;        
        
        if (thiscalrule.calculationRuleIdInEntityType) thiscalrule.calculationRuleId = String(thiscalrule.calculationRuleIdInEntityType);
        if (thiscalrule.calculationRuleId) thiscalrule.calculationRuleIdInEntityType = thiscalrule.calculationRuleId;        

        if (thiscalrule.combinationInEntityType) thiscalrule.combination = String(thiscalrule.combinationInEntityType);
        if (thiscalrule.combination) thiscalrule.combinationInEntityType = thiscalrule.combination;        
        
        if (thiscalrule.identifierInEntityType) thiscalrule.identifier = String(thiscalrule.identifierInEntityType);
        if (thiscalrule.identifier) thiscalrule.identifierInEntityType = thiscalrule.identifier;        
        
        if (thiscalrule.flagsInEntityType) thiscalrule.flags = String(thiscalrule.flagsInEntityType);
        if (thiscalrule.flags) thiscalrule.flagsInEntityType = thiscalrule.flags;        
        
        if (thiscalrule.calculationRuleQualifyMethodIdInEntityType) thiscalrule.calculationRuleQualifyMethodId = String(thiscalrule.calculationRuleQualifyMethodIdInEntityType);
        if (thiscalrule.calculationRuleQualifyMethodId) thiscalrule.calculationRuleQualifyMethodIdInEntityType = thiscalrule.calculationRuleQualifyMethodId;        
        
        if (thiscalrule.field1InEntityType) thiscalrule.field1 = String(thiscalrule.field1InEntityType);
        if (thiscalrule.field1) thiscalrule.field1InEntityType = thiscalrule.field1;
        
        if (thiscalrule.calculationCodeIdInEntityType) thiscalrule.calculationCodeId = String(thiscalrule.calculationCodeIdInEntityType);
        if (thiscalrule.calculationCodeId) thiscalrule.calculationCodeIdInEntityType = thiscalrule.calculationCodeId;                        
     }
     
     var calscale = taxes.calscale;
     for(var i=0; i < size(calscale); i++)
     {
        var thiscalscale = elementAt(i,calscale);
        if (thiscalscale.calculationUsageIdInEntityType) thiscalscale.calculationUsageId = String(thiscalscale.calculationUsageIdInEntityType);
        if (thiscalscale.calculationUsageId) thiscalscale.calculationUsageIdInEntityType = thiscalscale.calculationUsageId;
        
        if (thiscalscale.calculationMethodIdInEntityType) thiscalscale.calculationMethodId = String(thiscalscale.calculationMethodIdInEntityType);
        if (thiscalscale.calculationMethodId) thiscalscale.calculationMethodIdInEntityType = thiscalscale.calculationMethodId;
        
        if (thiscalscale.calculationScaleIdInEntityType) thiscalscale.calculationScaleId = String(thiscalscale.calculationScaleIdInEntityType);
        if (thiscalscale.calculationScaleId) thiscalscale.calculationScaleIdInEntityType = thiscalscale.calculationScaleId;
        
        if (thiscalscale.storeEntityIdInEntityType) thiscalscale.storeEntityId = String(thiscalscale.storeEntityIdInEntityType);
        if (thiscalscale.storeEntityId) thiscalscale.storeEntityIdInEntityType = thiscalscale.storeEntityId;
     }     
     
     var crulescale = taxes.crulescale;     
     for(var i=0; i < size(crulescale); i++)
     {
        var thiscrulescale = elementAt(i,crulescale);
        if (thiscrulescale.calculationScaleIdInEntityType) thiscrulescale.calculationScaleId = String(thiscrulescale.calculationScaleIdInEntityType);
        if (thiscrulescale.calculationScaleId) thiscrulescale.calculationScaleIdInEntityType = thiscrulescale.calculationScale;
        
        if (thiscrulescale.calculationRuleIdInEntityType) thiscrulescale.calculationRuleId = String(thiscrulescale.calculationRuleIdInEntityType);
        if (thiscrulescale.calculationRuleId) thiscrulescale.calculationRuleIdInEntityType = thiscrulescale.calculationRuleId;
     }
     
     var calrange = taxes.calrange;
     for(var i=0; i < size(calrange); i++)
     {
        var thiscalrange = elementAt(i,calrange);
        if (thiscalrange.cumulativeInEntityType) thiscalrange.cumulative = String(thiscalrange.cumulativeInEntityType);
        if (thiscalrange.cumulative) thiscalrange.cumulativeInEntityType = thiscalrange.cumulative;
        
        if (thiscalrange.field2InEntityType) thiscalrange.field2 = String(thiscalrange.field2InEntityType);
        if (thiscalrange.field2) thiscalrange.field2InEntityType = thiscalrange.field2;
        
        if (thiscalrange.field1InEntityType) thiscalrange.field1 = String(thiscalrange.field1InEntityType);
        if (thiscalrange.field1) thiscalrange.field1InEntityType = thiscalrange.field1;
        
        if (thiscalrange.calculationMethodIdInEntityType) thiscalrange.calculationMethodId = String(thiscalrange.calculationMethodIdInEntityType);
        if (thiscalrange.calculationMethodId) thiscalrange.calculationMethodIdInEntityType = thiscalrange.calculationMethodId;

        if (thiscalrange.markForDeleteInEntityType) thiscalrange.markForDelete = String(thiscalrange.markForDeleteInEntityType);
        if (thiscalrange.markForDelete) thiscalrange.markForDeleteInEntityType = thiscalrange.markForDelete;
        
        if (thiscalrange.rangeStartInEntityType) thiscalrange.rangeStart = String(thiscalrange.rangeStartInEntityType);
        if (thiscalrange.rangeStart) thiscalrange.rangeStartInEntityType = thiscalrange.rangeStart;

        if (thiscalrange.calculationScaleIdInEntityType) thiscalrange.calculationScaleId = String(thiscalrange.calculationScaleIdInEntityType);
        if (thiscalrange.calculationScaleId) thiscalrange.calculationScaleIdInEntityType = thiscalrange.calculationScaleId;
        
        if (thiscalrange.calculationRangeIdInEntityType) thiscalrange.calculationRangeId = String(thiscalrange.calculationRangeIdInEntityType);
        if (thiscalrange.calculationRangeId) thiscalrange.calculationRangeIdInEntityType = thiscalrange.calculationRangeId;
     }     
     
     var calrlookup = taxes.calrlookup;
     for(var i=0; i < size(calrlookup); i++)
     {
        var thiscalrlookup = elementAt(i,calrlookup);
        if (thiscalrlookup.calculationRangeLookupResultIdInEntityType) thiscalrlookup.calculationRangeLookupResultId = String(thiscalrlookup.calculationRangeLookupResultIdInEntityType);
        if (thiscalrlookup.calculationRangeLookupResultId) thiscalrlookup.calculationRangeLookupResultIdInEntityType = thiscalrlookup.calculationRangeLookupResultId;
        
        if (thiscalrlookup.calculationRangeIdInEntityType) thiscalrlookup.calculationRangeId = String(thiscalrlookup.calculationRangeIdInEntityType);
        if (thiscalrlookup.calculationRangeId) thiscalrlookup.calculationRangeIdInEntityType = thiscalrlookup.calculationRangeId;
        
        if (thiscalrlookup.valueInEntityType) thiscalrlookup.value = String(thiscalrlookup.valueInEntityType);
        if (thiscalrlookup.value) thiscalrlookup.valueInEntityType = thiscalrlookup.value;
        
     }
     
//    var storecatalogtaxbean = parent.get("StoreCatalogTaxBean1");
//    var catencalcd = storecatalogtaxbean.catencalcd;
//    for (var i=0; i < size(catencalcd); i++)
//     {
//        var thiscatencalcd = elementAt(i,catencalcd);
//        if (thiscatencalcd.contractIdInEntityType) thiscatencalcd.contractId = String(thiscatencalcd.contractIdInEntityType);
//        if (thiscatencalcd.contractId) thiscatencalcd.contractIdInEntityType = thiscatencalcd.contractId;
//        
//        if (thiscatencalcd.storeIdInEntityType) thiscatencalcd.storeId = String(thiscatencalcd.storeIdInEntityType);
//        if (thiscatencalcd.storeId) thiscatencalcd.storeIdInEntityType = thiscatencalcd.storeId;
//        
//        if (thiscatencalcd.catalogEntryCalculationCodeIdInEntityType) thiscatencalcd.catalogEntryCalculationCodeId = String(thiscatencalcd.catalogEntryCalculationCodeIdInEntityType);
//        if (thiscatencalcd.catalogEntryCalculationCodeId) thiscatencalcd.catalogEntryCalculationCodeIdInEntityType = thiscatencalcd.catalogEntryCalculationCodeId;
//        
//        if (thiscatencalcd.catalogEntryIdInEntityType) thiscatencalcd.catalogEntryId = String(thiscatencalcd.catalogEntryIdInEntityType);
//        if (thiscatencalcd.catalogEntryId) thiscatencalcd.catalogEntryIdInEntityType = thiscatencalcd.catalogEntryId;
//        
//        if (thiscatencalcd.calculationCodeIdInEntityType) thiscatencalcd.calculationCodeId = String(thiscatencalcd.calculationCodeIdInEntityType);
//        if (thiscatencalcd.calculationCodeId) thiscatencalcd.calculationCodeIdInEntityType = thiscatencalcd.calculationCodeId;
//     }
  }