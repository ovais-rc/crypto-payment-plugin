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

import java.lang.reflect.Field;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Set;
import java.util.logging.Level;
import java.util.logging.Logger;

import javax.servlet.http.HttpServletRequest;
import javax.ws.rs.Consumes;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import javax.ws.rs.core.Response.ResponseBuilder;
import javax.ws.rs.core.Response.Status;

import com.ibm.commerce.foundation.common.entities.Quantity;
import com.ibm.commerce.foundation.entities.ErrorUEResponse;
import com.ibm.commerce.foundation.entities.ExceptionData;
import com.ibm.commerce.foundation.entities.TaskCmdUEInput;
import com.ibm.commerce.foundation.ue.compensation.entities.CompensateForTxRollbackCmdUEInput;
import com.ibm.commerce.foundation.ue.compensation.entities.CompensateForTxRollbackCmdUEOutput;
import com.ibm.commerce.foundation.ue.compensation.entities.UEInvocation;
import com.ibm.commerce.foundation.ue.util.UserExitUtil;
import com.ibm.commerce.order.entities.Order;
import com.ibm.commerce.order.entities.OrderItem;
import com.ibm.commerce.order.ue.entities.ExtOrderProcessCmdUEInput;
import com.ibm.commerce.order.ue.entities.ExtOrderProcessCmdUEOutput;
import com.ibm.commerce.order.ue.entities.OrderMessagingCmdUEInput;
import com.ibm.commerce.order.ue.entities.OrderMessagingCmdUEOutput;
import com.ibm.commerce.order.ue.entities.OrderNotifyCmdUEInput;
import com.ibm.commerce.order.ue.entities.OrderNotifyCmdUEOutput;
import com.ibm.commerce.order.ue.entities.OrderPostUERequest;
import com.ibm.commerce.order.ue.entities.OrderPostUEResponse;
import com.ibm.commerce.order.ue.entities.OrderPreUERequest;
import com.ibm.commerce.order.ue.entities.OrderPreUEResponse;
import com.ibm.commerce.order.ue.entities.OrderReplaceUERequest;
import com.ibm.commerce.order.ue.entities.OrderReplaceUEResponse;
import com.ibm.commerce.order.ue.entities.PreProcessOrderCmdUEInput;
import com.ibm.commerce.order.ue.entities.PreProcessOrderCmdUEOutput;
import com.ibm.commerce.order.ue.entities.ProcessOrderCmdUEInput;
import com.ibm.commerce.order.ue.entities.ProcessOrderCmdUEOutput;
import com.ibm.commerce.order.ue.entities.ProcessOrderSubmitEventCmdUEInput;
import com.ibm.commerce.order.ue.entities.ProcessOrderSubmitEventCmdUEOutput;
import com.ibm.commerce.order.ue.entities.TaxIntegrationCustomCmdUEInput;
import com.ibm.commerce.order.ue.entities.TaxIntegrationCustomCmdUEOutput;
import com.ibm.commerce.order.ue.entities.TaxIntegrationCustomOrderItem;
import com.ibm.commerce.order.ue.entities.UpdateShippingAddressCmdUEInput;
import com.ibm.commerce.order.ue.entities.UpdateShippingAddressCmdUEOutput;
import com.ibm.commerce.ue.rest.BaseResource;
import com.ibm.commerce.ue.rest.MessageKey;

@Path("/order")
@SwaggerDefinition(tags = { @Tag(name = "order", description = "API Extensions for order customization.") })
@Api(value = "/order", tags = "order")
public class OrderResource extends BaseResource {
	
	@Context HttpServletRequest request;
	
	private static final String requestId = "X-Request-ID";
	private static final String responseId = "X-Response-ID";

	private static final Logger LOGGER = Logger.getLogger(OrderResource.class.getName());
	private static final String CLASS_NAME = OrderResource.class.getName();

	private static Locale locale = new Locale(MessageKey.getConfig("_CONFIG_LANGUAGE"),
			MessageKey.getConfig("_CONFIG_LOCALE"));

	/**
	 * The pre API extension for orderItemAddCmd controller command. This
	 * command is used to add items to one or a list of orders.
	 * 
	 * @param ueRequest
	 *            The UERequest passed.
	 * 
	 * @return The response.
	 */

	@POST
	@Path("/order_item_add_pre")
	@Consumes({ MediaType.APPLICATION_JSON })
	@Produces({ MediaType.APPLICATION_JSON })
	@ApiOperation(value = "The pre API extension for orderItemAddCmd controller command.", notes = "| Command: com.ibm.commerce.orderitems.commands.OrderItemAddCmd |\n|----------|\n| OrderItemAddCmd is a controller command which is used to add items to one or a list of orders.|", response = OrderPreUEResponse.class,
		extensions = { 
	       @Extension( name = "data-command", properties = {
	           @ExtensionProperty(name = "Command", value = "com.ibm.commerce.orderitems.commands.OrderItemAddCmd")
	           })
	    })
	@ApiResponses(value = { @ApiResponse(code = 400, message = "Invalid Input Parameter"),
			@ApiResponse(code = 500, message = "Invalid Input Parameter") })
	public Response orderItemAddPre(
			@ApiParam(name = "orderItemAddPre UE input", value = "The UE Request String", required = true) OrderPreUERequest ueRequest) {

		Order orderPOJO = ueRequest.getOrder();
		if (orderPOJO != null) {
			List<OrderItem> orderitemPOJOs = orderPOJO.getOrderItem();
			if (orderitemPOJOs != null && !orderitemPOJOs.isEmpty()) {
				for (OrderItem orderitemPOJO : orderitemPOJOs) {
					LOGGER.info("orderItemId:"
							+ orderitemPOJO.getOrderItemIdentifier()
							+ " quantity:" + orderitemPOJO.getQuantity());
				}
			}
		}

		Map<String, Object> inputParameters = ueRequest.getCommandInputs();

		OrderPreUEResponse ueResponse = UserExitUtil.createPreUEResponse(orderPOJO, inputParameters);

		Response response = Response.ok(ueResponse).build();
		return response;

	}

	/**
	 * The replace API extension for orderItemAddCmd controller command. This
	 * command is used to add items to one or a list of orders.
	 * 
	 * @param ueRequest
	 *            The UERequest passed.
	 * 
	 * @return The response.
	 */

	@POST
	@Path("/order_item_add_replace")
	@Consumes({ MediaType.APPLICATION_JSON })
	@Produces({ MediaType.APPLICATION_JSON })
	@ApiOperation(value = "The replace API extension for orderItemAddCmd controller command.", notes = "| Command: com.ibm.commerce.orderitems.commands.OrderItemAddCmd |\n|----------|\n| OrderItemAddCmd is a controller command which is used to add items to one or a list of orders.|", response = OrderReplaceUEResponse.class,
		extensions = { 
	       @Extension( name = "data-command", properties = {
	           @ExtensionProperty(name = "Command", value = "com.ibm.commerce.orderitems.commands.OrderItemAddCmd")
	           })
	    })
	@ApiResponses(value = { @ApiResponse(code = 400, message = "Invalid Input Parameter"),
			@ApiResponse(code = 500, message = "Invalid Input Parameter") })
	public Response orderItemAddReplace(
			@ApiParam(name = "orderItemAddReplace UE input", value = "The UE Request String", required = true) OrderReplaceUERequest ueRequest) {

		Order orderPOJO = ueRequest.getOrder();
		if (orderPOJO != null) {
			List<OrderItem> orderitemPOJOs = orderPOJO.getOrderItem();
			if (orderitemPOJOs != null && !orderitemPOJOs.isEmpty()) {
				for (OrderItem orderitemPOJO : orderitemPOJOs) {
					LOGGER.info("orderItemId:"
							+ orderitemPOJO.getOrderItemIdentifier()
							+ " quantity:" + orderitemPOJO.getQuantity());
				}
			}
		}

		Map<String, Object> inputParameters = ueRequest.getCommandInputs();

		OrderReplaceUEResponse ueResponse = UserExitUtil.createReplaceUEResponse(orderPOJO, inputParameters);

		Response response = Response.ok(ueResponse).build();
		return response;

	}

	/**
	 * The post API extension for orderItemAddCmd controller command. This
	 * command is used to add items to one or a list of orders.
	 * 
	 * @param ueRequest
	 *            The UERequest passed.
	 * 
	 * @return The response.
	 */

	@POST
	@Path("/order_item_add_post")
	@Consumes({ MediaType.APPLICATION_JSON })
	@Produces({ MediaType.APPLICATION_JSON })
	@ApiOperation(value = "The post API extension for orderItemAddCmd controller command.", notes = "| Command: com.ibm.commerce.orderitems.commands.OrderItemAddCmd |\n|----------|\n| OrderItemAddCmd is a controller command which is used to add items to one or a list of orders.|", response = OrderPostUEResponse.class,
		extensions = { 
	       @Extension( name = "data-command", properties = {
	           @ExtensionProperty(name = "Command", value = "com.ibm.commerce.orderitems.commands.OrderItemAddCmd")
	           })
	    })
	@ApiResponses(value = { @ApiResponse(code = 400, message = "Invalid Input Parameter"),
			@ApiResponse(code = 500, message = "Invalid Input Parameter") })
	public Response orderItemAddPost(
			@ApiParam(name = "orderItemAddPost UE input", value = "The UE Request String", required = true) OrderPostUERequest ueRequest) {

		Order orderPOJO = ueRequest.getOrder();
		if (orderPOJO != null) {
			List<OrderItem> orderitemPOJOs = orderPOJO.getOrderItem();
			if (orderitemPOJOs != null && !orderitemPOJOs.isEmpty()) {
				for (OrderItem orderitemPOJO : orderitemPOJOs) {
					LOGGER.info("orderItemId:"
							+ orderitemPOJO.getOrderItemIdentifier()
							+ " quantity:" + orderitemPOJO.getQuantity());
				}
			}
		}

		Map<String, Object> inputParameters = ueRequest.getCommandInputs();

		OrderPostUEResponse ueResponse = UserExitUtil.createPostUEResponse(orderPOJO, inputParameters);

		Response response = Response.ok(ueResponse).build();
		return response;

	}

	/**
	 * The pre API extension for orderItemUpdateCmd controller command. This
	 * command is used to Updates one or more order items in the shopping cart.
	 * 
	 * @param ueRequest
	 *            The UERequest passed.
	 * 
	 * @return The response.
	 */

	@POST
	@Path("/order_item_update_pre")
	@Consumes({ MediaType.APPLICATION_JSON })
	@Produces({ MediaType.APPLICATION_JSON })
	@ApiOperation(value = "The pre API extension for orderItemUpdateCmd controller command.", notes = "| Command: com.ibm.commerce.orderitems.commands.OrderItemUpdateCmd |\n|----------|\n| orderItemUpdateCmd is a controller command which is used to Updates one or more order items in the shopping cart.|", response = OrderPreUEResponse.class,
		extensions = { 
	       @Extension( name = "data-command", properties = {
	           @ExtensionProperty(name = "Command", value = "com.ibm.commerce.orderitems.commands.OrderItemUpdateCmd")
	           })
	    })
	@ApiResponses(value = { @ApiResponse(code = 400, message = "Invalid Input Parameter"),
			@ApiResponse(code = 500, message = "Invalid Input Parameter") })
	public Response orderItemUpdatePre(
			@ApiParam(name = "orderItemUpdateCmdPre UE input", value = "The UE Request String", required = true) OrderPreUERequest ueRequest) {

		Order orderPOJO = ueRequest.getOrder();
		if (orderPOJO != null) {
			List<OrderItem> orderitemPOJOs = orderPOJO.getOrderItem();
			if (orderitemPOJOs != null && !orderitemPOJOs.isEmpty()) {
				for (OrderItem orderitemPOJO : orderitemPOJOs) {
					LOGGER.info("orderItemId:"
							+ orderitemPOJO.getOrderItemIdentifier()
							+ " quantity:" + orderitemPOJO.getQuantity());
				}
			}
		}

		Map<String, Object> inputParameters = ueRequest.getCommandInputs();

		OrderPreUEResponse ueResponse = UserExitUtil.createPreUEResponse(orderPOJO, inputParameters);

		Response response = Response.ok(ueResponse).build();
		return response;

	}

