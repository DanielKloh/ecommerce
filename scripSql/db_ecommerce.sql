-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Tempo de geração: 29/05/2023 às 02:23
-- Versão do servidor: 10.4.28-MariaDB
-- Versão do PHP: 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Banco de dados: `db_ecommerce`
--

DELIMITER $$
--
-- Procedimentos
--
CREATE  PROCEDURE `sp_addresses_save` (`pidaddress` INT(11), `pidperson` INT(11), `pdesaddress` VARCHAR(128), `pdesnumber` VARCHAR(16), `pdescomplement` VARCHAR(32), `pdescity` VARCHAR(32), `pdesstate` VARCHAR(32), `pdescountry` VARCHAR(32), `pdeszipcode` CHAR(8), `pdesdistrict` VARCHAR(32))   BEGIN

	IF pidaddress > 0 THEN
		
		UPDATE tb_addresses
        SET
			idperson = pidperson,
            desaddress = pdesaddress,
            desnumber = pdesnumber,
            descomplement = pdescomplement,
            descity = pdescity,
            desstate = pdesstate,
            descountry = pdescountry,
            deszipcode = pdeszipcode, 
            desdistrict = pdesdistrict
		WHERE idaddress = pidaddress;
        
    ELSE
		
		INSERT INTO tb_addresses (idperson, desaddress, desnumber, descomplement, descity, desstate, descountry, deszipcode, desdistrict)
        VALUES(pidperson, pdesaddress, pdesnumber, pdescomplement, pdescity, pdesstate, pdescountry, pdeszipcode, pdesdistrict);
        
        SET pidaddress = LAST_INSERT_ID();
        
    END IF;
    
    SELECT * FROM tb_addresses WHERE idaddress = pidaddress;

END$$

CREATE  PROCEDURE `sp_carts_save` (`pidcart` INT, `pdessessionid` VARCHAR(64), `piduser` INT, `pdeszipcode` CHAR(8), `pvlfreight` DECIMAL(10,2), `pnrdays` INT)   BEGIN

    IF pidcart > 0 THEN
        
        UPDATE tb_carts
        SET
            dessessionid = pdessessionid,
            iduser = piduser,
            deszipcode = pdeszipcode,
            vlfreight = pvlfreight,
            nrdays = pnrdays
        WHERE idcart = pidcart;
        
    ELSE
        
        INSERT INTO tb_carts (dessessionid, iduser, deszipcode, vlfreight, nrdays)
        VALUES(pdessessionid, piduser, pdeszipcode, pvlfreight, pnrdays);
        
        SET pidcart = LAST_INSERT_ID();
        
    END IF;
    
    SELECT * FROM tb_carts WHERE idcart = pidcart;

END$$

CREATE  PROCEDURE `sp_categories_save` (`pidcategory` INT, `pdescategory` VARCHAR(64))   BEGIN
	
	IF pidcategory > 0 THEN
		
		UPDATE tb_categories
        SET descategory = pdescategory
        WHERE idcategory = pidcategory;
        
    ELSE
		
		INSERT INTO tb_categories (descategory) VALUES(pdescategory);
        
        SET pidcategory = LAST_INSERT_ID();
        
    END IF;
    
    SELECT * FROM tb_categories WHERE idcategory = pidcategory;
    
END$$

CREATE  PROCEDURE `sp_orders_save` (`pidorder` INT, `pidcart` INT(11), `piduser` INT(11), `pidstatus` INT(11), `pidaddress` INT(11), `pvltotal` DECIMAL(10,2))   BEGIN
	
	IF pidorder > 0 THEN
		
		UPDATE tb_orders
        SET
			idcart = pidcart,
            iduser = piduser,
            idstatus = pidstatus,
            idaddress = pidaddress,
            vltotal = pvltotal
		WHERE idorder = pidorder;
        
    ELSE
    
		INSERT INTO tb_orders (idcart, iduser, idstatus, idaddress, vltotal)
        VALUES(pidcart, piduser, pidstatus, pidaddress, pvltotal);
		
		SET pidorder = LAST_INSERT_ID();
        
    END IF;
    
    SELECT * 
    FROM tb_orders a
    INNER JOIN tb_ordersstatus b USING(idstatus)
    INNER JOIN tb_carts c USING(idcart)
    INNER JOIN tb_users d ON d.iduser = a.iduser
    INNER JOIN tb_addresses e USING(idaddress)
    WHERE idorder = pidorder;
    
