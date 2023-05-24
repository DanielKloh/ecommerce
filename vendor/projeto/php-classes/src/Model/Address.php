<?php


namespace projeto\Model;
use projeto\DB\Sql;
use projeto\Model;



class Address extends Model{
	const SESSION_ERROR = "AddressError";
    public static function getCEP($nrcep){

        $nrcep = str_replace("-","",$nrcep);
        
        $ch = curl_init();

        curl_setopt($ch, CURLOPT_URL, "https://viacep.com.br/ws/$nrcep/json/");

        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);

        $data = json_decode(curl_exec($ch), true);


        curl_close($ch);

        return $data;
    }


    public function loadFromCEP($nrcep){

        $data = Address::getCEP($nrcep);

        if(isset($data["logradouro"]) && $data["logradouro"]){

            $this->setdesaddress($data['logradouro']);
			$this->setdescomplement($data['complemento']);
			$this->setdesdistrict($data['bairro']);
			$this->setdescity($data['localidade']);
			$this->setdesstate($data['uf']);
			$this->setdescountry('Brasil');
			$this->setdeszipcode($nrcep);

        }
    }


    public function save(){

        $sql = new Sql();

        $results = $sql->select("CALL sp_addresses_save(:idaddress, :idperson, :desaddress,:desnumber, :descomplement, :descity, :desstate, :descountry, :deszipcode, :desdistrict)", [
			':idaddress'=>$this->getidaddress(),
			':idperson'=>$this->getidperson(),
			':desaddress'=>mb_convert_encoding($this->getdesaddress(), "Windows-1252", "UTF-8"),
			":desnumber"=>$this->getdesnumber(),
			':descomplement'=>mb_convert_encoding($this->getdescomplement(), "Windows-1252", "UTF-8"),
			':descity'=>mb_convert_encoding($this->getdescity(), "Windows-1252", "UTF-8"),
			':desstate'=>mb_convert_encoding($this->getdesstate(), "Windows-1252", "UTF-8"),
			':descountry'=>mb_convert_encoding($this->getdescountry(), "Windows-1252", "UTF-8"),
			':deszipcode'=>$this->getdeszipcode(),
			':desdistrict'=>$this->getdesdistrict()
		]);

        if (count($results) > 0) {
			$this->setData($results[0]);
		}
    }

    public static function setMsgErro($msg)
	{
		$_SESSION[Address::SESSION_ERROR] = $msg;
	}

	public static function getMsgErro()
	{

		$msg = (isset($_SESSION[Address::SESSION_ERROR])) ? $_SESSION[Address::SESSION_ERROR] : "";
		Address::clearMsgErro();
		return $msg;
	}

	public static function clearMsgErro()
	{
		$_SESSION[Address::SESSION_ERROR] = NULL;
	}
}




?>