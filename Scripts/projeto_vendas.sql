-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Tempo de geração: 05-Ago-2024 às 14:57
-- Versão do servidor: 10.4.27-MariaDB
-- versão do PHP: 8.2.0

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Banco de dados: `projeto_vendas`
--

DELIMITER $$
--
-- Procedimentos
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `Gravar_Pedido` (IN `p_numPedido` INT, IN `p_dtEmissao` DATE, IN `p_codCliente` INT, IN `p_vlTotal` DECIMAL(10,2), IN `p_codProduto` INT, IN `p_quantidade` INT, IN `p_vlUnitario` DECIMAL(10,2))   BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        -- Rollback the transaction in case of an error
        ROLLBACK;
        RESIGNAL;
    END;

    -- Start transaction
    START TRANSACTION;

    -- Insert into Pedidos_Gerais
    INSERT INTO Pedidos_Gerais (numPedido, dtEmissao, codCliente, vlTotal)
    VALUES (p_numPedido, p_dtEmissao, p_codCliente, p_vlTotal);

    -- Insert into Pedidos_Produtos
    INSERT INTO Pedidos_Produtos (numPedido, codProduto, quantidade, vlUnitario)
    VALUES (p_numPedido, p_codProduto, p_quantidade, p_vlUnitario);

    -- Commit the transaction
    COMMIT;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Insere_Remove_Produtos` (IN `p_condicao` CHAR(1), IN `p_codProduto` INT, IN `p_quantidade` INT, IN `p_vlUnitario` DECIMAL(10,2), IN `p_descricao` VARCHAR(255), IN `p_precVenda` DECIMAL(10,2))   BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        -- Rollback the transaction in case of an error
        ROLLBACK;
        RESIGNAL;
    END;

    -- Start transaction
    START TRANSACTION;

    IF p_condicao = 'I' THEN
        -- Insert into Pedidos_Produtos
        INSERT INTO Pedidos_Produtos (codProduto, quantidade, vlUnitario)
        VALUES (p_codProduto, p_quantidade, p_vlUnitario);

        -- Insert into Produtos
        INSERT INTO Produtos (codigo, descricao, precVenda)
        VALUES (p_codProduto, p_descricao, p_precVenda);

    ELSEIF p_condicao = 'R' THEN
        -- Delete from Pedidos_Produtos
        DELETE FROM Pedidos_Produtos
        WHERE codProduto = p_codProduto;

        -- Delete from Produtos
        DELETE FROM Produtos
        WHERE codigo = p_codProduto;
    END IF;

    -- Commit the transaction
    COMMIT;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Obtem_Produtos` ()   BEGIN
    SELECT 
        p.codigo AS ProdutoCodigo,
        p.descricao AS ProdutoDescricao,
        COALESCE(pp.quantidade, 0) AS Quantidade,
        COALESCE(pp.vlUnitario, 0) AS ValorUnitario,
        COALESCE(pp.quantidade * pp.vlUnitario, 0) AS ValorTotal
    FROM 
        Produtos p
    LEFT JOIN 
        Pedidos_Produtos pp ON p.codigo = pp.codProduto;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estrutura da tabela `clientes`
--

