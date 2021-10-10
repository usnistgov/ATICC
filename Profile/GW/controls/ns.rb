title "Network Segmentation Tests for Gateway"

control "NS-Ingress" do
  impact 0.7
  title "Network Segmentation Ingress"

  tag "Capability":"Network"
  tag "TIC Version":"3.0"
  tag "Network Segmentation"
  tag "Ingress"

  describe iptables(chain:'INPUT') do
    it { should have_rule('-P INPUT DROP') }
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
