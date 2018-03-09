<%--==========================================================================
Licensed Materials - Property of IBM

WebSphere Commerce

(c) Copyright IBM Corp.  2006
All Rights Reserved

US Government Users Restricted Rights - Use, duplication or
disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
===========================================================================--%>
<%@ page import="java.util.*" %>
<%@ page import="java.math.*" %>
<%@ page import="com.ibm.commerce.server.*" %>
<%@ page import="com.ibm.commerce.server.ECConstants" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.server.*" %>
<%@ page import="com.ibm.commerce.tools.common.ui.taglibs.*" %>
<%@ page import="com.ibm.commerce.tools.util.UIUtil" %>
<%@ page import="com.ibm.commerce.payment.ppc.beans.*" %>
<%@ page import="com.ibm.commerce.payments.plugincontroller.Payment" %>
<%@ page import="com.ibm.commerce.payments.plugin.ExtendedData" %>
<%@ include file="../common/common.jsp" %>
<%@ include file="ppcUtil.jsp" %>
<%
// obtain the resource bundle for display
CommandContext cmdContextLocale = (CommandContext) request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
Locale jLocale = cmdContextLocale.getLocale();
Integer langId = cmdContextLocale.getLanguageId();
Integer storeId = cmdContextLocale.getStoreId();
String currency = cmdContextLocale.getCurrency();
Hashtable ppcLabels = (Hashtable) ResourceDirectory.lookup("edp.ppcLabels", jLocale);

JSPHelper jspHelper = new JSPHelper(request);

String paymentId = request.getParameter("paymentId");

PPCGetPaymentDataBean paymentDataBean = new PPCGetPaymentDataBean();
paymentDataBean.setPaymentId(paymentId);

com.ibm.commerce.beans.DataBeanManager.activate(paymentDataBean, request);

ExtendedData extData = paymentDataBean.getTranExtendedData();
 HashMap hashData = extData.getExtendedDataAsHashMap();
Set keySet = hashData.keySet();
Iterator iter = keySet.iterator();
int index = 0;
%>

<html>
<head>
<title><%=UIUtil.toHTML((String) ppcLabels.get("title"))%></title>

<SCRIPT SRC="/wcs/javascript/tools/common/dynamiclist.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/common/NumberFormat.js"></SCRIPT>
<script src="/wcs/javascript/tools/common/Util.js"></script>
<script language="JavaScript">
	var back = "";
	back = top.getData("back");	
	
	var row = 1;
	var checkBoxes=new Array();	
	var ListDatas = new ListDate("payment");
	var types=new Array('Boolean','Integer','Long','BigDecimal','String');	
	var typesTranslated=new Array('<%=ppcLabels.get("Boolean")%>','<%=ppcLabels.get("Integer")%>','<%=ppcLabels.get("Long")%>','<%=ppcLabels.get("BigDecimal")%>','<%=ppcLabels.get("String")%>');	
	var strTrue = '<%=UIUtil.toJavaScript(ppcLabels.get("true"))%>';
	var strFalse = '<%=UIUtil.toJavaScript(ppcLabels.get("false"))%>';
	
	var nameLabel = '<%=ppcLabels.get("name")%>';
	var valueLabel = '<%=ppcLabels.get("value")%>';
	var typeLabel = '<%=ppcLabels.get("type")%>';

function ListDate(instanceName) {
  this.instanceName = instanceName;
  this.data = new Array();
  this.deleteIndex = deleteIndex;
}

function extData(key,value,type){
	this.key=key;
	this.value=value;
	this.type=type;	
}
function insSelect(tableid,row,col,name,fnc,values,selected,label) {
	
	var len = arguments.length;
	var cont = '<label class=\"hidden-label\" for="'+name+'">'+label+'</label><select name="'+name+'" id="'+name+'" onchange='+ fnc + '>';				
		
	var selectNum = values.length;
	
	for(var i=0;i<selectNum;i++){
		if(len>6 && selected!=null && values[i]==selected){
			cont += '<option value="'+ values[i] +'" selected>'+ typesTranslated[i] +'</option>';			
		}else{
			cont += '<option value="'+ values[i] +'">'+ typesTranslated[i] +'</option>';
		}
	}
	cont += '</select>';
	insCell(tableid,row,col,cont);
	
	var c = getCell(tableid,row,col);
	c.style.backgroundColor='#C4C6CB';
	c.style.width='16px';
}

