-- ==========================================
-- 0. REMOÇÃO DE TABELAS EXISTENTES (CASO NECESSÁRIO)
-- ==========================================
DROP TABLE IF EXISTS turma_disciplina_professor CASCADE;
DROP TABLE IF EXISTS aluno_responsavel CASCADE;
DROP TABLE IF EXISTS historico_presenca CASCADE;
DROP TABLE IF EXISTS matricula CASCADE;
DROP TABLE IF EXISTS aluno CASCADE;
DROP TABLE IF EXISTS turma CASCADE;
DROP TABLE IF EXISTS professor CASCADE;
DROP TABLE IF EXISTS responsavel CASCADE;
DROP TABLE IF EXISTS disciplina CASCADE;
DROP TABLE IF EXISTS escola CASCADE;

-- ==========================================
-- 1. TABELA: escola
-- ==========================================
CREATE TABLE escola (
    id_escola SERIAL PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    endereco VARCHAR(255) NOT NULL,
    cnpj VARCHAR(18),
    telefone VARCHAR(20),

    CONSTRAINT uq_escola_cnpj UNIQUE (cnpj)
);

-- ==========================================
-- 2. TABELA: disciplina
-- ==========================================
CREATE TABLE disciplina (
    id_disciplina SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    carga_horaria INT NOT NULL
);

-- ==========================================
-- 3. TABELA: responsavel
-- ==========================================
CREATE TABLE responsavel (
    id_responsavel SERIAL PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    cpf VARCHAR(14) NOT NULL,
    telefone VARCHAR(20) NOT NULL,
    email VARCHAR(255),

    CONSTRAINT uq_responsavel_cpf UNIQUE (cpf)
);

-- ==========================================
-- 4. TABELA: professor
-- ==========================================
CREATE TABLE professor (
    id_professor SERIAL PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    cpf VARCHAR(14) NOT NULL,
    data_nascimento DATE,
    email VARCHAR(255),
    fk_escola INT NOT NULL,

    CONSTRAINT uq_professor_cpf UNIQUE (cpf),
    CONSTRAINT uq_professor_email UNIQUE (email),
    CONSTRAINT fk_professor_escola FOREIGN KEY (fk_escola) REFERENCES escola(id_escola) ON DELETE CASCADE
);

-- ==========================================
-- 5. TABELA: turma
-- ==========================================
CREATE TABLE turma (
    id_turma SERIAL PRIMARY KEY,
    serie VARCHAR(100) NOT NULL,
    quantidade_aluno INT,
    chamada INT,
    ano_letivo INT NOT NULL,
    fk_escola INT NOT NULL,

    CONSTRAINT fk_turma_escola FOREIGN KEY (fk_escola) REFERENCES escola(id_escola) ON DELETE CASCADE
);

-- ==========================================
-- 6. TABELA: aluno
-- ==========================================
CREATE TABLE aluno (
    id_aluno SERIAL PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    cpf VARCHAR(14) NOT NULL,
    data_nascimento DATE NOT NULL,
    link_foto VARCHAR(255),
    fk_turma INT NOT NULL,

    CONSTRAINT uq_aluno_cpf UNIQUE (cpf),
    CONSTRAINT fk_aluno_turma FOREIGN KEY (fk_turma) REFERENCES turma(id_turma) ON DELETE CASCADE
);

-- ==========================================
-- 7. TABELA: matricula
-- ==========================================
CREATE TABLE matricula (
    id_matricula SERIAL PRIMARY KEY,
    numero_matricula VARCHAR(50) NOT NULL,
    cpf VARCHAR(14) NOT NULL,
    nome VARCHAR(255) NOT NULL,
    comprovante_residencia VARCHAR(255),
    data_matricula TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(50),
    fk_aluno INT NOT NULL,

    CONSTRAINT uq_matricula_numero_matricula UNIQUE (numero_matricula),
    CONSTRAINT uq_matricula_aluno UNIQUE (fk_aluno),
    CONSTRAINT fk_matricula_aluno FOREIGN KEY (fk_aluno) REFERENCES aluno(id_aluno) ON DELETE CASCADE
);

