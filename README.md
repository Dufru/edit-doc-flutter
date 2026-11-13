# Relatório de Migração Arquitetural — Edit Doc Flutter

## 1. Mapeamento de Classes e Widgets

Inicialmente, a aplicação foi desenvolvida em um único arquivo no DartPad, contendo as telas, regras de negócio, validações e navegação. Durante a migração para o GitHub Codespaces, o código foi reorganizado seguindo o padrão arquitetural MVVM (Model-View-ViewModel), separando as responsabilidades em diferentes arquivos.

A organização ficou da seguinte forma:

| Elemento original | Novo arquivo | Responsabilidade |
|---|---|---|
| `MyApp` | `lib/main.dart` | Inicialização, configuração do tema e rotas da aplicação. |
| `Usuario` | `lib/models/usuario.dart` | Representação dos dados do usuário. |
| `Documento` | `lib/models/documento.dart` | Representação dos documentos e conversão dos dados. |
| Persistência de preferências | `lib/models/services/preferences_service.dart` | Armazenamento das preferências do aplicativo. |
| Acesso aos dados locais | `lib/models/services/banco_local_service.dart` | Operações relacionadas aos usuários e dados locais. |
| Autenticação e cadastro | `lib/viewmodels/auth_viewmodel.dart` | Regras de autenticação, cadastro e gerenciamento das preferências. |
| Gerenciamento de documentos | `lib/viewmodels/documentos_viewmodel.dart` | Controle das operações de criação, consulta, edição e exclusão de documentos. |
| `TelaLogin` | `lib/views/login_view.dart` | Interface de autenticação do usuário. |
| `TelaCadastro` | `lib/views/cadastro_view.dart` | Interface de cadastro e seleção de preferências. |
| `TelaPrincipal` | `lib/views/home_view.dart` | Tela principal, listagem de documentos e acesso às funcionalidades. |
| Editor de documentos | `lib/views/editor_view.dart` | Interface para criação e edição de documentos. |
| Funções de validação | `lib/utils/validadores.dart` | Validações de nome, e-mail e senha. |

A separação permite que cada camada tenha uma responsabilidade específica, facilitando a manutenção, a organização e a evolução do projeto.

## 2. Alterações de Estrutura e Imports

A principal adaptação foi dividir o código que anteriormente estava concentrado em um único arquivo em diversos arquivos Dart independentes.

Com essa mudança, foram necessárias algumas alterações:

- **Organização das classes:** os modelos foram transferidos para `models/`, as regras de negócio para `viewmodels/` e as interfaces para `views/`.
- **Construtores:** as classes que recebem informações externas passaram a utilizar construtores com parâmetros nomeados e, quando necessário, `required`, facilitando a identificação dos dados necessários para sua inicialização.
- **Encapsulamento:** atributos internos dos ViewModels passaram a utilizar o prefixo `_`, indicando que são privados à biblioteca Dart. Getters foram utilizados para disponibilizar os dados necessários às interfaces.
- **Imports:** cada arquivo passou a importar explicitamente os modelos, serviços e ViewModels dos quais depende, utilizando caminhos relativos.
- **Rotas nomeadas:** a navegação foi centralizada no `main.dart`, utilizando rotas como `/`, `/cadastro`, `/home` e `/editor`. A passagem de informações entre telas ocorre por meio de `arguments`.
- **Separação das validações:** as funções de validação foram concentradas em `utils/validadores.dart`, evitando duplicação de regras nas telas.

Também foi adotado o pacote Provider para disponibilizar os ViewModels às telas e facilitar o gerenciamento compartilhado do estado da aplicação.

Essa organização reduz o acoplamento entre as interfaces e as regras de negócio, permitindo modificar uma camada sem precisar concentrar todas as alterações em um único arquivo.

## 3. Mudanças no Gerenciamento de Estado

Na implementação inicial, parte do controle de estado estava diretamente nas telas, utilizando `setState()`. Com a migração para MVVM, as responsabilidades relacionadas às regras de negócio foram transferidas para classes que estendem `ChangeNotifier`.

As principais mudanças foram:

**Estado de autenticação e preferências**

O `AuthViewModel` passou a controlar as informações relacionadas ao usuário autenticado, ao processo de cadastro, ao carregamento e às preferências do aplicativo, como o tema e as notificações.

**Estado dos documentos**

O `DocumentosViewModel` passou a controlar a lista de documentos e as operações de criação, consulta, atualização e exclusão.

**Atualização das interfaces**

Os ViewModels utilizam `notifyListeners()` para informar que seus dados foram alterados.

As telas utilizam Provider, principalmente por meio de `Consumer` para acompanhar as alterações e reconstruir automaticamente os componentes que dependem dos dados atualizados. Para operações que apenas precisam acessar um ViewModel sem escutar mudanças, é utilizado `context.read()`.

O Provider também é configurado no `main.dart`, disponibilizando os ViewModels para as telas da aplicação.

O uso de `setState()` não foi eliminado completamente: ele continua sendo adequado para estados temporários e exclusivamente visuais, como controlar a exibição de uma senha ou atualizar uma seleção local de formulário. Entretanto, as regras de negócio e os dados compartilhados deixaram de depender diretamente das telas.

Dessa maneira, o gerenciamento de estado fica centralizado nos ViewModels, enquanto as Views permanecem responsáveis principalmente pela apresentação e interação com o usuário.

## Conclusão

A migração para MVVM tornou o projeto mais organizado e modular. A separação entre Model, View e ViewModel melhorou a divisão de responsabilidades, enquanto o Provider facilitou o compartilhamento de estado e a atualização das interfaces.

A estrutura também criou uma base adequada para a implementação das funcionalidades de persistência e CRUD, permitindo que a aplicação evolua sem concentrar suas responsabilidades nas telas.

**Tecnologias utilizadas:** Flutter, Dart, MVVM, ChangeNotifier, Provider e SharedPreferences.
