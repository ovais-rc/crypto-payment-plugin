//-----------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (C) Copyright IBM Corp. 2013 All Rights Reserved.
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with
// IBM Corp.
//-----------------------------------------------------------------

//<%--
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp.  2011 All Rights Reserved.
//* All Rights Reserved
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
//*
//--%>
	
	////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//
	// CatalogSearchDisplayJS contains all the global variables and javascript functions 
	// necessary for this page to work.
	//
	////////////////////////////////////////////////////////////////////////////////////////////////////////////
	   
	 
	CatalogSearchDisplayJS={	
	
		trimTerm:function(formId) {
			if(form.searchTerm !== null && form.searchTerm != 'undefined')
				form.searchTerm.value = form.searchTerm.value.replace(/^\s+/g, '').replace(/\s+$/g, '');
			if(form.filterTerm !== null && form.filterTerm != 'undefined')
				form.searchTerm.value = form.searchTerm.value.replace(/^\s+/g, '').replace(/\s+$/g, '');
		},
						
		submitAdvancedSearch:function(formId){
		
		// summary: This function submit the advanced search form by using render.updateContext
		// Description: This function submit the advanced search form by using render.updateContext			
		
		// form: html formId
		//		this is the advanced search form to be submitted.
			
			var methodName = "submitAdvancedSearch";
			
			form = document.getElementById(formId);
			
			//set the result catEntryType, which is checked on CatalogSearchResultDisplay.jsp: 
			// 1 = list items, packages, and bundles
			// 2 = list products, packages, and bundles

			this.trimTerm(formId);
		
			if(form.minPrice !== null && form.minPrice != 'undefined')
				form.minPrice.value = form.minPrice.value.replace(/^\s+/g, '').replace(/\s+$/g, '');
		
			if(form.maxPrice !== null && form.maxPrice != 'undefined')
				form.maxPrice.value = form.maxPrice.value.replace(/^\s+/g, '').replace(/\s+$/g, '');
		
		
			if ((form.minPrice.value == "") && (form.maxPrice.value == ""))
			{
				form.currency.value="";
			}
			form.resultCatEntryType.value = "2";
			
			
			form.submit();

		},
			
		submitSearch:function(formId){
			form = document.getElementById(formId);
			this.trimTerm(formId);
			form.submit();
		},
		
		/**
		 *   Displays the Addresses in MyAccount ( pagination ) 
		 *  @param {string} controllerURL The URL of the refresh area contents to point to upon a widget refresh.
		 *  @param {string} pageNumber The updated page number to display.
		 */	
		showNextResults: function(pageNumber){

				

				if($("#widget_Addr_"+pageNumber).length){
					$("#widget_Addr_"+pageNumber).css("display", "none");
					
				}
				
				pageNumber++;
				
				if($("#widget_Addr_"+pageNumber).length){
					$("#widget_Addr_"+pageNumber).css("display", "block");
					
				}

		},

		/**
		 *  Displays the Addresses in MyAccount ( pagination ) 
		 *  @param {string} controllerURL The URL of the refresh area contents to point to upon a widget refresh.
		 *  @param {string} pageNumber The updated page number to display.
		 */	

		showPrevResults: function(pageNumber){

				

				if($("#widget_Addr_"+pageNumber).length){
					$("#widget_Addr_"+pageNumber).css("display", "none");
					
				}
				
				pageNumber--;
				
				if($("#widget_Addr_"+pageNumber).length){
					$("#widget_Addr_"+pageNumber).css("display", "block");
					
				}

		}

	}//end of CatalogSearchDisplayJS   
