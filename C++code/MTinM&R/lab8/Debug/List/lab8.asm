
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega128A
;Program type           : Application
;Clock frequency        : 11,052900 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 1024 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: No
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega128A
	#pragma AVRPART MEMORY PROG_FLASH 131072
	#pragma AVRPART MEMORY EEPROM 4096
	#pragma AVRPART MEMORY INT_SRAM SIZE 4096
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x100

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU RAMPZ=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F
	.EQU XMCRA=0x6D
	.EQU XMCRB=0x6C

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0100
	.EQU __SRAM_END=0x10FF
	.EQU __DSTACK_SIZE=0x0400
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _Kp=R4
	.DEF _Kp_msb=R5
	.DEF _Kd=R6
	.DEF _Kd_msb=R7
	.DEF _count=R8
	.DEF _count_msb=R9
	.DEF _button=R11
	.DEF _flag_control=R10
	.DEF _f_Kp=R13

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  _int1Isr
	JMP  _NameIsr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x3,0x0,0x0,0x0
	.DB  0xA,0x0,0x0,0x0
	.DB  0x0,0x0

_0x3:
	.DB  0x3F,0x6,0x5B,0x4F,0x66,0x6D,0x7D,0x7
	.DB  0x7F,0x6F,0x40
_0x2000060:
	.DB  0x1
_0x2000000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x0A
	.DW  0x04
	.DW  __REG_VARS*2

	.DW  0x0B
	.DW  _segments
	.DW  _0x3*2

	.DW  0x01
	.DW  __seed_G100
	.DW  _0x2000060*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  MCUCR,R31
	OUT  MCUCR,R30
	STS  XMCRB,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,LOW(__SRAM_START)
	LDI  R27,HIGH(__SRAM_START)
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

	OUT  RAMPZ,R24

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x500

	.CSEG
;/*
;* lab8
; * Created: 11.09.2019 11:46:22
; * Author: Student
; *
; * Variant 8
; * ����� �������� �������� ������ ��������
; *
;  �� ������� �� ������ �������� ����� ������ �������� ��� ���������.
;   ��������� ���������� ��������, ������� ������ � ������ ������:
;   � green Kd
;   � red Kp
;   - blue control
; * 3 10
; */
;
;#include <define.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif
;#define SIGN 10
;#define VOID 11
;
;// ������ ����� ����
;const unsigned char segments[] = {0x3F, 0x06, 0x5B, 0x4F, 0x66, 0x6D,0x7D, 0x07, 0x7F, 0x6F, 0x40, 0x00};

	.DSEG
