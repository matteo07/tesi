<?php
function getKirivoWidgets() {
    $res = array();
    foreach(glob( dirname(_FILE_)."/widget-kirivo/*Widget.php") 
            as $filename) {
        array_push($res,$filename);
    };
    return $res;
}
function getOriginiWidgets() {
    $res = array();
    foreach(glob( dirname(_FILE_)."/widget-origini/*Widget.php") 
            as $filename) {
        array_push($res,$filename);
    };
    return $res;
}
function my_register_widgets() {
    foreach(getKirivoWidgets() as $filename) {
        require_once $filename;
        register_widget(str_replace('.php','',str_replace(dirname(_FILE_).
            '/widget-kirivo/','',$filename)));
    }
    foreach(getOriginiWidgets() as $filename) {
        require_once $filename;
        register_widget(str_replace('.php','',str_replace(dirname(_FILE_).
            '/widget-origini/','',$filename)));
    };
}
add_action( 'widgets_init', 'my_register_widgets' );