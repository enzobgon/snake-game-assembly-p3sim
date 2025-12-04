;----------------------------------------------------------------------------------------------------------------------------
; ZONE I: Constants Definition
;         Pseudo-instruction : EQU
;----------------------------------------------------------------------------------------------------------------------------

CR              EQU     0Ah
FIM_TEXTO       EQU     '@'         ; Selected null char
SPACEBAR        EQU     ' '
IO_READ         EQU     FFFFh
IO_WRITE        EQU     FFFEh       ; Write address
IO_STATUS       EQU     FFFDh
INITIAL_SP      EQU     FDFFh
CURSOR          EQU     FFFCh       ; Cursor address
CURSOR_INIT     EQU     FFFFh
ROW_SHIFT       EQU     8d

HEAD_CHAR       EQU     'O'         ; Head char
FOOD_CHAR       EQU     '*'         ; Food char
BODY_CHAR       EQU     'o'
START_ROW       EQU     12d
START_COL       EQU     40d

UP              EQU     1d          ; Configure in emulator 
RIGHT           EQU     2d
DOWN            EQU     3d
LEFT            EQU     4d

TOP_LIMIT       EQU     3d          ; Wall limits
BOT_LIMIT       EQU     23d
LEFT_LIMIT      EQU     1d  
RIGHT_LIMIT     EQU     78d

TOP_LIMIT_EXT   EQU     5d          ; Extended wall limits (food generation)
BOT_LIMIT_EXT   EQU     18d
LEFT_LIMIT_EXT  EQU     75d
RIGHT_LIMIT_EXT EQU     4d

COUNTER         EQU     FFF6h       ; Interval marker (Interrupt time)
TIMER           EQU     FFF7h       ; Timer
TIME            EQU     2d          ; Refresh time

ON              EQU     1d          ; On (Useful for flags)
OFF             EQU     0d          ; Off

RND_MASK        EQU     8016h       ; 1000 0000 0001 0110b
LSB_MASK        EQU     0001h       ; Mask to test the LSB of RandomValue
PRIME_NUMBER_1  EQU     11d
PRIME_NUMBER_2  EQU     13d
DONT_KNOW_WHY   EQU     5d

SCORE_U         EQU     10d         ; Exact column addresses for SCORE chars on map
SCORE_D         EQU     9d
SCORE_ROW       EQU     1d          ; Header center row 
NINE_CHAR       EQU     '9'         ; Decimal place advance chars
ZERO_CHAR       EQU     '0'

ONE             EQU     1d          ; Just useful characters for comparisons
ZERO            EQU     0d
MINUS_ONE       EQU     -1d

HEADER_LINE     EQU     2d          ; Row to update map without deleting header

COLUMN_RESET    EQU     0d          ; Parameter to reset column index
TEXT_RESET      EQU     0d          ; Parameter to reset text index
LAST_LINE       EQU     23d         ; Parameter to show we are at the last line

SNAKE_INIT_SIZE EQU     16d         ; Snake initialization size (normal = 1)

;----------------------------------------------------------------------------------------------------------------------------
; ZONE II: Variables Definition
;          Pseudo-instructions : WORD - Word (16 bits)
;                              STR  - String of Chars (Word)
;----------------------------------------------------------------------------------------------------------------------------

                ORIG    8000h       ; Memory allocated for operation start

L01             STR     '[][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][]', FIM_TEXTO
L02             STR     '[] SCORE:00                       SNAKE GAME                                   []', FIM_TEXTO
L03             STR     '[][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][]', FIM_TEXTO
L04             STR     '[]                                                                              []', FIM_TEXTO
L05             STR     '[]                                                                              []', FIM_TEXTO
L06             STR     '[]                                                                              []', FIM_TEXTO
L07             STR     '[]                                                                              []', FIM_TEXTO
L08             STR     '[]                                                                              []', FIM_TEXTO
L09             STR     '[]                                                                              []', FIM_TEXTO
L10             STR     '[]                                                                              []', FIM_TEXTO
L11             STR     '[]                                                                              []', FIM_TEXTO
L12             STR     '[]                                                                              []', FIM_TEXTO
L13             STR     '[]                                                                              []', FIM_TEXTO
L14             STR     '[]                                                                              []', FIM_TEXTO
L15             STR     '[]                                                                              []', FIM_TEXTO
L16             STR     '[]                                                                              []', FIM_TEXTO
L17             STR     '[]                                                                              []', FIM_TEXTO
L18             STR     '[]                                                                              []', FIM_TEXTO
L19             STR     '[]                                                                              []', FIM_TEXTO
L20             STR     '[]                                                                              []', FIM_TEXTO
L21             STR     '[]                                                                              []', FIM_TEXTO
L22             STR     '[]                                                                              []', FIM_TEXTO
L23             STR     '[]                                                                              []', FIM_TEXTO
L24             STR     '[][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][]', FIM_TEXTO

