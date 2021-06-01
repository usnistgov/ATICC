# coding: utf-8
# copyright: 2021, The Hackers

title "Network Segmentation Tests for a Bad Guy Client"

control "NS-Ingress-BGC" do
  impact 0.7
  title "Network Segmentation Ingress - Bad Guy Client"

  # Running fwknop command
  describe command('fwknop') do
    it { should_not exist }
  end

  describe command('fwknop —wget-cmd /usr/bin/wget -R -n service_gate') do
    its('stderr') { should_not eq '' }
    its('exit_status') { should_not eq 0 }
  end

  # Checking if telnet is open on blue machiene
  describe port('sdp-gateway.e3lab.solutions', 23) do
    it { should_not be_listening }
    its('protocols') { should_not include 'tcp' }
  end

  # Checking if ssh is open on blue machiene
  describe port('sdp-gateway.e3lab.solutions', 22) do
    it { should_not be_listening }
    its('protocols') { should_not include 'tcp' }
  end

  # SHOULD FAIL: Use trace route to show destination is on seperate network
  
end

control "NS-Transit-BGC" do
  impact 0.7
  title "Network Segmentation Transit - Bad Guy Client"

  # Running fwknop command
  describe command('fwknop') do
    it { should_not exist }
  end

  describe command('fwknop —wget-cmd /usr/bin/wget -R -n service_gate') do
    its('stderr') { should_not eq '' }
    its('exit_status') { should_not eq 0 }
  end
  
  # SHOULD FAIL: ssh to unauthoried internal domain
  
end

control "NS-Egress-BGC" do
  impact 0.7
  title "Network Segmentation Egress - Bad Guy Client"

  # Running fwknop command
  describe command('fwknop') do
    it { should_not exist }
  end

  describe command('fwknop —wget-cmd /usr/bin/wget -R -n service_gate') do
    its('stderr') { should_not eq '' }
    its('exit_status') { should_not eq 0 }
  end
  
  # SHOULD FAIL: ssh to external domain
  
end