;unsigned char Digit (unsigned int val, unsigned char m)
; 0000 0011 {

	.CSEG
_Digit:
; .FSTART _Digit
;    //[]-----------------------------------------------------[]
;    //| ����������: ��������� ���� �� �������� �������������� |
;    //| ����������� �������������� �����  |
;    //| ������� ���������: |
;    //| d - ����� ���������� ������������� ����� |
;    //| m - ����� ������� (�� 1 �� 5, ����� �������) |
;    //| ������� ���������� �������� ����� � ������� m ����� d |
;    //[]-----------------------------------------------------[]
;    unsigned char i = 5, a ;
;    unsigned int d = val ;
;    while(i)
	ST   -Y,R26
	CALL __SAVELOCR4
;	val -> Y+5
;	m -> Y+4
;	i -> R17
;	a -> R16
;	d -> R18,R19
	LDI  R17,5
	__GETWRS 18,19,5
_0x4:
	CPI  R17,0
	BREQ _0x6
;    { // ���� �� �������� �����
;        a = d%10; // �������� ��������� ������
	MOVW R26,R18
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21U
	MOV  R16,R30
;        if(i-- == m) break; // ������� �������� ������ - ������
	PUSH R17
	SUBI R17,1
	LDD  R30,Y+4
	POP  R26
	CP   R30,R26
	BREQ _0x6
;        d /= 10; // ��������� ����� � 10 ���
	MOVW R26,R18
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21U
	MOVW R18,R30
;    }
	RJMP _0x4
_0x6:
;    return(a);
	MOV  R30,R16
	CALL __LOADLOCR4
	ADIW R28,7
	RET
;}
; .FEND
;
;void indic_int (int val)
;{
_indic_int:
; .FSTART _indic_int
;    unsigned char i = 1;
;    int flag_first_digit = 0;
;    int var = val;
;    if(val<0)
	CALL SUBOPT_0x0
;	val -> Y+6
;	i -> R17
;	flag_first_digit -> R18,R19
;	var -> R20,R21
	LDD  R26,Y+7
	TST  R26
	BRPL _0x8
;    {
;        var = abs(val); ///������� � ������ ��� �������������� �����
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	RCALL _abs
	MOVW R20,R30
;    }
;    do
_0x8:
_0xA:
;    {
;       unsigned int digit;
;       digit=Digit(var,i);
	CALL SUBOPT_0x1
;	val -> Y+8
;	digit -> Y+0
;
;       if(digit==0)
	BRNE _0xC
;       {
;            if(flag_first_digit==0)
	MOV  R0,R18
	OR   R0,R19
	BRNE _0xD
;            {
;                PORTC = segments[VOID];
	__GETB1MN _segments,11
	OUT  0x15,R30
;                if(i==5)
	CPI  R17,5
	BRNE _0xE
;                {
;                    PORTC = segments[0];
	LDS  R30,_segments
	OUT  0x15,R30
;                }
;            }else
_0xE:
	RJMP _0xF
_0xD:
;            {
;                PORTC = segments[0];
	LDS  R30,_segments
	OUT  0x15,R30
;            }
_0xF:
;       }else
	RJMP _0x10
_0xC:
;       {     if(val<0)
	LDD  R26,Y+9
	TST  R26
	BRPL _0x11
;             {
;                 if(flag_first_digit==0)
	MOV  R0,R18
	OR   R0,R19
	BRNE _0x12
;                 {
;                     PORTC = segments[SIGN];
	__GETB1MN _segments,10
	OUT  0x15,R30
;                     BitSet(PORTA,i-1) ;
	CALL SUBOPT_0x2
	CALL SUBOPT_0x3
;                     delay_us(1)     ;
;                     BitClr(PORTA,i-1) ;
	CALL SUBOPT_0x2
	COM  R30
	AND  R30,R1
	OUT  0x1B,R30
;                 }
;             }
_0x12:
;             flag_first_digit = 1;
_0x11:
	CALL SUBOPT_0x4
;             PORTC = segments[digit];
;
;       }
_0x10:
;       BitSet(PORTA,i) ;
	CALL SUBOPT_0x5
	CALL SUBOPT_0x3
;       delay_us(1)     ;
;       BitClr(PORTA,i) ;
	CALL SUBOPT_0x5
	COM  R30
	AND  R30,R1
	OUT  0x1B,R30
;       i++;
	SUBI R17,-1
;    }
	ADIW R28,2
;    while (i<=5);
	CPI  R17,6
	BRLO _0xA
;}
	RJMP _0x2080001
; .FEND
;
;
;void indic_uint (unsigned int val)
;{
_indic_uint:
; .FSTART _indic_uint
;    unsigned char i = 1;
;    int flag_first_digit = 0;
;    int var = val;
;    do
	CALL SUBOPT_0x0
;	val -> Y+6
;	i -> R17
;	flag_first_digit -> R18,R19
;	var -> R20,R21
_0x14:
;    {
;       unsigned int digit;
;       digit=Digit(var,i);
	CALL SUBOPT_0x1
;	val -> Y+8
;	digit -> Y+0
;
;       if(digit==0)
	BRNE _0x16
;       {
;            if(flag_first_digit==0)
	MOV  R0,R18
	OR   R0,R19
	BRNE _0x17
;            {
;                PORTC = segments[VOID];
	__GETB1MN _segments,11
	OUT  0x15,R30
;                if(i==5)
	CPI  R17,5
	BRNE _0x18
;                {
;                    PORTC = segments[0];
	LDS  R30,_segments
	OUT  0x15,R30
;                }
;            }else
_0x18:
	RJMP _0x19
_0x17:
;            {
;                PORTC = segments[0];
	LDS  R30,_segments
	OUT  0x15,R30
;            }
_0x19:
;       }else
	RJMP _0x1A
_0x16:
;       {
;             flag_first_digit = 1;
	CALL SUBOPT_0x4
;             PORTC = segments[digit];
;       }
_0x1A:
;       BitSet(PORTA,i) ;
	CALL SUBOPT_0x5
	CALL SUBOPT_0x3
;       delay_us(1)     ;
;       BitClr(PORTA,i) ;
	CALL SUBOPT_0x5
	COM  R30
	AND  R30,R1
	OUT  0x1B,R30
;       i++;
	SUBI R17,-1
;    }
	ADIW R28,2
;    while (i<=5);
	CPI  R17,6
	BRLO _0x14
;}
_0x2080001:
	CALL __LOADLOCR6
	ADIW R28,8
	RET
