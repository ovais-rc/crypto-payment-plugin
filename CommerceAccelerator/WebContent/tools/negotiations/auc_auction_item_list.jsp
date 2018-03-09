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


<!-- ========================================================================
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
 ===========================================================================-->
<%@  page import="com.ibm.commerce.negotiation.beans.*" %>
<%@  page import="com.ibm.commerce.negotiation.bean.commands.*" %>
<%@  page import="com.ibm.commerce.negotiation.util.*" %>
<%@  page import="com.ibm.commerce.tools.common.ui.taglibs.*" %>
<%@  page import="com.ibm.commerce.server.*" %>
<%@  page import="com.ibm.commerce.command.*" %>
<%@  page import="com.ibm.commerce.negotiation.helpers.*" %>
<%@  page import="com.ibm.commerce.negotiation.objimpl.*" %>
<%@  page import="com.ibm.commerce.negotiation.misc.*" %>
<%@  page import="com.ibm.commerce.negotiation.operation.*" %>
<%@  page import="com.ibm.commerce.usermanagement.commands.ECUserConstants" %>
<%@  page import="com.ibm.commerce.user.beans.MemberDataBean" %>
<%@  page import="com.ibm.commerce.user.beans.OrganizationDataBean" %>
<%@  page import="com.ibm.commerce.user.beans.UserRegistryDataBean" %>
<%@  page import="com.ibm.commerce.search.beans.*" %>
<%@  page import="com.ibm.commerce.catalog.objects.*" %>
<%@  page import="com.ibm.commerce.catalog.beans.*" %>
<%@  page import="java.util.*" %>

<%@page import="com.ibm.commerce.tools.test.*" %>
<%@page import="com.ibm.commerce.tools.util.*" %>
<%@include file="../common/common.jsp" %>
<%@include file="../common/List.jsp" %>

<%
   String   emptyString = new String("");
   Integer  storeid = null;
   Integer  langid = null;
   Long     ownerid = null; 
   int      itemLength = 0; 
   Locale   aLocale = null;
     
   //***Get storeid from CommandContext
   CommandContext aCommandContext = (CommandContext)request.getAttribute("CommandContext");    
   if( aCommandContext!= null )
   {
        langid = aCommandContext.getLanguageId();
        storeid = aCommandContext.getStoreId();
        aLocale = aCommandContext.getLocale();
   }

   JSPHelper help = new JSPHelper(request);
   String sku        = help.getParameter("sku");
   sku=UIUtil.toHTML(sku);
   String name       = help.getParameter("name");
   name=UIUtil.toHTML(name);
   String shortdesc  = help.getParameter("shortdesc");
   shortdesc=UIUtil.toHTML(shortdesc);

   //*** GET list size and start index ***//
   String listSize_str = (String) help.getParameter("listsize");
   int listSize = Integer.parseInt(listSize_str);
   String startIndex_str = (String) help.getParameter("startindex");
   int startIndex = Integer.parseInt(startIndex_str);

   // obtain the resource bundle for display
   Hashtable auctionListNLS = (Hashtable)ResourceDirectory.lookup("negotiations.negotiationsNLS", aLocale);
   com.ibm.commerce.datatype.TypedProperty reqProperties = (com.ibm.commerce.datatype.TypedProperty) 	request.getAttribute("RequestProperties");
%>

<HTML>
<HEAD>
<%= fHeader%>
<link rel=stylesheet href="<%= UIUtil.getCSSFile(aLocale) %>" type="text/css">
<TITLE><%= auctionListNLS.get("auctionItemListTitle") %></TITLE>

