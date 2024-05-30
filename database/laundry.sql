-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Waktu pembuatan: 27 Des 2023 pada 20.09
-- Versi server: 10.4.24-MariaDB
-- Versi PHP: 8.1.6

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `laundry`
--

DELIMITER $$
--
-- Fungsi
--
CREATE DEFINER=`root`@`localhost` FUNCTION `jmlPenghasilan` (`tanggal_awal` DATETIME, `tanggal_akhir` DATETIME) RETURNS INT(11)  BEGIN 
	DECLARE jmlHasil INT;
	SELECT sum(
			(
			((paket.harga_paket * detail_transaksi.kuantitas) + transaksi.biaya_tambahan) - 
			(((paket.harga_paket * detail_transaksi.kuantitas) + transaksi.biaya_tambahan) * transaksi.diskon / 100)
			) 
			+ 
			((
			(((paket.harga_paket * detail_transaksi.kuantitas) + transaksi.biaya_tambahan) - 
			(((paket.harga_paket * detail_transaksi.kuantitas) + transaksi.biaya_tambahan) * transaksi.diskon / 100)) 
			* transaksi.pajak
			) / 100)
		) as penghasilan INTO jmlHasil
		FROM transaksi
		INNER JOIN user ON transaksi.id_user = user.id_user 
		INNER JOIN member ON transaksi.id_member = member.id_member 
		INNER JOIN detail_transaksi ON transaksi.id_transaksi = detail_transaksi.id_transaksi 
		INNER JOIN paket ON detail_transaksi.id_paket = paket.id_paket 
		INNER JOIN jenis_paket ON paket.id_jenis_paket = jenis_paket.id_jenis_paket 
		INNER JOIN outlet ON transaksi.id_outlet = outlet.id_outlet WHERE transaksi.tanggal_transaksi 
		BETWEEN tanggal_awal AND tanggal_akhir;
	RETURN jmlHasil;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `jmlStatusTanggal` (`st` ENUM('proses','dicuci','siap diambil','sudah diambil'), `tgl` DATE) RETURNS INT(11) NO SQL BEGIN
DECLARE jmlHasil INT;
SELECT COUNT(*) AS jml INTO jmlHasil FROM transaksi WHERE status_transaksi = st AND date(tanggal_transaksi) = tgl;
RETURN jmlHasil;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `jmlTransPaket` (`idPaket` INT) RETURNS INT(11)  BEGIN
DECLARE jmlHasil INT;
	SELECT COUNT(*) as jml INTO jmlHasil FROM detail_transaksi WHERE id_paket = idPaket;
    RETURN jmlHasil;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Struktur dari tabel `biodata`
--

