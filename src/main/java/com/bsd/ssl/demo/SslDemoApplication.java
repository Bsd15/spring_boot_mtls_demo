package com.bsd.ssl.demo;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@SpringBootApplication
@RestController
@RequestMapping("/ssl-demo")
public class SslDemoApplication {

	public static void main(String[] args) {
		SpringApplication.run(SslDemoApplication.class, args);
	}

	@GetMapping
	public ResponseEntity<String> index() {
		return ResponseEntity.ok("Hello World!");
	}

}
