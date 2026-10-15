# Relatório Executivo — Análise de Contratos Públicos

## 1. Objetivo

Analisar a distribuição financeira de contratos públicos fictícios, identificando concentração de valores por órgão, categoria e fornecedor.

## 2. Metodologia

A análise foi desenvolvida em SQL no Databricks.

A base original possuía 80 registros. Após a remoção de uma duplicidade integral, foram mantidos 79 registros, dos quais 75 atenderam aos critérios de qualidade estabelecidos.

Os indicadores financeiros consideram exclusivamente os registros classificados como válidos.

## 3. Indicadores gerais

| Indicador | Resultado |
|---|---:|
| Contratos válidos | 75 |
| Valor total contratado | R$ 52.515.000 |
| Valor médio por contrato | R$ 700.200 |
| Menor contrato | R$ 85.000 |
| Maior contrato | R$ 2.100.000 |

## 4. Distribuição por órgão

A SENAD apresentou o maior valor contratado na base analisada, totalizando R$ 16.185.000, equivalentes a aproximadamente 30,82% do total.

O ranking dos três primeiros órgãos foi:

1. SENAD
2. PF
3. PRF

Não foram identificados empates no ranking.

## 5. Distribuição por categoria

A categoria Equipamentos apresentou o maior valor contratado, totalizando R$ 14.580.000, equivalentes a aproximadamente 27,76% do total.

## 6. Distribuição por fornecedor

Horizonte Serviços liderou o ranking de fornecedores, com R$ 13.970.000 em contratos, correspondentes a aproximadamente 26,60% do valor total elegível.

## 7. Principais conclusões

A análise identificou concentração financeira em determinados órgãos, categorias e fornecedores.

Os resultados demonstram como indicadores de valor contratado, participação percentual e rankings podem apoiar a compreensão da distribuição dos recursos registrados na base.

A concentração de valores não caracteriza, isoladamente, qualquer irregularidade.

## 8. Limitações

Todos os dados são fictícios e não representam contratações reais.

Os valores analisados correspondem aos valores dos contratos registrados na base, não a pagamentos efetivamente realizados.

As regras de qualidade foram definidas para fins educacionais e podem ser ampliadas em etapas futuras.


## 9. Análise exploratória da distribuição financeira

A análise dos 75 contratos válidos identificou diferenças relevantes entre a quantidade de contratos e a concentração dos valores financeiros.

A faixa acima de R$ 1 milhão reuniu 21 contratos, equivalentes a 28% dos registros, mas concentrou R$ 33.450.000, correspondentes a 63,70% do valor total.

Em contrapartida, a faixa de até R$ 250 mil apresentou a maior quantidade de contratos, com 28 registros (37,33%), representando apenas 8,05% do valor financeiro.

A média dos contratos foi de R$ 700.200, enquanto a mediana aproximada foi de R$ 420.000, sugerindo assimetria à direita na distribuição.

A análise pelo intervalo interquartil não identificou outliers entre os contratos válidos.

**Conclusão:** os contratos de maior valor concentram parcela expressiva dos recursos registrados na base fictícia, demonstrando a importância de analisar simultaneamente frequência, valor financeiro e dispersão estatística.


