<!--==========================================================================
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2001, 2002
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
//*
===========================================================================-->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
<%@ page language="java"
	import="com.ibm.commerce.beans.DataBeanManager,
	com.ibm.commerce.tools.contract.beans.PurchaseOrderTCDataBean,
	com.ibm.commerce.tools.util.UIUtil,
	com.ibm.commerce.tools.common.ui.taglibs.*"
%>

<%@ include file="../common/common.jsp" %>
<%@ include file="ContractCommon.jsp" %>


<%
	int startIndex = Integer.parseInt(request.getParameter("startindex"));
	int listSize = Integer.parseInt(request.getParameter("listsize"));
%>

<html>

<head>
<%= fHeader%>
<link rel="stylesheet" href="<%= UIUtil.getCSSFile(fLocale) %>" type="text/css">
<title><%= UIUtil.toHTML((String)contractsRB.get("contractPurchaseOrderTitle")) %></title>

<script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/Util.js">
</script>
<script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/dynamiclist.js">
</script>
<script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/FieldEntryUtil.js">
</script>
<script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/Vector.js">
</script>
<script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/ConvertToXML.js">
</script>

<script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/contract/Contract.js">
</script>
<script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/contract/PurchaseOrder.js">
</script>

<script LANGUAGE="JavaScript">
<!---- hide script from old browsers
//Declare variables to be used throughout the entire page

var purchaseOrderList;
var numberOfPurchaseOrder = 0;

<%
  // for test update contract use
 	//accountId = new String("10153");
  //foundAccountId =true;
  // end
%>


function changePOById(checked)
{
	var url = "/webapp/wcs/tools/servlet/DialogView?XMLFile=contract.ContractPurchaseOrderDialog";
	if (checked.length > 0)
	{
		var parms = checked.split(',');
		var rowNum = parms[0];

  	var ccdm = parent.parent.get("ContractCommonDataModel",null);
  	if (ccdm != null)
  	{
  	  top.saveData(ccdm, "CCDM");
  	}
  	savePanelData();
  	if (rowNum != null)
  	{
  		var changeRow = new Object();
  		changeRow = purchaseOrderList[rowNum];
      top.saveData(changeRow, "changeRow");
  		top.saveModel(parent.parent.model);
  	  top.setReturningPanel("notebookPurchaseOrder");
      if(top.setContent)
  	  {
  	    top.setContent("<%= UIUtil.toJavaScript((String)contractsRB.get("contractPurchaseOrderDialogChangeTitle")) %>", url, true);
  	  }
  	  else
  	  {
  	    alertDialog("parent.parent.location.replace(url);");
  	  //parent.parent.location.replace(url);
  	  }
  	}
  }
}


