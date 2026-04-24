-- MySQL Script Refactorizado - TESALIAVET DB
-- Correcciones aplicadas: Eliminación de 'VISIBLE' e integridad de Primary Keys (NOT NULL)
-- ============================================================
-- BASE DE DATOS: TesaliaVet
-- Arquitectura: Single-Tenant | Motor: InnoDB | Charset: UTF-8
-- ============================================================

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema tesaliavet_db
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `tesaliavet_db` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci ;
USE `tesaliavet_db` ;

-- -----------------------------------------------------
-- Table `tesaliavet_db`.`roles`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tesaliavet_db`.`roles` (
  `id` TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(50) NOT NULL,
  `description` VARCHAR(255) NULL DEFAULT NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE INDEX (`name` ASC))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `tesaliavet_db`.`users`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tesaliavet_db`.`users` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `tipo_documento` VARCHAR(10) NOT NULL,
  `numero_documento` VARCHAR(50) NOT NULL,
  `first_name` VARCHAR(100) NOT NULL,
  `last_name` VARCHAR(100) NOT NULL,
  `email` VARCHAR(255) NOT NULL,
  `password_hash` VARCHAR(255) NOT NULL,
  `phone` VARCHAR(20) NULL DEFAULT NULL,
  `direccion` VARCHAR(255) NULL DEFAULT NULL,
  `ciudad` VARCHAR(100) NULL DEFAULT NULL,
  `profile_image` LONGBLOB NULL DEFAULT NULL,
  `profile_image_mime` VARCHAR(50) NULL DEFAULT NULL,
  `is_active` TINYINT(1) NOT NULL DEFAULT 1,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE INDEX (`numero_documento` ASC),
  UNIQUE INDEX (`email` ASC))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `tesaliavet_db`.`user_roles`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tesaliavet_db`.`user_roles` (
  `user_id` BIGINT UNSIGNED NOT NULL,
  `role_id` TINYINT UNSIGNED NOT NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_id`, `role_id`),
  INDEX `fk_user_roles_role` (`role_id` ASC),
  CONSTRAINT `fk_user_roles_user`
    FOREIGN KEY (`user_id`)
    REFERENCES `tesaliavet_db`.`users` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_user_roles_role`
    FOREIGN KEY (`role_id`)
    REFERENCES `tesaliavet_db`.`roles` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `tesaliavet_db`.`species`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tesaliavet_db`.`species` (
  `id` SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(50) NOT NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE INDEX (`name` ASC))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `tesaliavet_db`.`breeds`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tesaliavet_db`.`breeds` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `species_id` SMALLINT UNSIGNED NOT NULL,
  `name` VARCHAR(100) NOT NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE INDEX (`species_id` ASC, `name` ASC),
  CONSTRAINT `fk_breeds_species`
    FOREIGN KEY (`species_id`)
    REFERENCES `tesaliavet_db`.`species` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `tesaliavet_db`.`pets`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tesaliavet_db`.`pets` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `owner_id` BIGINT UNSIGNED NOT NULL,
  `name` VARCHAR(100) NOT NULL,
  `species_id` SMALLINT UNSIGNED NOT NULL,
  `breed_id` INT UNSIGNED NULL DEFAULT NULL,
  `gender` ENUM('Macho', 'Hembra', 'Desconocido') NOT NULL DEFAULT 'Desconocido',
  `birth_date` DATE NULL DEFAULT NULL,
  `weight` DECIMAL(5,2) NULL DEFAULT NULL,
  `color` VARCHAR(50) NULL DEFAULT NULL,
  `notes` TEXT NULL DEFAULT NULL,
  `image` LONGBLOB NULL DEFAULT NULL,
  `image_mime` VARCHAR(50) NULL DEFAULT NULL,
  `is_active` TINYINT(1) NOT NULL DEFAULT 1,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX `idx_pets_owner_id` (`owner_id` ASC),
  INDEX `fk_pets_owner` (`owner_id` ASC),
  INDEX `fk_pets_species` (`species_id` ASC),
  INDEX `fk_pets_breed` (`breed_id` ASC),
  CONSTRAINT `fk_pets_owner`
    FOREIGN KEY (`owner_id`)
    REFERENCES `tesaliavet_db`.`users` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_pets_species`
    FOREIGN KEY (`species_id`)
    REFERENCES `tesaliavet_db`.`species` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_pets_breed`
    FOREIGN KEY (`breed_id`)
    REFERENCES `tesaliavet_db`.`breeds` (`id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `tesaliavet_db`.`medical_records`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tesaliavet_db`.`medical_records` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `pet_id` BIGINT UNSIGNED NOT NULL,
  `veterinarian_id` BIGINT UNSIGNED NULL DEFAULT NULL,
  `visit_date` DATETIME NOT NULL,
  `symptoms` TEXT NULL DEFAULT NULL,
  `diagnosis` TEXT NULL DEFAULT NULL,
  `treatment` TEXT NULL DEFAULT NULL,
  `observations` TEXT NULL DEFAULT NULL,
  `attachment` LONGBLOB NULL DEFAULT NULL,
  `attachment_mime` VARCHAR(50) NULL DEFAULT NULL,
  `is_active` TINYINT(1) NOT NULL DEFAULT 1,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX `idx_medical_records_pet_id` (`pet_id` ASC),
  INDEX `fk_medical_pet` (`pet_id` ASC),
  INDEX `fk_medical_vet` (`veterinarian_id` ASC),
  CONSTRAINT `fk_medical_pet`
    FOREIGN KEY (`pet_id`)
    REFERENCES `tesaliavet_db`.`pets` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_medical_vet`
    FOREIGN KEY (`veterinarian_id`)
    REFERENCES `tesaliavet_db`.`users` (`id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `tesaliavet_db`.`vaccines`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tesaliavet_db`.`vaccines` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NOT NULL,
  `description` VARCHAR(255) NULL DEFAULT NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE INDEX (`name` ASC))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `tesaliavet_db`.`pet_vaccinations`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tesaliavet_db`.`pet_vaccinations` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `pet_id` BIGINT UNSIGNED NOT NULL,
  `vaccine_id` INT UNSIGNED NOT NULL,
  `application_date` DATE NOT NULL,
  `next_due_date` DATE NULL DEFAULT NULL,
  `batch_number` VARCHAR(100) NULL DEFAULT NULL COMMENT 'Número de lote del fabricante',
  `expires_at` DATE NULL DEFAULT NULL COMMENT 'Fecha de vencimiento del vial',
  `veterinarian_id` BIGINT UNSIGNED NULL DEFAULT NULL,
  `notes` TEXT NULL DEFAULT NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX `idx_pet_vaccinations_pet_id` (`pet_id` ASC),
  INDEX `fk_pv_pet` (`pet_id` ASC),
  INDEX `fk_pv_vaccine` (`vaccine_id` ASC),
  INDEX `fk_pv_vet` (`veterinarian_id` ASC),
  CONSTRAINT `fk_pv_pet`
    FOREIGN KEY (`pet_id`)
    REFERENCES `tesaliavet_db`.`pets` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_pv_vaccine`
    FOREIGN KEY (`vaccine_id`)
    REFERENCES `tesaliavet_db`.`vaccines` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_pv_vet`
    FOREIGN KEY (`veterinarian_id`)
    REFERENCES `tesaliavet_db`.`users` (`id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `tesaliavet_db`.`appointments`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tesaliavet_db`.`appointments` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `pet_id` BIGINT UNSIGNED NOT NULL,
  `owner_id` BIGINT UNSIGNED NOT NULL,
  `veterinarian_id` BIGINT UNSIGNED NULL DEFAULT NULL,
  `appointment_datetime` DATETIME NOT NULL,
  `reason` VARCHAR(255) NULL DEFAULT NULL,
  `status` ENUM('Pendiente', 'Confirmada', 'Cancelada', 'Completada') NOT NULL DEFAULT 'Pendiente',
  `cancel_reason` VARCHAR(255) NULL DEFAULT NULL,
  `notes` TEXT NULL DEFAULT NULL,
  `is_active` TINYINT(1) NOT NULL DEFAULT 1,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX `idx_appointments_owner_id` (`owner_id` ASC),
  INDEX `idx_appointments_status_datetime` (`status` ASC, `appointment_datetime` ASC),
  INDEX `fk_appointments_pet` (`pet_id` ASC),
  INDEX `fk_appointments_owner` (`owner_id` ASC),
  INDEX `fk_appointments_vet` (`veterinarian_id` ASC),
  CONSTRAINT `fk_appointments_pet`
    FOREIGN KEY (`pet_id`)
    REFERENCES `tesaliavet_db`.`pets` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_appointments_owner`
    FOREIGN KEY (`owner_id`)
    REFERENCES `tesaliavet_db`.`users` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_appointments_vet`
    FOREIGN KEY (`veterinarian_id`)
    REFERENCES `tesaliavet_db`.`users` (`id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `tesaliavet_db`.`categories`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tesaliavet_db`.`categories` (
  `id` SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NOT NULL,
  `description` VARCHAR(255) NULL DEFAULT NULL,
  `parent_id` SMALLINT UNSIGNED NULL DEFAULT NULL,
  `is_active` TINYINT(1) NOT NULL DEFAULT 1,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE INDEX (`name` ASC),
  INDEX `fk_categories_parent` (`parent_id` ASC),
  CONSTRAINT `fk_categories_parent`
    FOREIGN KEY (`parent_id`)
    REFERENCES `tesaliavet_db`.`categories` (`id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `tesaliavet_db`.`products`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tesaliavet_db`.`products` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `category_id` SMALLINT UNSIGNED NOT NULL,
  `sku` VARCHAR(50) NOT NULL,
  `barcode` VARCHAR(100) NULL DEFAULT NULL,
  `name` VARCHAR(150) NOT NULL,
  `description` TEXT NULL DEFAULT NULL,
  `purchase_price` DECIMAL(12,2) NOT NULL DEFAULT 0.00,
  `selling_price` DECIMAL(12,2) NOT NULL DEFAULT 0.00,
  `stock` DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  `min_stock` DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  `tax_rate` DECIMAL(5,2) NOT NULL DEFAULT 0.00 COMMENT 'Porcentaje IVA. Ej: 19.00',
  `is_active` TINYINT(1) NOT NULL DEFAULT 1,
  `image` LONGBLOB NULL DEFAULT NULL,
  `image_mime` VARCHAR(50) NULL DEFAULT NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE INDEX (`sku` ASC),
  UNIQUE INDEX (`barcode` ASC),
  INDEX `idx_products_stock_alerts` (`stock` ASC, `min_stock` ASC),
  INDEX `fk_products_category` (`category_id` ASC),
  CONSTRAINT `fk_products_category`
    FOREIGN KEY (`category_id`)
    REFERENCES `tesaliavet_db`.`categories` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `tesaliavet_db`.`product_images`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tesaliavet_db`.`product_images` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `product_id` BIGINT UNSIGNED NOT NULL,
  `image` LONGBLOB NOT NULL,
  `image_mime` VARCHAR(50) NOT NULL,
  `is_main` TINYINT(1) NOT NULL DEFAULT 0,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX `fk_product_images_product` (`product_id` ASC),
  CONSTRAINT `fk_product_images_product`
    FOREIGN KEY (`product_id`)
    REFERENCES `tesaliavet_db`.`products` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `tesaliavet_db`.`stock_alerts`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tesaliavet_db`.`stock_alerts` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `product_id` BIGINT UNSIGNED NOT NULL,
  `current_stock` DECIMAL(10,2) NOT NULL,
  `min_stock` DECIMAL(10,2) NOT NULL,
  `status` ENUM('Activa', 'Resuelta') NOT NULL DEFAULT 'Activa',
  `resolved_at` DATETIME NULL DEFAULT NULL,
  `resolved_by` BIGINT UNSIGNED NULL DEFAULT NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX `fk_stock_alerts_product` (`product_id` ASC),
  INDEX `fk_stock_alerts_user` (`resolved_by` ASC),
  CONSTRAINT `fk_stock_alerts_product`
    FOREIGN KEY (`product_id`)
    REFERENCES `tesaliavet_db`.`products` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_stock_alerts_user`
    FOREIGN KEY (`resolved_by`)
    REFERENCES `tesaliavet_db`.`users` (`id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `tesaliavet_db`.`carts`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tesaliavet_db`.`carts` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` BIGINT UNSIGNED NOT NULL,
  `status` ENUM('Activo', 'Abandonado', 'Convertido') NOT NULL DEFAULT 'Activo',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX `fk_carts_user` (`user_id` ASC),
  CONSTRAINT `fk_carts_user`
    FOREIGN KEY (`user_id`)
    REFERENCES `tesaliavet_db`.`users` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `tesaliavet_db`.`cart_items`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tesaliavet_db`.`cart_items` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `cart_id` BIGINT UNSIGNED NOT NULL,
  `product_id` BIGINT UNSIGNED NOT NULL,
  `quantity` DECIMAL(10,2) NOT NULL DEFAULT 1.00,
  `unit_price` DECIMAL(12,2) NOT NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE INDEX (`cart_id` ASC, `product_id` ASC),
  INDEX `fk_cart_items_product` (`product_id` ASC),
  CONSTRAINT `fk_cart_items_cart`
    FOREIGN KEY (`cart_id`)
    REFERENCES `tesaliavet_db`.`carts` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_cart_items_product`
    FOREIGN KEY (`product_id`)
    REFERENCES `tesaliavet_db`.`products` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `tesaliavet_db`.`suppliers`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tesaliavet_db`.`suppliers` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(150) NOT NULL,
  `document_type` VARCHAR(10) NOT NULL COMMENT 'Ej: NIT, CC',
  `document_number` VARCHAR(50) NOT NULL,
  `primary_contact_name` VARCHAR(150) NULL DEFAULT NULL,
  `primary_contact_phone` VARCHAR(20) NULL DEFAULT NULL,
  `primary_contact_email` VARCHAR(255) NULL DEFAULT NULL,
  `address` VARCHAR(255) NULL DEFAULT NULL,
  `city` VARCHAR(100) NULL DEFAULT NULL,
  `is_active` TINYINT(1) NOT NULL DEFAULT 1,
  `notes` VARCHAR(255) NULL DEFAULT NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE INDEX (`document_number` ASC))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `tesaliavet_db`.`purchase_orders`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tesaliavet_db`.`purchase_orders` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `supplier_id` BIGINT UNSIGNED NOT NULL,
  `created_by` BIGINT UNSIGNED NOT NULL,
  `order_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `expected_delivery_date` DATE NULL DEFAULT NULL,
  `received_at` DATETIME NULL DEFAULT NULL,
  `status` ENUM('Borrador', 'Enviada', 'Recibida', 'Cancelada') NOT NULL DEFAULT 'Borrador',
  `total_amount` DECIMAL(12,2) NOT NULL DEFAULT 0.00,
  `notes` TEXT NULL DEFAULT NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX `fk_purchase_orders_user` (`created_by` ASC),
  INDEX `fk_purchase_orders_supplier` (`supplier_id` ASC),
  CONSTRAINT `fk_purchase_orders_user`
    FOREIGN KEY (`created_by`)
    REFERENCES `tesaliavet_db`.`users` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_purchase_orders_supplier`
    FOREIGN KEY (`supplier_id`)
    REFERENCES `tesaliavet_db`.`suppliers` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `tesaliavet_db`.`purchase_order_details`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tesaliavet_db`.`purchase_order_details` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `purchase_order_id` BIGINT UNSIGNED NOT NULL,
  `product_id` BIGINT UNSIGNED NOT NULL,
  `quantity_ordered` DECIMAL(10,2) NOT NULL,
  `quantity_received` DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  `unit_cost` DECIMAL(12,2) NOT NULL,
  `subtotal` DECIMAL(12,2) GENERATED ALWAYS AS (quantity_ordered * unit_cost) STORED,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX `fk_pod_order` (`purchase_order_id` ASC),
  INDEX `fk_pod_product` (`product_id` ASC),
  CONSTRAINT `fk_pod_order`
    FOREIGN KEY (`purchase_order_id`)
    REFERENCES `tesaliavet_db`.`purchase_orders` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_pod_product`
    FOREIGN KEY (`product_id`)
    REFERENCES `tesaliavet_db`.`products` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `tesaliavet_db`.`sales_orders`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tesaliavet_db`.`sales_orders` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` BIGINT UNSIGNED NOT NULL,
  `status` ENUM('Pendiente', 'Pagado', 'Entregado', 'Cancelado') NOT NULL DEFAULT 'Pendiente',
  `payment_method` ENUM('Efectivo', 'Tarjeta', 'Transferencia', 'Nequi') NOT NULL,
  `shipping_name` VARCHAR(200) NOT NULL,
  `shipping_phone` VARCHAR(20) NULL DEFAULT NULL,
  `shipping_address` VARCHAR(255) NOT NULL,
  `shipping_city` VARCHAR(100) NOT NULL,
  `subtotal` DECIMAL(12,2) NOT NULL DEFAULT 0.00,
  `tax_total` DECIMAL(12,2) NOT NULL DEFAULT 0.00,
  `total` DECIMAL(12,2) NOT NULL DEFAULT 0.00,
  `notes` TEXT NULL DEFAULT NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX `fk_sales_orders_user` (`user_id` ASC),
  CONSTRAINT `fk_sales_orders_user`
    FOREIGN KEY (`user_id`)
    REFERENCES `tesaliavet_db`.`users` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `tesaliavet_db`.`sales_order_items`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tesaliavet_db`.`sales_order_items` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `order_id` BIGINT UNSIGNED NOT NULL,
  `product_id` BIGINT UNSIGNED NOT NULL,
  `quantity` DECIMAL(10,2) NOT NULL,
  `unit_price` DECIMAL(12,2) NOT NULL,
  `tax_rate` DECIMAL(5,2) NOT NULL,
  `subtotal` DECIMAL(12,2) GENERATED ALWAYS AS (quantity * unit_price) STORED,
  `tax_amount` DECIMAL(12,2) GENERATED ALWAYS AS (quantity * unit_price * (tax_rate / 100)) STORED,
  `total` DECIMAL(12,2) GENERATED ALWAYS AS (quantity * unit_price * (1 + (tax_rate / 100))) STORED,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX `fk_so_items_order` (`order_id` ASC),
  INDEX `fk_so_items_product` (`product_id` ASC),
  CONSTRAINT `fk_so_items_order`
    FOREIGN KEY (`order_id`)
    REFERENCES `tesaliavet_db`.`sales_orders` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_so_items_product`
    FOREIGN KEY (`product_id`)
    REFERENCES `tesaliavet_db`.`products` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `tesaliavet_db`.`invoices`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tesaliavet_db`.`invoices` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `order_id` BIGINT UNSIGNED NOT NULL,
  `invoice_number` VARCHAR(50) NOT NULL,
  `cufe` VARCHAR(100) NULL DEFAULT NULL,
  `issue_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `client_name` VARCHAR(200) NOT NULL,
  `client_document` VARCHAR(50) NOT NULL,
  `client_doc_type` VARCHAR(10) NOT NULL,
  `client_email` VARCHAR(255) NULL DEFAULT NULL,
  `client_address` VARCHAR(255) NULL DEFAULT NULL,
  `subtotal` DECIMAL(12,2) NOT NULL,
  `tax_total` DECIMAL(12,2) NOT NULL,
  `total` DECIMAL(12,2) NOT NULL,
  `status` ENUM('Emitida', 'Anulada') NOT NULL DEFAULT 'Emitida',
  `cancellation_reason` VARCHAR(255) NULL DEFAULT NULL,
  `pdf_path` VARCHAR(255) NULL DEFAULT NULL,
  `pdf_file` LONGBLOB NOT NULL,
  `pdf_mime` VARCHAR(50) NULL DEFAULT 'application/pdf',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE INDEX (`order_id` ASC),
  UNIQUE INDEX (`invoice_number` ASC),
  CONSTRAINT `fk_invoices_order`
    FOREIGN KEY (`order_id`)
    REFERENCES `tesaliavet_db`.`sales_orders` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `tesaliavet_db`.`invoice_items`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tesaliavet_db`.`invoice_items` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `invoice_id` BIGINT UNSIGNED NOT NULL,
  `product_name` VARCHAR(150) NOT NULL,
  `quantity` DECIMAL(10,2) NOT NULL,
  `unit_price` DECIMAL(12,2) NOT NULL,
  `tax_rate` DECIMAL(5,2) NOT NULL,
  `subtotal` DECIMAL(12,2) NOT NULL,
  `tax_amount` DECIMAL(12,2) NOT NULL,
  `total` DECIMAL(12,2) NOT NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX `fk_invoice_items_invoice` (`invoice_id` ASC),
  CONSTRAINT `fk_invoice_items_invoice`
    FOREIGN KEY (`invoice_id`)
    REFERENCES `tesaliavet_db`.`invoices` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `tesaliavet_db`.`payments`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tesaliavet_db`.`payments` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `invoice_id` BIGINT UNSIGNED NOT NULL,
  `amount` DECIMAL(12,2) NOT NULL,
  `payment_method` ENUM('Efectivo', 'Tarjeta', 'Transferencia', 'Nequi', 'Daviplata') NOT NULL,
  `reference` VARCHAR(100) NULL DEFAULT NULL COMMENT 'Número de transacción',
  `paid_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `registered_by` BIGINT UNSIGNED NULL DEFAULT NULL,
  `notes` VARCHAR(255) NULL DEFAULT NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX `fk_payments_invoice` (`invoice_id` ASC),
  INDEX `fk_payments_user` (`registered_by` ASC),
  CONSTRAINT `fk_payments_invoice`
    FOREIGN KEY (`invoice_id`)
    REFERENCES `tesaliavet_db`.`invoices` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_payments_user`
    FOREIGN KEY (`registered_by`)
    REFERENCES `tesaliavet_db`.`users` (`id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `tesaliavet_db`.`supplier_products`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tesaliavet_db`.`supplier_products` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `supplier_id` BIGINT UNSIGNED NOT NULL,
  `product_id` BIGINT UNSIGNED NOT NULL,
  `supplier_sku` VARCHAR(100) NULL DEFAULT NULL,
  `purchase_price` DECIMAL(12,2) NOT NULL,
  `lead_time_days` SMALLINT UNSIGNED NULL DEFAULT NULL COMMENT 'Días estimados de entrega',
  `is_preferred` TINYINT(1) NOT NULL DEFAULT 0 COMMENT 'Proveedor preferido para este producto',
  `is_active` TINYINT(1) NOT NULL DEFAULT 1,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE INDEX (`supplier_id` ASC, `product_id` ASC),
  INDEX `idx_supplier_products_supplier_id` (`supplier_id` ASC),
  INDEX `idx_supplier_products_preferred` (`is_preferred` ASC),
  INDEX `fk_supplier_products_product` (`product_id` ASC),
  CONSTRAINT `fk_supplier_products_supplier`
    FOREIGN KEY (`supplier_id`)
    REFERENCES `tesaliavet_db`.`suppliers` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_supplier_products_product`
    FOREIGN KEY (`product_id`)
    REFERENCES `tesaliavet_db`.`products` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `tesaliavet_db`.`notifications`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tesaliavet_db`.`notifications` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` BIGINT UNSIGNED NOT NULL,
  `type` ENUM('Sistema', 'Cita', 'Compra', 'Vacuna', 'Promocion', 'Stock', 'Factura', 'PQRS') NOT NULL,
  `title` VARCHAR(150) NOT NULL,
  `message` TEXT NOT NULL,
  `is_read` TINYINT(1) NOT NULL DEFAULT 0,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `read_at` DATETIME NULL DEFAULT NULL,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX `idx_notifications_user_date` (`user_id` ASC, `created_at` DESC),
  INDEX `fk_notifications_user` (`user_id` ASC),
  CONSTRAINT `fk_notifications_user`
    FOREIGN KEY (`user_id`)
    REFERENCES `tesaliavet_db`.`users` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `tesaliavet_db`.`system_alerts`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tesaliavet_db`.`system_alerts` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `type` ENUM('Stock Bajo', 'Error', 'Sistema', 'Seguridad') NOT NULL,
  `title` VARCHAR(150) NOT NULL,
  `message` TEXT NOT NULL,
  `is_resolved` TINYINT(1) NOT NULL DEFAULT 0,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `resolved_at` DATETIME NULL DEFAULT NULL,
  `resolved_by` BIGINT UNSIGNED NULL DEFAULT NULL,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX `idx_system_alerts_resolved` (`is_resolved` ASC),
  INDEX `fk_system_alerts_user` (`resolved_by` ASC),
  CONSTRAINT `fk_system_alerts_user`
    FOREIGN KEY (`resolved_by`)
    REFERENCES `tesaliavet_db`.`users` (`id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `tesaliavet_db`.`pqrs`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tesaliavet_db`.`pqrs` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` BIGINT UNSIGNED NULL DEFAULT NULL,
  `sender_name` VARCHAR(150) NOT NULL,
  `sender_email` VARCHAR(255) NOT NULL,
  `sender_phone` VARCHAR(20) NULL DEFAULT NULL,
  `type` ENUM('Peticion', 'Queja', 'Reclamo', 'Sugerencia') NOT NULL,
  `subject` VARCHAR(150) NOT NULL,
  `message` TEXT NOT NULL,
  `status` ENUM('Abierto', 'En Proceso', 'Resuelto', 'Cerrado') NOT NULL DEFAULT 'Abierto',
  `response` TEXT NULL DEFAULT NULL,
  `responded_by` BIGINT UNSIGNED NULL DEFAULT NULL,
  `attachment` LONGBLOB NULL DEFAULT NULL,
  `attachment_mime` VARCHAR(50) NULL DEFAULT NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `responded_at` DATETIME NULL DEFAULT NULL,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX `idx_pqrs_status` (`status` ASC),
  INDEX `idx_pqrs_type` (`type` ASC),
  INDEX `fk_pqrs_user` (`user_id` ASC),
  INDEX `fk_pqrs_admin` (`responded_by` ASC),
  CONSTRAINT `fk_pqrs_user`
    FOREIGN KEY (`user_id`)
    REFERENCES `tesaliavet_db`.`users` (`id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  CONSTRAINT `fk_pqrs_admin`
    FOREIGN KEY (`responded_by`)
    REFERENCES `tesaliavet_db`.`users` (`id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE)
ENGINE = InnoDB;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;


-- ------------------------------------------------------------------
-- TESALIAVET DB – DATOS DE PRUEBA
-- ------------------------------------------------------------------
SET FOREIGN_KEY_CHECKS = 0;
SET UNIQUE_CHECKS = 0;

-- -----------------------------------------------------
-- roles
-- -----------------------------------------------------
INSERT INTO roles (id, name, description) VALUES
(1, 'Admin', 'Acceso total al sistema'),
(2, 'Veterinario', 'Atención médica y gestión de historiales'),
(3, 'Cliente', 'Compra en tienda y gestión de mascotas'),
(4, 'Cajero', 'Gestión de ventas y pagos'),
(5, 'Farmacéutico', 'Control de inventario y productos');

-- -----------------------------------------------------
-- users
-- -----------------------------------------------------
INSERT INTO users (id, tipo_documento, numero_documento, first_name, last_name, email, password_hash, phone, direccion, ciudad, is_active) VALUES
(1, 'CC', '1001', 'Admin', 'Sistema', 'admin@tesaliavet.com', '$2y$10$DUMMYHASHFORADMIN', '3001112233', 'Calle 1 #2-3', 'Bogotá', 1),
(2, 'CC', '2002', 'Laura', 'Gómez', 'vet@tesaliavet.com', '$2y$10$DUMMYHASHFORVET', '3002223344', 'Carrera 4 #5-6', 'Medellín', 1),
(3, 'CC', '3003', 'Juan', 'Pérez', 'juan.perez@example.com', '$2y$10$DUMMYHASHFORUSER', '3114455667', 'Cra 7 #8-9', 'Cali', 1),
(4, 'CC', '4004', 'María', 'Gómez', 'maria.gomez@example.com', '$2y$10$DUMMYHASHFORUSER2', '3225566778', 'Av Siempre Viva #123', 'Bogotá', 1),
(5, 'CC', '5005', 'Carlos', 'Rojas', 'cashier@tesaliavet.com', '$2y$10$DUMMYHASHFORCASH', '3336677889', 'Diagonal 10 #20-30', 'Cali', 1);

-- -----------------------------------------------------
-- user_roles
-- -----------------------------------------------------
INSERT INTO user_roles (user_id, role_id) VALUES
(1, 1),  -- Admin
(2, 2),  -- Veterinario
(3, 3),  -- Cliente
(4, 3),  -- Cliente
(5, 4);  -- Cajero

-- -----------------------------------------------------
-- species
-- -----------------------------------------------------
INSERT INTO species (id, name) VALUES
(1, 'Perro'),
(2, 'Gato');

-- -----------------------------------------------------
-- breeds
-- -----------------------------------------------------
INSERT INTO breeds (id, species_id, name) VALUES
(1, 1, 'Labrador'),
(2, 1, 'Poodle'),
(3, 2, 'Siamés'),
(4, 2, 'Persa');

-- -----------------------------------------------------
-- pets
-- -----------------------------------------------------
INSERT INTO pets (id, owner_id, name, species_id, breed_id, gender, birth_date, weight, color, notes, is_active) VALUES
(1, 3, 'Max', 1, 1, 'Macho', '2020-05-10', 25.50, 'Dorado', 'Muy juguetón', 1),
(2, 4, 'Luna', 2, 3, 'Hembra', '2021-08-15', 4.20, 'Gris', 'Tímida', 1);

-- -----------------------------------------------------
-- medical_records
-- -----------------------------------------------------
INSERT INTO medical_records (id, pet_id, veterinarian_id, visit_date, symptoms, diagnosis, treatment, observations) VALUES
(1, 1, 2, '2023-10-01 09:30:00', 'Tos seca y decaimiento', 'Bronquitis', 'Antibiótico por 7 días', 'Reposo absoluto'),
(2, 2, 2, '2023-11-15 11:00:00', 'Vómito y pérdida de apetito', 'Gastroenteritis', 'Dieta blanda y probióticos', 'Mejoría en 48h');

-- -----------------------------------------------------
-- vaccines
-- -----------------------------------------------------
INSERT INTO vaccines (id, name, description) VALUES
(1, 'Rabia', 'Vacuna antirrábica anual'),
(2, 'Parvovirus', 'Core para perros'),
(3, 'Triple Felina', 'Protege contra panleucopenia, herpes y calicivirus');

-- -----------------------------------------------------
-- pet_vaccinations
-- -----------------------------------------------------
INSERT INTO pet_vaccinations (id, pet_id, vaccine_id, application_date, next_due_date, batch_number, veterinarian_id) VALUES
(1, 1, 1, '2023-01-15', '2024-01-15', 'LOT-123', 2),
(2, 1, 2, '2023-03-10', '2024-03-10', 'LOT-456', 2),
(3, 2, 3, '2023-06-20', '2024-06-20', 'LOT-789', 2);

-- -----------------------------------------------------
-- appointments
-- -----------------------------------------------------
INSERT INTO appointments (id, pet_id, owner_id, veterinarian_id, appointment_datetime, reason, status, notes) VALUES
(1, 1, 3, 2, '2024-03-10 10:00:00', 'Revisión anual y vacunación', 'Confirmada', 'Traer carnet'),
(2, 2, 4, 2, '2024-03-12 11:30:00', 'Control de peso', 'Pendiente', NULL);

-- -----------------------------------------------------
-- categories
-- -----------------------------------------------------
INSERT INTO categories (id, name, description, parent_id) VALUES
(1, 'Medicamentos', 'Fármacos veterinarios', NULL),
(2, 'Alimentos', 'Concentrados y snacks', NULL),
(3, 'Accesorios', 'Juguetes, camas, collares', NULL),
(4, 'Antiparasitarios', 'Pipetas y comprimidos', 1);

-- -----------------------------------------------------
-- products
-- -----------------------------------------------------
INSERT INTO products (id, category_id, sku, barcode, name, description, purchase_price, selling_price, stock, min_stock, tax_rate, is_active) VALUES
(1, 1, 'MED-001', '7701234567890', 'Amoxicilina 500mg', 'Antibiótico de amplio espectro', 10.00, 25.00, 50, 10, 19.00, 1),
(2, 2, 'ALI-001', '7709876543210', 'Concentrado Premium Perro Adulto', 'Alimento balanceado 15kg', 40.00, 70.00, 30, 5, 0.00, 1),
(3, 3, 'ACC-001', '7701112223334', 'Collar Antipulgas', 'Collar repelente de 3 meses', 8.00, 15.00, 20, 5, 19.00, 1);

-- -----------------------------------------------------
-- product_images (opcional, se omite para brevedad)
-- -----------------------------------------------------

-- -----------------------------------------------------
-- stock_alerts (para producto con stock bajo)
-- -----------------------------------------------------
INSERT INTO stock_alerts (id, product_id, current_stock, min_stock, status) VALUES
(1, 2, 3, 5, 'Activa');   -- Concentrado con stock por debajo del mínimo

-- -----------------------------------------------------
-- carts
-- -----------------------------------------------------
INSERT INTO carts (id, user_id, status) VALUES
(1, 3, 'Activo');   -- Carrito activo de Juan Pérez

-- -----------------------------------------------------
-- cart_items
-- -----------------------------------------------------
INSERT INTO cart_items (id, cart_id, product_id, quantity, unit_price) VALUES
(1, 1, 1, 2, 25.00);   -- 2 unidades de Amoxicilina

-- -----------------------------------------------------
-- suppliers
-- -----------------------------------------------------
INSERT INTO suppliers (id, name, document_type, document_number, primary_contact_name, primary_contact_phone, primary_contact_email, address, city) VALUES
(1, 'Distribuidora Vet S.A.S', 'NIT', '901234567-1', 'Pedro López', '6012345678', 'pedro@vetdistribuye.com', 'Calle 100 #20-30', 'Bogotá'),
(2, 'Alimentos SAS', 'NIT', '987654321-0', 'Ana Torres', '6018765432', 'compras@alimentossas.com', 'Cra 50 #10-80', 'Cali');

-- -----------------------------------------------------
-- purchase_orders
-- -----------------------------------------------------
INSERT INTO purchase_orders (id, supplier_id, created_by, order_date, expected_delivery_date, received_at, status, total_amount) VALUES
(1, 1, 1, '2024-02-01 08:00:00', '2024-02-10', '2024-02-09 15:30:00', 'Recibida', 200.00);

-- -----------------------------------------------------
-- purchase_order_details
-- -----------------------------------------------------
INSERT INTO purchase_order_details (id, purchase_order_id, product_id, quantity_ordered, quantity_received, unit_cost) VALUES
(1, 1, 1, 20, 20, 10.00);

-- -----------------------------------------------------
-- sales_orders
-- -----------------------------------------------------
INSERT INTO sales_orders (id, user_id, status, payment_method, shipping_name, shipping_phone, shipping_address, shipping_city, subtotal, tax_total, total, notes) VALUES
(1, 3, 'Pagado', 'Tarjeta', 'Juan Pérez', '3114455667', 'Cra 7 #8-9', 'Cali', 50.00, 9.50, 59.50, 'Entregar en horario de oficina');

-- -----------------------------------------------------
-- sales_order_items
-- -----------------------------------------------------
INSERT INTO sales_order_items (id, order_id, product_id, quantity, unit_price, tax_rate) VALUES
(1, 1, 1, 2, 25.00, 19.00);

-- -----------------------------------------------------
-- invoices
-- -----------------------------------------------------
INSERT INTO invoices (id, order_id, invoice_number, cufe, issue_date, client_name, client_document, client_doc_type, client_email, client_address, subtotal, tax_total, total, status, pdf_file, pdf_mime) VALUES
(1, 1, 'INV-001', 'CUFE-ABCD1234', '2024-02-20 10:00:00', 'Juan Pérez', '3003', 'CC', 'juan.perez@example.com', 'Cra 7 #8-9', 50.00, 9.50, 59.50, 'Emitida', 'PDF_CONTENT_DUMMY', 'application/pdf');

-- -----------------------------------------------------
-- invoice_items
-- -----------------------------------------------------
INSERT INTO invoice_items (id, invoice_id, product_name, quantity, unit_price, tax_rate, subtotal, tax_amount, total) VALUES
(1, 1, 'Amoxicilina 500mg', 2, 25.00, 19.00, 50.00, 9.50, 59.50);

-- -----------------------------------------------------
-- payments
-- -----------------------------------------------------
INSERT INTO payments (id, invoice_id, amount, payment_method, reference, paid_at, registered_by) VALUES
(1, 1, 59.50, 'Tarjeta', 'TRX-123456', '2024-02-20 10:05:00', 5);

-- -----------------------------------------------------
-- supplier_products
-- -----------------------------------------------------
INSERT INTO supplier_products (id, supplier_id, product_id, supplier_sku, purchase_price, lead_time_days, is_preferred) VALUES
(1, 1, 1, 'SUP-MED001', 9.50, 5, 1),
(2, 2, 2, 'ALI-PRO-15', 38.00, 7, 1);

-- -----------------------------------------------------
-- notifications
-- -----------------------------------------------------
INSERT INTO notifications (id, user_id, type, title, message, is_read) VALUES
(1, 3, 'Cita', 'Recordatorio de cita', 'Tiene una cita agendada para el 10 de marzo con su mascota Max', 0);

-- -----------------------------------------------------
-- system_alerts
-- -----------------------------------------------------
INSERT INTO system_alerts (id, type, title, message, is_resolved) VALUES
(1, 'Stock Bajo', 'Stock crítico de Concentrado Premium', 'El producto Concentrado Premium (ID 2) tiene stock 3, mínimo 5', 0);

-- -----------------------------------------------------
-- pqrs
-- -----------------------------------------------------
INSERT INTO pqrs (id, user_id, sender_name, sender_email, sender_phone, type, subject, message, status) VALUES
(1, 3, 'Juan Pérez', 'juan.perez@example.com', '3114455667', 'Queja', 'Demora en atención', 'Mi cita fue reprogramada sin previo aviso', 'Abierto');

SET FOREIGN_KEY_CHECKS = 1;
SET UNIQUE_CHECKS = 1;