<!-- ==========================================================================
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2002, 2003
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
//*
 ===========================================================================-->

<!-- 
  //*----
  //* @deprecated The Product Advisor feature has been deprecated. For more information, see <a href="../../../../../../com.ibm.commerce.productadvisor.doc/concepts/cpaintro.htm">Product Advisor</a>.
  //*----
-->

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
<%@page language="java" import="com.ibm.commerce.beans.DataBeanManager,
	com.ibm.commerce.pa.tools.metaphor.containers.PAGuiConstants,
	com.ibm.commerce.pa.tools.searchspace.beans.SSCategoryListDataBean,
	com.ibm.commerce.pa.tools.searchspace.containers.SSCategoryListContainer,
      com.ibm.commerce.tools.util.*,
	com.ibm.commerce.tools.xml.XMLUtil,
	com.ibm.commerce.server.ConfigProperties,
	com.ibm.commerce.server.ServerConfiguration,
	com.ibm.commerce.tools.common.ui.taglibs.*,
	com.ibm.commerce.tools.common.ui.UIProperties" %>

<%@include file="pacommon.jsp" %>

<%
SSCategoryListDataBean ssCategoryList = null;
SSCategoryListContainer ssCatListContainer = null;
boolean compatibilityMode;
Vector ssCatListContVect = null;

ssCategoryList = new SSCategoryListDataBean();
DataBeanManager.activate(ssCategoryList,request);
ssCatListContVect = ssCategoryList.getSSCatListVect();
compatibilityMode = ssCategoryList.isCompatibilityMode();
%>

<HTML>
<HEAD>
<%= fHeader%>
<style type='text/css'>
.selectWidth {width: 235px;}
</style>
<TITLE><%= productAdvisorRB.get(PAGuiConstants.MSG_CREATE_SS_TITLE) %></TITLE>

<SCRIPT LANGUAGE="JavaScript">
<!-- hide script from old browsers -->

function initializeState()
{

<%
	for(int i=0 ; i<ssCatListContVect.size();i++)
	{
		ssCatListContainer = (SSCategoryListContainer)ssCatListContVect.elementAt(i);
%>
  document.createSSForm.availableCategories.options[<%=i%>] = new Option('<%=UIUtil.toJavaScript(ssCatListContainer.getCategoryName())%>','<%=ssCatListContainer.getCategoryId().toString()%>', false, false);
//added for defect 55117
  document.createSSForm.selectedCategories.options[0] = new Option('                                                ','key', false, false);
//end change  
<%
	}
%>

  initializeSloshBuckets(document.createSSForm.availableCategories, document.createSSForm.addButton, document.createSSForm.selectedCategories, document.createSSForm.removeButton);

  if (parent.setContentFrameLoaded) {
 	parent.setContentFrameLoaded(true);
  }
}


function savePanelData()
{
    parent.put("numberOfCategories",document.createSSForm.selectedCategories.length);
    for (var i=0; i < document.createSSForm.selectedCategories.length; i++)
    {
	parent.put("searchSpaceCategoryId_"+i,document.createSSForm.selectedCategories[i].value);
    }

}


function validatePanelData()
{
    var selected = true; 	
    if(document.createSSForm.selectedCategories.length == 0 || document.createSSForm.selectedCategories.length == null || document.createSSForm.selectedCategories.options[0].value == "key")
    {
	alertDialog("<%=getNLString(productAdvisorRB,PAGuiConstants.MSG_NO_CATEGORIES_SELECTED)%>");
	return false;   
    }
    else if(<%=compatibilityMode%>)
    {
	selected = confirmDialog("<%=getNLString(productAdvisorRB,PAGuiConstants.MSG_SS_CREATION_INFO)%>");
	return selected;
    }
    	return true;
}


function addToSelectedCategories() {
//added for defect 55117 
    if (document.createSSForm.selectedCategories.options[0].value == "key")
    {
    	document.createSSForm.selectedCategories.options[0]=null;	
    }
//end change
    move(document.createSSForm.availableCategories, document.createSSForm.selectedCategories);
    updateSloshBuckets(document.createSSForm.availableCategories, document.createSSForm.addButton, document.createSSForm.selectedCategories, document.createSSForm.removeButton);        
}

