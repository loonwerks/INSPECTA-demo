#include "seL4_arduPilot_arduPilot.h"

// This file will not be overwritten if codegen is rerun

void seL4_arduPilot_arduPilot_initialize(void) {
  printf("%s: seL4_arduPilot_arduPilot_initialize invoked\n", microkit_name);
}

void seL4_arduPilot_arduPilot_timeTriggered(void) {
  printf("%s: seL4_arduPilot_arduPilot_timeTriggered invoked\n", microkit_name);
}

void seL4_arduPilot_arduPilot_notify(microkit_channel channel) {
  // this method is called when the monitor does not handle the passed in channel
  switch (channel) {
    default:
      printf("%s: Unexpected channel %d\n", microkit_name, channel);
  }
}
