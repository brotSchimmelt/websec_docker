USE `shop`;

CREATE TABLE `products` (
  `prod_id` int(11) NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT 'auto incrementing id of each product, unique index',
  `prod_title` varchar(255) COLLATE utf8mb4_general_ci NOT NULL COMMENT 'product title',
  `prod_description` text COLLATE utf8mb4_general_ci NOT NULL COMMENT 'some description text for the product',
  `price` int(11) NOT NULL DEFAULT '42' COMMENT 'well, the price',
  `img_path` varchar(255) COLLATE utf8mb4_general_ci NOT NULL COMMENT 'path to product image'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='fake product data';

INSERT INTO `products` (`prod_id`, `prod_title`, `prod_description`, `price`, `img_path`) VALUES
(1, 'WebSec Mug', 'Some quick example text to build on the card title and make up the bulk of the cards content.', 100, '/assets/img/prod/prod_mug.jpg'),
(2, 'WebSec Bananaslicer', 'Some quick example text to build on the card title and make up the bulk of the cards content.', 200, '/assets/img/prod/prod_bananaslicer.jpg'),
(3, 'WebSec Bag', 'Some quick example text to build on the card title and make up the bulk of the cards content.', 300, '/assets/img/prod/prod_bag.jpg'),
(4, 'WebSec Pillow', 'Some quick example text to build on the card title and make up the bulk of the cards content.', 400, '/assets/img/prod/prod_pillow.jpg'),
(5, 'WebSec T-Shirt', 'Some quick example text to build on the card title and make up the bulk of the cards content.', 500, '/assets/img/prod/prod_tshirt2.jpg'),
(6, 'WebSec Hoodie', 'Some quick example text to build on the card title and make up the bulk of the cards content.', 600, '/assets/img/prod/prod_hoodie.jpg'),
(7, 'WebSec Sweater', 'Some quick example text to build on the card title and make up the bulk of the cards content.', 700, '/assets/img/prod/prod_sweater.jpg'),
(8, 'WebSec Classic T-Shirt', 'Some quick example text to build on the card title and make up the bulk of the cards content.', 800, '/assets/img/prod/prod_tshirt1.jpg');


CREATE TABLE `cart` (
  `position_id` int(11) NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT 'auto incrementing id of each position in the cart, unique index',
  `prod_id` int(11) DEFAULT NULL COMMENT 'product id in the cart, unique with user_id',
  `user_name` varchar(64) NOT NULL COMMENT 'corresponding user name, unique with prod_id',
  `quantity` int(11) NOT NULL COMMENT 'quantity',
  `timestamp` datetime NOT NULL COMMENT 'timestamp of creation'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='shopping cart data';

ALTER TABLE `cart`
  ADD UNIQUE KEY `unique_key` (`prod_id`,`user_name`);


CREATE TABLE `xss_comments` (
  `comment_id` int(11) NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT 'auto incrementing id of each comment, unique index',
  `author` varchar(64) COLLATE utf8mb4_general_ci NOT NULL COMMENT 'username of comment author',
  `text` varchar(255) COLLATE utf8mb4_general_ci NOT NULL COMMENT 'comment body',
  `rating` int(11) NOT NULL COMMENT 'rating for products',
  `timestamp` datetime NOT NULL COMMENT 'timestamp of creation',
  `post_time` varchar(64) COLLATE utf8mb4_general_ci DEFAULT 'just now' COMMENT 'time of posting'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='comments for the stored xss challenge';


CREATE TABLE `csrf_posts` (
  `post_id` int(11) NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT 'auto incrementing id of each post, unique index',
  `user_name` varchar(64) COLLATE utf8mb4_general_ci NOT NULL COMMENT 'username of crosspost author',
  `message` varchar(255) COLLATE utf8mb4_general_ci NOT NULL COMMENT 'post body',
  `referrer` varchar(255) COLLATE utf8mb4_general_ci NOT NULL COMMENT 'source of post',
  `timestamp` datetime NOT NULL COMMENT 'timestamp of creation'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='posts for the csrf challenge';
