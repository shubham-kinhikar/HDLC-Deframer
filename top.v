module deframe(input clk,rst,[7:0]data_fr,output sop_out,eop_out,error,output [7:0]data_out);
wire sop_delin,eop_delin,start;
wire [7:0]data_delin;
delineation d1(.clk(clk),.rst(rst),.data_fr(data_fr),.sop_delin(sop_delin),.eop_delin(eop_delin),.start(start),.data_delin(data_delin));
wire sop_des,eop_des;
wire [7:0]data_des;
byte_destuffing d2(.clk(clk),.rst(rst),.sop_delin(sop_delin),.eop_delin(eop_delin),.data_delin(data_delin),.sop_des(sop_des),.eop_des(eop_des),.data_des(data_des));
crc d3(.clk(clk),.rst(rst),.sop_des(sop_des),.eop_des(eop_des),.data_des(data_des),.sop_out(sop_out),.eop_out(eop_out),.data_out(data_out),.error(error));
endmodule