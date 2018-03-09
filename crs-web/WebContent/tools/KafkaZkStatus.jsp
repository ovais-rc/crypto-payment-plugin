<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2016 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%@	page session="false"%><%@ 
	page pageEncoding="UTF-8"%>
	<%@ page import="com.ibm.commerce.component.util.BackendServersConfigurationUtil" %>
	<%@ page import="kafka.javaapi.consumer.ConsumerConnector" %>
	<%@ page import="kafka.consumer.ConsumerConfig" %>
	<%@ page import="kafka.consumer.Consumer" %>
	<%@ page import="java.util.Properties" %>
	<%@ page import="java.lang.String" %>
	<%@ page import="com.ibm.commerce.component.server.WcsApp" %>
	<%@ page import="org.I0Itec.zkclient.exception.ZkTimeoutException" %>
	
	
	<%
	
	String zookeeperServer = BackendServersConfigurationUtil.getZookeeperServerPort();
	ConsumerConnector consumerConnector = null; 
	if(zookeeperServer!=null && zookeeperServer.trim().length() > 0){
		Properties props = new Properties();
        props.put("zookeeper.connect", zookeeperServer);
        //use cloneId as the consumer client id.
        //groupId should be alphanumeric, so trim other characters
        String groupId = WcsApp.cloneId;
        groupId = groupId.replaceAll("\\W", "");
        props.put("group.id", groupId+"testgroup");
        props.put("zookeeper.session.timeout.ms", "400");
        props.put("zookeeper.sync.time.ms", "200");
        props.put("auto.commit.interval.ms", "1000");
        
		// Create the connection to the cluster
		ConsumerConfig consumerConfig = new ConsumerConfig(props);
		
		//step1 connect to zookeeper server safely
		boolean connected = false;
		while(!connected){
			try{
				consumerConnector = Consumer.createJavaConsumerConnector(consumerConfig);
				connected = true;
			}catch(ZkTimeoutException timeout){
				try{
					Thread.sleep(1000);
				}catch(InterruptedException ite){
				}
//				timeout.printStackTrace();
			}
		}
	}
	
	if(consumerConnector != null){
		out.println("connected!");
		consumerConnector.shutdown();
	}else{
		out.println("not connected!");
	}
	
	%>
