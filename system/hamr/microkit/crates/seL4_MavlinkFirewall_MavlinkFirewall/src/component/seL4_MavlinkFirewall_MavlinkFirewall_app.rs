// This file will not be overwritten if codegen is rerun

use data::*;
use crate::bridge::seL4_MavlinkFirewall_MavlinkFirewall_api::*;
use vstd::prelude::*;

verus! {

  pub struct seL4_MavlinkFirewall_MavlinkFirewall {
    // PLACEHOLDER MARKER STATE VARS
  }

  impl seL4_MavlinkFirewall_MavlinkFirewall {
    pub fn new() -> Self
    {
      Self {
        // PLACEHOLDER MARKER STATE VAR INIT
      }
    }

    pub fn initialize<API: seL4_MavlinkFirewall_MavlinkFirewall_Put_Api> (
      &mut self,
      api: &mut seL4_MavlinkFirewall_MavlinkFirewall_Application_Api<API>)
      ensures
        // PLACEHOLDER MARKER INITIALIZATION ENSURES
    {
      log_info("initialize entrypoint invoked");
    }

    pub fn timeTriggered<API: seL4_MavlinkFirewall_MavlinkFirewall_Full_Api> (
      &mut self,
      api: &mut seL4_MavlinkFirewall_MavlinkFirewall_Application_Api<API>)
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
        api.In0.is_some() && GumboLib::msg_is_mav_cmd_flash_bootloader_spec(api.In0.unwrap().payload) ==>
          api.Out0.is_none(),
        // guarantee hlr_21_mav0_no_input
        !(api.In0.is_some()) ==> api.Out0.is_none(),
        // guarantee hlr_22_mav0_allow
        api.In0.is_some() && !(GumboLib::msg_is_blacklisted_spec(api.In0.unwrap().payload)) ==>
          api.Out0.is_some() && GumboLib::mav_input_eq_output_spec(api.In0.unwrap(), api.Out0.unwrap()),
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

  // PLACEHOLDER MARKER GUMBO METHODS

}
