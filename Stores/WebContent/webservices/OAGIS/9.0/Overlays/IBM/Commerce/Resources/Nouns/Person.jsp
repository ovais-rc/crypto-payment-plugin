<%--==========================================================================
Licensed Materials - Property of IBM

WebSphere Commerce

(c) Copyright IBM Corp.  2006
All Rights Reserved

US Government Users Restricted Rights - Use, duplication or
disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
===========================================================================--%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

    <mbr:Person xmlns:mbr="http://www.ibm.com/xmlns/prod/commerce/member"
    	xmlns:wcf="http://www.ibm.com/xmlns/prod/commerce/foundation">	    	
			<mbr:PersonIdentifier>
				<wcf:UniqueID><c:out value="${RequestProperties.userId}"/></wcf:UniqueID>
			</mbr:PersonIdentifier>
    </mbr:Person>
