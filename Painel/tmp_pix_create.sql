INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password`, `user_type`, `is_active`, `created_at`, `updated_at`) 
VALUES (UUID(), 'Test', 'PIX', 'pixtest@example.com', '+5511999999999', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'customer', 1, NOW(), NOW())
ON DUPLICATE KEY UPDATE email=email;

SET @user_id = (SELECT id FROM users WHERE email = 'pixtest@example.com' LIMIT 1);

INSERT INTO `payment_requests` 
(`id`, `payer_id`, `payment_amount`, `currency_code`, `payment_method`, `additional_data`, `is_paid`, `payer_information`, `external_redirect_link`, `receiver_information`, `attribute_id`, `attribute`, `payment_platform`, `created_at`, `updated_at`)
VALUES 
(UUID(), @user_id, 1.00, 'BRL', 'mercadopago_pix', NULL, 0, '{"name":"Test PIX","email":"pixtest@example.com","phone":"+5511999999999"}', NULL, NULL, UUID(), 'booking', NULL, NOW(), NOW());

SELECT 
    CONCAT('https://32da65970cc6.ngrok-free.app/payment/mercadopago_pix/pay?payment_id=', id) as payment_url,
    id as payment_id,
    payment_amount,
    is_paid
FROM payment_requests 
WHERE payer_id = @user_id 
ORDER BY created_at DESC 
LIMIT 1;
