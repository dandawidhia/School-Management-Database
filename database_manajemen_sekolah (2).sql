-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Dec 06, 2023 at 12:15 PM
-- Server version: 8.0.34
-- PHP Version: 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `database_manajemen_sekolah`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `AbsensiGurudariNama` (`NamaGuru` VARCHAR(50))   BEGIN
    SELECT 
      	AG.Absen,
        AG.Keterangan,
        AG.Tanggal
    FROM 
    	Absensi_Guru AS AG
    JOIN 
    	Guru ON Guru.Guru_ID = AG.Guru_ID
    WHERE Guru.Nama = NamaGuru;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `AbsensiSiswadariNama` (IN `NamaSiswa` VARCHAR(50))   BEGIN
    SELECT 
        AG.Absen,
        AG.Keterangan,
        AG.Tanggal
    FROM 
        Siswa  
    JOIN 
        Absensi_Siswa AS AG ON AG.Siswa_ID = Siswa.Siswa_ID
    WHERE Siswa.Nama = NamaSiswa;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `DataSiswaDariNamaKelas` (IN `Cari_Nama` VARCHAR(50))   BEGIN
    SELECT 
        Siswa_Id,
        Nama,
        Jenis_kelamin
    FROM Siswa
    WHERE Kelas = Cari_Nama;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `JadwalKelasdarinamakelas` (IN `Cari_Kelas` VARCHAR(50))   BEGIN
    SELECT 
        JMP.Jadwal_ID,
        JMP.Mata_Pelajaran_ID,
        JMP.Nama_Kelas,
        JMP.Hari,
        CONCAT(JMP.Jam_Mulai, ' - ', JMP.Jam_Selesai) AS Waktu,
        Guru.Nama As Nama_Pengajar
    FROM Jadwal_Mata_Pelajaran AS JMP
    JOIN Guru On Guru.Guru_ID = JMP.Guru_ID
    WHERE Nama_Kelas = Cari_Kelas;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `JadwalMengajarGurudariNama` (IN `NamaGuru` VARCHAR(50))   BEGIN
    SELECT 
        JMP.Nama_Kelas,
        MP.Nama_Pelajaran,
        JMP.Hari,
        CONCAT(JMP.Jam_Mulai, ' - ', JMP.Jam_Selesai) AS Waktu
    FROM 
        guru  
    JOIN 
        jadwal_mata_pelajaran AS JMP ON guru.Guru_ID = JMP.Guru_ID
    JOIN
        Mata_Pelajaran AS MP ON MP.Mata_Pelajaran_ID = JMP.Mata_Pelajaran_ID
    WHERE 
        guru.Nama = NamaGuru;
END$$

--
-- Functions
--
CREATE DEFINER=`root`@`localhost` FUNCTION `Hitungmuriddikelas` (`Nama_Kelas` VARCHAR(50)) RETURNS INT DETERMINISTIC BEGIN
    DECLARE Hitung INT;
    SELECT COUNT(*) INTO Hitung
    FROM siswa
    WHERE Kelas = Nama_Kelas;
RETURN Hitung;

END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `JumlahAbsenGurudariNama` (`Nama_Guru` VARCHAR(50)) RETURNS INT READS SQL DATA BEGIN
    DECLARE absen INT;
    SELECT COUNT(*) INTO absen
    FROM Absensi_Guru
    JOIN Guru ON Guru.Guru_ID = Absensi_Guru.Guru_ID
    WHERE Guru.Nama = Nama_Guru;

    RETURN absen;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `JumlahAbsenMuriddariNama` (`Nama_Murid` VARCHAR(50)) RETURNS INT READS SQL DATA BEGIN
    DECLARE Absen INT;
    SELECT COUNT(*) INTO Absen
    FROM Absensi_Siswa
    JOIN Siswa ON Siswa.Siswa_ID = Absensi_Siswa.Siswa_ID
    WHERE Siswa.Nama = Nama_Murid;

    RETURN Absen;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `absensi_guru`
--

