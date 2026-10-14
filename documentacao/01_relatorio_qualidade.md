# Relatório 01 — Diagnóstico e Tratamento da Qualidade dos Dados

## 1. Objetivo

Avaliar a qualidade de uma base fictícia de contratos públicos, identificando inconsistências que possam comprometer a confiabilidade das análises e dos indicadores gerenciais.

A auditoria foi desenvolvida utilizando SQL no Databricks.

## 2. Características da base

A base original possui 80 registros e sete colunas:

- `id_contrato`
- `orgao`
- `fornecedor`
- `valor`
- `data_contrato`
- `situacao`
- `categoria`

Os dados são fictícios e destinados exclusivamente a estudos.

## 3. Problemas identificados

| Problema | Resultado |
|---|---|
| Identificador repetido | CT0013 |
| Duplicidade integral | 1 ocorrência excedente |
| Órgão ausente | 1 registro |
| Fornecedor ausente | 1 registro |
| Valor ausente | 1 registro |
| Data inválida | CT0046 |
| Valor negativo | 1 registro, de R$ -20.000 |
| Valor máximo observado | R$ 2.100.000 |
| Média original dos valores não nulos | R$ 684.493,67 |

## 4. Metodologia de tratamento

Foi criada a view `vw_contratos_tratados`, preservando a tabela original `contratos_publicos`.

As transformações implementadas incluem:

- Remoção de duplicidades integrais por meio de `SELECT DISTINCT`.
- Padronização de campos textuais com `TRIM`.
- Conversão de textos vazios para `NULL` com `NULLIF`.
- Conversão segura de datas com `TRY_CAST`.
- Classificação dos registros em `VALIDO` ou `REVISAR` por meio de `CASE WHEN`.

Os registros sinalizados para revisão foram preservados na view, permitindo investigação posterior.

## 5. Resultados da validação

| Indicador | Resultado |
|---|---:|
| Registros originais | 80 |
| Registros após deduplicação | 79 |
| Registros classificados como válidos | 75 |
| Registros sinalizados para revisão | 4 |
| Percentual de registros válidos após deduplicação | 94,94% |
| Percentual de registros para revisão | 5,06% |

## 6. Considerações técnicas

Os critérios de validação foram definidos para fins educacionais.

A classificação `VALIDO` indica que o registro passou nas regras implementadas, não que sua correção foi comprovada em todas as dimensões.

Valores negativos e campos ausentes exigem investigação conforme as regras de negócio antes de qualquer correção definitiva.

## 7. Conclusão

A auditoria identificou inconsistências de unicidade, completude e validade.

A criação de uma view tratada permitiu padronizar os registros e classificar sua qualidade sem modificar a tabela original.

O processo demonstrou a importância de validar dados antes de construir indicadores gerenciais e análises financeiras.

## 8. Próximas etapas

- Detalhar os motivos de revisão por registro.
- Preservar os valores originais para rastreabilidade.
- Criar indicadores financeiros com critérios explícitos de elegibilidade.
- Desenvolver rankings e análises avançadas com SQL.