function insBooleanSelect(tableid,row,col,name,fnc,selected,label) {
	
	var len = arguments.length;
	var cont = '<label class=\"hidden-label\" for="'+name+'">'+label+'</label><select name="'+name+'" id="'+name+'" onchange="'+ fnc + '">';	
	
	if(selected=='false'){
		cont += '<option value="true" >'+ strTrue +'</option>';
		cont += '<option value="false" selected>'+ strFalse +'</option>';			
	}else{
		cont += '<option value="true" selected>'+ strTrue +'</option>';
		cont += '<option value="false" >'+ strFalse +'</option>';
	}
	cont += '</select>';
	insCell(tableid,row,col,cont);
	
	var c = getCell(tableid,row,col);
	c.style.backgroundColor='#C4C6CB';
	c.style.width='16px';
}
function initializeDynamicList(tableName) {

  startDlistTable(tableName,'100%');
  startDlistRowHeading();
  addDlistCheckHeading(true,'setAllCheckBoxesCheckedTo(this.checked);');
  addDlistColumnHeading("<%=UIUtil.toJavaScript(ppcLabels.get("name"))%>",true,null,null,null);
  addDlistColumnHeading("<%=UIUtil.toJavaScript(ppcLabels.get("value"))%>",true,null,null,null);  
  addDlistColumnHeading("<%=UIUtil.toJavaScript(ppcLabels.get("type"))%>",true,null,null,null); 
  endDlistRowHeading();
  endDlistTable();

}

function addButton(tableid) {
	clearDynamicList(tableid);
	var index = ListDatas.data.length;
	ListDatas.data[index]=new extData('','','String');
	ListDatas.outputToDynamicList(tableid);
	enableButtonsBasedOnCheckboxes();
}

function enableButtonsBasedOnCheckboxes(){
  count=0;
  for(var i=0;i<checkBoxes.length;i++) {
    if (checkBoxes[i].checked) count++;
  }
	
  eval(select_deselect).checked=(count==checkBoxes.length && count!=0);
  	  
}

function modifyButton() {
	for(var i=0;i<ListDatas.data.length;i++){		
		ListDatas.data[i].key=eval("key"+i).value;
		ListDatas.data[i].value=eval("value"+i).value;
		ListDatas.data[i].type=eval("type"+i).value;
	}
}

function changeData(){
	for(var i=0;i<ListDatas.data.length;i++){
		ListDatas.data[i].key=eval("key"+i).value;
		ListDatas.data[i].value=eval("value"+i).value;
		ListDatas.data[i].type=eval("type"+i).value;
		
	}
	clearDynamicList('extdata');
	ListDatas.outputToDynamicList('extdata');
}

function deleteButton(tableid){

	var checkedArray=getCheckedArray();
	if(checkedArray.length==0){
		 parent.alertDialog('<%=UIUtil.toJavaScript(ppcLabels.get("noExtendedDataSelectedError"))%>');
	}	else{

	     if (parent.confirmDialog('<%=UIUtil.toJavaScript(ppcLabels.get("deleteConfirmationMessage"))%>')) {   	
    	       for (var i=0;checkedArray.length>i;i++) {
      		   //every delete ,the array length will -1,so the del index must -1	      		
      		   ListDatas.deleteIndex(checkedArray[i]-i);     		      		
    	       }   	
	     }
	     clearDynamicList(tableid);
	     ListDatas.outputToDynamicList(tableid);
	     setAllCheckBoxesCheckedTo(false);
   }
}
	


