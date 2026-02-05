// This file will not be overwritten if codegen is rerun

use data::*;
use crate::bridge::seL4_rxFirewall_firewall_api::*;
use vstd::prelude::*;

verus! {

  pub struct seL4_rxFirewall_firewall {
    // PLACEHOLDER MARKER STATE VARS
  }

  impl seL4_rxFirewall_firewall {
    pub fn new() -> Self
    {
      Self {
        // PLACEHOLDER MARKER STATE VAR INIT
      }
    }

    pub fn initialize<API: seL4_rxFirewall_firewall_Put_Api> (
      &mut self,
      api: &mut seL4_rxFirewall_firewall_Application_Api<API>)
      ensures
        // PLACEHOLDER MARKER INITIALIZATION ENSURES
    {
      log_info("initialize entrypoint invoked");
    }

    pub fn timeTriggered<API: seL4_rxFirewall_firewall_Full_Api> (
      &mut self,
      api: &mut seL4_rxFirewall_firewall_Application_Api<API>)
      requires
        // BEGIN MARKER TIME TRIGGERED REQUIRES
        // assume AADL_Requirement
        //   All outgoing event ports must be empty
        old(api).VmmOut0.is_none(),
        old(api).VmmOut1.is_none(),
        old(api).VmmOut2.is_none(),
        old(api).VmmOut3.is_none(),
        old(api).MavlinkOut0.is_none(),
        old(api).MavlinkOut1.is_none(),
        old(api).MavlinkOut2.is_none(),
        old(api).MavlinkOut3.is_none(),
        // END MARKER TIME TRIGGERED REQUIRES
      ensures
        // BEGIN MARKER TIME TRIGGERED ENSURES
        // guarantee hlr_05_rx0_can_send_arp_to_vmm
        (api.EthernetFramesRxIn0.is_some() && valid_arp(api.EthernetFramesRxIn0.unwrap())) ==>
          (api.VmmOut0.is_some() &&
            ((api.EthernetFramesRxIn0.unwrap() == api.VmmOut0.unwrap()) &&
              api.MavlinkOut0.is_none())),
        // guarantee hlr_18_rx0_can_send_mavlink_udp
        (api.EthernetFramesRxIn0.is_some() && valid_ipv4_udp_mavlink(api.EthernetFramesRxIn0.unwrap())) ==>
          (api.MavlinkOut0.is_some() &&
            (input_eq_mav_output(api.EthernetFramesRxIn0.unwrap(), api.MavlinkOut0.unwrap()) && api.VmmOut0.is_none())),
        // guarantee hlr_13_rx0_can_send_ipv4_udp
        (api.EthernetFramesRxIn0.is_some() && valid_ipv4_udp_port(api.EthernetFramesRxIn0.unwrap())) ==>
          (api.VmmOut0.is_some() &&
            ((api.EthernetFramesRxIn0.unwrap() == api.VmmOut0.unwrap()) &&
              api.MavlinkOut0.is_none())),
        // guarantee hlr_15_rx0_disallow
        (api.EthernetFramesRxIn0.is_some() && !(allow_outbound_frame(api.EthernetFramesRxIn0.unwrap()))) ==>
          (api.VmmOut0.is_none() && api.MavlinkOut0.is_none()),
        // guarantee hlr_17_rx0_no_input
        !(api.EthernetFramesRxIn0.is_some()) ==>
          (api.VmmOut0.is_none() && api.MavlinkOut0.is_none()),
        // guarantee hlr_05_rx1_can_send_arp_to_vmm
        (api.EthernetFramesRxIn1.is_some() && valid_arp(api.EthernetFramesRxIn1.unwrap())) ==>
          (api.VmmOut1.is_some() &&
            ((api.EthernetFramesRxIn1.unwrap() == api.VmmOut1.unwrap()) &&
              api.MavlinkOut1.is_none())),
        // guarantee hlr_18_rx1_can_send_mavlink_udp
        (api.EthernetFramesRxIn1.is_some() && valid_ipv4_udp_mavlink(api.EthernetFramesRxIn1.unwrap())) ==>
          (api.MavlinkOut1.is_some() &&
            (input_eq_mav_output(api.EthernetFramesRxIn1.unwrap(), api.MavlinkOut1.unwrap()) && api.VmmOut1.is_none())),
        // guarantee hlr_13_rx1_can_send_ipv4_udp
        (api.EthernetFramesRxIn1.is_some() && valid_ipv4_udp_port(api.EthernetFramesRxIn1.unwrap())) ==>
          (api.VmmOut1.is_some() &&
            ((api.EthernetFramesRxIn1.unwrap() == api.VmmOut1.unwrap()) &&
              api.MavlinkOut1.is_none())),
        // guarantee hlr_15_rx1_disallow
        (api.EthernetFramesRxIn1.is_some() && !(allow_outbound_frame(api.EthernetFramesRxIn1.unwrap()))) ==>
          (api.VmmOut1.is_none() && api.MavlinkOut1.is_none()),
        // guarantee hlr_17_rx1_no_input
        !(api.EthernetFramesRxIn1.is_some()) ==>
          (api.VmmOut1.is_none() && api.MavlinkOut1.is_none()),
        // guarantee hlr_05_rx2_can_send_arp_to_vmm
        (api.EthernetFramesRxIn2.is_some() && valid_arp(api.EthernetFramesRxIn2.unwrap())) ==>
          (api.VmmOut2.is_some() &&
            ((api.EthernetFramesRxIn2.unwrap() == api.VmmOut2.unwrap()) &&
              api.MavlinkOut2.is_none())),
        // guarantee hlr_18_rx2_can_send_mavlink_udp
        (api.EthernetFramesRxIn2.is_some() && valid_ipv4_udp_mavlink(api.EthernetFramesRxIn2.unwrap())) ==>
          (api.MavlinkOut2.is_some() &&
            (input_eq_mav_output(api.EthernetFramesRxIn2.unwrap(), api.MavlinkOut2.unwrap()) && api.VmmOut2.is_none())),
        // guarantee hlr_13_rx2_can_send_ipv4_udp
        (api.EthernetFramesRxIn2.is_some() && valid_ipv4_udp_port(api.EthernetFramesRxIn2.unwrap())) ==>
          (api.VmmOut2.is_some() &&
            ((api.EthernetFramesRxIn2.unwrap() == api.VmmOut2.unwrap()) &&
              api.MavlinkOut2.is_none())),
        // guarantee hlr_15_rx2_disallow
        (api.EthernetFramesRxIn2.is_some() && !(allow_outbound_frame(api.EthernetFramesRxIn2.unwrap()))) ==>
          (api.VmmOut2.is_none() && api.MavlinkOut2.is_none()),
        // guarantee hlr_17_rx2_no_input
        !(api.EthernetFramesRxIn2.is_some()) ==>
          (api.VmmOut2.is_none() && api.MavlinkOut2.is_none()),
        // guarantee hlr_05_rx3_can_send_arp_to_vmm
        (api.EthernetFramesRxIn3.is_some() && valid_arp(api.EthernetFramesRxIn3.unwrap())) ==>
          (api.VmmOut3.is_some() &&
            ((api.EthernetFramesRxIn3.unwrap() == api.VmmOut3.unwrap()) &&
              api.MavlinkOut3.is_none())),
        // guarantee hlr_18_rx3_can_send_mavlink_udp
        (api.EthernetFramesRxIn3.is_some() && valid_ipv4_udp_mavlink(api.EthernetFramesRxIn3.unwrap())) ==>
          (api.MavlinkOut3.is_some() &&
            (input_eq_mav_output(api.EthernetFramesRxIn3.unwrap(), api.MavlinkOut3.unwrap()) && api.VmmOut3.is_none())),
        // guarantee hlr_13_rx3_can_send_ipv4_udp
        (api.EthernetFramesRxIn3.is_some() && valid_ipv4_udp_port(api.EthernetFramesRxIn3.unwrap())) ==>
          (api.VmmOut3.is_some() &&
            ((api.EthernetFramesRxIn3.unwrap() == api.VmmOut3.unwrap()) &&
              api.MavlinkOut3.is_none())),
        // guarantee hlr_15_rx3_disallow
        (api.EthernetFramesRxIn3.is_some() && !(allow_outbound_frame(api.EthernetFramesRxIn3.unwrap()))) ==>
          (api.VmmOut3.is_none() && api.MavlinkOut3.is_none()),
        // guarantee hlr_17_rx3_no_input
        !(api.EthernetFramesRxIn3.is_some()) ==>
          (api.VmmOut3.is_none() && api.MavlinkOut3.is_none()),
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
  pub open spec fn TCP_ALLOWED_PORTS() -> SW::u16Array
  {
    [5760u16, 0u16, 0u16, 0u16]
  }

  pub open spec fn UDP_ALLOWED_PORTS() -> SW::u16Array
  {
    [68u16, 0u16, 0u16, 0u16]
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
    !((aframe[0] == 0u8) &&
      ((aframe[1] == 0u8) &&
        ((aframe[2] == 0u8) &&
          ((aframe[3] == 0u8) &&
            ((aframe[4] == 0u8) &&
              (aframe[5] == 0u8))))))
  }

  pub open spec fn frame_has_ipv4(aframe: SW::RawEthernetMessage) -> bool
  {
    (aframe[12] == 8u8) &&
      (aframe[13] == 0u8)
  }

  pub open spec fn frame_has_ipv6(aframe: SW::RawEthernetMessage) -> bool
  {
    (aframe[12] == 134u8) &&
      (aframe[13] == 221u8)
  }

  pub open spec fn frame_has_arp(aframe: SW::RawEthernetMessage) -> bool
  {
    (aframe[12] == 8u8) &&
      (aframe[13] == 6u8)
  }

  pub open spec fn arp_has_ipv4(aframe: SW::RawEthernetMessage) -> bool
  {
    (aframe[16] == 8u8) &&
      (aframe[17] == 0u8)
  }

  pub open spec fn arp_has_ipv6(aframe: SW::RawEthernetMessage) -> bool
  {
    (aframe[16] == 134u8) &&
      (aframe[17] == 221u8)
  }

  pub open spec fn valid_arp_ptype(aframe: SW::RawEthernetMessage) -> bool
  {
    arp_has_ipv4(aframe) || arp_has_ipv6(aframe)
  }

  pub open spec fn valid_arp_op(aframe: SW::RawEthernetMessage) -> bool
  {
    (aframe[20] == 0u8) &&
      ((aframe[21] == 1u8) ||
        (aframe[21] == 2u8))
  }

  pub open spec fn valid_arp_htype(aframe: SW::RawEthernetMessage) -> bool
  {
    (aframe[14] == 0u8) &&
      (aframe[15] == 1u8)
  }

  pub open spec fn wellformed_arp_frame(aframe: SW::RawEthernetMessage) -> bool
  {
    valid_arp_op(aframe) &&
      (valid_arp_htype(aframe) && valid_arp_ptype(aframe))
  }

  pub open spec fn valid_ipv4_length(aframe: SW::RawEthernetMessage) -> bool
  {
    two_bytes_to_u16(aframe[16], aframe[17]) <= 9000u16
  }

  pub open spec fn valid_ipv4_protocol(aframe: SW::RawEthernetMessage) -> bool
  {
    (aframe[23] == 0u8) ||
      ((aframe[23] == 1u8) ||
        ((aframe[23] == 2u8) ||
          ((aframe[23] == 6u8) ||
            ((aframe[23] == 17u8) ||
              ((aframe[23] == 43u8) ||
                ((aframe[23] == 44u8) ||
                  ((aframe[23] == 58u8) ||
                    ((aframe[23] == 59u8) ||
                      (aframe[23] == 60u8)))))))))
  }

  pub open spec fn valid_ipv4_vers_ihl(aframe: SW::RawEthernetMessage) -> bool
  {
    aframe[14] == 69u8
  }

  pub open spec fn wellformed_ipv4_frame(aframe: SW::RawEthernetMessage) -> bool
  {
    valid_ipv4_protocol(aframe) &&
      (valid_ipv4_length(aframe) && valid_ipv4_vers_ihl(aframe))
  }

  pub open spec fn ipv4_is_tcp(aframe: SW::RawEthernetMessage) -> bool
  {
    aframe[23] == 6u8
  }

  pub open spec fn ipv4_is_udp(aframe: SW::RawEthernetMessage) -> bool
  {
    aframe[23] == 17u8
  }

  pub open spec fn tcp_is_valid_port(aframe: SW::RawEthernetMessage) -> bool
  {
    two_bytes_to_u16(aframe[36], aframe[37]) == TCP_ALLOWED_PORTS()
  }

  pub open spec fn udp_is_valid_port(aframe: SW::RawEthernetMessage) -> bool
  {
    two_bytes_to_u16(aframe[36], aframe[37]) == UDP_ALLOWED_PORTS()
  }

  pub open spec fn udp_is_mavlink_src_port(aframe: SW::RawEthernetMessage) -> bool
  {
    two_bytes_to_u16(aframe[34], aframe[35]) == 14550
  }

  pub open spec fn udp_is_mavlink_dst_port(aframe: SW::RawEthernetMessage) -> bool
  {
    two_bytes_to_u16(aframe[36], aframe[37]) == 14562
  }

  pub open spec fn udp_is_mavlink(aframe: SW::RawEthernetMessage) -> bool
  {
    udp_is_mavlink_src_port(aframe) && udp_is_mavlink_dst_port(aframe)
  }

  pub open spec fn frame_has_ipv4_tcp_on_allowed_port_quant(aframe: SW::RawEthernetMessage) -> bool
  {
    true
  }

  pub open spec fn udp_is_valid_direct_dst_port(aframe: SW::RawEthernetMessage) -> bool
  {
    true
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
    forall|i:int| 0 <= i <= headers.len() ==> #[trigger] headers[i] == aframe[i]
  }

  pub open spec fn input_eq_mav_output_payload(
    aframe: SW::RawEthernetMessage,
    payload: SW::UdpPayload,
    headers: SW::EthIpUdpHeaders) -> bool
  {
    forall|i:int| 0 <= i <= payload.len() ==> #[trigger] aframe[i + headers.len()] == payload[i]
  }

  pub open spec fn input_eq_mav_output(
    aframe: SW::RawEthernetMessage,
    output: SW::UdpFrame) -> bool
  {
    input_eq_mav_output_headers(aframe, output.headers) && input_eq_mav_output_payload(aframe, output.payload, output.headers)
  }
  // END MARKER GUMBO METHODS

}