function loadPanelData ()
{

  if (!parent.parent.get)
  {
    alertDialog('No model found!');
    return;
  }

	var hereBefore = parent.parent.get("ContractPurchaseOrderModelLoaded", null);

	//alertDialog(hereBefore);
	if (hereBefore)
	{
		// have been to this page before - load from the model
		//alertDialog("have been here before, load data from the model");
		var cpm = parent.parent.get("ContractPurchaseOrderModel", null);

		if (cpm != null)
		{
			// load data to list from parent javascript object
			purchaseOrderList = cpm.purchaseOrder;
      with (document.ContractPurchaseOrderForm1)
      {
        If_Specified.checked = cpm.If_Specified;
        checkUniqueness.checked = cpm.checkUniqueness;
      }
		}

	 	//check see if we go back from 'New' or 'update' panel.
	 	var newPurchaseOrderTC=top.getData("newPurchaseOrderTC");
	 	var changeRow=top.getData("changeRow",0);
	 	if (newPurchaseOrderTC != null)
    {
      if (changeRow ==null)
      {
        //alertDialog("Go back from 'new' dialog.");
        purchaseOrderList[purchaseOrderList.length] = newPurchaseOrderTC;
      }
      else
      {
        //alertDialog("Go back from 'change' dialog.");
        purchaseOrderList[changeRow.rowNum]=newPurchaseOrderTC;

        //clear saved changeRow
        //alertDialog ("clear changeRow");
        top.saveData(null,"changeRow");
      }

      //clear saved new purchaseOrder TC
      top.saveData(null,"newPurchaseOrderTC");
    }
  }
	else
	{
		// this is the first time on this page
		// create the model

		var cpm = new ContractPurchaseOrderModel();

  	// check if this is an update

  	if (<%= foundAccountId %> == true)
		{
			// load the data from the databean
			// TODO
      purchaseOrderList = new Array();
     	cpm.If_Specified = false;
    	cpm.checkUniqueness = false;
	    cpm.old_If_Specified = false;
	    cpm.old_checkUniqueness = false;

    <%
      int j = 0;

  		if (foundAccountId)
  		{
  			try
  			{

    			PurchaseOrderTCDataBean potc = new PurchaseOrderTCDataBean(new Long(UIUtil.toHTML(accountId)), new Integer(fLanguageId));

    			DataBeanManager.activate(potc, request);
          int ifPOIndividual = potc.getPOIndividual();
    			String[] POLNumber;
    			String[] POLReferenceNumber;
    			String[] POBNumber;
    			String[] POBReferenceNumber;
    			String[] POLCurrency;
    			String[] POLValue;
  	  		POBNumber = potc.getPOBNumber();
  	  		POLNumber = potc.getPOLNumber();
  		  	POLCurrency = potc.getPOLCurrency();
  			  POLValue = potc.getPOLValue();
  			  POLReferenceNumber = potc.getPOLReferenceNumber();
  			  POBReferenceNumber = potc.getPOBReferenceNumber();

          // POIndividual
          if (ifPOIndividual == 1)
          {
          %>
           	cpm.If_Specified = true;
          	cpm.checkUniqueness = true;
      	    cpm.old_If_Specified = true;
	          cpm.old_checkUniqueness = true;
	          cpm.individualReferenceNumber = "<%=potc.getPOIReferenceNumber()%>";
	          with (document.ContractPurchaseOrderForm1)
	          {
	            If_Specified.checked=true;
	            checkUniqueness.checked=true;
	          }
          <%
          }
          else if(ifPOIndividual == 0)
          {
          %>
           	cpm.If_Specified = true;
          	cpm.checkUniqueness = false;
      	    cpm.old_If_Specified = true;
	          cpm.old_checkUniqueness = false;
	          cpm.individualReferenceNumber = "<%=potc.getPOIReferenceNumber()%>";
 	          with (document.ContractPurchaseOrderForm1)
	          {
	            If_Specified.checked=true;
	            checkUniqueness.checked=false;
	          }

    			<%
    			}

	  			// POLimited

    			for (int i=0; i < POLNumber.length; i++)
    			{
    			  %>
    			  purchaseOrderList[<%=j%>] = new Object();
    			  purchaseOrderList[<%=j%>].po = "<%=UIUtil.toJavaScript((String)POLNumber[i])%>";
    			  purchaseOrderList[<%=j%>].currency = "<%=POLCurrency[i]%>";
    			  purchaseOrderList[<%=j%>].limit = parent.parent.numberToCurrency(<%=POLValue[i]%>, "<%=POLCurrency[i]%>", "<%=fLanguageId%>");
    			  purchaseOrderList[<%=j%>].action = "noaction";
    			  purchaseOrderList[<%=j%>].referenceNumber = "<%=POLReferenceNumber[i]%>";
    			  <%
    			  j++;
    			}

    			// POBlanket

    			for (int i=0; i < POBNumber.length; i++)
    			{
    			  %>
    			  purchaseOrderList[<%=j%>] = new Object();
    			  purchaseOrderList[<%=j%>].po = "<%=UIUtil.toJavaScript((String)POBNumber[i])%>";
    			  purchaseOrderList[<%=j%>].limit = "-1";
    			  purchaseOrderList[<%=j%>].action = "noaction";
    			  purchaseOrderList[<%=j%>].referenceNumber = "<%=POBReferenceNumber[i]%>";
    			  <%
    			  j++;
    			}

    		}
  			catch (Exception e)
  			{
  			  out.println(e);
  			}
  		}
  		%>


   		cpm.purchaseOrder=purchaseOrderList;
			cpm.ifUpdateContract = true;
		}
		else
		{
      // initialize purchaseOrder list (temp)
      //alertDialog("First time be here, create the model.");

      purchaseOrderList = new Array();

      cpm.purchaseOrder=purchaseOrderList;
     	cpm.If_Specified = false;
    	cpm.checkUniqueness = false;
    	cpm.ifUpdateContract = false;
	    cpm.old_If_Specified = false;
	    cpm.old_checkUniqueness = false;

      //purchaseOrderList=cpm.purchaseOrder;
		}
	}

	//Just in case
	top.saveData(null,"changeRow");
  parent.parent.put("ContractPurchaseOrderModel", cpm);
	parent.parent.put("ContractPurchaseOrderModelLoaded", true);

  if (cpm == null)
  {
    //no rows have been entered yet
		numberOfPurchaseOrder = 0;
  	purchaseOrderList = new Array();
  	alertDialog("Fatal Error: No purchase order model found!");
	}
	else
	{
		// find out how many rows have been saved
		numberOfPurchaseOrder = purchaseOrderList.length;
	}

	addRowNumbers();
}


