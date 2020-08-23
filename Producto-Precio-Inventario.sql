-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema SistemaDeInventario
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema SistemaDeInventario
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `SistemaDeInventario` DEFAULT CHARACTER SET utf8 ;
USE `SistemaDeInventario` ;

-- -----------------------------------------------------
-- Table `SistemaDeInventario`.`Productos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `SistemaDeInventario`.`Productos` (
  `Prod_ID` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Prod_Descripcion` VARCHAR(80) NULL,
  `Prod_ColorID` SMALLINT(4) UNSIGNED NULL,
  `Prod_UnimedID` SMALLINT(2) UNSIGNED NULL,
  `Prod_Medida` DECIMAL(6,2) UNSIGNED NULL,
  `Prod_ProvID` INT UNSIGNED NOT NULL,
  `Prod_CompraSusp` BIT(1) NULL,
  `Prod_VentaSusp` BIT(1) NULL,
  `Prod_Status` CHAR(1) NULL,
  PRIMARY KEY (`Prod_ID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `SistemaDeInventario`.`Sucursales`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `SistemaDeInventario`.`Sucursales` (
  `Sucursal_ID` SMALLINT(3) UNSIGNED NOT NULL,
  `Sucursal_Nombre` VARCHAR(50) NULL,
  `Sucursal_Status` CHAR(1) NULL,
  PRIMARY KEY (`Sucursal_ID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `SistemaDeInventario`.`Depositos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `SistemaDeInventario`.`Depositos` (
  `Depo_ID` SMALLINT(4) UNSIGNED NOT NULL AUTO_INCREMENT,
  `Depo_SucursalID` SMALLINT(3) UNSIGNED NOT NULL,
  `Depo_Status` CHAR(1) NULL,
  `Depo_Nombre` VARCHAR(45) NULL,
  PRIMARY KEY (`Depo_ID`),
  INDEX `FK_Depo_Sucursales_idx` (`Depo_SucursalID` ASC) ,
  CONSTRAINT `FK_Depo_Sucursales`
    FOREIGN KEY (`Depo_SucursalID`)
    REFERENCES `SistemaDeInventario`.`Sucursales` (`Sucursal_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `SistemaDeInventario`.`DepSecciones`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `SistemaDeInventario`.`DepSecciones` (
  `DPS_ID` MEDIUMINT(6) UNSIGNED NOT NULL,
  `DPS_DepID` SMALLINT(4) UNSIGNED NOT NULL,
  `DPS_Nombre` VARCHAR(45) NULL,
  `DPS_Status` CHAR(1) NULL,
  PRIMARY KEY (`DPS_ID`),
  INDEX `FK_DS_Depo_idx` (`DPS_DepID` ASC) ,
  CONSTRAINT `FK_DS_Depo`
    FOREIGN KEY (`DPS_DepID`)
    REFERENCES `SistemaDeInventario`.`Depositos` (`Depo_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `SistemaDeInventario`.`Racks`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `SistemaDeInventario`.`Racks` (
  `Rack_ID` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Rack_DPSID` MEDIUMINT(6) UNSIGNED NOT NULL,
  `Rack_Nro` MEDIUMINT(4) UNSIGNED NULL,
  `Rack_Filas` TINYINT(2) UNSIGNED NULL,
  `Rack_Columnas` TINYINT(3) NULL,
  `Rack_Status` CHAR(1) NULL,
  PRIMARY KEY (`Rack_ID`),
  INDEX `FK_Rack_DS_idx` (`Rack_DPSID` ASC) ,
  CONSTRAINT `FK_Rack_DS`
    FOREIGN KEY (`Rack_DPSID`)
    REFERENCES `SistemaDeInventario`.`DepSecciones` (`DPS_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `SistemaDeInventario`.`StockDetalle`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `SistemaDeInventario`.`StockDetalle` (
  `STD_ID` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `STD_ProdID` INT UNSIGNED NOT NULL,
  `STD_RackID` INT UNSIGNED NOT NULL,
  `STD_Fila` TINYINT(2) UNSIGNED NULL,
  `STD_Columna` TINYINT(3) UNSIGNED NULL,
  `STD_Stock` MEDIUMINT(5) NULL,
  `STD_UltimoMov` DATE NULL,
  `STD_UltimoInventario` DATE NULL,
  PRIMARY KEY (`STD_ID`),
  INDEX `FechaUltMov` (`STD_UltimoMov` ASC) ,
  INDEX `FechaUltInv` (`STD_UltimoInventario` ASC) ,
  UNIQUE INDEX `RackFilaColumna` (`STD_RackID` ASC, `STD_Fila` ASC, `STD_Columna` ASC) ,
  UNIQUE INDEX `ProdRackFilaColumna` (`STD_ProdID` ASC, `STD_RackID` ASC, `STD_Fila` ASC, `STD_Columna` ASC) ,
  CONSTRAINT `FK_STD_Prod`
    FOREIGN KEY (`STD_ProdID`)
    REFERENCES `SistemaDeInventario`.`Productos` (`Prod_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FK_STD_Rack`
    FOREIGN KEY (`STD_RackID`)
    REFERENCES `SistemaDeInventario`.`Racks` (`Rack_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `SistemaDeInventario`.`Mapa`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `SistemaDeInventario`.`Mapa` (
  `Mapa_ID` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Mapa_RackID` INT UNSIGNED NOT NULL,
  `Mapa_Fila` SMALLINT(2) UNSIGNED NULL,
  `Mapa_Columna` SMALLINT(3) UNSIGNED NULL,
  `Mapa_ProdID` INT UNSIGNED NOT NULL,
  `Mapa_Cantidad` MEDIUMINT(5) UNSIGNED NULL,
  PRIMARY KEY (`Mapa_ID`),
  INDEX `FK_Mapa_Racks_idx` (`Mapa_RackID` ASC) ,
  CONSTRAINT `FK_Mapa_Racks`
    FOREIGN KEY (`Mapa_RackID`)
    REFERENCES `SistemaDeInventario`.`Racks` (`Rack_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `SistemaDeInventario`.`StockMaestra`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `SistemaDeInventario`.`StockMaestra` (
  `STM_ProdID` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `STM_Stock` INT NULL,
  `STM_Status` CHAR(1) NULL,
  `STM_UltimoMov` DATE NULL,
  `STM_UltimoInventario` DATE NULL,
  PRIMARY KEY (`STM_ProdID`),
  INDEX `FechaUltimoMov` (`STM_UltimoMov` ASC) ,
  INDEX `FechaUltimoInv` (`STM_UltimoInventario` ASC) ,
  CONSTRAINT `FK_STN_Prod`
    FOREIGN KEY (`STM_ProdID`)
    REFERENCES `SistemaDeInventario`.`Productos` (`Prod_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `SistemaDeInventario`.`StockHistoricoAño`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `SistemaDeInventario`.`StockHistoricoAño` (
  `SH_ID` BIGINT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `SH_Mes` TINYINT(2) UNSIGNED NULL,
  `SH_ProdID` INT UNSIGNED NULL,
  `SH_DepoID` SMALLINT(4) UNSIGNED NULL,
  `SH_Stock` INT NULL,
  `SH_Costo` DECIMAL(10,2) UNSIGNED NULL,
  PRIMARY KEY (`SH_ID`),
  INDEX `Mes` (`SH_Mes` ASC) ,
  INDEX `FK_SH_Productos_idx` (`SH_ProdID` ASC) ,
  INDEX `FK_SH_Depositos_idx` (`SH_DepoID` ASC) ,
  CONSTRAINT `FK_SH_Productos`
    FOREIGN KEY (`SH_ProdID`)
    REFERENCES `SistemaDeInventario`.`Productos` (`Prod_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FK_SH_Depositos`
    FOREIGN KEY (`SH_DepoID`)
    REFERENCES `SistemaDeInventario`.`Depositos` (`Depo_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `SistemaDeInventario`.`StockMovDetAñoMes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `SistemaDeInventario`.`StockMovDetAñoMes` (
  `SMD_ID` BIGINT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `SMD_Fecha` DATETIME NULL,
  `SMD_Mov` CHAR(1) NULL,
  `SMD_ProdID` INT UNSIGNED NULL,
  `SMD_RackID` INT UNSIGNED NOT NULL,
  `SMD_Cantidad` MEDIUMINT(5) NULL,
  PRIMARY KEY (`SMD_ID`),
  INDEX `Fecha` (`SMD_Fecha` ASC) ,
  INDEX `FK_SMAM_Racks_idx` (`SMD_RackID` ASC) ,
  INDEX `FK_SMAM_Prod_idx` (`SMD_ProdID` ASC) ,
  CONSTRAINT `FK_SMAM_Racks`
    FOREIGN KEY (`SMD_RackID`)
    REFERENCES `SistemaDeInventario`.`Racks` (`Rack_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FK_SMAM_Prod`
    FOREIGN KEY (`SMD_ProdID`)
    REFERENCES `SistemaDeInventario`.`Productos` (`Prod_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `SistemaDeInventario`.`ListaCostosPrecios`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `SistemaDeInventario`.`ListaCostosPrecios` (
  `LCP_ID` SMALLINT(4) UNSIGNED NOT NULL AUTO_INCREMENT,
  `LCP_Nombre` VARCHAR(45) NULL,
  `LCP_CP` ENUM('C', 'P') NULL,
  `LCP_Status` CHAR(1) NULL,
  `LCP_FechaDesde` DATE NULL,
  `LCP_FechaHasta` DATE NULL,
  PRIMARY KEY (`LCP_ID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `SistemaDeInventario`.`Costos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `SistemaDeInventario`.`Costos` (
  `Costo_ID` BIGINT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `Costo_LCPID` SMALLINT(4) UNSIGNED NULL,
  `Costo_ProdID` INT UNSIGNED NULL,
  `Costo_PrecioLista` DECIMAL(10,4) UNSIGNED NULL,
  `Costo_Cotizacion` DECIMAL(10,4) UNSIGNED NULL DEFAULT 1,
  `Costo_MonedaCorriente` DECIMAL(10,4) UNSIGNED NULL,
  `Costo_Descuento1` DECIMAL(4,2) NULL,
  `Costo_Descuento2` DECIMAL(4,2) NULL,
  `Costo_Descuento3` DECIMAL(4,2) NULL,
  `Costo_Descuento4` DECIMAL(4,2) NULL,
  `Costo_Descuento` DECIMAL(4,2) NULL,
  `Costo_Transporte` DECIMAL(4,2) NULL,
  `Costo_Impuesto` DECIMAL(4,2) NULL,
  `Costo_ConIVA` DECIMAL(10,4) NULL,
  `Costo_SinIVA` DECIMAL(10,4) NULL,
  `Costo_Fecha` DATETIME NULL,
  PRIMARY KEY (`Costo_ID`),
  INDEX `FK_Costo_LCP_idx` (`Costo_LCPID` ASC) ,
  INDEX `FK_Costo_Producto_idx` (`Costo_ProdID` ASC) ,
  CONSTRAINT `FK_Costo_LCP`
    FOREIGN KEY (`Costo_LCPID`)
    REFERENCES `SistemaDeInventario`.`ListaCostosPrecios` (`LCP_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FK_Costo_Producto`
    FOREIGN KEY (`Costo_ProdID`)
    REFERENCES `SistemaDeInventario`.`Productos` (`Prod_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `SistemaDeInventario`.`CostoHistorial`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `SistemaDeInventario`.`CostoHistorial` (
  `CostoHistorial_ID` BIGINT(10) UNSIGNED NOT NULL,
  `CH_CostoID` BIGINT(10) UNSIGNED NULL,
  `CH_Fecha` DATETIME NULL,
  `CH_Campo` TINYINT(2) NULL,
  `CH_valorAnt` DECIMAL(10,4) NULL,
  `CH_ValorPos` DECIMAL(10,4) NULL,
  PRIMARY KEY (`CostoHistorial_ID`),
  INDEX `CostoID_Fecha` (`CH_CostoID` ASC, `CH_Fecha` ASC) ,
  INDEX `CostoID_Campo` (`CH_CostoID` ASC, `CH_Campo` ASC) ,
  CONSTRAINT `FK_CH_Costo`
    FOREIGN KEY (`CH_CostoID`)
    REFERENCES `SistemaDeInventario`.`Costos` (`Costo_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `SistemaDeInventario`.`Precios`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `SistemaDeInventario`.`Precios` (
  `Precio_ID` BIGINT(10) UNSIGNED NOT NULL,
  `Precio_LCPID` SMALLINT(4) UNSIGNED NULL,
  `Precio_ProdID` INT UNSIGNED NULL,
  `Precio_Margen` DECIMAL(5,2) NULL,
  `Precio_Precio` DECIMAL(10,4) NULL,
  PRIMARY KEY (`Precio_ID`),
  INDEX `FK_Precio_LCP_idx` (`Precio_LCPID` ASC) ,
  INDEX `FK_Precio_Prod_idx` (`Precio_ProdID` ASC) ,
  CONSTRAINT `FK_Precio_LCP`
    FOREIGN KEY (`Precio_LCPID`)
    REFERENCES `SistemaDeInventario`.`ListaCostosPrecios` (`LCP_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FK_Precio_Prod`
    FOREIGN KEY (`Precio_ProdID`)
    REFERENCES `SistemaDeInventario`.`Productos` (`Prod_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `SistemaDeInventario`.`PreciosHistorial`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `SistemaDeInventario`.`PreciosHistorial` (
  `PreciosHistorial_ID` BIGINT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `PrecioH_PrecioID` BIGINT(10) UNSIGNED NULL,
  `PreciosH_Fecha` DATETIME NULL,
  `PreciosH_MargenAnt` DECIMAL(5,2) UNSIGNED NULL,
  `PreciosH_MargenPos` DECIMAL(5,2) UNSIGNED NULL,
  `PrecioH_PrecioAnt` DECIMAL(10,4) UNSIGNED NULL,
  `PrecioH_PrecioPos` DECIMAL(10,4) UNSIGNED NULL,
  PRIMARY KEY (`PreciosHistorial_ID`),
  INDEX `PrecioID_Fecha` (`PrecioH_PrecioID` ASC, `PreciosH_Fecha` ASC) ,
  CONSTRAINT `FK_PH_Precio`
    FOREIGN KEY (`PrecioH_PrecioID`)
    REFERENCES `SistemaDeInventario`.`Precios` (`Precio_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
