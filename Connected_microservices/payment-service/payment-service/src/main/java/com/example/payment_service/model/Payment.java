package com.example.payment_service.model;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.Id;
import lombok.Data;

@Entity
@Data
public class Payment {
    @Id
    @GeneratedValue
    private Long id;
    private Long orderId;
    private double amount;
    private String status;
}