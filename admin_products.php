<?php


use \projeto\Page_Admin;
use \projeto\Model\User;
use \projeto\Model\Products;


$app->get("/admin/products", function () {

    User::verifyLogin();

    $search = isset($_GET["search"]) ? $_GET["search"] : "";

	$page = (isset($_GET["page"])) ? (int) $_GET["page"] : 1;


	if ($search != "") {

		$pagination = Products::getPageSearch($search, $page);
	} else {

		$pagination = Products::getPage($page);
	}


	$pages = [];

	for ($i = 0; $i < $pagination["pages"]; $i++) {
		array_push($pages, [
			'href' => "/admin/products?" . http_build_query([
				"page" => $i + 1,
				"search" => $search
			]),
			"text" => $i + 1
		]);
	}


    $page = new Page_Admin();

    $page->setTpl("products", [
        "products" => $pagination["data"],
			"search" => $search,
			"pages" => $pages
    ]);
});


$app->get("/admin/products/create", function () {

    User::verifyLogin();

    $page = new Page_Admin();

    $page->setTpl("products-create");
});


$app->post("/admin/products/create", function () {

    User::verifyLogin();

    $product = new Products();

    $product->setData($_POST);

    $product->save();

    if($_FILES["file"]["name"] !== "") $product->setPhoto($_FILES['file']);

    header("Location: /admin/products");

    exit;
});



$app->get("/admin/products/:idproduct", function ($idproduct) {

    User::verifyLogin();

    $products = new Products();

    $products->get((int) $idproduct);

    $page = new Page_Admin();
    $page->setTpl("products-update",[
        "product"=>$products->getValues()
    ]);

});


$app->post("/admin/products/:idproduct", function ($idproduct) {

	User::verifyLogin();

	$product = new Products();

	$product->get((int)$idproduct);

	$product->setData($_POST);

	$product->save();
    
    if($_FILES["file"]["name"] !== "") $product->setPhoto($_FILES["file"]);


	header('Location: /admin/products');
	exit;
});

$app->get("/admin/products/:idproduct/delete", function ($idproduct) {

    User::verifyLogin();

	$product = new Products();

	$product->get((int)$idproduct);

    $product->delete();

	header('Location: /admin/products');
	exit;
});


?>