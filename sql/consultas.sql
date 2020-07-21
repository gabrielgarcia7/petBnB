-- Projeto – Animais Domésticos e Exóticos
-- Contrato temporário de itens e serviços para animais de estimação

-- Caio Augusto Duarte Basso – 10801173
-- Gabriel Garcia Lorencetti – 10691891
-- Giovana Daniele da Silva – 10692224
-- Luíza Pereira Pinto Machado – 7564426 

-- CONSULTAS


-- 1. Ordenar comerciantes de acordo com as avalições de seus alugueis:
SELECT U.nome_usuario, ROUND(AVG(AP.nota_al_p), 2) AS nota_media
FROM usuario U, aluguel_produto AP
WHERE AP.comerciante_al_p = U.cpf_usuario
GROUP BY U.nome_usuario
ORDER BY nota_media DESC;


-- 2. Selecionar pets exóticos que tenham utilizado mais de um serviço:
SELECT 
	P.nome_pet, 
	P.especie_pet, 
	U.nome_usuario, 
	COUNT(*) as qtdd_servicos
FROM pet P, usuario U, prestacao_servico PS
WHERE 
	U.cpf_usuario = P.cpf_dono_pet AND
	P.nome_pet = PS.nome_pet_pr_s AND
	P.cpf_dono_pet = PS.cpf_dp_pr_s AND
	UPPER(P.tipo_pet) = 'EXÓTICO'
GROUP BY (P.nome_pet, P.especie_pet, U.nome_usuario)
HAVING COUNT(*) > 1;


-- 3. Selecionar, para cada pet, seu nome, nome do seu dono, estado de residência 
-- e, se já tiver feito algum serviço, qual foi esse serviço e com quem foi feito o negócio
SELECT 
	DATE(PS.timestamp_pr_s) AS data, 
	P.nome_pet, U1.nome_usuario AS dono_pet, 
	PS.tipo_pr_s AS tipo_servico, 
	U2.nome_usuario AS prestador
FROM pet P
JOIN usuario U1 ON (P.cpf_dono_pet = U1.cpf_usuario)
LEFT JOIN prestacao_servico PS ON (P.nome_pet = PS.nome_pet_pr_s)
LEFT JOIN USUARIO U2 ON (PS.cpf_dp_pr_s = U2.cpf_usuario)
ORDER BY data;


-- 4. Para cada comerciante, selecionar os produtos que possui para alugar, 
-- seu valor e quantas vezes já foi alugado:
SELECT 
	P.nome_produto, 
	U.nome_usuario AS comerciante, 
	P.valor_aluguel, 
	COUNT(*) as contratos
 FROM produto P
 JOIN usuario U ON U.cpf_usuario = P.comerciante_prod
 LEFT JOIN aluguel_produto AP ON P.codigo = AP.produto_al_p
 GROUP BY (P.nome_produto, U.nome_usuario, P.valor_aluguel);


-- 5. Selecionar prestadores com experiência em lidar com pets com deficiência 
-- e com quantos desse tipo eles já trabalharam:
SELECT 
	U.cpf_usuario, 
	U.nome_usuario, 
	COUNT(*) AS qtdd_exotico
FROM usuario U
JOIN prestacao_servico PS ON U.cpf_usuario = PS.cpf_pr_s
JOIN pet P ON (
	P.nome_pet = PS.nome_pet_pr_s AND
	P.cpf_dono_pet = PS.cpf_dp_pr_s AND
	UPPER(P.tipo_pet) = 'EXÓTICO')
JOIN pet_deficiencia PD ON (
	PD.cpf_dono_pet_def = PS.cpf_dp_pr_s AND
	PD.nome_pet_def = PS.nome_pet_pr_s)
GROUP BY (U.cpf_usuario, U.nome_usuario);


-- 6. Selecionar usuários que sejam, ao mesmo tempo, donos de algum pet 
-- e prestadores/comerciantes/anfritões:
SELECT U.nome_usuario
FROM usuario U, tipo_usuario TU
WHERE 
	TU.cpf_tp_usuario = U.cpf_usuario AND
	UPPER(TU.tipo_usuario) = 'DONO PET'
INTERSECT
SELECT U.nome_usuario
FROM usuario U, tipo_usuario TU
WHERE 
	 TU.cpf_tp_usuario = U.cpf_usuario AND
	(UPPER(TU.tipo_usuario) = 'COMERCIANTE' OR 
	 UPPER(TU.tipo_usuario) = 'ANFITRIÃO' OR 
	 UPPER(TU.tipo_usuario) = 'PRESTADOR SERVIÇO');


-- 7. Para cada pet, selecionar: nome do pet, nome do dono, total gasto em 
-- produtos e serviços e a quantidade de produtos e serviços contratados.
SELECT 
	P.nome_pet, 
	U.nome_usuario, 
	CASE 
		WHEN SUM(PS.valor_pr_s) > 0.00 THEN SUM(PS.valor_pr_s)
		ELSE '0.00'
	END AS total_gasto	
FROM pet P
JOIN usuario U ON U.cpf_usuario = P.cpf_dono_pet
LEFT JOIN prestacao_servico PS ON U.cpf_usuario = PS.cpf_dp_pr_s
GROUP BY (P.nome_pet, U.nome_usuario)
ORDER BY total_gasto DESC;


