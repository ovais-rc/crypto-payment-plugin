BEGIN_SYMBOL_DEFINITIONS
	
	<!-- The table for noun LAYOUT  -->
		<!-- PAGELAYOUT table -->
		COLS:PAGELAYOUT = PAGELAYOUT:*
		COLS:PAGELAYOUT_ID = PAGELAYOUT:PAGELAYOUT_ID
		COLS:NAME = PAGELAYOUT:NAME
		COLS:STOREENT_ID = PAGELAYOUT:STOREENT_ID
		COLS:MEMBER_ID = PAGELAYOUT:MEMBER_ID
		COLS:ISTEMPLATE = PAGELAYOUT:ISTEMPLATE
		COLS:ISDEFAULT = PAGELAYOUT:ISDEFAULT
		COLS:MANAGINGTOOL = PAGELAYOUT:MANAGINGTOOL
		COLS:STATE = PAGELAYOUT:STATE
		COLS:PAGELAYOUTTYPE_ID = PAGELAYOUT:PAGELAYOUTTYPE_ID
		COLS:DEVICETYPE = PAGELAYOUT:DEVICETYPE
		COLS:DESCRIPTION = PAGELAYOUT:DESCRIPTION
		COLS:STARTDATE = PAGELAYOUT:STARTDATE
		COLS:ENDDATE = PAGELAYOUT:ENDDATE
		COLS:PRIORITY = PAGELAYOUT:PRIORITY
				
		<!-- PLLOCATION table -->
		COLS:PLLOCATION = PLLOCATION:*
		COLS:PLLOCATION_ID = PLLOCATION:PLLOCATION_ID 
		
		<!-- PLWIDGET table -->
		COLS:PLWIDGET = PLWIDGET:* 
		
		<!-- PLWIDGETDEF table -->
		COLS:PLWIDGETDEF_ID = PLWIDGETDEF:PLWIDGETDEF_ID
		COLS:PLWIDGETDEF:IDENTIFIER = PLWIDGETDEF:IDENTIFIER
		COLS:PLWIDGETDEF:STOREENT_ID = PLWIDGETDEF:STOREENT_ID
		
		<!-- PLWIDGETNVP table -->
		COLS:PLWIDGETNVP = PLWIDGETNVP:*
		
		<!-- PLWIDGETSLOT table -->
		COLS:PLWIDGETSLOT = PLWIDGETSLOT:*
		
		<!-- PLWIDGETREL table -->
		COLS:PLWIDGETREL = PLWIDGETREL:* 	
		<!-- PLTEMPLATEREL table -->
		COLS:PLTEMPLATEREL = PLTEMPLATEREL:*
		<!-- PLPROPERTY table -->		
		COLS:PLPROPERTY = PLPROPERTY:*
		<!-- PLLOCSTATIC table -->
		COLS:PLLOCSTATIC = PLLOCSTATIC:* 	
END_SYMBOL_DEFINITIONS

<!-- =============================================================================================== -->
<!-- XPath: /Layout[@template=]                                                                  	 -->
<!-- Fetches all Layouts or Layout Templates for the current store path & site.            			 -->
<!-- The access profiles that apply to this SQL are:									             -->
<!--	IBM_Admin_Summary																             -->
<!--	IBM_Admin_Details																             -->
<!-- @param template                                                                                 -->
<!--                   false: Returns all Layouts for the current store path & site.                  -->
<!--                   true: Returns all Layout Templates for the current store path & site.        -->
<!-- =============================================================================================== -->

BEGIN_XPATH_TO_SQL_STATEMENT
	name=/Layout[@template=]
	base_table=PAGELAYOUT
	sql=	
		SELECT 
	     				PAGELAYOUT.$COLS:PAGELAYOUT_ID$
	     	FROM
	     				PAGELAYOUT
	     	WHERE
						PAGELAYOUT.STOREENT_ID IN ($STOREPATH:view$) AND
						PAGELAYOUT.STATE = 1 AND
						PAGELAYOUT.ISTEMPLATE = (CASE WHEN CAST((?template?) as char(5)) = 'true' THEN 1 ELSE 0 END) AND
						PAGELAYOUT.ISDEFAULT = 0
						AND PAGELAYOUT.MANAGINGTOOL = ?managingTool?  
		    ORDER BY 
				        PAGELAYOUT.ENDDATE DESC, PAGELAYOUT.NAME
END_XPATH_TO_SQL_STATEMENT

<!-- =============================================================================================== -->
<!-- XPath: /Layout[@deviceClass= and template]                                                   	 -->
<!-- Fetches Layout Templates by deviceClass for the context store path. 							 -->
<!-- The access profiles that apply to this SQL are:									             -->
<!--	IBM_Admin_Summary																             -->
<!-- @param deviceClass - The device type. e.g. Web, Mobile 										 -->
<!-- @param template - Only Templates are retrieved by this XPath, so this parameter is always 'true'.-->
<!-- =============================================================================================== -->

