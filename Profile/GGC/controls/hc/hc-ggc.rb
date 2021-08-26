# copyright: 2021, The Hackers

title "Hostname Containment Tests for a Good Guy Client"

control "HC-Ingress-GGC" do
  impact 0.7
  title "Hostname Containment Ingress - Good Guy Client"

  # Running fwknop command
  describe command('fwknop') do
    it { should exist }
  end

  describe command(input('full_fwknop_command')) do
    #its('stderr') { should eq '' }
    its('exit_status') { should eq 0 }
  end

  #Test Containment for Green host ICMP
  #describe host('0.0.0.0', port: input('icmp_port'), protocol: 'tcp') do
  #  it { should be_reachable }
  #  it { should be_resolvable }
  #end

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
  #describe host('0.0.0.0', port: input('icmp_port'), protocol: 'tcp') do
  #  it { should be_reachable }
  #  it { should be_resolvable }
  #end

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



control "HC-Transiting-GGC" do
  impact 0.7
  title "Hostname Containment Transiting - Good Guy Client"

  # Running fwknop command
  describe command('fwknop') do
    it { should exist }
  end

  describe command(input('full_fwknop_command')) do
    #its('stderr') { should eq '' }
    its('exit_status') { should eq 0 }
  end


  #Test Containment for Green host ICMP
  #describe host('0.0.0.0', port: input('icmp_port'), protocol: 'tcp') do
  #  it { should be_reachable }
  #  it { should be_resolvable }
  #end

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
  #describe host('0.0.0.0', port: input('icmp_port'), protocol: 'tcp') do
  #  it { should be_reachable }
  #  it { should be_resolvable }
  #end

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
