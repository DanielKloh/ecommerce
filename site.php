<?php


use projeto\Model\Cart;
use projeto\Model\Category;
use projeto\Model\Products;
use projeto\Page;

$app->get('/', function () {

	$page = new Page();

	$page->setTpl("index");

});


$app->get("/categories/:idcategory", function ($idcategory) {


	$page = (isset($_GET['page'])) ? (int)$_GET['page'] : 1;

	$category = new Category();

	$category->get((int) $idcategory);

	$pagination = $category->getPrductsPage($page);

	$pages = [];

	for ($i=1; $i <= $pagination['pages']; $i++) { 
		array_push($pages, [
			'link'=>'/categories/'.$category->getidcategory().'?page='.$i,
			'page'=>$i
		]);
	}

	$page = new Page();


	$page->setTpl("category", [
		"category" => $category->getValues(),
		"products" => $pagination["data"],
		"pages" => $pages
	]);

});


$app->get('/products/:desurl', function($desurl){
	$product = new Products();

	$product->getFormUrl($desurl);

	$page = new Page();

	$page->setTpl("product-detail",[

		"product"=>$product->getValues(),
		"categories"=>$product->getCategories()
	]);
});



$app->get("/cart",function(){
	$cart = Cart::getFromSession();
	$page = new Page();

	$page->setTpl("cart");
})

?>