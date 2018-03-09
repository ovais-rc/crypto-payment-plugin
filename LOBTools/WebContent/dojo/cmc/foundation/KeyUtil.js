//-----------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (C) Copyright IBM Corp. 2015, 2016 All Rights Reserved.
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with
// IBM Corp.
//-----------------------------------------------------------------

define([
	"dojo/_base/declare",
	"dojo/on",
	"dojo/query",
	"dojo/sniff",
	"dojo/dom-class",
	"cmc/foundation/EventUtil",
	"dojo/NodeList-traverse"
], function(declare, on, query, has, domClass, EventUtil) {
	return new declare(null, {
		iframeFocusing: false,
		//focus is on iframe of a widget
		downKeysArray: [],
		keyCodes: {
			"enter": 13,
			"spacebar": 32,
			"shift": 16,
			"control": 17,
			"alt": 18,
			"tab": 9,
			"pagedown": 34,
			"pageup": 33,
			"esc": 27,
			"0": 48,
			"1": 49,
			"2": 50,
			"3": 51,
			"4": 52,
			"5": 53,
			"6": 54,
			"7": 55,
			"8": 56,
			"9": 57,
			"a": 65,
			"b": 66,
			"c": 67,
			"d": 68,
			"e": 69,
			"f": 70,
			"g": 71,
			"h": 72,
			"i": 73,
			"j": 74,
			"k": 75,
			"l": 76,
			"m": 77,
			"n": 78,
			"o": 79,
			"p": 80,
			"q": 81,
			"r": 82,
			"s": 83,
			"t": 84,
			"u": 85,
			"v": 86,
			"w": 87,
			"x": 88,
			"y": 89,
			"z": 90,
			"f1": 112,
			"f2": 113,
			"f3": 114,
			"f4": 115,
			"f5": 116,
			"f6": 117,
			"f7": 118,
			"f8": 119,
			"f9": 120,
			"f10": 121,
			"f11": 122,
			"f12": 123
		},
		stopPropagationCodes: {
			9: true,
			13: true,
			0: true,
			37: true,
			38: true,
			39: true,
			40: true			
		},
		keyCombos: {},
		constructor: function() {
			var KeyUtil = this;
			on(document, "keydown", function(e) {
				if (!KeyUtil.skipKeyHandle(e.target)){
					KeyUtil.handleKeyDown(e);
					if ((e.target.tagName.toUpperCase() != 'TEXTAREA' && e.target.tagName.toUpperCase() != 'INPUT' && KeyUtil.stopPropagationCodes[e.keyCode]) ||  KeyUtil.keyCodes["tab"] == e.keyCode) {
						e.stopPropagation();
						e.preventDefault();
					}
				}
			});
			on(document, "keyup", function(e) {
				if (!KeyUtil.skipKeyHandle(e.target)){
					KeyUtil.handleKeyUp(e);
				}
			});
			on(document, "wheel", function(e) {
				var target = e.target;
				var mainContent = query(target).closest("#mainContent")[0];
				if (mainContent){
					//do not trigger scroll event if target is not child of Maincontent, e.g. CKEditor help text popup
					var deltaY = has("mozilla")? -100*e.deltaY : -e.deltaY;
					//Firefox moving slower than others
					EventUtil.trigger(KeyUtil, "onmousewheeldelta", deltaY);
				}
			});
		},
		handleKeyDown: function(e) {
			var keyCode = e.keyCode;
			if (this.downKeysArray.indexOf(keyCode) == -1) {
				this.downKeysArray.push(keyCode);
				this.downKeysArray.sort();
			}
			EventUtil.trigger(this, "onkeydown", keyCode);
			var keys = this.downKeysArray;
			var keyMap = this.keyCombos;
			for (var i = 0; i < keys.length; i++) {
				var keyMapping = keyMap[keys[i]];
				if (typeof keyMapping == "undefined") {
					break;
				}
				if (i == keys.length - 1) {
					if (typeof keyMapping.handlers != "undefined") {
						for (var j = keyMapping.handlers.length - 1; j >= 0; j--) {
							keyMapping.handlers[j].execute(keys);
						}
					}
				}
				else {
					keyMap = keyMapping;
				}
			}
		},
		handleKeyUp: function(e) {
			var keyCode = e.keyCode;
			var index = this.downKeysArray.indexOf(keyCode);
			if (index != -1) {
				this.downKeysArray.splice(index, 1);
			}
			EventUtil.trigger(this, "onkeyup", keyCode);
		},
		callOnKeyCombo: function(handler, keyArray) {
			var keys = [];
			for (var i = 0; i < keyArray.length; i++) {
				var kc = this.keyCodes[keyArray[i].toLowerCase()];
				if (typeof kc == "undefined") {
					console.log("undefined key "+keyArray[i]);
				}
				keys.push(kc);
			}
			keys.sort();
			var keyMap = this.keyCombos;
			for (var i = 0; i < keys.length; i++) {
				var keyMapping = keyMap[keys[i]];
				if (typeof keyMapping == "undefined") {
					keyMapping = {};
					keyMap[keys[i]] = keyMapping;
				}
				if (i == keys.length - 1) {
					if (typeof keyMapping.handlers == "undefined") {
						keyMapping.handlers = [];
					}
					if (keyMapping.handlers.indexOf(handler) == -1) {
						keyMapping.handlers.push(handler);
					}
				}
				else {
					keyMap = keyMapping;
				}
			}
		},
		removeKeyComboCall: function(handler, keyArray) {
			var keys = [];
			for (var i = 0; i < keyArray.length; i++) {
				keys.push(this.keyCodes[keyArray[i].toLowerCase()]);
			}
			keys.sort();
			var keyMap = this.keyCombos;
			for (var i = 0; i < keys.length; i++) {
				var keyMapping = keyMap[keys[i]];
				if (typeof keyMapping == "undefined") {
					break;
				}
				if (i == keys.length - 1) {
					if (typeof keyMapping.handlers != "undefined") {
						var index = keyMapping.handlers.indexOf(handler);
						if (index != -1) {
							keyMapping.handlers.splice(index, 1);
						}
					}
				}
				else {
					keyMap = keyMapping;
				}
			}
		},
		isKeyDown: function(key) {
			var keyCode = typeof this.keyCodes[key] != "undefined" ? this.keyCodes[key] : key;
			return this.downKeysArray.indexOf(keyCode) != -1;
		},
		__allKeysUp: function() {
			if (!this.iframeFocusing){
			//handle ck eidtor iframe case
				this.downKeysArray = [];
			}
		},
		skipKeyHandle: function(node) {
		//skip keyHandle for ck editor toolbar
			return domClass.contains(node, "cke_button") || domClass.contains(node, "cke_combo_button");
		},
		setIframeBlurTimeout: function(){
			this._iframeBlurTimer = setTimeout(function(){
				this.iframeFocusing = false;
			}, 3000);
		},
		clearIframeBlurTimeout: function(){
			if (this._iframeBlurTimer){
				clearTimeout(this._iframeBlurTimer);
				this._iframeBlurTimer = undefined;
			}
		}
	})();
});