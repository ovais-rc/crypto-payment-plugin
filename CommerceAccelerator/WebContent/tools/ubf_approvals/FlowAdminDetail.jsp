

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">

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
<%@page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.tools.xml.*" %>
<%@ page import="com.ibm.commerce.beans.*" %>
<%@ page import="com.ibm.commerce.datatype.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.lang.*" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.command.*"%>
<%@ page import="com.ibm.commerce.*" %>
<%@ page import="com.ibm.commerce.exception.*" %>
<%@ page import="com.ibm.commerce.server.*" %>
<%@ page import="com.ibm.commerce.ubf.util.*" %>
<%@ page import="com.ibm.commerce.ubf.beans.*" %>
<%@ page import="com.ibm.commerce.ubf.objects.*" %>
<%@include file="../common/common.jsp" %>

<%
   String   emptyString = new String("");
   String userId = null;
   Locale locale = null;
   String storeId = null;
   String lang = null;
   String flowId = (String) request.getParameter(com.ibm.commerce.ubf.util.FlowAdminConstants.EC_PARM_FLOWID);

   CommandContext aCommandContext = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);

   if( aCommandContext!= null )
   {
      locale = aCommandContext.getLocale();
      storeId = aCommandContext.getStoreId().toString();
      lang = aCommandContext.getLanguageId().toString();
      userId = aCommandContext.getUserId().toString();
   }

      // out.println("storeId: " + storeId);
      // out.println("userId: " + userId);
      // out.println("locale: " + locale);
      // out.println("lang: " + lang);
      // out.println("flowId: " + flowId);

   if (flowId == null)
     flowId = emptyString;

   // obtain the resource bundle for display
   Hashtable flowAdminListNLS = (Hashtable)ResourceDirectory.lookup("ubfapprovals.flowAdminNLS",locale);
%>

<html>
<head>
<link rel=stylesheet href="<%= UIUtil.getCSSFile(locale) %>" type="text/css">

<script SRC="/wcs/javascript/tools/common/Util.js">
</script>

    <script>
      function printAction() {
      	window.print();
      }
    
</script>
</head>
<body CLASS="content" ONLOAD="parent.setContentFrameLoaded(true);">
<%
  String flowDesc = null;
  String flowLongDesc = null;
  String defalutLanguage = "-1";
  FlowDataBean flow = new FlowDataBean();
  flow.setFlowId(flowId);
  FlowDescriptionDataBean flowdesc = new FlowDescriptionDataBean();
  try
  {
    flowdesc.setFlowId(flowId);
    flowdesc.setLanguageId(lang);
    flowDesc = flowdesc.getDescription();
    flowLongDesc = flowdesc.getLongDescription();
  } catch(javax.persistence.NoResultException e1) {
    if (!lang.equals(defalutLanguage))
    {
      try
      {
        flowdesc.setLanguageId(defalutLanguage);
        flowDesc = flowdesc.getDescription();
        flowLongDesc = flowdesc.getLongDescription();
      } catch(javax.persistence.NoResultException e2) {
        flowDesc = " " ;
        flowLongDesc = " ";
      }
    }
    else
      flowDesc = " " ;
      flowLongDesc = " ";
  }

  String flowTypeId = flow.getFlowTypeId();
  FlowTypeDataBean flowType = new FlowTypeDataBean();
  flowType.setFlowTypeId(flowTypeId);
  String flowTypeDesc = null;
  String flowTypeLongDesc = null;
  FlowTypeDescriptionDataBean flowtypedesc = new FlowTypeDescriptionDataBean();
  try
  {
    flowtypedesc.setFlowTypeId(flowTypeId);
    flowtypedesc.setLanguageId(lang);
    flowTypeDesc = flowtypedesc.getDescription();
    flowTypeLongDesc = flowtypedesc.getLongDescription();
	} catch(javax.persistence.NoResultException e3) {
    if (!lang.equals(defalutLanguage))
    {
      try
      {
        flowtypedesc.setLanguageId(defalutLanguage);
        flowTypeDesc = flowtypedesc.getDescription();
        flowTypeLongDesc = flowtypedesc.getLongDescription();
	  } catch(javax.persistence.NoResultException e4) {
        flowTypeDesc = " " ;
        flowTypeLongDesc = " ";
      }
    }
    else
      flowTypeDesc = " " ;
      flowTypeLongDesc = " ";
  }

  FlowStateRelListBean flowstateList = new FlowStateRelListBean();
  flowstateList.setFlowId(flowId);
  com.ibm.commerce.beans.DataBeanManager.activate(flowstateList, request);
  FlowStateRelDataBean[] aList = flowstateList.getFlowStateRels();
  int statesLen = aList.length;
  FlowStateRelDataBean theDataBean;
  String stateId = null;
  String stateName = null;
  String entryAction = null;
  String exitAction = null;
  String responseViewName = null;
  String desc = null;

  TransitionListBean flowtransitionList = new TransitionListBean();
  flowtransitionList.setFlowId(Long.valueOf(flowId));
  com.ibm.commerce.beans.DataBeanManager.activate(flowtransitionList, request);
  TransitionDataBean[] aTransitionList = flowtransitionList.getTransitions();
  int transitionsLen = aTransitionList.length;
  TransitionDataBean theTransitionDataBean;
  String  transitionId = null;
  String  sourceStateId = null;
  String  targetStateId = null;
  String  priority = null;
  String  eventIdentifier = null;
  String  approval = null;
  String  actionInterface = null;
  String  accessControlGuard = null;
  String  businessLogicGuard = null;
  String  spawnFlowTypeId = null;
  String  spawnType = null;
