<?php


namespace projeto;



class Model
{
    private $value = [];

    public function __call($name, $args)
    {
        $method = substr($name, 0, 3);
        $fildName = substr($name, 3, strlen($name));

        switch ($method) {

            case "get":
                return $this->value[$fildName];

            case "set":
                $this->value[$fildName] = $args[0];
                break;

        }
        ;
    }

    public function setData($data = array()){
        foreach ($data as $key => $value) {
            $this->{"set".$key}($value);
        }
    }

    public function getValues(){
        return $this->value;
    }
}



?>