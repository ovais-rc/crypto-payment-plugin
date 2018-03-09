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

/****************************************************************************
 *
 * Licensed Materials - Property of IBM
 *
 * WebSphere Commerce
 *
 * (c) Copyright IBM Corp. 2000, 2002
 *
 * US Government Users Restricted Rights - Use, duplication or
 * disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 * 
 ***************************************************************************/

function submitFinishHandler()
{
   top.setHome()
}
function submitCancelHandler()
{
   top.setHome();
}

function preSubmitHandler()
{
	var taxes = self.get("TaxInfoBean1");
	var taxFulfillmentInfoBean = self.get("TaxFulfillmentInfoBean1");
	
	if(taxes != null){
		var jurstgroup = taxes.jurstgroup;
		var jurisdictions = taxes.jurst;
		var jurstgprel = taxes.jurstgprel;
		var taxcgry = taxes.taxcgry;
		var taxcgryds = taxes.taxcgryds;
		var calcode = taxes.calcode;
		var calrule = taxes.calrule;
		var calscale = taxes.calscale;
		var crulescale = taxes.crulescale;
		var calrange = taxes.calrange;
		var calrlookup = taxes.calrlookup;
		
		if(jurstgroup != null){
			var addJgroup = new Vector();
			for (var i = 0; i < size(jurstgroup); i++)
			{
			    var thisjurstgroup = elementAt(i,jurstgroup);
				if (thisjurstgroup.jurisdictionGroupId.substring(0,1) == "@")       
				{
					addElement(thisjurstgroup,addJgroup);
				}
			}
			self.put("addJgroup",addJgroup);
		}
		
		if(jurisdictions != null){
			var addJurst = new Vector();
			for (var i = 0; i < size(jurisdictions); i++)
			{
			    var jurst = elementAt(i,jurisdictions);
				if (jurst.jurisdictionId.substring(0,1) == "@")       
				{
					addElement(jurst,addJurst);
				}
			}
			self.put("addJurst",addJurst);
		}
		
		if(jurstgprel != null){
			var addJustgprel = new Vector();
			for (var i = 0; i < size(jurstgprel); i++)
			{
			    var thisjurstgprel = elementAt(i,jurstgprel);
				if (thisjurstgprel.jurisdictionId.substring(0,1) == "@" || thisjurstgprel.jurisdictionGroupId.substring(0,1) == "@")       
				{
					addElement(thisjurstgprel,addJustgprel);
				}
			}
			self.put("addJustgprel",addJustgprel);
		}
		
		if(taxcgry != null){
			var addTaxcgry = new Vector();
			for (var i = 0; i < size(taxcgry); i++)
			{
			    var thistaxcgry = elementAt(i,taxcgry);
				if (thistaxcgry.categoryId.substring(0,1) == "@")       
				{
					addElement(thistaxcgry,addTaxcgry);
				}
			}
			self.put("addTaxcgry",addTaxcgry);
		}
		
		if(taxcgryds != null){
			var addTaxcgryds = new Vector();
			for (var i = 0; i < size(taxcgryds); i++)
			{
			    var thistaxcgryds = elementAt(i,taxcgryds);
				if (thistaxcgryds.taxCategoryId.substring(0,1) == "@")       
				{
					addElement(thistaxcgryds,addTaxcgryds);
				}
			}
			self.put("addTaxcgryds",addTaxcgryds);
		}
		
		if(calcode != null){
			var addCalcode = new Vector();
			for (var i = 0; i < size(calcode); i++)
			{
			    var thiscalcode = elementAt(i,calcode);
				if (thiscalcode.calculationCodeId.substring(0,1) == "@")       
				{
					addElement(thiscalcode,addCalcode);
				}
			}
			self.put("addCalcode",addCalcode);
		}
		
		if(calrule != null){
			var addCalrule = new Vector();
			for (var i = 0; i < size(calrule); i++)
			{
			    var thiscalrule = elementAt(i,calrule);
				if (thiscalrule.calculationRuleId.substring(0,1) == "@" || thiscalrule.calculationCodeId.substring(0,1) == "@" || thiscalrule.taxCategoryId.substring(0,1) == "@")       
				{
					addElement(thiscalrule,addCalrule);
				}
			}
			self.put("addCalrule",addCalrule);
		}
		
		if(calscale != null){
			var addCalscale = new Vector();
			for (var i = 0; i < size(calscale); i++)
			{
			    var thiscalscale = elementAt(i,calscale);
				if (thiscalscale.calculationScaleId.substring(0,1) == "@")       
				{
					addElement(thiscalscale,addCalscale);
				}
			}
			self.put("addCalscale",addCalscale);
		}
		
		if(crulescale != null){
			var addCrulescale = new Vector();
			for (var i = 0; i < size(crulescale); i++)
			{
			    var thiscrulescale = elementAt(i,crulescale);
				if (thiscrulescale.calculationRuleId.substring(0,1) == "@" || thiscrulescale.calculationScaleId.substring(0,1) == "@")       
				{
					addElement(thiscrulescale,addCrulescale);
				}
			}
			self.put("addCrulescale",addCrulescale);
		}
		
		if(calrange != null){
			var addCalrange = new Vector();
			for (var i = 0; i < size(calrange); i++)
			{
			    var thiscalrange = elementAt(i,calrange);
				if (thiscalrange.calculationRangeId.substring(0,1) == "@" || thiscalrange.calculationScaleId.substring(0,1) == "@")       
				{
					addElement(thiscalrange,addCalrange);
				}
			}
			self.put("addCalrange",addCalrange);
		}
		
		if(calrlookup != null){
			var addCalrlookup = new Vector();
			for (var i = 0; i < size(calrlookup); i++)
			{
			    var thiscalrlookup = elementAt(i,calrlookup);
				if (thiscalrlookup.calculationRangeId.substring(0,1) == "@" || thiscalrlookup.calculationRangeLookupResultId.substring(0,1) == "@")       
				{
					addElement(thiscalrlookup,addCalrlookup);
				}
			}
			self.put("addCalrlookup",addCalrlookup);
		}
		self.put("TaxInfoBean1","");
	}	
		
	if(taxFulfillmentInfoBean != null){	
		var taxjcrule = taxFulfillmentInfoBean.taxjcrule;
		if(taxjcrule != null){
			var addTaxjcrule = new Vector();
			for (var i = 0; i < size(taxjcrule); i++)
			{
			    var thistaxjcrule = elementAt(i,taxjcrule);
			 	if (thistaxjcrule.calculationRuleId.substring(0,1) == "@" || thistaxjcrule.jurisdictionGroupId.substring(0,1) == "@")       
				{
					addElement(thistaxjcrule,addTaxjcrule);
				}
			}
			self.put("addTaxjcrule",addTaxjcrule);
		}
		self.put("TaxFulfillmentInfoBean1","");
	}
}

