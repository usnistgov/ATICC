title "Access Control Client Tests"

control "AC-Ingress Unauthenticated" do
  impact 0.7
  title "Access Control Ingress - Unauthenticated Client"
  desc "Access control protections prevent the ingest of unauthorized network traffic."
  tag "Capability":"Network"
  tag "TIC Version":"3.0"
  tag "Access Control"
  tag "Ingress"
  tag "Unauthenticated"

  describe host(input('dev_machine_address'), port: input('fforce_app_port'), protocol: 'tcp') do
    it { should be_resolvable }
    it { should_not be_reachable }
  end

  describe host(input('dev_machine_address'), port: input('telnet_port'), protocol: 'tcp') do
    it { should be_resolvable }
    it { should_not be_reachable }
  end

  describe host(input('dev_machine_address'), port: input('ssh_port'), protocol: 'tcp') do
    it { should be_resolvable }
    it { should_not be_reachable }
  end

  describe host(input('dev_machine_address'), port: input('vnc_port'), protocol: 'tcp') do
    it { should be_resolvable }
    it { should_not be_reachable }
  end
end

control "AC-Ingress Authenticated" do
  impact 0.7
  title "Access Control Ingress - Authenticated Client"
  desc "Access control protections allow the ingest of authorized network traffic."
  tag "Capability":"Network"
  tag "TIC Version":"3.0"
  tag "Access Control"
  tag "Ingress"
  tag "Authenticated"

  describe host(input('dev_machine_address'), port: input('fforce_app_port'), protocol: 'tcp') do
    it { should be_resolvable }
    it { should be_reachable }
  end

  describe host(input('dev_machine_address'), port: input('telnet_port'), protocol: 'tcp') do
    it { should be_resolvable }
    it { should be_reachable }
  end

  describe host(input('dev_machine_address'), port: input('ssh_port'), protocol: 'tcp') do
    it { should be_resolvable }
    it { should be_reachable }
  end

  describe host(input('dev_machine_address'), port: input('vnc_port'), protocol: 'tcp') do
    it { should be_resolvable }
    it { should be_reachable }
  end
end
