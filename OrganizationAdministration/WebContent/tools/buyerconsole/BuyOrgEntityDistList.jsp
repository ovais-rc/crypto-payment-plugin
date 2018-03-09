<!--  
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
-->
<%@ page language="java" %>

<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.base.objects.*"   %>
<%@ page import="com.ibm.commerce.beans.*" %>
<%@ page import="com.ibm.commerce.command.*" %>
<%@ page import="com.ibm.commerce.datatype.*" %>
<%@ page import="com.ibm.commerce.server.*" %>
<%@ page import="com.ibm.commerce.user.beans.*"   %>
<%@ page import="com.ibm.commerce.user.objects.*"   %>
<%@ page import="com.ibm.commerce.common.beans.*" %>
<%@ page import="com.ibm.commerce.common.objects.*" %>
<%@ page import="com.ibm.commerce.usermanagement.commands.ECUserConstants" %>

<%@ include file="../common/common.jsp" %>
<%@ include file="../common/List.jsp" %>

<%try {
// Set Command Context
CommandContext cmdContext = (CommandContext)request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
Locale locale = cmdContext.getLocale();
String webalias = UIUtil.getWebPrefix(request);

// obtain the resource bundle for display
Hashtable orgEntityNLS = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("buyerconsole.BuyOrgEntityNLS", locale);
Hashtable userAdminListNLS2 = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("adminconsole.AdminConsoleNLS", locale);
   if (orgEntityNLS == null) System.out.println("!!!! RS is null");

String orgEntityId	= request.getParameter("orgEntityId");
String distProxyDN = WcsApp.configProperties.getValue("Instance/DistributorProxyOrgDN");
String distProxyId = null;
Vector distList = new Vector();
String storeEntityId 	= "0";

OrgEntityDataBean oedb = new OrgEntityDataBean();
oedb.setDataBeanKeyMemberId(orgEntityId);
DataBeanManager.activate(oedb, request);

OrganizationAccessBean oab = new OrganizationAccessBean();
try {
	distProxyId  = (oab.findByDN(distProxyDN)).getOrganizationId();
} catch (Exception e) {
}

if (distProxyId != null && !distProxyId.equals("")) {
	OrgEntityDataBean distProxyOrg = new OrgEntityDataBean();
	distProxyOrg.setDataBeanKeyMemberId(distProxyId);
	distProxyOrg.populate();
	
	Long[] distOrgs = distProxyOrg.getChildOrgEntities();
	
	for (int i=0; i < distOrgs.length; i++) {
	
		StoreEntityAccessBean seab = new StoreEntityAccessBean();
		Enumeration enum2 = seab.findByMember(distOrgs[i]);
		String distStoreId = null;
		if (enum2.hasMoreElements()) {
			distStoreId = ((StoreEntityAccessBean) enum2.nextElement()).getStoreEntityId();
		}
		
		if (distStoreId == null) {
			continue;
		}
			
		OrgEntityDataBean oedbtemp = new OrgEntityDataBean();
		oedbtemp.setDataBeanKeyMemberId((distOrgs[i]).toString());
		oedbtemp.populate();
		
		Vector tempVec = new Vector();
		tempVec = oedb.getAttribute(ECUserConstants.EC_ORG_DISTRIBUTOR_PARTNER_ID, distStoreId);
		if (tempVec != null) {
			for (int j=0; j < tempVec.size(); j++) {
				String value = (String) tempVec.elementAt(j);
				String pref = value.substring(0,2);
				String rId = value.substring(2);
				String[] attr = {distStoreId, oedbtemp.getOrgEntityName(), pref, rId};
				distList.addElement(attr);
			}
		} else {
			String[] attr = {distStoreId, oedbtemp.getOrgEntityName(), null, null};
			distList.addElement(attr);
		}
	}
}


int numberOfDist = 0;
if (distList != null) 
	numberOfDist = distList.size();

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">

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
<HTML>
<HEAD>
<%= fHeader%>
<LINK rel=stylesheet href="<%= UIUtil.getCSSFile(cmdContext.getLocale())%>" type="text/css">

<TITLE><%= UIUtil.toHTML((String)orgEntityNLS.get("organization")) %></TITLE>

<SCRIPT LANGUAGE="JavaScript">
<!---- hide script from old browsers

    function getResultsSize() { 
     return <%= numberOfDist  %>; 
    }
    

    function changeDist() {
      	var changed = 0;
      	var storeId = 0;

      	if (arguments.length > 0) {
        
      		var temp = arguments[0];
	        var index = temp.indexOf('_',0);
        	var storeId = temp.substring(0,index);
        	var exists = temp.substring(index+1, temp.length);
        	changed = 1;
      	} else {
        	var checked = parent.getChecked();
        	if (checked.length > 0) {
          		var temp = checked[0];
          		var index = temp.indexOf('_',0);
          		storeId = temp.substring(0,index);
          		var exists = temp.substring(index+1, temp.length);
          		changed = 1;
        	}
      	}
      	if (changed != 0) {
      		if (exists == 1) 
      			var url = top.getWebappPath() + "DialogView?XMLFile=buyerconsole.BuyOrgEntityDistChange";
      		else
      			var url = top.getWebappPath() + "DialogView?XMLFile=buyerconsole.BuyOrgEntityDistAdd";
      			
        	url += "&storeEntityId=" + storeId;
        	url += "&orgEntityId=" + '<%=UIUtil.toJavaScript(orgEntityId)%>';
        	        
        	if (top.setContent) {
          		top.setContent("<%=UIUtil.toJavaScript((String)orgEntityNLS.get("changePartner")) %>",
                        		url,
                         		true);
        	} else {
          		parent.location.replace(url);
        	}
      	} 
    }

    
function showParent()
{
	alertDialog("show parent");
}

function showChildren()
{
	alertDialog("show children");
}

    function onLoad() 
    {
      parent.loadFrames();
    }


// -->
</script>

<SCRIPT SRC="<%=webalias%>javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT SRC="<%=webalias%>javascript/tools/common/dynamiclist.js"></SCRIPT>

</HEAD>

<BODY ONLOAD="onLoad()" class="content">
<%
          int startIndex = Integer.parseInt(request.getParameter("startindex"));
          int listSize = Integer.parseInt(request.getParameter("listsize"));          
	  int endIndex = getStartIndex() + getListSize();
    	  if (endIndex > numberOfDist)
      		endIndex = numberOfDist;
          int totalsize = numberOfDist;
          int totalpage = totalsize/listSize;          
	
%>
<%=com.ibm.commerce.tools.common.ui.taglibs.comm.addControlPanel("buyerconsole.BuyOrgEntityDistList", totalpage, totalsize, cmdContext.getLocale() )%>

<FORM NAME="orgEntityForm" ACTION="BuyOrgEntityPartnerListView" METHOD="POST">
<%=addHiddenVars()%>

<%= com.ibm.commerce.tools.common.ui.taglibs.comm.startDlistTable("orgTableId") %>
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.startDlistRowHeading() %>
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.addDlistCheckHeading() %>
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.addDlistColumnHeading((String)orgEntityNLS.get("OrgEntityDist"), null, false )%>
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.addDlistColumnHeading((String)orgEntityNLS.get("prefDistTitle"), null, false )%>
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.addDlistColumnHeading((String)orgEntityNLS.get("resellerId"), null, false )%>
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.endDlistRow() %>



<!-- Need to have a for loop to lookfor all the member groups -->
<%
    int rowselect=1;
        
    for (int i=getStartIndex(); i < endIndex; i++) {    
    
        String preferred = (String)orgEntityNLS.get("pref");
    	String distName = "";
    	String resellId = "";
    	int exists = 0;
    	
    	String[] dist = (String []) distList.elementAt(i);
    	distName = dist[1];
    	
    	
    	if (dist[2] != null)  {
    		if (dist[2].equals("1_")) preferred = (String)orgEntityNLS.get("pref");
    		else preferred = (String)orgEntityNLS.get("notpref");
    		resellId = dist[3];
    		exists = 1;
    	}
    	
    	
	
%>

<%= com.ibm.commerce.tools.common.ui.taglibs.comm.startDlistRow(rowselect) %>
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.addDlistCheck(dist[0] + "_" + exists, "none" ) %>
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.addDlistColumn( UIUtil.toHTML(distName), null ) %> 
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.addDlistColumn( UIUtil.toHTML(preferred), null ) %> 
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.addDlistColumn( UIUtil.toHTML(resellId), null ) %> 

<%= com.ibm.commerce.tools.common.ui.taglibs.comm.endDlistRow() %>

<%
}
%>
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.endDlistTable() %>

</FORM>
<SCRIPT LANGUAGE="JavaScript">
<!--
          parent.afterLoads();
          parent.setResultssize(getResultsSize());

// -->
</SCRIPT>
</BODY>
</HTML>
<% } catch (Exception e) { e.printStackTrace();}%>