
#ifndef __IIC_H__
#define __IIC_H__

#define u8  unsigned char
#define u16 unsigned int

#define Add_slave					0xa0
#define myself_address		0xa0

#define IIC_Start()		I2C_CR2 |= 0x01
#define IIC_Stop()		I2C_CR2 |= 0x02

extern void IIC_Master_Init(void);
extern void IIC_Send_Data(u8 *Data_Buff, u8 Length);

#endif