	/**
	 * The replace API extension for orderItemUpdateCmd controller command. This
	 * command is used to Updates one or more order items in the shopping cart.
	 * 
	 * @param ueRequest
	 *            The UERequest passed.
	 * 
	 * @return The response.
	 */

	@POST
	@Path("/order_item_update_replace")
	@Consumes({ MediaType.APPLICATION_JSON })
	@Produces({ MediaType.APPLICATION_JSON })
	@ApiOperation(value = "The replace API extension for orderItemUpdateCmd controller command.", notes = "| Command: com.ibm.commerce.orderitems.commands.OrderItemUpdateCmd |\n|----------|\n| orderItemUpdateCmd is a controller command which is used to Updates one or more order items in the shopping cart.|", response = OrderReplaceUEResponse.class,
		extensions = { 
	       @Extension( name = "data-command", properties = {
	           @ExtensionProperty(name = "Command", value = "com.ibm.commerce.orderitems.commands.OrderItemUpdateCmd")
	           })
	    })
	@ApiResponses(value = { @ApiResponse(code = 400, message = "Invalid Input Parameter"),
			@ApiResponse(code = 500, message = "Invalid Input Parameter") })
	public Response orderItemUpdateReplace(
			@ApiParam(name = "orderItemUpdateCmdReplace UE input", value = "The UE Request String", required = true) OrderReplaceUERequest ueRequest) {

		Order orderPOJO = ueRequest.getOrder();
		if (orderPOJO != null) {
			List<OrderItem> orderitemPOJOs = orderPOJO.getOrderItem();
			if (orderitemPOJOs != null && !orderitemPOJOs.isEmpty()) {
				for (OrderItem orderitemPOJO : orderitemPOJOs) {
					LOGGER.info("orderItemId:"
							+ orderitemPOJO.getOrderItemIdentifier()
							+ " quantity:" + orderitemPOJO.getQuantity());
				}
			}
		}

		Map<String, Object> inputParameters = ueRequest.getCommandInputs();

		OrderReplaceUEResponse ueResponse = UserExitUtil.createReplaceUEResponse(orderPOJO, inputParameters);

		Response response = Response.ok(ueResponse).build();
		return response;

	}

	/**
	 * The post API extension for orderItemUpdateCmd controller command. This
	 * command is used to Updates one or more order items in the shopping cart.
	 * 
	 * @param ueRequest
	 *            The UERequest passed.
	 * 
	 * @return The response.
	 */

	@POST
	@Path("/order_item_update_post")
	@Consumes({ MediaType.APPLICATION_JSON })
	@Produces({ MediaType.APPLICATION_JSON })
	@ApiOperation(value = "The post API extension for orderItemUpdateCmd controller command.", notes = "| Command: com.ibm.commerce.orderitems.commands.OrderItemUpdateCmd |\n|----------|\n| orderItemUpdateCmd is a controller command which is used to Updates one or more order items in the shopping cart.|", response = OrderPostUEResponse.class,
		extensions = { 
	       @Extension( name = "data-command", properties = {
	           @ExtensionProperty(name = "Command", value = "com.ibm.commerce.orderitems.commands.OrderItemUpdateCmd")
	           })
	    })
	@ApiResponses(value = { @ApiResponse(code = 400, message = "Invalid Input Parameter"),
			@ApiResponse(code = 500, message = "Invalid Input Parameter") })
	public Response orderItemUpdatePost(
			@ApiParam(name = "orderItemUpdateCmdPost UE input", value = "The UE Request String", required = true) OrderPostUERequest ueRequest) {

		Order orderPOJO = ueRequest.getOrder();
		if (orderPOJO != null) {
			List<OrderItem> orderitemPOJOs = orderPOJO.getOrderItem();
			if (orderitemPOJOs != null && !orderitemPOJOs.isEmpty()) {
				for (OrderItem orderitemPOJO : orderitemPOJOs) {
					LOGGER.info("orderItemId:"
							+ orderitemPOJO.getOrderItemIdentifier()
							+ " quantity:" + orderitemPOJO.getQuantity());
				}
			}
		}

		Map<String, Object> inputParameters = ueRequest.getCommandInputs();

		OrderPostUEResponse ueResponse = UserExitUtil.createPostUEResponse(orderPOJO, inputParameters);

		Response response = Response.ok(ueResponse).build();
		return response;

	}

	/**
	 * The pre API extension for OrderProcessCmd controller command.
	 * OrderProcessCmd is a controller command which is used to submit an order.
	 * The order must have been locked by OrderPrepare. Once the OrderProcess
	 * command begins running, the order cannot be cancelled with OrderCancel.
	 * 
	 * @param ueRequest
	 *            The UERequest passed.
	 * 
	 * @return The response.
	 */

	@POST
	@Path("/order_process_pre")
	@Consumes({ MediaType.APPLICATION_JSON })
	@Produces({ MediaType.APPLICATION_JSON })
	@ApiOperation(value = "The pre API extension for OrderProcessCmd controller command.", notes = "| Command: com.ibm.commerce.order.commands.OrderProcessCmd |\n|----------|\n| OrderProcessCmd is a controller command which is used to submit an order. The order must have been locked by OrderPrepare. Once the  OrderProcess command begins running, the order cannot be cancelled with OrderCancel.|", response = OrderPreUEResponse.class,
		extensions = { 
	       @Extension( name = "data-command", properties = {
	           @ExtensionProperty(name = "Command", value = "com.ibm.commerce.order.commands.OrderProcessCmd")
	           })
	    })
	@ApiResponses(value = { @ApiResponse(code = 400, message = "Invalid Input Parameter"),
			@ApiResponse(code = 500, message = "Invalid Input Parameter") })
	public Response OrderProcessPre(
			@ApiParam(name = "OrderProcessCmdPre UE input", value = "The UE Request String", required = true) OrderPreUERequest ueRequest) {

		Order orderPOJO = ueRequest.getOrder();
		if (orderPOJO != null) {
			List<OrderItem> orderitemPOJOs = orderPOJO.getOrderItem();
			if (orderitemPOJOs != null && !orderitemPOJOs.isEmpty()) {
				for (OrderItem orderitemPOJO : orderitemPOJOs) {
					LOGGER.info("orderItemId:"
							+ orderitemPOJO.getOrderItemIdentifier()
							+ " quantity:" + orderitemPOJO.getQuantity());
				}
			}
		}

		Map<String, Object> inputParameters = ueRequest.getCommandInputs();

		OrderPreUEResponse ueResponse = UserExitUtil.createPreUEResponse(orderPOJO, inputParameters);

		Response response = Response.ok(ueResponse).build();
		return response;

	}

	/**
	 * The replace API extension for OrderProcessCmd controller command. This
	 * command is used to Updates one or more order items in the shopping cart.
	 * 
	 * @param ueRequest
	 *            The UERequest passed.
	 * 
	 * @return The response.
	 */

	@POST
	@Path("/order_process_replace")
	@Consumes({ MediaType.APPLICATION_JSON })
	@Produces({ MediaType.APPLICATION_JSON })
	@ApiOperation(value = "The replace API extension for OrderProcessCmd controller command.", notes = "| Command: com.ibm.commerce.order.commands.OrderProcessCmd |\n|----------|\n| OrderProcessCmd is a controller command which is used to submit an order. The order must have been locked by OrderPrepare. Once the  OrderProcess command begins running, the order cannot be cancelled with OrderCancel.|", response = OrderReplaceUEResponse.class,
		extensions = { 
	       @Extension( name = "data-command", properties = {
	           @ExtensionProperty(name = "Command", value = "com.ibm.commerce.order.commands.OrderProcessCmd")
	           })
	    })
	@ApiResponses(value = { @ApiResponse(code = 400, message = "Invalid Input Parameter"),
			@ApiResponse(code = 500, message = "Invalid Input Parameter") })
	public Response OrderProcessReplace(
			@ApiParam(name = "OrderProcessCmdReplace UE input", value = "The UE Request String", required = true) OrderReplaceUERequest ueRequest) {

		Order orderPOJO = ueRequest.getOrder();
		if (orderPOJO != null) {
			List<OrderItem> orderitemPOJOs = orderPOJO.getOrderItem();
			if (orderitemPOJOs != null && !orderitemPOJOs.isEmpty()) {
				for (OrderItem orderitemPOJO : orderitemPOJOs) {
					LOGGER.info("orderItemId:"
							+ orderitemPOJO.getOrderItemIdentifier()
							+ " quantity:" + orderitemPOJO.getQuantity());
				}
			}
		}

		Map<String, Object> inputParameters = ueRequest.getCommandInputs();

		OrderReplaceUEResponse ueResponse = UserExitUtil.createReplaceUEResponse(orderPOJO, inputParameters);

		Response response = Response.ok(ueResponse).build();
		return response;

	}

	/**
	 * The post API extension for OrderProcessCmd controller command. This
	 * command is used to Updates one or more order items in the shopping cart.
	 * 
	 * @param ueRequest
	 *            The UERequest passed.
	 * 
	 * @return The response.
	 */

	@POST
	@Path("/order_process_post")
	@Consumes({ MediaType.APPLICATION_JSON })
	@Produces({ MediaType.APPLICATION_JSON })
	@ApiOperation(value = "The post API extension for OrderProcessCmd controller command.", notes = "| Command: com.ibm.commerce.order.commands.OrderProcessCmd |\n|----------|\n| OrderProcessCmd is a controller command which is used to submit an order. The order must have been locked by OrderPrepare. Once the  OrderProcess command begins running, the order cannot be cancelled with OrderCancel.|", response = OrderPostUEResponse.class,
		extensions = { 
	       @Extension( name = "data-command", properties = {
	           @ExtensionProperty(name = "Command", value = "com.ibm.commerce.order.commands.OrderProcessCmd")
	           })
	    })
	@ApiResponses(value = { @ApiResponse(code = 400, message = "Invalid Input Parameter"),
			@ApiResponse(code = 500, message = "Invalid Input Parameter") })
	public Response OrderProcessPost(
			@ApiParam(name = "OrderProcessCmdPost UE input", value = "The UE Request String", required = true) OrderPostUERequest ueRequest) {

		Order orderPOJO = ueRequest.getOrder();
		if (orderPOJO != null) {
			List<OrderItem> orderitemPOJOs = orderPOJO.getOrderItem();
			if (orderitemPOJOs != null && !orderitemPOJOs.isEmpty()) {
				for (OrderItem orderitemPOJO : orderitemPOJOs) {
					LOGGER.info("orderItemId:"
							+ orderitemPOJO.getOrderItemIdentifier()
							+ " quantity:" + orderitemPOJO.getQuantity());
				}
			}
		}

		Map<String, Object> inputParameters = ueRequest.getCommandInputs();

		OrderPostUEResponse ueResponse = UserExitUtil.createPostUEResponse(orderPOJO, inputParameters);

		Response response = Response.ok(ueResponse).build();
		return response;

	}

	/**
	 * The pre API extension for OrderPrepareCmd controller command.
	 * OrderPrepareCmd is a controller command which is used to prepare an order
	 * by determining prices, discounts, shipping charges, shipping adjustment,
	 * and taxes for an order. If an order reference number is not specified,
	 * all current pending orders will be prepared for the current customer at
	 * the given store.
	 * 
	 * @param ueRequest
	 *            The UERequest passed.
	 * 
	 * @return The response.
	 */

