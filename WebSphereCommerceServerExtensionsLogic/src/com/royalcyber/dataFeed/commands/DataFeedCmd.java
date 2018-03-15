/**
 * 
 */
package com.royalcyber.dataFeed.commands;

import com.ibm.commerce.command.ControllerCommand;
/**
 * @author Administrator
 *
 */
public interface DataFeedCmd extends ControllerCommand{

	// set default command implement class
	static final String defaultCommandClassName = "com.royalcyber.dataFeed.commands.DataFeedCmdImpl";
}
