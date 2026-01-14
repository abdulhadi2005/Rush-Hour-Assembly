INCLUDE Irvine32.inc
Beep PROTO, dwFreq:DWORD, dwDuration:DWORD
.data
    rows BYTE 20
    cols BYTE 20
    board \
        DB 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
        DB 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
        DB 0, 0, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0
        DB 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
        DB 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0
        DB 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0
        DB 0, 0, 1, 1, 0, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 1, 0
        DB 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0
        DB 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0
        DB 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0
        DB 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
        DB 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
        DB 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0
        DB 0, 0, 1, 1, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 1, 1, 1, 1, 1, 0
        DB 0, 0, 1, 1, 0, 1, 0, 1, 1, 1, 1, 1, 0, 0, 1, 0, 0, 0, 0, 0
        DB 0, 0, 1, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0
        DB 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0
        DB 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
        DB 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0
        DB 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0

    ; Variables for getValue and setValue
    row BYTE ?
    col BYTE ?
    value BYTE ?

    ; Constants for board values
    road BYTE 0
    building BYTE 1
    player BYTE 2
    passenger BYTE 3
    destination BYTE 4

    ; Strings to display board
    playerStr BYTE "C ", 0
    passengerStr BYTE "P ", 0
    roadStr BYTE "  ", 0
    buildingStr BYTE "[]", 0
    destinationStr BYTE "D ", 0
    boundaryStr BYTE "##", 0
    invalidStr BYTE "  ", 0

    ; Color codes (background foreground)
    defaultColor BYTE 00Fh         ; black white
    buildingColor BYTE 08Fh        ; dark grey white
    roadColor BYTE 0F0h            ; white black
    playerColor BYTE ?             ; Will be set to Red (04Fh) or Yellow (0EFh)
    passengerColor BYTE 06Fh       ; brown white
    destinationColor BYTE 02Fh     ; green white
    boundaryColor BYTE 00Ah        ; black light green
    invalidColor BYTE 04Fh         ; red white

    ; Player coordinates
    playerX BYTE 1
    playerY BYTE 4

    isPassengerPicked BYTE 0 ; bool variable ha check karne ke liye
    lookFor BYTE ?           ; ye passenger ya destination check karne ke liye

    score DWORD 0
    droppedPassengerScore DWORD 10
    
    obstaclePenalty    DWORD -2    ; Default penalty for hitting building
    carPenalty         DWORD -3
    
    scoreStr BYTE "Score: ", 0

    ; MENU STRINGS
    strMenuTitle    BYTE "========== RUSH HOUR TAXI ==========", 0
    strOpt1         BYTE "1. Start New Game", 0
    strOpt2         BYTE "2. Difficulty / Taxi Select", 0
    strOpt3         BYTE "3. Instructions", 0
    strOpt4         BYTE "4. Leaderboard", 0
    strOpt5         BYTE "5. Exit", 0
    strChoice       BYTE "Enter choice: ", 0

    strPaused        BYTE "GAME PAUSED - Press 'p' to Resume", 0
    
    ; INSTRUCTION STRINGS
    strInstTitle    BYTE "--- INSTRUCTIONS ---", 0
    strInst1        BYTE "1. Use Arrow Keys to move.", 0
    strInst2        BYTE "2. Press SPACE to Pick/Drop passengers.", 0
    strInst3        BYTE "3. Green D is destination.", 0
    strInst4        BYTE "4. Avoid Obstacles and Cars", 0
    strAnyKey       BYTE "Press any key to go back", 0

    ; DIFFICULTY STRINGS
    strDiffTitle    BYTE "--- SELECT DIFFICULTY / TAXI ---", 0
    strDiff1        BYTE "1. Yellow Taxi (Easy - Faster Speed)", 0
    strDiff2        BYTE "2. Red Taxi    (Hard - Slower Speed)", 0
    strSelected     BYTE "Selected Taxi: ", 0
    strYellow       BYTE "Yellow", 0
    strRed          BYTE "Red", 0

    ; LEADERBOARD
    strLeadTitle    BYTE "--- LEADERBOARD ---", 0
    strNoScores     BYTE "No high scores yet.", 0

    ; Variable for Menu and Taxi Settings
    currentDifficulty BYTE 1 ; 1 Yellow ke liye and 2 Red ke liye
    
    ; Menu Strings
    strDiffRand       BYTE "3. Random Assignment", 0
    strSelectedMode   BYTE "Mode Active: ", 0

    ; PLAYER NAME VARIABLES
    strEnterName      BYTE "Enter your name: ", 0
    playerName        BYTE 21 DUP(0)  ; max 20  characters ka name
    nameLength        DWORD ?         ; input name ki length

    ; GAME MODE VARIABLES
    selectedMode       BYTE 1       ; 1 for Career, 2 for Time and 3 for Endless
    timeLimit          DWORD 60000  ; 60 Seconds time or ye milliseconds me ha
    startTime          DWORD ?
    timeRemaining      DWORD ?
    passengersDelivered DWORD 0
    
    strModeTitle       BYTE "--- SELECT GAME MODE ---", 0
    strMode1           BYTE "1. Career (Deliver 5 Passengers)", 0
    strMode2           BYTE "2. Time Attack (60 Seconds)", 0
    strMode3           BYTE "3. Endless", 0
    
    strWin             BYTE "YOU WON. Career Goal Reached", 0
    strLose            BYTE "GAME OVER. Time is Up", 0
    strTimeLabel       BYTE " Time: ", 0
    strCountLabel      BYTE " Delivered: ", 0
    strSlash           BYTE "/5", 0

