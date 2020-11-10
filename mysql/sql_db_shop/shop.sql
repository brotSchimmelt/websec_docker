USE `shop`;

CREATE TABLE `products` (
  `prod_id` int(11) NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT 'auto incrementing id of each product, unique index',
  `prod_title` varchar(255) COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT 'product title',
  `prod_description` text COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT 'some description text for the product',
  `price` int(11) NOT NULL DEFAULT '42' COMMENT 'well, the price',
  `img_path` varchar(255) COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT 'path to product image'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_as_cs COMMENT='fake product data';

INSERT INTO `products` (`prod_id`, `prod_title`, `prod_description`, `price`, `img_path`) VALUES
(1, 'WebSec Mug', 'Our bestseller! The WebSec Mug - can hold hot and cold beverages.', 599, '/assets/img/prod/prod_mug.jpg'),
(2, 'WebSec Banana Slicer S', 'A fun solution to slice a right curved banana uniformly each and every time.', 314, '/assets/img/prod/prod_bananaslicer.jpg'),
(3, 'WebSec Bag', 'A nice linen bag to impress your friends and carry your laptop around.', 999, '/assets/img/prod/prod_bag.jpg'),
(4, 'WebSec Pillow', 'Sleep well and dream of web security or fight off hackers in pillow fights.', 2399, '/assets/img/prod/prod_pillow.jpg'),
(5, 'WebSec T-Shirt', 'WebSec apparel - T-Shirt. Made from 100 percent cotton.', 1499, '/assets/img/prod/prod_tshirt2.jpg'),
(6, 'WebSec Hoodie', 'WebSec apparel - Hoodie. Made from 100 percent cotton.', 4242, '/assets/img/prod/prod_hoodie.jpg'),
(7, 'WebSec Sweater', 'WebSec apparel - Sweater. Made from 100 percent cotton.', 3099, '/assets/img/prod/prod_sweater.jpg'),
(8, 'WebSec Classic T-Shirt', 'WebSec apparel - Classic T-Shirt. Made from 100 percent cotton.', 1999, '/assets/img/prod/prod_tshirt1.jpg');


CREATE TABLE `cart` (
  `position_id` int(11) NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT 'auto incrementing id of each position in the cart, unique index',
  `prod_id` int(11) DEFAULT NULL COMMENT 'product id in the cart, unique with user_id',
  `user_name` varchar(64) NOT NULL COMMENT 'corresponding user name, unique with prod_id',
  `quantity` int(11) NOT NULL COMMENT 'quantity',
  `timestamp` datetime NOT NULL COMMENT 'timestamp of creation'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_as_cs COMMENT='shopping cart data';

ALTER TABLE `cart`
  ADD UNIQUE KEY `unique_key` (`prod_id`,`user_name`);


CREATE TABLE `xss_comments` (
  `comment_id` int(11) NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT 'auto incrementing id of each comment, unique index',
  `author` varchar(64) COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT 'username of comment author',
  `text` varchar(255) COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT 'comment body',
  `rating` int(11) NOT NULL COMMENT 'rating for products',
  `timestamp` datetime NOT NULL COMMENT 'timestamp of creation',
  `post_time` varchar(64) COLLATE utf8mb4_0900_as_cs DEFAULT 'just now' COMMENT 'time of posting'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_as_cs COMMENT='comments for the stored xss challenge';


CREATE TABLE `csrf_posts` (
  `post_id` int(11) NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT 'auto incrementing id of each post, unique index',
  `user_name` varchar(64) COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT 'username of crosspost author',
  `message` varchar(255) COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT 'post body',
  `referrer` varchar(255) COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT 'source of post',
  `timestamp` datetime NOT NULL COMMENT 'timestamp of creation'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_as_cs COMMENT='posts for the csrf challenge';


CREATE TABLE `challenge_solutions` (
  `id` int(11) NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT 'auto incrementing id of each solution',
  `user_name` varchar(64) COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT 'username',
  `reflective_xss` varchar(255) COLLATE utf8mb4_0900_as_cs NOT NULL DEFAULT '-' COMMENT 'reflective xss challenge',
  `stored_xss` varchar(255) COLLATE utf8mb4_0900_as_cs NOT NULL DEFAULT '-' COMMENT 'stored xss challenge',
  `sqli` varchar(255) COLLATE utf8mb4_0900_as_cs NOT NULL DEFAULT '-' COMMENT 'sql injection challenge'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_as_cs COMMENT='solutions for the challenges';
