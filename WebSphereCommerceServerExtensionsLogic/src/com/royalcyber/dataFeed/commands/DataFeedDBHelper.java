/**
 * 
 */
package com.royalcyber.dataFeed.commands;

import java.rmi.RemoteException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.ejb.CreateException;
import javax.ejb.EJBException;
import javax.ejb.FinderException;
import javax.ejb.SessionBean;
import javax.ejb.SessionContext;
import javax.naming.NamingException;

import java.sql.ResultSet;

import com.ibm.commerce.base.helpers.BaseJDBCHelper;
import com.ibm.commerce.catalog.objects.CatalogGroupCatalogEntryRelationAccessBean;
import com.ibm.commerce.common.objects.StoreAccessBean;
import com.ibm.commerce.datatype.TypedProperty;
import com.ibm.commerce.foundation.common.exception.AbstractApplicationException;
import com.ibm.commerce.seo.registry.SEOConfigurationRegistry;
import com.ibm.commerce.seo.url.helpers.SEOURLMapper;
import com.royalcyber.datafeedutility.DataFeedProperty;


import static com.royalcyber.datafeedutility.DataFeedConstants.DATAFEED_STORE_URL;
import static com.royalcyber.datafeedutility.DataFeedConstants.DATAFEED_STORE_Brand;
import static com.royalcyber.datafeedutility.DataFeedConstants.DATAFEED_STORE_Manufacturer;
import static com.royalcyber.datafeedutility.DataFeedConstants.DATAFEED_STORE_ImageUrl;

/**
 * @author Administrator
 *
 */
public class DataFeedDBHelper extends BaseJDBCHelper implements SessionBean {

	  private Connection conn = null;
	  private PreparedStatement sqlStmt = null;
	
	/* (non-Javadoc)
	 * @see com.ibm.commerce.base.helpers.BaseJDBCHelper#getSessionContext()
	 */
	public SessionContext getSessionContext() {
		// TODO Auto-generated method stub
		return null;
	}

	/* (non-Javadoc)
	 * @see javax.ejb.SessionBean#ejbActivate()
	 */
	@Override
	public void ejbActivate() throws EJBException, RemoteException {
		// TODO Auto-generated method stub

	}

	/* (non-Javadoc)
	 * @see javax.ejb.SessionBean#ejbPassivate()
	 */
	@Override
	public void ejbPassivate() throws EJBException, RemoteException {
		// TODO Auto-generated method stub

	}

	/* (non-Javadoc)
	 * @see javax.ejb.SessionBean#ejbRemove()
	 */
	@Override
	public void ejbRemove() throws EJBException, RemoteException {
		// TODO Auto-generated method stub

	}

	/* (non-Javadoc)
	 * @see javax.ejb.SessionBean#setSessionContext(javax.ejb.SessionContext)
	 */
	@Override
	public void setSessionContext(SessionContext arg0) throws EJBException,
			RemoteException {
		// TODO Auto-generated method stub

	}
	
	 public boolean getDataFeedProcessStatus() throws javax.naming.NamingException, SQLException {
		 boolean ret = false;
		 String flagStatus="";
	  try {
	   // Get a connection from the WebSphere Commerce data source
	   makeConnection();
	  
	   PreparedStatement psSql = getPreparedStatement("select processflag from XDATAFEED");
	 
	   ResultSet rsData = executeQuery(psSql, false);
	   
	   if(rsData.next()){
		 flagStatus = rsData.getString("processflag");
		 if(flagStatus.equals("active"))
			 ret = true;
	   		}
	 } finally {
		   // Return the connection to the WebSphere Commerce data source
		   closeConnection();
		  }
	  return ret;
	 }
	 
	 public void updateDataFeedLog( )
	   throws javax.naming.NamingException, SQLException {
	
	  try {
	   // Get a connection from the WebSphere Commerce data source
	   makeConnection();
	   
	   PreparedStatement psSql1 = getPreparedStatement("select * from XDATAFEEDLOG");
		 
	   ResultSet rsData = executeQuery(psSql1, false);
	  // System.out.println(rsData.first());
//	   int rData=0;
	   if(rsData.next()){
	    
		   
		   	PreparedStatement psSql = getPreparedStatement("insert into XDATAFEEDLOG (PROCESSCOUNTER, STATUS, ERRORMSG, LASTUPDATED, OPTCOUNTER) values ((select max(PROCESSCOUNTER)+1 from XDATAFEEDLOG), 'Sucessfull', 'DataFeed is updated', CURRENT timestamp, 0)");
			executeUpdate(psSql, false);
			
	   } else {
		
		PreparedStatement psSql = getPreparedStatement("insert into XDATAFEEDLOG (PROCESSCOUNTER, STATUS, ERRORMSG, LASTUPDATED, OPTCOUNTER) values (1, 'Sucessfull', 'DataFeed is updated', CURRENT timestamp, 0)");
		   executeUpdate(psSql, false);
	}
	 
	  } finally {
		   // Return the connection to the WebSphere Commerce data source
		   closeConnection();
		  }
		  //return ret;
		 }
	 
