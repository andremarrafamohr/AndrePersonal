-- MARCAS
INSERT INTO brand (name) VALUES ('Rolex'), ('Omega'), ('Teste'), ('Casio'), ('Patek Philippe'), ('Cartier'), ('Franck Muller'), ('Watch Watching'), ('Hour Teller'), ('OClock'), 
('Time Teller'), ('Time Machine'), ('Im Late'), ('Dinner Time'), ('Audemars Piguet'), ('Blancpain'), ('Hublot'), ('Glashütte Original'), ('SwissBrand'), ('NOW');

-- CONTACTOS
INSERT INTO contacts (email, phone, site, brand_fk) VALUES
('info@rolex.com', '+41223456789', 'https://www.rolex.com', 'Rolex'), ('help7casio@time.com', NULL, NULL, 'Casio'),
(NULL, '+351912345678', NULL, 'Rolex'), ('patekphilippe@geral.ch', '+410523192544', 'https://www.patekphilippe.com', 'Patek Philippe'),
('contact@omega.com', '+41229876543', 'https://www.omegawatches.com', 'Omega'), ('casio@time.com', '+609999', 'https://www.casio.com,', 'Casio'),
('support@teste.com', NULL, 'https://www.teste.com', 'Teste'), ('cartier@time.com', '+8998199', 'https://www.cartier.com,', 'Cartier'), 
('frankmuller@time.com', '+24177789', 'https://www.frank&muller.com,', 'Franck Muller'), ('watch@time.com', '+7812345567', 'https://www.watch.com,', 'Watch Watching'),
('hour@time.com', '+1235555', 'https://www.hour.com,', 'Hour Teller'), ('clock@time.com', '+0107273', 'https://www.oclock.com,', 'OClock'),
('time@time.com', '+71694920', 'https://www.timeteller.timeland,', 'Time Teller'), ('machine@time.com', '+89010123', 'https://www.timemachine.en,', 'Time Machine'),
('imlate@time.com', '+347701223', 'https://www.imltate.br,', 'Im Late'), ('dinner@time.com', '+101010101', 'https://www.dinnertime.pt,', 'Dinner Time'),
('piguet@hours.com', '+888478', 'https://www.audemarspiguet.sw,', 'Audemars Piguet'), ('blacpain@hours.com', '+81230974', 'https://www.blacpain.au,', 'Blancpain'),
('hublot@help.com', '+00100891', 'https://www.hublot.org,', 'Hublot'), ('idk@time.com', '+5608484', 'https://www.likewhat.com,', 'Glashütte Original'),
('swissbrand@geral.com', '+69621803', 'https://www.realswissbrand.us,', 'SwissBrand'), ('now@now.now', '+11111111', 'https://www.now.rs,', 'NOW');

-- MODELOS
INSERT INTO model (designation, color, material, special_edition, vintage, brand_fk) VALUES
('Submariner', 'Preto', 'Aço Inoxidável', FALSE, FALSE, 'Rolex'), ('NOW2', 'Preto', 'Aluminio', FALSE, FALSE, 'Time Teller'),
('LMAO', 'Azul', 'Aço Oxidável', FALSE, FALSE, 'Rolex'), ('Texas TI-84', 'Preto', 'Plástico', FALSE, FALSE, 'Casio'),
('Fly asf', 'Rosa', 'Titânio', FALSE, FALSE, 'Rolex'), ('Carissimo', 'Verde', 'Parta', FALSE, TRUE, 'Patek Philippe'),
('Pesant', 'Castanho', 'Nickel', FALSE, FALSE, 'Rolex'), ('Chipwet 23', 'Azul', 'Aço', FALSE, FALSE, 'OMEGA'),
('FlexPlus', 'Prateado', 'Platina', FALSE, TRUE, 'Rolex'), ('New Model', 'Amarelo', 'Ferro', FALSE, FALSE, 'NOW'),
('Fit & Go', 'Branco', 'Titânio', TRUE, FALSE, 'Rolex'), ('Wristband', 'Vermelho', 'Cobre', TRUE, TRUE, 'Glashütte Original'),
('Speedmaster', 'Prateado', 'Titânio', TRUE, TRUE, 'Omega'), ('New Italy', 'Dourado', 'Ouro', FALSE, FALSE, 'Audemars Piguet'),
('StarLux', 'Rocho Couve', 'Ouro', FALSE, TRUE, 'Patek Philippe'), ('Number123', 'Branco', 'Ouro', FALSE, TRUE, 'Blancpain'),
('Carrera', 'Azul', 'Cerâmica', FALSE, FALSE, 'Teste'), ('Speedmaster Gold', 'Dourado', 'Ouro', TRUE, TRUE, 'Omega'),
('Nine Eleven', 'Cinzento', 'Aço', TRUE, TRUE, 'Teste'), ('Submariner Lite', 'Branco', 'Aço Inoxidável', FALSE, FALSE, 'Rolex'), 
('Moo Moo', 'Castanho', '', FALSE, FALSE, 'Swissbrand'), ('Thunder', 'Amarelo', 'Ouro', FALSE, FALSE, 'Time Machine'),
('Day Time2', 'Azul', 'Aço', TRUE, TRUE, 'Time Teller'), ('Danoninho', 'Rosa', 'Aço Inoxidável', FALSE, FALSE, 'Im Late');

