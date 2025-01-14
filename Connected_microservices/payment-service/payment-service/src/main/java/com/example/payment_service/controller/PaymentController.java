package com.example.payment_service.controller;

import com.example.payment_service.model.Payment;
import com.example.payment_service.repository.PaymentRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/payments")
public class PaymentController {
    @Autowired
    private PaymentRepository paymentRepository;

    @PostMapping
    public ResponseEntity<Payment> processPayment(@RequestBody Payment payment) {
        payment.setStatus("COMPLETED");
        return ResponseEntity.ok(paymentRepository.save(payment));
    }

    @GetMapping("/{id}")
    public ResponseEntity<Payment> getPayment(@PathVariable Long id) {
        return ResponseEntity.ok(paymentRepository.findById(id).orElseThrow());
    }
}
