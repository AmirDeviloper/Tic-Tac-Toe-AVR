
;CodeVisionAVR C Compiler V3.14 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega64
;Program type           : Application
;Clock frequency        : 1.000000 MHz
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
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega64
	#pragma AVRPART MEMORY PROG_FLASH 65536
	#pragma AVRPART MEMORY EEPROM 2048
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
	.DEF _player_turn=R4
	.DEF _player_turn_msb=R5
	.DEF _is_started=R7
	.DEF __lcd_x=R6
	.DEF __lcd_y=R9
	.DEF __lcd_maxx=R8

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
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
	JMP  0x00
	JMP  0x00
	JMP  0x00

_tbl10_G101:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G101:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x1,0x0,0x0,0x0

_0x0:
	.DB  0x47,0x72,0x65,0x65,0x6E,0x27,0x73,0x20
	.DB  0x54,0x75,0x72,0x6E,0x0,0x52,0x65,0x64
	.DB  0x27,0x73,0x20,0x54,0x75,0x72,0x6E,0x0
	.DB  0x54,0x72,0x79,0x20,0x41,0x67,0x61,0x69
	.DB  0x6E,0x0,0x50,0x72,0x65,0x73,0x73,0x20
	.DB  0x30,0x20,0x54,0x6F,0x20,0x53,0x74,0x61
	.DB  0x72,0x74,0x0,0x47,0x72,0x65,0x65,0x6E
	.DB  0x20,0x57,0x69,0x6E,0x0,0x52,0x65,0x64
	.DB  0x20,0x20,0x57,0x69,0x6E,0x0,0x44,0x52
	.DB  0x41,0x57,0x21,0x0
_0x2000003:
	.DB  0x80,0xC0

