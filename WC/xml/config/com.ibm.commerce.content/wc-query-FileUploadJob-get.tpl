<!--********************************************************************-->
<!--  Licensed Materials - Property of IBM                              -->
<!--                                                                    -->
<!--  WebSphere Commerce                                                -->
<!--                                                                    -->
<!--  (c) Copyright IBM Corp. 2010                                      -->
<!--                                                                    -->
<!--  US Government Users Restricted Rights - Use, duplication or       -->
<!--  disclosure restricted by GSA ADP Schedule Contract with IBM Corp. -->
<!--                                                                    -->
<!--********************************************************************-->
BEGIN_SYMBOL_DEFINITIONS
	
	<!-- The table for noun UPLOADFILE  -->
		<!-- Defining all columns of the table -->
		COLS:UPLOADFILE = UPLOADFILE:* 	
		COLS:PROCESSFILE = PROCESSFILE:* 	
		COLS:FILEPROCREL = FILEPROCREL:* 	
		
		<!-- Defining the columns of the UPLOADFILE table -->
		COLS:UPLOADFILE_ID = UPLOADFILE:UPLOADFILE_ID
		COLS:UPLOADFILE:MEMBER_ID = UPLOADFILE:MEMBER_ID
		COLS:UPLOADFILE:STORE_ID = UPLOADFILE:STORE_ID
		COLS:UPLOADFILE:OBJECTID = UPLOADFILE:OBJECTID
		COLS:UPLOADFILE:UPLOADTYPE = UPLOADFILE:UPLOADTYPE
		COLS:UPLOADFILE:PROPERTIES = UPLOADFILE:PROPERTIES
		COLS:UPLOADFILE:UPLOADTIME = UPLOADFILE:UPLOADTIME
		COLS:UPLOADFILE:FILEPATH = UPLOADFILE:FILEPATH
		COLS:UPLOADFILE:FILENAME = UPLOADFILE:FILENAME
		COLS:UPLOADFILE:FILESIZE = UPLOADFILE:FILESIZE
		COLS:UPLOADFILE:FILEENCODING = UPLOADFILE:FILEENCODING
		COLS:UPLOADFILE:FILECONTENT = UPLOADFILE:FILECONTENT
		COLS:UPLOADFILE:OPTCOUNTER = UPLOADFILE:OPTCOUNTER

		<!-- Defining the columns of the PROCESSFILE table -->
		COLS:PROCESSFILE_ID = PROCESSFILE:PROCESSFILE_ID
		COLS:PROCESSFILE:MEMBER_ID = PROCESSFILE:MEMBER_ID
		COLS:PROCESSFILE:PROPERTIES = PROCESSFILE:PROPERTIES
		COLS:PROCESSFILE:STARTTIME = PROCESSFILE:STARTTIME
		COLS:PROCESSFILE:ENDTIME = PROCESSFILE:ENDTIME
		COLS:PROCESSFILE:STATUS = PROCESSFILE:STATUS
		COLS:PROCESSFILE:PROCESSINFO = PROCESSFILE:PROCESSINFO
		COLS:PROCESSFILE:OPTCOUNTER = PROCESSFILE:OPTCOUNTER
		
		<!-- Defining the columns of the FILEPROCREL table -->		
		COLS:FILEPROCREL:UPLOADFILE_ID = FILEPROCREL:UPLOADFILE_ID
		COLS:FILEPROCREL:PROCESSFILE_ID = FILEPROCREL:PROCESSFILE_ID
		COLS:FILEPROCREL:OPTCOUNTER = FILEPROCREL:OPTCOUNTER


		
END_SYMBOL_DEFINITIONS


<!-- ================================================================================== -->
<!-- XPath: /FileUploadJob[FileUploadJobIdentifier[UniqueID=]] -->
<!-- AccessProfile:	IBM_Admin_Details, IBM_Admin_Summary, IBM_Store_Details -->
<!-- Get the information for UPLOADFILE with the specfified unique ID. -->
<!-- @param UniqueID  Unique ID of UPLOADFILE to retrieve. -->   
<!-- ================================================================================== -->

