// This file will not be overwritten if codegen is rerun

use data::*;
use crate::bridge::seL4_mavlinkFirewall_mavlinkFirewall_api::*;
use vstd::prelude::*;

verus! {

  pub struct seL4_mavlinkFirewall_mavlinkFirewall {
    // PLACEHOLDER MARKER STATE VARS
  }

  impl seL4_mavlinkFirewall_mavlinkFirewall {
    pub fn new() -> Self
    {
      Self {
        // PLACEHOLDER MARKER STATE VAR INIT
      }
    }

    pub fn initialize<API: seL4_mavlinkFirewall_mavlinkFirewall_Put_Api> (
      &mut self,
      api: &mut seL4_mavlinkFirewall_mavlinkFirewall_Application_Api<API>)
      ensures
        // PLACEHOLDER MARKER INITIALIZATION ENSURES
    {
      log_info("initialize entrypoint invoked");
    }

    pub fn timeTriggered<API: seL4_mavlinkFirewall_mavlinkFirewall_Full_Api> (
      &mut self,
      api: &mut seL4_mavlinkFirewall_mavlinkFirewall_Application_Api<API>)
      requires
        // BEGIN MARKER TIME TRIGGERED REQUIRES
        // assume AADL_Requirement
        //   All outgoing event ports must be empty
        old(api).Out0.is_none(),
        old(api).Out1.is_none(),
        old(api).Out2.is_none(),
        old(api).Out3.is_none(),
        // END MARKER TIME TRIGGERED REQUIRES
      ensures
        // BEGIN MARKER TIME TRIGGERED ENSURES
        // guarantee hlr_19_mav0_drop_mav_cmd_flash_bootloader
        (api.In0.is_some() && msg_is_mav_cmd_flash_bootloader(api.In0.unwrap().payload)) ==>
          api.Out0.is_none(),
        // guarantee hlr_21_mav0_no_input
        !(api.In0.is_some()) ==> api.Out0.is_none(),
        // guarantee hlr_22_mav0_allow
        (api.In0.is_some() && !(msg_is_blacklisted(api.In0.unwrap().payload))) ==>
          (api.Out0.is_some() && mav_input_eq_output(api.In0.unwrap(), api.Out0.unwrap())),
        // END MARKER TIME TRIGGERED ENSURES
    {
      log_info("compute entrypoint invoked");
    }

    pub fn notify(
      &mut self,
      channel: microkit_channel)
    {
      // this method is called when the monitor does not handle the passed in channel
      match channel {
        _ => {
          log_warn_channel(channel)
        }
      }
    }
  }

  #[verifier::external_body]
  pub fn log_info(msg: &str)
  {
    log::info!("{0}", msg);
  }

  #[verifier::external_body]
  pub fn log_warn_channel(channel: u32)
  {
    log::warn!("Unexpected channel: {0}", channel);
  }

  // BEGIN MARKER GUMBO METHODS
  pub open spec fn three_bytes_to_u32(
    byte0: u8,
    byte1: u8,
    byte2: u8) -> u32
  {
    32u32
  }

  pub open spec fn two_bytes_to_u16(
    byte0: u8,
    byte1: u8) -> u16
  {
    32u16
  }

  pub open spec fn msg_v1_is_command_int(msg: SW::UdpPayload) -> bool
  {
    msg[5] == 75u8
  }

  pub open spec fn command_int_msg_v1_is_bootloader_flash(msg: SW::UdpPayload) -> bool
  {
    two_bytes_to_u16(msg[33], msg[34]) == 42650u16
  }

  pub open spec fn msg_v1_is_command_long(msg: SW::UdpPayload) -> bool
  {
    msg[5] == 76u8
  }

  pub open spec fn command_long_msg_v1_is_bootloader_flash(msg: SW::UdpPayload) -> bool
  {
    two_bytes_to_u16(msg[34], msg[35]) == 42650u16
  }

  pub open spec fn msg_is_mavlinkv1(msg: SW::UdpPayload) -> bool
  {
    msg[0] == 254u8
  }

  pub open spec fn msg_v2_is_command_int(msg: SW::UdpPayload) -> bool
  {
    three_bytes_to_u32(msg[7], msg[8], msg[9]) == 75u32
  }

  pub open spec fn command_int_msg_v2_is_bootloader_flash(msg: SW::UdpPayload) -> bool
  {
    two_bytes_to_u16(msg[37], msg[38]) == 42650u16
  }

  pub open spec fn msg_v2_is_command_long(msg: SW::UdpPayload) -> bool
  {
    three_bytes_to_u32(msg[7], msg[8], msg[9]) == 76u32
  }

  pub open spec fn command_long_msg_v2_is_bootloader_flash(msg: SW::UdpPayload) -> bool
  {
    two_bytes_to_u16(msg[38], msg[39]) == 42650u16
  }

  pub open spec fn msg_is_mavlinkv2(msg: SW::UdpPayload) -> bool
  {
    msg[0] == 253u8
  }

  pub open spec fn msg_is_mav_v2_cmd_flash_bootloader(msg: SW::UdpPayload) -> bool
  {
    msg_is_mavlinkv2(msg) &&
      ((msg_v2_is_command_int(msg) && command_int_msg_v2_is_bootloader_flash(msg)) ||
        (msg_v2_is_command_long(msg) && command_long_msg_v2_is_bootloader_flash(msg)))
  }

  pub open spec fn msg_is_mav_v1_cmd_flash_bootloader(msg: SW::UdpPayload) -> bool
  {
    msg_is_mavlinkv1(msg) &&
      ((msg_v1_is_command_int(msg) && command_int_msg_v1_is_bootloader_flash(msg)) ||
        (msg_v1_is_command_long(msg) && command_long_msg_v1_is_bootloader_flash(msg)))
  }

  pub open spec fn msg_is_mav_cmd_flash_bootloader(msg: SW::UdpPayload) -> bool
  {
    msg_is_mav_v2_cmd_flash_bootloader(msg) || msg_is_mav_v1_cmd_flash_bootloader(msg)
  }

  pub open spec fn mav_input_headers_eq_output(
    headers: SW::EthIpUdpHeaders,
    aframe: SW::RawEthernetMessage) -> bool
  {
    true
  }

  pub open spec fn mav_input_payload_eq_output(
    payload: SW::UdpPayload,
    headers: SW::EthIpUdpHeaders,
    aframe: SW::RawEthernetMessage) -> bool
  {
    true
  }

  pub open spec fn mav_input_eq_output(
    input: SW::UdpFrame,
    aframe: SW::RawEthernetMessage) -> bool
  {
    mav_input_headers_eq_output(input.headers, aframe) && mav_input_payload_eq_output(input.payload, input.headers, aframe)
  }

  pub open spec fn msg_is_blacklisted(msg: SW::UdpPayload) -> bool
  {
    msg_is_mav_cmd_flash_bootloader(msg)
  }
  // END MARKER GUMBO METHODS

}
