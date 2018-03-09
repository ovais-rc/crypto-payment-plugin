<!-- ========================================================================
 Licensed Materials - Property of IBM

 WebSphere Commerce

 (c) Copyright IBM Corp. 2000, 2002

US Government Users Restricted Rights - Use, duplication or
disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
===========================================================================-->
<%@page import=	"com.ibm.commerce.tools.test.*, 
			com.ibm.commerce.tools.util.*, 
			com.ibm.commerce.negotiation.beans.*, 
			com.ibm.commerce.command.*, 
			com.ibm.commerce.common.objects.*,
			com.ibm.commerce.price.utils.*, 
			com.ibm.commerce.negotiation.misc.*,
			com.ibm.commerce.negotiation.operation.*,
			com.ibm.commerce.negotiation.util.*" %>

<%@include file="../common/common.jsp" %>

<HTML>
<HEAD>

<%
	String selectedRuleType = (String)request.getParameter("ruletype");

      //*** GET LANGID,LOCALE AND STOREID FROM COMANDCONTEXT ***//
      CommandContext aCommandContext = (CommandContext)request.getAttribute("CommandContext");    
 	String   StoreId = "0";
	String   lang =  "-1";  
	Locale   locale = null;
      if( aCommandContext!= null ){
            lang = aCommandContext.getLanguageId().toString();
            locale = aCommandContext.getLocale();
            StoreId = aCommandContext.getStoreId().toString();
      }
	if (locale == null)
		locale = new Locale("en","US");

	StoreAccessBean storeAB = com.ibm.commerce.registry.StoreRegistry.singleton().find(new Integer(StoreId));

	//*** GET CURRENCY ***//     
	CurrencyManager cm = CurrencyManager.getInstance();
	Integer defaultLanguageId = new Integer(Integer.parseInt(lang));
	String defaultCurrency = cm.getDefaultCurrency(storeAB, defaultLanguageId);

	//*** GET THE RESOURCE BUNDLE BASED ON LOCALE ***//
	Hashtable neg_properties = (Hashtable)ResourceDirectory.lookup("negotiations.negotiationsNLS",locale);
%>

<link rel="stylesheet" href="<%= UIUtil.getCSSFile(locale) %>" type="text/css">

<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
<%@include file="../common/NumberFormat.jsp" %>
<SCRIPT>
var msgInvalidInteger		= '<%= UIUtil.toJavaScript((String)neg_properties.get("msgInvalidInteger")) %>';
var msgMandatoryField 		= '<%= UIUtil.toJavaScript((String)neg_properties.get("msgMandatoryField")) %>';
var msgInvalidNumber 		= '<%= UIUtil.toJavaScript((String)neg_properties.get("msgInvalidNumber")) %>';
var msgNegativeNumber 		= '<%= UIUtil.toJavaScript((String)neg_properties.get("msgNegativeNumber")) %>';
var msgInvalidCurrency 		= '<%= UIUtil.toJavaScript((String)neg_properties.get("msgInvalidCurrency")) %>';
var msgInvalidValueRanges 	= '<%= UIUtil.toJavaScript((String)neg_properties.get("msgInvalidValueRanges")) %>';
var msgInvalidValueIncrement 	= '<%= UIUtil.toJavaScript((String)neg_properties.get("msgInvalidValueIncrement")) %>';
var msgConflictingRange 	= '<%= UIUtil.toJavaScript((String)neg_properties.get("msgConflictingRange")) %>';
var ds_minval 			= '<%= UIUtil.toJavaScript((String)neg_properties.get("MinBidAmount")) %>';
var ds_minqty   			= '<%= UIUtil.toJavaScript((String)neg_properties.get("MinBidQty")) %>';
var ds_valrange 			= '<%= UIUtil.toJavaScript((String)neg_properties.get("ValRange")) %>';
var ds_valincr 			= '<%= UIUtil.toJavaScript((String)neg_properties.get("ValIncr")) %>';

var ValueCount	= 0;
var ValueRange1	= new MakeArray(0);
var ValueRange2	= new MakeArray(0);
var ValueIncr	= new MakeArray(0);        
var selectedType	= parent.get("ruletype","O");

function MakeArray(n) {
	this.length = n
	return this
}

function initializeState(){
	var code = parent.getErrorParams();
	if (code == "minvalError")
		alertDialog(ds_minval + ":" + msgInvalidCurrency);
	else if (code == "minvalNegative")
		alertDialog(ds_minval + ":" + msgNegativeNumber);
	else if (code == "minquantError")
		alertDialog(ds_minqty + ":" + msgInvalidInteger);
	else if (code == "minquantNegative")
		alertDialog(ds_minqty + ":" + msgNegativeNumber);
	parent.setContentFrameLoaded(true);
}

