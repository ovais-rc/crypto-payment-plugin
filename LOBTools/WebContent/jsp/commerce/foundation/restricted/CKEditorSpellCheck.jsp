<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2013 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%@page contentType="application/json;charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

{
	"items" : [<c:if test="${!(empty results)}"><c:forEach var="result" items="${results}" varStatus="count">
		{
			"endIndex" : ${result.endIndex},
			"autoCorrectReplacement" : null,
			"beginIndex" : ${result.beginIndex},
			"word" : "${result.word}",
			"suggestions" : ${result.suggestions}
		}<c:if test="${!count.last}">,</c:if></c:forEach></c:if>
	],
	"label" : "word",
	"identifier" : "word"
}
