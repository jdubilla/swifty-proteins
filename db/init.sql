CREATE DATABASE IF NOT EXISTS swiftyProteins;
USE swiftyProteins;

CREATE TABLE IF NOT EXISTS user (
  `id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `password` varchar(200) NOT NULL,
  PRIMARY KEY (`id`)
);