CREATE TABLE `biodata` (
  `id_biodata` int(11) NOT NULL,
  `nama_lengkap` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `tempat_lahir` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `tanggal_lahir` date NOT NULL,
  `jenis_kelamin` enum('pria','wanita') COLLATE utf8_unicode_ci NOT NULL,
  `golongan_darah` enum('o','a','b','ab') COLLATE utf8_unicode_ci DEFAULT NULL,
  `telepon` varchar(25) COLLATE utf8_unicode_ci NOT NULL,
  `email` varchar(200) COLLATE utf8_unicode_ci NOT NULL,
  `alamat` text COLLATE utf8_unicode_ci NOT NULL,
  `foto` text COLLATE utf8_unicode_ci NOT NULL,
  `id_user` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data untuk tabel `biodata`
--

INSERT INTO `biodata` (`id_biodata`, `nama_lengkap`, `tempat_lahir`, `tanggal_lahir`, `jenis_kelamin`, `golongan_darah`, `telepon`, `email`, `alamat`, `foto`, `id_user`) VALUES
(1, 'Reissa Giana Azaria', 'Jambi', '2003-11-17', 'wanita', 'o', '082282061449', 'rgiana@gmail.com', 'Jl. Anyelir 1 No.231, Perumnas Condong Catur, Condongcatur, Kec. Depok, Kab. Sleman, Daerah Istimewa Yogyakarta', 'fotoSaya.png', 1),
(12, 'Reissa Giana Azaria', 'Jambi', '2003-11-17', 'wanita', 'o', '082282061449', 'rgiana@gmail.com', 'Jl. Anyelir 1 No.231, Perumnas Condong Catur, Condongcatur, Kec. Depok, Kabupaten Sleman, Daerah Istimewa Yogyakarta 55281, Indonesia', 'fotoSaya1.png', 13);

-- --------------------------------------------------------

--
-- Struktur dari tabel `detail_transaksi`
--

CREATE TABLE `detail_transaksi` (
  `id_detail_transaksi` int(11) NOT NULL,
  `kuantitas` float NOT NULL,
  `keterangan` text COLLATE utf8_unicode_ci NOT NULL,
  `id_transaksi` int(11) NOT NULL,
  `id_paket` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data untuk tabel `detail_transaksi`
--

INSERT INTO `detail_transaksi` (`id_detail_transaksi`, `kuantitas`, `keterangan`, `id_transaksi`, `id_paket`) VALUES
(68, 2, '', 47, 1),
(69, 1, '', 47, 2),
(70, 5, '', 48, 1),
(71, 1, '', 48, 2),
(72, 10, '', 49, 1),
(73, 2, '', 49, 2),
(74, 1, '', 50, 1),
(75, 12, '', 50, 2),
(76, 3, '', 51, 1),
(77, 2, '', 51, 2);

-- --------------------------------------------------------

--
-- Struktur dari tabel `jabatan`
--

CREATE TABLE `jabatan` (
  `id_jabatan` int(11) NOT NULL,
  `nama_jabatan` varchar(100) COLLATE utf8_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data untuk tabel `jabatan`
--

INSERT INTO `jabatan` (`id_jabatan`, `nama_jabatan`) VALUES
(1, 'super administrator'),
(2, 'administrator'),
(3, 'kasir'),
(4, 'owner');

-- --------------------------------------------------------

--
-- Struktur dari tabel `jenis_paket`
--

CREATE TABLE `jenis_paket` (
  `id_jenis_paket` int(11) NOT NULL,
  `nama_jenis_paket` varchar(100) COLLATE utf8_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data untuk tabel `jenis_paket`
--

INSERT INTO `jenis_paket` (`id_jenis_paket`, `nama_jenis_paket`) VALUES
(1, 'kiloan'),
(2, 'selimut'),
(3, 'bed cover'),
(4, 'Kaos'),
(6, 'Celana'),
(8, 'satuan');

-- --------------------------------------------------------

--
-- Struktur dari tabel `log`
--

CREATE TABLE `log` (
  `id_log` int(11) NOT NULL,
  `isi_log` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `tanggal_log` datetime NOT NULL,
  `id_user` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data untuk tabel `log`
--

INSERT INTO `log` (`id_log`, `isi_log`, `tanggal_log`, `id_user`) VALUES
(1, 'Pengguna super_administrator berhasil login', '2020-03-02 14:28:37', 1),
(1101, 'Pengguna ica berhasil ditambahkan', '2023-12-10 16:24:53', 1),
(1102, 'Biodata Pengguna Reissa Giana Azaria berhasil ditambahkan', '2023-12-10 16:26:24', 1),
(1103, 'Paket WoW! Bed cover juga Bisa disini! berhasil diubah', '2023-12-10 16:27:19', 1),
(1104, 'Paket Satuan aja Ya berhasil diubah', '2023-12-10 16:27:49', 1),
(1105, 'Paket Kiloan Biasa Aja berhasil diubah', '2023-12-10 16:28:10', 1),
(1106, 'Pengguna super_administrator berhasil logout', '2023-12-10 16:29:43', 1),
(1107, 'Pengguna ica berhasil login', '2023-12-10 16:29:49', 13),
(1108, 'Transaksi  berhasil diubah status transaksinya', '2023-12-10 16:33:47', 13),
(1109, 'Member Naufal berhasil ditambahkan', '2023-12-10 16:34:58', 13),
(1110, 'Transaksi 1012202311321T0001 berhasil ditambahkan', '2023-12-10 16:35:31', 13),
(1111, 'Detail Transaksi 1012202311321T0001 berhasil ditambahkan', '2023-12-10 16:35:56', 13),
(1112, 'Pengguna ica berhasil logout', '2023-12-10 16:36:24', 13),
(1113, 'Pengguna ica berhasil login', '2023-12-10 16:41:07', 13),
(1114, 'Pengguna ica berhasil logout', '2023-12-10 16:41:21', 13),
(1115, 'Pengguna super_administrator berhasil login', '2023-12-10 16:41:32', 1),
(1116, 'Pengguna super_administrator berhasil logout', '2023-12-10 16:41:44', 1),
(1117, 'Pengguna ica berhasil login', '2023-12-10 16:41:49', 13),
(1118, 'Member Lisia berhasil ditambahkan', '2023-12-10 16:42:54', 13),
(1119, 'Transaksi 090320201112T0011 berhasil diubah', '2023-12-10 16:43:30', 13),
(1120, 'Transaksi  berhasil diubah status transaksinya', '2023-12-10 16:43:40', 13),
(1121, 'Transaksi  berhasil diubah status transaksinya', '2023-12-10 16:43:47', 13),
(1122, 'Transaksi 1012202311322T0002 berhasil ditambahkan', '2023-12-10 16:44:14', 13),
(1123, 'Detail Transaksi 1012202311322T0002 berhasil ditambahkan', '2023-12-10 16:44:23', 13),
(1124, 'Pembayaran Transaksi 1012202311322T0002 berhasil', '2023-12-10 16:44:34', 13),
(1125, 'Cetak Invoice - 1012202311322T0002 - Lisia', '2023-12-10 16:44:40', 13),
(1126, 'Cetak Invoice - 1012202311322T0002 - Lisia', '2023-12-10 16:45:36', 13),
(1127, 'Cetak Invoice - 1012202311322T0002 - Lisia', '2023-12-10 16:45:52', 13),
(1128, 'Cetak Invoice - 1012202311322T0002 - Lisia', '2023-12-10 16:46:01', 13),
(1129, 'Member Mariadi berhasil ditambahkan', '2023-12-10 16:47:45', 13),
(1130, 'Transaksi 1012202311323T0003 berhasil ditambahkan', '2023-12-10 16:48:04', 13),
(1131, 'Detail Transaksi 1012202311323T0003 berhasil ditambahkan', '2023-12-10 16:48:13', 13),
(1132, 'Pembayaran Transaksi 1012202311323T0003 berhasil', '2023-12-10 16:48:30', 13),
(1133, 'Transaksi  berhasil diubah status transaksinya', '2023-12-10 16:48:45', 13),
(1134, 'Transaksi  berhasil diubah status transaksinya', '2023-12-10 16:48:51', 13),
(1135, 'Transaksi  berhasil diubah status transaksinya', '2023-12-10 16:48:58', 13),
(1136, 'Pengguna ica berhasil logout', '2023-12-10 16:50:02', 13),
(1137, 'Pengguna ica berhasil login', '2023-12-10 16:53:07', 13),
(1138, 'Member Joko Kendil berhasil ditambahkan', '2023-12-10 16:54:11', 13),
(1139, 'Transaksi 1012202311324T0004 berhasil ditambahkan', '2023-12-10 16:54:28', 13),
(1140, 'Detail Transaksi 1012202311324T0004 berhasil ditambahkan', '2023-12-10 16:54:36', 13),
(1141, 'Transaksi  berhasil diubah status transaksinya', '2023-12-10 16:55:10', 13),
(1142, 'Transaksi  berhasil diubah status transaksinya', '2023-12-10 16:55:18', 13),
(1143, 'Member Pariaman berhasil ditambahkan', '2023-12-10 16:56:28', 13),
(1144, 'Transaksi 1012202311325T0005 berhasil ditambahkan', '2023-12-10 16:56:41', 13),
(1145, 'Detail Transaksi 1012202311325T0005 berhasil ditambahkan', '2023-12-10 16:56:50', 13),
(1146, 'Transaksi  berhasil diubah status transaksinya', '2023-12-10 17:00:42', 13),
(1147, 'Pengguna ica berhasil logout', '2023-12-10 17:01:05', 13),
(1148, 'Pengguna ica berhasil login', '2023-12-10 17:01:21', 13),
(1149, 'Cetak Laporan - 2023-12-01 00:00:00 - 2023-12-10 23:59:59', '2023-12-10 17:02:05', 13),
(1150, 'Pengguna ica berhasil logout', '2023-12-10 17:04:32', 13),
(1151, 'Pengguna ica berhasil login', '2023-12-10 18:13:00', 13),
(1152, 'Pengguna ica berhasil logout', '2023-12-10 18:13:14', 13);

-- --------------------------------------------------------

--
-- Struktur dari tabel `member`
--

CREATE TABLE `member` (
  `id_member` int(11) NOT NULL,
  `nama_member` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `jenis_kelamin` enum('pria','wanita') COLLATE utf8_unicode_ci NOT NULL,
  `telepon_member` varchar(25) COLLATE utf8_unicode_ci NOT NULL,
  `email_member` varchar(200) COLLATE utf8_unicode_ci DEFAULT NULL,
  `alamat_member` text COLLATE utf8_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data untuk tabel `member`
--

INSERT INTO `member` (`id_member`, `nama_member`, `jenis_kelamin`, `telepon_member`, `email_member`, `alamat_member`) VALUES
(21, 'Naufal', 'pria', '088215178312', 'naufal7@gmail.com', 'JL. Gatoto Subroto, Gg. Wongso No.20, Rt 01, Kel. Tanjung Gading, Kec. Kedamaian'),
(22, 'Lisia', 'wanita', '081234567869', 'lisia11@gmail.com', 'Jl. jalan sore, hehe'),
(23, 'Mariadi', 'pria', '08987654321', 'wedusmariadi@gmail.com', 'Jl. Kambing ente ya'),
(24, 'Joko Kendil', 'pria', '0897867543', 'jokosuper@gmail.com', 'Jl. ne podo mariadi'),
(25, 'Pariaman', 'pria', '081221383933', '', 'Jl. Nasi padang');

-- --------------------------------------------------------

--
-- Struktur dari tabel `outlet`
--

CREATE TABLE `outlet` (
  `id_outlet` int(11) NOT NULL,
  `nama_outlet` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `telepon_outlet` varchar(25) COLLATE utf8_unicode_ci NOT NULL,
  `alamat_outlet` text COLLATE utf8_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data untuk tabel `outlet`
--

INSERT INTO `outlet` (`id_outlet`, `nama_outlet`, `telepon_outlet`, `alamat_outlet`) VALUES
(1, 'Goody Laundry', '085932936891', 'Jl. Bakung No.22, Dero, Condongcatur, Kec. Depok, Kabupaten Sleman, Daerah Istimewa Yogyakarta 55281, Indonesia'),
(2, 'Good Laundry Cab. Tajem', '088215178312', '7C3M+6P5, Jl. Raya Tajem, Tajem, Maguwoharjo, Kec. Depok, Kabupaten Sleman, Daerah Istimewa Yogyakarta 55281, Indonesia');

-- --------------------------------------------------------

--
-- Struktur dari tabel `paket`
--

CREATE TABLE `paket` (
  `id_paket` int(11) NOT NULL,
  `nama_paket` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `harga_paket` int(11) NOT NULL,
  `id_outlet` int(11) NOT NULL,
  `id_jenis_paket` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data untuk tabel `paket`
--

INSERT INTO `paket` (`id_paket`, `nama_paket`, `harga_paket`, `id_outlet`, `id_jenis_paket`) VALUES
(1, 'Kiloan Biasa Aja', 7500, 1, 1),
(2, 'Satuan aja Ya', 3500, 1, 8),
(3, 'WoW! Bed cover juga Bisa disini!', 25000, 1, 3),
(4, 'Reguler Kiloan', 7000, 2, 1),
(5, 'Reguler Satuan', 2500, 2, 8),
(6, 'Kiloan Raja Laut', 10000, 2, 1);

-- --------------------------------------------------------

--
-- Struktur dari tabel `pembayaran`
--

CREATE TABLE `pembayaran` (
  `id_pembayaran` int(11) NOT NULL,
  `id_transaksi` int(11) NOT NULL,
  `id_user` int(11) NOT NULL,
  `total_harga` int(11) NOT NULL,
  `uang_yg_dibayar` int(11) NOT NULL,
  `kembalian` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data untuk tabel `pembayaran`
--

INSERT INTO `pembayaran` (`id_pembayaran`, `id_transaksi`, `id_user`, `total_harga`, `uang_yg_dibayar`, `kembalian`) VALUES
(29, 48, 13, 53700, 60000, 6300),
(30, 49, 13, 90200, 100000, 9800);

-- --------------------------------------------------------

--
-- Struktur dari tabel `transaksi`
--

CREATE TABLE `transaksi` (
  `id_transaksi` int(11) NOT NULL,
  `kode_invoice` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `tanggal_transaksi` datetime NOT NULL,
  `batas_waktu` datetime NOT NULL,
  `tanggal_bayar` datetime NOT NULL,
  `biaya_tambahan` int(11) NOT NULL,
  `diskon` float NOT NULL,
  `pajak` int(11) NOT NULL,
  `status_transaksi` enum('proses','dicuci','siap diambil','sudah diambil') COLLATE utf8_unicode_ci NOT NULL,
  `status_bayar` enum('belum dibayar','sudah dibayar') COLLATE utf8_unicode_ci NOT NULL,
  `id_member` int(11) NOT NULL,
  `id_outlet` int(11) NOT NULL,
  `id_user` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data untuk tabel `transaksi`
--

INSERT INTO `transaksi` (`id_transaksi`, `kode_invoice`, `tanggal_transaksi`, `batas_waktu`, `tanggal_bayar`, `biaya_tambahan`, `diskon`, `pajak`, `status_transaksi`, `status_bayar`, `id_member`, `id_outlet`, `id_user`) VALUES
(47, '1012202311321T0001', '2023-12-10 16:35:31', '2023-12-10 16:35:00', '0000-00-00 00:00:00', 5000, 10, 10, 'dicuci', 'belum dibayar', 21, 1, 13),
(48, '1012202311322T0002', '2023-12-10 16:44:14', '2023-12-10 16:43:00', '2023-12-10 16:44:34', 20000, 20, 10, 'proses', 'sudah dibayar', 22, 1, 13),
(49, '1012202311323T0003', '2023-12-10 16:48:04', '2023-12-10 16:47:00', '2023-12-10 16:48:30', 0, 0, 10, 'sudah diambil', 'sudah dibayar', 23, 1, 13),
(50, '1012202311324T0004', '2023-12-10 16:54:28', '2023-12-10 16:54:00', '0000-00-00 00:00:00', 2000, 0, 10, 'siap diambil', 'belum dibayar', 24, 1, 13),
(51, '1012202311325T0005', '2023-12-10 16:56:41', '2023-12-10 16:56:00', '0000-00-00 00:00:00', 0, 0, 10, 'dicuci', 'belum dibayar', 25, 1, 13);

-- --------------------------------------------------------

--
-- Struktur dari tabel `user`
--

CREATE TABLE `user` (
  `id_user` int(11) NOT NULL,
  `username` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `password` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `id_outlet` int(11) NOT NULL,
  `id_jabatan` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data untuk tabel `user`
--

INSERT INTO `user` (`id_user`, `username`, `password`, `id_outlet`, `id_jabatan`) VALUES
(1, 'super_administrator', '$2y$10$.zk2CNXlXauzDhI38F721.2ExLvw3hvDxE4hA.v/m.ANSGrPiPleC', 1, 1),
(13, 'ica', '$2y$10$qeA2RVqM9EJWDEjseXllzu5zdacwMkHc/TpBYMSIuYtlyLxdV0Y3q', 1, 2);

--
-- Indexes for dumped tables
--

--
-- Indeks untuk tabel `biodata`
--
ALTER TABLE `biodata`
  ADD PRIMARY KEY (`id_biodata`),
  ADD KEY `id_user` (`id_user`);

--
-- Indeks untuk tabel `detail_transaksi`
--
ALTER TABLE `detail_transaksi`
  ADD PRIMARY KEY (`id_detail_transaksi`),
  ADD KEY `id_transaksi` (`id_transaksi`),
  ADD KEY `id_paket` (`id_paket`);

--
-- Indeks untuk tabel `jabatan`
--
ALTER TABLE `jabatan`
  ADD PRIMARY KEY (`id_jabatan`);

--
-- Indeks untuk tabel `jenis_paket`
--
ALTER TABLE `jenis_paket`
  ADD PRIMARY KEY (`id_jenis_paket`);

--
-- Indeks untuk tabel `log`
--
ALTER TABLE `log`
  ADD PRIMARY KEY (`id_log`),
  ADD KEY `id_user` (`id_user`);

--
-- Indeks untuk tabel `member`
--
ALTER TABLE `member`
  ADD PRIMARY KEY (`id_member`);

--
-- Indeks untuk tabel `outlet`
--
ALTER TABLE `outlet`
  ADD PRIMARY KEY (`id_outlet`);

--
-- Indeks untuk tabel `paket`
--
ALTER TABLE `paket`
  ADD PRIMARY KEY (`id_paket`),
  ADD KEY `id_outlet` (`id_outlet`),
  ADD KEY `id_jenis_paket` (`id_jenis_paket`);

--
-- Indeks untuk tabel `pembayaran`
--
ALTER TABLE `pembayaran`
  ADD PRIMARY KEY (`id_pembayaran`),
  ADD KEY `id_transaksi` (`id_transaksi`),
  ADD KEY `id_user` (`id_user`);

--
-- Indeks untuk tabel `transaksi`
--
ALTER TABLE `transaksi`
  ADD PRIMARY KEY (`id_transaksi`),
  ADD KEY `id_member` (`id_member`),
  ADD KEY `id_outlet` (`id_outlet`),
  ADD KEY `id_user` (`id_user`);

--
-- Indeks untuk tabel `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`id_user`),
  ADD KEY `id_outlet` (`id_outlet`),
  ADD KEY `id_jabatan` (`id_jabatan`);

--
-- AUTO_INCREMENT untuk tabel yang dibuang
--

--
-- AUTO_INCREMENT untuk tabel `biodata`
--
ALTER TABLE `biodata`
  MODIFY `id_biodata` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT untuk tabel `detail_transaksi`
--
ALTER TABLE `detail_transaksi`
  MODIFY `id_detail_transaksi` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=78;

--
-- AUTO_INCREMENT untuk tabel `jabatan`
--
ALTER TABLE `jabatan`
  MODIFY `id_jabatan` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT untuk tabel `jenis_paket`
--
ALTER TABLE `jenis_paket`
  MODIFY `id_jenis_paket` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT untuk tabel `log`
--
ALTER TABLE `log`
  MODIFY `id_log` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1153;

--
-- AUTO_INCREMENT untuk tabel `member`
--
ALTER TABLE `member`
  MODIFY `id_member` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- AUTO_INCREMENT untuk tabel `outlet`
--
ALTER TABLE `outlet`
  MODIFY `id_outlet` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT untuk tabel `paket`
--
ALTER TABLE `paket`
  MODIFY `id_paket` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT untuk tabel `pembayaran`
--
ALTER TABLE `pembayaran`
  MODIFY `id_pembayaran` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=31;

--
-- AUTO_INCREMENT untuk tabel `transaksi`
--
ALTER TABLE `transaksi`
  MODIFY `id_transaksi` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=52;

--
-- AUTO_INCREMENT untuk tabel `user`
--
ALTER TABLE `user`
  MODIFY `id_user` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- Ketidakleluasaan untuk tabel pelimpahan (Dumped Tables)
--

--
-- Ketidakleluasaan untuk tabel `biodata`
--
ALTER TABLE `biodata`
  ADD CONSTRAINT `biodata_ibfk_1` FOREIGN KEY (`id_user`) REFERENCES `user` (`id_user`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ketidakleluasaan untuk tabel `detail_transaksi`
--
ALTER TABLE `detail_transaksi`
  ADD CONSTRAINT `detail_transaksi_ibfk_1` FOREIGN KEY (`id_transaksi`) REFERENCES `transaksi` (`id_transaksi`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `detail_transaksi_ibfk_2` FOREIGN KEY (`id_paket`) REFERENCES `paket` (`id_paket`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ketidakleluasaan untuk tabel `log`
--
ALTER TABLE `log`
  ADD CONSTRAINT `log_ibfk_1` FOREIGN KEY (`id_user`) REFERENCES `user` (`id_user`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ketidakleluasaan untuk tabel `paket`
--
ALTER TABLE `paket`
  ADD CONSTRAINT `paket_ibfk_1` FOREIGN KEY (`id_jenis_paket`) REFERENCES `jenis_paket` (`id_jenis_paket`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `paket_ibfk_2` FOREIGN KEY (`id_outlet`) REFERENCES `outlet` (`id_outlet`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ketidakleluasaan untuk tabel `pembayaran`
--
ALTER TABLE `pembayaran`
  ADD CONSTRAINT `pembayaran_ibfk_1` FOREIGN KEY (`id_user`) REFERENCES `user` (`id_user`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `pembayaran_ibfk_2` FOREIGN KEY (`id_transaksi`) REFERENCES `transaksi` (`id_transaksi`) ON DELETE NO ACTION ON UPDATE CASCADE;

--
-- Ketidakleluasaan untuk tabel `transaksi`
--
ALTER TABLE `transaksi`
  ADD CONSTRAINT `transaksi_ibfk_1` FOREIGN KEY (`id_outlet`) REFERENCES `outlet` (`id_outlet`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `transaksi_ibfk_2` FOREIGN KEY (`id_user`) REFERENCES `user` (`id_user`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `transaksi_ibfk_3` FOREIGN KEY (`id_member`) REFERENCES `member` (`id_member`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ketidakleluasaan untuk tabel `user`
--
ALTER TABLE `user`
  ADD CONSTRAINT `user_ibfk_1` FOREIGN KEY (`id_outlet`) REFERENCES `outlet` (`id_outlet`),
  ADD CONSTRAINT `user_ibfk_2` FOREIGN KEY (`id_jabatan`) REFERENCES `jabatan` (`id_jabatan`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
