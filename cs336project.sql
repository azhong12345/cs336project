-- MySQL dump 10.13  Distrib 8.0.25, for Win64 (x86_64)
--
-- Host: localhost    Database: cs336project
-- ------------------------------------------------------
-- Server version	8.0.25

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
-- Table structure for table `alerts`
--

DROP TABLE IF EXISTS `alerts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `alerts` (
  `username` varchar(30) NOT NULL,
  `itemID` int NOT NULL,
  `auctionID` int NOT NULL,
  `bid_price` decimal(10,2) NOT NULL,
  `message` varchar(300) DEFAULT NULL,
  PRIMARY KEY (`username`,`itemID`,`auctionID`,`bid_price`),
  KEY `itemID` (`itemID`),
  KEY `auctionID` (`auctionID`),
  CONSTRAINT `alerts_ibfk_1` FOREIGN KEY (`username`) REFERENCES `user` (`username`),
  CONSTRAINT `alerts_ibfk_2` FOREIGN KEY (`itemID`) REFERENCES `clothing` (`itemID`),
  CONSTRAINT `alerts_ibfk_3` FOREIGN KEY (`auctionID`) REFERENCES `auction` (`auctionID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `alerts`
--

LOCK TABLES `alerts` WRITE;
/*!40000 ALTER TABLE `alerts` DISABLE KEYS */;
INSERT INTO `alerts` VALUES ('mjo',15,4,30.00,'You\'ve been outbid! Place another bid or miss out!'),('ms123',15,4,19.00,'You\'ve been outbid! Place another bid or miss out!'),('ms123',15,4,25.00,'You\'ve been outbid! Place another bid or miss out!');
/*!40000 ALTER TABLE `alerts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auction`
--

DROP TABLE IF EXISTS `auction`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auction` (
  `auctionID` int NOT NULL AUTO_INCREMENT,
  `itemID` int DEFAULT NULL,
  `username` varchar(30) DEFAULT NULL,
  `open_date` datetime DEFAULT NULL,
  `close_date` datetime DEFAULT NULL,
  `init_price` decimal(10,2) DEFAULT NULL,
  `bid_increment` decimal(10,2) DEFAULT NULL,
  `min_price` decimal(10,2) DEFAULT NULL,
  `current_price` decimal(10,2) DEFAULT NULL,
  `current_bidder` varchar(30) DEFAULT NULL,
  `secret_max` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`auctionID`),
  KEY `itemID` (`itemID`),
  KEY `username` (`username`),
  KEY `current_bidder` (`current_bidder`),
  CONSTRAINT `auction_ibfk_1` FOREIGN KEY (`itemID`) REFERENCES `clothing` (`itemID`),
  CONSTRAINT `auction_ibfk_2` FOREIGN KEY (`username`) REFERENCES `user` (`username`),
  CONSTRAINT `auction_ibfk_3` FOREIGN KEY (`current_bidder`) REFERENCES `user` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auction`
--

LOCK TABLES `auction` WRITE;
/*!40000 ALTER TABLE `auction` DISABLE KEYS */;
INSERT INTO `auction` VALUES (1,12,'azhong','2021-08-12 21:04:40','2021-09-22 08:08:11',200.00,50.00,250.00,NULL,NULL,NULL),(2,13,'azhong','2021-08-12 21:28:40','2021-08-26 00:00:00',25.00,1.50,30.00,30.00,NULL,NULL),(3,14,NULL,'2021-08-13 00:01:19','2021-08-13 00:00:00',500.00,10.00,600.00,600.00,'azhong',NULL),(4,15,'azhong','2021-08-13 20:53:19','2021-08-23 00:00:00',5.00,2.00,5.00,32.00,'cl',50.00);
/*!40000 ALTER TABLE `auction` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bid`
--

DROP TABLE IF EXISTS `bid`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bid` (
  `username` varchar(30) NOT NULL,
  `auctionID` int NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `is_anon` int DEFAULT NULL,
  PRIMARY KEY (`username`,`auctionID`,`price`),
  KEY `auctionID` (`auctionID`),
  CONSTRAINT `bid_ibfk_1` FOREIGN KEY (`username`) REFERENCES `user` (`username`),
  CONSTRAINT `bid_ibfk_2` FOREIGN KEY (`auctionID`) REFERENCES `auction` (`auctionID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bid`
--

LOCK TABLES `bid` WRITE;
/*!40000 ALTER TABLE `bid` DISABLE KEYS */;
INSERT INTO `bid` VALUES ('azhong',3,600.00,0),('cl',4,27.00,0),('cl',4,32.00,0),('cl',4,50.00,0),('mjo',4,30.00,0),('mlou',4,7.00,0),('ms123',4,12.00,0),('ms123',4,15.00,0),('ms123',4,25.00,0);
/*!40000 ALTER TABLE `bid` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `clothing`
--

DROP TABLE IF EXISTS `clothing`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `clothing` (
  `itemID` int NOT NULL AUTO_INCREMENT,
  `name` varchar(50) DEFAULT NULL,
  `gender` varchar(10) DEFAULT NULL,
  `brand` varchar(20) DEFAULT NULL,
  `type` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`itemID`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `clothing`
--

LOCK TABLES `clothing` WRITE;
/*!40000 ALTER TABLE `clothing` DISABLE KEYS */;
INSERT INTO `clothing` VALUES (1,'summer dress',NULL,'gap',NULL),(2,'dress',NULL,'gap',NULL),(4,'jeans','men','levis',NULL),(5,'White Short-sleeve Blouse','women','Loft',NULL),(6,'White short-sleeve blouse','women','Loft',NULL),(7,'White short-sleeve blouse','women','Loft',NULL),(8,'s','men','s',NULL),(9,'Blue Check Shirt','men','Gap',NULL),(10,'Blue T-Shirt','women','Target',NULL),(11,'yellow dress','women','gucci',NULL),(12,'yellow dress','women','gucci',NULL),(13,'jeans','men','levis',NULL),(14,'leather jacket','men','moschino','shirt'),(15,'White Shirt','women','Gap','shirt');
/*!40000 ALTER TABLE `clothing` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customer_service`
--

DROP TABLE IF EXISTS `customer_service`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `customer_service` (
  `ticketID` int NOT NULL AUTO_INCREMENT,
  `end_username` varchar(30) DEFAULT NULL,
  `rep_username` varchar(30) DEFAULT NULL,
  `question` varchar(500) DEFAULT NULL,
  `answer` varchar(700) DEFAULT NULL,
  PRIMARY KEY (`ticketID`),
  KEY `end_username` (`end_username`),
  KEY `rep_username` (`rep_username`),
  CONSTRAINT `customer_service_ibfk_1` FOREIGN KEY (`end_username`) REFERENCES `user` (`username`),
  CONSTRAINT `customer_service_ibfk_2` FOREIGN KEY (`rep_username`) REFERENCES `user` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customer_service`
--

LOCK TABLES `customer_service` WRITE;
/*!40000 ALTER TABLE `customer_service` DISABLE KEYS */;
/*!40000 ALTER TABLE `customer_service` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dress`
--

DROP TABLE IF EXISTS `dress`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `dress` (
  `itemID` int NOT NULL,
  `dress_size` int DEFAULT NULL,
  `dress_length` int DEFAULT NULL,
  PRIMARY KEY (`itemID`),
  CONSTRAINT `dress_ibfk_1` FOREIGN KEY (`itemID`) REFERENCES `clothing` (`itemID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dress`
--

LOCK TABLES `dress` WRITE;
/*!40000 ALTER TABLE `dress` DISABLE KEYS */;
INSERT INTO `dress` VALUES (11,4,20),(12,10,35);
/*!40000 ALTER TABLE `dress` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `end_view`
--

DROP TABLE IF EXISTS `end_view`;
/*!50001 DROP VIEW IF EXISTS `end_view`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `end_view` AS SELECT 
 1 AS `auctionID`,
 1 AS `name`,
 1 AS `gender`,
 1 AS `brand`,
 1 AS `username`,
 1 AS `current_price`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `pants`
--

DROP TABLE IF EXISTS `pants`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pants` (
  `itemID` int NOT NULL,
  `pants_size` int DEFAULT NULL,
  `pants_style` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`itemID`),
  CONSTRAINT `pants_ibfk_1` FOREIGN KEY (`itemID`) REFERENCES `clothing` (`itemID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pants`
--

LOCK TABLES `pants` WRITE;
/*!40000 ALTER TABLE `pants` DISABLE KEYS */;
INSERT INTO `pants` VALUES (13,30,'jeans');
/*!40000 ALTER TABLE `pants` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `shirt`
--

DROP TABLE IF EXISTS `shirt`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `shirt` (
  `itemID` int NOT NULL,
  `shirt_size` varchar(2) DEFAULT NULL,
  `shirt_style` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`itemID`),
  CONSTRAINT `shirt_ibfk_1` FOREIGN KEY (`itemID`) REFERENCES `clothing` (`itemID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `shirt`
--

LOCK TABLES `shirt` WRITE;
/*!40000 ALTER TABLE `shirt` DISABLE KEYS */;
INSERT INTO `shirt` VALUES (6,'M','blouse'),(9,'l','blouse'),(10,'XS','tee'),(14,'L','sweater'),(15,'L','tee');
/*!40000 ALTER TABLE `shirt` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user` (
  `name` varchar(50) DEFAULT NULL,
  `username` varchar(30) NOT NULL,
  `password` varchar(50) DEFAULT NULL,
  `email` varchar(50) DEFAULT NULL,
  `address` varchar(100) DEFAULT NULL,
  `type` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES ('John Doe','admin1','password','adminstaff@buyme.com','600 William Ave. Neenah, WI 54956','admin'),('Annie Zhong','azhong','az12345','azhong@gmail.com','123 Scenic Ln, Kipling, OH','end'),('Cindy Lauper','cl','cl123','cl@gmail.com','56 Green St.','end'),('Crystal Smith','customerrep1','password','csmith@buyme.com','7311 E. Fieldstone Dr. Des Moines, IA 50310','rep'),('Billy Bob','customerrep2','password','bbob@buyme.com','390 Border Street Anaheim, CA 92806','rep'),('Judy Mae','customerrep3','password','jmae@buyme.com','7486 Schoolhouse Ave. Hamtramck, MI 48212','rep'),('Mary Williams','customerrep4','password','mwilliams@buyme.com','8628 Sugar Street Palm Harbor, FL 34683','rep'),('Josh Stewart','customerrep5','password','jstewart@buyme.com','12 Grand St. Glenside, PA 19038','rep'),('Mindy Jones','mjo','mj123','mjones@gmail.com','957 Lake St., Georgetown','end'),('Mary Lou','mlou','password','Mlou@gmail.com','123 rutgers ave','end'),('Mary','mlou@gmail.com','password','Lou','123 rutgers ave','end'),('May Smith','ms123','password','msmith@gmail.com','123 rutgers ave','end');
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Final view structure for view `end_view`
--

/*!50001 DROP VIEW IF EXISTS `end_view`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `end_view` AS select `a`.`auctionID` AS `auctionID`,`c`.`name` AS `name`,`c`.`gender` AS `gender`,`c`.`brand` AS `brand`,`a`.`username` AS `username`,`a`.`current_price` AS `current_price` from (`auction` `a` join `clothing` `c`) where (`a`.`itemID` = `c`.`itemID`) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2021-08-14 14:34:48
