USE `login`;

CREATE TABLE `users` (
  `user_id` int(11) NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT 'auto incrementing user_id of each user, unique index',
  `user_name` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'user name, unique',
  `user_pwd_hash` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'user password in salted and hashed format',
  `user_wwu_email` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'user email, unique',
  `is_unlocked` tinyint(4) NOT NULL DEFAULT '0' COMMENT 'unlock status flag',
  `is_admin` tinyint(4) NOT NULL DEFAULT '0' COMMENT 'admin flag',
  `timestamp` datetime NOT NULL DEFAULT '1970-01-01 00:00:01' COMMENT 'timestamp of registration',
  `last_login` datetime DEFAULT '1970-01-01 00:00:01' COMMENT 'timestamp of last login'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='student login data';

ALTER TABLE `users`
  ADD UNIQUE KEY `user_name` (`user_name`),
  ADD UNIQUE KEY `user_wwu_email` (`user_wwu_email`);

CREATE TABLE `fakeCookie` (
  `id` int(11) PRIMARY KEY AUTO_INCREMENT NOT NULL COMMENT 'auto incrementing id of each request, unique index',
  `user_name` varchar(64) NOT NULL COLLATE utf8mb4_unicode_ci COMMENT 'user name, unique',
  `challenge_cookie` varchar(255) NOT NULL DEFAULT 'youShouldNotGetThisCookiePleaseReportInLearnweb' COMMENT 'fake cookie for XSS challenge'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='XSS fake cookie';

ALTER TABLE `fakeCookie`
  ADD UNIQUE KEY `user_name` (`user_name`);

CREATE TABLE `resetPwd` (
  `request_id` int(11) PRIMARY KEY AUTO_INCREMENT NOT NULL COMMENT 'auto incrementing id of each request, unique index',
  `user_wwu_email` TEXT NOT NULL COMMENT 'user email, unique',
  `request_selector` TEXT NOT NULL COMMENT 'selector token',
  `request_token` LONGTEXT NOT NULL COMMENT 'hashed validator token',
  `request_expiration` TEXT NOT NULL COMMENT 'time in seconds for how long the tokens are valid'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='pwd reset token data';

ALTER TABLE `resetPwd`
  ADD UNIQUE KEY `user_wwu_email` (`user_wwu_email`);
