module median(
    input  wire [7:0] p0, p1, p2, p3, p4, p5, p6, p7, p8,
    output wire [7:0] median_val
);

    wire [7:0] min1, mid1, max1;
    wire [7:0] min2, mid2, max2;
    wire [7:0] min3, mid3, max3;

    sort3 row1 (.in1(p0), .in2(p1), .in3(p2), .min_out(min1), .mid_out(mid1), .max_out(max1));
    sort3 row2 (.in1(p3), .in2(p4), .in3(p5), .min_out(min2), .mid_out(mid2), .max_out(max2));
    sort3 row3 (.in1(p6), .in2(p7), .in3(p8), .min_out(min3), .mid_out(mid3), .max_out(max3));

    wire [7:0] max_of_min; 
    wire [7:0] mid_of_mid; 
    wire [7:0] min_of_max; 

    wire [7:0] t1, t2, t3, t4, t5, t6;

    sort3 col_min (.in1(min1), .in2(min2), .in3(min3), .min_out(t1), .mid_out(t2), .max_out(max_of_min));
    sort3 col_mid (.in1(mid1), .in2(mid2), .in3(mid3), .min_out(t3), .mid_out(mid_of_mid), .max_out(t4));
    sort3 col_max (.in1(max1), .in2(max2), .in3(max3), .min_out(min_of_max), .mid_out(t5), .max_out(t6));

    sort3 final_sort (
        .in1(max_of_min), 
        .in2(mid_of_mid), 
        .in3(min_of_max), 
        .min_out(),
        .mid_out(median_val),
        .max_out()             
    );

endmodule