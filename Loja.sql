--- Criando o banco de dados ---

USE master;
GO

CREATE LOGIN loja WITH PASSWORD = 'loja';
GO

CREATE DATABASE Loja;
GO

USE Loja;
GO


CREATE TABLE pessoa(
idPessoa INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
pessoa_tipo VARCHAR(100),
nome VARCHAR(255) NOT NULL,
logradouro VARCHAR(255) NOT NULL,
cidade VARCHAR(255) NOT NULL,
estado CHAR(2) NOT NULL,
telefone VARCHAR(11) NOT NULL,
email VARCHAR(255) NOT NULL,
CONSTRAINT check_tipo_pessoa CHECK (pessoa_tipo IN ('fisica', 'juridica'))
)
GO

CREATE TABLE pessoa_fisica(
idPessoaFisica INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
idPessoa INT NULL,
cpf VARCHAR(11) NOT NULL,
FOREIGN KEY (idPessoa) REFERENCES pessoa(idPessoa)
)

CREATE TABLE pessoa_juridica (
idPessoaJuridica INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
idPessoa INT NULL,
cnpj VARCHAR(14) NOT NULL
FOREIGN KEY (idPessoa) REFERENCES pessoa(idPessoa)
)

CREATE TABLE produto (
idProduto INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
nome VARCHAR(255) NOT NULL,
quantidade INT NOT NULL,
precoVenda DECIMAL(10,2) NOT NULL
)

CREATE TABLE usuario (
idUsuario INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
login VARCHAR(255) NOT NULL,
senha VARCHAR(255) NOT NULL
)

CREATE TABLE movimento (
idMovimento INT PRIMARY KEY NOT NULL,
idProduto INT NOT NULL,
idPessoa INT NOT NULL,
idUsuario INT NOT NULL,
movimento_tipo VARCHAR(100), -- 'E' para entrada, 'S' para saída
quantidade INT NOT NULL,
precoUnitario DECIMAL(10,2) NOT NULL,
CONSTRAINT check_tipo_movimento CHECK (movimento_tipo IN ('entrada', 'saida')),
FOREIGN KEY (idProduto) REFERENCES produto(idProduto),
FOREIGN KEY (idPessoa) REFERENCES pessoa(idPessoa),
FOREIGN KEY (idUsuario) REFERENCES usuario(idUsuario)
)

--- Alimentando o banco ---

INSERT INTO [usuario](login, senha)
VALUES
	('silviasantos', 'silvia1234'),
	('juciara23', 'juju198'),
	('luciana242', 'lulu2345'),
	('rosenilda44678', 'rose3124')

INSERT INTO [produto](nome, quantidade, precoVenda)
VALUES
	('Banana', 100, 5.00),
	('Laranja', 500, 2.00),
	('Manga', 800, 4.00),
	('Pêra', 450, 9.00)
		
--Inserir pessoas--
INSERT INTO [pessoa] ( pessoa_tipo,  nome, logradouro, cidade, estado, telefone, email)
VALUES ( 'fisica', 'Silvia Santos Conceição', 'Rua Jubiramba Castro', 'São Paulo', 'SP', '11982377465', 'silvia@email.com');

INSERT INTO [pessoa_fisica] (idPessoa, cpf) VALUES (1, 37570270726);
--------
INSERT INTO [pessoa] ( pessoa_tipo, nome, logradouro, cidade, estado, telefone, email)
VALUES ('fisica', 'Judiciara Albuquerque', 'Avenida Julho Maia 4983', 'Rio de Janeiro', 'RJ', '21934753764', 'judiciara@email.com');

INSERT INTO [pessoa_fisica] (idPessoa, cpf) VALUES (2, 09384752932);
--------
INSERT INTO [pessoa] ( pessoa_tipo, nome, logradouro, cidade, estado, telefone, email)
VALUES ( 'juridica', 'Luciana Costa', 'Travessa paz e amor', 'Belo Horizonte', 'MG', '31976756383', 'luciana@email.com');

INSERT INTO [pessoa_juridica] (idPessoa, cnpj) VALUES (3, 85665739393404);
--------
INSERT INTO [pessoa] (pessoa_tipo, nome, logradouro, cidade, estado, telefone, email)
VALUES ('juridica', 'Rosenilda do Carmo', 'Rua Fonte do Saber', 'Porto Alegre', 'RS', '51975730803', 'rosenilda@email.com');

