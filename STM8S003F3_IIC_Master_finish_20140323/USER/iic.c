
#include "iic.h"
#include "iostm8s.h"

//PB4,PB5 悬浮输入
static void IIC_GPIO_Init(void)
{
	PB_DDR &= 0xcf;
	PB_CR1 &= 0xcf;
	PB_CR2 &= 0xcf;
}

void IIC_Master_Init(void)
{
	CLK_PCKENR1 |= 0x01;				//使能IIC外设时钟
	
	IIC_GPIO_Init();
	
	I2C_CR1 = 0x00;							//允许时钟延展，禁止广播呼叫，禁止iic
	I2C_FREQR = 0x01;						//输入时钟频率8MHz
	I2C_OARH = 0x40;						//七位地址模式
	I2C_OARL = myself_address;	//自身地址0xa0
	I2C_CCRL = 0xff;						//
	I2C_CCRH = 0x00;						//标准模式
	I2C_TRISER = 0x02;
	I2C_CR1 |= 0x01;						//使能iic外设
}


void IIC_Send_Data(u8 *Data_Buff, u8 Length)
{
	u8 i = 0;
	u8 temp = 0;
	u16 cnt = 0;
	
	cnt = 500;
	while((I2C_SR3 & 0x02) != 0)		//等待IIC总线空闲
		if(!--cnt)
			return ;
	IIC_Start();
	cnt = 500;
	while((I2C_SR1 & 0x01) == 0)			//EV5，起始信号已经发送
		if(!--cnt)
			return ;
	I2C_DR = (Add_slave & 0xfe);			//发送iic从器件物理地址，最低位0，写操作
	cnt = 500;
	while((I2C_SR1 & 0x02) == 0)			//地址已经被发送
		if(!--cnt)
			return ;
	temp = I2C_SR1;										//清除ADDR标志位
	temp = I2C_SR3;
	
	for(i = 0; i < Length; i++)
	{
		cnt = 500;
		while((I2C_SR1 & 0x80) == 0)		//等待发送寄存器为空
			if(!--cnt)
				return ;
		I2C_DR = *Data_Buff;						//发送数据
		Data_Buff ++;
		cnt == 500;
		while((I2C_SR1 & 0x04) == 0)		//等待发送完成
			if(!--cnt)
				return ;
	}
			
	temp = I2C_SR1;										//清零BTF标志位
	temp = I2C_DR;
	IIC_Stop();												//发送停止信号
}
