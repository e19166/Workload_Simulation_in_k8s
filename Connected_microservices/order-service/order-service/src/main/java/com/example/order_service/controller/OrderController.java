//Author: Wishula Jayathunga
package com.example.order_service.controller;

import com.example.order_service.model.Order;
import com.example.order_service.repository.OrderRepository;

import java.util.Map;

//import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.client.RestTemplate;

@RestController
@RequestMapping("/api/orders")
public class OrderController {
    @Autowired
    private OrderRepository orderRepository;
    
    @Autowired
    private RestTemplate restTemplate;

    @PostMapping
    public ResponseEntity<Order> createOrder(@RequestBody Order order) {
        // Update product stock
        restTemplate.put("http://product-service:9090/api/products/" + 
            order.getProductId() + "/stock?quantity=" + order.getQuantity(), null);
        
        // Create payment
        // Replace restTemplate.post with restTemplate.postForObject
restTemplate.postForObject("http://payment-service:9092/api/payments", 
Map.of("orderId", order.getId(), "amount", order.getTotalAmount()), Void.class);

        
        order.setStatus("CREATED");
        return ResponseEntity.ok(orderRepository.save(order));
    }

    @GetMapping("/{id}")
    public ResponseEntity<Order> getOrder(@PathVariable Long id) {
        return ResponseEntity.ok(orderRepository.findById(id).orElseThrow());
    }
}

