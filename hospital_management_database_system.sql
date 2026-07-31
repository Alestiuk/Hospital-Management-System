-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jul 31, 2026 at 01:05 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `hospital_management_database_system`
--

-- --------------------------------------------------------

--
-- Table structure for table `admission`
--

CREATE TABLE `admission` (
  `Admission_ID` int(11) NOT NULL,
  `Admission_Date` date DEFAULT NULL,
  `Discharge_Date` date DEFAULT NULL,
  `Patient_ID` int(11) DEFAULT NULL,
  `Room_ID` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `admission`
--

INSERT INTO `admission` (`Admission_ID`, `Admission_Date`, `Discharge_Date`, `Patient_ID`, `Room_ID`) VALUES
(501, '2025-06-01', NULL, 201, 401),
(502, '2025-06-02', NULL, 203, 403);

--
-- Triggers `admission`
--
DELIMITER $$
CREATE TRIGGER `trg_CheckRoomAvailability` BEFORE INSERT ON `admission` FOR EACH ROW BEGIN
    DECLARE v_status VARCHAR(20);
    SELECT Availability_Status INTO v_status FROM Room WHERE Room_ID = NEW.Room_ID;
    
    IF v_status = 'Unavailable' OR v_status = 'Occupied' THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Error: Room is currently occupied or unavailable for admission.';
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `appointment`
--

CREATE TABLE `appointment` (
  `Appointment_ID` int(11) NOT NULL,
  `Appointment_Date` date DEFAULT NULL,
  `Appointment_Time` time DEFAULT NULL,
  `Purpose` varchar(255) DEFAULT NULL,
  `Status` varchar(20) DEFAULT NULL,
  `Consultation_Notes` text DEFAULT NULL,
  `Patient_ID` int(11) DEFAULT NULL,
  `Doctor_ID` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `appointment`
--

INSERT INTO `appointment` (`Appointment_ID`, `Appointment_Date`, `Appointment_Time`, `Purpose`, `Status`, `Consultation_Notes`, `Patient_ID`, `Doctor_ID`) VALUES
(301, '2025-06-01', '10:00:00', 'Chest Pain Checkup', 'Completed', 'ECG done', 201, 101),
(302, '2025-06-01', '11:30:00', 'Migraine Consultation', 'Completed', 'Prescribed meds', 202, 102);

--
-- Triggers `appointment`
--
DELIMITER $$
CREATE TRIGGER `trg_LogDeletedAppointment` AFTER DELETE ON `appointment` FOR EACH ROW BEGIN
    INSERT INTO Appointment_Log (Appointment_ID, Patient_ID, Doctor_ID, Appointment_Date, Appointment_Time, Purpose)
    VALUES (OLD.Appointment_ID, OLD.Patient_ID, OLD.Doctor_ID, OLD.Appointment_Date, OLD.Appointment_Time, OLD.Purpose);
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `appointment_log`
--

CREATE TABLE `appointment_log` (
  `Log_ID` int(11) NOT NULL,
  `Appointment_ID` int(11) DEFAULT NULL,
  `Patient_ID` int(11) DEFAULT NULL,
  `Doctor_ID` int(11) DEFAULT NULL,
  `Appointment_Date` date DEFAULT NULL,
  `Appointment_Time` time DEFAULT NULL,
  `Purpose` varchar(255) DEFAULT NULL,
  `Deleted_At` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `bill`
--

CREATE TABLE `bill` (
  `Bill_ID` int(11) NOT NULL,
  `Bill_Date` date DEFAULT NULL,
  `Total_Charge` decimal(10,2) DEFAULT NULL,
  `Discount` decimal(10,2) DEFAULT 0.00,
  `Tax` decimal(10,2) DEFAULT 0.00,
  `Final_Amount` decimal(10,2) DEFAULT NULL,
  `Payment_Method` varchar(50) DEFAULT NULL,
  `Payment_Status` varchar(20) DEFAULT NULL,
  `Patient_ID` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `bill`
--

INSERT INTO `bill` (`Bill_ID`, `Bill_Date`, `Total_Charge`, `Discount`, `Tax`, `Final_Amount`, `Payment_Method`, `Payment_Status`, `Patient_ID`) VALUES
(701, '2025-06-01', 15000.00, 1000.00, 500.00, 14500.00, 'Cash', 'Paid', 201),
(702, '2025-06-01', 8000.00, 500.00, 200.00, 7700.00, 'Card', 'Paid', 202);

--
-- Triggers `bill`
--
DELIMITER $$
CREATE TRIGGER `trg_RecalculateFinalBill` BEFORE UPDATE ON `bill` FOR EACH ROW BEGIN
    SET NEW.Final_Amount = NEW.Total_Charge + NEW.Tax - NEW.Discount;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `department`
--

CREATE TABLE `department` (
  `Department_ID` int(11) NOT NULL,
  `Department_Name` varchar(100) NOT NULL,
  `Location` varchar(255) DEFAULT NULL,
  `Contact_Number` varchar(20) DEFAULT NULL,
  `Head_Of_Department` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `department`
--

INSERT INTO `department` (`Department_ID`, `Department_Name`, `Location`, `Contact_Number`, `Head_Of_Department`) VALUES
(1, 'Cardiology', 'Building A, Floor 2', '01711111111', 'Dr. Hasan Ali'),
(2, 'Neurology', 'Building B, Floor 3', '01822222222', 'Dr. Nabila Islam'),
(3, 'Orthopedics', 'Building A, Floor 1', '01933333333', 'Dr. Imran Hossain');

-- --------------------------------------------------------

--
-- Table structure for table `doctor`
--

CREATE TABLE `doctor` (
  `Doctor_ID` int(11) NOT NULL,
  `Full_Name` varchar(100) NOT NULL,
  `Specialization` varchar(100) DEFAULT NULL,
  `Phone_Number` varchar(20) DEFAULT NULL,
  `Email` varchar(100) DEFAULT NULL,
  `Qualification` varchar(100) DEFAULT NULL,
  `Joining_Date` date DEFAULT NULL,
  `Consultation_Fee` decimal(10,2) DEFAULT NULL,
  `Employment_Status` varchar(20) DEFAULT NULL,
  `Department_ID` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `doctor`
--

INSERT INTO `doctor` (`Doctor_ID`, `Full_Name`, `Specialization`, `Phone_Number`, `Email`, `Qualification`, `Joining_Date`, `Consultation_Fee`, `Employment_Status`, `Department_ID`) VALUES
(101, 'Dr. Hasan Ali', 'Cardiologist', '01711111111', 'hasan@hospital.com', 'MBBS, FCPS', '2020-01-15', 1500.00, 'Active', 1),
(102, 'Dr. Nabila Islam', 'Neurologist', '01822222222', 'nabila@hospital.com', 'MBBS, MD', '2021-06-01', 1200.00, 'Active', 2),
(103, 'Dr. Imran Hossain', 'Orthopedic Surgeon', '01933333333', 'imran@hospital.com', 'MBBS, MS', '2019-03-10', 900.00, 'Active', 3);

-- --------------------------------------------------------

--
-- Table structure for table `patient`
--

CREATE TABLE `patient` (
  `Patient_ID` int(11) NOT NULL,
  `Full_Name` varchar(100) NOT NULL,
  `Gender` varchar(10) DEFAULT NULL,
  `Date_Of_Birth` date DEFAULT NULL,
  `Blood_Group` varchar(5) DEFAULT NULL,
  `Address` varchar(255) DEFAULT NULL,
  `Phone_Number` varchar(20) DEFAULT NULL,
  `Emergency_Contact` varchar(20) DEFAULT NULL,
  `Registration_Date` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `patient`
--

INSERT INTO `patient` (`Patient_ID`, `Full_Name`, `Gender`, `Date_Of_Birth`, `Blood_Group`, `Address`, `Phone_Number`, `Emergency_Contact`, `Registration_Date`) VALUES
(201, 'Rahim Rahman', 'Male', '1985-04-12', 'A+', 'Dhanmondi, Dhaka', '01711111111', '01700000000', '2025-06-01'),
(202, 'Karim Hasan', 'Male', '1992-08-25', 'B+', 'Uttara, Dhaka', '01822222222', '01800000000', '2025-06-01'),
(203, 'Nila Sultana', 'Female', '1990-11-05', 'O+', 'Mirpur, Dhaka', '01933333333', '01900000000', '2025-06-02');

-- --------------------------------------------------------

--
-- Table structure for table `room`
--

CREATE TABLE `room` (
  `Room_ID` int(11) NOT NULL,
  `Room_Number` varchar(20) NOT NULL,
  `Room_Type` varchar(50) DEFAULT NULL,
  `Capacity` int(11) DEFAULT NULL,
  `Daily_Charge` decimal(10,2) DEFAULT NULL,
  `Availability_Status` varchar(20) DEFAULT 'Available'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `room`
--

INSERT INTO `room` (`Room_ID`, `Room_Number`, `Room_Type`, `Capacity`, `Daily_Charge`, `Availability_Status`) VALUES
(401, 'R101', 'Cabin', 1, 5000.00, 'Occupied'),
(402, 'R102', 'General Ward', 4, 1500.00, 'Available'),
(403, 'R103', 'ICU', 1, 15000.00, 'Occupied');

-- --------------------------------------------------------

--
-- Table structure for table `treatment`
--

CREATE TABLE `treatment` (
  `Treatment_ID` int(11) NOT NULL,
  `Diagnosis_Details` text DEFAULT NULL,
  `Prescribed_Medicines` text DEFAULT NULL,
  `Treatment_Date` date DEFAULT NULL,
  `Followup_Instructions` text DEFAULT NULL,
  `Patient_ID` int(11) DEFAULT NULL,
  `Doctor_ID` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `fullname` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `admission`
--
ALTER TABLE `admission`
  ADD PRIMARY KEY (`Admission_ID`),
  ADD KEY `Patient_ID` (`Patient_ID`),
  ADD KEY `Room_ID` (`Room_ID`);

--
-- Indexes for table `appointment`
--
ALTER TABLE `appointment`
  ADD PRIMARY KEY (`Appointment_ID`),
  ADD KEY `Patient_ID` (`Patient_ID`),
  ADD KEY `Doctor_ID` (`Doctor_ID`);

--
-- Indexes for table `appointment_log`
--
ALTER TABLE `appointment_log`
  ADD PRIMARY KEY (`Log_ID`);

--
-- Indexes for table `bill`
--
ALTER TABLE `bill`
  ADD PRIMARY KEY (`Bill_ID`),
  ADD KEY `Patient_ID` (`Patient_ID`);

--
-- Indexes for table `department`
--
ALTER TABLE `department`
  ADD PRIMARY KEY (`Department_ID`);

--
-- Indexes for table `doctor`
--
ALTER TABLE `doctor`
  ADD PRIMARY KEY (`Doctor_ID`),
  ADD UNIQUE KEY `Email` (`Email`),
  ADD KEY `Department_ID` (`Department_ID`);

--
-- Indexes for table `patient`
--
ALTER TABLE `patient`
  ADD PRIMARY KEY (`Patient_ID`);

--
-- Indexes for table `room`
--
ALTER TABLE `room`
  ADD PRIMARY KEY (`Room_ID`),
  ADD UNIQUE KEY `Room_Number` (`Room_Number`);

--
-- Indexes for table `treatment`
--
ALTER TABLE `treatment`
  ADD PRIMARY KEY (`Treatment_ID`),
  ADD KEY `Patient_ID` (`Patient_ID`),
  ADD KEY `Doctor_ID` (`Doctor_ID`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `appointment_log`
--
ALTER TABLE `appointment_log`
  MODIFY `Log_ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `admission`
--
ALTER TABLE `admission`
  ADD CONSTRAINT `admission_ibfk_1` FOREIGN KEY (`Patient_ID`) REFERENCES `patient` (`Patient_ID`) ON DELETE CASCADE,
  ADD CONSTRAINT `admission_ibfk_2` FOREIGN KEY (`Room_ID`) REFERENCES `room` (`Room_ID`) ON DELETE CASCADE;

--
-- Constraints for table `appointment`
--
ALTER TABLE `appointment`
  ADD CONSTRAINT `appointment_ibfk_1` FOREIGN KEY (`Patient_ID`) REFERENCES `patient` (`Patient_ID`) ON DELETE CASCADE,
  ADD CONSTRAINT `appointment_ibfk_2` FOREIGN KEY (`Doctor_ID`) REFERENCES `doctor` (`Doctor_ID`) ON DELETE CASCADE;

--
-- Constraints for table `bill`
--
ALTER TABLE `bill`
  ADD CONSTRAINT `bill_ibfk_1` FOREIGN KEY (`Patient_ID`) REFERENCES `patient` (`Patient_ID`) ON DELETE CASCADE;

--
-- Constraints for table `doctor`
--
ALTER TABLE `doctor`
  ADD CONSTRAINT `doctor_ibfk_1` FOREIGN KEY (`Department_ID`) REFERENCES `department` (`Department_ID`) ON DELETE SET NULL;

--
-- Constraints for table `treatment`
--
ALTER TABLE `treatment`
  ADD CONSTRAINT `treatment_ibfk_1` FOREIGN KEY (`Patient_ID`) REFERENCES `patient` (`Patient_ID`) ON DELETE CASCADE,
  ADD CONSTRAINT `treatment_ibfk_2` FOREIGN KEY (`Doctor_ID`) REFERENCES `doctor` (`Doctor_ID`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
