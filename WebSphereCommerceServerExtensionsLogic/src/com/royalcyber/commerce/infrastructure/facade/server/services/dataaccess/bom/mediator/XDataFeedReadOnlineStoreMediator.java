/**
 * 
 */
package com.royalcyber.commerce.infrastructure.facade.server.services.dataaccess.bom.mediator;

import com.ibm.commerce.infrastructure.facade.datatypes.OnlineStoreType;
import com.ibm.commerce.infrastructure.facade.server.entity.datatypes.Store;
import com.ibm.commerce.infrastructure.facade.server.entity.datatypes.Storedefcat;
import com.ibm.commerce.infrastructure.facade.server.entity.datatypes.Storeent;
import com.ibm.commerce.infrastructure.facade.server.services.dataaccess.bom.mediator.ReadOnlineStoreMediator;
/*import com.ibm.commerce.base.objects.ServerJDBCHelperAccessBean;*/
import com.ibm.commerce.catalog.facade.datatypes.CatalogEntryType;
import com.ibm.commerce.catalog.facade.server.entity.datatypes.CatalogEntry;
import com.ibm.commerce.catalog.facade.server.helpers.CatalogComponentHelper;

import com.ibm.commerce.foundation.common.datatypes.UserDataType;
import com.ibm.commerce.foundation.common.exception.AbstractApplicationException;
import com.ibm.commerce.foundation.common.util.logging.LoggingHelper;
import java.io.PrintStream;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Vector;
import java.util.logging.Logger;
/**
 * @author Administrator
 *
 */
public class XDataFeedReadOnlineStoreMediator extends ReadOnlineStoreMediator {

	
	 private static final String CLASSNAME = XDataFeedReadOnlineStoreMediator.class.getName();
	  private static final Logger LOGGER = LoggingHelper.getLogger(CLASSNAME);

	  public void buildNoun(Object aLogicalEntityType, Object aPhysicalEntityType)
	    throws AbstractApplicationException
	  {
	    String METHODNAME = "buildNoun";
	    System.out.println("IN XDataFeedReadOnlineStoreMediator........................");
	    if (LoggingHelper.isEntryExitTraceEnabled(LOGGER)) {
	      LOGGER.entering(CLASSNAME, METHODNAME, new Object[] { 
	        aLogicalEntityType, aPhysicalEntityType });
	    }

	    super.buildNoun(aLogicalEntityType, aPhysicalEntityType);
	    buildAttributes(aLogicalEntityType, aPhysicalEntityType);
	    if (LoggingHelper.isEntryExitTraceEnabled(LOGGER))
	      LOGGER.exiting(CLASSNAME, METHODNAME);
	  }

	  private void buildAttributes(Object aLogicalEntityType, Object aPhysicalEntityType)
	    throws AbstractApplicationException
	  {
	    String METHODNAME = "buildAttributes";
	    if (LoggingHelper.isEntryExitTraceEnabled(LOGGER)) {
	      LOGGER.entering(CLASSNAME, METHODNAME, new Object[] { 
	        aLogicalEntityType, aPhysicalEntityType });
	    }

	
	        Storeent aPhysicalEntity = (Storeent)aPhysicalEntityType;       
            OnlineStoreType aNoun = (OnlineStoreType)aLogicalEntityType;
            Store storePhysicalDo = aPhysicalEntity.getStoreForStoreent();
            Map attributes = aNoun.getUserData().getUserDataField();
            attributes.get("Keywords");
			System.out.println("######get Vakue of process flg########: " +attributes.get("Keywords"));
		    Vector listRecords = null;
		    String sql = "select PROCESSFLAG, LASTPROCESSCOUNTER,msg,lastupdated from xdatafeed";
	
		    System.out.println("select sql : " + sql);
		    String processFlag = "";
		    String LASTPROCESSCOUNTER = "";
		    String msg = "";
		    String lastupdated = "";
		
		   /* ServerJDBCHelperAccessBean sjdbc2 = null;*/
		    try {
		    	
		      /*sjdbc2 = new ServerJDBCHelperAccessBean();
		      listRecords = sjdbc2.executeQuery(sql);
		    	*/
		    }
		    catch (Exception e) {
		      e.printStackTrace();
		    }
		    
		    try {
		      if ((listRecords != null) && (listRecords.size() > 0))
		        for (Enumeration enumeration = listRecords.elements(); enumeration.hasMoreElements(); ) {
		          Vector record = (Vector)enumeration.nextElement();
		          processFlag = String.valueOf(record.elementAt(0));
		          LASTPROCESSCOUNTER = String.valueOf(record.elementAt(1));
		          msg = String.valueOf(record.elementAt(2));
		          lastupdated = String.valueOf(record.elementAt(3));
		         
		        }
		    }
		    catch (Exception exp)
		    {
		      exp.printStackTrace();
		    }
	
		    if (processFlag.equalsIgnoreCase("active")) {
		    System.out.println("######get Vakue of process flg########: " +attributes.get("Keywords"));
		      attributes.put("enablegodatafeed", "Enable");
		      attributes.put("status", "Enable");
		      attributes.put("lastupdate", lastupdated);
		      attributes.put("errormessage", "Its already active please wait till finshed.");
	  
	       
		    }
		    
		    if (processFlag.equalsIgnoreCase("complete")) {
			      attributes.put("enablegodatafeed", "Disable");
			      attributes.put("status", "Disable");
			      attributes.put("lastupdate", lastupdated);
			      attributes.put("FeedStatus", "Feed " +LASTPROCESSCOUNTER + " was Successful");			     
			      attributes.put("errormessage", "Select Enable From DropDown to run Data Feed");
			    }
		    
		    
		    
		    if (processFlag.equalsIgnoreCase("processing")) {
			      attributes.put("enablegodatafeed", "Disable");
			      attributes.put("status", "Disable");
			      attributes.put("lastupdate", lastupdated);
			      attributes.put("errormessage", "Please wait untile processing finshed");
			      
		       
			    }  
		    
		    if (processFlag.equalsIgnoreCase("") || processFlag.equalsIgnoreCase("null")) {
			     attributes.put("enablegodatafeed", "Disable");
		      	  attributes.put("lastupdate", "");
			      attributes.put("status", "Disable");
			      attributes.put("errormessage", "Please First Enable WebFeed!");
		  
		       
			    }  
		    
		    
			   	   
		  
		   
	
		    if (LoggingHelper.isEntryExitTraceEnabled(LOGGER))
		      LOGGER.exiting(CLASSNAME, METHODNAME);
		     
		  }
		  
	  

      
  

	
}//end off class
