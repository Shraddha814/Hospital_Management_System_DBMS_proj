-- MySQL dump 10.13  Distrib 8.0.45, for Win64 (x86_64)
--
-- Host: localhost    Database: hospitaldb
-- ------------------------------------------------------
-- Server version	8.0.45

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `check_up`
--

DROP TABLE IF EXISTS `check_up`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `check_up` (
  `P_No` int NOT NULL,
  `Doc_No` int NOT NULL,
  `Checkup_Date` date NOT NULL DEFAULT (curdate()),
  `Diagnosis` varchar(200) DEFAULT NULL,
  `Status` varchar(20) DEFAULT NULL,
  `Treatment` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`P_No`,`Doc_No`,`Checkup_Date`),
  KEY `Doc_No` (`Doc_No`),
  CONSTRAINT `check_up_ibfk_1` FOREIGN KEY (`P_No`) REFERENCES `patient` (`P_No`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `check_up_ibfk_2` FOREIGN KEY (`Doc_No`) REFERENCES `doctors` (`Doc_No`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `check_up_chk_1` CHECK ((`Status` in (_utf8mb4'Ongoing',_utf8mb4'Completed')))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `check_up`
--

LOCK TABLES `check_up` WRITE;
/*!40000 ALTER TABLE `check_up` DISABLE KEYS */;
INSERT INTO `check_up` VALUES (1,101,'2026-04-02','Heart Issue','Completed','Medication'),(2,102,'2026-04-03','Migraine','Ongoing','Therapy'),(3,103,'2026-04-04','Fracture','Completed','Surgery'),(4,104,'2026-04-05','Fever','Completed','Medication');
/*!40000 ALTER TABLE `check_up` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `department`
--

DROP TABLE IF EXISTS `department`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `department` (
  `D_Name` varchar(50) NOT NULL,
  `D_Location` varchar(100) NOT NULL,
  `Facilities` varchar(100) DEFAULT 'Basic',
  PRIMARY KEY (`D_Name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `department`
--

LOCK TABLES `department` WRITE;
/*!40000 ALTER TABLE `department` DISABLE KEYS */;
INSERT INTO `department` VALUES ('Cardiology','Block A','Advanced'),('General','Block E','Basic'),('Neurology','Block B','ICU'),('Orthopedics','Block C','Surgery'),('Pediatrics','Block D','Basic');
/*!40000 ALTER TABLE `department` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `doctors`
--

DROP TABLE IF EXISTS `doctors`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `doctors` (
  `Doc_No` int NOT NULL,
  `First_Name` varchar(50) DEFAULT NULL,
  `Last_Name` varchar(50) DEFAULT NULL,
  `Ph_No` varchar(15) DEFAULT NULL,
  `Qualification` varchar(100) DEFAULT NULL,
  `Salary` decimal(10,2) DEFAULT NULL,
  `D_Name` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`Doc_No`),
  UNIQUE KEY `Ph_No` (`Ph_No`),
  KEY `D_Name` (`D_Name`),
  CONSTRAINT `doctors_ibfk_1` FOREIGN KEY (`D_Name`) REFERENCES `department` (`D_Name`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `doctors_chk_1` CHECK ((`Salary` > 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `doctors`
--

LOCK TABLES `doctors` WRITE;
/*!40000 ALTER TABLE `doctors` DISABLE KEYS */;
INSERT INTO `doctors` VALUES (101,'Raj','Sharma','9123456780','MD',80000.00,'Cardiology'),(102,'Neha','Verma','9123456781','MBBS',60000.00,'Neurology'),(103,'Arjun','Patel','9123456782','MS',75000.00,'Orthopedics'),(104,'Priya','Singh','9123456783','MD',70000.00,'Pediatrics'),(105,'Karan','Mehta','9123456784','MBBS',50000.00,'General');
/*!40000 ALTER TABLE `doctors` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `operate_on`
--

DROP TABLE IF EXISTS `operate_on`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `operate_on` (
  `P_No` int NOT NULL,
  `Doc_No` int NOT NULL,
  `Operation_Date` date NOT NULL DEFAULT (curdate()),
  `Operation_Type` varchar(100) DEFAULT NULL,
  `Result` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`P_No`,`Doc_No`,`Operation_Date`),
  KEY `Doc_No` (`Doc_No`),
  CONSTRAINT `operate_on_ibfk_1` FOREIGN KEY (`P_No`) REFERENCES `patient` (`P_No`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `operate_on_ibfk_2` FOREIGN KEY (`Doc_No`) REFERENCES `doctors` (`Doc_No`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `operate_on_chk_1` CHECK ((`Result` in (_utf8mb4'Success',_utf8mb4'Failure',_utf8mb4'Pending')))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `operate_on`
--

LOCK TABLES `operate_on` WRITE;
/*!40000 ALTER TABLE `operate_on` DISABLE KEYS */;
INSERT INTO `operate_on` VALUES (1,101,'2026-04-03','Heart Surgery','Success'),(2,102,'2026-04-04','Brain Scan','Pending'),(3,103,'2026-04-05','Bone Surgery','Success'),(4,104,'2026-04-06','Minor Operation','Failure');
/*!40000 ALTER TABLE `operate_on` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `patient`
--

DROP TABLE IF EXISTS `patient`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `patient` (
  `P_No` int NOT NULL,
  `Pat_Name` varchar(100) NOT NULL,
  `HNo` varchar(20) DEFAULT NULL,
  `Street` varchar(50) DEFAULT NULL,
  `City` varchar(50) DEFAULT 'Unknown',
  `Sex` varchar(10) DEFAULT NULL,
  `PHNo` varchar(15) DEFAULT NULL,
  `DOB` date DEFAULT NULL,
  `Age` int DEFAULT NULL,
  PRIMARY KEY (`P_No`),
  UNIQUE KEY `PHNo` (`PHNo`),
  CONSTRAINT `patient_chk_1` CHECK ((`Sex` in (_utf8mb4'M',_utf8mb4'F',_utf8mb4'Other'))),
  CONSTRAINT `patient_chk_2` CHECK ((`Age` between 0 and 130))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `patient`
--

LOCK TABLES `patient` WRITE;
/*!40000 ALTER TABLE `patient` DISABLE KEYS */;
INSERT INTO `patient` VALUES (1,'Niyati','H101','MG Road','Pune','F','9876543210','2005-06-15',20),(2,'Rashi','H102','FC Road','Pune','F','9876543211','2004-08-20',21),(3,'Amit','H103','JM Road','Delhi','M','9876543212','2000-01-10',25),(4,'Rohan','H104','Link Road','Delhi','M','9876543213','1998-03-05',27);
/*!40000 ALTER TABLE `patient` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `patient_admit`
--

DROP TABLE IF EXISTS `patient_admit`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `patient_admit` (
  `P_No` int NOT NULL,
  `Admit_Date` date NOT NULL DEFAULT (curdate()),
  `Room_No` int NOT NULL,
  `Adv_Payment` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`P_No`,`Admit_Date`),
  CONSTRAINT `patient_admit_ibfk_1` FOREIGN KEY (`P_No`) REFERENCES `patient` (`P_No`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `patient_admit_chk_1` CHECK ((`Adv_Payment` >= 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `patient_admit`
--

LOCK TABLES `patient_admit` WRITE;
/*!40000 ALTER TABLE `patient_admit` DISABLE KEYS */;
INSERT INTO `patient_admit` VALUES (1,'2026-04-01',101,5000.00),(2,'2026-04-02',102,4000.00),(3,'2026-04-03',103,3000.00),(3,'2026-04-18',101,500.00),(4,'2026-04-04',104,4500.00),(4,'2026-04-18',101,500.00);
/*!40000 ALTER TABLE `patient_admit` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `patient_backup`
--

DROP TABLE IF EXISTS `patient_backup`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `patient_backup` (
  `P_No` int DEFAULT NULL,
  `Pat_Name` varchar(100) DEFAULT NULL,
  `HNo` varchar(20) DEFAULT NULL,
  `Street` varchar(100) DEFAULT NULL,
  `City` varchar(50) DEFAULT NULL,
  `Sex` char(1) DEFAULT NULL,
  `PHNo` varchar(15) DEFAULT NULL,
  `DOB` date DEFAULT NULL,
  `Age` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `patient_backup`
--

LOCK TABLES `patient_backup` WRITE;
/*!40000 ALTER TABLE `patient_backup` DISABLE KEYS */;
INSERT INTO `patient_backup` VALUES (5,'Sneha','H105','Park Street','Kolkata','F','9876543214','2003-11-25',22);
/*!40000 ALTER TABLE `patient_backup` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `patient_discharged`
--

DROP TABLE IF EXISTS `patient_discharged`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `patient_discharged` (
  `P_No` int NOT NULL,
  `Discharge_Date` date NOT NULL DEFAULT (curdate()),
  `Medicine` varchar(100) DEFAULT NULL,
  `Payment_Type` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`P_No`,`Discharge_Date`),
  CONSTRAINT `patient_discharged_ibfk_1` FOREIGN KEY (`P_No`) REFERENCES `patient` (`P_No`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `patient_discharged_chk_1` CHECK ((`Payment_Type` in (_utf8mb4'Cash',_utf8mb4'Card',_utf8mb4'Insurance')))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `patient_discharged`
--

LOCK TABLES `patient_discharged` WRITE;
/*!40000 ALTER TABLE `patient_discharged` DISABLE KEYS */;
INSERT INTO `patient_discharged` VALUES (1,'2026-04-10','Paracetamol','Cash'),(2,'2026-04-11','Ibuprofen','Card'),(3,'2026-04-12','Antibiotics','Insurance'),(4,'2026-04-13','Painkillers','Cash');
/*!40000 ALTER TABLE `patient_discharged` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-05-06 10:45:59
