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

<%@ page import="com.ibm.commerce.beans.DataBeanManager" %>
<%@ page import="com.ibm.commerce.tools.util.ResourceDirectory" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.tools.xml.*" %>
<%@ page import="com.ibm.commerce.inventory.beans.VendorDataBean" %>
<%@ page import="com.ibm.commerce.tools.common.ui.taglibs.*" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.server.JSPHelper" %>
<%@ page import="com.ibm.commerce.utils.TimestampHelper" %>
<%@ page import="com.ibm.commerce.tools.util.UIUtil" %>
<%@ include file="../common/common.jsp" %>


<jsp:useBean id="vendorList" scope="request" class="com.ibm.commerce.inventory.beans.VendorListDataBean">
</jsp:useBean>

<%
   Hashtable vendorPurchaseListNLS = null;
   
   VendorDataBean vendorPOs[] = null; 
   int numberOfVendors = 0; 

   CommandContext cmdContext = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
   Long userId = cmdContext.getUserId();
   Locale localUsed = cmdContext.getLocale();

   // obtain the resource bundle for display
   vendorPurchaseListNLS = (Hashtable)ResourceDirectory.lookup("inventory.VendorPurchaseNLS", localUsed  );

  Integer storeId = cmdContext.getStoreId();
  String strStoreId = storeId.toString(); 
  
  Integer langId = cmdContext.getLanguageId();
  String strLangId = langId.toString(); 
    
  vendorList.setLanguageId(strLangId);     
  vendorList.setStoreentId(strStoreId);
   
   DataBeanManager.activate(vendorList, request);
   vendorPOs = vendorList.getVendorList();



   if (vendorPOs != null)
   {
     numberOfVendors = vendorPOs.length;
   }
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
<HTML>
<HEAD>
<%= fHeader%>
<LINK rel="stylesheet" href="<%= UIUtil.getCSSFile(localUsed) %>" type="text/css">
<TITLE></TITLE>

<SCRIPT LANGUAGE="JavaScript">
<!---- hide script from old browsers
function getResultsize(){
     return <%=numberOfVendors%>; 
}
    
    function newVendor(){
          var url = "/webapp/wcs/tools/servlet/WizardView?XMLFile=inventory.VendorNewWizard";
          url += "&status=" + "new";
          if (top.setContent){
             top.setContent('<%=UIUtil.toJavaScript((String)vendorPurchaseListNLS.get("vendorNewGeneralScreenTitle"))%>',
                           url,
                           true);
    
          }else{
            parent.location.replace(url);
          }
        }

    
   function changeVendor(row){
            
    if(row == null){ 
      var vendorId =getCheckedValue("vendorId");
    
      } else {
      var valueArray = row.split(",");
      var vendorId  = valueArray[0];
    
      }
     
      var url = "/webapp/wcs/tools/servlet/NotebookView?XMLFile=inventory.VendorChangeNotebook";
             url += "&status=" + "change";
             url += "&vendorId=" + vendorId;
            
             
             if (top.setContent){
                top.setContent('<%=UIUtil.toJavaScript((String)vendorPurchaseListNLS.get("vendorChangeScreenTitle"))%>',
                              url,
                              true);
       
             }else{
               parent.location.replace(url);
             }
        }
              
        
    function deleteVendor()
       {
             var checked = parent.getChecked();
             
	    
	      	if (checked.length > 0) 
	            {
	              // Set up the delete list
	              var vendorList = "";
	             
	              for(var i=0; i< checked.length; i++)
	              {
	                if (i == 0){
	                  var tokens = checked[i].split(",");
	                  vendorList = "vendorId=" + tokens[0];
	                }else{
	                var tokens = checked[i].split(",");
	                vendorList += "&vendorId=" + tokens[0];
	                }
	                  
	              }
	              
	            }

            var confirmClose = "<%=UIUtil.toJavaScript((String)vendorPurchaseListNLS.get("deleteVendor")) %>";
	    if (confirmDialog(confirmClose)) {
            var redirectURL = "<%="/webapp/wcs/tools/servlet/NewDynamicListView?ActionXMLFile=inventory.VendorList&cmd=VendorListView"%>";
            var url = "/webapp/wcs/tools/servlet/VendorDelete?"
	                            + vendorList
                        + "&URL=" + redirectURL;
            parent.location.replace(url);
     	  }  
     	}
       
        
    function onLoad()
    {
      parent.loadFrames()
    }

function getCheckedValue(value){
    
    
    var checkValues = parent.getChecked();
     var valueArray = checkValues[0].split(",");
    
     var vendorId  = valueArray[0];
     
     var vendorDescription =  valueArray[1];

     if (value == "vendorId"){
          return vendorId;   
    
     }else if (value == "vendorDescription"){
          return vendorDescription ;      
     }
}

// -->
</script>

<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/common/dynamiclist.js"></SCRIPT>

</HEAD>

<BODY onload="onLoad()" CLASS="content">



<%
          int startIndex = Integer.parseInt(request.getParameter("startindex"));
          int listSize = Integer.parseInt(request.getParameter("listsize"));
          int endIndex = startIndex + listSize;
          int rowselect = 1;
          int totalsize = numberOfVendors;
          int totalpage = totalsize/listSize;
%>

 
 


<%-- // Building Menu  --%>
<%=comm.addControlPanel("inventory.VendorPurchase",totalpage,totalsize, localUsed)%>


<FORM NAME="vendorForm">

<%=comm.startDlistTable((String)vendorPurchaseListNLS.get("expectedInventoryDetails")) %>

<%= comm.startDlistRowHeading() %>
<%= comm.addDlistCheckHeading() %>
<%-- //Checkbox row is automatically included --%>   

<%-- //AF 3APRIL2001 These next few rows get the header name from the vendorPurchaseNLS file --%>

<%= comm.addDlistColumnHeading((String)vendorPurchaseListNLS.get("name"), null, false )%>
<%= comm.addDlistColumnHeading((String)vendorPurchaseListNLS.get("description"), null, false  )%>
<%= comm.endDlistRow() %>


<!-- Need to have a for loop to look for all the member groups -->
<%
    VendorDataBean vendorPO;
  
    if (endIndex > numberOfVendors)
      {endIndex = numberOfVendors;
      }

    
    for (int i=startIndex; i<endIndex ; i++) 
    {
      vendorPO = vendorPOs[i];


      
%>

<%=  comm.startDlistRow(rowselect) %>

<!-- CheckBox column added-->

<%= comm.addDlistCheck(vendorPO.getVendorId(),"none" ) %>

<%= comm.addDlistColumn( UIUtil.toHTML(vendorPO.getVendorName()),  "javascript:changeVendor('"+vendorPO.getVendorId()+"');" ) %> 
<%= comm.addDlistColumn( UIUtil.toHTML(vendorPO.getDescription()), "none" ) %> 
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
   if ( numberOfVendors == 0 ){
%>

<br>
<%= (String)vendorPurchaseListNLS.get("vendorsNoRows") %>
<%
   }
%>


</FORM>
<SCRIPT>
  parent.afterLoads();
  parent.setResultssize(getResultsize());
  </SCRIPT>

</BODY>
</HTML>
