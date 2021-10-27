title "Hostname Containment Tests"

control "HC-Ingress-UC" do
  impact 0.7
  title "Hostname Containment Ingress"
  desc "Justification","...."
  desc "This control ...."
  tag "Capability":"Network"
  tag "TIC Version":"3.0"
  tag "Hostname Containment"
  tag "Ingress"
  tag "Invalidated"

  #Test Containment for Green host F-Force App
  describe host(input('dev_machine_address'), port: input('fforce_app_port'), protocol: 'tcp') do
    it { should be_resolvable }
    it { should_not be_reachable }
  end
  #Test Containment for Green host SSH
  describe host(input('dev_machine_address'), port: input('ssh_port'), protocol: 'tcp') do
    it { should be_resolvable }
    it { should_not be_reachable }
  end
  #Test Containment for Green host VNC
  describe host(input('dev_machine_address'), port: input('vnc_port'), protocol: 'tcp') do
    it { should be_resolvable }
    it { should_not be_reachable }
  end
  #Test Containment for Green host Telnet
  describe host(input('dev_machine_address'), port: input('telnet_port'), protocol: 'tcp') do
    it { should be_resolvable }
    it { should_not be_reachable }
  end

  #Test Containment for Blue host F-Force App
  describe host(input('prod_machine_address'), port: input('fforce_app_port'), protocol: 'tcp') do
    it { should be_resolvable }
    it { should_not be_reachable }
  end
  #Test Containment for Blue host SSH
  describe host(input('prod_machine_address'), port: input('ssh_port'), protocol: 'tcp') do
    it { should be_resolvable }
    it { should_not be_reachable }
  end
  #Test Containment for Blue host VNC
  describe host(input('prod_machine_address'), port: input('vnc_port'), protocol: 'tcp') do
    it { should be_resolvable }
    it { should_not be_reachable }
  end
  #Test Containment for Blue host Telnet
  describe host(input('prod_machine_address'), port: input('telnet_port'), protocol: 'tcp') do
    it { should be_resolvable }
    it { should_not be_reachable }
  end
end
