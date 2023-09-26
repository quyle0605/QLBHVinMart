--Tạo cơ sở dữ liệu
create database QuanLyBanHangVinMart
go
use QuanLyBanHangVinMart
go
--Tạo bảng thực thể nhân viên
create table NHANVIEN
(
MaNV nvarchar(10),
HoNV nvarchar(20),
TenNV nvarchar(20),
GioiTinh nvarchar(20),
NgaySinh date,
DiaChi nvarchar(100),
DienThoai nvarchar(30),
Email nvarchar(100),
constraint Pk_NHANVIEN primary key(MaNV),
constraint duynhat_DienThoaiNV unique(DienThoai)
)
go
--Tạo bảng thực thể khách hàng
create table KHACHHANG
(
MaKH nvarchar(10),
HoKH nvarchar(20),
TenKH nvarchar(20),
DiaChi nvarchar(100),
DienThoai nvarchar(30),
Email nvarchar(100),
constraint Pk_KHACHHANG primary key(MaKH),
constraint duynhat_DienThoaiKH unique(DienThoai)
)
go
--Tạo bảng thực thể nhà cung cấp
create table NHACUNGCAP
(
MaNCC nvarchar(10),
TenNCC nvarchar(100),
DiaChi nvarchar(100),
Email nvarchar(100),
DienThoai nvarchar(30),
constraint Pk_NHACUNGCAP primary key(MaNCC)
)
go
--Tạo bảng thực thể loại sản phẩm
create table LOAISANPHAM
(
MaLoaiSP nvarchar(10),
TenLoaiSP nvarchar(100),
constraint Pk_LOAISANPHAM primary key(MaLoaiSP)
)
go
--Tạo bảng thực thể sản phẩm
create table SANPHAM
(
MaSP nvarchar(10),
TenSP nvarchar(100),
DgBan float,
DonViTinh nvarchar(20),
SlTon float DEFAULT 0,
MaLoaiSP nvarchar(10),
constraint Pk_SANPHAM primary key(MaSP)
)
go
--Tạo bảng thực thể hóa đơn
create table HOADON
(
MaHD nvarchar(10),
MaKH nvarchar(10),
MaNV nvarchar(10),
NgayLapHD date DEFAULT (GETDATE()),
constraint Pk_HOADON primary key(MaHD)
)
go
--Tạo bảng thực thể chi tiết hóa đơn
create table CTHOADON
(
MaHD nvarchar(10),
MaSP nvarchar(10),
DgBan float,
SlBan float DEFAULT 1
)
go
--Tạo bảng thực thể phiếu nhập
create table PHIEUNHAP
(
MaPN nvarchar(10),
MaNCC nvarchar(10),
NgayNhap date DEFAULT (GETDATE()),
constraint Pk_PHIEUNHAP primary key(MaPN)
)
go
--Tạo bảng thực thể chi tiết phiếu nhập 
create table CTPHIEUNHAP
(
MaPN nvarchar(10),
MaSP nvarchar(10),
DgNhap float,
SlNhap float DEFAULT 1,
constraint Pk_CTPHIEUNHAP primary key(MaPN, MaSP))
go
--Tạo bảng thực thể tài khoản 
create table ACCOUNT
(
Usename nvarchar(30),
Password varchar(30),
Type  nvarchar(20),
constraint Pk_ACCOUNT primary key (Usename))
go
alter table HOADON
add constraint fk_MaNV_HD foreign key (MaNV) references NHANVIEN(MaNV),
	constraint fk_MaKH_HD foreign key (MaKH) references KHACHHANG(MaKH)
go
alter table CTHOADON
add constraint fk_MaHD_CTHD foreign key (MaHD) references HOADON(MaHD),
	constraint fk_MaSP_CTHD foreign key (MaSP) references SANPHAM(MaSP)
go
alter table SANPHAM
add constraint fk_MaLoaiSP_SP foreign key (MaLoaiSP) references LOAISANPHAM(MaLoaiSP)
go
alter table PHIEUNHAP
add constraint fk_MaNCC_PN foreign key (MaNCC) references NHACUNGCAP(MaNCC)
go
alter table CTPHIEUNHAP 
add constraint fk_MaPN_CTPN foreign key (MaPN) references PHIEUNHAP(MaPN),
	constraint fk_MaPN_SP foreign key (MaSP) references SANPHAM(MaSP)