function savePanelData(){
	var form = document.bidruleForm;  	
  	for (i=0;i<form.elements.length;i++) {
		var elem = form.elements[i];
		if (elem.name == "minvalue"){ 
			parent.put("minvalue_ds",elem.value);
		}
		else if (elem.name == "minquant") {
			parent.put("minquant_ds",elem.value);
		}
	} // end for

	if (parent.get("ruletype") == "<%= AuctionConstants.EC_AUCTION_OPEN_CRY_TYPE %>") 
	{		
		var ruletext = "";
		if (form.ValueVector.length == 1 && form.ValueVector.options[0].value == "0,0,0;"){
			parent.put("ruletext","");
			parent.put("VVLength","0");
		}
		else {
			parent.put("VVLength",form.ValueVector.length);
			for(i=0;i<form.ValueVector.length;i++){
			   parent.put("ValueVectorText" + i,form.ValueVector.options[i].text);
			   parent.put("ValueVectorValue" + i,form.ValueVector.options[i].value);
			   ruletext += ValueRange1[i] + "," + ValueRange2[i] + "," + ValueIncr[i] + ";" ;
			}

			parent.put("ruletext",ruletext);
		}
   	}
	parent.put("currency","<%=defaultCurrency %>");
	parent.put("lang","<%= lang %>");
}


function retrievePanelData(){
	var form = document.bidruleForm;

  	for (i=0;i<form.elements.length;i++) {
		var elem = form.elements[i];
		if (elem.name == "minvalue")
			elem.value = parent.get("minvalue_ds","");
		else if (elem.name == "minquant")
			elem.value = parent.get("minquant_ds","");
  	}// end for


	if (parent.get("ruletype") == "<%= AuctionConstants.EC_AUCTION_OPEN_CRY_TYPE %>") 
	{		
		ValueCount = 0;		
		var VVLength = parent.get("VVLength","0");
		for (i=0;i<VVLength;i++) {
       		var text = parent.get("ValueVectorText" + i);
       		var value = parent.get("ValueVectorValue" + i);
			value = (value.toString()).substring(0,value.length - 1);
			var splitArray = value.toString().split(",");
			ValueRange1[i] = splitArray[0];
			ValueRange2[i] = splitArray[1];
			ValueIncr[i]   = splitArray[2];
			ValueCount++;
	       	form.ValueVector.options[form.ValueVector.length] = new Option(text,value);
      	 	form.ValueVector.selectedIndex = form.ValueVector.length -1 ;
        	}
	  	if (VVLength == "0"){
       		var text = padBlanks(" ",50);
       		var value = "0,0,0;";
	       	form.ValueVector.options[0] = new Option(text,value);
      	 	form.ValueVector.selectedIndex = form.ValueVector.length -1 ;
	  	}	
	} 
}