.code
getValue PROC     
    movzx eax, row     ; index = row * rows + col  ye formula ha correct index nikalne ka
    movzx ebx, cols
    imul eax, ebx              
    movzx ebx, col
    add eax, ebx                 

    mov esi, OFFSET board
    movzx eax, BYTE PTR [esi + eax]

    mov value, al                
    ret
getValue ENDP

setValue PROC
    movzx eax, row    ; index = row * rows + col  same above wala formula ha correct index nikalne ka
    movzx ebx, cols
    imul eax, ebx                 
    movzx ebx, col
    add eax, ebx                  

    movzx ebx, value
    mov esi, OFFSET board
    mov [esi + eax], bl
    ret
setValue ENDP

displayValue PROC
    mov ebx, edx
    movzx eax, value

    ; har index ki value ko check kare or chez banaye ge
    cmp al, road
    je  PrintRoad

    cmp al, building
    je  PrintBuilding

    cmp al, player
    je  PrintPlayer

    cmp al, passenger
    je  PrintPassenger

    cmp al, destination
    je  PrintDestination

    ; If no match was found
    movzx eax, invalidColor
    call SetTextColor
    mov edx, OFFSET invalidStr
    call WriteString
    jmp  Done

    PrintRoad:
        movzx eax, roadColor
        call SetTextColor
        mov edx, OFFSET roadStr
        call WriteString
        jmp  Done

    PrintBuilding:
        movzx eax, buildingColor
        call SetTextColor
        mov edx, OFFSET buildingStr
        call WriteString
        jmp  Done

    PrintPlayer:
        movzx eax, playerColor
        call SetTextColor
        mov edx, OFFSET playerStr
        call WriteString
        jmp  Done

    PrintPassenger:
        movzx eax, passengerColor
        call SetTextColor
        mov edx, OFFSET passengerStr
        call WriteString
        jmp  Done

    PrintDestination:
        movzx eax, destinationColor
        call SetTextColor
        mov edx, OFFSET destinationStr
        call WriteString

    Done:
        mov edx, ebx        
    ret
displayValue ENDP

