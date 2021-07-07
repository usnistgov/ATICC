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

  describe command(input('full_fwknop_command')) do
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

  # Use nmap to show destination is on seperate network

  # Check nmap command exists
  describe command('nmap') do
    it { should exist }
  end

  # Run nmap scan to determine whether all ports are filtered
  describe command('nmap 0.0.0.0') do
    its('stdout') { should match (/.*All.*are filtered.*/) }
  end

end

control "NS-Transit-GGC" do
  impact 0.7
  title "Network Segmentation Transit - Good Guy Client"

  # Running fwknop command
  describe command('fwknop') do
    it { should exist }
  end

  describe command(input('full_fwknop_command')) do
    its('stderr') { should eq '' }
    its('exit_status') { should eq 0 }
  end

  # ssh to authorized internal domain
  describe command("ssh -i <key> -o ConnectTimeout=5 <user>@sdp-gateway.e3lab.solutions 'exit 0'") do
    its('exit_status') { should eq 0}
  end

  # telnet to authorized internal domain
  describe command("echo 'exit' | telnet sdp-gateway.e3lab.solutions") do
    its('exit_status') { should eq 0}
  end

  # ssh to unauthorized internal domain
  describe command("ssh -i <key> -o ConnectTimeout=5 <user>@sdp-attacker1.e3lab.solutions 'exit 0'") do
    its('exit_status') { should_not eq 0}
  end

  # telnet to unauthorized internal domain
  describe command("echo 'exit' | telnet sdp-attacker1.e3lab.solutions") do
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

  describe command(input('full_fwknop_command')) do
    its('stderr') { should eq '' }
    its('exit_status') { should eq 0 }
  end

  # ssh to external domain
  describe command("ssh -i <key> -o ConnectTimeout=5 <external.domain> 'exit 0'") do
    its('exit_status') { should_not eq 0}
  end

  # telnet to external domain
  describe command("telnet <external.domain>") do
    its('exit_status') { should_not eq 0}
  end

end
