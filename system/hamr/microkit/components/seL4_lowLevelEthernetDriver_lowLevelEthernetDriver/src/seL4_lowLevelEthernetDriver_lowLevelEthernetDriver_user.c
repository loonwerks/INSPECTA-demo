#include "seL4_lowLevelEthernetDriver_lowLevelEthernetDriver.h"

// This file will not be overwritten if codegen is rerun

void seL4_lowLevelEthernetDriver_lowLevelEthernetDriver_initialize(void) {
  printf("%s: seL4_lowLevelEthernetDriver_lowLevelEthernetDriver_initialize invoked\n", microkit_name);
}

void seL4_lowLevelEthernetDriver_lowLevelEthernetDriver_timeTriggered(void) {
  printf("%s: seL4_lowLevelEthernetDriver_lowLevelEthernetDriver_timeTriggered invoked\n", microkit_name);
}

void seL4_lowLevelEthernetDriver_lowLevelEthernetDriver_notify(microkit_channel channel) {
  // this method is called when the monitor does not handle the passed in channel
  switch (channel) {
    default:
      printf("%s: Unexpected channel %d\n", microkit_name, channel);
  }
}
