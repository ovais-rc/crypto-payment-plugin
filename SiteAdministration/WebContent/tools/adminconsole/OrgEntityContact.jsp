
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2000, 2013 All Rights Reserved.

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
	Hashtable userNLS = (Hashtable)ResourceDirectory.lookup("adminconsole.OrgEntityNLS", cmdContext.getLocale());	
	String webalias = UIUtil.getWebPrefix(request);
	
	String userId = request.getParameter("shrfnbr");
	// String storeId = request.getParameter("storeId");
	// String addressId = request.getParameter(ECConstants.EC_ADDR_REFNUM);
	Locale cmdLocale = cmdContext.getLocale();
	String locale = cmdLocale.toString();
    
	Hashtable formats = (Hashtable)ResourceDirectory.lookup("adminconsole.nlsFormats");
	Hashtable format = (Hashtable)XMLUtil.get(formats, "nlsFormats."+ locale);
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
	bnResourceBundle.setPropertyFileName("UserRegistration_" + locale);
	DataBeanManager.activate(bnResourceBundle, request);


	// for drop-down list options
	String PreferredCommunicationURL = ECUserConstants.EC_UPROF_PREFERREDCOMMUNICATION;
	String BestCallingTimeURL = ECUserConstants.EC_ADDR_BESTCALLINGTIME;
		
	Hashtable hshPreferredCommunication = new Hashtable();
	Hashtable hshBestCallingTime  = new Hashtable();
	
	SortedMap smpFields = bnResourceBundle.getPropertySortedMap();
	Iterator entryIterator = smpFields.entrySet().iterator();
	Map.Entry textentry = (Map.Entry) entryIterator.next();
	Hashtable hshText = (Hashtable) textentry .getValue();
	
	while (entryIterator.hasNext()) {
		Map.Entry entry = (Map.Entry) entryIterator.next();
		Hashtable hshField = (Hashtable) entry.getValue();
		String strName = (String) hshField.get("Name");
		
		if (strName.equals(PreferredCommunicationURL)) {
			hshPreferredCommunication  = (Hashtable) entry.getValue();
		}
		if (strName.equals(BestCallingTimeURL)) {
			hshBestCallingTime  = (Hashtable) entry.getValue();
		}
	}

	String[][] PreferredCommunicationOptions = (String[][])hshPreferredCommunication.get(ECUserConstants.EC_RB_OPTIONS);
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
<SCRIPT SRC="<%=webalias%>javascript/tools/csr/user.js"></SCRIPT>
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
	// check for errors from validation
	var mE1 = "missingEmail1";
	var mE2 = "missingEmail2";
	var mP1 = "missingPhone1";
	var mP2 = "missingPhone2";
	var iFM = "inputFieldMax";
	
	var index = document.contact.preferredCommunication.selectedIndex;
   	var code  = document.contact.preferredCommunication.options[index].value;
		
	//var code = parent.getErrorParams();
	if (code != null || code !="")
	{
		if (code == "E1")
		{
		    if (isEmpty(document.contact.email1.value)) {
			alertDialog("<%=UIUtil.toJavaScript((String)userNLS.get("missingEmail1"))%>");
			document.contact.email1.focus();
			return false;
		    }
		}
		else if (code == "E2")
		{
		    if (isEmpty(document.contact.email2.value)) {
			alertDialog("<%=UIUtil.toJavaScript((String)userNLS.get("missingEmail2"))%>");
			document.contact.email2.focus();
			return false;
		    }
		}
		else if (code == "P1")
		{
		    if (isEmpty(document.contact.phone1.value)) {
			alertDialog("<%=UIUtil.toJavaScript((String)userNLS.get("missingPhone1"))%>");
			document.contact.phone1.focus();
			return false;
		    }
		}
		else if (code == "P2")
		{
		    if (isEmpty(document.contact.phone2.value)) {
			alertDialog("<%=UIUtil.toJavaScript((String)userNLS.get("missingPhone2"))%>");
			document.contact.phone2.focus();			
			return false;
		    }
		} 
	}
}

