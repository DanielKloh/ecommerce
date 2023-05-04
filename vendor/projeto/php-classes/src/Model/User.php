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

        $result = $sql->select(
            "SELECT * FROM tb_users WHERE deslogin = :LOGIN",
            array(
                ":LOGIN" => $login
            )
        );


        if (count($result) === 0) {
            throw new \Exception("Usuario ou senha invalidos", 1);
        }

        $data = $result[0];

        if (password_verify($password, $data["despassword"]) === true) {
            $user = new User;

            $user->setiduser($data);

            $_SESSION[User::SESSION] = $user->getValues();

            return $user;


        } else {
            throw new \Exception("Usuario ou senha invalidos", 1);
        }


    }

    public static function verifyLogin($inadmin = true)
    {

        if (
            !isset($_SESSION[User::SESSION])
            ||
            !$_SESSION[User::SESSION]
            ||
            !(int) $_SESSION[User::SESSION]["iduser"] > 0
            ||
            (bool) $_SESSION[User::SESSION]["iduser"] !== $inadmin
        ) {
            header("Location: /admin/login/");
            exit;
        }
    }

    public static function logout()
    {
        $_SESSION[User::SESSION] = NULL;
    }

    public static function listAll()
    {
        $sql = new Sql();

        return $sql->select("SELECT * FROM tb_users a INNER JOIN tb_persons b using(idperson) order BY b.desperson");
    }



    public function save()
    {
        $sql = new Sql();
        //     pdesperson VARCHAR(64), 
        //     pdeslogin VARCHAR(64), 
        //     pdespassword VARCHAR(256), 
        //     pdesemail VARCHAR(128), 
        //     pnrphone BIGINT, 
        //     pinadmin TINYINT

        $result = $sql->select(
            "CALL sp_users_save(:desperson, :deslogin, :despassword, :desemail, :nrphone, :inadmin)",
            array(
                ":desperson" => $this->getdesperson(),
                ":deslogin" => $this->getdeslogin(),
                ":despassword" => $this->getdespassword(),
                ":desemail" => $this->getdesemail(),
                ":nrphone" => $this->getnrphone(),
                ":inadmin" => $this->getinadmin()
            )
        );

        $this->setData($result[0]);
    }

    public function get($iduser)
    {
        $sql = new Sql();

        $results = $sql->select(
            "SELECT * FROM tb_users a INNER JOIN tb_persons b USING(idperson) WHERE a.iduser = :iduser
            ", array(
                ":iduser" => $iduser
            ));
        
            $this->setData($results[0]);
    }


    public function update()
    {
        $sql = new Sql();

        $result = $sql->select(
            "CALL sp_usersupdate_save(:iduser, :desperson, :deslogin, :despassword, :desemail, :nrphone, :inadmin)",
            array(
                ":iduser" => $this->getiduser(),
                ":desperson" => $this->getdesperson(),
                ":deslogin" => $this->getdeslogin(),
                ":despassword" => $this->getdespassword(),
                ":desemail" => $this->getdesemail(),
                ":nrphone" => $this->getnrphone(),
                ":inadmin" => $this->getinadmin()
            )
        );

        $this->setData($result[0]);
    }

    public function delete(){

        $sql = new Sql();

        $sql->query("CALL sp_users_delete(:iduser)",array(
            ":iduser"=>$this->getiduser()
        ));
    }
}


?>