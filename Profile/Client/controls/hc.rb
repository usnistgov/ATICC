
control "HC-Ingress-AC" do
  impact 0.7
  title "Hostname Containment Ingress - Authenticated Client"
  desc "Justification","...."#get detailed description from TIC 3.0
  desc "This control tests whether or not hosts are reachable and resolvable from an authenticated client within the network" #this will be changed to a more articulated description later on
  tag "Capability":"Network"
  tag "TIC Version":"3.0"
  tag "Hostname Containment"
  tag "Ingress"
  tag "Authenticated"

  #Test Containment for Green host ICMP
  describe host('0.0.0.0', port: input('icmp_port'), protocol: 'tcp') do
    it { should be_reachable }
    it { should be_resolvable }
  end

  describe host(input('green_machine_address'), port: input('telnet_port'), protocol: 'tcp') do
    it { should be_reachable }
    it { should be_resolvable }
  end
  #Test Containment for Green host F-Force App
  describe host(input('green_machine_address'), port: input('fforce_app_port'), protocol: 'tcp') do
    it { should be_reachable }
    it { should be_resolvable }
  end
  #Test Containment for Green host SSH
  describe host(input('green_machine_address'), port: input('ssh_port'), protocol: 'tcp') do
    it { should be_reachable }
    it { should be_resolvable }
  end
  #Test Containment for Green host VNC
  describe host(input('green_machine_address'), port: input('vnc_port'), protocol: 'tcp') do
    it { should be_reachable }
    it { should be_resolvable }
  end
  #Test Containment for Green host Telnet
  describe host(input('green_machine_address'), port: input('telnet_port'), protocol: 'tcp') do
    it { should be_reachable }
    it { should be_resolvable }
  end

  #Test Containment for Blue host ICMP
  describe host('0.0.0.0', port: input('icmp_port'), protocol: 'tcp') do
    it { should be_reachable }
    it { should be_resolvable }
  end

  describe host(input('blue_machine_address'), port: input('icmp_port'), protocol: 'tcp') do
    it { should be_reachable }
    it { should be_resolvable }
  end
  #Test Containment for Blue host F-Force App
  describe host(input('blue_machine_address'), port: input('fforce_app_port'), protocol: 'tcp') do
    it { should be_reachable }
    it { should be_resolvable }
  end
  #Test Containment for Blue host SSH
  describe host(input('blue_machine_address'), port: input('ssh_port'), protocol: 'tcp') do
    it { should be_reachable }
    it { should be_resolvable }
  end
  #Test Containment for Blue host VNC
  describe host(input('blue_machine_address'), port: input('vnc_port'), protocol: 'tcp') do
    it { should be_reachable }
    it { should be_resolvable }
  end
  #Test Containment for Blue host Telnet
  describe host(input('blue_machine_address'), port: input('telnet_port'), protocol: 'tcp') do
    it { should be_reachable }
    it { should be_resolvable }
  end
end


