
/*
 *-------------------------------------------------------------------
 * IBM Confidential
 * OCO Source Materials
 *
 * WebSphere Commerce   
 *
 * (c) Copyright International Business Machines Corporation. yyyy, 2005
 *     All rights reserved.
 *
 * The source code for this program is not published or otherwise
 * divested of its trade secrets, irrespective of what has been
 * deposited with the US Copyright Office.
 *-------------------------------------------------------------------
*/
  
  function sPreviewFn(){
        // building the URL

          var url = 'CMWSPreviewSetup?';
          var params = ''; 
          var pathInfo = '';
          var start = '';
		  var redirectvalue ='';	          

		  //addURLParameter("redirectstoreurl", "http://vdev/webapp/wcs/stores/servlet/wcsstore/store202/index.jsp"); 
		  redirecturl = "http://"+ top.location.hostname+top.trim(self.CONTENTS.previewForm.redirecturl.value);
		  if (top.trim(self.CONTENTS.previewForm.redirecturl.value) == '') {
		   var message = self.CONTENTS.getstoreURLNotSpecifiedMessage();
			   self.CONTENTS.alertDialog(message);
			   self.CONTENTS.previewForm.redirecturl.focus();
               return false;		  
		  }		  

		  if ((redirecturl.indexOf("http://") != 0) && (redirecturl.indexOf("https://") != 0)) {
		   var message = self.CONTENTS.getIncorrectStoreUrlMsg();
			   self.CONTENTS.alertDialog(message);
			   self.CONTENTS.previewForm.redirecturl.focus();
               return false;		  
		  }		  
	
		  for (i = 0; i <= redirecturl.length; i++)
		  {
			if (redirecturl.charAt(i) == '&' )	{
				redirectvalue += '~~amp~~';
			}
			else {
				redirectvalue += redirecturl.charAt(i);
			}
		  }			  

		  redirectstoreurl = '&redirectstoreurl='+ redirectvalue + "~~amp~~" + self.CONTENTS.getNewPreviewSessionParameter() + "=true";
		  
		  //setup date and time
		 
		  var year = '';
		  var month = '';		  
		  var day = '';		  
		  var time = '';
		  
		  if (self.CONTENTS.previewForm.timeoption[0].checked){
		  //then use current date and time
		 
		  year = String (getCurrentYear()); 
		  month = String (getCurrentMonth());		  
		  day = String (getCurrentDay());	
		  
		  var currenttime=new Date();

	var hours = currenttime.getHours();
	var minutes = currenttime.getMinutes();
	time = "" + hours; 
    time = ((time <10)? "0":"") + time;
    time += ((minutes < 10) ? ":0" : ":") + minutes;
		  }
		  else {
		  //use the date and time specified
		  year = self.CONTENTS.previewForm.startYear.value;
		  month = self.CONTENTS.previewForm.startMonth.value;		  
		  day = self.CONTENTS.previewForm.startDay.value;		  
		  time = self.CONTENTS.previewForm.startTime.value;
		  }
		//end setup for date and time

		  var wrkspcname = self.CONTENTS.previewForm.workspace.value;
		  var taskgrp = self.CONTENTS.previewForm.taskgrp.value;		  		  		  
		  var task = self.CONTENTS.previewForm.task.value;		  
		  var context = '';
		  
//		  if (wrkspcname != null) {
//		  		context = "&workspace="+wrkspcname;
//		  		if (taskgrp !=null){
//		  			context = context + "&taskgroup="+taskgrp;
//		  		} 
//		  		if (task != null) {
//		  			context = context + "&task=" + task;		
//		  		}		  		
//		  }		
   		  context = "&workspace="+wrkspcname;
 		  context = context + "&taskgroup="+taskgrp;		  	
		  context = context + "&task=" + task;				
 
		  var status = '';
		  var invstatus = '';


//		  if(self.CONTENTS.previewForm.status.checked){
//		  	status= "&status="+true;
//		  } else {
//		  	status = "&status="+false;
//		  }
		  
		  var statusval = false;

		  for (var i=0; i < self.CONTENTS.previewForm.status.length; i++)
		  {
			   if (self.CONTENTS.previewForm.status[i].checked)
      			   {
			      statusval = self.CONTENTS.previewForm.status[i].value;
      			   }
   		  }
	  
	
		  status = "&status=" + statusval;

//		  if(self.CONTENTS.previewForm.invstatus.checked){
//		  	invstatus= "&invstatus="+true;
//		  } else {
//		  	invstatus = "&invstatus="+self.CONTENTS.previewForm.invstatus.value;
//		  }
	  
	  	  invstatus = "&invstatus="+self.CONTENTS.previewForm.invstatus.value;

		  if ((time != '') && ((day == '') || (month == '') || (year ==''))) {
			   var message = self.CONTENTS.timeMessage();
			   self.CONTENTS.alertDialog(message);
			   self.CONTENTS.previewForm.startYear.focus();
               return false;
          }
		  
          if (((!(wc_validateDate(year,month,day))) && ((day != '') || (month != '') || (year !=''))) || ((time != '') && (!(wc_validateTime(time)))))  {
// Validate the others
	   var message = self.CONTENTS.timeMessage();
	  
			   self.CONTENTS.alertDialog(message);
			   self.CONTENTS.previewForm.startYear.focus();			   
               return false;
          } else if ((day != '') && (month != '') && (year !='')){
		 	    if (time == '') {
		 	    	time='0:00';
		 	    }		 	    
		 	    start = year + "/" + month + "/" + day + " " + time + ":00";
               	start = '&start=' + start;		 	    
          }          


			var webapp = self.CONTENTS.getToolsWebPath();
				
			redirecturl = "redirecturl=" + "tools/preview/" + "PreviewRedirect.jsp";
			loc = "CMWSPreviewSetup?";
			loc += redirecturl;
			loc += redirectstoreurl;			
			loc += start;
			loc += status;
			loc += invstatus;
			if (context != '') {
				loc += context;
			}	
			
			top.openChildWindow(loc,"Preview_Window", 'left=0,top=0,width=1014,height=710,scrollbars=no,toolbar=no,directories=no,status=no,menubar=no,copyhistory=no,resizable=yes');		  
  }
