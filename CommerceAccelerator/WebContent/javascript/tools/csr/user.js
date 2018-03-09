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

function isEmpty(id) {
   return !id.match(/[^\s]/);
}

function undoChange (bitName)
{
   //alert("undo change " + bitName);
   top.put(bitName, "false");
}
  
function setDirtyBit(bitName)
{
   //alert("set dirty bit "+ bitName);
   top.put(bitName,"true");
}

function trim(word)
{
   var i=0;
   var j=word.length-1;
   while(word.charAt(i) == " ") i++;
   while(word.charAt(j) == " ") j--;
   return word.substring(i,j+1);
}

function isNumber(word) 
{
   var numbers="0123456789";
   for (var i=0; i < word.length; i++)
   {
      if (numbers.indexOf(word.charAt(i)) == -1) 
         return false;
   }
   return true;
}

function getValue(value,deflt)
{
   return value=="" ? deflt : value;
}

function println(value)
{
   document.writeln(value);
}

function print(value)
{
   document.write(value);
}

function lockInput(inputElement, flag)
{
   if (flag == true)
      inputElement.blur();
}

function restoreCheckBox(checkbox, flag)
{
   if (flag == true)
   {
      if (checkbox.checked == true)
         checkbox.checked = false;
      else
         checkbox.checked = true;
   }
}

