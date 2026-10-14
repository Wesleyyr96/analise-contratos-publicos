-- Definir o catálogo e schema
USE CATALOG workspace;
USE SCHEMA portfolio_contratos;

-- Criar uma view com os dados preparados
CREATE OR REPLACE VIEW vw_contratos_tratados AS

WITH contratos_sem_duplicidade AS (
    SELECT DISTINCT
        id_contrato,
        orgao,
        fornecedor,
        valor,
        data_contrato,
        situacao,
        categoria
    FROM contratos_publicos
),

contratos_padronizados AS (
    SELECT
        id_contrato,

        -- Remover espaços e transformar texto vazio em NULL
        NULLIF(TRIM(orgao), '') AS orgao,
        NULLIF(TRIM(fornecedor), '') AS fornecedor,

        -- Preservar o valor numérico original
        valor,

        -- Tentar converter a data sem interromper a consulta
        TRY_CAST(data_contrato AS DATE) AS data_contrato,

        NULLIF(TRIM(situacao), '') AS situacao,
        NULLIF(TRIM(categoria), '') AS categoria

    FROM contratos_sem_duplicidade
)

SELECT
    *,

    -- Validar os campos essenciais
    CASE
        WHEN id_contrato IS NULL THEN 'REVISAR'
        WHEN orgao IS NULL THEN 'REVISAR'
        WHEN valor IS NULL THEN 'REVISAR'
        WHEN valor < 0 THEN 'REVISAR'
        WHEN data_contrato IS NULL THEN 'REVISAR'
        ELSE 'VALIDO'
    END AS status_qualidade

FROM contratos_padronizados;
