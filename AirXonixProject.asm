
.model small
.stack 100h
.data
AIRXONIX db "A I R   X O N I X$"
inst_1 db "- use arrow keys to move the spaceship","$"
inst_2 db "- press 'p' to pause","$"
inst_3 db "- avoid collision with enemy spaceship","$"
inst_3_1 db " and obstacles","$"
inst_4 db "- complete the level before the timer","$"
inst_4_1 db "  runs out to win","$"
arr db 15 dup(1),13 dup(1,13 dup(0),1),15 dup(1)
rownum db 0
loopcount dw ?
enemy_x dw 100
enemy_y dw 50
enemy_row dw ?
enemy_col dw ?
pointer_x db 11
pointer_y db 5
spaceship_x dw 8
spaceship_y dw 8
clean_x dw 0
clean_y dw 0
tempbl db ?
spaceship_inner_loop dw ?
spaceship_outer_loop dw ?
timer db 61
prevtime db 0
pause db 0
timerstring db '00$'
scorestring db '00$'
pausemsg db 'PAUSED$'
nameentermsg db 'Enter your name:$'
nameuser db '        $'
inputnum db 0
gameend db 0
startgame db "Start Game","$"
selectlevel db "Select Level","$"
highscores db "High Score","$"
help db "Help","$"
exit db "Exit","$"
outofborder db 0
inborder db 0
Congrats db "Congratulations You've Won","$"
Lose db "Better Luck Next Time", "$"
YourScore db "Your Score ","$"
Score db 0
prevscore db 0
Levelmsg db "Level ","$"
LevelNo db 0
Completed db "Ends","$"
Next db "Next  Level","$"
RMainMenu db "Main Menu","$"
scoremsg db "Score:","$"
LevelA db "Level 1$"

LevelB db "Level 2$"
FNAME1 DB "1.txt", 0
fHANDLE1 DW ?
endl DB 0Dh,0Ah
FNAME DB "1.txt", 0
fHANDLE DW ?
Buf DB 100 DUP('$'), "$"
num1MSG db "1. $"
num2MSG db "2. $"
num3MSG db "3. $"
Dot db 15 DUP("."), "$"
name1 dw ?
no1 dw ?
name2 dw ?
no2 dw ?
name3 dw ?
no3 dw ?
inst_5 db "- press b for main menu","$"
pointer db "->","$"
menuselection db 1
gameendmsg db 'THANK YOU FOR PLAYING$'
enemy_l db 0
enemy_v db 0
enemyshadow_x dw 0
enemyshadow_y dw 0
enemylagcount db 0
lives db 3
tempcount db 0
;heart db U+2665
lives_count db "Lives : ","$"
filledblocks dw 0
win db 0
;in map dat
;rows=21
;cols=36
spaceshiptoggle db 0
spaceshiptoggle2 db 0
inmaparr db 38 dup (23 dup(0))
trackx db ?
tracky db ?
enemylag db ?
.code 

gameendcon proc
    mov Score,0
    mov filledblocks,0
    mov tempcount,0
    mov clean_x,3
    mov clean_y,3
    mov spaceship_outer_loop,20
    mov spaceship_inner_loop,35
    mov cx,spaceship_outer_loop
    middle34___:

    mov spaceship_outer_loop,cx
    mov cx,spaceship_inner_loop

    middle_nested34___:

    mov loopcount,cx

    ;code to check a block ch,dh,y dl,cl,x
    mov bl,8
    mov ax,clean_x
    mul bl
    mov cx,ax
    inc cx
    mov ax,clean_y
    mul bl
    mov dx,ax
    mov ah,0Dh
    int 10h
    cmp al,42h
    jne gs
    inc tempcount
    inc filledblocks
    cmp filledblocks,330
    jne gs_1
    mov gameend,1
    mov win,1
    gs_1:
    cmp tempcount,20
    jne gs
    mov tempcount,0
    inc Score
    gs:

    inc clean_x
    mov cx,loopcount
    loop middle_nested34___

    mov clean_x,3
    mov cx,spaceship_outer_loop
    inc clean_y
    loop middle34___

    mov al,prevscore
    cmp Score,al
    ja newscore
    mov Score,al
    newscore:

    ret
gameendcon endp

displayscore proc

    mov ah,02h
    mov bh,0   ;set cursor to corner
    mov dh,24
    mov dl,1
    int 10h

    lea dx,scoremsg
    mov ah,09h
    int 21h


    mov al,Score
    mov ah,0
    mov bl,10
    div bl
    add ah,48
    add al,48
    mov scorestring,al
    mov byte ptr[scorestring+1],ah

    mov ah,02h
    mov bh,0   ;set cursor to corner
    mov dh,24
    mov dl,8
    int 10h

    mov ah,9	;first number
    mov al,scorestring
    mov bl,11
    mov cx,1
    int 10h
    mov ah,02h
    mov bh,0   ;set cursor to corner
    mov dh,24
    mov dl,9
    int 10h

    mov ah,9	;second number
    mov al,byte ptr [scorestring+1]
    mov bl,11
    mov cx,1
    int 10h



    ret 
displayscore endp



jamal proc

    call setarray
    mov bx,0

    mov spaceship_outer_loop,23
    mov spaceship_inner_loop,38
    mov cx,spaceship_outer_loop
    middle8___:

    mov spaceship_outer_loop,cx
    mov cx,spaceship_inner_loop

    middle_nested8___:

    mov loopcount,cx
    mov al,inmaparr[bx]
    cmp al,2
    je found2

    inc trackx
    mov cx,loopcount
    inc bx
    loop middle_nested8___
    mov cx,spaceship_outer_loop

    loop middle8___

    found2:

    call fillingalg
    call fillwitharray

    mov cx,874
    mov si,offset inmaparr
    clear_array:
    mov [si],0
    inc si
    loop clear_array

    call gameendcon
    ret