-- ==========================================
-- 8. TABELA: historico_presenca
-- ==========================================
CREATE TABLE historico_presenca (
    id_historico_presenca SERIAL PRIMARY KEY,
    data DATE NOT NULL,
    hora_entrada TIME,
    hora_saida TIME,
    entrada_aluno TIMESTAMP,
    saida_aluno TIMESTAMP,
    status_presenca VARCHAR(20),
    fk_aluno INT NOT NULL,

    CONSTRAINT fk_historico_presenca_aluno FOREIGN KEY (fk_aluno) REFERENCES aluno(id_aluno) ON DELETE CASCADE
);

-- ==========================================
-- 9. TABELA: aluno_responsavel
-- ==========================================
CREATE TABLE aluno_responsavel (
    fk_aluno INT NOT NULL,
    fk_responsavel INT NOT NULL,
    parentesco VARCHAR(50) NOT NULL,

    CONSTRAINT pk_aluno_responsavel PRIMARY KEY (fk_aluno, fk_responsavel),
    CONSTRAINT fk_aluno_responsavel_aluno FOREIGN KEY (fk_aluno) REFERENCES aluno(id_aluno) ON DELETE CASCADE,
    CONSTRAINT fk_aluno_responsavel_responsavel FOREIGN KEY (fk_responsavel) REFERENCES responsavel(id_responsavel) ON DELETE CASCADE
);

-- ==========================================
-- 10. TABELA: turma_disciplina_professor
-- ==========================================
CREATE TABLE turma_disciplina_professor (
    fk_turma INT NOT NULL,
    fk_disciplina INT NOT NULL,
    fk_professor INT NOT NULL,

    CONSTRAINT pk_turma_disciplina_professor PRIMARY KEY (fk_turma, fk_disciplina, fk_professor),
    CONSTRAINT fk_turma_disciplina_professor_turma FOREIGN KEY (fk_turma) REFERENCES turma(id_turma) ON DELETE CASCADE,
    CONSTRAINT fk_turma_disciplina_professor_disciplina FOREIGN KEY (fk_disciplina) REFERENCES disciplina(id_disciplina) ON DELETE CASCADE,
    CONSTRAINT fk_turma_disciplina_professor_professor FOREIGN KEY (fk_professor) REFERENCES professor(id_professor) ON DELETE CASCADE
);


-- ==========================================
-- SCRIPT DE INSERÇÃO DIDÁTICA (DADOS REALISTAS)
-- ==========================================

-- 1. ESCOLA
INSERT INTO escola (nome, endereco, cnpj, telefone) VALUES
('Escola Estadual Horizonte do Saber', 'Rua XV de Novembro, 850 - Centro, Curitiba - PR', '12.345.678/0001-01', '(41) 3322-1010'),
('Colégio Municipal Araucária', 'Avenida República Argentina, 1420 - Água Verde, Curitiba - PR', '23.456.789/0001-02', '(41) 3344-2020'),
('Instituto Educacional Pequeno Príncipe', 'Rua Augusto Stresser, 510 - Juvevê, Curitiba - PR', '34.567.890/0001-03', '(41) 3252-3030'),
('Centro Educacional Santa Felicidade', 'Avenida Manoel Ribas, 4100 - Santa Felicidade, Curitiba - PR', '45.678.901/0001-04', '(41) 3372-4040'),
('Colégio Estadual Paraná', 'Avenida João Gualberto, 250 - Alto da Glória, Curitiba - PR', '56.789.012/0001-05', '(41) 3232-5050'),
('Escola Municipal Jardim das Américas', 'Rua Coronel Francisco Heráclito dos Santos, 900 - Jardim das Américas, Curitiba - PR', '67.890.123/0001-06', '(41) 3366-6060'),
('Colégio Técnico Industrial Sul', 'Avenida Presidente Kennedy, 3200 - Portão, Curitiba - PR', '78.901.234/0001-07', '(41) 3311-7070'),
('Escola Integrada Boqueirão', 'Rua Marechal Floriano Peixoto, 6500 - Boqueirão, Curitiba - PR', '89.012.345/0001-08', '(41) 3276-8080'),
('Instituto de Ensino Batel', 'Avenida do Batel, 1600 - Batel, Curitiba - PR', '90.123.456/0001-09', '(41) 3242-9090'),
('Escola Comunitária Cabral', 'Avenida Paraná, 1950 - Cabral, Curitiba - PR', '01.234.567/0001-10', '(41) 3254-0010');

