//
//-------------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (c) Copyright IBM Corp. 2006
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//-------------------------------------------------------------------
//

	//////////////////////////////////////////////////////////////////////////////////////
	// submitErrorHandler(errMessage, errorStatus) 
	//
	// - Called when error is received from controller command. 
	//////////////////////////////////////////////////////////////////////////////////////
	function submitErrorHandler(errMessage, errorStatus) 
	{
		if(CONTENTS.submitErrorHandler)
			CONTENTS.submitErrorHandler(errMessage, errorStatus); 
		else
			top.alertDialog(errMessage);	
	}
	
	//////////////////////////////////////////////////////////////////////////////////////
	// submitFinishHandler(finishMessage) 
	//
	// - Called upon successful completion of controller command. 
	//////////////////////////////////////////////////////////////////////////////////////
	function submitFinishHandler(finishMessage)
	{
		if(CONTENTS.submitFinishHandler)
			CONTENTS.submitFinishHandler(finishMessage); 
		else
			top.alertDialog(finishMessage);	
	}

	//////////////////////////////////////////////////////////////////////////////////////
	// submitCancelHandler()
	//
	// - Called when Cancel is clicked. 
	//////////////////////////////////////////////////////////////////////////////////////
	//function submitCancelHandler()
	//{
	//	if(CONTENTS.submitCancelHandler)
	//		CONTENTS.submitCancelHandler();
	//	else
	//		top.goBack();	 
	//}

	//////////////////////////////////////////////////////////////////////////////////////
	// preSubmitHandler()
	//
	// - Called after validateAllPanels() but before finish controller command.
	//////////////////////////////////////////////////////////////////////////////////////
	//function preSubmitHandler() 
	//{
	//	if(CONTENTS.preSubmitHandler)
	//		CONTENTS.preSubmitHandler(); 
	//}