function AddValueVector() {    
	var form = document.bidruleForm;

      if ( isInputStringEmpty(form.ValRange1.value) ) {
         reprompt(form.ValRange1, msgMandatoryField)
         return false
      }

      if ( isInputStringEmpty(form.ValRange2.value) ) {
         reprompt(form.ValRange2, msgMandatoryField)
         return false
      }

      if ( isInputStringEmpty(form.ValIncr.value) ) {
        reprompt(form.ValIncr, msgMandatoryField)
        return false
      }

	var t_range1 = form.ValRange1.value;
	var t_range2 = form.ValRange2.value;
	var t_incr   = form.ValIncr.value;

	if (!isValidCurrency(t_range1,"<%= defaultCurrency %>","<%= lang %>")){
     		reprompt(form.ValRange1, msgInvalidValueRanges)
	      return false  
     	}
	if (t_range1.charAt(0) == "-"){
     	     reprompt(form.ValRange1, msgNegativeNumber)
	     return false  
     	}

	if (!isValidCurrency(t_range2,"<%= defaultCurrency %>","<%= lang %>")){
     		reprompt(form.ValRange2, msgInvalidValueRanges)
	      return false  
     	}
	if (t_range2.charAt(0) == "-"){
     	     reprompt(form.ValRange2, msgNegativeNumber)
	     return false  
     	}

	if (!isValidCurrency(t_incr,"<%= defaultCurrency %>","<%= lang %>")){
     		reprompt(form.ValIncr, msgInvalidValueIncrement)
	      return false  
     	}
	if (t_incr.charAt(0) == "-"){
     	     reprompt(form.ValIncr, msgNegativeNumber)
	     return false  
     	}

	range1 = currencyToNumber(t_range1, "<%= defaultCurrency %>","<%= lang %>");
	range2 = currencyToNumber(t_range2, "<%= defaultCurrency %>","<%= lang %>");
	incr   = currencyToNumber(t_incr, "<%= defaultCurrency %>","<%= lang %>");  

	// if the two ranges are equal, do not permit addition
	if (!(range2>range1 || range1 > range2)) {
		reprompt(form.ValRange1, msgInvalidValueRanges)
	      return false  
     	}

	if (!(incr > 0)) {
		reprompt(form.ValIncr, msgInvalidValueIncrement)
	      return false  
     	}

	// Swap the ranges, if necessary
      if (range2 < range1) {
	     // Swap formatted ranges
           var rtemp = t_range2
           t_range2  = t_range1
           t_range1  = rtemp

	     // Swap non-formatted ranges
		rtemp  = range2;
		range2 = range1;
		range1 = rtemp;

	     // Change the form field values.
           form.ValRange1.value  = t_range1
           form.ValRange2.value  = t_range2
      } 
  
      var temptext = t_range1 + " - " + t_range2  + " = " +  t_incr
	var tempvalue = range1 + "," + range2 + "," + incr + ";";
  
      for ( var i = 0 ; i < form.ValueVector.length  ; ++i) {
         if (form.ValueVector.options[i].value == tempvalue)
            break;
      }

       //If not found in the current list then add 
       if ( i == form.ValueVector.length )  
       {
            //  Check for range overlaps and conflict ranges 
            //  We have ranges defined like this :
            //  R1 <= x <= R2  
            // 
            // If NR1 and NR2 are the ranges to be added then 
            // The following are conflict situations :
            //  NR2 = R2
            //  NR1 > R1  &&  NR1 < R2  
            //  NR2 > R1  &&  NR2 < R2
            //  NR1 <= R1  &&  NR2 > R2
            //  

          for ( var j = 0 ; j < ValueCount ; ++ j ) {                    
         	   if ( range2 == ValueRange2[j]  || 
                    (range1 > ValueRange1[j] && range1 < ValueRange2[j]) ||
                    (range2 > ValueRange1[j] && range2 < ValueRange2[j]) ||
                    (range1 <= ValueRange1[j] && range2 > ValueRange2[j]) )
                  {
			   reprompt(form.ValRange1, msgConflictingRange)
                     return false
                  }
           } 

		   if (form.ValueVector.length > 0 && form.ValueVector.options[0].value == "0,0,0;"){
			 form.ValueVector.options[0] = null;
			 ValueCount = 0;
		   }
				
               ValueCount = ValueCount + 1 ;
               ValueRange1[ValueCount - 1] = range1;
               ValueRange2[ValueCount - 1] = range2;
		   ValueIncr[ValueCount - 1] = incr;

		     // add the range to the value vector
		        form.ValueVector.options[form.ValueVector.length] = new Option (padBlanks(temptext,50), tempvalue);
			  form.ValueVector.selectedIndex = form.ValueVector.length -1 ;
			  form.ValRange1.value="";
			  form.ValRange2.value="";
			  form.ValIncr.value="";
            }
         return true
}
function DeleteValueVector() {
	var form = document.bidruleForm;

	  if (form.ValueVector.length == 0)
		return;

         i =  form.ValueVector.selectedIndex;
         form.ValueVector.options[form.ValueVector.selectedIndex] = null;
         // Delete the entry from the Vector Arrays
         for (var j = i ; j < ValueCount - 1 ; ++j)  
         {
            ValueRange1[j] = ValueRange1[j+1];
            ValueRange2[j] = ValueRange2[j+1];
            ValueIncr[j] = ValueIncr[j+1];
         } 

         ValueCount = ValueCount -1 ;

         if ( i > 0 ) {
            form.ValueVector.selectedIndex = i-1;
            onSelChangeValue(form);
         }
         else if ( i == 0 && form.ValueVector.length > 0 )
         {
            form.ValueVector.selectedIndex = 0;
            onSelChangeValue(form);
         }
         else
         {
         form.ValRange1.value  = ""; 
         form.ValRange2.value  = "";
         form.ValIncr.value  =  "";
         }       
}


