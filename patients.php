<?php
session_start();
include 'db.php';

if (!isset($_SESSION['user_id'])) {
    header("Location: login.php");
    exit();
}

// CREATE
if (isset($_POST['add_patient'])) {
    $pid       = mysqli_real_escape_string($conn, $_POST['patient_id']);
    $name      = mysqli_real_escape_string($conn, $_POST['full_name']);
    $gender    = $_POST['gender'];
    $dob       = $_POST['date_of_birth'];
    $blood     = $_POST['blood_group'];
    $address   = mysqli_real_escape_string($conn, $_POST['address']);
    $phone     = mysqli_real_escape_string($conn, $_POST['phone_number']);
    $emergency = mysqli_real_escape_string($conn, $_POST['emergency_contact']);
    $reg_date  = $_POST['registration_date'];

    $sql = "INSERT INTO Patient (Patient_ID, Full_Name, Gender, Date_Of_Birth, Blood_Group, Address, Phone_Number, Emergency_Contact, Registration_Date)
            VALUES ('$pid', '$name', '$gender', '$dob', '$blood', '$address', '$phone', '$emergency', '$reg_date')";
    mysqli_query($conn, $sql);
    header("Location: patients.php");
}

// DELETE
if (isset($_GET['delete'])) {
    $id = $_GET['delete'];
    mysqli_query($conn, "DELETE FROM Patient WHERE Patient_ID='$id'");
    header("Location: patients.php");
}

// READ
$patients_result = mysqli_query($conn, "SELECT * FROM Patient");
?>

<!DOCTYPE html>
<html>
<head>
    <title>Patient Management</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>

<div class="navbar">
    <div class="logo">Hospital Management System</div>
    <ul class="menu">
        <li style="color:white; font-weight:bold;">Hi, <?php echo $_SESSION['username']; ?></li>
        <li><a href="patients.php">Patients</a></li>
        <li><a href="logout.php">Logout</a></li>
    </ul>
</div>

<h1 class="page-title">PATIENT DIRECTORY & RECORDS</h1>

<div class="cart-wrapper">
    <h3>Add New Patient (CREATE)</h3>
    <form method="POST" style="margin-bottom:30px;">
        <input type="number" name="patient_id" placeholder="Patient ID" required>
        <input type="text" name="full_name" placeholder="Full Name" required>
        <select name="gender">
            <option value="Male">Male</option>
            <option value="Female">Female</option>
            <option value="Other">Other</option>
        </select>
        <input type="date" name="date_of_birth" required>
        <input type="text" name="blood_group" placeholder="Blood Group">
        <input type="text" name="address" placeholder="Address">
        <input type="text" name="phone_number" placeholder="Phone Number" required>
        <input type="text" name="emergency_contact" placeholder="Emergency Contact">
        <input type="date" name="registration_date" required>
        <br><br>
        <button type="submit" name="add_patient" class="btn">Add Patient Record</button>
    </form>

    <h3>Patient Records (READ)</h3>
    <table class="cart-table">
        <tr>
            <th>ID</th>
            <th>Name</th>
            <th>Gender</th>
            <th>DOB</th>
            <th>Blood Group</th>
            <th>Phone</th>
            <th>Reg. Date</th>
            <th>Actions</th>
        </tr>
        <?php while ($row = mysqli_fetch_assoc($patients_result)) { ?>
        <tr>
            <td><?php echo $row['Patient_ID']; ?></td>
            <td><?php echo $row['Full_Name']; ?></td>
            <td><?php echo $row['Gender']; ?></td>
            <td><?php echo $row['Date_Of_Birth']; ?></td>
            <td><?php echo $row['Blood_Group']; ?></td>
            <td><?php echo $row['Phone_Number']; ?></td>
            <td><?php echo $row['Registration_Date']; ?></td>
            <td>
                <a href="edit_patient.php?id=<?php echo $row['Patient_ID']; ?>">Edit</a> | 
                <a href="patients.php?delete=<?php echo $row['Patient_ID']; ?>" onclick="return confirm('Delete record?')">Delete</a>
            </td>
        </tr>
        <?php } ?>
    </table>
</div>

</body>
</html>