//-----------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (C) Copyright IBM Corp. 2009, 2014 All Rights Reserved.
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with
// IBM Corp.
//-----------------------------------------------------------------


/**
 * @fileOverview This file will setup facebook environment to use facebook widgets, i.e. 'Like, 'Send' buttons, etc... 
 * get user logged in status and setup certain event to register to. The following events are supported: 
 * 1. edge.create: This event is fired when the user likes something (fb:like). 
 *      The response parameter to the callback function contains the URL that was liked.
 * 2. edge.remove - This event is fired when the user unlikes something (fb:like). The response parameter to the callback function 
 *      contains the URL that was unliked. 
 * 
 * FB.getLoginStatus - determines if a user is logged in and connected to your app.
 * 
 * @version 1.0
 * 
 **/

/**
* @class fbIntegrationJS This class defines all the variables and functions used by the FBIntegrationJS.js 
* One and only one global fbIntegrationJS should be created. Therefore, we create this object only when it is not present in 
* in the global namespace.
*
**/
if(typeof(fbIntegrationJS) == "undefined" || !fbIntegrationJS){
   
    /* query parms passed in from this Javascript  */
    var FBappIdQueryParm = ""; //appid
    var FBlocaleQueryParm = ""; //locale
    
	fbIntegrationJS = {
		/** The application ID is used to authorize and access facebook app **/
	    appId : "",
        /** Facebook user's name **/
	    name : "",
	    /** Facebook's 3rd party user id **/
        third_party_id : "",
	    /** Facebook's picture of user **/
        picture : "",
	    /** Facebook's connected status **/
        userStatus : false,
	    /** Facebook's access token **/
        accessToken : "",
 
        /* menu item is being hovered over with mouse */
        menuItemHovered : false,
        
        //Flag is logging in  via Like button. 
        isLoginViaLike : false,
        
        //Page reference that is return from Facebook like event
        widgetPageRef : null,
        
        //to be used on the disconnect for Facebook Menu:
        saveFacebookMenuFocuslink : null, 

        // initial facebook with the specified appId
	    FBinit_Callback : function(appId) {

	        console.log("BEGIN initFacebook_Callback, using this appid = "+ appId);
	        this.appId = appId ; 
			if (Utils.get_IE_version() <= 7) { // only IE7 and older - to get FB login status, you MUST Include "channelUrl" parameter 
		        FB.init({appId: this.appId, channelUrl: absoluteURL+"FacebookChannelUrl.html" , oauth: true, status: true, cookie: true, xfbml: true});
			}else{
		        FB.init({appId: this.appId, oauth: true, status: true, cookie: true, xfbml: true});
			}

	        console.log("END initFacebook_Callback. this.appid = "+this.appId);

            //load up Social CSS file so Madison's store pages will have this css file
	        this.loadSocialCssFile(imageDirectoryPath+"css/SocialIntegration.css");
	        // subscribe to FB events at startup 
	        this.FB_SubscribeEvents();
	        this.FB_GetFacebookLoginStatus(); //get status on initial startup
	    },

	    //subscribe to these events 
	    FB_SubscribeEvents : function() { //subscribe to FB events 

	        console.log("BEGIN FB_SubscribeEvents");
	        
	        /* All the events registered */
	        FB.Event.subscribe('edge.create', function(response, widget) {//'like' event
		        console.log("BEGIN FB.Event.subscribe- edge.create");
	            // do something with the 'like'event, this.send_MarketingLikeMetrics();
				// create map of key/value pairs to send to marketing engine
				var mktObj = { "type": "likes"};

				//only authorized user will allow 'like' event to flow to marketing engine 
				if (widget != null && fbIntegrationJS.isConnected()) {
					fbIntegrationJS._triggerHandler(widget._attr.ref, mktObj);
				}

					
				if ( !fbIntegrationJS.isConnected()) {
				     //Set a flag here that 'Liked' event occurred without being connected. Set flag to true and then
				     //set back to 'false' in '_onFacebookLoginStatus()'. Send to Marketing if connected !!!!
					 fbIntegrationJS.isLoginViaLike = true;
					 
				     //Get current status of Facebook user. When FB.getLoginStatus(function(response) {}, true),
				     //is called, 'Auth.login' will be issued to get login status. If we don't call FB.getLoginStatus with 'true', 
				     //the login status will always be 'unknown'. Therefore, force a reloading of the login status
					 console.log("FB Like event - Current login status is 'unknown', Calling FB.getLoginStatus(function(response) {}, true) to get latest login status ");		               		
					 FB.getLoginStatus(function(response) {}, true);
					 
					 //Store widgetPageRef for later use
					 fbIntegrationJS.widgetPageRef = widget._attr.ref;
				}	
						
		        console.log("END FB.Event.subscribe - edge.create");
	        });
	        
	        
	        FB.Event.subscribe('edge.remove', function(response, widget) {//'unlike' event
		        console.log("BEGIN FB.Event.subscribe- edge.remove");
	            // do something with the 'unlike'event, this.send_MarketingUnlikeMetrics();	
				// create map of key/value pairs to send to marketing engine
				var mktObj = { "type": "unlikes" };

				//only authorized user will allow 'unlike' event to flow to marketing engine 
				if (widget != null && fbIntegrationJS.isConnected()) {
					fbIntegrationJS._triggerHandler(widget._attr.ref, mktObj);
				}
	        
				console.log("END FB.Event.subscribe - edge.remove");
	        });
	        FB.Event.subscribe('auth.login', function(response) { //logged in
	            // do something with response
		        console.log("BEGIN FB.Event.subscribe - auth.login");

		        if ( response.status == 'connected'){//user has logged out successfully
		        	//User has signed in, update header menu and the FB plugins
					fbIntegrationJS.userStatus = true;
		        	fbIntegrationJS._onFacebookLoginStatus(response);
			        //update the plugins to their current state
			        fbIntegrationJS._updateFacebookPlugins();
		        }
		        console.log("END FB.Event.subscribe - auth.login");
	        });
	        FB.Event.subscribe('auth.logout', function(response) { //logged off
	            // do something with response
		        console.log("BEGIN FB.Event.subscribe - auth.logout");
		        //User is logged off; update the plugins
		        if ( response.status == 'unknown'){//user has logged out successfully
				   //update our status to logged out.
			       fbIntegrationJS.onClickFacebookLogout();
		        }
		        console.log("END FB.Event.subscribe - auth.logout");
	        });
	        wcTopic.subscribe("FacebookIntegraionDynamicLogin", $.proxy(this, this.dynamicSocialBridgingLoginRequest));
        	wcTopic.subscribe("FacebookIntegraionDynamicLogout", $.proxy(this, this.onClickFacebookLogout));

	  
	        console.log("EXIT FB_SubscribeEvents");

	    },

	    //Reload facebook plugin(s) to show their current status
	    _updateFacebookPlugins : function() { 

	        console.log("BEGIN _updateFacebookPlugins");
            //check if request is via Like button. If so, no need to referesh FB plugins
	        if(fbIntegrationJS.isLoginViaLike != true){
		        //On home page, update like button
		        var homePageLikeBtn = document.getElementById('social_facebook_Like_HomeSidebarDisplay');
		        if ( homePageLikeBtn ){
			        var likeBtnIframe = homePageLikeBtn.getElementsByTagName("iframe")[0];
			        
			        //refresh the like button on home page for iFrame
			        if (likeBtnIframe){
			        	var url = likeBtnIframe.getAttribute("src");
			        	likeBtnIframe.setAttribute("src", url);
			        }
		        }
	
		        //details page like button
		        var detailsPageLikeBtn = document.getElementById('social_facebook_Details_Like_Button_Display');
				//make sure its been liked
		        if ( detailsPageLikeBtn ){
			        var likeBtnIframe = detailsPageLikeBtn.getElementsByTagName("iframe")[0];
			        
			        //refresh the like button on product page foriFrame
			        if (likeBtnIframe){
			        	var url = likeBtnIframe.getAttribute("src");
			        	likeBtnIframe.setAttribute("src", url);
			        }
		        }
	
		        //On homepage, update activity feed plug-in
		        var homePageActivityFeed = document.getElementById('social_facebook_Activity_HomeSidebarDisplay');
		        if ( homePageActivityFeed ){
			        var activityFeedIframe = homePageActivityFeed.getElementsByTagName("iframe")[0];
			        
			        //refresh the activity feed iFrame
			        if (activityFeedIframe){
			        	var url = activityFeedIframe.getAttribute("src");
			        activityFeedIframe.setAttribute("src", url);
			        }
		        }

				//Reset Global Flag
		        fbIntegrationJS.isLoginViaLike = false;
	        }
	        console.log("EXIT _updateFacebookPlugins");

	    },
	    
	    //get determine if a user is logged in and connected to your app.
	    FB_GetFacebookLoginStatus : function() { 

	        console.log("BEGIN FB_GetFacebookLoginStatus");
       
	        FB.getLoginStatus(this._onFacebookLoginStatus);

	        console.log("EXIT FB_GetFacebookLoginStatus");

	    },
	    
	    /*
	     * Callback function for FB.getLoginStatus or FB.Login
	     */
	    _onFacebookLoginStatus: function(response){

		    console.log("BEGIN Callback from FB_getLoginStatus - _onFacebookLoginStatus()");
            console.log('_onFacebookLoginStatus() - status= ' + response.status);
	    	// do something with response
	        if (response.status=="connected" && response.authResponse) {
                //If isLoginViaLike is set to true, means user is logging in via Like button
                //Trigger a Marketing event since user has already authorized the Application.
                if (fbIntegrationJS.widgetPageRef != null && fbIntegrationJS.isLoginViaLike === true) {
                		var mktObj = { "type": "likes"}; 
						fbIntegrationJS._triggerHandler(fbIntegrationJS.widgetPageRef, mktObj);
				}
	        	 
				fbIntegrationJS.userStatus = true;
	        	//save access token 
	        	fbIntegrationJS.accessToken = response.authResponse.accessToken;
		        //if browsing secure, make sure the resources are fetched secured otherwise
		        //warnings will be issued in browser, especially IE
		        if (location.protocol == "https:"){
		        	FB.api("/me?return_ssl_resources=1&fields=third_party_id,name,picture", fbIntegrationJS._onUserInfoLoaded);
		        }else{
		        	FB.api("/me?fields=third_party_id,name,picture", fbIntegrationJS._onUserInfoLoaded);
		        }
	         
	         } else
	            if (response.status === 'not_authorized') {
	                console.log('Callback from FB_getLoginStatus - _onFacebookLoginStatus() - status= ' + response.status);
	                //the user is logged in to Facebook, 
			        fbIntegrationJS._updateFacebookPlugins();

			        //but not connected to the app, show Connect To Facebook link
	            	fbIntegrationJS._displayConnectFacebookLink();
		            console.log('Callback from FB_getLoginStatus - _onFacebookLoginStatus() - user logged in to Facebook but not_connected to application');
	         } else {
	            //user cancelled login or did not grant authorization
	        	 fbIntegrationJS._displayConnectFacebookLink();
	             console.log('Callback from FB_getLoginStatus - _onFacebookLoginStatus() - user cancelled login or did not grant authorization');
	            
	         }
	         console.log("END Callback from FB_getLoginStatus - _onFacebookLoginStatus()");
	    },

	    //Connect to Facebook, display the link "Connect To Facebook"
	    _displayConnectFacebookLink : function() { //subscribe to FB events 

	        console.log("BEGIN _displayConnectFacebookLink");
       

	        var loginFacebookButtonDiv=document.getElementById("header-fb-login-button-span");
			if(loginFacebookButtonDiv !=null && loginFacebookButtonDiv != undefined){
				loginFacebookButtonDiv.style.display="inline"; 
			}
	        
 	        var logoutFacebookButtonDiv=document.getElementById("header-fb-logout-button-span");
			if(logoutFacebookButtonDiv !=null && logoutFacebookButtonDiv != undefined){
				logoutFacebookButtonDiv.style.display="none";
			}
			
	        console.log("EXIT _displayConnectFacebookLink");

	    },

	    //Display Facebook Menu with profile pix - The submenu will have "Disconnect from Facebook"
	    _displayFacebookMenu : function() { //subscribe to FB events 

	        console.log("BEGIN _displayFacebookMenu");

	        var loginFacebookButtonDiv=document.getElementById("header-fb-login-button-span");
			if(loginFacebookButtonDiv!=null && loginFacebookButtonDiv != undefined){
				loginFacebookButtonDiv.style.display="none"; 
			}
	        
		    var logoutFacebookButtonDiv=document.getElementById("header-fb-logout-button-span");
		    if(logoutFacebookButtonDiv!=null && logoutFacebookButtonDiv != undefined){
			    //add profile picture and name to mast header Menu
		    	// <div <img /><span /> </div> - the inner html( img pix and name) will be added menu label, see widget's menuDropDownWidget label
		    	var facebookUserProfileDiv = null;
		    	
		    	//make sure there's a profile image
		    	if ( fbIntegrationJS.picture != ""){
			    	facebookUserProfileDiv = document.createElement("div");
			    	facebookUserProfileDiv.setAttribute('id',"WC_FacebookUserProfileDiv");
			        var facebookUserProfileImg=document.createElement("img");
			        facebookUserProfileImg.setAttribute("id", "WC_FacebookUserProfileImg" );
			        facebookUserProfileImg.setAttribute("src", fbIntegrationJS.picture.data.url );
			        facebookUserProfileImg.setAttribute("title", fbIntegrationJS.name);
			        facebookUserProfileImg.setAttribute("alt", fbIntegrationJS.name);
			        facebookUserProfileImg.setAttribute("class", "socialFacebookProfilePix");
			        facebookUserProfileDiv.appendChild(facebookUserProfileImg);
                    //add user name 
			    	var facebookUsernameSpan = document.createElement("span");
			    	facebookUsernameSpan.setAttribute('id',"WC_FacebookUserNameSpan");
			    	facebookUsernameSpan.setAttribute("class", "socialFacebookProfileName");
			    	facebookUsernameSpan.innerHTML = fbIntegrationJS.name;
			    	facebookUserProfileDiv.appendChild(facebookUsernameSpan);
		    	}
		        
				//parse widgets and show menu with drop down
				var showFacebookMenu = document.getElementById("header_menu_facebook_loaded");
				if(showFacebookMenu!=null && showFacebookMenu != undefined){
					parseWidget("header_menu_facebook_loaded");
					if (Utils.get_IE_version() >= 8){ // only IE8 and beyond
						showFacebookMenu.style.display = "inline";
					}
					else{
						showFacebookMenu.style.display = "inline-block";
					}
				}

				//Add FB user's profile and name OR just name ( may not want to have a photo )
				var menuDropDownWidget = $("#menu_DropDown_Facebook");
		        if (menuDropDownWidget) {
					//append Profile picture & name OR just name
		        	menuDropDownWidget.attr('label',( fbIntegrationJS.picture != "" ) ?  facebookUserProfileDiv.innerHTML : fbIntegrationJS.name);
		        }
			
		
				//adjust header z-index to allow disconnect from Facebook popup menu ( "dijitPopup" ) to overlay the padding area of menu
                var headerNode = $("#widget_masthead_links");
                if (headerNode){
                    headerNode.css("zIndex", "999");
                }
				//remove madison's "dijitButtonNode" class, if found, then add our Social class for menu
				if($("#menu_DropDown_Facebook").hasClass("dijitButtonNode")){
					$("#menu_DropDown_Facebook").removeClass("dijitButtonNode");
					if (Utils.get_IE_version()){
						//make adjustment to the node for IE browser
						if (get_IE_version >= 8){
			    			$("#menu_DropDown_Facebook").addClass("ie8_socialFacebookdijitButtonNodeAdjustment");
			    		}else
			    		   if (get_IE_version < 8 ){
			    			   $("#menu_DropDown_Facebook").addClass("ie_socialFacebookdijitButtonNodeAdjustment");
			    		   }
					}
				}

				//remove madison's "dijitA11yDownArrow" class, we want to show the down arrow
				$('> .dijitA11yDownArrow', 'menu_DropDown_Facebook').addClass("socialDropDownArrow");
				$('> .dijitA11yDownArrow', 'menu_DropDown_Facebook').removeClass("dijitA11yDownArrow");
				
				var arrowSpanNode = $('> .socialDropDownArrow', 'menu_DropDown_Facebook');
				arrowSpanNode.html("");
				var arrowImg=$("<img></img>");
				arrowImg.attr("id", "shopCartArrowImg" );
				arrowImg.attr("src", imageDirectoryPath + "images/colors/color1/widget_minishopcart/minishopcart_arrow.png" );
				arrowSpanNode.append(arrowImg);

				logoutFacebookButtonDiv.style.display="inline";
				//move Facebook menu with photo just before the search bar so that the FB profile picture does
				//not over lap searchbar; this adjustment is only needs
				//for DBCS - Simplified Chinese, Traditional Chinese, Korean and Japanese
				if ((facebookUserProfileDiv) && (FBlocaleQueryParm == 'zh_CN' ) || (FBlocaleQueryParm == 'zh_TW' ) || 
					(FBlocaleQueryParm == 'ja_JP' ) || (FBlocaleQueryParm == 'ko_KR' )) { 
					fbIntegrationJS._moveFacebookMenu($("#header_menu_facebook_loaded"),$("#header-search"));
				}
				this._setFacebookMenuWidth();//adjust FB mast header button if needed
			
			}
			
			if ( fbIntegrationJS.saveFacebookMenuFocuslink == null ){
				fbIntegrationJS._setFacebookMenuFocus();
			}
			
	        console.log("EXIT _displayFacebookMenu");

	    },

	    //For DBCS , move Facebook menu dropdown just before the search bar. This will allow 
	    //room for Facebook profile picture; otherwise if not moved, will be overlapped 
	    _moveFacebookMenu: function(facebookMenuNode, searchBarNode){

	        console.log("BEGIN _moveFacebookMenu");

			if((searchBarNode!=null && searchBarNode != undefined) && 
			  (facebookMenuNode!=null && facebookMenuNode != undefined)){
				//    
				// proceed to move FB menu to left of search bar, if need be
				//    

				      // use true to get the x/y relative to the document root
		        var facebookMenuCoords = facebookMenuNode.offset();
		        var searchBarNodeCoords = searchBarNode.offset();
      
		        //starting position plus width equals end position
		        var facebookMenuEndPostion = facebookMenuCoords.left + facebookMenuCoords.width();
		        if ( facebookMenuEndPostion > searchBarNodeCoords.left ){
		        	//move Facebook menu so it won't overlap with search  bar	
		        	var numOfPixelsToMove = facebookMenuEndPostion - searchBarNodeCoords.left;
			        //adjust dome node with margin to right ( forces menu to move left )
			       	console.log("_moveFacebookMenu - Adjusting facebook menu to move left by " + numOfPixelsToMove + "px");
		        	facebookMenuNode.css("marginRight", numOfPixelsToMove + "px");
		        }
			}
	       	console.log("END _moveFacebookMenu");
	    },
	    
	   
	    
	    //Open the dropdown for this widget - "dropDownButton"
	    openDropDown: function(){
	        //    
	    	// Gets called when mouse enters the "dropDownButton" widget
	        //    
			var menuDropDown =  $("#menu_DropDown_Facebook");
		    if (menuDropDown){
				menuDropDown.openDropDown();
		    }
	    },
	    
	    //Close the dropdown for this widget - "dropDownButton"
		closeDropDown: function(e){
	        //    
	    	// Gets called when mouse leaves the "dropDownButton" widget
	        // 
			var close = true;
	    	var event = e || window.event || arguments[0];	    	
	    	if(event) {
			    // FF does not get the event object.
		    	var node = event.toElement;
		    	while(node){
					if(node.id == "SocialIntegrationArea"){
					    // Do not close the dropdown if the mouse moves back to the "profile" area
						close = false;
						break;
					}
					node = node.parentNode;
				}
	    	}
	    	
	    	if(close) {
				this.menuItemHovered = false;   //no longer hovering over menu items
				setTimeout ( "fbIntegrationJS._closeDropDown()", 400 );
			}			
		},

	    //Close the dropdown if we are no longer hovered over the menu items
		_closeDropDown: function ( ){
			if (!this.menuItemHovered ){
				var menuDropDown =  $("#menu_DropDown_Facebook");
				if (menuDropDown){
					menuDropDown.closeDropDown(true); //close and set focus
				}
			}
		},

    	// Gets called when mouse hover's over menu item
		menuItemHover: function(item){
			this.menuItemHovered = true;
		},
		      
	    //set the Facebook Menu (main button on mast header)width to the same size as menu items
	    _setFacebookMenuWidth: function() { 

	        console.log("BEGIN _setFacebookMenuWidth");
			var headerMenu =  $("#header_menu_facebook_loaded");
            var menuDropdown =  $("#WC_CachedHeaderDisplayFacebook_div");
            if (headerMenu && menuDropdown && headerMenu.offsetWidth < menuDropdown.offsetWidth){
                var headerMenuDropdown =  $("#menu_DropDown_Facebook");
                if (headerMenuDropdown){
        	        //adjust and take into account the extra padding around this widget
                	headerMenuDropdown.style.width = Math.round(menuDropdown.offsetWidth) + "px"; 
                }
            }
	        console.log("EXIT _setFacebookMenuWidth");
	    },

	    //Load Social Integration CSS so all pages of Madison's store will have css classes
	    loadSocialCssFile : function(fileName) { 

	        console.log("BEGIN loadSocialCssFile");
	        if ( fileName == null){
	        	console.log("loadSocialCssFile - Social CSS file name is empty");
            	return;
            }
	        var cssNode=document.createElement("link")
	        cssNode.setAttribute("rel", "stylesheet")
	        cssNode.setAttribute("type", "text/css")
	        cssNode.setAttribute("href", fileName)
	        
	        if (typeof cssNode!=undefined){
	    	//add Social CSS file
	        	var headNodes = document.getElementsByTagName("head")[0]; 
	        	document.getElementsByTagName("head")[0].appendChild(cssNode)
	        	console.log("loadSocialCssFile - successfully loaded up CSS file: "+fileName);
	        }
	        console.log("EXIT loadSocialCssFile");

	    },

	    //is FB user currently connected to the Application 
	    isConnected : function() { 

	        console.log("BEGIN isConnected");
            console.log('isConnected.fbIntegrationJS.userStatus= '+fbIntegrationJS.userStatus);
	        console.log("EXIT isConnected");
			return fbIntegrationJS.userStatus;

	    },

	    //FB 3rd party user id that can be shared.
	    getThirdPartyId : function() { 

	        console.log("BEGIN getThirdPartyId");
            console.log('fbIntegrationJS.third_party_id= '+fbIntegrationJS.third_party_id);
			
	        console.log("EXIT getThirdPartyId");
			return fbIntegrationJS.third_party_id;;

	    },

	    //get user FB accessToke that was returned after a successful connect   
	    getAccessToken : function() { 

	        console.log("BEGIN getAccessToken");
            console.log('fbIntegrationJS.accessToken= '+fbIntegrationJS.accessToken);
			
	        console.log("EXIT getAccessToken");
			return fbIntegrationJS.accessToken;;

	    },

	    //user info - name, third_party_id, picture etc.
	    _onUserInfoLoaded : function(response) { 

	        console.log("BEGIN _onUserInfoLoaded");
			fbIntegrationJS.third_party_id  = response.third_party_id;
	        if (response.name != undefined ){
				fbIntegrationJS.name  = response.name;
	        }
	        else {
	        	fbIntegrationJS.name = '???';
	        }
	        if (response.picture != undefined ){
		        fbIntegrationJS.picture = response.picture;           
	        }
	        else {
	        	fbIntegrationJS.picture = "";
	        }
        	fbIntegrationJS._displayFacebookMenu();
	        wcTopic.publish("FacebookUserSignedIn",null);

	        console.log("EXIT _onUserInfoLoaded");

	    },

	    //Login / Connect user to facebook App.
	    onClickFacebookLogin : function() { 

	        console.log("BEGIN onClickFacebookLogin");
	        this.loginFacebookUser();                        

			/*
	        if ( fbIntegrationJS.saveFacebookMenuFocuslink == null ){
		        //setup connect, wait for Facebook user to get connected  and after the profile is showing, call _setFacebookMenuFocus to set focus
		        fbIntegrationJS.saveFacebookMenuFocuslink = dojo.connect(fbIntegrationJS, '_displayFacebookMenu', fbIntegrationJS, '_setFacebookMenuFocus');
	        }*/
	        console.log("EXIT onClickFacebookLogin");

	    },
	    
	    //set focus on facebook menu ( header ) that is showing the profile 
	    _setFacebookMenuFocus : function() { 

	        console.log("BEGIN _setFacebookMenuFocus");
	        //connected to facebook, set focus on the facebook profile menu item
			var menuDropDownWidget = $("#menu_DropDown_Facebook");
			if(menuDropDownWidget!=null && menuDropDownWidget != undefined){
				//dijit.focus(menuDropDownWidget.focusNode);
				menuDropDownWidget.focus();
				
			}
	        console.log("EXIT _setFacebookMenuFocus");

	    },

	    //Social Bridging has initiated a request to login
    	// login and update Social Integration menu status
	    dynamicSocialBridgingLoginRequest : function() { 

	        console.log("BEGIN dynamicSocialBridgingLoginRequest");
			
			//Social Bridging is requesting a login, update Social Integration menu status
			//Do FB.getLoginStatus ands "Force reloading the login status" using true Parameter.
			FB.getLoginStatus(function(response) {}, true);
			
	        console.log("EXIT dynamicSocialBridgingLoginRequest");

	    },

	    //Login FB user
	    loginFacebookUser : function() { 

	        console.log("BEGIN loginFacebookUser");
	        fbIntegrationJS.name  = "";
	        fbIntegrationJS.picture = "";           
        	fbIntegrationJS.userStatus = false;
        	fbIntegrationJS.accessToken = "";
	        //Login and connect user to Application 
            //Facebook will fire event for "auth.login", no need to a callback
      		//on the FB.login() - FB.login will fire event "auth.login", see FB_SubscribeEvents()
			FB.login(function(){},{scope:'publish_actions'});

	        console.log("EXIT loginFacebookUser");
	    },

	    //Logoff facebook user.
	    onClickFacebookLogout : function() { 

	        console.log("BEGIN onClickFacebookLogout");
	        //Logoff Facebook user and display connect facebook link
	        
			//clear object and update Master header
			fbIntegrationJS.userStatus = false;
		    fbIntegrationJS.accessToken = "";
			fbIntegrationJS.name  = "";
			fbIntegrationJS.picture = "";       
			fbIntegrationJS._updateFacebookPlugins();
			
	        //Pulish an event for features such as Social Commerce
	        wcPublic.publish("FacebookUserSignedOut",null);

	        //Call Facebook logout
	        FB.logout(); 
	        fbIntegrationJS._displayConnectFacebookLink();
	        
	        //no longer need linkage since user has disconnected
	        if (fbIntegrationJS.saveFacebookMenuFocuslink != null){
		        //dojo.disconnect(fbIntegrationJS.saveFacebookMenuFocuslink);
		        fbIntegrationJS.saveFacebookMenuFocuslink = null;
	        }

	        //set focus back on facebook menu since they just disconnected
			var headerFBlogin=document.getElementById("headerFBlogin");
			if(headerFBlogin !=null && headerFBlogin != undefined){
				headerFBlogin.focus();
			}

	        console.log("EXIT onClickFacebookLogout");

	    },

		// notify marketing runtime about the Like/UnLike Facebook event
		_triggerHandler : function(refAttrValue, mktObj) {
	        	console.log("BEGIN - _triggerHandler " + mktObj["type"] +" event with refAttrValue of " + refAttrValue);
	    		// set the appropriate key/value pairs to send to marketing engine
	        	if (refAttrValue != null) {
	        		// we will need to append the type of Like to this later 
        			var type = mktObj["type"];
	        		if (refAttrValue == "homepage") {
	        			// homepage Like events do not have any filters, so no additional info required
	        			mktObj["type"] = type+"Homepage";
	        		} else {
	        			// product Like events may have one or more filters, we need to pass this info to the marketing runtime
	        			// format of the ref value in this case would be "categoryId+catEntryId+partNumber+manufacturerName"
	        			// notes: (1) max value for the ref attribute is 50 characters
	        			//        (2) manufacturerName may not be set on a catalog entry
	        			//        (3) a space in the original value was converted to a period, we now need to do the reverse
	        			mktObj["type"] = type+"Product";
        				// if necessary, change the periods back to spaces
        				var realRefValue = refAttrValue.replace(/\./g,' ');
        				console.log("realRefValue -> " + realRefValue);
	        			var filterValues = realRefValue.split("+");
        				//console.log("filterValues.length -> " + filterValues.length);
        				var filterKeys = ["categoryId", "catEntryId", "partNumber", "manufacturerName"];

        				//If categoryId value does not exist, change the keys from "catEntryId" to "productId"
        				if (filterValues[0] == "" || filterValues[0] == null) {
        					filterKeys[1] = "productId";
        				}
        				
	        			for ( var i = 0; i < filterValues.length; i++ ) {
	        				//console.log("i -> " + i);
	        				var value = filterValues[i];
	        				//console.log("value -> "+ value);
	        				if (value != null) {
	        					mktObj[filterKeys[i]] = value;
	        				}
	        			}
	        		}
	        	} else {
	        		// the ref attribute value is missing
	        		console.warn("Missing the ref attribute.");
	        	}

	        	var url = "AjaxRESTMarketingTriggerProcessServiceEvaluate?DM_ReqCmd=SocialCommerceInteraction";	

	        	// encode request params
	        	for(prop in mktObj){		    
	        		url = url.concat("&", prop, "=", encodeURIComponent(mktObj[prop]));	
	        	}
				
	        	$.post({
	        		url: url,
	        		dataType: 'text',
					success: null,
	        		error: function(resp, ioArgs) {
						console.error("Precision Marketing request failed.");
					}
	        	});

	        	console.log("END - _triggerHandler");
		},

	    //setup Facebook environment right away; div tag and javascript library
	    setupFBEnv : (function() { //run this setup as soon as possible
	        
	    	console.log("BEGIN setupFBEnv");
	        /*the default locale for facebook library */
	        var defaultLocale = "en_US"; //globally defined, default to en_US
	    	var defaultAppId = "0000000000000"; //globally defined, default appId for facebook

	    	//add in Facebook SDK javascript
	        var e = document.createElement('script');
	        e.type = 'text/javascript';

		    //get the locale that's passed in on the query parm. If no query parm, use default ocale 
	        FBlocaleQueryParm = defaultLocale;//set default locale;
	        FBappIdQueryParm = defaultAppId; //set default
 	        var scripts = document.getElementsByTagName('script');
	        var FBintegrationScript = scripts[ scripts.length - 1 ];//this script is ours, last one loaded

	        //get the query param for locale setting; needed for facebook SDK plugin
	        var queryString = FBintegrationScript.src.replace(/^[^\?]+\??/,'');
	        if (!queryString) {
    	    	 console.log("setupFBEnv - No locale specified, default to: " + defaultLocale);
    	    	 console.log("setupFBEnv - appId specified, default to: " + defaultAppId);
	        }else{
	        	var pairs = queryString.split(/[;&]/);
    			//extract query parms
 	        	for ( var i = 0; i < pairs.length; i++ ) {
	        		var keyValue = pairs[i].split('=');
	        		//make sure there's a "key" and "value" 
	        		if ( keyValue && keyValue.length == 2 && keyValue[0] == 'locale') { 
	        			//get locale value	
	        			// ar_EG and iw_IL not supported by Facebook.  Use ar_AR and he_IL instead.
	        			var fblocaleOverrideMapping = {'ar_EG' : 'ar_AR', 'iw_IL' : 'he_IL'};
	        			var fblocale = unescape(keyValue[1]);
        				FBlocaleQueryParm = fblocaleOverrideMapping.hasOwnProperty(fblocale) ? fblocaleOverrideMapping[fblocale] : fblocale;
	       	    	 	console.log("setupFBEnv - locale to use for facebook: " + FBlocaleQueryParm);
	        			continue; //get next entry
	        		}else if ( keyValue && keyValue.length == 2 && keyValue[0] == 'appId') { 
	        			//get appID value
	        			FBappIdQueryParm = unescape( keyValue[1] );
	       	    	 	console.log("setupFBEnv - appId to connect and authorize is: " + FBappIdQueryParm);
	        			continue;//get next entry
              	  	}
 	        	}
	        }
	        // Need to be secured(https) because Facebook users can specify secure(account->security->secure browsing)
	        e.src = 'https://connect.facebook.net/'+FBlocaleQueryParm+'/all.js';
   	 	    console.log("Initializing Facebook with Language and AppID = " + e.src);
	        e.async = true;
	                
	        //Facebook requires this div tag in Body
			$(document).ready(function() {
				var fbDiv = document.createElement('div');
				fbDiv.setAttribute('id', 'fb-root');
				document.body.appendChild(fbDiv);
				fbDiv.appendChild(e);
			});
			
	        console.log("EXIT setupFBEnv");

	    }())

	}
};
//Facebook recommends to wait for this event to occur before FB gets initialized with appId
window.fbAsyncInit = function() {

	fbIntegrationJS.FBinit_Callback(FBappIdQueryParm);//initialize Facebook SDK
    
};
