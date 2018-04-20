CON
  _clkmode = xtal1 + pll16x                                               'Standard clock mode * crystal frequency = 80 MHz
  _xinfreq = 5_000_000


CON
  DIO_PIN = 26
  CLK_PIN = 25
  STB_PIN = 24

  
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
  send_byte($ff)
  send_byte($00)
  send_byte($ff)
  send_byte($00)
  send_byte($ff)
  send_byte($00)  
  send_byte($ff)
  send_byte($00)
  send_byte($ff)
  send_byte($00)  
  send_byte($ff)
  send_byte($00)  
  send_byte($ff)
  send_byte($00)  
  send_byte($ff)
  send_byte($00)   
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

        