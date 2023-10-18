<html>
	<head>
		<title>PHP Test Page</title>
	</head>
	<body>
		<?php echo '<p>Hello world!</p>'; ?>

		<?php
			if (strpos($_SERVER['HTTP_USER_AGENT'], 'Firefox') !== false) {
		?>
			<h3>strpos() returned true!</h3>
			<p> You are using firefox!</p>	
		<?php
			} else {
		?>
			<h3>strpos() returned false!</h3>
			<p> You are not using firefox! <p3>
		<?php
			}
		?>



		<h3>Form</h3>
		<form action="action.php" method="post">
			<label for="name">Your name:</label>
			<input name="name" id="name" type="text">
			
			<label for="age">Your age:</label>
			<input name="age" id="age" type="number">
			
			<button type="submit">Submit</button>
		</form>

		<h3>Data</h3>
		
		<?php
			echo $_SERVER['HTTP_USER_AGENT'];
		?>

		<?php phpinfo(); ?>
	</body>
</html>
