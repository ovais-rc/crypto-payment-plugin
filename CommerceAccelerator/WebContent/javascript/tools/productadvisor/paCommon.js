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

function visibleList (s) {

	if (defined(this.document) == false || this.document.readyState != "complete") {
		return;
	}

	if (defined(this.document.visibleList)) {
		this.document.visibleList(s);
		return;
	}

	if (defined(this.document.forms[0])) {
		for (var i = 0; i < this.document.forms[0].elements.length; i++) {
			if (this.document.forms[0].elements[i].type.substring(0,6) == "select") {
				this.document.forms[0].elements[i].style.visibility = s;
			}
		}
	}
}


/*********************************************************************/
/*              tableid:  the ID of the table                        */
/*              row: the row number                                  */
/*              col: the column number                               */
/*              name: the name of the dropdown                       */
/*              fnc: javascript function used to refresh buttons etc.*/
/*              value: the value of the dropdown                     */
/*              selected: the value of the dropdown to be selected   */
/*********************************************************************/
function insDropDownList(tableid,row,col,name,fnc,values,selected)
{
   var len = arguments.length;
   var cont = "<SELECT ";
   if( len>3 && name != null ){
       if( len>4 && fnc != null ){
           cont += " NAME=\"" + name + "\" onChange=\"" + fnc + "\" >";
       }else{
           cont += " NAME=\"" + name + "\" >";
       }
   }	
      if( len>5 && values != null && values.length > 0)
	{
      	for (var i=0 ; i< values.length ; i++)
		{
			if(selected == values[i])
			{
		           cont +="<OPTION value=\"" + values[i] + "\" selected>" +values[i]+ "</OPTION>";
			}
			else
			{
		           cont +="<OPTION value=\"" + values[i] + "\" >" +values[i]+ "</OPTION>";
			}
		}
	}
      else
	{
		cont +="<OPTION value=''></OPTION>";
     	}

   cont +="</SELECT>";
   insCell(tableid,row,col,cont);
}


/********************************************************************************************/
/*              tableid:  the ID of the table                        						*/
/*              row: the row number                                  						*/
/*              col: the column number                               						*/
/*              name: the name of the dropdown list                  						*/
/*              fnc: javascript function used to refresh buttons etc.						*/
/*              dvalue: the value displayed in the dropdown list     						*/
/*              svalue: the value selected when dvalue is selected in the dropdown list     */
/*              selected: the value of the dropdown to be selected   						*/
/********************************************************************************************/
function insWidgetDropDownList(tableid,row,col,name,fnc,dvalues,svalues,selected)
{
   var len = arguments.length;
   var cont = "<SELECT ";
   if( len>3 && name != null ){
       if( len>4 && fnc != null ){
           cont += " NAME=\"" + name + "\" onChange=\"" + fnc + "\" >";
       }else{
           cont += " NAME=\"" + name + "\" >";
       }
   }	
   if( len>5 && dvalues != null && dvalues.length > 0 && svalues != null && svalues.length > 0)
	{
      	for (var i=0 ; i< svalues.length ; i++)
		{
			if(selected == svalues[i])
			{
		           cont +="<OPTION value=\"" + svalues[i] + "\" selected>" +dvalues[i]+ "</OPTION>";
			}
			else
			{
		           cont +="<OPTION value=\"" + svalues[i] + "\" >" +dvalues[i]+ "</OPTION>";
			}
		}
	}
   else
	{
		cont +="<OPTION value=''></OPTION>";
    }

   cont +="</SELECT>";
   insCell(tableid,row,col,cont);
}


/*********************************************************************/
/*              name: the name of the dropdown                       */
/*              fnc: javascript function used to refresh buttons etc.*/
/*              values: the value of the dropdown                    */
/*              selected: the value of the dropdown to be selected   */
/*********************************************************************/
drop_down_list_style="list_select";
function addDlistDropDown(name,fnc,values,selected)
{
   var len = arguments.length;

   if (hindex >= headings.length) hindex=0;

   document.writeln("<TD headers='" + headings[hindex++] + "' CLASS=\""+drop_down_list_style+"\">");
   if( len>0 && name != null ){
       if( len>1 && fnc != null && !testNone(fnc.toLowerCase()) ){
           document.write("<SELECT NAME=\""+name+"\" onChange=\""+fnc+"\" >");
       }else{
           document.write("<SELECT NAME=\""+name+"\" >");
       }

       if(len>2 && values != null && values.length > 0){
      	for (var i=0 ; i< values.length ; i++)
		{
			if(selected == values[i])
			{
		           document.write("<OPTION value=\"" + values[i] + "\" selected>" +values[i]+ "</OPTION>");
			}
			else
			{
		           document.write("<OPTION value=\"" + values[i] + "\" >" +values[i]+ "</OPTION>");
			}
		}
	}
       else
     	 {
		document.write("<OPTION value=''></OPTION>");
     	 }
	 document.write("</SELECT>");	
   }
   document.write("</TD>");
}


