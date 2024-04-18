CREATE TABLE `plants` (
  `id` int(11) NOT NULL,
  `coords` longtext,
  `type` varchar(100) NOT NULL,
  `water` double NOT NULL,
  `food` double NOT NULL,
  `growth` double NOT NULL,
  `rate` double NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

ALTER TABLE `plants`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `plants`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=69;
  
  CREATE TABLE `processing` (
  `id` int(11) NOT NULL,
  `type` varchar(100) NOT NULL,
  `item` longtext,
  `time` int(11) NOT NULL,
  `coords` longtext,
  `rot` double NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

ALTER TABLE `processing`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `processing`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=36;