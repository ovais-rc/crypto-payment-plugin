<!--==========================================================================
Licensed Materials - Property of IBM

WebSphere Commerce

(c)  Copyright  IBM Corp.  2000      All Rights Reserved

US Government Users Restricted Rights - Use, duplication or
disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
===========================================================================-->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@include file="eCouponCommon.jsp" %>
<%@page import="com.ibm.commerce.price.utils.*" %>
<%@page import="com.ibm.commerce.common.objects.*" %>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title><%=eCouponWizardNLS.get("eCouponDescription_title")%></title>
<%= feCouponHeader%>

<script src="/wcs/javascript/tools/common/Util.js">
</script>
<script src="/wcs/javascript/tools/common/DateUtil.js">
</script>

<script language="JavaScript">
function initializeState()
{
	var visitedDescriptionForm = parent.get("visitedDescriptionForm", false);
	//alertDialog("in initialize");
	if (visitedDescriptionForm)  // if we've been here already ...
	{
		//alertDialog(" Yeah Description visited already");

		// get short and long desc
		document.descriptionForm.shortDesc.value = parent.get("shortDesc");
		document.descriptionForm.longDesc.value = parent.get("longDesc");
		document.descriptionForm.thumbNailPath.value = parent.get("thumbNailPath");
		document.descriptionForm.fullImagePath.value = parent.get("fullImagePath");
	}
	document.descriptionForm.shortDesc.focus();
	parent.setContentFrameLoaded(true);
}

function savePanelData()
{
	//alertDialog("inside Details save Panel data");
     	// put short and long desc in top frame
	parent.put("shortDesc", document.descriptionForm.shortDesc.value);
	parent.put("longDesc", document.descriptionForm.longDesc.value);
	parent.put("thumbNailPath", document.descriptionForm.thumbNailPath.value);
	parent.put("fullImagePath", document.descriptionForm.fullImagePath.value);

    	parent.put("visitedDescriptionForm", true);
	//alertDialog(" Exiting save Panel");
	return true;
}

function validatePanelData()
{
	if (!isValidUTF8length(document.descriptionForm.shortDesc.value, 64))
	{
	    reprompt(document.descriptionForm.shortDesc,"<%= UIUtil.toJavaScript(eCouponWizardNLS.get("eCouponFieldTooLong").toString())%>");
	    return false;
	}
	if (!isValidUTF8length(document.descriptionForm.longDesc.value, 254))
	{
	    reprompt(document.descriptionForm.longDesc,"<%= UIUtil.toJavaScript(eCouponWizardNLS.get("eCouponFieldTooLong").toString())%>");
	    return false;
	}
	if (!isValidUTF8length(document.descriptionForm.thumbNailPath.value, 254))
	{
	    reprompt(document.descriptionForm.thumbNailPath,"<%= UIUtil.toJavaScript(eCouponWizardNLS.get("eCouponFieldTooLong").toString())%>");
	    return false;
	}
		if (!isValidUTF8length(document.descriptionForm.fullImagePath.value, 254))
	{
	    reprompt(document.descriptionForm.fullImagePath,"<%= UIUtil.toJavaScript(eCouponWizardNLS.get("eCouponFieldTooLong").toString())%>");
	    return false;
	}
	//alertDialog(" over with validate");
	return true;
}


</script>
<meta name="GENERATOR" content="IBM WebSphere Studio" />
</head>

<body class="content" onload="initializeState();">
<!-- ============================================================================
The sample Templates, HTML and Macros are furnished by IBM as simple
examples to provide an illustration. These examples have not been
thoroughly tested under all conditions.  IBM, therefore, cannot guarantee reliability,
serviceability or function of these programs. All programs contained herein are provided
to you "AS IS".

The sample Templates, HTML and Macros may include the names of individuals,
companies, brands and products in order to illustrate them as completely as
possible.  All of these are names are ficticious and any similarity to the names
and addresses used by actual persons or business enterprises is entirely coincidental.

Licensed Materials - Property of IBM

5697-D24

(c)  Copyright  IBM Corp.  1997, 1999.      All Rights Reserved

US Government Users Restricted Rights - Use, duplication or
disclosure restricted by GSA ADP Schedule Contract with IBM Corp

=============================================================================== -->

<form name="descriptionForm" id="descriptionForm">

<h1><%=eCouponWizardNLS.get("eCouponDescription")%></h1>

<p><label for="shortDesc"><%=eCouponWizardNLS.get("eCouponShortDescLabel")%></label><br />
<textarea name="shortDesc" id="shortDesc" rows="2" cols="50" wrap="physical" onkeydown="limitTextArea(this.form.shortDesc, 64);" onkeyup="limitTextArea(this.form.shortDesc, 644);"></textarea></p>

<p><label for="longDesc"><%=eCouponWizardNLS.get("eCouponLongDescLabel")%></label><br />
<textarea name="longDesc" id="longDesc" rows="6" cols="50" wrap="physical" onkeydown="limitTextArea(this.form.longDesc, 254);" onkeyup="limitTextArea(this.form.longDesc, 254);"></textarea></p>

<p><label for="thumbNailPath"><%=eCouponWizardNLS.get("eCouponThumbnailPathLabel")%></label><br />
<input name="thumbNailPath" type="text" size="64" maxlength="254" id="thumbNailPath" /></p>

<p><label for="fullImagePath"><%=eCouponWizardNLS.get("eCouponFullImagePathLabel")%></label><br />
<input name="fullImagePath" type="text" size="64" maxlength="254" id="fullImagePath" /></p>

<script>
//parent.put("visitedDescriptionForm", true);
parent.setContentFrameLoaded(true);

</script>
</form>
</body>
</html>
