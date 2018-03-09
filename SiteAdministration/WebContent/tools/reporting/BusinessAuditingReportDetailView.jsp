<%
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* 5697-D24
//*
//* (c) Copyright IBM Corp. 2000, 2002, 2003, 2004
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
//*
 %> 

<%@page import="java.util.*" %>
<%@page import= "com.ibm.commerce.event.businessaudit.beans.BusinessAuditDataBean"%>
<%@page import= "com.ibm.commerce.datatype.TypedProperty"%>
<%@page import= "com.ibm.commerce.server.JSPHelper"%>

<%@include file="common.jsp"%>

<HTML>
   <HEAD>	
     <%=fHeader%>		 
   </HEAD>

   <BODY CLASS=content ONLOAD="javascript:parent.setContentFrameLoaded(true)">	
	<%
	JSPHelper jspHelper = new JSPHelper(request);
   	String record_id = jspHelper.getParameter("busaudit_id").trim();

	String strRow = "<tr>";
	String endRow = "</tr>";
	String strCell = "<td>";
	String endCell = "</td>";	
	String blank  = "&nbsp";	
	try {
		out.print("<h1>" + reportsRB.get("BusinessAuditingDetailRecordId") + blank + record_id + "</h1><br>");		
		com.ibm.commerce.event.businessaudit.beans.BusinessAuditDataBean businessAuditBean = new com.ibm.commerce.event.businessaudit.beans.BusinessAuditDataBean();
		com.ibm.commerce.datatype.TypedProperty tp = new com.ibm.commerce.datatype.TypedProperty();
		tp.put(com.ibm.commerce.event.businessaudit.beans.BusinessAuditDataBean.PARAM_QUERY, "BUSAUDIT_ID=" + record_id + " ORDER BY SESSION_ID, SEQUENCE");
		businessAuditBean.setRequestProperties(tp);
		businessAuditBean.populate();
		
		// BUSAUDIT_ID|SESSION_ID|SEQUENCE|USERS_ID|FOR_USER_ID|AUDIT_TIMESTAMP|EVENT_TYPE|SIGNATURE|STORE_ID|
		// OCCURENCE|COMMAND_NAME|SEARCH_FIELD1|SEARCH_FIELD2|SEARCH_FIELD3|SEARCH_FIELD4|SEARCH_FIELD5|PARAMETERS_NAME|PARAMETER_VALUE	
		
		if (businessAuditBean.size() > 0) {					
			boolean flag = true;
			com.ibm.commerce.event.businessaudit.beans.BusinessAuditParameterDataBean businessAuditParameterDataBean = businessAuditBean.getAttributes(0);
			if (businessAuditParameterDataBean != null && businessAuditParameterDataBean.size() > 0) {
				if ((businessAuditBean.getOccurence(0).trim()).equals("1")) out.print("<p><b>"+ reportsRB.get("BusinessAuditingExceptionMsg") + "</b></p>");							
				else out.print("<p><b>"+ reportsRB.get("BusinessAuditingEntryMsg") + "</b></p>");	
				out.print("<p><b>" + reportsRB.get("BusinessAuditingDetailCommandMsg") + "</b>" + blank + businessAuditBean.getCommandName(0) + "</p>");
				out.print("<table><TR CLASS=list_header>");
				out.print("<TH align='left'><b>" + reportsRB.get("BusinessAuditingParmNameColumnTitle") + "</b></TH><TH align='left'><b>" + reportsRB.get("BusinessAuditingParmValColumnTitle") + "</b></TH></tr>");
				for (int k=0; k < businessAuditParameterDataBean.size(); k++) {
					if (flag) out.print("<TR CLASS=list_row1>" + strCell);
					else out.print("<TR CLASS=list_row2>" + strCell);	
					out.print(businessAuditParameterDataBean.getParameterName(k));
					out.print(blank + endCell + strCell);
					String parametervalue = new String(businessAuditParameterDataBean.getParameterValue(k));
					for(int index =0; index < parametervalue.length(); index++){
						if(parametervalue.charAt(index) == '<')
							parametervalue = parametervalue.replaceAll("<", "&lt;");
						else if(parametervalue.charAt(index) == '>')
							parametervalue = parametervalue.replaceAll(">", "&gt;");
						else continue;
					}
					out.print(parametervalue);
					out.println(blank + endCell + endRow);
					if (flag) flag = false;
					else flag = true;
				}
				out.print("</table>");	
			} 
			else {											
				out.print(reportsRB.get("BusinessAuditingDetailNoParametersMsg")); 	
			}
		}
		else {													
				out.print(reportsRB.get("BusinessAuditingDetailUnableToGetMsg")); 	
		}
		
	} catch (Exception e) {
		e.printStackTrace();
	}
%>
	<SCRIPT>
	function printButton()
	{
       parent.CONTENTS.window.focus();
       parent.CONTENTS.window.print();
    }
    function okButton()
	{
       top.goBack();
	}
	</SCRIPT>
   </BODY>

</HTML>
