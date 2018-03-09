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

// @deprecated The Product Advisor feature has been deprecated. For more information, see <a href="../../../../../../com.ibm.commerce.productadvisor.doc/concepts/cpaintro.htm">Product Advisor</a>.

  function applyAndPreview()
  {
	addURLParameter("applyAndPreview","true");
	removeURLParameter("concurrencyCheck");
	removeURLParameter("fromConCur");
	finish();
  }
   
 function okButton()
 {
	removeURLParameter("applyAndPreview");
	removeURLParameter("concurrencyCheck");
	removeURLParameter("fromConCur");
	finish();
 }

 function submitErrorHandler(submitErrorMessage, submitErrorStatus)
 {
      alertDialog(submitErrorMessage);
 }

 function submitFinishHandler(finishMessage)
 {
	var param = finishMessage.split(';');
	finishMessage = param[0];
	var metaphorId = param[1];
      if(finishMessage == "conConfirm" || finishMessage == "conConfirmAP") {
		var selected = self.CONTENTS.basefrm.concurrentConfirmMsg();
		if(selected){
			addURLParameter("concurrencyCheck","false");
			addURLParameter("fromConCur","true");
			if(finishMessage == "conConfirmAP"){
				addURLParameter("applyAndPreview","true");
			}
			finish();
		}
	} else if(finishMessage == "AandP"){
		top.put("featExists","true");
		top.put("metaphorId",metaphorId);
		self.CONTENTS.basefrm.preview();
	} else if(finishMessage == "Delete"){
		top.goBack();
	} else if(finishMessage == "metSuccess"){
		//alertDialog("Metaphor has been created successfully.");
		top.goBack();
	} else if(finishMessage == "AandPDelete"){
		top.put("metaphorId","-1");
		top.put("featExists","false");
	}

 }

 
 function submitCancelHandler()
 {
	if(self.CONTENTS.basefrm.cancelConfirmMsg())
	{
		if (top.goBack) {
      		top.goBack();
		} else {
      	     //alert("Error: top.goBack invalid");
		}
	}
 }

 function preSubmitHandler()
 {
 }
