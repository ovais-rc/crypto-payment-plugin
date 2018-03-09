<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2001, 2016 All Rights Reserved.

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
<%@ page import="com.ibm.commerce.ubf.util.*" %>
<%@ page import="com.ibm.commerce.ubf.beans.*" %>
<%@ page import="com.ibm.commerce.user.beans.*" %>

<%@include file="../common/common.jsp" %>

<%
try
{
%>

<html>
<head>
<%= fHeader%>



<%
   String userId = null;
   String orgId = null;
   Locale locale = null;
   String storeId = null;
   String lang = null;
   String sortby = null;
   String searchFlowType = null;
   String theFlowType = null;
   String resultmsg = null;


   CommandContext aCommandContext = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);


   if( aCommandContext!= null )
   {
      locale = aCommandContext.getLocale();
      storeId = aCommandContext.getStoreId().toString();
      lang = aCommandContext.getLanguageId().toString();
      userId = aCommandContext.getUserId().toString();
      // use the Organization Id that this user is belong to
      Long [] orgChain = aCommandContext.getUser().getAncestors();
      if (orgChain != null && orgChain.length > 0)
      {
        // the first ancestor is the parent org
        orgId = orgChain[0].toString();
      }
   }
    // out.println("storeId: " + storeId);
    // out.println("userId: " + userId);
    // out.println("locale: " + locale);
    // out.println("lang: " + lang);

   resultmsg = (String) request.getParameter(com.ibm.commerce.ubf.util.FlowAdminConstants.EC_RESULTMSG);
   // out.println("resultmsg: " + resultmsg);
   searchFlowType = (String) request.getParameter("searchFlowType");
   String emptyString = new String("");
   if ((searchFlowType==null) || (searchFlowType.equals(emptyString)))
     searchFlowType = "All";

   theFlowType = searchFlowType;

   // obtain the resource bundle for display
   Hashtable flowAdminListNLS = (Hashtable)ResourceDirectory.lookup("ubfapprovals.flowAdminNLS",locale);
%>
<link rel=stylesheet href="<%= UIUtil.getCSSFile(locale) %>" type="text/css">

<title><%= flowAdminListNLS.get("flowAdminListTitle") %></title>

<jsp:useBean id="flowList" class="com.ibm.commerce.ubf.beans.FlowListBean" >
<jsp:setProperty property="*" name="flowList" />
<%
  if (!searchFlowType.equals("All"))
  {
%>
     <jsp:setProperty property="flowTypeId" name="flowList" value="<%= searchFlowType %>" />
<%
  }
%>
</jsp:useBean>


<%
   com.ibm.commerce.ubf.util.FlowSortingAttribute aSort
        = new com.ibm.commerce.ubf.util.FlowSortingAttribute();

   sortby = request.getParameter("orderby");
   // out.println("sortby is " + sortby);

   if ( sortby != null && !sortby.equals("null") && !sortby.equals("") ) {
      aSort.addSorting(sortby, true);
      flowList.setSortAtt(aSort);
   }

   com.ibm.commerce.beans.DataBeanManager.activate(flowList, request);
   FlowDataBean[] aList = flowList.getFlows();
   int len = aList.length;

   int startIndex = Integer.parseInt(request.getParameter("startindex"));
   int listSize = Integer.parseInt(request.getParameter("listsize"));
   int endIndex = startIndex + listSize;
   if (endIndex > aList.length )
   {
     endIndex = aList.length;
   }
   int rowselect = 1;
   int totalsize = flowList.getFlows().length;
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
   FlowDataBean theDataBean;
   FlowTypeDescriptionDataBean flowtypedesc;
   String flowId = null;
   String flowTypeId = null;
   String flowDesc = null;
   String flowTypeDesc = null;
   String selected = "No";
   String selectedFlow = null;
   String defalutLanguage = com.ibm.commerce.ubf.util.FlowAdminConstants.EC_SET_DEFAULT_LANGUAGE;
   String defalutStoreId = com.ibm.commerce.ubf.util.FlowAdminConstants.EC_SET_DEFAULT_STORE;
   String defalutOrganizationId = com.ibm.commerce.ubf.util.FlowAdminConstants.EC_SET_ROOT_ORG;
