<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2006, 2016 All Rights Reserved.

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
                com.ibm.commerce.tools.xml.*,
                com.ibm.commerce.datatype.*,
                com.ibm.commerce.beans.*,
                com.ibm.commerce.fulfillment.objects.StoreEntityCalculationUsageAccessBean" 
%> 
<%@page import="com.ibm.commerce.tools.resourcebundle.*"
%>  
<%
  CommandContext cmdContext  = (CommandContext)request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
  Locale locale = cmdContext.getLocale();
  ResourceBundleProperties taxNLS = (ResourceBundleProperties)ResourceDirectory.lookup("taxation.taxationNLS", locale);
%>
<%@include file="../common/common.jsp" %>
<HTML>
<HEAD>
<LINK REL=stylesheet HREF="<%= UIUtil.getCSSFile(locale) %>" TYPE="text/css">
<STYLE TYPE='text/css'>
.selectWidth {width: 250px;}
</STYLE>
</HEAD>
<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/common/Vector.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/common/FieldEntryUtil.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/common/ConvertToXML.js"></SCRIPT>
<SCRIPT>
<%@include file="TaxUtil.jsp" %>
<% 
	String strDefaultShippingTaxCode = "";
    //only if there is STENCALUSG existing for specific calusage and store, default tax code is changeable.
	//String isDefaultTaxCodeChangeable = "false";
	
	StoreEntityCalculationUsageAccessBean abStoreEntityCalUsage = new StoreEntityCalculationUsageAccessBean();
	abStoreEntityCalUsage.setInitKey_storeEntityId(cmdContext.getStoreId().toString());
	abStoreEntityCalUsage.setInitKey_calculationUsageId("-4");
	
	try{
		strDefaultShippingTaxCode = abStoreEntityCalUsage.getCalculationCodeId();
		//isDefaultTaxCodeChangeable = "true";
	}catch(javax.persistence.NoResultException e){
		//try store group level config
		abStoreEntityCalUsage.setInitKey_storeEntityId(cmdContext.getStore().getStoreGroupId());
		abStoreEntityCalUsage.setInitKey_calculationUsageId("-3");
		strDefaultShippingTaxCode = abStoreEntityCalUsage.getCalculationCodeId();
		//isDefaultTaxCodeChangeable = "false";
		
	}catch(Exception e) {
		strDefaultShippingTaxCode = "";
	}
	
	if(strDefaultShippingTaxCode == null) {
		strDefaultShippingTaxCode = "";
	} 
