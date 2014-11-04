-- ----------------------------
-- Table structure for `admins`
-- ----------------------------
DROP TABLE IF EXISTS `admins`;
CREATE TABLE `admins` (
  `uid` INTEGER PRIMARY KEY NOT NULL,
  `username` varchar(20) NOT NULL,
  `userpass` varchar(100) NOT NULL
);

-- ----------------------------
-- Records of admins
-- ----------------------------

-- ----------------------------
-- Table structure for `articles`
-- ----------------------------
DROP TABLE IF EXISTS `articles`;
CREATE TABLE `articles` (
  `aid` INTEGER PRIMARY KEY NOT NULL,
  `title` varchar(20) NULL,
  `content` text,
  `posttime` datetime NULL
);

-- ----------------------------
-- Records of articles
-- ----------------------------
INSERT INTO `articles` VALUES ('1', 'test article', 'test content', '2013-02-27 22:38:39');
INSERT INTO `articles` VALUES ('2', '标题', '内容', '2014-11-04 07:38:39');

-- ----------------------------
-- Table structure for `sessions`
-- ----------------------------
DROP TABLE IF EXISTS `sessions`;
CREATE TABLE `sessions` (
  `session_id` char(128) NOT NULL UNIQUE,
  `atime` CURRENT_TIMESTAMP NOT NULL,
  `data` text
);