G03             STR     '[][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][]', FIM_TEXTO
G04             STR     '[]                                                                              []', FIM_TEXTO
G05             STR     '[]                                                                              []', FIM_TEXTO
G06             STR     '[]                                                                              []', FIM_TEXTO
G07             STR     '[]                                                                              []', FIM_TEXTO
G08             STR     '[]                                                                              []', FIM_TEXTO
G09             STR     '[]                                                                              []', FIM_TEXTO
G10             STR     '[]                                                                              []', FIM_TEXTO
G11             STR     '[]                                                                              []', FIM_TEXTO
G12             STR     '[]                                  YOU LOSE :)                                 []', FIM_TEXTO
G13             STR     '[]                                                                              []', FIM_TEXTO
G14             STR     '[]                                                                              []', FIM_TEXTO
G15             STR     '[]                                                                              []', FIM_TEXTO
G16             STR     '[]                                                                              []', FIM_TEXTO
G17             STR     '[]                                                                              []', FIM_TEXTO
G18             STR     '[]                                                                              []', FIM_TEXTO
G19             STR     '[]                                                                              []', FIM_TEXTO
G20             STR     '[]                                                                              []', FIM_TEXTO
G21             STR     '[]                                                                              []', FIM_TEXTO
G22             STR     '[]                                                                              []', FIM_TEXTO
G23             STR     '[]                                                                              []', FIM_TEXTO
G24             STR     '[][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][]', FIM_TEXTO

RowIndex        WORD    0d          ; Row 0
ColumnIndex     WORD    0d          ; Column 0
TextIndex       WORD    0d          ; Initial text index

SnakeBodyRow    TAB     100d        ; Table to store snake body rows
SnakeBodyCol    TAB     100d        ; Table to store snake body columns
SnakeSize       WORD    0d          ; Current snake size

HeadRow         WORD    START_ROW   ; Initial head row
HeadCol         WORD    START_COL   ; Initial head column
FoodRow         WORD    20d
FoodCol         WORD    20d

Direction       WORD    RIGHT

ButtonFlag      WORD    0d          ; 0 = can change direction | 1 = already changed in this cycle
GrowFlag        WORD    0d          ; 0 = won't grow           | 1 = will grow
GameOverFlag    WORD    0d          ; 0 = game running         | 1 = game ended

RandomValue     WORD    A5A5h       ; 1010 0101 1010 0101
RandomState     WORD    24d

ScoreD          WORD    '0'
ScoreU          WORD    '0'

;----------------------------------------------------------------------------------------------------------------------------
; ZONE III: Interrupt Table Definition
;----------------------------------------------------------------------------------------------------------------------------

                ORIG    FE00h
INT0            WORD    TurnUp
INT1            WORD    TurnRight
INT2            WORD    TurnDown
INT3            WORD    TurnLeft

                ORIG    FE0Fh
INT15           WORD    StartGame

;----------------------------------------------------------------------------------------------------------------------------
; ZONE IV: Main Code
;----------------------------------------------------------------------------------------------------------------------------

                ORIG    0000h
                JMP     Main

;----------------------------------------------------------------------------------------------------------------------------
; Function Printf Map
;----------------------------------------------------------------------------------------------------------------------------

Printf:         PUSH    R1
                PUSH    R2
                PUSH    R3
                PUSH    R4
                PUSH    R5
                PUSH    R6
                PUSH    R7

                MOV     R5, L01                ; Loads initial address of desired line
                MOV     R6, COLUMN_RESET       ; Used to reset Column Index
                MOV     R7, LAST_LINE          ; Used to compare Row Index

