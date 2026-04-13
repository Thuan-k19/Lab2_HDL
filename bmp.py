from PIL import Image
import os

def convert_to_bitmap(input_image_path, output_bmp_path, mode="24bit", threshold=128):
    """
    Chuyen doi anh (JPG, PNG, RGB...) sang file anh Bitmap (.bmp)
    
    Tham so:
    - mode="24bit": Giu nguyen mau RGB, chi doi dinh dang file thanh .bmp
    - mode="1bit": Chuyen thanh anh den trang (monochrome 1-bit)
    - threshold: Nguong sang de phan loai Den/Trang (ap dung cho mode 1bit)
    """
    if not os.path.exists(input_image_path):
        print(f"Loi: Khong tim thay file '{input_image_path}'")
        return

    try:
        # Mo anh goc
        img = Image.open(input_image_path)

        if mode == "24bit":
            # Dam bao anh o he mau RGB (loai bo kenh Alpha/trong suot neu co)
            img = img.convert("RGB")
            # Luu thang duoi dinh dang BMP
            img.save(output_bmp_path, format="BMP")
            print(f"Thanh cong! Da luu anh Bitmap Mau tai: {output_bmp_path}")

        elif mode == "1bit":
            # Buoc 1: Chuyen sang anh xam (Grayscale - mode 'L')
            img_gray = img.convert("L")
            
            # Buoc 2: Ep ve 1-bit (Den/Trang) dua tren nguong Threshold
            # Neu diem anh >= threshold -> 255 (Trang), nguoc lai -> 0 (Den)
            # Che do (mode) '1' trong PIL se dong goi 8 pixel vao 1 byte de toi uu dung luong
            img_1bit = img_gray.point(lambda x: 255 if x >= threshold else 0, mode='1')
            
            # Luu file BMP
            img_1bit.save(output_bmp_path, format="BMP")
            print(f"Thanh cong! Da luu anh Bitmap 1-bit (Den/Trang) tai: {output_bmp_path}")

        else:
            print("Loi: Che do (mode) khong hop le. Vui long chon '24bit' hoac '1bit'.")

    except Exception as e:
        print(f"Da xay ra loi trong qua trinh chuyen doi: {e}")


# --- Vi du cach su dung ---
if __name__ == "__main__":
    # Thay bang duong dan toi anh goc cua ban
    anh_goc = "baitap2_anhgoc.jpg" 
    
    anh_bmp_mau = "anh_mau.bmp"
    anh_bmp_den_trang = "ket_qua_den_trang.bmp"

    # 1. Chuyen thanh file .bmp (Giu nguyen mau sac 24-bit RGB)
    convert_to_bitmap(anh_goc, anh_bmp_mau, mode="24bit")

    # 2. Chuyen thanh file .bmp 1-bit (Chi co Den va Trang) voi nguong 127
    convert_to_bitmap(anh_goc, anh_bmp_den_trang, mode="1bit", threshold=127)