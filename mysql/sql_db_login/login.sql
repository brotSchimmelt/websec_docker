USE `login`;

CREATE TABLE `users` (
  `user_id` int(11) NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT 'auto incrementing user_id of each user, unique index',
  `user_name` varchar(64) COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT 'user name, unique',
  `user_pwd_hash` varchar(255) COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT 'user password in salted and hashed format',
  `user_wwu_email` varchar(64) COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT 'user email, unique',
  `is_unlocked` tinyint(4) NOT NULL DEFAULT '0' COMMENT 'unlock status flag',
  `is_admin` tinyint(4) NOT NULL DEFAULT '0' COMMENT 'admin flag',
  `timestamp` datetime NOT NULL DEFAULT '1970-01-01 00:00:01' COMMENT 'timestamp of registration',
  `last_login` datetime DEFAULT '1970-01-01 00:00:01' COMMENT 'timestamp of last login'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_as_cs COMMENT='student login data';

ALTER TABLE `users`
  ADD UNIQUE KEY `user_name` (`user_name`),
  ADD UNIQUE KEY `user_wwu_email` (`user_wwu_email`);

INSERT INTO `users`
(`user_id`, `user_name`, `user_pwd_hash`, `user_wwu_email`, `is_unlocked`, `is_admin`, `timestamp`, `last_login`)
VALUES (1, 'administrator', '$2y$13$X5v4r.pNv0USvF0k4RENPe4zEAuidzOBsY4Sr29h7kBjvMSR3B8Mm', 
'tim.knebler@uni-muenster.de', 1, 1, '1970-01-01 00:00:01', NULL);

CREATE TABLE `fakeCookie` (
  `id` int(11) PRIMARY KEY AUTO_INCREMENT NOT NULL COMMENT 'auto incrementing id of each user, unique index',
  `user_name` varchar(64) NOT NULL COLLATE utf8mb4_0900_as_cs COMMENT 'user name, unique',
  `reflective_xss` varchar(255) NOT NULL DEFAULT 'youShouldNotGetThisCookiePleaseReportInLearnweb' COMMENT 'fake cookie for REFLECTIVE XSS challenge',
  `stored_xss` varchar(255) NOT NULL DEFAULT 'youShouldNotGetThisCookiePleaseReportInLearnweb' COMMENT 'fake cookie for STORED XSS challenge',
  `fake_token` varchar(255) NOT NULL DEFAULT 'youShouldNotGetThisTokenPleaseReportInLearnweb' COMMENT 'fake token for HARD CSRF challenge'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_as_cs COMMENT='XSS fake cookie';

ALTER TABLE `fakeCookie`
  ADD UNIQUE KEY `user_name` (`user_name`);

INSERT INTO `fakeCookie`
(`id`, `user_name`, `reflective_xss`, `stored_xss`, `fake_token`) VALUES
(1, 'administrator', 'cc80d244b6ca403f', '24ee09f64e93a128', 'cb3dedbefd49a997');

CREATE TABLE `challengeStatus` (
  `id` int(11) PRIMARY KEY AUTO_INCREMENT NOT NULL COMMENT 'auto incrementing id of each user, unique index',
  `user_name` varchar(64) NOT NULL COLLATE utf8mb4_0900_as_cs COMMENT 'user name, unique',
  `reflective_xss` tinyint(4) NOT NULL DEFAULT '0' COMMENT 'status for REFLECTIVE XSS challenge',
  `stored_xss` tinyint(4) NOT NULL DEFAULT '0' COMMENT 'status for STORED XSS challenge',
  `sqli` tinyint(4) NOT NULL DEFAULT '0' COMMENT 'status for SQLI challenge',
  `csrf` tinyint(4) NOT NULL DEFAULT '0' COMMENT 'status for CSRF challenge',
  `csrf_referrer` tinyint(4) NOT NULL DEFAULT '0' COMMENT 'status for CSRF part II challenge',
  `reflective_xss_hard` tinyint(4) NOT NULL DEFAULT '0' COMMENT 'status for hard REFLECTIVE XSS challenge',
  `stored_xss_hard` tinyint(4) NOT NULL DEFAULT '0' COMMENT 'status for hard STORED XSS challenge',
  `sqli_hard` tinyint(4) NOT NULL DEFAULT '0' COMMENT 'status for hard SQLI challenge',
  `csrf_hard` tinyint(4) NOT NULL DEFAULT '0' COMMENT 'status for hard CSRF challenge',
  `csrf_referrer_hard` tinyint(4) NOT NULL DEFAULT '0' COMMENT 'status for hard CSRF part II challenge'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_as_cs COMMENT='challange status';

ALTER TABLE `challengeStatus`
  ADD UNIQUE KEY `user_name` (`user_name`);

INSERT INTO `challengeStatus`
(`id`, `user_name`, `reflective_xss`, `stored_xss`, `sqli`, `csrf`, `csrf_referrer`, `reflective_xss_hard`, `stored_xss_hard`, `sqli_hard`, `csrf_hard`, `csrf_referrer_hard`) 
VALUES (1, 'administrator', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);

CREATE TABLE `resetPwd` (
  `request_id` int(11) PRIMARY KEY AUTO_INCREMENT NOT NULL COMMENT 'auto incrementing id of each request, unique index',
  `user_wwu_email` TEXT NOT NULL COMMENT 'user email, unique',
  `request_selector` TEXT NOT NULL COMMENT 'selector token',
  `request_token` LONGTEXT NOT NULL COMMENT 'hashed validator token',
  `request_expiration` TEXT NOT NULL COMMENT 'time in seconds for how long the tokens are valid'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_as_cs COMMENT='pwd reset token data';

ALTER TABLE `resetPwd`
  ADD UNIQUE KEY `user_wwu_email` (`user_wwu_email`);
