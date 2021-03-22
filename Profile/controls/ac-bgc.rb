# copyright: 2021, The Hackers

title "Active Access Control Tests for a Bad Guy Client"

control "AC-Ingress-BGC" do
  impact 0.7
  title "Access Control Ingress - Bad Guy Client"

  # Running fwknop command
  describe command('fwknop —wget-cmd /usr/bin/wget -R -n service_gate') do
    # TODO: this should either not exist or should not work

    # it { should exist }
    # its('stderr') { should eq '' }
    # its('exit_status') { should eq 0 }
  end

  # Checking if telnet is closed on blue machiene
  describe port('sdp-gateway.e3lab.solutions', 23) do
    it { should_not be_listening }
    its('protocols') { should_not include 'tcp' }
  end

  # Checking if ssh is closed on blue machiene
  describe port('sdp-gateway.e3lab.solutions', 22) do
    it { should_not be_listening }
    its('protocols') { should_not include 'tcp' }
  end
end

control "AC-Egress-BGC" do
  impact 0.7
  title "Access Control Egress - Bad Guy Client"

  # Running fwknop command
  # test step 1
  # test step 2
  # test step 3
end
