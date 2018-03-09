<!--
//********************************************************************
//*-------------------------------------------------------------------
//*Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright International Business Machines Corporation. 2002
//*     All rights reserved.
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*--------------------------------------------------------------------
-->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<%@include file="epromotionCommon.jsp" %>

<%!
  static final int NUMOFVISIBLEITEMSINLIST= 14;
%>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title><%=RLPromotionNLS.get("RLPromotionWho_title")%></title>
<%= fPromoHeader%>

<jsp:useBean id="memberGroupList" scope="request" class="com.ibm.commerce.tools.promotions.CustomerGroupDataBean">
</jsp:useBean>
<%
	memberGroupList.setMemberGroupTypeId(new Integer(-1));
	com.ibm.commerce.beans.DataBeanManager.activate(memberGroupList, request);
%>
<style type='text/css'>
.selectWidth {width: 180px;}

</style>
<script src="/wcs/javascript/tools/common/Util.js">
</script>
<script language="JavaScript1.2" src="/wcs/javascript/tools/common/SwapList.js">
</script>
<script>

function replaceSpecialChars(obj)
{
   var string = new String(obj);
   var result = string;
   for (var i=0; i<string.length;i++)
   { 	
	 result = result.replace("\\\"",'"');
   }
		
   return result;
}

function initializeState()
{
	var assignedShopperGroups  = new Array();
	var noAssignedShopperGroups  = new Array();

	if (parent.get) {
		var o = parent.get("<%= RLConstants.RLPROMOTION %>", null);
		if (o != null)
		{
	      	var shopGroups = new Array();
			<%
				int i=0;
				while (i<memberGroupList.getLength())
				{
			%>
					// noAssignedShopperGroups[<%=i%>] ="<%=memberGroupList.getMemberGroupId(i)%>"; - D47212
					noAssignedShopperGroups[<%=i%>] ="<%=UIUtil.toJavaScript(memberGroupList.getMemberGroupName(i).toString())%>";
					var sgrp = new Object;
					sgrp.name ="<%=UIUtil.toJavaScript(memberGroupList.getMemberGroupName(i).toString())%>";
					sgrp.ref  ="<%=memberGroupList.getMemberGroupId(i)%>";
					shopGroups[shopGroups.length] = sgrp ;
			<%
					i++;
				}
			%>
				parent.put("shopperGroups", shopGroups);
				parent.put("noAssignedShopperGroups", noAssignedShopperGroups);

			if(o.<%= RLConstants.RLPROMOTION_ASSIGNEDSEGMENTS %> != null && o.<%= RLConstants.RLPROMOTION_ASSIGNEDSEGMENTS %>.length != 0)
			{
				document.f1.allGroups[1].checked=true;
				document.f1.allGroups[1].focus();
				document.all["shopperGroupArea"].style.display = "block";

				assignedShopperGroups= o.<%= RLConstants.RLPROMOTION_ASSIGNEDSEGMENTS %>; 
				for (var i=0; i< assignedShopperGroups.length; i++) 
				{
					// var shopperGroupName = getShopperGroupName(assignedShopperGroups[i]); - D47212
					var shopperGroupName = replaceSpecialChars(assignedShopperGroups[i]);
					document.f1.definedShopperGroup.options[i] = new Option(shopperGroupName, shopperGroupName, false, false);
					document.f1.definedShopperGroup.options[i].selected=false;
				}
				var shopperGroups = parent.get("shopperGroups", null);
				var noAssignedShopGroups  = new Array();
				if(shopperGroups != null)
				{
					var nasgLength=0;
					for (var i=0; i< shopperGroups.length; i++) 
					{
						var has = true;
						for (var j=0; j< assignedShopperGroups.length; j++) 
						{
							// if (shopperGroups[i].ref ==  assignedShopperGroups[j]) - D47212
							if (shopperGroups[i].name ==  replaceSpecialChars(assignedShopperGroups[j]) )
							{
								has = false;	
								break;
							}
						}
						if(has)
						{
							// noAssignedShopGroups[nasgLength] = shopperGroups[i].ref; - D47212
							noAssignedShopGroups[nasgLength] = shopperGroups[i].name;
							nasgLength = nasgLength-(-1);
						}
					}
					parent.put("noAssignedShopperGroups", noAssignedShopGroups);
				}
			}
			else
			{
				document.f1.allGroups[0].checked=true;
				document.f1.allGroups[0].focus();
				document.all["shopperGroupArea"].style.display = "none";
			}

			var noAssignedShopperGroups = parent.get("noAssignedShopperGroups");
			if(noAssignedShopperGroups != null || noAssignedShopperGroups != "")
			{
				for ( var i=0; i< noAssignedShopperGroups.length; i++) 
				{
					// var shopperGroupName = getShopperGroupName(noAssignedShopperGroups[i]); - D47212
					var shopperGroupName = noAssignedShopperGroups[i];
					document.f1.allShopperGroup.options[i] = new Option( shopperGroupName, shopperGroupName, false, false);
					document.f1.allShopperGroup.options[i].selected=false;
				}
			}
		}
	}
	parent.setContentFrameLoaded(true);

	if (parent.get("noAssignedMbrGrps", false)) {
		parent.remove("noAssignedMbrGrps");
		alertDialog('<%= UIUtil.toJavaScript(RLPromotionNLS.get("needAMemberGroup").toString())%>');
	      return;
	}
}


