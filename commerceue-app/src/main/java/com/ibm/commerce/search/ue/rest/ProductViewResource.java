package com.ibm.commerce.search.ue.rest;

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

import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import io.swagger.annotations.ApiParam;
import io.swagger.annotations.SwaggerDefinition;
import io.swagger.annotations.Tag;

import java.util.Iterator;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

import javax.ws.rs.Consumes;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;

import org.apache.wink.json4j.JSONArray;
import org.apache.wink.json4j.JSONObject;

import com.ibm.commerce.search.ue.pojo.SearchUERequest;
import com.ibm.commerce.search.ue.pojo.SearchUEResponse;

@Path("/search/productview")
@SwaggerDefinition(tags = { @Tag(name = "search - product view", description = "This resource handler contains customization extensions for the ProductView search service which is hosted on the Search server.  The ProductView service is used for browsing product by category and performing keyword searches from the storefront, as well as displaying product level information such as associated attributes and the product's underlying items.") })
@Api(value = "/search/productview", tags = "search - product view")
public class ProductViewResource extends AbstractSearchResource {

	private static final Logger LOGGER = Logger
			.getLogger(ProductViewResource.class.getName());
	private static final String CLASSNAME = ProductViewResource.class.getName();

	private static final String SHORT_DESCRIPTION = "shortDescription";
	private static final String FIELD5 = "field5";
	private static final String NAME = "name";
	private static final String USER_DATA = "UserData";

	@POST
	@Path("/postBySearchTerm")
	@Consumes({ MediaType.APPLICATION_JSON })
	@Produces({ MediaType.APPLICATION_JSON })
	@ApiOperation(value = "Customize the search response after getting product details based on a search term. For example, update the short description of the given product.", response = SearchUEResponse.class)
	public Response postFindProductsBySearchTerm(
			@ApiParam(name = "ProductViewPost UE input", value = "The UE Request String", required = true) SearchUERequest uePostRequest) {
		final String METHODNAME = "postFindProductsBySearchTerm(SearchUERequest)";
		if (LOGGER.isLoggable(Level.FINER)) {
			LOGGER.entering(CLASSNAME, METHODNAME);
		}

		logRequest(uePostRequest);
		Response response = null;
		try {
			// Convert request into a map
			List<JSONObject> arrayContentView = uePostRequest
					.getContent();

			Iterator<JSONObject> iterator = arrayContentView.iterator();
			// Loop through each catentry_id
			while (iterator.hasNext()) {
				JSONObject jsonObject = iterator.next();

				// get the user data object
				if (jsonObject.get(USER_DATA) != null) {
					JSONArray userDataArray = jsonObject.getJSONArray(USER_DATA);
					
					if (!userDataArray.isEmpty()) {
						JSONObject userDataJsonObject = (JSONObject) userDataArray.get(0);
						
						Object field5Obj = userDataJsonObject.containsKey(FIELD5)
								? userDataJsonObject.get(FIELD5) : null;

						if (field5Obj != null && field5Obj instanceof String) {
							String field5 = (String) field5Obj;

							String prepend = "";
							prepend = "(" + field5 + ") ";

							String shortDescription = (String) jsonObject.get(SHORT_DESCRIPTION);
							jsonObject.put(SHORT_DESCRIPTION, prepend + shortDescription);
							String name = (String) jsonObject.get(NAME);
							jsonObject.put(NAME, prepend + name);
						}
					}
				}
			}

			// Return back to search server
			SearchUEResponse uePostResponse = new SearchUEResponse();
			uePostResponse.setContent(arrayContentView);
			response = Response.ok(uePostResponse).build();
		} catch (Exception e) {
			throw new RuntimeException(e);
		} finally {
			logResponse(response);
		}

		LOGGER.exiting(CLASSNAME, METHODNAME);
		return response;
	}

