<?php
namespace App\Controllers;

use App\Models\Product;

class ProductController {
    private $productModel;

    public function __construct() {
        $this->productModel = new Product();
    }

    public function listProducts() {
        try {
            $products = $this->productModel->getAllProducts();
            
            $data = [
                'title' => 'Our Products',
                'products' => $products
            ];

            require_once __DIR__ . '/../Views/layout.php';
            require_once __DIR__ . '/../Views/products.php';
        } catch (\Exception $e) {
            // Handle error
            error_log($e->getMessage());
            http_response_code(500);
            echo "Error fetching products";
        }
    }
}