jamal endp


fillwitharray proc 
    mov trackx, 1
    mov tracky, 1
    mov si,offset inmaparr
    mov spaceship_outer_loop,23
    mov spaceship_inner_loop,38
    mov cx,spaceship_outer_loop
    middle6___:

    mov spaceship_outer_loop,cx
    mov cx,spaceship_inner_loop

    middle_nested6___:

    mov loopcount,cx
    mov al,[si]
    cmp al,0
    jne move__
    ;code to fill a block ch,dh,y dl,cl,x
    mov ah,06h
    mov al,0
    mov ch,tracky
    mov cl,trackx
    mov dh,tracky
    mov dl,trackx
    mov bh,42h
    int 10h

    move__:
    inc trackx
    mov cx,loopcount
    inc si
    loop middle_nested6___

    mov trackx,1
    mov cx,spaceship_outer_loop
    inc tracky
    loop middle6___
    ;ah=0fh

    ret
fillwitharray endp

fillingalg proc uses bx

    cmp inmaparr[bx],1
    jne cont
    ret
    cont:	
    mov inmaparr[bx],2
    sub bx,38
    cmp inmaparr[bx],0
    jne next1
    call fillingalg
    next1:
    add bx,38
    add bx,38
    cmp inmaparr[bx],0
    jne next2
    call fillingalg
    next2:
    sub bx,38
    add bx,1
    cmp inmaparr[bx],0
    jne next3
    call fillingalg
    next3:
    sub bx,1
    sub bx,1
    cmp inmaparr[bx],0
    jne next4
    call fillingalg
    next4:
    add bx,1

    ret
fillingalg endp


setarray proc

    mov clean_x,1
    mov clean_y,1
    mov si,offset inmaparr
    mov spaceship_outer_loop,23
    mov spaceship_inner_loop,38
    mov cx,spaceship_outer_loop
    middle9___:

    mov spaceship_outer_loop,cx
    mov cx,spaceship_inner_loop

    middle_nested9___:

    mov loopcount,cx

    ;code to check a block ch,dh,y dl,cl,x
    mov bl,8
    mov ax,clean_x
    mul bl
    mov cx,ax
    inc cx
    mov ax,clean_y
    mul bl
    mov dx,ax
    mov ah,0Dh


    int 10h
    cmp al,42h
    jne gh
    mov [si],1
    gh:
    cmp al,4
    jne gg
    mov [si],2
    gg:
    inc clean_x
    mov cx,loopcount
    inc si
    loop middle_nested9___

    mov clean_x,1
    mov cx,spaceship_outer_loop
    inc clean_y
    loop middle9___


    ret
setarray endp


drawintrail proc

    cmp spaceship_x,16
    jb dontdrawtrail
    cmp spaceship_y,16
    jb dontdrawtrail
    cmp spaceship_x,304
    ja dontdrawtrail
    cmp spaceship_y,184
    ja dontdrawtrail




    mov ax,spaceship_x
    mov clean_x,ax
    mov ax,spaceship_y
    mov clean_y,ax
    mov spaceship_outer_loop,8
    mov spaceship_inner_loop,8
    mov cx,spaceship_outer_loop
    middle6:

    mov spaceship_outer_loop,cx
    mov cx,spaceship_inner_loop

    middle_nested6:
    mov loopcount,cx
    mov ah,0Dh
    mov bh,0
    mov cx,clean_x
    mov dx,clean_y
    int 10h
    cmp al,42h
    jne notpink
    cmp outofborder,1
    jne notpink
    call drawpathtoborder
    mov outofborder,0
    ret
    notpink:


    inc clean_x
    mov cx,loopcount
    loop middle_nested6

    inc clean_y
    mov cx,clean_x
    sub cx,8
    mov clean_x,cx
    mov cx,spaceship_outer_loop
    loop middle6


    dontdrawtrail:
    ret
drawintrail endp


    
drawpathtoborder proc


    mov enemyshadow_x,16
    mov enemyshadow_y,16


    mov spaceship_outer_loop,168
    mov spaceship_inner_loop,288
    mov cx,spaceship_outer_loop
    middle4:

    mov spaceship_outer_loop,cx
    mov cx,spaceship_inner_loop

    middle_nested4:

    mov loopcount,cx

    mov ah,0Dh
    mov bh,0
    mov cx,enemyshadow_x
    mov dx,enemyshadow_y
    int 10h
    cmp al,44h
    jne notpath
    mov ah,0ch
    mov bh,0
    mov al,42h
    mov cx,enemyshadow_x
    mov dx,enemyshadow_y
    int 10h

    notpath:

    inc enemyshadow_x
    mov cx,loopcount
    loop middle_nested4

    inc enemyshadow_y
    mov cx,enemyshadow_x
    sub cx,288
    mov enemyshadow_x,cx
    mov cx,spaceship_outer_loop
    loop middle4

    call jamal
    ret
drawpathtoborder endp