BEGIN_XPATH_TO_SQL_STATEMENT
	name=/Layout[@deviceClass= and template]
	base_table=PAGELAYOUT
	sql=	
		SELECT 
	     				PAGELAYOUT.$COLS:PAGELAYOUT_ID$
	     	FROM
	     				PAGELAYOUT
	     	WHERE
						PAGELAYOUT.STOREENT_ID IN ($STOREPATH:view$) AND
						PAGELAYOUT.STATE = 1 AND
						PAGELAYOUT.ISTEMPLATE = 1 AND
						PAGELAYOUT.DEVICETYPE = (?deviceClass?) AND
						PAGELAYOUT.ISDEFAULT = 0
						AND PAGELAYOUT.MANAGINGTOOL = ?managingTool?
           ORDER BY 
						PAGELAYOUT.ENDDATE DESC,PAGELAYOUT.NAME
END_XPATH_TO_SQL_STATEMENT

<!-- =============================================================================================== -->
<!-- XPath: /Layout[(@deviceClass=) and (@layoutGroup=) and default]                                 -->
<!-- Fetches default Layouts for the given Layout groups and device classes.						 -->
<!-- The access profiles that apply to this SQL are:									             -->
<!--	IBM_Admin_Summary																             -->
<!-- @param layoutGroup - The Layout Groups. e.g. Category, CatalogEntry, Content 					 -->
<!-- @param deviceClass - The device type. e.g. Web, Mobile 										 -->
<!-- @param default - Only default Layouts are retrieved by this XPath, so this parameter is always 'true'. -->
<!-- =============================================================================================== -->

BEGIN_XPATH_TO_SQL_STATEMENT
	name=/Layout[(@deviceClass=) and (@layoutGroup=) and default]
	base_table=PAGELAYOUT
	sql=	
		SELECT 
	     				PAGELAYOUT.$COLS:PAGELAYOUT_ID$
	     	FROM
	     				PAGELAYOUT
	     	WHERE
						PAGELAYOUT.STOREENT_ID IN ($STOREPATH:view$) AND
						PAGELAYOUT.STATE = 1 AND
						PAGELAYOUT.ISTEMPLATE = 0 AND
						PAGELAYOUT.PAGELAYOUTTYPE_ID IN (?layoutGroup?) AND
						PAGELAYOUT.DEVICETYPE IN (?deviceClass?) AND
						PAGELAYOUT.ISDEFAULT = 1
						AND PAGELAYOUT.MANAGINGTOOL = ?managingTool?
           ORDER BY 
						PAGELAYOUT.ENDDATE DESC,PAGELAYOUT.NAME
END_XPATH_TO_SQL_STATEMENT

<!-- ================================================================================== -->
<!-- XPath: /Layout[LayoutIdentifier[(UniqueID=)]]                                      -->
<!-- Fetches Layouts for the specified the Layout Ids.				                    -->
<!-- The access profiles that apply to this SQL are:									-->
<!--	IBM_Admin_Summary																-->
<!--	IBM_Admin_Details																-->
<!-- @param UniqueID - The Unique Ids of the Layout to fetch.	                        -->
<!-- ================================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/Layout[LayoutIdentifier[(UniqueID=)]]
	base_table=PAGELAYOUT
	sql=	
		SELECT 
	     				PAGELAYOUT.$COLS:PAGELAYOUT_ID$
	     	FROM
	     				PAGELAYOUT
	     	WHERE
						PAGELAYOUT.PAGELAYOUT_ID IN (?UniqueID?) AND
						PAGELAYOUT.STATE = 1
		    ORDER BY 
				        PAGELAYOUT.ENDDATE DESC,PAGELAYOUT.NAME
END_XPATH_TO_SQL_STATEMENT

<!-- ============================================================================================= 	-->
<!-- XPath: /Layout[LayoutIdentifier[ExternalIdentifier[(Name=) and StoreIdentifier[UniqueID=]]]]  	-->
<!-- Fetches Layouts or Layout Templates by Names for a given Store ID. 						   	-->
<!-- It returns Layouts of any state.     					                    					-->
<!-- The access profiles that apply to this SQL are:												-->
<!--	IBM_Admin_Summary																			-->
<!--	IBM_Admin_Details																			-->
<!-- @param Name - The Names of the Layouts to fetch.		  		                    			-->
<!-- ============================================================================================= 	-->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/Layout[LayoutIdentifier[ExternalIdentifier[(Name=) and StoreIdentifier[UniqueID=]]]]
	base_table=PAGELAYOUT
	sql=	
		SELECT 
	     				PAGELAYOUT.$COLS:PAGELAYOUT_ID$
	     	FROM
	     				PAGELAYOUT
	     	WHERE
						PAGELAYOUT.NAME IN (?Name?)  AND
						PAGELAYOUT.STOREENT_ID = ?UniqueID?
		    ORDER BY 
				        PAGELAYOUT.ENDDATE DESC