	 public void updateDataFeedStatus( )
	   throws javax.naming.NamingException, SQLException {
	
	  try {
	   // Get a connection from the WebSphere Commerce data source
	   makeConnection();
	  PreparedStatement psSql = getPreparedStatement("UPDATE xdatafeed SET processflag='complete', LASTPROCESSCOUNTER=(select max(PROCESSCOUNTER) from XDATAFEEDLOG)");
	 
	  executeUpdate(psSql, false);
	  
	 
	  } finally {
		   // Return the connection to the WebSphere Commerce data source
		   closeConnection();
		  }
		  //return ret;
		 }
	 
	 public  String[] getDataFeedFields() throws javax.naming.NamingException, SQLException {
		 String dataFields="";
		  try {
		   // Get a connection from the WebSphere Commerce data source
				 
		   makeConnection();
		   PreparedStatement psSql = getPreparedStatement("select a.name from emspot as a inner join DMEMSPOTDEF as b on (a.emspot_id = b.emspot_id) where a.description in ('DataFeedEnabled','DataFeedEnabledM') and b.content='true' ORDER BY case a.name when 'Brand' then 0 when 'Description' then 1 when 'Image URL' then 3 when 'Keywords' then 4 when 'Manufacturer' then 5 when 'Manufacturer Part Number' then 6 when 'Merchant Category' then 7 when 'Name' then 8 when 'Price' then 9 when 'Shipping Price' then 10 when 'Unique ID' then 11 when 'URL' then 12 when 'Availability' then 13 end");
		  
		   ResultSet rsData = executeQuery(psSql, false);
		
		   while (rsData.next()) {
			   int i=0;
			  rsData.getString("name");
			  dataFields+=rsData.getString("name")+",";
		      i++;
		   }
		  } finally {
		   // Return the connection to the WebSphere Commerce data source
		   closeConnection();
		  }
		  String ftpVal ="FTP Location";
		  boolean checkFtpTransfer = false;
		  if (dataFields.contains(ftpVal)){
			  checkFtpTransfer =true;
		  }
		  
		  
		  System.out.print("waqas \n"+dataFields);
		  return dataFields.split(",");
		 }
	 
	 
	 
	 
	 public  boolean getFeedFtpStatus() throws javax.naming.NamingException, SQLException {
		 String dataFields="";
		  try {
		   // Get a connection from the WebSphere Commerce data source
				 
		   makeConnection();
		   PreparedStatement psSql = getPreparedStatement("select a.name from emspot as a inner join DMEMSPOTDEF as b on (a.emspot_id = b.emspot_id) where a.description in ('DataFeedEnabled','DataFeedEnabledM') and b.content='true' ORDER BY case a.name when 'Brand' then 0 when 'Description' then 1 when 'Image URL' then 3 when 'Keywords' then 4 when 'Manufacturer' then 5 when 'Manufacturer Part Number' then 6 when 'Merchant Category' then 7 when 'Name' then 8 when 'Price' then 9 when 'Shipping Price' then 10 when 'Unique ID' then 11 when 'URL' then 12 when 'Availability' then 13 end");
		  
		   ResultSet rsData = executeQuery(psSql, false);
		
		   while (rsData.next()) {
			   int i=0;
			  rsData.getString("name");
			  dataFields+=rsData.getString("name")+",";
		      i++;
		   }
		  } finally {
		   // Return the connection to the WebSphere Commerce data source
		   closeConnection();
		  }
		  String ftpVal ="FTP Location";
		  boolean checkFtpTransfer = false;
		  if (dataFields.contains(ftpVal)){
			  checkFtpTransfer =true;
		  }
		  
		  return checkFtpTransfer;
		 }
	 
	 
	 
	 
	 
	 
	 
	 
	 
