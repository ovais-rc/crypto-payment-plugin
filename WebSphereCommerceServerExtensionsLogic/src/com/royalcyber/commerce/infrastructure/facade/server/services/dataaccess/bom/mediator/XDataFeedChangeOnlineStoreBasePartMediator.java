/**
 * 
 */
package com.royalcyber.commerce.infrastructure.facade.server.services.dataaccess.bom.mediator;

import java.sql.Timestamp;
import java.util.logging.Logger;

import com.ibm.commerce.exception.ECException;
import com.ibm.commerce.foundation.common.exception.AbstractApplicationException;
import com.ibm.commerce.foundation.common.util.logging.LoggingHelper;

import com.ibm.commerce.infrastructure.facade.datatypes.impl.OnlineStoreTypeImpl;
import com.ibm.commerce.infrastructure.facade.server.entity.datatypes.Store;
import com.ibm.commerce.infrastructure.facade.server.entity.datatypes.impl.StoreentImpl;
import com.ibm.commerce.infrastructure.facade.server.services.dataaccess.bom.mediator.ChangeOnlineStoreBasePartMediator;
import com.ibm.commerce.scheduler.commands.AddJobCmd;
import com.ibm.commerce.server.ECConstants;
import com.ibm.commerce.webcontroller.WebAdapterContextHelper;
import com.royalcyber.dataFeed.commands.DataFeedCmd;
import com.royalcyber.dataFeed.commands.DataFeedHandler;

import java.io.PrintStream;
import java.util.Date;
import java.util.Enumeration;
import java.util.Map;
import java.util.Vector;

import com.ibm.commerce.catalog.facade.server.helpers.CatalogComponentHelper;
import com.ibm.commerce.command.CommandContext;
import com.ibm.commerce.command.CommandFactory;
import com.ibm.commerce.context.baseimpl.ContextHelper;
import com.ibm.commerce.datatype.TypedProperty;
/**
 * @author Administrator
 *
 */