INSERT INTO [pessoa_juridica] (idPessoa, cnpj) VALUES (4, 96783757389230);

-- Inserir movimentação fornecedor
INSERT INTO [movimento] (idMovimento, idProduto, idPessoa, idUsuario, movimento_tipo, quantidade, precoUnitario)
VALUES 
    (1, 1, 1, 1, 'entrada', 20, 4.5),
    (2, 2, 2, 2, 'entrada', 15, 3.00),
	(3, 1, 1, 1, 'saida', 10, 3.35),
    (4, 1, 1, 1, 'entrada', 25, 4.50),
	(5, 1, 1, 1, 'saida', 5, 2.50)


--Dados completos de pessoas físicas
SELECT pessoa.idPessoa, pessoa.nome, pessoa.logradouro, pessoa.cidade, pessoa.estado, pessoa.telefone, pessoa.email, pessoa_fisica.cpf  
FROM pessoa INNER JOIN pessoa_fisica ON pessoa.idPessoa = pessoa_fisica.idPessoaFisica

--Dados completos de pessoas juridica
SELECT pessoa.idPessoa, pessoa.nome, pessoa.logradouro, pessoa.cidade, pessoa.estado, pessoa.telefone, pessoa.email, pessoa_juridica.cnpj  
FROM pessoa INNER JOIN pessoa_juridica ON pessoa.idPessoa = pessoa_juridica.idPessoaJuridica

--Movimentação de entrada
SELECT
P.nome AS Fornecedor, Prod.nome AS Produto, Mov.quantidade, Mov.precoUnitario AS PrecoUnitario,
Mov.quantidade * Mov.precoUnitario AS ValorTotal
FROM movimento Mov
JOIN Produto Prod ON Mov.idProduto = Prod.idProduto
JOIN Pessoa P ON Mov.idPessoa = P.idPessoa
WHERE movimento_tipo = 'entrada';

--Movimentação de saída
SELECT
P.nome AS Comprador, Prod.nome AS Produto, Mov.quantidade, Mov.precoUnitario AS PrecoUnitario,
Mov.quantidade * Mov.precoUnitario AS ValorTotal FROM Movimento Mov
JOIN Produto Prod ON Mov.idProduto = Prod.idProduto
JOIN Pessoa P ON Mov.idPessoa = P.idPessoa
WHERE movimento_tipo = 'saida';

--Valor total das entradas agrupadas por produto
SELECT Mov.idProduto, SUM(Mov.quantidade * Mov.precoUnitario) AS TotalEntradas
FROM Movimento Mov 
WHERE movimento_tipo = 'entrada'
GROUP BY Mov.idProduto;

--Valor total das saídas agrupadas por produto
SELECT Mov.idProduto, SUM(Mov.quantidade * Mov.precoUnitario) AS TotalSaidas
FROM Movimento Mov
WHERE movimento_tipo = 'saida'
GROUP BY Mov.idProduto;

--Operadores que não efetuaram movimentações de entrada
SELECT DISTINCT U.*
FROM usuario U
LEFT JOIN Movimento M ON U.idUsuario = M.idUsuario AND movimento_tipo = 'entrada'
WHERE M.idUsuario IS NULL;

--Valor total de entrada, agrupado por operador
SELECT M.idUsuario, SUM(M.quantidade * M.precoUnitario) AS TotalEntradas FROM Movimento M
WHERE movimento_tipo = 'entrada'
GROUP BY M.idUsuario;

--Valor total de saída, agrupado por operador
SELECT M.idUsuario, SUM(M.quantidade * M.precoUnitario) AS TotalSaidas FROM Movimento M
WHERE movimento_tipo = 'saida'
GROUP BY M.idUsuario;

--Valor médio de venda por produto, utilizando média ponderada
SELECT
Prod.nome AS Produto, Mov.idProduto, SUM(Mov.quantidade * Mov.precoUnitario) / SUM(Mov.quantidade) AS MediaPonderada 
FROM Movimento Mov
JOIN Produto Prod ON Mov.idProduto = Prod.idProduto
WHERE movimento_tipo = 'saida'
GROUP BY Mov.idProduto, Prod.nome;