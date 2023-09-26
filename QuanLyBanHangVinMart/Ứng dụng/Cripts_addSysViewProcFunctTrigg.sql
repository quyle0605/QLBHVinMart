USE QuanLyBanHangVinMart
GO
/*Câu lệnh SQL*/
--------------------------------------------------------------------------------------------------------------------
									/*Synonym: tối thiểu 2*/
--------------------------------------------------------------------------------------------------------------------
/*1. Tạo Synonym cho bảng loại sản phẩm (LOAISANPHAM) là LSP*/
--Lệnh tạo Synonym
CREATE SYNONYM LSP FOR dbo.LOAISANPHAM
GO
----------------------------------------------------------
/*2. Tạo Synonym cho View vwTuoiNhanVienNu với:
View vwTuoiNhanVienNu với các thông tin:
mã nhân viên, họ, tên nhân viên, tuổi nhân viên có độ tuổi từ 35 đến 40 tuổi*/
CREATE VIEW vwTuoiNhanVienNu
AS
SELECT MaNV, HoNV, TenNV, year(getdate())-year(NgaySinh) AS Tuoi
FROM NHANVIEN
WHERE GioiTinh=N'Nữ' and year(getdate())-year(NgaySinh) between 35 and 40
GO
--Tạo Synonym cho View
CREATE SYNONYM TNVN FOR dbo.vwTuoiNhanVienNu
GO
----------------------------------------------------------
/*3. Tạo Synonym cho Store Procedure sp_SPSlTonNN
Với sp_SPSlTonNN: Cho biết danh sách những sản phẩm có số lượng tồn nhiều nhất*/
create proc sp_SPSlTonNN
as
select top 1 WITH TIES *
from SANPHAM
order by SlTon desc
GO
--Tạo Synonym cho Store Procedure
CREATE SYNONYM SLTNN FOR dbo.sp_SPSlTonNN
GO
----------------------------------------------------------
/*4. Tạo Synonym cho Function 
Function: xem danh sách các mặt hàng theo loại hàng (trả về dạng bảng)*/
create function f_XemSPTheoLSP (@MaLoaiSP nvarchar(50))
returns table
as
return (select * from SANPHAM where MaLoaiSP = @MaLoaiSP)
GO
--Tạo Synonym cho Function 
CREATE SYNONYM SPLSP FOR dbo.f_XemSPTheoLSP
GO
--------------------------------------------------------------------------------------------------------------------
									/*Index: tối thiểu 2*/
--------------------------------------------------------------------------------------------------------------------
--Tạo Index trên Mã Sản phẩm của bảng CTPHIEUNHAP
CREATE INDEX IndexMaSP on CTPHIEUNHAP(MaSP)
GO
----------------------------------------------------------
--Tạo Index cho 2 thuộc tính
CREATE INDEX IndexHD_KH_NV
ON HOADON(MaKH,MaNV) 
GO
----------------------------------------------------------
--Tạo Index cho 2 thuộc tính
CREATE INDEX IndexSP_DGB_LSP
ON SANPHAM(DgBan,MaLoaiSP)
GO
---------------------------------------------------------
-- Tạo Index để sắp xếp
CREATE INDEX IndexSXSlTon
ON SANPHAM(TenSP, SlTon desc)
GO
---------------------------------------------------------------------------------------------------------------
						/*View: tối thiểu 4, đa dạng (cơ bản, gom nhóm/thống kê, lồng)*/
--------------------------------------------------------------------------------------------------------------------
--1	 Tạo vwDanhSachNhanVienNu với các thông tin gồm: mã nhân viên, họ tên nhân viên, ngày sinh của các nhân viên nữ
create view VwDanhSachNhanVienNu 
as
select MaNV, HoNv,TenNv, NgaySinh
from NHANVIEN
where GioiTinh = N'Nữ'
GO
------------------------------------------------------------------------------
--2.Tạo view vwThongTinPhieuNhap với các thông tin: mã phiếu nhập,mã nhà cung cấp, tên nhà cung cấp, ngày nhập
create view VwThongTinPhieuNhap
as
select MaPN, ncc.MaNCC, TenNCC, NgayNhap
from PHIEUNHAP pn inner join NHACUNGCAP ncc on pn.MaNCC=ncc.MaNCC
group by MaPN,ncc.MaNCC, TenNCC, NgayNhap
GO
------------------------------------------------------------------------------
/*3.Cho biết danh sách các khách hàng gồm mã khách hàng, họ tên khách hàng, số lượng hóa đơn đã mua (nếu khách đó chưa mua hàng thì cột số lượng hóa đơn để trống)*/
create view VwDanhSachKHDatHang
as
select kh.MaKH,TenKH,
case  when count(MaHD) >0 then count(MaHD) else null end as N'Số lượng đặt'
from KHACHHANG kh full join HOADON hd on kh.MaKh= hd.MaKH
group by kh.MaKH,TenKH
GO
------------------------------------------------------------------------------
--4	Tạo view vwThongTinHoadon918 với các thông tin: Mã hóa đơn, họ, tên nhân viên của các hóa đơn tháng 9 năm 2018
create view vwThongTinHoaDon918
as
select hd.MaHD,HoNV+' '+ TenNV as N'Họ và tên nhân viên'
from  HOADON hd inner join NHANVIEN nv on nv.MaNV= hd.MaNv
where month(NgayLapHD)= 9 and year(NgayLapHD)=2021
GO
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
GO
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
GO
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
GO
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
GO
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
GO
---------------------------------------------------------------
 /*4.Viết hàm tính doanh thu cho từng sản phẩm (giá bán – giá mua)* số lượng đặt từng mặt hàng*/