cleartrail proc

    mov enemyshadow_x,16
    mov enemyshadow_y,16


    mov spaceship_outer_loop,168
    mov spaceship_inner_loop,288
    mov cx,spaceship_outer_loop
    middle4_:

    mov spaceship_outer_loop,cx
    mov cx,spaceship_inner_loop

    middle_nested4_:

    mov loopcount,cx

    mov ah,0Dh
    mov bh,0
    mov cx,enemyshadow_x
    mov dx,enemyshadow_y
    int 10h
    cmp al,44h
    jne notpath_
    mov ah,0ch
    mov bh,0
    mov al,43h
    mov cx,enemyshadow_x
    mov dx,enemyshadow_y
    int 10h

    notpath_:

    inc enemyshadow_x
    mov cx,loopcount
    loop middle_nested4_

    inc enemyshadow_y
    mov cx,enemyshadow_x
    sub cx,288
    mov enemyshadow_x,cx
    mov cx,spaceship_outer_loop
    loop middle4_

    ret
cleartrail endp



collisioncheck proc
    mov ax,spaceship_x
    mov bx,enemy_x
    sub ax,bx
    cmp ax,0
    jg pos
    neg ax
    pos:
    cmp ax,8
    jae nocollision1

    mov ax,spaceship_y
    mov bx,enemy_y
    sub ax,bx
    cmp ax,0
    jg pos1
    neg ax

    pos1:
    cmp ax,8
    jae nocollision1

    call cleanspaceship
    mov spaceship_x,8
    mov spaceship_y,8
    call cleartrail
    dec lives
    cmp lives,0
    jne nocollision1

    mov gameend,1
    ret
    nocollision1:





    ret
collisioncheck endp

enemyshadow proc

    mov ax,enemy_x
    mov enemyshadow_x,ax
    mov ax,enemy_y
    mov enemyshadow_y,ax
    mov spaceship_outer_loop,8
    mov spaceship_inner_loop,8
    mov cx,spaceship_outer_loop
    middle3:

    mov spaceship_outer_loop,cx
    mov cx,spaceship_inner_loop

    middle_nested3:
    mov loopcount,cx
    mov ah,0ch
    mov bh,0
    mov al,43h
    mov cx,enemyshadow_x
    mov dx,enemyshadow_y
    int 10h
    inc enemyshadow_x
    mov cx,loopcount
    loop middle_nested3

    inc enemyshadow_y
    mov cx,enemyshadow_x
    sub cx,8
    mov enemyshadow_x,cx
    mov cx,spaceship_outer_loop
    loop middle3


    ret 
enemyshadow endp




enemymovement proc
    call collisioncheck
    mov al,enemylag
    cmp enemylagcount,al
    jne nolag
    mov enemylagcount,0



    call enemyshadow
    cmp enemy_l,0
    jne notl

    mov ah,0Dh
    mov bh,0
    mov cx,enemy_x
    add cx,9
    mov dx,enemy_y
    int 10h
    cmp al,44h
    jne jumpq

    call cleanspaceship
    call cleartrail

    dec lives
    mov spaceship_x,8
    mov spaceship_y,8
    cmp lives,0
    jne jumpq

    mov gameend,1
    ret
    jumpq:


    mov ah,0Dh
    mov bh,0
    mov cx,enemy_x
    add cx,9
    mov dx,enemy_y
    int 10h
    cmp al,42h
    jne jumpjj
    mov enemy_l,1
    ret
    jumpjj:
    inc enemy_x
    call collisioncheck
    notl:
    cmp enemy_l,1
    jne notr

    mov ah,0Dh
    mov bh,0
    mov cx,enemy_x
    dec cx
    mov dx,enemy_y
    int 10h
    cmp al,44h
    jne jumpw

    call cleanspaceship
    call cleartrail
    dec lives
    mov spaceship_x,8
    mov spaceship_y,8
    cmp lives,0
    jne jumpw
    mov gameend,1
    ret
    jumpw:


    mov ah,0Dh
    mov bh,0
    mov cx,enemy_x
    dec cx
    mov dx,enemy_y
    int 10h
    cmp al,42h
    jne jumpj
    mov enemy_l,0
    ret
    jumpj:

    dec enemy_x
    call collisioncheck
    notr:
    cmp enemy_v,0
    jne notu


    mov ah,0Dh
    mov bh,0
    mov cx,enemy_x
    mov dx,enemy_y
    add dx,9
    int 10h
    cmp al,44h
    jne jumpe
    call cleanspaceship
    call cleartrail
    dec lives
    mov spaceship_x,8
    mov spaceship_y,8
    cmp lives,0
    jne jumpe
    mov gameend,1
    ret
    jumpe:


    mov ah,0Dh
    mov bh,0
    mov cx,enemy_x
    mov dx,enemy_y
    add dx,9
    int 10h
    cmp al,42h
    jne jumpjo
    mov enemy_v,1
    ret
    jumpjo:
    inc enemy_y
    call collisioncheck
    notu:
    cmp enemy_v,1
    jne notd

    mov ah,0Dh
    mov bh,0
    mov cx,enemy_x
    mov dx,enemy_y
    dec dx
    int 10h
    cmp al,44h
    jne jumpr
    call cleanspaceship
    call cleartrail
    dec lives
    mov spaceship_x,8
    mov spaceship_y,8
    cmp lives,0
    jne jumpr
    mov gameend,1
    ret
    jumpr:

    mov ah,0Dh
    mov bh,0
    mov cx,enemy_x
    mov dx,enemy_y
    dec dx
    int 10h
    cmp al,42h
    jne jumpju
    mov enemy_v,0
    ret
    jumpju:

    dec enemy_y
    call collisioncheck
    notd:

    

    nolag:
    inc enemylagcount

    

    ret
enemymovement endp

