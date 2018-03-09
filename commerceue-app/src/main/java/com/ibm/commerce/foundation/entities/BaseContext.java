package com.ibm.commerce.foundation.entities;

/*
 *-----------------------------------------------------------------
 * IBM Confidential
 *
 * OCO Source Materials
 *
 * WebSphere Commerce
 *
 * (C) Copyright IBM Corp. 2015, 2016
 *
 * The source code for this program is not published or otherwise
 * divested of its trade secrets, irrespective of what has
 * been deposited with the U.S. Copyright Office.
 *-----------------------------------------------------------------
 */

public class BaseContext {
	
	private String storeId;
	private String callerId;
	private String runAsId;
	private String channelId;

	public BaseContext(){
		
	}
	
    public BaseContext(String storeId, String callerId, String runAsId, String channelId){
		this.storeId = storeId;
		this.callerId = callerId;
		this.runAsId = runAsId;
		this.channelId = channelId;
	}

	public String getStoreId(){
		return storeId;
	}
	
	public String getCallerId(){
		return callerId;
	}
	
	public String getRunAsId(){
		return runAsId;
	}
	
	public String getChannelId(){
		return channelId;
	}
	
	public void setStoreId(String id){
		storeId = id;
	}
	
	public void setCallerId(String id){	
		callerId = id;
	}
	
	public void setRunAsId(String id){
		runAsId = id;
	}
	
	public void setChannelId(String id){
		channelId = id;
	}
	
	
	
}
