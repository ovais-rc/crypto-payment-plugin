BEGIN_SYMBOL_DEFINITIONS


	<!-- CATENTRY table -->
	COLS:CATENTRY=CATENTRY:*
	COLS:CATENTRY_ID=CATENTRY:CATENTRY_ID
	COLS:CATENTRY:PARTNUMBER=CATENTRY:PARTNUMBER
	COLS:CATENTRY:MEMBER_ID=CATENTRY:MEMBER_ID
	COLS:CATENTRY:CATENTTYPE_ID=CATENTRY:CATENTTYPE_ID


	<!-- CATALOG table -->
	COLS:CATALOG=CATALOG:*
	COLS:CATALOG_ID=CATALOG:CATALOG_ID

	<!-- CATGROUP table -->
	COLS:CATGROUP=CATGROUP:*
	COLS:CATGROUP_ID=CATGROUP:CATGROUP_ID
	COLS:CATGROUP:IDENTIFIER=CATGROUP:IDENTIFIER
	COLS:CATGROUP:MEMBER_ID=CATGROUP:MEMBER_ID


	<!-- STORECAT table -->
	COLS:STORECAT=STORECAT:*


	<!-- STORECGRP table -->
	COLS:STORECGRP=STORECGRP:*
	COLS:STORECGRP:STOREENT_ID=STORECGRP:STOREENT_ID
	COLS:STORECGRP:CATGROUP_ID=STORECGRP:CATGROUP_ID


	<!-- Other tables -->
	COLS:ATTRIBUTE=ATTRIBUTE:*
	COLS:ATTRVALUE=ATTRVALUE:*

	COLS:STORECENT=STORECENT:*

	<!-- CATENTDESC table -->
	COLS:CATENTDESC=CATENTDESC:*
	COLS:CATENTDESC:CATENTRY_ID=CATENTDESC:CATENTRY_ID
	COLS:CATENTDESC:LANGUAGE_ID=CATENTDESC:LANGUAGE_ID
	COLS:CATENTDESC:NAME=CATENTDESC:NAME

	COLS:CATENTREL=CATENTREL:*
	COLS:CATENTATTR=CATENTATTR:*
	COLS:CATENTSHIP=CATENTSHIP:*

	<!-- CATGPENREL table -->
	COLS:CATGPENREL=CATGPENREL:*
	COLS:CATGPENREL:CATENTRY_ID=CATGPENREL:CATENTRY_ID
	COLS:CATGPENREL:SEQUENCE=CATGPENREL:SEQUENCE
	COLS:CATGPENREL:CATGROUP_ID=CATGPENREL:CATGROUP_ID

	COLS:CATCLSFCOD=CATCLSFCOD:*
	COLS:CATCONFINF=CATCONFINF:*
	COLS:CATENCALCD=CATENCALCD:*
	COLS:DKPDCCATENTREL=DKPDCCATENTREL:*
	COLS:DKPDCCOMPLIST=DKPDCCOMPLIST:*
	COLS:DKPDCREL=DKPDCREL:*
	COLS:DISPENTREL=DISPENTREL:*
	COLS:CATENTTYPE=CATENTTYPE:*
	COLS:LISTPRICE=LISTPRICE:*
	COLS:BASEITEM=BASEITEM:*
	COLS:OFFER=OFFER:*
	COLS:ITEMSPC=ITEMSPC:*
	COLS:MASSOCCECE=MASSOCCECE:*

	COLS:CATALOGDSC=CATALOGDSC:*
	COLS:CATTOGRP=CATTOGRP:*
	COLS:CATTOGRP:CATGROUP_ID=CATTOGRP:CATGROUP_ID

	<!-- CATGRPREL Table -->
	COLS:CATGRPREL=CATGRPREL:*
	COLS:CATGROUP_ID_PARENT=CATGRPREL:CATGROUP_ID_PARENT
	COLS:CATGROUP_ID_CHILD=CATGRPREL:CATGROUP_ID_CHILD
	COLS:CATGRPREL:SEQUENCE=CATGRPREL:SEQUENCE

	COLS:CATCNTR=CATCNTR:*
	COLS:CATGRPTPC=CATGRPTPC:*
	COLS:CATGRPPS=CATGRPPS:*

	COLS:CATGPCALCD=CATGPCALCD:*
	COLS:CATGRPATTR=CATGRPATTR:*

	<!-- CATGRPDESC Table -->
	COLS:CATGRPDESC=CATGRPDESC:*
	COLS:CATGRPDESC:NAME=CATGRPDESC:NAME
	COLS:CATGRPDESC:CATGROUP_ID=CATGRPDESC:CATGROUP_ID
	COLS:CATGRPDESC:LANGUAGE_ID=CATGRPDESC:LANGUAGE_ID
	COLS:CATGRPDESC:SHORTDESCRIPTION=CATGRPDESC:SHORTDESCRIPTION
	COLS:CATGRPDESC:THUMBNAIL=CATGRPDESC:THUMBNAIL

	COLS:MASSOCGPGP=MASSOCGPGP:*
	COLS:MASSOC=MASSOC:*
	COLS:MASSOCTYPE=MASSOCTYPE:*
	COLS:ITEMVERSN=ITEMVERSN:*
	COLS:VERSIONSPC=VERSIONSPC:*
	COLS:ITEMTYPE=ITEMTYPE:*
	COLS:BASEITMDSC=BASEITMDSC:*

	<!-- ATTRDICT table -->
	COLS:ATTRDICT=ATTRDICT:*


	<!-- ATTRDICTGRPMBR table -->
	<!-- COLS:ATTRDICTGRPMBR=ATTRDICTGRPMBR:* -->


	<!-- ATCHREL table -->
	COLS:ATCHREL=ATCHREL:*
	COLS:ATCHREL:ATCHTGT_ID=ATCHREL:ATCHTGT_ID
	COLS:ATCHREL:SEQUENCE=ATCHREL:SEQUENCE

	<!-- ATCHRLUS table -->
	COLS:ATCHRLUS=ATCHRLUS:*
	COLS:ATCHRLUS:IDENTIFIER=ATCHRLUS:IDENTIFIER

	<!-- ATCHRELDSC table -->
	COLS:ATCHRELDSC=ATCHRELDSC:*
	COLS:ATCHRELDSC:NAME=ATCHRELDSC:NAME
	COLS:ATCHRELDSC:SHORTDESCRIPTION=ATCHRELDSC:SHORTDESCRIPTION
	COLS:ATCHRELDSC:LONGDESCRIPTION=ATCHRELDSC:LONGDESCRIPTION


	<!-- CALCODE table -->
	COLS:CALCODE=CALCODE:*
  <!-- Catalog group rule tables -->
	COLS:CATGRPRULE=CATGRPRULE:*

  <!-- CATGROUP_EXTERNAL_CONTENT_REL table -->
  COLS:CATGROUP_EXTERNAL_CONTENT_REL=CATGROUP_EXTERNAL_CONTENT_REL:*

 COLS:CATGROUP_EXTERNAL_CONTENT_REL:CG_EXTERNAL_CONTENT_REL_ID=CATGROUP_EXTERNAL_CONTENT_REL:CG_EXTERNAL_CONTENT_REL_ID
 COLS:CATGROUP_EXTERNAL_CONTENT_REL:CATGROUP_ID=CATGROUP_EXTERNAL_CONTENT_REL:CATGROUP_ID
 COLS:CATGROUP_EXTERNAL_CONTENT_REL:CATOVRGRP_ID=CATGROUP_EXTERNAL_CONTENT_REL:CATOVRGRP_ID
 COLS:CATGROUP_EXTERNAL_CONTENT_REL:LANGUAGE_ID=CATGROUP_EXTERNAL_CONTENT_REL:LANGUAGE_ID
 COLS:CATGROUP_EXTERNAL_CONTENT_REL:CONTENT_ID=CATGROUP_EXTERNAL_CONTENT_REL:CONTENT_ID
 COLS:CATGROUP_EXTERNAL_CONTENT_REL:TYPE=CATGROUP_EXTERNAL_CONTENT_REL:TYPE
 COLS:CATGROUP_EXTERNAL_CONTENT_REL:FIELD1=CATGROUP_EXTERNAL_CONTENT_REL:FIELD1
 COLS:CATGROUP_EXTERNAL_CONTENT_REL:FIELD2=CATGROUP_EXTERNAL_CONTENT_REL:FIELD2
 COLS:CATGROUP_EXTERNAL_CONTENT_REL:FIELD3=CATGROUP_EXTERNAL_CONTENT_REL:FIELD3
 COLS:CATGROUP_EXTERNAL_CONTENT_REL:OPTCOUNTER=CATGROUP_EXTERNAL_CONTENT_REL:OPTCOUNTER


  <!-- EXTERNAL_CONTENT table -->
  COLS:EXTERNAL_CONTENT=EXTERNAL_CONTENT:*

  <!-- EXTERNAL_CONTENT_ASSET table -->
  COLS:EXTERNAL_CONTENT_ASSET=EXTERNAL_CONTENT_ASSET:*

END_SYMBOL_DEFINITIONS


<!-- ===================================================================================== -->
<!-- ================================ GET CATGROUP BEGINS ================================ -->
<!-- ===================================================================================== -->


<!-- ========================================================================= -->
<!-- =============================SUB SELECT QUERIES========================== -->
<!-- ========================================================================= -->

<!-- ============================================================= -->
<!-- This SQL will return the elements of the Top Catalog Group    -->
<!-- noun(s) under the catalog.                                    -->
<!-- The access profiles that apply to this SQL are:               -->
<!-- IBM_Admin_Details, IBM_Admin_Summary, IBM_Admin_All and all other catalog group -->
<!-- profiles.				                                       -->
<!-- @param Context:CatalogID - The catalog for which to retrieve  -->
<!--        the catalog group. This parameter is retrieved from    -->
<!--	    within the business context.           	               -->
<!-- ============================================================= -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogGroup[@topCatalogGroup=]
	base_table=CATGROUP
	sql=

            SELECT
              		CATGROUP_ID_1,
              		SEQUENCE
			FROM (
					SELECT
		     				CATTOGRP.$COLS:CATTOGRP:CATGROUP_ID$ CATGROUP_ID_1,
		     				CATTOGRP.SEQUENCE SEQUENCE
		     		FROM
		     				CATTOGRP
			     	WHERE
                            CATTOGRP.CATALOG_ID = $CTX:CATALOG_ID$
			) T1
			WHERE EXISTS (
			  SELECT 1 FROM STORECGRP, CATGROUP
			  WHERE CATGROUP_ID_1 = STORECGRP.CATGROUP_ID
			  AND STORECGRP.STOREENT_ID IN ( $STOREPATH:catalog$ )
			  AND CATGROUP.CATGROUP_ID = STORECGRP.CATGROUP_ID
			  AND CATGROUP.MARKFORDELETE = 0
			  AND 'true' like (?topCatalogGroup?)
			  )
			ORDER BY
				SEQUENCE

END_XPATH_TO_SQL_STATEMENT


<!-- ============================================================= -->
<!-- This SQL will return the elements of the Catalog Group noun   -->
<!-- given the specified unique identifier.                        -->
<!-- Multiple results are returned if multiple identifiers are     -->
<!-- specified.	                                                   -->
<!-- The access profiles that apply to this SQL are:               -->
<!-- IBM_Admin_Details, IBM_Admin_Summary, IBM_Admin_All and all other catalog group -->
<!-- profiles.				                                       -->
<!-- @param UniqueID - The identifier(s) for which to retrieve     -->
<!-- @param Context:StoreID - The store for which to retrieve the  -->
<!--        catalog group. This parameter is retrieved from within -->
<!--	    the business context.           	                   -->
<!-- ============================================================= -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogGroup[CatalogGroupIdentifier[(UniqueID=)]]
	base_table=CATGROUP
	sql=

            SELECT
              		CATGROUP_ID_1
			FROM (
					SELECT
		     				CATGROUP.$COLS:CATGROUP_ID$ CATGROUP_ID_1
		     		FROM
		     				CATGROUP
			     	WHERE
                            CATGROUP.CATGROUP_ID IN (?UniqueID?)
                             AND CATGROUP.MARKFORDELETE = 0
			) T1
			WHERE EXISTS (
			  SELECT 1 FROM STORECGRP
			  WHERE CATGROUP_ID_1 = STORECGRP.CATGROUP_ID
			  AND STORECGRP.STOREENT_ID IN ( $STOREPATH:catalog$ )
			  )


END_XPATH_TO_SQL_STATEMENT

<!-- ============================================================= -->
<!-- This SQL will return the elements of the Catalog Group noun   -->
<!-- given the specified unique identifier.                        -->
<!-- Multiple results are returned if multiple identifiers are     -->
<!-- specified.	                                                   -->
<!-- The access profiles that apply to this SQL are:               -->
<!-- IBM_Admin_Details, IBM_Admin_Summary, IBM_Admin_All and all other catalog group -->
<!-- profiles.				                                       -->
<!-- @param UniqueID - The identifier(s) for which to retrieve     -->
<!-- @param Context:StoreID - The store for which to retrieve the  -->
<!--        catalog group. This parameter is retrieved from within -->
<!--	    the business context.           	                   -->
<!-- ============================================================= -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogGroup[CatalogGroupIdentifier[UniqueID=]]
	base_table=CATGROUP
	sql=
            SELECT
              		CATGROUP_ID_1
			FROM (
					SELECT
		     				CATGROUP.$COLS:CATGROUP_ID$ CATGROUP_ID_1
		     		FROM
		     				CATGROUP
			     	WHERE
                            CATGROUP.CATGROUP_ID IN (?UniqueID?)
                             AND CATGROUP.MARKFORDELETE = 0
			) T1
			WHERE EXISTS (
			  SELECT 1 FROM STORECGRP
			  WHERE CATGROUP_ID_1 = STORECGRP.CATGROUP_ID
			  AND STORECGRP.STOREENT_ID IN ( $STOREPATH:catalog$ )
			  )


END_XPATH_TO_SQL_STATEMENT

<!-- ============================================================= -->
<!-- This SQL will return the elements of the Catalog Group noun   -->
<!-- given the specified identifier.                               -->
<!-- Multiple results are returned if multiple identifiers are     -->
<!-- specified.	                                                   -->
<!-- The access profiles that apply to this SQL are:               -->
<!-- IBM_Admin_Details, IBM_Admin_Summary, IBM_Admin_All and all other catalog group -->
<!-- profiles.				                                       -->
<!-- @param GroupIdentifier - The identifier(s) for which to       -->
<!--        retrieve.                                              -->
<!-- @param Context:StoreID - The store for which to retrieve the  -->
<!--        catalog group. This parameter is retrieved from within -->
<!--	    the business context.           	                   -->
<!-- ============================================================= -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogGroup[CatalogGroupIdentifier[ExternalIdentifier[(GroupIdentifier=)]]]
	base_table=CATGROUP
	sql=

              SELECT
              				CATGROUP.$COLS:CATGROUP_ID$
              FROM
                            CATGROUP
                             JOIN
                            STORECGRP ON
                            	(CATGROUP.CATGROUP_ID = STORECGRP.CATGROUP_ID AND
                            	 STORECGRP.STOREENT_ID IN ($STOREPATH:catalog$))
              WHERE
                            CATGROUP.IDENTIFIER IN (?GroupIdentifier?) AND
                            CATGROUP.MARKFORDELETE = 0

END_XPATH_TO_SQL_STATEMENT


<!-- ============================================================= -->
<!-- This SQL will return the elements of the Catalog Group noun   -->
<!-- given the specified identifier and member id.                 -->
<!-- Multiple results are returned if multiple input params are    -->
<!-- specified.	                                                   -->
<!-- The access profiles that apply to this SQL are:               -->
<!-- IBM_Admin_Details, IBM_Admin_Summary, IBM_Admin_All and all other catalog group -->
<!-- profiles.				                                       -->
<!-- @param GroupIdentifier - The identifier(s) for which to       -->
<!--        retrieve.                                              -->
<!-- @param ownerID -    The owner Id(s) for which to retrieve.    -->
<!-- @param Context:StoreID - The store for which to retrieve the  -->
<!--        catalog group. This parameter is retrieved from within -->
<!--	    the business context.           	                   -->
<!-- ============================================================= -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogGroup[CatalogGroupIdentifier[ExternalIdentifier[(@ownerID= and GroupIdentifier=)]]]
	base_table=CATGROUP
	sql=

              SELECT
              				CATGROUP.$COLS:CATGROUP_ID$
              FROM
                            CATGROUP
                             JOIN
                            STORECGRP ON
                            	(CATGROUP.CATGROUP_ID = STORECGRP.CATGROUP_ID AND
                            	 STORECGRP.STOREENT_ID IN ($STOREPATH:catalog$))
              WHERE
                            CATGROUP.IDENTIFIER = ?GroupIdentifier? AND
                            CATGROUP.MEMBER_ID = ?ownerID? AND
                            CATGROUP.MARKFORDELETE = 0

