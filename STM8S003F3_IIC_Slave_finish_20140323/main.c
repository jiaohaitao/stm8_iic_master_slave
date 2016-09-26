
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
	CLK_CKDIVR = 0x00;		//16MHz��Ƶ
	CLK_PCKENR1 = 0x00;		//�ر���������ʱ��
	CLK_PCKENR2 = 0x00;
}

@far @interrupt void IIC_Receive (void)
{
	if((I2C_SR2 & 0x07) != 0)	//Ӧ��ʧ�ܣ��ٲ�ʧ�ܣ����ߴ���
	{
		I2C_SR2 &= 0xf8;
		return ;
	}
	else
		IIC_Receice(Receive_Buff);
	_asm("rim");
}
