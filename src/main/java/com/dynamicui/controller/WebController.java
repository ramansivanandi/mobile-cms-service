package com.dynamicui.controller;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.dynamicui.dto.ApiResponse;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.extern.slf4j.Slf4j;
import reactor.core.publisher.Mono;

@RestController
@RequestMapping("/api")
@Slf4j
@Tag(name = "Web Services", description = "Mock API endpoints for testing dynamic UI actions and on-load services")
public class WebController {

    @GetMapping("/user/profile")
    @Operation(summary = "Get user profile", description = "Retrieves user profile information")
    public Mono<ResponseEntity<ApiResponse<Map<String, Object>>>> getUserProfile(
            @RequestHeader(value = "Authorization", required = false) String authorization) {

        log.info("GET /api/user/profile - Loading user profile");

        Map<String, Object> profile = new HashMap<>();
        profile.put("userId", "12345");
        profile.put("username", "john.doe");
        profile.put("email", "john.doe@example.com");
        profile.put("salary", "75000");
        profile.put("department", "IT");
        profile.put("address", "123 Main Street, City, State 12345");
        profile.put("firstName", "John");
        profile.put("lastName", "Doe");
        profile.put("age", 30);
        profile.put("phone", "+1234567890");
        profile.put("lastLogin", LocalDateTime.now().minusDays(2).toString());

        return Mono.just(ResponseEntity.ok(ApiResponse.success(profile)));
    }

    @GetMapping("/cars/brands")
    @Operation(summary = "Get car brands", description = "Retrieves list of available car brands")
    public Mono<ResponseEntity<ApiResponse<List<Map<String, Object>>>>> getCarBrands(
            @RequestParam(value = "category", required = false) String category) {

        log.info("GET /api/cars/brands - category: {}", category);

        List<Map<String, Object>> brands = new ArrayList<>();

        Map<String, Object> brand1 = new HashMap<>();
        brand1.put("id", "1");
        brand1.put("name", "Toyota");
        brand1.put("country", "Japan");
        brands.add(brand1);

        Map<String, Object> brand2 = new HashMap<>();
        brand2.put("id", "2");
        brand2.put("name", "Nissan");
        brand2.put("country", "Japan");
        brands.add(brand2);

        Map<String, Object> brand3 = new HashMap<>();
        brand3.put("id", "3");
        brand3.put("name", "BMW");
        brand3.put("country", "Germany");
        brands.add(brand3);

        Map<String, Object> brand4 = new HashMap<>();
        brand4.put("id", "4");
        brand4.put("name", "Mercedes-Benz");
        brand4.put("country", "Germany");
        brands.add(brand4);

        Map<String, Object> brand5 = new HashMap<>();
        brand5.put("id", "5");
        brand5.put("name", "Ford");
        brand5.put("country", "USA");
        brands.add(brand5);

        return Mono.just(ResponseEntity.ok(ApiResponse.success(brands)));
    }

    @PostMapping("/forms/initialize")
    @Operation(summary = "Initialize form", description = "Initializes form with default values")
    public Mono<ResponseEntity<ApiResponse<Map<String, Object>>>> initializeForm(
            @RequestBody(required = false) Map<String, Object> request,
            @RequestHeader(value = "Authorization", required = false) String authorization) {

        log.info("POST /api/forms/initialize - request: {}", request);

        Map<String, Object> formData = new HashMap<>();
        formData.put("formType", request != null ? request.get("formType") : "insurance");
        formData.put("userId", request != null ? request.get("userId") : "12345");
        formData.put("defaultAge", 25);
        formData.put("defaultCarBrand", "Toyota");
        formData.put("termsAccepted", false);
        formData.put("initializedAt", LocalDateTime.now().toString());
        formData.put("formVersion", "1.0");

        return Mono.just(ResponseEntity.ok(ApiResponse.success(formData)));
    }

    @GetMapping("/config/settings")
    @Operation(summary = "Get configuration settings", description = "Retrieves application configuration settings")
    public Mono<ResponseEntity<ApiResponse<Map<String, Object>>>> getConfigSettings(
            @RequestParam(value = "category", required = false) String category) {

        log.info("GET /api/config/settings - category: {}", category);

        Map<String, Object> config = new HashMap<>();
        config.put("category", category != null ? category : "motor");
        config.put("maxAge", 100);
        config.put("minAge", 18);
        config.put("supportedCountries", Arrays.asList("USA", "UK", "Canada", "Australia"));
        config.put("currency", "USD");
        config.put("timezone", "UTC");
        config.put("features", Map.of(
                "multiLanguage", true,
                "darkMode", false,
                "notifications", true
        ));
        config.put("apiVersion", "v1");
        config.put("lastUpdated", LocalDateTime.now().toString());

        return Mono.just(ResponseEntity.ok(ApiResponse.success(config)));
    }

