-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Хост: 127.0.0.1:3306
-- Время создания: Янв 24 2024 г., 07:08
-- Версия сервера: 8.0.30
-- Версия PHP: 8.1.9

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- База данных: `module_bmadi`
--

-- --------------------------------------------------------

--
-- Структура таблицы `billingquotas`
--

CREATE TABLE `billingquotas` (
  `id` bigint UNSIGNED NOT NULL,
  `limit` double(8,2) NOT NULL,
  `workspace` bigint UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `billingquotas`
--

INSERT INTO `billingquotas` (`id`, `limit`, `workspace`, `created_at`, `updated_at`) VALUES
(5, 6.00, 4, '2024-01-14 11:56:11', '2024-01-14 11:56:11'),
(7, 2.00, 7, '2024-01-24 01:01:25', '2024-01-24 01:01:25');

-- --------------------------------------------------------

--
-- Структура таблицы `billings`
--

CREATE TABLE `billings` (
  `id` bigint UNSIGNED NOT NULL,
  `time` double(8,2) NOT NULL,
  `total` double(8,2) NOT NULL,
  `token` bigint UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `billings`
--

INSERT INTO `billings` (`id`, `time`, `total`, `token`, `created_at`, `updated_at`) VALUES
(1, 11.50, 22.45, 6, '2024-09-13 06:52:47', NULL),
(2, 11.56, 22.45, 7, '2024-01-13 06:52:47', NULL),
(3, 24.50, 33.00, 4, '2024-01-13 06:52:47', NULL),
(4, 43.00, 22.45, 7, '2024-01-13 06:52:47', NULL);

-- --------------------------------------------------------

--
-- Структура таблицы `migrations`
--

CREATE TABLE `migrations` (
  `id` int UNSIGNED NOT NULL,
  `migration` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `batch` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(1, '2014_10_12_000000_create_users_table', 1),
(2, '2019_12_14_000001_create_personal_access_tokens_table', 1),
(3, '2024_01_12_055003_create_workspaces_table', 1),
(4, '2024_01_12_055036_create_tokens_table', 1),
(5, '2024_01_12_055052_create_billingquotas_table', 1),
(6, '2024_01_12_055115_create_billings_table', 1),
(7, '2024_01_12_055745_create_token_types_table', 1),
(19, '2024_01_12_064106_delete_email_from_users_table', 2),
(20, '2024_01_14_114922_add_tokentypesid_column_to_tokens_table', 2);

-- --------------------------------------------------------

--
-- Структура таблицы `personal_access_tokens`
--

CREATE TABLE `personal_access_tokens` (
  `id` bigint UNSIGNED NOT NULL,
  `tokenable_type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `tokenable_id` bigint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `abilities` text COLLATE utf8mb4_unicode_ci,
  `last_used_at` timestamp NULL DEFAULT NULL,
  `expires_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `tokens`
--

CREATE TABLE `tokens` (
  `id` bigint UNSIGNED NOT NULL,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(40) COLLATE utf8mb4_unicode_ci NOT NULL,
  `tokentypes_id` bigint UNSIGNED DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `workspace` bigint UNSIGNED NOT NULL,
  `tokentype` bigint UNSIGNED NOT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `tokens`
--

INSERT INTO `tokens` (`id`, `name`, `token`, `tokentypes_id`, `created_at`, `updated_at`, `workspace`, `tokentype`, `deleted_at`) VALUES
(1, 'First Token', '3nI31ACEvfECs4yUx4o1US7lPM1U71bAdUEst6Mp', 2, '2024-01-13 06:52:47', '2024-01-13 07:27:43', 5, 2, '2024-01-13 07:27:43'),
(2, 'Madi Kairambekov', 'GlsjCoCJxDj8mghhkQuHrJdH2XT6R7Krx806qURX', 2, '2024-01-13 07:31:02', '2024-01-13 07:31:04', 5, 3, '2024-01-13 07:31:04'),
(3, 'Erasyl Zhassulan', 'BvNFlUjL5ltkf5Tae8qrEuxzELlNtBznMgZp59vN', 2, '2024-01-13 07:31:11', '2024-01-13 07:31:33', 5, 2, '2024-01-13 07:31:33'),
(4, 'New token 1', '3yn5oVlMCiFvzBl1nzmEZMiIE6dX9WSvtpTKrT07', 2, '2024-01-13 07:39:27', '2024-01-13 07:39:28', 6, 2, '2024-01-13 07:39:28'),
(5, 'Madi', '0KAKj0m1eYw1MwVQFIqrurr4ti1aGshybAdpywcM', 3, '2024-01-13 14:27:13', '2024-01-13 14:27:13', 5, 2, NULL),
(6, 'First Token', 'mksVdAcVcVVgUuPVD9iUXL9ln33I1UcFxhOgP6k5', 2, '2024-01-13 14:27:18', '2024-01-13 14:27:18', 5, 3, NULL),
(7, 'New token 1', 'l79LSIcWqCnrBrYmYDlMSMp56a6gHNv1O54k2t3R', 1, '2024-01-13 14:37:59', '2024-01-13 14:37:59', 5, 1, NULL),
(8, 'New token 1', 'U9IaAbhTq2DHRvesNJeXtI4TggTWzAK0cIAXXScR', 1, '2024-01-13 14:43:44', '2024-01-13 14:43:44', 5, 1, NULL),
(9, 'New token 1', 'vQkU6Y1ejFOibGSZGNtkbpshz81WOqc6Tk08IuPu', 3, '2024-01-13 14:43:56', '2024-01-13 14:43:56', 5, 1, NULL),
(10, 'Madi Kairambekov', 'CrgcS0KYa4joK9QnhjDqXZWavCaFmRpxrWYYbS6y', 2, '2024-01-13 14:44:11', '2024-01-13 14:44:11', 5, 2, NULL),
(11, 'Мади Бахытұлы', 'BnJoi0x7qAzcNGJ9GVXtnirWMWNWmXr9VgoRYyLY', NULL, '2024-01-14 11:55:51', '2024-01-14 11:55:51', 4, 1, NULL),
(12, 'First Token', 'eloiu9RUPUoOqN0gM39dlhPZxUdtAtvpIqbMsb5b', NULL, '2024-01-14 11:55:59', '2024-01-14 11:55:59', 4, 3, NULL),
(13, 'ffffffffffff', 'ldnFJjLyLohKurIMsiRwH9EbR1NgSa478qUgFlDy', NULL, '2024-01-24 01:00:53', '2024-01-24 01:01:14', 7, 2, '2024-01-24 01:01:14');

-- --------------------------------------------------------

--
-- Структура таблицы `token_types`
--

CREATE TABLE `token_types` (
  `id` bigint UNSIGNED NOT NULL,
  `persec` double(8,2) NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `token_types`
--

INSERT INTO `token_types` (`id`, `persec`, `name`, `created_at`, `updated_at`) VALUES
(1, 0.06, 'Service#1', '2024-01-13 06:52:47', NULL),
(2, 0.10, 'Service#2', '2024-01-13 06:52:47', NULL),
(3, 0.15, 'Service#3', '2024-01-13 06:52:47', NULL);

-- --------------------------------------------------------

--
-- Структура таблицы `users`
--

CREATE TABLE `users` (
  `id` bigint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `remember_token` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `users`
--

INSERT INTO `users` (`id`, `name`, `email_verified_at`, `password`, `remember_token`, `created_at`, `updated_at`) VALUES
(1, 'demo1', NULL, '$2y$10$RjExtMWKEs51D3zlc8LG0u.At4Dy4wNkiDIGfrCCMKVxiTYg00dl2', NULL, NULL, NULL),
(2, 'demo2', NULL, 'skills2023d2', NULL, NULL, NULL),
(3, 'Michael', NULL, 'asd', NULL, '2024-01-12 13:39:49', '2024-01-12 13:39:49'),
(4, 'madi', NULL, '$2y$10$bfNd5ymDPFiTVypy6ohzoeqULMbBu6oDsDwcyCisJ9LuFMy7CEtXy', NULL, '2024-01-12 13:49:29', '2024-01-12 13:49:29'),
(5, 'timaa', NULL, '$2y$10$X2NVSHr.mCBFHau8NpP0we2wjCpPj/lRr5mLVTQ83kUY7qyCRx/3e', NULL, '2024-01-12 14:24:41', '2024-01-12 14:24:41'),
(6, 'erkhan', NULL, '$2y$10$rDnJyssIN2FM.uHfF6Cwl.bmFbBGl7KrrGgfg7nDGocF/zPEHdnm6', NULL, '2024-01-13 07:32:15', '2024-01-13 07:32:15'),
(7, 'eldok', NULL, '$2y$10$nDEU0Y.fJiambJWyUCS5zuQNUmhd9I4N12Cb7eFPKowAISn8xuc3q', NULL, '2024-01-13 07:39:13', '2024-01-13 07:39:13'),
(8, 'dd@dddd', NULL, '$2y$10$hcZEt8AHQQe8wU1dL5r9M.KDV9zgJZ.t/SwvFjoSmozqSWtQACq0e', NULL, '2024-01-24 01:00:35', '2024-01-24 01:00:35');

-- --------------------------------------------------------

--
-- Структура таблицы `workspaces`
--

CREATE TABLE `workspaces` (
  `id` bigint UNSIGNED NOT NULL,
  `title` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `user` bigint UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `workspaces`
--

INSERT INTO `workspaces` (`id`, `title`, `description`, `user`, `created_at`, `updated_at`) VALUES
(1, '2g424g', '24g24g24g24g', 1, '2024-01-12 04:23:30', '2024-01-12 04:23:30'),
(2, '2g424g', '24g24g24g24g', 1, '2024-01-12 04:24:01', '2024-01-12 04:24:01'),
(3, 'Daryn', 'Madi molodec', 1, '2024-01-12 04:31:29', '2024-01-12 04:31:29'),
(4, 'wrgwrg', 'wqergwg', 5, NULL, NULL),
(5, 'Mi', 'test3', 5, '2024-01-12 14:52:20', '2024-01-24 01:04:25'),
(6, 'Digital Bridge 2k23', '20203', 7, '2024-01-13 07:39:20', '2024-01-13 07:39:20'),
(7, 'madi', 'daryjn', 8, '2024-01-24 01:00:44', '2024-01-24 01:00:44');

--
-- Индексы сохранённых таблиц
--

--
-- Индексы таблицы `billingquotas`
--
ALTER TABLE `billingquotas`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `billings`
--
ALTER TABLE `billings`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `personal_access_tokens_token_unique` (`token`),
  ADD KEY `personal_access_tokens_tokenable_type_tokenable_id_index` (`tokenable_type`,`tokenable_id`);

--
-- Индексы таблицы `tokens`
--
ALTER TABLE `tokens`
  ADD PRIMARY KEY (`id`),
  ADD KEY `tokens_tokentypes_id_foreign` (`tokentypes_id`);

--
-- Индексы таблицы `token_types`
--
ALTER TABLE `token_types`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `workspaces`
--
ALTER TABLE `workspaces`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT для сохранённых таблиц
--

--
-- AUTO_INCREMENT для таблицы `billingquotas`
--
ALTER TABLE `billingquotas`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT для таблицы `billings`
--
ALTER TABLE `billings`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT для таблицы `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT для таблицы `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `tokens`
--
ALTER TABLE `tokens`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT для таблицы `token_types`
--
ALTER TABLE `token_types`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT для таблицы `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT для таблицы `workspaces`
--
ALTER TABLE `workspaces`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- Ограничения внешнего ключа сохраненных таблиц
--

--
-- Ограничения внешнего ключа таблицы `tokens`
--
ALTER TABLE `tokens`
  ADD CONSTRAINT `tokens_tokentypes_id_foreign` FOREIGN KEY (`tokentypes_id`) REFERENCES `token_types` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
