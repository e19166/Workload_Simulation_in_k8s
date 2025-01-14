package com.example.order_service.model;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.Data;

@Entity
@Data
@Table(name = "orders")
public class Order {
    @Id
    @GeneratedValue
    private Long id;
    private Long productId;
    private int quantity;
    private double totalAmount;
    private String status;
}

