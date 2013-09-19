-- create.sql - create a database to store CRRA (VuFind) httpd log transactions

-- Eric Lease Morgan <emorgan@nd.edu>
-- January   24, 2011 - first investigations
-- January   25, 2011 - added hosttype and requesttype
-- June      29, 2011 - added searchtype, recordtype, and institution
-- September 16, 2011 - added host index


-- MySQL dump 10.10
--
-- Host: mysql.library.nd.edu    Database: crra_transactions
-- ------------------------------------------------------
-- Server version	5.0.24a-standard-log

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
-- Table structure for table `httpd`
--

DROP TABLE IF EXISTS `httpd`;
CREATE TABLE `httpd` (
  `id` int(11) NOT NULL auto_increment,
  `host` varchar(128) NOT NULL,
  `username` varchar(16) NOT NULL,
  `password` varchar(16) NOT NULL,
  `datetime` datetime NOT NULL,
  `timezone` varchar(8) NOT NULL,
  `method` varchar(8) NOT NULL,
  `request` varchar(1024) NOT NULL,
  `protocol` varchar(8) NOT NULL,
  `statuscode` varchar(8) NOT NULL,
  `bytessent` int(11) NOT NULL,
  `referrer` varchar(1024) NOT NULL,
  `useragent` varchar(1024) NOT NULL,
  `hosttype` varchar(16) default 'unknown',
  `requesttype` varchar(16) default 'unknown',
  `searchtype` varchar(16) default NULL,
  `recordtype` varchar(16) default NULL,
  `institution` varchar(128) default NULL,
  PRIMARY KEY  (`id`),
  KEY `host` (`host`),
  KEY `requesttype` (`requesttype`)
) ENGINE=MyISAM AUTO_INCREMENT=3892285 DEFAULT CHARSET=latin1;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