cleanspaceship proc


    cmp spaceshiptoggle2,255
    jne overhh
    mov spaceshiptoggle2,0
    overhh:
    inc spaceshiptoggle2
    mov ah,0
    mov al,spaceshiptoggle2
    mov bl,2
    div bl
    mov spaceshiptoggle,ah
    mov ax,spaceship_x
    mov clean_x,ax
    mov ax,spaceship_y
    mov clean_y,ax


    ;middle box pixels

    mov spaceship_outer_loop,8
    mov spaceship_inner_loop,8
    mov cx,spaceship_outer_loop
    middle2:

    mov spaceship_outer_loop,cx
    mov cx,spaceship_inner_loop

    middle_nested2:
    mov loopcount,cx

    mov ah,0ch
    mov al,44h
    cmp outofborder,0
    jne notyellow
    mov al,42h
    notyellow:


    mov bh,0
    mov cx,clean_x
    mov dx,clean_y
    int 10h


    inc clean_x
    mov cx,loopcount
    loop middle_nested2

    inc clean_y
    mov cx,clean_x
    sub cx,8
    mov clean_x,cx
    mov cx,spaceship_outer_loop
    loop middle2



    ret 
cleanspaceship endp


enemydraw proc
    call collisioncheck
    mov spaceship_outer_loop,8
    mov spaceship_inner_loop,8
    mov cx,spaceship_outer_loop
    middle1:

    mov spaceship_outer_loop,cx
    mov cx,spaceship_inner_loop

    middle_nested1:
    mov loopcount,cx
    mov ah,0ch
    mov bh,0
    mov al,4
    mov cx,enemy_x
    mov dx,enemy_y
    int 10h
    inc enemy_x
    mov cx,loopcount
    loop middle_nested1

    inc enemy_y
    mov cx,enemy_x
    sub cx,8
    mov enemy_x,cx
    mov cx,spaceship_outer_loop
    loop middle1


    sub enemy_y,8


    ret
enemydraw endp


help_inst proc

    back_loop:

    call background

    mov ah,02h
    mov bh,0
    mov dh,5
    mov dl,1
    int 10h

    lea dx,inst_1
    mov ah,09h
    int 21h

    mov ah,02h
    mov bh,0
    mov dh,8
    mov dl,1
    int 10h

    lea dx,inst_2
    mov ah,09h
    int 21h

    mov ah,02h
    mov bh,0
    mov dh,11
    mov dl,1
    int 10h

    lea dx,inst_3
    mov ah,09h
    int 21h

    mov ah,02h
    mov bh,0
    mov dh,12
    mov dl,1
    int 10h

    lea dx,inst_3_1
    mov ah,09h
    int 21h

    mov ah,02h
    mov bh,0
    mov dh,14
    mov dl,1
    int 10h

    lea dx,inst_4
    mov ah,09h
    int 21h

    mov ah,02h
    mov bh,0
    mov dh,15
    mov dl,1
    int 10h

    lea dx,inst_4_1
    mov ah,09h
    int 21h

    mov ah,02h
    mov bh,0
    mov dh,18
    mov dl,1
    int 10h

    lea dx,inst_5
    mov ah,09h
    int 21h

    mov ah,02h
    mov bh,0
    mov dh,0
    mov dl,0
    int 10h

    mov ah,01h
    int 21h
    cmp al,98
    je back_loop_over
    cmp al,66
    je back_loop_over
    jmp back_loop

    back_loop_over:
    call mainmenu

    mov ah,02h
    mov bh,0
    mov dh,0
    mov dl,0
    int 10h

    ret
help_inst endp


WriteFile proc
    MOV AH, 3CH ; open file function
    LEA DX, FNAME ; DX has filename address
    mov Cl, 1 ; read-only attribute
    INT 21H ; open file
    MOV fHANDLE, AX ; save handle or error code

    MOV BX, ax
    LEA DX, nameuser
    MOV CX, LENGTHOF nameuser -1
    MOV AH, 40h
    INT 21H

    ; MOV BX, ax
    LEA DX, endl
    MOV CX, 2
    MOV AH, 40h
    INT 21H

    LEA DX, scorestring
    MOV CX, LENGTHOF scorestring-1
    MOV AH, 40h
    INT 21H

    LEA DX, endl
    MOV CX, 2
    MOV AH, 40h
    INT 21H

    LEA DX, nameuser
    MOV CX, LENGTHOF nameuser-1
    MOV AH, 40h
    INT 21H

    LEA DX, endl
    MOV CX, 2
    MOV AH, 40h
    INT 21H

    LEA DX, scorestring
    MOV CX, LENGTHOF scorestring-1
    MOV AH, 40h
    INT 21H

    LEA DX, endl
    MOV CX, 2
    MOV AH, 40h
    INT 21H

    LEA DX, nameuser
    MOV CX, LENGTHOF nameuser-1
    MOV AH, 40h
    INT 21H

    LEA DX, endl
    MOV CX, 2
    MOV AH, 40h
    INT 21H

    LEA DX, scorestring
    MOV CX, LENGTHOF scorestring-1
    MOV AH, 40h
    INT 21H

    ;Closing File
    mov ah, 3eh
    mov bx, fhandle
    int 21h

    ret
WriteFile endp

    ;LevelEnd screen
