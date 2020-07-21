-- Projeto – Animais Domésticos e Exóticos
-- Contrato temporário de itens e serviços para animais de estimação

-- Caio Augusto Duarte Basso – 10801173
-- Gabriel Garcia Lorencetti – 10691891
-- Giovana Daniele da Silva – 10692224
-- Luíza Pereira Pinto Machado – 7564426 

-- CRIAÇÃO DAS TABELAS


-- TABLE USUARIO --
CREATE TABLE usuario(
	cpf_usuario VARCHAR(14),
	nome_usuario VARCHAR(100) NOT NULL,
	email VARCHAR(100) NOT NULL UNIQUE,
	senha VARCHAR(20) NOT NULL,
	telefone VARCHAR(13),
	uf_usuario CHAR(2),
	cidade_usuario VARCHAR(75),
	cep_usuario VARCHAR(10),
	bairro_usuario VARCHAR(75),
	logradouro_usuario VARCHAR(100),
	numero_usuario SMALLINT,
	complemento_usuario VARCHAR(50),

	CONSTRAINT pk_usuario PRIMARY KEY (cpf_usuario)
);

-- TABLE TIPO_USUARIO --
CREATE TABLE tipo_usuario(
	cpf_tp_usuario VARCHAR(14),
	tipo_usuario VARCHAR(17),

	CONSTRAINT pk_tipo_usuario PRIMARY KEY (cpf_tp_usuario, tipo_usuario),
	CONSTRAINT fk_tipo_usuario FOREIGN KEY (cpf_tp_usuario) REFERENCES usuario
			   (cpf_usuario) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT ck_tipo_usuario CHECK(UPPER(tipo_usuario) = 'COMERCIANTE' OR
							   	     UPPER(tipo_usuario) = 'DONO PET' OR
						   	   		 UPPER(tipo_usuario) = 'ANFITRIÃO' OR
									 UPPER(tipo_usuario) = 'PRESTADOR SERVIÇO')
);

-- TABLE PRESTADOR_SERVICO --
CREATE TABLE prestador_servico(
	cpf_ps VARCHAR(14),
	bool_passeador BOOLEAN NOT NULL,
	bool_adestrador BOOLEAN NOT NULL,

	CONSTRAINT pk_ps PRIMARY KEY (cpf_ps),
	CONSTRAINT fk_ps FOREIGN KEY (cpf_ps) REFERENCES usuario (cpf_usuario)
			   ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT ck_ps CHECK(bool_passeador  = TRUE OR
					 	   bool_adestrador = TRUE)
);

-- TABLE PASSEADOR_BAIRROS --
CREATE TABLE passeador_bairros(
	cpf_pb VARCHAR(14),
	bairro_pb VARCHAR(75),

	CONSTRAINT pk_pb PRIMARY KEY (cpf_pb, bairro_pb),
	CONSTRAINT fk_pb FOREIGN KEY (cpf_pb) REFERENCES prestador_servico (cpf_ps)
			   ON DELETE CASCADE ON UPDATE CASCADE
);

-- TABLE PRESTADOR_CARACTERISTICAS --
CREATE TABLE prestador_carac(
	cpf_pc VARCHAR(14),
	caracteristica VARCHAR(20),
	CONSTRAINT pk_pc PRIMARY KEY (cpf_pc, caracteristica),
	CONSTRAINT fk_pc FOREIGN KEY (cpf_pc) REFERENCES prestador_servico (cpf_ps)
			   ON DELETE CASCADE ON UPDATE CASCADE
);

-- TABLE ADESTRADOR_CERTIFICADOS --
CREATE TABLE adestrador_certific(
	cpf_ac VARCHAR(14),
	certificado VARCHAR(75),

	CONSTRAINT pk_ac PRIMARY KEY (cpf_ac, certificado),
	CONSTRAINT fk_ac FOREIGN KEY (cpf_ac) REFERENCES prestador_servico (cpf_ps)
			   ON DELETE CASCADE ON UPDATE CASCADE
);

-- TABLE ADESTRADOR_ESPECIES --
CREATE TABLE adestrador_espec(
	cpf_ae VARCHAR(14),
	especie VARCHAR(30),

	CONSTRAINT pk_ae PRIMARY KEY (cpf_ae, especie),
	CONSTRAINT fk_ae FOREIGN KEY (cpf_ae) REFERENCES prestador_servico (cpf_ps)
			   ON DELETE CASCADE ON UPDATE CASCADE
);