END$$

CREATE  PROCEDURE `sp_products_save` (`pidproduct` INT(11), `pdesproduct` VARCHAR(64), `pvlprice` DECIMAL(10,2), `pvlwidth` DECIMAL(10,2), `pvlheight` DECIMAL(10,2), `pvllength` DECIMAL(10,2), `pvlweight` DECIMAL(10,2), `pdesurl` VARCHAR(128))   BEGIN
	
	IF pidproduct > 0 THEN
		
		UPDATE tb_products
        SET 
			desproduct = pdesproduct,
            vlprice = pvlprice,
            vlwidth = pvlwidth,
            vlheight = pvlheight,
            vllength = pvllength,
            vlweight = pvlweight,
            desurl = pdesurl
        WHERE idproduct = pidproduct;
        
    ELSE
		
		INSERT INTO tb_products (desproduct, vlprice, vlwidth, vlheight, vllength, vlweight, desurl) 
        VALUES(pdesproduct, pvlprice, pvlwidth, pvlheight, pvllength, pvlweight, pdesurl);
        
        SET pidproduct = LAST_INSERT_ID();
        
    END IF;
    
    SELECT * FROM tb_products WHERE idproduct = pidproduct;
    
END$$

CREATE  PROCEDURE `sp_userspasswordsrecoveries_create` (`piduser` INT, `pdesip` VARCHAR(45))   BEGIN
  
  INSERT INTO tb_userspasswordsrecoveries (iduser, desip)
    VALUES(piduser, pdesip);
    
    SELECT * FROM tb_userspasswordsrecoveries
    WHERE idrecovery = LAST_INSERT_ID();
    
END$$

CREATE  PROCEDURE `sp_usersupdate_save` (`piduser` INT, `pdesperson` VARCHAR(64), `pdeslogin` VARCHAR(64), `pdespassword` VARCHAR(256), `pdesemail` VARCHAR(128), `pnrphone` BIGINT, `pinadmin` TINYINT)   BEGIN
  
    DECLARE vidperson INT;
    
  SELECT idperson INTO vidperson
    FROM tb_users
    WHERE iduser = piduser;
    
    UPDATE tb_persons
    SET 
    desperson = pdesperson,
        desemail = pdesemail,
        nrphone = pnrphone
  WHERE idperson = vidperson;
    
    UPDATE tb_users
    SET
    deslogin = pdeslogin,
        despassword = pdespassword,
        inadmin = pinadmin
  WHERE iduser = piduser;
    
    SELECT * FROM tb_users a INNER JOIN tb_persons b USING(idperson) WHERE a.iduser = piduser;
    
END$$

CREATE  PROCEDURE `sp_users_delete` (`piduser` INT)   BEGIN
    
    DECLARE vidperson INT;
    
    SET FOREIGN_KEY_CHECKS = 0;
	
	SELECT idperson INTO vidperson
    FROM tb_users
    WHERE iduser = piduser;
	
    DELETE FROM tb_addresses WHERE idperson = vidperson;
    DELETE FROM tb_addresses WHERE idaddress IN(SELECT idaddress FROM tb_orders WHERE iduser = piduser);
	DELETE FROM tb_persons WHERE idperson = vidperson;
    
    DELETE FROM tb_userslogs WHERE iduser = piduser;
    DELETE FROM tb_userspasswordsrecoveries WHERE iduser = piduser;
    DELETE FROM tb_orders WHERE iduser = piduser;
    DELETE FROM tb_cartsproducts WHERE idcart IN(SELECT idcart FROM tb_carts WHERE iduser = piduser);
    DELETE FROM tb_carts WHERE iduser = piduser;
    DELETE FROM tb_users WHERE iduser = piduser;
    
    SET FOREIGN_KEY_CHECKS = 1;
    
END$$

CREATE  PROCEDURE `sp_users_save` (`pdesperson` VARCHAR(64), `pdeslogin` VARCHAR(64), `pdespassword` VARCHAR(256), `pdesemail` VARCHAR(128), `pnrphone` BIGINT, `pinadmin` TINYINT)   BEGIN
  
    DECLARE vidperson INT;
    
  INSERT INTO tb_persons (desperson, desemail, nrphone)
    VALUES(pdesperson, pdesemail, pnrphone);
    
    SET vidperson = LAST_INSERT_ID();
    
    INSERT INTO tb_users (idperson, deslogin, despassword, inadmin)
    VALUES(vidperson, pdeslogin, pdespassword, pinadmin);
    
    SELECT * FROM tb_users a INNER JOIN tb_persons b USING(idperson) WHERE a.iduser = LAST_INSERT_ID();
    
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estrutura para tabela `tb_addresses`
--