LevelEnd PROC
    mov gameend,0
    mov menuselection,1
    mov pointer_y,15
    mov pointer_x,11
    call displayscore
    levelendloop:
    call background
    

    cmp win,0
    je Loses
    jne Winning

    Loses:
    mov ah,02h
    mov bh,0
    mov dh,6
    mov dl,9
    int 10h

    lea dx,Lose
    mov ah,09h
    int 21h
    jmp going

    Winning:
    mov ah,02h
    mov bh,0
    mov dh,6
    mov dl,7
    int 10h
    lea dx,Congrats
    mov ah,09h
    int 21h
    call WriteFile

    going:
    mov ah,02h
    mov bh,0
    mov dh,9
    mov dl,12
    int 10h
    
    mov ah,09h
    lea dx, YourScore
    int 21h


    mov ah,02h
    mov bh,0
    mov dh,9
    mov dl,25
    int 10h


    mov ah,02h
    mov bh,0   ;set cursor to corner
    mov dh,9
    mov dl,25
    int 10h

    mov ah,9	;first number
    mov al,scorestring
    mov bl,11
    mov cx,1
    int 10h
    mov ah,02h
    mov bh,0   ;set cursor to corner
    mov dh,9
    mov dl,26
    int 10h

    mov ah,9	;second number
    mov al,byte ptr [scorestring+1]
    mov bl,11
    mov cx,1
    int 10h

    mov ah,02h
    mov bh,0
    mov dh,12
    mov dl,12
    int 10h

    lea dx,Levelmsg
    mov ah,09h
    int 21h

    mov ah,02h
    mov bh,0
    mov dh,12
    mov dl,18
    int 10h

    mov dl, LevelNo
    add dl,48
    mov ah,02
    int 21h
    
    

    mov ah,02h  
    mov bh,0
    mov dh,12
    mov dl,22
    int 10h


    lea dx, Completed
    mov ah,09h
    int 21h

    mov ah,02h  
    mov bh,0
    mov dh,15
    mov dl,14
    int 10h


    lea dx, Next
    mov ah,09h
    int 21h

    mov ah,02h  
    mov bh,0
    mov dh,17
    mov dl,15
    int 10h


    lea dx, RMainMenu
    mov ah,09h
    int 21h

    mov ah,02h
    mov bh,0
    mov dh,pointer_y
    mov dl,pointer_x
    int 10h

    lea dx,pointer
    mov ah,09h
    int 21h

    mov ah,01
    int 21h
    cmp al,13d
    je exitlevelendloop
    cmp al,80
    jne up2
    cmp menuselection,2
    je up2
    inc menuselection
    up2:
    cmp al,72
    jne down2
    cmp menuselection,1
    je down2
    dec menuselection
    je down2
    down2:

    cmp menuselection,1
    jne notemenu1
    mov pointer_y,15
    mov pointer_x,11
    notemenu1:
    cmp menuselection,2
    jne notemenu2
    mov pointer_y,17
    mov pointer_x,12
    notemenu2:
    




    jmp levelendloop
    exitlevelendloop:
    
    cmp LevelNo,2
    jne notlevel2
    mov LevelNo,0
    notlevel2:
    cmp menuselection,1
    jne sover
    call level
    ret
    sover:
    cmp menuselection,2
    jne sover1
    call mainmenu
    ret
    sover1:


    ret
LevelEnd endp

LevelSelect PROC

    mov menuselection,1
    mov pointer_x,13
    mov pointer_y,7
    levelselectloop:
    call background
    mov ah,02h
    mov bh,0
    mov dh,7
    mov dl,16
    int 10h

    lea dx,LevelA
    mov ah,09h
    int 21h

    mov ah,02h
    mov bh,0
    mov dh,11
    mov dl,16
    int 10h

    lea dx,LevelB
    mov ah,09h
    int 21h

    mov ah,02h  
    mov bh,0
    mov dh,15   
    mov dl,15
    int 10h


    lea dx, RMainMenu
    mov ah,09h
    int 21h

    mov ah,02h  
    mov bh,0
    mov dh,pointer_y
    mov dl,pointer_x
    int 10h
    lea dx, pointer
    mov ah,09h
    int 21h


    mov ah,01
    int 21h
    cmp al,13d
    je exitlevelselect
    cmp al,80
    jne up1
    cmp menuselection,3
    je up1
    inc menuselection
    up1:
    cmp al,72
    jne down1
    cmp menuselection,1
    je down1
    dec menuselection
    je down1
    down1:

    cmp menuselection,1
    jne notmenu1
    mov pointer_y,7
    mov pointer_x,13
    notmenu1:
    cmp menuselection,2
    jne notmenu2
    mov pointer_y,11
    mov pointer_x,13
    notmenu2:
    cmp menuselection,3
    jne notmenu3
    mov pointer_y,15
    mov pointer_x,12
    notmenu3:




    jmp levelselectloop

    exitlevelselect:

    cmp menuselection,1
    jne lsover
    mov timer,61
    mov LevelNo,0
    mov enemylag,200
    call level
    ret
    lsover:
    cmp menuselection,2
    jne lsover1
    mov timer,41
    mov LevelNo,1
    mov enemylag,50
    call level 
    ret
    lsover1:
    cmp menuselection,3
    jne lsover2
    call mainmenu
    ret
    lsover2:



    ret
LevelSelect endp



