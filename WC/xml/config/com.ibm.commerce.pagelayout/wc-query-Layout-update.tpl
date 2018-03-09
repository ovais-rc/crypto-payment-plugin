BEGIN_SYMBOL_DEFINITIONS
    <!-- PAGELAYOUT table -->
		COLS:PAGELAYOUT = PAGELAYOUT:*
		COLS:PAGELAYOUT_ID = PAGELAYOUT:PAGELAYOUT_ID
		COLS:NAME = PAGELAYOUT:NAME
		COLS:STOREENT_ID = PAGELAYOUT:STOREENT_ID
		
	<!-- PLWIDGET table -->
		COLS:PLWIDGET = PLWIDGET:*
		COLS:PLWIDGET_ID = PLWIDGET:PLWIDGET_ID
	<!-- PLLOCATION table -->
		COLS:PLLOCATION = PLLOCATION:* 
		
	<!-- PLWIDGETSLOT table -->
		COLS:PLWIDGETSLOT = PLWIDGETSLOT:*
	
	<!-- PLWIDGETNVP table -->
		COLS:PLWIDGETNVP = PLWIDGETNVP:*
		
	<!-- PLWIDGETREL table -->
		COLS:PLWIDGETREL = PLWIDGETREL:* 
		
	<!-- PLTEMPLATEREL table -->
		COLS:PLTEMPLATEREL:PAGELAYOUT_ID = PLTEMPLATEREL:PAGELAYOUT_ID
	
	<!-- PLPROPERTY table -->
		COLS:PLPROPERTY = PLPROPERTY:*
	
	<!-- PLLOCSTATIC table -->
		COLS:PLLOCSTATIC = PLLOCSTATIC:*
END_SYMBOL_DEFINITIONS
<!-- ================================================================================== -->
<!-- XPath: /Layout[LayoutIdentifier[(UniqueID=)]] -->
<!-- The access profiles that apply to this SQL is:									-->
<!-- IBM_Layout_Update-->
<!-- @param UniqueID  UniqueID of Layout to retrieve -->   
<!-- ================================================================================== -->

BEGIN_XPATH_TO_SQL_STATEMENT
	name=/Layout[LayoutIdentifier[(UniqueID=)]]+IBM_Layout_Update
	base_table=PAGELAYOUT
	sql=	
		SELECT 
	     				PAGELAYOUT.$COLS:PAGELAYOUT$,
	     				PLLOCSTATIC.$COLS:PLLOCSTATIC$
	     	FROM
	     				PAGELAYOUT LEFT OUTER JOIN PLLOCSTATIC ON (PAGELAYOUT.PAGELAYOUT_ID = PLLOCSTATIC.PAGELAYOUT_ID AND PAGELAYOUT.PAGELAYOUT_ID IN (?UniqueID?))
	     	WHERE
						PAGELAYOUT.PAGELAYOUT_ID IN (?UniqueID?) AND
						PAGELAYOUT.STATE = 1

END_XPATH_TO_SQL_STATEMENT

<!-- =============================================================================================== -->
<!-- XPath: /Layout[(@deviceClass=) and (@layoutGroup=) and default]                                 -->
<!-- Fetches default Layouts for the given Layout groups and device classes.						 -->
<!-- The access profiles that apply to this SQL are:									             -->
<!--	IBM_Layout_Update																             -->
<!-- @param layoutGroup - The Layout Groups. e.g. Category, CatalogEntry, Content 					 -->
<!-- @param deviceClass - The device type. e.g. Web, Mobile 										 -->
<!-- @param default - Only default Layouts are retrieved by this XPath, so this parameter is always 'true'. -->
<!-- =============================================================================================== -->

