module delineation (input clk,rst,[7:0]data_fr, output reg
sop_delin,eop_delin,start, output reg [7:0]data_delin);
always @ (posedge clk)
begin
if(rst)
begin
sop_delin<=1'b0;
eop_delin<=1'b0;
data_delin<=1'b0;
start<=1'b0;
end
else
begin
if((data_fr!==8'h7e)&&(start==0))
begin
sop_delin<=1'b1;
eop_delin<=1'b0;
start<=1'b1;
data_delin<=data_fr;
end
else if((data_fr!==8'h7e)&&(start==1))
begin
sop_delin<=1'b0;
data_delin<=data_fr;
end
else if((data_fr==8'h7e)&&(start==1))
begin
eop_delin<=1'b1;
data_delin<=data_fr;
start<=1'b0;
end
else if((data_fr==8'h7e)&&(start==0))
begin
eop_delin<=1'b0;
end
end
end
endmodule