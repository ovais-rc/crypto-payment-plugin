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
       
      var ProductPartNumber = cutspace(CONTENTS.ProductFindCriteriaFORM.ProductPartNumber.value);
      var partNumberCaseSensitive = false;
      var partNumberLike = CONTENTS.ProductFindCriteriaFORM.partNumberLike.options[CONTENTS.ProductFindCriteriaFORM.partNumberLike.selectedIndex].value;

      var ProductName = cutspace(CONTENTS.ProductFindCriteriaFORM.ProductName.value);
      var nameCaseSensitive = false;
      var nameLike = CONTENTS.ProductFindCriteriaFORM.nameLike.options[CONTENTS.ProductFindCriteriaFORM.nameLike.selectedIndex].value;

      var ProductShortDescription = cutspace(CONTENTS.ProductFindCriteriaFORM.ProductShortDescription.value);
      var shortDescriptionCaseSensitive = false;
      var shortDescriptionLike = CONTENTS.ProductFindCriteriaFORM.shortDescriptionLike.options[CONTENTS.ProductFindCriteriaFORM.shortDescriptionLike.selectedIndex].value;
  
      var langid = CONTENTS.ProductFindCriteriaFORM.langid.value;
      //var parentCategoryID = CONTENTS.ProductFindCriteriaFORM.parentCategoryID.value;
      //if (parentCategoryID != "")
      //	  parentCategoryID = strToInteger(parentCategoryID, langid);

      //var categoryCode= cutspace(CONTENTS.ProductFindCriteriaFORM.categoryCode.value);
      //var categoryCodeCaseSensitive = false;
      //var categoryCodeLike = CONTENTS.ProductFindCriteriaFORM.nameLike.options[CONTENTS.ProductFindCriteriaFORM.categoryCodeLike.selectedIndex].value;

      var categoryName= cutspace(CONTENTS.ProductFindCriteriaFORM.categoryName.value);
      var categoryNameCaseSensitive = false;
      var categoryNameLike = CONTENTS.ProductFindCriteriaFORM.nameLike.options[CONTENTS.ProductFindCriteriaFORM.categoryNameLike.selectedIndex].value;
      
      if (CONTENTS.validatePanelData()) 
      {
          var resultTitle = CONTENTS.getResultTitle();
      
        //  var startindex = 0;
        //  var listsize = 16;
		//  var orderBy = "CATENTRY.PARTNUMBER";
      
          var aurl = "/webapp/wcs/tools/servlet/NewDynamicListView";

          var p = new Object();
          p["ActionXMLFile"] = "catalog.productListActions";
          p["cmd"] = "ProductFindResults";
          
          /**********************************************
          p["startindex"] = startindex;
          p["listsize"] = listsize;
          p["orderby"] = orderBy;
          p["selected"] = "SELECTED";
          p["refnum"]=0;
          ***********************************************/
          p["ProductPartNumber"] = ProductPartNumber;
          p["partNumberCaseSensitive"] = partNumberCaseSensitive;
          p["partNumberLike"] = partNumberLike;
          p["ProductName"] = ProductName;
          p["nameCaseSensitive"] = nameCaseSensitive;
          p["nameLike"] = nameLike;
          p["ProductShortDescription"] = ProductShortDescription;
          p["shortDescriptionCaseSensitive"] = shortDescriptionCaseSensitive;
          p["shortDescriptionLike"] = shortDescriptionLike;
          //p["parentCategoryID"] = parentCategoryID;
          
          //p["categoryCode"] = categoryCode;
          //p["categoryCodeCaseSensitive"] = categoryCodeCaseSensitive;
          //p["categoryCodeLike"] = categoryCodeLike;

          p["categoryName"] = categoryName;
          p["categoryNameCaseSensitive"] = categoryNameCaseSensitive;
          p["categoryNameLike"] = categoryNameLike;

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