displayBoard PROC
    ; top boundary
    movzx ecx, cols
    add ecx, 2
    TopBoundaryLoop:
        movzx eax, boundaryColor
        call SetTextColor
        mov edx, OFFSET boundaryStr
        call WriteString
        loop TopBoundaryLoop
    call Crlf

    movzx ecx, rows

    RowLoop:
        mov edx, ecx                    
        movzx  ecx, cols                

        ; left boundary
        movzx eax, boundaryColor
        call SetTextColor
        mov ebx, edx                    
        mov edx, OFFSET boundaryStr
        call WriteString
        mov edx, ebx                    

        ColLoop:
            ; Calculating row and column indices by subtracting from 4.
            movzx ebx, rows
            sub ebx, edx
            mov row, bl

            movzx ebx, cols
            sub ebx, ecx
            mov col, bl

            call getValue
            call displayValue
            
            loop ColLoop

        ; right boundary
        movzx eax, boundaryColor
        call SetTextColor
        mov ebx, edx                    
        mov edx, OFFSET boundaryStr
        call WriteString
        mov edx, ebx                    

        call Crlf                   
        mov ecx, edx
        loop RowLoop

    ; bottom boundary
    movzx ecx, cols
    add ecx, 2
    BottomBoundaryLoop:
        movzx eax, boundaryColor
        call SetTextColor
        mov edx, OFFSET boundaryStr
        call WriteString
        loop BottomBoundaryLoop
    call Crlf

    ; reset to default color
    movzx eax, defaultColor
    call SetTextColor

    ret
displayBoard ENDP

moveUp PROC
    ; Check upper boundary
    cmp playerY, 0
    je CannotMoveUp          

    ; Check the cell above like row = playerY - 1, col = playerX
    mov al, playerY
    dec al                   
    mov row, al
    mov al, playerX
    mov col, al
    call getValue

    mov al, value
    cmp al, road           
    jne CannotMoveUp

    inc row
    mov al, road
    mov value, al
    call setValue

    dec playerY
    call setPlayerOnBoard
    ret

    CannotMoveUp:
        cmp al, building
        jne NoBuildingAbove

        ; building hit hoge to score decrease ho ga
        mov eax, score
        add eax, obstaclePenalty 
        mov score, eax
        call PlayClickSound

    NoBuildingAbove:
    ret
moveUp ENDP

moveDown PROC
    ; Check lower boundary
    mov al, rows
    dec al
    cmp playerY, al
    je CannotMoveDown      

    ; Check the cell below like row = playerY + 1, col = playerX
    mov al, playerY
    inc al
    mov row, al
    mov al, playerX
    mov col, al
    call getValue

    mov al, value
    cmp al, road        
    jne CannotMoveDown

    dec row
    mov al, road
    mov value, al
    call setValue

    inc playerY
    call setPlayerOnBoard

    CannotMoveDown:
        cmp al, building
        jne NoBuildingBelow

        ; building hit hoge to score decrease ho ga
        mov eax, score
        add eax, obstaclePenalty
        mov score, eax
        call PlayClickSound

    NoBuildingBelow:
    ret
moveDown ENDP

moveLeft PROC
    ; Check lower boundary
    cmp playerX, 0
    je CannotMoveLeft     

    ; Check the left cell like row = playerY, col = playerX - 1
    mov al, playerY
    mov row, al
    mov al, playerX
    dec al
    mov col, al
    call getValue

    mov al, value
    cmp al, road          
    jne CannotMoveLeft

    inc col
    mov al, road
    mov value, al
    call setValue

    dec playerX
    call setPlayerOnBoard

    CannotMoveLeft:
        cmp al, building
        jne NoBuildingLeft

        ; building hit hoge to score decrease ho ga
        mov eax, score
        add eax, obstaclePenalty
        mov score, eax
        call PlayClickSound

    NoBuildingLeft:
    ret
moveLeft ENDP

moveRight PROC
    ; Check lower boundary
    mov al, cols
    dec al
    cmp playerX, al
    je CannotMoveRight       

    ; Check the left cell like row = playerY, col = playerX + 1
    mov al, playerY
    mov row, al
    mov al, playerX
    inc al
    mov col, al
    call getValue

    mov al, value
    cmp al, road           
    jne CannotMoveRight

    dec col
    mov al, road
    mov value, al
    call setValue

    inc playerX
    call setPlayerOnBoard

    CannotMoveRight:
        cmp al, building
        jne NoBuildingRight

        ; building hit hoge to score decrease ho ga
        mov eax, score
        add eax, obstaclePenalty 
        mov score, eax
        call PlayClickSound

    NoBuildingRight:
    ret
