/****************************************************************************
 *
 * Licensed Materials - Property of IBM
 *
 * WebSphere Commerce
 *
 * (c) Copyright IBM Corp. 2002
 *
 * US Government Users Restricted Rights - Use, duplication or
 * disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 * 
 ***************************************************************************/



	function paramInfo(name, value, displayName){
		this.name = name;
		this.value = value;
		this.displayName = displayName;
	}

		
	function submitFinishHandler(finishMessage){
		alertDialog(finishMessage);
		//document.location.replace(top.getWebappPath() + "NewDynamicListView?ActionXMLFile=publish.StorePublishStatusList&amp;cmd=StorePublishStatusListView" );
		top.setContent(CONTENTS.publishStatusTitle,top.getWebappPath() + "NewDynamicListView?ActionXMLFile=publish.StorePublishStatusList&amp;cmd=StorePublishStatusListView", false );

	}
	   
   function submitErrorHandler(submitErrorMessage, submitErrorStatus)
   {
	   	alertDialog(submitErrorMessage);
   }


   function submitCancelHandler()
   {
   		top.goBack();
   }

   function preSubmitHandler()
   {

   }
