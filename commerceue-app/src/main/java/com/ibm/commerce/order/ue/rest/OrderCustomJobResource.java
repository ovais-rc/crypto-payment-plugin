package com.ibm.commerce.order.ue.rest;

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

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.logging.Logger;

import javax.ws.rs.Consumes;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import com.fasterxml.jackson.dataformat.xml.XmlMapper;
import com.ibm.commerce.foundation.entities.ErrorUEResponse;
import com.ibm.commerce.foundation.entities.ExceptionData;
import com.ibm.commerce.foundation.entities.Message;
import com.ibm.commerce.foundation.ue.util.UserExitUtil;
import com.ibm.commerce.order.entities.Order;
import com.ibm.commerce.order.entities.OrderItem;
import com.ibm.commerce.order.entities.OrderStatus;
import com.ibm.commerce.order.ue.entities.OrderCustomJobUERequest;
import com.ibm.commerce.order.ue.entities.OrderCustomJobUEResponse;
import com.ibm.commerce.order.ue.entities.OrderPostUEResponse;
import com.ibm.commerce.ue.rest.BaseResource;

@Path("/customjob")
@SwaggerDefinition(tags = { @Tag(name = "customjob", description = "API Extensions for order scheduler job customization.") })
@Api(value = "/customjob", tags = "customjob")
public class OrderCustomJobResource extends BaseResource {

	private static final Logger LOGGER = Logger.getLogger(OrderCustomJobResource.class.getName());
	private static final String CLASS_NAME = OrderCustomJobResource.class.getName();

	/**
	 * This is the replaceUE api for CustomJobCmd controller command.
	 * 
	 * @param ueRequest
	 *            The UERequest passed.
	 * 
	 * @return The response.
	 */
	
	@POST
	@Path("/customjob_batch_order_message")
	@Consumes({ MediaType.APPLICATION_JSON })
	@Produces({ MediaType.APPLICATION_JSON })	
	@ApiOperation(value = "The replace API extension for CustomJobCmd controller command.", notes = "| Command: com.ibm.commerce.scheduler.commands.CustomJobCmd |\n|----------|\n| CustomJobCmd is a controller command which calls out to the scheduler xC.|", response = OrderPostUEResponse.class,
	extensions = { 
       @Extension( name = "data-command", properties = {
           @ExtensionProperty(name = "Command", value = "com.ibm.commerce.scheduler.commands.CustomJobCmd")
           })
    })
	@ApiResponses(value = { @ApiResponse(code = 400, message = "Invalid Input Parameter"),
			@ApiResponse(code = 500, message = "Invalid Input Parameter") })
	public Response OrderCustomJobMessage(
			@ApiParam(name = "OrderCustomJUEReplace UE input", value = "The UE Request String", required = true) OrderCustomJobUERequest ueRequest) {
		
		final String METHOD_NAME = "OrderCustomJobMessage(OrderCustomJobUERequest ueRequest)";
		
		List <Message> messages = new ArrayList<Message>();
		List<Order> orderPOJOS = ueRequest.getOrders();
		StringBuilder localeXml = new StringBuilder();

		if (orderPOJOS != null && !orderPOJOS.isEmpty()) {
			
			for(Order orderPOJO : orderPOJOS){
				if(orderPOJO != null){
					try{
						ObjectMapper jsonMapper = new ObjectMapper();
						String strPojo = jsonMapper.writeValueAsString(orderPOJO);
						Order ordObj = jsonMapper.readValue(strPojo, Order.class);
						XmlMapper xmlMapper = new XmlMapper();
						localeXml.append(new String(xmlMapper.writer().with(SerializationFeature.WRAP_ROOT_VALUE).writeValueAsBytes(ordObj))).append("\r\n");
						List<OrderItem> orderitemPOJOs = orderPOJO.getOrderItem();

						OrderStatus orderStatus = orderPOJO.getOrderStatus();
						orderStatus.setStatus("G");
						orderPOJO.setOrderStatus(orderStatus);
						
					}catch(Exception e){
						ErrorUEResponse ueResponse = new ErrorUEResponse();
						List<ExceptionData> errors = new ArrayList<ExceptionData>();
						ExceptionData error = new ExceptionData();
						error.setCode("400");
						error.setMessageKey("_ERR_INVALID_INPUT");
						error.setMessage("Exception in xml message transform");
						errors.add(error);
						ueResponse.setErrors(errors);
						Response response = Response.status(400).type(MediaType.APPLICATION_JSON).entity(ueResponse).build();

						LOGGER.exiting(CLASS_NAME, METHOD_NAME, response);
						return response;
					}
				}
			}
			
			Message myMessage = new Message();
			myMessage.setXml(localeXml.toString());
			myMessage.setLocale("en_US");
			myMessage.setMsgType("OrderReceived");
			myMessage.setStoreId("0");
			myMessage.setSync(false);
			messages.add(myMessage);
			
		}
		
		Map<String, Object> inputParameters = ueRequest.getCommandInputs();

		OrderCustomJobUEResponse ueResponse = UserExitUtil.createReplaceUEResponse(orderPOJOS, messages, inputParameters);
			
		Response response = Response.ok(ueResponse).build();
		return response;

	}

}
