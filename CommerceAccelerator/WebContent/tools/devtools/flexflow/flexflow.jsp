<!--
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
//*--------------------------------------------------------------------->

<script>

/******************************************************************************
*
*	Content initializer.
*
******************************************************************************/

	// from databean
	var flexflowInfo = null;
	var selections = new Object();	// selections[optionGroupId] = optionId that is selected for the optionGroupId
	var panels = new Object();
	var topPanels = new Array();
	var topOptionGroups = new Array();

	function initializeContent()
	{
		flexflowInfo = parent.get("flexflowInfo");
		selections = flexflowInfo["selections"];
		panels = flexflowInfo["panels"];
		topPanels = flexflowInfo["topPanels"];
		topOptionGroups = flexflowInfo["topOptionGroups"];
		
		//debugConsole();
		//debug(parent.convertToXML(parent.get("flexflowInfo")));
		//debug(parent.convertToXML(selections));
		//debug(parent.convertToXML(panels));
		//debug(parent.convertToXML(topPanels));
		
		updateAllOptionStatus();
		
		//debug(parent.convertToXML(enabledPanels));
		//debug(parent.convertToXML(enabledOptionGroups));
		
		parent.setContentFrameLoaded(true);		
	}

	function savePanelData()
	{
		flexflowInfo["enabledOptionGroups"] = enabledOptionGroups;
	}

/******************************************************************************
*
*	Enablement controller.
*
******************************************************************************/

	// enablement controller globals
	var condEnabledOptionGroups;
	var enabledPanels;
	var enabledOptionGroups;

	function enablementController_Execute()
	{
		condEnabledOptionGroups = new Vector("condEnabledOptionGroups");
		enabledPanels = new Vector("enabledPanels");
		enabledOptionGroups = new Vector("enabledOptionGroups");
		
		condEnabledOptionGroups.addElements(topOptionGroups);
		
		for (var i = 0; i < topPanels.length; i++)
			enablePanel(topPanels[i]);
	}

	function getPanelIdsToEnable(optionGroup)
	{
		var ids = new Vector();
		for (var optionId in optionGroup.options)
		{
			option = optionGroup.options[optionId];
			if (selections[optionGroup.id] == optionId)
				// option is selected
				ids.addElements(option.enablesPanels);
			else
				ids.addElements(option.disablesPanels);
		}
		return ids;
	}

	function getOptionGroupIdsToEnable(optionGroup)
	{
		var ids = new Vector();
		for (var optionId in optionGroup.options)
		{
			option = optionGroup.options[optionId];
			if (selections[optionGroup.id] == optionId)
				// option is selected
				ids.addElements(option.enablesOptionGroups);
			else
				ids.addElements(option.disablesOptionGroups);
		}
		return ids;
	}

	function findOptionGroup(optionGroupId)
	{
		for (var panelId in panels)
		{
			var optionGroup = panels[panelId].optionGroups[optionGroupId];
			if (optionGroup != null)
				return optionGroup;
		}
		return null;
	}
			
	function isOptionGroupOnDisabledPanel(optionGroupId)
	{
		for (var panelId in panels)
		{
			var optionGroup = panels[panelId].optionGroups[optionGroupId];
			if (optionGroup != null)
			{
				if (enabledPanels.contains(panelId))
					return false;
			}
		}
		return true;
	}

	function enableOptionGroup(optionGroupId)
	{
		if (enabledOptionGroups.contains(optionGroupId))
			// the option group is already enabled
			return;

		enabledOptionGroups.addElement(optionGroupId);
		condEnabledOptionGroups.removeElement(optionGroupId);	
	
		var optionGroup = findOptionGroup(optionGroupId);

		if (optionGroup == null)
		{
			//alert("Internal error.  Option group does not exist:  " + optionGroupId);
			return;
		}
		
		// enable child panels
		var enablePanels = getPanelIdsToEnable(optionGroup);
		for (var i = 0; i < enablePanels.size(); i++)
			enablePanel(enablePanels.elementAt(i));
		
		// enable child option groups
		var enableOptionGroups = getOptionGroupIdsToEnable(optionGroup);
		
		for (var i = 0; i < enableOptionGroups.size(); i++)
		{
			curOptionGroupId = enableOptionGroups.elementAt(i);
			if (isOptionGroupOnDisabledPanel(curOptionGroupId))
			{
				if (!condEnabledOptionGroups.contains(curOptionGroupId))
					condEnabledOptionGroups.addElement(curOptionGroupId);
			}
			else
				enableOptionGroup(curOptionGroupId);
		}
	}

	function enablePanel(panelId)
	{
		if (enabledPanels.contains(panelId))
			return;
			
		enabledPanels.addElement(panelId);
	
		if (panels[panelId] == null)
		{
			//alert("Internal error.  Panel does not exist:  " + panelId);
			return;
		}

		// enable "conditionally enabled controls"
		for (var optionGroupId in panels[panelId].optionGroups)
			if(condEnabledOptionGroups.contains(optionGroupId))
				enableOptionGroup(optionGroupId);
	}

/******************************************************************************
*
*	Selection controller.
*
******************************************************************************/

	function showOptionSelections()
	{
		var elements = document.optionsForm.elements;
		for (var i = 0; i < elements.length; i++)
		{
			var element = elements[i];

			var selectedValue;
			
			if (!enabledOptionGroups.contains(element.name))
				selectedValue = null;
			else
				selectedValue = selections[element.name];

			if (element.type == 'checkbox' || element.type == 'radio')
			{
				if (element.value == selectedValue)
					element.checked = true;
				else
					element.checked = false;
			}
			else if (element.type == 'select-one')
			{
				for (var j = 0; j < element.options.length; j++)
				{
					if (element.options[j].value == selectedValue)
						element.options[j].selected = true;
				}
			}		
		}
	}

	// update the selections list	
	function optionListener(element)
	{
		if (element.type == 'radio')
			selections[element.name] = element.value;
		else if (element.type == 'checkbox')
		{
			if (element.checked == true)
				selections[element.name] = element.value;
			else
				delete selections[element.name];
		}
		else if (element.type == 'select-one')
			selections[element.name] = element.value;

		updateAllOptionStatus();
	}
	
/******************************************************************************
*
*	Option status
*
******************************************************************************/

function updateAllOptionStatus()
{
	enablementController_Execute();
	
	for (var i = 0; i < document.optionsForm.elements.length; i++)
	{
		var element = document.optionsForm.elements[i];
		var optionGroup = findOptionGroup(element.name);

		if (!enabledOptionGroups.contains(element.name) || (optionGroup != null && optionGroup.dependsOn != null))
			disable(element.name);
		else
			enable(element.name);
	}
	showOptionSelections();
}

function disable(optionGroupId)
{
	setOptionStatus(optionGroupId, true);
}

function enable(optionGroupId)
{
	setOptionStatus(optionGroupId, false);
}

function setOptionStatus(name, status)
{
	// status for checkbox and list
	document.optionsForm[name].disabled = status;

	// status for radio
	for (var i = 0; i < document.optionsForm[name].length; i++)
		document.optionsForm[name][i].disabled = status;
}

</script>
