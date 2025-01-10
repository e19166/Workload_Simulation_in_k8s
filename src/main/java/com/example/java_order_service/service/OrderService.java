package com.example.java_order_service.service;

import com.example.java_order_service.entity.Order;
import com.example.java_order_service.repository.orderRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class OrderService {
    @Autowired
    private orderRepository repository;

    public Order save(Order order) {
        return repository.save(order);
    }

    public Order findById(Long id) {
        return repository.findById(id).orElseThrow(() -> new RuntimeException("Order not found"));
    }

    public List<Order> findAll() {
        return repository.findAll();
    }
}
