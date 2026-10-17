-- phpMyAdmin SQL Dump
-- version 5.2.3deb1
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Oct 17, 2026 at 02:21 AM
-- Server version: 8.4.11-0ubuntu0.26.04.1
-- PHP Version: 8.5.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `blog_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `categories`
--

CREATE TABLE `categories` (
  `category_id` int NOT NULL,
  `name` varchar(300) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `categories`
--

INSERT INTO `categories` (`category_id`, `name`) VALUES
(1, 'Github'),
(2, 'Programming'),
(4, 'Business'),
(5, 'Entrepreneur');

-- --------------------------------------------------------

--
-- Table structure for table `comment`
--

CREATE TABLE `comment` (
  `comment_id` int NOT NULL,
  `user_id` int NOT NULL,
  `blog_id` int NOT NULL,
  `comment` text NOT NULL,
  `is_visible` tinyint(1) DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `comment`
--

INSERT INTO `comment` (`comment_id`, `user_id`, `blog_id`, `comment`, `is_visible`, `created_at`) VALUES
(1, 1, 3, 'Great lesson thx.', 1, '2026-10-16 23:03:39'),
(2, 1, 2, 'Thx for this blog', 1, '2026-10-16 23:04:34'),
(3, 1, 1, 'Thx this is amazing', 1, '2026-10-16 23:05:04'),
(4, 1, 9, 'thx', 1, '2026-10-17 00:12:04'),
(5, 6, 1, 'Thx for it', 1, '2026-10-17 00:16:39');

-- --------------------------------------------------------

--
-- Table structure for table `contact_message`
--

CREATE TABLE `contact_message` (
  `message_id` int NOT NULL,
  `sender_name` varchar(200) NOT NULL,
  `sender_email` varchar(250) NOT NULL,
  `subject` varchar(250) NOT NULL,
  `message` text NOT NULL,
  `submitted_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `is_resolved` tinyint(1) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `contact_message`
--

INSERT INTO `contact_message` (`message_id`, `sender_name`, `sender_email`, `subject`, `message`, `submitted_at`, `is_resolved`) VALUES
(1, 'Log Tresor', 'ingeritresor27@gmail.com', 'Request support', 'Help to know how can i improve the visibility of my posts such that i cam get more reads, comment, likes and reaction.', '2026-10-16 23:00:32', 0),
(2, 'Niyonkuru Bonhuer', 'niyonkuru@gmail.com', 'Requesting for Information', 'I want to know more about this website and how to use it', '2026-10-17 00:18:16', 0);

-- --------------------------------------------------------

--
-- Table structure for table `likes`
--

