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

  function button_Find()
  {
      var orderBy = "CATENTRY.PARTNUMBER";
       
      var itemPartNumber = cutspace(CONTENTS.ItemFindCriteriaFORM.itemPartNumber.value);
      var partNumberCaseSensitive = false;
      var partNumberLike = CONTENTS.ItemFindCriteriaFORM.partNumberLike.options[CONTENTS.ItemFindCriteriaFORM.partNumberLike.selectedIndex].value;

  
      var itemName = cutspace(CONTENTS.ItemFindCriteriaFORM.itemName.value);
      var nameCaseSensitive = false;
      var nameLike = CONTENTS.ItemFindCriteriaFORM.nameLike.options[CONTENTS.ItemFindCriteriaFORM.nameLike.selectedIndex].value;

   
      var itemShortDescription = cutspace(CONTENTS.ItemFindCriteriaFORM.itemShortDescription.value);
      var shortDescriptionCaseSensitive = false;
      var shortDescriptionLike = CONTENTS.ItemFindCriteriaFORM.shortDescriptionLike.options[CONTENTS.ItemFindCriteriaFORM.shortDescriptionLike.selectedIndex].value;
  
      var langid = CONTENTS.ItemFindCriteriaFORM.langid.value;
      var parentCategoryID = CONTENTS.ItemFindCriteriaFORM.parentCategoryID.value;
      if (parentCategoryID != "")
      	  parentCategoryID = strToInteger(parentCategoryID, langid);
      var parentProductID = CONTENTS.ItemFindCriteriaFORM.parentProductID.value;
      if (parentProductID != "")
          parentProductID = strToInteger(parentProductID, langid)
      
      if (CONTENTS.validatePanelData()) {
          var resultTitle = CONTENTS.getResultTitle();
      
          var startindex = 0;
          var listsize = 16;

         
          var aurl = "/webapp/wcs/tools/servlet/DynamicListSCView";

          var p = new Object();
          p["ActionXMLFile"] = "catalog.itemFindActions";
          p["cmd"] = "ItemFindResults";
          p["startindex"] = startindex;
          p["listsize"] = listsize;
          p["orderby"] = orderBy;
          p["selected"] = "SELECTED";
          p["refnum"]=0;
          p["itemPartNumber"] = itemPartNumber;
          p["partNumberCaseSensitive"] = partNumberCaseSensitive;
          p["partNumberLike"] = partNumberLike;
          p["itemName"] = itemName;
          p["nameCaseSensitive"] = nameCaseSensitive;
          p["nameLike"] = nameLike;
          p["itemShortDescription"] = itemShortDescription;
          p["shortDescriptionCaseSensitive"] = shortDescriptionCaseSensitive;
          p["shortDescriptionLike"] = shortDescriptionLike;
          p["parentCategoryID"] = parentCategoryID;
          p["parentProductID"] = parentProductID;
          

          top.setContent(resultTitle, aurl, true, p);
        
      }
       
  }


  function button_Cancel()
  {
    top.goBack();
  }


  function cutspace(word) {
  	return trim(word);
	 

  }    