moveRight ENDP

setPlayerOnBoard PROC
    mov al, playerY
    mov row, al
    mov al, playerX
    mov col, al
    mov al, player
    mov value, al
    call setValue
    ret
setPlayerOnBoard ENDP

pickOrDropPassenger PROC
    mov al, isPassengerPicked
    test al, al
    jz LookForPassenger
    
    ; passenger mil jaye to destination dhundho
    mov bl, destination
    jmp CheckDirections
    
    LookForPassenger:
        ; passenger dhundho
        mov bl, passenger
    
    CheckDirections:
        mov lookFor, bl

        ; Check UP
        mov al, playerY
        cmp al, 0
        je SkipUp
        dec al
        mov row, al
        mov al, playerX
        mov col, al
        call getValue
        mov bl, lookFor
        cmp value, bl
        je FoundIt

    SkipUp:
        ; Check DOWN
        mov al, playerY
        mov ah, rows
        dec ah
        cmp al, ah
        je SkipDown
        inc al
        mov row, al
        mov al, playerX
        mov col, al
        call getValue
        mov bl, lookFor
        cmp value, bl
        je FoundIt

    SkipDown:
        ; Check LEFT
        mov al, playerX
        cmp al, 0
        je SkipLeft
        mov al, playerY
        mov row, al
        mov al, playerX
        dec al
        mov col, al
        call getValue
        mov bl, lookFor
        cmp value, bl
        je FoundIt

    SkipLeft:
        ; Check RIGHT
        mov al, playerY
        mov row, al
        mov al, playerX
        mov ah, cols
        dec ah
        cmp al, ah
        je SkipRight
        inc al
        mov col, al
        call getValue
        mov bl, lookFor
        cmp value, bl
        je FoundIt

    SkipRight:
        ret  ; agar koi passenger ya destination nahi mila to return kardo
    
    FoundIt:
        cmp bl, passenger
        je FoundPassenger

        cmp bl, destination
        je FoundDestination

    FoundPassenger:
        mov al, road
        mov value, al
        call setValue
        call spawnDestination
        call PlayClickSound
        jmp ToggleFlag

    FoundDestination:
        mov al, road
        mov value, al
        call setValue
        
        mov eax, score
        add eax, droppedPassengerScore
        mov score, eax
        
        inc passengersDelivered
        call spawnPassenger
        call PlayClickSound
        jmp ToggleFlag

    ToggleFlag: ; ye passenger picked/drop flag ko toggle kare ga
        mov al, isPassengerPicked
        xor al, 1
        mov isPassengerPicked, al

    ret
pickOrDropPassenger ENDP

; Spawns passenger at random cell
spawnPassenger PROC
    TrySpawnAgain:
        movzx eax, rows
        call RandomRange
        mov row, al
        
        movzx eax, cols
        call RandomRange
        mov col, al
        
        call getValue
        cmp value, 0 
        jne TrySpawnAgain ; agar road nahi ha to fir se try karo road ke liye
        
        mov al, passenger
        mov value, al
        call setValue
    ret
spawnPassenger ENDP

; Spawns a destination at a random cell
spawnDestination PROC
    mov eax, 2
    call RandomRange
    cmp eax, 0
    jne SpawnDestinationInLastColumn

    movzx eax, cols
    call RandomRange

    mov col, al
    mov al, rows
    dec al
    mov row, al
    jmp SetDestinationValue

    SpawnDestinationInLastColumn:
        movzx eax, rows
        call RandomRange

        mov row, al
        mov al, cols
        dec al
        mov col, al

    SetDestinationValue:
        mov al, destination
        mov value, al
        call setValue
    ret
spawnDestination ENDP

