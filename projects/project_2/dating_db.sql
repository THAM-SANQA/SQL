-- This script was generated by the ERD tool in pgAdmin 4.
-- Please log an issue at https://redmine.postgresql.org/projects/pgadmin4/issues/new if you find any bugs, including reproduction steps.
BEGIN;


CREATE TABLE IF NOT EXISTS public.my_contacts
(
    contact_id serial,
    last_name character varying(50),
    first_name character varying(50),
    phone numeric(10),
    email character varying(225),
    gender character varying(6),
    birthday date,
    prof_id serial,
    zip_code character varying(4),
    status_id serial,
    PRIMARY KEY (contact_id)
);

CREATE TABLE IF NOT EXISTS public.profession
(
    prof_id serial,
    profession character varying(50),
    PRIMARY KEY (prof_id)
);

CREATE TABLE IF NOT EXISTS public.zip_code
(
    zip_code character varying(4),
    city character varying(50),
    province character varying(50),
    PRIMARY KEY (zip_code)
);

CREATE TABLE IF NOT EXISTS public.status
(
    status_id serial,
    status character varying,
    PRIMARY KEY (status_id)
);

CREATE TABLE IF NOT EXISTS public.contact_interest
(
    contact_id serial,
    interest_id serial
);

CREATE TABLE IF NOT EXISTS public.interests
(
    interest_id serial,
    interest character varying(150),
    PRIMARY KEY (interest_id)
);

CREATE TABLE IF NOT EXISTS public.contact_seeking
(
    conact_id serial,
    seeking_id serial
);

CREATE TABLE IF NOT EXISTS public.seeking
(
    seeking_id serial,
    seeking character varying(100),
    PRIMARY KEY (seeking_id)
);

