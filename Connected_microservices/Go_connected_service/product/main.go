package main

import (
    "encoding/json"
    "log"
    "net/http"
    "github.com/gorilla/mux"
    "gorm.io/gorm"
    "gorm.io/driver/postgres"
)

type Product struct {
    ID            uint    `json:"id" gorm:"primaryKey"`
    Name          string  `json:"name"`
    Price         float64 `json:"price"`
    StockQuantity int     `json:"stockQuantity"`
}

var db *gorm.DB

func main() {
    dsn := "host=product-db user=postgres password=1234 dbname=productdb port=5432 sslmode=disable"
    var err error
    db, err = gorm.Open(postgres.Open(dsn), &gorm.Config{})
    if err != nil {
        log.Fatal("failed to connect to the database: ", err)
    }

    // Auto-migrate Product model
    if err := db.AutoMigrate(&Product{}); err != nil {
        log.Fatal("failed to migrate the Product model: ", err)
    }

    // Setting up routes
    r := mux.NewRouter()
    r.HandleFunc("/api/products/{id}", getProduct).Methods("GET")
    r.HandleFunc("/api/products", createProduct).Methods("POST")
    r.HandleFunc("/api/products/{id}/stock", updateStock).Methods("PUT")

    log.Fatal(http.ListenAndServe(":8081", r))
}

func getProduct(w http.ResponseWriter, r *http.Request) {
    vars := mux.Vars(r)
    var product Product
    if err := db.First(&product, vars["id"]).Error; err != nil {
        http.Error(w, "Product not found", http.StatusNotFound)
        return
    }
    w.Header().Set("Content-Type", "application/json")
    json.NewEncoder(w).Encode(product)
}

func createProduct(w http.ResponseWriter, r *http.Request) {
    var product Product
    if err := json.NewDecoder(r.Body).Decode(&product); err != nil {
        http.Error(w, "Invalid input", http.StatusBadRequest)
        return
    }
    // Create the product
    if err := db.Create(&product).Error; err != nil {
        http.Error(w, "Failed to create product", http.StatusInternalServerError)
        return
    }
    // Send response with status created
    w.WriteHeader(http.StatusCreated)
    w.Header().Set("Content-Type", "application/json")
    json.NewEncoder(w).Encode(product)
}

func updateStock(w http.ResponseWriter, r *http.Request) {
    vars := mux.Vars(r)
    var product Product
    if err := db.First(&product, vars["id"]).Error; err != nil {
        http.Error(w, "Product not found", http.StatusNotFound)
        return
    }

    var quantity int
    if err := json.NewDecoder(r.Body).Decode(&quantity); err != nil {
        http.Error(w, "Invalid input", http.StatusBadRequest)
        return
    }

    // Ensure stock quantity doesn't go below zero
    if product.StockQuantity-quantity < 0 {
        http.Error(w, "Insufficient stock", http.StatusBadRequest)
        return
    }

    // Update stock quantity
    product.StockQuantity -= quantity
    if err := db.Save(&product).Error; err != nil {
        http.Error(w, "Failed to update stock", http.StatusInternalServerError)
        return
    }

    w.Header().Set("Content-Type", "application/json")
    json.NewEncoder(w).Encode(product)
}
