
#ifndef SOURCE_PLATFORM_FRAMEWORK_COMMON_UTILCRC16_H_
#define SOURCE_PLATFORM_FRAMEWORK_COMMON_UTILCRC16_H_

#include "UtilBit.h"


/* 
	CRC16/MODBUS algorithm
	poly: 0x8005
	Init: 0xffff
	RefIn: true
	RefOut: true
	XorOut: 0x0000

	WARNING: retrun value big endian

*/

#define CRC16_SIZE		2

#define BYTE_BIT_COUNT		8
#define CRC_TALBLE_SIZE		1 << BYTE_BIT_COUNT
#define CRC_START_VALUE		0xFF

class UtilCrc16
{
public:
	UtilCrc16();
	virtual ~UtilCrc16();

	static uint16_t Calculation(const uint8_t abData[], uint16_t wLength);
	static uint16_t PasteFrame(uint8_t abData[], uint16_t wDataLength);
	static bool Check(const uint8_t abData[], uint16_t wFrameLength);
};

#endif /* SOURCE_PLATFORM_FRAMEWORK_COMMON_UTILCRC16_H_ */
