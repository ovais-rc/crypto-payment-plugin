package com.royalcyber.datafeedutility;

import java.io.FileReader;
import java.io.IOException;
import java.util.Properties;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * @author Balkrishna
 * 
 *         Property reader class. Provides method to load and read property
 *         values from datafeed.properties file.
 */
public class DataFeedProperty {
	private static final String CLASSNAME = DataFeedProperty.class.getName();
	private static final Logger LOGGER = Logger.getLogger(CLASSNAME); 
	private static final String DATAFEED_PROPERTIES = "C:\\WCDE_V9/workspace/WebSphereCommerceServerExtensionsLogic/src/datafeed.properties";
	private static Properties prop = null;
	
	/**
	 * Load properties from datafeed.properties file
	 */
	public static void loadProperties() {
		String loadProperties = "loadProperties";
		LOGGER.entering(CLASSNAME, loadProperties);
		prop = new Properties();
		try {
			// load a properties file
			FileReader fr = new FileReader(DATAFEED_PROPERTIES);
			prop.load(fr);
		} catch (IOException e) {
			LOGGER.log(
					Level.SEVERE,
					"IOException occurred during feed creation"
							+ e.getMessage());

		} catch (Exception e) {
			LOGGER.log(Level.SEVERE, "Exception occurred during feed creation"
					+ e.getMessage());

		}
		LOGGER.exiting(CLASSNAME, loadProperties);
	}

	/**
	 * Read String value from property key
	 * 
	 * @param key
	 * @return String value
	 */
	public static String getValue(final String key) {
		if (prop == null || prop.equals("")) {
			loadProperties();
		}
		return prop.getProperty(key);
	}

	/**
	 * Read integer value from property key
	 * 
	 * @param key
	 * @return integer value
	 */
	public static int getIntValue(final String key) {
		if (prop == null) {
			loadProperties();
		}

		return Integer.parseInt(prop.getProperty(key));
	}
}

