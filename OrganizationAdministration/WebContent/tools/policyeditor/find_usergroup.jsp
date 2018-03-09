<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2001, 2013 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.tools.common.ui.taglibs.*" %> 
<%@ page import="com.ibm.commerce.beans.*" %>
<%@ page import="com.ibm.commerce.datatype.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="com.ibm.commerce.command.*"%>
<%@ page import="com.ibm.commerce.*" %>
<%@ page import="com.ibm.commerce.exception.*" %>
<%@ page import="com.ibm.commerce.server.*" %>
<%@ page import="com.ibm.commerce.accesscontrol.policyeditor.util.*" %>
<%@ page import="com.ibm.commerce.accesscontrol.policyeditor.beans.*" %>

<%@include file="../common/common.jsp" %>

<%
try
{
%>

<HTML>
<HEAD>
<%= fHeader%>

<%        
   String userId = null;    
   Locale locale = null;
   String storeId = null;
   String lang = null;
   String sortby = null;
   String XMLFile = null;
   String resourceGroupId = null;
   String policyId = null;
   String ownerId = null;
                          
   CommandContext aCommandContext = (CommandContext)request.getAttribute("CommandContext"); 
      
         
   if( aCommandContext!= null )
   {
      locale = aCommandContext.getLocale();
      storeId = aCommandContext.getStoreId().toString();
      lang = aCommandContext.getLanguageId().toString();
      userId = aCommandContext.getUserId().toString();
   }

   resourceGroupId = (String) request.getParameter("resourceGroupId");
   XMLFile = (String) request.getParameter("XMLFile");
   policyId = (String) request.getParameter("policyId");
   ownerId = (String) request.getParameter("ownerId");
   
   // obtain the resource bundle for display
   Hashtable policyListNLS = (Hashtable)ResourceDirectory.lookup("policyeditor.policyeditorNLS", locale);      
%>

<link rel=stylesheet href="<%= UIUtil.getCSSFile(locale) %>" type="text/css">
<TITLE><%= UIUtil.toHTML((String)policyListNLS.get("userGroupSearchTitle")) %></TITLE>

<jsp:useBean id="memberGroupListBean" class="com.ibm.commerce.accesscontrol.policyeditor.beans.MemberGroupLightListBean" >
<jsp:setProperty property="*" name="memberGroupListBean" />
</jsp:useBean>

<%
   
   PolicySortingAttribute sort = new PolicySortingAttribute();
   
   sortby = request.getParameter("orderby");
   if ( sortby != null && !sortby.equals("null") && !sortby.equals("") ) 
   {
     sort.addSorting(sortby, true);
   }
   memberGroupListBean.setSortAtt( sort );
   
   com.ibm.commerce.beans.DataBeanManager.activate(memberGroupListBean, request);
   MemberGroupLightDataBean[] aList = memberGroupListBean.getMemberGroupBeans();
%>



<SCRIPT LANGUAGE="JavaScript">
<!---- hide script from old browsers


function getResultsSize() { 
     return <%= memberGroupListBean.getMemberGroupBeans().length %>; 
}


function onLoad() {
  parent.loadFrames();
}

function getXMLFile() {
     return "<%= UIUtil.toJavaScript(XMLFile) %>";
}

function getResourceGroupId() {
     return "<%= UIUtil.toJavaScript(resourceGroupId) %>";
}

function getPolicyId() {
     return "<%= UIUtil.toJavaScript(policyId) %>";
}

function getOwnerId() {
     return "<%= UIUtil.toJavaScript(ownerId) %>";
}

// This function is needed because the Framework keeps selected items from previous visits
function deSelectAll() 
{
  for (var i=0; i < document.findListForm.elements.length; i++) 
  {
     var e = document.findListForm.elements[i];
     if (e.type == 'checkbox' && e.name != 'select_deselect') 
     {
        parent.removeEntry(e.name);
     }	
  }
}

function doOK(checked)
{
 // The test for != "0" is necessary because it seems to treat "0" as ""
 if(checked == "" && checked != "0")
 {
    checked = parent.getChecked();
 }
 var userGroupId = "";
 if (checked.length > 0) {
	userGroupId = checked[0];
 }
 top.sendBackData(userGroupId, "POLICY_userGroupId");
 nam = "N" + checked;
 var x = "";
 for (i = 0; i < document.findListForm.elements.length; i++)
 {
   var e = document.findListForm.elements[i];
   if(e.type == "hidden" && e.name == nam)
   {
     x = e.value;
     break;
   }
  }
 top.sendBackData(x, "POLICY_userGroup");
 deSelectAll();
 top.mccbanner.removebct();
 parent.location.replace(
       top.getWebappPath() +'DialogView?XMLFile=' + getXMLFile() +
       "&amp;resourceGroupId=" + getResourceGroupId() + "&policyId=" + getPolicyId() +
       "&amp;ownerId=" + getOwnerId() + "&amp;fromFind=1")
}

function doCancel()
{
 if(!confirmDialog("<%= policyListNLS.get("userGroupCancelConfirmation") %>"))
 { return; }
 deSelectAll();
 top.mccbanner.removebct();
 parent.location.replace(
       top.getWebappPath() +'DialogView?XMLFile=' + getXMLFile() +
       "&amp;resourceGroupId=" + getResourceGroupId() + "&policyId=" + getPolicyId() +
       "&amp;ownerId=" + getOwnerId() + "&amp;fromFind=1")
}

// -->
</script>

<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/common/dynamiclist.js"></SCRIPT>

</HEAD>
<BODY class="content_list">
<SCRIPT LANGUAGE="JavaScript">
<!--
//For IE
if (document.all) {
    onLoad();
}
//-->
</SCRIPT>


<%
          int startIndex = Integer.parseInt(request.getParameter("startindex"));
          int listSize = Integer.parseInt(request.getParameter("listsize"));
          int endIndex = startIndex + listSize;
          if (endIndex > aList.length )
          {
            endIndex = aList.length;
          }
          int rowselect = 1;
          int totalsize = memberGroupListBean.getMemberGroupBeans().length;
          int totalpage = totalsize/listSize;
          // addControlPanel adds 1 to the page count which is ok unless the division doesn't result in a remainder
          if(totalsize == totalpage * listSize)
          {
            totalpage--;
          }
          String nul = null;
          int currentpage = (startIndex / listSize) + 1;
          String statusString = null;
          int status;
%>

<%= comm.addControlPanel("policyeditor.userGroupFind",totalpage,totalsize,locale) %>
<FORM NAME="findListForm" action="" method="POST">

<%= comm.startDlistTable(nul) %>
<%= comm.startDlistRowHeading() %>
<%= comm.addDlistCheckHeading() %>
<%= comm.addDlistColumnHeading((String)policyListNLS.get("userGroupHeader"), "none", false) %>
<%= comm.addDlistColumnHeading((String)policyListNLS.get("userGroupDescriptionHeader"), "none", false) %>
<%= comm.endDlistRow() %>
         
<%
  String nam = null;
  for (int i = startIndex; i < endIndex ; i++)
  {
    nam = "N" + aList[i].getMemberGroupId().toString();
%>
    <INPUT TYPE="HIDDEN" NAME="<%= nam %>" VALUE="<%= aList[i].getMemberGroupName() %>">
<%= comm.startDlistRow(rowselect) %>
<%= comm.addDlistCheck(aList[i].getMemberGroupId().toString(), "none") %>
<%= comm.addDlistColumn(UIUtil.toHTML((String)aList[i].getMemberGroupName()), "javascript:doOK('" + aList[i].getMemberGroupId().toString() + "')") %>
<%= comm.addDlistColumn(UIUtil.toHTML((String)aList[i].getMemberGroupDescription()), "none") %>
<%= comm.endDlistRow() %>
      
<%  
     if(rowselect==1){
       rowselect = 2;
     }
     else{
       rowselect = 1;
     } 
   }    // end for
%>   

<%= comm.endDlistTable() %>

   
</FORM>

<% if( aList.length == 0 ) {%>
<P>
<P>
<% 
     out.println( UIUtil.toHTML((String)policyListNLS.get("emptyMemberGroupList")) ); 
   }
%>


<SCRIPT>
        <!--
           parent.afterLoads();
           parent.setResultssize(getResultsSize());
         //-->
</SCRIPT>

</BODY>
</HTML>

<%
}
catch(Exception e)
{
   ExceptionHandler.displayJspException(request, response, e);
}
%>

