-- BEGIN transaction
BEGIN;

-- Creating tables
CREATE TABLE IF NOT EXISTS public.menu
(
    product_id bigserial,
    product_name character varying(50),
    product_price money,
    PRIMARY KEY (product_id)
);

CREATE TABLE IF NOT EXISTS public.cart
(
    product_id bigserial,
    product_quantity integer
);

CREATE TABLE IF NOT EXISTS public.users
(
    user_id bigserial,
    user_name character varying(50),
    PRIMARY KEY (user_id)
);

CREATE TABLE IF NOT EXISTS public.order_header
(
    order_id bigserial,
    user_id bigserial,
    order_date timestamp without time zone,
    PRIMARY KEY (order_id)
);

CREATE TABLE IF NOT EXISTS public.order_details
(
    detail_id bigserial,
    order_id bigserial,
    product_id bigserial,
    product_quantity integer
);

-- Adding foreign key constraints
ALTER TABLE IF EXISTS public.cart
    ADD CONSTRAINT product_id_fk FOREIGN KEY (product_id)
    REFERENCES public.menu (product_id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;

ALTER TABLE IF EXISTS public.order_header
    ADD CONSTRAINT user_id_fk FOREIGN KEY (user_id)
    REFERENCES public.users (user_id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;

ALTER TABLE IF EXISTS public.order_details
    ADD CONSTRAINT order_id_fk FOREIGN KEY (order_id)
    REFERENCES public.order_header (order_id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;

ALTER TABLE IF EXISTS public.order_details
    ADD CONSTRAINT product_id_fk FOREIGN KEY (product_id)
    REFERENCES public.menu (product_id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;

-- COMMIT transaction
COMMIT;

-- Adding items function
CREATE OR REPLACE FUNCTION add_to_cart(pro_id INT)
RETURNS VOID AS $$
BEGIN
    IF EXISTS(SELECT * FROM cart WHERE product_id = pro_id) THEN 
        UPDATE cart SET product_quantity = product_quantity + 1 WHERE product_id = pro_id;
    ELSE 
        INSERT INTO cart(product_id, product_quantity) VALUES (pro_id, 1);
    END IF; 
END;
$$ LANGUAGE plpgsql;

-- Remove items function
CREATE OR REPLACE FUNCTION remove_from_cart(pro_id INT)
RETURNS VOID AS $$
BEGIN 
    IF EXISTS(SELECT * FROM cart WHERE product_id = pro_id) THEN 
        IF EXISTS(SELECT * FROM cart WHERE product_quantity > 1 AND product_id = pro_id) THEN 
            UPDATE cart SET product_quantity = product_quantity - 1 WHERE product_id = pro_id;
        ELSE 
            DELETE FROM cart WHERE product_id = pro_id;
        END IF;
    END IF; 
END; 
$$ LANGUAGE plpgsql;

-- Checkout function
CREATE OR REPLACE FUNCTION checkout_order(user_id INT)
RETURNS VOID AS $$
DECLARE
    new_order_id INT;
BEGIN 
    -- Inserting into order_header
    INSERT INTO order_header (user_id, order_date) VALUES (user_id, NOW()) RETURNING order_id INTO new_order_id;

    -- Inserting into order_details
    INSERT INTO order_details (order_id, product_id, product_quantity)
    SELECT new_order_id, product_id, product_quantity FROM cart;

    -- Clearing the cart
    DELETE FROM cart;
END;
$$ LANGUAGE plpgsql;

BEGIN;

INSERT INTO menu(product_name, product_price)
VALUES 
	('Coke', 19.99),
	('Chips', 14.99),
	('Bar One', 11.99),
	('Dunhill', 2.99),
	('Switch', 9.99),
	('Sprite', 18.99),
	('XXX mints', 4.99),
	('Maynards', 7.95),
	('Halls', 0.50),
	('Stumbo', 2.60);

SELECT * FROM menu;

INSERT INTO users(user_name)
VALUES 
	('Amanda'),
	('Junior'),
	('Mtho'),
	('Prince');
	
SELECT * FROM users;
END;
--------------------------------------------------------------------------------------------------------------------------------------------
-- Example usage

-- Adding multiple products to the cart
SELECT add_to_cart(1); -- Adding product with ID 1
SELECT add_to_cart(3); -- Adding product with ID 3
SELECT add_to_cart(5); -- Adding product with ID 5

-- Displaying the cart after each addition
SELECT * FROM cart;

-- Deleting products from the cart
SELECT remove_from_cart(3); -- Removing product with ID 3

-- Displaying the cart after deletion
SELECT * FROM cart;

-- Checking out multiple times, creating multiple orders
-- Checkout for user with ID 1
SELECT checkout_order(1);

-- Displaying orders after the first checkout
SELECT * FROM order_header;
SELECT * FROM order_details;

-- Adding more products to the cart
SELECT add_to_cart(2); -- Adding product with ID 2
SELECT add_to_cart(4); -- Adding product with ID 4

-- Displaying the cart after addition
SELECT * FROM cart;

-- Checkout for user with ID 1 again
SELECT checkout_order(1);

-- Displaying orders after the second checkout
SELECT * FROM order_header;
SELECT * FROM order_details;

-- Printing orders with inner joins
-- Displaying all orders with product details
SELECT oh.order_id, oh.order_date, od.product_id, od.product_quantity
FROM order_header oh
JOIN order_details od ON oh.order_id = od.order_id;

-- Printing a single order (for order with ID 1)
SELECT oh.order_id, oh.order_date, od.product_id, od.product_quantity
FROM order_header oh
JOIN order_details od ON oh.order_id = od.order_id
WHERE oh.order_id = 1;


DELETE FROM order_details;
DELETE FROM order_header;
DELETE FROM cart;