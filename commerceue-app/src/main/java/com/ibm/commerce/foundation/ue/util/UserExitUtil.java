package com.ibm.commerce.foundation.ue.util;

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

import java.lang.reflect.Field;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.logging.Logger;

import javax.ws.rs.core.Response.Status;

import com.fasterxml.jackson.annotation.JsonInclude.Include;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import com.ibm.commerce.foundation.entities.Message;
import com.ibm.commerce.order.entities.Order;
import com.ibm.commerce.order.ue.entities.OrderCustomJobUEResponse;
import com.ibm.commerce.order.ue.entities.OrderPostUEResponse;
import com.ibm.commerce.order.ue.entities.OrderPreUEResponse;
import com.ibm.commerce.order.ue.entities.OrderReplaceUEResponse;
import com.ibm.commerce.member.entities.Person;
import com.ibm.commerce.member.ue.entities.PersonPostUEResponse;
import com.ibm.commerce.member.ue.entities.PersonPreUEResponse;
import com.ibm.commerce.member.ue.entities.PersonReplaceUEResponse;
import com.ibm.commerce.ue.rest.MessageKey;

public class UserExitUtil {
	
	private static final Logger LOGGER = Logger
			.getLogger(UserExitUtil.class.getName());
	
	private static final Object lock = new Object();
	private static volatile ObjectMapper mapper;
	
	private static Locale locale = new Locale(
			MessageKey.getConfig("_CONFIG_LANGUAGE"),
			MessageKey.getConfig("_CONFIG_LOCALE"));

	public static ObjectMapper getMapper() {
		if (mapper == null) {
			synchronized (lock) {
				if (mapper == null) {
					mapper = new ObjectMapper();
					mapper = mapper.configure(SerializationFeature.FAIL_ON_EMPTY_BEANS,
							false);
					mapper.setSerializationInclusion(Include.NON_NULL);
				}
			}
		}

		return mapper;
	}

	public static OrderPreUEResponse createPreUEResponse(Order nounData,
			Map<String, Object> inputParameters) {
		OrderPreUEResponse ueResponse = new OrderPreUEResponse();
		ueResponse.setOrder(nounData);
		ueResponse.setCommandInputs(inputParameters);
		return ueResponse;
	}

	public static OrderReplaceUEResponse createReplaceUEResponse(Order nounData,
			Map<String, Object> outputParameters) {
		OrderReplaceUEResponse ueResponse = new OrderReplaceUEResponse();
		ueResponse.setOrder(nounData);
		ueResponse.setCommandOutputs(outputParameters);
		return ueResponse;
	}

	public static OrderCustomJobUEResponse createReplaceUEResponse(List<Order> nounData, List<Message> messages, 
			Map<String, Object> outputParameters) {
		OrderCustomJobUEResponse ueResponse = new OrderCustomJobUEResponse();
		ueResponse.setOrders(nounData);
		//ueResponse.setEmails(emails);
		ueResponse.setMessages(messages);
		ueResponse.setCommandOutputs(outputParameters);
		return ueResponse;
	}
	
	public static OrderPostUEResponse createPostUEResponse(Order nounData,
			Map<String, Object> outputParameters) {
		OrderPostUEResponse ueResponse = new OrderPostUEResponse();
		ueResponse.setOrder(nounData);
		ueResponse.setCommandOutputs(outputParameters);
		return ueResponse;
	}
	
	public static PersonPreUEResponse createPreUEResponse(Person nounData,
			Map<String, Object> inputParameters) {
		PersonPreUEResponse ueResponse = new PersonPreUEResponse();
		ueResponse.setPerson(nounData);
		ueResponse.setCommandInputs(inputParameters);
		return ueResponse;
	}

	public static PersonReplaceUEResponse createReplaceUEResponse(Person nounData,
			Map<String, Object> outputParameters) {
		PersonReplaceUEResponse ueResponse = new PersonReplaceUEResponse();
		ueResponse.setPerson(nounData);
		ueResponse.setCommandOutputs(outputParameters);
		return ueResponse;
	}

	public static PersonPostUEResponse createPostUEResponse(Person nounData,
			Map<String, Object> outputParameters) {
		PersonPostUEResponse ueResponse = new PersonPostUEResponse();
		ueResponse.setPerson(nounData);
		ueResponse.setCommandOutputs(outputParameters);
		return ueResponse;
	}
	
	@SuppressWarnings("unchecked")
	public static void setPropertiesFromInputToOutput(Object UEInput, Class taskCmdUEInputClass,
			Object UEoutput, Class taskCmdUEOutputClass,List<Field> fields) {
		try {
			for(Field field : fields){
				if("contextData".equals(field.getName())){
					continue;
				}else {
					Method inputMethod = taskCmdUEInputClass.getMethod(fieldToGetter(field.getName()));
					Method outputMethod = taskCmdUEOutputClass.getMethod(fieldToSetter(field.getName()),field.getType());	
					outputMethod.invoke(UEoutput,inputMethod.invoke(UEInput));
				}
			}
		} catch (NoSuchMethodException e) {
			LOGGER.info("Cannot set property from input" + e);
		} catch ( SecurityException | IllegalAccessException | IllegalArgumentException| InvocationTargetException e){
			throw new RuntimeException(e + " "
					+ Status.INTERNAL_SERVER_ERROR.getStatusCode() + " "
					+ "Cannot set property from input");
		}
		
	}
	
	public static String fieldToSetter(String field) {
		if(field == null || field.trim().isEmpty())
			return field;
		if(field.trim().length() == 1)
			return "set" + field.toUpperCase();
		return "set" + field.substring(0,1).toUpperCase() + field.substring(1);
	}
	
	public static String fieldToGetter(String field) {
		if(field == null || field.trim().isEmpty())
			return field;
		if(field.trim().length() == 1)
			return "get" + field.toUpperCase();
		return "get" + field.substring(0,1).toUpperCase() + field.substring(1);
	}
}
