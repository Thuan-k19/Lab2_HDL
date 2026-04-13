module sort3 (
    input  wire [7:0] in1, in2, in3,
    output wire [7:0] min_out, mid_out, max_out
);
    wire [7:0] max1, min1, min2;

    sort2 sort12 (.a(in1), .b(in2), .max(max1), .min(min1));
    sort2 sort13 (.a(max1), .b(in3), .max(max_out), .min(min2));
    sort2 sort_min (.a(min1), .b(min2), .max(mid_out), .min(min_out));
    
endmodule