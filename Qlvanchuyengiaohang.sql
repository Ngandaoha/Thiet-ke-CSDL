CREATE DATABASE Quanlygiaohangnhanh;
USE Quanlygiaohangnhanh;
-- TAO BANG
-- table 1: Khach hang
DROP TABLE IF EXISTS khach_hang;
CREATE TABLE khach_hang(
	id_khach_hang VARCHAR(20) PRIMARY KEY,
	ten_khach_hang NVARCHAR(50) NOT NULL UNIQUE, 
	so_dien_thoai_khach CHAR(20) NOT NULL UNIQUE,
	email NVARCHAR(100) NOT NULL UNIQUE,
	dia_chi_nhan VARCHAR(100) NOT NULL
);
-- table 2: Kho hàng
DROP TABLE IF EXISTS kho_hang;
CREATE TABLE kho_hang(
	id_kho VARCHAR(20) PRIMARY KEY,
	ten_kho NVARCHAR(50) NOT NULL,
	dia_chi_kho NVARCHAR(100) NOT NULL
);
-- table 3: Nhân viên kho
DROP TABLE IF EXISTS nhan_vien_kho;
CREATE TABLE nhan_vien_kho(
	id_nhan_vien_kho VARCHAR(20) PRIMARY KEY,
	id_kho VARCHAR(20) NOT NULL,
	ten_nhan_vien_kho NVARCHAR(50) NOT NULL UNIQUE, 
	ngay_sinh DATE NOT NULL,
	FOREIGN KEY (id_kho) REFERENCES kho_hang (id_kho) ON DELETE CASCADE ON UPDATE CASCADE
);
-- table 4: Nhân viên giao hàng
DROP TABLE IF EXISTS nhan_vien_giao_hang;
CREATE TABLE nhan_vien_giao_hang(
	id_nhan_vien_giao VARCHAR(20) PRIMARY KEY,
	id_xe_giao VARCHAR(20) UNIQUE,
	ten_nhan_vien_giao NVARCHAR(50) NOT NULL UNIQUE, 
	ngay_sinh DATE NOT NULL	
);
-- table 5: Dịch vụ 
DROP TABLE IF EXISTS dich_vu;
CREATE TABLE dich_vu(
	id_dich_vu VARCHAR(20) PRIMARY KEY,
	ten_dich_vu NVARCHAR(50) NOT NULL UNIQUE
);
-- table 6: Loại mặt hàng
DROP TABLE IF EXISTS loai_mat_hang;
CREATE TABLE loai_mat_hang(
	id_loai_mat_hang VARCHAR(20) PRIMARY KEY,
	ten_mat_hang NVARCHAR(50) NOT NULL UNIQUE
);
-- table 7: Đơn hàng và giao hàng
DROP TABLE IF EXISTS don_hang_va_giao_hang;
CREATE TABLE don_hang_va_giao_hang(
	id_don_hang_giao VARCHAR(20) PRIMARY KEY,
	id_khu_vuc VARCHAR(20) NOT NULL,
	id_khach_hang VARCHAR(20) NOT NULL, 
	id_nhan_vien_giao VARCHAR(20),	
	id_dich_vu VARCHAR(20) NOT NULL,
	so_dien_thoai_khach CHAR(20) NOT NULL,
	dia_chi_nhan NVARCHAR(100) NOT NULL,
	trang_thai_duyet NVARCHAR(50) NOT NULL,
	trang_thai_giao NVARCHAR(50) NOT NULL,	
	phuong_thuc_thanh_toan NVARCHAR(50),
	thoi_gian_giao DATETIME,
	thoi_gian_nhan DATETIME,
	FOREIGN KEY (id_dich_vu) REFERENCES dich_vu (id_dich_vu) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (id_khach_hang) REFERENCES khach_hang (id_khach_hang) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (id_nhan_vien_giao) REFERENCES nhan_vien_giao_hang (id_nhan_vien_giao) ON DELETE CASCADE ON UPDATE CASCADE
);
-- table 8: Chi tiết đơn hàng
DROP TABLE IF EXISTS chi_tiet_don_hang;
CREATE TABLE chi_tiet_don_hang(
	id_chi_tiet_don_hang VARCHAR(20) PRIMARY KEY,
	id_don_hang_giao VARCHAR(20) NOT NULL,
	id_loai_mat_hang VARCHAR(20),
	ten_don_hang NVARCHAR(50),
	so_luong INT NOT NULL,
	trong_luong DOUBLE PRECISION NOT NULL,
	tien_thu_ho MONEY,	
	FOREIGN KEY (id_don_hang_giao) REFERENCES don_hang_va_giao_hang (id_don_hang_giao) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (id_loai_mat_hang) REFERENCES loai_mat_hang (id_loai_mat_hang) ON DELETE CASCADE ON UPDATE CASCADE
);
-- table 9: Lương
DROP TABLE IF EXISTS luong;
CREATE TABLE luong(
	id_nhan_vien_giao VARCHAR(20),
	id_nhan_vien_kho VARCHAR(20),
	so_buoi_lam INT NOT NULL,
	luong_cung MONEY NOT NULL,
	luong_linh MONEY,
	FOREIGN KEY (id_nhan_vien_giao) REFERENCES nhan_vien_giao_hang (id_nhan_vien_giao) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (id_nhan_vien_kho) REFERENCES nhan_vien_kho (id_nhan_vien_kho) ON DELETE CASCADE ON UPDATE CASCADE
);