function getShopperGroupName(shopperGroupRef)
{
	var groups = parent.get("shopperGroups");
	for (var i=0; i< groups.length; i++) 
	{
		if ( shopperGroupRef == groups[i].ref ) 
		{
			return groups[i].name;
		}
	}
	return shopperGroupRef;
}

function getshopperGroupRefnum(shopperGroupName) 
{
	 var groups = parent.get("shopperGroups");
	 for (var i=0; i< groups.length; i++) 
	 {
		  if ( shopperGroupName == groups[i].name ) 
		  {
			   return groups[i].ref;				
		  }
	 }
}


function savePanelData()
{
	var assignedShopperGroups  = new Array();
	var noAssignedShopperGroups  = new Array();

	if (parent.get) {
		var o = parent.get("<%= RLConstants.RLPROMOTION %>", null);
	}

	if (o != null)
	{
		if(document.f1.allGroups[1].checked)
		{
			o.<%= RLConstants.RLPROMOTION_VALIDFORALLCUSTOMERS %> = false;
			for (var i=0; i< document.f1.allShopperGroup.options.length; i++)
			{
				// var groupRef = getshopperGroupRefnum(document.f1.allShopperGroup.options[i].value); - D47212
				// noAssignedShopperGroups[i] = groupRef ; - D47212
				noAssignedShopperGroups[i] = document.f1.allShopperGroup.options[i].value;
			}
			var groups = parent.get("shopperGroups");
			if(groups.length > 0)
			{
				parent.put("noAssignedShopperGroups", noAssignedShopperGroups);
			}
			for (var i=0; i< document.f1.definedShopperGroup.options.length; i++)
			{
				// var groupRef = getshopperGroupRefnum(document.f1.definedShopperGroup.options[i].value); - D47212
				// assignedShopperGroups[i] = groupRef; - D47212
				assignedShopperGroups[i] = document.f1.definedShopperGroup.options[i].value;
			}
			o.<%= RLConstants.RLPROMOTION_ASSIGNEDSEGMENTS %> = assignedShopperGroups;
		}
		else
		{
			o.<%= RLConstants.RLPROMOTION_ASSIGNEDSEGMENTS %> = assignedShopperGroups;
			o.<%= RLConstants.RLPROMOTION_VALIDFORALLCUSTOMERS %> = true;
		}
	}	
}

function validatePanelData()
{
	if ((document.f1.allGroups[1].checked)&&(isListBoxEmpty(document.f1.definedShopperGroup))) 
	{
		alertDialog('<%= UIUtil.toJavaScript(RLPromotionNLS.get("needAMemberGroup").toString())%>');
		return false;
	}
    return true;
}

function showAllShopperGroup()
{
	var shopperGroups = new Array();
	shopperGroups = parent.get("shopperGroups", null);

	if(shopperGroups != null && shopperGroups.length !=0)
	{
		setItemsSelected(document.f1.definedShopperGroup);
		move(document.f1.definedShopperGroup,document.f1.allShopperGroup);
		document.all["shopperGroupArea"].style.display = "block";
	}
	else
	{
		alertDialog('<%= UIUtil.toJavaScript(RLPromotionNLS.get("emptyGroup").toString())%>');
		document.f1.allGroups[0].checked=true;
	}

}

function hideAllShopperGroup()
{
	setItemsSelected(document.f1.definedShopperGroup);
	move(document.f1.definedShopperGroup,document.f1.allShopperGroup);	
	document.all["shopperGroupArea"].style.display = "none";
}


function addToDefinedShopperGroup() 
{
	move(document.f1.allShopperGroup, document.f1.definedShopperGroup);
	updateSloshBuckets(document.f1.allShopperGroup, document.f1.addButton, document.f1.definedShopperGroup, document.f1.removeButton);
}

function removeFromDefinedShopperGroup() 
{
	move(document.f1.definedShopperGroup, document.f1.allShopperGroup);
	updateSloshBuckets(document.f1.definedShopperGroup, document.f1.removeButton,document.f1.allShopperGroup, document.f1.addButton);
}




