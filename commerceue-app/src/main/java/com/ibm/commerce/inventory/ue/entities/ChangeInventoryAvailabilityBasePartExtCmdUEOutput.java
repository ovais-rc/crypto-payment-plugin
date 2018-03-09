package com.ibm.commerce.inventory.ue.entities;

/*
 *-----------------------------------------------------------------
 * IBM Confidential
 *
 * OCO Source Materials
 *
 * WebSphere Commerce
 *
 * (C) Copyright IBM Corp. 2016
 *
 * The source code for this program is not published or otherwise
 * divested of its trade secrets, irrespective of what has
 * been deposited with the U.S. Copyright Office.
 *-----------------------------------------------------------------
 */

import com.ibm.commerce.foundation.entities.TaskCmdUEOutput;
import com.ibm.commerce.inventory.entities.InventoryAvailability;

public class ChangeInventoryAvailabilityBasePartExtCmdUEOutput extends TaskCmdUEOutput{
	
	InventoryAvailability noun;

	/**
	 * Return the noun of the InventoryAvailability
	 * @return noun
	 */
	public InventoryAvailability getNoun(){
		return noun;
		
	}
	
	/**
	 * Set noun of the InventoryAvailability
	 * @param noun
	 */
	public void setNoun(InventoryAvailability noun){
		this.noun = noun;
	}
}
