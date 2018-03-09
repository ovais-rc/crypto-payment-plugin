//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2000, 2002
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
//*

   function submitCancelHandler()
   {
     top.goBack();
	
   }
function formatTime(tm){
       var hr, mn, ftime;
       var splitTimeArray = tm.split(":");
       if ( splitTimeArray[0] < 10 && splitTimeArray[0].charAt(0) != "0" )
              hr = "0" + splitTimeArray[0];
       else
              hr = splitTimeArray[0];
              
       if ( splitTimeArray[1] < 10 && splitTimeArray[1].charAt(0) != "0" )
              mn = "0" + splitTimeArray[1];
       else
              mn = splitTimeArray[1];
              
       var ftime = "" + hr + ":" + mn + ":00";
       return ftime;
}



   function preSubmitHandler()
   {
     //alert("Inside the preSubmitHandler()");
     	var name        = window.CONTENTS.document.rfqsearchform.name.value;
     	var state        = window.CONTENTS.document.rfqsearchform.state.value;
     	var createday="";
     	var activeday="";
	var casesensitive = window.CONTENTS.document.rfqsearchform.casesensitive.checked;
     	if((window.CONTENTS.document.rfqsearchform.byear.value!="") && (window.CONTENTS.document.rfqsearchform.bmonth.value!="") &&(window.CONTENTS.document.rfqsearchform.bday.value!=""))
	       	createday = window.CONTENTS.document.rfqsearchform.byear.value+"-"+window.CONTENTS.document.rfqsearchform.bmonth.value+"-"+window.CONTENTS.document.rfqsearchform.bday.value+" "+formatTime(window.CONTENTS.document.rfqsearchform.btime.value);
	       	
     	if(window.CONTENTS.document.rfqsearchform.ayear.value!="" &&   	   window.CONTENTS.document.rfqsearchform.amonth.value!="" &&    	   window.CONTENTS.document.rfqsearchform.aday.value!="" )     	      
	       	activeday = window.CONTENTS.document.rfqsearchform.ayear.value+"-"+window.CONTENTS.document.rfqsearchform.amonth.value+"-"+window.CONTENTS.document.rfqsearchform.aday.value+" "+formatTime(window.CONTENTS.document.rfqsearchform.atime.value);       
      
        //aURL="/webapp/wcs/tools/servlet/NewDynamicListView?ActionXMLFile=rfq.rfqrequestlist&amp;cmd=RFQRequestList"+"&amp;name="+name+"&state="+state+"&amp;createday="+createday+"&amp;activeday="+activeday+"&amp;forfind=yes";
        aURL="/webapp/wcs/tools/servlet/NewDynamicListView";
        urlPara = new Object();
	urlPara.ActionXMLFile='rfq.rfqrequestlist';
	urlPara.cmd='RFQRequestList';
	urlPara.name= name;
	urlPara.state = state;
	urlPara.createday=createday;
	urlPara.activeday=activeday;
	urlPara.forfind='yes';
	urlPara.casesensitive = casesensitive;
        
	top.setContent(window.CONTENTS.getResultBCT(),aURL,false,urlPara);  
   }
