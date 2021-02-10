package gov.nist.csd.pm.admintool.services;

import org.springframework.boot.web.client.RestTemplateBuilder;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.http.converter.json.MappingJackson2HttpMessageConverter;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.util.Arrays;
import java.util.Map;

@Service
public class RestService {
    private final  RestTemplate restTemplate;

    public RestService(RestTemplateBuilder restTemplateBuilder) {
        this.restTemplate = restTemplateBuilder.build();
    }

    public static coordinatorResponse sendRequest(String url, HttpMethod method, Map<String, Object> params) {
        RestTemplate rt = new RestTemplate();
        HttpEntity<Map<String, Object>> request = new HttpEntity<>(params, null);
        ResponseEntity<coordinatorResponse> response;
        coordinatorResponse noResponse = new coordinatorResponse();

        MappingJackson2HttpMessageConverter converter = new MappingJackson2HttpMessageConverter();

        converter.setSupportedMediaTypes(Arrays.asList(MediaType.TEXT_PLAIN, MediaType.APPLICATION_JSON));

        rt.getMessageConverters().add(converter);

        if (method == HttpMethod.GET) {
            try {
                response = rt.getForEntity(url, coordinatorResponse.class, request);
            } catch (Exception e) {
                noResponse.summary = e.getMessage();
                noResponse.success = false;
                return noResponse;
            }
        } else /* if (method == HttpMethod.POST) */ {
            try {
                response = rt.postForEntity(url, request, coordinatorResponse.class);
            } catch (Exception e) {
                noResponse.summary = e.getMessage();
                noResponse.success = false;
                return noResponse;
            }
        }

        return response.getBody();
    }
}