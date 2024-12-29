<?php
require_once __DIR__ . '/../vendor/autoload.php';

use App\Controllers\HomeController;
use App\Controllers\ProductController;

// Simple routing
$requestUri = $_SERVER['REQUEST_URI'];

try {
    switch ($requestUri) {
        case '/':
            $controller = new HomeController();
            $controller->index();
            break;
        case '/products':
            $controller = new ProductController();
            $controller->listProducts();
            break;
        default:
            http_response_code(404);
            echo "Page Not Found";
            break;
    }
} catch (Exception $e) {
    // Log error and show user-friendly message
    error_log($e->getMessage());
    http_response_code(500);
    echo "An unexpected error occurred.";
}