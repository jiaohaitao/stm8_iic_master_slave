   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.8.32 - 23 Mar 2010
   3                     ; Generator V4.3.4 - 23 Mar 2010
2787                     	bsct
2788  0000               _Send_Data_Buff:
2789  0000 aa            	dc.b	170
2790  0001 55            	dc.b	85
2791  0002 02            	dc.b	2
2792  0003 03            	dc.b	3
2793  0004 04            	dc.b	4
2794  0005 05            	dc.b	5
2795  0006 06            	dc.b	6
2796  0007 07            	dc.b	7
2797  0008 08            	dc.b	8
2798  0009 09            	dc.b	9
2799  000a 10            	dc.b	16
2800  000b 11            	dc.b	17
2801  000c 12            	dc.b	18
2802  000d 13            	dc.b	19
2803  000e 14            	dc.b	20
2804  000f 15            	dc.b	21
2837                     ; 9 main()
2837                     ; 10 {
2839                     	switch	.text
2840  0000               _main:
2844                     ; 12 	System_Config();
2846  0000 ad0e          	call	_System_Config
2848                     ; 13 	IIC_Master_Init();
2850  0002 cd0000        	call	_IIC_Master_Init
2852                     ; 15 	IIC_Send_Data(Send_Data_Buff, 16);
2854  0005 4b10          	push	#16
2855  0007 ae0000        	ldw	x,#_Send_Data_Buff
2856  000a cd0000        	call	_IIC_Send_Data
2858  000d 84            	pop	a
2859  000e               L1002:
2860                     ; 17 	while (1);
2862  000e 20fe          	jra	L1002
2888                     ; 20 void System_Config(void)
2888                     ; 21 {
2889                     	switch	.text
2890  0010               _System_Config:
2894                     ; 22 	CLK_CKDIVR = 0x00;		//16MHz主频
2896  0010 725f50c6      	clr	_CLK_CKDIVR
2897                     ; 23 	CLK_PCKENR1 = 0x00;		//关闭所有外设时钟
2899  0014 725f50c7      	clr	_CLK_PCKENR1
2900                     ; 24 	CLK_PCKENR2 = 0x00;
2902  0018 725f50ca      	clr	_CLK_PCKENR2
2903                     ; 25 }
2906  001c 81            	ret
2931                     	xdef	_main
2932                     	xdef	_System_Config
2933                     	xdef	_Send_Data_Buff
2934                     	xref	_IIC_Send_Data
2935                     	xref	_IIC_Master_Init
2954                     	end
