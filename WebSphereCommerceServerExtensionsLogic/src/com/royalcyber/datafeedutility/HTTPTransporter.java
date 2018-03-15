package com.royalcyber.datafeedutility;


import static com.royalcyber.datafeedutility.DataFeedConstants.DATAFEED_FILELOCATION;
import static com.royalcyber.datafeedutility.DataFeedConstants.DATAFEED_HTTP_FILELOCATION;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.nio.channels.FileChannel;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * @author Balkrishna
 * 
 *         FTP Transporter for data feed
 * 
 */
public class HTTPTransporter {
	private static final String CLASSNAME = HTTPTransporter.class.getName();
	private static final Logger LOGGER = Logger.getLogger(CLASSNAME);

	/**
	 * Method for data feed transport over to HTTP location
	 * 
	 * @return Method for data feed transport over HTTP
	 * @throws DataFeedException
	 */
	public boolean transportHTTP() throws DataFeedException {

		String transportHTTP = "transportHTTP";
		LOGGER.entering(CLASSNAME, transportHTTP);
		String dataFeedFile = DataFeedProperty.getValue(DATAFEED_FILELOCATION);
		String httpDataFeedFile = DataFeedProperty
				.getValue(DATAFEED_HTTP_FILELOCATION);

		FileChannel inputChannel = null;

		FileChannel outputChannel = null;

		try {

			inputChannel = new FileInputStream(dataFeedFile).getChannel();
			outputChannel = new FileOutputStream(httpDataFeedFile).getChannel();

			outputChannel.transferFrom(inputChannel, 0, inputChannel.size());
			LOGGER.exiting(CLASSNAME, transportHTTP);
			return true;
		} catch (FileNotFoundException e) {
			LOGGER.log(
					Level.SEVERE,
					"FileNotFoundException occurred during feed creation"
							+ e.getMessage());
			throw new DataFeedException(
					"FileNotFoundException occurred during feed creation"
							+ e.getMessage());
		} catch (IOException e) {
			LOGGER.log(
					Level.SEVERE,
					"IOException occurred during feed creation"
							+ e.getMessage());
			throw new DataFeedException(
					"IOException occurred during feed creation"
							+ e.getMessage());
		} finally {

			try {

				if (inputChannel != null)
					inputChannel.close();
				if (outputChannel != null)
					outputChannel.close();

			} catch (IOException e) {

				LOGGER.log(
						Level.SEVERE,
						"IOException occurred during feed creation"
								+ e.getMessage());
				throw new DataFeedException(
						"IOException occurred during feed creation"
								+ e.getMessage());

			}

		}

	}
}