control "HC-Transiting-AC" do
  impact 0.7
  title "Hostname Containment Transiting - Authenticated Client"
  desc "Justification","...."
  desc "This control ...."
  tag "Capability":"Network"
  tag "TIC Version":"3.0"
  tag "Hostname Containment"
  tag "Transiting"
  tag "Authenticated"


  #Test Containment for Green host ICMP
  describe host('0.0.0.0', port: input('icmp_port'), protocol: 'tcp') do
    it { should be_reachable }
    it { should be_resolvable }
  end

  describe host(input('green_machine_address'), port: input('icmp_port'), protocol: 'tcp') do
    it { should be_reachable }
    it { should be_resolvable }
  end
  #Test Containment for Green host F-Force App
  describe host(input('green_machine_address'), port: input('fforce_app_port'), protocol: 'tcp') do
    it { should be_reachable }
    it { should be_resolvable }
  end
  #Test Containment for Green host SSH
  describe host(input('green_machine_address'), port: input('ssh_port'), protocol: 'tcp') do
    it { should be_reachable }
    it { should be_resolvable }
  end
  #Test Containment for Green host VNC
  describe host(input('green_machine_address'), port: input('vnc_port'), protocol: 'tcp') do
    it { should be_reachable }
    it { should be_resolvable }
  end
  #Test Containment for Green host Telnet
  describe host(input('green_machine_address'), port: input('telnet_port'), protocol: 'tcp') do
    it { should be_reachable }
    it { should be_resolvable }
  end


  #Test Containment for Blue host ICMP
  describe host('0.0.0.0', port: input('icmp_port'), protocol: 'tcp') do
    it { should be_reachable }
    it { should be_resolvable }
  end

  describe host(input('blue_machine_address'), port: input('icmp_port'), protocol: 'tcp') do
    it { should be_reachable }
    it { should be_resolvable }
  end

  #Test Containment for Blue host F-Force App
  describe host(input('blue_machine_address'), port: input('fforce_app_port'), protocol: 'tcp') do
    it { should be_reachable }
    it { should be_resolvable }
  end
  #Test Containment for Blue host SSH
  describe host(input('blue_machine_address'), port: input('ssh_port'), protocol: 'tcp') do
    it { should be_reachable }
    it { should be_resolvable }
  end
  #Test Containment for Blue host VNC
  describe host(input('blue_machine_address'), port: input('vnc_port'), protocol: 'tcp') do
    it { should be_reachable }
    it { should be_resolvable }
  end
  #Test Containment for Blue host Telnet
  describe host(input('blue_machine_address'), port: input('telnet_port'), protocol: 'tcp') do
    it { should be_reachable }
    it { should be_resolvable }
  end

  #Test Containment for Resilient Controller host F-Force App
  describe host('sdp-controller.e3lab.solutions', port: input('fforce_app_port'), protocol: 'tcp') do
    it { should be_reachable }
    it { should be_resolvable }
  end
  #Test Containment for Resilient Controller host SSH
  describe host('sdp-controller.e3lab.solutions', port: input('ssh_port'), protocol: 'tcp') do
    it { should be_reachable }
    it { should be_resolvable }
  end
  #Test Containment for Resilient Controller host VNC
  describe host('sdp-controller.e3lab.solutions', port: input('vnc_port'), protocol: 'tcp') do
    it { should be_reachable }
    it { should be_resolvable }
  end
  #Test Containment for Resilient Controller host Telnet
  describe host('sdp-controller.e3lab.solutions', port: input('telnet_port'), protocol: 'tcp') do
    it { should be_reachable }
    it { should be_resolvable }
  end
end



title "Hostname Containment Tests for an Unauthenticated Client"

control "HC-Ingress-UC" do
  impact 0.7
  title "Hostname Containment Ingress - Unauthenticated Client"
  desc "Justification","...."
  desc "This control ...."
  tag "Capability":"Network"
  tag "TIC Version":"3.0"
  tag "Hostname Containment"
  tag "Ingress"
  tag "Unauthenticated"

  #Test Containment for Green host ICMP
  describe host('0.0.0.0', port: input('icmp_port'), protocol: 'tcp') do
    it { should_not be_reachable }
    it { should_not be_resolvable }
  end
  #Test Containment for Green host F-Force App
  describe host(input('green_machine_address'), port: input('fforce_app_port'), protocol: 'tcp') do
    it { should_not be_reachable }
    it { should_not be_resolvable }
  end
  #Test Containment for Green host SSH
  describe host(input('green_machine_address'), port: input('ssh_port'), protocol: 'tcp') do
    it { should_not be_reachable }
    it { should_not be_resolvable }
  end
  #Test Containment for Green host VNC
  describe host(input('green_machine_address'), port: input('vnc_port'), protocol: 'tcp') do
    it { should_not be_reachable }
    it { should_not be_resolvable }
  end
  #Test Containment for Green host Telnet
  describe host(input('green_machine_address'), port: input('telnet_port'), protocol: 'tcp') do
    it { should_not be_reachable }
    it { should_not be_resolvable }
  end

  #Test Containment for Blue host ICMP
  describe host('0.0.0.0', port: input('icmp_port'), protocol: 'tcp') do
    it { should_not be_reachable }
    it { should_not be_resolvable }
  end
  #Test Containment for Blue host F-Force App
  describe host(input('blue_machine_address'), port: input('fforce_app_port'), protocol: 'tcp') do
    it { should_not be_reachable }
    it { should_not be_resolvable }
  end
  #Test Containment for Blue host SSH
  describe host(input('blue_machine_address'), port: input('ssh_port'), protocol: 'tcp') do
    it { should_not be_reachable }
    it { should_not be_resolvable }
  end
  #Test Containment for Blue host VNC
  describe host(input('blue_machine_address'), port: input('vnc_port'), protocol: 'tcp') do
    it { should_not be_reachable }
    it { should_not be_resolvable }
  end
  #Test Containment for Blue host Telnet
  describe host(input('blue_machine_address'), port: input('telnet_port'), protocol: 'tcp') do
    it { should_not be_reachable }
    it { should_not be_resolvable }
  end
