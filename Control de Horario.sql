-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema ControlDeHorario
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema ControlDeHorario
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `ControlDeHorario` DEFAULT CHARACTER SET utf8 COLLATE utf8_bin ;
USE `ControlDeHorario` ;

-- -----------------------------------------------------
-- Table `ControlDeHorario`.`Estados`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ControlDeHorario`.`Estados` (
  `Estado_ID` TINYINT(2) UNSIGNED NOT NULL AUTO_INCREMENT,
  `Estado_Descripcion` VARCHAR(50) NULL,
  PRIMARY KEY (`Estado_ID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ControlDeHorario`.`PoliticaHoraria`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ControlDeHorario`.`PoliticaHoraria` (
  `PoliticaHoraria_ID` SMALLINT(5) UNSIGNED NOT NULL AUTO_INCREMENT,
  `PH_HorarioFlexible` BIT(1) NULL,
  `PH_Nombre` VARCHAR(60) NULL,
  `PH_Estado` BIT(1) NULL DEFAULT 1,
  PRIMARY KEY (`PoliticaHoraria_ID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ControlDeHorario`.`Categorias`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ControlDeHorario`.`Categorias` (
  `Categoria_ID` SMALLINT(4) UNSIGNED NOT NULL,
  `Categoria_Nombre` VARCHAR(60) NULL,
  PRIMARY KEY (`Categoria_ID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ControlDeHorario`.`Sectores`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ControlDeHorario`.`Sectores` (
  `Sector_ID` SMALLINT(3) UNSIGNED NOT NULL,
  `Sector_Nombre` VARCHAR(60) NULL,
  PRIMARY KEY (`Sector_ID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ControlDeHorario`.`Paises`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ControlDeHorario`.`Paises` (
  `Pais_ID` TINYINT(3) UNSIGNED NOT NULL AUTO_INCREMENT,
  `Pais_Nombre` VARCHAR(45) NULL,
  PRIMARY KEY (`Pais_ID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ControlDeHorario`.`Provincias`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ControlDeHorario`.`Provincias` (
  `Provincia_ID` MEDIUMINT(8) UNSIGNED NOT NULL AUTO_INCREMENT,
  `Provincia_PaisID` TINYINT(3) UNSIGNED NOT NULL,
  `Provincia_Nombre` VARCHAR(60) NULL,
  PRIMARY KEY (`Provincia_ID`),
  INDEX `FK_Provincia_Pais_idx` (`Provincia_PaisID` ASC) ,
  CONSTRAINT `FK_Provincia_Pais`
    FOREIGN KEY (`Provincia_PaisID`)
    REFERENCES `ControlDeHorario`.`Paises` (`Pais_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ControlDeHorario`.`Localidades`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ControlDeHorario`.`Localidades` (
  `Localidad_ID` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Localidad_ProvinciaID` MEDIUMINT(8) UNSIGNED NOT NULL,
  `Localidad_Nombre` VARCHAR(100) NULL,
  PRIMARY KEY (`Localidad_ID`),
  INDEX `FK_Localidad_Provincia_idx` (`Localidad_ProvinciaID` ASC) ,
  CONSTRAINT `FK_Localidad_Provincia`
    FOREIGN KEY (`Localidad_ProvinciaID`)
    REFERENCES `ControlDeHorario`.`Provincias` (`Provincia_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ControlDeHorario`.`Empleado`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ControlDeHorario`.`Empleado` (
  `Empleado_ID` INT UNSIGNED NOT NULL,
  `Empleado_Apellido` VARCHAR(60) NULL,
  `Empleado_Nombre` VARCHAR(100) NULL,
  `Empleado_FechaNac` DATE NULL,
  `Empleado_FechaAlta` DATE NULL,
  `Empleado_FechaBaja` DATE NULL,
  `Empleado_EstadoID` TINYINT(2) UNSIGNED NULL DEFAULT 1,
  `Empleado_LocalidadID` INT UNSIGNED NOT NULL,
  `Empleado_CategoriaID` SMALLINT(4) UNSIGNED NULL,
  `Empleado_Sector` SMALLINT(3) UNSIGNED NULL,
  `Empleado_Salario` DECIMAL(10,2) UNSIGNED NULL DEFAULT 0,
  `Empleado_PoliticaHorariaID` SMALLINT(4) UNSIGNED NULL,
  `Empleado_Domicilio` VARCHAR(150) NULL,
  `Empleado_Email` VARCHAR(80) NULL,
  `Empleado_Telefono` VARCHAR(25) NULL,
  PRIMARY KEY (`Empleado_ID`),
  INDEX `FK_Empleado_Estado_idx` (`Empleado_EstadoID` ASC) ,
  INDEX `FK_Empleado_PH_idx` (`Empleado_PoliticaHorariaID` ASC) ,
  INDEX `FK_Empleado_Categoria_idx` (`Empleado_CategoriaID` ASC) ,
  INDEX `FK_Empleado_Sector_idx` (`Empleado_Sector` ASC) ,
  INDEX `FK_Empleado_Localidad_idx` (`Empleado_LocalidadID` ASC) ,
  CONSTRAINT `FK_Empleado_Estado`
    FOREIGN KEY (`Empleado_EstadoID`)
    REFERENCES `ControlDeHorario`.`Estados` (`Estado_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FK_Empleado_PH`
    FOREIGN KEY (`Empleado_PoliticaHorariaID`)
    REFERENCES `ControlDeHorario`.`PoliticaHoraria` (`PoliticaHoraria_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FK_Empleado_Categoria`
    FOREIGN KEY (`Empleado_CategoriaID`)
    REFERENCES `ControlDeHorario`.`Categorias` (`Categoria_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FK_Empleado_Sector`
    FOREIGN KEY (`Empleado_Sector`)
    REFERENCES `ControlDeHorario`.`Sectores` (`Sector_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FK_Empleado_Localidad`
    FOREIGN KEY (`Empleado_LocalidadID`)
    REFERENCES `ControlDeHorario`.`Localidades` (`Localidad_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ControlDeHorario`.`PoliticaHoraria_Detalle`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ControlDeHorario`.`PoliticaHoraria_Detalle` (
  `PH_DetalleID` MEDIUMINT(6) UNSIGNED NOT NULL AUTO_INCREMENT,
  `PHD_PHID` SMALLINT(2) UNSIGNED NOT NULL,
  `PHD_DiaSemana` TINYINT(1) UNSIGNED NULL,
  `PHD_HoraDia` TIME NULL,
  `PHD_HoraHora` TIME NULL,
  `PHD_Horas` TINYINT(2) UNSIGNED NULL DEFAULT 0,
  PRIMARY KEY (`PH_DetalleID`),
  INDEX `FK_PHD_PH_idx` (`PHD_PHID` ASC) ,
  CONSTRAINT `FK_PHD_PH`
    FOREIGN KEY (`PHD_PHID`)
    REFERENCES `ControlDeHorario`.`PoliticaHoraria` (`PoliticaHoraria_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ControlDeHorario`.`ControlHorario_Movimientos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ControlDeHorario`.`ControlHorario_Movimientos` (
  `CHM_ID` BIGINT(10) UNSIGNED NOT NULL,
  `CHM_Fecha` DATE NULL,
  `CHM_Hora` TIME NULL,
  `CHM_EmpleadoID` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`CHM_ID`),
  INDEX `Fecha` (`CHM_Fecha` ASC) ,
  INDEX `FechaEmpleado` (`CHM_Fecha` ASC, `CHM_EmpleadoID` ASC) ,
  INDEX `FK_CHM_Empleado_idx` (`CHM_EmpleadoID` ASC) ,
  CONSTRAINT `FK_CHM_Empleado`
    FOREIGN KEY (`CHM_EmpleadoID`)
    REFERENCES `ControlDeHorario`.`Empleado` (`Empleado_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ControlDeHorario`.`ControHorario_Resumen`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ControlDeHorario`.`ControHorario_Resumen` (
  `CHR_ID` BIGINT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `CHR_Fecha` DATE NULL,
  `CHR_EmpleadoID` INT UNSIGNED NOT NULL,
  `CHR_Horas` TINYINT(2) NULL,
  PRIMARY KEY (`CHR_ID`),
  INDEX `Fecha` (`CHR_Fecha` ASC) ,
  INDEX `FechaEmpleado` (`CHR_Fecha` ASC, `CHR_EmpleadoID` ASC) ,
  INDEX `FK_CHR_Empleado_idx` (`CHR_EmpleadoID` ASC) ,
  CONSTRAINT `FK_CHR_Empleado`
    FOREIGN KEY (`CHR_EmpleadoID`)
    REFERENCES `ControlDeHorario`.`Empleado` (`Empleado_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ControlDeHorario`.`Infracciones`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ControlDeHorario`.`Infracciones` (
  `Infraccion_ID` SMALLINT(3) UNSIGNED NOT NULL AUTO_INCREMENT,
  `Infraccion_Nombre` VARCHAR(60) NULL,
  PRIMARY KEY (`Infraccion_ID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ControlDeHorario`.`ControlHorario_Novedades`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ControlDeHorario`.`ControlHorario_Novedades` (
  `CHN_ID` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `CHN_Fecha` DATE NULL,
  `CHN_InfraccionID` SMALLINT(3) UNSIGNED NOT NULL,
  `CHN_EmpleadoID` INT UNSIGNED NOT NULL,
  `CHN_Horas` TINYINT(1) UNSIGNED NULL,
  `CHN_Minutos` TINYINT(3) UNSIGNED NULL,
  PRIMARY KEY (`CHN_ID`),
  INDEX `Fecha` (`CHN_Fecha` ASC) ,
  INDEX `Empleado` (`CHN_EmpleadoID` ASC) ,
  INDEX `FechaEmpleado` (`CHN_EmpleadoID` ASC, `CHN_Fecha` ASC) ,
  INDEX `FK_CHN_Infraccion_idx` (`CHN_InfraccionID` ASC) ,
  CONSTRAINT `FK_CHN_Empleado`
    FOREIGN KEY (`CHN_EmpleadoID`)
    REFERENCES `ControlDeHorario`.`Empleado` (`Empleado_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FK_CHN_Infraccion`
    FOREIGN KEY (`CHN_InfraccionID`)
    REFERENCES `ControlDeHorario`.`Infracciones` (`Infraccion_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ControlDeHorario`.`Novedades`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ControlDeHorario`.`Novedades` (
  `Novedad_ID` SMALLINT(4) UNSIGNED NOT NULL AUTO_INCREMENT,
  `Novedad_Descripcion` VARCHAR(80) NULL,
  PRIMARY KEY (`Novedad_ID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ControlDeHorario`.`ControlHorario_Excepciones`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ControlDeHorario`.`ControlHorario_Excepciones` (
  `CHE_ID` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `CHE_EmpleadoID` INT UNSIGNED NOT NULL,
  `CHE_FechaDesde` DATE NULL,
  `CHE_FechaHasta` DATE NULL,
  `CHE_NovedadID` SMALLINT(4) UNSIGNED NOT NULL,
  `CHE_Horas` SMALLINT(5) NULL,
  PRIMARY KEY (`CHE_ID`),
  INDEX `FK_CHE_Empleado_idx` (`CHE_EmpleadoID` ASC) ,
  INDEX `FK_CHE_Excepcion_idx` (`CHE_NovedadID` ASC) ,
  CONSTRAINT `FK_CHE_Empleado`
    FOREIGN KEY (`CHE_EmpleadoID`)
    REFERENCES `ControlDeHorario`.`Empleado` (`Empleado_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FK_CHE_Novedad`
    FOREIGN KEY (`CHE_NovedadID`)
    REFERENCES `ControlDeHorario`.`Novedades` (`Novedad_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
