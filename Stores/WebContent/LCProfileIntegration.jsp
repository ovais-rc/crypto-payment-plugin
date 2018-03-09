<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2008 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%@page import="java.util.*,
  com.ibm.commerce.server.JSPHelper,
  com.ibm.commerce.member.constants.ECMemberConstants,
  com.ibm.commerce.socialcommerce.util.Hex,
  com.ibm.commerce.usermanagement.vcardintegration.util.ECLotusConnectionIntegrationConstants"
%>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import "com.ibm.commerce.ras.ECTrace"%>
<%@ page import "com.ibm.commerce.ras.ECTraceIdentifiers"%>
<%
	final boolean bTraceEnabled = ECTrace.traceEnabled(ECTraceIdentifiers.COMPONENT_MESSAGING);
	final String EMPTY_STRING = "";

	if (bTraceEnabled) {
		ECTrace.entry(ECTraceIdentifiers.COMPONENT_MESSAGING,"LCProfileIntegraion.jsp"," ");
	}

	JSPHelper jsphelper = new JSPHelper(request);

	String firstName = jsphelper.getParameter(ECMemberConstants.EC_ADDR_FIRSTNAME);
	if (firstName == null) {
		firstName = EMPTY_STRING;
	}
	String lastName = jsphelper.getParameter(ECMemberConstants.EC_ADDR_LASTNAME);
	if (lastName == null) {
		lastName = EMPTY_STRING;
	}
	String email = jsphelper.getParameter(ECMemberConstants.EC_ADDR_EMAIL1);
	if (email == null) {
		email = EMPTY_STRING;
	}
	String uid = jsphelper.getParameter(ECMemberConstants.EC_UREG_LOGONID).toLowerCase();
	String rdn = null;
	if (uid == null) {
		uid = EMPTY_STRING;
		rdn = EMPTY_STRING;
	} else {
	    rdn = Hex.getMD5UidFromLdapDn(uid);
	}

	String birthday = jsphelper.getParameter(ECLotusConnectionIntegrationConstants.EC_MEMBER_BIRTHDAY);
	if (birthday == null) {
		birthday = EMPTY_STRING;
	}
	String occupation = jsphelper.getParameter(ECLotusConnectionIntegrationConstants.EC_MEMBER_OCCUPATION);
	if (occupation == null) {
		occupation = EMPTY_STRING;
	}
	String screenName = jsphelper.getParameter(ECLotusConnectionIntegrationConstants.EC_MEMBER_SCREEN_NAME);
	if (screenName == null) {
		screenName = EMPTY_STRING;
	}
	String location = jsphelper.getParameter(ECLotusConnectionIntegrationConstants.EC_MEMBER_LOCATION);
	if (location == null) {
		location = EMPTY_STRING;
	}
	String interests = jsphelper.getParameter(ECLotusConnectionIntegrationConstants.EC_MEMBER_INTERESTS);
	if (interests == null) {
		interests = EMPTY_STRING;
	}

	if (bTraceEnabled) {
		ECTrace.trace(ECTraceIdentifiers.COMPONENT_MESSAGING,"LCProfileIntegraion.jsp"," ", "screenName= "+screenName);
		ECTrace.trace(ECTraceIdentifiers.COMPONENT_MESSAGING,"LCProfileIntegraion.jsp"," ", "lastName= "+lastName);
		ECTrace.trace(ECTraceIdentifiers.COMPONENT_MESSAGING,"LCProfileIntegraion.jsp"," ", "firstName= "+firstName);
		ECTrace.trace(ECTraceIdentifiers.COMPONENT_MESSAGING,"LCProfileIntegraion.jsp"," ", "email= "+email);
		ECTrace.trace(ECTraceIdentifiers.COMPONENT_MESSAGING,"LCProfileIntegraion.jsp"," ", "rdn= "+rdn);
		ECTrace.trace(ECTraceIdentifiers.COMPONENT_MESSAGING,"LCProfileIntegraion.jsp"," ", "uid= "+uid);
		ECTrace.trace(ECTraceIdentifiers.COMPONENT_MESSAGING,"LCProfileIntegraion.jsp"," ", "birthday= "+birthday);
		ECTrace.trace(ECTraceIdentifiers.COMPONENT_MESSAGING,"LCProfileIntegraion.jsp"," ", "occupation= "+occupation);
		ECTrace.trace(ECTraceIdentifiers.COMPONENT_MESSAGING,"LCProfileIntegraion.jsp"," ", "location= "+location);
		ECTrace.trace(ECTraceIdentifiers.COMPONENT_MESSAGING,"LCProfileIntegraion.jsp"," ", "interests= "+interests);
	}

	// extra fields required by vCard but not on the jsp
	String lc_altLastName = jsphelper.getParameter(ECLotusConnectionIntegrationConstants.EC_ALTERNATE_LAST_NAME);
	if (lc_altLastName == null) {
		lc_altLastName = EMPTY_STRING;
	}
	String lc_blogURL = jsphelper.getParameter(ECLotusConnectionIntegrationConstants.EC_BLOG_URL);
	if (lc_blogURL == null) {
		lc_blogURL = EMPTY_STRING;
	}
	String lc_calendarURL = jsphelper.getParameter(ECLotusConnectionIntegrationConstants.EC_CALENDAR_URL);
	if (lc_calendarURL == null) {
		lc_calendarURL = EMPTY_STRING;
	}
	String lc_freebusyURL = jsphelper.getParameter(ECLotusConnectionIntegrationConstants.EC_FREEBUSY_URL);
	if (lc_freebusyURL == null) {
		lc_freebusyURL = EMPTY_STRING;
	}
	String lc_honorificPrefix = jsphelper.getParameter(ECLotusConnectionIntegrationConstants.EC_HONORIFIC_PREFIX);
	if (lc_honorificPrefix == null) {
		lc_honorificPrefix = EMPTY_STRING;
	}
	String lc_deptNumber = jsphelper.getParameter(ECLotusConnectionIntegrationConstants.EC_DEPT_NUMBER);
	if (lc_deptNumber == null) {
		lc_deptNumber = EMPTY_STRING;
	}
	String lc_empNumber = jsphelper.getParameter(ECLotusConnectionIntegrationConstants.EC_EMP_NUMBER);
	if (lc_empNumber == null) {
		lc_empNumber = EMPTY_STRING;
	}
	String lc_empType = jsphelper.getParameter(ECLotusConnectionIntegrationConstants.EC_EMP_TYPE);
	if (lc_empType == null) {
		lc_empType = EMPTY_STRING;
	}
	String lc_building = jsphelper.getParameter(ECLotusConnectionIntegrationConstants.EC_BUILDING);
	if (lc_building == null) {
		lc_building = EMPTY_STRING;
	}
	String lc_floor = jsphelper.getParameter(ECLotusConnectionIntegrationConstants.EC_FLOOR);
	if (lc_floor == null) {
		lc_floor = EMPTY_STRING;
	}
	String lc_groupwareEmail = jsphelper.getParameter(ECLotusConnectionIntegrationConstants.EC_GROUPWARE_EMAIL);
	if (lc_groupwareEmail == null) {
		lc_groupwareEmail = EMPTY_STRING;
	}
	String lc_telFax = jsphelper.getParameter(ECLotusConnectionIntegrationConstants.EC_TEL_FAX);
	if (lc_telFax == null) {
		lc_telFax = EMPTY_STRING;
	}
	String lc_telWork = jsphelper.getParameter(ECLotusConnectionIntegrationConstants.EC_TEL_WORK);
	if (lc_telWork == null) {
		lc_telWork = EMPTY_STRING;
	}
	String lc_telXIP = jsphelper.getParameter(ECLotusConnectionIntegrationConstants.EC_TEL_X_IP);
	if (lc_telXIP == null) {
		lc_telXIP = EMPTY_STRING;
	}
	String lc_telCell = jsphelper.getParameter(ECLotusConnectionIntegrationConstants.EC_TEL_CELL);
	if (lc_telCell == null) {
		lc_telCell = EMPTY_STRING;
	}
	String lc_telPager = jsphelper.getParameter(ECLotusConnectionIntegrationConstants.EC_TEL_PAGER);
	if (lc_telPager == null) {
		lc_telPager = EMPTY_STRING;
	}
	String lc_pagerId = jsphelper.getParameter(ECLotusConnectionIntegrationConstants.EC_PAGER_ID);
	if (lc_pagerId == null) {
		lc_pagerId = EMPTY_STRING;
	}
	String lc_pagerProvider = jsphelper.getParameter(ECLotusConnectionIntegrationConstants.EC_PAGER_PROVIDER);
	if (lc_pagerProvider == null) {
		lc_pagerProvider = EMPTY_STRING;
	}
	String lc_pagerType = jsphelper.getParameter(ECLotusConnectionIntegrationConstants.EC_PAGER_TYPE);
	if (lc_pagerType == null) {
		lc_pagerType = EMPTY_STRING;
	}
	String lc_countryCode = jsphelper.getParameter(ECLotusConnectionIntegrationConstants.EC_COUNTRY_CODE);
	if (lc_countryCode == null) {
		lc_countryCode = EMPTY_STRING;
	}
	String lc_manager = jsphelper.getParameter(ECLotusConnectionIntegrationConstants.EC_MANAGER);
	if (lc_manager == null) {
		lc_manager = EMPTY_STRING;
	}
	String lc_nativeFirstname = jsphelper.getParameter(ECLotusConnectionIntegrationConstants.EC_NATIVE_FIRST_NAME);
	if (lc_nativeFirstname == null) {
		lc_nativeFirstname = EMPTY_STRING;
	}
	String lc_nativeLastname = jsphelper.getParameter(ECLotusConnectionIntegrationConstants.EC_NATIVE_LAST_NAME);
	if (lc_nativeLastname == null) {
		lc_nativeLastname = EMPTY_STRING;
	}
	String lc_officeNumber = jsphelper.getParameter(ECLotusConnectionIntegrationConstants.EC_OFFICE_NUMBER);
	if (lc_officeNumber == null) {
		lc_officeNumber = EMPTY_STRING;
	}
	String lc_nickname = jsphelper.getParameter(ECLotusConnectionIntegrationConstants.EC_NICKNAME);
	if (lc_nickname == null) {
		lc_nickname = EMPTY_STRING;
	}
	String lc_preferredLang = jsphelper.getParameter(ECLotusConnectionIntegrationConstants.EC_PREFERRED_LANG);
	if (lc_preferredLang == null) {
		lc_preferredLang = EMPTY_STRING;
	}
	String lc_preferredLastname = jsphelper.getParameter(ECLotusConnectionIntegrationConstants.EC_PREFERRED_LAST_NAME);
	if (lc_preferredLastname == null) {
		lc_preferredLastname = EMPTY_STRING;
	}
	String lc_shift = jsphelper.getParameter(ECLotusConnectionIntegrationConstants.EC_SHIFT);
	if (lc_shift == null) {
		lc_shift = EMPTY_STRING;
	}
	String lc_timezone = jsphelper.getParameter(ECLotusConnectionIntegrationConstants.EC_TIMEZONE);
	if (lc_timezone == null) {
		lc_timezone = EMPTY_STRING;
	}

	if (bTraceEnabled)  {
		ECTrace.trace(ECTraceIdentifiers.COMPONENT_MESSAGING,"LCProfileIntegraion.jsp"," ", "lc_altLastName= "+lc_altLastName);
		ECTrace.trace(ECTraceIdentifiers.COMPONENT_MESSAGING,"LCProfileIntegraion.jsp"," ", "lc_blogURL= "+lc_blogURL);
		ECTrace.trace(ECTraceIdentifiers.COMPONENT_MESSAGING,"LCProfileIntegraion.jsp"," ", "lc_calendarURL= "+lc_calendarURL);
		ECTrace.trace(ECTraceIdentifiers.COMPONENT_MESSAGING,"LCProfileIntegraion.jsp"," ", "lc_freebusyURL= "+lc_freebusyURL);
		ECTrace.trace(ECTraceIdentifiers.COMPONENT_MESSAGING,"LCProfileIntegraion.jsp"," ", "lc_honorificPrefix= "+lc_honorificPrefix);
		ECTrace.trace(ECTraceIdentifiers.COMPONENT_MESSAGING,"LCProfileIntegraion.jsp"," ", "lc_deptNumber= "+lc_deptNumber);
		ECTrace.trace(ECTraceIdentifiers.COMPONENT_MESSAGING,"LCProfileIntegraion.jsp"," ", "lc_empNumber= "+lc_empNumber);
		ECTrace.trace(ECTraceIdentifiers.COMPONENT_MESSAGING,"LCProfileIntegraion.jsp"," ", "lc_empType= "+lc_empType);
		ECTrace.trace(ECTraceIdentifiers.COMPONENT_MESSAGING,"LCProfileIntegraion.jsp"," ", "lc_building= "+lc_building);
		ECTrace.trace(ECTraceIdentifiers.COMPONENT_MESSAGING,"LCProfileIntegraion.jsp"," ", "lc_floor= "+lc_floor);
		ECTrace.trace(ECTraceIdentifiers.COMPONENT_MESSAGING,"LCProfileIntegraion.jsp"," ", "lc_groupwareEmail= "+lc_groupwareEmail);
		ECTrace.trace(ECTraceIdentifiers.COMPONENT_MESSAGING,"LCProfileIntegraion.jsp"," ", "lc_telFax= "+lc_telFax);
		ECTrace.trace(ECTraceIdentifiers.COMPONENT_MESSAGING,"LCProfileIntegraion.jsp"," ", "lc_telWork= "+lc_telWork);
		ECTrace.trace(ECTraceIdentifiers.COMPONENT_MESSAGING,"LCProfileIntegraion.jsp"," ", "lc_telXIP= "+lc_telXIP);
		ECTrace.trace(ECTraceIdentifiers.COMPONENT_MESSAGING,"LCProfileIntegraion.jsp"," ", "lc_telCell= "+lc_telCell);
		ECTrace.trace(ECTraceIdentifiers.COMPONENT_MESSAGING,"LCProfileIntegraion.jsp"," ", "lc_telPager= "+lc_telPager);
		ECTrace.trace(ECTraceIdentifiers.COMPONENT_MESSAGING,"LCProfileIntegraion.jsp"," ", "lc_pagerId= "+lc_pagerId);
		ECTrace.trace(ECTraceIdentifiers.COMPONENT_MESSAGING,"LCProfileIntegraion.jsp"," ", "lc_pagerProvider= "+lc_pagerProvider);
		ECTrace.trace(ECTraceIdentifiers.COMPONENT_MESSAGING,"LCProfileIntegraion.jsp"," ", "lc_pagerType= "+lc_pagerType);
		ECTrace.trace(ECTraceIdentifiers.COMPONENT_MESSAGING,"LCProfileIntegraion.jsp"," ", "lc_countryCode= "+lc_countryCode);
		ECTrace.trace(ECTraceIdentifiers.COMPONENT_MESSAGING,"LCProfileIntegraion.jsp"," ", "lc_manager= "+lc_manager);
		ECTrace.trace(ECTraceIdentifiers.COMPONENT_MESSAGING,"LCProfileIntegraion.jsp"," ", "lc_nativeFirstname= "+lc_nativeFirstname);
		ECTrace.trace(ECTraceIdentifiers.COMPONENT_MESSAGING,"LCProfileIntegraion.jsp"," ", "lc_nativeLastname= "+lc_nativeLastname);
		ECTrace.trace(ECTraceIdentifiers.COMPONENT_MESSAGING,"LCProfileIntegraion.jsp"," ", "lc_officeNumber= "+lc_officeNumber);
		ECTrace.trace(ECTraceIdentifiers.COMPONENT_MESSAGING,"LCProfileIntegraion.jsp"," ", "lc_nickname= "+lc_nickname);
		ECTrace.trace(ECTraceIdentifiers.COMPONENT_MESSAGING,"LCProfileIntegraion.jsp"," ", "lc_preferredLang= "+lc_preferredLang);
		ECTrace.trace(ECTraceIdentifiers.COMPONENT_MESSAGING,"LCProfileIntegraion.jsp"," ", "lc_preferredLastname= "+lc_preferredLastname);
		ECTrace.trace(ECTraceIdentifiers.COMPONENT_MESSAGING,"LCProfileIntegraion.jsp"," ", "lc_shift= "+lc_shift);
		ECTrace.trace(ECTraceIdentifiers.COMPONENT_MESSAGING,"LCProfileIntegraion.jsp"," ", "lc_timezone= "+lc_timezone);
	}

	// extension fields
	String lc_field1 = jsphelper.getParameter(ECLotusConnectionIntegrationConstants.EC_EXT_FIELD1);
	if (lc_field1 == null) {
		lc_field1 = EMPTY_STRING;
	}
	String lc_field2 = jsphelper.getParameter(ECLotusConnectionIntegrationConstants.EC_EXT_FIELD2);
	if (lc_field2 == null) {
		lc_field2 = EMPTY_STRING;
	}
	String lc_field3 = jsphelper.getParameter(ECLotusConnectionIntegrationConstants.EC_EXT_FIELD3);
	if (lc_field3 == null) {
		lc_field3 = EMPTY_STRING;
	}
	String lc_field4 = jsphelper.getParameter(ECLotusConnectionIntegrationConstants.EC_EXT_FIELD4);
	if (lc_field4 == null) {
		lc_field4 = EMPTY_STRING;
	}
	String lc_field5 = jsphelper.getParameter(ECLotusConnectionIntegrationConstants.EC_EXT_FIELD5);
	if (lc_field5 == null) {
		lc_field5 = EMPTY_STRING;
	}

	if (bTraceEnabled)  {
		ECTrace.trace(ECTraceIdentifiers.COMPONENT_MESSAGING,"LCProfileIntegraion.jsp"," ", "lc_field1= "+lc_field1);
		ECTrace.trace(ECTraceIdentifiers.COMPONENT_MESSAGING,"LCProfileIntegraion.jsp"," ", "lc_field2= "+lc_field2);
		ECTrace.trace(ECTraceIdentifiers.COMPONENT_MESSAGING,"LCProfileIntegraion.jsp"," ", "lc_field3= "+lc_field3);
		ECTrace.trace(ECTraceIdentifiers.COMPONENT_MESSAGING,"LCProfileIntegraion.jsp"," ", "lc_field4= "+lc_field4);
		ECTrace.trace(ECTraceIdentifiers.COMPONENT_MESSAGING,"LCProfileIntegraion.jsp"," ", "lc_field5= "+lc_field5);

		ECTrace.exit(ECTraceIdentifiers.COMPONENT_MESSAGING,"LCProfileIntegraion.jsp"," ");
	}
