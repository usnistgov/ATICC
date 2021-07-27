# copyright: 2021, The Hackers

title "Active Access Control Tests for a Good Guy Client"

control "AC-Ingress-GGC" do
  impact 0.7
  title "Access Control Ingress - Good Guy Client"

  # Running fwknop command
  describe command('fwknop') do
    it { should exist }
  end

  describe command(input('full_fwknop_command')) do
    its('stderr') { should eq '' }
    its('exit_status') { should eq 0 }
  end

  # icmp (Blue Machine)
  describe port('0.0.0.0', input('icmp_port')) do
    it { should be_listening }
    its('protocols') { should include 'tcp' }
  end

  #7 - F-Force App (Blue Machine)
  describe port(input('blue_machine_address'), input('fforce_app_port')) do
    it { should be_listening }
    its('protocols') { should include 'tcp' }
  end

  #8 - ssh (Blue Machine)
  describe port(input('blue_machine_address'), input('ssh_port')) do
    it { should be_listening }
    its('protocols') { should include 'tcp' }
  end

  #9 - VNC (Blue Machine)
  describe port(input('blue_machine_address'), input('vnc_port')) do
    it { should be_listening }
    its('protocols') { should include 'tcp' }
  end

  #10 - Telnet (Blue Machine)
  describe port(input('blue_machine_address'), input('telnet_port')) do
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
  describe command(input('full_fwknop_command')) do
    its('stderr') { should eq '' }
    its('exit_status') { should eq 0 }
  end

  # Egress steps

  # SSH to Blue Machine (authorized internal domain)
  # Clone a GitHub repository
  describe command("ssh -i <key> -o ConnectTimeout=5 <user@" + input("blue_machine_address") + " 'git clone https://github.com/usnistgov/ATICC.git; exit 0'") do
    its('exit_status') { should eq 0 }
  end

end

control "AC-Transiting-GGC" do
  impact 0.7
  title "Access Control Transiting - Good Guy Client"

  # Running fwknop command
  describe command('fwknop') do
    it { should exist }
  end

  describe command(input('full_fwknop_command')) do
    its('stderr') { should eq '' }
    its('exit_status') { should eq 0 }
  end

  # Transiting steps
  # Go from Blue to Green
  describe command("ssh -i <key> -o ConnectTimeout=5 <user>@" + input("blue_machine_address") + " 'telnet " + input("green_machine_address") + " && exit 0'") do
    its('exit_status') { should eq 0 }
  end
  # describe port('sdp-attacker1.e3lab.solutions', 2200) do
  #   it { should_not be_listening }
  #   its('protocols') { should_not include 'tcp' }
  # end

  # Go from Green to Blue
  describe command("ssh -i <key> -o ConnectTimeout=5 <user>@" + input("green_machine_address") + " 'telnet " + input("blue_machine_address") + " && exit 0'") do
    its('exit_status') { should eq 0 }
  end
  # describe port('sdp-gateway.e3lab.solutions', 2200) do
  #   it { should_not be_listening }
  #   its('protocols') { should_not include 'tcp' }
  # end
end
