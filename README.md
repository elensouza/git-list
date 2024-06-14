# Git-list
Aplicativo que lista os gist da API pública do GitHub, ao clicar em um item da lista mostra detalhes. Listagem com paginação, ao chegar no ultimo item, faz request para a próxima página (infinite scroll).

A arquitetura utilizada foi a MVP, pois se adequa bem à necessidade do projeto, dada sua baixa complexidade. A MVVM poderia ser usada também, minha decisão foi baseada considerando o prazo de entrega x esforço. As camadas separadas,  aliada à  Programação Orientada a Protocolos, facilitam a manutenção, adição de novas features assim como a criação de testes unitários e seus stubs, spies e mocks. Além de facilitar a divisão das responsabilidades e manter a organização.

Para rodar os testes: cmd+u (iPhone 14 Pro - iOS 16.4)

A versão utilizada do Xcode foi a 14.3.

![Preview](https://github.com/elensouza/git-list/assets/47696869/d9731e5b-2d10-414f-8061-408f10e6109d)

## Frameworks adicionados:
[Swift Snapshot Testing](https://github.com/pointfreeco/swift-snapshot-testing) - para os testes de snapshot.

## Adicionais:
* Suporte a dark e light mode.
* Pull to refresh para atualizar a lista dos gits.
* Tela de loading e erro.
* Tratamento para erro de download de imagem.
* Os testes de snapshots contemplam iPhone, portrait, landscape, light e dark mode.
* Strings localizadas para português e inglês.

## Sugestões de melhorias:
- [ ] Adicionar validação para paginação.
- [ ] Adicionar um framework , tipo Tuist, para gerar os arquivos do Xcode e assim facilitar a manutenção, além de evitar conflitos no pbxproj quando houver atuação em equipes.
- [ ] Criar um modulo com helpers para facilitar os testes, por exemplo:  pegar views pelo accessibilityIdentifier, mock de navigation, URLSession, configuração de UINavigation.
- [ ] Criar um módulo para Networks para centralizar e deixar disponível para outras equipes.
- [ ] Criar testes automatizados de UI.
- [ ] Mapear os tipo de erro para apresentar adequadamente ao usuário.
- [ ] Adicionar acessibilidade para VoiceOver, fontes dinâmicas e outros tipos de acessibilidade para democratizar o acesso ao aplicativo.
- [ ] Pipeline ci/cd.
- [ ] Adicionar Swiftlint visando qualidade e integridade do código.
