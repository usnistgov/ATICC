title "Active Micro-Segmentation Tests for the SDP Controller"

sql = mysql_session(input('sdpcontroller_mysql_username'), input('sdpcontroller_mysql_password'))

describe sql.query('select count(*) cnt from user_constraints where table_name=$$$ and constraint_type=0') do
  its('stdout') { should_not match(/text/) }
end

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
