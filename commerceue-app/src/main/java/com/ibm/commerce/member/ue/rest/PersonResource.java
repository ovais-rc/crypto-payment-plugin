package com.ibm.commerce.member.ue.rest;

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

import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.logging.Logger;

import javax.servlet.http.HttpServletRequest;
import javax.ws.rs.Consumes;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;



import com.ibm.commerce.foundation.ue.util.UserExitUtil;
import com.ibm.commerce.member.entities.Attribute;
import com.ibm.commerce.member.entities.AttributeValue;
import com.ibm.commerce.foundation.common.entities.ContactInfo;
import com.ibm.commerce.member.entities.Person;
import com.ibm.commerce.member.entities.PersonalProfile;
import com.ibm.commerce.member.ue.entities.PersonPostUERequest;
import com.ibm.commerce.member.ue.entities.PersonPostUEResponse;
import com.ibm.commerce.member.ue.entities.PersonPreUERequest;
import com.ibm.commerce.member.ue.entities.PersonPreUEResponse;
import com.ibm.commerce.member.ue.entities.PersonReplaceUERequest;
import com.ibm.commerce.member.ue.entities.PersonReplaceUEResponse;
import com.ibm.commerce.ue.rest.BaseResource;
import com.ibm.commerce.ue.rest.MessageKey;


@Path("/person")
@SwaggerDefinition(tags = { @Tag(name = "person", description = "API Extensions for person customization.") })
@Api(value = "/person", tags = "person")
public class PersonResource extends BaseResource {
	
	@Context HttpServletRequest request;
	
	private static final String requestId = "X-Request-ID";
	private static final String responseId = "X-Response-ID";

	private static final Logger LOGGER = Logger.getLogger(PersonResource.class.getName());
	private static final String CLASS_NAME = PersonResource.class.getName();

	private static Locale locale = new Locale(MessageKey.getConfig("_CONFIG_LANGUAGE"),
			MessageKey.getConfig("_CONFIG_LOCALE"));

	/**
	 * The pre API extension for UserRegistrationAddCmd controller command. This
	 * command is used to register a new shopper.
	 * 
	 * @param ueRequest
	 *            The UERequest passed.
	 * 
	 * @return The response.
	 */

	@POST
	@Path("/person_register_pre")
	@Consumes({ MediaType.APPLICATION_JSON })
	@Produces({ MediaType.APPLICATION_JSON })
	@ApiOperation(value = "The pre API extension for UserRegistrationAddCmd controller command.", notes = "| Command: com.ibm.commerce.usermanagement.commands.UserRegistrationAddCmd |\n|----------|\n| UserRegistrationAddCmd is a controller command which is used to register a new shopper|", response = PersonPreUEResponse.class,
		extensions = { 
	       @Extension( name = "data-command", properties = {
	           @ExtensionProperty(name = "Command", value = "com.ibm.commerce.usermanagement.commands.UserRegistrationAddCmd")
	           })
	    })
	@ApiResponses(value = { @ApiResponse(code = 400, message = "Application error"),
			@ApiResponse(code = 500, message = "System error") })
	public Response personRegisterPre(
			@ApiParam(name = "personRegisterPre UE input", value = "The UE Request String", required = true) PersonPreUERequest ueRequest) {

		Person personPOJO = ueRequest.getPerson();

		Map<String, Object> inputParameters = ueRequest.getCommandInputs();

		PersonPreUEResponse ueResponse = UserExitUtil.createPreUEResponse(personPOJO, inputParameters);
		Response response = Response.ok(ueResponse).build();

		return response;

	}

	/**
	 * The replace API extension for UserRegistrationAddCmd controller command. This
	 * command is used to register a new shopper.
	 * 
	 * @param ueRequest
	 *            The UERequest passed.
	 * 
	 * @return The response.
	 */

