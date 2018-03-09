<%--==========================================================================
Licensed Materials - Property of IBM

WebSphere Commerce

(c) Copyright IBM Corp.  2006
All Rights Reserved

US Government Users Restricted Rights - Use, duplication or
disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
===========================================================================--%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase"%>
<wcbase:useBean id="error"
	classname="com.ibm.commerce.beans.ErrorDataBean" scope="request" />
<oa:ConfirmBOD releaseID="9.0"
	xmlns:oa="http://www.openapplications.org/oagis/9"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xsi:schemaLocation="http://www.openapplications.org/oagis/9 ConfirmBOD.xsd ">
	<jsp:include page="../Resources/Components/Common/ApplicationArea.jsp" flush="true"/>
	<oa:DataArea>
		<oa:Confirm>
			<c:if test="${!empty error.exceptionType}">
				<jsp:include page="../Resources/Components/Common/ResponseCriteria.jsp" flush="true"/>
			</c:if>
		</oa:Confirm>
		<oa:BOD>
			<jsp:include page="../Resources/Components/Common/OriginalApplicationArea.jsp" flush="true"/>
			<c:if test="${empty error.exceptionType}">
				<oa:BODSuccessMessage>
				<c:if test="${!empty RequestProperties.successUserArea}">
					<oa:UserArea>
						<c:import url="${RequestProperties.successUserArea}"/>
					</oa:UserArea>
				</c:if>
				</oa:BODSuccessMessage>
			</c:if>
			<c:if test="${!empty error.exceptionType}">
				<oa:BODFailureMessage>
					<oa:ErrorProcessMessage>
						<oa:ID>
							<c:out value="${error.correlationIdentifier}" />
						</oa:ID>
						<oa:Description>
							<c:out value="${error.message}" escapeXml="false"/>
						</oa:Description>
						<oa:Note>
							<c:out value="${error.correctiveActionMessage}" escapeXml="false" />
						</oa:Note>
						<oa:Type>
							<c:out value="${error.exceptionType}" />
						</oa:Type>
						<oa:ReasonCode>
							<c:out value="${error.errorCode}" />
						</oa:ReasonCode>
					</oa:ErrorProcessMessage>
				</oa:BODFailureMessage>
			</c:if>
		</oa:BOD>
	</oa:DataArea>
</oa:ConfirmBOD>