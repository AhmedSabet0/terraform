#!/bin/bash

# Install Apache and PHP
yum update -y
yum install -y httpd php
systemctl start httpd 
systemctl enable httpd 

# Configure Apache
cat <<'DESIGN' > /var/www/html/index.php
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ahmed Mahmoud Thabet - Backend System</title>
    <style>
        :root {
            --primary: #3498db;
            --secondary: #2ecc71;
            --dark: #2c3e50;
            --light: #ecf0f1;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            margin: 0;
            padding: 0;
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            color: var(--dark);
        }
        
        .container {
            background: white;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            width: 90%;
            max-width: 800px;
            padding: 40px;
            text-align: center;
            position: relative;
            overflow: hidden;
        }
        
        .container::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 10px;
            background: linear-gradient(90deg, var(--primary), var(--secondary));
        }
        
        h1 {
            color: var(--primary);
            margin-bottom: 10px;
            font-size: 2.5rem;
        }
        
        h2 {
            color: var(--secondary);
            margin-top: 0;
            font-weight: 500;
            font-size: 1.5rem;
            margin-bottom: 30px;
        }
        
        .info-card {
            background: var(--light);
            border-radius: 10px;
            padding: 20px;
            margin: 20px 0;
            text-align: left;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.05);
        }
        
        .info-item {
            margin: 15px 0;
            display: flex;
            align-items: center;
        }
        
        .info-label {
            font-weight: bold;
            min-width: 150px;
            color: var(--dark);
        }
        
        .info-value {
            color: var(--primary);
            word-break: break-all;
        }
        
        .signature {
            margin-top: 30px;
            font-style: italic;
            color: #7f8c8d;
        }
        
        .animation {
            animation: fadeIn 1.5s ease-in-out;
        }
        
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
    </style>
</head>
<body>
    <div class="container animation">
        <h1>Ahmed Mahmoud Thabet</h1>
        <h2>Backend System Information</h2>
        
        <div class="info-card">
            <div class="info-item">
                <span class="info-label">Backend Number:</span>
<span class="info-value">
    <?php 
        $backendNumber = @file_get_contents('/var/www/html/backend_number.txt');
        echo htmlspecialchars(trim($backendNumber ?: 'N/A'));
    ?>
</span>
            </div>
            <div class="info-item">
                <span class="info-label">Backend IP:</span>
                <span class="info-value"><?= $_SERVER['SERVER_ADDR'] ?? 'N/A' ?></span>
            </div>
            <div class="info-item">
                <span class="info-label">Client IP:</span>
                <span class="info-value"><?php 
                    $clientIP = $_SERVER['HTTP_X_FORWARDED_FOR'] ?? $_SERVER['REMOTE_ADDR'] ?? 'N/A';
                    $ips = explode(',', $clientIP);
                    echo trim(end($ips)); // Get the last IP in the chain
                ?></span>
            </div>
            <div class="info-item">
                <span class="info-label">Request Time:</span>
                <span class="info-value"><?= date('Y-m-d H:i:s') ?></span>
            </div>
        </div>
        
        <p class="signature">System designed and implemented by Ahmed Mahmoud Thabet</p>
    </div>
</body>
</html>
DESIGN

   echo "${backend_number}" > /var/www/html/backend_number.txt

# Health check page
echo "OK" > /var/www/html/health.html

# Set permissions

# Start Apache
systemctl enable --now httpd
