
<!-- ===================================================================================== -->
<!-- Selects the Page Location for the given Page Layout ID and Web Activity Id.           -->
<!-- @param layoutId The id of page layout.                                                -->
<!-- @param activityId The id of web activity.                                             -->
<!-- ===================================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Select_PageLocation_By_Layout_Id_And_Activity_Id
	base_table=PLLOCATION
	sql=	
		SELECT * FROM PLLOCATION WHERE PLLOCATION.PAGELAYOUT_ID in (?layoutId?) AND PLLOCATION.DMACTIVITY_ID in (?activityId?)
END_SQL_STATEMENT

<!-- ===================================================================================== -->
<!-- Selects the Page Design for the given Layout Activity ID.                             -->
<!-- The Page Design only includes the layout ID and name.                                 -->
<!-- @param layoutActivityId The id of layout activity.                                    -->
<!-- ===================================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Select_PageDesign_By_Layout_Activity_Id
	base_table=PAGELAYOUT
	sql=	
		SELECT PAGELAYOUT.PAGELAYOUT_ID, PAGELAYOUT.NAME, PAGELAYOUT.MEMBER_ID, PAGELAYOUT.STOREENT_ID 
	  FROM
				PAGELAYOUT
				LEFT JOIN PLLOCATION ON (PAGELAYOUT.PAGELAYOUT_ID = PLLOCATION.PAGELAYOUT_ID) 
				LEFT JOIN DMACTIVITY ON (PLLOCATION.DMACTIVITY_ID = DMACTIVITY.DMACTIVITY_ID)
	  WHERE
				DMACTIVITY.DMACTIVITY_ID = ?layoutActivityId?
END_SQL_STATEMENT

<!-- ===================================================================================== -->
<!-- Selects the Page Design for the given Layout ID.                                      -->
<!-- The Page Design only includes the layout ID and name.                                 -->
<!-- @param layoutId The id of layout.                                                     -->
<!-- ===================================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Select_PageDesign_By_Layout_Id
	base_table=PAGELAYOUT
	sql=	
		SELECT PAGELAYOUT.PAGELAYOUT_ID, PAGELAYOUT.NAME, PAGELAYOUT.MEMBER_ID, PAGELAYOUT.STOREENT_ID 
	  FROM
				PAGELAYOUT
	  WHERE
				PAGELAYOUT.PAGELAYOUT_ID = ?layoutId?
END_SQL_STATEMENT

<!-- ===================================================================================== -->
<!-- Selects the Page Layouts that are marked for delete.                                  -->
<!-- @param storeId The store id of page layout.                                           -->
<!-- ===================================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Select_MarkedForDelete_PageLayouts
	base_table=PAGELAYOUT
	sql=	
		SELECT 
		    * 
		FROM 
		    PAGELAYOUT 
		WHERE 
		    PAGELAYOUT.STOREENT_ID = ?storeId? AND 
		    PAGELAYOUT.STATE = 2 AND 
		    PAGELAYOUT.ISTEMPLATE = 0
END_SQL_STATEMENT

<!-- ===================================================================================== -->
<!-- Selects the expired Page Layouts.                                                     -->
<!-- @param expirationDate The expiration date of page layout.                             -->
<!-- @param storeId The store id of page layout.                                           -->
<!-- ===================================================================================== -->
BEGIN_SQL_STATEMENT
	base_table=PAGELAYOUT
	name=IBM_Select_Expired_PageLayouts
	dbtype=oracle
	    sql=	
		    SELECT 
		        * 
		    FROM 
		        PAGELAYOUT 
		    WHERE 
		        PAGELAYOUT.STOREENT_ID = ?storeId? AND
		        PAGELAYOUT.ENDDATE <= TO_TIMESTAMP(?expirationDate?, 'YYYY-MM-DD HH24:MI:SS.FF') AND
		        PAGELAYOUT.ISTEMPLATE = 0
	dbtype=any
	    sql=	
		    SELECT 
		        * 
		    FROM 
		        PAGELAYOUT 
		    WHERE 
		        PAGELAYOUT.STOREENT_ID = ?storeId? AND 
		        PAGELAYOUT.ENDDATE <= ?expirationDate? AND 
		        PAGELAYOUT.ISTEMPLATE = 0
END_SQL_STATEMENT

<!-- ===================================================================================== -->
<!-- Selects the Page Location for the given Page Layout ID                                -->
<!-- @param layoutId The id of page layout.                                                -->
<!-- ===================================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Select_PageLocation_By_Layout_Id
	base_table=PLLOCATION
	sql=	
		SELECT * FROM PLLOCATION WHERE PLLOCATION.PAGELAYOUT_ID IN (?layoutId?)
END_SQL_STATEMENT

<!-- ===================================================================================== -->
<!-- Selects the Widgets for the given Page Layout ID                                      -->
<!-- @param layoutId The id of page layout.                                                -->
<!-- ===================================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Select_Widget_By_Layout_Id
	base_table=PLWIDGET
	sql=	
		SELECT * FROM PLWIDGET WHERE PLWIDGET.PAGELAYOUT_ID IN (?layoutId?)
END_SQL_STATEMENT

<!-- ===================================================================================== -->
<!-- Deletes Page Layouts by given Unique IDs.                                             -->
<!-- @param layoutId The Unique IDs of Page Layouts to be deleted.                         -->
<!-- ===================================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Delete_PageLayout_By_Id
	base_table=PAGELAYOUT
	sql=	
		DELETE FROM PAGELAYOUT WHERE PAGELAYOUT_ID IN (?layoutId?)
END_SQL_STATEMENT

