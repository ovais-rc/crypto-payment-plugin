//********************************************************************
//*-------------------------------------------------------------------
//*Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright International Business Machines Corporation. 2002
//*     All rights reserved.
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*--------------------------------------------------------------------

// @deprecated The Product Advisor feature has been deprecated. For more information, see <a href="../../../../../../com.ibm.commerce.productadvisor.doc/concepts/cpaintro.htm">Product Advisor</a>.

//returns the concept type
function getConceptValue(parameter){
	var param = parameter.split('&');
	var plength = param.length;
	for(var i=0;i<plength;i++){
		var tparam = param[i];
		var key = tparam.split('=');
		var tkey = key[0];
		if(tkey == 'conceptType'){
			var value = key[1];
			var type = value.split('.');
			return type[type.length-1];
		}
	}
}

//function to check if the nodeParameter is a Question
function isQuestion(parameter){
	if(parameter != null && parameter != ''){
		var param = getConceptValue(parameter);
		return (param == 'Question');
	} else {
		return false;
	}
}

//function to check if the nodeParameter is an Answer
function isAnswer(parameter){
	if(parameter != null && parameter != ''){
		var param = getConceptValue(parameter);
		return (param == 'Answer');
	} else {
		return false;
	}
}

//function to check if the nodeParameter is linked
function isLinked(parameter){
	if(parameter != null && parameter != ''){
		var param = parameter.split('&');
		var plength = param.length;
		for(var i=0;i<plength;i++){
			var tparam = param[i];
			var key = tparam.split('=');
			var tkey = key[0];
			if(tkey == 'isLinked'){
				var value = key[1];
				return value == 'true';
			}
		}
	} else {
		return false;
	}
}

//checks if the selected node is a link
function isLink(parameter){
	if(parameter != null && parameter != ''){
		var param = parameter.split('&');
		var plength = param.length;
		for(var i=0;i<plength;i++){
			var tparam = param[i];
			var key = tparam.split('=');
			var tkey = key[0];
			if(tkey == 'isLink'){
				var value = key[1];
				return value == 'true';
			}
		}
	} else {
		return false;
	}	
}

//function that returns the parameter of the node seletced
function getNodeParameter(){
	var nodeParameter = '';
      if ( gsframe.getHighlightedNode != null )  {
          var x = gsframe.getHighlightedNode();
          if (( x != null ) && (x.style != null)){
              var node = eval ( "gsframe." + x.style.node );
              var path  = gsframe.getValuePath( node );
		  var param = path.split('/');
		  nodeParameter = param[param.length-1];	
          }
      }
	return nodeParameter;
}


//displays the progress indicator while displaying the path
var progressChecks = 0;
var maxChecks      = 10000;
var targetPath     = null;
var minDelay = 100;

function checkProgress () {
	var x = null;
	var y = null;
	var path = null;
	if ( progressChecks <= maxChecks - 1 ) {  
		if ( gsframe.getHighlightedNode != null )  {
			x = gsframe.getHighlightedNode();
			if (x.style != null) {
				y = eval("gsframe." + x.style.node);
				path  = gsframe.getValuePath( y );
		      }
		}

		if ( path != targetPath ) {
			top.showProgressIndicator ( true );        
			checkTimer = setTimeout("checkProgress()", minDelay);
			progressChecks += 1;
		} else  {
      		top.showProgressIndicator ( false );
		}
	} else {
		top.showProgressIndicator ( false );
	}
}

//displays the selected path
function displayPath() {
	var removed = top.get("fromRemove",null);
	if(removed == "true"){
		if(this.unloadForm){
			unloadForm();
		}
		top.remove("fromRemove");
		return;	
	}
	var select_path = top.get("pathId",null);
	if ( select_path != null ) {
		targetPath = select_path;
		top.showProgressIndicator ( true );   
		checkTimer = setTimeout("checkProgress()", minDelay);
		gsframe.gotoAndHighlightByValue(select_path);
	}
}

//function that returns the parent path
function getParentPath( path ) {
	var sep = "/";
      var pos1 = 0;
      var init_pos = 0;
      var parent_path = null;

      pos1 = path.lastIndexOf ( sep );
      if ( pos1 != -1 ) {
      	parent_path = path.substring( 0, pos1  );
      }
      return parent_path;
}

//function for saving the highlighted path
function saveHighLightedPath(){
	var x = null;
	var path = null;
      var node = null;
      var parent = false;

      if (arguments.length > 0) {
	     parent = arguments[0];
      }


      if ( gsframe.getHighlightedNode != null )  {
      	x = gsframe.getHighlightedNode();
            if (( x != null ) && (x.style != null)){
            	node = eval ( "gsframe." + x.style.node );
                  path  = gsframe.getValuePath( node );
                  if ( path != null ) {
                  	if ( parent != null ) {
                        	if ( parent == true ) {
                              	path = getParentPath ( path );
                            	}
                        }
                        top.put("pathId", path );
                  }
            }
	} 
}

/**********************************************************************************
 *	The following functions are for the new imlementation of the DynamicTree.jsp
 **********************************************************************************/

//function that returns the parameter of the node seletced
function getNodeParameterNew(){
	var nodeParameter = '';
      if ( gsframe.getHighlightedNode != null )  {
          var node = gsframe.getHighlightedNode();
          if (node != null){
              var path  = gsframe.getValuePath( node );
			  var param = path.split('/');
			  nodeParameter = param[param.length-1];	
          }
      }
	return nodeParameter;
}

//function for saving the highlighted path
function saveHighLightedPathNew(){
	var path = null;
    var node = null;
    var parent = false;

    if (arguments.length > 0) {
     parent = arguments[0];
    }


    if( gsframe.getHighlightedNode != null )  {
      	node = gsframe.getHighlightedNode();
        if (node != null ){
			path  = gsframe.getValuePath( node );
            if(path != null ) {
                if ( parent != null ) {
					if ( parent == true ) {
                		path = getParentPath ( path );
                	}
				}
                top.put("pathId", path );
			}
		}
	} 
}

//check for progress
function checkProgressNew() {
	var x = null;
	var path = null;
	if ( progressChecks <= maxChecks - 1 ) {  
		if ( gsframe.getHighlightedNode != null )  {
			x = gsframe.getHighlightedNode();
			if (x != null) {
				path  = gsframe.getValuePath(x);
            }
		}

		if ( path != targetPath ) {
			top.showProgressIndicator(true);        
			checkTimer = setTimeout("checkProgressNew()", minDelay);
			progressChecks += 1;
		} else  {
      		top.showProgressIndicator ( false );
		}
	} else {
		top.showProgressIndicator ( false );
	}
}

//displays the selected path
function displayPathNew() {
	var removed = top.get("fromRemove",null);
	if(removed == "true"){
		if(this.unloadForm){
			unloadForm();
		}
		top.remove("fromRemove");
		return;	
	}
	var select_path = top.get("pathId",null);
	if ( select_path != null ) {
		targetPath = select_path;
		top.showProgressIndicator ( true );   
		checkTimer = setTimeout("checkProgressNew()", minDelay);
		gsframe.gotoAndHighlightByValue(select_path);
	}
}