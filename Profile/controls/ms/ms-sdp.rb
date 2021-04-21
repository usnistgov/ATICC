# copyright: 2021, The Hackers

title "Active Micro-Segmentation Tests for the SDP Controller"

control "MS-Unique_Connection-SDP" do
  impact 0.7
  title "Micro-Segmentation: Unique Connection - SDP Controller"

  # check each service gets its own port
end

control "MS-Restricted_Scope-SDP" do
  impact 0.7
  title "Micro-Segmentation: Restricted Scope - SDP Controller"

  # check that each client had defined services
end