%>
   <h1><%= flowAdminListNLS.get("flowAdminDetailsTitle").toString() %></h1>
   <table class="list" width=90% cellpadding=1 cellspacing=0 border=1 id="FlowAdminDetail_Table_1">
       <tr CLASS="list_roles">
        <th id="Flow" colspan=2>
           <table CLASS="list_role_off" id="FlowAdminDetail_Table_2">
                <tr>
                     <td CLASS="list_header" wrap id="FlowAdminDetail_TableCell_1"><center><big><%= flowAdminListNLS.get("flow").toString() %></big></center></td>
                </tr>
            </table>
        </th>
       </tr>

       <tr CLASS="list_row1">
         <td CLASS="list_info1" width=25% id="FlowAdminDetail_TableCell_2"><%= flowAdminListNLS.get("flowId").toString() %></td>
         <td CLASS="list_info1" id="FlowAdminDetail_TableCell_3"><%= UIUtil.toHTML(flowId) %></td>
       </tr>

  	<tr CLASS="list_row2">
         <td CLASS="list_info1" id="FlowAdminDetail_TableCell_4"><%= flowAdminListNLS.get("description").toString() %></td>
         <td CLASS="list_info1" id="FlowAdminDetail_TableCell_5"><%= flowDesc %></td>
       </tr>
  	<tr CLASS="list_row1">
         <td CLASS="list_info1" id="FlowAdminDetail_TableCell_6"><%= flowAdminListNLS.get("longDescription").toString() %></td>
         <td CLASS="list_info1" id="FlowAdminDetail_TableCell_7"><%= flowLongDesc %></td>
       </tr>
  	<tr CLASS="list_row2">
         <td CLASS="list_info1" id="FlowAdminDetail_TableCell_8"><%= flowAdminListNLS.get("flowTypeId").toString() %></td>
         <td CLASS="list_info1" id="FlowAdminDetail_TableCell_9"><%= flow.getFlowTypeId() %></td>
       </tr>
  	<tr CLASS="list_row1">
         <td CLASS="list_info1" id="FlowAdminDetail_TableCell_10"><%= flowAdminListNLS.get("compositeFlow").toString() %></td>
         <td CLASS="list_info1" id="FlowAdminDetail_TableCell_11"><%= flow.getCompositeFlow() %></td>
       </tr>
  	<tr CLASS="list_row2">
         <td CLASS="list_info1" id="FlowAdminDetail_TableCell_12"><%= flowAdminListNLS.get("attribute").toString() %></td>
         <td CLASS="list_info1" id="FlowAdminDetail_TableCell_13"><%= flow.getAttribute() %></td>
       </tr>
  	<tr CLASS="list_row1">
         <td CLASS="list_info1" id="FlowAdminDetail_TableCell_14"><%= flowAdminListNLS.get("identifier").toString() %></td>
         <td CLASS="list_info1" id="FlowAdminDetail_TableCell_15"><%= flow.getIdentifier() %></td>
       </tr>
  	<tr CLASS="list_row2">
         <td CLASS="list_info1" id="FlowAdminDetail_TableCell_16"><%= flowAdminListNLS.get("priority").toString() %></td>
         <td CLASS="list_info1" id="FlowAdminDetail_TableCell_17"><%= flow.getPriority() %></td>
       </tr>
   </table>

   <br><br>
   <table width=90% cellpadding=0 cellspacing=0 border=1 id="FlowAdminDetail_Table_3">
       <tr CLASS="list_roles">
        <th id="Flow" colspan=2>
           <table CLASS="list_role_off" id="FlowAdminDetail_Table_4">
                <tr>
                     <td CLASS="list_header" wrap id="FlowAdminDetail_TableCell_18"><center><big><%= flowAdminListNLS.get("flowType").toString() %></big></center></td>
                </tr>
            </table>
        </th>
       </tr>

  	<tr CLASS="list_row1">
         <td CLASS="list_info1" width=25% id="FlowAdminDetail_TableCell_19"><%= flowAdminListNLS.get("flowTypeId").toString() %></td>
         <td CLASS="list_info1" id="FlowAdminDetail_TableCell_20"><%= flowTypeId %></td>
       </tr>
  	<tr CLASS="list_row2">
         <td CLASS="list_info1" id="FlowAdminDetail_TableCell_21"><%= flowAdminListNLS.get("description").toString() %></td>
         <td CLASS="list_info1" id="FlowAdminDetail_TableCell_22"><%= flowTypeDesc %></td>
       </tr>
  	<tr CLASS="list_row1">
         <td CLASS="list_info1" id="FlowAdminDetail_TableCell_23"><%= flowAdminListNLS.get("longDescription").toString() %></td>
         <td CLASS="list_info1" id="FlowAdminDetail_TableCell_24"><%= flowTypeLongDesc %></td>
       </tr>
  	<tr CLASS="list_row2">
         <td CLASS="list_info1" id="FlowAdminDetail_TableCell_25"><%= flowAdminListNLS.get("flowDomainId").toString() %></td>
         <td CLASS="list_info1" id="FlowAdminDetail_TableCell_26"><%= flowType.getFlowDomainId() %></td>
       </tr>
  	<tr CLASS="list_row1">
         <td CLASS="list_info1" id="FlowAdminDetail_TableCell_27"><%= flowAdminListNLS.get("businessFlowBeanClass").toString() %></td>
         <td CLASS="list_info1" id="FlowAdminDetail_TableCell_28"><%= flowType.getBusinessFlowBeanClass() %></td>
       </tr>
  	<tr CLASS="list_row2">
         <td CLASS="list_info1" id="FlowAdminDetail_TableCell_29"><%= flowAdminListNLS.get("viewName").toString() %></td>
         <td CLASS="list_info1" id="FlowAdminDetail_TableCell_30"><%= flowType.getViewName() %></td>
       </tr>
  	<tr CLASS="list_row1">
         <td CLASS="list_info1" id="FlowAdminDetail_TableCell_31"><%= flowAdminListNLS.get("attribute").toString() %></td>
         <td CLASS="list_info1" id="FlowAdminDetail_TableCell_32"><%= flowType.getAttribute() %></td>
       </tr>
  	<tr CLASS="list_row2">
         <td CLASS="list_info1" id="FlowAdminDetail_TableCell_33"><%= flowAdminListNLS.get("identifier").toString() %></td>
         <td CLASS="list_info1" id="FlowAdminDetail_TableCell_34"><%= flowType.getIdentifier() %></td>
       </tr>
  	<tr CLASS="list_row1">
         <td CLASS="list_info1" id="FlowAdminDetail_TableCell_35"><%= flowAdminListNLS.get("priority").toString() %></td>
         <td CLASS="list_info1" id="FlowAdminDetail_TableCell_36"><%= flowType.getPriority() %></td>
       </tr>
   </table>
   <br><br>
   <table width=90% cellpadding=0 cellspacing=0 border=1 id="FlowAdminDetail_Table_5">
       <tr CLASS="list_roles">
        <th id="Flow" colspan=2>
           <table CLASS="list_role_off" id="FlowAdminDetail_Table_6">
                <tr>
                     <td CLASS="list_header" wrap id="FlowAdminDetail_TableCell_37"><center><big><%= flowAdminListNLS.get("flowStates").toString() %></big></center></td>
                </tr>
            </table>
        </th>
       </tr>

  	<tr CLASS="list_row1">
         <td CLASS="list_info1" width=25% id="FlowAdminDetail_TableCell_38"><%= flowAdminListNLS.get("totalFlowStates").toString() %></td>
         <td CLASS="list_info1" id="FlowAdminDetail_TableCell_39"><%= statesLen %></td>
       </tr>
