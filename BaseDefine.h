

#ifndef __BASE_DEFINE_H_
#define __BASE_DEFINE_H_

#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#undef NULL
#define NULL		nullptr

typedef void INTERRUPT;

typedef void (*pVOIDFUNC)(void);
typedef bool (*pBOOLFUNC)(void);

typedef uint8_t (*pUINT8FUNC)(void);
typedef uint16_t (*pUINT16FUNC)(void);
typedef uint32_t (*pUINT32FUNC)(void);
typedef uint8_t * pUINT8;
typedef uint16_t * pUINT16;
typedef uint32_t * pUINT32;
typedef void * pVOID;

#define GENERATE_ENUM(ENUM) ENUM,
#define GENERATE_STRING(STRING) #STRING,

#define BIT_OFF				0U
#define BIT_ON				1U

#define LOW					0U
#define HIGH				1U

#define INACTIVE			0U
#define ACTIVE				1U

#define SELECT_NO			0U
#define SELECT_YES			1U
#define SELECT_NONE			0U

#define UINT8_MAX_VALUE			(0xFFU)
#define UINT16_MAX_VALUE		(0xFFFFU)
#define UINT32_MAX_VALUE		(0xFFFFFFFFUL)

#define INT16_MAX_VALUE			(32767)
#define INT32_MAX_VALUE			(2147483647L)	//0x7FFFFFFF
#define INT24_MAX_VALUE			(8388607L)
#define INT16_MIN_VALUE			(-32767-1)
#define INT32_MIN_VALUE			(-2147483647L-1L)
#define INT24_MIN_VALUE			(-8388608L)
#define FLOAT_INT24_MAX_VALUE	(8388607.0f)
#define FLOAT_INT24_MIN_VALUE	(-8388608.0f)

#define INT16_SIGN_BIT			(0x8000)
#define INT32_SIGN_BIT			(0x80000000)
#define INT24_SIGN_BIT			(0x800000)

#define NUMBER_TWO_FIXED	2
#define NUMBER_TWO_FLOAT	2.0f
#define INV_TWO_FLOAT		0.5f
#define FLOAT_ROUND 		0.5f

#define NAN_FLOAT			1E-20f
#define INF_FLOAT			1E+20f


#define	BIT_LONG_31			0x80000000UL
#define	BIT_LONG_30			0x40000000UL
#define	BIT_LONG_29			0x20000000UL
#define	BIT_LONG_28			0x10000000UL
#define	BIT_LONG_27			0x08000000UL
#define	BIT_LONG_26			0x04000000UL
#define	BIT_LONG_25			0x02000000UL
#define	BIT_LONG_24			0x01000000UL
#define	BIT_LONG_23			0x00800000UL
#define	BIT_LONG_22			0x00400000UL
#define	BIT_LONG_21			0x00200000UL
#define	BIT_LONG_20			0x00100000UL
#define	BIT_LONG_19			0x00080000UL
#define	BIT_LONG_18			0x00040000UL
#define	BIT_LONG_17			0x00020000UL
#define	BIT_LONG_16			0x00010000UL
#define	BIT_LONG_15			0x00008000UL
#define	BIT_LONG_14			0x00004000UL
#define	BIT_LONG_13			0x00002000UL
#define	BIT_LONG_12			0x00001000UL
#define	BIT_LONG_11			0x00000800UL
#define	BIT_LONG_10			0x00000400UL
#define	BIT_LONG_9			0x00000200UL
#define	BIT_LONG_8			0x00000100UL
#define	BIT_LONG_7			0x00000080UL
#define	BIT_LONG_6			0x00000040UL
#define	BIT_LONG_5			0x00000020UL
#define	BIT_LONG_4			0x00000010UL
#define	BIT_LONG_3			0x00000008UL
#define	BIT_LONG_2			0x00000004UL
#define	BIT_LONG_1			0x00000002UL
#define	BIT_LONG_0			0x00000001UL

#define	BIT_15			0x8000U
#define	BIT_14			0x4000U
#define	BIT_13			0x2000U
#define	BIT_12			0x1000U
#define	BIT_11			0x0800U
#define	BIT_10			0x0400U
#define	BIT_9			0x0200U
#define	BIT_8			0x0100U
#define	BIT_7			0x80U
#define	BIT_6			0x40U
#define	BIT_5			0x20U
#define	BIT_4			0x10U
#define	BIT_3			0x08U
#define	BIT_2			0x04U
#define	BIT_1			0x02U
#define	BIT_0			0x01U

#define UINT8_TO_HI_4BITS 			(0xF0U)
#define UINT8_TO_LO_4BITS 			(0x0FU)
#define UINT16_TO_UINT8_LO_BITS 	(0x00FFU)
#define UINT16_TO_UINT8_HI_BITS 	(0xFF00U)
#define UINT16_TO_UINT8_LO_BITS 	(0x00FFU)
#define UINT32_TO_UINT8_HIHI_BITS	(0xFF000000LU)
#define UINT32_TO_UINT8_HILO_BITS	(0x00FF0000LU)
#define UINT32_TO_UINT8_LOHI_BITS	(0x0000FF00LU)
#define UINT32_TO_UINT8_LOLO_BITS	(0x000000FFLU)
#define UINT32_TO_UINT16_HI_BITS	(0xFFFF0000LU)
#define UINT32_TO_UINT16_LO_BITS	(0x0000FFFFLU)

#define UINT8_TO_HI_4BIT_SHIFT		4U
#define UINT16_TO_HI_UINT8_SHIFT	8U
#define UINT32_TO_HIHI_UINT8_SHIFT	24U
#define UINT32_TO_HILO_UINT8_SHIFT	16U
#define UINT32_TO_LOHI_UINT8_SHIFT	8U
#define UINT32_TO_HI_UINT16_SHIFT	16U

#define UINT8_TO_BIT_SIZE	8U
#define UINT16_TO_BIT_SIZE	16U
#define UINT32_TO_BIT_SIZE	32U

#endif  //__BASE_DEFINE_H_
