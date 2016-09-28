
#ifndef __IIC_H__
#define __IIC_H__

#define u8  unsigned char
#define u16 unsigned int

#define Rec_Length				20
#define myself_address		0xA2//x51

#define IIC_Start()		I2C_CR2 |= 0x01
#define IIC_Stop()		I2C_CR2 |= 0x02

extern void IIC_Slave_Init(void);
extern void IIC_Receice(u8 *Buff);

#endif
