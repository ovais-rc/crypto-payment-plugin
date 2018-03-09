<%
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2001, 2002
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
//*
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
<HTML>

<%@ page import="javax.servlet.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.math.*" %>

<%@include file="../common/common.jsp" %>
<%@include file="../common/List.jsp" %>

<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.tools.common.ui.taglibs.*" %>
<%@ page import="com.ibm.commerce.beans.DataBeanManager" %>
<%@ page import="com.ibm.commerce.tools.util.ResourceDirectory" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.tools.xml.*" %>
<%@ page import="com.ibm.commerce.user.beans.UserAdminDataBean" %>
<%@ page import="com.ibm.commerce.user.beans.*" %>
<%@ page import="java.lang.*" %>
<%@ page import="com.ibm.commerce.tools.optools.user.beans.*" %>
<%@ page import="com.ibm.commerce.tools.optools.user.helpers.*" %>
<%@ page import="com.ibm.commerce.tools.optools.common.helpers.*" %>
<%@ page import="com.ibm.commerce.server.*" %>
<%@ page import="com.ibm.commerce.collaboration.livehelp.beans.LiveHelpConfiguration" %>
<%@ page import="com.ibm.commerce.tools.optools.user.beans.UserSearchDataBean" %>

<%@ page import="com.ibm.commerce.tools.test.*" %>

      <%
      String webalias = UIUtil.getWebPrefix(request);
      try {
        CommandContext cmdContext = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
        Locale jLocale = cmdContext.getLocale();
        Hashtable userAdminListNLS = (Hashtable) ResourceDirectory.lookup("adminconsole.AdminConsoleNLS", jLocale);
      
        UserAdminDataBean userAdmins[] = null;
      int numberOfOrgUsers = 0;
      
        // obtain the resource bundle for display
      String adminTypeSstr = UIUtil.toHTML((String)userAdminListNLS.get("userAdminTypeS"));
      String adminTypeAstr = UIUtil.toHTML((String)userAdminListNLS.get("userAdminTypeA"));

      Long userId          = cmdContext.getUserId();
      String localeUsed       = cmdContext.getLocale().toString();
      JSPHelper jspHelper1       = new JSPHelper(request);

      String name          = jspHelper1.getParameter("name");
      String roleId        = jspHelper1.getParameter("roleId");
      String orgId         = jspHelper1.getParameter("orgId");
      String strStartIndex       = jspHelper1.getParameter("startindex");
   int    iStartIndex              = Integer.parseInt(request.getParameter("startindex"));
   String strListSize              = String.valueOf(iStartIndex);  // get the start Index from .xml file
      int    totalsize                = 0;
      
        if(strStartIndex == null || strStartIndex.equals("")) 
           strStartIndex = "0";

        if(orgId == null || orgId.equals("")) 
           orgId = "-2001";
   
         String sss = request.getParameter("refnum");

         Vector userIds = null;

         try {    
      UserSearchDataBean userSearchDB = new UserSearchDataBean();
      userSearchDB.setOrgId(orgId);
      userSearchDB.setRoleId(roleId);
      userSearchDB.setLastName(name);
      userSearchDB.setOrderBy("");
      userSearchDB.setStartIndex(strStartIndex);
      userSearchDB.setListSize(strListSize);
      userSearchDB.setBusinessSearch();
      userSearchDB.setCommandContext(cmdContext);
      userSearchDB.populate();
      userIds = userSearchDB.getUserIds();
   
      totalsize = userIds.size();            
         numberOfOrgUsers = totalsize;
         
      } catch (Exception e) {
      // we do not plan to process any exception(s) here
      }  

        String xmlFileParm = jspHelper1.getParameter("ActionXMLFile");
      Hashtable xmlTree = (Hashtable)ResourceDirectory.lookup(xmlFileParm);

      Hashtable localeNameFormat = (Hashtable)XMLUtil.get(xmlTree, "action.nlsNameFormats."+ localeUsed);
      if (localeNameFormat == null){
         localeNameFormat = (Hashtable)XMLUtil.get(xmlTree, "action.nlsNameFormats.default");
      }

   boolean displayLastNameFirst = false;

      int displayLastNamePos = 0;
      int displayFirstNamePos = 0;

      String nameFormatStr = (String)XMLUtil.get(localeNameFormat,"name.fields");
      if (nameFormatStr != null){
   
         String[] nameFormatFields = Util.tokenize(nameFormatStr, ",");

         for (int i=0; i < nameFormatFields.length; i++){

               if ( nameFormatFields[i].equals("lastName") )
                  displayLastNamePos = i;
               else if ( nameFormatFields[i].equals("firstName") )
                  displayFirstNamePos = i;
         } // end of inner "for" loop
         
         if (displayLastNamePos < displayFirstNamePos)
               displayLastNameFirst = true;
      } // end of "if"


          int startIndex = Integer.parseInt(request.getParameter("startindex"));
          int listSize = Integer.parseInt(request.getParameter("listsize"));
          int endIndex = startIndex + listSize;
          int rowselect = 1;
          int resultSize = Integer.parseInt(request.getParameter("resultsize"));

      %>


    <HEAD>
      <%= fHeader %>      
      <LINK rel=stylesheet href="<%=UIUtil.getCSSFile(cmdContext.getLocale())%>" type="text/css">      
      <SCRIPT SRC="<%=webalias%>javascript/tools/common/dynamiclist.js"></SCRIPT>

      <SCRIPT LANGUAGE="JavaScript">
        // Following will be the supporting JavaScript functions for the buttons on the right of panel

    function findUserAdmin(){

      var url = top.getWebappPath() + "DialogView?XMLFile=adminconsole.UserFind";

      if (top.setContent)
      {
        top.setContent("<%=UIUtil.toJavaScript((String)userAdminListNLS.get("find")) %>",
                       url,
                       true);
      }
      else
      {
        parent.location.replace(url);
      }
    }

    function newUserAdmin(){

      var url = top.getWebappPath() + "WizardView?XMLFile=adminconsole.UserWizard";

      if (top.setContent)
      {
        top.setContent("<%=UIUtil.toJavaScript((String)userAdminListNLS.get("newUser")) %>",
                       url,
                       true);
      }
      else
      {
        parent.location.replace(url);
      }
    }

    function changeUserAdmin(){

      var changed = 0;
      var userAdminId = 0;

      if (arguments.length > 0)
      {
        userAdminId = arguments[0];
        changed = 1;
      }
      else
      {
        var checked = parent.getChecked();
        if (checked.length > 0)
        {
          userAdminId = checked[0];
          changed = 1;
        }
      }
      if (changed != 0)
      {
        var url = top.getWebappPath() + "NotebookView?XMLFile=adminconsole.UserNotebook";
        url += "&memberId=" + userAdminId;
        if (top.setContent)
        {
          top.setContent("<%=UIUtil.toJavaScript((String)userAdminListNLS.get("changeUser")) %>",
                         url,
                         true);
        }
        else
        {
          parent.location.replace(url);
        }
      }
    }

    function deleteUserAdmin(){

      var userId = "<%= userId %>";
      var checked = parent.getChecked();

      if (checked.length > 0)
      {
        // check for default administrators and set up the delete list
        var administratorList = "";
        var errorFound = 0;
        for (var i = 0; (i<checked.length && errorFound==0); i++)
        {
          if ( (checked[i] < 0) || (checked[i] == userId) )
          {
            errorFound = 1;
            if (checked[i] < 0)
              alertDialog ("<%=UIUtil.toJavaScript((String)userAdminListNLS.get("userAdminListDefaultDeleteFailed"))%>");
            else
              alertDialog ("<%=UIUtil.toJavaScript((String)userAdminListNLS.get("userAdminListLogonDeleteFailed"))%>");
          }
          else
            administratorList += "&memberId=" + checked[i];
        }

        if ( (errorFound == 0) &&
             confirmDialog("<%=UIUtil.toJavaScript((String)userAdminListNLS.get("userAdminListDeleteConfirmation")) %>") )
        {
          // delete the administrators
          var redirectURL = top.getWebappPath() + "DynamicListSCView?cmd=AdminConUserAdminView&ActionXMLFile=adminconsole.UserAdminList&listsize=20&startindex=0&refnum=0";

          var url = "<%="UserAdminDelete?"%>"
                    + administratorList
                    + "&size=" + checked.length
                    + "&URL=" + redirectURL;
          if (top.setContent)
          {
            top.showContent(url);
            top.refreshBCT();
          }
          else
          {
            parent.location.replace(url);
          }
        }
      }
    }

    function rolesUserAdmin(){

      var changed = 0;
      var userAdminId = 0;

      if (arguments.length > 0)
      {
        userAdminId = arguments[0];
        changed = 1;
      }
      else
      {
        var checked = parent.getChecked();
        if (checked.length > 0)
        {
          userAdminId = checked[0];
          changed = 1;
        }
      }
      if (changed != 0)
      {
        var url = top.getWebappPath() + "DialogView?XMLFile=adminconsole.UserRoles";
        url += "&memberId=" + userAdminId;

        if (top.setContent)
        {
          top.setContent("<%=UIUtil.toJavaScript((String)userAdminListNLS.get("roles")) %>",
                         url,
                         true);
        }
        else
        {
          parent.location.replace(url);
        }
      }
    }

    function mbrgrpUserAdmin(){

      var changed = 0;
      var userAdminId = 0;

      if (arguments.length > 0)
      {
        userAdminId = arguments[0];
        changed = 1;
      }
      else
      {
        var checked = parent.getChecked();
        if (checked.length > 0)
        {
          userAdminId = checked[0];
          changed = 1;
        }
      }
      if (changed != 0)
      {
        var url = top.getWebappPath() + "DialogView?XMLFile=adminconsole.UserMbrGrp";
        url += "&memberId=" + userAdminId;
        if (top.setContent)
        {
          top.setContent("<%=UIUtil.toJavaScript((String)userAdminListNLS.get("userGeneralMbrGrp")) %>",
                         url,
                         true);
        }
        else
        {
          parent.location.replace(url);
        }
      }
    }

    // -- \/ \/ \/ --- LiveHelp
    function regCustCare(){
      
      if (parent.buttons.buttonForm.regCustCareButton.className =='disabled')
        return;   //df33144
        
      var changed = 0;
      var userAdminId = 0;

      if (arguments.length > 0)
      {
        userAdminId = arguments[0];
        changed = 1;
      }
      else
      {
        var checked = parent.getChecked();
        if (checked.length > 0)
        {
          userAdminId = checked[0];
          changed = 1;
        }
      }
      if (changed != 0)
      {
        var url = top.getWebappPath() + "DialogView?XMLFile=livehelp.liveHelpRegistration";
        url += "&memberId=" + userAdminId;
        if (top.setContent)
        {
          top.setContent("<%=UIUtil.toJavaScript((String)userAdminListNLS.get("regCustCare")) %>",
                         url,
                         true);
        }
        else
        {
          parent.location.replace(url);
        }
      }
    }
    // -- /\ /\ /\ --- LiveHelp
    // -- \/ \/ \/ --- LiveHelp
    function myRefreshButtons()
    {

      parent.refreshButtons();

      if(typeof parent.checkValueHashtable == "undefined")
        parent.checkValueHashtable = new Object();

      var theArray = new Array;
      var temp;

      for (var i=0; i<document.userAdminForm.elements.length; i++)
      {
          if (document.userAdminForm.elements[i].type == 'checkbox')
            if (document.userAdminForm.elements[i].checked)
               parent.checkValueHashtable[document.userAdminForm.elements[i].name] = document.userAdminForm.elements[i].value;
      }

      var temp2;
      var checked = new String(parent.getChecked());
      if(checked == "") return;

      temp2 = checked.split(",");
      for (var j = 0; j < temp2.length; j++)
      {
        theArray[j] = parent.checkValueHashtable[temp2[j]];
      }


      if (theArray.length == 1 )
      {
        temp_role = theArray[0];
        <% if (LiveHelpConfiguration.isEnabled()) { %>
		bCCDisabled=false;
        <%  } else { %>
		bCCDisabled=true;
        <% } %>

          // --------------------------------------------------------
          // Only the following roles allow to Register Customer Care
          //  -1 = Site Admin
          //  -3 = Customer Service Representative
          //  -4 = Seller
          // -12 = Operations Manager
          // -14 = Customer Service Supervisor
          // -18 = Sales Manager
          // --------------------------------------------------------
          if (bCCDisabled || "<%=LiveHelpConfiguration.getLdapType()%>"=="1" || !((temp_role.indexOf("[-1]") != -1) ||(temp_role.indexOf("[-3]") != -1) || (temp_role.indexOf("[-4]") != -1) ||
              (temp_role.indexOf("[-12]") != -1) || (temp_role.indexOf("[-14]") != -1) || (temp_role.indexOf("[-18]") != -1)))
          {
            if (defined(parent.buttons.buttonForm.regCustCareButton))
            {
              parent.buttons.buttonForm.regCustCareButton.disabled=false;
              parent.buttons.buttonForm.regCustCareButton.className='disabled';
              parent.buttons.buttonForm.regCustCareButton.id='disabled';
            }
          }
      }
    }
    // -- /\ /\ /\ --- LiveHelp


      </SCRIPT>

      <TITLE><%=UIUtil.toHTML((String)userAdminListNLS.get("administrators")) %></TITLE>

      <SCRIPT>

        function onLoad()
        {
          parent.loadFrames();
        }

        function getRefNum()
        {
          return parent.getChecked();
        }

        function getResultsSize(){
            return <%=numberOfOrgUsers%>;
        }

   function getUserNLSTitle(){
       return "<%=userAdminListNLS.get("administrators")%>"             
        }

      </SCRIPT>
      <SCRIPT SRC="<%=webalias%>javascript/tools/common/Util.js"></SCRIPT>
    </HEAD>

    <BODY class="content_list">

      <SCRIPT>
        <!--
        // For IE
        if (document.all) {
          onLoad();
        }
        //-->
      </SCRIPT>

    <%

     int totalpage = totalsize / listSize;

    %>
      <%=comm.addControlPanel("adminconsole.UserAdminList",totalpage,totalsize,jLocale)%>      
      <FORM NAME="userAdminForm">
      
        <%= comm.startDlistTable("AdminConsoleTableSumUserAdminList") %>
        <%= comm.startDlistRowHeading() %>
        <%= comm.addDlistCheckHeading() %>
        <%= comm.addDlistColumnHeading((String)userAdminListNLS.get("userAdminListLogonIdColumn"),"none",false ) %>

        <%
            if (displayLastNameFirst) {
        %>
        <%= comm.addDlistColumnHeading((String)userAdminListNLS.get("userAdminListLastNameColumn"),"none",false ) %>
        <%
            }
        %>
        
        <%= comm.addDlistColumnHeading((String)userAdminListNLS.get("userAdminListFirstNameColumn"),"none",false ) %>

        <%
            if (!displayLastNameFirst) {
        %>
        <%= comm.addDlistColumnHeading((String)userAdminListNLS.get("userAdminListLastNameColumn"),"none",false ) %>
        <%
            }
        %>
        
        <%= comm.addDlistColumnHeading((String)userAdminListNLS.get("userAdminFindOrg"),"none",false ) %>
        <%= comm.addDlistColumnHeading((String)userAdminListNLS.get("memberGroupRole"),"none",false ) %>        
        <%= comm.endDlistRow() %>
           

<!-- Need to have a for loop to look for all the member groups -->
        <%
      UserAdminDataBean userAdmin = null;

    
   endIndex = startIndex + listSize;
   
      if(endIndex > numberOfOrgUsers)
            endIndex = numberOfOrgUsers;
        
        
    for (int i=startIndex; i < endIndex; i++) {

    String id = (userIds.elementAt(i)).toString();
         UserRegistrationDataBean urdb = new UserRegistrationDataBean();
         urdb.setDataBeanKeyMemberId(id);
         urdb.setCommandContext(cmdContext);
         urdb.populate();

         String lastNameStr = urdb.getLastName();
         if (lastNameStr == null)
            lastNameStr = "";

         String firstNameStr = urdb.getFirstName();
         if (firstNameStr == null)
            firstNameStr = "";

         Integer[] rootRoles = urdb.getRoles();
         String roleNames = "";
         // added roleIDs --- LiveHelp
         String roleIDs = "";

         for (int j =0; j < rootRoles.length; j++) {

             RoleDataBean rdb = new RoleDataBean();
             rdb.setDataBeanKeyRoleId(rootRoles[j].toString());
             rdb.setCommandContext(cmdContext);
             rdb.populate();

             roleNames = roleNames + rdb.getName();
             // added roleIDs --- LiveHelp
             roleIDs = roleIDs + "[" + rootRoles[j].toString() + "]";
             if (j != (rootRoles.length - 1)) {
               roleNames = roleNames + ", ";
               // added roleIDs --- LiveHelp
               roleIDs = roleIDs + ", ";
             }

         }        


         String parentId = urdb.getParentMemberId();
         OrgEntityDataBean oedb2 = new OrgEntityDataBean();
         oedb2.setDataBeanKeyMemberId(parentId);
         oedb2.setCommandContext(cmdContext);
         oedb2.populate();

         String orgName = oedb2.getOrgEntityName();


         String adminTypeStr = null;
         if (urdb.getRegisterType().equals("S"))
         {
             adminTypeStr = adminTypeSstr;
         }
         else
         {
             adminTypeStr = adminTypeAstr;
         }
        
        
                          
          %>
        <%= comm.startDlistRow(Math.abs(i % 2) + 1) %>
        <%= comm.addDlistCheck(urdb.getUserId().trim(), "parent.setChecked();myRefreshButtons()", roleIDs.trim()) %>
        <%= comm.addDlistColumn(urdb.getLogonId(),"javascript:changeUserAdmin('" + urdb.getUserId().trim() + "')") %>

        <%
            if (displayLastNameFirst) {
        %>
        <%= comm.addDlistColumn(urdb.getLastName().trim(), "none") %>
        <%
        }
        %>
        
        <%= comm.addDlistColumn(urdb.getFirstName().trim(), "none") %>

        <%
            if (!displayLastNameFirst) {
        %>
        <%= comm.addDlistColumn(urdb.getLastName().trim(), "none") %>
        <%
        }
        %>

        <%= comm.addDlistColumn(orgName, "none") %>
        <%= comm.addDlistColumn(roleNames, "none") %>
        <%= comm.endDlistRow() %>
        
        <%
          }

      } catch (Exception e)   {

         com.ibm.commerce.exception.ExceptionHandler.displayJspException(request, response, e);
      }
    %>
        <%= comm.endDlistTable() %>

      </FORM>


      <SCRIPT LANGUAGE="JavaScript">
        
          parent.afterLoads();
          parent.setResultssize(getResultsSize());
          // --------------------------------------------------------
          // Hide the Register Customer Care button if liveHelp is not enable in the
          // instance.xml file
          // --------------------------------------------------------
          <%
          String liveHelpEnabled = WcsApp.configProperties.getValue("Collaboration/Sametime/enabled");
      if (!(liveHelpEnabled != null && liveHelpEnabled.compareTo("true") == 0))
          {
          %>
            parent.hideButton('regCustCare');
          <%
          }
          %>
          
          
      </SCRIPT>

    </BODY>

  </HTML>