High_Score proc
    Mov ah, 3dh ;for opening an existing file
    Mov al, 02h ;in read only mode
    Mov dx, offset fname
    int 21h
    mov fhandle, ax

    Mov ah, 3fh ;uses for reading a file
    Mov dx, offset buf
    Mov cx, 100
    Mov bx, fhandle
    int 21h


    ; Display Text
    mov ah, 09h
    mov [buf+8], "$"
    mov bx, offset buf
    mov name1, bx
    mov [buf+12], "$"
    mov bx, offset [buf+10]
    mov no1, bx
    mov [buf+22], "$"
    mov bx, offset [buf+14]
    mov name2, bx
    mov [buf+26], "$"
    mov bx, offset [buf+24]
    mov no2, bx
    mov [buf+36], "$"
    mov bx, offset [buf+28]
    mov name3, bx
    mov bx, offset [buf+38]
    mov no3, bx
    ; mov [buf+31], "$"
    ; lea bx, [buf+6]
    ; mov no, bl
    ; mov ah, 09h
    ; mov dx, no1
    ; int 21h


    ;Closing File
    mov ah, 3eh
    mov bx, fhandle
    int 21h

    loophighscore:

    call background
    ; .startup
    mov ah,02h
    mov bh,0
    mov dh,7
    mov dl,10
    int 10h

    lea dx,num1MSG
    mov ah,09h
    int 21h

    mov ah,02h
    mov bh,0
    mov dh,7
    mov dl,14
    int 10h

    lea dx,Dot
    mov ah,09h
    int 21h

    mov ah,02h
    mov bh,0
    mov dh,7
    mov dl,14
    int 10h

    ; File Read
    
    mov dx, name1
    mov ah,09h
    int 21h

    mov ah,02h
    mov bh,0
    mov dh,7
    mov dl,29
    int 10h

    ; File Read
    mov ah,09h
    mov dx, no1
    int 21h
    

    mov ah,02h
    mov bh,0
    mov dh,11
    mov dl,10
    int 10h

    lea dx,num2MSG
    mov ah,09h
    int 21h

    mov ah,02h
    mov bh,0
    mov dh,11
    mov dl,14
    int 10h

    lea dx,Dot
    mov ah,09h
    int 21h

    mov ah,02h
    mov bh,0
    mov dh,11
    mov dl,14
    int 10h

     ; File Se Read
    
    mov dx, name2
    mov ah, 09h
    int 21h

    mov ah,02h
    mov bh,0
    mov dh,11
    mov dl,29
    int 10h

     ; File Se Read
    
    mov dx, no2
    mov ah, 09h
    int 21h

    mov ah,02h
    mov bh,0
    mov dh,15
    mov dl,10
    int 10h

    lea dx,num3MSG
    mov ah,09h
    int 21h

    mov ah,02h
    mov bh,0
    mov dh,15
    mov dl,14
    int 10h

    ; File Se Read

    mov ah,02h
    mov bh,0
    mov dh,15
    mov dl,14
    int 10h

    lea dx,Dot
    mov ah,09h
    int 21h

    mov ah,02h
    mov bh,0
    mov dh,15
    mov dl,14
    int 10h

     ; File Se Read
    
    mov dx, name3
    mov ah, 09h
    int 21h

    mov ah,02h
    mov bh,0
    mov dh,15
    mov dl,29
    int 10h

     ; File Se Read
    
    mov dx, no3
    mov ah, 09h
    int 21h
    mov ah,02h  
    mov bh,0
    mov dh,19   
    mov dl,9
    int 10h


    lea dx, inst_5
    mov ah,09h
    int 21h


    mov ah,02h
    mov bh,0
    mov dh,0
    mov dl,0
    int 10h

    mov ah,01h
    int 21h
    cmp al,98
    je highscoreover
    cmp al,66
    je highscoreover
    jmp loophighscore

    highscoreover:
    call mainmenu





    ret
High_Score endp



pausegame PROC

    mov ah,02h   
    mov dh,0
    mov dl,17
    int 10h

    lea dx,pausemsg
    mov ah,09
    int 21h

    pauseloop:
    mov ah,0Bh  
    int 21h
    cmp al,0
    je pauseloop
    mov ah,02h   
    mov dh,0
    mov dl,0
    int 10h
    mov ah,01h
    int 21h
    cmp al,112
    
    mov ah,02h   
    mov dh,0
    mov dl,17
    int 10h
    lea dx,pausemsg
    mov ah,09
    int 21h
    jne pauseloop
    mov ah,06h
    mov al,0
    mov cx,17
    mov dh,0
    mov dl,22
    mov bh,41h
    int 10h
    mov pause,0
    mov ah,06h
    mov cx,0017h
    mov dh,00
    mov dl,22
    mov bh,0
    int 10h
    jmp game_loop

    ret
pausegame endp


