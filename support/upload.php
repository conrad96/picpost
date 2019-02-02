<?php 

	function db_connect()
	{
		$host = "localhost";
		$user = "root";
		$db = "picpost";
		$pwd = "";

		$connect = mysqli_connect($host,$user,$pwd,$db);

		if(!$connect) json_encode("msg"=>"Connection Failed");				
	}

	if(!empty($_POST))
	{
		db_connect(); //connect to the db

		//call functions from GET
		if(isset($_GET['method']) && isset($_GET['value'])): 
			switch($_GET['method'])
			{
				case 'test':
				$params = $_GET['value'];
				$response = array(
					"msg" => "Received",
					"value" => $_GET['value'],
					"function" => test_request()
				);
				return json_encode($response);
				break;

			}
		endif;
	}

	function test_request()
	{
		return json_encode(array("msg"=>"Test Success"));
	}
	
//}

?>