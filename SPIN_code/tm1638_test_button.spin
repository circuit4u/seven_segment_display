CON
  _clkmode = xtal1 + pll16x                                             
  _xinfreq = 5_000_000


CON
  DIO_PIN = 26
  CLK_PIN = 25
  STB_PIN = 24

VAR
  byte DIN[4]
       
  
PUB main    | Index     

  dira[DIO_PIN] := 1
  dira[CLK_PIN] := 1
  dira[STB_PIN] := 1

  outa[STB_PIN] := 1
  outa[CLK_PIN] := 1

  
  repeat
    start
    send_byte($42)
    delay
    repeat Index from 0 to 3
      read_byte(@DIN[Index])      
    end
           
    waitcnt(clkfreq/10 + cnt)




PRI send_byte(data_byte)

   
  'lsb first
   repeat 8
     outa[CLK_PIN] := 0
     delay
     outa[DIO_PIN] :=  data_byte & $01
     data_byte >>= 1
     outa[CLK_PIN] := 1
     delay

PRI read_byte(data_byte_addr) | tmp
  tmp := 0
  dira[DIO_PIN]~
  repeat 8
    tmp <<= 1
    outa[CLK_PIN] := 0
    delay
    outa[CLK_PIN] := 1        
    tmp := tmp | ina[DIO_PIN]           
    delay
      
  byte[data_byte_addr] := tmp >< 8 
  dira[DIO_PIN]~~     
 
PRI start    
  outa[STB_PIN]:= 0 
  delay


PRI end 
  outa[STB_PIN] := 1
  delay
 

PRI delay '10us
  waitcnt(clkfreq/100_000 + cnt)    

        