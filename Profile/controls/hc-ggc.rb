# copyright: 2021, The Hackers

title "Hostname Containment Tests for a Good Guy Client"

control "HC-Ingress-GGC" do
  impact 0.7
  title "Hostname Containment Ingress - Good Guy Client "

  # Running fwknop command
  describe command('fwknop —wget-cmd /usr/bin/wget -R -n service_gate') do
    it { should exist }
    its('stderr') { should eq '' }
    its('exit_status') { should eq 0 }
  end
  #Test Containment for Green host
  describe host('sdp-attacker1.e3lab.solutions') do
    it { should be_reachable }
    it { should be_resolvable }
  end
  #Test Containment for Blue host
  describe host('sdp-gateway.e3lab.solutions') do
    it { should be_reachable }
    it { should be_resolvable }
  end
end

control "HC-Transiting-GGC" do
  impact 0.7
  title "Hostname Containment Transiting - Good Guy Client"

  # Running fwknop command
  describe command('fwknop —wget-cmd /usr/bin/wget -R -n service_gate') do
    it { should exist }
    its('stderr') { should eq '' }
    its('exit_status') { should eq 0 }
  end
  #Test Containment for Green host
  describe host('sdp-attacker1.e3lab.solutions') do
    it { should be_reachable }
    it { should be_resolvable }
  end
  #Test Containment for Blue host
  describe host('sdp-gateway.e3lab.solutions') do
    it { should be_reachable }
    it { should be_resolvable }
  end
  #Test Containment for Resilient Controller
  describe host('sdp-controller.e3lab.solutions') do
    it { should be_reachable }
    it { should be_resolvable }
  end
end
