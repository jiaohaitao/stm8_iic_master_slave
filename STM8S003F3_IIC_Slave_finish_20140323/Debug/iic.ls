   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.8.32 - 23 Mar 2010
   3                     ; Generator V4.3.4 - 23 Mar 2010
2787                     	bsct
2788  0000               _Receive_Buff:
2789  0000 00            	dc.b	0
2790  0001 000000000000  	ds.b	19
2822                     ; 9 static void IIC_GPIO_Init(void)
2822                     ; 10 {
2824                     	switch	.text
2825  0000               L3671_IIC_GPIO_Init:
2829                     ; 11 	PB_DDR &= 0xcf;
2831  0000 c65007        	ld	a,_PB_DDR
2832  0003 a4cf          	and	a,#207
2833  0005 c75007        	ld	_PB_DDR,a
2834                     ; 12 	PB_CR1 &= 0xcf;
2836  0008 c65008        	ld	a,_PB_CR1
2837  000b a4cf          	and	a,#207
2838  000d c75008        	ld	_PB_CR1,a
2839                     ; 13 	PB_CR2 &= 0xcf;
2841  0010 c65009        	ld	a,_PB_CR2
2842  0013 a4cf          	and	a,#207
2843  0015 c75009        	ld	_PB_CR2,a
2844                     ; 14 }
2847  0018 81            	ret
2881                     ; 16 void IIC_Slave_Init(void)
2881                     ; 17 {
2882                     	switch	.text
2883  0019               _IIC_Slave_Init:
2887                     ; 18 	CLK_PCKENR1 |= 0x01;				//使能IIC外设时钟
2889  0019 721050c7      	bset	_CLK_PCKENR1,#0
2890                     ; 20 	IIC_GPIO_Init();
2892  001d ade1          	call	L3671_IIC_GPIO_Init
2894                     ; 22 	I2C_CR1 = 0x00;							//允许时钟延展，禁止广播呼叫，禁止iic
2896  001f 725f5210      	clr	_I2C_CR1
2897                     ; 23 	I2C_FREQR = 0x08;						//输入时钟频率8MHz
2899  0023 35085212      	mov	_I2C_FREQR,#8
2900                     ; 24 	I2C_OARH = 0x40;						//七位地址模式
2902  0027 35405214      	mov	_I2C_OARH,#64
2903                     ; 25 	I2C_OARL = myself_address;	//自身地址0xa0
2905  002b 35a25213      	mov	_I2C_OARL,#162
2906                     ; 26 	I2C_CCRL = 0xff;						//
2908  002f 35ff521b      	mov	_I2C_CCRL,#255
2909                     ; 27 	I2C_CCRH = 0x00;						//标准模式
2911  0033 725f521c      	clr	_I2C_CCRH
2912                     ; 28 	I2C_TRISER = 0x02;
2914  0037 3502521d      	mov	_I2C_TRISER,#2
2915                     ; 29 	I2C_CR1 |= 0x01;						//使能iic外设
2917  003b 72105210      	bset	_I2C_CR1,#0
2918                     ; 30 	I2C_CR2 |= 0x04;						//使能ACK
2920  003f 72145211      	bset	_I2C_CR2,#2
2921                     ; 31 	I2C_ITR |= 0x07;						//使能中断，使能错误中断
2923  0043 c6521a        	ld	a,_I2C_ITR
2924  0046 aa07          	or	a,#7
2925  0048 c7521a        	ld	_I2C_ITR,a
2926                     ; 32 }
2929  004b 81            	ret
2986                     ; 34 void IIC_Receice(u8 *Buff)
2986                     ; 35 {
2987                     	switch	.text
2988  004c               _IIC_Receice:
2990  004c 89            	pushw	x
2991  004d 5205          	subw	sp,#5
2992       00000005      OFST:	set	5
2995                     ; 36 	u8 cnt = 0;
2997                     ; 37 	u16 time = 0;
2999                     ; 39 	if((I2C_SR1 & 0x02) != 0)
3001  004f c65217        	ld	a,_I2C_SR1
3002  0052 a502          	bcp	a,#2
3003  0054 2603          	jrne	L42
3004  0056 cc0124        	jp	L1402
3005  0059               L42:
3006                     ; 41 		cnt = I2C_SR1;								//清除ADDR标志位
3008  0059 c65217        	ld	a,_I2C_SR1
3009                     ; 42 		cnt = I2C_SR3;
3011  005c c65219        	ld	a,_I2C_SR3
3012                     ; 44 		cnt = 0;
3014  005f 0f03          	clr	(OFST-2,sp)
3015                     ; 45 		time = 500;
3017  0061 ae01f4        	ldw	x,#500
3018  0064 1f04          	ldw	(OFST-1,sp),x
3020  0066 200b          	jra	L7402
3021  0068               L3402:
3022                     ; 48 			time --;
3024  0068 1e04          	ldw	x,(OFST-1,sp)
3025  006a 1d0001        	subw	x,#1
3026  006d 1f04          	ldw	(OFST-1,sp),x
3027                     ; 49 			if(time == 0)
3029  006f 1e04          	ldw	x,(OFST-1,sp)
3030  0071 271f          	jreq	L22
3031                     ; 50 				return ;
3033  0073               L7402:
3034                     ; 46 		while((I2C_SR1 & 0x40) == 0)
3036  0073 c65217        	ld	a,_I2C_SR1
3037  0076 a540          	bcp	a,#64
3038  0078 27ee          	jreq	L3402
3039                     ; 52 		*Buff = I2C_DR;								//读I2C_DR寄存器，清零RxEN
3041  007a 1e06          	ldw	x,(OFST+1,sp)
3042  007c c65216        	ld	a,_I2C_DR
3043  007f f7            	ld	(x),a
3044                     ; 53 		time = 500;
3046  0080 ae01f4        	ldw	x,#500
3047  0083 1f04          	ldw	(OFST-1,sp),x
3049  0085 200e          	jra	L1602
3050  0087               L5502:
3051                     ; 56 			time --;
3053  0087 1e04          	ldw	x,(OFST-1,sp)
3054  0089 1d0001        	subw	x,#1
3055  008c 1f04          	ldw	(OFST-1,sp),x
3056                     ; 57 			if(time == 0)
3058  008e 1e04          	ldw	x,(OFST-1,sp)
3059  0090 2603          	jrne	L1602
3060                     ; 58 				return ;
3061  0092               L22:
3064  0092 5b07          	addw	sp,#7
3065  0094 81            	ret
3066  0095               L1602:
3067                     ; 54 		while((I2C_SR1 & 0x40) != 0)
3069  0095 c65217        	ld	a,_I2C_SR1
3070  0098 a540          	bcp	a,#64
3071  009a 26eb          	jrne	L5502
3072                     ; 61 		time = 500;
3074  009c ae01f4        	ldw	x,#500
3075  009f 1f04          	ldw	(OFST-1,sp),x
3077  00a1 203b          	jra	L3702
3078  00a3               L7602:
3079                     ; 64 			if((I2C_SR1 & 0x40) != 0)		//查询是否再次接收到数据
3081  00a3 c65217        	ld	a,_I2C_SR1
3082  00a6 a540          	bcp	a,#64
3083  00a8 272d          	jreq	L7702
3084                     ; 66 				Buff ++;
3086  00aa 1e06          	ldw	x,(OFST+1,sp)
3087  00ac 1c0001        	addw	x,#1
3088  00af 1f06          	ldw	(OFST+1,sp),x
3089                     ; 67 				cnt ++;
3091  00b1 0c03          	inc	(OFST-2,sp)
3092                     ; 68 				*Buff = I2C_DR;
3094  00b3 1e06          	ldw	x,(OFST+1,sp)
3095  00b5 c65216        	ld	a,_I2C_DR
3096  00b8 f7            	ld	(x),a
3097                     ; 69 				time = 500;
3099  00b9 ae01f4        	ldw	x,#500
3100  00bc 1f04          	ldw	(OFST-1,sp),x
3102  00be 200b          	jra	L5012
3103  00c0               L1012:
3104                     ; 73 						time --;
3106  00c0 1e04          	ldw	x,(OFST-1,sp)
3107  00c2 1d0001        	subw	x,#1
3108  00c5 1f04          	ldw	(OFST-1,sp),x
3109                     ; 74 						if(time == 0)
3111  00c7 1e04          	ldw	x,(OFST-1,sp)
3112  00c9 27c7          	jreq	L22
3113                     ; 75 							return ;
3115  00cb               L5012:
3116                     ; 70 				while((I2C_SR1 & 0x40) != 0)
3118  00cb c65217        	ld	a,_I2C_SR1
3119  00ce a540          	bcp	a,#64
3120  00d0 26ee          	jrne	L1012
3121                     ; 78 				time = 500;
3123  00d2 ae01f4        	ldw	x,#500
3124  00d5 1f04          	ldw	(OFST-1,sp),x
3125  00d7               L7702:
3126                     ; 80 			time --;
3128  00d7 1e04          	ldw	x,(OFST-1,sp)
3129  00d9 1d0001        	subw	x,#1
3130  00dc 1f04          	ldw	(OFST-1,sp),x
3131  00de               L3702:
3132                     ; 62 		while(((I2C_SR1 & 0x10) == 0) & (time != 0))	//判断是否收到停止位
3134  00de 1e04          	ldw	x,(OFST-1,sp)
3135  00e0 2705          	jreq	L21
3136  00e2 ae0001        	ldw	x,#1
3137  00e5 2001          	jra	L41
3138  00e7               L21:
3139  00e7 5f            	clrw	x
3140  00e8               L41:
3141  00e8 1f01          	ldw	(OFST-4,sp),x
3142  00ea c65217        	ld	a,_I2C_SR1
3143  00ed a510          	bcp	a,#16
3144  00ef 2605          	jrne	L61
3145  00f1 ae0001        	ldw	x,#1
3146  00f4 2001          	jra	L02
3147  00f6               L61:
3148  00f6 5f            	clrw	x
3149  00f7               L02:
3150  00f7 01            	rrwa	x,a
3151  00f8 1402          	and	a,(OFST-3,sp)
3152  00fa 01            	rrwa	x,a
3153  00fb 1401          	and	a,(OFST-4,sp)
3154  00fd 01            	rrwa	x,a
3155  00fe a30000        	cpw	x,#0
3156  0101 26a0          	jrne	L7602
3158  0103 200c          	jra	L5112
3159  0105               L3112:
3160                     ; 85 			Buff ++;
3162  0105 1e06          	ldw	x,(OFST+1,sp)
3163  0107 1c0001        	addw	x,#1
3164  010a 1f06          	ldw	(OFST+1,sp),x
3165                     ; 86 			cnt ++;
3167  010c 0c03          	inc	(OFST-2,sp)
3168                     ; 87 			*Buff = 0;
3170  010e 1e06          	ldw	x,(OFST+1,sp)
3171  0110 7f            	clr	(x)
3172  0111               L5112:
3173                     ; 83 		while(cnt < (Rec_Length - 1))
3175  0111 7b03          	ld	a,(OFST-2,sp)
3176  0113 a113          	cp	a,#19
3177  0115 25ee          	jrult	L3112
3178                     ; 90 		cnt = I2C_SR1;			//清除STOPF标志位
3180  0117 c65217        	ld	a,_I2C_SR1
3181                     ; 91 		I2C_CR2 |= 0x02;		//释放总线
3183  011a 72125211      	bset	_I2C_CR2,#1
3184                     ; 92 		_asm("nop");
3187  011e 9d            nop
3189                     ; 93 		I2C_CR2 &= 0xfd;
3191  011f 72135211      	bres	_I2C_CR2,#1
3192                     ; 94 		_asm("nop");
3195  0123 9d            nop
3197  0124               L1402:
3198                     ; 96 }
3200  0124 ac920092      	jpf	L22
3225                     	xdef	_Receive_Buff
3226                     	xdef	_IIC_Receice
3227                     	xdef	_IIC_Slave_Init
3246                     	end
