/********************************************************************
*-------------------------------------------------------------------
* Licensed Materials - Property of IBM
*
* WebSphere Commerce
*
* (c) Copyright IBM Corp. 2000, 2004
*
* US Government Users Restricted Rights - Use, duplication or
* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
*
*-------------------------------------------------------------------*/

/**********************************************************************/
/*              Util function for NewDynamicList                      */
/**********************************************************************/
function checkAndSetNavButton(){
   if(defined(scrollcontrol)){
       if(document.all){
          /* display the previous button */
          scrollcontrol.document.all("control_panel_prev_but1").style.display="";
          scrollcontrol.document.all("control_panel_prev_but2").style.display="";
          scrollcontrol.document.all("control_panel_prev_but3").style.display="";
          /* display the next button */
          scrollcontrol.document.all("control_panel_next_but1").style.display="";
          scrollcontrol.document.all("control_panel_next_but2").style.display="";
          scrollcontrol.document.all("control_panel_next_but3").style.display="";
          if(page==1)/* at the first page */
          {
             /* hide the previous button */
             scrollcontrol.document.all("control_panel_prev_but1").style.display="none";
             scrollcontrol.document.all("control_panel_prev_but2").style.display="none";
             scrollcontrol.document.all("control_panel_prev_but3").style.display="none";
          }
          if(page==t_page)/* at the last page */
          {
             /* hide the next button */
             scrollcontrol.document.all("control_panel_next_but1").style.display="none";
             scrollcontrol.document.all("control_panel_next_but2").style.display="none";
             scrollcontrol.document.all("control_panel_next_but3").style.display="none";
          }
       }
   }
}

function setNLSTitle(name) {
  if(defined(this.scrollcontrol)){
     if(scrollcontrol.document.all && scrollcontrol.document.readyState=="complete"){
        scrollcontrol.document.all("scroll_title").innerHTML=name;
     }
  }
}

/* Sort function */
function doSort(fieldname) {
    page=1;
    top.showProgressIndicator(true);
    if(this.scrollcontrol && scrollcontrol.document.all.gotopage) {
        scrollcontrol.document.all.gotopage.value=page;
    }
    document.generalForm.startindex.value=0;
    document.generalForm.orderby.value=fieldname;
    document.generalForm.submit();
}

var option_name='';
var option_index=0;
/**********************************************************************/
/*          External API: set option                                  */
/**********************************************************************/
function setoption(v){
   option_index=v;
}
function set_opt(){
   var op = scrollcontrol.document.ControlPanelForm.viewname.options;
   op.selectedIndex=option_index;
}

// deprecated, no longer in use
function checkAndSetOpt(){
}

var checkeds = new Vector;
/**********************************************************************/
/*          External API: get checked items, return an array          */
/**********************************************************************/
function getChecked() {
    return checkeds.container;
}
/**********************************************************************/
/*          External API: get checked value, return a concated string */
/**********************************************************************/
function getSelected() {
    return getChecked().join(',');
}
/**********************************************************************/
/*          External API: remove entry from container                 */
/**********************************************************************/
function removeEntry(entry){
      checkeds.removeElement(entry);
}

/**********************************************************************/
/*          External API: add item into container                     */
/**********************************************************************/
function insertEntry(item){
      checkeds.addElement(item);
}

/**********************************************************************/
/*              Frame load function                                   */
/**********************************************************************/
var frameLoaded;
function setBaseFrameLoaded(state) {
   frameLoaded = state;
}
function isBaseFrameLoaded() {
   return frameLoaded;
}
function stopLoad(){
   //if(defined(parent.setContentFrameLoaded)){
   //   parent.setContentFrameLoaded(true);
   //}
   top.showProgressIndicator(false);
}

/**********************************************************************/
/*                         Navigation                                 */
/**********************************************************************/
var t_page = 1;
/**********************************************************************/
/*          External API: set total page                              */
/**********************************************************************/
function set_t_page(t){
    t_page = t;
}
function setTotalPage(tp){
    if(scrollcontrol.document.all){
       scrollcontrol.document.all("totalpage").innerHTML=tp;
    }
}
var t_item = 0;
/**********************************************************************/
/*          External API: set total item                              */
/**********************************************************************/
function set_t_item(t){
    t_item = t;
}
function setTotalItem (tt, numofitem_text) {
	if (scrollcontrol.document.all) {
		scrollcontrol.document.all("numofitem").innerHTML = numofitem_text.replace(/%1/, "<b class=\"scroll\">" + tt + "</b>");
	}
}
function setNumPage(np){
    if(scrollcontrol.document.all){
       scrollcontrol.document.all("numofpage").innerHTML=np;
    }
}
/**********************************************************************/
/*          External API: set total page and total item               */
/**********************************************************************/
function set_t_item_page(t,lsize){
    t_item = t;
    var p = t%lsize;
    t_page = (t_item==0)?1:((p>0)?((t-p)/lsize+1):(t/lsize));
}
var startindex=0;
var pagesize=5;
var page=1;

