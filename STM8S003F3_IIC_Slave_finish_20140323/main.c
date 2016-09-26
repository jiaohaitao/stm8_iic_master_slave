
#include "iostm8s.h"
//#include "STM8S003F3P.h"
#include "iic.h"

extern u8 Receive_Buff[Rec_Length];

void System_Config(void);

main()
{
	_asm("sim");
	System_Config();
	IIC_Slave_Init();
	_asm("rim");
	
	while (1)
	{
		;
	}
}

void System_Config(void)
{
	CLK_CKDIVR = 0x00;		//16MHz主频
	CLK_PCKENR1 = 0x00;		//关闭所有外设时钟
	CLK_PCKENR2 = 0x00;
}

@far @interrupt void IIC_Receive (void)
{
	if((I2C_SR2 & 0x07) != 0)	//应答失败，仲裁失败，总线错误
	{
		I2C_SR2 &= 0xf8;
		return ;
	}
	else
		IIC_Receice(Receive_Buff);
	_asm("rim");
}