%>

<?xml version="1.0" encoding="UTF-8"?>
<entry>
<category scheme="http://www.ibm.com/xmlns/prod/sn/type" term="profile"/>
<content type="text">
BEGIN:VCARD
VERSION:2.1
FN:<%=screenName%>
N:<%=lastName%>; <%=firstName%>;
EMAIL;INTERNET:<%=email%>
X_LCONN_USER_ID:<%=rdn%>
X_PROFILE_UID:<%=uid%>
X_DESCRIPTION:<%=birthday%>
TITLE:<%=occupation%>
X_ORGANIZATION_CODE:<%=location%>
X_EXPERIENCE:<%=interests%>

X_ALTERNATE_LAST_NAME:<%=lc_altLastName%>
X_BLOG_URL;VALUE=URL:<%=lc_blogURL%>
X_CALENDAR_URL;VALUE=URL:<%=lc_calendarURL%>
X_FREEBUSY_URL;VALUE=URL:<%=lc_freebusyURL%>
HONORIFIC_PREFIX:<%=lc_honorificPrefix%>
X_DEPARTMENT_NUMBER:<%=lc_deptNumber%>
X_EMPLOYEE_NUMBER:<%=lc_empNumber%>
X_EMPTYPE:<%=lc_empType%>
X_BUILDING:<%=lc_building%>
X_FLOOR:<%=lc_floor%>
EMAIL;X_GROUPWARE_EMAIL:<%=lc_groupwareEmail%>
TEL;FAX:<%=lc_telFax%>
TEL;WORK:<%=lc_telWork%>
TEL;X_IP:<%=lc_telXIP%>
TEL;CELL:<%=lc_telCell%>
TEL;PAGER:<%=lc_telPager%>
X_PAGER_ID:<%=lc_pagerId%>
X_PAGER_PROVIDER:<%=lc_pagerProvider%>
X_PAGER_TYPE:<%=lc_pagerType%>
X_COUNTRY_CODE:<%=lc_countryCode%>
X_IS_MANAGER:<%=lc_manager%>
X_NATIVE_FIRST_NAME:<%=lc_nativeFirstname%>
X_NATIVE_LAST_NAME:<%=lc_nativeLastname%>
X_OFFICE_NUMBER:<%=lc_officeNumber%>
NICKNAME:<%=lc_nickname%>
X_PREFERRED_LANGUAGE:<%=lc_preferredLang%>
X_PREFERRED_LAST_NAME:<%=lc_preferredLastname%>
X_SHIFT:<%=lc_shift%>
TZ:<%=lc_timezone%>
X_EXTENSION_PROPERTY;VALUE=X_EXTENSION_PROPERTY_ID:field1;VALUE=X_EXTENSION_NAME:field1;VALUE=X_EXTENSION_VALUE:<%=lc_field1%>;VALUE=X_EXTENSION_DATA_TYPE:String
X_EXTENSION_PROPERTY;VALUE=X_EXTENSION_PROPERTY_ID:field2;VALUE=X_EXTENSION_NAME:field2;VALUE=X_EXTENSION_VALUE:<%=lc_field2%>;VALUE=X_EXTENSION_DATA_TYPE:String
X_EXTENSION_PROPERTY;VALUE=X_EXTENSION_PROPERTY_ID:field3;VALUE=X_EXTENSION_NAME:field3;VALUE=X_EXTENSION_VALUE:<%=lc_field3%>;VALUE=X_EXTENSION_DATA_TYPE:String
X_EXTENSION_PROPERTY;VALUE=X_EXTENSION_PROPERTY_ID:field4;VALUE=X_EXTENSION_NAME:field4;VALUE=X_EXTENSION_VALUE:<%=lc_field4%>;VALUE=X_EXTENSION_DATA_TYPE:String
X_EXTENSION_PROPERTY;VALUE=X_EXTENSION_PROPERTY_ID:field5;VALUE=X_EXTENSION_NAME:field5;VALUE=X_EXTENSION_VALUE:<%=lc_field5%>;VALUE=X_EXTENSION_DATA_TYPE:String

END:VCARD
</content>
</entry>
