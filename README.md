# DevShop - Aplicativo Mobile de E-commerce

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Provider](https://img.shields.io/badge/Provider-4.1.0-blue?style=for-the-badge)

## 📋 Sobre o Projeto

O **DevShop** é um aplicativo móvel de e-commerce desenvolvido em Flutter, seguindo padrões arquiteturais como MVC (Model-View-Controller) e utilizando Provider para gerenciamento de estado.

O aplicativo oferece uma experiência completa de compras online com interface moderna e intuitiva, focando na apresentação da UI, navegação entre telas, validações de formulários e tratamento adequado de dados.

## 👥 Integrantes da Equipe

- **Guilherme**
- **Mateus**
- **Gabriel**

## 🎯 Sobre o Projeto Acadêmico

Este é um projeto acadêmico desenvolvido na disciplina de Desenvolvimento Mobile, Parte 1 do trabalho prático.

**Parte 1 - Foco na Interface e Navegação**
A primeira parte concentra-se no desenvolvimento completo da interface do usuário (UI), navegação entre telas, validações de formulários e tratamento de dados. Utiliza dados estáticos em memória, sem persistência (que será implementada na Parte 2).

## 🚀 Funcionalidades Implementadas

### ✅ Interface do Usuário
- **Tela Inicial (Home)**: Apresenta banners promocionais, categorias, produtos em destaque e ofertas especiais
- **Busca**: Campo de busca com filtros
- **Navegação**: Bottom navigation bar para acesso rápido às seções
- **Animações**: Transições suaves e efeitos visuais modernos

### ✅ Autenticação
- **Login**: Formulário com validações (email, senha)
- **Registro**: Formulário completo com validações e feedback
- **Mensagens de erro**: Exibição clara de erros de validação

### ✅ Produtos
- **Listagem**: Exibição de produtos em grid/lista
- **Detalhes**: Tela de detalhes do produto
- **Categorias**: Navegação por categorias

### ✅ Carrinho e Perfil
- **Carrinho**: Interface para gerenciamento de itens
- **Perfil**: Área do usuário com informações pessoais

### ✅ Validações e Feedback
- Validação em tempo real nos formulários
- Mensagens de erro contextuais
- Feedback visual para ações do usuário

## 🛠️ Tecnologias Utilizadas

- **Flutter**: Framework para desenvolvimento mobile
- **Dart**: Linguagem de programação
- **Provider**: Gerenciamento de estado
- **Google Fonts**: Tipografia moderna
- **Material Design 3**: Design system do Google
- **MVC Pattern**: Arquitetura organizada

## 📦 Instalação e Configuração

### Pré-requisitos
- Flutter SDK (versão 3.9.0 ou superior)
- Dart SDK
- Android Studio ou VS Code
- Dispositivo/emulador Android ou iOS

### Passos para Instalação

1. **Clone o repositório**:
   ```bash
   git clone https://github.com/GOA03/devshop.git
   cd devshop
   ```

2. **Mude para a branch correta**:
   ```bash
   git checkout anti-gabi
   ```

3. **Instale as dependências**:
   ```bash
   flutter pub get
   ```

4. **Execute o aplicativo**:
   ```bash
   flutter run
   ```

### Verificação
- Certifique-se de que o Flutter está instalado corretamente: `flutter doctor`
- Teste em diferentes dispositivos para garantir compatibilidade

## 📋 Particularidades e Limitações

### ✅ Implementado
- Interface completa e responsiva
- Navegação fluida entre telas
- Validações robustas em formulários
- Estrutura MVC bem organizada
- Uso adequado do Provider

### ⚠️ Limitações Conhecidas (Parte 1)
- **Persistência de Dados**: Não implementada (será na Parte 2). Atualmente usa dados estáticos em memória.
- **Backend**: Não conectado a servidor/API real.
- **Banco de Dados**: Dados são mockados/simulados.
- **Autenticação**: Não persiste sessões (logout ao fechar app).
- **Carrinho**: Dados não salvos permanentemente.

### 🐛 Bugs Conhecidos
- Nenhum bug crítico identificado na Parte 1.
- Algumas animações podem ter comportamento diferente em dispositivos antigos.

### 🔮 Funcionalidades Futuras (Parte 2)
- Integração com banco de dados
- API REST para produtos e usuários
- Persistência de carrinho e favoritos
- Sistema de pagamentos
- Notificações push

## 👨‍💻 Atividades dos Integrantes

### Guilherme
- Desenvolvimento da tela inicial (Home) com banners e produtos em destaque
- Implementação das animações e transições
- Configuração do tema e cores do aplicativo

### Mateus
- Criação dos formulários de autenticação (login e registro)
- Implementação das validações e feedback de erro
- Desenvolvimento dos widgets customizados (CustomTextField, CustomButton)

### Gabriel
- Estruturação da arquitetura MVC
- Configuração do Provider para gerenciamento de estado
- Desenvolvimento das telas de produtos, carrinho e perfil
- Navegação entre telas e bottom navigation

Todos os membros contribuíram para revisões de código, testes e refinamentos da UI/UX.

## 📚 Recursos Adicionais

Para mais informações sobre Flutter:
- [Documentação Oficial](https://docs.flutter.dev/)
- [Codelabs](https://docs.flutter.dev/codelab)
- [Cookbook](https://docs.flutter.dev/cookbook)

## 📞 Contato

Para dúvidas sobre o projeto, entre em contato com os integrantes da equipe.

---

**Nota**: Este é um projeto acadêmico desenvolvido como parte da avaliação da disciplina de Desenvolvimento Mobile. Todos os direitos reservados aos autores.
