drop table alunos cascade constraint;
drop table usuarios cascade constraint;
drop sequence seq_alunos;
drop user admin cascade;

create table alunos (
    id_aluno   number(5)     constraint alunos_id_nn  not null,
    nome       varchar2(50)  constraint alunos_nome_nn not null,
    finalizado varchar2(1)   default 'N' constraint alunos_finalizado_nn not null
    );

alter table alunos
add constraint pk_alunos primary key (id_aluno);

alter table alunos
add constraint alunos_finalizado_ck
check (finalizado in ('S', 'N'));

create sequence seq_alunos
    start with 1
    increment by 1
    maxvalue 99999
    minvalue 1
;

create table usuarios (
    username varchar2(50) constraint usuarios_username_NN  not null,
    permissao varchar2(13) constraint usuarios_permissao_NN  not null
);

alter table usuarios
add constraint pk_usuarios primary key (username);

alter table usuarios
add constraint usuarios_username_ck
check (username in ('HR', 'ADMIN'));

alter table usuarios
add constraint usuarios_permissao_ck
check (permissao in ('C', 'A'));

insert into usuarios values ('HR', 'C');
insert into usuarios values ('ADMIN', 'A');

CREATE OR REPLACE TRIGGER ALUNOS_FINALIZADO_BUD 
BEFORE UPDATE OR DELETE ON ALUNOS
FOR EACH ROW
declare 
    v_permissao varchar2(1);
BEGIN
    if deleting then
        raise_application_error(-20000,'Não é possivel deletar os dados de um aluno Finalizado');
    else
        select  permissao into v_permissao from usuarios where upper(username) = upper(user);
        if v_permissao = 'C' and :old.finalizado = 'S' then
            raise_application_error(-20001,'Usuario comum não pode alterar os dados de um aluno Finalizado');
        end if;
    end if;
END;
/
create or replace TRIGGER COD_ALUNO 
BEFORE INSERT ON ALUNOS 
FOR EACH ROW
BEGIN
  :new.id_aluno := seq_alunos.nextval;
END;


-- USER SQL
CREATE USER "ADMIN" IDENTIFIED BY "123";
GRANT SELECT, UPDATE, INSERT, DELETE ON system.alunos to ADMIN;
GRANT CREATE SESSION TO "ADMIN";


CONNECT ADMIN/123@localhost:1521/xepdb1;
insert into system.alunos (nome) values ('Roberto');
insert into system.alunos (nome) values ('Cleitin');
update system.alunos set finalizado = 'S' 
where id_aluno  = 1;
delete system.alunos 
where id_aluno = 1;

commit;

