//-----------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (C) Copyright IBM Corp. 2011, 2013 All Rights Reserved.
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with
// IBM Corp.
//-----------------------------------------------------------------

if(typeof(ResponsiveJS) == "undefined" || ResponsiveJS == null || !ResponsiveJS){

	ResponsiveJS = { 	
			
	
	
	init: function(){
		$("#footerCustomerService").on("click", $.proxy(ResponsiveJS._cSToggleAndShow, ResponsiveJS));
		$("#footerCorporateInfo").on("click", $.proxy(ResponsiveJS._cIToggleAndShow, ResponsiveJS));
		$("#footerExplore").on("click", $.proxy(ResponsiveJS._eToggleAndShow, ResponsiveJS));
		$("#footerFollowUs").on("click", $.proxy(ResponsiveJS._FUToggleAndShow, ResponsiveJS));
		
	},
		
	_cSToggleAndShow:function(evt){			
		this.toggle($("#cSTog"));
		this.show($("#expandCS"));
	},
	
	_cIToggleAndShow:function(evt){			
		this.toggle($("#cITog"));
		this.show($("#expandCI"));
	},
	
	_eToggleAndShow:function(evt){			
		this.toggle($("#eTog"));
		this.show($("#expandE"));
	},
	
	_FUToggleAndShow:function(evt){			
		this.toggle($("#fUTog"));
		this.show($("#expandFU"));
	},
	
	toggle:function(node){			 
		var srcElement = node;
		if(srcElement != null) {
		      if(srcElement.style.backgroundPosition== '-161px -1px') {
		        srcElement.style.backgroundPosition= '-181px -1px';
		        srcElement.style.width='12px';
		        srcElement.style.height='6px';
		        srcElement.style.left='6px';
		        srcElement.style.top='14px';
		      }
		      else {
		        srcElement.style.backgroundPosition= '-161px -1px';
		        srcElement.style.width='6px';
		        srcElement.style.height='12px';
		        srcElement.style.left='10px';
		        srcElement.style.top='10px';
		  }
		}
	},
	
	show:function(node){
		srcElement = node;
	    if(srcElement != null) {
	      if(srcElement.style.display == "block") {
	        close('searchDropdown');
	        srcElement.style.display= 'none';
	      }
	      else {	    	  
	    	$(".subDeptDropdown ").each(function(i,node){
	    		close(node.id);
		    });
		    close("departmentsDropdown");	
	        close('qLinkDropdown');	        
	        close('mobileSearchDropdown');
	        close('searchDropdown');
	        close('pageDropdown');	        
	        close('sortDropdown');
	        srcElement.style.display='block';
	      }	      
	    }
	}
	
		
 };
}
