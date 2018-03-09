<%--
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2001, 2002
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
<head>

</head>

  <body class="content" >

    <FORM name="aplform" target="_self" action="" method=GET>
    
    <INPUT TYPE=hidden name="XMLFile" value="returns.returnItemListDialog">
    <INPUT TYPE=hidden name="ActionXMLFile" value="">
    <INPUT TYPE=hidden name="cmd" value="">
    <INPUT TYPE=hidden name="itemsSelected" value="false">
    
    <INPUT TYPE=hidden name="searchProductName" value="">
    <INPUT TYPE=hidden name="searchSKUNumber" value="">
    <INPUT TYPE=hidden name="searchShortDesc" value="">
    
    <INPUT TYPE=hidden name="searchOrderNumber" value="">
    <INPUT TYPE=hidden name="searchCustomerLogonId" value="">
    <INPUT TYPE=hidden name="searchAccountId" value="">

    <INPUT TYPE=hidden name="listsize" value="10">
    <INPUT TYPE=hidden name="startindex" value="0">
    <INPUT TYPE=hidden name="refnum" value="0">
    </FORM>

    <SCRIPT language="javascript">
      var URLParam = top.getData("OrderProductSearchURLParam");
      if (URLParam == null) {
		var wizardModel = top.getModel(1);
		URLParam = wizardModel.OrderProductSearchURLParam;
      }

      if ( URLParam.searchOrdersOrCatalog == "searchCatalog" )
      {
         document.aplform.action="/webapp/wcs/tools/servlet/NewDynamicListView";
         document.aplform.ActionXMLFile.value = "returns.returnItemList";
         document.aplform.cmd.value = "ReturnItemList";
         document.aplform.searchProductName.value=URLParam.searchProductName;
         document.aplform.searchSKUNumber.value=URLParam.searchSKUNumber;
         document.aplform.searchShortDesc.value=URLParam.searchShortDesc;
         document.aplform.submit();
      }
      else
      {
         document.aplform.action="/webapp/wcs/tools/servlet/NewDynamicListView";
         document.aplform.ActionXMLFile.value = "returns.returnOrderItemList";
         document.aplform.cmd.value = "ReturnOrderItemList";
         document.aplform.searchOrderNumber.value=URLParam.searchOrderNumber;
         document.aplform.searchCustomerLogonId.value=URLParam.searchCustomerLogonId;
	 document.aplform.searchAccountId.value=URLParam.searchAccountId;
         document.aplform.submit();
      }
    </SCRIPT>
  </body>
</HTML>
