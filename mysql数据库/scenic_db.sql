/*
Navicat MySQL Data Transfer

Source Server         : localhost_3306
Source Server Version : 50051
Source Host           : localhost:3306
Source Database       : scenic_db

Target Server Type    : MYSQL
Target Server Version : 50051
File Encoding         : 65001

Date: 2018-02-04 01:42:53
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for `admin`
-- ----------------------------
DROP TABLE IF EXISTS `admin`;
CREATE TABLE `admin` (
  `username` varchar(20) NOT NULL default '',
  `password` varchar(32) default NULL,
  PRIMARY KEY  (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of admin
-- ----------------------------
INSERT INTO `admin` VALUES ('a', 'a');

-- ----------------------------
-- Table structure for `t_leaveword`
-- ----------------------------
DROP TABLE IF EXISTS `t_leaveword`;
CREATE TABLE `t_leaveword` (
  `leavewordId` int(11) NOT NULL auto_increment COMMENT '留言id',
  `title` varchar(60) NOT NULL COMMENT '留言标题',
  `content` varchar(2000) NOT NULL COMMENT '留言内容',
  `userObj` varchar(20) NOT NULL COMMENT '留言人',
  `leaveTime` varchar(20) default NULL COMMENT '留言时间',
  `replyContent` varchar(20) default NULL COMMENT '回复内容',
  `replyTime` varchar(20) default NULL COMMENT '回复时间',
  PRIMARY KEY  (`leavewordId`),
  KEY `userObj` (`userObj`),
  CONSTRAINT `t_leaveword_ibfk_1` FOREIGN KEY (`userObj`) REFERENCES `t_userinfo` (`user_name`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of t_leaveword
-- ----------------------------
INSERT INTO `t_leaveword` VALUES ('1', '反映下食堂问题', '第一食堂的荤菜感觉肉太少了！', 'user1', '2017-11-08 00:43:23', '收到', '2017-11-22 00:43:29');
INSERT INTO `t_leaveword` VALUES ('2', '1111', '2222', 'user1', '2017-11-07 19:05:08', '很好', '2017-11-07 19:06:02');
INSERT INTO `t_leaveword` VALUES ('3', '很好的网站', '我可以找到好地方去玩了！', 'user1', '2017-11-25 17:16:38', '嗯  谢谢支持', '2017-11-25 17:16:52');

-- ----------------------------
-- Table structure for `t_route`
-- ----------------------------
DROP TABLE IF EXISTS `t_route`;
CREATE TABLE `t_route` (
  `routeId` int(11) NOT NULL auto_increment COMMENT '路径id',
  `startScenic` int(11) NOT NULL COMMENT '起始景点',
  `endScenic` int(11) NOT NULL COMMENT '结束景点',
  PRIMARY KEY  (`routeId`),
  KEY `startScenic` (`startScenic`),
  KEY `endScenic` (`endScenic`),
  CONSTRAINT `t_route_ibfk_1` FOREIGN KEY (`startScenic`) REFERENCES `t_scenic` (`scenicId`),
  CONSTRAINT `t_route_ibfk_2` FOREIGN KEY (`endScenic`) REFERENCES `t_scenic` (`scenicId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of t_route
-- ----------------------------

-- ----------------------------
-- Table structure for `t_scenic`
-- ----------------------------
DROP TABLE IF EXISTS `t_scenic`;
CREATE TABLE `t_scenic` (
  `scenicId` int(11) NOT NULL auto_increment COMMENT '景点id',
  `scenicTypeObj` int(11) NOT NULL COMMENT '景点类型',
  `scenicGrade` varchar(20) NOT NULL COMMENT '景区等级 ',
  `scenicName` varchar(40) NOT NULL COMMENT '景点名称',
  `scenicDate` varchar(20) NOT NULL,
  `scenicPhoto` varchar(60) NOT NULL COMMENT '景点照片',
  `scenicDesc` varchar(2000) NOT NULL COMMENT '景点介绍',
  `latitude` double NOT NULL COMMENT '纬度',
  `longitude` double NOT NULL COMMENT '经度',
  PRIMARY KEY  (`scenicId`),
  KEY `scenicTypeObj` (`scenicTypeObj`),
  CONSTRAINT `t_scenic_ibfk_1` FOREIGN KEY (`scenicTypeObj`) REFERENCES `t_scenictype` (`typeId`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of t_scenic
-- ----------------------------
INSERT INTO `t_scenic` VALUES ('1', '3', '二级', '大学南门', '2017-05-24', 'upload/1ef35f89-1f00-40c5-9a42-c78062551015.jpg', '我们学校的食堂', '31.306996', '120.65585');
INSERT INTO `t_scenic` VALUES ('2', '2', '一级', '凌云楼', '2017-11-02', 'upload/c29b29a2-a5c1-4adc-9870-0362285bc7ec.jpg', '很高大的一座楼', '31.308504', '120.655945');
INSERT INTO `t_scenic` VALUES ('3', '2', '一级', '财经教学大楼', '2017-11-06', 'upload/100bf84c-afb8-4cf8-84cc-e0470ec0857e.jpg', '学校财经专业的大楼', '31.308191', '120.65698');

-- ----------------------------
-- Table structure for `t_scenictype`
-- ----------------------------
DROP TABLE IF EXISTS `t_scenictype`;
CREATE TABLE `t_scenictype` (
  `typeId` int(11) NOT NULL auto_increment COMMENT '类型id',
  `typeName` varchar(20) NOT NULL COMMENT '类别名称',
  PRIMARY KEY  (`typeId`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of t_scenictype
-- ----------------------------
INSERT INTO `t_scenictype` VALUES ('1', '食堂');
INSERT INTO `t_scenictype` VALUES ('2', '教学楼');
INSERT INTO `t_scenictype` VALUES ('3', '校门');
INSERT INTO `t_scenictype` VALUES ('4', '运动类');

-- ----------------------------
-- Table structure for `t_userinfo`
-- ----------------------------
DROP TABLE IF EXISTS `t_userinfo`;
CREATE TABLE `t_userinfo` (
  `user_name` varchar(20) NOT NULL COMMENT 'user_name',
  `password` varchar(20) NOT NULL COMMENT '登录密码',
  `name` varchar(20) NOT NULL COMMENT '姓名',
  `sex` varchar(4) NOT NULL COMMENT '性别',
  `birthday` varchar(20) default NULL COMMENT '出生日期',
  `userPhoto` varchar(60) NOT NULL COMMENT '用户照片',
  `telephone` varchar(20) default NULL COMMENT '联系电话',
  PRIMARY KEY  (`user_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of t_userinfo
-- ----------------------------
INSERT INTO `t_userinfo` VALUES ('user1', '123', '双鱼林', '女', '2017-11-06', 'upload/efb61b56-3700-46db-9f99-610970404731.jpg', '13958342983');
INSERT INTO `t_userinfo` VALUES ('user2', '123', '王倩', '女', '2018-02-01', 'upload/1657fd44-209d-4650-87f5-d91160acdf46.jpg', '13573598343');
