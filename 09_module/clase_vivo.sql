-- CREAR OBTEJOS DEL TRIGGER
-- BEFORE -->  Por lo general son para checks - validaciones o algos casos donde necesito modificar esa data.

CREATE DATABASE `triggers_database`;
USE `triggers_database`;

CREATE TABLE products (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL,
    category VARCHAR(50), -- zapatillas Zapatillas ZAPATILLAS
    stock_quantity INT DEFAULT 0,
    brand VARCHAR(50)
);

-- que pasa cuando la data no es consistente! 

DELIMITER //

DROP TRIGGER IF EXISTS trg_product_category_uppercase//

CREATE TRIGGER trg_product_category_uppercase
	BEFORE INSERT ON `triggers_database`.`products`
	FOR EACH ROW
BEGIN
	SET  NEW.category = UPPER(NEW.category) ;
END//

DELIMITER ;


INSERT INTO products (name, description, price, category, stock_quantity, brand) VALUES
('MacBook Pro', '14-inch laptop with M2 chip, 16GB RAM', 1999.99, 'Electronics', 30, 'Apple');


SELECT * FROM `triggers_database`.`products`;

INSERT INTO products (name, description, price, category, stock_quantity, brand) VALUES
('MacBook Pro', '14-inch laptop with M2 chip, 16GB RAM', 1999.99, 'Electronics', 30, 'Apple'),
('Running Shoes', 'Lightweight running shoes for men', 89.99, 'Footwear', 150, 'Adidas'),
('Python Programming Book', 'Learn Python from scratch', 49.99, 'Books', 80, 'O\'Reilly'),
('Blender', 'High-speed blender for smoothies', 79.99, 'Home Appliances', 40, 'Ninja'),
('Dumbbell Set', '20kg adjustable dumbbell set', 119.99, 'Sports', 25, 'Bowflex'),
('Sunglasses', 'Polarized aviator sunglasses', 159.99, 'Accessories', 35, 'Ray-Ban'),
('Office Chair', 'Ergonomic mesh office chair', 249.99, 'Furniture', 15, 'Herman Miller'),
('Tablet Stand', 'Adjustable aluminum tablet stand', 29.99, 'Accessories', 200, 'Amazon Basics'),
('Gaming Mouse', 'RGB gaming mouse with 7 buttons', 49.99, 'Electronics', 75, 'Razer'),
('Water Bottle', 'Stainless steel insulated water bottle', 24.99, 'Sports', 300, 'Hydro Flask');


-- que hago si por algun motivo tengo genete loca que me borre los productos ??  🙀

-- crear un trigger que me permita auditar cuando un registro es borrado por cierto usuario en la hora exacta.



CREATE TABLE products_delete_audit (
    audit_id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL,
    category VARCHAR(50), -- zapatillas Zapatillas ZAPATILLAS
    stock_quantity INT DEFAULT 0,
    brand VARCHAR(50),
    deleted_by VARCHAR(100),
    deleted_at DATETIME
);


DELIMITER //
DROP TRIGGER IF EXISTS trg_product_before_delete//

CREATE TRIGGER `triggers_database`.`trg_product_before_delete`
		AFTER DELETE ON `triggers_database`.`products`
        FOR EACH ROW
BEGIN

INSERT INTO `triggers_database`.`products_delete_audit`
	(product_id,name,description,price,category,stock_quantity, brand, deleted_by,deleted_at) 
	VALUES
    (OLD.id, OLD.name,OLD.description,OLD.price,OLD.category,OLD.stock_quantity,OLD.brand,CURRENT_USER(),NOW());
END//
DELIMITER ;
        

DELETE FROM `triggers_database`.`products` WHERE id BETWEEN 2 AND 5;


SELECT * FROM `triggers_database`.`products`;

SELECT * FROM `triggers_database`.`products_delete_audit`;

-- trigger que me valide que no tenga el update valores negativos para el price, ni que el valor del producto sea 4 veces mas al valor viejo

DELIMITER //
DROP TRIGGER IF EXISTS trg_validate_product_price//

CREATE TRIGGER `triggers_database`.`trg_validate_product_price`
		BEFORE UPDATE ON `triggers_database`.`products`
        FOR EACH ROW
BEGIN

	IF NEW.price < 0 THEN
		SIGNAL SQLSTATE '45000'
			SET MESSAGE_TEXT = 'El precio no debe ser negativo, Zapallo!';
	END IF;
    
    IF NEW.price > OLD.price * 4  THEN
    
		SIGNAL SQLSTATE '45000'
			SET MESSAGE_TEXT = 'EEEEEUUUU!! Como cuatro veces??? Nahh! Corregilo con el dueño, cabeza de termo';
	END IF;
    

END//
DELIMITER ;


UPDATE `triggers_database`.`products` 
	SET price = -10
WHERE id = 1;

UPDATE `triggers_database`.`products` 
	SET price = 20000
WHERE id = 1;

SELECT * FROM `triggers_database`.`products`;

UPDATE `triggers_database`.`products` 
	SET price = 2000
WHERE id = 1;



-- DCL --> data control language

CREATE USER 'nancy_coderhouse'@'%'
	 IDENTIFIED BY 'pass_123';
    
RENAME USER
	'nancy_coderhouse'@'%' TO 'nancy_coderhouse_beta'@'%';

-- GRANT  LECTURA
-- otorgar los permisos de lectura cierta base de datos y ciertas tablas a este user
GRANT SELECT ON `coderhouse_gamers`.* TO 'nancy_coderhouse_beta'@'%';

-- observar los permisos que tiene el usuario
SHOW GRANTS FOR 'nancy_coderhouse_beta'@'%';

REVOKE SELECT ON `coderhouse_gamers`.* FROM 'nancy_coderhouse_beta'@'%';


GRANT SELECT ON `coderhouse_gamers`.`GAME` TO 'nancy_coderhouse_beta'@'%';

GRANT SELECT(description) ON `coderhouse_gamers`.`LEVEL_GAME` TO 'nancy_coderhouse_beta'@'%';

FLUSH PRIVILEGES;

DROP USER 
	'nancy_coderhouse'@'%';