	@POST
	@Path("/order_prepare_pre")
	@Consumes({ MediaType.APPLICATION_JSON })
	@Produces({ MediaType.APPLICATION_JSON })
	@ApiOperation(value = "The pre API extension for OrderPrepareCmd controller command.", notes = "| Command: com.ibm.commerce.order.commands.OrderPrepareCmd |\n|----------|\n| OrderPrepareCmd is a controller command which is used to prepare an order by determining prices, discounts, shipping charges, shipping adjustment,and taxes for an order. If an order reference number is not specified,all current pending orders will be prepared for the current customer at the given store.|", response = OrderPreUEResponse.class,
		extensions = { 
	       @Extension( name = "data-command", properties = {
	           @ExtensionProperty(name = "Command", value = "com.ibm.commerce.order.commands.OrderPrepareCmd")
	           })
	    })
	@ApiResponses(value = { @ApiResponse(code = 400, message = "Invalid Input Parameter"),
			@ApiResponse(code = 500, message = "Invalid Input Parameter") })
	public Response OrderPreparePre(
			@ApiParam(name = "OrderPrepareCmdPre UE input", value = "The UE Request String", required = true) OrderPreUERequest ueRequest) {

		Order orderPOJO = ueRequest.getOrder();
		if (orderPOJO != null) {
			List<OrderItem> orderitemPOJOs = orderPOJO.getOrderItem();
			if (orderitemPOJOs != null && !orderitemPOJOs.isEmpty()) {
				for (OrderItem orderitemPOJO : orderitemPOJOs) {
					LOGGER.info("orderItemId:"
							+ orderitemPOJO.getOrderItemIdentifier()
							+ " quantity:" + orderitemPOJO.getQuantity());
				}
			}
		}

		Map<String, Object> inputParameters = ueRequest.getCommandInputs();

		OrderPreUEResponse ueResponse = UserExitUtil.createPreUEResponse(orderPOJO, inputParameters);

		Response response = Response.ok(ueResponse).build();
		return response;

	}

	/**
	 * The replace API extension for OrderPrepareCmd controller command.
	 * OrderPrepareCmd is a controller command which is used to prepare an order
	 * by determining prices, discounts, shipping charges, shipping adjustment,
	 * and taxes for an order. If an order reference number is not specified,
	 * all current pending orders will be prepared for the current customer at
	 * the given store.
	 * 
	 * @param ueRequest
	 *            The UERequest passed.
	 * 
	 * @return The response.
	 */

	@POST
	@Path("/order_prepare_replace")
	@Consumes({ MediaType.APPLICATION_JSON })
	@Produces({ MediaType.APPLICATION_JSON })
	@ApiOperation(value = "The replace API extension for OrderPrepareCmd controller command.", notes = "| Command: com.ibm.commerce.order.commands.OrderPrepareCmd |\n|----------|\n| OrderPrepareCmd is a controller command which is used to prepare an order by determining prices, discounts, shipping charges, shipping adjustment,and taxes for an order. If an order reference number is not specified,all current pending orders will be prepared for the current customer at the given store.|", response = OrderReplaceUEResponse.class,
		extensions = { 
	       @Extension( name = "data-command", properties = {
	           @ExtensionProperty(name = "Command", value = "com.ibm.commerce.order.commands.OrderPrepareCmd")
	           })
	    })
	@ApiResponses(value = { @ApiResponse(code = 400, message = "Invalid Input Parameter"),
			@ApiResponse(code = 500, message = "Invalid Input Parameter") })
	public Response OrderPrepareReplace(
			@ApiParam(name = "OrderPrepareCmdReplace UE input", value = "The UE Request String", required = true) OrderReplaceUERequest ueRequest) {

		Order orderPOJO = ueRequest.getOrder();
		if (orderPOJO != null) {
			List<OrderItem> orderitemPOJOs = orderPOJO.getOrderItem();
			if (orderitemPOJOs != null && !orderitemPOJOs.isEmpty()) {
				for (OrderItem orderitemPOJO : orderitemPOJOs) {
					LOGGER.info("orderItemId:"
							+ orderitemPOJO.getOrderItemIdentifier()
							+ " quantity:" + orderitemPOJO.getQuantity());
				}
			}
		}

		Map<String, Object> inputParameters = ueRequest.getCommandInputs();

		OrderReplaceUEResponse ueResponse = UserExitUtil.createReplaceUEResponse(orderPOJO, inputParameters);

		Response response = Response.ok(ueResponse).build();
		return response;

	}

	/**
	 * The post API extension for OrderPrepareCmd controller command.
	 * OrderPrepareCmd is a controller command which is used to prepare an order
	 * by determining prices, discounts, shipping charges, shipping adjustment,
	 * and taxes for an order. If an order reference number is not specified,
	 * all current pending orders will be prepared for the current customer at
	 * the given store.
	 * 
	 * @param ueRequest
	 *            The UERequest passed.
	 * 
	 * @return The response.
	 */

	@POST
	@Path("/order_prepare_post")
	@Consumes({ MediaType.APPLICATION_JSON })
	@Produces({ MediaType.APPLICATION_JSON })
	@ApiOperation(value = "The post API extension for OrderPrepareCmd controller command.", notes = "| Command: com.ibm.commerce.order.commands.OrderPrepareCmd |\n|----------|\n| OrderPrepareCmd is a controller command which is used to prepare an order by determining prices, discounts, shipping charges, shipping adjustment,and taxes for an order. If an order reference number is not specified,all current pending orders will be prepared for the current customer at the given store.|", response = OrderPostUEResponse.class,
		extensions = { 
	       @Extension( name = "data-command", properties = {
	           @ExtensionProperty(name = "Command", value = "com.ibm.commerce.order.commands.OrderPrepareCmd")
	           })
	    })
	@ApiResponses(value = { @ApiResponse(code = 400, message = "Invalid Input Parameter"),
			@ApiResponse(code = 500, message = "Invalid Input Parameter") })
	public Response OrderPreparePost(
			@ApiParam(name = "OrderPrepareCmdPre UE input", value = "The UE Request String", required = true) OrderPostUERequest ueRequest) {

		Order orderPOJO = ueRequest.getOrder();
		if (orderPOJO != null) {
			List<OrderItem> orderitemPOJOs = orderPOJO.getOrderItem();
			if (orderitemPOJOs != null && !orderitemPOJOs.isEmpty()) {
				for (OrderItem orderitemPOJO : orderitemPOJOs) {
					LOGGER.info("orderItemId:"
							+ orderitemPOJO.getOrderItemIdentifier()
							+ " quantity:" + orderitemPOJO.getQuantity());
				}
			}
		}

		Map<String, Object> inputParameters = ueRequest.getCommandInputs();

		OrderPostUEResponse ueResponse = UserExitUtil.createPostUEResponse(orderPOJO, inputParameters);

		Response response = Response.ok(ueResponse).build();
		return response;

	}

	/**
	 * The pre API extension for OrderCalculateCmd controller command.
	 * OrderCalculateCmd is a controller command which is used to re-calculate
	 * specified calculation usages. <br>
	 * This command is called by
	 * {@link com.ibm.commerce.orderitems.commands.OrderItemBaseCmdImpl} and
	 * {@link com.ibm.commerce.orderitems.commands.OrderItemDeleteCmdImpl} to
	 * refresh the order price, charges and freebie items after Add, Update and
	 * Delete order item.<br>
	 * 
	 * @param ueRequest
	 *            The UERequest passed.
	 * 
	 * @return The response.
	 */

	@POST
	@Path("/order_calculate_pre")
	@Consumes({ MediaType.APPLICATION_JSON })
	@Produces({ MediaType.APPLICATION_JSON })
	@ApiOperation(value = "The pre API extension for OrderCalculateCmd controller command.", notes = "| Command: com.ibm.commerce.order.commands.OrderCalculateCmd |\n|----------|\n| OrderCalculateCmd is a controller command which is used to re-calculate specified calculation usages.<br> This command is called by OrderItemBaseCmdImpl and OrderItemDeleteCmdImpl to refresh the order price, charges and freebie items after Add, Update and Delete order item.<br>|", response = OrderPreUEResponse.class,
		extensions = { 
	       @Extension( name = "data-command", properties = {
	           @ExtensionProperty(name = "Command", value = "com.ibm.commerce.order.commands.OrderCalculateCmd")
	           })
	    })
	@ApiResponses(value = { @ApiResponse(code = 400, message = "Invalid Input Parameter"),
			@ApiResponse(code = 500, message = "Invalid Input Parameter") })
	public Response OrderCalculatePre(
			@ApiParam(name = "OrderCalculateCmdPre UE input", value = "The UE Request String", required = true) OrderPreUERequest ueRequest) {

		Order orderPOJO = ueRequest.getOrder();
		if (orderPOJO != null) {
			List<OrderItem> orderitemPOJOs = orderPOJO.getOrderItem();
			if (orderitemPOJOs != null && !orderitemPOJOs.isEmpty()) {
				for (OrderItem orderitemPOJO : orderitemPOJOs) {
					LOGGER.info("orderItemId:"
							+ orderitemPOJO.getOrderItemIdentifier()
							+ " quantity:" + orderitemPOJO.getQuantity());
				}
			}
		}

		Map<String, Object> inputParameters = ueRequest.getCommandInputs();

		OrderPreUEResponse ueResponse = UserExitUtil.createPreUEResponse(orderPOJO, inputParameters);

		Response response = Response.ok(ueResponse).build();
		return response;

	}

	/**
	 * The replace API extension for OrderCalculateCmd controller command.
	 * OrderCalculateCmd is a controller command which is used to re-calculate
	 * specified calculation usages. <br>
	 * This command is called by
	 * {@link com.ibm.commerce.orderitems.commands.OrderItemBaseCmdImpl} and
	 * {@link com.ibm.commerce.orderitems.commands.OrderItemDeleteCmdImpl} to
	 * refresh the order price, charges and freebie items after Add, Update and
	 * Delete order item.<br>
	 * 
	 * @param ueRequest
	 *            The UERequest passed.
	 * 
	 * @return The response.
	 */

	@POST
	@Path("/order_calculate_replace")
	@Consumes({ MediaType.APPLICATION_JSON })
	@Produces({ MediaType.APPLICATION_JSON })
	@ApiOperation(value = "The replace API extension for OrderCalculateCmd controller command.", notes = "| Command: com.ibm.commerce.order.commands.OrderCalculateCmd |\n|----------|\n| OrderCalculateCmd is a controller command which is used to re-calculate specified calculation usages.<br> This command is called by OrderItemBaseCmdImpl and OrderItemDeleteCmdImpl to refresh the order price, charges and freebie items after Add, Update and Delete order item.<br>|", response = OrderReplaceUEResponse.class,
		extensions = { 
	       @Extension( name = "data-command", properties = {
	           @ExtensionProperty(name = "Command", value = "com.ibm.commerce.order.commands.OrderCalculateCmd")
	           })
	    })
	@ApiResponses(value = { @ApiResponse(code = 400, message = "Invalid Input Parameter"),
			@ApiResponse(code = 500, message = "Invalid Input Parameter") })
	public Response OrderCalculateReplace(
			@ApiParam(name = "OrderCalculateCmdReplace UE input", value = "The UE Request String", required = true) OrderReplaceUERequest ueRequest) {

		Order orderPOJO = ueRequest.getOrder();
		if (orderPOJO != null) {
			List<OrderItem> orderitemPOJOs = orderPOJO.getOrderItem();
			if (orderitemPOJOs != null && !orderitemPOJOs.isEmpty()) {
				for (OrderItem orderitemPOJO : orderitemPOJOs) {
					LOGGER.info("orderItemId:"
							+ orderitemPOJO.getOrderItemIdentifier()
							+ " quantity:" + orderitemPOJO.getQuantity());
				}
			}
		}

		Map<String, Object> inputParameters = ueRequest.getCommandInputs();

		OrderReplaceUEResponse ueResponse = UserExitUtil.createReplaceUEResponse(orderPOJO, inputParameters);

		Response response = Response.ok(ueResponse).build();
		return response;

	}