ALTER TABLE IF EXISTS public.my_contacts
    ADD CONSTRAINT prof_id FOREIGN KEY (prof_id)
    REFERENCES public.profession (prof_id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS public.my_contacts
    ADD CONSTRAINT zip_code FOREIGN KEY (zip_code)
    REFERENCES public.zip_code (zip_code) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS public.my_contacts
    ADD CONSTRAINT status_id FOREIGN KEY (status_id)
    REFERENCES public.status (status_id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS public.contact_interest
    ADD CONSTRAINT interest_id FOREIGN KEY (interest_id)
    REFERENCES public.interests (interest_id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS public.contact_interest
    ADD CONSTRAINT contact_id FOREIGN KEY (contact_id)
    REFERENCES public.my_contacts (contact_id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS public.contact_seeking
    ADD CONSTRAINT seeking_id FOREIGN KEY (seeking_id)
    REFERENCES public.seeking (seeking_id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS public.contact_seeking
    ADD CONSTRAINT contact_id FOREIGN KEY (conact_id)
    REFERENCES public.my_contacts (contact_id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;

END;

-- Add UNIQUE constraint to profession column
ALTER TABLE IF EXISTS public.profession
    ADD CONSTRAINT unique_profession UNIQUE (profession);

-- Add CHECK constraint to zip_code column
ALTER TABLE IF EXISTS public.my_contacts
    ADD CONSTRAINT check_zip_code_length CHECK (length(zip_code) = 4);
ALTER TABLE IF EXISTS public.zip_code
    RENAME COLUMN pronvince TO province;	

INSERT INTO profession (profession, prof_id) --21:29
VALUES 
	('Web Dveloper', 21),
	('Project Manager', 22),
	('Student', 23),
	('Professor', 24),
	('Waitress', 25),
	('Architect', 26),
	('Engineer', 27),
	('Accountant', 28),
	('Bartender', 29);

INSERT INTO zip_code (zip_code, city, province)
VALUES 
	('0699', 'Polokwane', 'Limpopo'),
	('0480', 'Bela-Bela', 'Limpopo'),
	('1038', 'Emalahleni', 'Mpumalanga'),
	('4366', 'Nelspruit', 'Mpumalanga'),
	('3201', 'Pietermaritzburg', 'KwaZulu-Natal'),
	('4057', 'Durban', 'KwaZulu-Natal'),
	('2999', 'Rustenburg', 'North West'),
	('2520', 'Potchefstroom', 'North West'),
	('0126', 'Pretoria', 'Gauteng'),
	('2001', 'Johannesburg', 'Gauteng'),
	('9300', 'Bloemfontein', 'Free State'),
	('9460', 'Welkom', 'Free State'),
	('8301', 'Kimberley', 'Northern Cape'),
	('8890', 'Pofadder', 'Northern Cape'),
	('5201', 'East London', 'Eastern Cape'),
	('6006', 'Gqeberha', 'Eastern Cape'),
	('8001', 'Cape Town', 'Western Cape'),
	('7600', 'Stellenbosch', 'Western Cape');

INSERT INTO status (status, status_id)
VALUES 
	('Single', 00), -- 00:04
	('Married', 04), 
	('Divorced', 01),
	('Dating', 02),
	('Complicated', 03);
	
INSERT INTO interests (interest, interest_id)
VALUES --81:88 
	('Reading', 81),
	('Hiking', 82),
	('Cooking', 83),
	('Gyming', 84),
	('Gaming', 85),
	('Gardening', 86),
	('Netflix', 87),
	('Music', 88);

INSERT INTO seeking (seeking, seeking_id)
VALUES --41:45
	('Short-Term', 42),
	('Long-Term', 45),
	('Friendship', 41),
	('Casual', 44);

INSERT INTO my_contacts ( --1-16
	contact_id,
	last_name, 
	first_name,
	phone,
	email, 
	gender,
	birthday, 
	prof_id, 
	zip_code, 
	status_id)
VALUES 
	(1, 'Fiona', 'Gira', '0712347678', 'fon@gmail.com', 'M', '1996/09/12', 29, '8890', 00),
	(2, 'Yiang', 'Hong', '0821357448', 'hong@gmail.com', 'M', '2000/03/26', 23, '0480', 01),
	(3, 'Hawthorne', 'Tom', '0656473099', 'hawthorntom@gmail.com', 'F', '2000/04/15', 24, '9300', 01),
	(4, 'Thabo', 'Montse', '0752479751', 'montse@gmail.com', 'F', '1995/11/25', 22, '5201', 02),
	(5, 'Kat', 'Nkomba', '0622857690', 'kat@gmail.com', 'M', '1993/02/09', 28, '0699', 04),
	(6, 'Penelope', 'Gatsheni', '0802173522', 'gatsheni@gmail.com', 'M', '1999/04/22', 25, '2001', 00),
	(7, 'Annisa', 'Malik', '0600757874', 'malik@gmail.com', 'F', '2001/05/17', 22, '7600', 04),
	(8, 'Chris', 'Ivan', '0677281923', 'ivan@gmail.com', 'M', '1996/03/14', 26, '2999', 01),
	(9, 'Arnold', 'Jordan', '0621335456', 'arnold@gmail.com', 'F', '1993/05/20', 27, '2001', 00),
	(10, 'Bhabha', 'Tracy', '0895423647', 'tracy@gmail.com', 'F', '1992/07/23', 21, '9460', 02),
	(11, 'Muxe', 'Tello', '082311446', 'muxe@gmail.com', 'M', '1997/08/23', 28, '3201', 00),
	(12, 'Mamacita', 'Bambi', '0631333854', 'mama@gmail.com', 'F', '1992/01/30', 21, '8301', 03),
	(13, 'Nardia', 'Nakai', '0734965854', 'nardia@gmail.com', 'F', '1991/07/28', 29, '4366', 04),
	(14, 'Junior', 'Fatih', '0845365490', 'jfaith@gmail.com', 'F', '2003/01/15', 26, '4057', 03),
	(15, 'Kendrick', 'Lamar', '0624113438', 'lamar@gmail.com', 'M', '1989/06/21', 23, '1038', 02),
	(16, 'Thami', 'King', '0823253440', 'thamik@gmail.com', 'M', '2003/06/13', 29, '6006', 00);
	

INSERT INTO contact_interest (contact_id, interest_id)
SELECT
    contact_id,
    interest_id
FROM (
    SELECT
        contact_id,
        interest_id,
        ROW_NUMBER() OVER (PARTITION BY contact_id ORDER BY RANDOM()) as row_num
    FROM
        generate_series(1, 16) AS contact_id,
        generate_series(81, 88) AS interest_id
) AS subquery
WHERE row_num <= 3;


ALTER TABLE IF EXISTS public.contact_seeking
    RENAME COLUMN conact_id TO contact_id;
	
INSERT INTO contact_seeking (contact_id, seeking_id) 
VALUES --41:45
	(1, 41),
	(2, 42),
	(3, 45),
	(4, 44), 
	(5, 41),
	(6, 45),
	(7, 42),
	(8, 44),
	(9, 41), 
	(10, 45),
	(11, 41),
	(12, 42),
	(13, 42),
	(14, 44),
	(15, 45), 
	(16, 41);

SELECT * FROM my_contacts;
SELECT * FROM profession;
SELECT * FROM zip_code;
SELECT * FROM status;
SELECT * FROM interests;
SELECT * FROM seeking;

SELECT * FROM contact_interest;
SELECT * FROM contact_seeking;
DELETE FROM contact_interest;

SELECT
    mc.contact_id,
    mc.last_name,
    mc.first_name,
    p.profession,
    z.zip_code,
    z.city,
    z.province,
    st.status,
    it.interest,
    se.seeking
FROM
    my_contacts mc
LEFT JOIN profession p ON mc.prof_id = p.prof_id
LEFT JOIN zip_code z ON mc.zip_code = z.zip_code
LEFT JOIN status st ON mc.status_id = st.status_id
LEFT JOIN contact_interest ci ON mc.contact_id = ci.contact_id
LEFT JOIN interests it ON ci.interest_id = it.interest_id
LEFT JOIN contact_seeking cs ON mc.contact_id = cs.contact_id
LEFT JOIN seeking se ON cs.seeking_id = se.seeking_id;