	@POST
	@Path("/preBySearchTerm")
	@Consumes({ MediaType.APPLICATION_JSON })
	@Produces({ MediaType.APPLICATION_JSON })
	@ApiOperation(value = "Customize the search expression before getting product details based on a search term.")
	public Response preFindProductsBySearchTerm(
			@ApiParam(name = "ProductViewPre UE input", value = "The UE Request String", required = true) SearchUERequest uePreRequest) {
		final String METHODNAME = "preFindProductsBySearchTerm(SearchUERequest)";
		if (LOGGER.isLoggable(Level.FINER)) {
			LOGGER.entering(CLASSNAME, METHODNAME);
		}

		logRequest(uePreRequest);
		Response response = null;
		try {
			// Convert request into a map of JSONObject of JSONArray
			List<JSONObject> contentView = uePreRequest
					.getContent();

			// Updating the sort criteria to use non-tokenized name column
			setControlParameterValue(contentView, "_wcf.search.internal.sort", "name_ntk asc");
			
			// Return back to search server
			SearchUEResponse uePreResponse = new SearchUEResponse();
			uePreResponse.setContent(contentView);
			response = Response.ok(uePreResponse).build();
		} catch (Exception e) {
			throw new RuntimeException(e);
		} finally {
			logResponse(response);
		}

		LOGGER.exiting(CLASSNAME, METHODNAME);
		return response;
	}

	@POST
	@Path("/postById")
	@Consumes({ MediaType.APPLICATION_JSON })
	@Produces({ MediaType.APPLICATION_JSON })
	@ApiOperation(value = "Customize the search response after getting product details based on the product ID.", response = SearchUEResponse.class)
	public Response postFindProductsById(
			@ApiParam(name = "ProductViewPost UE input", value = "The UE Request String", required = true) SearchUERequest uePostRequest) {
		final String METHODNAME = "postFindProductsById(SearchUERequest)";
		if (LOGGER.isLoggable(Level.FINER)) {
			LOGGER.entering(CLASSNAME, METHODNAME);
		}

		logRequest(uePostRequest);
		Response response = null;
		try {
			// Convert request into a map of JSONObject of JSONArray
			List<JSONObject> contentView = uePostRequest
					.getContent();

			// Put your customization logic here ....
		
			// Return back to search server
			SearchUEResponse uePostResponse = new SearchUEResponse();
			uePostResponse.setContent(contentView);
			response = Response.ok(uePostResponse).build();
		} catch (Exception e) {
			throw new RuntimeException(e);
		} finally {
			logResponse(response);
		}

		LOGGER.exiting(CLASSNAME, METHODNAME);
		return response;
	}

	@POST
	@Path("/preById")
	@Consumes({ MediaType.APPLICATION_JSON })
	@Produces({ MediaType.APPLICATION_JSON })
	@ApiOperation(value = "Customize the search expression before getting product details based on the product ID.")
	public Response preFindProductsById(
			@ApiParam(name = "ProductViewPre UE input", value = "The UE Request String", required = true) SearchUERequest uePreRequest) {
		final String METHODNAME = "preFindProductsById(SearchUERequest)";
		if (LOGGER.isLoggable(Level.FINER)) {
			LOGGER.entering(CLASSNAME, METHODNAME);
		}

		logRequest(uePreRequest);
		Response response = null;
		try {
			// Convert request into a map of JSONObject of JSONArray
			List<JSONObject> contentView = uePreRequest
					.getContent();

			// Put your customization logic here ....
		
			// Return back to search server
			SearchUEResponse uePreResponse = new SearchUEResponse();
			uePreResponse.setContent(contentView);
			response = Response.ok(uePreResponse).build();
		} catch (Exception e) {
			throw new RuntimeException(e);
		} finally {
			logResponse(response);
		}

		LOGGER.exiting(CLASSNAME, METHODNAME);
		return response;
	}

	@POST
	@Path("/postByIds")
	@Consumes({ MediaType.APPLICATION_JSON })
	@Produces({ MediaType.APPLICATION_JSON })
	@ApiOperation(value = "Customize the search response after getting product details based on the product IDs.", response = SearchUEResponse.class)
	public Response postFindProductsByIds(
			@ApiParam(name = "ProductViewPost UE input", value = "The UE Request String", required = true) SearchUERequest uePostRequest) {
		final String METHODNAME = "postFindProductsByIds(SearchUERequest)";
		if (LOGGER.isLoggable(Level.FINER)) {
			LOGGER.entering(CLASSNAME, METHODNAME);
		}

		logRequest(uePostRequest);
		Response response = null;
		try {
			// Convert request into a map of JSONObject of JSONArray
			List<JSONObject> contentView = uePostRequest
					.getContent();

			// Put your customization logic here ....
		
			// Return back to search server
			SearchUEResponse uePostResponse = new SearchUEResponse();
			uePostResponse.setContent(contentView);
			response = Response.ok(uePostResponse).build();
		} catch (Exception e) {
			throw new RuntimeException(e);
		} finally {
			logResponse(response);
		}

		LOGGER.exiting(CLASSNAME, METHODNAME);
		return response;
	}

