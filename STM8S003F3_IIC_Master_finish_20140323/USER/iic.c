
#include "iic.h"
#include "iostm8s.h"

//PB4,PB5 ��������
static void IIC_GPIO_Init(void)
{
	PB_DDR &= 0xcf;
	PB_CR1 &= 0xcf;
	PB_CR2 &= 0xcf;
}

void IIC_Master_Init(void)
{
	CLK_PCKENR1 |= 0x01;				//ʹ��IIC����ʱ��
	
	IIC_GPIO_Init();
	
	I2C_CR1 = 0x00;							//����ʱ����չ����ֹ�㲥���У���ֹiic
	I2C_FREQR = 0x01;						//����ʱ��Ƶ��8MHz
	I2C_OARH = 0x40;						//��λ��ַģʽ
	I2C_OARL = myself_address;	//�����ַ0xa0
	I2C_CCRL = 0xff;						//
	I2C_CCRH = 0x00;						//��׼ģʽ
	I2C_TRISER = 0x02;
	I2C_CR1 |= 0x01;						//ʹ��iic����
}


void IIC_Send_Data(u8 *Data_Buff, u8 Length)
{
	u8 i = 0;
	u8 temp = 0;
	u16 cnt = 0;
	
	cnt = 500;
	while((I2C_SR3 & 0x02) != 0)		//�ȴ�IIC���߿���
		if(!--cnt)
			return ;
	IIC_Start();
	cnt = 500;
	while((I2C_SR1 & 0x01) == 0)			//EV5����ʼ�ź��Ѿ�����
		if(!--cnt)
			return ;
	I2C_DR = (Add_slave & 0xfe);			//����iic�����������ַ�����λ0��д����
	cnt = 500;
	while((I2C_SR1 & 0x02) == 0)			//��ַ�Ѿ�������
		if(!--cnt)
			return ;
	temp = I2C_SR1;										//���ADDR��־λ
	temp = I2C_SR3;
	
	for(i = 0; i < Length; i++)
	{
		cnt = 500;
		while((I2C_SR1 & 0x80) == 0)		//�ȴ����ͼĴ���Ϊ��
			if(!--cnt)
				return ;
		I2C_DR = *Data_Buff;						//��������
		Data_Buff ++;
		cnt == 500;
		while((I2C_SR1 & 0x04) == 0)		//�ȴ��������
			if(!--cnt)
				return ;
	}
			
	temp = I2C_SR1;										//����BTF��־λ
	temp = I2C_DR;
	IIC_Stop();												//����ֹͣ�ź�
}
