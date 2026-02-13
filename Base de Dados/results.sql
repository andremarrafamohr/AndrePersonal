-- SP1
-- create a new auction that is not dated before the current date
DELIMITER $$

CREATE PROCEDURE sp_criar_leilao (IN p_start_date DATE, IN p_final_date DATE, IN p_locality VARCHAR(100), IN p_state_fk VARCHAR(50), IN p_organizer_fk INT, IN p_auction_description VARCHAR(200))
BEGIN
    IF p_start_date < CURDATE() THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Start data cannot be earlier than current data.';
    ELSE
        INSERT INTO auction(start_date, final_date, locality, state_fk, organizer_fk, auction_description)
        VALUES (p_start_date, p_final_date, p_locality, p_state_fk, p_organizer_fk, p_auction_description);
    END IF;
END $$

DELIMITER ;

-- SP2
-- add participant to an auction, verify if the auction exists, verify if the participant exits and if he is already a participant of that auction.
DELIMITER $$

CREATE PROCEDURE sp_adicionar_participante(IN p_auction_id INT, IN p_participant_id INT)
BEGIN
    IF NOT EXISTS (SELECT 1 FROM auction WHERE auction_id = p_auction_id) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Auction does not exists.';
    END IF;
    IF NOT EXISTS (SELECT 1 FROM participant WHERE participant_id = p_participant_id) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Participant does not exists.';
    END IF;
    IF EXISTS (
        SELECT 1 FROM participant_auction 
        WHERE participant_id = p_participant_id AND auction_id = p_auction_id
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Participant already in the auction.';
    END IF;
    INSERT INTO participant_auction (participant_id, auction_id)
    VALUES (p_participant_id, p_auction_id);
END $$

DELIMITER ;

-- SP3
-- Check if auction has ended and return the participant ID, name, and highest bid value
DELIMITER //
CREATE PROCEDURE sp_resultado (IN p_id_leilao INT)
BEGIN
    DECLARE v_final_date DATE;
    DECLARE v_participant_id INT;
    DECLARE v_participant_name VARCHAR(100);
    DECLARE v_highest_bid DECIMAL(11,2);
    -- Check if auction exists
    IF NOT EXISTS (SELECT 1 FROM auction WHERE auction_id = p_id_leilao) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Auction not found.';
    END IF;
    -- Get final date of the auction
    SELECT final_date INTO v_final_date
    FROM auction
    WHERE auction_id = p_id_leilao;
    -- Check if auction has ended
    IF v_final_date IS NULL OR v_final_date > CURRENT_DATE THEN
        SELECT 'Auction has not ended yet.' AS message;
    ELSE
        -- Get highest bid info
        SELECT b.bidder_fk, p.name, b.value
        INTO v_participant_id, v_participant_name, v_highest_bid
        FROM bidding b
        JOIN session s ON b.session_fk = s.session_id
        JOIN participant p ON p.participant_id = b.bidder_fk
        WHERE s.auction_fk = p_id_leilao
        ORDER BY b.value DESC
        LIMIT 1;
        -- If no bids found
        IF v_participant_id IS NULL THEN
            SELECT 'Auction has ended but no bids were found.' AS message;
        ELSE
            SELECT CONCAT('Auction ended. Winner ID: ', v_participant_id, ', Name: ', v_participant_name, ', Bid: €', v_highest_bid) AS message;
        END IF;
    END IF;
END //

DELIMITER ;



-- SP4
-- remove auction, verify if the auction exists, verify dependencies, if they exists and Force = False dont Error, if Force = true force remove.
DELIMITER $$
CREATE PROCEDURE sp_remover_leilao(IN p_auction_id INT, IN p_force BOOLEAN)
BEGIN
    IF NOT EXISTS (SELECT 1 FROM auction WHERE auction_id = p_auction_id) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Auction does not exists.';
    END IF;
    SET @tem_resultados := (SELECT COUNT(*) FROM leilao_resultado WHERE auction_id = p_auction_id);
    SET @tem_participantes := (SELECT COUNT(*) FROM participant_auction WHERE auction_id = p_auction_id);
	SET @tem_sessoes := (SELECT COUNT(*) FROM session WHERE auction_fk = p_auction_id);
    IF ( @tem_resultados > 0 OR @tem_participantes > 0 OR @tem_sessoes > 0 ) AND NOT p_force THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Auction has data associated. Use force = TRUE to force remove.';
    END IF;
    DELETE FROM bidding 
    WHERE session_fk IN (SELECT session_id FROM session WHERE auction_fk = p_auction_id);
    DELETE FROM batch_session 
    WHERE session_id IN (SELECT session_id FROM session WHERE auction_fk = p_auction_id);
    DELETE FROM session 
    WHERE auction_fk = p_auction_id;
    DELETE FROM participant_auction WHERE auction_id = p_auction_id;
    DELETE FROM leilao_resultado WHERE auction_id = p_auction_id;
    DELETE FROM auction WHERE auction_id = p_auction_id;
END $$

DELIMITER ;

-- SP5
-- Clone an existing auction and create a copy with "--- COPIA (a preencher)" appended to the description
DELIMITER //

CREATE PROCEDURE sp_clonar_leilao (IN p_id_leilao INT)
BEGIN
    DECLARE v_start_date DATE;
    DECLARE v_final_date DATE;
    DECLARE v_locality VARCHAR(100);
    DECLARE v_description VARCHAR(200);
    DECLARE v_state_fk VARCHAR(50);
    DECLARE v_organizer_fk INT;
    DECLARE v_new_auction_id INT;
    -- Check if the auction exists
    IF NOT EXISTS (SELECT 1 FROM auction WHERE auction_id = p_id_leilao) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Auction not found.';
    END IF;
    -- Get original auction data
    SELECT start_date, final_date, locality, auction_description, state_fk, organizer_fk
    INTO v_start_date, v_final_date, v_locality, v_description, v_state_fk, v_organizer_fk
    FROM auction WHERE auction_id = p_id_leilao;
    -- Append the copy suffix to the description
    IF v_description IS NULL THEN
        SET v_description = ' --- COPIA (a preencher)';
    ELSE
        SET v_description = CONCAT(v_description, ' --- COPIA (a preencher)');
    END IF;
    -- Insert the cloned auction
    INSERT INTO auction (start_date, final_date, locality, auction_description, state_fk, organizer_fk) 
    VALUES (v_start_date, v_final_date, v_locality, v_description, v_state_fk, v_organizer_fk);
    -- Optionally return the new auction ID
    SET v_new_auction_id = LAST_INSERT_ID();
    SELECT v_new_auction_id AS new_auction_id;
END //

DELIMITER ;