go
/*Insert thông tin*/
/*Insert thông tin bảng nhân viên*/
insert into NHANVIEN 
values 
('NV0001',N'Lê Thị',N'Cúc',N'Nữ','1985/5/4',N'Lô C, phòng 28','0929879827','cuclt@gmail.com'),
('NV0002',N'Mai Minh',N'Mẫn',N'Nữ','1990/7/3',N'78/12/8/Tân Hội','0987897989',',manmm@gmail.com'),
('NV0003',N'Võ Tú',N'Hoàng',N'Nam','2000/8/9',N'178/An Dương','0912342324','hoangvt@gmail.com'),
('NV0004',N'Trần Hữu',N'Thắng',N'Nam','1985/12/5',N'50 Nguyễn Du','0926786738','thangth@gmail.com'),
('NV0005',N'Lê Thị Diệu',N'Yến',N'Nữ','1989/4/5',N'Quảng Bình','0929874857','dieuyen@gmail.com'),
('NV0006',N'Nguyễn Duy',N'Thăng',N'Nam','1987/5/4',N'Gò Vấp','0983566657','nguyenduy@gmail.com'),
('NV0007',N'Nguyễn Việt',N'Hùng',N'Nam','1990/5/23',N'Quận 9, Hồ Chí Minh','0984577654','nguyenviethung@gmail.com'),
('NV0008',N'Nguyễn Thị Hồng',N'Hoa',N'Nữ','1986/12/7',N'Bình Dương','0984265694','honghoa@gmail.com'),
('NV0009',N'Đỗ Việt',N'Long',N'Nam','1988/5/14',N'Bình Thạch','0984566825','vietlong@gmail.com'),
('NV0010',N'Huỳnh Hoàng',N'Hải',N'Nam','1999/7/23',N'Bình Thuận','0984450654','hoanghai@gmail.com')
go 
/*Insert thông tin bảng khách hàng*/
insert into KHACHHANG
values 
('KH0001',N'Lê Thị',N'Hoa',N'Quận Thủ Đức, Hồ Chí Minh','0929849877','lethihoa@gmail.com'),
('KH0002',N'Mai Minh',N'Trí',N'Quận Tân Bình, Hồ Chí Minh','0981897989',',nguyenminhtri@gmail.com'),
('KH0003',N'Đỗ Hoàng',N'Tú',N'178/An Dương','0915342345','dohoangtu@gmail.com'),
('KH0004',N'Trần Thị',N'Hoa',N'50 Nguyễn Du','0924786787','tranthihoa@gmail.com'),
('KH0005',N'Lê Thị',N'Lý',N'Quảng Bình','0929864870','lethily@gmail.com'),
('KH0006',N'Nguyễn Huy',N'Thăng',N'Gò Vấp','0983566572','nguyenhuythang@gmail.com'),
('KH0007',N'Nguyễn Việt',N'Hùng',N'Quận 9, Hồ Chí Minh','0984576541','nguyenviethung@gmail.com'),
('KH0008',N'Nguyễn Thị Hồng',N'Hoa',N'Bình Dương','0984266945','honghoa@gmail.com'),
('KH0009',N'Đỗ Việt',N'Long',N'Bình Thạch','0984566225','vietlong@gmail.com'),
('KH0010',N'Huỳnh Hoàng',N'Việt',N'Bình Thuận','0984456534','hoangviet@gmail.com')
go
/*Insert thông tin bảng Mhà cung cấp*/
insert into NHACUNGCAP
values 
('NCC001',N'Công Ty TNHH MTV Nông Lâm Sản Thành Nam',N'66D, quận 2, Hồ Chí Minh','mtvhcm@gmail.com','0869843814'),
('NCC002',N'Công Ty TNHH Thực Phẩm Nông Sản Miền Nam',N'quận 12, Hồ Chí Minh','tpnsvn@gmail.com','0869784184'),
('NCC003',N'CÔNG TY CỔ PHẦN HÀNG TIÊU DÙNG MASAN',N'22E,Tân Bình, Hồ Chí Minh','masan@gmail.com','0867844814'),
('NCC004',N'Công ty TNHH Dầu thực vật Cái Lân',N'Tân Bình, Hồ Chí Minh','cailan@gmail.com','0986885793'),
('NCC005',N'Công ty CP Acecook Việt Nam',N'77A,Tân Bình, Hồ Chí Minh','acecook@gmail.com','0986884785'),
('NCC006',N'Công Ty CP Kỹ Nghệ Thực Phẩm Việt Nam (VIFON)',N'71A, Bình Chánh, Hồ Chí Minh','vifon@gmail.com','0996884785'),
('NCC007',N'Công Ty Cổ Phần DUTUCO',N'71C,quận 5, Hồ Chí Minh','dutuco@gmail.com','0996884585'),
('NCC008',N'Công Ty Tnhh Big Chocolate',N'52D,Gò Vấp, Hồ Chí Minh','bigchocolate@gmail.com','0996884512'),
('NCC009',N'Công Ty CP AVE GROUP',N'42B,Gò Vấp, Hồ Chí Minh','cpave@gmail.com','0996884512'),
('NCC010',N'Công Ty Cổ Phần Thương Mại Imexco Việt Nam',N'11B,Bình Tân, Hồ Chí Minh','imexco@gmail.com','0996884512')
go
/*Insert thông tin bảng Loại Sản phẩm*/
insert into LOAISANPHAM
values 
('Khac',N'Khác'),
('TT',N'Truyện Tranh'),
('VPP',N'Văn phòng phẩm'),
('TPX',N'Thực phẩm xanh'),
('DU',N'Đồ uống'),
('DAN',N'Đồ ăn nhanh'),
('DAL',N'Đồ ăn lạnh'),
('TPK',N'Thực phẩm kho'),
('SPH',N'Sản phẩm hộp'),
('GV',N'Gia vị'),
('MP',N'Mỹ phẩm'),
('GD',N'Gia dụng'),
('DC',N'Đồ chơi'),
('RB',N'Rựợu Bia'),
('TPT',N'Thực phẩm tươi'),
('TY',N'Thiết yếu'),
('VTYT',N'Vật tư y tế')
go
/*Insert thông tin bảng Sản phẩm*/
insert into SANPHAM
values 
('SP0001',N'Dầu ăn',56000,N'Chai',50,'GV'),
('SP0002',N'Bột canh gà angon 200g',6000,N'Gói',60,'GV'),
('SP0003',N'Bút bi',6000,N'Cây',52,'VPP'),
('SP0004',N'Vở',15000,N'Cây',45,'VPP'),
('SP0005',N'Truyện tranh thiếu nhi',52000,N'Quyển',43,'TT'),
('SP0006',N'Conan',56000,N'Quyển',56,'TT'),
('SP0007',N'Rau muống',10000,N'Kg',102,'TPX'),
('SP0008',N'Bắp cải',12000,N'Kg',75,'TPX'),
('SP0009',N'Coca Cola',12000,N'chai',102,'DU'),
('SP0010',N'Chanh muối',14000,N'chai',50,'DU'),
('SP0011',N'Snack Cua',8000,N'Cái',63,'DAN'),
('SP0012',N'Snack Khoai Tây',10000,N'Cái',23,'DAN'),
('SP0013',N'Kem Oreo',13000,N'Cái',56,'DAL'),
('SP0014',N'Kem Bơ',26000,N'Cái',12,'DAL'),
('SP0015',N'Sửa rửa mặt Simple',75000,N'Chai',62,'MP'),
('SP0016',N'Sửa rửa mặt Cerave ',89000,N'Chai',23,'MP'),
('SP0017',N'Thịt heo',150000,N'Kg',41,'TPT'),
('SP0018',N'Thịt gà',200000,N'Kg',90,'TPT'),
('SP0019',N'Khẩu trang',75000,N'Hộp',210,'VTYT'),
('SP0020',N'Kem đánh răng PS',34000,N'Hộp',63,'TY')
go
/*Insert thông tin bảng Hóa đơn*/
insert into HOADON
values 
('HD0001','KH0005','NV0001','2021/1/21'),
('HD0002','KH0004','NV0002','2021/4/1'),
('HD0003','KH0002','NV0004','2021/7/21'),
('HD0004','KH0005','NV0007','2021/4/11'),
('HD0005','KH0006','NV0004','2021/11/1'),
('HD0006','KH0007','NV0008','2021/7/9'),
('HD0007','KH0008','NV0005','2021/4/21'),
('HD0008','KH0002','NV0008','2021/5/17'),
('HD0009','KH0009','NV0002','2021/6/21'),
('HD0010','KH0010','NV0003','2021/11/21'),
('HD0011','KH0001','NV0009','2021/9/5'),
('HD0012','KH0004','NV0004','2021/11/14'),
('HD0013','KH0006','NV0003','2021/8/11'),
('HD0014','KH0002','NV0007','2021/3/8'),
('HD0015','KH0004','NV0010','2021/1/27'),
('HD0016','KH0005','NV0008','2021/11/29'),
('HD0017','KH0008','NV0004','2021/12/21'),
('HD0018','KH0007','NV0001','2021/12/1'),
('HD0019','KH0004','NV0004','2021/9/11'),
('HD0020','KH0003','NV0008','2021/10/21')
go
/*Insert thông tin bảng Chi tiết Hóa đơn*/
insert into CTHOADON
values 
('HD0001','SP0020',28000,5),
('HD0002','SP0019',70000,10),
('HD0003','SP0018',25000,25),
('HD0004','SP0017',40000,15),
('HD0005','SP0016',45000,10),
('HD0006','SP0015',75000,22),
('HD0007','SP0014',280000,100),
('HD0008','SP0013',54000,20),
('HD0009','SP0012',28000,80),
('HD0010','SP0011',30000,55),
('HD0011','SP0010',26000,30),
('HD0012','SP0009',92000,120),
('HD0013','SP0008',81000,2),
('HD0014','SP0007',62000,1.5),
('HD0015','SP0006',58000,2),
('HD0016','SP0005',58000,1),
('HD0017','SP0004',37000,2),
('HD0018','SP0003',60000,5),
('HD0019','SP0002',56000,2),
('HD0020','SP0001',62000,1)
go
/*Insert thông tin bảng Phiếu nhập*/
insert into PHIEUNHAP
values 
('PN0001','NCC005','2021/1/21'),
('PN0002','NCC008','2021/10/27'),
('PN0003','NCC009','2021/8/21'),
('PN0004','NCC010','2021/11/21'),
('PN0005','NCC006','2021/1/21'),
('PN0006','NCC004','2021/12/21'),
('PN0007','NCC003','2021/8/2'),
('PN0008','NCC005','2021/7/21'),
('PN0009','NCC010','2021/4/8'),
('PN0010','NCC002','2021/2/28'),
('PN0011','NCC010','2021/3/2'),
('PN0012','NCC006','2021/7/21'),
('PN0013','NCC003','2021/11/21'),
('PN0014','NCC010','2021/8/12'),
('PN0015','NCC005','2021/6/28'),
('PN0016','NCC008','2021/1/25'),
('PN0017','NCC010','2021/12/21'),
('PN0018','NCC006','2021/5/2'),
('PN0019','NCC002','2021/5/24'),
('PN0020','NCC007','2021/4/21')
go
/*Insert thông tin bảng Chi tiết Phiếu nhập*/
insert into CTPHIEUNHAP
values 
('PN0001','SP0020',12000,100),
('PN0002','SP0019',15000,150),
('PN0003','SP0018',17000,80),
('PN0004','SP0017',20000,70),
('PN0005','SP0016',23000,150),
('PN0006','SP0015',60000,50),
('PN0007','SP0014',100000,70),
('PN0008','SP0013',17000,20),
('PN0009','SP0012',23000,30),
('PN0010','SP0011',12000,100),
('PN0011','SP0010',23000,100),
('PN0012','SP0009',54000,50),
('PN0013','SP0008',63000,30),
('PN0014','SP0007',52000,60),
('PN0015','SP0006',32000,120),
('PN0016','SP0005',16000,40),
('PN0017','SP0004',17000,100),
('PN0018','SP0003',24000,40),
('PN0019','SP0002',36000,50),
('PN0020','SP0001',56000,80)
/*Câu lệnh SQL*/
--------------------------------------------------------------------------------------------------------------------
									/*Synonym: tối thiểu 2*/
