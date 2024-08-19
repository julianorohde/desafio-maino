# README

## DESAFIO TÉCNICO MAINÔ

O seguinte APP é responsável por realizar a leitura de Notas Fiscais (.xml) ou conjunto de Notas Fiscais (.zip) e a renderização em tela de suas informações.
Também é possível a filtragem dessas Notas Fiscais através de parâmetros como Número da Nota Fiscal, Produto, Emitente ou Destinatário.
Além disso, é possível a exportação desses arquivos para formato Excel (.xlsx)

Desenvolvido por [Juliano Rohde](https://github.com/julianorohde).

## Requisitos

* Ruby 3.2.2 e Rails 7.1.2;
* Clonar o repositório;
* Rodar `bundle install` para instalar as Gems e dependências;
* Criar o banco de dados local (`rails db:create`) e rodar as migrações `rails db:migrate`.
* Executar o Sidekiq localmente `bundle exec sidekiq`.

## Como rodar os testes RSpec
1. Criar o banco de dados de testes utilizando o comando `rails db:create` e rodar as migrações `rails db:migrate`.
2. Rodar `rspec` no terminal, o resultado deve ser:

   ```
   Finished in 1.04 seconds (files took 4.39 seconds to load)
   33 examples, 0 failures

   Coverage report generated for RSpec to /Users/julianorohde/Documents/projects/maino/desafio-maino/coverage. 283 / 329 LOC (86.02%) covered.
   ```

Estamos com somente 86.02% de coverage pois alguns métodos dentro do `EletronicInvoicesController` e do service `EletronicInvoice::CreateService` precisam de conexão com a AWS S3 para fazer upload dos arquivos e isso foi desabilitado em ambiente de desenvolvimento/testes. 

![Screenshot 2024-08-18 at 21 30 32](https://github.com/user-attachments/assets/1e068a93-5f39-4803-9833-c855674f5866)
### 
