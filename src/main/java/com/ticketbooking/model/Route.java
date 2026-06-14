package com.ticketbooking.model;

public class Route {
    private int    routeId;
    private String routeType;   // BUS | TRAIN | MOVIE
    private String source;
    private String destination;
    private String operator;

    public int    getRouteId()               { return routeId; }
    public void   setRouteId(int v)          { this.routeId = v; }
    public String getRouteType()             { return routeType; }
    public void   setRouteType(String v)     { this.routeType = v; }
    public String getSource()                { return source; }
    public void   setSource(String v)        { this.source = v; }
    public String getDestination()           { return destination; }
    public void   setDestination(String v)   { this.destination = v; }
    public String getOperator()              { return operator; }
    public void   setOperator(String v)      { this.operator = v; }
}
