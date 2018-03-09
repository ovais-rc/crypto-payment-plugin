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
.selectWidth {width: 230px;}
.selectWidth2 {width: 260px;}
.selectWidth3 {width: 260px;}
</STYLE>
</HEAD>
<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/common/Vector.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/common/FieldEntryUtil.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/common/ConvertToXML.js"></SCRIPT>
<SCRIPT>

  <%@include file="TaxUtil.jsp" %>

  <%--
    - Populate the list box with the previously defined shipping categories.
    --%>
    var	remTaxCgry = parent.get("remTaxCgry");  
	if(remTaxCgry == null){
		remTaxCgry = new Vector();
	} 

  	var	remCalRule1 = parent.get("remCalRule1");  
	if(remCalRule1 == null){
		remCalRule1 = new Vector();
	} 

  function initializeState()
  {
    var taxes = parent.get("TaxInfoBean1");
    var categories = taxes.taxcgry;
    var count = 0;

    for(var i=0; i < size(categories); i++) {
      var category = elementAt(i,categories);

      if( (category != "<%=taxNLS.getJSProperty("CategoriesDefaultTax")%>") &&
          (category != "<%=taxNLS.getJSProperty("CategoriesShippingTax")%>") ) {

		  var displayName = category.name;
        if (category.displayUsage != 0) displayName += ' (<%=taxNLS.getJSProperty("VATCheckboxDesc")%>)';
        
		  document.f1.definedCategories.options[count] = new Option(displayName, displayName, false, false);
        document.f1.definedCategories.options[count].selected=false;
		  count++;
      }
    }
    document.f1.newTaxCategory.focus();
    parent.setContentFrameLoaded(true);
  }

  <%--
    - Create a new tax category. This is called when the user clicks 'Add'
    -
    - code        The tax category code.
    - description A brief description of the tax category. 
    --%>
  function addCategory()
  {
    if (trim(document.f1.newTaxCategory.value) == "") {
       alertDialog("<%=taxNLS.getJSProperty("SelectCategoryToAdd")%>");
       return;
    }
    
    <%-- Make sure the user entered a category name of valid length--%>
    if ( !isValidUTF8length(document.f1.newTaxCategory.value, 15)) {
       alertDialog ( "<%=taxNLS.getJSProperty("tooLong")%>" );
       return;
    } 

    var taxes = parent.get("TaxInfoBean1");
    var storeid = parent.get("storeid");
    var taxcgry = taxes.taxcgry;
    var jurstgroup = taxes.jurstgroup;
    var jurst = taxes.jurst;
    var calrule = taxes.calrule;
    var taxFulfillmentInfoBean = parent.get("TaxFulfillmentInfoBean1");
    var taxjcrule = taxFulfillmentInfoBean.taxjcrule;
    var ffmcntr = parent.get("ffmcntr");
    var calcode = taxes.calcode;
//    var default_id;
      
//    for (var x=0; x < calcode.size(); x++) {
//       var tmpcalcode = calcode.elementAt(x);
//       if(tmpcalcode.code == "Default") {
//            default_id = tmpcalcode.calculationCodeId;
//            break;
//       }
//    }
                
    var newDisplayUsage = 0;
    var taxtype
    if (document.f1.newTaxVatCheckBox.checked==true && document.f1.newTaxVatCheckBox.disabled==false) newDisplayUsage = 1;
    for(var i=0; i<document.f1.taxtypeRadio.length; i++){
    	if (document.f1.taxtypeRadio[i].checked == true){
    		if (document.f1.taxtypeRadio[i].value == -3)taxtype = "sales";
    		if (document.f1.taxtypeRadio[i].value == -4)taxtype = "shipping";
	}
    }	
    for(var i=0; i < size(taxcgry); i++) {
      var category = elementAt(i,taxcgry);
      if (category.name.toUpperCase() == trim(document.f1.newTaxCategory.value.toUpperCase())) {
         alertDialog("<%=taxNLS.getJSProperty("CategoryAlreadyExists")%>");
         return;
      }
    }

    <%-- create a new category --%>
    if (taxtype == "sales"){
    	var newTaxcgry  = new parent.taxcgry();
    }
    else{
    	var newTaxcgry = new parent.shippingtaxcgry();
    }
    newTaxcgry.name = trim(document.f1.newTaxCategory.value);
    newTaxcgry.categoryId = "@taxcgry_id_" + getTaxcgryuid();
    newTaxcgry.categoryId = newTaxcgry.categoryId;
    newTaxcgry.displayUsage = newDisplayUsage;
    newTaxcgry.displayUsage = newDisplayUsage;
    newTaxcgry.storeEntityId = storeid;
    newTaxcgry.storeEntityId = storeid;
    addElement(newTaxcgry,taxcgry);
    
    
    <%-- add a new taxjcrule, and all of its dependant entries, for each defined jurisdiction --%>
    for (var i=0; i < size(jurst); i++) {
       var temp = elementAt(i,jurst);
       if (temp.subclass != "2") continue;

       var jurstGroupID = getJurstgroupIdFromJurstId(temp.jurisdictionId);
       
       for (var k=0; k < size(calcode); k++)   {
       	var thiscalcode = elementAt(k,calcode);
       	var taxtype = null;
       	//if (thiscalcode.code == "Default") continue;
       	if (thiscalcode.calculationUsageId == "-3") taxtype = "sales";
       	else if (thiscalcode.calculationUsageId == "-4") taxtype = "shipping";
       	else alertDialog("No correct tax type defined in sar!");
      	              
       	if (newTaxcgry.typeId == thiscalcode.calculationUsageId){
		  <%-- create the new calrule --%>
       	  var newCalrule = createNewCalrule(taxtype, 0);
       	  newCalrule.taxCategoryId = newTaxcgry.categoryId;
       	  newCalrule.taxCategoryId = newTaxcgry.categoryId;
       	  //newCalrule.calculationCodeId = default_id;
       	  //newCalrule.calculationCodeId = default_id;
       	  newCalrule.calculationCodeId = thiscalcode.calculationCodeId;
       	  newCalrule.calculationCodeId = thiscalcode.calculationCodeId;
       	  newCalrule.sequence = thiscalcode.sequence;
		  newCalrule.sequence = thiscalcode.sequence;
       	  addElement(newCalrule,calrule);
       	  //
       	  var precedence = getPrecedence(jurstGroupID);
	  //
       	  var newTaxjcrule = new parent.taxjcrule(precedence);
       	  newTaxjcrule.calculationRuleId = newCalrule.calculationRuleId;
          newTaxjcrule.calculationRuleId = newTaxjcrule.calculationRuleId;
       	  newTaxjcrule.jurisdictionGroupId = jurstGroupID;
		  newTaxjcrule.fulfillmentCenterId = ffmcntr;
		  newTaxjcrule.fulfillmentCenterId = ffmcntr;
       	  newTaxjcrule.taxJCRuleId = "@taxjcrule_id_" + getTaxjcruleuid();
       	  addElement(newTaxjcrule,taxjcrule);
       	}
       }
    }

	 <%-- add this new category to the display list --%>
    var displayName = newTaxcgry.name;
    if (newTaxcgry.displayUsage != 0) displayName += ' (<%=taxNLS.getJSProperty("VATCheckboxDesc")%>)';
     
    var count = document.f1.definedCategories.options.length;
    document.f1.definedCategories.options[count] = new Option(displayName, displayName, false, false);
    document.f1.definedCategories.options[count].selected=false;

	 <%-- add the taxcgryds entries for MLS enablement --%>
    var avLangList = parent.get("AvailLangList");
	 var taxcgryds = taxes.taxcgryds;

	 for (var i = 0; i < avLangList.length; i++) {
	    var thisLang = avLangList[i];
       var newTaxcgryds = new Object();
       newTaxcgryds.taxCategoryId = newTaxcgry.categoryId;
	    newTaxcgryds.description = newTaxcgry.name;
		 newTaxcgryds.languageId = thisLang.languageId;
		 addElement(newTaxcgryds,taxcgryds);
	 }

	 document.f1.newTaxCategory.value = "";
  }

  <%--
    - Remove all entries that reference this taxcgry_id.
    --%>
  function removeCategoryMLSReferences(taxcgry_id)
  {
    var taxes = parent.get("TaxInfoBean1");
    var taxcgryds = taxes.taxcgryds;

    for (var i=size(taxcgryds)-1; i >= 0 ; i--) {
       var temp = elementAt(i,taxcgryds);

       if (temp.taxCategoryId == taxcgry_id) {
          removeElementAt(i,taxcgryds);
       }
    }

  }

  <%--
    - Remove all entries that reference this taxcgry_id.
    --%>
  function removeCategoryReferences(taxcgry_id)
  {
    var taxes = parent.get("TaxInfoBean1");
    var calrule = taxes.calrule;

    for (var i=size(calrule)-1; i >= 0 ; i--) {
       var temp = elementAt(i,calrule);

       if (temp.taxCategoryId == taxcgry_id) {
          removeCalruleAssociations(temp.calculationRuleId);
          <%--Remove the records from updateCalrlookup, updateTaxJcRule,updateCalrule as per calculation rule id if existed--%>
          removeCalruleRefUpdates(temp.calculationRuleId);
          removeElementAt(i,calrule);
          <%-- add the primary ids to the vector so that it can be deleted from the db --%>
          if (temp.calculationRuleId.substring(0,1) != "@"){
  	            //remCalRule1.addElement(temp.calculationRuleId);	
  	            addElement(temp.calculationRuleId,remCalRule1);
  	            
          }
       }
    }
   parent.put("remCalRule1",remCalRule1);
  }
  

  <%--
    - Delete the previously defined tax category. This is called when
    - the user clicks 'Remove'
    --%>
  function deleteCategory()
  {

    var i = document.f1.definedCategories.selectedIndex;

	 if (i == -1) {
	    alertDialog("<%=taxNLS.getJSProperty("SelectCategoryToRemove")%>");
	    return;  
	 }

    var taxes = parent.get("TaxInfoBean1");
    var categories = taxes.taxcgry;
    var removedCategory = elementAt(i,categories);
    <%-- add the primary ids to the vector so that it can be deleted from the db --%>
    if (removedCategory.categoryId.substring(0,1) != "@"){
  		//remTaxCgry.addElement(removedCategory.categoryId);	
  	  	addElement(removedCategory.categoryId,remTaxCgry);
  	
    }

    var msg = "<%=taxNLS.getJSProperty("CategoriesRemoveConfirm")%>";
    msg = msg.replace("%1", removedCategory.name);

    removeElementAt(i,categories);   
    removeCategoryReferences(removedCategory.categoryId);
    removeCategoryMLSReferences(removedCategory.categoryId);
    parent.put("remTaxCgry",remTaxCgry);
    document.f1.definedCategories.options[i] = null;
  }
  
  function toggleVAT()
  {
    var i = document.f1.definedCategories.selectedIndex;   

	 if (i == -1) {
	    alertDialog("<%=taxNLS.getJSProperty("SelectCategoryToToggle")%>");
	 }

    var taxes = parent.get("TaxInfoBean");
    var categories = taxes.taxcgry;
    var category = elementAt(i,categories);
 
	 var newDisplayUsage = 0;
	 if (category.displayUsage == 0) newDisplayUsage = 1;
    category.displayUsage = newDisplayUsage;

	 <%-- change the display --%>
    var displayName = category.name;
    if (category.displayUsage != 0) displayName += ' (<%=taxNLS.getJSProperty("VATCheckboxDesc")%>)';
     
    document.f1.definedCategories.options[i] = new Option(displayName, displayName, false, false);;
    document.f1.definedCategories.options[i].selected = true;
  }

  function enableVAT()
  {
  	document.f1.newTaxVatCheckBox.disabled=false;
  }
  
  function disableVAT()
  {
  	document.f1.newTaxVatCheckBox.disabled=true;
  }
  
  function createCategoryTable()
  {
    document.writeln("<TABLE BORDER=0 CELLSPACING=10>");
    document.writeln("<TR>");
    document.writeln("  <TD nowrap>");
    document.writeln("     <B><%=taxNLS.getJSProperty("NewTaxCategory")%></B><BR>");
    document.writeln("     <INPUT CLASS='selectWidth' SIZE=30 TYPE=text NAME='newTaxCategory' maxlength='25' WIDTH=235>");
    document.writeln("  </TD>");
    document.writeln("  <TD>");
    document.writeln("     <INPUT TYPE=BUTTON WIDTH=100 VALUE='<%=taxNLS.getJSProperty("CategoriesAddButton")%>' ONCLICK='addCategory();'>");
    document.writeln("  </TD>");
    document.writeln("</TR>");

    document.writeln("<TR><TD>&nbsp;</TD></TR>");
    document.writeln("</TABLE>");

    <%-- Write out the categories --%>
    var taxes = parent.get("TaxInfoBean1");
    var categories = taxes.taxcgry;

    document.writeln("<TABLE>");
    document.writeln("<TR><TH><%=taxNLS.getJSProperty("DefinedCategories")%></TH><TH><%=taxNLS.getJSProperty("VATCheckboxDesc")%></TH>");

    for(var i=0; i < size(categories); i++) {
      var category = elementAt(i,categories);

      if( (category.name != "<%=taxNLS.getJSProperty("CategoriesDefaultTax")%>") &&
          (category.name != "<%=taxNLS.getJSProperty("CategoriesShippingTax")%>") ) {

          document.f1.definedCategories[i].value = category.name + vatTax
          document.writeln("  <TD ALIGN=CENTER>");
          document.writeln("     <INPUT TYPE=CHECKBOX NAME=VatTax" + i  + ">");
          document.writeln("  </TD>");
          document.writeln("  <TD>");
          document.writeln("     <INPUT TYPE=BUTTON Value='<%=taxNLS.getJSProperty("CategoriesRemoveButton")%>' ONCLICK='deleteCategory(" + i + ");'>");
          document.writeln("  </TD>");
          document.writeln("</TR>");
       }
    }

    document.writeln("</TABLE>");

  }

