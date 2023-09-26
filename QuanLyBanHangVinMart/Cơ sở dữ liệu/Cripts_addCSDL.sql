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