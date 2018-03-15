/**
 * 
 */
package com.royalcyber.dataFeed.commands;

import java.rmi.RemoteException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Logger;

import javax.ejb.CreateException;
import javax.ejb.FinderException;
import javax.naming.NamingException;

import com.ibm.commerce.command.ControllerCommandImpl;
import com.ibm.commerce.exception.ECException;
import com.ibm.commerce.exception.ECSystemException;
import com.royalcyber.dataFeed.commands.DataFeedDBHelper;
import com.royalcyber.datafeedutility.DataFeedCreator;
import com.royalcyber.datafeedutility.DataFeedException;
import com.royalcyber.datafeedutility.DataFeedTransporter;


/**
 * @author Administrator
 * 
 */
public class DataFeedCmdImpl extends ControllerCommandImpl implements
		DataFeedCmd {
	
	private final static Logger LOGGER = Logger.getLogger(DataFeedCmd.class
			.getName());
	boolean res= false;
	DataFeedDBHelper dbhelper = null;    
	/**
	 * This constructor calls the superclass constructor.
	 */
	public DataFeedCmdImpl() {
		super();
	}

	@Override
	public void performExecute() throws ECException {
		// TODO Auto-generated method stub
		super.performExecute();
		try {
			checkDataFeedSchedular();
		} catch (NamingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (DataFeedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (RemoteException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (CreateException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (FinderException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	public void checkDataFeedSchedular() throws NamingException, SQLException, DataFeedException, ECSystemException, RemoteException, CreateException, FinderException{
		   dbhelper = new DataFeedDBHelper();
		   
		   if(dbhelper.getDataFeedProcessStatus()){
			   Integer storeId = null;
			    storeId = commandContext.getStoreId();
			     Integer langId = commandContext.getLanguageId(); 
		   
		  System.out.println("checkFlag");
		//if(dbhelper.getDataFeedProcessStatus()){
			List<Map <String, String>> mpData = new ArrayList<Map<String, String>>();
			mpData = dbhelper.createCatalogDataMap(storeId,langId);
			
		 
			System.out.println("mpData : "+mpData);
			DataFeedCreator dataFeedCreator = new DataFeedCreator();
			dataFeedCreator.createCSVDataFeed(mpData);
			DataFeedDBHelper dbHelper = new DataFeedDBHelper();
		    if(dbHelper.getFeedFtpStatus()){
			DataFeedTransporter dataFeedTransporter = new DataFeedTransporter();
		   
			dataFeedTransporter.sendDataFeed();
		    }
			dbhelper.updateDataFeedLog();
			//dbhelper.updateDataFeedStatus();
			dbhelper.updateFiledsRecords();
			System.out.println("updateDataFeedStatus");
		   }else{System.out.println("No DataFeed Update found");}
			
		//}
		//return res;
	}
	

}