; .FEND
;
;//void indic_float (float val)
;//{
;//    unsigned char i = 1;
;//    int flag_first_digit = 0;
;//    flo var = val;
;//    if(val<0)
;//    {
;//        var = abs(val); ///������� � ������ ��� �������������� �����
;//    }
;//    do
;//    {
;//       unsigned int digit;
;//       digit=Digit(var,i);
;//
;//       if(digit==0)
;//       {
;//            if(flag_first_digit==0)
;//            {
;//                PORTC = segments[VOID];
;//                if(i==5)
;//                {
;//                    PORTC = segments[0];
;//                }
;//            }else
;//            {
;//                PORTC = segments[0];
;//            }
;//       }else
;//       {     if(val<0)
;//             {
;//                 if(flag_first_digit==0)
;//                 {
;//                     PORTC = segments[SIGN];
;//                     BitSet(PORTA,i-1) ;
;//                     delay_us(1)     ;
;//                     BitClr(PORTA,i-1) ;
;//                 }
;//             }
;//             flag_first_digit = 1;
;//             PORTC = segments[digit];
;//
;//       }
;//       BitSet(PORTA,i) ;
;//       delay_us(1)     ;
;//       BitClr(PORTA,i) ;
;//       i++;
;//    }
;//    while (i<=5);
;//
;//}
;
;void init_segments()
;{
_init_segments:
; .FSTART _init_segments
;    PORTA &=  ~(_BV(1) | _BV(2) | _BV(3) | _BV(4) | _BV(5) )  ;
	IN   R30,0x1B
	ANDI R30,LOW(0xC1)
	OUT  0x1B,R30
;    PORTC = 0 ;
	LDI  R30,LOW(0)
	OUT  0x15,R30
;    DDRA = _BV(DDA1) | _BV(DDA2) | _BV(DDA3) | _BV(DDA4) | _BV(DDA5)  ;
	LDI  R30,LOW(62)
	OUT  0x1A,R30
;    DDRC = _BV(DDC0) | _BV(DDC1) | _BV(DDC2) | _BV(DDC3) | _BV(DDC4) | _BV(DDC5) | _BV(DDC6) | _BV(DDC7);
	LDI  R30,LOW(255)
	OUT  0x14,R30
;}
	RET
; .FEND
;
;
;interrupt [EXT_INT2] void NameIsr(void)
; 0000 0014 {
_NameIsr:
; .FSTART _NameIsr
	ST   -Y,R26
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0015     if (BIT_IS_CLEAR(PIND, 2))
	SBIC 0x10,2
	RJMP _0x1B
; 0000 0016     {
; 0000 0017         button++;
	INC  R11
; 0000 0018         switch (button) {
	MOV  R30,R11
	LDI  R31,0
; 0000 0019         case 1:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x1F
; 0000 001A             f_Kp=1;
	LDI  R30,LOW(1)
	MOV  R13,R30
; 0000 001B             count=Kp;
	MOVW R8,R4
; 0000 001C         break;
	RJMP _0x1E
; 0000 001D         case 2:  //������ ����������
_0x1F:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x20
; 0000 001E             flag_control=1;
	LDI  R30,LOW(1)
	MOV  R10,R30
; 0000 001F             f_Kp=0;
	CLR  R13
; 0000 0020             PORTE = _BV(3);
	LDI  R30,LOW(8)
	OUT  0x3,R30
; 0000 0021         break;
	RJMP _0x1E
; 0000 0022         case 3:       //��������� � ����� ���������
_0x20:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x22
; 0000 0023             PORTE=0;
	LDI  R30,LOW(0)
	OUT  0x3,R30
; 0000 0024             button=0;
	CLR  R11
; 0000 0025             count=Kd;
	MOVW R8,R6
; 0000 0026             flag_control=0;
	CLR  R10
; 0000 0027         break;
; 0000 0028         default:
_0x22:
; 0000 0029         };
_0x1E:
; 0000 002A 
; 0000 002B     }
; 0000 002C 
; 0000 002D 
; 0000 002E }
_0x1B:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R26,Y+
	RETI