	@POST
	@Path("/person_register_replace")
	@Consumes({ MediaType.APPLICATION_JSON })
	@Produces({ MediaType.APPLICATION_JSON })
	@ApiOperation(value = "The replace API extension for UserRegistrationAddCmd controller command.", notes = "| Command: com.ibm.commerce.usermanagement.commands.UserRegistrationAddCmd |\n|----------|\n| UserRegistrationAddCmd is a controller command which is used to register a new shopper|", response = PersonReplaceUEResponse.class,
		extensions = { 
	       @Extension( name = "data-command", properties = {
	           @ExtensionProperty(name = "Command", value = "com.ibm.commerce.usermanagement.commands.UserRegistrationAddCmd")
	           })
	    })
	@ApiResponses(value = { @ApiResponse(code = 400, message = "Application error"),
			@ApiResponse(code = 500, message = "System error") })
	public Response personRegisterReplace(
			@ApiParam(name = "personRegisterReplace UE input", value = "The UE Request String", required = true) PersonReplaceUERequest ueRequest) {

		Person personPOJO = ueRequest.getPerson();

		Map<String, Object> inputParameters = ueRequest.getCommandInputs();

		PersonReplaceUEResponse ueResponse = UserExitUtil.createReplaceUEResponse(personPOJO, inputParameters);

		Response response = Response.ok(ueResponse).build();
		return response;

	}

	/**
	 * The post API extension for UserRegistrationAddCmd controller command. This
	 * command is used to register a new shopper.
	 * 
	 * @param ueRequest
	 *            The UERequest passed.
	 * 
	 * @return The response.
	 */

	@POST
	@Path("/person_register_post")
	@Consumes({ MediaType.APPLICATION_JSON })
	@Produces({ MediaType.APPLICATION_JSON })
	@ApiOperation(value = "The post API extension for UserRegistrationAddCmd controller command.", notes = "| Command: com.ibm.commerce.usermanagement.commands.UserRegistrationAddCmd |\n|----------|\n| UserRegistrationAddCmd is a controller command which is used to register a new shopper|", response = PersonPostUEResponse.class,
		extensions = { 
	       @Extension( name = "data-command", properties = {
	           @ExtensionProperty(name = "Command", value = "com.ibm.commerce.usermanagement.commands.UserRegistrationAddCmd")
	           })
	    })
	@ApiResponses(value = { @ApiResponse(code = 400, message = "Application error"),
			@ApiResponse(code = 500, message = "System error") })
	public Response personRegisterPost(
			@ApiParam(name = "personRegisterPost UE input", value = "The UE Request String", required = true) PersonPostUERequest ueRequest) {
		Person personPOJO = ueRequest.getPerson();

		Map<String, Object> inputParameters = ueRequest.getCommandInputs();

		PersonPostUEResponse ueResponse = UserExitUtil.createPostUEResponse(personPOJO, inputParameters);

		Response response = Response.ok(ueResponse).build();
		return response;

	}

	/**
	 * The pre API extension for UserRegistrationUpdateCmd controller command. This
	 * command is used to update existing shopper.
	 * 
	 * @param ueRequest
	 *            The UERequest passed.
	 * 
	 * @return The response.
	 */

	@POST
	@Path("/person_update_pre")
	@Consumes({ MediaType.APPLICATION_JSON })
	@Produces({ MediaType.APPLICATION_JSON })
	@ApiOperation(value = "The pre API extension for UserRegistrationUpdateCmd controller command.", notes = "| Command: com.ibm.commerce.usermanagement.commands.UserRegistrationUpdateCmd |\n|----------|\n| UserRegistrationUpdateCmd is a controller command which is used to update existing shopper|", response = PersonPreUEResponse.class,
		extensions = { 
	       @Extension( name = "data-command", properties = {
	           @ExtensionProperty(name = "Command", value = "com.ibm.commerce.usermanagement.commands.UserRegistrationUpdateCmd")
	           })
	    })
	@ApiResponses(value = { @ApiResponse(code = 400, message = "Application error"),
			@ApiResponse(code = 500, message = "System error") })
	public Response personUpdatePre(
			@ApiParam(name = "personUpdatePre UE input", value = "The UE Request String", required = true) PersonPreUERequest ueRequest) {

		Person personPOJO = ueRequest.getPerson();
		
		Map<String, Object> inputParameters = ueRequest.getCommandInputs();
		
		PersonPreUEResponse ueResponse = UserExitUtil.createPreUEResponse(personPOJO, inputParameters);
		
		Response response = Response.ok(ueResponse).build();

		return response;

	}

