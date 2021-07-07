# copyright: 2021, The Hackers

title "Active Micro-Segmentation Tests for a Good Guy Client"

control "MS-Unique_Connection-GGC" do
  impact 0.7
  title "Micro-Segmentation: Unique Connection - Good Guy Client"

  # 1.  fwknop with EACH credentials
  # 2.  telnet or ssh to EACH address
  # 3.  traceroute to check if each connection is diffenet
end

control "MS-Restricted_Scope-GGC" do
  impact 0.7
  title "Micro-Segmentation: Restricted Scope - Good Guy Client"

  # 1.  fwknop with EACH credentials
  # 2.  check:
  #   a.  tries incorrect connection protocol for EACH address
  #       (telnet on ssh) and (ssh on telnet)
  #   b.  user tries to access unauthorized services for EACH address
  #       ()
end