-- TABLE COMERCIANTE --
CREATE TABLE comerciante(
	cpf_comerciante VARCHAR(14),

	CONSTRAINT pk_comerciante PRIMARY KEY (cpf_comerciante),
	CONSTRAINT fk_comerciante FOREIGN KEY (cpf_comerciante)
		       REFERENCES usuario (cpf_usuario)
			   ON DELETE CASCADE ON UPDATE CASCADE
);

-- TABLE PRODUTO --
CREATE TABLE produto(
	codigo INT,
	nome_produto VARCHAR(50) NOT NULL,
	valor_aluguel NUMERIC(6,2) NOT NULL,
	descricao_produto VARCHAR(250),
	categoria_produto VARCHAR(11) NOT NULL DEFAULT 'OUTROS',
	quantidade SMALLINT NOT NULL,
	comerciante_prod VARCHAR(14) NOT NULL,

	CONSTRAINT pk_produto PRIMARY KEY (codigo),
	CONSTRAINT fk_produto FOREIGN KEY (comerciante_prod) REFERENCES comerciante
			   (cpf_comerciante) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT ck_produto CHECK(UPPER(categoria_produto) = 'LAZER' OR
								UPPER(categoria_produto) = 'ALIMENTAÇÃO' OR
								UPPER(categoria_produto) = 'VESTUÁRIO' OR
								UPPER(categoria_produto) = 'OUTROS')
);

-- TABLE DONO_PET --
CREATE TABLE dono_pet(
	cpf_dp VARCHAR(14),

	CONSTRAINT pk_dono_pet PRIMARY KEY (cpf_dp),
	CONSTRAINT fk_dono_pet FOREIGN KEY (cpf_dp) REFERENCES usuario (cpf_usuario)
			   ON DELETE CASCADE ON UPDATE CASCADE
);

-- TABLE PET --
CREATE TABLE pet(
	cpf_dono_pet VARCHAR(14),
	nome_pet VARCHAR(20),
	especie_pet VARCHAR(30),
	data_nasc DATE,
	porte CHAR(1) NOT NULL,
	tipo_pet VARCHAR(9) NOT NULL,
	registro_ibama INT,

	CONSTRAINT pk_pet PRIMARY KEY (cpf_dono_pet, nome_pet, especie_pet),
	CONSTRAINT fk_pet FOREIGN KEY (cpf_dono_pet) REFERENCES dono_pet (cpf_dp)
			   ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT ck_pet_porte CHECK(UPPER(porte) = 'P' OR UPPER(porte) = 'M' OR
								  UPPER(porte) = 'G'),
	CONSTRAINT ck_pet_tipo CHECK(UPPER(tipo_pet) = 'EXÓTICO' OR
								 UPPER(tipo_pet) = 'DOMÉSTICO'),
	CONSTRAINT ck_pet_reg_ibama CHECK((UPPER(tipo_pet) = 'EXÓTICO' AND registro_ibama
								IS NOT NULL) OR (UPPER(tipo_pet) = 'DOMÉSTICO' AND
								registro_ibama IS NULL))
);

-- TABLE PET_COMPORTAMENTO --
CREATE TABLE pet_comportamento(
	cpf_dono_comp VARCHAR(14),
	nome_pet_comp VARCHAR(20),
	especie_pet_comp VARCHAR(30),
	comportamento VARCHAR(25),

	CONSTRAINT pk_p_c PRIMARY KEY (cpf_dono_comp, nome_pet_comp, especie_pet_comp, comportamento),
	CONSTRAINT fk_p_c FOREIGN KEY (cpf_dono_comp, nome_pet_comp, especie_pet_comp) REFERENCES
					  pet (cpf_dono_pet, nome_pet, especie_pet)
					  ON DELETE CASCADE ON UPDATE CASCADE
);

-- TABLE PET_EXOTIC_CUID --
CREATE TABLE pet_exotic_cuid(
	cpf_dono_ex_c VARCHAR(14),
	nome_pet_ex_c VARCHAR(20),
	especie_pet_ex_c VARCHAR(30),
	cuidado_especial VARCHAR(50),

	CONSTRAINT pk_pet_e_c PRIMARY KEY (cpf_dono_ex_c, nome_pet_ex_c, especie_pet_ex_c,
		 							   cuidado_especial),
	CONSTRAINT fk_pet_e_c FOREIGN KEY (cpf_dono_ex_c, nome_pet_ex_c, especie_pet_ex_c)
			   REFERENCES pet (cpf_dono_pet, nome_pet, especie_pet)
			   ON DELETE CASCADE ON UPDATE CASCADE
);

