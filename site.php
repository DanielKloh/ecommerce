<?php


use projeto\Model\Cart;
use projeto\Model\Category;
use projeto\Model\Products;
use projeto\Page;

$app->get('/', function () {

	$products = Products::listAll();

	$page = new Page();

	$page->setTpl("index",[
		'products'=>Products::checkList($products)
	]);

});


$app->get("/categories/:idcategory", function ($idcategory) {


	$page = (isset($_GET['page'])) ? (int) $_GET['page'] : 1;

	$category = new Category();

	$category->get((int) $idcategory);

	$pagination = $category->getPrductsPage($page);

	$pages = [];

	for ($i = 1; $i <= $pagination['pages']; $i++) {
		array_push($pages, [
			'link' => '/categories/' . $category->getidcategory() . '?page=' . $i,
			'page' => $i
		]);
	}

	$page = new Page();


	$page->setTpl("category", [
		"category" => $category->getValues(),
		"products" => $pagination["data"],
		"pages" => $pages
	]);

});


$app->get('/products/:desurl', function ($desurl) {
	$product = new Products();

	$product->getFormUrl($desurl);

	$page = new Page();

	$page->setTpl("product-detail", [

		"product" => $product->getValues(),
		"categories" => $product->getCategories()
	]);
});



$app->get("/cart", function () {

	$cart = Cart::getFromSession();
	$page = new Page();

	$page->setTpl(
		"cart",
		[
			"cart" => $cart->getValues(),
			"products" => $cart->getProducts(),
			"error"=>Cart::getMsgErro()
		]
	);
});


$app->get("/cart/:idproduct/add", function ($idproduct) {


	$product = new Products();

	$product->get((int) $idproduct);

	$cart = Cart::getFromSession();
	
	$qtd = (isset($_GET['qtd'])) ? (int)$_GET['qtd'] : 1;

	for ($i = 0; $i < $qtd; $i++) {
		
		$cart->addProduc($product);

	}

	header("Location: /cart");
	exit;
});

$app->get("/cart/:idproduct/minus", function ($idproduct) {
	$product = new Products();

	$product->get((int) $idproduct);

	$cart = Cart::getFromSession();

	$cart->removeProduc($product);

	header("Location: /cart");
	exit;
});


$app->get("/cart/:idproduct/remove", function ($idproduct) {
	$product = new Products();

	$product->get((int) $idproduct);

	$cart = Cart::getFromSession();

	$cart->removeProduc($product, true);

	header("Location: /cart");
	exit;
});



$app->post("/cart/freight", function(){

	$cart = Cart::getFromSession();

	$cart->setFreight($_POST["zipcode"]);

	header("Location: /cart");
	exit;
});
?>