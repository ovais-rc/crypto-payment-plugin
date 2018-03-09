<!-- 
========================================================================
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2000, 2002, 2003
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
========================================================================
--> 
  
<%@ page import="com.ibm.commerce.command.*" %>
<%@ page import="com.ibm.commerce.rfq.beans.*" %>
<%@ page import="com.ibm.commerce.rfq.objects.*" %>
<%@ page import="com.ibm.commerce.rfq.utils.*" %>
<%@ page import="com.ibm.commerce.tools.util.UIUtil" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.tools.common.ui.taglibs.*" %>
<%@ page import="com.ibm.commerce.server.ECConstants" %>
<%@ page import="com.ibm.commerce.utf.utils.*" %>

<%@ include file="../common/common.jsp" %>
<%@ include file="../common/List.jsp" %>
	
<%
    Locale aLocale = null;  
    Integer langId = null;
    boolean wrap = true;
    CommandContext aCommandContext = (CommandContext)request.getAttribute(ECConstants.EC_COMMANDCONTEXT); 
    
    String ErrorMessage = request.getParameter(com.ibm.commerce.tools.common.ui.UIProperties.SUBMIT_ERROR_MESSAGE);
    if (ErrorMessage != null) 
    { 
		ErrorMessage = "";
    }

    if( aCommandContext!= null ) 
    {
        aLocale = aCommandContext.getLocale();
        langId = aCommandContext.getLanguageId();
    }

    //no wrapping for the asian languages
    if(langId.intValue() <= -7 && langId.intValue() >= -10) 
    { 
    	wrap = false; 
    }  
      
    // obtain the resource bundle for display
    Hashtable rfqNLS = (Hashtable)ResourceDirectory.lookup("rfq.rfqNLS",aLocale); 
    JSPHelper jsphelper = new JSPHelper(request);     
    String rfqResponseId = jsphelper.getParameter("offerId" ); 
       
    RFQResponseDataBean	RFQres = new RFQResponseDataBean();
    RFQres.setInitKey_rfqResponseId(Long.valueOf(rfqResponseId));
    String rfqRequestId =RFQres.getRfqId(); 
    
    String requestCatalogId = requestCatalogId = RFQProductHelper.getCatalogIdFromXmlFragment(new Long(rfqRequestId));

    int startIndex = Integer.parseInt(jspHelper.getParameter("startindex"));
    int listSize = Integer.parseInt(jspHelper.getParameter("listsize"));
    int endIndex = startIndex + listSize;
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<link rel="stylesheet" href="<%= UIUtil.getCSSFile(aLocale)%>" type="text/css" /> 
<title></title>
<script type="text/javascript" src="/wcs/javascript/tools/common/dynamiclist.js"></script>
<script type="text/javascript" src="/wcs/javascript/tools/rfq/rfqUtile.js"></script>
<script type="text/javascript" src="/wcs/javascript/tools/rfq/rfq_skippage.js"></script>

