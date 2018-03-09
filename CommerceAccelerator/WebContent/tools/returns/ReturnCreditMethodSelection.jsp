<%--
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
--%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">

<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="java.util.*" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.server.JSPHelper" %>
<%@ page import="com.ibm.commerce.payment.beans.*" %>
<%@ page import="com.ibm.commerce.server.ECConstants" %>

<%@include file="../common/common.jsp" %>
<%
try{
	CommandContext cmdContext = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
	Locale jLocale = cmdContext.getLocale();
	Hashtable returnsNLS = (Hashtable)ResourceDirectory.lookup("returns.ReturnsNLS", jLocale);
	JSPHelper jspHelper = new JSPHelper(request);
	
%>

<HTML>
<HEAD>
<LINK REL="stylesheet" HREF="<%= UIUtil.getCSSFile(jLocale) %>" TYPE="text/css">
<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/common/ConvertToXML.js"></SCRIPT>
<script src="/wcs/javascript/tools/common/Vector.js"></script>
<script src="/wcs/javascript/tools/common/FieldEntryUtil.js"></script>

<SCRIPT>

 ////////////////////////////////////////////////////////
  // Initialize the state of this page                  //
  ////////////////////////////////////////////////////////
  function initializeState() 
  {
  	  
  		if (parent.setContentFrameLoaded) {
      		parent.setContentFrameLoaded(true);
   		}

  }
  
  
      //////////////////////////////////////////////////////////
      // Load the result frame according to the refund method selected
      //////////////////////////////////////////////////////////
      function reloadResultFrame()
      {
        var url;
              
        var selectedOption = document.creditMethodForm.creditMethodSelect.selectedIndex;
   
        if (selectedOption != 0 && selectedOption != 1) {
           var selectedVectorIndex = document.creditMethodForm.creditMethodSelect.options[selectedOption].value;
           var selectedRefundMethod = elementAt(selectedVectorIndex,supportedRefundTCs);
                   
            url = "tools/returns/refundPages/" + selectedRefundMethod.attrPageName + ".jsp";
           
           } else {
           url = "/wcs/tools/common/blank.html";
						        }
        
        	parent.ReturnCreditMethodResult.location.replace(url);      
        
       
      }
  

</SCRIPT>

<TITLE><%= UIUtil.toHTML((String)returnsNLS.get("returnCreditMethodTitle")) %></TITLE>

</HEAD>

<BODY class='content' ONLOAD="initializeState();"> 

<H1><%= UIUtil.toHTML((String)returnsNLS.get("returnCreditMethodTitle")) %></H1>

<DIV><%= (String)returnsNLS.get("returnCreditMethodInstructions") %></DIV><BR><BR>

<%
	String returnId = jspHelper.getParameter("returnId");
	UsableRefundTCListDataBean refundTCs = new UsableRefundTCListDataBean();
	refundTCs.setRmaId(returnId);
	com.ibm.commerce.beans.DataBeanManager.activate(refundTCs, request);

	RefundTCInfo[] refundTCInfo = refundTCs.getRefundTCInfo();
	request.setAttribute("returnsNLS", returnsNLS);
%>
	<script>
     var supportedRefundTCs = new Vector();

<%	
	for (int i = 0; i < refundTCInfo.length; ++i) 
	{
	
		if ( refundTCInfo[i].getAttrPageName() == null || refundTCInfo[i].getAttrPageName().equals("") )
	   		 continue;
	    
    	%>
    	
	     obj = new Object();
	  	 obj.policyId = "<%= refundTCInfo[i].getPolicyId() %>";
 	     obj.policyName = "<%= refundTCInfo[i].getPolicyName() %>";
 	  	 obj.attrPageName = "<%= refundTCInfo[i].getAttrPageName() %>" ;
	     obj.shortDescription = "<%= refundTCInfo[i].getShortDescription() %>";
	     obj.longDescription = "<%= refundTCInfo[i].getLongDescription() %>";

	     addElement(obj, supportedRefundTCs);
	     
       <%
    }
        
%>
	</script>


<FORM name="creditMethodForm">

<!-- Show Refund information for the returnId selected -->
<TABLE border ="0">    
       
    <TR>
    <TD ALIGN="left" VALIGN=middle>
    <LABEL for="creditMethodSelect1"></LABEL>
    <SELECT name="creditMethodSelect" ID="creditMethodSelect1" size="1" onchange="reloadResultFrame()">
       <option selected></option>
       <option selected>---<%= UIUtil.toHTML((String)returnsNLS.get("defaultRefundMethod")) %>---</option>

    <script>
       for (var i=0; i<size(supportedRefundTCs);i++) {
          var refundMethod = elementAt(i,supportedRefundTCs);
          document.writeln('<option value="' + i + '">' + refundMethod.shortDescription + '</option>');
       }
       
       if ( size(supportedRefundTCs) == 0 )
            alertDialog("No supported Refund Methods avialble.");
          
    </script>
    </SELECT>
    </TD>
    </TR>
    
</TABLE>

</FORM>

</BODY>
</HTML>

<%

}catch (Exception e){

	com.ibm.commerce.exception.ExceptionHandler.displayJspException(request, response, e);
	}
%>
