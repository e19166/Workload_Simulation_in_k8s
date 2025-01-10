package com.example.java_order_service.controller;

import com.example.java_order_service.entity.Order;
import com.example.java_order_service.service.OrderService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/orders")
public class orderController {
    @Autowired
    private OrderService service;

    @PostMapping
    public ResponseEntity<Order> createOrder(@RequestBody Order order) {
        return new ResponseEntity<>(service.save(order), HttpStatus.CREATED);
    }

    @GetMapping("/{id}")
    public ResponseEntity<Order> getOrder(@PathVariable Long id) {
        return ResponseEntity.ok(service.findById(id));
    }

    @GetMapping
    public ResponseEntity<List<Order>> listOrders() {
        return ResponseEntity.ok(service.findAll());
    }
}