END_XPATH_TO_SQL_STATEMENT


<!-- ============================================================= -->
<!-- This SQL will return the elements of the Catalog Group        -->
<!-- noun(s) given the specified parent catalog group unique       -->
<!-- identifier.                                                   -->
<!-- Multiple results are returned if multiple identifiers are     -->
<!-- specified.	                                                   -->
<!-- The access profiles that apply to this SQL are:               -->
<!-- IBM_Admin_Details, IBM_Admin_Summary, IBM_Admin_All and all other catalog group -->
<!-- profiles.				                                       -->
<!-- @param UniqueID - The identifier(s) for which to retrieve.    -->
<!-- @param Context:StoreID - The store for which to retrieve the  -->
<!--        catalog group. This parameter is retrieved from within -->
<!--	    the business context.           	                   -->
<!-- @param Context:CatalogID - The catalog for which to retrieve  -->
<!--        the catalog group. This parameter is retrieved from    -->
<!--	    within the business context.           	               -->
<!-- ============================================================= -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogGroup[ParentCatalogGroupIdentifier[(UniqueID=)]]
	base_table=CATGROUP
	sql=

		SELECT CATGROUP_ID_1
		FROM (

				SELECT
	     				CATGRPREL.CATGROUP_ID_CHILD CATGROUP_ID_1,
	     				CATGRPREL.SEQUENCE SEQUENCE
		     	FROM
	     				CATGRPREL
		     	WHERE
						CATGRPREL.CATGROUP_ID_PARENT IN (?UniqueID?) AND
						CATGRPREL.CATALOG_ID = ($CTX:CATALOG_ID$)
			) T1
			WHERE EXISTS (
			  SELECT 1 FROM CATGROUP, STORECGRP
			  WHERE CATGROUP_ID_1 = CATGROUP.CATGROUP_ID AND
			  CATGROUP.MARKFORDELETE = 0 AND
			  STORECGRP.CATGROUP_ID = CATGROUP.CATGROUP_ID AND
			  STORECGRP.STOREENT_ID IN ( $STOREPATH:catalog$ )
			  )
			ORDER BY
				SEQUENCE

END_XPATH_TO_SQL_STATEMENT


<!-- ============================================================= -->
<!-- This SQL will return the elements of the Catalog Group        -->
<!-- noun(s) given the specified parent catalog group identifier.  -->
<!-- Multiple results are returned if multiple identifiers are     -->
<!-- specified.	                                                   -->
<!-- The access profiles that apply to this SQL are:               -->
<!-- IBM_Admin_Details, IBM_Admin_Summary, IBM_Admin_All and all other catalog group -->
<!-- profiles.				                                       -->
<!-- @param GroupIdentifier - The identifier(s) for which to       -->
<!--        retrieve.                                              -->
<!-- @param Context:StoreID - The store for which to retrieve the  -->
<!--        catalog group. This parameter is retrieved from within -->
<!--	    the business context.           	                   -->
<!-- @param Context:CatalogID - The catalog for which to retrieve  -->
<!--        the catalog group. This parameter is retrieved from    -->
<!--	    within the business context.           	               -->
<!-- ============================================================= -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogGroup[ParentCatalogGroupIdentifier[ExternalIdentifier[(GroupIdentifier=)]]]
	base_table=CATGROUP
	sql=

              SELECT
              				CATGROUP.$COLS:CATGROUP_ID$
              FROM
                            CATGROUP
                             JOIN
                            CATGRPREL ON
                            	(CATGROUP.CATGROUP_ID = CATGRPREL.CATGROUP_ID_CHILD AND
                            	 CATGRPREL.CATALOG_ID = $CTX:CATALOG_ID$)
                             JOIN
                            STORECGRP ON
                            	(CATGROUP.CATGROUP_ID = STORECGRP.CATGROUP_ID AND
                            	 STORECGRP.STOREENT_ID IN ($STOREPATH:catalog$))
                             JOIN
                            CATGROUP CATGROUP2 ON
                            	(CATGROUP2.CATGROUP_ID = CATGRPREL.CATGROUP_ID_PARENT AND
                            	 CATGROUP2.IDENTIFIER IN (?GroupIdentifier?) AND
                            	 CATGROUP2.MARKFORDELETE = 0)
              WHERE
                            CATGROUP.MARKFORDELETE = 0
              ORDER BY
              				CATGRPREL.SEQUENCE

END_XPATH_TO_SQL_STATEMENT


<!-- ============================================================= -->
<!-- This SQL will return the elements of the Catalog Group        -->
<!-- noun(s) given the specified child catalog entry unique        -->
<!-- identifier.                                                   -->
<!-- Multiple results are returned if multiple identifiers are     -->
<!-- specified.	                                                   -->
<!-- The access profiles that apply to this SQL are:               -->
<!-- IBM_Admin_Details, IBM_Admin_Summary, IBM_Admin_All and all other catalog group -->
<!-- profiles.				                                       -->
<!-- @param UniqueID - The identifier(s) for which to retrieve.    -->
<!-- @param type - The type of relationship for which to retrieve. -->
<!--        Should always be 'child'.                              -->
<!-- @param Context:StoreID - The store for which to retrieve the  -->
<!--        catalog group. This parameter is retrieved from within -->
<!--	    the business context.           	                   -->
<!-- @param Context:CatalogID - The catalog for which to retrieve  -->
<!--        the catalog group. This parameter is retrieved from    -->
<!--	    within the business context.           	               -->
<!-- ============================================================= -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogGroup[NavigationRelationship[CatalogEntryReference[CatalogEntryIdentifier[(UniqueID= and type=)]]]]
	base_table=CATGROUP
	sql=

              SELECT
              		   CATGROUP.$COLS:CATGROUP_ID$
              FROM
			    	   CATGPENREL
                        JOIN
                       CATGROUP ON
                       		(CATGROUP.CATGROUP_ID = CATGPENREL.CATGROUP_ID AND
                             CATGPENREL.CATALOG_ID = $CTX:CATALOG_ID$)
                        JOIN
                       STORECGRP ON
                            	(CATGROUP.CATGROUP_ID = STORECGRP.CATGROUP_ID AND
                            	 STORECGRP.STOREENT_ID IN ($STOREPATH:catalog$))
              WHERE
                       CATGPENREL.CATENTRY_ID IN (?UniqueID?) AND
		        	   CATGROUP.MARKFORDELETE = 0 AND
		        	   ?type? = 'child'

END_XPATH_TO_SQL_STATEMENT


<!-- ============================================================= -->
<!-- This SQL will return the elements of the Catalog Group        -->
<!-- noun(s) given the specified child catalog entry part          -->
<!-- number.                                                       -->
<!-- Multiple results are returned if multiple identifiers are     -->
<!-- specified.	                                                   -->
<!-- The access profiles that apply to this SQL are:               -->
<!-- IBM_Admin_Details, IBM_Admin_Summary, IBM_Admin_All and all other catalog group -->
<!-- profiles.				                                       -->
<!-- @param PartNumber - The part num(s) for which to retrieve.    -->
<!-- @param type - The type of relationship for which to retrieve. -->
<!--        Should always be 'child'.                              -->
<!-- @param Context:StoreID - The store for which to retrieve the  -->
<!--        catalog group. This parameter is retrieved from within -->
<!--	    the business context.           	                   -->
<!-- @param Context:CatalogID - The catalog for which to retrieve  -->
<!--        the catalog group. This parameter is retrieved from    -->
<!--	    within the business context.           	               -->
<!-- ============================================================= -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogGroup[NavigationRelationship[CatalogEntryReference[CatalogEntryIdentifier[ExternalIdentifier[(PartNumber= and type=)]]]]]
	base_table=CATGROUP
	sql=

              SELECT
              		   CATGROUP.$COLS:CATGROUP_ID$
              FROM
			    	   CATGPENREL
                        JOIN
                       CATGROUP ON
                       		(CATGROUP.CATGROUP_ID = CATGPENREL.CATGROUP_ID AND
                             CATGPENREL.CATALOG_ID = $CTX:CATALOG_ID$)
                        JOIN
                       STORECGRP ON
                            (CATGROUP.CATGROUP_ID = STORECGRP.CATGROUP_ID AND
                             STORECGRP.STOREENT_ID IN ($STOREPATH:catalog$))
                        JOIN
                       CATENTRY ON
                       		(CATGPENREL.CATENTRY_ID = CATENTRY.CATENTRY_ID AND
                       		 CATENTRY.PARTNUMBER IN (?PartNumber?) AND
                       		 CATENTRY.MARKFORDELETE = 0)
              WHERE
		        	   CATGROUP.MARKFORDELETE = 0 AND
		        	   ?type? = 'child'

END_XPATH_TO_SQL_STATEMENT


<!-- ============================================================= -->
<!-- This SQL will return the elements of the Catalog Group        -->
<!-- noun(s) given the specified child catalog group unique        -->
<!-- identifier.                                                   -->
<!-- Multiple results are returned if multiple identifiers are     -->
<!-- specified.	                                                   -->
<!-- The access profiles that apply to this SQL are:               -->
<!-- IBM_Admin_Details, IBM_Admin_Summary, IBM_Admin_All and all other catalog group -->
<!-- profiles.				                                       -->
<!-- @param UniqueID - The identifier(s) for which to retrieve.    -->
<!-- @param type - The type of relationship for which to retrieve. -->
<!--        Should always be 'child'.                              -->
<!-- @param Context:StoreID - The store for which to retrieve the  -->
<!--        catalog group. This parameter is retrieved from within -->
<!--	    the business context.           	                   -->
<!-- @param Context:CatalogID - The catalog for which to retrieve  -->
<!--        the catalog group. This parameter is retrieved from    -->
<!--	    within the business context.           	               -->
<!-- ============================================================= -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogGroup[NavigationRelationship[CatalogGroupReference[CatalogGroupIdentifier[(UniqueID= and type=)]]]]
	base_table=CATGROUP
	sql=

              SELECT
              				CATGROUP.$COLS:CATGROUP_ID$
              FROM
                            CATGROUP
                             JOIN
                            CATGRPREL ON
                            	(CATGROUP.CATGROUP_ID = CATGRPREL.CATGROUP_ID_PARENT AND
			   			 	     CATGRPREL.CATALOG_ID = $CTX:CATALOG_ID$)
			   			 	 JOIN
                            STORECGRP ON
                            	(CATGROUP.CATGROUP_ID = STORECGRP.CATGROUP_ID AND
                            	 STORECGRP.STOREENT_ID IN ($STOREPATH:catalog$))
              WHERE
                            CATGRPREL.CATGROUP_ID_CHILD IN (?UniqueID?) AND
		                	CATGROUP.MARKFORDELETE = 0 AND
		                	?type? = 'child'

END_XPATH_TO_SQL_STATEMENT


<!-- ============================================================= -->
<!-- This SQL will return the elements of the Catalog Group        -->
<!-- noun(s) given the specified child catalog group identifier.   -->
<!-- Multiple results are returned if multiple identifiers are     -->
<!-- specified.	                                                   -->
<!-- The access profiles that apply to this SQL are:               -->
<!-- IBM_Admin_Details, IBM_Admin_Summary, IBM_Admin_All and all other catalog group -->
<!-- profiles.				                                       -->
<!-- @param GroupIdentifier - The identifier(s) for which to       -->
<!--        retrieve.                                              -->
<!-- @param type - The type of relationship for which to retrieve. -->
<!--        Should always be 'child'.                              -->
<!-- @param Context:StoreID - The store for which to retrieve the  -->
<!--        catalog group. This parameter is retrieved from within -->
<!--	    the business context.           	                   -->
<!-- @param Context:CatalogID - The catalog for which to retrieve  -->
<!--        the catalog group. This parameter is retrieved from    -->
<!--	    within the business context.           	               -->
<!-- ============================================================= -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogGroup[NavigationRelationship[CatalogGroupReference[CatalogGroupIdentifier[ExternalIdentifier[(GroupIdentifier= and type=)]]]]]
	base_table=CATGROUP
	sql=

              SELECT
              				CATGROUP.$COLS:CATGROUP_ID$
              FROM
                            CATGROUP
                             JOIN
                            CATGRPREL ON
                            	(CATGROUP.CATGROUP_ID = CATGRPREL.CATGROUP_ID_PARENT AND
			   			 	     CATGRPREL.CATALOG_ID = $CTX:CATALOG_ID$)
			   			 	 JOIN
                            STORECGRP ON
                            	(CATGROUP.CATGROUP_ID = STORECGRP.CATGROUP_ID AND
                            	 STORECGRP.STOREENT_ID IN ($STOREPATH:catalog$))
                             JOIN
                            CATGROUP CATGROUP2 ON
                            	(CATGRPREL.CATGROUP_ID_CHILD = CATGROUP2.CATGROUP_ID AND
                            	 CATGROUP2.IDENTIFIER IN (?GroupIdentifier?) AND
                            	 CATGROUP2.MARKFORDELETE = 0)
              WHERE
		                	CATGROUP.MARKFORDELETE = 0 AND
		                	?type? = 'child'

END_XPATH_TO_SQL_STATEMENT

<!-- ================================================================== -->
<!-- This SQL will return the elements of the Catalog Group noun(s)     -->
<!-- given the specified search criteria                                -->
<!-- The access profiles that apply to this SQL are:                    -->
<!-- @param Context:StoreID - The store for which to retrieve the       -->
<!--        catalog entry. This parameter is retrieved from within      -->
<!--	    the business context.           	                        -->
<!-- @param Context:CatalogID - The catalog for which to retrieve       -->
<!--        the catalog group. This parameter is retrieved from         -->
<!--	    within the business context.           	                -->
<!-- @param Description/Name - The name of the catalog entry            -->
<!-- @param CatalogGroupIdentifier/ExternalIdentifier/GroupIdentifier   -->
<!--        - The part number of the catalog group identifier           -->
<!-- @param Description/Name                                            -->
<!--        - The descriptive name of the catalog group                 -->
<!-- ================================================================== -->

