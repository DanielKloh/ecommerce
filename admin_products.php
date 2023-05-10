<?php


use \projeto\Page_Admin;
use \projeto\Model\User;
use \projeto\Model\Products;


$app->get("/admin/products", function () {

    User::verifyLogin();

    $products = Products::listAll();

    $page = new Page_Admin();

    $page->setTpl("products", [
        "products" => $products
    ]);
});


$app->get("/admin/products/create", function () {

    User::verifyLogin();

    $page = new Page_Admin();

    $page->setTpl("products-create");
});


$app->post("/admin/products/create", function () {

    User::verifyLogin();

    $products = new Products();

    $products->setData($_POST);

    $products->save();

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

    $products = new Products();

    $products->get((int)$idproduct);

    $products->setData($_POST);

    $products->save();

    $products->setPhoto($_FILES['file']);
    
    header("Location: /admin/products");
    exit;
});

$app->get("/admin/products/:idproduct/delete", function ($idproduct) {

    User::verifyLogin();

    $products = new Products();

    $products->get((int) $idproduct);

    $products->delete();

    header("Location: /admin/products");
    exit;
});


?>