BEGIN_XPATH_TO_SQL_STATEMENT
	name=/FileUploadJob[FileUploadJobIdentifier[UniqueID=]]
	base_table=UPLOADFILE
	sql=	
		SELECT 
	     				UPLOADFILE.$COLS:UPLOADFILE_ID$
	     	FROM
	     				UPLOADFILE
	     	WHERE
						UPLOADFILE.UPLOADFILE_ID = ?UniqueID? 

END_XPATH_TO_SQL_STATEMENT





<!-- ================================================================================== -->
<!-- XPath: /FileUploadJob[NumberOfDays= and UploadType=] -->
<!-- AccessProfile:	IBM_Store_Summary, IBM_Store_Details -->
<!-- Get the information for FileUploadJob with the specified upload type. -->
<!-- @param UploadType  The type of the upload. -->   
<!-- ================================================================================== -->

BEGIN_XPATH_TO_SQL_STATEMENT
	name=/FileUploadJob[NumberOfDays= and UploadType=]
	base_table=UPLOADFILE
	className=com.ibm.commerce.requisitionlist.commands.RequisitionListUploadSQLComposer
    sql=	
		SELECT 
			UPLOADFILE.$COLS:UPLOADFILE_ID$
		FROM
	     				UPLOADFILE

	     	WHERE
						UPLOADFILE.UPLOADTYPE = ?UploadType?
						AND UPLOADFILE.MEMBER_ID = $CTX:USER_ID$ 
						AND UPLOADFILE.STORE_ID= $CTX:STORE_ID$ 
						ANDUploadDate 
				ORDER BY  UPLOADFILE.UPLOADTIME DESC 	

END_XPATH_TO_SQL_STATEMENT


<!-- ================================================================================== -->
<!-- XPath: /FileUploadJob[UploadType=] -->
<!-- AccessProfile:	IBM_Admin_Details, IBM_Admin_Summary -->
<!-- Get the information for FileUploadJob with the specified upload type. -->
<!-- @param UploadType  The type of the upload. -->   
<!-- ================================================================================== -->

BEGIN_XPATH_TO_SQL_STATEMENT
	name=/FileUploadJob[UploadType=]
	base_table=UPLOADFILE
	sql=	
		SELECT 
			UPLOADFILE.$COLS:UPLOADFILE_ID$
		FROM
	     				UPLOADFILE

	     	WHERE
						UPLOADFILE.UPLOADTYPE = ?UploadType?
						AND UPLOADFILE.STORE_ID=$CTX:STORE_ID$  
				ORDER BY  UPLOADFILE.UPLOADTIME DESC 		
						

END_XPATH_TO_SQL_STATEMENT

<!-- ================================================================================== -->
<!-- XPath: /FileUploadJob[PrompotionCodeExport] 										-->
<!-- AccessProfile:	IBM_Admin_DetailsWithPromotionCodeExportInfo						-->
<!-- Get all 'PromotionCodeExport' type job details for the store						-->
<!-- ================================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/FileUploadJob[PrompotionCodeExport]
	base_table=UPLOADFILE
	sql=	
		SELECT 
			UPLOADFILE.$COLS:UPLOADFILE_ID$
		FROM
			UPLOADFILE, PX_PROMOTION
     	WHERE
			UPLOADFILE.UPLOADTYPE = 'PromotionCodeExport' AND 
			UPLOADFILE.STORE_ID IN ($STOREPATH:promotions$) AND
			PX_PROMOTION.PX_PROMOTION_ID=INTEGER(UPLOADFILE.OBJECTID)
		ORDER BY  
			UPLOADFILE.UPLOADTIME DESC 		
			
	dbtype=oracle
	sql=	
		SELECT 
			UPLOADFILE.$COLS:UPLOADFILE_ID$
		FROM
			UPLOADFILE, PX_PROMOTION
     	WHERE
			UPLOADFILE.UPLOADTYPE = 'PromotionCodeExport' AND 
			UPLOADFILE.STORE_ID IN ($STOREPATH:promotions$) AND
			PX_PROMOTION.PX_PROMOTION_ID=TO_NUMBER(UPLOADFILE.OBJECTID)
		ORDER BY  
			UPLOADFILE.UPLOADTIME DESC 					
END_XPATH_TO_SQL_STATEMENT


