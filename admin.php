<?php


use projeto\Model\User;
use projeto\Page_Admin;


$app->get('/admin/', function () {

	User::verifyLogin();

	$page = new Page_Admin();

	$page->setTpl("index");

});

$app->get('/admin/login/', function () {

	$page = new Page_Admin([
		"header" => false,
		"footer" => false
	]);

	$page->setTpl("login");

});


$app->post('/admin/login/', function () {
	User::login($_POST["login"], $_POST["password"]);

	header("Location: /admin/");
	exit;
});


$app->get('/admin/forgot', function () {

	$page = new Page_Admin([
		"header" => false,
		"footer" => false
	]);

	$page->setTpl("forgot");
});


$app->post('/admin/forgot', function () {

	$user = User::getForgot($_POST["email"]);

	header("Location: /admin/forgot/sent");
	exit;
});

$app->get('/admin/forgot/sent', function () {

	$page = new Page_Admin([
		"header" => false,
		"footer" => false
	]);

	$page->setTpl("forgot-sent");
});



$app->get('/admin/forgot/reset', function () {

	$user = User::validForgotDecripy($_GET["code"]);
	$page = new Page_Admin([
		"header" => false,
		"footer" => false
	]);

	$page->setTpl("forgot-reset", array(
		"neme" => $user["desperson"],
		"code" => $_GET["code"]
	)
	);
});




$app->post('/admin/forgot/reset', function () {

	$forgot = User::validForgotDecripy($_POST["code"]);

	User::setForgotUsed($forgot["idcovery"]);

	$user = new User();

	$user->get((int) $forgot["iduser"]);

	$password = password_hash($_POST["password"], PASSWORD_DEFAULT, ["cost" => 12]);

	$user->setPassword($password);

	$page = new Page_Admin([
		"header" => false,
		"footer" => false
	]);

	$page->setTpl("forgot-reset-succes");
});











?>