%>
  <%--
    - store defaults variables used in option list.
    --%>
    var orgtext = null;
    var defcalcodeid = null; //default position in the option list
	var	remCalCode2 = parent.get("remCalCode2");
	if(remCalCode2 == null){
		remCalCode2 = new Vector();
	} 
                              
  <%--
    - Populate the list box with the previously defined tax codes.
    --%>
  function initializeState()
  {
    var taxes = parent.get("TaxInfoBean1");
    var calcodes = taxes.calcode;
    //var storecatalogtaxbean = parent.get("StoreCatalogTaxBean1");
    //var catencalcd = storecatalogtaxbean.catencalcd;
    var numOfTaxCodes = size(calcodes);
    var shippingtax = -4;
    var j = 0; 
    //var catenindex = -1;

//    if (catencalcd.size()< 2){
//    	alertDialog("<%=taxNLS.getJSProperty("noStoreDefault")%>");
//    }
//    if (calcodes.size()==0) {
//    	alertDialog("<%=taxNLS.getJSProperty("noShippingTaxCode")%>");
//    }	
//    else 

    for(var i=0; i < numOfTaxCodes; i++) {
      var thiscalcode = elementAt(i,calcodes);
      var taxtype = thiscalcode.calculationUsageId;
      if (thiscalcode.code == "Default") continue;
      if (taxtype != shippingtax) continue;
      var calcode_id = thiscalcode.calculationCodeId;
      var displayName = thiscalcode.code;
      var displayValue = calcode_id;
      
//    alertDialog("displayName="+displayName);
//    alertDialog("displayValue="+displayValue);
      
//      if (catenindex == -1) {
//      	catenindex = findCatenElementindex(catencalcd, calcode_id);
//      	if (catenindex != -1){
//      	 	defcalcodeid = calcode_id;
//       		orgtext = displayName;
//      		displayName = addDefaultText(displayName);
//      	}
//      }   
      
      if(calcode_id == "<%=strDefaultShippingTaxCode%>") {
      	defcalcodeid = calcode_id;
      	orgtext = displayName;
      	displayName = addDefaultText(displayName);
      }
      
                             
      document.f1.definedCodes.options[j] = new Option(displayName, displayValue, false, false);
      document.f1.definedCodes.options[j].selected = false;
      j++;
    }
    
//    if (catenindex == -1 && numOfTaxCodes != 0){
//        alertDialog("<%=taxNLS.getJSProperty("AddDefaultShippingTaxCode")%>");
//         orgtext = document.f1.definedCodes.options[0].text
//         document.f1.definedCodes.options[0].text = addDefaultText(orgtext) 
//         catencalcd.elementAt(1).calculationCodeId = document.f1.definedCodes.options[0].value; 
//    }
//  dumpGlobalVarialbes();

	//var defaultButtonEnable = "<%//=isDefaultTaxCodeChangeable%>";
    //document.f1.defaultButton.disabled = defaultButtonEnable;
    
    document.f1.newTaxCode.focus();
    parent.setContentFrameLoaded(true);
  }

  <%--
    - append "defaut" text.
    --%>
  function addDefaultText(text)
  {
  	return (text + " <%= taxNLS.getJSProperty("addDefaultcodeString") %>");
  }  

  <%--
    - find the option list index which has "default" in the text.
    --%>
  function findDefaultindex(text){
	pattern = new RegExp("<%= taxNLS.getJSProperty("addDefaultcodeString") %>");
	matchingpos = text.search(pattern);	
	if (matchingpos != -1) {
		return true;
	} 
	else {
		return false;
	}
  }

  <%--
    - find the index which has the same calcode_id in catencalcd.
    --%>
