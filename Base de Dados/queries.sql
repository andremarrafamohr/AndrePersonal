-- queries.sql

-- =========================================
-- Q1.1 - Lista de participantes cujo nome começa por 'A'
SELECT participant_id AS 'ID', name AS 'Nome'
FROM participant
WHERE name LIKE 'A%';

-- Q1.2 - Lista de participantes com código postal específico
SELECT participant_id AS 'ID', name AS 'Nome', postal_code AS 'Código Postal'
FROM participant
WHERE postal_code = '1000-001';

-- Q2.1 - Leilões em aberto
SELECT auction_id AS 'ID Leilão', locality AS 'Local', state_fk AS 'Abertura', final_date AS 'Encerramento'
FROM auction
WHERE state_fk = "Open";

-- Q2.2 - Sessões a decorrer hoje
SELECT session_id AS 'ID Sessão', session_date as 'Dia de abertura', start_session as 'Hora de abertura', end_session as 'Hora de Encerramento'
FROM session
WHERE CURDATE() = session_date AND CURRENT_TIME BETWEEN start_session AND end_session;

-- Q3.1 - Licitações superiores a 1000€
SELECT bidding_id AS 'ID Licitação', value AS 'Valor'
FROM bidding
WHERE value > 1000 order by value desc;

-- Q3.2 - Licitações por participante específico (ID=1)
SELECT bidding_id AS 'ID Licitação', value AS 'Valor'
FROM bidding
WHERE bidder_fk = 10;

-- Q3.3 - Licitações de um lote específico (ID=2)
SELECT bidding_id AS 'ID Licitação', value AS 'Valor'
FROM bidding
WHERE batch_fk = 2;

-- Q4.1 - Lista de relógios e os seus modelos
SELECT w.watch_id AS 'ID Relógio', m.designation AS 'Modelo', m.material
FROM watch w
JOIN model m ON w.model_fk = m.designation;

-- Q4.2 - Relógios vintage
SELECT w.watch_id AS 'ID Relógio', m.vintage
FROM watch w
JOIN model m ON w.model_fk = m.designation
WHERE m.vintage = TRUE;

-- Q5.1 - Estatísticas de lotes vendidos (por categoria)
SELECT 
       COUNT(*) AS 'Total Vendidos',			-- N sei oq é a categiria temos de ver isso 
       MIN(base_price) AS 'Preço Mínimo',
       MAX(base_price) AS 'Preço Máximo',
       ROUND(STDDEV(base_price), 2) AS 'Desvio Padrão'
FROM batch
WHERE state_fk = 'Sold'
GROUP BY batch_id;

-- Q5.2 - Estatísticas por organizador
SELECT o.organizer_id as ID, o.name as 'Organizador',
       COUNT(b.batch_id) AS 'Total Vendidos',
       ROUND(AVG(b.base_price), 2) AS 'Preço Médio'
FROM auction a
JOIN organizer o ON o.organizer_id = a.organizer_fk
JOIN session s ON s.auction_fk = a.auction_id
JOIN batch_session bs ON bs.session_id = s.session_id
JOIN batch b ON b.batch_id = bs.batch_id
WHERE b.state_fk = 'Sold'
GROUP BY o.organizer_id;

-- Q6 - Top 3 lotes mais valorizados
SELECT b.batch_id as 'ID', MAX(bd.value) AS 'Licitação mais alta'
FROM batch as b
JOIN bidding bd ON bd.batch_fk = b.batch_id
GROUP BY b.batch_id
ORDER BY 'Licitação mais alta' DESC
LIMIT 3;

-- Q7 - Participantes sem licitações
SELECT p.participant_id as 'ID', p.name as 'Nome'
FROM participant p
LEFT JOIN bidder b ON p.participant_id = b.participant_id
LEFT JOIN bidding bd ON b.participant_id = bd.bidder_fk
WHERE bd.bidding_id IS NULL;

-- Q8 - Participantes por leilão com licitações
SELECT a.auction_id as 'ID auction', p.participant_id as 'ID participant', p.name as 'Nome', b.value as 'Valor'
FROM bidding b
JOIN bidder bd ON b.bidder_fk = bd.participant_id
JOIN participant p ON p.participant_id = bd.participant_id
JOIN session s ON s.session_id = b.session_fk
JOIN auction a ON s.auction_fk = a.auction_id;

-- Q9 - Top 5 leilões com mais participantes nos últimos 3 anos
SELECT a.auction_id, YEAR(a.start_date) AS 'Ano', COUNT(DISTINCT b.bidder_fk) AS 'Nº Participantes'
FROM auction a
JOIN session s ON s.auction_fk = a.auction_id
JOIN bidding b ON b.session_fk = s.session_id
WHERE a.start_date >= DATE_SUB(CURDATE(), INTERVAL 3 YEAR)
GROUP BY a.auction_id, YEAR(a.start_date)
ORDER BY `Nº Participantes` DESC
LIMIT 5;

-- Q10 - Consulta com 3 tabelas: licitações por modelo de relógio
SELECT m.designation as 'Modelo', COUNT(b.bidding_id) as 'Total de licitações'
FROM bidding b
JOIN batch bt ON b.batch_fk = bt.batch_id
JOIN watch_batch wb ON bt.batch_id = wb.batch_id
JOIN watch w ON wb.watch_id = w.watch_id
JOIN model m ON w.model_fk = m.designation
GROUP BY m.designation;

-- Q11 - Lotes vendidos com mais de uma licitação
SELECT bt.batch_id, COUNT(*) AS total_licitacoes
FROM bidding b
JOIN batch bt ON b.batch_fk = bt.batch_id
WHERE bt.state_fk = 'Sold'
GROUP BY bt.batch_id
HAVING COUNT(*) > 1;

-- Q12 - Consulta usando relacionamento recursivo (exemplo genérico)
-- Vamos assumir que um participante pode representar outro (não implementado no SQL ainda)
-- SELECT p1.name AS 'Representante', p2.name AS 'Representado'
-- FROM participant p1
-- JOIN participant_relation r ON p1.participant_id = r.representante_id
-- JOIN participant p2 ON p2.participant_id = r.representado_id;

-- Q13.1 - Subquery: relógios com média de licitações acima de 500€
SELECT w.watch_id as 'ID', m.designation as 'Modelo'
FROM watch w
JOIN model m ON w.model_fk = m.designation
WHERE w.watch_id IN (
    SELECT wb.watch_id
    FROM watch_batch wb
    JOIN bidding b ON b.batch_fk = wb.batch_id
    GROUP BY wb.watch_id
    HAVING AVG(b.value) > 500
);

-- Q13.2 - Subquery com EXISTS: participantes que licitaram em leilões abertos
SELECT DISTINCT p.name as 'Nome'
FROM participant p
WHERE EXISTS (
    SELECT 1 FROM bidder bd
    JOIN bidding b ON b.bidder_fk = bd.participant_id
    JOIN session s ON s.session_id = b.session_fk
    JOIN auction a ON a.auction_id = s.auction_fk
    WHERE a.state_fk = 'Open' AND bd.participant_id = p.participant_id
);
