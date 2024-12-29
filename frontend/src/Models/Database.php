<?php
namespace App\Models;

class Database {
    private static $instance = null;
    private $connection;

    private function __construct() {
        $config = require_once __DIR__ . '/../../config/database.php';
        
        try {
            $this->connection = new \PDO(
                "pgsql:host={$config['host']};dbname={$config['database']}",
                $config['username'],
                $config['password']
            );
            $this->connection->setAttribute(\PDO::ATTR_ERRMODE, \PDO::ERRMODE_EXCEPTION);
        } catch (\PDOException $e) {
            error_log($e->getMessage());
            throw new \Exception("Database connection failed");
        }
    }

    public static function getInstance() {
        if (self::$instance === null) {
            self::$instance = new self();
        }
        return self::$instance->connection;
    }
}