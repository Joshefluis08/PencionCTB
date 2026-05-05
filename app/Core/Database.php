<?php
namespace App\Core;

use PDO;
use PDOException;

class Database
{
    protected $pdo;

    public function __construct()
    {
        $config = require dirname(__DIR__, 2) . '/app/config/database.php';
        try {
            $this->pdo = new PDO(
                "mysql:host={$config['host']};dbname={$config['database']};charset={$config['charset']}",
                $config['username'],
                $config['password']
            );
            $this->pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
        } catch (PDOException $e) {
            exit('Error BD: ' . $e->getMessage());
        }
    }

    public function getPdo()
    {
        return $this->pdo;
    }
}
