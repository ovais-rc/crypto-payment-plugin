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

// Remove all check marks from all pages.  This function would normally
// be executed before invoking a command.
function deSelectAll() 
{
   var temp;
   checked = new String(parent.getChecked());
   temp = checked.split(",");
   for (var j = 0; j < temp.length; j++)
   {
     parent.removeEntry(temp[j]);
   }
}