-- ESTADOS DO LOTE
INSERT INTO batch_state (state_desc) VALUES ('selling'), ('sold'), ('not sold');

-- PARTICIPANTES
INSERT INTO participant (name, street, locality, postal_code, cc_number) VALUES
('João Silva', 'Rua A', 'Lisboa', '1000-001', '3456'), ('Tilinha Azeda', 'Rua B', 'Lisboa', '1000-201', '873163'),
('Participante Teste', 'Rua W', 'Lisboa', '1000-020', '5678'), ('Tito Costa', 'Rua C', 'Coimbra', '1000-201', '7239367'),
('Gonçalo Costa', 'Rua AC', 'Setúbal', '4200-070', '45678'), ('Tropa Marcelo', 'Rua D', 'Cantanhede', '1000-221', '72367'),
('Maria Costa', 'Rua B', 'Porto', '4000-002', '0765'), ('Zé Pipo', 'Rua E', 'Coimbra', '1022-201', '7277800'),
('Joana Rosa', 'Av. Z', 'Leiria', '1000-005', '23456'), ('Rui Unhas', 'Rua F', 'Algarve', '1800-901', '0101010'),
('Pedro Rocha', 'Rua D', 'Lisboa', '1000-002', '1234567'), ('Paula Ana', 'Rua G', 'Coimbra', '8901-001', '234567'),
('Ana Maria', 'Rua F', 'Lisboa', '2000-003', '6789'), ('Joana Silva', 'Rua C', 'Beja', '1000-201', '72101010'),
('Rita Rocha', 'Rua B', 'Lisboa', '2500-232', '1234567'), ('Catarina Augusta', 'Rua C', 'Coimbra', '1990-011', '10102928'),
('Zé Manuel', 'Rua AB', 'Lisboa', '6600-302', '81982'), ('Pedro Silva', 'Rua K', 'Porto', '1095-201', '10976543'),
('Francisco Pinto', 'Av. H', 'Setúbal', '8888-111', '1456287'), ('Eva Rita', 'Rua L', 'Braga', '1093-231', '70009367'),
('Sofia Gomes', 'Av. B', 'Setúbal', '1010-4490', '71811'), ('Rui Costa', 'Rua N', 'Porto', '1200-888', '0000002'),
('Matilde Rosa', 'Rua C', 'Setúbal', '5001-020', '8282828'), ('Afonso Fonseca', 'Rua P', 'Porto', '1091-999', '000101012'),
('Ricardo Salgado', 'Rua AC', 'Algarve', '1120-035', '00001'), ('Test User', 'Rua ABC', 'City', '0000-000', '0000000'),
('Ana Gomes', 'Av. C', 'Coimbra', '3000-003', '171771'), ('André Cabeças', 'Rua V', 'Algarve', '2020-001', '111190'),
('João Maria', 'Rua. C', 'Seixal', '1001-002', '99999'), ('Vanessa Luz', 'Rua X', 'Guarda', '1022-111', '975534');

