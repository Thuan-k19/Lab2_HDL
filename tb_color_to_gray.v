`timescale 1ns / 1ps

module tb_color_to_gray;

    parameter WIDTH  = 2048;
    parameter HEIGHT = 1365;
    parameter TOTAL_PIXELS = WIDTH * HEIGHT;

    // ==========================================
    // BỘ NHỚ RAM ẢO LƯU TOÀN BỘ ẢNH TRONG TESTBENCH
    // ==========================================
    reg [7:0] img_R [0:TOTAL_PIXELS-1];
    reg [7:0] img_G [0:TOTAL_PIXELS-1];
    reg [7:0] img_B [0:TOTAL_PIXELS-1];
    reg [7:0] img_Gray [0:TOTAL_PIXELS-1]; // Lưu kết quả

    // ==========================================
    // TÍN HIỆU GIAO TIẾP VỚI MODULE LÕI
    // ==========================================
    reg  [10919:0] r_in, g_in, b_in;
    wire [10919:0] gray_out;
    reg signed [8:0] brightness_level;

    // Biến quản lý file BMP
    integer file_in, file_out;
    integer r, i, x, y;
    reg [7:0] bmp_header [0:53];
    reg [7:0] pad_val;
    integer row_padding;

    // Khởi tạo Module phần cứng (Đã viết ở bước trước)
    pixels_gray uut (
        .r_array(r_in), .g_array(g_in), .b_array(b_in),
        .brightness(brightness_level),
        .gray_array(gray_out)
    );

    initial begin
        // ==========================================
        // BƯỚC 1: ĐỌC TRỰC TIẾP FILE BMP VÀO RAM ẢO
        // ==========================================
        file_in = $fopen("anh_mau.bmp", "rb");
        if (!file_in) begin
            $display("Loi: Khong tim thay file anh_mau.bmp!");
            $finish;
        end

        // Copy 54 bytes Header để dành lát nữa tạo file mới
        for (i = 0; i < 54; i = i + 1) begin
            r = $fread(pad_val, file_in);
            bmp_header[i] = pad_val;
        end

        row_padding = (4 - ((WIDTH * 3) % 4)) % 4;

        $display("Dang doc anh_mau.bmp vao RAM...");
        // File BMP lưu từ hàng dưới cùng (HEIGHT-1) lên trên
        for (y = HEIGHT - 1; y >= 0; y = y - 1) begin
            for (x = 0; x < WIDTH; x = x + 1) begin
                r = $fread(pad_val, file_in); img_B[y*WIDTH + x] = pad_val;
                r = $fread(pad_val, file_in); img_G[y*WIDTH + x] = pad_val;
                r = $fread(pad_val, file_in); img_R[y*WIDTH + x] = pad_val;
            end
            // Đọc bỏ các byte rác cuối hàng
            for (i = 0; i < row_padding; i = i + 1) r = $fread(pad_val, file_in);
        end
        $fclose(file_in);


        // ==========================================
        // BƯỚC 2: BƠM DỮ LIỆU QUA MODULE PHẦN CỨNG
        // ==========================================
        $display("Dang xu ly %0d cot (Moi cot %0d pixel song song)...", WIDTH, HEIGHT);

        brightness_level = 9'sd0; // Tối đi 70

        // Quét qua 2048 CỘT
        for (x = 0; x < WIDTH; x = x + 1) begin
            
            // 2.1. Đóng gói 1365 pixel của cột 'x' vào bus dữ liệu siêu lớn
            for (y = 0; y < HEIGHT; y = y + 1) begin
                r_in[y*8 +: 8] = img_R[y*WIDTH + x];
                g_in[y*8 +: 8] = img_G[y*WIDTH + x];
                b_in[y*8 +: 8] = img_B[y*WIDTH + x];
            end

            // 2.2. Chờ mạch tổ hợp tính toán (Delay 50ns để an toàn nếu chạy Gate-Level SDO)
            #50; 

            // 2.3. Bóc tách 1365 pixel từ mạch ra, lưu lại vào RAM kết quả
            for (y = 0; y < HEIGHT; y = y + 1) begin
                img_Gray[y*WIDTH + x] = gray_out[y*8 +: 8];
            end
        end


        // ==========================================
        // BƯỚC 3: GHI RAM ẢO RA FILE BMP MỚI
        // ==========================================
        $display("Dang xuat ket qua ra output_gray.bmp...");
        file_out = $fopen("output_gray.bmp", "wb");
        
        // Trả lại Header 54-byte
        for (i = 0; i < 54; i = i + 1) $fwrite(file_out, "%c", bmp_header[i]);

        // Ghi lại từ dưới lên trên đúng chuẩn BMP
        for (y = HEIGHT - 1; y >= 0; y = y - 1) begin
            for (x = 0; x < WIDTH; x = x + 1) begin
                pad_val = img_Gray[y*WIDTH + x];
                // Ghi 3 kênh R=G=B bằng nhau để ra ảnh xám trên định dạng 24-bit
                $fwrite(file_out, "%c", pad_val); 
                $fwrite(file_out, "%c", pad_val); 
                $fwrite(file_out, "%c", pad_val); 
            end
            
            // Chèn lại byte rác vào cuối hàng nếu cần
            pad_val = 8'h00;
            for (i = 0; i < row_padding; i = i + 1) $fwrite(file_out, "%c", pad_val);
        end

        $fclose(file_out);
        $display("Thanh cong ruc ro! Da luu anh moi.");
        $finish;
    end

endmodule