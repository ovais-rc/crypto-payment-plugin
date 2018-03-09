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
<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/common/NumberFormat.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/common/Vector.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/common/FieldEntryUtil.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/common/ConvertToXML.js"></SCRIPT>
<SCRIPT>
  var updateTaxcgryds = new Vector();
function visibleList(s){
   if (this.Description.visibleList){
    Description.visibleList(s);
   }
}
  var selectedLangIndex = 0;
  
  <%@include file="TaxUtil.jsp" %>

  <%--
    -- Populate the rates table with any previously defined shipping
    -- category rates.
    --%>
  function initializeState()
  {
    var taxes = parent.get("TaxInfoBean1");
    var categories = taxes.taxcgry;

	 if (size(categories) == 0) {
	 }
	 else {
	    populateTable();
   	 var entryName = tableEntryName(0, 0);
	    CategoryLangTable.document.f1[entryName].focus();
	 }
  	 parent.setContentFrameLoaded(true);
  }

  <%--
    -- Returns a unique name for a table entry
    --%>
  function tableEntryName( row, column )
  {
    return "Category" + column + "Jurisdiction" + row;
  }

  <%--
    -- Returns the row and column of a table entry
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
    -- Returns a list of jurisdictions to be used to label each row of the table
    --%>
  function getRowArray()
  {
    var taxes = parent.get("TaxInfoBean1");
    var categories = taxes.taxcgry;
    var categoryNames = new Array();

    for(var i=0; i < size(categories); i++) {
      var category = elementAt(i,categories);

      if( (category != "<%=taxNLS.getJSProperty("CategoriesDefaultTax")%>") &&
          (category != "<%=taxNLS.getJSProperty("CategoriesShippingTax")%>") ) {

		  var displayName = category.name;
        if (category.displayUsage != 0) displayName += ' (<%=taxNLS.getJSProperty("VATCheckboxDesc")%>)';
        
		  categoryNames[categoryNames.length] = displayName;
      }
    }
    return categoryNames;
 }
 
  <%--
    -- Returns a list of categories to be used to label each column of the table
    --%>
  var headingName = "<%=taxNLS.getJSProperty("CategoryTableHead")%>";
  function getColumnArray()
  {
    var colArray = new Array();
            
    colArray[0] = "<%=taxNLS.getJSProperty("CategoryLangMsg")%>";
    
    return colArray;
  }


  function compareValues(a, b)
    {
      if ( a > b ) return 1; 
      else if ( a < b ) return -1;
      else return 0;
    }

  <%--
    -- Populate a list box with the previously defined providers. This is called
    -- by the RatesTop panel after it has finished loading.
    --%>
  function populateLanguageList()
  {
    var avLangList = parent.get("AvailLangList");
    var alLangList = parent.get("AllLangList");

    for( var i = 0; i < avLangList.length; i++ ) {
       displayName = avLangList[i].description;
       Description.document.f1.langList[Description.document.f1.langList.length] = new Option(displayName, displayName, false, false);
    }
    Description.document.f1.langList[selectedLangIndex].selected = true;
  }

  <%--
    -- Populate the rates table with the current shipping providers' shipping
    -- category rates.
    --%>
  function populateTable()
  { 
    var taxes = parent.get("TaxInfoBean1");
    var avLangList = parent.get("AvailLangList");
    
    var taxcgry = taxes.taxcgry;
    var taxcgryds = taxes.taxcgryds;
    var categoryCount = 0;
    var selectedlang;
    var langIndex;
              
    var langIndex;
        
	if (Description == null || Description.document == null || Description.document.f1 == null || Description.document.f1.langList == null || Description.document.f1.langList.selectedIndex == -1)
	{
    	// the language list frame hasn't loaded yet
		langIndex = avLangList[0].languageId;
	}
	else
	{
		// a null object error happens here when Description.document.f1.langList.selectedIndex == -1, since avLangList has an index of 0...n
		langIndex = avLangList[Description.document.f1.langList.selectedIndex].languageId;
	}
    

    for (var i=0; i < size(taxcgry); i++) {
       var thistaxcgry = elementAt(i,taxcgry);  
              
		 var cgryFound = false;
       for (var j=0; j < size(taxcgryds) && cgryFound == false; j++) {
          var thistaxcgryds = elementAt(j,taxcgryds);
          if (thistaxcgry.categoryId == thistaxcgryds.taxCategoryId && thistaxcgryds.languageId == langIndex) {
          
             var fieldName = tableEntryName(i, 0);
             var categoryName = thistaxcgryds.description;
             CategoryLangTable.document.f1[fieldName].value = categoryName;
				 cgryFound = true;
          }
       }

		 if (cgryFound == false) {
		     var newTaxcgryds = new Object();
             newTaxcgryds.taxCategoryId = thistaxcgry.categoryId;
			 newTaxcgryds.description = "";
			 newTaxcgryds.languageId = langIndex;

          var fieldName = tableEntryName(i, 0);
          CategoryLangTable.document.f1[fieldName].value = newTaxcgryds.description;

			 addElement(newTaxcgryds,taxcgryds);

		 }
    }
  }
  
  <%--
    -- Called whenever the user changes the shipping provider.
    --%>
  function languageChanged()
  {
    populateTable();
    Description.document.f1.langList.options.selectedIndex.selected = true;
  }

  function getColumnName(fieldName)
  {
     var endindex = fieldName.indexOf("J");
     var num = fieldName.substring(8, endindex);
     return num;
  }
  
  function getRowName(fieldName)
  {
     var beginindex = fieldName.indexOf("n") + 1;
     var num = fieldName.substring(beginindex); 
     return num;
  }
  <%--
    -- Validate the number that was just entered into a text box in the rates table.
    --%>
  function validateEntry(fieldName)
  {
     var taxes = parent.get("TaxInfoBean1");
     var taxcgry = taxes.taxcgry;
     var taxcgryds = taxes.taxcgryds;
     var avLangList = parent.get("AvailLangList");
     
     var jurst_id = -1;
     var taxcgry_id = -1;

	  if ( !isValidUTF8length(CategoryLangTable.document.f1[fieldName].value, 255)) {
       alertDialog ( "<%=taxNLS.getJSProperty("tooLong")%>" );
		 CategoryLangTable.document.f1[fieldName].value = CategoryLangTable.document.f1[fieldName].value.substring(0,254);
		 CategoryLangTable.document.f1[fieldName].focus();
       return;
    } 
     
     var columnindex = getColumnName(fieldName);
     var rowindex = getRowName(fieldName);
   
     if (Description == null || Description.document == null || Description.document.f1 == null || Description.document.f1.langList == null) {
        langIndex = avLangList[0].languageId;
     }
     else {
        langIndex = avLangList[Description.document.f1.langList.selectedIndex].languageId;
     }   
   
     var thistaxcgry = elementAt(rowindex,taxcgry);
          
     for (var j=0; j < size(taxcgryds); j++) {
        var thistaxcgryds = elementAt(j,taxcgryds);
        if (thistaxcgryds.taxCategoryId == thistaxcgry.categoryId && thistaxcgryds.languageId == langIndex) {
           //thistaxcgryds.description = CategoryLangTable.document.f1[fieldName].value;
           elementAt(j,taxcgryds).description = CategoryLangTable.document.f1[fieldName].value;
           addElement(elementAt(j,taxcgryds),updateTaxcgryds);
        }
     }
     
     parent.put("TaxInfoBean1.taxcgryds", taxcgryds);
     parent.put("updateTaxcgryds",updateTaxcgryds);

  }

  <%--
    -- Test each table entry to see if it is a valid shipping rate. If all entries
    -- are valid, save them.
    --%>
  function validateEntries()
  {
    return(true);
  }

</SCRIPT>
  <HEAD>
  <LINK REL=stylesheet HREF="<%= UIUtil.getCSSFile(locale) %>" TYPE="text/css">
  </HEAD>
  <FRAMESET ROWS="165, *" BORDER=0>
      <FRAME NAME="Description"
               SRC="TaxCategoriesMLSTopView"
               TITLE="<%=taxNLS.getJSProperty("taxWizardCategoriesMLSTab_title")%>"
               FRAMEBORDER="0"
               BORDER="0"
               NORESIZE
               SCROLLING="no"
               MARGINWIDTH=15
               MARGINHEIGHT=15>
      <FRAME NAME="CategoryLangTable"
               SRC="/wcs/tools/taxation/tablemls.html?CTS=<%=System.currentTimeMillis()%>"
               TITLE="<%=taxNLS.getJSProperty("taxWizardCategoriesMLSTab")%>"
               FRAMEBORDER="0"
               BORDER="0"
               NORESIZE
               SCROLLING="auto"
               MARGINWIDTH=15
               MARGINHEIGHT=15>
  </FRAMESET>
</HTML>

