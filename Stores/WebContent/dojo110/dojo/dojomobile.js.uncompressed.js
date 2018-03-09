require({cache:{
'dojox/mobile/ViewController':function(){
define([
	"dojo/_base/kernel",
	"dojo/_base/array",
	"dojo/_base/connect",
	"dojo/_base/declare",
	"dojo/_base/lang",
	"dojo/_base/window",
	"dojo/_base/Deferred",
	"dojo/dom",
	"dojo/dom-class",
	"dojo/dom-construct",
	"dojo/on",
	"dojo/ready",
	"dijit/registry",
	"./ProgressIndicator",
	"./TransitionEvent",
	"./viewRegistry"
], function(dojo, array, connect, declare, lang, win, Deferred, dom, domClass, domConstruct, on, ready, registry, ProgressIndicator, TransitionEvent, viewRegistry){

	// module:
	//		dojox/mobile/ViewController

	var Controller = declare("dojox.mobile.ViewController", null, {
		// summary:
		//		A singleton class that controls view transition.
		// description:
		//		This class listens to the "startTransition" events and performs
		//		view transitions. If the transition destination is an external
		//		view specified with the url parameter, the view content is
		//		retrieved and parsed to create a new target view.

		// dataHandlerClass: Object
		//		The data handler class used to load external views,
		//		by default "dojox/mobile/dh/DataHandler"
		//		(see the Data Handlers page in the reference documentation).
		dataHandlerClass: "dojox/mobile/dh/DataHandler",
		// dataSourceClass: Object
		//		The data source class used to load external views,
		//		by default "dojox/mobile/dh/UrlDataSource"
		//		(see the Data Handlers page in the reference documentation).
		dataSourceClass: "dojox/mobile/dh/UrlDataSource",
		// fileTypeMapClass: Object
		//		The file type map class used to load external views,
		//		by default "dojox/mobile/dh/SuffixFileTypeMap"
		//		(see the Data Handlers page in the reference documentation).
		fileTypeMapClass: "dojox/mobile/dh/SuffixFileTypeMap",

		constructor: function(){
			// summary:
			//		Creates a new instance of the class.
			// tags:
			//		private
			this.viewMap = {};
			ready(lang.hitch(this, function(){
				on(win.body(), "startTransition", lang.hitch(this, "onStartTransition"));
			}));
		},

		findTransitionViews: function(/*String*/moveTo){
			// summary:
			//		Parses the moveTo argument and determines a starting view and a destination view.
			// returns: Array
			//		An array containing the currently showing view, the destination view
			//		and the transition parameters, or an empty array if the moveTo argument
			//		could not be parsed. 
			if(!moveTo){ return []; }
			// removes a leading hash mark (#) and params if exists
			// ex. "#bar&myParam=0003" -> "bar"
			moveTo.match(/^#?([^&?]+)(.*)/);
			var params = RegExp.$2;
			var view = registry.byId(RegExp.$1);
			if(!view){ return []; }
			for(var v = view.getParent(); v; v = v.getParent()){ // search for the topmost invisible parent node
				if(v.isVisible && !v.isVisible()){
					var sv = view.getShowingView();
					if(sv && sv.id !== view.id){
						view.show();
					}
					view = v;
				}
			}
			return [view.getShowingView(), view, params]; // fromView, toView, params
		},

		openExternalView: function(/*Object*/ transOpts, /*DomNode*/ target){
			// summary:
			//		Loads an external view and performs a transition to it.
			// returns: dojo/_base/Deferred
			//		Deferred object that resolves when the external view is
			//		ready and a transition starts. Note that it resolves before
			//		the transition is complete.
			// description:
			//		This method loads external view content through the
			//		dojox/mobile data handlers, creates a new View instance with
			//		the loaded content, and performs a view transition to the
			//		new view. The external view content can be specified with
			//		the url property of transOpts. The new view is created under
			//		a DOM node specified by target.
			//
			// example:
			//		This example loads view1.html, creates a new view under
			//		`<body>`, and performs a transition to the new view with the
			//		slide animation.
			//		
			//	|	var vc = ViewController.getInstance();
			//	|	vc.openExternalView({
			//	|	    url: "view1.html", 
			//	|	    transition: "slide"
			//	|	}, win.body());
			//
			//
			// example:
			//		If you want to perform a view transition without animation,
			//		you can give transition:"none" to transOpts.
			//
			//	|	var vc = ViewController.getInstance();
			//	|	vc.openExternalView({
			//	|	    url: "view1.html", 
			//	|	    transition: "none"
			//	|	}, win.body());
			//
			// example:
			//		If you want to dynamically create an external view, but do
			//		not want to perform a view transition to it, you can give noTransition:true to transOpts.
			//		This may be useful when you want to preload external views before the user starts using them.
			//
			//	|	var vc = ViewController.getInstance();
			//	|	vc.openExternalView({
			//	|	    url: "view1.html", 
			//	|	    noTransition: true
			//	|	}, win.body());
			//
			// example:
			//		To do something when the external view is ready:
			//
			//	|	var vc = ViewController.getInstance();
			//	|	Deferred.when(vc.openExternalView({...}, win.body()), function(){
			//	|	    doSomething();
			//	|	});

			var d = new Deferred();
			var id = this.viewMap[transOpts.url];
			if(id){
				transOpts.moveTo = id;
				if(transOpts.noTransition){
					registry.byId(id).hide();
				}else{
					new TransitionEvent(win.body(), transOpts).dispatch();
				}
				d.resolve(true);
				return d;
			}

			// if a fixed bottom bar exists, a new view should be placed before it.
			var refNode = null;
			for(var i = target.childNodes.length - 1; i >= 0; i--){
				var c = target.childNodes[i];
				if(c.nodeType === 1){
					var fixed = c.getAttribute("fixed") // TODO: Remove the non-HTML5-compliant attribute in 2.0
						|| c.getAttribute("data-mobile-fixed")
						|| (registry.byNode(c) && registry.byNode(c).fixed);
					if(fixed === "bottom"){
						refNode = c;
						break;
					}
				}
			}

			var dh = transOpts.dataHandlerClass || this.dataHandlerClass;
			var ds = transOpts.dataSourceClass || this.dataSourceClass;
			var ft = transOpts.fileTypeMapClass || this.fileTypeMapClass;
			require([dh, ds, ft], lang.hitch(this, function(DataHandler, DataSource, FileTypeMap){
				var handler = new DataHandler(new DataSource(transOpts.data || transOpts.url), target, refNode);
				var contentType = transOpts.contentType || FileTypeMap.getContentType(transOpts.url) || "html";
				handler.processData(contentType, lang.hitch(this, function(id){
					if(id){
						this.viewMap[transOpts.url] = transOpts.moveTo = id;
						if(transOpts.noTransition){
							registry.byId(id).hide();
						}else{
							new TransitionEvent(win.body(), transOpts).dispatch();
						}
						d.resolve(true);
					}else{
						d.reject("Failed to load "+transOpts.url);
					}
				}));
			}));
			return d;
		},

		onStartTransition: function(evt){
			// summary:
			//		A handler that performs view transition.
			evt.preventDefault();
			if(!evt.detail){ return; }
			var detail = evt.detail;
			if(!detail.moveTo && !detail.href && !detail.url && !detail.scene){ return; }

			if(detail.url && !detail.moveTo){
				var urlTarget = detail.urlTarget;
				var w = registry.byId(urlTarget);
				var target = w && w.containerNode || dom.byId(urlTarget);
				if(!target){
					w = viewRegistry.getEnclosingView(evt.target);
					target = w && w.domNode.parentNode || win.body();
				}
				var src = registry.getEnclosingWidget(evt.target);
				if(src && src.callback){
					detail.context = src;
					detail.method = src.callback;
				}
				this.openExternalView(detail, target);
				return;
			}else if(detail.href){
				if(detail.hrefTarget && detail.hrefTarget != "_self"){
					win.global.open(detail.href, detail.hrefTarget);
				}else{
					var view; // find top level visible view
					for(var v = viewRegistry.getEnclosingView(evt.target); v; v = viewRegistry.getParentView(v)){
						view = v;
					}
					if(view){
						view.performTransition(null, detail.transitionDir, detail.transition, evt.target, function(){location.href = detail.href;});
					}
				}
				return;
			}else if(detail.scene){
				connect.publish("/dojox/mobile/app/pushScene", [detail.scene]);
				return;
			}

			var arr = this.findTransitionViews(detail.moveTo),
				fromView = arr[0],
				toView = arr[1],
				params = arr[2];
			if(!location.hash && !detail.hashchange){
				viewRegistry.initialView = fromView;
			}
			if(detail.moveTo && toView){
				detail.moveTo = (detail.moveTo.charAt(0) === '#' ? '#' + toView.id : toView.id) + params;
			}
			if(!fromView || (detail.moveTo && fromView === registry.byId(detail.moveTo.replace(/^#?([^&?]+).*/, "$1")))){ return; }
			src = registry.getEnclosingWidget(evt.target);
			if(src && src.callback){
				detail.context = src;
				detail.method = src.callback;
			}
			fromView.performTransition(detail);
		}
	});
	Controller._instance = new Controller(); // singleton
	Controller.getInstance = function(){
		return Controller._instance;
	};
	return Controller;
});


},
'dojox/mobile/RoundRectList':function(){
define([
	"dojo/_base/array",
	"dojo/_base/declare",
	"dojo/_base/event",
	"dojo/_base/lang",
	"dojo/_base/window",
	"dojo/dom-construct",
	"dojo/dom-attr",
	"dijit/_Contained",
	"dijit/_Container",
	"dijit/_WidgetBase"
], function(array, declare, event, lang, win, domConstruct, domAttr, Contained, Container, WidgetBase){

	// module:
	//		dojox/mobile/RoundRectList

	return declare("dojox.mobile.RoundRectList", [WidgetBase, Container, Contained], {
		// summary:
		//		A rounded rectangle list.
		// description:
		//		RoundRectList is a rounded rectangle list, which can be used to
		//		display a group of items. Each item must be a dojox/mobile/ListItem.

		// transition: String
		//		The default animated transition effect for child items.
		transition: "slide",

		// iconBase: String
		//		The default icon path for child items.
		iconBase: "",

		// iconPos: String
		//		The default icon position for child items.
		iconPos: "",

		// select: String
		//		Selection mode of the list. The check mark is shown for the
		//		selected list item(s). The value can be "single", "multiple", or "".
		//		If "single", there can be only one selected item at a time.
		//		If "multiple", there can be multiple selected items at a time.
		//		If "", the check mark is not shown.
		select: "",

		// stateful: Boolean
		//		If true, the last selected item remains highlighted.
		stateful: false,

		// syncWithViews: [const] Boolean
		//		If true, this widget listens to view transition events to be
		//		synchronized with view's visibility.
		//		Note that changing the value of the property after the widget
		//		creation has no effect.
		syncWithViews: false,

		// editable: [const] Boolean
		//		If true, the list can be reordered.
		//		Note that changing the value of the property after the widget
		//		creation has no effect.
		editable: false,

		// tag: String
		//		A name of html tag to create as domNode.
		tag: "ul",

		/* internal properties */
		// editableMixinClass: String
		//		The name of the mixin class.
		editableMixinClass: "dojox/mobile/_EditableListMixin",
		
		// baseClass: String
		//		The name of the CSS class of this widget.
		baseClass: "mblRoundRectList",
		
		// filterBoxClass: String
		//		The name of the CSS class added to the DOM node inside which is placed the 
		//		dojox/mobile/SearchBox created when mixing dojox/mobile/FilteredListMixin.
		//		The default value is "mblFilteredRoundRectListSearchBox".  
		filterBoxClass: "mblFilteredRoundRectListSearchBox",

		buildRendering: function(){
			this.domNode = this.srcNodeRef || domConstruct.create(this.tag);
			if(this.select){
				domAttr.set(this.domNode, "role", "listbox");
				if(this.select === "multiple"){
					domAttr.set(this.domNode, "aria-multiselectable", "true");
				}
			}
			this.inherited(arguments);
		},

		postCreate: function(){
			if(this.editable){
				require([this.editableMixinClass], lang.hitch(this, function(module){
					declare.safeMixin(this, new module());
				}));
			}
			this.connect(this.domNode, "onselectstart", event.stop);

			if(this.syncWithViews){ // see also TabBar#postCreate
				var f = function(view, moveTo, dir, transition, context, method){
					var child = array.filter(this.getChildren(), function(w){
						return w.moveTo === "#" + view.id || w.moveTo === view.id; })[0];
					if(child){ child.set("selected", true); }
				};
				this.subscribe("/dojox/mobile/afterTransitionIn", f);
				this.subscribe("/dojox/mobile/startView", f);
			}
		},

		resize: function(){
			// summary:
			//		Calls resize() of each child widget.
			array.forEach(this.getChildren(), function(child){
				if(child.resize){ child.resize(); }
			});
		},

		onCheckStateChanged: function(/*Widget*//*===== listItem, =====*/ /*String*//*===== newState =====*/){
			// summary:
			//		Stub function to connect to from your application.
			// description:
			//		Called when the check state has been changed.
		},

		_setStatefulAttr: function(stateful){
			// tags:
			//		private
			this._set("stateful", stateful);
			this.selectOne = stateful;
			array.forEach(this.getChildren(), function(child){
				child.setArrow && child.setArrow();
			});
		},

		deselectItem: function(/*dojox/mobile/ListItem*/item){
			// summary:
			//		Deselects the given item.
			item.set("selected", false);
		},

		deselectAll: function(){
			// summary:
			//		Deselects all the items.
			array.forEach(this.getChildren(), function(child){
				child.set("selected", false);
			});
		},

		selectItem: function(/*ListItem*/item){
			// summary:
			//		Selects the given item.
			item.set("selected", true);
		}
	});
});

},
'dojox/mobile/RoundRect':function(){
define([
	"dojo/_base/declare",
	"dojo/dom-class",
	"./Container"
], function(declare, domClass, Container){

	// module:
	//		dojox/mobile/RoundRect

	return declare("dojox.mobile.RoundRect", Container, {
		// summary:
		//		A simple round rectangle container.
		// description:
		//		RoundRect is a simple round rectangle container for any HTML
		//		and/or widgets. You can achieve the same appearance by just
		//		applying the -webkit-border-radius style to a div tag. However,
		//		if you use RoundRect, you can get a round rectangle even on
		//		non-CSS3 browsers such as (older) IE.

		// shadow: [const] Boolean
		//		If true, adds a shadow effect to the container element by adding
		//		the CSS class "mblShadow" to widget's domNode. The default value
		//		is false. Note that changing the value of the property after
		//		the widget creation has no effect.
		shadow: false,

		/* internal properties */	
		
		// baseClass: String
		//		The name of the CSS class of this widget.
		baseClass: "mblRoundRect",

		buildRendering: function(){
			this.inherited(arguments);
			if(this.shadow){
				domClass.add(this.domNode, "mblShadow");
			}
		}
	});
});

},
'dojox/mobile/_ScrollableMixin':function(){
define([
	"dojo/_base/kernel",
	"dojo/_base/config",
	"dojo/_base/declare",
	"dojo/_base/lang",
	"dojo/_base/window",
	"dojo/dom",
	"dojo/dom-class",
	"dijit/registry",	// registry.byNode
	"./scrollable"
], function(dojo, config, declare, lang, win, dom, domClass, registry, Scrollable){
	// module:
	//		dojox/mobile/_ScrollableMixin

	var cls = declare("dojox.mobile._ScrollableMixin", Scrollable, {
		// summary:
		//		Mixin for widgets to have a touch scrolling capability.
	
		// fixedHeader: String
		//		Id of the fixed header.
		fixedHeader: "",

		// fixedFooter: String
		//		Id of the fixed footer.
		fixedFooter: "",

		_fixedAppFooter: "",

		// scrollableParams: Object
		//		Parameters for dojox/mobile/scrollable.init().
		scrollableParams: null,

		// allowNestedScrolls: Boolean
		//		Flag to allow scrolling in nested containers, e.g. to allow ScrollableView in a SwapView.
		allowNestedScrolls: true,

		// appBars: Boolean
		//		Enables the search for application-specific bars (header or footer).
		appBars: true, 

		constructor: function(){
			// summary:
			//		Creates a new instance of the class.
			// tags:
			//		private
			this.scrollableParams = {};
		},

		destroy: function(){
			this.cleanup();
			this.inherited(arguments);
		},

		startup: function(){
			if(this._started){ return; }
			if(this._fixedAppFooter){
				this._fixedAppFooter = dom.byId(this._fixedAppFooter);
			}
			this.findAppBars();
			var node, params = this.scrollableParams;
			if(this.fixedHeader){
				node = dom.byId(this.fixedHeader);
				if(node.parentNode == this.domNode){ // local footer
					this.isLocalHeader = true;
				}
				params.fixedHeaderHeight = node.offsetHeight;
			}
			if(this.fixedFooter){
				node = dom.byId(this.fixedFooter);
				if(node.parentNode == this.domNode){ // local footer
					this.isLocalFooter = true;
					node.style.bottom = "0px";
				}
				params.fixedFooterHeight = node.offsetHeight;
			}
			this.scrollType = this.scrollType || config.mblScrollableScrollType || 0;
			this.init(params);
			if(this.allowNestedScrolls){
				for(var p = this.getParent(); p; p = p.getParent()){
					if(p && p.scrollableParams){
						this.dirLock = true;
						p.dirLock = true;
						break;
					}
				}
			}
			// subscribe to afterResizeAll to scroll the focused input field into view
			// so as not to break layout on orientation changes while keyboard is shown (#14991)
			this._resizeHandle = this.subscribe("/dojox/mobile/afterResizeAll", function(){
				if(this.domNode.style.display === 'none'){ return; }
				var elem = win.doc.activeElement;
				if(this.isFormElement(elem) && dom.isDescendant(elem, this.containerNode)){
					this.scrollIntoView(elem);
				}
			});
			this.inherited(arguments);
		},

		findAppBars: function(){
			// summary:
			//		Search for application-specific header or footer.
			if(!this.appBars){ return; }
			var i, len, c;
			for(i = 0, len = win.body().childNodes.length; i < len; i++){
				c = win.body().childNodes[i];
				this.checkFixedBar(c, false);
			}
			if(this.domNode.parentNode){
				for(i = 0, len = this.domNode.parentNode.childNodes.length; i < len; i++){
					c = this.domNode.parentNode.childNodes[i];
					this.checkFixedBar(c, false);
				}
			}
			this.fixedFooterHeight = this.fixedFooter ? this.fixedFooter.offsetHeight : 0;
		},

		checkFixedBar: function(/*DomNode*/node, /*Boolean*/local){
			// summary:
			//		Checks if the given node is a fixed bar or not.
			if(node.nodeType === 1){
				var fixed = node.getAttribute("fixed") // TODO: Remove the non-HTML5-compliant attribute in 2.0
					|| node.getAttribute("data-mobile-fixed")
					|| (registry.byNode(node) && registry.byNode(node).fixed);
				if(fixed === "top"){
					domClass.add(node, "mblFixedHeaderBar");
					if(local){
						node.style.top = "0px";
						this.fixedHeader = node;
					}
					return fixed;
				}else if(fixed === "bottom"){
					domClass.add(node, "mblFixedBottomBar");
					if(local){
						this.fixedFooter = node;
					}else{
						this._fixedAppFooter = node;
					}
					return fixed;
				}
			}
			return null;
		}
	});
	return cls;
});

},
'dojox/mobile/viewRegistry':function(){
define([
	"dojo/_base/array",
	"dojo/dom-class",
	"dijit/registry"
], function(array, domClass, registry){

	// module:
	//		dojox/mobile/viewRegistry

	var viewRegistry = {
		// summary:
		//		A registry of existing views.

		// length: Number
		//		The number of registered views.
		length: 0,
		
		// hash: [private] Object
		//		The object used to register views.
		hash: {},
		
		// initialView: [private] dojox/mobile/View
		//		The initial view.
		initialView: null,

		add: function(/*dojox/mobile/View*/ view){
			// summary:
			//		Adds a view to the registry.
			this.hash[view.id] = view;
			this.length++;
		},

		remove: function(/*String*/ id){
			// summary:
			//		Removes a view from the registry.
			if(this.hash[id]){
				delete this.hash[id];
				this.length--;
			}
		},

		getViews: function(){
			// summary:
			//		Gets all registered views.
			// returns: Array
			var arr = [];
			for(var i in this.hash){
				arr.push(this.hash[i]);
			}
			return arr;
		},

		getParentView: function(/*dojox/mobile/View*/ view){
			// summary:
			//		Gets the parent view of the specified view.
			// returns: dojox/mobile/View
			for(var v = view.getParent(); v; v = v.getParent()){
				if(domClass.contains(v.domNode, "mblView")){ return v; }
			}
			return null;
		},

		getChildViews: function(/*dojox/mobile/View*/ parent){
			// summary:
			//		Gets the children views of the specified view.
			// returns: Array
			return array.filter(this.getViews(), function(v){ return this.getParentView(v) === parent; }, this);
		},

		getEnclosingView: function(/*DomNode*/ node){
			// summary:
			//		Gets the view containing the specified DOM node.
			// returns: dojox/mobile/View
			for(var n = node; n && n.tagName !== "BODY"; n = n.parentNode){
				if(n.nodeType === 1 && domClass.contains(n, "mblView")){
					return registry.byNode(n);
				}
			}
			return null;
		},

		getEnclosingScrollable: function(/*DomNode*/ node){
			// summary:
			//		Gets the dojox/mobile/scrollable object containing the specified DOM node.
			// returns: dojox/mobile/scrollable
			for(var w = registry.getEnclosingWidget(node); w; w = w.getParent()){
				if(w.scrollableParams && w._v){ return w; }
			}
			return null;
		}
	};

	return viewRegistry;
});

},
'dojox/mobile/sniff':function(){
define([
	"dojo/_base/kernel",
	"dojo/sniff"
], function(kernel, has){

	kernel.deprecated("dojox/mobile/sniff", "Use dojo/sniff instead", "2.0");
	
	// TODO: remove this in 2.0
	has.add("iphone", has("ios"));

	/*=====
	return {
		// summary:
		//		Deprecated: use dojo/sniff instead.
		//		On iOS, dojox/mobile/sniff sets "iphone" to the same value as "ios"
		//		for compatibility with earlier versions, but this should be considered deprecated.
		//		In future versions, "iphone" will be set only when running on an iPhone (not iPad on iPod).
	};
	=====*/
	return has;
});

},
'dojox/mobile/TransitionEvent':function(){
define(["dojo/_base/declare", "dojo/on"], function(declare, on){

	return declare("dojox.mobile.TransitionEvent", null, {
		// summary:
		//		A class used to trigger view transitions.
		
		constructor: function(/*DomNode*/target, /*Object*/transitionOptions, /*Event?*/triggerEvent){
			// summary:
			//		Creates a transition event.
			// target:
			//		The DOM node that initiates the transition (for example a ListItem).
			// transitionOptions:
			//		Contains the transition options.
			// triggerEvent:
			//		The event that triggered the transition (for example a touch event on a ListItem).
			this.transitionOptions = transitionOptions;
			this.target = target;
			this.triggerEvent = triggerEvent||null;
		},

		dispatch: function(){
			// summary:
			//		Dispatches this transition event. Emits a "startTransition" event on the target.
			var opts = {bubbles:true, cancelable:true, detail: this.transitionOptions, triggerEvent: this.triggerEvent};	
			var evt = on.emit(this.target,"startTransition", opts);
		}
	});
});

},
'dijit/form/_TextBoxMixin':function(){
define([
	"dojo/_base/array", // array.forEach
	"dojo/_base/declare", // declare
	"dojo/dom", // dom.byId
	"dojo/sniff",	// has("ie"), has("dojo-bidi")
	"dojo/keys", // keys.ALT keys.CAPS_LOCK keys.CTRL keys.META keys.SHIFT
	"dojo/_base/lang", // lang.mixin
	"dojo/on", // on
	"../main"    // for exporting dijit._setSelectionRange, dijit.selectInputText
], function(array, declare, dom, has, keys, lang, on, dijit){

	// module:
	//		dijit/form/_TextBoxMixin

	var _TextBoxMixin = declare("dijit.form._TextBoxMixin" + (has("dojo-bidi") ? "_NoBidi" : ""), null, {
		// summary:
		//		A mixin for textbox form input widgets

		// trim: Boolean
		//		Removes leading and trailing whitespace if true.  Default is false.
		trim: false,

		// uppercase: Boolean
		//		Converts all characters to uppercase if true.  Default is false.
		uppercase: false,

		// lowercase: Boolean
		//		Converts all characters to lowercase if true.  Default is false.
		lowercase: false,

		// propercase: Boolean
		//		Converts the first character of each word to uppercase if true.
		propercase: false,

		// maxLength: String
		//		HTML INPUT tag maxLength declaration.
		maxLength: "",

		// selectOnClick: [const] Boolean
		//		If true, all text will be selected when focused with mouse
		selectOnClick: false,

		// placeHolder: String
		//		Defines a hint to help users fill out the input field (as defined in HTML 5).
		//		This should only contain plain text (no html markup).
		placeHolder: "",

		_getValueAttr: function(){
			// summary:
			//		Hook so get('value') works as we like.
			// description:
			//		For `dijit/form/TextBox` this basically returns the value of the `<input>`.
			//
			//		For `dijit/form/MappedTextBox` subclasses, which have both
			//		a "displayed value" and a separate "submit value",
			//		This treats the "displayed value" as the master value, computing the
			//		submit value from it via this.parse().
			return this.parse(this.get('displayedValue'), this.constraints);
		},

		_setValueAttr: function(value, /*Boolean?*/ priorityChange, /*String?*/ formattedValue){
			// summary:
			//		Hook so set('value', ...) works.
			//
			// description:
			//		Sets the value of the widget to "value" which can be of
			//		any type as determined by the widget.
			//
			// value:
			//		The visual element value is also set to a corresponding,
			//		but not necessarily the same, value.
			//
			// formattedValue:
			//		If specified, used to set the visual element value,
			//		otherwise a computed visual value is used.
			//
			// priorityChange:
			//		If true, an onChange event is fired immediately instead of
			//		waiting for the next blur event.

			var filteredValue;
			if(value !== undefined){
				// TODO: this is calling filter() on both the display value and the actual value.
				// I added a comment to the filter() definition about this, but it should be changed.
				filteredValue = this.filter(value);
				if(typeof formattedValue != "string"){
					if(filteredValue !== null && ((typeof filteredValue != "number") || !isNaN(filteredValue))){
						formattedValue = this.filter(this.format(filteredValue, this.constraints));
					}else{
						formattedValue = '';
					}
					// Ensure the filtered value does not change after being formatted. See track #17955.
					//
					// This check is only applied when the formatted value is not specified by the caller in order to allow the 
					// behavior to be overriden. This is needed whenever value synonyms cannot be determined using parse/compare. For
					// example, dijit/form/FilteringSelect determines the formatted value asynchronously and applies it using a 
					// callback to this method.
					//
					// TODO: Should developers be warned that they broke the round trip on format?
					if (this.compare(filteredValue, this.filter(this.parse(formattedValue, this.constraints))) != 0){
						formattedValue = null;
					}
				}
			}
			if(formattedValue != null /* and !undefined */ && ((typeof formattedValue) != "number" || !isNaN(formattedValue)) && this.textbox.value != formattedValue){
				this.textbox.value = formattedValue;
				this._set("displayedValue", this.get("displayedValue"));
			}

			this.inherited(arguments, [filteredValue, priorityChange]);
		},

		// displayedValue: String
		//		For subclasses like ComboBox where the displayed value
		//		(ex: Kentucky) and the serialized value (ex: KY) are different,
		//		this represents the displayed value.
		//
		//		Setting 'displayedValue' through set('displayedValue', ...)
		//		updates 'value', and vice-versa.  Otherwise 'value' is updated
		//		from 'displayedValue' periodically, like onBlur etc.
		//
		//		TODO: move declaration to MappedTextBox?
		//		Problem is that ComboBox references displayedValue,
		//		for benefit of FilteringSelect.
		displayedValue: "",

		_getDisplayedValueAttr: function(){
			// summary:
			//		Hook so get('displayedValue') works.
			// description:
			//		Returns the displayed value (what the user sees on the screen),
			//		after filtering (ie, trimming spaces etc.).
			//
			//		For some subclasses of TextBox (like ComboBox), the displayed value
			//		is different from the serialized value that's actually
			//		sent to the server (see `dijit/form/ValidationTextBox.serialize()`)

			// TODO: maybe we should update this.displayedValue on every keystroke so that we don't need
			// this method
			// TODO: this isn't really the displayed value when the user is typing
			return this.filter(this.textbox.value);
		},

		_setDisplayedValueAttr: function(/*String*/ value){
			// summary:
			//		Hook so set('displayedValue', ...) works.
			// description:
			//		Sets the value of the visual element to the string "value".
			//		The widget value is also set to a corresponding,
			//		but not necessarily the same, value.

			if(value == null /* or undefined */){
				value = ''
			}
			else if(typeof value != "string"){
				value = String(value)
			}

			this.textbox.value = value;

			// sets the serialized value to something corresponding to specified displayedValue
			// (if possible), and also updates the textbox.value, for example converting "123"
			// to "123.00"
			this._setValueAttr(this.get('value'), undefined);

			this._set("displayedValue", this.get('displayedValue'));
		},

		format: function(value /*=====, constraints =====*/){
			// summary:
			//		Replaceable function to convert a value to a properly formatted string.
			// value: String
			// constraints: Object
			// tags:
			//		protected extension
			return value == null /* or undefined */ ? "" : (value.toString ? value.toString() : value);
		},

		parse: function(value /*=====, constraints =====*/){
			// summary:
			//		Replaceable function to convert a formatted string to a value
			// value: String
			// constraints: Object
			// tags:
			//		protected extension

			return value;	// String
		},

		_refreshState: function(){
			// summary:
			//		After the user types some characters, etc., this method is
			//		called to check the field for validity etc.  The base method
			//		in `dijit/form/TextBox` does nothing, but subclasses override.
			// tags:
			//		protected
		},

		 onInput: function(/*Event*/ /*===== evt =====*/){
			 // summary:
			 //		Connect to this function to receive notifications of various user data-input events.
			 //		Return false to cancel the event and prevent it from being processed.
			 //		Note that although for historical reasons this method is called `onInput()`, it doesn't
			 //		correspond to the standard DOM "input" event, because it occurs before the input has been processed.
			 // event:
			 //		keydown | keypress | cut | paste | compositionend
			 // tags:
			 //		callback
		 },

		_onInput: function(/*Event*/ evt){
			// summary:
			//		Called AFTER the input event has happened and this.textbox.value has new value.

			this._lastInputEventValue = this.textbox.value;

			// For Combobox, this needs to be called w/the keydown/keypress event that was passed to onInput().
			// As a backup, use the "input" event itself.
			this._processInput(this._lastInputProducingEvent || evt);
			delete this._lastInputProducingEvent;

			if(this.intermediateChanges){
				this._handleOnChange(this.get('value'), false);
			}
		},

		_processInput: function(/*Event*/ /*===== evt =====*/){
			// summary:
			//		Default action handler for user input events.
			//		Called after the "input" event (i.e. after this.textbox.value has been updated),
			//		but `evt` is the keydown/keypress/etc. event that triggered the "input" event.
			// tags:
			//		protected

			this._refreshState();

			// In case someone is watch()'ing for changes to displayedValue
			this._set("displayedValue", this.get("displayedValue"));
		},

		postCreate: function(){
			// setting the value here is needed since value="" in the template causes "undefined"
			// and setting in the DOM (instead of the JS object) helps with form reset actions
			this.textbox.setAttribute("value", this.textbox.value); // DOM and JS values should be the same

			this.inherited(arguments);

			// normalize input events to reduce spurious event processing
			//	keydown: do not forward modifier keys
			//		       set charOrCode to numeric keycode
			//	keypress: do not forward numeric charOrCode keys (already sent through onkeydown)
			//	paste, cut, compositionend: set charOrCode to 229 (IME)
			function handleEvent(e){
				var charOrCode;

				// Filter out keydown events that will be followed by keypress events.  Note that chrome/android
				// w/word suggestion has keydown/229 events on typing with no corresponding keypress events.
				if(e.type == "keydown" && e.keyCode != 229){
					charOrCode = e.keyCode;
					switch(charOrCode){ // ignore state keys
						case keys.SHIFT:
						case keys.ALT:
						case keys.CTRL:
						case keys.META:
						case keys.CAPS_LOCK:
						case keys.NUM_LOCK:
						case keys.SCROLL_LOCK:
							return;
					}
					if(!e.ctrlKey && !e.metaKey && !e.altKey){ // no modifiers
						switch(charOrCode){ // ignore location keys
							case keys.NUMPAD_0:
							case keys.NUMPAD_1:
							case keys.NUMPAD_2:
							case keys.NUMPAD_3:
							case keys.NUMPAD_4:
							case keys.NUMPAD_5:
							case keys.NUMPAD_6:
							case keys.NUMPAD_7:
							case keys.NUMPAD_8:
							case keys.NUMPAD_9:
							case keys.NUMPAD_MULTIPLY:
							case keys.NUMPAD_PLUS:
							case keys.NUMPAD_ENTER:
							case keys.NUMPAD_MINUS:
							case keys.NUMPAD_PERIOD:
							case keys.NUMPAD_DIVIDE:
								return;
						}
						if((charOrCode >= 65 && charOrCode <= 90) || (charOrCode >= 48 && charOrCode <= 57) || charOrCode == keys.SPACE){
							return; // keypress will handle simple non-modified printable keys
						}
						var named = false;
						for(var i in keys){
							if(keys[i] === e.keyCode){
								named = true;
								break;
							}
						}
						if(!named){
							return;
						} // only allow named ones through
					}
				}

				charOrCode = e.charCode >= 32 ? String.fromCharCode(e.charCode) : e.charCode;
				if(!charOrCode){
					charOrCode = (e.keyCode >= 65 && e.keyCode <= 90) || (e.keyCode >= 48 && e.keyCode <= 57) || e.keyCode == keys.SPACE ? String.fromCharCode(e.keyCode) : e.keyCode;
				}
				if(!charOrCode){
					charOrCode = 229; // IME
				}
				if(e.type == "keypress"){
					if(typeof charOrCode != "string"){
						return;
					}
					if((charOrCode >= 'a' && charOrCode <= 'z') || (charOrCode >= 'A' && charOrCode <= 'Z') || (charOrCode >= '0' && charOrCode <= '9') || (charOrCode === ' ')){
						if(e.ctrlKey || e.metaKey || e.altKey){
							return;
						} // can only be stopped reliably in keydown
					}
				}

				// create fake event to set charOrCode and to know if preventDefault() was called
				var faux = { faux: true }, attr;
				for(attr in e){
					if(!/^(layer[XY]|returnValue|keyLocation)$/.test(attr)){ // prevent WebKit warnings
						var v = e[attr];
						if(typeof v != "function" && typeof v != "undefined"){
							faux[attr] = v;
						}
					}
				}
				lang.mixin(faux, {
					charOrCode: charOrCode,
					_wasConsumed: false,
					preventDefault: function(){
						faux._wasConsumed = true;
						e.preventDefault();
					},
					stopPropagation: function(){
						e.stopPropagation();
					}
				});

				this._lastInputProducingEvent = faux;

				// Give web page author a chance to consume the event.  Note that onInput() may be called multiple times
				// for same keystroke: once for keypress event and once for input event.
				//console.log(faux.type + ', charOrCode = (' + (typeof charOrCode) + ') ' + charOrCode + ', ctrl ' + !!faux.ctrlKey + ', alt ' + !!faux.altKey + ', meta ' + !!faux.metaKey + ', shift ' + !!faux.shiftKey);
				if(this.onInput(faux) === false){ // return false means stop
					faux.preventDefault();
					faux.stopPropagation();
				}
				if(faux._wasConsumed){
					return;
				} // if preventDefault was called

				// IE8 doesn't emit the "input" event at all, and IE9 doesn't emit it for backspace, delete, cut, etc.
				// Since the code below (and perhaps user code) depends on that event, emit it synthetically.
				// See http://benalpert.com/2013/06/18/a-near-perfect-oninput-shim-for-ie-8-and-9.html.
				if(has("ie") <= 9){
					switch(e.keyCode){
					case keys.TAB:
					case keys.ESCAPE:
					case keys.DOWN_ARROW:
					case keys.UP_ARROW:
					case keys.LEFT_ARROW:
					case keys.RIGHT_ARROW:
						// These keys may alter the <input>'s value indirectly, but we don't want to emit an "input"
						// event.  For example, the up/down arrows in TimeTextBox or ComboBox will cause the next
						// dropdown item's value to be copied to the <input>.
						break;
					default:
						if(e.keyCode == keys.ENTER && this.textbox.tagName.toLowerCase() != "textarea"){
							break;
						}
						this.defer(function(){
							if(this.textbox.value !== this._lastInputEventValue){
								on.emit(this.textbox, "input", {bubbles: true});
							}
						});
					}
				}
			}
			this.own(
				on(this.textbox, "keydown, keypress, paste, cut, compositionend", lang.hitch(this, handleEvent)),
				on(this.textbox, "input", lang.hitch(this, "_onInput")),

				// Allow keypress to bubble to this.domNode, so that TextBox.on("keypress", ...) works,
				// but prevent it from further propagating, so that typing into a TextBox inside a Toolbar doesn't
				// trigger the Toolbar's letter key navigation.
				on(this.domNode, "keypress", function(e){ e.stopPropagation(); })
			);
		},

		_blankValue: '', // if the textbox is blank, what value should be reported
		filter: function(val){
			// summary:
			//		Auto-corrections (such as trimming) that are applied to textbox
			//		value on blur or form submit.
			// description:
			//		For MappedTextBox subclasses, this is called twice
			//
			//		- once with the display value
			//		- once the value as set/returned by set('value', ...)
			//
			//		and get('value'), ex: a Number for NumberTextBox.
			//
			//		In the latter case it does corrections like converting null to NaN.  In
			//		the former case the NumberTextBox.filter() method calls this.inherited()
			//		to execute standard trimming code in TextBox.filter().
			//
			//		TODO: break this into two methods in 2.0
			//
			// tags:
			//		protected extension
			if(val === null){
				return this._blankValue;
			}
			if(typeof val != "string"){
				return val;
			}
			if(this.trim){
				val = lang.trim(val);
			}
			if(this.uppercase){
				val = val.toUpperCase();
			}
			if(this.lowercase){
				val = val.toLowerCase();
			}
			if(this.propercase){
				val = val.replace(/[^\s]+/g, function(word){
					return word.substring(0, 1).toUpperCase() + word.substring(1);
				});
			}
			return val;
		},

		_setBlurValue: function(){
			// Format the displayed value, for example (for NumberTextBox) convert 1.4 to 1.400,
			// or (for CurrencyTextBox) 2.50 to $2.50

			this._setValueAttr(this.get('value'), true);
		},

		_onBlur: function(e){
			if(this.disabled){
				return;
			}
			this._setBlurValue();
			this.inherited(arguments);
		},

		_isTextSelected: function(){
			return this.textbox.selectionStart != this.textbox.selectionEnd;
		},

		_onFocus: function(/*String*/ by){
			if(this.disabled || this.readOnly){
				return;
			}

			// Select all text on focus via click if nothing already selected.
			// Since mouse-up will clear the selection, need to defer selection until after mouse-up.
			// Don't do anything on focus by tabbing into the widget since there's no associated mouse-up event.
			if(this.selectOnClick && by == "mouse"){
				// Use on.once() to only select all text on first click only; otherwise users would have no way to clear
				// the selection.
				this._selectOnClickHandle = on.once(this.domNode, "mouseup, touchend", lang.hitch(this, function(evt){
					// Check if the user selected some text manually (mouse-down, mouse-move, mouse-up)
					// and if not, then select all the text
					if(!this._isTextSelected()){
						_TextBoxMixin.selectInputText(this.textbox);
					}
				}));
				this.own(this._selectOnClickHandle);

				// in case the mouseup never comes
				this.defer(function(){
					if(this._selectOnClickHandle){
						this._selectOnClickHandle.remove();
						this._selectOnClickHandle = null;
					}
				}, 500); // if mouseup not received soon, then treat it as some gesture
			}
			// call this.inherited() before refreshState(), since this.inherited() will possibly scroll the viewport
			// (to scroll the TextBox into view), which will affect how _refreshState() positions the tooltip
			this.inherited(arguments);

			this._refreshState();
		},

		reset: function(){
			// Overrides `dijit/_FormWidget/reset()`.
			// Additionally resets the displayed textbox value to ''
			this.textbox.value = '';
			this.inherited(arguments);
		}
	});

	if(has("dojo-bidi")){
		_TextBoxMixin = declare("dijit.form._TextBoxMixin", _TextBoxMixin, {
			_setValueAttr: function(){
				this.inherited(arguments);
				this.applyTextDir(this.focusNode);
			},
			_setDisplayedValueAttr: function(){
				this.inherited(arguments);
				this.applyTextDir(this.focusNode);
			},
			_onInput: function(){
				this.applyTextDir(this.focusNode);
				this.inherited(arguments);
			}
		});
	}

	_TextBoxMixin._setSelectionRange = dijit._setSelectionRange = function(/*DomNode*/ element, /*Number?*/ start, /*Number?*/ stop){
		if(element.setSelectionRange){
			element.setSelectionRange(start, stop);
		}
	};

	_TextBoxMixin.selectInputText = dijit.selectInputText = function(/*DomNode*/ element, /*Number?*/ start, /*Number?*/ stop){
		// summary:
		//		Select text in the input element argument, from start (default 0), to stop (default end).

		// TODO: use functions in _editor/selection.js?
		element = dom.byId(element);
		if(isNaN(start)){
			start = 0;
		}
		if(isNaN(stop)){
			stop = element.value ? element.value.length : 0;
		}
		try{
			element.focus();
			_TextBoxMixin._setSelectionRange(element, start, stop);
		}catch(e){ /* squelch random errors (esp. on IE) from unexpected focus changes or DOM nodes being hidden */
		}
	};

	return _TextBoxMixin;
});

},
'dojox/mobile':function(){
define([
	".",
	"dojo/_base/lang",
	"dojox/mobile/_base"
], function(dojox, lang, base){
	lang.getObject("mobile", true, dojox);
	/*=====
	return {
		// summary:
		//		Deprecated.  Should require dojox/mobile classes directly rather than trying to access them through
		//		this module.
	};
	=====*/
	return dojox.mobile;
});

},
'dojox/mobile/View':function(){
define([
	"dojo/_base/array",
	"dojo/_base/config",
	"dojo/_base/connect",
	"dojo/_base/declare",
	"dojo/_base/lang",
	"dojo/sniff",
	"dojo/_base/window",
	"dojo/_base/Deferred",
	"dojo/dom",
	"dojo/dom-class",
	"dojo/dom-construct",
	"dojo/dom-geometry",
	"dojo/dom-style",
	"dijit/registry",
	"dijit/_Contained",
	"dijit/_Container",
	"dijit/_WidgetBase",
	"./ViewController", // to load ViewController for you (no direct references)
	"./common",
	"./transition",
	"./viewRegistry",
	"./_css3"
], function(array, config, connect, declare, lang, has, win, Deferred, dom, domClass, domConstruct, domGeometry, domStyle, registry, Contained, Container, WidgetBase, ViewController, common, transitDeferred, viewRegistry, css3){

	// module:
	//		dojox/mobile/View

	var dm = lang.getObject("dojox.mobile", true);

	return declare("dojox.mobile.View", [WidgetBase, Container, Contained], {
		// summary:
		//		A container widget for any HTML element and/or Dojo widgets
		// description:
		//		View is a container widget for any HTML element and/or Dojo widgets.
		//		As a Dojo widget container it can itself contain View widgets
		//		forming a set of nested views. A Dojo Mobile application is usually
		//		made of multiple View widgets and the user can navigate through
		//		the views back and forth with animated transition effects.
		//		
		//		When using several sibling views (direct children of the same
		//		element), you can use the 'selected' attribute to define whether
		//		the view should be displayed when the application is launched.
		//		If no view has selected=true, the first sibling view is displayed
		//		at startup time.

		// selected: Boolean
		//		If true, the view is displayed at startup time.
		selected: false,

		// keepScrollPos: Boolean
		//		If true, the scroll position is kept when transition occurs between views.
		keepScrollPos: true,

		// tag: String
		//		The name of the HTML tag to create as domNode. The default value is "div".
		tag: "div",

		/* internal properties */
		baseClass: "mblView",

		constructor: function(/*Object*/params, /*DomNode?*/node){
			// summary:
			//		Creates a new instance of the class.
			// params:
			//		Contains the parameters.
			// node:
			//		The DOM node. If none is specified, it is automatically created. 
			if(node){
				dom.byId(node).style.visibility = "hidden";
			}
		},

		destroy: function(){
			viewRegistry.remove(this.id);
			this.inherited(arguments);
		},

		buildRendering: function(){
			if(!this.templateString){
				// Create root node if it wasn't created by _TemplatedMixin
				this.domNode = this.containerNode = this.srcNodeRef || domConstruct.create(this.tag);
			}

			this._animEndHandle = this.connect(this.domNode, css3.name("animationEnd"), "onAnimationEnd");
			this._animStartHandle = this.connect(this.domNode, css3.name("animationStart"), "onAnimationStart");
			if(!config.mblCSS3Transition){
				this._transEndHandle = this.connect(this.domNode, css3.name("transitionEnd"), "onAnimationEnd");
			}
			if(has('mblAndroid3Workaround')){
				// workaround for the screen flicker issue on Android 3.x/4.0
				// applying "-webkit-transform-style:preserve-3d" to domNode can avoid
				// transition animation flicker
				domStyle.set(this.domNode, css3.name("transformStyle"), "preserve-3d");
			}

			viewRegistry.add(this);
			this.inherited(arguments);
		},

		startup: function(){
			if(this._started){ return; }

			// Determine which view among the siblings should be visible.
			// Priority:
			//	 1. fragment id in the url (ex. #view1,view2)
			//	 2. this.selected
			//	 3. the first view
			if(this._visible === undefined){
				var views = this.getSiblingViews();
				var ids = location.hash && location.hash.substring(1).split(/,/);
				var fragView, selectedView, firstView;
				array.forEach(views, function(v, i){
					if(array.indexOf(ids, v.id) !== -1){ fragView = v; }
					if(i == 0){ firstView = v; }
					if(v.selected){ selectedView = v; }
					v._visible = false;
				}, this);
				(fragView || selectedView || firstView)._visible = true;
			}
			if(this._visible){
				// The 2nd arg is not to hide its sibling views so that they can be
				// correctly initialized.
				this.show(true, true);

				// Defer firing events to let user connect to events just after creation
				// TODO: revisit this for 2.0
				this.defer(function(){
					this.onStartView();
					connect.publish("/dojox/mobile/startView", [this]);
				});
			}

			if(this.domNode.style.visibility === "hidden"){ // this check is to avoid screen flickers
				this.domNode.style.visibility = "inherit";
			}

			// Need to call inherited first - so that child widgets get started
			// up correctly
			this.inherited(arguments);

			var parent = this.getParent();
			if(!parent || !parent.resize){ // top level widget
				this.resize();
			}

			if(!this._visible){
				// hide() should be called last so that child widgets can be
				// initialized while they are visible.
				this.hide();
			}
		},

		resize: function(){
			// summary:
			//		Calls resize() of each child widget.
			array.forEach(this.getChildren(), function(child){
				if(child.resize){ child.resize(); }
			});
		},

		onStartView: function(){
			// summary:
			//		Stub function to connect to from your application.
			// description:
			//		Called only when this view is shown at startup time.
		},

		onBeforeTransitionIn: function(moveTo, dir, transition, context, method){
			// summary:
			//		Stub function to connect to from your application.
			// description:
			//		Called before the arriving transition occurs.
		},

		onAfterTransitionIn: function(moveTo, dir, transition, context, method){
			// summary:
			//		Stub function to connect to from your application.
			// description:
			//		Called after the arriving transition occurs.
		},

		onBeforeTransitionOut: function(moveTo, dir, transition, context, method){
			// summary:
			//		Stub function to connect to from your application.
			// description:
			//		Called before the leaving transition occurs.
		},

		onAfterTransitionOut: function(moveTo, dir, transition, context, method){
			// summary:
			//		Stub function to connect to from your application.
			// description:
			//		Called after the leaving transition occurs.
		},

		_clearClasses: function(/*DomNode*/node){
			// summary:
			//		Clean up the domNode classes that were added while making a transition.
			// description:
			//		Remove all the "mbl" prefixed classes except mbl*View.
			if(!node){ return; }
			var classes = [];
			array.forEach(lang.trim(node.className||"").split(/\s+/), function(c){
				if(c.match(/^mbl\w*View$/) || c.indexOf("mbl") === -1){
					classes.push(c);
				}
			}, this);
			node.className = classes.join(' ');
		},

		_fixViewState: function(/*DomNode*/toNode){
			// summary:
			//		Sanity check for view transition states.
			// description:
			//		Sometimes uninitialization of Views fails after making view transition,
			//		and that results in failure of subsequent view transitions.
			//		This function does the uninitialization for all the sibling views.
			var nodes = this.domNode.parentNode.childNodes;
			for(var i = 0; i < nodes.length; i++){
				var n = nodes[i];
				if(n.nodeType === 1 && domClass.contains(n, "mblView")){
					this._clearClasses(n);
				}
			}
			this._clearClasses(toNode); // just in case toNode is a sibling of an ancestor.
			
			// #16337
			// Uninitialization may fail to clear _inProgress when multiple
			// performTransition calls occur in a short duration of time.
			var toWidget = registry.byNode(toNode);
			if(toWidget){
				toWidget._inProgress = false;
			}
		},

		convertToId: function(moveTo){
			if(typeof(moveTo) == "string"){
				// removes a leading hash mark (#) and params if exists
				// ex. "#bar&myParam=0003" -> "bar"
				return moveTo.replace(/^#?([^&?]+).*/, "$1");
			}
			return moveTo;
		},

		_isBookmarkable: function(detail){
			return detail.moveTo && (config.mblForceBookmarkable || detail.moveTo.charAt(0) === '#') && !detail.hashchange;
		},

		performTransition: function(/*String*/moveTo, /*Number*/transitionDir, /*String*/transition,
									/*Object|null*/context, /*String|Function*/method /*...*/){
			// summary:
			//		Function to perform the various types of view transitions, such as fade, slide, and flip.
			// moveTo: String
			//		The id of the transition destination view which resides in
			//		the current page.
			//		If the value has a hash sign ('#') before the id
			//		(e.g. #view1) and the dojo/hash module is loaded by the user
			//		application, the view transition updates the hash in the
			//		browser URL so that the user can bookmark the destination
			//		view. In this case, the user can also use the browser's
			//		back/forward button to navigate through the views in the
			//		browser history.
			//		If null, transitions to a blank view.
			//		If '#', returns immediately without transition.
			// transitionDir: Number
			//		The transition direction. If 1, transition forward. If -1, transition backward.
			//		For example, the slide transition slides the view from right to left when transitionDir == 1,
			//		and from left to right when transitionDir == -1.
			// transition: String
			//		A type of animated transition effect. You can choose from
			//		the standard transition types, "slide", "fade", "flip", or
			//		from the extended transition types, "cover", "coverv",
			//		"dissolve", "reveal", "revealv", "scaleIn", "scaleOut",
			//		"slidev", "swirl", "zoomIn", "zoomOut", "cube", and
			//		"swap". If "none" is specified, transition occurs
			//		immediately without animation.
			// context: Object
			//		The object that the callback function will receive as "this".
			// method: String|Function
			//		A callback function that is called when the transition has finished.
			//		A function reference, or name of a function in context.
			// tags:
			//		public
			//
			// example:
			//		Transition backward to a view whose id is "foo" with the slide animation.
			//	|	performTransition("foo", -1, "slide");
			//
			// example:
			//		Transition forward to a blank view, and then open another page.
			//	|	performTransition(null, 1, "slide", null, function(){location.href = href;});

			if(this._inProgress){ return; } // transition is in progress
			this._inProgress = true;
			
			// normalize the arg
			var detail, optArgs;
			if(moveTo && typeof(moveTo) === "object"){
				detail = moveTo;
				optArgs = transitionDir; // array
			}else{
				detail = {
					moveTo: moveTo,
					transitionDir: transitionDir,
					transition: transition,
					context: context,
					method: method
				};
				optArgs = [];
				for(var i = 5; i < arguments.length; i++){
					optArgs.push(arguments[i]);
				}
			}

			// save the parameters
			this._detail = detail;
			this._optArgs = optArgs;
			this._arguments = [
				detail.moveTo,
				detail.transitionDir,
				detail.transition,
				detail.context,
				detail.method
			];

			if(detail.moveTo === "#"){ return; }
			var toNode;
			if(detail.moveTo){
				toNode = this.convertToId(detail.moveTo);
			}else{
				if(!this._dummyNode){
					this._dummyNode = win.doc.createElement("div");
					win.body().appendChild(this._dummyNode);
				}
				toNode = this._dummyNode;
			}

			if(this.addTransitionInfo && typeof(detail.moveTo) == "string" && this._isBookmarkable(detail)){
				this.addTransitionInfo(this.id, detail.moveTo, {transitionDir:detail.transitionDir, transition:detail.transition});
			}

			var fromNode = this.domNode;
			var fromTop = fromNode.offsetTop;
			toNode = this.toNode = dom.byId(toNode);
			if(!toNode){ console.log("dojox/mobile/View.performTransition: destination view not found: "+detail.moveTo); return; }
			toNode.style.visibility = "hidden";
			toNode.style.display = "";
			this._fixViewState(toNode);
			var toWidget = registry.byNode(toNode);
			if(toWidget){
				// Now that the target view became visible, it's time to run resize()
				if(config.mblAlwaysResizeOnTransition || !toWidget._resized){
					common.resizeAll(null, toWidget);
					toWidget._resized = true;
				}

				if(detail.transition && detail.transition != "none"){
					// Temporarily add padding to align with the fromNode while transition
					toWidget._addTransitionPaddingTop(fromTop);
				}

				toWidget.load && toWidget.load(); // for ContentView

				toWidget.movedFrom = fromNode.id;
			}
			if(has('mblAndroidWorkaround') && !config.mblCSS3Transition
					&& detail.transition && detail.transition != "none"){
				// workaround for the screen flicker issue on Android 2.2/2.3
				// apply "-webkit-transform-style:preserve-3d" to both toNode and fromNode
				// to make them 3d-transition-ready state just before transition animation
				domStyle.set(toNode, css3.name("transformStyle"), "preserve-3d");
				domStyle.set(fromNode, css3.name("transformStyle"), "preserve-3d");
				// show toNode offscreen to avoid flicker when switching "display" and "visibility" styles
				domClass.add(toNode, "mblAndroidWorkaround");
			}

			this.onBeforeTransitionOut.apply(this, this._arguments);
			connect.publish("/dojox/mobile/beforeTransitionOut", [this].concat(lang._toArray(this._arguments)));
			if(toWidget){
				// perform view transition keeping the scroll position
				if(this.keepScrollPos && !this.getParent()){
					var scrollTop = win.body().scrollTop || win.doc.documentElement.scrollTop || win.global.pageYOffset || 0;
					fromNode._scrollTop = scrollTop;
					var toTop = (detail.transitionDir == 1) ? 0 : (toNode._scrollTop || 0);
					toNode.style.top = "0px";
					if(scrollTop > 1 || toTop !== 0){
						fromNode.style.top = toTop - scrollTop + "px";
						// address bar hiding does not work on iOS 7+.
						if(!(has("ios") >= 7) && config.mblHideAddressBar !== false){
							this.defer(function(){ // iPhone needs setTimeout (via defer)
								win.global.scrollTo(0, (toTop || 1));
							});
						}
					}
				}else{
					toNode.style.top = "0px";
				}
				toWidget.onBeforeTransitionIn.apply(toWidget, this._arguments);
				connect.publish("/dojox/mobile/beforeTransitionIn", [toWidget].concat(lang._toArray(this._arguments)));
			}
			toNode.style.display = "none";
			toNode.style.visibility = "inherit";

			common.fromView = this;
			common.toView = toWidget;

			this._doTransition(fromNode, toNode, detail.transition, detail.transitionDir);
		},

		_addTransitionPaddingTop: function(/*String|Integer*/ value){
			// add padding top to the view in order to get alignment during the transition
			this.containerNode.style.paddingTop = value + "px";
		},

		_removeTransitionPaddingTop: function(){
			// remove padding top from the view after the transition
			this.containerNode.style.paddingTop = "";
		},

		_toCls: function(s){
			// convert from transition name to corresponding class name
			// ex. "slide" -> "mblSlide"
			return "mbl"+s.charAt(0).toUpperCase() + s.substring(1);
		},

		_doTransition: function(fromNode, toNode, transition, transitionDir){
			var rev = (transitionDir == -1) ? " mblReverse" : "";
			toNode.style.display = "";
			if(!transition || transition == "none"){
				this.domNode.style.display = "none";
				this.invokeCallback();
			}else if(config.mblCSS3Transition){
				//get dojox/css3/transit first
				Deferred.when(transitDeferred, lang.hitch(this, function(transit){
					//follow the style of .mblView.mblIn in View.css
					//need to set the toNode to absolute position
					var toPosition = domStyle.get(toNode, "position");
					domStyle.set(toNode, "position", "absolute");
					Deferred.when(transit(fromNode, toNode, {transition: transition, reverse: (transitionDir===-1)?true:false}),lang.hitch(this,function(){
						domStyle.set(toNode, "position", toPosition);
						// Reset the temporary padding on toNode
						toNode.style.paddingTop = "";
						this.invokeCallback();
					}));
				}));
			}else{
				if(transition.indexOf("cube") != -1){
					if(has('ipad')){
						domStyle.set(toNode.parentNode, {webkitPerspective:1600});
					}else if(has("ios")){
						domStyle.set(toNode.parentNode, {webkitPerspective:800});
					}
				}
				var s = this._toCls(transition);
				if(has('mblAndroidWorkaround')){
					// workaround for the screen flicker issue on Android 2.2
					// applying transition css classes just after setting toNode.style.display = ""
					// causes flicker, so wait for a while using setTimeout (via defer)
					var _this = this;
					_this.defer(function(){
						domClass.add(fromNode, s + " mblOut" + rev);
						domClass.add(toNode, s + " mblIn" + rev);
						domClass.remove(toNode, "mblAndroidWorkaround"); // remove offscreen style
						_this.defer(function(){
							domClass.add(fromNode, "mblTransition");
							domClass.add(toNode, "mblTransition");
						}, 30); // 30 = 100 - 70, to make total delay equal to 100ms
					}, 70); // 70ms is experiential value
				}else{
					domClass.add(fromNode, s + " mblOut" + rev);
					domClass.add(toNode, s + " mblIn" + rev);
					this.defer(function(){
						domClass.add(fromNode, "mblTransition");
						domClass.add(toNode, "mblTransition");
					}, 100);
				}
				// set transform origin
				var fromOrigin = "50% 50%";
				var toOrigin = "50% 50%";
				var scrollTop, posX, posY;
				if(transition.indexOf("swirl") != -1 || transition.indexOf("zoom") != -1){
					if(this.keepScrollPos && !this.getParent()){
						scrollTop = win.body().scrollTop || win.doc.documentElement.scrollTop || win.global.pageYOffset || 0;
					}else{
						scrollTop = -domGeometry.position(fromNode, true).y;
					}
					posY = win.global.innerHeight / 2 + scrollTop;
					fromOrigin = "50% " + posY + "px";
					toOrigin = "50% " + posY + "px";
				}else if(transition.indexOf("scale") != -1){
					var viewPos = domGeometry.position(fromNode, true);
					posX = ((this.clickedPosX !== undefined) ? this.clickedPosX : win.global.innerWidth / 2) - viewPos.x;
					if(this.keepScrollPos && !this.getParent()){
						scrollTop = win.body().scrollTop || win.doc.documentElement.scrollTop || win.global.pageYOffset || 0;
					}else{
						scrollTop = -viewPos.y;
					}
					posY = ((this.clickedPosY !== undefined) ? this.clickedPosY : win.global.innerHeight / 2) + scrollTop;
					fromOrigin = posX + "px " + posY + "px";
					toOrigin = posX + "px " + posY + "px";
				}
				domStyle.set(fromNode, css3.add({}, {transformOrigin:fromOrigin}));
				domStyle.set(toNode, css3.add({}, {transformOrigin:toOrigin}));
			}
		},

		onAnimationStart: function(e){
			// summary:
			//		A handler that is called when transition animation starts.
		},

		onAnimationEnd: function(e){
			// summary:
			//		A handler that is called after transition animation ends.
			var name = e.animationName || e.target.className;
			if(name.indexOf("Out") === -1 &&
				name.indexOf("In") === -1 &&
				name.indexOf("Shrink") === -1){ return; }
			var isOut = false;
			if(domClass.contains(this.domNode, "mblOut")){
				isOut = true;
				this.domNode.style.display = "none";
				domClass.remove(this.domNode, [this._toCls(this._detail.transition), "mblIn", "mblOut", "mblReverse"]);
			}else{
				// Reset the temporary padding
				this._removeTransitionPaddingTop();
			}
			domStyle.set(this.domNode, css3.add({}, {transformOrigin:""}));
			if(name.indexOf("Shrink") !== -1){
				var li = e.target;
				li.style.display = "none";
				domClass.remove(li, "mblCloseContent");

				// If target is placed inside scrollable, need to call onTouchEnd
				// to adjust scroll position
				var p = viewRegistry.getEnclosingScrollable(this.domNode);
				p && p.onTouchEnd();
			}
			if(isOut){
				this.invokeCallback();
			}
			this._clearClasses(this.domNode);

			// clear the clicked position
			this.clickedPosX = this.clickedPosY = undefined;

			if(name.indexOf("Cube") !== -1 &&
				name.indexOf("In") !== -1 && has("ios")){
				this.domNode.parentNode.style[css3.name("perspective")] = "";
			}
		},

		invokeCallback: function(){
			// summary:
			//		A function to be called after performing a transition to
			//		call a specified callback.
			this.onAfterTransitionOut.apply(this, this._arguments);
			connect.publish("/dojox/mobile/afterTransitionOut", [this].concat(this._arguments));
			var toWidget = registry.byNode(this.toNode);
			if(toWidget){
				toWidget.onAfterTransitionIn.apply(toWidget, this._arguments);
				connect.publish("/dojox/mobile/afterTransitionIn", [toWidget].concat(this._arguments));
				toWidget.movedFrom = undefined;
				if(this.setFragIds && this._isBookmarkable(this._detail)){
					this.setFragIds(toWidget); // setFragIds is defined in bookmarkable.js
				}
			}
			if(has('mblAndroidWorkaround')){
				// workaround for the screen flicker issue on Android 2.2/2.3
				// remove "-webkit-transform-style" style after transition finished
				// to avoid side effects such as input field auto-scrolling issue
				// use setTimeout (via defer) to avoid flicker in case of ScrollableView
				this.defer(function(){
					if(toWidget){ domStyle.set(this.toNode, css3.name("transformStyle"), ""); }
					domStyle.set(this.domNode, css3.name("transformStyle"), "");
				});
			}

			var c = this._detail.context, m = this._detail.method;
			if(c || m){
				if(!m){
					m = c;
					c = null;
				}
				c = c || win.global;
				if(typeof(m) == "string"){
					c[m].apply(c, this._optArgs);
				}else if(typeof(m) == "function"){
					m.apply(c, this._optArgs);
				}
			}
			this._detail = this._optArgs = this._arguments = undefined;
			this._inProgress = false;
		},

		isVisible: function(/*Boolean?*/checkAncestors){
			// summary:
			//		Return true if this view is visible
			// checkAncestors:
			//		If true, in addition to its own visibility, also checks the
			//		ancestors visibility to see if the view is actually being
			//		shown or not.
			var visible = function(node){
				return domStyle.get(node, "display") !== "none";
			};
			if(checkAncestors){
				for(var n = this.domNode; n.tagName !== "BODY"; n = n.parentNode){
					if(!visible(n)){ return false; }
				}
				return true;
			}else{
				return visible(this.domNode);
			}
		},

		getShowingView: function(){
			// summary:
			//		Find the currently showing view from my sibling views.
			// description:
			//		Note that depending on the ancestor views' visibility,
			//		the found view may not be actually shown.
			var nodes = this.domNode.parentNode.childNodes;
			for(var i = 0; i < nodes.length; i++){
				var n = nodes[i];
				if(n.nodeType === 1 && domClass.contains(n, "mblView") && n.style.display !== "none"){
					return registry.byNode(n);
				}
			}
			return null;
		},

		getSiblingViews: function(){
			// summary:
			//		Returns an array of the sibling views.
			if(!this.domNode.parentNode){ return [this]; }
			return array.map(array.filter(this.domNode.parentNode.childNodes,
				function(n){ return n.nodeType === 1 && domClass.contains(n, "mblView"); }),
				function(n){ return registry.byNode(n); });
		},

		show: function(/*Boolean?*/noEvent, /*Boolean?*/doNotHideOthers){
			// summary:
			//		Shows this view without a transition animation.
			var out = this.getShowingView();
			if(!noEvent){
				if(out){
					out.onBeforeTransitionOut(out.id);
					connect.publish("/dojox/mobile/beforeTransitionOut", [out, out.id]);
				}
				this.onBeforeTransitionIn(this.id);
				connect.publish("/dojox/mobile/beforeTransitionIn", [this, this.id]);
			}

			if(doNotHideOthers){
				this.domNode.style.display = "";
			}else{
				array.forEach(this.getSiblingViews(), function(v){
					v.domNode.style.display = (v === this) ? "" : "none";
				}, this);
			}
			this.load && this.load(); // for ContentView

			if(!noEvent){
				if(out){
					out.onAfterTransitionOut(out.id);
					connect.publish("/dojox/mobile/afterTransitionOut", [out, out.id]);
				}
				this.onAfterTransitionIn(this.id);
				connect.publish("/dojox/mobile/afterTransitionIn", [this, this.id]);
			}
		},

		hide: function(){
			// summary:
			//		Hides this view without a transition animation.
			this.domNode.style.display = "none";
		}
	});
});

},
'dojox/mobile/transition':function(){
define([
	"dojo/_base/Deferred",
	"dojo/_base/config"
], function(Deferred, config){
	/*=====
	return {
		// summary:
		//		This is the wrapper module which loads
		//		dojox/css3/transit conditionally. If mblCSS3Transition
		//		is set to 'dojox/css3/transit', it will be loaded as
		//		the module to conduct view transitions, otherwise this module returns null.
	};
	=====*/
	if(config.mblCSS3Transition){
		//require dojox/css3/transit and resolve it as the result of transitDeferred.
		var transitDeferred = new Deferred();
		require([config.mblCSS3Transition], function(transit){
			transitDeferred.resolve(transit);
		});
		return transitDeferred;
	}
	return null;
});

},
'dojox/mobile/Heading':function(){
define([
	"dojo/_base/array",
	"dojo/_base/connect",
	"dojo/_base/declare",
	"dojo/_base/lang",
	"dojo/_base/window",
	"dojo/dom-class",
	"dojo/dom-construct",
	"dojo/dom-style",
	"dojo/dom-attr",
	"dijit/registry",
	"./common",
	"dijit/_Contained",
	"dijit/_Container",
	"dijit/_WidgetBase",
	"./ProgressIndicator",
	"./ToolBarButton",
	"./View",
	"dojo/has",
	"dojo/has!dojo-bidi?dojox/mobile/bidi/Heading"
], function(array, connect, declare, lang, win, domClass, domConstruct, domStyle, domAttr, registry, common, Contained, Container, WidgetBase, ProgressIndicator, ToolBarButton, View, has, BidiHeading){

	// module:
	//		dojox/mobile/Heading

	var dm = lang.getObject("dojox.mobile", true);

	var Heading = declare(has("dojo-bidi") ? "dojox.mobile.NonBidiHeading" : "dojox.mobile.Heading", [WidgetBase, Container, Contained],{
		// summary:
		//		A widget that represents a navigation bar.
		// description:
		//		Heading is a widget that represents a navigation bar, which
		//		usually appears at the top of an application. It usually
		//		displays the title of the current view and can contain a
		//		navigational control. If you use it with
		//		dojox/mobile/ScrollableView, it can also be used as a fixed
		//		header bar or a fixed footer bar. In such cases, specify the
		//		fixed="top" attribute to be a fixed header bar or the
		//		fixed="bottom" attribute to be a fixed footer bar. Heading can
		//		have one or more ToolBarButton widgets as its children.

		// back: String
		//		A label for the navigational control to return to the previous View.
		back: "",

		// href: String
		//		A URL to open when the navigational control is pressed.
		href: "",

		// moveTo: String
		//		The id of the transition destination of the navigation control.
		//		If the value has a hash sign ('#') before the id (e.g. #view1)
		//		and the dojox/mobile/bookmarkable module is loaded by the user application,
		//		the view transition updates the hash in the browser URL so that the
		//		user can bookmark the destination view. In this case, the user
		//		can also use the browser's back/forward button to navigate
		//		through the views in the browser history.
		//
		//		If null, transitions to a blank view.
		//		If '#', returns immediately without transition.
		moveTo: "",

		// transition: String
		//		A type of animated transition effect. You can choose from the
		//		standard transition types, "slide", "fade", "flip", or from the
		//		extended transition types, "cover", "coverv", "dissolve",
		//		"reveal", "revealv", "scaleIn", "scaleOut", "slidev",
		//		"swirl", "zoomIn", "zoomOut", "cube", and "swap". If "none" is
		//		specified, transition occurs immediately without animation.
		transition: "slide",

		// label: String
		//		A title text of the heading. If the label is not specified, the
		//		innerHTML of the node is used as a label.
		label: "",

		// iconBase: String
		//		The default icon path for child items.
		iconBase: "",

		// tag: String
		//		A name of HTML tag to create as domNode.
		tag: "h1",

		// busy: Boolean
		//		If true, a progress indicator spins on this widget.
		busy: false,

		// progStyle: String
		//		A css class name to add to the progress indicator.
		progStyle: "mblProgWhite",

		/* internal properties */
		
		// baseClass: String
		//		The name of the CSS class of this widget.	
		baseClass: "mblHeading",

		buildRendering: function(){
			if(!this.templateString){ // true if this widget is not templated
				// Create root node if it wasn't created by _TemplatedMixin
				this.domNode = this.containerNode = this.srcNodeRef || win.doc.createElement(this.tag);
			}
			this.inherited(arguments);
			
			if(!this.templateString){ // true if this widget is not templated
				if(!this.label){
					array.forEach(this.domNode.childNodes, function(n){
						if(n.nodeType == 3){
							var v = lang.trim(n.nodeValue);
							if(v){
								this.label = v;
								this.labelNode = domConstruct.create("span", {innerHTML:v}, n, "replace");
							}
						}
					}, this);
				}
				if(!this.labelNode){
					this.labelNode = domConstruct.create("span", null, this.domNode);
				}
				this.labelNode.className = "mblHeadingSpanTitle";
				this.labelDivNode = domConstruct.create("div", {
					className: "mblHeadingDivTitle",
					innerHTML: this.labelNode.innerHTML
				}, this.domNode);
			}

			if(this.labelDivNode){
				domAttr.set(this.labelDivNode, "role", "heading"); //a11y
				domAttr.set(this.labelDivNode, "aria-level", "1");
			}

			common.setSelectable(this.domNode, false);
		},

		startup: function(){
			if(this._started){ return; }
			var parent = this.getParent && this.getParent();
			if(!parent || !parent.resize){ // top level widget
				var _this = this;
				_this.defer(function(){ // necessary to render correctly
					_this.resize();
				});
			}
			this.inherited(arguments);
		},

		resize: function(){
			if(this.labelNode){
				// find the rightmost left button (B), and leftmost right button (C)
				// +-----------------------------+
				// | |A| |B|             |C| |D| |
				// +-----------------------------+
				var leftBtn, rightBtn;
				var children = this.containerNode.childNodes;
				for(var i = children.length - 1; i >= 0; i--){
					var c = children[i];
					if(c.nodeType === 1 && domStyle.get(c, "display") !== "none"){
						if(!rightBtn && domStyle.get(c, "float") === "right"){
							rightBtn = c;
						}
						if(!leftBtn && domStyle.get(c, "float") === "left"){
							leftBtn = c;
						}
					}
				}

				if(!this.labelNodeLen && this.label){
					this.labelNode.style.display = "inline";
					this.labelNodeLen = this.labelNode.offsetWidth;
					this.labelNode.style.display = "";
				}

				var bw = this.domNode.offsetWidth; // bar width
				var rw = rightBtn ? bw - rightBtn.offsetLeft + 5 : 0; // rightBtn width
				var lw = leftBtn ? leftBtn.offsetLeft + leftBtn.offsetWidth + 5 : 0; // leftBtn width
				var tw = this.labelNodeLen || 0; // title width
				domClass[bw - Math.max(rw,lw)*2 > tw ? "add" : "remove"](this.domNode, "mblHeadingCenterTitle");
			}
			array.forEach(this.getChildren(), function(child){
				if(child.resize){ child.resize(); }
			});
		},

		_setBackAttr: function(/*String*/back){
			// tags:
			//		private
			this._set("back", back);
			if(!this.backButton){
				this.backButton = new ToolBarButton({
					arrow: "left",
					label: back,
					moveTo: this.moveTo,
					back: !this.moveTo && !this.href, // use browser history unless moveTo or href
					href: this.href,
					transition: this.transition,
					transitionDir: -1,
					dir: this.isLeftToRight() ? "ltr" : "rtl"
				});
				this.backButton.placeAt(this.domNode, "first");
			}else{
				this.backButton.set("label", back);
			}
			this.resize();
		},
		
		_setMoveToAttr: function(/*String*/moveTo){
			// tags:
			//		private
			this._set("moveTo", moveTo);
			if(this.backButton){
				this.backButton.set("moveTo", moveTo);
				this.backButton.set("back", !moveTo && !this.href);
			}
		},
		
		_setHrefAttr: function(/*String*/href){
			// tags:
			//		private
			this._set("href", href);
			if(this.backButton){
				this.backButton.set("href", href);
				this.backButton.set("back", !this.moveTo && !href);
			}
		},
		
		_setTransitionAttr: function(/*String*/transition){
			// tags:
			//		private
			this._set("transition", transition);
			if(this.backButton){
				this.backButton.set("transition", transition);
			}
		},
		
		_setLabelAttr: function(/*String*/label){
			// tags:
			//		private
			this._set("label", label);
			this.labelNode.innerHTML = this.labelDivNode.innerHTML = this._cv ? this._cv(label) : label;
			delete this.labelNodeLen;
		},

		_setBusyAttr: function(/*Boolean*/busy){
			// tags:
			//		private
			var prog = this._prog;
			if(busy){
				if(!prog){
					prog = this._prog = new ProgressIndicator({size:30, center:false});
					domClass.add(prog.domNode, this.progStyle);
				}
				domConstruct.place(prog.domNode, this.domNode, "first");
				prog.start();
			}else if(prog){
				prog.stop();
			}
			this._set("busy", busy);
		}	
	});

	return has("dojo-bidi") ? declare("dojox.mobile.Heading", [Heading, BidiHeading]) : Heading;
});

},
'dijit/_base/manager':function(){
define([
	"dojo/_base/array",
	"dojo/_base/config", // defaultDuration
	"dojo/_base/lang",
	"../registry",
	"../main"	// for setting exports to dijit namespace
], function(array, config, lang, registry, dijit){

	// module:
	//		dijit/_base/manager

	var exports = {
		// summary:
		//		Deprecated.  Shim to methods on registry, plus a few other declarations.
		//		New code should access dijit/registry directly when possible.
	};

	array.forEach(["byId", "getUniqueId", "findWidgets", "_destroyAll", "byNode", "getEnclosingWidget"], function(name){
		exports[name] = registry[name];
	});

	 lang.mixin(exports, {
		 // defaultDuration: Integer
		 //		The default fx.animation speed (in ms) to use for all Dijit
		 //		transitional fx.animations, unless otherwise specified
		 //		on a per-instance basis. Defaults to 200, overrided by
		 //		`djConfig.defaultDuration`
		 defaultDuration: config["defaultDuration"] || 200
	 });

	lang.mixin(dijit, exports);

	/*===== return exports; =====*/
	return dijit;	// for back compat :-(
});

},
'dojox/mobile/compat':function(){
define([
	"dojo/_base/lang",
	"dojo/sniff"
], function(lang, has){
	// module:
	//		dojox/mobile/compat

	var dm = lang.getObject("dojox.mobile", true);
	// TODO: Use feature detection instead, but this would require a major rewrite of _compat
	// to detect each feature and plug the corresponding compat code if needed.
	// Currently the compat code is a workaround for too many different things to be able to
	// decide based on feature detection. So for now we just disable _compat on the mobile browsers
	// that are known to support enough CSS3: all webkit-based browsers, IE10 (Windows [Phone] 8) and IE11+.
	if(!(has("webkit") || has("ie") === 10) || (!has("ie") && has("trident") > 6)){
		var s = "dojox/mobile/_compat"; // assign to a variable so as not to be picked up by the build tool
		require([s]);
	}
	
	/*=====
	return {
		// summary:
		//		CSS3 compatibility module.
		// description:
		//		This module provides to dojox/mobile support for some of the CSS3 features 
		//		in non-CSS3 browsers, such as IE or Firefox.
		//		If you require this module, when running in a non-CSS3 browser it directly 
		//		replaces some of the methods of	dojox/mobile classes, without any subclassing. 
		//		This way, HTML pages remain the same regardless of whether this compatibility 
		//		module is used or not.
		//
		//		Example of usage: 
		//		|	require([
		//		|		"dojox/mobile",
		//		|		"dojox/mobile/compat",
		//		|		...
		//		|	], function(...){
		//		|		...
		//		|	});
		//
		//		This module also loads compatibility CSS files, which have a -compat.css
		//		suffix. You can use either the `<link>` tag or `@import` to load theme
		//		CSS files. Then, this module searches for the loaded CSS files and loads
		//		compatibility CSS files. For example, if you load dojox/mobile/themes/iphone/iphone.css
		//		in a page, this module automatically loads dojox/mobile/themes/iphone/iphone-compat.css.
		//		If you explicitly load iphone-compat.css with `<link>` or `@import`,
		//		this module will not load again the already loaded file.
		//
		//		Note that, by default, compatibility CSS files are only loaded for CSS files located
		//		in a directory containing a "mobile/themes" path. For that, a matching is done using 
		//		the default pattern	"/\/mobile\/themes\/.*\.css$/". If a custom theme is not located 
		//		in a directory containing this path, the data-dojo-config needs to specify a custom 
		//		pattern using the "mblLoadCompatPattern" configuration parameter, for instance:
		// |	data-dojo-config="mblLoadCompatPattern: /\/mycustomtheme\/.*\.css$/"
	};
	=====*/
	return dm;
});

},
'wc/mobile/ProgressIndicator':function(){
// wrapped by build app
define(["dijit","dojo","dojox","dojo/require!dojox/mobile/ProgressIndicator"], function(dijit,dojo,dojox){
//-----------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (C) Copyright IBM Corp. 2011 All Rights Reserved.
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with
// IBM Corp.
//-----------------------------------------------------------------

dojo.provide("wc.mobile.ProgressIndicator");

dojo.require("dojox.mobile.ProgressIndicator");

dojo.declare("wc.mobile.ProgressIndicator", [ dojox.mobile.ProgressIndicator ], {

	start: function() {
	
		if (!this.underLay) {
			this.underLay = dojo.create('div', {style: {position:'absolute', top:'0px', left:'0px', width:'100%', height:'100%'}}, this.domNode, 'before');
		}
		
		this.inherited(arguments);
	},

	stop: function(){

		if (this.underLay) {
			dojo.destroy(this.underLay);
		}
		this.inherited(arguments);
	}

});

wc.mobile.ProgressIndicator._instance = null;
wc.mobile.ProgressIndicator.getInstance = function(){
	if(!wc.mobile.ProgressIndicator._instance){
		wc.mobile.ProgressIndicator._instance = new wc.mobile.ProgressIndicator();
	}
	return wc.mobile.ProgressIndicator._instance;
};


});

},
'dojox/mobile/Switch':function(){
define([
	"dojo/_base/array",
	"dojo/_base/connect",
	"dojo/_base/declare",
	"dojo/_base/event",
	"dojo/_base/window",
	"dojo/dom-class",
	"dojo/dom-construct",
	"dojo/dom-style",
	"dojo/dom-attr",
	"dojo/touch",
	"dijit/_Contained",
	"dijit/_WidgetBase",
	"./sniff",
	"./_maskUtils",
	"./common",
	"dojo/has!dojo-bidi?dojox/mobile/bidi/Switch"
], function(array, connect, declare, event, win, domClass, domConstruct, domStyle, domAttr, touch, Contained, WidgetBase, has, maskUtils, dm, BidiSwitch){

	// module:
	//		dojox/mobile/Switch

	var Switch = declare(has("dojo-bidi") ? "dojox.mobile.NonBidiSwitch" : "dojox.mobile.Switch", [WidgetBase, Contained],{
		// summary:
		//		A toggle switch with a sliding knob.
		// description:
		//		Switch is a toggle switch with a sliding knob. You can either
		//		tap or slide the knob to toggle the switch. The onStateChanged
		//		handler is called when the switch is manipulated.

		// value: String
		//		The initial state of the switch: "on" or "off". The default
		//		value is "on".
		value: "on",

		// name: String
		//		A name for a hidden input field, which holds the current value.
		name: "",

		// leftLabel: String
		//		The left-side label of the switch.
		leftLabel: "ON",

		// rightLabel: String
		//		The right-side label of the switch.
		rightLabel: "OFF",

		// shape: String
		//		The shape of the switch.
		//		"mblSwDefaultShape", "mblSwSquareShape", "mblSwRoundShape1",
		//		"mblSwRoundShape2", "mblSwArcShape1" or "mblSwArcShape2".
		//		The default value is "mblSwDefaultShape".
		shape: "mblSwDefaultShape",

		// tabIndex: String
		//		Tabindex setting for this widget so users can hit the tab key to
		//		focus on it.
		tabIndex: "0",
		_setTabIndexAttr: "", // sets tabIndex to domNode

		/* internal properties */
		baseClass: "mblSwitch",
		// role: [private] String
		//		The accessibility role.
		role: "", // a11y

		buildRendering: function(){
			if(!this.templateString){ // true if this widget is not templated
				this.domNode = (this.srcNodeRef && this.srcNodeRef.tagName === "SPAN") ?
					this.srcNodeRef : domConstruct.create("span");
			}
			// prevent browser scrolling on IE10 (evt.preventDefault() is not enough)
			dm._setTouchAction(this.domNode, "none");
			this.inherited(arguments);
			if(!this.templateString){ // true if this widget is not templated
				var c = (this.srcNodeRef && this.srcNodeRef.className) || this.className || this["class"];
				if((c = c.match(/mblSw.*Shape\d*/))){ this.shape = c; }
				domClass.add(this.domNode, this.shape);
				var nameAttr = this.name ? " name=\"" + this.name + "\"" : "";
				this.domNode.innerHTML =
					  '<div class="mblSwitchInner">'
					+	'<div class="mblSwitchBg mblSwitchBgLeft">'
					+		'<div class="mblSwitchText mblSwitchTextLeft"></div>'
					+	'</div>'
					+	'<div class="mblSwitchBg mblSwitchBgRight">'
					+		'<div class="mblSwitchText mblSwitchTextRight"></div>'
					+	'</div>'
					+	'<div class="mblSwitchKnob"></div>'
					+	'<input type="hidden"'+nameAttr+' value="'+this.value+'"></div>'
					+ '</div>';
				var n = this.inner = this.domNode.firstChild;
				this.left = n.childNodes[0];
				this.right = n.childNodes[1];
				this.knob = n.childNodes[2];
				this.input = n.childNodes[3];
			}
			domAttr.set(this.domNode, "role", "checkbox"); //a11y
			domAttr.set(this.domNode, "aria-checked", (this.value === "on") ? "true" : "false"); //a11y

			this.switchNode = this.domNode;

			if(has("windows-theme")) {
				var rootNode = domConstruct.create("div", {className: "mblSwitchContainer"});
				this.labelNode = domConstruct.create("label", {"class": "mblSwitchLabel", "for": this.id}, rootNode);
				rootNode.appendChild(this.domNode.cloneNode(true));
				this.domNode = rootNode;
				this.focusNode = rootNode.childNodes[1];
				this.labelNode.innerHTML = (this.value=="off") ? this.rightLabel : this.leftLabel;
				this.switchNode = this.domNode.childNodes[1];
				var inner = this.inner = this.domNode.childNodes[1].firstChild;
				this.left = inner.childNodes[0];
				this.right = inner.childNodes[1];
				this.knob = inner.childNodes[2];
				this.input = inner.childNodes[3];
			}
		},

		postCreate: function(){
			this.connect(this.switchNode, "onclick", "_onClick");
			this.connect(this.switchNode, "onkeydown", "_onClick"); // for desktop browsers
			this._startHandle = this.connect(this.switchNode, touch.press, "onTouchStart");
			this._initialValue = this.value; // for reset()
		},

		startup: function(){
			this.inherited(arguments);
			if(!this._started){
				this.resize();
			}
		},

		resize: function(){
			if(has("windows-theme")){
				// Override the custom CSS width (if any) to avoid misplacement.
				// Per design, the windows theme does not allow resizing the controls.
				// The label of the switch is placed next to the switch, and a custom
				// width would only have the effect to increase the distance between the
				// label and the switch, which is undesired. Hence, on windows theme,
				// ensure the width of root DOM node is 100%.
				domStyle.set(this.domNode, "width", "100%");
			}else{
				var value = domStyle.get(this.domNode,"width");
				var outWidth = value + "px";
				var innWidth = (value - domStyle.get(this.knob,"width")) + "px";
				domStyle.set(this.left, "width", outWidth);
				domStyle.set(this.right,this.isLeftToRight()?{width: outWidth, left: innWidth}:{width: outWidth});
				domStyle.set(this.left.firstChild, "width", innWidth);
				domStyle.set(this.right.firstChild, "width", innWidth);
				domStyle.set(this.knob, "left", innWidth);
				if(this.value == "off"){
					domStyle.set(this.inner, "left", this.isLeftToRight()?("-" + innWidth):0);
				}
				this._hasMaskImage = false;
				this._createMaskImage();
			}
		},

		_changeState: function(/*String*/state, /*Boolean*/anim){
			var on = (state === "on");
			this.left.style.display = "";
			this.right.style.display = "";
			this.inner.style.left = "";
			if(anim){
				domClass.add(this.switchNode, "mblSwitchAnimation");
			}
			domClass.remove(this.switchNode, on ? "mblSwitchOff" : "mblSwitchOn");
			domClass.add(this.switchNode, on ? "mblSwitchOn" : "mblSwitchOff");
			domAttr.set(this.switchNode, "aria-checked", on ? "true" : "false"); //a11y

			if(!on && !has("windows-theme")){
				this.inner.style.left  = (this.isLeftToRight()?(-(domStyle.get(this.domNode,"width") - domStyle.get(this.knob,"width"))):0) + "px";
			}

			var _this = this;
			_this.defer(function(){
				_this.left.style.display = on ? "" : "none";
				_this.right.style.display = !on ? "" : "none";
				domClass.remove(_this.switchNode, "mblSwitchAnimation");
			}, anim ? 300 : 0);
		},

		_createMaskImage: function(){
			if(this._timer){
				 this._timer.remove();
				 delete this._timer;
			}
			if(this._hasMaskImage){ return; }
			var w = domStyle.get(this.domNode,"width"), h = domStyle.get(this.domNode,"height");
			this._width = (w - domStyle.get(this.knob,"width"));
			this._hasMaskImage = true;
			if(!(has("mask-image"))){ return; }
			var rDef = domStyle.get(this.left, "borderTopLeftRadius");
			if(rDef == "0px"){ return; }
			var rDefs = rDef.split(" ");
			var rx = parseFloat(rDefs[0]), ry = (rDefs.length == 1) ? rx : parseFloat(rDefs[1]);
			var id = (this.shape+"Mask"+w+h+rx+ry).replace(/\./,"_");

			maskUtils.createRoundMask(this.switchNode, 0, 0, 0, 0, w, h, rx, ry, 1);
		},

		_onClick: function(e){
			// summary:
			//		Internal handler for click events.
			// tags:
			//		private
			if(e && e.type === "keydown" && e.keyCode !== 13){ return; }
			if(this.onClick(e) === false){ return; } // user's click action
			if(this._moved){ return; }
			this._set("value", this.input.value = (this.value == "on") ? "off" : "on");
			this._changeState(this.value, true);
			this.onStateChanged(this.value);
		},

		onClick: function(/*Event*/ /*===== e =====*/){
			// summary:
			//		User defined function to handle clicks
			// tags:
			//		callback
		},

		onTouchStart: function(/*Event*/e){
			// summary:
			//		Internal function to handle touchStart events.
			this._moved = false;
			this.innerStartX = this.inner.offsetLeft;
			if(!this._conn){
				this._conn = [
					this.connect(this.inner, touch.move, "onTouchMove"),
					this.connect(win.doc, touch.release, "onTouchEnd")
				];

				/* While moving the slider knob sometimes IE fires MSPointerCancel event. That prevents firing
				MSPointerUp event (http://msdn.microsoft.com/ru-ru/library/ie/hh846776%28v=vs.85%29.aspx) so the
				knob can be stuck in the middle of the switch. As a fix we handle MSPointerCancel event with the
				same lintener as for MSPointerUp event.
				*/
				if(has("windows-theme")){
					this._conn.push(this.connect(win.doc, "MSPointerCancel", "onTouchEnd"));
				}
			}
			this.touchStartX = e.touches ? e.touches[0].pageX : e.clientX;
			this.left.style.display = "";
			this.right.style.display = "";
			event.stop(e);
			this._createMaskImage();
		},

		onTouchMove: function(/*Event*/e){
			// summary:
			//		Internal function to handle touchMove events.
			e.preventDefault();
			var dx;
			if(e.targetTouches){
				if(e.targetTouches.length != 1){ return; }
				dx = e.targetTouches[0].clientX - this.touchStartX;
			}else{
				dx = e.clientX - this.touchStartX;
			}
			var pos = this.innerStartX + dx;
			var d = 10;
			if(pos <= -(this._width-d)){ pos = -this._width; }
			if(pos >= -d){ pos = 0; }
			this.inner.style.left = pos + "px";
			if(Math.abs(dx) > d){
				this._moved = true;
			}
		},

		onTouchEnd: function(/*Event*/e){
			// summary:
			//		Internal function to handle touchEnd events.
			array.forEach(this._conn, connect.disconnect);
			this._conn = null;
			if(this.innerStartX == this.inner.offsetLeft){
				// need to send a synthetic click?
				if(has("touch") && has("clicks-prevented")){
					dm._sendClick(this.inner, e);
				}
				return;
			}
			var newState = (this.inner.offsetLeft < -(this._width/2)) ? "off" : "on";
			newState = this._newState(newState);
			this._changeState(newState, true);
			if(newState != this.value){
				this._set("value", this.input.value = newState);
				this.onStateChanged(newState);
			}
		},
		_newState: function(newState){
			return newState;
		},
		onStateChanged: function(/*String*/newState){
			// summary:
			//		Stub function to connect to from your application.
			// description:
			//		Called when the state has been changed.
			if (this.labelNode) {
				this.labelNode.innerHTML = newState=='off' ? this.rightLabel : this.leftLabel;
			}
		},

		_setValueAttr: function(/*String*/value){
			this._changeState(value, false);
			if(this.value != value){
				this._set("value", this.input.value = value);
				this.onStateChanged(value);
			}
		},

		_setLeftLabelAttr: function(/*String*/label){
			this.leftLabel = label;
			this.left.firstChild.innerHTML = this._cv ? this._cv(label) : label;
		},

		_setRightLabelAttr: function(/*String*/label){
			this.rightLabel = label;
			this.right.firstChild.innerHTML = this._cv ? this._cv(label) : label;
		},

		reset: function(){
			// summary:
			//		Reset the widget's value to what it was at initialization time
			this.set("value", this._initialValue);
		}
	});

	return has("dojo-bidi") ? declare("dojox.mobile.Switch", [Switch, BidiSwitch]) : Switch;
});

},
'dojox/mobile/_maskUtils':function(){
define([
	"dojo/_base/window",
	"dojo/dom-style",
	"./sniff"
], function(win, domStyle, has){

	has.add("mask-image-css", function(global, doc, elt){
		return typeof doc.getCSSCanvasContext === "function" && typeof elt.style.webkitMaskImage !== "undefined";
	});

	// Indicates whether image mask is available (either via css mask image or svg)
	has.add("mask-image", function(){
		return has("mask-image-css") || has("svg");
	});

	var cache = {};

	return {
		// summary:
		//		Utility methods to clip rounded corners of various elements (Switch, ScrollablePane, scrollbars in scrollable widgets).
		//		Uses -webkit-mask-image on webkit, or SVG on other browsers.
		
		createRoundMask: function(/*DomNode*/node, x, y, r, b, w, h, rx, ry, e){
			// summary:
			//		Creates and sets a mask for the specified node.
			
			var tw = x + w + r;
			var th = y + h + b;
			
			if(has("mask-image-css")){			// use -webkit-mask-image
				var id = ("DojoMobileMask" + x + y + w + h + rx + ry).replace(/\./g, "_");
				if (!cache[id]) {
					cache[id] = 1;
					var ctx = win.doc.getCSSCanvasContext("2d", id, tw, th);
					ctx.beginPath();
					if (rx == ry) {
						// round arc
						if(rx == 2 && w == 5){
							// optimized case for vertical scrollbar
							ctx.fillStyle = "rgba(0,0,0,0.5)";
							ctx.fillRect(1, 0, 3, 2);
							ctx.fillRect(0, 1, 5, 1);
							ctx.fillRect(0, h - 2, 5, 1);
							ctx.fillRect(1, h - 1, 3, 2);
							ctx.fillStyle = "rgb(0,0,0)";
							ctx.fillRect(0, 2, 5, h - 4);
						}else if(rx == 2 && h == 5){
							// optimized case for horizontal scrollbar
							ctx.fillStyle = "rgba(0,0,0,0.5)";
							ctx.fillRect(0, 1, 2, 3);
							ctx.fillRect(1, 0, 1, 5);
							ctx.fillRect(w - 2, 0, 1, 5);
							ctx.fillRect(w - 1, 1, 2, 3);
							ctx.fillStyle = "rgb(0,0,0)";
							ctx.fillRect(2, 0, w - 4, 5);
						}else{
							// general case
							ctx.fillStyle = "#000000";
							ctx.moveTo(x+rx, y);
							ctx.arcTo(x, y, x, y+rx, rx);
							ctx.lineTo(x, y+h - rx);
							ctx.arcTo(x, y+h, x+rx, y+h, rx);
							ctx.lineTo(x+w - rx, y+h);
							ctx.arcTo(x+w, y+h, x+w, y+rx, rx);
							ctx.lineTo(x+w, y+rx);
							ctx.arcTo(x+w, y, x+w - rx, y, rx);
						}
					} else {
						// elliptical arc
						var pi = Math.PI;
						ctx.scale(1, ry / rx);
						ctx.moveTo(x+rx, y);
						ctx.arc(x+rx, y+rx, rx, 1.5 * pi, 0.5 * pi, true);
						ctx.lineTo(x+w - rx, y+2 * rx);
						ctx.arc(x+w - rx, y+rx, rx, 0.5 * pi, 1.5 * pi, true);
					}
					ctx.closePath();
					ctx.fill();
				}
				node.style.webkitMaskImage = "-webkit-canvas(" + id + ")";
			}else if(has("svg")){		// add an SVG image to clip the corners.
				if(node._svgMask){
					node.removeChild(node._svgMask);
				}
				var bg = null;
				for(var p = node.parentNode; p; p = p.parentNode){
					bg = domStyle.getComputedStyle(p).backgroundColor;
					if(bg && bg != "transparent" && !bg.match(/rgba\(.*,\s*0\s*\)/)){
						break;
					}
				}
				var svgNS = "http://www.w3.org/2000/svg";
				var svg = win.doc.createElementNS(svgNS, "svg");
				svg.setAttribute("width", tw);
				svg.setAttribute("height", th);
				svg.style.position = "absolute";
				svg.style.pointerEvents = "none";
				svg.style.opacity = "1";
				svg.style.zIndex = "2147483647"; // max int
				var path = win.doc.createElementNS(svgNS, "path");
				e = e || 0;
				rx += e;
				ry += e;
				// TODO: optimized cases for scrollbars as in webkit case?
				var d = " M" + (x + rx - e) + "," + (y - e) + " a" + rx + "," + ry + " 0 0,0 " + (-rx) + "," + ry + " v" + (-ry) + " h" + rx + " Z" +
						" M" + (x - e) + "," + (y + h - ry + e) + " a" + rx + "," + ry + " 0 0,0 " + rx + "," + ry + " h" + (-rx) + " v" + (-ry) + " z" +
						" M" + (x + w - rx + e) + "," + (y + h + e) + " a" + rx + "," + ry + " 0 0,0 " + rx + "," + (-ry) + " v" + ry + " h" + (-rx) + " z" +
						" M" + (x + w + e) + "," + (y + ry - e) + " a" + rx + "," + ry + " 0 0,0 " + (-rx) + "," + (-ry) + " h" + rx + " v" + ry + " z";
				if(y > 0){
					d += " M0,0 h" + tw + " v" + y + " h" + (-tw) + " z";
				}
				if(b > 0){
					d += " M0," + (y + h) + " h" + tw + " v" + b + " h" + (-tw) + " z";
				}
				path.setAttribute("d", d);
				path.setAttribute("fill", bg);
				path.setAttribute("stroke", bg);
				path.style.opacity = "1";
				svg.appendChild(path); 
				node._svgMask = svg;
				node.appendChild(svg);
			}
		}
	};
});

},
'dojox/mobile/ListItem':function(){
define([
	"dojo/_base/array",
	"dojo/_base/declare",
	"dojo/_base/lang",
	"dojo/dom-class",
	"dojo/dom-construct",
	"dojo/dom-style",
	"dojo/dom-attr",
	"dijit/registry",
	"dijit/_WidgetBase",
	"./iconUtils",
	"./_ItemBase",
	"./ProgressIndicator",
	"dojo/has",
	"dojo/has!dojo-bidi?dojox/mobile/bidi/ListItem"
], function(array, declare, lang, domClass, domConstruct, domStyle, domAttr, registry, WidgetBase, iconUtils, ItemBase, ProgressIndicator, has,  BidiListItem){

	// module:
	//		dojox/mobile/ListItem

	var ListItem = declare(has("dojo-bidi") ? "dojox.mobile.NonBidiListItem" : "dojox.mobile.ListItem", ItemBase, {
		// summary:
		//		An item of either RoundRectList or EdgeToEdgeList.
		// description:
		//		ListItem represents an item of either RoundRectList or
		//		EdgeToEdgeList. There are three ways to move to a different view:
		//		moveTo, href, and url. You can choose only one of them.
		//
		//		A child DOM node (or widget) can have the layout attribute,
		//		whose value is "left", "right", or "center". Such nodes will be
		//		aligned as specified.
		// example:
		// |	<li data-dojo-type="dojox.mobile.ListItem">
		// |		<div layout="left">Left Node</div>
		// |		<div layout="right">Right Node</div>
		// |		<div layout="center">Center Node</div>
		// |	</li>
		//
		//		Similarly, a child widget can have the preventTouch
		//		attribute, whose value is a boolean (or data-mobile-prevent-touch
		//		for children which are not widgets), such that touching such
		//		child doesn't trigger the item action.
		//
		//		Note that even if you specify variableHeight="true" for the list
		//		and place a tall object inside the layout node as in the example
		//		below, the layout node does not expand as you may expect,
		//		because layout node is aligned using float:left, float:right, or
		//		position:absolute.
		// example:
		// |	<li data-dojo-type="dojox.mobile.ListItem" variableHeight="true">
		// |		<div layout="left"><img src="large-picture.jpg"></div>
		// |	</li>

		// rightText: String
		//		A right-aligned text to display on the item.
		rightText: "",

		// rightIcon: String
		//		An icon to display at the right hand side of the item. The value
		//		can be either a path for an image file or a class name of a DOM
		//		button.
		rightIcon: "",

		// rightIcon2: String
		//		An icon to display at the left of the rightIcon. The value can
		//		be either a path for an image file or a class name of a DOM
		//		button.
		rightIcon2: "",

		// deleteIcon: String
		//		A delete icon to display at the left of the item. The value can
		//		be either a path for an image file or a class name of a DOM
		//		button.
		deleteIcon: "",

		// anchorLabel: Boolean
		//		If true, the label text becomes a clickable anchor text. When
		//		the user clicks on the text, the onAnchorLabelClicked handler is
		//		called. You can override or connect to the handler and implement
		//		any action. The handler has no default action.
		anchorLabel: false,

		// noArrow: Boolean
		//		If true, the right hand side arrow is not displayed.
		noArrow: false,

		// checked: Boolean
		//		If true, a check mark is displayed at the right of the item.
		checked: false,

		// arrowClass: String
		//		An icon to display as an arrow. The value can be either a path
		//		for an image file or a class name of a DOM button.
		arrowClass: "",

		// checkClass: String
		//		An icon to display as a check mark. The value can be either a
		//		path for an image file or a class name of a DOM button.
		checkClass: "",

		// uncheckClass: String
		//		An icon to display as an uncheck mark. The value can be either a
		//		path for an image file or a class name of a DOM button.
		uncheckClass: "",

		// variableHeight: Boolean
		//		If true, the height of the item varies according to its content.
		variableHeight: false,

		// rightIconTitle: String
		//		An alt text for the right icon.
		rightIconTitle: "",

		// rightIcon2Title: String
		//		An alt text for the right icon2.
		rightIcon2Title: "",

		// header: Boolean
		//		If true, this item is rendered as a category header.
		header: false,

		// tag: String
		//		A name of html tag to create as domNode.
		tag: "li",

		// busy: Boolean
		//		If true, a progress indicator spins.
		busy: false,

		// progStyle: String
		//		A css class name to add to the progress indicator.
		progStyle: "",

		// layoutOnResize: Boolean
		//		If true, a call to resize() will force computation of variable height items layout. You should not need this as in most
		//		cases ListItem height doesn't change on container resize. Depending on number and complexity
		//		of items in a view, setting to true may have a high impact on performance.
		layoutOnResize: false,

		/* internal properties */	
		// The following properties are overrides of those in _ItemBase.
		paramsToInherit: "variableHeight,transition,deleteIcon,icon,rightIcon,rightIcon2,uncheckIcon,arrowClass,checkClass,uncheckClass,deleteIconTitle,deleteIconRole",
		baseClass: "mblListItem",

		_selStartMethod: "touch",
		_selEndMethod: "timer",
		_delayedSelection: true,

		_selClass: "mblListItemSelected",

		buildRendering: function(){
			this._templated = !!this.templateString; // true if this widget is templated
			if(!this._templated){
				// Create root node if it wasn't created by _TemplatedMixin
				this.domNode = this.containerNode = this.srcNodeRef || domConstruct.create(this.tag);
			}
			this.inherited(arguments);

			if(this.selected){
				domClass.add(this.domNode, this._selClass);
			}
			if(this.header){
				domClass.replace(this.domNode, "mblEdgeToEdgeCategory", this.baseClass);
			}

			if(!this._templated){
				this.labelNode =
					domConstruct.create("div", {className:"mblListItemLabel"});
				var ref = this.srcNodeRef;
				if(ref && ref.childNodes.length === 1 && ref.firstChild.nodeType === 3){
					// if ref has only one text node, regard it as a label
					this.labelNode.appendChild(ref.firstChild);
				}
				this.domNode.appendChild(this.labelNode);
			}
			this._layoutChildren = [];
		},

		startup: function(){
			if(this._started){ return; }
			var parent = this.getParent();
			var opts = this.getTransOpts();
			// When using a template, labelNode may be created via an attach point.
			// The attach points are not yet set when ListItem.buildRendering() 
			// executes, hence the need to use them in startup().
			if((!this._templated || this.labelNode) && this.anchorLabel){
				this.labelNode.style.display = "inline"; // to narrow the text region
				this.labelNode.style.cursor = "pointer";
				this.connect(this.labelNode, "onclick", "_onClick");
				this.onTouchStart = function(e){
					return (e.target !== this.labelNode);
				};
			}

			this.inherited(arguments);
			
			if(domClass.contains(this.domNode, "mblVariableHeight")){
				this.variableHeight = true;
			}
			if(this.variableHeight){
				domClass.add(this.domNode, "mblVariableHeight");
				this.defer("layoutVariableHeight");
			}

			if(!this._isOnLine){
				this._isOnLine = true;
				this.set({ 
					// retry applying the attributes for which the custom setter delays the actual 
					// work until _isOnLine is true
					icon: this._pending_icon !== undefined ? this._pending_icon : this.icon,
					deleteIcon: this._pending_deleteIcon !== undefined ? this._pending_deleteIcon : this.deleteIcon,
					rightIcon: this._pending_rightIcon !== undefined ? this._pending_rightIcon : this.rightIcon,
					rightIcon2: this._pending_rightIcon2 !== undefined ? this._pending_rightIcon2 : this.rightIcon2,
					uncheckIcon: this._pending_uncheckIcon !== undefined ? this._pending_uncheckIcon : this.uncheckIcon 
				});
				// Not needed anymore (this code executes only once per life cycle):
				delete this._pending_icon;
				delete this._pending_deleteIcon;
				delete this._pending_rightIcon;
				delete this._pending_rightIcon2;
				delete this._pending_uncheckIcon;
			}
			if(parent && parent.select){
				// retry applying the attributes for which the custom setter delays the actual 
				// work until _isOnLine is true. 
				this.set("checked", this._pendingChecked !== undefined ? this._pendingChecked : this.checked);
				domAttr.set(this.domNode, "role", "option");
				if(this._pendingChecked || this.checked){
					domAttr.set(this.domNode, "aria-selected", "true");
				}
				// Not needed anymore (this code executes only once per life cycle):
				delete this._pendingChecked; 
			}
			this.setArrow();
			this.layoutChildren();
		},

		_updateHandles: function(){
			// tags:
			//		private
			var parent = this.getParent();
			var opts = this.getTransOpts();
			if(opts.moveTo || opts.href || opts.url || this.clickable || (parent && parent.select)){
				if(!this._keydownHandle){
					this._keydownHandle = this.connect(this.domNode, "onkeydown", "_onClick"); // for desktop browsers
				}
				this._handleClick = true;
			}else{
				if(this._keydownHandle){
					this.disconnect(this._keydownHandle);
					this._keydownHandle = null;
				}
				this._handleClick = false;
			}
			this.inherited(arguments);
		},

		layoutChildren: function(){
			var centerNode;
			array.forEach(this.domNode.childNodes, function(n){
				if(n.nodeType !== 1){ return; }
				var layout = n.getAttribute("layout") || // TODO: Remove the non-HTML5-compliant attribute in 2.0
					n.getAttribute("data-mobile-layout") || 
					(registry.byNode(n) || {}).layout;
				if(layout){ 
					domClass.add(n, "mblListItemLayout" +
						layout.charAt(0).toUpperCase() + layout.substring(1));
					this._layoutChildren.push(n);
					if(layout === "center"){ centerNode = n; }
				}
			}, this);
			if(centerNode){
				this.domNode.insertBefore(centerNode, this.domNode.firstChild);
			}
		},

		resize: function(){
			if(this.layoutOnResize && this.variableHeight){
				this.layoutVariableHeight();
			}
			// labelNode may not exist only when using a template (if not created by an attach point)
			if(!this._templated || this.labelNode){
				// If labelNode is empty, shrink it so as not to prevent user clicks.
				this.labelNode.style.display = this.labelNode.firstChild ? "block" : "inline";
			}
		},

		_onTouchStart: function(e){
			// tags:
			//		private
			if(e.target.getAttribute("preventTouch") || // TODO: Remove the non-HTML5-compliant attribute in 2.0
				e.target.getAttribute("data-mobile-prevent-touch") ||
				(registry.getEnclosingWidget(e.target) || {}).preventTouch){
				return;
			}
			this.inherited(arguments);
		},

		_onClick: function(e){
			// summary:
			//		Internal handler for click events.
			// tags:
			//		private
			if(this.getParent().isEditing || e && e.type === "keydown" && e.keyCode !== 13){ return; }
			if(this.onClick(e) === false){ return; } // user's click action
			var n = this.labelNode;
			// labelNode may not exist only when using a template 
			if((this._templated || n) && this.anchorLabel && e.currentTarget === n){
				domClass.add(n, "mblListItemLabelSelected");
				this.defer(function(){
					domClass.remove(n, "mblListItemLabelSelected");
				}, this._duration);
				this.onAnchorLabelClicked(e);
				return;
			}
			var parent = this.getParent();
			if(parent.select){
				if(parent.select === "single"){
					if(!this.checked){
						this.set("checked", true);
					}
				}else if(parent.select === "multiple"){
					this.set("checked", !this.checked);
				}
			}
			this.defaultClickAction(e);
		},

		onClick: function(/*Event*/ /*===== e =====*/){
			// summary:
			//		User-defined function to handle clicks.
			// tags:
			//		callback
		},

		onAnchorLabelClicked: function(e){
			// summary:
			//		Stub function to connect to from your application.
		},

		layoutVariableHeight: function(){
			// summary:
			//		Lays out the current item with variable height.
			var h = this.domNode.offsetHeight;
			if(h === this.domNodeHeight){ return; }
			this.domNodeHeight = h;
			array.forEach(this._layoutChildren.concat([
				this.rightTextNode,
				this.rightIcon2Node,
				this.rightIconNode,
				this.uncheckIconNode,
				this.iconNode,
				this.deleteIconNode,
				this.knobIconNode
			]), function(n){
				if(n){
					var domNode = this.domNode;
					var f = function(){
						var t = Math.round((domNode.offsetHeight - n.offsetHeight) / 2) -
							domStyle.get(domNode, "paddingTop");
						n.style.marginTop = t + "px";
					};
					if(n.offsetHeight === 0 && n.tagName === "IMG"){
						n.onload = f;
					}else{
						f();
					}
				}
			}, this);
		},

		setArrow: function(){
			// summary:
			//		Sets the arrow icon if necessary.
			if(this.checked){ return; }
			var c = "";
			var parent = this.getParent();
			var opts = this.getTransOpts();
			if(opts.moveTo || opts.href || opts.url || this.clickable){
				if(!this.noArrow && !(parent && parent.selectOne)){
					c = this.arrowClass || "mblDomButtonArrow";
					domAttr.set(this.domNode, "role", "button");
				}
			}
			if(c){
				this._setRightIconAttr(c);
			}
		},

		_findRef: function(/*String*/type){
			// summary:
			//		Find an appropriate position to insert a new child node.
			// tags:
			//		private
			var i, node, list = ["deleteIcon", "icon", "rightIcon", "uncheckIcon", "rightIcon2", "rightText"];
			for(i = array.indexOf(list, type) + 1; i < list.length; i++){
				node = this[list[i] + "Node"];
				if(node){ return node; }
			}
			for(i = list.length - 1; i >= 0; i--){
				node = this[list[i] + "Node"];
				if(node){ return node.nextSibling; }
			}
			return this.domNode.firstChild;
		},
		
		_setIcon: function(/*String*/icon, /*String*/type){
			// tags:
			//		private
			if(!this._isOnLine){
				// record the value to be able to reapply it (see the code in the startup method)
				this["_pending_" + type] = icon;
				return; 
			} // icon may be invalid because inheritParams is not called yet
			this._set(type, icon);
			this[type + "Node"] = iconUtils.setIcon(icon, this[type + "Pos"],
				this[type + "Node"], this[type + "Title"] || this.alt, this.domNode, this._findRef(type), "before");
			if(this[type + "Node"]){
				var cap = type.charAt(0).toUpperCase() + type.substring(1);
				domClass.add(this[type + "Node"], "mblListItem" + cap);
			}
			var role = this[type + "Role"];
			if(role){
				this[type + "Node"].setAttribute("role", role);
			}
		},

		_setDeleteIconAttr: function(/*String*/icon){
			// tags:
			//		private
			this._setIcon(icon, "deleteIcon");
		},

		_setIconAttr: function(icon){
			// tags:
			//		private
			this._setIcon(icon, "icon");
		},

		_setRightTextAttr: function(/*String*/text){
			// tags:
			//		private
			if(!this._templated && !this.rightTextNode){
				// When using a template, let the template create the element.
				this.rightTextNode = domConstruct.create("div", {className:"mblListItemRightText"}, this.labelNode, "before");
			}
			this.rightText = text;
			this.rightTextNode.innerHTML = this._cv ? this._cv(text) : text;
		},

		_setRightIconAttr: function(/*String*/icon){
			// tags:
			//		private
			this._setIcon(icon, "rightIcon");
		},

		_setUncheckIconAttr: function(/*String*/icon){
			// tags:
			//		private
			this._setIcon(icon, "uncheckIcon");
		},

		_setRightIcon2Attr: function(/*String*/icon){
			// tags:
			//		private
			this._setIcon(icon, "rightIcon2");
		},

		_setCheckedAttr: function(/*Boolean*/checked){
			// tags:
			//		private
			if(!this._isOnLine){
				// record the value to be able to reapply it (see the code in the startup method)
				this._pendingChecked = checked; 
				return; 
			} // icon may be invalid because inheritParams is not called yet
			var parent = this.getParent();
			if(parent && parent.select === "single" && checked){
				array.forEach(parent.getChildren(), function(child){
					child !== this && child.checked && child.set("checked", false) && domAttr.set(child.domNode, "aria-selected", "false");
				}, this);
			}
			this._setRightIconAttr(this.checkClass || "mblDomButtonCheck");
			this._setUncheckIconAttr(this.uncheckClass);

			domClass.toggle(this.domNode, "mblListItemChecked", checked);
			domClass.toggle(this.domNode, "mblListItemUnchecked", !checked);
			domClass.toggle(this.domNode, "mblListItemHasUncheck", !!this.uncheckIconNode);
			this.rightIconNode.style.position = (this.uncheckIconNode && !checked) ? "absolute" : "";

			if(parent && this.checked !== checked){
				parent.onCheckStateChanged(this, checked);
			}
			this._set("checked", checked);
			domAttr.set(this.domNode, "aria-selected", checked ? "true" : "false");
		},

		_setBusyAttr: function(/*Boolean*/busy){
			// tags:
			//		private
			var prog = this._prog;
			if(busy){
				if(!this._progNode){
					this._progNode = domConstruct.create("div", {className:"mblListItemIcon"});
					prog = this._prog = new ProgressIndicator({size:25, center:false, removeOnStop:false});
					domClass.add(prog.domNode, this.progStyle);
					this._progNode.appendChild(prog.domNode);
				}
				if(this.iconNode){
					this.domNode.replaceChild(this._progNode, this.iconNode);
				}else{
					domConstruct.place(this._progNode, this._findRef("icon"), "before");
				}
				prog.start();
			}else if(this._progNode){
				if(this.iconNode){
					this.domNode.replaceChild(this.iconNode, this._progNode);
				}else{
					this.domNode.removeChild(this._progNode);
				}
				prog.stop();
			}
			this._set("busy", busy);
		},

		_setSelectedAttr: function(/*Boolean*/selected){
			// summary:
			//		Makes this widget in the selected or unselected state.
			// tags:
			//		private
			this.inherited(arguments);
			domClass.toggle(this.domNode, this._selClass, selected);
		},
		
		_setClickableAttr: function(/*Boolean*/clickable){
			// tags:
			//		private
			this._set("clickable", clickable);
			this._updateHandles();
		},
		
		_setMoveToAttr: function(/*String*/moveTo){
			// tags:
			//		private
			this._set("moveTo", moveTo);
			this._updateHandles();
		},
		
		_setHrefAttr: function(/*String*/href){
			// tags:
			//		private
			this._set("href", href);
			this._updateHandles();
		},
		
		_setUrlAttr: function(/*String*/url){
			// tags:
			//		private
			this._set("url", url);
			this._updateHandles();
		}
	});
	
	ListItem.ChildWidgetProperties = {
		// summary:
		//		These properties can be specified for the children of a dojox/mobile/ListItem.

		// layout: String
		//		Specifies the position of the ListItem child ("left", "center" or "right").
		layout: "",

		// preventTouch: Boolean
		//		Disables touch events on the ListItem child.
		preventTouch: false
	};
	
	// Since any widget can be specified as a ListItem child, mix ChildWidgetProperties
	// into the base widget class.  (This is a hack, but it's effective.)
	// This is for the benefit of the parser.   Remove for 2.0.  Also, hide from doc viewer.
	lang.extend(WidgetBase, /*===== {} || =====*/ ListItem.ChildWidgetProperties);

	return has("dojo-bidi") ? declare("dojox.mobile.ListItem", [ListItem, BidiListItem]) : ListItem;	
});

},
'dojox/mobile/Pane':function(){
define([
	"dojo/_base/array",
	"dojo/_base/declare",
	"dijit/_Contained",
	"dijit/_WidgetBase"
], function(array, declare, Contained, WidgetBase){

	// module:
	//		dojox/mobile/Pane

	return declare("dojox.mobile.Pane", [WidgetBase, Contained], {
		// summary:
		//		A simple pane widget.
		// description:
		//		Pane is a simple general-purpose pane widget.
		//		It is a widget, but can be regarded as a simple `<div>` element.

		// baseClass: String
		//		The name of the CSS class of this widget.
		baseClass: "mblPane",

		buildRendering: function(){
			this.inherited(arguments);
			if(!this.containerNode){
				// set containerNode so that getChildren() works
				this.containerNode = this.domNode;
			}
		},

		resize: function(){
			// summary:
			//		Calls resize() of each child widget.
			array.forEach(this.getChildren(), function(child){
				if(child.resize){ child.resize(); }
			});
		}
	});
});

},
'dojox/mobile/common':function(){
define([
	"dojo/_base/array",
	"dojo/_base/config",
	"dojo/_base/connect",
	"dojo/_base/lang",
	"dojo/_base/window",
	"dojo/_base/kernel",
	"dojo/dom",
	"dojo/dom-class",
	"dojo/dom-construct",
	"dojo/domReady",
	"dojo/ready",
	"dojo/touch",
	"dijit/registry",
	"./sniff",
	"./uacss" // (no direct references)
], function(array, config, connect, lang, win, kernel, dom, domClass, domConstruct, domReady, ready, touch, registry, has){

	// module:
	//		dojox/mobile/common

	var dm = lang.getObject("dojox.mobile", true);

	// tell dojo/touch to generate synthetic clicks immediately
	// and regardless of preventDefault() calls on touch events
	win.doc.dojoClick = true;
	/// ... but let user disable this by removing dojoClick from the document
	if(has("touch")){
		// Do we need to send synthetic clicks when preventDefault() is called on touch events?
		// This is normally true on anything except Android 4.1+ and IE10+, but users reported
		// exceptions like Galaxy Note 2. So let's use a has("clicks-prevented") flag, and let
		// applications override it through data-dojo-config="has:{'clicks-prevented':true}" if needed.
		has.add("clicks-prevented", !(has("android") >= 4.1 || (has("ie") === 10) || (!has("ie") && has("trident") > 6)));
		if(has("clicks-prevented")){
			dm._sendClick = function(target, e){
				// dojo/touch will send a click if dojoClick is set, so don't do it again.
				for(var node = target; node; node = node.parentNode){
					if(node.dojoClick){
						return;
					}
				}
				var ev = win.doc.createEvent("MouseEvents"); 
				ev.initMouseEvent("click", true, true, win.global, 1, e.screenX, e.screenY, e.clientX, e.clientY); 
				target.dispatchEvent(ev);
			};
		}
	}

	dm.getScreenSize = function(){
		// summary:
		//		Returns the dimensions of the browser window.
		return {
			h: win.global.innerHeight || win.doc.documentElement.clientHeight,
			w: win.global.innerWidth || win.doc.documentElement.clientWidth
		};
	};

	dm.updateOrient = function(){
		// summary:
		//		Updates the orientation specific CSS classes, 'dj_portrait' and
		//		'dj_landscape'.
		var dim = dm.getScreenSize();
		domClass.replace(win.doc.documentElement,
				  dim.h > dim.w ? "dj_portrait" : "dj_landscape",
				  dim.h > dim.w ? "dj_landscape" : "dj_portrait");
	};
	dm.updateOrient();

	dm.tabletSize = 500;
	dm.detectScreenSize = function(/*Boolean?*/force){
		// summary:
		//		Detects the screen size and determines if the screen is like
		//		phone or like tablet. If the result is changed,
		//		it sets either of the following css class to `<html>`:
		//
		//		- 'dj_phone'
		//		- 'dj_tablet'
		//
		//		and it publishes either of the following events:
		//
		//		- '/dojox/mobile/screenSize/phone'
		//		- '/dojox/mobile/screenSize/tablet'

		var dim = dm.getScreenSize();
		var sz = Math.min(dim.w, dim.h);
		var from, to;
		if(sz >= dm.tabletSize && (force || (!this._sz || this._sz < dm.tabletSize))){
			from = "phone";
			to = "tablet";
		}else if(sz < dm.tabletSize && (force || (!this._sz || this._sz >= dm.tabletSize))){
			from = "tablet";
			to = "phone";
		}
		if(to){
			domClass.replace(win.doc.documentElement, "dj_"+to, "dj_"+from);
			connect.publish("/dojox/mobile/screenSize/"+to, [dim]);
		}
		this._sz = sz;
	};
	dm.detectScreenSize();

	// dojox/mobile.hideAddressBarWait: Number
	//		The time in milliseconds to wait before the fail-safe hiding address
	//		bar runs. The value must be larger than 800.
	dm.hideAddressBarWait = typeof(config.mblHideAddressBarWait) === "number" ?
		config.mblHideAddressBarWait : 1500;

	dm.hide_1 = function(){
		// summary:
		//		Internal function to hide the address bar.
		// tags:
		//		private
		scrollTo(0, 1);
		dm._hidingTimer = (dm._hidingTimer == 0) ? 200 : dm._hidingTimer * 2;
		setTimeout(function(){ // wait for a while for "scrollTo" to finish
			if(dm.isAddressBarHidden() || dm._hidingTimer > dm.hideAddressBarWait){
				// Succeeded to hide address bar, or failed but timed out 
				dm.resizeAll();
				dm._hiding = false;
			}else{
				// Failed to hide address bar, so retry after a while
				setTimeout(dm.hide_1, dm._hidingTimer);
			}
		}, 50); //50ms is an experiential value
	};

	dm.hideAddressBar = function(/*Event?*/evt){
		// summary:
		//		Hides the address bar.
		// description:
		//		Tries to hide the address bar a couple of times. The purpose is to do 
		//		it as quick as possible while ensuring the resize is done after the hiding
		//		finishes.
		if(dm.disableHideAddressBar || dm._hiding){ return; }
		dm._hiding = true;
		dm._hidingTimer = has("ios") ? 200 : 0; // Need to wait longer in case of iPhone
		var minH = screen.availHeight;
		if(has('android')){
			minH = outerHeight / devicePixelRatio;
			// On some Android devices such as Galaxy SII, minH might be 0 at this time.
			// In that case, retry again after a while. (200ms is an experiential value)
			if(minH == 0){
				dm._hiding = false;
				setTimeout(function(){ dm.hideAddressBar(); }, 200);
			}
			// On some Android devices such as HTC EVO, "outerHeight/devicePixelRatio"
			// is too short to hide address bar, so make it high enough
			if(minH <= innerHeight){ minH = outerHeight; }
			// On Android 2.2/2.3, hiding address bar fails when "overflow:hidden" style is
			// applied to html/body element, so force "overflow:visible" style
			if(has('android') < 3){
				win.doc.documentElement.style.overflow = win.body().style.overflow = "visible";
			}
		}
		if(win.body().offsetHeight < minH){ // to ensure enough height for scrollTo to work
			win.body().style.minHeight = minH + "px";
			dm._resetMinHeight = true;
		}
		setTimeout(dm.hide_1, dm._hidingTimer);
	};

	dm.isAddressBarHidden = function(){
		return pageYOffset === 1;
	};

	dm.resizeAll = function(/*Event?*/evt, /*Widget?*/root){
		// summary:
		//		Calls the resize() method of all the top level resizable widgets.
		// description:
		//		Finds all widgets that do not have a parent or the parent does not
		//		have the resize() method, and calls resize() for them.
		//		If a widget has a parent that has resize(), calling widget's
		//		resize() is its parent's responsibility.
		// evt:
		//		Native event object
		// root:
		//		If specified, searches the specified widget recursively for top-level
		//		resizable widgets.
		//		root.resize() is always called regardless of whether root is a
		//		top level widget or not.
		//		If omitted, searches the entire page.
		if(dm.disableResizeAll){ return; }
		connect.publish("/dojox/mobile/resizeAll", [evt, root]); // back compat
		connect.publish("/dojox/mobile/beforeResizeAll", [evt, root]);
		if(dm._resetMinHeight){
			win.body().style.minHeight = dm.getScreenSize().h + "px";
		} 
		dm.updateOrient();
		dm.detectScreenSize();
		var isTopLevel = function(w){
			var parent = w.getParent && w.getParent();
			return !!((!parent || !parent.resize) && w.resize);
		};
		var resizeRecursively = function(w){
			array.forEach(w.getChildren(), function(child){
				if(isTopLevel(child)){ child.resize(); }
				resizeRecursively(child);
			});
		};
		if(root){
			if(root.resize){ root.resize(); }
			resizeRecursively(root);
		}else{
			array.forEach(array.filter(registry.toArray(), isTopLevel),
					function(w){ w.resize(); });
		}
		connect.publish("/dojox/mobile/afterResizeAll", [evt, root]);
	};

	dm.openWindow = function(url, target){
		// summary:
		//		Opens a new browser window with the given URL.
		win.global.open(url, target || "_blank");
	};

	dm._detectWindowsTheme = function(){
		// summary:
		//		Detects if the "windows" theme is used,
		//		if it is used, set has("windows-theme") and
		//		add the .windows_theme class on the document.
		
		// Avoid unwanted (un)zoom on some WP8 devices (at least Nokia Lumia 920) 
		if(navigator.userAgent.match(/IEMobile\/10\.0/)){
			domConstruct.create("style", 
				{innerHTML: "@-ms-viewport {width: auto !important}"}, win.doc.head);
		}

		var setWindowsTheme = function(){
			domClass.add(win.doc.documentElement, "windows_theme");
			kernel.experimental("Dojo Mobile Windows theme", "Behavior and appearance of the Windows theme are experimental.");
		};

		// First see if the "windows-theme" feature has already been set explicitly
		// in that case skip aut-detect
		var windows = has("windows-theme");
		if(windows !== undefined){
			if(windows){
				setWindowsTheme();
			}
			return;
		}

		// check css
		var i, j;

		var check = function(href){
			// TODO: find a better regexp to match?
			if(href && href.indexOf("/windows/") !== -1){
				has.add("windows-theme", true);
				setWindowsTheme();
				return true;
			}
			return false;
		};

		// collect @import
		var s = win.doc.styleSheets;
		for(i = 0; i < s.length; i++){
			if(s[i].href){ continue; }
			var r = s[i].cssRules || s[i].imports;
			if(!r){ continue; }
			for(j = 0; j < r.length; j++){
				if(check(r[j].href)){
					return;
				}
			}
		}

		// collect <link>
		var elems = win.doc.getElementsByTagName("link");
		for(i = 0; i < elems.length; i++){
			if(check(elems[i].href)){
				return;
			}
		}
	};

	if(config.mblApplyPageStyles !== false){
		domClass.add(win.doc.documentElement, "mobile");
	}
	if(has('chrome')){
		// dojox/mobile does not load uacss (only _compat does), but we need dj_chrome.
		domClass.add(win.doc.documentElement, "dj_chrome");
	}

	if(win.global._no_dojo_dm){
		// deviceTheme seems to be loaded from a script tag (= non-dojo usage)
		var _dm = win.global._no_dojo_dm;
		for(var i in _dm){
			dm[i] = _dm[i];
		}
		dm.deviceTheme.setDm(dm);
	}

	// flag for Android transition animation flicker workaround
	has.add('mblAndroidWorkaround', 
			config.mblAndroidWorkaround !== false && has('android') < 3, undefined, true);
	has.add('mblAndroid3Workaround', 
			config.mblAndroid3Workaround !== false && has('android') >= 3, undefined, true);

	dm._detectWindowsTheme();

	dm.setSelectable = function(/*Node*/node, /*Boolean*/selectable){
		var nodes, i;
		node = dom.byId(node);
		if (has("ie") <= 9){
			// (IE < 10) Fall back to setting/removing the
			// unselectable attribute on the element and all its children
			// except the input element (see https://bugs.dojotoolkit.org/ticket/13846)
			nodes = node.getElementsByTagName("*");
			i = nodes.length;
			if(selectable){
				node.removeAttribute("unselectable");
				while(i--){
					nodes[i].removeAttribute("unselectable");
				}
			}else{
				node.setAttribute("unselectable", "on");
				while(i--){
					if (nodes[i].tagName !== "INPUT"){
						nodes[i].setAttribute("unselectable", "on");
					}
				}
			}
		}else{
			domClass.toggle(node, "unselectable", !selectable);
		}
	};

	var touchActionProp = has("pointer-events") ? "touchAction" : has("MSPointer") ? "msTouchAction" : null;
	dm._setTouchAction = touchActionProp ? function(/*Node*/node, /*Boolean*/value){
		node.style[touchActionProp] = value;
	} : function(){};

	// Set the background style using dojo/domReady, not dojo/ready, to ensure it is already
	// set at widget initialization time. (#17418) 
	domReady(function(){
		domClass.add(win.body(), "mblBackground");
	});

	ready(function(){
		dm.detectScreenSize(true);
		if(config.mblAndroidWorkaroundButtonStyle !== false && has('android')){
			// workaround for the form button disappearing issue on Android 2.2-4.0
			domConstruct.create("style", {innerHTML:"BUTTON,INPUT[type='button'],INPUT[type='submit'],INPUT[type='reset'],INPUT[type='file']::-webkit-file-upload-button{-webkit-appearance:none;} audio::-webkit-media-controls-play-button,video::-webkit-media-controls-play-button{-webkit-appearance:media-play-button;} video::-webkit-media-controls-fullscreen-button{-webkit-appearance:media-fullscreen-button;}"}, win.doc.head, "first");
		}
		if(has('mblAndroidWorkaround')){
			// add a css class to show view offscreen for android flicker workaround
			domConstruct.create("style", {innerHTML:".mblView.mblAndroidWorkaround{position:absolute;top:-9999px !important;left:-9999px !important;}"}, win.doc.head, "last");
		}

		var f = dm.resizeAll;
		// Address bar hiding
		var isHidingPossible =
			navigator.appVersion.indexOf("Mobile") != -1 && // only mobile browsers
			// #17455: hiding Safari's address bar works in iOS < 7 but this is 
			// no longer possible since iOS 7. Hence, exclude iOS 7 and later: 
			!(has("ios") >= 7);
		// You can disable the hiding of the address bar with the following dojoConfig:
		// var dojoConfig = { mblHideAddressBar: false };
		// If unspecified, the flag defaults to true.
		if((config.mblHideAddressBar !== false && isHidingPossible) ||
			config.mblForceHideAddressBar === true){
			dm.hideAddressBar();
			if(config.mblAlwaysHideAddressBar === true){
				f = dm.hideAddressBar;
			}
		}

		var ios6 = has("ios") >= 6; // Full-screen support for iOS6 or later
		if((has('android') || ios6) && win.global.onorientationchange !== undefined){
			var _f = f;
			var curSize, curClientWidth, curClientHeight;
			if(ios6){
				curClientWidth = win.doc.documentElement.clientWidth;
				curClientHeight = win.doc.documentElement.clientHeight;
			}else{ // Android
				// Call resize for the first resize event after orientationchange
				// because the size information may not yet be up to date when the 
				// event orientationchange occurs.
				f = function(evt){
					var _conn = connect.connect(null, "onresize", null, function(e){
						connect.disconnect(_conn);
						_f(e);
					});
				};
				curSize = dm.getScreenSize();
			};
			// Android: Watch for resize events when the virtual keyboard is shown/hidden.
			// The heuristic to detect this is that the screen width does not change
			// and the height changes by more than 100 pixels.
			//
			// iOS >= 6: Watch for resize events when entering or existing the new iOS6 
			// full-screen mode. The heuristic to detect this is that clientWidth does not
			// change while the clientHeight does change.
			connect.connect(null, "onresize", null, function(e){
				if(ios6){
					var newClientWidth = win.doc.documentElement.clientWidth,
						newClientHeight = win.doc.documentElement.clientHeight;
					if(newClientWidth == curClientWidth && newClientHeight != curClientHeight){
						// full-screen mode has been entered/exited (iOS6)
						_f(e);
					}
					curClientWidth = newClientWidth;
					curClientHeight = newClientHeight;
				}else{ // Android
					var newSize = dm.getScreenSize();
					if(newSize.w == curSize.w && Math.abs(newSize.h - curSize.h) >= 100){
						// keyboard has been shown/hidden (Android)
						_f(e);
					}
					curSize = newSize;
				}
			});
		}
		
		connect.connect(null, win.global.onorientationchange !== undefined
			? "onorientationchange" : "onresize", null, f);
		win.body().style.visibility = "visible";
	});

	// TODO: return functions declared above in this hash, rather than
	// dojox.mobile.

	/*=====
	return {
		// summary:
		//		A common module for dojox/mobile.
		// description:
		//		This module includes common utility functions that are used by
		//		dojox/mobile widgets. Also, it provides functions that are commonly
		//		necessary for mobile web applications, such as the hide address bar
		//		function.
	};
	=====*/
	return dm;
});

},
'dojox/mobile/iconUtils':function(){
define([
	"dojo/_base/array",
	"dojo/_base/config",
	"dojo/_base/connect",
	"dojo/_base/event",
	"dojo/_base/lang",
	"dojo/_base/window",
	"dojo/dom-class",
	"dojo/dom-construct",
	"dojo/dom-style",
	"./sniff"
], function(array, config, connect, event, lang, win, domClass, domConstruct, domStyle, has){

	var dm = lang.getObject("dojox.mobile", true);

	// module:
	//		dojox/mobile/iconUtils

	var IconUtils = function(){
		// summary:
		//		Utilities to create an icon (image, CSS sprite image, or DOM Button).

		this.setupSpriteIcon = function(/*DomNode*/iconNode, /*String*/iconPos){
			// summary:
			//		Sets up CSS sprite for a foreground image.
			if(iconNode && iconPos){
				var arr = array.map(iconPos.split(/[ ,]/),function(item){return item-0});
				var t = arr[0]; // top
				var r = arr[1] + arr[2]; // right
				var b = arr[0] + arr[3]; // bottom
				var l = arr[1]; // left
				domStyle.set(iconNode, {
					position: "absolute",
					clip: "rect("+t+"px "+r+"px "+b+"px "+l+"px)",
					top: (iconNode.parentNode ? domStyle.get(iconNode, "top") : 0) - t + "px",
					left: -l + "px"
				});
				domClass.add(iconNode, "mblSpriteIcon");
			}
		};

		this.createDomButton = function(/*DomNode*/refNode, /*Object?*/style, /*DomNode?*/toNode){
			// summary:
			//		Creates a DOM button.
			// description:
			//		DOM button is a simple graphical object that consists of one or
			//		more nested DIV elements with some CSS styling. It can be used
			//		in place of an icon image on ListItem, IconItem, and so on.
			//		The kind of DOM button to create is given as a class name of
			//		refNode. The number of DIVs to create is searched from the style
			//		sheets in the page. However, if the class name has a suffix that
			//		starts with an underscore, like mblDomButtonGoldStar_5, then the
			//		suffixed number is used instead. A class name for DOM button
			//		must starts with 'mblDomButton'.
			// refNode:
			//		A node that has a DOM button class name.
			// style:
			//		A hash object to set styles to the node.
			// toNode:
			//		A root node to create a DOM button. If omitted, refNode is used.

			if(!this._domButtons){
				if(has("webkit")){
					var findDomButtons = function(sheet, dic){
						// summary:
						//		Searches the style sheets for DOM buttons.
						// description:
						//		Returns a key-value pair object whose keys are DOM
						//		button class names and values are the number of DOM
						//		elements they need.
						var i, j;
						if(!sheet){
							var _dic = {};
							var ss = win.doc.styleSheets;
							for (i = 0; i < ss.length; i++){
								ss[i] && findDomButtons(ss[i], _dic);
							}
							return _dic;
						}
						var rules = sheet.cssRules || [];
						for (i = 0; i < rules.length; i++){
							var rule = rules[i];
							if(rule.href && rule.styleSheet){
								findDomButtons(rule.styleSheet, dic);
							}else if(rule.selectorText){
								var sels = rule.selectorText.split(/,/);
								for (j = 0; j < sels.length; j++){
									var sel = sels[j];
									var n = sel.split(/>/).length - 1;
									if(sel.match(/(mblDomButton\w+)/)){
										var cls = RegExp.$1;
										if(!dic[cls] || n > dic[cls]){
											dic[cls] = n;
										}
									}
								}
							}
						}
						return dic;
					};
					this._domButtons = findDomButtons();
				}else{
					this._domButtons = {};
				}
			}

			var s = refNode.className;
			var node = toNode || refNode;
			if(s.match(/(mblDomButton\w+)/) && s.indexOf("/") === -1){
				var btnClass = RegExp.$1;
				var nDiv = 4;
				if(s.match(/(mblDomButton\w+_(\d+))/)){
					nDiv = RegExp.$2 - 0;
				}else if(this._domButtons[btnClass] !== undefined){
					nDiv = this._domButtons[btnClass];
				}
				var props = null;
				if(has("bb") && config.mblBBBoxShadowWorkaround !== false){
					// Removes box-shadow because BlackBerry incorrectly renders it.
					props = {style:"-webkit-box-shadow:none"};
				}
				for(var i = 0, p = node; i < nDiv; i++){
					p = p.firstChild || domConstruct.create("div", props, p);
				}
				if(toNode){
					setTimeout(function(){
						domClass.remove(refNode, btnClass);
					}, 0);
					domClass.add(toNode, btnClass);
				}
			}else if(s.indexOf(".") !== -1){ // file name
				domConstruct.create("img", {src:s}, node);
			}else{
				return null;
			}
			domClass.add(node, "mblDomButton");
			!!style && domStyle.set(node, style);
			return node;
		};

		this.createIcon = function(/*String*/icon, /*String?*/iconPos, /*DomNode?*/node, /*String?*/title, /*DomNode?*/parent, /*DomNode?*/refNode, /*String?*/pos){
			// summary:
			//		Creates or updates an icon node
			// description:
			//		If node exists, updates the existing node. Otherwise, creates a new one.
			// icon:
			//		Path for an image, or DOM button class name.
			title = title || "";
			if(icon && icon.indexOf("mblDomButton") === 0){
				// DOM button
				if(!node){
					node = domConstruct.create("div", null, refNode || parent, pos);
				}else{
					if(node.className.match(/(mblDomButton\w+)/)){
						domClass.remove(node, RegExp.$1);
					}
				}
				node.title = title;
				domClass.add(node, icon);
				this.createDomButton(node);
			}else if(icon && icon !== "none"){
				// Image
				if(!node || node.nodeName !== "IMG"){
					node = domConstruct.create("img", {
						alt: title
					}, refNode || parent, pos);
				}
				node.src = (icon || "").replace("${theme}", dm.currentTheme);
				this.setupSpriteIcon(node, iconPos);
				if(iconPos && parent){
					var arr = iconPos.split(/[ ,]/);
					domStyle.set(parent, {
						position: "relative",
						width: arr[2] + "px",
						height: arr[3] + "px"
					});
					domClass.add(parent, "mblSpriteIconParent");
				}
				connect.connect(node, "ondragstart", event, "stop");
			}
			return node;
		};

		this.iconWrapper = false;
		this.setIcon = function(/*String*/icon, /*String*/iconPos, /*DomNode*/iconNode, /*String?*/alt, /*DomNode*/parent, /*DomNode?*/refNode, /*String?*/pos){
			// summary:
			//		A setter function to set an icon.
			// description:
			//		This function is intended to be used by icon setters (e.g. _setIconAttr)
			// icon:
			//		An icon path or a DOM button class name.
			// iconPos:
			//		The position of an aggregated icon. IconPos is comma separated
			//		values like top,left,width,height (ex. "0,0,29,29").
			// iconNode:
			//		An icon node.
			// alt:
			//		An alt text for the icon image.
			// parent:
			//		Parent node of the icon.
			// refNode:
			//		A node reference to place the icon.
			// pos:
			//		The position of the icon relative to refNode.
			if(!parent || !icon && !iconNode){ return null; }
			if(icon && icon !== "none"){ // create or update an icon
				if(!this.iconWrapper && icon.indexOf("mblDomButton") !== 0 && !iconPos){ // image
					if(iconNode && iconNode.tagName === "DIV"){
						domConstruct.destroy(iconNode);
						iconNode = null;
					}
					iconNode = this.createIcon(icon, null, iconNode, alt, parent, refNode, pos);
					domClass.add(iconNode, "mblImageIcon");
				}else{ // sprite or DOM button
					if(iconNode && iconNode.tagName === "IMG"){
						domConstruct.destroy(iconNode);
						iconNode = null;
					}
					iconNode && domConstruct.empty(iconNode);
					if(!iconNode){
						iconNode = domConstruct.create("div", null, refNode || parent, pos);
					}
					this.createIcon(icon, iconPos, null, null, iconNode);
					if(alt){
						iconNode.title = alt;
					}
				}
				domClass.remove(parent, "mblNoIcon");
				return iconNode;
			}else{ // clear the icon
				domConstruct.destroy(iconNode);
				domClass.add(parent, "mblNoIcon");
				return null;
			}
		};
	};

	// Return singleton.  (TODO: can we replace IconUtils class and singleton w/a simple hash of functions?)
	return new IconUtils();
});

},
'dojox/mobile/SwapView':function(){
define([
	"dojo/_base/array",
	"dojo/_base/connect",
	"dojo/_base/declare",
	"dojo/dom",
	"dojo/dom-class",
	"dijit/registry",
	"./View",
	"./_ScrollableMixin",
	"./sniff",
	"./_css3",
	"dojo/has!dojo-bidi?dojox/mobile/bidi/SwapView"
], function(array, connect, declare, dom, domClass, registry, View, ScrollableMixin, has, css3, BidiSwapView){

	// module:
	//		dojox/mobile/SwapView

	var SwapView = declare(has("dojo-bidi") ? "dojox.mobile.NonBidiSwapView" : "dojox.mobile.SwapView", [View, ScrollableMixin], {
		// summary:
		//		A container that can be swiped horizontally.
		// description:
		//		SwapView is a container widget which can be swiped horizontally. 
		//		SwapView is a subclass of dojox/mobile/View. It allows the user to 
		//		swipe the screen left or right to move between the views. When 
		//		SwapView is swiped, it finds an adjacent SwapView to open. When 
		//		the transition is done, a topic "/dojox/mobile/viewChanged" is 
		//		published. Note that, to behave properly, the SwapView needs to 
		//		occupy the entire width of the screen.

		/* internal properties */	
		// scrollDir: [private] String
		//		Scroll direction, used by dojox/mobile/scrollable (always "f" for this class).
		scrollDir: "f",
		// weight: [private] Number
		//		Frictional weight used to compute scrolling speed.
		weight: 1.2,

		// _endOfTransitionTimeoutHandle: [private] Object
		//		The handle (returned by _WidgetBase.defer) for the timeout set on touchEnd in case
		//      the end of transition event is not fired by the browser.
		_endOfTransitionTimeoutHandle: null,

		buildRendering: function(){
			this.inherited(arguments);
			domClass.add(this.domNode, "mblSwapView");
			this.setSelectable(this.domNode, false);
			this.containerNode = this.domNode;
			this.subscribe("/dojox/mobile/nextPage", "handleNextPage");
			this.subscribe("/dojox/mobile/prevPage", "handlePrevPage");
			this.noResize = true; // not to call resize() from scrollable#init
		},

		startup: function(){
			if(this._started){ return; }
			this.inherited(arguments);
		},

		resize: function(){
			// summary:
			//		Calls resize() of each child widget.
			this.inherited(arguments); // scrollable#resize() will be called
			array.forEach(this.getChildren(), function(child){
				if(child.resize){ child.resize(); }
			});
		},

		onTouchStart: function(/*Event*/e){
			// summary:
			//		Internal function to handle touchStart events.
			if(this._siblingViewsInMotion()){  // Ignore touchstart if the views are already in motion
				this.propagatable ? e.preventDefault() : event.stop(e);
				return;
			}
			var fromTop = this.domNode.offsetTop;
			var nextView = this.nextView(this.domNode);
			if(nextView){
				nextView.stopAnimation();
				domClass.add(nextView.domNode, "mblIn");
				// Temporarily add padding to align with the fromNode while transition
				nextView.containerNode.style.paddingTop = fromTop + "px";
			}
			var prevView = this.previousView(this.domNode);
			if(prevView){
				prevView.stopAnimation();
				domClass.add(prevView.domNode, "mblIn");
				// Temporarily add padding to align with the fromNode while transition
				prevView.containerNode.style.paddingTop = fromTop + "px";
			}
			this._setSiblingViewsInMotion(true);
			this.inherited(arguments);
		},

		onTouchEnd: function(/*Event*/e){
			if(e){
				if(!this._moved){ // No transition / animation following touchend in this case
					this._setSiblingViewsInMotion(false);
				}else{ // There might be a transition / animation following touchend
					// As the webkitTransitionEndEvent is not always fired, make sure we call this._setSiblingViewsInMotion(false) even
					// if the event is not fired (and onFlickAnimationEnd is not called as a result)
					this._endOfTransitionTimeoutHandle = this.defer(function(){
						this._setSiblingViewsInMotion(false);
					}, 1000);
				}
			}
			this.inherited(arguments);
		},

		handleNextPage: function(/*Widget*/w){
			// summary:
			//		Called when the "/dojox/mobile/nextPage" topic is published.
			var refNode = w.refId && dom.byId(w.refId) || w.domNode;
			if(this.domNode.parentNode !== refNode.parentNode){ return; }
			if(this.getShowingView() !== this){ return; }
			this.goTo(1);
		},

		handlePrevPage: function(/*Widget*/w){
			// summary:
			//		Called when the "/dojox/mobile/prevPage" topic is published.
			var refNode = w.refId && dom.byId(w.refId) || w.domNode;
			if(this.domNode.parentNode !== refNode.parentNode){ return; }
			if(this.getShowingView() !== this){ return; }
			this.goTo(-1);
		},

		goTo: function(/*Number*/dir, /*String?*/moveTo){
			// summary:
			//		Moves to the next or previous view.
			var view = moveTo ? registry.byId(moveTo) :
				((dir == 1) ? this.nextView(this.domNode) : this.previousView(this.domNode));
			if(view && view !== this){
				this.stopAnimation(); // clean-up animation states
				view.stopAnimation();
				this.domNode._isShowing = false; // update isShowing flag
				view.domNode._isShowing = true;
				this.performTransition(view.id, dir, "slide", null, function(){
					connect.publish("/dojox/mobile/viewChanged", [view]);
				});
			}
		},

		isSwapView: function(/*DomNode*/node){
			// summary:
			//		Returns true if the given node is a SwapView widget.
			return (node && node.nodeType === 1 && domClass.contains(node, "mblSwapView"));
		},

		nextView: function(/*DomNode*/node){
			// summary:
			//		Returns the next view.
			for(var n = node.nextSibling; n; n = n.nextSibling){
				if(this.isSwapView(n)){ return registry.byNode(n); }
			}
			return null;
		},

		previousView: function(/*DomNode*/node){
			// summary:
			//		Returns the previous view.
			for(var n = node.previousSibling; n; n = n.previousSibling){
				if(this.isSwapView(n)){ return registry.byNode(n); }
			}
			return null;
		},

		scrollTo: function(/*Object*/to){
			// summary:
			//		Overrides dojox/mobile/scrollable.scrollTo().
			if(!this._beingFlipped){
				var newView, x;
				if(to.x){
					if(to.x < 0){
						newView = this.nextView(this.domNode);
						x = to.x + this.domNode.offsetWidth;
					}else{
						newView = this.previousView(this.domNode);
						x = to.x - this.domNode.offsetWidth;
					}
				}
				if(newView){
					if(newView.domNode.style.display === "none"){
						newView.domNode.style.display = "";
						newView.resize();
					}
					newView._beingFlipped = true;
					newView.scrollTo({x:x});
					newView._beingFlipped = false;
				}
			}
			this.inherited(arguments);
		},

		findDisp: function(/*DomNode*/node){
			// summary:
			//		Overrides dojox/mobile/scrollable.findDisp().
			// description:
			//		When this function is called from scrollable.js, there are
			//		two visible views, one is the current view, the other is the
			//		next view. This function returns the current view, not the
			//		next view, which has the mblIn class.
			if(!domClass.contains(node, "mblSwapView")){
				return this.inherited(arguments);
			}
			if(!node.parentNode){ return null; }
			var nodes = node.parentNode.childNodes;
			for(var i = 0; i < nodes.length; i++){
				var n = nodes[i];
				if(n.nodeType === 1 && domClass.contains(n, "mblSwapView")
				    && !domClass.contains(n, "mblIn") && n.style.display !== "none"){
					return n;
				}
			}
			return node;
		},

		slideTo: function(/*Object*/to, /*Number*/duration, /*String*/easing, /*Object?*/fake_pos){
			// summary:
			//		Overrides dojox/mobile/scrollable.slideTo().
			if(!this._beingFlipped){
				var w = this.domNode.offsetWidth;
				var pos = fake_pos || this.getPos();
				var newView, newX;
				if(pos.x < 0){ // moving to left
					newView = this.nextView(this.domNode);
					if(pos.x < -w/4){ // slide to next
						if(newView){
							to.x = -w;
							newX = 0;
						}
					}else{ // go back
						if(newView){
							newX = w;
						}
					}
				}else{ // moving to right
					newView = this.previousView(this.domNode);
					if(pos.x > w/4){ // slide to previous
						if(newView){
							to.x = w;
							newX = 0;
						}
					}else{ // go back
						if(newView){
							newX = -w;
						}
					}
				}

				if(newView){
					newView._beingFlipped = true;
					newView.slideTo({x:newX}, duration, easing);
					newView._beingFlipped = false;
					newView.domNode._isShowing = (newView && newX === 0);
				}
				this.domNode._isShowing = !(newView && newX === 0);
			}
			this.inherited(arguments);
		},

		onAnimationEnd: function(/*Event*/e){
			// summary:
			//		Overrides dojox/mobile/View.onAnimationEnd().
			if(e && e.target && domClass.contains(e.target, "mblScrollableScrollTo2")){ return; }
			this.inherited(arguments);
		},

		onFlickAnimationEnd: function(/*Event*/e){
			if(this._endOfTransitionTimeoutHandle){
				this._endOfTransitionTimeoutHandle = this._endOfTransitionTimeoutHandle.remove();
			}
			// summary:
			//		Overrides dojox/mobile/scrollable.onFlickAnimationEnd().
			if(e && e.target && !domClass.contains(e.target, "mblScrollableScrollTo2")){ return; }
			this.inherited(arguments);

			if(this.domNode._isShowing){
				// Hide all the views other than the currently showing one.
				// Otherwise, when the orientation is changed, other views
				// may appear unexpectedly.
				array.forEach(this.domNode.parentNode.childNodes, function(c){
					if(this.isSwapView(c)){
						domClass.remove(c, "mblIn");
						if(!c._isShowing){
							c.style.display = "none";
							c.style[css3.name("transform")] = "";
							c.style.left = "0px"; // top/left mode needs this
							// reset the temporaty padding on the container node
							c.style.paddingTop = "";
						}
					}
				}, this);
				connect.publish("/dojox/mobile/viewChanged", [this]);
				// Reset the temporary padding
				this.containerNode.style.paddingTop = "";
			}else if(!has("css3-animations")){
				this.containerNode.style.left = "0px"; // compat mode needs this
			}
			this._setSiblingViewsInMotion(false);
		},

		_setSiblingViewsInMotion: function(/*Boolean*/inMotion){
			var inMotionAttributeValue = inMotion ? "true" : false;
			var parent = this.domNode.parentNode;
			if(parent){
				parent.setAttribute("data-dojox-mobile-swapview-inmotion", inMotionAttributeValue);
			}
		},

		_siblingViewsInMotion: function(){
			var parent = this.domNode.parentNode;
			if(parent){
				return parent.getAttribute("data-dojox-mobile-swapview-inmotion") == "true";
			}else{
				return false;
			}
		}
	});
	return has("dojo-bidi") ? declare("dojox.mobile.SwapView", [SwapView, BidiSwapView]) : SwapView;
});

},
'dojox/mobile/uacss':function(){
define([
	"dojo/_base/kernel",
	"dojo/_base/lang",
	"dojo/_base/window",
	"./sniff"
], function(dojo, lang, win, has){
	var html = win.doc.documentElement;
	html.className = lang.trim(html.className + " " + [
		has('bb') ? "dj_bb" : "",
		has('android') ? "dj_android" : "",
		has("ios") ? "dj_ios" : "",
		has("ios") >= 6 ? "dj_ios6" : "",
		has("ios") ? "dj_iphone" : "",	// TODO: remove for 2.0
		has('ipod') ? "dj_ipod" : "",
		has('ipad') ? "dj_ipad" : "",
		has('ie') ? "dj_ie": ""
	].join(" ").replace(/ +/g," "));
	
	/*=====
	return {
		// summary:
		//		Requiring this module adds CSS classes to your document's `<html`> tag:
		//
		//		- "dj_android" when running on Android;
		//		- "dj_bb" when running on BlackBerry;
		//		- "dj_ios" when running on iOS (iPhone, iPad or iPod);
		//		- "dj_ios6" when running on iOS6+; this class is intended for the iphone theme to detect if it must use the iOS 6 variant of the theme. Currently applies on iOS 6 or later.
		//		- "dj_iphone" when running on iPhone, iPad or iPod (Note: will be changed in future versions to be set only on iPhone);
		//		- "dj_ipod" when running on iPod;
		//		- "dj_ipad" when running on iPad.
	};
	=====*/
	return dojo;
});

},
'dojox/mobile/RoundRectCategory':function(){
define([
	"dojo/_base/declare",
	"dojo/_base/window",
	"dojo/dom-construct",
	"dijit/_Contained",
	"dijit/_WidgetBase",
	"dojo/has",
	"dojo/has!dojo-bidi?dojox/mobile/bidi/RoundRectCategory"
], function(declare, win, domConstruct, Contained, WidgetBase, has, BidiRoundRectCategory){

	// module:
	//		dojox/mobile/RoundRectCategory

	var RoundRectCategory = declare(has("dojo-bidi") ? "dojox.mobile.NonBidiRoundRectCategory" : "dojox.mobile.RoundRectCategory", [WidgetBase, Contained], {
		// summary:
		//		A category header for a rounded rectangle list.

		// label: String
		//		A label of the category. If the label is not specified,
		//		innerHTML is used as a label.
		label: "",

		// tag: String
		//		A name of html tag to create as domNode.
		tag: "h2",

		/* internal properties */	
		
		// baseClass: String
		//		The name of the CSS class of this widget.
		baseClass: "mblRoundRectCategory",

		buildRendering: function(){
			var domNode = this.domNode = this.containerNode = this.srcNodeRef || domConstruct.create(this.tag);
			this.inherited(arguments);
			if(!this.label && domNode.childNodes.length === 1 && domNode.firstChild.nodeType === 3){
				// if it has only one text node, regard it as a label
				this.label = domNode.firstChild.nodeValue;
			}
		},

		_setLabelAttr: function(/*String*/label){
			// summary:
			//		Sets the category header text.
			// tags:
			//		private
			this.label = label;
			this.domNode.innerHTML = this._cv ? this._cv(label) : label;
		}
	});

	return has("dojo-bidi") ? declare("dojox.mobile.RoundRectCategory", [RoundRectCategory, BidiRoundRectCategory]) : RoundRectCategory;	
});

},
'dojox/mobile/ProgressIndicator':function(){
define([
	"dojo/_base/config",
	"dojo/_base/declare",
	"dojo/_base/lang",
	"dojo/dom-class",
	"dojo/dom-construct",
	"dojo/dom-geometry",
	"dojo/dom-style",
	"dojo/has",
	"dijit/_Contained",
	"dijit/_WidgetBase",
	"./_css3",
	"dojo/has!dojo-bidi?dojox/mobile/bidi/ProgressIndicator"
], function(config, declare, lang, domClass, domConstruct, domGeometry, domStyle, has, Contained, WidgetBase, css3, BidiProgressIndicator){

	// module:
	//		dojox/mobile/ProgressIndicator

	var cls = declare("dojox.mobile.ProgressIndicator", [WidgetBase, Contained], {
		// summary:
		//		A progress indication widget.
		// description:
		//		ProgressIndicator is a round spinning graphical representation
		//		that indicates the current task is ongoing.

		// interval: Number
		//		The time interval in milliseconds for updating the spinning
		//		indicator.
		interval: 100,

		// size: [const] Number
		//		The size of the indicator in pixels.
		//		Note that changing the value of the property after the widget
		//		creation has no effect.
		size: 40,

		// removeOnStop: Boolean
		//		If true, this widget is removed from the parent node
		//		when stop() is called.
		removeOnStop: true,

		// startSpinning: Boolean
		//		If true, calls start() to run the indicator at startup.
		startSpinning: false,

		// center: Boolean
		//		If true, the indicator is displayed as center aligned.
		center: true,

		// colors: String[]
		//		An array of indicator colors. 12 colors have to be given.
		//		If colors are not specified, CSS styles
		//		(mblProg0Color - mblProg11Color) are used.
		colors: null,

		/* internal properties */
		
		// baseClass: String
		//		The name of the CSS class of this widget.	
		baseClass: "mblProgressIndicator",

		constructor: function(){
			// summary:
			//		Creates a new instance of the class.
			this.colors = [];
			this._bars = [];
		},

		buildRendering: function(){
			this.inherited(arguments);
			if(this.center){
				domClass.add(this.domNode, "mblProgressIndicatorCenter");
			}
			this.containerNode = domConstruct.create("div", {className:"mblProgContainer"}, this.domNode);
			this.spinnerNode = domConstruct.create("div", null, this.containerNode);
			for(var i = 0; i < 12; i++){
				var div = domConstruct.create("div", {className:"mblProg mblProg"+i}, this.spinnerNode);
				this._bars.push(div);
			}
			this.scale(this.size);
			if(this.startSpinning){
				this.start();
			}
		},

		scale: function(/*Number*/size){
			// summary:
			//		Changes the size of the indicator.
			// size:
			//		The size of the indicator in pixels.
			var scale = size / 40;
			domStyle.set(this.containerNode, css3.add({}, {
				transform: "scale(" + scale + ")",
				transformOrigin: "0 0"
			}));
			domGeometry.setMarginBox(this.domNode, {w:size, h:size});
			domGeometry.setMarginBox(this.containerNode, {w:size / scale, h:size / scale});
		},

		start: function(){
			// summary:
			//		Starts the spinning of the ProgressIndicator.
			if(this.imageNode){
				var img = this.imageNode;
				var l = Math.round((this.containerNode.offsetWidth - img.offsetWidth) / 2);
				var t = Math.round((this.containerNode.offsetHeight - img.offsetHeight) / 2);
				img.style.margin = t+"px "+l+"px";
				return;
			}
			var cntr = 0;
			var _this = this;
			var n = 12;
			this.timer = setInterval(function(){
				cntr--;
				cntr = cntr < 0 ? n - 1 : cntr;
				var c = _this.colors;
				for(var i = 0; i < n; i++){
					var idx = (cntr + i) % n;
					if(c[idx]){
						_this._bars[i].style.backgroundColor = c[idx];
					}else{
						domClass.replace(_this._bars[i],
										 "mblProg" + idx + "Color",
										 "mblProg" + (idx === n - 1 ? 0 : idx + 1) + "Color");
					}
				}
			}, this.interval);
		},

		stop: function(){
			// summary:
			//		Stops the spinning of the ProgressIndicator.
			if(this.timer){
				clearInterval(this.timer);
			}
			this.timer = null;
			if(this.removeOnStop && this.domNode && this.domNode.parentNode){
				this.domNode.parentNode.removeChild(this.domNode);
			}
		},

		setImage: function(/*String*/file){
			// summary:
			//		Sets an indicator icon image file (typically animated GIF).
			//		If null is specified, restores the default spinner.
			if(file){
				this.imageNode = domConstruct.create("img", {src:file}, this.containerNode);
				this.spinnerNode.style.display = "none";
			}else{
				if(this.imageNode){
					this.containerNode.removeChild(this.imageNode);
					this.imageNode = null;
				}
				this.spinnerNode.style.display = "";
			}
		},

		destroy: function(){
			this.inherited(arguments);
			if(this === cls._instance){
				cls._instance = null;
			}
		}
	});
	cls = has("dojo-bidi") ? declare("dojox.mobile.ProgressIndicator", [cls, BidiProgressIndicator]) : cls;
	cls._instance = null;
	cls.getInstance = function(props){
		if(!cls._instance){
			cls._instance = new cls(props);
		}
		return cls._instance;
	};

	return cls;
});

},
'dojox/mobile/EdgeToEdgeList':function(){
define([
	"dojo/_base/declare",
	"./RoundRectList"
], function(declare, RoundRectList){

	// module:
	//		dojox/mobile/EdgeToEdgeCategory

	return declare("dojox.mobile.EdgeToEdgeList", RoundRectList, {
		// summary:
		//		An edge-to-edge layout list.
		// description:
		//		EdgeToEdgeList is an edge-to-edge layout list, which displays
		//		all items in equally-sized rows. Each item must be a
		//		dojox/mobile/ListItem.
		
		// filterBoxClass: String
		//		The name of the CSS class added to the DOM node inside which is placed the 
		//		dojox/mobile/SearchBox created when mixing dojox/mobile/FilteredListMixin.
		//		The default value is "mblFilteredEdgeToEdgeListSearchBox". 
		filterBoxClass: "mblFilteredEdgeToEdgeListSearchBox",

		buildRendering: function(){
			this.inherited(arguments);
			this.domNode.className = "mblEdgeToEdgeList";
		}
	});
});

},
'dojox/mobile/EdgeToEdgeCategory':function(){
define([
	"dojo/_base/declare",
	"./RoundRectCategory"
], function(declare, RoundRectCategory){

	// module:
	//		dojox/mobile/EdgeToEdgeCategory

	return declare("dojox.mobile.EdgeToEdgeCategory", RoundRectCategory, {
		// summary:
		//		A category header for an edge-to-edge list.
		buildRendering: function(){
			this.inherited(arguments);
			this.domNode.className = "mblEdgeToEdgeCategory";

			if(this.type && this.type == "long"){
				this.domNode.className += " mblEdgeToEdgeCategoryLong";
			}
		}
	});
});

},
'dojox/mobile/Container':function(){
define([
	"dojo/_base/declare",
	"dijit/_Container",
	"./Pane"
], function(declare, Container, Pane){

	// module:
	//		dojox/mobile/Container

	return declare("dojox.mobile.Container", [Pane, Container], {
		// summary:
		//		A simple container-type widget.
		// description:
		//		Container is a simple general-purpose container widget.
		//		It is a widget, but can be regarded as a simple `<div>` element.

		// baseClass: String
		//		The name of the CSS class of this widget.
		baseClass: "mblContainer"
	});
});

},
'dojox/mobile/ToolBarButton':function(){
define([
	"dojo/_base/declare",
	"dojo/_base/lang",
	"dojo/_base/window",
	"dojo/dom-class",
	"dojo/dom-construct",
	"dojo/dom-style",
	"dojo/dom-attr",
	"./sniff",
	"./_ItemBase",
	"dojo/has!dojo-bidi?dojox/mobile/bidi/ToolBarButton"
], function(declare, lang, win, domClass, domConstruct, domStyle, domAttr, has, ItemBase, BidiToolBarButton){

	// module:
	//		dojox/mobile/ToolBarButton

	var ToolBarButton = declare(has("dojo-bidi") ? "dojox.mobile.NonBidiToolBarButton" : "dojox.mobile.ToolBarButton", ItemBase, {
		// summary:
		//		A button widget which is placed in the Heading widget.
		// description:
		//		ToolBarButton is a button which is typically placed in the
		//		Heading widget. It is a subclass of dojox/mobile/_ItemBase just
		//		like ListItem or IconItem. So, unlike Button, it has basically
		//		the same capability as ListItem or IconItem, such as icon
		//		support, transition, etc.

		// selected: Boolean
		//		If true, the button is in the selected state.
		selected: false,

		// arrow: [const] String
		//		Specifies "right" or "left" to be an arrow button.
		//		Note that changing the value of the property after the widget 
		//		creation has no effect.
		arrow: "",

		// light: [const] Boolean
		//		If true, this widget produces only a single `<span>` node when it
		//		has only an icon or only a label, and has no arrow. In that
		//		case, you cannot have both icon and label, or arrow even if you
		//		try to set them.
		//		Note that changing the value of the property after the widget 
		//		creation has no effect.
		light: true,

		// defaultColor: String
		//		CSS class for the default color.
		//		Note: If this button has an arrow (typically back buttons on iOS),
		//		the class selector used for it is the value of defaultColor + "45".
		//		For example, by default the arrow selector is "mblColorDefault45".
		defaultColor: "mblColorDefault",

		// selColor: String
		//		CSS class for the selected color.
		//		Note: If this button has an arrow (typically back buttons on iOS),
		//		the class selector used for it is the value of selColor + "45".
		//		For example, by default the selected arrow selector is "mblColorDefaultSel45".
		selColor: "mblColorDefaultSel",

		/* internal properties */
		baseClass: "mblToolBarButton",

		_selStartMethod: "touch",
		_selEndMethod: "touch",

		buildRendering: function(){
			if(!this.label && this.srcNodeRef){
				this.label = this.srcNodeRef.innerHTML;
			}
			this.label = lang.trim(this.label);
			this.domNode = (this.srcNodeRef && this.srcNodeRef.tagName === "SPAN") ?
				this.srcNodeRef : domConstruct.create("span");
			domAttr.set(this.domNode, "role", "button");
			this.inherited(arguments);

			if(this.light && !this.arrow && (!this.icon || !this.label)){
				this.labelNode = this.tableNode = this.bodyNode = this.iconParentNode = this.domNode;
				domClass.add(this.domNode, this.defaultColor + " mblToolBarButtonBody" +
							 (this.icon ? " mblToolBarButtonLightIcon" : " mblToolBarButtonLightText"));
				return;
			}

			this.domNode.innerHTML = "";
			if(this.arrow === "left" || this.arrow === "right"){
				this.arrowNode = domConstruct.create("span", {
					className: "mblToolBarButtonArrow mblToolBarButton" +
					(this.arrow === "left" ? "Left" : "Right") + "Arrow " +
					(has("ie") < 10 ? "" : (this.defaultColor + " " + this.defaultColor + "45"))
				}, this.domNode);
				domClass.add(this.domNode, "mblToolBarButtonHas" +
					(this.arrow === "left" ? "Left" : "Right") + "Arrow");
			}
			this.bodyNode = domConstruct.create("span", {className:"mblToolBarButtonBody"}, this.domNode);
			this.tableNode = domConstruct.create("table", {cellPadding:"0",cellSpacing:"0",border:"0",role:"presentation"}, this.bodyNode);
			if(!this.label && this.arrow){
				// The class mblToolBarButtonText is needed for arrow shape too.
				// If the button has a label, the class is set by _setLabelAttr. If no label, do it here.
				this.tableNode.className = "mblToolBarButtonText";
			}

			var row = this.tableNode.insertRow(-1);
			this.iconParentNode = row.insertCell(-1);
			this.labelNode = row.insertCell(-1);
			this.iconParentNode.className = "mblToolBarButtonIcon";
			this.labelNode.className = "mblToolBarButtonLabel";

			if(this.icon && this.icon !== "none" && this.label){
				domClass.add(this.domNode, "mblToolBarButtonHasIcon");
				domClass.add(this.bodyNode, "mblToolBarButtonLabeledIcon");
			}

			domClass.add(this.bodyNode, this.defaultColor);
		},

		startup: function(){
			if(this._started){ return; }

			this.connect(this.domNode, "onkeydown", "_onClick"); // for desktop browsers

			this.inherited(arguments);
			if(!this._isOnLine){
				this._isOnLine = true;
				// retry applying the attribute for which the custom setter delays the actual 
				// work until _isOnLine is true. 
				this.set("icon", this._pendingIcon !== undefined ? this._pendingIcon : this.icon);
				// Not needed anymore (this code executes only once per life cycle):
				delete this._pendingIcon; 
			}
		},

		_onClick: function(e){
			// summary:
			//		Internal handler for click events.
			// tags:
			//		private
			if(e && e.type === "keydown" && e.keyCode !== 13){ return; }
			if(this.onClick(e) === false){ return; } // user's click action
			this.defaultClickAction(e);
		},

		onClick: function(/*Event*/ /*===== e =====*/){
			// summary:
			//		User defined function to handle clicks
			// tags:
			//		callback
		},

		_setLabelAttr: function(/*String*/text){
			// summary:
			//		Sets the button label text.
			this.inherited(arguments);
			domClass.toggle(this.tableNode, "mblToolBarButtonText", text || this.arrow); // also needed if only arrow
		},

		_setSelectedAttr: function(/*Boolean*/selected){
			// summary:
			//		Makes this widget in the selected or unselected state.
			var replace = function(node, a, b){
				domClass.replace(node, a + " " + a + "45", b + " " + b + "45");
			};
			this.inherited(arguments);
			if(selected){
				domClass.replace(this.bodyNode, this.selColor, this.defaultColor);
				if(!(has("ie") < 10) && this.arrowNode){
					replace(this.arrowNode, this.selColor, this.defaultColor);
				}
			}else{
				domClass.replace(this.bodyNode, this.defaultColor, this.selColor);
				if(!(has("ie") < 10) && this.arrowNode){
					replace(this.arrowNode, this.defaultColor, this.selColor);
				}
			}
			domClass.toggle(this.domNode, "mblToolBarButtonSelected", selected);
			domClass.toggle(this.bodyNode, "mblToolBarButtonBodySelected", selected);
		}
	});
	return has("dojo-bidi") ? declare("dojox.mobile.ToolBarButton", [ToolBarButton, BidiToolBarButton]) : ToolBarButton;
});

},
'dojox/mobile/_ItemBase':function(){
define([
	"dojo/_base/array",
	"dojo/_base/declare",
	"dojo/_base/lang",
	"dojo/_base/window",
	"dojo/dom-class",
	"dojo/touch",
	"dijit/registry",
	"dijit/_Contained",
	"dijit/_Container",
	"dijit/_WidgetBase",
	"./TransitionEvent",
	"./iconUtils",
	"./sniff",
	"./viewRegistry",
	"dojo/has!dojo-bidi?dojox/mobile/bidi/_ItemBase"
], function(array, declare, lang, win, domClass, touch, registry, Contained, Container, 
	WidgetBase, TransitionEvent, iconUtils, has, viewRegistry, BidiItemBase){

	// module:
	//		dojox/mobile/_ItemBase

	var _ItemBase = declare(has("dojo-bidi") ? "dojox.mobile._NonBidiItemBase" : "dojox.mobile._ItemBase", [WidgetBase, Container, Contained], {
		// summary:
		//		A base class for item classes (e.g. ListItem, IconItem, etc.).
		// description:
		//		_ItemBase is a base class for widgets that have capability to
		//		make a view transition when clicked.

		// icon: String
		//		An icon image to display. The value can be either a path for an
		//		image file or a class name of a DOM button. If icon is not
		//		specified, the iconBase parameter of the parent widget is used.
		icon: "",

		// iconPos: String
		//		The position of an aggregated icon. IconPos is comma separated
		//		values like top,left,width,height (ex. "0,0,29,29"). If iconPos
		//		is not specified, the iconPos parameter of the parent widget is
		//		used.
		iconPos: "", // top,left,width,height (ex. "0,0,29,29")

		// alt: String
		//		An alternate text for the icon image.
		alt: "",

		// href: String
		//		A URL of another web page to go to.
		href: "",

		// hrefTarget: String
		//		A target that specifies where to open a page specified by
		//		href. The value will be passed to the 2nd argument of
		//		window.open().
		hrefTarget: "",

		// moveTo: String
		//		The id of the transition destination view which resides in the
		//		current page.
		//
		//		If the value has a hash sign ('#') before the id (e.g. #view1)
		//		and the dojo/hash module is loaded by the user application, the
		//		view transition updates the hash in the browser URL so that the
		//		user can bookmark the destination view. In this case, the user
		//		can also use the browser's back/forward button to navigate
		//		through the views in the browser history.
		//
		//		If null, transitions to a blank view.
		//		If '#', returns immediately without transition.
		moveTo: "",

		// scene: String
		//		The name of a scene. Used from dojox/mobile/app.
		scene: "",

		// clickable: Boolean
		//		If true, this item becomes clickable even if a transition
		//		destination (moveTo, etc.) is not specified.
		clickable: false,

		// url: String
		//		A URL of an html fragment page or JSON data that represents a
		//		new view content. The view content is loaded with XHR and
		//		inserted in the current page. Then a view transition occurs to
		//		the newly created view. The view is cached so that subsequent
		//		requests would not load the content again.
		url: "",

		// urlTarget: String
		//		Node id under which a new view will be created according to the
		//		url parameter. If not specified, The new view will be created as
		//		a sibling of the current view.
		urlTarget: "",

		// back: Boolean
		//		If true, history.back() is called when clicked.
		back: false,

		// transition: String
		//		A type of animated transition effect. You can choose from the
		//		standard transition types, "slide", "fade", "flip", or from the
		//		extended transition types, "cover", "coverv", "dissolve",
		//		"reveal", "revealv", "scaleIn", "scaleOut", "slidev",
		//		"swirl", "zoomIn", "zoomOut", "cube", and "swap". If "none" is
		//		specified, transition occurs immediately without animation.
		transition: "",

		// transitionDir: Number
		//		The transition direction. If 1, transition forward. If -1,
		//		transition backward. For example, the slide transition slides
		//		the view from right to left when dir == 1, and from left to
		//		right when dir == -1.
		transitionDir: 1,

		// transitionOptions: Object
		//		A hash object that holds transition options.
		transitionOptions: null,

		// callback: Function|String
		//		A callback function that is called when the transition has been
		//		finished. A function reference, or name of a function in
		//		context.
		callback: null,

		// label: String
		//		A label of the item. If the label is not specified, innerHTML is
		//		used as a label.
		label: "",

		// toggle: Boolean
		//		If true, the item acts like a toggle button.
		toggle: false,

		// selected: Boolean
		//		If true, the item is highlighted to indicate it is selected.
		selected: false,

		// tabIndex: String
		//		Tabindex setting for the item so users can hit the tab key to
		//		focus on it.
		tabIndex: "0",
		
		// _setTabIndexAttr: [private] String
		//		Sets tabIndex to domNode.
		_setTabIndexAttr: "",

		/* internal properties */	

		// paramsToInherit: String
		//		Comma separated parameters to inherit from the parent.
		paramsToInherit: "transition,icon",

		// _selStartMethod: String
		//		Specifies how the item enters the selected state.
		//
		//		- "touch": Use touch events to enter the selected state.
		//		- "none": Do not change the selected state.
		_selStartMethod: "none", // touch or none

		// _selEndMethod: String
		//		Specifies how the item leaves the selected state.
		//
		//		- "touch": Use touch events to leave the selected state.
		//		- "timer": Use setTimeout to leave the selected state.
		//		- "none": Do not change the selected state.
		_selEndMethod: "none", // touch, timer, or none

		// _delayedSelection: Boolean
		//		If true, selection is delayed 100ms and canceled if dragged in
		//		order to avoid selection when flick operation is performed.
		_delayedSelection: false,

		// _duration: Number
		//		Duration of selection, milliseconds.
		_duration: 800,

		// _handleClick: Boolean
		//		If true, this widget listens to touch events.
		_handleClick: true,

		buildRendering: function(){
			this.inherited(arguments);
			this._isOnLine = this.inheritParams();
		},

		startup: function(){
			if(this._started){ return; }
			if(!this._isOnLine){
				this.inheritParams();
			}
			this._updateHandles();
			this.inherited(arguments);
		},

		inheritParams: function(){
			// summary:
			//		Copies from the parent the values of parameters specified 
			//		by the property paramsToInherit.
			var parent = this.getParent();
			if(parent){
				array.forEach(this.paramsToInherit.split(/,/), function(p){
					if(p.match(/icon/i)){
						var base = p + "Base", pos = p + "Pos";
						if(this[p] && parent[base] &&
							parent[base].charAt(parent[base].length - 1) === '/'){
							this[p] = parent[base] + this[p];
						}
						if(!this[p]){ this[p] = parent[base]; }
						if(!this[pos]){ this[pos] = parent[pos]; }
					}
					if(!this[p]){ this[p] = parent[p]; }
				}, this);
			}
			return !!parent;
		},

		_updateHandles: function(){
			// tags:
			//		private
			if(this._handleClick && this._selStartMethod === "touch"){
				if(!this._onTouchStartHandle){
					this._onTouchStartHandle = this.connect(this.domNode, touch.press, "_onTouchStart");
				}
			}else{
				if(this._onTouchStartHandle){
					this.disconnect(this._onTouchStartHandle);
					this._onTouchStartHandle = null;
				}
			}
		},
		
		getTransOpts: function(){
			// summary:
			//		Copies from the parent and returns the values of parameters  
			//		specified by the property paramsToInherit.
			var opts = this.transitionOptions || {};
			array.forEach(["moveTo", "href", "hrefTarget", "url", "target",
				"urlTarget", "scene", "transition", "transitionDir"], function(p){
				opts[p] = opts[p] || this[p];
			}, this);
			return opts; // Object
		},

		userClickAction: function(/*Event*/ /*===== e =====*/){
			// summary:
			//		User-defined click action.
		},

		defaultClickAction: function(/*Event*/e){
			// summary:
			//		The default action of this item.
			this.handleSelection(e);
			if(this.userClickAction(e) === false){ return; } // user's click action
			this.makeTransition(e);
		},

		handleSelection: function(/*Event*/e){
			// summary:
			//		Handles this items selection state.

			// Before transitioning, we want the visual effect of selecting the item.
			// To ensure this effect happens even if _delayedSelection is true:
			if(this._delayedSelection){
				this.set("selected", true);
			} // the item will be deselected after transition.

			if(this._onTouchEndHandle){
				this.disconnect(this._onTouchEndHandle);
				this._onTouchEndHandle = null;
			}

			var p = this.getParent();
			if(this.toggle){
				this.set("selected", !this._currentSel);
			}else if(p && p.selectOne){
				this.set("selected", true);
			}else{
				if(this._selEndMethod === "touch"){
					this.set("selected", false);
				}else if(this._selEndMethod === "timer"){
					this.defer(function(){
						this.set("selected", false);
					}, this._duration);
				}
			}
		},

		makeTransition: function(/*Event*/e){
			// summary:
			//		Makes a transition.
			if(this.back && history){
				history.back();	
				return;
			}	
			if (this.href && this.hrefTarget && this.hrefTarget != "_self") {
				win.global.open(this.href, this.hrefTarget || "_blank");
				this._onNewWindowOpened(e);
				return;
			}
			var opts = this.getTransOpts();
			var doTransition = 
				!!(opts.moveTo || opts.href || opts.url || opts.target || opts.scene);
			if(this._prepareForTransition(e, doTransition ? opts : null) === false){ return; }
			if(doTransition){
				this.setTransitionPos(e);
				new TransitionEvent(this.domNode, opts, e).dispatch();
			}
		},

		_onNewWindowOpened: function(/*Event*/ /*===== e =====*/){
			// summary:
			//		Subclasses may want to implement it.
		},

		_prepareForTransition: function(/*Event*/e, /*Object*/transOpts){
			// summary:
			//		Subclasses may want to implement it.
		},

		_onTouchStart: function(e){
			// tags:
			//		private
			if(this.getParent().isEditing || this.onTouchStart(e) === false){ return; } // user's touchStart action
			var enclosingScrollable = viewRegistry.getEnclosingScrollable(this.domNode);
			if(enclosingScrollable &&
				domClass.contains(enclosingScrollable.containerNode, "mblScrollableScrollTo2")){
				// #17165: do not select the item during scroll animation
				return;
			}
			if(!this._onTouchEndHandle && this._selStartMethod === "touch"){
				// Connect to the entire window. Otherwise, fail to receive
				// events if operation is performed outside this widget.
				// Expose both connect handlers in case the user has interest.
				this._onTouchMoveHandle = this.connect(win.body(), touch.move, "_onTouchMove");
				this._onTouchEndHandle = this.connect(win.body(), touch.release, "_onTouchEnd");
			}
			this.touchStartX = e.touches ? e.touches[0].pageX : e.clientX;
			this.touchStartY = e.touches ? e.touches[0].pageY : e.clientY;
			this._currentSel = this.selected;

			if(this._delayedSelection){
				// so as not to make selection when the user flicks on ScrollableView
				this._selTimer = this.defer(function(){
					this.set("selected", true);
				}, 100);
			}else{
				this.set("selected", true);
			}
		},

		onTouchStart: function(/*Event*/ /*===== e =====*/){
			// summary:
			//		User-defined function to handle touchStart events.
			// tags:
			//		callback
		},

		_onTouchMove: function(e){
			// tags:
			//		private
			var x = e.touches ? e.touches[0].pageX : e.clientX;
			var y = e.touches ? e.touches[0].pageY : e.clientY;
			if(Math.abs(x - this.touchStartX) >= 4 ||
			   Math.abs(y - this.touchStartY) >= 4){ // dojox/mobile/scrollable.threshold
				this.cancel();
				var p = this.getParent();
				if(p && p.selectOne){
					this._prevSel && this._prevSel.set("selected", true);
				}else{
					this.set("selected", false);
				}
			}
		},

		_disconnect: function(){
			// tags:
			//		private
			this.disconnect(this._onTouchMoveHandle);
			this.disconnect(this._onTouchEndHandle);
			this._onTouchMoveHandle = this._onTouchEndHandle = null;
		},

		cancel: function(){
			// summary:
			//		Cancels an ongoing selection (if any).
			if(this._selTimer){
				this._selTimer.remove(); 
				this._selTimer = null;
			}
			this._disconnect();
		},

		_onTouchEnd: function(e){
			// tags:
			//		private
			if(!this._selTimer && this._delayedSelection){ return; }
			this.cancel();
			this._onClick(e);
		},

		setTransitionPos: function(e){
			// summary:
			//		Stores the clicked position for later use.
			// description:
			//		Some of the transition animations (e.g. ScaleIn) need the
			//		clicked position.
			var w = this;
			while(true){
				w = w.getParent();
				if(!w || domClass.contains(w.domNode, "mblView")){ break; }
			}
			if(w){
				w.clickedPosX = e.clientX;
				w.clickedPosY = e.clientY;
			}
		},

		transitionTo: function(/*String|Object*/moveTo, /*String*/href, /*String*/url, /*String*/scene){
			// summary:
			//		Performs a view transition.
			// description:
			//		Given a transition destination, this method performs a view
			//		transition. This method is typically called when this item
			//		is clicked.
			var opts = (moveTo && typeof(moveTo) === "object") ? moveTo :
				{moveTo: moveTo, href: href, url: url, scene: scene,
				 transition: this.transition, transitionDir: this.transitionDir};
			new TransitionEvent(this.domNode, opts).dispatch();
		},

		_setIconAttr: function(icon){
			// tags:
			//		private
			if(!this._isOnLine){
				// record the value to be able to reapply it (see the code in the startup method)
				this._pendingIcon = icon;  
				return; 
			} // icon may be invalid because inheritParams is not called yet
			this._set("icon", icon);
			this.iconNode = iconUtils.setIcon(icon, this.iconPos, this.iconNode, this.alt, this.iconParentNode, this.refNode, this.position);
		},

		_setLabelAttr: function(/*String*/text){
			// tags:
			//		private
			this._set("label", text);
			this.labelNode.innerHTML = this._cv ? this._cv(text) : text;
		},

		_setSelectedAttr: function(/*Boolean*/selected){
			// summary:
			//		Makes this widget in the selected or unselected state.
			// description:
			//		Subclass should override.
			// tags:
			//		private
			if(selected){
				var p = this.getParent();
				if(p && p.selectOne){
					// deselect the currently selected item
					var arr = array.filter(p.getChildren(), function(w){
						return w.selected;
					});
					array.forEach(arr, function(c){
						this._prevSel = c;
						c.set("selected", false);
					}, this);
				}
			}
			this._set("selected", selected);
		}
	});
	return has("dojo-bidi") ? declare("dojox.mobile._ItemBase", [_ItemBase, BidiItemBase]) : _ItemBase;
});

},
'dojox/mobile/ScrollableView':function(){
define([
	"dojo/_base/array",
	"dojo/_base/declare",
	"dojo/dom-class",
	"dojo/dom-construct",
	"dijit/registry",	// registry.byNode
	"./View",
	"./_ScrollableMixin"
], function(array, declare, domClass, domConstruct, registry, View, ScrollableMixin){

	// module:
	//		dojox/mobile/ScrollableView

	return declare("dojox.mobile.ScrollableView", [View, ScrollableMixin], {
		// summary:
		//		A container that has a touch scrolling capability.
		// description:
		//		ScrollableView is a subclass of View (dojox/mobile/View).
		//		Unlike the base View class, ScrollableView's domNode always stays
		//		at the top of the screen and its height is "100%" of the screen.
		//		Inside this fixed domNode, the containerNode scrolls. The browser's
		//		default scrolling behavior is disabled, and the scrolling mechanism is
		//		reimplemented in JavaScript. Thus the user does not need to use the
		//		two-finger operation to scroll the inner DIV (containerNode).
		//		The main purpose of this widget is to realize fixed-positioned header
		//		and/or footer bars.

		// scrollableParams: Object
		//		Parameters for dojox/mobile/scrollable.init().
		scrollableParams: null,

		// keepScrollPos: Boolean
		//		Overrides dojox/mobile/View/keepScrollPos.
		keepScrollPos: false,

		constructor: function(){
			// summary:
			//		Creates a new instance of the class.
			this.scrollableParams = {noResize: true};
		},

		buildRendering: function(){
			this.inherited(arguments);
			domClass.add(this.domNode, "mblScrollableView");
			this.domNode.style.overflow = "hidden";
			this.domNode.style.top = "0px";
			this.containerNode = domConstruct.create("div",
				{className:"mblScrollableViewContainer"}, this.domNode);
			this.containerNode.style.position = "absolute";
			this.containerNode.style.top = "0px"; // view bar is relative
			if(this.scrollDir === "v"){
				this.containerNode.style.width = "100%";
			}
		},

		startup: function(){
			if(this._started){ return; }
			// user can initialize the app footers using a value for fixedFooter (we keep this value for non regression of existing apps)
			if(this.fixedFooter && !this.isLocalFooter){
				this._fixedAppFooter = this.fixedFooter;
				this.fixedFooter = "";
			}
			this.reparent();
			this.inherited(arguments);
		},

		resize: function(){
			// summary:
			//		Calls resize() of each child widget.
			this.inherited(arguments); // scrollable#resize() will be called
			array.forEach(this.getChildren(), function(child){
				if(child.resize){ child.resize(); }
			});
			this._dim = this.getDim(); // update dimension cache
			if(this._conn){
				// if a resize happens during a scroll, update the scrollbar
				this.resetScrollBar();
			}
		},

		isTopLevel: function(/*Event*/e){
			// summary:
			//		Returns true if this is a top-level widget.
			//		Overrides dojox/mobile/scrollable.isTopLevel.
			var parent = this.getParent && this.getParent();
			return (!parent || !parent.resize); // top level widget
		},

		addFixedBar: function(/*Widget*/widget){
			// summary:
			//		Adds a view local fixed bar to this widget.
			// description:
			//		This method can be used to programmatically add a view local
			//		fixed bar to ScrollableView. The bar is appended to this
			//		widget's domNode. The addChild API cannot be used for this
			//		purpose, because it adds the given widget to containerNode.
			var c = widget.domNode;
			var fixed = this.checkFixedBar(c, true);
			if(!fixed){ return; }
			// Fixed bar has to be added to domNode, not containerNode.
			this.domNode.appendChild(c);
			if(fixed === "top"){
				this.fixedHeaderHeight = c.offsetHeight;
				this.isLocalHeader = true;
			}else if(fixed === "bottom"){
				this.fixedFooterHeight = c.offsetHeight;
				this.isLocalFooter = true;
				c.style.bottom = "0px";
			}
			this.resize();
		},

		reparent: function(){
			// summary:
			//		Moves all the children, except header and footer, to
			//		containerNode.
			var i, idx, len, c;
			for(i = 0, idx = 0, len = this.domNode.childNodes.length; i < len; i++){
				c = this.domNode.childNodes[idx];
				// search for view-specific header or footer
				if(c === this.containerNode || this.checkFixedBar(c, true)){
					idx++;
					continue;
				}
				this.containerNode.appendChild(this.domNode.removeChild(c));
			}
		},

		onAfterTransitionIn: function(moveTo, dir, transition, context, method){
			// summary:
			//		Overrides View.onAfterTransitionIn to flash the scroll bar
			//		after performing a view transition.
			this.flashScrollBar();
		},

		getChildren: function(){
			// summary:
			//		Overrides _WidgetBase.getChildren to add local fixed bars,
			//		which are not under containerNode, to the children array.
			var children = this.inherited(arguments);
			var fixedWidget;
			if(this.fixedHeader && this.fixedHeader.parentNode === this.domNode){
				fixedWidget = registry.byNode(this.fixedHeader);
				if(fixedWidget){
					children.push(fixedWidget);
				}
			}
			if(this.fixedFooter && this.fixedFooter.parentNode === this.domNode){
				fixedWidget = registry.byNode(this.fixedFooter);
				if(fixedWidget){
					children.push(fixedWidget);
				}
			}
			return children;
		},

		_addTransitionPaddingTop: function(/*String|Integer*/ value){
			// add padding top to the view in order to get alignment during the transition
			this.domNode.style.paddingTop = value + "px";
			this.containerNode.style.paddingTop = value + "px";
		},

		_removeTransitionPaddingTop: function(){
			// remove padding top from the view after the transition
			this.domNode.style.paddingTop = "";
			this.containerNode.style.paddingTop = "";
		}

	});
});

},
'dijit/_Contained':function(){
define([
	"dojo/_base/declare", // declare
	"./registry"	// registry.getEnclosingWidget(), registry.byNode()
], function(declare, registry){

	// module:
	//		dijit/_Contained

	return declare("dijit._Contained", null, {
		// summary:
		//		Mixin for widgets that are children of a container widget
		// example:
		//	|	// make a basic custom widget that knows about its parents
		//	|	declare("my.customClass",[dijit._WidgetBase, dijit._Contained],{});

		_getSibling: function(/*String*/ which){
			// summary:
			//		Returns next or previous sibling
			// which:
			//		Either "next" or "previous"
			// tags:
			//		private
			var p = this.getParent();
			return (p && p._getSiblingOfChild && p._getSiblingOfChild(this, which == "previous" ? -1 : 1)) || null;	// dijit/_WidgetBase
		},

		getPreviousSibling: function(){
			// summary:
			//		Returns null if this is the first child of the parent,
			//		otherwise returns the next element sibling to the "left".

			return this._getSibling("previous"); // dijit/_WidgetBase
		},

		getNextSibling: function(){
			// summary:
			//		Returns null if this is the last child of the parent,
			//		otherwise returns the next element sibling to the "right".

			return this._getSibling("next"); // dijit/_WidgetBase
		},

		getIndexInParent: function(){
			// summary:
			//		Returns the index of this widget within its container parent.
			//		It returns -1 if the parent does not exist, or if the parent
			//		is not a dijit/_Container

			var p = this.getParent();
			if(!p || !p.getIndexOfChild){
				return -1; // int
			}
			return p.getIndexOfChild(this); // int
		}
	});
});

},
'dojox/mobile/scrollable':function(){
define([
	"dojo/_base/kernel",
	"dojo/_base/connect",
	"dojo/_base/event",
	"dojo/_base/lang",
	"dojo/_base/window",
	"dojo/dom-class",
	"dojo/dom-construct",
	"dojo/dom-style",
	"dojo/dom-geometry",
	"dojo/touch",
	"dijit/registry",
	"dijit/form/_TextBoxMixin",
	"./sniff",
	"./_css3",
	"./_maskUtils",
	"./common",
	"dojo/_base/declare",
	"dojo/has!dojo-bidi?dojox/mobile/bidi/Scrollable"
], function(dojo, connect, event, lang, win, domClass, domConstruct, domStyle,
			 domGeom, touch, registry, TextBoxMixin, has, css3, maskUtils, common, declare, BidiScrollable){

	// module:
	//		dojox/mobile/scrollable

	// TODO: rename to Scrollable.js (capital S) for 2.0

	// TODO: shouldn't be referencing this dojox/mobile variable, would be better to require the mobile.js module
	var dm = lang.getObject("dojox.mobile", true);

	// feature detection
	has.add("translate3d", function(){
		if(has("css3-animations")){
			var elem = win.doc.createElement("div");
			elem.style[css3.name("transform")] = "translate3d(0px,1px,0px)";
			win.doc.documentElement.appendChild(elem);
			var v = win.doc.defaultView.getComputedStyle(elem, '')[css3.name("transform", true)];
			var hasTranslate3d = v && v.indexOf("matrix") === 0;
			win.doc.documentElement.removeChild(elem);
			return hasTranslate3d;
		}
	});

	var Scrollable = function(){
		// summary:
		//		Mixin for enabling touch scrolling capability.
		// description:
		//		Mixin for enabling touch scrolling capability.
		//		Mobile WebKit browsers do not allow scrolling inner DIVs. (For instance,
		//		on iOS you need the two-finger operation to scroll them.)
		//		That means you cannot have fixed-positioned header/footer bars.
		//		To solve this issue, this module disables the browsers default scrolling
		//		behavior, and rebuilds its own scrolling machinery by handling touch
		//		events. In this module, this.domNode has height "100%" and is fixed to
		//		the window, and this.containerNode scrolls. If you place a bar outside
		//		of this.containerNode, then it will be fixed-positioned while
		//		this.containerNode is scrollable.
		//
		//		This module has the following features:
		//
		//		- Scrolls inner DIVs vertically, horizontally, or both.
		//		- Vertical and horizontal scroll bars.
		//		- Flashes the scroll bars when a view is shown.
		//		- Simulates the flick operation using animation.
		//		- Respects header/footer bars if any.
	};

	lang.extend(Scrollable, {
		// fixedHeaderHeight: Number
		//		height of a fixed header
		fixedHeaderHeight: 0,

		// fixedFooterHeight: Number
		//		height of a fixed footer
		fixedFooterHeight: 0,

		// isLocalFooter: Boolean
		//		footer is view-local (as opposed to application-wide)
		isLocalFooter: false,

		// scrollBar: Boolean
		//		show scroll bar or not
		scrollBar: true,

		// scrollDir: String
		//		v: vertical, h: horizontal, vh: both, f: flip
		scrollDir: "v",

		// weight: Number
		//		frictional drag
		weight: 0.6,

		// fadeScrollBar: Boolean
		fadeScrollBar: true,

		// disableFlashScrollBar: Boolean
		disableFlashScrollBar: false,

		// threshold: Number
		//		drag threshold value in pixels
		threshold: 4,

		// constraint: Boolean
		//		bounce back to the content area
		constraint: true,

		// touchNode: DOMNode
		//		a node that will have touch event handlers
		touchNode: null,

		// propagatable: Boolean
		//		let touchstart event propagate up
		propagatable: true,

		// dirLock: Boolean
		//		disable the move handler if scroll starts in the unexpected direction
		dirLock: false,

		// height: String
		//		explicitly specified height of this widget (ex. "300px")
		height: "",

		// scrollType: Number
		//		- 1: use (-webkit-)transform:translate3d(x,y,z) style, use (-webkit-)animation for slide animation
		//		- 2: use top/left style,
		//		- 3: use (-webkit-)transform:translate3d(x,y,z) style, use (-webkit-)transition for slide animation
		//		- 0: use default value (3 for Android, iOS6+, and BlackBerry; otherwise 1)
		scrollType: 0,
		
		// _parentPadBorderExtentsBottom: [private] Number
		//		For Tooltip.js.
		_parentPadBorderExtentsBottom: 0,

		// _moved: [private] Boolean
		//		Flag that signals if the user have moved in (one of) the scroll
		//		direction(s) since touch start (a move under the threshold is ignored).
		_moved: false,

		init: function(/*Object?*/params){
			// summary:
			//		Initialize according to the given params.
			// description:
			//		Mixes in the given params into this instance. At least domNode
			//		and containerNode have to be given.
			//		Starts listening to the touchstart events.
			//		Calls resize(), if this widget is a top level widget.
			if(params){
				for(var p in params){
					if(params.hasOwnProperty(p)){
						this[p] = ((p == "domNode" || p == "containerNode") && typeof params[p] == "string") ?
							win.doc.getElementById(params[p]) : params[p]; // mix-in params
					}
				}
			}
			// prevent browser scrolling on IE10 (evt.preventDefault() is not enough)
			common._setTouchAction(this.domNode, "none");
			this.touchNode = this.touchNode || this.containerNode;
			this._v = (this.scrollDir.indexOf("v") != -1); // vertical scrolling
			this._h = (this.scrollDir.indexOf("h") != -1); // horizontal scrolling
			this._f = (this.scrollDir == "f"); // flipping views

			this._ch = []; // connect handlers
			this._ch.push(connect.connect(this.touchNode, touch.press, this, "onTouchStart"));
			if(has("css3-animations")){
				// flag for whether to use -webkit-transform:translate3d(x,y,z) or top/left style.
				// top/left style works fine as a workaround for input fields auto-scrolling issue,
				// so use top/left in case of Android by default.
				this._useTopLeft = this.scrollType ? this.scrollType === 2 : false;
				// Flag for using webkit transition on transform, instead of animation + keyframes.
				// (keyframes create a slight delay before the slide animation...)
				if(!this._useTopLeft){
					this._useTransformTransition = 
						this.scrollType ? this.scrollType === 3 : has("ios") >= 6 || has("android") || has("bb");
				}
				if(!this._useTopLeft){
					if(this._useTransformTransition){
						this._ch.push(connect.connect(this.containerNode, css3.name("transitionEnd"), this, "onFlickAnimationEnd"));
						// Note that there is no transitionstart event (#17822).
					}else{
						this._ch.push(connect.connect(this.containerNode, css3.name("animationEnd"), this, "onFlickAnimationEnd"));
						this._ch.push(connect.connect(this.containerNode, css3.name("animationStart"), this, "onFlickAnimationStart"));
	
						// Creation of keyframes takes a little time. If they are created
						// in a lazy manner, a slight delay is noticeable when you start
						// scrolling for the first time. This is to create keyframes up front.
						for(var i = 0; i < 3; i++){
							this.setKeyframes(null, null, i);
						}
					}
					if(has("translate3d")){ // workaround for flicker issue on iPhone and Android 3.x/4.0
						domStyle.set(this.containerNode, css3.name("transform"), "translate3d(0,0,0)");
					}
				}else{
					this._ch.push(connect.connect(this.containerNode, css3.name("transitionEnd"), this, "onFlickAnimationEnd"));
					// Note that there is no transitionstart event (#17822).
				}
			}

			this._speed = {x:0, y:0};
			this._appFooterHeight = 0;
			if(this.isTopLevel() && !this.noResize){
				this.resize();
			}
			var _this = this;
			setTimeout(function(){ 
				// Why not using widget.defer() instead of setTimeout()? Because this module
				// is not always mixed into a widget (ex. dojox/mobile/_ComboBoxMenu), and adding 
				// a check to call either defer or setTimeout has been considered overkill.
				_this.flashScrollBar();
			}, 600);
			
			// #16363: while navigating among input field using TAB (desktop keyboard) or 
			// NEXT (mobile soft keyboard), domNode.scrollTop gets modified (this holds even 
			// if the text widget has selectOnFocus at false, that is even if dijit's _FormWidgetMixin._onFocus 
			// does not trigger a global scrollIntoView). This messes up ScrollableView's own 
			// scrolling machinery. To avoid this misbehavior:
			if(win.global.addEventListener){ // all supported browsers but IE8
				// (for IE8, using attachEvent is not a solution, because it only works in bubbling phase)
				this._onScroll = function(e){
					if(!_this.domNode || _this.domNode.style.display === 'none'){ return; }
					var scrollTop = _this.domNode.scrollTop;
					var scrollLeft = _this.domNode.scrollLeft; 
					var pos;
					if(scrollTop > 0 || scrollLeft > 0){ 
						pos = _this.getPos(); 
						// Reset to zero while compensating using our own scroll: 
						_this.domNode.scrollLeft = 0; 
						_this.domNode.scrollTop = 0; 
						_this.scrollTo({x: pos.x - scrollLeft, y: pos.y - scrollTop}); // no animation 
					}
				};
				win.global.addEventListener("scroll", this._onScroll, true);
			}
			// #17062: Ensure auto-scroll when navigating focusable fields
			if(!this.disableTouchScroll && this.domNode.addEventListener){
				this._onFocusScroll = function(e){
					if(!_this.domNode || _this.domNode.style.display === 'none'){ return; }
					var node = win.doc.activeElement;
					var nodeRect, scrollableRect;
					if(node){
						nodeRect = node.getBoundingClientRect();
						scrollableRect = _this.domNode.getBoundingClientRect();
						if(nodeRect.height < _this.getDim().d.h){
							// do not call scrollIntoView for elements with a height
							// larger than the height of scrollable's content display
							// area (it would be ergonomically harmful).
							
							if(nodeRect.top < (scrollableRect.top + _this.fixedHeaderHeight)){
								// scrolling towards top (to bring into the visible area an element
								// located above it).
								_this.scrollIntoView(node, true);
							}else if((nodeRect.top + nodeRect.height) > 
								(scrollableRect.top + scrollableRect.height - _this.fixedFooterHeight)){
								// scrolling towards bottom (to bring into the visible area an element
								// located below it).
								_this.scrollIntoView(node, false);
							} // else do nothing (the focused node is already visible)
						}
					}
				};
				this.domNode.addEventListener("focus", this._onFocusScroll, true);
			}
		},

		isTopLevel: function(){
			// summary:
			//		Returns true if this is a top-level widget.
			// description:
			//		Subclass may want to override.
			return true;
		},

		cleanup: function(){
			// summary:
			//		Uninitialize the module.
			if(this._ch){
				for(var i = 0; i < this._ch.length; i++){
					connect.disconnect(this._ch[i]);
				}
				this._ch = null;
			}
			if(this._onScroll && win.global.removeEventListener){ // all supported browsers but IE8
				win.global.removeEventListener("scroll", this._onScroll, true);
				this._onScroll = null;
			}
			
			if(this._onFocusScroll && this.domNode.removeEventListener){
				this.domNode.removeEventListener("focus", this._onFocusScroll, true);
				this._onFocusScroll = null;
			} 
		},

		findDisp: function(/*DomNode*/node){
			// summary:
			//		Finds the currently displayed view node from my sibling nodes.
			if(!node.parentNode){ return null; }

			// the given node is the first candidate
			if(node.nodeType === 1 && domClass.contains(node, "mblSwapView") && node.style.display !== "none"){
				return node;
			}

			var nodes = node.parentNode.childNodes;
			for(var i = 0; i < nodes.length; i++){
				var n = nodes[i];
				if(n.nodeType === 1 && domClass.contains(n, "mblView") && n.style.display !== "none"){
					return n;
				}
			}
			return node;
		},

		getScreenSize: function(){
			// summary:
			//		Returns the dimensions of the browser window.
			return {
				h: win.global.innerHeight||win.doc.documentElement.clientHeight||win.doc.documentElement.offsetHeight,
				w: win.global.innerWidth||win.doc.documentElement.clientWidth||win.doc.documentElement.offsetWidth
			};
		},

		resize: function(e){
			// summary:
			//		Adjusts the height of the widget.
			// description:
			//		If the height property is 'inherit', the height is inherited
			//		from its offset parent. If 'auto', the content height, which
			//		could be smaller than the entire screen height, is used. If an
			//		explicit height value (ex. "300px"), it is used as the new
			//		height. If nothing is specified as the height property, from the
			//		current top position of the widget to the bottom of the screen
			//		will be the new height.

			// moved from init() to support dynamically added fixed bars
			this._appFooterHeight = (this._fixedAppFooter) ? this._fixedAppFooter.offsetHeight : 0;
			if(this.isLocalHeader){
				this.containerNode.style.marginTop = this.fixedHeaderHeight + "px";
			}

			// Get the top position. Same as dojo.position(node, true).y
			var top = 0;
			for(var n = this.domNode; n && n.tagName != "BODY"; n = n.offsetParent){
				n = this.findDisp(n); // find the first displayed view node
				if(!n){ break; }
				top += n.offsetTop + domGeom.getBorderExtents(n).h;
			}

			// adjust the height of this view
			var	h,
				screenHeight = this.getScreenSize().h,
				dh = screenHeight - top - this._appFooterHeight; // default height
			if(this.height === "inherit"){
				if(this.domNode.offsetParent){
					h = domGeom.getContentBox(this.domNode.offsetParent).h - domGeom.getBorderExtents(this.domNode).h + "px";
				}
			}else if(this.height === "auto"){
				var parent = this.domNode.offsetParent;
				if(parent){
					this.domNode.style.height = "0px";
					var	parentRect = parent.getBoundingClientRect(),
						scrollableRect = this.domNode.getBoundingClientRect(),
						contentBottom = parentRect.bottom - this._appFooterHeight - this._parentPadBorderExtentsBottom;
					if(scrollableRect.bottom >= contentBottom){ // use entire screen
						dh = screenHeight - (scrollableRect.top - parentRect.top) - this._appFooterHeight - this._parentPadBorderExtentsBottom;
					}else{ // stretch to fill predefined area
						dh = contentBottom - scrollableRect.bottom;
					}
				}
				// content could be smaller than entire screen height
				var contentHeight = Math.max(this.domNode.scrollHeight, this.containerNode.scrollHeight);
				h = (contentHeight ? Math.min(contentHeight, dh) : dh) + "px";
			}else if(this.height){
				h = this.height;
			}
			if(!h){
				h = dh + "px";
			}
			if(h.charAt(0) !== "-" && // to ensure that h is not negative (e.g. "-10px")
				h !== "default"){
				this.domNode.style.height = h;
			}

			if(!this._conn){
				// to ensure that the view is within a scrolling area when resized.
				this.onTouchEnd();
			}
		},

		onFlickAnimationStart: function(e){
			if(e){
				event.stop(e);
			}
		},

		onFlickAnimationEnd: function(e){
			if(has("ios")){
				this._keepInputCaretInActiveElement();
			}
			if(e){
				var an = e.animationName;
				if(an && an.indexOf("scrollableViewScroll2") === -1){
					if(an.indexOf("scrollableViewScroll0") !== -1){ // scrollBarV
						if(this._scrollBarNodeV){ domClass.remove(this._scrollBarNodeV, "mblScrollableScrollTo0"); }
					}else if(an.indexOf("scrollableViewScroll1") !== -1){ // scrollBarH
						if(this._scrollBarNodeH){ domClass.remove(this._scrollBarNodeH, "mblScrollableScrollTo1"); }
					}else{ // fade or others
						if(this._scrollBarNodeV){ this._scrollBarNodeV.className = ""; }
						if(this._scrollBarNodeH){ this._scrollBarNodeH.className = ""; }
					}
					return;
				}
				if(this._useTransformTransition || this._useTopLeft){
					var n = e.target;
					if(n === this._scrollBarV || n === this._scrollBarH){
						var cls = "mblScrollableScrollTo" + (n === this._scrollBarV ? "0" : "1");
						if(domClass.contains(n, cls)){
							domClass.remove(n, cls);
						}else{
							n.className = "";
						}
						return;
					}
				}
				if(e.srcElement){
					event.stop(e);
				}
			}
			this.stopAnimation();
			if(this._bounce){
				var _this = this;
				var bounce = _this._bounce;
				setTimeout(function(){
					_this.slideTo(bounce, 0.3, "ease-out");
				}, 0);
				_this._bounce = undefined;
			}else{
				this.hideScrollBar();
				this.removeCover();
			}
		},

		isFormElement: function(/*DOMNode*/node){
			// summary:
			//		Returns true if the given node is a form control.
			if(node && node.nodeType !== 1){ node = node.parentNode; }
			if(!node || node.nodeType !== 1){ return false; }
			var t = node.tagName;
			return (t === "SELECT" || t === "INPUT" || t === "TEXTAREA" || t === "BUTTON");
		},

		onTouchStart: function(e){
			// summary:
			//		User-defined function to handle touchStart events.
			if(this.disableTouchScroll){ return; }
			if(this._conn && (new Date()).getTime() - this.startTime < 500){
				return; // ignore successive onTouchStart calls
			}
			if(!this._conn){
				this._conn = [];
				this._conn.push(connect.connect(win.doc, touch.move, this, "onTouchMove"));
				this._conn.push(connect.connect(win.doc, touch.release, this, "onTouchEnd"));
			}

			this._aborted = false;
			if(domClass.contains(this.containerNode, "mblScrollableScrollTo2")){
				this.abort();
			}else{ // reset scrollbar class especially for reseting fade-out animation
				if(this._scrollBarNodeV){ this._scrollBarNodeV.className = ""; }
				if(this._scrollBarNodeH){ this._scrollBarNodeH.className = ""; }
			}
			this.touchStartX = e.touches ? e.touches[0].pageX : e.clientX;
			this.touchStartY = e.touches ? e.touches[0].pageY : e.clientY;
			this.startTime = (new Date()).getTime();
			this.startPos = this.getPos();
			this._dim = this.getDim();
			this._time = [0];
			this._posX = [this.touchStartX];
			this._posY = [this.touchStartY];
			this._locked = false;
			this._moved = false;

			this._preventDefaultInNextTouchMove = true; // #17502
			if(!this.isFormElement(e.target)){
				// Call preventDefault to avoid browser scroll, except for form elements 
				// for which doing it in touch.press would forbid the virtual keyboard 
				// from showing up (for form elements which are text widgets, preventDefault
				// is called in touch.move). 
				this.propagatable ? e.preventDefault() : event.stop(e);
				this._preventDefaultInNextTouchMove = false;
			}
		},

		onTouchMove: function(e){
			// summary:
			//		User-defined function to handle touchMove events.
			if(this._locked){ return; }
			
			if(this._preventDefaultInNextTouchMove){ // #17502
				this._preventDefaultInNextTouchMove = false; // only in the first touch.move
				var enclosingWidget = registry.getEnclosingWidget(
					// On touch-enabled devices, e.target can be different in touch.move than in
					// touch.start. Hence:
					((e.targetTouches && e.targetTouches.length === 1) ? e.targetTouches[0] : e).target);
				if(enclosingWidget && enclosingWidget.isInstanceOf(TextBoxMixin)){
					// For touches on text widgets for which e.preventDefault() has not been
					// called in onTouchStart, call it in onTouchMove() to avoid browser scroll.
					// Not done on other elements such that for instance a native slider
					// can still handle touchmove events.
					this.propagatable ? e.preventDefault() : event.stop(e);
				}
			}
			
			var x = e.touches ? e.touches[0].pageX : e.clientX;
			var y = e.touches ? e.touches[0].pageY : e.clientY;
			var dx = x - this.touchStartX;
			var dy = y - this.touchStartY;
			var to = {x:this.startPos.x + dx, y:this.startPos.y + dy};
			var dim = this._dim;

			dx = Math.abs(dx);
			dy = Math.abs(dy);
			if(this._time.length == 1){ // the first TouchMove after TouchStart
				if(this.dirLock){
					if(this._v && !this._h && dx >= this.threshold && dx >= dy ||
						(this._h || this._f) && !this._v && dy >= this.threshold && dy >= dx){
						this._locked = true;
						return;
					}
				}
				if(this._v && this._h){ // scrollDir="hv"
					if(dy < this.threshold &&
						dx < this.threshold){
						return;
					}
				}else{
					if(this._v && dy < this.threshold ||
						(this._h || this._f) && dx < this.threshold){
						return;
					}
				}
				this._moved = true;
				this.addCover();
				this.showScrollBar();
			}

			var weight = this.weight;
			if(this._v && this.constraint){
				if(to.y > 0){ // content is below the screen area
					to.y = Math.round(to.y * weight);
				}else if(to.y < -dim.o.h){ // content is above the screen area
					if(dim.c.h < dim.d.h){ // content is shorter than display
						to.y = Math.round(to.y * weight);
					}else{
						to.y = -dim.o.h - Math.round((-dim.o.h - to.y) * weight);
					}
				}
			}
			if((this._h || this._f) && this.constraint){
				if(to.x > 0){
					to.x = Math.round(to.x * weight);
				}else if(to.x < -dim.o.w){
					if(dim.c.w < dim.d.w){
						to.x = Math.round(to.x * weight);
					}else{
						to.x = -dim.o.w - Math.round((-dim.o.w - to.x) * weight);
					}
				}
			}
			this.scrollTo(to);

			var max = 10;
			var n = this._time.length; // # of samples
			if(n >= 2){
				this._moved = true;
				// Check the direction of the finger move.
				// If the direction has been changed, discard the old data.
				var d0, d1;
				if(this._v && !this._h){
					d0 = this._posY[n - 1] - this._posY[n - 2];
					d1 = y - this._posY[n - 1];
				}else if(!this._v && this._h){
					d0 = this._posX[n - 1] - this._posX[n - 2];
					d1 = x - this._posX[n - 1];
				}
				if(d0 * d1 < 0){ // direction changed
					// leave only the latest data
					this._time = [this._time[n - 1]];
					this._posX = [this._posX[n - 1]];
					this._posY = [this._posY[n - 1]];
					n = 1;
				}
			}
			if(n == max){
				this._time.shift();
				this._posX.shift();
				this._posY.shift();
			}
			this._time.push((new Date()).getTime() - this.startTime);
			this._posX.push(x);
			this._posY.push(y);
		},

		_keepInputCaretInActiveElement: function(){
			var activeElement = win.doc.activeElement;
			var initialValue;
			if(activeElement && (activeElement.tagName == "INPUT" || activeElement.tagName == "TEXTAREA")){
				initialValue = activeElement.value;
				if(activeElement.type == "number" || activeElement.type == "week"){
					if(initialValue){
						activeElement.value = activeElement.value + 1;
					}else{
						activeElement.value = (activeElement.type == "week") ? "2013-W10" : 1;
					}
					activeElement.value = initialValue;
				}else{
					activeElement.value = activeElement.value + " ";
					activeElement.value = initialValue;
				}
			}
		},

		onTouchEnd: function(/*Event*/e){
			// summary:
			//		User-defined function to handle touchEnd events.
			if(this._locked){ return; }
			var speed = this._speed = {x:0, y:0};
			var dim = this._dim;
			var pos = this.getPos();
			var to = {}; // destination
			if(e){
				if(!this._conn){ return; } // if we get onTouchEnd without onTouchStart, ignore it.
				for(var i = 0; i < this._conn.length; i++){
					connect.disconnect(this._conn[i]);
				}
				this._conn = null;

				var clicked = false;
				if(!this._aborted && !this._moved){
					clicked = true;
				}
				if(clicked){ // clicked, not dragged or flicked
					this.hideScrollBar();
					this.removeCover();
					// need to send a synthetic click?
					if(has("touch") && has("clicks-prevented") && !this.isFormElement(e.target)){
						var elem = e.target;
						if(elem.nodeType != 1){
							elem = elem.parentNode;
						}
						setTimeout(function(){
							dm._sendClick(elem, e);
						});
					}
					return;
				}
				speed = this._speed = this.getSpeed();
			}else{
				if(pos.x == 0 && pos.y == 0){ return; } // initializing
				dim = this.getDim();
			}

			if(this._v){
				to.y = pos.y + speed.y;
			}
			if(this._h || this._f){
				to.x = pos.x + speed.x;
			}

			if(this.adjustDestination(to, pos, dim) === false){ return; }
			if(this.constraint){
				if(this.scrollDir == "v" && dim.c.h < dim.d.h){ // content is shorter than display
					this.slideTo({y:0}, 0.3, "ease-out"); // go back to the top
					return;
				}else if(this.scrollDir == "h" && dim.c.w < dim.d.w){ // content is narrower than display
					this.slideTo({x:0}, 0.3, "ease-out"); // go back to the left
					return;
				}else if(this._v && this._h && dim.c.h < dim.d.h && dim.c.w < dim.d.w){
					this.slideTo({x:0, y:0}, 0.3, "ease-out"); // go back to the top-left
					return;
				}
			}

			var duration, easing = "ease-out";
			var bounce = {};
			if(this._v && this.constraint){
				if(to.y > 0){ // going down. bounce back to the top.
					if(pos.y > 0){ // started from below the screen area. return quickly.
						duration = 0.3;
						to.y = 0;
					}else{
						to.y = Math.min(to.y, 20);
						easing = "linear";
						bounce.y = 0;
					}
				}else if(-speed.y > dim.o.h - (-pos.y)){ // going up. bounce back to the bottom.
					if(pos.y < -dim.o.h){ // started from above the screen top. return quickly.
						duration = 0.3;
						to.y = dim.c.h <= dim.d.h ? 0 : -dim.o.h; // if shorter, move to 0
					}else{
						to.y = Math.max(to.y, -dim.o.h - 20);
						easing = "linear";
						bounce.y = -dim.o.h;
					}
				}
			}
			if((this._h || this._f) && this.constraint){
				if(to.x > 0){ // going right. bounce back to the left.
					if(pos.x > 0){ // started from right of the screen area. return quickly.
						duration = 0.3;
						to.x = 0;
					}else{
						to.x = Math.min(to.x, 20);
						easing = "linear";
						bounce.x = 0;
					}
				}else if(-speed.x > dim.o.w - (-pos.x)){ // going left. bounce back to the right.
					if(pos.x < -dim.o.w){ // started from left of the screen top. return quickly.
						duration = 0.3;
						to.x = dim.c.w <= dim.d.w ? 0 : -dim.o.w; // if narrower, move to 0
					}else{
						to.x = Math.max(to.x, -dim.o.w - 20);
						easing = "linear";
						bounce.x = -dim.o.w;
					}
				}
			}
			this._bounce = (bounce.x !== undefined || bounce.y !== undefined) ? bounce : undefined;

			if(duration === undefined){
				var distance, velocity;
				if(this._v && this._h){
					velocity = Math.sqrt(speed.x*speed.x + speed.y*speed.y);
					distance = Math.sqrt(Math.pow(to.y - pos.y, 2) + Math.pow(to.x - pos.x, 2));
				}else if(this._v){
					velocity = speed.y;
					distance = to.y - pos.y;
				}else if(this._h){
					velocity = speed.x;
					distance = to.x - pos.x;
				}
				if(distance === 0 && !e){ return; } // #13154
				duration = velocity !== 0 ? Math.abs(distance / velocity) : 0.01; // time = distance / velocity
			}
			this.slideTo(to, duration, easing);
		},

		adjustDestination: function(/*Object*/to, /*Object*/pos, /*Object*/dim){
			// summary:
			//		A stub function to be overridden by subclasses.
			// description:
			//		This function is called from onTouchEnd(). The purpose is to give its
			//		subclasses a chance to adjust the destination position. If this
			//		function returns false, onTouchEnd() returns immediately without
			//		performing scroll.
			// to:
			//		The destination position. An object with x and y.
			// pos:
			//		The current position. An object with x and y.
			// dim:
			//		Dimension information returned by getDim().			

			// subclass may want to implement
			return true; // Boolean
		},

		abort: function(){
			// summary:
			//		Aborts scrolling.
			// description:
			//		This function stops the scrolling animation that is currently
			//		running. It is called when the user touches the screen while
			//		scrolling.
			this._aborted = true;
			this.scrollTo(this.getPos());
			this.stopAnimation();
		},

		stopAnimation: function(){
			// summary:
			//		Stops the currently running animation.
			domClass.remove(this.containerNode, "mblScrollableScrollTo2");
			if(this._scrollBarV){
				this._scrollBarV.className = "";
			}
			if(this._scrollBarH){
				this._scrollBarH.className = "";
			}
			if(this._useTransformTransition || this._useTopLeft){
				this.containerNode.style[css3.name("transition")] = "";
				if(this._scrollBarV) { this._scrollBarV.style[css3.name("transition")] = ""; }
				if(this._scrollBarH) { this._scrollBarH.style[css3.name("transition")] = ""; }
			}
		},

		scrollIntoView: function(/*DOMNode*/node, /*Boolean?*/alignWithTop, /*Number?*/duration){
			// summary:
			//		Scrolls the pane until the searching node is in the view.
			// node:
			//		A DOM node to be searched for view.
			// alignWithTop:
			//		If true, aligns the node at the top of the pane.
			//		If false, aligns the node at the bottom of the pane.
			// duration:
			//		Duration of scrolling in seconds. (ex. 0.3)
			//		If not specified, scrolls without animation.
			// description:
			//		Just like the scrollIntoView method of DOM elements, this
			//		function causes the given node to scroll into view, aligning it
			//		either at the top or bottom of the pane.

			if(!this._v){ return; } // cannot scroll vertically

			var c = this.containerNode,
				h = this.getDim().d.h, // the height of ScrollableView's content display area
				top = 0;

			// Get the top position of node relative to containerNode
			for(var n = node; n !== c; n = n.offsetParent){
				if(!n || n.tagName === "BODY"){ return; } // exit if node is not a child of scrollableView
				top += n.offsetTop;
			}
			// Calculate scroll destination position
			var y = alignWithTop ? Math.max(h - c.offsetHeight, -top) : Math.min(0, h - top - node.offsetHeight);

			// Scroll to destination position
			(duration && typeof duration === "number") ? 
				this.slideTo({y: y}, duration, "ease-out") : this.scrollTo({y: y});
		},

		getSpeed: function(){
			// summary:
			//		Returns an object that indicates the scrolling speed.
			// description:
			//		From the position and elapsed time information, calculates the
			//		scrolling speed, and returns an object with x and y.
			var x = 0, y = 0, n = this._time.length;
			// if the user holds the mouse or finger more than 0.5 sec, do not move.
			if(n >= 2 && (new Date()).getTime() - this.startTime - this._time[n - 1] < 500){
				var dy = this._posY[n - (n > 3 ? 2 : 1)] - this._posY[(n - 6) >= 0 ? n - 6 : 0];
				var dx = this._posX[n - (n > 3 ? 2 : 1)] - this._posX[(n - 6) >= 0 ? n - 6 : 0];
				var dt = this._time[n - (n > 3 ? 2 : 1)] - this._time[(n - 6) >= 0 ? n - 6 : 0];
				y = this.calcSpeed(dy, dt);
				x = this.calcSpeed(dx, dt);
			}
			return {x:x, y:y};
		},

		calcSpeed: function(/*Number*/distance, /*Number*/time){
			// summary:
			//		Calculate the speed given the distance and time.
			return Math.round(distance / time * 100) * 4;
		},

		scrollTo: function(/*Object*/to, /*Boolean?*/doNotMoveScrollBar, /*DomNode?*/node){
			// summary:
			//		Scrolls to the given position immediately without animation.
			// to:
			//		The destination position. An object with x and y.
			//		ex. {x:0, y:-5}
			// doNotMoveScrollBar:
			//		If true, the scroll bar will not be updated. If not specified,
			//		it will be updated.
			// node:
			//		A DOM node to scroll. If not specified, defaults to
			//		this.containerNode.

			// scroll events
			var scrollEvent, beforeTopHeight, afterBottomHeight;
			var doScroll = true;
			if(!this._aborted && this._conn){ // No scroll event if the call to scrollTo comes from abort or onTouchEnd
				if(!this._dim){
					this._dim = this.getDim();
				}
				beforeTopHeight = (to.y > 0)?to.y:0;
				afterBottomHeight = (this._dim.o.h + to.y < 0)?-1 * (this._dim.o.h + to.y):0;
				scrollEvent = {bubbles: false,
						cancelable: false,
						x: to.x,
						y: to.y,
						beforeTop: beforeTopHeight > 0,
						beforeTopHeight: beforeTopHeight,
						afterBottom: afterBottomHeight > 0,
						afterBottomHeight: afterBottomHeight};
				// before scroll event
				doScroll = this.onBeforeScroll(scrollEvent);
			}
			
			if(doScroll){
				var s = (node || this.containerNode).style;
				if(has("css3-animations")){
					if(!this._useTopLeft){
						if(this._useTransformTransition){
							s[css3.name("transition")] = "";	
						}
						s[css3.name("transform")] = this.makeTranslateStr(to);
					}else{
						s[css3.name("transition")] = "";
						if(this._v){
							s.top = to.y + "px";
						}
						if(this._h || this._f){
							s.left = to.x + "px";
						}
					}
				}else{
					if(this._v){
						s.top = to.y + "px";
					}
					if(this._h || this._f){
						s.left = to.x + "px";
					}
				}
				if(has("ios")){
					this._keepInputCaretInActiveElement();
				}
				if(!doNotMoveScrollBar){
					this.scrollScrollBarTo(this.calcScrollBarPos(to));
				}
				if(scrollEvent){
					// After scroll event
					this.onAfterScroll(scrollEvent);
				}
			}
		},

		onBeforeScroll: function(/*Event*/e){
			// e: Event
			//		the scroll event, that contains the following attributes:
			//		x (x coordinate of the scroll destination),
			//		y (y coordinate of the scroll destination),
			//		beforeTop (a boolean that is true if the scroll detination is before the top of the scrollable),
			//		beforeTopHeight (the number of pixels before the top of the scrollable for the scroll destination),
			//		afterBottom (a boolean that is true if the scroll destination is after the bottom of the scrollable),
			//		afterBottomHeight (the number of pixels after the bottom of the scrollable for the scroll destination)
			// summary:
			//		called before a scroll is initiated. If this method returns false,
			//		the scroll is canceled.
			// tags:
			//		callback
			return true;
		},

		onAfterScroll: function(/*Event*/e){
			// e: Event
			//		the scroll event, that contains the following attributes:
			//		x (x coordinate of the scroll destination),
			//		y (y coordinate of the scroll destination),
			//		beforeTop (a boolean that is true if the scroll detination is before the top of the scrollable),
			//		beforeTopHeight (the number of pixels before the top of the scrollable for the scroll destination),
			//		afterBottom (a boolean that is true if the scroll destination is after the bottom of the scrollable),
			//		afterBottomHeight (the number of pixels after the bottom of the scrollable for the scroll destination)
			// summary:
			//		called after a scroll has been performed.
			// tags:
			//		callback
		},
		
		slideTo: function(/*Object*/to, /*Number*/duration, /*String*/easing){
			// summary:
			//		Scrolls to the given position with the slide animation.
			// to:
			//		The scroll destination position. An object with x and/or y.
			//		ex. {x:0, y:-5}, {y:-29}, etc.
			// duration:
			//		Duration of scrolling in seconds. (ex. 0.3)
			// easing:
			//		The name of easing effect which webkit supports.
			//		"ease", "linear", "ease-in", "ease-out", etc.

			this._runSlideAnimation(this.getPos(), to, duration, easing, this.containerNode, 2);
			this.slideScrollBarTo(to, duration, easing);
		},

		makeTranslateStr: function(/*Object*/to){
			// summary:
			//		Constructs a string value that is passed to the -webkit-transform property.
			// to:
			//		The destination position. An object with x and/or y.
			// description:
			//		Return value example: "translate3d(0px,-8px,0px)"

			var y = this._v && typeof to.y == "number" ? to.y+"px" : "0px";
			var x = (this._h||this._f) && typeof to.x == "number" ? to.x+"px" : "0px";
			return has("translate3d") ?
					"translate3d("+x+","+y+",0px)" : "translate("+x+","+y+")";
		},

		getPos: function(){
			// summary:
			//		Gets the top position in the midst of animation.
			if(has("css3-animations")){
				var s = win.doc.defaultView.getComputedStyle(this.containerNode, '');
				if(!this._useTopLeft){
					var m = s[css3.name("transform")];
					if(m && m.indexOf("matrix") === 0){
						var arr = m.split(/[,\s\)]+/);
						// IE10 returns a matrix3d
						var i = m.indexOf("matrix3d") === 0 ? 12 : 4;
						return {y:arr[i+1] - 0, x:arr[i] - 0};
					}
					return {x:0, y:0};
				}else{
					return {x:parseInt(s.left) || 0, y:parseInt(s.top) || 0};
				}
			}else{
				// this.containerNode.offsetTop does not work here,
				// because it adds the height of the top margin.
				var y = parseInt(this.containerNode.style.top) || 0;
				return {y:y, x:this.containerNode.offsetLeft};
			}
		},

		getDim: function(){
			// summary:
			//		Returns various internal dimensional information needed for calculation.

			var d = {};
			// content width/height
			d.c = {h:this.containerNode.offsetHeight, w:this.containerNode.offsetWidth};

			// view width/height
			d.v = {h:this.domNode.offsetHeight + this._appFooterHeight, w:this.domNode.offsetWidth};

			// display width/height
			d.d = {h:d.v.h - this.fixedHeaderHeight - this.fixedFooterHeight - this._appFooterHeight, w:d.v.w};

			// overflowed width/height
			d.o = {h:d.c.h - d.v.h + this.fixedHeaderHeight + this.fixedFooterHeight + this._appFooterHeight, w:d.c.w - d.v.w};
			return d;
		},

		showScrollBar: function(){
			// summary:
			//		Shows the scroll bar.
			// description:
			//		This function creates the scroll bar instance if it does not
			//		exist yet, and calls resetScrollBar() to reset its length and
			//		position.

			if(!this.scrollBar){ return; }

			var dim = this._dim;
			if(this.scrollDir == "v" && dim.c.h <= dim.d.h){ return; }
			if(this.scrollDir == "h" && dim.c.w <= dim.d.w){ return; }
			if(this._v && this._h && dim.c.h <= dim.d.h && dim.c.w <= dim.d.w){ return; }

			var createBar = function(self, dir){
				var bar = self["_scrollBarNode" + dir];
				if(!bar){
					var wrapper = domConstruct.create("div", null, self.domNode);
					var props = { position: "absolute", overflow: "hidden" };
					if(dir == "V"){
						props.right = "2px";
						props.width = "5px";
					}else{
						props.bottom = (self.isLocalFooter ? self.fixedFooterHeight : 0) + 2 + "px";
						props.height = "5px";
					}
					domStyle.set(wrapper, props);
					wrapper.className = "mblScrollBarWrapper";
					self["_scrollBarWrapper"+dir] = wrapper;

					bar = domConstruct.create("div", null, wrapper);
					domStyle.set(bar, css3.add({
						opacity: 0.6,
						position: "absolute",
						backgroundColor: "#606060",
						fontSize: "1px",
						MozBorderRadius: "2px",
						zIndex: 2147483647 // max of signed 32-bit integer
					}, {
						borderRadius: "2px",
						transformOrigin: "0 0"
					}));
					domStyle.set(bar, dir == "V" ? {width: "5px"} : {height: "5px"});
					self["_scrollBarNode" + dir] = bar;
				}
				return bar;
			};
			if(this._v && !this._scrollBarV){
				this._scrollBarV = createBar(this, "V");
			}
			if(this._h && !this._scrollBarH){
				this._scrollBarH = createBar(this, "H");
			}
			this.resetScrollBar();
		},

		hideScrollBar: function(){
			// summary:
			//		Hides the scroll bar.
			// description:
			//		If the fadeScrollBar property is true, hides the scroll bar with
			//		the fade animation.

			if(this.fadeScrollBar && has("css3-animations")){
				if(!dm._fadeRule){
					var node = domConstruct.create("style", null, win.doc.getElementsByTagName("head")[0]);
					node.textContent =
						".mblScrollableFadeScrollBar{"+
						"  " + css3.name("animation-duration", true) + ": 1s;"+
						"  " + css3.name("animation-name", true) + ": scrollableViewFadeScrollBar;}"+
						"@" + css3.name("keyframes", true) + " scrollableViewFadeScrollBar{"+
						"  from { opacity: 0.6; }"+
						"  to { opacity: 0; }}";
					dm._fadeRule = node.sheet.cssRules[1];
				}
			}
			if(!this.scrollBar){ return; }
			var f = function(bar, self){
				domStyle.set(bar, css3.add({
					opacity: 0
				}, {
					animationDuration: ""
				}));
				// do not use fade animation in case of using top/left on Android
				// since it causes screen flicker during adress bar's fading out
				if(!(self._useTopLeft && has('android'))){
					bar.className = "mblScrollableFadeScrollBar";
				}
			};
			if(this._scrollBarV){
				f(this._scrollBarV, this);
				this._scrollBarV = null;
			}
			if(this._scrollBarH){
				f(this._scrollBarH, this);
				this._scrollBarH = null;
			}
		},

		calcScrollBarPos: function(/*Object*/to){
			// summary:
			//		Calculates the scroll bar position.
			// description:
			//		Given the scroll destination position, calculates the top and/or
			//		the left of the scroll bar(s). Returns an object with x and y.
			// to:
			//		The scroll destination position. An object with x and y.
			//		ex. {x:0, y:-5}			

			var pos = {};
			var dim = this._dim;
			var f = function(wrapperH, barH, t, d, c){
				var y = Math.round((d - barH - 8) / (d - c) * t);
				if(y < -barH + 5){
					y = -barH + 5;
				}
				if(y > wrapperH - 5){
					y = wrapperH - 5;
				}
				return y;
			};
			if(typeof to.y == "number" && this._scrollBarV){
				pos.y = f(this._scrollBarWrapperV.offsetHeight, this._scrollBarV.offsetHeight, to.y, dim.d.h, dim.c.h);
			}
			if(typeof to.x == "number" && this._scrollBarH){
				pos.x = f(this._scrollBarWrapperH.offsetWidth, this._scrollBarH.offsetWidth, to.x, dim.d.w, dim.c.w);
			}
			return pos;
		},

		scrollScrollBarTo: function(/*Object*/to){
			// summary:
			//		Moves the scroll bar(s) to the given position without animation.
			// to:
			//		The destination position. An object with x and/or y.
			//		ex. {x:2, y:5}, {y:20}, etc.

			if(!this.scrollBar){ return; }
			if(this._v && this._scrollBarV && typeof to.y == "number"){
				if(has("css3-animations")){
					if(!this._useTopLeft){
						if(this._useTransformTransition){
							this._scrollBarV.style[css3.name("transition")] = "";
						}
						this._scrollBarV.style[css3.name("transform")] = this.makeTranslateStr({y:to.y});
					}else{
						domStyle.set(this._scrollBarV, css3.add({
							top: to.y + "px"
						}, {
							transition: ""
						}));
					}
				}else{
					this._scrollBarV.style.top = to.y + "px";
				}
			}
			if(this._h && this._scrollBarH && typeof to.x == "number"){
				if(has("css3-animations")){
					if(!this._useTopLeft){
						if(this._useTransformTransition){
							this._scrollBarH.style[css3.name("transition")] = "";
						}
						this._scrollBarH.style[css3.name("transform")] = this.makeTranslateStr({x:to.x});
					}else{
						domStyle.set(this._scrollBarH, css3.add({
							left: to.x + "px"
						}, {
							transition: ""
						}));
					}
				}else{
					this._scrollBarH.style.left = to.x + "px";
				}
			}
		},

		slideScrollBarTo: function(/*Object*/to, /*Number*/duration, /*String*/easing){
			// summary:
			//		Moves the scroll bar(s) to the given position with the slide animation.
			// to:
			//		The destination position. An object with x and y.
			//		ex. {x:0, y:-5}
			// duration:
			//		Duration of the animation in seconds. (ex. 0.3)
			// easing:
			//		The name of easing effect which webkit supports.
			//		"ease", "linear", "ease-in", "ease-out", etc.

			if(!this.scrollBar){ return; }
			var fromPos = this.calcScrollBarPos(this.getPos());
			var toPos = this.calcScrollBarPos(to);
			if(this._v && this._scrollBarV){
				this._runSlideAnimation({y:fromPos.y}, {y:toPos.y}, duration, easing, this._scrollBarV, 0);
			}
			if(this._h && this._scrollBarH){
				this._runSlideAnimation({x:fromPos.x}, {x:toPos.x}, duration, easing, this._scrollBarH, 1);
			}
		},

		_runSlideAnimation: function(/*Object*/from, /*Object*/to, /*Number*/duration, /*String*/easing, /*DomNode*/node, /*Number*/idx){
			// tags:
			//		private
			
			// idx: 0:scrollbarV, 1:scrollbarH, 2:content
			if(has("css3-animations")){
				if(!this._useTopLeft){
					if(this._useTransformTransition){
						// for iOS6 (maybe others?): use -webkit-transform + -webkit-transition
						if(to.x === undefined){ to.x = from.x; }
						if(to.y === undefined){ to.y = from.y; }
						 // make sure we actually change the transform, otherwise no webkitTransitionEnd is fired.
						if(to.x !== from.x || to.y !== from.y){
							this.onFlickAnimationStart(); // needed because there is no transitionstart event.
							domStyle.set(node, css3.add({}, {
								transitionProperty: css3.name("transform"),
								transitionDuration: duration + "s",
								transitionTimingFunction: easing
							}));
							var t = this.makeTranslateStr(to);
							setTimeout(function(){ // setTimeout is needed to prevent webkitTransitionEnd not fired
								domStyle.set(node, css3.add({}, {
									transform: t
								}));
							}, 0);
							domClass.add(node, "mblScrollableScrollTo"+idx);
						} else {
							// transform not changed, just hide the scrollbar
							this.hideScrollBar();
							this.removeCover();
						}
					}else{
						// use -webkit-transform + -webkit-animation
						this.setKeyframes(from, to, idx);
						domStyle.set(node, css3.add({}, {
							animationDuration: duration + "s",
							animationTimingFunction: easing
						}));
						domClass.add(node, "mblScrollableScrollTo"+idx);
						if(idx == 2){
							this.scrollTo(to, true, node);
						}else{
							this.scrollScrollBarTo(to);
						}
					}
				}else if(to.x !== undefined || to.y !== undefined){
					this.onFlickAnimationStart(); // #17822: needed because there is no transitionstart event.
					domStyle.set(node, css3.add({}, {
						// #17822 when scrolling on one direction, avoid unnecessarily animating
						// both top and left, because this leads to two transitionend events fired 
						// instead of one in some browsers (Safari/iOS7 at least).
						transitionProperty: (to.x !== undefined && to.y !== undefined) ?
							"top, left" :
							to.y !== undefined ? "top" : "left",
						transitionDuration: duration + "s",
						transitionTimingFunction: easing
					}));
					setTimeout(function(){ // setTimeout is needed to prevent webkitTransitionEnd not fired
						var style = {};
						if(to.x !== undefined){
							style.left = to.x + "px";
						}
						if(to.y !== undefined){
							style.top = to.y + "px";
						}
						domStyle.set(node, style);
					}, 0);
					domClass.add(node, "mblScrollableScrollTo"+idx);
				}
			}else if(dojo.fx && dojo.fx.easing && duration){
				// If you want to support non-webkit browsers,
				// your application needs to load necessary modules as follows:
				//
				// | dojo.require("dojo.fx");
				// | dojo.require("dojo.fx.easing");
				//
				// This module itself does not make dependency on them.
				// TODO: for 2.0 the dojo global is going away. Use require("dojo/fx") and require("dojo/fx/easing") instead.
				
				var self = this;
				var s = dojo.fx.slideTo({
					node: node,
					duration: duration*1000,
					left: to.x,
					top: to.y,
					easing: (easing == "ease-out") ? dojo.fx.easing.quadOut : dojo.fx.easing.linear,
					onBegin: function(){ // #17822
						if(idx == 2){
							self.onFlickAnimationStart();
						}
					},
					onEnd: function(){
						if(idx == 2){
							self.onFlickAnimationEnd();
						}
					}
				}).play();
			}else{
				// directly jump to the destination without animation
				if(idx == 2){
					this.onFlickAnimationStart(); // #17822
					this.scrollTo(to, false, node);
					this.onFlickAnimationEnd();
				}else{
					this.scrollScrollBarTo(to);
				}
			}
		},

		resetScrollBar: function(){
			// summary:
			//		Resets the scroll bar length, position, etc.
			var f = function(wrapper, bar, d, c, hd, v){
				if(!bar){ return; }
				var props = {};
				props[v ? "top" : "left"] = hd + 4 + "px"; // +4 is for top or left margin
				var t = (d - 8) <= 0 ? 1 : d - 8;
				props[v ? "height" : "width"] = t + "px";
				domStyle.set(wrapper, props);
				var l = Math.round(d * d / c); // scroll bar length
				l = Math.min(Math.max(l - 8, 5), t); // -8 is for margin for both ends
				bar.style[v ? "height" : "width"] = l + "px";
				domStyle.set(bar, {"opacity": 0.6});
			};
			var dim = this.getDim();
			f(this._scrollBarWrapperV, this._scrollBarV, dim.d.h, dim.c.h, this.fixedHeaderHeight, true);
			f(this._scrollBarWrapperH, this._scrollBarH, dim.d.w, dim.c.w, 0);
			this.createMask();
		},

		createMask: function(){
			// summary:
			//		Creates a mask for a scroll bar edge.
			// description:
			//		This function creates a mask that hides corners of one scroll
			//		bar edge to make it round edge. The other side of the edge is
			//		always visible and round shaped with the border-radius style.
			if(!(has("mask-image"))){ return; }
			if(this._scrollBarWrapperV){
				var h = this._scrollBarWrapperV.offsetHeight;
				maskUtils.createRoundMask(this._scrollBarWrapperV, 0, 0, 0, 0, 5, h, 2, 2, 0.5);
			}
			if(this._scrollBarWrapperH){
				var w = this._scrollBarWrapperH.offsetWidth;
				maskUtils.createRoundMask(this._scrollBarWrapperH, 0, 0, 0, 0, w, 5, 2, 2, 0.5);
			}
		},

		flashScrollBar: function(){
			// summary:
			//		Shows the scroll bar instantly.
			// description:
			//		This function shows the scroll bar, and then hides it 300ms
			//		later. This is used to show the scroll bar to the user for a
			//		short period of time when a hidden view is revealed.
			if(this.disableFlashScrollBar || !this.domNode){ return; }
			this._dim = this.getDim();
			if(this._dim.d.h <= 0){ return; } // dom is not ready
			this.showScrollBar();
			var _this = this;
			setTimeout(function(){
				_this.hideScrollBar();
			}, 300);
		},

		addCover: function(){
			// summary:
			//		Adds the transparent DIV cover.
			// description:
			//		The cover is to prevent DOM events from affecting the child
			//		widgets such as a list widget. Without the cover, for example,
			//		child widgets may receive a click event and respond to it
			//		unexpectedly when the user flicks the screen to scroll.
			//		Note that only the desktop browsers need the cover.

			if(!has("touch") && !this.noCover){
				if(!dm._cover){
					dm._cover = domConstruct.create("div", null, win.doc.body);
					dm._cover.className = "mblScrollableCover";
					domStyle.set(dm._cover, {
						backgroundColor: "#ffff00",
						opacity: 0,
						position: "absolute",
						top: "0px",
						left: "0px",
						width: "100%",
						height: "100%",
						zIndex: 2147483647 // max of signed 32-bit integer
					});
					this._ch.push(connect.connect(dm._cover, touch.press, this, "onTouchEnd"));
				}else{
					dm._cover.style.display = "";
				}
				this.setSelectable(dm._cover, false);
				this.setSelectable(this.domNode, false);
			}
		},

		removeCover: function(){
			// summary:
			//		Removes the transparent DIV cover.

			if(!has("touch") && dm._cover){
				dm._cover.style.display = "none";
				this.setSelectable(dm._cover, true);
				this.setSelectable(this.domNode, true);
			}
		},

		setKeyframes: function(/*Object*/from, /*Object*/to, /*Number*/idx){
			// summary:
			//		Programmatically sets key frames for the scroll animation.

			if(!dm._rule){
				dm._rule = [];
			}
			// idx: 0:scrollbarV, 1:scrollbarH, 2:content
			if(!dm._rule[idx]){
				var node = domConstruct.create("style", null, win.doc.getElementsByTagName("head")[0]);
				node.textContent =
					".mblScrollableScrollTo"+idx+"{" + css3.name("animation-name", true) + ": scrollableViewScroll"+idx+";}"+
					"@" + css3.name("keyframes", true) + " scrollableViewScroll"+idx+"{}";
				dm._rule[idx] = node.sheet.cssRules[1];
			}
			var rule = dm._rule[idx];
			if(rule){
				if(from){
					rule.deleteRule(has("webkit")?"from":0);
					(rule.insertRule||rule.appendRule).call(rule, "from { " + css3.name("transform", true) + ": "+this.makeTranslateStr(from)+"; }");
				}
				if(to){
					if(to.x === undefined){ to.x = from.x; }
					if(to.y === undefined){ to.y = from.y; }
					rule.deleteRule(has("webkit")?"to":1);
					(rule.insertRule||rule.appendRule).call(rule, "to { " + css3.name("transform", true) + ": "+this.makeTranslateStr(to)+"; }");
				}
			}
		},

		setSelectable: function(/*DomNode*/node, /*Boolean*/selectable){
			// summary:
			//		Sets the given node as selectable or unselectable.
			 
			// dojo.setSelectable has dependency on dojo.query. Redefine our own.
			node.style.KhtmlUserSelect = selectable ? "auto" : "none";
			node.style.MozUserSelect = selectable ? "" : "none";
			node.onselectstart = selectable ? null : function(){return false;};
			if(has("ie")){
				node.unselectable = selectable ? "" : "on";
				var nodes = node.getElementsByTagName("*");
				for(var i = 0; i < nodes.length; i++){
					nodes[i].unselectable = selectable ? "" : "on";
				}
			}
		}
	});
	Scrollable = has("dojo-bidi") ? declare("dojox.mobile.Scrollable", [Scrollable, BidiScrollable]) : Scrollable;
	lang.setObject("dojox.mobile.scrollable", Scrollable);

	return Scrollable;
});

},
'dojox/mobile/_base':function(){
define([
	"./common",
	"./View",
	"./Heading",
	"./RoundRect",
	"./RoundRectCategory",
	"./EdgeToEdgeCategory",
	"./RoundRectList",
	"./EdgeToEdgeList",
	"./ListItem",
	"./Container",
	"./Pane",
	"./Switch",
	"./ToolBarButton",
	"./ProgressIndicator"
], function(common, View, Heading, RoundRect, RoundRectCategory, EdgeToEdgeCategory, RoundRectList, EdgeToEdgeList, ListItem, Switch, ToolBarButton, ProgressIndicator){
	// module:
	//		dojox/mobile/_base

	/*=====
	return {
		// summary:
		//		Includes the basic dojox/mobile modules: common, View, Heading, 
		//		RoundRect, RoundRectCategory, EdgeToEdgeCategory, RoundRectList,
		//		EdgeToEdgeList, ListItem, Container, Pane, Switch, ToolBarButton, 
		//		and ProgressIndicator.
	};
	=====*/
	return common;
});

},
'dojox/mobile/PageIndicator':function(){
define([
	"dojo/_base/connect",
	"dojo/_base/declare",
	"dojo/dom",
	"dojo/dom-class",
	"dojo/dom-construct",
	"dijit/registry",
	"dijit/_Contained",
	"dijit/_WidgetBase",
	"dojo/i18n!dojox/mobile/nls/messages"
], function(connect, declare, dom, domClass, domConstruct, registry, Contained, WidgetBase, messages){

	// module:
	//		dojox/mobile/PageIndicator

	return declare("dojox.mobile.PageIndicator", [WidgetBase, Contained],{
		// summary:
		//		A current page indicator.
		// description:
		//		PageIndicator displays a series of gray and white dots to
		//		indicate which page is currently being viewed. It can typically
		//		be used with dojox/mobile/SwapView. It is also internally used
		//		in dojox/mobile/Carousel.

		// refId: String
		//		An ID of a DOM node to be searched. Siblings of the reference
		//		node will be searched for views. If not specified, this.domNode
		//		will be the reference node.
		refId: "",

		// baseClass: String
		//		The name of the CSS class of this widget.
		baseClass: "mblPageIndicator",

		buildRendering: function(){
			this.inherited(arguments);
			this.domNode.setAttribute("role", "img");
			this._tblNode = domConstruct.create("table", {className:"mblPageIndicatorContainer"}, this.domNode);
			this._tblNode.insertRow(-1);
			this.connect(this.domNode, "onclick", "_onClick");
			this.subscribe("/dojox/mobile/viewChanged", function(view){
				this.reset();
			});
		},

		startup: function(){
			var _this = this;
			_this.defer(function(){ // to wait until views' visibility is determined
				_this.reset();
			});
		},

		reset: function(){
			// summary:
			//		Updates the indicator.
			var r = this._tblNode.rows[0];
			var i, c, a = [], dot, value = 0;
			var refNode = (this.refId && dom.byId(this.refId)) || this.domNode;
			var children = refNode.parentNode.childNodes;
			for(i = 0; i < children.length; i++){
				c = children[i];
				if(this.isView(c)){
					a.push(c);
				}
			}
			if(r.cells.length !== a.length){
				domConstruct.empty(r);
				for(i = 0; i < a.length; i++){
					c = a[i];
					dot = domConstruct.create("div", {className:"mblPageIndicatorDot"});
					r.insertCell(-1).appendChild(dot);
				}
			}
			if(a.length === 0){ return; }
			var currentView = registry.byNode(a[0]).getShowingView();
			for(i = 0; i < r.cells.length; i++){
				dot = r.cells[i].firstChild;
				if(a[i] === currentView.domNode){
					value = i + 1;
					domClass.add(dot, "mblPageIndicatorDotSelected");
				}else{
					domClass.remove(dot, "mblPageIndicatorDotSelected");
				}
			}
			if (r.cells.length)  {
				this.domNode.setAttribute("alt", messages["PageIndicatorLabel"].replace("$0", value).replace("$1", r.cells.length));
			} else {
				this.domNode.removeAttribute("alt");
			}
		},

		isView: function(node){
			// summary:
			//		Returns true if the given node is a view.
			return (node && node.nodeType === 1 && domClass.contains(node, "mblView")); // Boolean
		},

		_onClick: function(e){
			// summary:
			//		Internal handler for click events.
			// tags:
			//		private
			if(this.onClick(e) === false){ return; } // user's click action
			if(e.target !== this.domNode){ return; }
			if(e.layerX < this._tblNode.offsetLeft){
				connect.publish("/dojox/mobile/prevPage", [this]);
			}else if(e.layerX > this._tblNode.offsetLeft + this._tblNode.offsetWidth){
				connect.publish("/dojox/mobile/nextPage", [this]);
			}
		},

		onClick: function(/*Event*/ /*===== e =====*/){
			// summary:
			//		User-defined function to handle clicks.
			// tags:
			//		callback
		}
	});
});

},
'dojox/mobile/_css3':function(){
define([
	"dojo/_base/window",
	"dojo/_base/array",
	"dojo/has"
], function(win, arr, has){

	// caches for capitalized names and hypen names
	var cnames = [], hnames = [];

	// element style used for feature testing
	var style = win.doc.createElement("div").style;

	// We just test webkit prefix for now since our themes only have standard and webkit
	// (see dojox/mobile/themes/common/css3.less)
	// More prefixes can be added if/when we add them to css3.less.
	var prefixes = ["webkit"];

	// Does the browser support CSS3 animations?
	has.add("css3-animations", function(global, document, element){
		var style = element.style;
		return (style["animation"] !== undefined && style["transition"] !== undefined) ||
			arr.some(prefixes, function(p){
				return style[p+"Animation"] !== undefined && style[p+"Transition"] !== undefined;
			});
	});

	// Indicates whether style 'transition' returns empty string instead of
	// undefined, although TransitionEvent is not supported.
	// Reported on Android 4.1.x on some devices: https://bugs.dojotoolkit.org/ticket/17164
	has.add("t17164", function(global, document, element){
		return (element.style["transition"] !== undefined) && !('TransitionEvent' in window);
	});

	var css3 = {
		// summary:
		//		This module provide some cross-browser support for CSS3 properties.

		name: function(/*String*/p, /*Boolean?*/hyphen){
			// summary:
			//		Returns the name of a CSS3 property with the correct prefix depending on the browser.
			// p:
			//		The (non-prefixed) property name. The property name is assumed to be consistent with
			//		the hyphen argument, for example "transition-property" if hyphen is true, or "transitionProperty"
			//		if hyphen is false. If the browser supports the non-prefixed property, the property name will be
			//		returned unchanged.
			// hyphen:
			//		Optional, true if hyphen notation should be used (for example "transition-property" or "-webkit-transition-property"),
			//		false for camel-case notation (for example "transitionProperty" or "webkitTransitionProperty").

			var n = (hyphen?hnames:cnames)[p];
			if(!n){

				if(/End|Start/.test(p)){
					// event names: no good way to feature-detect, so we
					// assume they have the same prefix as the corresponding style property
					var idx = p.length - (p.match(/End/) ? 3 : 5);
					var s = p.substr(0, idx);
					var pp = this.name(s);
					if(pp == s){
						// no prefix, standard event names are all lowercase
						n = p.toLowerCase();
					}else{
						// prefix, e.g. webkitTransitionEnd (camel case)
						n = pp + p.substr(idx);
					}
				}else if(p == "keyframes"){
					// special case for keyframes, we also rely on consistency between 'animation' and 'keyframes'
					var pk = this.name("animation", hyphen);
					if(pk == "animation"){
						n = p;
					}else if(hyphen){
						n = pk.replace(/animation/, "keyframes");
					}else{
						n = pk.replace(/Animation/, "Keyframes");
					}
				}else{
					// convert name to camel-case for feature test
					var cn = hyphen ? p.replace(/-(.)/g, function(match, p1){
    					return p1.toUpperCase();
					}) : p;
					if(style[cn] !== undefined && !has('t17164')){
						// standard non-prefixed property is supported
						n = p;
					}else{
						// try prefixed versions
						cn = cn.charAt(0).toUpperCase() + cn.slice(1);
						arr.some(prefixes, function(prefix){
							if(style[prefix+cn] !== undefined){
								if(hyphen){
									n = "-" + prefix + "-" + p;
								}else{
									n = prefix + cn;
								}
							}
						});
					}
				}

				if(!n){
					// The property is not supported, just return it unchanged, it will be ignored.
					n = p;
				}

				(hyphen?hnames:cnames)[p] = n;
			}
			return n;
		},

		add: function(/*Object*/styles, /*Object*/css3Styles){
			// summary:
			//		Prefixes all property names in "css3Styles" and adds the prefixed properties in "styles".
			//		Used as a convenience when an object is passed to domStyle.set to set multiple styles.
			// example:
			//		domStyle.set(bar, css3.add({
			//			opacity: 0.6,
			//			position: "absolute",
			//			backgroundColor: "#606060"
			//		}, {
			//			borderRadius: "2px",
			//			transformOrigin: "0 0"
			//		}));
			// returns:
			//		The "styles" argument where the CSS3 styles have been added.

			for(var p in css3Styles){
				if(css3Styles.hasOwnProperty(p)){
					styles[css3.name(p)] = css3Styles[p];
				}
			}
			return styles;
		}
	};

	return css3;
});

},
'*now':function(r){r(['dojo/i18n!*preload*dojo/nls/dojomobile*["ar","ca","cs","da","de","el","en-gb","en-us","es-es","fi-fi","fr-fr","he-il","hu","it-it","ja-jp","ko-kr","nl-nl","nb","pl","pt-br","pt-pt","ru","sk","sl","sv","th","tr","zh-tw","zh-cn","ROOT"]']);}
}});
define("dojo/dojomobile", [], 1);
