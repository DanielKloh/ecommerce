<?php


use projeto\Model\Category;
use projeto\Model\Products;
use projeto\Page;

$app->get('/', function () {

	$page = new Page();

	$page->setTpl("index");

});


$app->get("/categories/:idcategory",function($idcategory){

	$category = new Category();
	$product = new Products();

	$category->get((int)$idcategory);

	$page = new Page();

	
	$page->setTpl("category",[
		"category"=>$category->getValues(),
		"products"=>Products::checkList($category->getProducts())
	]);

});


?>