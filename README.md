# HDLC-Deframer
HDLC deframer can be used to convert framer to packets. The deframer modifies the bytes streams output of the framer to discrete packets, adding SOP and EOP. It also verifies the CRC over the packet and generate an error signal if there is CRC mismatch.