END_XPATH_TO_SQL_STATEMENT

<!-- =============================================================================================== -->
<!-- XPath: /Layout[@template= and search()]						                                 -->
<!-- Fetches Layouts or Layout Templates for a given search criteria.								 -->
<!-- The access profiles that apply to this SQL are:									             -->
<!--	IBM_Admin_Summary																             -->
<!-- @param template - Flag to indicate whether to search for Layouts or Layout Templates.			 --> 
<!-- =============================================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/Layout[@template= and search()]
	base_table=PAGELAYOUT
	sql=	
		SELECT 
				PAGELAYOUT.$COLS:PAGELAYOUT_ID$    				
     	FROM
				PAGELAYOUT, $ATTR_TBLS$
	    WHERE
				PAGELAYOUT.ISTEMPLATE = (CASE WHEN CAST((?template?) as char(5)) = 'true' THEN 1 ELSE 0 END) AND
				(PAGELAYOUT.STOREENT_ID IN ($STOREPATH:view$) OR PAGELAYOUT.STOREENT_ID = 0) AND
				PAGELAYOUT.STATE = 1 AND
				PAGELAYOUT.ISDEFAULT = 0 
				AND PAGELAYOUT.MANAGINGTOOL = ?managingTool?
				AND
				$ATTR_CNDS$
		ORDER BY 
				PAGELAYOUT.ENDDATE DESC,PAGELAYOUT.NAME	
END_XPATH_TO_SQL_STATEMENT

<!-- The access profiles that apply to this SQL are: IBM_Admin_Summary							-->
<!-- Fetch layouts for a given search criteria, narrow the search result by layout type, isTempalte, and startDate, endDate of the layout.   	-->						
<!-- The parts of queries to fetch layouts by name are composed by search(). The parts of queries to narrow results by type, isTempalte, and startDate, -->
<!-- endDate of the layout are composed by LayoutSearchSQLComposer. The paramters of deviceClasses, isTemplate, startDate and endDate are passed as control parameters. -->
<!-- Refer to PageLayoutFacadeClient.searchLayouts() to know more details about these control parameters. -->
<!-- @param 0 The AND conditions which are used to narrow results by type, isTemplate, and startDate, endDate of the layout. The AND conditions are composed in LayoutSearchSQLComposer. -->
<!-- ========================================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/Layout[search()]
	base_table=PAGELAYOUT
	className=com.ibm.commerce.pagelayout.facade.server.services.dataaccess.db.jdbc.LayoutSearchSQLComposer
	sql=	
		SELECT 
				PAGELAYOUT.$COLS:PAGELAYOUT_ID$    				
     	FROM
				PAGELAYOUT, 
				$ATTR_TBLS$  
				
		WHERE 		        
		        PAGELAYOUT.STOREENT_ID in ($STOREPATH:view$,0) AND
		        PAGELAYOUT.STATE = 1 AND
		        PAGELAYOUT.ISDEFAULT = 0{0} AND
		        PAGELAYOUT.MANAGINGTOOL = ?managingTool? AND
		        $ATTR_CNDS$
		ORDER BY 
		        PAGELAYOUT.ENDDATE DESC,PAGELAYOUT.NAME	         		        
END_XPATH_TO_SQL_STATEMENT

<!-- ============================================================================================= 	-->
<!-- XPath: /Layout[Widget[WidgetProperty[Name= and Value=]]]  	                                    -->
<!-- Fetches Layouts or Layout Templates which has specified widget property name and value.    	-->
<!-- It returns Layouts of any state.     					                    					-->
<!-- The access profiles that apply to this SQL are:												-->
<!--	IBM_Admin_Summary																			-->
<!--	IBM_Admin_Details																			-->
<!-- @param Name - The Names of the Layouts to fetch.		  		                    			-->
<!-- ============================================================================================= 	-->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/Layout[Widget[WidgetProperty[Name= and Value=]]]
	base_table=PAGELAYOUT
	sql=	
		SELECT 
	     				PAGELAYOUT.$COLS:PAGELAYOUT_ID$
	     	FROM
	     				PAGELAYOUT, PLWIDGET, PLWIDGETNVP
	     	WHERE
						PAGELAYOUT.STOREENT_ID in ($STOREPATH:view$,0)  AND
						PAGELAYOUT.STATE = 1 AND
						PAGELAYOUT.PAGELAYOUT_ID = PLWIDGET.PAGELAYOUT_ID AND
						PLWIDGET.PLWIDGET_ID = PLWIDGETNVP.PLWIDGET_ID AND
						PLWIDGETNVP.NAME = ?Name? AND
						PLWIDGETNVP.VALUE = ?Value?
		    ORDER BY 
				        PAGELAYOUT.ENDDATE DESC,PAGELAYOUT.NAME