CREATE TABLE `tb_addresses` (
  `idaddress` int(11) NOT NULL,
  `idperson` int(11) NOT NULL,
  `desaddress` varchar(128) NOT NULL,
  `desnumber` varchar(16) NOT NULL,
  `descomplement` varchar(32) DEFAULT NULL,
  `descity` varchar(32) NOT NULL,
  `desstate` varchar(32) NOT NULL,
  `descountry` varchar(32) NOT NULL,
  `deszipcode` char(8) NOT NULL,
  `desdistrict` varchar(32) NOT NULL,
  `dtregister` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `tb_carts`
--

CREATE TABLE `tb_carts` (
  `idcart` int(11) NOT NULL,
  `dessessionid` varchar(64) NOT NULL,
  `iduser` int(11) DEFAULT NULL,
  `deszipcode` char(8) DEFAULT NULL,
  `vlfreight` decimal(10,2) DEFAULT NULL,
  `nrdays` int(11) DEFAULT NULL,
  `dtregister` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Despejando dados para a tabela `tb_carts`
--

INSERT INTO `tb_carts` (`idcart`, `dessessionid`, `iduser`, `deszipcode`, `vlfreight`, `nrdays`, `dtregister`) VALUES
(1, '6fms1i0r1ir1ncih55377a6l6o', NULL, NULL, NULL, NULL, '2023-05-11 15:38:27'),
(2, 'mv2hktospf8fma1un29m22ii1t', NULL, NULL, NULL, NULL, '2023-05-12 01:56:49'),
(3, '6rsle9u7j6b7r6255seqopoehm', NULL, '22041080', 0.00, 0, '2023-05-12 14:16:23'),
(4, 's1d598rvie4fk1cjrsl7muanfr', NULL, '96825358', 176.76, 2, '2023-05-13 13:17:51'),
(5, 'ggmh1vqmo38qnhh0j9vj4cmp4n', NULL, '96825358', 176.76, 2, '2023-05-15 17:32:11'),
(6, 'pq1ie1lpe1do26l6eqip17glou', NULL, NULL, NULL, NULL, '2023-05-15 20:10:53'),
(7, '5c8bur74dep8ud9og2n5igmlrf', NULL, '96825358', 0.00, 0, '2023-05-16 14:05:16'),
(8, 'ktdhi299pstcvcr799aj2sdv9i', NULL, '96825358', 285.16, 2, '2023-05-17 15:29:29'),
(9, 'gj5kbk2mid1ruk0gcrqspussej', NULL, '96825358', 285.16, 2, '2023-05-17 17:42:16'),
(10, 'j3bbk0888okf7ri044e7loamhd', NULL, '96825358', 285.16, 2, '2023-05-18 13:33:32'),
(11, 'k7ai1vbkr82g0olpp18u67idhb', NULL, '96825358', 245.16, 2, '2023-05-18 16:39:38'),
(12, '2bc6v4j9uq9iafuo6a5oc97ic1', NULL, '96825358', 176.76, 2, '2023-05-19 17:54:21'),
(13, '1r8qi47dt1oc45h0o8u03chckd', NULL, '96825358', 556.16, 2, '2023-05-22 18:36:50'),
(14, '68bi48t188iv5a87qfr8kuf8l2', NULL, NULL, NULL, NULL, '2023-05-23 17:52:53'),
(15, 'phd6ce9s9rkpvvinua4s039ouv', NULL, NULL, NULL, NULL, '2023-05-23 19:30:22'),
(16, 'fnu09mb1ul0q18esvklfqhsgaq', NULL, NULL, NULL, NULL, '2023-05-24 14:23:00'),
(17, 'lb4khn6irjlqqaenjv9cakcfp2', NULL, NULL, NULL, NULL, '2023-05-24 17:01:09'),
(18, 'ep4qgvac3q0dgevho6p15bh91u', NULL, NULL, NULL, NULL, '2023-05-25 13:14:14'),
(19, '9t2sukm66ma2gnifrnc740n2rh', NULL, NULL, NULL, NULL, '2023-05-25 17:54:57'),
(20, 'e3e06jq9kvkqrl3t5i6i2qaniu', NULL, NULL, NULL, NULL, '2023-05-25 20:53:23'),
(21, '9gk4uf9kddt2oi66ssjprfj2nt', NULL, '96825358', 0.00, 0, '2023-05-26 13:02:26'),
(22, '37ujum8lo002rgrvp9dfp8vh3k', NULL, NULL, NULL, NULL, '2023-05-26 15:44:38'),
(23, 'fc20s5emoe1vd3rgv1r3h046ea', NULL, NULL, NULL, NULL, '2023-05-26 18:46:42');

-- --------------------------------------------------------

--
-- Estrutura para tabela `tb_cartsproducts`
--

CREATE TABLE `tb_cartsproducts` (
  `idcartproduct` int(11) NOT NULL,
  `idcart` int(11) NOT NULL,
  `idproduct` int(11) NOT NULL,
  `dtremoved` datetime NOT NULL,
  `dtregister` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Despejando dados para a tabela `tb_cartsproducts`
--

INSERT INTO `tb_cartsproducts` (`idcartproduct`, `idcart`, `idproduct`, `dtremoved`, `dtregister`) VALUES
(104, 21, 14, '0000-00-00 00:00:00', '2023-05-26 14:13:30'),
(105, 21, 3, '0000-00-00 00:00:00', '2023-05-26 14:13:35'),
(106, 21, 5, '0000-00-00 00:00:00', '2023-05-26 14:13:47'),
(107, 21, 5, '0000-00-00 00:00:00', '2023-05-26 14:14:49'),
(108, 21, 5, '0000-00-00 00:00:00', '2023-05-26 14:14:49'),
(109, 21, 5, '0000-00-00 00:00:00', '2023-05-26 14:14:49');

-- --------------------------------------------------------

--
-- Estrutura para tabela `tb_categories`
--

CREATE TABLE `tb_categories` (
  `idcategory` int(11) NOT NULL,
  `descategory` varchar(32) NOT NULL,
  `dtregister` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Despejando dados para a tabela `tb_categories`
--

INSERT INTO `tb_categories` (`idcategory`, `descategory`, `dtregister`) VALUES
(2, 'Android', '2023-05-09 15:32:57'),
(3, 'Aple', '2023-05-09 15:33:07'),
(4, 'Sansung', '2023-05-09 15:33:17'),
(5, 'Motorola', '2023-05-09 15:33:22');

-- --------------------------------------------------------

--
-- Estrutura para tabela `tb_categoriesproducts`
--

CREATE TABLE `tb_categoriesproducts` (
  `idcategory` int(11) NOT NULL,
  `idproduct` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `tb_orders`
--

CREATE TABLE `tb_orders` (
  `idorder` int(11) NOT NULL,
  `idcart` int(11) NOT NULL,
  `iduser` int(11) NOT NULL,
  `idstatus` int(11) NOT NULL,
  `idaddress` int(11) NOT NULL,
  `vltotal` decimal(10,2) NOT NULL,
  `dtregister` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `tb_ordersstatus`
--

CREATE TABLE `tb_ordersstatus` (
  `idstatus` int(11) NOT NULL,
  `desstatus` varchar(32) NOT NULL,
  `dtregister` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Despejando dados para a tabela `tb_ordersstatus`
--

INSERT INTO `tb_ordersstatus` (`idstatus`, `desstatus`, `dtregister`) VALUES
(1, 'Em Aberto', '2017-03-13 06:00:00'),
(2, 'Aguardando Pagamento', '2017-03-13 06:00:00'),
(3, 'Pago', '2017-03-13 06:00:00'),
(4, 'Entregue', '2017-03-13 06:00:00');

-- --------------------------------------------------------

--
-- Estrutura para tabela `tb_persons`
--

CREATE TABLE `tb_persons` (
  `idperson` int(11) NOT NULL,
  `desperson` varchar(64) NOT NULL,
  `desemail` varchar(128) DEFAULT NULL,
  `nrphone` bigint(20) DEFAULT NULL,
  `dtregister` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Despejando dados para a tabela `tb_persons`
--

INSERT INTO `tb_persons` (`idperson`, `desperson`, `desemail`, `nrphone`, `dtregister`) VALUES
(18, 'Daniel Kloh', 'danielkloh06@gmail.com', 9953330699, '2023-05-16 18:33:01'),
(19, 'Daniel', 'danielkloh06@gmail.com', 9953330699, '2023-05-16 18:47:52'),
(20, 'teste testdado', 'teste@gmail.com', 113259667, '2023-05-16 19:15:53'),
(44, 'admin', 'admin@gmail.com', 99999999, '2023-05-22 19:45:28'),
(47, 'Daniel', 'danielkloh06@gmail.com', 995330699, '2023-05-23 17:54:10');

-- --------------------------------------------------------

--
-- Estrutura para tabela `tb_products`
--

CREATE TABLE `tb_products` (
  `idproduct` int(11) NOT NULL,
  `desproduct` varchar(64) NOT NULL,
  `vlprice` decimal(10,2) NOT NULL,
  `vlwidth` decimal(10,2) NOT NULL,
  `vlheight` decimal(10,2) NOT NULL,
  `vllength` decimal(10,2) NOT NULL,
  `vlweight` decimal(10,2) NOT NULL,
  `desurl` varchar(128) NOT NULL,
  `dtregister` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Despejando dados para a tabela `tb_products`
--

INSERT INTO `tb_products` (`idproduct`, `desproduct`, `vlprice`, `vlwidth`, `vlheight`, `vllength`, `vlweight`, `desurl`, `dtregister`) VALUES
(1, 'Smartphone Android 7.0', 999.95, 75.00, 151.00, 80.00, 167.00, 'smartphone-android-7.0', '2017-03-13 06:00:00'),
(3, 'Notebook 14\" 4GB 1TB', 1949.99, 345.00, 23.00, 30.00, 2000.00, 'notebook-14-4gb-1tb', '2017-03-13 06:00:00'),
(5, 'xirofonfula', 90000.50, 9688.00, 757.00, 2857.00, 757.00, 'xirofonfula', '2023-05-09 15:40:31'),
(6, 'Smartphone Samsung Galaxy M53 128GB Azul 5G', 3499.99, 10.00, 10.00, 10.00, 10.00, 'Smartphone_Samsung_Galaxy_M53_128GB_Azul_5G', '2023-05-10 18:34:58'),
(7, 'Google Pixel 6 128Gb 8Gb Ram Sorta Seafoam', 5500.00, 10.00, 10.00, 10.00, 10.00, 'Google_Pixel_6_128Gb_8Gb_Ram_Sorta_Seafoam', '2023-05-10 18:36:44'),
(8, 'Smartphone moto z play', 2300.00, 16.00, 5.00, 2.00, 5.00, 'Smartphone-moto-z-play', '2023-05-12 16:51:48'),
(14, 'Monitor Gamer', 1800.00, 10.00, 10.00, 10.00, 10.00, 'monitor-gamer', '2023-05-25 18:51:53'),
(15, 'SmartTV LED 4K', 20000.00, 100.00, 100.00, 100.00, 8.00, 'SmartTV-LED-4K', '2023-05-25 20:55:25');

-- --------------------------------------------------------

--
-- Estrutura para tabela `tb_productscategories`
--

CREATE TABLE `tb_productscategories` (
  `idcategory` int(11) NOT NULL,
  `idproduct` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Despejando dados para a tabela `tb_productscategories`
--

INSERT INTO `tb_productscategories` (`idcategory`, `idproduct`) VALUES
(2, 1),
(2, 5),
(2, 6),
(2, 7),
(4, 5),
(4, 6),
(5, 5),
(5, 8);

-- --------------------------------------------------------

--
-- Estrutura para tabela `tb_users`
--

CREATE TABLE `tb_users` (
  `iduser` int(11) NOT NULL,
  `idperson` int(11) NOT NULL,
  `deslogin` varchar(64) NOT NULL,
  `despassword` varchar(256) NOT NULL,
  `inadmin` tinyint(4) NOT NULL DEFAULT 0,
  `dtregister` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Despejando dados para a tabela `tb_users`
--

INSERT INTO `tb_users` (`iduser`, `idperson`, `deslogin`, `despassword`, `inadmin`, `dtregister`) VALUES
(41, 44, 'admin', '$2y$12$EOKuOvMvlNeptz6FpHVoSeAU8UAdK5SRvcRNQNe/HQkD/CUjSPA6q', 1, '2023-05-22 19:45:28'),
(44, 47, 'daniel', '$2y$12$OABe7cZJyz67C0eUYO6v8.0xmhznJrkuBqzWbZKPlP44R5Fpy1Ume', 1, '2023-05-23 17:54:10');

-- --------------------------------------------------------

--
-- Estrutura para tabela `tb_userslogs`
--

CREATE TABLE `tb_userslogs` (
  `idlog` int(11) NOT NULL,
  `iduser` int(11) NOT NULL,
  `deslog` varchar(128) NOT NULL,
  `desip` varchar(45) NOT NULL,
  `desuseragent` varchar(128) NOT NULL,
  `dessessionid` varchar(64) NOT NULL,
  `desurl` varchar(128) NOT NULL,
  `dtregister` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `tb_userspasswordsrecoveries`
--

CREATE TABLE `tb_userspasswordsrecoveries` (
  `idrecovery` int(11) NOT NULL,
  `iduser` int(11) NOT NULL,
  `desip` varchar(45) NOT NULL,
  `dtrecovery` datetime DEFAULT NULL,
  `dtregister` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Despejando dados para a tabela `tb_userspasswordsrecoveries`
--

INSERT INTO `tb_userspasswordsrecoveries` (`idrecovery`, `iduser`, `desip`, `dtrecovery`, `dtregister`) VALUES
(6, 44, '127.0.0.1', NULL, '2023-05-23 17:55:25'),
(7, 44, '127.0.0.1', NULL, '2023-05-23 17:56:59'),
(8, 44, '127.0.0.1', NULL, '2023-05-23 17:57:03'),
(9, 44, '127.0.0.1', NULL, '2023-05-23 18:00:40'),
(10, 44, '127.0.0.1', NULL, '2023-05-23 18:00:57'),
(11, 44, '127.0.0.1', NULL, '2023-05-23 18:01:07'),
(12, 44, '127.0.0.1', NULL, '2023-05-23 18:01:17'),
(13, 44, '127.0.0.1', NULL, '2023-05-23 18:01:30'),
(14, 44, '127.0.0.1', NULL, '2023-05-23 18:01:45'),
(15, 44, '127.0.0.1', NULL, '2023-05-23 18:01:54'),
(16, 44, '127.0.0.1', NULL, '2023-05-23 18:04:23'),
(17, 44, '127.0.0.1', NULL, '2023-05-23 18:04:44'),
(18, 44, '127.0.0.1', NULL, '2023-05-23 18:05:10'),
(19, 44, '127.0.0.1', NULL, '2023-05-23 18:05:22'),
(20, 44, '127.0.0.1', NULL, '2023-05-23 18:05:36'),
(21, 44, '127.0.0.1', NULL, '2023-05-23 18:07:21'),
(22, 44, '127.0.0.1', NULL, '2023-05-23 18:07:39'),
(23, 44, '127.0.0.1', NULL, '2023-05-23 18:07:46'),
(24, 44, '127.0.0.1', NULL, '2023-05-23 18:08:04'),
(25, 44, '127.0.0.1', NULL, '2023-05-23 18:08:18'),
(26, 44, '127.0.0.1', NULL, '2023-05-23 18:08:33'),
(27, 44, '127.0.0.1', NULL, '2023-05-23 18:20:45'),
(28, 44, '127.0.0.1', NULL, '2023-05-23 18:22:03'),
(29, 44, '127.0.0.1', NULL, '2023-05-23 18:24:28'),
(30, 44, '127.0.0.1', NULL, '2023-05-23 18:28:46'),
(31, 44, '127.0.0.1', NULL, '2023-05-23 18:38:41'),
(32, 44, '127.0.0.1', NULL, '2023-05-23 18:39:02'),
(33, 44, '127.0.0.1', NULL, '2023-05-23 18:44:29'),
(34, 44, '127.0.0.1', NULL, '2023-05-23 18:45:32'),
(35, 44, '127.0.0.1', NULL, '2023-05-23 18:46:22'),
(36, 44, '127.0.0.1', NULL, '2023-05-23 18:47:47'),
(37, 44, '127.0.0.1', NULL, '2023-05-23 18:48:20'),
(38, 44, '127.0.0.1', NULL, '2023-05-23 18:48:54'),
(39, 44, '127.0.0.1', NULL, '2023-05-23 18:49:17'),
(40, 44, '127.0.0.1', NULL, '2023-05-23 18:50:06'),
(41, 44, '127.0.0.1', NULL, '2023-05-23 18:51:55'),
(42, 44, '127.0.0.1', NULL, '2023-05-23 18:54:45'),
(43, 44, '127.0.0.1', NULL, '2023-05-23 19:02:17'),
(44, 44, '127.0.0.1', NULL, '2023-05-23 19:05:13'),
(45, 44, '127.0.0.1', NULL, '2023-05-23 19:06:53'),
(46, 44, '127.0.0.1', NULL, '2023-05-23 19:09:27'),
(47, 44, '127.0.0.1', NULL, '2023-05-23 19:10:41'),
(48, 44, '127.0.0.1', NULL, '2023-05-23 19:15:14'),
(49, 44, '127.0.0.1', NULL, '2023-05-23 19:20:53'),
(50, 44, '::1', NULL, '2023-05-24 14:10:32'),
(51, 44, '::1', NULL, '2023-05-24 14:18:54'),
(52, 44, '::1', NULL, '2023-05-24 14:22:13'),
(53, 44, '::1', '2023-05-24 11:32:19', '2023-05-24 14:23:59'),
(54, 44, '::1', '2023-05-24 11:34:56', '2023-05-24 14:34:39'),
(57, 44, '127.0.0.1', NULL, '2023-05-24 17:09:09');

--
-- Índices para tabelas despejadas
--

--
-- Índices de tabela `tb_addresses`
--
ALTER TABLE `tb_addresses`
  ADD PRIMARY KEY (`idaddress`),
  ADD KEY `fk_addresses_persons_idx` (`idperson`);

--
-- Índices de tabela `tb_carts`
--
ALTER TABLE `tb_carts`
  ADD PRIMARY KEY (`idcart`),
  ADD KEY `FK_carts_users_idx` (`iduser`);

--
-- Índices de tabela `tb_cartsproducts`
--
ALTER TABLE `tb_cartsproducts`
  ADD PRIMARY KEY (`idcartproduct`),
  ADD KEY `FK_cartsproducts_carts_idx` (`idcart`),
  ADD KEY `FK_cartsproducts_products_idx` (`idproduct`);

--
-- Índices de tabela `tb_categories`
--
ALTER TABLE `tb_categories`
  ADD PRIMARY KEY (`idcategory`);

--
-- Índices de tabela `tb_categoriesproducts`
--
ALTER TABLE `tb_categoriesproducts`
  ADD PRIMARY KEY (`idcategory`,`idproduct`);

--
-- Índices de tabela `tb_orders`
--
ALTER TABLE `tb_orders`
  ADD PRIMARY KEY (`idorder`),
  ADD KEY `FK_orders_users_idx` (`iduser`),
  ADD KEY `fk_orders_ordersstatus_idx` (`idstatus`),
  ADD KEY `fk_orders_carts_idx` (`idcart`),
  ADD KEY `fk_orders_addresses_idx` (`idaddress`);

--
-- Índices de tabela `tb_ordersstatus`
--
ALTER TABLE `tb_ordersstatus`
  ADD PRIMARY KEY (`idstatus`);

--
-- Índices de tabela `tb_persons`
--
ALTER TABLE `tb_persons`
  ADD PRIMARY KEY (`idperson`);

--
-- Índices de tabela `tb_products`
--
ALTER TABLE `tb_products`
  ADD PRIMARY KEY (`idproduct`);

--
-- Índices de tabela `tb_productscategories`
--
ALTER TABLE `tb_productscategories`
  ADD PRIMARY KEY (`idcategory`,`idproduct`),
  ADD KEY `fk_productscategories_products_idx` (`idproduct`);

--
-- Índices de tabela `tb_users`
--
ALTER TABLE `tb_users`
  ADD PRIMARY KEY (`iduser`),
  ADD KEY `FK_users_persons_idx` (`idperson`);

--
-- Índices de tabela `tb_userslogs`
--
ALTER TABLE `tb_userslogs`
  ADD PRIMARY KEY (`idlog`),
  ADD KEY `fk_userslogs_users_idx` (`iduser`);

--
-- Índices de tabela `tb_userspasswordsrecoveries`
--
ALTER TABLE `tb_userspasswordsrecoveries`
  ADD PRIMARY KEY (`idrecovery`),
  ADD KEY `fk_userspasswordsrecoveries_users_idx` (`iduser`);

--
-- AUTO_INCREMENT para tabelas despejadas
--

--
-- AUTO_INCREMENT de tabela `tb_addresses`
--
ALTER TABLE `tb_addresses`
  MODIFY `idaddress` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de tabela `tb_carts`
--
ALTER TABLE `tb_carts`
  MODIFY `idcart` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;

--
-- AUTO_INCREMENT de tabela `tb_cartsproducts`
--
ALTER TABLE `tb_cartsproducts`
  MODIFY `idcartproduct` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=110;

--
-- AUTO_INCREMENT de tabela `tb_categories`
--
ALTER TABLE `tb_categories`
  MODIFY `idcategory` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT de tabela `tb_orders`
--
ALTER TABLE `tb_orders`
  MODIFY `idorder` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT de tabela `tb_ordersstatus`
--
ALTER TABLE `tb_ordersstatus`
  MODIFY `idstatus` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de tabela `tb_persons`
--
ALTER TABLE `tb_persons`
  MODIFY `idperson` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=52;

--
-- AUTO_INCREMENT de tabela `tb_products`
--
ALTER TABLE `tb_products`
  MODIFY `idproduct` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT de tabela `tb_users`
--
ALTER TABLE `tb_users`
  MODIFY `iduser` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=49;

--
-- AUTO_INCREMENT de tabela `tb_userslogs`
--
ALTER TABLE `tb_userslogs`
  MODIFY `idlog` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `tb_userspasswordsrecoveries`
--
ALTER TABLE `tb_userspasswordsrecoveries`
  MODIFY `idrecovery` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=74;

--
-- Restrições para tabelas despejadas
--

--
-- Restrições para tabelas `tb_addresses`
--
ALTER TABLE `tb_addresses`
  ADD CONSTRAINT `fk_addresses_persons` FOREIGN KEY (`idperson`) REFERENCES `tb_persons` (`idperson`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Restrições para tabelas `tb_carts`
--
ALTER TABLE `tb_carts`
  ADD CONSTRAINT `fk_carts_users` FOREIGN KEY (`iduser`) REFERENCES `tb_users` (`iduser`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Restrições para tabelas `tb_cartsproducts`
--
ALTER TABLE `tb_cartsproducts`
  ADD CONSTRAINT `fk_cartsproducts_carts` FOREIGN KEY (`idcart`) REFERENCES `tb_carts` (`idcart`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_cartsproducts_products` FOREIGN KEY (`idproduct`) REFERENCES `tb_products` (`idproduct`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Restrições para tabelas `tb_orders`
--
ALTER TABLE `tb_orders`
  ADD CONSTRAINT `fk_orders_addresses` FOREIGN KEY (`idaddress`) REFERENCES `tb_addresses` (`idaddress`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_orders_carts` FOREIGN KEY (`idcart`) REFERENCES `tb_carts` (`idcart`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_orders_ordersstatus` FOREIGN KEY (`idstatus`) REFERENCES `tb_ordersstatus` (`idstatus`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_orders_users` FOREIGN KEY (`iduser`) REFERENCES `tb_users` (`iduser`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Restrições para tabelas `tb_productscategories`
--
ALTER TABLE `tb_productscategories`
  ADD CONSTRAINT `fk_productscategories_categories` FOREIGN KEY (`idcategory`) REFERENCES `tb_categories` (`idcategory`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_productscategories_products` FOREIGN KEY (`idproduct`) REFERENCES `tb_products` (`idproduct`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Restrições para tabelas `tb_users`
--
ALTER TABLE `tb_users`
  ADD CONSTRAINT `fk_users_persons` FOREIGN KEY (`idperson`) REFERENCES `tb_persons` (`idperson`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Restrições para tabelas `tb_userslogs`
--
ALTER TABLE `tb_userslogs`
  ADD CONSTRAINT `fk_userslogs_users` FOREIGN KEY (`iduser`) REFERENCES `tb_users` (`iduser`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Restrições para tabelas `tb_userspasswordsrecoveries`
--
ALTER TABLE `tb_userspasswordsrecoveries`
  ADD CONSTRAINT `fk_userspasswordsrecoveries_users` FOREIGN KEY (`iduser`) REFERENCES `tb_users` (`iduser`) ON DELETE NO ACTION ON UPDATE NO ACTION;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
