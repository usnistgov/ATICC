# copyright: 2021, The Hackers

title "Active Access Control Tests for a Good Guy Client"

control "AC-Ingress-GGC" do
  impact 0.7
  title "Access Control Ingress - Good Guy Client "

  # Running fwknop command
  describe command('fwknop') do
    it { should exist }
  end

  describe command('fwknop —wget-cmd /usr/bin/wget -R -n service_gate') do
    its('stderr') { should eq '' }
    its('exit_status') { should eq 0 }
  end

  # icmp (Blue Machine)
  describe port('0.0.0.0', 57621) do
    it { should be_listening }
    its('protocols') { should include 'tcp' }
  end

  #7 - F-Force App (Blue Machine)
  describe port('sdp-gateway.e3lab.solutions', 8282) do
    it { should be_listening }
    its('protocols') { should include 'tcp' }
  end

  #8 - ssh (Blue Machine)
  describe port('sdp-gateway.e3lab.solutions', 2200) do
    it { should be_listening }
    its('protocols') { should include 'tcp' }
  end

  #9 - VNC (Blue Machine)
  describe port('sdp-gateway.e3lab.solutions', 5901) do
    it { should be_listening }
    its('protocols') { should include 'tcp' }
  end

  #10 - Telnet (Blue Machine)
  describe port('sdp-gateway.e3lab.solutions', 23) do
    it { should be_listening }
    its('protocols') { should include 'tcp' }
  end

end

control "AC-Egress-GGC" do
  impact 0.7
  title "Access Control Egress - Good Guy Client"

  # Running fwknop command
  describe command('fwknop') do
    it { should exist }
  end
  describe command('fwknop —wget-cmd /usr/bin/wget -R -n service_gate') do
    its('stderr') { should eq '' }
    its('exit_status') { should eq 0 }
  end

  # Egress steps
  # Access google
  # Clone a GitHub repo
end

control "AC-Transiting-GGC" do
  impact 0.7
  title "Access Control Transiting - Good Guy Client"

  # Running fwknop command
  describe command('fwknop') do
    it { should exist }
  end

  describe command('fwknop —wget-cmd /usr/bin/wget -R -n service_gate') do
    its('stderr') { should eq '' }
    its('exit_status') { should eq 0 }
  end

  # Transiting steps
end