--------------------------------------------------------------------------------------------------------------------
/*1. Tạo Synonym cho bảng loại sản phẩm (LOAISANPHAM) là LSP*/
--Lệnh tạo Synonym
CREATE SYNONYM LSP FOR dbo.LOAISANPHAM
--Lệnh xóa Synonym
DROP SYNONYM LSP
--Kiểm thử
SELECT * FROM LSP
----------------------------------------------------------
/*2. Tạo Synonym cho View vwTuoiNhanVienNu với:
View vwTuoiNhanVienNu với các thông tin:
mã nhân viên, họ, tên nhân viên, tuổi nhân viên có độ tuổi từ 35 đến 40 tuổi*/
CREATE VIEW vwTuoiNhanVienNu
AS
SELECT MaNV, HoNV, TenNV, year(getdate())-year(NgaySinh) AS Tuoi
FROM NHANVIEN
WHERE GioiTinh=N'Nữ' and year(getdate())-year(NgaySinh) between 35 and 40 
--Tạo Synonym cho View
CREATE SYNONYM TNVN FOR dbo.vwTuoiNhanVienNu

--Kiểm thử
SELECT * FROM TNVN
----------------------------------------------------------
/*3. Tạo Synonym cho Store Procedure sp_SPSlTonNN
Với sp_SPSlTonNN: Cho biết danh sách những sản phẩm có số lượng tồn nhiều nhất*/
create proc sp_SPSlTonNN
as
select top 1 WITH TIES *
from SANPHAM
order by SlTon desc
--Tạo Synonym cho Store Procedure
CREATE SYNONYM SLTNN FOR dbo.sp_SPSlTonNN
--Kiểm thử
exec SLTNN
----------------------------------------------------------
/*4. Tạo Synonym cho Function 
Function: xem danh sách các mặt hàng theo loại hàng (trả về dạng bảng)*/
create function f_XemSPTheoLSP (@MaLoaiSP nvarchar(50))
returns table
as
return (select * from SANPHAM where MaLoaiSP = @MaLoaiSP)
--Tạo Synonym cho Function 
CREATE SYNONYM SPLSP FOR dbo.f_XemSPTheoLSP

--Kiểm thử
select * from SPLSP ('VPP')
--------------------------------------------------------------------------------------------------------------------
									/*Index: tối thiểu 2*/
--------------------------------------------------------------------------------------------------------------------
--Tạo Index trên Mã Sản phẩm của bảng CTPHIEUNHAP
CREATE INDEX IndexMaSP on CTPHIEUNHAP(MaSP)

