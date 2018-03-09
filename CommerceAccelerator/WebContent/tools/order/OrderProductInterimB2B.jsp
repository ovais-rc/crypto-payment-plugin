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

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
  <head>
  </head>

  <body class="content">

    <form name="aplform" target="_self" action="/webapp/wcs/tools/servlet/NewDynamicListView" method="post">
    
    <input type="hidden" name="XMLFile" value="order.orderProductListDialogB2B" />
    <input type="hidden" name="ActionXMLFile" value="order.orderProductListB2B" />
    <input type="hidden" name="cmd" value="OrderProductListB2B" />
    <input type="hidden" name="searchProductName" value="" />
    <input type="hidden" name="searchSKUNumber" value="" />
    <input type="hidden" name="searchMaxMatches" value="" />
    <input type="hidden" name="customerId" value="" />
    <input type="hidden" name="listsize" value="10" />
    <input type="hidden" name="startindex" value="0" />
    </form>
 
    <script language="javascript" type="text/javascript">
	  <!-- <![CDATA[
      var URLParam = top.getData("OrderProductSearchURLParam");
      document.aplform.searchProductName.value=URLParam.searchProductName;
      document.aplform.searchSKUNumber.value=URLParam.searchSKUNumber;
      document.aplform.searchMaxMatches.value=URLParam.searchMaxMatches;
      document.aplform.customerId.value=URLParam.customerId;
      document.aplform.submit();
    //[[>-->
    </script>
  </body>
</html>
