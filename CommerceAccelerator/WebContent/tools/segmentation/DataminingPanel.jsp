<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2000, 2013 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<%@page import="com.ibm.commerce.command.CommandContext" %>
<%@page import="com.ibm.commerce.server.ECConstants" %>
<%@page import="com.ibm.commerce.tools.segmentation.SegmentConstants" %>
<%@page import="com.ibm.commerce.tools.segmentation.SegmentUtil" %>
<%@page import="com.ibm.commerce.tools.util.ResourceDirectory" %>
<%@page import="com.ibm.commerce.tools.util.UIUtil" %>
<%@page import="java.util.Hashtable" %>
<%@page import="java.util.Enumeration" %>
<%@page import="java.util.Locale" %>
<%@page import="java.util.Vector" %>
<%@page import="com.ibm.commerce.ras.ECTrace" %>
<%@page import="com.ibm.commerce.ras.ECTraceIdentifiers" %>

<%@include file="../common/common.jsp" %>

<jsp:useBean id="data" scope="request" class="com.ibm.commerce.bi.databeans.SegmentNotebookDataminingDatabean"></jsp:useBean>

<%
    CommandContext cmdContext = (CommandContext)request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
    Locale locale = null;

    // use server default locale if no command context is found
    if (cmdContext != null) {
        locale = cmdContext.getLocale();
    } else {
        locale = Locale.getDefault();
    }

    if (locale==null) {
        locale=Locale.US;
    }
	// get request variables
	String model = request.getParameter("model");
	String segment = request.getParameter("segment");
	String score = request.getParameter("score");

    // set databean request properties
 	data.init(cmdContext);
	Hashtable resources = (Hashtable) ResourceDirectory.lookup(SegmentConstants.SEGMENTATION_RESOURCES, locale);

%>

<html>

<head>
<link rel=stylesheet href="<%= UIUtil.getCSSFile(locale) %>" type="text/css">
<title><%= resources.get("dataminingTitle") %></title>
<script>
		var modelX = null;
		var segment = null;
		var score = null;
		var filteredResults = null;

<%	if (model != null) { %>
		modelX = "<%=UIUtil.toJavaScript(model)%>";
<%	}
	if (segment != null) { %>
		segment = "<%=UIUtil.toJavaScript(segment)%>";
<%	}
	if (score != null) { %>
		score = parent.numberToStr('<%=UIUtil.toJavaScript(score)%>', top.langId);
		filteredResults = "<%= data.getFilteredResults(model, segment, score) %>";
<%	} %>

<% data.getJSArray(out); %>

function loadPanelData() {
	if (parent.setContentFrameLoaded) {
		parent.setContentFrameLoaded(true);
	}

	// if model is null, then the rest must also be null
	if (modelX == null) {
		// if model has been stored in the parent model, the other vars must also be there
		// can't get data from segmentation notebook.
		//if (parent.get("model")) {
		//	modelX = parent.get("model");
		//	segment = parent.get("segment");
		//	score = parent.get("score");
		//}
	}
	//updateForm(modelX, segment);
}

function refresh() {
	if (!validateScoreData()) {
		return false;
	}

	top.showProgressIndicator(true);

	var mod = document.all.modelSelect[document.all.modelSelect.selectedIndex].value;
	var seg = document.all.segmentSelect[document.all.segmentSelect.selectedIndex].value;
	var sco = parent.strToNumber(document.all.scoreTextbox.value, top.langId);

	document.location = location.pathname + "?model=" + mod + "&segment=" + seg + "&score=" + sco;
}


function updateForm(newModel, newSegment) {
	var modelSelected = false;
	var segmentSelected = false;
	for (var x=0; x<model.length; x++) {
		if (modelSelected==false && model[x].id==newModel || newModel==null) {
			// found model -- set selection
			document.all.modelSelect.selectedIndex = x;
			// found model -- set model description
			document.all.modelDesc.innerText = model[x].desc;
			// set associated segments
			document.all.segmentSelect.innerHTML = "";
			for (var y=0; y<model[x].segments.length; y++) {
				var opt = document.createElement("OPTION");
				opt.value = y;
				opt.innerText = y;
				if (segmentSelected==false && y==newSegment || newSegment==null && y==0) {
					opt.selected = true;
				}
				document.all.segmentSelect.appendChild(opt);
			}
			document.all.scoreTextbox.innerText = parent.formatNumber("0", top.langId, 1);
			break;
		}
	}
	updateNumberInSegment(document.all.modelSelect.selectedIndex, document.all.segmentSelect.selectedIndex);
}


function updateNumberInSegment(m, s) {
	if (modelX==model[m].id && segment==s) {
		if (parent.strToNumber(score, top.langId)==parent.strToNumber(document.all.scoreTextbox.value, top.langId)) {
			document.all.scoreSpan.innerText = filteredResults;
			document.all.form.style.visibility = "hidden";
		} else if (parent.strToNumber(document.all.scoreTextbox.value, top.langId)==0){
			document.all.scoreSpan.innerText = model[m].segments[s];
		} else {
			document.all.form.style.visibility = "visible";
			document.all.scoreSpan.innerHTML = "<%= resources.get("dataminingSegmentSizeUnknown") %>";
		}
	} else {
		document.all.scoreSpan.innerText = model[m].segments[s];
		if (parent.strToNumber(document.all.scoreTextbox.value, top.langId)!=0) {
			document.all.form.style.visibility = "visible";
			document.all.scoreSpan.innerHTML = "<%= resources.get("dataminingSegmentSizeUnknown") %>";
		} else {
			document.all.form.style.visibility = "hidden";
			}
	}
}

