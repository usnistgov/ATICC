# copyright: 2021, The Hackers

title "Hostname Containment Tests for a Bad Guy Client"

control "HC-Ingress-BGC" do
  impact 0.7
  title "Hostname Containment Ingress - Bad Guy Client"

  # Running fwknop command
  describe command('fwknop —wget-cmd /usr/bin/wget -R -n service_gate') do
    it { should exist }
    its('stderr') { should eq '' }
    its('exit_status') { should eq 0 }
  end

  #Test Containment for Green host ICMP
  describe host('0.0.0.0', port: 57621, protocol: 'tcp') do
    it { should_not be_reachable }
    it { should_not be_resolvable }
  end
  #Test Containment for Green host F-Force App
  describe host('sdp-attacker1.e3lab.solutions', port: 8282, protocol: 'tcp') do
    it { should_not be_reachable }
    it { should_not be_resolvable }
  end
  #Test Containment for Green host SSH
  describe host('sdp-attacker1.e3lab.solutions', port: 2200, protocol: 'tcp') do
    it { should_not be_reachable }
    it { should_not be_resolvable }
  end
  #Test Containment for Green host VNC
  describe host('sdp-attacker1.e3lab.solutions', port: 5901, protocol: 'tcp') do
    it { should_not be_reachable }
    it { should_not be_resolvable }
  end
  #Test Containment for Green host Telnet
  describe host('sdp-attacker1.e3lab.solutions', port: 23, protocol: 'tcp') do
    it { should_not be_reachable }
    it { should_not be_resolvable }
  end

  #Test Containment for Blue host ICMP
  describe host('0.0.0.0', port: 57621, protocol: 'tcp') do
    it { should_not be_reachable }
    it { should_not be_resolvable }
  end
  #Test Containment for Blue host F-Force App
  describe host('sdp-gateway.e3lab.solutions', port: 8282, protocol: 'tcp') do
    it { should_not be_reachable }
    it { should_not be_resolvable }
  end
  #Test Containment for Blue host SSH
  describe host('sdp-gateway.e3lab.solutions', port: 2200, protocol: 'tcp') do
    it { should_not be_reachable }
    it { should_not be_resolvable }
  end
  #Test Containment for Blue host VNC
  describe host('sdp-gateway.e3lab.solutions', port: 5901, protocol: 'tcp') do
    it { should_not be_reachable }
    it { should_not be_resolvable }
  end
  #Test Containment for Blue host Telnet
  describe host('sdp-gateway.e3lab.solutions', port: 23, protocol: 'tcp') do
    it { should_not be_reachable }
    it { should_not be_resolvable }
  end
end

control "HC-Transiting-BGC" do
  impact 0.7
  title "Hostname Containment Transiting - Bad Guy Client"

  # Running fwknop command
  describe command('fwknop —wget-cmd /usr/bin/wget -R -n service_gate') do
    it { should exist }
    its('stderr') { should eq '' }
    its('exit_status') { should eq 0 }
  end

  #Test Containment for Green host ICMP
  describe host('0.0.0.0', port: 57621, protocol: 'tcp') do
    it { should_not be_reachable }
    it { should_not be_resolvable }
  end
  #Test Containment for Green host F-Force App
  describe host('sdp-attacker1.e3lab.solutions', port: 8282, protocol: 'tcp') do
    it { should_not be_reachable }
    it { should_not be_resolvable }
  end
  #Test Containment for Green host SSH
  describe host('sdp-attacker1.e3lab.solutions', port: 2200, protocol: 'tcp') do
    it { should_not be_reachable }
    it { should_not be_resolvable }
  end
  #Test Containment for Green host VNC
  describe host('sdp-attacker1.e3lab.solutions', port: 5901, protocol: 'tcp') do
    it { should_not be_reachable }
    it { should_not be_resolvable }
  end
  #Test Containment for Green host Telnet
  describe host('sdp-attacker1.e3lab.solutions', port: 23, protocol: 'tcp') do
    it { should_not be_reachable }
    it { should_not be_resolvable }
  end

  #Test Containment for Blue host ICMP
  describe host('0.0.0.0', port: 57621, protocol: 'tcp') do
    it { should_not be_reachable }
    it { should_not be_resolvable }
  end
  #Test Containment for Blue host F-Force App
  describe host('sdp-gateway.e3lab.solutions', port: 8282, protocol: 'tcp') do
    it { should_not be_reachable }
    it { should_not be_resolvable }
  end
  #Test Containment for Blue host SSH
  describe host('sdp-gateway.e3lab.solutions', port: 2200, protocol: 'tcp') do
    it { should_not be_reachable }
    it { should_not be_resolvable }
  end
  #Test Containment for Blue host VNC
  describe host('sdp-gateway.e3lab.solutions', port: 5901, protocol: 'tcp') do
    it { should_not be_reachable }
    it { should_not be_resolvable }
  end
  #Test Containment for Blue host Telnet
  describe host('sdp-gateway.e3lab.solutions', port: 23, protocol: 'tcp') do
    it { should_not be_reachable }
    it { should_not be_resolvable }
  end



  #Test Containment for Resilient Controller
  describe host('sdp-controller.e3lab.solutions') do
    it { should_not be_reachable }
    it { should_not be_resolvable }
  end

  #Make sure to add new port tests for containment of the Resilient Controller
end