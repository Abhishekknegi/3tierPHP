<?php
namespace App\Models;

class Product {
    private $db;

    public function __construct() {
        $this->db = Database::getInstance();
    }

    public function getAllProducts() {
        try {
            $query = "SELECT * FROM products LIMIT 10";
            $stmt = $this->db->prepare($query);
            $stmt->execute();
            return $stmt->fetchAll(\PDO::FETCH_ASSOC);
        } catch (\PDOException $e) {
            error_log($e->getMessage());
            throw new \Exception("Database error");
        }
    }
}