; .FEND
;
;interrupt [EXT_INT1] void int1Isr(void)
; 0000 0031 {
_int1Isr:
; .FSTART _int1Isr
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0032     // ���� ���������� �� ������
; 0000 0033     if(BIT_IS_SET(PIND, 1))
	SBIS 0x10,1
	RJMP _0x23
; 0000 0034     {
; 0000 0035         // ����������� ���������� �� ����
; 0000 0036         EICRA &= ~_BV(ISC10);
	LDS  R30,106
	ANDI R30,0xFB
	STS  106,R30
; 0000 0037 
; 0000 0038         if(BIT_IS_CLEAR(PIND, 0))
	SBIC 0x10,0
	RJMP _0x24
; 0000 0039         {
; 0000 003A             count+=1;
	MOVW R30,R8
	ADIW R30,1
	RJMP _0x40
; 0000 003B         }
; 0000 003C         else    // ���� �� ������ ����� ������� �������
_0x24:
; 0000 003D         {
; 0000 003E             count-=1;
	MOVW R30,R8
	SBIW R30,1
_0x40:
	MOVW R8,R30
; 0000 003F         }
; 0000 0040     }
; 0000 0041     else
	RJMP _0x26
_0x23:
; 0000 0042     {
; 0000 0043         // ���� ���������� �� �����
; 0000 0044         // ����������� ���������� �� �����
; 0000 0045         EICRA |= _BV(ISC11) | _BV(ISC10);
	LDS  R30,106
	ORI  R30,LOW(0xC)
	STS  106,R30
; 0000 0046 
; 0000 0047         if(BIT_IS_CLEAR(PIND, 0))
	SBIC 0x10,0
	RJMP _0x27
; 0000 0048         {
; 0000 0049             count-=1;
	MOVW R30,R8
	SBIW R30,1
	RJMP _0x41
; 0000 004A         }
; 0000 004B         else        // ���� �� ������ ����� ������� �������
_0x27:
; 0000 004C         {
; 0000 004D             count+=1;
	MOVW R30,R8
	ADIW R30,1
_0x41:
	MOVW R8,R30
; 0000 004E         }
; 0000 004F     }
_0x26:
; 0000 0050 }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	RETI
; .FEND
;
;
;unsigned long readAdc(unsigned char channel)
; 0000 0054 {
_readAdc:
; .FSTART _readAdc
; 0000 0055     ADMUX = MUX | channel;
	ST   -Y,R26
;	channel -> Y+0
	LD   R30,Y
	ORI  R30,0x40
	OUT  0x7,R30
; 0000 0056     delay_us(10);
	__DELAY_USB 37
; 0000 0057     ADCSRA |= _BV(ADSC); // ������ ��������������
	SBI  0x6,6
; 0000 0058     while(BIT_IS_CLEAR(ADCSRA, ADIF));   // �������� ���������� ��������������
_0x29:
	SBIS 0x6,4
	RJMP _0x29
; 0000 0059     ADCSRA |= _BV(ADIF);   // ����� ����� ���������� ���
	SBI  0x6,4
; 0000 005A     return ADCL+(ADCH<<8);
	IN   R30,0x4
	LDI  R31,0
	MOVW R26,R30
	IN   R30,0x5
	MOV  R31,R30
	LDI  R30,0
	ADD  R30,R26
	ADC  R31,R27
	CALL __CWD1
	ADIW R28,1
	RET
; 0000 005B }
; .FEND
;#define POROG_OTT 450
;#define START_VAL 150
;#define STEP      5
;#define STEP_VAL  5
;void main(void)
; 0000 0061 {
_main:
; .FSTART _main
; 0000 0062     int field; // �������� � ������� �����
; 0000 0063     unsigned long ref; // �������
; 0000 0064     int error = 0; // ������ ����������
; 0000 0065     int control; // ������ ����������
; 0000 0066     int error_last=0; //   ������ ���������� ���������
; 0000 0067     init_segments();
	SBIW R28,6
	LDI  R30,LOW(0)
	ST   Y,R30
	STD  Y+1,R30
;	field -> R16,R17
;	ref -> Y+2
;	error -> R18,R19
;	control -> R20,R21
;	error_last -> Y+0
	__GETWRN 18,19,0
	RCALL _init_segments
; 0000 0068     #asm("sei");  //���������� ����������
	sei
; 0000 0069     EICRA |= _BV(ISC11) | _BV(ISC10) ;//�� �����
	LDS  R30,106
	ORI  R30,LOW(0xC)
	STS  106,R30
; 0000 006A     EIMSK |= _BV(INT1);
	IN   R30,0x39
	ORI  R30,2
	OUT  0x39,R30
; 0000 006B     // ������������� ������ �����/������
; 0000 006C     DDRB |= _BV(5) ;//��� ����������
	SBI  0x17,5
; 0000 006D     DDRG |= _BV(3);//����������� ����
	LDS  R30,100
	ORI  R30,8
	STS  100,R30
; 0000 006E     DDRD &= ~_BV(2); //������
	CBI  0x11,2
; 0000 006F     //���������� ������
; 0000 0070     EICRA |= _BV(ISC21) ;//| _BV(ISC20) ;
	LDS  R30,106
	ORI  R30,0x20
	STS  106,R30
; 0000 0071     EIMSK |= _BV(INT2) ;
	IN   R30,0x39
	ORI  R30,4
	OUT  0x39,R30
; 0000 0072     DDRE |= _BV(5) | _BV (4) | _BV(3) ;
	IN   R30,0x2
	ORI  R30,LOW(0x38)
	OUT  0x2,R30
; 0000 0073     PORTE  = 0;
	LDI  R30,LOW(0)
	OUT  0x3,R30
; 0000 0074     // ������������� ���
; 0000 0075     ADCSRA = _BV(ADEN) | _BV(ADPS2) | _BV(ADPS1) | _BV(ADPS0); //freq=11.0529/128=0,08635078125 MHz T=11.58 us/tick
	LDI  R30,LOW(135)
	OUT  0x6,R30
; 0000 0076     // ������������� ������� 1
; 0000 0077     // ������� ��� 8 ���
; 0000 0078     TCCR1A = _BV(COM1A1) | _BV(WGM10);
	LDI  R30,LOW(129)
	OUT  0x2F,R30
; 0000 0079     TCCR1B = _BV(WGM12) | _BV(CS10);
	LDI  R30,LOW(9)
	OUT  0x2E,R30
; 0000 007A     while(1)
_0x2C:
; 0000 007B     {
; 0000 007C         if(flag_control)
	TST  R10
	BRNE PC+2
	RJMP _0x2F
; 0000 007D         {
; 0000 007E             //����������
; 0000 007F             // ��������� � ���������� ������� � �������
; 0000 0080             // ���������� ����
; 0000 0081             field = (readAdc(1) + readAdc(1) +
; 0000 0082             readAdc(1) + readAdc(1) + readAdc(1)) / 5;
	LDI  R26,LOW(1)
	RCALL _readAdc
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	LDI  R26,LOW(1)
	RCALL _readAdc
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __ADDD12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	LDI  R26,LOW(1)
	RCALL _readAdc
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __ADDD12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	LDI  R26,LOW(1)
	RCALL _readAdc
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __ADDD12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	LDI  R26,LOW(1)
	RCALL _readAdc
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __ADDD21
	__GETD1N 0x5
	CALL __DIVD21U
	MOVW R16,R30
; 0000 0083             //field -= 512;   //����  ��������� ������� ����� 512, �� field ����� 0
; 0000 0084 
; 0000 0085             ref = readAdc(3)*182;
	LDI  R26,LOW(3)
	RCALL _readAdc
	__GETD2N 0xB6
	CALL __MULD12U
	CALL SUBOPT_0x6
; 0000 0086             ref = ref/1023+508;  // ��������� ������� � ����� ������������
	__GETD2S 2
	__GETD1N 0x3FF
	CALL __DIVD21U
	__ADDD1N 508
	CALL SUBOPT_0x6
; 0000 0087             if(field<=2) //������ �����
	__CPWRN 16,17,3
	BRGE _0x30
; 0000 0088             {
; 0000 0089                 ref=559;//������������ ������, ����� �� �������
	__GETD1N 0x22F
	CALL SUBOPT_0x6
; 0000 008A             }
; 0000 008B 
; 0000 008C             // ������ ������ ����������
; 0000 008D             error = ref - field ;
_0x30:
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	SUB  R30,R16
	SBC  R31,R17
	MOVW R18,R30
; 0000 008E             // ������ ������� ����������
; 0000 008F             control = error/Kp+(error-error_last)*Kd;
	MOVW R30,R4
	MOVW R26,R18
	CALL __DIVW21U
	MOVW R22,R30
	LD   R26,Y
	LDD  R27,Y+1
	MOVW R30,R18
	SUB  R30,R26
	SBC  R31,R27
	MOVW R26,R30
	MOVW R30,R6
	CALL __MULW12U
	ADD  R30,R22
	ADC  R31,R23
	MOVW R20,R30
; 0000 0090             error_last=error;
	__PUTWSR 18,19,0
; 0000 0091 
; 0000 0092             if(field>=290) {   control=40;}          //����������, ����� "��������� ������"
	__CPWRN 16,17,290
	BRLT _0x31
	__GETWRN 20,21,40
; 0000 0093 //            while(1)
; 0000 0094 //            {
; 0000 0095 //            if(field>=290) {   control=100;break;}          //����������, ����� "��������� ������"
; 0000 0096 //            if(field>=300) {   control=95;break;} //����������, ����� "��������� ������"
; 0000 0097 //            if(field>=310) {   control=90;break;} //����������, ����� "��������� ������"
; 0000 0098 //            if(field>=320) {   control=85;break;} //����������, ����� "��������� ������"
; 0000 0099 //            if(field>=330) {   control=80;break;} //����������, ����� "��������� ������"
; 0000 009A //            if(field>=340) {   control=75; break;} //����������, ����� "��������� ������"
; 0000 009B //            if(field>=350) {   control=70; break;} //����������, ����� "��������� ������"
; 0000 009C //            if(field>=360) {   control=65; break;} //����������, ����� "��������� ������"
; 0000 009D //            if(field>=370) {   control=60; break;} //����������, ����� "��������� ������"
; 0000 009E //            if(field>=380) {   control=55; break;} //����������, ����� "��������� ������"
; 0000 009F //            if(field>=390) {   control=50; break;} //����������, ����� "��������� ������"
; 0000 00A0 //            if(field>=400) {   control=45; break;} //����������, ����� "��������� ������"
; 0000 00A1 //            if(field>=410) {   control=40; break;} //����������, ����� "��������� ������"
; 0000 00A2 //            if(field>=420) {   control=35; break;} //����������, ����� "��������� ������"
; 0000 00A3 //            if(field>=430) {   control=30; break;} //����������, ����� "��������� ������"
; 0000 00A4 //            if(field>=440) {   control=25; break;} //����������, ����� "��������� ������"
; 0000 00A5 //            if(field>=450) {   control=20; break;} //����������, ����� "��������� ������"
; 0000 00A6 //            if(field>=460) {   control=15; break;} //����������, ����� "��������� ������"
; 0000 00A7 //            if(field>=470) {   control=10; break;} //����������, ����� "��������� ������"
; 0000 00A8 //            if(field>=480) {   control=5; } //����������, ����� "��������� ������"
; 0000 00A9 //            break;
; 0000 00AA //            }
; 0000 00AB 
; 0000 00AC //            if(field>=POROG_OTT+STEP*3) {   control=-(START_VAL+STEP_VAL*8);} //����������, ����� "��������� ������"
; 0000 00AD //            if(field>=POROG_OTT+STEP*4) {   control=-(START_VAL+STEP_VAL*7);} //����������, ����� "��������� ������"
; 0000 00AE //            if(field>=POROG_OTT+STEP*5) {   control=-(START_VAL+STEP_VAL*6);} //����������, ����� "��������� ������"
; 0000 00AF //            if(field>=POROG_OTT+STEP*6) {   control=-(START_VAL+STEP_VAL*6);} //����������, ����� "��������� ������"
; 0000 00B0 //            if(field>=POROG_OTT+STEP*7) {   control=-(START_VAL+STEP_VAL*6);} //����������, ����� "��������� ������"
; 0000 00B1 //            if(field>=POROG_OTT+STEP*8) {   control=-(START_VAL+STEP_VAL*6);} //����������, ����� "��������� ������"
; 0000 00B2 //            if(field>=POROG_OTT+STEP*9) {   control=-(START_VAL+STEP_VAL*6);} //����������, ����� "��������� ������"
; 0000 00B3 //            if(field>=POROG_OTT+STEP*10){   control=-(START_VAL+STEP_VAL*6);} //����������, ����� "��������� ������"
; 0000 00B4 
; 0000 00B5 
; 0000 00B6             // ����������� ������� ����������
; 0000 00B7             if(control > 255)
_0x31:
	__CPWRN 20,21,256
	BRLT _0x32
; 0000 00B8             {
; 0000 00B9                 control = 255;
	__GETWRN 20,21,255
; 0000 00BA             }
; 0000 00BB             if(control < -255)
_0x32:
	__CPWRN 20,21,-255
	BRGE _0x33
; 0000 00BC             {
; 0000 00BD                 control = -255;
	__GETWRN 20,21,-255
; 0000 00BE             }
; 0000 00BF 
; 0000 00C0             // ��������� ������� ����������
; 0000 00C1             if(control >= 0)
_0x33:
	TST  R21
	BRMI _0x34
; 0000 00C2             {
; 0000 00C3                 PORTG &= ~_BV(3); //��������� �������������� ����
	LDS  R30,101
	ANDI R30,0XF7
	STS  101,R30
; 0000 00C4                 OCR1AL = (unsigned char)control;
	OUT  0x2A,R20
; 0000 00C5             }
; 0000 00C6             else
	RJMP _0x35
_0x34:
; 0000 00C7             {
; 0000 00C8                 PORTG |= _BV(3); //��������� �������������� ����
	LDS  R30,101
	ORI  R30,8
	STS  101,R30
; 0000 00C9                 OCR1AL = (unsigned char)(-control);
	MOV  R30,R20
	NEG  R30
	OUT  0x2A,R30
; 0000 00CA             }
_0x35:
; 0000 00CB             indic_int( field );
	MOVW R26,R16
	RCALL _indic_int
; 0000 00CC         }else //��������� �����������
	RJMP _0x36
_0x2F:
; 0000 00CD         {
; 0000 00CE             if(f_Kp){  Kp=count; }else{ Kd=count; };
	TST  R13
	BREQ _0x37
	MOVW R4,R8
	RJMP _0x38
_0x37:
	MOVW R6,R8
_0x38:
; 0000 00CF             BitClr(PORTE,4);
	CBI  0x3,4
; 0000 00D0             BitClr(PORTE,5);
	CBI  0x3,5
; 0000 00D1             BitSet(PORTE,(f_Kp ?  5 : 4 ));
	IN   R1,3
	TST  R13
	BREQ _0x39
	LDI  R30,LOW(5)
	RJMP _0x3A
_0x39:
	LDI  R30,LOW(4)
_0x3A:
	LDI  R26,LOW(1)
	CALL __LSLB12
	OR   R30,R1
	OUT  0x3,R30
; 0000 00D2             indic_uint( f_Kp ? Kp : Kd );
	MOV  R30,R13
	LDI  R31,0
	SBIW R30,0
	BREQ _0x3C
	MOVW R30,R4
	RJMP _0x3D
_0x3C:
	MOVW R30,R6
_0x3D:
	MOVW R26,R30
	RCALL _indic_uint
; 0000 00D3         }
_0x36:
; 0000 00D4     }
	RJMP _0x2C
; 0000 00D5 }
_0x3F:
	RJMP _0x3F