PrintfCycle:    MOV     R1, M[ TextIndex ]     ; Loads Text Index (0) into R1
                ADD     R1, R5
                MOV     R2, M[ R1 ]            ; Gets current char from string
                CMP     R2, FIM_TEXTO          ; Is char equal to '@'?
                JMP.Z   RowCycle               ; If yes, exit cycle

                MOV     R3, M[ RowIndex ]      ; Loads row index into R3
                MOV     R4, M[ ColumnIndex ]   ; Loads column index into R4
                SHL     R3, ROW_SHIFT          ; Adjust row to correct position
                OR      R3, R4                 ; Combines row and column
                MOV     M[ CURSOR ], R3        ; Moves cursor to position [Row|Col]
                MOV     M[ IO_WRITE ], R2      ; Writes char stored in R2
                INC     M[ TextIndex ]         ; Increments text index
                INC     M[ ColumnIndex ]       ; Increments column
                JMP     PrintfCycle            ; Restarts for next Char

RowCycle:       CMP     M[ RowIndex], R7       ; Is index equal to 23d (24 lines)?
                JMP.Z   EndPrintf
                INC     M[ RowIndex ]          ; Increments row
                MOV     M[ ColumnIndex ], R6   ; Resets column index
                INC     M[ TextIndex ]         ; Increments text index
                JMP     PrintfCycle

EndPrintf:      POP     R7
                POP     R6
                POP     R5
                POP     R4
                POP     R3
                POP     R2
                POP     R1
                RET

;----------------------------------------------------------------------------------------------------------------------------
; Function Printf You Lose
;----------------------------------------------------------------------------------------------------------------------------

PrintYouLose:   PUSH    R1
                PUSH    R2
                PUSH    R3
                PUSH    R4
                PUSH    R5
                PUSH    R6
                PUSH    R7

                MOV     R5, TEXT_RESET         ; Resetting TextIndex
                MOV     M[ TextIndex ], R5    
                MOV     R5, HEADER_LINE        ; Row Index starts at line 2 to preserve Header
                MOV     M[ RowIndex ], R5
                MOV     R5, G03                ; Loads initial address of desired line
                MOV     R6, COLUMN_RESET       ; Used to reset Column Index
                MOV     R7, LAST_LINE          ; Used to compare Row Index

YouLoseCycle:   MOV     R1, M[ TextIndex ]     
                ADD     R1, R5
                MOV     R2, M[ R1 ]            
                CMP     R2, FIM_TEXTO          
                JMP.Z   YouLoseRowCycle          

                MOV     R3, M[ RowIndex ]
                MOV     R4, M[ ColumnIndex ]
                SHL     R3, ROW_SHIFT
                OR      R3, R4                 
                MOV     M[ CURSOR ], R3 
                MOV     M[ IO_WRITE ], R2 
                INC     M[ TextIndex ] 
                INC     M[ ColumnIndex ] 
                JMP     YouLoseCycle

YouLoseRowCycle:CMP     M[ RowIndex], R7       ; Is index equal to 23d (24 lines)?
                JMP.Z   EndYouLosePrint
                INC     M[ RowIndex ]          ; Increments row
                MOV     M[ ColumnIndex ], R6   ; Resets column index
                INC     M[ TextIndex ]         ; Increments text index
                JMP     YouLoseCycle

EndYouLosePrint:POP     R7
                POP     R6
                POP     R5
                POP     R4
                POP     R3
                POP     R2
                POP     R1
                RET

;----------------------------------------------------------------------------------------------------------------------------
; Function Timer
;----------------------------------------------------------------------------------------------------------------------------

Timer:          PUSH    R1
                MOV     R1, TIME               ; Count time (5 = 500ms)
                MOV     M[ COUNTER ], R1       ; Configures timer
                MOV     R1, ON                 ; Activates timer
                MOV     M[ TIMER ], R1
                POP     R1
                RET

;----------------------------------------------------------------------------------------------------------------------------
; Function Check Collision
;----------------------------------------------------------------------------------------------------------------------------

