package com.royalcyber.commerce.infrastructure.facade.server.services.dataaccess.bom.mediator;

import com.ibm.commerce.infrastructure.facade.server.services.dataaccess.bom.mediator.ChangeOnlineStoreMediator;
import java.util.logging.Logger;

import com.ibm.commerce.foundation.common.exception.AbstractApplicationException;
import com.ibm.commerce.foundation.common.util.logging.LoggingHelper;
import com.ibm.commerce.foundation.server.services.dataaccess.exception.DataMediatorException;


public class XDataFeedChangeOnlineStoreMediator extends
		ChangeOnlineStoreMediator {
	
	
	
	

	
	private static final String CLASSNAME = XDataFeedChangeOnlineStoreMediator.class.getName();
	private static final Logger LOGGER = LoggingHelper.getLogger(CLASSNAME);

	/**
	 * 
	 */
	
	
	// TODO Auto-generated constructor stub
		
	
	
	 public void create(Object aNoun)
     throws AbstractApplicationException
 {
     String METHODNAME = "create";
     System.out.println("Test................. XDataFeedChangeOnlineStoreMediator");
     super.create(aNoun);
     if(LoggingHelper.isEntryExitTraceEnabled(LOGGER))
         LOGGER.entering(CLASSNAME, "create", new Object[] {
             aNoun
         });
     if(LoggingHelper.isEntryExitTraceEnabled(LOGGER))
         LOGGER.exiting(CLASSNAME, "create");
 }

 public void change(Object aNoun)
     throws AbstractApplicationException
 {
     String METHODNAME = "change";
     System.out.println("Test................. XDataFeedChangeOnlineStoreMediator");
     super.change(aNoun);
     System.out.println("Test................. XDataFeedChangeOnlineStoreMediator");
     if(LoggingHelper.isEntryExitTraceEnabled(LOGGER))
     {
         LOGGER.entering(CLASSNAME, "change", new Object[] {
             aNoun
         });
         LOGGER.exiting(CLASSNAME, "change");
     }
 }

 public void delete(Object aNoun)
     throws AbstractApplicationException
 {
     String METHODNAME = "delete";
     System.out.println("Test................. XDataFeedChangeOnlineStoreMediator");
     super.delete(aNoun);
     System.out.println("Test................. XDataFeedChangeOnlineStoreMediator");
     if(LoggingHelper.isEntryExitTraceEnabled(LOGGER))
         LOGGER.entering(CLASSNAME, "delete", new Object[] {
             aNoun
         });
     if(LoggingHelper.isEntryExitTraceEnabled(LOGGER))
         LOGGER.exiting(CLASSNAME, "delete");
 }

 public Object findPhysicalEntity(Object aNoun)
     throws DataMediatorException
 {
     String METHODNAME = "findPhysicalEntity";
     System.out.println("Test................. XDataFeedChangeOnlineStoreMediator");
     super.findPhysicalEntity(aNoun);
     System.out.println("Test................. XDataFeedChangeOnlineStoreMediator");
     if(LoggingHelper.isEntryExitTraceEnabled(LOGGER))
         LOGGER.entering(CLASSNAME, "findPhysicalEntity", new Object[] {
             aNoun
         });
	return METHODNAME;
     
 
 }

}