CREATE TABLE `clientes` (
  `codigo` int(11) NOT NULL,
  `nome` varchar(100) NOT NULL,
  `cidade` varchar(100) DEFAULT NULL,
  `uf` char(2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Extraindo dados da tabela `clientes`
--

INSERT INTO `clientes` (`codigo`, `nome`, `cidade`, `uf`) VALUES
(1, 'João da Silva', 'São Paulo', 'SP'),
(2, 'Maria Oliveira', 'Rio de Janeiro', 'RJ'),
(3, 'Pedro Santos', 'Belo Horizonte', 'MG'),
(4, 'Ana Costa', 'Salvador', 'BA'),
(5, 'Lucas Pereira', 'Porto Alegre', 'RS'),
(6, 'Julia Almeida', 'Fortaleza', 'CE'),
(7, 'Carlos Fernandes', 'Curitiba', 'PR'),
(8, 'Fernanda Rocha', 'Recife', 'PE'),
(9, 'Roberto Lima', 'Brasília', 'DF'),
(10, 'Larissa Martins', 'Manaus', 'AM'),
(11, 'Tiago Mendes', 'Campo Grande', 'MS'),
(12, 'Camila Ferreira', 'João Pessoa', 'PB'),
(13, 'Gustavo Moreira', 'Vitória', 'ES'),
(14, 'Tatiane Silva', 'Maceió', 'AL'),
(15, 'Daniela Souza', 'Aracaju', 'SE'),
(16, 'Rodrigo Lima', 'Teresina', 'PI'),
(17, 'Priscila Almeida', 'São Luís', 'MA'),
(18, 'Vitor Costa', 'Natal', 'RN'),
(19, 'Samantha Rocha', 'Cuiabá', 'MT'),
(20, 'Marcos Silva', 'Belém', 'PA'),
(21, 'Renata Oliveira', 'Porto Velho', 'RO'),
(22, 'André Santos', 'Rio Branco', 'AC'),
(23, 'Juliana Costa', 'Boa Vista', 'RR'),
(24, 'Maurício Pereira', 'Palmas', 'TO'),
(25, 'Mariana Fernandes', 'Macapá', 'AP'),
(26, 'Rafael Almeida', 'São José', 'SC'),
(27, 'Luciana Santos', 'Londrina', 'PR'),
(28, 'Felipe Lima', 'Uberlândia', 'MG'),
(29, 'Amanda Rocha', 'Maringá', 'PR'),
(30, 'Vinícius Ferreira', 'Araraquara', 'SP');

-- --------------------------------------------------------

--
-- Estrutura da tabela `pedidos_gerais`
--

CREATE TABLE `pedidos_gerais` (
  `numPedido` int(11) NOT NULL,
  `dtEmissao` date NOT NULL,
  `codCliente` int(11) NOT NULL,
  `vlTotal` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Extraindo dados da tabela `pedidos_gerais`
--

INSERT INTO `pedidos_gerais` (`numPedido`, `dtEmissao`, `codCliente`, `vlTotal`) VALUES
(1, '2024-01-15', 1, '150.00'),
(2, '2024-01-16', 2, '200.50'),
(3, '2024-01-17', 3, '175.75'),
(4, '2024-01-18', 4, '220.30'),
(5, '2024-01-19', 5, '180.00'),
(6, '2024-01-20', 6, '210.20'),
(7, '2024-01-21', 7, '165.40'),
(8, '2024-01-22', 8, '250.00'),
(9, '2024-01-23', 9, '190.25'),
(10, '2024-01-24', 10, '240.90'),
(11, '2024-01-25', 11, '170.75'),
(12, '2024-01-26', 12, '215.60'),
(13, '2024-01-27', 13, '185.00'),
(14, '2024-01-28', 14, '230.30'),
(15, '2024-01-29', 15, '160.90'),
(16, '2024-01-30', 16, '245.10'),
(17, '2024-01-31', 17, '200.00'),
(18, '2024-02-01', 18, '190.50'),
(19, '2024-02-02', 19, '220.75'),
(20, '2024-02-03', 20, '175.25'),
(21, '2024-02-04', 21, '210.40'),
(22, '2024-02-05', 22, '240.00'),
(23, '2024-02-06', 23, '185.75'),
(24, '2024-02-07', 24, '225.60'),
(25, '2024-02-08', 25, '195.90'),
(26, '2024-02-09', 26, '250.50'),
(27, '2024-02-10', 27, '210.20'),
(28, '2024-02-11', 28, '230.00'),
(29, '2024-02-12', 29, '220.40'),
(30, '2024-02-13', 30, '240.10'),
(31, '2024-02-14', 1, '185.00'),
(32, '2024-02-15', 2, '170.75'),
(33, '2024-02-16', 3, '215.20');

-- --------------------------------------------------------

--
-- Estrutura da tabela `pedidos_produtos`
--

CREATE TABLE `pedidos_produtos` (
  `id` int(11) NOT NULL,
  `numPedido` int(11) DEFAULT NULL,
  `codProduto` int(11) DEFAULT NULL,
  `quantidade` int(11) NOT NULL,
  `vlUnitario` decimal(10,2) NOT NULL,
  `vlTotal` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Extraindo dados da tabela `pedidos_produtos`
--

INSERT INTO `pedidos_produtos` (`id`, `numPedido`, `codProduto`, `quantidade`, `vlUnitario`, `vlTotal`) VALUES
(1, 1, 1, 2, '10.99', '21.98'),
(2, 1, 2, 1, '20.49', '20.49'),
(3, 2, 3, 3, '15.75', '47.25'),
(4, 2, 4, 1, '22.00', '22.00'),
(5, 3, 5, 4, '9.99', '39.96'),
(6, 3, 6, 2, '18.25', '36.50'),
(7, 4, 7, 1, '12.50', '12.50'),
(8, 4, 8, 5, '25.30', '126.50'),
(9, 5, 9, 3, '8.75', '26.25'),
(10, 5, 10, 2, '19.90', '39.80'),
(11, 6, 11, 4, '14.60', '58.40'),
(12, 6, 12, 3, '21.10', '63.30'),
(13, 7, 13, 5, '17.45', '87.25'),
(14, 7, 14, 1, '13.80', '13.80'),
(15, 8, 15, 2, '24.99', '49.98'),
(16, 8, 16, 3, '16.20', '48.60'),
(17, 9, 17, 1, '11.95', '11.95'),
(18, 9, 18, 2, '23.50', '47.00'),
(19, 10, 19, 4, '7.85', '31.40'),
(20, 10, 20, 1, '26.40', '26.40'),
(21, 11, 21, 2, '12.30', '24.60'),
(22, 11, 22, 3, '20.00', '60.00'),
(23, 12, 23, 4, '10.50', '42.00'),
(24, 12, 24, 1, '22.75', '22.75'),
(25, 13, 25, 3, '13.20', '39.60'),
(26, 13, 26, 2, '27.10', '54.20'),
(27, 14, 27, 1, '8.65', '8.65'),
(28, 14, 28, 4, '29.99', '119.96'),
(29, 15, 29, 2, '15.90', '31.80'),
(30, 15, 30, 3, '18.75', '56.25'),
(31, 16, 1, 4, '10.99', '43.96'),
(32, 16, 2, 2, '20.49', '40.98'),
(33, 17, 3, 1, '15.75', '15.75'),
(34, 17, 4, 3, '22.00', '66.00'),
(35, 18, 5, 2, '9.99', '19.98'),
(36, 18, 6, 4, '18.25', '73.00'),
(37, 19, 7, 3, '12.50', '37.50'),
(38, 19, 8, 2, '25.30', '50.60'),
(39, 20, 9, 1, '8.75', '8.75'),
(40, 20, 10, 5, '19.90', '99.50'),
(41, 21, 11, 2, '14.60', '29.20'),
(42, 21, 12, 4, '21.10', '84.40'),
(43, 22, 13, 1, '17.45', '17.45'),
(44, 22, 14, 3, '13.80', '41.40'),
(45, 23, 15, 5, '24.99', '124.95'),
(46, 23, 16, 1, '16.20', '16.20'),
(47, 24, 17, 2, '11.95', '23.90'),
(48, 24, 18, 4, '23.50', '94.00'),
(49, 25, 19, 1, '7.85', '7.85'),
(50, 25, 20, 3, '26.40', '79.20'),
(51, 26, 21, 2, '12.30', '24.60'),
(52, 26, 22, 5, '20.00', '100.00'),
(53, 27, 23, 1, '10.50', '10.50'),
(54, 27, 24, 4, '22.75', '91.00'),
(55, 28, 25, 3, '13.20', '39.60'),
(56, 28, 26, 2, '27.10', '54.20'),
(57, 29, 27, 5, '8.65', '43.25'),
(58, 29, 28, 2, '29.99', '59.98'),
(59, 30, 29, 1, '15.90', '15.90'),
(60, 30, 30, 3, '18.75', '56.25');

-- --------------------------------------------------------

--
-- Estrutura da tabela `produtos`
--

CREATE TABLE `produtos` (
  `codigo` int(11) NOT NULL,
  `descricao` varchar(255) NOT NULL,
  `precVenda` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Extraindo dados da tabela `produtos`
--

INSERT INTO `produtos` (`codigo`, `descricao`, `precVenda`) VALUES
(1, 'Produto A', '10.99'),
(2, 'Produto B', '20.49'),
(3, 'Produto C', '15.75'),
(4, 'Produto D', '22.00'),
(5, 'Produto E', '9.99'),
(6, 'Produto F', '18.25'),
(7, 'Produto G', '12.50'),
(8, 'Produto H', '25.30'),
(9, 'Produto I', '8.75'),
(10, 'Produto J', '19.90'),
(11, 'Produto K', '14.60'),
(12, 'Produto L', '21.10'),
(13, 'Produto M', '17.45'),
(14, 'Produto N', '13.80'),
(15, 'Produto O', '24.99'),
(16, 'Produto P', '16.20'),
(17, 'Produto Q', '11.95'),
(18, 'Produto R', '23.50'),
(19, 'Produto S', '7.85'),
(20, 'Produto T', '26.40'),
(21, 'Produto U', '12.30'),
(22, 'Produto V', '20.00'),
(23, 'Produto W', '10.50'),
(24, 'Produto X', '22.75'),
(25, 'Produto Y', '13.20'),
(26, 'Produto Z', '27.10'),
(27, 'Produto AA', '8.65'),
(28, 'Produto AB', '29.99'),
(29, 'Produto AC', '15.90'),
(30, 'Produto AD', '18.75');

--
-- Índices para tabelas despejadas
--

--
-- Índices para tabela `clientes`
--
ALTER TABLE `clientes`
  ADD PRIMARY KEY (`codigo`);

--
-- Índices para tabela `pedidos_gerais`
--
ALTER TABLE `pedidos_gerais`
  ADD PRIMARY KEY (`numPedido`);

--
-- Índices para tabela `pedidos_produtos`
--
ALTER TABLE `pedidos_produtos`
  ADD PRIMARY KEY (`id`),
  ADD KEY `numPedido` (`numPedido`),
  ADD KEY `codProduto` (`codProduto`);

--
-- Índices para tabela `produtos`
--
ALTER TABLE `produtos`
  ADD PRIMARY KEY (`codigo`);

--
-- AUTO_INCREMENT de tabelas despejadas
--

--
-- AUTO_INCREMENT de tabela `clientes`
--
ALTER TABLE `clientes`
  MODIFY `codigo` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=31;

--
-- AUTO_INCREMENT de tabela `pedidos_gerais`
--
ALTER TABLE `pedidos_gerais`
  MODIFY `numPedido` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=34;

--
-- AUTO_INCREMENT de tabela `pedidos_produtos`
--
ALTER TABLE `pedidos_produtos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=61;

--
-- AUTO_INCREMENT de tabela `produtos`
--
ALTER TABLE `produtos`
  MODIFY `codigo` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=31;

--
-- Restrições para despejos de tabelas
--

--
-- Limitadores para a tabela `pedidos_produtos`
--
ALTER TABLE `pedidos_produtos`
  ADD CONSTRAINT `pedidos_produtos_ibfk_1` FOREIGN KEY (`numPedido`) REFERENCES `pedidos_gerais` (`numPedido`),
  ADD CONSTRAINT `pedidos_produtos_ibfk_2` FOREIGN KEY (`codProduto`) REFERENCES `produtos` (`codigo`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
