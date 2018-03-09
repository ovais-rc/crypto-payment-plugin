/********************************************************************
*-------------------------------------------------------------------
* Licensed Materials - Property of IBM
*
* WebSphere Commerce
*
* (c) Copyright IBM Corp. 2000, 2002
*
* US Government Users Restricted Rights - Use, duplication or
* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
*
*-------------------------------------------------------------------*/


/**
 * Returns all set properties in an XML format.
 */
function generateXML(object, name, depth)
{
  if (depth == null) depth = 0;
  var xml = "";

  // if object is a primitive, return its XML representation
  if ( object == null )
  {
    return spacing(depth) + "<" + name + ">" + "" + "</" + name + ">\n";
  }

  if ( typeof object == "number"  || typeof object == "boolean" ) {
     return spacing(depth) + "<" + name + ">" + object  + "</" + name + ">\n";
  }
  if ( typeof object == "string" ) {
     return spacing(depth) + "<" + name + ">" + replaceSpecialChars(object) + "</" + name + ">\n";
  }

  // Get the string representation of the constructor
  var undefined
  if ( object === undefined)
  {
    return spacing(depth) + "<" + name + ">" + "" + "</" + name + ">\n";
  }

  if ( isVector(object) ) {
     // object.size() will not work properlyin IE, to make it work on both
     // IE and Netscape, do the following instead:  size(object)
     for ( var i = 0; i < size(object); i++ ) {
         xml += spacing(depth) + generateXML(elementAt(i,object), name, depth+1);
     }
  } else if ( isHashtable(object) ) {
     xml += spacing(depth) + "<" + name + ">\n";
     for ( attribute in object.data ) {
         xml += spacing(depth) + generateXML(object.data[attribute], attribute, depth+1);
     }
     xml += spacing(depth) + "</" + name + ">\n";
  } else if ( object.length == 0) {
    return spacing(depth) + "<" + name + ">" + "" + "</" + name + ">\n";
  } else if ( isArray(object) ) {
     for ( var i = 0; i < object.length; i++ ) {
         xml += spacing(depth) + generateXML(object[i], name, depth+1);
     }
  } else {
     xml += spacing(depth) + "<" + name + ">\n";
     for ( attribute in object ) {
         xml += spacing(depth) + generateXML(object[attribute], attribute, depth+1);
     }
     xml += spacing(depth) + "</" + name + ">\n";
  }
  return xml;
}


/**
 * Converts any javaScript object into an XML format.
 */
function convertToXML(object, rootName, encoding)
{
  if (encoding == null || encoding == "") encoding = "UTF-8";

  var xml = '<?xml version="1.0" encoding="' + encoding + '"?>\n';

  if ( isVector(object) ) {
     if ( rootName != null )  xml += "<" + rootName + ">\n";
     if ( object.getRootName() == null) {
        xml += generateXML( object.elements(), "item" );
     } else {
        xml += generateXML( object.elements(), object.getRootName() );
     }
     if ( rootName != null )  xml += "</" + rootName + ">\n";
  }
  else if (isHashtable(object)) {
     if ( rootName != null )  xml += "<" + rootName + ">\n";
     for(element in object) {
        xml += generateXML( object[element], element );
     }
     if ( rootName != null )  xml += "</" + rootName + ">\n";
  }
  else if (isArray(object)) {
     if (rootName == "") rootName = "rootName";
     for(element in object) {
        xml += generateXML( object[element], rootName );
     }
  } else {
     if ( rootName == null ) rootName = "rootName";
     xml += generateXML( object, rootName )
  }

  return xml;
}

function convertToInlineXML(object, rootName)
{
  var xml = '';

  if ( isVector(object) ) {
     if ( rootName != null )  xml += "<" + rootName + ">\n";
     if ( object.getRootName() == null) {
        xml += generateXML( object.elements(), "item" );
     } else {
        xml += generateXML( object.elements(), object.getRootName() );
     }
     if ( rootName != null )  xml += "</" + rootName + ">\n";
  }
  else if (isHashtable(object)) {
     if ( rootName != null )  xml += "<" + rootName + ">\n";
     for(element in object) {
        xml += generateXML( object[element], element );
     }
     if ( rootName != null )  xml += "</" + rootName + ">\n";
  }
  else if (isArray(object)) {
     if (rootName == "") rootName = "rootName";
     for(element in object) {
        xml += generateXML( object[element], rootName );
     }
  } else {
     if ( rootName == null ) rootName = "rootName";
     xml += generateXML( object, rootName )
  }

  return xml;
}

function spacing(depth)
{
  var spacer = "";
  for ( var i=0; i < depth; i++ ) {
     spacer += " ";
  }
  return spacer;
}

function isVector(obj)
{
  if (obj.type == "Vector") return true;
  else return false;
}

function isHashtable(obj)
{
  if (obj.type == "Hashtable") return true;
  else return false;
}

function isArray(obj)
{
  var undefined
  if ( obj === undefined || obj.length === undefined)
  {
    return false;
  }

  return true;
}

