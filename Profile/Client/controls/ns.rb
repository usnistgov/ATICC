title "Network Segmentation Tests for a Authenticated Client"

control "NS-Ingress-Authenticated" do
  impact 0.7
  title "Network Segmentation Ingress - Authenticated Client"

  # Checking if telnet is open on blue machine
  #describe port(input('blue_machine_address'), input(telnet_port)) do
  #  it { should be_listening }
  #  its('protocols') { should include 'tcp' }
  #end

  describe host(input('blue_machine_address'), port: input('telnet_port'), protocol: 'tcp') do
    it { should be_reachable }
    it { should be_resolvable }
  end

  # Checking if ssh is open on blue machine
  #describe port(input('blue_machine_address'), input(ssh_port)) do
  #  it { should be_listening }
  #  its('protocols') { should include 'tcp' }
  #end

  describe host(input('blue_machine_address'), port: input('ssh_port'), protocol: 'tcp') do
    it { should be_reachable }
    it { should be_resolvable }
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

control "NS-Transit-Authenticated" do
  impact 0.7
  title "Network Segmentation Transit - Authenticated Client"

  # ssh to authorized internal domain
  describe command("ssh -i " + input("ssh_key") + " -o ConnectTimeout=5 " + input("ssh_user") + "@" + input("blue_machine_address") + " 'exit 0'") do
    its('exit_status') { should eq 0}
  end

  # telnet to authorized internal domain
  describe command("echo 'exit' | telnet " + input("blue_machine_address")) do
    its('exit_status') { should eq 0}
  end

  # ssh to unauthorized internal domain
  describe command("ssh -i " + input("ssh_key") + " -o ConnectTimeout=5 " + input("ssh_user") + "@" + input("green_machine_address") + " 'exit 0'") do
    its('exit_status') { should_not eq 0}
  end

  # telnet to unauthorized internal domain
  describe command("echo 'exit' | telnet " + input("green_machine_address")) do
    its('exit_status') { should_not eq 0}
  end

end

control "NS-Egress-Authenticated" do
  impact 0.7
  title "Network Segmentation Egress - Authenticated Client"

  # ssh to external domain
  describe command("ssh -i " + input("ssh_key") + " -o ConnectTimeout=5 <external.domain> 'exit 0'") do
    its('exit_status') { should_not eq 0}
  end

  # telnet to external domain
  describe command("telnet <external.domain>") do
    its('exit_status') { should_not eq 0}
  end

end
