<?php
namespace App\Controllers;

class HomeController {
    public function index() {
        $data = [
            'title' => 'Welcome to Our Application',
            'message' => 'This is a modern PHP application'
        ];
        require_once __DIR__ . '/../Views/layout.php';
        require_once __DIR__ . '/../Views/home.php';
    }
}