END_XPATH_TO_SQL_STATEMENT

<!-- ============================================================================================= 	-->
<!-- XPath: /Layout[ExtendedData[DataType=] and Widget[WidgetIdentifier[UniqueID=]]]                -->
<!-- Fetches the extended data of the specified data type for a widget	                            -->
<!-- The access profiles that apply to this SQL are:												-->
<!--	IBM_Admin_Details																			-->
<!-- @param DataType - The type of the extended data.	    		                    			-->
<!-- @param UniqueID - The unique id of the widget. 	    		                    			-->
<!-- ============================================================================================= 	-->

BEGIN_XPATH_TO_SQL_STATEMENT
	name=/Layout[ExtendedData[DataType=] and Widget[WidgetIdentifier[UniqueID=]]]+IBM_Admin_Details
	base_table=PAGELAYOUT
	sql=	
		SELECT 
	     				PAGELAYOUT.$COLS:PAGELAYOUT$, PLWIDGET.$COLS:PLWIDGET$, PLWIDGETNVP.$COLS:PLWIDGETNVP$
	     	FROM
	     				PAGELAYOUT, PLWIDGET, PLWIDGETNVP
	     	WHERE
						PLWIDGET.PLWIDGET_ID =?UniqueID? AND
						PLWIDGET.PLWIDGET_ID = PLWIDGETNVP.PLWIDGET_ID AND
						PAGELAYOUT.PAGELAYOUT_ID = PLWIDGET.PAGELAYOUT_ID

END_XPATH_TO_SQL_STATEMENT

<!-- ================================================================================== -->
<!-- XPath: /Layout[LayoutIdentifier[UniqueID=]]/PageLocation                           -->
<!-- This XPath fetches page location of a page layout with pagination support. 		-->
<!-- The access profiles that apply to this SQL are:									-->
<!--	IBM_Admin_Layout_Locations 														-->
<!-- @param UniqueID - The Unique Id of the Layout to fetch.	                        -->
<!-- ================================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/Layout[LayoutIdentifier[UniqueID=]]/PageLocation
	base_table=PAGELAYOUT
	sql=	
		SELECT 
	     				PAGELAYOUT.$COLS:PAGELAYOUT_ID$, PLLOCATION.$COLS:PLLOCATION_ID$
	     	FROM
	     				PAGELAYOUT, PLLOCATION
	     	WHERE
						PAGELAYOUT.PAGELAYOUT_ID = ?UniqueID? AND
						PLLOCATION.PAGELAYOUT_ID = PAGELAYOUT.PAGELAYOUT_ID AND
						PAGELAYOUT.STATE = 1 
END_XPATH_TO_SQL_STATEMENT

<!-- ================================================================================== -->
<!-- XPath: /Layout[State=]																-->
<!-- The order by clause is set by the LayoutSortingOptionsSQLProcessor class based on	-->
<!-- _pgl:SortBy and _pgl:SortOrder parameters 											-->
<!-- @param State - The state of the layout. 											-->
<!-- ================================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/Layout[State=]
	base_table=PAGELAYOUT
	className=com.ibm.commerce.pagelayout.facade.server.services.dataaccess.db.jdbc.LayoutSortingOptionsSQLProcessor
	sql=	
		SELECT 
	     				PAGELAYOUT.$COLS:PAGELAYOUT_ID$
	     	FROM
	     				PAGELAYOUT LEFT OUTER JOIN PLTEMPLATEREL ON (PAGELAYOUT.PAGELAYOUT_ID = PLTEMPLATEREL.PAGELAYOUT_ID) 
	     	WHERE
						PAGELAYOUT.STATE = ?State? AND PAGELAYOUT.STATE <> 2 
						AND PAGELAYOUT.MANAGINGTOOL = ?managingTool?
						AND PAGELAYOUT.STOREENT_ID IN ($STOREPATH:view$)
END_XPATH_TO_SQL_STATEMENT