-- 2. DISCIPLINA
INSERT INTO disciplina (nome, carga_horaria) VALUES
('Matemática', 160),
('Língua Portuguesa', 160),
('História', 80),
('Geografia', 80),
('Ciências da Natureza', 120),
('Física', 80),
('Química', 80),
('Biologia', 80),
('Língua Inglesa', 80),
('Educação Física', 80);

-- 3. RESPONSAVEL
INSERT INTO responsavel (nome, cpf, telefone, email) VALUES
('Mariana Souza Oliveira', '111.222.333-01', '(41) 99111-0001', 'mariana.oliveira@email.com'),
('Ricardo Almeida Santos', '222.333.444-02', '(41) 99222-0002', 'ricardo.santos@email.com'),
('Patrícia Lima Costa', '333.444.555-03', '(41) 99333-0003', 'patricia.costa@email.com'),
('Fernando Pereira Silva', '444.555.666-04', '(41) 99444-0004', 'fernando.silva@email.com'),
('Camila Rocha Martins', '555.666.777-05', '(41) 99555-0005', 'camila.martins@email.com'),
('Gustavo Mendes Ferreira', '666.777.888-06', '(41) 99666-0006', 'gustavo.ferreira@email.com'),
('Luciana Alves Nogueira', '777.888.999-07', '(41) 99777-0007', 'luciana.nogueira@email.com'),
('Roberto Castro Dias', '888.999.000-08', '(41) 99888-0008', 'roberto.dias@email.com'),
('Tatiane Ribeiro Gomes', '999.000.111-09', '(41) 99999-0009', 'tatiane.gomes@email.com'),
('André Barbosa Lima', '000.111.222-10', '(41) 99000-0010', 'andre.lima@email.com');

-- 4. PROFESSOR
INSERT INTO professor (nome, cpf, data_nascimento, email, fk_escola) VALUES
('Prof. Carlos Eduardo Silva', '101.202.303-11', '1980-05-14', 'carlos.silva@escola.edu.br', 1),
('Profa. Beatriz Helena Lima', '202.303.404-22', '1985-08-22', 'beatriz.lima@escola.edu.br', 1),
('Prof. Daniel Augusto Rocha', '303.404.505-33', '1978-11-03', 'daniel.rocha@escola.edu.br', 2),
('Profa. Elena Cristina Souza', '404.505.606-44', '1990-02-19', 'elena.souza@escola.edu.br', 2),
('Prof. Felipe Henrique Costa', '505.606.707-55', '1983-07-30', 'felipe.costa@escola.edu.br', 3),
('Profa. Gabriela Martins Alves', '606.707.808-66', '1988-09-12', 'gabriela.alves@escola.edu.br', 4),
('Prof. Hugo Leonardo Pereira', '707.808.909-77', '1982-04-25', 'hugo.pereira@escola.edu.br', 5),
('Profa. Isabela Fernanda Dias', '808.909.010-88', '1992-12-08', 'isabela.dias@escola.edu.br', 6),
('Prof. João Marcelo Santos', '909.010.121-99', '1975-06-17', 'joao.santos@escola.edu.br', 7),
('Profa. Larissa Vitória Gomes', '010.121.232-00', '1989-10-29', 'larissa.gomes@escola.edu.br', 8);

-- 5. TURMA
INSERT INTO turma (serie, quantidade_aluno, chamada, ano_letivo, fk_escola) VALUES
('1º Ano Ensino Médio - A', 32, 1, 2026, 1),
('2º Ano Ensino Médio - B', 30, 2, 2026, 1),
('9º Ano Ensino Fundamental - A', 28, 1, 2026, 2),
('8º Ano Ensino Fundamental - B', 29, 2, 2026, 2),
('5º Ano Ensino Fundamental - A', 25, 1, 2026, 3),
('3º Ano Ensino Médio - A', 35, 1, 2026, 4),
('7º Ano Ensino Fundamental - A', 27, 1, 2026, 5),
('6º Ano Ensino Fundamental - B', 26, 2, 2026, 6),
('1º Ano Ensino Médio - C', 31, 3, 2026, 7),
('2º Ano Ensino Médio - A', 33, 1, 2026, 8);

