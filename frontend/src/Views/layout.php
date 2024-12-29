<!DOCTYPE html>
<html>
<head>
    <title><?= htmlspecialchars($data['title']) ?></title>
    <link rel="stylesheet" href="/assets/css/style.css">
</head>
<body>
    <header>
        <!-- Navigation -->
    </header>
    <main>
        <?php include func_get_arg(1); ?>
    </main>
    <footer>
        <!-- Footer content -->
    </footer>
</body>
</html>