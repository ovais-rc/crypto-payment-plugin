//
//-------------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (c) Copyright IBM Corp. 2006
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//-------------------------------------------------------------------
//

// @deprecated The Product Advisor feature has been deprecated. For more information, see <a href="../../../../../../com.ibm.commerce.productadvisor.doc/concepts/cpaintro.htm">Product Advisor</a>.

function sPEPreviewFn(){
	if(!self.CONTENTS.isPEMetaphorAvailable()){
		return;	
	}
	var fix = self.CONTENTS.getURLFix();
//	var url = "PEPreviewView?";
//	url = url+''+fix;
	var date= new Date();
	var time = date.getTime();
	var title = "productExplorer" + time;
//changed for defect 48051 - Preview fix start
	var hostname = window.location.hostname;
	var url = "http://"+hostname+"/webapp/wcs/stores/servlet/pe51.jsp?";
	url = url+fix;
	var changed = self.CONTENTS.prompt(url);
	if(changed != null && changed.length != 0 ){
      	window.open(changed,title, "resizable=yes,scrollbars=yes,status=no,width=800,height=600");
	}
////changed for defect 48051 - Preview fix end	
     //window.open(url,title , "resizable=yes,scrollbars=yes,status=no,width=800,height=600");
}

function sPCPreviewFn(){
	if(!self.CONTENTS.isPCMetaphorAvailable()){
		return;	
	}
	var fix = self.CONTENTS.getURLFix();
//	var url = "PCPreviewView?";
//	url = url+''+fix;
	var date= new Date();
	var time = date.getTime();
	var title = "productComparer" + time;
//changed for defect 48051 - Preview fix start
	var hostname = window.location.hostname;
	var url = "http://"+hostname+"/webapp/wcs/stores/servlet/pc51.jsp?";
	url = url+fix;
	var changed = self.CONTENTS.prompt(url);
	if(changed != null && changed.length != 0 ){
      	window.open(changed,title, "resizable=yes,scrollbars=yes,status=no,width=800,height=600");
	}
//changed for defect 48051 - Preview fix ends	
    //window.open(url, title, "resizable=yes,scrollbars=yes,status=no,width=800,height=600");
}

function performPrint(){
	self.CONTENTS.window.focus();
	self.CONTENTS.window.print();	
}

function performOK(){
	top.remove("categoryName");
	top.goBack();
}