-- 6. ALUNO
INSERT INTO aluno (nome, cpf, data_nascimento, link_foto, fk_turma) VALUES
('Lucas Souza Oliveira', '123.456.789-01', '2010-03-15', 'https://cdn.hpf.edu.br/fotos/aluno_01.jpg', 1),
('Sofia Almeida Santos', '234.567.890-02', '2009-07-22', 'https://cdn.hpf.edu.br/fotos/aluno_02.jpg', 2),
('Gabriel Lima Costa', '345.678.901-03', '2011-11-05', 'https://cdn.hpf.edu.br/fotos/aluno_03.jpg', 3),
('Manuela Pereira Silva', '456.789.012-04', '2012-01-18', 'https://cdn.hpf.edu.br/fotos/aluno_04.jpg', 4),
('Pedro Rocha Martins', '567.890.123-05', '2015-05-30', 'https://cdn.hpf.edu.br/fotos/aluno_05.jpg', 5),
('Laura Mendes Ferreira', '678.901.234-06', '2008-09-10', 'https://cdn.hpf.edu.br/fotos/aluno_06.jpg', 6),
('Matheus Alves Nogueira', '789.012.345-07', '2013-04-27', 'https://cdn.hpf.edu.br/fotos/aluno_07.jpg', 7),
('Helena Castro Dias', '890.123.456-08', '2014-08-14', 'https://cdn.hpf.edu.br/fotos/aluno_08.jpg', 8),
('Enzo Ribeiro Gomes', '901.234.567-09', '2010-12-02', 'https://cdn.hpf.edu.br/fotos/aluno_09.jpg', 9),
('Valentina Barbosa Lima', '012.345.678-10', '2009-06-19', 'https://cdn.hpf.edu.br/fotos/aluno_10.jpg', 10);

-- 7. MATRICULA
INSERT INTO matricula (numero_matricula, cpf, nome, comprovante_residencia, status, fk_aluno) VALUES
('MAT-2026-0001', '123.456.789-01', 'Lucas Souza Oliveira', 'https://cdn.hpf.edu.br/docs/comp_01.pdf', 'ATIVA', 1),
('MAT-2026-0002', '234.567.890-02', 'Sofia Almeida Santos', 'https://cdn.hpf.edu.br/docs/comp_02.pdf', 'ATIVA', 2),
('MAT-2026-0003', '345.678.901-03', 'Gabriel Lima Costa', 'https://cdn.hpf.edu.br/docs/comp_03.pdf', 'ATIVA', 3),
('MAT-2026-0004', '456.789.012-04', 'Manuela Pereira Silva', 'https://cdn.hpf.edu.br/docs/comp_04.pdf', 'ATIVA', 4),
('MAT-2026-0005', '567.890.123-05', 'Pedro Rocha Martins', 'https://cdn.hpf.edu.br/docs/comp_05.pdf', 'ATIVA', 5),
('MAT-2026-0006', '678.901.234-06', 'Laura Mendes Ferreira', 'https://cdn.hpf.edu.br/docs/comp_06.pdf', 'ATIVA', 6),
('MAT-2026-0007', '789.012.345-07', 'Matheus Alves Nogueira', 'https://cdn.hpf.edu.br/docs/comp_07.pdf', 'PENDENTE', 7),
('MAT-2026-0008', '890.123.456-08', 'Helena Castro Dias', 'https://cdn.hpf.edu.br/docs/comp_08.pdf', 'ATIVA', 8),
('MAT-2026-0009', '901.234.567-09', 'Enzo Ribeiro Gomes', 'https://cdn.hpf.edu.br/docs/comp_09.pdf', 'ATIVA', 9),
('MAT-2026-0010', '012.345.678-10', 'Valentina Barbosa Lima', 'https://cdn.hpf.edu.br/docs/comp_10.pdf', 'ATIVA', 10);

