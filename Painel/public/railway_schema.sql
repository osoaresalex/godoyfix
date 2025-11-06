-- Database Schema Export
-- Generated: 2025-11-06 16:57:42

SET FOREIGN_KEY_CHECKS=0;

-- Table: accounts
DROP TABLE IF EXISTS `accounts`;
CREATE TABLE `accounts` (
  `id` char(36) NOT NULL,
  `user_id` char(36) DEFAULT NULL,
  `balance_pending` decimal(24,2) NOT NULL DEFAULT 0.00,
  `received_balance` decimal(24,2) NOT NULL DEFAULT 0.00,
  `account_payable` decimal(24,2) NOT NULL DEFAULT 0.00,
  `account_receivable` decimal(24,2) NOT NULL DEFAULT 0.00,
  `total_withdrawn` decimal(24,2) NOT NULL DEFAULT 0.00,
  `total_expense` decimal(24,2) NOT NULL DEFAULT 0.00,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: added_to_carts
DROP TABLE IF EXISTS `added_to_carts`;
CREATE TABLE `added_to_carts` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` char(36) NOT NULL,
  `service_id` char(36) NOT NULL,
  `count` int(11) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `is_guest` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: addon_settings
DROP TABLE IF EXISTS `addon_settings`;
CREATE TABLE `addon_settings` (
  `id` char(36) NOT NULL,
  `key_name` varchar(191) DEFAULT NULL,
  `live_values` longtext DEFAULT NULL,
  `test_values` longtext DEFAULT NULL,
  `settings_type` varchar(255) DEFAULT NULL,
  `mode` varchar(20) NOT NULL DEFAULT 'live',
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `additional_data` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `payment_settings_id_index` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: advertisement_attachments
DROP TABLE IF EXISTS `advertisement_attachments`;
CREATE TABLE `advertisement_attachments` (
  `id` char(36) NOT NULL,
  `advertisement_id` char(36) DEFAULT NULL,
  `file_extension_type` varchar(255) DEFAULT NULL,
  `file_name` varchar(255) DEFAULT NULL,
  `type` varchar(255) DEFAULT NULL COMMENT 'promotional_video, provider_profile_image, provider_cover_image',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: advertisement_notes
DROP TABLE IF EXISTS `advertisement_notes`;
CREATE TABLE `advertisement_notes` (
  `id` char(36) NOT NULL,
  `advertisement_id` char(36) DEFAULT NULL,
  `type` varchar(255) DEFAULT NULL COMMENT 'paused, denied',
  `note` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: advertisement_settings
DROP TABLE IF EXISTS `advertisement_settings`;
CREATE TABLE `advertisement_settings` (
  `id` char(36) NOT NULL,
  `advertisement_id` char(36) DEFAULT NULL,
  `key` varchar(255) DEFAULT NULL,
  `value` varchar(255) NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: advertisements
DROP TABLE IF EXISTS `advertisements`;
CREATE TABLE `advertisements` (
  `id` char(36) NOT NULL,
  `readable_id` varchar(255) DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `provider_id` char(36) DEFAULT NULL,
  `priority` int(11) DEFAULT NULL,
  `type` varchar(255) DEFAULT NULL COMMENT 'video_promotion, profile_promotion',
  `is_paid` tinyint(4) NOT NULL DEFAULT 0,
  `start_date` datetime NOT NULL DEFAULT '2024-05-20 20:36:19',
  `end_date` datetime NOT NULL DEFAULT '2024-05-20 20:36:19',
  `status` varchar(255) NOT NULL DEFAULT 'pending' COMMENT 'pending, approved, running, expired, denied, paused, canceled',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `is_updated` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: bank_details
DROP TABLE IF EXISTS `bank_details`;
CREATE TABLE `bank_details` (
  `id` char(36) NOT NULL,
  `provider_id` char(36) NOT NULL,
  `bank_name` varchar(191) DEFAULT NULL,
  `branch_name` varchar(191) DEFAULT NULL,
  `acc_no` varchar(191) DEFAULT NULL,
  `acc_holder_name` varchar(191) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `routing_number` varchar(191) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: banners
DROP TABLE IF EXISTS `banners`;
CREATE TABLE `banners` (
  `id` char(36) NOT NULL,
  `banner_title` varchar(191) DEFAULT NULL,
  `resource_type` varchar(191) DEFAULT NULL,
  `resource_id` char(36) DEFAULT NULL,
  `redirect_link` varchar(191) DEFAULT NULL,
  `banner_image` varchar(255) NOT NULL DEFAULT 'def.png',
  `is_active` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: bonuses
DROP TABLE IF EXISTS `bonuses`;
CREATE TABLE `bonuses` (
  `id` char(36) NOT NULL,
  `bonus_title` varchar(255) NOT NULL,
  `short_description` text NOT NULL,
  `bonus_amount_type` varchar(255) NOT NULL,
  `bonus_amount` decimal(24,3) NOT NULL DEFAULT 0.000,
  `minimum_add_amount` decimal(24,3) NOT NULL DEFAULT 0.000,
  `maximum_bonus_amount` decimal(24,3) NOT NULL DEFAULT 0.000,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: booking_additional_information
DROP TABLE IF EXISTS `booking_additional_information`;
CREATE TABLE `booking_additional_information` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `booking_id` char(36) NOT NULL,
  `key` varchar(255) NOT NULL,
  `value` text NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: booking_details
DROP TABLE IF EXISTS `booking_details`;
CREATE TABLE `booking_details` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `booking_id` char(36) DEFAULT NULL,
  `service_id` char(36) DEFAULT NULL,
  `service_name` varchar(255) DEFAULT NULL,
  `variant_key` varchar(255) DEFAULT NULL,
  `service_cost` decimal(24,3) NOT NULL DEFAULT 0.000,
  `quantity` int(11) NOT NULL DEFAULT 1,
  `discount_amount` decimal(24,3) NOT NULL DEFAULT 0.000,
  `tax_amount` decimal(24,3) NOT NULL DEFAULT 0.000,
  `total_cost` decimal(24,3) NOT NULL DEFAULT 0.000,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `campaign_discount_amount` decimal(24,3) NOT NULL DEFAULT 0.000,
  `overall_coupon_discount_amount` decimal(24,3) NOT NULL DEFAULT 0.000,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: booking_details_amounts
DROP TABLE IF EXISTS `booking_details_amounts`;
CREATE TABLE `booking_details_amounts` (
  `id` char(36) NOT NULL,
  `booking_details_id` char(36) NOT NULL,
  `booking_id` char(36) NOT NULL,
  `service_unit_cost` decimal(24,2) NOT NULL DEFAULT 0.00,
  `service_quantity` int(11) NOT NULL DEFAULT 0,
  `service_tax` decimal(24,2) NOT NULL DEFAULT 0.00,
  `discount_by_admin` decimal(24,2) NOT NULL DEFAULT 0.00,
  `discount_by_provider` decimal(24,2) NOT NULL DEFAULT 0.00,
  `coupon_discount_by_admin` decimal(24,2) NOT NULL DEFAULT 0.00,
  `coupon_discount_by_provider` decimal(24,2) NOT NULL DEFAULT 0.00,
  `campaign_discount_by_admin` decimal(24,2) NOT NULL DEFAULT 0.00,
  `campaign_discount_by_provider` decimal(24,2) NOT NULL DEFAULT 0.00,
  `admin_commission` decimal(24,2) NOT NULL DEFAULT 0.00,
  `provider_earning` decimal(24,2) NOT NULL DEFAULT 0.00,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `booking_repeat_id` char(36) DEFAULT NULL,
  `booking_repeat_details_id` char(36) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: booking_ignores
DROP TABLE IF EXISTS `booking_ignores`;
CREATE TABLE `booking_ignores` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `booking_id` char(36) DEFAULT NULL,
  `provider_id` char(36) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: booking_offline_payments
DROP TABLE IF EXISTS `booking_offline_payments`;
CREATE TABLE `booking_offline_payments` (
  `id` char(36) NOT NULL,
  `booking_id` char(36) NOT NULL,
  `offline_payment_id` char(36) DEFAULT NULL,
  `method_name` text DEFAULT NULL,
  `customer_information` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `payment_status` enum('pending','denied','approved') NOT NULL DEFAULT 'approved',
  `denied_note` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: booking_partial_payments
DROP TABLE IF EXISTS `booking_partial_payments`;
CREATE TABLE `booking_partial_payments` (
  `id` char(36) NOT NULL,
  `booking_id` varchar(255) NOT NULL,
  `paid_with` varchar(255) NOT NULL,
  `paid_amount` decimal(24,3) NOT NULL DEFAULT 0.000,
  `due_amount` decimal(24,3) NOT NULL DEFAULT 0.000,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: booking_repeat_details
DROP TABLE IF EXISTS `booking_repeat_details`;
CREATE TABLE `booking_repeat_details` (
  `id` char(36) NOT NULL,
  `booking_repeat_id` char(36) DEFAULT NULL,
  `booking_id` char(36) DEFAULT NULL,
  `booking_details_id` char(36) DEFAULT NULL,
  `service_id` char(36) DEFAULT NULL,
  `variant_key` varchar(255) DEFAULT NULL,
  `service_name` varchar(255) DEFAULT NULL,
  `service_cost` decimal(24,3) NOT NULL DEFAULT 0.000,
  `quantity` int(11) NOT NULL DEFAULT 1,
  `discount_amount` decimal(24,3) NOT NULL DEFAULT 0.000,
  `tax_amount` decimal(24,3) NOT NULL DEFAULT 0.000,
  `total_cost` decimal(24,3) NOT NULL DEFAULT 0.000,
  `campaign_discount_amount` decimal(24,3) NOT NULL DEFAULT 0.000,
  `overall_coupon_discount_amount` decimal(24,3) NOT NULL DEFAULT 0.000,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: booking_repeat_histories
DROP TABLE IF EXISTS `booking_repeat_histories`;
CREATE TABLE `booking_repeat_histories` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `booking_id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `booking_repeat_id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `booking_repeat_details_id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `readable_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `old_quantity` int(11) DEFAULT NULL,
  `new_quantity` int(11) DEFAULT NULL,
  `is_multiple` tinyint(4) NOT NULL DEFAULT 0,
  `total_booking_amount` decimal(24,3) NOT NULL DEFAULT 0.000,
  `total_tax_amount` decimal(24,3) NOT NULL DEFAULT 0.000,
  `total_discount_amount` decimal(24,3) NOT NULL DEFAULT 0.000,
  `extra_fee` decimal(24,3) NOT NULL DEFAULT 0.000,
  `total_referral_discount_amount` decimal(24,3) NOT NULL DEFAULT 0.000,
  `log_details` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Table: booking_repeats
DROP TABLE IF EXISTS `booking_repeats`;
CREATE TABLE `booking_repeats` (
  `id` char(36) NOT NULL,
  `readable_id` varchar(255) DEFAULT NULL,
  `booking_id` char(36) DEFAULT NULL,
  `booking_details_id` char(36) DEFAULT NULL,
  `provider_id` char(36) DEFAULT NULL,
  `serviceman_id` char(36) DEFAULT NULL,
  `booking_type` varchar(255) DEFAULT NULL,
  `transaction_id` varchar(255) DEFAULT NULL,
  `booking_status` varchar(255) NOT NULL DEFAULT 'pending',
  `service_schedule` datetime DEFAULT NULL,
  `is_paid` tinyint(1) NOT NULL DEFAULT 0,
  `payment_method` varchar(255) NOT NULL DEFAULT 'cash',
  `total_booking_amount` decimal(24,3) NOT NULL DEFAULT 0.000,
  `total_tax_amount` decimal(24,3) NOT NULL DEFAULT 0.000,
  `total_discount_amount` decimal(24,3) NOT NULL DEFAULT 0.000,
  `total_campaign_discount_amount` decimal(24,3) NOT NULL DEFAULT 0.000,
  `total_coupon_discount_amount` decimal(24,3) NOT NULL DEFAULT 0.000,
  `removed_coupon_amount` decimal(24,3) NOT NULL DEFAULT 0.000,
  `additional_charge` decimal(24,3) NOT NULL DEFAULT 0.000,
  `additional_tax_amount` decimal(24,3) NOT NULL DEFAULT 0.000,
  `additional_discount_amount` decimal(24,3) NOT NULL DEFAULT 0.000,
  `additional_campaign_discount_amount` decimal(24,3) NOT NULL DEFAULT 0.000,
  `extra_fee` decimal(24,3) NOT NULL DEFAULT 0.000,
  `total_referral_discount_amount` decimal(24,3) NOT NULL DEFAULT 0.000,
  `coupon_code` varchar(255) DEFAULT NULL,
  `is_verified` tinyint(4) NOT NULL DEFAULT 0,
  `is_reassign` tinyint(4) NOT NULL DEFAULT 0,
  `evidence_photos` longtext DEFAULT NULL,
  `booking_otp` varchar(255) DEFAULT NULL,
  `service_address_location` text DEFAULT NULL,
  `service_location` varchar(255) NOT NULL DEFAULT 'customer' COMMENT 'customer,provider',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: booking_schedule_histories
DROP TABLE IF EXISTS `booking_schedule_histories`;
CREATE TABLE `booking_schedule_histories` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `booking_id` char(36) NOT NULL,
  `changed_by` char(36) NOT NULL,
  `schedule` datetime NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `is_guest` tinyint(1) NOT NULL DEFAULT 0,
  `booking_repeat_id` char(36) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: booking_status_histories
DROP TABLE IF EXISTS `booking_status_histories`;
CREATE TABLE `booking_status_histories` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `booking_id` char(36) NOT NULL,
  `changed_by` char(36) NOT NULL,
  `booking_status` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `is_guest` tinyint(1) NOT NULL DEFAULT 0,
  `booking_repeat_id` char(36) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: bookings
DROP TABLE IF EXISTS `bookings`;
CREATE TABLE `bookings` (
  `id` char(36) NOT NULL,
  `readable_id` bigint(20) NOT NULL,
  `customer_id` char(36) DEFAULT NULL,
  `provider_id` char(36) DEFAULT NULL,
  `zone_id` char(36) DEFAULT NULL,
  `booking_status` varchar(255) NOT NULL DEFAULT 'pending',
  `is_paid` tinyint(1) NOT NULL DEFAULT 0,
  `payment_method` varchar(255) NOT NULL DEFAULT 'cash',
  `transaction_id` varchar(255) DEFAULT NULL,
  `total_booking_amount` decimal(24,3) NOT NULL DEFAULT 0.000,
  `total_tax_amount` decimal(24,3) NOT NULL DEFAULT 0.000,
  `total_discount_amount` decimal(24,3) NOT NULL DEFAULT 0.000,
  `service_schedule` datetime DEFAULT NULL,
  `service_address_id` char(36) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `category_id` char(36) DEFAULT NULL,
  `sub_category_id` char(36) DEFAULT NULL,
  `serviceman_id` char(36) DEFAULT NULL,
  `total_campaign_discount_amount` decimal(24,3) NOT NULL DEFAULT 0.000,
  `total_coupon_discount_amount` decimal(24,3) NOT NULL DEFAULT 0.000,
  `coupon_code` varchar(255) DEFAULT NULL,
  `is_checked` tinyint(1) NOT NULL DEFAULT 0,
  `additional_charge` decimal(24,2) NOT NULL DEFAULT 0.00,
  `additional_tax_amount` decimal(24,2) NOT NULL DEFAULT 0.00,
  `additional_discount_amount` decimal(24,2) NOT NULL DEFAULT 0.00,
  `additional_campaign_discount_amount` decimal(24,2) NOT NULL DEFAULT 0.00,
  `removed_coupon_amount` decimal(24,2) NOT NULL DEFAULT 0.00,
  `evidence_photos` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `booking_otp` varchar(255) DEFAULT NULL,
  `is_guest` tinyint(1) NOT NULL DEFAULT 0,
  `is_verified` tinyint(1) NOT NULL DEFAULT 0,
  `extra_fee` decimal(24,3) NOT NULL DEFAULT 0.000,
  `total_referral_discount_amount` decimal(24,2) NOT NULL DEFAULT 0.00,
  `is_repeated` tinyint(4) NOT NULL DEFAULT 0,
  `assigned_by` varchar(255) DEFAULT NULL,
  `service_location` varchar(255) NOT NULL DEFAULT 'customer' COMMENT 'customer,provider',
  `service_address_location` text DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: business_page_settings
DROP TABLE IF EXISTS `business_page_settings`;
CREATE TABLE `business_page_settings` (
  `id` char(36) NOT NULL,
  `page_key` varchar(255) NOT NULL,
  `title` varchar(255) NOT NULL,
  `content` text DEFAULT NULL,
  `image` text DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `is_default` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `business_page_settings_page_key_unique` (`page_key`),
  UNIQUE KEY `business_page_settings_title_unique` (`title`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: business_settings
DROP TABLE IF EXISTS `business_settings`;
CREATE TABLE `business_settings` (
  `id` char(36) NOT NULL COMMENT '(DC2Type:guid)',
  `key_name` varchar(191) DEFAULT NULL,
  `live_values` longtext DEFAULT NULL,
  `test_values` longtext DEFAULT NULL,
  `settings_type` varchar(255) DEFAULT NULL,
  `mode` varchar(20) NOT NULL DEFAULT 'live',
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: campaigns
DROP TABLE IF EXISTS `campaigns`;
CREATE TABLE `campaigns` (
  `id` char(36) NOT NULL,
  `campaign_name` varchar(191) DEFAULT NULL,
  `cover_image` varchar(191) NOT NULL DEFAULT 'def.png',
  `thumbnail` varchar(191) NOT NULL DEFAULT 'def.png',
  `discount_id` char(36) DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: carts
DROP TABLE IF EXISTS `carts`;
CREATE TABLE `carts` (
  `id` char(36) NOT NULL,
  `customer_id` char(36) DEFAULT NULL,
  `provider_id` char(36) DEFAULT NULL,
  `service_id` char(36) DEFAULT NULL,
  `category_id` char(36) DEFAULT NULL,
  `sub_category_id` char(36) DEFAULT NULL,
  `variant_key` varchar(191) DEFAULT NULL,
  `service_cost` decimal(24,2) NOT NULL DEFAULT 0.00,
  `quantity` int(11) NOT NULL DEFAULT 1,
  `discount_amount` decimal(24,2) NOT NULL DEFAULT 0.00,
  `coupon_code` varchar(255) DEFAULT NULL,
  `coupon_discount` decimal(24,2) NOT NULL DEFAULT 0.00,
  `campaign_discount` decimal(24,2) NOT NULL DEFAULT 0.00,
  `tax_amount` decimal(24,2) NOT NULL DEFAULT 0.00,
  `total_cost` decimal(24,2) NOT NULL DEFAULT 0.00,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `is_guest` tinyint(1) NOT NULL DEFAULT 0,
  `coupon_id` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: categories
DROP TABLE IF EXISTS `categories`;
CREATE TABLE `categories` (
  `id` char(36) NOT NULL,
  `parent_id` char(36) DEFAULT NULL,
  `name` varchar(191) DEFAULT NULL,
  `image` varchar(191) DEFAULT NULL,
  `position` int(10) unsigned NOT NULL DEFAULT 1,
  `description` text DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `is_featured` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: category_zone
DROP TABLE IF EXISTS `category_zone`;
CREATE TABLE `category_zone` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `category_id` char(36) NOT NULL,
  `zone_id` char(36) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: channel_conversations
DROP TABLE IF EXISTS `channel_conversations`;
CREATE TABLE `channel_conversations` (
  `id` char(36) NOT NULL,
  `channel_id` char(36) NOT NULL,
  `message` text DEFAULT NULL,
  `user_id` char(36) NOT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: channel_lists
DROP TABLE IF EXISTS `channel_lists`;
CREATE TABLE `channel_lists` (
  `id` char(36) NOT NULL,
  `reference_id` char(36) DEFAULT NULL COMMENT '(DC2Type:guid)',
  `reference_type` varchar(255) DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: channel_users
DROP TABLE IF EXISTS `channel_users`;
CREATE TABLE `channel_users` (
  `id` char(36) NOT NULL,
  `channel_id` char(36) NOT NULL,
  `user_id` char(36) NOT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `is_read` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: conversation_files
DROP TABLE IF EXISTS `conversation_files`;
CREATE TABLE `conversation_files` (
  `id` char(36) NOT NULL,
  `conversation_id` char(36) NOT NULL,
  `stored_file_name` varchar(255) NOT NULL,
  `original_file_name` varchar(255) DEFAULT NULL,
  `file_type` varchar(255) NOT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: coupon_customers
DROP TABLE IF EXISTS `coupon_customers`;
CREATE TABLE `coupon_customers` (
  `id` char(36) NOT NULL,
  `coupon_id` char(36) DEFAULT NULL,
  `customer_user_id` char(36) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: coupons
DROP TABLE IF EXISTS `coupons`;
CREATE TABLE `coupons` (
  `id` char(36) NOT NULL,
  `coupon_type` varchar(191) DEFAULT NULL,
  `coupon_code` varchar(191) DEFAULT NULL,
  `discount_id` char(36) DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: cron_jobs
DROP TABLE IF EXISTS `cron_jobs`;
CREATE TABLE `cron_jobs` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(255) DEFAULT NULL,
  `send_mail_type` varchar(255) DEFAULT NULL,
  `send_mail_day` int(11) NOT NULL DEFAULT 1,
  `activity` varchar(255) DEFAULT NULL,
  `php_file_path` varchar(255) DEFAULT NULL,
  `command` varchar(255) DEFAULT NULL,
  `status` int(11) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `type` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: data_settings
DROP TABLE IF EXISTS `data_settings`;
CREATE TABLE `data_settings` (
  `id` char(36) NOT NULL,
  `key` varchar(255) NOT NULL,
  `value` text DEFAULT NULL,
  `type` varchar(255) NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: discount_types
DROP TABLE IF EXISTS `discount_types`;
CREATE TABLE `discount_types` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `discount_id` char(36) DEFAULT NULL,
  `discount_type` varchar(255) DEFAULT NULL,
  `type_wise_id` char(36) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: discounts
DROP TABLE IF EXISTS `discounts`;
CREATE TABLE `discounts` (
  `id` char(36) NOT NULL,
  `discount_title` varchar(191) DEFAULT NULL,
  `discount_type` varchar(191) DEFAULT NULL,
  `discount_amount` decimal(24,3) NOT NULL DEFAULT 0.000,
  `discount_amount_type` varchar(191) NOT NULL DEFAULT 'percent',
  `min_purchase` decimal(24,3) NOT NULL DEFAULT 0.000,
  `max_discount_amount` decimal(24,3) NOT NULL DEFAULT 0.000,
  `limit_per_user` int(11) NOT NULL DEFAULT 0,
  `promotion_type` varchar(191) NOT NULL DEFAULT 'discount',
  `is_active` tinyint(1) NOT NULL DEFAULT 0,
  `start_date` date NOT NULL DEFAULT '2022-04-04',
  `end_date` date NOT NULL DEFAULT '2022-04-04',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: employee_role_accesses
DROP TABLE IF EXISTS `employee_role_accesses`;
CREATE TABLE `employee_role_accesses` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `employee_id` char(36) NOT NULL,
  `role_id` char(36) NOT NULL,
  `section_name` varchar(255) NOT NULL,
  `can_view` tinyint(4) NOT NULL DEFAULT 1,
  `can_add` tinyint(4) NOT NULL DEFAULT 0,
  `can_update` tinyint(4) NOT NULL DEFAULT 0,
  `can_delete` tinyint(4) NOT NULL DEFAULT 0,
  `can_export` tinyint(4) NOT NULL DEFAULT 0,
  `can_manage_status` tinyint(4) NOT NULL DEFAULT 0,
  `can_approve_or_deny` tinyint(4) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `can_assign_serviceman` tinyint(4) NOT NULL DEFAULT 0,
  `can_give_feedback` tinyint(4) NOT NULL DEFAULT 0,
  `can_take_backup` tinyint(4) NOT NULL DEFAULT 0,
  `can_change_status` tinyint(4) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: employee_role_sections
DROP TABLE IF EXISTS `employee_role_sections`;
CREATE TABLE `employee_role_sections` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `employee_id` char(36) NOT NULL,
  `role_id` char(36) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: error_logs
DROP TABLE IF EXISTS `error_logs`;
CREATE TABLE `error_logs` (
  `id` char(36) NOT NULL,
  `status_code` int(11) DEFAULT NULL,
  `url` varchar(255) NOT NULL,
  `hit_counts` int(11) NOT NULL DEFAULT 0,
  `redirect_url` varchar(255) DEFAULT NULL,
  `redirect_status` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: faqs
DROP TABLE IF EXISTS `faqs`;
CREATE TABLE `faqs` (
  `id` char(36) NOT NULL,
  `question` text DEFAULT NULL,
  `answer` text DEFAULT NULL,
  `service_id` char(36) DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: favorite_providers
DROP TABLE IF EXISTS `favorite_providers`;
CREATE TABLE `favorite_providers` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `customer_user_id` char(36) NOT NULL,
  `provider_id` char(36) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: favorite_services
DROP TABLE IF EXISTS `favorite_services`;
CREATE TABLE `favorite_services` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `customer_user_id` char(36) NOT NULL,
  `service_id` char(36) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: guests
DROP TABLE IF EXISTS `guests`;
CREATE TABLE `guests` (
  `id` char(36) NOT NULL,
  `guest_id` char(36) DEFAULT NULL,
  `ip_address` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `current_language_key` varchar(255) DEFAULT 'en',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: ignored_posts
DROP TABLE IF EXISTS `ignored_posts`;
CREATE TABLE `ignored_posts` (
  `id` char(36) NOT NULL,
  `post_id` char(36) NOT NULL,
  `provider_id` char(36) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: landing_page_features
DROP TABLE IF EXISTS `landing_page_features`;
CREATE TABLE `landing_page_features` (
  `id` char(36) NOT NULL,
  `title` varchar(255) DEFAULT NULL,
  `sub_title` varchar(255) DEFAULT NULL,
  `image_1` varchar(255) DEFAULT NULL,
  `image_2` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: landing_page_specialities
DROP TABLE IF EXISTS `landing_page_specialities`;
CREATE TABLE `landing_page_specialities` (
  `id` char(36) NOT NULL,
  `title` varchar(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `image` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: landing_page_testimonials
DROP TABLE IF EXISTS `landing_page_testimonials`;
CREATE TABLE `landing_page_testimonials` (
  `id` char(36) NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `designation` varchar(255) DEFAULT NULL,
  `review` varchar(255) DEFAULT NULL,
  `image` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: login_setups
DROP TABLE IF EXISTS `login_setups`;
CREATE TABLE `login_setups` (
  `id` char(36) NOT NULL,
  `key` varchar(255) DEFAULT NULL,
  `value` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: loyalty_point_transactions
DROP TABLE IF EXISTS `loyalty_point_transactions`;
CREATE TABLE `loyalty_point_transactions` (
  `id` char(36) NOT NULL,
  `user_id` char(36) NOT NULL,
  `credit` decimal(24,2) NOT NULL DEFAULT 0.00,
  `debit` decimal(24,2) NOT NULL DEFAULT 0.00,
  `balance` decimal(24,2) NOT NULL DEFAULT 0.00,
  `reference` varchar(255) DEFAULT NULL,
  `transaction_type` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: migrations
DROP TABLE IF EXISTS `migrations`;
CREATE TABLE `migrations` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `migration` varchar(255) NOT NULL,
  `batch` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=223 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: modules
DROP TABLE IF EXISTS `modules`;
CREATE TABLE `modules` (
  `id` char(36) NOT NULL,
  `module_name` varchar(191) DEFAULT NULL,
  `module_display_name` varchar(191) DEFAULT NULL,
  `icon` varchar(191) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: notification_setups
DROP TABLE IF EXISTS `notification_setups`;
CREATE TABLE `notification_setups` (
  `id` char(36) NOT NULL,
  `user_type` varchar(255) DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  `sub_title` varchar(255) DEFAULT NULL,
  `key` varchar(255) DEFAULT NULL,
  `value` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `key_type` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: oauth_access_tokens
DROP TABLE IF EXISTS `oauth_access_tokens`;
CREATE TABLE `oauth_access_tokens` (
  `id` varchar(100) NOT NULL,
  `user_id` char(36) DEFAULT NULL,
  `client_id` char(36) NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `scopes` text DEFAULT NULL,
  `revoked` tinyint(1) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `expires_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `oauth_access_tokens_user_id_index` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: oauth_auth_codes
DROP TABLE IF EXISTS `oauth_auth_codes`;
CREATE TABLE `oauth_auth_codes` (
  `id` varchar(100) NOT NULL,
  `user_id` char(36) NOT NULL,
  `client_id` char(36) NOT NULL,
  `scopes` text DEFAULT NULL,
  `revoked` tinyint(1) NOT NULL,
  `expires_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `oauth_auth_codes_user_id_index` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: oauth_clients
DROP TABLE IF EXISTS `oauth_clients`;
CREATE TABLE `oauth_clients` (
  `id` char(36) NOT NULL,
  `user_id` char(36) DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `secret` varchar(100) DEFAULT NULL,
  `provider` varchar(255) DEFAULT NULL,
  `redirect` text NOT NULL,
  `personal_access_client` tinyint(1) NOT NULL,
  `password_client` tinyint(1) NOT NULL,
  `revoked` tinyint(1) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `oauth_clients_user_id_index` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: oauth_personal_access_clients
DROP TABLE IF EXISTS `oauth_personal_access_clients`;
CREATE TABLE `oauth_personal_access_clients` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `client_id` char(36) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: oauth_refresh_tokens
DROP TABLE IF EXISTS `oauth_refresh_tokens`;
CREATE TABLE `oauth_refresh_tokens` (
  `id` varchar(100) NOT NULL,
  `access_token_id` varchar(100) NOT NULL,
  `revoked` tinyint(1) NOT NULL,
  `expires_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `oauth_refresh_tokens_access_token_id_index` (`access_token_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: offline_payments
DROP TABLE IF EXISTS `offline_payments`;
CREATE TABLE `offline_payments` (
  `id` char(36) NOT NULL,
  `method_name` varchar(255) NOT NULL,
  `payment_information` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `customer_information` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: package_subscriber_features
DROP TABLE IF EXISTS `package_subscriber_features`;
CREATE TABLE `package_subscriber_features` (
  `id` char(36) NOT NULL,
  `provider_id` char(36) DEFAULT NULL,
  `package_subscriber_log_id` char(36) DEFAULT NULL,
  `feature` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: package_subscriber_limits
DROP TABLE IF EXISTS `package_subscriber_limits`;
CREATE TABLE `package_subscriber_limits` (
  `id` char(36) NOT NULL,
  `provider_id` char(36) DEFAULT NULL,
  `subscription_package_id` char(36) DEFAULT NULL,
  `key` varchar(255) DEFAULT NULL,
  `is_limited` tinyint(1) NOT NULL DEFAULT 1,
  `limit_count` int(10) unsigned NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: package_subscriber_logs
DROP TABLE IF EXISTS `package_subscriber_logs`;
CREATE TABLE `package_subscriber_logs` (
  `id` char(36) NOT NULL,
  `provider_id` char(36) DEFAULT NULL,
  `subscription_package_id` char(36) DEFAULT NULL,
  `package_name` varchar(255) DEFAULT NULL,
  `package_price` decimal(24,2) NOT NULL DEFAULT 0.00,
  `start_date` timestamp NULL DEFAULT NULL,
  `end_date` timestamp NULL DEFAULT NULL,
  `vat_percentage` double(8,2) NOT NULL DEFAULT 0.00,
  `vat_amount` double(8,2) NOT NULL DEFAULT 0.00,
  `payment_id` varchar(50) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `primary_transaction_id` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: package_subscribers
DROP TABLE IF EXISTS `package_subscribers`;
CREATE TABLE `package_subscribers` (
  `id` char(36) NOT NULL,
  `provider_id` char(36) DEFAULT NULL,
  `subscription_package_id` char(36) DEFAULT NULL,
  `package_subscriber_log_id` char(36) DEFAULT NULL,
  `package_name` varchar(255) DEFAULT NULL,
  `package_price` decimal(24,2) NOT NULL DEFAULT 0.00,
  `package_start_date` timestamp NULL DEFAULT NULL,
  `package_end_date` timestamp NULL DEFAULT NULL,
  `trial_duration` int(11) NOT NULL DEFAULT 0,
  `vat_percentage` double(8,2) NOT NULL DEFAULT 0.00,
  `vat_amount` double(8,2) NOT NULL DEFAULT 0.00,
  `payment_method` varchar(50) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `is_canceled` tinyint(4) NOT NULL DEFAULT 0,
  `payment_id` char(36) DEFAULT NULL,
  `is_notified` tinyint(4) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: password_resets
DROP TABLE IF EXISTS `password_resets`;
CREATE TABLE `password_resets` (
  `email` varchar(255) DEFAULT NULL,
  `token` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `phone` varchar(255) DEFAULT NULL,
  `user_id` char(36) DEFAULT NULL,
  `expires_at` datetime DEFAULT NULL,
  KEY `password_resets_email_index` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: payment_requests
DROP TABLE IF EXISTS `payment_requests`;
CREATE TABLE `payment_requests` (
  `id` char(36) NOT NULL,
  `payer_id` varchar(64) DEFAULT NULL,
  `receiver_id` varchar(64) DEFAULT NULL,
  `payment_amount` decimal(24,2) NOT NULL DEFAULT 0.00,
  `gateway_callback_url` varchar(191) DEFAULT NULL,
  `success_hook` varchar(100) DEFAULT NULL,
  `failure_hook` varchar(100) DEFAULT NULL,
  `transaction_id` varchar(100) DEFAULT NULL,
  `currency_code` varchar(20) NOT NULL DEFAULT 'USD',
  `payment_method` varchar(50) DEFAULT NULL,
  `additional_data` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `is_paid` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `payer_information` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `external_redirect_link` varchar(255) DEFAULT NULL,
  `receiver_information` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `attribute_id` varchar(64) DEFAULT NULL,
  `attribute` varchar(255) DEFAULT NULL,
  `payment_platform` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: personal_access_tokens
DROP TABLE IF EXISTS `personal_access_tokens`;
CREATE TABLE `personal_access_tokens` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `tokenable_type` varchar(255) NOT NULL,
  `tokenable_id` bigint(20) unsigned NOT NULL,
  `name` varchar(255) NOT NULL,
  `token` varchar(64) NOT NULL,
  `abilities` text DEFAULT NULL,
  `last_used_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `personal_access_tokens_token_unique` (`token`),
  KEY `personal_access_tokens_tokenable_type_tokenable_id_index` (`tokenable_type`,`tokenable_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: post_additional_information
DROP TABLE IF EXISTS `post_additional_information`;
CREATE TABLE `post_additional_information` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `post_id` char(36) NOT NULL,
  `key` varchar(255) NOT NULL,
  `value` text NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: post_additional_instructions
DROP TABLE IF EXISTS `post_additional_instructions`;
CREATE TABLE `post_additional_instructions` (
  `id` char(36) NOT NULL,
  `details` text DEFAULT NULL,
  `post_id` char(36) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: post_bids
DROP TABLE IF EXISTS `post_bids`;
CREATE TABLE `post_bids` (
  `id` char(36) NOT NULL,
  `offered_price` decimal(24,2) NOT NULL DEFAULT 0.00,
  `provider_note` text DEFAULT NULL,
  `status` varchar(255) NOT NULL,
  `post_id` char(36) NOT NULL,
  `provider_id` char(36) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: posts
DROP TABLE IF EXISTS `posts`;
CREATE TABLE `posts` (
  `id` char(36) NOT NULL,
  `service_description` text DEFAULT NULL,
  `booking_schedule` datetime DEFAULT NULL,
  `is_booked` tinyint(1) NOT NULL DEFAULT 0,
  `is_checked` tinyint(1) NOT NULL DEFAULT 0,
  `customer_user_id` char(36) NOT NULL,
  `service_id` char(36) DEFAULT NULL,
  `category_id` char(36) DEFAULT NULL,
  `sub_category_id` char(36) DEFAULT NULL,
  `service_address_id` char(36) DEFAULT NULL,
  `zone_id` char(36) DEFAULT NULL,
  `booking_id` char(36) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `is_guest` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: provider_notification_setups
DROP TABLE IF EXISTS `provider_notification_setups`;
CREATE TABLE `provider_notification_setups` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `provider_id` char(36) DEFAULT NULL,
  `notification_setup_id` char(36) DEFAULT NULL,
  `value` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: provider_settings
DROP TABLE IF EXISTS `provider_settings`;
CREATE TABLE `provider_settings` (
  `id` char(36) NOT NULL,
  `provider_id` char(36) NOT NULL,
  `key_name` varchar(191) DEFAULT NULL,
  `live_values` longtext DEFAULT NULL,
  `test_values` longtext DEFAULT NULL,
  `settings_type` varchar(255) DEFAULT NULL,
  `mode` varchar(20) NOT NULL DEFAULT 'live',
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: provider_sub_category
DROP TABLE IF EXISTS `provider_sub_category`;
CREATE TABLE `provider_sub_category` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `provider_id` char(36) NOT NULL,
  `sub_category_id` char(36) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: providers
DROP TABLE IF EXISTS `providers`;
CREATE TABLE `providers` (
  `id` char(36) NOT NULL,
  `user_id` char(36) DEFAULT NULL,
  `company_name` varchar(191) DEFAULT NULL,
  `company_phone` varchar(25) DEFAULT NULL,
  `company_address` varchar(191) DEFAULT NULL,
  `company_email` varchar(191) DEFAULT NULL,
  `logo` varchar(191) DEFAULT NULL,
  `contact_person_name` varchar(191) DEFAULT NULL,
  `contact_person_phone` varchar(25) DEFAULT NULL,
  `contact_person_email` varchar(191) DEFAULT NULL,
  `order_count` int(10) unsigned NOT NULL DEFAULT 0,
  `service_man_count` int(10) unsigned NOT NULL DEFAULT 0,
  `service_capacity_per_day` int(10) unsigned NOT NULL DEFAULT 0,
  `rating_count` int(10) unsigned NOT NULL DEFAULT 0,
  `avg_rating` double(8,4) NOT NULL DEFAULT 0.0000,
  `commission_status` tinyint(1) NOT NULL DEFAULT 0,
  `commission_percentage` double(8,4) NOT NULL DEFAULT 0.0000,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `is_approved` tinyint(1) NOT NULL DEFAULT 0,
  `zone_id` char(36) DEFAULT NULL,
  `coordinates` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `is_suspended` tinyint(1) NOT NULL DEFAULT 0,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `service_availability` tinyint(1) NOT NULL DEFAULT 1,
  `cover_image` varchar(191) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: providers_withdraw_methods_data
DROP TABLE IF EXISTS `providers_withdraw_methods_data`;
CREATE TABLE `providers_withdraw_methods_data` (
  `id` char(36) NOT NULL,
  `provider_id` char(36) NOT NULL,
  `withdrawal_method_id` char(36) NOT NULL,
  `method_name` varchar(255) NOT NULL,
  `method_field_data` text NOT NULL,
  `is_default` tinyint(1) NOT NULL DEFAULT 0,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `providers_withdraw_methods_data_provider_id_index` (`provider_id`),
  KEY `providers_withdraw_methods_data_withdrawal_method_id_index` (`withdrawal_method_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: push_notification_users
DROP TABLE IF EXISTS `push_notification_users`;
CREATE TABLE `push_notification_users` (
  `id` char(36) NOT NULL,
  `push_notification_id` char(36) NOT NULL,
  `user_id` char(36) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: push_notifications
DROP TABLE IF EXISTS `push_notifications`;
CREATE TABLE `push_notifications` (
  `id` char(36) NOT NULL,
  `title` varchar(191) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `cover_image` varchar(255) DEFAULT NULL,
  `zone_ids` text NOT NULL,
  `to_users` varchar(255) NOT NULL DEFAULT '["customer"]',
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: recent_searches
DROP TABLE IF EXISTS `recent_searches`;
CREATE TABLE `recent_searches` (
  `id` char(36) NOT NULL,
  `user_id` char(36) NOT NULL,
  `keyword` varchar(255) DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: recent_views
DROP TABLE IF EXISTS `recent_views`;
CREATE TABLE `recent_views` (
  `id` char(36) NOT NULL,
  `user_id` char(36) NOT NULL,
  `service_id` char(36) DEFAULT NULL,
  `total_service_view` int(11) NOT NULL DEFAULT 0,
  `category_id` char(36) DEFAULT NULL,
  `total_category_view` int(11) NOT NULL DEFAULT 0,
  `sub_category_id` char(36) DEFAULT NULL,
  `total_sub_category_view` int(11) NOT NULL DEFAULT 0,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: review_replies
DROP TABLE IF EXISTS `review_replies`;
CREATE TABLE `review_replies` (
  `id` char(36) NOT NULL,
  `readable_id` bigint(20) DEFAULT NULL,
  `user_id` char(36) DEFAULT NULL,
  `review_id` char(36) DEFAULT NULL,
  `reply` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: reviews
DROP TABLE IF EXISTS `reviews`;
CREATE TABLE `reviews` (
  `id` char(36) NOT NULL,
  `readable_id` bigint(20) NOT NULL,
  `booking_id` char(36) DEFAULT NULL,
  `service_id` char(36) DEFAULT NULL,
  `provider_id` char(36) DEFAULT NULL,
  `review_rating` int(11) NOT NULL DEFAULT 1,
  `review_comment` text DEFAULT NULL,
  `review_images` text DEFAULT NULL,
  `booking_date` datetime DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `customer_id` char(36) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: role_accesses
DROP TABLE IF EXISTS `role_accesses`;
CREATE TABLE `role_accesses` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `role_id` char(36) NOT NULL,
  `section_name` varchar(255) NOT NULL,
  `can_view` tinyint(4) NOT NULL DEFAULT 1,
  `can_add` tinyint(4) NOT NULL DEFAULT 0,
  `can_update` tinyint(4) NOT NULL DEFAULT 0,
  `can_delete` tinyint(4) NOT NULL DEFAULT 0,
  `can_export` tinyint(4) NOT NULL DEFAULT 0,
  `can_manage_status` tinyint(4) NOT NULL DEFAULT 0,
  `can_approve_or_deny` tinyint(4) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `can_assign_serviceman` tinyint(4) NOT NULL DEFAULT 0,
  `can_give_feedback` tinyint(4) NOT NULL DEFAULT 0,
  `can_take_backup` tinyint(4) NOT NULL DEFAULT 0,
  `can_change_status` tinyint(4) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: roles
DROP TABLE IF EXISTS `roles`;
CREATE TABLE `roles` (
  `id` char(36) NOT NULL,
  `role_name` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: route_search_histories
DROP TABLE IF EXISTS `route_search_histories`;
CREATE TABLE `route_search_histories` (
  `id` char(36) NOT NULL,
  `user_id` char(36) NOT NULL,
  `user_type` varchar(255) NOT NULL,
  `route_name` varchar(255) NOT NULL,
  `route_uri` varchar(255) NOT NULL,
  `route_full_url` varchar(255) NOT NULL,
  `keyword` varchar(255) DEFAULT NULL,
  `response` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`response`)),
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: searched_data
DROP TABLE IF EXISTS `searched_data`;
CREATE TABLE `searched_data` (
  `id` char(36) NOT NULL,
  `user_id` char(36) NOT NULL,
  `zone_id` char(36) NOT NULL,
  `attribute` varchar(255) DEFAULT NULL,
  `attribute_id` char(36) DEFAULT NULL,
  `response_data_count` int(11) NOT NULL DEFAULT 0,
  `volume` int(11) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: seo_settings
DROP TABLE IF EXISTS `seo_settings`;
CREATE TABLE `seo_settings` (
  `id` char(36) NOT NULL,
  `page_title` varchar(255) DEFAULT NULL,
  `page_name` varchar(255) DEFAULT NULL,
  `page_url` varchar(255) DEFAULT NULL,
  `meta_title` varchar(255) DEFAULT NULL,
  `meta_description` text DEFAULT NULL,
  `meta_image` varchar(255) DEFAULT NULL,
  `canonicals_url` varchar(255) DEFAULT NULL,
  `index` varchar(255) DEFAULT NULL,
  `no_follow` varchar(255) DEFAULT NULL,
  `no_image_index` varchar(255) DEFAULT NULL,
  `no_archive` varchar(255) DEFAULT NULL,
  `no_snippet` varchar(255) DEFAULT NULL,
  `max_snippet` varchar(255) DEFAULT NULL,
  `max_snippet_value` varchar(255) DEFAULT NULL,
  `max_video_preview` varchar(255) DEFAULT NULL,
  `max_video_preview_value` varchar(255) DEFAULT NULL,
  `max_image_preview` varchar(255) DEFAULT NULL,
  `max_image_preview_value` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: service_requests
DROP TABLE IF EXISTS `service_requests`;
CREATE TABLE `service_requests` (
  `id` char(36) NOT NULL,
  `category_id` char(36) DEFAULT NULL COMMENT '(DC2Type:guid)',
  `service_name` varchar(255) NOT NULL,
  `service_description` text NOT NULL,
  `status` varchar(20) NOT NULL COMMENT 'pending,accepted,denied',
  `admin_feedback` text DEFAULT NULL,
  `user_id` char(36) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: service_tag
DROP TABLE IF EXISTS `service_tag`;
CREATE TABLE `service_tag` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `service_id` char(36) NOT NULL,
  `tag_id` char(36) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: servicemen
DROP TABLE IF EXISTS `servicemen`;
CREATE TABLE `servicemen` (
  `id` char(36) NOT NULL,
  `provider_id` char(36) DEFAULT NULL,
  `user_id` char(36) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: services
DROP TABLE IF EXISTS `services`;
CREATE TABLE `services` (
  `id` char(36) NOT NULL,
  `name` varchar(191) DEFAULT NULL,
  `short_description` text DEFAULT NULL,
  `description` text DEFAULT NULL,
  `cover_image` varchar(191) DEFAULT NULL,
  `thumbnail` varchar(191) DEFAULT NULL,
  `category_id` char(36) DEFAULT NULL,
  `sub_category_id` char(36) DEFAULT NULL,
  `tax` decimal(24,3) NOT NULL DEFAULT 0.000,
  `order_count` int(10) unsigned NOT NULL DEFAULT 0,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `rating_count` int(10) unsigned NOT NULL DEFAULT 0,
  `avg_rating` double(8,4) NOT NULL DEFAULT 0.0000,
  `min_bidding_price` decimal(24,3) NOT NULL DEFAULT 0.000,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: settings_tutorials
DROP TABLE IF EXISTS `settings_tutorials`;
CREATE TABLE `settings_tutorials` (
  `id` char(36) NOT NULL,
  `user_id` char(36) NOT NULL,
  `options` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`options`)),
  `platform` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `settings_tutorials_user_id_index` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: storages
DROP TABLE IF EXISTS `storages`;
CREATE TABLE `storages` (
  `id` char(36) NOT NULL,
  `model` varchar(255) NOT NULL,
  `model_id` char(36) NOT NULL,
  `model_column` varchar(255) NOT NULL,
  `storage_type` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `storages_model_id_index` (`model_id`),
  KEY `storages_model_column_index` (`model_column`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: subscribe_newsletters
DROP TABLE IF EXISTS `subscribe_newsletters`;
CREATE TABLE `subscribe_newsletters` (
  `id` char(36) NOT NULL,
  `email` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `subscribe_newsletters_email_unique` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: subscribed_services
DROP TABLE IF EXISTS `subscribed_services`;
CREATE TABLE `subscribed_services` (
  `id` char(36) NOT NULL,
  `provider_id` char(36) NOT NULL,
  `category_id` char(36) NOT NULL,
  `sub_category_id` char(36) NOT NULL,
  `is_subscribed` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: subscription_booking_types
DROP TABLE IF EXISTS `subscription_booking_types`;
CREATE TABLE `subscription_booking_types` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `booking_id` char(36) DEFAULT NULL,
  `type` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: subscription_package_features
DROP TABLE IF EXISTS `subscription_package_features`;
CREATE TABLE `subscription_package_features` (
  `id` char(36) NOT NULL,
  `subscription_package_id` char(36) DEFAULT NULL,
  `feature` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: subscription_package_limits
DROP TABLE IF EXISTS `subscription_package_limits`;
CREATE TABLE `subscription_package_limits` (
  `id` char(36) NOT NULL,
  `subscription_package_id` char(36) DEFAULT NULL,
  `key` varchar(255) DEFAULT NULL,
  `is_limited` tinyint(1) NOT NULL DEFAULT 1,
  `limit_count` int(10) unsigned NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: subscription_packages
DROP TABLE IF EXISTS `subscription_packages`;
CREATE TABLE `subscription_packages` (
  `id` char(36) NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `price` decimal(24,2) NOT NULL DEFAULT 0.00,
  `duration` int(11) NOT NULL DEFAULT 0,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `description` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: subscription_subscriber_bookings
DROP TABLE IF EXISTS `subscription_subscriber_bookings`;
CREATE TABLE `subscription_subscriber_bookings` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `provider_id` char(36) DEFAULT NULL,
  `booking_id` char(36) DEFAULT NULL,
  `package_subscriber_log_id` char(36) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: tags
DROP TABLE IF EXISTS `tags`;
CREATE TABLE `tags` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `tag` text NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: transactions
DROP TABLE IF EXISTS `transactions`;
CREATE TABLE `transactions` (
  `id` char(36) NOT NULL,
  `ref_trx_id` char(36) DEFAULT NULL,
  `booking_id` char(36) DEFAULT NULL,
  `trx_type` varchar(255) DEFAULT NULL,
  `debit` decimal(24,2) NOT NULL DEFAULT 0.00,
  `credit` decimal(24,2) NOT NULL DEFAULT 0.00,
  `balance` decimal(24,2) NOT NULL DEFAULT 0.00,
  `from_user_id` char(36) DEFAULT NULL,
  `to_user_id` char(36) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `from_user_account` varchar(255) DEFAULT NULL,
  `to_user_account` varchar(255) DEFAULT NULL,
  `reference_note` varchar(100) DEFAULT NULL,
  `is_guest` tinyint(1) NOT NULL DEFAULT 0,
  `booking_repeat_id` char(36) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: translations
DROP TABLE IF EXISTS `translations`;
CREATE TABLE `translations` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `translationable_type` varchar(255) NOT NULL,
  `translationable_id` char(36) NOT NULL,
  `locale` varchar(255) NOT NULL,
  `key` varchar(255) DEFAULT NULL,
  `value` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `translations_translationable_id_index` (`translationable_id`),
  KEY `translations_locale_index` (`locale`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: user_addresses
DROP TABLE IF EXISTS `user_addresses`;
CREATE TABLE `user_addresses` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` char(36) DEFAULT NULL,
  `lat` varchar(191) DEFAULT NULL,
  `lon` varchar(191) DEFAULT NULL,
  `city` varchar(191) DEFAULT NULL,
  `street` varchar(191) DEFAULT NULL,
  `zip_code` varchar(255) DEFAULT NULL,
  `country` varchar(255) DEFAULT NULL,
  `address` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `address_type` varchar(255) DEFAULT NULL,
  `contact_person_name` varchar(255) DEFAULT NULL,
  `contact_person_number` varchar(255) DEFAULT NULL,
  `address_label` varchar(255) DEFAULT NULL,
  `zone_id` char(36) DEFAULT NULL,
  `is_guest` tinyint(1) NOT NULL DEFAULT 0,
  `house` varchar(255) DEFAULT NULL,
  `floor` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: user_verifications
DROP TABLE IF EXISTS `user_verifications`;
CREATE TABLE `user_verifications` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `identity` varchar(255) NOT NULL,
  `identity_type` varchar(255) NOT NULL,
  `user_id` char(36) DEFAULT NULL,
  `otp` text NOT NULL,
  `expires_at` datetime NOT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `hit_count` tinyint(4) NOT NULL DEFAULT 0,
  `is_temp_blocked` tinyint(1) NOT NULL DEFAULT 0,
  `temp_block_time` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: user_zones
DROP TABLE IF EXISTS `user_zones`;
CREATE TABLE `user_zones` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` char(36) DEFAULT NULL,
  `zone_id` char(36) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: users
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `id` char(36) NOT NULL,
  `first_name` varchar(191) DEFAULT NULL,
  `last_name` varchar(191) DEFAULT NULL,
  `email` varchar(191) DEFAULT NULL,
  `phone` varchar(191) DEFAULT NULL,
  `identification_number` varchar(191) DEFAULT NULL,
  `identification_type` varchar(191) NOT NULL DEFAULT 'nid',
  `identification_image` varchar(255) NOT NULL DEFAULT '[]',
  `date_of_birth` date DEFAULT NULL,
  `gender` varchar(191) NOT NULL DEFAULT 'male',
  `profile_image` varchar(191) NOT NULL DEFAULT 'default.png',
  `fcm_token` varchar(191) DEFAULT NULL,
  `is_phone_verified` tinyint(1) NOT NULL DEFAULT 0,
  `is_email_verified` tinyint(1) NOT NULL DEFAULT 0,
  `phone_verified_at` timestamp NULL DEFAULT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(191) DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 0,
  `user_type` varchar(191) NOT NULL DEFAULT 'customer',
  `remember_token` varchar(100) DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `wallet_balance` decimal(24,3) NOT NULL DEFAULT 0.000,
  `loyalty_point` decimal(24,3) NOT NULL DEFAULT 0.000,
  `ref_code` varchar(50) DEFAULT NULL,
  `referred_by` char(36) DEFAULT NULL,
  `login_hit_count` tinyint(4) NOT NULL DEFAULT 0,
  `is_temp_blocked` tinyint(1) NOT NULL DEFAULT 0,
  `temp_block_time` timestamp NULL DEFAULT NULL,
  `current_language_key` varchar(255) DEFAULT 'en',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: variations
DROP TABLE IF EXISTS `variations`;
CREATE TABLE `variations` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `variant` varchar(191) DEFAULT NULL,
  `variant_key` varchar(191) NOT NULL,
  `service_id` char(36) NOT NULL,
  `zone_id` char(36) NOT NULL,
  `price` decimal(24,3) NOT NULL DEFAULT 0.000,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: visited_services
DROP TABLE IF EXISTS `visited_services`;
CREATE TABLE `visited_services` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` char(36) NOT NULL,
  `service_id` char(36) NOT NULL,
  `count` int(11) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: withdraw_requests
DROP TABLE IF EXISTS `withdraw_requests`;
CREATE TABLE `withdraw_requests` (
  `id` char(36) NOT NULL,
  `user_id` char(36) DEFAULT NULL,
  `request_updated_by` char(36) DEFAULT NULL,
  `amount` decimal(24,2) NOT NULL DEFAULT 0.00,
  `request_status` varchar(255) NOT NULL DEFAULT 'pending',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `is_paid` tinyint(1) NOT NULL DEFAULT 0,
  `note` varchar(255) DEFAULT NULL,
  `admin_note` varchar(255) DEFAULT NULL,
  `withdrawal_method_id` char(36) DEFAULT NULL,
  `withdrawal_method_fields` text DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: withdrawal_methods
DROP TABLE IF EXISTS `withdrawal_methods`;
CREATE TABLE `withdrawal_methods` (
  `id` char(36) NOT NULL,
  `method_name` varchar(255) NOT NULL,
  `method_fields` text NOT NULL,
  `is_default` tinyint(1) NOT NULL DEFAULT 0,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: zones
DROP TABLE IF EXISTS `zones`;
CREATE TABLE `zones` (
  `id` char(36) NOT NULL,
  `name` varchar(255) NOT NULL,
  `coordinates` polygon DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `zones_name_unique` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

SET FOREIGN_KEY_CHECKS=1;