function showDivisions()
{
  with (document.ContractPurchaseOrderForm1)
  {
    var ifSpecifiedPO = If_Specified.checked;

    //alertDialog(ifhasSpendLimit);
    if (ifSpecifiedPO == true)
    {
      checkUniquenessPromptDiv.style.display = "block";
      checkUniquenessDiv.style.display = "block";
    }
    else
    {
      checkUniquenessPromptDiv.style.display = "none";
      checkUniquenessDiv.style.display = "none";
    }
  }
}

function getResultsize ()
{
	return numberOfPurchaseOrder;
}



function showXML()
{
  var ccdm = parent.parent.get("ContractCommonDataModel",null);
  var flanguageId=ccdm.flanguageId;
  var cpm = parent.parent.get("ContractPurchaseOrderModel", null);
  //alertDialog(convertToXML(cpm));
  var o = convertLocalModelToPurchaseOrder(cpm,flanguageId);
  if (o!=null)
  {
    alertDialog(convertToXML(o));
  }
  else
  {
    alertDialog("no purchaseOrder tcs");
  }
  /*
  if (cpm != null)
	{
		// load data to list from parent javascript object
		var pL = cpm.purchaseOrder;
		alertDialog(convertToXML(pL));
	}
  */
}

function createPurchaseOrder ()
{
  var url = "/webapp/wcs/tools/servlet/DialogView?XMLFile=contract.ContractPurchaseOrderDialog";
	//top.saveModel(Object data);
	var ccdm = parent.parent.get("ContractCommonDataModel",null);
	if (ccdm != null)
	{
	  top.saveData(ccdm, "CCDM");
	}
	savePanelData();
	top.saveModel(parent.parent.model);

	//top.saveData(Object data, String slotName);

	//top.setReturningPanel(String panelName);
	top.setReturningPanel("notebookPurchaseOrder");

	if(top.setContent)
	{
	  top.setContent("<%= UIUtil.toJavaScript((String)contractsRB.get("contractPurchaseOrderDialogAddTitle")) %>", url, true);
	}
	else
	{
	  alertDialog("parent.parent.location.replace(url);");
	  //parent.parent.location.replace(url);
	}
}

function updatePurchaseOrder ()
{
	var url = "/webapp/wcs/tools/servlet/DialogView?XMLFile=contract.ContractPurchaseOrderDialog";
	var rowNum = parent.getChecked();
	var ccdm = parent.parent.get("ContractCommonDataModel",null);
	if (ccdm != null)
	{
	  top.saveData(ccdm, "CCDM");
	}
	savePanelData();
	if (rowNum != null)
	{
		var changeRow = new Object();
		changeRow = purchaseOrderList[rowNum];
    top.saveData(changeRow, "changeRow");
		top.saveModel(parent.parent.model);
	  top.setReturningPanel("notebookPurchaseOrder");
    if(top.setContent)
	  {
	    top.setContent("<%= UIUtil.toJavaScript((String)contractsRB.get("contractPurchaseOrderDialogChangeTitle")) %>", url, true);
	  }
	  else
	  {
	    alertDialog("parent.parent.location.replace(url);");
	  //parent.parent.location.replace(url);
	  }
	}
}



