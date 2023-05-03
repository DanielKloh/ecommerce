<?php 
session_start();
use projeto\Pageadmin;

require_once("vendor/autoload.php");


use \Slim\Slim;
use \projeto\page;
use \projeto\page_Admin;
use \projeto\Model\User;

$app = new Slim();

$app->config('debug', true);

$app->get('/', function() {
    
	$page = new Page();

	$page->setTpl("index");

});

$app->get('/admin/', function() {
	
	User::varifyLogin();

	$page = new Page_Admin();

	$page->setTpl("index");

});

$app->get('/admin/login/', function(){

	$page = new Page_Admin([
		"header"=>false,
		"footer"=>false
	]);

	$page->setTpl("login");

});


$app->post('/admin/login/', function(){
	User::login($_POST["login"],$_POST["password"]);

	header("Location: /admin/");
	exit;
});

$app->get('/admin/logout/', function(){

	User::logout();
	header("Location: /admin/login");
	exit;
});


$app->run();

 ?>