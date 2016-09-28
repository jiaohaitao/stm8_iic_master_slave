   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.8.32 - 23 Mar 2010
   3                     ; Generator V4.3.4 - 23 Mar 2010
2816                     ; 10 main()
2816                     ; 11 {
2818                     	switch	.text
2819  0000               _main:
2823                     ; 12 	_asm("sim");
2826  0000 9b            sim
2828                     ; 13 	System_Config();
2830  0001 ad06          	call	_System_Config
2832                     ; 14 	IIC_Slave_Init();
2834  0003 cd0000        	call	_IIC_Slave_Init
2836                     ; 15 	_asm("rim");
2839  0006 9a            rim
2841  0007               L1002:
2842                     ; 19 		;
2844  0007 20fe          	jra	L1002
2870                     ; 23 void System_Config(void)
2870                     ; 24 {
2871                     	switch	.text
2872  0009               _System_Config:
2876                     ; 25 	CLK_CKDIVR = 0x00;		//16MHz主频
2878  0009 725f50c6      	clr	_CLK_CKDIVR
2879                     ; 26 	CLK_PCKENR1 = 0x00;		//关闭所有外设时钟
2881  000d 725f50c7      	clr	_CLK_PCKENR1
2882                     ; 27 	CLK_PCKENR2 = 0x00;
2884  0011 725f50ca      	clr	_CLK_PCKENR2
2885                     ; 28 }
2888  0015 81            	ret
2915                     ; 30 @far @interrupt void IIC_Receive (void)
2915                     ; 31 {
2917                     	switch	.text
2918  0016               f_IIC_Receive:
2920  0016 3b0002        	push	c_x+2
2921  0019 be00          	ldw	x,c_x
2922  001b 89            	pushw	x
2923  001c 3b0002        	push	c_y+2
2924  001f be00          	ldw	x,c_y
2925  0021 89            	pushw	x
2928                     ; 32 	if((I2C_SR2 & 0x07) != 0)	//应答失败，仲裁失败，总线错误
2930  0022 c65218        	ld	a,_I2C_SR2
2931  0025 a507          	bcp	a,#7
2932  0027 270a          	jreq	L5202
2933                     ; 34 		I2C_SR2 &= 0xf8;
2935  0029 c65218        	ld	a,_I2C_SR2
2936  002c a4f8          	and	a,#248
2937  002e c75218        	ld	_I2C_SR2,a
2938                     ; 35 		return ;
2940  0031 2007          	jra	L21
2941  0033               L5202:
2942                     ; 38 		IIC_Receice(Receive_Buff);
2944  0033 ae0000        	ldw	x,#_Receive_Buff
2945  0036 cd0000        	call	_IIC_Receice
2947                     ; 39 	_asm("rim");
2950  0039 9a            rim
2952                     ; 40 }
2953  003a               L21:
2956  003a 85            	popw	x
2957  003b bf00          	ldw	c_y,x
2958  003d 320002        	pop	c_y+2
2959  0040 85            	popw	x
2960  0041 bf00          	ldw	c_x,x
2961  0043 320002        	pop	c_x+2
2962  0046 80            	iret
2974                     	xdef	f_IIC_Receive
2975                     	xdef	_main
2976                     	xdef	_System_Config
2977                     	xref.b	_Receive_Buff
2978                     	xref	_IIC_Receice
2979                     	xref	_IIC_Slave_Init
2980                     	xref.b	c_x
2981                     	xref.b	c_y
3000                     	end