CheckCollision: PUSH    R1
                PUSH    R2
                PUSH    R3
                PUSH    R4

                MOV     R1, M[ HeadRow ]       ; Current head row
                MOV     R2, M[ HeadCol ]       ; Current head column

                CMP     R1, TOP_LIMIT
                JMP.Z    StopGame

                CMP     R1, BOT_LIMIT          ; Bottom limit
                JMP.Z    StopGame

                CMP     R2, LEFT_LIMIT         ; Left limit
                JMP.Z    StopGame

                CMP     R2, RIGHT_LIMIT        ; Right limit
                JMP.Z    StopGame

                POP     R4
                POP     R3
                POP     R2
                POP     R1
                RET

;----------------------------------------------------------------------------------------------------------------------------
; Function Check Food Collision
;----------------------------------------------------------------------------------------------------------------------------

CheckFoodCollision: PUSH    R1

                    MOV     R1, M[FoodRow]
                    CMP     M[HeadRow], R1
                    JMP.NZ  EndFoodCollision

                    MOV     R1, M[FoodCol]
                    CMP     M[HeadCol], R1
                    JMP.NZ  EndFoodCollision

                    MOV     R1, ON
                    MOV     M[GrowFlag], R1

                    CALL    UpdateScore
                    CALL    GenerateFood

EndFoodCollision:   POP     R1
                    RET

;----------------------------------------------------------------------------------------------------------------------------
; Function Check Food Collision
;----------------------------------------------------------------------------------------------------------------------------

CheckSelfCollision: PUSH    R1
                    PUSH    R2
                    PUSH    R3
                    PUSH    R4
                    PUSH    R5

                    MOV     R1, M[HeadRow]    ; Head row
                    MOV     R2, M[HeadCol]    ; Head column
                    MOV     R3, M[SnakeSize]  ; Number of body segments
                    DEC     R3                ; Does not check head

CheckLoop:          CMP     R3, ZERO
                    JMP.Z   EndCheck          ; If finished checking, return

                    MOV     R4, SnakeBodyRow  ; Gets body segment address
                    ADD     R4, R3
                    MOV     R5, M[R4]         ; Segment row

                    CMP     R1, R5            ; Is head in the same row?
                    JMP.NZ  SkipCheck

                    MOV     R4, SnakeBodyCol  ; Gets segment column
                    ADD     R4, R3
                    MOV     R5, M[R4]         ; Segment column

                    CMP     R2, R5            ; Is head in the same column?
                    JMP.NZ  SkipCheck

                    CALL    StopGame          ; Calls StopGame correctly
                    JMP     Halt              ; Ensures game does not continue

SkipCheck:          DEC     R3                ; Moves to next segment
                    JMP     CheckLoop

EndCheck:           POP     R5
                    POP     R4
                    POP     R3
                    POP     R2
                    POP     R1
                    RET

;----------------------------------------------------------------------------------------------------------------------------
; Function Update Score
;----------------------------------------------------------------------------------------------------------------------------

UpdateScore:    PUSH R1
                PUSH R2
                PUSH R3



                MOV R1, M[ ScoreU ]
                MOV R2, M[ ScoreD ]
                MOV R3, NINE_CHAR

                CMP R1, R3                  ; If unit equals 9
                JMP.NZ UpdateUnity          ; Update ten 
                JMP.Z UpdateTen

UpdateTen:      MOV R1, ZERO_CHAR
                MOV M[ ScoreU ], R1
                MOV R3, SCORE_U
                MOV R2, R3

                MOV R3, SCORE_ROW           ; Adjustment to consider L01 (Header)
                SHL R3, ROW_SHIFT
                OR R2, R3
                MOV M[ CURSOR ], R2
                MOV M[ IO_WRITE ], R1

                INC M[ ScoreD ]
                MOV R1, M[ ScoreD ]
                MOV R3, SCORE_D
                MOV R2, R3

                MOV R3, SCORE_ROW
                SHL R3, ROW_SHIFT
                OR R2, R3
                MOV M[ CURSOR ], R2
                MOV M[ IO_WRITE ], R1

                JMP UpdateScoreEnd

UpdateUnity:    INC M[ ScoreU ]
                MOV R1, M[ ScoreU ]
                MOV R2, SCORE_U

                MOV R3, SCORE_ROW
                SHL R3, ROW_SHIFT
                OR R2, R3
                MOV M[ CURSOR ], R2
                MOV M[ IO_WRITE ], R1
                 
                JMP UpdateScoreEnd

UpdateScoreEnd: POP R3
                POP R2
                POP R1
                RET

