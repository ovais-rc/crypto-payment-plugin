<!-- ========================================================================
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
 ===========================================================================-->

<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.tools.common.ui.taglibs.*" %>
<%@ page import="com.ibm.commerce.negotiation.beans.*" %>
<%@ page import="com.ibm.commerce.negotiation.util.*" %>
<%@ page import="com.ibm.commerce.negotiation.misc.*" %>
<%@ page import="com.ibm.commerce.negotiation.operation.*" %>
<%@ page import="com.ibm.commerce.beans.*" %>
<%@ page import="com.ibm.commerce.datatype.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="com.ibm.commerce.command.*"%>
<%@ page import="com.ibm.commerce.negotiation.objimpl.*"%>
<%@ page import="com.ibm.commerce.*" %>
<%@ page import="com.ibm.commerce.exception.*" %>
<%@ page import="com.ibm.commerce.server.*" %>

<%@include file="../common/common.jsp" %>

<%
try
{
%>



<%                       
   String userId = null;    
   Locale locale = null;
   String auction_Type= null;
   String storeId = null;
   Integer lang = null;
   String sortby = null;
      
   Long root_id = null;
   Long msg_id = null;
   String subject = null;
   String message = null;
        
   String forum_id = null;
   String target_id = null;
   
   String msgstatus = null;
 
                
   boolean productOnAuction = false;
   
   String productId = null;
   String product_Desc = null;
      
   boolean inGallery = false;
   String auction_Status= null;
   
   Object parms[] = null;
   
   JSPHelper help = new JSPHelper(request);
                
   String aucrfn = (String)help.getParameter("aucrfn");
         
   forum_id = (String)help.getParameter("forum_id");
   if( forum_id == null )
   {
      //forum_id 1 is for auction
      forum_id ="1";
   }
         
   target_id = (String)help.getParameter("aucrfn");
   
   msgstatus = (String)help.getParameter("msgstatus");
   if( msgstatus == null )
   {
      //msgstatus A is for active
      msgstatus ="A";
   }

                     
   CommandContext aCommandContext = (CommandContext)request.getAttribute("CommandContext"); 
       
         
   if( aCommandContext!= null )
   {
      
       
      locale = aCommandContext.getLocale();
         
      storeId = aCommandContext.getStoreId().toString();
      
      lang = aCommandContext.getLanguageId();
   }
   
   DateFormat dateFormat = DateFormat.getDateTimeInstance(DateFormat.LONG, DateFormat.MEDIUM, locale);
   
   
   // obtain the resource bundle for display
   Hashtable forumMsgListNLS = (Hashtable)ResourceDirectory.lookup("negotiations.negotiationsNLS", locale);      

   //*** GET list size and start index ***//
   int listSize = Integer.parseInt((String) help.getParameter("listsize"));
   int startIndex = Integer.parseInt((String) help.getParameter("startindex"));

%>

<HTML>
<HEAD>
<%= fHeader%>
<link rel=stylesheet href="<%= UIUtil.getCSSFile(locale) %>" type="text/css">
<TITLE><%= forumMsgListNLS.get("forummsglisttitle") %></TITLE>
     
<jsp:useBean id="auction" class="com.ibm.commerce.negotiation.beans.AuctionDataBean" >
<jsp:setProperty property="*" name="auction" />
<jsp:setProperty property="auctionId" name="auction" value="<%= aucrfn %>" />
</jsp:useBean>

<%
   
   //Need to to be uncommented after an EJB defect is fixed
   com.ibm.commerce.beans.DataBeanManager.activate(auction, request);
   productId = auction.getEntryId();
%>

<jsp:useBean id="forumMsgListBean" class="com.ibm.commerce.negotiation.beans.ForumMessageLightListBean" >
<jsp:setProperty property="*" name="forumMsgListBean" />
<jsp:setProperty property="forumId" name="forumMsgListBean" value="<%= forum_id %>" />
<jsp:setProperty property="targetId" name="forumMsgListBean" value="<%= target_id %>" />
<jsp:setProperty property="msgStatus" name="forumMsgListBean" value="<%= msgstatus %>" />
</jsp:useBean>

<%
   
   ForumMessageSortingAttribute sort = new ForumMessageSortingAttribute();
   
   sortby = help.getParameter("orderby");
   //out.println("sortby is " + sortby);
 
   if ( sortby != null && !sortby.equals("null") && !sortby.equals("") ) 
   {
     if( sortby.equals(ForumMessageSortingAttribute.POST_TIME) 
               || sortby.equals(ForumMessageSortingAttribute.VIEW_STATUS)
               || sortby.equals(ForumMessageSortingAttribute.MSG_SUBJECT) 
       )
     {
        sort.addSorting(sortby, true);
     }
     else  //ROOT_MSG_ID
     {
        sort.addSorting(ForumMessageSortingAttribute.ROOT_MSG_ID, true);
        sort.addSorting(ForumMessageSortingAttribute.PARENT_MSG_ID, true);
        sort.addSorting(ForumMessageSortingAttribute.POST_TIME, true);
     }
     
   }
   else  //default
   {
      sort.addSorting(ForumMessageSortingAttribute.ROOT_MSG_ID, true);
      sort.addSorting(ForumMessageSortingAttribute.PARENT_MSG_ID, true);
      sort.addSorting(ForumMessageSortingAttribute.POST_TIME, true);
   }
   forumMsgListBean.setSortAtt( sort );
   com.ibm.commerce.beans.DataBeanManager.activate(forumMsgListBean, request);
     
   ForumMessageLight[] aList = forumMsgListBean.getForumMessageBeans();
   int totalItems = getResultsSize(forumMsgListBean);
%>


<%!
   // move this function from list.jsp to the local file since the length is only need on the server by
   // the implemented list and not List.jsp
   public int getResultsSize(com.ibm.commerce.negotiation.beans.ForumMessageLightListBean forumMsgListBean) 
   {
     return forumMsgListBean.getForumMessageBeans().length;
   }
   
%>

<SCRIPT LANGUAGE="JavaScript">
<!---- hide script from old browsers

function myRefreshButtons(){
  parent.refreshButtons();

  if(typeof parent.checkValueHashtable == "undefined")
    parent.checkValueHashtable = new Object();

  for (var i=0; i<document.forumMsgListForm.elements.length; i++) {
      if (document.forumMsgListForm.elements[i].type == 'checkbox' && 
          document.forumMsgListForm.elements[i].name != 'select_deselect')
        if (document.forumMsgListForm.elements[i].checked)
        {
           parent.checkValueHashtable[document.forumMsgListForm.elements[i].name] = 
               document.forumMsgListForm.elements[i].value;
        }
  }

  var tempstr = new String();
  var temp;
  var temp2;
  var checked = new String(parent.getChecked());
  if(checked == "") return;

  temp2 = checked.split(",");
  for (var j = 0; j < temp2.length; j++)
  {
    tempstr = parent.checkValueHashtable[temp2[j]];
    temp = tempstr.split(",");
    var temp_status = temp[1];
    if(temp_status == "P")
    {
      if (defined(parent.buttons.buttonForm.make_publicButton)) 
	{
         parent.buttons.buttonForm.make_publicButton.id = 'disabled';
	   parent.buttons.buttonForm.make_publicButton.className ='disabled';
      } 
      return;
    }
  }
}


function userInitialButtons() {
	if (defined(parent.buttons.buttonForm.make_publicButton)) 
	{
         parent.buttons.buttonForm.make_publicButton.id = 'disabled';
         parent.buttons.buttonForm.make_publicButton.className ='disabled';
	}
      if (defined(parent.buttons.buttonForm.respondButton)) 
	{
         parent.buttons.buttonForm.respondButton.id = 'disabled';
         parent.buttons.buttonForm.respondButton.className='disabled';
	}
      if (defined(parent.buttons.buttonForm.viewButton)) 
	{
         parent.buttons.buttonForm.viewButton.id = 'disabled';
         parent.buttons.buttonForm.viewButton.className='disabled';
	}
      if (defined(parent.buttons.buttonForm.deleteButton)) 
	{
         parent.buttons.buttonForm.deleteButton.id = 'disabled';
         parent.buttons.buttonForm.deleteButton.className='disabled';
	}
      myRefreshButtons();
}

function isButtonDisabled(b) {
    if (b.className =='disabled' &&	b.id == 'disabled')
	return true;
    return false;
}

function performDelete() {
  if (confirmDialog("<%= forumMsgListNLS.get("deletemsg") %>")) {
    document.forumMsgListForm.msg_id.value = parent.getChecked()
    document.forumMsgListForm.action = "ModifyForumMessageList";
    document.forumMsgListForm.msgaction.value= "D";
    document.forumMsgListForm.startindex.value="0";
    document.forumMsgListForm.listsize.value = getListSize();
    document.forumMsgListForm.orderby.value = getSortby();
    deSelectAll();
    parent.page = 1;
    document.forumMsgListForm.submit();
    
  }
}

function makePublic() {
  if(isButtonDisabled(parent.buttons.buttonForm.make_publicButton))
    return;
  if (confirmDialog("<%= forumMsgListNLS.get("make_public_msg") %>")) {
    document.forumMsgListForm.msg_id.value = parent.getChecked()
    document.forumMsgListForm.action = "ModifyForumMessageList";
    document.forumMsgListForm.msgaction.value= "P";
    document.forumMsgListForm.startindex.value="0";
    document.forumMsgListForm.listsize.value = getListSize();
    document.forumMsgListForm.orderby.value = getSortby();
    deSelectAll();
    parent.page = 1;
    document.forumMsgListForm.submit();
  
  }
}

function onLoad() {
  parent.loadFrames()
}

function getAuctionId() {
  return document.forumMsgListForm.aucrfn.value;
}

function getForumId() {
  return document.forumMsgListForm.forum_id.value;
}

function getLang() {
  return document.forumMsgListForm.lang.value;
}

function getNewDiscussionBCT(){
  return "<%= UIUtil.toJavaScript((String)forumMsgListNLS.get("newDiscussionBCT")) %>";
}

function getRespondDiscussionBCT(){
  return "<%= UIUtil.toJavaScript((String)forumMsgListNLS.get("respondDiscussion")) %>";
}

function getViewDiscussionBCT(){
  return "<%= UIUtil.toJavaScript((String)forumMsgListNLS.get("viewDiscussion")) %>";
}

function getResultsSize() { 
     return <%= totalItems %>; 
}

function getSortby() {
     return "<%= sortby %>";
}

function getListSize() {
    return "<%= listSize %>"
}

function getUserNLSTitle() {
   return "<%= UIUtil.toJavaScript((String)forumMsgListNLS.get("forummsglisttitle")) %>"
}

parent.setResultssize(getResultsSize());
// -->
</script>

<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/common/dynamiclist.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/negotiations/auc_commonlist.js"></SCRIPT>
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

<%= comm.addControlPanel("negotiations.auc_forummsg_sclist",totalpage,totalItems,locale) %>

<FORM NAME="forumMsgListForm" action="ForumMsgListView?" method="POST">
<INPUT TYPE="HIDDEN" NAME="startindex" VALUE="">
<INPUT TYPE="HIDDEN" NAME="listsize" VALUE="">
<INPUT TYPE="HIDDEN" NAME="orderby" VALUE="">

<%= comm.startDlistTable(nul) %>
<%= comm.startDlistRowHeading() %>
<%= comm.addDlistCheckHeading(true,"parent.selectDeselectAll();userInitialButtons();myRefreshButtons();") %>
<%= comm.addDlistColumnHeading(UIUtil.toHTML((String)forumMsgListNLS.get("msg_id")), ForumMessageSortingAttribute.ROOT_MSG_ID, sortby.equals(ForumMessageSortingAttribute.ROOT_MSG_ID)) %>
<%= comm.addDlistColumnHeading(UIUtil.toHTML((String)forumMsgListNLS.get("auctionId")),"none",false) %> 
<%= comm.addDlistColumnHeading(UIUtil.toHTML((String)forumMsgListNLS.get("subject")), ForumMessageSortingAttribute.MSG_SUBJECT, sortby.equals(ForumMessageSortingAttribute.MSG_SUBJECT)) %>
<%= comm.addDlistColumnHeading(UIUtil.toHTML((String)forumMsgListNLS.get("sender")),"none",false) %> 
<%= comm.addDlistColumnHeading(UIUtil.toHTML((String)forumMsgListNLS.get("viewstatus")), ForumMessageSortingAttribute.VIEW_STATUS, sortby.equals(ForumMessageSortingAttribute.VIEW_STATUS)) %>
<%= comm.addDlistColumnHeading(UIUtil.toHTML((String)forumMsgListNLS.get("date")), ForumMessageSortingAttribute.POST_TIME, sortby.equals(ForumMessageSortingAttribute.POST_TIME)) %>
<%= comm.endDlistRow() %>


<!-- XXX need to have a for loop to lookfor all the messagess -->
<%
  int rowselect = 1;
  ForumMessageLight aForumMessageDataBean;
  int endIndex = startIndex + listSize;
  String theStatus = "";

  if (endIndex > aList.length )
  {
    endIndex = aList.length;
  }
  for (int i = startIndex; i < endIndex ; i++) 
  {
     aForumMessageDataBean = aList[i];
     root_id = aForumMessageDataBean.getRootMsgId();
     msg_id =  aForumMessageDataBean.getId();
     if( aForumMessageDataBean.getViewStatus().trim().equals("P"))
     {
        theStatus = "P";
     }
     else
     {
        theStatus = "NP";
     }                
%>

<%= comm.startDlistRow(rowselect) %>
<%= comm.addDlistCheck(msg_id.toString(), "parent.setChecked();myRefreshButtons()",msg_id.toString() + "," + theStatus) %>
<%= comm.addDlistColumn(msg_id.toString(), "javascript:top.setContent(getViewDiscussionBCT(),'DialogView?XMLFile=negotiations.auc_forummsg_view_dialog&amp;aucrfn=" + aucrfn + "&amp;msg_id=" + msg_id + "' ,true)" ) %>
<%= comm.addDlistColumn(aucrfn, "none") %>
<%= comm.addDlistColumn(UIUtil.toHTML(aForumMessageDataBean.getMsgSubject().trim()), "none") %>

  
<%
  Long posterId = aForumMessageDataBean.getPosterId();      
  String shopperFirstName = null;
  String shopperMiddleName = null;
  String shopperLastName = null;
  String senderString = null;
  try
  {
     //useBean tag will cause problem when a user's name is not defined, such as ncadmin
     //new will do the job
     com.ibm.commerce.user.beans.UserInfoDataBean aRegister = new com.ibm.commerce.user.beans.UserInfoDataBean();
// bobz 8/1/01 changed posterId to posterId.toString()
     aRegister.setUserId (posterId.toString() );
     com.ibm.commerce.beans.DataBeanManager.activate(aRegister, request);
     shopperFirstName = aRegister.getFirstName();
     shopperMiddleName = aRegister.getMiddleName();
     shopperLastName = aRegister.getLastName();
     
          
     if( shopperLastName == null )
     {
        shopperLastName = "";   
     }
     
     if( shopperMiddleName == null )
     {
        shopperMiddleName = "";   
     }
     
     if( shopperFirstName == null)
     {
        shopperFirstName = "";
     }
          
     senderString = (String)forumMsgListNLS.get("author");
     parms = new Object[4];
     parms[0] = shopperFirstName;
	 parms[1] = shopperMiddleName;
	 parms[2] = shopperLastName;
     senderString = MessageFormat.format(senderString, parms);
     
  }
  catch(Exception e)
  {
     senderString = "";
  }
 
                                   
%>

<%= comm.addDlistColumn(UIUtil.toHTML(senderString), "none") %>
   
  
<% if( aForumMessageDataBean.getViewStatus().trim().equals("P") ) { %> 
<%= comm.addDlistColumn(UIUtil.toHTML((String)forumMsgListNLS.get("public")), "none") %>
<% } else { %>
<%= comm.addDlistColumn(UIUtil.toHTML((String)forumMsgListNLS.get("not_public")), "none") %>
<% }%>
  
<%
   java.sql.Timestamp postTime = aForumMessageDataBean.getPostTime();
   String dateString = dateFormat.format( postTime );
%>  
  
<%= comm.addDlistColumn(UIUtil.toHTML(dateString), "none") %>  

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

   <INPUT TYPE="hidden" NAME="aucrfn" VALUE=<%= aucrfn %> >
   <INPUT TYPE="hidden" NAME="msgaction" VALUE=""> 
   <INPUT TYPE="hidden" NAME="msgstatus" VALUE=<%= msgstatus %>> 
   <INPUT TYPE="hidden" NAME="forum_id" VALUE=<%= forum_id %>>
   <INPUT TYPE="hidden" NAME="msg_id" VALUE="">
   <INPUT TYPE="hidden" NAME="viewtask" VALUE="ForumMsgListView">
   <INPUT TYPE="hidden" NAME="lang" VALUE=<%= lang %>>
  
</FORM>
<% if( aList.length == 0 ) {%>
<P>
<P>
<% 
      out.println( UIUtil.toHTML((String)forumMsgListNLS.get("emptyDiscussionList")) ); 
   }
%>

<SCRIPT LANGUAGE="Javascript">
   parent.afterLoads();
</SCRIPT>

</BODY>
</HTML>

<%
}
catch(ECSystemException e)
{
   ExceptionHandler.displayJspException(request, response, e);
}
%>