BEGIN_XPATH_TO_SQL_STATEMENT
    name=/CatalogGroup[search(starts-with(CatalogGroupIdentifier/ExternalIdentifier/GroupIdentifier,) or starts-with(Description/Name,))]
	base_table=CATGROUP
	className=com.ibm.commerce.foundation.server.services.dataaccess.db.jdbc.VarcharParametersTrimProcessor
	param=Description/Name:254
	param=CatalogGroupIdentifier/ExternalIdentifier/GroupIdentifier:254

        dbtype=any
	sql=
	      SELECT
              	  DISTINCT CATGROUP.$COLS:CATGROUP_ID$
              FROM
                  CATGROUP
                     JOIN
                  STORECGRP ON
                     (CATGROUP.CATGROUP_ID = STORECGRP.CATGROUP_ID AND
                      STORECGRP.STOREENT_ID IN ($STOREPATH:catalog$)), CATGRPDESC

              WHERE
                  EXISTS (
                            SELECT 1
                            FROM CATGRPREL
                            WHERE CATGRPREL.CATALOG_ID =  $CTX:CATALOG_ID$ AND
                            	  CATGRPREL.CATGROUP_ID_PARENT = CATGROUP.CATGROUP_ID

                            UNION ALL


			    SELECT 1
                            FROM CATGRPREL
                            WHERE  CATGRPREL.CATALOG_ID =  $CTX:CATALOG_ID$ AND
                            	   CATGRPREL.CATGROUP_ID_CHILD =  CATGROUP.CATGROUP_ID

                            UNION ALL

                            SELECT 1
                            FROM CATTOGRP
                            WHERE CATTOGRP.CATALOG_ID =  $CTX:CATALOG_ID$ AND
                            	  CATTOGRP.CATGROUP_ID =  CATGROUP.CATGROUP_ID

                    ) AND
                    CATGROUP.MARKFORDELETE = 0 AND
	            (
                         (CATGROUP.CATGROUP_ID=CATGRPDESC.CATGROUP_ID AND
                         (UPPER(CATGRPDESC.NAME) LIKE UPPER(?Description/Name?)  ESCAPE '+' )) )

		UNION

 		SELECT
              	    DISTINCT CATGROUP.$COLS:CATGROUP_ID$
             	FROM
                    CATGROUP
                       JOIN
                    STORECGRP ON
                       (CATGROUP.CATGROUP_ID = STORECGRP.CATGROUP_ID AND
                        STORECGRP.STOREENT_ID IN ($STOREPATH:catalog$))

              	WHERE
                    EXISTS (
                            SELECT 1
                            FROM CATGRPREL
                            WHERE CATGRPREL.CATALOG_ID =  $CTX:CATALOG_ID$ AND
                            	  CATGRPREL.CATGROUP_ID_PARENT = CATGROUP.CATGROUP_ID

                            UNION ALL

                            SELECT 1
                            FROM CATGRPREL
                            WHERE  CATGRPREL.CATALOG_ID =  $CTX:CATALOG_ID$ AND
                            	   CATGRPREL.CATGROUP_ID_CHILD =  CATGROUP.CATGROUP_ID

                            UNION ALL

                            SELECT 1
                            FROM CATTOGRP
                            WHERE CATTOGRP.CATALOG_ID =  $CTX:CATALOG_ID$ AND
                            	  CATTOGRP.CATGROUP_ID =  CATGROUP.CATGROUP_ID

                     ) AND
		     CATGROUP.MARKFORDELETE = 0 AND
		     (
                       ( (UPPER(CATGROUP.IDENTIFIER) LIKE UPPER(?CatalogGroupIdentifier/ExternalIdentifier/GroupIdentifier?) ESCAPE '+')) )

		 ORDER BY
              		CATGROUP_ID $DB:UNCOMMITTED_READ$
        dbtype=db2
	sql=
	      SELECT
              	  DISTINCT CATGROUP.$COLS:CATGROUP_ID$
              FROM
                  CATGROUP
                     JOIN
                  STORECGRP ON
                     (CATGROUP.CATGROUP_ID = STORECGRP.CATGROUP_ID AND
                      STORECGRP.STOREENT_ID IN ($STOREPATH:catalog$)), CATGRPDESC

              WHERE
                  EXISTS (
                            SELECT 1
                            FROM CATGRPREL
                            WHERE CATGRPREL.CATALOG_ID =  $CTX:CATALOG_ID$ AND
                            	  CATGRPREL.CATGROUP_ID_PARENT = CATGROUP.CATGROUP_ID

                            UNION ALL


			    SELECT 1
                            FROM CATGRPREL
                            WHERE  CATGRPREL.CATALOG_ID =  $CTX:CATALOG_ID$ AND
                            	   CATGRPREL.CATGROUP_ID_CHILD =  CATGROUP.CATGROUP_ID

                            UNION ALL

                            SELECT 1
                            FROM CATTOGRP
                            WHERE CATTOGRP.CATALOG_ID =  $CTX:CATALOG_ID$ AND
                            	  CATTOGRP.CATGROUP_ID =  CATGROUP.CATGROUP_ID

                    ) AND
                    CATGROUP.MARKFORDELETE = 0 AND
	            (
                         (CATGROUP.CATGROUP_ID=CATGRPDESC.CATGROUP_ID AND
                         (UPPER(CATGRPDESC.NAME) LIKE UPPER(CAST(?Description/Name? AS VARCHAR(254)))  ESCAPE '+' )))

		UNION

 		SELECT
              	    DISTINCT CATGROUP.$COLS:CATGROUP_ID$
             	FROM
                    CATGROUP
                       JOIN
                    STORECGRP ON
                       (CATGROUP.CATGROUP_ID = STORECGRP.CATGROUP_ID AND
                        STORECGRP.STOREENT_ID IN ($STOREPATH:catalog$))

              	WHERE
                    EXISTS (
                            SELECT 1
                            FROM CATGRPREL
                            WHERE CATGRPREL.CATALOG_ID =  $CTX:CATALOG_ID$ AND
                            	  CATGRPREL.CATGROUP_ID_PARENT = CATGROUP.CATGROUP_ID

                            UNION ALL

                            SELECT 1
                            FROM CATGRPREL
                            WHERE  CATGRPREL.CATALOG_ID =  $CTX:CATALOG_ID$ AND
                            	   CATGRPREL.CATGROUP_ID_CHILD =  CATGROUP.CATGROUP_ID

                            UNION ALL

                            SELECT 1
                            FROM CATTOGRP
                            WHERE CATTOGRP.CATALOG_ID =  $CTX:CATALOG_ID$ AND
                            	  CATTOGRP.CATGROUP_ID =  CATGROUP.CATGROUP_ID

                     ) AND
		     CATGROUP.MARKFORDELETE = 0 AND
		     (
                       ( (UPPER(CATGROUP.IDENTIFIER) LIKE UPPER(CAST(?CatalogGroupIdentifier/ExternalIdentifier/GroupIdentifier? AS VARCHAR(254))) ESCAPE '+')) )

		 ORDER BY
              		CATGROUP_ID $DB:UNCOMMITTED_READ$
	cm
	dbtype=db2
	sql=
	      SELECT
              	  DISTINCT CATGROUP.$COLS:CATGROUP_ID$
              FROM
		 ( SELECT $CM:BASE$.CATGROUP.CATGROUP_ID, $CM:BASE$.CATGROUP.MARKFORDELETE
		   FROM $CM:BASE$.CATGROUP
		   WHERE NOT EXISTS (SELECT '1' FROM $CM:WRITE$.CATGROUP WHERE $CM:BASE$.CATGROUP.CATGROUP_ID = $CM:WRITE$.CATGROUP.CATGROUP_ID)
			 UNION ALL
			 SELECT $CM:WRITE$.CATGROUP.CATGROUP_ID, $CM:WRITE$.CATGROUP.MARKFORDELETE
			 FROM $CM:WRITE$.CATGROUP
		 ) CATGROUP
                      JOIN
                 ( SELECT $CM:BASE$.STORECGRP.STOREENT_ID, $CM:BASE$.STORECGRP.CATGROUP_ID
		   FROM $CM:BASE$.STORECGRP
		   WHERE NOT EXISTS (SELECT '1' FROM $CM:WRITE$.STORECGRP WHERE $CM:BASE$.STORECGRP.STOREENT_ID=$CM:WRITE$.STORECGRP.STOREENT_ID AND $CM:BASE$.STORECGRP.CATGROUP_ID = $CM:WRITE$.STORECGRP.CATGROUP_ID)
			 UNION ALL
			 SELECT $CM:WRITE$.STORECGRP.STOREENT_ID, $CM:WRITE$.STORECGRP.CATGROUP_ID
			 FROM $CM:WRITE$.STORECGRP
		  ) STORECGRP ON
                      ( CATGROUP.CATGROUP_ID = STORECGRP.CATGROUP_ID AND
                        STORECGRP.STOREENT_ID IN ($STOREPATH:catalog$)),
		        ( SELECT $CM:BASE$.CATGRPDESC.CATGROUP_ID, $CM:BASE$.CATGRPDESC.LANGUAGE_ID, $CM:BASE$.CATGRPDESC.NAME
			  FROM $CM:BASE$.CATGRPDESC
			  WHERE NOT EXISTS (SELECT '1' FROM $CM:WRITE$.CATGRPDESC WHERE  $CM:BASE$.CATGRPDESC.CATGROUP_ID = $CM:WRITE$.CATGRPDESC.CATGROUP_ID AND $CM:BASE$.CATGRPDESC.LANGUAGE_ID = $CM:WRITE$.CATGRPDESC.LANGUAGE_ID)
			        UNION ALL
			        SELECT $CM:WRITE$.CATGRPDESC.CATGROUP_ID, $CM:WRITE$.CATGRPDESC.LANGUAGE_ID, $CM:WRITE$.CATGRPDESC.NAME
			        FROM $CM:WRITE$.CATGRPDESC
		        ) CATGRPDESC

              WHERE
                  EXISTS (
                            SELECT 1
                            FROM ( SELECT $CM:BASE$.CATGRPREL.CATGROUP_ID_CHILD, $CM:BASE$.CATGRPREL.CATGROUP_ID_PARENT, $CM:BASE$.CATGRPREL.CATALOG_ID
				   FROM $CM:BASE$.CATGRPREL
				   WHERE NOT EXISTS (SELECT '1' FROM $CM:WRITE$.CATGRPREL WHERE $CM:BASE$.CATGRPREL.CATGROUP_ID_CHILD = $CM:WRITE$.CATGRPREL.CATGROUP_ID_CHILD AND $CM:BASE$.CATGRPREL.CATGROUP_ID_PARENT = $CM:WRITE$.CATGRPREL.CATGROUP_ID_PARENT AND
					   $CM:BASE$.CATGRPREL.CATALOG_ID = $CM:WRITE$.CATGRPREL.CATALOG_ID)
					 UNION ALL
					 SELECT $CM:WRITE$.CATGRPREL.CATGROUP_ID_CHILD, $CM:WRITE$.CATGRPREL.CATGROUP_ID_PARENT, $CM:WRITE$.CATGRPREL.CATALOG_ID
					 FROM $CM:WRITE$.CATGRPREL
				) CATGRPREL
                            WHERE CATGRPREL.CATALOG_ID =  $CTX:CATALOG_ID$ AND
                            	  CATGRPREL.CATGROUP_ID_PARENT = CATGROUP.CATGROUP_ID

                            UNION ALL


			    SELECT 1
                            FROM ( SELECT $CM:BASE$.CATGRPREL.CATGROUP_ID_CHILD, $CM:BASE$.CATGRPREL.CATGROUP_ID_PARENT, $CM:BASE$.CATGRPREL.CATALOG_ID
				   FROM $CM:BASE$.CATGRPREL
				   WHERE NOT EXISTS (SELECT '1' FROM $CM:WRITE$.CATGRPREL WHERE $CM:BASE$.CATGRPREL.CATGROUP_ID_CHILD = $CM:WRITE$.CATGRPREL.CATGROUP_ID_CHILD AND $CM:BASE$.CATGRPREL.CATGROUP_ID_PARENT = $CM:WRITE$.CATGRPREL.CATGROUP_ID_PARENT AND
					   $CM:BASE$.CATGRPREL.CATALOG_ID = $CM:WRITE$.CATGRPREL.CATALOG_ID)
					 UNION ALL
					 SELECT $CM:WRITE$.CATGRPREL.CATGROUP_ID_CHILD, $CM:WRITE$.CATGRPREL.CATGROUP_ID_PARENT, $CM:WRITE$.CATGRPREL.CATALOG_ID
					 FROM $CM:WRITE$.CATGRPREL
				) CATGRPREL
                            WHERE  CATGRPREL.CATALOG_ID =  $CTX:CATALOG_ID$ AND
                            	   CATGRPREL.CATGROUP_ID_CHILD =  CATGROUP.CATGROUP_ID

                            UNION ALL

                            SELECT 1
                            FROM ( SELECT $CM:BASE$.CATTOGRP.CATGROUP_ID, $CM:BASE$.CATTOGRP.CATALOG_ID
				   FROM $CM:BASE$.CATTOGRP
				   WHERE NOT EXISTS ( SELECT '1' FROM $CM:WRITE$.CATTOGRP WHERE $CM:BASE$.CATTOGRP.CATALOG_ID = $CM:WRITE$.CATTOGRP.CATALOG_ID
					    AND $CM:BASE$.CATTOGRP.CATGROUP_ID = $CM:WRITE$.CATTOGRP.CATGROUP_ID)
					 UNION ALL
					 SELECT $CM:WRITE$.CATTOGRP.CATGROUP_ID, $CM:WRITE$.CATTOGRP.CATALOG_ID
					 FROM $CM:WRITE$.CATTOGRP
				) CATTOGRP
                            WHERE CATTOGRP.CATALOG_ID =  $CTX:CATALOG_ID$ AND
                            	  CATTOGRP.CATGROUP_ID =  CATGROUP.CATGROUP_ID

                    ) AND
                    CATGROUP.MARKFORDELETE = 0 AND
	            (
                         (CATGROUP.CATGROUP_ID=CATGRPDESC.CATGROUP_ID AND
                         (UPPER(CATGRPDESC.NAME) LIKE UPPER(CAST(?Description/Name? AS VARCHAR(254)))  ESCAPE '+' ) ) )

		UNION

 		SELECT
              	    DISTINCT CATGROUP.$COLS:CATGROUP_ID$
             	FROM
                    ( SELECT $CM:BASE$.CATGROUP.CATGROUP_ID, $CM:BASE$.CATGROUP.IDENTIFIER, $CM:BASE$.CATGROUP.MARKFORDELETE
		      FROM $CM:BASE$.CATGROUP
		      WHERE NOT EXISTS (SELECT '1' FROM $CM:WRITE$.CATGROUP WHERE $CM:BASE$.CATGROUP.CATGROUP_ID = $CM:WRITE$.CATGROUP.CATGROUP_ID)
			    UNION ALL
			    SELECT $CM:WRITE$.CATGROUP.CATGROUP_ID, $CM:WRITE$.CATGROUP.IDENTIFIER, $CM:WRITE$.CATGROUP.MARKFORDELETE
			    FROM $CM:WRITE$.CATGROUP
		    ) CATGROUP
                       JOIN
                    ( SELECT $CM:BASE$.STORECGRP.STOREENT_ID, $CM:BASE$.STORECGRP.CATGROUP_ID
		      FROM $CM:BASE$.STORECGRP
		      WHERE NOT EXISTS (SELECT '1' FROM $CM:WRITE$.STORECGRP WHERE $CM:BASE$.STORECGRP.STOREENT_ID=$CM:WRITE$.STORECGRP.STOREENT_ID AND $CM:BASE$.STORECGRP.CATGROUP_ID = $CM:WRITE$.STORECGRP.CATGROUP_ID)
			    UNION ALL
			    SELECT $CM:WRITE$.STORECGRP.STOREENT_ID, $CM:WRITE$.STORECGRP.CATGROUP_ID
			    FROM $CM:WRITE$.STORECGRP
		    ) STORECGRP ON
                       (CATGROUP.CATGROUP_ID = STORECGRP.CATGROUP_ID AND
                        STORECGRP.STOREENT_ID IN ($STOREPATH:catalog$))

              	WHERE
                    EXISTS (
                            SELECT 1
                            FROM ( SELECT $CM:BASE$.CATGRPREL.CATGROUP_ID_CHILD, $CM:BASE$.CATGRPREL.CATGROUP_ID_PARENT, $CM:BASE$.CATGRPREL.CATALOG_ID
				   FROM $CM:BASE$.CATGRPREL
				   WHERE NOT EXISTS (SELECT '1' FROM $CM:WRITE$.CATGRPREL WHERE $CM:BASE$.CATGRPREL.CATGROUP_ID_CHILD = $CM:WRITE$.CATGRPREL.CATGROUP_ID_CHILD AND $CM:BASE$.CATGRPREL.CATGROUP_ID_PARENT = $CM:WRITE$.CATGRPREL.CATGROUP_ID_PARENT AND
					   $CM:BASE$.CATGRPREL.CATALOG_ID = $CM:WRITE$.CATGRPREL.CATALOG_ID)
					 UNION ALL
					 SELECT $CM:WRITE$.CATGRPREL.CATGROUP_ID_CHILD, $CM:WRITE$.CATGRPREL.CATGROUP_ID_PARENT, $CM:WRITE$.CATGRPREL.CATALOG_ID
					 FROM $CM:WRITE$.CATGRPREL
				) CATGRPREL
                            WHERE CATGRPREL.CATALOG_ID =  $CTX:CATALOG_ID$ AND
                            	  CATGRPREL.CATGROUP_ID_PARENT = CATGROUP.CATGROUP_ID

                            UNION ALL

                            SELECT 1
                            FROM ( SELECT $CM:BASE$.CATGRPREL.CATGROUP_ID_CHILD, $CM:BASE$.CATGRPREL.CATGROUP_ID_PARENT, $CM:BASE$.CATGRPREL.CATALOG_ID
				   FROM $CM:BASE$.CATGRPREL
				   WHERE NOT EXISTS (SELECT '1' FROM $CM:WRITE$.CATGRPREL WHERE $CM:BASE$.CATGRPREL.CATGROUP_ID_CHILD = $CM:WRITE$.CATGRPREL.CATGROUP_ID_CHILD AND $CM:BASE$.CATGRPREL.CATGROUP_ID_PARENT = $CM:WRITE$.CATGRPREL.CATGROUP_ID_PARENT AND
					   $CM:BASE$.CATGRPREL.CATALOG_ID = $CM:WRITE$.CATGRPREL.CATALOG_ID)
					 UNION ALL
					 SELECT $CM:WRITE$.CATGRPREL.CATGROUP_ID_CHILD, $CM:WRITE$.CATGRPREL.CATGROUP_ID_PARENT, $CM:WRITE$.CATGRPREL.CATALOG_ID
					 FROM $CM:WRITE$.CATGRPREL
				) CATGRPREL
                            WHERE  CATGRPREL.CATALOG_ID =  $CTX:CATALOG_ID$ AND
                            	   CATGRPREL.CATGROUP_ID_CHILD =  CATGROUP.CATGROUP_ID

                            UNION ALL

                            SELECT 1
                            FROM ( SELECT $CM:BASE$.CATTOGRP.CATGROUP_ID, $CM:BASE$.CATTOGRP.CATALOG_ID
				   FROM $CM:BASE$.CATTOGRP
				   WHERE NOT EXISTS (SELECT '1' FROM $CM:WRITE$.CATTOGRP WHERE $CM:BASE$.CATTOGRP.CATALOG_ID = $CM:WRITE$.CATTOGRP.CATALOG_ID
					    AND $CM:BASE$.CATTOGRP.CATGROUP_ID = $CM:WRITE$.CATTOGRP.CATGROUP_ID)
					 UNION ALL
					 SELECT $CM:WRITE$.CATTOGRP.CATGROUP_ID, $CM:WRITE$.CATTOGRP.CATALOG_ID
					 FROM $CM:WRITE$.CATTOGRP
				) CATTOGRP
                            WHERE CATTOGRP.CATALOG_ID =  $CTX:CATALOG_ID$ AND
                            	  CATTOGRP.CATGROUP_ID =  CATGROUP.CATGROUP_ID

                     ) AND
		     CATGROUP.MARKFORDELETE = 0 AND
		     (
                       ((UPPER(CATGROUP.IDENTIFIER) LIKE UPPER(CAST(?CatalogGroupIdentifier/ExternalIdentifier/GroupIdentifier? AS VARCHAR(254))) ESCAPE '+')))

		 ORDER BY
              		CATGROUP_ID $DB:UNCOMMITTED_READ$

