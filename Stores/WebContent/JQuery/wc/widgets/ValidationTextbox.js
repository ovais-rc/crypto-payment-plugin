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

/*global jQuery, $, window, setTimeout, clearTimeout, Utils */

/* 
 * ValidationTextbox
 * 
 * IMPORTANT: REQUIRES "custom.wcToolTip" to work
 *
 */
(function () {

    /*
     * New options (in addition to ones inherited from $.Widget):
     * 
     * OPTIONAL:
     * regExp: {string} a JavaScript regular expression String for the valid input
     * canBeEmpty: {boolean} {default: true} true if the textbox is allowed to be empty, false otherwise
     * trimBeforeValidation: {boolean} {default: true} true if the textbox value should be trimmed before
     *                       validation, false otherwise.
     * invalidMessage: {string} the message to display as tooltip if the input is invalid
     * submitButton: {string} a jQuery selector of the button that will submit the form that contains 
     *               this ValidationTextbox. Will disable the button if the contents of this ValidationTextbox
     *               is invalid. 
     * submitButtonDisabledClass: {string} {default: disable} the CSS class to add to the submit button
     *                           if it is disabled
     * errorClass: {string} {default: "error"} the CSS class to add to this ValidationTextbox if the 
     *             input is invalid
     * customValidateFunction: {function} Customized validate function, return error message
     * onValidInput: {function(string)} a function that gets called each time the user enters a valid input (if 
     *                          the user enters invalid input, this function is not called). The text in the textbox
     *                          is passed to the function.
     * REQUIRED: 
     * (None)
     */
    $.widget("wc.ValidationTextbox", $.Widget, {
        options: {
            canBeEmpty: true,
            trimBeforeValidation: true,
            errorClass: "error",
            submitButtonDisabledClass: "disabled",
            invalidMessage: null
        },

        _create: function () {
            this._super(this);

            if (this.options.regExp) {
                this.regExp = new RegExp(this.options.regExp);
            }
            
            this.element.addClass("wcValidationTextbox");
            
            if (this.options.submitButton) {
                this.submitButton = $(this.options.submitButton);
            }
            this.element.bind("input propertychange", $.proxy(function(evt) {
                // Validate the value in text box and create error message tooltip when necessary
                if (this.validationAndErrorHandler() && this.options.onValidInput) {
                    this.options.onValidInput($(this.element).prop("value"));
                }
            }, this));
        },
        
        /**
        * Toggle the submit button associated with this Validation Textbox
        *
        * @param enable true if the submit button should be enabled, false otherwise
        */
        toggleSubmitButton: function(enable) {
            if (this.options.submitButton && this.submitButton.length) {
                if (enable) {
                    this.submitButton.removeClass(this.options.submitButtonDisabledClass);
                } else {
                    this.submitButton.addClass(this.options.submitButtonDisabledClass);
                }
                if (this.submitButton.is("a")) {
                    Utils.toggleHyperlink(this.submitButton, enable);
                    
                } else if (this.submitButton.is("input")) {
                    this.submitButton.prop('disabled', !enable);
                    
                } else {
                    console.err("don't know how to disable: " + this.submitButton);
                }
                
            }
        },
        
        /**
        * Returns true if the given value matches format defined in regExp, false otherwise.
        */
        validateFormat: function(value) {
            if (Utils.isBoolean(this.options.canBeEmpty) && value === "") {
                return this.options.canBeEmpty;
            } else if (this.options.regExp && !this.regExp.test(value)){
                return false;
            }
            return true;
        },

        /**
        * Create error message tooltip and return false when the value in text box fails in format validation and 
        * customized validation check (if customValidateFunction is specified).
        * Remove tooltip and return true when the value is valid.
        */
        validationAndErrorHandler: function() {
            var $textbox = $(this.element),
                value = this.element.val();

            if (this.options.trimBeforeValidation) {
                value = $.trim(value);
            }

            var errorMessage = null;
            if (!this.validateFormat(value)) {
                errorMessage = this.options.invalidMessage;
            }
            if (errorMessage == null && this.options.customValidateFunction != null && this.options.customValidateFunction != undefined) {
                errorMessage = this.options.customValidateFunction();
            }

            if (errorMessage == null) {
                // Remove tooltip and return true when no error
                if ($textbox.hasClass(this.options.errorClass)) {
                    $textbox.removeClass(this.options.errorClass);
                    if (this.tooltip) {
                        this.tooltip.destroy();
                        this.tooltip = null;
                    }
                    this.toggleSubmitButton(true);
                }

                return true;
            } else if (this.tooltip && this.element.data("tooltip-content") && this.element.data("tooltip-content") != errorMessage) {
                // Change error message if necessary
                this.element.data("tooltip-content", errorMessage);
                this.tooltip.tooltip.find(".content").text(errorMessage);
                this.tooltip.show_popup();
            } else if (this.tooltip) {
                // Show error message tooltip if there's already one
                this.tooltip.show_popup();
            } else {
                // Create tooltip when error message is not null
                if (!$textbox.hasClass(this.options.errorClass)) {
                    $textbox.addClass(this.options.errorClass);
                    this.element.data("tooltip-content", errorMessage);
                    this.tooltip = this.element.wcToolTip().data("custom-wcToolTip");
                    this.tooltip.show_popup();
                    this.toggleSubmitButton(false);
                }
            }

            // Return false if there's error
            return false;
        }
    });

}());