	/**
	 * The post API extension for OrderCalculateCmd controller command.
	 * OrderCalculateCmd is a controller command which is used to re-calculate
	 * specified calculation usages. <br>
	 * This command is called by
	 * {@link com.ibm.commerce.orderitems.commands.OrderItemBaseCmdImpl} and
	 * {@link com.ibm.commerce.orderitems.commands.OrderItemDeleteCmdImpl} to
	 * refresh the order price, charges and freebie items after Add, Update and
	 * Delete order item.<br>
	 * 
	 * @param ueRequest
	 *            The UERequest passed.
	 * 
	 * @return The response.
	 */

	@POST
	@Path("/order_calculate_post")
	@Consumes({ MediaType.APPLICATION_JSON })
	@Produces({ MediaType.APPLICATION_JSON })
	@ApiOperation(value = "The post API extension for OrderCalculateCmd controller command.", notes = "| Command: com.ibm.commerce.order.commands.OrderCalculateCmd |\n|----------|\n| OrderCalculateCmd is a controller command which is used to re-calculate specified calculation usages.<br> This command is called by OrderItemBaseCmdImpl and OrderItemDeleteCmdImpl to refresh the order price, charges and freebie items after Add, Update and Delete order item.<br>|", response = OrderPostUEResponse.class,
		extensions = { 
	       @Extension( name = "data-command", properties = {
	           @ExtensionProperty(name = "Command", value = "com.ibm.commerce.order.commands.OrderCalculateCmd")
	           })
	    })
	@ApiResponses(value = { @ApiResponse(code = 400, message = "Invalid Input Parameter"),
			@ApiResponse(code = 500, message = "Invalid Input Parameter") })
	public Response OrderCalculatePost(
			@ApiParam(name = "OrderCalculateCmdPost UE input", value = "The UE Request String", required = true) OrderPostUERequest ueRequest) {

		Order orderPOJO = ueRequest.getOrder();
		if (orderPOJO != null) {
			List<OrderItem> orderitemPOJOs = orderPOJO.getOrderItem();
			if (orderitemPOJOs != null && !orderitemPOJOs.isEmpty()) {
				for (OrderItem orderitemPOJO : orderitemPOJOs) {
					LOGGER.info("orderItemId:"
							+ orderitemPOJO.getOrderItemIdentifier()
							+ " quantity:" + orderitemPOJO.getQuantity());
				}
			}
		}

		Map<String, Object> inputParameters = ueRequest.getCommandInputs();

		OrderPostUEResponse ueResponse = UserExitUtil.createPostUEResponse(orderPOJO, inputParameters);

		Response response = Response.ok(ueResponse).build();
		return response;

	}

	/**
	 * The pre API extension for OrderItemDeleteCmd controller command.
	 * OrderItemDeleteCmd is a controller command which is used to delete some
	 * order items from one or more pending orders for some
	 * <samp>orderitemIds</samp> or product.
	 * 
	 * @param ueRequest
	 *            The UERequest passed.
	 * 
	 * @return The response.
	 */

	@POST
	@Path("/order_item_delete_pre")
	@Consumes({ MediaType.APPLICATION_JSON })
	@Produces({ MediaType.APPLICATION_JSON })
	@ApiOperation(value = "The pre API extension for OrderItemDeleteCmd controller command.", notes = "| Command: com.ibm.commerce.orderitems.commands.OrderItemDeleteCmd |\n|----------|\n| OrderItemDeleteCmd is a controller command which is used to delete some order items from one or more pending orders for some orderitemIds or product.|", response = OrderPreUEResponse.class,
		extensions = { 
	       @Extension( name = "data-command", properties = {
	           @ExtensionProperty(name = "Command", value = "com.ibm.commerce.orderitems.commands.OrderItemDeleteCmd")
	           })
	    })
	@ApiResponses(value = { @ApiResponse(code = 400, message = "Invalid Input Parameter"),
			@ApiResponse(code = 500, message = "Invalid Input Parameter") })
	public Response OrderItemDeletePre(
			@ApiParam(name = "OrderDeleteCmdPre UE input", value = "The UE Request String", required = true) OrderPreUERequest ueRequest) {

		Order orderPOJO = ueRequest.getOrder();
		if (orderPOJO != null) {
			List<OrderItem> orderitemPOJOs = orderPOJO.getOrderItem();
			if (orderitemPOJOs != null && !orderitemPOJOs.isEmpty()) {
				for (OrderItem orderitemPOJO : orderitemPOJOs) {
					LOGGER.info("orderItemId:"
							+ orderitemPOJO.getOrderItemIdentifier()
							+ " quantity:" + orderitemPOJO.getQuantity());
				}
			}
		}

		Map<String, Object> inputParameters = ueRequest.getCommandInputs();

		OrderPreUEResponse ueResponse = UserExitUtil.createPreUEResponse(orderPOJO, inputParameters);

		Response response = Response.ok(ueResponse).build();
		return response;

	}

	/**
	 * The replace API extension for OrderItemDeleteCmd controller command.
	 * OrderItemDeleteCmd is a controller command which is used to delete some
	 * order items from one or more pending orders for some
	 * <samp>orderitemIds</samp> or product.
	 * 
	 * @param ueRequest
	 *            The UERequest passed.
	 * 
	 * @return The response.
	 */

	@POST
	@Path("/order_item_delete_replace")
	@Consumes({ MediaType.APPLICATION_JSON })
	@Produces({ MediaType.APPLICATION_JSON })
	@ApiOperation(value = "The replace API extension for OrderItemDeleteCmd controller command.", notes = "| Command: com.ibm.commerce.orderitems.commands.OrderItemDeleteCmd |\n|----------|\n| OrderItemDeleteCmd is a controller command which is used to delete some order items from one or more pending orders for some orderitemIds or product.|", response = OrderReplaceUEResponse.class,
		extensions = { 
	       @Extension( name = "data-command", properties = {
	           @ExtensionProperty(name = "Command", value = "com.ibm.commerce.orderitems.commands.OrderItemDeleteCmd")
	           })
	    })
	@ApiResponses(value = { @ApiResponse(code = 400, message = "Invalid Input Parameter"),
			@ApiResponse(code = 500, message = "Invalid Input Parameter") })
	public Response OrderItemDeleteReplace(
			@ApiParam(name = "OrderDeleteCmdReplace UE input", value = "The UE Request String", required = true) OrderReplaceUERequest ueRequest) {

		Order orderPOJO = ueRequest.getOrder();
		if (orderPOJO != null) {
			List<OrderItem> orderitemPOJOs = orderPOJO.getOrderItem();
			if (orderitemPOJOs != null && !orderitemPOJOs.isEmpty()) {
				for (OrderItem orderitemPOJO : orderitemPOJOs) {
					LOGGER.info("orderItemId:"
							+ orderitemPOJO.getOrderItemIdentifier()
							+ " quantity:" + orderitemPOJO.getQuantity());
				}
			}
		}

		Map<String, Object> inputParameters = ueRequest.getCommandInputs();

		OrderReplaceUEResponse ueResponse = UserExitUtil.createReplaceUEResponse(orderPOJO, inputParameters);

		Response response = Response.ok(ueResponse).build();
		return response;

	}

	/**
	 * The post API extension for OrderItemDeleteCmd controller command.
	 * OrderItemDeleteCmd is a controller command which is used to delete some
	 * order items from one or more pending orders for some
	 * <samp>orderitemIds</samp> or product.
	 * 
	 * @param ueRequest
	 *            The UERequest passed.
	 * 
	 * @return The response.
	 */

	@POST
	@Path("/order_item_delete_post")
	@Consumes({ MediaType.APPLICATION_JSON })
	@Produces({ MediaType.APPLICATION_JSON })
	@ApiOperation(value = "The post API extension for OrderItemDeleteCmd controller command.", notes = "| Command: com.ibm.commerce.orderitems.commands.OrderItemDeleteCmd |\n|----------|\n| OrderItemDeleteCmd is a controller command which is used to delete some order items from one or more pending orders for some orderitemIds or product.|", response = OrderPostUEResponse.class,
		extensions = { 
	       @Extension( name = "data-command", properties = {
	           @ExtensionProperty(name = "Command", value = "com.ibm.commerce.orderitems.commands.OrderItemDeleteCmd")
	           })
	    })
	@ApiResponses(value = { @ApiResponse(code = 400, message = "Invalid Input Parameter"),
			@ApiResponse(code = 500, message = "Invalid Input Parameter") })
	public Response OrderItemDeletePost(
			@ApiParam(name = "OrderDeleteCmdPoste UE input", value = "The UE Request String", required = true) OrderPostUERequest ueRequest) {

		Order orderPOJO = ueRequest.getOrder();
		if (orderPOJO != null) {
			List<OrderItem> orderitemPOJOs = orderPOJO.getOrderItem();
			if (orderitemPOJOs != null && !orderitemPOJOs.isEmpty()) {
				for (OrderItem orderitemPOJO : orderitemPOJOs) {
					LOGGER.info("orderItemId:"
							+ orderitemPOJO.getOrderItemIdentifier()
							+ " quantity:" + orderitemPOJO.getQuantity());
				}
			}
		}

		Map<String, Object> inputParameters = ueRequest.getCommandInputs();

		OrderPostUEResponse ueResponse = UserExitUtil.createPostUEResponse(orderPOJO, inputParameters);

		Response response = Response.ok(ueResponse).build();
		return response;

	}

	/**
	 * Validate quantity limit against the order.
	 * 
	 * @param ueRequest
	 *            The UERequest passed.
	 * 
	 * @return The response.
	 */

