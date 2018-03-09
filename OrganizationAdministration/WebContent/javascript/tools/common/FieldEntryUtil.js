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


/*---------------------------------------------------------------------------
  WARNING: PLEASE INCLUDE FILE "Util.js" WHEN USING THIS FILE
  WARNING: PLEASE INCLUDE FILE "Vector.js" WHEN USING THIS FILE
---------------------------------------------------------------------------*/


// Database entry states
var ADD      = "add";     // A new entry is to made in the database
var CHANGE   = "change";  // A current entry in the database is to be updated
var REMOVE   = "remove";  // A current entry in the database is to be removed
var NONE     = "...";     // This entry is the current value in the database

// Common tag/property names
var ACTION   = "HIDE_action";    // A tag that indicates the current state of an entry
                                 // In order to work with the CreateTable.js to create
                                 // a table, the prefix of the ACTION has to start with HIDE_
                                 // in order to hide the value of the action from the
                                 // user.
var OLDVALUE = "oldValue";  // The value of an entry currently in the database
var VALUE    = "value";     // The value of an entry to be placed in the database

/****************************************************************************
* Create/Change an entry and update its current state.
*
* root  The root of a tree of which the entry is a child of.
* index The location of the entry.
* value The entry value.
*
* Returns "true" if successful; "false" otherwise.
****************************************************************************/
function updateEntry(root, index, value)
{
  if(!defined(root[index]))
    return(addEntry(root, index, value));
  else
    return(changeEntry(root, index, value));
}

/****************************************************************************
* Create a new entry to be placed into the database and update its current
* state.
*
* root  The root of a tree upon which the entry will become a child of.
* index The location of the entry.
* value The entry value. 
*
* Always returns "true".
****************************************************************************/
function addEntry(root, index, value)
{
  if ((root.type) && (root.type == "Vector"))
  {
    //var element = root.elementAt(index);
    var element = elementAt(index, root);
    
    if ((!defined(element)) && (!defined(value[ACTION])))
    {
      value[ACTION] = ADD;
      //root.addElement(value);
      addElement(value, root);
    }// Undo action to this entry
    else if (element[ACTION] == REMOVE)
      element[ACTION] = NONE;
  }
  else
  {
    if(!defined(root[ACTION]))
      root[ACTION] = ADD;
    if(!defined(root[index]) && (root[ACTION] == ADD))
      root[index] = value;
    // Undo action to this entry
    else if(root[ACTION] == REMOVE)
      root[ACTION] = NONE;
  }
  return(true);
}

/****************************************************************************
* Change the value of a current entry and update its current state.
*
* root  The root of a tree of which the entry is a child of.
* index The location of the entry.
* value The entry value.
*
* Returns "true" if successful; "false" otherwise.
****************************************************************************/
function changeEntry(root, index, value)
{
  if ((root.type) && (root.type == "Vector"))
  {
    //var element = root.elementAt(index);
    var element = elementAt(index, root);

    if(!defined(element))
      return(false);

    if((element[ACTION] == NONE) || (element[ACTION] == REMOVE))
    {
      value[ACTION] = CHANGE;
      //root.removeElementAt(index);
      removeElementAt(index, root);
            
      if (index == size(root)) {
        //root.addElement(value);
        addElement(value, root);
      }
      else 
        //root.insertElementAt(value, index);
        insertElementAt(value, index, root);
    }
    else if((element[ACTION] == ADD) || (element[ACTION] == CHANGE))
    {
      value[ACTION] = element[ACTION];
      //root.removeElementAt(index);
      removeElementAt(index, root);
      
      if (index == size(root)) {
        // root.addElement(value);
        addElement(value, root);
      }
      else 
        //root.insertElementAt(value, index);
        insertElementAt(value, index, root);
    }
  }
  else
  {
    if(!defined(root[index]))
      return(false);

    if((root[ACTION] == NONE) || (root[ACTION] == REMOVE)) {
      root[index]  = value;
      root[ACTION] = CHANGE;
    }
    else if((root[ACTION] == ADD) || (root[ACTION] == CHANGE))
      root[index] = value;
  }  
  
  return(true);
}

/****************************************************************************
* Remove an entry and update its current state.
*
* root  The root of the tree of which the entry is a child of.
* index The location of the entry.
****************************************************************************/
function removeEntry(root, index)
{
  if ((root.type) && (root.type == "Vector"))
  {
    // var element = root.elementAt(index);
    var element = elementAt(index, root);

    if((element[ACTION] == NONE) || (element[ACTION] == CHANGE))
      element[ACTION] = REMOVE;
    
    // If this entry was never saved to the database, remove the entry from the tree.
    else if(element[ACTION] == ADD) {
      // root.removeElementAt(index);
      removeElementAt(index, root);
    }
  }
  else
  {
    if((root[ACTION] == NONE) || (root[ACTION] == CHANGE))
      root[ACTION] = REMOVE;
      
    // If this entry was never saved to the database, remove the entry from the tree.
    else if(root[ACTION] == ADD)
      delete root[index];
  }
}