<!-- ================================================================================== -->
<!-- XPath: /Layout[State= and StaticLocation[OwnerID=]]								-->
<!-- The order by clause is set by the LayoutSortingOptionsSQLProcessor class based on	-->
<!-- _pgl:SortBy and _pgl:SortOrder parameters 											-->
<!-- @param State - The state of the layout. 											-->
<!-- @param OwnerID - The ownerId of the layout to fetch.		                        -->
<!-- ================================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/Layout[State= and StaticLocation[OwnerID=]]
	base_table=PAGELAYOUT
	className=com.ibm.commerce.pagelayout.facade.server.services.dataaccess.db.jdbc.LayoutSortingOptionsSQLProcessor
	sql=	
		SELECT 
	     				PAGELAYOUT.$COLS:PAGELAYOUT_ID$
	     	FROM
	     				PAGELAYOUT LEFT OUTER JOIN PLTEMPLATEREL ON (PAGELAYOUT.PAGELAYOUT_ID = PLTEMPLATEREL.PAGELAYOUT_ID)
	     				, PLLOCSTATIC
	     	WHERE
						PLLOCSTATIC.PAGELAYOUT_ID = PAGELAYOUT.PAGELAYOUT_ID
						AND PLLOCSTATIC.OWNER_ID = ?OwnerID?
						AND PAGELAYOUT.STATE = ?State? AND PAGELAYOUT.STATE <> 2 
						AND PAGELAYOUT.MANAGINGTOOL = ?managingTool?
						AND PAGELAYOUT.STOREENT_ID IN ($STOREPATH:view$)
END_XPATH_TO_SQL_STATEMENT

<!-- ================================================================================== -->
<!-- XPath: /Layout[State= and search()]												-->
<!-- The order by clause is set by the LayoutSortingOptionsSQLProcessor class based on	-->
<!-- _pgl:SortBy and _pgl:SortOrder parameters 											-->
<!-- @param State - The state of the layout. 											-->
<!-- ================================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/Layout[State= and search()]
	base_table=PAGELAYOUT
	className=com.ibm.commerce.pagelayout.facade.server.services.dataaccess.db.jdbc.LayoutSortingOptionsSQLProcessor
	sql=	
		SELECT 
	     				PAGELAYOUT.$COLS:PAGELAYOUT_ID$
	     	FROM
	     				PAGELAYOUT LEFT OUTER JOIN PLTEMPLATEREL ON (PAGELAYOUT.PAGELAYOUT_ID = PLTEMPLATEREL.PAGELAYOUT_ID)
	     				LEFT OUTER JOIN PLLOCSTATIC ON (PAGELAYOUT.PAGELAYOUT_ID = PLLOCSTATIC.PAGELAYOUT_ID)
	     				, $ATTR_TBLS$
	     	WHERE
						PAGELAYOUT.STATE = ?State? AND PAGELAYOUT.STATE <> 2 
						AND PAGELAYOUT.MANAGINGTOOL = ?managingTool?
						AND PAGELAYOUT.STOREENT_ID IN ($STOREPATH:view$)
						AND $ATTR_CNDS$
END_XPATH_TO_SQL_STATEMENT

<!-- ================================================================================== -->
<!-- XPath: /Layout[State= and StaticLocation[OwnerID=] and TemplateIdentifier[UniqueID=]]-->
<!-- This XPath fetches layouts of a user which are created from a specific template	-->
<!-- The access profiles that apply to this SQL are:									-->
<!--	IBM_Admin_Summary																-->
<!--	IBM_Admin_Details																-->
<!-- @param State - The state of the layout. 											-->
<!-- @param OwnerID - The static location owner ID 										-->
<!-- @param UniqueID - The unique ID of the template to filter the layouts by			-->
<!-- ================================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/Layout[State= and StaticLocation[OwnerID=] and TemplateIdentifier[UniqueID=]]
	base_table=PAGELAYOUT
	sql=	
		SELECT 
	     				PAGELAYOUT.$COLS:PAGELAYOUT_ID$
	     	FROM
	     				PAGELAYOUT, PLLOCSTATIC, PLTEMPLATEREL
	     	WHERE
	     				PAGELAYOUT.PAGELAYOUT_ID = PLTEMPLATEREL.PAGELAYOUT_ID AND
	     				PLLOCSTATIC.PAGELAYOUT_ID = PAGELAYOUT.PAGELAYOUT_ID AND
	     				PAGELAYOUT.STOREENT_ID IN ($STOREPATH:view$) AND
						PLLOCSTATIC.OWNER_ID = ?OwnerID? AND
						PLTEMPLATEREL.TEMPLATE_ID = ?UniqueID? AND
						PAGELAYOUT.STATE = ?State? AND PAGELAYOUT.STATE <> 2 AND 
						PAGELAYOUT.MANAGINGTOOL = ?managingTool?
			ORDER BY
						PLLOCSTATIC.LOCATIONNAME ASC 
END_XPATH_TO_SQL_STATEMENT

