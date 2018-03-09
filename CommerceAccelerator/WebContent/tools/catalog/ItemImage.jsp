<%
//********************************************************************
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
//*
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">

<HTML>
<HEAD>

<%@page import="java.util.*,
 		java.lang.*,
		com.ibm.commerce.beans.*,
		com.ibm.commerce.tools.util.*,
                com.ibm.commerce.tools.catalog.beans.*,
                com.ibm.commerce.tools.catalog.util.*"
%>
<%@ page import="com.ibm.commerce.command.CommandContext" %>

<%@include file="../common/common.jsp" %>

<%
  CommandContext cmdContext = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
  Locale jLocale = cmdContext.getLocale();
  Hashtable itemResource = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("catalog.ItemNLS", jLocale);
%>

<% 
   try {
    // get parameters from URL   
    String productRefNum = request.getParameter(ECConstants.EC_PRODUCT_NUMBER);
    String lang_id = request.getParameter(com.ibm.commerce.server.ECConstants.EC_LANGUAGE_ID);
    String itemRefNum = request.getParameter(ECConstants.EC_ITEM_NUMBER);


    String catEntryRefNum = null;

    if(itemRefNum != null){
	catEntryRefNum = itemRefNum;
    }else{
	catEntryRefNum = productRefNum;
    }
    
    // activate catEntImage

    CatalogEntryDescriptionDataBean catEntImage = new CatalogEntryDescriptionDataBean();
    catEntImage.setInitKey_catalogEntryReferenceNumber(catEntryRefNum);
    catEntImage.setInitKey_language_id(lang_id);
    
    DataBeanManager.activate(catEntImage, request);
    
    String fullimage = null;
    String thumbnail = null;
    

    
    fullimage = catEntImage.getFullImage();
    thumbnail = catEntImage.getThumbNail();
    	
    
    fullimage = (fullimage != null ? UIUtil.toJavaScript(fullimage) : "");
    thumbnail = (thumbnail != null ? UIUtil.toJavaScript(thumbnail) : "");
        

    
%>


<META name="GENERATOR" content="IBM WebSphere Page Designer V3.0.2 for Windows">
<TITLE><%=UIUtil.toHTML((String)itemResource.get("image"))%></TITLE>
<link rel=stylesheet href="<%= UIUtil.getCSSFile(jLocale) %>" type="text/css">

<SCRIPT LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT>
 
 
function ImageData(fullimage, thumbnail) {
     
    this.fullimage = fullimage;
    this.thumbnail = thumbnail;
     
}  

Image.ID = "image";

function Image(fullimage, thumbnail) {
  
    this.data = new ImageData(fullimage, thumbnail);
    this.id = Image.ID;
    this.formref = null;
     
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


var img = null;

function savePanelData() {

   if (img != null) {
       img.formref = document.image;
       img.load();
       parent.put(Image.ID, img.getData());
   }
    
}

function initForm() {

    img = parent.get(Image.ID);
    
    if (img == null) {
        
        img = new Image("<%=fullimage%>", "<%=thumbnail%>");
	img.formref = document.image;
	img.display();
         
    } else {

        
        img = new Image();
        img.data = parent.get(Image.ID);
        img.formref = document.image;
        img.display();
    }
    
    if (parent.get("fieldSizeExceeded_fullimage", false))
       {
        parent.remove("fieldSizeExceeded_fullimage");
	document.image.fullimage.select();
        alertDialog("<%= UIUtil.toJavaScript((String)itemResource.get("fieldSizeExceeded"))%>");
               
       }

    if (parent.get("fieldSizeExceeded_thumbnail", false))
       {
        parent.remove("fieldSizeExceeded_thumbnail");
	document.image.thumbnail.select();
        alertDialog("<%= UIUtil.toJavaScript((String)itemResource.get("fieldSizeExceeded"))%>");
               
       }

    if (parent.get("noSpaceForImageLocation_fullimage", false))
       {
        parent.remove("noSpaceForImageLocation_fullimage");
	document.image.fullimage.select();
        alertDialog("<%= UIUtil.toJavaScript((String)itemResource.get("noSpaceForImageLocation"))%>");
               
       }

    if (parent.get("noSpaceForImageLocation_thumbnail", false))
       {
        parent.remove("noSpaceForImageLocation_thumbnail");
	document.image.thumbnail.select();
        alertDialog("<%= UIUtil.toJavaScript((String)itemResource.get("noSpaceForImageLocation"))%>");
               
       }    
     
    parent.setContentFrameLoaded(true);
}    



function validatePanelData(){

    var objFullImage = document.image.fullimage.value;
    var objThumbnail = document.image.thumbnail.value;


    if ( !isValidUTF8length(objFullImage, 254)  ){
	document.image.fullimage.select();
	alertDialog("<%=UIUtil.toJavaScript((String)itemResource.get("fieldSizeExceeded"))%>");     	 
   	return false;
    }

    if ( !isValidUTF8length(objThumbnail, 254)  ){
	document.image.thumbnail.select();
	alertDialog("<%=UIUtil.toJavaScript((String)itemResource.get("fieldSizeExceeded"))%>");     	 
   	return false;
    }

    if (numOfOccur(objFullImage, ' ') > 0){
	document.image.fullimage.select();
	alertDialog("<%=UIUtil.toJavaScript((String)itemResource.get("noSpaceForImageLocation"))%>");     	 
   	return false;
    }

    if (numOfOccur(objThumbnail, ' ') > 0){
	document.image.thumbnail.select();
	alertDialog("<%=UIUtil.toJavaScript((String)itemResource.get("noSpaceForImageLocation"))%>");     	 
   	return false;
    }

    return true;
}

 
</SCRIPT>
</HEAD>
    
<BODY class="content" onload="initForm()">
<H1><%=UIUtil.toHTML((String)itemResource.get("image"))%></H1>
<%=UIUtil.toHTML((String)itemResource.get("imagePanelInstruction"))%>
<FORM name="image">
   

<TABLE width=500>
    <TH></TH>   
  
    <TR>
           <TD>
           <LABEL for="fullimageID"><%=UIUtil.toHTML((String)itemResource.get("fullimage"))%></LABEL>
       </TD>
    </TR>
    <TR>
           <TD>
               <INPUT id="fullimageID" size="60" maxlength="254" type="text" name="fullimage"><BR><BR>
       </TD>
    </TR>
    <TR>
           <TD>
               <LABEL for="thumbnailID"><%=UIUtil.toHTML((String)itemResource.get("thumbnail"))%></LABEL>
           </TD>
    </TR>
    <TR>
           <TD>
               <INPUT id="thumbnailID" size="60" maxlength="254" type="text" name="thumbnail"><BR>
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