--Kiểm tra hoạt động của index
--Không có index
Select *
From CTPHIEUNHAP
Where MaSP='SP0008'
--Có index 
Select *
From CTPHIEUNHAP
With (index(IndexMaSP))
Where MaSP='SP0008'
----------------------------------------------------------
--Tạo Index cho 2 thuộc tính
CREATE INDEX IndexHD_KH_NV
ON HOADON(MaKH,MaNV) 

--Kiểm tra hoạt động của index
--Không có index
SELECT *
FROM HOADON 
WHERE MaKH='KH0002' and MaNV='NV0008'
--Có index 
SELECT *
FROM HOADON
WITH (INDEX(IndexHD_KH_NV))
WHERE MaKH='KH0002' and MaNV='NV0008'
----------------------------------------------------------
--Tạo Index cho 2 thuộc tính
CREATE INDEX IndexSP_DGB_LSP
ON SANPHAM(DgBan,MaLoaiSP)

--Kiểm tra hoạt động của index
--Nếu chỉ tìm một giá trị trong Index mới tạo
--Tìm theo giá trị Đơn giá bán
--Không có index
SELECT *
FROM SANPHAM
WHERE DgBan between 15000 and 50000
--Có index 
SELECT *
FROM SANPHAM
WITH (INDEX(IndexSP_DGB_LSP))
WHERE DgBan between 15000 and 50000

--Tìm theo giá trị Mã loại sản phẩm
--Không có index
SELECT *
FROM SANPHAM
WHERE MaLoaiSP = 'GV'
--Có index 
SELECT *
FROM SANPHAM
WITH (INDEX(IndexSP_DGB_LSP))
WHERE MaLoaiSP = 'GV'
---------------------------------------------------------
--Kiểm thử khi chưa chạy index
select TenSP
from SANPHAM
order by SlTon desc
-- Tạo Index để sắp xếp
CREATE INDEX IndexSXSlTon
ON SANPHAM(TenSP, SlTon desc)

--Kiểm thử khi đã chạy index
select TenSP
from SANPHAM
order by SlTon desc

---------------------------------------------------------------------------------------------------------------
						/*View: tối thiểu 4, đa dạng (cơ bản, gom nhóm/thống kê, lồng)*/
--------------------------------------------------------------------------------------------------------------------
--1	 Tạo vwDanhSachNhanVienNu với các thông tin gồm: mã nhân viên, họ tên nhân viên, ngày sinh của các nhân viên nữ
create view VwDanhSachNhanVienNu 
as
select MaNV, HoNv,TenNv, NgaySinh
from NHANVIEN
where GioiTinh = N'Nữ'
--thực thi câu lệnh
select * from VwDanhSachNhanVienNu 
------------------------------------------------------------------------------
--2.Tạo view vwThongTinPhieuNhap với các thông tin: mã phiếu nhập,mã nhà cung cấp, tên nhà cung cấp, ngày nhập
create view VwThongTinPhieuNhap
as
select MaPN, ncc.MaNCC, TenNCC, NgayNhap
from PHIEUNHAP pn inner join NHACUNGCAP ncc on pn.MaNCC=ncc.MaNCC
group by MaPN,ncc.MaNCC, TenNCC, NgayNhap
--Thực thi
select * from VwThongTinPhieuNhap
------------------------------------------------------------------------------
/*3.Cho biết danh sách các khách hàng gồm mã khách hàng, họ tên khách hàng, số lượng hóa đơn đã mua (nếu khách đó chưa mua hàng thì cột số lượng hóa đơn để trống)*/
create view VwDanhSachKHDatHang
as
select kh.MaKH,TenKH,
case  when count(MaHD) >0 then count(MaHD) else null end as N'Số lượng đặt'
from KHACHHANG kh full join HOADON hd on kh.MaKh= hd.MaKH
group by kh.MaKH,TenKH
--thực thi 
select * from VwDanhSachKHDatHang
------------------------------------------------------------------------------
--4	Tạo view vwThongTinHoadon918 với các thông tin: Mã hóa đơn, họ, tên nhân viên của các hóa đơn tháng 9 năm 2018
create view vwThongTinHoaDon918
as
select hd.MaHD,HoNV+' '+ TenNV as N'Họ và tên nhân viên'
from  HOADON hd inner join NHANVIEN nv on nv.MaNV= hd.MaNv
where month(NgayLapHD)= 9 and year(NgayLapHD)=2021
--Thực thi 
select * from vwThongTinHoaDon918
------------------------------------------------------------------------------
--5	Tạo view vwTriGiaHoaDonVPP với các thông tin: Mã hóa đơn, mã khách hàng, mã nhân viên, Tổng trị giá hóa đơn (giá bán x số lượng) của các mặt hàng thuộc loại hàng văn phòng phẩm.
create view vwTriGiaHoaDonVPP
as
select hd.MaHD, kh.MaKH, HoKH+' '+TenKH as HoTenKh, HoNV+' ' +TenNV as HoTenNv, sum(SlBan*sp.DgBan) as N'Trị giá'
from HOADON hd join KHACHHANG kh on hd.MaKH=kh.MaKH
			   join NHANVIEN nv on hd.MaNV=nv.MaNV
			   join CTHOADON ct on ct.MaHD= hd.MaHD 
			   join SANPHAM sp on sp.MaSP= ct.MaSP
where sp.MaLoaiSP='VPP'
group by hd.MaHD,kh.MaKH,HoKH+' '+TenKH, HoNV+' ' +TenNV
--Thực thi câu lệnh
select * from VwTriGiaHoaDonVPP
------------------------------------------------------------------------------
/*6. Cho biết hóa đơn có tổng trị giá lớn nhất trong tháng 9/2018 gồm các thông tin: 
mã hóa đơn, ngày hóa đơn, họ tên khách hàng, địa chỉ khách hàng, tổng giá trị của hóa đơn*/
create View VwTongGiaTriHoaDonLonNhat
as
select ct.MaHD, NgayLapHD, HoKh+' '+TenKh as N'Họ Tên', DiaChi, Sum(SlBan * DgBan) as Tong
from KHACHHANG kh join HOADON hd on kh.MaKH= hd.MaKH 
				  join CTHOADON ct on hd.MaHD=ct.MaHD
where month(NgayLapHD)=5 and year(NgayLapHD)=2021
group by  ct.MaHD,NgayLapHD,HoKH+' '+TenKH,DiaChi
Having  Sum(SlBan * DgBan) >= all (select  Sum(SlBan * DgBan)
							from  HOADON hd  join CTHOADON ct on hd.MaHD=ct.MaHD 
							where month(NgayLapHD)=5 and year(NgayLapHD)=2021 
							group by hd.MaHD)
