# copyright: 2021, The Hackers

title "Hostname Containmnet Tests for a Bad Guy Client"

control "HC-Ingress-BGC" do
  impact 0.7
  title "Hostname Containment Ingress - Bad Guy Client"

  # Running fwknop command
  describe command('fwknop —wget-cmd /usr/bin/wget -R -n service_gate') do
    it { should_not exist }
    its('stderr') { should_not eq '' }
    its('exit_status') { should_not eq 0 }
  end
  #Test containment for Green host
  describe host('sdp-attacker1.e3lab.solutions') do
    it { should_not be_reachable }
    it { should_not be_resolvable }
  end
  #Test Containment for Blue host
  describe host('sdp-gateway.e3lab.solutions') do
    it { should_not be_reachable }
    it { should_not be_resolvable }
  end
end

control "HC-Transiting-BGC" do
  impact 0.7
  title "Hostname Containment Transiting - Bad Guy Client"

  # Running fwknop command
  describe command('fwknop —wget-cmd /usr/bin/wget -R -n service_gate') do
    it { should_not exist }
    its('stderr') { should_not eq '' }
    its('exit_status') { should_not eq 0 }
  end
  #Test Containment for Green host
  describe host('sdp-attacker1.e3lab.solutions') do
    it { should_not be_reachable }
    it { should_not be_resolvable }
  end
  #Test Containment for Blue host
  describe host('sdp-gateway.e3lab.solutions') do
    it { should_not be_reachable }
    it { should_not be_resolvable }
  end
  #Test Containment for Resilient Controller
  describe host('sdp-controller.e3lab.solutions') do
    it { should_not be_reachable }
    it { should_not be_resolvable }
  end
end