;----------------------------------------------------------------------------------------------------------------------------
; Interrupts Turn's
;----------------------------------------------------------------------------------------------------------------------------

TurnUp:         PUSH    R1                      ; Direction capture functions 
                MOV     R1, M[ButtonFlag]       ; Checks if button already pressed in this cycle
                CMP     R1, ON
                JMP.Z   EndTurn                 ; If already pressed, ignore input

                MOV     R1, DOWN
                CMP     R1, M[Direction]
                JMP.Z   EndTurn
                MOV     R1, UP
                MOV     M[Direction], R1

                MOV     R1, ON                  ; Activates flag to avoid repeated changes
                MOV     M[ButtonFlag], R1

EndTurn:        POP     R1
                RTI

TurnRight:      PUSH    R1
                MOV     R1, M[ButtonFlag]
                CMP     R1, ON
                JMP.Z   EndTurn

                MOV     R1, LEFT
                CMP     R1, M[Direction]
                JMP.Z   EndTurn
                MOV     R1, RIGHT
                MOV     M[Direction], R1

                MOV     R1, ON
                MOV     M[ButtonFlag], R1

                JMP     EndTurn

TurnDown:       PUSH    R1
                MOV     R1, M[ButtonFlag]
                CMP     R1, ON
                JMP.Z   EndTurn

                MOV     R1, UP
                CMP     R1, M[Direction]
                JMP.Z   EndTurn
                MOV     R1, DOWN
                MOV     M[Direction], R1

                MOV     R1, ON
                MOV     M[ButtonFlag], R1

                JMP     EndTurn

TurnLeft:       PUSH    R1
                MOV     R1, M[ButtonFlag]
                CMP     R1, ON
                JMP.Z   EndTurn

                MOV     R1, RIGHT
                CMP     R1, M[Direction]
                JMP.Z   EndTurn
                MOV     R1, LEFT
                MOV     M[Direction], R1

                MOV     R1, ON
                MOV     M[ButtonFlag], R1

                JMP     EndTurn

;----------------------------------------------------------------------------------------------------------------------------
; Function Move Snake
;----------------------------------------------------------------------------------------------------------------------------

MoveSnake:      PUSH    R1
                PUSH    R2
                PUSH    R3
                PUSH    R4

                MOV     R1, M[GameOverFlag]         ; Flag triggered in Game Over conditions (Collisions)
                CMP     R1, ON
                JMP.Z   EndMoveSnake

                MOV     R4, M[Direction]            ; Direction "updated" in interrupt interval by Turns

                CMP     R4, UP                      ; Checks if there was any update in direction
                JMP.Z   MoveUpLogic
                CMP     R4, DOWN
                JMP.Z   MoveDownLogic
                CMP     R4, LEFT
                JMP.Z   MoveLeftLogic
                CMP     R4, RIGHT
                JMP.Z   MoveRightLogic

MoveUpLogic:    DEC     M[HeadRow]                  ; Head address adjustments = movement
                JMP     MoveEndLogic

MoveDownLogic:  INC     M[HeadRow]
                JMP     MoveEndLogic

MoveLeftLogic:  DEC     M[HeadCol]
                JMP     MoveEndLogic

MoveRightLogic: INC     M[HeadCol]

MoveEndLogic:   MOV     R1, OFF                   
                MOV     M[ButtonFlag], R1 

                CALL    CheckFoodCollision      ; Collision with food? (Activate Grow Flag)
                CALL    UpdateSnakeBody         ; Body update function.
                CALL    CheckCollision          ; Collision with wall? (Activate GameOver Flag)
                CALL    CheckSelfCollision      ; Collision with own body? (Activate GameOver Flag)

EndMoveSnake:   POP     R4
                POP     R3
                POP     R2
                POP     R1
                RET

;----------------------------------------------------------------------------------------------------------------------------
; Function Update Snake Body
;----------------------------------------------------------------------------------------------------------------------------

