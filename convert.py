from PIL import Image
import numpy as np

def exact_image_to_hex(image_path, output_path):
    try:
        # 1. Mo anh
        img = Image.open(image_path)
        print(f"Kich thuoc anh goc: Width = {img.width}, Height = {img.height}")
        
        # Kiem tra neu kich thuoc khong dung 430x554
        if img.width != 430 or img.height != 554:
            print("Canh bao: Anh goc khong phai kich thuoc 430x554. Vui long kiem tra lai file anh!")
        
        # 2. Chuyen sang che do Grayscale
        img = img.convert('L')
        
        # 3. Lay mang pixel TRUC TIEP (Khong dung bat ky bo loc resize nao)
        pixel_array = np.array(img)
        
        # 4. Ghi truc tiep ra file txt
        with open(output_path, 'w', encoding='utf-8') as f:
            for row in pixel_array:
                # Dinh dang hex in hoa, khong co '0x', cach nhau bang khoang trang
                row_string = " ".join([f"{pixel:02X}" for pixel in row])
                f.write(row_string + "\n")
                
        print("Da tao ma tran thanh cong! Gia tri pixel da duoc giu nguyen ban 100%.")
        
    except FileNotFoundError:
        print(f"Loi: Khong tim thay anh '{image_path}'")
    except Exception as e:
        print(f"Loi khong mong muon: {e}")

if __name__ == "__main__":
    # Thay doi ten file cho khop voi anh ban vua gui
    input_image = r'D:\Mthuan\UIT\4.HDL\Lab2\baitap1_anhgoc.jpg'
    output_matrix = r'D:\Mthuan\UIT\4.HDL\Lab2\output_goc.txt'
    
    exact_image_to_hex(input_image, output_matrix)