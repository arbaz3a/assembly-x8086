                                             .model small
.stack 100h
.data            

    line_setting db "-------------------------", '$'
    start_message db " START: ", '$'                  
    time_symbol db " HH:MM:SS ", '$'
    time_format db " 00:00:00 ", '$'
    newline db 13, 10, '$' 
    input_button db ? 
    hours db 0 
    minutes db 0
    seconds db 0   
    
    first_message db " WELCOME TO emmi DIGITAL STOP WATCH ", '$'
    instruction_0 db " INSTRUCTIONS: ", 13, 10,  '$'
    instruction_1 db " Press 'S' or 's' to start the stopwatch. ", '$' 
    instruction_2 db " Press 'P' or 'p' to pause the stopwatch. ", '$'
    instruction_3 db " Press 'R' or 'r' to resume the stopwatch. ", '$'
    instruction_4 db " Press 'X' or 'x' to restart the stopwatch.", '$'
    instruction_5 db " Press 'E' or 'e' to exit the stopwatch. ", '$'
    instruction_6 db " Press '1' TO OPEN emmi DIGITAL STOP WATCH: ", '$'
    instruction_6_input db ?
    last_message db " THANKS FOR USING emmi DIGITAL STOP WATCH ", '$'
     
.code
main proc
    
    mov ax, @data
    mov ds, ax  
               
    ;cursor position
    mov ah, 02h
    mov dh, 1
    mov dl, 7
    int 10h           
               
    lea dx, first_message
    mov ah, 09h
    int 21h
    
    ;cursor position
    mov ah, 02h
    mov dh, 3
    mov dl, 7
    int 10h 
    
    
    lea dx, instruction_0
    mov ah, 09h
    int 21h
     
     
    ;cursor position
    mov ah, 02h
    mov dh, 5
    mov dl, 9
    int 10h 
     
               
    lea dx, instruction_1
    mov ah, 09h
    int 21h       
    
    ;cursor position
    mov ah, 02h
    mov dh, 6
    mov dl, 9
    int 10h 
    
    lea dx, instruction_2
    mov ah, 09h
    int 21h      
    
    ;cursor position
    mov ah, 02h
    mov dh, 7
    mov dl, 9
    int 10h 
    
    lea dx, instruction_3
    mov ah, 09h
    int 21h
    
    ;cursor position
    mov ah, 02h
    mov dh, 8
    mov dl, 9
    int 10h 
    
    
    lea dx, instruction_4
    mov ah, 09h
    int 21h   
       
    ;cursor position
    mov ah, 02h
    mov dh, 9
    mov dl, 9
    int 10h 
    
    
    lea dx, instruction_5
    mov ah, 09h
    int 21h           
    
    ;cursor position
    mov ah, 02h
    mov dh, 11
    mov dl, 5
    int 10h
    
                  
    lea dx, instruction_6
    mov ah, 09h
    int 21h           
          
          

valid_input: 
    
    ;cursor position
    mov ah, 02h
    mov dh, 11
    mov dl, 49
    int 10h
               
    mov ah, 01h
    int 21h
    mov instruction_6_input, al
    
    cmp instruction_6_input, '1'
    jne valid_input
    
        
    ;clear screen         
    call clear_screen             
    

    ;something
    mov bh, 0
               
               
    ;cursor position
    mov ah, 02h
    mov dh, 0
    mov dl, 0
    int 10h
                
                
    ;display line 
    lea dx, line_setting
    mov ah, 09h
    int 21h 
     
   
    ;cursor position
    mov ah, 02h
    mov dh, 1
    mov dl, 4
    int 10h
             
             
    ;display start message 
    lea dx, start_message
    mov ah, 09h
    int 21h  
    
            
             
;start main process
start_process_label:

    ;cursor position
    mov ah, 02h
    mov dh, 1
    mov dl, 12
    int 10h

    mov ah, 01h
    int 21h               
    mov input_button, al 
    
    ;newline
    lea dx, newline
    mov ah, 09h
    int 21h
    
    ;display line 
    lea dx, line_setting
    mov ah, 09h
    int 21h  
 
    ;check if wrong input              
    cmp input_button, 'S'
    je start_below
    
    cmp input_button, 's' 
    jne start_process_label  
    
    
    