function deletePurchaseOrder ()
{
  if (confirmDialog("<%= UIUtil.toJavaScript((String)contractsRB.get("contractPurchaseOrderFormDeleteConfirmation")) %>"))
  {
    var rowNum = new String(parent.getChecked());
    var items = rowNum.split(",");
    //items.sort();
    for (var i=0; i<items.length; i++)
    {
      purchaseOrderList[items[i]].deleted=true;
    }

    var newPurchaseOrderList= new Array();
    var j=0;

    //if (parent.parent.get("accountId", null) != null)

    if (<%= foundAccountId %> == true)
    {
      //updating a contract: if it is old TC, set action = delete

      for (var i=0; i<purchaseOrderList.length; i++)
      {
        if (purchaseOrderList[i].deleted)
        {
          if (purchaseOrderList[i].action=="noaction")
          {
            //load -> delete : set action=delete and keep it
            purchaseOrderList[i].action="delete";
            newPurchaseOrderList[j]=purchaseOrderList[i];
            j++;
          }
          else if (purchaseOrderList[i].action=="new")
          {
            //new tc, we can delete it from model
            //so do nothing
          }
          else
          {
            //catch "update" and "delete" TCs
            //just keep it
            newPurchaseOrderList[j]=purchaseOrderList[i];
            newPurchaseOrderList[j].action="delete";
            j++;
          }
        }
        else
        {
          //catch not deleted TCs
          newPurchaseOrderList[j]=purchaseOrderList[i];
          j++;
        }
      }
    }
    else
    {
      //new contract: erase deleted TCs from the model
      var j=0;
      for (var i=0; i<purchaseOrderList.length; i++)
      {
        if (!purchaseOrderList[i].deleted)
        {
          newPurchaseOrderList[j]=purchaseOrderList[i];
          j++;
        }
      }
    }

    purchaseOrderList=newPurchaseOrderList;
    var cpm = new ContractPurchaseOrderModel();

    var If_Specified = false;
    var checkUniqueness = false;
    var old_If_Specified = false;
    var old_checkUniqueness = false;
    var ifUpdateContract = false;
    var oldReferenceNumber;

    var o = parent.parent.get("ContractPurchaseOrderModel", null);
    if (o != null)
    {
   	  If_Specified = o.If_Specified;
   	  checkUniqueness = o.checkUniqueness;
      old_If_Specified = o.old_If_Specified;
      old_checkUniqueness = o.old_checkUniqueness;
      ifUpdateContract = o.ifUpdateContract;
      oldReferenceNumber=o.individualReferenceNumber;
   	}

    cpm.ifUpdateContract = ifUpdateContract;
    cpm.old_If_Specified = old_If_Specified;
	  cpm.old_checkUniqueness = old_checkUniqueness;

    cpm.If_Specified = If_Specified;
   	cpm.checkUniqueness = checkUniqueness;

    cpm.individualReferenceNumber=oldReferenceNumber;

    cpm.purchaseOrder=purchaseOrderList;

    parent.parent.put("ContractPurchaseOrderModel", cpm);

    var url="notebookPurchaseOrder";
    parent.parent.gotoPanel(url);
  }
}



function addRowNumbers ()
{
	for (var i=0; i<purchaseOrderList.length; i++)
	{
		purchaseOrderList[i].rowNum = i;
		purchaseOrderList[i].deleted = false;
	}
}



function savePanelData()
{
  //alertDialog ('PurchaseOrder TC: savePanelData');
  //return false;
  if (parent.parent.get)
  {
    var o = parent.parent.get("ContractPurchaseOrderModel", null);
    if (o != null)
    {
   	  //o.purchaseOrder=purchaseOrderList;
   	  with (document.ContractPurchaseOrderForm1)
   	  {
        o.If_Specified = If_Specified.checked;
        o.checkUniqueness = checkUniqueness.checked;
   	  }
   	  parent.parent.put("ContractPurchaseOrderModel", o);
    }
	}
}


function onLoad()
{
	parent.loadFrames();
	if (parent.parent.setContentFrameLoaded)
	{
		parent.parent.setContentFrameLoaded(true);
	}
}



//-->

</script>
</head>

<!--BODY onload="onLoad();" onUnLoad="savePanelData();"-->
<body onload="onLoad();" class="content">

<h1><%= contractsRB.get("contractPurchaseOrderTitle") %></h1>

<form NAME="ContractPurchaseOrderForm1" id="ContractPurchaseOrderForm1">

