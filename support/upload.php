<?php 
	
	function db_connect()
	{
		$host = "localhost";
		$user = "root";
		$db = "picpost";
		$pwd = "";

		$connect = mysqli_connect($host,$user,$pwd,$db);

		if(!$connect) print_r(json_encode(array("msg"=>"Connection Failed")));				
	}

	if(!empty($_POST))
	{
		if(isset($_POST['upload'])):

			if(!empty($_FILES)):
				$upload_dir = "images/";
				$file_name = $_FILES['photo']['name'];
				$file = $_FILES['photo']['tmp_name'];

				if(move_uploaded_file($file, $upload_dir.$file_name)):
					print_r(json_encode(array("msg"=>"Upload Success")));
				else:
					print_r(json_encode(array("msg"=>"Upload Failed")));
				endif;

			endif;

		endif;
	}

	function test_request()
	{
		return json_encode(array("msg"=>"Test Success"));
	}

?>