; .FEND

	.CSEG
_abs:
; .FSTART _abs
	ST   -Y,R27
	ST   -Y,R26
    ld   r30,y+
    ld   r31,y+
    sbiw r30,0
    brpl __abs0
    com  r30
    com  r31
    adiw r30,1
__abs0:
    ret
; .FEND

	.DSEG

	.CSEG

	.CSEG

	.CSEG

	.CSEG

	.DSEG
_segments:
	.BYTE 0xC
__seed_G100:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x0:
	ST   -Y,R27
	ST   -Y,R26
	CALL __SAVELOCR6
	LDI  R17,1
	__GETWRN 18,19,0
	__GETWRS 20,21,6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x1:
	SBIW R28,2
	ST   -Y,R21
	ST   -Y,R20
	MOV  R26,R17
	CALL _Digit
	LDI  R31,0
	ST   Y,R30
	STD  Y+1,R31
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2:
	IN   R1,27
	MOV  R30,R17
	SUBI R30,LOW(1)
	LDI  R26,LOW(1)
	CALL __LSLB12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3:
	OR   R30,R1
	OUT  0x1B,R30
	__DELAY_USB 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x4:
	__GETWRN 18,19,1
	LD   R30,Y
	LDD  R31,Y+1
	SUBI R30,LOW(-_segments)
	SBCI R31,HIGH(-_segments)
	LD   R30,Z
	OUT  0x15,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x5:
	IN   R1,27
	MOV  R30,R17
	LDI  R26,LOW(1)
	CALL __LSLB12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6:
	__PUTD1S 2
	RET


	.CSEG