	 //Updating temp records to false
	 public void updateFiledsRecords() throws SQLException, NamingException{
		 try {
			   // Get a connection from the WebSphere Commerce data source
					 
			   makeConnection();
			   PreparedStatement psSql = getPreparedStatement("update DMEMSPOTDEF set content='false' where emspot_id in (select emspot_id from emspot where description = 'DataFeedEnabled') and content='true'");
			  
			   executeUpdate(psSql, false);
			
			  
			  } finally {
			   // Return the connection to the WebSphere Commerce data source
			   closeConnection();
			  }
			
	 }
	 
	 

	
	 public List<Map<String, String>> createCatalogDataMap(Integer storeId,Integer langId) throws javax.naming.NamingException, SQLException, RemoteException, CreateException, FinderException {
		 List<Map<String, String>> mpCatalogData =  new ArrayList<Map<String, String>>();
		  try {
		   // Get a connection from the WebSphere Commerce data source
			  
			  StoreAccessBean storeAccessBean = new StoreAccessBean();
			  storeAccessBean.setInitKey_storeEntityId(storeId.toString());
			  //storeAccessBean.refreshCopyHelper();
			 // String ctId = storeAccessBean.getMasterCatalog().getCatalogReferenceNumber();
			  
			  String seoUrl="";
			  String Brand = DataFeedProperty.getValue(DATAFEED_STORE_Brand);
			  String patternName = "CanonicalItemURL";
			     TypedProperty properties = new TypedProperty();
			     properties.put("storeId", 10501);
			     properties.put("catalogId", 10001);
			     properties.put("langId", -1);
			     
			    
			    

			     SEOURLMapper mapperInstance = SEOConfigurationRegistry.singleton().getMapperInstance();
			     try {
			     seoUrl = mapperInstance.constructDynamicURLByPatternName(patternName, properties, null);
			    System.out.println("########seoUrl#########"+seoUrl);
			   } catch (AbstractApplicationException e) {
			    // TODO Auto-generated catch block
			    e.printStackTrace();
			   }
			  
			  makeConnection();
			  
		   PreparedStatement psSql = getPreparedStatement("select a.CATENTRY_ID, a.partnumber, b.name, b.shortdescription, b.thumbnail, b.keyword, b.fullimage, c.LISTPRICE from catentry as a INNER JOIN catentdesc as b on (a.CATENTRY_ID =b.CATENTRY_ID) inner join LISTPRICE as c on (a.CATENTRY_ID = c.CATENTRY_ID)  where  b.language_id=-1");
		   String url = DataFeedProperty.getValue(DATAFEED_STORE_URL)+seoUrl+"&productId=";
		   System.out.println("url="+url);
		   ResultSet rsData = executeQuery(psSql, false);
		   int i=0;
		   while (rsData.next()) {
			   Map<String, String> mpCMap = new HashMap<String, String>();
			   System.out.println("as"+rsData.getString("CATENTRY_ID").trim());
			   String categoryId="";
			   Object parentCategoriesEnu = new CatalogGroupCatalogEntryRelationAccessBean().findByCatalogEntryId(new Long(rsData.getString("CATENTRY_ID")));
			    // findByCatalogEntryId(new Long(10023));

			      if (parentCategoriesEnu != null) {
			      while(((Enumeration) parentCategoriesEnu).hasMoreElements()){
			      CatalogGroupCatalogEntryRelationAccessBean cgceRelationAB = (CatalogGroupCatalogEntryRelationAccessBean)((Enumeration) parentCategoriesEnu).nextElement();
			       categoryId = cgceRelationAB.getCatalogGroupId();
			      System.out.println("CATEGORY ID "+categoryId);
			      }
			      }
			      
			      PreparedStatement psSqlcat = getPreparedStatement("select b.NAME from catgroup as a inner join CATGRPDESC as b on (a.CATGROUP_ID = b.CATGROUP_ID) where a.CATGROUP_ID = "+categoryId+" and b.LANGUAGE_ID = -1");
				   
				  
				   ResultSet rsDataCat = executeQuery(psSqlcat, false);
				   
				   if(rsDataCat.next())
				   mpCMap.put("Merchant Category", ((rsDataCat.getString("NAME")).trim()).toLowerCase());
			      
				   psSqlcat.close();
			  
				   
			   /*mpCMap.put("Brand", DataFeedProperty.getValue(DATAFEED_STORE_Brand));*/
			   mpCMap.put("Description", ((rsData.getString("shortdescription")).trim()).toLowerCase());
			  /* mpCMap.put("Image URL", (DataFeedProperty.getValue(DATAFEED_STORE_ImageUrl)+(rsData.getString("thumbnail")).trim()));*/
			   mpCMap.put("Keywords", (rsData.getString("Keyword") != null ? rsData.getString("Keyword") : ""));
			   mpCMap.put("Manufacturer", DataFeedProperty.getValue(DATAFEED_STORE_Manufacturer));
			   mpCMap.put("Manufacturer Part Number", (rsData.getString("partnumber")).trim());
			   mpCMap.put("Name", ((rsData.getString("name")).trim()).toLowerCase());
			  /* mpCMap.put("Price", ((rsData.getString("LISTPRICE")).trim()).toLowerCase());*/
			  /* mpCMap.put("Shipping Price",((rsData.getString("LISTPRICE")).trim()).toLowerCase());*/
			   mpCMap.put("Unique ID", (rsData.getString("CATENTRY_ID").trim()));
			   /*mpCMap.put("URL",(url+rsData.getString("CATENTRY_ID").trim()));
			   mpCMap.put("Quantity", (rsData.getString("QTYRECEIVED").trim()));	
			   mpCMap.put("Availability", (rsData.getString("Availability").trim()));*/
			   
			   
			   mpCatalogData.add(mpCMap);
			   
			   

			   
			   
		       //i++;		   
		       }
		  } finally {
		   // Return the connection to the WebSphere Commerce data source
		   closeConnection();
		  }
		  return mpCatalogData;
		 }
	 

}