-- TABLE PET_DEFICIENCIA --
CREATE TABLE pet_deficiencia(
	cpf_dono_pet_def VARCHAR(14),
	nome_pet_def VARCHAR(20),
	especie_pet_def VARCHAR(30),
	deficiencia VARCHAR(20),

	CONSTRAINT pk_pet_def PRIMARY KEY (cpf_dono_pet_def, nome_pet_def, especie_pet_def,
		 							  deficiencia),
	CONSTRAINT fk_pet_def FOREIGN KEY (cpf_dono_pet_def, nome_pet_def, especie_pet_def)
		       REFERENCES pet (cpf_dono_pet, nome_pet, especie_pet)
			   ON DELETE CASCADE ON UPDATE CASCADE
);

-- TABLE ALUGUEL_PRODUTO --
CREATE TABLE aluguel_produto(
	timestamp_al_p TIMESTAMP,
	comerciante_al_p VARCHAR(14),
	dono_pet_al_p VARCHAR(14),
	produto_al_p SMALLINT,
	data_fim_al_p DATE NOT NULL,
	valor_al_p NUMERIC(6,2) NOT NULL,
	qtdd_prod SMALLINT NOT NULL,
	comentario_al_p VARCHAR(250),
	nota_al_p NUMERIC(2,1),

	CONSTRAINT pk_al_p PRIMARY KEY (timestamp_al_p, comerciante_al_p, dono_pet_al_p, produto_al_p),
	CONSTRAINT fk_dono_pet_al_p FOREIGN KEY (dono_pet_al_p) REFERENCES dono_pet (cpf_dp)
			   ON DELETE RESTRICT ON UPDATE RESTRICT,
	CONSTRAINT fk_comerciante_al_p FOREIGN KEY (comerciante_al_p) REFERENCES comerciante (cpf_comerciante)
			   ON DELETE RESTRICT ON UPDATE RESTRICT,
	CONSTRAINT fk_produto_al_p FOREIGN KEY (produto_al_p) REFERENCES produto (codigo)
			   ON DELETE RESTRICT ON UPDATE RESTRICT,
	CONSTRAINT ck_al_p_qtdd_prod CHECK(qtdd_prod > 0),
	CONSTRAINT ck_al_p_nota CHECK(nota_al_p >= 0.0 AND nota_al_p <= 5.0),
	CONSTRAINT ck_al_p_datas CHECK(DATE(timestamp_al_p) < data_fim_al_p)
);

-- TABLE PRESTACAO_SERVICO --
CREATE TABLE prestacao_servico(
	cpf_pr_s VARCHAR(14),
	cpf_dp_pr_s VARCHAR(14),
	nome_pet_pr_s VARCHAR(20),
	especie_pet_pr_s VARCHAR(30),
	timestamp_pr_s TIMESTAMP,
	tipo_pr_s VARCHAR(12),
	data_fim_pr_s DATE NOT NULL,
	valor_pr_s NUMERIC(6,2) NOT NULL,
	nota_pr_s NUMERIC(2,1),
	comentario_pr_s VARCHAR(250),

	CONSTRAINT pk_pr_s PRIMARY KEY (cpf_pr_s, cpf_dp_pr_s, nome_pet_pr_s,
									especie_pet_pr_s, timestamp_pr_s),
	CONSTRAINT fk_pr_s_p_s FOREIGN KEY (cpf_pr_s) REFERENCES prestador_servico (cpf_ps)
			   ON DELETE RESTRICT ON UPDATE RESTRICT,
	CONSTRAINT fk_pr_s_pet FOREIGN KEY (cpf_dp_pr_s, nome_pet_pr_s, especie_pet_pr_s)
			   REFERENCES pet (cpf_dono_pet, nome_pet, especie_pet)
			   ON DELETE RESTRICT ON UPDATE RESTRICT,
	CONSTRAINT ck_pr_s_tipo CHECK(UPPER(tipo_pr_s) = 'PASSEIO' OR 
								  UPPER(tipo_pr_s) = 'ADESTRAMENTO'),
	CONSTRAINT ck_pr_s_nota CHECK(nota_pr_s >= 0.0 AND nota_pr_s <= 5.0),
	CONSTRAINT ck_pr_s_datas CHECK(DATE(timestamp_pr_s) < data_fim_pr_s)
);

