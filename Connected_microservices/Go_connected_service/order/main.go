// Author: Wishula Jayathunga
package main

import (
	"bytes"
	"encoding/json"
	"log"
	"net/http"
	"github.com/gorilla/mux"
	"gorm.io/gorm"
	"gorm.io/driver/postgres"
)

type Order struct {
	ID          uint    `json:"id" gorm:"primaryKey"`
	ProductID   uint    `json:"productId"`
	Quantity    int     `json:"quantity"`
	TotalAmount float64 `json:"totalAmount"`
	Status      string  `json:"status"`
}

var db *gorm.DB

func main() {
	dsn := "host=order-db user=postgres password=1234 dbname=orderdb port=5432 sslmode=disable"
	var err error
	db, err = gorm.Open(postgres.Open(dsn), &gorm.Config{})
	if err != nil {
		log.Fatal(err)
	}

	// Auto-migrate the Payment model
	if err := db.AutoMigrate(&Order{}); err != nil {
		log.Fatal("failed to migrate the Order model: ", err)
	}

	// Initialize router and routes
	r := mux.NewRouter()
	r.HandleFunc("/api/orders", createOrder).Methods("POST")
	r.HandleFunc("/api/orders/{id}", getOrder).Methods("GET")

	// Start the server
	log.Fatal(http.ListenAndServe(":8080", r))
}

func createOrder(w http.ResponseWriter, r *http.Request) {
	var order Order
	// Decode incoming JSON body into order struct
	if err := json.NewDecoder(r.Body).Decode(&order); err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}

	// Update product stock (handle potential errors from product service)
	updateStockURL := "http://product-service:8081/api/products/" + string(order.ProductID) + "/stock"
	stockBody, _ := json.Marshal(order.Quantity)
	resp, err := http.Post(updateStockURL, "application/json", bytes.NewBuffer(stockBody))
	if err != nil || resp.StatusCode != http.StatusOK {
		http.Error(w, "Failed to update product stock", http.StatusInternalServerError)
		return
	}

	// Create payment (handle potential errors from payment service)
	paymentURL := "http://payment-service:8082/api/payments"
	payment := map[string]interface{}{
		"orderId": order.ID,
		"amount":  order.TotalAmount,
	}
	paymentBody, _ := json.Marshal(payment)
	resp, err = http.Post(paymentURL, "application/json", bytes.NewBuffer(paymentBody))
	if err != nil || resp.StatusCode != http.StatusOK {
		http.Error(w, "Failed to create payment", http.StatusInternalServerError)
		return
	}

	// Set initial order status
	order.Status = "CREATED"

	// Save the order to the database
	if err := db.Create(&order).Error; err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	// Send the created order back as JSON response
	w.WriteHeader(http.StatusCreated)
	json.NewEncoder(w).Encode(order)
}

func getOrder(w http.ResponseWriter, r *http.Request) {
	vars := mux.Vars(r)
	var order Order
	// Fetch the order from the database by ID
	if err := db.First(&order, vars["id"]).Error; err != nil {
		http.Error(w, err.Error(), http.StatusNotFound)
		return
	}
	// Return the order as JSON response
	json.NewEncoder(w).Encode(order)
}
