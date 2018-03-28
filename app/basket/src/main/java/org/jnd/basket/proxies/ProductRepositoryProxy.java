package org.jnd.basket.proxies;

import org.jnd.microservices.model.Product;
import org.jnd.microservices.trace.InfoLineBuilder;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.ParameterizedTypeReference;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestTemplate;


@Component("ProductRepositoryProxy")
public class ProductRepositoryProxy {

    private Log log = LogFactory.getLog(ProductRepositoryProxy.class);


    @Autowired
    private RestTemplate loadBalancedRestTemplate;

    public Product getProduct(String id) {

        String[] args = { ProductRepositoryProxy.class.getName(), "getProduct", "basket", id };
        log.debug(InfoLineBuilder.getLine(args, null, null));


        ResponseEntity<Product> exchange =
                this.loadBalancedRestTemplate.exchange(
                        "http://product/product/{id}",
                        HttpMethod.GET,
                        null,
                        new ParameterizedTypeReference<Product>() {},
                        id);

        Product resp = exchange.getBody();
        log.debug("Product Response : "+resp);

        if (resp == null)
            throw new RuntimeException();

        return resp;
    }


}