__GLOBAL_INI_TBL:
	.DW  0x04
	.DW  0x04
	.DW  __REG_VARS*2

	.DW  0x0D
	.DW  _0x1D
	.DW  _0x0*2

	.DW  0x0B
	.DW  _0x1D+13
	.DW  _0x0*2+13

	.DW  0x0D
	.DW  _0x1D+24
	.DW  _0x0*2

	.DW  0x0A
	.DW  _0x1D+37
	.DW  _0x0*2+24

	.DW  0x0B
	.DW  _0x1D+47
	.DW  _0x0*2+13

	.DW  0x0D
	.DW  _0x1D+58
	.DW  _0x0*2

	.DW  0x11
	.DW  _0x48
	.DW  _0x0*2+34

	.DW  0x0A
	.DW  _0x48+17
	.DW  _0x0*2+51

	.DW  0x09
	.DW  _0x48+27
	.DW  _0x0*2+61

	.DW  0x06
	.DW  _0x48+36
	.DW  _0x0*2+70

	.DW  0x02
	.DW  __base_y_G100
	.DW  _0x2000003*2

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
;#include <mega64.h>
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
;#include <alcd.h>
;#include <delay.h>
;#include <stdio.h>
;#include <stdbool.h>
;
;int player_turn = 1;
;
;const int player_green = 1;
;const int player_red = -1;
;
;const int red_color_bit1 = 1;
;const int red_color_bit2 = 0;
;
;const int green_color_bit1 = 0;
;const int green_color_bit2 = 1;
;
;bool is_started = false;
;
;int game_board [] = { 0, 0, 0,
;                      0, 0, 0,
;                      0, 0, 0 };
;
;
;
;bool check_win(int player) {
; 0000 001A _Bool check_win(int player) {

	.CSEG
_check_win:
; .FSTART _check_win
; 0000 001B     // Check rows
; 0000 001C     int i = 0;
; 0000 001D     for (i = 0; i < 3; i++)
	ST   -Y,R27
	ST   -Y,R26
	CALL SUBOPT_0x0
;	player -> Y+2
;	i -> R16,R17
_0x4:
	__CPWRN 16,17,3
	BRGE _0x5
; 0000 001E     {
; 0000 001F         if (game_board[i * 3] == player &&
; 0000 0020              game_board[i * 3 + 1] == player &&
; 0000 0021               game_board[i * 3 + 2] == player)
	MOVW R30,R16
	LDI  R26,LOW(3)
	LDI  R27,HIGH(3)
	CALL __MULW12
	MOVW R22,R30
	MOVW R0,R30
	CALL SUBOPT_0x1
	BRNE _0x7
	MOVW R26,R0
	LSL  R26
	ROL  R27
	__ADDW2MN _game_board,2
	CALL SUBOPT_0x2
	BRNE _0x7
	MOVW R26,R22
	LSL  R26
	ROL  R27
	__ADDW2MN _game_board,4
	CALL SUBOPT_0x2
	BREQ _0x8
_0x7:
	RJMP _0x6
_0x8:
; 0000 0022         {
; 0000 0023             return true;
	LDI  R30,LOW(1)
	RJMP _0x2080004
; 0000 0024         }
; 0000 0025     }
_0x6:
	__ADDWRN 16,17,1
	RJMP _0x4
_0x5:
; 0000 0026 
; 0000 0027     // Check columns
; 0000 0028     for (i = 0; i < 3; i++)
	__GETWRN 16,17,0
_0xA:
	__CPWRN 16,17,3
	BRGE _0xB
; 0000 0029     {
; 0000 002A         if (game_board[i] == player &&
; 0000 002B              game_board[i+3] == player &&
; 0000 002C               game_board[i+6] == player)
	MOVW R30,R16
	CALL SUBOPT_0x1
	BRNE _0xD
	MOVW R26,R16
	LSL  R26
	ROL  R27
	__ADDW2MN _game_board,6
	CALL SUBOPT_0x2
	BRNE _0xD
	MOVW R26,R16
	LSL  R26
	ROL  R27
	__ADDW2MN _game_board,12
	CALL SUBOPT_0x2
	BREQ _0xE
_0xD:
	RJMP _0xC
_0xE:
; 0000 002D               {
; 0000 002E                     return true;
	LDI  R30,LOW(1)
	RJMP _0x2080004
; 0000 002F               }
; 0000 0030     }
_0xC:
	__ADDWRN 16,17,1
	RJMP _0xA
_0xB:
; 0000 0031 
; 0000 0032     // Check diagonals
; 0000 0033     if ((game_board[0] == player &&
; 0000 0034          game_board[4] == player &&
; 0000 0035          game_board[8] == player)
; 0000 0036          ||
; 0000 0037         (game_board[2] == player &&
; 0000 0038          game_board[4] == player &&
; 0000 0039          game_board[6] == player))
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	LDS  R26,_game_board
	LDS  R27,_game_board+1
	CP   R30,R26
	CPC  R31,R27
	BRNE _0x10
	CALL SUBOPT_0x3
	BRNE _0x10
	__GETW2MN _game_board,16
	CALL SUBOPT_0x4
	BREQ _0x12
_0x10:
	__GETW2MN _game_board,4
	CALL SUBOPT_0x4
	BRNE _0x13
	CALL SUBOPT_0x3
	BRNE _0x13
	__GETW2MN _game_board,12
	CALL SUBOPT_0x4
	BREQ _0x12
_0x13:
	RJMP _0xF
_0x12:
; 0000 003A          {
; 0000 003B             return true;
	LDI  R30,LOW(1)
	RJMP _0x2080004
; 0000 003C          }
; 0000 003D 
; 0000 003E     return false;
_0xF:
	LDI  R30,LOW(0)
_0x2080004:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,4
	RET
; 0000 003F }
; .FEND
;
;bool is_draw()
; 0000 0042 {
_is_draw:
; .FSTART _is_draw
; 0000 0043     int i = 0;
; 0000 0044     for (i = 0; i < 9; i++)
	CALL SUBOPT_0x0
;	i -> R16,R17
_0x17:
	__CPWRN 16,17,9
	BRGE _0x18
; 0000 0045     {
; 0000 0046         if (game_board[i] == 0)
	MOVW R30,R16
	CALL SUBOPT_0x5
	BRNE _0x19
; 0000 0047         {
; 0000 0048             return false;
	LDI  R30,LOW(0)
	RJMP _0x2080003
; 0000 0049         }
; 0000 004A     }
_0x19:
	__ADDWRN 16,17,1
	RJMP _0x17
_0x18:
; 0000 004B 
; 0000 004C     return true;
	LDI  R30,LOW(1)
_0x2080003:
	LD   R16,Y+
	LD   R17,Y+
	RET
; 0000 004D }
; .FEND
;
;void work(int key)
; 0000 0050 {
_work:
; .FSTART _work
; 0000 0051     if(!is_started && key == 0)
	ST   -Y,R27
	ST   -Y,R26
;	key -> Y+0
	TST  R7
	BRNE _0x1B
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,0
	BREQ _0x1C
_0x1B:
	RJMP _0x1A
_0x1C:
; 0000 0052     {
; 0000 0053         lcd_clear();
	RCALL _lcd_clear
; 0000 0054         lcd_puts("Green's Turn");
	__POINTW2MN _0x1D,0
	CALL SUBOPT_0x6
; 0000 0055         delay_ms(2000);
; 0000 0056         is_started = true;
	LDI  R30,LOW(1)
	MOV  R7,R30
; 0000 0057     }
; 0000 0058     else if (is_started && key != 0)
	RJMP _0x1E
_0x1A:
	TST  R7
	BREQ _0x20
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,0
	BRNE _0x21
_0x20:
	RJMP _0x1F
_0x21:
; 0000 0059     {
; 0000 005A         int index = key - 1;
; 0000 005B 
; 0000 005C         if(index >= 0 && game_board[index] == 0)
	SBIW R28,2
;	key -> Y+2
;	index -> Y+0
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	SBIW R30,1
	ST   Y,R30
	STD  Y+1,R31
	LDD  R26,Y+1
	TST  R26
	BRMI _0x23
	CALL SUBOPT_0x7
	BREQ _0x24
_0x23:
	RJMP _0x22
_0x24:
; 0000 005D         {
; 0000 005E             game_board[index] = player_turn;
	CALL SUBOPT_0x8
	ADD  R30,R26
	ADC  R31,R27
	ST   Z,R4
	STD  Z+1,R5
; 0000 005F 
; 0000 0060             player_turn *= -1;
	MOVW R30,R4
	LDI  R26,LOW(65535)
	LDI  R27,HIGH(65535)
	CALL __MULW12
	MOVW R4,R30
; 0000 0061 
; 0000 0062             if(player_turn == player_red)
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	CP   R30,R4
	CPC  R31,R5
	BRNE _0x25
; 0000 0063             {
; 0000 0064                 lcd_clear();
	RCALL _lcd_clear
; 0000 0065                 lcd_puts("Red's Turn");
	__POINTW2MN _0x1D,13
	RJMP _0x76
; 0000 0066             }
; 0000 0067             else
_0x25:
; 0000 0068             {
; 0000 0069                 lcd_clear();
	RCALL _lcd_clear
; 0000 006A                 lcd_puts("Green's Turn");
	__POINTW2MN _0x1D,24
_0x76:
	RCALL _lcd_puts
; 0000 006B             }
; 0000 006C             delay_ms(50);
	LDI  R26,LOW(50)
	LDI  R27,0
	CALL _delay_ms
; 0000 006D 
; 0000 006E         }
; 0000 006F         else
	RJMP _0x27
_0x22:
; 0000 0070         {
; 0000 0071             lcd_clear();
	RCALL _lcd_clear
; 0000 0072             lcd_puts("Try Again");
	__POINTW2MN _0x1D,37
	CALL SUBOPT_0x6
; 0000 0073             delay_ms(2000);
; 0000 0074             lcd_clear();
	RCALL _lcd_clear
; 0000 0075 
; 0000 0076             if(player_turn == player_red)
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	CP   R30,R4
	CPC  R31,R5
	BRNE _0x28
; 0000 0077             {
; 0000 0078                 lcd_clear();
	RCALL _lcd_clear
; 0000 0079                 lcd_puts("Red's Turn");
	__POINTW2MN _0x1D,47
	RJMP _0x77
; 0000 007A             }
; 0000 007B             else
_0x28:
; 0000 007C             {
; 0000 007D                 lcd_clear();
	RCALL _lcd_clear
; 0000 007E                 lcd_puts("Green's Turn");
	__POINTW2MN _0x1D,58
_0x77:
	RCALL _lcd_puts
; 0000 007F             }
; 0000 0080         }
_0x27:
; 0000 0081 
; 0000 0082     }
	ADIW R28,2
; 0000 0083 }
_0x1F:
_0x1E:
	RJMP _0x2080002
; .FEND

	.DSEG
_0x1D:
	.BYTE 0x47
;
;
;void keyboard(void)
; 0000 0087 {

	.CSEG
_keyboard:
; .FSTART _keyboard
; 0000 0088     // ---- ROW1 ----
; 0000 0089     PORTE.4 = 0;
	CBI  0x3,4
; 0000 008A     //delay_ms(1);
; 0000 008B     if(PINE.0==0) work(1);
	SBIC 0x1,0
	RJMP _0x2C
	LDI  R26,LOW(1)
	LDI  R27,0
	RCALL _work
; 0000 008C     if(PINE.1==0) work(4);
_0x2C:
	SBIC 0x1,1
	RJMP _0x2D
	LDI  R26,LOW(4)
	LDI  R27,0
	RCALL _work
; 0000 008D     if(PINE.2==0) work(7);
_0x2D:
	SBIC 0x1,2
	RJMP _0x2E
	LDI  R26,LOW(7)
	LDI  R27,0
	RCALL _work
; 0000 008E     PORTE.4=1;
_0x2E:
	SBI  0x3,4
; 0000 008F     // ---- ROW2 ----
; 0000 0090     PORTE.5 = 0;
	CBI  0x3,5
; 0000 0091     //delay_ms(1);
; 0000 0092     if(PINE.0==0) work(2);
	SBIC 0x1,0
	RJMP _0x33
	LDI  R26,LOW(2)
	LDI  R27,0
	RCALL _work
; 0000 0093     if(PINE.1==0) work(5);
_0x33:
	SBIC 0x1,1
	RJMP _0x34
	LDI  R26,LOW(5)
	LDI  R27,0
	RCALL _work
; 0000 0094     if(PINE.2==0) work(8);
_0x34:
	SBIC 0x1,2
	RJMP _0x35
	LDI  R26,LOW(8)
	LDI  R27,0
	RCALL _work
; 0000 0095     if(PINE.3==0) work(0);
_0x35:
	SBIC 0x1,3
	RJMP _0x36
	LDI  R26,LOW(0)
	LDI  R27,0
	RCALL _work
; 0000 0096     PORTE.5 = 1;
_0x36:
	SBI  0x3,5
; 0000 0097     // ---- ROW3 ----
; 0000 0098     PORTE.6 = 0;
	CBI  0x3,6
; 0000 0099     //delay_ms(1);
; 0000 009A     if(PINE.0==0) work(3);
	SBIC 0x1,0
	RJMP _0x3B
	LDI  R26,LOW(3)
	LDI  R27,0
	RCALL _work
; 0000 009B     if(PINE.1==0) work(6);
_0x3B:
	SBIC 0x1,1
	RJMP _0x3C
	LDI  R26,LOW(6)
	LDI  R27,0
	RCALL _work
; 0000 009C     if(PINE.2==0) work(9);
_0x3C:
	SBIC 0x1,2
	RJMP _0x3D
	LDI  R26,LOW(9)
	LDI  R27,0
	RCALL _work
; 0000 009D     PORTE.6 = 1;
_0x3D:
	SBI  0x3,6
; 0000 009E }
	RET
; .FEND
;
;int get_bit1_value(int index)
; 0000 00A1 {
_get_bit1_value:
; .FSTART _get_bit1_value
; 0000 00A2     if(game_board[index] == 0)
	ST   -Y,R27
	ST   -Y,R26
;	index -> Y+0
	CALL SUBOPT_0x7
	BRNE _0x40
; 0000 00A3         return 0;
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x2080002
; 0000 00A4 
; 0000 00A5     return game_board[index] == player_red ?
_0x40:
; 0000 00A6              red_color_bit1 : green_color_bit1;
	CALL SUBOPT_0x8
	CALL SUBOPT_0x9
	BRNE _0x41
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP _0x42
_0x41:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
_0x42:
	RJMP _0x2080002
; 0000 00A7 }
; .FEND
;
;int get_bit2_value(int index)
; 0000 00AA {
_get_bit2_value:
; .FSTART _get_bit2_value
; 0000 00AB     if(game_board[index] == 0)
	ST   -Y,R27
	ST   -Y,R26
;	index -> Y+0
	CALL SUBOPT_0x7
	BRNE _0x44
; 0000 00AC         return 0;
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x2080002
; 0000 00AD 
; 0000 00AE     return game_board[index] == player_red ?
_0x44:
; 0000 00AF              red_color_bit2 : green_color_bit2;
	CALL SUBOPT_0x8
	CALL SUBOPT_0x9
	BRNE _0x45
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x46
_0x45:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
_0x46:
	RJMP _0x2080002
; 0000 00B0 }
; .FEND
;
;void main(void)
; 0000 00B3 {
_main:
; .FSTART _main
; 0000 00B4     PORTD=0x00;
	LDI  R30,LOW(0)
	OUT  0x12,R30
; 0000 00B5     DDRD=0xF7;
	LDI  R30,LOW(247)
	OUT  0x11,R30
; 0000 00B6     PORTE=0xFF;
	LDI  R30,LOW(255)
	OUT  0x3,R30
; 0000 00B7     DDRE=0xF0;
	LDI  R30,LOW(240)
	OUT  0x2,R30
; 0000 00B8 
; 0000 00B9     DDRB = 0XFF;
	LDI  R30,LOW(255)
	OUT  0x17,R30
; 0000 00BA     DDRA = 0XFF;
	OUT  0x1A,R30
; 0000 00BB     DDRC = 0XFF;
	OUT  0x14,R30
; 0000 00BC 
; 0000 00BD     PORTA = 0XFF;
	OUT  0x1B,R30
; 0000 00BE     PORTB = 0XFF;
	OUT  0x18,R30
; 0000 00BF     PORTC = 0XFF;
	OUT  0x15,R30
; 0000 00C0 
; 0000 00C1     lcd_init(16);
	LDI  R26,LOW(16)
	RCALL _lcd_init
; 0000 00C2     lcd_clear();
	RCALL _lcd_clear
; 0000 00C3     lcd_puts("Press 0 To Start");
	__POINTW2MN _0x48,0
	RCALL _lcd_puts
; 0000 00C4 
; 0000 00C5     while (1)
_0x49:
; 0000 00C6     {
; 0000 00C7         keyboard();
	RCALL _keyboard
; 0000 00C8 
; 0000 00C9         PORTA.0 = get_bit1_value(0);
	LDI  R26,LOW(0)
	CALL SUBOPT_0xA
	BRNE _0x4C
	CBI  0x1B,0
	RJMP _0x4D
_0x4C:
	SBI  0x1B,0
_0x4D:
; 0000 00CA         PORTA.1 = get_bit2_value(0);
	LDI  R26,LOW(0)
	CALL SUBOPT_0xB
	BRNE _0x4E
	CBI  0x1B,1
	RJMP _0x4F
_0x4E:
	SBI  0x1B,1
_0x4F:
; 0000 00CB 
; 0000 00CC         PORTA.2 = get_bit1_value(1);
	LDI  R26,LOW(1)
	CALL SUBOPT_0xA
	BRNE _0x50
	CBI  0x1B,2
	RJMP _0x51
_0x50:
	SBI  0x1B,2
_0x51:
; 0000 00CD         PORTA.3 = get_bit2_value(1);
	LDI  R26,LOW(1)
	CALL SUBOPT_0xB
	BRNE _0x52
	CBI  0x1B,3
	RJMP _0x53
_0x52:
	SBI  0x1B,3
_0x53:
; 0000 00CE 
; 0000 00CF         PORTA.4 = get_bit1_value(2);
	LDI  R26,LOW(2)
	CALL SUBOPT_0xA
	BRNE _0x54
	CBI  0x1B,4
	RJMP _0x55
_0x54:
	SBI  0x1B,4
_0x55:
; 0000 00D0         PORTA.5 = get_bit2_value(2);
	LDI  R26,LOW(2)
	CALL SUBOPT_0xB
	BRNE _0x56
	CBI  0x1B,5
	RJMP _0x57
_0x56:
	SBI  0x1B,5
_0x57:
; 0000 00D1 
; 0000 00D2         PORTA.6 = get_bit1_value(3);
	LDI  R26,LOW(3)
	CALL SUBOPT_0xA
	BRNE _0x58
	CBI  0x1B,6
	RJMP _0x59
_0x58:
	SBI  0x1B,6
_0x59:
; 0000 00D3         PORTA.7 = get_bit2_value(3);
	LDI  R26,LOW(3)
	CALL SUBOPT_0xB
	BRNE _0x5A
	CBI  0x1B,7
	RJMP _0x5B
_0x5A:
	SBI  0x1B,7
_0x5B:
; 0000 00D4 
; 0000 00D5         PORTB.0 = get_bit1_value(4);
	LDI  R26,LOW(4)
	CALL SUBOPT_0xA
	BRNE _0x5C
	CBI  0x18,0
	RJMP _0x5D
_0x5C:
	SBI  0x18,0
_0x5D:
; 0000 00D6         PORTB.1 = get_bit2_value(4);
	LDI  R26,LOW(4)
	CALL SUBOPT_0xB
	BRNE _0x5E
	CBI  0x18,1
	RJMP _0x5F
_0x5E:
	SBI  0x18,1
_0x5F:
; 0000 00D7 
; 0000 00D8         PORTB.2 = get_bit1_value(5);
	LDI  R26,LOW(5)
	CALL SUBOPT_0xA
	BRNE _0x60
	CBI  0x18,2
	RJMP _0x61
_0x60:
	SBI  0x18,2
_0x61:
; 0000 00D9         PORTB.3 = get_bit2_value(5);
	LDI  R26,LOW(5)
	CALL SUBOPT_0xB
	BRNE _0x62
	CBI  0x18,3
	RJMP _0x63
_0x62:
	SBI  0x18,3
_0x63:
; 0000 00DA 
; 0000 00DB         PORTB.4 = get_bit1_value(6);
	LDI  R26,LOW(6)
	CALL SUBOPT_0xA
	BRNE _0x64
	CBI  0x18,4
	RJMP _0x65
_0x64:
	SBI  0x18,4
_0x65:
; 0000 00DC         PORTB.5 = get_bit2_value(6);
	LDI  R26,LOW(6)
	CALL SUBOPT_0xB
	BRNE _0x66
	CBI  0x18,5
	RJMP _0x67
_0x66:
	SBI  0x18,5
_0x67:
; 0000 00DD 
; 0000 00DE         PORTB.6 = get_bit1_value(7);
	LDI  R26,LOW(7)
	CALL SUBOPT_0xA
	BRNE _0x68
	CBI  0x18,6
	RJMP _0x69
_0x68:
	SBI  0x18,6
_0x69:
; 0000 00DF         PORTB.7 = get_bit2_value(7);
	LDI  R26,LOW(7)
	CALL SUBOPT_0xB
	BRNE _0x6A
	CBI  0x18,7
	RJMP _0x6B
_0x6A:
	SBI  0x18,7
_0x6B:
; 0000 00E0 
; 0000 00E1         PORTC.0 = get_bit1_value(8);
	LDI  R26,LOW(8)
	CALL SUBOPT_0xA
	BRNE _0x6C
	CBI  0x15,0
	RJMP _0x6D
_0x6C:
	SBI  0x15,0
_0x6D:
; 0000 00E2         PORTC.1 = get_bit2_value(8);
	LDI  R26,LOW(8)
	CALL SUBOPT_0xB
	BRNE _0x6E
	CBI  0x15,1
	RJMP _0x6F
_0x6E:
	SBI  0x15,1
_0x6F:
; 0000 00E3 
; 0000 00E4 
; 0000 00E5 
; 0000 00E6         if(check_win(player_green))
	LDI  R26,LOW(1)
	LDI  R27,HIGH(1)
	RCALL _check_win
	CPI  R30,0
	BREQ _0x70
; 0000 00E7         {
; 0000 00E8             lcd_clear();
	RCALL _lcd_clear
; 0000 00E9             lcd_puts("Green Win");
	__POINTW2MN _0x48,17
	RJMP _0x78
; 0000 00EA             delay_ms(999999999);
; 0000 00EB         }
; 0000 00EC         else if (check_win(player_red))
_0x70:
	LDI  R26,LOW(65535)
	LDI  R27,HIGH(65535)
	RCALL _check_win
	CPI  R30,0
	BREQ _0x72
; 0000 00ED         {
; 0000 00EE             lcd_clear();
	RCALL _lcd_clear
; 0000 00EF             lcd_puts("Red  Win");
	__POINTW2MN _0x48,27
	RJMP _0x78
; 0000 00F0             delay_ms(999999999);
; 0000 00F1         }
; 0000 00F2         else if (is_draw())
_0x72:
	RCALL _is_draw
	CPI  R30,0
	BREQ _0x74
; 0000 00F3         {
; 0000 00F4             lcd_clear();
	RCALL _lcd_clear
; 0000 00F5             lcd_puts("DRAW!");
	__POINTW2MN _0x48,36
_0x78:
	RCALL _lcd_puts
; 0000 00F6             delay_ms(999999999);
	LDI  R26,LOW(51711)
	LDI  R27,HIGH(51711)
	CALL _delay_ms
; 0000 00F7         }
; 0000 00F8 
; 0000 00F9         delay_ms(250);
_0x74:
	LDI  R26,LOW(250)
	LDI  R27,0
	CALL _delay_ms
; 0000 00FA     }
	RJMP _0x49
; 0000 00FB }
_0x75:
	RJMP _0x75
; .FEND

	.DSEG
_0x48:
	.BYTE 0x2A
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

	.DSEG

	.CSEG
__lcd_write_nibble_G100:
; .FSTART __lcd_write_nibble_G100
	ST   -Y,R26
	IN   R30,0x12
	ANDI R30,LOW(0xF)
	MOV  R26,R30
	LD   R30,Y
	ANDI R30,LOW(0xF0)
	OR   R30,R26
	OUT  0x12,R30
	__DELAY_USB 2
	SBI  0x12,2
	__DELAY_USB 2
	CBI  0x12,2
	__DELAY_USB 2
	RJMP _0x2080001
; .FEND
__lcd_write_data:
; .FSTART __lcd_write_data
	ST   -Y,R26
	LD   R26,Y
	RCALL __lcd_write_nibble_G100
    ld    r30,y
    swap  r30
    st    y,r30
	LD   R26,Y
	RCALL __lcd_write_nibble_G100
	__DELAY_USB 17
	RJMP _0x2080001
; .FEND
_lcd_gotoxy:
; .FSTART _lcd_gotoxy
	ST   -Y,R26
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G100)
	SBCI R31,HIGH(-__base_y_G100)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R26,R30
	RCALL __lcd_write_data
	LDD  R6,Y+1
	LDD  R9,Y+0