-- TAO VIEW
-- view 1: DS Nhân viên giao hàng --
CREATE VIEW ds_nhan_vien_giao_hang
AS
  SELECT id_nhan_vien_giao, ten_nhan_vien_giao, ngay_sinh
  FROM nhan_vien_giao_hang
GO

SELECT * FROM ds_nhan_vien_giao_hang
-- view 2: DS Nhân viên kho hàng --
CREATE VIEW ds_nhan_vien_kho 
AS
  SELECT id_nhan_vien_kho, ten_nhan_vien_kho, ngay_sinh
  FROM nhan_vien_kho
GO

SELECT * FROM ds_nhan_vien_kho
-- view 3: Bảng lương nhân viên giao hàng --
CREATE VIEW bang_luong_nhan_vien_giao_hang
AS
  SELECT GH.id_nhan_vien_giao, GH.ten_nhan_vien_giao, L.so_buoi_lam, L.luong_cung, L.luong_linh
  FROM nhan_vien_giao_hang GH INNER JOIN luong L
       ON GH.id_nhan_vien_giao = L.id_nhan_vien_giao
GO

SELECT * FROM bang_luong_nhan_vien_giao_hang
-- view 4: Bảng lương nhân viên kho hàng --
CREATE VIEW bang_luong_nhan_vien_kho
AS
  SELECT KH.id_nhan_vien_kho,  KH.ten_nhan_vien_kho, L.so_buoi_lam, L.luong_cung, L.luong_linh
  FROM nhan_vien_kho KH INNER JOIN luong L
       ON KH.id_nhan_vien_kho = L.id_nhan_vien_kho
GO

SELECT * FROM bang_luong_nhan_vien_kho
-- view 5: Bảng lương nhân viên --
CREATE VIEW bang_luong
AS 
  SELECT id_nhan_vien_giao, id_nhan_vien_kho, so_buoi_lam, luong_cung, luong_linh
  FROM luong
GO

SELECT * FROM bang_luong
-- view 6: DS Khách hàng --
CREATE VIEW ds_khach_hang 
AS
  SELECT id_khach_hang, ten_khach_hang, so_dien_thoai_khach, email, dia_chi_nhan
  FROM khach_hang
GO

SELECT * FROM ds_khach_hang
﻿-- view 7: DS dịch vụ --
CREATE VIEW ds_dich_vu
AS
  SELECT id_dich_vu, ten_dich_vu
  FROM dich_vu
