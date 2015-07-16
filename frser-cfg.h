#ifndef _FRSER_CFG_H_
#define _FRSER_CFG_H_

/* What kind of buses your flasher supports. I assume if it can LPC it can FWH too. */
/* You can override that with FORCE_BUSTYPE if you cant (weirdo hardware duuude :P) */
//#define FRSER_FEAT_PARALLEL
#define FRSER_FEAT_LPCFWH
#define FRSER_FEAT_SPI

/* Debug feature, if you want to use get_last_op to know the last frser operation. */
//#define FRSER_FEAT_LAST_OP
/* Safety feature, calls set_uart_timeout with a jmp_buf to longjmp to in case of timeout. */
//#define FRSER_FEAT_UART_TIMEOUT
/* If your system is capable of autodetecting the actual attached chip bustype. */
#define FRSER_FEAT_DYNPROTO
/* If your system is capable of turning on/off chip drivers. */
#define FRSER_FEAT_PIN_STATE
/* If you have a debug console you'd want frser to call upon space bar. */
//#define FRSER_FEAT_DBG_CONSOLE

/* Name provided to flashrom to identify what the thing is. Max 16 bytes */
#define FRSER_NAME "Teensy LPC+SPI"

/* Attached address lines, only if FRSER_FEAT_PARALLEL */
//#define FRSER_PARALLEL_BITS 19

/* Ability to set SPI frequency (only if SPI). */
//#define FRSER_FEAT_SPISPEED

/* Optionally, if you want to make the auto-OPBUF-sizing code leave more/less RAM space for
 * rest of the system, define this. Default is below. Not needed for SPI-only flashers. */
#define FRSER_SYS_BYTES 0

/* Hokey pokey values for the frser.c code to have something to calc opbuf size with. */
#define RAMSTART 0
#define RAMEND 0xFFF

/* Hooks to use the LED as a "busy" indicator + usb serial flush. */

#define FRSER_FEAT_PRE_OPRX_HOOK()  do { if (!usbs_has_data()) usb_serial_flush_output(); \
						LED_OFF(); } while(0)

#define FRSER_FEAT_POST_OPRX_HOOK() do { LED_ON(); } while(0)

#endif
