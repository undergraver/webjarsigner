<?php
$method = $_SERVER['REQUEST_METHOD'];

$name = 'jarfile';

if ($method === "GET")
{
    // display the submit form
	$page = "<html><body>
		 <form enctype='multipart/form-data' action='" . $_SERVER['PHP_SELF'] . "' method='POST'>
                   <label>Select a jar for signing</label>
                   <input type='file' name='" . $name . "' accept='.jar' />
                   <input type='submit' value='Sign jar' />
	         </form>
                 </body></html>";
    print $page;
}
else if ($method === "POST")
{
	if(!empty($_FILES[$name]))
	{
		$userFileName = basename( $_FILES[$name]['name'] );

		$signedJarName = tempnam(sys_get_temp_dir(), 'signed_jar_file');
		
		$downloadFileName = 'signed_' . $userFileName;

		$uploadedJarFile = $_FILES[$name]['tmp_name'];

		$command="./sign.sh " . $uploadedJarFile . " " . $signedJarName;

		$result = system($command);

		unlink($uploadedJarFile);

		$file = $signedJarName;

		if ($result==0 && file_exists($file))
	       	{
		    header('Content-Description: File Transfer');
		    header('Content-Type: application/octet-stream');
		    header('Content-Disposition: attachment; filename="'.$downloadFileName.'"');
		    header('Expires: 0');
		    header('Cache-Control: must-revalidate');
		    header('Pragma: public');
		    header('Content-Length: ' . filesize($file));
		    readfile($file);
                }
		else
		{
		    die('Failure signing ' . $userFileName);
                }

		unlink($signedJarName);
	}
	else
	{
	    die('Failure in upload');
	}
}
?>
