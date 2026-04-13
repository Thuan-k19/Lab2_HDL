module one_pixel_gray (
    input  wire [7:0] r,g,b,
    input  wire signed [8:0] brightness,
    output wire [7:0] gray
);

    wire [15:0] gray_Y = (r * 8'd77) + (g * 8'd150) + (b * 8'd29);
    wire [7:0]  gray_temp = gray_Y[15:8];
    
    wire signed [9:0] gray_calc = {2'b00, gray_temp} + brightness;

    assign gray = (gray_calc < 0) ? 8'd0 : (gray_calc > 255) ? 8'd255 : gray_calc[7:0];

endmodule