/********************************************************************************************/
/*              name: the name of the dropdown list                      					*/
/*              fnc: javascript function used to refresh buttons etc.						*/
/*              dvalues: the value displayed in the dropdown list                  			*/
/*              svalues: the value selected when dvalue is selected in the dropdown list   	*/
/*              selected: the value of the dropdown to be selected   						*/
/********************************************************************************************/
function addDlistWidgetDropDown(name,fnc,dvalues,svalues,selected)
{
   var len = arguments.length;

   if (hindex >= headings.length) hindex=0;

   document.writeln("<TD headers='" + headings[hindex++] + "' CLASS=\""+drop_down_list_style+"\">");
   if( len>0 && name != null ){
       if( len>1 && fnc != null && !testNone(fnc.toLowerCase()) ){
           document.write("<SELECT NAME=\""+name+"\" onChange=\""+fnc+"\" >");
       }else{
           document.write("<SELECT NAME=\""+name+"\" >");
       }

       if(len>2 && dvalues != null && dvalues.length > 0 && svalues != null && svalues.length > 0 ){
      	for (var i=0 ; i< svalues.length ; i++)
		{
			if(selected == svalues[i])
			{
		           document.write("<OPTION value=\"" + svalues[i] + "\" selected>" +dvalues[i]+ "</OPTION>");
			}
			else
			{
		           document.write("<OPTION value=\"" + svalues[i] + "\" >" +dvalues[i]+ "</OPTION>");
			}
		}
	}
       else
     	 {
		document.write("<OPTION value=''></OPTION>");
     	 }
	 document.write("</SELECT>");	
   }
   document.write("</TD>");
}
/****************************************************************************
 * Remove the object from the vector
 *
 * element - The element to remove
 *
 * Returns TRUE if successfull; FALSE otherwise
 * owner - The owner of this object, pass the object from the calling func
 ***************************************************************************/
function paRemoveElement(element, owner)
{
  if ( owner == null )
  {
      var buffer = new Array();
  
      for(var i=0; i<this.container.length; i++)
      {
        if(this.container[i] == element)
          continue;
        
        buffer[buffer.length] = this.container[i];
      }
  
      if (this.container.length == buffer.length) return(false);
      
      this.container = buffer;
      return(true);
    
  } // end of owner= null
  else
  { //owner != null
      var buffer = new Array();
  
      for(var i=0; i<owner.container.length; i++)
      {
        if(owner.container[i] == element)
          continue;
        
        buffer[buffer.length] = owner.container[i];
      }  

      if (owner.container.length == buffer.length) return(false);

      owner.container = buffer;
      return(true);    

  } // end of owner is not null
}// END paRemoveElement



function compareStrings(a,b){
	var a1 = parseInt(a);
	var b1 = parseInt(b);
	if(a1<b1) return -1;
	if(a1>b1) return 1;
	return 0;
}


function myRefreshButtons(){
	var checked = parent.getChecked();
	
	if(checked.length == 1)
	{	
		var index = checked[0];
		if(index==0) {
			if(defined(parent.buttons.buttonForm.moveUpButton)){
				disableButton(parent.buttons.buttonForm.moveUpButton);
			}
		}
		var remVec = new Vector();
		remVec = top.get("vectorDataRemove");
		if(index==(size(remVec)-1)) {
			if(defined(parent.buttons.buttonForm.moveDownButton)){
				disableButton(parent.buttons.buttonForm.moveDownButton);
			}
		}
	}
}


// code for disbling the button
function disableButton(b) {
	if (defined(b)) {
		b.disabled=false;
		b.className='disabled';
		b.id='disabled';
	}
}
// code for checking weather the button is disabled
function isButtonDisabled(b) {
	if (b.className =='disabled' && b.id == 'disabled')
		return true;
	return false;
}
//function to sort a vector
function sortVector(object){
	var vs = size(object);
	var array = new Array();
	for(var i=0;i<vs;i++){
		var obj = elementAt(i,object);
		array[i] = obj.displayColumnName;
	}
	array.sort();
	var tempVector = new Vector();
	for(var i=0 ; i<array.length ;i++){
		for(var j=0;j<vs;j++){
			var obj = elementAt(j,object);
			if(array[i] == obj.displayColumnName){
				addElement(obj,tempVector);
				break;
			}
		}
	}
	return tempVector;
}

//trimming function
//trim the left of the string
function ltrim(s){
	return s.replace(/^\s*/,"");
}

//trim the right of the function
function rtrim(s){
	return s.replace(/\s*$/,"");
}