GO

SELECT * FROM ds_dich_vu

--CAC TRUY VAN
-- query 1: Thêm nhân viên giao hàng --
INSERT INTO nhan_vien_giao_hang
VALUES ('DMVN001', 'RTX3900', N'Đặng Thùy Anh', '12/05/2002'),
       ('DMVN002', 'RTX3901', N'Vũ Thị Linh', '01/06/2001'),
	   ('DMVN003', 'RTX3902', N'Nguyễn Văn Anh', '09/08/1998'),
	   ('DMVN004', 'RTX3903', N'Hồ Ngọc Hải', '11/03/2001'),
	   ('DMVN005', 'RTX3904', N'Đinh Thị Tú', '02/11/1999')
SELECT * FROM nhan_vien_giao_hang
-- query 2.1: Xóa toàn bộ dữ liệu nhân viên giao hàng --
DELETE FROM nhan_vien_giao_hang

SELECT * FROM nhan_vien_giao_hang
-- query 2.2: Xóa có điều kiện dữ liệu nhân viên giao hàng --
DELETE FROM nhan_vien_giao_hang
WHERE id_nhan_vien_giao = 'DMVN004'

SELECT * FROM nhan_vien_giao_hang
-- query 3: Thêm dữ liệu kho --
INSERT INTO kho_hang
VALUES ('DLK001', 'Kho HH1', N'Hà Đông'),
       ('DLK002', 'Kho HH2', N'Cầu Giấy'),
	   ('DLK003', 'Kho HH3', N'Ba Đình'),
	   ('DLK004', 'Kho HH4', 'Thanh Oai'),
	   ('DLK005', 'Kho HH5', N'Đống Đa')
SELECT * FROM kho_hang
﻿-- query 4: Thêm nhân viên kho hàng --
INSERT INTO nhan_vien_kho
VALUES ('XK001', 'DLK001', N'Hồ Thị Hà Anh','02/10/1998'),
       ('XK002', 'DLK002', N'Vũ Văn Đức', '12/03/2002'),
	   ('XK003', 'DLK003', N'Nguyễn Thị Vân Anh', '12/12/1988'),
	   ('XK004', 'DLK004', N'Trịnh Thùy Linh', '11/15/1999'),
	   ('XK005', 'DLK005', N'Lê Thị Ngọc', '10/20/2001')
SELECT * FROM nhan_vien_kho
-- query 5.1: Xóa toàn bộ dữ liệu nhân viên kho hàng --
DELETE FROM nhan_vien_kho

SELECT * FROM nhan_vien_kho
-- query 5.2: Xóa có điều kiện dữ liệu nhân viên kho hàng --
DELETE FROM nhan_vien_kho
WHERE ten_nhan_vien_kho = N'Trịnh Thùy Linh'

SELECT * FROM nhan_vien_kho
-- query 6: Thêm dữ liệu lương --
-- SELECT  * FROM nhan_vien_giao_hang
INSERT INTO luong (id_nhan_vien_giao, so_buoi_lam, luong_cung)
VALUES ('DMVN001', 28, 700000),
       ('DMVN002', 30, 700000),
	   ('DMVN003', 25, 700000),
	   ('DMVN004', 30, 700000),
	   ('DMVN005', 29, 700000)

-- SELECT * FROM nhan_vien_kho --
INSERT INTO luong (id_nhan_vien_kho, so_buoi_lam, luong_cung)
VALUES ('XK001', 30, 500000),
       ('XK002', 25, 500000),
	   ('XK003', 27, 500000),
	   ('XK004', 28, 500000),
	   ('XK005', 29, 500000)
