package com.ibm.commerce.ue.rest;

import java.text.MessageFormat;
import java.util.Locale;
import java.util.MissingResourceException;
import java.util.ResourceBundle;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Application and system message keys.
 */
public class MessageKey {

	private static final Logger LOGGER = Logger.getLogger(MessageKey.class.getName());
	private static final String CONFIG_BUNDLE_NAME = "com.ibm.commerce.ue.properties.config";
	private static final String MESSAGE_BUNDLE_NAME = "com.ibm.commerce.ue.properties.Messages";

	/**
	 * Returns the configuration.
	 *
	 * @param configKey
	 *            The configuration key.
	 * @param configArguments
	 *            The configuration arguments.
	 * @return The configuration.
	 */
	public static String getConfig(final String configKey, final Object... configArguments) {

		String config = null;

		final ResourceBundle configBundle = ResourceBundle.getBundle(
				CONFIG_BUNDLE_NAME);
		try {
			config = configBundle.getString(configKey);
			config = MessageFormat.format(config, configArguments);
		} catch (final MissingResourceException mre) {
			LOGGER.log(Level.SEVERE, mre.getMessage(), mre);
		}

		return config;

	}
	
	/**
	 * Returns the message without a given locale.
	 *
	 * @param messageKey
	 *            The message key.
	 * @param messageArguments
	 *            The message arguments.
	 * @return The message.
	 */
	public static String getMessage(final String messageKey, final Object... messageArguments) {
		//en_US used as the default if no locale is provided
		Locale locale = new Locale("en", "US");
		return getMessage(locale, messageKey, messageArguments);
	}
	
	/**
	 * Returns the message given a locale.
	 *
	 * @param locale
	 *            The locale.
	 * @param messageKey
	 *            The message key.
	 * @param messageArguments
	 *            The message arguments.
	 * @return The message.
	 */
	public static String getMessage(final Locale locale, final String messageKey, final Object... messageArguments) {

		String message = null;

		final ResourceBundle messageBundle = ResourceBundle.getBundle(
				MESSAGE_BUNDLE_NAME, locale);
		try {
			message = messageBundle.getString(messageKey);
			message = MessageFormat.format(message, messageArguments);
		} catch (final MissingResourceException mre) {
			LOGGER.log(Level.SEVERE, mre.getMessage(), mre);
		}

		return message;

	}

}
