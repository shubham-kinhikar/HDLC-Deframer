module byte_destuffing(
input clk,rst,
input sop_delin,eop_delin,
input [7:0]data_delin,
output reg sop_des,eop_des,
output reg [7:0]data_des);

reg [3:0]wr_pnt,rd_pnt;
reg [7:0]mem[9:0];
reg start,flag,last;

always@(posedge clk)
begin
if(rst)
begin
  mem[0]<=0;//fifo initially becomes zero
 mem[1]<=0;
 mem[2]<=0;
 mem[3]<=0;
 mem[4]<=0;
 mem[5]<=0;
 mem[6]<=0;
 mem[7]<=0;
 mem[8]<=0;
 mem[9]<=0;
 //mem[10]<=0;
 //mem[11]<=0;
 //mem[12]<=0;
 //mem[13]<=0;
 //mem[14]<=0;
 //mem[15]<=0;
 wr_pnt<=0;
 start<=0;
//flag<=0; mem[10]<=0;
// mem[11]<=0;
// mem[12]<=0;
// mem[13]<=0;
// mem[14]<=0;
// mem[15]<=0;
// wr_pnt<=0;
end
// write into fifo
else if(sop_delin)// if sop_delin is high data starts to come in
begin
    start<=1'b1;// valid signal to take data when both sop and eop are low
  if(data_delin==8'h7d)//if data=7d then make flad as high
       flag=1'b1;
    else// if data is anything apart from 7d then directly store it in the fifo
     begin
        mem[wr_pnt]=data_delin;
        wr_pnt=wr_pnt+1'b1;
      end
end

else if(eop_delin==0 && start==1'b1) // if eop is low and start valid id high
 begin

  if(data_delin==8'h7d)// same as above
       flag=1'b1;
    else
     begin
        mem[wr_pnt]=data_delin;
        wr_pnt=wr_pnt+1'b1;
      end
end
      else if(eop_delin)// if eop  is high the last byte of the data has to be read so this block
 begin
  start=0;
  if(data_delin==8'h7d)
       flag=1'b1;
    else
     begin
        mem[wr_pnt]=data_delin;
      end
 end
  if(flag==1'b1)
      begin
        mem[wr_pnt]=data_delin^8'h20;
        wr_pnt=wr_pnt+1'b1;
           flag=1'b0;
           end
end
//if data is 7d
//always@(posedge clk)// if data is 7d and flag is high then neglect 7d and xor the succeding byte with 20
//begin
// if(flag==1'b1)
//      begin
//        mem[wr_pnt]=data_delin^8'h20;
//        wr_pnt=wr_pnt+1'b1;
//           flag=1'b0;
//      end
//end

//read operation
always@(posedge clk)
begin
if(rst)
begin
  data_des=0;
   sop_des=0;
   eop_des=0;
    rd_pnt=0;
     last=0;
    end
else if(eop_delin)// if eop_delin goes high then read starts
  begin
       sop_des=1'b1;
       data_des=mem[rd_pnt];
         rd_pnt=rd_pnt+1'b1;
           last=1'b1;
    end
   else if(eop_des==0 && last==1'b1)
  begin
       sop_des=1'b0;
       data_des=mem[rd_pnt];
         rd_pnt=rd_pnt+1'b1;
            if(wr_pnt==rd_pnt)//as soon as fifo is completly read ,read operation goes low
                eop_des=1'b1;

    end
else
  begin
  eop_des=0;
  data_des=0;
  last=0;
   end
end
endmodule