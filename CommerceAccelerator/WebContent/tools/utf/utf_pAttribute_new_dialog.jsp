<!-- ========================================================================
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2000, 2016
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//* MS
//*-------------------------------------------------------------------
 ===========================================================================-->
<%@ page import="com.ibm.commerce.common.objects.*"  %>
<%@ page import="com.ibm.commerce.command.*" %>
<%@ page import="com.ibm.commerce.datatype.*" %>
<%@ page import="com.ibm.commerce.beans.*" %>
<%@ page import="com.ibm.commerce.exception.*" %>
<%@ page import="com.ibm.commerce.tools.test.*" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.utf.utils.*" %>
<%@ page import="com.ibm.commerce.utf.objects.*" %>
<%@ page import="com.ibm.commerce.utf.beans.*" %>
<%@ page import="com.ibm.commerce.utf.helper.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*"  %>
<%@ page import="java.text.*"  %>

<%@ include file="../common/common.jsp" %>

<%
     Locale   aLocale = null;
     Integer  lang = null;
     String   lang_id =  "-1";
     CommandContext aCommandContext = (CommandContext)request.getAttribute("CommandContext");    
     if( aCommandContext!= null )
     {
         aLocale = aCommandContext.getLocale();
	     lang = aCommandContext.getLanguageId();
         lang_id = lang.toString();
	 //out.println("lang_id is" + lang_id);
     }

     Hashtable utfNLS = (Hashtable)ResourceDirectory.lookup("utf.utfNLS",aLocale);

     String emptyString = new String("");


  	String StoreId =  request.getParameter("StoreId");
	if (StoreId == null){
           StoreId= aCommandContext.getStoreId().toString();
           if(StoreId==null){
           	StoreId="0";
           }
	}

 //***Get ownerid from storeent table
     StoreAccessBean storeAB = com.ibm.commerce.registry.StoreRegistry.singleton().find(new Integer(StoreId));
     String   ownerid =  storeAB.getMemberId(); 


%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<link rel="stylesheet" href="<%= UIUtil.getCSSFile(aLocale)%>" type="text/css" />
<title><%= utfNLS.get("utf_CreateEntry") %></title>
<script type="text/javascript" src="/wcs/javascript/tools/common/Util.js"></script>

<script type="text/javascript">

var msgMandatoryField  = "<%= UIUtil.toJavaScript( (String)utfNLS.get("msgMandatoryField")) %>";
var msgInvalidSize  = "<%= UIUtil.toJavaScript( (String)utfNLS.get("msgInvalidSize")) %>";
var attrName;
var attrDesc;
var attrType;
var lang_id;
var owner_id;
var encryptFlag;

function initializeState()
{
  document.entryForm.attrEntry.focus();
  document.entryForm.encrypt.value="0";
  document.entryForm.newEntrydesc.value = "";
  parent.setContentFrameLoaded(true);
}


function savePanelData() {
//   alert("start Save");

  var form = document.entryForm; 
  var ecrypt="";
  parent.put("attrName", form.attrEntry.value);
  parent.put("attrDesc", form.newEntrydesc.value);   
 
  form.entype.value = form.entype.options[form.entype.selectedIndex].value;
  
  parent.put("attrType", form.entype.value );    
  parent.put("sequence", 1 );

  parent.put("lang_id", "<%= lang_id %>"); 

  if(form.encrypt[0].checked == <%= UTFOtherConstants.EC_ENCRYPTION %> )
	ecrypt=<%= UTFOtherConstants.EC_ENCRYPTION %>;
  else    
      ecrypt=<%= UTFOtherConstants.EC_NO_ENCRYPTION %>;

  parent.put("encryptFlag", ecrypt);
  
//alert("end Save");
  // return true;
}  

function validatePanelData() {

    var form=document.entryForm;

    if (isInputStringEmpty(document.entryForm.attrEntry.value)){
        reprompt(document.entryForm.attrEntry, msgMandatoryField );
        return false;
    }

    if (isInputStringEmpty(form.newEntrydesc.value.toString())){
        reprompt(document.entryForm.newEntrydesc, msgMandatoryField );
        return false;
    }
	
    if (!isValidUTF8length(form.newEntrydesc.value,254)) {
		reprompt(document.entryForm.newEntrydesc, msgInvalidSize );
		return false;
	}

    return true;
}

</script>
</head>

<body class="content" onload="initializeState();">
<br /><h1><%= utfNLS.get("utf_CreateEntry") %></h1>


   <form name="entryForm" action="">   
   
	<table>
        <tr>
	      <td>
                 <%= utfNLS.get("utf_newEntryText") %><br /><br /> 
	      </td>
        </tr>
        <tr>
	      <td>
	         <label for="attrEntry"><%= utfNLS.get("utf_newTerm") %></label><br />
		 <input type="text" name="attrEntry" id="attrEntry" size="46" maxlength="254" value="" />
	      </td>
        </tr>
	<tr>
	<td>
		<label for="newEntrydesc"><%= utfNLS.get("desc") %> <%= utfNLS.get("required") %></label><br />
	 	<textarea name="newEntrydesc" id="newEntrydesc" cols="50" rows="4"></textarea>
	</td>
	</tr>
	
        <tr>
	      <td>
   		<label for="entype"><%= utfNLS.get("utf_entryType") %></label><br />
    		<select name="entype" id="entype">

<%
	// get all Attribute types 
	int j = 0;
	com.ibm.commerce.catalog.objects.AttributeTypeAccessBean atab = null;

	try {
	  atab = new com.ibm.commerce.catalog.objects.AttributeTypeAccessBean();
	  java.util.Enumeration e = atab.findAll();

	  while (e.hasMoreElements()){
	    j++;
	    com.ibm.commerce.catalog.objects.AttributeTypeAccessBean atab1 = (com.ibm.commerce.catalog.objects.AttributeTypeAccessBean)e.nextElement();
    
%>
		<option value="<%= atab1.getAttributeType_id()%>" > <%= atab1.getAttributeType_id() %></option>
<%
	    
	  } // end while
      } catch (Exception e) {
	  System.out.println("EXCEPTION OCCURRED while getting attribute type " + e.toString());
      }
	
%>


    		</select>
    		    
	     </td>
	</tr>
	<tr>
		<td>
			<br />
			<p><%= utfNLS.get("utf_isEncrypted") %></p>
			<label for="R1">
			<br /><input type="radio" name="encrypt" id="R1" value="<%= UTFOtherConstants.EC_ENCRYPTION %>" /><%= utfNLS.get("yes") %>
			</label>
			<label for="R2">
			<br /><input type="radio" name="encrypt" id="R2" value="<%= UTFOtherConstants.EC_NO_ENCRYPTION %>" checked="checked" /><%= utfNLS.get("no") %>
			</label>
		</td>
	</tr>

</table>
</form>

</body>
</html>