public class XDataFeedChangeOnlineStoreBasePartMediator extends
		ChangeOnlineStoreBasePartMediator {
	
	private static final String CLASSNAME = XDataFeedChangeOnlineStoreBasePartMediator.class.getName();
	private static final Logger LOGGER = LoggingHelper.getLogger(CLASSNAME);
	
	
	  public void create(Object aNoun, Object aNounPart)
      throws AbstractApplicationException
  {
      String METHODNAME = "create";
      if(LoggingHelper.isEntryExitTraceEnabled(LOGGER))
      {
          LOGGER.entering(CLASSNAME, "create", new Object[] {
              aNoun, aNounPart
          });
          LOGGER.exiting(CLASSNAME, "create");
      }
  }
	  public void update(Object aNoun, Object aNounPart)
	    throws AbstractApplicationException
	  {
	    String METHODNAME = "update";
	    if (LoggingHelper.isEntryExitTraceEnabled(LOGGER)) {
	      LOGGER.entering(CLASSNAME, METHODNAME, new Object[] { 
	        aNoun, aNounPart });
	    }
	    super.update(aNoun, aNounPart);
	
	    OnlineStoreTypeImpl aNountype = (OnlineStoreTypeImpl)aNoun;
	      int storeentId = Integer.parseInt(aNountype.getOnlineStoreIdentifier().getUniqueID());
	      StoreentImpl storeentPhysicalDo = (StoreentImpl)findPhysicalEntity(aNoun, aNounPart);
	      Store storePhysicalDo = storeentPhysicalDo.getStoreForStoreent();
	    Map attributeMap = null;
	    if ((aNountype != null) && (aNountype.getUserData() != null) && (aNountype.getUserData().getUserDataField() != null)) {
	      attributeMap = aNountype.getUserData().getUserDataField();
	    }

	    if (attributeMap != null) {
	      System.out.println("FFFFFFFFFFFFFF checkbox update:: " + attributeMap.get("checkbox"));
	      //errormessage
	      System.out.println("FFFFFFFFFFFFFF processFlag processcounter:: " + attributeMap.get("processcounter"));
	      System.out.println("FFFFFFFFFFFFFF processFlag processFlag:: " + attributeMap.get("processFlag"));
	      System.out.println("FFFFFFFFFFFFFF processFlag processflag:: " + attributeMap.get("processflag"));
	      System.out.println("FFFFFFFFFFFFFF enablegodatafeed:: " + attributeMap.get("enablegodatafeed"));
	      System.out.println("FFFFFFFFFFFFFF attributeMap.get 1:: " + attributeMap.get("Keywords"));
	      System.out.println("FFFFFFFFFFFFFF attributeMap.get 2 " + attributeMap.get("Keywords.checkbox"));
	      
	      String catentryId = aNountype.getStoreType();

	      System.out.println("FFFFFFFFFFFFFF catentryId " + catentryId);
	      
	
	      String storeId = CatalogComponentHelper.getStoreId().toString();
	
	   

	      String enablegodatafeed = attributeMap.get("enablegodatafeed") == null ? "" : attributeMap.get("enablegodatafeed").toString();
	      String processflag=null;
	      if(enablegodatafeed.equals("Enable"))
	      processflag="active";
	      
	      java.util.Date date= new java.util.Date();
	      
	      Timestamp lastupdate=new Timestamp(date.getTime());
	 	  System.out.println("Time==="+lastupdate);
	 	 boolean isRecordExists=true;
         if (isRecordExists) {
	        updateRecords(processflag, storeId, lastupdate);
	        
	        TypedProperty req = new TypedProperty();
	        
			req.put(ECConstants.EC_SCHED_COMMAND, new String("DataFeedCmd"));
			req.put(ECConstants.EC_SCHED_START_TIME, lastupdate);
			req.put(ECConstants.EC_SCHED_NAME, "wcsadmin");
			req.put(ECConstants.EC_SCHED_HOST, "localhost");
			req.put(ECConstants.EC_STORE_ID, storeId);
			req.put(ECConstants.EC_SCHED_APPLICATION_TYPE, "default");
			//req.put(ECConstants.EC_SCHED_ATTEMPTS, limit);
			//req.put(ECConstants.EC_SCHED_DELAY, retryTime);

			req.put(ECConstants.EC_URL, "");
			
			CommandContext cmdContext = WebAdapterContextHelper.createCommandContext(ContextHelper.getGenericActivityToken());
			
			
			try {
				
				
			
				/*DataFeedCmd cmd1 = (DataFeedCmd)CommandFactory.createCommand("com.royalcyber.dataFeed.commands.DataFeedCmd", 0);
				
				cmd1.setAccCheck(false);
				//cmd.setStartTime(lastupdate);
				cmd1.setCommandContext(cmdContext);
				cmd1.setRequestProperties(req);
				cmd1.execute();*/	
				
				
			AddJobCmd cmd = (AddJobCmd)CommandFactory.createCommand("com.ibm.commerce.scheduler.commands.AddJobCmd", 0);
			
			cmd.setAccCheck(false);
			cmd.setStartTime(lastupdate);
			cmd.setCommandContext(cmdContext);
			cmd.setRequestProperties(req);
			cmd.execute();
			} catch (ECException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
	      }
	      else {
	       // insertRecords(enablegodatafeed, storeId, lastupdate);
	      }
	    }
	    if (LoggingHelper.isEntryExitTraceEnabled(LOGGER))
	      LOGGER.exiting(CLASSNAME, METHODNAME);
	  }

	  public void updateRecords(String processflag, String storeId, Timestamp lastupdate)
	  {
	    String records = getRecords(storeId, processflag);
	    String processflagFromDB="";
	    String storeIdFromDB="";
	    if(records!=null){
	    String[] arr = records.split(",");
	    processflagFromDB = arr[0];
	   // storeIdFromDB = arr[1];
	    }
	    
	    else{
	    	
	    	
	    	
	    }
	    
	    Date times=(Date)lastupdate;
	    String time=(String)times.toString();
	    System.out.println("Time21212==="+time);
	

	    if (processflagFromDB.equals("active") || processflagFromDB.equalsIgnoreCase("processing")) {
	    	
	        try {
	        	
	        String sqlUpdate = "UPDATE DB2ADMIN.xdatafeed SET msg='Web Feed is already active";
	    	  XSesssionBean serverJDBCHelperAccessBean = new XSesssionBean();
		      /*serverJDBCHelperAccessBean.myMethod();
		      executeUpdate("UPDATE DB2ADMIN.xdatafeed SET msg='Web Feed is already active'");
		      */
	        }catch (Exception e) {
			      e.printStackTrace();
			    }   
	    }
	

	
	    try {
	    	
	  if (processflagFromDB.equals("")) {	
	      /*ServerJDBCHelperAccessBean serverJDBCHelperAccessBean = new ServerJDBCHelperAccessBean();
	      String query="insert into DB2ADMIN.xdatafeed (processflag,lastupdated,storeent_id)values('"+processflag+"','"+time+"',"+storeId+")";
	      System.out.println("Insert Query..."+query);
	      serverJDBCHelperAccessBean.executeUpdate(query);*/
	      
	     
	  } 
	    }
	    catch (Exception e) {
	      e.printStackTrace();
	    }
	    
	    try {
	    	
	  	  if (processflagFromDB.equalsIgnoreCase("complete") || processflagFromDB.equalsIgnoreCase("null")) {	
	  		 /*ServerJDBCHelperAccessBean serverJDBCHelperAccessBean = new ServerJDBCHelperAccessBean();
		      serverJDBCHelperAccessBean.executeUpdate("UPDATE DB2ADMIN.xdatafeed SET processflag='"+processflag+"',lastupdated='"+time+"',storeent_id="+storeId);
	  		 */
	  	      
	  	     
	  	  } 
	  	    }
	  	    catch (Exception e) {
	  	      e.printStackTrace();
	  	    }
	    
	  }
	  
	  

	  public String getRecords(String storeId, String processflag) {
	    Vector listRecords = null;
	    String sql = "select processflag from db2admin.xdatafeed"; 
	    System.out.println(sql); 

	    System.out.println("select sql from getRecords method : " + sql);
	    String processflag1 = "";
	    String storeId1 = "";
	  

	   /* ServerJDBCHelperAccessBean sjdbc2 = null;*/
	    try {
	      /*sjdbc2 = new ServerJDBCHelperAccessBean();
	      listRecords = sjdbc2.executeQuery(sql);*/
	    }
	    catch (Exception e) {
	      e.printStackTrace();
	    }
	    try {
	      if ((listRecords != null) && (listRecords.size() > 0))
	        for (Enumeration enumeration = listRecords.elements(); enumeration.hasMoreElements(); ) {
	          Vector record = (Vector)enumeration.nextElement();
	          processflag1 = String.valueOf(record.elementAt(0));
	      
	        }
	    }
	    catch (Exception exp)
	    {
	      exp.printStackTrace();
	    }
	    if (!"".equalsIgnoreCase(processflag1) && (listRecords.size() > 0)) {
	      return processflag1;// + "," + storeId1;
	    }

	    return null;
	  }


}// end of class
