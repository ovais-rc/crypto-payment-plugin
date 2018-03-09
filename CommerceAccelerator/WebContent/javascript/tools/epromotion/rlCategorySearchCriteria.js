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

//Performs search action
function searchAction(){
      var categoryName = cutspace(CONTENTS.categorySearchCriteriaFORM.categoryName.value);
      var nameLike = CONTENTS.categorySearchCriteriaFORM.nameLike.options[CONTENTS.categorySearchCriteriaFORM.nameLike.selectedIndex].value;
   
      var categoryShortDescription = cutspace(CONTENTS.categorySearchCriteriaFORM.categoryShortDescription.value);
      var shortDescriptionLike = CONTENTS.categorySearchCriteriaFORM.shortDescriptionLike.options[CONTENTS.categorySearchCriteriaFORM.shortDescriptionLike.selectedIndex].value;
           
      if (CONTENTS.validatePanelData()) 
      {
         var aurl = "/webapp/wcs/tools/servlet/DialogView";
         var p = new Object();
         p["XMLFile"] = "RLPromotion.RLCategorySearchResultDialog";
         p["categoryName"] = categoryName;
         p["nameLike"] = nameLike;
         p["categoryShortDescription"] = categoryShortDescription;
         p["shortDescriptionLike"] = shortDescriptionLike;
         p["ActionXMLFile"] = "RLPromotion.RLCatalogGroupList";
         p["cmd"] = "RLCatalogGroupListView";               
         top.setContent(self.CONTENTS.getResultTitle(), aurl, false, p);       
      }
  }

//Performs cancel action
function cancelAction() {
	self.CONTENTS.cancelAction();		
}	
	
//Performs refine action	
function refineAction() {
	var url = "/webapp/wcs/tools/servlet/DialogView?XMLFile=RLPromotion.RLCategorySearchDialog";		
	this.location.replace(url);
}

function cutspace(word) {
	return trim(word)}    
  