function removeFromSelectedCategories() {      
   move(document.createSSForm.selectedCategories, document.createSSForm.availableCategories);
   updateSloshBuckets(document.createSSForm.availableCategories, document.createSSForm.addButton, document.createSSForm.selectedCategories, document.createSSForm.removeButton);
//sanjib added 
   if(document.createSSForm.selectedCategories.length == 0 || document.createSSForm.selectedCategories.length == null)
    {
		document.createSSForm.selectedCategories.options[0] = new Option('                                                ','key', false, false);
    }
 //end change
}

// -->
</script>
<SCRIPT LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/Vector.js">	</SCRIPT>
<script LANGUAGE="JavaScript1.2" SRC="/wcs/javascript/tools/common/SwapList.js"></script>
<SCRIPT LANGUAGE="JavaScript">

//added for defect 55117 
	function countSelected(aComponent) {
	   var selectedCount = 0;
	   for (var i=0; i<aComponent.options.length; i++) {
	      if (aComponent.options[i].selected && aComponent.options[i].value != 'key')  {
		 selectedCount++;
	      }
	   }
	   return selectedCount;
	}
//end change

	if(<%= ssCatListContVect.isEmpty()%>){
		alertDialog("<%=getNLString(productAdvisorRB,PAGuiConstants.MSG_NO_CATEGORY_FOR_SS_CREATION)%>");
		if(top.goBack){
			top.goBack();
		}
	}
</SCRIPT>
</HEAD>

<BODY ONLOAD="initializeState()" class="content">

<FORM NAME="createSSForm">

<SPAN style="color: #565665; height: 30px; font-size: 16pt; font-family : Verdana,Arial,Helvetica;"><%=UIUtil.toHTML((String)productAdvisorRB.get(PAGuiConstants.MSG_CREATE_SS_TITLE))%></SPAN><p>

<I><%= UIUtil.toHTML((String)productAdvisorRB.get(PAGuiConstants.NEW_SEARCH_CATEGORIES_INSTRUCTIONAL_TEXT))%></I><p>

<TABLE BORDER='0' WIDTH=100%>
	<TR>
      	<TD><B><SPAN style="color: #565665; height: 20px; font-size: 12pt; font-family : Verdana,Arial,Helvetica;"><label for="selectedCategorieslb"> <%=UIUtil.toHTML((String)productAdvisorRB.get(PAGuiConstants.MSG_SELECTED_CATEGORIES))%> </label> </SPAN></B></TD>
		<TD WIDTH='15'>&nbsp;</TD>
		<TD><B><SPAN style="color: #565665; height: 20px; font-size: 12pt; font-family : Verdana,Arial,Helvetica;"><label for="availableCategorieslb"> <%=UIUtil.toHTML((String)productAdvisorRB.get(PAGuiConstants.MSG_AVAILABLE_CATEGORIES))%> </label> </SPAN></B></TD>
      </TR>
      <TR>
      	<TD>
   	     	<!-- Selected Categories -->
   	      	<SELECT NAME='selectedCategories' ID="selectedCategorieslb" CLASS='' MULTIPLE SIZE='15' onChange="javascript:updateSloshBuckets(this, document.createSSForm.removeButton, document.createSSForm.availableCategories, document.createSSForm.addButton);">
	            </SELECT>
     	      </TD>

   		<TD WIDTH='15' VALIGN='TOP'><BR><BR>
   	      	<INPUT TYPE='button' NAME='addButton' STYLE='text-align: center' VALUE="<%=UIUtil.toHTML((String)productAdvisorRB.get(PAGuiConstants.MSG_SS_CATEGORIES_BUTTON_ADD))%>" onClick="addToSelectedCategories()"><BR><BR>
	   	      <INPUT TYPE='button' NAME='removeButton' STYLE='text-align: center' VALUE="<%=UIUtil.toHTML((String)productAdvisorRB.get(PAGuiConstants.MSG_SS_CATEGORIES_BUTTON_REMOVE))%>" onClick="removeFromSelectedCategories()">
   		</TD>
            <TD>
 	   	 <!-- all available categories list -->
             <SELECT NAME='availableCategories' ID="availableCategorieslb" CLASS='' MULTIPLE SIZE='15' onChange="javascript:updateSloshBuckets(this, document.createSSForm.addButton, document.createSSForm.selectedCategories, document.createSSForm.removeButton);">
	       </SELECT>
   	  	</TD>
      </TR>
</TABLE>

</FORM>

</BODY>
</HTML>