<!-- ================================================================================== -->
<!-- XPath: /FileUploadJob[PrompotionCodeExport and search()]    						-->
<!-- AccessProfile:	IBM_Admin_DetailsWithPromotionCodeExportInfo						-->
<!-- Search 'PromotionCodeExport' type jobs based on export name or promotion name      -->
<!-- ================================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/FileUploadJob[PrompotionCodeExport and search()]
	base_table=UPLOADFILE
	className=com.ibm.commerce.promotion.facade.server.services.dataaccess.db.jdbc.PromotionCodeExportSearchSQLComposer
	sql=	
			SELECT 
				UPLOADFILE.$COLS:UPLOADFILE_ID$
			FROM
				UPLOADFILE, PX_PROMOTION
	     	WHERE
				UPLOADFILE.UPLOADTYPE = 'PromotionCodeExport' AND 
				UPLOADFILE.STORE_ID IN ($STOREPATH:promotions$) AND
				PX_PROMOTION.PX_PROMOTION_ID=INTEGER(UPLOADFILE.OBJECTID) AND
				$PROMOCODEEXP_FILENAME_CND$
		UNION	
			SELECT 
				UPLOADFILE.$COLS:UPLOADFILE_ID$
			FROM
				UPLOADFILE, PX_PROMOAUTH
	     	WHERE
				UPLOADFILE.UPLOADTYPE = 'PromotionCodeExport' AND 
				UPLOADFILE.STORE_ID IN ($STOREPATH:promotions$) AND
				INTEGER(UPLOADFILE.OBJECTID)=PX_PROMOAUTH.PX_PROMOTION_ID AND
				$PROMOCODEEXP_PROMOTIONNAME_CND$
				
	dbtype=oracle
	sql=	
			SELECT 
				UPLOADFILE.$COLS:UPLOADFILE_ID$
			FROM
				UPLOADFILE, PX_PROMOTION
	     	WHERE
				UPLOADFILE.UPLOADTYPE = 'PromotionCodeExport' AND 
				UPLOADFILE.STORE_ID IN ($STOREPATH:promotions$) AND
				PX_PROMOTION.PX_PROMOTION_ID=TO_NUMBER(UPLOADFILE.OBJECTID) AND
				$PROMOCODEEXP_FILENAME_CND$
		UNION	
			SELECT 
				UPLOADFILE.$COLS:UPLOADFILE_ID$
			FROM
				UPLOADFILE, PX_PROMOAUTH
	     	WHERE
				UPLOADFILE.UPLOADTYPE = 'PromotionCodeExport' AND 
				UPLOADFILE.STORE_ID IN ($STOREPATH:promotions$) AND
				TO_NUMBER(UPLOADFILE.OBJECTID)=PX_PROMOAUTH.PX_PROMOTION_ID AND
				$PROMOCODEEXP_PROMOTIONNAME_CND$	
END_XPATH_TO_SQL_STATEMENT

<!-- ================================================================================== -->
<!-- XPath: /FileUploadJob[CustomerSegmentExport] 										-->
<!-- AccessProfile:	IBM_Admin_DetailsWithCustomerSegmentExportInfo						-->
<!-- Get all 'CustomerSegmentExport' type job details for the store						-->
<!-- ================================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/FileUploadJob[CustomerSegmentExport]
	base_table=UPLOADFILE
	sql=	
		SELECT 
			UPLOADFILE.$COLS:UPLOADFILE_ID$
		FROM
			UPLOADFILE
     	WHERE
			UPLOADFILE.UPLOADTYPE = 'CustomerSegmentExport' AND
			UPLOADFILE.STORE_ID IN ($STOREPATH:content$)
		ORDER BY  
			UPLOADFILE.UPLOADTIME DESC 		
END_XPATH_TO_SQL_STATEMENT


<!-- ================================================================================== -->
<!-- XPath: /FileUploadJob[CustomerSegmentExport and search()]    						-->
<!-- AccessProfile:	IBM_Admin_DetailsWithCustomerSegmentExportInfo						-->
<!-- Search 'CustomerSegmentExport' type jobs based on export name or promotion name      -->
<!-- ================================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/FileUploadJob[CustomerSegmentExport and search()]
	base_table=UPLOADFILE
	sql=	
			SELECT 
				UPLOADFILE.$COLS:UPLOADFILE_ID$
			FROM
				UPLOADFILE
	     	WHERE
			UPLOADFILE.UPLOADTYPE = 'CustomerSegmentExport' AND
			UPLOADFILE.STORE_ID IN ($STOREPATH:content$)