--Thực thi 
select * from VwTongGiaTriHoaDonLonNhat
---------------------------------------------------------------------------------------------------------------
								/*Function: tối thiểu 2*/
---------------------------------------------------------------------------------------------------------------
/*1. Viết hàm cho biết số lượng đơn đặt hàng với tham số truyền vào là mã nhân viên*/
create Function f_SoLuongDonTheoNv (@MaNv nvarchar(10))
returns int
as
	begin 
		declare @SoLuongHd int
		select @SoLuongHd = count(MaHD)
		from HOADON
		where MaNv=@MaNv
		group by MaNv
		return   @SoLuongHd
		end 
--drop Function f_SoLuongDonTheoNv 
--Thực thi
select  dbo.f_SoLuongDonTheoNv ('NV0008')
---------------------------------------------------------------
/*2.Viết hàm tính doanh thu từng nhân viên theo tháng, 
năm với tham số truyền vào là mã nhân viên và tháng, năm*/
create function f_DoanhThuNvThangNam (@MaNV nvarchar(10), @thang int, @nam int)
returns float
as
	begin 
	declare @DoanhThu float
	set @DoanhThu = 0
	select @DoanhThu = sum(DgBan * SlBan)
	from CTHOADON cthd join CTPHIEUNHAP ctpn  on cthd.MaSP = ctpn.MaSP 
					   join HOADON hd on hd.MaHD=cthd.MaHD
	where MaNv = @MaNv and month(NgayLapHD) = @thang and year(NgayLapHD) = @nam
	group by MaNv
	return @DoanhThu
	end
--Thực thi 
select dbo.f_DoanhThuNvThangNam ('NV0008',5,2021)
--drop function f_DoanhThuNvThangNam
---------------------------------------------------------------
/*3.Viết hàm tính doanh thu theo tháng, năm với tham số truyền vào là tháng và năm*/
create Function f_DoanhThuTheoThang (@Thang int, @Nam int)
returns float 
as
begin
 declare @DoanhThu float 
 select @DoanhThu= sum((cthd.DgBan -DgNhap)*SlBan ) 
 from  CTHOADON cthd join CTPHIEUNHAP ctpn on ctpn.MaSP= cthd.MaSP 
					 join HOADON hd on hd.MaHD=cthd.MaHD
 where month(NgayLapHD)= @Thang and year(NgayLapHD) = @Nam 
 group by month(NgayLapHD),year(NgayLapHD)
 return @DoanhThu
 end
 --Thực thi 
 select dbo.f_DoanhThuTheoThang (5,2021)
---------------------------------------------------------------
 /*4.Viết hàm tính doanh thu cho từng sản phẩm (giá bán – giá mua)* số lượng đặt từng mặt hàng*/
create function f_DoanhThuTungMh ()
returns table
as
	return(
	select ctpn.MaSP, sum((DgBan - DgNhap)*SlBan) as DoanhThu
	from CTHOADON cthd  join CTPHIEUNHAP ctpn on ctpn.MaSP= cthd.MaSP 
	group by ctpn.MaSP)
--Thực thi 
--drop function f_DoanhThuTungMh 
select * from dbo.f_DoanhThuTungMh ()
---------------------------------------------------------------
/*5. Viết hàm xem danh sách các sản phẩm theo loại sản phẩm (trả về dạng bảng)*/
create function f_XemMhTheoLh (@MaLoaiSP nvarchar(50))
returns table
as
return (select * from SANPHAM where MaLoaiSP = @MaLoaiSP)
--Thực thi 
select * from dbo.f_XemMhTheoLh ('TPX')
drop function f_XemMhTheoLh
--------------------------------------------------------------------------------------------------------------------------------------------
						/*Store Procedure: tối thiểu 6, trong đó ít nhất 4 SP có tham số*/
--------------------------------------------------------------------------------------------------------------------------------------------
--1.Cho biết danh sách 5 mặt hàng có số lượng tồn nhiều nhất
create proc sp_5MhSlTonMax
as
select top 5 *
from SANPHAM 
order by SlTon desc
--Thực thi 
exec sp_5MhSlTonMax
---------------------------------------------------------------
--2.Cho biết danh sách 3 hóa đơn có trị giá bán lớn nhất
create proc sp_3TriGiaHdMax
as
select MaHD, sum(SlBan*DgBan) as TriGiaHD
from CTHOADON
group by MaHD
having sum(SlBan*DgBan) in (select top 3 sum(SlBan*DgBan)
							   from  CTHOADON
							   group by MaHD
							   order by sum(SlBan*DgBan) desc)
--Thực thi 
exec sp_3TriGiaHdMax
---------------------------------------------------------------
/*3.Xem đơn giá của một mặt hàng với mã mặt hàng do người dùng nhập*/
create proc sp_DgSanPham @MaSP nvarchar(10)
as
select DgBan as N'Đơn giá'
from SANPHAM
where MaSP = @MaSP
--Thực thi 
--drop  proc sp_DgSanPham
exec sp_DgSanPham 'SP0001'
---------------------------------------------------------------
/*4.Xem thông tin hóa đơn gồm có:mã hóa đơn, mã nhân viên,
họ tên nhân viên, mã khách hàng,họ tên khách hàng,
ngày hóa đơn với mã số nhân viên do người dùng yêu cầu.*/
create proc sp_TTHoaDon_MaNV @MaNV nvarchar(10)
as 
select MaHD, hd.MaNV, HoNv + ' ' + TenNv as HoTenNV, hd.MaKh, HoKh + ' ' + TenKh as HoTenKh, NgayLapHD
from HOADON hd join NHANVIEN nv on hd.MaNV = nv.MaNV
				join KHACHHANG kh on hd.MaKH = kh.MaKH
