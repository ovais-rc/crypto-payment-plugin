//-----------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (C) Copyright IBM Corp. 2001, 2014 All Rights Reserved.
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with
// IBM Corp.
//-----------------------------------------------------------------

   function trim(str) 
   {
	//removes leading and trailing spaces
	if (str.length==0) 
		return "";  //exit on empty string
	while (str.charAt(0) == " ")
		str = str.substring(1,str.length);  //remove leading spaces
	while (str.charAt(str.length-1)==" ")
		str = str.substring(0,str.length-1); //remove trailing spaces
	return str;
   }
   
   function submitCancelHandler()
   {
     if(!confirmDialog(CONTENTS.getConfirmationMessage()))
     { return; }
     top.goBack();
   }

   function preSubmitHandler()
   {
     params = new Object();
     top.mccbanner.removebct();
     var j = CONTENTS.document.createForm.actionGroup.selectedIndex;
     var k = CONTENTS.document.createForm.relation.selectedIndex;
     var pattern = /^\s*$/;     
     if(k != -1 && !pattern.test(CONTENTS.document.createForm.relation.options[k].value))
     {
       params['relation'] = window.CONTENTS.document.createForm.relation.options[k].value;
     }
     for (var i = 0; i < window.CONTENTS.document.createForm.elements.length; i++)
     {
       if(window.CONTENTS.document.createForm.elements[i].name == 'policyType')
       {
          if(window.CONTENTS.document.createForm.elements[i].checked)
          {
            params['policyType'] = '3';
          }       
       }
     }
     params['policyName'] = trim(window.CONTENTS.document.createForm.policyName.value);
     params['policyDisplayName'] = trim(window.CONTENTS.document.createForm.policyDisplayName.value);
     params['policyDescription'] = trim(window.CONTENTS.document.createForm.policyDescription.value);
     params['userGroupId'] = window.CONTENTS.document.createForm.userGroupId.value;
     params['ownerId'] = window.CONTENTS.document.createForm.ownerId.value; 
     params['searchOrg'] = window.CONTENTS.document.createForm.ownerId.value;
     params['viewtaskname'] = window.CONTENTS.document.createForm.viewname.value;
     params['ActionXMLFile'] = window.CONTENTS.document.createForm.ActionXMLFile.value;
     params['cmd'] = window.CONTENTS.document.createForm.cmd.value;
     params['resourceGroup'] = window.CONTENTS.document.createForm.resourceGroupId.value;
     params['actionGroup'] = window.CONTENTS.document.createForm.actionGroup.options[j].value;
     params['authToken'] = window.CONTENTS.document.createForm.authToken.value;
     top.showContent(top.getWebappPath() + 'PolicyAddCmd',params);
}
