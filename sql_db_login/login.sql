USE `login`;

CREATE TABLE `users` (
  `user_id` int(11) NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT 'auto incrementing user_id of each user, unique index',
  `user_name` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'user name, unique',
  `user_pwd_hash` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'user password in salted and hashed format',
  `user_wwu_email` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'user email, unique',
  `is_unlocked` tinyint(4) NOT NULL DEFAULT '0' COMMENT 'unlock status flag',
  `is_admin` tinyint(4) NOT NULL DEFAULT '0' COMMENT 'admin flag',
  `xss_fake_cookie_id` varchar(255) NOT NULL DEFAULT 'youShouldNotGetThisCookiePleaseReportInLearnweb' COMMENT 'fake cookie for xss challenge'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='student login data';

ALTER TABLE `users`
  ADD UNIQUE KEY `user_name` (`user_name`),
  ADD UNIQUE KEY `user_wwu_email` (`user_wwu_email`);
