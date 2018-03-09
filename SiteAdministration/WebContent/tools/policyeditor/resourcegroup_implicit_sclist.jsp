<!-- ========================================================================
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2001
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
//*
 ===========================================================================-->



<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.tools.common.ui.taglibs.*" %> 
<%@ page import="com.ibm.commerce.beans.*" %>
<%@ page import="com.ibm.commerce.datatype.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="com.ibm.commerce.command.*"%>
<%@ page import="com.ibm.commerce.*" %>
<%@ page import="com.ibm.commerce.exception.*" %>
<%@ page import="com.ibm.commerce.server.*" %>
<%@ page import="com.ibm.commerce.accesscontrol.policyeditor.util.*" %>
<%@ page import="com.ibm.commerce.accesscontrol.policyeditor.beans.*" %>
<%@ page import="com.ibm.commerce.accesscontrol.policyeditor.dbutil.*" %>

<%@include file="../common/common.jsp" %>

<%
try
{
%>

<HTML>
<HEAD>
<%= fHeader%>

<%        
   Vector attr_id = new Vector();
   Vector attr_name  = new Vector();
   Vector attr_value   = new Vector();

   String userId = null;    
   Locale locale = null;
   String storeId = null;
   String lang = null;
   String sortby = null;
   Integer resCgryId = null;
   Integer selectResource = null;
   Integer resourceId = null;
                    
   CommandContext aCommandContext = (CommandContext)request.getAttribute("CommandContext"); 
      
         
   if( aCommandContext!= null )
   {
      locale = aCommandContext.getLocale();
      storeId = aCommandContext.getStoreId().toString();
      lang = aCommandContext.getLanguageId().toString();
      userId = aCommandContext.getUserId().toString();
   }

   int startIndex = Integer.parseInt(request.getParameter("startindex"));
   int listSize = Integer.parseInt(request.getParameter("listsize"));
   String selResource = (String) request.getParameter("selectResource");
  
   if(selResource != null && !selResource.equals(""))
   {
     try
     {
       selectResource = Integer.valueOf(selResource);
       resCgryId = selectResource;
     }
     catch (Exception ex) { }
   }

//   if(selResource !=null)
 //  {
//    selectResource = Integer.valueOf(selResource);
//   }
//   resCgryId = selectResource;
//   if(resCgryId == null)
//   {
//    resCgryId = new Integer(999999);
//   }

   PolicySortingAttribute sort = new PolicySortingAttribute();
   // obtain the resource bundle for display
   Hashtable resourcegroupListNLS = (Hashtable)ResourceDirectory.lookup("policyeditor.policyeditorNLS", locale);      
%>

<%!
public static String addDlistColumnEntry(String name, String entryName, String checkboxName, String size) throws com.ibm.commerce.exception.ECSystemException {

	  StringBuffer tmpStr = new StringBuffer(500);
	  tmpStr.append("<TD ");
	  tmpStr.append(" CLASS=\"list_info1\"><INPUT TYPE=TEXT MAXLENGTH=128 NAME='"+entryName+"' SIZE='"+size+"' VALUE=\""+name+"\" ONCHANGE=\"javascript:valueChange('"+checkboxName+"')\"></TD>");
	  return tmpStr.toString();
}

%>

<link rel=stylesheet href="<%= UIUtil.getCSSFile(locale) %>" type="text/css">
<TITLE><%= UIUtil.toHTML((String)resourcegroupListNLS.get("resourceGroupListTitle")) %></TITLE>

<jsp:useBean id="resourceListBean" class="com.ibm.commerce.accesscontrol.policyeditor.beans.ResourceLightListBean" >
<jsp:setProperty property="*" name="resourceListBean" />
<jsp:setProperty property="languageId" name="resourceListBean" value="<%= lang %>" />
</jsp:useBean>
<%   
   sort.setTableAlias("T1"); 
   sort.addSorting(ResourceTable.CLASSNAME, true);
   resourceListBean.setSortAtt( sort );
   com.ibm.commerce.beans.DataBeanManager.activate(resourceListBean, request);
   ResourceLightDataBean[] rList = resourceListBean.getResourcesHasAttributes();
   ResAttrLightDataBean[] aList = null;
%>
<jsp:useBean id="resattrListBean" class="com.ibm.commerce.accesscontrol.policyeditor.beans.ResAttrLightListBean" >
<jsp:setProperty property="*" name="resattrListBean" />
<jsp:setProperty property="languageId" name="resattrListBean" value="<%= lang %>" />
<jsp:setProperty property="resCgryId" name="resattrListBean" value="<%= resCgryId %>" />
</jsp:useBean>
<%
   int aListlen = 0;   
   PolicySortingAttribute newsort = new PolicySortingAttribute();

   sortby = request.getParameter("orderby");
   newsort.setTableAlias("T4"); 
   newsort.addSorting(sortby, true);
    
   resattrListBean.setSortAtt( newsort );
   if(resCgryId != null && !resCgryId.equals(""))
   {
   com.ibm.commerce.beans.DataBeanManager.activate(resattrListBean, request);
   aList = resattrListBean.getResAttrBeans();
   aListlen = aList.length;
}
%>

<SCRIPT LANGUAGE="JavaScript">
<!---- hide script from old browsers
 	var myAttributes = new Object();
	var myModel = new Object();
	var count = 0;
   	var totalcount;
        var aListlen = 0;

function getResultsSize() {
<%
  if(resCgryId != null && !resCgryId.equals(""))
  {
%>
     return <%= resattrListBean.getResAttrBeans().length %>; 
<%
  }
  else
  {
%>
   return 0;
<%
  }
%>
}

function getLang() {
  return "<%= lang %>";
}

function getSortby() {
     return "<%= UIUtil.toJavaScript(sortby) %>";
}


function savePanelData()
{
       myModel.product = new Array();
       myAttributes["count"] = count;
       myModel.product.push(myAttributes);

       document.createForm.XML.value = convertToXML(myModel, "myModel");
	   parent.put("implResGrpDetails", myModel);
}

function doPrompt (field,msg)
{
    if(aListlen == 0)
    {
      alertDialog(msg);
    }
    else
    {
      alertDialog(msg);
      field.focus();
    }
}

function validatePanelData()
{
   attributevalueMissing = "<%= UIUtil.toJavaScript((String)resourcegroupListNLS.get("attributevalueMissing")) %>";
   InputFieldMax = "<%= UIUtil.toJavaScript((String)resourcegroupListNLS.get("InputFieldMax")) %>";
   aListlen = <%=aListlen%>;
   totalcount=0;
   for(var i=0;i< aListlen; i++)
   {
    if(aListlen == 1)
    {
     if(trim(document.createForm.attr_value.value)=="")
     {
       totalcount++;
     }
     else
     {
      if (!isValidUTF8length(document.createForm.attr_value.value, 128)) 
      {
       doPrompt(document.createForm.attr_value,InputFieldMax);
       return false;
      }
     }
    }
    else
    {
     if(trim(document.createForm.attr_value[i].value)=="")
     {
       totalcount++;
     }
     else
     {
      if (!isValidUTF8length(document.createForm.attr_value[i].value, 128)) 
      {
       doPrompt(document.createForm.attr_value[i],InputFieldMax);
       return false;
      }
     }
    }
   }

   if(totalcount==aListlen)
   {
     doPrompt(document.createForm.attr_value, attributevalueMissing);
     return false;
   }
   else
   {
     return true;
   }
}

function changeResource() {
   var s = document.createForm.selectResource.selectedIndex;
   var o = document.createForm.selectResource.options[s].value;
   var theURL2 = top.getWebappPath() +'ResourceGroupImplicitListView?ActionXMLFile=adminconsole.resourcegroupImplList&amp;cmd=ResourceGroupImplicitListView&amp;selected=SELECTED&amp;listsize=15&amp;startindex=0&amp;orderby=ATTRNAME&amp;selectResource=' + o;
  location.replace(theURL2);
}

   function valueChange(index)
   {
      var value;
      var attribute;
      if(document.createForm.counter.value == 1)
      {
          value = trim(document.createForm.attr_value.value);
	  attribute = trim(document.createForm.attr_name.value);
      }
      else
      {
	  value = trim(document.createForm.attr_value[index].value);
	  attribute = trim(document.createForm.attr_name[index].value);
      }
      if(trim(value)!="")
      {
        count++;
        var s1 = "attribute" + index;
        var s2 = "value" + index;
        myAttributes[s1] = attribute;
        myAttributes[s2] = value;
	//parent.put("implResGrpDetails", myAttributes);
      }
  }


// -->
</script>

<SCRIPT LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/Vector.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/ConvertToXML.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/policyeditor/resourcegroup_wizard.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/common/dynamiclist.js"></SCRIPT>

</HEAD>
<BODY class="content_list">
<H1><%= UIUtil.toHTML((String)resourcegroupListNLS.get("ResourceGroupDetails")) %></H1><BR>

<%
  int endIndex = 0;
  if(resCgryId != null && !resCgryId.equals(""))
  {
       endIndex = aList.length;
  }
          int rowselect = 1;
          String nul = null;

%>

<FORM NAME="createForm" METHOD="POST" Action="resourcegroupListView">
    <INPUT TYPE="HIDDEN" NAME="resourcegroupName" VALUE="">
    <INPUT TYPE="HIDDEN" NAME="resGrpDisplayName" VALUE="">
    <INPUT TYPE="HIDDEN" NAME="resourcegroupDescription" VALUE="">
    <INPUT TYPE="HIDDEN" NAME="resourcegroupType" VALUE="">
    <INPUT TYPE="HIDDEN" NAME="viewtaskname" VALUE="">
    <INPUT TYPE="HIDDEN" NAME="ActionXMLFile" VALUE="">
    <INPUT TYPE="HIDDEN" NAME="cmd" VALUE="">
    <INPUT TYPE="HIDDEN" NAME="XML" VALUE="">
    <INPUT TYPE="HIDDEN" NAME="counter" VALUE="<%= endIndex %>">
    <INPUT TYPE="HIDDEN" NAME="explicit" VALUE="no">

<LABEL for="selectResource1">
<%= resourcegroupListNLS.get("view") %>
</LABEL>
<BR>
<SELECT NAME="selectResource" onChange="changeResource()" id="selectResource1">
<%
    if(resCgryId == null)
     {
%>   
       <OPTION value="" selected><%= UIUtil.toHTML((String)resourcegroupListNLS.get("noneView")) %></OPTION>
<%
     }
  for (int i = 0; i < rList.length ; i++)
  {
%>
  <OPTION VALUE="<%= rList[i].getResCgryId().toString() %>"
<%
   if(resCgryId != null && rList[i].getResCgryId().equals(resCgryId))
   {
%>
   selected
<%
   }
%>
  ><%= UIUtil.toHTML((String)rList[i].getClassName()) %>
<%
   }
%>
</SELECT><BR><BR>

<%= comm.startDlistTable(nul) %>
<%= comm.startDlistRowHeading() %>
<%= comm.addDlistColumnHeading(UIUtil.toHTML((String)resourcegroupListNLS.get("resourceAttributeHeader")),"none", false) %>
<%= comm.addDlistColumnHeading(UIUtil.toHTML((String)resourcegroupListNLS.get("resourceValueHeader")), "none", false) %>
<%= comm.endDlistRow() %>
         
<%
  for (int i = startIndex; i < endIndex ; i++)
  {
   String index = "" + i;
   attr_id.addElement(aList[i].getAttrId());
   attr_name.addElement(aList[i].getAttrBaseName());
   attr_value.addElement("");
%>
<%= comm.startDlistRow(rowselect) %>
<INPUT TYPE=HIDDEN NAME="attr_id" VALUE=<%=attr_id.elementAt(i)%>>
<INPUT TYPE=HIDDEN NAME="attr_name" VALUE="<%=attr_name.elementAt(i)%>">
<%= comm.addDlistColumn(aList[i].getAttrBaseName(),"none") %>
<%= addDlistColumnEntry(UIUtil.toHTML((String)attr_value.elementAt(i)), "attr_value", index , "20") %>
<%= comm.endDlistRow() %>
  
<%   
     if(rowselect==1){
       rowselect = 2;
     }
     else{
       rowselect = 1;
     } 
   }    // end for
%>   

<%= comm.endDlistTable() %>
  
</FORM>

<% if(aList == null || aList.length == 0) {%>
<P>
<P>
<% 
     out.println( UIUtil.toHTML((String)resourcegroupListNLS.get("emptyresourcegroupImplList")) ); 
   }
%>
<SCRIPT>
<!--
		   parent.setContentFrameLoaded(true);
//-->
</SCRIPT>

</BODY>
</HTML>

<%
}
catch(Exception e)
{
   ExceptionHandler.displayJspException(request, response, e);
}
%>

