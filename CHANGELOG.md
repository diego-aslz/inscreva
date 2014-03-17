
# CHANGELOG

## v1.18

1. Correção de erro crítico: usuário não autenticado com permissão para ler e alterar eventos;
2. Testes com Poltergeist;
3. Pequenas correções e melhorias de layout.

## v1.17

1. Correção: Links do Devise saem de HTTPS para HTTP;
2. Correção: Campo do tipo 'select' na listagem de inscritos;
3. Ampliada cobertura de testes unitários;
4. Novos formatos possíveis para arquivos;
5. Funcionalidade: Usuários podem ter permissão de criar eventos. Um usuário
pode atualizar e gerenciar seus próprios eventos.

## v1.16

1. Correção: Campos personalizados adicionados após criação de inscrições não
sendo exibidos no formulário de alteração;
2. Pequenas melhorias gerais.

## v1.15

1. Melhoria: Twitter Bootstrap 3;
2. Correção: Carregamento incorreto de e-mails ao abrir formulário de
notificação de usuários;
3. Pequenas melhorias e correções.

## v1.14

1. Funcionalidade: Envio de e-mails para candidatos;
2. Funcionalidade: Inclusão de campos fixos na busca de inscritos;
3. Pequenas correções.

## v1.13

1. Correção: Token incorreto enviado ao e-mail do usuário para redefinição de senha;
2. Correção: Compilação de imagens para plugin `chosen` e `markitup`.

## v1.12

1. Correção: Impossível definir tipos de arquivos permitidos para campo personalizado;
3. Pequenas melhorias de layout.

## v1.11

1. Correção: Alteração de evento duplica campos e delegações.

## v1.10

1. Migração para Rails 4.

## v1.02

1. Delegação de usuários para eventos com `autocomplete`;
2. Correção: Criação de eventos com usuários não funcionava;
3. Contagem de inscrições na busca avançada.

## v1.01

1. Melhorias de exibição. Abreviação de textos extensos;
2. Personalização de tamanho máximo de anexo em campo personalizado do tipo `Arquivo`;
3. Validação do tamanho da senha na inscrição.

## v1.00

1. Primeira versão funcional;
2. Gestão de eventos com campos personalizados e períodos de inscrição;
3. Gestão de páginas de divulgação de informações de eventos;
4. Consulta avançada de inscrições com filtros por campos personalizados;
5. Cópia de campos entre eventos.
