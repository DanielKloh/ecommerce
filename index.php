<?php 
use projeto\Pageadmin;

require_once("vendor/autoload.php");


use \Slim\Slim;
use \projeto\page;
use \projeto\page_Admin;

$app = new Slim();

$app->config('debug', true);

$app->get('/', function() {
    
	$page = new Page();

	$page->setTpl("index");

});

$app->get('/adm', function() {
    
	$page = new Page_Admin();

	$page->setTpl("index");

});

$app->run();

 ?>