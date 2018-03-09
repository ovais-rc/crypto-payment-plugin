<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2000, 2016 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<HTML>
<HEAD>

<%@page import = "java.util.*,
			com.ibm.commerce.command.CommandContext,
			com.ibm.commerce.beans.*,
			com.ibm.commerce.tools.catalog.beans.*,
			com.ibm.commerce.catalog.objects.*,
			com.ibm.commerce.tools.util.*,
			com.ibm.commerce.tools.catalog.util.*"
%>
<%@include file="../common/common.jsp" %>

<%
  CommandContext cmdContext = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
  Locale jLocale = cmdContext.getLocale();
  String jCurrency = cmdContext.getCurrency();
  Hashtable itemResource = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("catalog.CategoryNLS", jLocale);
  Integer storeId = cmdContext.getStoreId();
%>

<% 
     
  try {
   String strCategoryId = request.getParameter("categoryId");    
   String lang_id = cmdContext.getLanguageId().toString();

    String strCreate = request.getParameter("bCreate");

    Boolean blnCreate = null;
    if (( strCreate != null ) && ( strCreate.equals("true") ) ) {
	blnCreate = new Boolean ( true );
    } else {
	blnCreate = new Boolean ( false );
    }
    boolean bCreate = blnCreate.booleanValue(); 

   String strFullImage = "";
   String strThumbNail = "";

   if ( ! bCreate ) {
      try {
        CatalogGroupDescriptionAccessBean cgdAB = new CatalogGroupDescriptionAccessBean ();
        cgdAB.setInitKey_catalogGroupReferenceNumber ( strCategoryId );
        cgdAB.setInitKey_language_id ( lang_id );

        strFullImage = cgdAB.getFullIImage();
        strThumbNail = cgdAB.getThumbNail();
     } catch ( Exception e ) {
       strFullImage = "";
       strThumbNail = "";
     }
  }
  strFullImage = ( strFullImage != null ? UIUtil.toJavaScript( strFullImage ) : "");  
  strThumbNail = ( strThumbNail != null ? UIUtil.toJavaScript( strThumbNail ) : "");
   
%>

<META name="GENERATOR" content="IBM WebSphere Page Designer V3.0.2 for Windows">
<META http-equiv="Content-Style-Type" content="text/css">
<TITLE><%=UIUtil.toHTML((String)itemResource.get("categoryImageTitle"))%></TITLE>
<%@page import="com.ibm.commerce.tools.util.UIUtil" %> 
<link rel=stylesheet href="<%= UIUtil.getCSSFile(jLocale) %>" type="text/css"> 

<SCRIPT LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT> 
<SCRIPT>
 
function ImageData(fullimage, thumbnail) {
     
    this.fullimage = "<%= strFullImage %>";
    this.thumbnail = "<%= strThumbNail %>";
     
}  

Image.ID = "image";
Image.messages = new Object();

function Image(fullimage, thumbnail) {
  
    this.data = new ImageData(fullimage, thumbnail);
    this.id = Image.ID;
    this.formref = null;
    this.msgs = Image.messages;
     
}

function moveFocus(formFieldName) {
    var focus_target = "this.formref." + formFieldName + "." + "focus()";
    eval(focus_target);
}

function load() {

    this.data.fullimage = parent.cutspace(this.formref.fullimage.value);
    this.data.thumbnail = parent.cutspace(this.formref.thumbnail.value);
}

function display() {
    
    this.formref.fullimage.value = this.data.fullimage;
    this.formref.thumbnail.value = this.data.thumbnail;

}

function getData() {

    return this.data;
    
}

Image.prototype.load = load;
Image.prototype.display = display;
Image.prototype.getData = getData;
Image.prototype.doAlert = doAlert;
Image.prototype.focus = moveFocus;

var img = null;

function savePanelData() {

   if (img != null) {
       img.formref = document.image;
       img.load();
       parent.put(Image.ID, img.getData());
       parent.putPanelMsgs(Image.ID, img.msgs);
   }
    
}
 
function initForm() {

    img = parent.get(Image.ID);
    
    if (img == null) {
        
        initPanelObject();
        img = new Image("<%=strFullImage%>", "<%=strThumbNail%>");
	img.formref = document.image;
	img.display();
         
    } else {
        var code = parent.getErrorParams();

        initPanelObject();        
        img = new Image();
        img.data = parent.get(Image.ID);
        img.formref = document.image;
        img.msgs = parent.getPanelMsgs(Image.ID);
        img.doAlert(code);
        img.display();
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
      
      if ( msgName == "noSpaceForImageLocation" ) {
        alertDialog("<%=UIUtil.toJavaScript((String)itemResource.get("noSpaceForImageLocation"))%>");
      } else {
        alertDialog(   Image.messages[msgName]);
      }
      this.focus(guiltyField);
    }
}

function validatePanelData() {

          var full = document.image.fullimage.value;
          var thumb = document.image.thumbnail.value;
          
          if ( !isValidUTF8length(full, 254) )
      	  {
     	  	alertDialog ( Image.messages["fieldSizeExceeded"]);
                document.image.fullimage.focus();
                document.image.fullimage.select();
   	  	return false;
      	  }

          if ( !isValidUTF8length(thumb, 254) )
      	  {
     	  	alertDialog ( Image.messages["fieldSizeExceeded"]);
                document.image.thumbnail.focus();
                document.image.thumbnail.select();
   	  	return false;
      	  }
          
      	  if (numOfOccur(full, ' ') > 0) {
		alertDialog ( Image.messages["noSpaceForImageLocation"] );
                document.image.fullimage.focus();
                document.image.fullimage.select();
      	  	return false;
      	  }
      	  
      	  if (numOfOccur(thumb, ' ') > 0) {
		alertDialog ( Image.messages["noSpaceForImageLocation"] );
                document.image.thumbnail.focus();
                document.image.thumbnail.select();
      	  	return false;
      	  } 
      	   
      return true;
}

function initPanelObject() {

   Image.messages["fieldSizeExceeded"] = "<%=UIUtil.toJavaScript((String)itemResource.get("fieldSizeExceeded"))%>";  
   Image.messages["noSpaceForImageLocation"] = "<%=UIUtil.toJavaScript((String)itemResource.get("noSpaceForImageLocation"))%>";  
} 
       
</SCRIPT>
</HEAD>

<BODY onload="initForm()" class="content">
<H1><%=UIUtil.toHTML((String)itemResource.get("categoryImageTitle"))%></H1>

<FORM name="image">
<TABLE width=500>
    <TH></TH>   

    <TR>
           <TD>
               <LABEL for="thumbnail"><%=UIUtil.toHTML((String)itemResource.get("categoryThumbnail"))%></LABEL> 
           </TD>
    </TR>
    <TR>
           <TD>
               <INPUT size="60" maxlength="254" type="text" id="thumbnail" name="thumbnail"><BR><BR>
           </TD>
    </TR>   
  
    <TR>
           <TD>
           <LABEL for="fullimage"><%=UIUtil.toHTML((String)itemResource.get("categoryFullImage"))%></LABEL>
       </TD>
    </TR>
    <TR>
           <TD>
               <INPUT size="60" maxlength="254" type="text" id="fullimage" name="fullimage"><BR><BR>
       </TD>
    </TR>
     
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
