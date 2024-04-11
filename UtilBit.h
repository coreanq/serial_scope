/*
 * UtilBit.h
 *
 *  Created on: 2017. 3. 20.
 *      Author: myjeon
 */

#ifndef _UTIL_BIT_H_
#define _UTIL_BIT_H_

#include "BaseDefine.h"

class UtilBit
{
public:
	UtilBit(){};
	virtual ~UtilBit(){};

	enum eWord2ByteType : uint8_t
	{
		WORD_HI_BYTE,
		WORD_LO_BYTE,
		WORD_BYTE_SIZE
	};

	enum eLong2ByteType : uint8_t
	{
		LONG_HIHI_BYTE,
		LONG_HILO_BYTE,
		LONG_LOHI_BYTE,
		LONG_LOLO_BYTE,
		LONG_BYTE_SIZE
	};

	enum eLong2WordType : uint8_t
	{
		LONG_HI_WORD,
		LONG_LO_WORD,
		LONG_WORD_SIZE
	};

	static uint8_t ByteBitMask(uint16_t wBit){	// BitMaskByte
		return (uint8_t)(1U << wBit);
	}

	static uint16_t WordBitMask(uint16_t wBit){	// BitMaskWord
		return (uint16_t)(1U << wBit);
	}
	static uint32_t LongBitMask(uint16_t wBit){	// BitMaskLong
		return (uint32_t)(1UL << wBit);
	}
	static void SetBit(uint8_t* pbData, uint16_t wBit){// BitSetByte
		*pbData |= (uint8_t)(1U << wBit);
	}
	static void SetBit(uint16_t* pwData, uint16_t wBit){	// BitSetWord
		*pwData |= (uint16_t)(1U << wBit);
	}
	static void SetBit(uint32_t* pulData, uint16_t wBit){	// BitSetLong
		*pulData |= (uint32_t)(1UL << wBit);
	}
	static void ClearBit(uint8_t* pbData, uint16_t wBit){	// BitClrByte
		uint8_t bBitData;
		bBitData = (1U << wBit);
		*pbData &= ~bBitData;
	}
	static void ClearBit(uint16_t* pwData, uint16_t wBit){	// BitClrWord
		uint16_t wBitData;
		wBitData = (1U << wBit);
		*pwData &= ~wBitData;
	}
	static void ClearBit(uint32_t* pulData, uint16_t wBit){	// BitClrLong
		uint32_t ulBitData;
		ulBitData = (1U << wBit);
		*pulData &= ~ulBitData;
	}
	static void ChangeBitByStatus(uint8_t* pbData, uint16_t wBit, bool blStatus){	// BitCopyByte
		if(blStatus == true){
			SetBit(pbData, wBit);
		}
		else{
			ClearBit(pbData, wBit);
		}
	}
	static void ChangeBitByStatus(uint16_t* pwData, uint16_t wBit, bool blStatus){	// BitCopyWord
		if(blStatus == true){
			SetBit(pwData, wBit);
		}
		else{
			ClearBit(pwData, wBit);
		}
	}
	static void ChangeBitByStatus(uint32_t* pulData, uint16_t wBit, bool blStatus){	// BitCopyLong
		if(blStatus == true){
			SetBit(pulData, wBit);
		}
		else{
			ClearBit(pulData, wBit);
		}
	}
	static bool BitTest(uint8_t bData, uint16_t wBit){	// BitTestByte
		return (bool)(((bData) >> wBit) & BIT_0);
	}
	static bool BitTest(uint16_t wData, uint16_t wBit){	// BitTestWord
		return (bool)(((wData) >> wBit) & BIT_0);
	}
	static bool BitTest(uint32_t ulData, uint16_t wBit){	// BitTestLong
		return (bool)(((ulData) >> wBit) & BIT_LONG_0);
	}
	static void ToggleBit(bool* pblData){	// BitToggleBool
		if(*pblData == true){
			*pblData = false;
		}
		else{
			*pblData = true;
		}
	}
	static void ToggleBit(uint8_t* pbData, uint16_t wBit){	// BitToggleByte
		if(BitTest(*pbData, wBit) == false){
			SetBit(pbData, wBit);
		}
		else{
			ClearBit(pbData, wBit);
		}
	}
	static void ToggleBit(uint16_t* pwData, uint16_t wBit){	// BitToggleWord
		if(BitTest(*pwData, wBit) == false){
			SetBit(pwData, wBit);
		}
		else{
			ClearBit(pwData, wBit);
		}
	}
	static void ToggleBit(uint32_t* pulData, uint16_t wBit){	// BitToggleLong
		if(BitTest(*pulData, wBit) == false){
			SetBit(pulData, wBit);
		}
		else{
			ClearBit(pulData, wBit);
		}
	}
	static uint8_t ByteToHi4Bits(uint8_t bData){
		uint8_t bRet;
		bRet = (uint8_t)((bData >> UINT8_TO_HI_4BIT_SHIFT) & (BIT_3 | BIT_2 | BIT_1 | BIT_0));
		return bRet;
	}
	static uint8_t ByteToLo4Bits(uint8_t bData){
		uint8_t bRet;
		bRet = (uint8_t)(bData & (BIT_3 | BIT_2 | BIT_1 | BIT_0));
		return bRet;
	}
	static uint8_t WordToHiByte(uint16_t wData){
		return (uint8_t)((wData >> UINT16_TO_HI_UINT8_SHIFT) & UINT16_TO_UINT8_LO_BITS);
	}
	static uint8_t WordToLoByte(uint16_t wData){
		return (uint8_t)(wData & UINT16_TO_UINT8_LO_BITS);
	}
	static uint16_t ByteToWord(uint8_t bHiData, uint8_t bLoData){
		return(uint16_t)((((uint16_t)bHiData) << UINT16_TO_HI_UINT8_SHIFT) & UINT16_TO_UINT8_HI_BITS) + (uint16_t)bLoData;
	}
	static uint8_t LongToHiHiByte(uint32_t ulData){
		return (uint8_t)((ulData >> UINT32_TO_HIHI_UINT8_SHIFT) & UINT32_TO_UINT8_LOLO_BITS);
	}
	static uint8_t LongToHiLoByte(uint32_t ulData){
		return (uint8_t)((ulData >> UINT32_TO_HILO_UINT8_SHIFT) & UINT32_TO_UINT8_LOLO_BITS);
	}
	static uint8_t LongToLoHiByte(uint32_t ulData){
		return (uint8_t)((ulData >> UINT32_TO_LOHI_UINT8_SHIFT) & UINT32_TO_UINT8_LOLO_BITS);
	}
	static uint8_t LongToLoLoByte(uint32_t ulData){
		return (uint8_t)(ulData & UINT32_TO_UINT8_LOLO_BITS);
	}
	static uint32_t ByteToLong(uint8_t bHiHiData, uint8_t bHiLoData, uint8_t bLoHiData, uint8_t bLoLoData){
		uint32_t ulRet;
		ulRet = ((((uint32_t)bHiHiData) << UINT32_TO_HIHI_UINT8_SHIFT) & UINT32_TO_UINT8_HIHI_BITS) + ((((uint32_t)bHiLoData) << UINT32_TO_HILO_UINT8_SHIFT) & UINT32_TO_UINT8_HILO_BITS);
		ulRet = ulRet + ((((uint32_t)bLoHiData) << UINT32_TO_LOHI_UINT8_SHIFT) & UINT32_TO_UINT8_LOHI_BITS) + (((uint32_t)bLoLoData) & UINT32_TO_UINT8_LOLO_BITS);
		return ulRet;
	}
	static uint16_t LongToHiWord(uint32_t ulData){
		return (uint16_t)((ulData >> UINT32_TO_HI_UINT16_SHIFT) & UINT32_TO_UINT16_LO_BITS);
	}
	static uint16_t LongToLoWord(uint32_t ulData){
		return (uint16_t)(ulData & UINT32_TO_UINT16_LO_BITS);
	}
	static uint32_t WordToLong(uint16_t wHiData, uint16_t wLoData){
		return (uint32_t)((((uint32_t)wHiData) << UINT32_TO_HI_UINT16_SHIFT) & UINT32_TO_UINT16_HI_BITS) + (uint32_t)wLoData;
	}
};

#endif /* _UTIL_BIT_H_ */
