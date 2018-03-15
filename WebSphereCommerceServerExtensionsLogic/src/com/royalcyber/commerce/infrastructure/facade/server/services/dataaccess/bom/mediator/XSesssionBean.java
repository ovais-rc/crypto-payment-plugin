package com.royalcyber.commerce.infrastructure.facade.server.services.dataaccess.bom.mediator;

import java.rmi.RemoteException;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.ejb.EJBException;
import javax.ejb.SessionBean;
import javax.ejb.SessionContext;

public class XSesssionBean extends
com.ibm.commerce.base.helpers.BaseJDBCHelper 
   implements SessionBean 
{

   public Object myMethod()
        throws javax.naming.NamingException, SQLException
   {

       ///////////////////////////////////////////////// 
      //  -- your logic, such as initialization --    // 
      ///////////////////////////////////////////////// 

         try {
             // get a connection from the WebSphere Commerce data source
             makeConnection();
             PreparedStatement stmt = getPreparedStatement(
                "your sql string");
            
						//////////////////////////////////////////////////////////// 
             // -- your logic such as set parameter into the prepared  //
             // statement --    																	  // 
             /////////////////////////////////////////////////////////// 
             ResultSet rs = executeQuery(stmt, false);

					  while(rs.next()) {

             ///////////////////////////////////////////////// 
             // -- your logic to process the result set -- //
            //////////////////////////////////////////////// 

						}
          } 
          finally {
             // return the connection to the WebSphere Commerce

            closeConnection(); 
          }
		return mySessionCtx;

        /////////////////////////////////////////////////////
       // -- your logic to return the result ---           //
       //////////////////////////////////////////////////////

   }

@Override
public void ejbActivate() throws EJBException, RemoteException {
	// TODO Auto-generated method stub
	
}

@Override
public void ejbPassivate() throws EJBException, RemoteException {
	// TODO Auto-generated method stub
	
}

@Override
public void ejbRemove() throws EJBException, RemoteException {
	// TODO Auto-generated method stub
	
}

@Override
public void setSessionContext(SessionContext arg0) throws EJBException, RemoteException {
	// TODO Auto-generated method stub
	
}

}