UpdateSnakeBody:PUSH    R1
                PUSH    R2
                PUSH    R3
                PUSH    R4
                PUSH    R5
                PUSH    R6

                MOV     R1, M[SnakeSize]    ; R1 = Snake Size
                CMP     R1, ZERO            ; Initial snake?
                JMP.Z   InitSnakeBody       ; Initializes body, if needed

                MOV     R2, M[SnakeSize]    ; R2 = Snake Size
                DEC     R2                  ; Last tail index

                MOV     R4, SnakeBodyRow    ; ALWAYS erase tail, even during growth
                ADD     R4, R2              ; Tail row position
                MOV     R5, M[R4]          

                MOV     R4, SnakeBodyCol    ; Tail column position
                ADD     R4, R2              ; Calculates last column address
                MOV     R6, M[R4]           ; Loads tail column

                SHL     R5, ROW_SHIFT       ; Combines row with cursor position
                OR      R5, R6
                MOV     M[CURSOR], R5       ; Positions cursor at tail
                MOV     R1, SPACEBAR        ; Erases tail (replaces with space)
                MOV     M[IO_WRITE], R1

                DEC     R2                  ; Update body (move segments forward)

UpdateBodyLoop: CMP     R2, MINUS_ONE       ; Checked all segments?
                JMP.Z   UpdateBodyEnd       ; Finishes body update

                MOV     R3, SnakeBodyRow    ; Copy previous segment to next
                ADD     R3, R2
                MOV     R4, SnakeBodyRow   
                ADD     R4, R2
                INC     R4
                MOV     R5, M[R3]          
                MOV     M[R4], R5          

                MOV     R3, SnakeBodyCol     
                ADD     R3, R2
                MOV     R4, SnakeBodyCol     
                ADD     R4, R2
                INC     R4
                MOV     R5, M[R3]           ; Here, loads prev segment cols and row into new small table
                MOV     M[R4], R5           ; Saves at current position 

                DEC     R2             
                JMP     UpdateBodyLoop

UpdateBodyEnd:  MOV     R3, SnakeBodyRow
                MOV     R4, M[HeadRow]      ; Head row
                MOV     M[R3], R4           ; Saves in row table

                MOV     R3, SnakeBodyCol
                MOV     R4, M[HeadCol]      ; Head column
                MOV     M[R3], R4           ; Saves in column table

                MOV     R2, M[SnakeSize] 
                DEC     R2                  ; Adjusts index to print segments (Everything but head) / End of update phase

DrawBodyLoop:   CMP     R2, ZERO
                JMP.N   DrawHead

                MOV     R3, SnakeBodyRow
                ADD     R3, R2
                MOV     R4, M[R3]           

                MOV     R3, SnakeBodyCol
                ADD     R3, R2
                MOV     R5, M[R3]           

                SHL     R4, ROW_SHIFT       
                OR      R4, R5
                MOV     M[CURSOR], R4       
                MOV     R1, BODY_CHAR       ; Draws body
                MOV     M[IO_WRITE], R1

                DEC     R2                  ; Traversing list until last body segment
                JMP     DrawBodyLoop         

DrawHead:       MOV     R3, M[HeadRow]      ; Finally, draws head :)
                MOV     R4, M[HeadCol]   
                SHL     R3, ROW_SHIFT    
                OR      R3, R4
                MOV     M[CURSOR], R3     
                MOV     R1, HEAD_CHAR 
                MOV     M[IO_WRITE], R1

                MOV     R1, M[GrowFlag]     ; Checks grow flag
                CMP     R1, ON
                JMP.NZ  EndGrow

                INC     M[SnakeSize]        ; Increments snake size
                MOV     R1, OFF             ; Resets GrowFlag
                MOV     M[GrowFlag], R1

EndGrow:        POP     R6
                POP     R5
                POP     R4
                POP     R3
                POP     R2
                POP     R1
                RET

InitSnakeBody:  MOV     R3, M[HeadRow]      ; Initializes snake body
                MOV     R4, M[HeadCol]
                MOV     M[SnakeBodyRow], R3 ; Body = Head
                MOV     M[SnakeBodyCol], R4
                MOV     R1, SNAKE_INIT_SIZE
                MOV     M[SnakeSize], R1
                JMP     EndGrow

;----------------------------------------------------------------------------------------------------------------------------
; Function RNG
;----------------------------------------------------------------------------------------------------------------------------

