<!--==========================================================================
Licensed Materials - Property of IBM

WebSphere Commerce

(c) Copyright IBM Corp.  2005
All Rights Reserved

US Government Users Restricted Rights - Use, duplication or
disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
===========================================================================-->
<%
	com.ibm.commerce.beans.ErrorDataBean errorBean = new com.ibm.commerce.beans.ErrorDataBean ();
	com.ibm.commerce.beans.DataBeanManager.activate(errorBean, request, response);
	System.out.println ("ErrorDataBean:\n" + errorBean.toString()+"\n");
	String message = errorBean.getSystemMessage();
	if(message == null || message.trim().length() == 0) {
		message = errorBean.getMessage();
	}
%><soapenv:Fault xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/">
	<faultcode>soapenv:Server</faultcode>
	<faultstring><%= message %></faultstring>
	<faultactor><%= errorBean.getOriginatingCommand() %></faultactor>
</soapenv:Fault>