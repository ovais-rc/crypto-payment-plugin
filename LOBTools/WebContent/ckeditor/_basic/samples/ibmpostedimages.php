<?php
	// This is a simple example, not to be used in production.

	// create output folder for images to be saved.
	mkdir("./output", 0700);

	// get all data uris from the POST request
	$dataUriArray = array();
	foreach($_POST as $key => $value) {
		if(strpos($key, 'imageUri') === 0) {
			$dataUriArray[] = $value;
		}
	}

	// decode all data uris
	$count = 0;
	foreach ($dataUriArray as $dataUri) {
	   $path = decodeBase64Image($dataUri, $count);
	   // return array of urls
	   $imageUrls[] = '\''.getPathToAllOutputFiles().$path.'\'';
	   $count++;
	}

	// break the reference with the last element
	unset($dataUri);

	function getCallFunctionNumber() {
		$uriQuery = $_SERVER['QUERY_STRING'];
		$uriQuery = explode("=",$uriQuery);
		// get the second parameter from the request, which is callfunction number.
		$functionNumber = explode("&",$uriQuery[2]);
		return $functionNumber[0];
	}

	function getDeleteImageCallFunctionNumber() {
		$uriQuery = $_SERVER['QUERY_STRING'];
		$uriQuery = explode("=",$uriQuery);
		// get the second parameter from the request, which is callfunction number.
		$functionNumber = explode("&",$uriQuery[3]);
		//echo 'getDeleteImageCallFunctionNumber: '.$functionNumber[0];
		return $functionNumber[0];
	}

	function getImageTimestamp() {
		$uriQuery = $_SERVER['QUERY_STRING'];
		$timeStamp = explode("=",$uriQuery);
		// get the third parameter from the request, which is the timestamp.
		return $timeStamp[4];
	}

	function getPathToAllOutputFiles() {
		// removind the query part from the URI
		$serverURI = str_replace( '?'.$_SERVER['QUERY_STRING'], "", $_SERVER['REQUEST_URI'] );
		// removing ibmpostedimages.php in the path to get path for the folder containing the file
		$rootFolderForSamplePostDataFile = str_replace("ibmpostedimages.php", "", $serverURI);
		return "http://".$_SERVER['SERVER_NAME'].$rootFolderForSamplePostDataFile;
	}

	function decodeBase64Image ($dataUri=string, $count=int) {
	    if ($dataUri) {
		$encodedData = str_replace(' ','+',$dataUri);
		// check if we have correct data URI passed
		if (!preg_match('/data:([^;]*);base64,(.*)/', $dataUri, $matches)) {
	    		die("error");
		}

		// decode the data
		$content = base64_decode($matches[2]);
		// get the image length
		header('Content-Length: '.strlen($content));
		// get the image type
		$filetype = str_replace('image/', '', $matches[1]);
		// get the image name
		$imageName = getImageTimestamp().'_'.(string)$count.'.';
		$pathToFile = 'output/'.$imageName.$filetype;
		// save image on the server side
		file_put_contents($pathToFile, $content);

		return $pathToFile;
	    }
	}

	function getIdOfImageToDelete() {
		return getImageTimestamp();
	}

	$urls = implode(",", $imageUrls);
	// respond with an array of urls
	echo '<script type="text/javascript">window.parent.CKEDITOR.tools.callFunction('.getCallFunctionNumber().', ['.$urls.']);</script>';

	//Enable this part to sets images delete functionality
	//set_time_limit(3000);
	//$ids = getImageTimestamp();
	//$idToSend = '\''.(string)$ids.'_0\'';
	//echo '<script type="text/javascript">window.parent.CKEDITOR.tools.callFunction('.getDeleteImageCallFunctionNumber().', ['.$idToSend.']);</script>';
?>
