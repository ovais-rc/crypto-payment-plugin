//-----------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (C) Copyright IBM Corp. 2016 All Rights Reserved.
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with
// IBM Corp.
//-----------------------------------------------------------------

/* global $, window */

var arrayUtils = arrayUtils || {

    /**
     * Given an array and a comparison function, performs stable sort on the given array.
     * The comparison function must return 0 (and not just any falsy value) if the elements 
     * are equal for this function to work as expected. The given array and its elements are 
     * not modified. Returns a new array. This function was written since the built-in 
     * JavaScript [].sort is not guaranteed to be stable.
     */
    stableSort: function (arr, cmp) {
        // Create a new array that also has the index of each element
        var newArr = arr.map(function (e, i) {
            return {
                element: e,
                index: i
            };
        });

        // Uses the JavaScript built-in sort, but if two elements are equal, compare
        // by their index
        return newArr.sort(function (a, b) {
            var cmpResult = cmp(a.element, b.element);
            if (cmpResult === 0) {
                return a.index - b.index;
            } else {
                return cmpResult;
            }
        }).map(function(e) {
            return e.element;
        });
    },
    
    /**
    * Returns true if the given array holds a transitive property defined by the given predicate. 
    * For instance, to check if an array is sorted, it suffices to check whether the sorted property
    * holds for each consecutive elements. If an array has zero or one element, this function 
    * vacuously returns true.
    *
    * @param arr an array
    * @param predicate a function that takes two arguments and trues if the two arguments satisfy some
    * relationship and false otherwise. 
    */
    verifyTransitiveProperty: function(arr, predicate) {
        var i;
        for (i = 0; i < arr.length - 1; i++) {
            if (!predicate(arr[i], arr[i+1])) {
                return false;
            }
        }
        return true;
    },
    
    /**
    * Returns true if the given array is empty.
    */
    isEmpty: function(arr) {
        return arr.length === 0;
    },
    
    /**
    * Returns the last element in an array. Returns undefined if the array is empty.
    */
    last: function(arr) {
        if (this.isEmpty(arr)) {
            return undefined;
        }
        return arr[arr.length - 1];
    },
    
    /**
    * Given an array returns a new array where the elements of the given array are divided into
    * subarrays. Each subarray contains up to the given count.  
    *
    * Example:
    * arrTo2D([1,2,3,4,5,6,7,8,9], 3) -> [[1,2,3],[4,5,6],[7,8,9]]
    * arrTo2D([1,2,3,4,5,6,7,8,9,10], 3) -> [[1,2,3],[4,5,6],[7,8,9],[10]]
    */
    arrTo2D: function(arr, count) {
        if (typeof count === 'undefined') {
            throw "The number of columns to divide the array into is undefined";
        }
        var newArr = [];
        while(arr.length) {
            newArr.push(arr.splice(0,count));
        }
        return newArr;
    }
}