<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2011 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<%@page contentType="text/xml;charset=UTF-8"%> 
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://commerce.ibm.com/foundation" prefix="wcf"%>


<c:choose>
	<c:when test="${(empty param.searchText) && (empty param.taskGroupName) && (empty param.taskGroupCode)
					&& (empty param.dueDateFrom) && (empty param.dueDateTo)}">	
		<%-- No search criteria is specified --%>
		<objects
			recordSetCompleteIndicator="true"
		 	recordSetReferenceId=""
			recordSetStartNumber=""
			recordSetCount="0"
			recordSetTotal="0">
		</objects> 
	</c:when>

	<c:when test="${(empty param.searchText) && (param.typeInactive == 'false') && (param.typeWorking == 'false')
					&& (param.typeReadyForApprove == 'false') && (param.typeCompleted == 'false')
					&& (param.typeApproved == 'false') && (param.typeCanceled == 'false') && (param.taskGroupStatus == '2')}">
		<objects
			recordSetCompleteIndicator="true"
			recordSetReferenceId=""
			recordSetStartNumber=""
			recordSetCount="0"
			recordSetTotal="0">
		</objects>
	</c:when>

	<c:when test="${(param.wrongDate == 'true')}">
		<%-- wrong due date is specified --%>
		<objects
			recordSetCompleteIndicator="true"
		 	recordSetReferenceId=""
			recordSetStartNumber=""
			recordSetCount="0"
			recordSetTotal="0">
		</objects> 
	</c:when>
			
	<c:otherwise>
		<%-- Decide which expression builder to call based on the input --%>
		<c:choose>
			<c:when test="${!(empty param.searchText)}">
				<c:set var="expressionBuilderName" value="findTaskGroupBasicSearch"/>
				<c:set var="identifier" value="${param.searchText}"/>
				<c:set var="name" value="${param.searchText}"/>				
			</c:when>

			<c:otherwise>
				<c:set var="expressionBuilderName" value="findTaskGroupAdvancedSearch"/>
				
				<c:set var="identifier" value="${param.taskGroupCode}"/>
				<c:set var="name" value="${param.taskGroupName}"/>
					
				<c:if test="${param.taskGroupStatus == '2'}">
					<c:if test="${param.typeInactive == 'true'}">
						<c:set var="typeInactive" value="0"/>					
					</c:if>
					<c:if test="${param.typeWorking == 'true'}">
						<c:set var="typeWorking" value="1"/>					
					</c:if>
					<c:if test="${param.typeReadyForApprove == 'true'}">
						<c:set var="typeReadyForApprove" value="2"/>					
					</c:if>
					<c:if test="${param.typeCompleted == 'true'}">
						<c:set var="typeCompleted" value="5"/>					
					</c:if>
					<c:if test="${param.typeApproved == 'true'}">
						<c:set var="typeApproved" value="3"/>					
					</c:if>
					<c:if test="${param.typeCanceled == 'true'}">
						<c:set var="typeCanceled" value="6"/>					
					</c:if>
			
					<c:set var="status" value="${typeInactive},${typeWorking},${typeReadyForApprove},${typeCompleted},${typeApproved}, ${typeCanceled}"/>

				</c:if>				
			</c:otherwise>
		</c:choose>
					
	   	<wcf:getData type="com.ibm.commerce.content.facade.datatypes.TaskGroupType[]"
			var="taskGroups"
			expressionBuilder="${expressionBuilderName}"
			varShowVerb="showVerb"
			recordSetStartNumber="${param.recordSetStartNumber}"
			recordSetReferenceId="${param.recordSetReferenceId}"
			maxItems="${param.maxItems}">

			<wcf:param name="identifier" value="${identifier}"/>
			<wcf:param name="name" value="${name}"/>
			<wcf:param name="from" value="${param.dueDateFrom}"/>
			<wcf:param name="to" value="${param.dueDateTo}"/>			
			<wcf:param name="status" value="${status}"/>
						
		</wcf:getData>	

		<objects recordSetCompleteIndicator="${showVerb.recordSetCompleteIndicator}"
			recordSetReferenceId="${showVerb.recordSetReferenceId}" 
		 	recordSetStartNumber="${showVerb.recordSetStartNumber}"
		 	recordSetCount="${showVerb.recordSetCount}"
		 	recordSetTotal="${showVerb.recordSetTotal}">
		 	
    		<c:forEach var="taskGroup" items="${taskGroups}">
   				<jsp:directive.include file="SerializeTaskGroup.jspf"/>   					
    		</c:forEach>		
 		</objects>


	</c:otherwise>
</c:choose>	