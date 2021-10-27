title "Active Micro-Segmentation Tests for the SDP Controller"

control "MS-Unique_Connection-SDP" do
  impact 0.7
  title "Microsegmentation: Unique Connection - SDP Controller"
  desc "Microsegmentation divides the network, either physically or virtually, according to the communication needs of application and data workflows, facilitating security controls to protect the data."
  tag "Capability":"Network"
  tag "TIC Version":"3.0"
  tag "Microsegmentation"
  tag "Unique Connection"
  tag "NoState"

  # check each service gets its own port
  sql = mysql_session(input('sdpcontroller_mysql_username'), input('sdpcontroller_mysql_password'))

  describe sql.query('
    -- check each service gets its own port
    select
      case
        when count(distinct port) = count(port)
          then true
          else false
      end `unique?`
    from sdp.service_gateway;
  ') do
    its('stdout') { should match("1") }
  end
end

control "MS-Restricted_Scope-SDP" do
  impact 0.7
  title "Microsegmentation: Unique Connection - SDP Controller"
  desc "Microsegmentation divides the network, either physically or virtually, according to the communication needs of application and data workflows, facilitating security controls to protect the data."
  tag "Capability":"Network"
  tag "TIC Version":"3.0"
  tag "Microsegmentation"
  tag "Restricted Scope"
  tag "NoState"

  # check that each client has defined services
  sql = mysql_session(input('sdpcontroller_mysql_username'), input('sdpcontroller_mysql_password'))

  describe sql.query('
    -- check that each client has defined services
    select
    	case
    		when count(*) > 0
          then true
  		    else false
    	end `has_services?`
    from sdp.sdpid_service
    where sdpid = 55562;
  ') do
    its('stdout') { should match("1") }
  end
end