__ADDD12:
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	ADC  R23,R25
	RET

__ADDD21:
	ADD  R26,R30
	ADC  R27,R31
	ADC  R24,R22
	ADC  R25,R23
	RET

__LSLB12:
	TST  R30
	MOV  R0,R30
	MOV  R30,R26
	BREQ __LSLB12R
__LSLB12L:
	LSL  R30
	DEC  R0
	BRNE __LSLB12L
__LSLB12R:
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__MULW12U:
	MUL  R31,R26
	MOV  R31,R0
	MUL  R30,R27
	ADD  R31,R0
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	RET

__MULD12U:
	MUL  R23,R26
	MOV  R23,R0
	MUL  R22,R27
	ADD  R23,R0
	MUL  R31,R24
	ADD  R23,R0
	MUL  R30,R25
	ADD  R23,R0
	MUL  R22,R26
	MOV  R22,R0
	ADD  R23,R1
	MUL  R31,R27
	ADD  R22,R0
	ADC  R23,R1
	MUL  R30,R24
	ADD  R22,R0
	ADC  R23,R1
	CLR  R24
	MUL  R31,R26
	MOV  R31,R0
	ADD  R22,R1
	ADC  R23,R24
	MUL  R30,R27
	ADD  R31,R0
	ADC  R22,R1
	ADC  R23,R24
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	ADC  R22,R24
	ADC  R23,R24
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__DIVD21U:
	PUSH R19
	PUSH R20
	PUSH R21
	CLR  R0
	CLR  R1
	CLR  R20
	CLR  R21
	LDI  R19,32
__DIVD21U1:
	LSL  R26
	ROL  R27
	ROL  R24
	ROL  R25
	ROL  R0
	ROL  R1
	ROL  R20
	ROL  R21
	SUB  R0,R30
	SBC  R1,R31
	SBC  R20,R22
	SBC  R21,R23
	BRCC __DIVD21U2
	ADD  R0,R30
	ADC  R1,R31
	ADC  R20,R22
	ADC  R21,R23
	RJMP __DIVD21U3
__DIVD21U2:
	SBR  R26,1
__DIVD21U3:
	DEC  R19
	BRNE __DIVD21U1
	MOVW R30,R26
	MOVW R22,R24
	MOVW R26,R0
	MOVW R24,R20
	POP  R21
	POP  R20
	POP  R19
	RET

__MODW21U:
	RCALL __DIVW21U
	MOVW R30,R26
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE: