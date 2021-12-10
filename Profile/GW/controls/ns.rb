title "Network Segmentation Tests for Gateway"

control "NS/IP-Ingress Unauthenticated" do
  impact 0.7
  title "Network Segmentation/IP Denylisting Ingress - Unauthenticated Client"
  desc "Network Segmentation through the gateway enforces that the subnetworks divide up the the logical parts of the overall network."
  desc "IP Denylisting Protections prevent the ingest of traffic from a denylisted (external) IP address"

  tag "Capability":"Network"
  tag "TIC Version":"3.0"
  tag "Network Segmentation"
  tag "IP Denylisting"
  tag "Ingress"
  tag "Unauthenticated"

  describe iptables(chain:'INPUT') do
    it { should_not have_rule('-P INPUT ACCEPT') }
    it { should have_rule('-P INPUT DROP') }
  end
end

control "NS-Ingress Authenticated" do
  impact 0.7
  title "Network Segmentation Ingress - Authenticated Client"
  desc "Network Segmentation through the gateway enforces that the subnetworks divide up the the logical parts of the overall network."

  tag "Capability":"Network"
  tag "TIC Version":"3.0"
  tag "Network Segmentation"
  tag "Ingress"
  tag "Authenticated"

  describe command('iptables -S | grep -q "^\-A FWKNOP_INPUT \-s ' + input('public_ip').gsub! '.', '\.' + '\/32 \-p tcp"') do
    it { should exist }
    its('exit_status') { should eq 0 }
  end
end

control "NS/IP-Egress" do
  impact 0.7
  title "Network Segmentation/IP Denylisting Egress"
  desc "Network Segmentation protections though the gateway enforces that there is sufficient seperation between the internal and external network."
  desc "IP Denylisting protections prevent the egress of traffic from a denylisted (external) IP address"

  tag "Capability":"Network"
  tag "TIC Version":"3.0"
  tag "Network Segmentation"
  tag "Egress"
  tag "IP Denylisting"
  tag "NoState"

  describe iptables(chain:'OUTPUT') do
    it { should have_rule('-P OUTPUT DROP') }
  end
end