function navigate(pageno, indexno) {
    top.showProgressIndicator(true);

    // update URL in bread crumb trail
    if (top.mccbanner) {
        var item = top.mccbanner.trail[top.mccbanner.counter];
        if (item.parameters == null) {
            var index = item.location.indexOf("pagenumber=");
            if ( index < 0) { 
                // no "pagenumber" parameter defined before, simply add one
                item.location += "&pagenumber=" + pageno;
            } else {
                // "pagenumber" parameter is in the URL (ie. location) already, need to replace the old value with new one
        		var firstPart = item.location.substring(0, index + 11); // "pagenumber=".length() == 11
                var lastPart = item.location.substring(index);
		        var lastIndex = lastPart.indexOf("&");	
		        if(lastIndex > 0) {
		            lastPart = lastPart.substring(lastIndex); // there are more parameter(s)
		        } else {
		            lastPart = "";					    // nothing left
		        }
		        item.location = firstPart + pageno + lastPart; // the starting page replaced
            }
        } else {
            item.parameters.pagenumber = pageno;
        }
    }
    
    scrollcontrol.document.all.gotopage.value=pageno;
    document.generalForm.startindex.value=indexno;

	if(defined(scrollcontrol)){ 
		if(defined(basefrm) && basefrm.location != null){
			var optAction = basefrm.location.toString();
			var viewIndex = optAction.indexOf("view=");
			if(viewIndex != '-1'){
				 var viewName = optAction.substring(viewIndex+5);
				 document.generalForm.action = substituteParam(document.generalForm.action,"view",viewName);
			}
		}
	}
	
    document.generalForm.submit();
}

function gotoleft(){
    var tmp = (page-1)*pagesize;
    tmp -= pagesize;
    if(tmp < 0){
       page=1;
       return;
    }else{
       page--;
       navigate(page, tmp);
    }
}
var resultssize=0;
function gotoright(){
    var tmp = (page-1)*pagesize;
    tmp += pagesize;
    if(tmp >= resultssize){
	 return;
    }else{
       page++;
       navigate(page, tmp);
    }
}
function gotofirst(){
    page=1;
    navigate(page, 0);
}
function gotolast(){
    var x=resultssize%pagesize;
    var tmp=0;
    if(resultssize>0)
    {
       if(x==0){
          tmp=resultssize-pagesize;
       }else{
	    tmp=resultssize-x;
       }
    }
    page=tmp/pagesize+1;
    navigate(page, tmp);
}
/**********************************************************************/
/*          External API: set whole list size                         */
/**********************************************************************/
function setResultssize(size){
    resultssize=size;
}
function getPage(){
    return page;
}
function isValidNumberField(UserNumber) {
    var validChars = "0123456789";
    // if the string is empty it is not a valid integer
    if (!UserNumber.match(/[^\\s]/)) return false;
        // look for non numeric characters in the input string\n");
	  for (var i=0; i<UserNumber.length; i++) {
	       if (validChars.indexOf(UserNumber.substring(i, i+1)) == "-1") {
                 return false;
        }
    }
    // look for bad leading zeroes in the input string
    if (UserNumber.length > 1 && UserNumber.substring(0,1) == "0") {
        return false;
    }
    return true;
}
function gotopage(){
    var tmp1 = scrollcontrol.document.all.gotopage.value;
    if( !isValidNumberField(tmp1) ){
        scrollcontrol.document.all.gotopage.value=page;
        return;
    }
    var tmp = pagesize*(tmp1-1);
    if( (tmp < 0) || (tmp >= resultssize) ){
         scrollcontrol.document.all.gotopage.value=page;
         return;
    }else{
         page=tmp1;
         navigate(page, tmp);
    }
}