    @GetMapping("/validation/rules")
    @Operation(summary = "Get validation rules", description = "Retrieves validation rules for form fields")
    public Mono<ResponseEntity<ApiResponse<Map<String, Object>>>> getValidationRules() {

        log.info("GET /api/validation/rules - Loading validation rules");

        Map<String, Object> rules = new HashMap<>();

        Map<String, Object> ageRules = new HashMap<>();
        ageRules.put("required", true);
        ageRules.put("min", 18);
        ageRules.put("max", 100);
        ageRules.put("pattern", "^[0-9]+$");
        ageRules.put("message", "Age must be between 18 and 100");
        rules.put("age", ageRules);

        Map<String, Object> carBrandRules = new HashMap<>();
        carBrandRules.put("required", true);
        carBrandRules.put("message", "Please select a car brand");
        rules.put("carBrand", carBrandRules);

        Map<String, Object> emailRules = new HashMap<>();
        emailRules.put("required", false);
        emailRules.put("pattern", "^[A-Za-z0-9+_.-]+@(.+)$");
        emailRules.put("message", "Please enter a valid email address");
        rules.put("email", emailRules);

        Map<String, Object> phoneRules = new HashMap<>();
        phoneRules.put("required", false);
        phoneRules.put("pattern", "^\\+?[1-9]\\d{1,14}$");
        phoneRules.put("message", "Please enter a valid phone number");
        rules.put("phone", phoneRules);

        return Mono.just(ResponseEntity.ok(ApiResponse.success(rules)));
    }

    @GetMapping("/users/list")
    @Operation(summary = "Get user list", description = "Retrieves list of users for datatable display")
    public Mono<ResponseEntity<ApiResponse<List<Map<String, Object>>>>> getUserList(
            @RequestHeader(value = "Content-Type", required = false) String contentType) {

        log.info("GET /api/users/list - Loading user list");

        List<Map<String, Object>> users = new ArrayList<>();

        Map<String, Object> user1 = new HashMap<>();
        user1.put("id", 1);
        user1.put("name", "John Doe");
        user1.put("email", "john@example.com");
        user1.put("role", "Admin");
        user1.put("status", "Active");
        user1.put("createdAt", LocalDateTime.now().minusMonths(6).toString());
        users.add(user1);

        Map<String, Object> user2 = new HashMap<>();
        user2.put("id", 2);
        user2.put("name", "Jane Smith");
        user2.put("email", "jane@example.com");
        user2.put("role", "User");
        user2.put("status", "Active");
        user2.put("createdAt", LocalDateTime.now().minusMonths(3).toString());
        users.add(user2);

        Map<String, Object> user3 = new HashMap<>();
        user3.put("id", 3);
        user3.put("name", "Bob Johnson");
        user3.put("email", "bob@example.com");
        user3.put("role", "User");
        user3.put("status", "Inactive");
        user3.put("createdAt", LocalDateTime.now().minusMonths(1).toString());
        users.add(user3);

        Map<String, Object> user4 = new HashMap<>();
        user4.put("id", 4);
        user4.put("name", "Alice Williams");
        user4.put("email", "alice@example.com");
        user4.put("role", "Manager");
        user4.put("status", "Active");
        user4.put("createdAt", LocalDateTime.now().minusWeeks(2).toString());
        users.add(user4);

        Map<String, Object> user5 = new HashMap<>();
        user5.put("id", 5);
        user5.put("name", "Charlie Brown");
        user5.put("email", "charlie@example.com");
        user5.put("role", "User");
        user5.put("status", "Active");
        user5.put("createdAt", LocalDateTime.now().minusDays(5).toString());
        users.add(user5);

        return Mono.just(ResponseEntity.ok(ApiResponse.success(users)));
    }