	@POST
	@Path("/validate_quantity")
	@Consumes({ MediaType.APPLICATION_JSON })
	@Produces({ MediaType.APPLICATION_JSON })
	@ApiOperation(value = "The validate_quantity command validates the quantity limitation against the order.", notes="Command: com.ibm.commerce.orderitems.commands.OrderItemAddCmd", response = OrderPreUEResponse.class,
			extensions = { 
		       @Extension( name = "data-command", properties = {
		           @ExtensionProperty(name = "Command", value = "com.ibm.commerce.orderitems.commands.OrderItemAddCmd")
		           })
		    })
	@ApiResponses(value = { @ApiResponse(code = 400, message = "Invalid Input Parameter"),
			@ApiResponse(code = 500, message = "Invalid Input Parameter") })
	public Response validateQuantity(
			@ApiParam(name = "validateQuantity UE input", value = "The UE Request String", required = true) OrderPreUERequest ueRequest) {

		final String METHOD_NAME = "validateQuantity()";
		if (LOGGER.isLoggable(Level.FINER)) {
			LOGGER.entering(CLASS_NAME, METHOD_NAME, new Object[] {});
		}
		
		String id = null;
		if(request != null){
			id = request.getHeader(requestId);
		}
		

		Order orderPOJO = ueRequest.getOrder();

		Map<String, Double> catentryIdToTotalQuantity = new HashMap<String, Double>();
		if (orderPOJO != null) {
			List<OrderItem> orderitemPOJOs = orderPOJO.getOrderItem();
			if (orderitemPOJOs != null && !orderitemPOJOs.isEmpty()) {
				for (OrderItem orderitemPOJO : orderitemPOJOs) {
					Quantity quantity = orderitemPOJO.getQuantity();
					if (quantity != null) {
						double currentQuantity = quantity.getValue();
						String catentryId = orderitemPOJO.getCatalogEntryIdentifier().getUniqueID();
						Double totalQuantityInOrder = catentryIdToTotalQuantity.get(catentryId);
						if (totalQuantityInOrder == null) {
							totalQuantityInOrder = 0.0;
						}
						totalQuantityInOrder = totalQuantityInOrder + currentQuantity;
						catentryIdToTotalQuantity.put(catentryId, totalQuantityInOrder);
					}
				}
			}
			LOGGER.info("all total quantities by catentryId = " + catentryIdToTotalQuantity);
		} else {
			LOGGER.info("order is null. all total quantities by catentryId = " + catentryIdToTotalQuantity);
		}

		Map<String, Object> requestPropertyPOJOs = ueRequest.getCommandInputs();
		Map<String, CQ> indexToCQMap = new HashMap<String, CQ>();
		if (requestPropertyPOJOs != null && !requestPropertyPOJOs.isEmpty()) {
			for (Entry<String, Object> entry : requestPropertyPOJOs.entrySet()) {
				String name = entry.getKey();
				if (name != null && (name.startsWith("quantity_") || name.startsWith("catEntryId_")
						|| name.startsWith("orderItemId_"))) {
					int lastUnderscoreIndex = name.indexOf('_');
					String index = name.substring(lastUnderscoreIndex + 1);
					CQ cq = indexToCQMap.get(index);
					if (cq == null) {
						cq = new CQ();
						indexToCQMap.put(index, cq);
					}

					String value = (String) requestPropertyPOJOs.get(name);
					if (name.startsWith("quantity_")) {
						cq.quantity = Double.valueOf(value);
					} else if (name.startsWith("catEntryId_")) {
						// no catentryId for OrderItemUpdateCmd,
						// use orderItemId_ to get catentryID
						cq.catentryId = value;
					} else {
						if (orderPOJO != null) {
							List<OrderItem> orderitemPOJOs = orderPOJO.getOrderItem();
							if (orderitemPOJOs != null && !orderitemPOJOs.isEmpty()) {
								for (OrderItem orderitemPOJO : orderitemPOJOs) {
									String catentryId = orderitemPOJO.getOrderItemIdentifier().getUniqueID();
									if (catentryId.equals(value)) {
										cq.catentryId = catentryId;
									}
								}
							}
						}
					}
				}

			}
		}
		LOGGER.info("indexToCQMap = " + indexToCQMap);

		for (CQ cq : indexToCQMap.values()) {
			String catentryId = cq.catentryId;
			Double requestQuantity = cq.quantity;
			if (catentryId != null && requestQuantity != null) {
				// addToTotal(catentryIdToTotalQuantity, catentryId,
				// requestQuantity);
				// For OrderItemUpdateCmd, it should replace qty here.
				catentryIdToTotalQuantity.put(catentryId, requestQuantity);
			}
		}

		LOGGER.info(
				"all total quantities after adding request properties by catentryId = " + catentryIdToTotalQuantity);

		for (Entry<String, Double> entry : catentryIdToTotalQuantity.entrySet()) {
			String catentryId = entry.getKey();
			Double totalQuantity = entry.getValue();
			// hard coded quantity limit
			Double maxQuantityForCatentry = 1000.0;
			// Double maxQuantityForCatentry = getMaxQuantity(catentryId);

			if (maxQuantityForCatentry != null && totalQuantity != null && totalQuantity > maxQuantityForCatentry) {
				LOGGER.info("Quantity validation fail for catentry " + catentryId + " with quantity " + totalQuantity
						+ ", maximum is " + maxQuantityForCatentry + ", will throw exception.");

				ErrorUEResponse ueResponse = new ErrorUEResponse();
				List<ExceptionData> errors = new ArrayList<ExceptionData>();
				ExceptionData error = new ExceptionData();
				error.setCode("400");
				error.setMessageKey("_ERR_INVALID_PARAMETER_VALUE");
				error.setMessage(MessageKey.getMessage(locale, "_ERR_INVALID_PARAMETER_VALUE",
						new Object[] { "quantity", totalQuantity }));
				errors.add(error);
				ueResponse.setErrors(errors);
				Response response = Response.status(400).type(MediaType.APPLICATION_JSON).entity(ueResponse).build();

				LOGGER.exiting(CLASS_NAME, METHOD_NAME, response);
				return response;
			}
		}

		LOGGER.info("Quantity validation success, will return with OK!");

		Map<String, Object> inputParameters = ueRequest.getCommandInputs();

		OrderPreUEResponse ueResponse = UserExitUtil.createPreUEResponse(orderPOJO, inputParameters);

		Response response = Response.ok(ueResponse).build();
		
		ResponseBuilder responsebuilder = Response.fromResponse(response);
		if(id != null){
			responsebuilder.header(requestId, id);
			responsebuilder.header(responseId, id + "_001");
			response = responsebuilder.build();
		}
		
		
		LOGGER.exiting(CLASS_NAME, METHOD_NAME, response);
		return response;

	}
	
	/**
	 * The pre API extension for PromotionCodeAddRemoveControllerCmd controller
	 * command. This command is used to add or remove a promotion code from an
	 * order.
	 * 
	 * @param ueRequest
	 *            The UERequest passed.
	 * 
	 * @return The response.
	 */

	@POST
	@Path("/promotion_code_add_remove_pre")
	@Consumes({ MediaType.APPLICATION_JSON })
	@Produces({ MediaType.APPLICATION_JSON })
	@ApiOperation(value = "The pre API extension for PromotionCodeAddRemoveControllerCmd controller command.", notes = "| Command: com.ibm.commerce.marketing.commands.PromotionCodeAddRemoveControllerCmd |\n|----------|\n| PromotionCodeAddRemoveControllerCmd is a controller command which is used to add or remove a promotion code from an order.|", response = OrderPreUEResponse.class,
		extensions = { 
	       @Extension( name = "data-command", properties = {
	           @ExtensionProperty(name = "Command", value = "com.ibm.commerce.marketing.commands.PromotionCodeAddRemoveControllerCmd")
	           })
	    })
	@ApiResponses(value = { @ApiResponse(code = 400, message = "Invalid Input Parameter"),
			@ApiResponse(code = 500, message = "Invalid Input Parameter") })
	public Response promotionCodeAddRemovePre(
			@ApiParam(name = "promotionCodeAddRemovePre UE input", value = "The UE Request String", required = true) OrderPreUERequest ueRequest) {

		Order orderPOJO = ueRequest.getOrder();
		if (orderPOJO != null) {
			List<OrderItem> orderitemPOJOs = orderPOJO.getOrderItem();
			if (orderitemPOJOs != null && !orderitemPOJOs.isEmpty()) {
				for (OrderItem orderitemPOJO : orderitemPOJOs) {
					LOGGER.info("orderItemId:"
							+ orderitemPOJO.getOrderItemIdentifier()
							+ " quantity:" + orderitemPOJO.getQuantity());
				}
			}
		}
		
		Map<String, Object> inputParameters = ueRequest.getCommandInputs();

		OrderPreUEResponse ueResponse = UserExitUtil.createPreUEResponse(orderPOJO, inputParameters);

		Response response = Response.ok(ueResponse).build();
		return response;

	}

	/**
	 * The replace API extension for PromotionCodeAddRemoveControllerCmd
	 * controller command. This command is used to add or remove a promotion
	 * code from an order.
	 * 
	 * @param ueRequest
	 *            The UERequest passed.
	 * 
	 * @return The response.
	 */

	@POST
	@Path("/promotion_code_add_remove_replace")
	@Consumes({ MediaType.APPLICATION_JSON })
	@Produces({ MediaType.APPLICATION_JSON })
	@ApiOperation(value = "The replace API extension for PromotionCodeAddRemoveControllerCmd controller command.", notes = "| Command: com.ibm.commerce.marketing.commands.PromotionCodeAddRemoveControllerCmd |\n|----------|\n| PromotionCodeAddRemoveControllerCmd is a controller command which is used to add or remove a promotion code from an order.|", response = OrderPreUEResponse.class,
		extensions = { 
	       @Extension( name = "data-command", properties = {
	           @ExtensionProperty(name = "Command", value = "com.ibm.commerce.marketing.commands.PromotionCodeAddRemoveControllerCmd")
	           })
	    })
	@ApiResponses(value = { @ApiResponse(code = 400, message = "Invalid Input Parameter"),
			@ApiResponse(code = 500, message = "Invalid Input Parameter") })
	public Response promotionCodeAddRemoveReplace(
			@ApiParam(name = "promotionCodeAddRemoveReplace UE input", value = "The UE Request String", required = true) OrderReplaceUERequest ueRequest) {

		Order orderPOJO = ueRequest.getOrder();
		if (orderPOJO != null) {
			List<OrderItem> orderitemPOJOs = orderPOJO.getOrderItem();
			if (orderitemPOJOs != null && !orderitemPOJOs.isEmpty()) {
				for (OrderItem orderitemPOJO : orderitemPOJOs) {
					LOGGER.info("orderItemId:"
							+ orderitemPOJO.getOrderItemIdentifier()
							+ " quantity:" + orderitemPOJO.getQuantity());
				}
			}
		}
		
		Map<String, Object> inputParameters = ueRequest.getCommandInputs();

		OrderReplaceUEResponse ueResponse = UserExitUtil.createReplaceUEResponse(orderPOJO, inputParameters);

		Response response = Response.ok(ueResponse).build();
		return response;

	}

	/**
	 * The post API extension for PromotionCodeAddRemoveControllerCmd controller
	 * command. This command is used to add or remove a promotion code from an
	 * order.
	 * 
	 * @param ueRequest
	 *            The UERequest passed.
	 * 
	 * @return The response.
	 */

	@POST
	@Path("/promotion_code_add_remove_post")
	@Consumes({ MediaType.APPLICATION_JSON })
	@Produces({ MediaType.APPLICATION_JSON })
	@ApiOperation(value = "The post API extension for PromotionCodeAddRemoveControllerCmd controller command.", notes = "| Command: com.ibm.commerce.marketing.commands.PromotionCodeAddRemoveControllerCmd |\n|----------|\n| PromotionCodeAddRemoveControllerCmd is a controller command which is used to add or remove a promotion code from an order.|", response = OrderPreUEResponse.class,
		extensions = { 
	       @Extension( name = "data-command", properties = {
	           @ExtensionProperty(name = "Command", value = "com.ibm.commerce.marketing.commands.PromotionCodeAddRemoveControllerCmd")
	           })
	    })
	@ApiResponses(value = { @ApiResponse(code = 400, message = "Invalid Input Parameter"),
			@ApiResponse(code = 500, message = "Invalid Input Parameter") })
	public Response promotionCodeAddRemovePost(
			@ApiParam(name = "promotionCodeAddRemovePost UE input", value = "The UE Request String", required = true) OrderPostUERequest ueRequest) {

		Order orderPOJO = ueRequest.getOrder();
		if (orderPOJO != null) {
			List<OrderItem> orderitemPOJOs = orderPOJO.getOrderItem();
			if (orderitemPOJOs != null && !orderitemPOJOs.isEmpty()) {
				for (OrderItem orderitemPOJO : orderitemPOJOs) {
					LOGGER.info("orderItemId:"
							+ orderitemPOJO.getOrderItemIdentifier()
							+ " quantity:" + orderitemPOJO.getQuantity());
				}
			}
		}
		
		Map<String, Object> inputParameters = ueRequest.getCommandInputs();

		OrderPostUEResponse ueResponse = UserExitUtil.createPostUEResponse(orderPOJO, inputParameters);

		Response response = Response.ok(ueResponse).build();
		return response;

	}

	/**
	 * Process the promotion code. pass the real promotion code as input to
	 * PromotionCodeAddRemoveControllerCmdImpl when validation success,
	 * otherwise, throw exception.
	 * 
	 * @param ueRequest
	 *            The UERequest passed.
	 * 
	 * @return The response.
	 */

