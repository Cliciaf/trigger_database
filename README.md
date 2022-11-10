
# Atividade de trigger - Banco de dados ||

Problemar: Criar 2 trigger:
1.  trigger adiciona +1 no id_aluno
2. Verifica se a permissão do usuario for "comum" e o status do aluno for "finalizado", ele não pode atualizar.
E se o usuario tem a permissao "adm", ele não pode deleter o aluno que estiver com o status "finalizado".

Nesse caso, o usuario com a permissao de "adm" tentou deletar o aluno finalizado e o banco não permite. 