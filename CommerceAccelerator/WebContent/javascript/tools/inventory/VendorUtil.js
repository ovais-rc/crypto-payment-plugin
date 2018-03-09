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

/************************************************************************
* An object that represents various attributes of a country.
************************************************************************/
function Country()
{
  this.name         = new Object(); 
  this.regions      = new Array();
  this.numOfRegions = new Object();
}

/***********************************************************************
* An object that represents the address.
***********************************************************************/
function Address()
{
  addEntry(this, "nickName", "");
  addEntry(this, "firstName", "");
  addEntry(this, "lastName",  "");
  addEntry(this, "address1",  "");
  addEntry(this, "address2",  "");
  addEntry(this, "address3",  "");
  addEntry(this, "city",       "");
  addEntry(this, "region",     "");
  addEntry(this, "country",    "");
  addEntry(this, "postalCode", "");

  addEntry(this, "phoneNumber",   "");
  addEntry(this, "email",         "");
  addEntry(this, "onMailingList", "true");
  addEntry(this, "addrType", "");
  
  addEntry(this, "middleName", "");
  addEntry(this, "title", "");
  addEntry(this, "position", "");
  addEntry(this, "fax", "");
}



/***********************************************************************
* An object that represents the shipping provider.
***********************************************************************/
function ShippingProvider()
{
  addEntry(this, "refno", "");
  addEntry(this, "name",  "");
  addEntry(this, "service",  "");

}

/***********************************************************************
* An object that represents the item
***********************************************************************/
function Item()
{
  addEntry(this, "refno",       "");
  addEntry(this, "number",      "");
  addEntry(this, "name",        "");
  addEntry(this, "price",       null);
  addEntry(this, "actualPrice", null);
  addEntry(this, "inventory",   "");
  
  this.quantity = new Object;
  addEntry(this.quantity, "value", 0);
  this.comment = new Object;
  addEntry(this.comment, "value", "");
}
	 
/***********************************************************************
* An object that represents the total adjustment on an order.
***********************************************************************/
function TotalAdjustment()
{
  addEntry(this, "value",       "");
}

/***********************************************************************
* An object that represents the total tax on an order.
***********************************************************************/
function TotalTax()
{
  addEntry(this, "value",       "");
}

/***********************************************************************
* An object that represents the total shipping charges on an order.
***********************************************************************/
function ShippingCharge()
{
  addEntry(this, "value",       "");
}

/***********************************************************************
* An object that represents the total shipping tax on an order.
***********************************************************************/
function ShippingTax()
{
  addEntry(this, "value",       "");
}



//////////////////////////////////////////
// provider object                      //
//////////////////////////////////////////
function Provider()
{
  addEntry(this, "action", "");    
  addEntry(this, "refno","");
  addEntry(this, "name", "");
  addEntry(this, "service", "");
}


///////////////////////////////////////////
// paymnet object                        //
//////////////////////////////////////////
function Payment() 
{
  addEntry(this, "type", "");
  addEntry(this, "number", "");
  addEntry(this, "expiryYear", "");
  addEntry(this, "expiryMonth", "");
}


///////////////////////////////////////////
// comment object                        //
///////////////////////////////////////////
function Comment() 
{
  addEntry(this, "message", "");
  addEntry(this, "date", "");
}
