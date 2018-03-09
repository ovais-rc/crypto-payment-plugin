<!--  
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2000, 2016
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
-->
<%@ page language="java" %>

<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.base.objects.*"   %>
<%@ page import="com.ibm.commerce.beans.*" %>
<%@ page import="com.ibm.commerce.command.*" %>
<%@ page import="com.ibm.commerce.datatype.*" %>
<%@ page import="com.ibm.commerce.server.*" %>
<%@ page import="com.ibm.commerce.user.beans.*"   %>
<%@ page import="com.ibm.commerce.user.objects.*"   %>
<%@ page import="com.ibm.commerce.common.beans.*" %>
<%@ page import="com.ibm.commerce.usermanagement.commands.ECUserConstants" %>
<%@ page import="com.ibm.commerce.member.constants.ECMemberConstants" %>

<%@ include file="../common/common.jsp" %>
<%@include file="../common/List.jsp" %>

<%

// Set Command Context
CommandContext cmdContext = (CommandContext)request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
Locale locale = cmdContext.getLocale();
String webalias = UIUtil.getWebPrefix(request);

// obtain the resource bundle for display
Hashtable securityNLS = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("adminconsole.SecurityNLS", locale);


PolicyAccountLockoutDataBean palab = new PolicyAccountLockoutDataBean();
palab.setCommandContext(cmdContext);

Vector accLckList = palab.getPolicyAccLck();

int numberOfAccPol = accLckList.size();
   
PolicyAccountDataBean padb = new PolicyAccountDataBean();
padb.setCommandContext(cmdContext);

Vector accPolList = padb.getPolicyAcct();   

   

%>  

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
<HTML>
<HEAD>
<%= fHeader%>
<LINK rel=stylesheet href="<%=UIUtil.getCSSFile(cmdContext.getLocale())%>" type="text/css">

<TITLE><%= UIUtil.toHTML((String)securityNLS.get("acctLckPolicy")) %></TITLE>

<SCRIPT LANGUAGE="JavaScript">
<!---- hide script from old browsers

function getResultsSize() { 
     return <%= numberOfAccPol  %>; 
}


    function newRole()
    {
      var url = top.getWebappPath() + "DialogView?XMLFile=adminconsole.AccLckPolDialog";
      if (top.setContent)
      {
        top.setContent("<%= UIUtil.toJavaScript((String)securityNLS.get("newAcctLckPolicy")) %>",
                       url,
                       true);
        parent.location.replace(url);               
      }
      else
      {
        
        parent.location.replace(url);
      }
    }

    function changeRole()
    {
      var changed = 0;
      var accLckId = 0;
      
      if (arguments.length > 0)
      {
        accLckId = arguments[0];
        changed = 1;
      }
      else
      {
        var checked = parent.getChecked();
        if (checked.length > 0)
        {
          
          
          accLckId = checked[0];
          changed = 1; 
        }
      }
      if (changed != 0)
      {
        var url = top.getWebappPath() + "DialogView?XMLFile=adminconsole.AccLckPolEditDialog";
        url += "&accLckId=" + accLckId;
        if (top.setContent)
        {
          top.setContent("<%= UIUtil.toJavaScript((String)securityNLS.get("changeAcctLckPolicy")) %>",
                         url,
                         true);
        }
        else
        {
          parent.location.replace(url);
        }
      } 
    }
    
    
function deleteRole() {

	var checked = parent.getChecked();
	var deleteId = '';
	var count = 0;

        for (var j=0; j < checked.length; j++) {
        
	<% for (int i=0; i < accPolList.size(); i++) {
		Vector temp = (Vector) accPolList.elementAt(i);
		String alpId = (String) temp.elementAt(3);
		String name = (String) temp.elementAt(2);
	%>
		
		var x = '<%=alpId%>';
		if (x == checked[j]) {
			alert("<%= UIUtil.toJavaScript((String)securityNLS.get("policyInUse")) %>".replace(/%1/, '<%=UIUtil.toJavaScript(name)%>'));
			continue;
		}
		
	<%}%>
	
	if (count == 0 ) deleteId = checked[j];
	else deleteId = deleteId + "," + checked[j];
	count++;
	
	}
	
	
	
	var redirectURL = top.getWebappPath() + "NewDynamicListView?ActionXMLFile=adminconsole.AccLckPolList&amp;cmd=AccLckPolListView";
          var url = top.getWebappPath() + "AccountLockoutPolicyDelete?"
          			+ 'authToken=' + encodeURI('${authToken}')
                    + "&plcyacclck_id=" + deleteId
                    + "&redirecturl=" + redirectURL;
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



function showParent()
{
	alertDialog("show parent");
}

function showChildren()
{
	alertDialog("show children");
}

    function onLoad() 
    {
      parent.loadFrames();
    }

    function getRefNum() 
    {
      return <%= getRefNum() %>;
    }
// -->
</script>

<SCRIPT SRC="<%=webalias%>javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT SRC="<%=webalias%>javascript/tools/common/dynamiclist.js"></SCRIPT>

</HEAD>


<BODY ONLOAD="onLoad()" class="content">
<%
          int startIndex = Integer.parseInt(request.getParameter("startindex"));
          int listSize = Integer.parseInt(request.getParameter("listsize"));          
	  int endIndex = getStartIndex() + getListSize();
    	  if (endIndex > numberOfAccPol)
      		endIndex = numberOfAccPol;
          int totalsize = numberOfAccPol;
          int totalpage = totalsize/listSize;          
	
%>
<%=com.ibm.commerce.tools.common.ui.taglibs.comm.addControlPanel("adminconsole.AccLckPolList", totalpage, totalsize, cmdContext.getLocale() )%>

<FORM NAME="accPolForm" ACTION="AccLckPolListView" METHOD="POST">

<%=addHiddenVars()%>

<%= com.ibm.commerce.tools.common.ui.taglibs.comm.startDlistTable((String)securityNLS.get("acctLckPolicy")) %>
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.startDlistRowHeading() %>
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.addDlistCheckHeading() %>
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.addDlistColumnHeading((String)securityNLS.get("name"), null, false )%>
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.addDlistColumnHeading((String)securityNLS.get("accLckThresh"), null, false )%>
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.addDlistColumnHeading((String)securityNLS.get("accLckWaitTime"), null, false )%>
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.endDlistRow() %>



<!-- Need to have a for loop to lookfor all the member groups -->
<%
    int rowselect=1;
    for (int i=startIndex; i<endIndex ; i++) 
    {
      	Vector temp = (Vector) accLckList.elementAt(i);
   	String id = (String) temp.elementAt(0);
   	String lockThresh = (String) temp.elementAt(1);
   	String waitTime = (String) temp.elementAt(2);
   	String description = (String) temp.elementAt(3);
%>

<%= com.ibm.commerce.tools.common.ui.taglibs.comm.startDlistRow(rowselect) %>
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.addDlistCheck(id, "none" ) %>
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.addDlistColumn( UIUtil.toHTML(description), "javascript:changeRole('"+ id +"');" ) %> 
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.addDlistColumn( UIUtil.toHTML(lockThresh), null ) %> 
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.addDlistColumn( UIUtil.toHTML(waitTime), null ) %> 
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.endDlistRow() %>

<%
}
%>
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.endDlistTable() %>

</FORM>
<SCRIPT LANGUAGE="JavaScript">
<!--
          parent.afterLoads();
          parent.setResultssize(getResultsSize());

// -->
</SCRIPT>
</BODY>
</HTML>
