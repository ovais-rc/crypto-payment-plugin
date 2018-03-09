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

//*---------------------------------------------------------------------
//* The sample contained herein is provided to you "AS IS".
//*
//* It is furnished by IBM as a simple example and has not been  
//* thoroughly tested
//* under all conditions.  IBM, therefore, cannot guarantee its 
//* reliability, serviceability or functionality.  
//*
//* This sample may include the names of individuals, companies, brands 
//* and products in order to illustrate concepts as completely as 
//* possible.  All of these names
//* are fictitious and any similarity to the names and addresses used by 
//* actual persons 
//* or business enterprises is entirely coincidental.
//*---------------------------------------------------------------------//*

////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
// NativeSearch.js contains the javascript functions to call out to WL.NativePage.show
// to launch a native search dialog and perform a search on the resulting search term
//
////////////////////////////////////////////////////////////////////////////////////////////////////////////

var NativeSearchJS = {
    
    storeId:"",
    catalogId:"",
    langId:"",
    searchTerm:"",
    
    /** search parameters **/
    searchBeginIndex:0,
    searchPageSize:12,
    searchResultCatEntryType:2,
    searchShowResultsPage:"true",
    searchSource:"Q",
    searchType:"SimpleSearch",
    searchViewMode:WCHybridAppProperties.getDeviceTypePrefix(),

    /**
     * startSearchActivity is the starting point for the native search, launches a
     * native search with store parameters
     */
    startSearchActivity: function() {
        var METHODNAME = "NativeSearchJS.startSearchActivity ";
        if (wlInitOptions.enableLogger) {
            WL.Logger.debug(METHODNAME + "ENTRY");
        }
        
        var hostName = window.location.hostname;
        this.storeId = window.sessionStorage.getItem("storeId");
        this.catalogId = window.sessionStorage.getItem("catalogId");
        this.langId = window.sessionStorage.getItem("langId");
        
        // use a flat JSON array for broadest platform support
        var parameters = {
            hostName: hostName,
            storeId: this.storeId,
            catalogId: this.catalogId,
            langId: this.langId
        }
        
        this.launch(parameters);
        
        if (wlInitOptions.enableLogger) {
            WL.Logger.debug(METHODNAME + "EXIT");
        }
    },
    
    /**
     * Callback function after WL.NativePage.show returns that goes to the search results page
     * @param The data returned from the WL.NativePage.show containing the selected search term
     */
    returnFromSearch: function(data) {
        var METHODNAME = "NativeSearchJS.returnFromSearch ";
        if (wlInitOptions.enableLogger) {
            WL.Logger.debug(METHODNAME + "ENTRY");
        }
        
        if (data != null && data !== "undefined") {
            var searchURL = "SearchDisplay" 
                + "?langId=" + NativeSearchJS.langId
                + "&storeId=" + NativeSearchJS.storeId
                + "&catalogId=" + NativeSearchJS.catalogId
                + "&beginIndex=" + NativeSearchJS.searchBeginIndex
                + "&resultCatEntryType=" + NativeSearchJS.searchResultCatEntryType
                + "&pageSize=" + NativeSearchJS.searchPageSize
                + "&pageView=" + window.sessionStorage.getItem('defaultPageView')
                + "&showResultsPage=" + NativeSearchJS.searchShowResultsPage
                + "&searchSource=" + NativeSearchJS.searchSource
                + "&sType=" + NativeSearchJS.searchType
                + "&viewMode=" + NativeSearchJS.searchViewMode
                + "&searchTerm=" + data.searchTerm;
            window.location.href = searchURL;
        } else {
            if (wlInitOptions.enableLogger) {
                WL.Logger.debug(METHODNAME + "No data was returned");
            }
        }
        
        if (wlInitOptions.enableLogger) {
            WL.Logger.debug(METHODNAME + "EXIT");
        }
    },
    
    /**
     * Makes the call to the native search class and provides store data to build the search query
     * Example JSON object: 
     *      {
     *          hostName: "http://www.storename.com",
     *          storeId: "10152",
     *          catalogId: "10001",
     *          langId: "-1"
     *      };
     *
     * @param parameters     parameters in JSON array format 
     */
    launch: function(parameters) {
        try {
            WL.NativePage.show(WCHybridAppProperties.getNativeSearchClassName(), this.returnFromSearch, parameters);
        } catch (err) {
            if (wlInitOptions.enableLogger) {
                WL.Logger.debug("NativeSearchJS.launch " + err.name + ": " + err.message);
            }
        }
    }
        
}
    