END_XPATH_TO_SQL_STATEMENT


<!-- ============================================================= -->
<!-- This SQL will return the elements of the Catalog Group noun(s)-->
<!-- given the specified search criteria.                          -->
<!-- The search is restricted to catalog groups belonging to the   -->
<!-- catalog set in the context                                    -->
<!-- The access profiles that apply to this SQL are:               -->
<!-- IBM_Admin_Details, IBM_Admin_Summary, IBM_Admin_All and all other catalog group -->
<!-- profiles.				                                       -->
<!-- @param Context:StoreID - The store for which to retrieve the  -->
<!--        catalog entry. This parameter is retrieved from within -->
<!--	    the business context.           	                   -->
<!-- @param Context:CatalogID - The catalog for which to retrieve  -->
<!--        the catalog entry. This parameter is retrieved from    -->
<!--	    within the business context.           	               -->
<!-- ============================================================= -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogGroup[search()]
	base_table=CATGROUP
	className=com.ibm.commerce.foundation.server.services.dataaccess.db.jdbc.VarcharParametersTrimProcessor
	param=Description/Name:254
	param=CatalogGroupIdentifier/ExternalIdentifier/GroupIdentifier:254

	sql=
              SELECT
              		DISTINCT CATGROUP.$COLS:CATGROUP_ID$
              FROM
                            CATGROUP
                             JOIN
                            STORECGRP ON
                            	(CATGROUP.CATGROUP_ID = STORECGRP.CATGROUP_ID AND
                            	 STORECGRP.STOREENT_ID IN ($STOREPATH:catalog$))
                            ,$ATTR_TBLS$
              WHERE
                            EXISTS
                            (
                            	SELECT 1
                            	FROM CATGRPREL
                            	WHERE CATGRPREL.CATALOG_ID =  $CTX:CATALOG_ID$ AND
                            		CATGRPREL.CATGROUP_ID_PARENT = CATGROUP.CATGROUP_ID

                            	UNION ALL

                            	SELECT 1
                            	FROM CATGRPREL
                            	WHERE  CATGRPREL.CATALOG_ID =  $CTX:CATALOG_ID$ AND
                            		CATGRPREL.CATGROUP_ID_CHILD =  CATGROUP.CATGROUP_ID

                            	UNION ALL

                            	SELECT 1
                            	FROM CATTOGRP
                            	WHERE CATTOGRP.CATALOG_ID =  $CTX:CATALOG_ID$ AND
                            		CATTOGRP.CATGROUP_ID =  CATGROUP.CATGROUP_ID

                            ) AND
		                	CATGROUP.MARKFORDELETE = 0 AND
		                	( $ATTR_CNDS$ )
              ORDER BY
              				CATGROUP.CATGROUP_ID $DB:UNCOMMITTED_READ$

END_XPATH_TO_SQL_STATEMENT


<!-- ============================================================= -->
<!-- This SQL will return the elements of the Catalog Group noun(s)-->
<!-- given the specified search criteria.                          -->
<!-- The search is conducted on all catalog groups irrespective of -->
<!-- the catalog they belong to                                    -->
<!-- The access profiles that apply to this SQL are:               -->
<!-- IBM_Admin_Details, IBM_Admin_Summary, IBM_Admin_All and all other catalog group -->
<!-- profiles.				                                       -->
<!-- @param Context:StoreID - The store for which to retrieve the  -->
<!--        catalog entry. This parameter is retrieved from within -->
<!--	    the business context.           	                   -->
<!-- @param allCategories - Should be always 'true'                -->
<!-- ============================================================= -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogGroup[@allCategories= and search()]
	base_table=CATGROUP
	className=com.ibm.commerce.foundation.server.services.dataaccess.db.jdbc.VarcharParametersTrimProcessor
	param=Description/Name:254
	param=CatalogGroupIdentifier/ExternalIdentifier/GroupIdentifier:254

	sql=
              SELECT
              				DISTINCT CATGROUP.$COLS:CATGROUP_ID$
              FROM
                            CATGROUP
                             JOIN
                            STORECGRP ON
                            	(CATGROUP.CATGROUP_ID = STORECGRP.CATGROUP_ID AND
                            	 STORECGRP.STOREENT_ID IN ($STOREPATH:catalog$))
                            ,$ATTR_TBLS$
              WHERE
                            CATGROUP.MARKFORDELETE = 0 AND
		                	?allCategories? = 'true' AND
		                	( $ATTR_CNDS$ )
              ORDER BY
              				CATGROUP.CATGROUP_ID $DB:UNCOMMITTED_READ$

END_XPATH_TO_SQL_STATEMENT
<!-- ============================================================= -->
<!-- This SQL will return the elements of the Catalog Group noun(s)-->
<!-- given the specified search criteria.                          -->
<!-- The search is conducted only on sales catalog groups          -->
<!-- The access profiles that apply to this SQL are:               -->
<!-- IBM_Admin_Details, IBM_Admin_Summary, IBM_Admin_All and all other catalog group -->
<!-- profiles.				                                       -->
<!-- @param Context:StoreID - The store for which to retrieve the  -->
<!--        catalog entry. This parameter is retrieved from within -->
<!--	    the business context.           	                   -->
<!-- ============================================================= -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogGroup[@salesCategories= and search()]
	className=com.ibm.commerce.foundation.server.services.dataaccess.db.jdbc.VarcharParametersTrimProcessor
	param=Description/Name:254
	param=CatalogGroupIdentifier/ExternalIdentifier/GroupIdentifier:254

	base_table=CATGROUP
	sql=
              SELECT
              				DISTINCT CATGROUP.$COLS:CATGROUP_ID$
              FROM
                            CATGROUP
                             JOIN
                            STORECGRP ON
                            	(CATGROUP.CATGROUP_ID = STORECGRP.CATGROUP_ID AND
                            	 STORECGRP.STOREENT_ID IN ($STOREPATH:catalog$))
                            ,$ATTR_TBLS$
              WHERE
                            (
                            	EXISTS
                            		(
                            			SELECT
                            				1
                            			FROM
                            				CATGRPREL, STORECAT
                            			WHERE
                            				CATGRPREL.CATALOG_ID = STORECAT.CATALOG_ID AND
                            				STORECAT.STOREENT_ID IN ($STOREPATH:catalog$) AND
                            				STORECAT.MASTERCATALOG = '0' AND
                            				(CATGRPREL.CATGROUP_ID_CHILD = CATGROUP.CATGROUP_ID OR
                            				 CATGRPREL.CATGROUP_ID_PARENT = CATGROUP.CATGROUP_ID) AND
											CATGRPREL.CATALOG_ID_LINK IS NULL
                            		)
                            	 OR
                            	EXISTS
                            		(
                            			SELECT
                            				1
                            			FROM
                            				CATTOGRP, STORECAT
                            			WHERE
                            				CATTOGRP.CATALOG_ID = STORECAT.CATALOG_ID AND
                            				STORECAT.STOREENT_ID IN ($STOREPATH:catalog$) AND
                            				STORECAT.MASTERCATALOG = '0' AND
                            				CATTOGRP.CATGROUP_ID = CATGROUP.CATGROUP_ID AND
											CATTOGRP.CATALOG_ID_LINK IS NULL
                            		)
                            ) AND
		                	CATGROUP.MARKFORDELETE = 0 AND
		                	CATGROUP.DYNAMIC = 0 AND
		                	?salesCategories? = 'true' AND
		                	( $ATTR_CNDS$ )
              ORDER BY
              				CATGROUP.CATGROUP_ID  $DB:UNCOMMITTED_READ$

END_XPATH_TO_SQL_STATEMENT

<!-- ============================================================= -->
<!-- This SQL will return the elements of the Catalog Group noun(s)-->
<!-- given the specified search criteria.                          -->
<!-- The search is conducted only on dynamic sales catalog groups  -->
<!-- The access profiles that apply to this SQL are:               -->
<!-- IBM_Admin_Details, IBM_Admin_Summary, IBM_Admin_All and all other catalog group -->
<!-- profiles.				                                       -->
<!-- @param Context:StoreID - The store for which to retrieve the  -->
<!--        category. This parameter is retrieved from within -->
<!--	    the business context.           	                   -->
<!-- ============================================================= -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogGroup[@dynamicSalesCategories= and search()]
	className=com.ibm.commerce.foundation.server.services.dataaccess.db.jdbc.VarcharParametersTrimProcessor
	param=Description/Name:254
	param=CatalogGroupIdentifier/ExternalIdentifier/GroupIdentifier:254

	base_table=CATGROUP
	sql=
              SELECT
              				DISTINCT CATGROUP.$COLS:CATGROUP_ID$
              FROM
                            CATGROUP
                             JOIN
                            STORECGRP ON
                            	(CATGROUP.CATGROUP_ID = STORECGRP.CATGROUP_ID AND
                            	 STORECGRP.STOREENT_ID IN ($STOREPATH:catalog$))
                            ,$ATTR_TBLS$
              WHERE
                            (
                            	EXISTS
                            		(
                            			SELECT
                            				1
                            			FROM
                            				CATGRPREL, STORECAT
                            			WHERE
                            				CATGRPREL.CATALOG_ID = STORECAT.CATALOG_ID AND
                            				STORECAT.STOREENT_ID IN ($STOREPATH:catalog$) AND
                            				STORECAT.MASTERCATALOG = '0' AND
                            				(CATGRPREL.CATGROUP_ID_CHILD = CATGROUP.CATGROUP_ID OR
                            				 CATGRPREL.CATGROUP_ID_PARENT = CATGROUP.CATGROUP_ID)
                            		)
                            	 OR
                            	EXISTS
                            		(
                            			SELECT
                            				1
                            			FROM
                            				CATTOGRP, STORECAT
                            			WHERE
                            				CATTOGRP.CATALOG_ID = STORECAT.CATALOG_ID AND
                            				STORECAT.STOREENT_ID IN ($STOREPATH:catalog$) AND
                            				STORECAT.MASTERCATALOG = '0' AND
                            				CATTOGRP.CATGROUP_ID = CATGROUP.CATGROUP_ID
                            		)
                            ) AND
		                	CATGROUP.MARKFORDELETE = 0 AND
		                	CATGROUP.DYNAMIC = 1 AND
		                	?dynamicSalesCategories? = 'true' AND
		                	( $ATTR_CNDS$ )
              ORDER BY
              				CATGROUP.CATGROUP_ID  $DB:UNCOMMITTED_READ$

END_XPATH_TO_SQL_STATEMENT

<!-- ============================================================= -->
<!-- This SQL will return the elements of the Catalog Group        -->
<!-- noun(s) which refer TO the given catalog group (unique        -->
<!-- identifier) through a merchandising association.              -->
<!-- Multiple results are returned if multiple identifiers are     -->
<!-- specified.	                                                   -->
<!-- The access profiles that apply to this SQL are:               -->
<!-- IBM_Admin_Details, IBM_Admin_Summary, IBM_Admin_All and all other catalog group -->
<!-- profiles.				                                       -->
<!-- @param UniqueID - The identifier(s) for which to retrieve     -->
<!-- @param Context:StoreID - The store for which to retrieve the  -->
<!--        catalog entry. This parameter is retrieved from within -->
<!--	    the business context.           	                   -->
<!-- ============================================================= -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogGroup[Association[CatalogGroupReference[CatalogGroupIdentifier[(UniqueID=)]]]]
	base_table=CATGROUP
	sql=
		SELECT
				CATGROUP.$COLS:CATGROUP_ID$
		FROM
				MASSOCGPGP
				 JOIN
				CATGROUP ON
					(CATGROUP.CATGROUP_ID = MASSOCGPGP.CATGROUP_ID_FROM)
        WHERE
               MASSOCGPGP.CATGROUP_ID_TO IN (?UniqueID?) AND
               MASSOCGPGP.STORE_ID IN ($STOREPATH:catalog$) AND
               CATGROUP.MARKFORDELETE = 0
        ORDER BY
   				CATGROUP.CATGROUP_ID


END_XPATH_TO_SQL_STATEMENT


<!-- ============================================================= -->
<!-- This SQL will return the elements of the Catalog Group        -->
<!-- noun(s) which refer TO the given catalog group identifier     -->
<!-- through a merchandising association.                          -->
<!-- Multiple results are returned if multiple identifiers are     -->
<!-- specified.	                                                   -->
<!-- The access profiles that apply to this SQL are:               -->
<!-- IBM_Admin_Details, IBM_Admin_Summary, IBM_Admin_All and all other catalog group -->
<!-- profiles.				                                       -->
<!-- @param GroupIdentifier - The identifier(s) for which to       -->
<!--        retrieve.                                              -->
<!-- @param Context:StoreID - The store for which to retrieve the  -->
<!--        catalog entry. This parameter is retrieved from within -->
<!--	    the business context.           	                   -->
<!-- ============================================================= -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogGroup[Association[CatalogGroupReference[CatalogGroupIdentifier[ExternalIdentifier[(GroupIdentifier=)]]]]]
	base_table=CATGROUP
	sql=
		SELECT
				CATGROUP.$COLS:CATGROUP_ID$
		FROM
				MASSOCGPGP
				 JOIN
				CATGROUP ON
					(CATGROUP.CATGROUP_ID = MASSOCGPGP.CATGROUP_ID_FROM)
				 JOIN
				CATGROUP CATGROUP2 ON
					(MASSOCGPGP.CATGROUP_ID_TO = CATGROUP2.CATGROUP_ID AND
					 CATGROUP2.IDENTIFIER IN (?GroupIdentifier?) AND
					 CATGROUP2.MARKFORDELETE = 0)
        WHERE
               MASSOCGPGP.STORE_ID IN ($STOREPATH:catalog$) AND
               CATGROUP.MARKFORDELETE = 0
        ORDER BY
   				CATGROUP.CATGROUP_ID