input PROC

    ;larrrow ascii 75
    ;rarrow ascii 77
    ;uarrow ascii 72
    ;darrow ascii 80
    mov ah,02h
    mov dh,0
    mov dl,0
    int 10h

    mov ah,0Bh  
    int 21h

    cmp al,0
    je over5


 



    mov ah,01h
    int 21h
    
    cmp al,112
    jne notpause
    mov pause,1
    call pausegame
    notpause:
    cmp al,75
    jne notleft
    cmp spaceship_x,8
    jbe cantleft
    call cleanspaceship
    sub spaceship_x,8
    mov ah,0Dh
    mov cx,spaceship_x
    sub cx,2
    mov dx,spaceship_y
    add dx,4
    mov bh,0
    int 10h
    cmp al,43h      
    jne cantleft
    mov outofborder,1
    mov inborder,0
    cantleft:
    notleft:
    cmp al,77
    jne notright
    cmp spaceship_x,304
    jae cantright
    call cleanspaceship
    add spaceship_x,8

    mov ah,0Dh
    mov cx,spaceship_x
    add cx,8
    mov dx,spaceship_y
    mov bh,0
    int 10h
    cmp al,43h
    jne cantright
    mov outofborder,1
    mov inborder,0
    cantright:
    notright:
    cmp al,72
    jne notup
    cmp spaceship_y,8
    jbe cantup
    call cleanspaceship
    sub spaceship_y,8

    mov ah,0Dh
    mov cx,spaceship_x
    add cx,4
    mov dx,spaceship_y
    mov bh,0
    int 10h
    cmp al,43h      
    jne cantup
    mov outofborder,1
    mov inborder,0
    cantup:
    notup:
    cmp al,80
    jne notdown
    cmp spaceship_y,184
    jae cantdown
    call cleanspaceship
    add spaceship_y,8
    mov ah,0Dh
    mov cx,spaceship_x
    add cx,4
    mov dx,spaceship_y
    add dx,8
    mov bh,0
    int 10h
    cmp al,43h      
    jne cantdown
    mov outofborder,1
    mov inborder,0
    cantdown:
    notdown:

    cmp outofborder,0
    je notatborder





    cmp spaceship_x,8
    je atborder
    cmp spaceship_x,304
    je atborder
    cmp spaceship_y,8
    je atborder
    cmp spaceship_y,184
    je atborder
    jmp notatborder
    atborder:
    call drawpathtoborder

    mov outofborder,0
    mov inborder,1
    notatborder:
    mov inputnum,al
    over5:

    call drawintrail

    ret 
input endp



timeupdate PROC
    mov ah,2ch
    int 21h
    cmp dh,prevtime
    je over2
    dec timer
    mov prevtime,dh
    mov bx,offset timerstring
    mov al,timer
    mov ah,0
    cmp al,10
    
    mov bl,10
    div bl
    add ah,48
    add al,48
    mov timerstring,al
    mov byte ptr[timerstring+1],ah

    mov ah,02h
    mov bh,0   ;set cursor to corner
    mov dh,0
    mov dl,37
    int 10h

    mov ah,9	;first number
    mov al,timerstring
    mov bl,11
    mov cx,1

    int 10h	;move cursor one position to right
    mov ah,02h
    mov dl,38
    int 10h

    mov ah,9	;second number
    mov al,byte ptr [timerstring+1]
    mov bl,11
    mov cx,1
    int 10h

    

    over2:

    cmp timer,0
    jne over8

    mov gameend,1
    over8:
    ret
timeupdate endp


;for map logic

map PROC
    mov bl,0
    mov cx,225
    mov si,offset arr
    mov ax,0000
    l1:
    mov dx,[si]
    add dx,48
    mov ah,02h
    int 21h
    inc si
    inc bl
    cmp bl,15
    je nl
    jmp ex
    nl:
    mov dl,10
    mov ah,02h
    int 21h
    mov bl,0
    ex:
    loop l1

    ret
map endP


;drawing game map and spaceship at its place

game_map PROC
    mov ah,06h
    mov al,0
    mov cx,0101h
    mov dh,23
    mov dl,38
    mov bh,42h
    int 10h
    mov ah,06h
    mov al,0
    mov cx,0202h
    mov dh,22
    mov dl,37
    mov bh,43h
    int 10h

    ret
game_map endp



    ;spaceship pixel design

spaceship proc


    call collisioncheck

    ;left diagonal pixels
    mov cx,8
    left_diag:
    mov loopcount,cx
    mov cx,spaceship_x
    mov dx,spaceship_y
    mov ah,0ch
    mov bh,0
    cmp LevelNo,0
    jne notl1
    mov al,0
    jmp notgreen
    notl1:
    mov al,5
    cmp spaceshiptoggle,0
    je notgreen
    mov al,1011b
    notgreen:
    int 10h
    inc spaceship_x
    inc spaceship_y
    mov cx,loopcount
    loop left_diag

    ;setting spaceships coordinates

    mov ax,spaceship_y
    sub ax,8
    mov spaceship_y,ax
    dec spaceship_x


    ;right diagonal pixels

    mov cx,8
    right_diag:
    mov loopcount,cx
    mov cx,spaceship_x
    mov dx,spaceship_y
    mov ah,0ch
    mov bh,0
    cmp LevelNo,0
    jne notl2
    mov al,0
    jmp notgreen1
    notl2:
    mov al,5
    cmp spaceshiptoggle,0
    je notgreen1
    mov al,1011b
    notgreen1:
    int 10h
    dec spaceship_x
    inc spaceship_y
    mov cx,loopcount
    loop right_diag

    ;setting spaceship coordinates

    mov ax,spaceship_x
    add ax,3
    mov spaceship_x,ax
    mov ax,spaceship_y
    sub ax,6
    mov spaceship_y,ax

    ;middle box pixels

    mov spaceship_outer_loop,4
    mov spaceship_inner_loop,4
    mov cx,spaceship_outer_loop
    middle:

    mov spaceship_outer_loop,cx
    mov cx,spaceship_inner_loop

    middle_nested:
    mov loopcount,cx
    mov ah,0ch
    mov bh,0
    mov al,0111b
    mov cx,spaceship_x
    mov dx,spaceship_y
    int 10h
    inc spaceship_x
    mov cx,loopcount
    loop middle_nested

    inc spaceship_y
    mov cx,spaceship_x
    sub cx,4
    mov spaceship_x,cx
    mov cx,spaceship_outer_loop
    loop middle

    sub spaceship_x,2
    sub spaceship_y,6



    ret
spaceship endp