BEGIN_XPATH_TO_SQL_STATEMENT
	name=/Layout[(@deviceClass=) and (@layoutGroup=) and default]+IBM_Layout_Update
	base_table=PAGELAYOUT
	sql=	
		SELECT 
	     				PAGELAYOUT.$COLS:PAGELAYOUT$
	     	FROM
	     				PAGELAYOUT
	     	WHERE
						PAGELAYOUT.STOREENT_ID IN ($STOREPATH:view$, 0) AND
						PAGELAYOUT.STATE = 1 AND
						PAGELAYOUT.ISTEMPLATE = 0 AND
						PAGELAYOUT.PAGELAYOUTTYPE_ID IN (?layoutGroup?) AND
						PAGELAYOUT.DEVICETYPE IN (?deviceClass?) AND
						PAGELAYOUT.ISDEFAULT = 1
           ORDER BY 
						PAGELAYOUT.NAME
END_XPATH_TO_SQL_STATEMENT

<!-- ================================================================================== -->
<!-- XPath: /Layout[LayoutIdentifier[ExternalIdentifier[(Name=) and StoreIdentifier[(UniqueID=)]]]] -->
<!-- The access profiles that apply to this SQL are:									-->
<!--	IBM_Layout_Update																-->	
<!-- @param Name  Name(External ID) of Layout to retrieve -->   
<!-- ================================================================================== -->

BEGIN_XPATH_TO_SQL_STATEMENT
	name=/Layout[LayoutIdentifier[ExternalIdentifier[(Name=) and StoreIdentifier[(UniqueID=)]]]]+IBM_Layout_Update
	base_table=PAGELAYOUT
	sql=	
		SELECT 
	     				PAGELAYOUT.$COLS:PAGELAYOUT_ID$,
	     				PAGELAYOUT.$COLS:NAME$
	     	FROM
	     				PAGELAYOUT
	     	WHERE
						PAGELAYOUT.NAME IN (?Name?) AND
						PAGELAYOUT.STOREENT_ID IN (?UniqueID?)

END_XPATH_TO_SQL_STATEMENT

<!-- ================================================================================== -->
<!-- This XPATH retrieves all the layouts for the given template id.                    -->
<!-- XPath: /Layout[TemplateIdentifier[(UniqueID=)]]                                    -->
<!-- The access profiles that apply to this SQL are:									-->
<!--	IBM_Layout_Update																-->	
<!-- @param UniqueID  UniqueID of Template                                              -->   
<!-- ================================================================================== -->

BEGIN_XPATH_TO_SQL_STATEMENT
	name=/Layout[TemplateIdentifier[(UniqueID=)]]+IBM_Layout_Update
	base_table=PLTEMPLATEREL
	sql=	
		SELECT 
	     				PLTEMPLATEREL.$COLS:PLTEMPLATEREL:PAGELAYOUT_ID$
	     	FROM
	     				PLTEMPLATEREL
	     	WHERE
						PLTEMPLATEREL.TEMPLATE_ID IN (?UniqueID?)
END_XPATH_TO_SQL_STATEMENT

<!-- ============================================================================= -->
<!-- XPath: /Layout/PageLocation[(PageLocationID=)]                                -->
<!-- AccessProfile:	IBM_Admin_Layout_PageLocation_Update                           -->
<!-- Get the Page Location information for the specified Page Location ID.         -->
<!-- ============================================================================= -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/Layout/PageLocation[(PageLocationID=)]+IBM_Admin_Layout_PageLocation_Update
	base_table=PLLOCATION
	sql=	
		SELECT 
	     				PLLOCATION.$COLS:PLLOCATION$
	     	FROM
	     				PLLOCATION
	     	WHERE
						PLLOCATION.PLLOCATION_ID IN (?PageLocationID?)
END_XPATH_TO_SQL_STATEMENT

<!-- ============================================================================ -->
<!-- XPath: /Layout[LayoutIdentifier[(UniqueID=)]]/PageLocation[]                 -->
<!-- AccessProfile:	IBM_Admin_Layout_PageLocation_Update                          -->
<!-- Get all the Page Location for the specified Layout Unique ID.                -->
<!-- ============================================================================ -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/Layout[LayoutIdentifier[(UniqueID=)]]/PageLocation[]+IBM_Admin_Layout_PageLocation_Update
	base_table=PLLOCATION
	sql=	
		SELECT 
	     				PLLOCATION.$COLS:PLLOCATION$
	     	FROM
	     				PLLOCATION
	     	WHERE
						PLLOCATION.PAGELAYOUT_ID IN (?UniqueID?)
