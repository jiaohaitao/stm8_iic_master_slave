   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.8.32 - 23 Mar 2010
   3                     ; Generator V4.3.4 - 23 Mar 2010
2817                     ; 6 static void IIC_GPIO_Init(void)
2817                     ; 7 {
2819                     	switch	.text
2820  0000               L3671_IIC_GPIO_Init:
2824                     ; 8 	PB_DDR &= 0xcf;
2826  0000 c65007        	ld	a,_PB_DDR
2827  0003 a4cf          	and	a,#207
2828  0005 c75007        	ld	_PB_DDR,a
2829                     ; 9 	PB_CR1 &= 0xcf;
2831  0008 c65008        	ld	a,_PB_CR1
2832  000b a4cf          	and	a,#207
2833  000d c75008        	ld	_PB_CR1,a
2834                     ; 10 	PB_CR2 &= 0xcf;
2836  0010 c65009        	ld	a,_PB_CR2
2837  0013 a4cf          	and	a,#207
2838  0015 c75009        	ld	_PB_CR2,a
2839                     ; 11 }
2842  0018 81            	ret
2874                     ; 13 void IIC_Master_Init(void)
2874                     ; 14 {
2875                     	switch	.text
2876  0019               _IIC_Master_Init:
2880                     ; 15 	CLK_PCKENR1 |= 0x01;				//使能IIC外设时钟
2882  0019 721050c7      	bset	_CLK_PCKENR1,#0
2883                     ; 17 	IIC_GPIO_Init();
2885  001d ade1          	call	L3671_IIC_GPIO_Init
2887                     ; 19 	I2C_CR1 = 0x00;							//允许时钟延展，禁止广播呼叫，禁止iic
2889  001f 725f5210      	clr	_I2C_CR1
2890                     ; 20 	I2C_FREQR = 0x01;						//输入时钟频率8MHz
2892  0023 35015212      	mov	_I2C_FREQR,#1
2893                     ; 21 	I2C_OARH = 0x40;						//七位地址模式
2895  0027 35405214      	mov	_I2C_OARH,#64
2896                     ; 22 	I2C_OARL = myself_address;	//自身地址0xa0
2898  002b 35a05213      	mov	_I2C_OARL,#160
2899                     ; 23 	I2C_CCRL = 0xff;						//
2901  002f 35ff521b      	mov	_I2C_CCRL,#255
2902                     ; 24 	I2C_CCRH = 0x00;						//标准模式
2904  0033 725f521c      	clr	_I2C_CCRH
2905                     ; 25 	I2C_TRISER = 0x02;
2907  0037 3502521d      	mov	_I2C_TRISER,#2
2908                     ; 26 	I2C_CR1 |= 0x01;						//使能iic外设
2910  003b 72105210      	bset	_I2C_CR1,#0
2911                     ; 27 }
2914  003f 81            	ret
2989                     ; 30 void IIC_Send_Data(u8 *Data_Buff, u8 Length)
2989                     ; 31 {
2990                     	switch	.text
2991  0040               _IIC_Send_Data:
2993  0040 89            	pushw	x
2994  0041 5204          	subw	sp,#4
2995       00000004      OFST:	set	4
2998                     ; 32 	u8 i = 0;
3000                     ; 33 	u8 temp = 0;
3002                     ; 34 	u16 cnt = 0;
3004                     ; 36 	cnt = 500;
3006  0043 ae01f4        	ldw	x,#500
3007  0046 1f03          	ldw	(OFST-1,sp),x
3009  0048 2009          	jra	L5502
3010  004a               L1502:
3011                     ; 38 		if(!--cnt)
3013  004a 1e03          	ldw	x,(OFST-1,sp)
3014  004c 1d0001        	subw	x,#1
3015  004f 1f03          	ldw	(OFST-1,sp),x
3016  0051 271b          	jreq	L61
3017                     ; 39 			return ;
3019  0053               L5502:
3020                     ; 37 	while((I2C_SR3 & 0x02) != 0)		//等待IIC总线空闲
3022  0053 c65219        	ld	a,_I2C_SR3
3023  0056 a502          	bcp	a,#2
3024  0058 26f0          	jrne	L1502
3025                     ; 40 	IIC_Start();
3027  005a 72105211      	bset	_I2C_CR2,#0
3028                     ; 41 	cnt = 500;
3030  005e ae01f4        	ldw	x,#500
3031  0061 1f03          	ldw	(OFST-1,sp),x
3033  0063 200c          	jra	L7602
3034  0065               L3602:
3035                     ; 43 		if(!--cnt)
3037  0065 1e03          	ldw	x,(OFST-1,sp)
3038  0067 1d0001        	subw	x,#1
3039  006a 1f03          	ldw	(OFST-1,sp),x
3040  006c 2603          	jrne	L7602
3041                     ; 44 			return ;
3042  006e               L61:
3045  006e 5b06          	addw	sp,#6
3046  0070 81            	ret
3047  0071               L7602:
3048                     ; 42 	while((I2C_SR1 & 0x01) == 0)			//EV5，起始信号已经发送
3050  0071 c65217        	ld	a,_I2C_SR1
3051  0074 a501          	bcp	a,#1
3052  0076 27ed          	jreq	L3602
3053                     ; 45 	I2C_DR = (Add_slave & 0xfe);			//发送iic从器件物理地址，最低位0，写操作
3055  0078 35a05216      	mov	_I2C_DR,#160
3056                     ; 46 	cnt = 500;
3058  007c ae01f4        	ldw	x,#500
3059  007f 1f03          	ldw	(OFST-1,sp),x
3061  0081 2009          	jra	L1012
3062  0083               L5702:
3063                     ; 48 		if(!--cnt)
3065  0083 1e03          	ldw	x,(OFST-1,sp)
3066  0085 1d0001        	subw	x,#1
3067  0088 1f03          	ldw	(OFST-1,sp),x
3068  008a 27e2          	jreq	L61
3069                     ; 49 			return ;
3071  008c               L1012:
3072                     ; 47 	while((I2C_SR1 & 0x02) == 0)			//地址已经被发送
3074  008c c65217        	ld	a,_I2C_SR1
3075  008f a502          	bcp	a,#2
3076  0091 27f0          	jreq	L5702
3077                     ; 50 	temp = I2C_SR1;										//清除ADDR标志位
3079  0093 c65217        	ld	a,_I2C_SR1
3080                     ; 51 	temp = I2C_SR3;
3082  0096 c65219        	ld	a,_I2C_SR3
3083                     ; 53 	for(i = 0; i < Length; i++)
3085  0099 0f02          	clr	(OFST-2,sp)
3087  009b 2045          	jra	L3112
3088  009d               L7012:
3089                     ; 55 		cnt = 500;
3091  009d ae01f4        	ldw	x,#500
3092  00a0 1f03          	ldw	(OFST-1,sp),x
3094  00a2 2009          	jra	L3212
3095  00a4               L7112:
3096                     ; 57 			if(!--cnt)
3098  00a4 1e03          	ldw	x,(OFST-1,sp)
3099  00a6 1d0001        	subw	x,#1
3100  00a9 1f03          	ldw	(OFST-1,sp),x
3101  00ab 27c1          	jreq	L61
3102                     ; 58 				return ;
3104  00ad               L3212:
3105                     ; 56 		while((I2C_SR1 & 0x80) == 0)		//等待发送寄存器为空
3107  00ad c65217        	ld	a,_I2C_SR1
3108  00b0 a580          	bcp	a,#128
3109  00b2 27f0          	jreq	L7112
3110                     ; 59 		I2C_DR = *Data_Buff;						//发送数据
3112  00b4 1e05          	ldw	x,(OFST+1,sp)
3113  00b6 f6            	ld	a,(x)
3114  00b7 c75216        	ld	_I2C_DR,a
3115                     ; 60 		Data_Buff ++;
3117  00ba 1e05          	ldw	x,(OFST+1,sp)
3118  00bc 1c0001        	addw	x,#1
3119  00bf 1f05          	ldw	(OFST+1,sp),x
3120                     ; 61 		cnt == 500;
3122  00c1 1e03          	ldw	x,(OFST-1,sp)
3123  00c3 a301f4        	cpw	x,#500
3124  00c6 2605          	jrne	L21
3125  00c8 ae0001        	ldw	x,#1
3126  00cb 2001          	jra	L41
3127  00cd               L21:
3128  00cd 5f            	clrw	x
3129  00ce               L41:
3131  00ce 2009          	jra	L3312
3132  00d0               L1312:
3133                     ; 63 			if(!--cnt)
3135  00d0 1e03          	ldw	x,(OFST-1,sp)
3136  00d2 1d0001        	subw	x,#1
3137  00d5 1f03          	ldw	(OFST-1,sp),x
3138  00d7 2795          	jreq	L61
3139                     ; 64 				return ;
3141  00d9               L3312:
3142                     ; 62 		while((I2C_SR1 & 0x04) == 0)		//等待发送完成
3144  00d9 c65217        	ld	a,_I2C_SR1
3145  00dc a504          	bcp	a,#4
3146  00de 27f0          	jreq	L1312
3147                     ; 53 	for(i = 0; i < Length; i++)
3149  00e0 0c02          	inc	(OFST-2,sp)
3150  00e2               L3112:
3153  00e2 7b02          	ld	a,(OFST-2,sp)
3154  00e4 1109          	cp	a,(OFST+5,sp)
3155  00e6 25b5          	jrult	L7012
3156                     ; 67 	temp = I2C_SR1;										//清零BTF标志位
3158  00e8 c65217        	ld	a,_I2C_SR1
3159                     ; 68 	temp = I2C_DR;
3161  00eb c65216        	ld	a,_I2C_DR
3162                     ; 69 	IIC_Stop();												//发送停止信号
3164  00ee 72125211      	bset	_I2C_CR2,#1
3165                     ; 70 }
3167  00f2 ac6e006e      	jpf	L61
3180                     	xdef	_IIC_Send_Data
3181                     	xdef	_IIC_Master_Init
3200                     	end
