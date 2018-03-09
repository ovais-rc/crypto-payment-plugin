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

BEGIN_SQL_STATEMENT
  base_table=PREVIEWTOKEN
  name=INSERT_PREVIEWTOKEN
  sql=INSERT INTO PREVIEWTOKEN (PREVIEWTOKEN_ID, STOREENT_ID, USERS_ID, STARTDATE, ENDDATE, STATUS, PASSWORD, SALT, CTXDATA, PROPERTIES, OPTCOUNTER)
  VALUES (?PREVIEWTOKEN_ID?, ?STOREENT_ID?, ?USERS_ID?, ?STARTDATE?, ?ENDDATE?, ?STATUS?, ?PASSWORD?, ?SALT?, ?CTXDATA?, ?PROPERTIES?, 0)
END_SQL_STATEMENT

BEGIN_SQL_STATEMENT
  base_table=PREVIEWTOKEN
  name=SELECT_PREVIEWTOKEN_BY_ID
  sql=SELECT * FROM PREVIEWTOKEN WHERE PREVIEWTOKEN_ID = ?PREVIEWTOKEN_ID?
END_SQL_STATEMENT

BEGIN_SQL_STATEMENT
  base_table=PREVIEWTOKEN
  name=SELECT_VALID_PREVIEWTOKEN_BY_ID
  dbtype=db2
  sql=SELECT * FROM PREVIEWTOKEN WHERE PREVIEWTOKEN_ID = ?PREVIEWTOKEN_ID? AND STARTDATE <= CURRENT TIMESTAMP AND ENDDATE > CURRENT TIMESTAMP AND STATUS = 'A'
  dbtype=any
  sql=SELECT * FROM PREVIEWTOKEN WHERE PREVIEWTOKEN_ID = ?PREVIEWTOKEN_ID? AND STARTDATE <= CURRENT_TIMESTAMP AND ENDDATE > CURRENT_TIMESTAMP AND STATUS = 'A'
END_SQL_STATEMENT

BEGIN_SQL_STATEMENT
  base_table=PREVIEWTOKEN
  name=UPDATE_PREVIEWTOKEN_STATUS
  sql=UPDATE PREVIEWTOKEN SET STATUS=?STATUS? WHERE PREVIEWTOKEN_ID = ?PREVIEWTOKEN_ID?
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Create new ProcessFile record                                            -->
<!--                                                                           -->
<!--  @param MEMBER_ID                                                         -->
<!--     The primary key value of Member record                                -->
<!--  @param PROCESSFILE_ID                                                    -->
<!--     The primary key value of ProcessFile record                           -->
<!--  @param STARTTIME                                                         -->
<!--     The created time of the ProcessFile record                            -->
<!--  @param STATUS                                                            -->
<!--     The init status of the ProcessFile record                             -->
<!--===========================================================================-->
BEGIN_SQL_STATEMENT
  base_table=PROCESSFILE
  name=CreateNewProcessFile
  sql=INSERT INTO PROCESSFILE (MEMBER_ID, PROCESSFILE_ID, STARTTIME, STATUS) VALUES (?MEMBER_ID?, ?PROCESSFILE_ID?, ?STARTTIME?, ?STATUS?)
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Create new ProcessFile and UploadFile relationship record                -->
<!--                                                                           -->
<!--  @param PROCESSFILE_ID                                                    -->
<!--     The primary key value of the related ProcessFile record               -->
<!--  @param UPLOADFILE_ID                                                     -->
<!--     The primary key value of the related UploadFile record                -->
<!--===========================================================================-->
BEGIN_SQL_STATEMENT
  base_table=FILEPROCREL
  name=CreateNewFileProcessRelation
  sql=INSERT INTO FILEPROCREL (PROCESSFILE_ID, UPLOADFILE_ID) VALUES (?PROCESSFILE_ID?, ?UPLOADFILE_ID?)
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Update the status of the  ProcessFile                                    -->
<!--                                                                           -->
<!--  @param PROCESSFILE_ID                                                    -->
<!--     The primary key value of the ProcessFile record                       -->
<!--  @param STATUS                                                            -->
<!--     The status value of the ProcessFile record                            -->
<!--===========================================================================-->
BEGIN_SQL_STATEMENT
  base_table=PROCESSFILE
  name=UpdateProcessFileStatus
  sql=UPDATE PROCESSFILE SET STATUS=?STATUS? WHERE PROCESSFILE_ID=?PROCESSFILE_ID?
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Update the processInfo of the  ProcessFile                               -->
<!--                                                                           -->
<!--  @param PROCESSFILE_ID                                                    -->
<!--     The primary key value of the ProcessFile record                       -->
<!--  @param PROCESSINFO                                                       -->
<!--     The process information of the ProcessFile record                     -->
<!--===========================================================================-->
BEGIN_SQL_STATEMENT
  base_table=PROCESSFILE
  name=UpdateProcessFileProcessInfo
  sql=UPDATE PROCESSFILE SET PROCESSINFO=?PROCESSINFO? WHERE PROCESSFILE_ID=?PROCESSFILE_ID?
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Update the processInfo of the  ProcessFile                               -->
<!--                                                                           -->
<!--  @param PROCESSFILE_ID                                                    -->
<!--     The primary key value of the ProcessFile record                       -->
<!--  @param ENDTIME                                                           -->
<!--     The end time information of the ProcessFile record                    -->
<!--===========================================================================-->
BEGIN_SQL_STATEMENT
  base_table=PROCESSFILE
  name=UpdateProcessFileEndTime
  sql=UPDATE PROCESSFILE SET ENDTIME=?ENDTIME? WHERE PROCESSFILE_ID=?PROCESSFILE_ID?
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Select a row from the noun change history table                          -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=SELECT_CMVERSNCHGLOG
	base_table=CMVERSNCHGLOG
	sql=
	SELECT CMVERSNCHGLOG.* FROM CMVERSNCHGLOG
	 WHERE CMVERSNCHGLOG.NOUN=?objectType? 
	 		AND CMVERSNCHGLOG.OBJECT_ID = ?objectId? 
	 		AND CMVERSNCHGLOG.WORKSPACE = ?workspace? 
	 		AND CMVERSNCHGLOG.CONTENT_TASKGRP = ?taskGroup? 
			AND CMVERSNCHGLOG.STOREENT_ID = ?storeId?
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  insert a row into the noun change history table                          -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=INSERT_CMVERSNCHGLOG
	base_table=CMVERSNCHGLOG
	dbtype=db2
	sql=
	INSERT INTO CMVERSNCHGLOG(CMVERSNCHGLOG_ID,NOUN,OBJECT_ID,STOREENT_ID,WORKSPACE,CONTENT_TASKGRP,FILTER,LASTUPDATE) 
	VALUES( ?key? , ?objectType? , ?objectId? , ?storeId? , ?workspace? , ?taskGroup? , ?filter? , CURRENT TIMESTAMP) 
	dbtype=oracle
	sql=
	INSERT INTO CMVERSNCHGLOG(CMVERSNCHGLOG_ID,NOUN,OBJECT_ID,STOREENT_ID,WORKSPACE,CONTENT_TASKGRP,FILTER,LASTUPDATE) 
	VALUES( ?key? , ?objectType? , ?objectId? , ?storeId? , ?workspace? , ?taskGroup? , ?filter? , SYSTIMESTAMP) 
	sql=
	INSERT INTO CMVERSNCHGLOG(CMVERSNCHGLOG_ID,NOUN,OBJECT_ID,STOREENT_ID,WORKSPACE,CONTENT_TASKGRP,FILTER,LASTUPDATE) 
	VALUES( ?key? , ?objectType? , ?objectId? , ?storeId? , ?workspace? , ?taskGroup? , ?filter? , CURRENT TIMESTAMP) 