function getCheckedArray() {
  checkedArray=new Array();
  for(var i=0;i<checkBoxes.length;i++) {  
    if (checkBoxes[i].checked){
    	checkedArray[checkedArray.length]=Number(checkBoxes[i].value);
    }
  }
  
  return checkedArray;
}


function checkBoxName(tableid,i) {
  return (tableid + "CheckBox" + i);
}

function setAllCheckBoxesCheckedTo(checkedValue) {
	
  for(var i=0;i<checkBoxes.length;i++) {
    checkBoxes[i].checked=checkedValue;
  }
 
}
function loadPanelData(){

    if (parent.setContentFrameLoaded)
	{
	   parent.setContentFrameLoaded(true);
	}
	
	if(back == "back"){
		
		if(top.getData("extData")!=null ){			
			ListDatas.data=top.getData("extData");			
			ListDatas.outputToDynamicList('extdata');
		}
	}
	
}

function validateNoteBookPanel () {
	var datasize = ListDatas.data.length;
	for(var i=0;i<datasize;i++){
		var key1=ListDatas.data[i].key;
		var value1= ListDatas.data[i].value;
		var type1 = ListDatas.data[i].type;
		if(key1 == null || value1 == null ){
			
			parent.alertDialog('<%=UIUtil.toJavaScript(ppcLabels.get("emptyExtendedDataKeyOrValueError"))%>');
			return false;
		}else if(key1.indexOf('')){
			
			parent.alertDialog('<%=UIUtil.toJavaScript(ppcLabels.get("emptyExtendedDataKeyOrValueError"))%>');
			return false;
		}
		for(var j=i+1;j<datasize;j++){
			var key2=ListDatas.data[j].key;
			if(key1==key2){
				parent.alertDialog('<%=UIUtil.toJavaScript(ppcLabels.get("sameExtendedDataKeyError"))%>');
				return false;
			}
		}
		if(!checkValue(key1,value1,type1,i)){			
			return false;
		}
		
	} 
	return true;
}

function savePanelData(){
	
	parent.put("extData",ListDatas.data);
	parent.put("extDataSize",ListDatas.data.length);
	top.saveData(ListDatas.data,"extData");	
	top.saveData("back", "back");
		
}

function outputToDynamicList(tableName) {

  checkBoxes=new Array(); 

  for (i=0;i<this.data.length;i++) {
    var dynamicListIndex=i+1;

    insRow(tableName,dynamicListIndex);
    insCheckBox(tableName,dynamicListIndex,0,checkBoxName(tableName,i),'enableButtonsBasedOnCheckboxes()',i);
	checkBoxes[i]=eval(checkBoxName(tableName,i));
    
    if(this.data[i]==null){
    	
    	insCell(tableName,dynamicListIndex,1,"<label class=\"hidden-label\" for=\"key"+i+"\">"+nameLabel+"</label><INPUT name=\"key"+i+"\" id=\"key"+i+"\" type=\"text\" maxlength=\"256\" onChange=\"changeData()\" value=\"\">");
    	insCell(tableName,dynamicListIndex,2,"<label class=\"hidden-label\" for=\"value"+i+"\">"+valueLabel+"</label><INPUT name=\"value"+i+"\" id=\"value"+i+"\" type=\"text\" maxlength=\"256\" onChange=\"changeData()\" value=\"\">");
    	insSelect(tableName,dynamicListIndex,3,'type'+i,'changeData()',types,'String',typeLabel);
    	    	
  	}else{
 		insCell(tableName,dynamicListIndex,1,"<label class=\"hidden-label\" for=\"key"+i+"\">"+nameLabel+"</label><INPUT name=\"key"+i+"\" id=\"key"+i+"\" type=\"text\" maxlength=\"256\" onChange=\"changeData()\" value=\""+this.data[i].key +"\">");
 		if(this.data[i].type=='Boolean'){
 			if(this.data[i].value==null||this.data[i].value==""){
 		    	this.data[i].value=true;
 		    }
 			insBooleanSelect(tableName,dynamicListIndex,2,'value'+i,'changeData()',this.data[i].value,valueLabel);
 		}else{
	 		insCell(tableName,dynamicListIndex,2,"<label class=\"hidden-label\" for=\"value"+i+"\">"+valueLabel+"</label><INPUT name=\"value"+i+"\" id=\"value"+i+"\" type=\"text\" maxlength=\"256\" onChange=\"changeData()\" value=\""+this.data[i].value +"\">");	 	 		
	 	}
  		insSelect(tableName,dynamicListIndex,3,'type'+i,'changeData()',types,this.data[i].type,typeLabel);
  		
  	}


  }
}
function clearDynamicList(tableName) {

  while (eval(tableName).rows.length>1) {
    delRow(tableName,1);
  }

}
function deleteIndex(index) {
    this.data.splice(index,1);
}


function checkValue(key,value,type,index){

	index+=1;
	if(type=='string'){
		return true;
	}else if(type=='BigDecimal'){
		if(!parent.isValidNumber(value)){
			parent.alertDialog('<%=UIUtil.toJavaScript(ppcLabels.get("typeFormatError"))%>'+index);
			return false;
		}
	}else if(type=='Integer'||type=='Long'){
		if(!parent.isValidInteger(value)){
			parent.alertDialog('<%=UIUtil.toJavaScript(ppcLabels.get("typeFormatError"))%>'+index);
			return false; 
		}
	}
	
	
	return true; 
}
</script>
<LINK rel="stylesheet" href="<%=UIUtil.getCSSFile(jLocale)%>"
	type="text/css">
</head>

<body onLoad="loadPanelData()" CLASS="content">
<!--JSP File name :ppcEditPaymentExtendedData.jsp -->
<H1><%=UIUtil.toHTML((String) ppcLabels.get("editPendingPaymentExtendedData"))%></H1>
<SCRIPT>
	ListDatas.initializeDynamicList=initializeDynamicList;
	ListDatas.outputToDynamicList=outputToDynamicList;
	
</SCRIPT>
<TABLE ID="layoutTable" width=80%>

	<TR>
		<TD ALIGN="LEFT" VALIGN="TOP" COLSPAN=2></TD>
	</TR>
	<TR>
		<TD ALIGN="LEFT" VALIGN="TOP"><SCRIPT>ListDatas.initializeDynamicList('extdata');</SCRIPT></TD>
		<TD ALIGN="LEFT" VALIGN="TOP">
		<TABLE width="50%">
			<TR>
				<TD>
				<BUTTON type="BUTTON" value="Add" name="addButton" CLASS="enabled"
					onClick="if(this.className=='enabled') addButton('extdata');"><%=UIUtil.toHTML((String) ppcLabels.get("addButton"))%></BUTTON>
				</TD>
			</TR>
			<TR>
				<TD>
				<BUTTON type="BUTTON" value="Delete" name="deleteButton"
					CLASS="enabled" 
					onClick="if(this.className=='enabled') deleteButton('extdata');"><%=UIUtil.toHTML((String) ppcLabels.get("deleteButton"))%></BUTTON>
				</TD>
			</TR>
		</TABLE>
		</TD>
	</TR>
</TABLE>
<SCRIPT>
	
	ListDatas.initializeDynamicList=initializeDynamicList;
	ListDatas.outputToDynamicList=outputToDynamicList;
	
<%
	while (iter.hasNext()) {
	String key = (String) iter.next();	
	String value = (hashData.get(key)).toString();
	short typeCode = extData.getType(key);	
	String type = getTypeStr(typeCode);
%>
	
	if(back !="back"){
		ListDatas.data[<%=index%>]=new extData('<%=key%>','<%=value%>','<%=type%>');
		
	}
<% 
	index++; 
	}
%>	
	ListDatas.outputToDynamicList('extdata');
		
</SCRIPT>
</body>

</html>
