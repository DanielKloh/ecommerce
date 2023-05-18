<?php


namespace projeto\Model;

use projeto\Model;



class OrderStatus extends Model{
    
    const EM_BRANCO = 1;
    const AGUARDANDO_PAGAMENTO = 2;
    const PAGO = 3;
    const ENTREGE = 4;
}

?>