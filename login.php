<?php
session_start();
include 'db.php';

if (isset($_POST['login'])) {
    $email = mysqli_real_escape_string($conn, $_POST['email']);
    $password = $_POST['password'];

    $sql = "SELECT * FROM users WHERE email='$email'";
    $result = mysqli_query($conn, $sql);

    if (mysqli_num_rows($result) == 1) {
        $user = mysqli_fetch_assoc($result);
        if (password_verify($password, $user['password'])) {
            $_SESSION['user_id'] = $user['id'];
            $_SESSION['username'] = $user['fullname'];
            header("Location: patients.php");
            exit();
        }
    }
    $error = "Invalid email or password!";
}
?>

<!DOCTYPE html>
<html>
<head>
    <title>Login - Hospital Management System</title>
    <link rel="stylesheet" href="loginstyle.css">
</head>
<body>
    <div class="top-bar">Hospital Management System</div>
    <div class="login-container">
        <div class="login-box">
            <h2>Sign in to your account</h2>
            <p>Please enter your email and password to log in.</p>
            <?php if (isset($error)) echo "<div class='error'>$error</div>"; ?>
            <form method="POST">
                <input type="email" name="email" placeholder="Enter your email" required>
                <input type="password" name="password" placeholder="Password" required>
                <button type="submit" name="login">Login ➜</button>
            </form>
            <p style="text-align:center; margin-top:15px;">
                Don't have an account? <a href="register.php">Register</a>
            </p>
        </div>
    </div>
</body>
</html>