//  function findCatenElementindex(catencalcd, codeid){
//      var elementindex = -1;
//      for (var j=0; j < catencalcd.size(); j++){
//    	var thiscatencalcd = catencalcd.elementAt(j);
//    	var catencdid = thiscatencalcd.calculationCodeId;
//    	if (catencdid == codeid){
//    		elementindex = j;
//    		return elementindex;
//    	}    	
//      }
//      return elementindex;
//  }

  <%--
    - find the index which has the same calcode_id in calcodes.
    --%>
  function findCalcdElementindex(calcodes, codeid){
      var elementindex = -1;
      for (var j=0; j < size(calcodes); j++){
    	var thiscalcode = elementAt(j,calcodes);
    	var calcdid = thiscalcode.calculationCodeId;
    	if (calcdid == codeid){
    		elementindex = j;
    		return elementindex;
    	}    	
      }
      return elementindex;
  }

  <%--
    - Create a new tax code. This is called when the user clicks 'Add'
    --%>
  function addCode()
  {
    if (document.f1.newTaxCode.value == "" || trim(document.f1.newTaxCode.value) == "") {
       alertDialog("<%=taxNLS.getJSProperty("SelectCodeToAdd")%>");
       return;
    }

    var taxes = parent.get("TaxInfoBean1");
    var calcodes = taxes.calcode;
    var jurst = taxes.jurst;
    var taxcgry = taxes.taxcgry;
    var calrule = taxes.calrule;
    var taxFulfillmentInfoBean = parent.get("TaxFulfillmentInfoBean1");
    var taxjcrule = taxFulfillmentInfoBean.taxjcrule;
    var storeid = parent.get("storeid");
    var ffmcntr = parent.get("ffmcntr");

    for(var i=0; i < calcodes.container.length; i++) {
      var thiscode = elementAt(i,calcodes);
      if (thiscode.code.toUpperCase() == trim(document.f1.newTaxCode.value.toUpperCase())) {
         alertDialog("<%=taxNLS.getJSProperty("CodeAlreadyExists")%>");
         return;
      }
      else if (orgtext != null){
      	if (orgtext.toUpperCase() == trim(document.f1.newTaxCode.value.toUpperCase())) {
         	alertDialog("<%=taxNLS.getJSProperty("CodeAlreadyExists")%>");
         	return;
       	}
      }      
    }
    
    <%-- Make sure the user entered a category name of valid length--%>
    if ( !isValidUTF8length(document.f1.newTaxCode.value, 30)) {
       alertDialog ( "<%=taxNLS.getJSProperty("tooLong")%>" );
       return;
    } 

    <%-- add this new code to our javascript data --%>
    var newCode = new parent.shippingcalcode();
    newCode.code = trim(document.f1.newTaxCode.value);
    newCode.code = newCode.code;
    newCode.calculationCodeId = "@calcode_id_" + getCalcodeuid();
    // needed in some cases
    newCode.calculationCodeId = newCode.calculationCodeId;	
    newCode.storeEntityId = storeid;
    newCode.storeEntityId = storeid;
    newCode.sequence = getSequence();
    newCode.sequence = newCode.sequence;
    var size = calcodes.container.length;

    //alert("before size:"+calcodes.size());
    if(size == 0){
    	addElement(newCode,calcodes);
    } else {
    	insertElementAt(newCode, size-1,calcodes);
    }
    //alert("after size:"+calcodes.size());   

    <%-- update our gui --%>
    var newIndex = document.f1.definedCodes.options.length;

    document.f1.definedCodes.options[newIndex] = new Option(trim(document.f1.newTaxCode.value), newCode.calculationCodeId, false, false);
    document.f1.definedCodes.options[newIndex].selected = false;
    document.f1.newTaxCode.value = "";

    <%-- add a new taxjcrule, and all of its dependant entries, for each defined jurisdiction and tax category --%>
    for (var i=0; i < jurst.container.length; i++) {
       var thisjurst = elementAt(i,jurst);
       if (thisjurst.subclass != "2") continue;

       var jurstGroupID = getJurstgroupIdFromJurstId(thisjurst.jurisdictionId);
       
       for (var k=0; k < taxcgry.container.length; k++){
       	var thistaxcgry = elementAt(k,taxcgry);
       	var taxtype = null;
       	if (newCode.calculationUsageId == "-3") taxtype = "sales";
       	else if (newCode.calculationUsageId == "-4") taxtype = "shipping";
       	else alertDialog("No correct tax type defined in sar!");
       	var tempcalrlookup = getCalrlookup(thisjurst.jurisdictionId, thistaxcgry.categoryId);              
       	if (newCode.calculationUsageId == thistaxcgry.typeId){
       	  <%-- create the new calrule --%>
       	  //alert("insert rule for type:"+newCode.calculationUsageId);
       	         	  
       	  var newCalrule = null;
       	  if(tempcalrlookup == null) {
       	  	 newCalrule = createNewCalrule(taxtype, 0);
       	  } else {
       	  	newCalrule = createNewCalrule(taxtype, tempcalrlookup.value);
       	  }
       	   
       	  newCalrule.calculationCodeId = newCode.calculationCodeId;
       	  newCalrule.taxCategoryId = thistaxcgry.categoryId;
       	  newCalrule.sequence = newCode.sequence;
       	  addElement(newCalrule,calrule);
       	  //
       	  var precedence = getPrecedence(jurstGroupID);
	  //
       	  var newTaxjcrule = new parent.taxjcrule(precedence);
       	  newTaxjcrule.calculationRuleId = newCalrule.calculationRuleId;
		  newTaxjcrule.calculationRuleId = newTaxjcrule.calculationRuleId;
       	  newTaxjcrule.jurisdictionGroupId = jurstGroupID;
		  newTaxjcrule.jurisdictionGroupId = jurstGroupID;
       	  newTaxjcrule.fulfillmentCenterId = ffmcntr;
		  newTaxjcrule.fulfillmentCenterId = ffmcntr;
       	  newTaxjcrule.taxJCRuleId = "@taxjcrule_id_" + getTaxjcruleuid();
       	  addElement(newTaxjcrule,taxjcrule);
       	}
       }
    }
    
  }

  <%--
    - Set a default tax code. This is called when user click set default button.
    --%>
  function setDefaultShippingTaxCode()
  {
    var selectionMade = false;
    var taxes = parent.get("TaxInfoBean1");
    var calcodes = taxes.calcode;
    //var storecatalogtaxbean = parent.get("StoreCatalogTaxBean1");
    //var catencalcd = storecatalogtaxbean.catencalcd;
    var defaultindex = -1;
    //var calcode_id = -1;
    //var catenindex = -1;
        
   <%-- Find the 1st default index in the Defined Codes list --%>
    for ( var i=0; i<=document.f1.definedCodes.options.length-1; i++ ) {    
	if (findDefaultindex(document.f1.definedCodes.options[i].text) == true){
		defaultindex = i;
//		alertDialog("defaultindex found ="+i);
		break;
	}
    }        
            
    <%-- Check the selected items from the list and set default --%>
    for ( var i=0; i<=document.f1.definedCodes.options.length-1; i++ ) {
      if ( document.f1.definedCodes[i].selected == true ) {
      	var selectedindex = i;
        var selectedtext = document.f1.definedCodes.options[i].text;
        var selectedvalue = document.f1.definedCodes.options[i].value;
//        if (defaultindex != -1) {
//			calcode_id = document.f1.definedCodes.options[defaultindex].value;
//      		catenindex = findCatenElementindex(catencalcd, calcode_id);
//      	}
//		if (catenindex == -1){
//        	var temp = new Object();
//        	temp.calculationCodeId = selectedvalue;
//        	temp.catalogEntryCalculationCodeId = "-4";
//        	catencalcd.addElement(temp);
//        }   else {
//        	catencalcd.elementAt(catenindex).calculationCodeId = selectedvalue;
//        }       
        if (defaultindex!=-1 && orgtext!=null) {
        	if (selectedindex == defaultindex){
        	 	return;
        	}
        	document.f1.definedCodes.options[defaultindex].text = orgtext;
        }
       	
       	document.f1.definedCodes.options[selectedindex].text = addDefaultText(selectedtext);
       	document.f1.definedCodes.options[selectedindex].selected = true;
       	defcalcodeid = selectedvalue;
	orgtext = selectedtext;
       	selectionMade = true;
      }
    }
    
    //parent.put("StoreCatalogTaxBean1.catencalcd", catencalcd);
    parent.put("defaultShippingTaxCode", defcalcodeid);

    <%-- if nothing was selected, prompt the user to select something. --%>
    if(!selectionMade) {
      alertDialog ("<%=taxNLS.getJSProperty("SelectShippingTaxCodeToSetDefault")%>");
      return;
    }
  }  

  <%--
    - Delete the previously defined tax codes. This is called when
    - the user clicks 'Remove'
    --%>
  function removeCode()
  {
    var selectionMade = false;
    var taxes = parent.get("TaxInfoBean1");
    var calcodes = taxes.calcode;
//    var calcodedsc = taxes.calcodedsc;
    var calrule = taxes.calrule;
    //var default_id;
    var defaultindex = -1;


   <%-- Find the 1st default index in the defined codes list --%>
    for ( var i=0; i<=document.f1.definedCodes.options.length-1; i++ ) {    
	if (findDefaultindex(document.f1.definedCodes.options[i].text) == true){
		defaultindex = i;
//		alertDialog("defaultindex found ="+i);
		break;
	}
    } 
          
//    for (var x=0; x < calcodes.size(); x++) {
//       	var thiscalcode = calcodes.elementAt(x);
//        if(thiscalcode.code == "Default") {
//            default_id = thiscalcode.calculationCodeId;
//            break;
//        }
//    }        
    <%-- Remove the selected items from the list --%>
    for(var i = document.f1.definedCodes.length-1; i >= 0; i--) {
      if(document.f1.definedCodes[i].selected == true) {

        var selectedindex = i;
        var selectedvalue = document.f1.definedCodes.options[i].value;
        //do not allow to remove default tax code.
        if (selectedindex == defaultindex){
        	alertDialog("<%=taxNLS.getJSProperty("Can'tRemoveDefaultShippingTaxCode")%>");
        	return;
        }
                
	var calcode_id = document.f1.definedCodes.options[i].value;
      	var calcdindex = findCalcdElementindex(calcodes, calcode_id);
      	if (calcdindex != -1){	         
        	var removedCode = elementAt(calcdindex,calcodes);
        }
//        if (calcodedsc != null){
//	    for (var n=calcodedsc.size() -1; n >= 0; n--) {
//	       var thiscalcodedsc = calcodedsc.elementAt(n);
//	       if (thiscalcodedsc.calculationCodeId == removedCode.calculationCodeId) {
//		 calcodedsc.removeElementAt(n);
//	       }	
//	    }
//	}
        removeElementAt(calcdindex,calcodes);
          <%-- add the primary ids to the vector so that it can be deleted from the db --%>
          if (calcode_id.substring(0,1) != "@"){
             //remCalCode2.addElement(calcode_id);
             addElement(calcode_id,remCalCode2);
             
        }
          
        //if the removed calcode is set as default, clear it.  
        if(calcode_id == parent.get("defaultShippingTaxCode")) {
        	parent.put("defaultShippingTaxCode", "");
        }

        document.f1.definedCodes.options[i] = null;
        selectionMade = true;
        
        <%-- loop through all calrules and erase any references to this calcode --%>
        
                <%-- loop through all calrules and erase any references to this calcode --%>
//        for (x=0; x < calrule.size(); x++) {
//            var temp = calrule.elementAt(x);
//
//            if (temp.calculationCodeId == removedCode.calculationCodeId) {
//               temp.calculationCodeId = default_id;
//            }
//         }
        
        <%-- loop through all calrules and erase any references to this calrule, such as updateCalrule,updateCalrlookup, updateTaxjcRule --%>
        for (var x=0; x < calrule.container.length; x++) {
            var temprule = elementAt(x,calrule);

            if (temprule.calculationCodeId == removedCode.calculationCodeId) {   
              	
              	<%--Remove the calrulation associations as per calculation rule id--%>
              	removeCalruleAssociations(temprule.calculationRuleId);
              	<%--Remove the records from updateCalrlookup, updateTaxJcRule,updateCalrule as per calculation rule id if existed--%>
  			  	removeCalruleRefUpdates(temprule.calculationRuleId);
              	if (temprule.calculationRuleId.substring(0,1) == "@"){
              		removeElementAt(x,calrule);
              	}
            }
         }
      }
    }
    parent.put("remCalCode2", remCalCode2);
    <%-- If nothing was selected, prompt the user to select something. --%>
    if (!selectionMade) {
      alertDialog("<%=taxNLS.getJSProperty("SelectCodeToRemove")%>");
      return;
    }
  }

  function dumpGlobalVarialbes()
  {
    alertDialog("global variables orgtext=" + orgtext);
    alertDialog("global variables defcalcodeid=" + defcalcodeid);     
  }

</SCRIPT>
<BODY ONLOAD="initializeState()" CLASS="content">
<FORM NAME="f1" onsubmit='return false;'>
  <H1><%=taxNLS.getProperty("taxShippingTaxCodesTitle")%></H1>
  <%=taxNLS.getProperty("ShippingCodeMsg")%>
  <BR><BR>
  	<%=taxNLS.getProperty("NewShippingTaxCode")%>
			  <TABLE BORDER=0>
			    <TR>
				   <TD VALIGN=TOP>
	               			<LABEL><INPUT CLASS='selectWidth' SIZE=30 TYPE=text NAME="newTaxCode" maxlength="128" WIDTH=35></LABEL>
				   </TD>
 				   <TD >
				    <INPUT type="button" id='nbp' class="button"
						      value="   <%=taxNLS.getProperty("CodeAddButton")%>    " 
								onClick="addCode()">
				   </TD>
				 </TR>
			  </TABLE>
		  <BR><BR>
        <%=taxNLS.getProperty("DefinedShippingTaxCodes")%>
		  <TABLE>
		   <TR>
			  <TD rowspan="2">
  			  	<LABEL for="definedCodes"><SELECT NAME="definedCodes" ID="definedCodes" SIZE=5 CLASS="selectWidth"></SELECT></LABEL>
 			  </TD>
 			  <TD valign="TOP" height="21">
 			  	<INPUT type="button" name="defaultButton" id="nbp" class="button" value='<%=taxNLS.getProperty("ShippingTaxCodesDefaultButton")%> ' onclick="setDefaultShippingTaxCode()">
 			  </TD>
 		   </TR>
 		   <TR> 
			  <TD VALIGN=TOP height="47">
			    <INPUT type="button" id='nbp' class="button"
					      value="<%=taxNLS.getProperty("CodeRemoveButton")%> " 
							onClick="removeCode()">
			  </TD>
         </TR>
        </TABLE>
</FORM>
</BODY>
</HTML>


