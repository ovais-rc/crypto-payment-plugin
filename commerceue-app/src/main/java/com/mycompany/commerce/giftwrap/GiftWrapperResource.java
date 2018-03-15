package com.mycompany.commerce.giftwrap;

import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import io.swagger.annotations.ApiParam;
import io.swagger.annotations.ApiResponse;
import io.swagger.annotations.ApiResponses;
import io.swagger.annotations.SwaggerDefinition;
import io.swagger.annotations.Tag;

import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

import javax.ws.rs.Consumes;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import javax.ws.rs.core.Response.Status;

import com.ibm.commerce.foundation.common.entities.Quantity;
import com.ibm.commerce.foundation.ue.util.UserExitUtil;
import com.ibm.commerce.order.entities.ExtendAttribute;
import com.ibm.commerce.order.entities.Order;
import com.ibm.commerce.order.entities.OrderItem;
import com.ibm.commerce.order.ue.entities.OrderPostUERequest;
import com.ibm.commerce.order.ue.entities.OrderPostUEResponse;
import com.ibm.commerce.ue.rest.BaseResource;
import com.ibm.commerce.ue.rest.MessageKey;

@Path("/order")
@SwaggerDefinition(tags = { @Tag(name = "order - giftwrapper", description = "API Extensions for order customization.") })
@Api(value = "/order", tags = "order - giftwrapper")
public class GiftWrapperResource extends BaseResource {
	private static final Logger LOGGER = Logger.getLogger(GiftWrapperResource.class.getName());
	private static final String CLASS_NAME = GiftWrapperResource.class.getName();

