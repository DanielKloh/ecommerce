<?php


namespace projeto\Model;

use \projeto\DB\Sql;
use \projeto\Model;

class User extends Model
{

    const SESSION = "User";

    public static function login($login, $password)
    {

        $sql = new Sql();

        $result = $sql->select("SELECT * FROM tb_users WHERE deslogin = :LOGIN", array(
            ":LOGIN" => $login
        )
        );


        if (count($result) === 0) {
            throw new \Exception("Usuario ou senha invalidos", 1);
        }

        $data = $result[0];

        if(password_verify($password, $data["despassword"]) === true){
        $user = new User;

        $user->setiduser($data);
        
        $_SESSION[User::SESSION] = $user->getValues() ;

        return $user;


        }else{
            throw new \Exception("Usuario ou senha invalidos", 1);
        }


    }

    public static function varifyLogin($inadmin = true){

        if(
            !isset($_SESSION[User::SESSION])
            ||
            !$_SESSION[User::SESSION]
            ||
            !(int)$_SESSION[User::SESSION]["iduser"] > 0
            ||
            (bool)$_SESSION[User::SESSION]["iduser"] !== $inadmin
        ){
            header("Location: /admin/login/");
            exit;
        }
    }

    public static function logout(){
        $_SESSION[User::SESSION] = NULL;
    }


}


?>