    @GetMapping("/profile/get")
    @Operation(summary = "Get profile", description = "Retrieves user profile with username, salary, department, and address")
    public Mono<ResponseEntity<ApiResponse<Map<String, Object>>>> getProfile(
            @RequestHeader(value = "Authorization", required = false) String authorization) {

        log.info("GET /api/profile/get - Loading profile data");

        Map<String, Object> profile = new HashMap<>();
        profile.put("username", "john.doe");
        profile.put("salary", "75000");
        profile.put("department", "IT Department");
        profile.put("address", "123 Main Street, Suite 100, City, State 12345");

        return Mono.just(ResponseEntity.ok(ApiResponse.success(profile)));
    }

    @PostMapping("/insurance/submit")
    @Operation(summary = "Submit insurance form", description = "Submits insurance application form data")
    public Mono<ResponseEntity<ApiResponse<Map<String, Object>>>> submitInsurance(
            @RequestBody Map<String, Object> request,
            @RequestHeader(value = "Authorization", required = false) String authorization) {

        log.info("POST /api/insurance/submit - request: {}", request);

        if (request.get("age") == null || request.get("carBrand") == null) {
            Map<String, Object> errorData = new HashMap<>();
            errorData.put("message", "Missing required fields: age and carBrand");
            errorData.put("errors", Arrays.asList("age is required", "carBrand is required"));
            return Mono.just(ResponseEntity.badRequest()
                    .body(ApiResponse.error("400001", "BAD_REQUEST", errorData)));
        }

        Map<String, Object> responseData = new HashMap<>();
        responseData.put("success", true);
        responseData.put("message", "Insurance application submitted successfully");
        responseData.put("applicationId", "APP-" + System.currentTimeMillis());
        responseData.put("submittedAt", LocalDateTime.now().toString());
        responseData.put("status", "pending");
        responseData.put("estimatedProcessingTime", "2-3 business days");
        responseData.put("data", request);

        return Mono.just(ResponseEntity.ok(ApiResponse.success(responseData)));
    }

    @PutMapping("/user/profile")
    @Operation(summary = "Update user profile", description = "Updates user profile information")
    public Mono<ResponseEntity<ApiResponse<Map<String, Object>>>> updateUserProfile(
            @RequestBody Map<String, Object> request,
            @RequestHeader(value = "Authorization", required = false) String authorization) {

        log.info("PUT /api/user/profile - request: {}", request);

        Map<String, Object> responseData = new HashMap<>();
        responseData.put("success", true);
        responseData.put("message", "Profile updated successfully");
        responseData.put("userId", "12345");
        responseData.put("updatedFields", new ArrayList<>(request.keySet()));
        responseData.put("updatedAt", LocalDateTime.now().toString());
        responseData.put("data", request);

        return Mono.just(ResponseEntity.ok(ApiResponse.success(responseData)));
    }

    @DeleteMapping("/items/{itemId}")
    @Operation(summary = "Delete item", description = "Deletes an item by ID")
    public Mono<ResponseEntity<ApiResponse<Map<String, Object>>>> deleteItem(
            @Parameter(description = "Item ID", required = true, example = "123")
            @PathVariable String itemId,
            @RequestHeader(value = "Authorization", required = false) String authorization) {

        log.info("DELETE /api/items/{} - Deleting item", itemId);

        if ("999".equals(itemId) || "notfound".equals(itemId)) {
            Map<String, Object> errorData = new HashMap<>();
            errorData.put("message", "Item not found");
            errorData.put("itemId", itemId);
            return Mono.just(ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body(ApiResponse.error("404001", "NOT_FOUND", errorData)));
        }

        Map<String, Object> responseData = new HashMap<>();
        responseData.put("success", true);
        responseData.put("message", "Item deleted successfully");
        responseData.put("itemId", itemId);
        responseData.put("deletedAt", LocalDateTime.now().toString());

        return Mono.just(ResponseEntity.ok(ApiResponse.success(responseData)));
    }

    @GetMapping("/health")
    @Operation(summary = "Health check", description = "Returns service health status")
    public Mono<ResponseEntity<ApiResponse<Map<String, Object>>>> health() {
        Map<String, Object> healthData = new HashMap<>();
        healthData.put("status", "UP");
        healthData.put("timestamp", LocalDateTime.now().toString());
        healthData.put("service", "Dynamic UI Configuration Service");
        return Mono.just(ResponseEntity.ok(ApiResponse.success(healthData)));
    }
}
