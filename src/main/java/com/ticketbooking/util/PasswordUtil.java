package com.ticketbooking.util;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.util.Base64;

/**
 * Simple SHA-256 + salt password utility.
 * In production, prefer BCrypt (add bcrypt library to pom.xml).
 */
public class PasswordUtil {

    private static final SecureRandom RANDOM = new SecureRandom();

    /** Generates a random 16-byte salt, Base64-encoded. */
    public static String generateSalt() {
        byte[] salt = new byte[16];
        RANDOM.nextBytes(salt);
        return Base64.getEncoder().encodeToString(salt);
    }

    /** Returns SHA-256(salt + password), hex-encoded. */
    public static String hashPassword(String password, String salt) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            md.update((salt + password).getBytes());
            byte[] digest = md.digest();
            StringBuilder sb = new StringBuilder();
            for (byte b : digest) sb.append(String.format("%02x", b));
            return sb.toString();
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("SHA-256 not available", e);
        }
    }

    /**
     * Stored format:  salt$hash
     * Call this when registering a new user.
     */
    public static String encode(String rawPassword) {
        String salt = generateSalt();
        return salt + "$" + hashPassword(rawPassword, salt);
    }

    /** Verify rawPassword against a stored salt$hash string. */
    public static boolean verify(String rawPassword, String stored) {
        String[] parts = stored.split("\\$", 2);
        if (parts.length != 2) return false;
        String expected = hashPassword(rawPassword, parts[0]);
        return expected.equals(parts[1]);
    }

    /** Generate a random alphanumeric booking reference. */
    public static String generateBookingRef() {
        String chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
        StringBuilder sb = new StringBuilder("BK");
        for (int i = 0; i < 8; i++) sb.append(chars.charAt(RANDOM.nextInt(chars.length())));
        return sb.toString();
    }
}