	/**
	 * The replace API extension for UserRegistrationUpdateCmd controller command. This
	 * command is used to update existing shopper.
	 * 
	 * @param ueRequest
	 *            The UERequest passed.
	 * 
	 * @return The response.
	 */

	@POST
	@Path("/person_update_replace")
	@Consumes({ MediaType.APPLICATION_JSON })
	@Produces({ MediaType.APPLICATION_JSON })
	@ApiOperation(value = "The replace API extension for UserRegistrationUpdateCmd controller command.", notes = "| Command: com.ibm.commerce.usermanagement.commands.UserRegistrationUpdateCmd |\n|----------|\n| UserRegistrationUpdateCmd is a controller command which is used to update existing shopper|", response = PersonReplaceUEResponse.class,
		extensions = { 
	       @Extension( name = "data-command", properties = {
	           @ExtensionProperty(name = "Command", value = "com.ibm.commerce.usermanagement.commands.UserRegistrationUpdateCmd")
	           })
	    })
	@ApiResponses(value = { @ApiResponse(code = 400, message = "Application error"),
			@ApiResponse(code = 500, message = "System error") })
	public Response personUpdateReplace(
			@ApiParam(name = "personUpdateReplace UE input", value = "The UE Request String", required = true) PersonReplaceUERequest ueRequest) {

		Person personPOJO = ueRequest.getPerson();

		Map<String, Object> inputParameters = ueRequest.getCommandInputs();

		PersonReplaceUEResponse ueResponse = UserExitUtil.createReplaceUEResponse(personPOJO, inputParameters);

		Response response = Response.ok(ueResponse).build();
		return response;

	}

	/**
	 * The post API extension for UserRegistrationUpdateCmd controller command. This
	 * command is used to update existing shopper.
	 * 
	 * @param ueRequest
	 *            The UERequest passed.
	 * 
	 * @return The response.
	 */

	@POST
	@Path("/person_update_post")
	@Consumes({ MediaType.APPLICATION_JSON })
	@Produces({ MediaType.APPLICATION_JSON })
	@ApiOperation(value = "The post API extension for UserRegistrationUpdateCmd controller command.", notes = "| Command: com.ibm.commerce.usermanagement.commands.UserRegistrationUpdateCmd |\n|----------|\n| UserRegistrationUpdateCmd is a controller command which is used to update existing shopper|", response = PersonPostUEResponse.class,
		extensions = { 
	       @Extension( name = "data-command", properties = {
	           @ExtensionProperty(name = "Command", value = "com.ibm.commerce.usermanagement.commands.UserRegistrationUpdateCmd")
	           })
	    })
	@ApiResponses(value = { @ApiResponse(code = 400, message = "Application error"),
			@ApiResponse(code = 500, message = "System error") })
	public Response personUpdatePost(
			@ApiParam(name = "personUpdatePost UE input", value = "The UE Request String", required = true) PersonPostUERequest ueRequest) {
		Person personPOJO = ueRequest.getPerson();
		
		Map<String, Object> inputParameters = ueRequest.getCommandInputs();

		PersonPostUEResponse ueResponse = UserExitUtil.createPostUEResponse(personPOJO, inputParameters);

		Response response = Response.ok(ueResponse).build();
		return response;

	}
}
