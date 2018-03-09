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
      	var categoryName = cutspace(CONTENTS.categoryFindCriteriaFORM.categoryName.value);
      	var nameLike = CONTENTS.categoryFindCriteriaFORM.nameLike.options[CONTENTS.categoryFindCriteriaFORM.nameLike.selectedIndex].value;
   
      	var categoryShortDescription = cutspace(CONTENTS.categoryFindCriteriaFORM.categoryShortDescription.value);
      	var shortDescriptionLike = CONTENTS.categoryFindCriteriaFORM.shortDescriptionLike.options[CONTENTS.categoryFindCriteriaFORM.shortDescriptionLike.selectedIndex].value;

      	if (CONTENTS.validatePanelData()) 
      	{
            var resultTitle = CONTENTS.getResultTitle();
         
            var aurl = "/webapp/wcs/tools/servlet/NewDynamicListView";

            var p = new Object();
            p["ActionXMLFile"] = "catalog.catalogGroupList";
            p["cmd"] = "CatalogGroupListView";
            p["categoryName"] = categoryName;
            p["nameLike"] = nameLike;
            p["categoryShortDescription"] = categoryShortDescription;
            p["shortDescriptionLike"] = shortDescriptionLike;
            top.setContent(resultTitle, aurl, true, p);
      	}
    }

    function button_Cancel()
    {
    	top.goBack();
    }


    function cutspace(word) 
    {
  	return trim(word);
    }    