<script type="text/javascript">
    var isFirstTimeLogonPanel4;
    isFirstTimeLogonPanel4=top.getData("isFirstTimeLogonPanel4");
    if (isFirstTimeLogonPanel4 != "0") 
    {
    	isFirstTimeLogonPanel4="1";  //"1" means first time logon Panel4.
    	top.saveData("0","isFirstTimeLogonPanel4");
    } 

    var CatalogPPArray = new Array();
    setCatalogPPData();

    listSize = <%= listSize %>;
    startIndex = <%= startIndex %>;
    endIndex   = <%= endIndex %>;
    if ((CatalogPPArray!=null )&&(CatalogPPArray.length>0)) 
    {
	if (endIndex > CatalogPPArray.length) 
	{
	    endIndex = CatalogPPArray.length;
	}
    }	
    if (startIndex < 0) 
    {
	startIndex=0;
    }
    if (CatalogPPArray==null||CatalogPPArray.length<1) 
    {
	endIndex = 0;
	parent.set_t_item(0);
	parent.set_t_page(1);
    } else {
	numpage  = Math.ceil(CatalogPPArray.length/listSize);
	parent.set_t_item(CatalogPPArray.length);
	parent.set_t_page(numpage);
    }
        
    function setCatalogPPData() 
    {
	if (isFirstTimeLogonPanel4 == "0") 
	{
	    //NOT first time log on panel4
	     CatalogPPArray = top.getData("allCatalogPP");
	} else {
<%		
	    String categoryIDreferenceNumberAttr = null;
    	    String percentagePriceAttr = "";
    	    String categoryName = "";				
    	    String categoryDesc = "";
    	    String requestSynchronize = "";
    	    String ppResposeAdjust = "";
    	    String responseSynchronize = "";
    	    String tcId = "";	
    	    String resTcId = "";	
    	    String synchronizeAttr = "";
    	    String hasResponse = "";
    	     
	    RFQResPriceAdjustmentOnCategory[] rfqReqPaArray = RFQResProdHelper.getResAllPriceAdjustmentOnCategory(rfqResponseId, langId.toString());
	    if ( rfqReqPaArray != null && rfqReqPaArray.length !=0 ) 
	    {		
		java.text.NumberFormat numberFormatter = java.text.NumberFormat.getNumberInstance(aLocale);
		for (int i = 0; i<rfqReqPaArray.length; i++) 
		{			
		    RFQResPriceAdjustmentOnCategory rfqReqPaObj = new RFQResPriceAdjustmentOnCategory();				
		    rfqReqPaObj = rfqReqPaArray[i];
		    if (rfqReqPaObj.getReqTcId() != null)
		    {			
		        tcId = rfqReqPaObj.getReqTcId().toString();
		    }
		    if (rfqReqPaObj.getResTcId() != null)
		    {			
		        resTcId = rfqReqPaObj.getResTcId().toString();
		    }
		    categoryIDreferenceNumberAttr = rfqReqPaObj.getCategoryId().toString();
		    categoryName = rfqReqPaObj.getCategoryName();
		    categoryDesc = rfqReqPaObj.getCategoryDescription();	
		    percentagePriceAttr = rfqReqPaObj.getReqPriceAdjustment();
		    if (percentagePriceAttr != null && percentagePriceAttr.length() != 0 )
		    {
			Double ptemp = Double.valueOf(percentagePriceAttr);
            		if (ptemp != null && ptemp.doubleValue() <= 0) 
            		{
          		    percentagePriceAttr = numberFormatter.format(ptemp);
			}		
		    }
		    requestSynchronize = rfqReqPaObj.getReqSynchronize();	    
		    ppResposeAdjust = rfqReqPaObj.getResPriceAdjustment();
		    String ppResposeAdjust_ds = "";
		    if (ppResposeAdjust != null && ppResposeAdjust.length() != 0 )
		    {
			Double ptemp = Double.valueOf(ppResposeAdjust);
            		if (ptemp != null && ptemp.doubleValue() <= 0) 
            		{
          		    ppResposeAdjust_ds = numberFormatter.format(ptemp);
			}		
		    }
		    responseSynchronize = rfqReqPaObj.getResSynchronize();
		    hasResponse = rfqReqPaObj.getHasResponse();							
%>
		    CatalogPPArray[<%= i %>] = new Object();		    
		    CatalogPPArray[<%= i %>].<%= RFQConstants.EC_OFFERING_CATALOGID %>="<%= requestCatalogId %>";					
		    CatalogPPArray[<%= i %>].<%= RFQConstants.EC_OFFERING_CATEGORYID %>="<%= categoryIDreferenceNumberAttr %>";
		    CatalogPPArray[<%= i %>].<%= RFQConstants.EC_OFFERING_CATEGORYNAME %>="<%= categoryName %>";
		    CatalogPPArray[<%= i %>].<%= RFQConstants.EC_OFFERING_CATEGORYDESCRIPTION %>="<%= categoryDesc %>";
		    CatalogPPArray[<%= i %>].<%= RFQConstants.EC_REQUEST_TC_ID %>="<%= tcId %>";
		    CatalogPPArray[<%= i %>].<%= RFQConstants.EC_RFQ_OFFERING_PRICEADJUSTMENT %>="<%= percentagePriceAttr %>";
		    CatalogPPArray[<%= i %>].<%= RFQConstants.EC_RFQ_OFFERING_SYNCHRONIZE %>="<%= requestSynchronize %>"; 			
		    CatalogPPArray[<%= i %>].<%= RFQConstants.EC_RESPONSE_TC_ID %>="<%= resTcId %>";
		    CatalogPPArray[<%= i %>].<%= RFQConstants.EC_OFFERING_PRICEADJUSTMENT %>="<%= ppResposeAdjust %>";
		    CatalogPPArray[<%= i %>].res_priceAdjustment="<%= ppResposeAdjust_ds %>";
		    CatalogPPArray[<%= i %>].<%= RFQConstants.EC_OFFERING_SYNCHRONIZE %>="<%= responseSynchronize %>"; 
		    CatalogPPArray[<%= i %>].<%= RFQConstants.EC_OFFERING_RESPOND_TO_CATEGORY %> ="<%= hasResponse %>";				
<%		
		}	
	    }
%>	
   	    top.saveData(CatalogPPArray, "allCatalogPP");
	}
    }
    
    function initializeState() 
    {   
        skipPages(parent.parent.pageArray);
        parent.parent.reloadFrames();
    	parent.parent.setContentFrameLoaded(true);
    } 
 
    function myRefreshButtons() 
    {   
	parent.setChecked();	
	var aList=new Array();
	aList = parent.getChecked();
	if (aList.length == 0) 
	{
	    return;
	}

        var tmpArray= new Array();
        tmpArray=aList[0].split(',');
        var hasResponse = false;
        if (tmpArray[1] == 1) 
	{
            hasResponse = true;
        }
        if (parent.buttons.buttonForm.deleteResponseButton && !hasResponse)
	{
            parent.buttons.buttonForm.deleteResponseButton.className='disabled';
            parent.buttons.buttonForm.deleteResponseButton.disabled=true;
            parent.buttons.buttonForm.deleteResponseButton.id='disabled';
        } 	
        return;				
    }

    function selectDeselectAll()
    {
        for (var i=0; i<document.rfqCatAdjustModifyListForm.elements.length; i++)
        {
            var e = document.rfqCatAdjustModifyListForm.elements[i];
            if (e.name != 'select_deselect')
            {
                e.checked = document.rfqCatAdjustModifyListForm.select_deselect.checked;
            }
        }
        myRefreshButtons();
    }

    function setSelectDeselectFalse()
    {
        document.rfqCatAdjustModifyListForm.select_deselect.checked = false;
    }
        
    function isButtonDisabled(b) 
    {
	if (b.className =='disabled') 
	{
		return true;
	}    
	return false;
    } 
    
    function getCatalogPPByID(catalogppID) 
    {
  	var aCatalogPP = new Object();
  	for (var i=0; i<CatalogPPArray.length; i++) 
  	{
	    if(CatalogPPArray[i].<%= RFQConstants.EC_OFFERING_CATEGORYID %> == catalogppID) 
	    {
      		aCatalogPP = CatalogPPArray[i];
      		break;
	    }
  	}
  	return aCatalogPP;
    }
    
    function getACatalogPP() 
    { 
      	var aCatalogPP = new Object();
      	var catalogtppID;
      	var t = new Array();
      	t = parent.getChecked();
      	if (t.length > 0) 
      	{
    	    catalogppID = t[0].split(',')[0];
    	    aCatalogPP = getCatalogPPByID(catalogppID);  
      	}
      	return aCatalogPP;
    }
    
    function getNewBCT() 
    {
    	return "<%= UIUtil.toJavaScript(rfqNLS.get("rfqresponse")) %>";
    }
    
    function savePanelData() 
    { 
    	parent.parent.put("<%= RFQConstants.EC_RFQ_CATEGORY_PRICE_ADJUST_ITEM %>", CatalogPPArray );
    	return true;
    }
    
    function validatePanelData() 
    {
    	return true;
    }
    
    function saveData() 
    {
    	var aCatalogPP = new Object;
    	aCatalogPP = getACatalogPP();
    	top.saveData(aCatalogPP, "aCatalogPP");
    	top.saveData(CatalogPPArray, "allCatalogPP");
    	top.saveModel(parent.parent.model);
    }

    function retrievePanelData() 
    {
	if (top.getData("aCatalogPP") != undefined && top.getData("aCatalogPP") != null) 
	{
	    parent.parent.model=top.getModel();
	}
    }
       
    function ChangeCatPriceAdjust() 
    {
    	var aCatalogPP = new Object;
    	aCatalogPP = getACatalogPP();	
    	top.saveData(aCatalogPP, "aCatalogPP");
    	top.saveData(CatalogPPArray, "allCatalogPP");
    	top.saveModel(parent.parent.model);
    	var rfqId = '<%= rfqRequestId %>';
    	var url = "/webapp/wcs/tools/servlet/DialogView?XMLFile=rfq.rfqResponseCategoryPriceAdjustRespond&amp;requestId=" + rfqId;
    	if (top.setReturningPanel) 
    	{
    	    top.setReturningPanel("rfqadjustoncategories");
    	} 	
    	if (top.setContent) 
    	{
    	    top.setContent(getNewBCT(),url,true);
    	} else {
    	    parent.parent.location.replace(url);
    	}	 
    } 
    
    function deleteEntry() 
    {
        if (isButtonDisabled(parent.buttons.buttonForm.deleteResponseButton))
        {
            return;
       	}
    
        var aList = parent.getChecked();
        for (var i=0; i<CatalogPPArray.length; i++)
        {
            for (var j=0; j<aList.length; j++)
            {
                catalogppID = aList[j].split(',')[0];
                if (CatalogPPArray[i].<%=RFQConstants.EC_OFFERING_CATEGORYID%> == catalogppID)
                {
		    CatalogPPArray[i].<%= RFQConstants.EC_OFFERING_RESPOND_TO_CATEGORY %> = "<%= RFQConstants.EC_RFQ_RESPOND_TO_CATEGORY_NO %>";
		    CatalogPPArray[i].<%= RFQConstants.EC_OFFERING_PRICEADJUSTMENT %> = "";
		    CatalogPPArray[i].res_priceAdjustment = "";
		    CatalogPPArray[i].<%= RFQConstants.EC_OFFERING_SYNCHRONIZE %> = "";                     
                    parent.removeEntry(aList[j]);
                    break;
                }
            }
        }
        top.saveData(CatalogPPArray, "allCatalogPP");
        top.saveModel(parent.parent.model);
        parent.document.forms[0].submit();
    }
    
    function categorySummary(categoryId) 
    {
	var checkedCatalogId;
        if (categoryId == null || categoryId == "" || categoryId == undefined)
        {  	
  	    var aList = new Array();
  	    aList = parent.getChecked();
	    checkedCatalogId = aList[0].split(',')[0];
  	}
  	else
  	{
  	    checkedCatalogId = categoryId;
        }
            	
    	var url = '/webapp/wcs/tools/servlet/DialogView?XMLFile=rfq.rfqAdjustmentCategorySummary&amp;categoryId='+checkedCatalogId+'&amp;rfqId=<%= rfqRequestId %>';	
    	if (top.setReturningPanel) 
    	{
    	    top.setReturningPanel("rfqadjustoncategories");
    	} 
    	if (top.setContent) 
    	{
    	    top.setContent(getCategorySummaryBCT(), url, true);
    	} else {
    	    parent.parent.location.replace(url);
    	} 
    }
    
    function getCategorySummaryBCT() 
    {
      	return "<%= UIUtil.toJavaScript(rfqNLS.get("rfq_bct_CategorySumm")) %>";
    }
    
    function onLoad() 
    {
    	parent.loadFrames();
    }
