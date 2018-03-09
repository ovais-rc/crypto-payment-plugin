<%--============================================================================

   The sample Templates, HTML and Macros are furnished by IBM as simple
examples to provide an illustration. These examples have not been
thoroughly tested under all conditions. IBM, therefore, cannot guarantee
reliability, serviceability or function of these programs. All programs
contained herein are provided to you "AS IS".

   The sample Templates, HTML and Macros may include the names of individuals,
companies, brands and products in order to illustrate them as completely as
possible. All of these are names are ficticious and any similarity to the
names and addresses used by actual persons or business enterprises is entirely
coincidental.

Licensed Materials - Property of IBM

5697-D24	5798-NC3

(c) Copyright IBM Corp. 1997, 2002

US Government Users Restricted Rights - Use, duplication or
disclosure restricted by GSA ADP Schedule Contract with IBM Corp

==============================================================================--%><%@ 
page import="javax.servlet.*,
java.io.*,
java.util.*,
com.ibm.commerce.server.*,
com.ibm.commerce.command.*,
com.ibm.commerce.beans.*,
com.ibm.commerce.datatype.*,
com.ibm.commerce.common.objects.*,
com.ibm.commerce.common.objimpl.*,
com.ibm.commerce.common.beans.*,
com.ibm.commerce.user.beans.*,
com.ibm.commerce.user.objects.*"%><%
try {
	out.println("Your Reseller Organization has been approved by the site administrator.");
} catch (Exception e) {
	out.print( "Exception " + e);
}
%>