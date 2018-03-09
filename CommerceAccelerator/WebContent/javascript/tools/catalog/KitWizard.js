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

//////////////////////////////////////////////////////////////////////////////////////
// string2Array()
//
// @param string 	- input string
// @param delimiter 	- the delimiter
//
// - this function divide a string into an Array
//
//////////////////////////////////////////////////////////////////////////////////////
function string2Array (string, delimiter)
{
	var end;
	var i = 0;
	var start = 0;
	var result = new Array ();

	len = string.length;
	while (i < len)
	{
		end = string.indexOf (delimiter, start);
		if (end == -1)
		{
			result[i++] = string.substring (start, len);
			return result;
		}
		result[i++] = string.substring (start, end);
		start = end+1;
	} 
	return result;
}


	//////////////////////////////////////////////////////////////////////////////////////
	// replaceField(source, pattern, replacement) 
	//
	// - replace values in the property file string
	//////////////////////////////////////////////////////////////////////////////////////
	function replaceField(source, pattern, replacement) 
	{
		index1 = source.indexOf(pattern);
		index2 = index1 + pattern.length;
		return source.substring(0, index1) + replacement + source.substring(index2);
	}
	
	