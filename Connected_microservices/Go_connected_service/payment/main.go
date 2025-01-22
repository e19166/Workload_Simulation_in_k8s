package main

import (
	"encoding/json"
	"log"
	"net/http"
	"github.com/gorilla/mux"
	"gorm.io/gorm"
	"gorm.io/driver/postgres"
)

type Payment struct {
	ID      uint    `json:"id" gorm:"primaryKey"`
	OrderID uint    `json:"orderId"`
	Amount  float64 `json:"amount"`
	Status  string  `json:"status"`
}

var db *gorm.DB

func main() {
	dsn := "host=payment-db user=postgres password=1234 dbname=paymentdb port=5432 sslmode=disable"
	var err error
	db, err = gorm.Open(postgres.Open(dsn), &gorm.Config{})
	if err != nil {
		log.Fatal("failed to connect to the database: ", err)
	}

	// Auto-migrate the Payment model
	if err := db.AutoMigrate(&Payment{}); err != nil {
		log.Fatal("failed to migrate the Payment model: ", err)
	}

	r := mux.NewRouter()
	r.HandleFunc("/api/payments", processPayment).Methods("POST")
	r.HandleFunc("/api/payments/{id}", getPayment).Methods("GET")

	log.Fatal(http.ListenAndServe(":8082", r))
}

func processPayment(w http.ResponseWriter, r *http.Request) {
	var payment Payment
	// Decode the incoming JSON body into the Payment struct
	if err := json.NewDecoder(r.Body).Decode(&payment); err != nil {
		http.Error(w, "Invalid input", http.StatusBadRequest)
		return
	}

	// Validate the incoming payment (e.g., ensure Amount and OrderID are valid)
	if payment.OrderID == 0 || payment.Amount <= 0 {
		http.Error(w, "Invalid order ID or amount", http.StatusBadRequest)
		return
	}

	// Set payment status and save it in the database
	payment.Status = "COMPLETED"
	if err := db.Create(&payment).Error; err != nil {
		http.Error(w, "Failed to process payment", http.StatusInternalServerError)
		return
	}

	// Return the created payment as a JSON response
	w.WriteHeader(http.StatusCreated)
	json.NewEncoder(w).Encode(payment)
}

func getPayment(w http.ResponseWriter, r *http.Request) {
	vars := mux.Vars(r)
	var payment Payment
	// Fetch the payment from the database by ID
	if err := db.First(&payment, vars["id"]).Error; err != nil {
		http.Error(w, "Payment not found", http.StatusNotFound)
		return
	}

	// Return the payment as a JSON response
	json.NewEncoder(w).Encode(payment)
}
