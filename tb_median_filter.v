`timescale 1ns / 1ps
module tb_median_filter;

    // Kích thước ảnh
    parameter WIDTH  = 430;
    parameter HEIGHT = 554;
    parameter TOTAL_PIXELS = WIDTH * HEIGHT;

    // Bộ nhớ chứa ảnh đầu vào
    reg [7:0] img_in [0:TOTAL_PIXELS-1];
    
    // Tín hiệu điều khiển FSM / Counter
    reg clk;
    reg rst;
    integer fd;    // File descriptor
    integer x, y;  // Bộ đếm tọa độ

    // Tín hiệu kết nối module lọc
    reg  [7:0] p0, p1, p2, p3, p4, p5, p6, p7, p8;
    wire [7:0] median_out;

    // --- Khởi tạo Module Lọc (Đã bỏ vòng lặp ở bước trước) ---
    median uut (
        .p0(p0), .p1(p1), .p2(p2),
        .p3(p3), .p4(p4), .p5(p5),
        .p6(p6), .p7(p7), .p8(p8),
        .median_val(median_out)
    );

    // --- Hàm lấy Pixel (Zero Padding)
    function [7:0] get_pixel(input integer px, input integer py);
        begin
            if (px < 0 || px >= WIDTH || py < 0 || py >= HEIGHT) begin
                get_pixel = 8'h00; // Viền đen
            end else begin
                get_pixel = img_in[py * WIDTH + px];
            end
        end
    endfunction

    // --- 1. Tạo xung nhịp Clock ---
    initial clk = 0;
    always #5 clk = ~clk; // Đảo trạng thái mỗi 5ns (Chu kỳ 10ns)

// --- 2. Khởi tạo và Đọc file một lần duy nhất ---
    initial begin
        rst = 1; // Bật reset
        x = 0;
        y = 0;
        
        $display("Reading input image file...");
        $readmemh("pic_input.txt", img_in);
        
        fd = $fopen("pic_output.txt", "w");
        if (!fd) begin
            $display("Error: Could not open pic_output.txt");
            $finish;
        end
        
        //#18 để tắt reset an toàn, không trùng mép Clock
        #18 rst = 0; 
    end
    // --- 3. Trích xuất cửa sổ 3x3 (Mạch tổ hợp) ---
    always @(*) begin
        p0 = get_pixel(x-1, y-1); p1 = get_pixel(x, y-1); p2 = get_pixel(x+1, y-1);
        p3 = get_pixel(x-1, y  ); p4 = get_pixel(x, y  ); p5 = get_pixel(x+1, y  );
        p6 = get_pixel(x-1, y+1); p7 = get_pixel(x, y+1); p8 = get_pixel(x+1, y+1);
    end

// --- 4. Ghi file và Cập nhật tọa độ (Gộp chung vào sườn xuống của Clock) ---
    always @(negedge clk) begin
        if (!rst) begin
            // BƯỚC A: GHI DỮ LIỆU HIỆN TẠI (Lúc này x, y đang giữ nguyên từ chu kỳ trước)
            $fwrite(fd, "%02X ", median_out); 
            
            // Nếu chạy đến cuối hàng -> Ghi thêm ký tự xuống dòng
            if (x == WIDTH - 1) begin
                $fwrite(fd, "\n"); 
                
                // Nếu chạy đến Pixel cuối cùng của ảnh -> Dừng mô phỏng
                if (y == HEIGHT - 1) begin
                    $display("Done! Saved to pic_output.txt");
                    $fclose(fd);
                    $finish; 
                end
            end

            // BƯỚC B: SAU KHI GHI XONG, MỚI TĂNG TỌA ĐỘ LÊN PIXEL TIẾP THEO
            if (x == WIDTH - 1) begin
                x <= 0; // Hết 1 hàng thì quay về cột 0
                if (y < HEIGHT - 1) begin
                    y <= y + 1; // Nhảy xuống hàng tiếp theo
                end
            end else begin
                x <= x + 1; // Tiến sang cột tiếp theo
            end
        end
    end

endmodule