</script>
</head>

<body class="content" onload="initializeState()">

<%= rfqNLS.get("instruction_Categories_PercentagePrice_modify") %>

<form name="rfqCatAdjustModifyListForm" method="get" id="RFQCatAdjustModifyListForm" action="">

<%= comm.startDlistTable((String)rfqNLS.get("rfqpercentagepricing")) %>
<%= comm.startDlistRowHeading() %>
<%= comm.addDlistCheckHeading(true,"selectDeselectAll()") %>
<%= comm.addDlistColumnHeading((String)rfqNLS.get("rfqrequestcategoryname"),"null",false,"20%",wrap ) %>
<%= comm.addDlistColumnHeading((String)rfqNLS.get("rfqcategorydescription"),"null",false,"20%",wrap ) %>
<%= comm.addDlistColumnHeading((String)rfqNLS.get("rfqrequestpriceadjustment"),"null",false,"15%",wrap ) %>
<%= comm.addDlistColumnHeading((String)rfqNLS.get("rfqrequestcatalogsynchronized"),"null",false,"15%",wrap ) %> 
<%= comm.addDlistColumnHeading((String)rfqNLS.get("rfqresponsepriceadjustment"),"null",false,"15%",wrap ) %>
<%= comm.addDlistColumnHeading((String)rfqNLS.get("rfqresponsecatalogsynchronized"),"null",false,"15%",wrap ) %> 
<%= comm.endDlistRow() %>

