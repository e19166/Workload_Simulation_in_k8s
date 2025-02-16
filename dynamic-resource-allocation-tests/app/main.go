package main

import (
	"fmt"
	"log"
	"math/rand"
	"net/http"
	"time"

	"github.com/prometheus/client_golang/prometheus"
	"github.com/prometheus/client_golang/prometheus/promhttp"
)

var requestLatency = prometheus.NewHistogram(prometheus.HistogramOpts{
	Name:    "http_server_request_duration_seconds",
	Help:    "Histogram for request latency",
	Buckets: prometheus.LinearBuckets(0.01, 0.02, 10),
})

func handler(w http.ResponseWriter, r *http.Request) {
	start := time.Now()

	// Simulate work with random latency (50ms - 250ms)
	workTime := time.Duration(50+rand.Intn(200)) * time.Millisecond
	time.Sleep(workTime)

	duration := time.Since(start).Seconds()
	requestLatency.Observe(duration)

	w.WriteHeader(http.StatusOK)
	fmt.Fprintf(w, "Response time: %.3f seconds\n", duration)
}

func main() {
	rand.Seed(time.Now().UnixNano())

	// Register Prometheus metrics
	prometheus.MustRegister(requestLatency)

	http.HandleFunc("/", handler)
	http.Handle("/metrics", promhttp.Handler())

	log.Println("Starting test app on port 8085...")
	log.Fatal(http.ListenAndServe(":8085", nil))
}
