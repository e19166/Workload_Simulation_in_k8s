package com.example.java_order_service.repository;

import com.example.java_order_service.entity.Order;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface orderRepository extends JpaRepository<Order, Long> {}
