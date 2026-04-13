import numpy as np
from PIL import Image
import os

def hex_txt_to_grayscale_image(txt_filepath, output_image_path):
    """
    Chuyen doi file txt chua ma tran hex thanh anh Greyscale.
    
    Ho tro cac dinh dang hex: co/khong co tien to '0x', phan tach bang dau phay hoac khoang trang.
    Vi du 1: FF 00 A5 1B
    Vi du 2: 0xFF, 0x00, 0xA5, 0x1B
    """
    if not os.path.exists(txt_filepath):
        print(f"Loi: Khong tim thay file {txt_filepath}")
        return

    pixel_data = []
    
    try:
        with open(txt_filepath, 'r') as file:
            for line in file:
                # Lam sach du lieu: loai bo '0x', dau phay va khoang trang thua
                cleaned_line = line.replace('0x', '').replace(',', ' ').strip()
                
                # Bo qua cac dong trong
                if not cleaned_line:
                    continue
                
                # Chuyen doi cac gia tri hex tren mot dong thanh so nguyen he 10 (integer)
                # int(val, 16) se chuyen chuoi hex (VD: 'FF') thanh 255
                row = [int(val, 16) for val in cleaned_line.split()]
                pixel_data.append(row)
                
        # Chuyen doi list 2 chieu thanh mang NumPy voi kieu du lieu uint8 (0-255)
        pixel_array = np.array(pixel_data, dtype=np.uint8)
        
        # Tao anh tu mang NumPy. Mode 'L' (Luminance) dai dien cho anh Greyscale 8-bit
        img = Image.fromarray(pixel_array, mode='L')
        
        # Luu anh
        img.save(output_image_path)
        print(f"Thanh cong! Anh da duoc luu tai: {output_image_path}")
        print(f"Kich thuoc anh (Rong x Cao): {img.width} x {img.height} pixels")
        
    except ValueError as e:
        print(f"Loi dinh dang du lieu trong file txt: {e}")
        print("Vui long dam bao file chi chua cac gia tri Hex hop le.")
    except Exception as e:
        print(f"Da xay ra loi khong xac dinh: {e}")

# --- Vi du cach su dung ---
if __name__ == "__main__":
    # Thay doi duong dan file input va output cua ban tai day
    input_txt = "output5.txt" 
    output_img = "output555.png" # Co the dung .png, .jpg, .bmp
    
    hex_txt_to_grayscale_image(input_txt, output_img)