END_XPATH_TO_SQL_STATEMENT


<!-- ========================================================= -->
<!-- This is a helper SQL used for getting sales catalog       -->
<!-- references.                                               -->
<!--  Desc: Get parent catgroup of catgroup in catalog         -->
<!-- The access profile that apply to this SQL is:             -->
<!-- IBM_Admin_SalesCatalogReferenceHelper                           -->
<!-- ========================================================= -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogGroup[@catalogId= and NavigationRelationship[CatalogGroupReference[CatalogGroupIdentifier[(UniqueID= and type=)]]]]+IBM_Admin_SalesCatalogReferenceHelper
	base_table=CATGROUP
	sql=

              SELECT
              				CATGROUP.$COLS:CATGROUP_ID$, CATGROUP.$COLS:CATGROUP:MEMBER_ID$,
							CATGROUP.$COLS:CATGROUP:IDENTIFIER$,
							CATGRPDESC.$COLS:CATGRPDESC:CATGROUP_ID$, CATGRPDESC.$COLS:CATGRPDESC:LANGUAGE_ID$,
							CATGRPDESC.$COLS:CATGRPDESC:NAME$
              FROM
                            CATGROUP
                             JOIN
                            CATGRPREL ON
                            	(CATGROUP.CATGROUP_ID = CATGRPREL.CATGROUP_ID_PARENT AND
			   			 	     CATGRPREL.CATALOG_ID = ?catalogId?)
			   			 	 JOIN
                            STORECGRP ON
                            	(CATGROUP.CATGROUP_ID = STORECGRP.CATGROUP_ID AND
                            	 STORECGRP.STOREENT_ID IN ($STOREPATH:catalog$))
                             LEFT OUTER JOIN
					        CATGRPDESC ON
					 			(CATGROUP.CATGROUP_ID = CATGRPDESC.CATGROUP_ID AND
					  			 CATGRPDESC.LANGUAGE_ID IN ($CONTROL:LANGUAGES$))
              WHERE
                            CATGRPREL.CATGROUP_ID_CHILD IN (?UniqueID?) AND
		                	CATGROUP.MARKFORDELETE = 0 AND
		                	?type? = 'child-parent'

END_XPATH_TO_SQL_STATEMENT


<!-- ========================================================= -->
<!-- This is a helper SQL used for getting sales catalog       -->
<!-- references.                                               -->
<!--  Desc: Get parent catgroup of catentry in sales catalogs  -->
<!-- The access profile that apply to this SQL is:             -->
<!-- IBM_Admin_SalesCatalogReferenceHelper                           -->
<!-- ========================================================= -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogGroup[@salesCatalog= and NavigationRelationship[CatalogEntryReference[CatalogEntryIdentifier[(UniqueID= and type=)]]]]+IBM_Admin_SalesCatalogReferenceHelper
	base_table=CATGROUP
	sql=

              SELECT
					CATGROUP.$COLS:CATGROUP_ID$, CATGROUP.$COLS:CATGROUP:MEMBER_ID$,
					CATGROUP.$COLS:CATGROUP:IDENTIFIER$,
					CATGRPDESC.$COLS:CATGRPDESC:CATGROUP_ID$, CATGRPDESC.$COLS:CATGRPDESC:LANGUAGE_ID$,
					CATGRPDESC.$COLS:CATGRPDESC:NAME$,
           		    CATGPENREL.$COLS:CATGPENREL$,
           		    STORECGRP.$COLS:STORECGRP$
              FROM
			    	   CATGPENREL
                        JOIN
                       CATGROUP ON
                       		(CATGROUP.CATGROUP_ID = CATGPENREL.CATGROUP_ID)
                        JOIN
                       STORECGRP ON
                            (CATGROUP.CATGROUP_ID = STORECGRP.CATGROUP_ID AND
                             STORECGRP.STOREENT_ID IN ($STOREPATH:catalog$))
                       LEFT OUTER JOIN
					  CATGRPDESC ON
					 		(CATGROUP.CATGROUP_ID = CATGRPDESC.CATGROUP_ID AND
					  		 CATGRPDESC.LANGUAGE_ID IN ($CONTROL:LANGUAGES$))
					   JOIN
					  STORECAT ON
					  		(STORECAT.CATALOG_ID = CATGPENREL.CATALOG_ID AND
					  		 STORECAT.STOREENT_ID IN ($STOREPATH:catalog$) AND
					  		 STORECAT.MASTERCATALOG <> '1')
              WHERE
                       CATGPENREL.CATENTRY_ID IN (?UniqueID?) AND
		        	   CATGROUP.MARKFORDELETE = 0 AND
		        	   ?type? = 'child-parent' AND
		        	   ?salesCatalog? = 'true' AND
		               CATGROUP.MARKFORDELETE = 0

END_XPATH_TO_SQL_STATEMENT


<!-- ========================================================= -->
<!-- This is a helper SQL used for getting sales catalog       -->
<!-- references.                                               -->
<!--  Desc: Get parent catgroup of catentry in sales catalogs  -->
<!-- The access profile that apply to this SQL is:             -->
<!-- IBM_Admin_SalesCatalogReferenceHelper                           -->
<!-- ========================================================= -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogGroup[@salesCatalog= and NavigationRelationship[CatalogGroupReference[CatalogGroupIdentifier[(UniqueID= and type=)]]]]+IBM_Admin_SalesCatalogReferenceHelper
	base_table=CATGROUP
	sql=

              SELECT
					CATGROUP.$COLS:CATGROUP_ID$, CATGROUP.$COLS:CATGROUP:MEMBER_ID$,
					CATGROUP.$COLS:CATGROUP:IDENTIFIER$,
					CATGRPDESC.$COLS:CATGRPDESC:CATGROUP_ID$, CATGRPDESC.$COLS:CATGRPDESC:LANGUAGE_ID$,
					CATGRPDESC.$COLS:CATGRPDESC:NAME$,
           		    CATGRPREL.$COLS:CATGRPREL$
              FROM
			    	   CATGRPREL
                        JOIN
                       CATGROUP ON
                       		(CATGROUP.CATGROUP_ID = CATGRPREL.CATGROUP_ID_PARENT)
                        JOIN
                       STORECGRP ON
                            	(CATGROUP.CATGROUP_ID = STORECGRP.CATGROUP_ID AND
                            	 STORECGRP.STOREENT_ID IN ($STOREPATH:catalog$))
                       LEFT OUTER JOIN
					  CATGRPDESC ON
					 			(CATGROUP.CATGROUP_ID = CATGRPDESC.CATGROUP_ID AND
					  			 CATGRPDESC.LANGUAGE_ID IN ($CONTROL:LANGUAGES$))
					   JOIN
					  STORECAT ON
					  		(STORECAT.CATALOG_ID = CATGRPREL.CATALOG_ID AND
					  		 STORECAT.STOREENT_ID IN ($STOREPATH:catalog$) AND
					  		 STORECAT.MASTERCATALOG <> '1')
              WHERE
                       CATGRPREL.CATGROUP_ID_CHILD IN (?UniqueID?) AND
		        	   CATGROUP.MARKFORDELETE = 0 AND
		        	   ?type? = 'child-parent' AND
		        	   ?salesCatalog? = 'true' AND
		               CATGROUP.MARKFORDELETE = 0

END_XPATH_TO_SQL_STATEMENT


<!-- ========================================================= -->
<!-- This is a helper SQL used for getting sales catalog       -->
<!-- references.                                               -->
<!--  Desc: Get Top Catgroup info in sales catalogs            -->
<!-- The access profile that apply to this SQL is:             -->
<!-- IBM_Admin_SalesCatalogReferenceHelper                           -->
<!-- ========================================================= -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogGroup[@salesCatalog= and @topCatalogGroup= and CatalogGroupIdentifier[(UniqueID=)]]+IBM_Admin_SalesCatalogReferenceHelper
	base_table=CATGROUP
	sql=

              SELECT
              				CATGROUP.$COLS:CATGROUP$,
              				CATTOGRP.$COLS:CATTOGRP$
              FROM
                            CATGROUP
                             JOIN
                            CATTOGRP ON
                            	(CATTOGRP.CATGROUP_ID = CATGROUP.CATGROUP_ID)
                             JOIN
                            STORECGRP ON
                            	(CATGROUP.CATGROUP_ID = STORECGRP.CATGROUP_ID AND
                            	 STORECGRP.STOREENT_ID IN ($STOREPATH:catalog$))
                             JOIN
					  		STORECAT ON
						  		(STORECAT.CATALOG_ID = CATTOGRP.CATALOG_ID AND
						  		 STORECAT.STOREENT_ID IN ($STOREPATH:catalog$) AND
						  		 STORECAT.MASTERCATALOG <> '1')
              WHERE
                            CATGROUP.MARKFORDELETE = 0 AND
                            ?topCatalogGroup? = 'true' AND
                            ?salesCatalog? = 'true' AND
                            CATTOGRP.CATGROUP_ID IN (?UniqueID?) AND
                            CATGROUP.MARKFORDELETE = 0

END_XPATH_TO_SQL_STATEMENT


<!-- ========================================================= -->
<!-- This is a helper SQL used for getting parent catgroups.   -->
<!--  Desc: Get parent catgroups of catgroup in all catalogs.  -->
<!-- The access profile that apply to this SQL is:             -->
<!-- IBM_Admin_CatalogGroupAllParentsDetailsHelper                         -->
<!-- ========================================================= -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogGroup[@catalogId= and NavigationRelationship[CatalogGroupReference[CatalogGroupIdentifier[(UniqueID= and type=)]]]]+IBM_Admin_CatalogGroupAllParentsDetailsHelper
	base_table=CATGROUP
	sql=

              SELECT
	      		CATGROUP.$COLS:CATGROUP_ID$, CATGROUP.$COLS:CATGROUP:MEMBER_ID$,
	      		CATGROUP.$COLS:CATGROUP:IDENTIFIER$,
	      		CATGRPDESC.$COLS:CATGRPDESC:CATGROUP_ID$, CATGRPDESC.$COLS:CATGRPDESC:LANGUAGE_ID$,
	      		CATGRPDESC.$COLS:CATGRPDESC:NAME$,
	      		CATGRPREL.$COLS:CATGRPREL$
	      FROM
	                CATGROUP
	                 JOIN
			CATGRPREL ON
				(CATGROUP.CATGROUP_ID = CATGRPREL.CATGROUP_ID_PARENT AND
				 CATGRPREL.CATALOG_ID = ?catalogId?)
			 JOIN
			STORECGRP ON
				(CATGROUP.CATGROUP_ID = STORECGRP.CATGROUP_ID AND
				 STORECGRP.STOREENT_ID IN ($STOREPATH:catalog$))
			 LEFT OUTER JOIN
			CATGRPDESC ON
				(CATGROUP.CATGROUP_ID = CATGRPDESC.CATGROUP_ID AND
				 CATGRPDESC.LANGUAGE_ID IN ($CONTROL:LANGUAGES$))
	      WHERE
			CATGRPREL.CATGROUP_ID_CHILD IN (?UniqueID?) AND
			CATGROUP.MARKFORDELETE = 0 AND
			?type? = 'child-parent'

END_XPATH_TO_SQL_STATEMENT





<!-- ============================================================= -->
<!-- This is a helper SQL used for getting a catgroup noun    	   -->
<!-- for loading catalog group breadcrumb locations.          	   -->
<!-- This SQL will return the bsae elements of the Catalog Group   -->
<!-- noun given the specified unique identifier.                   -->
<!-- Multiple results are returned if multiple identifiers are     -->
<!-- specified.	                                                   -->
<!-- The access profile that applies to this SQL:                  -->
<!-- IBM_Admin_CatalogGroupLocations				   -->
<!--  			                                           -->
<!-- @param UniqueID - The identifier(s) for which to retrieve     -->
<!-- ============================================================= -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogGroup[CatalogGroupIdentifier[(UniqueID=)]]+IBM_Admin_CatalogGroupLocations
	base_table=CATGROUP
	sql=

		SELECT
				CATGROUP.$COLS:CATGROUP_ID$
		FROM
     				CATGROUP
		WHERE
				CATGROUP.CATGROUP_ID IN (?UniqueID?)
				AND CATGROUP.MARKFORDELETE = 0
END_XPATH_TO_SQL_STATEMENT


<!-- ============================================================= -->
<!-- This SQL will return the elements of the Catalog Group noun(s)-->
<!-- which do not belong to any catalog, given the specified store -->
<!-- id.                                                           -->
<!-- The access profiles that apply to this SQL are:               -->
<!-- IBM_Admin_Details, IBM_Admin_Summary, IBM_Admin_All and all other catalog group -->
<!-- profiles.				                                       -->
<!-- @param Context:StoreID - The store for which to retrieve the  -->
<!--        catalog entry. This parameter is retrieved from within -->
<!--	    the business context.           	                   -->
<!-- ============================================================= -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogGroup
	base_table=CATGROUP
	sql=
              SELECT
              		    CATGROUP.$COLS:CATGROUP_ID$
              FROM
                            CATGROUP
                             JOIN
                            STORECGRP ON
                            	(CATGROUP.CATGROUP_ID = STORECGRP.CATGROUP_ID AND
                            	 STORECGRP.STOREENT_ID IN ($STOREPATH:catalog$))
              WHERE
                            NOT EXISTS
				(
					SELECT
						1
					FROM
						CATGRPREL
					WHERE
						(CATGRPREL.CATGROUP_ID_CHILD = CATGROUP.CATGROUP_ID OR
						 CATGRPREL.CATGROUP_ID_PARENT = CATGROUP.CATGROUP_ID)
				)
  			     AND
			    NOT EXISTS
				(
					SELECT
						1
					FROM
						CATTOGRP
					WHERE
						CATTOGRP.CATGROUP_ID = CATGROUP.CATGROUP_ID
				)
			    AND
			   CATGROUP.MARKFORDELETE = 0
              ORDER BY
              		   CATGROUP.CATGROUP_ID

END_XPATH_TO_SQL_STATEMENT

<!-- ============================================================= -->
<!-- This SQL will return the catalog groups to which the          -->
<!-- specified attachment is associated.                           -->
<!-- The access profiles that apply to this SQL are:               -->
<!-- IBM_Admin_CatalogGroupDescription 				   -->
<!-- IBM_Admin_CatalogGroupAttachmentReference                     -->
<!-- @param UniqueID The identifier of the attachment              -->
<!-- @param Context:StoreID - The store for which to retrieve the  -->
<!--        catalog group. This parameter is retrieved from within -->
<!--	      the business context.           	                     -->
<!-- ============================================================= -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogGroup[AttachmentReference[AttachmentIdentifier[(UniqueID=)]]]
	base_table=CATGROUP
	sql=
		SELECT
				DISTINCT(CATGROUP.$COLS:CATGROUP_ID$)
		FROM
				CATGROUP
            JOIN STORECGRP ON (CATGROUP.CATGROUP_ID = STORECGRP.CATGROUP_ID AND
                               STORECGRP.STOREENT_ID IN ($STOREPATH:catalog$))
				    JOIN ATCHREL ON ATCHREL.BIGINTOBJECT_ID = CATGROUP.CATGROUP_ID
				    JOIN ATCHOBJTYP ON (ATCHREL.ATCHOBJTYP_ID = ATCHOBJTYP.ATCHOBJTYP_ID AND ATCHOBJTYP.IDENTIFIER = 'CATGROUP')
    WHERE
        ATCHREL.ATCHTGT_ID IN (?UniqueID?)


END_XPATH_TO_SQL_STATEMENT


