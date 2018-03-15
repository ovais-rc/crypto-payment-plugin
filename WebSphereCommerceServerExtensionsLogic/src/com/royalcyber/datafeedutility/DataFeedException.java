package com.royalcyber.datafeedutility;


/**
 * @author Balkrishna
 * 
 *         Custom exception class to indicate errors occurred from DataFeed
 */
public class DataFeedException extends Exception {
	/**
	 * @param message
	 */
	public DataFeedException(String message) {
		super(message);
	}

	/**
	 * @param cause
	 */
	public DataFeedException(Throwable cause) {
		super(cause);
	}

	/**
	 * @param message
	 * @param cause
	 */
	public DataFeedException(String message, Throwable cause) {
		super(message, cause);
	}
}
