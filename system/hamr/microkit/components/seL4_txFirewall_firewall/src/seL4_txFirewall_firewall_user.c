#include "seL4_txFirewall_firewall.h"

// This file will not be overwritten if codegen is rerun

void seL4_txFirewall_firewall_initialize(void) {
  printf("%s: seL4_txFirewall_firewall_initialize invoked\n", microkit_name);
}

void seL4_txFirewall_firewall_timeTriggered(void) {
  printf("%s: seL4_txFirewall_firewall_timeTriggered invoked\n", microkit_name);
}

void seL4_txFirewall_firewall_notify(microkit_channel channel) {
  // this method is called when the monitor does not handle the passed in channel
  switch (channel) {
    default:
      printf("%s: Unexpected channel %d\n", microkit_name, channel);
  }
}
