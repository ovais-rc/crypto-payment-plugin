<!--   ES 10/15/01 27696
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
-->
<%@ page language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.ibm.commerce.beans.DataBeanManager" %>
<%@ page import="com.ibm.commerce.tools.util.ResourceDirectory" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.tools.xml.*" %>
<%@ page import="com.ibm.commerce.inventory.beans.PickBatchDataBean" %>
<%@ page import="com.ibm.commerce.inventory.beans.*" %>
<%@ page import="com.ibm.commerce.tools.common.ui.taglibs.*" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.server.JSPHelper" %>
<%@ page import="com.ibm.commerce.utils.TimestampHelper" %>
<%@ page import="com.ibm.commerce.server.*" %>
<%@ page import="com.ibm.commerce.tools.util.UIUtil" %>
<%@ page import="com.ibm.commerce.inventory.commands.InventoryConstants" %>

<%@ page import="com.ibm.commerce.server.ECConstants" %>
<%@ page import="com.ibm.commerce.tools.segmentation.SegmentConstants" %>
<%@ page import="com.ibm.commerce.base.objects.*" %>
<%@ page import="com.ibm.commerce.beans.*" %>
<%@ page import="com.ibm.commerce.command.*" %>
<%@ page import="com.ibm.commerce.datatype.*" %>
<%@ page import="com.ibm.commerce.server.*" %>
<%@ page import="com.ibm.commerce.common.objects.*" %>
<%@ page import="com.ibm.commerce.user.beans.*"   %>
<%@ page import="com.ibm.commerce.user.objects.*"   %>

<%@ include file="../common/common.jsp" %>

<jsp:useBean id="pickBatchList" scope="request" class="com.ibm.commerce.inventory.beans.PickBatchListDataBean">
</jsp:useBean>

<%
   Hashtable FulfillmentNLS = null;
   PickBatchDataBean pickBatchIDs[] = null; 
   int numberOfpickbatchIDs = 0; 

   CommandContext cmdContext = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);

   Long userId = cmdContext.getUserId();
   Locale localeUsed = cmdContext.getLocale();

   // obtain the resource bundle for display
   FulfillmentNLS = (Hashtable)ResourceDirectory.lookup("inventory.FulfillmentNLS", localeUsed   );

   String pickbatchId = (String) request.getParameter(InventoryConstants.PICKBATCH_ID);
   String moreOrderReleases = (String) request.getParameter(InventoryConstants.MOREORDERRELEASES);

   Integer store_id = cmdContext.getStoreId();
   String storeId = store_id.toString(); 
   pickBatchList.setStoreentId(storeId); 

	StoreAccessBean sa = cmdContext.getStore();
	String storeTP = sa.getStoreType();
	String storeType = "";
	if ( storeTP == null ) {
		storeType = "";
	} else {
		storeType = storeTP.trim();
	}
        
   String ffmcenterId = UIUtil.getFulfillmentCenterId(request);

   if(ffmcenterId == null || ffmcenterId.equalsIgnoreCase("null")) {
	ffmcenterId = "";
   } else {
    ffmcenterId = ffmcenterId.trim();
   }

   if (ffmcenterId != "") {
   	pickBatchList.setFfmcenterId(ffmcenterId); 
	
   	DataBeanManager.activate(pickBatchList, request);
   	pickBatchIDs = pickBatchList.getPickBatchList();

   	if (pickBatchIDs != null)
     	{
     		numberOfpickbatchIDs = pickBatchIDs.length;
     	}
   } 
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
<HTML>
<HEAD>
<%= fHeader%>
<LINK rel=stylesheet href="<%= UIUtil.getCSSFile(localeUsed) %>" type="text/css">
<TITLE></TITLE>