END_XPATH_TO_SQL_STATEMENT

<!-- ==================================================================================  -->
<!-- XPath: /Layout[LayoutIdentifier[(UniqueID=)] and Widget[WidgetIdentifier[(Name=)]]] -->
<!-- The access profiles that apply to this SQL are:									 -->
<!--	IBM_Layout_Widget_Update																 -->	
<!-- @param UniqueID  UniqueID of Layout to retrieve                                     -->
<!-- @param Name  Name of Widget to retrieve                                             -->
<!-- ================================================================================== -->

BEGIN_XPATH_TO_SQL_STATEMENT
	name=/Layout[LayoutIdentifier[(UniqueID=)] and Widget[WidgetIdentifier[(Name=)]]]+IBM_Layout_Widget_Update
	base_table=PLWIDGET
	sql=	
		SELECT 
	     				PLWIDGET.$COLS:PLWIDGET_ID$
	     	FROM
	     				PLWIDGET
	     	WHERE
						PLWIDGET.PAGELAYOUT_ID IN (?UniqueID?)  AND
						PLWIDGET.ADMINNAME IN (?Name?)

END_XPATH_TO_SQL_STATEMENT

<!-- ==================================================================================  -->
<!-- XPath: /Layout[Widget[WidgetIdentifier[(UniqueID=)]]] -->
<!-- The access profiles that apply to this SQL are:									 -->
<!--	IBM_Layout_Widget_Update														-->	
<!-- @param UniqueID  UniqueID of Layout to retrieve                                     --> 
<!-- ================================================================================== -->

BEGIN_XPATH_TO_SQL_STATEMENT
	name=/Layout[Widget[WidgetIdentifier[(UniqueID=)]]]+IBM_Layout_Widget_Update
	base_table=PLWIDGET
	sql=	
		SELECT 
	     				PLWIDGET.$COLS:PLWIDGET$,
	     				PLWIDGETREL.$COLS:PLWIDGETREL$,
	     				PLWIDGETNVP.$COLS:PLWIDGETNVP$
	     	FROM
	     			PLWIDGET
	     			 	LEFT OUTER JOIN PLWIDGETREL  ON (PLWIDGET.PLWIDGET_ID = PLWIDGETREL.PLWIDGET_ID_CHILD)
	     			 	LEFT OUTER JOIN PLWIDGETNVP ON (PLWIDGET.PLWIDGET_ID = PLWIDGETNVP.PLWIDGET_ID)
	     	WHERE
						PLWIDGET.PLWIDGET_ID IN (?UniqueID?)
						

END_XPATH_TO_SQL_STATEMENT

<!-- ==================================================================================  -->
<!-- XPath: /Layout[LayoutIdentifier[(UniqueID=)] and Widget[ChildSlot[SlotIdentifier(Name=)]]] -->
<!-- The access profiles that apply to this SQL are:									 -->
<!--	IBM_Layout_Widget_ChildSlot_Update														-->	
<!-- @param UniqueID  UniqueID of Layout to retrieve                                     -->
<!-- @param Name  Name of Widget to retrieve                                             -->
<!-- ================================================================================== -->

BEGIN_XPATH_TO_SQL_STATEMENT
	name=/Layout[LayoutIdentifier[(UniqueID=)] and Widget[ChildSlot[SlotIdentifier(Name=)]]]+IBM_Layout_Widget_ChildSlot_Update
	base_table=PLWIDGETSLOT
	sql=	
		SELECT 
	     				PLWIDGETSLOT.$COLS:PLWIDGETSLOT$
	     	FROM
	     				PLWIDGETSLOT
	     	WHERE
						PLWIDGETSLOT.PAGELAYOUT_ID IN (?UniqueID?) AND
						PLWIDGETSLOT.ADMINNAME IN (?Name?)

END_XPATH_TO_SQL_STATEMENT

