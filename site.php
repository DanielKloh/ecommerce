<?php


use projeto\Model;
use projeto\Model\Cart;
use projeto\Model\Category;
use projeto\Model\Products;
use projeto\Model\User;
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








$app->get("/checkout", function(){

	User::verifyLogin(false);

	$address = new Model();
	$cart = Cart::getFromSession();

	$page = new Page();

	$page->setTpl("checkout", [
		'cart'=>$cart->getValues(),
		'address'=>$address->getValues(),
		"error"=>""

	]);

});

$app->get("/login", function(){

	$page = new Page();

	$page->setTpl("login",[
		'error'=>User::getError(),
		'errorRegister'=>User::getErrorRegister(),
		'registerValues'=>(isset($_SESSION['registerValues'])) ? $_SESSION['registerValues'] : ['name'=>'', 'email'=>'', 'phone'=>'']

	]);

});



$app->post("/login", function(){

	try {
		
		User::login($_POST['login'], $_POST['password']);

	} catch(Exception $e) {

		User::setError($e->getMessage());

	}

	header("Location: /checkout");
	exit;

});


$app->get("/logout", function(){

	User::logout();

	header("Location: /login");
	exit;

});



$app->post("/register", function(){

	$_SESSION['registerValues'] = $_POST;

	if (!isset($_POST['name']) || $_POST['name'] == '') {

		User::setErrorRegister("Preencha o seu nome.");
		header("Location: /login");
		exit;

	}

	if (!isset($_POST['email']) || $_POST['email'] == '') {

		User::setErrorRegister("Preencha o seu e-mail.");
		header("Location: /login");
		exit;

	}

	if (!isset($_POST['password']) || $_POST['password'] == '') {

		User::setErrorRegister("Preencha a senha.");
		header("Location: /login");
		exit;

	}

	if (User::checkLoginExist($_POST['email']) === true) {

		User::setErrorRegister("Este endereço de e-mail já está sendo usado por outro usuário.");
		header("Location: /login");
		exit;

	}

	$user = new User();

	$user->setData([
		'inadmin'=>0,
		'deslogin'=>$_POST['email'],
		'desperson'=>$_POST['name'],
		'desemail'=>$_POST['email'],
		'despassword'=>$_POST['password'],
		'nrphone'=>$_POST['phone']
	]);

	$user->save();

	User::login($_POST['email'], $_POST['password']);

	header('Location: /checkout');
	exit;

});






$app->get('/forgot', function () {

	$page = new Page();

	$page->setTpl("forgot");
});


$app->post('/forgot', function () {

	$user = User::getForgot($_POST["email"], false);

	header("Location: /forgot/sent");
	exit;
});

$app->get('/forgot/sent', function () {

	$page = new Page();

	$page->setTpl("forgot-sent");
});



$app->get('/forgot/reset', function () {

	$user = User::validForgotDecripy($_GET["code"]);
	$page = new Page();

	$page->setTpl("forgot-reset", array(
		"neme" => $user["desperson"],
		"code" => $_GET["code"]
	)
	);
});




$app->post('/forgot/reset', function () {

	$forgot = User::validForgotDecripy($_POST["code"]);

	User::setForgotUsed($forgot["idcovery"]);

	$user = new User();

	$user->get((int) $forgot["iduser"]);

	$password = password_hash($_POST["password"], PASSWORD_DEFAULT, ["cost" => 12]);

	$user->setPassword($password);

	$page = new Page();

	$page->setTpl("forgot-reset-succes");
});



$app->get("/profile", function(){

	User::verifyLogin(false);

	$user = User::getFromSession();

	$page = new Page();

	$page->setTpl("profile",[
		"user"=>$user->getValues(),
		"profileMsg"=>User::getSucess(),
		"profileError"=>User::getError()
	]);

});


$app->post("/profile",function(){

	User::verifyLogin(false);


	if(!isset($_POST["desperson"]) || $_POST["desperson"] === ""){
		User::setError("Preencha os seu nome");
		header("Location: /profile");
		exit;
	}

	if(!isset($_POST["desemail"]) || $_POST["desemail"] === ""){
		User::setError("Preencha os seu email");
		header("Location: /profile");
		exit;
	}

	$user = User::getFromSession();


	if($_POST["desemail"] !== $user->getdesemail()){

		if(User::checkLoginExist($_POST["desemail"]) === true){
			User::setError("Este email já está em uso!");
			header("Location: /profile");
			exit;
		}
	}



	$_POST['inadmin'] = (int)$user->getinadmin();
	$_POST['despassword'] = User::getPasswordHash( $user->getdespassword());



	var_dump($_POST['inadmin']);
	var_dump($_POST['despassword']);
	var_dump($_POST['deslogin']);
	$user->setData($_POST);

	
	$user->update();

	User::setSucess("Dados aleterados com sucesso!!");

	header("Location: /profile");
	exit;

})
?>