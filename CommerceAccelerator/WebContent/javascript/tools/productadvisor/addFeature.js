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

function addSelectedFeatures()
{
	if(self.CONTENTS.basefrm.validatePanelData())
	{
	self.CONTENTS.basefrm.addSelectedFeaturestoList();
	top.goBack();
	}
}
 
function cancelAddFeature()
{
	top.goBack();
}