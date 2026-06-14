package com.ticketbooking.model;

import java.sql.Timestamp;

public class User {
    private int userId;
    private String username;
    private String email;
    private String passwordHash;
    private String fullName;
    private String phone;
    private Timestamp createdAt;

    public User() {}

    public User(String username, String email, String passwordHash, String fullName, String phone) {
        this.username     = username;
        this.email        = email;
        this.passwordHash = passwordHash;
        this.fullName     = fullName;
        this.phone        = phone;
    }

    // Getters & Setters
    public int       getUserId()       { return userId; }
    public void      setUserId(int v)  { this.userId = v; }
    public String    getUsername()     { return username; }
    public void      setUsername(String v)     { this.username = v; }
    public String    getEmail()        { return email; }
    public void      setEmail(String v)        { this.email = v; }
    public String    getPasswordHash() { return passwordHash; }
    public void      setPasswordHash(String v) { this.passwordHash = v; }
    public String    getFullName()     { return fullName; }
    public void      setFullName(String v)     { this.fullName = v; }
    public String    getPhone()        { return phone; }
    public void      setPhone(String v)        { this.phone = v; }
    public Timestamp getCreatedAt()    { return createdAt; }
    public void      setCreatedAt(Timestamp v) { this.createdAt = v; }
}
