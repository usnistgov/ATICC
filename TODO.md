# To Complete for Initial Implementation:

- [x] AC
- [ ] IP
    - [x] Transiting: Covered by AC Transiting and NS Transiting or N/A
    - [x] Egress: Covered by AC Egress and NS Egress
    - [ ] Ingest: Ask for a list of banned ingress ip, run fwknop command from CLIENT profile expecting some failure condition (not a currently implemented failure condition) (JED/MAYBE)
- [ ] HC
    - [x] Ingress
    - [ ] Transiting: Adjust the runner to add a third stage in which the valid column for our credential set is adjusted, then run a test identical to ingress for an unauthenticated client (AKASH/NIKITA/…)
- [ ] NS
    - [ ] Ingress: Add two controls to gateway profile, run first control before fwknop command is run (unauthenticated tag) checking to see that no iptables rule exists allowing YOUR IP access, run second the fwknop command again and see if the rule exists (SELENA)
    - [ ] Transiting/Egress (NIKITA) 
- [ ] MS
    - [ ] SQL Query on the controller to enforce service port uniqueness constraint (AKASH)
- [ ] Updating the runner to handle all profiles (NIKITA)
