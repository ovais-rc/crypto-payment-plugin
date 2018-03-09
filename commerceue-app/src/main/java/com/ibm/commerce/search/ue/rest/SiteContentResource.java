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

import org.apache.wink.json4j.JSONObject;

import com.ibm.commerce.search.ue.pojo.SearchUERequest;
import com.ibm.commerce.search.ue.pojo.SearchUEResponse;

@Path("/search/sitecontent")
@SwaggerDefinition(tags = { @Tag(name = "search - site content", description = "This resource handler contains customization extensions for the SiteContent search service which is hosted on the Search server.  This SiteContent service is used for providing auto suggestion for products and keywords at the storefront, as well as performing keyword searches against product attachments.") })
@Api(value = "/search/sitecontent", tags = "search - site content")
public class SiteContentResource extends AbstractSearchResource {

	private static final Logger LOGGER = Logger
			.getLogger(SiteContentResource.class.getName());
	private static final String CLASSNAME = SiteContentResource.class
			.getName();

	@POST
	@Path("/postWebContentsBySearchTerm")
	@Consumes({ MediaType.APPLICATION_JSON })
	@Produces({ MediaType.APPLICATION_JSON })
	@ApiOperation(value = "Customize the search response after searching unstructured content details for search result page based on a search term.", response = SearchUEResponse.class)
	public Response postFindWebContentsBySearchTerm(
			@ApiParam(name = "SiteContentPost UE input", value = "The UE Request String", required = true) SearchUERequest uePostRequest) {
		final String METHODNAME = "postFindWebContentsBySearchTerm(SearchUERequest)";
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
	@Path("/preWebContentsBySearchTerm")
	@Consumes({ MediaType.APPLICATION_JSON })
	@Produces({ MediaType.APPLICATION_JSON })
	@ApiOperation(value = "Customize the search expression before searching unstructured content details for search result page based on a search term.")
	public Response preFindWebContentsBySearchTerm(
			@ApiParam(name = "SiteContentPre UE input", value = "The UE Request String", required = true) SearchUERequest uePreRequest) {
		final String METHODNAME = "preFindWebContentsBySearchTerm(SearchUERequest)";
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
	@Path("/postKeywordSuggestionsByTerm")
	@Consumes({ MediaType.APPLICATION_JSON })
	@Produces({ MediaType.APPLICATION_JSON })
	@ApiOperation(value = "Customize the search response after finding auto-suggest terms with type ahead search.", response = SearchUEResponse.class)
	public Response postFindKeywordSuggestionsByTerm(
			@ApiParam(name = "SiteContentPost UE input", value = "The UE Request String", required = true) SearchUERequest uePostRequest) {
		final String METHODNAME = "postFindKeywordSuggestionsByTerm(SearchUERequest)";
		if (LOGGER.isLoggable(Level.FINER)) {
			LOGGER.entering(CLASSNAME, METHODNAME);
		}
		
		logRequest(uePostRequest);
		Response response = null;
		response = Response.ok(uePostRequest).build();
		try{
			// Convert request into a map
			List<JSONObject> arrayContentView = uePostRequest
					.getContent();

			Iterator<JSONObject> iterator = arrayContentView.iterator();
			// Loop through each suggestion entry
			while (iterator.hasNext()) {
				JSONObject jsonObject = iterator.next();
				// Substitute the suggested product name with "Replace" if name contains "Versatil"
				@SuppressWarnings("unchecked")
				List<JSONObject> entry = (List<JSONObject>) jsonObject.get("entry");
				Iterator<JSONObject> entryIt = entry.iterator();
				while (entryIt.hasNext()) {
					JSONObject obj = entryIt.next();
					String name = (String) obj.get("name");
					if (name.contains("Versatil")){
						obj.put("name", "Replaced");
					}				
				}
			}

			// Return back to search server
			SearchUEResponse uePostResponse = new SearchUEResponse();
			uePostResponse.setContent(arrayContentView);
			response = Response.ok(uePostResponse).build();			
		} catch (Exception e){
			LOGGER.log(Level.INFO, "There was a problem in the UE code!");
			throw new RuntimeException(e);
		} finally {
			logResponse(response);
		}

		LOGGER.exiting(CLASSNAME, METHODNAME);
		return response;
	}

	@POST
	@Path("/preKeywordSuggestionsByTerm")
	@Consumes({ MediaType.APPLICATION_JSON })
	@Produces({ MediaType.APPLICATION_JSON })
	@ApiOperation(value = "Customize the search expression before finding auto-suggest terms with type ahead search.")
	public Response preFindKeywordSuggestionsByTerm(
			@ApiParam(name = "SiteContentPre UE input", value = "The UE Request String", required = true) SearchUERequest uePreRequest) {
		final String METHODNAME = "preFindKeywordSuggestionsByTerm(SearchUERequest)";
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
	@Path("/postProductSuggestionsBySearchTerm")
	@Consumes({ MediaType.APPLICATION_JSON })
	@Produces({ MediaType.APPLICATION_JSON })
	@ApiOperation(value = "Customize the search response after finding auto-suggest terms with type ahead search.", response = SearchUEResponse.class)
	public Response postFindProductSuggestionsByTerm(
			@ApiParam(name = "SiteContentPost UE input", value = "The UE Request String", required = true) SearchUERequest uePostRequest) {
		final String METHODNAME = "postFindProductSuggestionsBySearchTerm(SearchUERequest)";
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
	@Path("/preProductSuggestionsBySearchTerm")
	@Consumes({ MediaType.APPLICATION_JSON })
	@Produces({ MediaType.APPLICATION_JSON })
	@ApiOperation(value = "Customize the search expression before finding auto-suggest terms with type ahead search.")
	public Response preFindProductSuggestionsByTerm(
			@ApiParam(name = "SiteContentPre UE input", value = "The UE Request String", required = true) SearchUERequest uePreRequest) {
		final String METHODNAME = "preFindProductSuggestionsBySearchTerm(SearchUERequest)";
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
	@Path("/postCategorySuggestions")
	@Consumes({ MediaType.APPLICATION_JSON })
	@Produces({ MediaType.APPLICATION_JSON })
	@ApiOperation(value = "Customize the search response after getting all the category suggestions for auto-suggest with type ahead search.", response = SearchUEResponse.class)
	public Response postFindAllCategorySuggestions(
			@ApiParam(name = "SiteContentPost UE input", value = "The UE Request String", required = true) SearchUERequest uePostRequest) {
		final String METHODNAME = "postFindAllCategorySuggestions(SearchUERequest)";
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
	@Path("/preCategorySuggestions")
	@Consumes({ MediaType.APPLICATION_JSON })
	@Produces({ MediaType.APPLICATION_JSON })
	@ApiOperation(value = "Customize the search expression before getting all the category suggestions for auto-suggest with type ahead search.")
	public Response preFindAllCategorySuggestions(
			@ApiParam(name = "SiteContentPre UE input", value = "The UE Request String", required = true) SearchUERequest uePreRequest) {
		final String METHODNAME = "preFindAllCategorySuggestions(SearchUERequest)";
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
	@Path("/postBrandSuggestions")
	@Consumes({ MediaType.APPLICATION_JSON })
	@Produces({ MediaType.APPLICATION_JSON })
	@ApiOperation(value = "Customize the search response after getting all the brand suggestions for auto-suggest with type ahead search.", response = SearchUEResponse.class)
	public Response postFindAllBrandSuggestions(
			@ApiParam(name = "SiteContentPost UE input", value = "The UE Request String", required = true) SearchUERequest uePostRequest) {
		final String METHODNAME = "postFindAllBrandSuggestions(UERequest)";
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
	@Path("/preBrandSuggestions")
	@Consumes({ MediaType.APPLICATION_JSON })
	@Produces({ MediaType.APPLICATION_JSON })
	@ApiOperation(value = "Customize the search expression before getting all the brand suggestions for auto-suggest with type ahead search.")
	public Response preFindAllBrandSuggestions(
			@ApiParam(name = "SiteContentPre UE input", value = "The UE Request String", required = true) SearchUERequest uePreRequest) {
		final String METHODNAME = "preFindAllBrandSuggestions(SearchUERequest)";
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
	@Path("/postWebContentSuggestions")
	@Consumes({ MediaType.APPLICATION_JSON })
	@Produces({ MediaType.APPLICATION_JSON })
	@ApiOperation(value = "Customize the search response after getting all the unstructured content suggestions for auto-suggest with type ahead search.", response = SearchUEResponse.class)
	public Response postFindAllWebContentSuggestions(
			@ApiParam(name = "SiteContentPost UE input", value = "The UE Request String", required = true) SearchUERequest uePostRequest) {
		final String METHODNAME = "postFindAllWebContentSuggestions(SearchUERequest)";
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
	@Path("/preWebContentSuggestions")
	@Consumes({ MediaType.APPLICATION_JSON })
	@Produces({ MediaType.APPLICATION_JSON })
	@ApiOperation(value = "Customize the search expression before getting all the unstructured content suggestions for auto-suggest with type ahead search.")
	public Response preFindAllWebContentSuggestions(
			@ApiParam(name = "SiteContentPre UE input", value = "The UE Request String", required = true) SearchUERequest uePreRequest) {
		final String METHODNAME = "preFindAllWebContentSuggestions(SearchUERequest)";
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
	@Path("/postSuggestions")
	@Consumes({ MediaType.APPLICATION_JSON })
	@Produces({ MediaType.APPLICATION_JSON })
	@ApiOperation(value = "Customize the search response after getting all the category, brand and unstructured content suggestions for auto-suggest with type ahead search.", response = SearchUEResponse.class)
	public Response postFindSuggestions(
			@ApiParam(name = "SiteContentPost UE input", value = "The UE Request String", required = true) SearchUERequest uePostRequest) {
		final String METHODNAME = "postFindSuggestions(SearchUERequest)";
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
	@Path("/preSuggestions")
	@Consumes({ MediaType.APPLICATION_JSON })
	@Produces({ MediaType.APPLICATION_JSON })
	@ApiOperation(value = "Customize the search expression before getting all the category, brand and unstructured content suggestions for auto-suggest with type ahead search.")
	public Response preFindSuggestions(
			@ApiParam(name = "SiteContentPre UE input", value = "The UE Request String", required = true) SearchUERequest uePreRequest) {
		final String METHODNAME = "preFindSuggestions(SearchUERequest)";
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
