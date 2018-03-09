<%--
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2000, 2002
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
//*
--%>

<%@include file="../common/common.jsp" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
<HTML>
<HEAD>
<%= fHeader%>
<META name="GENERATOR" content="IBM WebSphere Studio">
</HEAD>
<BODY class="content">
  <FORM name="aplform" target="_self" action="/webapp/wcs/tools/servlet/NewDynamicListView" method=GET>
    <INPUT TYPE=hidden name="ActionXMLFile" value="inventory.AddItemListActions">
    <INPUT TYPE=hidden name="cmd" value="AddItemListView">
	 <INPUT TYPE=hidden name="searchItemName" value="">
    <INPUT TYPE=hidden name="searchSKU" value="">
  </FORM>

  <SCRIPT language="javascript">
    var URLParam = top.getData("AddItemSearch");
    document.aplform.searchItemName.value=URLParam.searchItemName;
    document.aplform.searchSKU.value=URLParam.searchSKU;
	 document.aplform.submit();
  </SCRIPT>
</BODY>
</HTML>