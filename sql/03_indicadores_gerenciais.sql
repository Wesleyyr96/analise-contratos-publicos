
-- ==================================================
-- PROJETO: ANALISE DE CONTRATOS PUBLICOS
-- ETAPA 03: INDICADORES GERENCIAIS
-- TECNOLOGIAS: SQL / DATABRICKS
-- BASE: DADOS FICTICIOS
-- ==================================================

USE CATALOG workspace;
USE SCHEMA portfolio_contratos;

-- ==================================================
-- KPI 01: INDICADORES FINANCEIROS GERAIS
-- ==================================================

SELECT
    COUNT(*) AS quantidade_contratos,
    SUM(valor) AS valor_total,
    ROUND(AVG(valor), 2) AS valor_medio,
    MIN(valor) AS menor_valor,
    MAX(valor) AS maior_valor
FROM vw_contratos_tratados
WHERE status_qualidade = 'VALIDO';


-- ==================================================
-- KPI 02: CONTRATOS POR ORGAO
-- ==================================================

SELECT
    orgao,
    COUNT(*) AS quantidade_contratos,
    SUM(valor) AS valor_total,
    ROUND(AVG(valor), 2) AS valor_medio
FROM vw_contratos_tratados
WHERE status_qualidade = 'VALIDO'
GROUP BY orgao
ORDER BY valor_total DESC;


-- ==================================================
-- KPI 03: PARTICIPACAO PERCENTUAL POR ORGAO
-- ==================================================

WITH resumo_orgao AS (
    SELECT
        orgao,
        COUNT(*) AS quantidade_contratos,
        SUM(valor) AS valor_total
    FROM vw_contratos_tratados
    WHERE status_qualidade = 'VALIDO'
    GROUP BY orgao
)
SELECT
    orgao,
    quantidade_contratos,
    valor_total,
    ROUND(
        100.0 * valor_total
        / SUM(valor_total) OVER (),
        2
    ) AS percentual_participacao
FROM resumo_orgao
ORDER BY valor_total DESC;


-- ==================================================
-- KPI 04: CONTRATOS POR CATEGORIA
-- ==================================================

SELECT
    COALESCE(categoria, 'Nao informada') AS categoria,
    COUNT(*) AS quantidade_contratos,
    SUM(valor) AS valor_total,
    ROUND(AVG(valor), 2) AS valor_medio
FROM vw_contratos_tratados
WHERE status_qualidade = 'VALIDO'
GROUP BY COALESCE(categoria, 'Nao informada')
ORDER BY valor_total DESC;


-- ==================================================
-- KPI 05: RANKING DE ORGAOS
-- ==================================================

WITH resumo_orgao AS (
    SELECT
        orgao,
        COUNT(*) AS quantidade_contratos,
        SUM(valor) AS valor_total
    FROM vw_contratos_tratados
    WHERE status_qualidade = 'VALIDO'
    GROUP BY orgao
)
SELECT
    orgao,
    quantidade_contratos,
    valor_total,
    DENSE_RANK() OVER (
        ORDER BY valor_total DESC
    ) AS posicao_ranking
FROM resumo_orgao
ORDER BY posicao_ranking, orgao;


-- ==================================================
-- KPI 06: RANKING DE FORNECEDORES
-- ==================================================

WITH resumo_fornecedor AS (
    SELECT
        fornecedor,
        COUNT(*) AS quantidade_contratos,
        SUM(valor) AS valor_total
    FROM vw_contratos_tratados
    WHERE status_qualidade = 'VALIDO'
      AND fornecedor IS NOT NULL
    GROUP BY fornecedor
)
SELECT
    fornecedor,
    quantidade_contratos,
    valor_total,
    DENSE_RANK() OVER (
        ORDER BY valor_total DESC
    ) AS posicao_ranking
FROM resumo_fornecedor
ORDER BY posicao_ranking, fornecedor;
