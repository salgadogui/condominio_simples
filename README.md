# Condomínio Simples

Sistema de gerenciamento de condomínios desenvolvido em Ruby on Rails.

## Requisitos

- Ruby 3.2.2 ou superior
- Rails 8.0.1
- SQLite3
- Node.js e Yarn (para assets)
- wkhtmltopdf (para geração de PDFs)

## Configuração do Ambiente

1. Clone o repositório:
```bash
git clone [URL_DO_REPOSITÓRIO]
cd condominio_simples
```

2. Instale as dependências:
```bash
bundle install
```

3. Configure o banco de dados:
```bash
rails db:create
rails db:migrate
```

4. Inicie o servidor:
```bash
./bin/dev

```

A aplicação estará disponível em `http://localhost:3000`

## Tecnologias Utilizadas

- Ruby on Rails 8.0.1
- SQLite3 como banco de dados
- TailwindCSS para estilização
- Turbo Rails para interatividade
- Stimulus.js para JavaScript
- WickedPDF para geração de PDFs

## Funcionalidades Principais

- Gerenciamento de moradores
- Controle de despesas
- Geração de boletos
- Gerenciamento individual de imóveis
- Gestão de blocos de imóveis

## Ambiente de Desenvolvimento

O projeto utiliza várias ferramentas para garantir a qualidade do código:

- Rubocop para linting
- Brakeman para segurança
- Capybara para testes de integração
- Ruby LSP para desenvolvimento

## Licença

Este projeto está sob a licença MIT.