<?php

namespace Modules\AdminModule\Traits;

trait ProviderModelWithRoutes
{
    public function getProviderModels(): array
    {
        return [
            'providers' => [
                'model' => 'Modules\ProviderManagement\Entities\Provider',
                'translationable_type' => 'Modules\ProviderManagement\Entities\Provider',
                'type' => 'providers',
                'column' => ['id', 'company_name', 'company_phone', 'company_address', 'company_email'],
                'routes' => ['provider/provider/details/{id}','provider/provider/edit/{id}'],
                'access_type' => ['admin', 'vendor'],
                'relations' => [
                    'owner' => [
                        'columns' => ['id', 'first_name', 'last_name', 'email', 'phone'],
                        'admin_routes' => [
                            'provider/provider/details/{id}' => 'provider_details',
                        ],
                    ]
                ]
            ],
            'users' => [
                'model' => 'Modules\UserManagement\Entities\User',
                'translationable_type' => 'Modules\UserManagement\Entities\User',
                'type' => 'users',
                'column' => ['id', 'first_name', 'last_name','phone','email'],
                'routes' => ['provider/analytics/search/customer'],
                'access_type' => ['admin', 'vendor']
            ],
            'bookings' => [
                'model' => 'Modules\BookingModule\Entities\Booking',
                'translationable_type' => 'Modules\BookingModule\Entities\Booking',
                'type' => 'bookings',
                'column' => ['id', 'readable_id','booking_status','is_repeated'],
                'routes' => [
                    'provider/booking/list/',
                    'provider/booking/list/verification',
                ],
                'relations' => [
                    'customer' => [
                        'columns' => ['id', 'first_name', 'last_name', 'email', 'phone'],
                        'admin_routes' => [
                            'provider/booking/post?type=all' => 'Customized_Booking_Requests',
                        ],
                    ],
                    'provider' => [
                        'columns' => ['id', 'company_name', 'company_phone', 'company_email'],
                        'admin_routes' => [
                            'provider/booking/post?type=all' => 'Customized_Booking_Requests',
                        ],
                    ]
                ],
                'access_type' => ['admin', 'vendor']
            ],
            'services' => [
                'model' => 'Modules\ServiceManagement\Entities\Service',
                'translationable_type' => 'Modules\ServiceManagement\Entities\Service',
                'type' => 'services',
                'column' => ['id', 'name'],
                'routes' => ['provider/service/available'],
                'relations' => [
                    'category' => [
                        'columns' => ['id', 'parent_id', 'name'],
                        'admin_routes' => [
                            'provider/service/available' => 'Available_Services',
                        ],
                    ]
                ],
                'access_type' => ['admin', 'vendor']
            ],
            'advertisements' => [
                'model' => 'Modules\PromotionManagement\Entities\Advertisement',
                'translationable_type' => 'Modules\PromotionManagement\Entities\Advertisement',
                'type' => 'advertisements',
                'column' => ['id', 'readable_id', 'title','status'],
                'routes' => ['provider/advertisements/ads-list'],
                'access_type' => ['admin', 'vendor'],

            ],
            'coupons' => [
                'model' => 'Modules\PromotionManagement\Entities\Coupon',
                'translationable_type' => 'Modules\PromotionManagement\Entities\Coupon',
                'type' => 'coupons',
                'column' => ['id', 'coupon_code'],
                'routes' => ['provider/coupon/list', 'provider/coupon/edit/{id}'],
                'access_type' => ['admin', 'vendor'],
            ],
            'discounts' => [
                'model' => 'Modules\PromotionManagement\Entities\Discount',
                'translationable_type' => 'Modules\PromotionManagement\Entities\Discount',
                'type' => 'discounts',
                'column' => ['id', 'discount_title'],
                'routes' => ['provider/discount/list'],
                'access_type' => ['admin', 'vendor']
            ],
            'bonuses' => [
                'model' => 'Modules\PaymentModule\Entities\Bonus',
                'translationable_type' => 'Modules\PaymentModule\Entities\Bonus',
                'type' => 'bonuses',
                'column' => ['id', 'bonus_title'],
                'routes' => ['provider/bonus/list'],
                'access_type' => ['admin', 'vendor'],
            ],
            'campaigns' => [
                'model' => 'Modules\PromotionManagement\Entities\Campaign',
                'translationable_type' => 'Modules\PromotionManagement\Entities\Campaign',
                'type' => 'campaigns',
                'column' => ['id', 'campaign_name'],
                'routes' => ['provider/campaign/list', 'provider/campaign/edit/{id}'],
                'access_type' => ['admin', 'vendor'],
            ],
            'banners' => [
                'model' => 'Modules\PromotionManagement\Entities\Banner',
                'translationable_type' => 'Modules\PromotionManagement\Entities\Banner',
                'type' => 'banners',
                'column' => ['id', 'banner_title'],
                'routes' => ['provider/banner/create','provider/banner/edit/{id}'],
                'access_type' => ['admin', 'vendor'],
            ],
            'categories' => [
                'model' => 'Modules\CategoryManagement\Entities\Category',
                'translationable_type' => 'Modules\CategoryManagement\Entities\Category',
                'type' => 'categories',
                'column' => ['id', 'name'],
                'routes' => ['provider/sub-category/subscribed?status=all'],
                'access_type' => ['admin', 'vendor'],
            ],
            'transactions' => [
                'model' => 'Modules\TransactionModule\Entities\Transaction',
                'translationable_type' => 'Modules\TransactionModule\Entities\Transaction',
                'type' => 'categories',
                'column' => ['id', 'ref_trx_id','debit','credit'],
                'routes' => ['provider/report/transaction'],
                'access_type' => ['admin', 'vendor'],
            ],
            'subscribe_newsletters' => [
                'model' => 'Modules\CustomerModule\Entities\SubscribeNewsletter',
                'translationable_type' => 'Modules\CustomerModule\Entities\SubscribeNewsletter',
                'type' => 'subscribe_newsletters',
                'column' => ['id', 'email'],
                'routes' => ['provider/customer/newsletter/list'],
                'access_type' => ['admin', 'vendor'],
            ],
        ];
    }
}