UPDATE luong
SET luong_linh = so_buoi_lam * luong_cung;
SELECT * FROM luong
-- query 7: Thêm khách hàng --
INSERT INTO khach_hang
VALUES ('PPKH001', N'Đặng Thị Lệ Quyên', '0923587239', N'An Lão, Hải Phòng', 'lequyen@gmail.com'),
       ('PPKH002', N'Nguyễn Thị Hạnh', '0823567188', N'Tứ Kỳ, Hải Dương', 'nthanh88@gmail.com'),
	   ('PPKH003', N'Vũ Minh Đức', '0258765358', N'Hoài Đức, Hà Nội', 'ducdz2510@gmail.com'),
	   ('PPKH004', N'Đoàn Bá Anh', '0335892351', N'Phủ Lý, Hà Nam', 'azenka@gmail.com'),
	   ('PPKH005', N'Phan Thị Ngọc Bích', '0223578789', N'Thủy Nguyên, Hải Phòng', 'phanthingocbich@gmail.com')
SELECT * FROM khach_hang
-- query 8: Thêm dữ liệu dịch vụ --
INSERT INTO dich_vu
VALUES ('DV001', N'Không thu phí'),
       ('DV002', N'Người gửi thanh toán'),
	   ('DV003', N'Người nhận thanh toán')
SELECT * FROM dich_vu
﻿-- query 9: Thêm dữ liệu loại mặt hàng --
INSERT INTO loai_mat_hang
VALUES ('LMH01', N'Đồ điện tử'),
       ('LMH02', N'Đồ dùng thiết yếu'),
	   ('LMH03', N'Mỹ phẩm'), 
	   ('LMH04', N'Quần áo'), 
	   ('LMH05', N'Thực phẩm')
SELECT * FROM loai_mat_hang
﻿-- query 10: Thêm dữ liệu đơn hàng và giao hàng --
INSERT INTO don_hang_va_giao_hang
VALUES ('DGH001', 'KV01', 'PPKH001', 'DMVN001', 'DV001', '0923587239', N'An Lão, Hải Phòng', N'Đã phê duyệt', N'Đã giao hàng', NULL, '05/30/2023 09:12', '06/03/2023 10:15'),
       ('DGH002', 'KV02', 'PPKH002', 'DMVN002', 'DV003', '0823567188', N'Tứ Kỳ, Hải Dương', N'Đã phê duyệt', N'Chưa giao hàng', N'Tiền mặt', '06/05/2023 08:00', NULL),
	   ('DGH003', 'KV02', 'PPKH003', 'DMVN002', 'DV003', '0258765358', N'Hoài Đức, Hà Nội', N'Đã phê duyệt', N'Đã giao hàng', N'Chuyển khoản', '06/15/2023 13:05', '06/17/2023 18:20'),
	   ('DGH004', 'KV03', 'PPKH004', 'DMVN003', 'DV002', '0335892351', N'Phủ Lý, Hà Nam', N'Chưa phê duyệt', N'Chưa giao hàng', NULL, NULL,NULL),
	   ('DGH005', 'KV05', 'PPKH005', 'DMVN005', 'DV003', '0223578789', N'Thủy Nguyên, Hải Phòng', N'Đã phê duyệt', N'Đã giao hàng', N'Chuyển khoản', '08/12/2023 15:30', '08/13/2023 07:45')
SELECT * FROM don_hang_va_giao_hang
﻿-- query 11: Thêm chi tiết đơn hàng --
INSERT INTO chi_tiet_don_hang
VALUES ('CTDH001', 'DGH001', 'LMH01', 'Laptop', 02, 5, 0),
       ('CTDH002', 'DGH002', 'LMH02', N'Bộ dụng cụ bếp', 01, 1.5, 350000),
	   ('CTDH003', 'DGH003', 'LMH03', N'Nước tẩy trang', 01, 0.25, 3700000),
	   ('CTDH004', 'DGH004', 'LMH04', N'Quần jean đen', 02, 0.2, 0),
	   ('CTDH005', 'DGH005', 'LMH05', N'Gạo ST-25', 03, 15, 750000)
SELECT * FROM chi_tiet_don_hang