_0x2080002:
	ADIW R28,2
	RET
; .FEND
_lcd_clear:
; .FSTART _lcd_clear
	LDI  R26,LOW(2)
	CALL SUBOPT_0xC
	LDI  R26,LOW(12)
	RCALL __lcd_write_data
	LDI  R26,LOW(1)
	CALL SUBOPT_0xC
	LDI  R30,LOW(0)
	MOV  R9,R30
	MOV  R6,R30
	RET
; .FEND
_lcd_putchar:
; .FSTART _lcd_putchar
	ST   -Y,R26
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ _0x2000005
	CP   R6,R8
	BRLO _0x2000004
_0x2000005:
	LDI  R30,LOW(0)
	ST   -Y,R30
	INC  R9
	MOV  R26,R9
	RCALL _lcd_gotoxy
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BRNE _0x2000007
	RJMP _0x2080001
_0x2000007:
_0x2000004:
	INC  R6
	SBI  0x12,0
	LD   R26,Y
	RCALL __lcd_write_data
	CBI  0x12,0
	RJMP _0x2080001
; .FEND
_lcd_puts:
; .FSTART _lcd_puts
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
_0x2000008:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x200000A
	MOV  R26,R17
	RCALL _lcd_putchar
	RJMP _0x2000008
_0x200000A:
	LDD  R17,Y+0
	ADIW R28,3
	RET