function initializeState()
{
   if ("<%=UIUtil.toJavaScript(orgEntityId)%>" != null || "<%=UIUtil.toJavaScript(orgEntityId)%>" != '') {
      
      document.contact.email1.value  = "<%=bnOrgEntity.getAttribute(ECUserConstants.EC_ADDR_EMAIL1)%>";
      document.contact.email2.value    = "<%=bnOrgEntity.getAttribute(ECUserConstants.EC_ADDR_EMAIL2)%>";
      document.contact.phone1.value    = "<%=bnOrgEntity.getAttribute(ECUserConstants.EC_ADDR_PHONE1)%>";
      document.contact.phone2.value   = "<%=bnOrgEntity.getAttribute(ECUserConstants.EC_ADDR_PHONE2)%>";
      document.contact.fax1.value  = "<%=bnOrgEntity.getAttribute(ECUserConstants.EC_ADDR_FAX1)%>";
      document.contact.fax2.value  = "<%=bnOrgEntity.getAttribute(ECUserConstants.EC_ADDR_FAX2)%>";
      
      
      for ( var i=0; i < document.contact.preferredCommunication.length ; i++ )
      {
	      if ( document.contact.preferredCommunication.options[i].value == "<%=bnOrgEntity.getAttribute("preferredCommunication")%>")
         {
   	      document.contact.preferredCommunication[i].selected = true;
            break;
         }
      }
		<%
      if (showPhoneType.equals("true"))
      {
      %>
         for ( var i=0; i < document.contact.phone1Type.length; i++ )
         {
           if ( document.contact.phone1Type.options[i].value == "<%=bnOrgEntity.getAttribute(ECUserConstants.EC_ADDR_PUBLISHPHONE1)%>")
           {
              document.contact.phone1Type.options[i].selected = true;
              break;
           }
         }
         for ( var i=0; i < document.contact.phone2Type.length; i++ )
         {
            if ( document.contact.phone2Type.options[i].value == "<%=bnOrgEntity.getAttribute(ECUserConstants.EC_ADDR_PUBLISHPHONE2)%>")
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
         if (document.contact.bestTimeToCall.options[i].value == "<%=bnOrgEntity.getAttribute(ECUserConstants.EC_ADDR_BESTCALLINGTIME)%>")
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
      
   
   if (parent.get("preferredCommunication") != null) {
      var dbPreferedMethod = parent.get("preferredCommunication");
      for ( var i=0; i < document.contact.preferredCommunication.length; i++ )
      {
         if ( document.contact.preferredCommunication.options[i].value == dbPreferedMethod )
         {
      	   document.contact.preferredCommunication[i].selected = true;
            break;
         }
      }
   }
   
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
   selected = document.contact.preferredCommunication.selectedIndex;
   parent.put("preferredCommunication", document.contact.preferredCommunication.options[selected].value);

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
<BODY class="content" onLoad="initializeState();">
<FORM name="contact">
<h1><%= userNLS.get("Contact") %></h1>
<TABLE border="0" cellpadding="0" cellspacing="0">
  <TR><TH></TH></TR>
  <TBODY>
    
          <TR>
            <TD valign="bottom">
            <LABEL for="preferredCommunication1"><%=userNLS.get("preferredCommunication")%></LABEL><BR>
            <SELECT name="preferredCommunication" id="preferredCommunication1">
            <OPTION value="" selected><%=userNLS.get("notProvided")%></OPTION>
				<%	for (int i = 0; i < PreferredCommunicationOptions.length; i ++) { %>
				<OPTION  VALUE="<%= PreferredCommunicationOptions[i][0] %>">
				<%= PreferredCommunicationOptions[i][1] %></OPTION>
				<%	} %>
            </SELECT></TD>
            <TD></TD>
          </TR>
          <TR>
            <TD valign="bottom">
            <LABEL for="email1_1"><%=userNLS.get("email1")%></LABEL><BR>
            <INPUT size="30" type="text" name="email1" id="email1_1" maxlength="254"></TD>
	                
          </TR>
          <TR>
             <TD valign="bottom" >
             <LABEL for="email2_1"><%=userNLS.get("email2")%></LABEL><BR>
             <INPUT size="30" type="text" name="email2" id="email2_1" maxlength="254"></TD>
          </TR>
          

    <TR>
      
            <TD valign="bottom">
            <LABEL for="phone1_1"><%=userNLS.get("phone1")%></LABEL><BR>
            <INPUT size="30" type="text" name="phone1" id="phone1_1" maxlength="32"></TD>
<%          if (showPhoneType.equals("true")) {
%>            <TD valign="bottom">
              <LABEL for="phone1Type1"><%=userNLS.get("type")%></LABEL><BR>
              <SELECT name="phone1Type" id="phone1Type1">
              <OPTION value="" selected></OPTION>
					
              </SELECT></TD>
<%          }
            if (showPhoneListed.equals("true")) {
%>           <TD valign="bottom">
              <INPUT type="checkbox" name="phone1Listed" id="phone1Listed1" value="1"><LABEL for="phone1Listed1"><%=userNLS.get("listed")%><LABEL></TD>
<%          }
%>        </TR>
          <TR>
            <TD valign="bottom">
            <LABEL for="phone2_1"><%=userNLS.get("phone2")%></LABEL><BR>
            <INPUT size="30" type="text" name="phone2" id="phone2_1" maxlength="32"></TD>
<%          if (showPhoneType.equals("true")) {
%>            <TD valign="bottom">
              <LABEL for="phone2Type1"><%=userNLS.get("type")%></LABEL><BR>
              <SELECT name="phone2Type" id="phone2Type1">
              <OPTION value="" selected></OPTION>
					
              </SELECT></TD>
<%          }
            if (showPhoneListed.equals("true")) {
%>            <TD valign="bottom">
              <INPUT type="checkbox" name="phone2Listed" id="phone2Listed1"value="1"><LABEL for="phone2Listed1"><%=userNLS.get("listed")%></LABEL></TD>
<%          }
%>        </TR>
        
      
          <TR>
            <TD valign="bottom">
            <LABEL for="fax1_1"><%=userNLS.get("fax1")%></LABEL><BR>
            <INPUT size="30" type="text" name="fax1" id="fax1_1" maxlength="32"></TD>
                       
          </TR>
          <TR>
            <TD valign="bottom">
            <LABEL for="fax2_1"><%=userNLS.get("fax2")%></LABEL><BR>
            <INPUT size="30" type="text" name="fax2" id="fax2_1" maxlength="32"></TD>
          </TR>
          <TR>
            <TD colspan=2 valign="bottom">
            <LABEL for="bestTimeToCall1"><%=userNLS.get("bestTimeToCall")%></LABEL><BR>
            <SELECT name="bestTimeToCall" id="bestTimeToCall1">
            <OPTION value="" selected><%=userNLS.get("notProvided")%></OPTION>
				<%	for (int i = 0; i < BestCallingTimeOptions.length; i ++) { %>
				<OPTION  VALUE="<%= BestCallingTimeOptions[i][0] %>">
				<%= BestCallingTimeOptions[i][1] %></OPTION>
				<%	} %>
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




