package gov.nist.csd.pm.admintool.services;

import org.springframework.boot.web.client.RestTemplateBuilder;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.util.Map;

@Service
public class RestService {
    private final  RestTemplate restTemplate;

    public RestService(RestTemplateBuilder restTemplateBuilder) {
        this.restTemplate = restTemplateBuilder.build();
    }

    public static String sendRequest(String url, HttpMethod method, Map<String, Object> params) {
        RestTemplate rt = new RestTemplate();

        HttpEntity<Map<String, Object>> request = new HttpEntity<>(params, null);
        ResponseEntity<String> response;

        if (method == HttpMethod.GET) {
            response = rt.getForEntity(url, String.class, request);
        } else /* if (method == HttpMethod.POST) */ {
            response = rt.postForEntity(url, request, String.class);
        }

        return response.getBody();
    }

    public static void getPostsPlainJSON() {
        String url = "https://jsonplaceholder.typicode.com/posts";
//        return this.restTemplate.getForObject(url, String.class);
    }
}