<!-- ================================================================================== -->
<!-- XPath: /Layout[State= and TemplateIdentifier[UniqueID=]]							-->
<!-- This XPath fetches layouts created from a specific template						-->
<!-- The access profiles that apply to this SQL are:									-->
<!--	IBM_Admin_Summary																-->
<!--	IBM_Admin_Details																-->
<!-- @param State - The state of the layout. 											-->
<!-- @param UniqueID - The unique ID of the template to filter the layouts by			-->
<!-- ================================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/Layout[State= and TemplateIdentifier[UniqueID=]]
	base_table=PAGELAYOUT
	sql=	
		SELECT 
	     				PAGELAYOUT.$COLS:PAGELAYOUT_ID$
	     	FROM
	     				PAGELAYOUT, PLTEMPLATEREL
	     	WHERE
	     				PAGELAYOUT.PAGELAYOUT_ID = PLTEMPLATEREL.PAGELAYOUT_ID AND
	     				PAGELAYOUT.STOREENT_ID IN ($STOREPATH:view$) AND
						PLTEMPLATEREL.TEMPLATE_ID = ?UniqueID? AND
						PAGELAYOUT.STATE = ?State? AND PAGELAYOUT.STATE <> 2 AND 
						PAGELAYOUT.MANAGINGTOOL = ?managingTool?
			ORDER BY
						PAGELAYOUT.CREATEDATE DESC 
END_XPATH_TO_SQL_STATEMENT

<!-- ========================================================================= -->
<!-- Adds summary information of Layout to the resultant data graph of Layouts.-->
<!-- ========================================================================= -->
BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_Layout_Admin_Summary
	base_table=PAGELAYOUT
	sql=
		SELECT 
				        PAGELAYOUT.$COLS:PAGELAYOUT_ID$,
	     				PAGELAYOUT.$COLS:STOREENT_ID$,
	     				PAGELAYOUT.$COLS:MEMBER_ID$,
	     				PAGELAYOUT.$COLS:NAME$,
	     				PAGELAYOUT.$COLS:ISTEMPLATE$,
	     				PAGELAYOUT.$COLS:ISDEFAULT$,
	     				PAGELAYOUT.$COLS:MANAGINGTOOL$,
	     				PAGELAYOUT.$COLS:STATE$,
	     				PAGELAYOUT.$COLS:PAGELAYOUTTYPE_ID$, 
	     				PAGELAYOUT.$COLS:DEVICETYPE$,
	     				PAGELAYOUT.$COLS:DESCRIPTION$,
	     				PAGELAYOUT.$COLS:STARTDATE$,
	     				PAGELAYOUT.$COLS:ENDDATE$,
	     				PAGELAYOUT.$COLS:PRIORITY$
		FROM
				PAGELAYOUT
		WHERE
                PAGELAYOUT.PAGELAYOUT_ID IN ($ENTITY_PKS$)
                
END_ASSOCIATION_SQL_STATEMENT

<!-- ========================================================================= -->
<!-- Adds detail information of Layout to the resultant data graph of Layouts. -->
<!-- ========================================================================= -->
BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_Layout_Admin_Details
	base_table=PAGELAYOUT
	sql=
		SELECT 
				        PAGELAYOUT.$COLS:PAGELAYOUT$
		FROM
				        PAGELAYOUT
		WHERE
                PAGELAYOUT.PAGELAYOUT_ID IN ($ENTITY_PKS$)
                
END_ASSOCIATION_SQL_STATEMENT

<!-- ========================================================================= -->
<!-- Adds Layout Identifier information to the resultant data graph of Layouts.-->
<!-- ========================================================================= -->
BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_Layout_LayoutIdentifier
	base_table=PAGELAYOUT
	sql=
		SELECT 
				        PAGELAYOUT.$COLS:PAGELAYOUT_ID$,
	     				PAGELAYOUT.$COLS:STOREENT_ID$,
	     				PAGELAYOUT.$COLS:MEMBER_ID$,
	     				PAGELAYOUT.$COLS:NAME$
		FROM
				PAGELAYOUT
		WHERE
                PAGELAYOUT.PAGELAYOUT_ID IN ($ENTITY_PKS$)
                
END_ASSOCIATION_SQL_STATEMENT

<!-- =========================================================================================== -->
<!-- This association SQL statement retrieves the PLLOCATION entities for the page layout IDs specified.-->
<!-- =========================================================================================== -->
BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_Layout_PLLOCATION
	base_table=PLLOCATION
	sql=
		SELECT 
		        PLLOCATION.$COLS:PLLOCATION$
		FROM
				PLLOCATION
		WHERE
                PLLOCATION.PAGELAYOUT_ID IN ($UNIQUE_IDS$)
END_ASSOCIATION_SQL_STATEMENT

<!-- ======================================================================================= -->
<!-- Retrieves the PLLOCATION entries with pagination-->
<!-- ======================================================================================= -->
BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_Layout_PageLocation_WithPagination
	base_table=PAGELAYOUT
	sql=
		SELECT 
			PAGELAYOUT.$COLS:PAGELAYOUT_ID$,
			PLLOCATION.$COLS:PLLOCATION$
		FROM
				PAGELAYOUT, PLLOCATION
		WHERE
                PAGELAYOUT.PAGELAYOUT_ID IN ($ENTITY_PKS$) AND 
                PLLOCATION.PLLOCATION_ID IN ($SUBENTITY_PKS$) AND 
		        PLLOCATION.PAGELAYOUT_ID = PAGELAYOUT.PAGELAYOUT_ID 
