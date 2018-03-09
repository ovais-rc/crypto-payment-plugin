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
	<c:when test="${(empty param.searchText) && (empty param.taskName) && (empty param.taskCode)
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
					&& (param.typeCompleted == 'false') && (param.taskStatus == '2')}">
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
		<c:if test="${param.workspaceContributor == 'true'}">
			<c:set var="type" value="1"/>
		</c:if>
		<c:if test="${param.workspaceApprover == 'true'}">
			<c:set var="type" value="2"/>
		</c:if>		
		<c:if test="${param.workspaceManager == 'true'}">
			<c:set var="type" value="2"/>
		</c:if>	
		<%-- Decide which expression builder to call based on the input --%>
		<c:choose>
			<c:when test="${!(empty param.searchText)}">
				<c:set var="expressionBuilderName" value="findTaskBasicSearch"/>
				<c:set var="identifier" value="${param.searchText}"/>
				<c:set var="name" value="${param.searchText}"/>				
			</c:when>

			<c:otherwise>
				<c:set var="expressionBuilderName" value="findTaskAdvancedSearch"/>
				<c:set var="identifier" value="${param.taskCode}"/>
				<c:set var="name" value="${param.taskName}"/>
							
				<c:if test="${param.taskStatus == '2'}">
					<c:if test="${param.typeInactive == 'true'}">
						<c:set var="typeInactive" value="0"/>					
					</c:if>
					<c:if test="${param.typeWorking == 'true'}">
						<c:set var="typeWorking" value="1"/>					
					</c:if>
					<c:if test="${param.typeCompleted == 'true'}">
						<c:set var="typeCompleted" value="2"/>					
					</c:if>					
					<c:set var="status" value="${typeInactive},${typeWorking},${typeCompleted}"/>
				</c:if>				
			</c:otherwise>
		</c:choose>
					
	   	<wcf:getData type="com.ibm.commerce.content.facade.datatypes.TaskType[]"
			var="tasks"
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
			<wcf:param name="type" value="${type}"/>
						
		</wcf:getData>

		<objects recordSetCompleteIndicator="${showVerb.recordSetCompleteIndicator}"
			recordSetReferenceId="${showVerb.recordSetReferenceId}" 
		 	recordSetStartNumber="${showVerb.recordSetStartNumber}"
		 	recordSetCount="${showVerb.recordSetCount}"
		 	recordSetTotal="${showVerb.recordSetTotal}">

    		<c:forEach var="task" items="${tasks}">
				<jsp:directive.include file="SerializeTask.jspf"/>
    		</c:forEach>
 		</objects>

	</c:otherwise>
</c:choose>	