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

function alertDebug(alertString) {
	if (debug) {
		alert(alertString);
	}
}

function PolicyReference (type, policyObject) {
	var myPR = new Object();

	myPR.policyName = policyObject.policyName;
	myPR.StoreRef = new Object();
	myPR.StoreRef.name = policyObject.storeIdentity;
	myPR.StoreRef.Owner = new Object();
	myPR.StoreRef.Owner = policyObject.member;
	
	// alert('Creating business policy XML='+dumpObject(myPR));
	return myPR;
}

function PolicyObject (displayText, policyName, policyId, storeIdentity, member, type) {
	var myPO = new Object();

	myPO.displayText = displayText;
	myPO.policyName = policyName;
	myPO.policyId = policyId;
	myPO.storeIdentity = storeIdentity;
	myPO.member = member;
	myPO.type = type;

	return myPO;
}

function findIndexInPolicyList(list, name, searchType) {
	if (searchType == "ID") {
    		for (var i = 0; i < list.length; i++) {
			if (list[i].policyId == name) {
				return i;
			}
		}
	}
	else {
    		for (var i = 0; i < list.length; i++) {
			if (list[i].policyName == name) {
				return i;
			}
		}
        }		
	return -1;
}

function popupXMLwindow(jsXMLobject, rootNode) {
    top.popupXMLobject = jsXMLobject;
    top.popupXMLobjectRootNode = rootNode;

    window.open('/webapp/wcs/tools/servlet/PopupXMLwindowView',
                'popupXMLwindow',
                'toolbar=no,menubar=no,location=no,scrollbars=yes,resize=yes,status=no,width=800,height=600');
}

// Set the values in a Select box - text is same as value
function loadSelectValues(select, values)
 {
  for (var i = 0; i < values.length; i++)
   {
    select.options[i] = new Option(values[i], values[i], false, false);
   }
 }

// Set the values in a Select box - value is different from text
function loadTextValueSelectValues(select, values)
 {
  for (var i = 0; i < values.length; i++)
   {
    select.options[i] = new Option(values[i].text, values[i].value, false, false);
   }
 }

// Load the values from a Select box - text is same as value
function getSelectValues(select)
 {
  var values = new Array();
  for (var i = 0; i < select.options.length; i++)
   {
    values[i] = select.options[i].value;
   }
  return values;
 }

// Load the values from a Select box - value is different from text
function getTextValueSelectValues(select)
 {
  var values = new Array();
  for (var i = 0; i < select.options.length; i++)
   {
    var vt = new Object();
    vt.text = select.options[i].text;
    vt.value = select.options[i].value;
    values[i] = vt;
   }
  return values;
 }

// Is an item in a Select box - value is different from text
function isInTextValueList(select, v)
 {
  for (var i = 0; i < select.options.length; i++)
   {
    if (select.options[i].value == v)
	return true;
   }
  return false;
 }

// Set the value in an entryfield
function loadValue(entryField, value)
 {
  if (value != top.undefined)
   {
    entryField.value = value;
   }
 }

// Is an item in an array of text-value pairs
function isNameInTextValueArray(n, a) {
   for (index = 0; index < a.length; index++) {
	if (a[index].value == n)
		return true;
   }
   return false;
}

// Is an item in an array of values
function isNameInArray(n, a) {
   for (index = 0; index < a.length; index++) {
	if (a[index] == n)
		return true;
   }
   return false;
}

