<!-- ========================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (c) Copyright IBM Corp. 2001, 2002, 2003

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 ===========================================================================-->

<%@include file="ReportHeaderSummaryHelper.jsp"%>

<%!
	// get input parameter ...

	private String generateSpecificCSROutputInputCriteria(String reportPrefix, Hashtable reportsRB, Locale locale){
		StringBuffer buff = new StringBuffer("");
		buff.append(generateOutputInputCriteria(reportPrefix, reportsRB, locale));
		Hashtable aReportDataBeanEnv = aReportDataBean.getEnv();
		String parm = (String) aReportDataBeanEnv.get("InputParm");


		if(parm != null){
			parm = UIUtil.toHTML(parm);
			buff.append("   <DIV ID=pageBody STYLE=\"display: block; margin-left: 20\">\n");
			buff.append("<b>" + reportsRB.get(reportPrefix + "ReportInputParameterTitle") + "</b> ");
      		buff.append(parm + "<BR>");
			buff.append("   </DIV><BR>\n\n");		
		}

		return buff.toString();

	}



	private String generateIndividualCustomerOrganizationsSpecificCSROutputInputCriteria(String reportPrefix, Hashtable reportsRB, Locale locale){

		StringBuffer buff = new StringBuffer("");
		buff.append(generateOutputInputCriteria(reportPrefix, reportsRB, locale));
		Hashtable aReportDataBeanEnv = aReportDataBean.getEnv();
		String parm = (String) aReportDataBeanEnv.get("InputParm");
		String parmName = (String) aReportDataBeanEnv.get("InputParmName");
		if(parm != null){
			parm = UIUtil.toHTML(parm);
			buff.append("   <DIV ID=pageBody STYLE=\"display: block; margin-left: 20\">\n");
			if(parmName.equals("ORGNAME"))
				buff.append("<b>" + reportsRB.get(reportPrefix + "ReportEnterOrg") + "</b> ");
			else
				buff.append("<b>" + reportsRB.get(reportPrefix + "ReportInputParameterTitle") + "</b> ");
    	  		buff.append(parm + "<BR>");
			buff.append("   </DIV><BR>\n\n");		
		}
		return buff.toString();
	}



	private String generateTeamCustomerOrganizationsSpecificCSROutputInputCriteria(String reportPrefix, Hashtable reportsRB, Locale locale){

		StringBuffer buff = new StringBuffer("");
		buff.append(generateOutputInputCriteria(reportPrefix, reportsRB, locale));
		Hashtable aReportDataBeanEnv = aReportDataBean.getEnv();
		String parm = (String) aReportDataBeanEnv.get("InputParm");
		String parmName = (String) aReportDataBeanEnv.get("InputParmName");
		if(parm != null){
			parm = UIUtil.toHTML(parm);
			buff.append("   <DIV ID=pageBody STYLE=\"display: block; margin-left: 20\">\n");
			if(parmName.equals("ORGNAME"))
				buff.append("<b>" + reportsRB.get(reportPrefix + "ReportEnterOrg") + "</b> ");
			else
				buff.append("<b>" + reportsRB.get(reportPrefix + "ReportInputParameterTitle") + "</b> ");
    	  		buff.append(parm + "<BR>");
			buff.append("   </DIV><BR>\n\n");				
		}
		return buff.toString();
	}

%>