	@POST
	@Path("/preByIds")
	@Consumes({ MediaType.APPLICATION_JSON })
	@Produces({ MediaType.APPLICATION_JSON })
	@ApiOperation(value = "Customize the search expression before getting product details based on the product IDs.")
	public Response preFindProductsByIds(
			@ApiParam(name = "ProductViewPre UE input", value = "The UE Request String", required = true) SearchUERequest uePreRequest) {
		final String METHODNAME = "preFindProductsByIds(SearchUERequest)";
		if (LOGGER.isLoggable(Level.FINER)) {
			LOGGER.entering(CLASSNAME, METHODNAME);
		}

		logRequest(uePreRequest);
		Response response = null;
		try {
			// Convert request into a map of JSONObject of JSONArray
			List<JSONObject> contentView = uePreRequest
					.getContent();

			// Put your customization logic here ....
		
			// Return back to search server
			SearchUEResponse uePreResponse = new SearchUEResponse();
			uePreResponse.setContent(contentView);
			response = Response.ok(uePreResponse).build();
		} catch (Exception e) {
			throw new RuntimeException(e);
		} finally {
			logResponse(response);
		}

		LOGGER.exiting(CLASSNAME, METHODNAME);
		return response;
	}

	@POST
	@Path("/postByPartNumber")
	@Consumes({ MediaType.APPLICATION_JSON })
	@Produces({ MediaType.APPLICATION_JSON })
	@ApiOperation(value = "Customize the search response after getting product details based on the part number.", response = SearchUEResponse.class)
	public Response postFindProductsByPartNumber(
			@ApiParam(name = "ProductViewPost UE input", value = "The UE Request String", required = true) SearchUERequest uePostRequest) {
		final String METHODNAME = "postFindProductsByPartNumber(SearchUERequest)";
		if (LOGGER.isLoggable(Level.FINER)) {
			LOGGER.entering(CLASSNAME, METHODNAME);
		}

		logRequest(uePostRequest);
		Response response = null;
		try {
			// Convert request into a map of JSONObject of JSONArray
			List<JSONObject> contentView = uePostRequest
					.getContent();

			// Put your customization logic here ....
		
			// Return back to search server
			SearchUEResponse uePostResponse = new SearchUEResponse();
			uePostResponse.setContent(contentView);
			response = Response.ok(uePostResponse).build();
		} catch (Exception e) {
			throw new RuntimeException(e);
		} finally {
			logResponse(response);
		}

		LOGGER.exiting(CLASSNAME, METHODNAME);
		return response;
	}

	@POST
	@Path("/preByPartNumber")
	@Consumes({ MediaType.APPLICATION_JSON })
	@Produces({ MediaType.APPLICATION_JSON })
	@ApiOperation(value = "Customize the search expression before getting product details based on the part number.")
	public Response preFindProductsByPartNumber(
			@ApiParam(name = "ProductViewPre UE input", value = "The UE Request String", required = true) SearchUERequest uePreRequest) {
		final String METHODNAME = "preFindProductsByPartNumber(SearchUERequest)";
		if (LOGGER.isLoggable(Level.FINER)) {
			LOGGER.entering(CLASSNAME, METHODNAME);
		}

		logRequest(uePreRequest);
		Response response = null;
		try {
			// Convert request into a map of JSONObject of JSONArray
			List<JSONObject> contentView = uePreRequest
					.getContent();

			// Put your customization logic here ....
		
			// Return back to search server
			SearchUEResponse uePreResponse = new SearchUEResponse();
			uePreResponse.setContent(contentView);
			response = Response.ok(uePreResponse).build();
		} catch (Exception e) {
			throw new RuntimeException(e);
		} finally {
			logResponse(response);
		}

		LOGGER.exiting(CLASSNAME, METHODNAME);
		return response;
	}

