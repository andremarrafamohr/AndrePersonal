-- logic.sql

-- =========================================
-- VIEWS (mínimo 5)
-- =========================================
-- View 1: Leilões futuros (ainda não começaram)
CREATE OR REPLACE VIEW vw_future_auctions AS
SELECT auction_id as 'ID', start_date as 'Opening Date', final_date as 'Closing Date', locality as 'Local', state_fk as 'State'
FROM auction
WHERE start_date > CURDATE();

-- View 2: Lotes disponíveis num leilão
CREATE OR REPLACE VIEW vw_available_batches AS
SELECT b.batch_id as ID, b.base_price as 'Base Price', b.state_fk as 'State', a.auction_id as 'Auction ID'
FROM batch as b
JOIN session s ON s.session_id IN (
    SELECT session_id FROM batch_session WHERE batch_id = b.batch_id
)
JOIN auction a ON s.auction_fk = a.auction_id
WHERE b.state_fk = 'Selling';

-- View 3: Participantes e número de licitações
CREATE OR REPLACE VIEW vw_bidder_activity AS
SELECT p.participant_id as 'ID', p.name as 'Name', COUNT(b.bidding_id) AS 'Total Bids' 
FROM participant p
JOIN bidder bd ON p.participant_id = bd.participant_id
LEFT JOIN bidding b ON b.bidder_fk = bd.participant_id
GROUP BY p.participant_id;

-- View 4: Relógios valorizados por lote (máximo licitado por lote)
CREATE OR REPLACE VIEW vw_valued_batches AS
SELECT b.batch_id as 'ID', MAX(bd.value) AS 'Highest bid'
FROM batch b
JOIN bidding bd ON bd.batch_fk = b.batch_id
GROUP BY b.batch_id;

-- View 5: Relógios que nunca foram vendidos
CREATE OR REPLACE VIEW vw_unsold_batches AS
SELECT batch_id as 'ID', base_price 'Base Price'
FROM batch
WHERE state_fk = 'Not Sold';


-- =========================================
-- FUNCTIONS (mínimo 2)
-- =========================================

-- Function 1: Calcular nº de licitações de um lote
DELIMITER //
CREATE FUNCTION fn_total_bids_batch(batchId INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE total INT;
    SELECT COUNT(*) INTO total
    FROM bidding
    WHERE batch_fk = batchId;
    RETURN total;
END //
DELIMITER ;

-- Function 2: Calcular valorização média de um lote
DELIMITER //
CREATE FUNCTION fn_avg_bid_batch(batchId INT)
RETURNS DECIMAL(11,2)
DETERMINISTIC
BEGIN
    DECLARE avg_bid DECIMAL(11,2);
    SELECT AVG(value) INTO avg_bid
    FROM bidding
    WHERE batch_fk = batchId;
    RETURN avg_bid;
END //
DELIMITER ;

-- =========================================
-- STORED PROCEDURES (mínimo 5)
-- =========================================

-- SP1: Criar novo leilão
DELIMITER $$

CREATE PROCEDURE create_organizer (
    IN o_name VARCHAR(50),
    IN o_adress VARCHAR(100),
    IN o_contact VARCHAR(100)
)
BEGIN
    INSERT INTO organizer (name, adress, contact)
    VALUES (o_name, o_adress, o_contact);
END$$

DELIMITER ;


-- SP2: Adicionar participante
DELIMITER $$

CREATE PROCEDURE create_participant (
    IN p_name VARCHAR(100),
    IN p_street VARCHAR(100),
    IN p_locality VARCHAR(100),
    IN p_postal_code VARCHAR(20),
    IN p_cc_number VARCHAR(20),
    IN p_recommends_id INT
)
BEGIN
    INSERT INTO participant (name, street, locality, postal_code, cc_number, recommends_id)
    VALUES (p_name, p_street, p_locality, p_postal_code, p_cc_number, p_recommends_id);
END$$

DELIMITER ;


-- SP3: Registar resultado (alterar estado do lote para 'Vendido')
DELIMITER //
CREATE PROCEDURE sp_register_result (
    IN p_batch_id INT
)
BEGIN
    UPDATE batch
    SET state_fk = 'Sold'
    WHERE batch_id = p_batch_id;
END //
DELIMITER ;

-- SP4: 
DELIMITER //

CREATE PROCEDURE add_watch (
    IN p_fabrication_year INT,
    IN p_is_new BOOLEAN,
    IN p_model_designation VARCHAR(100),
    IN p_color VARCHAR(50),
    IN p_material VARCHAR(50),
    IN p_special_edition BOOLEAN,
    IN p_vintage BOOLEAN,
    IN p_brand_name VARCHAR(50),
    IN p_participant_fk INT -- can be NULL
)
BEGIN
    -- Insert the brand if it does not exist
    IF NOT EXISTS (
        SELECT 1 FROM brand WHERE name = p_brand_name
    ) THEN
        INSERT INTO brand(name) VALUES (p_brand_name);
    END IF;

    -- Insert the model if it does not exist
    IF NOT EXISTS (
        SELECT 1 FROM model WHERE designasion = p_model_designation
    ) THEN
        INSERT INTO model (
            designasion, color, material, special_edition, vintage, brand_fk
        ) VALUES (
            p_model_designation, p_color, p_material, p_special_edition, p_vintage, p_brand_name
        );
    END IF;

    -- Validate participant if provided
    IF p_participant_fk IS NOT NULL AND NOT EXISTS (
        SELECT 1 FROM participant WHERE participant_id = p_participant_fk
    ) THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Participant not found.';
    END IF;

    -- Insert the watch
    INSERT INTO watch (
        fabrication_year, is_new, model_fk, participant_fk
    ) VALUES (
        p_fabrication_year, p_is_new, p_model_designation, p_participant_fk
    );
END //

DELIMITER ;

-- =========================================
-- TRIGGERS (mínimo 2)
-- =========================================

-- Trigger 1: Log de resultados registados
DROP TABLE IF EXISTS tbl_logs;
CREATE TABLE tbl_logs (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    log_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    participant_id INT,
    auction_id INT,
    value DECIMAL(11,2)
);

DELIMITER //
CREATE TRIGGER trg_result_insert
AFTER INSERT ON bidding
FOR EACH ROW
BEGIN
    DECLARE auct_id INT;
    SELECT auction_fk INTO auct_id
    FROM session
    WHERE session_id = NEW.session_fk;

    INSERT INTO tbl_logs (participant_id, auction_id, value)
    VALUES (NEW.bidder_fk, auct_id, NEW.value);
END //
DELIMITER ;

-- Trigger 2: Log de resultados apagados
DELIMITER //
CREATE TRIGGER trg_result_delete
AFTER DELETE ON bidding
FOR EACH ROW
BEGIN
    DECLARE auct_id INT;
    SELECT auction_fk INTO auct_id
    FROM session
    WHERE session_id = OLD.session_fk;
    
    INSERT INTO tbl_logs (participant_id, auction_id, value)
    VALUES (OLD.bidder_fk, auct_id, OLD.value);
END //
DELIMITER ;