function onSelChangeValue() {
	// we have elements in the format 'R1 - R2 = I1'
	var form = document.bidruleForm;
	var temptext = trim(form.ValueVector.options[form.ValueVector.selectedIndex].text);
	arrayofstring = temptext.split(" ") 
	form.ValRange1.value  = arrayofstring[0]; 
	form.ValRange2.value  = arrayofstring[2]; 
	form.ValIncr.value  = arrayofstring[4];      
}
 
function ClearValueVector(){
	var form = document.bidruleForm;
	var length = form.ValueVector.length
	for ( var i = length -1  ; i >= 0 ; --i)
		form.ValueVector.options[i]  = null;
	ValueCount = 0;                                        
}

function padBlanks(str,len) {
	if (str.length >= len)
		return str;
	var ret_str = str;
	for(i=str.length;i<len;i++) 
		ret_str += " ";
	return ret_str;
}

</SCRIPT>
</HEAD>

<BODY class=content ONLOAD="initializeState();">
<BR><h1><%= neg_properties.get("BRuleRule") %></h1>


<FORM NAME="bidruleForm" id="bidruleForm">
<TABLE id="WC_N_BidruleRule_Table_1">
	<TR>
	<TD id="WC_N_BidruleRule_TableCell_1">
		<Label for="WC_N_BidruleRule_minvalue_In_bidruleForm">
		<%= neg_properties.get("MinBidAmount") %> 
		</Label><BR>
      	<INPUT size="10" type="input" name="minvalue" maxlength="14" id="WC_N_BidruleRule_minvalue_In_bidruleForm">
		
	</TD>
	</TR>
	<TR>
	<TD id="WC_N_BidruleRule_TableCell_2">
		<Label for="WC_N_BidruleRule_minquant_In_bidruleForm">
		<%= neg_properties.get("MinBidQty") %>
		</Label><BR>
      	<INPUT size="10" type="input" name="minquant" maxlength="9" id="WC_N_BidruleRule_minquant_In_bidruleForm">
		
	</TD>
	</TR>

<% 	if (selectedRuleType.equals(AuctionConstants.EC_AUCTION_OPEN_CRY_TYPE)) {
%>

            <TR>
		<TD id="WC_N_BidruleRule_TableCell_3"><%= neg_properties.get("ValRange") %><BR>
		<Label for="WC_N_BidruleRule_ValRange1_In_bidruleForm">
		</Label>
		<INPUT TYPE="text" NAME="ValRange1" SIZE="10" MAXLENGTH="16" id="WC_N_BidruleRule_ValRange1_In_bidruleForm"> - 
		<Label for="WC_N_BidruleRule_ValRange2_In_bidruleForm">
		</Label>
		<INPUT TYPE="text" NAME="ValRange2" SIZE="10" MAXLENGTH="16" id="WC_N_BidruleRule_ValRange2_In_bidruleForm">
 	      </TD>

		<TD id="WC_N_BidruleRule_TableCell_4">
		<Label for="WC_N_BidruleRule_ValIncr_In_bidruleForm">
		<%= neg_properties.get("ValIncr") %>
		</Label><BR>
		<INPUT TYPE="text" NAME="ValIncr" SIZE=10 MAXLENGTH="16" id="WC_N_BidruleRule_ValIncr_In_bidruleForm">
		
	      </TD>
            </TR>

            <TR>
            <TD id="WC_N_BidruleRule_TableCell_5">
            <Label for="WC_N_BidruleRule_ValueVector_In_bidruleForm">
            </Label>
            <SELECT name="ValueVector"  size=5 width=50 onChange="onSelChangeValue()" id="WC_N_BidruleRule_ValueVector_In_bidruleForm">
            </SELECT>
            </TD>

            <TD COLSPAN=6 id="WC_N_BidruleRule_TableCell_6">
            <INPUT TYPE=BUTTON NAME="AddButton" VALUE="<%= neg_properties.get("AddButton") %>" onClick="AddValueVector()" style="width:100" id="WC_N_BidruleRule_AddButton_In_bidruleForm"> <BR>
            <INPUT TYPE=BUTTON NAME="DeleteButton" VALUE="<%= neg_properties.get("remove") %>" onClick="DeleteValueVector()" style="width:100" id="WC_N_BidruleRule_DeleteButton_In_bidruleForm"> <BR>
            <!--INPUT TYPE=BUTTON NAME="ClearButton" VALUE=" Clear " onClick="ClearValueVector()"--> <BR>
            </TD>
            </TR>

<%}%>
</TABLE>
</FORM>


<SCRIPT LANGUAGE="Javascript">
	retrievePanelData();
</SCRIPT>
</BODY>
</HTML>