<%
  for (int i = 0; i < statesLen ; i++)
  {
     theDataBean = aList[i];
     stateId = theDataBean.getStateId();
     stateName = theDataBean.getStateName();
     entryAction = theDataBean.getEntryActionInterface();
     exitAction = theDataBean.getExitActionInterface();
     FlowStateDescriptionDataBean flowstatedesc = new FlowStateDescriptionDataBean();
     try
     {
       flowstatedesc.setFlowStateId(stateId);
       flowstatedesc.setLanguageId(lang);
       desc = flowstatedesc.getDescription();
     } catch(javax.persistence.NoResultException e5) {
       if (!lang.equals(defalutLanguage))
       {
         try
         {
           flowstatedesc.setLanguageId(defalutLanguage);
           desc = flowstatedesc.getDescription();
         } catch(javax.persistence.NoResultException e6) {
           desc = " " ;
         }
       }
       else
         desc = " " ;
     }
%>
       <tr CLASS="list_roles">
        <th id="Flow" colspan=2>
           <table CLASS="list_role_on" id="FlowAdminDetail_Table_7_<%=i%>">
                <tr>
                     <td CLASS="list_header" wrap id="FlowAdminDetail_TableCell_40_<%=i%>"><%= flowAdminListNLS.get("flowState").toString() %>: <%= i+1 %></td>
                </tr>
            </table>
        </th>
       </tr>
  	<tr CLASS="list_row2">
         <td CLASS="list_info1" id="FlowAdminDetail_TableCell_41_<%=i%>"><%= flowAdminListNLS.get("flowStateId").toString() %></td>
         <td CLASS="list_info1" id="FlowAdminDetail_TableCell_42_<%=i%>"><%= stateId %></td>
       </tr>
  	<tr CLASS="list_row1">
         <td CLASS="list_info1" id="FlowAdminDetail_TableCell_43_<%=i%>"><%= flowAdminListNLS.get("stateName").toString() %></td>
         <td CLASS="list_info1" id="FlowAdminDetail_TableCell_44_<%=i%>"><%= stateName %></td>
       </tr>
  	<tr CLASS="list_row2">
         <td CLASS="list_info1" id="FlowAdminDetail_TableCell_45_<%=i%>"><%= flowAdminListNLS.get("description").toString() %></td>
         <td CLASS="list_info1" id="FlowAdminDetail_TableCell_46_<%=i%>"><%= desc %></td>
       </tr>
  	<tr CLASS="list_row1">
         <td CLASS="list_info1" id="FlowAdminDetail_TableCell_47_<%=i%>"><%= flowAdminListNLS.get("entryActionInterface").toString() %></td>
         <td CLASS="list_info1" id="FlowAdminDetail_TableCell_48_<%=i%>"><%= entryAction %></td>
       </tr>
  	<tr CLASS="list_row2">
         <td CLASS="list_info1" id="FlowAdminDetail_TableCell_49_<%=i%>"><%= flowAdminListNLS.get("exitActionInterface").toString() %></td>
         <td CLASS="list_info1" id="FlowAdminDetail_TableCell_50_<%=i%>"><%= exitAction %></td>
       </tr>
  	<tr CLASS="list_row1">
         <td CLASS="list_info1" id="FlowAdminDetail_TableCell_51_<%=i%>"><%= flowAdminListNLS.get("viewName").toString() %></td>
         <td CLASS="list_info1" id="FlowAdminDetail_TableCell_52_<%=i%>"><%= responseViewName %></td>
       </tr>
<%
  }