function jurst()
{
this.storeEntityId='@storeent_id_1';
this.subclass='1';

this.markForDelete='0';
}

function calcode()
{
//this.calmethod_id='3';
this.groupBy='0';
this.sequence='0';
this.storeEntityId='@storeent_id_1';
this.calculationCodeApplyMethodId='-44';
this.calculationCodeQualifyMethodId='-42';
this.calculationMethodId="-43";
this.calculationUsageId='-3';
this.published='1';

this.displayLevel="0"
this.flags="0"
this.precedence="0"

}

function shippingcalcode()
{
//this.calmethod_id='3';
this.groupBy='0';
this.sequence='0';
this.storeEntityId='@storeent_id_1';
this.calculationCodeApplyMethodId='-64';
this.calculationCodeQualifyMethodId='-62';
this.calculationMethodId="-63";
this.calculationUsageId='-4';
this.published='1';

this.displayLevel="0"
this.flags="0"
this.precedence="0"
}

function shipcategorycalcode()
{
this.groupBy='8';
this.sequence='0';
this.storeEntityId='@storeent_id_1';
this.calculationCodeApplyMethodId='-44';
this.calculationCodeQualifyMethodId='-42';
this.calculationMethodId="-43";
this.calculationUsageId='-3';
this.published='1';

this.displayLevel="0"
this.flags="0"
this.precedence="0"
}

function calrule()
{
this.calculationRuleId='-1';
this.calculationMethodId='-47';
this.sequence='0';
this.combination='2';
this.calculationRuleQualifyMethodId='-46';
this.flags='1';
}

function shippingcalrule()
{
this.calculationRuleId='-1';
this.calculationMethodId='-67';
this.sequence='0';
this.combination='2';
this.calculationRuleQualifyMethodId='-66';
this.flags='1';
}

function jurstgroup()
{
this.jurisdictionGroupId='-1';
this.storeentId='0';
this.description='-';
this.subclass='1';
this.code='World';

this.markForDelete='0';
}
					  
function calrange()
{
this.calculationRangeId='-1'
this.calculationMethodId='-59';
this.rangeStart='0.00000';
this.calculationScaleId='';
this.cumulative='0';

this.markForDelete='0';
}

function shippingcalrange()
{
this.calculationRangeId='-1'
this.calculationMethodId='-77';
this.rangeStart='0.00000';
this.calculationScaleId='';
this.cumulative='0';

this.markForDelete='0';
}

function crulescale()
{
this.calculationRuleId='';
this.calculationScaleId='';
}

function jurstgprel()
{
this.jurisdictionId='';
this.jurisdictionGroupId='';
this.subclass='1';
}

function calscale()
{
this.calculationScaleId='-1';
this.calculationMethodId='-53';
this.storeEntityId='@storeent_id_1';
this.code='-';
this.calculationUsageId='-3';
}

function shippingcalscale()
{
this.calculationScaleId='-1';
this.calculationMethodId='-73';
this.storeEntityId='@storeent_id_1';
this.code='-';
this.calculationUsageId='-4';
}

function calrlookup()
{
this.calculationRangeLookupResultId='-1';
this.calculationRangeId='-1';
}

function shipmode()
{
this.shipmode_id='-1';
this.code='Default Shipmode';
this.carrier='';

this.markfordelete='0';
}

function shpmodedsc()
{
  this.field1='';
  this.field2='';
}

function shparrange()
{
this.store_id='@storeent_id_1';
this.ffmcenter_id='@ffmcenter_id_1';
this.precedence= '0';
}

function shpjcrule(aPrecedence)
{
this.shipmode_id='';
this.jurstgroup_id='';
this.precedence=aPrecedence;
this.calrule_id='';
this.ffmcenter_id='@ffmcenter_id_1';
}

function taxcgry()
{
this.storeEntityId='@storeent_id_1';
this.displaySequence='0';
this.displayUsage="0";
this.calculationSequence='0';
this.name='';
this.categoryId='1';
this.typeId='-3';

this.markForDelete='0';
}

function shippingtaxcgry()
{
this.storeEntityId='@storeent_id_1';
this.displaySequence='0';
this.displayUsage="0";
this.calculationSequence='0';
this.name='';
this.categoryId='1';
this.typeId='-4';

this.markForDelete='0';
}

function taxtype()
{
this.taxtype_id='2';
this.sequence='0';
this.txcdscheme_id='';
}

function taxjcrule(aPrecedence)
{
this.jurisdictionGroupId='3';
this.precedence=aPrecedence;
this.calculationRuleId='';
this.fulfillmentCenterId='@ffmcenter_id_1';
this.taxJCRuleId='';
}