<!-- ==============================================================	-->
<!-- This SQL will return the elements of the Catalog Group			-->
<!-- noun(s) in the store.											-->
<!-- The access profiles that apply to this SQL are:				-->
<!-- IBM_Admin_DataExtract											-->
<!-- @param UniqueID - The store for which to retrieve the			-->
<!--        catalog group.											-->
<!-- ==============================================================	-->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogGroup[CatalogGroupIdentifier[ExternalIdentifier[StoreIdentifier[(UniqueID=)]]]]
	base_table=CATGROUP
	className=com.ibm.commerce.catalog.facade.server.services.dataaccess.db.jdbc.CatalogGroupDataExtractSQLComposer
	sql=
		SELECT
				CATGROUP.$COLS:CATGROUP_ID$
		FROM
				(
				SELECT
						CATGROUP.$COLS:CATGROUP_ID$
				FROM
						CATGROUP
						JOIN
						CATTOGRP ON (CATTOGRP.CATALOG_ID = $CTX:CATALOG_ID$ AND CATTOGRP.CATGROUP_ID = CATGROUP.CATGROUP_ID)
				WHERE
						CATGROUP.MARKFORDELETE=0
				UNION
				SELECT
						CATGROUP.$COLS:CATGROUP_ID$
				FROM
						CATGROUP
						JOIN
						CATGRPREL ON (CATGRPREL.CATALOG_ID = $CTX:CATALOG_ID$ AND CATGRPREL.CATGROUP_ID_CHILD = CATGROUP.CATGROUP_ID)
				WHERE
						CATGROUP.MARKFORDELETE=0
				)CATGROUP
				JOIN
				STORECGRP ON (CATGROUP.CATGROUP_ID = STORECGRP.CATGROUP_ID AND STORECGRP.STOREENT_ID IN (?UniqueID?))

END_XPATH_TO_SQL_STATEMENT




<!-- ========================================================================= -->
<!-- =============================ASSOCIATION QUERIES========================= -->
<!-- ========================================================================= -->

<!-- =============================================================================
     Adds store identifier (STORECENT table) of catalog entry to the
     resultant data graph.
     ============================================================================= -->

BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_CatalogGroupStoreIdentifier
	base_table=STORECGRP
	param=versionable
	sql=

		SELECT
			STORECGRP.$COLS:STORECGRP:CATGROUP_ID$,
			STORECGRP.$COLS:STORECGRP:STOREENT_ID$
		FROM
			STORECGRP
		WHERE
			STORECGRP.CATGROUP_ID IN ($UNIQUE_IDS$) AND
			STORECGRP.STOREENT_ID IN ($STOREPATH:catalog$)
END_ASSOCIATION_SQL_STATEMENT

<!-- ========================================================= -->
<!-- This associated SQL:                                      -->
<!-- Adds Base Catgroup Info with summary                      -->
<!-- to the resultant data graph.                              -->
<!-- ========================================================= -->
BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_RootCatalogGroupWithSummary
	base_table=CATGROUP
	additional_entity_objects=true
	param=versionable
	sql=
		SELECT
				CATGROUP.$COLS:CATGROUP_ID$, CATGROUP.$COLS:CATGROUP:MEMBER_ID$, CATGROUP.$COLS:CATGROUP:IDENTIFIER$,
				CATGRPDESC.$COLS:CATGRPDESC:CATGROUP_ID$, CATGRPDESC.$COLS:CATGRPDESC:LANGUAGE_ID$,
				CATGRPDESC.$COLS:CATGRPDESC:NAME$, CATGRPDESC.$COLS:CATGRPDESC:THUMBNAIL$,
				CATGRPDESC.$COLS:CATGRPDESC:SHORTDESCRIPTION$
		FROM
				CATGROUP
				 LEFT OUTER JOIN
				CATGRPDESC ON
					 (CATGROUP.CATGROUP_ID = CATGRPDESC.CATGROUP_ID AND
					  CATGRPDESC.LANGUAGE_ID IN ($CONTROL:LANGUAGES$))
		WHERE
                CATGROUP.CATGROUP_ID IN ($ENTITY_PKS$)
END_ASSOCIATION_SQL_STATEMENT


<!-- ========================================================= -->
<!-- This associated SQL:                                      -->
<!-- Adds Catgroup Parent Relations                            -->
<!-- to the resultant data graph.                              -->
<!-- ========================================================= -->
BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_CatalogGroupParentRelationShips
	base_table=CATGRPREL
	param=versionable
	sql=
		SELECT
				CATGRPREL.$COLS:CATGRPREL$
		FROM
				CATGRPREL
		WHERE
				CATGRPREL.CATGROUP_ID_CHILD IN ($UNIQUE_IDS$) AND
				(CATGRPREL.CATALOG_ID = $CTX:CATALOG_ID$ OR CATALOG_ID_LINK IS NULL)

END_ASSOCIATION_SQL_STATEMENT

<!-- ==========================================================
     Adds identifiers (CATGROUP, STORECGRP) of catalog groups
     to the resultant data graph.
     ========================================================== -->

BEGIN_ASSOCIATION_SQL_STATEMENT
    name=IBM_CatalogGroupIdentifier
	base_table=CATGROUP
	sql=

		SELECT
			CATGROUP.$COLS:CATGROUP_ID$,
			CATGROUP.$COLS:CATGROUP:MEMBER_ID$,
			CATGROUP.$COLS:CATGROUP:IDENTIFIER$,
			STORECGRP.$COLS:STORECGRP:CATGROUP_ID$,
			STORECGRP.$COLS:STORECGRP:STOREENT_ID$
		FROM
			CATGROUP,STORECGRP
		WHERE
			CATGROUP.CATGROUP_ID IN ($UNIQUE_IDS$) AND CATGROUP.MARKFORDELETE = 0 AND
			CATGROUP.CATGROUP_ID = STORECGRP.CATGROUP_ID AND STORECGRP.STOREENT_ID IN ($STOREPATH:catalog$)

END_ASSOCIATION_SQL_STATEMENT

<!-- ========================================================= -->
<!-- This associated SQL:                                      -->
<!-- Adds Catgroup Children Relations                          -->
<!-- to the resultant data graph.                              -->
<!-- ========================================================= -->
BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_CatalogGroupChildrenRelationShips
	base_table=CATGROUP
	additional_entity_objects=true
	sql=
		SELECT
				CATGROUP.$COLS:CATGROUP$,
				CATGROUP_CHILD.$COLS:CATGROUP_ID$, CATGROUP_CHILD.$COLS:CATGROUP:MEMBER_ID$,
				CATGROUP_CHILD.$COLS:CATGROUP:IDENTIFIER$,
				CATGRPREL.$COLS:CATGRPREL$,
				CATGRPDESC.$COLS:CATGRPDESC:NAME$,CATGRPDESC.$COLS:CATGRPDESC:CATGROUP_ID$,
				CATGRPDESC.$COLS:CATGRPDESC:LANGUAGE_ID$,
				STORECGRP.$COLS:STORECGRP$
		FROM
				CATGROUP,
				CATGROUP CATGROUP_CHILD
				 JOIN
				CATGRPREL ON
				 	 (CATGROUP_CHILD.CATGROUP_ID = CATGRPREL.CATGROUP_ID_CHILD AND
				 	  CATGRPREL.CATALOG_ID = $CTX:CATALOG_ID$)
				 LEFT OUTER JOIN
				CATGRPDESC ON
					 (CATGROUP_CHILD.CATGROUP_ID = CATGRPDESC.CATGROUP_ID AND
					  CATGRPDESC.LANGUAGE_ID IN ($CONTROL:LANGUAGES$))
				 JOIN
                            	STORECGRP ON
                            		(CATGROUP_CHILD.CATGROUP_ID = STORECGRP.CATGROUP_ID AND
                            	 	 STORECGRP.STOREENT_ID IN ($STOREPATH:catalog$))

		WHERE
				CATGROUP.CATGROUP_ID IN ($ENTITY_PKS$) AND
                		CATGRPREL.CATGROUP_ID_PARENT = CATGROUP.CATGROUP_ID AND
				CATGROUP.MARKFORDELETE = 0 AND
				CATGROUP_CHILD.MARKFORDELETE = 0
END_ASSOCIATION_SQL_STATEMENT


<!-- ========================================================= -->
<!-- This associated SQL:                                      -->
<!-- Adds Catentry Children Relations                          -->
<!-- to the resultant data graph.                              -->
<!-- ========================================================= -->
BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_CatalogEntryChildrenRelationShips
	base_table=CATGROUP
	additional_entity_objects=true
	sql=
		SELECT
				CATGROUP.$COLS:CATGROUP$,
				CATENTRY.$COLS:CATENTRY_ID$, CATENTRY.$COLS:CATENTRY:MEMBER_ID$,
				CATENTRY.$COLS:CATENTRY:CATENTTYPE_ID$, CATENTRY.$COLS:CATENTRY:PARTNUMBER$,
				CATGPENREL.$COLS:CATGPENREL$,
				CATENTDESC.$COLS:CATENTDESC:CATENTRY_ID$, CATENTDESC.$COLS:CATENTDESC:LANGUAGE_ID$,
				CATENTDESC.$COLS:CATENTDESC:NAME$,
				STORECENT.$COLS:STORECENT$
		FROM
				CATGROUP
				 JOIN
				CATGPENREL ON
					(CATGROUP.CATGROUP_ID = CATGPENREL.CATGROUP_ID AND
					 CATGPENREL.CATALOG_ID = $CTX:CATALOG_ID$)
				 JOIN
				CATENTRY ON
					(CATENTRY.CATENTRY_ID = CATGPENREL.CATENTRY_ID)
				 LEFT OUTER JOIN
				CATENTDESC ON
					(CATENTRY.CATENTRY_ID = CATENTDESC.CATENTRY_ID AND
					 CATENTDESC.LANGUAGE_ID IN ($CONTROL:LANGUAGES$))
				 LEFT OUTER JOIN
				CATENTREL ON
					(CATENTREL.CATENTRY_ID_CHILD = CATENTRY.CATENTRY_ID AND
					 CATENTREL.CATRELTYPE_ID = 'PRODUCT_ITEM')
				 JOIN
				STORECENT ON (CATENTRY.CATENTRY_ID = STORECENT.CATENTRY_ID AND
  					      STORECENT.STOREENT_ID IN ($STOREPATH:catalog$))
		WHERE
				CATGROUP.CATGROUP_ID IN ($ENTITY_PKS$) AND
                		CATGPENREL.CATGROUP_ID = CATGROUP.CATGROUP_ID AND
				CATENTRY.MARKFORDELETE = 0 AND
				NOT
					(
						CATENTRY.CATENTTYPE_ID = 'ItemBean' AND
						CATENTREL.CATENTRY_ID_CHILD IS NOT NULL
					)
END_ASSOCIATION_SQL_STATEMENT


<!-- ========================================================= -->
<!-- This associated SQL:                                      -->
<!-- Adds merchandising associations info                      -->
<!-- to the resultant data graph.                              -->
<!-- ========================================================= -->
BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_CatalogGroupMerchandisingAssociations
	base_table=CATGROUP
	additional_entity_objects=true
	sql=
		SELECT
			CATGROUP.$COLS:CATGROUP$,
			CATGRPDESC.$COLS:CATGRPDESC$,
			MASSOCGPGP.$COLS:MASSOCGPGP$,
			CATGROUP_TO.$COLS:CATGROUP$,
			STORECGRP.$COLS:STORECGRP$
		FROM
			CATGROUP,
			MASSOCGPGP
  		         LEFT OUTER JOIN
  		        CATGRPDESC ON
  		        	(CATGRPDESC.CATGROUP_ID = MASSOCGPGP.CATGROUP_ID_TO AND
  		         	 CATGRPDESC.LANGUAGE_ID IN ($CONTROL:LANGUAGES$))
			 JOIN
			CATGROUP CATGROUP_TO ON
				(CATGROUP_TO.CATGROUP_ID = MASSOCGPGP.CATGROUP_ID_TO)
			 JOIN
                       	STORECGRP ON
                       		(CATGROUP_TO.CATGROUP_ID = STORECGRP.CATGROUP_ID AND
                       	 	 STORECGRP.STOREENT_ID IN ($STOREPATH:catalog$))
        	WHERE
        		CATGROUP.CATGROUP_ID IN ($ENTITY_PKS$) AND
               		MASSOCGPGP.CATGROUP_ID_FROM = CATGROUP.CATGROUP_ID AND
               		MASSOCGPGP.STORE_ID IN ($STOREPATH:catalog$) AND
               		CATGROUP.MARKFORDELETE = 0 AND
               		CATGROUP_TO.MARKFORDELETE = 0
END_ASSOCIATION_SQL_STATEMENT




<!-- ========================================================= -->
<!-- This associated SQL:                                      -->
<!-- Adds Base Catgroup Info with top catgroup                 -->
<!-- to the resultant data graph.                              -->
<!-- ========================================================= -->
BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_RootCatalogGroupWithTopCatGroup
	base_table=CATGROUP
	additional_entity_objects=true
	sql=
		SELECT
				CATGROUP.$COLS:CATGROUP$,
				CATTOGRP.$COLS:CATTOGRP$
		FROM
				CATGROUP
				 LEFT OUTER JOIN
				CATTOGRP ON
					(CATGROUP.CATGROUP_ID = CATTOGRP.CATGROUP_ID AND
					 CATTOGRP.CATALOG_ID = $CTX:CATALOG_ID$)
		WHERE
                CATGROUP.CATGROUP_ID IN ($ENTITY_PKS$)
END_ASSOCIATION_SQL_STATEMENT


<!-- ========================================================= -->
<!-- This associated SQL:                                      -->
<!-- Adds Base Catgroup Info with description                  -->
<!-- to the resultant data graph.                              -->
<!-- ========================================================= -->
BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_RootCatalogGroupWithDescriptionWithTopCatGroup
	base_table=CATGROUP
	additional_entity_objects=true
	param=versionable
	sql=
		SELECT
				CATGROUP.$COLS:CATGROUP$,
				CATGRPDESC.$COLS:CATGRPDESC$,
				CATTOGRP.$COLS:CATTOGRP$
		FROM
				CATGROUP
				 LEFT OUTER JOIN
				CATGRPDESC ON
					 (CATGROUP.CATGROUP_ID = CATGRPDESC.CATGROUP_ID AND
					  CATGRPDESC.LANGUAGE_ID IN ($CONTROL:LANGUAGES$))
				 LEFT OUTER JOIN
				CATTOGRP ON
					(CATGROUP.CATGROUP_ID = CATTOGRP.CATGROUP_ID AND
					 (CATTOGRP.CATALOG_ID = $CTX:CATALOG_ID$ OR CATTOGRP.CATALOG_ID_LINK IS NULL))
		WHERE
                CATGROUP.CATGROUP_ID IN ($ENTITY_PKS$)
END_ASSOCIATION_SQL_STATEMENT


<!-- ========================================================= -->
<!-- This associated SQL:                                      -->
<!-- Adds Base Catgroup Info with summary                      -->
<!-- to the resultant data graph.                              -->
<!-- ========================================================= -->
BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_RootCatalogGroupWithSummaryWithTopCatGroup
	base_table=CATGROUP
	additional_entity_objects=true
	sql=
		SELECT
				CATGROUP.$COLS:CATGROUP_ID$, CATGROUP.$COLS:CATGROUP:MEMBER_ID$, CATGROUP.$COLS:CATGROUP:IDENTIFIER$,
				CATGRPDESC.$COLS:CATGRPDESC:CATGROUP_ID$, CATGRPDESC.$COLS:CATGRPDESC:LANGUAGE_ID$,
				CATGRPDESC.$COLS:CATGRPDESC:NAME$, CATGRPDESC.$COLS:CATGRPDESC:THUMBNAIL$,
				CATGRPDESC.$COLS:CATGRPDESC:SHORTDESCRIPTION$,
				CATTOGRP.$COLS:CATTOGRP$
		FROM
				CATGROUP
				 LEFT OUTER JOIN
				CATGRPDESC ON
					 (CATGROUP.CATGROUP_ID = CATGRPDESC.CATGROUP_ID AND
					  CATGRPDESC.LANGUAGE_ID IN ($CONTROL:LANGUAGES$))
				 LEFT OUTER JOIN
				CATTOGRP ON
					(CATGROUP.CATGROUP_ID = CATTOGRP.CATGROUP_ID AND
					 CATTOGRP.CATALOG_ID = $CTX:CATALOG_ID$)
		WHERE
                CATGROUP.CATGROUP_ID IN ($ENTITY_PKS$)
