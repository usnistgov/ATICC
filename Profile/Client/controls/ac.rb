# copyright: 2021, The Hackers

title "Active Access Control Tests for a Good Guy Client"

control "AC-Ingress-GGC" do
  impact 0.7
  title "Access Control Ingress - Good Guy Client"
  desc "Justification","...."
  desc "This control ...."
  tag "Capability":"Network"
  tag "TIC Version":"3.0"
  tag "Access Control"
  tag "Ingress"

  #7 - F-Force App (Blue Machine)
  describe host(input('blue_machine_address'), port: input('fforce_app_port'), protocol: 'tcp') do
    it { should be_reachable }
    it { should be_resolvable }
  end

  #8 - ssh (Blue Machine)
  describe host(input('blue_machine_address'), port: input('ssh_port'), protocol: 'tcp') do
    it { should be_reachable }
    it { should be_resolvable }
  end

  #9 - VNC (Blue Machine)
  describe host(input('blue_machine_address'), port: input('vnc_port'), protocol: 'tcp') do
    it { should be_reachable }
    it { should be_resolvable }
  end

  #10 - Telnet (Blue Machine)
  describe host(input('blue_machine_address'), port: input('telnet_port'), protocol: 'tcp') do
    it { should be_reachable }
    it { should be_resolvable }
  end
  # icmp (Blue Machine)
  describe host(input('blue_machine_address'), port: input('icmp_port'), protocol: 'tcp') do
    it { should be_reachable }
    it { should be_resolvable }
  end

  # icmp (Blue Machine)
  #describe port('0.0.0.0', input('icmp_port')) do
  #  it { should be_listening }
  #  its('protocols') { should include 'tcp' }
  #end

  #old commands
  ##7 - F-Force App (Blue Machine)
  #describe port(input('blue_machine_address'), input('fforce_app_port')) do
  #  it { should be_listening }
  #  its('protocols') { should include 'tcp' }
  #end

  ##8 - ssh (Blue Machine)
  #describe port(input('blue_machine_address'), input('ssh_port')) do
  #  it { should be_listening }
  #  its('protocols') { should include 'tcp' }
  #end



  ##9 - VNC (Blue Machine)
  #describe port(input('blue_machine_address'), input('vnc_port')) do
  #  it { should be_listening }
  #  its('protocols') { should include 'tcp' }
  #end

  

  ##10 - Telnet (Blue Machine)
  #describe port(input('blue_machine_address'), input('telnet_port')) do
  #  it { should be_listening }
  #  its('protocols') { should include 'tcp' }
  #end
end

control "AC-Egress-GGC" do
  impact 0.7
  title "Access Control Egress - Good Guy Client"

  # Egress steps

  # SSH to Blue Machine (authorized internal domain)
  # Clone a GitHub repository
  describe command("echo '" + input("ssh_key") + "' > /tmp/key && chmod 600 /tmp/key && ssh -i /tmp/key -o ConnectTimeout=5 " + input("ssh_user") + "@" + input("blue_machine_address") + " 'git clone https://github.com/usnistgov/ATICC.git /tmp/aticc && rm -fr /tmp/aticc' && rm /tmp/key") do
    its('exit_status') { should eq 0 }
  end

end

control "AC-Transiting-GGC" do
  impact 0.7
  title "Access Control Transiting - Good Guy Client"

  # Transiting steps
  # Go from Blue to Green
  describe command("echo '" + input("ssh_key") + "' > /tmp/key && chmod 600 /tmp/key && ssh -i /tmp/key -o ConnectTimeout=5 " + input("ssh_user") + "@" + input("blue_machine_address") + "'exit 0' && rm /tmp/key") do
    its('exit_status') { should eq 0 }
  end
  # describe port('sdp-attacker1.e3lab.solutions', 2200) do
  #   it { should_not be_listening }
  #   its('protocols') { should_not include 'tcp' }
  # end

  # Go from Green to Blue
  describe command("echo '" + input("ssh_key") + "' > /tmp/key && chmod 600 /tmp/key && ssh -i /tmp/key -o ConnectTimeout=5 " + input("ssh_user") + "@" + input("blue_machine_address") + "'exit 0' && rm /tmp/key") do
    its('exit_status') { should eq 0 }
  end
  # describe port('sdp-gateway.e3lab.solutions', 2200) do
  #   it { should_not be_listening }
  #   its('protocols') { should_not include 'tcp' }
  # end
end