<%
	//search for products using the AdvancedCatEntrySearchListDataBean	
	AdvancedCatEntrySearchListDataBean searchBean = new AdvancedCatEntrySearchListDataBean();
	searchBean.setCommandContext(aCommandContext);
	searchBean.setStoreId(storeid.toString());
	searchBean.setLangId( langid.toString() );
	
	searchBean.setBuyable("1");
	
	searchBean.setPublished("1");

	searchBean.setBeginIndex(startIndex_str);
	searchBean.setPageSize(listSize_str);
	
	//set the parameters from the request
	searchBean.setIsPackage(true);
	searchBean.setIsItem(true);

      if (sku != null && !sku.equals(emptyString) ) {
		searchBean.setSku(sku);
		searchBean.setSkuCaseSensitive( SearchConstants.CASE_SENSITIVE );
		searchBean.setSkuOperator( SearchConstants.OPERATOR_LIKE);
      } else if (name != null && !name.equals(emptyString) ) {
			searchBean.setName( name );
			searchBean.setNameTermOperator( SearchConstants.OPERATOR_LIKE );
      } else if (shortdesc != null && !shortdesc.equals(emptyString) ) {
				searchBean.setShortDesc( shortdesc );
				searchBean.setShortDescOperator(SearchConstants.OPERATOR_LIKE);
	  }	

	searchBean.populate();
	CatalogEntryDataBean[] tempResult = searchBean.getResultList();


      if ( tempResult == null ) {
        itemLength = 0; 
      }  
      else
        itemLength = tempResult.length;  
     int totalItems = (new Integer(searchBean.getResultCount())).intValue();
%>


<SCRIPT LANGUAGE="JavaScript">

function performCancel() {
	top.goBack();

}

function performOK() {

  var tempval = parent.getChecked();
  
  var selval = tempval[0].split("!");
  var aSKU       = selval[0];
  var aMemberId  = selval[1];
  var aName      = selval[2];
  var aShortDesc = selval[3];
  var aCatentryId= selval[4];

  document.itemForm.itemFlag.value = "2";
  top.sendBackData(aSKU, "aSKU");   
  top.sendBackData(aMemberId, "aMemberId");   
  top.sendBackData(aName, "aName");   
  top.sendBackData(aShortDesc, "aShortDesc" );   
  top.sendBackData(aCatentryId, "aCatentryId" );   
  top.goBack();

}

function getFindTitle()
{
	return "<%= UIUtil.toJavaScript((String)auctionListNLS.get("ItemDialog")) %>";
}

function onLoad() {
  parent.loadFrames()
}

function getResultsSize() { 
     return <%= totalItems %>; 
}

function getListSize() {
    return "<%= listSize %>"
}

function getUserNLSTitle() {
   return "<%= UIUtil.toJavaScript((String)auctionListNLS.get("itemSearchList")) %>"
}

parent.setResultssize(getResultsSize());

// -->
</SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/common/dynamiclist.js"></SCRIPT>
</HEAD>
<BODY class="content_list">
<SCRIPT LANGUAGE="JavaScript">
<!--
//For IE
if (document.all) {
    onLoad();
}


//-->
</SCRIPT>

<%
  int totalpage = totalItems/listSize;
  // addControlPanel adds 1 to the page count which is ok unless the division doesn't result in a remainder
   if(totalItems == totalpage * listSize)
   {
     totalpage--;
   }
   String nul = null;
%>

<%= comm.addControlPanel("negotiations.auctionItemListSC",totalpage,totalItems,aLocale) %>

<FORM NAME="itemForm" action="AuctionItemList?" method="POST">

<INPUT TYPE=HIDDEN NAME="itemFlag" VALUE="2">
<INPUT TYPE=HIDDEN NAME="sku" VALUE="<%= sku %>">
<INPUT TYPE=HIDDEN NAME="name" VALUE="<%= name %>">
<INPUT TYPE=HIDDEN NAME="shortdesc" VALUE="<%= shortdesc %>">
<INPUT TYPE="HIDDEN" NAME="startindex" VALUE="">
<INPUT TYPE="HIDDEN" NAME="listsize" VALUE="">

<%= comm.startDlistTable(nul) %>
<%= comm.startDlistRowHeading() %>
<%= comm.addDlistCheckHeading() %>
<%= comm.addDlistColumnHeading(UIUtil.toHTML((String)auctionListNLS.get("SKU")), "none", false) %>
<%= comm.addDlistColumnHeading(UIUtil.toHTML((String)auctionListNLS.get("ownerId")), "none", false) %>
<%= comm.addDlistColumnHeading(UIUtil.toHTML((String)auctionListNLS.get("ItemName")), "none", false) %>
<%= comm.addDlistColumnHeading(UIUtil.toHTML((String)auctionListNLS.get("ItemDesc")), "none", false) %>
<%= comm.addDlistColumnHeading(UIUtil.toHTML((String)auctionListNLS.get("onAuction")), "none", false) %>
<%= comm.endDlistRow() %>