END_ASSOCIATION_SQL_STATEMENT

<!-- =================================================================================== -->
<!-- This association SQL is used to retrieve all the widgets for the page layout. The   -->
<!-- name of the SQL is symbolic to the PageLayoutGraphComposer. It indicates that the   -->
<!-- graph composer must build a flat list of widgets under the page layout.	 		 -->
<!-- =================================================================================== -->
BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_LayoutWidget_FlatList
	base_table=PLWIDGET
	sql=
		SELECT 
	     		PLWIDGET.$COLS:PLWIDGET$
		FROM
				PLWIDGET
		WHERE
                PLWIDGET.PAGELAYOUT_ID IN ($UNIQUE_IDS$)
END_ASSOCIATION_SQL_STATEMENT

<!-- =================================================================================== -->
<!-- This association SQL is used to retrieve all the widgets for the page layout. The   -->
<!-- name of the SQL is symbolic to the PageLayoutGraphComposer. It indicates that the   -->
<!-- graph composer must build a hierarchical tree of widgets under the page layout.	 -->
<!-- =================================================================================== -->
BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_LayoutWidget_Tree
	base_table=PLWIDGET
	sql=
		SELECT 
	     		PLWIDGET.$COLS:PLWIDGET$
		FROM
				PLWIDGET
		WHERE
                PLWIDGET.PAGELAYOUT_ID IN ($UNIQUE_IDS$)
END_ASSOCIATION_SQL_STATEMENT

<!-- =========================================================================================== -->
<!-- This association SQL statement retrieves the template information for the layout IDs specified.-->
<!-- =========================================================================================== -->
BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_Layout_PLTEMPLATEREL
	base_table=PLTEMPLATEREL
	sql=
		SELECT 
			PLTEMPLATEREL.$COLS:PLTEMPLATEREL$,
			PAGELAYOUT.$COLS:PAGELAYOUT_ID$,
			PAGELAYOUT.$COLS:NAME$
		FROM
				PLTEMPLATEREL
	     			  LEFT OUTER JOIN PAGELAYOUT ON (PAGELAYOUT.PAGELAYOUT_ID = PLTEMPLATEREL.TEMPLATE_ID)
		WHERE
                PLTEMPLATEREL.PAGELAYOUT_ID IN ($UNIQUE_IDS$)
END_ASSOCIATION_SQL_STATEMENT

<!-- =========================================================================================== -->
<!-- This association SQL statement retrieves the widget slot information for the widget IDs specified.-->
<!-- =========================================================================================== -->
BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_LayoutWidget_PLWIDGETSLOT
	base_table=PLWIDGETSLOT
	sql=
		SELECT 
	     		PLWIDGETSLOT.$COLS:PLWIDGETSLOT$
		FROM
				PLWIDGETSLOT
		WHERE
                PLWIDGETSLOT.PLWIDGET_ID IN ($UNIQUE_IDS$)
		ORDER BY 
		        PLWIDGETSLOT.ADMINNAME
END_ASSOCIATION_SQL_STATEMENT

<!-- =========================================================================================== -->
<!-- This association SQL statement retrieves the widget properties for the widget IDs specified.-->
<!-- =========================================================================================== -->
BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_LayoutWidget_PLWIDGETNVP
	base_table=PLWIDGETNVP
	sql=
		SELECT 
	     		PLWIDGETNVP.$COLS:PLWIDGETNVP$
		FROM
				PLWIDGETNVP
		WHERE
                PLWIDGETNVP.PLWIDGET_ID IN ($UNIQUE_IDS$)
END_ASSOCIATION_SQL_STATEMENT

<!-- ============================================================================================ -->
<!-- This association SQL statement retrieves the widget relations for the widget IDs specified.-->
<!-- ============================================================================================ -->
BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_LayoutWidget_PLWIDGETREL
	base_table=PLWIDGETREL
	sql=
		SELECT 
	     		PLWIDGETREL.$COLS:PLWIDGETREL$
		FROM
				PLWIDGETREL
		WHERE
                PLWIDGETREL.PLWIDGET_ID_CHILD IN ($UNIQUE_IDS$)
END_ASSOCIATION_SQL_STATEMENT

<!-- =========================================================================================== -->
<!-- This association SQL statement retrieves the PLPROPERTY entities for the page layout IDs specified.-->
<!-- =========================================================================================== -->
BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_Layout_PLPROPERTY
	base_table=PLPROPERTY
	sql=
		SELECT 
		        PLPROPERTY.$COLS:PLPROPERTY$
		FROM
				PLPROPERTY
		WHERE
                PLPROPERTY.PAGELAYOUT_ID IN ($UNIQUE_IDS$)
