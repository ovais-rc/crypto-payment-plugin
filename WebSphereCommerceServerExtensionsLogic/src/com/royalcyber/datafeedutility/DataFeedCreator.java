package com.royalcyber.datafeedutility;


import static com.royalcyber.datafeedutility.DataFeedConstants.COMMA_SEPARATOR;
import static com.royalcyber.datafeedutility.DataFeedConstants.DATAFEED_CSV_FIELDS;
import static com.royalcyber.datafeedutility.DataFeedConstants.DATAFEED_FILELOCATION;
import static com.royalcyber.datafeedutility.DataFeedConstants.LINE_SEPARATOR;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.logging.Level;
import java.util.logging.Logger;

import com.royalcyber.dataFeed.commands.DataFeedDBHelper;

/**
 * @author Balkrishna
 * 
 *         This class will take care of Data Feed CSV creation. This calss's
 *         instance must be created in WCS or Hybris for invoking feed creation
 */
public class DataFeedCreator {

	private static final String CLASSNAME = DataFeedCreator.class.getName();
	private static final Logger LOGGER = Logger.getLogger(CLASSNAME);

	/**
	 * 
	 * This Method accepts catalog data in a List of Map format and creates CSV
	 * file in configured location
	 * 
	 * @param catalogData
	 * @throws DataFeedException
	 */
	public void createCSVDataFeed(List<Map<String, String>> catalogData)
			throws DataFeedException {
		DataFeedDBHelper dbHelper = new DataFeedDBHelper();
		String createCSVDataFeed = "createCSVDataFeed";
		LOGGER.entering(CLASSNAME, createCSVDataFeed);
		try {
			FileWriter writer = new FileWriter(
					DataFeedProperty.getValue(DATAFEED_FILELOCATION));

			StringBuffer stringBuffer = new StringBuffer();

			//String csvFields = DataFeedProperty.getValue(DATAFEED_CSV_FIELDS);
			String[] fields = dbHelper.getDataFeedFields();
			//String[] fields = csvFields.split(",");

			for (String field : fields) {
				System.out.println("++"+field);
				stringBuffer.append(field);
				stringBuffer.append(COMMA_SEPARATOR);
			}
			stringBuffer.deleteCharAt(stringBuffer.length() - 1);
			for (Map<String, String> datamap : catalogData) {
				stringBuffer.append((System.getProperty(LINE_SEPARATOR)));

				for (String field : fields) {
					stringBuffer.append(CSVHelper.validateMandatory(field,
							datamap.get(field)));
					stringBuffer.append(COMMA_SEPARATOR);
				}
				stringBuffer.deleteCharAt(stringBuffer.length() - 1);
			}

			writer.append(stringBuffer.toString());
			writer.flush();
			writer.close();
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

		LOGGER.exiting(CLASSNAME, createCSVDataFeed);
	}

}