RNG:        PUSH R1
            PUSH R2
            PUSH R3
            PUSH R4

            MOV R1, M[ RandomState ]
            MOV R2, PRIME_NUMBER_1
            MOV R3, PRIME_NUMBER_2
            MOV R4, DONT_KNOW_WHY           ; I don't know why... It's a decimal 5.

            MUL R1, R2                      ; Attention: The operation result is in R1 and R2!!!
            ADD R2, R3                      ; Let's use the 16 least significant bits of MUL
            MOV M[ RandomState ], R2

            DIV R2, R4
            MOV M[ RandomValue ], R4

            POP R4
            POP R3
            POP R2
            POP R1

            RET

;----------------------------------------------------------------------------------------------------------------------------
; Function Generate Food
;---------------------------------------------------------------------------------------------------------------------------- 

GenerateFood:       PUSH    R1
                    PUSH    R2
                    PUSH    R3
                    PUSH    R4
                    PUSH    R5

GeneratePosition:   CALL    RNG                     
                    MOV     R3, M[RandomState]          ; Returns random value in M[RandomValue] for food row
                    MOV     R1, BOT_LIMIT_EXT           ; Available row limits for food (Exaggerated)
                    DIV     R3, R1                      
                    ADD     R1, TOP_LIMIT_EXT                       
                    MOV     M[FoodRow], R1              ; Defines food row

                    CALL    RNG
                    MOV     R3, M[RandomState]          ; Returns random value in M[RandomValue] for food column
                    MOV     R2, RIGHT_LIMIT_EXT         ; Available column limits (Exaggerated)
                    DIV     R3, R2
                    ADD     R2, LEFT_LIMIT_EXT                       
                    MOV     M[FoodCol], R2              ; Defines food column

                    MOV     R3, M[SnakeSize]            ; Gets snake size
                    DEC     R3                          ; Adjusts index to verify each body segment

CheckFoodPosition:  CMP     R3, ZERO                    ; If checked whole snake (size = 0), can place food
                    JMP.Z   PlaceFood                   ; We can place food

                    MOV     R4, SnakeBodyRow            ; Gets current body segment row
                    ADD     R4, R3
                    MOV     R5, M[R4]                   ; Segment row

                    CMP     R1, R5                      ; Compares with food row
                    JMP.NZ  SkipCheckFood               ; If different, skip to next segment

                    MOV     R4, SnakeBodyCol            ; Gets current body segment column
                    ADD     R4, R3
                    MOV     R5, M[R4]                   ; Segment column

                    CMP     R2, R5                      ; Compares with food column
                    JMP.Z   GeneratePosition            ; Ouch, collided

SkipCheckFood:      DEC     R3                          ; Continue checking next segments
                    JMP     CheckFoodPosition

PlaceFood:          SHL     R1, ROW_SHIFT
                    OR      R1, R2
                    MOV     R3, FOOD_CHAR               
                    MOV     M[CURSOR], R1               
                    MOV     M[IO_WRITE], R3             ; Prints the little food

                    POP     R5
                    POP     R4
                    POP     R3
                    POP     R2
                    POP     R1
                    RET

;----------------------------------------------------------------------------------------------------------------------------
; Function Start Game
;----------------------------------------------------------------------------------------------------------------------------

StartGame:      CALL MoveSnake                      ; Start of interrupt routine
                CALL Timer                          ; "Continuous" movement
                RTI

;----------------------------------------------------------------------------------------------------------------------------
; Function Stop Game
;----------------------------------------------------------------------------------------------------------------------------

StopGame:       MOV     R3, ON                  ; End of game, GameOverFlag is activated
                MOV     M[ GameOverFlag ], R3

                MOV     R3, OFF                 ; Stops timer
                MOV     M[ TIMER ], R3

                CALL    PrintYouLose

                POP     R4
                POP     R3
                POP     R2
                POP     R1
                JMP     Halt

;----------------------------------------------------------------------------------------------------------------------------
; Function Main
;----------------------------------------------------------------------------------------------------------------------------

Main:           ENI                             ; Activates interrupts
                MOV     R1, INITIAL_SP          ; Initializes Stack Pointer
                MOV     SP, R1
                MOV     R1, CURSOR_INIT         ; Initializes Cursor
                MOV     M[ CURSOR ], R1

                MOV     R1, ZERO
                MOV     M[TextIndex], R1

                CALL    Printf                  ; Calls the little map
                CALL    GenerateFood            ; Generates first little fruit
                CALL    Timer                   ; Activates timer

Cycle:          BR      Cycle
Halt:           BR      Halt