	@POST
	@Path("/process_promotion_code")
	@Consumes({ MediaType.APPLICATION_JSON })
	@Produces({ MediaType.APPLICATION_JSON })
	@ApiOperation(value = "The process_promotion_code command processes the promotion code - return the real promotion code, or throw exception.", notes = "| Command: com.ibm.commerce.marketing.commands.PromotionCodeAddRemoveControllerCmd |\n|----------|\n| PromotionCodeAddRemoveControllerCmd is a controller command which is used to add or remove a promotion code from an order.|", response = OrderPreUEResponse.class,
		extensions = { 
	       @Extension( name = "data-command", properties = {
	           @ExtensionProperty(name = "Command", value = "com.ibm.commerce.marketing.commands.PromotionCodeAddRemoveControllerCmd")
	           })
	    })
	@ApiResponses(value = { @ApiResponse(code = 400, message = "Invalid Input Parameter"),
			@ApiResponse(code = 500, message = "Invalid Input Parameter") })
	public Response processPromotionCode(
			@ApiParam(name = "processPromotionCode UE input", value = "The UE Request String", required = true) OrderPreUERequest ueRequest) {

		final String METHOD_NAME = "processPromotionCode()";
		Order orderPOJO = ueRequest.getOrder();
		Map<String, Object> inputParameters = ueRequest.getCommandInputs();

		// It's ApplyPromotionCode when taskType is A, RemovePromotionCode for R
		String taskType = (String) inputParameters.get("taskType");
		// Get the associate/employee ID.
		String inputPromotionCode = (String) inputParameters.get("promotionCode");
		String storeId = (String) inputParameters.get("storeId");

		if (inputPromotionCode != null && !inputPromotionCode.isEmpty() && storeId != null
				&& !storeId.isEmpty() && "A".equals(taskType)) {

			if (isValidCode(storeId, inputPromotionCode)) {
				LOGGER.info("Code validation success, will return the real promotion code.");

				// Hard code the real promotion code here, 20PCTOFF is a public
				// promotion code created via promotion tool.
				String newPromotionCode = "20PCTOFF";
				inputParameters.put("promotionCode", newPromotionCode);
			} else {
				LOGGER.info("Code validation fail for the entered promotion code "
						+ inputPromotionCode + " under store " + storeId
						+ ", will throw exception.");

				ErrorUEResponse ueResponse = new ErrorUEResponse();
				List<ExceptionData> errors = new ArrayList<ExceptionData>();
				ExceptionData error = new ExceptionData();
				error.setCode("400");
				error.setMessageKey("_ERR_INVALID_PARAMETER_VALUE");
				error.setMessage(MessageKey.getMessage(locale,
						"_ERR_INVALID_PARAMETER_VALUE", new Object[] {
								"promotionCode", inputPromotionCode }));
				errors.add(error);
				ueResponse.setErrors(errors);
				Response response = Response.status(400)
						.type(MediaType.APPLICATION_JSON).entity(ueResponse)
						.build();

				LOGGER.exiting(CLASS_NAME, METHOD_NAME, response);
				return response;
			}

		}

		OrderPreUEResponse ueResponse = UserExitUtil.createPreUEResponse(orderPOJO, inputParameters);

		Response response = Response.ok(ueResponse).build();
		return response;

	}
	
	private boolean isValidCode(String storeId, String inputPromotionCode) {
		// Hard code Store Associate information here
		Map<String, Set> storeIdToEmployeeIdMap = new HashMap<String, Set>();
		String AuroraESiteId = "10201";
		Set<String> employeeIdSet = new HashSet<String>();
		employeeIdSet.add("-1000");
		storeIdToEmployeeIdMap.put(AuroraESiteId, employeeIdSet);

		// Validation
		if (storeIdToEmployeeIdMap.get(storeId) != null
				&& storeIdToEmployeeIdMap.get(storeId).contains(inputPromotionCode)) {
			return true;
		} else {
			return false;
		}
	}
	
	@POST
	@Path("/compensate_transaction")
	@Consumes({ MediaType.APPLICATION_JSON })
	@Produces({ MediaType.APPLICATION_JSON }) 
	@ApiOperation(value = "The compensation for transaction rollback", notes="Command: com.ibm.commerce.foundation.ue.compensation.CompensateForTxRollbackCmd",
			extensions = { 
		       @Extension( name = "data-command", properties = {
		           @ExtensionProperty(name = "Command", value = "com.ibm.commerce.foundation.ue.compensation.CompensateForTxRollbackCmd")
		           })
		    })
	@ApiResponses(value = { @ApiResponse(code = 400, message = "Application error"),
			@ApiResponse(code = 500, message = "System error") })
	public Response compensateForTxTransanction(@ApiParam(name = "compensateForTxTransanction UE input", value = "The compensateForTxTransanction UE input parameters", required = true) CompensateForTxRollbackCmdUEInput ueRequest) {

		final String METHOD_NAME = "compensateForTxTransanction()";
		if (LOGGER.isLoggable(Level.FINER)) {
			LOGGER.entering(CLASS_NAME, METHOD_NAME, new Object[] {});
		}
		if (LOGGER.isLoggable(Level.FINER)) {
			LOGGER.log(Level.FINER, "This is a UE implementation for compensateForTxTransanction");
		}
		
		CompensateForTxRollbackCmdUEOutput ueResponse = new CompensateForTxRollbackCmdUEOutput();
		List<UEInvocation> list = ueRequest.getUEInvocations();
		list.get(0).setCompensationResult("succeed");
		ueResponse.setUEInvocations(list);
		Response response = Response.ok(ueResponse).build();
		
		return response;

	}

	private class CQ {
		@Override
		public String toString() {
			return "CQ [catentryId=" + catentryId + ", quantity=" + quantity + "]";
		}

		private String catentryId;
		private Double quantity;
	}

	/**
	 * The API extension for PreProcessOrderCmd task command. This task command
	 * is used to pre process the order, it's called before the calling of
	 * {@link ProcessOrderCmd}.
	 * 
	 * @param PreProcessOrderUEInput
	 *            The PreProcessOrder UE Input Parameter.
	 * 
	 * @return The response.
	 */

	@POST
	@Path("/tax_integration_custom")
	@Consumes({ MediaType.APPLICATION_JSON })
	@Produces({ MediaType.APPLICATION_JSON })
	@ApiOperation(value = "The API extension for TaxIntegrationCustom task command.", notes = "| Command: com.ibm.commerce.isv.kit.tax.TaxIntegrationCustomCmd |\n|----------|\n| TaxIntegrationCustomCmd is a task command which is used to custom the tax integration by CoC Customization framework.|", response = TaxIntegrationCustomCmdUEOutput.class,
		extensions = { 
	       @Extension( name = "data-command", properties = {
	           @ExtensionProperty(name = "Command", value = "com.ibm.commerce.isv.kit.tax.TaxIntegrationCustomCmd")
	           })
	    })
	@ApiResponses(value = { @ApiResponse(code = 400, message = "Invalid Input Parameter"),
			@ApiResponse(code = 500, message = "Invalid Input Parameter") })
	public Response taxIntegrationOrderCus(
			@ApiParam(name = "TaxIntegrationCustomCmdUEInput", value = "TaxIntegrationCustomCmd UE Input Parameter", required = true) TaxIntegrationCustomCmdUEInput taxIntegrationCustomCmdUEInput) {
		List<TaxIntegrationCustomOrderItem> taxOrderItems = taxIntegrationCustomCmdUEInput.getTaxOrderItems();
		for(TaxIntegrationCustomOrderItem taxOrderItem:taxOrderItems){
			taxOrderItem.setTotalTax(BigDecimal.valueOf(1.0));
			taxOrderItem.setTotalTaxRate(BigDecimal.valueOf(1.1));
			taxOrderItem.setRecyclingFee(BigDecimal.valueOf(1.2));
			taxOrderItem.setTaxRate(new BigDecimal[]{BigDecimal.valueOf(1.0),BigDecimal.valueOf(1.0),BigDecimal.valueOf(1.0),BigDecimal.valueOf(1.0),BigDecimal.valueOf(1.0),BigDecimal.valueOf(1.0)});
			taxOrderItem.setSecondaryTaxRate(new BigDecimal[]{BigDecimal.valueOf(1.0),BigDecimal.valueOf(1.0),BigDecimal.valueOf(1.0)});
			taxOrderItem.setTaxAmounts(new BigDecimal[]{BigDecimal.valueOf(1.1),BigDecimal.valueOf(1.1),BigDecimal.valueOf(1.1),BigDecimal.valueOf(1.1),BigDecimal.valueOf(1.1),BigDecimal.valueOf(1.1)});
			taxOrderItem.setSecondaryTaxAmounts(new BigDecimal[]{BigDecimal.valueOf(1.1),BigDecimal.valueOf(1.1),BigDecimal.valueOf(1.1)});
		}
		TaxIntegrationCustomCmdUEOutput taxIntegrationCustomCmdUEOutput = new TaxIntegrationCustomCmdUEOutput();
		taxIntegrationCustomCmdUEOutput.setTaxOrderItems(taxOrderItems);
		taxIntegrationCustomCmdUEOutput.setTotalTax(BigDecimal.valueOf(1.0));
		taxIntegrationCustomCmdUEOutput.setTotalRecyclingFee(BigDecimal.valueOf(1.0));
		Response response = Response.ok(taxIntegrationCustomCmdUEOutput).build();
		return response;
	}
	
	/**
	 * The API extension for PreProcessOrderCmd task command. This task command
	 * is used to pre process the order, it's called before the calling of
	 * {@link ProcessOrderCmd}.
	 * 
	 * @param PreProcessOrderUEInput
	 *            The PreProcessOrder UE Input Parameter.
	 * 
	 * @return The response.
	 */

	@POST
	@Path("/pre_process_order")
	@Consumes({ MediaType.APPLICATION_JSON })
	@Produces({ MediaType.APPLICATION_JSON })
	@ApiOperation(value = "The API extension for PreProcessOrder task command.", notes = "| Command: com.ibm.commerce.order.commands.PreProcessOrderCmd |\n|----------|\n| PreProcessOrderCmd is a task command which is used to pre process the order, it's called before the calling of ProcessOrderCmd.|", response = PreProcessOrderCmdUEOutput.class,
		extensions = { 
	       @Extension( name = "data-command", properties = {
	           @ExtensionProperty(name = "Command", value = "com.ibm.commerce.order.commands.PreProcessOrderCmd")
	           })
	    })
	@ApiResponses(value = { @ApiResponse(code = 400, message = "Invalid Input Parameter"),
			@ApiResponse(code = 500, message = "Invalid Input Parameter") })
	public Response preProcessOrderCus(
			@ApiParam(name = "PreProcessOrderUEInput", value = "PreProcessOrder UE Input Parameter", required = true) PreProcessOrderCmdUEInput preProcessOrderUEInput) {
		List<Field> properties = new ArrayList<Field>();
		Field[] fields = PreProcessOrderCmdUEInput.class.getDeclaredFields();
		for (Field field : fields) {
			properties.add(field);
		}
		fields = TaskCmdUEInput.class.getDeclaredFields();
		for (Field field : fields) {
			properties.add(field);
		}
		PreProcessOrderCmdUEOutput preProcessOrderUEOutput = new PreProcessOrderCmdUEOutput();
		UserExitUtil.setPropertiesFromInputToOutput(preProcessOrderUEInput, PreProcessOrderCmdUEInput.class,
				preProcessOrderUEOutput, PreProcessOrderCmdUEOutput.class, properties);

		// testing properties preservation.
		preProcessOrderUEOutput.setPoNumber("666666666");
		Response response = Response.ok(preProcessOrderUEOutput).build();
		return response;
	}

	/**
	 * The API extension for ProcessOrderSubmitEvent task command. This task
	 * command is used to process the event captured by the listener when the
	 * event name is order submit.
	 * 
	 * @param processOrderSubmitEventCmdUEInputInput
	 *            The ProcessOrderSubmitEventCmd UE Input Parameter.
	 * 
	 * @return The response.
	 */