END_ASSOCIATION_SQL_STATEMENT

<!-- ============================================================ -->
<!-- This associated SQL:                                         -->
<!-- Adds Attachment Reference Description Info                   -->
<!-- to the resultant data graph.                                 -->
<!-- ============================================================ -->
BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_CatalogGroupAttachmentReferenceDescription
	base_table=CATGROUP
	additional_entity_objects=true
	param=versionable
	sql=
		SELECT
				CATGROUP.$COLS:CATGROUP_ID$, ATCHREL.$COLS:ATCHREL$, ATCHRLUS.$COLS:ATCHRLUS$, ATCHRELDSC.$COLS:ATCHRELDSC$
		FROM
				CATGROUP
				JOIN STORECGRP ON (CATGROUP.CATGROUP_ID = STORECGRP.CATGROUP_ID AND
                            	   STORECGRP.STOREENT_ID IN ($STOREPATH:catalog$))
				JOIN ATCHREL ON ATCHREL.BIGINTOBJECT_ID = CATGROUP.CATGROUP_ID
				JOIN ATCHRLUS ON ATCHREL.ATCHRLUS_ID = ATCHRLUS.ATCHRLUS_ID
				JOIN ATCHOBJTYP ON (ATCHREL.ATCHOBJTYP_ID = ATCHOBJTYP.ATCHOBJTYP_ID AND ATCHOBJTYP.IDENTIFIER = 'CATGROUP')
				LEFT OUTER JOIN ATCHRELDSC ON (ATCHREL.ATCHREL_ID = ATCHRELDSC.ATCHREL_ID AND ATCHRELDSC.LANGUAGE_ID IN ($CONTROL:LANGUAGES$))
		WHERE
        CATGROUP.CATGROUP_ID IN ($ENTITY_PKS$)

END_ASSOCIATION_SQL_STATEMENT


<!-- ========================================================= -->
<!-- This associated SQL:                                      -->
<!-- Adds Base Catgroup Info with description                  -->
<!-- to the resultant data graph.                              -->
<!-- ========================================================= -->
BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_RootCatalogGroupWithAllDescriptions
	base_table=CATGROUP
	additional_entity_objects=true
	sql=
		SELECT
				CATGROUP.$COLS:CATGROUP$,
				CATGRPDESC.$COLS:CATGRPDESC$,
				CATTOGRP.$COLS:CATTOGRP$
		FROM
				CATGROUP
				 LEFT OUTER JOIN
				CATGRPDESC ON
					 (CATGROUP.CATGROUP_ID = CATGRPDESC.CATGROUP_ID)
				 LEFT OUTER JOIN
				CATTOGRP ON
					(CATGROUP.CATGROUP_ID = CATTOGRP.CATGROUP_ID AND
					 CATTOGRP.CATALOG_ID = $CTX:CATALOG_ID$)
		WHERE
                CATGROUP.CATGROUP_ID IN ($ENTITY_PKS$)
END_ASSOCIATION_SQL_STATEMENT


<!-- ========================================================= -->
<!-- This associated SQL:                                      -->
<!-- Adds Base Catgroup Info with description                  -->
<!-- to the resultant data graph.                              -->
<!-- ========================================================= -->
BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_RootCatalogGroupWithDescriptions
	base_table=CATGROUP
	additional_entity_objects=true
	param=versionable
	sql=
		SELECT
				CATGROUP.$COLS:CATGROUP$,
				CATGRPDESC.$COLS:CATGRPDESC$,
				CATTOGRP.$COLS:CATTOGRP$
		FROM
				CATGROUP
				 LEFT OUTER JOIN
				CATGRPDESC ON
					 (CATGROUP.CATGROUP_ID = CATGRPDESC.CATGROUP_ID AND
					  CATGRPDESC.LANGUAGE_ID IN ($CONTROL:LANGUAGES$))
				 LEFT OUTER JOIN
				CATTOGRP ON
					(CATGROUP.CATGROUP_ID = CATTOGRP.CATGROUP_ID AND
					 CATTOGRP.CATALOG_ID = $CTX:CATALOG_ID$)
		WHERE
                CATGROUP.CATGROUP_ID IN ($ENTITY_PKS$)
END_ASSOCIATION_SQL_STATEMENT

<!-- ========================================================= -->
<!-- This associated SQL:                                      -->
<!-- Adds Base Catgroup Info with description                  -->
<!-- to the resultant data graph.                              -->
<!-- ========================================================= -->
BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_RootCatalogGroup
	base_table=CATGROUP
	additional_entity_objects=true
	sql=
		SELECT
				CATGROUP.$COLS:CATGROUP$,
				CATTOGRP.$COLS:CATTOGRP$
		FROM
				CATGROUP
				 LEFT OUTER JOIN
				CATTOGRP ON
					(CATGROUP.CATGROUP_ID = CATTOGRP.CATGROUP_ID AND
					 CATTOGRP.CATALOG_ID = $CTX:CATALOG_ID$)
		WHERE
                CATGROUP.CATGROUP_ID IN ($ENTITY_PKS$)
END_ASSOCIATION_SQL_STATEMENT


<!-- ========================================================= -->
<!-- This associated SQL:                                      -->
<!-- Adds Base Catgroup Info with description                  -->
<!-- to the resultant data graph.                              -->
<!-- ========================================================= -->
BEGIN_ASSOCIATION_SQL_STATEMENT
        name=IBM_RootCatalogGroupWithDescriptionsAllLanguages
        base_table=CATGROUP
        additional_entity_objects=true
        param=versionable
        sql=
                SELECT
                                CATGROUP.$COLS:CATGROUP$,
                                CATGRPDESC.$COLS:CATGRPDESC$,
                                CATTOGRP.$COLS:CATTOGRP$
                FROM
                                CATGROUP
                                 LEFT OUTER JOIN
                                CATGRPDESC ON
                                         (CATGROUP.CATGROUP_ID = CATGRPDESC.CATGROUP_ID)
                                 LEFT OUTER JOIN
                                CATTOGRP ON
                                        (CATGROUP.CATGROUP_ID = CATTOGRP.CATGROUP_ID AND
                                         CATTOGRP.CATALOG_ID = $CTX:CATALOG_ID$)

                WHERE
                CATGROUP.CATGROUP_ID IN ($ENTITY_PKS$)
END_ASSOCIATION_SQL_STATEMENT



<!-- ==========================================================
     Adds calculation codes (CATGPCALCD) of catalog groups
     to the resultant data graph.
     ========================================================== -->

BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_CatalogGroupCalculationCode
	base_table=CATGPCALCD
	sql=
		SELECT
			CATGPCALCD.$COLS:CATGPCALCD$, CALCODE.$COLS:CALCODE$
		FROM
			CATGPCALCD, CALCODE
		WHERE
			CALCODE.CALCODE_ID = CATGPCALCD.CALCODE_ID AND
			CATGPCALCD.STORE_ID = $CTX:STORE_ID$ AND
			CATGPCALCD.CATGROUP_ID IN ($UNIQUE_IDS$)
END_ASSOCIATION_SQL_STATEMENT

<!-- ==========================================================
     Adds rules (CATGRPRULE) of catalog groups
     to the resultant data graph.
     ========================================================== -->

BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_CatalogGroupRule
	base_table=CATGRPRULE
	sql=
		SELECT
			CATGRPRULE.$COLS:CATGRPRULE$
		FROM
			CATGRPRULE
		WHERE
			CATGRPRULE.CATGROUP_ID IN ($UNIQUE_IDS$)
END_ASSOCIATION_SQL_STATEMENT

<!-- ========================================================= -->
<!-- Fetches external-content relationship for given catentry  -->
<!--   within current store into resultant graph               -->
<!-- ========================================================= -->
BEGIN_ASSOCIATION_SQL_STATEMENT
  name=IBM_CatalogGroupExternalContentRel
  base_table=CATGROUP_EXTERNAL_CONTENT_REL
  additional_entity_objects=true
  param=versionable
  sql=SELECT CATGROUP_EXTERNAL_CONTENT_REL.$COLS:CATGROUP_EXTERNAL_CONTENT_REL:CG_EXTERNAL_CONTENT_REL_ID$,
 							CATGROUP_EXTERNAL_CONTENT_REL.$COLS:CATGROUP_EXTERNAL_CONTENT_REL:CATGROUP_ID$,
 							CATGROUP_EXTERNAL_CONTENT_REL.$COLS:CATGROUP_EXTERNAL_CONTENT_REL:CATOVRGRP_ID$,
							CATGROUP_EXTERNAL_CONTENT_REL.$COLS:CATGROUP_EXTERNAL_CONTENT_REL:LANGUAGE_ID$,
							CATGROUP_EXTERNAL_CONTENT_REL.$COLS:CATGROUP_EXTERNAL_CONTENT_REL:CONTENT_ID$,
							CATGROUP_EXTERNAL_CONTENT_REL.$COLS:CATGROUP_EXTERNAL_CONTENT_REL:TYPE$,
							CATGROUP_EXTERNAL_CONTENT_REL.$COLS:CATGROUP_EXTERNAL_CONTENT_REL:FIELD1$,
							CATGROUP_EXTERNAL_CONTENT_REL.$COLS:CATGROUP_EXTERNAL_CONTENT_REL:FIELD2$,
							CATGROUP_EXTERNAL_CONTENT_REL.$COLS:CATGROUP_EXTERNAL_CONTENT_REL:FIELD3$,
							CATGROUP_EXTERNAL_CONTENT_REL.$COLS:CATGROUP_EXTERNAL_CONTENT_REL:OPTCOUNTER$
      FROM   CATGROUP_EXTERNAL_CONTENT_REL
				JOIN STORECATOVRGRP ON CATGROUP_EXTERNAL_CONTENT_REL.CATOVRGRP_ID=STORECATOVRGRP.CATOVRGRP_ID 
							AND STORECATOVRGRP.STOREENT_ID IN ($STOREPATH:catalog$) 	
				JOIN STORELANG ON CATGROUP_EXTERNAL_CONTENT_REL.LANGUAGE_ID=STORELANG.LANGUAGE_ID AND STORELANG.STOREENT_ID=$CTX:STORE_ID$
      WHERE CATGROUP_ID IN ($UNIQUE_IDS$)  
END_ASSOCIATION_SQL_STATEMENT

<!-- ========================================================= -->
<!-- Fetches external-content into resultant graph             -->
<!-- ========================================================= -->
BEGIN_ASSOCIATION_SQL_STATEMENT
  name=IBM_CG_ExternalContent
  base_table=EXTERNAL_CONTENT
  additional_entity_objects=true
  param=versionable
  sql=SELECT $COLS:EXTERNAL_CONTENT$
      FROM   EXTERNAL_CONTENT
      WHERE  CONTENT_ID IN ($UNIQUE_IDS$)
END_ASSOCIATION_SQL_STATEMENT

<!-- ========================================================= -->
<!-- Fetches external-content assets into resultant graph      -->
<!-- ========================================================= -->
BEGIN_ASSOCIATION_SQL_STATEMENT
  name=IBM_CG_ExternalContentAssets
  base_table=EXTERNAL_CONTENT_ASSET
  additional_entity_objects=true
  param=versionable
  sql=SELECT $COLS:EXTERNAL_CONTENT_ASSET$
      FROM   EXTERNAL_CONTENT_ASSET
      WHERE  CONTENT_ID IN ($UNIQUE_IDS$)
END_ASSOCIATION_SQL_STATEMENT

<!-- ========================================================================= -->
<!-- =============================PROFILE DEFINITIONS========================= -->
<!-- ========================================================================= -->

BEGIN_PROFILE
	name=IBM_Admin_CatalogGroupFacets
	BEGIN_ENTITY
	  base_table=CATGROUP
	  className=com.ibm.commerce.catalog.facade.server.services.dataaccess.graphbuilderservice.CatalogGroupGraphComposer
      associated_sql_statement=IBM_RootCatalogGroup
      associated_sql_statement=IBM_CatalogGroupStoreIdentifier
    END_ENTITY
END_PROFILE

BEGIN_PROFILE
	name=IBM_Admin_SEO
	BEGIN_ENTITY
	  base_table=CATGROUP
	  className=com.ibm.commerce.catalog.facade.server.services.dataaccess.graphbuilderservice.CatalogGroupGraphComposer
      associated_sql_statement=IBM_RootCatalogGroup
      associated_sql_statement=IBM_CatalogGroupStoreIdentifier
      associated_sql_statement=IBM_RootCatalogGroupWithDescriptions
    END_ENTITY
END_PROFILE

<!-- ========================================================= -->
<!-- Catalog Group Details Access Profile.                     -->
<!-- This profile returns the following info:                  -->
<!-- 	1) Catalog Group with description.                     -->
<!-- 	2) Catalog Group top catalog group.                    -->
<!-- 	3) Catalog Group parent catalog group.                 -->
<!-- ========================================================= -->
BEGIN_PROFILE
	name=IBM_Admin_DataExtract
	BEGIN_ENTITY
	  base_table=CATGROUP
	  className=com.ibm.commerce.catalog.facade.server.services.dataaccess.graphbuilderservice.CatalogGroupGraphComposer
      associated_sql_statement=IBM_RootCatalogGroupWithDescriptions
      associated_sql_statement=IBM_CatalogGroupStoreIdentifier
      associated_sql_statement=IBM_CatalogGroupParentRelationShips
      associated_sql_statement=IBM_CatalogGroupIdentifier
    END_ENTITY
END_PROFILE

<!-- ========================================================= -->
<!-- Catalog Group Summary Access Profile.                     -->
<!-- This profile returns the following info:                  -->
<!-- 	1) Catalog Group with description summary.             -->
<!-- 	2) Catalog Group top catalog group.                    -->
<!-- 	3) Catalog Group parent catalog group.                 -->
<!-- ========================================================= -->
BEGIN_PROFILE
  name=IBM_Admin_Summary
  BEGIN_ENTITY
    base_table=CATGROUP
    className=com.ibm.commerce.catalog.facade.server.services.dataaccess.graphbuilderservice.CatalogGroupGraphComposer
    associated_sql_statement=IBM_RootCatalogGroupWithSummaryWithTopCatGroup
    associated_sql_statement=IBM_CatalogGroupStoreIdentifier
    associated_sql_statement=IBM_CatalogGroupParentRelationShips
    associated_sql_statement=IBM_CatalogGroupIdentifier
    associated_sql_statement=IBM_CatalogGroupCalculationCode
    associated_sql_statement=IBM_CatalogGroupExternalContentRel
    associated_sql_statement=IBM_CG_ExternalContent
    associated_sql_statement=IBM_CG_ExternalContentAssets
  END_ENTITY
END_PROFILE

<!-- ========================================================= -->
<!-- Catalog Group Summary Access Profile with breadcrumb information. -->
<!-- This profile returns the following info:                  -->
<!-- 	1) Catalog Group with description summary.             -->
<!-- 	2) Catalog Group top catalog group.                    -->
<!-- 	3) Catalog Group parent catalog group.                 -->
<!-- ========================================================= -->
BEGIN_PROFILE
	name=IBM_Admin_Summary_Breadcrumb
	BEGIN_ENTITY
	  base_table=CATGROUP
	  className=com.ibm.commerce.catalog.facade.server.services.dataaccess.graphbuilderservice.CatalogGroupGraphComposer
      associated_sql_statement=IBM_RootCatalogGroupWithSummaryWithTopCatGroup
      associated_sql_statement=IBM_CatalogGroupStoreIdentifier
	  associated_sql_statement=IBM_CatalogGroupIdentifier
    END_ENTITY
END_PROFILE

<!-- ========================================================= -->
<!-- Catalog Group Rule Access Profile.                        -->
<!-- This profile returns the following info:                  -->
<!-- 	1) Catalog Group with description.                     -->
<!-- 	2) Catalog Group top catalog group.                    -->
<!-- 	3) Catalog Group parent catalog group.                 -->
<!-- 	4) Catalog Group rule.                 				   -->
<!-- ========================================================= -->
BEGIN_PROFILE
	name=IBM_Admin_CatalogGroupRule
	BEGIN_ENTITY
	  base_table=CATGROUP
	  className=com.ibm.commerce.catalog.facade.server.services.dataaccess.graphbuilderservice.CatalogGroupGraphComposer
      associated_sql_statement=IBM_RootCatalogGroupWithDescriptionWithTopCatGroup
      associated_sql_statement=IBM_CatalogGroupStoreIdentifier
      associated_sql_statement=IBM_CatalogGroupParentRelationShips
      associated_sql_statement=IBM_CatalogGroupIdentifier
      associated_sql_statement=IBM_CatalogGroupRule
    END_ENTITY
