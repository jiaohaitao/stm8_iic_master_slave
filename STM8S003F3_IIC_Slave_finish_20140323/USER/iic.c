
#include "iic.h"
//#include "STM8S003F3P.h"
#include "iostm8s.h"

u8 Receive_Buff[Rec_Length] = {0};

//PB4,PB5 悬浮输入
static void IIC_GPIO_Init(void)
{
	PB_DDR &= 0xcf;
	PB_CR1 &= 0xcf;
	PB_CR2 &= 0xcf;
}

void IIC_Slave_Init(void)
{
	CLK_PCKENR1 |= 0x01;				//使能IIC外设时钟
	
	IIC_GPIO_Init();
	
	I2C_CR1 = 0x00;							//允许时钟延展，禁止广播呼叫，禁止iic
	I2C_FREQR = 0x08;						//输入时钟频率8MHz
	I2C_OARH = 0x40;						//七位地址模式
	I2C_OARL = myself_address;	//自身地址0xa0
	I2C_CCRL = 0xff;						//
	I2C_CCRH = 0x00;						//标准模式
	I2C_TRISER = 0x02;
	I2C_CR1 |= 0x01;						//使能iic外设
	I2C_CR2 |= 0x04;						//使能ACK
	I2C_ITR |= 0x07;						//使能中断，使能错误中断
}

void IIC_Receice(u8 *Buff)
{
	u8 cnt = 0;
	u16 time = 0;
	
	if((I2C_SR1 & 0x02) != 0)
	{
		cnt = I2C_SR1;								//清除ADDR标志位
		cnt = I2C_SR3;
		
		cnt = 0;
		time = 500;
		while((I2C_SR1 & 0x40) == 0)
		{
			time --;
			if(time == 0)
				return ;
		}
		*Buff = I2C_DR;								//读I2C_DR寄存器，清零RxEN
		time = 500;
		while((I2C_SR1 & 0x40) != 0)
		{
			time --;
			if(time == 0)
				return ;
		}
		
		time = 500;
		while(((I2C_SR1 & 0x10) == 0) & (time != 0))	//判断是否收到停止位
		{
			if((I2C_SR1 & 0x40) != 0)		//查询是否再次接收到数据
			{
				Buff ++;
				cnt ++;
				*Buff = I2C_DR;
				time = 500;
				while((I2C_SR1 & 0x40) != 0)
				{
					{
						time --;
						if(time == 0)
							return ;
					}
				}
				time = 500;
			}
			time --;
		}
		
		while(cnt < (Rec_Length - 1))
		{
			Buff ++;
			cnt ++;
			*Buff = 0;
		}
		
		cnt = I2C_SR1;			//清除STOPF标志位
		I2C_CR2 |= 0x02;		//释放总线
		_asm("nop");
		I2C_CR2 &= 0xfd;
		_asm("nop");
	}
}
