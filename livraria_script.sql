--Aqui faremos a criação e modelagem de um banco de dados inicial para uma livraria.
--Condições de projeto:
--Dados de clientes: CPF, nome, endereço, telefone e e-mail.
--Dados de livros: Título, categoria, ISBN, ano de publicação, editora, autor ou autores da obra.
--Dados de editora: Contato, e-mail e no máximo dois telefones.
--Não é possível ter o mesmo livro vindo de várias editoras. Cada livro é exclusivo de uma editora.

--RESTRIÇÃO: Nossos clientes podem comprar um ou mais livros em um pedido de compra. 
--Mas, antes que ele faça a compra, é preciso verificar se o livro está disponível em estoque para que a compra seja efetuada.
--É necessário também que a cada compra o estoque atual do produto seja atualizado, subtraindo o que foi comprado.

--FORMATAÇÃO: POSTGRESQL

--Criação da tabela de clientes
CREATE TABLE livraria_cliente (
	cpf int NOT NULL,
	nome_cliente varchar(40) NOT NULL,
	telefone_cliente varchar(13) NOT NULL,
	email_cliente varchar(50) NOT NULL,
	endereco_cliente varchar (60) NOT NULL,
	PRIMARY KEY (cpf)
);

--Criação da tabela de editoras
CREATE TABLE livraria_editora (
	id_editora serial NOT NULL,
	nome_editora varchar (40) NOT NULL,
	email_editora varchar (50) NOT NULL,
	telefone_editora varchar (13) NULL,
	telefone_editora_2 varchar (13) NULL,
	PRIMARY KEY (id_editora)
);

--Criação da tabela de livros
CREATE TABLE livraria_livro (
	isbn int NOT NULL,
	titulo varchar(50) NOT NULL,
	ano int NOT NULL,
	autor varchar(40) NOT NULL,
	autor_2 varchar (40) NULL DEFAULT NULL,
	quantidade int NOT NULL,
	categoria varchar (20) NOT NULL,
	id_editora int NOT NULL,
	PRIMARY KEY (isbn),
	FOREIGN KEY (id_editora)
		REFERENCES livraria_editora (id_editora)	
);

--Criação da tabela de pedidos
CREATE TABLE livraria_pedido (
	id_pedido serial NOT NULL,
	quantidade_pedido int NOT NULL,
	isbn int NOT NULL,
	cpf int NOT NULL,
	PRIMARY KEY (id_pedido),
	FOREIGN KEY (isbn)
		REFERENCES livraria_livro (isbn),
	FOREIGN KEY (cpf)
		REFERENCES livraria_cliente (cpf)
);

--Trigger para verificar se o livro do pedido está em estoque e atualizar o estoque do mesmo após a compra
CREATE OR REPLACE FUNCTION public.checa_estoque()  
RETURNS trigger AS  
$BODY$
BEGIN  
  IF (SELECT livraria_livro.quantidade FROM livraria_livro WHERE livraria_livro.isbn = NEW.isbn)
    < NEW.quantidade_pedido THEN
  	RAISE EXCEPTION 'Quantidade em Estoque Insuficiente';
  ELSE UPDATE livraria_livro
  	SET quantidade = quantidade-NEW.quantidade_pedido
	WHERE isbn = NEW.isbn;
  END if;
  RETURN NEW;
END;
$BODY$
LANGUAGE plpgsql;  

--Função para chamar o trigger criado antes de efetivar cada insert
CREATE TRIGGER checar_estoque
BEFORE INSERT ON livraria_pedido
FOR EACH ROW 
EXECUTE PROCEDURE checa_estoque();
