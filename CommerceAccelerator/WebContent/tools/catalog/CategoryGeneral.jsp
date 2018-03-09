


<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">

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

<HTML>
<HEAD>

<%@page import = "java.util.*,
			com.ibm.commerce.beans.*,
			com.ibm.commerce.command.CommandContext,
			com.ibm.commerce.tools.catalog.beans.*,
			com.ibm.commerce.tools.catalog.util.*,
			com.ibm.commerce.catalog.objects.*,
			com.ibm.commerce.contract.objects.*,
			com.ibm.commerce.common.objects.StoreAccessBean,
			com.ibm.commerce.context.content.ContentContext,
			com.ibm.commerce.tools.util.*,
            com.ibm.commerce.registry.StoreRegistry"
%>
<%@include file="../common/common.jsp" %>

<%
  CommandContext cmdContext = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
  Locale jLocale = cmdContext.getLocale();
  String jCurrency = cmdContext.getCurrency();
  Hashtable itemResource = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("catalog.CategoryNLS", jLocale);
  Hashtable itemResource2 = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("catalog.ItemNLS", jLocale);
  Integer intStoreId = cmdContext.getStoreId();
  String storeId = cmdContext.getStoreId().toString();
  String lang_id = cmdContext.getLanguageId().toString();

  try {
  
    boolean ifInWorkSpace = false;
    ContentContext contentCtxt = (ContentContext) cmdContext.getContext(ContentContext.NAME);
    if ((null != contentCtxt) && (null != contentCtxt.getWorkspace()) ) {
    	ifInWorkSpace = true;
    } 


  
    String strCategoryId = request.getParameter("categoryId");    

    String strCreate = request.getParameter("bCreate");
    Boolean blnCreate = null;
    if (( strCreate != null ) && ( strCreate.equals("true") ) ) {
	blnCreate = new Boolean ( true );
    } else {
	blnCreate = new Boolean ( false );
    }
    boolean bCreate = blnCreate.booleanValue(); 

   String strName = "";
   String strCode = "";
   String strDescription = "";
   String strLongDescription = "";
   String strKeyword = "";
   String strContracts   = "false";
   String strMasterCatalogId = null;
   String strStoreType = null;
   String strPublished = "1";
   String strpsName = "";
   String strpsOwnerId = "";

   boolean b2b = false;
   try {
     // Uses the StoreRegistry for better performance
     StoreAccessBean store = StoreRegistry.singleton().find(intStoreId);
     if (store == null) {
			store = new StoreAccessBean() ;
			store.setInitKey_storeEntityId(storeId);
     }
     CatalogAccessBean masterCatalog = store.getMasterCatalog();
     strMasterCatalogId = masterCatalog.getCatalogReferenceNumber();
     strStoreType = store.getStoreType ();
     b2b = ( strStoreType.equals( "B2B" ) || strStoreType.equals( "BRH" ) || strStoreType.equals( "BMH" ) || strStoreType.equals( "CPS" ) || strStoreType.equals( "SCS" )  || strStoreType.equals( "SHS" ));
   } catch ( Exception e ) {
     b2b = false;          
   }

   
   String strPS = "";
   if ( ! bCreate ) {
        
      try {
        CatalogGroupAccessBean cgAB = new CatalogGroupAccessBean ();
        cgAB.setInitKey_catalogGroupReferenceNumber ( strCategoryId );
        strCode = cgAB.getIdentifier();
      } catch ( Exception e ) {
        strCode = "";
      }

      strName = null;
      strDescription = null;
      strLongDescription = null;
      strKeyword = null;
      strPublished = null;
      CatalogGroupDescriptionAccessBean cgdAB = null;

      try {

         cgdAB = new CatalogGroupDescriptionAccessBean ();
         cgdAB.setInitKey_catalogGroupReferenceNumber ( strCategoryId );
         cgdAB.setInitKey_language_id ( lang_id );
        
         strName = cgdAB.getName ();
         strDescription = cgdAB.getShortDescription();
         strLongDescription = cgdAB.getLongDescription();
         strKeyword = cgdAB.getKeyWord();
         strPublished = cgdAB.getPublished();
      } catch ( Exception e ) {
         if ( strName == null ) {
            strName = ""; 
         }
         strDescription = "";
         strLongDescription = "";
         strKeyword = "";
         strPublished = "0";
      }


      strName = (strName != null ? UIUtil.toJavaScript(strName) : "");
      strCode = (strCode != null ? UIUtil.toJavaScript(strCode) : "");
      strDescription = (strDescription != null ? UIUtil.toJavaScript( strDescription ) : "");
      strLongDescription = (strLongDescription != null ? UIUtil.toJavaScript( strLongDescription ): "");
      strKeyword = (strKeyword != null ? UIUtil.toJavaScript( strKeyword ): "");      
      strPublished = (strPublished != null ? UIUtil.toJavaScript( strPublished ) : "");


		try {

			CatalogGroupProductSetRelAccessBean cgpsrAB = new CatalogGroupProductSetRelAccessBean();
			Enumeration e = cgpsrAB.findByCatalogIdAndCatGroupId(new Long(strMasterCatalogId), new Long(strCategoryId));
			
			// CATGRPPS relationship is found
			if (e.hasMoreElements()) {

				cgpsrAB = (CatalogGroupProductSetRelAccessBean) e.nextElement ();
				strPS = cgpsrAB.getProductSetId ();
                 				
				if (strPS != null) {
                 
					// get product set
					ProductSetAccessBean psAB = new ProductSetAccessBean();
					psAB.setInitKey_productSetId(strPS);
					
					// retrieve ownerId and Name of the product set
					strpsOwnerId = psAB.getOwnerId();
					strpsName = psAB.getName();
					
			  		BusinessPolicyAccessBean policy = new BusinessPolicyAccessBean();
					Enumeration policyEn = policy.findProductSetPolicyByPropertyPredicate("%"+strpsName+"%", "%"+strpsOwnerId+"%");
					
					while ((policyEn.hasMoreElements()) && (strContracts.equals("false"))) {
						
						policy = (BusinessPolicyAccessBean) policyEn.nextElement();

						// check and this policy applies to the current store
						if (policy.getStoreEntityId().equals(storeId)) {
							strContracts = "true";
						}
					}

                 }
                 
             }
          
		} catch ( Exception ex ) {
		}


   }
%>

<META name="GENERATOR" content="IBM WebSphere Page Designer V3.0.2 for Windows">
<META http-equiv="Content-Style-Type" content="text/css">
<TITLE><%=UIUtil.toHTML((String)itemResource.get("categoryGeneralTitle"))%></TITLE>
<%@page import="com.ibm.commerce.tools.util.UIUtil" %> 
<link rel=stylesheet href="<%= UIUtil.getCSSFile(jLocale) %>" type="text/css"> 

<SCRIPT LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT> 

<SCRIPT>
 
function CategoryGeneralData(){

   this.code = "<%=strCode%>"; 
   this.name = "<%=strName%>"; 
   this.description = "<%=strDescription%>"; 
   this.longdescription = "<%=strLongDescription%>";   				
   this.keyword = "<%=strKeyword%>";
   this.contracts = "<%=strContracts%>"; 
   this.catalog_id = "<%= strMasterCatalogId %>";
   this.ps_id = "<%= strPS %>";
   this.published = "<%= strPublished %>";
}

CategoryGeneral.messages = new Object();
CategoryGeneral.ID = "categorygeneral";

function CategoryGeneral () {
   this.data = new CategoryGeneralData();
   this.id = CategoryGeneral.ID;
   this.formref = null;
   this.msgs = CategoryGeneral.messages;
}

function moveFocus(formFieldName) {
    var focus_target = "this.formref." + formFieldName + "." + "focus()";
    eval(focus_target);
}

function load() {

   this.data.name = parent.cutspace( this.formref.cname.value );
   this.data.code = parent.cutspace( this.formref.code.value );
   this.data.description = parent.cutspace( this.formref.description.value );
   this.data.longdescription = parent.cutspace( this.formref.longdescription.value );
   this.data.keyword = parent.cutspace( this.formref.keyword.value );
   
   if (this.formref.published.checked == true) {
      this.data.published = "1";
   } else {
      this.data.published = "0";
   }


<% if ( b2b && (!ifInWorkSpace)) { %>
   if (this.formref.contracts.checked == true) {
     this.data.contracts = "true";
   } else {
     this.data.contracts = "false";
   }
<% } %>
}

function display() {


    this.formref.cname.value = this.data.name;
    this.formref.code.value = this.data.code;
    this.formref.description.value = this.data.description;
    this.formref.longdescription.value = this.data.longdescription;
    this.formref.keyword.value = this.data.keyword;
    
    if ( this.data.published == "1" || this.data.published == "" ) {
      this.formref.published.checked = true;
    } else {
      this.formref.published.checked = false;
    }
    
<% if ( b2b && (!ifInWorkSpace)) {%>
    if ( this.data.contracts == "true" ) {
      this.formref.contracts.checked = true;
    } else {
      this.formref.contracts.checked = false;
    }
<% } %> 
}    

function getData() {
    return this.data;
}

CategoryGeneral.prototype.load = load;
CategoryGeneral.prototype.display = display;
CategoryGeneral.prototype.getData = getData;
CategoryGeneral.prototype.focus = moveFocus;
CategoryGeneral.prototype.doAlert = doAlert;

var cg = null;

function savePanelData() {
	var name2 = "<%=strName%>"; 
	if(name2!="" && name2!=null || name2.length!=0){
   	//for update fail
   		if (! isValidCategoryName(document.categorygeneral.cname.value)){
         	   document.categorygeneral.cname.select();
                   return false;
                 }
           }

   if (cg != null)   {
       cg.formref = document.categorygeneral;
       cg.load();
       parent.put( CategoryGeneral.ID, cg.getData());
       parent.putPanelMsgs( CategoryGeneral.ID, cg.msgs);
   }
     
}
 
function initForm() {

    var dataObject = parent.get( CategoryGeneral.ID );
    
    if (dataObject == null) {
        
        initPanelObject();
        
        cg = new CategoryGeneral ();
        cg.formref = document.categorygeneral;
	cg.msgs = CategoryGeneral.messages;  
        cg.display();
        
    } else {

        var code = parent.getErrorParams();
        
        cg = new CategoryGeneral();
        cg.msgs = parent.getPanelMsgs(CategoryGeneral.ID);
        cg.data = dataObject;
        cg.formref = document.categorygeneral;
        cg.doAlert(code);
        cg.display();
         
    }
    parent.setContentFrameLoaded(true);
}    

function doAlert(code) 
{
    if (code != null) 
    {
      var sep = "_";
      var msgName = code.substring(0, code.indexOf(sep));
      var guiltyField = code.substring(code.indexOf(sep) + 1, code.length);
      
      alertDialog(this.msgs[msgName]);
      this.focus(guiltyField);
    }
}

function validatePanelData() {

      var name = document.categorygeneral.cname.value;
      var code = document.categorygeneral.code.value;
      var desc = document.categorygeneral.description.value;
      var longdesc = document.categorygeneral.longdescription.value;
	  var keywrd = document.categorygeneral.keyword.value;	

  	if ( !isValidUTF8length(code, 254)  )
      	{
	     alertDialog(cg.msgs["fieldSizeExceeded"]);
             document.categorygeneral.code.focus();
             document.categorygeneral.code.select();
             return false;
      	}
     	
     	if ((code == "") || ( code == null ) ) {
	   alertDialog(cg.msgs["misscode"]);
           document.categorygeneral.code.focus();
           document.categorygeneral.code.select();
           return false;
     	}


  	if ( !isValidUTF8length(name, 254)  )
      	{
	     alertDialog(cg.msgs["fieldSizeExceeded"]);
             document.categorygeneral.cname.focus();
             document.categorygeneral.cname.select();
             return false;
      	}
     	
     	if ((name == "") || ( name == null ) ) {
           alertDialog(cg.msgs["missname"]);
           document.categorygeneral.cname.focus();
           document.categorygeneral.cname.select();
           return false;
     	}

       if (! isValidCategoryName(name)){
           alertDialog(cg.msgs["invalidname"]);
           document.categorygeneral.cname.select();
           return false;
        }


        if ( !isValidUTF8length(desc, 254)  )
      	{
           alertDialog(cg.msgs["fieldSizeExceeded"]);
           document.categorygeneral.description.focus();
           document.categorygeneral.description.select();
   	   return false;
      	}
		
        if ( !isValidUTF8length(longdesc, 4000)  )
      	{
           alertDialog(cg.msgs["fieldSizeExceeded"]);
           document.categorygeneral.longdescription.focus();
           document.categorygeneral.longdescription.select();
   	   return false;
      	}

        if ( !isValidUTF8length(keywrd, 254)  )
      	{
           alertDialog(cg.msgs["fieldSizeExceeded"]);
           document.categorygeneral.keyword.focus();
           document.categorygeneral.keyword.select();
   	   return false;
      	}

      return true;
}

//Disallow illegal characters for category name
//This function is copied from ProductDetail.jsp
function isValidCategoryName(myString) {
    var invalidChars = "<>"; // invalid chars
    invalidChars += "\t"; // escape sequences
    
    // if the string is empty it is not a valid name
    if (isEmpty(myString)) return false;
 
    // look for presence of invalid characters.  if one is
    // found return false.  otherwise return true
    for (var i=0; i<myString.length; i++) {
      if (invalidChars.indexOf(myString.substring(i, i+1)) >= 0) {
        return false;
      }
    }    
        
    return true;
}

function initPanelObject() {

   CategoryGeneral.messages["missname"] = "<%=UIUtil.toJavaScript((String)itemResource.get("missname"))%>";
   CategoryGeneral.messages["invalidname"] = "<%=UIUtil.toJavaScript((String)itemResource.get("invalidname"))%>";
   CategoryGeneral.messages["misscode"] = "<%=UIUtil.toJavaScript((String)itemResource.get("misscode"))%>";
   CategoryGeneral.messages["fieldSizeExceeded"] = "<%=UIUtil.toJavaScript((String)itemResource.get("fieldSizeExceeded"))%>";  
 
} 
       
</SCRIPT>
</HEAD>

<BODY onload="initForm()" class="content">
<H1><%=UIUtil.toHTML((String)itemResource.get("categoryGeneralTitle"))%></H1>

<FORM name="categorygeneral">
<TABLE cols=6>   
    <TH colspan="6"></TH>   
    <TR>
	<TD colspan="4">
                <LABEL for="code"><%=UIUtil.toHTML((String)itemResource.get("categoryCode_caption"))%></LABEL><BR>
           </TD>
    </TR>
    <TR>
	<TD colspan="4">
	   <INPUT size="32" maxlength="254" type="text"  id="code" name="code"> <BR><BR>
           </TD>
    </TR>
    <TR>
	<TD colspan="4">
           <LABEL for="cname"><%=UIUtil.toHTML((String)itemResource.get("categoryName_caption"))%></LABEL><BR>
           </TD>
    </TR>
    <TR>
	<TD colspan="4">
	   <INPUT size="32" maxlength="254" type="text" id="cname" name="cname"> <BR><BR>
           </TD>
    </TR>

    <TR>
	<TD colspan="4">
	   <LABEL for="description"><%=UIUtil.toHTML((String)itemResource.get("categoryDescription"))%></LABEL><BR>
        </TD>
    </TR>

    <TR>
	<TD colspan="4">
           <TEXTAREA id="description" name="description" value='' rows="3" cols="50" WRAP="HARD"></TEXTAREA><BR><BR>
	</TD>
    </TR>

	<TR>
	<TD colspan="4">
	   <LABEL for="longdescription"><%=UIUtil.toHTML((String)itemResource.get("categoryLongDescription"))%></LABEL><BR>
        </TD>
    </TR>

    <TR>
	<TD colspan="4">
           <TEXTAREA id="longdescription" name="longdescription" value='' rows="3" cols="50" WRAP="HARD"></TEXTAREA><BR><BR>
	</TD>
    </TR>

    <TR>
       <TD>
           <LABEL for="keyword"><%=UIUtil.toHTML((String)itemResource.get("categorykeyword"))%></LABEL>
	   </TD>
    </TR>
    <TR>
       <TD>
           <INPUT size="32" maxlength="254" type="text" id="keyword" name="keyword"><BR><BR>
       </TD>
    </TR>

    <TR>
       <TD colspan="4">
           <INPUT type="checkbox" id="published" name="published" > &nbsp;<LABEL for="published"><%=UIUtil.toHTML((String)itemResource2.get("published"))%></LABEL><BR><BR>
       </TD>
    </TR>





<% if ( b2b && (!ifInWorkSpace)) { %>
    <TR>
       <TD colspan="4">
           <INPUT type="checkbox" id="contracts" name="contracts"> &nbsp;<LABEL for="contracts"><%=UIUtil.toHTML((String)itemResource.get("categoryContracts"))%></LABEL><BR><BR>
       </TD>
    </TR>
<% } %>
</TABLE>
</FORM>    
 
<%
}
catch (Exception e) 
{
       com.ibm.commerce.exception.ExceptionHandler.displayJspException(request, response, e);
}

%>

</BODY>
</HTML>
