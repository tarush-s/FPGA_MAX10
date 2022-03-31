// clk_per_bit=(Frequency of input clock)/(Frequency of UART)
// frequency of uart=115200
module Uart_rx
#(parameter clk_per_bit=87) // fpga will run at 10MGHz
(
 input clk,                // input is 10MGHz clock
 input serial_data,
 output [7:0] rec_data
 );
 parameter idle=0,start_bit=1,data_bits=2,stop_bit=3;
  
reg [7:0] clk_count=0;
reg [2:0] bit_index=0;
reg [7:0] byte=0;
reg [2:0] main=0;         //for FSM

always @(posedge clk)
 begin 
  
  case(main)
   idle:
	 begin 
	  clk_count<=0;
	  
	  bit_index<=0;
	  
	  if(serial_data == 0)  //start bit detected 
	  
    	  main<=start_bit;
	 
	 else
	
        main<=idle;
	 end 
	
   start_bit:             //check to make sure start bit is still 0
	 begin
	  
	  if(clk_count == ((clk_per_bit-1)/2))
       begin 
		 
		  if(serial_data == 0)
		   begin 
			  
			  clk_count<=0;  // reset the counter
			  
			  main<=data_bits;
			  
			end
	     
		  else 
		   
         main<=idle;
      end
    
	  else 
	    begin
	    
		  clk_count<=clk_count+1;
		 
		  main<=start_bit;
	   
		 end
	 end// end of start_bit
	
   data_bits://wait for clks_per_bit-1 to sample data
    begin
	  
	  if(clk_count < clk_per_bit-1)
	    begin 
		   
			clk_count<=clk_count+1;
			
			main<=data_bits;
			
		 end
		
	  else
	    begin
		    
			 clk_count<=0;
			 
			 byte[bit_index]<=serial_data;
			
		 //check whether we got all the 8 bits 
		
	       if(bit_index < 7)
			   begin
				  
				  bit_index<=bit_index+1;
				  
				  main<=data_bits;
				
				end
			
			else
           begin
		     
		      bit_index<=0;
	         
	         main<=start_bit;
	         
	       end
	    end
    end

   stop_bit: //receive stop bit is 1
    begin
	   
		if(clk_count < clk_per_bit-1)
		 begin 
		   
			clk_count<=clk_count+1;
			 
			main<=stop_bit;
	  	 
		 end
		
	   else
	     begin
		   
			clk_count<=0;
			
			main<=idle;
		
	     end
    end
   	
	default:
     
	 main<=idle;
	
  endcase 
 end
 
 assign rec_data=byte;
endmodule 

		  
	
		
	 	
		     
