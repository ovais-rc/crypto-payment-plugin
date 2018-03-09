<!--********************************************************************-->
<!--  Licensed Materials - Property of IBM                              -->
<!--                                                                    -->
<!--  WebSphere Commerce                                                -->
<!--                                                                    -->
<!--  (c) Copyright IBM Corp. 2013, 2015                                -->
<!--                                                                    -->
<!--  US Government Users Restricted Rights - Use, duplication or       -->
<!--  disclosure restricted by GSA ADP Schedule Contract with IBM Corp. -->
<!--                                                                    -->
<!--********************************************************************-->
BEGIN_SYMBOL_DEFINITIONS

END_SYMBOL_DEFINITIONS

<!--==============================================================================-->
<!--  Get the promotion ID for a particular promotion.                            -->
<!--  @param PromotionName The administrative name of the promotion               -->
<!--==============================================================================-->
BEGIN_SQL_STATEMENT
  base_table=PX_PROMOAUTH
	name=IBM_Select_PromotionIdByAdministrativeName
	sql=SELECT PX_PROMOAUTH.PX_PROMOTION_ID FROM PX_PROMOAUTH, PX_PROMOTION 
	    WHERE PX_PROMOAUTH.ADMINSTVENAME  = ?PromotionName?
	    AND PX_PROMOAUTH.PX_PROMOTION_ID = PX_PROMOTION.PX_PROMOTION_ID
	    AND PX_PROMOTION.STOREENT_ID IN ($STOREPATH:promotions$)
	    AND PX_PROMOTION.STATUS IN (0,1,3)
END_SQL_STATEMENT      

<!--==============================================================================-->
<!--  Get the administrative name for this particular promotion id                -->
<!--                                                                              -->
<!--  @param promotionId                        	                              -->
<!--     The promotion id for which the administrative name need to be selected   -->
<!--==============================================================================-->
BEGIN_SQL_STATEMENT
  	base_table=PX_PROMOAUTH
	name=IBM_Select_PromotionAdminstrativeName
	sql=SELECT PX_PROMOAUTH.ADMINSTVENAME FROM PX_PROMOAUTH WHERE PX_PROMOTION_ID=?promotionId?
END_SQL_STATEMENT

<!-- ============================================================================== -->
<!--  Removes the promotion code export entry from the PROCESSFILE table            -->
<!--                                                                                -->
<!--  @param objectId                                                               -->
<!--     The promotionId whose promotion code exports need to be marked as 	        -->
<!--        deleted 																-->												
<!--  @param uploadType                                                             -->
<!--     The uploadType string which indicates that the UPLOADFILE entry belongs    --> 
<!--        to a promotion code export job											-->
<!--================================================================================-->
BEGIN_SQL_STATEMENT
  base_table=UPLOADFILE
  name=IBM_DeletePromotionCodeExportsFromProcessFile
  sql=DELETE FROM PROCESSFILE WHERE PROCESSFILE.PROCESSFILE_ID IN (SELECT FILEPROCREL.PROCESSFILE_ID FROM FILEPROCREL,UPLOADFILE WHERE UPLOADFILE.UPLOADFILE_ID=FILEPROCREL.UPLOADFILE_ID AND UPLOADFILE.OBJECTID=?objectId? AND UPLOADFILE.UPLOADTYPE=?uploadType?)
END_SQL_STATEMENT

<!-- ============================================================================== -->
<!--  Removes the promotion code export entry from the UPLOADFILE table            -->
<!--                                                                                -->
<!--  @param objectId                                                               -->
<!--     The promotionId whose promotion code exports need to be marked as 	        -->
<!--        deleted 																-->												
<!--  @param uploadType                                                             -->
<!--     The uploadType string which indicates that the UPLOADFILE entry belongs    --> 
<!--        to a promotion code export job											-->
<!--================================================================================-->
BEGIN_SQL_STATEMENT
  base_table=UPLOADFILE
  name=IBM_DeletePromotionCodeExportsFromUploadFile
  sql=DELETE FROM UPLOADFILE WHERE UPLOADFILE.OBJECTID=?objectId? AND UPLOADFILE.UPLOADTYPE IN(?uploadType?)
END_SQL_STATEMENT

<!-- ========================================================= -->
<!-- Delete references to the FOLDERITEM table.				   -->
<!-- @param REFERENCE_ID The ID of the promotion.			   -->
<!-- @param FOLDERITEMTYPE The type of folder item to delete.  -->
<!-- ========================================================= -->
BEGIN_SQL_STATEMENT
	name=IBM_DELETE_FOLDERITEMS
	base_table=FOLDERITEM
	sql= 
		DELETE FROM FOLDERITEM WHERE REFERENCE_ID IN (?REFERENCE_ID?) AND FOLDERITEMTYPE IN (?FOLDERITEMTYPE?)
	cm
	sql=
		DELETE FROM $CM:BASE$.FOLDERITEM WHERE REFERENCE_ID IN (?REFERENCE_ID?) AND FOLDERITEMTYPE IN (?FOLDERITEMTYPE?)
END_SQL_STATEMENT