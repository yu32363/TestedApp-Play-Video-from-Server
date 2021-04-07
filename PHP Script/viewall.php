<?php
    $db = mysqli_connect('203.154.91.122:8306','bsrd','bsrd@helios','userdata');
    if(!$db){
        echo "Database connection faild";
    }

    $person = $db->query("SELECT * FROM person");
    $list = array();

    while ($rowdata=$person->fetch_assoc()) {
        $list[] = $rowdata;
    }
    echo json_encode($list);
?>

