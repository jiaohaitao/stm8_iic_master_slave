
#include "iostm8s.h"
#include "iic.h"

u8 Send_Data_Buff[16] = {0xaa, 0x55, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x10, 0x11, 0x12, 0x13, 0x14, 0x15};

void System_Config(void);

main()
{
	
	System_Config();
	IIC_Master_Init();
	
	IIC_Send_Data(Send_Data_Buff, 16);
	
	while (1);
}

void System_Config(void)
{
	CLK_CKDIVR = 0x00;		//16MHz主频
	CLK_PCKENR1 = 0x00;		//关闭所有外设时钟
	CLK_PCKENR2 = 0x00;
}
