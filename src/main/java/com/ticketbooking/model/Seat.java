package com.ticketbooking.model;

public class Seat {
    private int     seatId;
    private int     scheduleId;
    private String  seatNumber;
    private String  seatType;
    private boolean isBooked;

    public int     getSeatId()              { return seatId; }
    public void    setSeatId(int v)         { this.seatId = v; }
    public int     getScheduleId()          { return scheduleId; }
    public void    setScheduleId(int v)     { this.scheduleId = v; }
    public String  getSeatNumber()          { return seatNumber; }
    public void    setSeatNumber(String v)  { this.seatNumber = v; }
    public String  getSeatType()            { return seatType; }
    public void    setSeatType(String v)    { this.seatType = v; }
    public boolean isBooked()               { return isBooked; }
    public void    setBooked(boolean v)     { this.isBooked = v; }
}
