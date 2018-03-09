<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2002, 2016 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 TRANSITIONAL//EN">
<%
//---------------------------------------------------------------------
//- Import and Include Section
//---------------------------------------------------------------------
%>
<%@ page language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="com.ibm.commerce.tools.util.ResourceDirectory" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.beans.DataBeanManager" %>
<%@ page import="com.ibm.commerce.common.objects.StoreAccessBean" %>
<%@ page import="com.ibm.commerce.common.objects.LanguageDescriptionAccessBean"%>
<%@ page import="com.ibm.commerce.tools.util.UIUtil" %>
<%@ page import="com.ibm.commerce.catalog.beans.*" %>
<%@ page import="com.ibm.commerce.catalog.objects.*" %>

<%@ include file="../common/common.jsp" %>


<%
	CommandContext cmdContext = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
	Hashtable rbProduct = (Hashtable)ResourceDirectory.lookup("catalog.ProductNLS", cmdContext.getLocale());
	String catentryID  = request.getParameter("catentryID"); 
	Integer defaultLanguageId = cmdContext.getStore().getLanguageIdInEntityType();
	Integer preferredLanguageId = cmdContext.getPreferredLanguage();
	Integer [] iLanguages = cmdContext.getStore().getSupportedLanguageIds();
	
	for (int i=1; i<iLanguages.length; i++)
	{
		// Switch default language to the 0 index
		if (iLanguages[i].intValue() == defaultLanguageId.intValue())
		{
			Integer iZero = iLanguages[0];
			iLanguages[0] = iLanguages[i];
			iLanguages[i] = iZero;
		}
	}
%>

<HTML>
<HEAD>

<LINK rel=stylesheet href="<%= UIUtil.getCSSFile(cmdContext.getLocale()) %>" type="text/css">
<TITLE><%=UIUtil.toHTML((String)rbProduct.get("descriptiveAttributeDialog_Content"))%></TITLE>

<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/common/ConvertToXML.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/catalog/DescriptiveCommonFunctions.js"></SCRIPT>

<SCRIPT>

	var iLanguages = new Array();
	var attributes = new Array();
	defaultLanguage = <%=defaultLanguageId%>;
	var preferredLanguage = '<%=UIUtil.toJavaScript(preferredLanguageId.toString())%>';

