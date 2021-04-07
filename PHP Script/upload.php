<?php
    $db = mysqli_connect('203.154.91.122:8306','bsrd','bsrd@helios','userdata');
    if(!$db){
        echo "Database connection faild";
    }
    $image = $_FILES['image']['name'];
    $name = $_POST['name'];

    $imagePath = 'uploads/'.$image;
    $tmp_name = $_FILES['image']['tmp_name'];

    move_uploaded_file($tmp_name, $imagePath);

    $db->query("INSERT INTO person(id,name,image)VALUES(0,'".$name."','".$image."')");	
?>
