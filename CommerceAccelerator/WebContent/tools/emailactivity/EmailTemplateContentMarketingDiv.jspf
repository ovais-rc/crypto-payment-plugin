<!-- 
/*
 *-------------------------------------------------------------------
 * Licensed Materials - Property of IBM 
 *
 * WebSphere Commerce
 *
 * (c) Copyright International Business Machines Corporation. 2005
 *     All rights reserved.
 *
 * US Government Users Restricted Rights - Use, duplication or
 * disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 *-------------------------------------------------------------------
*/
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
//
// Change History
//
// YYMMDD    F/D#   WHO       Description
//----------------------------------------------------------------------
//
////////////////////////////////////////////////////////////////////////////////
=========================================================================== -->
<%@ page import="com.ibm.commerce.emarketing.utils.EmailTemplateUtil" %>
<%@ page import="java.util.Vector" %>

<%
//Get the display type...
Vector contentDisplayList = EmailTemplateUtil.getDisplayTypes("Content");
Vector emSpotDisplayList = 	EmailTemplateUtil.getDisplayTypes("EMSpot");

%>

<!-- Div of Content -->
<Div id="contentSelect" style="display:none;margin-left: 22">
<br/>
<label for="contentLabel"><%= emailActivityRB.get("content") 
%><br/></label>
<input name="content" id="contentLabel" type="text" size="50" maxlength="254" readOnly = 'true' />&nbsp;
<button value='<%=emailActivityRB.get("contentList")%>' name="contentList" onclick="gotoCommandParameterDialog('listAdCopy');" class="general" style="text-align: center; padding-left: 5px;">&nbsp;<%=emailActivityRB.get("contentList")%></button>
<br><br>
<label for="contentDisplay"><%= emailActivityRB.get("displayType") 
%><br/></label>

<select name="contentDisplayList" id="contentDisplay">

<%	for(int i=0; i < contentDisplayList.size(); i++){ %>
		<option value="<%= contentDisplayList.get(i).toString() %>"><%= contentDisplayList.get(i).toString() %></option>
<%	} %>

</select>
<!-- End of div for content -->
</Div>

<!-- Div of E - Marketing spot.. -->
<Div id="eMarketingSpotSelect" style="display:none;margin-left: 22">
<br/>
<label for="eMarketingSpotLabel"><%= emailActivityRB.get("eMarketingSpot") 
%><br/></label>
<input name="eMarketingSpot" id="eMarketingSpotLabel" type="text" size="50" maxlength="254" readOnly = 'true' />&nbsp;
<button value='<%=emailActivityRB.get("eMarketingSpotList")%>' name="eMarketingSpotList" onclick="gotoCommandParameterDialog('listEmarketingSpot');" class="general" style="text-align: center; padding-left: 5px;">&nbsp;<%=emailActivityRB.get("eMarketingSpotList")%></button>
<br><br>
<label for="eMarketingSpotDisplay"><%= emailActivityRB.get("displayType") 
%><br/></label>
<select name="emSpotDisplayList" id="eMarketingSpotDisplay">

<%	for(int i=0; i < emSpotDisplayList.size(); i++){ %>
		<option value="<%= emSpotDisplayList.get(i).toString() %>"><%= emSpotDisplayList.get(i).toString() %></option>
<%	} %>

</select>
<!-- End of div for E - Marketing spot...-->
</Div>
