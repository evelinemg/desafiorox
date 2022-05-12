## O desafio
A partir de um conjunto de arquivos referentes aos dados de um empresa que produz bicicletas deve-se:
 - Fazer a modelagem conceitual dos dados;
 - Criação da infraestrutura necessária;
 - Criação de todos os artefatos necessários para carregar os arquivos para o banco criado;
 - Desenvolvimento de SCRIPT para análise de dados;
 - (opcional) Criar um relatório em qualquer ferramenta de visualização de dados.
 
 Foram disponibilizados os seguintes arquivos no formato CSV:
|nº| Arquivos    |
|---| ---------------- | 
|1|  Sales.SpecialOfferProduct.csv     | 
|2|Production.Product.csv  | 
|3| Sales.SalesOrderHeader.csv|
|4| Sales.Customer.csv|
|5| Person.Person.csv|
|6|Sales.SalesOrderDetail.csv|


 A partir do diagrama oferecido é possível verificar as chaves estrangeiras e chaves primárias:
 
 ![Diagrama do BD](/img/modelooferecido.png)

## Ferramentas utilizadas

* Workbench
* AzCopy v10
* Azure Storage
* Azure MySQL 8.0
* DataFactory
* BigQuery

## Desenvolvimento

#### Banco de Dados

A nuvem escolhida para hospedagem do Banco de Dados MySQL 8.0 foi a Azure. A assinatura da Azure para estudantes oferece 750 horas e 32GB de storage por um periodo de 12 meses, fator relevante para escolha desse serviço de cloud e que atende a realização desse projeto.
Foi criado um Banco de Dados com as seguinte configuração: 
- Burstable, B1ms, 1 vCores, 2 GiB RAM, 20 GiB storage

 ![Banco de Dados Criado na AZ](/img/bdMysql.JPG)
 
 A modelagem da Banco de Dados foi feita utilizando a ferramenta Models do Workbench
 
 ![Modelagem Banco de Dados](/img/modeloconceitual.png)
 
 #### Azure Storage
 
 Utilizando o AZCopy todos os arquivos CSV foram enviados de uma pasta local para a Azure Storage
 
 ![Sincronização Diretório Local Azure](/img/azcopyenvio.JPG)
 
 
 