CREATE TABLE `likes` (
  `user_id` int NOT NULL,
  `blog_id` int NOT NULL,
  `like_date` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `likes`
--

INSERT INTO `likes` (`user_id`, `blog_id`, `like_date`) VALUES
(1, 1, NULL),
(1, 2, NULL),
(1, 3, NULL),
(1, 9, NULL),
(4, 1, NULL),
(6, 1, NULL),
(6, 9, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `login`
--

CREATE TABLE `login` (
  `login_id` int NOT NULL,
  `user_id` int NOT NULL,
  `login_time` datetime DEFAULT CURRENT_TIMESTAMP,
  `ip_address` varchar(45) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `login`
--

INSERT INTO `login` (`login_id`, `user_id`, `login_time`, `ip_address`) VALUES
(1, 2, '2026-10-17 00:12:53', '127.0.0.1'),
(2, 2, '2026-10-17 00:20:05', '127.0.0.1'),
(3, 2, '2026-10-17 00:26:30', '127.0.0.1'),
(4, 4, '2026-10-17 00:30:21', '127.0.0.1'),
(5, 2, '2026-10-17 00:36:41', '127.0.0.1'),
(6, 1, '2026-10-17 01:02:48', '127.0.0.1'),
(7, 4, '2026-10-17 01:06:47', '127.0.0.1'),
(8, 1, '2026-10-17 01:10:38', '127.0.0.1'),
(9, 2, '2026-10-17 01:29:43', '127.0.0.1'),
(10, 4, '2026-10-17 01:34:47', '127.0.0.1'),
(11, 2, '2026-10-17 01:35:14', '127.0.0.1'),
(12, 5, '2026-10-17 01:48:10', '127.0.0.1'),
(13, 2, '2026-10-17 02:03:23', '127.0.0.1'),
(14, 1, '2026-10-17 02:08:28', '127.0.0.1');

-- --------------------------------------------------------

--
-- Table structure for table `notification`
--

CREATE TABLE `notification` (
  `notification_id` int NOT NULL,
  `user_id` int NOT NULL,
  `is_read` tinyint(1) DEFAULT '0',
  `title` text,
  `link` varchar(300) DEFAULT NULL,
  `content` text,
  `actor_id` int DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `notification`
--

INSERT INTO `notification` (`notification_id`, `user_id`, `is_read`, `title`, `link`, `content`, `actor_id`, `created_at`) VALUES
(1, 2, 1, 'New login', '/java-blog/admin/logins', 'Log Tresor signed in.', 4, '2026-10-16 23:14:12'),
(2, 2, 1, 'Story published', '/java-blog/admin/posts', 'Log Tresor published “Supercharge Your Repository: A Complete Guide to GitHub Wikis”.', 4, '2026-10-16 23:14:12'),
(3, 2, 1, 'Post liked', '/java-blog/admin/posts', 'Log Tresor liked “Supercharge Your Repository: A Complete Guide to GitHub Wikis”.', 4, '2026-10-16 23:14:12'),
(4, 2, 1, 'Story published', '/java-blog/admin/posts', 'Log Tresor published “Write Once, Read Anywhere: The Ultimate Guide to Mastering Markdown”.', 4, '2026-10-16 23:14:12'),
(5, 2, 1, 'Story published', '/java-blog/admin/posts', 'Log Tresor published “Automate Everything: Building Powerful CI/CD Pipelines with GitHub Actions”.', 4, '2026-10-16 23:14:12'),
(6, 2, 1, 'New contact message', '/java-blog/admin?tab=messages', 'Request support', 4, '2026-10-16 23:14:12'),
(7, 2, 1, 'New login', '/java-blog/admin/logins', 'Ishimwe Promesse signed in.', 1, '2026-10-16 23:14:12'),
(8, 4, 0, 'New comment', '/java-blog/post?slug=automate-everything-building-powerful-ci-cd-pipelines-with-github-actions#comments', 'Ishimwe Promesse commented on “Automate Everything: Building Powerful CI/CD Pipelines with GitHub Actions”.', 1, '2026-10-16 23:14:12'),
(9, 2, 1, 'New blog comment', '/java-blog/admin/comments', 'Ishimwe Promesse commented on “Automate Everything: Building Powerful CI/CD Pipelines with GitHub Actions”.', 1, '2026-10-16 23:14:12'),
(10, 4, 0, 'Your story was liked', '/java-blog/post?slug=automate-everything-building-powerful-ci-cd-pipelines-with-github-actions', 'Ishimwe Promesse liked “Automate Everything: Building Powerful CI/CD Pipelines with GitHub Actions”.', 1, '2026-10-16 23:14:12'),
(11, 2, 1, 'Post liked', '/java-blog/admin/posts', 'Ishimwe Promesse liked “Automate Everything: Building Powerful CI/CD Pipelines with GitHub Actions”.', 1, '2026-10-16 23:14:12'),
(12, 4, 0, 'Your story was liked', '/java-blog/post?slug=write-once-read-anywhere-the-ultimate-guide-to-mastering-markdown', 'Ishimwe Promesse liked “Write Once, Read Anywhere: The Ultimate Guide to Mastering Markdown”.', 1, '2026-10-16 23:14:12'),
(13, 2, 1, 'Post liked', '/java-blog/admin/posts', 'Ishimwe Promesse liked “Write Once, Read Anywhere: The Ultimate Guide to Mastering Markdown”.', 1, '2026-10-16 23:14:12'),
(14, 4, 0, 'New comment', '/java-blog/post?slug=write-once-read-anywhere-the-ultimate-guide-to-mastering-markdown#comments', 'Ishimwe Promesse commented on “Write Once, Read Anywhere: The Ultimate Guide to Mastering Markdown”.', 1, '2026-10-16 23:14:12'),
(15, 2, 1, 'New blog comment', '/java-blog/admin/comments', 'Ishimwe Promesse commented on “Write Once, Read Anywhere: The Ultimate Guide to Mastering Markdown”.', 1, '2026-10-16 23:14:12'),
(16, 4, 0, 'Your story was liked', '/java-blog/post?slug=supercharge-your-repository-a-complete-guide-to-github-wikis', 'Ishimwe Promesse liked “Supercharge Your Repository: A Complete Guide to GitHub Wikis”.', 1, '2026-10-16 23:14:12'),
(17, 2, 1, 'Post liked', '/java-blog/admin/posts', 'Ishimwe Promesse liked “Supercharge Your Repository: A Complete Guide to GitHub Wikis”.', 1, '2026-10-16 23:14:12'),
(18, 4, 0, 'New comment', '/java-blog/post?slug=supercharge-your-repository-a-complete-guide-to-github-wikis#comments', 'Ishimwe Promesse commented on “Supercharge Your Repository: A Complete Guide to GitHub Wikis”.', 1, '2026-10-16 23:14:12'),
(19, 2, 1, 'New blog comment', '/java-blog/admin/comments', 'Ishimwe Promesse commented on “Supercharge Your Repository: A Complete Guide to GitHub Wikis”.', 1, '2026-10-16 23:14:12'),
(20, 4, 0, 'New subscriber', '/java-blog/editor', 'Ishimwe Promesse subscribed to your stories.', 1, '2026-10-16 23:14:12'),
(21, 2, 1, 'New login', '/java-blog/admin/logins', 'Log Tresor signed in.', 4, '2026-10-16 23:14:12'),
(22, 2, 1, 'New login', '/java-blog/admin/logins', 'Ishimwe Promesse signed in.', 1, '2026-10-16 23:14:12'),
(23, 2, 0, 'New login', '/java-blog/admin/logins', 'Log Tresor signed in.', 4, '2026-10-16 23:34:47'),
(24, 2, 0, 'New account', '/java-blog/admin/users', 'Gasore Kenny created an account.', 5, '2026-10-16 23:42:11'),
(25, 2, 0, 'New login', '/java-blog/admin/logins', 'Gasore Kenny signed in.', 5, '2026-10-16 23:48:10'),
(26, 2, 0, 'Story published', '/java-blog/admin/posts', 'Gasore Kenny published “Back to Basics: Why Clean HTML is the Foundation of Great Web Development”.', 5, '2026-10-16 23:51:27'),
(27, 2, 0, 'Story published', '/java-blog/admin/posts', 'Gasore Kenny published “The Language of the Web: Mastering Modern JavaScript Fundamentals”.', 5, '2026-10-16 23:54:09'),
(28, 2, 0, 'Story published', '/java-blog/admin/posts', 'Gasore Kenny published “Beyond the Pixel: The Art and Science of Modern Frontend Development”.', 5, '2026-10-16 23:56:07'),
(29, 2, 0, 'Story published', '/java-blog/admin/posts', 'Gasore Kenny published “The Invisible Engine: Mastering Modern Backend Development”.', 5, '2026-10-16 23:58:21'),
(30, 2, 0, 'New login', '/java-blog/admin/logins', 'Ishimwe Promesse signed in.', 1, '2026-10-17 00:08:28'),
(31, 4, 0, 'Your story was liked', '/java-blog/post?slug=supercharge-your-repository-a-complete-guide-to-github-wikis', 'Ishimwe Promesse liked “Supercharge Your Repository: A Complete Guide to GitHub Wikis”.', 1, '2026-10-17 00:11:38'),
(32, 2, 0, 'Post liked', '/java-blog/admin/posts', 'Ishimwe Promesse liked “Supercharge Your Repository: A Complete Guide to GitHub Wikis”.', 1, '2026-10-17 00:11:38'),
(33, 5, 0, 'Your story was liked', '/java-blog/post?slug=the-invisible-engine-mastering-modern-backend-development', 'Ishimwe Promesse liked “The Invisible Engine: Mastering Modern Backend Development”.', 1, '2026-10-17 00:11:56'),
(34, 2, 0, 'Post liked', '/java-blog/admin/posts', 'Ishimwe Promesse liked “The Invisible Engine: Mastering Modern Backend Development”.', 1, '2026-10-17 00:11:56'),
(35, 5, 0, 'New subscriber', '/java-blog/editor', 'Ishimwe Promesse subscribed to your stories.', 1, '2026-10-17 00:11:59'),
(36, 5, 0, 'New comment', '/java-blog/post?slug=the-invisible-engine-mastering-modern-backend-development#comments', 'Ishimwe Promesse commented on “The Invisible Engine: Mastering Modern Backend Development”.', 1, '2026-10-17 00:12:04'),
(37, 2, 0, 'New blog comment', '/java-blog/admin/comments', 'Ishimwe Promesse commented on “The Invisible Engine: Mastering Modern Backend Development”.', 1, '2026-10-17 00:12:04'),
(38, 2, 0, 'New account', '/java-blog/admin/users', 'Niyonkuru Bonhuer created an account.', 6, '2026-10-17 00:15:21'),
(39, 5, 0, 'New subscriber', '/java-blog/editor', 'Niyonkuru Bonhuer subscribed to your stories.', 6, '2026-10-17 00:15:46'),
(40, 5, 0, 'Your story was liked', '/java-blog/post?slug=the-invisible-engine-mastering-modern-backend-development', 'Niyonkuru Bonhuer liked “The Invisible Engine: Mastering Modern Backend Development”.', 6, '2026-10-17 00:15:49'),
(41, 2, 0, 'Post liked', '/java-blog/admin/posts', 'Niyonkuru Bonhuer liked “The Invisible Engine: Mastering Modern Backend Development”.', 6, '2026-10-17 00:15:49'),
(42, 4, 0, 'Your story was liked', '/java-blog/post?slug=supercharge-your-repository-a-complete-guide-to-github-wikis', 'Niyonkuru Bonhuer liked “Supercharge Your Repository: A Complete Guide to GitHub Wikis”.', 6, '2026-10-17 00:16:24'),
(43, 2, 0, 'Post liked', '/java-blog/admin/posts', 'Niyonkuru Bonhuer liked “Supercharge Your Repository: A Complete Guide to GitHub Wikis”.', 6, '2026-10-17 00:16:24'),
(44, 4, 0, 'New subscriber', '/java-blog/editor', 'Niyonkuru Bonhuer subscribed to your stories.', 6, '2026-10-17 00:16:28'),
(45, 4, 0, 'New comment', '/java-blog/post?slug=supercharge-your-repository-a-complete-guide-to-github-wikis#comments', 'Niyonkuru Bonhuer commented on “Supercharge Your Repository: A Complete Guide to GitHub Wikis”.', 6, '2026-10-17 00:16:39'),
(46, 2, 0, 'New blog comment', '/java-blog/admin/comments', 'Niyonkuru Bonhuer commented on “Supercharge Your Repository: A Complete Guide to GitHub Wikis”.', 6, '2026-10-17 00:16:39'),
(47, 2, 0, 'New contact message', '/java-blog/admin?tab=messages', 'Requesting for Information', 6, '2026-10-17 00:18:16');

-- --------------------------------------------------------

--
-- Table structure for table `post`
--

CREATE TABLE `post` (
  `blog_id` int NOT NULL,
  `author_id` int DEFAULT NULL,
  `category_id` int DEFAULT NULL,
  `title` text NOT NULL,
  `slug` varchar(300) NOT NULL,
  `blog_description` text NOT NULL,
  `body` text NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `is_read` varchar(100) DEFAULT NULL,
  `views` int DEFAULT '0',
  `likes` int DEFAULT '0',
  `comments` int DEFAULT '0',
  `is_visible` tinyint(1) DEFAULT '1',
  `blog_status` varchar(20) DEFAULT NULL,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ;

--
-- Dumping data for table `post`
--

INSERT INTO `post` (`blog_id`, `author_id`, `category_id`, `title`, `slug`, `blog_description`, `body`, `created_at`, `is_read`, `views`, `likes`, `comments`, `is_visible`, `blog_status`, `updated_at`) VALUES
(1, 4, 1, 'Supercharge Your Repository: A Complete Guide to GitHub Wikis', 'supercharge-your-repository-a-complete-guide-to-github-wikis', 'When building software, writing code is only half the battle. Documenting your project effectively is what separates a frustrating codebase from an open-source masterpiece or a seamless internal team project.', 'When building software, writing code is only half the battle. Documenting your project effectively is what separates a frustrating codebase from an open-source masterpiece or a seamless internal team project.\r\n\r\nWhile a README.md file in your root directory is great for a quick introduction, larger projects require a dedicated space for deep dives, architecture decisions, API specs, and onboarding guides. Enter GitHub Wikis—a built-in, frictionless documentation powerhouse that lives right inside your repository.\r\n\r\nIn this guide, we will explore why you should use GitHub Wikis, how to set them up, and best practices to keep your documentation clean, organized, and collaborative.\r\n\r\nWhy Use GitHub Wikis?\r\nEvery GitHub repository comes equipped with a Wiki tab (if enabled). Here is why it is worth utilizing:\r\n\r\nZero Infrastructure Required: You don’t need to set up a separate Notion workspace, Confluence, or static site generator (like Docusaurus or GitBook). It is already there, tied directly to your code.\r\n\r\nPowered by Git: Behind the scenes, every GitHub Wiki is its own Git repository. This means you can clone it locally, write documentation in your favorite text editor, and push changes just like code.\r\n\r\nMarkdown & AsciiDoc Support: You can write your pages using familiar Markdown syntax, complete with tables, code blocks, task lists, and math equations.\r\n\r\nFine-Grained Access Control: Anyone with write access to your repository can update the wiki, making it easy for your development team to keep documentation in sync with new features.\r\n\r\nStep-by-Step: Setting Up Your First Wiki\r\nSetting up a wiki takes less than a minute. Follow these simple steps:\r\n\r\nNavigate to your Repository: Go to your GitHub repository in your web browser.\r\n\r\nEnable the Wiki:\r\n\r\nIf you don\'t see the Wiki tab at the top of your repository, go to Settings -> General.\r\n\r\nScroll down to the Features section and check the box for Wikis.\r\n\r\nCreate the Home Page: Click on the Wiki tab and click Create the first page. This will automatically generate your landing page, known as Home.md.\r\n\r\nDraft and Publish: Write your welcome message or documentation overview, and click Save page.\r\n\r\nAdvanced Tip: Editing Locally via Git\r\nWhile the web editor is fantastic for quick edits, writing extensive documentation locally is often faster. Did you know you can clone your wiki to your machine?\r\n\r\nOn your repository\'s Wiki page, look at the right-hand sidebar for the Clone this wiki URL.\r\n\r\nOpen your terminal and run:\r\n\r\nBash\r\ngit clone https://github.com/your-username/your-repo.wiki.git\r\nOpen the folder in your favorite editor (like VS Code), write your Markdown files, and commit/push your changes just like regular code!\r\n\r\nBest Practices for a Great Wiki\r\nA disorganized wiki can quickly become a graveyard of outdated information. Keep these tips in mind to maintain a pristine documentation hub:\r\n\r\nDesign a Clear Sidebar (_Sidebar): GitHub Wikis allow you to create a custom sidebar by adding a page named _Sidebar. Use this to list your core documentation sections so users never feel lost.\r\n\r\nKeep it Synchronized with Code: Outdated documentation is worse than no documentation at all. Make updating the wiki part of your Pull Request (PR) workflow when introducing major features.\r\n\r\nUse Visuals and Code Blocks: Break up heavy walls of text with architecture diagrams, screenshots, and well-formatted code snippets.\r\n\r\nDefine a Style Guide: If multiple people are contributing, agree on naming conventions (e.g., using hyphens for file names) and formatting standards.\r\n\r\nConclusion\r\nGitHub Wikis are an underutilized superpower for developers and teams. By bringing your documentation directly into your version control ecosystem, you remove friction and ensure that your project is easy to understand, adopt, and contribute to.\r\n\r\nHave you used GitHub Wikis for your projects, or do you prefer external documentation tools? Let me know your thoughts in the comments below!\r\n\r\nWhat would you like to customize or add to this blog post? (e.g., adding specific code examples, adjusting the tone, or tailoring it for a specific audience?)', '2026-10-16 22:40:33', NULL, 13, 3, 2, 1, 'live', '2026-10-17 00:16:39'),
(2, 4, 1, 'Write Once, Read Anywhere: The Ultimate Guide to Mastering Markdown', 'write-once-read-anywhere-the-ultimate-guide-to-mastering-markdown', 'Supercharge Your Repository: A Complete Guide to GitHub Wikis. Tired of scattered notes and outdated docs? Discover how to turn GitHub Wikis into a frictionless, version-controlled documentation hub for your projects—complete with local Git editing and best practices for teams.', 'If you spend any time on GitHub, writing documentation, or collaborating in modern tech tools like Notion, Obsidian, or Discord, you’ve likely crossed paths with Markdown.Created in 2004 by John Gruber and Aaron Swartz, Markdown was designed with a single, elegant goal: to be readable as-is, without looking like it\'s been tagged with code.Whether you are a seasoned software engineer or just starting out, mastering Markdown is one of the highest-leverage skills you can acquire. Let’s break down why it’s a developer\'s best friend and how you can level up your syntax game.Why Markdown is EverywhereBefore Markdown, formatting text meant messy HTML tags (<h1>, <strong>, <br>) or bloated word processors. Markdown changed the game by offering:Human Readability: Even raw Markdown files are clean and easy to read in a plain text editor.Platform Agnostic: Your notes will render beautifully across GitHub, GitLab, static site generators, and note-taking apps.Speed: No reaching for the mouse to highlight and click formatting buttons. Your hands stay right on the keyboard.The Cheat Sheet: Core Markdown SyntaxYou don’t need to memorize a massive manual to write great Markdown. Here are the core elements you’ll use 90% of the time:1. HeadingsUse hash symbols to structure your document hierarchy:Markdown# H1 - Main Page Title\r\n## H2 - Section Header\r\n### H3 - Subsection Header\r\n2. EmphasisMake text stand out or indicate code:Markdown*Italic* or _Italic_\r\n**Bold** or __Bold__\r\n`Inline code` for variables or commands\r\n3. ListsOrganize your thoughts effortlessly:Unordered Lists: Use asterisks *, hyphens -, or plus signs +.Ordered Lists: Use numbers followed by periods (1., 2.).Task Lists: Perfect for READMEs and issue trackers:Markdown- [x] Complete the core feature\r\n- [ ] Write unit tests\r\n- [ ] Deploy to production\r\n4. Links and ImagesEmbed media without breaking a sweat:Markdown[Visit GitHub](https://github.com)\r\n![Alt text for image](path/to/image.png)\r\n5. Blockquotes & Code BlocksHighlight important quotes or share multi-line code snippets with syntax highlighting:Markdown> Note: Always backup your database before running migrations.\r\nPython# Python syntax highlighting example\r\ndef greet(name):\r\n    return f\"Hello, {name}!\"\r\nAdvanced Markdown Tricks You Should KnowOnce you’ve mastered the basics, these advanced tricks will make your documentation look professional:Tables: Structure comparative data using pipes (|) and hyphens (---):FeatureFree TierPro TierStorage1 GB50 GBSupportCommunityPriorityFootnotes: Great for adding side notes or citations without cluttering your main text[^1].MarkdownHere is a statement that needs a citation[^1].\r\n\r\n[^1]: This is the citation text at the bottom of the page.\r\nCollapsible Sections: Hide long logs or details using HTML tags supported by GitHub:Markdown<details>\r\n<summary>Click to expand error logs</summary>\r\n\r\n[Error 504: Gateway Timeout]\r\n</details>\r\nConclusionMarkdown is the lingua franca of the modern web and software development. By keeping things lightweight, human-readable, and universally compatible, it lets you focus on what you are writing rather than how it looks.What is your favorite Markdown feature or trick? Drop it in the comments below!Would you like a short description for this Markdown blog post as well, or any further tweaks?', '2026-10-16 22:48:05', NULL, 3, 1, 1, 1, 'live', '2026-10-16 23:04:34'),
(3, 4, 1, 'Automate Everything: Building Powerful CI/CD Pipelines with GitHub Actions', 'automate-everything-building-powerful-ci-cd-pipelines-with-github-actions', 'Automate Everything: Building Powerful CI/CD Pipelines with GitHub Actions. Say goodbye to manual deployments and repetitive testing. Discover how to set up robust, automated workflows using GitHub Actions to test, build, and ship your code seamlessly with every push.', 'Writing code is creative, rewarding, and fun. Manually running tests, building production bundles, logging into servers via SSH, and pushing updates to production? Not so much.\r\n\r\nIn modern software development, automation is the key to moving fast without breaking things. Enter GitHub Actions—a built-in continuous integration and continuous deployment (CI/CD) platform that allows you to automate your entire software development lifecycle right inside your repository.\r\n\r\nIn this guide, we will break down what workflows are, how GitHub Actions powers them, and how to write your very first automated pipeline.\r\n\r\nWhat is a Workflow?\r\nIn the context of GitHub Actions, a workflow is a configurable automated process that you set up in your repository. It consists of one or more jobs that run automatically when triggered by specific events (like pushing code, opening a pull request, or even on a scheduled cron timer).\r\n\r\nHere is a quick look at the anatomy of a GitHub Actions workflow:\r\n\r\nEvent: The trigger (e.g., push to the main branch).\r\n\r\nJob: A set of steps executed on the same runner (virtual machine).\r\n\r\nStep: An individual task that can run commands (like npm test) or use pre-built actions from the GitHub Marketplace.\r\n\r\nStep-by-Step: Creating Your First Workflow\r\nGitHub workflows live as YAML files inside your repository\'s .github/workflows/ directory. Let\'s create a simple workflow that automatically runs your test suite whenever code is pushed.\r\n\r\nCreate the Directory Structure: In the root of your project, create a folder named .github, and inside it, a folder named workflows.\r\n\r\nCreate the Workflow File: Create a file named ci.yml.\r\n\r\nAdd the Configuration: Paste the following configuration into your file:\r\n\r\nYAML\r\nname: CI Pipeline\r\n\r\n# Define what triggers the workflow\r\non:\r\n  push:\r\n    branches: [ \"main\" ]\r\n  pull_request:\r\n    branches: [ \"main\" ]\r\n\r\njobs:\r\n  build-and-test:\r\n    # Choose your operating system runner\r\n    runs-on: ubuntu-latest\r\n\r\n    steps:\r\n      # Step 1: Check out your repository code\r\n      - name: Checkout code\r\n        uses: actions/checkout@v4\r\n\r\n      # Step 2: Set up Node.js environment\r\n      - name: Set up Node.js\r\n        uses: actions/setup-node@v4\r\n        with:\r\n          node-version: \'20\'\r\n\r\n      # Step 3: Install dependencies\r\n      - name: Install dependencies\r\n        run: npm ci\r\n\r\n      # Step 4: Run your test suite\r\n      - name: Run tests\r\n        run: npm test\r\nCommit and Push: Save the file, commit it to your repository, and push it to GitHub. Go to the Actions tab in your repository—you will see your workflow running live!\r\n\r\nBest Practices for Robust Workflows\r\nAs your project grows, your workflows can become complex. Keep these tips in mind to maintain fast and reliable pipelines:\r\n\r\nCache Dependencies: Don\'t download node_modules or pip packages from scratch every single time. Use actions like actions/cache to speed up build times.\r\n\r\nSecure Your Secrets: Never hardcode API keys, tokens, or passwords in your workflow files. Use GitHub Repository Secrets (Settings -> Secrets and variables -> actions) and reference them securely via secrets.MY_SECRET_KEY.\r\n\r\nKeep Feedback Fast: Put your quickest checks (linters, unit tests) at the beginning of your pipeline so developers get instant feedback if something fails.\r\n\r\nMatrix Builds: If you need to test your code across multiple Node.js versions or operating systems simultaneously, use a strategy: matrix block to run them in parallel.\r\n\r\nConclusion\r\nGitHub Workflows take the friction out of release cycles. By automating testing and deployment, you protect your production code from bugs and free up hours of manual labor every week.', '2026-10-16 22:49:42', NULL, 5, 1, 1, 1, 'live', '2026-10-16 23:05:38'),
(4, 4, 1, 'Beyond git push: Mastering GitHub\'s Most Powerful Developer Features', 'beyond-git-push-mastering-github-s-most-powerful-developer-features', 'Mastering GitHub: Essential Features Every Developer Should Know. Go beyond git push. Discover the hidden gems, powerful collaboration tools, and project management features built into GitHub that will level up your developer workflow.', 'For most developers, GitHub is simply where our code lives—a cloud-based storage locker for our Git repositories. We write code locally, type git add, git commit, git push, and call it a day.\r\n\r\nBut GitHub is much more than a remote code host. It is an entire ecosystem designed for collaboration, project management, code quality assurance, and security.\r\n\r\nIf you are only using GitHub to store your code backups, you are only scratching the surface. Let’s explore some of the most powerful features GitHub offers to supercharge your daily workflow.\r\n\r\n1. GitHub Issues and Projects: Ditch Trello and Jira\r\nWhy jump to external tools when your issue tracking and project management can live right alongside your code?\r\n\r\nGitHub Issues: Beyond bug reports, issues are flexible task trackers. You can assign labels (like bug, enhancement, help wanted), assign team members, link them to specific milestones, and even track them using Markdown checkboxes.\r\n\r\nGitHub Projects: This is GitHub’s built-in kanban board and table view. You can create custom views, automate workflows (e.g., automatically move an issue to \"In Progress\" when a branch is created), and visualize your team\'s workload instantly.\r\n\r\n2. Pull Requests: The Heart of Code Review\r\nPull Requests (PRs) are where team collaboration truly shines. They give your team a dedicated sandbox to discuss changes before they merge into production.\r\n\r\nDraft PRs: When you are still working on a feature but want feedback or want to run your CI/CD tests, open a Draft PR. It prevents accidental merging while keeping transparency high.\r\n\r\nCode Review Tools: You can leave line-by-line comments, suggest exact code changes that the author can accept with a single click, and require approval reviews before a merge is permitted.\r\n\r\nProtected Branches: Set rules on your main branch so that nobody can push directly to it. Require passing test suites and at least one code review approval before any PR can be merged.\r\n\r\n3. GitHub Discussions: Community and Knowledge Sharing\r\nWhile Issues are meant for bugs and specific tasks, Discussions are built for open-ended conversations, brainstorming, and community Q&A.\r\n\r\nEnable Discussions on your repository to give your users and contributors a space to ask questions, share ideas, and announce updates without cluttering your issue tracker.\r\n\r\nYou can mark specific answers as \"Resolved,\" turning your discussion board into a searchable knowledge base over time.\r\n\r\n4. GitHub Security: Catch Vulnerabilities Early\r\nSecurity shouldn\'t be an afterthought. GitHub provides built-in tools to scan your code for vulnerabilities automatically:\r\n\r\nDependabot: Automatically monitors your dependencies (like package.json or requirements.txt) and opens pull requests to update them when a security vulnerability is discovered.\r\n\r\nSecret Scanning: If you accidentally commit an API key, AWS secret, or private token, GitHub scans public repositories (and optional private ones) and alerts you immediately—often before malicious actors can exploit it.\r\n\r\nCodeQL: GitHub’s semantic code analysis engine scans your source code for complex security flaws and bugs.\r\n\r\nConclusion\r\nGitHub is much more than a Git server; it is a complete platform for software engineering. By integrating project management, thorough code reviews, community discussions, and automated security into your daily routine, you can build better software, faster and safer.', '2026-10-16 22:51:12', NULL, 0, 0, 0, 1, 'draft', '2026-10-16 22:51:12'),
(5, 4, 1, 'Scaling Up: The Ultimate Guide to Managing GitHub Organizations', 'scaling-up-the-ultimate-guide-to-managing-github-organizations', 'Scaling Up: The Ultimate Guide to Managing GitHub Organizations. Moving from a solo developer to a growing team? Discover how to structure your GitHub Organization for security, collaboration, and scalability using teams, access controls, and repository templates.', 'When you first start coding, a personal GitHub account is all you need. Your repositories live under [github.com/your-username/repo](https://github.com/your-username/repo), and you manage everything yourself. But as your team grows, your side project turns into a startup, or your open-source project gains traction, a personal account quickly becomes a bottleneck.\r\n\r\nWho has access to what? Who owns the billing? How do you grant access to a new hire without giving them the keys to every repository?\r\n\r\nEnter GitHub Organizations. An organization is a shared account where businesses, open-source communities, and enterprise teams can collaborate across hundreds of repositories securely.\r\n\r\nIn this guide, we will break down how to set up, structure, and manage a GitHub Organization like a pro.\r\n\r\nWhy Move to a GitHub Organization?\r\nMoving your repositories from a personal account to an organization unlocks enterprise-grade management features:\r\n\r\nCentralized Ownership: Projects don\'t belong to a single individual who might leave the company or lose their password. The organization owns the assets.\r\n\r\nTeam-Based Access Control: Instead of managing permissions user-by-user, you can group developers into Teams (e.g., Frontend, Backend, DevOps) and assign permissions at the team level.\r\n\r\nSecurity and Compliance: Enforce enterprise-grade security policies, such as mandatory Two-Factor Authentication (2FA) for all members and SAML single sign-on (SSO).\r\n\r\nProfessional Brand Identity: Your repositories live under a clean URL structure like [github.com/your-company-name](https://github.com/your-company-name), boosting credibility.\r\n\r\nStep-by-Step: Setting Up Your Organization\r\nCreating and initializing your organization takes just a few minutes:\r\n\r\nCreate the Organization: Click the + icon in the top-right corner of GitHub, select New organization, and choose your plan (Free, Team, or Enterprise).\r\n\r\nFill in Profile Details: Add your company name, logo, billing email, and website link to make your organization look official.\r\n\r\nInvite Members: Go to the People tab, click Invite member, and enter their GitHub username or email address. You can assign them as a Member or an Owner.\r\n\r\nBest Practices for Organizing Your Workspace\r\nAn unorganized organization can quickly become as chaotic as a messy personal account. Keep your team productive with these structural best practices:\r\n\r\n1. Leverage Nested Teams\r\nDon\'t throw all developers into a single \"Developers\" team. Break them down logically:\r\n\r\n@your-org/frontend-team\r\n\r\n@your-org/backend-team\r\n\r\n@your-org/devops-security\r\n\r\nYou can then grant repository access based on these teams. For example, give frontend-team write access to the web app repository, but only read access to the core infrastructure repository.\r\n\r\n2. Standardize with Repository Templates\r\nInstead of letting developers spin up repositories from scratch with inconsistent folder structures or missing license files:\r\n\r\nCreate a repository and check the Template repository box in its settings.\r\n\r\nWhen team members create a new project, they can use your template instantly, ensuring uniform setup, linting rules, and initial documentation.\r\n\r\n3. Enforce Security Policies\r\nSecurity should be non-negotiable at the organizational level:\r\n\r\nGo to your organization’s Settings -> Member privileges.\r\n\r\nCheck the box to Require two-factor authentication for everyone in the organization.\r\n\r\nRestrict repository creation so that only specific teams or Owners can create new public or private repositories, preventing sprawl.\r\n\r\nConclusion\r\nGitHub Organizations are the backbone of modern engineering collaboration. By shifting from personal accounts to structured teams, automated templates, and strict access controls, you protect your intellectual property while giving your team the freedom to build fast.', '2026-10-16 22:54:45', NULL, 0, 0, 0, 1, 'draft', '2026-10-16 22:54:45'),
(6, 5, 2, 'Back to Basics: Why Clean HTML is the Foundation of Great Web Development', 'back-to-basics-why-clean-html-is-the-foundation-of-great-web-development', 'Back to Basics: Why HTML Still Matters in Modern Web Development. With endless JavaScript frameworks and UI libraries taking over, it\'s easy to forget the foundation of the web. Discover why writing clean, semantic HTML is more critical than ever for accessibility, SEO, and maintainability.', 'When people think of building websites today, their minds immediately jump to complex JavaScript frameworks like React, Next.js, or Vue, styled with Tailwind CSS or component libraries.\r\n\r\nAmidst all this tooling, it is easy to treat HTML (HyperText Markup Language) as an afterthought—something primitive you just throw together before getting to the \"real\" coding.\r\n\r\nBut HTML is the skeleton of the web. If your HTML foundation is weak, your entire application suffers in accessibility, SEO, performance, and maintainability. Let’s explore why mastering HTML is still your most powerful superpower as a web developer.\r\n\r\nThe Power of Semantic HTML\r\nWriting HTML isn\'t just about getting text and images onto a screen; it’s about meaning.\r\n\r\nFor years, developers built entire websites out of generic <div> and <span> tags, styling them with CSS to look like headers, footers, and sidebars. While this looks fine to a sighted user, it’s a nightmare for screen readers, search engine crawlers, and automated tools.\r\n\r\nSemantic HTML uses tags that describe their purpose:\r\n\r\n<header>: Represents introductory content or a navigation set.\r\n\r\nBy using the right tags, you give your web page built-in structure that browsers and assistive technologies can understand instantly.\r\n\r\nWhy Semantic HTML Matters\r\nInvesting time in writing proper HTML pays off in four massive ways:\r\n\r\n1. Built-In Accessibility (a11y)\r\nMillions of people rely on screen readers and keyboard navigation to browse the web. Semantic elements give screen readers landmarks, allowing users to jump directly from heading to heading or skip straight to the main content without listening to every navigation link on every page.\r\n\r\n2. Search Engine Optimization (SEO)\r\nSearch engines like Google use automated bots to crawl your site. When your code uses proper heading hierarchies (<h1> down to <h6>) and semantic tags, search engines can accurately index your content, boosting your rankings.\r\n\r\n3. Better Performance\r\nSemantic HTML requires less custom JavaScript and fewer hacky workarounds to achieve layout and accessibility goals. Less code means faster load times, especially for users on mobile devices or slow connections.\r\n\r\n4. Easier Maintenance\r\nHave you ever stared at a wall of nested <div> tags with classes like wrapper-inner-container-box? It’s painful to debug. Clean semantic markup makes your code self-documenting and much easier for other developers to read.\r\n\r\nBest Practices for Modern HTML\r\nKeep these golden rules in mind the next time you spin up a web project:\r\n\r\nDon\'t Skip Heading Levels: Always start with one <h1> per page (usually your main title), followed by <h2> for sections, <h3> for subsections, and so on. Don\'t skip levels just because you like the font size of a smaller heading (use CSS for sizing instead!).\r\n\r\nAlways Use Alt Text: Every <img> tag should include a descriptive alt attribute for screen readers and broken image fallbacks.\r\n\r\nForm Labels Are Mandatory: Never rely on placeholder text alone for form inputs. Always pair every <input> with an explicit <label> element.\r\n\r\nConclusion\r\nFrameworks come and go, but HTML is eternal. By treating HTML as a first-class citizen in your development process, you build faster, more accessible, and future-proof web applications.', '2026-10-16 23:51:27', NULL, 0, 0, 0, 1, 'live', '2026-10-16 23:51:27'),
(7, 5, 2, 'The Language of the Web: Mastering Modern JavaScript Fundamentals', 'the-language-of-the-web-mastering-modern-javascript-fundamentals', 'The Language of the Web: Mastering Modern JavaScript Fundamentals. From simple browser scripts to full-stack powerhouse apps, JavaScript powers the modern web. Discover the core concepts, modern features, and best practices every developer needs to write cleaner, more efficient JS.', 'If HTML is the skeleton and CSS is the skin, JavaScript (JS) is the nervous system of the web. It brings static pages to life, handles user interactions, communicates with servers, and powers entire ecosystems ranging from mobile apps to backend servers.\r\n\r\nYet, JavaScript is also famous for its quirks, rapid evolution, and the sheer fatigue of its endless framework wars. Before you jump into the latest framework, mastering core, modern JavaScript is the single best investment you can make in your engineering career.\r\n\r\nLet’s explore what makes JavaScript tick and how to write clean, modern code.\r\n\r\nWhy JavaScript Won the Web\r\nJavaScript was originally created in 1995 in just 10 days to add simple form validation to Netscape browsers. Today, it is the most widely used programming language in the world. Here is why it conquered tech:\r\n\r\nUbiquity: It runs natively in every modern web browser. Users don\'t need to install plugins or run complex environments to execute JS.\r\n\r\nFull-Stack Versatility: Thanks to Node.js and runtime environments like Deno or Bun, you can use JavaScript on both the frontend and the backend.\r\n\r\nVibrant Ecosystem: npm (Node Package Manager) hosts millions of open-source packages, meaning you rarely have to reinvent the wheel.\r\n\r\nModern JavaScript (ES6+): Features You Should Be Using\r\nJavaScript evolved significantly with the release of ES6 (ECMAScript 2015) and subsequent yearly updates. If you are still writing old-school JS, these modern features will instantly clean up your codebase:\r\n\r\n1. Arrow Functions\r\nCleaner, more concise syntax for writing functions, especially callbacks:\r\n\r\nJavaScript\r\n// Traditional Function\r\nfunction add(a, b) {\r\n    return a + b;\r\n}\r\n\r\n// Modern Arrow Function\r\nconst add = (a, b) => a + b;\r\n2. Destructuring\r\nEasily extract values from objects and arrays into distinct variables:\r\n\r\nJavaScript\r\nconst user = { name: \'Alice\', role: \'Developer\', city: \'Seattle\' };\r\n\r\n// Destructuring in action\r\nconst { name, role } = user;\r\nconsole.log(`${name} is a ${role}`); // Alice is a Developer\r\n3. Template Literals\r\nSay goodbye to messy string concatenation with plus signs. Use backticks and interpolation instead:\r\n\r\nJavaScript\r\nconst item = \'cart\';\r\nconst count = 3;\r\nconsole.log(`You have ${count} items in your ${item}.`);\r\n4. Async/Await\r\nAsynchronous programming used to mean \"callback hell.\" Modern JS makes dealing with APIs and promises clean and readable using async and await:\r\n\r\nJavaScript\r\nasync function fetchUserData(userId) {\r\n    try {\r\n        const response = await fetch(`https://api.example.com/users/${userId}`);\r\n        const data = await response.json();\r\n        return data;\r\n    } catch (error) {\r\n        console.error(\'Failed to fetch user:\', error);\r\n    }\r\n}\r\nBest Practices for Writing Clean JavaScript\r\nJavaScript is forgiving, which means it’s easy to write messy, bug-prone code. Keep these rules in mind to keep your scripts maintainable:\r\n\r\nPrefer const and let: Never use var anymore. Use const by default for variables that won\'t change, and let for variables that will be reassigned. Block scoping prevents nasty bugs.\r\n\r\nEmbrace Functional Array Methods: Master methods like .map(), .filter(), and .reduce() instead of relying on traditional for loops for data transformation.\r\n\r\nUse Strict Equality: Always use === and !== instead of loose equality (== and !=) to avoid unexpected type coercion bugs.\r\n\r\nConclusion\r\nJavaScript is a deeply expressive and powerful language. By focusing on modern syntax, clean asynchronous patterns, and fundamental principles, you can build lightning-fast web applications that scale effortlessly.', '2026-10-16 23:54:08', NULL, 0, 0, 0, 1, 'live', '2026-10-16 23:54:08'),
(8, 5, 2, 'Beyond the Pixel: The Art and Science of Modern Frontend Development', 'beyond-the-pixel-the-art-and-science-of-modern-frontend-development', 'Beyond the Pixel: The Art and Science of Modern Frontend Development. Frontend development is much more than just styling buttons—it’s where design meets logic. Discover what it takes to build fast, accessible, and stunning user interfaces in the modern web ecosystem.', 'When users visit a website or open a web app, they don\'t see your backend database architecture, your microservices, or your cloud server configurations. They see the frontend.\r\n\r\nIt is the face of your application, the layer where human interaction meets machine code. Yet, frontend development is often misunderstood as merely \"making things look pretty.\" In reality, it is a complex, high-impact discipline that requires a deep understanding of performance, psychology, accessibility, and software architecture.\r\n\r\nLet’s explore what modern frontend development looks like and why it has become such a critical pillar of software engineering.\r\n\r\nThe Evolution of the Frontend\r\nIf you built websites a decade ago, frontend development mostly meant writing HTML, styling it with CSS, and dropping in a bit of jQuery to make things fade in and out.\r\n\r\nToday’s frontend landscape looks entirely different. Driven by user expectations for lightning-fast, highly interactive applications (think Gmail, Figma, or Spotify running right in the browser), frontend engineering has evolved into full-scale application development:\r\n\r\nComponent-Driven Architecture: Instead of massive, monolithic HTML pages, we build modular, reusable components using frameworks like React, Vue, Svelte, or Solid.\r\n\r\nClient-Side State Management: Applications now manage complex streams of user data, caching, and real-time updates directly in the browser.\r\n\r\nAdvanced Tooling: Lightning-fast build tools like Vite, bundlers, and automated linters ensure our code is optimized before it ever reaches production.\r\n\r\nThe Three Pillars of Exceptional Frontend Engineering\r\nWriting code that renders on a screen is easy. Writing frontend code that scales, delights users, and remains maintainable requires focusing on three core pillars:\r\n\r\n1. Performance (Speed Matters)\r\nUsers are notoriously impatient. A delay of even a single second in page load time can drastically drop conversion rates. Modern frontend developers must obsess over bundle sizes, lazy loading, optimized images, and Core Web Vitals to ensure buttery-smooth 60fps animations and instant interactivity.\r\n\r\n2. Accessibility (The Web is for Everyone)\r\nA great frontend is inclusive. Semantic HTML, proper keyboard navigation, high contrast ratios, and screen-reader compatibility aren\'t \"nice-to-have\" features—they are fundamental requirements for building ethical, professional software that everyone can use.\r\n\r\n3. Responsiveness and Adaptability\r\nYour users will access your app on everything from a massive 4K ultrawide monitor to a budget smartphone on a slow 4G connection. Frontend development requires fluid layouts, CSS Grid, Flexbox, and media queries to ensure a flawless experience across every conceivable device.\r\n\r\nBest Practices for Cleaner Frontend Code\r\nKeep these guidelines in mind to elevate your UI codebase:\r\n\r\nDesign Systems Are Your Best Friend: Use tools like Tailwind CSS or component libraries to maintain visual consistency. Don\'t reinvent the wheel for every button or card.\r\n\r\nKeep Components Small and Focused: If a single component is handling data fetching, complex state logic, form validation, and rendering, it’s time to break it down.\r\n\r\nTest the User Experience: Write end-to-end (E2E) tests with tools like Playwright or Cypress to simulate real user actions and catch breaking UI bugs before your users do.\r\n\r\nConclusion\r\nFrontend development is where creativity and technical rigor collide. By mastering performance, accessibility, and modern component architecture, you transform raw code into an intuitive digital experience.', '2026-10-16 23:56:07', NULL, 0, 0, 0, 1, 'live', '2026-10-16 23:56:07'),
(9, 5, 2, 'The Invisible Engine: Mastering Modern Backend Development', 'the-invisible-engine-mastering-modern-backend-development', 'The Invisible Engine: Mastering Modern Backend Development. While the frontend gets all the visual credit, the backend keeps the digital world spinning. Discover what goes into building secure, scalable, and high-performance server-side systems.', 'When a user clicks \"Buy Now\" on an e-commerce site, uploads a profile picture, or sends a direct message, they experience the sleek, responsive interface of the frontend. But what happens behind the scenes?\r\n\r\nHow does data instantly save to a database, verify payment details through a third-party gateway, and push a notification to another user\'s phone in milliseconds?\r\n\r\nEnter the backend.\r\n\r\nOften hidden from plain sight, the backend is the invisible engine of the web. It handles business logic, database management, security, and communication between systems. Let’s dive into what makes backend development a fascinating, high-stakes discipline.\r\n\r\nWhat Does the Backend Actually Do?\r\nIf the frontend is the actor on stage, the backend is the entire production crew, director, and stage machinery working behind the curtains. A robust backend architecture typically consists of three core layers:\r\n\r\nThe Server & Application Logic: The environment where your code runs (using languages like Node.js, Go, Python, Rust, or Java) to process incoming requests, execute business rules, and determine what data to send back.\r\n\r\nThe Database: Where data is securely stored, queried, and updated (ranging from relational databases like PostgreSQL to NoSQL solutions like MongoDB and Redis caching layers).\r\n\r\nAPIs (Application Programming Interfaces): The bridge that allows the frontend application and external services to talk to the backend securely using protocols like REST, GraphQL, or gRPC.\r\n\r\nCore Pillars of Exceptional Backend Engineering\r\nWriting code that returns a simple \"Hello World\" is easy. Designing a backend system that handles millions of requests without crashing requires mastering four crucial pillars:\r\n\r\n1. Security and Authentication\r\nThe backend is the ultimate gatekeeper of user data. Backend engineers must implement robust authentication (like JWTs or OAuth), handle password hashing securely, protect against common vulnerabilities (like SQL injection and Cross-Site Scripting), and ensure sensitive data is encrypted both in transit and at rest.\r\n\r\n2. Scalability and Performance\r\nWhat happens when your app goes viral and traffic spikes by 1,000% overnight? A well-architected backend scales gracefully. This involves optimizing database queries, implementing caching layers (like Redis), utilizing load balancers, and designing asynchronous job queues for heavy tasks.\r\n\r\n3. Reliability and Fault Tolerance\r\nFailures happen—servers crash, third-party APIs go down, and networks drop. A resilient backend anticipates failure gracefully by implementing proper error handling, automatic retries, circuit breakers, and comprehensive logging so bugs can be diagnosed instantly.\r\n\r\n4. Maintainable Architecture\r\nWhether you are building a modular monolith or a distributed microservices ecosystem, keeping your codebase clean, well-tested, and easy to refactor ensures your engineering team can ship new features without breaking existing functionality.\r\n\r\nBest Practices for Building Modern Backends\r\nKeep these golden rules in mind when designing your next server-side application:\r\n\r\nNever Trust Client Input: Always validate and sanitize data on the backend. Never assume the frontend has caught every invalid entry or malicious payload.\r\n\r\nSecure Your Secrets: Store database credentials, API keys, and private tokens safely in environment variables. Never hardcode secrets directly into your codebase.\r\n\r\nDesign RESTful or Typed APIs: Keep your API endpoints predictable, use proper HTTP status codes (200 OK, 401 Unauthorized, 404 Not Found), and document your endpoints clearly.\r\n\r\nConclusion\r\nBackend development is where computer science fundamentals—data structures, algorithms, network protocols, and database design—truly shine. By focusing on security, scalability, and clean architecture, you build systems that people and businesses can rely on 24/7.', '2026-10-16 23:58:21', NULL, 7, 2, 1, 1, 'live', '2026-10-17 00:15:49'),
(10, 5, 2, 'Beyond WordPress: Why Modern PHP is Making a Massive Comeback', 'beyond-wordpress-why-modern-php-is-making-a-massive-comeback', 'Beyond WordPress: The Renaissance of Modern PHP. PHP used to be the punchline of web development. Today, thanks to PHP 8+, robust type systems, and powerhouse frameworks like Laravel, modern PHP is fast, elegant, and a joy to write. Discover why PHP is staging a massive comeback.', 'If you learned web development a decade ago, you probably remember PHP as the language of messy \"spaghetti code\" mixed directly with HTML, insecure database queries, and a reputation as a clunky tool used only to power WordPress sites.\r\n\r\nFor a long time, the tech community loved to hate PHP.\r\n\r\nBut if you haven\'t looked at PHP in recent years, you are missing out on one of the most impressive renaissances in software engineering. Thanks to aggressive performance optimizations, strict typing, and world-class frameworks, modern PHP is lightning-fast, highly secure, and a powerhouse for building modern web applications.\r\n\r\nLet’s explore how PHP evolved and why it is better than ever.\r\n\r\nThe PHP 8 Revolution\r\nThe turning point for PHP began with PHP 7 and hit overdrive with PHP 8 and later versions. These updates introduced massive performance upgrades (including a Just-In-Time compiler) and modern language features that brought PHP on par with languages like TypeScript, C#, and Java.\r\n\r\nIf your last memory of PHP is $var = \'hello\'; with zero type safety, take a look at what modern PHP 8+ code looks like:\r\n\r\nPHP\r\n<?php\r\n\r\ndeclare(strict_types=1);\r\n\r\nnamespace App\\Services;\r\n\r\nclass UserService \r\n{\r\n    // Constructor Property Promotion (cleaner, less boilerplate)\r\n    public function __construct(\r\n        private UserRepository $users\r\n    ) {}\r\n\r\n    public function getUserStatus(int $id): string\r\n    {\r\n        $user = $this->users->find($id);\r\n\r\n        // Match expression (cleaner than switch)\r\n        return match($user?->role) {\r\n            \'admin\' => \'Administrator Access\',\r\n            \'editor\' => \'Content Editor\',\r\n            default => \'Standard User\',\r\n        };\r\n    }\r\n}\r\nKey features like union types, named arguments, attributes, constructor property promotion, and match expressions make modern PHP remarkably expressive and concise.\r\n\r\nThe Ecosystem: Frameworks That Changed the Game\r\nWhile vanilla PHP is great, the real magic of modern PHP lies in its ecosystem.\r\n\r\nLaravel: Created by Taylor Otwell, Laravel is widely considered one of the best web application frameworks in any language. It offers an expressive syntax, elegant database ORM (Eloquent), built-in authentication, queuing, and an incredible suite of first-party tools (like Breeze, Forge, and Vapor) that let developers ship products at lightning speed.\r\n\r\nSymfony: For enterprise-grade, highly scalable applications, Symfony is a gold standard, powering massive platforms with strict architectural patterns and reusable components.\r\n\r\nBest Practices for Writing Modern PHP\r\nTo get the most out of modern PHP, leave the old legacy habits behind and follow these golden rules:\r\n\r\nAlways Use Strict Types: Put declare(strict_types=1); at the top of every file to enforce strict type checking and catch bugs before your code even runs.\r\n\r\nEmbrace Composer: Never manage dependencies manually. Use Composer (PHP\'s package manager) to pull in well-tested libraries from Packagist.\r\n\r\nLeverage Modern Frameworks: Don\'t build custom routers or database connection wrappers from scratch. Use Laravel or Symfony to handle the heavy lifting securely.\r\n\r\nConclusion\r\nPHP powers roughly 75% of the web for a reason: it is practical, hyper-optimized for the web request-response cycle, and incredibly fast to build with. By shedding its messy past and embracing modern software principles, PHP has cemented its place as a top-tier backend language.', '2026-10-17 00:00:45', NULL, 0, 0, 0, 1, 'draft', '2026-10-17 00:00:45');

-- --------------------------------------------------------

--
-- Table structure for table `subscription`
--

CREATE TABLE `subscription` (
  `user_id` int NOT NULL,
  `editor_id` int NOT NULL,
  `subscription_date` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `subscription`
--

INSERT INTO `subscription` (`user_id`, `editor_id`, `subscription_date`) VALUES
(1, 4, NULL),
(1, 5, NULL),
(6, 4, NULL),
(6, 5, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `user_id` int NOT NULL,
  `user_name` varchar(200) NOT NULL,
  `email` varchar(250) NOT NULL,
  `password_h` varchar(300) NOT NULL,
  `user_role` varchar(150) NOT NULL,
  `join_date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `is_active` tinyint(1) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`user_id`, `user_name`, `email`, `password_h`, `user_role`, `join_date`, `is_active`) VALUES
(1, 'Ishimwe Promesse', 'dufitumukiza@gmail.com', 'pbkdf2$120000$ueZqkLHo1OzUgREyCVPCeg$oyQmJwYp9TWzUWaRXdpFImCy4szGu7Qw-EmIgQNv810', 'user', '2026-10-16 15:22:26', 1),
(2, 'Ingeri Tresor', 'ingeritresor@gmail.com', 'pbkdf2$120000$bf7EXltmAimnaAxwNTz7yw$O3YKS7oZuR1Vsx3UD_ywf6XhZItpqPfZNgRyvur4rv8', 'admin', '2026-10-16 21:57:57', 1),
(4, 'Log Tresor', 'ingeritresor27@gmail.com', 'pbkdf2$120000$ChMQbTcgqn9pRV-JPQNqEA$_Cxu0Cxjng0BGpZetFQsy3Cugwb5m9UTqLO9tETQn7A', 'editor', '2026-10-16 22:06:30', 1),
(5, 'Gasore Kenny', 'gasore@gmail.com', 'pbkdf2$120000$pBug3Xb6bLv4AekY4EEtXQ$COKZRRPYDj7CL0bhDawfjw6kyesIShve6uBQLEm97BY', 'editor', '2026-10-16 23:42:11', 1),
(6, 'Niyonkuru Bonhuer', 'niyonkuru@gmail.com', 'pbkdf2$120000$sZUTr5gAn0X3lwzGHbP7Kw$pTRRizPRUqquYuRvGUA5ShCjFniGmsMIFhId6IVwLU4', 'user', '2026-10-17 00:15:21', 1);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`category_id`);

--
-- Indexes for table `comment`
--
ALTER TABLE `comment`
  ADD PRIMARY KEY (`comment_id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `blog_id` (`blog_id`);

--
-- Indexes for table `contact_message`
--
ALTER TABLE `contact_message`
  ADD PRIMARY KEY (`message_id`),
  ADD KEY `idx_contact_inbox` (`is_resolved`,`submitted_at`);

--
-- Indexes for table `likes`
--
ALTER TABLE `likes`
  ADD PRIMARY KEY (`user_id`,`blog_id`),
  ADD KEY `blog_id` (`blog_id`);

--
-- Indexes for table `login`
--
ALTER TABLE `login`
  ADD PRIMARY KEY (`login_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `notification`
--
ALTER TABLE `notification`
  ADD PRIMARY KEY (`notification_id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `fk_notification_actor` (`actor_id`);

--
-- Indexes for table `post`
--
ALTER TABLE `post`
  ADD PRIMARY KEY (`blog_id`),
  ADD UNIQUE KEY `slug` (`slug`),
  ADD KEY `category_id` (`category_id`),
  ADD KEY `idx_post_author` (`author_id`);

--
-- Indexes for table `subscription`
--
ALTER TABLE `subscription`
  ADD PRIMARY KEY (`user_id`,`editor_id`),
  ADD KEY `editor_id` (`editor_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `categories`
--
ALTER TABLE `categories`
  MODIFY `category_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `comment`
--
ALTER TABLE `comment`
  MODIFY `comment_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `contact_message`
--
ALTER TABLE `contact_message`
  MODIFY `message_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `login`
--
ALTER TABLE `login`
  MODIFY `login_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `notification`
--
ALTER TABLE `notification`
  MODIFY `notification_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=48;

--
-- AUTO_INCREMENT for table `post`
--
ALTER TABLE `post`
  MODIFY `blog_id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `user_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `comment`
--
ALTER TABLE `comment`
  ADD CONSTRAINT `comment_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `comment_ibfk_2` FOREIGN KEY (`blog_id`) REFERENCES `post` (`blog_id`) ON DELETE CASCADE;

--
-- Constraints for table `likes`
--
ALTER TABLE `likes`
  ADD CONSTRAINT `likes_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `likes_ibfk_2` FOREIGN KEY (`blog_id`) REFERENCES `post` (`blog_id`) ON DELETE CASCADE;

--
-- Constraints for table `login`
--
ALTER TABLE `login`
  ADD CONSTRAINT `login_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;

--
-- Constraints for table `notification`
--
ALTER TABLE `notification`
  ADD CONSTRAINT `fk_notification_actor` FOREIGN KEY (`actor_id`) REFERENCES `users` (`user_id`) ON DELETE SET NULL,
  ADD CONSTRAINT `notification_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;

--
-- Constraints for table `post`
--
ALTER TABLE `post`
  ADD CONSTRAINT `fk_post_author` FOREIGN KEY (`author_id`) REFERENCES `users` (`user_id`) ON DELETE SET NULL,
  ADD CONSTRAINT `post_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `categories` (`category_id`) ON DELETE SET NULL;

--
-- Constraints for table `subscription`
--
ALTER TABLE `subscription`
  ADD CONSTRAINT `subscription_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `subscription_ibfk_2` FOREIGN KEY (`editor_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
