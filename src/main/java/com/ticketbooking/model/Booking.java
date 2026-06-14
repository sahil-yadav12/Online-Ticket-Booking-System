package com.ticketbooking.model;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class Booking {
    private int        bookingId;
    private int        userId;
    private int        scheduleId;
    private int        seatId;
    private Timestamp  bookingDate;
    private BigDecimal totalAmount;
    private String     status;         // CONFIRMED | CANCELLED | PENDING
    private String     paymentStatus;  // PAID | REFUNDED | PENDING
    private String     bookingRef;
    // Denormalised fields from JOIN
    private String     routeType;
    private String     source;
    private String     destination;
    private String     operator;
    private Timestamp  departureTime;
    private String     seatNumber;

    public int        getBookingId()                  { return bookingId; }
    public void       setBookingId(int v)             { this.bookingId = v; }
    public int        getUserId()                     { return userId; }
    public void       setUserId(int v)                { this.userId = v; }
    public int        getScheduleId()                 { return scheduleId; }
    public void       setScheduleId(int v)            { this.scheduleId = v; }
    public int        getSeatId()                     { return seatId; }
    public void       setSeatId(int v)                { this.seatId = v; }
    public Timestamp  getBookingDate()                { return bookingDate; }
    public void       setBookingDate(Timestamp v)     { this.bookingDate = v; }
    public BigDecimal getTotalAmount()                { return totalAmount; }
    public void       setTotalAmount(BigDecimal v)    { this.totalAmount = v; }
    public String     getStatus()                     { return status; }
    public void       setStatus(String v)             { this.status = v; }
    public String     getPaymentStatus()              { return paymentStatus; }
    public void       setPaymentStatus(String v)      { this.paymentStatus = v; }
    public String     getBookingRef()                 { return bookingRef; }
    public void       setBookingRef(String v)         { this.bookingRef = v; }
    public String     getRouteType()                  { return routeType; }
    public void       setRouteType(String v)          { this.routeType = v; }
    public String     getSource()                     { return source; }
    public void       setSource(String v)             { this.source = v; }
    public String     getDestination()                { return destination; }
    public void       setDestination(String v)        { this.destination = v; }
    public String     getOperator()                   { return operator; }
    public void       setOperator(String v)           { this.operator = v; }
    public Timestamp  getDepartureTime()              { return departureTime; }
    public void       setDepartureTime(Timestamp v)   { this.departureTime = v; }
    public String     getSeatNumber()                 { return seatNumber; }
    public void       setSeatNumber(String v)         { this.seatNumber = v; }
}