<%
	for (int iLang=0; iLang<iLanguages.length; iLang++)
	{
		Integer iLanguage = iLanguages[iLang];
%>
		iLanguages[<%=iLang%>] = "<%=iLanguage%>";
<%

		AttributeAccessBean arabAttributes = new AttributeAccessBean();
		Enumeration e1 = arabAttributes.findByProduct(new Long(catentryID), iLanguage);
		while (e1.hasMoreElements())
		{
			arabAttributes = (AttributeAccessBean) e1.nextElement();
			String strRefNo = arabAttributes.getAttributeReferenceNumber();
			if (arabAttributes.getUsage() == null || arabAttributes.getUsage().equals("") || arabAttributes.getUsage().equals("1")) {
				continue;
			}
%>
			if (!attributes["<%=strRefNo%>"]) attributes["<%=strRefNo%>"] = new Array();
			if (!attributes["<%=strRefNo%>"]["<%=iLanguage%>"]) attributes["<%=strRefNo%>"]["<%=iLanguage%>"] = new Object();
	
			attributes["<%=strRefNo%>"]["<%=iLanguage%>"] = new Object();
			attributes["<%=strRefNo%>"]["<%=iLanguage%>"].ID        = "<%=strRefNo%>";
			attributes["<%=strRefNo%>"]["<%=iLanguage%>"].name      = "<%=UIUtil.toJavaScript(arabAttributes.getName())%>";
			attributes["<%=strRefNo%>"]["<%=iLanguage%>"].type      = "<%=UIUtil.toJavaScript(arabAttributes.getAttributeType())%>";
			attributes["<%=strRefNo%>"]["<%=iLanguage%>"].usage     = "<%=UIUtil.toJavaScript(arabAttributes.getUsage())%>";
			attributes["<%=strRefNo%>"]["<%=iLanguage%>"].desc      = "<%=UIUtil.toJavaScript(arabAttributes.getDescription())%>";
			attributes["<%=strRefNo%>"]["<%=iLanguage%>"].desc2     = "<%=UIUtil.toJavaScript(arabAttributes.getDescription2())%>";
			attributes["<%=strRefNo%>"]["<%=iLanguage%>"].sequence  = top.numberToStr(<%=arabAttributes.getSequenceNumber()%>,preferredLanguage);
			attributes["<%=strRefNo%>"]["<%=iLanguage%>"].field1    = "<%=UIUtil.toJavaScript(arabAttributes.getField1())%>";
			attributes["<%=strRefNo%>"]["<%=iLanguage%>"].status    = "UPDATE";
<%
		   // Get the attribute value
			try 
			{
%>
				attributes["<%=strRefNo%>"]["<%=iLanguage%>"].valueArray = new Array();
<%
				int iCounter = 0;
				AttributeValueAccessBean abValue = new AttributeValueAccessBean();
				Enumeration eValues = abValue.findByAttributeIdAndLanguageIdAndCatEntryId(arabAttributes.getAttributeReferenceNumberInEntityType(), arabAttributes.getLanguage_idInEntityType(), new Long(catentryID));
				while (eValues.hasMoreElements()) 
				{
					abValue = (AttributeValueAccessBean) eValues.nextElement();
%>
					attributes["<%=strRefNo%>"]["<%=iLanguage%>"].valueArray[<%=iCounter%>] = new Object();
					attributes["<%=strRefNo%>"]["<%=iLanguage%>"].valueArray[<%=iCounter%>].valueID  = "<%=abValue.getAttributeValueReferenceNumber()%>"; 
					
					<% if (abValue.getAttributeValue()!= null) {%>
						attributes["<%=strRefNo%>"]["<%=iLanguage%>"].valueArray[<%=iCounter%>].value    = "<%=UIUtil.toJavaScript(abValue.getAttributeValue().toString())%>";
					<% } else { %>
						attributes["<%=strRefNo%>"]["<%=iLanguage%>"].valueArray[<%=iCounter%>].value    = "";
					<% } %>
                                        if (attributes["<%=strRefNo%>"]["<%=iLanguage%>"].type == "FLOAT" | attributes["<%=strRefNo%>"]["<%=iLanguage%>"].type == "INTEGER" )
                                        {
                                        	attributes["<%=strRefNo%>"]["<%=iLanguage%>"].valueArray[<%=iCounter%>].value = 
                                        		top.numberToStr(attributes["<%=strRefNo%>"]["<%=iLanguage%>"].valueArray[<%=iCounter%>].value,preferredLanguage);
                                        }
					attributes["<%=strRefNo%>"]["<%=iLanguage%>"].valueArray[<%=iCounter%>].image1   = "<%=UIUtil.toJavaScript(abValue.getImage1())%>";
<%
					iCounter++;
				}
			} catch (Exception ex) {
%>
				attributes["<%=strRefNo%>"]["<%=iLanguage%>"].valueArray[0] = new Object();
				attributes["<%=strRefNo%>"]["<%=iLanguage%>"].valueArray[0].valueID  = "-1"; 
				attributes["<%=strRefNo%>"]["<%=iLanguage%>"].valueArray[0].value    = "";
				attributes["<%=strRefNo%>"]["<%=iLanguage%>"].valueArray[0].image1    = "";
<%
			}
		}
	}

