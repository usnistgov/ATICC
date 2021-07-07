# Example InSpec Profile

This example shows the implementation of an InSpec profile.


Controls Architecture:
- 4 Profiles for each section of the TIC 3.0 Network PEP Requirements:
    1. Tests on the Good Guy Client (GGC)
    2. Tests on the Bad Guy Client (GBC)
    3. Tests on the SDP Controller (SDP)
    4. *Tests on the SDP Gateway (GW)
- TIC Sections:
    1. Access Control (ac)
    2. IP Deny-listing (ip)
    3. Host Containment (hc)
    4. Network Segmentations (ns)
    5. Micro Segmentation (ms)
    6. ** AC/IA Controls **

- Full InSpec Run Command:
    ```bash
    docker run -it --rm -v /var/run/docker.sock:/var/run/docker.sock -v <path_to_Profile_dir>:/profile chef/inspec exec /profile/<choosen_inspec_profile> --input-file /profile/input_file.yml -t docker://<target_container_name>
    ```
