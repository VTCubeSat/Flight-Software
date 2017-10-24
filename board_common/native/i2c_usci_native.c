#include "i2c_usci_native.h"

#include <assert.h>

bool i2c_open() {

  // Initialization parameters for the I2C

  EUSCI_B_I2C_initMasterParam param;
  uint16_t base_address = 0x00;

  // Start the I2C in Master mode

  EUSCI_B_I2C_initMaster(base_address, param);

  assert(false);
}

void i2c_write_byte() {
  assert(false);
}

void i2c_read_byte() {
  assert(false);
}

void i2c_close() {
  assert(false);
}