%>


	function getCatentryID()
	{
		return "<%=UIUtil.toJavaScript(catentryID)%>";
	}

	function getAttributeID()
	{
		for (var i=1; i<dTable[0].rows.length; i++)
		{
			if (dTable[0].rows(i).cells(0).firstChild.checked) 
			{
				return dTable[0].rows(i).attributeID;
			}
		}
		return null;
	}

	function addEmptyLanguageInformation(id, iLang)
	{
		attributes[id][iLang] = new Object();
		attributes[id][iLang].ID        = "-1";
		attributes[id][iLang].name      = "";
		attributes[id][iLang].type      = attributes[id]["<%=defaultLanguageId%>"].type;
		attributes[id][iLang].usage     = attributes[id]["<%=defaultLanguageId%>"].usage;
		attributes[id][iLang].desc      = "";
		attributes[id][iLang].desc2     = "";
		attributes[id][iLang].sequence  = attributes[id]["<%=defaultLanguageId%>"].sequence;
		attributes[id][iLang].field1    = "";
		attributes[id][iLang].valueArray = new Array();
		attributes[id][iLang].valueArray[0] = new Object();
		attributes[id][iLang].valueArray[0].valueID   = "-1"; 
		attributes[id][iLang].valueArray[0].value     = "";
		attributes[id][iLang].valueArray[0].image1    = "";
		attributes[id][iLang].status    = "ADD";
	}

	function generateGeneralDiv(iLang)
	{
		var cellString = "";

		for (i in attributes) 
		{
			if (!attributes[i][iLang]) addEmptyLanguageInformation(i, iLang);
			document.writeln('<TR CLASS=dtable attributeID='+i+' ONCLICK=selectSingleRow(this)>');
			cellString = "";
			cellString += createCellString("CHECKBOX",  "ROWHEAD",       "",                            "ONCLICK=selectRow(this)");
                        cellString += createCellString("HREF",       "dtable",       attributes[i]["<%=defaultLanguageId%>"].name, null, null, "javascript:parent.buttonFrame.buttonChange()", 'attribute_reference');
			cellString += createCellString("INPUT",     "dtable",        attributes[i][iLang].name,     "ONCHANGE=fcnNameOnChange() ONKEYUP=cellOnKeyPress() ONKEYDOWN=cellOnKeyDown()", 'attribute_name');
			if (attributes[i][iLang].type == "STRING")  cellString += createCellString("STRING",    "dtablecenter",  "<%=UIUtil.toJavaScript((String)rbProduct.get("attribute_string_value"))%>", 'attribute_type'); 
			if (attributes[i][iLang].type == "INTEGER") cellString += createCellString("STRING",    "dtablecenter",  "<%=UIUtil.toJavaScript((String)rbProduct.get("attribute_integer_value"))%>", 'attribute_type'); 
			if (attributes[i][iLang].type == "FLOAT")   cellString += createCellString("STRING",    "dtablecenter",  "<%=UIUtil.toJavaScript((String)rbProduct.get("attribute_float_value"))%>", 'attribute_type'); 
			cellString += createCellString("SELECT",     "dtable",       attributes[i][iLang].valueArray, "ONKEYDOWN=cellOnKeyDown()", "value", 'attribute_values');
			cellString += createCellString("INPUT",     "dtable",        attributes[i][iLang].desc,     "ONKEYDOWN=cellOnKeyDown()", 'attribute_description');
			cellString += createCellString("INPUT",     "dtableright",   attributes[i][iLang].sequence, "ONKEYDOWN=cellOnKeyDown()", 'attribute_sequence');
			cellString += createCellString("INPUT",     "dtablecenter",  attributes[i][iLang].usage,    "ONKEYDOWN=cellOnKeyDown() MAXLENGTH=1", 'attribute_usage');
			cellString += createCellString("SELECT",    "dtable",        attributes[i][iLang].valueArray, "ONKEYDOWN=cellOnKeyDown()", "image1", 'attribute_image');
			cellString += createCellString("INPUT",     "dtable",        attributes[i][iLang].field1,   "ONKEYDOWN=cellOnKeyDown()", 'attribute_field1');
			document.writeln(cellString);
			document.writeln("</TR>");
		}
		
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// isValidNumericValue(value, language, minValue, maxValue)
	//
	// - determine if the value is valid
	//////////////////////////////////////////////////////////////////////////////////////
	function isValidNumericValue(value, language, minValue, maxValue)
	{
		if (top.isValidNumber(value, language, false) == false) { alertDialog("<%= UIUtil.toJavaScript((String)rbProduct.get("ProductUpdateValidation_InvalidNumber")) %>"); return false; }
		if ((minValue && value < minValue) || (maxValue && value > maxValue)) { alertDialog("<%= UIUtil.toJavaScript((String)rbProduct.get("ProductUpdateValidation_OutsideRange")) %>"); return false; }
		return true;
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// isValidIntegerValue(value, language, minValue, maxValue)
	//
	// - determine if the value is valid
	//////////////////////////////////////////////////////////////////////////////////////
	function isValidIntegerValue(value, language, minValue, maxValue)
	{
		if (top.isValidInteger(value, language) == false) { alertDialog("<%= UIUtil.toJavaScript((String)rbProduct.get("ProductUpdateValidation_InvalidInteger")) %>"); return false; }
		if ((minValue && value < minValue) || (maxValue && value > maxValue)) { alertDialog("<%= UIUtil.toJavaScript((String)rbProduct.get("ProductUpdateValidation_OutsideRange")) %>"); return false; }
		return true;
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// isValidStringValue(value, length, nullableTF, specialTF)
	//
	// - determine if the value is valid
	//////////////////////////////////////////////////////////////////////////////////////
	function isValidStringValue(value, length, nullableTF, nameTF)
	{
		if (isValidUTF8length(value, length) == false) { alertDialog("<%= UIUtil.toJavaScript((String)rbProduct.get("fieldSizeExceeded"))%>"); return false; }
		if (nullableTF == false && (value == null || isInputStringEmpty(value) == true)) { alertDialog("<%= UIUtil.toJavaScript((String)rbProduct.get("ProductUpdateValidation_EmptyRequiredField"))%>"); return false; }
		if (nameTF == true && isValidName(value) == false) { alertDialog("<%= UIUtil.toJavaScript((String)rbProduct.get("productNameNotValidMessage"))%>"); return false; }
		return true;
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// createAttributeXML(index, i, iLang)
	//
	// - creates and returns a string which represents the attribute changes
	//////////////////////////////////////////////////////////////////////////////////////
	function createAttributeXML(index, i, iLang)
	{
		var value;
		var chgString = "";

		var ID_REFERENCE   = 1;
		var ID_NAME        = 2;
		var ID_TYPE        = 3;
		var ID_VALUE       = 4;
		var ID_DESCRIPTION = 5;
		var ID_SEQUENCE    = 6;
		var ID_USAGE       = 7;
		var ID_FIELD1      = 9;

		value = dTable[iLang].rows(index).cells(ID_NAME).firstChild.value;
		if (attributes[i][iLanguages[iLang]].name != value) 
		{
			if (attributes[i][iLanguages[iLang]].ID != "-1") if (isValidStringValue(value, 254, false, false) == false) return failTableEntry(iLang, index, ID_NAME);
			else                                             if (isValidStringValue(value, 254, true, false)  == false) return failTableEntry(iLang, index, ID_NAME);
			chgString += ' name="' + replaceSpecialChars(value) + '"';
		}

		value = dTable[iLang].rows(index).cells(ID_DESCRIPTION).firstChild.value;
		if (attributes[i][iLanguages[iLang]].desc != value) 
		{
			if (isValidStringValue(value, 254, true, false) == false) return failTableEntry(iLang, index, ID_DESCRIPTION);
			chgString += ' desc="' + replaceSpecialChars(value) + '"';
		}

		value = dTable[iLang].rows(index).cells(ID_SEQUENCE).firstChild.value;
		if (attributes[i][iLanguages[iLang]].sequence != value) 
		{
			if (isValidNumericValue(value, preferredLanguage) == false) return failTableEntry(iLang, index, ID_SEQUENCE);
			chgString += ' sequence="' + top.strToNumber(value,preferredLanguage) + '"';
		}

		value = dTable[iLang].rows(index).cells(ID_USAGE).firstChild.value;
		if (attributes[i][iLanguages[iLang]].usage != value) 
		{ 
			if (value == "1") { 
				alertDialog("<%= UIUtil.toJavaScript((String)rbProduct.get("descriptiveAttributeReservedUsage")) %>"); 
				return failTableEntry(iLang, index, ID_USAGE); 
			}
			if (isValidStringValue(value, 1, false, false) == false) return failTableEntry(iLang, index, ID_USAGE);
			chgString += ' usage="' + replaceSpecialChars(value) + '"';
		}

		value = dTable[iLang].rows(index).cells(ID_FIELD1).firstChild.value;
		if (attributes[i][iLanguages[iLang]].field1 != value) 
		{
			if (isValidStringValue(value, 254, true, false) == false) return failTableEntry(iLang, index, ID_FIELD1);
			chgString += ' field1="' + replaceSpecialChars(value) + '"';
		}

		if (chgString != "")
		{
			if (isInputStringEmpty(dTable[iLang].rows(index).cells(ID_NAME).firstChild.value) == true)
			{
				alertDialog("<%= UIUtil.toJavaScript((String)rbProduct.get("descriptiveAttributeNameEmpty")) %>"); 
				return failTableEntry(iLang, index, ID_NAME);
			}

			xmlString += '<Attribute';
			xmlString += ' status="'+attributes[i][iLanguages[iLang]].status+'"';
			xmlString += ' ID="'+i+'"';
			xmlString += ' languageId="'+iLanguages[iLang]+'"';
			if (attributes[i][iLanguages[iLang]].status == "ADD")
			{
				xmlString += ' type="'+attributes[i][iLanguages[iLang]].type+'"';
				xmlString += ' usage="'+attributes[i][iLanguages[iLang]].usage+'"';
			}
			xmlString += chgString + ' />';
		}
		return true;
	}



	//////////////////////////////////////////////////////////////////////////////////////
	// createDeleteAttributeXML(index, i, iLang)
	//
	// - creates and returns a string which represents the attribute deletion
	//////////////////////////////////////////////////////////////////////////////////////
	function createDeleteAttributeXML(index, i, iLang)
	{
		// If the attribute exists then we must delete it
		if (attributes[i][iLanguages[iLang]].ID != "-1") xmlString += '<Attribute status="DELETE" ID="'+i+'" languageId="'+iLanguages[iLang]+'" />';
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// createAttributeValueXML(index, i, iLang)
	//
	// - creates and returns a string which represents the attribute changes
	//////////////////////////////////////////////////////////////////////////////////////
	function createAttributeValueXML(index, i, iLang)
	{
		var chgString = "";

		var ID_NAME  = 2;
		var ID_VALUE = 4;
		var ID_IMAGE = 8;

		var value = dTable[iLang].rows(index).cells(ID_VALUE).firstChild.value;
		if (attributes[i][iLanguages[iLang]].valueArray.length == 1 && attributes[i][iLanguages[iLang]].valueArray[0].value != value) 
		{
			if (attributes[i][iLanguages[iLang]].type == "STRING")
			{
				if (isValidStringValue(value, 254, false, false) == false) return failTableEntry(iLang, index, ID_VALUE);
			} else if (attributes[i][iLanguages[iLang]].type == "INTEGER") {
				if (isValidIntegerValue(value, iLanguages[iLang]) == false) return failTableEntry(iLang, index, ID_VALUE);
			} else if (attributes[i][iLanguages[iLang]].type == "FLOAT") {
				if (isValidNumericValue(value,preferredLanguage) == false) return failTableEntry(iLang, index, ID_VALUE);
			}
			if (attributes[i][iLanguages[iLang]].type == "STRING")
			{			
				chgString += ' value="' + replaceSpecialChars(value) + '"';
			}
			else if (attributes[i][iLanguages[iLang]].type == "INTEGER" || attributes[i][iLanguages[iLang]].type == "FLOAT") 
			{
				chgString += ' value="' + top.strToNumber(value,preferredLanguage) + '"';
			}
		}

		value = dTable[iLang].rows(index).cells(ID_IMAGE).firstChild.value;
		if (attributes[i][iLanguages[iLang]].valueArray.length == 1 && attributes[i][iLanguages[iLang]].valueArray[0].image1 != value) 
		{
			if (isValidStringValue(value, 254, true, false) == false) return failTableEntry(iLang, index, ID_IMAGE);
			chgString += ' image1="' + replaceSpecialChars(value) + '"';
		}

		if (chgString != "")
		{
			if (isInputStringEmpty(dTable[iLang].rows(index).cells(ID_NAME).firstChild.value) == true)
			{
				alertDialog("<%= UIUtil.toJavaScript((String)rbProduct.get("descriptiveAttributeNameEmpty")) %>"); 
				return failTableEntry(iLang, index, ID_NAME);
			}

			xmlString += '<Attrvalue';
			xmlString += ' ID="'+i+'"';
			xmlString += ' valueID="'+attributes[i][preferredLanguage].valueArray[0].valueID+'"';  
			xmlString += ' languageId="'+iLanguages[iLang]+'"';
			xmlString += ' type="'+attributes[i][iLanguages[iLang]].type+'"';
			xmlString += chgString + ' />';
		}

		return true;
	}


	/////////////////////////////////////////////////////////////////////////////////////
	// getCancelConfirmMessage()
	//
	// - get the confirm message for exit the dialog 
	/////////////////////////////////////////////////////////////////////////////////////
	function getCancelConfirmMessage()
	{
		return "<%= UIUtil.toJavaScript((String)rbProduct.get("descriptiveAttributeCancelConfirmation"))%>";
	}



	function onLoad()
	{
		contentFrameLoaded = true;
		parent.parent.setContentFrameLoaded(true);
		displayView();
		colorRows()
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// fcnNameOnChange(iLanguage)
	//
	// - Hilite the names which are not unique
	//////////////////////////////////////////////////////////////////////////////////////
	function fcnNameOnChange(iLanguage)
	{
		if (iLanguage == null) iLanguage = currentLanguageIndex;

		var length = dTable[iLanguage].rows.length;
		var cellValuei, cellValuej;
		var bFlag, bOverallFlag;

		bOverallFlag = false;
		for (var i=1; i<length; i++)
		{
			bFlag = false;
			cellValuei = dTable[iLanguage].rows(i).cells(2).firstChild.value;
			if (cellValuei == null) continue;
			if (cellValuei == "")
			{
				dTable[iLanguage].rows(i).cells(0).style.backgroundColor = "";
				dTable[iLanguage].rows(i).cells(0).title = "";
				continue;
			}

			for (var j=1; j<length; j++)
			{
				cellValuej = dTable[iLanguage].rows(j).cells(2).firstChild.value;
				if (i == j || cellValuej == null || cellValuej == "") continue;

				if (cellValuei == cellValuej)
				{
					bFlag = true;
					bOverallFlag = true;
					dTable[iLanguage].rows(j).cells(0).style.backgroundColor = "RED";
					dTable[iLanguage].rows(j).cells(0).title = "<%= UIUtil.toJavaScript((String)rbProduct.get("descriptiveAttributeUniqueNameTooltip"))%>";
				}
			}

			if (bFlag == true) 
			{
				dTable[iLanguage].rows(i).cells(0).style.backgroundColor = "RED";
				dTable[iLanguage].rows(i).cells(0).title = "<%= UIUtil.toJavaScript((String)rbProduct.get("descriptiveAttributeUniqueNameTooltip"))%>";
			}
			else
			{
				dTable[iLanguage].rows(i).cells(0).style.backgroundColor = "";
				dTable[iLanguage].rows(i).cells(0).title = "";
			}

		}
		return bOverallFlag;
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// validatePanelData()
	//
	// - ok button processing for the entire set of attributes
	//////////////////////////////////////////////////////////////////////////////////////
	function validatePanelData()
	{
		if (anyChanges == false)
		{
			alertDialog("<%= UIUtil.toJavaScript((String)rbProduct.get("descriptiveAttributeNoChangesToSave"))%>");
			return "FAILED";
		}

		var counter = 0;
		xmlString = "";

		for (var iLang=0; iLang<dTable.length-1; iLang++)
		{
			if (fcnNameOnChange(iLang) == true)
			{
				alertDialog("<%= UIUtil.toJavaScript((String)rbProduct.get("msgDescriptiveAttribute_AttributeUpdateDuplicate"))%>");
				return "FAILED";
			}
		}

		for (var i in attributes) 
		{
			counter++;
			for (var iLang=0; iLang<iLanguages.length; iLang++)
			{
				if (dTable[iLang].rows(counter).style.display == "none") 
				{
					createDeleteAttributeXML(counter, i, iLang);
					continue;
				}
				if (createAttributeXML(counter, i, iLang) == false) return "FAILED";
				if (createAttributeValueXML(counter, i, iLang) == false) return "FAILED";
			}
		}

		if (xmlString == "")
		{
			alertDialog("<%= UIUtil.toJavaScript((String)rbProduct.get("descriptiveAttributeNoChangesToSave"))%>");
			return "FAILED";
		}

		var returnString = '<?xml version="1.0" encoding="UTF-8"?><XMLSource>' + xmlString + '</XMLSource>';
		return returnString;
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// selectAll(element)
	//
	// - select/deselect all rows
	//////////////////////////////////////////////////////////////////////////////////////
	function selectAll(element)
	{
		// Loop through all rows and set checked/unchecked
		for (var i=0; i<dTable[0].rows.length; i++) checkRow(i, element.checked)

		// Display the correct buttons
		if (element.checked == true) parent.buttonFrame.displayButtons(dTable[0].rows.length-1);
		else                         parent.buttonFrame.displayButtons(0);
		colorRows();
	}

</SCRIPT>

</HEAD>

<BODY CLASS=content BGCOLOR=WHITE ONLOAD=onLoad() style="background-color:#EFEFEF;">

<%
for (int iLang=0; iLang<iLanguages.length; iLang++)
{
%>
	<DIV ID=generalDiv STYLE="display: none;background-color:#F3F3F3;">
		<SCRIPT>

			var tableString = '';
			tableString += '<TABLE ID=dTable cellpadding=0 cellspacing=0 border=0 width=100% bgcolor=#6D6D7C style="table-layout:fixed; border-bottom: 0px solid #6D6D7C; ">';
			tableString += '<THEAD><TR CLASS=dtableHeading ALIGN=center cellpadding=0 cellspacing=0 >';
			tableString += '<TD CLASS=CORNER TABID=ALL STYLE="width:30px; cursor:default; word-wrap:normal;"><INPUT TYPE=CHECKBOX ID=attributeCheckbox ONCLICK=selectAll(this)></TD>';
			tableString += '<TD CLASS=COLHEADNORMAL TABID=ALL  STYLE="width:150px; cursor:default; word-break: keep-all; word-wrap: break-word; "><label for="attribute_reference"><%=UIUtil.toJavaScript((String)rbProduct.get("attribute_reference"))%></label></TD>';
			tableString += '<TD CLASS=COLHEADNORMAL TABID=ALL  STYLE="width:30%; cursor:default; word-break: keep-all;  word-wrap: normal; "><label for="attribute_name"><%=UIUtil.toJavaScript((String)rbProduct.get("attribute_name"))%></label></TD>';
			tableString += '<TD CLASS=COLHEADNORMAL TABID=0    STYLE="width:100px; cursor:default; word-break: keep-all; word-wrap: break-word; "><label for="attribute_type"><%=UIUtil.toJavaScript((String)rbProduct.get("attribute_type"))%></label></TD>';
			tableString += '<TD CLASS=COLHEADNORMAL TABID=0   STYLE="width:50%; cursor:default; word-break: keep-all;  word-wrap: normal; "><label for="attribute_values"><%=UIUtil.toJavaScript((String)rbProduct.get("attribute_values"))%></label></TD>';
			tableString += '<TD CLASS=COLHEADNORMAL TABID=1   STYLE="width:60%; cursor:default; word-break: keep-all;  word-wrap: normal; "><label for="attribute_description"><%=UIUtil.toJavaScript((String)rbProduct.get("attribute_description"))%></label></TD>';
			tableString += '<TD CLASS=COLHEADNORMAL TABID=1   STYLE="width:90px; cursor:default; word-break: keep-all; word-wrap: break-word; "><label for="attribute_sequence"><%=UIUtil.toJavaScript((String)rbProduct.get("attribute_sequence"))%></label></TD>';
			tableString += '<TD CLASS=COLHEADNORMAL TABID=2   STYLE="width:90px; cursor:default; word-break: keep-all;  word-wrap: break-word; "><label for="attribute_usage"><%=UIUtil.toJavaScript((String)rbProduct.get("attribute_usage"))%></label></TD>';
			tableString += '<TD CLASS=COLHEADNORMAL TABID=2   STYLE="width:30%; cursor:default; word-break: keep-all;  word-wrap: break-word; "><label for="attribute_image"><%=UIUtil.toJavaScript((String)rbProduct.get("attribute_image"))%></label></TD>';
			tableString += '<TD CLASS=COLHEADNORMAL TABID=2   STYLE="width:30%; cursor:default; word-break: keep-all; word-wrap: normal; "><label for="attribute_field1"><%=UIUtil.toJavaScript((String)rbProduct.get("attribute_field1"))%></label></TD>';
			tableString += '</TR></THEAD>';
			document.writeln(tableString);
			generateGeneralDiv(<%=iLanguages[iLang]%>);
			document.writeln("</TABLE>");
			adjustTableBorder(attributes.length);
		</SCRIPT>
	</DIV>
<%
}
%>

<DIV ID=divEmpty STYLE="display: none;">
	<BR><%= UIUtil.toHTML((String)rbProduct.get("descriptiveAttributeNoAttributes"))%>
</DIV>

<DIV id=divToolTip CLASS=TOOLTIP></DIV>

<DIV ID=generalDiv STYLE="display: none;"><TABLE ID=dTable></TABLE></DIV>

<SCRIPT>
	setToolTipDiv(divToolTip);
	displayView();
</SCRIPT>

</BODY>

</HTML>


