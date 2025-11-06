UPDATE addon_settings 
SET mode = 'live',
    test_values = JSON_SET(test_values, '$.access_token', 'APP_USR-3044261839967338-110318-6d29d8585eb71369be1503277bd251b8-2952913899'),
    live_values = JSON_SET(live_values, '$.access_token', 'APP_USR-3044261839967338-110318-6d29d8585eb71369be1503277bd251b8-2952913899'),
    is_active = 1,
    updated_at = NOW()
WHERE key_name = 'mercadopago_pix' AND settings_type = 'payment_config';

SELECT 'Token de PRODUÇÃO configurado!' as status;
