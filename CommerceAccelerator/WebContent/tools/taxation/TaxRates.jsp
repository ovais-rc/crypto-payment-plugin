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
  Integer langId = cmdContext.getLanguageId();
  ResourceBundleProperties taxNLS = (ResourceBundleProperties)ResourceDirectory.lookup("taxation.taxationNLS", locale);
%>
<%@include file="../common/common.jsp" %>
<HTML>
<HEAD>
<LINK REL=stylesheet HREF="<%= UIUtil.getCSSFile(locale) %>" TYPE="text/css">
</HEAD>
<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/common/Vector.js"></SCRIPT>
<%@include file="../common/NumberFormat.jsp" %>
<SCRIPT>
  var updateCalrlookup = new Vector();
  <%--
    - Populate the rates table with any previously defined tax
    - category rates.
    --%>
  function initializeState()
  {
    var taxes = parent.get("TaxInfoBean1");
    var jurst = taxes.jurst;
    var taxcgry = taxes.taxcgry;
    var codes = taxes.calcode;

    if (size(jurst) == 0) {
       alertDialog("<%=taxNLS.getJSProperty("NoJurisdictionsDefined")%>");
    }
    else if (size(taxcgry) == 0) {
       alertDialog("<%=taxNLS.getJSProperty("NoCategoriesDefined")%>");
    } 
    else if (size(codes) == 0) {
    	alertDialog("<%=taxNLS.getJSProperty("NoCodesDefined")%>");
    	disableTable();
    }
    else {
       //var entryName = tableEntryName(0, 0);
       populateTable();
       //TaxRatesTable.document.f1[entryName].focus();
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
      TaxRatesTable.location.reload();
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
    return "Category" + column + "Jurisdiction" + row;
  }

  <%--
    - Returns the row and column of a table entry
    --%>
  function tableIndex( entryName )
  {
    var index      = new Object();
    var jurstIndex = entryName.indexOf("Jurisdiction");

    index.column = entryName.substring(8, jurstIndex);
    index.row    = entryName.substr(jurstIndex+12);
    return(index);
  }

  <%--
    - Returns a list of jurisdictions to be used to label each row of the table
    --%>
  function getRowArray()
  { 
     var taxes = parent.get("TaxInfoBean1");
     var jurisdictions = taxes.jurst;
     var jurstNames = new Array();
  
     for( var i=0; i < size(jurisdictions); i++ )
     {
       var jurisdiction = elementAt(i,jurisdictions);
       if (jurisdiction.subclass != "2") continue;

       var definedJurisdiction = jurisdiction.country;
       if (jurisdiction.state !=null && jurisdiction.state != "") definedJurisdiction = definedJurisdiction + ", " + jurisdiction.state;
       
       if (jurisdiction.code == "world" || jurisdiction.code == "World") definedJurisdiction = "<%=taxNLS.getJSProperty("defaultJurisdiction")%>";

       jurstNames[jurstNames.length] = definedJurisdiction;
     }
    return jurstNames;
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

  <%--
    -
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
    - Return the tax rate for the given (jurisdiction,category) pair.
    --%>
  function getCalrlookup_forSetTaxRate(jurst_id, taxcgry_id, ffmcntr)
  {
     var taxes = parent.get("TaxInfoBean1");
     var calrulebean = taxes.calrule;
     var jurstgroup_id = getJurstgroupIdFromJurstId(jurst_id);

     <%-- now find the calrule_id that has this jurstgroup_id and this taxcgry_id--%>
     var taxFulfillmentInfoBean = parent.get("TaxFulfillmentInfoBean1");
     var taxjcrule = taxFulfillmentInfoBean.taxjcrule;

     var calrlookup = new Vector();
     for (var i=0; i < size(taxjcrule); i++) {
        var temp = elementAt(i,taxjcrule);
        if (temp.jurisdictionGroupId == jurstgroup_id && temp.fulfillmentCenterId == ffmcntr) {
		   
           <%-- check if this taxjcrule.calrule_id has the right taxcgry_id in the calrule table --%>

           var calrule = getCalrule(temp.calculationRuleId);
		   
		   if(calrule == null){
		   	  continue;
		   }
		   
           if (calrule.taxCategoryId == taxcgry_id) {
              var calrule_id = temp.calculationRuleId;
              var calrlookup_id = getCalrlookupFromCalruleId(calrule_id);
              addElement(calrlookup_id,calrlookup);
           }
        }
     }

     if (calrlookup.isEmpty()) {
       //alertDialog("Rates.jsp::getCalrlookup_forSetTaxRate() - no value found for jurst_id=" + jurst_id + " and taxcgry_id=" + taxcgry_id + ".");
     }
     
     return calrlookup;

  }
  
  <%--
    - Return the tax rate for the given (jurisdiction,category) pair.
    --%>
  function getTaxRate(jurst_id, taxcgry_id, ffmcntr)
  {
     
     var calrlookup = getCalrlookup(jurst_id, taxcgry_id, ffmcntr);
     
     if(calrlookup == null){
     	return null;
     } else {
     	return calrlookup.value;
     }
     
  }

  <%--
    - Set the tax rate for the given (jurisdiction,category) pair.
    --%>
  function setTaxRate(jurst_id, taxcgry_id, newValue)
  {
	var ffmcntr = parent.get("ffmcntr");
     <%-- set the tax rate in all calrlookup --%>
     var calrlookup = getCalrlookup_forSetTaxRate(jurst_id, taxcgry_id, ffmcntr); 
     for (var i = 0; i < size(calrlookup); i++) {
	   var row = elementAt(i,calrlookup);
	   row.value = newValue;
	   addElement(elementAt(i,calrlookup),updateCalrlookup);
     }
     
  }

  <%--
    - Populate the rates table with the current tax category rates.
    --%>
  function populateTable()
  {
    var taxes = parent.get("TaxInfoBean1");
    var categories = taxes.taxcgry;
    var jurisdictions = taxes.jurst;
    var jurstCount=0;
	var ffmcntr = parent.get("ffmcntr");
    // Loop through the table rows and set their values
    for( var i=0; i < size(jurisdictions); i++ )
    {
      var jurisdiction = elementAt(i,jurisdictions);
      if (jurisdiction.subclass != "2") continue;

      for( var j=0; j < size(categories); j++ ) {
         var category = elementAt(j,categories);
         var fieldName = tableEntryName(jurstCount, j);

         var taxRate = getTaxRate(jurisdiction.jurisdictionId, category.categoryId, ffmcntr);
         //taxRate is null means this tax category is not associated any calcode.
         //alert("fieldName:"+fieldName+" taxRate:"+taxRate);
         if(taxRate == null) {
         	TaxRatesTable.document.f1[fieldName].value = numberToStr(0, "<%=langId%>", 4);
         	TaxRatesTable.document.f1[fieldName].disabled = true;
         } else {
         	TaxRatesTable.document.f1[fieldName].value = numberToStr(taxRate, "<%=langId%>", 4);
         }
         
      }
      jurstCount++;
    }
  }


  <%--
    - Disable the rates table with the current tax category rates.
    --%>
  function disableTable()
  {
    var taxes = parent.get("TaxInfoBean1");
    var categories = taxes.taxcgry;
    var jurisdictions = taxes.jurst;
    var jurstCount=0;

    // Loop through the table rows and set their values
    for( var i=0; i < size(jurisdictions); i++ )
    {
      var jurisdiction = elementAt(i,jurisdictions);
      if (jurisdiction.subclass != "2") continue;

      for( var j=0; j < size(categories); j++ ) {      
         var fieldName = tableEntryName(jurstCount, j);
         TaxRatesTable.document.f1[fieldName].value = '0.0000';
         TaxRatesTable.document.f1[fieldName].disabled = true;
         //alert("disable fieldName="+fieldName);
      }
      jurstCount++;
    }
  }

  function findNthJurisdiction(n)
  {
     var taxes = parent.get("TaxInfoBean1");
     var jurisdictions = taxes.jurst;
     var count = 0;
  
     for( var i=0; i < size(jurisdictions); i++ ) {
       var jurisdiction = elementAt(i,jurisdictions);
       if (jurisdiction.subclass != "2") continue;

       if (n == count) {
          return jurisdiction;
       }
       count++;
     }

     alertDialog(changeSpecialText("<%=UIUtil.toJavaScript((String) taxNLS.getJSProperty("errorJurisdictionNotFound"))%>", n));
  }

  <%--
    - Validate the field entry that was just entered into a text box in the rates
    - table.
    -
    - fieldName - The name of the text field being validated.
    -
    - Returns a primative numeric value or a string if successfull;  "null" if
    - an invalid entry has been encountered
    --%>
  function validateEntry(fieldName)
  {
    var taxes = parent.get("TaxInfoBean1");
    var categories = taxes.taxcgry;
	var ffmcntr = parent.get("ffmcntr");

    var x = tableIndex(fieldName);
    var jurisdiction = findNthJurisdiction(x.row);
    var category = elementAt(x.column,categories);
    
    var calrlookup = getCalrlookup(jurisdiction.jurisdictionId, category.categoryId, ffmcntr);

    var newValue = strToNumber(TaxRatesTable.document.f1[fieldName].value, "<%=langId%>");
    
    if (!isValidNumber(TaxRatesTable.document.f1[fieldName].value, "<%=langId%>") || (newValue < 0)) {
	    alertDialog("<%=taxNLS.getJSProperty("InvalidRateMsg")%>");
	    TaxRatesTable.document.f1[fieldName].value = numberToStr(calrlookup.value, "<%=langId%>", 4);
	    TaxRatesTable.document.f1[fieldName].focus();
	 }
	 else {
	    //alert("setTaxRate");
       	setTaxRate(jurisdiction.jurisdictionId, category.categoryId, newValue);
		TaxRatesTable.document.f1[fieldName].value = numberToStr(newValue, "<%=langId%>", 4);
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
    var taxes = parent.get("TaxInfoBean1");
    var categories = taxes.taxcgry;
    var jurisdictions = taxes.jurst;
    var jurstCount=0;
    var codes = taxes.calcode;
    if (size(codes) == 1) {
    	return true;
    }

    // Loop through the table rows and set their values
    for( var i=0; i < size(jurisdictions); i++ )
    {
      var jurisdiction = elementAt(i,jurisdictions);
      if (jurisdiction.subclass != "2") continue;

      for( var j=0; j < size(categories); j++ ) {
         var category = elementAt(j,categories);
         var fieldName = tableEntryName(jurstCount, j);
		 
		 if(TaxRatesTable.document.f1[fieldName].disabled == true){
		 	continue;
		 }
		 
		 var isValid = isValidNumber(TaxRatesTable.document.f1[fieldName].value, "<%=langId%>");
         var cellValue = strToNumber(TaxRatesTable.document.f1[fieldName].value, "<%=langId%>");

         if ( !isValid || (cellValue < 0)) {
			   alertDialog ("<%=taxNLS.getJSProperty("InvalidRateMsg")%>");
				TaxRatesTable.document.f1[fieldName].focus();
				return false;
         } else {
            setTaxRate(jurisdiction.jurisdictionId, category.categoryId, cellValue);
		 }
	  }
      jurstCount++;
    }
    parent.put("updateCalrlookup", updateCalrlookup);
  }

</SCRIPT>
  <FRAMESET ROWS="100, *" BORDER=0>
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
               SRC="/wcs/tools/taxation/table.html?CTS=<%=System.currentTimeMillis()%>"
               TITLE="<%=taxNLS.getJSProperty("taxWizardRatesTab")%>"
               FRAMEBORDER="0"
               BORDER="0"
               NORESIZE
               SCROLLING="auto"
               MARGINWIDTH=15
               MARGINHEIGHT=10>
  </FRAMESET>
</HTML>

