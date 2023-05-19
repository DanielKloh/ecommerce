<?php


namespace projeto\Model;

use projeto\DB\Sql;
use projeto\Model;



class OrderStatus extends Model{
    
    const EM_BRANCO = 1;
    const AGUARDANDO_PAGAMENTO = 2;
    const PAGO = 3;
    const ENTREGE = 4;


    public static function listAll(){

        $sql = new Sql();

        return $sql->select("SELECT * FROM tb_ordersstatus ORDER BY desstatus");
    }
}

?>