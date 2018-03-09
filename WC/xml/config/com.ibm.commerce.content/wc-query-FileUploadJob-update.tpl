<!-- TODO: This is a sample query template file. -->
<!-- Please modify to match your implementation. -->

BEGIN_SYMBOL_DEFINITIONS
		<!-- Defining all columns of the table -->
		COLS:FILEPROCREL = FILEPROCREL:*
				
		<!-- Defining the columns of the UPLOADFILE table -->
		COLS:UPLOADFILE_ID = UPLOADFILE:UPLOADFILE_ID
		COLS:STORE_ID = UPLOADFILE:STORE_ID
		COLS:OPTCOUNTER = UPLOADFILE:OPTCOUNTER
		COLS:FILENAME = UPLOADFILE:FILENAME
		
		<!-- Defining the columns of the PROCESSFILE table -->
		COLS:PROCESSFILE_ID = PROCESSFILE:PROCESSFILE_ID
		COLS:STATUS = PROCESSFILE:STATUS
		
		
END_SYMBOL_DEFINITIONS

<!-- ================================================================================== -->
<!-- XPath: /FileUploadJob[FileUploadJobIdentifier[UniqueID=]]-->
<!-- AccessProfile:	IBM_Admin_FileUploadJobUpdate -->
<!-- Get the information for FileUploadJob with specified unique ID for a delete operation -->
<!-- Access profile includes all columns from the table. -->
<!-- @param UniqueID  Unique id of FileUploadJob to retrieve -->   
<!-- ================================================================================== -->

BEGIN_XPATH_TO_SQL_STATEMENT
	name=/FileUploadJob[FileUploadJobIdentifier[UniqueID=]]+IBM_Admin_FileUploadJobUpdate     
	base_table=UPLOADFILE
	sql=	
		SELECT 
	     				UPLOADFILE.$COLS:UPLOADFILE_ID$,
	     				UPLOADFILE.$COLS:STORE_ID$,
	     				UPLOADFILE.$COLS:OPTCOUNTER$,
	     				UPLOADFILE.$COLS:FILENAME$,
						PROCESSFILE.$COLS:PROCESSFILE_ID$,
						PROCESSFILE.$COLS:STATUS$,
						FILEPROCREL.$COLS:FILEPROCREL$
	     				
	     	FROM
	     				UPLOADFILE
	     				LEFT OUTER JOIN FILEPROCREL ON FILEPROCREL.UPLOADFILE_ID=UPLOADFILE.UPLOADFILE_ID
							LEFT OUTER JOIN PROCESSFILE ON FILEPROCREL.PROCESSFILE_ID = PROCESSFILE.PROCESSFILE_ID
	     	WHERE
						UPLOADFILE.UPLOADFILE_ID = ?UniqueID?
END_XPATH_TO_SQL_STATEMENT
