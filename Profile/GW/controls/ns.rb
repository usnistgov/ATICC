title "Network Segmentation Tests for Gateway"

control "NS-Ingress Unauthenticated" do
  impact 0.7
  title "Network Segmentation Ingress - Unauthenticated Client"
  desc "Network Segmentation through the gateway enforces that the subnetworks divide up the the logical parts of the overall network."

  tag "Capability":"Network"
  tag "TIC Version":"3.0"
  tag "Network Segmentation"
  tag "Ingress"
  tag "Unauthenticated"

  describe iptables(chain:'INPUT') do
    it { should_not have_rule('-P INPUT ACCEPT') }
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

  describe iptables(chain:'INPUT') do
    it { should have_rule('-P INPUT ACCEPT') }
  end
end

control "NS-Egress" do
  impact 0.7
  title "Network Segmentation Egress"

  tag "Capability":"Network"
  tag "TIC Version":"3.0"
  tag "Network Segmentation"
  tag "Egress"

  describe iptables(chain:'OUTPUT') do
    it { should have_rule('-P OUTPUT DROP') }
  end
end