// replace special characters
function replaceSpecialChars(obj)
{
   var result = new String(obj);

   result = result.replace(/&/g, "&amp;");
   result = result.replace(/</g, "&lt;");
   result = result.replace(/>/g, "&gt;");
   result = result.replace(/'/g, "&#39;");
   result = result.replace(/"/g, "&quot;");
   result = result.replace(/\//g, "&#47;");
   result = result.replace(/\\/g, "&#92;"); 

   return result;
}

function encodeNewLines(obj) {
  var string = new String(obj);
  return string.replace(/\r\n/g, "\\n");
}

function decodeNewLines(obj) {
  var string = new String(obj);
  return string.replace(/\\n/g, '\n');
}

function decodeNewLinesForHtml(obj) {
  var string = new String(obj);
  return string.replace(/\\n/g, "<BR>");
}

//////////////////////////////////////////////////////////
// This function will validate a typical file name field
// and restrict it to pretty much alphanumerics.
// All special characters are invalid with some exceptions
// " ", "-", "_", and "." are all valid
// The string can also not be empty
// call with ::
//    arg1=<myInputString>
//
// return true is name is valid, false otherwise
//////////////////////////////////////////////////////////
function isValidFileName(myString) {

    var invalidChars = "'*<>?|"; // invalid chars
    invalidChars += "\t\'\""; // escape sequences

    // if the string is empty it is not a valid name
    if (isEmpty(myString)) return false;

    // look for presence of invalid characters.  if one is
    // found return false.  otherwise return true
    for (var i=0; i<myString.length; i++) {
      if (invalidChars.indexOf(myString.substring(i, i+1)) >= 0) {
        return false;
      }
    }
    return true;
}

// This function can be used to create a valid XML representation of a Member.
// This function is designed to be used in coordination with the MemberDataBean.  
//
// Usage is as follows:
// 
// INPUT: 5 input arguments, generally coming from the MemberDataBean getters
// 1) memberType - the type of member (either 'U', 'O', or 'G')
// 2) memberDN - the DN of the member if the memberType is 'U' or 'O'.  if the memberType is 'G', then this arg should be set to null or an empty string.
// the following 3 args are optional and are only necessary if the memberType is 'G' (MemberGroup)
// 3) mgName - the name of the member group
// 3) mgOwnerType - the member type of the owner of the member group (either 'U' or 'O')
// 4) mgOwnerDN - the member DN of the member group's owner
//
// The MemberDataBean databean takes a memberId as an input argument
// After the populate() method is called, 5 getters can be called to determine the relevant properties of the member
// The getters map 1-to-1 with input argument for the javascript function above.
// 1) getMemberType() - return the member type of the memberid.  can be one of 3 possible values ('U' user, 'O' organization, or 'G' membergroup)
// 2) getMemberDN() - returns the distinguish name of the memberid.  will be set is the member is of type 'U' or 'O'.  otherwise null.
// 3) getMemberGroupName() - returns the member group name for the memberid.  will only be set if member type is 'G'.
// 4) getMemberGroupOwnerMemberType() - returns the member group's owner member type for the memberid.  can be one of 2 possible values ('U' user, 'O' organization).  
//    will only be set if member type is 'G'.
// 5) getMemberGroupOwnerMemberDN() - returns the member group's owner distinguish name for the memberid.  will only be set if member type is 'G'.
// 
// OUTPUT: javascript Member() object representing the populated MemberDataBean
// 
// Sample Usage in a JSP:
// 
// <%
//  try{
//    String memberId = fStoreMemberId; // figure out who your member id is!!!
//    MemberDataBean mdb = new MemberDataBean();
//    mdb.setId(memberId);
//    DataBeanManager.activate(mdb, request);
// %>
//     <script>
//         myJSobject = new Member('<%= mdb.getMemberType() %>',
//                                 '<%= mdb.getMemberDN() %>',
//                                 '<%= mdb.getMemberGroupName() %>',
//                                 '<%= mdb.getMemberGroupOwnerMemberType() %>',
//                                 '<%= mdb.getMemberGroupOwnerMemberDN() %>'));
//     </script>
// <%    
//   }
//   catch(Exception e) {
//   }
// %>
function Member (memberType, memberDN, mgName, mgOwnerType, mgOwnerDN) {
	var myMember = new Object();

        if (memberType == "U") {
            myMember.UserRef = new Object();
            myMember.UserRef.distinguishName = memberDN;
        }
        else if (memberType == "O") {
            myMember.OrganizationRef = new Object();
            myMember.OrganizationRef.distinguishName = memberDN;
        }
        else if (memberType == "G") {
            myMember.MemberGroupRef = new Object();
            myMember.MemberGroupRef.memberGroupName = mgName;
            if (mgOwnerType == "O") {
            	myMember.MemberGroupRef.OrganizationRef = new Object();
            	myMember.MemberGroupRef.OrganizationRef.distinguishName = mgOwnerDN;
            }
            else if (mgOwnerType == "U") {
            	myMember.MemberGroupRef.UserRef = new Object();
            	myMember.MemberGroupRef.UserRef.distinguishName = mgOwnerDN;
            }            	
        }
        
        return myMember;
}

function ContractReferenceElement(contractName, contractOrigin, contractMajor, contractMinor,
				memberType, memberDN, mgName, mgOwnerType, mgOwnerDN,
				contractId, plType) {
	var myRef = new Object();

	myRef.name = contractName;
	myRef.origin = contractOrigin;
	myRef.majorVersionNumber = contractMajor;
	myRef.minorVersionNumber = contractMinor;
	myRef.ContractOwner = new Member(memberType, memberDN, mgName, mgOwnerType, mgOwnerDN); 
        myRef.id = contractId;
        myRef.priceListType = plType;

        return myRef;
}

//
// the functions below are provided to simplify the creation of other Trading XML elements
//
function CatalogOwner(memberType, memberDN, mgName, mgOwnerType, mgOwnerDN) {
	var myOwner = new Object();

        myOwner = new Member(memberType, memberDN, mgName, mgOwnerType, mgOwnerDN);        
        return myOwner;
}

function ProductSetOwner(memberType, memberDN, mgName, mgOwnerType, mgOwnerDN) {
	var myOwner = new Object();

        myOwner = new Member(memberType, memberDN, mgName, mgOwnerType, mgOwnerDN);        
        return myOwner;
}

function AccountOwner(memberType, memberDN, mgName, mgOwnerType, mgOwnerDN) {
	var myOwner = new Object();

        myOwner = new Member(memberType, memberDN, mgName, mgOwnerType, mgOwnerDN);        
        return myOwner;
}

function SkuOwner(memberType, memberDN, mgName, mgOwnerType, mgOwnerDN) {
	var myOwner = new Object();

        myOwner = new Member(memberType, memberDN, mgName, mgOwnerType, mgOwnerDN);        
        return myOwner;
}

function StoreOwner(memberType, memberDN, mgName, mgOwnerType, mgOwnerDN) {
	var myOwner = new Object();

        myOwner = new Member(memberType, memberDN, mgName, mgOwnerType, mgOwnerDN);        
        return myOwner;
}

function ContractOwner(memberType, memberDN, mgName, mgOwnerType, mgOwnerDN) {
	var myOwner = new Object();

        myOwner = new Member(memberType, memberDN, mgName, mgOwnerType, mgOwnerDN);        
        return myOwner;
}
