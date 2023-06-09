# ToD - To Do List em Prolog

Este é um projeto de uma aplicação de linha de comando em Prolog para gerenciar tarefas de estudantes universitários. A ToD tem como objetivo principal ajudar os usuários a manter suas tarefas organizadas, priorizadas e em dia, evitando esquecimentos e atrasos.

A ToD permite que os usuários criem perfis para armazenar suas listas de tarefas, adicionem novas tarefas com descrição, data de vencimento, prioridade e outros dados relevantes, adicionem status das tarefas (como não iniciada, em progresso ou concluída) e editem ou removam tarefas já existentes. Além disso, é possível visualizar todas as tarefas em uma lista ordenada por data de vencimento e prioridade, bem como definir lembretes para tarefas próximas de vencer.

A ToD também permite que os usuários criem uma lista de tarefas compartilhada, onde é possível fazer todas as ações anteriores em conjunto com outros perfis de usuário escolhidos, indicando quais perfis têm acesso.

A aplicação usa um banco de dados simples em arquivos de texto para armazenar as tarefas e os perfis de usuário. A interface de linha de comando é fácil de usar e intuitiva.
# Funcionalidades

- Criação de perfil para armazenar sua(s) lista(s).
- Adição de tarefas com descrição, data de vencimento, prioridade e outras informações relevantes.
- Adicionar status das tarefas (não iniciada, em progresso, concluída, etc) e atualizá-los posteriormente.
- Edição de tarefas: é possível editar as informações de suas tarefas, como a descrição, a data de vencimento e a prioridade.
- Remoção de tarefas: é possível remover tarefas que já foram concluídas ou que não são mais relevantes.
- Visualização de tarefas: é possível visualizar todas as suas tarefas em uma lista ordenada por data de vencimento e prioridade. Também é possível visualizar apenas as tarefas que vencem em um determinado período de tempo, como no dia atual ou na próxima semana.
- Lembretes: é possível definir lembretes para suas tarefas, de modo que o usuário receba notificações em seu celular ou email quando uma tarefa estiver próxima de vencer.
- Lista de tarefas compartilhada: é possível criar uma lista de tarefas compartilhada, onde é possível fazer todas as ações anteriores em conjunto com os perfis de sua escolha.
- Dashboard com informações gerais sobre a ToD.

# Instalação

## Para instalar a ToD, siga os seguintes passos:

1. Clone este repositório em sua máquina local.
2. Certifique-se de ter o compilador [SWIPL](https://www.swi-prolog.org/Download.html).
3. Navegue até a pasta "app" do projeto.
4. Execute o comando "swipl".
5. Execute o comando "consult('main.pl').".
6. Execute o comando "main.".
