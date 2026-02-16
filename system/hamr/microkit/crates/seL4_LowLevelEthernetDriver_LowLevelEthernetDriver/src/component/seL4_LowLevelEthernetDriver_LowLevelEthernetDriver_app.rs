// This file will not be overwritten if codegen is rerun

use data::*;
use crate::bridge::seL4_LowLevelEthernetDriver_LowLevelEthernetDriver_api::*;
use vstd::prelude::*;

verus! {

  pub struct seL4_LowLevelEthernetDriver_LowLevelEthernetDriver {
    // PLACEHOLDER MARKER STATE VARS
  }

  impl seL4_LowLevelEthernetDriver_LowLevelEthernetDriver {
    pub fn new() -> Self
    {
      Self {
        // PLACEHOLDER MARKER STATE VAR INIT
      }
    }

    pub fn initialize<API: seL4_LowLevelEthernetDriver_LowLevelEthernetDriver_Put_Api> (
      &mut self,
      api: &mut seL4_LowLevelEthernetDriver_LowLevelEthernetDriver_Application_Api<API>)
      ensures
        // PLACEHOLDER MARKER INITIALIZATION ENSURES
    {
      log_info("initialize entrypoint invoked");
    }

    pub fn timeTriggered<API: seL4_LowLevelEthernetDriver_LowLevelEthernetDriver_Full_Api> (
      &mut self,
      api: &mut seL4_LowLevelEthernetDriver_LowLevelEthernetDriver_Application_Api<API>)
      requires
        // PLACEHOLDER MARKER TIME TRIGGERED REQUIRES
      ensures
        // PLACEHOLDER MARKER TIME TRIGGERED ENSURES
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
  pub open spec fn TCP_ALLOWED_PORTS() -> SW::u16Array
  {
    [5760u16]
  }

  pub open spec fn UDP_ALLOWED_PORTS() -> SW::u16Array
  {
    [68u16]
  }

  pub open spec fn two_bytes_to_u16(
    byte0: u8,
    byte1: u8) -> u16
  {
    (((byte0) as u16) * 256u16 + ((byte1) as u16)) as u16
  }

  pub open spec fn frame_is_wellformed_eth2(aframe: SW::RawEthernetMessage) -> bool
  {
    valid_frame_ethertype(aframe) && valid_frame_dst_addr(aframe)
  }

  pub open spec fn valid_frame_ethertype(aframe: SW::RawEthernetMessage) -> bool
  {
    frame_has_ipv4(aframe) ||
      (frame_has_arp(aframe) || frame_has_ipv6(aframe))
  }

  pub open spec fn valid_frame_dst_addr(aframe: SW::RawEthernetMessage) -> bool
  {
    (aframe.len() == 1600) &&
      !((aframe[0] == 0u8) &&
        ((aframe[1] == 0u8) &&
          ((aframe[2] == 0u8) &&
            ((aframe[3] == 0u8) &&
              ((aframe[4] == 0u8) &&
                (aframe[5] == 0u8))))))
  }

  pub open spec fn frame_has_ipv4(aframe: SW::RawEthernetMessage) -> bool
  {
    (aframe.len() == 1600) &&
      ((aframe[12] == 8u8) &&
        (aframe[13] == 0u8))
  }

  pub open spec fn frame_has_ipv6(aframe: SW::RawEthernetMessage) -> bool
  {
    (aframe.len() == 1600) &&
      ((aframe[12] == 134u8) &&
        (aframe[13] == 221u8))
  }

  pub open spec fn frame_has_arp(aframe: SW::RawEthernetMessage) -> bool
  {
    (aframe.len() == 1600) &&
      ((aframe[12] == 8u8) &&
        (aframe[13] == 6u8))
  }

  pub open spec fn arp_has_ipv4(aframe: SW::RawEthernetMessage) -> bool
  {
    (aframe.len() == 1600) &&
      ((aframe[16] == 8u8) &&
        (aframe[17] == 0u8))
  }

  pub open spec fn arp_has_ipv6(aframe: SW::RawEthernetMessage) -> bool
  {
    (aframe.len() == 1600) &&
      ((aframe[16] == 134u8) &&
        (aframe[17] == 221u8))
  }

  pub open spec fn valid_arp_ptype(aframe: SW::RawEthernetMessage) -> bool
  {
    arp_has_ipv4(aframe) || arp_has_ipv6(aframe)
  }

  pub open spec fn valid_arp_op(aframe: SW::RawEthernetMessage) -> bool
  {
    (aframe.len() == 1600) &&
      ((aframe[20] == 0u8) &&
        ((aframe[21] == 1u8) ||
          (aframe[21] == 2u8)))
  }

  pub open spec fn valid_arp_htype(aframe: SW::RawEthernetMessage) -> bool
  {
    (aframe.len() == 1600) &&
      ((aframe[14] == 0u8) &&
        (aframe[15] == 1u8))
  }

  pub open spec fn wellformed_arp_frame(aframe: SW::RawEthernetMessage) -> bool
  {
    valid_arp_op(aframe) &&
      (valid_arp_htype(aframe) && valid_arp_ptype(aframe))
  }

  pub open spec fn valid_ipv4_length(aframe: SW::RawEthernetMessage) -> bool
  {
    (aframe.len() == 1600) &&
      (two_bytes_to_u16(aframe[16], aframe[17]) <= 9000u16)
  }

  pub open spec fn valid_ipv4_protocol(aframe: SW::RawEthernetMessage) -> bool
  {
    (aframe.len() == 1600) &&
      ((aframe[23] == 0u8) ||
        ((aframe[23] == 1u8) ||
          ((aframe[23] == 2u8) ||
            ((aframe[23] == 6u8) ||
              ((aframe[23] == 17u8) ||
                ((aframe[23] == 43u8) ||
                  ((aframe[23] == 44u8) ||
                    ((aframe[23] == 58u8) ||
                      ((aframe[23] == 59u8) ||
                        (aframe[23] == 60u8))))))))))
  }

  pub open spec fn valid_ipv4_vers_ihl(aframe: SW::RawEthernetMessage) -> bool
  {
    (aframe.len() == 1600) &&
      (aframe[14] == 69u8)
  }

  pub open spec fn wellformed_ipv4_frame(aframe: SW::RawEthernetMessage) -> bool
  {
    valid_ipv4_protocol(aframe) &&
      (valid_ipv4_length(aframe) && valid_ipv4_vers_ihl(aframe))
  }

  pub open spec fn valid_ipv6(aframe: SW::RawEthernetMessage) -> bool
  {
    frame_is_wellformed_eth2(aframe) && frame_has_ipv6(aframe)
  }

  pub open spec fn valid_arp(aframe: SW::RawEthernetMessage) -> bool
  {
    frame_is_wellformed_eth2(aframe) &&
      (frame_has_arp(aframe) && wellformed_arp_frame(aframe))
  }

  pub open spec fn valid_ipv4(aframe: SW::RawEthernetMessage) -> bool
  {
    frame_is_wellformed_eth2(aframe) &&
      (frame_has_ipv4(aframe) && wellformed_ipv4_frame(aframe))
  }

  pub open spec fn ipv4_length(aframe: SW::RawEthernetMessage) -> u16
  {
    two_bytes_to_u16(aframe[16], aframe[17])
  }

  pub open spec fn valid_output_arp_size(output: SW::SizedEthernetMessage_Impl) -> bool
  {
    output.sz == 64u16
  }

  pub open spec fn valid_output_ipv4_size(
    input: SW::RawEthernetMessage,
    output: SW::SizedEthernetMessage_Impl) -> bool
  {
    (input.len() == 1600) &&
      (output.sz == two_bytes_to_u16(input[16], input[17]) + 14u16)
  }

  pub open spec fn allow_outbound_frame(aframe: SW::RawEthernetMessage) -> bool
  {
    valid_arp(aframe) || valid_ipv4(aframe)
  }

  pub open spec fn ipv4_is_tcp(aframe: SW::RawEthernetMessage) -> bool
  {
    (aframe.len() == 1600) &&
      (aframe[23] == 6u8)
  }

  pub open spec fn ipv4_is_udp(aframe: SW::RawEthernetMessage) -> bool
  {
    (aframe.len() == 1600) &&
      (aframe[23] == 17u8)
  }

  pub open spec fn tcp_is_valid_port(aframe: SW::RawEthernetMessage) -> bool
  {
    (aframe.len() == 1600) &&
      (two_bytes_to_u16(aframe[36], aframe[37]) == TCP_ALLOWED_PORTS()[0])
  }

  pub open spec fn udp_is_valid_port(aframe: SW::RawEthernetMessage) -> bool
  {
    (aframe.len() == 1600) &&
      (two_bytes_to_u16(aframe[36], aframe[37]) == UDP_ALLOWED_PORTS()[0])
  }

  pub open spec fn udp_is_mavlink_src_port(aframe: SW::RawEthernetMessage) -> bool
  {
    (aframe.len() == 1600) &&
      (two_bytes_to_u16(aframe[34], aframe[35]) == 14550u16)
  }

  pub open spec fn udp_is_mavlink_dst_port(aframe: SW::RawEthernetMessage) -> bool
  {
    (aframe.len() == 1600) &&
      (two_bytes_to_u16(aframe[36], aframe[37]) == 14562u16)
  }

  pub open spec fn udp_is_mavlink(aframe: SW::RawEthernetMessage) -> bool
  {
    udp_is_mavlink_src_port(aframe) && udp_is_mavlink_dst_port(aframe)
  }

  pub open spec fn frame_has_ipv4_tcp_on_allowed_port_quant(aframe: SW::RawEthernetMessage) -> bool
  {
    (aframe.len() == 1600) &&
      exists|i:int| 0 <= i <= TCP_ALLOWED_PORTS().len() - 1 && #[trigger] TCP_ALLOWED_PORTS()[i] == two_bytes_to_u16(aframe[36], aframe[37])
  }

  pub open spec fn udp_is_valid_direct_dst_port(aframe: SW::RawEthernetMessage) -> bool
  {
    (aframe.len() == 1600) &&
      exists|i:int| 0 <= i <= UDP_ALLOWED_PORTS().len() - 1 && #[trigger] UDP_ALLOWED_PORTS()[i] == two_bytes_to_u16(aframe[36], aframe[37])
  }

  pub open spec fn valid_arp(aframe: SW::RawEthernetMessage) -> bool
  {
    frame_is_wellformed_eth2(aframe) &&
      (frame_has_arp(aframe) && wellformed_arp_frame(aframe))
  }

  pub open spec fn valid_ipv4_tcp(aframe: SW::RawEthernetMessage) -> bool
  {
    frame_is_wellformed_eth2(aframe) &&
      (frame_has_ipv4(aframe) &&
        (wellformed_ipv4_frame(aframe) && ipv4_is_tcp(aframe)))
  }

  pub open spec fn valid_ipv4_udp(aframe: SW::RawEthernetMessage) -> bool
  {
    frame_is_wellformed_eth2(aframe) &&
      (frame_has_ipv4(aframe) &&
        (wellformed_ipv4_frame(aframe) && ipv4_is_udp(aframe)))
  }

  pub open spec fn valid_ipv4_tcp_port(aframe: SW::RawEthernetMessage) -> bool
  {
    valid_ipv4_tcp(aframe) && frame_has_ipv4_tcp_on_allowed_port_quant(aframe)
  }

  pub open spec fn valid_ipv4_udp_port(aframe: SW::RawEthernetMessage) -> bool
  {
    valid_ipv4_udp(aframe) &&
      (udp_is_valid_direct_dst_port(aframe) && !(udp_is_mavlink(aframe)))
  }

  pub open spec fn valid_ipv4_udp_mavlink(aframe: SW::RawEthernetMessage) -> bool
  {
    valid_ipv4_udp(aframe) && udp_is_mavlink(aframe)
  }

  pub open spec fn allow_outbound_frame(aframe: SW::RawEthernetMessage) -> bool
  {
    valid_arp(aframe) ||
      (valid_ipv4_udp_mavlink(aframe) || valid_ipv4_udp_port(aframe))
  }

  pub open spec fn input_eq_mav_output_headers(
    aframe: SW::RawEthernetMessage,
    headers: SW::EthIpUdpHeaders) -> bool
  {
    (aframe.len() == 1600) &&
      forall|i:int| 0 <= i <= headers.len() - 1 ==> #[trigger] headers[i] == aframe[i]
  }

  pub open spec fn input_eq_mav_output_payload(
    aframe: SW::RawEthernetMessage,
    payload: SW::UdpPayload,
    headers: SW::EthIpUdpHeaders) -> bool
  {
    (aframe.len() == 1600) &&
      ((payload.len() == 1558) &&
        forall|i:int| 0 <= i <= payload.len() - 1 ==> #[trigger] aframe[i + headers.len()] == payload[i])
  }

  pub open spec fn input_eq_mav_output(
    aframe: SW::RawEthernetMessage,
    output: SW::UdpFrame_Impl) -> bool
  {
    input_eq_mav_output_headers(aframe, output.headers) && input_eq_mav_output_payload(aframe, output.payload, output.headers)
  }
  // END MARKER GUMBO METHODS

}
