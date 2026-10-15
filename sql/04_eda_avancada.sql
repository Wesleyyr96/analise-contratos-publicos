
-- ==================================================
-- PROJETO: ANALISE DE CONTRATOS PUBLICOS
-- ETAPA 04: ANALISE EXPLORATORIA AVANCADA
-- TECNOLOGIA: DATABRICKS SQL
-- BASE: DADOS FICTICIOS
-- ==================================================

USE CATALOG workspace;
USE SCHEMA portfolio_contratos;

-- ETAPA 19: Estatística descritiva dos contratos
-- Média, mediana e amplitude

SELECT
    COUNT(*) AS quantidade_contratos,

    ROUND(AVG(valor), 2) AS media,

    PERCENTILE_APPROX(valor, 0.5) AS mediana,

    MIN(valor) AS minimo,

    MAX(valor) AS maximo,

    MAX(valor) - MIN(valor) AS amplitude

FROM workspace.portfolio_contratos.vw_contratos_tratados

WHERE status_qualidade = 'VALIDO';


-- Quartis e dispersão dos contratos

SELECT
    PERCENTILE_APPROX(valor, 0.25) AS q1,

    PERCENTILE_APPROX(valor, 0.50) AS mediana,

    PERCENTILE_APPROX(valor, 0.75) AS q3,

    ROUND(STDDEV_SAMP(valor), 2) AS desvio_padrao,

    ROUND(VARIANCE(valor), 2) AS variancia

FROM workspace.portfolio_contratos.vw_contratos_tratados

WHERE status_qualidade = 'VALIDO';


-- ETAPA 20: Identificacao de outliers pelo IQR

WITH quartis AS (

    -- Calcular os quartis da base valida
    SELECT
        PERCENTILE_APPROX(valor, 0.25) AS q1,
        PERCENTILE_APPROX(valor, 0.75) AS q3

    FROM workspace.portfolio_contratos.vw_contratos_tratados

    WHERE status_qualidade = 'VALIDO'
),

limites AS (

    -- Calcular o IQR e os limites estatisticos
    SELECT
        q1,
        q3,
        q3 - q1 AS iqr,

        q1 - 1.5 * (q3 - q1) AS limite_inferior,

        q3 + 1.5 * (q3 - q1) AS limite_superior

    FROM quartis
),

contratos_classificados AS (

    -- Comparar cada contrato com os limites
    SELECT
        c.id_contrato,
        c.orgao,
        c.fornecedor,
        c.valor,
        l.limite_inferior,
        l.limite_superior,

        CASE
            WHEN c.valor < l.limite_inferior
              OR c.valor > l.limite_superior
            THEN 'OUTLIER'
            ELSE 'NORMAL'
        END AS classificacao

    FROM workspace.portfolio_contratos.vw_contratos_tratados c

    CROSS JOIN limites l

    WHERE c.status_qualidade = 'VALIDO'
)

SELECT
    classificacao,
    COUNT(*) AS quantidade

FROM contratos_classificados

GROUP BY classificacao

ORDER BY classificacao;


-- ETAPA 21: Classificar contratos por faixa de valor

SELECT
    id_contrato,
    orgao,
    valor,

    CASE
        WHEN valor <= 250000
            THEN '01 - Ate 250 mil'

        WHEN valor <= 500000
            THEN '02 - De 250 a 500 mil'

        WHEN valor <= 1000000
            THEN '03 - De 500 mil a 1 milhao'

        ELSE '04 - Acima de 1 milhao'
    END AS faixa_valor

FROM workspace.portfolio_contratos.vw_contratos_tratados

WHERE status_qualidade = 'VALIDO'

ORDER BY valor;



-- ==================================================
-- ETAPA 21: DISTRIBUICAO DE FREQUENCIAS
-- Quantidade, valor total e participacao percentual
-- ==================================================

WITH contratos_classificados AS (

    SELECT
        id_contrato,
        valor,

        CASE
            WHEN valor <= 250000
                THEN '01 - Ate 250 mil'

            WHEN valor <= 500000
                THEN '02 - De 250 a 500 mil'

            WHEN valor <= 1000000
                THEN '03 - De 500 mil a 1 milhao'

            ELSE '04 - Acima de 1 milhao'
        END AS faixa_valor

    FROM workspace.portfolio_contratos.vw_contratos_tratados

    WHERE status_qualidade = 'VALIDO'
),

resumo_faixas AS (

    SELECT
        faixa_valor,
        COUNT(*) AS quantidade_contratos,
        SUM(valor) AS valor_total

    FROM contratos_classificados

    GROUP BY faixa_valor
)

SELECT
    faixa_valor,
    quantidade_contratos,
    valor_total,

    ROUND(
        100.0 * quantidade_contratos
        / SUM(quantidade_contratos) OVER (),
        2
    ) AS percentual_contratos,

    ROUND(
        100.0 * valor_total
        / SUM(valor_total) OVER (),
        2
    ) AS percentual_valor

FROM resumo_faixas

ORDER BY faixa_valor;

