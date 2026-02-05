package SW {
	private import HAMR::*;
	private import CASE_Scheduling::*;
	private import SequenceFunctions::*;
	private import ControlFunctions::*;
	private import ScalarValues::*;

	part def u16Array :> Array {
		part :>> Base_Type : Base_Types::Unsigned_16;
		attribute :>> Dimensions = 4;
		attribute :>> Data_Size = 8 [byte];
		attribute :>> Array_Size_Kind = Array_Size_Kinds::Fixed;
	}

	part def RawEthernetMessage :> Array {
		part :>> Base_Type : Base_Types::Unsigned_8;
		attribute :>> Dimensions = 1600;
		attribute :>> Array_Size_Kind = Array_Size_Kinds::Fixed; 
		attribute :>> Data_Size = 1600[byte];
	}

	part def EthIpUdpHeaders :> Array {
		part :>> Base_Type : Base_Types::Unsigned_8;
		attribute :>> Dimensions = 42;
		attribute :>> Data_Size = 42 [byte];
		attribute :>> Array_Size_Kind = Array_Size_Kinds::Fixed;
	}
	
	part def UdpPayload :> Array {
		part :>> Base_Type : Base_Types::Unsigned_8;
		attribute :>> Dimensions = 1558;
		attribute :>> Data_Size = 1558 [byte];
		attribute :>> Array_Size_Kind = Array_Size_Kinds::Fixed;
	}
	
	part def UdpFrame :> Struct {
		part headers : EthIpUdpHeaders;
		part payload : UdpPayload;
	}
	
	part def SizedEthernetMessage :> Struct {
		part amessage : RawEthernetMessage;
		part sz : Base_Types::Unsigned_16;
	}

	part def LowLevelEthernetDriver :> Thread {
		attribute :>> Dispatch_Protocol = Supported_Dispatch_Protocols::Periodic;
		attribute :>> Period = 1000 [ms]; 
		attribute :>> Implementation_Language = Implementation_Languages::Rust;

		out port EthernetFramesRx0: EventDataPort {out :>> type : RawEthernetMessage; }
		out port EthernetFramesRx1: EventDataPort {out :>> type : RawEthernetMessage; }
		out port EthernetFramesRx2: EventDataPort {out :>> type : RawEthernetMessage; } 
		out port EthernetFramesRx3: EventDataPort {out :>> type : RawEthernetMessage; }
		in port EthernetFramesTx0: EventDataPort {in :>> type : SizedEthernetMessage; }
		in port EthernetFramesTx1: EventDataPort {in :>> type : SizedEthernetMessage; }
		in port EthernetFramesTx2: EventDataPort {in :>> type : SizedEthernetMessage; }
		in port EthernetFramesTx3: EventDataPort {in :>> type : SizedEthernetMessage; }
	}
	
	part def LowLevelEthernetDriver_seL4 :> Process {
		attribute :>> Domain = 4; 
		attribute Implementation_Language : HAMR::Implementation_Language = Implementation_Languages::Rust;

		part lowLevelEthernetDriver : LowLevelEthernetDriver; 

		out port EthernetFramesRx0: EventDataPort {out :>> type : RawEthernetMessage; }
		out port EthernetFramesRx1: EventDataPort {out :>> type : RawEthernetMessage; }
		out port EthernetFramesRx2: EventDataPort {out :>> type : RawEthernetMessage; } 
		out port EthernetFramesRx3: EventDataPort {out :>> type : RawEthernetMessage; }
		in port EthernetFramesTx0: EventDataPort {in :>> type : SizedEthernetMessage; }
		in port EthernetFramesTx1: EventDataPort {in :>> type : SizedEthernetMessage; }
		in port EthernetFramesTx2: EventDataPort {in :>> type : SizedEthernetMessage; }
		in port EthernetFramesTx3: EventDataPort {in :>> type : SizedEthernetMessage; }

		connection c1 : PortConnection 
			connect EthernetFramesTx0 to lowLevelEthernetDriver.EthernetFramesTx0;
		connection c2 : PortConnection 
			connect EthernetFramesTx1 to lowLevelEthernetDriver.EthernetFramesTx1;
		connection c3 : PortConnection 
			connect EthernetFramesTx2 to lowLevelEthernetDriver.EthernetFramesTx2;
		connection c4 : PortConnection 
			connect EthernetFramesTx3 to lowLevelEthernetDriver.EthernetFramesTx3;
			
		connection c5 : PortConnection
			connect lowLevelEthernetDriver.EthernetFramesRx0 to EthernetFramesRx0;
		connection c6 : PortConnection
			connect lowLevelEthernetDriver.EthernetFramesRx1 to EthernetFramesRx1;
		connection c7 : PortConnection
			connect lowLevelEthernetDriver.EthernetFramesRx2 to EthernetFramesRx2;
		connection c8 : PortConnection
			connect lowLevelEthernetDriver.EthernetFramesRx3 to EthernetFramesRx3;
	}
	
	part def RxFirewall :> Thread {
		in port EthernetFramesRxIn0: EventDataPort {in :>> type : RawEthernetMessage; }
		in port EthernetFramesRxIn1: EventDataPort {in :>> type : RawEthernetMessage; }
		in port EthernetFramesRxIn2: EventDataPort {in :>> type : RawEthernetMessage; } 
		in port EthernetFramesRxIn3: EventDataPort {in :>> type : RawEthernetMessage; }
		out port VmmOut0 : EventDataPort { out :>> type : RawEthernetMessage; }
		out port VmmOut1 : EventDataPort { out :>> type : RawEthernetMessage; }
		out port VmmOut2 : EventDataPort { out :>> type : RawEthernetMessage; }
		out port VmmOut3 : EventDataPort { out :>> type : RawEthernetMessage; }
		out port MavlinkOut0 : EventDataPort { out :>> type : UdpFrame; }
		out port MavlinkOut1 : EventDataPort { out :>> type : UdpFrame; }
		out port MavlinkOut2 : EventDataPort { out :>> type : UdpFrame; }
		out port MavlinkOut3 : EventDataPort { out :>> type : UdpFrame; }
		attribute :>> Dispatch_Protocol = Supported_Dispatch_Protocols::Periodic;
		attribute :>> Period = 1000[ms]; 
		//attribute :>> Compute_Execution_Time = 300 [ms];
		// attribute :>> Compute_Execution_Time : Time_Range {
		// 	attribute :>> minimum : Time { :>> num = 300[ms] }; 
		// 	attribute :>> maximum : Time { :>> num = 300[ms] }; 
		// }
		attribute :>> Stack_Size : Memory_Properties::Stack_Size = 1048576; //[byte];
		attribute :>> Implementation_Language = Implementation_Languages::Rust;			

		language "GUMBO" /*{
			functions
				def TCP_ALLOWED_PORTS(): u16Array := SW::u16Array(5760[u16], 0[u16], 0[u16], 0[u16]);
          
          		def UDP_ALLOWED_PORTS(): u16Array := SW::u16Array(68[u16], 0[u16], 0[u16], 0[u16]);
          
				// def toU16(byte: Base_Types::Unsigned_8): Base_Types::Unsigned_16 := 0[u16] + byte  ;

		        def two_bytes_to_u16(byte0: Base_Types::Unsigned_8, byte1: Base_Types::Unsigned_8): Base_Types::Unsigned_16 :=
		            byte0.toU16 * 256[u16] + byte1.toU16;
		             
		        def frame_is_wellformed_eth2(aframe: RawEthernetMessage): Base_Types::Boolean :=
           			valid_frame_ethertype(aframe) & valid_frame_dst_addr(aframe);

         		def valid_frame_ethertype(aframe: RawEthernetMessage): Base_Types::Boolean :=
            		frame_has_ipv4(aframe) | frame_has_arp(aframe) | frame_has_ipv6(aframe);     
		             
		        def valid_frame_dst_addr(aframe: RawEthernetMessage): Base_Types::Boolean :=
	              not ((aframe#(0) == 0[u8]) & 
					   (aframe#(1) == 0[u8]) &
					   (aframe#(2) == 0[u8]) &
					   (aframe#(3) == 0[u8]) &
					   (aframe#(4) == 0[u8]) &
					   (aframe#(5) == 0[u8]));
	
	            def frame_has_ipv4(aframe: RawEthernetMessage): Base_Types::Boolean := 
	                aframe#(12) == 8[u8] & aframe#(13) == 0[u8];
	          
	            def frame_has_ipv6(aframe: RawEthernetMessage): Base_Types::Boolean :=
	                aframe#(12) == 134[u8] & aframe#(13) == 221[u8];
	                    
	          	def frame_has_arp(aframe: RawEthernetMessage): Base_Types::Boolean := 
	                aframe#(12) == 8[u8] & aframe#(13) == 6[u8];
	
	            def arp_has_ipv4(aframe: RawEthernetMessage): Base_Types::Boolean := 
	                aframe#(16) == 8[u8] & aframe#(17) == 0[u8];
	          
	            def arp_has_ipv6(aframe: RawEthernetMessage): Base_Types::Boolean :=
	                aframe#(16) == 134[u8] & aframe#(17) == 221[u8];
	
		        def valid_arp_ptype(aframe: RawEthernetMessage): Base_Types::Boolean :=
	   		    	arp_has_ipv4(aframe) | arp_has_ipv6(aframe);
	
		        def valid_arp_op(aframe: RawEthernetMessage): Base_Types::Boolean :=
	  		    	aframe#(20) == 0[u8] & (aframe#(21) == 1[u8] | aframe#(21) == 2[u8]);
	
				def valid_arp_htype(aframe: RawEthernetMessage): Base_Types::Boolean :=
			    	aframe#(14) == 0[u8] & aframe#(15) == 1[u8];
	
				def wellformed_arp_frame(aframe: RawEthernetMessage): Base_Types::Boolean :=
			    	valid_arp_op(aframe) & valid_arp_htype(aframe) & valid_arp_ptype(aframe);
	
		        def valid_ipv4_length(aframe: RawEthernetMessage): Base_Types::Boolean :=
			        two_bytes_to_u16(aframe#(16), aframe#(17)) <= 9000[u16];     
		             
		        def valid_ipv4_protocol(aframe: RawEthernetMessage): Base_Types::Boolean :=
				    (aframe#(23) == 0[u8])  |
					(aframe#(23) == 1[u8])  |
					(aframe#(23) == 2[u8])  |
					(aframe#(23) == 6[u8])  |
					(aframe#(23) == 17[u8]) |
					(aframe#(23) == 43[u8]) |
					(aframe#(23) == 44[u8]) |
					(aframe#(23) == 58[u8]) |
					(aframe#(23) == 59[u8]) |
					(aframe#(23) == 60[u8]);

				def valid_ipv4_vers_ihl(aframe: RawEthernetMessage): Base_Types::Boolean :=
				    aframe#(14) == 69[u8];
				
				def wellformed_ipv4_frame(aframe: RawEthernetMessage): Base_Types::Boolean :=
				    valid_ipv4_protocol(aframe) & valid_ipv4_length(aframe) & valid_ipv4_vers_ihl(aframe);
				
				def ipv4_is_tcp(aframe: RawEthernetMessage): Base_Types::Boolean :=
					aframe#(23) == 6[u8];
				
				def ipv4_is_udp(aframe: RawEthernetMessage): Base_Types::Boolean :=
					aframe#(23) == 17[u8];
					
				def tcp_is_valid_port(aframe: RawEthernetMessage): Base_Types::Boolean :=
					two_bytes_to_u16(aframe#(36),aframe#(37)) == TCP_ALLOWED_PORTS();//#(0);

				def udp_is_valid_port(aframe: RawEthernetMessage): Base_Types::Boolean :=
					two_bytes_to_u16(aframe#(36),aframe#(37)) == UDP_ALLOWED_PORTS();//#(0);

  				def udp_is_mavlink_src_port(aframe: RawEthernetMessage): Base_Types::Boolean :=
	  				two_bytes_to_u16(aframe#(34),aframe#(35)) == 14550;

				def udp_is_mavlink_dst_port(aframe: RawEthernetMessage): Base_Types::Boolean :=
					two_bytes_to_u16(aframe#(36), aframe#(37)) == 14562;
				
				def udp_is_mavlink(aframe: RawEthernetMessage): Base_Types::Boolean :=
					udp_is_mavlink_src_port(aframe) & udp_is_mavlink_dst_port(aframe);

  				def frame_has_ipv4_tcp_on_allowed_port_quant(aframe: RawEthernetMessage): Base_Types::Boolean :=
					true;
    				//exists(0 .. 1), {in i;
        			//		TCP_ALLOWED_PORTS() == two_bytes_to_u16(aframe#(36), aframe#(37))});
    				//exists(0 .. size(TCP_ALLOWED_PORTS()), {in i;
        			//		TCP_ALLOWED_PORTS()#(i) == two_bytes_to_u16(aframe#(36), aframe#(37))});
				
  				def udp_is_valid_direct_dst_port(aframe: RawEthernetMessage): Base_Types::Boolean :=
    				true;
					//exists(0  .. 1), {in i;
      				//	UDP_ALLOWED_PORTS()#(i) == two_bytes_to_u16(aframe#(36), aframe#(37))});    
					//exists(0  .. size(UDP_ALLOWED_PORTS()), {in i;
      				//	UDP_ALLOWED_PORTS()#(i) == two_bytes_to_u16(aframe#(36), aframe#(37))});    
       		
	            def valid_arp(aframe: RawEthernetMessage): Base_Types::Boolean :=
	          		frame_is_wellformed_eth2(aframe) & frame_has_arp(aframe) & wellformed_arp_frame(aframe);
	            
	            def valid_ipv4_tcp(aframe: RawEthernetMessage): Base_Types::Boolean :=
	                frame_is_wellformed_eth2(aframe) & frame_has_ipv4(aframe) & wellformed_ipv4_frame(aframe) & ipv4_is_tcp(aframe);
	            
	            def valid_ipv4_udp(aframe: RawEthernetMessage): Base_Types::Boolean :=
	            	frame_is_wellformed_eth2(aframe) & frame_has_ipv4(aframe) & wellformed_ipv4_frame(aframe) & ipv4_is_udp(aframe);
	
				def valid_ipv4_tcp_port(aframe: RawEthernetMessage): Base_Types::Boolean :=
					valid_ipv4_tcp(aframe) & frame_has_ipv4_tcp_on_allowed_port_quant(aframe);
	
				def valid_ipv4_udp_port(aframe: RawEthernetMessage): Base_Types::Boolean :=
	            	valid_ipv4_udp(aframe) &udp_is_valid_direct_dst_port(aframe) & not udp_is_mavlink(aframe);
	
	          	def valid_ipv4_udp_mavlink(aframe: RawEthernetMessage): Base_Types::Boolean :=
	            	valid_ipv4_udp(aframe) & udp_is_mavlink(aframe);
	            
	          	def allow_outbound_frame(aframe: RawEthernetMessage): Base_Types::Boolean :=
	            	valid_arp(aframe) |
	            	valid_ipv4_udp_mavlink(aframe) |
	            	valid_ipv4_udp_port(aframe);      
			  
			  	def input_eq_mav_output_headers(aframe: RawEthernetMessage, headers: EthIpUdpHeaders): Base_Types::Boolean :=
					(0 .. size(headers)) -> forAll {in i;  headers#(i) == aframe#(i)};
					//forAll(0 .. size(headers), {in i;  headers#(i) == aframe#(i)});
	
			 	def input_eq_mav_output_payload(aframe: RawEthernetMessage, payload: UdpPayload, headers: EthIpUdpHeaders): Base_Types::Boolean :=
					(0 .. size(payload)) -> forAll {in i;  aframe#(i + size(headers)) == payload#(i)};
					//forAll(0 .. size(payload), {in i;  aframe#(i + size(headers)) == payload#(i)});
	
			  	def input_eq_mav_output(aframe: RawEthernetMessage, output: UdpFrame): Base_Types::Boolean :=
			  		input_eq_mav_output_headers(aframe, output.headers) & input_eq_mav_output_payload(aframe, output.payload, output.headers);
	            
	      compute
	
		        guarantee hlr_05_rx0_can_send_arp_to_vmm:
		          ((HasEvent(EthernetFramesRxIn0) & valid_arp(EthernetFramesRxIn0)) implies 
		            (HasEvent(VmmOut0) & (EthernetFramesRxIn0 == VmmOut0) & NoSend(MavlinkOut0)));
		        guarantee hlr_18_rx0_can_send_mavlink_udp:
		          ((HasEvent(EthernetFramesRxIn0) & valid_ipv4_udp_mavlink(EthernetFramesRxIn0)) implies 
		            (HasEvent(MavlinkOut0) & input_eq_mav_output(EthernetFramesRxIn0, MavlinkOut0) & NoSend(VmmOut0)));
		        guarantee hlr_13_rx0_can_send_ipv4_udp:
		          ((HasEvent(EthernetFramesRxIn0) & valid_ipv4_udp_port(EthernetFramesRxIn0)) implies 
		            (HasEvent(VmmOut0) & (EthernetFramesRxIn0 == VmmOut0) & NoSend(MavlinkOut0)));
		        guarantee hlr_15_rx0_disallow:
			       (HasEvent(EthernetFramesRxIn0) & not allow_outbound_frame(EthernetFramesRxIn0)) implies 
			         (NoSend(VmmOut0) & NoSend(MavlinkOut0));
		        guarantee hlr_17_rx0_no_input:
		           (not HasEvent(EthernetFramesRxIn0) implies (NoSend(VmmOut0) & NoSend(MavlinkOut0)));
		
		        guarantee hlr_05_rx1_can_send_arp_to_vmm:
		          ((HasEvent(EthernetFramesRxIn1) & valid_arp(EthernetFramesRxIn1)) implies 
		            (HasEvent(VmmOut1) & (EthernetFramesRxIn1 == VmmOut1) & NoSend(MavlinkOut1)));
		        guarantee hlr_18_rx1_can_send_mavlink_udp:
		          ((HasEvent(EthernetFramesRxIn1) & valid_ipv4_udp_mavlink(EthernetFramesRxIn1)) implies 
		            (HasEvent(MavlinkOut1) & input_eq_mav_output(EthernetFramesRxIn1, MavlinkOut1) & NoSend(VmmOut1)));
		        guarantee hlr_13_rx1_can_send_ipv4_udp:
		          ((HasEvent(EthernetFramesRxIn1) & valid_ipv4_udp_port(EthernetFramesRxIn1)) implies 
		            (HasEvent(VmmOut1) & (EthernetFramesRxIn1 == VmmOut1) & NoSend(MavlinkOut1)));
		        guarantee hlr_15_rx1_disallow:
			       (HasEvent(EthernetFramesRxIn1) & not allow_outbound_frame(EthernetFramesRxIn1)) implies 
			         (NoSend(VmmOut1) & NoSend(MavlinkOut1));
		        guarantee hlr_17_rx1_no_input:
		           (not HasEvent(EthernetFramesRxIn1) implies (NoSend(VmmOut1) & NoSend(MavlinkOut1)));
		
		        guarantee hlr_05_rx2_can_send_arp_to_vmm:
		          ((HasEvent(EthernetFramesRxIn2) & valid_arp(EthernetFramesRxIn2)) implies 
		            (HasEvent(VmmOut2) & (EthernetFramesRxIn2 == VmmOut2) & NoSend(MavlinkOut2)));
		        guarantee hlr_18_rx2_can_send_mavlink_udp:
		          ((HasEvent(EthernetFramesRxIn2) & valid_ipv4_udp_mavlink(EthernetFramesRxIn2)) implies 
		            (HasEvent(MavlinkOut2) & input_eq_mav_output(EthernetFramesRxIn2, MavlinkOut2) & NoSend(VmmOut2)));
		        guarantee hlr_13_rx2_can_send_ipv4_udp:
		          ((HasEvent(EthernetFramesRxIn2) & valid_ipv4_udp_port(EthernetFramesRxIn2)) implies 
		            (HasEvent(VmmOut2) & (EthernetFramesRxIn2 == VmmOut2) & NoSend(MavlinkOut2)));
		        guarantee hlr_15_rx2_disallow:
			       (HasEvent(EthernetFramesRxIn2) & not allow_outbound_frame(EthernetFramesRxIn2)) implies 
			         (NoSend(VmmOut2) & NoSend(MavlinkOut2));
		        guarantee hlr_17_rx2_no_input:
		           (not HasEvent(EthernetFramesRxIn2) implies (NoSend(VmmOut2) & NoSend(MavlinkOut2)));
		
		        guarantee hlr_05_rx3_can_send_arp_to_vmm:
		          ((HasEvent(EthernetFramesRxIn3) & valid_arp(EthernetFramesRxIn3)) implies 
		            (HasEvent(VmmOut3) & (EthernetFramesRxIn3 == VmmOut3) & NoSend(MavlinkOut3)));
		        guarantee hlr_18_rx3_can_send_mavlink_udp:
		          ((HasEvent(EthernetFramesRxIn3) & valid_ipv4_udp_mavlink(EthernetFramesRxIn3)) implies 
		            (HasEvent(MavlinkOut3) & input_eq_mav_output(EthernetFramesRxIn3, MavlinkOut3) & NoSend(VmmOut3)));
		        guarantee hlr_13_rx3_can_send_ipv4_udp:
		          ((HasEvent(EthernetFramesRxIn3) & valid_ipv4_udp_port(EthernetFramesRxIn3)) implies 
		            (HasEvent(VmmOut3) & (EthernetFramesRxIn3 == VmmOut3) & NoSend(MavlinkOut3)));
		        guarantee hlr_15_rx3_disallow:
			       (HasEvent(EthernetFramesRxIn3) & not allow_outbound_frame(EthernetFramesRxIn3)) implies 
			         (NoSend(VmmOut3) & NoSend(MavlinkOut3));
		        guarantee hlr_17_rx3_no_input:
		           (not HasEvent(EthernetFramesRxIn3) implies (NoSend(VmmOut3) & NoSend(MavlinkOut3)));
		 }*/
	}
	
	part def RxFirewall_seL4 :> Process {
		in port EthernetFramesRxIn0 : EventDataPort { in :> type : RawEthernetMessage; }
		in port EthernetFramesRxIn1 : EventDataPort { in :> type : RawEthernetMessage; }
		in port EthernetFramesRxIn2 : EventDataPort { in :> type : RawEthernetMessage; }
		in port EthernetFramesRxIn3 : EventDataPort { in :> type : RawEthernetMessage; }
		out port VmmOut0 : EventDataPort { out :> type : RawEthernetMessage; }
		out port VmmOut1 : EventDataPort { out :> type : RawEthernetMessage; }
		out port VmmOut2 : EventDataPort { out :> type : RawEthernetMessage; }
		out port VmmOut3 : EventDataPort { out :> type : RawEthernetMessage; }
		out port MavlinkOut0 : EventDataPort { out :> type : UdpFrame; }
		out port MavlinkOut1 : EventDataPort { out :> type : UdpFrame; }
		out port MavlinkOut2 : EventDataPort { out :> type : UdpFrame; }
		out port MavlinkOut3 : EventDataPort { out :> type : UdpFrame; }

		part firewall : RxFirewall;
		connection c1 : PortConnection 
			connect EthernetFramesRxIn0 to firewall.EthernetFramesRxIn0;
		connection c2 : PortConnection 
			connect EthernetFramesRxIn1 to firewall.EthernetFramesRxIn1;
		connection c3 : PortConnection 
			connect EthernetFramesRxIn2 to firewall.EthernetFramesRxIn2;
		connection c4 : PortConnection 
			connect EthernetFramesRxIn3 to firewall.EthernetFramesRxIn3;	
		connection c5 : PortConnection
			connect firewall.VmmOut0 to VmmOut0;
		connection c6 : PortConnection
			connect firewall.VmmOut1 to VmmOut1;
		connection c7 : PortConnection
			connect firewall.VmmOut2 to VmmOut2;
		connection c8 : PortConnection
			connect firewall.VmmOut3 to VmmOut3;
		connection c9 : PortConnection
			connect firewall.MavlinkOut0 to MavlinkOut0;
		connection c10 : PortConnection
			connect firewall.MavlinkOut1 to MavlinkOut1;
		connection c11 : PortConnection
			connect firewall.MavlinkOut2 to MavlinkOut2;
		connection c12 : PortConnection
			connect firewall.MavlinkOut3 to MavlinkOut3;
			
		attribute :>> Domain = 5;	
		attribute Implementation_Language : HAMR::Implementation_Language = Implementation_Languages::Rust;
	}
	
	part def TxFirewall :> Thread {
		in port EthernetFramesTxIn0 : EventDataPort { in :> type : RawEthernetMessage; }
		in port EthernetFramesTxIn1 : EventDataPort { in :> type : RawEthernetMessage; }
		in port EthernetFramesTxIn2 : EventDataPort { in :> type : RawEthernetMessage; }
		in port EthernetFramesTxIn3 : EventDataPort { in :> type : RawEthernetMessage; }
		out port EthernetFramesTxOut0 : EventDataPort { out :> type : SizedEthernetMessage; }
		out port EthernetFramesTxOut1 : EventDataPort { out :> type : SizedEthernetMessage; }
		out port EthernetFramesTxOut2 : EventDataPort { out :> type : SizedEthernetMessage; }
		out port EthernetFramesTxOut3 : EventDataPort { out :> type : SizedEthernetMessage; }
	
		attribute :>> Dispatch_Protocol = Supported_Dispatch_Protocols::Periodic;
		attribute :>> Period = 1000 [ms];
		// attribute :>> Compute_Execution_Time = 300[ms];
		attribute :>> Stack_Size : Memory_Properties::Stack_Size = 1048576; //[byte];
		attribute :>> Implementation_Language : HAMR::Implementation_Language = Implementation_Languages::Rust;
		
		language "GUMBO" /*{
			 functions
	          def two_bytes_to_u16(byte0: Base_Types::Unsigned_8, byte1: Base_Types::Unsigned_8): Base_Types::Unsigned_16 :=
	              byte0.toU16 * 256[u16] + byte1.toU16; 
	          
	          def frame_is_wellformed_eth2(aframe: RawEthernetMessage): Base_Types::Boolean :=
	            valid_frame_ethertype(aframe) & valid_frame_dst_addr(aframe);
	
	          def valid_frame_ethertype(aframe: RawEthernetMessage): Base_Types::Boolean :=
	            frame_has_ipv4(aframe) | frame_has_arp(aframe) | frame_has_ipv6(aframe);
	            
	          def valid_frame_dst_addr(aframe: RawEthernetMessage): Base_Types::Boolean :=
	              not ((aframe#(0) == 0[u8]) &
					(aframe#(1) == 0[u8]) &
					(aframe#(2) == 0[u8]) &
					(aframe#(3) == 0[u8]) &
					(aframe#(4) == 0[u8]) &
					(aframe#(5) == 0[u8]));
	
	          def frame_has_ipv4(aframe: RawEthernetMessage): Base_Types::Boolean := 
	              aframe#(12) == 8[u8] & aframe#(13) == 0[u8];
	          
	          def frame_has_ipv6(aframe: RawEthernetMessage): Base_Types::Boolean :=
	              aframe#(12) == 134[u8] & aframe#(13) == 221[u8];
	                    
	          def frame_has_arp(aframe: RawEthernetMessage): Base_Types::Boolean := 
	              aframe#(12) == 8[u8] & aframe#(13) == 6[u8];
	
	          def arp_has_ipv4(aframe: RawEthernetMessage): Base_Types::Boolean := 
	              aframe#(16) == 8[u8] & aframe#(17) == 0[u8];
	          
	          def arp_has_ipv6(aframe: RawEthernetMessage): Base_Types::Boolean :=
	              aframe#(16) == 134[u8] & aframe#(17) == 221[u8];
	
		      def valid_arp_ptype(aframe: RawEthernetMessage): Base_Types::Boolean :=
			      arp_has_ipv4(aframe) | arp_has_ipv6(aframe);
	
		      def valid_arp_op(aframe: RawEthernetMessage): Base_Types::Boolean :=
			      aframe#(20) == 0[u8] & (aframe#(21) == 1[u8] | aframe#(21) == 2[u8]);
	
		      def valid_arp_htype(aframe: RawEthernetMessage): Base_Types::Boolean :=
			      aframe#(14) == 0[u8] & aframe#(15) == 1[u8];
	
		      def wellformed_arp_frame(aframe: RawEthernetMessage): Base_Types::Boolean :=
			      valid_arp_op(aframe) & valid_arp_htype(aframe) & valid_arp_ptype(aframe);
	
		      def ipv4_length(aframe: RawEthernetMessage): Base_Types::Unsigned_16 :=
			      two_bytes_to_u16(aframe#(16),aframe#(17));
	
		      def valid_ipv4_length(aframe: RawEthernetMessage): Base_Types::Boolean :=
			      ipv4_length(aframe) <= 9000[u16];
	
		      def valid_ipv4_protocol(aframe: RawEthernetMessage): Base_Types::Boolean :=
			      (aframe#(23) == 0[u8])  |
				  (aframe#(23) == 1[u8])  |
				  (aframe#(23) == 2[u8])  |
				  (aframe#(23) == 6[u8])  |
				  (aframe#(23) == 17[u8]) |
				  (aframe#(23) == 43[u8]) |
				  (aframe#(23) == 44[u8]) |
				  (aframe#(23) == 58[u8]) |
				  (aframe#(23) == 59[u8]) |
				  (aframe#(23) == 60[u8]);
	
		      def valid_ipv4_vers_ihl(aframe: RawEthernetMessage): Base_Types::Boolean :=
			      aframe#(14) == 69[u8];
	
		      def wellformed_ipv4_frame(aframe: RawEthernetMessage): Base_Types::Boolean :=
			      valid_ipv4_protocol(aframe) & valid_ipv4_length(aframe) & valid_ipv4_vers_ihl(aframe);
	            
	//        --------------------------------------------------------------------------
	//        -- TX Firewall
	//        --------------------------------------------------------------------------
	          
	          def valid_ipv6(aframe: RawEthernetMessage): Base_Types::Boolean :=
	            frame_is_wellformed_eth2(aframe) & frame_has_ipv6(aframe);
	            
	          def valid_arp(aframe: RawEthernetMessage): Base_Types::Boolean :=
	            frame_is_wellformed_eth2(aframe) & frame_has_arp(aframe) & wellformed_arp_frame(aframe);
	            
	          def valid_ipv4(aframe: RawEthernetMessage): Base_Types::Boolean :=
	            frame_is_wellformed_eth2(aframe) & frame_has_ipv4(aframe) & wellformed_ipv4_frame(aframe);
	
	          def valid_output_arp_size(output: SizedEthernetMessage): Base_Types::Boolean :=
	            output.sz == 64[u16];
	
	          def valid_output_ipv4_size(input: RawEthernetMessage, output: SizedEthernetMessage): Base_Types::Boolean :=
	            output.sz == (ipv4_length(input)+14[u16]);
	
	          def allow_outbound_frame(aframe: RawEthernetMessage): Base_Types::Boolean :=
	            valid_arp(aframe) |
	            valid_ipv4(aframe);
	       
	      compute
	
	      	guarantee hlr_07_tx0_can_send_valid_arp:
	          ((HasEvent(EthernetFramesTxIn0) & valid_arp(EthernetFramesTxIn0)) implies 
	            (HasEvent(EthernetFramesTxOut0) & (EthernetFramesTxIn0 == EthernetFramesTxOut0.amessage) & valid_output_arp_size(EthernetFramesTxOut0)));
	        guarantee hlr_12_tx0_can_send_valid_ipv4:
	          ((HasEvent(EthernetFramesTxIn0) & valid_ipv4(EthernetFramesTxIn0)) implies 
	            (HasEvent(EthernetFramesTxOut0) & (EthernetFramesTxIn0 == EthernetFramesTxOut0.amessage) & valid_output_ipv4_size(EthernetFramesTxIn0, EthernetFramesTxOut0) ));
	        guarantee hlr_14_tx0_disallow:
		       (HasEvent(EthernetFramesTxIn0) & not allow_outbound_frame(EthernetFramesTxIn0)) implies 
		         (NoSend(EthernetFramesTxOut0));
	        guarantee hlr_16_tx0_no_input:
	           (not HasEvent(EthernetFramesTxIn0) implies NoSend(EthernetFramesTxOut0));
	
	        guarantee hlr_07_tx1_can_send_valid_arp:
	          ((HasEvent(EthernetFramesTxIn1) & valid_arp(EthernetFramesTxIn1)) implies 
	            (HasEvent(EthernetFramesTxOut1) & (EthernetFramesTxIn1 == EthernetFramesTxOut1.amessage) & valid_output_arp_size(EthernetFramesTxOut1) ));
	        guarantee hlr_12_tx1_can_send_valid_ipv4:
	          ((HasEvent(EthernetFramesTxIn1) & valid_ipv4(EthernetFramesTxIn1)) implies 
	            (HasEvent(EthernetFramesTxOut1) & (EthernetFramesTxIn1 == EthernetFramesTxOut1.amessage) & valid_output_ipv4_size(EthernetFramesTxIn1, EthernetFramesTxOut1) ));
	        guarantee hlr_14_tx1_disallow:
		       (HasEvent(EthernetFramesTxIn1) & not allow_outbound_frame(EthernetFramesTxIn1)) implies 
		         (NoSend(EthernetFramesTxOut1));
	        guarantee hlr_16_tx1_no_input:
	           (not HasEvent(EthernetFramesTxIn1) implies NoSend(EthernetFramesTxOut1));
	
	        guarantee hlr_07_tx2_can_send_valid_arp:
	          ((HasEvent(EthernetFramesTxIn2) & valid_arp(EthernetFramesTxIn2)) implies 
	            (HasEvent(EthernetFramesTxOut2) & (EthernetFramesTxIn2 == EthernetFramesTxOut2.amessage) & valid_output_arp_size(EthernetFramesTxOut2) ));
	        guarantee hlr_12_tx2_can_send_valid_ipv4:
	          ((HasEvent(EthernetFramesTxIn2) & valid_ipv4(EthernetFramesTxIn2)) implies 
	            (HasEvent(EthernetFramesTxOut2) & (EthernetFramesTxIn2 == EthernetFramesTxOut2.amessage) & valid_output_ipv4_size(EthernetFramesTxIn2, EthernetFramesTxOut2) ));
	        guarantee hlr_14_tx2_disallow:
		       (HasEvent(EthernetFramesTxIn2) & not allow_outbound_frame(EthernetFramesTxIn2)) implies 
		         (NoSend(EthernetFramesTxOut2));
	        guarantee hlr_16_tx2_no_input:
	           (not HasEvent(EthernetFramesTxIn2) implies NoSend(EthernetFramesTxOut2));
	
	        guarantee hlr_07_tx3_can_send_valid_arp:
	          ((HasEvent(EthernetFramesTxIn3) & valid_arp(EthernetFramesTxIn3)) implies 
	            (HasEvent(EthernetFramesTxOut3) & (EthernetFramesTxIn3 == EthernetFramesTxOut3.amessage) & valid_output_arp_size(EthernetFramesTxOut3) ));
	        guarantee hlr_12_tx3_can_send_valid_ipv4:
	          ((HasEvent(EthernetFramesTxIn3) & valid_ipv4(EthernetFramesTxIn3)) implies 
	            (HasEvent(EthernetFramesTxOut3) & (EthernetFramesTxIn3 == EthernetFramesTxOut3.amessage) & valid_output_ipv4_size(EthernetFramesTxIn3, EthernetFramesTxOut3) ));
	        guarantee hlr_14_tx3_disallow:
		       (HasEvent(EthernetFramesTxIn3) & not allow_outbound_frame(EthernetFramesTxIn3)) implies 
		         (NoSend(EthernetFramesTxOut3));
	        guarantee hlr_16_tx3_no_input:
	           (not HasEvent(EthernetFramesTxIn3) implies NoSend(EthernetFramesTxOut3));
	           	  
		}*/
	}
	
	part def TxFirewall_seL4 :> Process {
		in port EthernetFramesTxIn0 : EventDataPort { in :>> type : RawEthernetMessage; }
		in port EthernetFramesTxIn1 : EventDataPort { in :>> type : RawEthernetMessage; }
		in port EthernetFramesTxIn2 : EventDataPort { in :>> type : RawEthernetMessage; }
		in port EthernetFramesTxIn3 : EventDataPort { in :>> type : RawEthernetMessage; }
		out port EthernetFramesTxOut0 : EventDataPort { out :>> type : SizedEthernetMessage; }
		out port EthernetFramesTxOut1 : EventDataPort { out :>> type : SizedEthernetMessage; }
		out port EthernetFramesTxOut2 : EventDataPort { out :>> type : SizedEthernetMessage; }
		out port EthernetFramesTxOut3 : EventDataPort { out :>> type : SizedEthernetMessage; }
	
		part firewall : TxFirewall;
		
		connection c1 : PortConnection 
			connect EthernetFramesTxIn0 to firewall.EthernetFramesTxIn0;
		connection c2 : PortConnection 
			connect EthernetFramesTxIn1 to firewall.EthernetFramesTxIn1;
		connection c3 : PortConnection 
			connect EthernetFramesTxIn2 to firewall.EthernetFramesTxIn2;
		connection c4 : PortConnection 
			connect EthernetFramesTxIn3 to firewall.EthernetFramesTxIn3;	
		connection c5 : PortConnection
			connect firewall.EthernetFramesTxOut0 to EthernetFramesTxOut0;
		connection c6 : PortConnection
			connect firewall.EthernetFramesTxOut1 to EthernetFramesTxOut1;
		connection c7 : PortConnection
			connect firewall.EthernetFramesTxOut2 to EthernetFramesTxOut2;
		connection c8 : PortConnection
			connect firewall.EthernetFramesTxOut3 to EthernetFramesTxOut3;
			
		attribute :>> Domain : CASE_Scheduling::Domain = 3; 
		attribute Implementation_Language : HAMR::Implementation_Language = Implementation_Languages::Rust;
	}
	
	part def MavlinkFirewall :> Thread {
		in port In0 : EventDataPort { in :>> type : UdpFrame; }
		in port In1 : EventDataPort { in :>> type : UdpFrame; }
		in port In2 : EventDataPort { in :>> type : UdpFrame; }
		in port In3 : EventDataPort { in :>> type : UdpFrame; }
		out port Out0 : EventDataPort { out :>> type : RawEthernetMessage; }
		out port Out1 : EventDataPort { out :>> type : RawEthernetMessage; }
		out port Out2 : EventDataPort { out :>> type : RawEthernetMessage; }
		out port Out3 : EventDataPort { out :>> type : RawEthernetMessage; }
		
		attribute :>> Dispatch_Protocol = Supported_Dispatch_Protocols::Periodic;
		attribute :>> Period = 1000[ms]; 
		// attribute :>> Compute_Execution_Time = 300 [ms];
		// attribute :>> Compute_Execution_Time : Time_Range {
		// 	attribute :>> minimum : Time { attribute :>> num = 300[ms]; }
		// 	attribute :>> maximum : Time { attribute :>> num = 300[ms]; }
		// }
		attribute :>> Stack_Size : Memory_Properties::Stack_Size = 1048576; //[byte];
		attribute :>> Implementation_Language : HAMR::Implementation_Language = Implementation_Languages::Rust;
		attribute :>> Source_Text  = "src/MavlinkFirewall.c";
		attribute Initialize_Entrypoint_Source_Text : ScalarValues::String = "init";
		attribute Compute_Entrypoint_Source_Text : ScalarValues::String = "compute";
		
		language "GUMBO" /*{
		
			functions
		      def three_bytes_to_u32(byte0: Base_Types::Unsigned_8, byte1: Base_Types::Unsigned_8, byte2: Base_Types::Unsigned_8): Base_Types::Unsigned_32 :=
			  	32[u32];
	          //  toU32(byte2) * 65536[u32] + toU32(byte1) * 256[u32] + toU32(byte0);
	
	          def two_bytes_to_u16(byte0: Base_Types::Unsigned_8, byte1: Base_Types::Unsigned_8): Base_Types::Unsigned_16 :=
			  	32[u16];
	          //  toU16(byte1) * 256[u16] + toU16(byte0);
	
			  def msg_v1_is_command_int(msg: UdpPayload): Base_Types::Boolean :=
				msg#(5) == 75[u8];
	
			  def command_int_msg_v1_is_bootloader_flash(msg: UdpPayload): Base_Types::Boolean :=
				two_bytes_to_u16(msg#(33), msg#(34)) == 42650[u16];
	          
			  def msg_v1_is_command_long(msg: UdpPayload): Base_Types::Boolean :=
				msg#(5) == 76[u8];
			
			  def command_long_msg_v1_is_bootloader_flash(msg: UdpPayload): Base_Types::Boolean :=
				two_bytes_to_u16(msg#(34), msg#(35)) == 42650[u16];
	
			  def msg_is_mavlinkv1(msg: UdpPayload): Base_Types::Boolean :=
			    msg#(0) == 254[u8]; //"0xFE"
	
			  def msg_v2_is_command_int(msg: UdpPayload): Base_Types::Boolean :=
				three_bytes_to_u32(msg#(7), msg#(8), msg#(9)) == 75[u32];
	
			  def command_int_msg_v2_is_bootloader_flash(msg: UdpPayload): Base_Types::Boolean :=
				two_bytes_to_u16(msg#(37), msg#(38)) == 42650[u16];
	          
			  def msg_v2_is_command_long(msg: UdpPayload): Base_Types::Boolean :=
				three_bytes_to_u32(msg#(7), msg#(8), msg#(9)) == 76[u32];
			
			  def command_long_msg_v2_is_bootloader_flash(msg: UdpPayload): Base_Types::Boolean :=
				two_bytes_to_u16(msg#(38), msg#(39)) == 42650[u16];
	
			  def msg_is_mavlinkv2(msg: UdpPayload): Base_Types::Boolean :=
			    msg#(0) == 253[u8]; //"0xFD"
	
	
			  def msg_is_mav_v2_cmd_flash_bootloader(msg: UdpPayload): Base_Types::Boolean :=
				msg_is_mavlinkv2(msg) & ((msg_v2_is_command_int(msg) & command_int_msg_v2_is_bootloader_flash(msg)) |
				(msg_v2_is_command_long(msg) & command_long_msg_v2_is_bootloader_flash(msg)));
	
			  def msg_is_mav_v1_cmd_flash_bootloader(msg: UdpPayload): Base_Types::Boolean :=
				msg_is_mavlinkv1(msg) & ((msg_v1_is_command_int(msg) & command_int_msg_v1_is_bootloader_flash(msg)) |
				(msg_v1_is_command_long(msg) & command_long_msg_v1_is_bootloader_flash(msg)));
	
			  def msg_is_mav_cmd_flash_bootloader(msg: UdpPayload): Base_Types::Boolean :=
				msg_is_mav_v2_cmd_flash_bootloader(msg) | msg_is_mav_v1_cmd_flash_bootloader(msg);
	
			  def mav_input_headers_eq_output(headers: EthIpUdpHeaders, aframe: RawEthernetMessage): Base_Types::Boolean :=
	            	true; 
					//(forAll(0 .. size(headers), {in i; headers#(i) == aframe#(i)}));
	
			  def mav_input_payload_eq_output(payload: UdpPayload, headers: EthIpUdpHeaders, aframe: RawEthernetMessage): Base_Types::Boolean :=
					true;
					//(forAll(0 .. size(payload), {in i; aframe#(i + size(headers)) == payload#(i)}));
	
			  def mav_input_eq_output(input: UdpFrame, aframe: RawEthernetMessage): Base_Types::Boolean :=
			  		mav_input_headers_eq_output(input.headers, aframe) & mav_input_payload_eq_output(input.payload, input.headers, aframe);
	
			  def msg_is_blacklisted(msg: UdpPayload): Base_Types::Boolean :=
				  msg_is_mav_cmd_flash_bootloader(msg);
	     
	      compute
	
				guarantee hlr_19_mav0_drop_mav_cmd_flash_bootloader:
				  ((HasEvent(In0) & msg_is_mav_cmd_flash_bootloader(In0.payload)) implies
				    (NoSend(Out0)));
				guarantee hlr_21_mav0_no_input:
				   (not HasEvent(In0) implies (NoSend(Out0)));
				guarantee hlr_22_mav0_allow:
				   (HasEvent(In0) & not msg_is_blacklisted(In0.payload)) implies 
				     (HasEvent(Out0) & mav_input_eq_output(In0, Out0));
		}*/			
	}
	
	part def MavlinkFirewall_seL4 :> Process {
		in port In0 : EventDataPort { in :>> type : UdpFrame; }
		in port In1 : EventDataPort { in :>> type : UdpFrame; }
		in port In2 : EventDataPort { in :>> type : UdpFrame; }
		in port In3 : EventDataPort { in :>> type : UdpFrame; }
		out port Out0 : EventDataPort { out :>> type : RawEthernetMessage; }
		out port Out1 : EventDataPort { out :>> type : RawEthernetMessage; }
		out port Out2 : EventDataPort { out :>> type : RawEthernetMessage; }
		out port Out3 : EventDataPort { out :>> type : RawEthernetMessage; }
		
		part mavlinkFirewall : MavlinkFirewall;
		
		connection c1 : PortConnection
			connect In0 to mavlinkFirewall.In0;
		connection c2 : PortConnection
			connect In1 to mavlinkFirewall.In1;
		connection c3 : PortConnection
			connect In2 to mavlinkFirewall.In2;
		connection c4 : PortConnection
			connect In3 to mavlinkFirewall.In3;
		connection c5 : PortConnection
			connect mavlinkFirewall.Out0 to Out0;
		connection c6 : PortConnection
			connect mavlinkFirewall.Out1 to Out1;
		connection c7 : PortConnection
			connect mavlinkFirewall.Out2 to Out2;
		connection c8 : PortConnection
			connect mavlinkFirewall.Out3 to Out3;
			
		attribute :>> Domain = 6;
		attribute Implementation_Language : HAMR::Implementation_Language = Implementation_Languages::Rust;
	}
	
	part def ArduPilot :> Thread {
		in port FirewallRx0 : EventDataPort { in :>> type : RawEthernetMessage; }
		in port FirewallRx1 : EventDataPort { in :>> type : RawEthernetMessage; }
		in port FirewallRx2 : EventDataPort { in :>> type : RawEthernetMessage; }
		in port FirewallRx3 : EventDataPort { in :>> type : RawEthernetMessage; }
		out port MavlinkRx0 : EventDataPort { out :>> type : RawEthernetMessage; }
		out port MavlinkRx1 : EventDataPort { out :>> type : RawEthernetMessage; }
		out port MavlinkRx2 : EventDataPort { out :>> type : RawEthernetMessage; }
		out port MavlinkRx3 : EventDataPort { out :>> type : RawEthernetMessage; }
		out port EthernetFramesTx0 : EventDataPort { out :>> type : RawEthernetMessage; }
		out port EthernetFramesTx1 : EventDataPort { out :>> type : RawEthernetMessage; }
		out port EthernetFramesTx2 : EventDataPort { out :>> type : RawEthernetMessage; }
		out port EthernetFramesTx3 : EventDataPort { out :>> type : RawEthernetMessage; }
	
		attribute :>> Dispatch_Protocol = Supported_Dispatch_Protocols::Periodic;
		attribute :>> Period = 1000 [ms]; 
		// attribute :>> Compute_Execution_Time = 600 [ms];
		// attribute :>> Compute_Execution_Time : Time_Range { 
		// 	attribute :>> minimum = 600[ms]; 
		// 	attribute :>> maximum = 600[ms]; 
		// }
		attribute :>> Stack_Size : Memory_Properties::Stack_Size = 1048576; //[byte];
		attribute :>> Source_Text = "src/Ardupilot.c";
		attribute Initialize_Entrypoint_Source_Text : ScalarValues::String = "init";
		attribute Compute_Entrypoint_Source_Text : ScalarValues::String = "compute";
	}
	
	part def ArduPilot_seL4 :> Process {
		in port FirewallRx0 : EventDataPort { in :>> type : RawEthernetMessage; }
		in port FirewallRx1 : EventDataPort { in :>> type : RawEthernetMessage; }
		in port FirewallRx2 : EventDataPort { in :>> type : RawEthernetMessage; }
		in port FirewallRx3 : EventDataPort { in :>> type : RawEthernetMessage; }
		out port MavlinkRx0 : EventDataPort { out :>> type : RawEthernetMessage; }
		out port MavlinkRx1 : EventDataPort { out :>> type : RawEthernetMessage; }
		out port MavlinkRx2 : EventDataPort { out :>> type : RawEthernetMessage; }
		out port MavlinkRx3 : EventDataPort { out :>> type : RawEthernetMessage; }
		out port EthernetFramesTx0 : EventDataPort { out :>> type : RawEthernetMessage; }
		out port EthernetFramesTx1 : EventDataPort { out :>> type : RawEthernetMessage; }
		out port EthernetFramesTx2 : EventDataPort { out :>> type : RawEthernetMessage; }
		out port EthernetFramesTx3 : EventDataPort { out :>> type : RawEthernetMessage; }
	
		part arduPilot : ArduPilot;
		
		connection c1 : PortConnection 
			connect FirewallRx0 to arduPilot.FirewallRx0;
		connection c2 : PortConnection 
			connect FirewallRx1 to arduPilot.FirewallRx1;
		connection c3 : PortConnection 
			connect FirewallRx2 to arduPilot.FirewallRx2;
		connection c4 : PortConnection 
			connect FirewallRx3 to arduPilot.FirewallRx3;
		connection c5 : PortConnection
			connect arduPilot.MavlinkRx0 to MavlinkRx0;
		connection c6 : PortConnection
			connect arduPilot.MavlinkRx1 to MavlinkRx1;
		connection c7 : PortConnection
			connect arduPilot.MavlinkRx2 to MavlinkRx2;
		connection c8 : PortConnection
			connect arduPilot.MavlinkRx3 to MavlinkRx3;
		// connection c5 : PortConnection
		// 	connect MavlinkRx0 to arduPilot.MavlinkRx0;
		// connection c6 : PortConnection
		// 	connect MavlinkRx1 to arduPilot.MavlinkRx1;
		// connection c7 : PortConnection
		// 	connect MavlinkRx2 to arduPilot.MavlinkRx2;
		// connection c8 : PortConnection
		// 	connect MavlinkRx3 to arduPilot.MavlinkRx3;
		connection c9 : PortConnection
			connect arduPilot.EthernetFramesTx0 to EthernetFramesTx0;
		connection c10 : PortConnection
			connect arduPilot.EthernetFramesTx1 to EthernetFramesTx1;
		connection c11 : PortConnection
			connect arduPilot.EthernetFramesTx2 to EthernetFramesTx2;
		connection c12 : PortConnection
			connect arduPilot.EthernetFramesTx3 to EthernetFramesTx3;
			
		attribute :>> Domain = 2;
		attribute SMC : ScalarValues::Boolean = true;
	} 

	part def seL4 :> System {
		part arduPilot : ArduPilot_seL4;
		part mavlinkFirewall : MavlinkFirewall_seL4;
		part rxFirewall : RxFirewall_seL4;
		part txFirewall : TxFirewall_seL4;
		part lowLevelEthernetDriver : LowLevelEthernetDriver_seL4;

		attribute Domain : CASE_Scheduling::Domain = 2;
		connection c1 : PortConnection
			connect lowLevelEthernetDriver.EthernetFramesRx0 to rxFirewall.EthernetFramesRxIn0;
		connection c2 : PortConnection
			connect lowLevelEthernetDriver.EthernetFramesRx1 to rxFirewall.EthernetFramesRxIn1;
		connection c3 : PortConnection
			connect lowLevelEthernetDriver.EthernetFramesRx2 to rxFirewall.EthernetFramesRxIn2;
		connection c4 : PortConnection
			connect lowLevelEthernetDriver.EthernetFramesRx3 to rxFirewall.EthernetFramesRxIn3;
		
		connection c5 : PortConnection
			connect rxFirewall.VmmOut0 to arduPilot.FirewallRx0;
		connection c6 : PortConnection
			connect rxFirewall.VmmOut1 to arduPilot.FirewallRx1;
		connection c7 : PortConnection
			connect rxFirewall.VmmOut2 to arduPilot.FirewallRx2;
		connection c8 : PortConnection
			connect rxFirewall.VmmOut3 to arduPilot.FirewallRx3;
			
		connection c9 : PortConnection
			connect rxFirewall.MavlinkOut0 to mavlinkFirewall.In0;
		connection c10 : PortConnection
			connect rxFirewall.MavlinkOut1 to mavlinkFirewall.In1;
		connection c11 : PortConnection
			connect rxFirewall.MavlinkOut2 to mavlinkFirewall.In2;
		connection c12 : PortConnection
			connect rxFirewall.MavlinkOut3 to mavlinkFirewall.In3;
		
		connection c13 : PortConnection
			connect mavlinkFirewall.Out0 to arduPilot.MavlinkRx0;
		connection c14 : PortConnection
			connect mavlinkFirewall.Out1 to arduPilot.MavlinkRx1;
		connection c15 : PortConnection
			connect mavlinkFirewall.Out2 to arduPilot.MavlinkRx2;
		connection c16 : PortConnection
			connect mavlinkFirewall.Out3 to arduPilot.MavlinkRx3;
		
		connection c17 : PortConnection
			connect arduPilot.EthernetFramesTx0 to txFirewall.EthernetFramesTxOut0;
		connection c18 : PortConnection
			connect arduPilot.EthernetFramesTx1 to txFirewall.EthernetFramesTxOut1;
		connection c19 : PortConnection
			connect arduPilot.EthernetFramesTx2 to txFirewall.EthernetFramesTxOut2;
		connection c20 : PortConnection
			connect arduPilot.EthernetFramesTx3 to txFirewall.EthernetFramesTxOut3;
		
		connection c21 : PortConnection
			connect txFirewall.EthernetFramesTxOut0 to lowLevelEthernetDriver.EthernetFramesTx0;
		connection c22 : PortConnection
			connect txFirewall.EthernetFramesTxOut1 to lowLevelEthernetDriver.EthernetFramesTx1;
		connection c23 : PortConnection
			connect txFirewall.EthernetFramesTxOut2 to lowLevelEthernetDriver.EthernetFramesTx2;
		connection c24 : PortConnection
			connect txFirewall.EthernetFramesTxOut3 to lowLevelEthernetDriver.EthernetFramesTx3;
	}	
}