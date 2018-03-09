//<%--
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp.  2008, 2013
//* All Rights Reserved
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
//*
//--%>

/**
 * @fileOverview This file contains functions that are used by Store Locator.
 *
 * @version 1.0
 *
 */


/**
 * The functions defined in the class are used for the Store Locator feature.
 *
 * @class This storeLocatorJSStore class defines all the functions to be used on pages that contain the Store Locator feature.
 *
 */
storeLocatorJSStore = {

    /**
     * This function initializes the state/province selection drop down list by extracting the selected value
     * of the country selection.  Nothing is done when no selected country is found.
     *
     */
    initProvinceSelections: function () {
        var countrySelectedIndex = $("#selectCountry").prop("selectedIndex");
        if (countrySelectedIndex > -1) {
            var indexToUse = countrySelectedIndex;
            var indexFromSavedId = storeLocatorJSStore.getSavedCountrySelectionIndex();

            if (indexFromSavedId != null && indexFromSavedId != countrySelectedIndex) {
                indexToUse = indexFromSavedId;
                $("#selectCountry")[0].options[indexToUse].selected = true;
            }
            wcRenderContext.updateRenderContext('provinceSelectionsContext', {
                'countryId': $("#selectCountry")[0].options[indexToUse].value
            });
        }
    },

    /**
     * This function refreshes the city selection drop down list by extracting the selected value of the
     * state/province selection.  Nothing is done when no selected state/province is found.
     *
     */
    refreshCities: function () {
        var stateSelectedIndex = $("#selectState").prop("selectedIndex");
        if (stateSelectedIndex > -1) {
            var indexToUse = stateSelectedIndex;
            var indexFromSavedId = storeLocatorJSStore.getSavedProvinceSelectionIndex();
            if (indexFromSavedId != null && indexFromSavedId != stateSelectedIndex) {
                indexToUse = indexFromSavedId;
                $("#selectState")[0].options[indexToUse].selected = true;
            }
            wcRenderContext.updateRenderContext('citySelectionsContext', {
                'provinceId': $("#selectState")[0].options[indexToUse].value
            });
        }
    },

    /**
     * This function refreshes the store location search results by extracting the selected value of the city
     * selection.  Nothing is done when no selected city is found.  Store location search results are refreshed
     * automatically once when a search intend (i.e. Find button is pressed) was done before.
     *
     * @param {String} fromPage Parameter value passed by the calling page.
     *
     */
    refreshSearchResults: function (fromPage) {
        var citySelectedIndex = $("#selectCity").selectedIndex;
        if (citySelectedIndex > -1) {
            var indexToUse = citySelectedIndex;
            var indexFromSavedId = storeLocatorJSStore.getSavedCitySelectionIndex();
            if (indexFromSavedId != null && indexFromSavedId != citySelectedIndex) {
                indexToUse = indexFromSavedId;
                $("#selectCountry")[0].options[indexToUse].value("selectCity").options[indexToUse].selected = true;
            }

            var performFindFlag = PhysicalStoreCookieJSStore.getValueFromCookie("WC_stFind");
            if (performFindFlag != null) {
                wcRenderContext.updateRenderContext('storeLocatorResultsContext', {
                    'cityId': document.getElementById("selectCountry").options[indexToUse].value("selectCity").options[indexToUse].value,
                    'fromPage': fromPage
                });
            }
        }
    },

    /**
     * This function adds the user selected physical store to the cookie when the maximum number of physical
     * stores has not reached; otherwise, a message is displayed.
     *
     * @param {String} physicalStoreId The physical store Unique ID to be added.
     * @param {String} optionIndex The index of the physical store to be added.
     *
     * @returns {boolean} A flag to indicate whether the add is performed.
     *
     */
    addPhysicalStore: function (physicalStoreId, optionIndex) {
        if (PhysicalStoreCookieJSStore.isAddOneStoreIdExceedMax() == true) {
            if (document.getElementById("addPhysicalStoreToCookieButton" + optionIndex) != null) {
                MessageHelper.formErrorHandleClient("addPhysicalStoreToCookieButton" + optionIndex, MessageHelper.messages["EXCEED_PHYSICAL_STORE_SIZE"]);
                return false;
            } else {
                MessageHelper.displayErrorMessage(MessageHelper.messages["EXCEED_PHYSICAL_STORE_SIZE"]);
                return false;
            }
        }

        if (!submitRequest()) {
            return;
        }
        cursor_wait();

        PhysicalStoreCookieJSStore.addToCookie(physicalStoreId);
        storeLocatorJSStore.showRemoveOption(physicalStoreId);
        return true;
    },

    /**
     * This function removes the user selected physical store from the cookie.
     *
     * @param {String} physicalStoreId The physical store Unique ID to be removed.
     *
     */
    removePhysicalStore: function (physicalStoreId) {
        PhysicalStoreCookieJSStore.removeFromCookie(physicalStoreId);
        PhysicalStoreCookieJSStore.clearPickUpStoreIdFromCookie(physicalStoreId);
        storeLocatorJSStore.showAddOption(physicalStoreId);
    },

    /**
     * This function shows the disabled "add physical store" option and hides the "add physical store" option
     * of the physical store.
     *
     * @param {String} physicalStoreId The physical store Unique ID.
     *
     */
    showRemoveOption: function (physicalStoreId) {
        var addDisabledDiv = $("#addPhysicalStoreToCookieDisabled" + physicalStoreId);
        var addDiv = $("#addPhysicalStoreToCookie" + physicalStoreId);

        if (addDisabledDiv != null && addDisabledDiv != "undefined") {
            $(addDisabledDiv).css("display", "block");
        }

        if (addDiv != null && addDiv != "undefined") {
            $(addDiv).css("display", "none");
        }
    },

    /**
     * This function shows the "add physical store" option and hides the disabled "add physical store" option
     * of the physical store.
     *
     * @param {String} physicalStoreId The physical store Unique ID.
     *
     */
    showAddOption: function (physicalStoreId) {
        var addDisabledDiv = $("#addPhysicalStoreToCookieDisabled" + physicalStoreId);
        var addDiv = $("#addPhysicalStoreToCookie" + physicalStoreId);

        if (addDisabledDiv != null && addDisabledDiv != "undefined") {
            $(addDisabledDiv).css("display", "none");
        }

        if (addDiv != null && addDiv != "undefined") {
            $(addDiv).css("display", "block");
        }
    },

    /**
     * This function manages the cookie values when OK button is pressed from city search.
     *
     */
    manageCookieFromCity: function () {
        PhysicalStoreCookieJSStore.setValueToCookie('WC_stFind', 1);
    },

    /**
     * This function refreshes the result area when a city is selected.  It refreshes the physical store
     * information.
     *
     * @param form The form that contains the "city" selections.
     * @param {String} fromPage The fromPage parameter value passed by the calling page.
     *
     */
    refreshResultsFromCity: function (form, fromPage) {
        if (form.selectCity.selectedIndex < 0) {
            MessageHelper.formErrorHandleClient(form.selectCity.id, MessageHelper.messages["MISSING_CITY"]);
            return;
        }

        /* manage cookie values */
        storeLocatorJSStore.manageCookieFromCity();

        /* refresh the result area */
        wcRenderContext.updateRenderContext('storeLocatorResultsContext', {
            'cityId': form.selectCity.options[form.selectCity.selectedIndex].value,
            'fromPage': fromPage,
            'geoCodeLatitude': '',
            'geoCodeLongitude': '',
            'errorMsgKey': ''
        });
    },

    /**
     * This function refreshes the result area when the geolocation feature is used.  It refreshes the
     * physical store information.
     *
     * @param {String} geoCodeLatitude The user's latitude coordinate.
     * @param {String} geoCodeLongitude The user's longitude coordinate.
     *
     */
    refreshResultsFromNearest: function (geoCodeLatitude, geoCodeLongitude) {
        PhysicalStoreCookieJSStore.clearValueFromCookie("WC_stCntry");
        PhysicalStoreCookieJSStore.clearValueFromCookie("WC_stProv");
        PhysicalStoreCookieJSStore.clearValueFromCookie("WC_stCity");
        PhysicalStoreCookieJSStore.clearValueFromCookie("WC_stFind");

        /* refresh the result area */
        wcRenderContext.updateRenderContext('storeLocatorResultsContext', {
            'geoCodeLatitude': geoCodeLatitude,
            'geoCodeLongitude': geoCodeLongitude,
            'errorMsgKey': ''
        });
    },

    /**
     * This function refreshes the result area when the geolocation feature is used.  It refreshes the
     * physical store information.
     *
     * @param {String} errorMsgKey The resource key for the error message.
     *
     */
    refreshResultsWithLocationError: function (errorMsgKey) {
        PhysicalStoreCookieJSStore.clearValueFromCookie("WC_stFind");

        /* refresh the result area */
        wcRenderContext.updateRenderContext('storeLocatorResultsContext', {
            'errorMsgKey': errorMsgKey
        });
    },

    /**
     * This function refreshes the store list area.
     *
     * @param {String} fromPage The fromPage parameter value passed by the calling page.
     *
     */
    refreshStoreList: function (fromPage) {
        /* refresh the store list area */
        wcRenderContext.updateRenderContext('selectedStoreListContext', {
            'fromPage': fromPage
        });
    },

    removeFromStoreList: function (fromPage, tableRowId) {
        var numStores = PhysicalStoreCookieJSStore.getNumStores();
        if (numStores == 0) {
            // Refresh to remove complete table and display status message
            this.refreshStoreList(fromPage);
        } else {
            // Just remove store from the table.
            var tableRow = document.getElementById(tableRowId);
            tableRow.remove();
        }
    },

    /**
     * This function hides the store list area.
     *
     */
    hideStoreList: function () {
        var storeListDiv = $("#selectedStoreList");
        var showListHeaderDiv = $("#showStoreListHeader");
        var hideListHeaderDiv = $("#hideStoreListHeader");

        if (storeListDiv != null && storeListDiv != "undefined") {
            $(storeListDiv).css("display", "none");
        }
        if (showListHeaderDiv != null && showListHeaderDiv != "undefined") {
            $(showListHeaderDiv).css("display", "block");
        }
        if (hideListHeaderDiv != null && hideListHeaderDiv != "undefined") {
            $(hideListHeaderDiv).css("display", "none");
        }
    },

    /**
     * This function shows the store list area.
     *
     */
    showStoreList: function () {
        var storeListDiv = $("#selectedStoreList");
        var showListHeaderDiv = $("#showStoreListHeader");
        var hideListHeaderDiv = $("#hideStoreListHeader");

        if (storeListDiv != null && storeListDiv != "undefined") {
            $(storeListDiv).css("display", "block");
        }
        if (showListHeaderDiv != null && showListHeaderDiv != "undefined") {
            $(showListHeaderDiv).css("display", "none");
        }
        if (hideListHeaderDiv != null && hideListHeaderDiv != "undefined") {
            $(hideListHeaderDiv).css("display", "block");
        }
    },

    /**
     * This function is called after the counry selection list is changed.
     *
     * @param {String} countryId The unique ID of the selected country.
     *
     */
    changeCountrySelection: function (countryId) {
        PhysicalStoreCookieJSStore.setValueToCookie("WC_stCntry", countryId);
        PhysicalStoreCookieJSStore.clearValueFromCookie("WC_stProv");
        PhysicalStoreCookieJSStore.clearValueFromCookie("WC_stCity");
        PhysicalStoreCookieJSStore.clearValueFromCookie("WC_stFind");

        wcRenderContext.updateRenderContext("provinceSelectionsContext", {
            "countryId": countryId
        });
    },

    /**
     * This function is called after the province selection list is changed.
     *
     * @param {String} provinceId The unique ID of the selected province.
     *
     */
    changeProvinceSelection: function (provinceId) {
        PhysicalStoreCookieJSStore.setValueToCookie("WC_stProv", provinceId);
        PhysicalStoreCookieJSStore.clearValueFromCookie("WC_stCity");
        PhysicalStoreCookieJSStore.clearValueFromCookie("WC_stFind");

        wcRenderContext.updateRenderContext("citySelectionsContext", {
            "provinceId": provinceId
        });
    },

    /**
     * This function is called after the city selection list is changed.
     *
     * @param {String} cityId The unique ID of the selected city.
     *
     */
    changeCitySelection: function (cityId) {
        PhysicalStoreCookieJSStore.setValueToCookie("WC_stCity", cityId);
        PhysicalStoreCookieJSStore.clearValueFromCookie("WC_stFind");
    },

    /**
     * This function retrieves the index of the country selection list which has a value matches the one saved in
     * the cookie.  Null is returned when cookie does not contain any saved country ID.
     *
     * @returns {int} The index of the country selection list which has a value matches the one saved in the
     * cookie.
     *
     */
    getSavedCountrySelectionIndex: function () {
        var index = null;
        var savedCountryId = PhysicalStoreCookieJSStore.getValueFromCookie("WC_stCntry");
        if (savedCountryId != null) {
            /* search for matching ID */
            var selectedCountryList = $("#selectCountry");
            if (selectedCountryList != null && selectedCountryList != "undefined") {
                var listSize = selectedCountryList.length;
                for (i = 0; i < listSize; i++) {
                    if (savedCountryId == selectedCountryList[0].options[i].value) {
                        index = i;
                        i = listSize;
                    }
                }
            }
        }

        return index;
    },

    /**
     * This function retrieves the index of the province selection list which has a value matches the one saved in
     * the cookie.  Null is returned when cookie does not contain any saved province ID.
     *
     * @returns {int} The index of the province selection list which has a value matches the one saved in the
     * cookie.
     *
     */
    getSavedProvinceSelectionIndex: function () {
        var index = null;
        var savedProvinceId = PhysicalStoreCookieJSStore.getValueFromCookie("WC_stProv");
        if (savedProvinceId != null) {
            /* search for matching ID */
            var selectedProvinceList = $("#selectState");
            if (selectedProvinceList != null && selectedProvinceList != "undefined") {
                var listSize = selectedProvinceList.length;
                for (i = 0; i < listSize; i++) {
                    if (savedProvinceId == selectedProvinceList[0].options[i].value) {
                        index = i;
                        i = listSize;
                    }
                }
            }
        }

        return index;
    },

    /**
     * This function retrieves the index of the city selection list which has a value matches the one saved in
     * the cookie.  Null is returned when cookie does not contain any saved city ID.
     *
     * @returns {int} The index of the city selection list which has a value matches the one saved in the
     * cookie.
     *
     */
    getSavedCitySelectionIndex: function () {
        var index = null;
        var savedCityId = PhysicalStoreCookieJSStore.getValueFromCookie("WC_stCity");
        if (savedCityId != null) {
            /* search for matching ID */
            var selectedCityList = $("#selectCity");
            if (selectedCityList != null && selectedCityList != "undefined") {
                var listSize = selectedCityList[0].options.length;
                for (i = 0; i < listSize; i++) {
                    if (savedCityId == selectedCityList[0].options[i].value) {
                        index = i;
                        i = listSize;
                    }
                }
            }
        }

        return index;
    }

}
