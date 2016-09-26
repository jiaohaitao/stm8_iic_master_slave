
#include "iic.h"
//#include "STM8S003F3P.h"
#include "iostm8s.h"

u8 Receive_Buff[Rec_Length] = {0};

//PB4,PB5 ��������
static void IIC_GPIO_Init(void)
{
	PB_DDR &= 0xcf;
	PB_CR1 &= 0xcf;
	PB_CR2 &= 0xcf;
}

void IIC_Slave_Init(void)
{
	CLK_PCKENR1 |= 0x01;				//ʹ��IIC����ʱ��
	
	IIC_GPIO_Init();
	
	I2C_CR1 = 0x00;							//����ʱ����չ����ֹ�㲥���У���ֹiic
	I2C_FREQR = 0x08;						//����ʱ��Ƶ��8MHz
	I2C_OARH = 0x40;						//��λ��ַģʽ
	I2C_OARL = myself_address;	//�����ַ0xa0
	I2C_CCRL = 0xff;						//
	I2C_CCRH = 0x00;						//��׼ģʽ
	I2C_TRISER = 0x02;
	I2C_CR1 |= 0x01;						//ʹ��iic����
	I2C_CR2 |= 0x04;						//ʹ��ACK
	I2C_ITR |= 0x07;						//ʹ���жϣ�ʹ�ܴ����ж�
}

void IIC_Receice(u8 *Buff)
{
	u8 cnt = 0;
	u16 time = 0;
	
	if((I2C_SR1 & 0x02) != 0)
	{
		cnt = I2C_SR1;								//���ADDR��־λ
		cnt = I2C_SR3;
		
		cnt = 0;
		time = 500;
		while((I2C_SR1 & 0x40) == 0)
		{
			time --;
			if(time == 0)
				return ;
		}
		*Buff = I2C_DR;								//��I2C_DR�Ĵ���������RxEN
		time = 500;
		while((I2C_SR1 & 0x40) != 0)
		{
			time --;
			if(time == 0)
				return ;
		}
		
		time = 500;
		while(((I2C_SR1 & 0x10) == 0) & (time != 0))	//�ж��Ƿ��յ�ֹͣλ
		{
			if((I2C_SR1 & 0x40) != 0)		//��ѯ�Ƿ��ٴν��յ�����
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
		
		cnt = I2C_SR1;			//���STOPF��־λ
		I2C_CR2 |= 0x02;		//�ͷ�����
		_asm("nop");
		I2C_CR2 &= 0xfd;
		_asm("nop");
	}
}
