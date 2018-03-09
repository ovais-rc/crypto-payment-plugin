//-----------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (C) Copyright IBM Corp. 2013, 2015 All Rights Reserved.
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with
// IBM Corp.
//-----------------------------------------------------------------

define([
	"cmc/foundation/Node",
	"cmc/shell/Logger",
	"dojo/_base/declare"
], function(Node, Logger, declare) {
	/*
		@keywords private
		
		A XML Utility Class.
	*/
	return new declare(Node.Class, {
		getFirstElement: function(e, nodeName) {
			var children = e.childNodes;
			var child;
			var rs = null;
			for (var i = 0; i < children.length; i++) {
				child = children[i];
				if (child.nodeName == nodeName) {
					rs = child;
					break;
				}
			}
			return rs;
		},

		getNodeValue: function(e) {
			var nodeValue = "";
			var nodes = e.childNodes;
			for (var i = 0; i < nodes.length; i++) {
				var thisNode = nodes[i];
				if (thisNode != null && (thisNode.nodeType == 3 || thisNode.nodeType == 4)) {
					nodeValue += thisNode.nodeValue;
				}
			}
			return nodeValue;
		},

		parseXML: function(xml) {
			var rs = null;
			if (xml != null && xml != "") {
				var dom = dojox.xml.parser.parse(xml);
				rs = dom.documentElement;
				if (rs != null) {
					var elements = [rs];
					while (elements.length > 0) {
						var newElements = [];
						for (var i = 0; i < elements.length; i++) {
							var element = elements[i];
							var whitespaceNodes = [];
							for (var j = 0; j < element.childNodes.length; j++) {
								var node = element.childNodes[j];
								if (node.nodeType == 1) {
									newElements.push(node);
								}
								else if (node.nodeType == 3 || node.nodeType == 4) {
									if (node.nodeValue == null || node.nodeValue.trim().length == 0) {
										whitespaceNodes.push(node);
									}
								}
								else {
									element.removeChild(node);
									j--;
								}
							}
							for (var j = 0; j < whitespaceNodes.length; j++) {
								element.removeChild(whitespaceNodes[j]);
							}
						}
						elements = newElements;
					}
				}
			}
			return rs;
		},
		
		innerXML: function(node){
			var textValue = null;
			if (node != null){
				textValue = dojox.xml.parser.innerXML(node);					
			}
			return textValue;
		}
	})();
});