-- 8. Dado um bairro, retornar os passeadores mais bem avaliados do mesmo
SELECT U.nome_usuario, U.email, ROUND(AVG(PS.nota_pr_s), 2) AS nota_media
    FROM usuario U, prestacao_servico PS
        JOIN passeador_bairros PB ON PS.cpf_pr_s = PB.cpf_pb
        WHERE PS.cpf_pr_s = U.cpf_usuario AND UPPER(PS.tipo_pr_s) = 'PASSEIO' 
              AND UPPER(PB.bairro_pb) = 'JARDIM IPANEMA'
            GROUP BY U.nome_usuario, U.email
            ORDER BY nota_media DESC;


-- 9. Selecionar, para cada dono de pet, seu nome e, se já tiver fechado algum 
-- contrato, selecionar os nomes dos usuários com que fez negócio, o tipo de 
-- negócio, a data do contrato e seu valor
SELECT 	U1.nome_usuario AS dono_pet, 
		U2.nome_usuario AS contratado,
		PS.tipo_pr_s AS tipo_contrato,
		DATE(PS.timestamp_pr_s) AS data,
		PS.valor_pr_s AS valor
FROM usuario U1, usuario U2, tipo_usuario TP, prestacao_servico PS
WHERE
	(U1.cpf_usuario = TP.cpf_tp_usuario AND UPPER(TP.tipo_usuario) = 'DONO PET') AND
	(U1.cpf_usuario = PS.cpf_dp_pr_s AND U2.cpf_usuario = PS.cpf_pr_s)
UNION
SELECT 	U1.nome_usuario AS dono_pet, 
		U2.nome_usuario AS contratado,
		CASE
			WHEN AP.dono_pet_al_p = U1.cpf_usuario THEN 'ALUGUEL'
		END AS tipo_contrato,
		DATE(AP.timestamp_al_p) AS data,
		AP.valor_al_p AS valor
FROM usuario U1, usuario U2, tipo_usuario TP, aluguel_produto AP
WHERE
	(U1.cpf_usuario = TP.cpf_tp_usuario AND UPPER(TP.tipo_usuario) = 'DONO PET') AND
	(U1.cpf_usuario = AP.dono_pet_al_p AND U2.cpf_usuario = AP.comerciante_al_p)
UNION
SELECT 	U1.nome_usuario AS dono_pet, 
		U2.nome_usuario AS contratado,
		CASE
			WHEN H.cpf_dono_hosp = U1.cpf_usuario THEN 'HOSPEDAGEM'
		END AS tipo_contrato,
		DATE(h.timestamp_hosp) AS data,
		H.valor_hosp AS valor
FROM usuario U1, usuario U2, tipo_usuario TP, hospedagem H
WHERE
	(U1.cpf_usuario = TP.cpf_tp_usuario AND UPPER(TP.tipo_usuario) = 'DONO PET') AND
	(U1.cpf_usuario = H.cpf_dono_hosp AND U2.cpf_usuario = H.anf_hosp)
ORDER BY valor;


-- 10. Selecionar comerciantes, prestadores e anfitriões e seus lucros totais
SELECT U.nome_usuario, 'SERVIÇO' AS tipo_servico, SUM(PS.valor_pr_s) AS valor_total
FROM prestacao_servico PS
JOIN usuario U ON PS.cpf_pr_s = U.cpf_usuario
GROUP BY U.nome_usuario
UNION ALL
SELECT U.nome_usuario, 'ALUGUEL' AS tipo_servico, SUM(AP.valor_al_p) AS valor_total
FROM aluguel_produto AP
JOIN usuario U ON AP.comerciante_al_p = U.cpf_usuario
GROUP BY U.nome_usuario
UNION ALL
SELECT U.nome_usuario, 'HOSPEDAGEM' AS tipo_servico, SUM(H.valor_hosp) AS valor_total
FROM hospedagem H
JOIN usuario U ON H.anf_hosp = U.cpf_usuario
GROUP BY U.nome_usuario
ORDER BY valor_total DESC;


-- 11. Selecionar usuários que tenham alugado todos os produtos de um certo comerciante

-- Alternativa 01
SELECT U.nome_usuario 
FROM usuario U
JOIN ( SELECT AP.dono_pet_al_p AS CPF_USUARIO, AP.produto_al_p AS PRODUTO 
       FROM aluguel_produto AP
       WHERE AP.comerciante_al_p = '921.585.380-40' ) USUARIO_PRODUTO
    ON USUARIO_PRODUTO.CPF_USUARIO =  U.cpf_usuario
GROUP BY USUARIO_PRODUTO.CPF_USUARIO, U.nome_usuario 
HAVING COUNT(*) = (
	SELECT COUNT(*) AS PRODUTO 
	FROM produto P
	WHERE P.comerciante_prod = '921.585.380-40'
);

-- Alternativa 02
SELECT DISTINCT U.nome_usuario
FROM usuario U, aluguel_produto AP1
WHERE 
	AP1.dono_pet_al_p = U.cpf_usuario AND
	(U.nome_usuario) NOT IN (
		SELECT DISTINCT U.nome_usuario
		FROM usuario U, aluguel_produto AP, produto P
		WHERE 
			AP.dono_pet_al_p = U.cpf_usuario AND
			P.comerciante_prod = '921.585.380-40' AND
			(U.nome_usuario, P.codigo) NOT IN (
				SELECT U.nome_usuario, AP.produto_al_p
				FROM usuario U, aluguel_produto AP
					WHERE 
						U.cpf_usuario = AP.dono_pet_al_p
			)
	);
