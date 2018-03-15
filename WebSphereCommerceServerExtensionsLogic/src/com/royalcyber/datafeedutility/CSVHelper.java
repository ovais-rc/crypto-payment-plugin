package com.royalcyber.datafeedutility;

import static com.royalcyber.datafeedutility.DataFeedConstants.COMMA_SEPARATOR;
import static com.royalcyber.datafeedutility.DataFeedConstants.DATAFEED_CSV_IGNORE_DESCRIPTION_ERROR;
import static com.royalcyber.datafeedutility.DataFeedConstants.DATAFEED_CSV_IGNORE_KEYWORDS_ERROR;
import static com.royalcyber.datafeedutility.DataFeedConstants.DATAFEED_CSV_IGNORE_NAME_ERROR;
import static com.royalcyber.datafeedutility.DataFeedConstants.DATAFEED_CSV_IGNORE_PRICE_ERROR;
import static com.royalcyber.datafeedutility.DataFeedConstants.DATAFEED_CSV_MANDATORY;
import static com.royalcyber.datafeedutility.DataFeedConstants.DESCRIPTION;
import static com.royalcyber.datafeedutility.DataFeedConstants.DOUBLE_QUOTE;
import static com.royalcyber.datafeedutility.DataFeedConstants.EMPTY_VALUE;
import static com.royalcyber.datafeedutility.DataFeedConstants.KEYWORDS;
import static com.royalcyber.datafeedutility.DataFeedConstants.NAME;

import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * @author Balkrishna
 * 
 *         This class provides validation and CSV helper methods.
 * 
 */
public class CSVHelper {

	private static String MANDATORY_ELEMENTS = DataFeedConstants.DATAFEED_CSV_MANDATORY;
	private static String NAME_ERROR = DataFeedConstants.DATAFEED_CSV_IGNORE_NAME_ERROR;
	private static String DESC_ERROR =DataFeedConstants.DATAFEED_CSV_IGNORE_DESCRIPTION_ERROR;
	private static String PRICE_ERROR = DataFeedConstants.DATAFEED_CSV_IGNORE_PRICE_ERROR;
	private static String KEYWORDS_ERROR = DataFeedConstants.DATAFEED_CSV_IGNORE_KEYWORDS_ERROR;
	private static final String CLASSNAME = CSVHelper.class.getName();
	private static final Logger LOGGER = Logger.getLogger(CLASSNAME);

	/**
	 * Method to validate CSV fields. Throws exception for validation errors
	 * 
	 * @param key
	 * @param value
	 * @return formatted value
	 * @throws DataFeedException
	 */
	public static String validateMandatory(final String key, String value)
			throws DataFeedException {
		String validateMandatory = "validateMandatory";

		LOGGER.entering(CLASSNAME, validateMandatory);
		if (value == null || value.trim().isEmpty()) {
			if (MANDATORY_ELEMENTS.contains(key)) {
				LOGGER.log(Level.SEVERE, "Missing Mandatory Element " + key
						+ " for Data Feed CSV");
				throw new DataFeedException("Missing Mandatory Element " + key
						+ " for Data Feed CSV");
			} else {
				return EMPTY_VALUE;
			}
		} else if (NAME.equals(key)) {
			if (value.length() > 70) {
				if ("true".equals(NAME_ERROR)) {
					value = value.substring(0, 69);
				} else {
					LOGGER.log(Level.SEVERE,
							"Product Name Exceeds expected length of 70 Characters");
					throw new DataFeedException(
							"Product Name Exceeds expected length of 70 Characters");
				}
			}

			value = DOUBLE_QUOTE + value + DOUBLE_QUOTE;

		} else if (DESCRIPTION.equals(key)) {
			if (value.length() > 750) {
				if ("true".equals(DESC_ERROR)) {
					value = value.substring(0, 749);
				} else {
					LOGGER.log(Level.SEVERE,
							"Product Description Exceeds expected length of 750 Characters");
					throw new DataFeedException(
							"Product Description Exceeds expected length of 750 Characters");
				}
			}

			value = DOUBLE_QUOTE + value + DOUBLE_QUOTE;

		} else if (KEYWORDS.equals(key)) {
			String[] keywordsArray = value.split(",");

			if (keywordsArray.length > 10) {
				if ("true".equals(KEYWORDS_ERROR)) {
					StringBuffer keywordValue = new StringBuffer();

					for (int i = 0; i < 9; i++) {
						keywordValue.append(keywordsArray[i]);
						keywordValue.append(COMMA_SEPARATOR);
					}
					keywordValue.append(keywordsArray[9]);
					value = keywordValue.toString();
				} else {
					LOGGER.log(Level.SEVERE,
							"Product Keywords Exceeds expected count of 10 keywords");
					throw new DataFeedException(
							"Product Keywords Exceeds expected count of 10 keywords");
				}
			}

			value = DOUBLE_QUOTE + value + DOUBLE_QUOTE;
		}

		LOGGER.exiting(CLASSNAME, validateMandatory);

		return value;
	}

}