END_XPATH_TO_SQL_STATEMENT

<!-- ========================================================================= -->
<!-- =============================ASSOCIATION QUERIES========================= -->
<!-- ========================================================================= -->

<!-- ============================================================ -->
<!-- This associated SQL adds upload file summary information        -->
<!-- to the resultant data graph.                                 -->
<!-- ============================================================ -->
BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_AssociatedSQL_UploadfileSummary
	base_table=UPLOADFILE
	sql=
		SELECT 
			UPLOADFILE.$COLS:UPLOADFILE_ID$,
			UPLOADFILE.$COLS:UPLOADFILE:MEMBER_ID$,
			UPLOADFILE.$COLS:UPLOADFILE:OBJECTID$,
			UPLOADFILE.$COLS:UPLOADFILE:PROPERTIES$,
			UPLOADFILE.$COLS:UPLOADFILE:UPLOADTIME$,
			UPLOADFILE.$COLS:UPLOADFILE:FILEPATH$,
			UPLOADFILE.$COLS:UPLOADFILE:FILENAME$,
			UPLOADFILE.$COLS:UPLOADFILE:FILESIZE$,
			UPLOADFILE.$COLS:UPLOADFILE:FILEENCODING$,
			UPLOADFILE.$COLS:UPLOADFILE:UPLOADTYPE$,		
			UPLOADFILE.$COLS:UPLOADFILE:STORE_ID$,
			FILEPROCREL.$COLS:FILEPROCREL$,
			PROCESSFILE.$COLS:PROCESSFILE_ID$,
			PROCESSFILE.$COLS:PROCESSFILE:STARTTIME$,
			PROCESSFILE.$COLS:PROCESSFILE:ENDTIME$,
			PROCESSFILE.$COLS:PROCESSFILE:STATUS$
			
				
		FROM
				UPLOADFILE
						LEFT OUTER JOIN FILEPROCREL ON FILEPROCREL.UPLOADFILE_ID=UPLOADFILE.UPLOADFILE_ID
						LEFT OUTER JOIN PROCESSFILE ON FILEPROCREL.PROCESSFILE_ID = PROCESSFILE.PROCESSFILE_ID
				      
				      
    WHERE
        UPLOADFILE.UPLOADFILE_ID IN ($ENTITY_PKS$)
		ORDER BY  PROCESSFILE.STARTTIME DESC    
        

END_ASSOCIATION_SQL_STATEMENT



<!-- ============================================================ -->
<!-- This associated SQL adds process file detailed information   -->
<!-- to the resultant data graph.                                 -->
<!-- ============================================================ -->
BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_AssociatedSQL_ProcessFile
	base_table=UPLOADFILE
	sql=
		SELECT 
			UPLOADFILE.$COLS:UPLOADFILE_ID$,
			UPLOADFILE.$COLS:UPLOADFILE:MEMBER_ID$,
			UPLOADFILE.$COLS:UPLOADFILE:OBJECTID$,
			UPLOADFILE.$COLS:UPLOADFILE:PROPERTIES$,
			UPLOADFILE.$COLS:UPLOADFILE:UPLOADTIME$,
			UPLOADFILE.$COLS:UPLOADFILE:FILEPATH$,
			UPLOADFILE.$COLS:UPLOADFILE:FILENAME$,
			UPLOADFILE.$COLS:UPLOADFILE:FILESIZE$,
			UPLOADFILE.$COLS:UPLOADFILE:FILEENCODING$,
			UPLOADFILE.$COLS:UPLOADFILE:UPLOADTYPE$,		
			UPLOADFILE.$COLS:UPLOADFILE:STORE_ID$,
			FILEPROCREL.$COLS:FILEPROCREL$,
			PROCESSFILE.$COLS:PROCESSFILE_ID$,
			PROCESSFILE.$COLS:PROCESSFILE:MEMBER_ID$,
			PROCESSFILE.$COLS:PROCESSFILE:PROPERTIES$,
			PROCESSFILE.$COLS:PROCESSFILE:STARTTIME$,
			PROCESSFILE.$COLS:PROCESSFILE:ENDTIME$,
			PROCESSFILE.$COLS:PROCESSFILE:STATUS$,
			PROCESSFILE.$COLS:PROCESSFILE:PROCESSINFO$
			
				
		FROM
				UPLOADFILE
						LEFT OUTER JOIN FILEPROCREL ON FILEPROCREL.UPLOADFILE_ID=UPLOADFILE.UPLOADFILE_ID
						LEFT OUTER JOIN PROCESSFILE ON FILEPROCREL.PROCESSFILE_ID = PROCESSFILE.PROCESSFILE_ID
				      
				      
    WHERE
        UPLOADFILE.UPLOADFILE_ID IN ($ENTITY_PKS$)
		ORDER BY  PROCESSFILE.STARTTIME DESC    