; board par passenger ka count maintain karne ke liye
maintainPassengerCount PROC
    mov ecx, 400
    mov esi, OFFSET board
    mov edx, 0 
    
    CountLoop:
        cmp BYTE PTR [esi], 3 ; 3 ID ha passenger ke liye
        jne NextCell
        inc edx
    NextCell:
        inc esi
        loop CountLoop
        
    cmp edx, 3
    jge CountSatisfied
    
    ; 3 se kam hato to naya passenger spawn karo
    call spawnPassenger
    jmp maintainPassengerCount
    
    CountSatisfied:
    ret
maintainPassengerCount ENDP

selectModeMenu PROC
    call Clrscr
    mov dh, 5
    mov dl, 20
    call Gotoxy
    mov edx, OFFSET strModeTitle
    call WriteString
    
    mov dh, 7
    mov dl, 20
    call Gotoxy
    mov edx, OFFSET strMode1
    call WriteString
    
    mov dh, 8
    mov dl, 20
    call Gotoxy
    mov edx, OFFSET strMode2
    call WriteString
    
    mov dh, 9
    mov dl, 20
    call Gotoxy
    mov edx, OFFSET strMode3
    call WriteString
    
    mov dh, 11
    mov dl, 20
    call Gotoxy
    mov edx, OFFSET strChoice
    call WriteString

    ModeInputLoop:
        call ReadChar
        cmp al, '1'
        je SetCareer
        cmp al, '2'
        je SetTime
        cmp al, '3'
        je SetEndless
        jmp ModeInputLoop
    
    SetCareer:
        mov selectedMode, 1
        ret
    SetTime:
        mov selectedMode, 2
        ret
    SetEndless:
        mov selectedMode, 3
        ret
selectModeMenu ENDP

displayScore PROC
    ; Display Score
    mov edx, OFFSET scoreStr
    call WriteString
    mov eax, score
    call WriteInt
    
    ; Check Mode
    cmp selectedMode, 2
    je ShowTimer
    cmp selectedMode, 1
    je ShowCounter
    jmp DoneHUD

    ShowTimer:
        mov edx, OFFSET strTimeLabel
        call WriteString
        
        ; Calculate seconds from milliseconds
        mov eax, timeRemaining
        mov ebx, 1000
        xor edx, edx
        div ebx  
        call WriteDec
        jmp DoneHUD

    ShowCounter:
        mov edx, OFFSET strCountLabel
        call WriteString
        mov eax, passengersDelivered
        call WriteDec
        mov edx, OFFSET strSlash
        call WriteString

    DoneHUD:
    call Crlf
    ret
displayScore ENDP

displayMenu PROC
    call Clrscr
    
    ; Draw Title
    mov dh, 5           
    mov dl, 20        
    call Gotoxy
    mov edx, OFFSET strMenuTitle
    call WriteString

    ; Option 1
    mov dh, 7
    mov dl, 20
    call Gotoxy
    mov edx, OFFSET strOpt1
    call WriteString

    ; Option 2
    mov dh, 8
    mov dl, 20
    call Gotoxy
    mov edx, OFFSET strOpt2
    call WriteString

    ; Option 3
    mov dh, 9
    mov dl, 20
    call Gotoxy
    mov edx, OFFSET strOpt3
    call WriteString

    ; Option 4
    mov dh, 10
    mov dl, 20
    call Gotoxy
    mov edx, OFFSET strOpt4
    call WriteString

    ; Option 5
    mov dh, 11
    mov dl, 20
    call Gotoxy
    mov edx, OFFSET strOpt5
    call WriteString

    ; Prompt
    mov dh, 13
    mov dl, 20
    call Gotoxy
    mov edx, OFFSET strChoice
    call WriteString

    ret
displayMenu ENDP