create function f_DoanhThuTungMh ()
returns table
as
	return(
	select ctpn.MaSP, sum((DgBan - DgNhap)*SlBan) as DoanhThu
	from CTHOADON cthd  join CTPHIEUNHAP ctpn on ctpn.MaSP= cthd.MaSP 
	group by ctpn.MaSP)
GO
---------------------------------------------------------------
/*5. Viết hàm xem danh sách các sản phẩm theo loại sản phẩm (trả về dạng bảng)*/
create function f_XemMhTheoLh (@MaLoaiSP nvarchar(50))
returns table
as
return (select * from SANPHAM where MaLoaiSP = @MaLoaiSP)
GO
--------------------------------------------------------------------------------------------------------------------------------------------
						/*Store Procedure: tối thiểu 6, trong đó ít nhất 4 SP có tham số*/
--------------------------------------------------------------------------------------------------------------------------------------------
--1.Cho biết danh sách 5 mặt hàng có số lượng tồn nhiều nhất
create proc sp_5MhSlTonMax
as
select top 5 *
from SANPHAM
order by SlTon desc
GO
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
GO
---------------------------------------------------------------
/*3.Xem đơn giá của một mặt hàng với mã mặt hàng do người dùng nhập*/
create proc sp_DgSanPham @MaSP nvarchar(10)
as
select DgBan as N'Đơn giá'
from SANPHAM
where MaSP = @MaSP
GO
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
GO
---------------------------------------------------------------
/*5 Xem thông tin đơn hàng gồm mã hóa đơn, mã sản phẩm, tên sản phẩm,
số lượng bán, đơn giá bán theo khoảng thời gian từ ngày đến ngày do người dùng yêu cầu.*/
create proc sp_TTDonHang_KhoangTg @tungay date, @denngay date
as  
select hd.MaHd, sp.MaSP, TenSP, SlBan, cthd.DgBan
from HOADON hd join CTHOADON cthd on hd.MaHD= cthd.MaHD join SANPHAM sp on sp.MaSP=cthd.MaSP
where NgayLapHD between @tungay and @denngay
GO
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
GO
---------------------------------------------------------------
/*7.Ngày lập là tham số truyền vào và doanh thu là tham số truyền ra*/
Create proc sp_DoanhThuBanHang @NgayBan datetime, @DoanhThu int output
As
Select  @DoanhThu=Sum(SlBan*DgBan) 
From HOADON hd inner join CTHOADON ct on hd.MaHD=ct.MaHD
Where NgayLapHD = @NgayBan
GO
---------------------------------------------------------------
/*8.Viết thủ tục xóa Khách hàng khi nhập mã Khách hàng*/
Create proc sp_XoaKh @MaKH nvarchar(10)
as
delete KHACHHANG where MaKH =@MaKH
GO
-------------------------------------------------------------------------------------
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
GO
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
GO
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
GO
----------------------------------------------------------------------
/*6.1. Cập nhật sản phẩm trong kho sau khi có phiếu nhập hàng*/
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
GO
--------------------------------------------------------------------------------------------------------------------------------------------
							/*User: tối thiểu 2 mức: quản lý và nhân viên*/
