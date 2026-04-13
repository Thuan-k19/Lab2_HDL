module sort2 (
    input wire [7:0] a, b,
    output wire [7:0] max, min
);
    assign max = (a > b) ? a : b;
    assign min = (a < b) ? a : b;
endmodule