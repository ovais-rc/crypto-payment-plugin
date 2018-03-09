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

function getDivisionStatus(aSwitch) {
    return (aSwitch == true || aSwitch != 0) ? "block" : "none";
}

function initializeCustomProductSetButtons() {
    // update the remove button
    setButtonContext(document.pricingForm.customProductSetSelections, 
                     document.pricingForm.customProductSetRemoveButton);
}

function getModel() {
    var myCPTC;
    
    // get the scratch price tc previously save 1 step back
    myCPTC = top.getData("scratchPriceTC", 1); 

    if (myCPTC == null) {    
        // alert('Fatal Error: no price model found!');
        return null;
    }
    
    // alert('Got Price TC Model!\n'+dumpObject(myCPTC));

    return myCPTC;
}    
              
function loadSelectValue(select, value) {
    for (var i = 0; i < select.length; i++) {
        if (select.options[i].value == value) {
            select.options[i].selected = true;
            return;
        }
    }
}

function disableOtherRadioValues(radio, value) {
    for (var i = 0; i < radio.length; i++) {
        if (radio[i].value != value) {
           radio[i].disabled = true;
        }
    }
}
 
function loadRadioValue(radio, value) {
    for (var i = 0; i < radio.length; i++) {
        if (radio[i].value == value) {
           radio[i].checked = true;
           return;
        }
    }
}

function getRadioValue(radio) {
    for (var i = 0; i < radio.length; i++) {
        if (radio[i].checked) {
            return radio[i].value;
        }
    }
    return null;
}

function getCheckboxValue(checkbox) {
    if (checkbox.checked) {
       return true;
    }
    return false;
}

function loadCheckboxValue(checkbox, value) {
    if (value == true || value == "1") {
    	checkbox.checked = true;
    }
    else {
    	checkbox.checked = false;
    }
}

function loadMultiSelect(aMultiSelect, someValues) {
    // clear out the multiselect first...
    aMultiSelect.options.length = 0;
    
    for (i=0; i<someValues.length; i++) {   
        // we are only going to create options for catgroup/entries which have not be "DELETED"
        if (someValues[i].type == "CG" || someValues[i].type == "CE") {
            aMultiSelect.options[aMultiSelect.options.length] = new Option(someValues[i].displayText, // label
                                                                           someValues[i].refnum,      // value
                                                                           false,
                                                                           false);
        }
    }
}

function removeFromMultiSelect(aMultiSelect, aButton, aSelectionArray) {
    var noneSelected = true;
  
    for(var i=aMultiSelect.options.length-1; i>=0; i--) {
       if(aMultiSelect.options[i].selected && aMultiSelect.options[i].value != "") {
          // remove the entry from the global catgroup/catentry selection array.  these
          // are the ones that are eventually persisted in the model.  the selection boxes
          // must be synched with the model.
          // we are going to try to delete the catgroup/catentry by looking up its refnum in the array.
          removeFromSelectionArray(aSelectionArray, aMultiSelect.options[i].value); 
        
          // now remove the entry from the select box
          aMultiSelect.options[i] = null;  // remove the selection from the list
          noneSelected = false;
       }
    }
    if (noneSelected) {
        alertDialog(getNoSelectionErrorMsg());
    }
     
    // update the remove button context for the multiselect box
    setButtonContext(aMultiSelect, aButton);
}

function removeFromSelectionArray(aSelectionArray, aKey) {
    for (var i=0;i<aSelectionArray.length;i++) {
        // alert('trying key='+aKey+' on: '+aSelectionArray[i].refnum);
        if (aSelectionArray[i].refnum == aKey) {
           // alert('deleting key='+aKey+' at position='+i);
           // flag the entry as deleted... it will remain in the array.
           // during XML generation, these entries will be ignored.
           aSelectionArray[i].displayText = "DELETED";  
           aSelectionArray[i].refnum = "DELETED";  
           aSelectionArray[i].type = "DELETED";
           break;
        }
    }
}

function getSignedAdjustment(adjustment, sign, lang) {
    var signedAdjustment = parent.strToNumber(adjustment, lang);
    var signValue = sign.options[sign.selectedIndex].value;
    
    if (signValue == "markup") {
        signedAdjustment = '+' + signedAdjustment;
    }
    else if (signValue == "markdown") {
        signedAdjustment = '-' + signedAdjustment;
    }    
    return signedAdjustment;
}

function loadSignedAdjustment(adjustment,sign) {
    if (adjustment > 0) { 
        // this is a markup
        sign.options[1].selected = true;
    }
    else {
        // this is a markdown
        sign.options[0].selected = true;
    }
}

function hasMasterCatalogPriceTC(cpm) {
   for (i=0; i<cpm.priceTC.length; i++) {
    if (cpm.priceTC[i].markedForDelete == false && cpm.priceTC[i].percentagePricingRadio == "masterPriceTC")
        return true;
   }
   return false;
}

function hasPriceTC(cpm) {
   for (i=0; i<cpm.priceTC.length; i++) {
    if (cpm.priceTC[i].markedForDelete == false)
        return true;
   }
   return false;
}

function isCategoryAlreadyInContract(cpm, policyId) {
   // check to see is a standard price TC is already in the contract.
   // we only want to show categories in the slosh buckets which have not been used already...
   for (i=0; i<cpm.priceTC.length; i++) {
    if (cpm.priceTC[i].markedForDelete == false && 
        cpm.priceTC[i].percentagePricingRadio == "standardPriceTC" &&
        cpm.priceTC[i].adjustmentOnStandardProductSetPolicyId == policyId) {
        return true;
    }
   }
   return false;
}

function addAction()
 {
  self.CONTENTS.addAction()
 }

function cancelAction()
 {
  self.CONTENTS.cancelAction()
 }

function changeAction()
 {
  self.CONTENTS.changeAction()
 }

