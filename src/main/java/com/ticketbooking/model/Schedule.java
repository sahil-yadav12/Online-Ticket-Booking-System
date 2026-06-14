package com.ticketbooking.model;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class Schedule {
    private int        scheduleId;
    private int        routeId;
    private Timestamp  departureTime;
    private Timestamp  arrivalTime;
    private BigDecimal price;
    private int        totalSeats;
    private int        availableSeats;
    private String     status;
    // Denormalised fields from JOIN with routes table
    private String routeType;
    private String source;
    private String destination;
    private String operator;

    public int        getScheduleId()              { return scheduleId; }
    public void       setScheduleId(int v)         { this.scheduleId = v; }
    public int        getRouteId()                 { return routeId; }
    public void       setRouteId(int v)            { this.routeId = v; }
    public Timestamp  getDepartureTime()           { return departureTime; }
    public void       setDepartureTime(Timestamp v){ this.departureTime = v; }
    public Timestamp  getArrivalTime()             { return arrivalTime; }
    public void       setArrivalTime(Timestamp v)  { this.arrivalTime = v; }
    public BigDecimal getPrice()                   { return price; }
    public void       setPrice(BigDecimal v)       { this.price = v; }
    public int        getTotalSeats()              { return totalSeats; }
    public void       setTotalSeats(int v)         { this.totalSeats = v; }
    public int        getAvailableSeats()          { return availableSeats; }
    public void       setAvailableSeats(int v)     { this.availableSeats = v; }
    public String     getStatus()                  { return status; }
    public void       setStatus(String v)          { this.status = v; }
    public String     getRouteType()               { return routeType; }
    public void       setRouteType(String v)       { this.routeType = v; }
    public String     getSource()                  { return source; }
    public void       setSource(String v)          { this.source = v; }
    public String     getDestination()             { return destination; }
    public void       setDestination(String v)     { this.destination = v; }
    public String     getOperator()                { return operator; }
    public void       setOperator(String v)        { this.operator = v; }
}
