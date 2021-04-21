# Example InSpec Profile

This example shows the implementation of an InSpec profile.


Controls Architecture:
- 3 Controls for each section of the TIC 3.0 Network PEP Requirements:
    1. Tests on the Good Guy Client (ggc)
    2. Tests on the Bad Guy Client (bgc)
    3. Tests on the SDP Controller (sdp)
    4. *Tests on the SDP Gateway (gw)
- TIC Sections:
    1. Access Control (ac)
    2. IP Deny-listing (ip)
    3. Host Containment (hc)
    4. Network Segmentations (ns)
    5. Micro Segmentation (ms)
    6. ** AC/IA Controls **
