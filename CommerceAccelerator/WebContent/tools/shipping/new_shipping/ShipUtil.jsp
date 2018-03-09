<%
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2000, 2002
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
%>  
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
 
  function getJurstuid()
  {
     var jurstuid = parent.get("jurstuid");
     
     if (jurstuid == null) {
     
        var shipping = parent.get("ShippingInfoBean");
        var jurst = shipping.jurst;
     
        if (jurst.size() == 0) {
           jurstuid = 100;
           parent.put("jurstuid", jurstuid);
           return jurstuid;
        } else {
           var idArray = new Array();
           for (var i=0; i < jurst.size(); i++) {
              var thisjurst = jurst.elementAt(i);
              if (thisjurst.jurst_id.substring(0,7) == "@sjurst") idArray[idArray.length] = parseFloat(thisjurst.jurst_id.substring(11));
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
     
        var shipping = parent.get("ShippingInfoBean");
        var jurstgroup = shipping.jurstgroup;
        
        if (jurstgroup.size() == 0) {
           jurstgroupuid = 100;
           parent.put("jurstgroupuid", jurstgroupuid);
           return jurstgroupuid;
        } else {
           var idArray = new Array();
           for (var i=0; i < jurstgroup.size(); i++) {
              var thisjurstgroup = jurstgroup.elementAt(i);
              if (thisjurstgroup.jurstgroup_id.substring(0,7) == "@sjurst" ) idArray[idArray.length] = parseFloat(thisjurstgroup.jurstgroup_id.substring(16));
           }
           if (idArray.length !=0) {
              idArray.sort(compareValues);
              jurstgroupuid = idArray[idArray.length -1] + 1;
           } else jurstgroupuid = 100;
           
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
     
        var shipping = parent.get("ShippingInfoBean");
        var calcode = shipping.calcode;
     
        if (calcode.size() == 0) {
           calcodeuid = 100;
           parent.put("calcodeuid", calcodeuid);
           return calcodeuid;
        } else {
           var idArray = new Array();
           for (var i=0; i < calcode.size(); i++) {
              var thiscalcode = calcode.elementAt(i);
              if (thiscalcode.calcode_id.substring(0,7) == "@scalco" ) idArray[idArray.length] = parseFloat(thiscalcode.calcode_id.substring(13));
           }
           if(idArray.length != 0) {
              idArray.sort(compareValues);
              calcodeuid = idArray[idArray.length -1] + 1;
           } else calcodeuid = 100;
           
           parent.put("calcodeuid", calcodeuid);
           return calcodeuid;
        }
     } else {
        calcodeuid++;
        parent.put("calcodeuid", calcodeuid);
        return calcodeuid;
     }
     
  }


  function getCalrangeuid()
  {
     var calrangeuid = parent.get("calrangeuid");
     
     if (calrangeuid == null) {
     
        var shipping = parent.get("ShippingInfoBean");
        var calrange = shipping.calrange;
        
        if (calrange.size() == 0) {
           calrangeuid = 1000;
           parent.put("calrangeuid", calrangeuid);
           return calrangeuid;
        } else {
           var idArray = new Array();
           for (var i=0; i < calrange.size(); i++) {
              var thiscalrange = calrange.elementAt(i);
              if (thiscalrange.calrange_id.substring(0,7) == "@scalra" ) idArray[idArray.length] = parseFloat(thiscalrange.calrange_id.substring(14));
           }
           if (idArray.length != 0) {
              idArray.sort(compareValues);
              calrangeuid = idArray[idArray.length -1] + 1;
           } else calrangeuid = 1000;
           
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
     
        var shipping = parent.get("ShippingInfoBean");
        var calrlookup = shipping.calrlookup;
     
        if (calrlookup.size() == 0) {
           calrlookupuid = 1000;
           parent.put("calrlookupuid", calrlookupuid);
           return calrlookupuid;
        } else {
           var idArray = new Array();
           for (var i=0; i < calrlookup.size(); i++) {
              var thiscalrlookup = calrlookup.elementAt(i);
              if (thiscalrlookup.calrlookup_id.substring(0,7) == "@scalrl" )idArray[idArray.length] = parseFloat(thiscalrlookup.calrlookup_id.substring(16));
           }
           if (idArray.length != 0) {
              idArray.sort(compareValues);
              calrlookupuid = idArray[idArray.length -1] + 1;
           } else calrlookupuid = 1000;
           
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
     
        var shipping = parent.get("ShippingInfoBean");
        var calrule = shipping.calrule;
     
        if (calrule.size() == 0) {
           calruleuid = 1000;
           parent.put("calruleuid", calruleuid);
			  return calruleuid;
        } else {
           var idArray = new Array();
           for (var i=0; i < calrule.size(); i++) {						
              var thiscalrule = calrule.elementAt(i);
				  if (thiscalrule.calrule_id.substring(0,7) == "@scalru" )idArray[idArray.length] = parseFloat(thiscalrule.calrule_id.substring(13));
           }
           if (idArray.length != 0) {
              idArray.sort(compareValues);
              calruleuid = idArray[idArray.length -1] + 1;

           } else calruleuid = 1000;
           
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
     
        var shipping = parent.get("ShippingInfoBean");
        var calscale = shipping.calscale;
     
        if (calscale.size() == 0) {
           calscaleuid = 1000;
           parent.put("calscaleuid", calscaleuid);
           return calscaleuid;
        } else {
           var idArray = new Array();
           for (var i=0; i < calscale.size(); i++) {
              var thiscalscale = calscale.elementAt(i);
              if (thiscalscale.calscale_id.substring(0,7) == "@scalsc" )idArray[idArray.length] = parseFloat(thiscalscale.calscale_id.substring(14));
           }
           if (idArray.length != 0) {
              idArray.sort(compareValues);
              calscaleuid = idArray[idArray.length -1] + 1;
           } else calscaleuid = 1000;
           
           parent.put("calscaleuid", calscaleuid);
           return calscaleuid;
        }
     } else {
        calscaleuid++;
        parent.put("calscaleuid", calscaleuid);
        return calscaleuid;
     }
     
  }
  
  
  function getShipmodeuid()
  {
     var shipmodeuid = parent.get("shipmodeuid");
     
     if (shipmodeuid == null) {
     
        var shipping = parent.get("ShippingInfoBean");
        var shipmode = shipping.shipmode;
     
        if (shipmode.size() == 0) {
           shipmodeuid = 100;
           parent.put("shipmodeuid", shipmodeuid);
           return shipmodeuid;
        } else {
           var idArray = new Array();
           for (var i=0; i < shipmode.size(); i++) {
              var thisshipmode = shipmode.elementAt(i);
              if (thisshipmode.shipmode_id.substring(0,7) == "@sshipm") idArray[idArray.length] = parseFloat(thisshipmode.shipmode_id.substring(14));
           }
           if (idArray.length != 0) {
             idArray.sort(compareValues);
             shipmodeuid = idArray[idArray.length -1] + 1;
           } else shipmodeuid = 100;
           
           parent.put("shipmodeuid", shipmodeuid);
           return shipmodeuid;
        }
     } else {
        shipmodeuid++;
        parent.put("shipmodeuid", shipmodeuid);
        return shipmodeuid;
     }
     
  }

  function getShpjcruleuid()
  {
     var shpjcruleuid = parent.get("shpjcruleuid");
     
     if (shpjcruleuid == null) {
     
        var shipping = parent.get("ShippingFulfillmentInfoBean");
        var shpjcrule = shipping.shpjcrule;
     
        if (shpjcrule.size() == 0) {
           shpjcruleuid = 1000;
           parent.put("shpjcruleuid", shpjcruleuid);
           return shpjcruleuid;
        } else {
           var idArray = new Array();
           for (var i=0; i < shpjcrule.size(); i++) {
              var thisshpjcrule = shpjcrule.elementAt(i);
              if (thisshpjcrule.shpjcrule_id.substring(0,7) == "@sshpjc") idArray[idArray.length] = parseFloat(thisshpjcrule.shpjcrule_id.substring(15));
           }
           if (idArray.length != 0) {
              idArray.sort(compareValues);
              shpjcruleuid = idArray[idArray.length -1] + 1;
           } else shpjcruleuid = 1000;
           
           parent.put("shpjcruleuid", shpjcruleuid);
           return shpjcruleuid;
        }
     } else {
        shpjcruleuid++;
        parent.put("shpjcruleuid", shpjcruleuid);
        return shpjcruleuid;
     }
     
  }

  
  function getShparrangeuid()
  {
     var shparrangeuid = parent.get("shparrangeuid");
     
     if (shparrangeuid == null) {
     
        var shippingFulfillmentInfoBean = parent.get("ShippingFulfillmentInfoBean");
        var shparrange = shippingFulfillmentInfoBean.shparrange;
     
        if (shparrange.size() == 0) {
           shparrangeuid = 1;
           parent.put("shparrangeuid", shparrangeuid);
           return shparrangeuid;
        } else {
           var idArray = new Array();
           for (var i=0; i < shparrange.size(); i++) {
              var thisshparrange = shparrange.elementAt(i);
              if (thisshparrange.shparrange_id.substring(0,7) == "@sshpar") idArray[idArray.length] = parseFloat(thisshparrange.shparrange_id.substring(16));
           }
           if (idArray.length != 0) {
              idArray.sort(compareValues);
              shparrangeuid = idArray[idArray.length -1] + 1;
           } else shparrangeuid = 100;
           
           parent.put("shparrangeuid", shparrangeuid);
           return shparrangeuid;
        }
     } else {
        shparrangeuid++;
        parent.put("shparrangeuid", shparrangeuid);
        return shparrangeuid;
     }
     
  }


//function trim(word) {
//   var i=0;
//   if (word == null)
//   	return "";
//   var j=word.length-1;
//   while(word.charAt(i) == " ") i++;
//   while(word.charAt(j) == " ") j--;
//   if (i > j) {
//		return word.substring(i,i);
//	} else {
//		return word.substring(i,j+1);
//	}
//}



  <%--
    -  Returns a new calrule object with all of the dependant table rows
    - created and populated with the default values;
    --%>
  function createNewCalrule()
  {
      <%-- create a new calrule --%>
      var newCalrule = new parent.calrule();
      var cid = getCalruleuid();
      newCalrule.identifier = cid;
      newCalrule.calrule_id = "@scalrule_id_" + cid;
      newCalrule.calcode_id = -1;
      newCalrule.calmethod_id="-27";
      newCalrule.calmethod_id_qfy="-26";
      
      
      createNewScale(newCalrule.calrule_id);
      
      return newCalrule;
  }


  function createNewScale(calrule_id)
  { 
     var shipping = parent.get("ShippingInfoBean");
     var avCurrList = parent.get("AvailCurrList");
     var storeid = parent.get("storeid");
     var calrlookup = shipping.calrlookup;
     var calrange = shipping.calrange;
     var calscale = shipping.calscale;
     var crulescale = shipping.crulescale;

     <%-- create a new calscale for this calrule --%>
     for (var i=0; i < avCurrList.length; i++) {
         
        <%-- create a new calrange for this calrule --%>   
        var newCalrange = new parent.calrange();
        newCalrange.calrange_id = "@scalrange_id_" + getCalrangeuid();
        var cid = getCalscaleuid();
        newCalrange.calscale_id = "@scalscale_id_" + cid;
        newCalrange.calmethod_id = "-34";
        
         
        <%-- create a new calscale for this calrule --%>   
        var newCalscale = new parent.calscale();
        newCalscale.code = cid;
        newCalscale.calscale_id = newCalrange.calscale_id;
        newCalscale.calusage_id = "-2"; 
        newCalscale.setccurr = avCurrList[i].setccurr;
        newCalscale.calmethod_id="-28";
        newCalscale.storeent_id = storeid;

        <%-- create a new crulescale --%>
        var newCrulescale = new parent.crulescale();
        newCrulescale.calrule_id = calrule_id;
        newCrulescale.calscale_id = newCalscale.calscale_id;
        
	<%-- create a new calrlookup for this calrule --%>
        var newCalrlookup = new parent.calrlookup();
        newCalrlookup.calrlookup_id = "@scalrlookup_id_" + getCalrlookupuid();
        newCalrlookup.calrange_id = newCalrange.calrange_id;
        newCalrlookup.setccurr = avCurrList[i].setccurr;
        newCalrlookup.value = '0.00000';
         
        <%-- save the new entries --%>
        calrange.addElement(newCalrange);
        calscale.addElement(newCalscale);
        crulescale.addElement(newCrulescale);
        calrlookup.addElement(newCalrlookup);
     }
       
  }
  
  function createNewWeightScale(calrule_id, range)
  { 
     var shipping = parent.get("ShippingInfoBean");
     var avCurrList = parent.get("AvailCurrList");
     var storeid = parent.get("storeid");
     var calrlookup = shipping.calrlookup;
     var calrange = shipping.calrange;
     var calscale = shipping.calscale;
     var crulescale = shipping.crulescale;

     <%-- create a new calscale for this calrule --%>
     for (var i=0; i < avCurrList.length; i++) {
         
        <%-- create a new calrange for this calrule --%>   
        var newCalrange = new parent.calrange();
        newCalrange.calrange_id = "@scalrange_id_" + getCalrangeuid();
        var cid = getCalscaleuid();
        newCalrange.calscale_id = "@scalscale_id_" + cid;
        newCalrange.rangestart = range;
        newCalrange.calmethod_id = "-33";
         
        <%-- create a new calscale for this calrule --%>   
        var newCalscale = new parent.calscale();
        newCalscale.calscale_id = newCalrange.calscale_id;
        newCalscale.code = cid;
        newCalscale.calusage_id = "-2"; 
        newCalscale.setccurr = avCurrList[i].setccurr;
	newCalscale.calmethod_id="-29";
        newCalscale.storeent_id = storeid;
        newCalscale.qtyunit_id = "LBR";
      
        <%-- create a new crulescale --%>
        var newCrulescale = new parent.crulescale();
        newCrulescale.calrule_id = calrule_id;
        newCrulescale.calscale_id = newCalscale.calscale_id;
        
	<%-- create a new calrlookup for this calrule --%>
        var newCalrlookup = new parent.calrlookup();
        newCalrlookup.calrlookup_id = "@scalrlookup_id_" + getCalrlookupuid();
        newCalrlookup.calrange_id = newCalrange.calrange_id;
        newCalrlookup.setccurr = avCurrList[i].setccurr;
        newCalrlookup.value = "0.0000";
         
        <%-- save the new entries --%>
        calrange.addElement(newCalrange);
        calscale.addElement(newCalscale);
        crulescale.addElement(newCrulescale);
        calrlookup.addElement(newCalrlookup);
     }
       
  }
  
  function createNewWeightRange(calscale_id, range)
  { 
     var shipping = parent.get("ShippingInfoBean");
     var avCurrList = parent.get("AvailCurrList");
     var storeid = parent.get("storeid");
     var calrlookup = shipping.calrlookup;
     var calrange = shipping.calrange;
     var calscale = shipping.calscale;
     
         
     <%-- create a new calrange for this calrule --%>   
     var newCalrange = new parent.calrange();
     newCalrange.calrange_id = "@scalrange_id_" + getCalrangeuid();
     newCalrange.calscale_id = calscale_id
     newCalrange.rangestart = range;
     newCalrange.calmethod_id = "-33";
        
     <%-- create a new calrlookup for this calrule --%>
     for (var i=0; i < calscale.size(); i++) {
        var thiscalscale = calscale.elementAt(i);
        if (thiscalscale.calscale_id == calscale_id) var setccurr = thiscalscale.setccurr;
     }
     
     var newCalrlookup = new parent.calrlookup();
     newCalrlookup.calrlookup_id = "@scalrlookup_id_" + getCalrlookupuid();
     newCalrlookup.calrange_id = newCalrange.calrange_id;
     newCalrlookup.setccurr = setccurr;
     newCalrlookup.value = "0.0000";
         
     <%-- save the new entries --%>
     calrange.addElement(newCalrange);
     calrlookup.addElement(newCalrlookup);
     
       
  }
  
  function getJurstgroupIdFromJurstId(jurst_id)
  {
     var shipping = parent.get("ShippingInfoBean");
     var jurstgprel = shipping.jurstgprel;
     var jurstgroup_id = -1;

     for (var i=0; i < jurstgprel.size(); i++) {
        var temp = jurstgprel.elementAt(i);
        if (temp.jurst_id == jurst_id && temp.subclass=="1") {
           jurstgroup_id = temp.jurstgroup_id;
           break;
        }
     }

     if (jurstgroup_id == -1) {
        alert("Rates.jsp::getJurstgroupIdFromJurstId() - jurst_id= " + jurst_id + " does not belong to a group.");
        return;
     }
     
     return jurstgroup_id;
  }


  function removeCalruleAssociations(calrule_id)
  {
    var shipping = parent.get("ShippingInfoBean");
    var shippingFulfillmentInfoBean = parent.get("ShippingFulfillmentInfoBean");
    var shpjcrule = shippingFulfillmentInfoBean.shpjcrule;
    var crulescale = shipping.crulescale;
    var calscale = shipping.calscale;
    var calrange = shipping.calrange;
    var calrlookup = shipping.calrlookup;
    var calrule = shipping.calrule;
    var calcode = shipping.calcode;
    var shipmode = shipping.shipmode;
    var jurst = shipping.jurst;

    for (var x=0; x < calrule.size(); x++) {
       var thiscalrule = calrule.elementAt(x);
       if (thiscalrule.calrule_id == calrule_id) {
          for (var y=0; y < calcode.size(); y++) {
             var thiscalcode = calcode.elementAt(y);
             if (jurst.size() == 0 || shipmode.size() == 0) {
                if (thiscalcode.calcode_id == thiscalrule.calcode_id && thiscalcode.code == "WeightRanges") calcode.removeElementAt(y);
             }
          }
       }
    }
       
    <%-- remove this calrule from shpjcrule --%>
    for (var i=shpjcrule.size()-1; i >= 0 ; i--) {
       var temp = shpjcrule.elementAt(i);
       if (temp.calrule_id == calrule_id) {
          shpjcrule.removeElementAt(i);
          
       }
    }

    <%-- remove this calrule from crulescale (this cascades) --%>
    for (var i=crulescale.size()-1; i >= 0; i--) {
       var thisCrulescale = crulescale.elementAt(i);

       if (thisCrulescale.calrule_id == calrule_id) {

           var calscale_id = thisCrulescale.calscale_id;
           
           <%-- remove this calscale_id from the calscale table --%>
           for (var j=calscale.size() -1; j >= 0; j--) {
              var tmp = calscale.elementAt(j);
              if (tmp.calscale_id == calscale_id) {
                 calscale.removeElementAt(j);
              }
           }

           <%-- remove this calscale_id from the calrange table (this cascades to calrlookup) --%>
           for (var j=calrange.size()-1; j >= 0; j--) {
              var tmp = calrange.elementAt(j);
              if (tmp.calscale_id == calscale_id) {
                 var calrange_id = tmp.calrange_id;

                 <%-- remove this calrange_id from the calrlookup table --%>
                 for (var k=calrlookup.size()-1; k >= 0; k--) {
                    var tmp2 = calrlookup.elementAt(k);
      
                    if (tmp2.calrange_id == calrange_id) {
                       calrlookup.removeElementAt(k);
                    }
                 }
                 calrange.removeElementAt(j);
              }
           }

           crulescale.removeElementAt(i);
       }
    }
  }
  
  function removeCalrangeAssociations(calscale_id, range)
  {
    var shipping = parent.get("ShippingInfoBean");
    var shippingFulfillmentInfoBean = parent.get("ShippingFulfillmentInfoBean");
    var shpjcrule = shippingFulfillmentInfoBean.shpjcrule;
    var crulescale = shipping.crulescale;
    var calscale = shipping.calscale;
    var calrange = shipping.calrange;
    var calrlookup = shipping.calrlookup;

    
    <%-- remove this calscale_id from the calrange table (this cascades to calrlookup) --%>
    for (var k=calrange.size()-1; k >= 0 ; k--) {
       var tmp = calrange.elementAt(k);
       if (tmp.calscale_id == calscale_id && tmp.rangestart == range) {
          var calrange_id = tmp.calrange_id;

          <%-- remove this calrange_id from the calrlookup table --%>
          for (var l=calrlookup.size()-1; l >= 0 ; l--) {
             var tmp2 = calrlookup.elementAt(l);
      
             if (tmp2.calrange_id == calrange_id) {
                calrlookup.removeElementAt(l);
             }
          }
       calrange.removeElementAt(k);
       }
    }
    

  }

function getArrayofRangesFromCalcode(calcode_id) {
      
     var shipping = parent.get("ShippingInfoBean");
     var calrule = shipping.calrule;
     var crulescale = shipping.crulescale;
     var calrange = shipping.calrange;
     var raindex = 0;
     var rangeArray = new Array();
        
     for (var j=0; j < calrule.size(); j++) {
        thiscalrule = calrule.elementAt(j);
        if (thiscalrule.calcode_id == calcode_id) {
           for (var k=0; k < crulescale.size(); k++) {
              thiscrulescale = crulescale.elementAt(k);
              if (thiscrulescale.calrule_id == thiscalrule.calrule_id) {
                 for (var x=0; x < calrange.size(); x++) {
                    thiscalrange = calrange.elementAt(x);
                    if (thiscalrange.calscale_id == thiscrulescale.calscale_id) {
                       check = false;
                       if (rangeArray.length == 0) {
                          rangeArray[raindex] = parseFloat(thiscalrange.rangestart);
                          raindex++;
                       }
                       for (var y=0; y < rangeArray.length; y++) {
                          if (rangeArray[y] == thiscalrange.rangestart) check = true;
                       }
                       if (!check) {
                          rangeArray[raindex] = parseFloat(thiscalrange.rangestart);
                          raindex++;
                       }
                          
                    }
                 }
              }
           }
        }
     }
     return rangeArray;
  }
  
  function getCalscaleIdFromCalruleId(calrule_id, setccurr)
  {
     var shipping = parent.get("ShippingInfoBean");
     var crulescale = shipping.crulescale;
     var calscale = shipping.calscale;
	  var calrule = shipping.calrule;
	  var storeid = parent.get("storeid");

     for (var i=0; i < crulescale.size(); i++) {
        var temp = crulescale.elementAt(i);
        if (temp.calrule_id == calrule_id) {
           for (var j=0; j < calscale.size(); j++){
              var temp2 = calscale.elementAt(j);
              if (temp2.calscale_id == temp.calscale_id && temp2.setccurr == setccurr) return temp.calscale_id;
           }
        }
     }

     var newCalscale = new parent.calscale();
     var cid = getCalscaleuid();
     newCalscale.calscale_id = "@scalscale_id_" + cid;
     newCalscale.code = cid;
     newCalscale.calusage_id = "-2"; 
     newCalscale.setccurr = setccurr;
     newCalscale.calmethod_id="-28";
     newCalscale.storeent_id = storeid;
      
     <%-- create a new crulescale --%>
     var newCrulescale = new parent.crulescale();
     newCrulescale.calrule_id = calrule_id;
     newCrulescale.calscale_id = newCalscale.calscale_id;

	  calscale.addElement(newCalscale);
	  crulescale.addElement(newCrulescale);

	  return newCalscale.calscale_id;
     alert("Rates.jsp::getCalscaleIdFromCalruleId() - calrule_id=" + calrule_id + " not found in crulescale.");
  }
  
    
  <%--
    - Note that we do not support tax ranges. Return the first calrange_id whose
    - calscale_id matches.
    --%>
  function getCalrangeIdFromCalscaleId(calscale_id)
  {
     var shipping = parent.get("ShippingInfoBean");
     var calrange = shipping.calrange;

     for (var i=0; i < calrange.size(); i++) {
        var temp = calrange.elementAt(i);
        if (temp.calscale_id == calscale_id) {
           return temp.calrange_id;
        }
     }

	  <%-- create a new calrange for this calrule --%>   
     var newCalrange = new parent.calrange();
     newCalrange.calrange_id = "@scalrange_id_" + getCalrangeuid();
     newCalrange.calscale_id = calscale_id
     newCalrange.rangestart = 0.0000;
     newCalrange.calmethod_id = "-34";
     
     calrange.addElement(newCalrange);
     return newCalrange.calrange_id;

     alert("Rates.jsp::getCalrangeIdFromCalscaleId() - calscale_id=" + calscale_id + " not found in calrange.");
  }
  
  <%--
    - Note that we do not support tax ranges. Return the first calrange_id whose
    - calscale_id matches.
    --%>
  function getCalrangeFromCalscaleId(calscale_id)
  {
     var shipping = parent.get("ShippingInfoBean");
     var calrange = shipping.calrange;

     for (var i=0; i < calrange.size(); i++) {
        var temp = calrange.elementAt(i);
        if (temp.calscale_id == calscale_id) {
           return temp;
        }
     }

     alert("Rates.jsp::getCalrangeIdFromCalscaleId() - calscale_id=" + calscale_id + " not found in calrange.");
  }
  
  function getCalrule(calrule_id)
  {
     var shipping = parent.get("ShippingInfoBean");
     var calrule = shipping.calrule;

     for (var i=0; i < calrule.size(); i++) {
        var temp = calrule.elementAt(i);
        if (temp.calrule_id == calrule_id) {
           return temp;
        }
     }

     alert("Rates.jsp::getCalrule() - calrule_id=" + calrule_id + " not found in calrule.");
  }
  
  function calmethodForPerOrder()
  {
     var shipping = parent.get("ShippingInfoBean");
     var calcode = shipping.calcode;
     var calrule = shipping.calrule;
     var calscale = shipping.calscale;
     var crulescale = shipping.crulescale;
     var calrange = shipping.calrange;
     var calscale_id = '';
     var calcode_id = '';

     for (var i=0; i < calrange.size(); i++) {
        var thiscalrange = calrange.elementAt(i);
        if (thiscalrange.calmethod_id == "-33") {
           calscale_id = thiscalrange.calscale_id;
        }
     }

     
     for (var j=0; j < crulescale.size(); j++) {
        var thiscrulescale = crulescale.elementAt(j);
        if (thiscrulescale.calscale_id == calscale_id) {
           var calrule_id = thiscrulescale.calrule_id;
           for (var k=0; k < calrule.size(); k++) {
              var thiscalrule = calrule.elementAt(k);
              if (thiscalrule.calrule_id == calrule_id) {
                  calcode_id = thiscalrule.calcode_id;
              }
           }
        }
     }
     
     for (var i=0; i < calrule.size(); i++) {
        var tmpcalrule = calrule.elementAt(i);
        if (tmpcalrule.calcode_id == calcode_id) {
           for (var j=0; j < crulescale.size(); j++) {
              var tmpcrulescale = crulescale.elementAt(j);
              if (tmpcrulescale.calrule_id == tmpcalrule.calrule_id) {
                 for (var k=0; k < calrange.size(); k++) {
                    var tmpcalrange = calrange.elementAt(k);
                    if (tmpcalrange.calscale_id == tmpcrulescale.calscale_id) {
                       tmpcalrange.calmethod_id = "-33";
                    }
                 }
              }
           }
        }
     }
     
  }
  
function dumpCalrange()
{
     var shipping = parent.get("ShippingInfoBean"); 
     var calrange = shipping.calrange;
     alert("==================dumping calrange====================");
     alert("total calrange length ="+calrange.size());
        
     for (var i=0; i < calrange.size(); i++) {
        var thiscalrange = calrange.elementAt(i);
	alert("calrange.calrange_id=" + thiscalrange.calrange_id);
	alert("calrange.calmethod_id=" + thiscalrange.calmethod_id);
	alert("calrange.calscale_id="+thiscalrange.calscale_id);           
     }
     alert("==============end dumping calrange====================");
}     

  function getPrecedence(ajurstgroup_id)
  {
    var shipping = parent.get("ShippingFulfillmentInfoBean");
    var shpjcrule = shipping.shpjcrule;
    var thisprecedence;
    
    for (j=0; j < shpjcrule.size(); j++) {
       var thisshpjcrule = shpjcrule.elementAt(j);
       if (thisshpjcrule.jurstgroup_id == ajurstgroup_id) {
          thisprecedence=thisshpjcrule.precedence;
          return(thisprecedence);
       }
    }
  }
  