; .FEND
_lcd_init:
; .FSTART _lcd_init
	ST   -Y,R26
	IN   R30,0x11
	ORI  R30,LOW(0xF0)
	OUT  0x11,R30
	SBI  0x11,2
	SBI  0x11,0
	SBI  0x11,1
	CBI  0x12,2
	CBI  0x12,0
	CBI  0x12,1
	LDD  R8,Y+0
	LD   R30,Y
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G100,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G100,3
	LDI  R26,LOW(20)
	LDI  R27,0
	CALL _delay_ms
	CALL SUBOPT_0xD
	CALL SUBOPT_0xD
	CALL SUBOPT_0xD
	LDI  R26,LOW(32)
	RCALL __lcd_write_nibble_G100
	__DELAY_USB 33
	LDI  R26,LOW(40)
	RCALL __lcd_write_data
	LDI  R26,LOW(4)
	RCALL __lcd_write_data
	LDI  R26,LOW(133)
	RCALL __lcd_write_data
	LDI  R26,LOW(6)
	RCALL __lcd_write_data
	RCALL _lcd_clear
_0x2080001:
	ADIW R28,1
	RET
; .FEND
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

	.CSEG

	.CSEG

	.CSEG

	.DSEG
_game_board:
	.BYTE 0x12
__base_y_G100:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x0:
	ST   -Y,R17
	ST   -Y,R16
	__GETWRN 16,17,0
	__GETWRN 16,17,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x1:
	LDI  R26,LOW(_game_board)
	LDI  R27,HIGH(_game_board)
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	CALL __GETW1P
	MOVW R26,R30
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	CP   R30,R26
	CPC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x2:
	CALL __GETW1P
	MOVW R26,R30
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	CP   R30,R26
	CPC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3:
	__GETW2MN _game_board,8
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	CP   R30,R26
	CPC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4:
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	CP   R30,R26
	CPC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x5:
	LDI  R26,LOW(_game_board)
	LDI  R27,HIGH(_game_board)
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	CALL __GETW1P
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6:
	CALL _lcd_puts
	LDI  R26,LOW(2000)
	LDI  R27,HIGH(2000)
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7:
	LD   R30,Y
	LDD  R31,Y+1
	RJMP SUBOPT_0x5

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x8:
	LD   R30,Y
	LDD  R31,Y+1
	LDI  R26,LOW(_game_board)
	LDI  R27,HIGH(_game_board)
	LSL  R30
	ROL  R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x9:
	ADD  R26,R30
	ADC  R27,R31
	CALL __GETW1P
	CPI  R30,LOW(0xFFFF)
	LDI  R26,HIGH(0xFFFF)
	CPC  R31,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0xA:
	LDI  R27,0
	CALL _get_bit1_value
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0xB:
	LDI  R27,0
	CALL _get_bit2_value
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xC:
	CALL __lcd_write_data
	LDI  R26,LOW(3)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xD:
	LDI  R26,LOW(48)
	CALL __lcd_write_nibble_G100
	__DELAY_USB 33
	RET


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	wdr
	__DELAY_USW 0xFA
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
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

__MULW12:
	RCALL __CHKSIGNW
	RCALL __MULW12U
	BRTC __MULW121
	RCALL __ANEGW1
__MULW121:
	RET

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	COM  R26
	COM  R27
	ADIW R26,1
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

;END OF CODE MARKER
__END_OF_CODE:
