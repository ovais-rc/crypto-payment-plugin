//
//-------------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (c) Copyright IBM Corp. 2006
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//-------------------------------------------------------------------
//

// @deprecated The Product Advisor feature has been deprecated. For more information, see <a href="../../../../../../com.ibm.commerce.productadvisor.doc/concepts/cpaintro.htm">Product Advisor</a>.

function createRemoveVector(){
	var remVec = top.get("vectorDataRemove");
	var addVec = top.get("vectorDataAdd");
	var widgetCNArray = top.get("widgetClassNameArray",null);
	var widgetDNArray = top.get("widgetDisplayNameArray",null);
	var checked = parent.getChecked();
	var objArray = new Array();

	for(var i=0;i<checked.length;i++){
		var obj = elementAt((checked[i]-(-0)),remVec);
		obj.display = "0";
		obj.sequence = 0;
		obj.sortOrder = "true";
		obj.widget = widgetDNArray[0];
		obj.widgetClassName = widgetCNArray[0];
		objArray[i] = obj;
		addElement(obj,addVec);
	}

	for(var i=0;i<objArray.length;i++){
		paRemoveElement(objArray[i],remVec);
	}

	top.put("vectorDataRemove",remVec);
	top.put("vectorDataAdd",addVec);
}


function refreshTable()
{
	var checked = parent.getChecked();
	var tableId = 'peFeatureListSummaryID';
	var table = getTable(tableId);

	if((checked.length > 0) && (checked.length <= (table.rows.length-1))){
		var checkLength = document.peForm.elements.length;
		for (var i=0; i<checkLength; i++) {
		    var e = document.peForm.elements[i];
		    if (e.type == 'checkbox') {
      		if (e.name != 'select_deselect' && e.checked) {
				document.peForm.elements[i].click();
      		}
	    	   }
		}

		checked.sort(compareStrings);
		for(var i=checked.length-1;i>=0;i--){
			var rowNo = checked[i]-(-1);
			delRow(tableId,rowNo);
		}
		
		var tlen = getTable(tableId).rows.length;
		
		if(tlen == 1)
		{
		 //Need to put a refresh method.
		}
		var rVector = top.get("vectorDataRemove");
		var widgetDisplayNameList = top.get("widgetDisplayNameArray");
		var widgetClassNameList = top.get("widgetClassNameArray");	
		//var sortArray = new Array("Ascending","Descending");
		var sortArray = top.get("sortarrayData");

		var sortOrder;
		for(var i=1;i<tlen;i++){
			var obj = elementAt(i-1,rVector);
			insCheckBox(tableId,i,0,i-1,"parent.setChecked();myRefreshButtons()");
			insCell(tableId,i,1,obj.sequence);
			insCell(tableId,i,2,obj.displayColumnName);
			insCell(tableId,i,3,obj.description);
			insWidgetDropDownList(tableId,i,4,obj.name,"updateWidgetType(selectedIndex,"+(i-1)+")",widgetDisplayNameList,widgetClassNameList,obj.widgetClassName);
			if(obj.sortOrder == 'true')
			{
			sortOrder = getAscText();
			}
			else
			{
			sortOrder = getDescText();		
			}
			insDropDownList(tableId,i,5,object.name,"updateSortOrderType(selectedIndex,"+(i-1)+")",sortarray,sortOrder);
		}
		parent.setChecked();
		myRefreshButtons();
	}
}


function updateWidgetType(widgetIndex,vecPos)
{
	
	var remVector = top.get("vectorDataRemove");

	var featureObj = elementAt(vecPos,remVector);
	var widgetCNArray = top.get("widgetClassNameArray",null);
	var widgetDNArray = top.get("widgetDisplayNameArray",null);
	featureObj.widget = widgetCNArray[widgetIndex];

	var tempRemVector = new Vector();
	for(var i=0; i<size(remVector); i++)
	{
		var tempObj = elementAt(i,remVector);
		if(i == vecPos)
		{
			tempObj.widget = widgetDNArray[widgetIndex];
			tempObj.widgetClassName = widgetCNArray[widgetIndex];
			addElement(tempObj,tempRemVector);
		}
		else
		{
			addElement(tempObj,tempRemVector);
		}
	}
	top.put("vectorDataRemove",tempRemVector);
}

function updateSortOrderType(orderIndex,vecPos)
{
	var remVector = top.get("vectorDataRemove");
	
	var tempRemVector = new Vector();
	for(var i=0; i<size(remVector); i++)
	{
		var tempObj = elementAt(i,remVector);
		if(i == vecPos)
		{
			if(orderIndex == 0)
			{
			tempObj.sortOrder = "true"
			}
			else
			{
			tempObj.sortOrder = "false"
			}
			addElement(tempObj,tempRemVector);
		}
		else
		{
			addElement(tempObj,tempRemVector);
		}
	}
	top.put("vectorDataRemove",tempRemVector);
}

function moveUp()
{
	if(isButtonDisabled(parent.buttons.buttonForm.moveUpButton)){
		return;
	}

	var checked = parent.getChecked();
	if (checked.length > 0)
	{
		var moved_index = checked[0];

		var rVector = top.get("vectorDataRemove");

		var shifted_index = moved_index-1;

		var moved_object = elementAt(moved_index,rVector);
		var shifted_object = elementAt(shifted_index,rVector);

		var moved_sequence = moved_object.sequence;
		var shifted_sequence = shifted_object.sequence;

		moved_object.sequence = shifted_sequence;
		shifted_object.sequence = moved_sequence;

		var tempVector = new Vector();

		for(var i=0;i<size(rVector);i++){
			var tempObj = elementAt(i,rVector);
			if(i == moved_index){
				tempObj = shifted_object;
			}
			if(i == shifted_index){
				tempObj = moved_object;
			}
			addElement(tempObj,tempVector);
		}

		top.put("vectorDataRemove",tempVector);
//vector manip ends

//test
	moved_index = moved_index-(-1);
	shifted_index = moved_index-1;
	var tableId = 'peFeatureListSummaryID';
	var table = getTable(tableId);

	var rVector = top.get("vectorDataRemove");
	var widgetDisplayNameList = top.get("widgetDisplayNameArray");
	var widgetClassNameList = top.get("widgetClassNameArray");	
	//var sortArray = new Array("Ascending","Descending");
	var sortArray = top.get("sortarrayData");
	
	var tlen = table.rows.length;
	var sortOrder;
	for(var i=1;i<tlen;i++){
		var obj = elementAt(i-1,rVector);
		insCheckBox(tableId,i,0,i-1,"parent.setChecked();myRefreshButtons()");
		insCell(tableId,i,1,obj.sequence);
		insCell(tableId,i,2,obj.displayColumnName);
		insCell(tableId,i,3,obj.description);
		insWidgetDropDownList(tableId,i,4,obj.name,"updateWidgetType(selectedIndex,"+(i-1)+")",widgetDisplayNameList,widgetClassNameList,obj.widgetClassName);
		if(obj.sortOrder == 'true')
		{
		sortOrder = getAscText();
		}
		else
		{
		sortOrder = getDescText();		
		}

		insDropDownList(tableId,i,5,object.name,"updateSortOrderType(selectedIndex,"+(i-1)+")",sortarray,sortOrder);
	}
	var checkLength = document.peForm.elements.length;
	for (var i=0; i<checkLength; i++) {
	    var e = document.peForm.elements[i];
	    if (e.type == 'checkbox') {
     		if (e.name != 'select_deselect' && !e.checked && e.name == (shifted_index-1).toString()) {
			document.peForm.elements[i].click();
     		}
    	   }
	}
	return;
  }// If checked end

}

function moveDown()
{

	if(isButtonDisabled(parent.buttons.buttonForm.moveDownButton)){
		return;
	}

	var checked = parent.getChecked();
	if (checked.length > 0)
	{
		var moved_index = checked[0];

		var rVector = top.get("vectorDataRemove");

		var shifted_index = moved_index-(-1);

		var moved_object = elementAt(moved_index,rVector);
		var shifted_object = elementAt(shifted_index,rVector);

		var moved_sequence = moved_object.sequence;
		var shifted_sequence = shifted_object.sequence;

		moved_object.sequence = shifted_sequence;
		shifted_object.sequence = moved_sequence;

		var tempVector = new Vector();
		for(var i=0;i<size(rVector);i++){
			var tempObj = elementAt(i,rVector);
			if(i == moved_index){
				tempObj = shifted_object;
			}
			if(i == shifted_index){
				tempObj = moved_object;
			}
			addElement(tempObj,tempVector);
		}

		top.put("vectorDataRemove",tempVector);
//vector manip ends

//test
	moved_index = moved_index-(-1);
	shifted_index = moved_index-(-1);
	var tableId = 'peFeatureListSummaryID';
	var table = getTable(tableId);

	var rVector = top.get("vectorDataRemove");

	var widgetDisplayNameList = top.get("widgetDisplayNameArray");
	var widgetClassNameList = top.get("widgetClassNameArray");	
	//var sortArray = new Array("Ascending","Descending");
	var sortArray = top.get("sortarrayData");
	
	var tlen = table.rows.length;
	var sortOrder;
	for(var i=1;i<tlen;i++){
		var obj = elementAt(i-1,rVector);
		insCheckBox(tableId,i,0,i-1,"parent.setChecked();myRefreshButtons()");
		insCell(tableId,i,1,obj.sequence);
		insCell(tableId,i,2,obj.displayColumnName);
		insCell(tableId,i,3,obj.description);
		insWidgetDropDownList(tableId,i,4,obj.name,"updateWidgetType(selectedIndex,"+(i-1)+")",widgetDisplayNameList,widgetClassNameList,obj.widgetClassName);
		if(obj.sortOrder == 'true')
		{
		sortOrder = getAscText();
		}
		else
		{
		sortOrder = getDescText();		
		}

		insDropDownList(tableId,i,5,object.name,"updateSortOrderType(selectedIndex,"+(i-1)+")",sortarray,sortOrder);
	}
	var checkLength = document.peForm.elements.length;
	for (var i=0; i<checkLength; i++) {
	    var e = document.peForm.elements[i];
	    if (e.type == 'checkbox') {
     		if (e.name != 'select_deselect' && !e.checked && e.name == (shifted_index-1).toString()) {
			document.peForm.elements[i].click();
     		}
    	   }
	}
	return;
  }// If checked end

}