function validateScoreData() {
	if (!parent.isValidNumber(document.all.scoreTextbox.value, top.langId)) {
		top.alertDialog("<%= resources.get("dataminingScoreError") %>");
		document.all.scoreTextbox.innerText = parent.formatNumber("0", top.langId, 1);
		document.all.scoreTextbox.focus();
		return false;
	}
	if (isNaN(parent.strToNumber(document.all.scoreTextbox.value, top.langId)) ||
		0.0 > parent.strToNumber(document.all.scoreTextbox.value, top.langId)  ||
		parent.strToNumber(document.all.scoreTextbox.value, top.langId) > 1) {
		top.alertDialog("<%= resources.get("dataminingScoreError") %>");
		document.all.scoreTextbox.innerText = parent.formatNumber("0", top.langId, 1);
		document.all.scoreTextbox.focus();
		return false;
	} else {
		return true;
	}
}

function validatePanelData() {
 	if (!validateScoreData()) {
		return false;
 	} else if (filteredResults != null && filteredResults == 0) {
		top.alertDialog("<%= resources.get("dataminingFilteredToZero") %>");
		return false;
	} else {
		return true;
	}
}

function ok() {
	if (!validatePanelData()) {
		return false;
	}
	top.alertDialog("<%= resources.get("dataminingFinishAlert") %>");
	var WCAClosedLoopImport =  new Object();

	var Xmodel = document.all.modelSelect[document.all.modelSelect.selectedIndex].value;
	var Xsegment = document.all.segmentSelect[document.all.segmentSelect.selectedIndex].value;
	var Xscore = parent.strToNumber(document.all.scoreTextbox.value, top.langId);

    top.sendBackData(Xmodel,"WCAClosedLoopImportModel",1);
    top.sendBackData(Xsegment,"WCAClosedLoopImportSegment",1);
    top.sendBackData(Xscore,"WCAClosedLoopImportScore",1);
	top.goBack();
}


function changeScore(value) {
	if (parent.isValidNumber(value, top.langId)) {
		if (parent.strToNumber(value, top.langId) == <%=(score == null ? null : UIUtil.toJavaScript(score))%>) {
			updateNumberInSegment(document.all.modelSelect.selectedIndex, document.all.segmentSelect.selectedIndex);
		} else if (parent.strToNumber(value, top.langId) == 0 || value == "" || value == "." || value == ",") {
			updateNumberInSegment(document.all.modelSelect.selectedIndex, document.all.segmentSelect.selectedIndex);
		} else {
			document.all.scoreSpan.innerHTML = "<%= resources.get("dataminingSegmentSizeUnknown") %>";
			document.all.form.style.visibility = "visible";
		}
	}
}

</script>
<meta name="GENERATOR" content="IBM WebSphere Studio">
</head>

<body onload="loadPanelData()" class="content">

<h1><%= resources.get("dataminingTitle") %></h1>

<%	if (data.isThereAnyData()) { %>
	<form id="miningForm">
	        <p> 
		<label for="modelSelect"><%= resources.get("dataminingModel") %></label> 
		<select size="1" onchange="updateForm(this.options[this.selectedIndex].value, 0)" name="modelSelect" id="modelSelect">
		<% model = data.getModelOptions(model, out); %>
		</select>
		<div id="modelDesc">
			<%= data.getModelDescription(model) %>
		</div>
		</p>

                <p>
		<label for="segmentSelect"><%= resources.get("dataminingSegment") %></label>
		<select size="1" onchange="document.all.scoreTextbox.innerText=parent.formatNumber('0', top.langId, 1);updateNumberInSegment(document.all.modelSelect.selectedIndex, this.selectedIndex)" name="segmentSelect" id="segmentSelect">
		<script>
		for (var x=0; x<model.length; x++) {
			if (model[x].id == document.all.modelSelect[document.all.modelSelect.selectedIndex].value) {
				for (var y=0; y<model[x].segments.length; y++) {
					if (segment == y) {
						document.writeln('<option selected value="' + y + '">' + y + '</option>');
					} else {
						document.writeln('<option value="' + y + '">' + y + '</option>');
					}
				}
			}
		}
		</script>
		</select>
		</p>
		<p><%= resources.get("dataminingScore") %><br>
		<%= resources.get("dataminingScoreExplanation") %><br>
		<script>
		document.write('<input type="text" maxlength="10" value="');
		if (score == null) {
			document.write(parent.formatNumber("0", top.langId, 1));
		} else {
			document.write(score);
		}
		document.writeln('" id="scoreTextbox" size="3" onkeyup="changeScore(this.value)">');
		</script>
		&nbsp;&nbsp;<button id=form onclick="refresh()" style="visibility:hidden;"><%= resources.get("dataminingRefreshSegmentSample") %></button>
		</p>
		<p>
		<%= resources.get("dataminingNumberOfMembers") %>
		<script>
		document.write("<span id=\"scoreSpan\">");
		if (filteredResults == null) {
			document.write(model[document.all.modelSelect.selectedIndex].segments[document.all.segmentSelect.selectedIndex]);
		} else {
			document.write(filteredResults);
		}
		document.writeln("</span>");
		</script>
		</p>
	</form>
<%	} else { %>
	<%= resources.get("dataminingNoData") %>
<% } %>
</body>
</html>
