package com.ibm.commerce.foundation.ue.util;

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

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;

import com.fasterxml.jackson.core.JsonParseException;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

/**
 * This class provides convenience methods to convert between SDO objects, POJOs
 * and JSON, as well as filtering.
 */
public class ConverterUtil {

	/**
	 * Converts the given JSON to an instance of the given class.
	 * 
	 * @param json
	 *            The JSON to convert. This value cannot be null or empty.
	 * @param c
	 *            The class to instantiate to contain the JSON data. This value
	 *            cannot be null.
	 * 
	 * @return The instance of the class that contains all the data in the JSON.
	 *         This value will not be null.
	 * 
	 * @throws IOException
	 *             If an error occurs while reading the JSON.
	 * @throws JsonMappingException
	 *             If an error occurs while trying to put the data in the class
	 *             instance.
	 * @throws JsonParseException
	 *             If an error occurs while parsing the JSON.
	 
	public static <T> T convertToPojo(String json, Class c)
			throws JsonParseException, JsonMappingException, IOException {
		ChangeResponseRegistry registry = ChangeResponseRegistry.getInstance();
		ObjectMapper mapper = registry.getMapper();
		T pojo = (T) mapper.readValue(json, c);
		return pojo;
	}*/



	/**
	 * Converts the given POJO to JSON.
	 * 
	 * @param object
	 *            The POJO object to convert. This value cannot be null.
	 * 
	 * @return The JSON that contains the data from the POJO. This value will
	 *         not be null or empty.
	 * 
	 * @throws JsonProcessingException
	 *             If an error occurs while generating the JSON.
	 * 
	 
	public static String convertToJson(Object object)
			throws JsonProcessingException {
		ChangeResponseRegistry registry = ChangeResponseRegistry.getInstance();
		ObjectMapper mapper = registry.getMapper();
		String orderString = mapper.writeValueAsString(object);

		return orderString;
	}*/

}