	@POST
	@Path("/process_order_submit_event")
	@Consumes({ MediaType.APPLICATION_JSON })
	@Produces({ MediaType.APPLICATION_JSON })
	@ApiOperation(value = "The API extension for ProcessOrderSubmitEventCmd task command.", notes = "| Command: com.ibm.commerce.order.commands.ProcessOrderSubmitEventCmd |\n|----------|\n| ProcessOrderSubmitEventCmd is a task command which is used to process the event captured by the listener when the event name is order submit.|", response = ProcessOrderSubmitEventCmdUEOutput.class,
		extensions = { 
	       @Extension( name = "data-command", properties = {
	           @ExtensionProperty(name = "Command", value = "com.ibm.commerce.order.commands.ProcessOrderSubmitEventCmd")
	           })
	    })
	@ApiResponses(value = { @ApiResponse(code = 400, message = "Invalid Input Parameter"),
			@ApiResponse(code = 500, message = "Invalid Input Parameter") })
	public Response processOrderSubmitEvent(
			@ApiParam(name = "ProcessOrderSubmitEventCmdUEInput", value = "ProcessOrderSubmitEventCmd UE Input Parameter", required = true) ProcessOrderSubmitEventCmdUEInput processOrderSubmitEventCmdUEInputInput) {

		List<Field> properties = new ArrayList<Field>();
		Field[] fields = ProcessOrderSubmitEventCmdUEInput.class.getDeclaredFields();
		for (Field field : fields) {
			properties.add(field);
		}
		fields = TaskCmdUEInput.class.getDeclaredFields();
		for (Field field : fields) {
			properties.add(field);
		}
		ProcessOrderSubmitEventCmdUEOutput ueOutput = new ProcessOrderSubmitEventCmdUEOutput();
		UserExitUtil.setPropertiesFromInputToOutput(processOrderSubmitEventCmdUEInputInput,
				ProcessOrderSubmitEventCmdUEInput.class, ueOutput, ProcessOrderSubmitEventCmdUEOutput.class,
				properties);

		// testing order modification
		Order orderPOJO = ueOutput.getOrder();
		if (orderPOJO != null) {
			orderPOJO.setOrderDescription("Testing process_order_submit_event");
		}

		Response response = Response.ok(ueOutput).build();
		return response;
	}

	/**
	 * The API extension for ProcessOrderCmd task command. This Order task
	 * command is used to submit an order.
	 * 
	 * @param processOrderUEInput
	 *            ProcessOrderCmd UE Input Parameter.
	 * 
	 * @return The response.
	 */

	@POST
	@Path("/process_order")
	@Consumes({ MediaType.APPLICATION_JSON })
	@Produces({ MediaType.APPLICATION_JSON })
	@ApiOperation(value = "The API extension for ProcessOrderCmd task command.", notes = "| Command: com.ibm.commerce.order.commands.ProcessOrderCmd |\n|----------|\n| ProcessOrderCmd is a task command which is used to submit an order.|", response = ProcessOrderCmdUEOutput.class,
		extensions = { 
	       @Extension( name = "data-command", properties = {
	           @ExtensionProperty(name = "Command", value = "com.ibm.commerce.order.commands.ProcessOrderCmd")
	           })
	    })
	@ApiResponses(value = { @ApiResponse(code = 400, message = "Invalid Input Parameter"),
			@ApiResponse(code = 500, message = "Invalid Input Parameter") })
	public Response processOrderCus(
			@ApiParam(name = "ProcessOrderUEInput", value = "ProcessOrderCmd UE Input Parameter", required = true) ProcessOrderCmdUEInput processOrderUEInput) {
		List<Field> properties = new ArrayList<Field>();
		Field[] fields = ProcessOrderCmdUEInput.class.getDeclaredFields();
		for (Field field : fields) {
			properties.add(field);
		}
		fields = TaskCmdUEInput.class.getDeclaredFields();
		for (Field field : fields) {
			properties.add(field);
		}
		ProcessOrderCmdUEOutput processOrderCmdUEOutput = new ProcessOrderCmdUEOutput();
		UserExitUtil.setPropertiesFromInputToOutput(processOrderUEInput, ProcessOrderCmdUEInput.class,
				processOrderCmdUEOutput, ProcessOrderCmdUEOutput.class, properties);
		processOrderCmdUEOutput.setPoNumber("666666666");
		Response response = Response.ok(processOrderCmdUEOutput).build();
		return response;
	}

	/**
	 * The API extension for ExtOrderProcessCmd task command. This command is
	 * used to perform custom processing just prior to the completion of the
	 * {@link OrderProcessCmd} controller command
	 * 
	 * @param extOrderProcessCmdUEInput
	 *            The ExtOrderProcessCmd UE Input Parameter.
	 * 
	 * @return The response.
	 */

	@POST
	@Path("/ext_order_process")
	@Consumes({ MediaType.APPLICATION_JSON })
	@Produces({ MediaType.APPLICATION_JSON })
	@ApiOperation(value = "The API extension for ExtOrderProcessCmd task command.", notes = "| Command: com.ibm.commerce.order.commands.ExtOrderProcessCmd |\n|----------|\n| ExtOrderProcessCmd is a task command which is used to perform custom processing just prior to the completion of the OrderProcessCmd controller command.|", response = ExtOrderProcessCmdUEOutput.class,
		extensions = { 
	       @Extension( name = "data-command", properties = {
	           @ExtensionProperty(name = "Command", value = "com.ibm.commerce.order.commands.ExtOrderProcessCmd")
	           })
	    })
	@ApiResponses(value = { @ApiResponse(code = 400, message = "Invalid Input Parameter"),
			@ApiResponse(code = 500, message = "Invalid Input Parameter") })
	public Response extOrderProcessCus(
			@ApiParam(name = "ExtOrderProcessCmdUEInput", value = "ExtOrderProcessCmd UE Input Parameter", required = true) ExtOrderProcessCmdUEInput extOrderProcessCmdUEInput) {
		List<Field> properties = new ArrayList<Field>();
		Field[] fields = ExtOrderProcessCmdUEInput.class.getDeclaredFields();
		for (Field field : fields) {
			properties.add(field);
		}
		fields = TaskCmdUEInput.class.getDeclaredFields();
		for (Field field : fields) {
			properties.add(field);
		}
		ExtOrderProcessCmdUEOutput extOrderProcessCmdUEOutput = new ExtOrderProcessCmdUEOutput();
		UserExitUtil.setPropertiesFromInputToOutput(extOrderProcessCmdUEInput, ExtOrderProcessCmdUEInput.class,
				extOrderProcessCmdUEOutput, ExtOrderProcessCmdUEOutput.class, properties);
		extOrderProcessCmdUEOutput.setOrderRn(10001L);
		Response response = Response.ok(extOrderProcessCmdUEOutput).build();
		return response;
	}

	/**
	 * The API extension for UpdateShippingAddressCmd task command. This Order
	 * task command is used to update the shipping address for the passed order
	 * items.
	 * 
	 * @param updateShippingAddressCmdUEInput
	 *            The UpdateShippingAddress UE Input Parameter.
	 * 
	 * @return The response.
	 */

	@POST
	@Path("/update_shipping_address")
	@Consumes({ MediaType.APPLICATION_JSON })
	@Produces({ MediaType.APPLICATION_JSON })
	@ApiOperation(value = "The API extension for UpdateShippingAddressCmd task command.", notes = "| Command: com.ibm.commerce.order.commands.UpdateShippingAddressCmd |\n|----------|\n| UpdateShippingAddressCmd is a task command which is used to update the shipping address for the passed order items.|", response = UpdateShippingAddressCmdUEOutput.class,
		extensions = { 
	       @Extension( name = "data-command", properties = {
	           @ExtensionProperty(name = "Command", value = "com.ibm.commerce.order.commands.UpdateShippingAddressCmd")
	           })
	    })
	@ApiResponses(value = { @ApiResponse(code = 400, message = "Invalid Input Parameter"),
			@ApiResponse(code = 500, message = "Invalid Input Parameter") })
	public Response updateShippingAddressCus(
			@ApiParam(name = "UpdateShippingAddressUEInput", value = "UpdateShippingAddress UE Input Parameter", required = true) UpdateShippingAddressCmdUEInput updateShippingAddressUEInput) {
		List<Field> properties = new ArrayList<Field>();
		Field[] fields = UpdateShippingAddressCmdUEInput.class.getDeclaredFields();
		for (Field field : fields) {
			properties.add(field);
		}
		fields = TaskCmdUEInput.class.getDeclaredFields();
		for (Field field : fields) {
			properties.add(field);
		}
		UpdateShippingAddressCmdUEOutput updateShippingAddressUEOutput = new UpdateShippingAddressCmdUEOutput();
		UserExitUtil.setPropertiesFromInputToOutput(updateShippingAddressUEInput, UpdateShippingAddressCmdUEInput.class,
				updateShippingAddressUEOutput, UpdateShippingAddressCmdUEOutput.class, properties);

		updateShippingAddressUEOutput.setAddressIds(new Long[] { 1L });
		Response response = Response.ok(updateShippingAddressUEOutput).build();
		return response;
	}

	/**
	 * The API extension for OrderNotifyCmd task command. This Order task
	 * command is used to Sends order notification message.
	 * 
	 * @param OrderNotifyCmdUEInput
	 *            The OrderNotifyCmd UE Input Parameter.
	 * 
	 * @return The response.
	 */

	@POST
	@Path("/order_notify")
	@Consumes({ MediaType.APPLICATION_JSON })
	@Produces({ MediaType.APPLICATION_JSON })
	@ApiOperation(value = "The API extension for OrderNotifyCmd task command.", notes = "| Command: com.ibm.commerce.order.commands.OrderNotifyCmd |\n|----------|\n| OrderNotifyCmd is task command is used to Sends order notification message.|", response = OrderNotifyCmdUEOutput.class,
		extensions = { 
	       @Extension( name = "data-command", properties = {
	           @ExtensionProperty(name = "Command", value = "com.ibm.commerce.order.commands.OrderNotifyCmd")
	           })
	    })
	@ApiResponses(value = { @ApiResponse(code = 400, message = "Invalid Input Parameter"),
			@ApiResponse(code = 500, message = "Invalid Input Parameter") })
	public Response orderNotifyCus(
			@ApiParam(name = "OrderNotifyUEInput", value = "OrderNotify UE Input Parameter", required = true) OrderNotifyCmdUEInput orderNotifyUEInput) {
		List<Field> properties = new ArrayList<Field>();
		Field[] fields = OrderNotifyCmdUEInput.class.getDeclaredFields();
		for (Field field : fields) {
			properties.add(field);
		}
		fields = TaskCmdUEInput.class.getDeclaredFields();
		for (Field field : fields) {
			properties.add(field);
		}
		OrderNotifyCmdUEOutput orderNotifyUEOutput = new OrderNotifyCmdUEOutput();
		UserExitUtil.setPropertiesFromInputToOutput(orderNotifyUEInput, OrderNotifyCmdUEInput.class,
				orderNotifyUEOutput, OrderNotifyCmdUEOutput.class, properties);

		orderNotifyUEOutput.setNotificationEnabled(true);
		Response response = Response.ok(orderNotifyUEOutput).build();
		return response;
	}

	/**
	 * The API extension for OrderMessagingCmd task command. The interface of
	 * the OrderMessagingCmd task command that generates the outbound Order
	 * Create Message <samp>"Report_NC_PurchaseOrder"</samp>.
	 * 
	 * @param orderMessagingUEInput
	 *            The orderMessaging UE Input Parameter.
	 * 
	 * @return The response.
	 */

