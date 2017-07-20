package main

import (
	"fmt"
	"net/http"
)

func helloWorldHandler(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(w, "Hello World")
}

func main() {
	fmt.Print("Server running on port 8080")

	http.HandleFunc("/", helloWorldHandler)

	http.ListenAndServe(":8080", nil)
}
