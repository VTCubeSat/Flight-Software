#ifndef _BOARD_COMMON_UART_NATIVE_H_
#define _BOARD_COMMON_UART_NATIVE_H_

#ifdef __cplusplus
extern "C" {
#endif

#if defined( MSP430_CLASS_F5xx_6xx )
#   include "uart_usci_native.h"
#elif defined( MSP430_CLASS_FR2xx_4xx ) || \
      defined( MSP430_CLASS_FR57xx ) || \
      defined( MSP430_CLASS_FR5xx_6xx ) || \
      defined( MSP430_CLASS_i2xx )
#   include "uart_eusci_native.h"
#else
#   error "No MSP class defined"
#endif

#ifdef __cplusplus
}
#endif

#endif // _BOARD_COMMON_UART_NATIVE_H_
