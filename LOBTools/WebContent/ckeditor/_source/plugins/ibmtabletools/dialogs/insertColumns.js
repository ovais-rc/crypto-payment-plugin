/* Copyright IBM Corp. 2011-2014 All Rights Reserved.                    */

CKEDITOR.dialog.add('insertColumns', function(editor) {	

	return {
	
		title : editor.lang.ibmtabletools.insertMultipleCols,
		minWidth : 230,
		minHeight : 50,
		
		onOk : function()
		{	
			var data = {};
			this.commitContent( data );
			editor.execCommand('insertMultipleColumns', data);	
			
		},
	
       contents:
		[
			{
			    id: 'info',
			    style: 'width: 100%',
			    elements:
				[
				
					{
						type : 'hbox',
						padding : "5px",
						width : ['30%','70%'],
						
						children :
						[
							{
								label : editor.lang.ibmtabletools.noOfCols,
								type : 'text',
								id : 'numberOfCols',
								required : true,
								'default' : '2',
								
								validate : function()
								{
									var value = this.getValue(),
										pass = !!( CKEDITOR.dialog.validate.integer()( value ) && value > 0 );
										
									if ( !pass )
									{
										alert( editor.lang.table.invalidCols );
										this.select();
									}
									return pass;		
								},
								
								commit : function( data )
								{
									data.noOfCols = this.getValue();
								}
							},
							
							{
								type : 'select',
								label : editor.lang.ibmtabletools.insertPosition,
								id : 'type',
								style : 'width:150px',
								'default' : 'after',
								items :
								[
								 	[ editor.lang.ibmtabletools.insertAfter, 'after' ],
									[ editor.lang.ibmtabletools.insertBefore, 'before' ]
								],
								commit : function( data )
								{
									data.insertLocation = this.getValue();
								}
							}	
						]
					}
				]
			}						
		] 
    };
});