END_ASSOCIATION_SQL_STATEMENT


<!-- ========================================================================= -->
<!-- =============================PROFILE DEFINITIONS========================= -->
<!-- ========================================================================= -->

<!-- ========================================================= -->
<!-- The admin details Access Profile.                          -->
<!-- This profile returns the the upload file and process file detailed information -->
<!-- ========================================================= -->
BEGIN_PROFILE 
	name=IBM_Admin_Details
	BEGIN_ENTITY 
	  base_table=UPLOADFILE 
	  className=com.ibm.commerce.foundation.internal.server.services.dataaccess.graphbuilderservice.DefaultGraphComposer
      associated_sql_statement=IBM_AssociatedSQL_ProcessFile
    END_ENTITY
END_PROFILE

<!-- ========================================================= -->
<!-- The store details Access Profile.                          -->
<!-- This profile returns the the upload file and process file detailed information -->
<!-- ========================================================= -->
BEGIN_PROFILE 
	name=IBM_Store_Details
	BEGIN_ENTITY 
	  base_table=UPLOADFILE 
	  className=com.ibm.commerce.foundation.internal.server.services.dataaccess.graphbuilderservice.DefaultGraphComposer
      associated_sql_statement=IBM_AssociatedSQL_ProcessFile
    END_ENTITY
END_PROFILE


<!-- ========================================================= -->
<!-- The admin details Access Profile.                          -->
<!-- This profile returns the the upload file and process file detailed information -->
<!-- ========================================================= -->
BEGIN_PROFILE 
	name=IBM_Admin_DetailsWithPromotionCodeImportInfo
	BEGIN_ENTITY 
	  base_table=UPLOADFILE 
	  className=com.ibm.commerce.foundation.internal.server.services.dataaccess.graphbuilderservice.DefaultGraphComposer
      associated_sql_statement=IBM_AssociatedSQL_ProcessFile
    END_ENTITY
END_PROFILE

<!-- ========================================================= -->
<!-- The admin details Access Profile.                          -->
<!-- This profile returns the the upload file and process file detailed information -->
<!-- ========================================================= -->
BEGIN_PROFILE 
	name=IBM_Admin_DetailsWithPromotionCodeExportInfo
	BEGIN_ENTITY 
	  base_table=UPLOADFILE 
	  className=com.ibm.commerce.foundation.internal.server.services.dataaccess.graphbuilderservice.DefaultGraphComposer
      associated_sql_statement=IBM_AssociatedSQL_ProcessFile
    END_ENTITY
END_PROFILE

<!-- ========================================================= -->
<!-- The admin details Access Profile.                          -->
<!-- This profile returns the the upload file and process file detailed information -->
<!-- ========================================================= -->
BEGIN_PROFILE 
	name=IBM_Admin_DetailsWithCustomerSegmentExportInfo
	BEGIN_ENTITY 
	  base_table=UPLOADFILE 
	  className=com.ibm.commerce.foundation.internal.server.services.dataaccess.graphbuilderservice.DefaultGraphComposer
      associated_sql_statement=IBM_AssociatedSQL_ProcessFile
    END_ENTITY
END_PROFILE


