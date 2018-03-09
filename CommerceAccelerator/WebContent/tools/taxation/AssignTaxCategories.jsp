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
                com.ibm.commerce.tools.xml.*,
                com.ibm.commerce.datatype.*,
                com.ibm.commerce.beans.*"
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
.selectWidth {width: 200px;}
</STYLE>
</HEAD>
<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT> 
<SCRIPT SRC="/wcs/javascript/tools/common/Vector.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/common/FieldEntryUtil.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/common/ConvertToXML.js"></SCRIPT>
<SCRIPT>
  var showDetails   = false;
   //var updateCalrule = new Vector();
   
  	var	remCalRule3 = parent.get("remCalRule3");  
	if(remCalRule3 == null){
		remCalRule3 = new Vector();
	} 

  <%@include file="TaxUtil.jsp" %>
  
  <%--
    - Populate the codes table with any previously defined tax
    - categories.
    --%>
   function initializeState()
  {
    var taxes = parent.get("TaxInfoBean1");
    var calcode = taxes.calcode;
    var taxcgry = taxes.taxcgry;
 
    if (size(calcode) == 0) {
       alertDialog("<%=taxNLS.getJSProperty("NeedTaxCode")%>");
    }
    else if (size(calcode) == 1 && elementAt(0,calcode).code == "Default") {
       alertDialog("<%=taxNLS.getJSProperty("NeedTaxCode")%>");
    }
    else if (size(taxcgry) == 0) {
       alertDialog("<%=taxNLS.getJSProperty("NeedTaxCategory")%>");
    } else {
       var entryName = tableEntryName(0, 0);
       populateTable();
//       TaxCodesTable.document.f1[entryName].focus();
    }
    parent.setContentFrameLoaded(true);
  }

  <%--
    - Reload the tax table with the latest data
    --%>
  function reloadTable(details)
  {
    if(validateEntries())
    {
      showDetails   = details;
      categoryNames = null;
      TaxCodesTable.location.reload();
      return(true);
    }
    else
      return(false);
  }

  
 
  <%--
    - Returns a unique name for a table entry
    -
    - row    - The row number.
    - column - The column number.
    --%>
  function tableEntryName( row, column )
  {
    return "Category" + column + "Code" + row;
  }

  <%--
    - Returns the row and column of a table entry
    --%>
  function tableIndex( entryName )
  {
    var index      = new Object();
    var codeIndex = entryName.indexOf("Code");

    index.column = entryName.substring(8, codeIndex);
    index.row    = entryName.substr(codeIndex+4);
    return(index);
  }

  <%--
    - Returns a list of tax codes to be used to label each row of the table
    --%>
  function getRowArray()
  {
     var codeNames = new Array();
     var taxes = parent.get("TaxInfoBean1");
     var codes = taxes.calcode;
 
     for( var i=0; i < size(codes); i++ )
     {
       var code = elementAt(i,codes);
       var definedCode = code.code;
       if (definedCode == "Default") continue;
       codeNames[codeNames.length] = definedCode;
     }
    return codeNames;
  }

  <%--
    - Returns a list of categories to be used to label each column of the table
    --%>
  function getColumnArray()
  {
    var categoryNames = new Array();
    var taxes = parent.get("TaxInfoBean1");
    var categories = taxes.taxcgry;

    for(var i = 0; i < size(categories); i++) {
      var category = elementAt(i,categories);
      categoryNames[categoryNames.length] = category.name;
    }
    return categoryNames;
  }

  function getHeading()
  {
  	return "<%=taxNLS.getJSProperty("taxCodes")%>";
  }
  
  <%--
    - 
    --%>
  function isCgryVsCodeRelated(category, code)
  {
    var taxes = parent.get("TaxInfoBean1");
    var calrule = taxes.calrule;
    var taxFulfillmentInfoBean = parent.get("TaxFulfillmentInfoBean1");
    var taxjcrule = taxFulfillmentInfoBean.taxjcrule;
    var ffmcntr = parent.get("ffmcntr");
    if (calrule == null) return false;

    for (var i=0; i < size(calrule); i++) {
       var temp = elementAt(i,calrule);
       //consider fulfillment center here, if there is no taxjcrule with this rule_id for current fulfillment center
       //return false
       if (temp.calculationCodeId == code.calculationCodeId && temp.taxCategoryId == category.categoryId) {
          for(var j = 0; j < size(taxjcrule); j++) {
          	var tempTaxjcrule = elementAt(j,taxjcrule);
			if(tempTaxjcrule.calculationRuleId == temp.calculationRuleId && tempTaxjcrule.fulfillmentCenterId == ffmcntr){
		      	return true;	
			}
	    
          }
          
       }
    }
    return false;
  }

  <%--
    - Populate the codes table with the current tax categories.
    --%>
  function populateTable()
  {
    var taxes = parent.get("TaxInfoBean1");
    var codes = taxes.calcode;
    var categories = taxes.taxcgry;
    
    // Loop through the table rows and set their values
    var flag=false;
    var row = 0;
    for( var i=0; i < size(codes);  i++ )
    {
      var code = elementAt(i,codes);
      //if (code.code == "Default") {flag=true;continue;}
      if (code.code == "Default") continue;

      for( var j=0; j < size(categories); j++ ) {
         var category = elementAt(j,categories);
         //if (flag) var fieldName = tableEntryName(i-1, j);
         var fieldName = tableEntryName(row, j);
         //alert(fieldName+":"+code.code);
         if (code.calculationUsageId != category.typeId){
            TaxCodesTable.document.f1[fieldName].disabled = true;
         }
         else{
            TaxCodesTable.document.f1[fieldName].checked = isCgryVsCodeRelated(category,code);
         }
      }
      row++;
    }
  }

  <%--
    - Remove the relationship between this code and category, if one exists.
    --%>
  function removeRelation(calcode_id, taxcgry_id)
  {

    var taxes = parent.get("TaxInfoBean1");
    var calrule = taxes.calrule;
    var calcode = taxes.calcode;
//    var default_id;
      
//      for (var x=0; x < calcode.size(); x++) {
//         var thiscalcode = calcode.elementAt(x);
//         if(thiscalcode.code == "Default") {
//            default_id = thiscalcode.calculationCodeId;
//            break;
//         }
//      }


	
    for (var i=size(calrule)-1; i >= 0; i--) {
       var temp = elementAt(i,calrule);
	   var calculatinRuleId = temp.calculationRuleId;
	   var taxFulfillmentInfoBean = parent.get("TaxFulfillmentInfoBean1");
	   var taxjcrule = taxFulfillmentInfoBean.taxjcrule;
       var ffmcntr = parent.get("ffmcntr");
	   
       if (temp.calculationCodeId == calcode_id && temp.taxCategoryId == taxcgry_id) {
//          if (temp.field2 == "delete") 
//          {
			//if this calrule is for current fulfillment center, remove it
			for(var j = 0; j < size(taxjcrule); j++) {
				var tempTaxjcrule = elementAt(j,taxjcrule);
				if(tempTaxjcrule.calculationRuleId == temp.calculationRuleId && tempTaxjcrule.fulfillmentCenterId == ffmcntr){
					removeElementAt(i,calrule);
					<%--Remove the calrulation associations as per calculation rule id--%>
                      removeCalruleAssociations(temp.calculationRuleId);
                      <%--Remove the records from updateCalrlookup, updateTaxJcRule,updateCalrule as per calculation rule id if existed--%>
          			  removeCalruleRefUpdates(temp.calculationRuleId);
					if (calculatinRuleId.substring(0,1) != "@"){
						//don't use remCalRule3.addElement(calculatinRuleId) here, 
						//the error "Can't execute code from a freed script" will happen if you switch to other panel and go back to this one
						addElement(calculatinRuleId,remCalRule3);
					}
					break;
	    
				}
			}


            
//          }
//          else 
//          {
//            var flag = temp.calculationCodeId;
//            temp.calculationCodeId = default_id;
//            if(flag != default_id){
//            	updateCalrule.addElement(temp);
//            }
//          }  
          //return;
       }
    }

  }

  <%--
    - create a relationship between this code and category, if one doesn't exist.
    --%>
  function createRelation(calcode_id, sequence, taxcgry_id, taxtype)
  {
    var taxes = parent.get("TaxInfoBean1");
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
    var taxFulfillmentInfoBean = parent.get("TaxFulfillmentInfoBean1");
    var taxjcrule = taxFulfillmentInfoBean.taxjcrule;
    var ffmcntr = parent.get("ffmcntr");
//    var default_id;
    var check;
      
//      for (var x=0; x < calcode.size(); x++) {
//         var thiscalcode = calcode.elementAt(x);
//         if(thiscalcode.code == "Default") {
//            default_id = thiscalcode.calculationCodeId;
//            break;
//         }
//      }

    <%-- make sure this relationship doesn't already exist --%>
    for (var i=0; i < size(calrule); i++) {
       var temp = elementAt(i,calrule);

       if (temp.calculationCodeId == calcode_id && temp.taxCategoryId == taxcgry_id) {
			//if there is one taxjcrule in current fulfillment center with this calrule, return
			for(var j = 0; j < size(taxjcrule); j++) {
				
          		var tempTaxjcrule = elementAt(j,taxjcrule);
				if(tempTaxjcrule.calculationRuleId == temp.calculationRuleId  && tempTaxjcrule.fulfillmentCenterId == ffmcntr){
			      	return;	
				}
	    
          	}

       }
    }

    <%-- create this relationship in a predefined calrule, if possible --%>
    
    for (var n=0; n < size(jurst); n ++) {
       var thisjurst = elementAt(n,jurst);
       var jurstgroup_id = getJurstgroupIdFromJurstId(thisjurst.jurisdictionId);
       check = false;
       
//       for (var i=0; i < calrule.size(); i++) {
//          var temp = calrule.elementAt(i);
//
//          if (temp.calculationCodeId == default_id && temp.taxCategoryId == taxcgry_id && temp.sequence == sequence) {
//             for (var p=0; p < taxjcrule.size(); p++) {
//                var temptaxjcrule = taxjcrule.elementAt(p);
//                if (temptaxjcrule.jurisdictionGroupId == jurstgroup_id && temptaxjcrule.calculationRuleId == temp.calculationRuleId) {
//                  temp.calculationCodeId = calcode_id;
//                  updateCalrule.addElement(temp);
//                  check = true;
//                  break;
//                }
//             }
//             break;
//          }
//       }

    
       if (!check) {
        var tempcalrlookup = getCalrlookup(thisjurst.jurisdictionId, taxcgry_id);
		
       	if (taxtype == "sales"){
       		var newCalrule = new parent.calrule();
       	}
       	else if (taxtype == "shipping"){
       		var newCalrule = new parent.shippingcalrule();
       	}
       	newCalrule.calculationCodeId = calcode_id;
       	newCalrule.taxCategoryId = taxcgry_id;
       	var cid = getCalruleuid();
       	newCalrule.calculationRuleId = "@calrule_id_" + cid;
       	newCalrule.identifier = cid;
       	addElement(newCalrule,calrule);
       	//
       	var precedence = getPrecedence(jurstgroup_id);
	//
       	var newTaxjcrule = new parent.taxjcrule(precedence);          
       	newTaxjcrule.calculationRuleId = newCalrule.calculationRuleId;
       	newTaxjcrule.jurisdictionGroupId = jurstgroup_id;
       	newTaxjcrule.fulfillmentCenterId = ffmcntr;
       	addElement(newTaxjcrule,taxjcrule);
          
          <%-- create a new calrlookup for this calrule --%>
  	    var newCalrlookup = new parent.calrlookup();
        newCalrlookup.calculationRangeLookupResultId = "@calrlookup_id_" + getCalrlookupuid();
        newCalrlookup.calculationRangeId = "@calrange_id_" + getCalrangeuid();
        
        if(tempcalrlookup == null) {
        	newCalrlookup.value = 0;
        } else {
        	newCalrlookup.value = tempcalrlookup.value;
        }

          <%-- create a new calrange for this calrule --%>
       	  if (taxtype == "sales"){
          	var newCalrange = new parent.calrange();
          }
          else if (taxtype == "shipping"){
          	var newCalrange = new parent.shippingcalrange();
          }
          newCalrange.calculationRangeId = newCalrlookup.calculationRangeId;
          var scaleid = getCalscaleuid();
          newCalrange.calculationScaleId = "@calscale_id_" + scaleid;

          <%-- create a new calscale for this calrule --%>
          if (taxtype == "sales"){
          	var newCalscale = new parent.calscale();
          }
          else if (taxtype == "shipping"){
          	newCalscale = new parent.shippingcalscale();
          }
          newCalscale.calculationScaleId = newCalrange.calculationScaleId;
          newCalscale.code = scaleid;
          newCalscale.storeEntityId = storeid;

          <%-- create a new crulescale --%>
          var newCrulescale = new parent.crulescale();
          newCrulescale.calculationRuleId = newCalrule.calculationRuleId;
          newCrulescale.calculationScaleId = newCalscale.calculationScaleId;

          <%-- save the new entries --%>
          addElement(newCalrlookup,calrlookup);
          addElement(newCalrange,calrange);
          addElement(newCalscale,calscale);
          addElement(newCrulescale,crulescale);
          
       }
    }
  }


  function savePanelData()
  {
    var taxes = parent.get("TaxInfoBean1");
    var codes = taxes.calcode;
    var categories = taxes.taxcgry;
//    var calcodtxex = new Vector();
    var taxtype = null;
    
    var flag=false;
    var row = 0;
    // Loop through the check boxs and get their values
    for( var i=0; i < size(codes); i++ ) {
      var code = elementAt(i,codes);
      //if(code.code == "Default") {flag=true;continue;}
      if(code.code == "Default") continue;
      if (code.calculationUsageId == "-3") taxtype = "sales";
      else if (code.calculationUsageId == "-4") taxtype = "shipping";
      else alertDialog("No correct tax type defined in sar!");
      	
      for( var j=0; j < size(categories); j++ ) {
         var category = elementAt(j,categories);
         var fieldName = tableEntryName(row, j);
         if (TaxCodesTable.document.f1[fieldName].checked == true) {
         	//alert("createRelation");
            createRelation(code.calculationCodeId, code.sequence, category.categoryId, taxtype);
         }
         else if (TaxCodesTable.document.f1[fieldName].checked == false || TaxCodesTable.document.f1[fieldName].disabled == false){
			//alert("removeRelation");
            removeRelation(code.calculationCodeId, category.categoryId);
         }
      }
      row++;
    }

    //parent.put("calcodtxex", calcodtxex);
    //parent.put("updateCalrule", updateCalrule);
 	
    parent.put("remCalRule3", remCalRule3);

    return true;
  }
  
</SCRIPT>
  <FRAMESET ROWS="100, *" BORDER=0>
      <FRAME NAME="Description"
               SRC="TaxAssignCategoriesTopView"
               TITLE="<%=taxNLS.getJSProperty("taxAssignTaxCategoriesTab")%>"
               FRAMEBORDER="0"
               BORDER="0"
               NORESIZE
               SCROLLING="no"
               MARGINWIDTH=15
               MARGINHEIGHT=15>
      <FRAME NAME="TaxCodesTable"
               SRC="/wcs/tools/taxation/checkBoxTable.html?CTS=<%=System.currentTimeMillis()%>"
               TITLE="<%=taxNLS.getJSProperty("taxAssignTaxCategoriesTab")%>"
               FRAMEBORDER="0"
               BORDER="0"
               NORESIZE
               SCROLLING="auto"
               MARGINWIDTH=15
               MARGINHEIGHT=10>
  </FRAMESET>
</HTML>

