// This file will not be overwritten if codegen is rerun

use data::*;
use crate::bridge::seL4_txFirewall_firewall_api::*;
use vstd::prelude::*;

verus! {

  pub struct seL4_txFirewall_firewall {
    // PLACEHOLDER MARKER STATE VARS
  }

  impl seL4_txFirewall_firewall {
    pub fn new() -> Self
    {
      Self {
        // PLACEHOLDER MARKER STATE VAR INIT
      }
    }

    pub fn initialize<API: seL4_txFirewall_firewall_Put_Api> (
      &mut self,
      api: &mut seL4_txFirewall_firewall_Application_Api<API>)
      ensures
        // PLACEHOLDER MARKER INITIALIZATION ENSURES
    {
      log_info("initialize entrypoint invoked");
    }

    pub fn timeTriggered<API: seL4_txFirewall_firewall_Full_Api> (
      &mut self,
      api: &mut seL4_txFirewall_firewall_Application_Api<API>)
      requires
        // BEGIN MARKER TIME TRIGGERED REQUIRES
        // assume AADL_Requirement
        //   All outgoing event ports must be empty
        old(api).EthernetFramesTxOut0.is_none(),
        old(api).EthernetFramesTxOut1.is_none(),
        old(api).EthernetFramesTxOut2.is_none(),
        old(api).EthernetFramesTxOut3.is_none(),
        // END MARKER TIME TRIGGERED REQUIRES
      ensures
        // BEGIN MARKER TIME TRIGGERED ENSURES
        // guarantee hlr_07_tx0_can_send_valid_arp
        (api.EthernetFramesTxIn0.is_some() && valid_arp(api.EthernetFramesTxIn0.unwrap())) ==>
          (api.EthernetFramesTxOut0.is_some() &&
            ((api.EthernetFramesTxIn0.unwrap() == api.EthernetFramesTxOut0.unwrap().amessage) &&
              valid_output_arp_size(api.EthernetFramesTxOut0.unwrap()))),
        // guarantee hlr_12_tx0_can_send_valid_ipv4
        (api.EthernetFramesTxIn0.is_some() && valid_ipv4(api.EthernetFramesTxIn0.unwrap())) ==>
          (api.EthernetFramesTxOut0.is_some() &&
            ((api.EthernetFramesTxIn0.unwrap() == api.EthernetFramesTxOut0.unwrap().amessage) &&
              valid_output_ipv4_size(api.EthernetFramesTxIn0.unwrap(), api.EthernetFramesTxOut0.unwrap()))),
        // guarantee hlr_14_tx0_disallow
        (api.EthernetFramesTxIn0.is_some() && !(allow_outbound_frame(api.EthernetFramesTxIn0.unwrap()))) ==>
          api.EthernetFramesTxOut0.is_none(),
        // guarantee hlr_16_tx0_no_input
        !(api.EthernetFramesTxIn0.is_some()) ==> api.EthernetFramesTxOut0.is_none(),
        // guarantee hlr_07_tx1_can_send_valid_arp
        (api.EthernetFramesTxIn1.is_some() && valid_arp(api.EthernetFramesTxIn1.unwrap())) ==>
          (api.EthernetFramesTxOut1.is_some() &&
            ((api.EthernetFramesTxIn1.unwrap() == api.EthernetFramesTxOut1.unwrap().amessage) &&
              valid_output_arp_size(api.EthernetFramesTxOut1.unwrap()))),
        // guarantee hlr_12_tx1_can_send_valid_ipv4
        (api.EthernetFramesTxIn1.is_some() && valid_ipv4(api.EthernetFramesTxIn1.unwrap())) ==>
          (api.EthernetFramesTxOut1.is_some() &&
            ((api.EthernetFramesTxIn1.unwrap() == api.EthernetFramesTxOut1.unwrap().amessage) &&
              valid_output_ipv4_size(api.EthernetFramesTxIn1.unwrap(), api.EthernetFramesTxOut1.unwrap()))),
        // guarantee hlr_14_tx1_disallow
        (api.EthernetFramesTxIn1.is_some() && !(allow_outbound_frame(api.EthernetFramesTxIn1.unwrap()))) ==>
          api.EthernetFramesTxOut1.is_none(),
        // guarantee hlr_16_tx1_no_input
        !(api.EthernetFramesTxIn1.is_some()) ==> api.EthernetFramesTxOut1.is_none(),
        // guarantee hlr_07_tx2_can_send_valid_arp
        (api.EthernetFramesTxIn2.is_some() && valid_arp(api.EthernetFramesTxIn2.unwrap())) ==>
          (api.EthernetFramesTxOut2.is_some() &&
            ((api.EthernetFramesTxIn2.unwrap() == api.EthernetFramesTxOut2.unwrap().amessage) &&
              valid_output_arp_size(api.EthernetFramesTxOut2.unwrap()))),
        // guarantee hlr_12_tx2_can_send_valid_ipv4
        (api.EthernetFramesTxIn2.is_some() && valid_ipv4(api.EthernetFramesTxIn2.unwrap())) ==>
          (api.EthernetFramesTxOut2.is_some() &&
            ((api.EthernetFramesTxIn2.unwrap() == api.EthernetFramesTxOut2.unwrap().amessage) &&
              valid_output_ipv4_size(api.EthernetFramesTxIn2.unwrap(), api.EthernetFramesTxOut2.unwrap()))),
        // guarantee hlr_14_tx2_disallow
        (api.EthernetFramesTxIn2.is_some() && !(allow_outbound_frame(api.EthernetFramesTxIn2.unwrap()))) ==>
          api.EthernetFramesTxOut2.is_none(),
        // guarantee hlr_16_tx2_no_input
        !(api.EthernetFramesTxIn2.is_some()) ==> api.EthernetFramesTxOut2.is_none(),
        // guarantee hlr_07_tx3_can_send_valid_arp
        (api.EthernetFramesTxIn3.is_some() && valid_arp(api.EthernetFramesTxIn3.unwrap())) ==>
          (api.EthernetFramesTxOut3.is_some() &&
            ((api.EthernetFramesTxIn3.unwrap() == api.EthernetFramesTxOut3.unwrap().amessage) &&
              valid_output_arp_size(api.EthernetFramesTxOut3.unwrap()))),
        // guarantee hlr_12_tx3_can_send_valid_ipv4
        (api.EthernetFramesTxIn3.is_some() && valid_ipv4(api.EthernetFramesTxIn3.unwrap())) ==>
          (api.EthernetFramesTxOut3.is_some() &&
            ((api.EthernetFramesTxIn3.unwrap() == api.EthernetFramesTxOut3.unwrap().amessage) &&
              valid_output_ipv4_size(api.EthernetFramesTxIn3.unwrap(), api.EthernetFramesTxOut3.unwrap()))),
        // guarantee hlr_14_tx3_disallow
        (api.EthernetFramesTxIn3.is_some() && !(allow_outbound_frame(api.EthernetFramesTxIn3.unwrap()))) ==>
          api.EthernetFramesTxOut3.is_none(),
        // guarantee hlr_16_tx3_no_input
        !(api.EthernetFramesTxIn3.is_some()) ==> api.EthernetFramesTxOut3.is_none(),
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

  pub open spec fn ipv4_length(aframe: SW::RawEthernetMessage) -> u16
  {
    two_bytes_to_u16(aframe[16], aframe[17])
  }

  pub open spec fn valid_ipv4_length(aframe: SW::RawEthernetMessage) -> bool
  {
    ipv4_length(aframe) <= 9000u16
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

  pub open spec fn valid_output_arp_size(output: SW::SizedEthernetMessage) -> bool
  {
    output.sz == 64u16
  }

  pub open spec fn valid_output_ipv4_size(
    input: SW::RawEthernetMessage,
    output: SW::SizedEthernetMessage) -> bool
  {
    output.sz == ipv4_length(input) + 14u16
  }

  pub open spec fn allow_outbound_frame(aframe: SW::RawEthernetMessage) -> bool
  {
    valid_arp(aframe) || valid_ipv4(aframe)
  }
  // END MARKER GUMBO METHODS

}
