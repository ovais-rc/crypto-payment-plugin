<!--
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*   
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2000, 2013
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
//*
-->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2013 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%@ page language="java" 
    import="java.util.*,
            com.ibm.commerce.tools.common.*,
            com.ibm.commerce.tools.util.*,
            com.ibm.commerce.server.*,
            com.ibm.commerce.user.beans.*,
            com.ibm.commerce.user.objects.*,
            com.ibm.commerce.usermanagement.commands.ECUserConstants,
            com.ibm.commerce.tools.optools.user.beans.*,
	    com.ibm.commerce.beans.*,
	    com.ibm.commerce.command.*,
	    com.ibm.commerce.common.beans.*,
            com.ibm.commerce.tools.xml.*"
    
%>

<%@include file="../common/common.jsp" %>

<%
try
{
 	CommandContext cmdContext = (CommandContext)request.getAttribute("CommandContext");
	Hashtable userNLS = (Hashtable)ResourceDirectory.lookup("buyerconsole.BuyOrgEntityNLS", cmdContext.getLocale());
	String webalias = UIUtil.getWebPrefix(request);	
	
	String userId = request.getParameter("shrfnbr");
	// String storeId = request.getParameter("storeId");
	// String addressId = request.getParameter(ECConstants.EC_ADDR_REFNUM);
	Locale cmdLocale = cmdContext.getLocale();
	String locale = cmdLocale.toString();
    
	Hashtable formats = (Hashtable)ResourceDirectory.lookup("buyerconsole.nlsFormats");
	Hashtable format = (Hashtable)XMLUtil.get(formats, "nlsFormats."+ locale);
        if (format == null) 
        {
          format = (Hashtable)XMLUtil.get(formats, "nlsFormats.default");
        } 
	
	String showPhoneType = "false";
	String showPhoneListed = "false";

	// (defect 8650)
	// Check that if the showPhoneType and showPhoneListed is null
	// which means that they are not defined in the property file
	// Initialize these two variables to 'false'
	if (null == showPhoneType)
		showPhoneType = new String("false");
	if (null == showPhoneListed)
		showPhoneListed = new String("false");

    	String orgEntityId = request.getParameter("orgEntityId");
    	OrgEntityDataBean bnOrgEntity = new OrgEntityDataBean();
	if(!(orgEntityId == null || orgEntityId.trim().length()==0)) 
        {
		bnOrgEntity.setOrgEntityId(orgEntityId);
		com.ibm.commerce.beans.DataBeanManager.activate(bnOrgEntity, request);
	}
	
	    
        // (defect 8650)
	// Check that if the showPhoneType and showPhoneListed is null
	// which means that they are not defined in the property file
	// Initialize these two variables to 'false'
	if (null == showPhoneType)
		showPhoneType = new String("false");
	if (null == showPhoneListed)
		showPhoneListed = new String("false");


	ResourceBundleDataBean bnResourceBundle = new ResourceBundleDataBean();
	bnResourceBundle.setPropertyFileName("UserRegistration");
	DataBeanManager.activate(bnResourceBundle, request);


	// for drop-down list options
	String BestCallingTimeURL = ECUserConstants.EC_ADDR_BESTCALLINGTIME;
		
	Hashtable hshBestCallingTime  = new Hashtable();
	
	SortedMap smpFields = bnResourceBundle.getPropertySortedMap();
	Iterator entryIterator = smpFields.entrySet().iterator();
	Map.Entry textentry = (Map.Entry) entryIterator.next();
	Hashtable hshText = (Hashtable) textentry .getValue();
	
	while (entryIterator.hasNext()) {
		Map.Entry entry = (Map.Entry) entryIterator.next();
		Hashtable hshField = (Hashtable) entry.getValue();
		String strName = (String) hshField.get("Name");
		
		if (strName.equals(BestCallingTimeURL)) {
			hshBestCallingTime  = (Hashtable) entry.getValue();
		}
	}

	String[][] BestCallingTimeOptions = (String[][])hshBestCallingTime.get(ECUserConstants.EC_RB_OPTIONS);


	if (format == null) 
	{
	   format = (Hashtable)XMLUtil.get(formats, "nlsFormats.default");
	} 

    
	String userProfile = null;
   
        UIUtil convert = null;
      
%>   
<HTML>

<head><title><%= userNLS.get("Contact") %></title>
<LINK rel="stylesheet" href="<%=UIUtil.getCSSFile(cmdContext.getLocale())%>">
<SCRIPT SRC="/wcs/javascript/tools/csr/user.js"></SCRIPT>
<SCRIPT SRC="<%=webalias%>javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT>

function isTrue(v)
{
	return (v=="1")?true:false;
}


function isStateChanged()
{
	return parent.get("changesMade");
}

function displayValidationError()
{
}

function initializeState()
{
   if ("<%=UIUtil.toJavaScript(orgEntityId)%>" != null || "<%=UIUtil.toJavaScript(orgEntityId)%>" != '') {
      
      document.contact.email1.value  = "<%=UIUtil.toJavaScript(bnOrgEntity.getAttribute(ECUserConstants.EC_ADDR_EMAIL1))%>";
      document.contact.email2.value    = "<%=UIUtil.toJavaScript(bnOrgEntity.getAttribute(ECUserConstants.EC_ADDR_EMAIL2))%>";
      document.contact.phone1.value    = "<%=UIUtil.toJavaScript(bnOrgEntity.getAttribute(ECUserConstants.EC_ADDR_PHONE1))%>";
      document.contact.phone2.value   = "<%=UIUtil.toJavaScript(bnOrgEntity.getAttribute(ECUserConstants.EC_ADDR_PHONE2))%>";
      document.contact.fax1.value  = "<%=UIUtil.toJavaScript(bnOrgEntity.getAttribute(ECUserConstants.EC_ADDR_FAX1))%>";
      document.contact.fax2.value  = "<%=UIUtil.toJavaScript(bnOrgEntity.getAttribute(ECUserConstants.EC_ADDR_FAX2))%>";
      
		<%
      if (showPhoneType.equals("true"))
      {
      %>
         for ( var i=0; i < document.contact.phone1Type.length; i++ )
         {
           if ( document.contact.phone1Type.options[i].value == "<%=UIUtil.toJavaScript(bnOrgEntity.getAttribute(ECUserConstants.EC_ADDR_PUBLISHPHONE1))%>")
           {
              document.contact.phone1Type.options[i].selected = true;
              break;
           }
         }
         for ( var i=0; i < document.contact.phone2Type.length; i++ )
         {
            if ( document.contact.phone2Type.options[i].value == "<%=UIUtil.toJavaScript(bnOrgEntity.getAttribute(ECUserConstants.EC_ADDR_PUBLISHPHONE2))%>")
            {
               document.contact.phone2Type.options[i].selected = true;
               break;
            }
         }
      <%
      }

      if (showPhoneListed.equals("true")) {
      %>
         if (parent.get("phone1Listed") == "1")
            document.contact.phone1Listed.checked = true;
         else
            document.contact.phone1Listed.checked = false;
         if (parent.get("phone2Listed") == "1")
            document.contact.phone2Listed.checked = true;
         else
            document.contact.phone2Listed.checked = false;
      <%
      }
      %>

      
      for (var i=0; i< document.contact.bestTimeToCall.length; i++)
      {
         if (document.contact.bestTimeToCall.options[i].value == "<%=UIUtil.toJavaScript(bnOrgEntity.getAttribute(ECUserConstants.EC_ADDR_BESTCALLINGTIME))%>")
         {
            document.contact.bestTimeToCall.options[i].selected = true;
            break;
         }
      }
   }

   
   if (parent.get("<%=ECUserConstants.EC_ADDR_EMAIL1%>") != null) 
      document.contact.email1.value = parent.get("<%=ECUserConstants.EC_ADDR_EMAIL1%>");
   if (parent.get("<%=ECUserConstants.EC_ADDR_EMAIL2%>") != null) 
      document.contact.email2.value = parent.get("<%=ECUserConstants.EC_ADDR_EMAIL2%>");
   if (parent.get("<%=ECUserConstants.EC_ADDR_PHONE1%>") != null) 
      document.contact.phone1.value = parent.get("<%=ECUserConstants.EC_ADDR_PHONE1%>");
   if (parent.get("<%=ECUserConstants.EC_ADDR_PHONE2%>") != null) 
      document.contact.phone2.value = parent.get("<%=ECUserConstants.EC_ADDR_PHONE2%>");
   if (parent.get("<%=ECUserConstants.EC_ADDR_FAX1%>") != null) 
      document.contact.fax1.value = parent.get("<%=ECUserConstants.EC_ADDR_FAX1%>");
   if (parent.get("<%=ECUserConstants.EC_ADDR_FAX2%>") != null) 
      document.contact.fax2.value = parent.get("<%=ECUserConstants.EC_ADDR_FAX2%>");
      
     <%
      if (showPhoneType.equals("true"))
      {
      %>
      var dbPhone1Type = "";
      var dbPhone2Type = "";

      for ( var i=0; i < document.contact.phone1Type.length; i++ )
      {
         if ( document.contact.phone1Type.options[i].value == dbPhone1Type )
         {
         	document.contact.phone1Type.options[i].selected = true;
            break;
         }
      }
      for ( var i=0; i < document.contact.phone2Type.length; i++ )
      {
         if ( document.contact.phone2Type.options[i].value == dbPhone2Type )
         {
            document.contact.phone2Type.options[i].selected = true;
            break;
         }
      }
      <%
      }

      if (showPhoneListed.equals("true")) {
      %>
      var dbPhone1Listed = "";
      var dbPhone2Listed = "";

      if (dbPhone1Listed == "1")
         document.contact.phone1Listed.checked = true;
      else
         document.contact.phone1Listed.checked = false;

      if (dbPhone2Listed == "1")
         document.contact.phone2Listed.checked = true;
      else
         document.contact.phone2Listed.checked = false;
      <%
      }
      %>

      

      if (parent.get("<%=ECUserConstants.EC_ADDR_BESTCALLINGTIME%>") != null) {
      var dbBestTimeToCall = parent.get("<%=ECUserConstants.EC_ADDR_BESTCALLINGTIME%>");
      for (var i=0; i< document.contact.bestTimeToCall.length; i++)
      {
         if (document.contact.bestTimeToCall.options[i].value == dbBestTimeToCall)
         {
      	   document.contact.bestTimeToCall.options[i].selected = true;
            break;
         }
      }
      }
   
   

	parent.setContentFrameLoaded(true);  
}


function savePanelData()
{
     if (parent.get("missingEmail1") == null) 
	   parent.put("missingEmail1", "<%=UIUtil.toJavaScript((String)userNLS.get("missingEmail1"))%>");
	if (parent.get("missingEmail2") == null)
	   parent.put("missingEmail2", "<%=UIUtil.toJavaScript((String)userNLS.get("missingEmail2"))%>");
	if (parent.get("missingPhone1") == null)
	   parent.put("missingPhone1", "<%=UIUtil.toJavaScript((String)userNLS.get("missingPhone1"))%>");
	if (parent.get("missingPhone2") == null)
	   parent.put("missingPhone2", "<%=UIUtil.toJavaScript((String)userNLS.get("missingPhone2"))%>");
   
 
   var selected;
   parent.put("<%=ECUserConstants.EC_ADDR_EMAIL1%>", document.contact.email1.value);
   parent.put("<%=ECUserConstants.EC_ADDR_EMAIL2%>", document.contact.email2.value);
   parent.put("<%=ECUserConstants.EC_ADDR_PHONE1%>", document.contact.phone1.value);
   parent.put("<%=ECUserConstants.EC_ADDR_PHONE2%>", document.contact.phone2.value);
   parent.put("<%=ECUserConstants.EC_ADDR_FAX1%>", document.contact.fax1.value);
   parent.put("<%=ECUserConstants.EC_ADDR_FAX2%>", document.contact.fax2.value);

   <%
   if (showPhoneType.equals("true"))
   {
   %>
      selected = document.contact.phone1Type.selectedIndex;
      parent.put("<%=ECUserConstants.EC_ADDR_EMAIL1%>", document.contact.phone1Type.options[selected].value);
      selected = document.contact.phone2Type.selectedIndex;
      parent.put("<%=ECUserConstants.EC_ADDR_EMAIL1%>", document.contact.phone2Type.options[selected].value);
   <%
   }

   if (showPhoneListed.equals("true")) 
   {
   %>
   	if (document.contact.phone1Listed.checked == true)
	      parent.put("<%=ECUserConstants.EC_ADDR_PUBLISHPHONE1%>", "1");
	   else
	      parent.put("<%=ECUserConstants.EC_ADDR_PUBLISHPHONE1%>", "0");
	   	
   	if (document.contact.phone2Listed.checked == true)
	      parent.put("<%=ECUserConstants.EC_ADDR_PUBLISHPHONE2%>", "1");
	   else
	      parent.put("<%=ECUserConstants.EC_ADDR_PUBLISHPHONE2%>", "0");
	   		   	
   <%
   }
   %>

   selected = document.contact.bestTimeToCall.selectedIndex;
   parent.put("<%=ECUserConstants.EC_ADDR_BESTCALLINGTIME%>", document.contact.bestTimeToCall.options[selected].value);

	
   // return true;


}

function validatePanelData() 
{
	return displayValidationError();
}

function validateNoteBookPanel() 
{
	return validatePanelData();
}

</SCRIPT>

</HEAD>
<BODY CLASS="content" onLoad="initializeState();">
<FORM name="contact">
<h1><%= UIUtil.toHTML( (String)userNLS.get("Contact") ) %></h1>
<TABLE border="0" cellpadding="0" cellspacing="0">
  <TR><TH></TH></TR>
  <TBODY>
          <TR>
            <TD valign="bottom"><label for="email11"><%= UIUtil.toHTML((String)userNLS.get("email1")) %></label><BR>
            <INPUT size="30" type="text" name="email1" maxlength="254" id="email11"></TD>
	                
          </TR>
          <TR>
             <TD valign="bottom" ><label for="email21"><%= UIUtil.toHTML((String)userNLS.get("email2")) %></label><BR>
             <INPUT size="30" type="text" name="email2" maxlength="254" id="email21"></TD>
          </TR>
          

    <TR>
      
            <TD valign="bottom"><label for="phone11"><%= UIUtil.toHTML((String)userNLS.get("phone1")) %><label><BR>
            <INPUT size="30" type="text" name="phone1" maxlength="32" id="phone11"></TD>
<%          if (showPhoneType.equals("true")) {
%>            <TD valign="bottom">
              <label for="phone1Type1"><%= UIUtil.toHTML((String)userNLS.get("type")) %></label><BR>
              <SELECT name="phone1Type" id="phone1Type1">
              <OPTION value="" selected></OPTION>
					
              </SELECT></TD>
<%          }
            if (showPhoneListed.equals("true")) {
%>           <TD valign="bottom">
              <INPUT type="checkbox" name="phone1Listed" value="1" id="phone1Listed1"><label for="phone1Listed1"><%= UIUtil.toHTML((String)userNLS.get("listed")) %></label></TD>
<%          }
%>        </TR>
          <TR>
            <TD valign="bottom"><label for="phone21"><%= UIUtil.toHTML((String)userNLS.get("phone2")) %></label><BR>
            <INPUT size="30" type="text" name="phone2" maxlength="32" id="phone21"></TD>
<%          if (showPhoneType.equals("true")) {
%>            <TD valign="bottom">
              <label for="phone2Type1"><%= UIUtil.toHTML((String)userNLS.get("type")) %></label><BR>
              <SELECT name="phone2Type" id="phone2Type1">
              <OPTION value="" selected></OPTION>
					
              </SELECT></TD>
<%          }
            if (showPhoneListed.equals("true")) {
%>            <TD valign="bottom">
              <INPUT type="checkbox" name="phone2Listed" value="1" id="phone2Listed1"><label for="phone2Listed1"><%= UIUtil.toHTML((String)userNLS.get("listed")) %></label></TD>
<%          }
%>        </TR>
        
      
          <TR>
            <TD valign="bottom"><label for="fax11"><%= UIUtil.toHTML((String)userNLS.get("fax1")) %></label><BR>
            <INPUT size="30" type="text" name="fax1" maxlength="32" id="fax11"></TD>
                       
          </TR>
          <TR>
            <TD valign="bottom"><label for="fax21"><%= UIUtil.toHTML((String)userNLS.get("fax2")) %></label><BR>
            <INPUT size="30" type="text" name="fax2" maxlength="32" id="fax21"></TD>
          </TR>
          <TR>
            <TD colspan=2 valign="bottom"><label for="bestTimeToCall1"><%= UIUtil.toHTML((String)userNLS.get("bestTimeToCall")) %></label><BR>
            <SELECT name="bestTimeToCall" id="bestTimeToCall1">
            <OPTION value="" selected><%= UIUtil.toHTML((String)userNLS.get("notProvided")) %></OPTION>
				<%	if (BestCallingTimeOptions != null) {
						for (int i = 0; i < BestCallingTimeOptions.length; i ++) { %>
							<OPTION  VALUE="<%= UIUtil.toHTML( BestCallingTimeOptions[i][0] ) %>">
							<%= UIUtil.toHTML( BestCallingTimeOptions[i][1] ) %></OPTION>
					<%	} 
					} %>
            </SELECT></TD>
          </TR>
          
   
  </TBODY>
</TABLE>
</FORM>
<%
} catch (Exception e)
{
	e.printStackTrace();
}
%>

</BODY>
</HTML>




