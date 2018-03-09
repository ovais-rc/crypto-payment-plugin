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
     var j = CONTENTS.document.changeForm.actionGroup.selectedIndex;
     var k = CONTENTS.document.changeForm.relation.selectedIndex;
     var rel = "";
     var pattern = /^\s*$/;  
     if(k != -1 && !pattern.test(CONTENTS.document.changeForm.relation.options[k].value))
     {
       params['relation'] = window.CONTENTS.document.changeForm.relation.options[k].value;
     }
     params['policyName'] = trim(window.CONTENTS.document.changeForm.policyName.value);
     params['policyDisplayName'] = trim(window.CONTENTS.document.changeForm.policyDisplayName.value);
     params['policyDescription'] = trim(window.CONTENTS.document.changeForm.policyDescription.value); 
     params['userGroupId'] = window.CONTENTS.document.changeForm.userGroupId.value; 
     params['ownerId'] = window.CONTENTS.document.changeForm.ownerId.value;
     params['searchOrg'] = window.CONTENTS.document.changeForm.ownerId.value;
     params['policyId'] = window.CONTENTS.document.changeForm.policyId.value;
     params['viewtaskname'] = window.CONTENTS.document.changeForm.viewname.value;
     params['ActionXMLFile'] = window.CONTENTS.document.changeForm.ActionXMLFile.value; 
     params['cmd'] = window.CONTENTS.document.changeForm.cmd.value;
     params['resourceGroup'] = window.CONTENTS.document.changeForm.resourceGroupId.value; 
     params['actionGroup'] = window.CONTENTS.document.changeForm.actionGroup.options[j].value;
     params['authToken'] = window.CONTENTS.document.changeForm.authToken.value;
     top.showContent(top.getWebappPath() + 'PolicyUpdateCmd',params);
}