displaylives proc

    mov ah,02h
    mov bh,0
    mov dh,24
    mov dl,30
    int 10h
    lea dx,lives_count
    mov ah,09h
    int 21h

    mov ah,02h
    mov bh,0
    mov dh,24
    mov dl,38
    int 10h


    mov ah,9	;first number
    mov al,lives
    add al,48
    mov bl,11
    mov cx,1
    int 10h



    ret
displaylives endp


level proc
    
    mov win, 0
    mov spaceship_x,8
    mov spaceship_y,8
    mov filledblocks,0
    mov Score,0
    mov gameend,0
    mov enemylag,200
    mov timer,61
    cmp LevelNo,1
    jne ny1
    mov enemylag,50
    mov timer,41
    ny1:
    
    call background
    mov lives,3
    call game_map

    game_loop:
    cmp gameend,1
    je game_over
    call displaylives
    call displayscore

    call enemymovement
    call spaceship
    call enemydraw
    call timeupdate
    call input

    jmp game_loop

    game_over:
    inc LevelNo

    call LevelEnd

    ret
level endp

startscr proc

 

    call background

    mov ah,02h
    mov bh,0
    mov dh,8
    mov dl,10
    int 10h

    lea dx,AIRXONIX
    mov ah,09h
    int 21h

    mov bh,0
    mov ah,02h   
    mov dh,20
    mov dl,11
    int 10h

    lea dx,nameentermsg
    mov ah,09h
    int 21h

    mov si,offset nameuser
    startscreenloop:
    mov ah,0Bh  
    int 21h
    cmp al,0
    je startscreenloop
    mov ah,02h   
    mov dh,0
    mov dl,0
    int 10h
    mov ah,01h
    int 21h


    cmp al,13d
    je startscreenend
    cmp al,8
    jne fwd
    cmp si,offset nameuser
    je startscreenloop
    cmp [si],'$'
    jne over10
    dec si

    over10:
    dec si
    mov [si]," "
    jmp fwd_1
    fwd:
    cmp [si],'$'
    je fwd_1
    mov [si],al
    inc si
    fwd_1:

    mov ah,02h   
    mov dh,21
    mov dl,15
    int 10h

    lea dx,nameuser
    mov ah,09h
    int 21h



    jmp startscreenloop


    startscreenend:

    mov ah,02h   
    mov dh,0
    mov dl,0
    int 10h

    ret 
startscr endp

background proc
    ;background
    mov ah,06h
    mov al,0
    mov cx,0
    mov dh,25
    mov dl,39
    mov bh,0
    int 10h
    ;background-end

    ret
background endp

;mainmenu screen
mainmenu PROC

    mov menuselection,1
    mov pointer_y,5
    mov pointer_x,11
    mainmenuloop:
    call background

    mov ah,02h
    mov bh,0
    mov dh,2
    mov dl,10
    int 10h

    lea dx,AIRXONIX
    mov ah,09h
    int 21h

    mov ah,02h
    mov bh,0
    mov dh,5
    mov dl,14
    int 10h

    lea dx,startgame
    mov ah,09h
    int 21h

    mov ah,02h
    mov bh,0
    mov dh,8
    mov dl,13
    int 10h

    lea dx,selectlevel
    mov ah,09h
    int 21h

    mov ah,02h
    mov bh,0
    mov dh,11
    mov dl,14
    int 10h

    lea dx,highscores
    mov ah,09h
    int 21h

    mov ah,02h
    mov bh,0
    mov dh,14
    mov dl,17
    int 10h

    lea dx,help
    mov ah,09h
    int 21h

    mov ah,02h
    mov bh,0
    mov dh,17
    mov dl,17
    int 10h

    lea dx,exit
    mov ah,09h
    int 21h


    mov ah,02h
    mov bh,0
    mov dh,pointer_y
    mov dl,pointer_x
    int 10h

    lea dx,pointer
    mov ah,09h
    int 21h

    ;pointer_printing


    
    mov ah,01
    int 21h

    cmp al,13d
    je exit_arrowprinting
    cmp al,80
    jne up
    cmp menuselection,5
    je up
    inc menuselection
    up:
    cmp al,72
    jne down
    cmp menuselection,1
    je down
    dec menuselection
    je down
    down:

    mov al,menuselection 
    cmp al,1
    jne forward_0
    mov pointer_x,11
    mov pointer_y,5
    

    forward_0:
    cmp al,2
    jne forward_1
    
    mov pointer_x,10
    mov pointer_y,8
    

    forward_1:
    cmp al,3
    jne forward_2
    
    mov pointer_x,11
    mov pointer_y,11
    

    forward_2:
    cmp al,4
    jne forward_3
    
    mov pointer_x,14
    mov pointer_y,14
    
    

    forward_3:
    cmp al,5
    jne forward_4
    
    mov pointer_x,14
    mov pointer_y,17
    
    
    forward_4:


    jmp mainmenuloop
    exit_arrowprinting:

    cmp menuselection,1
    jne not1
    call level

    not1:
    cmp menuselection,2
    jne not2
    call LeveLSelect

    not2:
    cmp menuselection,3
    jne not3
    call High_Score

    not3:
    cmp menuselection,4
    jne not4
    call help_inst

    not4:
    cmp menuselection,5
    jne not5
    jmp programend
    not5:


    ret
mainmenu endp


;main func
main proc
    mov ax, @data
    mov ds, ax

    mov ah,00
    mov al,13h
    int 10h

    call startscr
    call mainmenu

    programend:

    call background
    mov ah,02h
    mov dh,12
    mov dl,10
    mov bh,0
    int 10h



    lea dx,gameendmsg
    mov ah,09h
    int 21h


    mov ah,4ch
    int 21h
main endp
end main