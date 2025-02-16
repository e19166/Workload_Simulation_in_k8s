package main  

import (  
	"fmt"  
	"log"  
	"math/rand"  
	"net/http"  
	"time"  
)  

func handler(w http.ResponseWriter, r *http.Request) {  
	start := time.Now()  

	// Simulate processing time (increases with lower CPU/memory)  
	randomDelay := time.Duration(rand.Intn(100)) * time.Millisecond  
	time.Sleep(50*time.Millisecond + randomDelay)  

	duration := time.Since(start)  
	fmt.Fprintf(w, "Request took %v\n", duration)  
}  

func main() {  
	http.HandleFunc("/", handler)  
	fmt.Println("Server is running on port 8085...")  
	log.Fatal(http.ListenAndServe(":8085", nil))  
}
