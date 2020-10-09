# Architecture

- Two Parts:
    - Dashboard
        - Purpose: Will start the tests, and display the results of each test.
            - Should be able to communicate with the coordinator to start tests.
            - Waits for finished signal from coordinator.
            - From there it will read the SDP controllers tables, and will gather whatever information is necessary to display the results of the tests.
            - It should have configuration options to choose which tests to run.
        - Language: Java, Vaadin Framework
        - Location: Deployed on 2 Twelve's Kubernetes platform
    - Coordinator
        - Purpose: Will actually execute the tests (and coordinate between the two clients for certain tests)
            - It will spawn 2 Clients:
                - The good (tester1) client who will have an SDP Client, and
                - the bad (tester2) client who will not have an SDP client.
            - It will run the tests the the dashboard tells it to, and will send a finished signal when done.
        - Language: GO
        - Location: VM on any local machine
- Both parts of the tool should be able to communicate with each other.