where hd.MaNv = @MaNv
--Thực thi
--drop proc sp_TTHoaDon_MaNV
exec sp_TTHoaDon_MaNv 'NV0002'
---------------------------------------------------------------
/*5 Xem thông tin đơn hàng gồm mã hóa đơn, mã sản phẩm, tên sản phẩm,
số lượng bán, đơn giá bán theo khoảng thời gian từ ngày đến ngày do người dùng yêu cầu.*/
create proc sp_TTDonHang_KhoangTg @tungay date, @denngay date
as  
select hd.MaHd, sp.MaSP, TenSP, SlBan, cthd.DgBan
from HOADON hd join CTHOADON cthd on hd.MaHD= cthd.MaHD join SANPHAM sp on sp.MaSP=cthd.MaSP
where NgayLapHD between @tungay and @denngay
--Thực thi 
--drop proc sp_TTDonHang_KhoangTg
exec sp_TTDonHang_KhoangTg '2/2/2021', '3/11/2021'
---------------------------------------------------------------
/*6. Xem số lượng tồn của một sản phẩm, nếu số lượng tồn >0 thì
thông báo “còn hàng”, ngược lại thông báo “đã hết hàng”, với mã hàng do người dùng nhập*/
create proc sp_SlTon_Ktra @MaSP nchar(6)
as
begin
if exists (select MaSP
		   from SANPHAM 
		   where MaSP = @MaSP and SlTon > 0)		
begin
declare @SlTon float 
set @SlTon =0 
select @SlTon = SlTon 
from SANPHAM
where MaSP=@MaSP
print N'Còn hàng. Số lượng là:  ' + cast (@SlTon as nvarchar(10))
end
else 
print N'Hết hàng'
end
--Thực thi 
--drop proc sp_SlTon_Ktra
exec sp_SlTon_Ktra 'SP0001'
---------------------------------------------------------------
/*7.Ngày lập là tham số truyền vào và doanh thu là tham số truyền ra*/
Create proc sp_DoanhThuBanHang @NgayBan datetime, @DoanhThu int output
As
Select  @DoanhThu=Sum(SlBan*DgBan) 
From HOADON hd inner join CTHOADON ct on hd.MaHD=ct.MaHD
Where NgayLapHD = @NgayBan

--drop proc sp_DoanhThuBanHang
----Thực thi 
Declare @DoanhThu int
Set @DoanhThu=0
Exec sp_DoanhThuBanHang '2021/01/21', @DoanhThu Output
Print 'Doanh thu bán hàng ngày là '  + Cast(@DoanhThu As nvarchar(10))
select * from HOADON 
---------------------------------------------------------------
/*8.Viết thủ tục xóa Khách hàng khi nhập mã Khách hàng*/
Create proc sp_XoaKh @MaKH nvarchar(10)
as
delete KHACHHANG where MaKH =@MaKH
--drop proc sp_ThemKh
/*8.Viết thủ tục xóa Khách hàng khi nhập mã Khách hàng*/
--Thực thi
exec sp_XoaKh 'KH0011'
select * from KHACHHANG
---------------------------------------------------------------------------------------------------------------
					/*Trigger: tối thiểu 2, đa dạng (Insert, Delete, Update) */
---------------------------------------------------------------------------------------------------------------
go
----------------------------------------------------------------------
/*1. Tạo Trigger quy định Số lượng tồn phải lớn hơn hoặc bằng 0 (>=0)*/
CREATE TRIGGER tg_SoLuongTon ON SANPHAM
FOR INSERT, UPDATE 
AS
IF EXISTS (SELECT * FROM inserted WHERE inserted.SlTon < 0)
  BEGIN 
	PRINT(N'Số lượng tồn phải lớn hơn hoặc bằng 0')
	rollback tran
  END

--Kiểm thử 
--Thêm Sản phẩm với với Số lượng tồn là số âm: -50
insert into SANPHAM
values 
('SP0021',N'Đường',31000,N'Kg',-50,'GV')

----------------------------------------------------------------------
GO
----------------------------------------------------------------------
/*2. Tạo Trigger quy định Số lượng bán trong Hóa đơn phải nhỏ hơn hoặc bằng Số lượng tồn trong Sản phẩm*/
CREATE TRIGGER tg_SlBanSlTon ON CTHOADON
FOR INSERT, UPDATE
AS
  BEGIN
	DECLARE @SlTon INT, @SlBan INT, @SlBan1 INT
	SET @SlTon = 0
	SET @SlBan =0
	SET @SlBan1 =0
	SELECT @SlBan1 = SlBan FROM CTHOADON
	SELECT @SlBan = inserted.SlBan FROM inserted 
	SELECT @SlTon = SANPHAM.SlTon
	FROM SANPHAM join inserted on inserted.MaSP = SANPHAM.MaSP 
	WHERE SANPHAM.MaSP = inserted.MaSP
	IF(@SlTon + @SlBan1 < @SlBan) 
		BEGIN 
			PRINT(N'Số lượng sản phẩm được bán phải nhỏ hơn hoặc bằng với sản phẩm trong kho')
			rollback tran
		END
	END

--Kiểm thử
--Xem bảng Sản phẩm
SELECT *
FROM SANPHAM
--Tạo Hóa đơn
insert into HOADON
values 
('HD0021','KH0004','NV0003','2022/4/13')
--Tạo Chi tiết hóa đơn với Số lượng bán là 60 so với Số lượng tồn là 50 của Sản phẩm SP0001
go
insert into CTHOADON
values 
('HD0021','SP0001',58000,60)
----------------------------------------------------------------------
go
----------------------------------------------------------------------
/*3. Số lượng bán của sản phẩm trong Chi tiết hóa đơn phải lớn hơn 0 (>0)*/
CREATE TRIGGER tg_SoLuongBan ON CTHOADON
FOR INSERT, UPDATE 
AS
IF EXISTS (SELECT * FROM inserted WHERE inserted.SlBan <= 0)
  BEGIN
	PRINT(N'Số lượng bán phải lớn hơn 0')
	rollback tran
  END

--Kiểm thử
--Cập nhật Chi tiết Hóa đơn HD0020 với Số lượng bán là -1
UPDATE CTHOADON
SET SlBan = -1
WHERE MaHD='HD0020'
----------------------------------------------------------------------
go
----------------------------------------------------------------------
/*4.1. Cập nhật sản phẩm trong kho sau khi thêm hóa đơn*/
CREATE TRIGGER tg_HoaDon ON CTHOADON
AFTER INSERT 
AS 
  BEGIN
	UPDATE SANPHAM
		SET SlTon = SlTon - (
			SELECT SlBan
			FROM inserted
			WHERE MaSP = SANPHAM.MaSP)
	FROM SANPHAM
	JOIN inserted ON SANPHAM.MaSP = inserted.MaSP
  END