	@POST
	@Path("/postByPartNumbers")
	@Consumes({ MediaType.APPLICATION_JSON })
	@Produces({ MediaType.APPLICATION_JSON })
	@ApiOperation(value = "Customize the search response after getting product details based on the part numbers.", response = SearchUEResponse.class)
	public Response postFindProductsByPartNumbers(
			@ApiParam(name = "ProductViewPost UE input", value = "The UE Request String", required = true) SearchUERequest uePostRequest) {
		final String METHODNAME = "postFindProductsByPartNumbers(SearchUERequest)";
		if (LOGGER.isLoggable(Level.FINER)) {
			LOGGER.entering(CLASSNAME, METHODNAME);
		}

		logRequest(uePostRequest);
		Response response = null;
		try {
			// Convert request into a map of JSONObject of JSONArray
			List<JSONObject> contentView = uePostRequest
					.getContent();

			// Put your customization logic here ....
		
			// Return back to search server
			SearchUEResponse uePostResponse = new SearchUEResponse();
			uePostResponse.setContent(contentView);
			response = Response.ok(uePostResponse).build();
		} catch (Exception e) {
			throw new RuntimeException(e);
		} finally {
			logResponse(response);
		}

		LOGGER.exiting(CLASSNAME, METHODNAME);
		return response;
	}

	@POST
	@Path("/preByPartNumbers")
	@Consumes({ MediaType.APPLICATION_JSON })
	@Produces({ MediaType.APPLICATION_JSON })
	@ApiOperation(value = "Customize the search expression before getting product details based on the part numbers.")
	public Response preFindProductsByPartNumbers(
			@ApiParam(name = "ProductViewPre UE input", value = "The UE Request String", required = true) SearchUERequest uePreRequest) {
		final String METHODNAME = "preFindProductsByPartNumbers(SearchUERequest)";
		if (LOGGER.isLoggable(Level.FINER)) {
			LOGGER.entering(CLASSNAME, METHODNAME);
		}

		logRequest(uePreRequest);
		Response response = null;
		try {
			// Convert request into a map of JSONObject of JSONArray
			List<JSONObject> contentView = uePreRequest
					.getContent();

			// Put your customization logic here ....
		
			// Return back to search server
			SearchUEResponse uePreResponse = new SearchUEResponse();
			uePreResponse.setContent(contentView);
			response = Response.ok(uePreResponse).build();
		} catch (Exception e) {
			throw new RuntimeException(e);
		} finally {
			logResponse(response);
		}

		LOGGER.exiting(CLASSNAME, METHODNAME);
		return response;
	}

	@POST
	@Path("/postByCategory")
	@Consumes({ MediaType.APPLICATION_JSON })
	@Produces({ MediaType.APPLICATION_JSON })
	@ApiOperation(value = "Customize the search response after getting product details based on the category.", response = SearchUEResponse.class)
	public Response postFindProductsByCategory(
			@ApiParam(name = "ProductViewPost UE input", value = "The UE Request String", required = true) SearchUERequest uePostRequest) {
		final String METHODNAME = "postFindProductsByCategory(SearchUERequest)";
		if (LOGGER.isLoggable(Level.FINER)) {
			LOGGER.entering(CLASSNAME, METHODNAME);
		}

		logRequest(uePostRequest);
		Response response = null;
		try {
			// Convert request into a map of JSONObject of JSONArray
			List<JSONObject> contentView = uePostRequest
					.getContent();

			// Put your customization logic here ....
		
			// Return back to search server
			SearchUEResponse uePostResponse = new SearchUEResponse();
			uePostResponse.setContent(contentView);
			response = Response.ok(uePostResponse).build();
		} catch (Exception e) {
			throw new RuntimeException(e);
		} finally {
			logResponse(response);
		}

		LOGGER.exiting(CLASSNAME, METHODNAME);
		return response;
	}

	@POST
	@Path("/preByCategory")
	@Consumes({ MediaType.APPLICATION_JSON })
	@Produces({ MediaType.APPLICATION_JSON })
	@ApiOperation(value = "Customize the search expression before getting product details based on the category.")
	public Response preFindProductsByCategory(
			@ApiParam(name = "ProductViewPre UE input", value = "The UE Request String", required = true) SearchUERequest uePreRequest) {
		final String METHODNAME = "preFindProductsByCategory(SearchUERequest)";
		if (LOGGER.isLoggable(Level.FINER)) {
			LOGGER.entering(CLASSNAME, METHODNAME);
		}
		
		logRequest(uePreRequest);
		Response response = null;
		try {
			// Convert request into a map of JSONObject of JSONArray
			List<JSONObject> contentView = uePreRequest
					.getContent();

			// Put your customization logic here ....
		
			// Return back to search server
			SearchUEResponse uePreResponse = new SearchUEResponse();
			uePreResponse.setContent(contentView);
			response = Response.ok(uePreResponse).build();
		} catch (Exception e) {
			throw new RuntimeException(e);
		} finally {
			logResponse(response);
		}

		LOGGER.exiting(CLASSNAME, METHODNAME);
		return response;
	}
}
