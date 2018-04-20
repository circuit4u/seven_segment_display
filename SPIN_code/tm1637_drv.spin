CON
  _clkmode = xtal1 + pll16x
  _xinfreq = 5_000_000
  
CON
  DIO_PIN = 24
  CLK_PIN = 25

CON 
  DISPLAY_ON = $8f
  DISPLAY_OFF = $80
  
  DATA_CMD = $40
  ADDR_CMD = $C0

DAT
  digits BYTE %00111111, %00000110, %01011011, %01001111, %01100110, %01101101, %01111101, %00000111, %01111111, %01101111    
  
PUB main
  'init: external pull up to set both DIO and CLK high
  dira[DIO_PIN] := 0    
  dira[CLK_PIN] := 0
  
  start 'start condition
  send_byte(DISPLAY_ON) 'turn-on display; full brightness
  end

  start
  send_byte(DATA_CMD)
  end

  start
  send_byte(ADDR_CMD)
  send_byte(digits[3] | $80)
  send_byte(digits[1])
  send_byte(digits[4])
  send_byte(digits[8]) 
  end

  repeat
  

  
PRI start
  'get ready to drive low
  outa[DIO_PIN] := 0
  outa[CLK_PIN] := 0
  'start condition 
  dira[DIO_PIN]:= 1 'drive DIO low
  delay
  dira[CLK_PIN] := 1 'drive CLK low
  
PRI send_byte(data_byte)  
  '8-bit LSB first
  repeat 8
    outa[CLK_PIN] := 0
    delay
    outa[DIO_PIN] :=  data_byte & $01
    data_byte >>= 1
    outa[CLK_PIN] := 1
    delay
  
  '9th CLK for ACK bit
  outa[CLK_PIN] := 0      
  dira[DIO_PIN] := 0 'release DIO for ACK 
  delay             
  outa[CLK_PIN] := 1 
  delay
  outa[CLK_PIN] := 0 'finish 9th CLK; TM1637 release DIO 

  outa[DIO_PIN] := 0  
  dira[DIO_PIN] := 1 'reclaim DIO
  delay
  
PRI end  
  'end condition
  outa[CLK_PIN] := 1
  delay
  outa[DIO_PIN] := 1
  delay
  
  'release bus
  dira[CLK_PIN] := 0  
  dira[DIO_PIN] := 0

  
PRI delay 
  '~10us
  waitcnt(clkfreq/100_000 + cnt)
