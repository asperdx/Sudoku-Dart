package main

import (
	"fmt"
	"go/build"
	"html/template"
	"log"
	"net/http"
	"path/filepath"
)

var tmpl *template.Template

func handleIndex(w http.ResponseWriter, r *http.Request) {
	wsURL := fmt.Sprintf("ws://%s/ws", r.Host)
	if r.URL.Path != "/" {
		http.Error(w, "Not Found", http.StatusNotFound)
		return
	}
	if err := tmpl.Execute(w, wsURL); err != nil {
		log.Printf("tmpl.Execute: %v", err)
	}
}

func handleFile(path string) http.HandlerFunc {
	path = filepath.Join(root, path)
	return func(w http.ResponseWriter, r *http.Request) {
		http.ServeFile(w, r, path)
	}
}

const basePkg = "github.com/TheSoberRussian/webserver"

var root string = "."

func main() {

	p, err := build.Default.Import(basePkg, "", build.FindOnly)
	if err != nil {
		log.Fatalf("Couldn't find index files: %v", err)
	}

	root = p.Dir

	tmpl, err = template.ParseFiles(filepath.Join(root, "index.html"))
	if err != nil {
		log.Fatalf("Couldn't parse index.html: %v", err)
	}

	http.HandleFunc("/", handleIndex)
	http.HandleFunc("/style.css", handleFile("style.css"))
	http.HandleFunc("/favicon.ico", handleFile("favicon.ico"))
	http.HandleFunc("/sudoku.dart", handleFile("sudoku.dart"))
	http.HandleFunc("/packages/browser/dart.js", handleFile("dart.js"))

	http.ListenAndServe(":8080", nil)
}