<!-- ==================================================================================  -->
<!-- XPath: /Layout[Widget[ChildSlot[SlotIdentifier(UniqueID=)]]] -->
<!-- The access profiles that apply to this SQL are:									 -->
<!--	IBM_Layout_Widget_ChildSlot_Update														-->	
<!-- @param UniqueID  UniqueID of Layout to retrieve                                     -->                                         -->
<!-- ================================================================================== -->

BEGIN_XPATH_TO_SQL_STATEMENT
	name=/Layout[Widget[ChildSlot[SlotIdentifier(UniqueID=)]]]+IBM_Layout_Widget_ChildSlot_Update
	base_table=PLWIDGETSLOT
	sql=	
		SELECT 
	     				PLWIDGETSLOT.$COLS:PLWIDGETSLOT$
	     	FROM
	     				PLWIDGETSLOT
	     	WHERE
						PLWIDGETSLOT.PLWIDGETSLOT_ID IN (?UniqueID?)

END_XPATH_TO_SQL_STATEMENT

<!-- ==================================================================================  -->
<!-- XPath: /Layout/Widget[WidgetIdentifier(UniqueID=)]                                  -->
<!-- The access profiles that apply to this SQL are:									 -->
<!--	IBM_IdResolve														             -->	
<!-- @param UniqueID  UniqueID of Widgets to retrieve                                    -->
<!-- ================================================================================== -->

BEGIN_XPATH_TO_SQL_STATEMENT
	name=/Layout/Widget[WidgetIdentifier(UniqueID=)]+IBM_IdResolve
	base_table=PLWIDGET
	sql=	
		SELECT 
	     				PLWIDGET.$COLS:PLWIDGET$
	     	FROM
	     				PLWIDGET
	     	WHERE
						PLWIDGET.PLWIDGET_ID IN (?UniqueID?)

END_XPATH_TO_SQL_STATEMENT

<!-- ==================================================================================  -->
<!-- Retrieves all the widgets in the layout specified	                                 -->
<!-- XPath: /PLWIDGET[PAGELAYOUT_ID=]					                                 -->
<!-- The access profiles that apply to this SQL are:									 -->
<!--	IBM_Admin_Summary													             -->	
<!-- @param PAGELAYOUT_ID  UniqueID of the page layout 									 -->
<!-- ================================================================================== -->

BEGIN_XPATH_TO_SQL_STATEMENT
	name=/PLWIDGET[PAGELAYOUT_ID=]+IBM_Admin_Summary
	base_table=PLWIDGET
	sql=	
		SELECT 
	     				PLWIDGET.$COLS:PLWIDGET$
	     	FROM
	     				PLWIDGET
	     	WHERE
						PLWIDGET.PAGELAYOUT_ID = ?PAGELAYOUT_ID?
END_XPATH_TO_SQL_STATEMENT

<!-- ==================================================================================  -->
<!-- Retrieves layout properties based on name, value and page layout ID specified       -->
<!-- XPath: /Layout[LayoutIdentifier[UniqueID=] and LayoutProperty[(Name=) and (Value=)]]-->
<!-- The access profiles that apply to this SQL are:									 -->
<!--	IBM_Admin_LayoutProperty_Update										             -->	
<!-- @param UniqueID  UniqueID of the page layout 										 -->
<!-- @param Name  Name of the layout property 											 -->
<!-- @param Value  Value of the Layout property											 -->
<!-- ================================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/Layout[LayoutIdentifier[UniqueID=] and LayoutProperty[(Name=) and (Value=)]]+IBM_Admin_LayoutProperty_Update
	base_table=PLPROPERTY
	sql=
		SELECT
				PLPROPERTY.$COLS:PLPROPERTY$
		FROM
				PLPROPERTY
		WHERE
				PLPROPERTY.PAGELAYOUT_ID = ?UniqueID?
				AND PLPROPERTY.NAME IN (?Name?)
				AND PLPROPERTY.VALUE IN (?Value?)
END_XPATH_TO_SQL_STATEMENT

