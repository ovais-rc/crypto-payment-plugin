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

import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

import javax.ws.rs.Consumes;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;

import org.apache.wink.json4j.JSONObject;

import com.ibm.commerce.search.ue.pojo.SearchUERequest;
import com.ibm.commerce.search.ue.pojo.SearchUEResponse;

@Path("/search/categoryview")
@SwaggerDefinition(tags = { @Tag(name = "search - category view", description = "This resource handler contains customization extensions for the CategoryView search service which is hosted on the Search server.  The CategoryView search service is used for displaying category level information, as well as retrieving the catalog hierarchy structure for use in the top navigation menu.") })
@Api(value = "/search/categoryview", tags = "search - category view")
public class CategoryViewResource extends AbstractSearchResource {

	private static final Logger LOGGER = Logger
			.getLogger(CategoryViewResource.class.getName());
	private static final String CLASSNAME = CategoryViewResource.class
			.getName();

	@POST
	@Path("/postById")
	@Consumes({ MediaType.APPLICATION_JSON })
	@Produces({ MediaType.APPLICATION_JSON })
	@ApiOperation(value = "Customize the search response after getting category details based on the unique ID.", response = SearchUEResponse.class)
	public Response postFindCategoryByUniqueId(
			@ApiParam(name = "CategoryViewPost UE input", value = "The UE Request String", required = true) SearchUERequest uePostRequest) {
		final String METHODNAME = "postFindCategoryByUniqueId(SearchUERequest)";
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
	@ApiOperation(value = "Customize the search expression before getting category details based on the unique ID.")
	public Response preFindCategoryByUniqueId(
			@ApiParam(name = "CategoryViewPre UE input", value = "The UE Request String", required = true) SearchUERequest uePreRequest) {
		final String METHODNAME = "preFindCategoryByUniqueId(SearchUERequest)";
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
	@ApiOperation(value = "Customize the search response after getting category details based on the unique IDs.", response = SearchUEResponse.class)
	public Response postFindCategoryByUniqueIds(
			@ApiParam(name = "CategoryViewPost UE input", value = "The UE Request String", required = true) SearchUERequest uePostRequest) {
		final String METHODNAME = "postFindCategoryByUniqueIds(SearchUERequest)";
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
	@ApiOperation(value = "Customize the search expression before getting category details based on the unique IDs.")
	public Response preFindCategoryByUniqueIds(
			@ApiParam(name = "CategoryViewPre UE input", value = "The UE Request String", required = true) SearchUERequest uePreRequest) {
		final String METHODNAME = "preFindCategoryByUniqueIds(SearchUERequest)";
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
	@Path("/postByIdentifier")
	@Consumes({ MediaType.APPLICATION_JSON })
	@Produces({ MediaType.APPLICATION_JSON })
	@ApiOperation(value = "Customize the search response after getting category details based on the identifier.", response = SearchUEResponse.class)
	public Response postFindCategoryByIdentifier(
			@ApiParam(name = "CategoryViewPost UE input", value = "The UE Request String", required = true) SearchUERequest uePostRequest) {
		final String METHODNAME = "postFindCategoryByIdentifier(SearchUERequest)";
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
	@Path("/preByIdentifier")
	@Consumes({ MediaType.APPLICATION_JSON })
	@Produces({ MediaType.APPLICATION_JSON })
	@ApiOperation(value = "Customize the search expression before getting category details based on the identifier.")
	public Response preFindCategoryByIdentifier(
			@ApiParam(name = "CategoryViewPre UE input", value = "The UE Request String", required = true) SearchUERequest uePreRequest) {
		final String METHODNAME = "preFindCategoryByIdentifier(SearchUERequest)";
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
	@Path("/post@top")
	@Consumes({ MediaType.APPLICATION_JSON })
	@Produces({ MediaType.APPLICATION_JSON })
	@ApiOperation(value = "Customize the search response Customize the search response after getting all the top level categories and optional subcategories.", response = SearchUEResponse.class)
	public Response postFindTopCategories(
			@ApiParam(name = "CategoryViewPost UE input", value = "The UE Request String", required = true) SearchUERequest uePostRequest) {
		final String METHODNAME = "postFindTopCategories(SearchUERequest)";
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
	@Path("/pre@top")
	@Consumes({ MediaType.APPLICATION_JSON })
	@Produces({ MediaType.APPLICATION_JSON })
	@ApiOperation(value = "Customize the search expression before getting all the top level categories and optionally subcategories.")
	public Response preFindTopCategories(
			@ApiParam(name = "CategoryViewPre UE input", value = "The UE Request String", required = true) SearchUERequest uePreRequest) {
		final String METHODNAME = "preFindTopCategories(SearchUERequest)";
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
	@Path("/postByParentCategory")
	@Consumes({ MediaType.APPLICATION_JSON })
	@Produces({ MediaType.APPLICATION_JSON })
	@ApiOperation(value = "Customize the search response after getting child categories based on the parent category unique ID.", response = SearchUEResponse.class)
	public Response postFindSubCategories(
			@ApiParam(name = "CategoryViewPost UE input", value = "The UE Request String", required = true) SearchUERequest uePostRequest) {
		final String METHODNAME = "postFindSubCategories(SearchUERequest)";
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
	@Path("/preByParentCategory")
	@Consumes({ MediaType.APPLICATION_JSON })
	@Produces({ MediaType.APPLICATION_JSON })
	@ApiOperation(value = "Customize the search expression before getting child categories based on the parent category unique ID.")
	public Response preFindSubCategories(
			@ApiParam(name = "CategoryViewPre UE input", value = "The UE Request String", required = true) SearchUERequest uePreRequest) {
		final String METHODNAME = "preFindSubCategories(SearchUERequest)";
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