</script>
<!-- ============================================================================
The sample Templates, HTML and Macros are furnished by IBM as simple
examples to provide an illustration. These examples have not been
thoroughly tested under all conditions.  IBM, therefore, cannot guarantee reliability, 
serviceability or function of these programs. All programs contained herein are provided 
to you "AS IS".

The sample Templates, HTML and Macros may include the names of individuals,
companies, brands and products in order to illustrate them as completely as
possible.  All of these are names are ficticious and any similarity to the names
and addresses used by actual persons or business enterprises is entirely coincidental.

Licensed Materials - Property of IBM

5697-D24

(c)  Copyright  IBM Corp.  1997, 1999.      All Rights Reserved

US Government Users Restricted Rights - Use, duplication or 
disclosure restricted by GSA ADP Schedule Contract with IBM Corp

=============================================================================== -->

<meta name="GENERATOR" content="IBM WebSphere Studio" />
</head>
<body class="content" onload="initializeState();">
   <h1><%=RLPromotionNLS.get("RLPromotionWho_title")%></h1>
   <p><%=RLPromotionNLS.get("shopperGroupMsg")%></p>
   <form name='f1' id='f1'>
    <input type="radio" name="allGroups" value="true" onclick="javascript:hideAllShopperGroup()" id="WC_RLPromotionWho_FormInput_allGroups_In_f1_1" /> <label for="WC_RLPromotionWho_FormInput_allGroups_In_f1_1"><%=RLPromotionNLS.get("assignToAllShopper")%></label>
    <br />
    <input type="radio" name="allGroups" value="false" onclick="javascript:showAllShopperGroup()" id="WC_RLPromotionWho_FormInput_allGroups_In_f1_2" /> <label for="WC_RLPromotionWho_FormInput_allGroups_In_f1_2"><%=RLPromotionNLS.get("assignToGroups")%></label>

   <div id="shopperGroupArea" style="display:none">
    <blockquote>

       <table border='0' id="WC_RLPromotionWho_Table_1">
         <tr>
        <td id="WC_RLPromotionWho_TableCell_1"><label for="definedShopperGroup"><%=RLPromotionNLS.get("definedShopperGroups")%></label></td>
   	<td width='20' id="WC_RLPromotionWho_TableCell_2">&nbsp;</td>
   	<td id="WC_RLPromotionWho_TableCell_3"><label for="allShopperGroup"><%=RLPromotionNLS.get("allShopperGroupsLbl")%></label></td>
         </tr>

   	  <!-- all shopper groups -->
          <tr>
           <td id="WC_RLPromotionWho_TableCell_4">
   	     <select name='definedShopperGroup' id="definedShopperGroup" class='selectWidth' multiple ="multiple" size='<%=NUMOFVISIBLEITEMSINLIST%>' onchange="javascript:updateSloshBuckets(this, document.f1.removeButton, document.f1.allShopperGroup, document.f1.addButton);">

         	   </select>
     	   </td>

   	   <td width='20' valign="top" id="WC_RLPromotionWho_TableCell_5"><br /><br />
   	      <input type='button' name='addButton' class="disabled" style='width:125px' value='<%=RLPromotionNLS.get("buttonAdd")%>' onclick="addToDefinedShopperGroup();parent.put('lastupdategui', '<%=RLPromotionNLS.get("definedshoppergroups")%>');" /><font size='javascript:Util.isDoubleByteLocale(<%=fLocale%>)? "2" : =":""1"' style='float:left; padding-top:2px'><br /><br />
   	      <input type='button' name='removeButton' class="disabled" style='width:125px' value='<%=RLPromotionNLS.get("buttonRemove")%>' onclick="removeFromDefinedShopperGroup();parent.put('lastupdategui', '<%=RLPromotionNLS.get("definedshoppergroups")%>');" /><font size='javascript:Util.isDoubleByteLocale(<%=fLocale%>)? "2" : =":""1"' style='float:left; padding-top:2px'>
   	   </font></font></td>
           <td id="WC_RLPromotionWho_TableCell_6">
             <select name='allShopperGroup' id="allShopperGroup" class='selectWidth' multiple ="multiple" size='<%=NUMOFVISIBLEITEMSINLIST%>' onchange="javascript:updateSloshBuckets(this, document.f1.addButton, document.f1.definedShopperGroup, document.f1.removeButton);">
   	     <!-- all available shopper groups for merchant -->

   	     </select>
   	   </td>
          </tr>
      </table>
   </blockquote>
  </div>
  </form>
</body>
</html>
