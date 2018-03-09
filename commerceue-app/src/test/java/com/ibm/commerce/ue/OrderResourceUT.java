package com.ibm.commerce.ue;

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

import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;

import java.util.List;
import java.util.Map;

import javax.json.spi.JsonProvider;
import javax.ws.rs.client.Client;
import javax.ws.rs.client.ClientBuilder;

import junit.framework.TestCase;

import org.junit.runner.RunWith;
import org.mockito.Matchers;
import org.mockito.Mock;
import org.powermock.api.mockito.PowerMockito;
import org.powermock.core.classloader.annotations.PrepareForTest;
import org.powermock.modules.junit4.PowerMockRunner;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.ibm.commerce.foundation.common.entities.CatalogEntryIdentifier;
import com.ibm.commerce.foundation.common.entities.Quantity;
import com.ibm.commerce.foundation.ue.util.UserExitUtil;
import com.ibm.commerce.order.entities.Order;
import com.ibm.commerce.order.entities.OrderItem;
import com.ibm.commerce.order.ue.entities.OrderPostUERequest;
import com.ibm.commerce.order.ue.entities.OrderPreUERequest;
import com.ibm.commerce.order.ue.rest.OrderResource;

@RunWith(PowerMockRunner.class)
@PrepareForTest( { 
	OrderResource.class, // Need the unit under test as it instantiates objects we want to mock
	UserExitUtil.class
	})
public class OrderResourceUT extends TestCase {
	
	@Mock
	private OrderPostUERequest mockPostUeRequest;
	@Mock
	private OrderPreUERequest mockPreUeRequest;
	@Mock
	private Order mockOrderPojo;
	@Mock
	private UserExitUtil mockUserExitUtil;
	@Mock
	private ObjectMapper mockObjectMapper;
	@Mock
	private OrderPostUERequest mockPostUERequest;
	@Mock
	private OrderResource t;
	
	protected void setUp() throws Exception {
		super.setUp();
		
		mockObjectMapper = mock(ObjectMapper.class);
		
		PowerMockito.mockStatic(UserExitUtil.class);
		mockUserExitUtil = mock(UserExitUtil.class);
		when(UserExitUtil.getMapper()).thenReturn(mockObjectMapper);
		
		mockPostUERequest = mock(OrderPostUERequest.class);
		
		when(mockPostUERequest.getOrder()).thenReturn(mockOrderPojo);

		t = new OrderResource();
	}

	protected void tearDown() throws Exception {
		super.tearDown();
	}

	public void testValidateQuantity_happyPath_successful() {
		String uniqueId = "12703";
		String quantityName = "quantity_";
		Double quantityValue = 10.0;
		String totalQuantity = "1";
		Double catEntry = 12703.0;
		
		OrderItem mockOrderitemPOJO = mock(OrderItem.class);
		CatalogEntryIdentifier mockCatalogEntryId = mock(CatalogEntryIdentifier.class);
		Quantity mockQuantity = mock(Quantity.class);
		List<Map<String, Object>> mockRequestPropertyPOJOs = mock(List.class);		
		t.validateQuantity(mockPreUeRequest);
		
		when(mockOrderitemPOJO.getQuantity()).thenReturn(mockQuantity);
		
		when(mockQuantity.getValue()).thenReturn(quantityValue);
		
		when(mockOrderitemPOJO.getCatalogEntryIdentifier()).thenReturn(mockCatalogEntryId);
		when(mockCatalogEntryId.getUniqueID()).thenReturn(uniqueId);
				
		assertEquals(mockCatalogEntryId.getUniqueID(), uniqueId);
		assertEquals(mockQuantity.getValue(), quantityValue);
	}
	
	public void testSynchGiftWrap_happyPath_successful() {

		OrderItem mockOrderitemPOJO = mock(OrderItem.class);
		CatalogEntryIdentifier mockCatalogEntryId = mock(CatalogEntryIdentifier.class);
		Quantity mockQuantity = mock(Quantity.class);
		List<Map> mockRequestPropertyPOJOs = mock(List.class);
		
		t.synchGiftWrap(mockPostUeRequest);
	}
	
	Client createClient() {
        return ClientBuilder
                .newBuilder()
                .register(JsonProvider.class)
                .build();
    }
}
