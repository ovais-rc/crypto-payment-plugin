
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

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
            com.ibm.commerce.tools.xml.*,
            com.ibm.commerce.usermanagement.commands.ECUserConstants,
	    com.ibm.commerce.user.beans.*"
    
%>

<%@include file="../common/common.jsp" %>

<%
try
{
	String userId = request.getParameter("shrfnbr");
	String webalias = UIUtil.getWebPrefix(request);
		
	CommandContext cmdContext = (CommandContext)request.getAttribute("CommandContext");
	Hashtable userNLS = (Hashtable)ResourceDirectory.lookup("buyerconsole.BuyAdminConsoleNLS", cmdContext.getLocale());	
	
	Locale cmdLocale = cmdContext.getLocale();
	String locale = cmdLocale.toString();
	String userProfile = null;
   
            
        UserRegistrationDataBean userBean = new UserRegistrationDataBean();  
        String memberId2 = request.getParameter("memberId");
        if(!(memberId2 == null || memberId2.trim().length()==0)) 
        {
           userBean.setDataBeanKeyMemberId(memberId2);
           com.ibm.commerce.beans.DataBeanManager.activate(userBean, request);
        }
    
	Hashtable formats = (Hashtable)ResourceDirectory.lookup("buyerconsole.nlsFormats");
	Hashtable format = (Hashtable)XMLUtil.get(formats, "nlsFormats."+ locale);
        if (format == null) 
        {
          format = (Hashtable)XMLUtil.get(formats, "nlsFormats.default");
        } 

	String showPhoneType = "false";  //(String)XMLUtil.get(format, "phoneType.show");
	String showPhoneListed = "false";  //(String)XMLUtil.get(format, "phoneListed.show");

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
	String PreferredCommunicationURL = userBean.getPreferredCommunicationURL();
	String BestCallingTimeURL = userBean.getBestCallingTimeURL();
		
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

    
	
	
	
      
%>   
<html xmlns="http://www.w3.org/1999/xhtml">

<head>
<title><%= userNLS.get("Contact") %></title>
<link rel="stylesheet" href="<%=UIUtil.getCSSFile(cmdContext.getLocale())%>" />
<script type="text/javascript"  src="/wcs/javascript/tools/csr/user.js"></script>
<script type="text/javascript"  src="<%=webalias%>javascript/tools/common/Util.js"></script>
<script type="text/javascript" >

function isTrue(v)
{
	return (v=="1")?true:false;
}

function compare()
{

}


function setStateChanged()
{

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
   
	
   if ("<%=UIUtil.toJavaScript(memberId2)%>" != null || "<%=UIUtil.toJavaScript(memberId2)%>" != '') {
      
      document.contact.email1.value  = "<%=UIUtil.toJavaScript(userBean.getEmail1())%>";
      document.contact.email2.value    = "<%=UIUtil.toJavaScript(userBean.getEmail2())%>";
      document.contact.phone1.value    = "<%=UIUtil.toJavaScript(userBean.getPhone1())%>";
      document.contact.phone2.value   = "<%=UIUtil.toJavaScript(userBean.getPhone2())%>";
      document.contact.fax1.value  = "<%=UIUtil.toJavaScript(userBean.getFax1())%>";
      document.contact.fax2.value  = "<%=UIUtil.toJavaScript(userBean.getFax2())%>";
      
      
      for ( var i=0; i < document.contact.preferredCommunication.length ; i++ )
      {
	      if ( document.contact.preferredCommunication.options[i].value == "<%=UIUtil.toJavaScript(userBean.getPreferredCommunication())%>")
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
           if ( document.contact.phone1Type.options[i].value == "<%=UIUtil.toJavaScript(userBean.getPhone1Type())%>")
           {
              document.contact.phone1Type.options[i].selected = true;
              break;
           }
         }
         for ( var i=0; i < document.contact.phone2Type.length; i++ )
         {
            if ( document.contact.phone2Type.options[i].value == "<%=UIUtil.toJavaScript(userBean.getPhone2Type())%>")
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
         if (document.contact.bestTimeToCall.options[i].value == "<%=UIUtil.toJavaScript(userBean.getBestCallingTime())%>")
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
      
   
  if (parent.get("<%=ECUserConstants.EC_UPROF_PREFERREDCOMMUNICATION%>") != null) {
      var dbPreferedMethod = parent.get("<%=ECUserConstants.EC_UPROF_PREFERREDCOMMUNICATION%>");
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
   parent.put("<%=ECUserConstants.EC_UPROF_PREFERREDCOMMUNICATION%>", document.contact.preferredCommunication.options[selected].value);

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

	
   setStateChanged();
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

</script>

</head>
<body class="content" onload="initializeState();">
<form action="" name="contact">
<h1><%= UIUtil.toHTML( (String)userNLS.get("Contact") ) %></h1>
<table border="0" cellpadding="0" cellspacing="0">
  <tr><th></th></tr>
  <tbody>
    
          <tr>
            <td valign="bottom"><label for="preferredCommunication1"><%= UIUtil.toHTML((String)userNLS.get("preferredCommunication")) %></label><br />
            <select name="preferredCommunication" id="preferredCommunication1">
            <option value="" selected="selected"><%= UIUtil.toHTML((String)userNLS.get("notProvided")) %></option>
				<%	if (PreferredCommunicationOptions != null) {
						for (int i = 0; i < PreferredCommunicationOptions.length; i ++) { %>
							<option  value="<%= UIUtil.toHTML(PreferredCommunicationOptions[i][0]) %>">
							<%= UIUtil.toHTML(PreferredCommunicationOptions[i][1]) %></option>
				<%		} 
					} %>
            </select></td>
            <td></td>
          </tr>
          <tr>
            <td valign="bottom"><label for="email11"><%= UIUtil.toHTML((String)userNLS.get("email1")) %></label><br />
            <input size="30" type="text" name="email1" maxlength="254" id="email11" /></td>
	                
          </tr>
          <tr>
             <td valign="bottom" ><label for="email21"><%= UIUtil.toHTML((String)userNLS.get("email2")) %></label><br />
             <input size="30" type="text" name="email2" maxlength="254" id="email21" /></td>
          </tr>
          

    <tr>
      
            <td valign="bottom"><label for="phone11"><%= UIUtil.toHTML((String)userNLS.get("phone1")) %></label><br />
            <input size="30" type="text" name="phone1" maxlength="32" id="phone11" /></td>
<%          if (showPhoneType.equals("true")) {
%>            <td valign="bottom">
              <label for="phone1Type1"><%= UIUtil.toHTML((String)userNLS.get("type")) %></label><br />
              <select name="phone1Type" id="phone1Type1">
              <option value="" selected="selected"></option>
					
              </select></td>
<%          }
            if (showPhoneListed.equals("true")) {
%>           <td valign="bottom">
              <input type="checkbox" name="phone1Listed" value="1" id="phone1Listed1" /><label for="phone1Listed1"><%= UIUtil.toHTML((String)userNLS.get("listed")) %></label></td>
<%          }
%>        </tr>
          <tr>
            <td valign="bottom"><label for="phone21"><%= UIUtil.toHTML((String)userNLS.get("phone2")) %></label><br />
            <input size="30" type="text" name="phone2" maxlength="32" id="phone21" /></td>
<%          if (showPhoneType.equals("true")) {
%>            <td valign="bottom">
              <label for="phone2Type1"><%= UIUtil.toHTML((String)userNLS.get("type")) %></label><br />
              <select name="phone2Type" id="phone2Type1">
              <option value="" selected="selected"></option>
					
              </select></td>
<%          }
            if (showPhoneListed.equals("true")) {
%>            <td valign="bottom">
              <input type="checkbox" name="phone2Listed" value="1" id="phone2Listed1" /><label for="phone2Listed1"><%= UIUtil.toHTML((String)userNLS.get("listed")) %></label></td>
<%          }
%>        </tr>
        
      
          <tr>
            <td valign="bottom"><label for="fax11"><%= UIUtil.toHTML((String)userNLS.get("fax1")) %></label><br />
            <input size="30" type="text" name="fax1" maxlength="32" id="fax11" /></td>
                       
          </tr>
          <tr>
            <td valign="bottom"><label for="fax21"><%= UIUtil.toHTML((String)userNLS.get("fax2")) %></label><br />
            <input size="30" type="text" name="fax2" maxlength="32" id="fax21" /></td>
          </tr>
          <tr>
            <td colspan="2" valign="bottom"><label for="bestTimeToCall1"><%= UIUtil.toHTML((String)userNLS.get("bestTimeToCall")) %></label><br />
            <select name="bestTimeToCall" id="bestTimeToCall1">
            <option value="" selected="selected"><%= UIUtil.toHTML((String)userNLS.get("notProvided")) %></option>
				<%	if (BestCallingTimeOptions != null) {
						for (int i = 0; i < BestCallingTimeOptions.length; i ++) { %>
							<option  value="<%= UIUtil.toHTML(BestCallingTimeOptions[i][0]) %>">
							<%= UIUtil.toHTML(BestCallingTimeOptions[i][1]) %></option>
				<%		} 
					}%>
            </select></td>
          </tr>
          
   
  </tbody>
</table>
</form>
<%
} catch (Exception e)
{
	e.printStackTrace();
}
%>

</body>
</html>