-- 8. HISTORICO_PRESENCA
INSERT INTO historico_presenca (data, hora_entrada, hora_saida, entrada_aluno, saida_aluno, status_presenca, fk_aluno) VALUES
(CURRENT_DATE, '07:25:00', '12:00:00', CURRENT_TIMESTAMP - INTERVAL '4 hours', CURRENT_TIMESTAMP, 'PRESENTE', 1),
(CURRENT_DATE, '07:28:00', '12:00:00', CURRENT_TIMESTAMP - INTERVAL '4 hours', CURRENT_TIMESTAMP, 'PRESENTE', 2),
(CURRENT_DATE, '07:45:00', '12:00:00', CURRENT_TIMESTAMP - INTERVAL '3 hours 40 minutes', CURRENT_TIMESTAMP, 'ATRASO', 3),
(CURRENT_DATE, NULL, NULL, NULL, NULL, 'FALTA', 4),
(CURRENT_DATE, '13:00:00', '17:30:00', CURRENT_TIMESTAMP - INTERVAL '4 hours 30 minutes', CURRENT_TIMESTAMP, 'PRESENTE', 5),
(CURRENT_DATE, '07:20:00', '12:00:00', CURRENT_TIMESTAMP - INTERVAL '4 hours', CURRENT_TIMESTAMP, 'PRESENTE', 6),
(CURRENT_DATE, '07:30:00', '10:15:00', CURRENT_TIMESTAMP - INTERVAL '4 hours', CURRENT_TIMESTAMP - INTERVAL '1 hour 45 minutes', 'SAIDA_ANTECIPADA', 7),
(CURRENT_DATE, '13:05:00', '17:30:00', CURRENT_TIMESTAMP - INTERVAL '4 hours 25 minutes', CURRENT_TIMESTAMP, 'PRESENTE', 8),
(CURRENT_DATE, NULL, NULL, NULL, NULL, 'FALTA_JUSTIFICADA', 9),
(CURRENT_DATE, '07:22:00', '12:00:00', CURRENT_TIMESTAMP - INTERVAL '4 hours', CURRENT_TIMESTAMP, 'PRESENTE', 10);

-- 9. ALUNO_RESPONSAVEL
INSERT INTO aluno_responsavel (fk_aluno, fk_responsavel, parentesco) VALUES
(1, 1, 'Mãe'),
(2, 2, 'Pai'),
(3, 3, 'Mãe'),
(4, 4, 'Pai'),
(5, 5, 'Mãe'),
(6, 6, 'Pai'),
(7, 7, 'Mãe'),
(8, 8, 'Pai'),
(9, 9, 'Mãe'),
(10, 10, 'Pai');

-- 10. TURMA_DISCIPLINA_PROFESSOR
INSERT INTO turma_disciplina_professor (fk_turma, fk_disciplina, fk_professor) VALUES
(1, 1, 1),
(1, 2, 2),
(2, 1, 1),
(2, 2, 2),
(3, 3, 3),
(4, 4, 4),
(5, 5, 5),
(6, 6, 6),
(7, 7, 7),
(8, 8, 8);


-- ==========================================
-- 11. CONSULTAS DE VALIDAÇÃO (TESTE RÁPIDO)
-- ==========================================

-- 1. Testar tabela escola
SELECT * FROM escola;

-- 2. Testar tabela disciplina
SELECT * FROM disciplina;

-- 3. Testar tabela responsavel
SELECT * FROM responsavel;

-- 4. Testar tabela professor
SELECT * FROM professor;

-- 5. Testar tabela turma
SELECT * FROM turma;

-- 6. Testar tabela aluno
SELECT * FROM aluno;

-- 7. Testar tabela matricula
SELECT * FROM matricula;

-- 8. Testar tabela historico_presenca
SELECT * FROM historico_presenca;

-- 9. Testar tabela aluno_responsavel
SELECT * FROM aluno_responsavel;

-- 10. Testar tabela turma_disciplina_professor
SELECT * FROM turma_disciplina_professor;

-- Questão 2 

SELECT nome, telefone
FROM (
    SELECT id_escola, nome, telefone
    FROM escola
    ORDER BY id_escola ASC
    LIMIT 4
) AS primeiras_escolas
ORDER BY nome ASC;