--------------------------------------------------------------------------------------------------------------------------------------------
--1. Tạo đăng nhập cho nhà quản lý: Xuân Nương
CREATE LOGIN NQL_XuanNuong with password = '12345', default_database = QuanLyBanHangVinMart
GO
--2. Tạo người dùng cho đăng nhập
CREATE USER NQL_XuanNuong FOR LOGIN NQL_XuanNuong 
GO
--3. Cấp tất cả quyền cho Nhà quản lý: Xuân Nương và có thể cấp quyền cho người khác
GRANT ALL ON NHANVIEN TO NQL_XuanNuong WITH GRANT OPTION
GO
GRANT ALL ON KHACHHANG TO NQL_XuanNuong WITH GRANT OPTION
GO
GRANT ALL ON NHACUNGCAP TO NQL_XuanNuong WITH GRANT OPTION
GO
--4. Tạo đăng nhập Nhân viên Quản lý: Đình Quý
CREATE LOGIN NVQL_DinhQuy with password = '12345', default_database = QuanLyBanHangVinMart
GO
--5. Tạo người dùng cho đăng nhập
CREATE USER NVQL_DinhQuy FOR LOGIN NVQL_DinhQuy
GO
--6. Cấp quyền xem và cật nhật, thêm cho Nhân viên Quản lý: Đình Quý
GO
GRANT SELECT, UPDATE, INSERT ON NHANVIEN TO NVQL_DinhQuy 
GO
GRANT SELECT, UPDATE, INSERT ON KHACHHANG TO NVQL_DinhQuy 
GO
--7. Tạo đăng nhập cho Nhân viên 1: Lê Thị Cúc và Nhân viên 2: Mai Minh Mẫn
CREATE LOGIN NV1_LeThiCuc with password = '12345', default_database = QuanLyBanHangVinMart
GO
CREATE LOGIN NV2_MaiMinhMan with password = '12345', default_database = QuanLyBanHangVinMart
GO
--8. Tạo người dùng cho đăng nhập
CREATE USER NV1_LeThiCuc FOR LOGIN NV1_LeThiCuc
GO
CREATE USER NV2_MaiMinhMan FOR LOGIN NV2_MaiMinhMan
GO
/*9. Cấp quyền xem, cập nhật, thêm trong các bảng Phiếu nhâp (PHIEUNHAP),
Chi tiết Phiếu nhập (CTPHIEUNHAP)*/
GRANT SELECT, UPDATE, INSERT ON PHIEUNHAP TO NV1_LeThiCuc,NV2_MaiMinhMan
GO
GRANT SELECT, UPDATE, INSERT ON CTPHIEUNHAP TO NV1_LeThiCuc,NV2_MaiMinhMan
GO
--10. Tạo nhóm người dùng: NhanvienBanhang
CREATE ROLE NhanvienBanhang
GO
--11. Thêm 2 người dùng: NV1_LeThiCuc, NV2_MaiMinhMan vào nhóm NhanvienBanhang
sp_addrolemember 'NhanvienBanhang', 'NV1_LeThiCuc'
GO
sp_addrolemember 'NhanvienBanhang', 'NV2_MaiMinhMan'
/*12. Cấp quyền xem, cập nhật, thêm trong các bảng Hóa đơn (HOADON),
Chi tiết Hóa đơn (CTHOADON)*/
GRANT SELECT, UPDATE, INSERT ON HOADON TO NhanvienBanhang
GO
GRANT SELECT, UPDATE, INSERT ON CTHOADON TO NhanvienBanhang
GO
--13. Cấp quyền xem bảng Sản phẩm, Loại sản phẩm, Nhà cung cấp cho tất cả mọi người
GRANT SELECT ON SANPHAM TO PUBLIC 
GO
GRANT SELECT ON LOAISANPHAM TO PUBLIC 
GO
GRANT SELECT ON NHACUNGCAP TO PUBLIC 
GO
/*--14. Hủy quyền cập nhật Hóa đơn của Nhân viên 1: NV1_LeThiCuc
REVOKE UPDATE ON HOADON TO NV1_LeThiCuc
GO
--15. Hủy quyền của Nhân viên 2: NV2_MaiMinhMan
REVOKE NV2_MaiMinhMan*/
GO
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
GO
--2. Tạo Transection cho Store Procedure cập nhật số điện thoại của nhân viên khi bít mã nhân viên
create proc sp_CapnhatSoDTNV (@manv nvarchar(10), @dienthoai nvarchar(30))
as
begin transaction
update NHANVIEN
set DienThoai = @dienthoai
where MaNV= @manv
if @@ERROR <> 0 rollback
else commit
GO
-------------------------------------------------------------------------------
							/*Window function*/
-------------------------------------------------------------------------------
/*--1. Sắp xếp thứ tự theo đơn giá bán
select * , RANK() over (order by DgBan DESC) as TT
from CTHOADON
order by SlBan
--2. xếp hạng trong cùng 1 nhóm
select * , rank() over( partition by MaSP order by DgBan)
from CTHOADON*/
