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
	import="com.ibm.commerce.tools.util.UIUtil,
	com.ibm.commerce.datatype.TypedProperty" %>

<%@ include file="../common/common.jsp" %>
<%@ include file="ContractCommon.jsp" %>

<%
	String paymentPolicy = "";
  String pPolicy = "";
  String brand = "";
	TypedProperty requestProperties = (TypedProperty)request.getAttribute("RequestProperties");
	if (requestProperties != null) {
	  pPolicy=(String)requestProperties.getString("paymentPolicy");
		//paymentPolicy = "payment/" + pPolicy +".jsp";
		paymentPolicy = "../order/buyPages/" + pPolicy;
		brand = pPolicy=UIUtil.toHTML((String)requestProperties.getString("cardBrand"));
	}
	//paymentPolicy="payment/TestLines.html";

  CommandContext cmdContext = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
  Locale jLocale = cmdContext.getLocale();
  Hashtable paymentBuyPagesNLS = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("order.paymentBuyPagesNLS", jLocale);
%>

<html>
<script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/ConvertToXML.js">
</script>

<script LANGUAGE="JavaScript">
<!--

function showBlankLoadingDetail(flag)
{
  if (flag=="Blank")
  {
    if (parent.parent.setContentFrameLoaded)
    {
      parent.parent.setContentFrameLoaded(true);
    }
  	top.showProgressIndicator(false);
  	Detail.style.display = "none";
  	Loading.style.display = "none";
  	Blank.style.display = "block";
  }
  else if (flag=="Loading")
  {
    if (parent.parent.setContentFrameLoaded)
    {
      parent.parent.setContentFrameLoaded(false);
    }
  	top.showProgressIndicator(true);
  	Detail.style.display = "none";
  	Blank.style.display = "none";
  	Loading.style.display = "block";
  }
  else if (flag=="Detail")
  {
      if (parent.parent.setContentFrameLoaded)
    {
      parent.parent.setContentFrameLoaded(true);
    }
  	top.showProgressIndicator(false);
  	Loading.style.display = "none";
  	Blank.style.display = "none";
  	Detail.style.display = "block";
  }
}


function snipJSPOnChange(name)
{
  return;
}

function onload ()
{
  var changeRow=top.getData("changeRow",1);

  //if (changeRow!=null && changeRow.paymentPolicy=="<%=pPolicy%>")
  if (changeRow!=null)
  {
    //it is update
    //alertDialog(convertToXML(changeRow));
    var atts = changeRow.atts;
    if (atts != null)
    {
    	with (document.forms[0])
    	{
//alert("elements.length " + elements.length);
    		for (var i=0; i<elements.length; i++)
    		{
//alert("Match elements[i].name " + elements[i].name + " " + i);    		
//alert("atts.length " + atts.length);
    			for (var j=0; j<atts.length; j++)
    			{
//alert("atts[j].name " + atts[j].name + " " + j);
      				if (elements[i].name==atts[j].name)
      				{
//alert("Have a match type= " + elements[i].type);      				
        				if ((elements[i].type=="checkbox") || (elements[i].type=="radio"))
        				{
//alert("atts[j].value=" + atts[j].value);
//alert("elements[i].value=" + elements[i].value);
        		    			if (elements[i].value==atts[j].value)
        		    			{
        		      				elements[i].checked=true;
         		    			}
        		    			else
        		    			{
        		      				elements[i].checked=false;
	        		    		}
        				}
        				else if (elements[i].type=="select-one")
        				{
        					var m=i;
                				for (var k=0; k< elements[m].options.length; k++)
                				{
                  					if (elements[m].options[k].value==atts[j].value)
                  					{
                    						elements[m].options[k].selected=true;
                    						//got it, then skip to next element
                    						break;
                    						k = elements[m].options.length;
                  					}
                				}
        				}
        				else if (elements[i].type=="text")
        				{
        					elements[i].value=atts[j].value;
	        			}		
	        			break;
        			} //end if
        		}//end for j
    		} //end for i
    	}// end with


    }//end if atts
  }//end if changeRow
  showBlankLoadingDetail('Detail');
  if (parent.defined(parent.AddressSelectionBody.showBlank))
  {
    parent.AddressSelectionBody.showBlank(false);
  }
}
-->

</script>

<head>
<%= fHeader %>
<link rel="stylesheet" href="<%= UIUtil.getCSSFile(fLocale) %>" type="text/css">
<title><%= contractsRB.get("contractPaymentFormDetailPanelTitle") %></title>
</head>

<body class="content" OnLoad="onload();">
<div id="Blank" style="display: none">
</div>

<div id="Loading" style="display: none">
<%= contractsRB.get("generalLoadingMessage") %>
</div>

<div id="Detail" style="display: block">
<%	if (!paymentPolicy.equals("")) { %>
<form name=paymentForm id=paymentForm>
<%
request.setAttribute("resourceBundle", paymentBuyPagesNLS);
request.setAttribute("cardType", brand);
%>
<!--table border=0-->
<jsp:include page= "<%= paymentPolicy %>" flush="true" /><br>
<!--/table-->
</form>
<script LANGUAGE="JavaScript">
<!--
with (document.paymentForm)
if ("<%=brand%>"!="")
{
  <%= ECConstants.EC_CC_TYPE %>.value="<%=brand%>";
}
-->

</script>

<%	} %>
</div>
</body>

</html>