%>



<script LANGUAGE="JavaScript">
<!---- hide script from old browsers


function getResultsSize() {
     return <%= flowList.getFlows().length %>;
}

function getSortby() {
     return "<%= UIUtil.toJavaScript(sortby) %>";
}

function getStartIndex() {
    return "<%= UIUtil.toJavaScript(request.getParameter("startindex")) %>";
}

function getListSize() {
    return "<%= UIUtil.toJavaScript(request.getParameter("listsize")) %>";
}

function getSearchFlowType() {
    return "<%= UIUtil.toJavaScript(theFlowType) %>";
}

// This function is needed because the Framework keeps selected items from previous visits
function deSelectAll()
{
  for (var i=0; i < document.flowAdminListForm.elements.length; i++)
  {
     var e = document.flowAdminListForm.elements[i];
     if (e.type == 'checkbox' && e.name != 'select_deselect')
     {
        parent.removeEntry(e.name);
     }	
  }
}

function changeIt() {
  var checked = new Array;
  checked = parent.getChecked();
  var tempchecked = checked[0].split("|");
  var checked_id = tempchecked[0];
  if (checked.length > 1)
  {
    for (var j=1; j<checked.length; j++)
    {
       tempchecked = checked[j].split("|");
       checked_id = checked_id + "," + tempchecked[0];
    }
  }
  deSelectAll();
  location.replace('/webapp/wcs/tools/servlet/AddFlowAdminRecordCmd?flow_ids=' + checked_id + '&amp;viewtask=FlowAdminListView&amp;lang=' + getLang() + '&amp;orderby=' +
 getSortby() + '&amp;listsize=' + getListSize() + '&amp;startindex=' + getStartIndex() + '&amp;searchFlowType=' + getSearchFlowType());
  top.showProgressIndicator(true);
}

function removeIt() {
  if (confirmDialog("<%= flowAdminListNLS.get("removeFlows") %>")) {
    var checked = new Array;
    checked = parent.getChecked();
    var tempchecked = checked[0].split("|");
    var checked_id = tempchecked[0];
    if (checked.length > 1)
    {
      for (var j=1; j<checked.length; j++)
      {
         tempchecked = checked[j].split("|");
         checked_id = checked_id + "," + tempchecked[0];
      }
    }
    deSelectAll();
    location.replace('/webapp/wcs/tools/servlet/DeleteFlowAdminRecordCmd?flow_ids=' + checked_id + '&amp;viewtask=FlowAdminListView&amp;lang=' + getLang() + '&amp;orderby=' +
    getSortby() + '&amp;listsize=' + getListSize() + '&amp;startindex=' + getStartIndex() + '&amp;searchFlowType=' + getSearchFlowType());
    top.showProgressIndicator(true);
  }
}

function viewSummary() {
    var checked = new Array;
    checked = parent.getChecked();
    var tempchecked = checked[0].split("|");
    var checked_id = tempchecked[0];
    var theUrl = "/webapp/wcs/tools/servlet/DialogView?XMLFile=ubfapprovals.flowAdminDetailsDialog"+
              "&amp;flowId=" + checked_id;
    top.setContent("<%= UIUtil.toJavaScript((String)flowAdminListNLS.get("flowAdminDetailsBCT")) %>",
                         theUrl,
                         true);
}

function visibleList(s){
   if (this.flowAdminListForm.searchFlowType)
   {
      this.flowAdminListForm.searchFlowType.style.visibility = s;
   }
}

function changeFlowType() {
   var s = document.flowAdminListForm.searchFlowType.selectedIndex;
   var o = document.flowAdminListForm.searchFlowType.options[s].value;
   deSelectAll();
   var theURL2 = '/webapp/wcs/tools/servlet/NewDynamicListView?ActionXMLFile=ubfapprovals.flowAdminList&amp;cmd=FlowAdminListView&amp;searchFlowType=' + o;
   top.showContent(theURL2);
   top.refreshBCT();
   top.mccbanner.trail[top.mccbanner.counter].location = theURL2;
}