-- RELÓGIOS
INSERT INTO watch (fabrication_year, is_new, model_fk, participant_fk) VALUES
(2020, TRUE, 'Submariner', 1), (2020, FALSE, 'Submariner', 1), (2020, TRUE, 'Submariner', 1), (1969, FALSE, 'LMAO', 1), (2015, FALSE, 'Fly asf', 1),
(2001, FALSE, 'Nine Eleven', 2), (2001, FALSE, 'Nine Eleven', 2), (1995, FALSE, 'Speedmaster', 2), (2005, FALSE, 'Pesant', 2), (2000, FALSE, 'FlexPlus', 2),
(2010, FALSE, 'Fit & Go', 5), (2015, FALSE, 'Speedmaster', 5), (2010, FALSE, 'StarLux', 5), (2023, TRUE, 'Carrera', 5), (1990, FALSE, 'Thunder', 5),
(2007, FALSE, 'Speedmaster Gold', 15), (2010, TRUE, 'FlexPlus', 15), (1899, FALSE, 'Texas TI-84', 15), (2020, TRUE, 'New Italy', 15), (2023, TRUE, 'Carrera', 15),
(2021, TRUE, 'NOW2', 9), (2001, FALSE, 'Nine Eleven', 9), (2001, FALSE, 'Nine Eleven', 9),(2010, TRUE, 'FlexPlus', 9), (1899, FALSE, 'Texas TI-84', 9), 
(2020, TRUE, 'New Italy', 10), (2023, TRUE, 'Carrera', 10), (2020, TRUE, 'Submariner', 20), (1969, FALSE, 'LMAO', 21), (2015, FALSE, 'Fly asf', 22);

-- VENDEDORES
INSERT INTO seller (participant_id) VALUES (1), (2), (5), (15), (9);
-- LICITADORES
INSERT INTO bidder (participant_id) VALUES (2), (3), (4), (6), (7), (8), (9), (10), (11), (12), (13), (14), (16), (17), (18), (19), (20), (21), (22), (23), (24), (25), (26), (27);

-- LOTES
INSERT INTO batch (base_price, state_fk, seller_fk) VALUES
(5000.00, 'selling', 1),
(3200.00, 'selling', 2),
(4000.00, 'sold', 2),
(2000.00, 'not sold', 5),
(3500.00, 'selling', 5);

-- ASSOCIAR RELÓGIOS A LOTES
INSERT INTO watch_batch (watch_id, batch_id) VALUES
(1, 1), (2, 1), (3, 1),
(5, 2),
(25, 3),
(10, 4), (11, 4),
(10, 5), (12, 5);

-- ESTADOS DO LEILÃO
INSERT INTO auction_state (state_desc) VALUES ('open'), ('close'), ('canceled');

-- ORGANIZADORES
INSERT INTO organizer (name, contact, address) VALUES
('Leilões VIP', 'vip@leiloes.pt', 'Av. Leiloeira, Lisboa'),
('Tester Auctions', 'tester@auctions.en', 'Street City, London'),
('Elite Auctions', 'elite@auctions.com', 'Rua Elite, Porto');

-- LEILÕES
INSERT INTO auction (start_date, final_date, locality, state_fk, organizer_fk) VALUES
('2025-06-01', '2025-06-07', 'Lisboa', 'open', 1),
('2025-06-10', NULL, 'Porto', 'open', 2),
('2026-01-11', '2026-08-08', 'Lisboa', 'close', 2);

-- SESSÕES
INSERT INTO session (session_date, start_session, end_session, auction_fk) VALUES
('2025-06-01', '08:30:00', '13:30:00', 1),
('2025-06-20', '08:45:00', '14:30:00', 2),
('2025-07-10', '16:30:00', '19:00:00', 3),
('2025-06-11', '08:30:00', '19:00:00', 3);

-- ASSOCIAÇÃO LOTE-SESSION
INSERT INTO batch_session (batch_id, session_id) VALUES
(1, 1), (5, 1), (4, 1),
(2, 2),
(3, 3);

-- LICITAÇÕES
INSERT INTO bidding (value, session_fk, batch_fk, bidder_fk) VALUES
(5100.00, 1, 1, 12), (5200.00, 1, 1, 10),
(5300.00, 2, 2, 9), (6000.00, 2, 3, 10),
(7000.00, 1, 1, 8), (7200.00, 1, 1, 18),
(9200.00, 2, 2, 17), (1000.00, 2, 3, 22);





