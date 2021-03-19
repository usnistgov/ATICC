# copyright: 2021, The Hackers

title "Active Access Control Tests for a Good Guy Client"

control "AC-GGC" do
  impact 0.7
  title "Test Access Control Ingress"

  # Running fwknop command
  describe command('fwknop —wget-cmd /usr/bin/wget -R -n service_gate') do
    it { should exist }
    its('stderr') { should eq '' }
    its('exit_status') { should eq 0 }
  end

  # Checking if telnet is open on blue machiene
  describe port('sdp-gateway.e3lab.solutions', 23) do
    it { should be_listening }
    its('protocols') { should include 'tcp' }
  end

  # Checking if ssh is open on blue machiene
  describe port('sdp-gateway.e3lab.solutions', 22) do
    it { should be_listening }
    its('protocols') { should include 'tcp' }
  end
end