start_below:
    
    ;newline
    lea dx, newline
    mov ah, 09h
    int 21h 
    
    ;cursor position
    mov ah, 02h
    mov dh, 4
    mov dl, 9
    int 10h
    
    ;display time symbols
    lea dx, time_symbol
    mov ah, 09h
    int 21h
    
    
update_time:

    ;cursor position
    mov ah, 02h
    mov dh, 6
    mov dl, 9
    int 10h
            
            
    ;hours in time_format
    mov al, hours
    call convert_two_digits
    mov time_format[1], al 
    mov time_format[2], ah 
             
             
    ;minutes in time_format
    mov al, minutes
    call convert_two_digits
    mov time_format[4], al 
    mov time_format[5], ah
            
            
    ;seconds in time_format
    mov al, seconds
    call convert_two_digits
    mov time_format[7], al 
    mov time_format[8], ah 
        
        
    ;display time
    lea dx, time_format
    mov ah, 09h
    int 21h
             
             
    ;delay shit 
    mov cx, 20
    delay:
        loop delay
                 
                 
    ;for pause timer
    mov ah, 01h
    int 16h
    jz continue      
    mov ah, 00h           
    int 16h   
    
    
    ;restart stopwatch       
    call restart_time
           
    ;exit the program
    call exit_shit
    
           
    cmp al, 'P'
    je pause_phase
    cmp al, 'p' 
    jne continue           
         
               
               
pause_phase:   
       
    ;for resume timer
    mov ah, 01h           
    int 16h
    jz pause_phase         
    mov ah, 00h         
    int 16h  
    
                   
    ;restart stopwatch                      
    call restart_time
    
    ;exit the program
    call exit_shit
     
     
    cmp al, 'R'
    je continue
    cmp al, 'r'          
    jne pause_phase
    
    
             
continue: 
     
    inc seconds 
    ;checking if seconds exceed 60
    cmp seconds, 60
    jl skip_minute

    mov seconds, 0  
    
    inc minutes
    ;checking if minutes exceed 60
    cmp minutes, 60
    jl skip_hour 
    
    mov minutes, 0 
    
    inc hours
           
           
           
skip_hour: 
  
    ;checking if hours exceed 24
    cmp hours, 24
    jl skip_minute
    mov hours, 0
              
              
              
skip_minute: 

    jmp update_time
    
         
         
;restart stopwatch procedure
restart_time proc
    
            
    cmp al, 'x'
    je zero
    cmp al, 'X'
    je zero
    ret
    
restart_time endp

   
   
;exit procedure
exit_shit proc
    
    cmp al, 'e'
    je exit_main
    cmp al, 'E'
    je exit_main
    ret 
    
exit_shit endp


               
;convert into two digits fornat procedure  
convert_two_digits proc
    
    xor ah, ah  
    mov bl, 10
    div bl
    add ah, '0' ;ascii to digit
    add al, '0' ;ascii to digit
    ret
    
convert_two_digits endp
           
                     

;clear screen procedure
clear_screen proc 
    
    mov ah, 06h                   
    mov bh, 07h          
    mov cx, 0           
    mov dx, 184Fh
    int 10h
    ret   
    
clear_screen endp                                                             
    
    
                                          
;restart the whole time by pressing s/S
zero:   

    mov seconds, 0
    mov minutes, 0
    mov hours, 0
    jmp update_time

       
       
;exiting of main program
exit_main:
           
    ;cursor position
    mov ah, 02h
    mov dh, 9
    mov dl, 7
    int 10h
    
    lea dx, last_message
    mov ah, 09h
    int 21h   
    
    ;newline 
    lea dx, newline
    mov ah, 09h
    int 21h
    
    mov ah, 08h ; without echo input
    int 21h
    
    mov ah, 4ch
    int 21h
       
;main endp
end main