<!-- ==================================================================================  -->
<!-- Retrieves layout properties based on name, value and page layout ID specified       -->
<!-- XPath: /Layout[LayoutIdentifier[UniqueID=] and LayoutProperty[(Name=) and (Value=)]]-->
<!-- The access profiles that apply to this SQL are:									 -->
<!--	IBM_Admin_LayoutProperty_Update										             -->	
<!-- @param UniqueID  UniqueID of the page layout 										 -->
<!-- @param Name  Name of the layout property 											 -->
<!-- @param Value  Value of the Layout property											 -->
<!-- ================================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/Layout[LayoutProperty(LayoutPropertyID=)]+IBM_Admin_LayoutProperty_Update
	base_table=PLPROPERTY
	sql=
		SELECT
				PLPROPERTY.$COLS:PLPROPERTY$
		FROM
				PLPROPERTY
		WHERE
				PLPROPERTY.PLPROPERTY_ID IN (?LayoutPropertyID?)
END_XPATH_TO_SQL_STATEMENT				


<!-- ==================================================================================  -->
<!-- Retrieves PLLOCSTATIC based on the PAGELAYOUT_ID specified						     -->
<!-- XPath: /Layout[LayoutIdentifier[(UniqueID=)]]										 -->
<!-- The access profiles that apply to this SQL are:									 -->
<!--	IBM_Admin_LayoutStaticLocation_Update								             -->	
<!-- @param UniqueID  UniqueID of the page layout 										 -->
<!-- @param Name  Name of the layout property 											 -->
<!-- @param Value  Value of the Layout property											 -->
<!-- ================================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/Layout[LayoutIdentifier[(UniqueID=)]]+IBM_Admin_LayoutStaticLocation_Update
	base_table=PLLOCSTATIC
	sql=
		SELECT
				PLLOCSTATIC.$COLS:PLLOCSTATIC$
		FROM
				PLLOCSTATIC
		WHERE
				PLLOCSTATIC.PAGELAYOUT_ID IN (?UniqueID?)
END_XPATH_TO_SQL_STATEMENT

<!-- ==================================================================================  -->
<!-- Retrieves PLLOCSTATIC based on the PLLOCSTATIC_ID specified					     -->
<!-- XPath: /Layout[StaticLocation(LayoutStaticLocationID=)]							 -->
<!-- The access profiles that apply to this SQL are:									 -->
<!--	IBM_Admin_LayoutStaticLocation_Update								             -->	
<!-- @param UniqueID  UniqueID of the page layout 										 -->
<!-- @param Name  Name of the layout property 											 -->
<!-- @param Value  Value of the Layout property											 -->
<!-- ================================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/Layout[StaticLocation(LayoutStaticLocationID=)]+IBM_Admin_LayoutStaticLocation_Update
	base_table=PLLOCSTATIC
	sql=
		SELECT
				PLLOCSTATIC.$COLS:PLLOCSTATIC$
		FROM
				PLLOCSTATIC
		WHERE
				PLLOCSTATIC.PLLOCSTATIC_ID IN (?LayoutStaticLocationID?)
END_XPATH_TO_SQL_STATEMENT

<!-- ==================================================================================  -->
<!-- Retrieves PLLOCSTATIC for the specified OWNER_ID. 								     -->
<!-- XPath: /Layout[StaticLocation(LayoutStaticLocationID=)]							 -->
<!-- The access profiles that apply to this SQL are:									 -->
<!--	IBM_Admin_LayoutStaticLocation_Update								             -->	
<!-- @param UniqueID  UniqueID of the page layout 										 -->
<!-- @param Name  Name of the layout property 											 -->
<!-- @param Value  Value of the Layout property											 -->
<!-- ================================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/PLLOCSTATIC[OWNER_ID=]+IBM_Admin_LayoutStaticLocation_Update
	base_table=PLLOCSTATIC
	sql=
		SELECT
				PLLOCSTATIC.$COLS:PLLOCSTATIC$
		FROM
				PLLOCSTATIC
		WHERE
				PLLOCSTATIC.OWNER_ID IN (?OWNER_ID?)
END_XPATH_TO_SQL_STATEMENT