<script type="text/javascript">
    var checkname;
    var checkvalue;
    var s,changeable,mandatory;
    var rowselect = 1;
    var synchonized;
    s ="";
    changeable="";
    mandatory ="";  
    for (var i=startIndex; i<endIndex; i++) 
    {     
    	checkname = "checkname_" + i;    	
        var reqName,reqCategoryName;        
    	var OwnSpecs,OwnComments;
    	var prodChangeable,prodSubstituted;
    	var linkCategorySummary = 'javascript:categorySummary('+CatalogPPArray[i].<%= RFQConstants.EC_OFFERING_CATEGORYID %>+')';   	
    	var percentagemark = "<%= (String)rfqNLS.get("percentagemark") %>";  
    	  	
    	checkvalue = CatalogPPArray[i].<%= RFQConstants.EC_OFFERING_CATEGORYID %>;
    	if (CatalogPPArray[i].<%= RFQConstants.EC_OFFERING_RESPOND_TO_CATEGORY %> == "<%= RFQConstants.EC_RFQ_RESPOND_TO_CATEGORY_NO %>")
	{
	    checkvalue = checkvalue + "," + "0";
        }
        else
        {
            checkvalue = checkvalue + "," + "1";
	}
	   	    	
	startDlistRow(rowselect);			
	addDlistCheck(checkvalue, "setSelectDeselectFalse();myRefreshButtons();", null);			
	addDlistColumn(ToHTML(CatalogPPArray[i].<%= RFQConstants.EC_OFFERING_CATEGORYNAME %>), linkCategorySummary);
	addDlistColumn(ToHTML(CatalogPPArray[i].<%= RFQConstants.EC_OFFERING_CATEGORYDESCRIPTION %> ));			
	addDlistColumn(ToHTML(CatalogPPArray[i].<%= RFQConstants.EC_RFQ_OFFERING_PRICEADJUSTMENT %> + percentagemark ));			
		
	if((CatalogPPArray[i].<%= RFQConstants.EC_RFQ_OFFERING_SYNCHRONIZE %>) == 'true') 
	{
	    addDlistColumn(ToHTML("<%= (String)rfqNLS.get("yes") %>")); 
	} else if ((CatalogPPArray[i].<%= RFQConstants.EC_RFQ_OFFERING_SYNCHRONIZE %>) == 'false') {
	    addDlistColumn(ToHTML("<%= (String)rfqNLS.get("no") %>")); 
	} else {
	    addDlistColumn(ToHTML(CatalogPPArray[i].<%= RFQConstants.EC_RFQ_OFFERING_SYNCHRONIZE %>)); 
	}
		
	if((CatalogPPArray[i].<%= RFQConstants.EC_OFFERING_PRICEADJUSTMENT %>) == "") 
	{
	    addDlistColumn(ToHTML(CatalogPPArray[i].res_priceAdjustment));
	} else {
	    addDlistColumn(ToHTML(CatalogPPArray[i].res_priceAdjustment + percentagemark ));
	}
	
	if((CatalogPPArray[i].<%= RFQConstants.EC_OFFERING_SYNCHRONIZE %>) == 'true') {
	    addDlistColumn(ToHTML("<%= (String)rfqNLS.get("yes") %>")); 
	} else if ((CatalogPPArray[i].<%= RFQConstants.EC_OFFERING_SYNCHRONIZE %>) == 'false') {
	    addDlistColumn(ToHTML("<%= (String)rfqNLS.get("no") %>")); 
	} else {
	    addDlistColumn(ToHTML(CatalogPPArray[i].<%= RFQConstants.EC_OFFERING_SYNCHRONIZE %>)); 
	}								
	
	endDlistRow();          		
        if ( rowselect == 1 ) 
        { 
            rowselect = 2; 
        } else { 
            rowselect = 1; 
        }        
    }
</script>
<%= comm.endDlistTable() %>
</form>

<script type="text/javascript">
    parent.afterLoads();
    if (CatalogPPArray != null) 
    {
	parent.setResultssize(CatalogPPArray.length);
    } else {
	parent.setResultssize(0);
    }

    retrievePanelData();
</script>

</body>
</html>
