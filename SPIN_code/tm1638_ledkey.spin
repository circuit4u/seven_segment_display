CON
  _clkmode = xtal1 + pll16x                                               'Standard clock mode * crystal frequency = 80 MHz
  _xinfreq = 5_000_000


CON
  DIO_PIN = 24
  CLK_PIN = 25
  STB_PIN = 26

DAT
  digits BYTE %00111111, %00000110, %01011011, %01001111, %01100110, %01101101, %01111101, %00000111, %01111111, %01101111    
  
  
PUB main

  dira[DIO_PIN] := 1
  dira[CLK_PIN] := 1
  dira[STB_PIN] := 1

  outa[STB_PIN] := 1
  outa[CLK_PIN] := 1

  start 
  send_byte($8f) 'turn on 
  end
  
  start
  send_byte($40) 'write to register
  end
                         
  start           'clear
  send_byte($c0)
  repeat 16  
    send_byte($00)
  end


  start
  send_byte($c0)

  send_byte(digits[3]^$80)
  send_byte($01)
  send_byte(digits[1])
  send_byte($01)
  send_byte(digits[4])
  send_byte($01)
  send_byte(digits[1])
  send_byte($01)
  send_byte(digits[5])
  send_byte($01)
  send_byte(digits[9])
  send_byte($01)
  send_byte(digits[2])
  send_byte($01)
  send_byte(digits[6])
  send_byte($01)    
  end
                    
  repeat  

   
  


PRI send_byte(data_byte)   
  'lsb first
   repeat 8
     outa[CLK_PIN] := 0
     delay
     outa[DIO_PIN] :=  data_byte & $01
     data_byte >>= 1
     outa[CLK_PIN] := 1
     delay
     
 
PRI start    
  outa[STB_PIN]:= 0 
  delay


PRI end 
  outa[STB_PIN] := 1
  delay
 

PRI delay '10us
  waitcnt(clkfreq/100_000 + cnt)    

        