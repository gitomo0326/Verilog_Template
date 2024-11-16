module counter10
(
    input CLK,
    input RES,
    output [3:0] Q 
);

reg [3: 0] q;

always @(posedge CLK or negedge RES) begin
   if(RES ==1'b1)
       q <= 4'd0;
   else if(Q == 4'd9)
       q <= 4'd0;
   else
       q <= Q + 4'd1;
end

assign Q = q;

endmodule
