-- phpMyAdmin SQL Dump
-- version 4.6.6deb5ubuntu0.5
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Dec 16, 2021 at 06:23 AM
-- Server version: 5.7.36-0ubuntu0.18.04.1
-- PHP Version: 7.4.24

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `bhicxumy`
--

-- --------------------------------------------------------

--
-- Table structure for table `atm`
--

CREATE TABLE `atm` (
  `balance` float NOT NULL,
  `member name` varchar(30) COLLATE utf8_unicode_ci NOT NULL,
  `region` int(39) NOT NULL,
  `data` date NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `baton`
--

CREATE TABLE `baton` (
  `id` int(11) NOT NULL,
  `avatar_key` varchar(36) COLLATE utf8_unicode_ci NOT NULL,
  `baton_key` varchar(36) COLLATE utf8_unicode_ci NOT NULL,
  `properties` varchar(1000) COLLATE utf8_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `demo2`
--

CREATE TABLE `demo2` (
  `id` int(11) NOT NULL,
  `avatar_key` varchar(36) COLLATE utf8_unicode_ci NOT NULL,
  `registration_date` varchar(256) COLLATE utf8_unicode_ci NOT NULL,
  `avatar_Name` varchar(20) COLLATE utf8_unicode_ci NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `demo2`
--

INSERT INTO `demo2` (`id`, `avatar_key`, `registration_date`, `avatar_Name`) VALUES
(0, 'ccb679d9-690e-4b6c-a7eb-769712f1d0aa', '2020-05-25', ''),
(0, 'd65ba044-30e5-4d8b-b901-4e24de3592ee', '2020-05-25', ''),
(0, 'c83a345b-f901-4f51-8553-c82d15121ec4', '2020-05-27', ''),
(0, 'ed93f96c-6c0a-4060-97e3-8eab28a2f43b', '2020-06-08', ''),
(0, 'e53a44de-09d6-438c-949e-ecf79104fee3', '2020-06-11', ''),
(0, '132ccc0e-c250-4a3a-b35d-8b5bb6c608b6', '2020-06-19', '');

-- --------------------------------------------------------

--
-- Table structure for table `register`
--

CREATE TABLE `register` (
  `id` int(11) NOT NULL,
  `avatar_key` varchar(36) COLLATE utf8_unicode_ci NOT NULL,
  `registration_date` varchar(256) COLLATE utf8_unicode_ci NOT NULL,
  `amount` float NOT NULL,
  `experience` int(11) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `register`
--

INSERT INTO `register` (`id`, `avatar_key`, `registration_date`, `amount`, `experience`) VALUES
(1, 'd65ba044-30e5-4d8b-b901-4e24de3592ee', '2020-11-27', 0, 0),
(2, 'c83a345b-f901-4f51-8553-c82d15121ec4', '2020-11-27', 19.306, 221),
(3, 'ed93f96c-6c0a-4060-97e3-8eab28a2f43b', '2020-11-30', 40.701, 468),
(4, 'ccb679d9-690e-4b6c-a7eb-769712f1d0aa', '2020-11-30', 0.809, 2750),
(5, '132ccc0e-c250-4a3a-b35d-8b5bb6c608b6', '2021-05-15', 0.186, 585),
(6, '59992c57-4d1e-4f43-a0c4-6dc8ec37d665', '2021-08-03', 5.624, 71),
(11, '5151f728-6611-43b9-9f38-560022e7f102', '2021-12-08', 0, 0),
(12, '5151f728-6611-43b9-9f38-560022e7f102', '2021-12-09', 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `stand`
--

CREATE TABLE `stand` (
  `avatar_id` int(20) NOT NULL,
  `avatar_key` varchar(200) COLLATE utf8_unicode_ci NOT NULL,
  `avatar_name` varchar(20) COLLATE utf8_unicode_ci NOT NULL,
  `region` varchar(200) COLLATE utf8_unicode_ci NOT NULL,
  `previous_id` varchar(200) COLLATE utf8_unicode_ci NOT NULL,
  `present_id` varchar(200) COLLATE utf8_unicode_ci NOT NULL,
  `money` int(40) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `stand`
--

INSERT INTO `stand` (`avatar_id`, `avatar_key`, `avatar_name`, `region`, `previous_id`, `present_id`, `money`) VALUES
(1, 'ed93f96c-6c0a-4060-97e3-8eab28a2f43b', 'Gurusow Resident', 'Kazuhisa', '7e14bdc0-3efb-6051-6143-e001900ab4e6', '', 0),
(3, 'd65ba044-30e5-4d8b-b901-4e24de3592ee', 'jbc71 Resident', 'Kazuhisa', '382f9b16-81c3-a63e-2360-8af3b22bf247', '', 9),
(2, 'ccb679d9-690e-4b6c-a7eb-769712f1d0aa', 'johnbclare Resident', 'Kazuhisa', '7e14bdc0-3efb-6051-6143-e001900ab4e6', '', 0),
(4, 'd65ba044-30e5-4d8b-b901-4e24de3592ee', 'jbc71 Resident', 'Kazuhisa', '7e14bdc0-3efb-6051-6143-e001900ab4e6', '', 0),
(5, 'ed93f96c-6c0a-4060-97e3-8eab28a2f43b', 'Gurusow Resident', 'Kazuhisa', '488b2509-df92-7e26-33cb-cf2d4e8d3490', '', 0),
(6, 'ccb679d9-690e-4b6c-a7eb-769712f1d0aa', 'johnbclare Resident', 'Kazuhisa', '488b2509-df92-7e26-33cb-cf2d4e8d3490', '', 0),
(7, 'd65ba044-30e5-4d8b-b901-4e24de3592ee', 'jbc71 Resident', 'Kazuhisa', 'fa21dd91-1773-403b-b753-8cfcb7133162', '', 0),
(8, 'd65ba044-30e5-4d8b-b901-4e24de3592ee', 'jbc71 Resident', 'Zerango', '0d066706-4354-f1d8-e61a-bf6fdc532bbd', '', 9),
(9, 'd65ba044-30e5-4d8b-b901-4e24de3592ee', 'jbc71 Resident', 'Zerango', 'a492aca3-c73a-9102-c0d3-0871a09e8176', '', 9),
(10, 'd65ba044-30e5-4d8b-b901-4e24de3592ee', 'jbc71 Resident', 'Zerango', 'c8570126-f92d-8410-3c65-39ebb6c06f46', '', 8),
(11, 'ccb679d9-690e-4b6c-a7eb-769712f1d0aa', 'johnbclare Resident', 'Kazuhisa', 'be7ead4a-5f1f-d37e-aa35-8608c953462e', '', 0),
(12, 'd65ba044-30e5-4d8b-b901-4e24de3592ee', 'jbc71 Resident', 'Zerango', 'c8570126-f92d-8410-3c65-39ebb6c06f46', '', 8),
(13, 'ed93f96c-6c0a-4060-97e3-8eab28a2f43b', 'Gurusow Resident', 'Kazuhisa', 'be7ead4a-5f1f-d37e-aa35-8608c953462e', '', 9),
(14, 'ed93f96c-6c0a-4060-97e3-8eab28a2f43b', 'Gurusow Resident', 'Kazuhisa', '1f69b953-6577-9792-0def-69cb27f78306', '', 0),
(15, 'ed93f96c-6c0a-4060-97e3-8eab28a2f43b', 'Gurusow Resident', 'Kazuhisa', 'eb3cb1da-5bba-7dcd-8b9a-09bd21008ae5', '', 0),
(16, 'ed93f96c-6c0a-4060-97e3-8eab28a2f43b', 'Gurusow Resident', 'Kazuhisa', 'eb3cb1da-5bba-7dcd-8b9a-09bd21008ae5', '', 18),
(17, 'ed93f96c-6c0a-4060-97e3-8eab28a2f43b', 'Gurusow Resident', 'Kazuhisa', 'eb3cb1da-5bba-7dcd-8b9a-09bd21008ae5', '', 36),
(18, 'ed93f96c-6c0a-4060-97e3-8eab28a2f43b', 'Gurusow Resident', 'Kazuhisa', 'b1f29d22-7287-bfd4-3a94-7ce7f2e504f0', '', 9),
(25, 'd65ba044-30e5-4d8b-b901-4e24de3592ee', 'jbc71 Resident', 'Zerango', 'e9a69392-88d9-dda5-b293-05864b06fc1e', '', 5),
(19, 'ed93f96c-6c0a-4060-97e3-8eab28a2f43b', 'Gurusow Resident', 'Kazuhisa', 'd1bd9c61-b6c6-8a1d-7d89-1da177d00744', '', 0),
(20, 'd65ba044-30e5-4d8b-b901-4e24de3592ee', 'jbc71 Resident', 'Zerango', 'd42e0c2d-a271-5c16-f592-b04867f9600e', '', 8),
(21, 'd65ba044-30e5-4d8b-b901-4e24de3592ee', '', 'Kazuhisa', 'be7ead4a-5f1f-d37e-aa35-8608c953462e', '', 0),
(22, 'd65ba044-30e5-4d8b-b901-4e24de3592ee', 'jbc71 Resident', 'Zerango', '6abf2aa9-5a12-6120-7f09-1e5f9eafcd56', '', 9),
(23, 'd65ba044-30e5-4d8b-b901-4e24de3592ee', 'jbc71 Resident', 'Zerango', 'fdb1fe70-b31e-4867-c7f2-ce7119153051', '', 0),
(24, 'd65ba044-30e5-4d8b-b901-4e24de3592ee', 'jbc71 Resident', 'Zerango', '967a9d66-fd16-a650-8e77-3fffba96c1f9', '', 0),
(26, 'd65ba044-30e5-4d8b-b901-4e24de3592ee', 'jbc71 Resident', 'Kazuhisa', 'b657bee2-602f-dc46-8c76-2ecc93d1d2dd', '', 9),
(27, 'ed93f96c-6c0a-4060-97e3-8eab28a2f43b', 'Gurusow Resident', 'Kazuhisa', 'ab110c33-70bd-ac56-7223-3b3aa70664bf', '', 0),
(28, 'd65ba044-30e5-4d8b-b901-4e24de3592ee', '', 'Kazuhisa', '74447057-d5b7-c913-86b2-03397196fcfc', '', 0),
(29, 'ccb679d9-690e-4b6c-a7eb-769712f1d0aa', 'johnbclare Resident', 'Kazuhisa', '3fae30cf-cb95-ad1b-639b-74e9b6b0987b', '', 0),
(30, 'd65ba044-30e5-4d8b-b901-4e24de3592ee', 'jbc71 Resident', 'Zerango', '1fc5c520-a5db-d1fe-f975-05c0c12b79ae', '', 0),
(31, 'd65ba044-30e5-4d8b-b901-4e24de3592ee', 'jbc71 Resident', 'Zerango', '2bd7fd3b-3549-c48e-eefb-1db4d03b9055', '', 9),
(32, 'd65ba044-30e5-4d8b-b901-4e24de3592ee', 'jbc71 Resident', 'Zerango', '08ee4de8-1934-c727-aee0-58b582859f39', '', 0),
(33, 'd65ba044-30e5-4d8b-b901-4e24de3592ee', 'jbc71 Resident', 'Zerango', '06778430-b595-895b-9521-a3751bc725af', '', 0),
(34, 'd65ba044-30e5-4d8b-b901-4e24de3592ee', 'jbc71 Resident', 'Zerango', '08ee4de8-1934-c727-aee0-58b582859f39', '', 18),
(35, 'ed93f96c-6c0a-4060-97e3-8eab28a2f43b', 'Gurusow Resident', 'Kazuhisa', '2882576f-cdcb-52fa-462e-d44d23b661e8', '', 0),
(36, 'd65ba044-30e5-4d8b-b901-4e24de3592ee', 'jbc71 Resident', 'Zerango', '573625df-ab82-eca0-b669-a8dfe2744d01', '', 9),
(37, 'ed93f96c-6c0a-4060-97e3-8eab28a2f43b', 'Gurusow Resident', 'Kazuhisa', 'ee80fcba-ecb5-f7db-6f2a-15803a4eb62b', '', 0),
(38, 'd65ba044-30e5-4d8b-b901-4e24de3592ee', 'jbc71 Resident', 'Kazuhisa', '648f24bb-361d-bb75-e684-61de6fc440a3', '', 0),
(39, 'd65ba044-30e5-4d8b-b901-4e24de3592ee', 'jbc71 Resident', 'Zerango', '269af6b1-aac9-f402-62ed-4442b26b5d87', '', 0),
(40, 'ed93f96c-6c0a-4060-97e3-8eab28a2f43b', 'Gurusow Resident', 'Kazuhisa', '467635e9-faa5-2772-33ec-a3154d1e9ef8', '', 0),
(41, 'ed93f96c-6c0a-4060-97e3-8eab28a2f43b', 'Gurusow Resident', 'Kazuhisa', '435ce804-dd61-8f40-2a3b-7828f3764f05', '', 0),
(43, 'd65ba044-30e5-4d8b-b901-4e24de3592ee', 'jbc71 Resident', 'Kazuhisa', 'f8752a0d-d4c5-c288-bb0a-b043c989a582', '', 0),
(42, 'd65ba044-30e5-4d8b-b901-4e24de3592ee', 'jbc71 Resident', 'Zerango', '467635e9-faa5-2772-33ec-a3154d1e9ef8', '', 0),
(44, 'ed93f96c-6c0a-4060-97e3-8eab28a2f43b', 'Gurusow Resident', 'Kazuhisa', 'a80fa28e-34d4-56e8-6aa5-fce8b463119a', '', 9),
(45, 'd65ba044-30e5-4d8b-b901-4e24de3592ee', 'jbc71 Resident', 'Zerango', '86e00782-1a91-7c38-68d2-a4ae80763727', '', 0),
(46, 'd65ba044-30e5-4d8b-b901-4e24de3592ee', 'jbc71 Resident', 'Kazuhisa', '4d7b9782-4778-03b0-3316-865246cf2b29', '', 10),
(47, 'ed93f96c-6c0a-4060-97e3-8eab28a2f43b', 'Gurusow Resident', 'Kazuhisa', '612400d2-dfee-9f0e-c8a5-9740e6f30c3b', '', 0),
(48, 'ed93f96c-6c0a-4060-97e3-8eab28a2f43b', 'Gurusow Resident', 'Kazuhisa', '4d7b9782-4778-03b0-3316-865246cf2b29', '', 0),
(49, 'ed93f96c-6c0a-4060-97e3-8eab28a2f43b', 'Gurusow Resident', 'Kazuhisa', '3cfacde8-e4a1-f720-fd53-a79dc74c1217', '', 0),
(50, 'd65ba044-30e5-4d8b-b901-4e24de3592ee', 'jbc71 Resident', 'Zerango', 'ea9b6f6b-1d3b-ba52-eef5-648325b002d5', '', 9),
(51, 'd65ba044-30e5-4d8b-b901-4e24de3592ee', 'jbc71 Resident', 'Kazuhisa', '3cfacde8-e4a1-f720-fd53-a79dc74c1217', '', 0),
(52, 'ed93f96c-6c0a-4060-97e3-8eab28a2f43b', 'Gurusow Resident', 'Kazuhisa', 'db211fa2-2a28-fb44-5893-a2f7761e2c9b', '', 9),
(53, 'd65ba044-30e5-4d8b-b901-4e24de3592ee', 'jbc71 Resident', 'Zerango', 'ea9b6f6b-1d3b-ba52-eef5-648325b002d5', '', 12),
(54, 'd65ba044-30e5-4d8b-b901-4e24de3592ee', 'jbc71 Resident', 'Zerango', 'ea9b6f6b-1d3b-ba52-eef5-648325b002d5', '', 9),
(55, 'd65ba044-30e5-4d8b-b901-4e24de3592ee', 'jbc71 Resident', 'Zerango', 'ea9b6f6b-1d3b-ba52-eef5-648325b002d5', '', 16),
(56, 'd65ba044-30e5-4d8b-b901-4e24de3592ee', 'jbc71 Resident', 'Kazuhisa', '31057bd1-04ae-1b75-be71-0e3eb99d0dad', '', 9),
(57, '59992c57-4d1e-4f43-a0c4-6dc8ec37d665', 'LittleScripter Resid', 'Cedar Point', 'c3982738-b090-6fd7-f979-6de45537eb31', '', 200),
(58, 'd65ba044-30e5-4d8b-b901-4e24de3592ee', 'jbc71 Resident', 'Kazuhisa', 'f382b6ff-d81c-0de7-05fe-7b321ec68603', '', 200),
(59, '59992c57-4d1e-4f43-a0c4-6dc8ec37d665', 'LittleScripter Resid', 'Cedar Point', '5d214e0f-c5f2-b578-eb7b-9b503f8ea383', '', 0),
(60, '59992c57-4d1e-4f43-a0c4-6dc8ec37d665', 'LittleScripter Resid', 'Cedar Point', '5fb9ca50-99f6-db99-c95a-b18473e9ea4f', '', 200);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `atm`
--
ALTER TABLE `atm`
  ADD PRIMARY KEY (`balance`);

--
-- Indexes for table `baton`
--
ALTER TABLE `baton`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `register`
--
ALTER TABLE `register`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `stand`
--
ALTER TABLE `stand`
  ADD PRIMARY KEY (`avatar_id`,`avatar_name`,`region`,`money`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `atm`
--
ALTER TABLE `atm`
  MODIFY `balance` float NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `baton`
--
ALTER TABLE `baton`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `register`
--
ALTER TABLE `register`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;
--
-- AUTO_INCREMENT for table `stand`
--
ALTER TABLE `stand`
  MODIFY `avatar_id` int(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=61;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