	@POST
	@Path("/order_messaging")
	@Consumes({ MediaType.APPLICATION_JSON })
	@Produces({ MediaType.APPLICATION_JSON })
	@ApiOperation(value = "The API extension for OrderMessagingCmd task command.", notes = "| Command: com.ibm.commerce.order.commands.OrderMessagingCmd |\n|----------|\n| OrderMessagingCmd is a task command that generates the outbound Order Create Message \"Report_NC_PurchaseOrder\".|", response = OrderMessagingCmdUEOutput.class,
		extensions = { 
	       @Extension( name = "data-command", properties = {
	           @ExtensionProperty(name = "Command", value = "com.ibm.commerce.order.commands.OrderMessagingCmd")
	           })
	    })
	@ApiResponses(value = { @ApiResponse(code = 400, message = "Invalid Input Parameter"),
			@ApiResponse(code = 500, message = "Invalid Input Parameter") })
	public Response orderMessagingCus(
			@ApiParam(name = "OrderMessagingUEInput", value = "OrderMessaging UE Input Parameter", required = true) OrderMessagingCmdUEInput orderMessagingUEInput) {

		List<Field> properties = new ArrayList<Field>();
		Field[] fields = OrderMessagingCmdUEInput.class.getDeclaredFields();
		for (Field field : fields) {
			properties.add(field);
		}
		fields = TaskCmdUEInput.class.getDeclaredFields();
		for (Field field : fields) {
			properties.add(field);
		}
		OrderMessagingCmdUEOutput orderMessagingUEOutput = new OrderMessagingCmdUEOutput();
		UserExitUtil.setPropertiesFromInputToOutput(orderMessagingUEInput, OrderMessagingCmdUEInput.class,
				orderMessagingUEOutput, OrderMessagingCmdUEOutput.class, properties);

		Order order = orderMessagingUEOutput.getOrder();
		Map<String, String> userData = new HashMap<String, String>();
		userData.put("PGreetings", "Hello, This is a UE test");
		order.getUserData().setUserDataField(userData);

		Response response = Response.ok(orderMessagingUEOutput).build();
		return response;
	}

	/**
	 * Synchronizes the gift wrap with the order item it belongs to - makes or
	 * breaks the association, or updates the gift wrap quantity.
	 * 
	 * @param ueRequest
	 *            The UERequest passed.
	 * 
	 * @return The response.
	 */

	@POST
	@Path("/synch_gift_wrap")
	@Consumes({ MediaType.APPLICATION_JSON })
	@Produces({ MediaType.APPLICATION_JSON })
	@ApiOperation(value = "The synch_gift_wrap command synchronizes the gift wrap with the order item it belongs to - makes or breaks the association, or updates the gift wrap quantity.", notes="Command: com.ibm.commerce.orderitems.commands.OrderItemUpdateCmd", response = OrderPostUERequest.class,
		extensions = { 
	       @Extension( name = "data-command", properties = {
	           @ExtensionProperty(name = "Command", value = "com.ibm.commerce.orderitems.commands.OrderItemUpdateCmd")
	           })
	    })
	@ApiResponses(value = { @ApiResponse(code = 400, message = "Invalid Input Parameter"),
			@ApiResponse(code = 500, message = "Invalid Input Parameter") })
	public Response synchGiftWrap(
			@ApiParam(name = "synchGiftWrap UE input", value = "The UE Request String", required = true) OrderPostUERequest ueRequest) {

		final String METHOD_NAME = "synchGiftWrap()";
		if (LOGGER.isLoggable(Level.FINER)) {
			LOGGER.entering(CLASS_NAME, METHOD_NAME, new Object[] {});
		}

		// ObjectMapper mapper = UserExitUtil.getMapper();
		try {
			String parameterValue = null;
			String newOrderItemID = null;
			String updatedOrRemovedOrderItemID = null;
			String wrappedOrderItemID = null;
			Map<String, Object> requestPropertyPOJOs = ueRequest.getCommandInputs();
			Map<String, Object> responsePropertyPOJOs = ueRequest.getCommandOutputs();

			parameterValue = (String) responsePropertyPOJOs.get("newOrderItemId_1");
			if (parameterValue != null && !parameterValue.isEmpty()) {
				newOrderItemID = parameterValue;
			}

			parameterValue = (String) requestPropertyPOJOs.get("orderItemId_1");
			if (parameterValue != null && !parameterValue.isEmpty()) {
				updatedOrRemovedOrderItemID = parameterValue;
			}

			parameterValue = (String) requestPropertyPOJOs.get("giftwrap");
			if (parameterValue != null && !parameterValue.isEmpty()) {
				wrappedOrderItemID = parameterValue;
			}

			Order orderPOJO = ueRequest.getOrder();
			if (orderPOJO != null) {

				String removedOrderItemID = null;
				String updatedOrderItemID = null;
				if (updatedOrRemovedOrderItemID != null) {
					OrderItem newOrderItem = getOrderItem(orderPOJO, updatedOrRemovedOrderItemID, false);
					if (newOrderItem != null) {
						updatedOrderItemID = updatedOrRemovedOrderItemID;
					} else {
						removedOrderItemID = updatedOrRemovedOrderItemID;
					}
				}

				if (newOrderItemID != null) {
					OrderItem newOrderItem = getOrderItem(orderPOJO, newOrderItemID, true);
					if (wrappedOrderItemID != null) {
						OrderItem wrappedOrderItem = getOrderItem(orderPOJO, wrappedOrderItemID, true);
						addGiftWrapToOrderItem(orderPOJO, newOrderItem, wrappedOrderItem);
					}
					// else it's not a gift wrap, just a normal item added, so
					// do nothing
				} else if (removedOrderItemID != null) {
					// it's a normal order item, that could be wrapped
					// find the wrapper if it exists
					removeWrapperForOrderItemByCorrelationGroupID(orderPOJO, null, removedOrderItemID);
				} else if (updatedOrderItemID != null) {
					// we assume that wrapper order items cannot be updated
					// directly, so the updated one is just a normal order item
					OrderItem updatedOrderItem = getOrderItem(orderPOJO, updatedOrderItemID, true);
					OrderItem wrapperOrderItem = findWrapperForOrderItem(orderPOJO, updatedOrderItem);
					if (wrapperOrderItem != null) {
						updateGiftWrapQuantity(updatedOrderItem, wrapperOrderItem);
					}
					// it's a gift wrap, ignore updates
				}
			}

			Map<String, Object> outputParameters = new HashMap<String, Object>();

			OrderPostUEResponse ueResponse = UserExitUtil.createPostUEResponse(orderPOJO, outputParameters);

			LOGGER.info("Gift wrap synchronization was successful, will return with OK!");

			Response response = Response.ok(ueResponse).build();
			LOGGER.exiting(CLASS_NAME, METHOD_NAME, response);
			return response;
		} catch (NullPointerException e) {
			throw new RuntimeException(e + " " + Status.INTERNAL_SERVER_ERROR.getStatusCode() + " "
					+ MessageKey.getMessage(locale, "_ERR_INVALID_PARAMETER_VALUE"));

		} catch (IllegalArgumentException e) {
			throw new RuntimeException(e + " " + Status.INTERNAL_SERVER_ERROR.getStatusCode() + " "
					+ MessageKey.getMessage(locale, "_ERR_INVALID_PARAMETER_VALUE"));
		}
	}

	private void updateGiftWrapQuantity(OrderItem wrappedOrderItem, OrderItem wrapperOrderItem) {
		Quantity wrappedQuantity = wrappedOrderItem.getQuantity();
		if (wrappedQuantity != null) {
			double newQuanitity = wrappedQuantity.getValue();
			Quantity wrapperQuantity = wrapperOrderItem.getQuantity();
			if (wrapperQuantity == null) {
				// quantity object not defined so create it for the wrapper
				wrapperQuantity = new Quantity();
				wrapperQuantity.setUom(wrappedQuantity.getUom());
				wrapperOrderItem.setQuantity(wrapperQuantity);
			}

			wrapperQuantity.setValue(newQuanitity);
		} else {
			wrapperOrderItem.setQuantity(null);
		}
	}

	private OrderItem findWrapperForOrderItem(Order order, OrderItem wrappedOrderItem) {
		String correlationGroupId = wrappedOrderItem.getCorrelationGroup();
		OrderItem found = findWrapperForOrderItemByCorrelationGroupID(order, wrappedOrderItem, correlationGroupId);

		return found;
	}

	private OrderItem findWrapperForOrderItemByCorrelationGroupID(Order order, OrderItem wrappedOrderItem,
			String correlationGroupId) {
		OrderItem found = null;
		for (OrderItem orderItem : order.getOrderItem()) {
			if (orderItem != wrappedOrderItem && orderItem.getCorrelationGroup().equals(correlationGroupId)) {
				found = orderItem;
				break;
			}
		}
		return found;
	}

	private void removeWrapperForOrderItemByCorrelationGroupID(Order order, OrderItem wrappedOrderItem,
			String correlationGroupId) {
		Iterator<OrderItem> orderItemIterator = order.getOrderItem().iterator();
		while (orderItemIterator.hasNext()) {
			OrderItem orderItem = orderItemIterator.next();
			if (orderItem != wrappedOrderItem && orderItem.getCorrelationGroup().equals(correlationGroupId)) {
				orderItemIterator.remove();
				break;
			}
		}

	}

	private void removeGiftWrapFromOrderItem(OrderItem wrapperOrderItem) {
		String oldWrapperId = wrapperOrderItem.getOrderItemIdentifier().getUniqueID();
		wrapperOrderItem.setCorrelationGroup(oldWrapperId);
	}

	private void addGiftWrapToOrderItem(Order order, OrderItem wrapperOrderItem, OrderItem wrappedOrderItem) {
		String wrappedId = wrappedOrderItem.getOrderItemIdentifier().getUniqueID();
		String wrappedCorrelationGroupId = wrappedOrderItem.getCorrelationGroup();
		String wrapperCorrelationGroupId = wrapperOrderItem.getCorrelationGroup();
		if (wrappedCorrelationGroupId == null) {
			LOGGER.severe("Wrapped order item " + wrappedId + " is missing the correlationGroup.");

			throw new RuntimeException(Status.INTERNAL_SERVER_ERROR.getStatusCode() + " " + MessageKey
					.getMessage(locale, "_ERR_INVALID_PARAMETER_VALUE", new Object[] { "correlationGroup is null" }));
		}

		// remove an old wrapper if it exists
		OrderItem oldWrapperOrderItem = findWrapperForOrderItem(order, wrappedOrderItem);
		if (oldWrapperOrderItem != null) {
			// remove the association
			removeGiftWrapFromOrderItem(oldWrapperOrderItem);
		}

		if (!wrappedCorrelationGroupId.equals(wrapperCorrelationGroupId)) {
			// make the association
			wrapperOrderItem.setCorrelationGroup(wrappedCorrelationGroupId);
		}
		// else no change

	}

	private boolean isGiftWrap(OrderItem orderItem) {
		String catentryId = orderItem.getCatalogEntryIdentifier().getUniqueID();

		// no DB, use list instead.
		List<String> giftWrapCatentryIds = new ArrayList<String>();
		giftWrapCatentryIds.add("12705");
		return giftWrapCatentryIds.contains(catentryId);
	}

	private OrderItem getOrderItem(Order orderPOJO, String orderItemID, boolean exceptionIfNotFound) {
		OrderItem found = null;
		for (OrderItem orderItem : orderPOJO.getOrderItem()) {
			if (orderItem.getOrderItemIdentifier().getUniqueID().equals(orderItemID)) {
				found = orderItem;
				break;
			}
		}

		if (exceptionIfNotFound && found == null) {
			LOGGER.severe("Could not find orderItem in the Order POJO with orderItemID=" + orderItemID + ".");

			throw new RuntimeException(Status.INTERNAL_SERVER_ERROR.getStatusCode() + " " + MessageKey
					.getMessage(locale, "_ERR_INVALID_PARAMETER_VALUE", new Object[] { "orderItemID", orderItemID }));
		}

		return found;
	}

}
