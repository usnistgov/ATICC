# copyright: 2021, The Hackers

title "Active Access Control Tests for a Bad Guy Client"

control "AC-Ingress-BGC" do
  impact 0.7
  title "Access Control Ingress - Bad Guy Client"

  # Running fwknop command
  describe command('fwknop —wget-cmd /usr/bin/wget -R -n service_gate') do
    it { should_not exist }
    its('stderr') { should_not eq '' }
    its('exit_status') { should_not eq 0 }
  end

  # icmp (Blue Machine)
  describe port('0.0.0.0', 57621) do
    it { should_not be_listening }
    its('protocols') { should_not include 'tcp' }
  end

  #7 - F-Force App (Blue Machine)
  describe port('sdp-gateway.e3lab.solutions', 8282) do
    it { should_not be_listening }
    its('protocols') { should_not include 'tcp' }
  end

  #8 - ssh (Blue Machine)
  describe port('sdp-gateway.e3lab.solutions', 2200) do
    it { should_not be_listening }
    its('protocols') { should_not include 'tcp' }
  end

  #9 - VNC (Blue Machine)
  describe port('sdp-gateway.e3lab.solutions', 5901) do
    it { should_not be_listening }
    its('protocols') { should_not include 'tcp' }
  end

  #10 - Telnet (Blue Machine)
  describe port('sdp-gateway.e3lab.solutions', 23) do
    it { should_not be_listening }
    its('protocols') { should_not include 'tcp' }
  end


end

control "AC-Egress-BGC" do
  impact 0.7
  title "Access Control Egress - Bad Guy Client"

  # Running fwknop command
  describe command('fwknop —wget-cmd /usr/bin/wget -R -n service_gate') do
    it { should_not exist }
    its('stderr') { should_not eq '' }
    its('exit_status') { should_not eq 0 }
  end
  # Egress steps
end

control "AC-Transiting-BGC" do
  impact 0.7
  title "Access Control Transiting - Bad Guy Client"

  # Running fwknop command
  describe command('fwknop —wget-cmd /usr/bin/wget -R -n service_gate') do
    it { should_not exist }
    its('stderr') { should_not eq '' }
    its('exit_status') { should_not eq 0 }
  end
  # Transiting steps
end
