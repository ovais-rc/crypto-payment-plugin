package com.royalcyber.datafeedutility;


import static com.royalcyber.datafeedutility.DataFeedConstants.DATAFEED_TRANSPORT_TYPE;
import static com.royalcyber.datafeedutility.DataFeedConstants.FTP;

import java.util.logging.Logger;

/**
 * @author Balkrishna
 * 
 *         This class handles transportation of data feed file according
 *         configuration
 * 
 */
public class DataFeedTransporter {
	private static final String CLASSNAME = DataFeedTransporter.class.getName();
	private static final Logger LOGGER = Logger.getLogger(CLASSNAME);

	/**
	 * Method sends data feed over FTP or HTTP location
	 * 
	 * @return flag for Success/Failure transportation
	 * @throws DataFeedException
	 */
	public boolean sendDataFeed() throws DataFeedException {
		String sendDataFeed = "sendDataFeed";
		LOGGER.entering(CLASSNAME, sendDataFeed);

		if (FTP.equals(DataFeedProperty.getValue(DATAFEED_TRANSPORT_TYPE))) {
		//if (FTP.equals(DataFeedConstants.DATAFEED_TRANSPORT_TYPE)) {
			FTPTransporter ftpTransporter = new FTPTransporter();
			LOGGER.exiting(CLASSNAME, sendDataFeed);
			return ftpTransporter.transportFTP();
		} else {
			HTTPTransporter httpTransporter = new HTTPTransporter();
			LOGGER.exiting(CLASSNAME, sendDataFeed);
			return httpTransporter.transportHTTP();
		}

	}
}