end

control "HC-Transiting-UC" do
  impact 0.7
  title "Hostname Containment Transiting - Unauthenticated Client"
  desc "Justification","...."
  desc "This control ...."
  tag "Capability":"Network"
  tag "TIC Version":"3.0"
  tag "Hostname Containment"
  tag "Transiting"
  tag "Unauthenticated"

  #Test Containment for Green host ICMP
  describe host('0.0.0.0', port: input('icmp_port'), protocol: 'tcp') do
    it { should_not be_reachable }
    it { should_not be_resolvable }
  end
  #Test Containment for Green host F-Force App
  describe host(input('green_machine_address'), port: input('fforce_app_port'), protocol: 'tcp') do
    it { should_not be_reachable }
    it { should_not be_resolvable }
  end
  #Test Containment for Green host SSH
  describe host(input('green_machine_address'), port: input('ssh_port'), protocol: 'tcp') do
    it { should_not be_reachable }
    it { should_not be_resolvable }
  end
  #Test Containment for Green host VNC
  describe host(input('green_machine_address'), port: input('vnc_port'), protocol: 'tcp') do
    it { should_not be_reachable }
    it { should_not be_resolvable }
  end
  #Test Containment for Green host Telnet
  describe host(input('green_machine_address'), port: input('telnet_port'), protocol: 'tcp') do
    it { should_not be_reachable }
    it { should_not be_resolvable }
  end

  #Test Containment for Blue host ICMP
  describe host('0.0.0.0', port: input('icmp_port'), protocol: 'tcp') do
    it { should_not be_reachable }
    it { should_not be_resolvable }
  end
  #Test Containment for Blue host F-Force App
  describe host(input('blue_machine_address'), port: input('fforce_app_port'), protocol: 'tcp') do
    it { should_not be_reachable }
    it { should_not be_resolvable }
  end
  #Test Containment for Blue host SSH
  describe host(input('blue_machine_address'), port: input('ssh_port'), protocol: 'tcp') do
    it { should_not be_reachable }
    it { should_not be_resolvable }
  end
  #Test Containment for Blue host VNC
  describe host(input('blue_machine_address'), port: input('vnc_port'), protocol: 'tcp') do
    it { should_not be_reachable }
    it { should_not be_resolvable }
  end
  #Test Containment for Blue host Telnet
  describe host(input('blue_machine_address'), port: input('telnet_port'), protocol: 'tcp') do
    it { should_not be_reachable }
    it { should_not be_resolvable }
  end

  #Test Containment for Resilient Controller host F-Force App
  describe host('sdp-controller.e3lab.solutions', port: input('fforce_app_port'), protocol: 'tcp') do
    it { should_not be_reachable }
    it { should_not be_resolvable }
  end
  #Test Containment for Resilient Controller host SSH
  describe host('sdp-controller.e3lab.solutions', port: input('ssh_port'), protocol: 'tcp') do
    it { should_not be_reachable }
    it { should_not be_resolvable }
  end
  #Test Containment for Resilient Controller host VNC
  describe host('sdp-controller.e3lab.solutions', port: input('vnc_port'), protocol: 'tcp') do
    it { should_not be_reachable }
    it { should_not be_resolvable }
  end
  #Test Containment for Resilient Controller host Telnet
  describe host('sdp-controller.e3lab.solutions', port: input('telnet_port'), protocol: 'tcp') do
    it { should_not be_reachable }
    it { should_not be_resolvable }
  end
end
