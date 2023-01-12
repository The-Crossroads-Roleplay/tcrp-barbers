CREATE TABLE IF NOT EXISTS `telegrams` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `station` varchar(100) NOT NULL,
  `sender` varchar(50) NOT NULL DEFAULT '0',
  `recipient` varchar(50) NOT NULL,
  `recipientid` varchar(30) NOT NULL,
  `message` longtext NOT NULL,
  `type` int(1) NOT NULL DEFAULT '1',
  `coordinates` varchar(100),
  `hasRead` int(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=279 DEFAULT CHARSET=utf8mb4;`status`telegramstelegrams