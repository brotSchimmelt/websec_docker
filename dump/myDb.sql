-- MySQL dump 10.13  Distrib 5.7.27, for Linux (x86_64)
--
-- Host: localhost    Database: 
-- ------------------------------------------------------
-- Server version	5.7.27-0ubuntu0.18.04.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Current Database: `phplogin`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `phplogin` /*!40100 DEFAULT CHARACTER SET latin1 */;

USE `phplogin`;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `user_id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'auto incrementing user_id of each user, unique index',
  `user_name` varchar(64) COLLATE utf8_unicode_ci NOT NULL COMMENT 'user''s name, unique',
  `user_password_hash` varchar(255) COLLATE utf8_unicode_ci NOT NULL COMMENT 'user''s password in salted and hashed format',
  `user_email` varchar(64) COLLATE utf8_unicode_ci NOT NULL COMMENT 'user''s email, unique',
  `unlocked` tinyint(4) NOT NULL DEFAULT '0',
  `isadmin` tinyint(4) DEFAULT '0',
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `user_name` (`user_name`),
  UNIQUE KEY `user_email` (`user_email`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='user data';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'Administrator','$2y$10$HAffLy2Q0QVUL5Hx8APCFuKM1mKlgdA5Pavharr46dihKIP7JClTK','thomas.hupperich@wi.uni-muenster.de',1,1),(15,'ThomasHupperich','$2y$10$dK9EXmz8NPUF72AmG862UubhwsGs0SYDBIFGTyM3wa2FCR0TWUYq2','thomas.hupperich@uni-muenster.de',0,0);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Current Database: `websec`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `websec` /*!40100 DEFAULT CHARACTER SET latin1 */;

USE `websec`;

--
-- Table structure for table `crossposts`
--

DROP TABLE IF EXISTS `crossposts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `crossposts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(45) NOT NULL,
  `post` varchar(455) NOT NULL,
  `timestamp` varchar(45) NOT NULL,
  `referrer` mediumtext,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`),
  UNIQUE KEY `username_UNIQUE` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=36 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `crossposts`
--

LOCK TABLES `crossposts` WRITE;
/*!40000 ALTER TABLE `crossposts` DISABLE KEYS */;
/*!40000 ALTER TABLE `crossposts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fake_cookie_ids`
--

DROP TABLE IF EXISTS `fake_cookie_ids`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fake_cookie_ids` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(45) NOT NULL,
  `fake_id` varchar(45) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`),
  UNIQUE KEY `username_UNIQUE` (`username`),
  UNIQUE KEY `fake_id_UNIQUE` (`fake_id`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fake_cookie_ids`
--

LOCK TABLES `fake_cookie_ids` WRITE;
/*!40000 ALTER TABLE `fake_cookie_ids` DISABLE KEYS */;
INSERT INTO `fake_cookie_ids` VALUES (15,'Administrator','17b7bc2512ee1fedcd76bdc68926d4f7b'),(16,'ThomasHupperich','15bc2af0e993a836cce8ecce80ed8d416e');
/*!40000 ALTER TABLE `fake_cookie_ids` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `userdbs`
--

DROP TABLE IF EXISTS `userdbs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `userdbs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(45) NOT NULL,
  `dbname` varchar(50) NOT NULL,
  PRIMARY KEY (`id`,`username`),
  UNIQUE KEY `id_UNIQUE` (`id`),
  UNIQUE KEY `username_UNIQUE` (`username`),
  UNIQUE KEY `fake_id_UNIQUE` (`dbname`)
) ENGINE=InnoDB AUTO_INCREMENT=49 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `userdbs`
--

LOCK TABLES `userdbs` WRITE;
/*!40000 ALTER TABLE `userdbs` DISABLE KEYS */;
INSERT INTO `userdbs` VALUES (46,'Administrator','databases/administrator.sqlite'),(42,'ThomasHupperich','databases/thomashupperich.sqlite');
/*!40000 ALTER TABLE `userdbs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `xsscomments`
--

DROP TABLE IF EXISTS `xsscomments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `xsscomments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(45) NOT NULL,
  `comment_id` varchar(45) NOT NULL,
  `comment` varchar(500) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`),
  UNIQUE KEY `comment_id_UNIQUE` (`comment_id`)
) ENGINE=InnoDB AUTO_INCREMENT=197 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `xsscomments`
--

LOCK TABLES `xsscomments` WRITE;
/*!40000 ALTER TABLE `xsscomments` DISABLE KEYS */;
INSERT INTO `xsscomments` VALUES (1,'Reviewer','1','I really like this product! Five stars!'),(2,'Reviewer','2','Totally useless!! Never buy this item!'),(3,'Reviewer','3','I purchased this product for my girlfriend\'s birthday. She was not disappointed!');
/*!40000 ALTER TABLE `xsscomments` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2019-09-19 13:10:59