function replaceSpecialChars(obj)
{
   var result = new String(obj);

   result = result.replace(/&/g, "&amp;");
   result = result.replace(/</g, "&lt;");
   result = result.replace(/>/g, "&gt;");
   result = result.replace(/'/g, "&#39;");
   result = result.replace(/"/g, "&quot;");
  
   return result;
}

// converting xml string using attributes like <a b=".."> format
// instead of <a> <b>..</b> </a>
function generate2XML(object, name, depth, xsdRootName, xsdFileName)
{
  if (depth == null) depth = 0;
  if (name == null) return "";
  var xml = "";

  // if object is a primitive, return its XML representation
  if ( object == null )
  {
    return spacing(depth) + "<" + name + ">" + "" + "</" + name + ">\n";
  }

  if ( typeof object == "number"  || typeof object == "boolean" ) {
     return spacing(depth) + "<" + name + ">" + object  + "</" + name + ">\n";
  }
  if ( typeof object == "string" ) {
     return spacing(depth) + "<" + name + ">" + replaceSpecialChars(object) + "</" + name + ">\n";
  }

  // Get the string representation of the constructor
  var undefined
  if ( object === undefined)
  {
    return spacing(depth) + "<" + name + ">" + "" + "</" + name + ">\n";
  }

  if ( isVector(object) ) {
     // object.size() will not work properlyin IE, to make it work on both
     // IE and Netscape, do the following instead:  size(object)
     for ( var i = 0; i < size(object); i++ ) {
         xml += generate2XML(elementAt(i,object), name, depth+1);
     }
  } else if ( isHashtable(object) ) {
     xml += spacing(depth) + "<" + name + ">";
     for ( attribute in object.data ) {
         xml += generate2XML(object.data[attribute], attribute, depth+1);
     }
     xml += "</" + name + ">\n";
  } else if ( object.length == 0) {
    return spacing(depth) + "<" + name + ">" + "" + "</" + name + ">\n";
  } else if ( isArray(object) ) {
     for ( var i = 0; i < object.length; i++ ) {
         xml += generate2XML(object[i], name, depth+1);
     }
  } else {
     var tmp_storage = new Object();
     //xml += spacing(depth) + "<" + name;
     xml += "<" + name;

     if ( name == xsdRootName && xsdFileName != "" )
     {
	xml += " xmlns=\"http://www.ibm.com/WebSphereCommerce\" \n";
	xml += "xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" \n";
  	xml += "xsi:schemaLocation=\"http://www.ibm.com/WebSphereCommerce ";
  	xml += xsdFileName;
  	xml += "\" \n";
     }

     for ( attribute in object ) {
         if( object[attribute] == null ){
             xml += " " + attribute + "=\"\" ";
         }
         else if( object[attribute] === undefined ){
                  //skip
         }
         else if( typeof object[attribute] == "number"  || typeof object[attribute] == "boolean" ){
                  xml +=  " " + attribute + "=\"" + object[attribute] + "\" ";
         }
         else if( typeof object[attribute]  == "string" ) {
                  xml +=  " " + attribute + "=\"" + replaceSpecialChars(object[attribute]) + "\" ";
         }
         else if( isVector(object[attribute]) || isHashtable(object[attribute]) ){
                  tmp_storage.attribute = object[attribute];
         }else{
                  var name1 = attribute;
                  tmp_storage[""+name1+""] = object[attribute];
         }
     }
     xml += ">";
     for ( attribute in tmp_storage) {
           xml += generate2XML(tmp_storage[attribute], attribute, depth+1);
     }
     tmp_storage = null;
     xml += "</" + name + ">\n";
  }
  return xml;
}


function convert2XML(obj, rootName, dtdname, xsdRootName, xsdFileName, encoding)
{
  if (encoding == null || encoding == "") encoding = "UTF-8";

  var xml = '<?xml version="1.0" encoding="' + encoding + '"?>\n';
  
  var undefined;
  
  if ( obj == null) {
  	//skip
  }
  else if( obj === undefined ){
        //skip
  }
  else if ( isVector(obj) ) {
     //if ( rootName != null )  xml += "<" + rootName + ">";
     if ( obj.getRootName() == null) {
        xml += generate2XML( obj.elements(), "item" );
     } else {
        xml += generate2XML( obj.elements(), obj.getRootName() );
     }
     //if ( rootName != null )  xml += "</" + rootName + ">\n";
  }
  else if (isHashtable(obj)) {
     //if ( rootName != null )  xml += "<" + rootName + ">";
     for(element in obj) {
        xml += generate2XML( obj[element], element );
     }
     //if ( rootName != null )  xml += "</" + rootName + ">\n";
  }
  else {

     for(attribute in obj){
         rootName = attribute;
     }

     if ( rootName == null ) rootName = "XML";
     
     if (dtdname) {
     	xml += '<!DOCTYPE '+ rootName +' SYSTEM "'+ dtdname + '">\n';
     }

     for(attribute in obj){
         xml += generate2XML( obj[attribute], attribute, null, xsdRootName, xsdFileName );
     }
     //xml += generate2XML(obj,rootName);
  }
  //alert(xml);
  return xml;
}

