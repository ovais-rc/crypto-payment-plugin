package com.royalcyber.datafeedutility;


import static com.royalcyber.datafeedutility.DataFeedConstants.DATAFEED_FILELOCATION;
import static com.royalcyber.datafeedutility.DataFeedConstants.DATAFEED_FTP_LOCATION;
import static com.royalcyber.datafeedutility.DataFeedConstants.DATAFEED_FTP_PASSWORD;
import static com.royalcyber.datafeedutility.DataFeedConstants.DATAFEED_FTP_PORT;
import static com.royalcyber.datafeedutility.DataFeedConstants.DATAFEED_FTP_USERNAME;
import static com.royalcyber.datafeedutility.DataFeedConstants.DATAFEED_OUT_FILENAME;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.net.SocketException;
import java.util.logging.Level;
import java.util.logging.Logger;

import org.apache.commons.net.ftp.FTP;
import org.apache.commons.net.ftp.FTPClient;

/**
 * @author Balkrishna
 * 
 *         FTP Transporter for data feed
 */
public class FTPTransporter {
	private static final String CLASSNAME = FTPTransporter.class.getName();
	private static final Logger LOGGER = Logger.getLogger(CLASSNAME);

	/**
	 * Method for data feed transport over FTP
	 * 
	 * @return flag for Success/Failure transportation
	 * @throws DataFeedException
	 */
	public boolean transportFTP() throws DataFeedException {
		String transportFTP = "transportFTP";
		LOGGER.entering(CLASSNAME, transportFTP);
		FTPClient ftpClient = new FTPClient();
		String dataFeedFile = DataFeedProperty.getValue(DATAFEED_FILELOCATION);
		String ftpServer = DataFeedProperty.getValue(DATAFEED_FTP_LOCATION);
		int ftpPort = DataFeedProperty.getIntValue(DATAFEED_FTP_PORT);
		String ftpUser = DataFeedProperty.getValue(DATAFEED_FTP_USERNAME);
		String ftpPwd = DataFeedProperty.getValue(DATAFEED_FTP_PASSWORD);

		try {
			ftpClient.connect(ftpServer, ftpPort);
			ftpClient.login(ftpUser, ftpPwd);
			ftpClient.enterLocalPassiveMode();

			ftpClient.setFileType(FTP.BINARY_FILE_TYPE);

			File firstLocalFile = new File(dataFeedFile);

			String firstRemoteFile = DataFeedProperty
					.getValue(DATAFEED_OUT_FILENAME);
			InputStream inputStream = new FileInputStream(firstLocalFile);

			boolean done = ftpClient.storeFile(firstRemoteFile, inputStream);
			inputStream.close();
			if (done) {
				LOGGER.info("FTP successful");
				LOGGER.exiting(CLASSNAME, transportFTP);
				return true;
			} else {
				LOGGER.log(Level.SEVERE, "FTP unsuccessful");
				LOGGER.exiting(CLASSNAME, transportFTP);
				return false;
			}

		} catch (SocketException e) {
			LOGGER.log(
					Level.SEVERE,
					"SocketException occurred during feed creation"
							+ e.getMessage());
			throw new DataFeedException(
					"SocketException occurred during feed creation"
							+ e.getMessage());

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
		} catch (Exception e) {
			LOGGER.log(Level.SEVERE, "Exception occurred during feed creation"
					+ e.getMessage());
			throw new DataFeedException(
					"Exception occurred during feed creation" + e.getMessage());
		}

	}
}