<!-- ========================================================= -->
<!-- The admin summary Access Profile.                          -->
<!-- This profile returns the the upload file summary information -->
<!-- ========================================================= -->
BEGIN_PROFILE 
	name=IBM_Admin_Summary
	BEGIN_ENTITY 
	  base_table=UPLOADFILE 
	  className=com.ibm.commerce.foundation.internal.server.services.dataaccess.graphbuilderservice.DefaultGraphComposer
      associated_sql_statement=IBM_AssociatedSQL_UploadfileSummary
    END_ENTITY
END_PROFILE

<!-- ========================================================= -->
<!-- The admin summary Access Profile.                          -->
<!-- This profile returns the the upload file summary information -->
<!-- ========================================================= -->
BEGIN_PROFILE 
	name=IBM_Store_Summary
	BEGIN_ENTITY 
	  base_table=UPLOADFILE 
	  className=com.ibm.commerce.foundation.internal.server.services.dataaccess.graphbuilderservice.DefaultGraphComposer
      associated_sql_statement=IBM_AssociatedSQL_UploadfileSummary
    END_ENTITY
END_PROFILE


<!-- ========================================================================= -->
<!--  Get the UploadFiles(s) by specific OBJECTID and UPLOADTYPE               -->
<!--                                                                           -->
<!--  @param ObjectId                                                          -->
<!--     The object identifier(s) for which to retrieve the Uploadfiles        -->
<!--  @param UploadType                                                        -->
<!--     The type for which to retrieve the Uploadfiles                        -->
<!--  @param STOREPATH:content                                                -->
<!--     The stores for which to retrieve the Uploadfiles. This parameter is   -->
<!--     retrieved from within the business context.                           -->
<!--===========================================================================-->

BEGIN_XPATH_TO_SQL_STATEMENT
  name=/FileUploadJob[UploadFile[(ObjectId=)] and (UploadType=)]+IBM_Admin_All
  base_table=UPLOADFILE
  sql=
    SELECT 
        UPLOADFILE.$COLS:UPLOADFILE_ID$, 
		UPLOADFILE.$COLS:UPLOADFILE:MEMBER_ID$,		
		UPLOADFILE.$COLS:UPLOADFILE:OBJECTID$,
		UPLOADFILE.$COLS:UPLOADFILE:UPLOADTYPE$,
		UPLOADFILE.$COLS:UPLOADFILE:PROPERTIES$,
		UPLOADFILE.$COLS:UPLOADFILE:UPLOADTIME$,
		UPLOADFILE.$COLS:UPLOADFILE:FILEPATH$,
		UPLOADFILE.$COLS:UPLOADFILE:FILENAME$,
		UPLOADFILE.$COLS:UPLOADFILE:FILESIZE$,
		UPLOADFILE.$COLS:UPLOADFILE:FILEENCODING$,
		UPLOADFILE.$COLS:UPLOADFILE:STORE_ID$
    FROM
        UPLOADFILE 
    WHERE
        UPLOADFILE.OBJECTID IN (?ObjectId?)
        AND UPLOADFILE.UPLOADTYPE IN (?UploadType?)
        AND UPLOADFILE.STORE_ID IN ($STOREPATH:content$)
END_XPATH_TO_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Get the UploadFiles(s) by specific UPLOADTYPE and that matches           -->
<!--  the specified search criteria                                            -->
<!--                                                                           -->
<!--  @param UploadType                                                        -->
<!--     The type for which to retrieve the Uploadfiles.                       -->
<!--  @param ATTR_CNDS                                                         -->
<!--     The search criteria.                                                  -->
<!--  @param STOREPATH:content                                                 -->
<!--     The stores for which to retrieve the Uploadfiles. This parameter is   -->
<!--     retrieved from within the business context.                           -->
<!--===========================================================================-->

BEGIN_XPATH_TO_SQL_STATEMENT
  name=/FileUploadJob[UploadType= and search()]
  base_table=UPLOADFILE
  sql=
    SELECT 
        UPLOADFILE.$COLS:UPLOADFILE_ID$ 
    FROM
        UPLOADFILE, $ATTR_TBLS$ 
    WHERE
        UPLOADFILE.UPLOADTYPE IN (?UploadType?)
        AND UPLOADFILE.STORE_ID IN ($STOREPATH:content$)
		AND UPLOADFILE.$ATTR_CNDS$
END_XPATH_TO_SQL_STATEMENT