showInstructions PROC
    call Clrscr
    mov dh, 5
    mov dl, 20
    call Gotoxy
    mov edx, OFFSET strInstTitle
    call WriteString

    mov dh, 7
    mov dl, 20
    call Gotoxy
    mov edx, OFFSET strInst1
    call WriteString

    mov dh, 8
    mov dl, 20
    call Gotoxy
    mov edx, OFFSET strInst2
    call WriteString
    
    mov dh, 9
    mov dl, 20
    call Gotoxy
    mov edx, OFFSET strInst3
    call WriteString
    
    mov dh, 10
    mov dl, 20
    call Gotoxy
    mov edx, OFFSET strInst4
    call WriteString

    mov dh, 12
    mov dl, 20
    call Gotoxy
    mov edx, OFFSET strAnyKey
    call WriteString

    call ReadChar      ; user se koi key press karwane ke liye
    ret
showInstructions ENDP

showDifficulty PROC
    call Clrscr
    mov dh, 5
    mov dl, 20
    call Gotoxy
    mov edx, OFFSET strDiffTitle
    call WriteString

    mov dh, 7
    mov dl, 20
    call Gotoxy
    mov edx, OFFSET strDiff1  ; Yellow
    call WriteString

    mov dh, 8
    mov dl, 20
    call Gotoxy
    mov edx, OFFSET strDiff2  ; Red
    call WriteString

    ; ADD RANDOM OPTION
    mov dh, 9
    mov dl, 20
    call Gotoxy
    mov edx, OFFSET strDiffRand
    call WriteString

    mov dh, 11
    mov dl, 20
    call Gotoxy
    mov edx, OFFSET strSelected
    call WriteString

    ; Show current selection
    cmp currentDifficulty, 1
    je ShowYellow
    mov edx, OFFSET strRed
    jmp PrintSel

    ShowYellow:
        mov edx, OFFSET strYellow
    PrintSel:
        call WriteString

        mov dh, 13
        mov dl, 20
        call Gotoxy
        mov edx, OFFSET strChoice
        call WriteString

        call ReadChar
        cmp al, '1'
        je SetYellowChoice
        cmp al, '2'
        je SetRedChoice
        cmp al, '3'
        je SetRandomChoice
        ret 

    SetYellowChoice:
        mov currentDifficulty, 1
        ret
    SetRedChoice:
        mov currentDifficulty, 2
        ret

    SetRandomChoice:
        ; Generate random number 0 or 1
        mov eax, 2
        call RandomRange
        add eax, 1             ; yeh 1 ya 2 bana dega
        mov currentDifficulty, al
    ret
showDifficulty ENDP

showLeaderboard PROC
    call Clrscr
    mov dh, 5
    mov dl, 20
    call Gotoxy
    mov edx, OFFSET strLeadTitle
    call WriteString

    mov dh, 7
    mov dl, 20
    call Gotoxy
    mov edx, OFFSET strNoScores
    call WriteString

    mov dh, 9
    mov dl, 20
    call Gotoxy
    mov edx, OFFSET strAnyKey
    call WriteString
    
    call ReadChar
    ret
showLeaderboard ENDP

resetGame PROC
    mov score, 0
    mov isPassengerPicked, 0
    mov playerX, 1
    mov playerY, 4

    mov ecx, 400            
    mov esi, OFFSET board 
    
    mov al, building        
    mov bl, road           

    ; ye loop pore board pe traverse kare ga or buildings ko preserve kare ga or baki cells ko road set kare ga
    ClearLoop:
        cmp BYTE PTR [esi], al  
        je SkipClear            

    mov [esi], bl           
    
    SkipClear:
        inc esi                 
        loop ClearLoop         
    ret
resetGame ENDP

inputPlayerName PROC
    call Clrscr
    
    mov dh, 10
    mov dl, 20
    call Gotoxy
    
    mov edx, OFFSET strEnterName
    call WriteString
    
    mov edx, OFFSET playerName    
    mov ecx, SIZEOF playerName - 1 ; minus 1 for null character
    call ReadString
    mov nameLength, eax           
    
    ret
inputPlayerName ENDP

pauseGame PROC
    call Clrscr
    
    mov dh, 10
    mov dl, 20
    call Gotoxy
    mov edx, OFFSET strPaused
    call WriteString

    ; Infinite loop for 'p'
    PauseWaitLoop:
        call ReadChar
        
        cmp al, 'p'
        call PlayClickSound
        je ResumeGame
        
        jmp PauseWaitLoop

    ResumeGame:
        ; simple screen clear kare ga pr game wahi se resume ho gi
        call Clrscr 
        ret
