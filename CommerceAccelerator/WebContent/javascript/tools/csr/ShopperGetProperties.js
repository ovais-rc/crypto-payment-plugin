//-----------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (C) Copyright IBM Corp. 2009 All Rights Reserved.
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with
// IBM Corp.
//-----------------------------------------------------------------

//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2000, 2002
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
//*


function isEmpty(id) {
	//just added
	//alertDialog("inside isEmpty");
	return !id.match(/[^\s]/);
}
	
function isNumber(word) {
	var numbers="0123456789";
	for (var i=0; i < word.length; i++) {
		if (numbers.indexOf(word.charAt(i)) == -1) 
		return false;
	}
   	return true;
}

function submitFinishHandler(finishMessage) {
	alertDialog(finishMessage);
	top.goBack();
}

function submitCancelHandler() {
	top.goBack();
}

function isValidLength(fieldName, maxLen) {
	if (fieldName != "") {
		if (!isValidUTF8length(fieldName, maxLen)) {
			return false;
		}
	}
	return true;
}

 /*
   -- validateAllPanels(name)
   -- Read data stored in model and validate it
   -- If a frame contains invalid data, call gotoPanel to switch to that panel and display an error msg
   -- Return true if all data is valid
   -- false otherwise
   -- */
 function validateAllPanels() {
	// define error codes
	var mM = "missingMandatoryField";
	var mE1 = "missingEmail1";
	var mE2 = "missingEmail2";
	var mP1 = "missingPhone1";
	var mP2 = "missingPhone2";
	var iNH = "InvalidNumberInHousehold";
	var iCH = "InvalidNumberOfChildren";
	var iFM = "inputFieldMax";
	var iFIE1 = "inputFieldInvalidEmail1";
	var iFIE2 = "inputFieldInvalidEmail2";
	var iFME1 = "inputFieldMaxEmail1";
	var iFME2 = "inputFieldMaxEmail2";

	var profileInfo = get("profileInfo");
	var addressInfo = get("addressInfo");
	var contactInfo = get("contactInfo");
	var demographicsInfo = get("demographicsInfo");
	
	// alertDialog("current panel is " + getCurrentPanelAttribute("name"));
	var currentPanel = getCurrentPanelAttribute("name");

	// Add validation to Profile panel
  
  
   	var mandatoryFieldList = get("mandatoryFieldList");
   	for (var i=0; i < mandatoryFieldList.length; i++) {
      		if (mandatoryFieldList[i] == "last" && isEmpty(profileInfo.lastName)) {
			if (currentPanel != "Profile")
   	  			gotoPanel("Profile", mM + "_lastName");
			else {
				alertDialog(get("missingMandatoryData"));
				self.CONTENTS.document.profile.lastName.focus();	         	
       			}
       			return false;
		}
      		if (mandatoryFieldList[i] == "first" && isEmpty(profileInfo.firstName)) {
  			if (currentPanel != "Profile")
	   	  		gotoPanel("Profile", mM + "_firstName");
			else {
				alertDialog(get("missingMandatoryData"));
				self.CONTENTS.document.profile.firstName.focus();
 			}
			return false;
		}
		if (mandatoryFieldList[i] == "middle" && isEmpty(profileInfo.middleName)) {
			if (currentPanel != "Profile")
	   	  		gotoPanel("Profile", mM + "_middleName");
			else {
				alertDialog(get("missingMandatoryData"));
				self.CONTENTS.document.profile.middleName.focus();
         		}
			return false;
		}
      		if (mandatoryFieldList[i] == "title" && isEmpty(profileInfo.title)) {
			if (currentPanel != "Profile")
	   	  		gotoPanel("Profile", mM + "_title");
			else {
				alertDialog(get("missingMandatoryData"));
				self.CONTENTS.document.profile.title.focus();
		        }
		        return false;
		}
	}
	if (!isValidLength(profileInfo.lastName, 64)) {
		if (currentPanel != "Profile")
			gotoPanel("Profile", iFM + "_lastName");
		else {
			alertDialog(get("inputFieldMax"));
			self.CONTENTS.document.profile.lastName.select();
		}
		return false;
	}
	if (!isValidLength(profileInfo.firstName, 64)) {
		if (currentPanel != "Profile") 
			gotoPanel("Profile", iFM + "_firstName");
		else {
			alertDialog(get("inputFieldMax"));
			self.CONTENTS.document.profile.firstName.select();
		}
		return false;
	}
	if (!isValidLength(profileInfo.middleName, 64)) {
		if (currentPanel != "Profile")
			gotoPanel("Profile", iFM + "_middleName");
		else {
			alertDialog(get("inputFieldMax"));
			self.CONTENTS.document.profile.middleName.select();
		}
		return false;
	}
	if (!isValidLength(profileInfo.challengeQuestion, 254)) {
		if (currentPanel != "Profile")
			gotoPanel("Profile", iFM + "_challengeQuestion");
		else { 
			alertDialog(get("inputFieldMax"));
			self.CONTENTS.document.profile.challengeQuestion.select();
		}
		return false;
	}     
	if (!isValidLength(profileInfo.challengeAnswer, 254)) {
		if (currentPanel != "Profile")
			gotoPanel("Profile", iFM + "_challengeAnswer");
		else {
			alertDialog(get("inputFieldMax"));
			self.CONTENTS.document.profile.challengeAnswer.select();
		}
		return false;
	}    




	if (addressInfo!= null)	{
		// add validation to address panel	
		for (var i=0; i < mandatoryFieldList.length; i++) {
			if (mandatoryFieldList[i] == "street" && isEmpty(addressInfo.address1)) {
   	  			if (currentPanel != "Address")
		   	  		gotoPanel("Address", mM + "_address1");
		   		else {
			   	      	alertDialog(get("missingMandatoryData"));
			   	      	self.CONTENTS.document.address.address1.focus();
		   		}
				return false;
			}
			if (mandatoryFieldList[i] == "city" && isEmpty(addressInfo.city)) {
	   	  		if (currentPanel != "Address")
			   	  	gotoPanel("Address", mM + "_city");
			   	else {
			   	      	alertDialog(get("missingMandatoryData"));
			   	      	self.CONTENTS.document.address.city.focus();
		  		}
				return false;
			}
			if (mandatoryFieldList[i] == "state" && isEmpty(addressInfo.state)) {
	     			if (currentPanel != "Address")
		   		  	gotoPanel("Address", mM + "_state");
	   			else {
			      	   	alertDialog(get("missingMandatoryData"));
			      	   	self.CONTENTS.document.address.state.focus();
      	   			}
				return false;
		      	}
		      	if (mandatoryFieldList[i] == "zip" && isEmpty(addressInfo.zip))	{
	     			if (currentPanel != "Address")
		   		  	gotoPanel("Address", mM + "_zip");
	   			else {
			      	   	alertDialog(get("missingMandatoryData"));
			      	   	self.CONTENTS.document.address.zip.focus();
				}
				return false;
		      	}
		      	if (mandatoryFieldList[i] == "country" && isEmpty(addressInfo.country))	{
  	   			if (currentPanel != "Address")
		   		  	gotoPanel("Address", mM + "_country");
		   		else {
			      	   	alertDialog(get("missingMandatoryData"));
			      	    	self.CONTENTS.document.address.country.focus();
				}
				return false;
		      	}      		
		}
		if (!isValidLength(addressInfo.address1, 50)) {
			if (currentPanel != "Address")
				gotoPanel("Address", iFM + "_address1");
			else {
				alertDialog(get("inputFieldMax"));
				self.CONTENTS.document.address.address1.select();
			}
			return false;
		}
		if (!isValidLength(addressInfo.address2, 50)) {
			if (currentPanel != "Address")
				gotoPanel("Address", iFM + "_address2");
			else {
				alertDialog(get("inputFieldMax"));
				self.CONTENTS.document.address.address2.select();
			}
			return false;
		}
		if (!isValidLength(addressInfo.address3, 50)) {
			if (currentPanel != "Address")
				gotoPanel("Address", iFM + "_address3");
			else {
				alertDialog(get("inputFieldMax"));
				self.CONTENTS.document.address.address3.select();
			}
			return false;
		}
		if (!isValidLength(addressInfo.city, 128)) {
			if (currentPanel != "Address")
				gotoPanel("Address", iFM + "_city");
			else {
				alertDialog(get("inputFieldMax"));
				self.CONTENTS.document.address.city.select();
			}
			return false;
		}
		if (!isValidLength(addressInfo.state, 128)) {
			if (currentPanel != "Address")
				gotoPanel("Address", iFM + "_state");
			else {
				alertDialog(get("inputFieldMax"));
				self.CONTENTS.document.address.state.select();
			}
			return false;
		}
		if (!isValidLength(addressInfo.country, 128)) {
			if (currentPanel != "Address")
				gotoPanel("Address", iFM + "_country");
			else {
				alertDialog(get("inputFieldMax"));
				self.CONTENTS.document.address.country.select();
			}
			return false;
		}
		if (!isValidLength(addressInfo.zip, 40)) {
			if (currentPanel != "Address")
				gotoPanel("Address", iFM + "_zip");
			else {
				alertDialog(get("inputFieldMax"));
				self.CONTENTS.document.address.zip.select();
			}
			return false;
		}
	}



	
	if (contactInfo != null) {
	   	// validate fields in contact panel
   		if (contactInfo.preferredCommunication == "E1" && contactInfo.email1 =="") {
	     		if (currentPanel != "Contact")
		   	  	gotoPanel("Contact", mE1);
	   		else {
			   	alertDialog(get("missingEmail1"));
			   	self.CONTENTS.document.contact.email1.focus();
			}
			return false;
	   	}
   		if (contactInfo.preferredCommunication == "E2" && contactInfo.email2 =="") {
	     		if (currentPanel != "Contact")
		   	  	gotoPanel("Contact", mE2);
	   		else {
	   		   	alertDialog(get("missingEmail2"));
   		   		self.CONTENTS.document.contact.email2.focus();
			}
			return false;
	   	}
   		if (contactInfo.preferredCommunication == "P1" && contactInfo.phone1 =="") {
	     		if (currentPanel != "Contact")
		   	  	gotoPanel("Contact", mP1);
	   		else {
		   	   	alertDialog(get("missingPhone1"));	 
   	   			self.CONTENTS.document.contact.phone1.focus();  	
			}
			return false;
	   	}
   		if (contactInfo.preferredCommunication == "P2" && contactInfo.phone2 =="") {
	     		if (currentPanel != "Contact")
		   	  	gotoPanel("Contact", mP2);
	   		else {
		   	   	alertDialog(get("missingPhone2"));
   	   			self.CONTENTS.document.contact.phone2.focus();
			}
			return false;
	   	}
		if (!isValidLength(contactInfo.email1, 254)) {
			if (currentPanel != "Contact")
				gotoPanel("Contact", iFME1);
			else {
				alertDialog(get("inputFieldMaxEmail1"));
				self.CONTENTS.document.contact.email1.select();
			}
			return false;
		}
		
		if (!isValidEmail(contactInfo.email1)) {
			if (currentPanel != "Contact")
				gotoPanel("Contact", iFIE1);
			else {
				alertDialog(get("inputFieldInvalidEmail1"));
				self.CONTENTS.document.contact.email1.select();
			}
			return false;
		}
		if (!isValidLength(contactInfo.email2, 254)) {
			if (currentPanel != "Contact")
				gotoPanel("Contact", iFME2);
			else {
				alertDialog(get("inputFieldMaxEmail2"));
				self.CONTENTS.document.contact.email2.select();
			}
			return false;
		}
		
		if (!isValidEmail(contactInfo.email2)) {
			if (currentPanel != "Contact")
				gotoPanel("Contact", iFIE2);
			else {
				alertDialog(get("inputFieldInvalidEmail2"));
				self.CONTENTS.document.contact.email2.select();
			}
			return false;
		}
		if (!isValidLength(contactInfo.phone1, 32)) {
			if (currentPanel != "Contact")
				gotoPanel("Contact", iFM + "_phone1");
			else {
				alertDialog(get("inputFieldMax"));
				self.CONTENTS.document.contact.phone1.select();
			}
			return false;
		}
		if (!isValidLength(contactInfo.phone2, 32)) {
			if (currentPanel != "Contact")
				gotoPanel("Contact", iFM + "_phone2");
			else {
				alertDialog(get("inputFieldMax"));
				self.CONTENTS.document.contact.phone2.select();
			}
			return false;
		}
		if (!isValidLength(contactInfo.fax1, 32)) {
			if (currentPanel != "Contact")
				gotoPanel("Contact", iFM + "_fax1");
			else {
				alertDialog(get("inputFieldMax"));
				self.CONTENTS.document.contact.fax1.select();
			}
			return false;
		}
		if (!isValidLength(contactInfo.fax2, 32)) {
			if (currentPanel != "Contact")
				gotoPanel("Contact", iFM + "_fax2");
			else {
				alertDialog(get("inputFieldMax"));
				self.CONTENTS.document.contact.fax2.select();
			}
			return false;
		}
	}
	
	if (demographicsInfo != null) {
		if (!isNumber(demographicsInfo.peopleNumInHouse)) {
			if (currentPanel != "Demographics")
     	  	  		gotoPanel("Demographics", iNH);
			else {
				alertDialog(get("InvalidNumberInHousehold"));
				self.CONTENTS.document.dem.peopleNumInHouse.focus();
			}
			return false;
		}
		if (!isNumber(demographicsInfo.childrenNum)) {
			if (currentPanel != "Demographics")
     	  	  		gotoPanel("Demographics", iCH);
			else {
	 	     		alertDialog(get("InvalidNumberOfChildren"));
 		     		self.CONTENTS.document.dem.childrenNum.focus();
			}
			return false;
		}		
		if (!isValidLength(demographicsInfo.peopleNumInHouse, 2)) {
			if (currentPanel != "Demographics")
				gotoPanel("Demographics", iFM + "_peopleNumInHouse");
			else {
				alertDialog(get("inputFieldMax"));
				self.CONTENTS.document.dem.peopleNumInHouse.select();
			}
			return false;
		}
		if (!isValidLength(demographicsInfo.childrenNum, 2)) {
			if (currentPanel != "Demographics")
				gotoPanel("Demographics", iFM + "_childrenNum");
			else {
				alertDialog(get("inputFieldMax"));
				self.CONTENTS.document.dem.childrenNum.select();
			}
			return false;
		}
		if (!isValidLength(demographicsInfo.employer, 128)) {
			if (currentPanel != "Demographics")
				gotoPanel("Demographics", iFM + "_employer");
			else {
				alertDialog(get("inputFieldMax"));
				self.CONTENTS.document.dem.employer.select();
			}
			return false;
		}
		if (!isValidLength(demographicsInfo.hobby, 254)) {
			if (currentPanel != "Demographics")
				gotoPanel("Demographics", iFM + "_hobby");
			else {
				alertDialog(get("inputFieldMax"));
				self.CONTENTS.document.dem.hobby.select();
			}
			return false;
		}
	}
	
	return true;
	
 }
