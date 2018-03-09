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
<%@ page import="com.ibm.commerce.condition.*"%>
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
   //Vector attr_id = new Vector();
   Vector attr_name  = new Vector();
   Vector attr_value   = new Vector();

   String userId = null;    
   Locale locale = null;
   String storeId = null;
   String lang = null;
   String sortby = null;
   Integer resGrpId = null;
   Integer selectResource = null;
   Integer resourceId = null;
   boolean isUpdatable = true;

   
                    
   CommandContext aCommandContext = (CommandContext)request.getAttribute("CommandContext"); 
      
         
   if( aCommandContext!= null )
   {
      locale = aCommandContext.getLocale();
      storeId = aCommandContext.getStoreId().toString();
      lang = aCommandContext.getLanguageId().toString();
      userId = aCommandContext.getUserId().toString();
   }
//   resGrpId = Integer.valueOf((String)(request.getParameter("resGrpId")));
//   String s = request.getQueryString();

//   int resIndex = s.indexOf("resGrpId=");
//   String resGrpIdStr = s.substring(resIndex + "resGrpId=".length());

   String resGrpIdStr = (String)request.getParameter("resGrpId");
   resGrpId = Integer.valueOf(resGrpIdStr);
   int startIndex = Integer.parseInt(request.getParameter("startindex"));
   int listSize = Integer.parseInt(request.getParameter("listsize"));

   //PolicySortingAttribute sort = new PolicySortingAttribute();
   // obtain the resource bundle for display
   Hashtable resourcegroupListNLS = (Hashtable)ResourceDirectory.lookup("policyeditor.policyeditorNLS", locale);      
%>

<link rel=stylesheet href="<%= UIUtil.getCSSFile(locale) %>" type="text/css">
<TITLE><%= UIUtil.toHTML((String)resourcegroupListNLS.get("resourceGroupListTitle")) %></TITLE>

<jsp:useBean id="resattrListBean" class="com.ibm.commerce.accesscontrol.policyeditor.beans.ResGrpImplUpdateDataBean" >
<jsp:setProperty property="*" name="resattrListBean" />
<jsp:setProperty property="id" name="resattrListBean" value="<%= resGrpId %>" />
</jsp:useBean>

<SCRIPT LANGUAGE="JavaScript">
	  var isUpdatable = true;
</script>

<% 
   int aListlen = 0;   
   //PolicySortingAttribute newsort = new PolicySortingAttribute();

   //sortby = request.getParameter("orderby");
   //newsort.setTableAlias("T5"); 
   //newsort.addSorting(sortby, true);
    
   //resattrListBean.setSortAtt( newsort );
     
   com.ibm.commerce.beans.DataBeanManager.activate(resattrListBean, request);
   if (!resattrListBean.getIsUpdateable()) 
   {
	  isUpdatable = false;
%>
<SCRIPT LANGUAGE="JavaScript">
	  isUpdatable = false;
</script>
<%
   }
   SimpleCondition[] aList = resattrListBean.getSConditionArray();
   aListlen = aList.length;
%>

<%!
public static String addDlistColumnEntry(String name, String entryName, String checkboxName, String size) throws com.ibm.commerce.exception.ECSystemException {

	  StringBuffer tmpStr = new StringBuffer(500);
	  tmpStr.append("<TD ");
	  tmpStr.append(" CLASS=\"list_info1\"><INPUT TYPE=TEXT MAXLENGTH=128 NAME='"+entryName+"' SIZE='"+size+"' VALUE=\""+name+"\" ONCHANGE=\"javascript:valueChange('"+checkboxName+"')\"></TD>");
	  return tmpStr.toString();
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
     return <%= resattrListBean.getSConditionArray().length %>; 
}

function savePanelData()
{
      myModel.product = new Array();
      myModel.product.push(myAttributes);
  
      document.createForm.XML.value = convertToXML(myModel, "myModel");
	  parent.put("implResGrpDetails", myModel);
}

function doPrompt (field,msg)
{
      alertDialog(msg);
      field.focus();
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

   if(totalcount==aListlen && isUpdatable != false)
   {
     doPrompt(document.createForm.attr_value, attributevalueMissing);
     return false;
   }
   return true;
}

 function onLoad() 
   {
//     parent.loadFrames();
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
       var s1 = "attribute" + index;
       var s2 = "value" + index;
       myAttributes[s1] = trim(attribute);
       myAttributes[s2] = trim(value);
      }
	//parent.put("implResGrpDetails", myAttributes);
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
<SCRIPT LANGUAGE="JavaScript">
<!--
//For IE
if (document.all) {
    onLoad();
}
//-->
</SCRIPT>


<%
          int endIndex = aList.length;
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

<%= comm.startDlistTable(nul) %>
<%= comm.startDlistRowHeading() %>
<%= comm.addDlistColumnHeading(UIUtil.toHTML((String) resourcegroupListNLS.get("resourceAttributeHeader")), "none", false) %>
<%= comm.addDlistColumnHeading(UIUtil.toHTML((String)resourcegroupListNLS.get("resourceValueHeader")), "none", false) %>
<%= comm.endDlistRow() %>
         
<%
  for (int i = startIndex; i < endIndex ; i++)
  {
   String index = "" + i;
   //attr_id.addElement(aList[i].getAttrId());
   attr_name.addElement(aList[i].getVariable());
   attr_value.addElement(aList[i].getValue());
%>
<%= comm.startDlistRow(rowselect) %>
<INPUT TYPE=HIDDEN NAME="attr_name" VALUE="<%=attr_name.elementAt(i)%>">
<%= comm.addDlistColumn(aList[i].getVariable(),"none") %>
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

<% if( aList.length == 0 ) {%>
<P>
<P>
<%  if (isUpdatable)
	{
		out.println( UIUtil.toHTML((String)resourcegroupListNLS.get("emptyresourcegroupImplList")) ); 
	}
   }
%>
<SCRIPT>
   <!--
   var count=document.createForm.counter.value;
   myAttributes["count"] = count;
	myAttributes["isUpdatable"] = isUpdatable;

   for (cnt = 0; cnt < count; cnt++)
    {
     valueChange(cnt);
    }

    parent.setContentFrameLoaded(true);

    if (isUpdatable == false)
	{
		alertDialog('<%=UIUtil.toJavaScript((String)resourcegroupListNLS.get("resourceGroupImplicitResolveFailed"))%>');	
	}
   //-->
</SCRIPT>
<%
	if (!isUpdatable) 
	{
 %>
<%=UIUtil.toHTML((String)resourcegroupListNLS.get("resourceGroupImplicitResolveFailed"))%>
<%
	}
%>
</BODY>
</HTML>

<%
}
catch(Exception e)
{
   ExceptionHandler.displayJspException(request, response, e);
}
%>

