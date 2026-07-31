<?php
include 'db.php';

if (isset($_POST['register'])) {
    $fullname = mysqli_real_escape_string($conn, $_POST['fullname']);
    $email = mysqli_real_escape_string($conn, $_POST['email']);
    $password = password_hash($_POST['password'], PASSWORD_DEFAULT);

    $sql = "INSERT INTO users (fullname, email, password) VALUES ('$fullname', '$email', '$password')";

    if (mysqli_query($conn, $sql)) {
        header("Location: login.php");
        exit();
    } else {
        $error = "Registration failed: " . mysqli_error($conn);
    }
}
?>

<!DOCTYPE html>
<html>
<head>
    <title>Register - Hospital Management System</title>
    <link rel="stylesheet" href="registerstyle.css">
</head>
<body>
    <div class="top-bar"><h1>Hospital Management System</h1></div>
    <div class="auth-container">
        <div class="auth-box">
            <h2>Create an Account</h2>
            <p>Please fill in details to register</p>
            <?php if (isset($error)) echo "<p style='color:red;'>$error</p>"; ?>
            <form method="POST">
                <input type="text" name="fullname" placeholder="Full Name" required>
                <input type="email" name="email" placeholder="Email Address" required>
                <input type="password" name="password" placeholder="Password" required>
                <button type="submit" name="register">Register →</button>
            </form>
            <p class="bottom-text">Already have an account? <a href="login.php">Login</a></p>
        </div>
    </div>
</body>
</html>