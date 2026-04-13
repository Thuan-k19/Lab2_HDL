import cv2
from skimage.metrics import peak_signal_noise_ratio as psnr
from skimage.metrics import structural_similarity as ssim

def compare_images_fixed_size(image_path_1, image_path_2):
    """
    So sanh 2 buc anh xam bang chi so PSNR va SSIM.
    Duoc cau hinh co dinh cho anh kich thuoc 430 (Rong) x 554 (Cao).
    """
    TARGET_WIDTH = 430
    TARGET_HEIGHT = 554

    # 1. Doc anh truc tiep duoi dang anh xam (Grayscale - 8bit)
    # Rat phu hop de danh gia ngo ra tu thiet ke Verilog
    img1 = cv2.imread(image_path_1, cv2.IMREAD_GRAYSCALE)
    img2 = cv2.imread(image_path_2, cv2.IMREAD_GRAYSCALE)

    # Kiem tra xem file co ton tai khong
    if img1 is None or img2 is None:
        print("Loi: Khong the doc duoc anh. Vui long kiem tra lai duong dan/ten file.")
        return

    # 2. Kiem tra nghiem ngat kich thuoc (Luu y: OpenCV shape tra ve (Height, Width))
    if img1.shape != (TARGET_HEIGHT, TARGET_WIDTH):
        print(f"Loi: Anh 1 khong dung kich thuoc 430x554. Kich thuoc thuc te: {img1.shape[1]}x{img1.shape[0]}")
        return
        
    if img2.shape != (TARGET_HEIGHT, TARGET_WIDTH):
        print(f"Loi: Anh 2 khong dung kich thuoc 430x554. Kich thuoc thuc te: {img2.shape[1]}x{img2.shape[0]}")
        return

    # 3. Tinh toan PSNR va SSIM 
    # Co dinh data_range=255 vi day la anh 8-bit (tu 0 den 255)
    psnr_value = psnr(img1, img2, data_range=255)
    ssim_value = ssim(img1, img2, data_range=255)

    # 4. In ket qua
    print("-" * 45)
    print("KET QUA DANH GIA CHAT LUONG ANH (430 x 554)")
    print("-" * 45)
    print(f"File 1 (Goc)  : {image_path_1}")
    print(f"File 2 (Xu ly): {image_path_2}")
    print("-" * 45)
    print(f"PSNR : {psnr_value:.4f} dB")
    print(f"SSIM : {ssim_value:.4f}")
    print("-" * 45)
    
    return psnr_value, ssim_value

# --- Vi du cach goi ham ---
if __name__ == "__main__":
    # Thay doi ten file tuong ung voi file luu tren may cua ban
    file_anh_goc = "baitap1_anhgoc.jpg" 
    file_anh_verilog = "output555.png" # File anh output sau khi chay Verilog (da duoc chuyen sang xam va co kich thuoc 430x554)
    
    compare_images_fixed_size(file_anh_goc, file_anh_verilog)