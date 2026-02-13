-- test.sql

-- =========================================
-- TESTES ÀS VIEWS
-- =========================================
use proj;
-- Teste à view de leilões futuros
SELECT * FROM vw_future_auctions;

-- Teste à view de lotes disponíveis
SELECT * FROM vw_available_batches;

-- Teste à view de atividade dos licitadores
SELECT * FROM vw_bidder_activity;

-- Teste à view de valorização dos lotes
SELECT * FROM vw_valued_batches;

-- Teste à view de lotes não vendidos
SELECT * FROM vw_unsold_batches;


-- =========================================
-- TESTES ÀS FUNCTIONS
-- =========================================

-- Total de licitações num lote
SELECT fn_total_bids_batch(1) AS total_bids_lote_1;

-- Média de licitações num lote
SELECT fn_avg_bid_batch(1) AS avg_bid_lote_1;


-- =========================================
-- TESTES ÀS PROCEDURES
-- =========================================

-- Criar novo leilão
CALL sp_criar_leilao('2025-12-01', '2025-12-05', 'Funchal', 'Close', 1, 'Leilão de Natal');
SELECT * FROM auction WHERE locality = 'Funchal';

-- Adicionar novo participante
CALL create_participant('José Teste', 'Rua Nova', 'Porto', '4000-001', '123456789', NULL);
SELECT * FROM participant WHERE name = 'José Teste';

-- Registar resultado de um lote
CALL sp_register_result(3);
SELECT batch_id, state_fk FROM batch WHERE batch_id = 3;

-- Clonar leilão existente
CALL sp_clonar_leilao(1);
SELECT * FROM auction WHERE auction_description LIKE '%--- COPIA (a preencher)';

-- Remover leilão (sem força)
CALL sp_remover_leilao(999, FALSE); -- Espera erro se não existir

-- Remover leilão (com força, exemplo hipotético)
-- CALL sp_remove_auction(3, TRUE);
-- SELECT * FROM auction WHERE auction_id = 3;