CREATE TABLE `absensi_guru` (
  `Absen_ID` int NOT NULL,
  `Guru_ID` varchar(10) NOT NULL,
  `Absen` char(1) NOT NULL,
  `Keterangan` varchar(50) NOT NULL,
  `Tanggal` varchar(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `absensi_guru`
--

INSERT INTO `absensi_guru` (`Absen_ID`, `Guru_ID`, `Absen`, `Keterangan`, `Tanggal`) VALUES
(1, 'GR001', 'A', 'Alpha', '2023-12-01'),
(2, 'GR002', 'I', 'Izin', '2023-12-02'),
(3, 'GR003', 'S', 'Sakit', '2023-12-03'),
(4, 'GR004', 'S', 'Sakit ', '2023-12-04'),
(5, 'GR005', 'A', 'Alpha', '2023-12-05'),
(6, 'GR006', 'I', 'Izin', '2023-12-06'),
(7, 'GR007', 'S', 'Sakit', '2023-12-07'),
(8, 'GR008', 'I', 'Izin', '2023-12-08'),
(9, 'GR009', 'A', 'Alpha', '2023-12-09'),
(10, 'GR010', 'I', 'Izin', '2023-12-10');

-- --------------------------------------------------------

--
-- Table structure for table `absensi_siswa`
--

CREATE TABLE `absensi_siswa` (
  `Absen_ID` int NOT NULL,
  `Siswa_ID` varchar(10) NOT NULL,
  `Absen` char(1) NOT NULL,
  `Keterangan` varchar(50) NOT NULL,
  `Tanggal` varchar(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `absensi_siswa`
--

INSERT INTO `absensi_siswa` (`Absen_ID`, `Siswa_ID`, `Absen`, `Keterangan`, `Tanggal`) VALUES
(1, 'SS00011', 'A', 'Alpha', '2023-01-01'),
(2, 'SS00040', 'I', 'Izin', '2023-01-01'),
(3, 'SS00053', 'S', 'Sakit', '2023-01-02'),
(4, 'SS00040', 'I', 'Izin', '2023-01-02'),
(5, 'SS00051', 'A', 'Alpha', '2023-01-03'),
(6, 'SS00043', 'I', 'Izin', '2023-01-03'),
(7, 'SS00012', 'S', 'Sakit', '2023-01-04'),
(8, 'SS00022', 'S', 'Sakit', '2023-01-04'),
(9, 'SS00091', 'A', 'Alpha', '2023-01-05'),
(10, 'SS00100', 'I', 'Izin', '2023-01-05');

-- --------------------------------------------------------

--
-- Table structure for table `guru`
--

CREATE TABLE `guru` (
  `Guru_ID` varchar(10) NOT NULL,
  `Nama` varchar(50) NOT NULL,
  `Alamat` varchar(50) NOT NULL,
  `Jenis_Kelamin` char(1) NOT NULL,
  `Email` varchar(50) DEFAULT NULL,
  `Nomor_Telepon` varchar(15) NOT NULL
) ;

--
-- Dumping data for table `guru`
--

INSERT INTO `guru` (`Guru_ID`, `Nama`, `Alamat`, `Jenis_Kelamin`, `Email`, `Nomor_Telepon`) VALUES
('GR001', 'Budi Setiawan', 'Jl. Kawi No. 123', 'L', 'budi.setiawan@email.com', '081234567890'),
('GR002', 'Siti Rahayu', 'Jl. Veteran No. 456', 'P', 'siti.rahayu@email.com', '089876543210'),
('GR003', 'Ahmad Susanto', 'Jl. Simpang Borobudur No. 789', 'L', 'ahmad.susanto@email.com', '084567890123'),
('GR004', 'Dewi Anggraeni', 'Jl. S. Parman No. 456', 'P', 'dewi.anggraeni@email.com', '087890123456'),
('GR005', 'Rudi Santoso', 'Jl. Trunojoyo No. 789', 'L', 'rudi.santoso@email.com', '082345678901'),
('GR006', 'Lina Wijaya', 'Jl. Puncak B29 No. 123', 'P', 'lina.wijaya@email.com', '083456789012'),
('GR007', 'Denny Wirawan', 'Jl. Ijen No. 456', 'L', 'denny.wirawan@email.com', '085678901234'),
('GR008', 'Ninooa Marwah', 'Jl. Bromo No. 789', 'P', 'nina.marwah@email.com', '086789012345'),
('GR009', 'Wahyu Budiman', 'Jl. Kawi No. 123', 'L', 'wahyu.budiman@email.com', '089012345678'),
('GR010', 'Rina Puspitasari', 'Jl. Singosari No. 456', 'P', 'rina.puspitasari@email.com', '089012345678'),
('GR011', 'Budi Santoso', 'Jl. Merdeka No. 123', 'L', 'budi.santoso@example.com', '081234567890'),
('GR012', 'Siti kurniya', 'Jl. Jendral Sudirman No. 456', 'P', 'siti.rahayu@example.com', '081298765432'),
('GR013', 'Hendri Susanto', 'Jl. Gatot Subroto No. 789', 'L', 'hendri.susanto@example.com', '081211112222'),
('GR014', 'Rina Sari', 'Jl. Pahlawan No. 567', 'P', 'rina.sari@example.com', '081277778888'),
('GR015', 'Agus Prabowo', 'Jl. Diponegoro No. 890', 'L', 'agus.prabowo@example.com', '081244445555'),
('GR016', 'Nurul Fitriani', 'Jl. Ahmad Yani No. 123', 'P', 'nurul.fitriani@example.com', '081299990000'),
('GR017', 'Andi Saputra', 'Jl. Teuku Umar No. 456', 'L', 'andi.saputra@example.com', '081266667777'),
('GR018', 'Rini Wijaya', 'Jl. Gajah Mada No. 789', 'P', 'rini.wijaya@example.com', '081233332222'),
('GR019', 'Dedi Pratama', 'Jl. Jawa No. 101', 'L', 'dedi.pratama@example.com', '081212123434'),
('GR020', 'Lina Setiawati', 'Jl. Kalimantan No. 111', 'P', 'lina.setiawati@example.com', '081256567878');

-- --------------------------------------------------------

--
-- Table structure for table `jadwal_mata_pelajaran`
--

CREATE TABLE `jadwal_mata_pelajaran` (
  `Jadwal_ID` varchar(10) NOT NULL,
  `Mata_Pelajaran_ID` varchar(10) NOT NULL,
  `Nama_Kelas` varchar(10) NOT NULL,
  `Hari` varchar(10) NOT NULL,
  `Jam_Mulai` time NOT NULL,
  `Jam_Selesai` time NOT NULL,
  `Guru_ID` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `jadwal_mata_pelajaran`
--

INSERT INTO `jadwal_mata_pelajaran` (`Jadwal_ID`, `Mata_Pelajaran_ID`, `Nama_Kelas`, `Hari`, `Jam_Mulai`, `Jam_Selesai`, `Guru_ID`) VALUES
('J001', 'MT001', 'XI IPA 1', 'Senin', '07:15:00', '08:00:00', 'GR001'),
('J002', 'MT001', 'XI IPA 1', 'Senin', '08:00:00', '08:45:00', 'GR001'),
('J003', 'MT001', 'XI IPA 1', 'Senin', '08:45:00', '09:30:00', 'GR001'),
('J004', 'MT011', 'XI IPA 1', 'Senin', '10:15:00', '11:00:00', 'GR011'),
('J005', 'MT011', 'XI IPA 1', 'Senin', '11:00:00', '11:45:00', 'GR011'),
('J006', 'MT003', 'XI IPA 1', 'Senin', '12:30:00', '13:15:00', 'GR003'),
('J007', 'MT003', 'XI IPA 1', 'Senin', '13:15:00', '14:00:00', 'GR003'),
('J008', 'MT003', 'XI IPA 1', 'Senin', '14:00:00', '14:45:00', 'GR003'),
('J009', 'MT004', 'XI IPA 1', 'Selasa', '07:15:00', '08:00:00', 'GR004'),
('J010', 'MT004', 'XI IPA 1', 'Selasa', '08:00:00', '08:45:00', 'GR004'),
('J011', 'MT004', 'XI IPA 1', 'Selasa', '08:45:00', '09:30:00', 'GR004'),
('J012', 'MT014', 'XI IPA 1', 'Selasa', '10:15:00', '11:00:00', 'GR014'),
('J013', 'MT014', 'XI IPA 1', 'Selasa', '11:00:00', '11:45:00', 'GR014'),
('J014', 'MT014', 'XI IPA 1', 'Selasa', '11:45:00', '12:30:00', 'GR014'),
('J015', 'MT010', 'XI IPA 1', 'Selasa', '13:15:00', '14:00:00', 'GR010'),
('J016', 'MT010', 'XI IPA 1', 'Selasa', '14:00:00', '14:45:00', 'GR010'),
('J017', 'MT006', 'XI IPA 1', 'Rabu', '07:15:00', '08:00:00', 'GR006'),
('J018', 'MT006', 'XI IPA 1', 'Rabu', '08:00:00', '08:45:00', 'GR006'),
('J019', 'MT005', 'XI IPA 1', 'Rabu', '08:45:00', '09:30:00', 'GR005'),
('J020', 'MT005', 'XI IPA 1', 'Rabu', '10:15:00', '11:00:00', 'GR005'),
('J021', 'MT005', 'XI IPA 1', 'Rabu', '11:00:00', '11:45:00', 'GR005'),
('J022', 'MT015', 'XI IPA 1', 'Rabu', '11:45:00', '12:30:00', 'GR015'),
('J023', 'MT015', 'XI IPA 1', 'Rabu', '13:15:00', '14:00:00', 'GR015'),
('J024', 'MT015', 'XI IPA 1', 'Rabu', '14:00:00', '14:45:00', 'GR015'),
('J025', 'MT012', 'XI IPA 1', 'Kamis', '07:15:00', '08:00:00', 'GR012'),
('J026', 'MT012', 'XI IPA 1', 'Kamis', '08:00:00', '08:45:00', 'GR012'),
('J027', 'MT001', 'XI IPA 1', 'Kamis', '08:45:00', '09:30:00', 'GR001'),
('J028', 'MT001', 'XI IPA 1', 'Kamis', '10:15:00', '11:00:00', 'GR001'),
('J029', 'MT001', 'XI IPA 1', 'Kamis', '11:00:00', '11:45:00', 'GR001'),
('J030', 'MT002', 'XI IPA 1', 'Kamis', '11:45:00', '12:30:00', 'GR002'),
('J031', 'MT002', 'XI IPA 1', 'Kamis', '13:15:00', '14:00:00', 'GR002'),
('J032', 'MT002', 'XI IPA 1', 'Kamis', '14:00:00', '14:45:00', 'GR002'),
('J033', 'MT013', 'XI IPA 1', 'Jumat', '07:15:00', '08:00:00', 'GR013'),
('J034', 'MT013', 'XI IPA 1', 'Jumat', '08:00:00', '08:45:00', 'GR013'),
('J035', 'MT013', 'XI IPA 1', 'Jumat', '08:45:00', '09:30:00', 'GR013'),
('J036', 'MT010', 'XI IPA 1', 'Jumat', '10:15:00', '11:00:00', 'GR010'),
('J037', 'MT010', 'XI IPA 1', 'Jumat', '11:00:00', '11:45:00', 'GR010'),
('J038', 'MT010', 'XI IPA 1', 'Jumat', '11:45:00', '12:30:00', 'GR010');

-- --------------------------------------------------------

--
-- Table structure for table `kelas`
--

CREATE TABLE `kelas` (
  `Nama_Kelas` varchar(10) NOT NULL,
  `Wali_Kelas_ID` varchar(10) NOT NULL,
  `Jumlah_Siswa` int NOT NULL
) ;

--
-- Dumping data for table `kelas`
--

INSERT INTO `kelas` (`Nama_Kelas`, `Wali_Kelas_ID`, `Jumlah_Siswa`) VALUES
('X IPA 1', 'GR001', 10),
('X IPA 2', 'GR002', 10),
('X IPA 3', 'GR003', 10),
('X IPS 1', 'GR004', 10),
('X IPS 2', 'GR005', 10),
('XI IPA 1', 'GR006', 10),
('XI IPA 2', 'GR007', 10),
('XI IPA 3', 'GR008', 10),
('XI IPS 1', 'GR009', 10),
('XI IPS 2', 'GR010', 10);

-- --------------------------------------------------------

--
-- Stand-in structure for view `kelasdanwalikelas`
-- (See below for the actual view)
--
CREATE TABLE `kelasdanwalikelas` (
`Nama_Kelas` varchar(10)
,`Wali_Kelas` varchar(50)
);

-- --------------------------------------------------------

--
-- Table structure for table `mata_pelajaran`
--

CREATE TABLE `mata_pelajaran` (
  `Mata_Pelajaran_ID` varchar(10) NOT NULL,
  `Nama_Pelajaran` varchar(50) NOT NULL,
  `Guru_ID` varchar(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `mata_pelajaran`
--

INSERT INTO `mata_pelajaran` (`Mata_Pelajaran_ID`, `Nama_Pelajaran`, `Guru_ID`) VALUES
('MT001', 'Matematika', 'GR001'),
('MT002', 'Bahasa Inggris', 'GR002'),
('MT003', 'Fisika', 'GR003'),
('MT004', 'Kimia', 'GR004'),
('MT005', 'Biologi', 'GR005'),
('MT006', 'Sejarah', 'GR006'),
('MT007', 'Geografi', 'GR007'),
('MT008', 'Ekonomi', 'GR008'),
('MT009', 'Sosiologi', 'GR009'),
('MT010', 'Bahasa Indonesia', 'GR010'),
('MT011', 'Program Pengembangan Karakter', 'GR011'),
('MT012', 'Pendidikan Kewarganegaraan', 'GR012'),
('MT013', 'Seni Budaya', 'GR013'),
('MT014', 'Pendidikan jasmani, olahraga dan kesehatan', 'GR014'),
('MT015', 'Agama', 'GR015');

-- --------------------------------------------------------

--
-- Table structure for table `siswa`
--

CREATE TABLE `siswa` (
  `Siswa_ID` varchar(10) NOT NULL,
  `Nama` varchar(50) NOT NULL,
  `Alamat` varchar(50) NOT NULL,
  `Jenis_Kelamin` char(1) NOT NULL,
  `Nomor_Telepon` varchar(15) NOT NULL,
  `Kelas` varchar(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `siswa`
--

INSERT INTO `siswa` (`Siswa_ID`, `Nama`, `Alamat`, `Jenis_Kelamin`, `Nomor_Telepon`, `Kelas`) VALUES
('SS00001', 'Anita Putri', 'Jl. Melati No. 123', 'P', '081234567890', 'X IPA 1'),
('SS00002', 'Budi Setiawan', 'Jl. Anggrek No. 456', 'L', '081234567891', 'X IPA 1'),
('SS00003', 'Citra Dewi', 'Jl. Mawar No. 789', 'P', '081234567892', 'X IPA 1'),
('SS00004', 'Dika Pratama', 'Jl. Dahlia No. 101', 'L', '081234567893', 'X IPA 1'),
('SS00005', 'Eka Sari', 'Jl. Kenanga No. 202', 'P', '081234567894', 'X IPA 1'),
('SS00006', 'Fikri Ramadhan', 'Jl. Cempaka No. 303', 'L', '081234567895', 'X IPA 1'),
('SS00007', 'Gita Wulandari', 'Jl. Sakura No. 404', 'P', '081234567896', 'X IPA 1'),
('SS00008', 'Hadi Santoso', 'Jl. Melati No. 505', 'L', '081234567897', 'X IPA 1'),
('SS00009', 'Ira Putri', 'Jl. Anggrek No. 606', 'P', '081234567898', 'X IPA 1'),
('SS00010', 'Joko Susanto', 'Jl. Mawar No. 707', 'L', '081234567899', 'X IPA 1'),
('SS00011', 'Kartika Sari', 'Jl. Dahlia No. 808', 'P', '081234567890', 'X IPA 2'),
('SS00012', 'Lutfi Rahman', 'Jl. Kenanga No. 909', 'L', '081234567891', 'X IPA 2'),
('SS00013', 'Mega Wati', 'Jl. Cempaka No. 111', 'P', '081234567892', 'X IPA 2'),
('SS00014', 'Nanda Pratama', 'Jl. Sakura No. 222', 'L', '081234567893', 'X IPA 2'),
('SS00015', 'Oscar Santoso', 'Jl. Melati No. 333', 'P', '081234567894', 'X IPA 2'),
('SS00016', 'Putri Wahyuni', 'Jl. Anggrek No. 444', 'P', '081234567895', 'X IPA 2'),
('SS00017', 'Qori Maulana', 'Jl. Mawar No. 555', 'L', '081234567896', 'X IPA 2'),
('SS00018', 'Rina Cahyani', 'Jl. Dahlia No. 666', 'P', '081234567897', 'X IPA 2'),
('SS00019', 'Surya Pratama', 'Jl. Kenanga No. 777', 'L', '081234567898', 'X IPA 2'),
('SS00020', 'Tika Ramadhani', 'Jl. Cempaka No. 888', 'P', '081234567899', 'X IPA 2'),
('SS00021', 'Umar Setiawan', 'Jl. Sakura No. 999', 'L', '081234567890', 'X IPA 3'),
('SS00022', 'Vivi Handayani', 'Jl. Melati No. 1010', 'P', '081234567891', 'X IPA 3'),
('SS00023', 'Wira Nugraha', 'Jl. Anggrek No. 1111', 'L', '081234567892', 'X IPA 3'),
('SS00024', 'Xena Putri', 'Jl. Mawar No. 1212', 'P', '081234567893', 'X IPA 3'),
('SS00025', 'Yoga Pratama', 'Jl. Dahlia No. 1313', 'L', '081234567894', 'X IPA 3'),
('SS00026', 'Zahra Maulida', 'Jl. Kenanga No. 1414', 'P', '081234567895', 'X IPA 3'),
('SS00027', 'Andi Setiawan', 'Jl. Cempaka No. 1515', 'L', '081234567896', 'X IPA 3'),
('SS00028', 'Bella Wahyuni', 'Jl. Sakura No. 1616', 'P', '081234567897', 'X IPA 3'),
('SS00029', 'Cahya Pratama', 'Jl. Melati No. 1717', 'L', '081234567898', 'X IPA 3'),
('SS00030', 'Dewi Setiawati', 'Jl. Anggrek No. 1818', 'P', '081234567899', 'X IPA 3'),
('SS00031', 'Farhan Abdul', 'Jl. Flamboyan No. 123', 'L', '081234567800', 'X IPS 1'),
('SS00032', 'Gina Dewi', 'Jl. Cendana No. 456', 'P', '081234567801', 'X IPS 1'),
('SS00033', 'Hafiz Pratama', 'Jl. Matahari No. 789', 'L', '081234567802', 'X IPS 1'),
('SS00034', 'Ika Sari', 'Jl. Teratai No. 101', 'P', '081234567803', 'X IPS 1'),
('SS00035', 'Joko Santoso', 'Jl. Bambu No. 202', 'L', '081234567804', 'X IPS 1'),
('SS00036', 'Kartika Wulandari', 'Jl. Kenari No. 303', 'P', '081234567805', 'X IPS 1'),
('SS00037', 'Luthfi Maulana', 'Jl. Pisang No. 404', 'L', '081234567806', 'X IPS 1'),
('SS00038', 'Mia Pratiwi', 'Jl. Sirsak No. 505', 'P', '081234567807', 'X IPS 1'),
('SS00039', 'Nurul Hidayah', 'Jl. Anggrek No. 606', 'P', '081234567808', 'X IPS 1'),
('SS00040', 'Oscar Setiawan', 'Jl. Mawar No. 707', 'L', '081234567809', 'X IPS 1'),
('SS00041', 'Prita Agustina', 'Jl. Dahlia No. 808', 'P', '081234567810', 'X IPS 2'),
('SS00042', 'Qori Ramadhan', 'Jl. Kenanga No. 909', 'L', '081234567811', 'X IPS 2'),
('SS00043', 'Rina Cahyani', 'Jl. Mawar No. 111', 'P', '081234567812', 'X IPS 2'),
('SS00044', 'Surya Pratama', 'Jl. Anggrek No. 222', 'L', '081234567813', 'X IPS 2'),
('SS00045', 'Tia Wijayanti', 'Jl. Cempaka No. 333', 'P', '081234567814', 'X IPS 2'),
('SS00046', 'Umar Setiawan', 'Jl. Sakura No. 444', 'L', '081234567815', 'X IPS 2'),
('SS00047', 'Vina Pratiwi', 'Jl. Melati No. 555', 'P', '081234567816', 'X IPS 2'),
('SS00048', 'Wawan Kurniawan', 'Jl. Alamanda No. 666', 'L', '081234567817', 'X IPS 2'),
('SS00049', 'Xena Putri', 'Jl. Cendana No. 777', 'P', '081234567818', 'X IPS 2'),
('SS00050', 'Yogi Maulana', 'Jl. Dahlia No. 888', 'L', '081234567819', 'X IPS 2'),
('SS00051', 'Aldi Ramadhan', 'Jl. Seroja No. 123', 'L', '081234567850', 'XI IPA 1'),
('SS00052', 'Bunga Melati', 'Jl. Kamboja No. 456', 'P', '081234567851', 'XI IPA 1'),
('SS00053', 'Cahya Pratama', 'Jl. Rafflesia No. 789', 'L', '081234567852', 'XI IPA 1'),
('SS00054', 'Dewi Lestari', 'Jl. Aster No. 101', 'P', '081234567853', 'XI IPA 1'),
('SS00055', 'Eko Nugroho', 'Jl. Flamboyan No. 202', 'L', '081234567854', 'XI IPA 1'),
('SS00056', 'Fani Wahyuni', 'Jl. Cendana No. 303', 'P', '081234567855', 'XI IPA 1'),
('SS00057', 'Galih Ramadhan', 'Jl. Melati No. 404', 'L', '081234567856', 'XI IPA 1'),
('SS00058', 'Hana Maulidya', 'Jl. Teratai No. 505', 'P', '081234567857', 'XI IPA 1'),
('SS00059', 'Ibnu Santoso', 'Jl. Anggrek No. 606', 'L', '081234567858', 'XI IPA 1'),
('SS00060', 'Jasmine Putri', 'Jl. Dahlia No. 707', 'P', '081234567859', 'XI IPA 1'),
('SS00061', 'Kiki Setiawan', 'Jl. Kenanga No. 808', 'L', '081234567860', 'XI IPA 2'),
('SS00062', 'Linda Wijayanti', 'Jl. Cempaka No. 909', 'P', '081234567861', 'XI IPA 2'),
('SS00063', 'Maulana Yusuf', 'Jl. Sakura No. 111', 'L', '081234567862', 'XI IPA 2'),
('SS00064', 'Nia Pratiwi', 'Jl. Dahlia No. 222', 'P', '081234567863', 'XI IPA 2'),
('SS00065', 'Oscar Prabowo', 'Jl. Melati No. 333', 'L', '081234567864', 'XI IPA 2'),
('SS00066', 'Putri Cahaya', 'Jl. Anggrek No. 444', 'P', '081234567865', 'XI IPA 2'),
('SS00067', 'Qowi Pratama', 'Jl. Mawar No. 555', 'L', '081234567866', 'XI IPA 2'),
('SS00068', 'Rani Maulida', 'Jl. Dahlia No. 666', 'P', '081234567867', 'XI IPA 2'),
('SS00069', 'Surya Setiawan', 'Jl. Kenanga No. 777', 'L', '081234567868', 'XI IPA 2'),
('SS00070', 'Tia Putri', 'Jl. Cempaka No. 888', 'P', '081234567869', 'XI IPA 2'),
('SS00071', 'Umar Pratama', 'Jl. Sakura No. 999', 'L', '081234567870', 'XI IPA 3'),
('SS00072', 'Vira Setiawati', 'Jl. Melati No. 1010', 'P', '081234567871', 'XI IPA 3'),
('SS00073', 'Wahyu Cahyono', 'Jl. Anggrek No. 1111', 'L', '081234567872', 'XI IPA 3'),
('SS00074', 'Xena Wulandari', 'Jl. Mawar No. 1212', 'P', '081234567873', 'XI IPA 3'),
('SS00075', 'Yoga Setiawan', 'Jl. Dahlia No. 1313', 'L', '081234567874', 'XI IPA 3'),
('SS00076', 'Zara Maulida', 'Jl. Kenanga No. 1414', 'P', '081234567875', 'XI IPA 3'),
('SS00077', 'Adi Pratama', 'Jl. Cempaka No. 1515', 'L', '081234567876', 'XI IPA 3'),
('SS00078', 'Bella Ramadhani', 'Jl. Sakura No. 1616', 'P', '081234567877', 'XI IPA 3'),
('SS00079', 'Cahyo Setiawan', 'Jl. Melati No. 1717', 'L', '081234567878', 'XI IPA 3'),
('SS00080', 'Dina Setiawati', 'Jl. Anggrek No. 1818', 'P', '081234567879', 'XI IPA 3'),
('SS00081', 'Alya Wulandari', 'Jl. Melati No. 123', 'P', '081234567880', 'XI IPS 1'),
('SS00082', 'Budi Santoso', 'Jl. Dahlia No. 456', 'L', '081234567881', 'XI IPS 1'),
('SS00083', 'Citra Pratiwi', 'Jl. Kenanga No. 789', 'P', '081234567882', 'XI IPS 1'),
('SS00084', 'Dito Setiawan', 'Jl. Mawar No. 101', 'L', '081234567883', 'XI IPS 1'),
('SS00085', 'Eva Ramadhani', 'Jl. Anggrek No. 202', 'P', '081234567884', 'XI IPS 1'),
('SS00086', 'Fahmi Pratama', 'Jl. Sakura No. 303', 'L', '081234567885', 'XI IPS 1'),
('SS00087', 'Gita Cahyani', 'Jl. Cempaka No. 404', 'P', '081234567886', 'XI IPS 1'),
('SS00088', 'Hadi Kurniawan', 'Jl. Teratai No. 505', 'L', '081234567887', 'XI IPS 1'),
('SS00089', 'Ina Wijayanti', 'Jl. Melati No. 606', 'P', '081234567888', 'XI IPS 1'),
('SS00090', 'Jaka Santosa', 'Jl. Cendana No. 707', 'L', '081234567889', 'XI IPS 1'),
('SS00091', 'Kartika Putri', 'Jl. Anggrek No. 808', 'P', '081234567890', 'XI IPS 2'),
('SS00092', 'Luthfi Setiawan', 'Jl. Cendana No. 909', 'L', '081234567891', 'XI IPS 2'),
('SS00093', 'Mira Pratiwi', 'Jl. Mawar No. 111', 'P', '081234567892', 'XI IPS 2'),
('SS00094', 'Nando Maulana', 'Jl. Kenanga No. 222', 'L', '081234567893', 'XI IPS 2'),
('SS00095', 'Olla Ramadhani', 'Jl. Dahlia No. 333', 'P', '081234567894', 'XI IPS 2'),
('SS00096', 'Prabu Setiawan', 'Jl. Melati No. 444', 'L', '081234567895', 'XI IPS 2'),
('SS00097', 'Qoryah Putri', 'Jl. Anggrek No. 555', 'P', '081234567896', 'XI IPS 2'),
('SS00098', 'Rizal Kurniawan', 'Jl. Cempaka No. 666', 'L', '081234567897', 'XI IPS 2'),
('SS00099', 'Siska Pratama', 'Jl. Sakura No. 777', 'P', '081234567898', 'XI IPS 2'),
('SS00100', 'Teguh Santoso', 'Jl. Kenanga No. 888', 'L', '081234567899', 'XI IPS 2');

-- --------------------------------------------------------

--
-- Stand-in structure for view `siswajurusanipa`
-- (See below for the actual view)
--
CREATE TABLE `siswajurusanipa` (
`Siswa_ID` varchar(10)
,`Nama` varchar(50)
,`Kelas` varchar(10)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `siswajurusanips`
-- (See below for the actual view)
--
CREATE TABLE `siswajurusanips` (
`Siswa_ID` varchar(10)
,`Nama` varchar(50)
,`Kelas` varchar(10)
);

-- --------------------------------------------------------

--
-- Structure for view `kelasdanwalikelas`
--
DROP TABLE IF EXISTS `kelasdanwalikelas`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `kelasdanwalikelas`  AS SELECT `kelas`.`Nama_Kelas` AS `Nama_Kelas`, `guru`.`Nama` AS `Wali_Kelas` FROM (`kelas` join `guru` on((`guru`.`Guru_ID` = `kelas`.`Wali_Kelas_ID`))) ;

-- --------------------------------------------------------

--
-- Structure for view `siswajurusanipa`
--
DROP TABLE IF EXISTS `siswajurusanipa`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `siswajurusanipa`  AS SELECT `siswa`.`Siswa_ID` AS `Siswa_ID`, `siswa`.`Nama` AS `Nama`, `siswa`.`Kelas` AS `Kelas` FROM `siswa` WHERE ((`siswa`.`Kelas` like 'X IPA%') OR (`siswa`.`Kelas` like 'XI IPA%') OR (`siswa`.`Kelas` like 'XII IPA%')) ;

-- --------------------------------------------------------

--
-- Structure for view `siswajurusanips`
--
DROP TABLE IF EXISTS `siswajurusanips`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `siswajurusanips`  AS SELECT `siswa`.`Siswa_ID` AS `Siswa_ID`, `siswa`.`Nama` AS `Nama`, `siswa`.`Kelas` AS `Kelas` FROM `siswa` WHERE ((`siswa`.`Kelas` like 'X IPS%') OR (`siswa`.`Kelas` like 'XI IPS%') OR (`siswa`.`Kelas` like 'XII IPS%')) ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `guru`
--
ALTER TABLE `guru`
  ADD PRIMARY KEY (`Guru_ID`);

--
-- Indexes for table `kelas`
--
ALTER TABLE `kelas`
  ADD PRIMARY KEY (`Nama_Kelas`),
  ADD KEY `Wali_Kelas_ID` (`Wali_Kelas_ID`);

--
-- Constraints for dumped tables
--

--
-- Constraints for table `kelas`
--
ALTER TABLE `kelas`
  ADD CONSTRAINT `kelas_ibfk_1` FOREIGN KEY (`Wali_Kelas_ID`) REFERENCES `guru` (`Guru_ID`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