<table BORDER=0 id="ContractPurchaseOrderList_Table_1">
  <tr>
  &nbsp;
  </tr>
	<tr>
		<td WIDTH=20 id="ContractPurchaseOrderList_TableCell_1"><input NAME="If_Specified" TYPE="Checkbox" VALUE="true" ONCLICK="showDivisions()" id="ContractPurchaseOrderList_FormInput_If_Specified_In_ContractPurchaseOrderForm1_1"></td>
		<td id="ContractPurchaseOrderList_TableCell_2"><label for="ContractPurchaseOrderList_FormInput_If_Specified_In_ContractPurchaseOrderForm1_1"><%= contractsRB.get("contractPurchaseOrderUserSpecifiedPrompt") %></label></td>
	</tr>
	<tr height=40>
		<td WIDTH=20 id="ContractPurchaseOrderList_TableCell_3">&nbsp;</td>
		<td id="ContractPurchaseOrderList_TableCell_4">
			<table BORDER=0 id="ContractPurchaseOrderList_Table_2">
				<tr>
					<td WIDTH=20 id="ContractPurchaseOrderList_TableCell_5">
						<div id="checkUniquenessDiv" style="display: none">
							<input NAME="checkUniqueness" TYPE="CHECKBOX" value="true" id="ContractPurchaseOrderList_FormInput_checkUniqueness_In_ContractPurchaseOrderForm1_1">
						</div>
					</td>
					<td id="ContractPurchaseOrderList_TableCell_6">
						<div id="checkUniquenessPromptDiv" style="display: none">
							<label for="ContractPurchaseOrderList_FormInput_checkUniqueness_In_ContractPurchaseOrderForm1_1"><%= contractsRB.get("contractPurchaseOrderCheckUniquenessPrompt") %></label>
						</div>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>

</form>

<script LANGUAGE="JavaScript">
<!---- hide script from old browsers
  loadPanelData();
  showDivisions();
//-->

</script>

<form NAME="ContractPurchaseOrderForm" id="ContractPurchaseOrderForm">
<%= comm.startDlistTable((String)contractsRB.get("contractPurchaseOrderTitle")) %>
<%= comm.startDlistRowHeading() %>
<%= comm.addDlistCheckHeading() %>
<%= comm.addDlistColumnHeading((String)contractsRB.get("contractPurchaseOrderListPurchaseOrderColumn"), null, false) %>
<%= comm.addDlistColumnHeading((String)contractsRB.get("contractPurchaseOrderListLimitColumn"), null, false, "25%") %>
<%= comm.endDlistRow() %>

<script LANGUAGE="JavaScript">
<!-- hide script from old browsers

  var startIndex = <%= startIndex %>;
  var listSize = <%= listSize %>;
  var endIndex = startIndex + listSize;
  var j = 0;
  if (endIndex > numberOfPurchaseOrder)
  {
	  endIndex = numberOfPurchaseOrder;
  }
  for (var i=startIndex; i<endIndex; i++)
  {
	  if (purchaseOrderList[i].action != "delete" )
  	{

  	  if (j == 0)
  	  {
  		  document.writeln('<TR CLASS="list_row1">');
  		  j = 1;
  	  }
  	  else
  	  {
  		  document.writeln('<TR CLASS="list_row2">');
  		  j = 0;
  	  }
    	addDlistCheck(i, "none" );
    	addDlistColumn(purchaseOrderList[i].po, "javascript: changePOById('" + i +"')");

    	if (purchaseOrderList[i].limit=="-1")
    	{
    	  addDlistColumn("<%= UIUtil.toJavaScript((String)contractsRB.get("contractPurchaseOrderNoLimit")) %>", "none");
    	}
    	else
    	{
    	  var myColumn = purchaseOrderList[i].limit + " &nbsp; " + purchaseOrderList[i].currency;
    	  addDlistColumn(myColumn, "none");
    	}
    	document.writeln('</TR>');
    }
  }
//-->

</script>

<%= comm.endDlistTable() %>

<script LANGUAGE="JavaScript">
<!---- hide script from old browsers
if (numberOfPurchaseOrder == 0)
{
	document.writeln('<br>');
	document.writeln('<%= UIUtil.toJavaScript((String)contractsRB.get("contractPurchaseOrderListEmpty")) %>');
}
//-->

</script>

</form>

<script LANGUAGE="JavaScript">
<!---- hide script from old browsers
  parent.afterLoads();
  parent.setResultssize(getResultsize());
  parent.setButtonPos('0px','155px');
//-->

</script>

</body>

</html>


