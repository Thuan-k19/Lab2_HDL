module pixels_gray (
    input  wire [10919:0] r_array,
    input  wire [10919:0] g_array,
    input  wire [10919:0] b_array,
    input  wire signed [8:0] brightness,
    output wire [10919:0] gray_array
);

    genvar i;
    generate
        for (i = 0; i < 1365; i = i + 1) begin : pixel
            one_pixel_gray core (
                .r(r_array[i*8 +: 8]), 
                .g(g_array[i*8 +: 8]),
                .b(b_array[i*8 +: 8]),
                .brightness(brightness),
                .gray(gray_array[i*8 +: 8])
            );
        end
    endgenerate

endmodule