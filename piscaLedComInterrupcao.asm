#INCLUDE <P12F675.INC>

__CONFIG _INTRC_OSC_NOCLKOUT & _WDT_OFF & _PWRTE_OFF & _MCLR_ OFF & _CPD_OFF & _CP_OFF &

CBLOCK 0X0C
TEMP1
TEMP500
W_TEMP
STATUS_TEMP
ENDC

ORG 0X0000

GOTO PRINCIPAL

ORG 0X0004
MOVWF W_TEMP
SWAPF STATUS,W
MOVWF STATUS_TEMP
BTFSC INTCON,T0IF
GOTO TRATA_TMR0
BTFSC INTCON,T0IF
GOTO TRATA_TMR0
BTFSC PIR1,TMR1IF
GOTO TRATA_TMR1
BTFSC INTCON,INTF
GOTO TRATA_INT

FIM_INT:
SWAPF STATUS_TEMP,W
MOVWF STATUS
SWAPF W_TEMP,W
RETFIE

TRATA_TMR0:
BCF INTCON,T0IF
GOTO FIM_INT

TRATA_TMR1:
BCF PIR1,T1IF
GOTO FIM_INT

TRATA_INT:
BCF INTCON,INTIF
BSF LED_VM
GOTO FIM_INT

#DEFINE Chave_1 GPIO,2
#DEFINE Chave_2 GPIO,3

#DEFINE LED_VD GPIO,5
#DEFINE LED_AM GPIO,4
#DEFINE LED_VM GPIO,1

#DEFINE Banco STATUS,RP0

BSF Banco
MOVLW B'00000001'
MOVWF ANSEL
MOVLW B'00001101'
MOVWF TRISIO
BCF Banco
MOVLW B'00000111'
MOVWF CMCON
MOVLW B'10010000'
MOVWF INTCON

BCF LED_VD
BCF LED_AM
BCF LED_VM

PRINCIPAL:
BSF LED_VD ; ACENDE LED VERDE
CALL DELAY_500MS; PAUSA 500MS
BCF LED_VD ;APAGA LED VERDE
CALL DELAY_500MS ; PAUSA 500MS
GOTO PRINCIPAL

DELAY_500MS:
MOVLW .200
MOVWF TEMP500
DL_50
CALL DELAY_2MS
DECFSZ TEMP500,F
GOTO DL_50
RETURN

DELAY_2MS
MOVLW .250
MOVWF TEMP1
DL_10
NOP
NOP
NOP
NOP
NOP
NOP
NOP
DECFDZ TEMP1,F
GOTO DL_10
RETURN

END
