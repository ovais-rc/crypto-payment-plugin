<%--
 ===================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (c) Copyright International Business Machines Corporation.
      2007, 2008
      All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 ===================================================================
--%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@page import="java.util.*,java.math.*"%>

<?xml version="1.0" encoding="UTF-8"?>
<%
Map<String,String> roundingDefinitionGrid = new HashMap<String,String>();
Set<String> previewCurrencies = new HashSet<String>();

Enumeration paramNames = request.getParameterNames();
String definingCurrencies="";

while(paramNames.hasMoreElements()){
	String paramName = (String)paramNames.nextElement();
	if((paramName.contains("numberPlaceType")||paramName.contains("numberPlaceValue")||paramName.contains("definingCurrencyCodes"))&&paramName.contains("@")){
	
		if(paramName.contains("definingCurrencyCodes")){
			previewCurrencies.addAll(Arrays.asList(request.getParameter(paramName).split(",")));
			definingCurrencies=request.getParameter(paramName);
		}
		
		String aKey = paramName.split("@")[1];
		String aValue = paramName + "=" + request.getParameter(paramName).replace(",","_");

		if(roundingDefinitionGrid.containsKey(aKey)){
			aValue = aValue +"&"+ roundingDefinitionGrid.get(aKey);
		}
		roundingDefinitionGrid.put(aKey,aValue);
	}
}

String previewInput = request.getParameter("previewInput").trim();

Map<String,BigDecimal> previewResultMap = new HashMap();
if(org.apache.commons.lang.StringUtils.isNotEmpty(previewInput)&&org.apache.commons.lang.StringUtils.isNumeric(previewInput.replace(".", ""))&&roundingDefinitionGrid.size()>0&&previewCurrencies.size()>0){
	BigDecimal previewInputNumber = new BigDecimal(previewInput);
	String roundingDefinitionsString = org.apache.commons.lang.StringUtils.join(roundingDefinitionGrid.values().toArray(new String[0]), ",");
	roundingDefinitionsString=roundingDefinitionsString.replaceAll("PROPERTY_","");
	for(String aCurrency:previewCurrencies){
		Map<Boolean,BigDecimal> aResult = com.ibm.commerce.price.rule.runtime.util.PriceRuleHelper.getInstance().applyRounding(roundingDefinitionsString, definingCurrencies, previewInputNumber, aCurrency);
		if (aResult.containsKey(Boolean.TRUE)){previewResultMap.put(aCurrency, aResult.get(Boolean.TRUE).setScale(2,java.math.BigDecimal.ROUND_FLOOR));}
	}
}
%>
<c:set var="previewResult" value="<%=previewResultMap%>" />
<objects>
	<object objectType="previewResultDataObject">
		<c:forEach items="${previewResult}" var="entry" >
			<${entry.key}>${entry.value}</${entry.key}>
		</c:forEach>
		<randomIdProperty>previewResultDataObject${param.parentId}</randomIdProperty>
	</object>
</objects>