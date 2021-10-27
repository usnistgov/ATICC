title "Access Control Tests for Internal Machine"

control "AC-Egress" do
  impact 0.7
  title "Access Control Egress"
  desc "Access control protections prevent the egress of unauthorized network traffic"
  tag "Capability":"Network"
  tag "TIC Version":"3.0"
  tag "Access Control"
  tag "Egress"

  describe host(input('external_address'), port: 80, protocol: 'tcp') do
    it { should be_resolvable }
    it { should_not be_reachable }
  end
end

control "AC-Transiting" do
  impact 0.7
  title "Access Control Transiting"
  desc "Access control protections prevent the transiting of unauthorized network traffic"
  tag "Capability":"Network"
  tag "TIC Version":"3.0"
  tag "Access Control"
  tag "Egress"

  describe host(input('different_zone_machine'), port: input('fforce_app_port'), protocol: 'tcp') do
    it { should be_resolvable }
    it { should_not be_reachable }
  end

  describe host(input('different_zone_machine'), port: input('telnet_port'), protocol: 'tcp') do
    it { should be_resolvable }
    it { should_not be_reachable }
  end
  
  describe host(input('different_zone_machine'), port: input('ssh_port'), protocol: 'tcp') do
    it { should be_resolvable }
    it { should_not be_reachable }
  end

  describe host(input('different_zone_machine'), port: input('vnc_port'), protocol: 'tcp') do
    it { should be_resolvable }
    it { should_not be_reachable }
  end
end
