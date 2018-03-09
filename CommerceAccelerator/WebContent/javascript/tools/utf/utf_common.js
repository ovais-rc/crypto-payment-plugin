//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2001, 2002
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
//*
function UTFConvertFromHTMLToText(obj)
{
   /* add some padding to the string so we don't
      require bounds checking */

   var string = new String(obj + "_______");
   var result = "";

   for (var i=0; i < string.length; ) {
      if (string.charAt(i) == "&") {
         if (string.substring(i, i+4) == "&lt;") {
            result += "<";
            i += 4;
         }
         else if (string.substring(i, i+4) == "&gt;") {
            result += ">";
            i += 4;
         }
         else if (string.substring(i, i+5) == "&amp;") {
            result += "&";
            i += 5;
         }
         else if (string.substring(i, i+6) == "&quot;") {
            result += "\"";
            i += 6;
         }
         else {
            result += string.charAt(i);
            i++;
         }
      }
      else {
         result += string.charAt(i);
         i++;
      }
   }
   return result.substring(0, result.length-7);
}