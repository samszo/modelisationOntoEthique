-- phpMyAdmin SQL Dump
-- version 5.2.3
-- https://www.phpmyadmin.net/
--
-- Hôte : localhost
-- Généré le : ven. 06 nov. 2026 à 18:11
-- Version du serveur : 12.0.2-MariaDB-log
-- Version de PHP : 8.3.27

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données : `omk_ontoethique`
--

-- --------------------------------------------------------

--
-- Structure de la table `annotation`
--

CREATE TABLE `annotation` (
  `id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `annotation_value`
--

CREATE TABLE `annotation_value` (
  `id` int(11) NOT NULL,
  `annotation_id` int(11) NOT NULL,
  `field` varchar(190) NOT NULL,
  `ordinal` smallint(6) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `api_key`
--

CREATE TABLE `api_key` (
  `id` varchar(32) NOT NULL,
  `owner_id` int(11) NOT NULL,
  `label` varchar(255) NOT NULL,
  `credential_hash` varchar(60) NOT NULL,
  `last_ip` varbinary(16) DEFAULT NULL COMMENT '(DC2Type:ip_address)',
  `last_accessed` datetime DEFAULT NULL,
  `created` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `api_key`
--

INSERT INTO `api_key` (`id`, `owner_id`, `label`, `credential_hash`, `last_ip`, `last_accessed`, `created`) VALUES
('udDqpj6kB4dKkgPx2de05arAXvM1vPnM', 1, 'appliCliente', '$2y$10$v2XIYTGma5Er0UCo75/MCO8Dcvn4oowgKVrcHiZdWGUnJFA0SfbwK', 0x00000000000000000000000000000001, '2026-11-06 15:38:45', '2026-10-21 13:58:54');

-- --------------------------------------------------------

--
-- Structure de la table `asset`
--

CREATE TABLE `asset` (
  `id` int(11) NOT NULL,
  `owner_id` int(11) DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `media_type` varchar(190) NOT NULL,
  `storage_id` varchar(190) NOT NULL,
  `extension` varchar(190) DEFAULT NULL,
  `alt_text` longtext DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `custom_vocab`
--

CREATE TABLE `custom_vocab` (
  `id` int(11) NOT NULL,
  `item_set_id` int(11) DEFAULT NULL,
  `owner_id` int(11) DEFAULT NULL,
  `label` varchar(190) NOT NULL,
  `lang` varchar(190) DEFAULT NULL,
  `terms` longtext DEFAULT NULL COMMENT '(DC2Type:json)',
  `uris` longtext DEFAULT NULL COMMENT '(DC2Type:json)'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `custom_vocab`
--

INSERT INTO `custom_vocab` (`id`, `item_set_id`, `owner_id`, `label`, `lang`, `terms`, `uris`) VALUES
(1, 2, 1, 'Concepts', NULL, NULL, NULL),
(2, 7, 1, 'Agents', NULL, NULL, NULL),
(3, 3, 1, 'Actants', NULL, NULL, NULL),
(4, 5, 1, 'Cribles', NULL, NULL, NULL),
(5, 6, 1, 'Personnes', NULL, NULL, NULL),
(6, 4, 1, 'Physiques', NULL, NULL, NULL),
(7, 8, 1, 'Rôles', NULL, NULL, NULL),
(8, 9, 1, 'Pouvoirs existentiels', NULL, NULL, NULL),
(9, 11, 1, 'Raisons trajectives', NULL, NULL, NULL),
(10, 10, 1, 'Pulsations existentielles', NULL, NULL, NULL),
(12, 12, 1, 'Temporalités relatives', NULL, NULL, NULL),
(13, NULL, 1, 'Annotation Motivation', NULL, '[\"assessing\",\"bookmarking\",\"classifying\",\"commenting\",\"describing\",\"editing\",\"highlighting\",\"identifying\",\"linking\",\"moderating\",\"questioning\",\"replying\",\"tagging\"]', NULL),
(14, NULL, 1, 'Annotation Target dcterms:format', NULL, '[\"application\\/geo+json\",\"application\\/json\",\"application\\/xml\",\"image\\/svg+xml\",\"application\\/wkt\"]', NULL),
(15, 29, 1, 'Ecosystèmes de connaissances', NULL, NULL, NULL),
(16, 214, 1, 'Pouvoirs', NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Structure de la table `fulltext_search`
--

CREATE TABLE `fulltext_search` (
  `id` int(11) NOT NULL,
  `resource` varchar(190) NOT NULL,
  `owner_id` int(11) DEFAULT NULL,
  `is_public` tinyint(1) NOT NULL,
  `title` longtext DEFAULT NULL,
  `text` longtext DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `fulltext_search`
--

INSERT INTO `fulltext_search` (`id`, `resource`, `owner_id`, `is_public`, `title`, `text`) VALUES
(1, 'items', 1, 1, 'philosophie', 'philosophie\nphilosophy'),
(2, 'item_sets', 1, 1, 'Concepts', 'Concepts'),
(3, 'item_sets', 1, 1, 'Actants', 'Actants'),
(4, 'item_sets', 1, 1, 'Physiques', 'Physiques'),
(5, 'item_sets', 1, 1, 'Cribles', 'Cribles'),
(6, 'item_sets', 1, 1, 'Personnes', 'Personnes'),
(7, 'item_sets', 1, 1, 'Agents', 'Agents'),
(8, 'item_sets', 1, 1, 'Rôles', 'Rôles'),
(9, 'item_sets', 1, 1, 'Pouvoirs existentiels', 'Pouvoirs existentiels'),
(10, 'item_sets', 1, 1, 'Pulsations existentielles', 'Pulsations existentielles'),
(11, 'item_sets', 1, 1, 'Raisons trajectives', 'Raisons trajectives'),
(12, 'item_sets', 1, 1, 'Temporalités relatives', 'Temporalités relatives'),
(13, 'items', 1, 1, 'Avant', 'Avant\nbefore\nTemporalité\nCollaborations entre Jean-Pierre Balpe et Samuel Szoniecky'),
(14, 'items', 1, 1, 'Pendant', 'Pendant\nduring\nTemporalité\nCollaborations entre Jean-Pierre Balpe et Samuel Szoniecky'),
(16, 'items', 1, 1, 'Après', 'Après\nafter\nTemporalité\nCollaborations entre Jean-Pierre Balpe et Samuel Szoniecky'),
(29, 'item_sets', 1, 1, 'Ecosytèmes de connaissances', 'Ecosytèmes de connaissances'),
(42, 'items', 1, 1, 'Collaborations entre Jean-Pierre Balpe et Samuel Szoniecky', 'Collaborations entre Jean-Pierre Balpe et Samuel Szoniecky\nRetrace l\'évolution technologique, poétique et épistémologique des systèmes de génération automatique de textes, depuis les algorithmes combinatoires et chaotiques des années 1980-1990 jusqu\'aux architectures contemporaines d\'intelligence artificielle générative et multi-agents\nEcoSpace : positions des éléments\necospace-42'),
(43, 'items', 1, 1, 'Samuel Szoniecky', 'Samuel Szoniecky\nDes générateurs chaotiques aux IA génératives'),
(44, 'items', 1, 1, 'Jean-Pierre Balpe', 'Jean-Pierre Balpe\nDes générateurs chaotiques aux IA génératives'),
(46, 'items', 1, 1, 'HyperCard', 'HyperCard\n\n'),
(48, 'items', 1, 1, 'PhilosHard', 'PhilosHard\nDes générateurs chaotiques aux IA génératives'),
(54, 'items', 1, 1, 'Plastique d\'Espace Numérique', 'Plastique d\'Espace Numérique\n\n1996-09-01 1 September 1996\n100\nSamuel Szoniecky\nIMG_20261104_164004.jpg'),
(55, 'media', 1, 1, 'IMG_20261104_164004.jpg', 'IMG_20261104_164004.jpg'),
(58, 'items', 1, 1, 'Samuel Szoniecky', 'Samuel Szoniecky\n\n'),
(69, 'items', 1, 1, 'Décompose en parties', 'Décompose en parties\nDécompose un élément physique en un nombre de parties défini dans la valeur d\'annotation jdc:cribleRatingValue\njdc:cribleRatingValue\ndecomposeParties'),
(75, 'items', 1, 1, 'Plastique d\'Espace Numérique - page 1', 'Plastique d\'Espace Numérique - page 1\n2026-11-05 5 November 2026\n1\n\nPlastique d\'Espace Numérique\nIMG_20261105_084858.jpg'),
(76, 'media', 1, 1, 'IMG_20261105_084858.jpg', 'IMG_20261105_084858.jpg'),
(77, 'items', 1, 1, 'Plastique d\'Espace Numérique - page 2', 'Plastique d\'Espace Numérique - page 2\nPlastique d\'Espace Numérique\n\n2026-11-05 5 November 2026\n1'),
(78, 'items', 1, 1, 'Plastique d\'Espace Numérique - page 3', 'Plastique d\'Espace Numérique - page 3\nPlastique d\'Espace Numérique\n\n2026-11-05 5 November 2026\n1'),
(79, 'items', 1, 1, 'Plastique d\'Espace Numérique - page 4', 'Plastique d\'Espace Numérique - page 4\nPlastique d\'Espace Numérique\n\n2026-11-05 5 November 2026\n1'),
(80, 'items', 1, 1, 'Plastique d\'Espace Numérique - page 5', 'Plastique d\'Espace Numérique - page 5\nPlastique d\'Espace Numérique\n\n2026-11-05 5 November 2026\n1'),
(81, 'items', 1, 1, 'Plastique d\'Espace Numérique - page 6', 'Plastique d\'Espace Numérique - page 6\nPlastique d\'Espace Numérique\n\n2026-11-05 5 November 2026\n1'),
(82, 'items', 1, 1, 'Plastique d\'Espace Numérique - page 7', 'Plastique d\'Espace Numérique - page 7\nPlastique d\'Espace Numérique\n\n2026-11-05 5 November 2026\n1'),
(83, 'items', 1, 1, 'Plastique d\'Espace Numérique - page 8', 'Plastique d\'Espace Numérique - page 8\nPlastique d\'Espace Numérique\n\n2026-11-05 5 November 2026\n1'),
(84, 'items', 1, 1, 'Plastique d\'Espace Numérique - page 9', 'Plastique d\'Espace Numérique - page 9\nPlastique d\'Espace Numérique\n\n2026-11-05 5 November 2026\n1'),
(85, 'items', 1, 1, 'Plastique d\'Espace Numérique - page 10', 'Plastique d\'Espace Numérique - page 10\nPlastique d\'Espace Numérique\n\n2026-11-05 5 November 2026\n1'),
(86, 'items', 1, 1, 'Plastique d\'Espace Numérique - page 11', 'Plastique d\'Espace Numérique - page 11\nPlastique d\'Espace Numérique\n\n2026-11-05 5 November 2026\n1'),
(87, 'items', 1, 1, 'Plastique d\'Espace Numérique - page 12', 'Plastique d\'Espace Numérique - page 12\nPlastique d\'Espace Numérique\n\n2026-11-05 5 November 2026\n1'),
(88, 'items', 1, 1, 'Plastique d\'Espace Numérique - page 13', 'Plastique d\'Espace Numérique - page 13\nPlastique d\'Espace Numérique\n\n2026-11-05 5 November 2026\n1'),
(89, 'items', 1, 1, 'Plastique d\'Espace Numérique - page 14', 'Plastique d\'Espace Numérique - page 14\nPlastique d\'Espace Numérique\n\n2026-11-05 5 November 2026\n1'),
(90, 'items', 1, 1, 'Plastique d\'Espace Numérique - page 15', 'Plastique d\'Espace Numérique - page 15\nPlastique d\'Espace Numérique\n\n2026-11-05 5 November 2026\n1'),
(91, 'items', 1, 1, 'Plastique d\'Espace Numérique - page 16', 'Plastique d\'Espace Numérique - page 16\nPlastique d\'Espace Numérique\n\n2026-11-05 5 November 2026\n1'),
(92, 'items', 1, 1, 'Plastique d\'Espace Numérique - page 17', 'Plastique d\'Espace Numérique - page 17\nPlastique d\'Espace Numérique\n\n2026-11-05 5 November 2026\n1'),
(93, 'items', 1, 1, 'Plastique d\'Espace Numérique - page 18', 'Plastique d\'Espace Numérique - page 18\nPlastique d\'Espace Numérique\n\n2026-11-05 5 November 2026\n1'),
(94, 'items', 1, 1, 'Plastique d\'Espace Numérique - page 19', 'Plastique d\'Espace Numérique - page 19\nPlastique d\'Espace Numérique\n\n2026-11-05 5 November 2026\n1'),
(95, 'items', 1, 1, 'Plastique d\'Espace Numérique - page 20', 'Plastique d\'Espace Numérique - page 20\nPlastique d\'Espace Numérique\n\n2026-11-05 5 November 2026\n1'),
(96, 'items', 1, 1, 'Plastique d\'Espace Numérique - page 21', 'Plastique d\'Espace Numérique - page 21\nPlastique d\'Espace Numérique\n\n2026-11-05 5 November 2026\n1'),
(97, 'items', 1, 1, 'Plastique d\'Espace Numérique - page 22', 'Plastique d\'Espace Numérique - page 22\nPlastique d\'Espace Numérique\n\n2026-11-05 5 November 2026\n1'),
(98, 'items', 1, 1, 'Plastique d\'Espace Numérique - page 23', 'Plastique d\'Espace Numérique - page 23\nPlastique d\'Espace Numérique\n\n2026-11-05 5 November 2026\n1'),
(99, 'items', 1, 1, 'Plastique d\'Espace Numérique - page 24', 'Plastique d\'Espace Numérique - page 24\nPlastique d\'Espace Numérique\n\n2026-11-05 5 November 2026\n1'),
(100, 'items', 1, 1, 'Plastique d\'Espace Numérique - page 25', 'Plastique d\'Espace Numérique - page 25\nPlastique d\'Espace Numérique\n\n2026-11-05 5 November 2026\n1'),
(101, 'items', 1, 1, 'Plastique d\'Espace Numérique - page 26', 'Plastique d\'Espace Numérique - page 26\nPlastique d\'Espace Numérique\n\n2026-11-05 5 November 2026\n1'),
(102, 'items', 1, 1, 'Plastique d\'Espace Numérique - page 27', 'Plastique d\'Espace Numérique - page 27\nPlastique d\'Espace Numérique\n\n2026-11-05 5 November 2026\n1'),
(103, 'items', 1, 1, 'Plastique d\'Espace Numérique - page 28', 'Plastique d\'Espace Numérique - page 28\nPlastique d\'Espace Numérique\n\n2026-11-05 5 November 2026\n1'),
(104, 'items', 1, 1, 'Plastique d\'Espace Numérique - page 29', 'Plastique d\'Espace Numérique - page 29\nPlastique d\'Espace Numérique\n\n2026-11-05 5 November 2026\n1'),
(105, 'items', 1, 1, 'Plastique d\'Espace Numérique - page 30', 'Plastique d\'Espace Numérique - page 30\nPlastique d\'Espace Numérique\n\n2026-11-05 5 November 2026\n1'),
(106, 'items', 1, 1, 'Plastique d\'Espace Numérique - page 31', 'Plastique d\'Espace Numérique - page 31\nPlastique d\'Espace Numérique\n\n2026-11-05 5 November 2026\n1'),
(107, 'items', 1, 1, 'Plastique d\'Espace Numérique - page 32', 'Plastique d\'Espace Numérique - page 32\nPlastique d\'Espace Numérique\n\n2026-11-05 5 November 2026\n1'),
(108, 'items', 1, 1, 'Plastique d\'Espace Numérique - page 33', 'Plastique d\'Espace Numérique - page 33\nPlastique d\'Espace Numérique\n\n2026-11-05 5 November 2026\n1'),
(109, 'items', 1, 1, 'Plastique d\'Espace Numérique - page 34', 'Plastique d\'Espace Numérique - page 34\nPlastique d\'Espace Numérique\n\n2026-11-05 5 November 2026\n1'),
(110, 'items', 1, 1, 'Plastique d\'Espace Numérique - page 35', 'Plastique d\'Espace Numérique - page 35\nPlastique d\'Espace Numérique\n\n2026-11-05 5 November 2026\n1'),
(111, 'items', 1, 1, 'Plastique d\'Espace Numérique - page 36', 'Plastique d\'Espace Numérique - page 36\nPlastique d\'Espace Numérique\n\n2026-11-05 5 November 2026\n1'),
(112, 'items', 1, 1, 'Plastique d\'Espace Numérique - page 37', 'Plastique d\'Espace Numérique - page 37\nPlastique d\'Espace Numérique\n\n2026-11-05 5 November 2026\n1'),
(113, 'items', 1, 1, 'Plastique d\'Espace Numérique - page 38', 'Plastique d\'Espace Numérique - page 38\nPlastique d\'Espace Numérique\n\n2026-11-05 5 November 2026\n1'),
(114, 'items', 1, 1, 'Plastique d\'Espace Numérique - page 39', 'Plastique d\'Espace Numérique - page 39\nPlastique d\'Espace Numérique\n\n2026-11-05 5 November 2026\n1'),
(115, 'items', 1, 1, 'Plastique d\'Espace Numérique - page 40', 'Plastique d\'Espace Numérique - page 40\nPlastique d\'Espace Numérique\n\n2026-11-05 5 November 2026\n1'),
(116, 'items', 1, 1, 'Plastique d\'Espace Numérique - page 41', 'Plastique d\'Espace Numérique - page 41\nPlastique d\'Espace Numérique\n\n2026-11-05 5 November 2026\n1'),
(117, 'items', 1, 1, 'Plastique d\'Espace Numérique - page 42', 'Plastique d\'Espace Numérique - page 42\nPlastique d\'Espace Numérique\n\n2026-11-05 5 November 2026\n1'),
(118, 'items', 1, 1, 'Plastique d\'Espace Numérique - page 43', 'Plastique d\'Espace Numérique - page 43\nPlastique d\'Espace Numérique\n\n2026-11-05 5 November 2026\n1'),
(119, 'items', 1, 1, 'Plastique d\'Espace Numérique - page 44', 'Plastique d\'Espace Numérique - page 44\nPlastique d\'Espace Numérique\n\n2026-11-05 5 November 2026\n1'),
(120, 'items', 1, 1, 'Plastique d\'Espace Numérique - page 45', 'Plastique d\'Espace Numérique - page 45\nPlastique d\'Espace Numérique\n\n2026-11-05 5 November 2026\n1'),
(121, 'items', 1, 1, 'Plastique d\'Espace Numérique - page 46', 'Plastique d\'Espace Numérique - page 46\nPlastique d\'Espace Numérique\n\n2026-11-05 5 November 2026\n1'),
(129, 'media', 1, 1, NULL, ''),
(130, 'media', 1, 1, NULL, ''),
(131, 'media', 1, 1, NULL, ''),
(136, 'items', 1, 1, 'Temporalité', 'Temporalité\nAvant\nCollaborations entre Jean-Pierre Balpe et Samuel Szoniecky\nPendant\nCollaborations entre Jean-Pierre Balpe et Samuel Szoniecky\nAprès\nCollaborations entre Jean-Pierre Balpe et Samuel Szoniecky'),
(209, 'items', 1, 1, 'Pouvoirs', 'Pouvoirs\npower'),
(210, 'items', 1, 1, 'Dicerner', 'Dicerner\ndiscernment\n'),
(211, 'items', 1, 1, 'Raisonner', 'Raisonner\nreason\n\n\n\n'),
(212, 'items', 1, 1, 'Résonner', 'Résonner\nresonance\n\n\n\n'),
(213, 'items', 1, 1, 'Agir', 'Agir\nactivity\n\n\n'),
(214, 'item_sets', 1, 1, 'Pouvoirs', 'Pouvoirs'),
(221, 'items', 1, 1, 'HyperCard', 'HyperCard\n\n'),
(224, 'items', 1, 1, 'source', 'source\nCollaborations entre Jean-Pierre Balpe et Samuel Szoniecky'),
(225, 'items', 1, 1, 'Définir les sources', 'Définir les sources\nSamuel Szoniecky\nHyperCard\nactant\nPhilosHard\nPlastique d\'Espace Numérique - page 1\nsource\nDéfinir\n\n0\nCollaborations entre Jean-Pierre Balpe et Samuel Szoniecky'),
(266, 'items', 1, 1, 'Définir', 'Définir\n'),
(280, 'items', 1, 1, 'Evaluer la pertinence', 'Evaluer la pertinence\nSamuel Szoniecky\nactant\nsource\nconcept source\nDéfinir\nconcept destination\n\n0\nCollaborations entre Jean-Pierre Balpe et Samuel Szoniecky'),
(284, 'items', 1, 1, 'Saisir', 'Saisir\n'),
(285, 'media', 1, 1, 'EcoSpace : positions des éléments', 'EcoSpace : positions des éléments\necospace-42'),
(286, 'items', 1, 1, 'Saisir les données', 'Saisir les données\nSamuel Szoniecky\nactant\nHyperCard\nactant\nPhilosHard\ncrible\nPlastique d\'Espace Numérique - page 1\nphysique\nsource\nconcept\nSaisir\nconcept\n\n0\nCollaborations entre Jean-Pierre Balpe et Samuel Szoniecky'),
(299, 'items', 1, 1, 'Initialiser une partition multimédia', 'Initialiser une partition multimédia\n\n\n1\n\n\n2\n\n\n3\nCollaborations entre Jean-Pierre Balpe et Samuel Szoniecky');

-- --------------------------------------------------------

--
-- Structure de la table `item`
--

CREATE TABLE `item` (
  `id` int(11) NOT NULL,
  `primary_media_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `item`
--

INSERT INTO `item` (`id`, `primary_media_id`) VALUES
(1, NULL),
(13, NULL),
(14, NULL),
(16, NULL),
(42, NULL),
(43, NULL),
(44, NULL),
(46, NULL),
(48, NULL),
(58, NULL),
(69, NULL),
(75, NULL),
(77, NULL),
(78, NULL),
(79, NULL),
(80, NULL),
(81, NULL),
(82, NULL),
(83, NULL),
(84, NULL),
(85, NULL),
(86, NULL),
(87, NULL),
(88, NULL),
(89, NULL),
(90, NULL),
(91, NULL),
(92, NULL),
(93, NULL),
(94, NULL),
(95, NULL),
(96, NULL),
(97, NULL),
(98, NULL),
(99, NULL),
(100, NULL),
(101, NULL),
(102, NULL),
(103, NULL),
(104, NULL),
(105, NULL),
(106, NULL),
(107, NULL),
(108, NULL),
(109, NULL),
(110, NULL),
(111, NULL),
(112, NULL),
(113, NULL),
(114, NULL),
(115, NULL),
(116, NULL),
(117, NULL),
(118, NULL),
(119, NULL),
(120, NULL),
(121, NULL),
(136, NULL),
(209, NULL),
(210, NULL),
(211, NULL),
(212, NULL),
(213, NULL),
(221, NULL),
(224, NULL),
(225, NULL),
(266, NULL),
(280, NULL),
(284, NULL),
(286, NULL),
(299, NULL),
(54, 55);

-- --------------------------------------------------------

--
-- Structure de la table `item_item_set`
--

CREATE TABLE `item_item_set` (
  `item_id` int(11) NOT NULL,
  `item_set_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `item_item_set`
--

INSERT INTO `item_item_set` (`item_id`, `item_set_id`) VALUES
(1, 2),
(13, 2),
(13, 12),
(14, 2),
(14, 12),
(16, 2),
(16, 12),
(42, 29),
(43, 6),
(44, 6),
(46, 7),
(48, 5),
(54, 4),
(58, 3),
(69, 5),
(75, 4),
(77, 4),
(78, 4),
(79, 4),
(80, 4),
(81, 4),
(82, 4),
(83, 4),
(84, 4),
(85, 4),
(86, 4),
(87, 4),
(88, 4),
(89, 4),
(90, 4),
(91, 4),
(92, 4),
(93, 4),
(94, 4),
(95, 4),
(96, 4),
(97, 4),
(98, 4),
(99, 4),
(100, 4),
(101, 4),
(102, 4),
(103, 4),
(104, 4),
(105, 4),
(106, 4),
(107, 4),
(108, 4),
(109, 4),
(110, 4),
(111, 4),
(112, 4),
(113, 4),
(114, 4),
(115, 4),
(116, 4),
(117, 4),
(118, 4),
(119, 4),
(120, 4),
(121, 4),
(136, 2),
(209, 2),
(210, 2),
(210, 214),
(211, 2),
(211, 214),
(212, 2),
(212, 214),
(213, 2),
(213, 214),
(221, 3),
(224, 2),
(225, 9),
(266, 2),
(280, 9),
(284, 2),
(286, 9),
(299, 10);

-- --------------------------------------------------------

--
-- Structure de la table `item_set`
--

CREATE TABLE `item_set` (
  `id` int(11) NOT NULL,
  `is_open` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `item_set`
--

INSERT INTO `item_set` (`id`, `is_open`) VALUES
(2, 0),
(3, 0),
(4, 0),
(5, 0),
(6, 0),
(7, 0),
(8, 0),
(9, 0),
(10, 0),
(11, 0),
(12, 0),
(29, 0),
(214, 0);

-- --------------------------------------------------------

--
-- Structure de la table `item_site`
--

CREATE TABLE `item_site` (
  `item_id` int(11) NOT NULL,
  `site_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `job`
--

CREATE TABLE `job` (
  `id` int(11) NOT NULL,
  `owner_id` int(11) DEFAULT NULL,
  `pid` varchar(190) DEFAULT NULL,
  `status` varchar(190) DEFAULT NULL,
  `class` varchar(190) NOT NULL,
  `args` longtext DEFAULT NULL COMMENT '(DC2Type:json_array)',
  `log` longtext DEFAULT NULL,
  `started` datetime NOT NULL,
  `ended` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `job`
--

INSERT INTO `job` (`id`, `owner_id`, `pid`, `status`, `class`, `args`, `log`, `started`, `ended`) VALUES
(1, 1, '85578', 'completed', 'EasyAdmin\\Job\\CronTasks', '{\"tasks\":{\"session_8\":{\"enabled\":true,\"frequency\":\"hourly\"}},\"manual\":false}', '2026-10-31T07:32:00+00:00 NOTICE (5): Starting cron execution with 1 tasks. {\"referenceId\":\"easy-admin/cron/job_1\"}\n2026-10-31T07:32:00+00:00 INFO (6): Executing task \"session_8\". {\"referenceId\":\"easy-admin/cron/job_1\"}\n2026-10-31T07:32:00+00:00 NOTICE (5): Cron execution completed: 1 tasks executed, 0 errors. {\"referenceId\":\"easy-admin/cron/job_1\"}\n', '2026-10-31 07:32:00', '2026-10-31 07:32:00'),
(2, 1, '32037', 'completed', 'AdvancedResourceTemplate\\Job\\ApplyTemplate', '{\"template_id\":2,\"fix\":false,\"fix_default_values\":false,\"fix_automatic_values\":false,\"fix_truncate\":false,\"fix_max_values\":false,\"fix_visibility\":false,\"fix_data_types\":false,\"fix_extra_properties\":false}', '2026-10-31T08:00:30+00:00 NOTICE (5): Applying template \"Concept\" (mode: audit). {\"referenceId\":\"art/apply-template/job_2\"}\n2026-10-31T08:00:30+00:00 INFO (6): Processing 1 items with template. {\"referenceId\":\"art/apply-template/job_2\"}\n2026-10-31T08:00:30+00:00 INFO (6): Resource #1: dcterms:isReferencedBy: data type \"uri\" is not allowed by the template (allowed: valuesuggest:idref:subject). Use BulkEdit for manual conversion. {\"referenceId\":\"art/apply-template/job_2\"}\n2026-10-31T08:00:30+00:00 NOTICE (5): Template \"Concept\": 4 properties not used by any resource: dcterms:description, skos:broader, skos:narrower, skos:related. {\"referenceId\":\"art/apply-template/job_2\"}\n2026-10-31T08:00:30+00:00 NOTICE (5): Template \"Concept\" audited: 1 resources checked, 1 issues found. {\"fixed\":0,\"skipped\":1} {\"referenceId\":\"art/apply-template/job_2\"}\n', '2026-10-31 08:00:29', '2026-10-31 08:00:30'),
(3, 1, '83206', 'completed', 'EasyAdmin\\Job\\CronTasks', '{\"tasks\":{\"session_8\":{\"enabled\":true,\"frequency\":\"hourly\"}},\"manual\":false}', '2026-10-31T08:32:30+00:00 NOTICE (5): Starting cron execution with 1 tasks. {\"referenceId\":\"easy-admin/cron/job_3\"}\n2026-10-31T08:32:30+00:00 INFO (6): Executing task \"session_8\". {\"referenceId\":\"easy-admin/cron/job_3\"}\n2026-10-31T08:32:30+00:00 NOTICE (5): Cron execution completed: 1 tasks executed, 0 errors. {\"referenceId\":\"easy-admin/cron/job_3\"}\n', '2026-10-31 08:32:29', '2026-10-31 08:32:30'),
(4, 1, '84157', 'completed', 'EasyAdmin\\Job\\CronTasks', '{\"tasks\":{\"session_8\":{\"enabled\":true,\"frequency\":\"hourly\"}},\"manual\":false}', '2026-10-31T10:37:12+00:00 NOTICE (5): Starting cron execution with 1 tasks. {\"referenceId\":\"easy-admin/cron/job_4\"}\n2026-10-31T10:37:12+00:00 INFO (6): Executing task \"session_8\". {\"referenceId\":\"easy-admin/cron/job_4\"}\n2026-10-31T10:37:12+00:00 NOTICE (5): Cron execution completed: 1 tasks executed, 0 errors. {\"referenceId\":\"easy-admin/cron/job_4\"}\n', '2026-10-31 10:37:12', '2026-10-31 10:37:12'),
(5, 1, '9937', 'completed', 'EasyAdmin\\Job\\CronTasks', '{\"tasks\":{\"session_8\":{\"enabled\":true,\"frequency\":\"hourly\"}},\"manual\":false}', '2026-11-01T04:28:54+00:00 NOTICE (5): Starting cron execution with 1 tasks. {\"referenceId\":\"easy-admin/cron/job_5\"}\n2026-11-01T04:28:54+00:00 INFO (6): Executing task \"session_8\". {\"referenceId\":\"easy-admin/cron/job_5\"}\n2026-11-01T04:28:54+00:00 NOTICE (5): Cron execution completed: 1 tasks executed, 0 errors. {\"referenceId\":\"easy-admin/cron/job_5\"}\n', '2026-11-01 04:28:54', '2026-11-01 04:28:54'),
(6, 1, '92988', 'completed', 'EasyAdmin\\Job\\CronTasks', '{\"tasks\":{\"session_8\":{\"enabled\":true,\"frequency\":\"hourly\"}},\"manual\":false}', '2026-11-04T06:30:08+00:00 NOTICE (5): Starting cron execution with 1 tasks. {\"referenceId\":\"easy-admin/cron/job_6\"}\n2026-11-04T06:30:08+00:00 INFO (6): Executing task \"session_8\". {\"referenceId\":\"easy-admin/cron/job_6\"}\n2026-11-04T06:30:08+00:00 NOTICE (5): Cron execution completed: 1 tasks executed, 0 errors. {\"referenceId\":\"easy-admin/cron/job_6\"}\n', '2026-11-04 06:30:08', '2026-11-04 06:30:08'),
(7, 1, '25931', 'completed', 'EasyAdmin\\Job\\CronTasks', '{\"tasks\":{\"session_8\":{\"enabled\":true,\"frequency\":\"hourly\"}},\"manual\":false}', '2026-11-04T09:27:50+00:00 NOTICE (5): Starting cron execution with 1 tasks. {\"referenceId\":\"easy-admin/cron/job_7\"}\n2026-11-04T09:27:50+00:00 INFO (6): Executing task \"session_8\". {\"referenceId\":\"easy-admin/cron/job_7\"}\n2026-11-04T09:27:50+00:00 NOTICE (5): Cron execution completed: 1 tasks executed, 0 errors. {\"referenceId\":\"easy-admin/cron/job_7\"}\n', '2026-11-04 09:27:50', '2026-11-04 09:27:50'),
(8, NULL, '14734', 'completed', 'EasyAdmin\\Job\\CronTasks', '{\"tasks\":{\"session_8\":{\"enabled\":true,\"frequency\":\"hourly\"}},\"manual\":false}', '2026-11-04T11:30:29+00:00 NOTICE (5): Starting cron execution with 1 tasks. {\"referenceId\":\"easy-admin/cron/job_8\"}\n2026-11-04T11:30:29+00:00 INFO (6): Executing task \"session_8\". {\"referenceId\":\"easy-admin/cron/job_8\"}\n2026-11-04T11:30:29+00:00 NOTICE (5): Cron execution completed: 1 tasks executed, 0 errors. {\"referenceId\":\"easy-admin/cron/job_8\"}\n', '2026-11-04 11:30:28', '2026-11-04 11:30:29'),
(9, 1, '2202', 'completed', 'EasyAdmin\\Job\\CronTasks', '{\"tasks\":{\"session_8\":{\"enabled\":true,\"frequency\":\"hourly\"}},\"manual\":false}', '2026-11-04T13:32:21+00:00 NOTICE (5): Starting cron execution with 1 tasks. {\"referenceId\":\"easy-admin/cron/job_9\"}\n2026-11-04T13:32:21+00:00 INFO (6): Executing task \"session_8\". {\"referenceId\":\"easy-admin/cron/job_9\"}\n2026-11-04T13:32:21+00:00 NOTICE (5): Cron execution completed: 1 tasks executed, 0 errors. {\"referenceId\":\"easy-admin/cron/job_9\"}\n', '2026-11-04 13:32:21', '2026-11-04 13:32:21'),
(10, 1, '62282', 'completed', 'EasyAdmin\\Job\\CronTasks', '{\"tasks\":{\"session_8\":{\"enabled\":true,\"frequency\":\"hourly\"}},\"manual\":false}', '2026-11-04T14:57:58+00:00 NOTICE (5): Starting cron execution with 1 tasks. {\"referenceId\":\"easy-admin/cron/job_10\"}\n2026-11-04T14:57:58+00:00 INFO (6): Executing task \"session_8\". {\"referenceId\":\"easy-admin/cron/job_10\"}\n2026-11-04T14:57:58+00:00 NOTICE (5): Cron execution completed: 1 tasks executed, 0 errors. {\"referenceId\":\"easy-admin/cron/job_10\"}\n', '2026-11-04 14:57:57', '2026-11-04 14:57:58'),
(11, 1, '25767', 'completed', 'EasyAdmin\\Job\\CronTasks', '{\"tasks\":{\"session_8\":{\"enabled\":true,\"frequency\":\"hourly\"}},\"manual\":false}', '2026-11-05T06:28:36+00:00 NOTICE (5): Starting cron execution with 1 tasks. {\"referenceId\":\"easy-admin/cron/job_11\"}\n2026-11-05T06:28:36+00:00 INFO (6): Executing task \"session_8\". {\"referenceId\":\"easy-admin/cron/job_11\"}\n2026-11-05T06:28:36+00:00 NOTICE (5): Cron execution completed: 1 tasks executed, 0 errors. {\"referenceId\":\"easy-admin/cron/job_11\"}\n', '2026-11-05 06:28:36', '2026-11-05 06:28:36'),
(12, 1, '94507', 'completed', 'EasyAdmin\\Job\\CronTasks', '{\"tasks\":{\"session_8\":{\"enabled\":true,\"frequency\":\"hourly\"}},\"manual\":false}', '2026-11-05T08:04:27+00:00 NOTICE (5): Starting cron execution with 1 tasks. {\"referenceId\":\"easy-admin/cron/job_12\"}\n2026-11-05T08:04:27+00:00 INFO (6): Executing task \"session_8\". {\"referenceId\":\"easy-admin/cron/job_12\"}\n2026-11-05T08:04:27+00:00 NOTICE (5): Cron execution completed: 1 tasks executed, 0 errors. {\"referenceId\":\"easy-admin/cron/job_12\"}\n', '2026-11-05 08:04:27', '2026-11-05 08:04:27'),
(13, 1, '58345', 'completed', 'EasyAdmin\\Job\\CronTasks', '{\"tasks\":{\"session_8\":{\"enabled\":true,\"frequency\":\"hourly\"}},\"manual\":false}', '2026-11-05T09:30:20+00:00 NOTICE (5): Starting cron execution with 1 tasks. {\"referenceId\":\"easy-admin/cron/job_13\"}\n2026-11-05T09:30:20+00:00 INFO (6): Executing task \"session_8\". {\"referenceId\":\"easy-admin/cron/job_13\"}\n2026-11-05T09:30:20+00:00 NOTICE (5): Cron execution completed: 1 tasks executed, 0 errors. {\"referenceId\":\"easy-admin/cron/job_13\"}\n', '2026-11-05 09:30:20', '2026-11-05 09:30:20'),
(14, 1, '83718', 'completed', 'EasyAdmin\\Job\\CronTasks', '{\"tasks\":{\"session_8\":{\"enabled\":true,\"frequency\":\"hourly\"}},\"manual\":false}', '2026-11-05T14:39:13+00:00 NOTICE (5): Starting cron execution with 1 tasks. {\"referenceId\":\"easy-admin/cron/job_14\"}\n2026-11-05T14:39:13+00:00 INFO (6): Executing task \"session_8\". {\"referenceId\":\"easy-admin/cron/job_14\"}\n2026-11-05T14:39:13+00:00 NOTICE (5): Cron execution completed: 1 tasks executed, 0 errors. {\"referenceId\":\"easy-admin/cron/job_14\"}\n', '2026-11-05 14:39:13', '2026-11-05 14:39:13'),
(15, 1, '60158', 'completed', 'EasyAdmin\\Job\\CronTasks', '{\"tasks\":{\"session_8\":{\"enabled\":true,\"frequency\":\"hourly\"}},\"manual\":false}', '2026-11-05T16:21:48+00:00 NOTICE (5): Starting cron execution with 1 tasks. {\"referenceId\":\"easy-admin/cron/job_15\"}\n2026-11-05T16:21:48+00:00 INFO (6): Executing task \"session_8\". {\"referenceId\":\"easy-admin/cron/job_15\"}\n2026-11-05T16:21:48+00:00 NOTICE (5): Cron execution completed: 1 tasks executed, 0 errors. {\"referenceId\":\"easy-admin/cron/job_15\"}\n', '2026-11-05 16:21:48', '2026-11-05 16:21:48'),
(16, 1, '79677', 'completed', 'EasyAdmin\\Job\\CronTasks', '{\"tasks\":{\"session_8\":{\"enabled\":true,\"frequency\":\"hourly\"}},\"manual\":false}', '2026-11-06T04:34:51+00:00 NOTICE (5): Starting cron execution with 1 tasks. {\"referenceId\":\"easy-admin/cron/job_16\"}\n2026-11-06T04:34:51+00:00 INFO (6): Executing task \"session_8\". {\"referenceId\":\"easy-admin/cron/job_16\"}\n2026-11-06T04:34:51+00:00 NOTICE (5): Cron execution completed: 1 tasks executed, 0 errors. {\"referenceId\":\"easy-admin/cron/job_16\"}\n', '2026-11-06 04:34:50', '2026-11-06 04:34:51'),
(17, 1, '32679', 'completed', 'EasyAdmin\\Job\\CronTasks', '{\"tasks\":{\"session_8\":{\"enabled\":true,\"frequency\":\"hourly\"}},\"manual\":false}', '2026-11-06T05:42:47+00:00 NOTICE (5): Starting cron execution with 1 tasks. {\"referenceId\":\"easy-admin/cron/job_17\"}\n2026-11-06T05:42:47+00:00 INFO (6): Executing task \"session_8\". {\"referenceId\":\"easy-admin/cron/job_17\"}\n2026-11-06T05:42:47+00:00 NOTICE (5): Cron execution completed: 1 tasks executed, 0 errors. {\"referenceId\":\"easy-admin/cron/job_17\"}\n', '2026-11-06 05:42:47', '2026-11-06 05:42:47'),
(18, NULL, '19518', 'completed', 'EasyAdmin\\Job\\CronTasks', '{\"tasks\":{\"session_8\":{\"enabled\":true,\"frequency\":\"hourly\"}},\"manual\":false}', '2026-11-06T09:59:15+00:00 NOTICE (5): Starting cron execution with 1 tasks. {\"referenceId\":\"easy-admin/cron/job_18\"}\n2026-11-06T09:59:15+00:00 INFO (6): Executing task \"session_8\". {\"referenceId\":\"easy-admin/cron/job_18\"}\n2026-11-06T09:59:15+00:00 NOTICE (5): Cron execution completed: 1 tasks executed, 0 errors. {\"referenceId\":\"easy-admin/cron/job_18\"}\n', '2026-11-06 09:59:15', '2026-11-06 09:59:15'),
(19, NULL, '64673', 'completed', 'EasyAdmin\\Job\\CronTasks', '{\"tasks\":{\"session_8\":{\"enabled\":true,\"frequency\":\"hourly\"}},\"manual\":false}', '2026-11-06T10:59:29+00:00 NOTICE (5): Starting cron execution with 1 tasks. {\"referenceId\":\"easy-admin/cron/job_19\"}\n2026-11-06T10:59:29+00:00 INFO (6): Executing task \"session_8\". {\"referenceId\":\"easy-admin/cron/job_19\"}\n2026-11-06T10:59:29+00:00 NOTICE (5): Cron execution completed: 1 tasks executed, 0 errors. {\"referenceId\":\"easy-admin/cron/job_19\"}\n', '2026-11-06 10:59:29', '2026-11-06 10:59:29'),
(20, NULL, '35262', 'completed', 'EasyAdmin\\Job\\CronTasks', '{\"tasks\":{\"session_8\":{\"enabled\":true,\"frequency\":\"hourly\"}},\"manual\":false}', '2026-11-06T14:58:17+00:00 NOTICE (5): Starting cron execution with 1 tasks. {\"referenceId\":\"easy-admin/cron/job_20\"}\n2026-11-06T14:58:17+00:00 INFO (6): Executing task \"session_8\". {\"referenceId\":\"easy-admin/cron/job_20\"}\n2026-11-06T14:58:17+00:00 NOTICE (5): Cron execution completed: 1 tasks executed, 0 errors. {\"referenceId\":\"easy-admin/cron/job_20\"}\n', '2026-11-06 14:58:17', '2026-11-06 14:58:17');

-- --------------------------------------------------------

--
-- Structure de la table `mapper`
--

CREATE TABLE `mapper` (
  `id` int(11) NOT NULL,
  `owner_id` int(11) DEFAULT NULL,
  `label` varchar(190) NOT NULL,
  `mapping` longtext NOT NULL,
  `created` datetime NOT NULL,
  `modified` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `media`
--

CREATE TABLE `media` (
  `id` int(11) NOT NULL,
  `item_id` int(11) NOT NULL,
  `ingester` varchar(190) NOT NULL,
  `renderer` varchar(190) NOT NULL,
  `data` longtext DEFAULT NULL COMMENT '(DC2Type:json_array)',
  `source` longtext DEFAULT NULL,
  `media_type` varchar(190) DEFAULT NULL,
  `storage_id` varchar(190) DEFAULT NULL,
  `extension` varchar(190) DEFAULT NULL,
  `sha256` char(64) DEFAULT NULL,
  `size` bigint(20) DEFAULT NULL,
  `has_original` tinyint(1) NOT NULL,
  `has_thumbnails` tinyint(1) NOT NULL,
  `position` int(11) DEFAULT NULL,
  `lang` varchar(190) DEFAULT NULL,
  `alt_text` longtext DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `media`
--

INSERT INTO `media` (`id`, `item_id`, `ingester`, `renderer`, `data`, `source`, `media_type`, `storage_id`, `extension`, `sha256`, `size`, `has_original`, `has_thumbnails`, `position`, `lang`, `alt_text`) VALUES
(55, 54, 'upload', 'file', NULL, 'IMG_20261104_164004.jpg', 'image/jpeg', '9d02359cb763e52fb53ed12b5f2d66776d8f39b4', 'jpg', 'ce0f2e8d30b4b4a72b71feeb4753b1e3b012cc2c588ac34b41f058ab71a83c99', 3777553, 1, 1, 1, NULL, NULL),
(76, 75, 'upload', 'file', NULL, 'IMG_20261105_084858.jpg', 'image/jpeg', '1989e7506ab2228d3e50983927904cfdabfb2a5d', 'jpg', '3dc668512d4a796c714a0bc18d5948f9981612de3ed44869e857a1cb8b57f45e', 1195669, 1, 1, NULL, NULL, NULL),
(129, 79, 'upload', 'file', NULL, 'IMG_20261105_090001.jpg', 'image/jpeg', '849a430d719a1abd58a4b42c915a4ce8efa7c6a7', 'jpg', '21ff54495b022bcdb5f464491caa5f0c6a7e349b660a33adcf6b184102f56b13', 1770889, 1, 1, 1, NULL, NULL),
(130, 81, 'upload', 'file', NULL, 'IMG_20261105_090649.jpg', 'image/jpeg', '390ce5894aec4301205182001ee35a9d705bb209', 'jpg', '6f217ead75162985a42caf0668732795b805de2b0352d35f5754f8aeba39dcd8', 2910950, 1, 1, 1, NULL, NULL),
(131, 90, 'upload', 'file', NULL, 'IMG_20261105_104418.jpg', 'image/jpeg', '122813aabdee8635785a15dc6a06d244f0df2239', 'jpg', 'dccd1ce2cb1f0addd2f90c9b0357f30d4b079f58c0d928f76adec09b85cbaf4e', 3543772, 1, 1, 1, NULL, NULL),
(285, 42, 'upload', 'file', NULL, 'ecospace-42.json', 'application/json', 'b1114d35ccb4ede60dddcd6255a71e2ea55508eb', 'json', '060577667821c8fe9a6a28d4585344f3c9419a0c50929c75241a269380c95d71', 1412, 1, 0, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Structure de la table `migration`
--

CREATE TABLE `migration` (
  `version` varchar(16) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `migration`
--

INSERT INTO `migration` (`version`) VALUES
('20171128053327'),
('20180412035023'),
('20180919072656'),
('20180924033501'),
('20181002015551'),
('20181004043735'),
('20181106060421'),
('20190307043537'),
('20190319020708'),
('20190412090532'),
('20190423040354'),
('20190423071228'),
('20190514061351'),
('20190515055359'),
('20190729023728'),
('20190809092609'),
('20190815062003'),
('20200224022356'),
('20200226064602'),
('20200325091157'),
('20200326091310'),
('20200803000000'),
('20200831000000'),
('20210205101827'),
('20210225095734'),
('20210810083804'),
('20220718090449'),
('20220824103916'),
('20230124033031'),
('20230410074846'),
('20230523085358'),
('20230601060113'),
('20230713101012'),
('20231016000000'),
('20240103030617'),
('20240219000000'),
('20240614123811');

-- --------------------------------------------------------

--
-- Structure de la table `module`
--

CREATE TABLE `module` (
  `id` varchar(190) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `version` varchar(190) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `module`
--

INSERT INTO `module` (`id`, `is_active`, `version`) VALUES
('AdvancedResourceTemplate', 1, '3.4.56'),
('Annotate', 1, '3.4.13'),
('Common', 1, '3.4.94'),
('CustomVocab', 1, '2.1.0'),
('EasyAdmin', 1, '3.4.50'),
('Mapper', 1, '3.4.8'),
('NumericDataTypes', 1, '1.15.0'),
('ValueSuggest', 1, '1.21.0'),
('Wikidata', 1, '1.6.0');

-- --------------------------------------------------------

--
-- Structure de la table `numeric_data_types_duration`
--

CREATE TABLE `numeric_data_types_duration` (
  `id` int(11) NOT NULL,
  `resource_id` int(11) NOT NULL,
  `property_id` int(11) NOT NULL,
  `value` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `numeric_data_types_integer`
--

CREATE TABLE `numeric_data_types_integer` (
  `id` int(11) NOT NULL,
  `resource_id` int(11) NOT NULL,
  `property_id` int(11) NOT NULL,
  `value` decimal(32,16) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `numeric_data_types_integer`
--

INSERT INTO `numeric_data_types_integer` (`id`, `resource_id`, `property_id`, `value`) VALUES
(1, 54, 317, 100.0000000000000000),
(15, 75, 317, 1.0000000000000000),
(16, 77, 317, 1.0000000000000000),
(17, 78, 317, 1.0000000000000000),
(18, 79, 317, 1.0000000000000000),
(19, 80, 317, 1.0000000000000000),
(20, 81, 317, 1.0000000000000000),
(21, 82, 317, 1.0000000000000000),
(22, 83, 317, 1.0000000000000000),
(23, 84, 317, 1.0000000000000000),
(24, 85, 317, 1.0000000000000000),
(25, 86, 317, 1.0000000000000000),
(26, 87, 317, 1.0000000000000000),
(27, 88, 317, 1.0000000000000000),
(28, 89, 317, 1.0000000000000000),
(29, 90, 317, 1.0000000000000000),
(30, 91, 317, 1.0000000000000000),
(31, 92, 317, 1.0000000000000000),
(32, 93, 317, 1.0000000000000000),
(33, 94, 317, 1.0000000000000000),
(34, 95, 317, 1.0000000000000000),
(35, 96, 317, 1.0000000000000000),
(36, 97, 317, 1.0000000000000000),
(37, 98, 317, 1.0000000000000000),
(38, 99, 317, 1.0000000000000000),
(39, 100, 317, 1.0000000000000000),
(40, 101, 317, 1.0000000000000000),
(41, 102, 317, 1.0000000000000000),
(42, 103, 317, 1.0000000000000000),
(43, 104, 317, 1.0000000000000000),
(44, 105, 317, 1.0000000000000000),
(45, 106, 317, 1.0000000000000000),
(46, 107, 317, 1.0000000000000000),
(47, 108, 317, 1.0000000000000000),
(48, 109, 317, 1.0000000000000000),
(49, 110, 317, 1.0000000000000000),
(50, 111, 317, 1.0000000000000000),
(51, 112, 317, 1.0000000000000000),
(52, 113, 317, 1.0000000000000000),
(53, 114, 317, 1.0000000000000000),
(54, 115, 317, 1.0000000000000000),
(55, 116, 317, 1.0000000000000000),
(56, 117, 317, 1.0000000000000000),
(57, 118, 317, 1.0000000000000000),
(58, 119, 317, 1.0000000000000000),
(59, 120, 317, 1.0000000000000000),
(60, 121, 317, 1.0000000000000000);

-- --------------------------------------------------------

--
-- Structure de la table `numeric_data_types_interval`
--

CREATE TABLE `numeric_data_types_interval` (
  `id` int(11) NOT NULL,
  `resource_id` int(11) NOT NULL,
  `property_id` int(11) NOT NULL,
  `value` bigint(20) NOT NULL,
  `value2` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `numeric_data_types_timestamp`
--

CREATE TABLE `numeric_data_types_timestamp` (
  `id` int(11) NOT NULL,
  `resource_id` int(11) NOT NULL,
  `property_id` int(11) NOT NULL,
  `value` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `numeric_data_types_timestamp`
--

INSERT INTO `numeric_data_types_timestamp` (`id`, `resource_id`, `property_id`, `value`) VALUES
(1, 54, 20, 841536000),
(15, 75, 20, 1793836800),
(16, 77, 20, 1793836800),
(17, 78, 20, 1793836800),
(18, 79, 20, 1793836800),
(19, 80, 20, 1793836800),
(20, 81, 20, 1793836800),
(21, 82, 20, 1793836800),
(22, 83, 20, 1793836800),
(23, 84, 20, 1793836800),
(24, 85, 20, 1793836800),
(25, 86, 20, 1793836800),
(26, 87, 20, 1793836800),
(27, 88, 20, 1793836800),
(28, 89, 20, 1793836800),
(29, 90, 20, 1793836800),
(30, 91, 20, 1793836800),
(31, 92, 20, 1793836800),
(32, 93, 20, 1793836800),
(33, 94, 20, 1793836800),
(34, 95, 20, 1793836800),
(35, 96, 20, 1793836800),
(36, 97, 20, 1793836800),
(37, 98, 20, 1793836800),
(38, 99, 20, 1793836800),
(39, 100, 20, 1793836800),
(40, 101, 20, 1793836800),
(41, 102, 20, 1793836800),
(42, 103, 20, 1793836800),
(43, 104, 20, 1793836800),
(44, 105, 20, 1793836800),
(45, 106, 20, 1793836800),
(46, 107, 20, 1793836800),
(47, 108, 20, 1793836800),
(48, 109, 20, 1793836800),
(49, 110, 20, 1793836800),
(50, 111, 20, 1793836800),
(51, 112, 20, 1793836800),
(52, 113, 20, 1793836800),
(53, 114, 20, 1793836800),
(54, 115, 20, 1793836800),
(55, 116, 20, 1793836800),
(56, 117, 20, 1793836800),
(57, 118, 20, 1793836800),
(58, 119, 20, 1793836800),
(59, 120, 20, 1793836800),
(60, 121, 20, 1793836800);

-- --------------------------------------------------------

--
-- Structure de la table `password_creation`
--

CREATE TABLE `password_creation` (
  `id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `user_id` int(11) NOT NULL,
  `created` datetime NOT NULL,
  `activate` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `property`
--

CREATE TABLE `property` (
  `id` int(11) NOT NULL,
  `owner_id` int(11) DEFAULT NULL,
  `vocabulary_id` int(11) NOT NULL,
  `local_name` varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `label` varchar(255) NOT NULL,
  `comment` longtext DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `property`
--

INSERT INTO `property` (`id`, `owner_id`, `vocabulary_id`, `local_name`, `label`, `comment`) VALUES
(1, NULL, 1, 'title', 'Title', 'A name given to the resource.'),
(2, NULL, 1, 'creator', 'Creator', 'An entity primarily responsible for making the resource.'),
(3, NULL, 1, 'subject', 'Subject', 'The topic of the resource.'),
(4, NULL, 1, 'description', 'Description', 'An account of the resource.'),
(5, NULL, 1, 'publisher', 'Publisher', 'An entity responsible for making the resource available.'),
(6, NULL, 1, 'contributor', 'Contributor', 'An entity responsible for making contributions to the resource.'),
(7, NULL, 1, 'date', 'Date', 'A point or period of time associated with an event in the lifecycle of the resource.'),
(8, NULL, 1, 'type', 'Type', 'The nature or genre of the resource.'),
(9, NULL, 1, 'format', 'Format', 'The file format, physical medium, or dimensions of the resource.'),
(10, NULL, 1, 'identifier', 'Identifier', 'An unambiguous reference to the resource within a given context.'),
(11, NULL, 1, 'source', 'Source', 'A related resource from which the described resource is derived.'),
(12, NULL, 1, 'language', 'Language', 'A language of the resource.'),
(13, NULL, 1, 'relation', 'Relation', 'A related resource.'),
(14, NULL, 1, 'coverage', 'Coverage', 'The spatial or temporal topic of the resource, the spatial applicability of the resource, or the jurisdiction under which the resource is relevant.'),
(15, NULL, 1, 'rights', 'Rights', 'Information about rights held in and over the resource.'),
(16, NULL, 1, 'audience', 'Audience', 'A class of entity for whom the resource is intended or useful.'),
(17, NULL, 1, 'alternative', 'Alternative Title', 'An alternative name for the resource.'),
(18, NULL, 1, 'tableOfContents', 'Table Of Contents', 'A list of subunits of the resource.'),
(19, NULL, 1, 'abstract', 'Abstract', 'A summary of the resource.'),
(20, NULL, 1, 'created', 'Date Created', 'Date of creation of the resource.'),
(21, NULL, 1, 'valid', 'Date Valid', 'Date (often a range) of validity of a resource.'),
(22, NULL, 1, 'available', 'Date Available', 'Date (often a range) that the resource became or will become available.'),
(23, NULL, 1, 'issued', 'Date Issued', 'Date of formal issuance (e.g., publication) of the resource.'),
(24, NULL, 1, 'modified', 'Date Modified', 'Date on which the resource was changed.'),
(25, NULL, 1, 'extent', 'Extent', 'The size or duration of the resource.'),
(26, NULL, 1, 'medium', 'Medium', 'The material or physical carrier of the resource.'),
(27, NULL, 1, 'isVersionOf', 'Is Version Of', 'A related resource of which the described resource is a version, edition, or adaptation.'),
(28, NULL, 1, 'hasVersion', 'Has Version', 'A related resource that is a version, edition, or adaptation of the described resource.'),
(29, NULL, 1, 'isReplacedBy', 'Is Replaced By', 'A related resource that supplants, displaces, or supersedes the described resource.'),
(30, NULL, 1, 'replaces', 'Replaces', 'A related resource that is supplanted, displaced, or superseded by the described resource.'),
(31, NULL, 1, 'isRequiredBy', 'Is Required By', 'A related resource that requires the described resource to support its function, delivery, or coherence.'),
(32, NULL, 1, 'requires', 'Requires', 'A related resource that is required by the described resource to support its function, delivery, or coherence.'),
(33, NULL, 1, 'isPartOf', 'Is Part Of', 'A related resource in which the described resource is physically or logically included.'),
(34, NULL, 1, 'hasPart', 'Has Part', 'A related resource that is included either physically or logically in the described resource.'),
(35, NULL, 1, 'isReferencedBy', 'Is Referenced By', 'A related resource that references, cites, or otherwise points to the described resource.'),
(36, NULL, 1, 'references', 'References', 'A related resource that is referenced, cited, or otherwise pointed to by the described resource.'),
(37, NULL, 1, 'isFormatOf', 'Is Format Of', 'A related resource that is substantially the same as the described resource, but in another format.'),
(38, NULL, 1, 'hasFormat', 'Has Format', 'A related resource that is substantially the same as the pre-existing described resource, but in another format.'),
(39, NULL, 1, 'conformsTo', 'Conforms To', 'An established standard to which the described resource conforms.'),
(40, NULL, 1, 'spatial', 'Spatial Coverage', 'Spatial characteristics of the resource.'),
(41, NULL, 1, 'temporal', 'Temporal Coverage', 'Temporal characteristics of the resource.'),
(42, NULL, 1, 'mediator', 'Mediator', 'An entity that mediates access to the resource and for whom the resource is intended or useful.'),
(43, NULL, 1, 'dateAccepted', 'Date Accepted', 'Date of acceptance of the resource.'),
(44, NULL, 1, 'dateCopyrighted', 'Date Copyrighted', 'Date of copyright.'),
(45, NULL, 1, 'dateSubmitted', 'Date Submitted', 'Date of submission of the resource.'),
(46, NULL, 1, 'educationLevel', 'Audience Education Level', 'A class of entity, defined in terms of progression through an educational or training context, for which the described resource is intended.'),
(47, NULL, 1, 'accessRights', 'Access Rights', 'Information about who can access the resource or an indication of its security status.'),
(48, NULL, 1, 'bibliographicCitation', 'Bibliographic Citation', 'A bibliographic reference for the resource.'),
(49, NULL, 1, 'license', 'License', 'A legal document giving official permission to do something with the resource.'),
(50, NULL, 1, 'rightsHolder', 'Rights Holder', 'A person or organization owning or managing rights over the resource.'),
(51, NULL, 1, 'provenance', 'Provenance', 'A statement of any changes in ownership and custody of the resource since its creation that are significant for its authenticity, integrity, and interpretation.'),
(52, NULL, 1, 'instructionalMethod', 'Instructional Method', 'A process, used to engender knowledge, attitudes and skills, that the described resource is designed to support.'),
(53, NULL, 1, 'accrualMethod', 'Accrual Method', 'The method by which items are added to a collection.'),
(54, NULL, 1, 'accrualPeriodicity', 'Accrual Periodicity', 'The frequency with which items are added to a collection.'),
(55, NULL, 1, 'accrualPolicy', 'Accrual Policy', 'The policy governing the addition of items to a collection.'),
(56, NULL, 3, 'affirmedBy', 'affirmedBy', 'A legal decision that affirms a ruling.'),
(57, NULL, 3, 'annotates', 'annotates', 'Critical or explanatory note for a Document.'),
(58, NULL, 3, 'authorList', 'list of authors', 'An ordered list of authors. Normally, this list is seen as a priority list that order authors by importance.'),
(59, NULL, 3, 'citedBy', 'cited by', 'Relates a document to another document that cites the\nfirst document.'),
(60, NULL, 3, 'cites', 'cites', 'Relates a document to another document that is cited\nby the first document as reference, comment, review, quotation or for\nanother purpose.'),
(61, NULL, 3, 'contributorList', 'list of contributors', 'An ordered list of contributors. Normally, this list is seen as a priority list that order contributors by importance.'),
(62, NULL, 3, 'court', 'court', 'A court associated with a legal document; for example, that which issues a decision.'),
(63, NULL, 3, 'degree', 'degree', 'The thesis degree.'),
(64, NULL, 3, 'director', 'director', 'A Film director.'),
(65, NULL, 3, 'distributor', 'distributor', 'Distributor of a document or a collection of documents.'),
(66, NULL, 3, 'editor', 'editor', 'A person having managerial and sometimes policy-making responsibility for the editorial part of a publishing firm or of a newspaper, magazine, or other publication.'),
(67, NULL, 3, 'editorList', 'list of editors', 'An ordered list of editors. Normally, this list is seen as a priority list that order editors by importance.'),
(68, NULL, 3, 'interviewee', 'interviewee', 'An agent that is interviewed by another agent.'),
(69, NULL, 3, 'interviewer', 'interviewer', 'An agent that interview another agent.'),
(70, NULL, 3, 'issuer', 'issuer', 'An entity responsible for issuing often informally published documents such as press releases, reports, etc.'),
(71, NULL, 3, 'organizer', 'organizer', 'The organizer of an event; includes conference organizers, but also government agencies or other bodies that are responsible for conducting hearings.'),
(72, NULL, 3, 'owner', 'owner', 'Owner of a document or a collection of documents.'),
(73, NULL, 3, 'performer', 'performer', NULL),
(74, NULL, 3, 'presentedAt', 'presented at', 'Relates a document to an event; for example, a paper to a conference.'),
(75, NULL, 3, 'presents', 'presents', 'Relates an event to associated documents; for example, conference to a paper.'),
(76, NULL, 3, 'producer', 'producer', 'Producer of a document or a collection of documents.'),
(77, NULL, 3, 'recipient', 'recipient', 'An agent that receives a communication document.'),
(78, NULL, 3, 'reproducedIn', 'reproducedIn', 'The resource in which another resource is reproduced.'),
(79, NULL, 3, 'reversedBy', 'reversedBy', 'A legal decision that reverses a ruling.'),
(80, NULL, 3, 'reviewOf', 'review of', 'Relates a review document to a reviewed thing (resource, item, etc.).'),
(81, NULL, 3, 'status', 'status', 'The publication status of (typically academic) content.'),
(82, NULL, 3, 'subsequentLegalDecision', 'subsequentLegalDecision', 'A legal decision on appeal that takes action on a case (affirming it, reversing it, etc.).'),
(83, NULL, 3, 'transcriptOf', 'transcript of', 'Relates a document to some transcribed original.'),
(84, NULL, 3, 'translationOf', 'translation of', 'Relates a translated document to the original document.'),
(85, NULL, 3, 'translator', 'translator', 'A person who translates written document from one language to another.'),
(86, NULL, 3, 'abstract', 'abstract', 'A summary of the resource.'),
(87, NULL, 3, 'argued', 'date argued', 'The date on which a legal case is argued before a court. Date is of format xsd:date'),
(88, NULL, 3, 'asin', 'asin', NULL),
(89, NULL, 3, 'chapter', 'chapter', 'An chapter number'),
(90, NULL, 3, 'coden', 'coden', NULL),
(91, NULL, 3, 'content', 'content', 'This property is for a plain-text rendering of the content of a Document. While the plain-text content of an entire document could be described by this property.'),
(92, NULL, 3, 'doi', 'doi', NULL),
(93, NULL, 3, 'eanucc13', 'eanucc13', NULL),
(94, NULL, 3, 'edition', 'edition', 'The name defining a special edition of a document. Normally its a literal value composed of a version number and words.'),
(95, NULL, 3, 'eissn', 'eissn', NULL),
(96, NULL, 3, 'gtin14', 'gtin14', NULL),
(97, NULL, 3, 'handle', 'handle', NULL),
(98, NULL, 3, 'identifier', 'identifier', NULL),
(99, NULL, 3, 'isbn', 'isbn', NULL),
(100, NULL, 3, 'isbn10', 'isbn10', NULL),
(101, NULL, 3, 'isbn13', 'isbn13', NULL),
(102, NULL, 3, 'issn', 'issn', NULL),
(103, NULL, 3, 'issue', 'issue', 'An issue number'),
(104, NULL, 3, 'lccn', 'lccn', NULL),
(105, NULL, 3, 'locator', 'locator', 'A description (often numeric) that locates an item within a containing document or collection.'),
(106, NULL, 3, 'numPages', 'number of pages', 'The number of pages contained in a document'),
(107, NULL, 3, 'numVolumes', 'number of volumes', 'The number of volumes contained in a collection of documents (usually a series, periodical, etc.).'),
(108, NULL, 3, 'number', 'number', 'A generic item or document number. Not to be confused with issue number.'),
(109, NULL, 3, 'oclcnum', 'oclcnum', NULL),
(110, NULL, 3, 'pageEnd', 'page end', 'Ending page number within a continuous page range.'),
(111, NULL, 3, 'pageStart', 'page start', 'Starting page number within a continuous page range.'),
(112, NULL, 3, 'pages', 'pages', 'A string of non-contiguous page spans that locate a Document within a Collection. Example: 23-25, 34, 54-56. For continuous page ranges, use the pageStart and pageEnd properties.'),
(113, NULL, 3, 'pmid', 'pmid', NULL),
(114, NULL, 3, 'prefixName', 'prefix name', 'The prefix of a name'),
(115, NULL, 3, 'section', 'section', 'A section number'),
(116, NULL, 3, 'shortDescription', 'shortDescription', NULL),
(117, NULL, 3, 'shortTitle', 'short title', 'The abbreviation of a title.'),
(118, NULL, 3, 'sici', 'sici', NULL),
(119, NULL, 3, 'suffixName', 'suffix name', 'The suffix of a name'),
(120, NULL, 3, 'upc', 'upc', NULL),
(121, NULL, 3, 'uri', 'uri', 'Universal Resource Identifier of a document'),
(122, NULL, 3, 'volume', 'volume', 'A volume number'),
(123, NULL, 4, 'mbox', 'personal mailbox', 'A  personal mailbox, ie. an Internet mailbox associated with exactly one owner, the first owner of this mailbox. This is a \'static inverse functional property\', in that  there is (across time and change) at most one individual that ever has any particular value for foaf:mbox.'),
(124, NULL, 4, 'mbox_sha1sum', 'sha1sum of a personal mailbox URI name', 'The sha1sum of the URI of an Internet mailbox associated with exactly one owner, the  first owner of the mailbox.'),
(125, NULL, 4, 'gender', 'gender', 'The gender of this Agent (typically but not necessarily \'male\' or \'female\').'),
(126, NULL, 4, 'geekcode', 'geekcode', 'A textual geekcode for this person, see http://www.geekcode.com/geek.html'),
(127, NULL, 4, 'dnaChecksum', 'DNA checksum', 'A checksum for the DNA of some thing. Joke.'),
(128, NULL, 4, 'sha1', 'sha1sum (hex)', 'A sha1sum hash, in hex.'),
(129, NULL, 4, 'based_near', 'based near', 'A location that something is based near, for some broadly human notion of near.'),
(130, NULL, 4, 'title', 'title', 'Title (Mr, Mrs, Ms, Dr. etc)'),
(131, NULL, 4, 'nick', 'nickname', 'A short informal nickname characterising an agent (includes login identifiers, IRC and other chat nicknames).'),
(132, NULL, 4, 'jabberID', 'jabber ID', 'A jabber ID for something.'),
(133, NULL, 4, 'aimChatID', 'AIM chat ID', 'An AIM chat ID'),
(134, NULL, 4, 'skypeID', 'Skype ID', 'A Skype ID'),
(135, NULL, 4, 'icqChatID', 'ICQ chat ID', 'An ICQ chat ID'),
(136, NULL, 4, 'yahooChatID', 'Yahoo chat ID', 'A Yahoo chat ID'),
(137, NULL, 4, 'msnChatID', 'MSN chat ID', 'An MSN chat ID'),
(138, NULL, 4, 'name', 'name', 'A name for some thing.'),
(139, NULL, 4, 'firstName', 'firstName', 'The first name of a person.'),
(140, NULL, 4, 'lastName', 'lastName', 'The last name of a person.'),
(141, NULL, 4, 'givenName', 'Given name', 'The given name of some person.'),
(142, NULL, 4, 'givenname', 'Given name', 'The given name of some person.'),
(143, NULL, 4, 'surname', 'Surname', 'The surname of some person.'),
(144, NULL, 4, 'family_name', 'family_name', 'The family name of some person.'),
(145, NULL, 4, 'familyName', 'familyName', 'The family name of some person.'),
(146, NULL, 4, 'phone', 'phone', 'A phone,  specified using fully qualified tel: URI scheme (refs: http://www.w3.org/Addressing/schemes.html#tel).'),
(147, NULL, 4, 'homepage', 'homepage', 'A homepage for some thing.'),
(148, NULL, 4, 'weblog', 'weblog', 'A weblog of some thing (whether person, group, company etc.).'),
(149, NULL, 4, 'openid', 'openid', 'An OpenID for an Agent.'),
(150, NULL, 4, 'tipjar', 'tipjar', 'A tipjar document for this agent, describing means for payment and reward.'),
(151, NULL, 4, 'plan', 'plan', 'A .plan comment, in the tradition of finger and \'.plan\' files.'),
(152, NULL, 4, 'made', 'made', 'Something that was made by this agent.'),
(153, NULL, 4, 'maker', 'maker', 'An agent that  made this thing.'),
(154, NULL, 4, 'img', 'image', 'An image that can be used to represent some thing (ie. those depictions which are particularly representative of something, eg. one\'s photo on a homepage).'),
(155, NULL, 4, 'depiction', 'depiction', 'A depiction of some thing.'),
(156, NULL, 4, 'depicts', 'depicts', 'A thing depicted in this representation.'),
(157, NULL, 4, 'thumbnail', 'thumbnail', 'A derived thumbnail image.'),
(158, NULL, 4, 'myersBriggs', 'myersBriggs', 'A Myers Briggs (MBTI) personality classification.'),
(159, NULL, 4, 'workplaceHomepage', 'workplace homepage', 'A workplace homepage of some person; the homepage of an organization they work for.'),
(160, NULL, 4, 'workInfoHomepage', 'work info homepage', 'A work info homepage of some person; a page about their work for some organization.'),
(161, NULL, 4, 'schoolHomepage', 'schoolHomepage', 'A homepage of a school attended by the person.'),
(162, NULL, 4, 'knows', 'knows', 'A person known by this person (indicating some level of reciprocated interaction between the parties).'),
(163, NULL, 4, 'interest', 'interest', 'A page about a topic of interest to this person.'),
(164, NULL, 4, 'topic_interest', 'topic_interest', 'A thing of interest to this person.'),
(165, NULL, 4, 'publications', 'publications', 'A link to the publications of this person.'),
(166, NULL, 4, 'currentProject', 'current project', 'A current project this person works on.'),
(167, NULL, 4, 'pastProject', 'past project', 'A project this person has previously worked on.'),
(168, NULL, 4, 'fundedBy', 'funded by', 'An organization funding a project or person.'),
(169, NULL, 4, 'logo', 'logo', 'A logo representing some thing.'),
(170, NULL, 4, 'topic', 'topic', 'A topic of some page or document.'),
(171, NULL, 4, 'primaryTopic', 'primary topic', 'The primary topic of some page or document.'),
(172, NULL, 4, 'focus', 'focus', 'The underlying or \'focal\' entity associated with some SKOS-described concept.'),
(173, NULL, 4, 'isPrimaryTopicOf', 'is primary topic of', 'A document that this thing is the primary topic of.'),
(174, NULL, 4, 'page', 'page', 'A page or document about this thing.'),
(175, NULL, 4, 'theme', 'theme', 'A theme.'),
(176, NULL, 4, 'account', 'account', 'Indicates an account held by this agent.'),
(177, NULL, 4, 'holdsAccount', 'account', 'Indicates an account held by this agent.'),
(178, NULL, 4, 'accountServiceHomepage', 'account service homepage', 'Indicates a homepage of the service provide for this online account.'),
(179, NULL, 4, 'accountName', 'account name', 'Indicates the name (identifier) associated with this online account.'),
(180, NULL, 4, 'member', 'member', 'Indicates a member of a Group'),
(181, NULL, 4, 'membershipClass', 'membershipClass', 'Indicates the class of individuals that are a member of a Group'),
(182, NULL, 4, 'birthday', 'birthday', 'The birthday of this Agent, represented in mm-dd string form, eg. \'12-31\'.'),
(183, NULL, 4, 'age', 'age', 'The age in years of some agent.'),
(184, NULL, 4, 'status', 'status', 'A string expressing what the user is happy for the general public (normally) to know about their current activity.'),
(185, 1, 5, 'prefLabel', 'preferred label', NULL),
(186, 1, 5, 'inScheme', 'is in scheme', NULL),
(187, 1, 5, 'hasTopConcept', 'has top concept', NULL),
(188, 1, 5, 'topConceptOf', 'is top concept in scheme', NULL),
(189, 1, 5, 'altLabel', 'alternative label', 'The range of skos:altLabel is the class of RDF plain literals.'),
(190, 1, 5, 'hiddenLabel', 'hidden label', 'The range of skos:hiddenLabel is the class of RDF plain literals.'),
(191, 1, 5, 'notation', 'notation', NULL),
(192, 1, 5, 'note', 'note', NULL),
(193, 1, 5, 'changeNote', 'change note', NULL),
(194, 1, 5, 'definition', 'definition', NULL),
(195, 1, 5, 'editorialNote', 'editorial note', NULL),
(196, 1, 5, 'example', 'example', NULL),
(197, 1, 5, 'historyNote', 'history note', NULL),
(198, 1, 5, 'scopeNote', 'scope note', NULL),
(199, 1, 5, 'semanticRelation', 'is in semantic relation with', NULL),
(200, 1, 5, 'broader', 'has broader', 'Broader concepts are typically rendered as parents in a concept hierarchy (tree).'),
(201, 1, 5, 'narrower', 'has narrower', 'Narrower concepts are typically rendered as children in a concept hierarchy (tree).'),
(202, 1, 5, 'related', 'has related', 'skos:related is disjoint with skos:broaderTransitive'),
(203, 1, 5, 'broaderTransitive', 'has broader transitive', NULL),
(204, 1, 5, 'narrowerTransitive', 'has narrower transitive', NULL),
(205, 1, 5, 'member', 'has member', NULL),
(206, 1, 5, 'memberList', 'has member list', 'For any resource, every item in the list given as the value of the\n      skos:memberList property is also a value of the skos:member property.'),
(207, 1, 5, 'mappingRelation', 'is in mapping relation with', 'These concept mapping relations mirror semantic relations, and the data model defined below is similar (with the exception of skos:exactMatch) to the data model defined for semantic relations. A distinct vocabulary is provided for concept mapping relations, to provide a convenient way to differentiate links within a concept scheme from links between concept schemes. However, this pattern of usage is not a formal requirement of the SKOS data model, and relies on informal definitions of best practice.'),
(208, 1, 5, 'broadMatch', 'has broader match', NULL),
(209, 1, 5, 'narrowMatch', 'has narrower match', NULL),
(210, 1, 5, 'relatedMatch', 'has related match', NULL),
(211, 1, 5, 'exactMatch', 'has exact match', 'skos:exactMatch is disjoint with each of the properties skos:broadMatch and skos:relatedMatch.'),
(212, 1, 5, 'closeMatch', 'has close match', NULL),
(213, 1, 6, 'x', 'x', NULL),
(214, 1, 6, 'y', 'y', NULL),
(215, 1, 6, 'xRatingValue', 'xRatingValue', NULL),
(216, 1, 6, 'yRatingValue', 'yRatingValue', NULL),
(217, 1, 6, 'degradName', 'degradName', NULL),
(218, 1, 6, 'degradColors', 'degradColors', NULL),
(219, 1, 6, 'creationDate', 'creationDate', NULL),
(220, 1, 6, 'hasExistence', 'a comme existence', NULL),
(221, 1, 6, 'hasActant', 'a comme actant', NULL),
(222, 1, 6, 'hasPhysique', 'a comme physique', NULL),
(223, 1, 6, 'hasConcept', 'a comme concept', NULL),
(224, 1, 6, 'hasRapport', 'a comme rapport', NULL),
(225, 1, 6, 'hasCrible', 'a comme crible', NULL),
(226, 1, 6, 'cribleLabel', 'cribleLabel', NULL),
(227, 1, 6, 'cribleId', 'cribleId', NULL),
(228, 1, 6, 'cribleRatingValue', 'cribleRatingValue', NULL),
(229, 1, 6, 'distanceCenter', 'distance du centre', NULL),
(230, 1, 6, 'distanceConcept', 'distance du concept', NULL),
(231, 1, 6, 'ordreCrible', 'Ordre dans le crible', NULL),
(232, 1, 6, 'hasCribleCarto', 'a comme cartographie', NULL),
(233, 1, 6, 'hasSujet', 'a comme sujet', NULL),
(234, 1, 6, 'hasObjet', 'a comme objet', NULL),
(235, 1, 6, 'hasPredicat', 'a comme prédicat', NULL),
(236, 1, 6, 'hasMenu', 'a comme menu', NULL),
(237, 1, 6, 'hasArchetype', 'a comme archetype', NULL),
(238, 1, 6, 'iaModel', 'IA modèle', NULL),
(239, 1, 6, 'pipeline', 'pipeline', NULL),
(240, 1, 6, 'hasPerson', 'a comme personne', NULL),
(241, 1, 6, 'hasGeo', 'a comme lieu', NULL),
(242, 1, 6, 'hasEpoque', 'a comme époque', NULL),
(243, 1, 6, 'hasBook', 'a comme livre', NULL),
(244, 1, 6, 'hasMovie', 'a comme film', NULL),
(245, 1, 6, 'hasMusic', 'a comme musique', NULL),
(246, 1, 6, 'hasLink', 'a comme lien', NULL),
(247, 1, 6, 'ragRef', 'Référence dans le RAG', NULL),
(248, 1, 6, 'surTout', 'Applique la transformation sur tout', NULL),
(249, 1, 6, 'remplacer', 'Le texte à remplacer', NULL),
(250, 1, 6, 'par', 'Le texte de remplacement', NULL),
(251, NULL, 6, 'hasAgent', 'a comme agent', NULL),
(252, NULL, 6, 'intensite', 'Intensité', NULL),
(253, NULL, 6, 'hasRole', 'a comme rôle', NULL),
(254, NULL, 6, 'hasPulsationExistentielle', 'a comme pulsation existentielle', NULL),
(255, NULL, 6, 'ordreRelatif', 'Ordre relatif', NULL),
(256, NULL, 6, 'ordreSuccessif', 'Ordre successif', NULL),
(257, NULL, 6, 'hasPouvoir', 'a comme pouvoir', NULL),
(258, NULL, 6, 'flux', 'a comme flux', NULL),
(259, 1, 7, 'annotationService', 'annotation service', 'The object of the relationship is the end point of a service that conforms to the annotation-protocol, and it may be associated with any resource.  The expectation of asserting the relationship is that the object is the preferred service for maintaining annotations about the subject resource, according to the publisher of the relationship.\n\n  This relationship is intended to be used both within Linked Data descriptions and as the  rel  type of a Link, via HTTP Link Headers rfc5988 for binary resources and in HTML <link> elements.  For more information about these, please see the Annotation Protocol specification annotation-protocol.\n  '),
(260, 1, 7, 'bodyValue', 'body value', 'The object of the predicate is a plain text string to be used as the content of the body of the Annotation.  The value MUST be an  xsd:string  and that data type MUST NOT be expressed in the serialization. Note that language MUST NOT be associated with the value either as a language tag, as that is only available for  rdf:langString .\n  '),
(261, 1, 7, 'cachedSource', 'cached source', 'A object of the relationship is a copy of the Source resource\'s representation, appropriate for the Annotation.'),
(262, 1, 7, 'canonical', 'canonical', 'A object of the relationship is the canonical IRI that can always be used to deduplicate the Annotation, regardless of the current IRI used to access the representation.'),
(263, 1, 7, 'end', 'end', 'The end property is used to convey the 0-based index of the end position of a range of content.'),
(264, 1, 7, 'exact', 'exact', 'The object of the predicate is a copy of the text which is being selected, after normalization.'),
(265, 1, 7, 'hasBody', 'has body', 'The object of the relationship is a resource that is a body of the Annotation.'),
(266, 1, 7, 'hasEndSelector', 'has end selector', 'The relationship between a RangeSelector and the Selector that describes the end position of the range. '),
(267, 1, 7, 'hasPurpose', 'has purpose', 'The purpose served by the resource in the Annotation.'),
(268, 1, 7, 'hasScope', 'has scope', 'The scope or context in which the resource is used within the Annotation.'),
(269, 1, 7, 'hasSelector', 'has selector', 'The object of the relationship is a Selector that describes the segment or region of interest within the source resource.  Please note that the domain ( oa:ResourceSelection ) is not used directly in the Web Annotation model.'),
(270, 1, 7, 'hasSource', 'has source', 'The resource that the ResourceSelection, or its subclass SpecificResource, is refined from, or more specific than. Please note that the domain ( oa:ResourceSelection ) is not used directly in the Web Annotation model.'),
(271, 1, 7, 'hasStartSelector', 'has start selector', 'The relationship between a RangeSelector and the Selector that describes the start position of the range. '),
(272, 1, 7, 'hasState', 'has state', 'The relationship between the ResourceSelection, or its subclass SpecificResource, and a State resource. Please note that the domain ( oa:ResourceSelection ) is not used directly in the Web Annotation model.'),
(273, 1, 7, 'hasTarget', 'has target', 'The relationship between an Annotation and its Target.'),
(274, 1, 7, 'motivatedBy', 'motivated by', 'The relationship between an Annotation and a Motivation that describes the reason for the Annotation\'s creation.'),
(275, 1, 7, 'prefix', 'prefix', 'The object of the property is a snippet of content that occurs immediately before the content which is being selected by the Selector.'),
(276, 1, 7, 'processingLanguage', 'processing language', 'The object of the property is the language that should be used for textual processing algorithms when dealing with the content of the resource, including hyphenation, line breaking, which font to use for rendering and so forth.  The value must follow the recommendations of BCP47.'),
(277, 1, 7, 'refinedBy', 'refined by', 'The relationship between a Selector and another Selector or a State and a Selector or State that should be applied to the results of the first to refine the processing of the source resource. '),
(278, 1, 7, 'renderedVia', 'rendered via', 'A system that was used by the application that created the Annotation to render the resource.'),
(279, 1, 7, 'sourceDate', 'source date', 'The timestamp at which the Source resource should be interpreted as being applicable to the Annotation.'),
(280, 1, 7, 'sourceDateEnd', 'source date end', 'The end timestamp of the interval over which the Source resource should be interpreted as being applicable to the Annotation.'),
(281, 1, 7, 'sourceDateStart', 'source date start', 'The start timestamp of the interval over which the Source resource should be interpreted as being applicable to the Annotation.'),
(282, 1, 7, 'start', 'start', 'The start position in a 0-based index at which a range of content is selected from the data in the source resource.'),
(283, 1, 7, 'styleClass', 'style class', 'The name of the class used in the CSS description referenced from the Annotation that should be applied to the Specific Resource.'),
(284, 1, 7, 'styledBy', 'styled by', 'A reference to a Stylesheet that should be used to apply styles to the Annotation rendering.'),
(285, 1, 7, 'suffix', 'suffix', 'The snippet of text that occurs immediately after the text which is being selected.'),
(286, 1, 7, 'textDirection', 'text direction', 'The direction of the text of the subject resource. There MUST only be one text direction associated with any given resource.'),
(287, 1, 7, 'via', 'via', 'A object of the relationship is a resource from which the source resource was retrieved by the providing system.'),
(288, 1, 8, 'type', 'type', 'The subject is an instance of a class.'),
(289, 1, 8, 'subject', 'subject', 'The subject of the subject RDF statement.'),
(290, 1, 8, 'predicate', 'predicate', 'The predicate of the subject RDF statement.'),
(291, 1, 8, 'object', 'object', 'The object of the subject RDF statement.'),
(292, 1, 8, 'value', 'value', 'Idiomatic property used for structured values.'),
(293, 1, 8, 'first', 'first', 'The first item in the subject RDF list.'),
(294, 1, 8, 'rest', 'rest', 'The rest of the subject RDF list after the first item.'),
(295, 1, 9, 'access', 'Access', 'Define an access to the resource.'),
(296, 1, 9, 'featured', 'Featured', 'Mark the resource as a featured one as soon as a value is set, whatever it is.'),
(297, 1, 9, 'new', 'New', 'Mark the resource as a new one as soon as a value is set, whatever it is.'),
(298, 1, 9, 'reserved', 'Reserved', 'Define the resource as a restricted access one as soon a value is set, whatever it is.'),
(299, 1, 9, 'selected', 'Selected', 'Mark the resource as a selected one as soon as a value is set, whatever it is.'),
(300, 1, 9, 'category', 'Category', 'A topic that can be used for some purposes.'),
(301, 1, 9, 'collection', 'Collection', 'A way to group resources.'),
(302, 1, 9, 'set', 'Set', 'A set to group resources together.'),
(303, 1, 9, 'subject', 'Subject', 'A subject to describe the resource.'),
(304, 1, 9, 'tag', 'Tag', 'Tag that can be used for some purposes or for upgrade from Omeka Classic.'),
(305, 1, 9, 'theme', 'Theme', 'A domain that can be used for some purposes.'),
(306, 1, 9, 'type', 'Type', 'A type that can be used for some purposes.'),
(307, 1, 9, 'coordinates', 'Coordinates', 'Numerical coordinates related to the resource, generaly the geographic position.'),
(308, 1, 9, 'data', 'Data', 'Any data that can be used for any purpose.'),
(309, 1, 9, 'dateStart', 'Date of start', 'Start date related to the resource, for example an embargo.'),
(310, 1, 9, 'dateEnd', 'Date of end', 'End date related to the resource, for example an embargo.'),
(311, 1, 9, 'location', 'Location', 'A location related to the resource, for example the place of publication.'),
(312, 1, 9, 'note', 'Note', 'A specific or generic information on a resource, generally for internal purposes.'),
(313, 1, 9, 'number', 'Number', 'A number related to the resource.'),
(314, 1, 9, 'rank', 'Rank', 'A rank or a position related to the resource.'),
(315, 1, 9, 'status', 'Status', 'The status of the resource, generally for internal purposes.'),
(316, NULL, 6, 'hasEcoCon', 'a comme écosytème de connaissances', NULL),
(317, NULL, 6, 'importance', 'importance', NULL),
(319, NULL, 6, 'paramCrible', 'paramètre du crible', NULL),
(320, NULL, 6, 'fonctionCrible', 'fonction du crible', NULL);

-- --------------------------------------------------------

--
-- Structure de la table `resource`
--

CREATE TABLE `resource` (
  `id` int(11) NOT NULL,
  `owner_id` int(11) DEFAULT NULL,
  `resource_class_id` int(11) DEFAULT NULL,
  `resource_template_id` int(11) DEFAULT NULL,
  `thumbnail_id` int(11) DEFAULT NULL,
  `title` longtext DEFAULT NULL,
  `is_public` tinyint(1) NOT NULL,
  `created` datetime NOT NULL,
  `modified` datetime DEFAULT NULL,
  `resource_type` varchar(190) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `resource`
--

INSERT INTO `resource` (`id`, `owner_id`, `resource_class_id`, `resource_template_id`, `thumbnail_id`, `title`, `is_public`, `created`, `modified`, `resource_type`) VALUES
(1, 1, 106, 2, NULL, 'philosophie', 1, '2026-10-31 07:45:15', '2026-10-31 08:24:17', 'Omeka\\Entity\\Item'),
(2, 1, 106, NULL, NULL, 'Concepts', 1, '2026-10-31 08:23:32', '2026-10-31 08:24:27', 'Omeka\\Entity\\ItemSet'),
(3, 1, NULL, NULL, NULL, 'Actants', 1, '2026-10-31 08:27:56', '2026-10-31 08:27:56', 'Omeka\\Entity\\ItemSet'),
(4, 1, NULL, NULL, NULL, 'Physiques', 1, '2026-10-31 08:28:08', '2026-10-31 08:28:08', 'Omeka\\Entity\\ItemSet'),
(5, 1, NULL, NULL, NULL, 'Cribles', 1, '2026-10-31 08:28:19', '2026-10-31 08:28:19', 'Omeka\\Entity\\ItemSet'),
(6, 1, NULL, NULL, NULL, 'Personnes', 1, '2026-10-31 08:28:30', '2026-10-31 08:28:30', 'Omeka\\Entity\\ItemSet'),
(7, 1, NULL, NULL, NULL, 'Agents', 1, '2026-10-31 08:28:57', '2026-10-31 08:28:57', 'Omeka\\Entity\\ItemSet'),
(8, 1, NULL, NULL, NULL, 'Rôles', 1, '2026-10-31 08:35:21', '2026-10-31 08:35:21', 'Omeka\\Entity\\ItemSet'),
(9, 1, NULL, NULL, NULL, 'Pouvoirs existentiels', 1, '2026-10-31 08:42:40', '2026-10-31 08:42:40', 'Omeka\\Entity\\ItemSet'),
(10, 1, NULL, NULL, NULL, 'Pulsations existentielles', 1, '2026-10-31 09:02:46', '2026-10-31 09:02:46', 'Omeka\\Entity\\ItemSet'),
(11, 1, NULL, NULL, NULL, 'Raisons trajectives', 1, '2026-10-31 09:03:01', '2026-10-31 09:03:01', 'Omeka\\Entity\\ItemSet'),
(12, 1, 109, NULL, NULL, 'Temporalités relatives', 1, '2026-11-01 04:33:03', '2026-11-01 04:33:03', 'Omeka\\Entity\\ItemSet'),
(13, 1, 106, 2, NULL, 'Avant', 1, '2026-11-01 04:34:39', '2026-11-06 06:09:43', 'Omeka\\Entity\\Item'),
(14, 1, 106, 2, NULL, 'Pendant', 1, '2026-11-01 04:36:03', '2026-11-06 06:09:58', 'Omeka\\Entity\\Item'),
(16, 1, 106, 2, NULL, 'Après', 1, '2026-11-01 04:40:15', '2026-11-06 06:26:12', 'Omeka\\Entity\\Item'),
(26, 1, 109, 11, NULL, NULL, 1, '2026-11-01 04:58:26', '2026-11-01 04:58:26', 'Omeka\\Entity\\ValueAnnotation'),
(28, 1, 109, 11, NULL, NULL, 1, '2026-11-01 04:58:27', '2026-11-01 04:58:27', 'Omeka\\Entity\\ValueAnnotation'),
(29, 1, NULL, NULL, NULL, 'Ecosytèmes de connaissances', 1, '2026-11-04 09:40:36', '2026-11-04 09:40:36', 'Omeka\\Entity\\ItemSet'),
(42, 1, 152, 14, NULL, 'Collaborations entre Jean-Pierre Balpe et Samuel Szoniecky', 1, '2026-11-04 11:29:12', '2026-11-04 15:47:42', 'Omeka\\Entity\\Item'),
(43, 1, 94, 8, NULL, 'Samuel Szoniecky', 1, '2026-11-04 11:29:49', '2026-11-04 11:46:49', 'Omeka\\Entity\\Item'),
(44, 1, 94, 8, NULL, 'Jean-Pierre Balpe', 1, '2026-11-04 11:30:15', '2026-11-04 11:30:15', 'Omeka\\Entity\\Item'),
(46, 1, 1, 6, NULL, 'HyperCard', 1, '2026-11-04 11:36:46', '2026-11-04 15:00:00', 'Omeka\\Entity\\Item'),
(48, 1, 111, 5, NULL, 'PhilosHard', 1, '2026-11-04 14:59:59', '2026-11-04 14:59:59', 'Omeka\\Entity\\Item'),
(54, 1, 116, 3, NULL, 'Plastique d\'Espace Numérique', 1, '2026-11-04 15:44:05', '2026-11-05 06:44:56', 'Omeka\\Entity\\Item'),
(55, 1, NULL, NULL, NULL, 'IMG_20261104_164004.jpg', 1, '2026-11-04 15:44:06', '2026-11-04 15:44:06', 'Omeka\\Entity\\Media'),
(58, 1, 114, 4, NULL, 'Samuel Szoniecky', 1, '2026-11-05 06:17:23', '2026-11-06 06:28:31', 'Omeka\\Entity\\Item'),
(69, 1, 111, 5, NULL, 'Décompose en parties', 1, '2026-11-05 08:34:36', '2026-11-05 08:58:51', 'Omeka\\Entity\\Item'),
(75, 1, 116, 3, NULL, 'Plastique d\'Espace Numérique - page 1', 1, '2026-11-05 09:26:38', '2026-11-05 09:26:38', 'Omeka\\Entity\\Item'),
(76, 1, NULL, NULL, NULL, 'IMG_20261105_084858.jpg', 1, '2026-11-05 09:26:38', '2026-11-05 09:26:38', 'Omeka\\Entity\\Media'),
(77, 1, 116, 3, NULL, 'Plastique d\'Espace Numérique - page 2', 1, '2026-11-05 09:28:49', '2026-11-05 09:28:49', 'Omeka\\Entity\\Item'),
(78, 1, 116, 3, NULL, 'Plastique d\'Espace Numérique - page 3', 1, '2026-11-05 09:28:49', '2026-11-05 09:28:49', 'Omeka\\Entity\\Item'),
(79, 1, 116, 3, NULL, 'Plastique d\'Espace Numérique - page 4', 1, '2026-11-05 09:28:50', '2026-11-05 09:48:54', 'Omeka\\Entity\\Item'),
(80, 1, 116, 3, NULL, 'Plastique d\'Espace Numérique - page 5', 1, '2026-11-05 09:28:51', '2026-11-05 09:28:51', 'Omeka\\Entity\\Item'),
(81, 1, 116, 3, NULL, 'Plastique d\'Espace Numérique - page 6', 1, '2026-11-05 09:28:52', '2026-11-05 09:49:32', 'Omeka\\Entity\\Item'),
(82, 1, 116, 3, NULL, 'Plastique d\'Espace Numérique - page 7', 1, '2026-11-05 09:28:53', '2026-11-05 09:28:53', 'Omeka\\Entity\\Item'),
(83, 1, 116, 3, NULL, 'Plastique d\'Espace Numérique - page 8', 1, '2026-11-05 09:28:54', '2026-11-05 09:28:54', 'Omeka\\Entity\\Item'),
(84, 1, 116, 3, NULL, 'Plastique d\'Espace Numérique - page 9', 1, '2026-11-05 09:28:55', '2026-11-05 09:28:55', 'Omeka\\Entity\\Item'),
(85, 1, 116, 3, NULL, 'Plastique d\'Espace Numérique - page 10', 1, '2026-11-05 09:28:57', '2026-11-05 09:28:57', 'Omeka\\Entity\\Item'),
(86, 1, 116, 3, NULL, 'Plastique d\'Espace Numérique - page 11', 1, '2026-11-05 09:28:58', '2026-11-05 09:28:58', 'Omeka\\Entity\\Item'),
(87, 1, 116, 3, NULL, 'Plastique d\'Espace Numérique - page 12', 1, '2026-11-05 09:29:00', '2026-11-05 09:29:00', 'Omeka\\Entity\\Item'),
(88, 1, 116, 3, NULL, 'Plastique d\'Espace Numérique - page 13', 1, '2026-11-05 09:29:01', '2026-11-05 09:29:01', 'Omeka\\Entity\\Item'),
(89, 1, 116, 3, NULL, 'Plastique d\'Espace Numérique - page 14', 1, '2026-11-05 09:29:03', '2026-11-05 09:29:03', 'Omeka\\Entity\\Item'),
(90, 1, 116, 3, NULL, 'Plastique d\'Espace Numérique - page 15', 1, '2026-11-05 09:29:05', '2026-11-05 09:51:23', 'Omeka\\Entity\\Item'),
(91, 1, 116, 3, NULL, 'Plastique d\'Espace Numérique - page 16', 1, '2026-11-05 09:29:07', '2026-11-05 09:29:07', 'Omeka\\Entity\\Item'),
(92, 1, 116, 3, NULL, 'Plastique d\'Espace Numérique - page 17', 1, '2026-11-05 09:29:10', '2026-11-05 09:29:10', 'Omeka\\Entity\\Item'),
(93, 1, 116, 3, NULL, 'Plastique d\'Espace Numérique - page 18', 1, '2026-11-05 09:29:12', '2026-11-05 09:29:12', 'Omeka\\Entity\\Item'),
(94, 1, 116, 3, NULL, 'Plastique d\'Espace Numérique - page 19', 1, '2026-11-05 09:29:14', '2026-11-05 09:29:14', 'Omeka\\Entity\\Item'),
(95, 1, 116, 3, NULL, 'Plastique d\'Espace Numérique - page 20', 1, '2026-11-05 09:29:17', '2026-11-05 09:29:17', 'Omeka\\Entity\\Item'),
(96, 1, 116, 3, NULL, 'Plastique d\'Espace Numérique - page 21', 1, '2026-11-05 09:29:20', '2026-11-05 09:29:20', 'Omeka\\Entity\\Item'),
(97, 1, 116, 3, NULL, 'Plastique d\'Espace Numérique - page 22', 1, '2026-11-05 09:29:22', '2026-11-05 09:29:22', 'Omeka\\Entity\\Item'),
(98, 1, 116, 3, NULL, 'Plastique d\'Espace Numérique - page 23', 1, '2026-11-05 09:29:25', '2026-11-05 09:29:25', 'Omeka\\Entity\\Item'),
(99, 1, 116, 3, NULL, 'Plastique d\'Espace Numérique - page 24', 1, '2026-11-05 09:29:28', '2026-11-05 09:29:28', 'Omeka\\Entity\\Item'),
(100, 1, 116, 3, NULL, 'Plastique d\'Espace Numérique - page 25', 1, '2026-11-05 09:29:32', '2026-11-05 09:29:32', 'Omeka\\Entity\\Item'),
(101, 1, 116, 3, NULL, 'Plastique d\'Espace Numérique - page 26', 1, '2026-11-05 09:29:35', '2026-11-05 09:29:35', 'Omeka\\Entity\\Item'),
(102, 1, 116, 3, NULL, 'Plastique d\'Espace Numérique - page 27', 1, '2026-11-05 09:29:38', '2026-11-05 09:29:38', 'Omeka\\Entity\\Item'),
(103, 1, 116, 3, NULL, 'Plastique d\'Espace Numérique - page 28', 1, '2026-11-05 09:29:42', '2026-11-05 09:29:42', 'Omeka\\Entity\\Item'),
(104, 1, 116, 3, NULL, 'Plastique d\'Espace Numérique - page 29', 1, '2026-11-05 09:29:45', '2026-11-05 09:29:45', 'Omeka\\Entity\\Item'),
(105, 1, 116, 3, NULL, 'Plastique d\'Espace Numérique - page 30', 1, '2026-11-05 09:29:49', '2026-11-05 09:29:49', 'Omeka\\Entity\\Item'),
(106, 1, 116, 3, NULL, 'Plastique d\'Espace Numérique - page 31', 1, '2026-11-05 09:29:53', '2026-11-05 09:29:53', 'Omeka\\Entity\\Item'),
(107, 1, 116, 3, NULL, 'Plastique d\'Espace Numérique - page 32', 1, '2026-11-05 09:29:57', '2026-11-05 09:29:57', 'Omeka\\Entity\\Item'),
(108, 1, 116, 3, NULL, 'Plastique d\'Espace Numérique - page 33', 1, '2026-11-05 09:30:01', '2026-11-05 09:30:01', 'Omeka\\Entity\\Item'),
(109, 1, 116, 3, NULL, 'Plastique d\'Espace Numérique - page 34', 1, '2026-11-05 09:30:05', '2026-11-05 09:30:05', 'Omeka\\Entity\\Item'),
(110, 1, 116, 3, NULL, 'Plastique d\'Espace Numérique - page 35', 1, '2026-11-05 09:30:10', '2026-11-05 09:30:10', 'Omeka\\Entity\\Item'),
(111, 1, 116, 3, NULL, 'Plastique d\'Espace Numérique - page 36', 1, '2026-11-05 09:30:14', '2026-11-05 09:30:14', 'Omeka\\Entity\\Item'),
(112, 1, 116, 3, NULL, 'Plastique d\'Espace Numérique - page 37', 1, '2026-11-05 09:30:19', '2026-11-05 09:30:19', 'Omeka\\Entity\\Item'),
(113, 1, 116, 3, NULL, 'Plastique d\'Espace Numérique - page 38', 1, '2026-11-05 09:30:24', '2026-11-05 09:30:24', 'Omeka\\Entity\\Item'),
(114, 1, 116, 3, NULL, 'Plastique d\'Espace Numérique - page 39', 1, '2026-11-05 09:30:28', '2026-11-05 09:30:28', 'Omeka\\Entity\\Item'),
(115, 1, 116, 3, NULL, 'Plastique d\'Espace Numérique - page 40', 1, '2026-11-05 09:30:33', '2026-11-05 09:30:33', 'Omeka\\Entity\\Item'),
(116, 1, 116, 3, NULL, 'Plastique d\'Espace Numérique - page 41', 1, '2026-11-05 09:30:39', '2026-11-05 09:30:39', 'Omeka\\Entity\\Item'),
(117, 1, 116, 3, NULL, 'Plastique d\'Espace Numérique - page 42', 1, '2026-11-05 09:30:44', '2026-11-05 09:30:44', 'Omeka\\Entity\\Item'),
(118, 1, 116, 3, NULL, 'Plastique d\'Espace Numérique - page 43', 1, '2026-11-05 09:30:49', '2026-11-05 09:30:49', 'Omeka\\Entity\\Item'),
(119, 1, 116, 3, NULL, 'Plastique d\'Espace Numérique - page 44', 1, '2026-11-05 09:30:55', '2026-11-05 09:30:55', 'Omeka\\Entity\\Item'),
(120, 1, 116, 3, NULL, 'Plastique d\'Espace Numérique - page 45', 1, '2026-11-05 09:31:00', '2026-11-05 09:31:00', 'Omeka\\Entity\\Item'),
(121, 1, 116, 3, NULL, 'Plastique d\'Espace Numérique - page 46', 1, '2026-11-05 09:31:06', '2026-11-05 09:31:06', 'Omeka\\Entity\\Item'),
(129, 1, NULL, NULL, NULL, NULL, 1, '2026-11-05 09:48:54', '2026-11-05 09:48:54', 'Omeka\\Entity\\Media'),
(130, 1, NULL, NULL, NULL, NULL, 1, '2026-11-05 09:49:32', '2026-11-05 09:49:32', 'Omeka\\Entity\\Media'),
(131, 1, NULL, NULL, NULL, NULL, 1, '2026-11-05 09:51:23', '2026-11-05 09:51:23', 'Omeka\\Entity\\Media'),
(136, 1, 106, 2, NULL, 'Temporalité', 1, '2026-11-05 10:22:42', '2026-11-06 05:41:49', 'Omeka\\Entity\\Item'),
(182, 1, NULL, NULL, NULL, NULL, 1, '2026-11-05 15:22:26', '2026-11-06 05:41:49', 'Omeka\\Entity\\ValueAnnotation'),
(183, 1, NULL, NULL, NULL, NULL, 1, '2026-11-05 15:24:38', '2026-11-06 05:41:49', 'Omeka\\Entity\\ValueAnnotation'),
(201, 1, NULL, NULL, NULL, NULL, 1, '2026-11-05 15:57:05', '2026-11-06 05:41:49', 'Omeka\\Entity\\ValueAnnotation'),
(209, 1, 106, 2, NULL, 'Pouvoirs', 1, '2026-11-06 04:53:29', '2026-11-06 04:53:29', 'Omeka\\Entity\\Item'),
(210, 1, 106, 2, NULL, 'Dicerner', 1, '2026-11-06 04:55:22', '2026-11-06 05:04:11', 'Omeka\\Entity\\Item'),
(211, 1, 106, 2, NULL, 'Raisonner', 1, '2026-11-06 04:57:22', '2026-11-06 05:04:11', 'Omeka\\Entity\\Item'),
(212, 1, 106, 2, NULL, 'Résonner', 1, '2026-11-06 05:00:19', '2026-11-06 05:04:11', 'Omeka\\Entity\\Item'),
(213, 1, 106, 2, NULL, 'Agir', 1, '2026-11-06 05:02:40', '2026-11-06 05:04:11', 'Omeka\\Entity\\Item'),
(214, 1, NULL, NULL, NULL, 'Pouvoirs', 1, '2026-11-06 05:03:43', '2026-11-06 05:03:43', 'Omeka\\Entity\\ItemSet'),
(221, 1, 114, 4, NULL, 'HyperCard', 1, '2026-11-06 05:36:47', '2026-11-06 05:37:25', 'Omeka\\Entity\\Item'),
(224, 1, 106, 2, NULL, 'source', 1, '2026-11-06 05:39:27', '2026-11-06 05:39:27', 'Omeka\\Entity\\Item'),
(225, 1, 121, 7, NULL, 'Définir les sources', 1, '2026-11-06 05:39:27', '2026-11-06 06:43:16', 'Omeka\\Entity\\Item'),
(228, 1, NULL, NULL, NULL, NULL, 1, '2026-11-06 05:42:07', '2026-11-06 06:26:12', 'Omeka\\Entity\\ValueAnnotation'),
(230, 1, NULL, NULL, NULL, NULL, 1, '2026-11-06 05:42:18', '2026-11-06 06:09:43', 'Omeka\\Entity\\ValueAnnotation'),
(232, 1, NULL, NULL, NULL, NULL, 1, '2026-11-06 05:42:29', '2026-11-06 06:09:58', 'Omeka\\Entity\\ValueAnnotation'),
(264, 1, NULL, NULL, NULL, NULL, 1, '2026-11-06 06:11:53', '2026-11-06 06:43:16', 'Omeka\\Entity\\ValueAnnotation'),
(266, 1, 106, 2, NULL, 'Définir', 1, '2026-11-06 06:15:43', '2026-11-06 06:20:21', 'Omeka\\Entity\\Item'),
(280, 1, 121, 7, NULL, 'Evaluer la pertinence', 1, '2026-11-06 09:45:58', '2026-11-06 09:45:58', 'Omeka\\Entity\\Item'),
(281, 1, NULL, NULL, NULL, NULL, 1, '2026-11-06 09:45:58', '2026-11-06 09:45:58', 'Omeka\\Entity\\ValueAnnotation'),
(282, 1, NULL, NULL, NULL, NULL, 1, '2026-11-06 09:45:58', '2026-11-06 09:45:58', 'Omeka\\Entity\\ValueAnnotation'),
(283, 1, NULL, NULL, NULL, NULL, 1, '2026-11-06 09:45:58', '2026-11-06 09:45:58', 'Omeka\\Entity\\ValueAnnotation'),
(284, 1, 106, 2, NULL, 'Saisir', 1, '2026-11-06 09:48:30', '2026-11-06 09:48:30', 'Omeka\\Entity\\Item'),
(285, 1, NULL, NULL, NULL, 'EcoSpace : positions des éléments', 1, '2026-11-06 09:48:34', '2026-11-06 09:48:34', 'Omeka\\Entity\\Media'),
(286, 1, 121, 7, NULL, 'Saisir les données', 1, '2026-11-06 09:50:53', '2026-11-06 09:50:53', 'Omeka\\Entity\\Item'),
(287, 1, NULL, NULL, NULL, NULL, 1, '2026-11-06 09:50:53', '2026-11-06 09:50:53', 'Omeka\\Entity\\ValueAnnotation'),
(288, 1, NULL, NULL, NULL, NULL, 1, '2026-11-06 09:50:53', '2026-11-06 09:50:53', 'Omeka\\Entity\\ValueAnnotation'),
(289, 1, NULL, NULL, NULL, NULL, 1, '2026-11-06 09:50:53', '2026-11-06 09:50:53', 'Omeka\\Entity\\ValueAnnotation'),
(290, 1, NULL, NULL, NULL, NULL, 1, '2026-11-06 09:50:53', '2026-11-06 09:50:53', 'Omeka\\Entity\\ValueAnnotation'),
(291, 1, NULL, NULL, NULL, NULL, 1, '2026-11-06 09:50:53', '2026-11-06 09:50:53', 'Omeka\\Entity\\ValueAnnotation'),
(292, 1, NULL, NULL, NULL, NULL, 1, '2026-11-06 09:50:53', '2026-11-06 09:50:53', 'Omeka\\Entity\\ValueAnnotation'),
(299, 1, 124, 12, NULL, 'Initialiser une partition multimédia', 1, '2026-11-06 14:45:28', '2026-11-06 15:23:27', 'Omeka\\Entity\\Item'),
(300, 1, 109, 11, NULL, NULL, 1, '2026-11-06 14:45:28', '2026-11-06 15:23:27', 'Omeka\\Entity\\ValueAnnotation'),
(301, 1, 109, 11, NULL, NULL, 1, '2026-11-06 14:47:26', '2026-11-06 15:23:27', 'Omeka\\Entity\\ValueAnnotation'),
(302, 1, 109, 11, NULL, NULL, 1, '2026-11-06 15:23:27', '2026-11-06 15:23:27', 'Omeka\\Entity\\ValueAnnotation');

-- --------------------------------------------------------

--
-- Structure de la table `resource_class`
--

CREATE TABLE `resource_class` (
  `id` int(11) NOT NULL,
  `owner_id` int(11) DEFAULT NULL,
  `vocabulary_id` int(11) NOT NULL,
  `local_name` varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `label` varchar(255) NOT NULL,
  `comment` longtext DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `resource_class`
--

INSERT INTO `resource_class` (`id`, `owner_id`, `vocabulary_id`, `local_name`, `label`, `comment`) VALUES
(1, NULL, 1, 'Agent', 'Agent', 'A resource that acts or has the power to act.'),
(2, NULL, 1, 'AgentClass', 'Agent Class', 'A group of agents.'),
(3, NULL, 1, 'BibliographicResource', 'Bibliographic Resource', 'A book, article, or other documentary resource.'),
(4, NULL, 1, 'FileFormat', 'File Format', 'A digital resource format.'),
(5, NULL, 1, 'Frequency', 'Frequency', 'A rate at which something recurs.'),
(6, NULL, 1, 'Jurisdiction', 'Jurisdiction', 'The extent or range of judicial, law enforcement, or other authority.'),
(7, NULL, 1, 'LicenseDocument', 'License Document', 'A legal document giving official permission to do something with a Resource.'),
(8, NULL, 1, 'LinguisticSystem', 'Linguistic System', 'A system of signs, symbols, sounds, gestures, or rules used in communication.'),
(9, NULL, 1, 'Location', 'Location', 'A spatial region or named place.'),
(10, NULL, 1, 'LocationPeriodOrJurisdiction', 'Location, Period, or Jurisdiction', 'A location, period of time, or jurisdiction.'),
(11, NULL, 1, 'MediaType', 'Media Type', 'A file format or physical medium.'),
(12, NULL, 1, 'MediaTypeOrExtent', 'Media Type or Extent', 'A media type or extent.'),
(13, NULL, 1, 'MethodOfInstruction', 'Method of Instruction', 'A process that is used to engender knowledge, attitudes, and skills.'),
(14, NULL, 1, 'MethodOfAccrual', 'Method of Accrual', 'A method by which resources are added to a collection.'),
(15, NULL, 1, 'PeriodOfTime', 'Period of Time', 'An interval of time that is named or defined by its start and end dates.'),
(16, NULL, 1, 'PhysicalMedium', 'Physical Medium', 'A physical material or carrier.'),
(17, NULL, 1, 'PhysicalResource', 'Physical Resource', 'A material thing.'),
(18, NULL, 1, 'Policy', 'Policy', 'A plan or course of action by an authority, intended to influence and determine decisions, actions, and other matters.'),
(19, NULL, 1, 'ProvenanceStatement', 'Provenance Statement', 'A statement of any changes in ownership and custody of a resource since its creation that are significant for its authenticity, integrity, and interpretation.'),
(20, NULL, 1, 'RightsStatement', 'Rights Statement', 'A statement about the intellectual property rights (IPR) held in or over a Resource, a legal document giving official permission to do something with a resource, or a statement about access rights.'),
(21, NULL, 1, 'SizeOrDuration', 'Size or Duration', 'A dimension or extent, or a time taken to play or execute.'),
(22, NULL, 1, 'Standard', 'Standard', 'A basis for comparison; a reference point against which other things can be evaluated.'),
(23, NULL, 2, 'Collection', 'Collection', 'An aggregation of resources.'),
(24, NULL, 2, 'Dataset', 'Dataset', 'Data encoded in a defined structure.'),
(25, NULL, 2, 'Event', 'Event', 'A non-persistent, time-based occurrence.'),
(26, NULL, 2, 'Image', 'Image', 'A visual representation other than text.'),
(27, NULL, 2, 'InteractiveResource', 'Interactive Resource', 'A resource requiring interaction from the user to be understood, executed, or experienced.'),
(28, NULL, 2, 'Service', 'Service', 'A system that provides one or more functions.'),
(29, NULL, 2, 'Software', 'Software', 'A computer program in source or compiled form.'),
(30, NULL, 2, 'Sound', 'Sound', 'A resource primarily intended to be heard.'),
(31, NULL, 2, 'Text', 'Text', 'A resource consisting primarily of words for reading.'),
(32, NULL, 2, 'PhysicalObject', 'Physical Object', 'An inanimate, three-dimensional object or substance.'),
(33, NULL, 2, 'StillImage', 'Still Image', 'A static visual representation.'),
(34, NULL, 2, 'MovingImage', 'Moving Image', 'A series of visual representations imparting an impression of motion when shown in succession.'),
(35, NULL, 3, 'AcademicArticle', 'Academic Article', 'A scholarly academic article, typically published in a journal.'),
(36, NULL, 3, 'Article', 'Article', 'A written composition in prose, usually nonfiction, on a specific topic, forming an independent part of a book or other publication, as a newspaper or magazine.'),
(37, NULL, 3, 'AudioDocument', 'audio document', 'An audio document; aka record.'),
(38, NULL, 3, 'AudioVisualDocument', 'audio-visual document', 'An audio-visual document; film, video, and so forth.'),
(39, NULL, 3, 'Bill', 'Bill', 'Draft legislation presented for discussion to a legal body.'),
(40, NULL, 3, 'Book', 'Book', 'A written or printed work of fiction or nonfiction, usually on sheets of paper fastened or bound together within covers.'),
(41, NULL, 3, 'BookSection', 'Book Section', 'A section of a book.'),
(42, NULL, 3, 'Brief', 'Brief', 'A written argument submitted to a court.'),
(43, NULL, 3, 'Chapter', 'Chapter', 'A chapter of a book.'),
(44, NULL, 3, 'Code', 'Code', 'A collection of statutes.'),
(45, NULL, 3, 'CollectedDocument', 'Collected Document', 'A document that simultaneously contains other documents.'),
(46, NULL, 3, 'Collection', 'Collection', 'A collection of Documents or Collections'),
(47, NULL, 3, 'Conference', 'Conference', 'A meeting for consultation or discussion.'),
(48, NULL, 3, 'CourtReporter', 'Court Reporter', 'A collection of legal cases.'),
(49, NULL, 3, 'Document', 'Document', 'A document (noun) is a bounded physical representation of body of information designed with the capacity (and usually intent) to communicate. A document may manifest symbolic, diagrammatic or sensory-representational information.'),
(50, NULL, 3, 'DocumentPart', 'document part', 'a distinct part of a larger document or collected document.'),
(51, NULL, 3, 'DocumentStatus', 'Document Status', 'The status of the publication of a document.'),
(52, NULL, 3, 'EditedBook', 'Edited Book', 'An edited book.'),
(53, NULL, 3, 'Email', 'EMail', 'A written communication addressed to a person or organization and transmitted electronically.'),
(54, NULL, 3, 'Event', 'Event', NULL),
(55, NULL, 3, 'Excerpt', 'Excerpt', 'A passage selected from a larger work.'),
(56, NULL, 3, 'Film', 'Film', 'aka movie.'),
(57, NULL, 3, 'Hearing', 'Hearing', 'An instance or a session in which testimony and arguments are presented, esp. before an official, as a judge in a lawsuit.'),
(58, NULL, 3, 'Image', 'Image', 'A document that presents visual or diagrammatic information.'),
(59, NULL, 3, 'Interview', 'Interview', 'A formalized discussion between two or more people.'),
(60, NULL, 3, 'Issue', 'Issue', 'something that is printed or published and distributed, esp. a given number of a periodical'),
(61, NULL, 3, 'Journal', 'Journal', 'A periodical of scholarly journal Articles.'),
(62, NULL, 3, 'LegalCaseDocument', 'Legal Case Document', 'A document accompanying a legal case.'),
(63, NULL, 3, 'LegalDecision', 'Decision', 'A document containing an authoritative determination (as a decree or judgment) made after consideration of facts or law.'),
(64, NULL, 3, 'LegalDocument', 'Legal Document', 'A legal document; for example, a court decision, a brief, and so forth.'),
(65, NULL, 3, 'Legislation', 'Legislation', 'A legal document proposing or enacting a law or a group of laws.'),
(66, NULL, 3, 'Letter', 'Letter', 'A written or printed communication addressed to a person or organization and usually transmitted by mail.'),
(67, NULL, 3, 'Magazine', 'Magazine', 'A periodical of magazine Articles. A magazine is a publication that is issued periodically, usually bound in a paper cover, and typically contains essays, stories, poems, etc., by many writers, and often photographs and drawings, frequently specializing in a particular subject or area, as hobbies, news, or sports.'),
(68, NULL, 3, 'Manual', 'Manual', 'A small reference book, especially one giving instructions.'),
(69, NULL, 3, 'Manuscript', 'Manuscript', 'An unpublished Document, which may also be submitted to a publisher for publication.'),
(70, NULL, 3, 'Map', 'Map', 'A graphical depiction of geographic features.'),
(71, NULL, 3, 'MultiVolumeBook', 'Multivolume Book', 'A loose, thematic, collection of Documents, often Books.'),
(72, NULL, 3, 'Newspaper', 'Newspaper', 'A periodical of documents, usually issued daily or weekly, containing current news, editorials, feature articles, and usually advertising.'),
(73, NULL, 3, 'Note', 'Note', 'Notes or annotations about a resource.'),
(74, NULL, 3, 'Patent', 'Patent', 'A document describing the exclusive right granted by a government to an inventor to manufacture, use, or sell an invention for a certain number of years.'),
(75, NULL, 3, 'Performance', 'Performance', 'A public performance.'),
(76, NULL, 3, 'Periodical', 'Periodical', 'A group of related documents issued at regular intervals.'),
(77, NULL, 3, 'PersonalCommunication', 'Personal Communication', 'A communication between an agent and one or more specific recipients.'),
(78, NULL, 3, 'PersonalCommunicationDocument', 'Personal Communication Document', 'A personal communication manifested in some document.'),
(79, NULL, 3, 'Proceedings', 'Proceedings', 'A compilation of documents published from an event, such as a conference.'),
(80, NULL, 3, 'Quote', 'Quote', 'An excerpted collection of words.'),
(81, NULL, 3, 'ReferenceSource', 'Reference Source', 'A document that presents authoritative reference information, such as a dictionary or encylopedia .'),
(82, NULL, 3, 'Report', 'Report', 'A document describing an account or statement describing in detail an event, situation, or the like, usually as the result of observation, inquiry, etc..'),
(83, NULL, 3, 'Series', 'Series', 'A loose, thematic, collection of Documents, often Books.'),
(84, NULL, 3, 'Slide', 'Slide', 'A slide in a slideshow'),
(85, NULL, 3, 'Slideshow', 'Slideshow', 'A presentation of a series of slides, usually presented in front of an audience with written text and images.'),
(86, NULL, 3, 'Standard', 'Standard', 'A document describing a standard'),
(87, NULL, 3, 'Statute', 'Statute', 'A bill enacted into law.'),
(88, NULL, 3, 'Thesis', 'Thesis', 'A document created to summarize research findings associated with the completion of an academic degree.'),
(89, NULL, 3, 'ThesisDegree', 'Thesis degree', 'The academic degree of a Thesis'),
(90, NULL, 3, 'Webpage', 'Webpage', 'A web page is an online document available (at least initially) on the world wide web. A web page is written first and foremost to appear on the web, as distinct from other online resources such as books, manuscripts or audio documents which use the web primarily as a distribution mechanism alongside other more traditional methods such as print.'),
(91, NULL, 3, 'Website', 'Website', 'A group of Webpages accessible on the Web.'),
(92, NULL, 3, 'Workshop', 'Workshop', 'A seminar, discussion group, or the like, that emphasizes zxchange of ideas and the demonstration and application of techniques, skills, etc.'),
(93, NULL, 4, 'LabelProperty', 'Label Property', 'A foaf:LabelProperty is any RDF property with texual values that serve as labels.'),
(94, NULL, 4, 'Person', 'Person', 'A person.'),
(95, NULL, 4, 'Document', 'Document', 'A document.'),
(96, NULL, 4, 'Organization', 'Organization', 'An organization.'),
(97, NULL, 4, 'Group', 'Group', 'A class of Agents.'),
(98, NULL, 4, 'Agent', 'Agent', 'An agent (eg. person, group, software or physical artifact).'),
(99, NULL, 4, 'Project', 'Project', 'A project (a collective endeavour of some kind).'),
(100, NULL, 4, 'Image', 'Image', 'An image.'),
(101, NULL, 4, 'PersonalProfileDocument', 'PersonalProfileDocument', 'A personal profile RDF document.'),
(102, NULL, 4, 'OnlineAccount', 'Online Account', 'An online account.'),
(103, NULL, 4, 'OnlineGamingAccount', 'Online Gaming Account', 'An online gaming account.'),
(104, NULL, 4, 'OnlineEcommerceAccount', 'Online E-commerce Account', 'An online e-commerce account.'),
(105, NULL, 4, 'OnlineChatAccount', 'Online Chat Account', 'An online chat account.'),
(106, 1, 5, 'Concept', 'Concept', NULL),
(107, 1, 5, 'ConceptScheme', 'Concept Scheme', NULL),
(108, 1, 5, 'Collection', 'Collection', NULL),
(109, 1, 5, 'OrderedCollection', 'Ordered Collection', NULL),
(110, 1, 6, 'SemanticPosition', 'SemanticPosition', NULL),
(111, 1, 6, 'Crible', 'Crible', NULL),
(112, 1, 6, 'CriblePosition', 'CriblePosition', NULL),
(113, 1, 6, 'CribleCarto', 'Cartographie d\'un crible', NULL),
(114, 1, 6, 'Actant', 'Actant', NULL),
(115, 1, 6, 'Existence', 'Existence', NULL),
(116, 1, 6, 'Physique', 'Physique', NULL),
(117, 1, 6, 'Rapport', 'Rapport', NULL),
(118, 1, 6, 'Archetype', 'Archetype', NULL),
(119, 1, 6, 'Concept', 'Concept', NULL),
(120, 1, 6, 'Transcription', 'Transcription', NULL),
(121, NULL, 6, 'Pouvoir', 'Pouvoir', NULL),
(122, NULL, 6, 'Role', 'Rôle', NULL),
(123, NULL, 6, 'raisonTrajective', 'Raison trajective', NULL),
(124, NULL, 6, 'pulsationExistentielle', 'Pulsation existentielle', NULL),
(125, 1, 7, 'Annotation', 'Annotation', 'The class for Web Annotations.'),
(126, 1, 7, 'Choice', 'Choice', 'A subClass of  as:OrderedCollection  that conveys to a consuming application that it should select one of the resources in the  as:items  list to use, rather than all of them.  This is typically used to provide a choice of resources to render to the user, based on further supplied properties.  If the consuming application cannot determine the user\'s preference, then it should use the first in the list.'),
(127, 1, 7, 'CssSelector', 'Css selector', 'A CssSelector describes a Segment of interest in a representation that conforms to the Document Object Model through the use of the CSS selector specification.'),
(128, 1, 7, 'CssStyle', 'Css style', 'A resource which describes styles for resources participating in the Annotation using CSS.'),
(129, 1, 7, 'DataPositionSelector', 'Data position selector', 'DataPositionSelector describes a range of data by recording the start and end positions of the selection in the stream. Position 0 would be immediately before the first byte, position 1 would be immediately before the second byte, and so on. The start byte is thus included in the list, but the end byte is not.'),
(130, 1, 7, 'Direction', 'Direction', 'A class to encapsulate the different text directions that a textual resource might take.  It is not used directly in the Annotation Model, only its three instances.'),
(131, 1, 7, 'FragmentSelector', 'Fragment selector', 'The FragmentSelector class is used to record the segment of a representation using the IRI fragment specification defined by the representation\'s media type.'),
(132, 1, 7, 'HttpRequestState', 'Http request state', 'The HttpRequestState class is used to record the HTTP request headers that a client SHOULD use to request the correct representation from the resource. '),
(133, 1, 7, 'Motivation', 'Motivation', 'The Motivation class is used to record the user\'s intent or motivation for the creation of the Annotation, or the inclusion of the body or target, that it is associated with.'),
(134, 1, 7, 'RangeSelector', 'Range selector', 'A Range Selector can be used to identify the beginning and the end of the selection by using other Selectors. The selection consists of everything from the beginning of the starting selector through to the beginning of the ending selector, but not including it.'),
(135, 1, 7, 'ResourceSelection', 'Resource selection', 'Instances of the ResourceSelection class identify part (described by an oa:Selector) of another resource (referenced with oa:hasSource), possibly from a particular representation of a resource (described by an oa:State). Please note that ResourceSelection is not used directly in the Web Annotation model, but is provided as a separate class for further application profiles to use, separate from oa:SpecificResource which has many Annotation specific features.'),
(136, 1, 7, 'Selector', 'Selector', 'A resource which describes the segment of interest in a representation of a Source resource, indicated with oa:hasSelector from the Specific Resource. This class is not used directly in the Annotation model, only its subclasses.'),
(137, 1, 7, 'SpecificResource', 'Specific resource', 'Instances of the SpecificResource class identify part of another resource (referenced with oa:hasSource), a particular representation of a resource, a resource with styling hints for renders, or any combination of these, as used within an Annotation.'),
(138, 1, 7, 'State', 'State', 'A State describes the intended state of a resource as applied to the particular Annotation, and thus provides the information needed to retrieve the correct representation of that resource.'),
(139, 1, 7, 'Style', 'Style', 'A Style describes the intended styling of a resource as applied to the particular Annotation, and thus provides the information to ensure that rendering is consistent across implementations.'),
(140, 1, 7, 'SvgSelector', 'Svg selector', 'An SvgSelector defines an area through the use of the Scalable Vector Graphics [SVG] standard. This allows the user to select a non-rectangular area of the content, such as a circle or polygon by describing the region using SVG. The SVG may be either embedded within the Annotation or referenced as an External Resource.'),
(141, 1, 7, 'TextPositionSelector', 'Text position selector', 'The TextPositionSelector describes a range of text by recording the start and end positions of the selection in the stream. Position 0 would be immediately before the first character, position 1 would be immediately before the second character, and so on.'),
(142, 1, 7, 'TextQuoteSelector', 'Text quote selector', 'The TextQuoteSelector describes a range of text by copying it, and including some of the text immediately before (a prefix) and after (a suffix) it to distinguish between multiple copies of the same sequence of characters.'),
(143, 1, 7, 'TextualBody', 'Textual body', ''),
(144, 1, 7, 'TimeState', 'Time state', 'A TimeState records the time at which the resource\'s state is appropriate for the Annotation, typically the time that the Annotation was created and/or a link to a persistent copy of the current version.'),
(145, 1, 7, 'XPathSelector', 'XPath selector', ' An XPathSelector is used to select elements and content within a resource that supports the Document Object Model via a specified XPath value.'),
(146, 1, 8, 'Property', 'Property', 'The class of RDF properties.'),
(147, 1, 8, 'Statement', 'Statement', 'The class of RDF statements.'),
(148, 1, 8, 'Bag', 'Bag', 'The class of unordered containers.'),
(149, 1, 8, 'Seq', 'Seq', 'The class of ordered containers.'),
(150, 1, 8, 'Alt', 'Alt', 'The class of containers of alternatives.'),
(151, 1, 8, 'List', 'List', 'The class of RDF Lists.'),
(152, NULL, 6, 'EcoCon', 'Ecosystème de connaissances', NULL);

-- --------------------------------------------------------

--
-- Structure de la table `resource_template`
--

CREATE TABLE `resource_template` (
  `id` int(11) NOT NULL,
  `owner_id` int(11) DEFAULT NULL,
  `resource_class_id` int(11) DEFAULT NULL,
  `title_property_id` int(11) DEFAULT NULL,
  `description_property_id` int(11) DEFAULT NULL,
  `label` varchar(190) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `resource_template`
--

INSERT INTO `resource_template` (`id`, `owner_id`, `resource_class_id`, `title_property_id`, `description_property_id`, `label`) VALUES
(2, 1, 106, NULL, NULL, 'Concept'),
(3, 1, 116, NULL, NULL, 'Physique'),
(4, 1, 114, NULL, NULL, 'Actant'),
(5, 1, 111, NULL, NULL, 'Crible'),
(6, 1, 1, NULL, NULL, 'Agent'),
(7, 1, 121, NULL, NULL, 'Pouvoir existentiel'),
(8, 1, 94, NULL, NULL, 'Personne'),
(9, 1, 122, NULL, NULL, 'Rôle'),
(10, 1, 123, NULL, NULL, 'Raison trajective'),
(11, 1, 109, NULL, NULL, 'Temporalités'),
(12, 1, 124, NULL, NULL, 'Pulsation existentielle'),
(13, 1, 125, NULL, NULL, 'Annotation'),
(14, 1, 152, NULL, NULL, 'Ecosystème de connaissances');

-- --------------------------------------------------------

--
-- Structure de la table `resource_template_data`
--

CREATE TABLE `resource_template_data` (
  `id` int(11) NOT NULL,
  `resource_template_id` int(11) NOT NULL,
  `data` longtext NOT NULL COMMENT '(DC2Type:json)'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `resource_template_data`
--

INSERT INTO `resource_template_data` (`id`, `resource_template_id`, `data`) VALUES
(1, 7, '{\"use_for_resources\":[\"items\"],\"require_resource_class\":\"0\",\"closed_class_list\":\"0\",\"closed_property_list\":\"0\",\"quick_new_resource\":\"yes\",\"autocomplete\":\"no\",\"item_sets\":[\"9\"],\"media_templates_minimum\":[],\"settings\":\"\",\"value_languages\":[],\"default_language\":\"\",\"no_language\":\"0\",\"title_fallback_properties\":[],\"automatic_values\":\"\",\"value_annotations_template\":\"\",\"value_suggest_keep_original_label\":\"0\",\"value_suggest_require_uri\":\"0\",\"groups\":[],\"subject_values_order\":[],\"suggested_resource_class_ids\":{\"jdc:Pouvoir\":121}}'),
(2, 2, '{\"use_for_resources\":[\"items\",\"media\",\"item_sets\"],\"require_resource_class\":\"0\",\"closed_class_list\":\"0\",\"closed_property_list\":\"0\",\"quick_new_resource\":\"yes\",\"autocomplete\":\"no\",\"item_sets\":[\"2\"],\"media_templates_minimum\":[],\"settings\":\"\",\"value_languages\":[],\"default_language\":\"\",\"no_language\":\"0\",\"title_fallback_properties\":[],\"automatic_values\":\"\",\"value_annotations_template\":\"\",\"value_suggest_keep_original_label\":\"0\",\"value_suggest_require_uri\":\"0\",\"groups\":[],\"subject_values_order\":[],\"suggested_resource_class_ids\":{\"skos:Concept\":106}}'),
(3, 8, '{\"use_for_resources\":[\"items\"],\"require_resource_class\":\"0\",\"closed_class_list\":\"0\",\"closed_property_list\":\"0\",\"quick_new_resource\":\"yes\",\"autocomplete\":\"no\",\"item_sets\":[\"6\"],\"media_templates_minimum\":[],\"settings\":\"\",\"value_languages\":[],\"default_language\":\"\",\"no_language\":\"0\",\"title_fallback_properties\":[],\"automatic_values\":\"\",\"value_annotations_template\":\"\",\"value_suggest_keep_original_label\":\"0\",\"value_suggest_require_uri\":\"0\",\"groups\":[],\"subject_values_order\":[],\"suggested_resource_class_ids\":{\"foaf:Person\":94}}'),
(4, 9, '{\"use_for_resources\":[\"items\"],\"require_resource_class\":\"0\",\"closed_class_list\":\"0\",\"closed_property_list\":\"0\",\"quick_new_resource\":\"yes\",\"autocomplete\":\"no\",\"item_sets\":[\"8\"],\"media_templates_minimum\":[],\"settings\":\"\",\"value_languages\":[],\"default_language\":\"\",\"no_language\":\"0\",\"title_fallback_properties\":[],\"automatic_values\":\"\",\"value_annotations_template\":\"\",\"value_suggest_keep_original_label\":\"0\",\"value_suggest_require_uri\":\"0\",\"groups\":[],\"subject_values_order\":[],\"suggested_resource_class_ids\":{\"jdc:Role\":122}}'),
(5, 4, '{\"use_for_resources\":[\"items\"],\"require_resource_class\":\"0\",\"closed_class_list\":\"0\",\"closed_property_list\":\"0\",\"quick_new_resource\":\"yes\",\"autocomplete\":\"no\",\"item_sets\":[\"3\"],\"media_templates_minimum\":[],\"settings\":\"\",\"value_languages\":[],\"default_language\":\"\",\"no_language\":\"0\",\"title_fallback_properties\":[],\"automatic_values\":\"\",\"value_annotations_template\":\"\",\"value_suggest_keep_original_label\":\"0\",\"value_suggest_require_uri\":\"0\",\"groups\":[],\"subject_values_order\":[],\"suggested_resource_class_ids\":{\"jdc:Actant\":114}}'),
(6, 6, '{\"use_for_resources\":[\"items\"],\"require_resource_class\":\"0\",\"closed_class_list\":\"0\",\"closed_property_list\":\"0\",\"quick_new_resource\":\"yes\",\"autocomplete\":\"no\",\"item_sets\":[\"7\"],\"media_templates_minimum\":[],\"settings\":\"\",\"value_languages\":[],\"default_language\":\"\",\"no_language\":\"0\",\"title_fallback_properties\":[],\"automatic_values\":\"\",\"value_annotations_template\":\"\",\"value_suggest_keep_original_label\":\"0\",\"value_suggest_require_uri\":\"0\",\"groups\":[],\"subject_values_order\":[],\"suggested_resource_class_ids\":{\"dcterms:Agent\":1}}'),
(7, 5, '{\"use_for_resources\":[\"items\",\"media\",\"item_sets\"],\"require_resource_class\":\"0\",\"closed_class_list\":\"0\",\"closed_property_list\":\"0\",\"quick_new_resource\":\"yes\",\"autocomplete\":\"no\",\"item_sets\":[\"5\"],\"media_templates_minimum\":[],\"settings\":\"\",\"value_languages\":[],\"default_language\":\"\",\"no_language\":\"0\",\"title_fallback_properties\":[],\"automatic_values\":\"\",\"value_annotations_template\":\"\",\"value_suggest_keep_original_label\":\"0\",\"value_suggest_require_uri\":\"0\",\"groups\":[],\"subject_values_order\":[],\"suggested_resource_class_ids\":{\"jdc:Crible\":111}}'),
(8, 3, '{\"use_for_resources\":[\"items\"],\"require_resource_class\":\"0\",\"closed_class_list\":\"0\",\"closed_property_list\":\"0\",\"quick_new_resource\":\"yes\",\"autocomplete\":\"no\",\"item_sets\":[\"4\"],\"media_templates_minimum\":[],\"settings\":\"\",\"value_languages\":[],\"default_language\":\"\",\"no_language\":\"0\",\"title_fallback_properties\":[],\"automatic_values\":\"\",\"value_annotations_template\":\"\",\"value_suggest_keep_original_label\":\"0\",\"value_suggest_require_uri\":\"0\",\"groups\":[],\"subject_values_order\":[],\"suggested_resource_class_ids\":{\"jdc:Physique\":116}}'),
(9, 10, '{\"use_for_resources\":[\"items\",\"media\",\"item_sets\"],\"require_resource_class\":\"0\",\"closed_class_list\":\"0\",\"closed_property_list\":\"0\",\"quick_new_resource\":\"yes\",\"autocomplete\":\"no\",\"item_sets\":[\"11\"],\"media_templates_minimum\":[],\"settings\":\"\",\"value_languages\":[],\"default_language\":\"\",\"no_language\":\"0\",\"title_fallback_properties\":[],\"automatic_values\":\"\",\"value_annotations_template\":\"\",\"value_suggest_keep_original_label\":\"0\",\"value_suggest_require_uri\":\"0\",\"groups\":[],\"subject_values_order\":[],\"suggested_resource_class_ids\":{\"jdc:raisonTrajective\":123}}'),
(10, 11, '{\"use_for_resources\":[\"value_annotations\"],\"require_resource_class\":\"0\",\"closed_class_list\":\"0\",\"closed_property_list\":\"0\",\"quick_new_resource\":\"yes\",\"autocomplete\":\"no\",\"item_sets\":null,\"media_templates_minimum\":[],\"settings\":\"\",\"value_languages\":[],\"default_language\":\"\",\"no_language\":\"0\",\"title_fallback_properties\":[],\"automatic_values\":\"\",\"value_annotations_template\":\"\",\"value_suggest_keep_original_label\":\"0\",\"value_suggest_require_uri\":\"0\",\"groups\":[],\"subject_values_order\":[],\"suggested_resource_class_ids\":{\"skos:OrderedCollection\":109}}'),
(11, 12, '{\"use_for_resources\":[\"items\"],\"require_resource_class\":\"0\",\"closed_class_list\":\"0\",\"closed_property_list\":\"0\",\"quick_new_resource\":\"yes\",\"autocomplete\":\"no\",\"item_sets\":[\"10\"],\"media_templates_minimum\":[],\"settings\":\"\",\"value_languages\":[],\"default_language\":\"\",\"no_language\":\"0\",\"title_fallback_properties\":[],\"automatic_values\":\"\",\"value_annotations_template\":\"\",\"value_suggest_keep_original_label\":\"0\",\"value_suggest_require_uri\":\"0\",\"groups\":[],\"subject_values_order\":[],\"suggested_resource_class_ids\":{\"jdc:pulsationExistentielle\":124}}'),
(12, 13, '[]'),
(13, 14, '{\"use_for_resources\":[\"items\"],\"require_resource_class\":\"yes\",\"closed_class_list\":\"0\",\"closed_property_list\":\"0\",\"quick_new_resource\":\"yes\",\"autocomplete\":\"no\",\"item_sets\":[\"29\"],\"media_templates_minimum\":[],\"settings\":\"\",\"value_languages\":[],\"default_language\":\"\",\"no_language\":\"0\",\"title_fallback_properties\":[],\"automatic_values\":\"\",\"value_annotations_template\":\"\",\"value_suggest_keep_original_label\":\"0\",\"value_suggest_require_uri\":\"0\",\"groups\":[],\"subject_values_order\":[],\"suggested_resource_class_ids\":{\"jdc:EcoCon\":152}}');

-- --------------------------------------------------------

--
-- Structure de la table `resource_template_property`
--

CREATE TABLE `resource_template_property` (
  `id` int(11) NOT NULL,
  `resource_template_id` int(11) NOT NULL,
  `property_id` int(11) NOT NULL,
  `alternate_label` varchar(255) DEFAULT NULL,
  `alternate_comment` longtext DEFAULT NULL,
  `position` int(11) DEFAULT NULL,
  `data_type` longtext DEFAULT NULL COMMENT '(DC2Type:json_array)',
  `is_required` tinyint(1) NOT NULL,
  `is_private` tinyint(1) NOT NULL,
  `default_lang` varchar(190) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `resource_template_property`
--

INSERT INTO `resource_template_property` (`id`, `resource_template_id`, `property_id`, `alternate_label`, `alternate_comment`, `position`, `data_type`, `is_required`, `is_private`, `default_lang`) VALUES
(21, 2, 1, NULL, NULL, 1, NULL, 0, 0, NULL),
(22, 2, 4, NULL, NULL, 2, NULL, 0, 0, NULL),
(23, 2, 185, NULL, NULL, 4, NULL, 0, 0, NULL),
(24, 2, 200, NULL, NULL, 5, '[\"customvocab:1\"]', 0, 0, NULL),
(25, 2, 201, NULL, NULL, 6, '[\"customvocab:1\"]', 0, 0, NULL),
(26, 2, 202, NULL, NULL, 7, '[\"customvocab:1\"]', 0, 0, NULL),
(27, 3, 1, NULL, NULL, 1, NULL, 0, 0, NULL),
(28, 3, 4, NULL, NULL, 2, NULL, 0, 0, NULL),
(29, 3, 33, NULL, NULL, 3, '[\"customvocab:6\"]', 0, 0, NULL),
(30, 4, 1, NULL, NULL, 1, NULL, 0, 0, NULL),
(31, 4, 4, NULL, NULL, 2, NULL, 0, 0, NULL),
(32, 4, 33, NULL, NULL, 3, NULL, 0, 0, NULL),
(33, 4, 240, NULL, NULL, 4, '[\"customvocab:5\"]', 0, 0, NULL),
(34, 4, 251, NULL, NULL, 5, '[\"customvocab:2\"]', 0, 0, NULL),
(35, 5, 1, NULL, NULL, 1, NULL, 0, 0, NULL),
(36, 5, 4, NULL, NULL, 2, NULL, 0, 0, NULL),
(37, 6, 1, NULL, NULL, 1, NULL, 0, 0, NULL),
(38, 6, 4, NULL, NULL, 2, NULL, 0, 0, NULL),
(39, 6, 8, NULL, NULL, 3, NULL, 0, 0, NULL),
(40, 6, 35, NULL, NULL, 4, NULL, 0, 0, NULL),
(41, 6, 36, NULL, NULL, 5, NULL, 0, 0, NULL),
(42, 6, 225, NULL, NULL, 6, '[\"customvocab:4\"]', 0, 0, NULL),
(43, 7, 1, NULL, NULL, 1, NULL, 0, 0, NULL),
(44, 7, 4, NULL, NULL, 2, NULL, 0, 0, NULL),
(45, 7, 221, NULL, NULL, 3, '[\"resource:item\",\"customvocab:3\"]', 0, 0, NULL),
(46, 7, 225, NULL, NULL, 4, '[\"resource:item\",\"customvocab:4\"]', 0, 0, NULL),
(47, 7, 222, NULL, NULL, 5, '[\"resource:item\",\"customvocab:6\"]', 0, 0, NULL),
(48, 7, 223, NULL, NULL, 6, '[\"resource:item\",\"customvocab:1\"]', 0, 0, NULL),
(49, 7, 8, NULL, NULL, 7, '[\"customvocab:16\"]', 0, 0, NULL),
(50, 7, 252, NULL, NULL, 8, NULL, 0, 0, NULL),
(51, 2, 35, NULL, NULL, 3, '[\"wikidata:reconciliation:all\"]', 0, 0, NULL),
(52, 8, 1, NULL, NULL, 1, NULL, 0, 0, NULL),
(53, 8, 141, NULL, NULL, 2, NULL, 0, 0, NULL),
(54, 8, 145, NULL, NULL, 3, NULL, 0, 0, NULL),
(55, 8, 4, NULL, NULL, 4, NULL, 0, 0, NULL),
(56, 8, 35, NULL, NULL, 5, '[\"wikidata:reconciliation:persons\"]', 0, 0, NULL),
(57, 9, 1, NULL, NULL, 1, NULL, 0, 0, NULL),
(58, 9, 4, NULL, NULL, 2, NULL, 0, 0, NULL),
(59, 9, 35, NULL, NULL, 3, NULL, 0, 0, NULL),
(60, 10, 1, NULL, NULL, 1, NULL, 0, 0, NULL),
(61, 10, 4, NULL, NULL, 2, NULL, 0, 0, NULL),
(62, 10, 254, NULL, NULL, 3, '[\"resource:item\",\"customvocab:10\"]', 0, 0, NULL),
(63, 11, 255, NULL, NULL, 1, '[\"customvocab:12\"]', 0, 0, NULL),
(64, 11, 256, NULL, NULL, 2, '[\"numeric:integer\"]', 0, 0, NULL),
(65, 12, 1, NULL, NULL, 1, NULL, 0, 0, NULL),
(66, 12, 4, NULL, NULL, 2, NULL, 0, 0, NULL),
(67, 12, 257, NULL, NULL, 3, '[\"resource:item\",\"customvocab:8\"]', 0, 0, NULL),
(68, 12, 258, NULL, NULL, 4, '[\"resource:item\",\"customvocab:10\"]', 0, 0, NULL),
(69, 13, 274, 'Motivated by', NULL, 1, '[\"customvocab:1\"]', 0, 0, NULL),
(70, 13, 292, 'Value', 'May be used for body textual content and/or json/xml/svg, etc. target selector.', 2, '[\"literal\"]', 0, 0, NULL),
(71, 13, 267, 'Has purpose', NULL, 3, '[\"customvocab:1\"]', 0, 0, NULL),
(72, 13, 12, NULL, 'Language of the textual body.', 4, '[\"literal\"]', 0, 0, NULL),
(73, 13, 270, 'Has source', NULL, 5, '[\"resource\"]', 0, 0, NULL),
(74, 13, 9, NULL, 'The format of the selector, if any', 6, '[\"customvocab:5\"]', 0, 0, NULL),
(75, 14, 1, NULL, NULL, 1, NULL, 0, 0, NULL),
(76, 14, 4, NULL, NULL, 2, NULL, 0, 0, NULL),
(77, 4, 316, NULL, NULL, 6, '[\"customvocab:15\"]', 0, 0, NULL),
(78, 6, 316, NULL, NULL, 7, '[\"customvocab:15\"]', 0, 0, NULL),
(79, 2, 316, NULL, NULL, 8, '[\"customvocab:15\"]', 0, 0, NULL),
(80, 8, 316, NULL, NULL, 6, NULL, 0, 0, NULL),
(81, 3, 316, NULL, NULL, 4, '[\"customvocab:15\"]', 0, 0, NULL),
(82, 3, 20, NULL, NULL, 5, '[\"numeric:timestamp\"]', 0, 0, NULL),
(83, 3, 317, NULL, NULL, 6, '[\"numeric:integer\"]', 0, 0, NULL),
(84, 5, 319, NULL, NULL, 3, NULL, 0, 0, NULL),
(85, 3, 225, NULL, NULL, 7, '[\"customvocab:4\"]', 0, 0, NULL),
(86, 5, 320, NULL, NULL, 4, NULL, 0, 0, NULL);

-- --------------------------------------------------------

--
-- Structure de la table `resource_template_property_data`
--

CREATE TABLE `resource_template_property_data` (
  `id` int(11) NOT NULL,
  `resource_template_id` int(11) NOT NULL,
  `resource_template_property_id` int(11) NOT NULL,
  `data` longtext NOT NULL COMMENT '(DC2Type:json)'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `resource_template_property_data`
--

INSERT INTO `resource_template_property_data` (`id`, `resource_template_id`, `resource_template_property_id`, `data`) VALUES
(1, 7, 43, '{\"input_control\":\"\",\"default_value\":\"\",\"automatic_value\":\"\",\"split_separator\":\"\",\"resource_query\":\"\",\"placeholder_value\":\"\",\"card_separator\":\"\",\"settings\":\"\",\"o:alternate_label\":\"\",\"o:alternate_comment\":\"\",\"is-title-property\":\"0\",\"is-description-property\":\"0\",\"o:is_required\":\"0\",\"o:is_private\":\"0\",\"o:default_lang\":\"\",\"o:data_type\":[],\"min_values\":\"\",\"max_values\":\"\",\"min_length\":\"\",\"max_length\":\"\",\"unique_value\":\"0\",\"automatic_value_issued\":\"\",\"locked_value\":\"0\",\"property_read_only\":\"0\",\"quick_new_resource\":\"\",\"autocomplete\":\"\",\"value_languages\":[],\"use_language\":\"\",\"order_by_linked_resource_properties\":[],\"value_annotations_template\":\"\",\"display_on_public_site\":\"\",\"card_display\":\"0\",\"card_role\":\"\",\"card_first_only\":\"0\",\"card_max\":\"\",\"custom_vocab_open\":\"0\",\"value_suggest_keep_original_label\":\"\",\"value_suggest_require_uri\":\"\"}'),
(2, 7, 44, '{\"input_control\":\"\",\"default_value\":\"\",\"automatic_value\":\"\",\"split_separator\":\"\",\"resource_query\":\"\",\"placeholder_value\":\"\",\"card_separator\":\"\",\"settings\":\"\",\"o:alternate_label\":\"\",\"o:alternate_comment\":\"\",\"is-title-property\":\"0\",\"is-description-property\":\"0\",\"o:is_required\":\"0\",\"o:is_private\":\"0\",\"o:default_lang\":\"\",\"o:data_type\":[],\"min_values\":\"\",\"max_values\":\"\",\"min_length\":\"\",\"max_length\":\"\",\"unique_value\":\"0\",\"automatic_value_issued\":\"\",\"locked_value\":\"0\",\"property_read_only\":\"0\",\"quick_new_resource\":\"\",\"autocomplete\":\"\",\"value_languages\":[],\"use_language\":\"\",\"order_by_linked_resource_properties\":[],\"value_annotations_template\":\"\",\"display_on_public_site\":\"\",\"card_display\":\"0\",\"card_role\":\"\",\"card_first_only\":\"0\",\"card_max\":\"\",\"custom_vocab_open\":\"0\",\"value_suggest_keep_original_label\":\"\",\"value_suggest_require_uri\":\"\"}'),
(3, 7, 45, '{\"input_control\":\"\",\"default_value\":\"\",\"automatic_value\":\"\",\"split_separator\":\"\",\"resource_query\":\"\",\"placeholder_value\":\"\",\"card_separator\":\"\",\"settings\":\"\",\"o:alternate_label\":\"\",\"o:alternate_comment\":\"\",\"is-title-property\":\"0\",\"is-description-property\":\"0\",\"o:is_required\":\"0\",\"o:is_private\":\"0\",\"o:default_lang\":\"\",\"o:data_type\":[\"resource:item\",\"customvocab:3\"],\"min_values\":\"\",\"max_values\":\"\",\"min_length\":\"\",\"max_length\":\"\",\"unique_value\":\"0\",\"automatic_value_issued\":\"\",\"locked_value\":\"0\",\"property_read_only\":\"0\",\"quick_new_resource\":\"\",\"autocomplete\":\"\",\"value_languages\":[],\"use_language\":\"\",\"order_by_linked_resource_properties\":[],\"value_annotations_template\":\"\",\"display_on_public_site\":\"\",\"card_display\":\"0\",\"card_role\":\"\",\"card_first_only\":\"0\",\"card_max\":\"\",\"custom_vocab_open\":\"0\",\"value_suggest_keep_original_label\":\"\",\"value_suggest_require_uri\":\"\"}'),
(4, 7, 46, '{\"input_control\":\"\",\"default_value\":\"\",\"automatic_value\":\"\",\"split_separator\":\"\",\"resource_query\":\"\",\"placeholder_value\":\"\",\"card_separator\":\"\",\"settings\":\"\",\"o:alternate_label\":\"\",\"o:alternate_comment\":\"\",\"is-title-property\":\"0\",\"is-description-property\":\"0\",\"o:is_required\":\"0\",\"o:is_private\":\"0\",\"o:default_lang\":\"\",\"o:data_type\":[\"resource:item\",\"customvocab:4\"],\"min_values\":\"\",\"max_values\":\"\",\"min_length\":\"\",\"max_length\":\"\",\"unique_value\":\"0\",\"automatic_value_issued\":\"\",\"locked_value\":\"0\",\"property_read_only\":\"0\",\"quick_new_resource\":\"\",\"autocomplete\":\"\",\"value_languages\":[],\"use_language\":\"\",\"order_by_linked_resource_properties\":[],\"value_annotations_template\":\"\",\"display_on_public_site\":\"\",\"card_display\":\"0\",\"card_role\":\"\",\"card_first_only\":\"0\",\"card_max\":\"\",\"custom_vocab_open\":\"0\",\"value_suggest_keep_original_label\":\"\",\"value_suggest_require_uri\":\"\"}'),
(5, 7, 47, '{\"input_control\":\"\",\"default_value\":\"\",\"automatic_value\":\"\",\"split_separator\":\"\",\"resource_query\":\"\",\"placeholder_value\":\"\",\"card_separator\":\"\",\"settings\":\"\",\"o:alternate_label\":\"\",\"o:alternate_comment\":\"\",\"is-title-property\":\"0\",\"is-description-property\":\"0\",\"o:is_required\":\"0\",\"o:is_private\":\"0\",\"o:default_lang\":\"\",\"o:data_type\":[\"resource:item\",\"customvocab:6\"],\"min_values\":\"\",\"max_values\":\"\",\"min_length\":\"\",\"max_length\":\"\",\"unique_value\":\"0\",\"automatic_value_issued\":\"\",\"locked_value\":\"0\",\"property_read_only\":\"0\",\"quick_new_resource\":\"\",\"autocomplete\":\"\",\"value_languages\":[],\"use_language\":\"\",\"order_by_linked_resource_properties\":[],\"value_annotations_template\":\"\",\"display_on_public_site\":\"\",\"card_display\":\"0\",\"card_role\":\"\",\"card_first_only\":\"0\",\"card_max\":\"\",\"custom_vocab_open\":\"0\",\"value_suggest_keep_original_label\":\"\",\"value_suggest_require_uri\":\"\"}'),
(6, 7, 48, '{\"input_control\":\"\",\"default_value\":\"\",\"automatic_value\":\"\",\"split_separator\":\"\",\"resource_query\":\"\",\"placeholder_value\":\"\",\"card_separator\":\"\",\"settings\":\"\",\"o:alternate_label\":\"\",\"o:alternate_comment\":\"\",\"is-title-property\":\"0\",\"is-description-property\":\"0\",\"o:is_required\":\"0\",\"o:is_private\":\"0\",\"o:default_lang\":\"\",\"o:data_type\":[\"resource:item\",\"customvocab:1\"],\"min_values\":\"\",\"max_values\":\"\",\"min_length\":\"\",\"max_length\":\"\",\"unique_value\":\"0\",\"automatic_value_issued\":\"\",\"locked_value\":\"0\",\"property_read_only\":\"0\",\"quick_new_resource\":\"\",\"autocomplete\":\"\",\"value_languages\":[],\"use_language\":\"\",\"order_by_linked_resource_properties\":[],\"value_annotations_template\":\"\",\"display_on_public_site\":\"\",\"card_display\":\"0\",\"card_role\":\"\",\"card_first_only\":\"0\",\"card_max\":\"\",\"custom_vocab_open\":\"yes\",\"value_suggest_keep_original_label\":\"\",\"value_suggest_require_uri\":\"\"}'),
(7, 7, 49, '{\"input_control\":\"\",\"default_value\":\"\",\"automatic_value\":\"\",\"split_separator\":\"\",\"resource_query\":\"\",\"placeholder_value\":\"\",\"card_separator\":\"\",\"settings\":\"\",\"o:alternate_label\":\"\",\"o:alternate_comment\":\"\",\"is-title-property\":\"0\",\"is-description-property\":\"0\",\"o:is_required\":\"0\",\"o:is_private\":\"0\",\"o:default_lang\":\"\",\"o:data_type\":[\"customvocab:16\"],\"min_values\":\"\",\"max_values\":\"\",\"min_length\":\"\",\"max_length\":\"\",\"unique_value\":\"0\",\"automatic_value_issued\":\"\",\"locked_value\":\"0\",\"property_read_only\":\"0\",\"quick_new_resource\":\"\",\"autocomplete\":\"\",\"value_languages\":[],\"use_language\":\"\",\"order_by_linked_resource_properties\":[],\"value_annotations_template\":\"\",\"display_on_public_site\":\"\",\"card_display\":\"0\",\"card_role\":\"\",\"card_first_only\":\"0\",\"card_max\":\"\",\"custom_vocab_open\":\"0\",\"value_suggest_keep_original_label\":\"\",\"value_suggest_require_uri\":\"\"}'),
(8, 7, 50, '{\"input_control\":\"\",\"default_value\":\"\",\"automatic_value\":\"\",\"split_separator\":\"\",\"resource_query\":\"\",\"placeholder_value\":\"\",\"card_separator\":\"\",\"settings\":\"\",\"o:alternate_label\":\"\",\"o:alternate_comment\":\"\",\"is-title-property\":\"0\",\"is-description-property\":\"0\",\"o:is_required\":\"0\",\"o:is_private\":\"0\",\"o:default_lang\":\"\",\"o:data_type\":[],\"min_values\":\"\",\"max_values\":\"\",\"min_length\":\"\",\"max_length\":\"\",\"unique_value\":\"0\",\"automatic_value_issued\":\"\",\"locked_value\":\"0\",\"property_read_only\":\"0\",\"quick_new_resource\":\"\",\"autocomplete\":\"\",\"value_languages\":[],\"use_language\":\"\",\"order_by_linked_resource_properties\":[],\"value_annotations_template\":\"\",\"display_on_public_site\":\"\",\"card_display\":\"0\",\"card_role\":\"\",\"card_first_only\":\"0\",\"card_max\":\"\",\"custom_vocab_open\":\"0\",\"value_suggest_keep_original_label\":\"\",\"value_suggest_require_uri\":\"\"}'),
(9, 2, 21, '{\"input_control\":\"\",\"default_value\":\"\",\"automatic_value\":\"\",\"split_separator\":\"\",\"resource_query\":\"\",\"placeholder_value\":\"\",\"card_separator\":\"\",\"settings\":\"\",\"o:alternate_label\":\"\",\"o:alternate_comment\":\"\",\"is-title-property\":\"0\",\"is-description-property\":\"0\",\"o:is_required\":\"0\",\"o:is_private\":\"0\",\"o:default_lang\":\"\",\"o:data_type\":[],\"min_values\":\"\",\"max_values\":\"\",\"min_length\":\"\",\"max_length\":\"\",\"unique_value\":\"0\",\"automatic_value_issued\":\"\",\"locked_value\":\"0\",\"property_read_only\":\"0\",\"quick_new_resource\":\"\",\"autocomplete\":\"\",\"value_languages\":[],\"use_language\":\"\",\"order_by_linked_resource_properties\":[],\"value_annotations_template\":\"\",\"display_on_public_site\":\"\",\"card_display\":\"0\",\"card_role\":\"\",\"card_first_only\":\"0\",\"card_max\":\"\",\"custom_vocab_open\":\"0\",\"value_suggest_keep_original_label\":\"\",\"value_suggest_require_uri\":\"\"}'),
(10, 2, 22, '{\"input_control\":\"\",\"default_value\":\"\",\"automatic_value\":\"\",\"split_separator\":\"\",\"resource_query\":\"\",\"placeholder_value\":\"\",\"card_separator\":\"\",\"settings\":\"\",\"o:alternate_label\":\"\",\"o:alternate_comment\":\"\",\"is-title-property\":\"0\",\"is-description-property\":\"0\",\"o:is_required\":\"0\",\"o:is_private\":\"0\",\"o:default_lang\":\"\",\"o:data_type\":[],\"min_values\":\"\",\"max_values\":\"\",\"min_length\":\"\",\"max_length\":\"\",\"unique_value\":\"0\",\"automatic_value_issued\":\"\",\"locked_value\":\"0\",\"property_read_only\":\"0\",\"quick_new_resource\":\"\",\"autocomplete\":\"\",\"value_languages\":[],\"use_language\":\"\",\"order_by_linked_resource_properties\":[],\"value_annotations_template\":\"\",\"display_on_public_site\":\"\",\"card_display\":\"0\",\"card_role\":\"\",\"card_first_only\":\"0\",\"card_max\":\"\",\"custom_vocab_open\":\"0\",\"value_suggest_keep_original_label\":\"\",\"value_suggest_require_uri\":\"\"}'),
(11, 2, 51, '{\"input_control\":\"\",\"default_value\":\"\",\"automatic_value\":\"\",\"split_separator\":\"\",\"resource_query\":\"\",\"placeholder_value\":\"\",\"card_separator\":\"\",\"settings\":\"\",\"o:alternate_label\":\"\",\"o:alternate_comment\":\"\",\"is-title-property\":\"0\",\"is-description-property\":\"0\",\"o:is_required\":\"0\",\"o:is_private\":\"0\",\"o:default_lang\":\"\",\"o:data_type\":[\"wikidata:reconciliation:all\"],\"min_values\":\"\",\"max_values\":\"\",\"min_length\":\"\",\"max_length\":\"\",\"unique_value\":\"0\",\"automatic_value_issued\":\"\",\"locked_value\":\"0\",\"property_read_only\":\"0\",\"quick_new_resource\":\"\",\"autocomplete\":\"\",\"value_languages\":[],\"use_language\":\"\",\"order_by_linked_resource_properties\":[],\"value_annotations_template\":\"\",\"display_on_public_site\":\"\",\"card_display\":\"0\",\"card_role\":\"\",\"card_first_only\":\"0\",\"card_max\":\"\",\"custom_vocab_open\":\"0\",\"value_suggest_keep_original_label\":\"\",\"value_suggest_require_uri\":\"\"}'),
(12, 2, 23, '{\"input_control\":\"\",\"default_value\":\"\",\"automatic_value\":\"\",\"split_separator\":\"\",\"resource_query\":\"\",\"placeholder_value\":\"\",\"card_separator\":\"\",\"settings\":\"\",\"o:alternate_label\":\"\",\"o:alternate_comment\":\"\",\"is-title-property\":\"0\",\"is-description-property\":\"0\",\"o:is_required\":\"0\",\"o:is_private\":\"0\",\"o:default_lang\":\"\",\"o:data_type\":[],\"min_values\":\"\",\"max_values\":\"\",\"min_length\":\"\",\"max_length\":\"\",\"unique_value\":\"0\",\"automatic_value_issued\":\"\",\"locked_value\":\"0\",\"property_read_only\":\"0\",\"quick_new_resource\":\"\",\"autocomplete\":\"\",\"value_languages\":[],\"use_language\":\"\",\"order_by_linked_resource_properties\":[],\"value_annotations_template\":\"\",\"display_on_public_site\":\"\",\"card_display\":\"0\",\"card_role\":\"\",\"card_first_only\":\"0\",\"card_max\":\"\",\"custom_vocab_open\":\"0\",\"value_suggest_keep_original_label\":\"\",\"value_suggest_require_uri\":\"\"}'),
(13, 2, 24, '{\"input_control\":\"\",\"default_value\":\"\",\"automatic_value\":\"\",\"split_separator\":\"\",\"resource_query\":\"\",\"placeholder_value\":\"\",\"card_separator\":\"\",\"settings\":\"\",\"o:alternate_label\":\"\",\"o:alternate_comment\":\"\",\"is-title-property\":\"0\",\"is-description-property\":\"0\",\"o:is_required\":\"0\",\"o:is_private\":\"0\",\"o:default_lang\":\"\",\"o:data_type\":[\"customvocab:1\"],\"min_values\":\"\",\"max_values\":\"\",\"min_length\":\"\",\"max_length\":\"\",\"unique_value\":\"0\",\"automatic_value_issued\":\"\",\"locked_value\":\"0\",\"property_read_only\":\"0\",\"quick_new_resource\":\"\",\"autocomplete\":\"\",\"value_languages\":[],\"use_language\":\"\",\"order_by_linked_resource_properties\":[],\"value_annotations_template\":\"\",\"display_on_public_site\":\"\",\"card_display\":\"0\",\"card_role\":\"\",\"card_first_only\":\"0\",\"card_max\":\"\",\"custom_vocab_open\":\"0\",\"value_suggest_keep_original_label\":\"\",\"value_suggest_require_uri\":\"\"}'),
(14, 2, 25, '{\"input_control\":\"\",\"default_value\":\"\",\"automatic_value\":\"\",\"split_separator\":\"\",\"resource_query\":\"\",\"placeholder_value\":\"\",\"card_separator\":\"\",\"settings\":\"\",\"o:alternate_label\":\"\",\"o:alternate_comment\":\"\",\"is-title-property\":\"0\",\"is-description-property\":\"0\",\"o:is_required\":\"0\",\"o:is_private\":\"0\",\"o:default_lang\":\"\",\"o:data_type\":[\"customvocab:1\"],\"min_values\":\"\",\"max_values\":\"\",\"min_length\":\"\",\"max_length\":\"\",\"unique_value\":\"0\",\"automatic_value_issued\":\"\",\"locked_value\":\"0\",\"property_read_only\":\"0\",\"quick_new_resource\":\"\",\"autocomplete\":\"\",\"value_languages\":[],\"use_language\":\"\",\"order_by_linked_resource_properties\":[],\"value_annotations_template\":\"\",\"display_on_public_site\":\"\",\"card_display\":\"0\",\"card_role\":\"\",\"card_first_only\":\"0\",\"card_max\":\"\",\"custom_vocab_open\":\"0\",\"value_suggest_keep_original_label\":\"\",\"value_suggest_require_uri\":\"\"}'),
(15, 2, 26, '{\"input_control\":\"\",\"default_value\":\"\",\"automatic_value\":\"\",\"split_separator\":\"\",\"resource_query\":\"\",\"placeholder_value\":\"\",\"card_separator\":\"\",\"settings\":\"\",\"o:alternate_label\":\"\",\"o:alternate_comment\":\"\",\"is-title-property\":\"0\",\"is-description-property\":\"0\",\"o:is_required\":\"0\",\"o:is_private\":\"0\",\"o:default_lang\":\"\",\"o:data_type\":[\"customvocab:1\"],\"min_values\":\"\",\"max_values\":\"\",\"min_length\":\"\",\"max_length\":\"\",\"unique_value\":\"0\",\"automatic_value_issued\":\"\",\"locked_value\":\"0\",\"property_read_only\":\"0\",\"quick_new_resource\":\"\",\"autocomplete\":\"\",\"value_languages\":[],\"use_language\":\"\",\"order_by_linked_resource_properties\":[],\"value_annotations_template\":\"\",\"display_on_public_site\":\"\",\"card_display\":\"0\",\"card_role\":\"\",\"card_first_only\":\"0\",\"card_max\":\"\",\"custom_vocab_open\":\"0\",\"value_suggest_keep_original_label\":\"\",\"value_suggest_require_uri\":\"\"}'),
(16, 8, 52, '{\"input_control\":\"\",\"default_value\":\"\",\"automatic_value\":\"\",\"split_separator\":\"\",\"resource_query\":\"\",\"placeholder_value\":\"\",\"card_separator\":\"\",\"settings\":\"\",\"o:alternate_label\":\"\",\"o:alternate_comment\":\"\",\"is-title-property\":\"0\",\"is-description-property\":\"0\",\"o:is_required\":\"0\",\"o:is_private\":\"0\",\"o:default_lang\":\"\",\"o:data_type\":[],\"min_values\":\"\",\"max_values\":\"\",\"min_length\":\"\",\"max_length\":\"\",\"unique_value\":\"0\",\"automatic_value_issued\":\"\",\"locked_value\":\"0\",\"property_read_only\":\"0\",\"quick_new_resource\":\"\",\"autocomplete\":\"\",\"value_languages\":[],\"use_language\":\"\",\"order_by_linked_resource_properties\":[],\"value_annotations_template\":\"\",\"display_on_public_site\":\"\",\"card_display\":\"0\",\"card_role\":\"\",\"card_first_only\":\"0\",\"card_max\":\"\",\"custom_vocab_open\":\"0\",\"value_suggest_keep_original_label\":\"\",\"value_suggest_require_uri\":\"\"}'),
(17, 8, 53, '{\"input_control\":\"\",\"default_value\":\"\",\"automatic_value\":\"\",\"split_separator\":\"\",\"resource_query\":\"\",\"placeholder_value\":\"\",\"card_separator\":\"\",\"settings\":\"\",\"o:alternate_label\":\"\",\"o:alternate_comment\":\"\",\"is-title-property\":\"0\",\"is-description-property\":\"0\",\"o:is_required\":\"0\",\"o:is_private\":\"0\",\"o:default_lang\":\"\",\"o:data_type\":[],\"min_values\":\"\",\"max_values\":\"\",\"min_length\":\"\",\"max_length\":\"\",\"unique_value\":\"0\",\"automatic_value_issued\":\"\",\"locked_value\":\"0\",\"property_read_only\":\"0\",\"quick_new_resource\":\"\",\"autocomplete\":\"\",\"value_languages\":[],\"use_language\":\"\",\"order_by_linked_resource_properties\":[],\"value_annotations_template\":\"\",\"display_on_public_site\":\"\",\"card_display\":\"0\",\"card_role\":\"\",\"card_first_only\":\"0\",\"card_max\":\"\",\"custom_vocab_open\":\"0\",\"value_suggest_keep_original_label\":\"\",\"value_suggest_require_uri\":\"\"}'),
(18, 8, 54, '{\"input_control\":\"\",\"default_value\":\"\",\"automatic_value\":\"\",\"split_separator\":\"\",\"resource_query\":\"\",\"placeholder_value\":\"\",\"card_separator\":\"\",\"settings\":\"\",\"o:alternate_label\":\"\",\"o:alternate_comment\":\"\",\"is-title-property\":\"0\",\"is-description-property\":\"0\",\"o:is_required\":\"0\",\"o:is_private\":\"0\",\"o:default_lang\":\"\",\"o:data_type\":[],\"min_values\":\"\",\"max_values\":\"\",\"min_length\":\"\",\"max_length\":\"\",\"unique_value\":\"0\",\"automatic_value_issued\":\"\",\"locked_value\":\"0\",\"property_read_only\":\"0\",\"quick_new_resource\":\"\",\"autocomplete\":\"\",\"value_languages\":[],\"use_language\":\"\",\"order_by_linked_resource_properties\":[],\"value_annotations_template\":\"\",\"display_on_public_site\":\"\",\"card_display\":\"0\",\"card_role\":\"\",\"card_first_only\":\"0\",\"card_max\":\"\",\"custom_vocab_open\":\"0\",\"value_suggest_keep_original_label\":\"\",\"value_suggest_require_uri\":\"\"}'),
(19, 8, 55, '{\"input_control\":\"\",\"default_value\":\"\",\"automatic_value\":\"\",\"split_separator\":\"\",\"resource_query\":\"\",\"placeholder_value\":\"\",\"card_separator\":\"\",\"settings\":\"\",\"o:alternate_label\":\"\",\"o:alternate_comment\":\"\",\"is-title-property\":\"0\",\"is-description-property\":\"0\",\"o:is_required\":\"0\",\"o:is_private\":\"0\",\"o:default_lang\":\"\",\"o:data_type\":[],\"min_values\":\"\",\"max_values\":\"\",\"min_length\":\"\",\"max_length\":\"\",\"unique_value\":\"0\",\"automatic_value_issued\":\"\",\"locked_value\":\"0\",\"property_read_only\":\"0\",\"quick_new_resource\":\"\",\"autocomplete\":\"\",\"value_languages\":[],\"use_language\":\"\",\"order_by_linked_resource_properties\":[],\"value_annotations_template\":\"\",\"display_on_public_site\":\"\",\"card_display\":\"0\",\"card_role\":\"\",\"card_first_only\":\"0\",\"card_max\":\"\",\"custom_vocab_open\":\"0\",\"value_suggest_keep_original_label\":\"\",\"value_suggest_require_uri\":\"\"}'),
(20, 8, 56, '{\"input_control\":\"\",\"default_value\":\"\",\"automatic_value\":\"\",\"split_separator\":\"\",\"resource_query\":\"\",\"placeholder_value\":\"\",\"card_separator\":\"\",\"settings\":\"\",\"o:alternate_label\":\"\",\"o:alternate_comment\":\"\",\"is-title-property\":\"0\",\"is-description-property\":\"0\",\"o:is_required\":\"0\",\"o:is_private\":\"0\",\"o:default_lang\":\"\",\"o:data_type\":[\"wikidata:reconciliation:persons\"],\"min_values\":\"\",\"max_values\":\"\",\"min_length\":\"\",\"max_length\":\"\",\"unique_value\":\"0\",\"automatic_value_issued\":\"\",\"locked_value\":\"0\",\"property_read_only\":\"0\",\"quick_new_resource\":\"\",\"autocomplete\":\"\",\"value_languages\":[],\"use_language\":\"\",\"order_by_linked_resource_properties\":[],\"value_annotations_template\":\"\",\"display_on_public_site\":\"\",\"card_display\":\"0\",\"card_role\":\"\",\"card_first_only\":\"0\",\"card_max\":\"\",\"custom_vocab_open\":\"0\",\"value_suggest_keep_original_label\":\"\",\"value_suggest_require_uri\":\"\"}'),
(21, 9, 57, '{\"input_control\":\"\",\"default_value\":\"\",\"automatic_value\":\"\",\"split_separator\":\"\",\"resource_query\":\"\",\"placeholder_value\":\"\",\"card_separator\":\"\",\"settings\":\"\",\"o:alternate_label\":\"\",\"o:alternate_comment\":\"\",\"is-title-property\":\"0\",\"is-description-property\":\"0\",\"o:is_required\":\"0\",\"o:is_private\":\"0\",\"o:default_lang\":\"\",\"o:data_type\":[],\"min_values\":\"\",\"max_values\":\"\",\"min_length\":\"\",\"max_length\":\"\",\"unique_value\":\"0\",\"automatic_value_issued\":\"\",\"locked_value\":\"0\",\"property_read_only\":\"0\",\"quick_new_resource\":\"\",\"autocomplete\":\"\",\"value_languages\":[],\"use_language\":\"\",\"order_by_linked_resource_properties\":[],\"value_annotations_template\":\"\",\"display_on_public_site\":\"\",\"card_display\":\"0\",\"card_role\":\"\",\"card_first_only\":\"0\",\"card_max\":\"\",\"custom_vocab_open\":\"0\",\"value_suggest_keep_original_label\":\"\",\"value_suggest_require_uri\":\"\"}'),
(22, 9, 58, '{\"input_control\":\"\",\"default_value\":\"\",\"automatic_value\":\"\",\"split_separator\":\"\",\"resource_query\":\"\",\"placeholder_value\":\"\",\"card_separator\":\"\",\"settings\":\"\",\"o:alternate_label\":\"\",\"o:alternate_comment\":\"\",\"is-title-property\":\"0\",\"is-description-property\":\"0\",\"o:is_required\":\"0\",\"o:is_private\":\"0\",\"o:default_lang\":\"\",\"o:data_type\":[],\"min_values\":\"\",\"max_values\":\"\",\"min_length\":\"\",\"max_length\":\"\",\"unique_value\":\"0\",\"automatic_value_issued\":\"\",\"locked_value\":\"0\",\"property_read_only\":\"0\",\"quick_new_resource\":\"\",\"autocomplete\":\"\",\"value_languages\":[],\"use_language\":\"\",\"order_by_linked_resource_properties\":[],\"value_annotations_template\":\"\",\"display_on_public_site\":\"\",\"card_display\":\"0\",\"card_role\":\"\",\"card_first_only\":\"0\",\"card_max\":\"\",\"custom_vocab_open\":\"0\",\"value_suggest_keep_original_label\":\"\",\"value_suggest_require_uri\":\"\"}'),
(23, 9, 59, '{\"input_control\":\"\",\"default_value\":\"\",\"automatic_value\":\"\",\"split_separator\":\"\",\"resource_query\":\"\",\"placeholder_value\":\"\",\"card_separator\":\"\",\"settings\":\"\",\"o:alternate_label\":\"\",\"o:alternate_comment\":\"\",\"is-title-property\":\"0\",\"is-description-property\":\"0\",\"o:is_required\":\"0\",\"o:is_private\":\"0\",\"o:default_lang\":\"\",\"o:data_type\":[],\"min_values\":\"\",\"max_values\":\"\",\"min_length\":\"\",\"max_length\":\"\",\"unique_value\":\"0\",\"automatic_value_issued\":\"\",\"locked_value\":\"0\",\"property_read_only\":\"0\",\"quick_new_resource\":\"\",\"autocomplete\":\"\",\"value_languages\":[],\"use_language\":\"\",\"order_by_linked_resource_properties\":[],\"value_annotations_template\":\"\",\"display_on_public_site\":\"\",\"card_display\":\"0\",\"card_role\":\"\",\"card_first_only\":\"0\",\"card_max\":\"\",\"custom_vocab_open\":\"0\",\"value_suggest_keep_original_label\":\"\",\"value_suggest_require_uri\":\"\"}'),
(24, 4, 30, '{\"input_control\":\"\",\"default_value\":\"\",\"automatic_value\":\"\",\"split_separator\":\"\",\"resource_query\":\"\",\"placeholder_value\":\"\",\"card_separator\":\"\",\"settings\":\"\",\"o:alternate_label\":\"\",\"o:alternate_comment\":\"\",\"is-title-property\":\"0\",\"is-description-property\":\"0\",\"o:is_required\":\"0\",\"o:is_private\":\"0\",\"o:default_lang\":\"\",\"o:data_type\":[],\"min_values\":\"\",\"max_values\":\"\",\"min_length\":\"\",\"max_length\":\"\",\"unique_value\":\"0\",\"automatic_value_issued\":\"\",\"locked_value\":\"0\",\"property_read_only\":\"0\",\"quick_new_resource\":\"\",\"autocomplete\":\"\",\"value_languages\":[],\"use_language\":\"\",\"order_by_linked_resource_properties\":[],\"value_annotations_template\":\"\",\"display_on_public_site\":\"\",\"card_display\":\"0\",\"card_role\":\"\",\"card_first_only\":\"0\",\"card_max\":\"\",\"custom_vocab_open\":\"0\",\"value_suggest_keep_original_label\":\"\",\"value_suggest_require_uri\":\"\"}'),
(25, 4, 31, '{\"input_control\":\"\",\"default_value\":\"\",\"automatic_value\":\"\",\"split_separator\":\"\",\"resource_query\":\"\",\"placeholder_value\":\"\",\"card_separator\":\"\",\"settings\":\"\",\"o:alternate_label\":\"\",\"o:alternate_comment\":\"\",\"is-title-property\":\"0\",\"is-description-property\":\"0\",\"o:is_required\":\"0\",\"o:is_private\":\"0\",\"o:default_lang\":\"\",\"o:data_type\":[],\"min_values\":\"\",\"max_values\":\"\",\"min_length\":\"\",\"max_length\":\"\",\"unique_value\":\"0\",\"automatic_value_issued\":\"\",\"locked_value\":\"0\",\"property_read_only\":\"0\",\"quick_new_resource\":\"\",\"autocomplete\":\"\",\"value_languages\":[],\"use_language\":\"\",\"order_by_linked_resource_properties\":[],\"value_annotations_template\":\"\",\"display_on_public_site\":\"\",\"card_display\":\"0\",\"card_role\":\"\",\"card_first_only\":\"0\",\"card_max\":\"\",\"custom_vocab_open\":\"0\",\"value_suggest_keep_original_label\":\"\",\"value_suggest_require_uri\":\"\"}'),
(26, 4, 32, '{\"input_control\":\"\",\"default_value\":\"\",\"automatic_value\":\"\",\"split_separator\":\"\",\"resource_query\":\"\",\"placeholder_value\":\"\",\"card_separator\":\"\",\"settings\":\"\",\"o:alternate_label\":\"\",\"o:alternate_comment\":\"\",\"is-title-property\":\"0\",\"is-description-property\":\"0\",\"o:is_required\":\"0\",\"o:is_private\":\"0\",\"o:default_lang\":\"\",\"o:data_type\":[],\"min_values\":\"\",\"max_values\":\"\",\"min_length\":\"\",\"max_length\":\"\",\"unique_value\":\"0\",\"automatic_value_issued\":\"\",\"locked_value\":\"0\",\"property_read_only\":\"0\",\"quick_new_resource\":\"\",\"autocomplete\":\"\",\"value_languages\":[],\"use_language\":\"\",\"order_by_linked_resource_properties\":[],\"value_annotations_template\":\"\",\"display_on_public_site\":\"\",\"card_display\":\"0\",\"card_role\":\"\",\"card_first_only\":\"0\",\"card_max\":\"\",\"custom_vocab_open\":\"0\",\"value_suggest_keep_original_label\":\"\",\"value_suggest_require_uri\":\"\"}'),
(27, 4, 33, '{\"input_control\":\"\",\"default_value\":\"\",\"automatic_value\":\"\",\"split_separator\":\"\",\"resource_query\":\"\",\"placeholder_value\":\"\",\"card_separator\":\"\",\"settings\":\"\",\"o:alternate_label\":\"\",\"o:alternate_comment\":\"\",\"is-title-property\":\"0\",\"is-description-property\":\"0\",\"o:is_required\":\"0\",\"o:is_private\":\"0\",\"o:default_lang\":\"\",\"o:data_type\":[\"customvocab:5\"],\"min_values\":\"\",\"max_values\":\"\",\"min_length\":\"\",\"max_length\":\"\",\"unique_value\":\"0\",\"automatic_value_issued\":\"\",\"locked_value\":\"0\",\"property_read_only\":\"0\",\"quick_new_resource\":\"\",\"autocomplete\":\"\",\"value_languages\":[],\"use_language\":\"\",\"order_by_linked_resource_properties\":[],\"value_annotations_template\":\"\",\"display_on_public_site\":\"\",\"card_display\":\"0\",\"card_role\":\"\",\"card_first_only\":\"0\",\"card_max\":\"\",\"custom_vocab_open\":\"0\",\"value_suggest_keep_original_label\":\"\",\"value_suggest_require_uri\":\"\"}'),
(28, 4, 34, '{\"input_control\":\"\",\"default_value\":\"\",\"automatic_value\":\"\",\"split_separator\":\"\",\"resource_query\":\"\",\"placeholder_value\":\"\",\"card_separator\":\"\",\"settings\":\"\",\"o:alternate_label\":\"\",\"o:alternate_comment\":\"\",\"is-title-property\":\"0\",\"is-description-property\":\"0\",\"o:is_required\":\"0\",\"o:is_private\":\"0\",\"o:default_lang\":\"\",\"o:data_type\":[\"customvocab:2\"],\"min_values\":\"\",\"max_values\":\"\",\"min_length\":\"\",\"max_length\":\"\",\"unique_value\":\"0\",\"automatic_value_issued\":\"\",\"locked_value\":\"0\",\"property_read_only\":\"0\",\"quick_new_resource\":\"\",\"autocomplete\":\"\",\"value_languages\":[],\"use_language\":\"\",\"order_by_linked_resource_properties\":[],\"value_annotations_template\":\"\",\"display_on_public_site\":\"\",\"card_display\":\"0\",\"card_role\":\"\",\"card_first_only\":\"0\",\"card_max\":\"\",\"custom_vocab_open\":\"0\",\"value_suggest_keep_original_label\":\"\",\"value_suggest_require_uri\":\"\"}'),
(29, 6, 37, '{\"input_control\":\"\",\"default_value\":\"\",\"automatic_value\":\"\",\"split_separator\":\"\",\"resource_query\":\"\",\"placeholder_value\":\"\",\"card_separator\":\"\",\"settings\":\"\",\"o:alternate_label\":\"\",\"o:alternate_comment\":\"\",\"is-title-property\":\"0\",\"is-description-property\":\"0\",\"o:is_required\":\"0\",\"o:is_private\":\"0\",\"o:default_lang\":\"\",\"o:data_type\":[],\"min_values\":\"\",\"max_values\":\"\",\"min_length\":\"\",\"max_length\":\"\",\"unique_value\":\"0\",\"automatic_value_issued\":\"\",\"locked_value\":\"0\",\"property_read_only\":\"0\",\"quick_new_resource\":\"\",\"autocomplete\":\"\",\"value_languages\":[],\"use_language\":\"\",\"order_by_linked_resource_properties\":[],\"value_annotations_template\":\"\",\"display_on_public_site\":\"\",\"card_display\":\"0\",\"card_role\":\"\",\"card_first_only\":\"0\",\"card_max\":\"\",\"custom_vocab_open\":\"0\",\"value_suggest_keep_original_label\":\"\",\"value_suggest_require_uri\":\"\"}'),
(30, 6, 38, '{\"input_control\":\"\",\"default_value\":\"\",\"automatic_value\":\"\",\"split_separator\":\"\",\"resource_query\":\"\",\"placeholder_value\":\"\",\"card_separator\":\"\",\"settings\":\"\",\"o:alternate_label\":\"\",\"o:alternate_comment\":\"\",\"is-title-property\":\"0\",\"is-description-property\":\"0\",\"o:is_required\":\"0\",\"o:is_private\":\"0\",\"o:default_lang\":\"\",\"o:data_type\":[],\"min_values\":\"\",\"max_values\":\"\",\"min_length\":\"\",\"max_length\":\"\",\"unique_value\":\"0\",\"automatic_value_issued\":\"\",\"locked_value\":\"0\",\"property_read_only\":\"0\",\"quick_new_resource\":\"\",\"autocomplete\":\"\",\"value_languages\":[],\"use_language\":\"\",\"order_by_linked_resource_properties\":[],\"value_annotations_template\":\"\",\"display_on_public_site\":\"\",\"card_display\":\"0\",\"card_role\":\"\",\"card_first_only\":\"0\",\"card_max\":\"\",\"custom_vocab_open\":\"0\",\"value_suggest_keep_original_label\":\"\",\"value_suggest_require_uri\":\"\"}'),
(31, 6, 39, '{\"input_control\":\"\",\"default_value\":\"\",\"automatic_value\":\"\",\"split_separator\":\"\",\"resource_query\":\"\",\"placeholder_value\":\"\",\"card_separator\":\"\",\"settings\":\"\",\"o:alternate_label\":\"\",\"o:alternate_comment\":\"\",\"is-title-property\":\"0\",\"is-description-property\":\"0\",\"o:is_required\":\"0\",\"o:is_private\":\"0\",\"o:default_lang\":\"\",\"o:data_type\":[],\"min_values\":\"\",\"max_values\":\"\",\"min_length\":\"\",\"max_length\":\"\",\"unique_value\":\"0\",\"automatic_value_issued\":\"\",\"locked_value\":\"0\",\"property_read_only\":\"0\",\"quick_new_resource\":\"\",\"autocomplete\":\"\",\"value_languages\":[],\"use_language\":\"\",\"order_by_linked_resource_properties\":[],\"value_annotations_template\":\"\",\"display_on_public_site\":\"\",\"card_display\":\"0\",\"card_role\":\"\",\"card_first_only\":\"0\",\"card_max\":\"\",\"custom_vocab_open\":\"0\",\"value_suggest_keep_original_label\":\"\",\"value_suggest_require_uri\":\"\"}'),
(32, 6, 40, '{\"input_control\":\"\",\"default_value\":\"\",\"automatic_value\":\"\",\"split_separator\":\"\",\"resource_query\":\"\",\"placeholder_value\":\"\",\"card_separator\":\"\",\"settings\":\"\",\"o:alternate_label\":\"\",\"o:alternate_comment\":\"\",\"is-title-property\":\"0\",\"is-description-property\":\"0\",\"o:is_required\":\"0\",\"o:is_private\":\"0\",\"o:default_lang\":\"\",\"o:data_type\":[],\"min_values\":\"\",\"max_values\":\"\",\"min_length\":\"\",\"max_length\":\"\",\"unique_value\":\"0\",\"automatic_value_issued\":\"\",\"locked_value\":\"0\",\"property_read_only\":\"0\",\"quick_new_resource\":\"\",\"autocomplete\":\"\",\"value_languages\":[],\"use_language\":\"\",\"order_by_linked_resource_properties\":[],\"value_annotations_template\":\"\",\"display_on_public_site\":\"\",\"card_display\":\"0\",\"card_role\":\"\",\"card_first_only\":\"0\",\"card_max\":\"\",\"custom_vocab_open\":\"0\",\"value_suggest_keep_original_label\":\"\",\"value_suggest_require_uri\":\"\"}'),
(33, 6, 41, '{\"input_control\":\"\",\"default_value\":\"\",\"automatic_value\":\"\",\"split_separator\":\"\",\"resource_query\":\"\",\"placeholder_value\":\"\",\"card_separator\":\"\",\"settings\":\"\",\"o:alternate_label\":\"\",\"o:alternate_comment\":\"\",\"is-title-property\":\"0\",\"is-description-property\":\"0\",\"o:is_required\":\"0\",\"o:is_private\":\"0\",\"o:default_lang\":\"\",\"o:data_type\":[],\"min_values\":\"\",\"max_values\":\"\",\"min_length\":\"\",\"max_length\":\"\",\"unique_value\":\"0\",\"automatic_value_issued\":\"\",\"locked_value\":\"0\",\"property_read_only\":\"0\",\"quick_new_resource\":\"\",\"autocomplete\":\"\",\"value_languages\":[],\"use_language\":\"\",\"order_by_linked_resource_properties\":[],\"value_annotations_template\":\"\",\"display_on_public_site\":\"\",\"card_display\":\"0\",\"card_role\":\"\",\"card_first_only\":\"0\",\"card_max\":\"\",\"custom_vocab_open\":\"0\",\"value_suggest_keep_original_label\":\"\",\"value_suggest_require_uri\":\"\"}'),
(34, 6, 42, '{\"input_control\":\"\",\"default_value\":\"\",\"automatic_value\":\"\",\"split_separator\":\"\",\"resource_query\":\"\",\"placeholder_value\":\"\",\"card_separator\":\"\",\"settings\":\"\",\"o:alternate_label\":\"\",\"o:alternate_comment\":\"\",\"is-title-property\":\"0\",\"is-description-property\":\"0\",\"o:is_required\":\"0\",\"o:is_private\":\"0\",\"o:default_lang\":\"\",\"o:data_type\":[\"customvocab:4\"],\"min_values\":\"\",\"max_values\":\"\",\"min_length\":\"\",\"max_length\":\"\",\"unique_value\":\"0\",\"automatic_value_issued\":\"\",\"locked_value\":\"0\",\"property_read_only\":\"0\",\"quick_new_resource\":\"\",\"autocomplete\":\"\",\"value_languages\":[],\"use_language\":\"\",\"order_by_linked_resource_properties\":[],\"value_annotations_template\":\"\",\"display_on_public_site\":\"\",\"card_display\":\"0\",\"card_role\":\"\",\"card_first_only\":\"0\",\"card_max\":\"\",\"custom_vocab_open\":\"0\",\"value_suggest_keep_original_label\":\"\",\"value_suggest_require_uri\":\"\"}'),
(35, 5, 35, '{\"input_control\":\"\",\"default_value\":\"\",\"automatic_value\":\"\",\"split_separator\":\"\",\"resource_query\":\"\",\"placeholder_value\":\"\",\"card_separator\":\"\",\"settings\":\"\",\"o:alternate_label\":\"\",\"o:alternate_comment\":\"\",\"is-title-property\":\"0\",\"is-description-property\":\"0\",\"o:is_required\":\"0\",\"o:is_private\":\"0\",\"o:default_lang\":\"\",\"o:data_type\":[],\"min_values\":\"\",\"max_values\":\"\",\"min_length\":\"\",\"max_length\":\"\",\"unique_value\":\"0\",\"automatic_value_issued\":\"\",\"locked_value\":\"0\",\"property_read_only\":\"0\",\"quick_new_resource\":\"\",\"autocomplete\":\"\",\"value_languages\":[],\"use_language\":\"\",\"order_by_linked_resource_properties\":[],\"value_annotations_template\":\"\",\"display_on_public_site\":\"\",\"card_display\":\"0\",\"card_role\":\"\",\"card_first_only\":\"0\",\"card_max\":\"\",\"custom_vocab_open\":\"0\",\"value_suggest_keep_original_label\":\"\",\"value_suggest_require_uri\":\"\"}'),
(36, 5, 36, '{\"input_control\":\"\",\"default_value\":\"\",\"automatic_value\":\"\",\"split_separator\":\"\",\"resource_query\":\"\",\"placeholder_value\":\"\",\"card_separator\":\"\",\"settings\":\"\",\"o:alternate_label\":\"\",\"o:alternate_comment\":\"\",\"is-title-property\":\"0\",\"is-description-property\":\"0\",\"o:is_required\":\"0\",\"o:is_private\":\"0\",\"o:default_lang\":\"\",\"o:data_type\":[],\"min_values\":\"\",\"max_values\":\"\",\"min_length\":\"\",\"max_length\":\"\",\"unique_value\":\"0\",\"automatic_value_issued\":\"\",\"locked_value\":\"0\",\"property_read_only\":\"0\",\"quick_new_resource\":\"\",\"autocomplete\":\"\",\"value_languages\":[],\"use_language\":\"\",\"order_by_linked_resource_properties\":[],\"value_annotations_template\":\"\",\"display_on_public_site\":\"\",\"card_display\":\"0\",\"card_role\":\"\",\"card_first_only\":\"0\",\"card_max\":\"\",\"custom_vocab_open\":\"0\",\"value_suggest_keep_original_label\":\"\",\"value_suggest_require_uri\":\"\"}'),
(37, 3, 27, '{\"input_control\":\"\",\"default_value\":\"\",\"automatic_value\":\"\",\"split_separator\":\"\",\"resource_query\":\"\",\"placeholder_value\":\"\",\"card_separator\":\"\",\"settings\":\"\",\"o:alternate_label\":\"\",\"o:alternate_comment\":\"\",\"is-title-property\":\"0\",\"is-description-property\":\"0\",\"o:is_required\":\"0\",\"o:is_private\":\"0\",\"o:default_lang\":\"\",\"o:data_type\":[],\"min_values\":\"\",\"max_values\":\"\",\"min_length\":\"\",\"max_length\":\"\",\"unique_value\":\"0\",\"automatic_value_issued\":\"\",\"locked_value\":\"0\",\"property_read_only\":\"0\",\"quick_new_resource\":\"\",\"autocomplete\":\"\",\"value_languages\":[],\"use_language\":\"\",\"order_by_linked_resource_properties\":[],\"value_annotations_template\":\"\",\"display_on_public_site\":\"\",\"card_display\":\"0\",\"card_role\":\"\",\"card_first_only\":\"0\",\"card_max\":\"\",\"custom_vocab_open\":\"0\",\"value_suggest_keep_original_label\":\"\",\"value_suggest_require_uri\":\"\"}'),
(38, 3, 28, '{\"input_control\":\"\",\"default_value\":\"\",\"automatic_value\":\"\",\"split_separator\":\"\",\"resource_query\":\"\",\"placeholder_value\":\"\",\"card_separator\":\"\",\"settings\":\"\",\"o:alternate_label\":\"\",\"o:alternate_comment\":\"\",\"is-title-property\":\"0\",\"is-description-property\":\"0\",\"o:is_required\":\"0\",\"o:is_private\":\"0\",\"o:default_lang\":\"\",\"o:data_type\":[],\"min_values\":\"\",\"max_values\":\"\",\"min_length\":\"\",\"max_length\":\"\",\"unique_value\":\"0\",\"automatic_value_issued\":\"\",\"locked_value\":\"0\",\"property_read_only\":\"0\",\"quick_new_resource\":\"\",\"autocomplete\":\"\",\"value_languages\":[],\"use_language\":\"\",\"order_by_linked_resource_properties\":[],\"value_annotations_template\":\"\",\"display_on_public_site\":\"\",\"card_display\":\"0\",\"card_role\":\"\",\"card_first_only\":\"0\",\"card_max\":\"\",\"custom_vocab_open\":\"0\",\"value_suggest_keep_original_label\":\"\",\"value_suggest_require_uri\":\"\"}'),
(39, 3, 29, '{\"input_control\":\"\",\"default_value\":\"\",\"automatic_value\":\"\",\"split_separator\":\"\",\"resource_query\":\"\",\"placeholder_value\":\"\",\"card_separator\":\"\",\"settings\":\"\",\"o:alternate_label\":\"\",\"o:alternate_comment\":\"\",\"is-title-property\":\"0\",\"is-description-property\":\"0\",\"o:is_required\":\"0\",\"o:is_private\":\"0\",\"o:default_lang\":\"\",\"o:data_type\":[\"customvocab:6\"],\"min_values\":\"\",\"max_values\":\"\",\"min_length\":\"\",\"max_length\":\"\",\"unique_value\":\"0\",\"automatic_value_issued\":\"\",\"locked_value\":\"0\",\"property_read_only\":\"0\",\"quick_new_resource\":\"\",\"autocomplete\":\"\",\"value_languages\":[],\"use_language\":\"\",\"order_by_linked_resource_properties\":[],\"value_annotations_template\":\"\",\"display_on_public_site\":\"\",\"card_display\":\"0\",\"card_role\":\"\",\"card_first_only\":\"0\",\"card_max\":\"\",\"custom_vocab_open\":\"0\",\"value_suggest_keep_original_label\":\"\",\"value_suggest_require_uri\":\"\"}'),
(40, 10, 60, '{\"input_control\":\"\",\"default_value\":\"\",\"automatic_value\":\"\",\"split_separator\":\"\",\"resource_query\":\"\",\"placeholder_value\":\"\",\"card_separator\":\"\",\"settings\":\"\",\"o:alternate_label\":\"\",\"o:alternate_comment\":\"\",\"is-title-property\":\"0\",\"is-description-property\":\"0\",\"o:is_required\":\"0\",\"o:is_private\":\"0\",\"o:default_lang\":\"\",\"o:data_type\":[],\"min_values\":\"\",\"max_values\":\"\",\"min_length\":\"\",\"max_length\":\"\",\"unique_value\":\"0\",\"automatic_value_issued\":\"\",\"locked_value\":\"0\",\"property_read_only\":\"0\",\"quick_new_resource\":\"\",\"autocomplete\":\"\",\"value_languages\":[],\"use_language\":\"\",\"order_by_linked_resource_properties\":[],\"value_annotations_template\":\"\",\"display_on_public_site\":\"\",\"card_display\":\"0\",\"card_role\":\"\",\"card_first_only\":\"0\",\"card_max\":\"\",\"custom_vocab_open\":\"0\",\"value_suggest_keep_original_label\":\"\",\"value_suggest_require_uri\":\"\"}'),
(41, 10, 61, '{\"input_control\":\"\",\"default_value\":\"\",\"automatic_value\":\"\",\"split_separator\":\"\",\"resource_query\":\"\",\"placeholder_value\":\"\",\"card_separator\":\"\",\"settings\":\"\",\"o:alternate_label\":\"\",\"o:alternate_comment\":\"\",\"is-title-property\":\"0\",\"is-description-property\":\"0\",\"o:is_required\":\"0\",\"o:is_private\":\"0\",\"o:default_lang\":\"\",\"o:data_type\":[],\"min_values\":\"\",\"max_values\":\"\",\"min_length\":\"\",\"max_length\":\"\",\"unique_value\":\"0\",\"automatic_value_issued\":\"\",\"locked_value\":\"0\",\"property_read_only\":\"0\",\"quick_new_resource\":\"\",\"autocomplete\":\"\",\"value_languages\":[],\"use_language\":\"\",\"order_by_linked_resource_properties\":[],\"value_annotations_template\":\"\",\"display_on_public_site\":\"\",\"card_display\":\"0\",\"card_role\":\"\",\"card_first_only\":\"0\",\"card_max\":\"\",\"custom_vocab_open\":\"0\",\"value_suggest_keep_original_label\":\"\",\"value_suggest_require_uri\":\"\"}'),
(42, 10, 62, '{\"input_control\":\"\",\"default_value\":\"\",\"automatic_value\":\"\",\"split_separator\":\"\",\"resource_query\":\"\",\"placeholder_value\":\"\",\"card_separator\":\"\",\"settings\":\"\",\"o:alternate_label\":\"\",\"o:alternate_comment\":\"\",\"is-title-property\":\"0\",\"is-description-property\":\"0\",\"o:is_required\":\"0\",\"o:is_private\":\"0\",\"o:default_lang\":\"\",\"o:data_type\":[\"resource:item\",\"customvocab:10\"],\"min_values\":\"\",\"max_values\":\"\",\"min_length\":\"\",\"max_length\":\"\",\"unique_value\":\"0\",\"automatic_value_issued\":\"\",\"locked_value\":\"0\",\"property_read_only\":\"0\",\"quick_new_resource\":\"\",\"autocomplete\":\"\",\"value_languages\":[],\"use_language\":\"\",\"order_by_linked_resource_properties\":[],\"value_annotations_template\":\"11\",\"display_on_public_site\":\"\",\"card_display\":\"0\",\"card_role\":\"\",\"card_first_only\":\"0\",\"card_max\":\"\",\"custom_vocab_open\":\"0\",\"value_suggest_keep_original_label\":\"\",\"value_suggest_require_uri\":\"\"}'),
(43, 11, 63, '{\"input_control\":\"\",\"default_value\":\"\",\"automatic_value\":\"\",\"split_separator\":\"\",\"resource_query\":\"\",\"placeholder_value\":\"\",\"card_separator\":\"\",\"settings\":\"\",\"o:alternate_label\":\"\",\"o:alternate_comment\":\"\",\"is-title-property\":\"0\",\"is-description-property\":\"0\",\"o:is_required\":\"0\",\"o:is_private\":\"0\",\"o:default_lang\":\"\",\"o:data_type\":[\"customvocab:12\"],\"min_values\":\"\",\"max_values\":\"\",\"min_length\":\"\",\"max_length\":\"\",\"unique_value\":\"0\",\"automatic_value_issued\":\"\",\"locked_value\":\"0\",\"property_read_only\":\"0\",\"quick_new_resource\":\"\",\"autocomplete\":\"\",\"value_languages\":[],\"use_language\":\"\",\"order_by_linked_resource_properties\":[],\"value_annotations_template\":\"\",\"display_on_public_site\":\"\",\"card_display\":\"0\",\"card_role\":\"\",\"card_first_only\":\"0\",\"card_max\":\"\",\"custom_vocab_open\":\"0\",\"value_suggest_keep_original_label\":\"\",\"value_suggest_require_uri\":\"\"}'),
(44, 11, 64, '{\"input_control\":\"\",\"default_value\":\"\",\"automatic_value\":\"\",\"split_separator\":\"\",\"resource_query\":\"\",\"placeholder_value\":\"\",\"card_separator\":\"\",\"settings\":\"\",\"o:alternate_label\":\"\",\"o:alternate_comment\":\"\",\"is-title-property\":\"0\",\"is-description-property\":\"0\",\"o:is_required\":\"0\",\"o:is_private\":\"0\",\"o:default_lang\":\"\",\"o:data_type\":[\"numeric:integer\"],\"min_values\":\"\",\"max_values\":\"\",\"min_length\":\"\",\"max_length\":\"\",\"unique_value\":\"0\",\"automatic_value_issued\":\"\",\"locked_value\":\"0\",\"property_read_only\":\"0\",\"quick_new_resource\":\"\",\"autocomplete\":\"\",\"value_languages\":[],\"use_language\":\"\",\"order_by_linked_resource_properties\":[],\"value_annotations_template\":\"\",\"display_on_public_site\":\"\",\"card_display\":\"0\",\"card_role\":\"\",\"card_first_only\":\"0\",\"card_max\":\"\",\"custom_vocab_open\":\"0\",\"value_suggest_keep_original_label\":\"\",\"value_suggest_require_uri\":\"\"}'),
(45, 12, 65, '{\"input_control\":\"\",\"default_value\":\"\",\"automatic_value\":\"\",\"split_separator\":\"\",\"resource_query\":\"\",\"placeholder_value\":\"\",\"card_separator\":\"\",\"settings\":\"\",\"o:alternate_label\":\"\",\"o:alternate_comment\":\"\",\"is-title-property\":\"0\",\"is-description-property\":\"0\",\"o:is_required\":\"0\",\"o:is_private\":\"0\",\"o:default_lang\":\"\",\"o:data_type\":[],\"min_values\":\"\",\"max_values\":\"\",\"min_length\":\"\",\"max_length\":\"\",\"unique_value\":\"0\",\"automatic_value_issued\":\"\",\"locked_value\":\"0\",\"property_read_only\":\"0\",\"quick_new_resource\":\"\",\"autocomplete\":\"\",\"value_languages\":[],\"use_language\":\"\",\"order_by_linked_resource_properties\":[],\"value_annotations_template\":\"\",\"display_on_public_site\":\"\",\"card_display\":\"0\",\"card_role\":\"\",\"card_first_only\":\"0\",\"card_max\":\"\",\"custom_vocab_open\":\"0\",\"value_suggest_keep_original_label\":\"\",\"value_suggest_require_uri\":\"\"}'),
(46, 12, 66, '{\"input_control\":\"\",\"default_value\":\"\",\"automatic_value\":\"\",\"split_separator\":\"\",\"resource_query\":\"\",\"placeholder_value\":\"\",\"card_separator\":\"\",\"settings\":\"\",\"o:alternate_label\":\"\",\"o:alternate_comment\":\"\",\"is-title-property\":\"0\",\"is-description-property\":\"0\",\"o:is_required\":\"0\",\"o:is_private\":\"0\",\"o:default_lang\":\"\",\"o:data_type\":[],\"min_values\":\"\",\"max_values\":\"\",\"min_length\":\"\",\"max_length\":\"\",\"unique_value\":\"0\",\"automatic_value_issued\":\"\",\"locked_value\":\"0\",\"property_read_only\":\"0\",\"quick_new_resource\":\"\",\"autocomplete\":\"\",\"value_languages\":[],\"use_language\":\"\",\"order_by_linked_resource_properties\":[],\"value_annotations_template\":\"\",\"display_on_public_site\":\"\",\"card_display\":\"0\",\"card_role\":\"\",\"card_first_only\":\"0\",\"card_max\":\"\",\"custom_vocab_open\":\"0\",\"value_suggest_keep_original_label\":\"\",\"value_suggest_require_uri\":\"\"}'),
(47, 12, 67, '{\"input_control\":\"\",\"default_value\":\"\",\"automatic_value\":\"\",\"split_separator\":\"\",\"resource_query\":\"\",\"placeholder_value\":\"\",\"card_separator\":\"\",\"settings\":\"\",\"o:alternate_label\":\"\",\"o:alternate_comment\":\"\",\"is-title-property\":\"0\",\"is-description-property\":\"0\",\"o:is_required\":\"0\",\"o:is_private\":\"0\",\"o:default_lang\":\"\",\"o:data_type\":[\"resource:item\",\"customvocab:8\"],\"min_values\":\"\",\"max_values\":\"\",\"min_length\":\"\",\"max_length\":\"\",\"unique_value\":\"0\",\"automatic_value_issued\":\"\",\"locked_value\":\"0\",\"property_read_only\":\"0\",\"quick_new_resource\":\"\",\"autocomplete\":\"\",\"value_languages\":[],\"use_language\":\"\",\"order_by_linked_resource_properties\":[],\"value_annotations_template\":\"11\",\"display_on_public_site\":\"\",\"card_display\":\"0\",\"card_role\":\"\",\"card_first_only\":\"0\",\"card_max\":\"\",\"custom_vocab_open\":\"0\",\"value_suggest_keep_original_label\":\"\",\"value_suggest_require_uri\":\"\"}'),
(48, 12, 68, '{\"input_control\":\"\",\"default_value\":\"\",\"automatic_value\":\"\",\"split_separator\":\"\",\"resource_query\":\"\",\"placeholder_value\":\"\",\"card_separator\":\"\",\"settings\":\"\",\"o:alternate_label\":\"\",\"o:alternate_comment\":\"\",\"is-title-property\":\"0\",\"is-description-property\":\"0\",\"o:is_required\":\"0\",\"o:is_private\":\"0\",\"o:default_lang\":\"\",\"o:data_type\":[\"resource:item\",\"customvocab:10\"],\"min_values\":\"\",\"max_values\":\"\",\"min_length\":\"\",\"max_length\":\"\",\"unique_value\":\"0\",\"automatic_value_issued\":\"\",\"locked_value\":\"0\",\"property_read_only\":\"0\",\"quick_new_resource\":\"\",\"autocomplete\":\"\",\"value_languages\":[],\"use_language\":\"\",\"order_by_linked_resource_properties\":[],\"value_annotations_template\":\"11\",\"display_on_public_site\":\"\",\"card_display\":\"0\",\"card_role\":\"\",\"card_first_only\":\"0\",\"card_max\":\"\",\"custom_vocab_open\":\"0\",\"value_suggest_keep_original_label\":\"\",\"value_suggest_require_uri\":\"\"}'),
(49, 13, 69, '{\"o:data_type\":[\"customvocab:1\"]}'),
(50, 13, 70, '{\"o:data_type\":[\"literal\"]}'),
(51, 13, 71, '{\"o:data_type\":[\"customvocab:1\"]}'),
(52, 13, 72, '{\"o:data_type\":[\"literal\"]}'),
(53, 13, 73, '{\"o:data_type\":[\"resource\"]}'),
(54, 13, 74, '{\"o:data_type\":[\"customvocab:5\"]}'),
(55, 14, 75, '{\"input_control\":\"\",\"default_value\":\"\",\"automatic_value\":\"\",\"split_separator\":\"\",\"resource_query\":\"\",\"placeholder_value\":\"\",\"card_separator\":\"\",\"settings\":\"\",\"o:alternate_label\":\"\",\"o:alternate_comment\":\"\",\"is-title-property\":\"0\",\"is-description-property\":\"0\",\"o:is_required\":\"0\",\"o:is_private\":\"0\",\"o:default_lang\":\"\",\"o:data_type\":[],\"min_values\":\"\",\"max_values\":\"\",\"min_length\":\"\",\"max_length\":\"\",\"unique_value\":\"0\",\"automatic_value_issued\":\"\",\"locked_value\":\"0\",\"property_read_only\":\"0\",\"quick_new_resource\":\"\",\"autocomplete\":\"\",\"value_languages\":[],\"use_language\":\"\",\"order_by_linked_resource_properties\":[],\"value_annotations_template\":\"\",\"display_on_public_site\":\"\",\"card_display\":\"0\",\"card_role\":\"\",\"card_first_only\":\"0\",\"card_max\":\"\",\"custom_vocab_open\":\"0\",\"value_suggest_keep_original_label\":\"\",\"value_suggest_require_uri\":\"\"}');
INSERT INTO `resource_template_property_data` (`id`, `resource_template_id`, `resource_template_property_id`, `data`) VALUES
(56, 14, 76, '{\"input_control\":\"\",\"default_value\":\"\",\"automatic_value\":\"\",\"split_separator\":\"\",\"resource_query\":\"\",\"placeholder_value\":\"\",\"card_separator\":\"\",\"settings\":\"\",\"o:alternate_label\":\"\",\"o:alternate_comment\":\"\",\"is-title-property\":\"0\",\"is-description-property\":\"0\",\"o:is_required\":\"0\",\"o:is_private\":\"0\",\"o:default_lang\":\"\",\"o:data_type\":[],\"min_values\":\"\",\"max_values\":\"\",\"min_length\":\"\",\"max_length\":\"\",\"unique_value\":\"0\",\"automatic_value_issued\":\"\",\"locked_value\":\"0\",\"property_read_only\":\"0\",\"quick_new_resource\":\"\",\"autocomplete\":\"\",\"value_languages\":[],\"use_language\":\"\",\"order_by_linked_resource_properties\":[],\"value_annotations_template\":\"\",\"display_on_public_site\":\"\",\"card_display\":\"0\",\"card_role\":\"\",\"card_first_only\":\"0\",\"card_max\":\"\",\"custom_vocab_open\":\"0\",\"value_suggest_keep_original_label\":\"\",\"value_suggest_require_uri\":\"\"}'),
(57, 4, 77, '{\"input_control\":\"\",\"default_value\":\"\",\"automatic_value\":\"\",\"split_separator\":\"\",\"resource_query\":\"\",\"placeholder_value\":\"\",\"card_separator\":\"\",\"settings\":\"\",\"o:alternate_label\":\"\",\"o:alternate_comment\":\"\",\"is-title-property\":\"0\",\"is-description-property\":\"0\",\"o:is_required\":\"0\",\"o:is_private\":\"0\",\"o:default_lang\":\"\",\"o:data_type\":[\"customvocab:15\"],\"min_values\":\"\",\"max_values\":\"\",\"min_length\":\"\",\"max_length\":\"\",\"unique_value\":\"0\",\"automatic_value_issued\":\"\",\"locked_value\":\"0\",\"property_read_only\":\"0\",\"quick_new_resource\":\"\",\"autocomplete\":\"\",\"value_languages\":[],\"use_language\":\"\",\"order_by_linked_resource_properties\":[],\"value_annotations_template\":\"\",\"display_on_public_site\":\"\",\"card_display\":\"0\",\"card_role\":\"\",\"card_first_only\":\"0\",\"card_max\":\"\",\"custom_vocab_open\":\"0\",\"value_suggest_keep_original_label\":\"\",\"value_suggest_require_uri\":\"\"}'),
(58, 6, 78, '{\"input_control\":\"\",\"default_value\":\"\",\"automatic_value\":\"\",\"split_separator\":\"\",\"resource_query\":\"\",\"placeholder_value\":\"\",\"card_separator\":\"\",\"settings\":\"\",\"o:alternate_label\":\"\",\"o:alternate_comment\":\"\",\"is-title-property\":\"0\",\"is-description-property\":\"0\",\"o:is_required\":\"0\",\"o:is_private\":\"0\",\"o:default_lang\":\"\",\"o:data_type\":[\"customvocab:15\"],\"min_values\":\"\",\"max_values\":\"\",\"min_length\":\"\",\"max_length\":\"\",\"unique_value\":\"0\",\"automatic_value_issued\":\"\",\"locked_value\":\"0\",\"property_read_only\":\"0\",\"quick_new_resource\":\"\",\"autocomplete\":\"\",\"value_languages\":[],\"use_language\":\"\",\"order_by_linked_resource_properties\":[],\"value_annotations_template\":\"\",\"display_on_public_site\":\"\",\"card_display\":\"0\",\"card_role\":\"\",\"card_first_only\":\"0\",\"card_max\":\"\",\"custom_vocab_open\":\"0\",\"value_suggest_keep_original_label\":\"\",\"value_suggest_require_uri\":\"\"}'),
(59, 2, 79, '{\"input_control\":\"\",\"default_value\":\"\",\"automatic_value\":\"\",\"split_separator\":\"\",\"resource_query\":\"\",\"placeholder_value\":\"\",\"card_separator\":\"\",\"settings\":\"\",\"o:alternate_label\":\"\",\"o:alternate_comment\":\"\",\"is-title-property\":\"0\",\"is-description-property\":\"0\",\"o:is_required\":\"0\",\"o:is_private\":\"0\",\"o:default_lang\":\"\",\"o:data_type\":[\"customvocab:15\"],\"min_values\":\"\",\"max_values\":\"\",\"min_length\":\"\",\"max_length\":\"\",\"unique_value\":\"0\",\"automatic_value_issued\":\"\",\"locked_value\":\"0\",\"property_read_only\":\"0\",\"quick_new_resource\":\"\",\"autocomplete\":\"\",\"value_languages\":[],\"use_language\":\"\",\"order_by_linked_resource_properties\":[],\"value_annotations_template\":\"\",\"display_on_public_site\":\"\",\"card_display\":\"0\",\"card_role\":\"\",\"card_first_only\":\"0\",\"card_max\":\"\",\"custom_vocab_open\":\"0\",\"value_suggest_keep_original_label\":\"\",\"value_suggest_require_uri\":\"\"}'),
(60, 8, 80, '{\"input_control\":\"\",\"default_value\":\"\",\"automatic_value\":\"\",\"split_separator\":\"\",\"resource_query\":\"\",\"placeholder_value\":\"\",\"card_separator\":\"\",\"settings\":\"\",\"o:alternate_label\":\"\",\"o:alternate_comment\":\"\",\"is-title-property\":\"0\",\"is-description-property\":\"0\",\"o:is_required\":\"0\",\"o:is_private\":\"0\",\"o:default_lang\":\"\",\"o:data_type\":[],\"min_values\":\"\",\"max_values\":\"\",\"min_length\":\"\",\"max_length\":\"\",\"unique_value\":\"0\",\"automatic_value_issued\":\"\",\"locked_value\":\"0\",\"property_read_only\":\"0\",\"quick_new_resource\":\"\",\"autocomplete\":\"\",\"value_languages\":[],\"use_language\":\"\",\"order_by_linked_resource_properties\":[],\"value_annotations_template\":\"\",\"display_on_public_site\":\"\",\"card_display\":\"0\",\"card_role\":\"\",\"card_first_only\":\"0\",\"card_max\":\"\",\"custom_vocab_open\":\"0\",\"value_suggest_keep_original_label\":\"\",\"value_suggest_require_uri\":\"\"}'),
(61, 3, 81, '{\"input_control\":\"\",\"default_value\":\"\",\"automatic_value\":\"\",\"split_separator\":\"\",\"resource_query\":\"\",\"placeholder_value\":\"\",\"card_separator\":\"\",\"settings\":\"\",\"o:alternate_label\":\"\",\"o:alternate_comment\":\"\",\"is-title-property\":\"0\",\"is-description-property\":\"0\",\"o:is_required\":\"0\",\"o:is_private\":\"0\",\"o:default_lang\":\"\",\"o:data_type\":[\"customvocab:15\"],\"min_values\":\"\",\"max_values\":\"\",\"min_length\":\"\",\"max_length\":\"\",\"unique_value\":\"0\",\"automatic_value_issued\":\"\",\"locked_value\":\"0\",\"property_read_only\":\"0\",\"quick_new_resource\":\"\",\"autocomplete\":\"\",\"value_languages\":[],\"use_language\":\"\",\"order_by_linked_resource_properties\":[],\"value_annotations_template\":\"\",\"display_on_public_site\":\"\",\"card_display\":\"0\",\"card_role\":\"\",\"card_first_only\":\"0\",\"card_max\":\"\",\"custom_vocab_open\":\"0\",\"value_suggest_keep_original_label\":\"\",\"value_suggest_require_uri\":\"\"}'),
(62, 3, 82, '{\"input_control\":\"\",\"default_value\":\"\",\"automatic_value\":\"\",\"split_separator\":\"\",\"resource_query\":\"\",\"placeholder_value\":\"\",\"card_separator\":\"\",\"settings\":\"\",\"o:alternate_label\":\"\",\"o:alternate_comment\":\"\",\"is-title-property\":\"0\",\"is-description-property\":\"0\",\"o:is_required\":\"0\",\"o:is_private\":\"0\",\"o:default_lang\":\"\",\"o:data_type\":[\"numeric:timestamp\"],\"min_values\":\"\",\"max_values\":\"\",\"min_length\":\"\",\"max_length\":\"\",\"unique_value\":\"0\",\"automatic_value_issued\":\"\",\"locked_value\":\"0\",\"property_read_only\":\"0\",\"quick_new_resource\":\"\",\"autocomplete\":\"\",\"value_languages\":[],\"use_language\":\"\",\"order_by_linked_resource_properties\":[],\"value_annotations_template\":\"\",\"display_on_public_site\":\"\",\"card_display\":\"0\",\"card_role\":\"\",\"card_first_only\":\"0\",\"card_max\":\"\",\"custom_vocab_open\":\"0\",\"value_suggest_keep_original_label\":\"\",\"value_suggest_require_uri\":\"\"}'),
(63, 3, 83, '{\"input_control\":\"\",\"default_value\":\"\",\"automatic_value\":\"\",\"split_separator\":\"\",\"resource_query\":\"\",\"placeholder_value\":\"\",\"card_separator\":\"\",\"settings\":\"\",\"o:alternate_label\":\"\",\"o:alternate_comment\":\"\",\"is-title-property\":\"0\",\"is-description-property\":\"0\",\"o:is_required\":\"0\",\"o:is_private\":\"0\",\"o:default_lang\":\"\",\"o:data_type\":[\"numeric:integer\"],\"min_values\":\"\",\"max_values\":\"\",\"min_length\":\"\",\"max_length\":\"\",\"unique_value\":\"0\",\"automatic_value_issued\":\"\",\"locked_value\":\"0\",\"property_read_only\":\"0\",\"quick_new_resource\":\"\",\"autocomplete\":\"\",\"value_languages\":[],\"use_language\":\"\",\"order_by_linked_resource_properties\":[],\"value_annotations_template\":\"\",\"display_on_public_site\":\"\",\"card_display\":\"0\",\"card_role\":\"\",\"card_first_only\":\"0\",\"card_max\":\"\",\"custom_vocab_open\":\"0\",\"value_suggest_keep_original_label\":\"\",\"value_suggest_require_uri\":\"\"}'),
(64, 5, 84, '{\"input_control\":\"\",\"default_value\":\"\",\"automatic_value\":\"\",\"split_separator\":\"\",\"resource_query\":\"\",\"placeholder_value\":\"\",\"card_separator\":\"\",\"settings\":\"\",\"o:alternate_label\":\"\",\"o:alternate_comment\":\"\",\"is-title-property\":\"0\",\"is-description-property\":\"0\",\"o:is_required\":\"0\",\"o:is_private\":\"0\",\"o:default_lang\":\"\",\"o:data_type\":[],\"min_values\":\"\",\"max_values\":\"\",\"min_length\":\"\",\"max_length\":\"\",\"unique_value\":\"0\",\"automatic_value_issued\":\"\",\"locked_value\":\"0\",\"property_read_only\":\"0\",\"quick_new_resource\":\"\",\"autocomplete\":\"\",\"value_languages\":[],\"use_language\":\"\",\"order_by_linked_resource_properties\":[],\"value_annotations_template\":\"\",\"display_on_public_site\":\"\",\"card_display\":\"0\",\"card_role\":\"\",\"card_first_only\":\"0\",\"card_max\":\"\",\"custom_vocab_open\":\"0\",\"value_suggest_keep_original_label\":\"\",\"value_suggest_require_uri\":\"\"}'),
(65, 3, 85, '{\"input_control\":\"\",\"default_value\":\"\",\"automatic_value\":\"\",\"split_separator\":\"\",\"resource_query\":\"\",\"placeholder_value\":\"\",\"card_separator\":\"\",\"settings\":\"\",\"o:alternate_label\":\"\",\"o:alternate_comment\":\"\",\"is-title-property\":\"0\",\"is-description-property\":\"0\",\"o:is_required\":\"0\",\"o:is_private\":\"0\",\"o:default_lang\":\"\",\"o:data_type\":[\"customvocab:4\"],\"min_values\":\"\",\"max_values\":\"\",\"min_length\":\"\",\"max_length\":\"\",\"unique_value\":\"0\",\"automatic_value_issued\":\"\",\"locked_value\":\"0\",\"property_read_only\":\"0\",\"quick_new_resource\":\"\",\"autocomplete\":\"\",\"value_languages\":[],\"use_language\":\"\",\"order_by_linked_resource_properties\":[],\"value_annotations_template\":\"\",\"display_on_public_site\":\"\",\"card_display\":\"0\",\"card_role\":\"\",\"card_first_only\":\"0\",\"card_max\":\"\",\"custom_vocab_open\":\"0\",\"value_suggest_keep_original_label\":\"\",\"value_suggest_require_uri\":\"\"}'),
(66, 5, 86, '{\"input_control\":\"\",\"default_value\":\"\",\"automatic_value\":\"\",\"split_separator\":\"\",\"resource_query\":\"\",\"placeholder_value\":\"\",\"card_separator\":\"\",\"settings\":\"\",\"o:alternate_label\":\"\",\"o:alternate_comment\":\"\",\"is-title-property\":\"0\",\"is-description-property\":\"0\",\"o:is_required\":\"0\",\"o:is_private\":\"0\",\"o:default_lang\":\"\",\"o:data_type\":[],\"min_values\":\"\",\"max_values\":\"\",\"min_length\":\"\",\"max_length\":\"\",\"unique_value\":\"0\",\"automatic_value_issued\":\"\",\"locked_value\":\"0\",\"property_read_only\":\"0\",\"quick_new_resource\":\"\",\"autocomplete\":\"\",\"value_languages\":[],\"use_language\":\"\",\"order_by_linked_resource_properties\":[],\"value_annotations_template\":\"\",\"display_on_public_site\":\"\",\"card_display\":\"0\",\"card_role\":\"\",\"card_first_only\":\"0\",\"card_max\":\"\",\"custom_vocab_open\":\"0\",\"value_suggest_keep_original_label\":\"\",\"value_suggest_require_uri\":\"\"}');

-- --------------------------------------------------------

--
-- Structure de la table `session`
--

CREATE TABLE `session` (
  `id` varchar(190) NOT NULL,
  `data` longblob NOT NULL,
  `modified` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `session`
--

INSERT INTO `session` (`id`, `data`, `modified`) VALUES
('03o4vaqr11l4rikdmka210vqev', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333838383030332e3738383831363b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a2230336f347661717231316c3472696b646d6b6132313076716576223b7d7d, 1793888003),
('07qa5hk28bpeu14kh7urtmtnuk', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333936323630312e3536333935373b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a223037716135686b32386270657531346b68377572746d746e756b223b7d7d, 1793962601),
('0cq0o4r7atp12rjmp5o65oppk2', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333838373836312e3839313538333b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a22306371306f3472376174703132726a6d70356f36356f70706b32223b7d7d, 1793887861),
('0g57r3a05i1lbbfn8vd470vlpc', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333738383036382e3234343731363b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a2230673537723361303569316c6262666e387664343730766c7063223b7d7d, 1793788068),
('0hblf4rb7dtt75pvui60sn0sr7', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333936323631312e3239333632353b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a223068626c66347262376474743735707675693630736e30737237223b7d7d, 1793962611),
('0hbqeuria9h941g0llgdnjr37d', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333934363135302e3135303633313b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a22306862716575726961396839343167306c6c67646e6a72333764223b7d7d, 1793946150),
('0j29daoaie17vafv6nja70aus9', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333739323236332e3038343333363b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a22306a323964616f616965313776616676366e6a61373061757339223b7d7d, 1793792263),
('0o0p212ve9k375t7hsomlgetnj', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333934333731322e3939393339323b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a22306f30703231327665396b333735743768736f6d6c6765746e6a223b7d7d, 1793943713),
('0q6dgijfttjp24rc708tqnl4bc', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333837303939332e3535393736393b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a223071366467696a6674746a703234726337303874716e6c346263223b7d7d, 1793870993),
('0uqs0i5nnlhskt4gfvalg4pavi', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333934353338332e30383830393b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a22307571733069356e6e6c68736b7434676676616c673470617669223b7d7d, 1793945383),
('13npokimg5dfqvhjrcsdmt7pto', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333838393134362e3734323435313b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a2231336e706f6b696d673564667176686a726373646d743770746f223b7d7d, 1793889146),
('16krdj0543dverjesnonlillup', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333837303936382e3930353038373b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a2231366b72646a30353433647665726a65736e6f6e6c696c6c7570223b7d7d, 1793870968),
('17a1tl26msa1hl1s9qo5h8kp6h', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333839363939312e3233313534393b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a2231376131746c32366d736131686c317339716f3568386b703668223b7d7d, 1793896991),
('17fj7tk7aru0p3vh14o4u96j3p', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333830373034362e3333393934383b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a223137666a37746b37617275307033766831346f347539366a3370223b7d7d, 1793807047),
('18euovaaea6vialghc2ujjjfgl', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333837343233382e3832333936373b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a22313865756f7661616561367669616c67686332756a6a6a66676c223b7d7d, 1793874238),
('1b2cs7ej8rq0mnvgpm3hkjnukq', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333837313035352e3034383135333b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a22316232637337656a387271306d6e7667706d33686b6a6e756b71223b7d7d, 1793871055),
('1drp45kso5j53ihgodsk45jle2', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333830343339392e3736333531373b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a223164727034356b736f356a35336968676f64736b34356a6c6532223b7d7d, 1793804399),
('1edku7dd9lko3lnumibddoonnp', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333837343830362e3234313937323b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a223165646b75376464396c6b6f336c6e756d696264646f6f6e6e70223b7d7d, 1793874806),
('1g4v2v9sf0nb607bd2eu267msc', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333838383135352e353135373b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a22316734763276397366306e6236303762643265753236376d7363223b7d7d, 1793888155),
('1n406o4itaugv93tb9cfifcbpv', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333934373137362e3539363838353b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a22316e3430366f3469746175677639337462396366696663627076223b7d7d, 1793947176),
('1pobcd24b1nvv86t8alp7gb0rd', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333934353734332e35303835363b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a2231706f626364323462316e767638367438616c70376762307264223b7d7d, 1793945743),
('1tnsl3ofjn3svqgqj7hnsf1bsm', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333837303934372e3834353331313b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a2231746e736c336f666a6e3373767167716a37686e73663162736d223b7d7d, 1793870947),
('1vltb7c27d0hafa25lhb1vtm70', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333837303935342e3834393531363b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a2231766c74623763323764306861666132356c68623176746d3730223b7d7d, 1793870954),
('224mtls7jb0cem6s98sbb5429q', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333739323239302e3730303031363b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a223232346d746c73376a623063656d367339387362623534323971223b7d7d, 1793792290),
('250u6pv93sgcindinruun42k5n', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333837303937352e3338373534393b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a22323530753670763933736763696e64696e7275756e34326b356e223b7d7d, 1793870975),
('28l7ab1jbk0tboge8718kausau', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333934373139352e3131343939333b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a2232386c376162316a626b3074626f6765383731386b6175736175223b7d7d, 1793947195),
('2a7k2sulbne6qi16tj1c5ic0kq', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333934353531332e3733353130343b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a223261376b3273756c626e653671693136746a3163356963306b71223b7d7d, 1793945513),
('2djss65fnlisl9f8bda1f4e3oq', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333839343232352e3635313634383b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a2232646a73733635666e6c69736c39663862646131663465336f71223b7d7d, 1793894225),
('2el65v76rfqn84bp7c8itvs17f', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333836313639322e3239383133383b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a2232656c36357637367266716e3834627037633869747673313766223b7d7d, 1793861692),
('2i4mitv10d1pl6ai9m6lud2mj6', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333838373333382e3132393631343b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a223269346d69747631306431706c366169396d366c7564326d6a36223b7d7d, 1793887338),
('2il4va37lppitjpa5o1kf076el', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333837333832322e3837323530323b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a2232696c34766133376c707069746a7061356f316b66303736656c223b7d7d, 1793873822),
('2j5un6fmmnc873967jpeu2j8tr', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333839383131332e3735363632383b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a22326a35756e36666d6d6e633837333936376a706575326a387472223b7d7d, 1793898113),
('2lomqk4gqv1qip4gqqpiei80kf', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333837333638352e3333323134363b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a22326c6f6d716b3467717631716970346771717069656938306b66223b7d7d, 1793873685),
('2nfkndei7eug5fijrbou4m87re', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333838383135382e3433383634393b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a22326e666b6e646569376575673566696a72626f75346d38377265223b7d7d, 1793888158),
('2r63s0f219psh8st6fb4fctlkd', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333838383931362e3631393330333b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a2232723633733066323139707368387374366662346663746c6b64223b7d7d, 1793888916),
('2traflj9c8ob342ij2rs17jttu', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333934343833332e3533303234333b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a2232747261666c6a3963386f62333432696a32727331376a747475223b7d7d, 1793944833),
('317vsmjcva70b0qgdgu1sdru2h', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333838373930392e3537373330393b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a2233313776736d6a63766137306230716764677531736472753268223b7d7d, 1793887909),
('33b1tkkl8rjm907pk5lohvcdtm', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333839363939342e3734353831353b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a2233336231746b6b6c38726a6d393037706b356c6f68766364746d223b7d7d, 1793896994),
('342cr8p0fh30muqbrkvr2vupi2', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333838393533382e3034383732323b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a223334326372387030666833306d757162726b7672327675706932223b7d7d, 1793889538),
('369fn7vpddldo7r043a8omeoah', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333934363334302e3232303534383b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a22333639666e37767064646c646f377230343361386f6d656f6168223b7d7d, 1793946340),
('37f2namlcntdj1rgdmrsq7t9db', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333837353031382e31383235343b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a22333766326e616d6c636e74646a317267646d7273713774396462223b7d7d, 1793875018),
('3cdthfou38hjpj5u2t681iia5a', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333738373736392e33373437343b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a223363647468666f753338686a706a357532743638316969613561223b7d7d, 1793787769),
('3erunlm0g5ocgh56inj2ll8kh0', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333838373235372e3936343738333b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a22336572756e6c6d3067356f6367683536696e6a326c6c386b6830223b7d7d, 1793887257),
('3h7tj5rdrqmnggvqjkhbi71510', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333934353232302e3237323834353b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a22336837746a35726472716d6e676776716a6b6862693731353130223b7d7d, 1793945220),
('3j4ojoe8j65s5fsbb0jj9guj01', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333830373034352e3938313531343b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a22336a346f6a6f65386a3635733566736262306a6a3967756a3031223b7d7d, 1793807046),
('3mbeflu1cl5v8lsg045543lsai', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333934363531312e3836373332313b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a22336d6265666c7531636c3576386c73673034353534336c736169223b7d7d, 1793946511),
('3pnv3b1fr7detr6tb8fk7v6obi', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333837303932392e3737393737383b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a2233706e763362316672376465747236746238666b3776366f6269223b7d7d, 1793870929),
('3rsj2veq2it547729or2kjdvik', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333934343834302e3833323935313b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a223372736a327665713269743534373732396f72326b6a6476696b223b7d7d, 1793944840),
('3t2ghl10ia1od898lki7fl6h0g', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333934353430312e3934313438363b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a2233743267686c31306961316f643839386c6b6937666c36683067223b7d7d, 1793945402),
('432qnb47mqnjaut0npeqlnf2g0', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333838383931382e3438363238373b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a22343332716e6234376d716e6a617574306e7065716c6e66326730223b7d7d, 1793888918),
('43tbmvc9h0rfproc6vkm8kceim', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333837313036362e3235313939393b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a22343374626d7663396830726670726f6336766b6d386b6365696d223b7d7d, 1793871066),
('49qi9nqku978dufl38p15747he', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333738383038372e3930333433323b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a2234397169396e716b753937386475666c33387031353734376865223b7d7d, 1793788087),
('4ba3fq48p3tj62mlr4k253mae7', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333839333334392e3831363033333b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a2234626133667134387033746a36326d6c72346b3235336d616537223b7d7d, 1793893349),
('4gafsu4cg5u4rc7gvki55hhb5a', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333837343831392e3137303639333b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a2234676166737534636735753472633767766b6935356868623561223b7d7d, 1793874819),
('4icggpsvm820934n790tf0vbsh', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333935383531302e3930363134383b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a2234696367677073766d3832303933346e37393074663076627368223b7d7d, 1793958510),
('4jvbspnr8vse4t97q9lqt1mea3', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333739313835392e3131353131363b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a22346a766273706e72387673653474393771396c7174316d656133223b7d7d72656469726563745f75726c7c733a34363a22687474703a2f2f6c6f63616c686f73742f6f6d6b5f6f6e746f657468697175652f61646d696e2f6974656d2f3433223b, 1793791859),
('4p8ggp2msdjaon10uhpigb3uhu', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333934363531352e3932323639393b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a22347038676770326d73646a616f6e313075687069676233756875223b7d7d, 1793946516),
('4sm681n2jmm8j9tqd5s3rdjcr3', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333838393431332e3934363535323b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a2234736d3638316e326a6d6d386a3974716435733372646a637233223b7d7d, 1793889413),
('4v5f5u6832eonvb2j0v2gb357n', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333837303933382e35333731313b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a2234763566357536383332656f6e7662326a30763267623335376e223b7d7d, 1793870938),
('4vs10vfi40q4vqc2hk3gku2lkq', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333837333635362e3034313431373b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a2234767331307666693430713476716332686b33676b75326c6b71223b7d7d, 1793873656),
('505rtoc2el6v9qijo657thfof6', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333837343231382e3335323739363b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a2235303572746f6332656c36763971696a6f3635377468666f6636223b7d7d, 1793874218),
('52lrknhpnvgh4nu3tijdh9kkh8', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333837343737372e3739343336323b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a2235326c726b6e68706e766768346e753374696a6468396b6b6838223b7d7d, 1793874777),
('535pgu77cgp8qsp8uebitendck', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333838383931322e3233383730383b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a22353335706775373763677038717370387565626974656e64636b223b7d7d, 1793888912),
('54mevvnhnq72cc98bs3njfviao', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333839373134322e3635303134343b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a2235346d6576766e686e713732636339386273336e6a667669616f223b7d7d, 1793897142),
('5a10dr304co8m4gkthrfgfbb38', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333830353232342e3131393938313b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a22356131306472333034636f386d34676b74687266676662623338223b7d7d72656469726563745f75726c7c733a34363a22687474703a2f2f6c6f63616c686f73742f6f6d6b5f6f6e746f657468697175652f61646d696e2f6974656d2f3433223b, 1793805224),
('5l0sksor6ntc7sbniar0clti46', 0x5f5f4c616d696e61737c613a333a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333739313832382e3838323336393b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a22356c30736b736f72366e74633773626e69617230636c74693436223b7d733a34323a224c616d696e61735f56616c696461746f725f437372665f73616c745f6c6f67696e666f726d5f63737266223b613a313a7b733a363a22455850495245223b693a313739333833353032383b7d7d4c616d696e61735f56616c696461746f725f437372665f73616c745f6c6f67696e666f726d5f637372667c4f3a32363a224c616d696e61735c5374646c69625c41727261794f626a656374223a343a7b733a373a2273746f72616765223b613a323a7b733a393a22746f6b656e4c697374223b613a313a7b733a33323a226435333566336164306530313866333062323864616662633832653233333031223b733a33323a223366373565393762613434646433366363666666636236613263613933353636223b7d733a343a2268617368223b733a36353a2233663735653937626134346464333663636666666362366132636139333536362d6435333566336164306530313866333062323864616662633832653233333031223b7d733a343a22666c6167223b693a323b733a31333a226974657261746f72436c617373223b733a31333a2241727261794974657261746f72223b733a31393a2270726f74656374656450726f70657274696573223b613a343a7b693a303b733a373a2273746f72616765223b693a313b733a343a22666c6167223b693a323b733a31333a226974657261746f72436c617373223b693a333b733a31393a2270726f74656374656450726f70657274696573223b7d7d, 1793791829),
('5rv05gugb8742ju0utu7nn4kgl', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333836313536312e3531383131363b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a22357276303567756762383734326a7530757475376e6e346b676c223b7d7d, 1793861561),
('5tbrimfg1f0s48q4gm525v1mho', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333838373236312e3538393235383b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a2235746272696d66673166307334387134676d35323576316d686f223b7d7d, 1793887261),
('63hgnitn533uipe25pa1ghrn5k', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333837313034392e3537333838363b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a22363368676e69746e3533337569706532357061316768726e356b223b7d7d, 1793871049),
('6aue81pf598qke3i8khokkuv96', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333839383131332e3939343832373b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a223661756538317066353938716b653369386b686f6b6b75763936223b7d7d, 1793898114),
('6c54lvdvrfp0b4tccul59qkk17', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333738373737322e3332383836333b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a22366335346c766476726670306234746363756c3539716b6b3137223b7d7d, 1793787772),
('6f7ith4ns3mvk306f5rveh2iv3', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333839363938382e3234383434323b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a22366637697468346e73336d766b33303666357276656832697633223b7d7d, 1793896988),
('6fpr43h2nk1nos98m8haodgi7m', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333934333730392e3432393434363b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a2236667072343368326e6b316e6f7339386d3868616f646769376d223b7d7d, 1793943709),
('6h8uaccbhu09uql986mftonk4c', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333738373936312e3133343239373b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a2236683875616363626875303975716c3938366d66746f6e6b3463223b7d7d, 1793787961),
('6jkpom3tsdti11o6k8cvog5aba', 0x5f5f4c616d696e61737c613a333a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333830353135302e3539343139393b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a22366a6b706f6d33747364746931316f366b3863766f6735616261223b7d733a34323a224c616d696e61735f56616c696461746f725f437372665f73616c745f6c6f67696e666f726d5f63737266223b613a313a7b733a363a22455850495245223b693a313739333834383335303b7d7d4c616d696e61735f56616c696461746f725f437372665f73616c745f6c6f67696e666f726d5f637372667c4f3a32363a224c616d696e61735c5374646c69625c41727261794f626a656374223a343a7b733a373a2273746f72616765223b613a323a7b733a393a22746f6b656e4c697374223b613a313a7b733a33323a223531633734376165656664376233343734626130666235316435356666656366223b733a33323a226430363732376464373266353433343538643764633865396233353534383434223b7d733a343a2268617368223b733a36353a2264303637323764643732663534333435386437646338653962333535343834342d3531633734376165656664376233343734626130666235316435356666656366223b7d733a343a22666c6167223b693a323b733a31333a226974657261746f72436c617373223b733a31333a2241727261794974657261746f72223b733a31393a2270726f74656374656450726f70657274696573223b613a343a7b693a303b733a373a2273746f72616765223b693a313b733a343a22666c6167223b693a323b733a31333a226974657261746f72436c617373223b693a333b733a31393a2270726f74656374656450726f70657274696573223b7d7d, 1793805150);
INSERT INTO `session` (`id`, `data`, `modified`) VALUES
('6ois74rsd36sm0eugeqfje5bc2', 0x5f5f4c616d696e61737c613a31353a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333936303232302e3134363333363b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a2261717369393466753066627631356b7271307372663433666e75223b7d733a34323a224c616d696e61735f56616c696461746f725f437372665f73616c745f6c6f67696e666f726d5f63737266223b613a313a7b733a363a22455850495245223b693a313739333437313839383b7d733a33323a224c616d696e61735f56616c696461746f725f437372665f73616c745f63737266223b613a313a7b733a363a22455850495245223b693a313739343030333432303b7d733a35393a224c616d696e61735f56616c696461746f725f437372665f73616c745f7265736f7572636574656d706c617465696d706f7274666f726d5f63737266223b613a313a7b733a363a22455850495245223b693a313739333437343638393b7d733a35333a224c616d696e61735f56616c696461746f725f437372665f73616c745f7265736f7572636574656d706c617465666f726d5f63737266223b613a313a7b733a363a22455850495245223b693a313739333437353339323b7d733a34343a224c616d696e61735f56616c696461746f725f437372665f73616c745f636f6e6669726d666f726d5f63737266223b613a313a7b733a363a22455850495245223b693a313739343030333432303b7d733a35333a224c616d696e61735f56616c696461746f725f437372665f73616c745f766f636162756c617279757064617465666f726d5f63737266223b613a313a7b733a363a22455850495245223b693a313739333931313536303b7d733a36353a224c616d696e61735f56616c696461746f725f437372665f73616c745f7265736f7572636574656d706c617465726576696577696d706f7274666f726d5f63737266223b613a313a7b733a363a22455850495245223b693a313739333438383235363b7d733a35393a224c616d696e61735f56616c696461746f725f437372665f73616c745f6d6f64756c655f4561737941646d696e5f636f6e6669677572655f63737266223b613a313a7b733a363a22455850495245223b693a313739333437353132303b7d733a393a224561737941646d696e223b613a303a7b7d733a35363a224c616d696e61735f56616c696461746f725f437372665f73616c745f6d6f64756c655f4d61707065725f636f6e6669677572655f63737266223b613a313a7b733a363a22455850495245223b693a313739333437353532313b7d733a33373a224c616d696e61735f56616c696461746f725f437372665f73616c745f666f726d5f63737266223b613a313a7b733a363a22455850495245223b693a313739333936303531363b7d733a34383a224c616d696e61735f56616c696461746f725f437372665f73616c745f637573746f6d766f636162666f726d5f63737266223b613a313a7b733a363a22455850495245223b693a313739333938343639303b7d733a35373a224c616d696e61735f56616c696461746f725f437372665f73616c745f6561737961646d696e5f656e61626c655f656e68616e63656d656e7473223b613a313a7b733a363a22455850495245223b693a313739333839383635313b7d7d72656469726563745f75726c7c733a33383a22687474703a2f2f6c6f63616c686f73742f6f6d6b5f6f6e746f657468697175652f61646d696e223b4c616d696e61735f56616c696461746f725f437372665f73616c745f6c6f67696e666f726d5f637372667c4f3a32363a224c616d696e61735c5374646c69625c41727261794f626a656374223a343a7b733a373a2273746f72616765223b613a323a7b733a393a22746f6b656e4c697374223b613a313a7b733a33323a223665393935393430323737636362326536643663373131323961393862393838223b733a33323a223435393437616338386361313264393535333062316265643465386533333466223b7d733a343a2268617368223b733a36353a2234353934376163383863613132643935353330623162656434653865333334662d3665393935393430323737636362326536643663373131323961393862393838223b7d733a343a22666c6167223b693a323b733a31333a226974657261746f72436c617373223b733a31333a2241727261794974657261746f72223b733a31393a2270726f74656374656450726f70657274696573223b613a343a7b693a303b733a373a2273746f72616765223b693a313b733a343a22666c6167223b693a323b733a31333a226974657261746f72436c617373223b693a333b733a31393a2270726f74656374656450726f70657274696573223b7d7d4c616d696e61735f417574687c4f3a32363a224c616d696e61735c5374646c69625c41727261794f626a656374223a343a7b733a373a2273746f72616765223b613a313a7b733a373a2273746f72616765223b693a313b7d733a343a22666c6167223b693a323b733a31333a226974657261746f72436c617373223b733a31333a2241727261794974657261746f72223b733a31393a2270726f74656374656450726f70657274696573223b613a343a7b693a303b733a373a2273746f72616765223b693a313b733a343a22666c6167223b693a323b733a31333a226974657261746f72436c617373223b693a333b733a31393a2270726f74656374656450726f70657274696573223b7d7d4f6d656b614d657373656e6765727c4f3a32363a224c616d696e61735c5374646c69625c41727261794f626a656374223a343a7b733a373a2273746f72616765223b613a303a7b7d733a343a22666c6167223b693a323b733a31333a226974657261746f72436c617373223b733a31333a2241727261794974657261746f72223b733a31393a2270726f74656374656450726f70657274696573223b613a343a7b693a303b733a373a2273746f72616765223b693a313b733a343a22666c6167223b693a323b733a31333a226974657261746f72436c617373223b693a333b733a31393a2270726f74656374656450726f70657274696573223b7d7d4c616d696e61735f56616c696461746f725f437372665f73616c745f637372667c4f3a32363a224c616d696e61735c5374646c69625c41727261794f626a656374223a343a7b733a373a2273746f72616765223b613a323a7b733a393a22746f6b656e4c697374223b613a38393a7b733a33323a226435376566303032366433333231626333323564623665363163633132643538223b733a33323a223239616164376164363439663937626339633035626263396264323934616337223b733a33323a226164396430343532336434356437633862666639356233376337356639366564223b733a33323a226334313064313532323166313538373432346432373731613135316237663566223b733a33323a223131336265656138363837633066613536656461366530333431653564386564223b733a33323a223336356235653338643139386363363131653333633365646438356162393039223b733a33323a223332326533393434346539303161616664633062656463396365363462353363223b733a33323a223130613566353837336563663137366530626138373361313664363538616539223b733a33323a223964613763343734633231626537636636656562393466323561633731396361223b733a33323a223061323536363137656230303564386461636663336338663338343034633437223b733a33323a226233656232643563613534666631343031306362303431666165363031316564223b733a33323a226463323833323465373031633737616438643337633632316430613938333462223b733a33323a226638643961333433656638613266666234306263616561663036336234346132223b733a33323a223863333865393666666333653064333466373262336332383439323365323637223b733a33323a223337666138666165313730656433636666633138393264363232316633373164223b733a33323a223031623537623464616231376134383366643065653662323534636163653762223b733a33323a223034643531386165353964326162656661366638333663326236306137656536223b733a33323a223164343037353130323263646365393361396165363766376633313330323161223b733a33323a226262643661396165656466613531393064666263323033393236313339356430223b733a33323a223462643938616561346362336231383436323435373738363730306639373164223b733a33323a226233336233396539343565323537636235643139653932373762633633646531223b733a33323a223533313030303665343231393065373830303264326664646263356536653135223b733a33323a223966666439336430393834663766313139636138633366633230633535326238223b733a33323a226365633134393734306436363937633438373265306533636165326539376433223b733a33323a223936336136623061393130636666663532613438616536306461326166363737223b733a33323a223564633732393530343063633839643539336337383431366238336330393735223b733a33323a226461356335353531386237376233373934383935383064303563356633356464223b733a33323a226132393663643062336433363239323136303333313138386237363661616631223b733a33323a223235363234323662656466616330376133346631333031383163303161376334223b733a33323a226266353531663636373139353536333764343230626565613135656232353333223b733a33323a223431393731333037353834356432376262616463653435663439646634636434223b733a33323a223963366165386532393733363061393036633030373064653234336635623265223b733a33323a223662623964373031646334636562393534306666393932616335613133653531223b733a33323a223132396532616434666337626362636230383166326436323161393861373932223b733a33323a223738376235633534366636663137363535633035646439663261613864666464223b733a33323a223338366530316461303566623037383361353434636464373137333732313639223b733a33323a223632303261666662343238326262656532353430373137333731373736326436223b733a33323a223065353939393665376364616238306438393266336536343561643439373031223b733a33323a226532333863376466303362613963643266646164646330353734613039326633223b733a33323a226632343537623464613366613131643566346337356162383836376461626135223b733a33323a223133343930336639333332663964376437366662343331623832336630396339223b733a33323a223064323432646237353237313632376462353039363064626436353734353564223b733a33323a223435626335636339336666393332323864336666646665626162653030333963223b733a33323a223565376164646562366437633335663065313138303930663630376336353431223b733a33323a223538393933623537613161643033376663303933393562336238646234326363223b733a33323a223133356664616231313135316232633833643435373334666133386531383066223b733a33323a223033303434366430653730666564333162373564633561613136323432353165223b733a33323a226234656333333064333034396663356362656237623139656138313764376530223b733a33323a223366393730366365373139653165316464313438646637356635616235366439223b733a33323a226663663161653938646264323232656462636166663238323234653562626438223b733a33323a223632376535386664343930343338393136303234316137643538306333346138223b733a33323a223330313765313762663333326334633631656364623238353962613161646362223b733a33323a226139303437303235616363343637353034303936323062356231613965326336223b733a33323a223230363935643936386563653430363137663533336435313338366332633637223b733a33323a223836316566376534323333343933373964373530666263333938313665653665223b733a33323a223336626431333136613637343934316333346133316636353738663931656462223b733a33323a223062633161393035326533656261656461636631396634643464346263386463223b733a33323a226536303534356336313637653063393630303539343731616637316431653838223b733a33323a226261373034353533363731393032313635383535393333376537663562346165223b733a33323a226133313638663131613835643266323937333736393766663064643439366262223b733a33323a223632656330343236373238363030613139383562653234316434626436303033223b733a33323a223262336637363836626165353661343364616530326337303532323762643336223b733a33323a223965363331393562373638396138303632663735376562333839643032333535223b733a33323a223561343962363234326537313664636138323761366134663365633635323730223b733a33323a226562356237363261333832613161616539663836303336313531646163646532223b733a33323a223338663839366131373565643137633834356435386631653363353963616639223b733a33323a223234346462336263303238346435623930636633653030383930616464616433223b733a33323a223063346535663439656435386564626462653333326338386632363831316232223b733a33323a223861353837343762623833643934343539646535616137303366386537383163223b733a33323a223333353835633235336437366635343466323537633565343562616536353036223b733a33323a223361336336643134343261646133383031353936666563376335353766393338223b733a33323a223832656566646462326366323566326365613432363166366234353262313631223b733a33323a223263343264633562663830366666643065646561353232643833336430353261223b733a33323a223936313131646661643330633732376137333864656166363538356236303163223b733a33323a223039633766383535303933383533613963336533313337623538323634386664223b733a33323a223962636131356436343333303730663633663861383830373632353666393464223b733a33323a223737303566613336356335316133363065636536386538303266346636636165223b733a33323a223865353764643531326533343339663530333864356336376230326161653831223b733a33323a223564363137316565343361396233663163373463376139346564303539336133223b733a33323a223934383038396265636561396635303732383632653339653739333539633837223b733a33323a226239363465663732323465353762343135373039633632313861343338383239223b733a33323a223535663135383763656562343065663365386535376638643338636130336132223b733a33323a223635333839303239316364663334386531626638373266383432633536313136223b733a33323a223830336463643533663537333933616464613462366533306236346537303566223b733a33323a226138386666623263363934353034633837306635303236623535333239346135223b733a33323a223064303533333338656134333533623638646532653237383436643131663734223b733a33323a226365626463316537353764633563616238316437303932636233356163616234223b733a33323a223734336137633232363534616438653133323036336161323439353566346530223b733a33323a223339366561373865363333363434626139636434346363613562333466646465223b733a33323a223630633038376562626133323135656366333135356131646630623930363432223b733a33323a223534646630376565393331613831303763336162303766333965346331366261223b733a33323a223161316332336134306438373266393666383564616366656433396536626338223b733a33323a226666356333316436653836393038656437356233376161666461363236643163223b733a33323a226661666563663739393535633237353938643931343633656631653939303037223b733a33323a223636353161396638656366356464656264363233643334373836303939396630223b733a33323a223330366161323064663839336532396534646634636565303330386534633565223b733a33323a226634626531623036396561333632363738633263363035613330306236656530223b733a33323a226435643263336266343334393432653763656130656135653165383432666162223b733a33323a226164356437343763356262663731373031376131393661353734663666376461223b733a33323a223338306632343637333065386633386533386234366564663839343039636566223b733a33323a223138343033626433336366393733643164363135643164336531303966393938223b733a33323a223636353036643138333163623737363765323464363131646462616432653165223b733a33323a223136613837363434663832646466396466326463663065636239623532663539223b733a33323a223863623765393432633536396338656466333530663566313466353163613538223b733a33323a223234383362616633306662303164326139643331643437646561386666386165223b733a33323a223965643062633234646537646634633636623766643335363465356433353263223b733a33323a226238386166616262383830333733316665663731383732316463636631396363223b733a33323a223039656164383261663436373062396263323534316637653937366537636534223b733a33323a223766306138356438373339333330383662393935623364383564313837396430223b733a33323a223664333137376463363132326336323433383335336534383632353830343131223b733a33323a226238353934666561383562366533343735326234373931613861306236616534223b733a33323a223830333037386164303734313266646338613862636635616336313032633630223b733a33323a223236663133353835643961313534346266323130393366373730653934383036223b733a33323a226439353737363662383233303636356131643265333135343364383638386266223b733a33323a223936613735656635306537613235613662666361633434663262393634666636223b733a33323a226339616632663261373863653361653133613330346566346335666530353139223b733a33323a223031316364303432666635626665366531353930313139333162616339383037223b733a33323a223134623837313463613033643435656362376134353635356435343538653766223b733a33323a226364333230383937376637623664363030303763363561343039393661386539223b733a33323a226262373363643766313563306635323539333639393334323863366638323862223b733a33323a226366306636336162333838313132663061396434373333646635393766353366223b733a33323a226435316530623266636261663533666565343235333535353039623938663433223b733a33323a223162653338313061363437653034343935303865363232313764336438373235223b733a33323a223634336439316162656130306235323531366237383964396431313730636262223b733a33323a226435323265323438303936333938623433393035616234353434653465353034223b733a33323a223264343933326538336663323964346332653533356332386437366439633437223b733a33323a226631323736366161653937336266353338636635316263626137633436646261223b733a33323a226130396134303132373235393334646233626264633266323066313233323637223b733a33323a226436366537646338323632306231386335636337653262626539376537336431223b733a33323a223164343339376265626165653137376265366331643932323932373932636536223b733a33323a223030333233653461373736343331316132303139383565303765663662613438223b733a33323a223761333731653839643534613266396461353864346130306361366239613637223b733a33323a226133643534653062613732376235626237376439653034353365613931336631223b733a33323a223264386435663136343334313630343437376631333139316231613263363631223b733a33323a223366373165383130633832343738636266336662666364303163366230646439223b733a33323a223437363537346461343532646438373063363633383532626137613238326437223b733a33323a223738363136663539653237363631313531633438376534633338663138653261223b733a33323a226362366534306462326161323265633435323139623936636638666165653061223b733a33323a223463393735353835653464626462623437333838636638373933636338646236223b733a33323a223330646237326361613839623836396533643765323537643336363030353064223b733a33323a223135326132336337353839316438306234346235656434336464336361396537223b733a33323a226136336231393734396139373132373764326637353164656165383139623130223b733a33323a226334633930643961396435383165643238666631326262633237323530386261223b733a33323a223938333765643632366438323065383765353936616632383762313363313136223b733a33323a223839633236666538346532626163663533306161393033653434616236376236223b733a33323a226365633333303466373964313862393533353665303835356137633434333066223b733a33323a223361373531633639663832663733383838303937363930343133393566316230223b733a33323a223230363930383233376638383134373136366166656264663534313133393438223b733a33323a226234373133303439323764643132333234613430353337303235373634353937223b733a33323a226235666435303465656239383931326230366263613766636634333534333439223b733a33323a223337613266393837316364353330636133383934303030336665663866373833223b733a33323a223030363738656233646265666462613137386536623838306633333039366331223b733a33323a226132316437323861663266666465383964653964656637306338323934653163223b733a33323a226263363236303834336536333237383531653834613464633963343862303261223b733a33323a226137633036616261343236383765383937343563373362643261653237363164223b733a33323a226264633537633237343333303134346135623664343730356661366133396333223b733a33323a223835303334383731396262656132343531336361653262356630353937663632223b733a33323a226333303461313061663133303765313039373032383530306533383839663061223b733a33323a223838313734623164373365323963356432613135613965383761376563636532223b733a33323a223630653464653934643330333932666334313131663836343962316338623662223b733a33323a226661306364313633376331643266363461653064393266613837373562663634223b733a33323a223331613065306530643663353162646261666635363839363638333663663734223b733a33323a223230323165323333653961633231646532333438393633663932313161393732223b733a33323a223938626563383730343533646438363332643731373236333832333864366662223b733a33323a223434323833353735613361343135633363643532313263323438346664303861223b733a33323a223133336433346235363539376235383739623337643831393838376335343930223b733a33323a226333323865666562613766333062333264643932306432333933633461613238223b733a33323a226133393538383336363935343933663730626432393430373561393236303966223b733a33323a223137373961376533376633303663396230373562343163306562656436343234223b733a33323a223435333139303765393835333964326262363862626433333962643637623338223b733a33323a223065363430313231643065643035653934633263396631323364396132336531223b733a33323a226637666230396334333064633561333432303335366566616239366564623937223b733a33323a226130393236613364373863353132643166303364346339323934636161623336223b733a33323a226431373463643031306163303561336632626662333735656162336661643934223b733a33323a226264343561356331303666623834313732643434373831663264613033383062223b733a33323a226162623331613735633564323733656239383734326239623061303761376538223b733a33323a226635333866326435663461613635636633623432333232646338353863653632223b733a33323a223233333865383364383362323733666264363463386431643037613230323932223b7d733a343a2268617368223b733a36353a2232333338653833643833623237336662643634633864316430376132303239322d6635333866326435663461613635636633623432333232646338353863653632223b7d733a343a22666c6167223b693a323b733a31333a226974657261746f72436c617373223b733a31333a2241727261794974657261746f72223b733a31393a2270726f74656374656450726f70657274696573223b613a343a7b693a303b733a373a2273746f72616765223b693a313b733a343a22666c6167223b693a323b733a31333a226974657261746f72436c617373223b693a333b733a31393a2270726f74656374656450726f70657274696573223b7d7d4c616d696e61735f56616c696461746f725f437372665f73616c745f7265736f7572636574656d706c617465696d706f7274666f726d5f637372667c4f3a32363a224c616d696e61735c5374646c69625c41727261794f626a656374223a343a7b733a373a2273746f72616765223b613a323a7b733a393a22746f6b656e4c697374223b613a343a7b733a33323a226230386561306363366439313563656165343832663464363236656632656462223b733a33323a223362383838373532393862333938323839396237626366353231643161633861223b733a33323a226237616361333031623437356431623739333430326632613332366336613630223b733a33323a223337353636393364336462343137313564353239306132396131663664336361223b733a33323a223561333764663263646665393533666535343731613937653361353636323433223b733a33323a226466393063316439643266386365323831373936353462623064623739353566223b733a33323a226566383539306661386462633864333265333336666665366366623832633834223b733a33323a223436623033633635653334623464336162353631346264376338653238663435223b7d733a343a2268617368223b733a36353a2234366230336336356533346234643361623536313462643763386532386634352d6566383539306661386462633864333265333336666665366366623832633834223b7d733a343a22666c6167223b693a323b733a31333a226974657261746f72436c617373223b733a31333a2241727261794974657261746f72223b733a31393a2270726f74656374656450726f70657274696573223b613a343a7b693a303b733a373a2273746f72616765223b693a313b733a343a22666c6167223b693a323b733a31333a226974657261746f72436c617373223b693a333b733a31393a2270726f74656374656450726f70657274696573223b7d7d4c616d696e61735f56616c696461746f725f437372665f73616c745f7265736f7572636574656d706c617465666f726d5f637372667c4f3a32363a224c616d696e61735c5374646c69625c41727261794f626a656374223a343a7b733a373a2273746f72616765223b613a323a7b733a393a22746f6b656e4c697374223b613a31323a7b733a33323a226237396535383462316430326439356232613534313136333030356436363965223b733a33323a223730346534656165333865643666613137343666363766356163613366386366223b733a33323a223633666361316231636438303530336230336130663030666666326239333337223b733a33323a223037353364613731366465366231393635393061313435363735376138353463223b733a33323a223166666665366537326633356266643263333734393030633438383566643132223b733a33323a223865316633393239343039656137623664376437653864326233663438356661223b733a33323a226138333736373131386239653633396336316332316561343134663364363063223b733a33323a223565313834363665383838616339346336653835346436616334343636393861223b733a33323a223866323938383632613663323131353531333264343665663936646563336366223b733a33323a223236336636323861363636326434386164656237633635623538393631373531223b733a33323a226434663131313532613261656234666366356661313864373731653732366135223b733a33323a223638376439646462383437613661613735376237626138326663393731313437223b733a33323a226565356231356331643030623632626632613564656434393538373736653962223b733a33323a226261333463373264353832323161653661323535633635653931306132386337223b733a33323a226430333063353031323264346261306136343439633565383661383134346235223b733a33323a223530626661653762323238313063353533343634623732633531653266653136223b733a33323a226434646562363166376363383637363737393136636135656463333238366461223b733a33323a223730383536663835656535376333323162353266323266343834656538346130223b733a33323a223765393030643030316361386535313361656433636530366437343562383237223b733a33323a226361613334373131663864323066366263656139333262663562326461373936223b733a33323a223465393332656438373730613966663563613236303031346339323162316133223b733a33323a223463313935303865306338363461383335646132643164383064343534366266223b733a33323a223039633562356366396632643966386531303065316231356439666530623965223b733a33323a223333643231326537613535663961323331643231323035303037323661373565223b7d733a343a2268617368223b733a36353a2233336432313265376135356639613233316432313230353030373236613735652d3039633562356366396632643966386531303065316231356439666530623965223b7d733a343a22666c6167223b693a323b733a31333a226974657261746f72436c617373223b733a31333a2241727261794974657261746f72223b733a31393a2270726f74656374656450726f70657274696573223b613a343a7b693a303b733a373a2273746f72616765223b693a313b733a343a22666c6167223b693a323b733a31333a226974657261746f72436c617373223b693a333b733a31393a2270726f74656374656450726f70657274696573223b7d7d4c616d696e61735f56616c696461746f725f437372665f73616c745f636f6e6669726d666f726d5f637372667c4f3a32363a224c616d696e61735c5374646c69625c41727261794f626a656374223a343a7b733a373a2273746f72616765223b613a323a7b733a393a22746f6b656e4c697374223b613a3131333a7b733a33323a226634613736356438633130383839353731373932646132663036313163326536223b733a33323a223833633362626234383731656136346430343335343133353363663165393361223b733a33323a226564623762616666366264346438396333343939306361623762313664353531223b733a33323a226234643439333866353461306563323638393237366139323463363331613036223b733a33323a226330316265623866313137613365386336366164363935656364373238303136223b733a33323a223436383863656531356638643736356562656638626234393461343439653034223b733a33323a223963383433626338393062313938326262623466656165343532363430316636223b733a33323a223232343466363333316435653063323161636432386566396139623631613736223b733a33323a226132623161326534353664353861373932343865376162373039633737333265223b733a33323a226330643031303865626361303234366635393562376232663365363738623362223b733a33323a223161313330613930333935313865636332346161366439333531333635646364223b733a33323a226538383532363632373962643533333735633165383931313461326461326665223b733a33323a226237326165336361666237396434313061313038623566306132346233363136223b733a33323a223530303037656564303266376135343361643338663738633366363866613966223b733a33323a223464616363396632303539373861666462613730343063306332303962316434223b733a33323a223537646165363538306136326439376236316234353430333939346561346135223b733a33323a226466646238643131373430393364333237366131643732653162356661653730223b733a33323a226438353330663766656130363165306236376437363764323062336531316663223b733a33323a223162353662323930326165306535653164383738343335356261353965616233223b733a33323a226532393638376362623837316232333163633262646365646637306235373630223b733a33323a223037623535363530393565303863636364333664333430313631326332363530223b733a33323a226438363831333963646639343666613338656562316439633730303364643931223b733a33323a226661626135643634393837623838623864373362363963316233393763393864223b733a33323a223561343838613633646231346538373838373365653231323764663661353738223b733a33323a223138303533303866323830613130316565393366623462646337636463616564223b733a33323a223262613466363739393264656465653530333461646364663733653237363761223b733a33323a223736373730313764383163643462653035653162393833383966366333323465223b733a33323a223264656566303037636338316364646239383239316366386364663336333330223b733a33323a223935653565323037623931303761386339353837383161616339313134313765223b733a33323a226433366539346130613438636434313164363865363639376439336235336335223b733a33323a223462633537646262643334393661653362333631646562613063326237623531223b733a33323a226435663538306133363832336666613161343461376130306432356330376262223b733a33323a226266366263656165626136353537343461393334316263303961346635636236223b733a33323a223561643831623435393738336361646138333163366635633330646334623538223b733a33323a226137393230653632306333336438623032343466633334336138383763356638223b733a33323a226435613538636566366563303766353465313766333466656230636163316339223b733a33323a223739383634363161306261323261653733633337623233613264656638643962223b733a33323a226266373933363635353263346666623339396163323933613237343961363639223b733a33323a226531383932333733613638613936303339336264613432623335326562626561223b733a33323a223231376466303962323562323732396337363565643733376238313139643865223b733a33323a223563636336653233323364313635623838666361386366393866313231643534223b733a33323a223035663362333839613736626462316465376263363832313066353766346631223b733a33323a226536653738373335303962323934326632396661353239643938313935633439223b733a33323a226236343461663338363036346333316232616631336666653664393630313865223b733a33323a226130393663393935613039356564353836303835326430653763653735633066223b733a33323a223735376337643539353032366466363466636434653039313962313339383838223b733a33323a223337646466616332356661306333396639396536373437303130323265643837223b733a33323a223166633063643762653531393064386566616364356362363964303335323831223b733a33323a223836613130626332326330323363653461386239343439343064623830656139223b733a33323a226366313662346663646633353038303831386266663532663535306530663065223b733a33323a223536393034383335653565393637633666323438353334656437633266366566223b733a33323a223738633965356431643332306532636430336563303935656261363836333435223b733a33323a226132643663656662326565626337383234383534633133613239306364636235223b733a33323a226135643332343165373033666431636238336636636666323035623230303835223b733a33323a226135316432306538386131303733313766396239623737663336386436303733223b733a33323a223032636262656661623930663861656538396363643336363831386565656133223b733a33323a226538616564333863346536313261646231333232386336323961663664336634223b733a33323a226435313538306236643862636239336538323035346132373838303537616435223b733a33323a223533326665373234336561663638353235663438373132653632653265653130223b733a33323a223165626139323761383037643765666632373131663130386361363637393364223b733a33323a223137303161333561396332653432633639653032313461333639373935316165223b733a33323a223865326363316635623434653065393238616534356162643132626364616461223b733a33323a223232333965633438343330333330666266613265316661373339663265326365223b733a33323a223364656239333438353231643231633863303231303632393330333266353863223b733a33323a223566366439396565616636353065386234663833613733343036623061373439223b733a33323a226661323734656564393532376438653362303336353465373563323662373433223b733a33323a226565346261616261333536323264656439383466353939353938366336326330223b733a33323a223539663964376630646533353739633161323564323636623337323262376133223b733a33323a223339316230306461376164303962643661313462643533363066376133303731223b733a33323a223939653033633238393233326261363366333536656536623231626666383335223b733a33323a226432373061393338656231666361613633393532313132316538393337356664223b733a33323a223936393730336131373161353538393131353236653734626265623331623233223b733a33323a226363343063373738383462383938626635646133613232316434396138643933223b733a33323a226136653965343632353132303864643731663939346337376363353337636231223b733a33323a223332326335396237646430626566396636663336393339356134336463353232223b733a33323a226161633063366433343333386464393466363635333963306632383362666463223b733a33323a223130356137313538333439373335346362303337363331303231396361616131223b733a33323a226132663430393236366639306431363438316265343561386532323765306662223b733a33323a223832646432636664353135646338313263373761663563333663643638303662223b733a33323a223736323963356132346263613335373061313964363131303130346338306634223b733a33323a226130643334653438333531386533306433663139326235316366306366646130223b733a33323a223635393135343233373430636232306263376430333030396436373264313732223b733a33323a226330633730373063616264363732393330383834633063353363623838653132223b733a33323a226133376464356338613032373039356237373561366364376435383433306261223b733a33323a223136313035623034633162393735616535656237653533393534313836386135223b733a33323a223764343732636663663236343539336135313033646231653535333464373630223b733a33323a223539333764376331653539346430316330306238326363616666336531383463223b733a33323a226236346633343939323266613033323333636139393633386336373138323333223b733a33323a226236333864323663643134623436663934613161636635306664653737376430223b733a33323a226535333830653537353738623061646437323437333138623231336335313931223b733a33323a223139653135386566346331313462636333373835393165653333653261393161223b733a33323a223963333739643036366539623036393533613933373434373161363161656336223b733a33323a223237386630353935616464643132306662613562636438373031306234396663223b733a33323a223339623661373234613934623062376462623866376339636339303037666530223b733a33323a223431653566633863643931653430656163333131326630336536383164663136223b733a33323a223861613366396538346236663939363661643036613862323436656161346534223b733a33323a223563333061333033653366636164313435376630623837393166663738626535223b733a33323a223332316239633736326630626133396165363637306237376537343762633463223b733a33323a223433663935383435393235616365653865306461393963343166376533393663223b733a33323a223837393665616539356565613264393236336532663433343234353364346437223b733a33323a223466663732316135313638613732623365646339323535646461323665336230223b733a33323a226432396638366265623665383462383837666563653332333465373362336533223b733a33323a223339353337663961353935616531343063323135363531316137353738313131223b733a33323a226331616433366135383830366539656666656330333230356663366433643739223b733a33323a223637346563373363336661303732313438633664663065346361663162316331223b733a33323a223361383337316664666536363739366564353361613762383233383439386634223b733a33323a226662643136326465363666636439363132643239393731643738333133376435223b733a33323a223331336261343332323663653833313531313966393431653934373430643833223b733a33323a223731363662313337646337613964663037366139343136623938333131346365223b733a33323a223936356438313131653730636563616365366133646562633866323332363032223b733a33323a223638363332636132373431343563616133666164623663643266626330666562223b733a33323a223833323533336363346536653264373838373961336539373335656537383532223b733a33323a226638376363643031373934373932326266383535646263383161356264343464223b733a33323a226466313337376664613736356332353363623536316562646666323532393737223b733a33323a223930373833316136333135613539613766643230313738353065303366663535223b733a33323a226434643233353237376630396562663763303866316163646636333836643832223b733a33323a226561656630373933313231653333616664333532666230366633393364343262223b733a33323a223037626331363066646338366237306436633363343130653062386636663863223b733a33323a223265656433396439636334366234306533353933383937303635373535383165223b733a33323a226565396530386463653761663432653835323338613933633765633734653464223b733a33323a223834356163656263373065633236356366313536313136326131376265663737223b733a33323a223331393564323564356534666132333634396563666365323939643662393131223b733a33323a226531346263376439336362393938366665383237623964616535613537343334223b733a33323a223731646363393731653534616233626135616130306363656165653863363964223b733a33323a223466613061616332626537666335653032386531326132656262643532646432223b733a33323a226138363165313339626465653964346534363662633265313337396130396333223b733a33323a223462386237373933376531616337666331363137363031613339303034636635223b733a33323a223966393434653066656461333361623463646561383865623832636163343865223b733a33323a226637366565353664643038663434666533313730633736323566353339636538223b733a33323a226562316132633232326634366336353135356164316133653862333735306239223b733a33323a223863393730373931396135303731343563356261343030346439333165646631223b733a33323a223431633735633233663834663239656231346366346261656463663664653761223b733a33323a226331376236623761363531633066356562393033313563396636653939356234223b733a33323a223162653533343536303531353739303065633364393633653630653662303463223b733a33323a223661323963623237313166653536663335623339333931383730326139363762223b733a33323a226636636133356439393336333831316336313534333034343966633839663638223b733a33323a223062396238326465363939643632663066336462346365306338626630626365223b733a33323a226161666437303435653532666331326332613533613636323333323466666237223b733a33323a223566323961356263323332373835336235633538646362663964373232373564223b733a33323a223764666439663232613239303731313330353838643531623039646438353030223b733a33323a226261313364306139323866326365303837363537363763616131616564656337223b733a33323a223464323666633030313463333237633263666230373138373161633136613231223b733a33323a226164373639343366636561646365326637323534303039326163346566633630223b733a33323a223730653137306461383739336364663730393832316563326263326439376436223b733a33323a226234616632333337373366643132623531363864343934333239313935313733223b733a33323a226564323465623438333736666136643930396630393166623033363631633766223b733a33323a223032346336346333336238633465623930326164303061383164616666343537223b733a33323a223037636537396532313338613564656539623230646633623863663334646535223b733a33323a223463653234303965306135323361336633336530306333613136633231316331223b733a33323a223762346636303565353262393337363437333763633630366165616364313532223b733a33323a223136356164653063363637323538656137666332366265353231616132653533223b733a33323a223935396432616638343432643937653734303835356335313937376461316130223b733a33323a223732373334613563326564653731366435356666316564626662626534643063223b733a33323a223330383933343562643632313062646535303535396130383738303962333932223b733a33323a226264643836666431356431656663626162316133636365373266316338383038223b733a33323a226465643931306261633836376366356132626634316161396232356332623937223b733a33323a223562323231613637303063356631653161373834323363333332643361636130223b733a33323a226663323734623961373436336531313831636638356561346562386666643132223b733a33323a223563623463313832616137393933373638613430373830306531326330646565223b733a33323a226439306463373933333236356462333163393837386666613761633265363630223b733a33323a223431323132666363346566383031613838383331643734333033623334633739223b733a33323a223833333234386638326432646637356236633031306435353232306536363961223b733a33323a223766643763336334383466353666353663633932656166623861363661383466223b733a33323a223038353136663032636134646339653061366337666631323961356333333233223b733a33323a226534386533663030313964313563646561313838353164353862323563393032223b733a33323a223263303231663961613034656563396230386233383938303232323338623930223b733a33323a226432366666333333613965623563653835643161373233363436323966306235223b733a33323a223132353039306663646465393964386437383739363832356562363536393162223b733a33323a226636373963363339306139343338373733343939623434326134653033626231223b733a33323a226636363661623565623831303165643764333462373864666336643436303865223b733a33323a223163663830643739616366616263326133663365363566306464383634393236223b733a33323a223266653662373166336137343562303662393835326232373866326232323734223b733a33323a226536333763663939333662306565313936646663343936323265343234653366223b733a33323a223735653933356633303865356335333837373135646164646465633664653237223b733a33323a223736376464393339643431363962656431663736366235633532383036323035223b733a33323a223832376333316566646365343764376634643031343334653132616436383962223b733a33323a223736643836326539393239383465306133333133383739303031616230613838223b733a33323a223839656133366137356263353733663666643630373335343038623635663232223b733a33323a223363623236386237666335623638366236373538383266613236353231306237223b733a33323a226237663534666535373531353565626532643636653266393933376131313830223b733a33323a223961336535323664396533626137396161393737303233386533333434656238223b733a33323a223762303634656634646336323661643538643336626161613861366235633865223b733a33323a223864633131356433323637363336643361353861353235386230353965313762223b733a33323a226361636464336632336239383230396636306336306331353765333439393534223b733a33323a226437356330616433353263343032636636393534643065303337616662663365223b733a33323a223731343865326237613537383439306333633032316532373732633630366639223b733a33323a223433336261313235653332386637653032373364653461633762393461643230223b733a33323a223062303832333265623834653535656635663035613830386565323165613730223b733a33323a226262646463616139363231666538336436643063376535336137636362636538223b733a33323a223631303665316265333261613261376463613032613531613535383232613230223b733a33323a223535636333656234313035393435653132303063303638613166326266373465223b733a33323a226261343764316434373832366538656130613738333138663061353339376164223b733a33323a223733353038366364353233316634626331396233383163663664373436343030223b733a33323a223438646337353931373937383161376231353539316232356436306132393439223b733a33323a223964366433333935653535353161353762373363393464626534363633306462223b733a33323a223364343839323961323235323261356437613031663361343933306634616363223b733a33323a223764303935633266333663363965313361326465613936653165653137656562223b733a33323a223737376562393063313032356231623634643861323833653762346337353339223b733a33323a223263653839343135616435636166353438643336383166616430646539306561223b733a33323a226264623635326532363162353063616335336562373239353939663633336534223b733a33323a223762336334366536363738666463363163663532336435656138633333653037223b733a33323a223430616239333932643861616336383461376336336136656139616534626666223b733a33323a223865336330353631633564636566636361353434373530396161366135393761223b733a33323a223064383933636161356339326439643463343466373338656464663836633739223b733a33323a223038346139656661346334656164616539396136393063396164636361363266223b733a33323a223339306134373430343166643864343963343035646663656136376337356661223b733a33323a226564383130383030643531623463626366366332373935346665363963316266223b733a33323a226638313061356631653966613231303239623734643737386663363930623361223b733a33323a223936373439393564326236383563356166366636666366383438333866616264223b733a33323a226337346363393564346434323639356665383338666263616631646532386539223b733a33323a226165353031336365383531653939373436376536653930323436323462353861223b733a33323a223632363339663133353766646537626439666434383338393566363934313539223b733a33323a226636663030386264376636636635373230363038366461646336636530386565223b733a33323a223262313462353263616334326261313433353964333431616330613061346132223b733a33323a223133333839326564336335393833306463383965643265386432316534616637223b733a33323a226332656530393931313933323633376237316437323737666532663361363966223b733a33323a226164333063316464373730333033333766346134386337316264643637616664223b733a33323a223434343634313837303631353661303736306561613332636363653839396235223b733a33323a223161306630313762623266356233353331623362346436383439633132386461223b733a33323a226331623262356631393732313439326233353931313835616336373266373261223b733a33323a223761643831376336636463643537396162303935333835323236373130346264223b733a33323a226135333564336637656630633362623733306635323330626664623964646232223b733a33323a226637353863383337313036396232303763306163373439343337666435623536223b733a33323a223635373235663036363134663837303464356565356536326536343166633061223b733a33323a223562343835623766376330316532663965363937353233366565396537613437223b733a33323a223537363433643066633063346535646563663261316565323963633362323465223b7d733a343a2268617368223b733a36353a2235373634336430666330633465356465636632613165653239636333623234652d3562343835623766376330316532663965363937353233366565396537613437223b7d733a343a22666c6167223b693a323b733a31333a226974657261746f72436c617373223b733a31333a2241727261794974657261746f72223b733a31393a2270726f74656374656450726f70657274696573223b613a343a7b693a303b733a373a2273746f72616765223b693a313b733a343a22666c6167223b693a323b733a31333a226974657261746f72436c617373223b693a333b733a31393a2270726f74656374656450726f70657274696573223b7d7d4c616d696e61735f56616c696461746f725f437372665f73616c745f766f636162756c617279757064617465666f726d5f637372667c4f3a32363a224c616d696e61735c5374646c69625c41727261794f626a656374223a343a7b733a373a2273746f72616765223b613a323a7b733a393a22746f6b656e4c697374223b613a343a7b733a33323a223239643934313639383430353933383839383066386635326137626537613939223b733a33323a226166646662616265343163393562393535306565376538656138393237393461223b733a33323a223665636266343530376665646331326135343663386639656161303130633839223b733a33323a226631303533363763336535393733373131336639386339313334646236386535223b733a33323a223531653162343434363431303330316562613231346264633064333932626533223b733a33323a226162316433626330663438366161303132383138313836636566303163633036223b733a33323a223265323431303434383461333339656631353436653435643538323030313566223b733a33323a223663616161613438643033303138346131323066333561356435386364306632223b7d733a343a2268617368223b733a36353a2236636161616134386430333031383461313230663335613564353863643066322d3265323431303434383461333339656631353436653435643538323030313566223b7d733a343a22666c6167223b693a323b733a31333a226974657261746f72436c617373223b733a31333a2241727261794974657261746f72223b733a31393a2270726f74656374656450726f70657274696573223b613a343a7b693a303b733a373a2273746f72616765223b693a313b733a343a22666c6167223b693a323b733a31333a226974657261746f72436c617373223b693a333b733a31393a2270726f74656374656450726f70657274696573223b7d7d4c616d696e61735f56616c696461746f725f437372665f73616c745f7265736f7572636574656d706c617465726576696577696d706f7274666f726d5f637372667c4f3a32363a224c616d696e61735c5374646c69625c41727261794f626a656374223a343a7b733a373a2273746f72616765223b613a323a7b733a393a22746f6b656e4c697374223b613a383a7b733a33323a226162306438376264613765623861623032643136663930396333353239333239223b733a33323a226661616431353637656565633333356435663864643764653130336232626364223b733a33323a223763653130376238393136303538623530646633316163386530663134366164223b733a33323a223634363439343835643835373065336633316466336630366439316235656561223b733a33323a223837343962363635626239326362303937663230323264666561333838343534223b733a33323a226134336136313631363330343664616235353264336563633431333266646662223b733a33323a223932653536346330353038386130333935343561623235646438333339333835223b733a33323a226330623565326665646265316161613835626365343030663431366565626538223b733a33323a223537636238636536313336323733633435383234356562383138306461616532223b733a33323a223930313365633165636530666432383037633837643837303362613337343439223b733a33323a223030666366393537663633623364393864306334366337303832343636306264223b733a33323a223034393637623035393235356137663739636236373061366235353735396537223b733a33323a226164353932353066663838366161313161326366643735313633323863313662223b733a33323a223338303930303464356662383361306632333738303939623162326564393266223b733a33323a223531383236616532373635353463353631623964613664323737653431303234223b733a33323a223764366461326666376366303961316230313365386461656533633231656630223b7d733a343a2268617368223b733a36353a2237643664613266663763663039613162303133653864616565336332316566302d3531383236616532373635353463353631623964613664323737653431303234223b7d733a343a22666c6167223b693a323b733a31333a226974657261746f72436c617373223b733a31333a2241727261794974657261746f72223b733a31393a2270726f74656374656450726f70657274696573223b613a343a7b693a303b733a373a2273746f72616765223b693a313b733a343a22666c6167223b693a323b733a31333a226974657261746f72436c617373223b693a333b733a31393a2270726f74656374656450726f70657274696573223b7d7d4c616d696e61735f56616c696461746f725f437372665f73616c745f6d6f64756c655f4561737941646d696e5f636f6e6669677572655f637372667c4f3a32363a224c616d696e61735c5374646c69625c41727261794f626a656374223a343a7b733a373a2273746f72616765223b613a323a7b733a393a22746f6b656e4c697374223b613a313a7b733a33323a223763643165623963646330326662383337633434363162366335663235353963223b733a33323a223066353332626532326438666664363963616561656230303262376163313235223b7d733a343a2268617368223b733a36353a2230663533326265323264386666643639636165616562303032623761633132352d3763643165623963646330326662383337633434363162366335663235353963223b7d733a343a22666c6167223b693a323b733a31333a226974657261746f72436c617373223b733a31333a2241727261794974657261746f72223b733a31393a2270726f74656374656450726f70657274696573223b613a343a7b693a303b733a373a2273746f72616765223b693a313b733a343a22666c6167223b693a323b733a31333a226974657261746f72436c617373223b693a333b733a31393a2270726f74656374656450726f70657274696573223b7d7d4561737941646d696e7c4f3a32363a224c616d696e61735c5374646c69625c41727261794f626a656374223a343a7b733a373a2273746f72616765223b613a323a7b733a31343a226c61737442726f77736550616765223b613a313a7b733a353a2261646d696e223b613a313a7b733a353a226974656d73223b733a32373a222f6f6d6b5f6f6e746f657468697175652f61646d696e2f6974656d223b7d7d733a393a226c6173745175657279223b613a313a7b733a353a2261646d696e223b613a313a7b733a353a226974656d73223b613a353a7b733a31353a22736f72745f62795f64656661756c74223b733a303a22223b733a31383a22736f72745f6f726465725f64656661756c74223b733a303a22223b733a373a22736f72745f6279223b733a323a226964223b733a31303a22736f72745f6f72646572223b733a343a2264657363223b733a343a2270616765223b693a313b7d7d7d7d733a343a22666c6167223b693a323b733a31333a226974657261746f72436c617373223b733a31333a2241727261794974657261746f72223b733a31393a2270726f74656374656450726f70657274696573223b613a343a7b693a303b733a373a2273746f72616765223b693a313b733a343a22666c6167223b693a323b733a31333a226974657261746f72436c617373223b693a333b733a31393a2270726f74656374656450726f70657274696573223b7d7d4c616d696e61735f56616c696461746f725f437372665f73616c745f6d6f64756c655f4d61707065725f636f6e6669677572655f637372667c4f3a32363a224c616d696e61735c5374646c69625c41727261794f626a656374223a343a7b733a373a2273746f72616765223b613a323a7b733a393a22746f6b656e4c697374223b613a313a7b733a33323a223030386365653632646134626335373339663638363133613265373439326633223b733a33323a226234343864636633313035323738633438633130613033393161323061396636223b7d733a343a2268617368223b733a36353a2262343438646366333130353237386334386331306130333931613230613966362d3030386365653632646134626335373339663638363133613265373439326633223b7d733a343a22666c6167223b693a323b733a31333a226974657261746f72436c617373223b733a31333a2241727261794974657261746f72223b733a31393a2270726f74656374656450726f70657274696573223b613a343a7b693a303b733a373a2273746f72616765223b693a313b733a343a22666c6167223b693a323b733a31333a226974657261746f72436c617373223b693a333b733a31393a2270726f74656374656450726f70657274696573223b7d7d4c616d696e61735f56616c696461746f725f437372665f73616c745f666f726d5f637372667c4f3a32363a224c616d696e61735c5374646c69625c41727261794f626a656374223a343a7b733a373a2273746f72616765223b613a323a7b733a393a22746f6b656e4c697374223b613a363a7b733a33323a226339656131653962363662323330356233643832373962633863653466383138223b733a33323a223736663463383861333564356535616666643263363362333631343233393761223b733a33323a223834626164396630626536653966623938653135653363613731343731343539223b733a33323a226634346562393236303233653339353264303061383833393334636630626664223b733a33323a226432623039643636383633396438656565373435643664373164326339646266223b733a33323a223730376132316432373563346465333937393539666663623534663136636162223b733a33323a226234376532303230653638393564313764316336353565363936636564613831223b733a33323a226238653465626463356539623065646265353935346561363161346465323462223b733a33323a226431383137333264343563643434383334306531636333383137656635366266223b733a33323a226130653264633432616632333732393637633133353962376262663934373735223b733a33323a223930323865353661303435303737626339663634316532643761393533663731223b733a33323a223338366565346631366261666565653264383637383635383130626337393361223b7d733a343a2268617368223b733a36353a2233383665653466313662616665656532643836373836353831306263373933612d3930323865353661303435303737626339663634316532643761393533663731223b7d733a343a22666c6167223b693a323b733a31333a226974657261746f72436c617373223b733a31333a2241727261794974657261746f72223b733a31393a2270726f74656374656450726f70657274696573223b613a343a7b693a303b733a373a2273746f72616765223b693a313b733a343a22666c6167223b693a323b733a31333a226974657261746f72436c617373223b693a333b733a31393a2270726f74656374656450726f70657274696573223b7d7d4c616d696e61735f56616c696461746f725f437372665f73616c745f637573746f6d766f636162666f726d5f637372667c4f3a32363a224c616d696e61735c5374646c69625c41727261794f626a656374223a343a7b733a373a2273746f72616765223b613a323a7b733a393a22746f6b656e4c697374223b613a343a7b733a33323a226637323738396466353564346463313938323363313238623762383434306136223b733a33323a226530376437653938383336633665663136383034663137303865393437653035223b733a33323a223734626632316437363739363662656332363530633535393936633566366437223b733a33323a226436383638613537396162366231336437323266616131353433343363363266223b733a33323a226666666664663065356163663831333161333365656365323333343531646263223b733a33323a223336366661613965666439383165383031386566663031386233333333623033223b733a33323a226365666532336635326335313265326531343766333030343332303561646462223b733a33323a223233613937653165386364656534383362373638393036376339363234633932223b7d733a343a2268617368223b733a36353a2232336139376531653863646565343833623736383930363763393632346339322d6365666532336635326335313265326531343766333030343332303561646462223b7d733a343a22666c6167223b693a323b733a31333a226974657261746f72436c617373223b733a31333a2241727261794974657261746f72223b733a31393a2270726f74656374656450726f70657274696573223b613a343a7b693a303b733a373a2273746f72616765223b693a313b733a343a22666c6167223b693a323b733a31333a226974657261746f72436c617373223b693a333b733a31393a2270726f74656374656450726f70657274696573223b7d7d4c616d696e61735f56616c696461746f725f437372665f73616c745f6561737961646d696e5f656e61626c655f656e68616e63656d656e74737c4f3a32363a224c616d696e61735c5374646c69625c41727261794f626a656374223a343a7b733a373a2273746f72616765223b613a323a7b733a393a22746f6b656e4c697374223b613a323a7b733a33323a226461356437613930386137363365346633363264343937303665326566363664223b733a33323a226430646664626664336639386431653264616232366364366132623464346135223b733a33323a223764633736393137396239613361663631356463653732313133323465346233223b733a33323a223230643966353164373764653939363836616432663637313036323466663833223b7d733a343a2268617368223b733a36353a2232306439663531643737646539393638366164326636373130363234666638332d3764633736393137396239613361663631356463653732313133323465346233223b7d733a343a22666c6167223b693a323b733a31333a226974657261746f72436c617373223b733a31333a2241727261794974657261746f72223b733a31393a2270726f74656374656450726f70657274696573223b613a343a7b693a303b733a373a2273746f72616765223b693a313b733a343a22666c6167223b693a323b733a31333a226974657261746f72436c617373223b693a333b733a31393a2270726f74656374656450726f70657274696573223b7d7d, 1793960220);
INSERT INTO `session` (`id`, `data`, `modified`) VALUES
('6s569vhfqp27qgk8o4u4gq7cn3', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333934333430372e3636383436363b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a2236733536397668667170323771676b386f347534677137636e33223b7d7d, 1793943407),
('6usm31q82fk9ds9ljnpqsl3p7m', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333739323234322e3237323338383b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a223675736d3331713832666b396473396c6a6e7071736c3370376d223b7d7d, 1793792242),
('71ui7g9k3h5nrnmem0r8igtiqq', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333837303936302e3130363230323b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a22373175693767396b3368356e726e6d656d307238696774697171223b7d7d, 1793870960),
('7482ofhd8jd6kqunvq1jquaqul', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333934323834342e3936373036353b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a22373438326f666864386a64366b71756e7671316a71756171756c223b7d7d, 1793942844),
('77co0lgng25e1crs6cg4im519q', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333836393233362e3131343634383b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a223737636f306c676e673235653163727336636734696d35313971223b7d7d, 1793869236),
('77pp38g55s45lpo82729piksj8', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333837303936322e3931323435383b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a223737707033386735357334356c706f383237323970696b736a38223b7d7d, 1793870962),
('797d81d95rfmhea26lr8lua5i9', 0x5f5f4c616d696e61737c613a333a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333738373439352e3735333636373b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a2237393764383164393572666d68656132366c72386c7561356939223b7d733a34323a224c616d696e61735f56616c696461746f725f437372665f73616c745f6c6f67696e666f726d5f63737266223b613a313a7b733a363a22455850495245223b693a313739333833303639353b7d7d4c616d696e61735f56616c696461746f725f437372665f73616c745f6c6f67696e666f726d5f637372667c4f3a32363a224c616d696e61735c5374646c69625c41727261794f626a656374223a343a7b733a373a2273746f72616765223b613a323a7b733a393a22746f6b656e4c697374223b613a313a7b733a33323a226365666130346631333332666234653363373631306164383830303965343031223b733a33323a223263633165663037316536393739326165653664396436333637326234303766223b7d733a343a2268617368223b733a36353a2232636331656630373165363937393261656536643964363336373262343037662d6365666130346631333332666234653363373631306164383830303965343031223b7d733a343a22666c6167223b693a323b733a31333a226974657261746f72436c617373223b733a31333a2241727261794974657261746f72223b733a31393a2270726f74656374656450726f70657274696573223b613a343a7b693a303b733a373a2273746f72616765223b693a313b733a343a22666c6167223b693a323b733a31333a226974657261746f72436c617373223b693a333b733a31393a2270726f74656374656450726f70657274696573223b7d7d, 1793787495),
('7aptlf6hi5opt5sral41t01ubl', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333837303934302e3136333936313b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a22376170746c66366869356f7074357372616c343174303175626c223b7d7d, 1793870940),
('7beguf7jdk6jp0njoebf0hgcuo', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333838393435332e3633373730393b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a22376265677566376a646b366a70306e6a6f65626630686763756f223b7d7d, 1793889453),
('7ecbbfc1md1fmbn8icr4lqpf75', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333839333538342e3435333638393b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a2237656362626663316d6431666d626e38696372346c7170663735223b7d7d, 1793893584),
('7h8enajh5c097u953fb2qq1upg', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333838383839362e3939373936333b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a22376838656e616a68356330393775393533666232717131757067223b7d7d, 1793888897),
('7iaid3huh6kc1ol0i7ue7tpfr8', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333934343833392e3833363837393b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a22376961696433687568366b63316f6c3069377565377470667238223b7d7d, 1793944839),
('7ivj0r5infhskiscgo8hn5g3r4', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333837313432312e3831393930343b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a223769766a307235696e6668736b697363676f38686e3567337234223b7d7d, 1793871421),
('7ju4hdv0j72mjvl7bdg4de82me', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333837333833352e3234383237383b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a22376a7534686476306a37326d6a766c3762646734646538326d65223b7d7d, 1793873835),
('7k2ml98m9p5mtv17u6g4fu34d8', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333839383131332e3838363735333b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a22376b326d6c39386d3970356d7476313775366734667533346438223b7d7d, 1793898113),
('7l7p38972dm4l3ktgv3nfa9qi7', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333739313735322e3036363831333b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a22376c37703338393732646d346c336b746776336e666139716937223b7d7d, 1793791752),
('7qbd41rujk1ijmjaolrcqml562', 0x5f5f4c616d696e61737c613a333a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333837313436332e3739323333373b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a2237716264343172756a6b31696a6d6a616f6c7263716d6c353632223b7d733a34323a224c616d696e61735f56616c696461746f725f437372665f73616c745f6c6f67696e666f726d5f63737266223b613a313a7b733a363a22455850495245223b693a313739333931343636333b7d7d72656469726563745f75726c7c733a34373a22687474703a2f2f6c6f63616c686f73742f6f6d6b5f6f6e746f657468697175652f61646d696e2f6974656d2f313235223b4c616d696e61735f56616c696461746f725f437372665f73616c745f6c6f67696e666f726d5f637372667c4f3a32363a224c616d696e61735c5374646c69625c41727261794f626a656374223a343a7b733a373a2273746f72616765223b613a323a7b733a393a22746f6b656e4c697374223b613a333a7b733a33323a226263343665306634303664376237396232323065663136376432383536623563223b733a33323a223465376136396334616538306231366163653230343533366636336538373761223b733a33323a226264383730363833613338623038393235336636633761303037316331323466223b733a33323a223534633066333834643436353934636138393365373232363934383037353363223b733a33323a223562393565373666303632623036313366306337656635643037366635643535223b733a33323a226431396238323039393334333264643635343931313261376437386239313463223b7d733a343a2268617368223b733a36353a2264313962383230393933343332646436353439313132613764373862393134632d3562393565373666303632623036313366306337656635643037366635643535223b7d733a343a22666c6167223b693a323b733a31333a226974657261746f72436c617373223b733a31333a2241727261794974657261746f72223b733a31393a2270726f74656374656450726f70657274696573223b613a343a7b693a303b733a373a2273746f72616765223b693a313b733a343a22666c6167223b693a323b733a31333a226974657261746f72436c617373223b693a333b733a31393a2270726f74656374656450726f70657274696573223b7d7d, 1793871463),
('7qmpr7k1o748qefi3q8bh1vug0', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333835393032312e3930323037323b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a2237716d7072376b316f3734387165666933713862683176756730223b7d7d, 1793859021),
('7u953o00abmv898uk71up46l1a', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333835393434332e3936373736333b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a2237753935336f303061626d76383938756b3731757034366c3161223b7d7d, 1793859443),
('7ukdf416scbc46dnkcsa5bcqbj', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333739313933302e3631393736363b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a2237756b6466343136736362633436646e6b63736135626371626a223b7d7d72656469726563745f75726c7c733a34363a22687474703a2f2f6c6f63616c686f73742f6f6d6b5f6f6e746f657468697175652f61646d696e2f6974656d2f3433223b, 1793791930),
('81gl7rnhge1ndgsjv232pnvotv', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333838393532312e3338363030363b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a223831676c37726e686765316e6467736a76323332706e766f7476223b7d7d, 1793889521),
('8e51n6p53a88afpn2ob0fhmiss', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333837313736382e3537343236383b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a22386535316e367035336138386166706e326f623066686d697373223b7d7d, 1793871769),
('8ebiuae2jfsomgcn5649np2cns', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333737343539382e3539353736353b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a2238656269756165326a66736f6d67636e353634396e7032636e73223b7d7d, 1793774598),
('8ehs5eoq6omfogl32tc90hn46o', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333837343830352e3836313833343b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a223865687335656f71366f6d666f676c333274633930686e34366f223b7d7d, 1793874805),
('8f4ebfff146j027i7cjnmb6ulm', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333934353734372e3037333132343b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a2238663465626666663134366a3032376937636a6e6d6236756c6d223b7d7d, 1793945747),
('8gtoenqaucmarm5plh2p4td6j4', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333839333336372e3630313233353b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a223867746f656e716175636d61726d35706c683270347464366a34223b7d7d, 1793893367),
('8i5oqk48ek4mnplmkdscpmvibq', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333837303739382e3531383633343b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a223869356f716b3438656b346d6e706c6d6b647363706d76696271223b7d7d, 1793870799),
('8n7246iialptif06u41e1t9hra', 0x5f5f4c616d696e61737c613a353a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333935393531362e3931383131343b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a22313061353470696d376c68626b6c3268626771693476396e3365223b7d733a34323a224c616d696e61735f56616c696461746f725f437372665f73616c745f6c6f67696e666f726d5f63737266223b613a313a7b733a363a22455850495245223b693a313739333834393230363b7d733a33323a224c616d696e61735f56616c696461746f725f437372665f73616c745f63737266223b613a313a7b733a363a22455850495245223b693a313739343030323731363b7d733a34343a224c616d696e61735f56616c696461746f725f437372665f73616c745f636f6e6669726d666f726d5f63737266223b613a313a7b733a363a22455850495245223b693a313739333931353437313b7d7d72656469726563745f75726c7c733a34363a22687474703a2f2f6c6f63616c686f73742f6f6d6b5f6f6e746f657468697175652f61646d696e2f6974656d2f3433223b4c616d696e61735f56616c696461746f725f437372665f73616c745f6c6f67696e666f726d5f637372667c4f3a32363a224c616d696e61735c5374646c69625c41727261794f626a656374223a343a7b733a373a2273746f72616765223b613a323a7b733a393a22746f6b656e4c697374223b613a313a7b733a33323a223964366337306235313761353036363962363437323237633262383839666238223b733a33323a223562643462373630356637333235613161633536313963376136323564333530223b7d733a343a2268617368223b733a36353a2235626434623736303566373332356131616335363139633761363235643335302d3964366337306235313761353036363962363437323237633262383839666238223b7d733a343a22666c6167223b693a323b733a31333a226974657261746f72436c617373223b733a31333a2241727261794974657261746f72223b733a31393a2270726f74656374656450726f70657274696573223b613a343a7b693a303b733a373a2273746f72616765223b693a313b733a343a22666c6167223b693a323b733a31333a226974657261746f72436c617373223b693a333b733a31393a2270726f74656374656450726f70657274696573223b7d7d4c616d696e61735f417574687c4f3a32363a224c616d696e61735c5374646c69625c41727261794f626a656374223a343a7b733a373a2273746f72616765223b613a313a7b733a373a2273746f72616765223b693a313b7d733a343a22666c6167223b693a323b733a31333a226974657261746f72436c617373223b733a31333a2241727261794974657261746f72223b733a31393a2270726f74656374656450726f70657274696573223b613a343a7b693a303b733a373a2273746f72616765223b693a313b733a343a22666c6167223b693a323b733a31333a226974657261746f72436c617373223b693a333b733a31393a2270726f74656374656450726f70657274696573223b7d7d4f6d656b614d657373656e6765727c4f3a32363a224c616d696e61735c5374646c69625c41727261794f626a656374223a343a7b733a373a2273746f72616765223b613a303a7b7d733a343a22666c6167223b693a323b733a31333a226974657261746f72436c617373223b733a31333a2241727261794974657261746f72223b733a31393a2270726f74656374656450726f70657274696573223b613a343a7b693a303b733a373a2273746f72616765223b693a313b733a343a22666c6167223b693a323b733a31333a226974657261746f72436c617373223b693a333b733a31393a2270726f74656374656450726f70657274696573223b7d7d4c616d696e61735f56616c696461746f725f437372665f73616c745f637372667c4f3a32363a224c616d696e61735c5374646c69625c41727261794f626a656374223a343a7b733a373a2273746f72616765223b613a323a7b733a393a22746f6b656e4c697374223b613a313a7b733a33323a223064336164346464633230663138343231383534623038643833346638363535223b733a33323a223130646439656131393033653331356338653335643032636338346539636461223b7d733a343a2268617368223b733a36353a2231306464396561313930336533313563386533356430326363383465396364612d3064336164346464633230663138343231383534623038643833346638363535223b7d733a343a22666c6167223b693a323b733a31333a226974657261746f72436c617373223b733a31333a2241727261794974657261746f72223b733a31393a2270726f74656374656450726f70657274696573223b613a343a7b693a303b733a373a2273746f72616765223b693a313b733a343a22666c6167223b693a323b733a31333a226974657261746f72436c617373223b693a333b733a31393a2270726f74656374656450726f70657274696573223b7d7d4c616d696e61735f56616c696461746f725f437372665f73616c745f636f6e6669726d666f726d5f637372667c4f3a32363a224c616d696e61735c5374646c69625c41727261794f626a656374223a343a7b733a373a2273746f72616765223b613a323a7b733a393a22746f6b656e4c697374223b613a31333a7b733a33323a226239363864373534636164656536343332646665373935636330373835656364223b733a33323a223637613934303766636365323565666461363738636238626337303033646363223b733a33323a223864613864636663656161326663653339376538313837663439363738646437223b733a33323a226266303365313633653137646565643937323562643765636639343939376563223b733a33323a226332653032663634303632383465663366383036376664663134633133316636223b733a33323a223561306437353833386239366634336662633265393032363034373966633536223b733a33323a226266306131613031633037326265633331643862383363323762376238366630223b733a33323a223561366630343937633239626364303438313732616233636138623539356565223b733a33323a223034616466626336383632656661623838313739623961623766653732326331223b733a33323a223634346466653662343163613265643439353538643334613062643739616239223b733a33323a223539343137313136613732323436626232623231363966613766663965393564223b733a33323a223931373766316630663062633336323230633437623033396261343363623138223b733a33323a223361386662313964356438613037336537343437623435306565363862643133223b733a33323a223135336633356664313631323039383834303538633733366366333063333730223b733a33323a223136376534366465313230633534656161343066636366663364633165643736223b733a33323a226538313032633139306361326133383764623563363035393631343338643837223b733a33323a223032303366616636346236313639386539306263323132643366363965313033223b733a33323a226535383765333031326263386330646137623762353632636266326232393339223b733a33323a223937346233356130663733373630656630356439373432383730346236336261223b733a33323a226131303531306162386437333062393665363966303939666462386261363566223b733a33323a223437316465643434386264666435616366623966343833373063323636666432223b733a33323a226165663833656232623134373166303035333864343733333063366535643265223b733a33323a226632343633666365396234303962356261623537646138663236343631666362223b733a33323a223436356138356538663131356132393738663533633934316162353034346633223b733a33323a223735323465393733343639383763613237353833373537643134303432643539223b733a33323a226236303265616437363030366239376338333734633334376537303266336231223b7d733a343a2268617368223b733a36353a2262363032656164373630303662393763383337346333343765373032663362312d3735323465393733343639383763613237353833373537643134303432643539223b7d733a343a22666c6167223b693a323b733a31333a226974657261746f72436c617373223b733a31333a2241727261794974657261746f72223b733a31393a2270726f74656374656450726f70657274696573223b613a343a7b693a303b733a373a2273746f72616765223b693a313b733a343a22666c6167223b693a323b733a31333a226974657261746f72436c617373223b693a333b733a31393a2270726f74656374656450726f70657274696573223b7d7d4561737941646d696e7c4f3a32363a224c616d696e61735c5374646c69625c41727261794f626a656374223a343a7b733a373a2273746f72616765223b613a323a7b733a31343a226c61737442726f77736550616765223b613a313a7b733a353a2261646d696e223b613a313a7b733a353a226974656d73223b733a33343a222f6f6d6b5f6f6e746f657468697175652f61646d696e2f6974656d3f706167653d32223b7d7d733a393a226c6173745175657279223b613a313a7b733a353a2261646d696e223b613a313a7b733a353a226974656d73223b613a353a7b733a343a2270616765223b733a313a2232223b733a31353a22736f72745f62795f64656661756c74223b733a303a22223b733a31383a22736f72745f6f726465725f64656661756c74223b733a303a22223b733a373a22736f72745f6279223b733a323a226964223b733a31303a22736f72745f6f72646572223b733a343a2264657363223b7d7d7d7d733a343a22666c6167223b693a323b733a31333a226974657261746f72436c617373223b733a31333a2241727261794974657261746f72223b733a31393a2270726f74656374656450726f70657274696573223b613a343a7b693a303b733a373a2273746f72616765223b693a313b733a343a22666c6167223b693a323b733a31333a226974657261746f72436c617373223b693a333b733a31393a2270726f74656374656450726f70657274696573223b7d7d, 1793959516),
('8pcvd6lfgpk4b5mbbg2k3jj9iv', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333837333637312e3939333738383b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a223870637664366c6667706b3462356d626267326b336a6a396976223b7d7d, 1793873672),
('8rbdjrh9hgdbi671egkf3hhb5g', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333738373737392e3433383031313b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a22387262646a726839686764626936373165676b66336868623567223b7d7d, 1793787779),
('8t70gplipmnr1jk87ufgf3it2j', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333738373737382e3337323835393b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a223874373067706c69706d6e72316a6b383775666766336974326a223b7d7d, 1793787778),
('8va3el3uqt72fu2jl30eal4von', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333739323830392e3935383833323b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a2238766133656c3375717437326675326a6c333065616c34766f6e223b7d7d, 1793792809),
('92bk8sg2lrr2sltskfo2mo63pc', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333837343737382e39353338333b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a223932626b387367326c727232736c74736b666f326d6f36337063223b7d7d, 1793874778),
('948if596dmebhvfsq0sb8laa36', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333934333338322e3035323833333b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a223934386966353936646d65626876667371307362386c61613336223b7d7d, 1793943382),
('96pj47f9mqs0jgi0ovpc2rj5nt', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333737343732342e30313334393b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a223936706a343766396d7173306a6769306f76706332726a356e74223b7d7d, 1793774724),
('982gfc8gpoplenk6ansugii8ei', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333838383336322e3132383836343b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a223938326766633867706f706c656e6b36616e7375676969386569223b7d7d, 1793888362),
('9aavlaundac0mgvhu3soj7arjj', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333738373438382e3331343133333b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a22396161766c61756e646163306d6776687533736f6a3761726a6a223b7d7d72656469726563745f75726c7c733a34353a22687474703a2f2f6c6f63616c686f73742f6f6d6b5f6f6e746f657468697175652f61646d696e2f6974656d2f31223b, 1793787488),
('9acs8frsnbl3clcaiv96aaor7j', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333838383839392e3033343133343b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a2239616373386672736e626c33636c63616976393661616f72376a223b7d7d, 1793888899),
('9anssfkq1ir6vrf6f3iuevg955', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333934363536342e3034383236373b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a2239616e7373666b71316972367672663666336975657667393535223b7d7d, 1793946564),
('9bc48lgihvkqa6d6puvf8k9ig9', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333837303933322e3137373939353b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a2239626334386c676968766b716136643670757666386b39696739223b7d7d, 1793870932),
('9fogqdkr07hqa4n8f1hjld2nm0', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333837333637312e3331363337333b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a2239666f6771646b723037687161346e386631686a6c64326e6d30223b7d7d, 1793873671),
('9g2s57p09s1bvfu1fa0hdokg0d', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333839333530332e3636323937343b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a223967327335377030397331627666753166613068646f6b673064223b7d7d, 1793893503),
('9g47jjefha9aa3arqfko9bfsrp', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333838373334342e3231303831363b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a22396734376a6a6566686139616133617271666b6f396266737270223b7d7d, 1793887344),
('9gsc5g62epqh5qsaacg7osdsqs', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333836353237352e36333236323b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a2239677363356736326570716835717361616367376f7364737173223b7d7d, 1793865275),
('9hbs2eaf0s8oqovcblnh47g94a', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333934333733382e3338393830323b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a2239686273326561663073386f716f7663626c6e68343767393461223b7d7d, 1793943738),
('9kmdq73a95atc2c3kbf18e7ec3', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333839323232382e3139313033383b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a22396b6d647137336139356174633263336b626631386537656333223b7d7d, 1793892228),
('9li66gf9c5v7qsglhco3q76qe7', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333837303933342e3337313339393b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a22396c693636676639633576377173676c68636f33713736716537223b7d7d, 1793870934),
('9vg0p4sb3vpfmkm6ilmg675108', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333837333635372e3830343032363b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a223976673070347362337670666d6b6d36696c6d67363735313038223b7d7d, 1793873657),
('a2aj7he949imjqodk6rni50b2r', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333837313032342e3037393531373b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a226132616a376865393439696d6a716f646b36726e693530623272223b7d7d, 1793871024),
('a5774ibtj4avgcpdb7emldfi4n', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333830353135302e3636373939343b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a2261353737346962746a346176676370646237656d6c646669346e223b7d7d72656469726563745f75726c7c733a34363a22687474703a2f2f6c6f63616c686f73742f6f6d6b5f6f6e746f657468697175652f61646d696e2f6974656d2f3433223b, 1793805150),
('a8tuasiqvf6edacacrtdju070b', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333839363939332e3135313034333b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a2261387475617369717666366564616361637274646a7530373062223b7d7d, 1793896993),
('abdgnjrg3macvpfk51pdpmddni', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333837333739352e3834313438393b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a22616264676e6a7267336d61637670666b35317064706d64646e69223b7d7d, 1793873795),
('af0l8c3fq6dgt1lcfl1qvv1fel', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333934343833372e3538333032313b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a226166306c386333667136646774316c63666c317176763166656c223b7d7d, 1793944837),
('an5hvdftaih2quv4uobgialbnc', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333837313031302e32343631393b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a22616e3568766466746169683271757634756f626769616c626e63223b7d7d, 1793871010),
('artl4cqre2mpbskfvmled06jjd', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333739323230362e3637323939383b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a226172746c3463717265326d7062736b66766d6c656430366a6a64223b7d7d, 1793792206),
('b0uql0smfso5m9em8drevsllll', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333739323736332e3738313238333b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a22623075716c30736d66736f356d39656d3864726576736c6c6c6c223b7d7d, 1793792763),
('b0v8erld55o5habkosbobadjta', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333839383135352e3536373332343b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a226230763865726c6435356f356861626b6f73626f6261646a7461223b7d7d, 1793898155),
('b1cd3a1gd2kksjljtp3fhb3li2', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333838393532322e3038363631323b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a22623163643361316764326b6b736a6c6a747033666862336c6932223b7d7d, 1793889522),
('b1onod2ea4vgf234v27du83auu', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333839323133382e3236353138353b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a2262316f6e6f643265613476676632333476323764753833617575223b7d7d, 1793892138),
('b37939edb2113enfokfl403dg8', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333937363332382e3835343738363b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a2262333739333965646232313133656e666f6b666c343033646738223b7d7d, 1793976328),
('b584nmlsei6t2m1i3924ul3iah', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333934343836302e3431333735313b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a22623538346e6d6c7365693674326d316933393234756c33696168223b7d7d, 1793944860),
('b5haq46gejagb62ep67r678fqq', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333830363433372e3830313835393b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a226235686171343667656a61676236326570363772363738667171223b7d7d, 1793806437),
('b6ql0brgmdg4kj68r94tt1ksmu', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333839383038332e3331373130333b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a226236716c306272676d6467346b6a36387239347474316b736d75223b7d7d, 1793898083),
('b7e3b48l8p5ep9iuijeal10dgf', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333934353431322e3131333438383b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a22623765336234386c3870356570396975696a65616c3130646766223b7d7d, 1793945412),
('bcpnicd3lpdm41vqpacsa3r9cd', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333836393233372e31323332343b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a226263706e696364336c70646d3431767170616373613372396364223b7d7d, 1793869237),
('bf5akas8op8oln5l9tagfgnc83', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333530393039332e37313736353b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a22626635616b6173386f70386f6c6e356c3974616766676e633833223b7d7d, 1793509093),
('bfbcgp4psu08iu53vbmaucp3es', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333837303939372e35353233333b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a226266626367703470737530386975353376626d61756370336573223b7d7d, 1793870997),
('bjpsg73uosf5gqb6i20llva1d9', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333839333336352e3833363832343b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a22626a7073673733756f736635677162366932306c6c7661316439223b7d7d, 1793893365),
('bkuqh4ih5g5cj83sogm6jj2q3r', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333839333337322e3839393830353b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a22626b757168346968356735636a3833736f676d366a6a32713372223b7d7d, 1793893372),
('bnp78c7mn46c8o6868j7i6fkgc', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333838383930362e3238323131333b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a22626e70373863376d6e343663386f363836386a376936666b6763223b7d7d, 1793888906),
('bojgdk0lgjhfchfnekfi4qtp6t', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333934333536372e3739343234393b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a22626f6a67646b306c676a68666368666e656b6669347174703674223b7d7d, 1793943567),
('bpsij7bsr6vf2r5aafo0qekvab', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333837333739352e3035313138363b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a22627073696a376273723676663272356161666f3071656b766162223b7d7d, 1793873795),
('bt5qdo42l4ulec4svrg53lda8n', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333935383335382e32333338343b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a2262743571646f34326c34756c6563347376726735336c6461386e223b7d7d, 1793958358),
('btl7ae8q0agj6vjsquakcm5igo', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333934353339382e3337393731363b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a2262746c37616538713061676a36766a737175616b636d3569676f223b7d7d, 1793945398),
('c489d6fnhr2pdqh0hnrkeq9ev7', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333738373835382e3936363536313b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a22633438396436666e6872327064716830686e726b657139657637223b7d7d, 1793787858),
('c8g39e2q3qb25sqh4ofhf7i9lg', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333837303938352e3932353834343b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a2263386733396532713371623235737168346f6668663769396c67223b7d7d, 1793870985),
('c9lq1v8tkdc48h1ri28ns6pe32', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333839323231302e3232333733333b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a2263396c71317638746b646334386831726932386e733670653332223b7d7d, 1793892210),
('cbhulnmcbtmd5ne97qjdib9k0s', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333839373437382e3535353935333b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a22636268756c6e6d6362746d64356e653937716a646962396b3073223b7d7d, 1793897478),
('chd31l8mnaiorgc51mm4agrvpk', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333934353136392e3837363931323b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a2263686433316c386d6e61696f72676335316d6d3461677276706b223b7d7d, 1793945169),
('cht4qg901nf1dld27msoqcgbes', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333839323237392e3136383530373b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a226368743471673930316e6631646c6432376d736f716367626573223b7d7d, 1793892279),
('civ6gffkunjo1393e2h50u1snv', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333837303936352e3834343236343b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a22636976366766666b756e6a6f3133393365326835307531736e76223b7d7d, 1793870965),
('cjvggq0uhlpvn9r6ohnu1npnnb', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333837313432352e3535333233383b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a22636a766767713075686c70766e3972366f686e75316e706e6e62223b7d7d, 1793871425),
('ckjgkotetqbnppunpj1rftqggt', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333837313737302e3839373431323b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a22636b6a676b6f74657471626e7070756e706a3172667471676774223b7d7d, 1793871770),
('ckn4toqbinsacmdkija7kg7ul7', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333838393432302e3232303939323b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a22636b6e34746f7162696e7361636d646b696a61376b6737756c37223b7d7d, 1793889420),
('cnonpl4j1n1pfkd42paaadqt6h', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333838373235372e3630313732373b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a22636e6f6e706c346a316e3170666b643432706161616471743668223b7d7d, 1793887257),
('coep2jdg9vpbgupri0npnq5ek9', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333837303935372e3431333734383b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a22636f6570326a6467397670626775707269306e706e7135656b39223b7d7d, 1793870957),
('cq0hjoqodvp4g52664hqki4jb9', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333838393431332e3132353830333b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a22637130686a6f716f6476703467353236363468716b69346a6239223b7d7d, 1793889413),
('ctii1cicep6bspajtp6bklf9r9', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333837303934312e39303633363b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a226374696931636963657036627370616a747036626b6c66397239223b7d7d, 1793870941),
('cv7gru447hsv4s864l7tnnfb99', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333839323237382e3639383130343b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a2263763767727534343768737634733836346c37746e6e66623939223b7d7d, 1793892278),
('cvbvnuooih5oauhp430vf1q6p5', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333839373431352e3938373733313b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a22637662766e756f6f6968356f6175687034333076663171367035223b7d7d, 1793897416),
('d2nbkd0v4t7iqb1ascsn64nf7q', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333839333334362e3836353331363b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a2264326e626b64307634743769716231617363736e36346e663771223b7d7d, 1793893346),
('d3tg3aehqdvk8uec27klhmi4v2', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333934373331392e3336373332323b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a2264337467336165687164766b3875656332376b6c686d69347632223b7d7d, 1793947319),
('d5c7q8ivvo4iuj3tpua3pk198k', 0x5f5f4c616d696e61737c613a333a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333830353232342e3234333138353b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a223532666934306b31346a636433616e62667069636a69316e6238223b7d733a34323a224c616d696e61735f56616c696461746f725f437372665f73616c745f6c6f67696e666f726d5f63737266223b613a313a7b733a363a22455850495245223b693a313739333834383432343b7d7d4c616d696e61735f56616c696461746f725f437372665f73616c745f6c6f67696e666f726d5f637372667c4f3a32363a224c616d696e61735c5374646c69625c41727261794f626a656374223a343a7b733a373a2273746f72616765223b613a323a7b733a393a22746f6b656e4c697374223b613a323a7b733a33323a223963326363663338656162373539393664313834653334663436326639393534223b733a33323a223566323338346236376533613537326365306139373933666533616232353435223b733a33323a223633616164336662616632643461373665343464656233613735336635346365223b733a33323a223835613731633432616132303730353638323636656365303436346263393734223b7d733a343a2268617368223b733a36353a2238356137316334326161323037303536383236366563653034363462633937342d3633616164336662616632643461373665343464656233613735336635346365223b7d733a343a22666c6167223b693a323b733a31333a226974657261746f72436c617373223b733a31333a2241727261794974657261746f72223b733a31393a2270726f74656374656450726f70657274696573223b613a343a7b693a303b733a373a2273746f72616765223b693a313b733a343a22666c6167223b693a323b733a31333a226974657261746f72436c617373223b693a333b733a31393a2270726f74656374656450726f70657274696573223b7d7d4f6d656b614d657373656e6765727c4f3a32363a224c616d696e61735c5374646c69625c41727261794f626a656374223a343a7b733a373a2273746f72616765223b613a303a7b7d733a343a22666c6167223b693a323b733a31333a226974657261746f72436c617373223b733a31333a2241727261794974657261746f72223b733a31393a2270726f74656374656450726f70657274696573223b613a343a7b693a303b733a373a2273746f72616765223b693a313b733a343a22666c6167223b693a323b733a31333a226974657261746f72436c617373223b693a333b733a31393a2270726f74656374656450726f70657274696573223b7d7d, 1793805224),
('d6fuhe924hb5oh4kp4fjlgupb9', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333839333336372e33353831373b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a226436667568653932346862356f68346b7034666a6c6775706239223b7d7d, 1793893367),
('d84em15k0pmk4mjlochlu3a5gu', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333837343334332e3939383432383b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a22643834656d31356b30706d6b346d6a6c6f63686c753361356775223b7d7d, 1793874344),
('d8h1pi1l0mdc26qq0uj7plubu1', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333838383030342e3134363038343b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a22643868317069316c306d64633236717130756a37706c75627531223b7d7d, 1793888004),
('d8lur89ih61sbi2vcinumve5gv', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333837343739382e3536363736333b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a2264386c7572383969683631736269327663696e756d7665356776223b7d7d, 1793874798),
('dajh6m1ii8nnqrk4iaum6te3oe', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333839323134362e3136353431313b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a2264616a68366d316969386e6e71726b346961756d367465336f65223b7d7d, 1793892146),
('dcl519lsb2ba9fe1qhadd4s6lq', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333837303933372e3032373230313b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a2264636c3531396c73623262613966653171686164643473366c71223b7d7d, 1793870937),
('dd4uskhh3s2do3gq704k5brbno', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333934333735332e3336343339383b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a2264643475736b6868337332646f3367713730346b356272626e6f223b7d7d, 1793943753),
('dgagpv26qk3e8gh9ctq8i4uueq', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333837303933312e3236333332313b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a226467616770763236716b33653867683963747138693475756571223b7d7d, 1793870931),
('dl0s7cqh5nfs1b53jdaja3ngkl', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333837343136322e3931303936313b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a22646c307337637168356e6673316235336a64616a61336e676b6c223b7d7d, 1793874162),
('dn7g21she5m0eehhothf7vrd53', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333838383135382e3739353738333b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a22646e37673231736865356d30656568686f746866377672643533223b7d7d, 1793888158),
('do0ptrdforoki30vvfp5a14f8c', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333934363135332e363338343b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a22646f3070747264666f726f6b6933307676667035613134663863223b7d7d, 1793946153),
('dqhkt51at7ik8iv2st80oq1gl0', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333838373333382e3438333634373b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a226471686b743531617437696b38697632737438306f7131676c30223b7d7d, 1793887338),
('dqoo6kg8472mfvnu3g3afhprj8', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333934373339362e3831323538343b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a2264716f6f366b67383437326d66766e7533673361666870726a38223b7d7d, 1793947396);
INSERT INTO `session` (`id`, `data`, `modified`) VALUES
('dveuaurho5q598uggpva1tajs2', 0x5f5f4c616d696e61737c613a333a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333739313833342e38383539393b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a2264766575617572686f35713539387567677076613174616a7332223b7d733a34323a224c616d696e61735f56616c696461746f725f437372665f73616c745f6c6f67696e666f726d5f63737266223b613a313a7b733a363a22455850495245223b693a313739333833353033343b7d7d4f6d656b614d657373656e6765727c4f3a32363a224c616d696e61735c5374646c69625c41727261794f626a656374223a343a7b733a373a2273746f72616765223b613a303a7b7d733a343a22666c6167223b693a323b733a31333a226974657261746f72436c617373223b733a31333a2241727261794974657261746f72223b733a31393a2270726f74656374656450726f70657274696573223b613a343a7b693a303b733a373a2273746f72616765223b693a313b733a343a22666c6167223b693a323b733a31333a226974657261746f72436c617373223b693a333b733a31393a2270726f74656374656450726f70657274696573223b7d7d4c616d696e61735f56616c696461746f725f437372665f73616c745f6c6f67696e666f726d5f637372667c4f3a32363a224c616d696e61735c5374646c69625c41727261794f626a656374223a343a7b733a373a2273746f72616765223b613a323a7b733a393a22746f6b656e4c697374223b613a313a7b733a33323a226230616464633564643334613162376238626236663837666561616131316161223b733a33323a223734396462326233393136333530343330653934646465323939386562303664223b7d733a343a2268617368223b733a36353a2237343964623262333931363335303433306539346464653239393865623036642d6230616464633564643334613162376238626236663837666561616131316161223b7d733a343a22666c6167223b693a323b733a31333a226974657261746f72436c617373223b733a31333a2241727261794974657261746f72223b733a31393a2270726f74656374656450726f70657274696573223b613a343a7b693a303b733a373a2273746f72616765223b693a313b733a343a22666c6167223b693a323b733a31333a226974657261746f72436c617373223b693a333b733a31393a2270726f74656374656450726f70657274696573223b7d7d, 1793791834),
('e7sl1j0gv48kl458ecvh80gk3u', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333837343830362e3631383937353b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a226537736c316a30677634386b6c343538656376683830676b3375223b7d7d, 1793874806),
('elmhvdmv8uv46etbb4udbui972', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333836393230372e3430333631353b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a22656c6d6876646d76387576343665746262347564627569393732223b7d7d, 1793869207),
('ems6afol0h3o4njirr3p1i18er', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333839363936312e3835343236343b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a22656d733661666f6c3068336f346e6a6972723370316931386572223b7d7d, 1793896961),
('ep0ltafnqj9a51h1pkuo2o0a32', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333837343739382e3933383133363b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a226570306c7461666e716a396135316831706b756f326f30613332223b7d7d, 1793874798),
('esto7mbca9rrk5b08g2dtjm838', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333934363337362e3137383832333b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a226573746f376d6263613972726b35623038673264746a6d383338223b7d7d, 1793946376),
('f0g5u2p6ug6qbqj2g969m1ebh1', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333936323631392e3739363831373b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a2266306735753270367567367162716a32673936396d3165626831223b7d7d, 1793962619),
('f2t0hkpsomjoj3pmi20hbnidkv', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333839333333382e3933343133393b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a2266327430686b70736f6d6a6f6a33706d69323068626e69646b76223b7d7d, 1793893338),
('f32r0alk7g4ljgt2vvmtnhcap2', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333839333539302e3635393938393b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a226633327230616c6b3767346c6a67743276766d746e6863617032223b7d7d, 1793893590),
('f7jqfsvk5rt27hp6hkfvtk25rh', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333839323133382e3632373931393b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a2266376a716673766b3572743237687036686b6676746b32357268223b7d7d, 1793892138),
('f7sbtt2d0c92rb2v1u9pb06uf5', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333739313831352e3831313132353b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a226637736274743264306339327262327631753970623036756635223b7d7d, 1793791815),
('fcj3761r8jpp8fqd169i6pr0h3', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333837303933352e3634323635363b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a2266636a3337363172386a70703866716431363969367072306833223b7d7d, 1793870935),
('fg15ft28u02kn976hemoqt7hdo', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333934333334342e3534323930323b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a2266673135667432387530326b6e39373668656d6f71743768646f223b7d7d, 1793943344),
('fm05ovuibqa6lidg2nlnj4e81b', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333839333335302e33383938383b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a22666d30356f767569627161366c696467326e6c6e6a3465383162223b7d7d, 1793893350),
('fm5jdshimn9u22t2mmvbkc3sde', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333934363134392e3131393035353b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a22666d356a647368696d6e3975323274326d6d76626b6333736465223b7d7d, 1793946149),
('fqrch0h5q1o7jd2j22rm4bmpke', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333839333334372e3434373339333b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a22667172636830683571316f376a64326a3232726d34626d706b65223b7d7d, 1793893347),
('fqrctc2hnd6mc3ubbmah1j83pc', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333838383134382e3332393330393b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a2266717263746332686e64366d63337562626d6168316a38337063223b7d7d, 1793888148),
('fthjdfemohcm4sfsdn3mb8qfm6', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333836393233352e3231323333363b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a226674686a6466656d6f68636d34736673646e336d623871666d36223b7d7d, 1793869235),
('futr8d7e66vqqe9b0mp0dvr3nu', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333839333539302e3930313236353b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a2266757472386437653636767171653962306d7030647672336e75223b7d7d, 1793893590),
('gclqoa617r9dfalp2n707spq55', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333934363333362e3239383332383b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a2267636c716f6136313772396466616c70326e3730377370713535223b7d7d, 1793946336),
('gf8v4hp8ji9nuul91s4i3v6lis', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333836353237352e3938363836343b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a2267663876346870386a69396e75756c39317334693376366c6973223b7d7d, 1793865276),
('gfhdroaa7sq8j382hdbs8i36to', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333837313736322e3637343939353b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a2267666864726f6161377371386a3338326864627338693336746f223b7d7d, 1793871762),
('ghc16kr096uik6tk38su95k63t', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333739323739362e3139323438323b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a2267686331366b7230393675696b36746b3338737539356b363374223b7d7d, 1793792796),
('gkhhopbokn80oc89de1cr33ff0', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333838383839392e3339303432313b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a22676b68686f70626f6b6e38306f63383964653163723333666630223b7d7d, 1793888899),
('gp06pds25a04aibo8pa9k7mq9r', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333837333831362e3433343632343b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a226770303670647332356130346169626f387061396b376d713972223b7d7d, 1793873816),
('gpp49sehgl4pb9q30auf1gc2sr', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333738373736392e3731303336383b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a226770703439736568676c34706239713330617566316763327372223b7d7d, 1793787769),
('h11idt6cg2hgarlcqk9ceoqnov', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333838383134372e3936383033363b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a2268313169647436636732686761726c63716b3963656f716e6f76223b7d7d, 1793888147),
('h4qsup1kal9p358vnl78np5hfe', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333839333530332e39313032363b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a22683471737570316b616c3970333538766e6c37386e7035686665223b7d7d, 1793893503),
('h51p0rfpvbj7v61l2a4hh0u2k6', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333934343836342e3639313635373b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a22683531703072667076626a377636316c32613468683075326b36223b7d7d, 1793944865),
('h7ak2lm8db4hriu9j6u26o6727', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333837313031342e3730363734363b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a226837616b326c6d3864623468726975396a367532366f36373237223b7d7d, 1793871014),
('havurk5djgo2g56ktvh2b95luj', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333837303938322e32383735373b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a2268617675726b35646a676f326735366b747668326239356c756a223b7d7d, 1793870982),
('hc0agli5kscc3msbdi6ddblhcc', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333837333834312e3630313539353b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a2268633061676c69356b736363336d73626469366464626c686363223b7d7d, 1793873841),
('hgjee4t3h9oqmrns7ahnpfqs2o', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333937383630372e3635303533353b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a2268676a656534743368396f716d726e733761686e70667173326f223b7d7d, 1793978607),
('hj94i524bh17ep1576nfqms1u0', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333839333336362e3431373236313b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a22686a393469353234626831376570313537366e66716d73317530223b7d7d, 1793893366),
('hp5vmduojqmo0c1dnmr5ams2g0', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333934323835312e3438373230343b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a22687035766d64756f6a716d6f306331646e6d7235616d73326730223b7d7d, 1793942851),
('hpgqniih95d3ihjg5d15vg6i1f', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333835383937312e3635343632343b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a22687067716e6969683935643369686a6735643135766736693166223b7d7d, 1793858971),
('hqphpbr9q2lpfg54u7vipb482k', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333839333337322e3431303838323b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a22687170687062723971326c70666735347537766970623438326b223b7d7d, 1793893372),
('hrlbhqsr25qsmg2o2e926onn37', 0x5f5f4c616d696e61737c613a333a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333739313933392e3236343432343b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a2268726c6268717372323571736d67326f32653932366f6e6e3337223b7d733a34323a224c616d696e61735f56616c696461746f725f437372665f73616c745f6c6f67696e666f726d5f63737266223b613a313a7b733a363a22455850495245223b693a313739333833353133393b7d7d4f6d656b614d657373656e6765727c4f3a32363a224c616d696e61735c5374646c69625c41727261794f626a656374223a343a7b733a373a2273746f72616765223b613a303a7b7d733a343a22666c6167223b693a323b733a31333a226974657261746f72436c617373223b733a31333a2241727261794974657261746f72223b733a31393a2270726f74656374656450726f70657274696573223b613a343a7b693a303b733a373a2273746f72616765223b693a313b733a343a22666c6167223b693a323b733a31333a226974657261746f72436c617373223b693a333b733a31393a2270726f74656374656450726f70657274696573223b7d7d4c616d696e61735f56616c696461746f725f437372665f73616c745f6c6f67696e666f726d5f637372667c4f3a32363a224c616d696e61735c5374646c69625c41727261794f626a656374223a343a7b733a373a2273746f72616765223b613a323a7b733a393a22746f6b656e4c697374223b613a313a7b733a33323a226634323332353832363362636136633236386435623134316332346535383463223b733a33323a223161383835303439346630636261626361336337366138633133646531383163223b7d733a343a2268617368223b733a36353a2231613838353034393466306362616263613363373661386331336465313831632d6634323332353832363362636136633236386435623134316332346535383463223b7d733a343a22666c6167223b693a323b733a31333a226974657261746f72436c617373223b733a31333a2241727261794974657261746f72223b733a31393a2270726f74656374656450726f70657274696573223b613a343a7b693a303b733a373a2273746f72616765223b693a313b733a343a22666c6167223b693a323b733a31333a226974657261746f72436c617373223b693a333b733a31393a2270726f74656374656450726f70657274696573223b7d7d, 1793791939),
('hrmik0uqoucne22irrtbfd9bm2', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333838383136352e37343135323b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a2268726d696b3075716f75636e6532326972727462666439626d32223b7d7d, 1793888165),
('ht6kr2leju3v4n0cglgqtbt8s6', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333934353531372e31393535363b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a226874366b72326c656a753376346e3063676c6771746274387336223b7d7d, 1793945517),
('i2av42lotb5n5gii1h2u48hl7t', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333836393230352e3430313536333b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a226932617634326c6f7462356e35676969316832753438686c3774223b7d7d, 1793869205),
('i2ihs8aqnngrpq4vugck9nugmc', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333530393039312e3331313538313b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a2269326968733861716e6e6772707134767567636b396e75676d63223b7d7d, 1793509091),
('i315lge8916edl9g5rgst4or42', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333934333434392e3633383532363b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a22693331356c67653839313665646c39673572677374346f723432223b7d7d, 1793943449),
('i3bptmvafap2ns4ermb2922o5l', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333837303935322e3339343537383b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a2269336270746d7661666170326e733465726d62323932326f356c223b7d7d, 1793870952),
('i43ooub33ctu0cjfihcmsnp9c0', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333837303933302e3435383939313b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a226934336f6f7562333363747530636a666968636d736e70396330223b7d7d, 1793870930),
('i517h39d1iha9hiscs5lauj8de', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333936323630312e31333937383b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a22693531376833396431696861396869736373356c61756a386465223b7d7d, 1793962601),
('i51f8l3nit20fe8lkq7gv1c6ff', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333839343232352e3430383135363b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a2269353166386c336e697432306665386c6b713767763163366666223b7d7d, 1793894225),
('ib3p7a2qii7q52e2i1ovamjid0', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333738373836382e3436383636383b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a226962337037613271696937713532653269316f76616d6a696430223b7d7d, 1793787868),
('ibirid5eu3obs54rka52e3p9rm', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333838373236312e3934333132343b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a22696269726964356575336f62733534726b61353265337039726d223b7d7d, 1793887261),
('iivkt0p3fv2dknuqk4k6npg1bp', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333839333336362e3636303534353b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a226969766b74307033667632646b6e75716b346b366e7067316270223b7d7d, 1793893366),
('ij0256f1353ugos4s5aof5pc1l', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333738373837342e3237303430323b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a22696a30323536663133353375676f73347335616f66357063316c223b7d7d, 1793787874),
('imd6v8tb0hvno4fi5va20c5ql7', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333838383032332e3638343934383b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a22696d6436763874623068766e6f34666935766132306335716c37223b7d7d, 1793888023),
('iq99u15iuq6jvqfet7onmm0fvp', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333837303935302e3035383937373b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a2269713939753135697571366a7671666574376f6e6d6d30667670223b7d7d, 1793870950),
('isg7oa0kfpmfvjcsd93g8kltk8', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333530393038392e3738303836343b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a22697367376f61306b66706d66766a637364393367386b6c746b38223b7d7d, 1793509089),
('iuj6n3sfekoljtqal4dh3snnni', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333830363431382e3533323135313b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a2269756a366e337366656b6f6c6a7471616c34646833736e6e6e69223b7d7d, 1793806419),
('iv0mkv9iqoc4g6t45eghe8h395', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333739313738392e3830383037353b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a226976306d6b763969716f63346736743435656768653868333935223b7d7d, 1793791789),
('j3aj9nksq7h0fifdr07pdivbkg', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333839363939302e3138323133363b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a226a33616a396e6b73713768306669666472303770646976626b67223b7d7d, 1793896990),
('j46tf6enpuv1m36ra406uq7atn', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333839333336362e3839393934353b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a226a3436746636656e707576316d3336726134303675713761746e223b7d7d, 1793893366),
('j7jcok23gecv4463l0aip8hlc6', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333934363337322e3631323136363b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a226a376a636f6b323367656376343436336c3061697038686c6336223b7d7d, 1793946372),
('j7s66u39s0ud92lilu0c1nq6om', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333838383135352e3135353933373b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a226a377336367533397330756439326c696c753063316e71366f6d223b7d7d, 1793888155),
('j7s7a9t8kukhkqgqcj0m5tek28', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333838393437392e3936393531393b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a226a377337613974386b756b686b716771636a306d3574656b3238223b7d7d, 1793889480),
('jdtpvl1ps9ara8u86h18327i7f', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333838393435332e39393531343b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a226a647470766c3170733961726138753836683138333237693766223b7d7d, 1793889454),
('je8d33ei2t750d737dhbkg67tm', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333836313535382e3433323737313b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a226a653864333365693274373530643733376468626b673637746d223b7d7d, 1793861558),
('jllig83lcqjg1qvrit77dubl7v', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333838393432312e31353734353b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a226a6c6c696738336c63716a6731717672697437376475626c3776223b7d7d, 1793889421),
('jlos1trdeuq200brh79ib24sai', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333837303932392e3230313836383b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a226a6c6f7331747264657571323030627268373969623234736169223b7d7d, 1793870929),
('jmrvgkcjc8nk8kue4djeiosdlb', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333836353335352e3038373530373b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a226a6d7276676b636a63386e6b386b756534646a65696f73646c62223b7d7d, 1793865355),
('jqffedrjvcb1bf6ch30f2hbank', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333837313036302e3539343935373b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a226a7166666564726a766362316266366368333066326862616e6b223b7d7d, 1793871060),
('k3hafhm5iu4rq3aielf6fqo2j4', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333839363937322e32303839393b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a226b33686166686d356975347271336169656c663666716f326a34223b7d7d, 1793896972),
('k4fh8lnkgivh1h6idasgj2lntu', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333839333334372e3638363739383b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a226b346668386c6e6b6769766831683669646173676a326c6e7475223b7d7d, 1793893347),
('k4tjhpq2921aautlqkdvkdslei', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333837313033392e3030373031343b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a226b34746a68707132393231616175746c716b64766b64736c6569223b7d7d, 1793871039),
('k5l68vai4159page71l5mfvuik', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333837343739392e3331323839383b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a226b356c3638766169343135397061676537316c356d667675696b223b7d7d, 1793874799),
('k6ah4pd0hcs57pm77hrqmq3j7i', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333934343832362e3831333534393b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a226b366168347064306863733537706d37376872716d71336a3769223b7d7d, 1793944827),
('k74iah90hr0j8g892gbahmuqhq', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333837303937322e3039313233313b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a226b373469616839306872306a3867383932676261686d75716871223b7d7d, 1793870972),
('k74oc5984707v2ug15ek10ktk6', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333739323130352e3235343138353b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a226b37346f6335393834373037763275673135656b31306b746b36223b7d7d, 1793792105),
('kde3t16v4k3ajfecll9r5iub1p', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333738373836352e3835353133313b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a226b64653374313676346b33616a6665636c6c3972356975623170223b7d7d, 1793787865),
('ke8i21bdguli2kvqht82n8f2tp', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333934353137302e3332383734353b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a226b6538693231626467756c69326b7671687438326e3866327470223b7d7d, 1793945170),
('kl9q6pp2sedihdp1tsgr9i7f5o', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333837313034342e32323137373b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a226b6c39713670703273656469686470317473677239693766356f223b7d7d, 1793871044),
('kljl2fhad3o1h7ftk4akto8cl1', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333838373334332e3835373631393b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a226b6c6a6c3266686164336f31683766746b34616b746f38636c31223b7d7d, 1793887343),
('klpvne8e6iktor6545keusv9li', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333738373736362e3039373831363b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a226b6c70766e65386536696b746f72363534356b65757376396c69223b7d7d, 1793787766),
('kml7a2lfbem3h3aago0318qcn1', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333838383931312e3837393734343b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a226b6d6c3761326c6662656d3368336161676f3033313871636e31223b7d7d, 1793888911),
('knfqitvimr1cd9vanbl44q87v6', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333839363939362e3637343634373b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a226b6e6671697476696d723163643976616e626c34347138377636223b7d7d, 1793896996),
('komvuc0m0hvlbi83uo7ein47m7', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333738373837352e3232333632333b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a226b6f6d767563306d3068766c62693833756f3765696e34376d37223b7d7d, 1793787875),
('kp3k690tfs54bvs6siv5np80qb', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333739323635322e3430383733383b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a226b70336b363930746673353462767336736976356e7038307162223b7d7d, 1793792652),
('krdbv575p0k6vc396hrf1sn6as', 0x5f5f4c616d696e61737c613a333a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333739313836392e3238353939313b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a226b7264627635373570306b36766333393668726631736e366173223b7d733a34323a224c616d696e61735f56616c696461746f725f437372665f73616c745f6c6f67696e666f726d5f63737266223b613a313a7b733a363a22455850495245223b693a313739333833353036393b7d7d4f6d656b614d657373656e6765727c4f3a32363a224c616d696e61735c5374646c69625c41727261794f626a656374223a343a7b733a373a2273746f72616765223b613a303a7b7d733a343a22666c6167223b693a323b733a31333a226974657261746f72436c617373223b733a31333a2241727261794974657261746f72223b733a31393a2270726f74656374656450726f70657274696573223b613a343a7b693a303b733a373a2273746f72616765223b693a313b733a343a22666c6167223b693a323b733a31333a226974657261746f72436c617373223b693a333b733a31393a2270726f74656374656450726f70657274696573223b7d7d4c616d696e61735f56616c696461746f725f437372665f73616c745f6c6f67696e666f726d5f637372667c4f3a32363a224c616d696e61735c5374646c69625c41727261794f626a656374223a343a7b733a373a2273746f72616765223b613a323a7b733a393a22746f6b656e4c697374223b613a313a7b733a33323a223361653664303834346436363763656333623162383937303938653031396261223b733a33323a223165313337323561393033396435646664343838313365376462643036386433223b7d733a343a2268617368223b733a36353a2231653133373235613930333964356466643438383133653764626430363864332d3361653664303834346436363763656333623162383937303938653031396261223b7d733a343a22666c6167223b693a323b733a31333a226974657261746f72436c617373223b733a31333a2241727261794974657261746f72223b733a31393a2270726f74656374656450726f70657274696573223b613a343a7b693a303b733a373a2273746f72616765223b693a313b733a343a22666c6167223b693a323b733a31333a226974657261746f72436c617373223b693a333b733a31393a2270726f74656374656450726f70657274696573223b7d7d, 1793791869),
('kvaah0d3l2m2igpoilshh4j605', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333838383930352e3932393131363b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a226b766161683064336c326d326967706f696c736868346a363035223b7d7d, 1793888905),
('l3qremo06bchsf6if7a4n7d0hg', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333839373134302e3733353434343b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a226c337172656d6f303662636873663669663761346e3764306867223b7d7d, 1793897140),
('labu07buvh1j67ld0nltq2d13l', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333738373736332e3238323135353b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a226c616275303762757668316a36376c64306e6c7471326431336c223b7d7d, 1793787763),
('lbf86lk3jdbnb5dsg0b2svcuha', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333934343836312e3233353237353b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a226c626638366c6b336a64626e6235647367306232737663756861223b7d7d, 1793944861),
('lerpr7sohlees0htadepdj38jb', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333934343833362e3937323733323b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a226c6572707237736f686c65657330687461646570646a33386a62223b7d7d, 1793944837),
('lgnctf8os1dlv1k41t0tusv005', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333530393130362e3130383535313b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a226c676e637466386f7331646c76316b3431743074757376303035223b7d7d, 1793509106),
('ll5gnv6p1if3abit6et2vhq8gb', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333837303934332e3736393235383b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a226c6c35676e763670316966336162697436657432766871386762223b7d7d, 1793870943),
('lm1dcdhac41bd7ia1tfnt2j43i', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333934333431312e3232353134343b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a226c6d31646364686163343162643769613174666e74326a343369223b7d7d, 1793943411),
('lm2ukf1v5crvef00nvm6cli5eo', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333530393039322e3530333938343b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a226c6d32756b66317635637276656630306e766d36636c6935656f223b7d7d, 1793509092),
('lmhb77tgg427i17v99rl0ojgft', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333837303934352e3734333931373b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a226c6d68623737746767343237693137763939726c306f6a676674223b7d7d, 1793870945),
('lqli5ts0smqpftblkukguuosos', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333837313030312e3635373336333b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a226c716c6935747330736d71706674626c6b756b6775756f736f73223b7d7d, 1793871001),
('m00d3ageca1aft5m1ilhkjl6ev', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333530393130302e3638383537313b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a226d30306433616765636131616674356d31696c686b6a6c366576223b7d7d, 1793509100),
('m1dionkrkqmb9t7d3hom00m7vq', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333837343334342e33353831333b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a226d3164696f6e6b726b716d623974376433686f6d30306d377671223b7d7d, 1793874344),
('m6fmihqghd7g6okifq5akplh39', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333836313535362e3533383337313b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a226d36666d6968716768643767366f6b69667135616b706c683339223b7d7d, 1793861556),
('m8migdi10jv6taetjpb6rrl98e', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333837303933332e3231343432323b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a226d386d6967646931306a7636746165746a70623672726c393865223b7d7d, 1793870933),
('m8nofdq3krpuci5tro6dff9s8h', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333837303938392e3638323438353b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a226d386e6f666471336b72707563693574726f3664666639733868223b7d7d, 1793870989),
('m96c9bpu7pgeemj7312kl9doau', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333830363431372e3632373134393b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a226d3936633962707537706765656d6a373331326b6c39646f6175223b7d7d, 1793806417),
('mc7tfoatc7nmdostls8727bjdc', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333934353233332e3132343532323b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a226d633774666f617463376e6d646f73746c7338373237626a6463223b7d7d, 1793945233),
('mjteicjp51h9t4jhmppseno9l0', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333934343833322e3033383038363b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a226d6a746569636a703531683974346a686d707073656e6f396c30223b7d7d, 1793944832),
('mk36fom76je01u5d1ei0gd2n8g', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333739323634332e3035333832383b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a226d6b3336666f6d37366a653031753564316569306764326e3867223b7d7d, 1793792643),
('ms277jh5cmdnuh5qm2oj07nb9v', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333934333734392e3739393439383b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a226d733237376a6835636d646e756835716d326f6a30376e623976223b7d7d, 1793943749),
('n2el1jnt0a3gjruvb0ebgpj9gu', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333837303739382e3136323032363b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a226e32656c316a6e74306133676a7275766230656267706a396775223b7d7d, 1793870798),
('n35p0m4r0i4ufkgo3qft692imc', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333837313032382e3934353435353b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a226e333570306d347230693475666b676f33716674363932696d63223b7d7d, 1793871028),
('n7bbpm45boba96k9bm2ovn6g6f', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333838393532322e3535383534313b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a226e376262706d3435626f626139366b39626d326f766e36673666223b7d7d, 1793889522),
('n86jna12barafs654c9tehr89d', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333934343834342e3239343035393b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a226e38366a6e613132626172616673363534633974656872383964223b7d7d, 1793944844),
('ncu0jtisni22sm5nqmnei3ebpf', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333838373930392e3232303233323b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a226e6375306a7469736e693232736d356e716d6e65693365627066223b7d7d, 1793887909),
('ndp1oge9r6uhatd0utmgfv58lu', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333839333337322e3635363935373b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a226e6470316f676539723675686174643075746d67667635386c75223b7d7d, 1793893372),
('nh7ne7iu8s32t9aa3ju31e5vdr', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333739393232312e3133343435323b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a226e68376e653769753873333274396161336a7533316535766472223b7d7d, 1793799221),
('nt2kfhnotvtv5jpv8i0tcvkt8v', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333738373836392e3237313436323b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a226e74326b66686e6f74767476356a70763869307463766b743876223b7d7d, 1793787869),
('nubrdujp49mpnrk5n4qv4ftjjb', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333937363438372e3739303737313b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a226e75627264756a7034396d706e726b356e3471763466746a6a62223b7d7d, 1793976487),
('nuig2i2d55e8ven229bq3cs0qb', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333934323834352e3332323331393b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a226e756967326932643535653876656e3232396271336373307162223b7d7d, 1793942845),
('o02fcrk80q7p214mvemnm1v6lv', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333937363434362e3836373935343b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a226f30326663726b38307137703231346d76656d6e6d3176366c76223b7d7d, 1793976446),
('o23ocqf7m849qs0s66lvk18iut', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333934333434352e3732383630383b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a226f32336f637166376d3834397173307336366c766b3138697574223b7d7d, 1793943445),
('o6katdqjnh9bqhvos59uhi9kl9', 0x5f5f4c616d696e61737c613a333a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333739313835392e3135333034363b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a226f366b617464716a6e6839627168766f733539756869396b6c39223b7d733a34323a224c616d696e61735f56616c696461746f725f437372665f73616c745f6c6f67696e666f726d5f63737266223b613a313a7b733a363a22455850495245223b693a313739333833353035393b7d7d4c616d696e61735f56616c696461746f725f437372665f73616c745f6c6f67696e666f726d5f637372667c4f3a32363a224c616d696e61735c5374646c69625c41727261794f626a656374223a343a7b733a373a2273746f72616765223b613a323a7b733a393a22746f6b656e4c697374223b613a313a7b733a33323a223532626130396163613331653035626534343531636235663536336638373562223b733a33323a226464363331306263373236633837356230323665343064656436363030313863223b7d733a343a2268617368223b733a36353a2264643633313062633732366338373562303236653430646564363630303138632d3532626130396163613331653035626534343531636235663536336638373562223b7d733a343a22666c6167223b693a323b733a31333a226974657261746f72436c617373223b733a31333a2241727261794974657261746f72223b733a31393a2270726f74656374656450726f70657274696573223b613a343a7b693a303b733a373a2273746f72616765223b693a313b733a343a22666c6167223b693a323b733a31333a226974657261746f72436c617373223b693a333b733a31393a2270726f74656374656450726f70657274696573223b7d7d, 1793791859),
('o941r1rv5j38l726o25sg39ii8', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333839333335302e3633313237393b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a226f39343172317276356a33386c3732366f323573673339696938223b7d7d, 1793893350),
('oa7jrikekbbnbi375k572b1eir', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333934363236392e3831313436393b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a226f61376a72696b656b62626e62693337356b3537326231656972223b7d7d, 1793946269),
('oapkmmdh3fhr99e64k71g87v7g', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333836313535392e3938373831333b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a226f61706b6d6d64683366687239396536346b3731673837763767223b7d7d, 1793861560),
('odeocglv6bt4qe1js7ooctki16', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333739323736342e3233363134363b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a226f64656f63676c76366274347165316a73376f6f63746b693136223b7d7d, 1793792764),
('oh75u7576qm89gkujr58abemaf', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333836313730372e3737313538333b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a226f6837357537353736716d3839676b756a7235386162656d6166223b7d7d, 1793861707),
('oh98h1k8s8bvt5lkpkvj19knnc', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333837333637392e3036303635363b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a226f68393868316b387338627674356c6b706b766a31396b6e6e63223b7d7d, 1793873679),
('okgsggjs9f7dkqkh5i1fsduv74', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333738373739362e33313139343b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a226f6b677367676a73396637646b716b6835693166736475763734223b7d7d, 1793787796);
INSERT INTO `session` (`id`, `data`, `modified`) VALUES
('opv7gqjdargvuuoi2fd94ifef0', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333839363936392e3231313533373b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a226f70763767716a646172677675756f6932666439346966656630223b7d7d, 1793896969),
('p3k6ompn77801f6us1t4pth91j', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333934333734312e3934393139323b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a2270336b366f6d706e37373830316636757331743470746839316a223b7d7d, 1793943742),
('p6s2bh3u2tio1pbo4o4nf99kd0', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333838383134392e38393338363b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a2270367332626833753274696f3170626f346f346e6639396b6430223b7d7d, 1793888149),
('p8hhhv34c00jdsstin8qh5kfi6', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333838383134392e3534303734323b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a2270386868687633346330306a64737374696e387168356b666936223b7d7d, 1793888149),
('pb4uf867js4q14k9eis8ig9u55', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333837343831382e36363634313b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a2270623475663836376a73347131346b3965697338696739753535223b7d7d, 1793874818),
('phldpq9armtv1r03vkol2guunm', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333937363332382e3431333338393b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a2270686c6470713961726d747631723033766b6f6c326775756e6d223b7d7d, 1793976328),
('pj9g0i8p5h194ioqmrnpabtafg', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333738373837362e3133343334363b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a22706a3967306938703568313934696f716d726e70616274616667223b7d7d, 1793787876),
('pktka4o1ve5a97g7q7i1nj4vga', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333934353431352e36373838343b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a22706b746b61346f317665356139376737713769316e6a34766761223b7d7d, 1793945415),
('pm4a5hbplnf1qu1rh40hmntohh', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333530393038382e3731343733353b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a22706d3461356862706c6e663171753172683430686d6e746f6868223b7d7d, 1793509088),
('ponvhmcdn42hk0v18o14kj2nua', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333738373833312e3737313830323b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a22706f6e76686d63646e3432686b307631386f31346b6a326e7561223b7d7d, 1793787831),
('pqev8g68hl3istg5rqh1bhnsub', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333838383032332e3332383833343b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a227071657638673638686c3369737467357271683162686e737562223b7d7d, 1793888023),
('ptevdtondv1p74v4e66mfjvj6v', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333934333536372e3636353835363b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a227074657664746f6e64763170373476346536366d666a766a3676223b7d7d, 1793943567),
('q1crmhhkh243pr5htfv494fc92', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333838373335312e3036343038393b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a22713163726d68686b683234337072356874667634393466633932223b7d7d, 1793887351),
('q8t6g2f0l6eabahvl7o629poc0', 0x5f5f4c616d696e61737c613a333a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333739313933302e3635363739323b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a2271387436673266306c366561626168766c376f363239706f6330223b7d733a34323a224c616d696e61735f56616c696461746f725f437372665f73616c745f6c6f67696e666f726d5f63737266223b613a313a7b733a363a22455850495245223b693a313739333833353133303b7d7d4c616d696e61735f56616c696461746f725f437372665f73616c745f6c6f67696e666f726d5f637372667c4f3a32363a224c616d696e61735c5374646c69625c41727261794f626a656374223a343a7b733a373a2273746f72616765223b613a323a7b733a393a22746f6b656e4c697374223b613a313a7b733a33323a226130613432633935613230386430313737313861613032633435666461336631223b733a33323a223265386335653038653931616164346536333831646164656337643436353939223b7d733a343a2268617368223b733a36353a2232653863356530386539316161643465363338316461646563376434363539392d6130613432633935613230386430313737313861613032633435666461336631223b7d733a343a22666c6167223b693a323b733a31333a226974657261746f72436c617373223b733a31333a2241727261794974657261746f72223b733a31393a2270726f74656374656450726f70657274696573223b613a343a7b693a303b733a373a2273746f72616765223b693a313b733a343a22666c6167223b693a323b733a31333a226974657261746f72436c617373223b693a333b733a31393a2270726f74656374656450726f70657274696573223b7d7d, 1793791930),
('q9nmpm8t7c8b3dtc5l1kc646ei', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333838393134372e3130383035313b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a2271396e6d706d38743763386233647463356c316b633634366569223b7d7d, 1793889147),
('qc6oahpl8rrqsgav2ursntpngu', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333934353338362e3635323639333b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a227163366f6168706c3872727173676176327572736e74706e6775223b7d7d, 1793945386),
('qdd9bc3fr3rs1udl6qfqnl8gbr', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333934353232362e3730373133383b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a227164643962633366723372733175646c367166716e6c38676272223b7d7d, 1793945226),
('qdhvmdndgj5ur21ehggt76tov1', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333838383931382e3834373435363b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a22716468766d646e64676a357572323165686767743736746f7631223b7d7d, 1793888918),
('qii0dhl9trnqda2ml8l5r8m7uk', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333738373836312e3737393938373b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a227169693064686c3974726e716461326d6c386c3572386d37756b223b7d7d, 1793787861),
('qjiupcip676puofiu17d2vts13', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333838383839362e3634323437383b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a22716a69757063697036373670756f666975313764327674733133223b7d7d, 1793888896),
('ql55be0uikgnv46tj6bbsbq1jp', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333837343233392e3137363539383b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a22716c353562653075696b676e763436746a366262736271316a70223b7d7d, 1793874239),
('qnrpjp8r1pronh23mbsls6uc5o', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333837343736332e3837353934343b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a22716e72706a7038723170726f6e6832336d62736c73367563356f223b7d7d, 1793874763),
('qpdie6h21cpvqb26sdcb2hgho0', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333739313832382e3834333836363b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a227170646965366832316370767162323673646362326867686f30223b7d7d72656469726563745f75726c7c733a34363a22687474703a2f2f6c6f63616c686f73742f6f6d6b5f6f6e746f657468697175652f61646d696e2f6974656d2f3433223b, 1793791828),
('qvglv55n2cd9iev7egdeodvc7k', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333838383931362e3236323936323b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a227176676c7635356e3263643969657637656764656f647663376b223b7d7d, 1793888916),
('r0r88soc32vkj9bcc51g0igl07', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333830363431372e3139383737373b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a227230723838736f633332766b6a396263633531673069676c3037223b7d7d, 1793806417),
('r5mfgfnln58addl642c72opm8k', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333936323631302e3836303934373b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a2272356d6667666e6c6e35386164646c3634326337326f706d386b223b7d7d, 1793962610),
('r5rfp3tcvc13n2f2drofhnadv0', 0x5f5f4c616d696e61737c613a333a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333830353233332e3537333231343b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a227235726670337463766331336e32663264726f66686e61647630223b7d733a34323a224c616d696e61735f56616c696461746f725f437372665f73616c745f6c6f67696e666f726d5f63737266223b613a313a7b733a363a22455850495245223b693a313739333834383433333b7d7d72656469726563745f75726c7c733a34363a22687474703a2f2f6c6f63616c686f73742f6f6d6b5f6f6e746f657468697175652f61646d696e2f6974656d2f3433223b4c616d696e61735f56616c696461746f725f437372665f73616c745f6c6f67696e666f726d5f637372667c4f3a32363a224c616d696e61735c5374646c69625c41727261794f626a656374223a343a7b733a373a2273746f72616765223b613a323a7b733a393a22746f6b656e4c697374223b613a313a7b733a33323a223232343366356133626238313935613539393763666464373565623363366231223b733a33323a223538336662323635633339393230626138316635313533306536306430626637223b7d733a343a2268617368223b733a36353a2235383366623236356333393932306261383166353135333065363064306266372d3232343366356133626238313935613539393763666464373565623363366231223b7d733a343a22666c6167223b693a323b733a31333a226974657261746f72436c617373223b733a31333a2241727261794974657261746f72223b733a31393a2270726f74656374656450726f70657274696573223b613a343a7b693a303b733a373a2273746f72616765223b693a313b733a343a22666c6167223b693a323b733a31333a226974657261746f72436c617373223b693a333b733a31393a2270726f74656374656450726f70657274696573223b7d7d, 1793805233),
('r7leb95gqm4kejstbhk9201a01', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333837303937382e3738313335383b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a2272376c6562393567716d346b656a737462686b39323031613031223b7d7d, 1793870978),
('rcedajtosgp7g4hsep55dtj817', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333838373335312e3432343630333b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a2272636564616a746f73677037673468736570353564746a383137223b7d7d, 1793887351),
('rclgnf8tfn6kb7aq0mokq9lh55', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333738373836362e3330363236323b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a2272636c676e663874666e366b62376171306d6f6b71396c683535223b7d7d, 1793787866),
('rdg9icevs9oojs04ebp7r10kls', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333830363433372e3435383739343b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a22726467396963657673396f6f6a733034656270377231306b6c73223b7d7d, 1793806437),
('ri40jbrd58qpdgejdh1arc14bp', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333838393135352e3036373339323b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a22726934306a627264353871706467656a64683161726331346270223b7d7d, 1793889155),
('rinoqt2ehekki4dk74ns9006lk', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333837313431342e3639383632363b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a2272696e6f7174326568656b6b6934646b37346e73393030366c6b223b7d7d, 1793871414),
('rlm7g6vrjl7dgdi7al1euiluhu', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333934343833362e3932323333313b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a22726c6d37673676726a6c376467646937616c316575696c756875223b7d7d, 1793944836),
('roj2j0hgnuo9rc6io1skbeujlq', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333935383531342e3437303933313b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a22726f6a326a3068676e756f39726336696f31736b6265756a6c71223b7d7d, 1793958514),
('rvf1aoe23ktrnjs85d2b3nkgg9', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333934363231332e3437323138393b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a2272766631616f6532336b74726e6a733835643262336e6b676739223b7d7d, 1793946213),
('s07r03ebsjdevm17r77fugjlmd', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333934323834382e3134363236313b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a227330377230336562736a6465766d31377237376675676a6c6d64223b7d7d, 1793942848),
('s1igi8je7kmrcmtdb62m6vmd2l', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333934333334302e3635353330343b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a227331696769386a65376b6d72636d74646236326d36766d64326c223b7d7d, 1793943340),
('s1rlh7ls01pbeoln1p9qfk3l5g', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333934343832332e3234303136323b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a227331726c68376c7330317062656f6c6e31703971666b336c3567223b7d7d, 1793944823),
('s4q92dch8emsdc4g76v1gel4a6', 0x5f5f4c616d696e61737c613a333a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333937373039372e3130363532363b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a22733471393264636838656d73646334673736763167656c346136223b7d733a34323a224c616d696e61735f56616c696461746f725f437372665f73616c745f6c6f67696e666f726d5f63737266223b613a313a7b733a363a22455850495245223b693a313739343032303239373b7d7d72656469726563745f75726c7c733a34373a22687474703a2f2f6c6f63616c686f73742f6f6d6b5f6f6e746f657468697175652f61646d696e2f6974656d2f323939223b4c616d696e61735f56616c696461746f725f437372665f73616c745f6c6f67696e666f726d5f637372667c4f3a32363a224c616d696e61735c5374646c69625c41727261794f626a656374223a343a7b733a373a2273746f72616765223b613a323a7b733a393a22746f6b656e4c697374223b613a343a7b733a33323a226162386438353264613436393934373731373433623632653664396663333062223b733a33323a223531306635343364393765613363306233356138346165376133313232623361223b733a33323a223939396634313066663865636533626461393165613537393138333866646134223b733a33323a226433636636633839356165336338363738636563303039306565353665333064223b733a33323a223563653964666130336566613530353337333865333263613838663233643931223b733a33323a226434396264386439633734623531303633396437353037613639623538313165223b733a33323a223235333734386463326564383161323963623935333135656638613330343133223b733a33323a223131306432303238376338306435356362656665373636356565356330653765223b7d733a343a2268617368223b733a36353a2231313064323032383763383064353563626566653736363565653563306537652d3235333734386463326564383161323963623935333135656638613330343133223b7d733a343a22666c6167223b693a323b733a31333a226974657261746f72436c617373223b733a31333a2241727261794974657261746f72223b733a31393a2270726f74656374656450726f70657274696573223b613a343a7b693a303b733a373a2273746f72616765223b693a313b733a343a22666c6167223b693a323b733a31333a226974657261746f72436c617373223b693a333b733a31393a2270726f74656374656450726f70657274696573223b7d7d, 1793977097),
('s6r8nol2s5cvhp68rp21tool83', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333837343736322e3131343832323b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a22733672386e6f6c32733563766870363872703231746f6f6c3833223b7d7d, 1793874762),
('s7md688t81e5b2pc7qf59v346l', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333738373737312e35313530323b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a2273376d643638387438316535623270633771663539763334366c223b7d7d, 1793787771),
('s89t2m8gt39uo32qa99s10k0rn', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333838383136362e3131363436323b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a2273383974326d3867743339756f3332716139397331306b30726e223b7d7d, 1793888166),
('s9bqd6ror0sm6s79drejh8ih2n', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333839323134362e3532333235313b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a22733962716436726f7230736d367337396472656a68386968326e223b7d7d, 1793892146),
('sf1fdoeiaescam2i8kgi60f4c2', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333737343938332e3031343333363b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a2273663166646f656961657363616d3269386b6769363066346332223b7d7d, 1793774983),
('spqni0acr96nt6p4fmhc1uo53k', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333837313432332e3638343733323b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a227370716e693061637239366e74367034666d686331756f35336b223b7d7d, 1793871423),
('stc2uu31pdi6eml1rt7qqu6u6f', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333837333637382e3638333736323b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a22737463327575333170646936656d6c3172743771717536753666223b7d7d, 1793873678),
('t0uovdbq8stj934oqd3bfol654', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333934343835392e3937363730393b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a227430756f766462713873746a3933346f71643362666f6c363534223b7d7d, 1793944860),
('t1uks9s2oni03ate94l4mcdarh', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333830343430302e3231353639313b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a227431756b733973326f6e69303361746539346c346d6364617268223b7d7d, 1793804400),
('t9rq3sldcec5kmnmth0l662fk1', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333837313031392e33313735323b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a227439727133736c64636563356b6d6e6d7468306c363632666b31223b7d7d, 1793871019),
('tcvksqmfjub106pvrfvml6d4l4', 0x5f5f4c616d696e61737c613a353a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739323539313133352e30313833313b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a227268683432387165686a7364613263396a343435697363616169223b7d733a34323a224c616d696e61735f56616c696461746f725f437372665f73616c745f6c6f67696e666f726d5f63737266223b613a313a7b733a363a22455850495245223b693a313739323633343238343b7d733a34343a224c616d696e61735f56616c696461746f725f437372665f73616c745f636f6e6669726d666f726d5f63737266223b613a313a7b733a363a22455850495245223b693a313739323633343330313b7d733a33323a224c616d696e61735f56616c696461746f725f437372665f73616c745f63737266223b613a313a7b733a363a22455850495245223b693a313739323633343333343b7d7d4c616d696e61735f56616c696461746f725f437372665f73616c745f6c6f67696e666f726d5f637372667c4f3a32363a224c616d696e61735c5374646c69625c41727261794f626a656374223a343a7b733a373a2273746f72616765223b613a323a7b733a393a22746f6b656e4c697374223b613a313a7b733a33323a223838386331643137376234353761636434366438623231633036343336666363223b733a33323a223635623162613831323433663739376361343836313061633264653638376430223b7d733a343a2268617368223b733a36353a2236356231626138313234336637393763613438363130616332646536383764302d3838386331643137376234353761636434366438623231633036343336666363223b7d733a343a22666c6167223b693a323b733a31333a226974657261746f72436c617373223b733a31333a2241727261794974657261746f72223b733a31393a2270726f74656374656450726f70657274696573223b613a343a7b693a303b733a373a2273746f72616765223b693a313b733a343a22666c6167223b693a323b733a31333a226974657261746f72436c617373223b693a333b733a31393a2270726f74656374656450726f70657274696573223b7d7d4c616d696e61735f417574687c4f3a32363a224c616d696e61735c5374646c69625c41727261794f626a656374223a343a7b733a373a2273746f72616765223b613a313a7b733a373a2273746f72616765223b693a313b7d733a343a22666c6167223b693a323b733a31333a226974657261746f72436c617373223b733a31333a2241727261794974657261746f72223b733a31393a2270726f74656374656450726f70657274696573223b613a343a7b693a303b733a373a2273746f72616765223b693a313b733a343a22666c6167223b693a323b733a31333a226974657261746f72436c617373223b693a333b733a31393a2270726f74656374656450726f70657274696573223b7d7d4f6d656b614d657373656e6765727c4f3a32363a224c616d696e61735c5374646c69625c41727261794f626a656374223a343a7b733a373a2273746f72616765223b613a303a7b7d733a343a22666c6167223b693a323b733a31333a226974657261746f72436c617373223b733a31333a2241727261794974657261746f72223b733a31393a2270726f74656374656450726f70657274696573223b613a343a7b693a303b733a373a2273746f72616765223b693a313b733a343a22666c6167223b693a323b733a31333a226974657261746f72436c617373223b693a333b733a31393a2270726f74656374656450726f70657274696573223b7d7d72656469726563745f75726c7c4e3b4c616d696e61735f56616c696461746f725f437372665f73616c745f636f6e6669726d666f726d5f637372667c4f3a32363a224c616d696e61735c5374646c69625c41727261794f626a656374223a343a7b733a373a2273746f72616765223b613a323a7b733a393a22746f6b656e4c697374223b613a323a7b733a33323a223161383039643461313937343331663535626365306563313761616331633964223b733a33323a223937643631373135306666333536383136313133646237636664346262623439223b733a33323a223539303334333030613564383433373163353430383761356162353164363538223b733a33323a226231383531323461306532353636393063316337303631303230356338316139223b7d733a343a2268617368223b733a36353a2262313835313234613065323536363930633163373036313032303563383161392d3539303334333030613564383433373163353430383761356162353164363538223b7d733a343a22666c6167223b693a323b733a31333a226974657261746f72436c617373223b733a31333a2241727261794974657261746f72223b733a31393a2270726f74656374656450726f70657274696573223b613a343a7b693a303b733a373a2273746f72616765223b693a313b733a343a22666c6167223b693a323b733a31333a226974657261746f72436c617373223b693a333b733a31393a2270726f74656374656450726f70657274696573223b7d7d4c616d696e61735f56616c696461746f725f437372665f73616c745f637372667c4f3a32363a224c616d696e61735c5374646c69625c41727261794f626a656374223a343a7b733a373a2273746f72616765223b613a323a7b733a393a22746f6b656e4c697374223b613a323a7b733a33323a223832343939316134373630396361326261663661376662343331336637366530223b733a33323a223162346134663763656465363166323834636337613965626531363835313866223b733a33323a223738313439646431333837616135616336343939333537366565393630333733223b733a33323a223333323165646163353233643266333730663933623835313531656464343938223b7d733a343a2268617368223b733a36353a2233333231656461633532336432663337306639336238353135316564643439382d3738313439646431333837616135616336343939333537366565393630333733223b7d733a343a22666c6167223b693a323b733a31333a226974657261746f72436c617373223b733a31333a2241727261794974657261746f72223b733a31393a2270726f74656374656450726f70657274696573223b613a343a7b693a303b733a373a2273746f72616765223b693a313b733a343a22666c6167223b693a323b733a31333a226974657261746f72436c617373223b693a333b733a31393a2270726f74656374656450726f70657274696573223b7d7d, 1792591135),
('trrdqn3e6uo3t887rbmnj3l9kc', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333936323630382e3431313539323b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a2274727264716e336536756f337438383772626d6e6a336c396b63223b7d7d, 1793962608),
('tude98h9f7utofuita4cgbt356', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333839333538342e3231303934353b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a227475646539386839663775746f66756974613463676274333536223b7d7d, 1793893584),
('tusn3k298ak1ihk1399o1i9jqt', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333838393438302e3435353830373b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a227475736e336b323938616b3169686b313339396f3169396a7174223b7d7d, 1793889480),
('tva5qvhcflsoq32hssf5efg2ls', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333530393038372e39353338383b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a227476613571766863666c736f7133326873736635656667326c73223b7d7d, 1793509087),
('u03pluuvcivfo5gev9t22t5hub', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333836313537362e3932323234343b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a22753033706c757576636976666f35676576397432327435687562223b7d7d, 1793861576),
('u306gufbnagm6b13u5q5huch6p', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333837313033332e3839303039353b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a2275333036677566626e61676d3662313375357135687563683670223b7d7d, 1793871033),
('u6dkh4lft43j48aabca4v99g0d', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333935383635332e3436323331333b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a227536646b68346c667434336a3438616162636134763939673064223b7d7d, 1793958653),
('u6ek5eft6t991vuggb1fua67qe', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333934333733302e3738393239373b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a227536656b35656674367439393176756767623166756136377165223b7d7d, 1793943730),
('u70u253c9dt8hv1k42118107op', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333838393135352e3432353437383b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a227537307532353363396474386876316b34323131383130376f70223b7d7d, 1793889155),
('ua0uf5rl36bcilc5t74dmjiosm', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333738373737372e3532363236373b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a22756130756635726c33366263696c6335743734646d6a696f736d223b7d7d, 1793787777),
('ua520seqd2b8ndpfc3seh2nnmt', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333837353031382e36363134323b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a227561353230736571643262386e6470666333736568326e6e6d74223b7d7d, 1793875018),
('udi27ovjpie835s99inert2oov', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333837343737382e34383631323b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a2275646932376f766a706965383335733939696e657274326f6f76223b7d7d, 1793874778),
('uhlb05vlsd4vvqa0gi7tn9vqlb', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333839383038332e3635353032373b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a2275686c623035766c7364347676716130676937746e3976716c62223b7d7d, 1793898083),
('uijk24j5iitt3n6djvj64j1d21', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333530393130372e3834313934383b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a2275696a6b32346a3569697474336e36646a766a36346a31643231223b7d7d, 1793509107),
('ujreobb141e7ko2em66eu6kt4f', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333934333039332e3935313237333b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a22756a72656f626231343165376b6f32656d36366575366b743466223b7d7d, 1793943093),
('ukpg8mjqcm296818eeqe2hfld7', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333838373930382e3533373436393b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a22756b7067386d6a71636d323936383138656571653268666c6437223b7d7d, 1793887908),
('un3q6bp4vm7duuk7nr24p7uhhi', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333530393130342e3631303435363b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a22756e337136627034766d376475756b376e723234703775686869223b7d7d, 1793509104),
('unq6fjvk0ji5pt67mij041juj7', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333934333537312e3235323432323b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a22756e7136666a766b306a6935707436376d696a3034316a756a37223b7d7d, 1793943571),
('uo23ha88g65mpso53ticqhhq6d', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333837313030352e3839343037353b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a22756f3233686138386736356d70736f3533746963716868713664223b7d7d, 1793871005),
('urlebme8ohsmk7hbk365tkq408', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333837333638352e36383731353b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a2275726c65626d65386f68736d6b3768626b333635746b71343038223b7d7d, 1793873685),
('uv5r6b0aokcbtp2k4oil8rio7h', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333835393738332e3533333034373b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a2275763572366230616f6b63627470326b346f696c3872696f3768223b7d7d, 1793859783),
('uvtfgqp24f52o3082u684vvkuh', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333934343833322e3931323238363b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a227576746667717032346635326f333038327536383476766b7568223b7d7d, 1793944832),
('v7a04d1iinood9bq0iopth4b23', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333934353137332e3739383530373b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a227637613034643169696e6f6f6439627130696f70746834623233223b7d7d, 1793945173),
('vidh12fq0o1fr9u9hl672duonl', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333934333732372e323231313b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a227669646831326671306f316672397539686c36373264756f6e6c223b7d7d, 1793943727),
('vmo5j4148unl6btrk56s9v68eb', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333838393533382e3430343135353b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a22766d6f356a34313438756e6c366274726b353673397636386562223b7d7d, 1793889538),
('vp1eh0fpv7isvcrcgsmj1816ut', 0x5f5f4c616d696e61737c613a323a7b733a32303a225f524551554553545f4143434553535f54494d45223b643a313739333830373236322e3734343134393b733a363a225f56414c4944223b613a313a7b733a32383a224c616d696e61735c53657373696f6e5c56616c696461746f725c4964223b733a32363a227670316568306670763769737663726367736d6a313831367574223b7d7d, 1793807262);

-- --------------------------------------------------------

--
-- Structure de la table `setting`
--

CREATE TABLE `setting` (
  `id` varchar(190) NOT NULL,
  `value` longtext NOT NULL COMMENT '(DC2Type:json_array)'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `setting`
--

INSERT INTO `setting` (`id`, `value`) VALUES
('administrator_email', '\"samuel.szoniecky@univ-paris8.fr\"'),
('advancedresourcetemplate_autofillers', '[]'),
('advancedresourcetemplate_closed_property_list', '\"0\"'),
('advancedresourcetemplate_initialized_settings', '\"1\"'),
('advancedresourcetemplate_item_set_queries', '[]'),
('advancedresourcetemplate_properties_as_search_blacklist', '[\"dcterms:abstract\",\"dcterms:bibliographicCitation\",\"dcterms:description\",\"dcterms:extent\",\"dcterms:identifier\",\"dcterms:tableOfContents\",\"bibo:abstract\",\"bibo:asin\",\"bibo:content\",\"bibo:doi\",\"bibo:eanucc13\",\"bibo:eissn\",\"bibo:gtin14\",\"bibo:handle\",\"bibo:identifier\",\"bibo:isbn\",\"bibo:isbn10\",\"bibo:isbn13\",\"bibo:issn\",\"bibo:issue\",\"bibo:lccn\",\"bibo:authorList\",\"bibo:contributorList\",\"bibo:editorList\",\"bibo:locator\",\"bibo:number\",\"bibo:oclcnum\",\"bibo:pageEnd\",\"bibo:pageStart\",\"bibo:pages\",\"bibo:pmid\",\"bibo:sici\",\"bibo:upc\",\"bibo:uri\",\"curation:data\",\"curation:note\"]'),
('advancedresourcetemplate_properties_as_search_whitelist', '[\"all\"]'),
('advancedresourcetemplate_properties_display_admin', '\"0\"'),
('advancedresourcetemplate_resource_form_elements', '[\"metadata_collapse\",\"metadata_description\",\"language\",\"visibility\",\"value_annotation\"]'),
('advancedresourcetemplate_skip_checks', '\"0\"'),
('advancedresourcetemplate_skip_private_values', '\"0\"'),
('advancedresourcetemplate_templates_by_resource', '{\"items\":[2,3,4,5,6,7,8,9,10,12,13,14],\"media\":[2,5,10,13],\"item_sets\":[2,5,10,13],\"value_annotations\":[11,13],\"annotations\":[13],\"digital_objects\":[13],\"concepts\":[13]}'),
('annotate_initialized_settings', '\"1\"'),
('annotate_jsonld_old_format', '\"0\"'),
('annotate_public_allow_annotate', '\"0\"'),
('annotate_resource_template_data', '{\"13\":{\"oa:motivatedBy\":\"oa:Annotation\",\"rdf:value\":\"oa:hasBody\",\"oa:hasPurpose\":\"oa:hasBody\",\"dcterms:language\":\"oa:hasBody\",\"oa:hasSource\":\"oa:hasTarget\",\"dcterms:format\":\"oa:hasTarget\"}}'),
('annotate_w3c_creator_fields', '[\"name\"]'),
('batch_chunk_size', '\"100\"'),
('default_site', '\"\"'),
('default_to_private_item_sets', '\"0\"'),
('default_to_private_items', '\"0\"'),
('default_to_private_site_pages', '\"0\"'),
('default_to_private_sites', '\"0\"'),
('disable_file_validation', '\"0\"'),
('disable_jsonld_embed', '\"0\"'),
('disable_jsonld_reverse', '\"0\"'),
('easyadmin_addon_notify_version_dev', '\"0\"'),
('easyadmin_addon_notify_version_inactive', '\"1\"'),
('easyadmin_admin_board_color', '\"\"'),
('easyadmin_administrator_name', '\"\"'),
('easyadmin_allow_empty_files', '\"0\"'),
('easyadmin_asset_extensions', '[]'),
('easyadmin_asset_media_types', '[]'),
('easyadmin_config_apply_button', '\"0\"'),
('easyadmin_cron_last', '1793977097'),
('easyadmin_cron_tasks', '[\"session_8\"]'),
('easyadmin_disable_csrf', '\"0\"'),
('easyadmin_disable_thumbnails', '\"0\"'),
('easyadmin_display_exception', '\"\"'),
('easyadmin_initialized_config', '\"1\"'),
('easyadmin_initialized_settings', '\"1\"'),
('easyadmin_interface', '[\"resource_public_view\"]'),
('easyadmin_local_path', '\"\\/Users\\/samszo\\/Sites\\/omk_ontoethique\\/files\\/import\"'),
('easyadmin_local_path_any', 'false'),
('easyadmin_local_path_any_files', '\"1\"'),
('easyadmin_local_paths', '[]'),
('easyadmin_local_store_base_uri', '\"\"'),
('easyadmin_maintenance_mode', '\"\"'),
('easyadmin_maintenance_text', '\"<p>This site is down for maintenance. Please contact the site administrator for more information.<\\/p>\\n\"'),
('easyadmin_no_reply_email', '\"\"'),
('easyadmin_no_reply_name', '\"\"'),
('easyadmin_quick_template', '[\"4\",\"6\",\"2\",\"5\",\"3\",\"7\"]'),
('easyadmin_rights_reviewer_delete_all', '\"0\"'),
('easyadmin_settings_enhancements', '\"0\"'),
('easyadmin_user_directories', '\"0\"'),
('extension_whitelist', '[\"aac\",\"aif\",\"aiff\",\"asf\",\"asx\",\"avi\",\"bmp\",\"c\",\"cc\",\"class\",\"css\",\"divx\",\"doc\",\"docx\",\"exe\",\"gif\",\"gz\",\"gzip\",\"h\",\"ico\",\"j2k\",\"jp2\",\"jpe\",\"jpeg\",\"jpg\",\"m4a\",\"m4v\",\"mdb\",\"mid\",\"midi\",\"mov\",\"mp2\",\"mp3\",\"mp4\",\"mpa\",\"mpe\",\"mpeg\",\"mpg\",\"mpp\",\"odb\",\"odc\",\"odf\",\"odg\",\"odp\",\"ods\",\"odt\",\"ogg\",\"opus\",\"pdf\",\"png\",\"pot\",\"pps\",\"ppt\",\"pptx\",\"qt\",\"ra\",\"ram\",\"rtf\",\"rtx\",\"swf\",\"tar\",\"tif\",\"tiff\",\"txt\",\"wav\",\"wax\",\"webm\",\"webp\",\"wma\",\"wmv\",\"wmx\",\"wri\",\"xla\",\"xls\",\"xlsx\",\"xlt\",\"xlw\",\"zip\",\"html\",\"md\",\"json\",\"csv\",\"bib\"]'),
('favicon', '\"\"'),
('installation_title', '\"Mod\\u00e9lisations onto-\\u00e9thiques\"'),
('locale', '\"\"'),
('mapper_initialized_config', '\"1\"'),
('mapper_xslt_processor', '\"\"'),
('mapper_xslt_processor_mode', '\"auto\"'),
('media_alt_text_property', '\"\"'),
('media_type_whitelist', '[\"application\\/msword\",\"application\\/ogg\",\"application\\/pdf\",\"application\\/rtf\",\"application\\/vnd.ms-access\",\"application\\/vnd.ms-excel\",\"application\\/vnd.ms-powerpoint\",\"application\\/vnd.ms-project\",\"application\\/vnd.ms-write\",\"application\\/vnd.oasis.opendocument.chart\",\"application\\/vnd.oasis.opendocument.database\",\"application\\/vnd.oasis.opendocument.formula\",\"application\\/vnd.oasis.opendocument.graphics\",\"application\\/vnd.oasis.opendocument.presentation\",\"application\\/vnd.oasis.opendocument.spreadsheet\",\"application\\/vnd.oasis.opendocument.text\",\"application\\/vnd.openxmlformats-officedocument.wordprocessingml.document\",\"application\\/vnd.openxmlformats-officedocument.presentationml.presentation\",\"application\\/vnd.openxmlformats-officedocument.spreadsheetml.sheet\",\"application\\/x-gzip\",\"application\\/x-ms-wmp\",\"application\\/x-msdownload\",\"application\\/x-shockwave-flash\",\"application\\/x-tar\",\"application\\/zip\",\"audio\\/midi\",\"audio\\/mp4\",\"audio\\/mpeg\",\"audio\\/ogg\",\"audio\\/x-aac\",\"audio\\/x-aiff\",\"audio\\/x-ms-wma\",\"audio\\/x-ms-wax\",\"audio\\/x-realaudio\",\"audio\\/x-wav\",\"image\\/bmp\",\"image\\/gif\",\"image\\/jp2\",\"image\\/jpeg\",\"image\\/pjpeg\",\"image\\/png\",\"image\\/tiff\",\"image\\/webp\",\"image\\/x-icon\",\"text\\/css\",\"text\\/plain\",\"text\\/richtext\",\"video\\/divx\",\"video\\/mp4\",\"video\\/mpeg\",\"video\\/ogg\",\"video\\/quicktime\",\"video\\/webm\",\"video\\/x-ms-asf\",\"video\\/x-msvideo\",\"video\\/x-ms-wmv\",\"text\\/html\",\"text\\/markdown\",\"application\\/json\",\"text\\/csv\"]'),
('pagination_per_page', '\"25\"'),
('property_label_information', '\"none\"'),
('recaptcha_secret_key', '\"\"'),
('recaptcha_site_key', '\"\"'),
('time_zone', '\"Europe\\/Paris\"'),
('use_htmlpurifier', '\"1\"'),
('value_languages', '[]'),
('version', '\"4.2.1\"'),
('version_notifications', '\"1\"');

-- --------------------------------------------------------

--
-- Structure de la table `site`
--

CREATE TABLE `site` (
  `id` int(11) NOT NULL,
  `thumbnail_id` int(11) DEFAULT NULL,
  `homepage_id` int(11) DEFAULT NULL,
  `owner_id` int(11) DEFAULT NULL,
  `slug` varchar(190) NOT NULL,
  `theme` varchar(190) NOT NULL,
  `title` varchar(190) NOT NULL,
  `summary` longtext DEFAULT NULL,
  `navigation` longtext NOT NULL COMMENT '(DC2Type:json_array)',
  `item_pool` longtext NOT NULL COMMENT '(DC2Type:json_array)',
  `created` datetime NOT NULL,
  `modified` datetime DEFAULT NULL,
  `is_public` tinyint(1) NOT NULL,
  `assign_new_items` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `site_block_attachment`
--

CREATE TABLE `site_block_attachment` (
  `id` int(11) NOT NULL,
  `block_id` int(11) NOT NULL,
  `item_id` int(11) DEFAULT NULL,
  `media_id` int(11) DEFAULT NULL,
  `caption` longtext NOT NULL,
  `position` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `site_item_set`
--

CREATE TABLE `site_item_set` (
  `id` int(11) NOT NULL,
  `site_id` int(11) NOT NULL,
  `item_set_id` int(11) NOT NULL,
  `position` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `site_page`
--

CREATE TABLE `site_page` (
  `id` int(11) NOT NULL,
  `site_id` int(11) NOT NULL,
  `slug` varchar(190) NOT NULL,
  `title` varchar(190) NOT NULL,
  `is_public` tinyint(1) NOT NULL,
  `layout_data` longtext DEFAULT NULL COMMENT '(DC2Type:json)',
  `created` datetime NOT NULL,
  `modified` datetime DEFAULT NULL,
  `layout` varchar(190) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `site_page_block`
--

CREATE TABLE `site_page_block` (
  `id` int(11) NOT NULL,
  `page_id` int(11) NOT NULL,
  `layout` varchar(80) NOT NULL,
  `data` longtext NOT NULL COMMENT '(DC2Type:json_array)',
  `layout_data` longtext DEFAULT NULL COMMENT '(DC2Type:json)',
  `position` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `site_permission`
--

CREATE TABLE `site_permission` (
  `id` int(11) NOT NULL,
  `site_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `role` varchar(80) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `site_setting`
--

CREATE TABLE `site_setting` (
  `id` varchar(190) NOT NULL,
  `site_id` int(11) NOT NULL,
  `value` longtext NOT NULL COMMENT '(DC2Type:json_array)'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `user`
--

CREATE TABLE `user` (
  `id` int(11) NOT NULL,
  `email` varchar(190) NOT NULL,
  `name` varchar(190) NOT NULL,
  `created` datetime NOT NULL,
  `modified` datetime DEFAULT NULL,
  `password_hash` varchar(60) DEFAULT NULL,
  `role` varchar(190) NOT NULL,
  `is_active` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `user`
--

INSERT INTO `user` (`id`, `email`, `name`, `created`, `modified`, `password_hash`, `role`, `is_active`) VALUES
(1, 'samuel.szoniecky@univ-paris8.fr', 'Samuel Szoniecky', '2026-10-21 13:58:04', '2026-10-21 13:58:04', '$2y$10$63DD1vG9xsLoNMMpXW7JLuaVH3A/DFRcu1xNwxWuXJ/q/zSZzyn9C', 'global_admin', 1);

-- --------------------------------------------------------

--
-- Structure de la table `user_setting`
--

CREATE TABLE `user_setting` (
  `id` varchar(190) NOT NULL,
  `user_id` int(11) NOT NULL,
  `value` longtext NOT NULL COMMENT '(DC2Type:json_array)'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `user_setting`
--

INSERT INTO `user_setting` (`id`, `user_id`, `value`) VALUES
('browse_defaults_admin_item_sets', 1, '{\"sort_by\":\"id\",\"sort_order\":\"desc\"}'),
('browse_defaults_admin_items', 1, '{\"sort_by\":\"id\",\"sort_order\":\"desc\"}'),
('browse_defaults_admin_media', 1, '{\"sort_by\":\"id\",\"sort_order\":\"desc\"}'),
('browse_defaults_admin_sites', 1, '{\"sort_by\":\"title\",\"sort_order\":\"asc\"}'),
('columns_admin_item_sets', 1, '[{\"type\":\"resource_class\",\"default\":null,\"header\":null},{\"type\":\"owner\",\"default\":null,\"header\":null},{\"type\":\"created\",\"default\":null,\"header\":null}]'),
('columns_admin_items', 1, '[{\"type\":\"resource_class\",\"default\":null,\"header\":null},{\"type\":\"owner\",\"default\":null,\"header\":null},{\"type\":\"created\",\"default\":null,\"header\":null}]'),
('columns_admin_media', 1, '[{\"type\":\"resource_class\",\"default\":null,\"header\":null},{\"type\":\"owner\",\"default\":null,\"header\":null},{\"type\":\"created\",\"default\":null,\"header\":null}]'),
('columns_admin_sites', 1, '[{\"type\":\"slug\",\"default\":null,\"header\":null},{\"type\":\"owner\",\"default\":null,\"header\":null},{\"type\":\"created\",\"default\":null,\"header\":null}]'),
('default_resource_template', 1, '\"\"'),
('locale', 1, '\"\"');

-- --------------------------------------------------------

--
-- Structure de la table `value`
--

CREATE TABLE `value` (
  `id` int(11) NOT NULL,
  `resource_id` int(11) NOT NULL,
  `property_id` int(11) NOT NULL,
  `value_resource_id` int(11) DEFAULT NULL,
  `type` varchar(190) NOT NULL,
  `lang` varchar(190) DEFAULT NULL,
  `value_annotation_id` int(11) DEFAULT NULL,
  `value` longtext DEFAULT NULL,
  `uri` longtext DEFAULT NULL,
  `is_public` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `value`
--

INSERT INTO `value` (`id`, `resource_id`, `property_id`, `value_resource_id`, `type`, `lang`, `value_annotation_id`, `value`, `uri`, `is_public`) VALUES
(1, 1, 1, NULL, 'literal', '', NULL, 'philosophie', NULL, 1),
(5, 1, 35, NULL, 'wikidata:reconciliation:all', '', NULL, 'philosophy', 'http://www.wikidata.org/entity/Q5891', 1),
(6, 2, 1, NULL, 'literal', '', NULL, 'Concepts', NULL, 1),
(7, 3, 1, NULL, 'literal', '', NULL, 'Actants', NULL, 1),
(8, 4, 1, NULL, 'literal', '', NULL, 'Physiques', NULL, 1),
(9, 5, 1, NULL, 'literal', '', NULL, 'Cribles', NULL, 1),
(10, 6, 1, NULL, 'literal', '', NULL, 'Personnes', NULL, 1),
(11, 7, 1, NULL, 'literal', '', NULL, 'Agents', NULL, 1),
(12, 8, 1, NULL, 'literal', '', NULL, 'Rôles', NULL, 1),
(13, 9, 1, NULL, 'literal', '', NULL, 'Pouvoirs existentiels', NULL, 1),
(14, 10, 1, NULL, 'literal', '', NULL, 'Pulsations existentielles', NULL, 1),
(15, 11, 1, NULL, 'literal', '', NULL, 'Raisons trajectives', NULL, 1),
(16, 12, 1, NULL, 'literal', '', NULL, 'Temporalités relatives', NULL, 1),
(17, 13, 1, NULL, 'literal', NULL, NULL, 'Avant', NULL, 1),
(18, 13, 35, NULL, 'wikidata:reconciliation:all', NULL, NULL, 'before', 'http://www.wikidata.org/entity/Q79030196', 1),
(19, 14, 1, NULL, 'literal', NULL, NULL, 'Pendant', NULL, 1),
(20, 14, 35, NULL, 'wikidata:reconciliation:all', NULL, NULL, 'during', 'http://www.wikidata.org/entity/Q106580837', 1),
(23, 16, 1, NULL, 'literal', NULL, NULL, 'Après', NULL, 1),
(24, 16, 35, NULL, 'wikidata:reconciliation:all', NULL, NULL, 'after', 'http://www.wikidata.org/entity/Q12913816', 1),
(43, 26, 255, 13, 'customvocab:12', NULL, NULL, NULL, NULL, 1),
(44, 26, 256, NULL, 'numeric:integer', NULL, NULL, '1', NULL, 1),
(47, 28, 255, 13, 'customvocab:12', NULL, NULL, NULL, NULL, 1),
(48, 28, 256, NULL, 'numeric:integer', NULL, NULL, '1', NULL, 1),
(49, 29, 1, NULL, 'literal', '', NULL, 'Ecosytèmes de connaissances', NULL, 1),
(75, 42, 1, NULL, 'literal', NULL, NULL, 'Collaborations entre Jean-Pierre Balpe et Samuel Szoniecky', NULL, 1),
(76, 42, 4, NULL, 'literal', NULL, NULL, 'Retrace l\'évolution technologique, poétique et épistémologique des systèmes de génération automatique de textes, depuis les algorithmes combinatoires et chaotiques des années 1980-1990 jusqu\'aux architectures contemporaines d\'intelligence artificielle générative et multi-agents', NULL, 1),
(77, 43, 1, NULL, 'literal', NULL, NULL, 'Samuel Szoniecky', NULL, 1),
(78, 43, 316, 42, 'resource:item', NULL, NULL, NULL, NULL, 1),
(79, 44, 1, NULL, 'literal', NULL, NULL, 'Jean-Pierre Balpe', NULL, 1),
(80, 44, 316, 42, 'resource:item', NULL, NULL, NULL, NULL, 1),
(83, 46, 1, NULL, 'literal', NULL, NULL, 'HyperCard', NULL, 1),
(85, 46, 316, 42, 'customvocab:15', NULL, NULL, NULL, NULL, 1),
(92, 48, 1, NULL, 'literal', NULL, NULL, 'PhilosHard', NULL, 1),
(93, 48, 316, 42, 'resource:item', NULL, NULL, NULL, NULL, 1),
(94, 46, 225, 48, 'customvocab:4', NULL, NULL, NULL, NULL, 1),
(102, 54, 1, NULL, 'literal', '', NULL, 'Plastique d\'Espace Numérique', NULL, 1),
(103, 54, 316, 42, 'customvocab:15', NULL, NULL, NULL, NULL, 1),
(104, 55, 1, NULL, 'literal', NULL, NULL, 'IMG_20261104_164004.jpg', NULL, 1),
(105, 54, 20, NULL, 'numeric:timestamp', NULL, NULL, '1996-09-01', NULL, 1),
(110, 58, 1, NULL, 'literal', NULL, NULL, 'Samuel Szoniecky', NULL, 1),
(111, 58, 240, 43, 'customvocab:5', NULL, NULL, NULL, NULL, 1),
(114, 54, 317, NULL, 'numeric:integer', NULL, NULL, '100', NULL, 1),
(115, 54, 2, 43, 'resource', NULL, NULL, NULL, NULL, 1),
(155, 69, 1, NULL, 'literal', '', NULL, 'Décompose en parties', NULL, 1),
(156, 69, 4, NULL, 'literal', '', NULL, 'Décompose un élément physique en un nombre de parties défini dans la valeur d\'annotation jdc:cribleRatingValue', NULL, 1),
(157, 69, 319, NULL, 'literal', '', NULL, 'jdc:cribleRatingValue', NULL, 1),
(159, 69, 320, NULL, 'literal', '', NULL, 'decomposeParties', NULL, 1),
(180, 75, 1, NULL, 'literal', NULL, NULL, 'Plastique d\'Espace Numérique - page 1', NULL, 1),
(181, 75, 20, NULL, 'numeric:timestamp', NULL, NULL, '2026-11-05', NULL, 1),
(182, 75, 317, NULL, 'numeric:integer', NULL, NULL, '1', NULL, 1),
(183, 75, 316, 42, 'customvocab:15', NULL, NULL, NULL, NULL, 1),
(184, 75, 33, 54, 'resource:item', NULL, NULL, NULL, NULL, 1),
(185, 76, 1, NULL, 'literal', NULL, NULL, 'IMG_20261105_084858.jpg', NULL, 1),
(186, 77, 1, NULL, 'literal', NULL, NULL, 'Plastique d\'Espace Numérique - page 2', NULL, 1),
(187, 77, 33, 54, 'resource:item', NULL, NULL, NULL, NULL, 1),
(188, 77, 316, 42, 'customvocab:15', NULL, NULL, NULL, NULL, 1),
(189, 77, 20, NULL, 'numeric:timestamp', NULL, NULL, '2026-11-05', NULL, 1),
(190, 77, 317, NULL, 'numeric:integer', NULL, NULL, '1', NULL, 1),
(191, 78, 1, NULL, 'literal', NULL, NULL, 'Plastique d\'Espace Numérique - page 3', NULL, 1),
(192, 78, 33, 54, 'resource:item', NULL, NULL, NULL, NULL, 1),
(193, 78, 316, 42, 'customvocab:15', NULL, NULL, NULL, NULL, 1),
(194, 78, 20, NULL, 'numeric:timestamp', NULL, NULL, '2026-11-05', NULL, 1),
(195, 78, 317, NULL, 'numeric:integer', NULL, NULL, '1', NULL, 1),
(196, 79, 1, NULL, 'literal', '', NULL, 'Plastique d\'Espace Numérique - page 4', NULL, 1),
(197, 79, 33, 54, 'resource:item', NULL, NULL, NULL, NULL, 1),
(198, 79, 316, 42, 'customvocab:15', NULL, NULL, NULL, NULL, 1),
(199, 79, 20, NULL, 'numeric:timestamp', NULL, NULL, '2026-11-05', NULL, 1),
(200, 79, 317, NULL, 'numeric:integer', NULL, NULL, '1', NULL, 1),
(201, 80, 1, NULL, 'literal', NULL, NULL, 'Plastique d\'Espace Numérique - page 5', NULL, 1),
(202, 80, 33, 54, 'resource:item', NULL, NULL, NULL, NULL, 1),
(203, 80, 316, 42, 'customvocab:15', NULL, NULL, NULL, NULL, 1),
(204, 80, 20, NULL, 'numeric:timestamp', NULL, NULL, '2026-11-05', NULL, 1),
(205, 80, 317, NULL, 'numeric:integer', NULL, NULL, '1', NULL, 1),
(206, 81, 1, NULL, 'literal', '', NULL, 'Plastique d\'Espace Numérique - page 6', NULL, 1),
(207, 81, 33, 54, 'resource:item', NULL, NULL, NULL, NULL, 1),
(208, 81, 316, 42, 'customvocab:15', NULL, NULL, NULL, NULL, 1),
(209, 81, 20, NULL, 'numeric:timestamp', NULL, NULL, '2026-11-05', NULL, 1),
(210, 81, 317, NULL, 'numeric:integer', NULL, NULL, '1', NULL, 1),
(211, 82, 1, NULL, 'literal', NULL, NULL, 'Plastique d\'Espace Numérique - page 7', NULL, 1),
(212, 82, 33, 54, 'resource:item', NULL, NULL, NULL, NULL, 1),
(213, 82, 316, 42, 'customvocab:15', NULL, NULL, NULL, NULL, 1),
(214, 82, 20, NULL, 'numeric:timestamp', NULL, NULL, '2026-11-05', NULL, 1),
(215, 82, 317, NULL, 'numeric:integer', NULL, NULL, '1', NULL, 1),
(216, 83, 1, NULL, 'literal', NULL, NULL, 'Plastique d\'Espace Numérique - page 8', NULL, 1),
(217, 83, 33, 54, 'resource:item', NULL, NULL, NULL, NULL, 1),
(218, 83, 316, 42, 'customvocab:15', NULL, NULL, NULL, NULL, 1),
(219, 83, 20, NULL, 'numeric:timestamp', NULL, NULL, '2026-11-05', NULL, 1),
(220, 83, 317, NULL, 'numeric:integer', NULL, NULL, '1', NULL, 1),
(221, 84, 1, NULL, 'literal', NULL, NULL, 'Plastique d\'Espace Numérique - page 9', NULL, 1),
(222, 84, 33, 54, 'resource:item', NULL, NULL, NULL, NULL, 1),
(223, 84, 316, 42, 'customvocab:15', NULL, NULL, NULL, NULL, 1),
(224, 84, 20, NULL, 'numeric:timestamp', NULL, NULL, '2026-11-05', NULL, 1),
(225, 84, 317, NULL, 'numeric:integer', NULL, NULL, '1', NULL, 1),
(226, 85, 1, NULL, 'literal', NULL, NULL, 'Plastique d\'Espace Numérique - page 10', NULL, 1),
(227, 85, 33, 54, 'resource:item', NULL, NULL, NULL, NULL, 1),
(228, 85, 316, 42, 'customvocab:15', NULL, NULL, NULL, NULL, 1),
(229, 85, 20, NULL, 'numeric:timestamp', NULL, NULL, '2026-11-05', NULL, 1),
(230, 85, 317, NULL, 'numeric:integer', NULL, NULL, '1', NULL, 1),
(231, 86, 1, NULL, 'literal', NULL, NULL, 'Plastique d\'Espace Numérique - page 11', NULL, 1),
(232, 86, 33, 54, 'resource:item', NULL, NULL, NULL, NULL, 1),
(233, 86, 316, 42, 'customvocab:15', NULL, NULL, NULL, NULL, 1),
(234, 86, 20, NULL, 'numeric:timestamp', NULL, NULL, '2026-11-05', NULL, 1),
(235, 86, 317, NULL, 'numeric:integer', NULL, NULL, '1', NULL, 1),
(236, 87, 1, NULL, 'literal', NULL, NULL, 'Plastique d\'Espace Numérique - page 12', NULL, 1),
(237, 87, 33, 54, 'resource:item', NULL, NULL, NULL, NULL, 1),
(238, 87, 316, 42, 'customvocab:15', NULL, NULL, NULL, NULL, 1),
(239, 87, 20, NULL, 'numeric:timestamp', NULL, NULL, '2026-11-05', NULL, 1),
(240, 87, 317, NULL, 'numeric:integer', NULL, NULL, '1', NULL, 1),
(241, 88, 1, NULL, 'literal', NULL, NULL, 'Plastique d\'Espace Numérique - page 13', NULL, 1),
(242, 88, 33, 54, 'resource:item', NULL, NULL, NULL, NULL, 1),
(243, 88, 316, 42, 'customvocab:15', NULL, NULL, NULL, NULL, 1),
(244, 88, 20, NULL, 'numeric:timestamp', NULL, NULL, '2026-11-05', NULL, 1),
(245, 88, 317, NULL, 'numeric:integer', NULL, NULL, '1', NULL, 1),
(246, 89, 1, NULL, 'literal', NULL, NULL, 'Plastique d\'Espace Numérique - page 14', NULL, 1),
(247, 89, 33, 54, 'resource:item', NULL, NULL, NULL, NULL, 1),
(248, 89, 316, 42, 'customvocab:15', NULL, NULL, NULL, NULL, 1),
(249, 89, 20, NULL, 'numeric:timestamp', NULL, NULL, '2026-11-05', NULL, 1),
(250, 89, 317, NULL, 'numeric:integer', NULL, NULL, '1', NULL, 1),
(251, 90, 1, NULL, 'literal', '', NULL, 'Plastique d\'Espace Numérique - page 15', NULL, 1),
(252, 90, 33, 54, 'resource:item', NULL, NULL, NULL, NULL, 1),
(253, 90, 316, 42, 'customvocab:15', NULL, NULL, NULL, NULL, 1),
(254, 90, 20, NULL, 'numeric:timestamp', NULL, NULL, '2026-11-05', NULL, 1),
(255, 90, 317, NULL, 'numeric:integer', NULL, NULL, '1', NULL, 1),
(256, 91, 1, NULL, 'literal', NULL, NULL, 'Plastique d\'Espace Numérique - page 16', NULL, 1),
(257, 91, 33, 54, 'resource:item', NULL, NULL, NULL, NULL, 1),
(258, 91, 316, 42, 'customvocab:15', NULL, NULL, NULL, NULL, 1),
(259, 91, 20, NULL, 'numeric:timestamp', NULL, NULL, '2026-11-05', NULL, 1),
(260, 91, 317, NULL, 'numeric:integer', NULL, NULL, '1', NULL, 1),
(261, 92, 1, NULL, 'literal', NULL, NULL, 'Plastique d\'Espace Numérique - page 17', NULL, 1),
(262, 92, 33, 54, 'resource:item', NULL, NULL, NULL, NULL, 1),
(263, 92, 316, 42, 'customvocab:15', NULL, NULL, NULL, NULL, 1),
(264, 92, 20, NULL, 'numeric:timestamp', NULL, NULL, '2026-11-05', NULL, 1),
(265, 92, 317, NULL, 'numeric:integer', NULL, NULL, '1', NULL, 1),
(266, 93, 1, NULL, 'literal', NULL, NULL, 'Plastique d\'Espace Numérique - page 18', NULL, 1),
(267, 93, 33, 54, 'resource:item', NULL, NULL, NULL, NULL, 1),
(268, 93, 316, 42, 'customvocab:15', NULL, NULL, NULL, NULL, 1),
(269, 93, 20, NULL, 'numeric:timestamp', NULL, NULL, '2026-11-05', NULL, 1),
(270, 93, 317, NULL, 'numeric:integer', NULL, NULL, '1', NULL, 1),
(271, 94, 1, NULL, 'literal', NULL, NULL, 'Plastique d\'Espace Numérique - page 19', NULL, 1),
(272, 94, 33, 54, 'resource:item', NULL, NULL, NULL, NULL, 1),
(273, 94, 316, 42, 'customvocab:15', NULL, NULL, NULL, NULL, 1),
(274, 94, 20, NULL, 'numeric:timestamp', NULL, NULL, '2026-11-05', NULL, 1),
(275, 94, 317, NULL, 'numeric:integer', NULL, NULL, '1', NULL, 1),
(276, 95, 1, NULL, 'literal', NULL, NULL, 'Plastique d\'Espace Numérique - page 20', NULL, 1),
(277, 95, 33, 54, 'resource:item', NULL, NULL, NULL, NULL, 1),
(278, 95, 316, 42, 'customvocab:15', NULL, NULL, NULL, NULL, 1),
(279, 95, 20, NULL, 'numeric:timestamp', NULL, NULL, '2026-11-05', NULL, 1),
(280, 95, 317, NULL, 'numeric:integer', NULL, NULL, '1', NULL, 1),
(281, 96, 1, NULL, 'literal', NULL, NULL, 'Plastique d\'Espace Numérique - page 21', NULL, 1),
(282, 96, 33, 54, 'resource:item', NULL, NULL, NULL, NULL, 1),
(283, 96, 316, 42, 'customvocab:15', NULL, NULL, NULL, NULL, 1),
(284, 96, 20, NULL, 'numeric:timestamp', NULL, NULL, '2026-11-05', NULL, 1),
(285, 96, 317, NULL, 'numeric:integer', NULL, NULL, '1', NULL, 1),
(286, 97, 1, NULL, 'literal', NULL, NULL, 'Plastique d\'Espace Numérique - page 22', NULL, 1),
(287, 97, 33, 54, 'resource:item', NULL, NULL, NULL, NULL, 1),
(288, 97, 316, 42, 'customvocab:15', NULL, NULL, NULL, NULL, 1),
(289, 97, 20, NULL, 'numeric:timestamp', NULL, NULL, '2026-11-05', NULL, 1),
(290, 97, 317, NULL, 'numeric:integer', NULL, NULL, '1', NULL, 1),
(291, 98, 1, NULL, 'literal', NULL, NULL, 'Plastique d\'Espace Numérique - page 23', NULL, 1),
(292, 98, 33, 54, 'resource:item', NULL, NULL, NULL, NULL, 1),
(293, 98, 316, 42, 'customvocab:15', NULL, NULL, NULL, NULL, 1),
(294, 98, 20, NULL, 'numeric:timestamp', NULL, NULL, '2026-11-05', NULL, 1),
(295, 98, 317, NULL, 'numeric:integer', NULL, NULL, '1', NULL, 1),
(296, 99, 1, NULL, 'literal', NULL, NULL, 'Plastique d\'Espace Numérique - page 24', NULL, 1),
(297, 99, 33, 54, 'resource:item', NULL, NULL, NULL, NULL, 1),
(298, 99, 316, 42, 'customvocab:15', NULL, NULL, NULL, NULL, 1),
(299, 99, 20, NULL, 'numeric:timestamp', NULL, NULL, '2026-11-05', NULL, 1),
(300, 99, 317, NULL, 'numeric:integer', NULL, NULL, '1', NULL, 1),
(301, 100, 1, NULL, 'literal', NULL, NULL, 'Plastique d\'Espace Numérique - page 25', NULL, 1),
(302, 100, 33, 54, 'resource:item', NULL, NULL, NULL, NULL, 1),
(303, 100, 316, 42, 'customvocab:15', NULL, NULL, NULL, NULL, 1),
(304, 100, 20, NULL, 'numeric:timestamp', NULL, NULL, '2026-11-05', NULL, 1),
(305, 100, 317, NULL, 'numeric:integer', NULL, NULL, '1', NULL, 1),
(306, 101, 1, NULL, 'literal', NULL, NULL, 'Plastique d\'Espace Numérique - page 26', NULL, 1),
(307, 101, 33, 54, 'resource:item', NULL, NULL, NULL, NULL, 1),
(308, 101, 316, 42, 'customvocab:15', NULL, NULL, NULL, NULL, 1),
(309, 101, 20, NULL, 'numeric:timestamp', NULL, NULL, '2026-11-05', NULL, 1),
(310, 101, 317, NULL, 'numeric:integer', NULL, NULL, '1', NULL, 1),
(311, 102, 1, NULL, 'literal', NULL, NULL, 'Plastique d\'Espace Numérique - page 27', NULL, 1),
(312, 102, 33, 54, 'resource:item', NULL, NULL, NULL, NULL, 1),
(313, 102, 316, 42, 'customvocab:15', NULL, NULL, NULL, NULL, 1),
(314, 102, 20, NULL, 'numeric:timestamp', NULL, NULL, '2026-11-05', NULL, 1),
(315, 102, 317, NULL, 'numeric:integer', NULL, NULL, '1', NULL, 1),
(316, 103, 1, NULL, 'literal', NULL, NULL, 'Plastique d\'Espace Numérique - page 28', NULL, 1),
(317, 103, 33, 54, 'resource:item', NULL, NULL, NULL, NULL, 1),
(318, 103, 316, 42, 'customvocab:15', NULL, NULL, NULL, NULL, 1),
(319, 103, 20, NULL, 'numeric:timestamp', NULL, NULL, '2026-11-05', NULL, 1),
(320, 103, 317, NULL, 'numeric:integer', NULL, NULL, '1', NULL, 1),
(321, 104, 1, NULL, 'literal', NULL, NULL, 'Plastique d\'Espace Numérique - page 29', NULL, 1),
(322, 104, 33, 54, 'resource:item', NULL, NULL, NULL, NULL, 1),
(323, 104, 316, 42, 'customvocab:15', NULL, NULL, NULL, NULL, 1),
(324, 104, 20, NULL, 'numeric:timestamp', NULL, NULL, '2026-11-05', NULL, 1),
(325, 104, 317, NULL, 'numeric:integer', NULL, NULL, '1', NULL, 1),
(326, 105, 1, NULL, 'literal', NULL, NULL, 'Plastique d\'Espace Numérique - page 30', NULL, 1),
(327, 105, 33, 54, 'resource:item', NULL, NULL, NULL, NULL, 1),
(328, 105, 316, 42, 'customvocab:15', NULL, NULL, NULL, NULL, 1),
(329, 105, 20, NULL, 'numeric:timestamp', NULL, NULL, '2026-11-05', NULL, 1),
(330, 105, 317, NULL, 'numeric:integer', NULL, NULL, '1', NULL, 1),
(331, 106, 1, NULL, 'literal', NULL, NULL, 'Plastique d\'Espace Numérique - page 31', NULL, 1),
(332, 106, 33, 54, 'resource:item', NULL, NULL, NULL, NULL, 1),
(333, 106, 316, 42, 'customvocab:15', NULL, NULL, NULL, NULL, 1),
(334, 106, 20, NULL, 'numeric:timestamp', NULL, NULL, '2026-11-05', NULL, 1),
(335, 106, 317, NULL, 'numeric:integer', NULL, NULL, '1', NULL, 1),
(336, 107, 1, NULL, 'literal', NULL, NULL, 'Plastique d\'Espace Numérique - page 32', NULL, 1),
(337, 107, 33, 54, 'resource:item', NULL, NULL, NULL, NULL, 1),
(338, 107, 316, 42, 'customvocab:15', NULL, NULL, NULL, NULL, 1),
(339, 107, 20, NULL, 'numeric:timestamp', NULL, NULL, '2026-11-05', NULL, 1),
(340, 107, 317, NULL, 'numeric:integer', NULL, NULL, '1', NULL, 1),
(341, 108, 1, NULL, 'literal', NULL, NULL, 'Plastique d\'Espace Numérique - page 33', NULL, 1),
(342, 108, 33, 54, 'resource:item', NULL, NULL, NULL, NULL, 1),
(343, 108, 316, 42, 'customvocab:15', NULL, NULL, NULL, NULL, 1),
(344, 108, 20, NULL, 'numeric:timestamp', NULL, NULL, '2026-11-05', NULL, 1),
(345, 108, 317, NULL, 'numeric:integer', NULL, NULL, '1', NULL, 1),
(346, 109, 1, NULL, 'literal', NULL, NULL, 'Plastique d\'Espace Numérique - page 34', NULL, 1),
(347, 109, 33, 54, 'resource:item', NULL, NULL, NULL, NULL, 1),
(348, 109, 316, 42, 'customvocab:15', NULL, NULL, NULL, NULL, 1),
(349, 109, 20, NULL, 'numeric:timestamp', NULL, NULL, '2026-11-05', NULL, 1),
(350, 109, 317, NULL, 'numeric:integer', NULL, NULL, '1', NULL, 1),
(351, 110, 1, NULL, 'literal', NULL, NULL, 'Plastique d\'Espace Numérique - page 35', NULL, 1),
(352, 110, 33, 54, 'resource:item', NULL, NULL, NULL, NULL, 1),
(353, 110, 316, 42, 'customvocab:15', NULL, NULL, NULL, NULL, 1),
(354, 110, 20, NULL, 'numeric:timestamp', NULL, NULL, '2026-11-05', NULL, 1),
(355, 110, 317, NULL, 'numeric:integer', NULL, NULL, '1', NULL, 1),
(356, 111, 1, NULL, 'literal', NULL, NULL, 'Plastique d\'Espace Numérique - page 36', NULL, 1),
(357, 111, 33, 54, 'resource:item', NULL, NULL, NULL, NULL, 1),
(358, 111, 316, 42, 'customvocab:15', NULL, NULL, NULL, NULL, 1),
(359, 111, 20, NULL, 'numeric:timestamp', NULL, NULL, '2026-11-05', NULL, 1),
(360, 111, 317, NULL, 'numeric:integer', NULL, NULL, '1', NULL, 1),
(361, 112, 1, NULL, 'literal', NULL, NULL, 'Plastique d\'Espace Numérique - page 37', NULL, 1),
(362, 112, 33, 54, 'resource:item', NULL, NULL, NULL, NULL, 1),
(363, 112, 316, 42, 'customvocab:15', NULL, NULL, NULL, NULL, 1),
(364, 112, 20, NULL, 'numeric:timestamp', NULL, NULL, '2026-11-05', NULL, 1),
(365, 112, 317, NULL, 'numeric:integer', NULL, NULL, '1', NULL, 1),
(366, 113, 1, NULL, 'literal', NULL, NULL, 'Plastique d\'Espace Numérique - page 38', NULL, 1),
(367, 113, 33, 54, 'resource:item', NULL, NULL, NULL, NULL, 1),
(368, 113, 316, 42, 'customvocab:15', NULL, NULL, NULL, NULL, 1),
(369, 113, 20, NULL, 'numeric:timestamp', NULL, NULL, '2026-11-05', NULL, 1),
(370, 113, 317, NULL, 'numeric:integer', NULL, NULL, '1', NULL, 1),
(371, 114, 1, NULL, 'literal', NULL, NULL, 'Plastique d\'Espace Numérique - page 39', NULL, 1),
(372, 114, 33, 54, 'resource:item', NULL, NULL, NULL, NULL, 1),
(373, 114, 316, 42, 'customvocab:15', NULL, NULL, NULL, NULL, 1),
(374, 114, 20, NULL, 'numeric:timestamp', NULL, NULL, '2026-11-05', NULL, 1),
(375, 114, 317, NULL, 'numeric:integer', NULL, NULL, '1', NULL, 1),
(376, 115, 1, NULL, 'literal', NULL, NULL, 'Plastique d\'Espace Numérique - page 40', NULL, 1),
(377, 115, 33, 54, 'resource:item', NULL, NULL, NULL, NULL, 1),
(378, 115, 316, 42, 'customvocab:15', NULL, NULL, NULL, NULL, 1),
(379, 115, 20, NULL, 'numeric:timestamp', NULL, NULL, '2026-11-05', NULL, 1),
(380, 115, 317, NULL, 'numeric:integer', NULL, NULL, '1', NULL, 1),
(381, 116, 1, NULL, 'literal', NULL, NULL, 'Plastique d\'Espace Numérique - page 41', NULL, 1),
(382, 116, 33, 54, 'resource:item', NULL, NULL, NULL, NULL, 1),
(383, 116, 316, 42, 'customvocab:15', NULL, NULL, NULL, NULL, 1),
(384, 116, 20, NULL, 'numeric:timestamp', NULL, NULL, '2026-11-05', NULL, 1),
(385, 116, 317, NULL, 'numeric:integer', NULL, NULL, '1', NULL, 1),
(386, 117, 1, NULL, 'literal', NULL, NULL, 'Plastique d\'Espace Numérique - page 42', NULL, 1),
(387, 117, 33, 54, 'resource:item', NULL, NULL, NULL, NULL, 1),
(388, 117, 316, 42, 'customvocab:15', NULL, NULL, NULL, NULL, 1),
(389, 117, 20, NULL, 'numeric:timestamp', NULL, NULL, '2026-11-05', NULL, 1),
(390, 117, 317, NULL, 'numeric:integer', NULL, NULL, '1', NULL, 1),
(391, 118, 1, NULL, 'literal', NULL, NULL, 'Plastique d\'Espace Numérique - page 43', NULL, 1),
(392, 118, 33, 54, 'resource:item', NULL, NULL, NULL, NULL, 1),
(393, 118, 316, 42, 'customvocab:15', NULL, NULL, NULL, NULL, 1),
(394, 118, 20, NULL, 'numeric:timestamp', NULL, NULL, '2026-11-05', NULL, 1),
(395, 118, 317, NULL, 'numeric:integer', NULL, NULL, '1', NULL, 1),
(396, 119, 1, NULL, 'literal', NULL, NULL, 'Plastique d\'Espace Numérique - page 44', NULL, 1),
(397, 119, 33, 54, 'resource:item', NULL, NULL, NULL, NULL, 1),
(398, 119, 316, 42, 'customvocab:15', NULL, NULL, NULL, NULL, 1),
(399, 119, 20, NULL, 'numeric:timestamp', NULL, NULL, '2026-11-05', NULL, 1),
(400, 119, 317, NULL, 'numeric:integer', NULL, NULL, '1', NULL, 1),
(401, 120, 1, NULL, 'literal', NULL, NULL, 'Plastique d\'Espace Numérique - page 45', NULL, 1),
(402, 120, 33, 54, 'resource:item', NULL, NULL, NULL, NULL, 1),
(403, 120, 316, 42, 'customvocab:15', NULL, NULL, NULL, NULL, 1),
(404, 120, 20, NULL, 'numeric:timestamp', NULL, NULL, '2026-11-05', NULL, 1),
(405, 120, 317, NULL, 'numeric:integer', NULL, NULL, '1', NULL, 1),
(406, 121, 1, NULL, 'literal', NULL, NULL, 'Plastique d\'Espace Numérique - page 46', NULL, 1),
(407, 121, 33, 54, 'resource:item', NULL, NULL, NULL, NULL, 1),
(408, 121, 316, 42, 'customvocab:15', NULL, NULL, NULL, NULL, 1),
(409, 121, 20, NULL, 'numeric:timestamp', NULL, NULL, '2026-11-05', NULL, 1),
(410, 121, 317, NULL, 'numeric:integer', NULL, NULL, '1', NULL, 1),
(453, 136, 1, NULL, 'literal', NULL, NULL, 'Temporalité', NULL, 1),
(454, 136, 201, 13, 'resource:item', NULL, 183, NULL, NULL, 1),
(455, 13, 200, 136, 'resource:item', NULL, 230, NULL, NULL, 1),
(546, 136, 201, 14, 'resource:item', NULL, 182, NULL, NULL, 1),
(547, 182, 316, 42, 'resource:item', NULL, NULL, NULL, NULL, 1),
(548, 14, 200, 136, 'resource:item', NULL, 232, NULL, NULL, 1),
(549, 16, 200, 136, 'resource:item', NULL, 228, NULL, NULL, 1),
(550, 136, 201, 16, 'resource:item', NULL, 201, NULL, NULL, 1),
(551, 183, 316, 42, 'resource:item', NULL, NULL, NULL, NULL, 1),
(584, 201, 316, 42, 'resource:item', NULL, NULL, NULL, NULL, 1),
(604, 209, 1, NULL, 'literal', '', NULL, 'Pouvoirs', NULL, 1),
(605, 209, 35, NULL, 'wikidata:reconciliation:all', '', NULL, 'power', 'http://www.wikidata.org/entity/Q25107', 1),
(606, 210, 1, NULL, 'literal', '', NULL, 'Dicerner', NULL, 1),
(607, 210, 35, NULL, 'wikidata:reconciliation:all', '', NULL, 'discernment', 'http://www.wikidata.org/entity/Q1132167', 1),
(608, 210, 200, 209, 'customvocab:1', NULL, NULL, NULL, NULL, 1),
(609, 211, 1, NULL, 'literal', '', NULL, 'Raisonner', NULL, 1),
(610, 211, 35, NULL, 'wikidata:reconciliation:all', '', NULL, 'reason', 'http://www.wikidata.org/entity/Q178354', 1),
(611, 211, 200, 209, 'customvocab:1', NULL, NULL, NULL, NULL, 1),
(612, 211, 202, 210, 'customvocab:1', NULL, NULL, NULL, NULL, 1),
(613, 212, 1, NULL, 'literal', '', NULL, 'Résonner', NULL, 1),
(614, 212, 35, NULL, 'wikidata:reconciliation:all', '', NULL, 'resonance', 'http://www.wikidata.org/entity/Q172858', 1),
(615, 212, 200, 209, 'customvocab:1', NULL, NULL, NULL, NULL, 1),
(616, 212, 202, 210, 'customvocab:1', NULL, NULL, NULL, NULL, 1),
(617, 212, 202, 211, 'customvocab:1', NULL, NULL, NULL, NULL, 1),
(618, 213, 1, NULL, 'literal', '', NULL, 'Agir', NULL, 1),
(619, 213, 35, NULL, 'wikidata:reconciliation:all', '', NULL, 'activity', 'http://www.wikidata.org/entity/Q1914636', 1),
(620, 213, 200, 209, 'customvocab:1', NULL, NULL, NULL, NULL, 1),
(621, 213, 202, 211, 'customvocab:1', NULL, NULL, NULL, NULL, 1),
(622, 213, 202, 212, 'customvocab:1', NULL, NULL, NULL, NULL, 1),
(623, 211, 202, 212, 'customvocab:1', NULL, NULL, NULL, NULL, 1),
(624, 211, 202, 213, 'customvocab:1', NULL, NULL, NULL, NULL, 1),
(625, 212, 202, 213, 'customvocab:1', NULL, NULL, NULL, NULL, 1),
(626, 214, 1, NULL, 'literal', '', NULL, 'Pouvoirs', NULL, 1),
(656, 221, 1, NULL, 'literal', NULL, NULL, 'HyperCard', NULL, 1),
(657, 221, 316, 42, 'customvocab:15', NULL, NULL, NULL, NULL, 1),
(660, 221, 251, 46, 'customvocab:2', NULL, NULL, NULL, NULL, 1),
(663, 224, 1, NULL, 'literal', NULL, NULL, 'source', NULL, 1),
(664, 224, 316, 42, 'resource:item', NULL, NULL, NULL, NULL, 1),
(665, 225, 1, NULL, 'literal', NULL, NULL, 'Définir les sources', NULL, 1),
(666, 225, 221, 58, 'resource:item', NULL, NULL, NULL, NULL, 1),
(667, 225, 221, 221, 'resource:item', NULL, 264, NULL, NULL, 1),
(668, 225, 225, 48, 'resource:item', NULL, NULL, NULL, NULL, 1),
(669, 225, 222, 75, 'resource:item', NULL, NULL, NULL, NULL, 1),
(670, 225, 223, 224, 'resource:item', NULL, NULL, NULL, NULL, 1),
(671, 225, 223, 266, 'resource:item', NULL, NULL, NULL, NULL, 1),
(672, 225, 8, 210, 'customvocab:16', NULL, NULL, NULL, NULL, 1),
(677, 228, 316, 42, 'resource:item', NULL, NULL, NULL, NULL, 1),
(680, 230, 316, 42, 'resource:item', NULL, NULL, NULL, NULL, 1),
(683, 232, 316, 42, 'resource:item', NULL, NULL, NULL, NULL, 1),
(753, 225, 252, NULL, 'literal', NULL, NULL, '0', NULL, 1),
(754, 264, 8, NULL, 'literal', NULL, NULL, 'actant', NULL, 1),
(757, 266, 1, NULL, 'literal', '', NULL, 'Définir', NULL, 1),
(758, 266, 316, 42, 'customvocab:15', NULL, NULL, NULL, NULL, 1),
(782, 58, 316, 42, 'customvocab:15', NULL, NULL, NULL, NULL, 1),
(791, 225, 316, 42, 'resource:item', NULL, NULL, NULL, NULL, 1),
(792, 280, 1, NULL, 'literal', NULL, NULL, 'Evaluer la pertinence', NULL, 1),
(793, 280, 221, 58, 'resource:item', NULL, 281, NULL, NULL, 1),
(794, 281, 8, NULL, 'literal', NULL, NULL, 'actant', NULL, 1),
(795, 280, 223, 224, 'resource:item', NULL, 282, NULL, NULL, 1),
(796, 282, 8, NULL, 'literal', NULL, NULL, 'concept source', NULL, 1),
(797, 280, 223, 266, 'resource:item', NULL, 283, NULL, NULL, 1),
(798, 283, 8, NULL, 'literal', NULL, NULL, 'concept destination', NULL, 1),
(799, 280, 8, 211, 'customvocab:16', NULL, NULL, NULL, NULL, 1),
(800, 280, 252, NULL, 'literal', NULL, NULL, '0', NULL, 1),
(801, 280, 316, 42, 'resource:item', NULL, NULL, NULL, NULL, 1),
(802, 284, 1, NULL, 'literal', NULL, NULL, 'Saisir', NULL, 1),
(803, 284, 316, 42, 'customvocab:15', NULL, NULL, NULL, NULL, 1),
(804, 285, 1, NULL, 'literal', NULL, NULL, 'EcoSpace : positions des éléments', NULL, 1),
(805, 285, 10, NULL, 'literal', NULL, NULL, 'ecospace-42', NULL, 1),
(806, 286, 1, NULL, 'literal', NULL, NULL, 'Saisir les données', NULL, 1),
(807, 286, 221, 58, 'resource:item', NULL, 287, NULL, NULL, 1),
(808, 287, 8, NULL, 'literal', NULL, NULL, 'actant', NULL, 1),
(809, 286, 221, 221, 'resource:item', NULL, 288, NULL, NULL, 1),
(810, 288, 8, NULL, 'literal', NULL, NULL, 'actant', NULL, 1),
(811, 286, 225, 48, 'resource:item', NULL, 289, NULL, NULL, 1),
(812, 289, 8, NULL, 'literal', NULL, NULL, 'crible', NULL, 1),
(813, 286, 222, 75, 'resource:item', NULL, 290, NULL, NULL, 1),
(814, 290, 8, NULL, 'literal', NULL, NULL, 'physique', NULL, 1),
(815, 286, 223, 224, 'resource:item', NULL, 291, NULL, NULL, 1),
(816, 291, 8, NULL, 'literal', NULL, NULL, 'concept', NULL, 1),
(817, 286, 223, 284, 'resource:item', NULL, 292, NULL, NULL, 1),
(818, 292, 8, NULL, 'literal', NULL, NULL, 'concept', NULL, 1),
(819, 286, 8, 213, 'customvocab:16', NULL, NULL, NULL, NULL, 1),
(820, 286, 252, NULL, 'literal', NULL, NULL, '0', NULL, 1),
(821, 286, 316, 42, 'resource:item', NULL, NULL, NULL, NULL, 1),
(835, 299, 1, NULL, 'literal', NULL, NULL, 'Initialiser une partition multimédia', NULL, 1),
(836, 299, 257, 225, 'customvocab:8', NULL, 301, NULL, NULL, 1),
(837, 299, 257, 280, 'customvocab:8', NULL, 300, NULL, NULL, 1),
(838, 300, 255, 14, 'customvocab:12', NULL, NULL, NULL, NULL, 1),
(839, 299, 257, 286, 'customvocab:8', NULL, 302, NULL, NULL, 1),
(840, 301, 255, 14, 'customvocab:12', NULL, NULL, NULL, NULL, 1),
(841, 301, 256, NULL, 'numeric:integer', NULL, NULL, '1', NULL, 1),
(842, 299, 316, 42, 'resource:item', NULL, NULL, NULL, NULL, 1),
(843, 300, 256, NULL, 'numeric:integer', NULL, NULL, '2', NULL, 1),
(844, 302, 255, 14, 'customvocab:12', NULL, NULL, NULL, NULL, 1),
(845, 302, 256, NULL, 'numeric:integer', NULL, NULL, '3', NULL, 1);

-- --------------------------------------------------------

--
-- Structure de la table `value_annotation`
--

CREATE TABLE `value_annotation` (
  `id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `value_annotation`
--

INSERT INTO `value_annotation` (`id`) VALUES
(26),
(28),
(182),
(183),
(201),
(228),
(230),
(232),
(264),
(281),
(282),
(283),
(287),
(288),
(289),
(290),
(291),
(292),
(300),
(301),
(302);

-- --------------------------------------------------------

--
-- Structure de la table `vocabulary`
--

CREATE TABLE `vocabulary` (
  `id` int(11) NOT NULL,
  `owner_id` int(11) DEFAULT NULL,
  `namespace_uri` varchar(190) NOT NULL,
  `prefix` varchar(190) NOT NULL,
  `label` varchar(255) NOT NULL,
  `comment` longtext DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `vocabulary`
--

INSERT INTO `vocabulary` (`id`, `owner_id`, `namespace_uri`, `prefix`, `label`, `comment`) VALUES
(1, NULL, 'http://purl.org/dc/terms/', 'dcterms', 'Dublin Core', 'Basic resource metadata (DCMI Metadata Terms)'),
(2, NULL, 'http://purl.org/dc/dcmitype/', 'dctype', 'Dublin Core Type', 'Basic resource types (DCMI Type Vocabulary)'),
(3, NULL, 'http://purl.org/ontology/bibo/', 'bibo', 'Bibliographic Ontology', 'Bibliographic metadata (BIBO)'),
(4, NULL, 'http://xmlns.com/foaf/0.1/', 'foaf', 'Friend of a Friend', 'Relationships between people and organizations (FOAF)'),
(5, 1, 'http://www.w3.org/2004/02/skos/core#', 'skos', 'SKOS', 'Simple Knowledge Organization System'),
(6, 1, 'https://jardindesconnaissances.univ-paris8.fr/onto/jdc#', 'jdc', 'Jardin des connaissances', 'Vocabulaire pour gérer les écosystèmes de connaissances.'),
(7, 1, 'http://www.w3.org/ns/oa#', 'oa', 'Web Annotation Ontology', 'The Web Annotation Vocabulary specifies the set of RDF classes, predicates and named entities that are used by the Web Annotation Data Model (http://www.w3.org/TR/annotation-model/).'),
(8, 1, 'http://www.w3.org/1999/02/22-rdf-syntax-ns#', 'rdf', 'The RDF Concepts Vocabulary (RDF)', 'This is the RDF Schema for the RDF vocabulary terms in the RDF Namespace, defined in RDF 1.1 Concepts.'),
(9, 1, 'https://omeka.org/s/vocabs/curation/', 'curation', 'curation', '');

--
-- Index pour les tables déchargées
--

--
-- Index pour la table `annotation`
--
ALTER TABLE `annotation`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `annotation_value`
--
ALTER TABLE `annotation_value`
  ADD PRIMARY KEY (`id`),
  ADD KEY `IDX_annotation_value_parts` (`annotation_id`,`field`,`ordinal`);

--
-- Index pour la table `api_key`
--
ALTER TABLE `api_key`
  ADD PRIMARY KEY (`id`),
  ADD KEY `IDX_C912ED9D7E3C61F9` (`owner_id`);

--
-- Index pour la table `asset`
--
ALTER TABLE `asset`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `UNIQ_2AF5A5C5CC5DB90` (`storage_id`),
  ADD KEY `IDX_2AF5A5C7E3C61F9` (`owner_id`);

--
-- Index pour la table `custom_vocab`
--
ALTER TABLE `custom_vocab`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `UNIQ_8533D2A5EA750E8` (`label`),
  ADD KEY `IDX_8533D2A5960278D7` (`item_set_id`),
  ADD KEY `IDX_8533D2A57E3C61F9` (`owner_id`);

--
-- Index pour la table `fulltext_search`
--
ALTER TABLE `fulltext_search`
  ADD PRIMARY KEY (`id`,`resource`),
  ADD KEY `IDX_AA31FE4A7E3C61F9` (`owner_id`),
  ADD KEY `is_public` (`is_public`);
ALTER TABLE `fulltext_search` ADD FULLTEXT KEY `IDX_AA31FE4A2B36786B3B8BA7C7` (`title`,`text`);

--
-- Index pour la table `item`
--
ALTER TABLE `item`
  ADD PRIMARY KEY (`id`),
  ADD KEY `IDX_1F1B251ECBE0B084` (`primary_media_id`);

--
-- Index pour la table `item_item_set`
--
ALTER TABLE `item_item_set`
  ADD PRIMARY KEY (`item_id`,`item_set_id`),
  ADD KEY `IDX_6D0C9625126F525E` (`item_id`),
  ADD KEY `IDX_6D0C9625960278D7` (`item_set_id`);

--
-- Index pour la table `item_set`
--
ALTER TABLE `item_set`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `item_site`
--
ALTER TABLE `item_site`
  ADD PRIMARY KEY (`item_id`,`site_id`),
  ADD KEY `IDX_A1734D1F126F525E` (`item_id`),
  ADD KEY `IDX_A1734D1FF6BD1646` (`site_id`),
  ADD KEY `idx_site_item` (`site_id`,`item_id`);

--
-- Index pour la table `job`
--
ALTER TABLE `job`
  ADD PRIMARY KEY (`id`),
  ADD KEY `IDX_FBD8E0F87E3C61F9` (`owner_id`);

--
-- Index pour la table `mapper`
--
ALTER TABLE `mapper`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `UNIQ_38B5A4E4EA750E8` (`label`),
  ADD KEY `IDX_38B5A4E47E3C61F9` (`owner_id`);

--
-- Index pour la table `media`
--
ALTER TABLE `media`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `UNIQ_6A2CA10C5CC5DB90` (`storage_id`),
  ADD KEY `IDX_6A2CA10C126F525E` (`item_id`),
  ADD KEY `item_position` (`item_id`,`position`),
  ADD KEY `media_type` (`media_type`),
  ADD KEY `ingester` (`ingester`),
  ADD KEY `renderer` (`renderer`),
  ADD KEY `extension` (`extension`);

--
-- Index pour la table `migration`
--
ALTER TABLE `migration`
  ADD PRIMARY KEY (`version`);

--
-- Index pour la table `module`
--
ALTER TABLE `module`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `numeric_data_types_duration`
--
ALTER TABLE `numeric_data_types_duration`
  ADD PRIMARY KEY (`id`),
  ADD KEY `IDX_E1B5FC6089329D25` (`resource_id`),
  ADD KEY `IDX_E1B5FC60549213EC` (`property_id`),
  ADD KEY `property_value` (`property_id`,`value`),
  ADD KEY `value` (`value`);

--
-- Index pour la table `numeric_data_types_integer`
--
ALTER TABLE `numeric_data_types_integer`
  ADD PRIMARY KEY (`id`),
  ADD KEY `IDX_6D39C79089329D25` (`resource_id`),
  ADD KEY `IDX_6D39C790549213EC` (`property_id`),
  ADD KEY `property_value` (`property_id`,`value`),
  ADD KEY `value` (`value`);

--
-- Index pour la table `numeric_data_types_interval`
--
ALTER TABLE `numeric_data_types_interval`
  ADD PRIMARY KEY (`id`),
  ADD KEY `IDX_7E2C936B89329D25` (`resource_id`),
  ADD KEY `IDX_7E2C936B549213EC` (`property_id`),
  ADD KEY `property_value` (`property_id`,`value`),
  ADD KEY `value` (`value`);

--
-- Index pour la table `numeric_data_types_timestamp`
--
ALTER TABLE `numeric_data_types_timestamp`
  ADD PRIMARY KEY (`id`),
  ADD KEY `IDX_7367AFAA89329D25` (`resource_id`),
  ADD KEY `IDX_7367AFAA549213EC` (`property_id`),
  ADD KEY `property_value` (`property_id`,`value`),
  ADD KEY `value` (`value`);

--
-- Index pour la table `password_creation`
--
ALTER TABLE `password_creation`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `UNIQ_C77917B4A76ED395` (`user_id`);

--
-- Index pour la table `property`
--
ALTER TABLE `property`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `UNIQ_8BF21CDEAD0E05F6623C14D5` (`vocabulary_id`,`local_name`),
  ADD KEY `IDX_8BF21CDE7E3C61F9` (`owner_id`),
  ADD KEY `IDX_8BF21CDEAD0E05F6` (`vocabulary_id`);

--
-- Index pour la table `resource`
--
ALTER TABLE `resource`
  ADD PRIMARY KEY (`id`),
  ADD KEY `IDX_BC91F4167E3C61F9` (`owner_id`),
  ADD KEY `IDX_BC91F416448CC1BD` (`resource_class_id`),
  ADD KEY `IDX_BC91F41616131EA` (`resource_template_id`),
  ADD KEY `IDX_BC91F416FDFF2E92` (`thumbnail_id`),
  ADD KEY `title` (`title`(190)),
  ADD KEY `is_public` (`is_public`),
  ADD KEY `resource_type` (`resource_type`),
  ADD KEY `idx_type_created` (`resource_type`,`created`),
  ADD KEY `idx_type_modified` (`resource_type`,`modified`);

--
-- Index pour la table `resource_class`
--
ALTER TABLE `resource_class`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `UNIQ_C6F063ADAD0E05F6623C14D5` (`vocabulary_id`,`local_name`),
  ADD KEY `IDX_C6F063AD7E3C61F9` (`owner_id`),
  ADD KEY `IDX_C6F063ADAD0E05F6` (`vocabulary_id`);

--
-- Index pour la table `resource_template`
--
ALTER TABLE `resource_template`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `UNIQ_39ECD52EEA750E8` (`label`),
  ADD KEY `IDX_39ECD52E7E3C61F9` (`owner_id`),
  ADD KEY `IDX_39ECD52E448CC1BD` (`resource_class_id`),
  ADD KEY `IDX_39ECD52E724734A3` (`title_property_id`),
  ADD KEY `IDX_39ECD52EB84E0D1D` (`description_property_id`);

--
-- Index pour la table `resource_template_data`
--
ALTER TABLE `resource_template_data`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uniq_resource_template_id` (`resource_template_id`);

--
-- Index pour la table `resource_template_property`
--
ALTER TABLE `resource_template_property`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `UNIQ_4689E2F116131EA549213EC` (`resource_template_id`,`property_id`),
  ADD KEY `IDX_4689E2F116131EA` (`resource_template_id`),
  ADD KEY `IDX_4689E2F1549213EC` (`property_id`);

--
-- Index pour la table `resource_template_property_data`
--
ALTER TABLE `resource_template_property_data`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_resource_template_id` (`resource_template_id`),
  ADD KEY `idx_resource_template_property_id` (`resource_template_property_id`);

--
-- Index pour la table `session`
--
ALTER TABLE `session`
  ADD PRIMARY KEY (`id`),
  ADD KEY `modified` (`modified`);

--
-- Index pour la table `setting`
--
ALTER TABLE `setting`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `site`
--
ALTER TABLE `site`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `UNIQ_694309E4989D9B62` (`slug`),
  ADD UNIQUE KEY `UNIQ_694309E4571EDDA` (`homepage_id`),
  ADD KEY `IDX_694309E4FDFF2E92` (`thumbnail_id`),
  ADD KEY `IDX_694309E47E3C61F9` (`owner_id`);

--
-- Index pour la table `site_block_attachment`
--
ALTER TABLE `site_block_attachment`
  ADD PRIMARY KEY (`id`),
  ADD KEY `IDX_236473FEE9ED820C` (`block_id`),
  ADD KEY `IDX_236473FE126F525E` (`item_id`),
  ADD KEY `IDX_236473FEEA9FDD75` (`media_id`),
  ADD KEY `block_position` (`block_id`,`position`);

--
-- Index pour la table `site_item_set`
--
ALTER TABLE `site_item_set`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `UNIQ_D4CE134F6BD1646960278D7` (`site_id`,`item_set_id`),
  ADD KEY `IDX_D4CE134F6BD1646` (`site_id`),
  ADD KEY `IDX_D4CE134960278D7` (`item_set_id`),
  ADD KEY `position` (`position`);

--
-- Index pour la table `site_page`
--
ALTER TABLE `site_page`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `UNIQ_2F900BD9F6BD1646989D9B62` (`site_id`,`slug`),
  ADD KEY `is_public` (`is_public`),
  ADD KEY `IDX_2F900BD9F6BD1646` (`site_id`);

--
-- Index pour la table `site_page_block`
--
ALTER TABLE `site_page_block`
  ADD PRIMARY KEY (`id`),
  ADD KEY `IDX_C593E731C4663E4` (`page_id`),
  ADD KEY `page_position` (`page_id`,`position`);

--
-- Index pour la table `site_permission`
--
ALTER TABLE `site_permission`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `UNIQ_C0401D6FF6BD1646A76ED395` (`site_id`,`user_id`),
  ADD KEY `IDX_C0401D6FF6BD1646` (`site_id`),
  ADD KEY `IDX_C0401D6FA76ED395` (`user_id`);

--
-- Index pour la table `site_setting`
--
ALTER TABLE `site_setting`
  ADD PRIMARY KEY (`id`,`site_id`),
  ADD KEY `IDX_64D05A53F6BD1646` (`site_id`);

--
-- Index pour la table `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `UNIQ_8D93D649E7927C74` (`email`);

--
-- Index pour la table `user_setting`
--
ALTER TABLE `user_setting`
  ADD PRIMARY KEY (`id`,`user_id`),
  ADD KEY `IDX_C779A692A76ED395` (`user_id`);

--
-- Index pour la table `value`
--
ALTER TABLE `value`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `UNIQ_1D7758349B66727E` (`value_annotation_id`),
  ADD KEY `IDX_1D77583489329D25` (`resource_id`),
  ADD KEY `IDX_1D775834549213EC` (`property_id`),
  ADD KEY `IDX_1D7758344BC72506` (`value_resource_id`),
  ADD KEY `value` (`value`(190)),
  ADD KEY `uri` (`uri`(190)),
  ADD KEY `is_public` (`is_public`),
  ADD KEY `type` (`type`),
  ADD KEY `lang` (`lang`),
  ADD KEY `idx_property_value` (`property_id`,`value`(190)),
  ADD KEY `idx_property_value_resource` (`property_id`,`value_resource_id`);

--
-- Index pour la table `value_annotation`
--
ALTER TABLE `value_annotation`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `vocabulary`
--
ALTER TABLE `vocabulary`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `UNIQ_9099C97B9B267FDF` (`namespace_uri`),
  ADD UNIQUE KEY `UNIQ_9099C97B93B1868E` (`prefix`),
  ADD KEY `IDX_9099C97B7E3C61F9` (`owner_id`);

--
-- AUTO_INCREMENT pour les tables déchargées
--

--
-- AUTO_INCREMENT pour la table `asset`
--
ALTER TABLE `asset`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `custom_vocab`
--
ALTER TABLE `custom_vocab`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT pour la table `job`
--
ALTER TABLE `job`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT pour la table `mapper`
--
ALTER TABLE `mapper`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `numeric_data_types_duration`
--
ALTER TABLE `numeric_data_types_duration`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `numeric_data_types_integer`
--
ALTER TABLE `numeric_data_types_integer`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=67;

--
-- AUTO_INCREMENT pour la table `numeric_data_types_interval`
--
ALTER TABLE `numeric_data_types_interval`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `numeric_data_types_timestamp`
--
ALTER TABLE `numeric_data_types_timestamp`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=67;

--
-- AUTO_INCREMENT pour la table `property`
--
ALTER TABLE `property`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=321;

--
-- AUTO_INCREMENT pour la table `resource`
--
ALTER TABLE `resource`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=303;

--
-- AUTO_INCREMENT pour la table `resource_class`
--
ALTER TABLE `resource_class`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=153;

--
-- AUTO_INCREMENT pour la table `resource_template`
--
ALTER TABLE `resource_template`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT pour la table `resource_template_data`
--
ALTER TABLE `resource_template_data`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT pour la table `resource_template_property`
--
ALTER TABLE `resource_template_property`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=87;

--
-- AUTO_INCREMENT pour la table `resource_template_property_data`
--
ALTER TABLE `resource_template_property_data`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=67;

--
-- AUTO_INCREMENT pour la table `site`
--
ALTER TABLE `site`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `site_block_attachment`
--
ALTER TABLE `site_block_attachment`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `site_item_set`
--
ALTER TABLE `site_item_set`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `site_page`
--
ALTER TABLE `site_page`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `site_page_block`
--
ALTER TABLE `site_page_block`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `site_permission`
--
ALTER TABLE `site_permission`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `user`
--
ALTER TABLE `user`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT pour la table `value`
--
ALTER TABLE `value`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=846;

--
-- AUTO_INCREMENT pour la table `vocabulary`
--
ALTER TABLE `vocabulary`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- Contraintes pour les tables déchargées
--

--
-- Contraintes pour la table `annotation`
--
ALTER TABLE `annotation`
  ADD CONSTRAINT `FK_2E443EF2BF396750` FOREIGN KEY (`id`) REFERENCES `resource` (`id`) ON DELETE CASCADE;

--
-- Contraintes pour la table `annotation_value`
--
ALTER TABLE `annotation_value`
  ADD CONSTRAINT `FK_annotation_value_annotation` FOREIGN KEY (`annotation_id`) REFERENCES `annotation` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `FK_annotation_value_value` FOREIGN KEY (`id`) REFERENCES `value` (`id`) ON DELETE CASCADE;

--
-- Contraintes pour la table `api_key`
--
ALTER TABLE `api_key`
  ADD CONSTRAINT `FK_C912ED9D7E3C61F9` FOREIGN KEY (`owner_id`) REFERENCES `user` (`id`);

--
-- Contraintes pour la table `asset`
--
ALTER TABLE `asset`
  ADD CONSTRAINT `FK_2AF5A5C7E3C61F9` FOREIGN KEY (`owner_id`) REFERENCES `user` (`id`) ON DELETE SET NULL;

--
-- Contraintes pour la table `custom_vocab`
--
ALTER TABLE `custom_vocab`
  ADD CONSTRAINT `FK_8533D2A57E3C61F9` FOREIGN KEY (`owner_id`) REFERENCES `user` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `FK_8533D2A5960278D7` FOREIGN KEY (`item_set_id`) REFERENCES `item_set` (`id`) ON DELETE SET NULL;

--
-- Contraintes pour la table `fulltext_search`
--
ALTER TABLE `fulltext_search`
  ADD CONSTRAINT `FK_AA31FE4A7E3C61F9` FOREIGN KEY (`owner_id`) REFERENCES `user` (`id`) ON DELETE SET NULL;

--
-- Contraintes pour la table `item`
--
ALTER TABLE `item`
  ADD CONSTRAINT `FK_1F1B251EBF396750` FOREIGN KEY (`id`) REFERENCES `resource` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `FK_1F1B251ECBE0B084` FOREIGN KEY (`primary_media_id`) REFERENCES `media` (`id`) ON DELETE SET NULL;

--
-- Contraintes pour la table `item_item_set`
--
ALTER TABLE `item_item_set`
  ADD CONSTRAINT `FK_6D0C9625126F525E` FOREIGN KEY (`item_id`) REFERENCES `item` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `FK_6D0C9625960278D7` FOREIGN KEY (`item_set_id`) REFERENCES `item_set` (`id`) ON DELETE CASCADE;

--
-- Contraintes pour la table `item_set`
--
ALTER TABLE `item_set`
  ADD CONSTRAINT `FK_1015EEEBF396750` FOREIGN KEY (`id`) REFERENCES `resource` (`id`) ON DELETE CASCADE;

--
-- Contraintes pour la table `item_site`
--
ALTER TABLE `item_site`
  ADD CONSTRAINT `FK_A1734D1F126F525E` FOREIGN KEY (`item_id`) REFERENCES `item` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `FK_A1734D1FF6BD1646` FOREIGN KEY (`site_id`) REFERENCES `site` (`id`) ON DELETE CASCADE;

--
-- Contraintes pour la table `job`
--
ALTER TABLE `job`
  ADD CONSTRAINT `FK_FBD8E0F87E3C61F9` FOREIGN KEY (`owner_id`) REFERENCES `user` (`id`) ON DELETE SET NULL;

--
-- Contraintes pour la table `mapper`
--
ALTER TABLE `mapper`
  ADD CONSTRAINT `FK_38B5A4E47E3C61F9` FOREIGN KEY (`owner_id`) REFERENCES `user` (`id`) ON DELETE SET NULL;

--
-- Contraintes pour la table `media`
--
ALTER TABLE `media`
  ADD CONSTRAINT `FK_6A2CA10C126F525E` FOREIGN KEY (`item_id`) REFERENCES `item` (`id`),
  ADD CONSTRAINT `FK_6A2CA10CBF396750` FOREIGN KEY (`id`) REFERENCES `resource` (`id`) ON DELETE CASCADE;

--
-- Contraintes pour la table `numeric_data_types_duration`
--
ALTER TABLE `numeric_data_types_duration`
  ADD CONSTRAINT `FK_E1B5FC60549213EC` FOREIGN KEY (`property_id`) REFERENCES `property` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `FK_E1B5FC6089329D25` FOREIGN KEY (`resource_id`) REFERENCES `resource` (`id`) ON DELETE CASCADE;

--
-- Contraintes pour la table `numeric_data_types_integer`
--
ALTER TABLE `numeric_data_types_integer`
  ADD CONSTRAINT `FK_6D39C790549213EC` FOREIGN KEY (`property_id`) REFERENCES `property` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `FK_6D39C79089329D25` FOREIGN KEY (`resource_id`) REFERENCES `resource` (`id`) ON DELETE CASCADE;

--
-- Contraintes pour la table `numeric_data_types_interval`
--
ALTER TABLE `numeric_data_types_interval`
  ADD CONSTRAINT `FK_7E2C936B549213EC` FOREIGN KEY (`property_id`) REFERENCES `property` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `FK_7E2C936B89329D25` FOREIGN KEY (`resource_id`) REFERENCES `resource` (`id`) ON DELETE CASCADE;

--
-- Contraintes pour la table `numeric_data_types_timestamp`
--
ALTER TABLE `numeric_data_types_timestamp`
  ADD CONSTRAINT `FK_7367AFAA549213EC` FOREIGN KEY (`property_id`) REFERENCES `property` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `FK_7367AFAA89329D25` FOREIGN KEY (`resource_id`) REFERENCES `resource` (`id`) ON DELETE CASCADE;

--
-- Contraintes pour la table `password_creation`
--
ALTER TABLE `password_creation`
  ADD CONSTRAINT `FK_C77917B4A76ED395` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE;

--
-- Contraintes pour la table `property`
--
ALTER TABLE `property`
  ADD CONSTRAINT `FK_8BF21CDE7E3C61F9` FOREIGN KEY (`owner_id`) REFERENCES `user` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `FK_8BF21CDEAD0E05F6` FOREIGN KEY (`vocabulary_id`) REFERENCES `vocabulary` (`id`);

--
-- Contraintes pour la table `resource`
--
ALTER TABLE `resource`
  ADD CONSTRAINT `FK_BC91F41616131EA` FOREIGN KEY (`resource_template_id`) REFERENCES `resource_template` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `FK_BC91F416448CC1BD` FOREIGN KEY (`resource_class_id`) REFERENCES `resource_class` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `FK_BC91F4167E3C61F9` FOREIGN KEY (`owner_id`) REFERENCES `user` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `FK_BC91F416FDFF2E92` FOREIGN KEY (`thumbnail_id`) REFERENCES `asset` (`id`) ON DELETE SET NULL;

--
-- Contraintes pour la table `resource_class`
--
ALTER TABLE `resource_class`
  ADD CONSTRAINT `FK_C6F063AD7E3C61F9` FOREIGN KEY (`owner_id`) REFERENCES `user` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `FK_C6F063ADAD0E05F6` FOREIGN KEY (`vocabulary_id`) REFERENCES `vocabulary` (`id`);

--
-- Contraintes pour la table `resource_template`
--
ALTER TABLE `resource_template`
  ADD CONSTRAINT `FK_39ECD52E448CC1BD` FOREIGN KEY (`resource_class_id`) REFERENCES `resource_class` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `FK_39ECD52E724734A3` FOREIGN KEY (`title_property_id`) REFERENCES `property` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `FK_39ECD52E7E3C61F9` FOREIGN KEY (`owner_id`) REFERENCES `user` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `FK_39ECD52EB84E0D1D` FOREIGN KEY (`description_property_id`) REFERENCES `property` (`id`) ON DELETE SET NULL;

--
-- Contraintes pour la table `resource_template_data`
--
ALTER TABLE `resource_template_data`
  ADD CONSTRAINT `FK_31D1FFC816131EA` FOREIGN KEY (`resource_template_id`) REFERENCES `resource_template` (`id`) ON DELETE CASCADE;

--
-- Contraintes pour la table `resource_template_property`
--
ALTER TABLE `resource_template_property`
  ADD CONSTRAINT `FK_4689E2F116131EA` FOREIGN KEY (`resource_template_id`) REFERENCES `resource_template` (`id`),
  ADD CONSTRAINT `FK_4689E2F1549213EC` FOREIGN KEY (`property_id`) REFERENCES `property` (`id`) ON DELETE CASCADE;

--
-- Contraintes pour la table `resource_template_property_data`
--
ALTER TABLE `resource_template_property_data`
  ADD CONSTRAINT `FK_B133BBAA16131EA` FOREIGN KEY (`resource_template_id`) REFERENCES `resource_template` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `FK_B133BBAA2A6B767B` FOREIGN KEY (`resource_template_property_id`) REFERENCES `resource_template_property` (`id`) ON DELETE CASCADE;

--
-- Contraintes pour la table `site`
--
ALTER TABLE `site`
  ADD CONSTRAINT `FK_694309E4571EDDA` FOREIGN KEY (`homepage_id`) REFERENCES `site_page` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `FK_694309E47E3C61F9` FOREIGN KEY (`owner_id`) REFERENCES `user` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `FK_694309E4FDFF2E92` FOREIGN KEY (`thumbnail_id`) REFERENCES `asset` (`id`) ON DELETE SET NULL;

--
-- Contraintes pour la table `site_block_attachment`
--
ALTER TABLE `site_block_attachment`
  ADD CONSTRAINT `FK_236473FE126F525E` FOREIGN KEY (`item_id`) REFERENCES `item` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `FK_236473FEE9ED820C` FOREIGN KEY (`block_id`) REFERENCES `site_page_block` (`id`),
  ADD CONSTRAINT `FK_236473FEEA9FDD75` FOREIGN KEY (`media_id`) REFERENCES `media` (`id`) ON DELETE SET NULL;

--
-- Contraintes pour la table `site_item_set`
--
ALTER TABLE `site_item_set`
  ADD CONSTRAINT `FK_D4CE134960278D7` FOREIGN KEY (`item_set_id`) REFERENCES `item_set` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `FK_D4CE134F6BD1646` FOREIGN KEY (`site_id`) REFERENCES `site` (`id`) ON DELETE CASCADE;

--
-- Contraintes pour la table `site_page`
--
ALTER TABLE `site_page`
  ADD CONSTRAINT `FK_2F900BD9F6BD1646` FOREIGN KEY (`site_id`) REFERENCES `site` (`id`);

--
-- Contraintes pour la table `site_page_block`
--
ALTER TABLE `site_page_block`
  ADD CONSTRAINT `FK_C593E731C4663E4` FOREIGN KEY (`page_id`) REFERENCES `site_page` (`id`);

--
-- Contraintes pour la table `site_permission`
--
ALTER TABLE `site_permission`
  ADD CONSTRAINT `FK_C0401D6FA76ED395` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `FK_C0401D6FF6BD1646` FOREIGN KEY (`site_id`) REFERENCES `site` (`id`) ON DELETE CASCADE;

--
-- Contraintes pour la table `site_setting`
--
ALTER TABLE `site_setting`
  ADD CONSTRAINT `FK_64D05A53F6BD1646` FOREIGN KEY (`site_id`) REFERENCES `site` (`id`) ON DELETE CASCADE;

--
-- Contraintes pour la table `user_setting`
--
ALTER TABLE `user_setting`
  ADD CONSTRAINT `FK_C779A692A76ED395` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE;

--
-- Contraintes pour la table `value`
--
ALTER TABLE `value`
  ADD CONSTRAINT `FK_1D7758344BC72506` FOREIGN KEY (`value_resource_id`) REFERENCES `resource` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `FK_1D775834549213EC` FOREIGN KEY (`property_id`) REFERENCES `property` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `FK_1D77583489329D25` FOREIGN KEY (`resource_id`) REFERENCES `resource` (`id`),
  ADD CONSTRAINT `FK_1D7758349B66727E` FOREIGN KEY (`value_annotation_id`) REFERENCES `value_annotation` (`id`) ON DELETE SET NULL;

--
-- Contraintes pour la table `value_annotation`
--
ALTER TABLE `value_annotation`
  ADD CONSTRAINT `FK_C03BA4EBF396750` FOREIGN KEY (`id`) REFERENCES `resource` (`id`) ON DELETE CASCADE;

--
-- Contraintes pour la table `vocabulary`
--
ALTER TABLE `vocabulary`
  ADD CONSTRAINT `FK_9099C97B7E3C61F9` FOREIGN KEY (`owner_id`) REFERENCES `user` (`id`) ON DELETE SET NULL;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