pauseGame ENDP

setTaxiAttributes PROC
    cmp currentDifficulty, 1
    je ApplyYellow
    cmp currentDifficulty, 2
    je ApplyRed
    ret

    ApplyYellow:
        mov playerColor, 0EFh
        mov obstaclePenalty, -4
        mov carPenalty, -2
        ret

    ApplyRed:
        mov playerColor, 04Fh
        mov obstaclePenalty, -2
        mov carPenalty, -3
        ret
setTaxiAttributes ENDP

PlayClickSound PROC
    INVOKE Beep, 2000, 500
    ret
PlayClickSound ENDP

main PROC
    call Randomize

    MenuLoop:
        call displayMenu
        call ReadChar

        cmp al, '1'
        je StartGame
        cmp al, '2'
        je DifficultyMenu
        cmp al, '3'
        je InstructionsMenu
        cmp al, '4'
        je LeaderboardMenu
        cmp al, '5'
        je ExitProgram
        jmp MenuLoop        ; invalid input pe wapas menu pe aajao

    DifficultyMenu:
        call showDifficulty
        jmp MenuLoop

    InstructionsMenu:
        call showInstructions
        jmp MenuLoop

    LeaderboardMenu:
        call showLeaderboard
        jmp MenuLoop

    StartGame:
        call inputPlayerName   
        call setTaxiAttributes 
        call selectModeMenu    

        call resetGame        
        mov passengersDelivered, 0 ; Reset counter
        call GetMseconds            
        mov startTime, eax         ; Start Timer

        call Clrscr
        call setPlayerOnBoard
        call maintainPassengerCount
    
        GameLoop:
            call maintainPassengerCount ; ensure 3 passengers exist every frame

            cmp selectedMode, 2    ; time mode
            jne SkipTimeUpdate
            call GetMseconds
            sub eax, startTime     ; EAX me time guzar gaya
            mov ebx, timeLimit
            sub ebx, eax           ; EBX me remaining time
            mov timeRemaining, ebx
            cmp ebx, 0             ; Check if time is up
            jle GameOverLost
            SkipTimeUpdate:

            cmp selectedMode, 1    ; career mode
            jne SkipCareerCheck
            cmp passengersDelivered, 5
            jge GameOverWin
            SkipCareerCheck:

            mov dl, 0
            mov dh, 0
            call Gotoxy
            call displayScore
            call displayBoard

            call ReadChar
            jz   GameLoop

            ; Arrow keys
            cmp ah, 48h
            je  Up
            cmp ah, 50h
            je  Down
            cmp ah, 4Bh
            je  Left
            cmp ah, 4Dh
            je  Right

            cmp al, ' '
            je Space
            cmp al, 'p'        ; 'p' to Pause
            je  PauseInput
            cmp al, 27         ; ESC key
            je  QuitToMenu      

            jmp GameLoop

            Up:
                call moveUp
                jmp GameLoop
            Down:
                call moveDown
                jmp GameLoop
            Left:
                call moveLeft
                jmp GameLoop
            Right:
                call moveRight
                jmp GameLoop
            Space:
                call pickOrDropPassenger
                jmp GameLoop
            PauseInput:
                call pauseGame
                jmp GameLoop

        GameOverWin:
            call Clrscr
            mov dh, 10
            mov dl, 20
            call Gotoxy
            mov edx, OFFSET strWin
            call WriteString
            call PlayClickSound
            call ReadChar
            jmp MenuLoop

        GameOverLost:
            call Clrscr
            mov dh, 10
            mov dl, 20
            call Gotoxy
            mov edx, OFFSET strLose
            call WriteString
            call PlayClickSound
            call ReadChar
            jmp MenuLoop

        QuitToMenu:
            jmp MenuLoop        ; Jump back to the main menu

ExitProgram:
    call PlayClickSound
    exit
main ENDP
END main