	private static Locale locale = new Locale(
			MessageKey.getConfig("_CONFIG_LANGUAGE"),
			MessageKey.getConfig("_CONFIG_LOCALE"));

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
	@Path("/synch_gift_wrapper")
	@Consumes({ MediaType.APPLICATION_JSON })
	@Produces({ MediaType.APPLICATION_JSON })
	@ApiOperation(value = "Synchronizes the gift wrap with the order item it belongs to - makes or breaks the association, or updates the gift wrap quantity.", response = OrderPostUERequest.class)
	@ApiResponses(value = { @ApiResponse(code = 400, message = "Invalid Input Parameter"),
			@ApiResponse(code = 500, message = "Invalid Input Parameter") })
	public Response synchGiftWrap(
			@ApiParam(name = "synchGiftWrap UE input", value = "The UE Request String", required = true) OrderPostUERequest ueRequest) {

		final String METHOD_NAME = "synchGiftWrapper()";
		if (LOGGER.isLoggable(Level.FINER)) {
			LOGGER.entering(CLASS_NAME, METHOD_NAME, new Object[] {});
		}

		try {
			String parameterValue = null;
			String newOrderItemID = null;
			String updatedOrRemovedOrderItemID = null;
			String wrappedOrderItemID = null;
			//Get OrderItemAdd cmd's input parameters
			Map<String, Object> requestPropertyPOJOs = ueRequest.getCommandInputs();
			//Get OrderItemAdd cmd's output parameters
			Map<String, Object> responsePropertyPOJOs = ueRequest.getCommandOutputs();
			
			//If we add new order item to cart, newOrderItemId_1 will be set
			parameterValue = (String) responsePropertyPOJOs.get("newOrderItemId_1");
			if (parameterValue != null && !parameterValue.isEmpty()) {
				newOrderItemID = parameterValue;
			}
			
			//If we update or remove an order item, orderItemId_1 will be set
			parameterValue = (String) requestPropertyPOJOs.get("orderItemId_1");
			if (parameterValue != null && !parameterValue.isEmpty()) {
				updatedOrRemovedOrderItemID = parameterValue;
			}

			//If we add a wrapper into cart, giftwrap will be set
			parameterValue = (String) requestPropertyPOJOs.get("giftwrap");
			if (parameterValue != null && !parameterValue.isEmpty()) {
				wrappedOrderItemID = parameterValue;
			}

			//Get order info
			Order orderPOJO = ueRequest.getOrder();
		
			if (orderPOJO != null) {

				String removedOrderItemID = null;
				String updatedOrderItemID = null;
				//if we update or remove an order item, continue to judge the operation is update otherwise remove  
				if (updatedOrRemovedOrderItemID != null) {
					//see if updatedOrRemovedOrderItemID exist in current shopping cart
					OrderItem newOrderItem = getOrderItem(orderPOJO, updatedOrRemovedOrderItemID, false);
					if (newOrderItem != null) {
						//if exist, it's an update operation 
						updatedOrderItemID = updatedOrRemovedOrderItemID;
					} else {
						//if not exist, it's an remove operation
						removedOrderItemID = updatedOrRemovedOrderItemID;
					}
				}
				
				//if add an order item
				if (newOrderItemID != null) {
					//if the item is a wrapper, wrappedOrderItemID is gift's item id
					if (wrappedOrderItemID != null) {
						//get order item from current shopping cart
						OrderItem newOrderItem = getOrderItem(orderPOJO, newOrderItemID, true);
						//find gift item
						OrderItem wrappedOrderItem = getOrderItem(orderPOJO, wrappedOrderItemID, true);
						//add wrapper info into gift's extended attribute, add gift info into wrapper's extended attribute
						addGiftWrapToOrderItem(newOrderItem, wrappedOrderItem);
					}
					// else it's not a gift wrap, just a normal item added, so
					// do nothing
				} else if (removedOrderItemID != null) {
					// get related order item
					// for gift item, found it's wrapper (maybe not exist)
					// for wrapper item, found it's gift
					OrderItem relatedOrderItem = findRelatedItemForOrderItem(orderPOJO, removedOrderItemID);
					if(relatedOrderItem != null){
						removeRelatedForOrderItem(orderPOJO, relatedOrderItem);
					}
				} else if (updatedOrderItemID != null) {
					// we assume that wrapper order items cannot be updated
					// directly, so the updated one is just a normal order item
					OrderItem wrapperOrderItem = findRelatedItemForOrderItem(orderPOJO, updatedOrderItemID);
					if (wrapperOrderItem != null) {
						OrderItem updatedOrderItem = getOrderItem(orderPOJO, updatedOrderItemID, true);
						updateGiftWrapQuantity(updatedOrderItem, wrapperOrderItem);
					}
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
		} 
		else {
			wrapperOrderItem.setQuantity(null);
		}
	}
	
	//remove related order item info
	private void removeRelatedForOrderItem(Order order, OrderItem relatedOrderItem) {
		//get attribute name
		String attr = relatedOrderItem.getOrderItemExtendAttribute().get(0).getAttributeName();
		//if we remove a gift, we can got its wrapper item, its attribute name was set as gift_orderitem_id
		//then we need remove wrapper from shopping cart
		if(attr.equals("gift_orderitem_id")){
			order.getOrderItem().remove(relatedOrderItem);
		}
		//if we remove a wrapper, we can got its gift item, its attribute name was set as wrapper_orderitem_id
		//then we need clear gift's extended attribute
		else{
			relatedOrderItem.getOrderItemExtendAttribute().get(0).setAttributeValue(null);;
		}
	}

	//add a relationship between wrapper and gift
	private void addGiftWrapToOrderItem(OrderItem wrapperOrderItem, OrderItem wrappedOrderItem) {
		//gift id
		String wrappedId = wrappedOrderItem.getOrderItemIdentifier().getUniqueID();
		//wrapper id
		String wrapperId = wrapperOrderItem.getOrderItemIdentifier().getUniqueID();
		
		//for wrapper, set its gift order item id into ExtendAttribute
		ExtendAttribute extAttr = new ExtendAttribute();
		extAttr.setAttributeName("gift_orderitem_id");
		extAttr.setAttributeValue(wrappedId);
		wrapperOrderItem.getOrderItemExtendAttribute().add(extAttr);
		
		//for gift, set its wrapper order item id into ExtendAttribute
		extAttr = new ExtendAttribute();
		extAttr.setAttributeName("wrapper_orderitem_id");
		extAttr.setAttributeValue(wrapperId);
		wrappedOrderItem.getOrderItemExtendAttribute().add(extAttr);
	}

	//Find orderItem from current shopping cart
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
	
	//find related order item for current order item
	private OrderItem findRelatedItemForOrderItem(Order order, String wrappedOrderItemID) {
		OrderItem found = null;
		
		if (order != null) {
			List<OrderItem> orderitemPOJOs = order.getOrderItem();
			if (orderitemPOJOs != null && !orderitemPOJOs.isEmpty()) {
				for (OrderItem orderitemPOJO : orderitemPOJOs) {
					List<ExtendAttribute> extAttrs = orderitemPOJO.getOrderItemExtendAttribute();
					for (ExtendAttribute extAttr : extAttrs){
						if ( extAttr.getAttributeValue().equals(wrappedOrderItemID)) {
							found = orderitemPOJO;
							break;
						}
					}
				}
			}
		}		
		return found;
	}
}
