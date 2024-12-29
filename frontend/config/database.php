<?php
return [
    'host' => getenv('DB_HOST') ?: 'localhost',
    'database' => getenv('DB_NAME') ?: 'your_database',
    'username' => getenv('DB_USER') ?: 'your_username',
    'password' => getenv('DB_PASS') ?: 'your_password'
];