%>
   </table>
   <br><br>
   <table width=90% cellpadding=0 cellspacing=0 border=1 id="FlowAdminDetail_Table_8">
       <tr CLASS="list_roles">
        <th id="Flow" colspan=2>
           <table CLASS="list_role_off" id="FlowAdminDetail_Table_9">
                <tr>
                     <td CLASS="list_header" wrap id="FlowAdminDetail_TableCell_53"><center><big><%= flowAdminListNLS.get("flowTransitions").toString() %></big></center></td>
                </tr>
            </table>
        </th>
       </tr>

  	<tr CLASS="list_row1">
         <td CLASS="list_info1" width=25% id="FlowAdminDetail_TableCell_54"><%= flowAdminListNLS.get("totalFlowTransitions").toString() %></td>
         <td CLASS="list_info1" id="FlowAdminDetail_TableCell_55"><%= transitionsLen %></td>
       </tr>
<%
  for (int i = 0; i < transitionsLen ; i++)
  {
     theTransitionDataBean = aTransitionList[i];
     transitionId = theTransitionDataBean.getId();
     sourceStateId = theTransitionDataBean.getSourceStateId();
     targetStateId = theTransitionDataBean.getTargetStateId();
     priority = theTransitionDataBean.getPriority();
     eventIdentifier = theTransitionDataBean.getEventIdentifier();
     approval = theTransitionDataBean.getApproval();
     actionInterface = theTransitionDataBean.getActionInterface();
     accessControlGuard = theTransitionDataBean.getAccessControlGuard();
     businessLogicGuard = theTransitionDataBean.getBusinessLogicGuard();
     spawnFlowTypeId = theTransitionDataBean.getSpawnFlowTypeId();
     spawnType = theTransitionDataBean.getSpawnType();
     responseViewName = theTransitionDataBean.getResponseViewName();

     TransitionDescriptionDataBean flowtransitiondesc = new TransitionDescriptionDataBean();
     try
     {
       flowtransitiondesc.setTransitionId(transitionId);
       flowtransitiondesc.setLanguageId(lang);
       desc = flowtransitiondesc.getTransitionDescription();
     } catch(javax.persistence.NoResultException e7) {
       if (!lang.equals(defalutLanguage))
       {
         try
         {
           flowtransitiondesc.setLanguageId(defalutLanguage);
           desc = flowtransitiondesc.getTransitionDescription();
         } catch(javax.persistence.NoResultException e8) {
           desc = " " ;
         }
       }
       else
         desc = " " ;
     }
%>
       <tr CLASS="list_roles">
        <th id="Flow" colspan=2>
           <table CLASS="list_role_on" id="FlowAdminDetail_Table_10_<%=i%>">
                <tr>
                     <td CLASS="list_header" wrap id="FlowAdminDetail_TableCell_56_<%=i%>"><%= flowAdminListNLS.get("flowTransition").toString() %>: <%= i+1 %></td>
                </tr>
            </table>
        </th>
       </tr>
  	<tr CLASS="list_row2">
         <td CLASS="list_info1" id="FlowAdminDetail_TableCell_57_<%=i%>"><%= flowAdminListNLS.get("flowTransitionId").toString() %></td>
         <td CLASS="list_info1" id="FlowAdminDetail_TableCell_58_<%=i%>"><%= transitionId %></td>
       </tr>
  	<tr CLASS="list_row1">
         <td CLASS="list_info1" id="FlowAdminDetail_TableCell_59_<%=i%>"><%= flowAdminListNLS.get("description").toString() %></td>
         <td CLASS="list_info1" id="FlowAdminDetail_TableCell_60_<%=i%>"><%= desc %></td>
       </tr>
  	<tr CLASS="list_row2">
         <td CLASS="list_info1" id="FlowAdminDetail_TableCell_61_<%=i%>"><%= flowAdminListNLS.get("sourceStateId").toString() %></td>
         <td CLASS="list_info1" id="FlowAdminDetail_TableCell_62_<%=i%>"><%= sourceStateId %></td>
       </tr>
  	<tr CLASS="list_row1">
         <td CLASS="list_info1" id="FlowAdminDetail_TableCell_63_<%=i%>"><%= flowAdminListNLS.get("targetStateId").toString() %></td>
         <td CLASS="list_info1" id="FlowAdminDetail_TableCell_64_<%=i%>"><%= targetStateId %></td>
       </tr>
  	<tr CLASS="list_row2">
         <td CLASS="list_info1" id="FlowAdminDetail_TableCell_65_<%=i%>"><%= flowAdminListNLS.get("priority").toString() %></td>
         <td CLASS="list_info1" id="FlowAdminDetail_TableCell_66_<%=i%>"><%= priority %></td>
       </tr>
  	<tr CLASS="list_row1">
         <td CLASS="list_info1" id="FlowAdminDetail_TableCell_67_<%=i%>"><%= flowAdminListNLS.get("eventIdentifier").toString() %></td>
         <td CLASS="list_info1" id="FlowAdminDetail_TableCell_68_<%=i%>"><%= eventIdentifier %></td>
       </tr>
  	<tr CLASS="list_row2">
         <td CLASS="list_info1" id="FlowAdminDetail_TableCell_69_<%=i%>"><%= flowAdminListNLS.get("approval").toString() %></td>
         <td CLASS="list_info1" id="FlowAdminDetail_TableCell_70_<%=i%>"><%= approval %></td>
       </tr>
  	<tr CLASS="list_row1">
         <td CLASS="list_info1" id="FlowAdminDetail_TableCell_71_<%=i%>"><%= flowAdminListNLS.get("actionInterface").toString() %></td>
         <td CLASS="list_info1" id="FlowAdminDetail_TableCell_72_<%=i%>"><%= actionInterface %></td>
       </tr>
  	<tr CLASS="list_row2">
         <td CLASS="list_info1" id="FlowAdminDetail_TableCell_73_<%=i%>"><%= flowAdminListNLS.get("accessControlGuard").toString() %></td>
         <td CLASS="list_info1" id="FlowAdminDetail_TableCell_74_<%=i%>"><%= accessControlGuard %></td>
       </tr>
  	<tr CLASS="list_row1">
         <td CLASS="list_info1" id="FlowAdminDetail_TableCell_75_<%=i%>"><%= flowAdminListNLS.get("businessLogicGuard").toString() %></td>
         <td CLASS="list_info1" id="FlowAdminDetail_TableCell_76_<%=i%>"><%= businessLogicGuard %></td>
       </tr>
  	<tr CLASS="list_row2">
         <td CLASS="list_info1" id="FlowAdminDetail_TableCell_77_<%=i%>"><%= flowAdminListNLS.get("spawnFlowTypeId").toString() %></td>
         <td CLASS="list_info1" id="FlowAdminDetail_TableCell_78_<%=i%>"><%= spawnFlowTypeId %></td>
       </tr>
  	<tr CLASS="list_row1">
         <td CLASS="list_info1" id="FlowAdminDetail_TableCell_79_<%=i%>"><%= flowAdminListNLS.get("spawnType").toString() %></td>
         <td CLASS="list_info1" id="FlowAdminDetail_TableCell_80_<%=i%>"><%= spawnType %></td>
       </tr>
  	<tr CLASS="list_row2">
         <td CLASS="list_info1" id="FlowAdminDetail_TableCell_81_<%=i%>"><%= flowAdminListNLS.get("viewName").toString() %></td>
         <td CLASS="list_info1" id="FlowAdminDetail_TableCell_82_<%=i%>"><%= responseViewName %></td>
       </tr>
<%
  }
%>
   </table>
<br>
</body>
</html>