//this function will enable/disable button base on the status of the selected flow
function myRefreshButtons(){

  parent.setChecked();

  var theArray = new Array;
  var temp;
  for (var i=0; i<document.flowAdminListForm.elements.length; i++) {
      if (document.flowAdminListForm.elements[i].type == 'checkbox')
        if (document.flowAdminListForm.elements[i].checked)
           theArray[theArray.length] = document.flowAdminListForm.elements[i].name;
  }


 for (var j=0; j<theArray.length; j++)
 {
    temp = theArray[j].split("|");
    temp_id = temp[j];
    temp_status = temp[1];
    // alert("temp_status:" + temp_status);
    if ( temp_status == "No" )
    {
      if (defined(parent.buttons.buttonForm.removeButtonButton)) {
          //disable remove button
          // parent.buttons.buttonForm.removeButtonButton.disabled=false;
  	   parent.buttons.buttonForm.removeButtonButton.className='disabled';
      }
    }
    else if  ( temp_status == "Yes" )
    {
      if (defined(parent.buttons.buttonForm.changeStatusButtonButton)) {
          //disable change status button
          // parent.buttons.buttonForm.changeStatusButtonButton.disabled=false;
  	   parent.buttons.buttonForm.changeStatusButtonButton.className='disabled';
      }
    }
    else if  ( temp_status == "Default" )
    {
      if (defined(parent.buttons.buttonForm.changeStatusButtonButton)) {
          //disable change status button
          // parent.buttons.buttonForm.changeStatusButtonButton.disabled=false;
  	   parent.buttons.buttonForm.changeStatusButtonButton.className='disabled';
      }
      if (defined(parent.buttons.buttonForm.removeButtonButton)) {
          //disable remove button
          // parent.buttons.buttonForm.removeButtonButton.disabled=false;
  	   parent.buttons.buttonForm.removeButtonButton.className='disabled';
      }
    }
  }

}

function onLoad() {
  parent.loadFrames();
}

function getLang() {
  return "<%= lang %>";
}

// -->

</script>

<script SRC="/wcs/javascript/tools/common/Util.js">
</script>
<script SRC="/wcs/javascript/tools/common/dynamiclist.js">
</script>

</head>
<body CLASS="content" ONLOAD="onLoad()">
<script LANGUAGE="JavaScript">
<!--
//For IE
if (document.all) {
    onLoad();
}
//-->

</script>


<%= comm.addControlPanel("ubfapprovals.flowAdminList",totalpage,totalsize,locale) %>
      <form NAME="flowAdminListForm" id="flowAdminListForm">
        <br>
        <label for="searchFlowType1">
        <%= flowAdminListNLS.get("view") %>:
        </label>
        <select NAME="searchFlowType" onChange="changeFlowType()" id="searchFlowType1">
          <option VALUE="All" <%
           if(theFlowType.equals("All"))
           {
        %> selected <%
           }
        %>> All
         <jsp:useBean id="flowTypeList" class="com.ibm.commerce.ubf.beans.FlowTypeListBean" >
         <jsp:setProperty property="*" name="flowTypeList" />
         </jsp:useBean>
        <%
          com.ibm.commerce.beans.DataBeanManager.activate(flowTypeList, request);
          FlowTypeDataBean[] aFlowTypeList = flowTypeList.getFlowTypes();
          for (int i = 0; i < aFlowTypeList.length ; i++)
          {
        %>
          <option VALUE="<%= aFlowTypeList[i].getId() %>" <%
           if(aFlowTypeList[i].getId().equals(theFlowType))
           {
        %> selected <%
           }
           flowtypedesc = new FlowTypeDescriptionDataBean();
           try
           {
             flowtypedesc.setFlowTypeId(aFlowTypeList[i].getId());
             flowtypedesc.setLanguageId(lang);
             flowTypeDesc = flowtypedesc.getDescription();
           } catch(javax.persistence.NoResultException e1) {
             if (!lang.equals(defalutLanguage))
             {
               try
               {
                 flowtypedesc.setLanguageId(defalutLanguage);
                 flowTypeDesc = flowtypedesc.getDescription();
               } catch(javax.persistence.NoResultException e2) {
                 flowTypeDesc = " " ;
               }
             }
             else
               flowTypeDesc = " " ;
           }
        %>><%= flowTypeDesc %>
        <%
           }
        %>
        </select>

        <%= comm.startDlistTable(nul) %>
        <%= comm.startDlistRowHeading() %>
        <%= comm.addDlistCheckHeading(false) %>
        <%= comm.addDlistColumnHeading((String)flowAdminListNLS.get("statusHeader"),nul,false,"15%" ) %>
        <%= comm.addDlistColumnHeading((String)flowAdminListNLS.get("flowHeader"),"FLOW_ID",sortby.equals("FLOW_ID"),"45%" ) %>
        <%= comm.addDlistColumnHeading((String)flowAdminListNLS.get("flowTypeHeader"),"FLOWTYPE_ID",sortby.equals("FLOWTYPE_ID"),"40%" ) %>
        <%= comm.endDlistRow() %>

