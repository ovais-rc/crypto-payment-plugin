<%@ page language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.ibm.commerce.beans.DataBeanManager" %>
<%@ page import="com.ibm.commerce.tools.util.ResourceDirectory" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.tools.xml.*" %>
<%@ page import="com.ibm.commerce.inventory.beans.ReleasePackageDataBean" %>
<%@ page import="com.ibm.commerce.inventory.beans.*" %>
<%@ page import="com.ibm.commerce.tools.common.ui.taglibs.*" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.server.JSPHelper" %>
<%@ page import="com.ibm.commerce.utils.TimestampHelper" %>
<%@ page import="com.ibm.commerce.tools.util.UIUtil" %>
<%@ include file="../common/common.jsp" %>

<jsp:useBean id="packageList" scope="request" class="com.ibm.commerce.inventory.beans.ReleasePackageListDataBean">
</jsp:useBean>

<%
   Hashtable FulfillmentNLS = null;
   ReleasePackageDataBean packageIDs[] = null; 
   int numberOfPackageIDs = 0; 

   CommandContext cmdContext = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
   Long userId = cmdContext.getUserId();
   Locale localeUsed = cmdContext.getLocale();

   // obtain the resource bundle for display
   FulfillmentNLS = (Hashtable)ResourceDirectory.lookup("inventory.FulfillmentNLS", localeUsed   );	

   Integer store_id = cmdContext.getStoreId();
   String storeId = store_id.toString(); 
   packageList.setStoreentId(storeId); 

   Integer langId = cmdContext.getLanguageId();
   String strLangId = langId.toString();
   packageList.setLanguageId(strLangId); 

   String ffmcenterId = UIUtil.getFulfillmentCenterId(request);
   packageList.setFfmcenterId(ffmcenterId); 

   String orderNum = request.getParameter("orderNumber");	
   packageList.setOrdersId(orderNum); 

   String releaseNum = request.getParameter("releaseNumber");	
   packageList.setOrdReleaseNum(releaseNum); 

   String shipIdr = request.getParameter("shipmodeId");

   DataBeanManager.activate(packageList, request);
   packageIDs = packageList.getReleasePackageList();

   if (packageIDs != null)
   {
     numberOfPackageIDs = packageIDs.length;
   }

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">

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
<HTML>
<HEAD>
<%= fHeader%>
<LINK rel=stylesheet href="<%= UIUtil.getCSSFile(localeUsed) %>" type="text/css">
<H1></H1>

<SCRIPT LANGUAGE="JavaScript">
<!---- hide script from old browsers

//    function getResultsize(){
//     return <%=numberOfPackageIDs%>; 
//}

			     
    function packageNew(){	

        var url="/webapp/wcs/tools/servlet/DialogView?XMLFile=inventory.PackageDetail";
        url += "&orderNumber=<%=UIUtil.toJavaScript(orderNum)%>&releaseNumber=<%=UIUtil.toJavaScript(releaseNum)%>&shipmodeId=<%=UIUtil.toJavaScript(shipIdr)%>";
          	
        if (top.setContent)
        {
          top.setContent('<%=UIUtil.toJavaScript((String)FulfillmentNLS.get("PackageDetail"))%>',
                                 url,
                                 true);

      }else{
        parent.location.replace(url);
      }
    }

    function packageDelete()  {

      var checked = parent.getChecked();

      if (checked.length > 0)
      {
        // check for default administrators and set up the delete list
        var manifestList = "";
        for (var i = 0; (i<checked.length); i++)
        {
            manifestList += "&manifestId=" + checked[i];
        }

        if (confirmDialog("<%=UIUtil.toJavaScript((String)FulfillmentNLS.get("deleteRow")) %>") )
        {
          // delete
          var redirectURL = "<%="/webapp/wcs/tools/servlet/NewDynamicListView?ActionXMLFile=inventory.PackageList&cmd=PackageListView"%>";

	redirectURL += "&orderNumber=<%=UIUtil.toJavaScript(orderNum)%>&releaseNumber=<%=UIUtil.toJavaScript(releaseNum)%>&shipmodeId=<%=UIUtil.toJavaScript(shipIdr)%>";

          var url = "<%="/webapp/wcs/tools/servlet/ReleaseShipDelete?"%>"
                    + manifestList
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

 
    function packageChange(row){

	if (row == null) {
		var tokens = parent.getSelected().split(",");
		var manifestId = tokens[0];
	} else {
		var manifestId = row;
 
	}

        var url="/webapp/wcs/tools/servlet/DialogView?XMLFile=inventory.PackageChangeDetail";
        
        url += "&manifestId=" + manifestId + "&orderNumber=<%=UIUtil.toJavaScript(orderNum)%>&releaseNumber=<%=UIUtil.toJavaScript(releaseNum)%>";
          	
        if (top.setContent)
        {
          top.setContent('<%=UIUtil.toJavaScript((String)FulfillmentNLS.get("PackageDetailChange"))%>',
                                 url,
                                 true);

      }else{
        parent.location.replace(url);
      }
    }

    function onLoad()
    {
      parent.loadFrames();
    }


    function getResultSize () {
	return <%= numberOfPackageIDs %>;
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
          int totalsize = numberOfPackageIDs;
          int totalpage = totalsize/listSize;
	
%>



<%=comm.addControlPanel("inventory.PackageList", totalpage, totalsize, localeUsed )%>

<FORM NAME="PackageList">


<%=comm.startDlistTable((String)FulfillmentNLS.get("PackageList")) %>

<%= comm.startDlistRowHeading() %>

<%= comm.addDlistCheckHeading() %>

<%--//These next few rows get the header name from FulfillmentNLS file --%>

<%= comm.addDlistColumnHeading((String)FulfillmentNLS.get("PLPackageID"), null, false )%>
<%= comm.addDlistColumnHeading((String)FulfillmentNLS.get("PLShippingProvider"), null, false  )%>
<%= comm.addDlistColumnHeading((String)FulfillmentNLS.get("PLShippingDate"), null, false )%>

<%= comm.endDlistRow() %>


<!-- Need to have a for loop to look for all packages -->
<%
    ReleasePackageDataBean packageBean;
  
    if (endIndex > numberOfPackageIDs){
      endIndex = numberOfPackageIDs;
     }
    for (int i=startIndex; i<endIndex ; i++){
      packageBean = packageIDs[i];

      String packageId = packageBean.getPackageId();
      if (packageId == null){
        packageId = "";
      }

      String manifestId = packageBean.getManifestId();
      if (manifestId == null){
        manifestId = "";
      }

      String carrier = packageBean.getDescription();
      if (carrier == null){
        carrier = "";
      }

      String shipDate = packageBean.getDateShipped();
      String formattedshipDate = null;
      if (shipDate == null){
         formattedshipDate = "";
      }else{
         Timestamp tmp_shipDate = Timestamp.valueOf(shipDate);
         formattedshipDate = TimestampHelper.getDateFromTimestamp(tmp_shipDate, localeUsed );
	}
%>
<%=  comm.startDlistRow(rowselect) %>

<%= comm.addDlistCheck(manifestId, "none" ) %>

<%= comm.addDlistColumn(packageId, "javascript:packageChange('" + manifestId + "');" ) %> 

<%= comm.addDlistColumn(carrier, "none" ) %> 

<%= comm.addDlistColumn(formattedshipDate, "none" ) %> 

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
   if ( numberOfPackageIDs == 0 ){
%>
<br>
<%= UIUtil.toHTML((String)FulfillmentNLS.get("PLNoRows")) %>
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