END_ASSOCIATION_SQL_STATEMENT

<!-- =========================================================================================== -->
<!-- This association SQL statement retrieves the PLPROPERTY entities for the page layout IDs specified.-->
<!-- =========================================================================================== -->
BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_Layout_StaticLocation
	base_table=PAGELAYOUT
	sql=
		SELECT 
				PAGELAYOUT.$COLS:PAGELAYOUT_ID$,
	     		PLLOCSTATIC.$COLS:PLLOCSTATIC$
		FROM
				PAGELAYOUT, PLLOCSTATIC
		WHERE
                PAGELAYOUT.PAGELAYOUT_ID IN ($ENTITY_PKS$) AND PAGELAYOUT.PAGELAYOUT_ID = PLLOCSTATIC.PAGELAYOUT_ID                
END_ASSOCIATION_SQL_STATEMENT

<!-- ============================================================================= -->
<!-- This access profile returns the following summary information of Layouts:	   -->
<!-- @template                                                                     -->
<!-- @default                                                                      -->
<!-- @layoutGroup                                                                  -->
<!-- @deviceClass                                                                  -->
<!-- @state                                                                        -->
<!-- LayoutIdentifier                                                              -->
<!-- ============================================================================= -->
BEGIN_PROFILE 
    name=IBM_Admin_Summary
    BEGIN_ENTITY 
    	base_table=PAGELAYOUT
    	className=com.ibm.commerce.foundation.internal.server.services.dataaccess.graphbuilderservice.DefaultGraphComposer
    	associated_sql_statement=IBM_Layout_Admin_Summary
    	associated_sql_statement=IBM_Layout_StaticLocation 
    END_ENTITY
END_PROFILE

<!-- ============================================================================= -->
<!-- This access profiles provides pagination support for fetching page locations of a layout. -->
<!-- Use this access profile with /Layout[LayoutIdentifier[UniqueID=]]/PageLocation XPath only. -->
<!-- ============================================================================= -->
BEGIN_PROFILE 
    name=IBM_Admin_Layout_Locations
    BEGIN_ENTITY 
    	base_table=PAGELAYOUT
    	className=com.ibm.commerce.foundation.internal.server.services.dataaccess.graphbuilderservice.DefaultGraphComposer
    	associated_sql_statement=IBM_Layout_Admin_Summary 
    	associated_sql_statement=IBM_Layout_StaticLocation
    	associated_sql_statement=IBM_Layout_PageLocation_WithPagination
    END_ENTITY
END_PROFILE

<!-- ============================================================================================================= -->
<!-- This access profile returns the details of Layouts. 														   -->
<!-- The Widgets in the Layout nouns are returned as a flat structure using this access profile. 				   -->
<!-- ============================================================================================================= -->
BEGIN_PROFILE 
    name=IBM_Admin_Details
    BEGIN_ENTITY 
    	base_table=PAGELAYOUT
    	className=com.ibm.commerce.pagelayout.facade.server.services.dataaccess.graphbuilderservice.PageLayoutGraphComposer
    	associated_sql_statement=IBM_Layout_Admin_Details 
    	associated_sql_statement=IBM_LayoutWidget_FlatList
    	associated_sql_statement=IBM_LayoutWidget_PLWIDGETNVP
    	associated_sql_statement=IBM_LayoutWidget_PLWIDGETSLOT
    	associated_sql_statement=IBM_LayoutWidget_PLWIDGETREL
    	associated_sql_statement=IBM_Layout_PLTEMPLATEREL
    	associated_sql_statement=IBM_Layout_PLLOCATION
    	associated_sql_statement=IBM_Layout_PLPROPERTY
    	associated_sql_statement=IBM_Layout_StaticLocation 
    END_ENTITY
END_PROFILE

<!-- ============================================================================================================= -->
<!-- This access profile returns only the Layout Identifier and Widget details of Layouts.						   -->
<!-- The Widgets in the Layout nouns are returned as a hierarchy structure using this access profile. 			   -->
<!-- ============================================================================================================= -->
BEGIN_PROFILE 
    name=IBM_Widgets_With_Hierarchy
    BEGIN_ENTITY 
    	base_table=PAGELAYOUT
    	className=com.ibm.commerce.pagelayout.facade.server.services.dataaccess.graphbuilderservice.PageLayoutGraphComposer
    	associated_sql_statement=IBM_Layout_LayoutIdentifier
    	associated_sql_statement=IBM_LayoutWidget_Tree
    	associated_sql_statement=IBM_LayoutWidget_PLWIDGETNVP
    	associated_sql_statement=IBM_LayoutWidget_PLWIDGETREL
    	associated_sql_statement=IBM_Layout_PLPROPERTY
    END_ENTITY
END_PROFILE
