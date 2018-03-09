package com.ibm.commerce.inventory.ue.rest;

/*
 *-----------------------------------------------------------------
 * IBM Confidential
 *
 * OCO Source Materials
 *
 * WebSphere Commerce
 *
 * (C) Copyright IBM Corp. 2015, 2016
 *
 * The source code for this program is not published or otherwise
 * divested of its trade secrets, irrespective of what has
 * been deposited with the U.S. Copyright Office.
 *-----------------------------------------------------------------
 */
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import io.swagger.annotations.ApiParam;
import io.swagger.annotations.ApiResponse;
import io.swagger.annotations.ApiResponses;
import io.swagger.annotations.Extension;
import io.swagger.annotations.ExtensionProperty;
import io.swagger.annotations.SwaggerDefinition;
import io.swagger.annotations.Tag;

import java.lang.reflect.Field;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import java.util.logging.Logger;

import javax.servlet.http.HttpServletRequest;
import javax.ws.rs.Consumes;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;

import com.ibm.commerce.foundation.entities.TaskCmdUEInput;
import com.ibm.commerce.foundation.ue.util.UserExitUtil;
import com.ibm.commerce.inventory.entities.InventoryAvailability;
import com.ibm.commerce.inventory.ue.entities.ChangeInventoryAvailabilityBasePartExtCmdUEInput;
import com.ibm.commerce.inventory.ue.entities.ChangeInventoryAvailabilityBasePartExtCmdUEOutput;
import com.ibm.commerce.ue.rest.BaseResource;
import com.ibm.commerce.ue.rest.MessageKey;

@Path("/inventory")
@SwaggerDefinition(tags = { @Tag(name = "inventory", description = "API Extensions for inventory customization.") })
@Api(value = "/inventory", tags = "inventory")
public class InventoryResource extends BaseResource {
	
	@Context HttpServletRequest request;
	
	private static final String requestId = "X-Request-ID";
	private static final String responseId = "X-Response-ID";

	private static final Logger LOGGER = Logger.getLogger(InventoryResource.class.getName());
	private static final String CLASS_NAME = InventoryResource.class.getName();

	private static Locale locale = new Locale(MessageKey.getConfig("_CONFIG_LANGUAGE"),
			MessageKey.getConfig("_CONFIG_LOCALE"));
	
	
	@POST
	@Path("/inventory_update")
	@Consumes({ MediaType.APPLICATION_JSON })
	@Produces({ MediaType.APPLICATION_JSON })
	@ApiOperation(value = "The API extension for ChangeInventoryAvailabilityBasePartExtCmd task command.", notes = "| Command: com.ibm.commerce.inventory.task.commands.ChangeInventoryAvailabilityBasePartExtCmd |\n|----------|\n| ChangeInventoryAvailabilityBasePartExtCmd task command provides customers the ability to synchronize inventory services|", response = ChangeInventoryAvailabilityBasePartExtCmdUEOutput.class,
	extensions = { 
       @Extension( name = "data-command", properties = {
           @ExtensionProperty(name = "Command", value = "com.ibm.commerce.inventory.task.commands.ChangeInventoryAvailabilityBasePartExtCmd")
           })
    })
	@ApiResponses(value = { @ApiResponse(code = 400, message = "Invalid Input Parameter"),
			@ApiResponse(code = 500, message = "Invalid Input Parameter") })
	public Response updateInventoryQuantity(
			@ApiParam(name = "ChangeInventoryAvailabilityBasePartExtCmdUEInput", value = "ChangeInventoryAvailabilityBasePartExtCmdUEInput UE Input Parameter", required = true) ChangeInventoryAvailabilityBasePartExtCmdUEInput changeInventoryAvailabilityUEInput) {
		List<Field> properties = new ArrayList<Field>();
		Field[] fields = ChangeInventoryAvailabilityBasePartExtCmdUEInput.class.getDeclaredFields();
		for (Field field : fields) {
			properties.add(field);
		}
		fields = TaskCmdUEInput.class.getDeclaredFields();
		for (Field field : fields) {
			properties.add(field);
		}
		ChangeInventoryAvailabilityBasePartExtCmdUEOutput changeInventoryAvailabilityUEOutput = new ChangeInventoryAvailabilityBasePartExtCmdUEOutput();
		UserExitUtil.setPropertiesFromInputToOutput(changeInventoryAvailabilityUEInput, ChangeInventoryAvailabilityBasePartExtCmdUEInput.class,
				changeInventoryAvailabilityUEOutput, ChangeInventoryAvailabilityBasePartExtCmdUEOutput.class, properties);

		InventoryAvailability noun = changeInventoryAvailabilityUEInput.getNoun();
		com.ibm.commerce.foundation.common.entities.Quantity quantity = noun.getAvailableQuantity();
		double value = 0.0;
		double oldValue = 0.0;
		if(changeInventoryAvailabilityUEInput.getOldNoun() != null && changeInventoryAvailabilityUEInput.getOldNoun().getAvailableQuantity() != null){
		    oldValue = changeInventoryAvailabilityUEInput.getOldNoun().getAvailableQuantity().getValue();
		}
		double newValue = 0.0;
		
		if(changeInventoryAvailabilityUEInput.getNoun() != null && changeInventoryAvailabilityUEInput.getNoun().getAvailableQuantity() != null){
			newValue = changeInventoryAvailabilityUEInput.getNoun().getAvailableQuantity().getValue();
		}
		
		quantity.setValue(oldValue + newValue);
		noun.setAvailableQuantity(quantity);
		changeInventoryAvailabilityUEOutput.setNoun(noun);
		Response response = Response.ok(changeInventoryAvailabilityUEOutput).build();
		return response;
	}


}

