-- =========================================
-- TESTES ÀS TRIGGERS
-- =========================================

-- Inserir nova licitação (deve criar log)
INSERT INTO bidding (value, session_fk, batch_fk, bidder_fk) VALUES (9999.99, 1, 1, 10);
SELECT * FROM tbl_logs ORDER BY log_time DESC LIMIT 1;

-- Apagar licitação (deve criar log de remoção)
DELETE FROM bidding WHERE value = 9999.99 AND bidder_fk = 10;
SELECT * FROM tbl_logs ORDER BY log_time DESC LIMIT 1;