module Sequence_detector(
  input clk,
  input I,
  output y
  );
  
 parameter idle=0,A=1,B=2,C=3;
 reg [2:0]state=idle;
 reg temp=1;
 always@(posedge clk)
  begin 
   case(state)
	 idle:begin
			 if(I==1)
			 begin
			  temp <=1;
			  state <= A;
			 end 
			 else
			 begin
			  temp<=1;
			  state <= idle;
			  end
			end
	    A:begin
	       if(I==0)
		      state <= B;
		    else
		      state <= idle;
		   end
	    B:begin
	       if(I==1)
		     state <= C;
			 else
		     state <= idle;
			end
	    C:begin
	       if(I==0)
		      begin 
		       temp <= 0;
			    state <= idle;
			   end
		     else 
			   state <= idle;
		   end 
	endcase 
 end 
assign y=temp;	
endmodule