GO
/*4.2. Cập nhật sản phẩm trong kho sau khi cập nhật hóa đơn */
CREATE TRIGGER tg_CapNhatHoaDon on CTHOADON 
after update 
AS
  BEGIN
   UPDATE SANPHAM SET SlTon = SlTon -
	   (SELECT SlBan FROM inserted WHERE MaSP = SANPHAM.MaSP) +
	   (SELECT SlBan FROM deleted WHERE MaSP = SANPHAM.MaSP)
   FROM SANPHAM
   JOIN deleted ON SANPHAM.MaSP = deleted.MaSP
  END
GO
/*4.3. Cập nhật sản phẩm trong kho sau khi hủy hóa đơn */
create TRIGGER tg_HuyHoaDon ON CTHOADON
FOR DELETE 
AS 
  BEGIN
	UPDATE SANPHAM
	SET SlTon = SlTon + (SELECT SlBan FROM deleted WHERE MaSP = SANPHAM.MaSP)
	FROM SANPHAM
	JOIN deleted ON SANPHAM.MaSP = deleted.MaSP
  END

--Kiểm thử
--Xem bảng Sản phẩm ban đầu
select *
from SANPHAM
--Thêm Chi tiết hóa đơn với Mã Hóa đơn HD0021 , Mã Sản phẩm SP0001 và Số lượng bán là 40
insert into CTHOADON
values 
('HD0021','SP0001',58000,40)
--Xem bảng Chi tiết hóa đơn và bảng Sản phẩm sau khi thêm
select *
from SANPHAM
select *
from CTHOADON
--Cập nhật Chi tiết hóa đơn với Mã Hóa đơn HD0021 , Mã Sản phẩm SP0001 và Số lượng bán từ 40 xuống 30
update CTHOADON
set SlBan=30
where MaHD='HD0021'
--Xem bảng Chi tiết hóa đơn và bảng Sản phẩm sau khi cập nhật
select *
from SANPHAM
select *
from CTHOADON
--Xóa Hóa đơn HD0021
DELETE FROM CTHOADON WHERE MaHD='HD0021'
GO
DELETE FROM HOADON WHERE MaHD='HD0021'
--Xem bảng Chi tiết hóa đơn và bảng Sản phẩm sau khi xóa
select *
from SANPHAM
select *
from CTHOADON
----------------------------------------------------------------------
GO
----------------------------------------------------------------------
/*5. Số lượng nhập của sản phẩm trong Chi tiết phiếu nhập phải lớn hơn 0 (>0)*/
CREATE TRIGGER tg_SoLuongNhap ON CTPHIEUNHAP
FOR INSERT, UPDATE 
AS
IF EXISTS (SELECT * FROM inserted WHERE inserted.SlNhap <= 0)
  BEGIN
	PRINT(N'Số lượng nhập phải lớn hơn 0')
	rollback tran
  END

--Tạo Phiếu nhập PN0021 với Chi tiết phiếu nhập có Mã Sản phẩm: SP0001 và Số lượng nhập: -50
INSERT PHIEUNHAP 
VALUES ('PN0021','NCC001','2022/4/14')
INSERT CTPHIEUNHAP
VALUES ('PN0021','SP0001',31000,-50)
----------------------------------------------------------------------
GO
----------------------------------------------------------------------
/*6.1. Cập nhật sản phẩm trong kho sau khi có phiếu nhập hàng*/
go
CREATE TRIGGER tg_PhieuNhap ON CTPHIEUNHAP
AFTER INSERT 
AS 
  BEGIN
	UPDATE SANPHAM
		SET SlTon = SlTon + (
			SELECT SlNhap
			FROM inserted
			WHERE MaSP = SANPHAM.MaSP)
	FROM SANPHAM
	JOIN inserted ON SANPHAM.MaSP = inserted.MaSP
  END
GO
/*6.2. Cập nhật sản phẩm trong kho sau khi cập nhật phiếu nhập */
CREATE TRIGGER tg_CapNhatPhieuNhap on CTPHIEUNHAP
after update 
AS
  BEGIN
   UPDATE SANPHAM SET SlTon = SlTon +
	   (SELECT SlNhap FROM inserted WHERE MaSP = SANPHAM.MaSP) -
	   (SELECT SlNhap FROM deleted WHERE MaSP = SANPHAM.MaSP)
   FROM SANPHAM
   JOIN deleted ON SANPHAM.MaSP = deleted.MaSP
  END
GO
/*6.3. Cập nhật sản phẩm trong kho sau khi hủy phiếu nhập */
create TRIGGER tg_HuyPhieuNhap ON CTPHIEUNHAP
FOR DELETE 
AS 
  BEGIN
	UPDATE SANPHAM
	SET SlTon = SlTon - (SELECT SlNhap FROM deleted WHERE MaSP = SANPHAM.MaSP)
	FROM SANPHAM
	JOIN deleted ON SANPHAM.MaSP = deleted.MaSP
  END
  
--Kiểm thử
--Xem bảng Sản phẩm ban đầu
select *
from SANPHAM
/*Thêm Chi tiết phiếu nhập với Số phiếu nhập PN0021 , Mã Sản phẩm SP0001, Đơn giá nhập 31000
và Số lượng nhập là 50*/
INSERT INTO CTPHIEUNHAP
VALUES
('PN0021','SP0001',31000,50)
--Xem bảng Chi tiết phiếu nhập và bảng Sản phẩm sau khi thêm
select *
from SANPHAM
select *
from CTPHIEUNHAP
/*Cập nhật Chi tiết hóa đơn với Mã phiếu nhập PN0021 , Mã Sản phẩm SP0001 và 
Số lượng bán từ 50 lên 100*/
update CTPHIEUNHAP
set SlNhap=100
where MaPN='PN0021'
--Xem bảng Chi tiết Phiếu nhập và bảng Sản phẩm sau khi cập nhật
select *
from SANPHAM
select *
from CTPHIEUNHAP
--Xóa Phiếu nhập PN0021
DELETE FROM CTPHIEUNHAP WHERE MaPN='PN0021'
GO
DELETE FROM PHIEUNHAP WHERE MaPN='PN0021'
--Xem bảng Chi tiết phiếu nhập và bảng Sản phẩm sau khi xóa
select *
from SANPHAM
select *
from CTPHIEUNHAP
--------------------------------------------------------------------------------------------------------------------------------------------
							/*User: tối thiểu 2 mức: quản lý và nhân viên*/
