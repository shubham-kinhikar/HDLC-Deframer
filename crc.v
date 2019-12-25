module crc(
input clk,rst,
input [7:0] data_des,           //data
input sop_des,                  //start of packet
input eop_des,                  //start of packet
output reg [7:0] data_out,       //crc output
output reg sop_out,              //sop bit for byte stuffing module
output reg eop_out,              //eop bit for byte stuffing module
output reg error);

    reg data_trans=0;           //control bit for crc generation
    reg [15:0] crc;            //crc generator
    reg [1:0] crc_push=0;           //for sending crc data
    reg [3:0]counter;
 
    //crc calculation
    always@(posedge clk)
    begin
        if(rst)
            crc<=16'hffff;

        else if(sop_des==1 || counter >=0)
        begin
            crc[0]<=crc[12]^data_des[4]^crc[8]^data_des[0];
            crc[1]<=crc[13]^data_des[5]^crc[9]^data_des[1];
            crc[2]<=crc[14]^data_des[6]^crc[10]^data_des[2];
            crc[3]<=crc[15]^data_des[7]^crc[11]^data_des[3];
            crc[4]<=crc[12]^data_des[4];
            crc[5]<=crc[12]^data_des[4]^crc[8]^data_des[0]^crc[13]^data_des[5];
            crc[6]<=crc[13]^data_des[5]^crc[9]^data_des[1]^crc[14]^data_des[6];
            crc[7]<=crc[14]^data_des[6]^crc[10]^data_des[2]^crc[15]^data_des[7];
            crc[8]<=crc[15]^data_des[7]^crc[11]^data_des[3]^crc[0];
            crc[9]<=crc[12]^data_des[4]^crc[1];
            crc[10]<=crc[13]^data_des[5]^crc[2];
            crc[11]<=crc[14]^data_des[6]^crc[3];
            crc[12]<=crc[12]^data_des[4]^crc[8]^data_des[0]^crc[15]^data_des[7]^crc[4];
            crc[13]<=crc[13]^data_des[5]^crc[9]^data_des[1]^crc[5];
            crc[14]<=crc[14]^data_des[6]^crc[10]^data_des[2]^crc[6];
            crc[15]<=crc[15]^data_des[7]^crc[11]^data_des[3]^crc[7];
        end

        else
            crc<=crc;
    end
    //output block
    
    always@(posedge clk)
    begin
        if(rst)
        begin
            data_out<=8'h7e; //idle
            sop_out<=0;
            eop_out<=0;
        end

        else
        begin
            if(sop_des)
            begin
                data_out<=data_des;
                sop_out<=1;
                eop_out<=0;
            end
            else if(counter<=7)
            begin
                data_out<=data_des;
                sop_out<=0;
                eop_out<=0;
            end
            else
            begin
                data_out<=00;  //idle bit
                sop_out<=0;
                eop_out<=0;
            end
        end

    end
     // counter control flag
     
    always@(posedge clk)
    begin
    if(rst)
    counter<=0;
    else if(sop_des == 1)
    counter<=1;
    else if(counter > 0 && counter <= 7)
    counter<=counter+1;
    else
    counter<=counter+1;
    end
   // end
//    always @ (posedge clk)
//    begin
    always @ (eop_des)
    begin
    if(data_out==0)
    error<=1'b0;
    else
    error<=1'b1;
    end
    endmodule