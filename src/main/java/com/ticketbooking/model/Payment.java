package com.ticketbooking.model;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class Payment {
    private int        paymentId;
    private int        bookingId;
    private BigDecimal amount;
    private String     paymentMethod;
    private String     transactionId;
    private Timestamp  paymentTime;
    private String     status;

    public int        getPaymentId()                 { return paymentId; }
    public void       setPaymentId(int v)            { this.paymentId = v; }
    public int        getBookingId()                 { return bookingId; }
    public void       setBookingId(int v)            { this.bookingId = v; }
    public BigDecimal getAmount()                    { return amount; }
    public void       setAmount(BigDecimal v)        { this.amount = v; }
    public String     getPaymentMethod()             { return paymentMethod; }
    public void       setPaymentMethod(String v)     { this.paymentMethod = v; }
    public String     getTransactionId()             { return transactionId; }
    public void       setTransactionId(String v)     { this.transactionId = v; }
    public Timestamp  getPaymentTime()               { return paymentTime; }
    public void       setPaymentTime(Timestamp v)    { this.paymentTime = v; }
    public String     getStatus()                    { return status; }
    public void       setStatus(String v)            { this.status = v; }
}
