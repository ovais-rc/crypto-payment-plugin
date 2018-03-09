package sample.extensions;

/*
 *-------------------------------------------------------------------
 * Licensed Materials - Property of IBM
 *
 * WebSphere Commerce
 *
 * (c) Copyright International Business Machines Corporation.
 *     2007
 *     All rights reserved.
 *
 * US Government Users Restricted Rights - Use, duplication or
 * disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 *-------------------------------------------------------------------
 */

/**
 * Home interface for Enterprise Bean: ExtensionJDBCHelper
 */
public interface ExtensionJDBCHelperHome extends javax.ejb.EJBHome {
	/**
	 * Creates a default instance of Session Bean: ExtensionJDBCHelper
	 * @return an instance of the session bean
	 * @throws javax.ejb.CreateException
	 * @throws java.rmi.RemoteException
	 */
	public sample.extensions.ExtensionJDBCHelper create()
		throws javax.ejb.CreateException, java.rmi.RemoteException;
}
