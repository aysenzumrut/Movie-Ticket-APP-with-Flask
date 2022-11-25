-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Anamakine: 127.0.0.1
-- Üretim Zamanı: 25 Kas 2022, 10:28:54
-- Sunucu sürümü: 10.4.25-MariaDB
-- PHP Sürümü: 8.1.10

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Veritabanı: `ybblog`
--

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `booked_tickets`
--

CREATE TABLE `booked_tickets` (
  `ticket_no` int(11) NOT NULL,
  `title` text DEFAULT NULL,
  `hall` int(11) DEFAULT NULL,
  `show_start` date DEFAULT current_timestamp(),
  `time` time DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Tablo döküm verisi `booked_tickets`
--

INSERT INTO `booked_tickets` (`ticket_no`, `title`, `hall`, `show_start`, `time`) VALUES
(1, 'Bandırma Füze Kulübü', 3, '2022-11-27', '15:00:00'),
(2, 'Bandırma Füze Kulübü', 3, '2022-11-27', '15:00:00'),
(3, 'Bandırma Füze Kulübü', 3, '2022-11-27', '15:00:00'),
(4, 'Bandırma Füze Kulübü', 3, '2022-11-27', '15:00:00'),
(5, 'Bandırma Füze Kulübü', 3, '2022-11-27', '15:00:00'),
(6, 'The Truman Show', 2, '2022-11-27', '15:00:00'),
(7, 'Back to the Future', 1, '2022-11-27', '15:00:00'),
(8, 'Buz Devri', 1, '2022-11-25', '06:30:00');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `halls`
--

CREATE TABLE `halls` (
  `hall` int(11) NOT NULL,
  `no_of_seat` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Tablo döküm verisi `halls`
--

INSERT INTO `halls` (`hall`, `no_of_seat`) VALUES
(1, 20),
(2, 20),
(3, 20);

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `movies`
--

CREATE TABLE `movies` (
  `id` int(11) NOT NULL,
  `title` text DEFAULT NULL,
  `hall` int(11) DEFAULT NULL,
  `show_start` date DEFAULT NULL,
  `time` time DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Tablo döküm verisi `movies`
--

INSERT INTO `movies` (`id`, `title`, `hall`, `show_start`, `time`) VALUES
(145, 'Back to the Future', 1, '2022-11-27', '15:00:00'),
(163, 'Buz Devri', 1, '2022-11-25', '06:30:00'),
(166, 'buz devri', 1, '2022-11-25', '20:43:00');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `price_listing`
--

CREATE TABLE `price_listing` (
  `price_id` int(11) NOT NULL,
  `day` varchar(3) DEFAULT NULL,
  `price` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `role`
--

CREATE TABLE `role` (
  `id` int(11) NOT NULL,
  `name` text DEFAULT NULL,
  `role_val` int(11) DEFAULT NULL,
  `link` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Tablo döküm verisi `role`
--

INSERT INTO `role` (`id`, `name`, `role_val`, `link`) VALUES
(1, 'manager', 1, 'manager.html'),
(2, 'user', 2, 'customer.html');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `shows`
--

CREATE TABLE `shows` (
  `show_id` int(11) NOT NULL,
  `movie_id` int(11) DEFAULT NULL,
  `hall_id` int(11) DEFAULT NULL,
  `time` int(11) DEFAULT NULL,
  `date` date DEFAULT NULL,
  `price_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `name` text NOT NULL,
  `email` text NOT NULL,
  `username` text NOT NULL,
  `password` text NOT NULL,
  `role` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Tablo döküm verisi `users`
--

INSERT INTO `users` (`id`, `name`, `email`, `username`, `password`, `role`) VALUES
(1, 'Ayşen Zümrüt Sönmez', 'manager@gmail.com', 'manager', '$5$rounds=535000$o39bYAftszGl9Ukf$Jz4HHr72rZDePN8/BYokMKQmpPkejWghGHsVFCeIGSC', 1),
(2, 'Yadigar Sönmez', 'yadigar@hotmail.com', 'ydgrsnmz', '$5$rounds=535000$Yz/3TI3MPsWmI1rF$9Sfvwgl2fkBibKN41j1XFPU/NRAfMWJyU5Szc3REwt3', 0),
(4, 'Ayşen Zümrüt Sönmez', 'azs99@windowslive.com', 'azs99', '$5$rounds=535000$6aj6MPwgqSaHX2ws$cIf3b/4BLhykY4MxLezt9.rK6TVhOiOqXbtEHvsmcJA', 0),
(5, 'Ayşen Zümrüt Sönmez', 'azs@gmail.com', 'azs1234', '$5$rounds=535000$pdzz4YIOQd0Aqt3C$eihoq3bcsqQCJ9h.wBGkytLhxWjmq4TMu5ssd9dExR2', 0);

--
-- Dökümü yapılmış tablolar için indeksler
--

--
-- Tablo için indeksler `booked_tickets`
--
ALTER TABLE `booked_tickets`
  ADD PRIMARY KEY (`ticket_no`) USING BTREE;

--
-- Tablo için indeksler `halls`
--
ALTER TABLE `halls`
  ADD PRIMARY KEY (`hall`);

--
-- Tablo için indeksler `movies`
--
ALTER TABLE `movies`
  ADD PRIMARY KEY (`id`),
  ADD KEY `hall` (`hall`);

--
-- Tablo için indeksler `price_listing`
--
ALTER TABLE `price_listing`
  ADD PRIMARY KEY (`price_id`);

--
-- Tablo için indeksler `role`
--
ALTER TABLE `role`
  ADD PRIMARY KEY (`id`);

--
-- Tablo için indeksler `shows`
--
ALTER TABLE `shows`
  ADD PRIMARY KEY (`show_id`) USING BTREE,
  ADD UNIQUE KEY `movie_id` (`movie_id`),
  ADD UNIQUE KEY `hall_id` (`hall_id`),
  ADD UNIQUE KEY `price_id` (`price_id`);

--
-- Tablo için indeksler `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`);

--
-- Dökümü yapılmış tablolar için AUTO_INCREMENT değeri
--

--
-- Tablo için AUTO_INCREMENT değeri `booked_tickets`
--
ALTER TABLE `booked_tickets`
  MODIFY `ticket_no` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- Tablo için AUTO_INCREMENT değeri `halls`
--
ALTER TABLE `halls`
  MODIFY `hall` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- Tablo için AUTO_INCREMENT değeri `movies`
--
ALTER TABLE `movies`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=167;

--
-- Tablo için AUTO_INCREMENT değeri `price_listing`
--
ALTER TABLE `price_listing`
  MODIFY `price_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- Tablo için AUTO_INCREMENT değeri `role`
--
ALTER TABLE `role`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- Tablo için AUTO_INCREMENT değeri `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- Dökümü yapılmış tablolar için kısıtlamalar
--

--
-- Tablo kısıtlamaları `movies`
--
ALTER TABLE `movies`
  ADD CONSTRAINT `movies_ibfk_1` FOREIGN KEY (`hall`) REFERENCES `halls` (`hall`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
