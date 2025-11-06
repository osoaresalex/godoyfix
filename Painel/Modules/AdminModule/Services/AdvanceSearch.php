<?php

namespace Modules\AdminModule\Services;

use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\Cache;
use Illuminate\Support\Facades\File;
use Modules\AdminModule\Traits\AdminMenuWithRoutes;
use Modules\AdminModule\Traits\AdminModelWithRoutes;
use Modules\AdminModule\Traits\ProviderModelWithRoutes;
use Modules\AdminModule\Traits\ProviderMenuWithRoutes;
use stdClass;


class AdvanceSearch
{
    use ProviderModelWithRoutes;
    use ProviderMenuWithRoutes;
    use AdminMenuWithRoutes;
    use AdminModelWithRoutes;
    public function getCacheTimeoutByDays(int $days = 3): int
    {
        return 60 * 60 * 24 * $days;
    }

    public function getModelPrefix(): string
    {
        return 'advanced_search_';
    }

    public function searchModelList($keyword , $type): JsonResponse|array
    {
        $result = [];
        if($type == "admin"){
            $models = $this->getAdminModels();
        }else{
            $models = $this->getProviderModels();
        }

        if (!empty($keyword)) {
            $keyword = strtolower($keyword);

            if (!empty($models)) {
                foreach ($models as $key => $table) {
                    $cache_key = $this->getModelPrefix() . $table['model'];
                    $allItems = Cache::remember(
                        $cache_key,
                        $this->getCacheTimeoutByDays(days: 2),
                        function () use ($table) {
                            $query = $table['model']::withoutGlobalScopes()
                            ->select($table['column']);
                            if (!empty($table['relations']) && is_array($table['relations'])) {
                                $query->with(array_keys($table['relations']));
                            }
                            return $query->get();
                        }

                    );
                    $filteredItems = $allItems->filter(function ($item) use ($keyword, $table) {
                        foreach ($table['column'] as $column) {
                            $value = strtolower((string)($item->{$column} ?? ''));
                            if (preg_match('/(?<![a-zA-Z0-9])' . preg_quote($keyword, '/') . '(?![a-zA-Z0-9])/i', $value)) {
                                return true;
                            }
                        }
                        if (in_array('first_name', $table['column']) && in_array('last_name', $table['column'])) {
                            $fullName = strtolower(trim(($item->first_name ?? '') . ' ' . ($item->last_name ?? '')));
                            if (preg_match('/' . preg_quote(strtolower($keyword), '/') . '/', $fullName)) {
                                return true;
                            }
                        }
                        if (!empty($table['relations'])) {
                            foreach ($table['relations'] as $relationName => $relationData) {
                                $relatedItems = $item->{$relationName} ?? null;

                                if ($relatedItems) {
                                    // hasMany
                                    if ($relatedItems instanceof \Illuminate\Support\Collection) {
                                        foreach ($relatedItems as $relatedItem) {
                                            foreach ($relationData['columns'] as $relColumn) {
                                                $relValue = strtolower((string)($relatedItem->{$relColumn} ?? ''));
                                                if (preg_match('/(?<![a-zA-Z0-9])' . preg_quote($keyword, '/') . '(?![a-zA-Z0-9])/i', $relValue)) {
                                                    return true;
                                                }
                                            }
                                        }
                                    } else {
                                        // hasOne / belongsTo
                                        foreach ($relationData['columns'] as $relColumn) {
                                            $relValue = strtolower((string)($relatedItems->{$relColumn} ?? ''));
                                            if (preg_match('/(?<![a-zA-Z0-9])' . preg_quote($keyword, '/') . '(?![a-zA-Z0-9])/i', $relValue)) {
                                                return true;
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        return false;
                    });

                    if ($filteredItems->count() > 0) {
                        foreach ($filteredItems as $item) {
                            foreach ($table['routes'] as $route) {
                                $finalRoute = $route;
                                $pageTitle  = $item->name ?? ucfirst($this->getRouteName($route));
                                $finalUrl   = $finalRoute;
                                switch ($key) {
                                    case "users":
                                        $pageTitle = $item->first_name . ' ' . $item->last_name;
                                        if ($item->user_type == "admin-employee") {
                                            if (strpos($finalRoute, '/edit/') !== false) {
                                                $finalRoute = str_replace('customer', 'employee', $finalRoute);
                                            }
                                        }
                                        if ($finalRoute === 'admin/employee/list' && $item->user_type !== "admin-employee") {
                                            continue 2;
                                        }
                                        $detailRoute = "admin/customer/detail/{id}?web_page=overview";
                                        if($finalRoute == $detailRoute){
                                           if(strpos($finalRoute, '{id}') !== false){
                                                $finalRoute = str_replace('{id}', $item->id, $finalRoute);
                                            };
                                        }
                                        $finalUrl = $finalRoute;
                                        break;
                                    case "faqs":
                                        $finalRoute = str_replace('{id}', $item->service_id, $finalRoute);
                                        $finalUrl = $finalRoute;
                                        $pageTitle = $item->question ?? 'Service Detail';
                                        break;
                                    case "providers":
                                        $providerRoute = "admin/provider/details/{id}?web_page=overview&provider={id}";
                                        if ($route == $providerRoute) {
                                            if (strpos($route, '{id}') !== false) {
                                                $finalRoute = str_replace('{id}', $item->id, $providerRoute);
                                            }
                                        }
                                        $pageTitle = $item->company_name;
                                        break;
                                    case "services":
                                    case "categories":
                                        $pageTitle = $item->name;
                                        break;
                                    case "advertisements":
                                        $pageTitle = $item->title;
                                        $url = '';
                                        $validStatuses = ['pending','approved','running','expired','denied','paused'];

                                        if (!empty($item->status) && in_array($item->status, $validStatuses)) {
                                            $url = 'status=' . $item->status;
                                        } else {
                                            $url = 'status=all';
                                        }
                                        $finalUrl = $route . '?' . $url;
                                        break;
                                    case "discounts":
                                        $pageTitle = $item->discount_title;
                                        break;

                                    case "bonuses":
                                        $pageTitle = $item->bonus_title;
                                        break;
                                    case "campaigns":
                                        $pageTitle = $item->campaign_name;
                                        break;
                                    case "banners":
                                        $pageTitle = $item->banner_title;
                                        break;
                                    case "subscribe_newsletters":
                                        $pageTitle = $item->email;
                                        break;

                                    case "coupons":
                                        $pageTitle = $item->coupon_code;
                                        break;
                                    case "transactions":
                                        $pageTitle = "Transaction";
                                        if ($item->debit != 0) {
                                            $url = 'transaction_type=debit';
                                        } elseif ($item->credit != 0) {
                                            $url = 'transaction_type=credit';
                                        } else {
                                            $url = 'transaction_type=all';
                                        }
                                        $finalUrl = $route . '?' . $url;
                                        break;

                                }

                                if ($key !== "faqs" && strpos($route, '{id}') !== false && isset($item->id)) {
                                    $finalRoute = str_replace('{id}', (string)$item->id, $route);
                                    if ($finalUrl === $route) {
                                        $finalUrl = $finalRoute;
                                    } else {
                                        $finalUrl = str_replace('{id}', (string)$item->id, $finalUrl);
                                    }
                                }

                                $itemId = $item->id ?? '';

                                if ($key === "bookings") {
                                    $url = '';
                                    if (!empty($item->booking_status)) {
                                        $url .= 'booking_status=' . $item->booking_status;
                                    }
                                    if (isset($item->is_repeated)) {
                                        if ($item->is_repeated == 1) {
                                            $url .= ($url ? '&' : '') . 'service_type=repeat';
                                        } elseif ($item->is_repeated == 0) {
                                            $url .= ($url ? '&' : '') . 'service_type=regular';
                                        }
                                    }
                                    $pageTitle = "Booking - #" . ($item->readable_id ?? $itemId);
                                    $finalUrl  = !empty($url) ? $route . '?' . $url : $route;
                                    if($route == "admin/booking/details/{id}?web_page=details"){
                                        $route = "admin/booking/details/{id}?web_page=details";
                                        $finalUrl = str_replace('{id}', (string)$item->id, $route);
                                    }
                                }

                                $result[] = [
                                    "page_title"       => $pageTitle ?? "Unknown",
                                    "page_title_value" => $pageTitle ?? "Unknown",
                                    "full_route"       => url($finalUrl),
                                    "key"              => base64_encode("dbsearch" . $route . $itemId),
                                    "uri"              => $finalUrl,
                                    "uri_count"        => count(explode('/', $finalUrl)),
                                    "method"           => "GET",
                                    "keywords"         => $keyword,
                                    "type"             => $key,
                                    "priority"         => 3
                                ];

                                if (!empty($table['relations'])) {
                                    foreach ($table['relations'] as $relationName => $relationData) {
                                        $relatedData = $item->{$relationName} ?? null;

                                        if ($relatedData) {
                                            $relatedData = is_array($relatedData) || $relatedData instanceof \Illuminate\Support\Collection
                                                ? collect($relatedData)
                                                : collect([$relatedData]);

                                            $relationRoutes = $relationData['admin_routes'] ?? [];

                                            foreach ($relatedData as $relatedItem) {
                                                foreach ($relationRoutes as $relRoute => $label) {
                                                    if (strpos($relRoute, '{id}') !== false && isset($relatedItem->id)) {
                                                        $finalRelRoute = str_replace('{id}', (string)$relatedItem->id, $relRoute);
                                                    } else {
                                                        $finalRelRoute = $relRoute;
                                                    }

                                                    $relatedId = $relatedItem->id ?? '';

                                                    $result[] = [
                                                        "page_title"       => ucfirst($label) ?? "Unknown",
                                                        "page_title_value" => ucfirst($label) ?? "Unknown",
                                                        "uri"              => $finalRelRoute,
                                                        "key"              => base64_encode("dbsearch" . $relRoute . $relatedId),
                                                        "uri_count"        => count(explode('/', $finalRelRoute)),
                                                        "full_route"       => url($finalRelRoute),
                                                        "method"           => "GET",
                                                        "keywords"         => $keyword,
                                                        "type"             => $key,
                                                        "priority"         => 3
                                                    ];
                                                }
                                            }
                                        }
                                    }
                                }
                            }


                        }
                    }
                }
            } else {
                return response()->json(['error' => 'Access type not found'], 500);
            }
        }
        return collect($result)->unique('uri')->values()->all();

    }
    function formatRouteTitle($route) {
        // Remove {id} placeholders
        $route = preg_replace('/\{id\}/', '', $route);

        // Parse URL (this will split query string cleanly)
        $parts = parse_url($route);

        // Get path segments
        $pathSegments = explode('/', $parts['path'] ?? '');

        // Last meaningful segment (like "detail")
        $base = ucfirst(end($pathSegments));

        // If query params exist, format them nicely
        $title = $base;
        if (isset($parts['query'])) {
            parse_str($parts['query'], $query);
            foreach ($query as $key => $value) {
                $title .= " - " . ucfirst(str_replace('_', ' ', $value));
            }
        }

        return trim($title);
    }

    private function getRouteName($actualRouteName)
    {
        $actualRouteName = preg_replace('/\{[^}]+\}/', '', $actualRouteName);
        $routeNameParts = explode('/', $actualRouteName);
        if (count($routeNameParts) >= 2) {
            $lastPart = $routeNameParts[count($routeNameParts) - 1];
            $secondLastPart = $routeNameParts[count($routeNameParts) - 2];

            if (strtolower($lastPart) === 'index') {
                $lastPart = 'List';
            }

            $lastPartWords = explode(' ', str_replace(['_', '-'], ' ', $lastPart));
            $secondLastPartWords = explode(' ', str_replace(['_', '-'], ' ', $secondLastPart));
            $allWords = array_merge($secondLastPartWords, $lastPartWords);
            $uniqueWords = [];

            foreach ($allWords as $word) {
                $lowerWord = strtolower($word);
                if (empty($uniqueWords) || strtolower(end($uniqueWords)) !== $lowerWord) {
                    $uniqueWords[] = $word;
                }
            }

            if (count($uniqueWords) > 1 && strtolower($uniqueWords[0]) === strtolower(end($uniqueWords))) {
                array_shift($uniqueWords);
            }

            $uniqueWords = array_filter($uniqueWords, function ($word) {
                return strtolower($word) !== 'rental';
            });

            $routeName = $this->formatRouteTitle(ucwords(implode(' ', $uniqueWords))) ;

        } else {
            $routeName = $this->formatRouteTitle(ucwords(str_replace(['.', '_', '-'], ' ', Str::afterLast($actualRouteName, '.'))));
        }
        return $routeName;
    }

    public function searchMenuList($searchKeyword, $type): array
    {
        if($type == "admin"){
            $result = $this->adminMenuWithRoutes();
        }else{
            $result = $this->providerMenuWithRoutes();
        }
        $translatedMenus = [];
        $defaultLang = session()->has('local') ? session('local') : 'en';
        if ($defaultLang != 'en') {
            $allMessages = include(base_path('resources/lang/' . $defaultLang . '/lang.php'));

            $allMessageKeys = [];
            foreach ($allMessages as $key => $value) {
                if (str_contains(strtolower((string)$value), $searchKeyword)) {
                    $allMessageKeys[] = strtolower($key);
                }
            }

            $translatedMenus = collect($result)->filter(function ($item) use ($searchKeyword, $allMessageKeys) {
                $value = strtolower((string)($item['page_title'] ?? ''));
                return in_array($value, $allMessageKeys);
            })
                ->unique('uri')
                ->values()
                ->map(function ($item) {
                    return [
                        'page_title' => ucwords($item['page_title'] ?? ''),
                        'page_title_value' => $item['page_title_value'] ?? '',
                        'uri' => $item['uri'] ?? '',
                        'full_route' => $item['full_route'] ?? '',
                        'type' => $item['type'] ?? '',
                        'priority' =>$item['priority'] ?? 1,
                    ];
                })
                ->toArray();
        }
        $getRawValues = collect($result)
            ->filter(function ($item) use ($searchKeyword) {
                $pageTitleValue = strtolower($this->removeUnderscore($item['page_title_value'] ?? ''));
                $keywords  = strtolower($item['keywords'] ?? '');
                $search    = strtolower(trim($searchKeyword));
                if ($pageTitleValue === $search || str_contains($pageTitleValue, $search)) {
                    return true;
                }
                $keywordList = array_map('trim', explode(',', $keywords));
                foreach ($keywordList as $key) {
                    if ($key === $search || str_contains($key, $search)) {
                        return true;
                    }
                }
                return false;
            })
            ->unique('uri')
            ->values()
            ->map(function ($item) {
                return [
                    'page_title' => ucwords($item['page_title'] ?? ''),
                    'page_title_value' => $item['page_title_value'] ?? '',
                    'uri' => $item['uri'] ?? '',
                    'full_route' => $item['full_route'] ?? '',
                    'type' => $item['type'] ?? '',
                    'priority' =>$item['priority'] ?? 1,
                ];
            })
            ->toArray();
        return collect(array_merge($translatedMenus, $getRawValues))
            ->map(function ($item) {
                $item['page_title_value'] = translate($item['page_title_value']);
                return $item;
            })
            ->unique('uri')
            ->values()
            ->toArray();
    }

    public function pageSearchList($keyword, $type): JsonResponse|array
    {

        $skipRouts = ['admin/configuration/get-third-party-config','admin/configuration/get-email-config'];
        $defaultLang = session()->has('local') ? session('local') : 'en';
        $keyword = strtolower($keyword);

        if ($type == "admin") {
            $langPath = public_path("json/admin/lang/{$defaultLang}.json");
            $engPath  = public_path("json/admin/lang/en.json");
            $formattedRoutesPath = public_path('json/admin/admin_formatted_routes.json');
        } else {
            $langPath = public_path("json/provider/lang/{$defaultLang}.json");
            $engPath  = public_path("json/provider/lang/en.json");
            $formattedRoutesPath = public_path('json/provider/provider_formatted_routes.json');
        }

        if (!File::exists($langPath)) {
            if (!file_exists(dirname($langPath))) {
                File::makeDirectory(dirname($langPath), 0777, true, true);
            }

            if (file_exists($engPath)) {
                $content = file_get_contents($engPath);
                file_put_contents($langPath, $content);
            } else {
                file_put_contents($langPath, json_encode(new stdClass(), JSON_PRETTY_PRINT));
            }
        }

        $langData     = json_decode(File::get($langPath), true);
        $routesData   = json_decode(File::get($formattedRoutesPath), true);

        if (json_last_error() !== JSON_ERROR_NONE) {
            return response()->json(['error' => 'Invalid JSON in routes.json'], 500);
        }
        $matchedRoutes = [];

        foreach ($langData as $key => $route) {
            if (empty($route['keywords'])) {
                continue;
            }
            $title = $this->formatTitle($route['page_title_value']);
            if ($title == $keyword) {
                $matchedRoutes[] = $route['key'];
            } elseif (preg_match('/' . preg_quote($keyword, '/') . '/i', $title)) {
                $matchedRoutes[] = $route['key'];
            } else {
                foreach ($route['keywords'] as $value) {
                    $normalizedValue = strtolower(trim($value));
                    if (strpos($normalizedValue, $keyword) !== false) {
                        $matchedRoutes[] = $route['key'];
                        break;
                    }
                }
            }
        }

        $matchedRoutes = array_unique($matchedRoutes);

        $finalMatchedRoutes = [];
        foreach ($routesData as $route) {
            if (in_array($route['key'], $matchedRoutes) && !in_array($route['uri'], $skipRouts)) {
                $finalMatchedRoutes[] = [
                    "page_title"       => translate($route['page_title'] ?? 'Unknown'),
                    "page_title_value" => translate($route['page_title'] ?? 'Unknown'),
                    "key"              => $route['key'] ?? base64_encode("page_search_" . ($route['uri'] ?? '')),
                    "uri"              => $route['uri'] ?? '',
                    "full_route"       => url($route['uri'] ?? ''),
                    "uri_count"        => isset($route['uri']) ? count(explode('/', $route['uri'])) : 0,
                    "method"           => $route['method'] ?? "GET",
                    "keywords"         => $keyword,
                    "priority"         => 2,
                    "type"             => 'page',
                ];
            }
        }

        return $finalMatchedRoutes;
    }

    function formatTitle($input): string
    {
        $withSpaces = str_replace('_', ' ', $input);
        return strtolower(ucwords($withSpaces));
    }
    public function sortByPriority($formattedRoutes, $validRoutes, $menuSearchResults, $searchKeyword): mixed
    {
        $allRoutes = collect(array_merge($formattedRoutes, $validRoutes, $menuSearchResults))
            ->map(function ($item) use ($searchKeyword) {
                $score = 0;
                if (isset($item['page_title_value']) && str_contains(strtolower($item['page_title_value']), strtolower($searchKeyword))) {
                    $score += 1;
                }
                $item['match_score'] = $score;
                return $item;
            });
        $sorted = $allRoutes->sort(function ($a, $b) {
            $aPriority = $a['priority'] ?? 0;
            $bPriority = $b['priority'] ?? 0;

            if ($a['match_score'] === $b['match_score']) {
                return $aPriority <=> $bPriority;
            }
            return $b['match_score'] <=> $a['match_score'];
        })->values();
        return  $this->groupByType($sorted);
    }

    public function groupByType($sorted)
    {
        return $sorted->groupBy('type')->map(function ($items) {
            return $items->unique('uri')->values();
        })->toArray();
    }


    public function getSortRecentSearchByType(object|array $searchData): array
    {
        $fallbackResults = collect();

        foreach ($searchData as $search) {
            $response = is_string($search['response'])
                ? json_decode($search['response'], true)
                : $search['response'];

            if (is_array($response) && isset($response['priority'])) {
                $fallbackResults->push($response);
            }
        }
        $fallbackResults = $fallbackResults->sortBy('priority')->values();

        return $fallbackResults->groupBy('type')->toArray();
    }

    public function removeUnderscore($input)
    {
        if (strpos($input, '_') !== false) {
            return str_replace('_', ' ', $input);
        }
        return $input;
    }
}