-- TABLE ANFITRIAO --
CREATE TABLE anfitriao(
	cpf_anf VARCHAR(14),

	CONSTRAINT pk_anfitriao PRIMARY KEY (cpf_anf),
	CONSTRAINT fk_anfitriao FOREIGN KEY (cpf_anf) REFERENCES usuario (cpf_usuario)
			   ON DELETE CASCADE ON UPDATE CASCADE
);

-- TABLE LOCAL --
CREATE TABLE local(
	uf_local CHAR(2),
	cidade_local VARCHAR(75),
	cep_local VARCHAR(10),
	bairro_local VARCHAR(75),
	logradouro_local VARCHAR(100),
	numero_local SMALLINT,
	complemento_local VARCHAR(50),
	descricao_local VARCHAR(250),
	categoria_local VARCHAR(11) NOT NULL DEFAULT 'OUTROS',
	anfitriao_local VARCHAR(14) NOT NULL,

	CONSTRAINT pk_local PRIMARY KEY (uf_local, cidade_local, cep_local, bairro_local,
									 logradouro_local, numero_local, complemento_local),
	CONSTRAINT fk_local FOREIGN KEY (anfitriao_local) REFERENCES anfitriao (cpf_anf)
			   ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT ck_local_categ CHECK(UPPER(categoria_local) = 'CHÁCARA' OR
							  		UPPER(categoria_local) = 'CASA' OR
									UPPER(categoria_local) = 'SÍTIO' OR
									UPPER(categoria_local) = 'APARTAMENTO' OR
									UPPER(categoria_local) = 'OUTROS')
);

-- TABLE HOSPEDAGEM --
CREATE TABLE hospedagem(
	anf_hosp VARCHAR(14),
	cpf_dono_hosp VARCHAR(14),
	nome_pet_hosp VARCHAR(20),
	especie_pet_hosp VARCHAR(30),
	timestamp_hosp TIMESTAMP,
	data_fim_hosp DATE NOT NULL,
	valor_hosp NUMERIC(6,2) NOT NULL,
	nota_hosp NUMERIC(2,1),
	comentario_hosp VARCHAR(250),
	uf_hosp CHAR(2) NOT NULL,
	cidade_hosp VARCHAR(75) NOT NULL,
	cep_hosp VARCHAR(10) NOT NULL,
	bairro_hosp VARCHAR(75) NOT NULL,
	logradouro_hosp VARCHAR(100) NOT NULL,
	numero_hosp SMALLINT NOT NULL,
	complemento_hosp VARCHAR(50) NOT NULL,

	CONSTRAINT pk_hosp PRIMARY KEY (anf_hosp, cpf_dono_hosp, nome_pet_hosp,
								    especie_pet_hosp, timestamp_hosp),
	CONSTRAINT fk_hosp_anf FOREIGN KEY (anf_hosp) REFERENCES anfitriao (cpf_anf)
			   ON DELETE RESTRICT ON UPDATE RESTRICT,
	CONSTRAINT fk_hosp_pet FOREIGN KEY (cpf_dono_hosp, nome_pet_hosp, especie_pet_hosp)
	 		   REFERENCES pet (cpf_dono_pet, nome_pet, especie_pet)
			   ON DELETE RESTRICT ON UPDATE RESTRICT,
	CONSTRAINT fk_hosp_local FOREIGN KEY (uf_hosp, cidade_hosp, cep_hosp, bairro_hosp,
		 								  logradouro_hosp, numero_hosp, complemento_hosp)
			   REFERENCES local (uf_local, cidade_local, cep_local, bairro_local,
				   				 logradouro_local, numero_local, complemento_local)
			   ON DELETE RESTRICT ON UPDATE RESTRICT,
	CONSTRAINT ck_hosp_nota CHECK(nota_hosp >= 0.0 AND nota_hosp <= 5.0),
	CONSTRAINT ck_hosp_datas CHECK(DATE(timestamp_hosp) < data_fim_hosp)
);
