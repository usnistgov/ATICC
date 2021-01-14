package gov.nist.csd.pm.admintool.services;

import org.springframework.boot.web.client.RestTemplateBuilder;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

@Service
public class RestService {
    private final  RestTemplate restTemplate;

    public RestService(RestTemplateBuilder restTemplateBuilder) {
        this.restTemplate = restTemplateBuilder.build();
    }

    public static void getPostsPlainJSON() {
        String url = "https://jsonplaceholder.typicode.com/posts";
//        return this.restTemplate.getForObject(url, String.class);
    }
}
