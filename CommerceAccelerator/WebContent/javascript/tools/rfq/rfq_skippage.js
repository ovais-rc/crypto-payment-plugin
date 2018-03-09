//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2000, 2002, 2003
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
//*

function skipPages(pageArray) 
{
    var skipPagesArray = new Array();
    skipPagesArray = top.getData("skipPages");

    if ((skipPagesArray != undefined ) && (skipPagesArray.length > 0)) 
    {
	// Modify pageArray to skip pages.	
	for (var i=0; i < skipPagesArray.length; i++) 
	{
	    var skipPageName = skipPagesArray[i];
   	    if (pageArray[skipPageName] != null) 
	    {
		var prevPage = pageArray[skipPageName].prev;
		var nextPage = pageArray[skipPageName].next;
   	 	if (prevPage != null) 
		{
		    pageArray[prevPage].next = nextPage;
  	        }
   	   	if (nextPage != null) 
		{
		    pageArray[nextPage].prev = prevPage;
  	        }
  	    }
	}
    }
}