--------------------------------------------------------------------------------------------------------------------------------------------
--1. Tạo đăng nhập cho nhà quản lý: Xuân Nương
CREATE LOGIN NQL_XuanNuong with password = '12345', default_database = QuanLyBanHangVinMart
--2. Tạo người dùng cho đăng nhập
CREATE USER NQL_XuanNuong FOR LOGIN NQL_XuanNuong 
--3. Cấp tất cả quyền cho Nhà quản lý: Xuân Nương và có thể cấp quyền cho người khác
GRANT ALL ON NHANVIEN TO NQL_XuanNuong WITH GRANT OPTION
GRANT ALL ON KHACHHANG TO NQL_XuanNuong WITH GRANT OPTION
GRANT ALL ON NHACUNGCAP TO NQL_XuanNuong WITH GRANT OPTION
--4. Tạo đăng nhập Nhân viên Quản lý: Đình Quý
CREATE LOGIN NVQL_DinhQuy with password = '12345', default_database = QuanLyBanHangVinMart
--5. Tạo người dùng cho đăng nhập
CREATE USER NVQL_DinhQuy FOR LOGIN NVQL_DinhQuy
--6. Cấp quyền xem và cật nhật, thêm cho Nhân viên Quản lý: Đình Quý
GRANT SELECT, UPDATE, INSERT ON NHANVIEN TO NVQL_DinhQuy 
GRANT SELECT, UPDATE, INSERT ON KHACHHANG TO NVQL_DinhQuy 
--7. Tạo đăng nhập cho Nhân viên 1: Lê Thị Cúc và Nhân viên 2: Mai Minh Mẫn
CREATE LOGIN NV1_LeThiCuc with password = '12345', default_database = QuanLyBanHangVinMart
CREATE LOGIN NV2_MaiMinhMan with password = '12345', default_database = QuanLyBanHangVinMart
--8. Tạo người dùng cho đăng nhập
CREATE USER NV1_LeThiCuc FOR LOGIN NV1_LeThiCuc
CREATE USER NV2_MaiMinhMan FOR LOGIN NV2_MaiMinhMan
/*9. Cấp quyền xem, cập nhật, thêm trong các bảng Phiếu nhâp (PHIEUNHAP),
Chi tiết Phiếu nhập (CTPHIEUNHAP)*/
GRANT SELECT, UPDATE, INSERT ON PHIEUNHAP TO NV1_LeThiCuc,NV2_MaiMinhMan 
GRANT SELECT, UPDATE, INSERT ON CTPHIEUNHAP TO NV1_LeThiCuc,NV2_MaiMinhMan 
--10. Tạo nhóm người dùng: NhanvienBanhang
GO
CREATE ROLE NhanvienBanhang
--11. Thêm 2 người dùng: NV1_LeThiCuc, NV2_MaiMinhMan vào nhóm NhanvienBanhang
GO
sp_addrolemember 'NhanvienBanhang', 'NV1_LeThiCuc'
GO
sp_addrolemember 'NhanvienBanhang', 'NV2_MaiMinhMan'
/*12. Cấp quyền xem, cập nhật, thêm trong các bảng Hóa đơn (HOADON),
Chi tiết Hóa đơn (CTHOADON)*/
GRANT SELECT, UPDATE, INSERT ON HOADON TO NhanvienBanhang
GRANT SELECT, UPDATE, INSERT ON CTHOADON TO NhanvienBanhang
--13. Cấp quyền xem bảng Sản phẩm, Loại sản phẩm, Nhà cung cấp cho tất cả mọi người
GRANT SELECT ON SANPHAM TO PUBLIC 
GRANT SELECT ON LOAISANPHAM TO PUBLIC 
GRANT SELECT ON NHACUNGCAP TO PUBLIC 
--14. Hủy quyền cập nhật Hóa đơn của Nhân viên 1: NV1_LeThiCuc
REVOKE UPDATE ON HOADON TO NV1_LeThiCuc
--15. Hủy quyền của Nhân viên 2: NV2_MaiMinhMan
REVOKE NV2_MaiMinhMan
--------------------------------------------------------------------------------------------------------------------------------------------
										/*PHẦN MỞ RỘNG*/
--------------------------------------------------------------------------------------------------------------------------------------------
--Transaction
-------------------------------------------------------------------------------
--1. Tạo Transection cho Store Procedure thêm khách hàng vào bảng khách hàng
create proc sp_ThemKH (@makh nvarchar(10), @hokh nvarchar(20), @tenkh nvarchar(20), @diachi nvarchar(100), @dienthoai nvarchar(30), @email nvarchar(100))
as
begin transaction
insert into KHACHHANG
values (@makh,@hokh,@tenkh,@diachi,@dienthoai,@email)
if @@ERROR <> 0 rollback
else commit

--Kiểm thử 
--Thêm khách hàng với các thông tin: Lê Thị Đào, Quận 1, Tp.Hồ Chí Minh, 098445677, ledao@gmail.com
--Kiểm sai: Thêm Khách hàng nhưng nhập mã khách hàng KH0010 đã có 
exec sp_ThemKh 'KH0010', N'Lê Thị', N'Đào', N'Quận 1, TP.Hồ Chí Minh', '098445677', 'ledao@gmail.com'
--Kiểm đúng: Thêm khách hàng KH0011
exec sp_ThemKh 'KH0011', N'Lê Thị', N'Đào', N'Quận 1, TP.Hồ Chí Minh', '098445677', 'ledao@gmail.com'
go
--2. Tạo Transection cho Store Procedure cập nhật số điện thoại của nhân viên khi bít mã nhân viên
create proc sp_CapnhatSoDTNV (@manv nvarchar(10), @dienthoai nvarchar(30))
as
begin transaction
update NHANVIEN
set DienThoai = @dienthoai
where MaNV= @manv
if @@ERROR <> 0 rollback
else commit

--Kiểm thử
/*Kiểm sai:Cập nhật số điện thoại của Nhân viên có mã nhân viên NV0010 và
có số điện thoại trùng với số điện thoại của nhân viên NV0005*/
exec sp_CapnhatSoDTNV 'NV0010', '092987487'
/*Kiểm đúng : Cập nhật NV0010 với số điện thoại 0269874856*/ 
exec sp_CapnhatSoDTNV 'NV0010', '0269874856'
-------------------------------------------------------------------------------
							/*Window function*/
-------------------------------------------------------------------------------
--1. Sắp xếp thứ tự theo đơn giá bán 
select * , RANK() over (order by DgBan DESC) as TT
from CTHOADON
order by SlBan
--2. xếp hạng trong cùng 1 nhóm
select * , rank() over( partition by MaSP order by DgBan)
from CTHOADON
