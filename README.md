# Git-list
Aplicativo que lista os gist da API pública do GitHub, ao clicar em um item da lista mostra detalhes. Listagem com paginação, ao chegar no ultimo item, faz request para a próxima página (infinite scroll).

A arquitetura utilizada foi a MVP, pois se adequa bem à necessidade do projeto, dada sua baixa complexidade. A MVVM poderia ser usada também, minha decisão foi baseada considerando o prazo de entrega x esforço. As camadas separadas,  aliada à  Programação Orientada a Protocolos, facilitam a manutenção, adição de novas features assim como a criação de testes unitários e seus stubs, skpies e mocks. Além de facilitar a divisão das responsabilidades e manter a organização.

Para rodar os testes: cmd+u

A versão utilizada do Xcode foi a 14.3.

## Frameworks adicionados:
SwiftLint - visando qualidade e integridade do código.

Snapshot - para os testes de snapshots.

## Adicionais:
Suporte a dark e light mode.
Pull to refresh para atualizar a lista dos gits.
Tela de loading e erro.
Tratamento para erro de download de imagem.
Os testes de snapshots contemplam iPhone, portrait, landscape, light e dark mode.
Criei strings localizadas para português e inglês.

![Simulator Screen Recording - iPhone 14 Pro - 2024-06-14 at 01 37 54](https://github.com/elensouza/git-list/assets/47696869/d9731e5b-2d10-414f-8061-408f10e6109d)


## Sugestões de melhorias:
- [ ] Adicionar validação para paginação.
- [ ] Adicionar um framework , tipo Tuist, para gerar os arquivos do Xcode e assim facilitar a manutenção, além de evitar conflitos no pbxproj quando houver atuação em equipes.
- [ ] Criar um modulo com helpers para facilitar os testes, por exemplo:  pegar views pelo accessibilityIdentifier, mock de navigation, URLSession, configuração de UINavigation.
- [ ] Criar testes automatizados de UI.
- [ ] Mapear os tipo de erro para apresentar adequadamente ao usuário.
- [ ] Adicionar acessibilidade para VoiceOver, fontes dinâmicas e outros tipos de acessibilidade para democratizar o acesso ao aplicativo.
- [ ] Pipeline ci/cd.