<SCRIPT LANGUAGE="JavaScript">
<!---- hide script from old browsers

    function printMsg()
    {

        var more = '<%=UIUtil.toJavaScript((String)FulfillmentNLS.get("createBatchRemain"))%>';
	var noMore = '<%=UIUtil.toJavaScript((String)FulfillmentNLS.get("createBatchNoRemain"))%>';
 	var noNew = '<%=UIUtil.toJavaScript((String)FulfillmentNLS.get("noPickBatch"))%>';	
<%
      if (pickbatchId != null)
      {
        	out.println("var pickbatchId = \"" +  UIUtil.toJavaScript(pickbatchId) + "\";");
        	out.println("var moreOrderReleases = \"" + UIUtil.toJavaScript(moreOrderReleases) + "\";");

        	if (moreOrderReleases != null && moreOrderReleases.equals("Yes"))
          		out.println("alertDialog(pickbatchId + '-' + more);");
		else
          		out.println("alertDialog(pickbatchId  + '-' + noMore);");
      } else {
        	out.println("var moreOrderReleases = \"" + UIUtil.toJavaScript(moreOrderReleases) + "\";");

        	if (moreOrderReleases != null && moreOrderReleases.equals("No"))
          		out.println("alertDialog(noNew);");
      }
%>
    }


    function toBeOrNot()
    {
	var FFC = '<%=ffmcenterId%>';

	if ( FFC == "") {

		var mess = '<%=UIUtil.toJavaScript((String)FulfillmentNLS.get("FFCnone"))%>';
		alertDialog(mess);
		top.goBack();
	}
    }
			     
    function PickBatchGenerate(){

      var redirectURL = "<%="/webapp/wcs/tools/servlet/NewDynamicListView?ActionXMLFile=inventory.PickBatchList&cmd=PickBatchListView"%>";

      var url = "/webapp/wcs/tools/servlet/PickBatchGenerate?"
                    + "&ffmcenterId=" + <%=ffmcenterId%>
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
    function expeditedPickBatchGenerate(){

      var redirectURL = "<%="/webapp/wcs/tools/servlet/NewDynamicListView?ActionXMLFile=inventory.PickBatchList&cmd=PickBatchListView"%>";

      var url = "/webapp/wcs/tools/servlet/PickBatchGenerate?"
                    + "&ffmcenterId=" + <%=ffmcenterId%>
                    + "&isExpedited=Y"
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

    function viewPickTicket(){

	var tokens = parent.getSelected().split(",");
	var pickId = tokens[0];	

        var url="/webapp/wcs/tools/servlet/DialogView?XMLFile=inventory.PickTicketInterim";
        url += "&pickId=" + pickId;     
        
	var titleList = pickId + " - " + '<%=UIUtil.toJavaScript((String)FulfillmentNLS.get("PickTicketPanel"))%>';
          	
        if (top.setContent)
        {
          top.setContent(titleList,
                                 url,
                                 true);

        }else{
          parent.location.replace(url);
        }

    }
 

    function viewPackSlipList(){

	var tokens = parent.getSelected().split(",");
	var pickId = tokens[0];

        var url="/webapp/wcs/tools/servlet/NewDynamicListView?ActionXMLFile=inventory.PackslipList&amp;cmd=PackslipListView";
        url += "&pickId=" + pickId;
       
	var titleList = pickId + " - " + '<%=UIUtil.toJavaScript((String)FulfillmentNLS.get("PackslipListPanel"))%>';
          	
        if (top.setContent)
        {
          top.setContent(titleList,
                                 url,
                                 true);

      }else{
        parent.location.replace(url);
      }

    } 


    function viewReports(){


<%
	if (storeType.equalsIgnoreCase("B2C") || storeType.equalsIgnoreCase("RHS") || storeType.equalsIgnoreCase("MHS")) {
%>
        	var url="/webapp/wcs/tools/servlet/ShowContextList?context=B2C_PickBatchesReports&contextConfigXML=reporting.OperationalReportsContext&ActionXMLFile=bi.contextList";
<%
	} else {
%>
        	var url="/webapp/wcs/tools/servlet/ShowContextList?context=B2B_PickBatchesReports&contextConfigXML=reporting.OperationalReportsContext&ActionXMLFile=bi.contextList";
<%
	}
%>

        if (top.setContent)
        {
          top.setContent('<%=UIUtil.toJavaScript((String)FulfillmentNLS.get("viewReportsButton"))%>',
                                 url,
                                 true);

      }else{
        parent.location.replace(url);
      }


    } 

    function onLoad()
    {
      toBeOrNot();
      printMsg();
      parent.loadFrames()
    }

    function getResultSize () {
	return <%= numberOfpickbatchIDs %>;
    }


// -->
</script>

<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/common/dynamiclist.js"></SCRIPT>

</HEAD>
<BODY ONLOAD="onLoad()" CLASS="content">



<%
          int startIndex = Integer.parseInt(request.getParameter("startindex"));
          int listSize = Integer.parseInt(request.getParameter("listsize"));
          int endIndex = startIndex + listSize;
          int rowselect = 1;
          int totalsize = numberOfpickbatchIDs;
          int totalpage = totalsize/listSize;
	
%>



<%=comm.addControlPanel("inventory.PickBatchList", totalpage, totalsize, localeUsed )%>

<FORM NAME="PickBatchList">

<%=comm.startDlistTable((String)FulfillmentNLS.get("PickBatchList")) %>

<%= comm.startDlistRowHeading() %>

<%= comm.addDlistCheckHeading() %>

<%--//These next few rows get the header name from FulfillmentNLS file --%>
<%--//"pick batch ID should be the orderby variable  if orderbyParm = true, it sorts by this--%>
<%= comm.addDlistColumnHeading((String)FulfillmentNLS.get("PBLPickBatchNumber"), null, false )%>
<%= comm.addDlistColumnHeading((String)FulfillmentNLS.get("PBLDateCreated"), null, false  )%>
<%= comm.addDlistColumnHeading((String)FulfillmentNLS.get("PBLCreatedBy"), null, false )%>

<%= comm.endDlistRow() %>


<!-- Need to have a for loop to look for all pick batches -->
<%
    PickBatchDataBean pickBatchBean;
  
    if (endIndex > numberOfpickbatchIDs){
      endIndex = numberOfpickbatchIDs;
     }
    for (int i=startIndex; i<endIndex ; i++){
      pickBatchBean = pickBatchIDs[i];

      String pickBatchNumber = pickBatchBean.getPickBatchId();
      if (pickBatchNumber == null){
        pickBatchNumber = "";
      }

      String logId = pickBatchBean.getLogOnId();
      if (logId == null){
        logId = "";
      }


      String createdDate = pickBatchBean.getLastUpdate();
      String formattedCreatedDate = null;
      if (createdDate == null){
         formattedCreatedDate = "";
      }else{
         Timestamp tmp_createdDate = Timestamp.valueOf(createdDate);
         formattedCreatedDate = TimestampHelper.getDateFromTimestamp(tmp_createdDate, localeUsed );
	}
%>
<%=  comm.startDlistRow(rowselect) %>

<%= comm.addDlistCheck(pickBatchNumber, "none" ) %>

<%= comm.addDlistColumn(pickBatchNumber, "none" ) %>

<%= comm.addDlistColumn( formattedCreatedDate, "none" ) %> 

<%= comm.addDlistColumn( logId, "none" ) %> 

<%= comm.endDlistRow() %>
 
<%
if(rowselect==1)
   {
     rowselect = 2;
   }else{
     rowselect = 1;
   }
%>

<%
}
%>
<%= comm.endDlistTable() %>

<%
   if ( numberOfpickbatchIDs == 0 ){
%>
<br>
<%= UIUtil.toHTML((String)FulfillmentNLS.get("PBLNoRows")) %>
<%
   }
%>

</FORM>
<SCRIPT LANGUAGE="JavaScript">
 
  parent.afterLoads();
  parent.setResultssize(getResultSize());

</SCRIPT>

</BODY>
</HTML>