</SCRIPT>
<BODY ONLOAD="initializeState()" CLASS="content">
<FORM NAME="f1" onsubmit='return false;'>
  <H1><%=taxNLS.getProperty("taxWizardCategoriesTab")%></H1>
  <%=taxNLS.getProperty("CategoriesMsg")%>
  <BR>
  <BR>
  <%=taxNLS.getProperty("NewTaxCategory")%>
  <BR>
  <TABLE CELLPADDING=0 BORDER=0 CELLSPACING=0 width="100%">
    <TR>
	<TD width="260">
	   <TABLE CELLPADDING=0 BORDER=0 CELLSPACING=0>
	     <TR>
		<TD class='selectWidth'>
			<LABEL><INPUT CLASS='selectWidth2' SIZE=30 TYPE=text NAME="newTaxCategory" maxlength="128"></LABEL><BR><BR>
			<%=taxNLS.getProperty("Type")%><BR>
	     	   <TABLE CELLPADDING=0 BORDER=0 CELLSPACING=0>
	     	   	<TR><TD WIDTH=20></TD>
			    <TD>
			    	<INPUT type="radio" checked name="taxtypeRadio" ID="taxtypeRadio0" value="-3" onClick="enableVAT()"><LABEL for="taxtypeRadio0"><%=taxNLS.getProperty("SalesTaxType")%></LABEL><BR>
            			<INPUT type="radio" name="taxtypeRadio" ID="taxtypeRadio1" value="-4" onClick="disableVAT()"><LABEL for="taxtypeRadio1"><%=taxNLS.getProperty("ShippingTaxType")%></LABEL>
            		    </TD>
            		</TR>
            	   </TABLE> 			
 			<LABEL><INPUT TYPE=checkbox NAME='newTaxVatCheckBox'></LABEL><%=taxNLS.getProperty("VATCheckboxDesc")%>
	    </TR>
	  </TABLE>
	</TD>
	<TD ALIGN=LEFT VALIGN=TOP>
	&nbsp;
			<INPUT type="button" id='logon' class="button" value="<%=taxNLS.getProperty("CodeAddButton")%>" onClick="addCategory()">
	</TD>
    </TR>
  </TABLE>
  <BR>
  <BR>
        <%=taxNLS.getProperty("DefinedCategories")%>

  <TABLE CELLPADDING=0 BORDER=0 CELLSPACING=0 width="100%">
     <TR>
	 <TD width="260"><LABEL for="definedCategories"><SELECT NAME="definedCategories" ID="definedCategories" SIZE='5' MULTIPLE CLASS='selectWidth3' ></SELECT></LABEL></TD>
	 <TD VALIGN=TOP> 
	 &nbsp;
	 	<INPUT type="button" id='logon' class="button" value="<%=taxNLS.getProperty("CodeRemoveButton")%> " onClick="deleteCategory()">
	 </TD>
     </TR>
  </TABLE>

</FORM>
</BODY>
</HTML>


