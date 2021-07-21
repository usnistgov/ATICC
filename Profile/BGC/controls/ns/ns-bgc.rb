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

  describe command(input('full_fwknop_command')) do
    its('stderr') { should_not eq '' }
    its('exit_status') { should_not eq 0 }
  end

  # Checking if telnet is open on blue machiene
  describe port(input("blue_machine_address"), input("telnet_port")) do
    it { should_not be_listening }
    its('protocols') { should_not include 'tcp' }
  end

  # Checking if ssh is open on blue machiene
  describe port(input("blue_machine_address"), input("ssh_port")) do
    it { should_not be_listening }
    its('protocols') { should_not include 'tcp' }
  end

  # Use nmap to show destination is on seperate network

  # Check nmap command exists
  describe command('nmap') do
    it { should exist }
  end

  # Run nmap scan to determine whether all ports are filtered
  describe command('nmap 0.0.0.0') do
    its('stdout') { should_not match (/.*All.*are filtered.*/) }
  end
  
end

control "NS-Transit-BGC" do
  impact 0.7
  title "Network Segmentation Transit - Bad Guy Client"

  # Running fwknop command
  describe command('fwknop') do
    it { should_not exist }
  end

  describe command(input('full_fwknop_command')) do
    its('stderr') { should_not eq '' }
    its('exit_status') { should_not eq 0 }
  end

  # SHOULD FAIL: ssh to authorized internal domain
  describe command("ssh -i <key> -o ConnectTimeout=5 <user>@" + input("blue_machine_address") + " 'exit 0'") do
    its('exit_status') { should_not eq 0}
  end

  # telnet to authorized internal domain
  describe command("echo 'exit' | telnet " + input("blue_machine_address")) do
    its('exit_status') { should_not eq 0}
  end
  
  # SHOULD FAIL: ssh to unauthoried internal domain
  describe command("ssh -i <key> -o ConnectTimeout=5 <user>@" + input("green_machine_address") + " 'exit 0'") do
    its('exit_status') { should_not eq 0}
  end

  # telnet to unauthorized internal domain
  describe command("echo 'exit' | telnet " + input("green_machine_address")) do
    its('exit_status') { should_not eq 0}
  end
  
end

control "NS-Egress-BGC" do
  impact 0.7
  title "Network Segmentation Egress - Bad Guy Client"

  # Running fwknop command
  describe command('fwknop') do
    it { should_not exist }
  end

  describe command(input('full_fwknop_command')) do
    its('stderr') { should_not eq '' }
    its('exit_status') { should_not eq 0 }
  end
  
  # SHOULD FAIL: ssh to external domain
  describe command("ssh -i <key> -o ConnectTimeout=5 <external.domain> 'exit 0'") do
    its('exit_status') { should_not eq 0}
  end

  # telnet to external domain
  describe command("telnet <external.domain>") do
    its('exit_status') { should_not eq 0}
  end
  
end
