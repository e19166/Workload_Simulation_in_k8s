package com.example.product_service.controller;

import com.example.product_service.model.Product;
import com.example.product_service.repository.ProductRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/products")
public class ProductController {
    @Autowired
    private ProductRepository productRepository;

    @GetMapping("/{id}")
    public ResponseEntity<Product> getProduct(@PathVariable Long id) {
        return ResponseEntity.ok(productRepository.findById(id).orElseThrow());
    }

    @PostMapping
    public ResponseEntity<Product> createProduct(@RequestBody Product product) {
        return ResponseEntity.ok(productRepository.save(product));
    }

    @PutMapping("/{id}/stock")
    public ResponseEntity<Product> updateStock(@PathVariable Long id, @RequestParam int quantity) {
        Product product = productRepository.findById(id).orElseThrow();
        product.setStockQuantity(product.getStockQuantity() - quantity);
        return ResponseEntity.ok(productRepository.save(product));
    }
}