END_PROFILE

<!-- ========================================================= -->
<!-- Catalog Group Details Access Profile.                     -->
<!-- This profile returns the following info:                  -->
<!-- 	1) Catalog Group with description.                     -->
<!-- 	2) Catalog Group top catalog group.                    -->
<!-- 	3) Catalog Group parent catalog group.                 -->
<!-- ========================================================= -->
BEGIN_PROFILE
  name=IBM_Admin_Details
  BEGIN_ENTITY
    base_table=CATGROUP
    className=com.ibm.commerce.catalog.facade.server.services.dataaccess.graphbuilderservice.CatalogGroupGraphComposer
    associated_sql_statement=IBM_RootCatalogGroupWithDescriptionWithTopCatGroup
    associated_sql_statement=IBM_CatalogGroupStoreIdentifier
    associated_sql_statement=IBM_CatalogGroupParentRelationShips
    associated_sql_statement=IBM_CatalogGroupIdentifier
    associated_sql_statement=IBM_CatalogGroupCalculationCode
    associated_sql_statement=IBM_CatalogGroupRule
    associated_sql_statement=IBM_CatalogGroupExternalContentRel
    associated_sql_statement=IBM_CG_ExternalContent
    associated_sql_statement=IBM_CG_ExternalContentAssets
  END_ENTITY
END_PROFILE

<!-- ========================================================= -->
<!-- Catalog Group Details Access Profile with breadcrumb information. -->
<!-- This profile returns the following info:                  -->
<!-- 	1) Catalog Group with description.                     -->
<!-- 	2) Catalog Group top catalog group.                    -->
<!-- 	3) Catalog Group parent catalog group.                 -->
<!-- ========================================================= -->
BEGIN_PROFILE
	name=IBM_Admin_Details_Breadcrumb
	BEGIN_ENTITY
	  base_table=CATGROUP
	  className=com.ibm.commerce.catalog.facade.server.services.dataaccess.graphbuilderservice.CatalogGroupGraphComposer
      associated_sql_statement=IBM_RootCatalogGroupWithDescriptionWithTopCatGroup
      associated_sql_statement=IBM_CatalogGroupStoreIdentifier
      associated_sql_statement=IBM_CatalogGroupIdentifier
    END_ENTITY
END_PROFILE

<!-- ========================================================= -->
<!-- Catalog Group Merchandising Associations Access Profile.  -->
<!-- This profile returns the following info:                  -->
<!-- 	1) Catalog Group with description.                     -->
<!-- 	2) Catalog Group top catalog group.                    -->
<!-- 	3) Catalog Group parent catalog group.                 -->
<!-- 	4) Catalog Group merchandising associations.           -->
<!-- ========================================================= -->
BEGIN_PROFILE
	name=IBM_Admin_CatalogGroupMerchandisingAssociations
	BEGIN_ENTITY
	  base_table=CATGROUP
	  className=com.ibm.commerce.catalog.facade.server.services.dataaccess.graphbuilderservice.CatalogGroupGraphComposer
      associated_sql_statement=IBM_RootCatalogGroupWithDescriptionWithTopCatGroup
      associated_sql_statement=IBM_CatalogGroupStoreIdentifier
      associated_sql_statement=IBM_CatalogGroupParentRelationShips
      associated_sql_statement=IBM_CatalogGroupIdentifier
      associated_sql_statement=IBM_CatalogGroupMerchandisingAssociations
      associated_sql_statement=IBM_CatalogGroupCalculationCode
    END_ENTITY
END_PROFILE


<!-- ========================================================= -->
<!-- Catalog Group NavRel Catalog Group Access Profile.        -->
<!-- This profile returns the following info:                  -->
<!-- 	1) Catalog Group with description.                     -->
<!-- 	2) Catalog Group top catalog group.                    -->
<!-- 	3) Catalog Group parent catalog group.                 -->
<!-- 	4) Catalog Group children catalog groups.              -->
<!-- ========================================================= -->
BEGIN_PROFILE
	name=IBM_Admin_CatalogGroupNavRelCatalogGroup
	BEGIN_ENTITY
	  base_table=CATGROUP
	  className=com.ibm.commerce.catalog.facade.server.services.dataaccess.graphbuilderservice.CatalogGroupGraphComposer
      associated_sql_statement=IBM_RootCatalogGroupWithDescriptionWithTopCatGroup
      associated_sql_statement=IBM_CatalogGroupStoreIdentifier
      associated_sql_statement=IBM_CatalogGroupChildrenRelationShips
      associated_sql_statement=IBM_CatalogGroupParentRelationShips
      associated_sql_statement=IBM_CatalogGroupIdentifier
      associated_sql_statement=IBM_CatalogGroupCalculationCode
    END_ENTITY
END_PROFILE


<!-- ========================================================= -->
<!-- Catalog Group NavRel Catalog Entry Access Profile.        -->
<!-- This profile returns the following info:                  -->
<!-- 	1) Catalog Group with description.                     -->
<!-- 	2) Catalog Group top catalog group.                    -->
<!-- 	3) Catalog Group parent catalog group.                 -->
<!-- 	4) Catalog Group children catalog entries.             -->
<!-- ========================================================= -->
BEGIN_PROFILE
	name=IBM_Admin_CatalogGroupNavRelCatalogEntry
	BEGIN_ENTITY
	  base_table=CATGROUP
	  className=com.ibm.commerce.catalog.facade.server.services.dataaccess.graphbuilderservice.CatalogGroupGraphComposer
      associated_sql_statement=IBM_RootCatalogGroupWithDescriptionWithTopCatGroup
      associated_sql_statement=IBM_CatalogGroupStoreIdentifier
      associated_sql_statement=IBM_CatalogEntryChildrenRelationShips
      associated_sql_statement=IBM_CatalogGroupParentRelationShips
      associated_sql_statement=IBM_CatalogGroupIdentifier
      associated_sql_statement=IBM_CatalogGroupCalculationCode
    END_ENTITY
END_PROFILE


<!-- ========================================================= -->
<!-- Catalog Group NavRel All Access Profile.                  -->
<!-- This profile returns the following info:                  -->
<!-- 	1) Catalog Group with description.                     -->
<!-- 	2) Catalog Group top catalog group.                    -->
<!-- 	3) Catalog Group parent catalog group.                 -->
<!-- 	4) Catalog Group children catalog groups.              -->
<!-- 	5) Catalog Group children catalog entries.             -->
<!-- ========================================================= -->
BEGIN_PROFILE
	name=IBM_Admin_CatalogGroupNavRelAll
	BEGIN_ENTITY
	  base_table=CATGROUP
	  className=com.ibm.commerce.catalog.facade.server.services.dataaccess.graphbuilderservice.CatalogGroupGraphComposer
      associated_sql_statement=IBM_RootCatalogGroupWithDescriptionWithTopCatGroup
      associated_sql_statement=IBM_CatalogGroupStoreIdentifier
      associated_sql_statement=IBM_CatalogGroupChildrenRelationShips
      associated_sql_statement=IBM_CatalogEntryChildrenRelationShips
      associated_sql_statement=IBM_CatalogGroupParentRelationShips
      associated_sql_statement=IBM_CatalogGroupIdentifier
      associated_sql_statement=IBM_CatalogGroupCalculationCode
    END_ENTITY
END_PROFILE


<!-- ========================================================= -->
<!-- Catalog Group All Details Access Profile.                 -->
<!-- This profile returns the following info:                  -->
<!-- 	1) Catalog Group with description.                     -->
<!-- 	2) Catalog Group top catalog group.                    -->
<!-- 	3) Catalog Group parent catalog group.                 -->
<!-- 	4) Catalog Group children catalog groups.              -->
<!-- 	5) Catalog Group children catalog entries.             -->
<!-- 	6) Catalog Group merchandising associations.           -->
<!-- ========================================================= -->
BEGIN_PROFILE
  name=IBM_Admin_All
  BEGIN_ENTITY
    base_table=CATGROUP
    className=com.ibm.commerce.catalog.facade.server.services.dataaccess.graphbuilderservice.CatalogGroupGraphComposer
    associated_sql_statement=IBM_RootCatalogGroupWithDescriptionWithTopCatGroup
    associated_sql_statement=IBM_CatalogGroupStoreIdentifier
    associated_sql_statement=IBM_CatalogGroupChildrenRelationShips
    associated_sql_statement=IBM_CatalogEntryChildrenRelationShips
    associated_sql_statement=IBM_CatalogGroupParentRelationShips
    associated_sql_statement=IBM_CatalogGroupIdentifier
    associated_sql_statement=IBM_CatalogGroupMerchandisingAssociations
    associated_sql_statement=IBM_CatalogGroupCalculationCode
    associated_sql_statement=IBM_CatalogGroupRule
    associated_sql_statement=IBM_CatalogGroupExternalContentRel
    associated_sql_statement=IBM_CG_ExternalContent
    associated_sql_statement=IBM_CG_ExternalContentAssets
  END_ENTITY
END_PROFILE


<!-- ========================================================= -->
<!-- Catalog Group Sales Catalog References Access Profile.    -->
<!-- This profile returns the following info:                  -->
<!-- 	1) Catalog Group with description summary.             -->
<!-- 	2) Catalog Group sales catalog references.             -->
<!-- ========================================================= -->
BEGIN_PROFILE
	name=IBM_Admin_CatalogGroupSalesCatalogReference
	BEGIN_ENTITY
	  base_table=CATGROUP
	  className=com.ibm.commerce.catalog.facade.server.services.dataaccess.graphbuilderservice.CatalogGroupGraphComposer
      associated_sql_statement=IBM_RootCatalogGroupWithSummaryWithTopCatGroup
      associated_sql_statement=IBM_CatalogGroupStoreIdentifier
      associated_sql_statement=IBM_CatalogGroupCalculationCode
    END_ENTITY
END_PROFILE


<!-- ========================================================= -->
<!-- Catalog Group Descriptions Access Profile.                -->
<!-- This profile returns the following info:                  -->
<!-- 	1) Catalog Group with all descriptions.                -->
<!-- ========================================================= -->
BEGIN_PROFILE
  name=IBM_Admin_CatalogGroupAllDescriptions
  BEGIN_ENTITY
    base_table=CATGROUP
    className=com.ibm.commerce.catalog.facade.server.services.dataaccess.graphbuilderservice.CatalogGroupGraphComposer
    associated_sql_statement=IBM_RootCatalogGroupWithAllDescriptions
    associated_sql_statement=IBM_CatalogGroupStoreIdentifier
    associated_sql_statement=IBM_CatalogGroupCalculationCode
    associated_sql_statement=IBM_CatalogGroupExternalContentRel
    associated_sql_statement=IBM_CG_ExternalContent
    associated_sql_statement=IBM_CG_ExternalContentAssets
  END_ENTITY
END_PROFILE


<!-- ========================================================= -->
<!-- Catalog Group Descriptions Access Profile.                -->
<!-- This profile returns the following info:                  -->
<!-- 	1) Catalog Group with descriptions for languages.      -->
<!-- 	   passes in the control parameter 'LANGUAGES'.        -->
<!-- ========================================================= -->
BEGIN_PROFILE
  name=IBM_Admin_CatalogGroupDescription
  BEGIN_ENTITY
    base_table=CATGROUP
    className=com.ibm.commerce.catalog.facade.server.services.dataaccess.graphbuilderservice.CatalogGroupGraphComposer
    associated_sql_statement=IBM_RootCatalogGroupWithDescriptions
    associated_sql_statement=IBM_CatalogGroupStoreIdentifier
    associated_sql_statement=IBM_CatalogGroupCalculationCode
    associated_sql_statement=IBM_CatalogGroupExternalContentRel
    associated_sql_statement=IBM_CG_ExternalContent
    associated_sql_statement=IBM_CG_ExternalContentAssets
  END_ENTITY
END_PROFILE


<!-- ========================================================= -->
<!-- Catalog Group Parent Details Access Profile.              -->
<!-- This profile returns the following info:                  -->
<!-- 	1) Catalog Group with description.                     -->
<!-- 	2) Catalog Group top catalog group.                    -->
<!-- 	3) Catalog Group parent catalog groups in all catalogs.-->
<!-- ========================================================= -->
BEGIN_PROFILE
	name=IBM_Admin_CatalogGroupAllParentsDetails
	BEGIN_ENTITY
	  base_table=CATGROUP
	  className=com.ibm.commerce.catalog.facade.server.services.dataaccess.graphbuilderservice.CatalogGroupGraphComposer
      associated_sql_statement=IBM_RootCatalogGroupWithDescriptionWithTopCatGroup
      associated_sql_statement=IBM_CatalogGroupStoreIdentifier
      associated_sql_statement=IBM_CatalogGroupParentRelationShips
      associated_sql_statement=IBM_CatalogGroupIdentifier
      associated_sql_statement=IBM_CatalogGroupCalculationCode
      associated_sql_statement=IBM_CatalogGroupExternalContentRel
      associated_sql_statement=IBM_CG_ExternalContent
      associated_sql_statement=IBM_CG_ExternalContentAssets
    END_ENTITY
END_PROFILE

<!-- ========================================================= -->
<!-- Catalog Group Attachment References Access Profile.       -->
<!-- This profile returns the following info:                  -->
<!-- 	1) Catalog Group with attachment reference.              -->
<!-- 	2) Catalog Group with attachment reference description.  -->
<!-- ========================================================= -->
BEGIN_PROFILE
	name=IBM_Admin_CatalogGroupAttachmentReference
	BEGIN_ENTITY
	  base_table=CATGROUP
	  className=com.ibm.commerce.catalog.facade.server.services.dataaccess.graphbuilderservice.CatalogGroupGraphComposer
      associated_sql_statement=IBM_RootCatalogGroupWithDescriptions
      associated_sql_statement=IBM_CatalogGroupStoreIdentifier
      associated_sql_statement=IBM_CatalogGroupAttachmentReferenceDescription
      associated_sql_statement=IBM_CatalogGroupCalculationCode
	  associated_sql_statement=IBM_CatalogGroupParentRelationShips
      associated_sql_statement=IBM_CatalogGroupIdentifier
    END_ENTITY
END_PROFILE



<!-- ========================================================= -->
<!-- Catalog Group Access Profile Alias definition             -->
<!--                                                            -->
<!-- ========================================================= -->

BEGIN_PROFILE_ALIASES
  base_table=CATGROUP
  IBM_Summary=IBM_Admin_Summary
  IBM_Details=IBM_Admin_Details
  IBM_CatalogGroupMerchandisingAssociations=IBM_Admin_CatalogGroupMerchandisingAssociations
  IBM_CatalogGroupNavRelCatalogGroup=IBM_Admin_CatalogGroupNavRelCatalogGroup
  IBM_CatalogGroupNavRelCatalogEntry=IBM_Admin_CatalogGroupNavRelCatalogEntry
  IBM_CatalogGroupNavRelAll=IBM_Admin_CatalogGroupNavRelAll
  IBM_All=IBM_Admin_All
  IBM_CatalogGroupSalesCatalogReference=IBM_Admin_CatalogGroupSalesCatalogReference
  IBM_CatalogGroupAllDescriptions=IBM_Admin_CatalogGroupAllDescriptions
  IBM_CatalogGroupDescription=IBM_Admin_CatalogGroupDescription
  IBM_CatalogGroupAllParentsDetails=IBM_Admin_CatalogGroupAllParentsDetails
  IBM_SalesCatalogReferenceHelper=IBM_Admin_SalesCatalogReferenceHelper
  IBM_CatalogGroupAllParentsDetailsHelper=IBM_Admin_CatalogGroupAllParentsDetailsHelper
END_PROFILE_ALIASES


<!-- ===================================================================================== -->
<!-- ================================ GET CATGROUP ENDS ================================== -->
<!-- ===================================================================================== -->