END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  update the timestamp of a row in the noun change history table           -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=UPDATE_CMVERSNCHGLOG
	base_table=CMVERSNCHGLOG
	dbtype=db2
	sql=
	UPDATE CMVERSNCHGLOG set LASTUPDATE = CURRENT TIMESTAMP
	WHERE CMVERSNCHGLOG.NOUN=?objectType? 
	 		AND CMVERSNCHGLOG.OBJECT_ID = ?objectId? 
	 		AND CMVERSNCHGLOG.WORKSPACE = ?workspace? 
	 		AND CMVERSNCHGLOG.CONTENT_TASKGRP = ?taskGroup? 
			AND CMVERSNCHGLOG.STOREENT_ID = ?storeId?
	dbtype=oracle
	sql=
	UPDATE CMVERSNCHGLOG set LASTUPDATE = SYSTIMESTAMP
	WHERE CMVERSNCHGLOG.NOUN=?objectType? 
	 		AND CMVERSNCHGLOG.OBJECT_ID = ?objectId? 
	 		AND CMVERSNCHGLOG.WORKSPACE = ?workspace? 
	 		AND CMVERSNCHGLOG.CONTENT_TASKGRP = ?taskGroup? 
			AND CMVERSNCHGLOG.STOREENT_ID = ?storeId?
	sql=
	UPDATE CMVERSNCHGLOG set LASTUPDATE = CURRENT TIMESTAMP
	WHERE CMVERSNCHGLOG.NOUN=?objectType? 
	 		AND CMVERSNCHGLOG.OBJECT_ID = ?objectId? 
	 		AND CMVERSNCHGLOG.WORKSPACE = ?workspace? 
	 		AND CMVERSNCHGLOG.CONTENT_TASKGRP = ?taskGroup? 
			AND CMVERSNCHGLOG.STOREENT_ID = ?storeId?
	
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Get catentry id list from atrchrel  table                                -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=SELECT_CATENTRY_ID_BY_ATTACHMENT_ID
	base_table=ATCHREL
	sql=
	SELECT DISTINCT ATCHREL.BIGINTOBJECT_ID AS CATENTRY_ID
	FROM ATCHREL 
	WHERE ATCHREL.ATCHOBJTYP_ID 
		IN (SELECT ATCHOBJTYP_ID FROM ATCHOBJTYP WHERE IDENTIFIER = 'CATENTRY')
	AND ATCHREL.atchtgt_id = ?attachmentId?
END_SQL_STATEMENT