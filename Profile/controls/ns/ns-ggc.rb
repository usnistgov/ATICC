# coding: utf-8
# copyright: 2021, The Hackers

title "Network Segmentation Tests for a Good Guy Client"

control "NS-Ingress-GGC" do
  impact 0.7
  title "Network Segmentation Ingress - Good Guy Client"

  # Running fwknop command
  describe command('fwknop') do
    it { should exist }
  end

  describe command('fwknop —wget-cmd /usr/bin/wget -R -n service_gate') do
    its('stderr') { should eq '' }
    its('exit_status') { should eq 0 }
  end

  # Checking if telnet is open on blue machine
  describe port('sdp-gateway.e3lab.solutions', 23) do
    it { should be_listening }
    its('protocols') { should include 'tcp' }
  end

  # Checking if ssh is open on blue machine
  describe port('sdp-gateway.e3lab.solutions', 22) do
    it { should be_listening }
    its('protocols') { should include 'tcp' }
  end

  # Use trace route to show destination is on seperate network
  
end

control "NS-Transit-GGC" do
  impact 0.7
  title "Network Segmentation Transit - Good Guy Client"

  # Running fwknop command
  describe command('fwknop') do
    it { should exist }
  end

  describe command('fwknop —wget-cmd /usr/bin/wget -R -n service_gate') do
    its('stderr') { should eq '' }
    its('exit_status') { should eq 0 }
  end

  # ssh to unauthoried internal domain
  describe command("ssh -i <key> -o ConnectTimeout=5 <user>@sdp-attacker1.e3lab.solutions 'exit 0'") do
    its('exit_status') { should_not eq 0}
  end
  
end

control "NS-Egress-GGC" do
  impact 0.7
  title "Network Segmentation Egress - Good Guy Client"

  # Running fwknop command
  describe command('fwknop') do
    it { should exist }
  end

  describe command('fwknop —wget-cmd /usr/bin/wget -R -n service_gate') do
    its('stderr') { should eq '' }
    its('exit_status') { should eq 0 }
  end
  
  # ssh to external domain
  
end
