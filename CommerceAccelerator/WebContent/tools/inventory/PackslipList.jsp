<!--   
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
<%@ page import="com.ibm.commerce.inventory.beans.PackslipDataBean" %>
<%@ page import="com.ibm.commerce.inventory.beans.*" %>
<%@ page import="com.ibm.commerce.tools.common.ui.taglibs.*" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.server.JSPHelper" %>
<%@ page import="com.ibm.commerce.utils.TimestampHelper" %>
<%@ include file="../common/common.jsp" %>

<jsp:useBean id="packslipList" scope="request" class="com.ibm.commerce.inventory.beans.PackslipListDataBean">
</jsp:useBean>

<%
   Hashtable FulfillmentNLS = null;
   PackslipDataBean packIDs[] = null; 
   int numberOfPackIDs = 0; 

   CommandContext cmdContext = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
   Long userId = cmdContext.getUserId();
   Locale localeUsed = cmdContext.getLocale();

   // obtain the resource bundle for display
   FulfillmentNLS = (Hashtable)ResourceDirectory.lookup("inventory.FulfillmentNLS", localeUsed   );

   String pickBatchId = request.getParameter("pickId");
   
   //Change by wzh for defect 72373, to assign commandContext to PackslipListDataBean
   packslipList.setCommandContext(cmdContext);
   packslipList.setPickBatchId(pickBatchId); 

   DataBeanManager.activate(packslipList, request);
   packIDs = packslipList.getPackslipList();

   if (packIDs != null)
   {
     numberOfPackIDs = packIDs.length;
   }

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
<HTML>
<HEAD>
<%= fHeader%>
<LINK rel=stylesheet href="<%= UIUtil.getCSSFile(localeUsed) %>" type="text/css">
<TITLE></TITLE>
<H1></H1>

<SCRIPT LANGUAGE="JavaScript">
<!---- hide script from old browsers
			     
    function viewPackslip(){

	var tokens = parent.getSelected().split(",");
	var orderNum = tokens[0];	

	var tokens = parent.getSelected().split(",");
	var releaseNum = tokens[1];	

        var url="/webapp/wcs/tools/servlet/DialogView?XMLFile=inventory.PackslipInterim";
        url += "&orderNumber=" + orderNum + "&releaseNumber=" + releaseNum;

	var titleList = orderNum + "-" + releaseNum + " - " + '<%=UIUtil.toJavaScript((String)FulfillmentNLS.get("Packslip"))%>';


       if (top.setContent)
       {
         top.setContent(titleList,
                                url,
                                true);

       }else{
         parent.location.replace(url);
       }


    }
 

    function onLoad()
    {
      parent.loadFrames()
    }


    function getResultSize () {
	return <%= numberOfPackIDs %>;
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
          int totalsize = numberOfPackIDs;
          int totalpage = totalsize/listSize;
	
%>



<%=comm.addControlPanel("inventory.PackslipList", totalpage, totalsize, localeUsed )%>

<FORM NAME="PackslipList">

<%=comm.startDlistTable((String)FulfillmentNLS.get("PackslipList")) %>

<%= comm.startDlistRowHeading() %>

<%= comm.addDlistCheckHeading() %>

<%--//These next few rows get the header name from FulfillmentNLS file --%>
<%--//"pick batch ID should be the orderby variable  if orderbyParm = true, it sorts by this--%>
<%= comm.addDlistColumnHeading((String)FulfillmentNLS.get("PSLOrderNumber"), null, false )%>
<%= comm.addDlistColumnHeading((String)FulfillmentNLS.get("PSLReleaseNumber"), null, false )%>
<%= comm.addDlistColumnHeading((String)FulfillmentNLS.get("PSLDateCreated"), null, false  )%>

<%= comm.endDlistRow() %>


<!-- Need to have a for loop to look for all pick batches -->
<%
    PackslipDataBean packslipBean;
  
    if (endIndex > numberOfPackIDs){
      endIndex = numberOfPackIDs;
     }
    for (int i=startIndex; i<endIndex ; i++){
      packslipBean = packIDs[i];

      String orderNumber = packslipBean.getOrdersId();
      if (orderNumber == null){
        orderNumber = "";
      }

      String releaseNumber = packslipBean.getOrdReleaseNum();
      if (releaseNumber == null){
        releaseNumber = "";
      }

      String memberId = packslipBean.getmemberId();
      if (memberId == null){
        memberId = "";
      }

      String createdDate = packslipBean.getLastUpdate();
      String formattedCreatedDate = null;
      if (createdDate == null){
         formattedCreatedDate = "";
      }else{
         Timestamp tmp_createdDate = Timestamp.valueOf(createdDate);
         formattedCreatedDate = TimestampHelper.getDateFromTimestamp(tmp_createdDate, localeUsed );
	}
%>
<%=  comm.startDlistRow(rowselect) %>

<%= comm.addDlistCheck(orderNumber + "," + releaseNumber, "none" ) %>

<%= comm.addDlistColumn(orderNumber, "none" ) %>

<%= comm.addDlistColumn(releaseNumber, "none" ) %>

<%= comm.addDlistColumn( formattedCreatedDate, "none" ) %> 


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
   if ( numberOfPackIDs == 0 ){
%>
<br>
<%= UIUtil.toHTML((String)FulfillmentNLS.get("PSLNoRows")) %>
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