function removeListParameter(param) {
    // remove input element in the generalForm
    if (document.generalForm) {
        var elements = document.generalForm.getElementsByTagName("INPUT");
        for (i = 0; i < elements.length; i++) {
            if (elements[i].name && elements[i].name == param) {
                elements[i].removeNode(true);
                break;
            }
        }
    }
    
    // update URL in bread crumb trail
    if (top.mccbanner) {
        var item = top.mccbanner.trail[top.mccbanner.counter];
        if (item.parameters == null) {
            var index = item.location.indexOf(param + "=");
            if ( index < 0) { 
                // no specified parameter defined before
                return;
            } else {
                // parameter is in the URL (ie. location) already, will delete
        		var firstPart = item.location.substring(0, index);
                var lastPart = item.location.substring(index);
		        var lastIndex = lastPart.indexOf("&");	
		        if(lastIndex > 0) {
		            lastPart = lastPart.substring(lastIndex); // there are more parameter(s)
		        } else {
		            lastPart = "";					    // nothing left
		        }
		        item.location = firstPart + lastPart;
            }
        } else if (item.parameters[param]) {
            delete item.parameters[param];
        }
    }
}

/**********************************************************************/
/*                         Button function                            */
/**********************************************************************/

/**********************************************************************/
/*          External API: display button                              */
/**********************************************************************/
function displayButton(name){
    var localName = name + "Button";
    var n = localName + "_tr";
    if (Buttons[localName] != null) 
        Buttons[localName].display=true;
    if( button_frame_loaded &&(document.all)&&(buttons)&&(buttons.document.all(n)) ){
              //alert(n);
              buttons.document.all(n).style.display="";
    }
}
/**********************************************************************/
/*          External API: hide button                                 */
/**********************************************************************/
function hideButton(name){
    var localName = name + "Button";
    var n = localName + "_tr";
    if (Buttons[localName] != null) 
        Buttons[localName].display=false;
    if( button_frame_loaded &&(document.all)&&(buttons)&&(buttons.document.all(n)) ){
        //alert(n);
        buttons.document.all(n).style.display="none";
    }
}
function showControlPanel2(n){
    if( (document.all)&&(scrollcontrol)&&(scrollcontrol.document.all(n)) ){
         //alert(n);
         scrollcontrol.document.all(n).style.display="";
    }
}
/**********************************************************************/
/*          External API: show Control Panel                          */
/**********************************************************************/
function showControlPanel(){
    showControlPanel2("control_panel_field");
    showControlPanel2("control_panel_numofitem");
    showControlPanel2("control_panel_navigate");
}
function hideControlPanel2(n){
    if( (document.all)&&(scrollcontrol)&&(scrollcontrol.document.all(n)) ){
        //alert(n);
        scrollcontrol.document.all(n).style.display="none";
    }
}
/**********************************************************************/
/*          External API: hide Control Panel                          */
/**********************************************************************/
function hideControlPanel(){
    hideControlPanel2("control_panel_field");
    hideControlPanel2("control_panel_numofitem");
    hideControlPanel2("control_panel_navigate");
}

var button_x='0px';
var button_y='0px';
/**********************************************************************/
/*          External API: set the button position                     */
/**********************************************************************/
function setButtonPos(x,y){
    button_x=x;
    button_y=y;
}
function set_button_pos(){
    var ele = document.all?buttons.document.all.button_table:null;
    if(document.all && ele!=null){
       ele.style.position='relative';
       ele.style.top=button_y;
       ele.style.left=button_x;
    }
}
/**********************************************************************/
/*          External API: set the instructionion                      */
/**********************************************************************/
var instruction_text='';
function setInstruction(text){
    instruction_text=text;
}
function getInstruction(){
    return instruction_text;
}

/**********************************************************************/
/*              self-refresh function for Button                      */
/**********************************************************************/
function selfRefresh(but){
   //alert(but.className);
   var sty = but.className;
   but.className = sty;
}

/**********************************************************************/
/*              Private: set view selection in BCT                    */
/**********************************************************************/
function setViewSelection(sel) {
    if (top.mccbanner) {
        var item = top.mccbanner.trail[top.mccbanner.counter];
        if (item != null) {
 	       item.viewSelection = sel;
        }
    }
}

/**********************************************************************/
/*              Private: get view selection from BCT                  */
/**********************************************************************/
function getViewSelection() {
    if (top.mccbanner) {
        var item = top.mccbanner.trail[top.mccbanner.counter];
        if (item != null && item.viewSelection != null) {
 	    	ret = Number(item.viewSelection);
 	    	if (isNaN(ret)) {
 	    		return 0;
 	    	} else {
 	    		return ret;
 	    	}
        } else {
        	return 0;
        }
    }
}

function substituteParam(theURL, paramName, paramValue){
	// create regular expression (need to find out what is valid URL)
	re = new RegExp(("(.+)(" + paramName + "=)(.+)(&?.*)"));
	pos = theURL.search(re);
	
	if (pos == -1){
		// the paramName does not exist, so add
		return (theURL + "&" + paramName + "=" + paramValue);
	} else {
		// the paramName does exist, so replace
		return (theURL.replace(re, ("$1$2" + paramValue + "$4")));
	}
}
