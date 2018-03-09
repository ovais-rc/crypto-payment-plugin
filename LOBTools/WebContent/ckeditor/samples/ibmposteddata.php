<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<!-- Copyright IBM Corp. 2010-2014  All Rights Reserved. -->
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>CK Editor paosted data</title>
	<meta http-equiv="content-type" content="text/html; charset=utf-8" />
	<script type="text/javascript" src="../ckeditor.js"></script>
	<script type="text/javascript">
var editor = '';

function createEditor()
{
	if ( editor )
		return;

	// Create a new editor inside the <div id="editor">, setting its value to the contents of the output file
	var config = {toolbar : 'Full'};
	editor = CKEDITOR.appendTo( 'editor', config, document.getElementById( 'editorcontents' ).innerHTML );
}

function removeEditor()
{
	if ( !editor )
		return;

	document.getElementById( 'editorcontents' ).innerHTML = editor.getData();

	// Destroy the editor.
	editor.destroy();
	editor = null;
}
	</script>
</head>
<body>
	<h1>
		CKEditor Posted Data
	</h1>

<?php

	$postArray = &$_POST ;
	$keysArray = array_keys($postArray);
	$idForEditor = $keysArray[0];
	$value = $postArray[$idForEditor];
	$outputHTML = '<html><head><script type="text/javascript" src="../../ckeditor.js"></script>
	<script type="text/javascript">

	var editor = \'\';

	function createEditor()
	{
		if ( editor )
			return;

		// Create a new editor inside the <div id="editor">, setting its value to the contents of the output file
		var config = {toolbar : \'Full\'};
		editor = CKEDITOR.appendTo( \'editor\', config, document.getElementById( \'editorcontents\' ).innerHTML );
	}

	function removeEditor()
	{
		if ( !editor )
			return;

		document.getElementById( \'editorcontents\' ).innerHTML = editor.getData();

		// Destroy the editor.
		editor.destroy();
		editor = null;
	}

	</script></head><body>
	<table>
		<tr>
			<td> <input onclick="createEditor();" type="button" value="Show Content in Editor" /> </td>
			<td> <input onclick="removeEditor();" type="button" value="Remove Editor" /> </td>
		</tr>
	</table>
	<div id="editor">
	</div><p>
		Edited Contents:</p>
	<div id="editorcontents" style="border: 1px solid black; padding: 10px;>';
	$outputHTML .= utf8_encode($value);
	$outputHTML .= '</div></body></html>';

	mkdir("./output", 0700);

	$ourFileName = time() . ".html";
	$ourFileHandle = fopen("output/" . $ourFileName, 'w') or die("can't open file");
	fwrite($ourFileHandle,$outputHTML);
	fclose($ourFileHandle);

	$rootFolderForSamplePostDataFile = str_replace("sample_posteddata.php", "", $_SERVER['REQUEST_URI']); // removing sampleposteddata.php in the path to get path for the folder containing the file
	$folderForAllOutputFiles = "http://".$_SERVER['SERVER_NAME'].$rootFolderForSamplePostDataFile."output/" ;
	$pathForOutputFile = $folderForAllOutputFiles.$ourFileName ;

?>
	<table>
		<tr>
			<td> Editor Name: </td>
			<td><?php echo $idForEditor ; ?> </td>
		</tr>
		<tr>
			<td> Link for output file:</td>
			<td><a href="<?php echo $pathForOutputFile; ?>"> <?php echo $pathForOutputFile; ?></a> </td>
		</tr>
		<tr>
			<td> Link for all output files folder:</td>
			<td> <a href="<?php echo $folderForAllOutputFiles; ?>"> <?php echo $folderForAllOutputFiles; ?></a> </td>
		</tr>
	</table>

	<table>
		<tr>
			<td> <input onclick="createEditor();" type="button" value="Show Content in Editor" /> </td>
			<td> <input onclick="removeEditor();" type="button" value="Remove Editor" /> </td>
		</tr>
	</table>

	<!-- This div will hold the editor. -->
	<div id="editor">
	</div>

	<p>
		Edited Contents:</p>
	<!-- This div will be used to display the editor contents. -->
	<div id="editorcontents" style="border: 1px solid black; padding: 10px;>
		<?php echo $value ; ?>
	</div>
</body>
</html>
