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

//--------------------------------------------------------------------------------------------------

document.writeln(" <FORM NAME=\"_formDeleteSubmit\" ACTION=\"Delete\" METHOD=\"POST\"> 		");

	document.writeln(" 	<INPUT TYPE=\"hidden\" NAME=\"checkedItemRefNum\" VALUE=\" \">		");
	document.writeln(" 	<INPUT TYPE=\"hidden\" NAME=\"checkedProductRefNum\" VALUE=\" \">	");
	document.writeln(" 	<INPUT TYPE=\"hidden\" NAME=\"checkedCategoryRefNum\" VALUE=\" \">	");
	document.writeln(" 	<INPUT TYPE=\"hidden\" NAME=\"checkedAttributeRefNum\" VALUE=\" \">	");
	document.writeln(" 	<INPUT TYPE=\"hidden\" NAME=\"checkedAttrValueRefNum\" VALUE=\" \">	");

	document.writeln(" 	<INPUT TYPE=\"hidden\" NAME=\"productrfnbr\" VALUE=\" \">	");
	document.writeln(" 	<INPUT TYPE=\"hidden\" NAME=\"attributeId\" VALUE=\" \">	");

	//for category Delete
        document.writeln(" 	<INPUT TYPE=\"hidden\" NAME=\"categoryKeyword\" VALUE=\" \">			");
        document.writeln(" 	<INPUT TYPE=\"hidden\" NAME=\"keywordLike\" VALUE=\" \">			");
        document.writeln(" 	<INPUT TYPE=\"hidden\" NAME=\"categoryName\" VALUE=\" \">			");
        document.writeln(" 	<INPUT TYPE=\"hidden\" NAME=\"nameLike\" VALUE=\" \">				");
        document.writeln(" 	<INPUT TYPE=\"hidden\" NAME=\"categoryShortDescription\" VALUE=\" \">		");
        document.writeln(" 	<INPUT TYPE=\"hidden\" NAME=\"shortDescriptionLike\" VALUE=\" \">		");
        document.writeln(" 	<INPUT TYPE=\"hidden\" NAME=\"categoryLongDescription\" VALUE=\" \">		");
        document.writeln(" 	<INPUT TYPE=\"hidden\" NAME=\"longDescriptionLike\" VALUE=\" \">		");
	
	//keeping the orderby param	
        document.writeln(" 	<INPUT TYPE=\"hidden\" NAME=\"orderby\" VALUE=\" \">		");

document.writeln(" </FORM> ");

//--------------------------------------------------------------------------------------------------

  function performCategoryDelete()
  {
        var deletedCategories = null;
        var categoriesToDelete = new Array();
        var newIndex = null;
        var i=0;
  	if (confirmDialog(basefrm.getCategoryDelConfirmMsg())) 
	{
  	    top.showProgressIndicator(true);
  	    
            categoryId = getChecked();

	    deletedCategories = top.get( "deletedCategory", null );
            if ( deletedCategories == null ) {
                deletedCategories = new Array();
                newIndex = 0;
	    } else {
                newIndex = deletedCategories.length;
            }
        // We remove the categories which do not belong to the store.    
        for ( j=0 ; j<=categoryId.length - 1; j++ )
        {
           if (basefrm.catalogGroup[categoryId[j]].doIOwn)
           {
              categoriesToDelete[i] = categoryId[j];
              i++;           
           }
        }    
        if ( categoriesToDelete.length < categoryId.length )
        {
        	alertDialog(basefrm.getDoNotOwnCategoriesMsg());
        }
	    var undefined;
	    if ( categoriesToDelete.length === undefined ) {
               deletedCategories[ newIndex ] = categoriesToDelete;
            } else {
                for ( j = 0; j <= categoriesToDelete.length - 1; j++ ) {
                          deletedCategories[newIndex + j] = categoriesToDelete[j];
                }
            }
            top.put( "deletedCategory", deletedCategories );

        if (categoriesToDelete.length > 0 )
        {
	       document._formDeleteSubmit.checkedCategoryRefNum.value = categoriesToDelete;
	       document._formDeleteSubmit.action = "CategoryDelete";
	    
	       document._formDeleteSubmit.categoryKeyword.value = basefrm.document._formUsedByCategoryDelete.categoryKeyword.value; 			//in the jsp
	       document._formDeleteSubmit.keywordLike.value = basefrm.document._formUsedByCategoryDelete.keywordLike.value; 
	       document._formDeleteSubmit.categoryName.value = basefrm.document._formUsedByCategoryDelete.categoryName.value; 
	       document._formDeleteSubmit.nameLike.value = basefrm.document._formUsedByCategoryDelete.nameLike.value; 
	       document._formDeleteSubmit.categoryShortDescription.value = basefrm.document._formUsedByCategoryDelete.categoryShortDescription.value; 
	       document._formDeleteSubmit.shortDescriptionLike.value = basefrm.document._formUsedByCategoryDelete.shortDescriptionLike.value; 
	       document._formDeleteSubmit.categoryLongDescription.value = basefrm.document._formUsedByCategoryDelete.categoryLongDescription.value; 
	       document._formDeleteSubmit.longDescriptionLike.value = basefrm.document._formUsedByCategoryDelete.longDescriptionLike.value; 
	       document._formDeleteSubmit.orderby.value = generalForm.orderby.value;
	    
	       document._formDeleteSubmit.submit();
	    
	       selectDeselectAll();
	    }
	    else
	    {
	       top.showProgressIndicator(false);
	    }
	}   
  }

  
  function performAttributeDelete()
  {
  	if (confirmDialog(basefrm.getAttrDelConfirmMsg())) 
	{
  	    top.showProgressIndicator(true);

	    document._formDeleteSubmit.action = "AttributeDelete";
		
	    document._formDeleteSubmit.checkedAttributeRefNum.value = getChecked();
	    document._formDeleteSubmit.productrfnbr.value = basefrm.getProductID();		//in the jsp
	    document._formDeleteSubmit.orderby.value = generalForm.orderby.value;

	    document._formDeleteSubmit.submit();
	    
	    selectDeselectAll();
	}
  }
  
  function performAttributeValueDelete()
  {
  	if (confirmDialog(basefrm.getAttrValueDelConfirmMsg())) 
	{
  	    top.showProgressIndicator(true);

	    document._formDeleteSubmit.action = "ProductAttributeValueDelete";
		
	    document._formDeleteSubmit.checkedAttrValueRefNum.value = getChecked();
	    document._formDeleteSubmit.productrfnbr.value = basefrm.getProductID();		//in the jsp
	    document._formDeleteSubmit.attributeId.value = basefrm.getAttributeId();		//in the jsp
	    document._formDeleteSubmit.orderby.value = generalForm.orderby.value;

	    document._formDeleteSubmit.submit();
	    
	    selectDeselectAll();
	}
  }
  
  function performProductVariantDelete()
  {
  	if (confirmDialog(basefrm.getItemDelConfirmMsg())) 
	{
  	    top.showProgressIndicator(true);

	    document._formDeleteSubmit.action = "ItemDelete";
		
	    document._formDeleteSubmit.checkedItemRefNum.value = getChecked();
	    document._formDeleteSubmit.orderby.value = generalForm.orderby.value;

	    document._formDeleteSubmit.submit();
	    
	    selectDeselectAll();
	}
  }
  
  
