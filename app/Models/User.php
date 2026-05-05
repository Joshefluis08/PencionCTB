<?php
namespace App\Models;

use App\Core\Database;
use PDO;

class User
{
    protected $db;

    public function __construct()
    {
        $this->db = (new Database())->getPdo();
    }

    public function all()
    {
        $stmt = $this->db->query("SELECT * FROM usuarios");
        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }
}
