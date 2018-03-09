<!--
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2004
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
-->

<%@ include file="SegmentCommon.jsp" %>

<script language="JavaScript">
<!-- hide script from old browsers
function init () {
	if (parent.get) {
		var o = parent.get("<%= SegmentConstants.ELEMENT_SEGMENT_DETAILS %>", null);
		if (o != null) {
			loadValue(document.segmentForm.<%= SegmentConstants.ELEMENT_SEGMENT_NAME %>, o.<%= SegmentConstants.ELEMENT_SEGMENT_NAME %>);
			loadValue(document.segmentForm.<%= SegmentConstants.ELEMENT_DESCRIPTION %>, o.<%= SegmentConstants.ELEMENT_DESCRIPTION %>);
		}

		if (parent.get("<%= SegmentConstants.ELEMENT_SEGMENT_NAME_REQUIRED %>", false)) {
			parent.remove("<%= SegmentConstants.ELEMENT_SEGMENT_NAME_REQUIRED %>");
			alertDialog("<%= UIUtil.toJavaScript((String) segmentsRB.get(SegmentConstants.MSG_SEGMENT_NAME_REQUIRED)) %>");
			document.segmentForm.<%= SegmentConstants.ELEMENT_SEGMENT_NAME %>.focus();
		}
		if (parent.get("<%= SegmentConstants.ELEMENT_SEGMENT_NAME_TOO_LONG %>", false)) {
			parent.remove("<%= SegmentConstants.ELEMENT_SEGMENT_NAME_TOO_LONG %>");
			alertDialog("<%= UIUtil.toJavaScript((String) segmentsRB.get(SegmentConstants.MSG_SEGMENT_STRING_TOO_LONG)) %>");
			document.segmentForm.<%= SegmentConstants.ELEMENT_SEGMENT_NAME %>.select();
			document.segmentForm.<%= SegmentConstants.ELEMENT_SEGMENT_NAME %>.focus();
			return;
		}
		if (parent.get("<%= SegmentConstants.ELEMENT_SEGMENT_DESCRIPTION_TOO_LONG %>", false)) {
			parent.remove("<%= SegmentConstants.ELEMENT_SEGMENT_DESCRIPTION_TOO_LONG %>");
			alertDialog("<%= UIUtil.toJavaScript((String) segmentsRB.get(SegmentConstants.MSG_SEGMENT_STRING_TOO_LONG)) %>");
			document.segmentForm.<%= SegmentConstants.ELEMENT_DESCRIPTION %>.select();
			document.segmentForm.<%= SegmentConstants.ELEMENT_DESCRIPTION %>.focus();
			return;
		}
		if (parent.get("<%= SegmentConstants.ELEMENT_SEGMENT_EXISTS %>", false)) {
			parent.remove("<%= SegmentConstants.ELEMENT_SEGMENT_EXISTS %>");
			if (confirmDialog("<%= UIUtil.toJavaScript((String) segmentsRB.get(SegmentConstants.MSG_SEGMENT_EXISTS)) %>")) {
				parent.put("<%= SegmentConstants.ELEMENT_FORCE_SAVE %>", true);
				parent.finish();
				parent.remove("<%= SegmentConstants.ELEMENT_FORCE_SAVE %>");
			}
		}
		if (parent.get("<%= SegmentConstants.ELEMENT_SEGMENT_CHANGED %>", false)) {
			parent.remove("<%= SegmentConstants.ELEMENT_SEGMENT_CHANGED %>");
			if (confirmDialog("<%= UIUtil.toJavaScript((String) segmentsRB.get(SegmentConstants.MSG_SEGMENT_CHANGED)) %>")) {
				parent.put("<%= SegmentConstants.ELEMENT_FORCE_SAVE %>", true);
				parent.finish();
				parent.remove("<%= SegmentConstants.ELEMENT_FORCE_SAVE %>");
			}
		}
		if (parent.get("<%= SegmentConstants.ELEMENT_NAME_NOT_AVAILABLE %>", false)) {
			parent.remove("<%= SegmentConstants.ELEMENT_NAME_NOT_AVAILABLE %>");
			alertDialog("<%= UIUtil.toJavaScript((String) segmentsRB.get(SegmentConstants.MSG_NAME_NOT_AVAILABLE)) %>");
		}
	}

	if (!document.segmentForm.<%= SegmentConstants.ELEMENT_SEGMENT_NAME %>.disabled) {
		document.segmentForm.<%= SegmentConstants.ELEMENT_SEGMENT_NAME %>.focus();
	}
	else {
		document.segmentForm.<%= SegmentConstants.ELEMENT_DESCRIPTION %>.focus();
	}

	loadSegments();
}

function saveFormData () {
	if (parent.get) {
		var o = parent.get("<%= SegmentConstants.ELEMENT_SEGMENT_DETAILS %>", null);
		if (o != null) {
			if (!document.segmentForm.<%= SegmentConstants.ELEMENT_SEGMENT_NAME %>.disabled) {
				o.<%= SegmentConstants.ELEMENT_SEGMENT_NAME %> = document.segmentForm.<%= SegmentConstants.ELEMENT_SEGMENT_NAME %>.value;
			}
			o.<%= SegmentConstants.ELEMENT_DESCRIPTION %> = document.segmentForm.<%= SegmentConstants.ELEMENT_DESCRIPTION %>.value;
		}
	}

	saveSegments();
}
//-->
</script>