<%
  String partNumber    = null;
  String memberId      = null;
  String itemName      = null;
  String itemShortDesc = null;
  String catentryId    = null;
  String checkboxvalue = null;
  HashMap hMemberName = new HashMap();
   
  int rowselect = 1;
  
  int endIndex = startIndex + listSize;
  if ( endIndex > itemLength )
    endIndex= itemLength;

	for( int i = 0; i < itemLength; ++i) {
	  CatalogEntryDataBean aib = tempResult[i];
      partNumber    = aib.getPartNumber();
      
      memberId      = aib.getMemberId().toString();
      String sTempName = (String)hMemberName.get(memberId);
      if (sTempName == null) {
	MemberDataBean dbMember = new MemberDataBean();
	dbMember.setDataBeanKeyMemberId(memberId);
	com.ibm.commerce.beans.DataBeanManager.activate(dbMember, request);
	String sMbrType = dbMember.getType();
	if (sMbrType.trim().equals(ECUserConstants.EC_MEMBER_ORGENTITYBEAN)) {
		OrganizationDataBean dbOrgan = new OrganizationDataBean();
		dbOrgan.setDataBeanKeyMemberId(memberId);
		//no need to access control on this bean as the catalog has been checked already.
		//just want to get the name of the organization
		//com.ibm.commerce.beans.DataBeanManager.activate(dbOrgan, request);
		dbOrgan.populate();
    		sTempName = dbOrgan.getDisplayName();
    		hMemberName.put(memberId,sTempName);
    		memberId = sTempName;
    	} else if (sMbrType.trim().equals(ECUserConstants.EC_MEMBER_USERBEAN)) {
		UserRegistryDataBean dbUser = new UserRegistryDataBean();
		dbUser.setDataBeanKeyUserId(memberId);
		//no need to access control on this bean as the catalog has been checked already.
		//just want to get the name of the organization
		//com.ibm.commerce.beans.DataBeanManager.activate(dbUser, request);
		dbUser.populate();
		sTempName = dbUser.getLogonId();
    		hMemberName.put(memberId,sTempName);
    		memberId = sTempName;
	} else {
  		hMemberName.put(memberId,sTempName);
	}
      } else {
        memberId = sTempName;
      }
      CatalogEntryDescriptionAccessBean descAB = aib.getDescription();
      itemName      = descAB.getName();
      itemShortDesc = descAB.getShortDescription();
      catentryId    = aib.getCatalogEntryID();

      checkboxvalue = partNumber + "!" + memberId + "!" + itemName + "!" + itemShortDesc + "!" + catentryId; 
   
%>

<%= comm.startDlistRow(rowselect) %>
<%= comm.addDlistCheck(checkboxvalue, "none") %>
<%= comm.addDlistColumn(UIUtil.toHTML(partNumber), "none") %>
<%= comm.addDlistColumn(UIUtil.toHTML(memberId), "none") %>
<%= comm.addDlistColumn(UIUtil.toHTML(itemName), "none") %>	
<%= comm.addDlistColumn(UIUtil.toHTML(itemShortDesc), "none") %>
<%      if ( aib.getOnAuction().toString().equals("1") )  {
%>
<%= comm.addDlistColumn(UIUtil.toHTML((String)auctionListNLS.get("yes")), "none") %>
<%      }  else {
%>
<%= comm.addDlistColumn(UIUtil.toHTML((String)auctionListNLS.get("no")), "none") %>
<%      }
%>

<%= comm.endDlistRow() %>

<%      
     if(rowselect==1){
       rowselect = 2;
     }
     else{
       rowselect = 1;
     } 

  }
%>

<%= comm.endDlistTable() %>
<%
	if (itemLength <= 0) {
%>
	<P>
	<P>
	<%= UIUtil.toHTML((String)auctionListNLS.get("msgItemFindError")) %>
<% 
	}
%>


</FORM>
<SCRIPT LANGUAGE="Javascript">
   parent.afterLoads();
</SCRIPT>
</BODY>
</HTML>