<%
  for (int i = startIndex; i < endIndex ; i++)
  {
     theDataBean = aList[i];
     flowId = theDataBean.getFlowId().toString();
     flowTypeId = theDataBean.getFlowTypeId().toString();

     FlowAdminDataBean aflowadmin = new FlowAdminDataBean();

     FlowDescriptionDataBean flowdesc = new FlowDescriptionDataBean();
     try
     {
       flowdesc.setFlowId(flowId);
       flowdesc.setLanguageId(lang);
       flowDesc = flowdesc.getDescription();
     } catch(javax.persistence.NoResultException e3) {
       if (!lang.equals(defalutLanguage))
       {
         try
         {
           flowdesc.setLanguageId(defalutLanguage);
           flowDesc = flowdesc.getDescription();
         } catch(javax.persistence.NoResultException e4) {
           flowDesc = " " ;
         }
       }
       else
         flowDesc = " " ;
     }

     flowtypedesc = new FlowTypeDescriptionDataBean();
     try
     {
       flowtypedesc.setFlowTypeId(flowTypeId);
       flowtypedesc.setLanguageId(lang);
       flowTypeDesc = flowtypedesc.getDescription();
     } catch(javax.persistence.NoResultException e5) {
       if (!lang.equals(defalutLanguage))
       {
         try
         {
           flowtypedesc.setLanguageId(defalutLanguage);
           flowTypeDesc = flowtypedesc.getDescription();
         } catch(javax.persistence.NoResultException e6) {
           flowTypeDesc = " " ;
         }
       }
       else
         flowTypeDesc = " " ;
     }

     if (aflowadmin.isFlowSelected(flowId, orgId, storeId))
     {
       selected = "Yes";
       selectedFlow = (String)flowAdminListNLS.get("inUseFlow");
     }
     else
     {
        if (aflowadmin.isFlowSelected(flowId, defalutOrganizationId, defalutStoreId))
        {
          selected = "Default";
          selectedFlow = (String)flowAdminListNLS.get("defaultFlow");
        }
        else
        {
         selected = "No";
         selectedFlow = (String)flowAdminListNLS.get("notUseFlow");
        }
     }

%>
<%= comm.startDlistRow(rowselect) %>
<%= comm.addDlistCheck(flowId+"|"+selected, "myRefreshButtons()") %>
<%= comm.addDlistColumn(selectedFlow, "none") %>
<%= comm.addDlistColumn(flowDesc, "none") %>
<%= comm.addDlistColumn(flowTypeDesc, "none") %>
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

   </form>

<% if( aList.length == 0 ) {%>
<p>
<p>
<%
     out.println( flowAdminListNLS.get("emptyFlowAdminList") );
   }
%>


<script>
        <!--
           parent.afterLoads();
           parent.setResultssize(getResultsSize());

<%
if(resultmsg != null && !resultmsg.equals(""))
{
%>
   top.showProgressIndicator(false);
   alertDialog('<%= flowAdminListNLS.get(resultmsg) %>');
<%
}
%>

//-->

</script>
</body>
</html>
<%
}
catch(ECSystemException e)
{
   ExceptionHandler.displayJspException(request, response, e);
}
%>