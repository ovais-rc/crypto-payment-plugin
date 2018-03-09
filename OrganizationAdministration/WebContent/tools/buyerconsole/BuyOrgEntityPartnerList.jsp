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

//////////////////////////////////////////////////////////////////////
// THE RESELLER ORG ID IS PASSED TO THIS PAGE AND IT SHOULD BE USED TO FIND THE RESELLER STORE ID
//////////////////////////////////////////////////////////////////////
Vector distList = new Vector();

String distProxyDN = WcsApp.configProperties.getValue("Instance/DistributorProxyOrgDN");
String distProxyId = null;
String storeEntityId 	= "0";
String orgEntityId	= request.getParameter("orgEntityId");



OrganizationAccessBean oab = new OrganizationAccessBean();
try {
	distProxyId  = (oab.findByDN(distProxyDN)).getOrganizationId();

	if (distProxyId != null || !distProxyId.equals("")) {
		OrgEntityDataBean distProxyOrg = new OrgEntityDataBean();
		distProxyOrg.setDataBeanKeyMemberId(distProxyId);
		distProxyOrg.populate();
	
		Long[] distOrgs = distProxyOrg.getChildOrgEntities();
	
		for (int i=0; i < distOrgs.length; i++) {
			
			OrgEntityDataBean oedbtemp = new OrgEntityDataBean();
			oedbtemp.setDataBeanKeyMemberId(distOrgs[i].toString());
			oedbtemp.populate();
			
			String[] attr = {distOrgs[i].toString(), oedbtemp.getOrgEntityName(), "", ""};
						
			MemberGroupAccessBean mgab = new MemberGroupAccessBean();
			Enumeration enum1 = mgab.findByMember(distOrgs[i]);
			
			MemberGroupMemberAccessBean mgmab = new MemberGroupMemberAccessBean();
    			
		
			while (enum1.hasMoreElements()) {
				MemberGroupAccessBean partnerGroup = (MemberGroupAccessBean) enum1.nextElement();
				java.util.Enumeration enum2 = mgmab.findByMember(new Long(orgEntityId));
				while (enum2.hasMoreElements()) {
					MemberGroupMemberAccessBean resellerGroup = (MemberGroupMemberAccessBean) enum2.nextElement();
					if ((resellerGroup.getMbrGrpId()).equals(partnerGroup.getMbrGrpId())) {
						attr[2] = partnerGroup.getMbrGrpName();
						attr[3] = resellerGroup.getMbrGrpId();
						break;
					}
				}
			}
			distList.addElement(attr);
		}
	}
} catch (Exception e) {
}	


String strMessage = "";
String strMessageKey = "";
Object[] strMessageParams = null;
String strFieldName = "";

int numberOfDist = 0;
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
    

    function changePart() {
      	var changed = 0;
      	var distId = 0;

      	if (arguments.length > 0) {
        
      		var temp = arguments[0];
	        var index = temp.indexOf('_',0);
        	var distId = temp.substring(0,index);
        	var mbrGrpId = temp.substring(index+1, temp.length);
        	changed = 1;
      	} else {
        	var checked = parent.getChecked();
        	if (checked.length > 0) {
          		var temp = checked[0];
          		var index = temp.indexOf('_',0);
          		distId = temp.substring(0,index);
          		var mbrGrpId = temp.substring(index+1, temp.length);
          		changed = 1;
        	}
      	}
      	if (changed != 0) {
      		var url = top.getWebappPath() + "DialogView?XMLFile=buyerconsole.BuyOrgEntityPartnerChange";
        	        		
        	url += "&distributorId=" + distId;
        	url += "&orgEntityId=" + '<%=UIUtil.toJavaScript(orgEntityId)%>';
        	if (mbrGrpId != null || mbrGrpId != "") 
        		url += "&mbrGrpId=" + mbrGrpId;
        	
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
<%=com.ibm.commerce.tools.common.ui.taglibs.comm.addControlPanel("buyerconsole.BuyOrgEntityPartnerList", totalpage, totalsize, cmdContext.getLocale() )%>

<FORM NAME="orgEntityForm" ACTION="BuyOrgEntityPartnerListView" METHOD="POST">
<%=addHiddenVars()%>

<%= com.ibm.commerce.tools.common.ui.taglibs.comm.startDlistTable("orgTableId") %>
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.startDlistRowHeading() %>
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.addDlistCheckHeading() %>
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.addDlistColumnHeading((String)orgEntityNLS.get("OrgEntityDist"), null, false )%>
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.addDlistColumnHeading((String)orgEntityNLS.get("OrgEntityPartnerGroup"), null, false )%>
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.endDlistRow() %>



<!-- Need to have a for loop to lookfor all the member groups -->
<%
    int rowselect=1;
    
    for (int i=getStartIndex(); i < endIndex; i++) {    
    
    	String[] attrValues = (String[]) distList.elementAt(i);
    	String distName = "";
    	String partnerGrp = "";	
    	int exists = 0;
    	
    	distName = attrValues[1];
    	partnerGrp = attrValues[2];
    	if (attrValues[2] != null) {
    		partnerGrp = attrValues[2];
    		exists = 1;
    	}
	
%>

<%= com.ibm.commerce.tools.common.ui.taglibs.comm.startDlistRow(rowselect) %>
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.addDlistCheck(attrValues[0] + "_" + attrValues[3], "none" ) %>
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.addDlistColumn( UIUtil.toHTML(distName), null ) %> 
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.addDlistColumn( UIUtil.toHTML(partnerGrp), null ) %> 

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