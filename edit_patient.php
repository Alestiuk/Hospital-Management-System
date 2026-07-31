<?php
session_start();
include 'db.php';

if (!isset($_SESSION['user_id'])) {
    header("Location: login.php");
    exit();
}

$id = $_GET['id'];
$query = mysqli_query($conn, "SELECT * FROM Patient WHERE Patient_ID='$id'");
$patient = mysqli_fetch_assoc($query);

if (isset($_POST['update_patient'])) {
    $name    = mysqli_real_escape_string($conn, $_POST['full_name']);
    $phone   = mysqli_real_escape_string($conn, $_POST['phone_number']);
    $address = mysqli_real_escape_string($conn, $_POST['address']);

    $update_sql = "UPDATE Patient SET Full_Name='$name', Phone_Number='$phone', Address='$address' WHERE Patient_ID='$id'";
    mysqli_query($conn, $update_sql);
    header("Location: patients.php");
}
?>

<!DOCTYPE html>
<html>
<head>
    <title>Edit Patient</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
    <div class="cart-wrapper">
        <h2>Update Patient (ID: <?php echo $patient['Patient_ID']; ?>)</h2>
        <form method="POST">
            <label>Full Name:</label><br>
            <input type="text" name="full_name" value="<?php echo $patient['Full_Name']; ?>" required><br><br>

            <label>Phone Number:</label><br>
            <input type="text" name="phone_number" value="<?php echo $patient['Phone_Number']; ?>" required><br><br>

            <label>Address:</label><br>
            <input type="text" name="address" value="<?php echo $patient['Address']; ?>"><br><br>

            <button type="submit" name="update_patient" class="btn">Update Details</button>
            <br><br>
            <a href="patients.php">Cancel</a>
        </form>
    </div>
</body>
</html>