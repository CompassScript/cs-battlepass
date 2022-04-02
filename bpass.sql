CREATE TABLE IF NOT EXISTS `battlepass` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `player` varchar(255) COLLATE utf8mb4_turkish_ci NOT NULL,
  `data` text COLLATE utf8mb4_turkish_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_turkish_ci ROW_FORMAT=DYNAMIC;

INSERT INTO `battlepass` (`id`, `player`, `data`) VALUES
	(14, 'cs-battlepass', 'do not delete this!');
/*!40000 ALTER TABLE `battlepass` ENABLE KEYS */;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
